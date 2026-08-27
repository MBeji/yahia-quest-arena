// Le panneau « Demander au Prof » — étude 11 lot 1, US-1 et US-2.
//
// OÙ IL S'INSÈRE, ET POURQUOI PAS AILLEURS
// ---------------------------------------------------------------------------
// Sous une question RATÉE de l'écran de correction, à côté du bloc « erreur
// nommée » livré par é04 A1.2b. Ce n'est pas un choix d'esthétique : A1.2b avait
// posé l'emplacement en toutes lettres (D-A1.2-5) — « le déterministe décide
// quel tag, quel chapitre ; le LLM rédigera la phrase plus tard. Si A1.2b est
// bien fait, é11 lot 1 remplace un contenu, il ne refond pas un écran. »
//
// Le composant vit dans `features/tutor` et la feature `quest` ne l'importe
// JAMAIS : c'est la ROUTE qui compose les deux (AGENTS.md — une feature n'en
// importe pas une autre). `QuestReviewList` reçoit un slot, pas une dépendance.
//
// R-15 : aucun état d'erreur brute. Chaque refus de `callAi()` retombe sur une
// phrase que l'enfant peut lire, et le bloc de correction canonique reste
// affiché derrière — il est le PLANCHER, jamais remplacé.

import { useState } from "react";
import { useServerFn } from "@tanstack/react-start";
import { CheckCircle2, GraduationCap, RefreshCw, ThumbsDown, ThumbsUp } from "lucide-react";

import { Button } from "@/components/ui/button";
import { useT } from "@/lib/i18n";
import {
  escalateTutorThread,
  explainMistake,
  getTutorMiniCheck,
  getTutorUnderstandingSignal,
  rateTutorMessage,
  submitTutorMiniCheck,
  type TutorExplanation,
  type TutorMiniCheck,
} from "../tutor.server";
import type { TutorEscalationStep } from "../escalation";
import { tutorLockedKey } from "../locked";

type PanelState =
  | { kind: "idle" }
  | { kind: "loading" }
  | { kind: "answer"; value: Extract<TutorExplanation, { ok: true }> }
  | { kind: "degraded"; code: string };

/**
 * Les états du MINI-CHECK (lot 4). Volontairement distincts de `PanelState` :
 * le mini-check vit SOUS l'explication et ne la remplace jamais, donc son cycle
 * de vie est indépendant. Les fondre en un seul état aurait fait disparaître
 * l'explication au moment précis où l'élève en a le plus besoin — pendant qu'il
 * répond à la question de vérification.
 */
type MiniCheckState =
  | { kind: "idle" }
  | { kind: "loading" }
  | { kind: "asking"; check: Extract<TutorMiniCheck, { ok: true }> }
  /** Aucun candidat, ou une correction illisible : on se tait poliment (R-15). */
  | { kind: "unavailable" }
  | {
      kind: "graded";
      correct: boolean;
      explanation: string | null;
      /** La marche proposée en cas d'échec. `null` quand c'est réussi. */
      step: TutorEscalationStep | null;
    };

/**
 * R-1 — les refus de la PORTE, dits en langage d'élève. Rend `null` pour tout ce
 * qui n'est pas un refus de porte : un code qu'on ne sait pas traduire ne
 * s'affiche pas, il fait disparaître le tuteur (R-A1.2-3).
 *
 * La table des codes est dans `../locked` : le chat de chapitre doit la même
 * phrase au même refus, et deux copies auraient divergé.
 */
function lockedCopy(reason: string, t: ReturnType<typeof useT>): string | null {
  const key = tutorLockedKey(reason);
  return key ? t.tutor[key] : null;
}

/** R-15 — un code technique devient une phrase d'enfant. Jamais l'inverse. */
function degradedCopy(code: string, t: ReturnType<typeof useT>) {
  if (code === "AI_BUDGET_REACHED" || code === "AI_NO_ENERGY" || code === "NO_ENERGY") {
    return { title: t.tutor.noEnergyTitle, body: t.tutor.noEnergyBody };
  }
  if (code === "AI_MODE_OFF" || code === "AI_NOT_ACTIVATED") {
    return { title: t.tutor.offTitle, body: t.tutor.offBody };
  }
  return { title: t.tutor.pausedTitle, body: t.tutor.pausedBody };
}

