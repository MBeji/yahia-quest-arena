// LE CHAT DU CHAPITRE — étude 11 lot 3 (US-8 à US-10).
//
// CE QUE CET ÉCRAN NE DÉCIDE PAS
// ---------------------------------------------------------------------------
// Rien. Ni qui a le droit de parler (R-1, `can_use_tutor`), ni qui a le droit
// d'écrire librement (Q-6, la bande d'âge côté serveur), ni ce qui est hors
// sujet (R-6), ni ce qui est trop long (R-5). Il DEMANDE, il REFLÈTE. La route
// `/api/tutor/stream` re-vérifie chacune de ces gardes de son côté — un client
// modifié ne contourne rien.
//
// Le bornage local des 300 caractères est donc une COURTOISIE (l'élève voit son
// compteur), pas une sécurité : la même borne est appliquée côté serveur, et
// c'est celle-là qui compte.
//
// POURQUOI UN `fetch` ET PAS UNE SERVER FN
// ---------------------------------------------------------------------------
// Une server fn rend une valeur ; ici on lit un FLUX au fil de l'eau, pour que
// l'enfant voie la réponse s'écrire au lieu d'attendre un rond qui tourne
// (RISK-6 : le TTFB est ce qui rend l'attente supportable). Le jeton posé est le
// MÊME que celui des server fns, obtenu par la MÊME fonction — une seconde
// lecture de session rejouerait la panne de rafraîchissement du 2026-08-18.

import { useEffect, useRef, useState } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { GraduationCap, Send } from "lucide-react";

import { Button } from "@/components/ui/button";
import { useT } from "@/lib/i18n";
import { TUTOR_FREE_TEXT_MAX } from "@/shared/constants/ai";
import { resolveAccessToken } from "@/shared/integrations/supabase/auth-attacher";
import { getTutorChatEntry } from "../tutor.server";
import type { TutorChatIntent } from "../chat";
import { TUTOR_ENERGY_QUERY_KEY } from "../energy";
import { TutorEnergyMeter } from "./tutor-energy";

type Turn = { role: "student" | "tutor"; content: string };

/** Les codes de refus que l'écran sait dire en langage d'élève. Le reste disparaît. */
function refusalCopy(code: string, t: ReturnType<typeof useT>): string | null {
  if (code === "FREE_TEXT_TOO_LONG") return t.tutor.chat.tooLong;
  if (code === "FREE_TEXT_URL") return t.tutor.chat.noLinks;
  if (code === "RATE_LIMITED") return t.tutor.chat.rateLimited;
  if (code === "AI_OUTPUT_REJECTED") return t.tutor.chat.outputRejected;
  if (code === "AI_BUDGET_REACHED" || code === "AI_ENERGY_SPENT") return t.tutor.noEnergyBody;
  if (code === "AI_MODE_OFF" || code === "AI_NOT_ACTIVATED") return t.tutor.offBody;
  return t.tutor.pausedBody;
}

