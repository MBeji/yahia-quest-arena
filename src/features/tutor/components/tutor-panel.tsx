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
import { GraduationCap, RefreshCw, ThumbsDown, ThumbsUp } from "lucide-react";

import { Button } from "@/components/ui/button";
import { useT } from "@/lib/i18n";
import { explainMistake, rateTutorMessage, type TutorExplanation } from "../tutor.server";

type PanelState =
  | { kind: "idle" }
  | { kind: "loading" }
  | { kind: "answer"; value: Extract<TutorExplanation, { ok: true }> }
  | { kind: "degraded"; code: string };

/**
 * R-1 — les refus de la PORTE, dits en langage d'élève. Rend `null` pour tout ce
 * qui n'est pas un refus de porte : un code qu'on ne sait pas traduire ne
 * s'affiche pas, il fait disparaître le tuteur (R-A1.2-3).
 */
function lockedCopy(reason: string, t: ReturnType<typeof useT>): string | null {
  if (reason === "ACTIVE_SESSION") return t.tutor.lockedSession;
  if (reason === "ACTIVE_DUNGEON") return t.tutor.lockedDungeon;
  if (reason === "ACTIVE_DUEL") return t.tutor.lockedDuel;
  if (reason === "NOT_ATTEMPTED") return t.tutor.lockedNotAttempted;
  return null;
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
    </div>
  );
}