export function TutorPanel({
  questionId,
  /**
   * R-1 — la porte, si l'appelant la connaît déjà. ABSENTE, le bouton s'affiche
   * et c'est le serveur qui tranche : `explainMistake` re-vérifie `can_use_tutor`
   * et rend la raison, que l'écran traduit en phrase d'élève. Un aller-retour de
   * moins, et le juge reste le même — l'UI ne fait toujours que refléter.
   */
  availability,
}: {
  questionId: string;
  availability?: { allowed: boolean; reason: string };
}) {
  const t = useT();
  const ask = useServerFn(explainMistake);
  const rate = useServerFn(rateTutorMessage);
  const [state, setState] = useState<PanelState>({ kind: "idle" });
  const [rated, setRated] = useState(false);

  // R-1 : porte fermée ⇒ on dit POURQUOI, en langage d'élève, et on n'affiche
  // aucun bouton. Une porte fermée sans explication ressemble à une panne.
  if (availability && !availability.allowed) {
    const locked = lockedCopy(availability.reason, t);
    if (!locked) return null;
    return <p className="text-muted-foreground mt-2 text-xs">{locked}</p>;
  }

  if (state.kind === "degraded") {
    const locked = lockedCopy(state.code, t);
    if (locked) return <p className="text-muted-foreground mt-2 text-xs">{locked}</p>;
  }

  async function run(again: boolean) {
    setState({ kind: "loading" });
    setRated(false);
    const result = await ask({ data: { questionId, again } });
    setState(
      result.ok ? { kind: "answer", value: result } : { kind: "degraded", code: result.code },
    );
  }

  async function sendRating(rating: 1 | -1) {
    if (state.kind !== "answer") return;
    setRated(true);
    await rate({
      data: { threadId: state.value.threadId, messageIx: state.value.messageIx, rating },
    });
    // R-17 : le 👎 propose immédiatement la récupération — une reformulation,
    // pas un formulaire. L'élève est venu comprendre, pas donner son avis.
    if (rating === -1 && state.value.canReformulate) void run(true);
  }

  if (state.kind === "idle") {
    return (
      <Button
        type="button"
        variant="outline"
        size="sm"
        className="mt-2"
        onClick={() => void run(false)}
      >
        <GraduationCap className="size-4" aria-hidden="true" />
        {t.tutor.ask}
      </Button>
    );
  }

  if (state.kind === "loading") {
    return (
      <p className="text-muted-foreground mt-2 text-xs" role="status">
        {t.tutor.thinking}
      </p>
    );
  }

  if (state.kind === "degraded") {
    const copy = degradedCopy(state.code, t);
    return (
      <div className="border-border bg-muted/40 mt-2 rounded-lg border p-3">
        <p className="text-sm font-medium">{copy.title}</p>
        <p className="text-muted-foreground text-xs">{copy.body}</p>
      </div>
    );
  }

  const answer = state.value;
  return (
    <div className="border-border bg-muted/40 mt-2 rounded-lg border p-3">
      <div className="mb-1 flex items-center gap-2">
        <GraduationCap className="size-4" aria-hidden="true" />
        <span className="text-sm font-medium">{t.tutor.panelTitle}</span>
        {answer.cached ? (
          <span className="text-muted-foreground text-[0.7rem]">{t.tutor.fromCache}</span>
        ) : null}
      </div>

      {/*
        La sortie du modèle est du markdown SIMPLE et déjà validée (§3.4 : ni
        HTML, ni LaTeX, ni URL). On la rend en texte préservant les retours à la
        ligne plutôt qu'en HTML : il n'y a rien à interpréter, et ne pas passer
        par `dangerouslySetInnerHTML` retire du système une surface entière.

        `dir="auto"` et non `dir` calculé : la langue de SORTIE est celle de la
        matière (R-3), qui peut différer de celle de l'interface. Le navigateur
        lit le premier caractère fort et tranche mieux qu'une prop héritée.
      */}
      <p dir="auto" className="text-sm whitespace-pre-wrap">
        {answer.body}
      </p>

      <div className="mt-2 flex flex-wrap items-center gap-2">
        {answer.canReformulate ? (
          <Button type="button" variant="ghost" size="sm" onClick={() => void run(true)}>
            <RefreshCw className="size-4" aria-hidden="true" />
            {t.tutor.again}
          </Button>
        ) : (
          <span className="text-muted-foreground text-xs">{t.tutor.againExhausted}</span>
        )}

        {rated ? (
          <span className="text-muted-foreground text-xs">{t.tutor.rated}</span>
        ) : (
          <>
            <Button
              type="button"
              variant="ghost"
              size="sm"
              aria-label={t.tutor.helpful}
              onClick={() => void sendRating(1)}
            >
              <ThumbsUp className="size-4" aria-hidden="true" />
            </Button>
            <Button
              type="button"
              variant="ghost"
              size="sm"
              aria-label={t.tutor.notHelpful}
              onClick={() => void sendRating(-1)}
            >
              <ThumbsDown className="size-4" aria-hidden="true" />
            </Button>
          </>
        )}
      </div>

      {/* US-4 — « Vérifions ensemble », SOUS l'explication et jamais à sa place.
          Le fil est celui que l'explication vient d'ouvrir : c'est lui que
          l'escalade fera monter d'une marche (R-8). */}
      <TutorMiniCheckBlock questionId={questionId} threadId={answer.threadId} />
    </div>
  );
}

/**
 * LE MINI-CHECK ET SON ESCALADE — étude 11 lot 4, US-4 et R-8.
 *
 * Rendu SOUS l'explication, jamais à sa place : l'explication reste le plancher
 * (R-15). Trois états seulement s'ajoutent au panneau — la question servie, sa
 * correction, et la marche proposée en cas d'échec.
 *
 * R-11, à l'écran comme en base : aucune célébration de récompense. « C'est
 * ça ! » et rien d'autre — pas de +XP, pas de pièce, pas de confetti. Un enfant
 * qui voit une récompense au mini-check apprend à s'y tromper exprès pour en
 * refaire un, et le signal R-8 devient du bruit.
 */