export function TutorChatPanel({
  chapterId,
  defaultOpen = false,
}: {
  chapterId: string;
  /**
   * Le panneau s'ouvre-t-il déplié ? La bulle IA globale amène l'élève sur ce
   * chapitre POUR discuter (`?chat=1`) — le laisser replié lui demanderait un
   * second clic pour la chose qu'il vient de demander.
   */
  defaultOpen?: boolean;
}) {
  const t = useT();
  const queryClient = useQueryClient();
  const loadEntry = useServerFn(getTutorChatEntry);
  const { data: entry } = useQuery({
    queryKey: ["tutor-chat-entry", chapterId],
    queryFn: () => loadEntry({ data: { chapterId } }),
    staleTime: 60_000,
  });

  const [open, setOpen] = useState(defaultOpen);
  const [turns, setTurns] = useState<Turn[]>([]);
  const [draft, setDraft] = useState("");
  const [streaming, setStreaming] = useState(false);
  const [refusal, setRefusal] = useState<string | null>(null);
  const liveRef = useRef<HTMLDivElement>(null);

  // Le flux fait grandir la dernière bulle : on garde le bas visible, sinon la
  // réponse s'écrit hors de l'écran sur un téléphone.
  useEffect(() => {
    liveRef.current?.scrollIntoView({ block: "end" });
  }, [turns]);

  // R-1 : porte fermée ⇒ aucune surface. Pas de bouton grisé, pas de « bientôt ».
  if (!entry?.allowed) return null;

  async function ask(intent: TutorChatIntent, freeText?: string) {
    setRefusal(null);
    setStreaming(true);
    if (freeText) setTurns((prev) => [...prev, { role: "student", content: freeText }]);
    setTurns((prev) => [...prev, { role: "tutor", content: "" }]);

    try {
      const token = await resolveAccessToken();
      const response = await fetch("/api/tutor/stream", {
        method: "POST",
        headers: {
          "content-type": "application/json",
          ...(token ? { Authorization: `Bearer ${token}` } : {}),
        },
        body: JSON.stringify({ chapterId, intent, freeText }),
      });

      if (!response.ok || !response.body) {
        setRefusal(refusalCopy("AI_UNKNOWN", t));
        setTurns((prev) => prev.slice(0, -1));
        return;
      }

      const reader = response.body.getReader();
      const decoder = new TextDecoder();
      let buffer = "";

      for (;;) {
        const { done, value } = await reader.read();
        if (done) break;
        buffer += decoder.decode(value, { stream: true });

        // Les trames SSE sont séparées par une ligne vide. On ne consomme que
        // les trames COMPLÈTES : un `data:` coupé en deux lectures TCP serait
        // du JSON invalide, et c'est le bug classique de tout lecteur SSE écrit
        // à la main.
        const frames = buffer.split("\n\n");
        buffer = frames.pop() ?? "";

        for (const frame of frames) {
          const event = /^event: (.+)$/m.exec(frame)?.[1];
          const payload = /^data: (.+)$/m.exec(frame)?.[1];
          if (!event || !payload) continue;
          const data = JSON.parse(payload) as { text?: string; code?: string };

          if (event === "token" && data.text) {
            setTurns((prev) => {
              const next = [...prev];
              const last = next[next.length - 1];
              if (last?.role === "tutor")
                next[next.length - 1] = { ...last, content: last.content + data.text };
              return next;
            });
          }

          if (event === "error") {
            setRefusal(refusalCopy(data.code ?? "AI_UNKNOWN", t));
            // Une bulle vide n'a rien à dire : on la retire plutôt que de
            // laisser un blanc sous le nom du professeur.
            setTurns((prev) => (prev[prev.length - 1]?.content ? prev : prev.slice(0, -1)));
          }
        }
      }
    } catch {
      setRefusal(refusalCopy("AI_UNKNOWN", t));
      setTurns((prev) => (prev[prev.length - 1]?.content ? prev : prev.slice(0, -1)));
    } finally {
      setStreaming(false);
      // Le flux vient de dépenser de l'énergie (ou de se la voir refuser) : la
      // jauge juste au-dessus doit suivre. Dans le `finally` et non dans la
      // branche heureuse, parce qu'un refus `AI_ENERGY_SPENT` est PRÉCISÉMENT
      // le moment où le chiffre affiché est faux. Sans cette invalidation,
      // `staleTime` le laisserait mentir une minute entière — pile la minute où
      // l'élève regarde le compteur pour comprendre ce qui vient de se passer.
      void queryClient.invalidateQueries({ queryKey: TUTOR_ENERGY_QUERY_KEY });
    }
  }

  if (!open) {
    return (
      <Button type="button" variant="outline" size="sm" onClick={() => setOpen(true)}>
        <GraduationCap className="size-4" aria-hidden="true" />
        {t.tutor.chat.open}
      </Button>
    );
  }

  return (
    <section className="border-border bg-surface-2 mt-4 rounded-2xl border p-4">
      <div className="mb-3 flex items-center gap-2">
        <GraduationCap className="size-4 text-[color:var(--gold)]" aria-hidden="true" />
        <h3 className="text-sm font-bold">{t.tutor.chat.title}</h3>
      </div>

      {/* LE COMPTEUR D'ÉNERGIE (é11 lot 7) — ici, et à un seul endroit.
          C'est LE panneau qui dépense : chaque message coûte, et un enfant doit
          voir sa réserve baisser au moment où il la dépense, pas sur un autre
          écran une heure plus tard.

          Pourquoi PAS dans `TutorPanel` (l'écran de correction) : celui-ci est
          rendu UNE FOIS PAR QUESTION RATÉE. La même jauge y apparaîtrait cinq
          fois sur une correction à cinq erreurs — cinq fois le même chiffre, et
          cinq boutons d'échange pour un seul indice. Le panneau de chat, lui,
          est unique par page et n'existe que pour un élève connecté qui l'a
          ouvert : aucune lecture n'est faite pour qui ne s'en sert pas.

          D-14 : le compteur est une MÉCANIQUE DE JEU. Il n'annonce aucune autre
          porte que l'échange d'un indice gagné en jouant. */}
      <TutorEnergyMeter />

      <div className="space-y-3">
        {turns.length === 0 ? (
          <p className="text-muted-foreground text-xs">{t.tutor.chat.empty}</p>
        ) : (
          turns.map((turn, i) => (
            <div key={i} className="text-sm">
              <span className="text-muted-foreground text-xs font-semibold">
                {turn.role === "student" ? t.tutor.chat.you : t.tutor.panelTitle}
              </span>
              {/*
                `dir="auto"` : la réponse arrive dans la langue de la MATIÈRE,
                qui peut différer de celle de l'interface (R-3). Le navigateur
                lit le premier caractère fort et tranche mieux qu'une prop
                héritée. Le texte est du markdown simple déjà validé (§3.4 :
                ni HTML, ni LaTeX, ni URL), rendu en clair — rien à interpréter.
              */}
              <p dir="auto" className="whitespace-pre-wrap">
                {turn.content}
              </p>
            </div>
          ))
        )}
        <div ref={liveRef} />
      </div>

      {refusal ? <p className="text-muted-foreground mt-3 text-xs">{refusal}</p> : null}

      <div className="mt-4 flex flex-wrap gap-2">
        <Button
          type="button"
          variant="ghost"
          size="sm"
          disabled={streaming}
          onClick={() => void ask("explain_lesson")}
        >
          {t.tutor.chat.intentExplain}
        </Button>
        <Button
          type="button"
          variant="ghost"
          size="sm"
          disabled={streaming}
          onClick={() => void ask("example")}
        >
          {t.tutor.chat.intentExample}
        </Button>
        <Button
          type="button"
          variant="ghost"
          size="sm"
          disabled={streaming}
          onClick={() => void ask("summarize")}
        >
          {t.tutor.chat.intentSummarize}
        </Button>
      </div>

      {/* Q-6 : le champ libre n'existe pas en primaire, et c'est le SERVEUR qui
          l'a dit — l'écran ne fait que ne pas le rendre. */}
      {entry.freeText ? (
        <form
          className="mt-3 flex items-end gap-2"
          onSubmit={(e) => {
            e.preventDefault();
            const text = draft.trim();
            if (!text || streaming) return;
            setDraft("");
            void ask("free", text);
          }}
        >
          <label className="flex-1">
            <span className="sr-only">{t.tutor.chat.placeholder}</span>
            <textarea
              value={draft}
              onChange={(e) => setDraft(e.target.value.slice(0, TUTOR_FREE_TEXT_MAX))}
              placeholder={t.tutor.chat.placeholder}
              rows={2}
              maxLength={TUTOR_FREE_TEXT_MAX}
              className="border-border bg-background w-full resize-none rounded-xl border p-2 text-sm"
            />
          </label>
          <Button type="submit" size="sm" disabled={streaming || draft.trim().length === 0}>
            <Send className="size-4" aria-hidden="true" />
            {t.tutor.chat.send}
          </Button>
        </form>
      ) : null}

      {streaming ? (
        <p className="text-muted-foreground mt-2 text-xs" role="status">
          {t.tutor.thinking}
        </p>
      ) : null}
    </section>
  );
}