function TutorMiniCheckBlock({
  questionId,
  threadId,
}: {
  questionId: string;
  /** Le fil ouvert par l'explication : c'est lui qu'on escalade. */
  threadId: string;
}) {
  const t = useT();
  const fetchCheck = useServerFn(getTutorMiniCheck);
  const submitCheck = useServerFn(submitTutorMiniCheck);
  const readSignal = useServerFn(getTutorUnderstandingSignal);
  const escalate = useServerFn(escalateTutorThread);
  const [state, setState] = useState<MiniCheckState>({ kind: "idle" });

  async function start() {
    setState({ kind: "loading" });
    const result = await fetchCheck({ data: { questionId } });
    // R-15 : un vivier vide n'est pas une panne à annoncer. On dit une phrase
    // neutre et on rend la main au chapitre.
    setState(result.ok ? { kind: "asking", check: result } : { kind: "unavailable" });
  }

  async function answer(choice: string) {
    if (state.kind !== "asking") return;
    const check = state.check;
    setState({ kind: "loading" });
    const graded = await submitCheck({
      data: { questionId: check.questionId, choice },
    });
    if (!graded.ok) {
      setState({ kind: "unavailable" });
      return;
    }
    if (graded.correct) {
      setState({
        kind: "graded",
        correct: true,
        explanation: graded.explanation,
        step: null,
      });
      return;
    }

    // ÉCHEC — et c'est ici que R-8 décide, pas l'écran. On demande d'abord au
    // serveur si un signal objectif est levé : rater UNE fois ne justifie pas
    // qu'on remonte au prérequis, encore moins qu'on prévienne les parents.
    // Sans signal, on reste sur la marche la plus douce, qui est le bouton
    // « Explique autrement » déjà présent au-dessus.
    const tag = graded.tag ?? check.tag;
    if (!tag) {
      setState({
        kind: "graded",
        correct: false,
        explanation: graded.explanation,
        step: "reteach",
      });
      return;
    }
    const signal = await readSignal({ data: { tag } });
    if (signal.level <= 0) {
      setState({
        kind: "graded",
        correct: false,
        explanation: graded.explanation,
        step: "reteach",
      });
      return;
    }
    const next = await escalate({ data: { threadId } });
    setState({
      kind: "graded",
      correct: false,
      explanation: graded.explanation,
      step: next?.step ?? "reteach",
    });
  }

  if (state.kind === "idle") {
    return (
      <Button
        type="button"
        variant="ghost"
        size="sm"
        className="mt-2"
        data-testid="tutor-minicheck-start"
        onClick={() => void start()}
      >
        <CheckCircle2 className="size-4" aria-hidden="true" />
        {t.tutor.miniCheck.start}
      </Button>
    );
  }

  if (state.kind === "loading") {
    return (
      <p className="text-muted-foreground mt-2 text-xs" role="status">
        {t.tutor.miniCheck.loading}
      </p>
    );
  }

  if (state.kind === "unavailable") {
    return (
      <p className="text-muted-foreground mt-2 text-xs" data-testid="tutor-minicheck-unavailable">
        {t.tutor.miniCheck.unavailable}
      </p>
    );
  }

  if (state.kind === "asking") {
    return (
      <div
        className="border-border bg-surface-3 mt-2 rounded-lg border p-3"
        data-testid="tutor-minicheck"
      >
        <p className="text-sm font-medium">{t.tutor.miniCheck.title}</p>
        {/* `dir="auto"` : la langue de SORTIE est celle de la MATIÈRE (R-3), qui
            peut différer de celle de l'interface. Le navigateur lit le premier
            caractère fort et tranche mieux qu'une prop héritée. */}
        <p dir="auto" className="mt-1 text-sm">
          {state.check.prompt}
        </p>
        <div className="mt-2 flex flex-col gap-1">
          {state.check.options.map((option) => (
            <Button
              key={option.id}
              type="button"
              variant="outline"
              size="sm"
              dir="auto"
              className="justify-start text-start"
              onClick={() => void answer(option.id)}
            >
              {option.text}
            </Button>
          ))}
        </div>
      </div>
    );
  }

  const escalationCopy = state.step ? t.tutor.escalation[state.step] : null;
  return (
    <div
      className="border-border bg-surface-3 mt-2 rounded-lg border p-3"
      data-testid="tutor-minicheck-result"
      role="status"
    >
      <p className="text-sm font-medium">
        {state.correct ? t.tutor.miniCheck.correctTitle : t.tutor.miniCheck.wrongTitle}
      </p>
      <p className="text-muted-foreground text-xs">
        {state.correct ? t.tutor.miniCheck.correctBody : t.tutor.miniCheck.wrongBody}
      </p>
      {state.explanation ? (
        <p dir="auto" className="mt-2 text-sm whitespace-pre-wrap">
          {state.explanation}
        </p>
      ) : null}
      {escalationCopy ? (
        <p className="mt-2 text-sm" data-testid="tutor-escalation">
          {escalationCopy}
        </p>
      ) : null}
    </div>
  );
}
