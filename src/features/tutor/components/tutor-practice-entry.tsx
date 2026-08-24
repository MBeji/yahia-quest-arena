// « ENTRAÎNE-MOI LÀ-DESSUS » — étude 11 lot 5 (US-11, US-12).
//
// OÙ IL S'INSÈRE, ET POURQUOI IL REMPLACE UN BOUTON AU LIEU D'EN AJOUTER UN
// ---------------------------------------------------------------------------
// Dans une ligne de « Tes points faibles » (é04 A2.1), à la place du bouton
// « S'entraîner » que le panneau rend lui-même. Ce n'est pas un doublon évité
// par élégance : le produit n'a qu'UN chemin de remédiation (A12 / R-A1.2-6), et
// deux boutons côte à côte qui promettent la même chose obligeraient l'élève à
// choisir entre deux mots qu'il ne peut pas distinguer.
//
// Ce que celui-ci sait faire en plus de son prédécesseur :
//   * il cible par le TAG autant que par la compétence — donc il fonctionne
//     aussi sur une erreur SANS compétence déclarée, où l'ancien bouton ne
//     s'affichait tout simplement pas ;
//   * il sait que le stock peut être vide, et bascule alors vers des questions
//     ÉCRITES pour l'occasion (Q-8) ;
//   * il avoue quand il n'a rien — au lieu de ne pas naviguer, ce que faisait
//     l'ancien quand la RPC rendait une liste vide (un bouton qui ne fait rien).
//
// LE COMPOSANT VIT DANS `features/tutor`, ET `progression` NE L'IMPORTE JAMAIS
// ---------------------------------------------------------------------------
// C'est la ROUTE qui compose, par le slot `renderPractice` — motif `renderCoach`
// (dashboard) et `renderTutor` (écran de correction). Une feature n'en importe
// pas une autre (AGENTS.md).
//
// LA FORGE EST ATTEINTE PAR UNE URL, PAS PAR UN IMPORT
// ---------------------------------------------------------------------------
// `kind: "forge"` se traduit en `/forge?chapitre=<uuid>`. Le tuteur ne connaît
// donc ni `forgeQuiz`, ni son schéma, ni ses filtres : le serveur a décidé, cet
// écran navigue. C'est aussi ce qui fait que la Forge garde SES propres gardes —
// la route vérifie l'accord parental et `callAi` la dépense, comme pour une
// visite directe depuis le tableau de bord.

import { useState } from "react";
import { useNavigate } from "@tanstack/react-router";
import { Dumbbell } from "lucide-react";
import { useServerFn } from "@tanstack/react-start";

import { useT } from "@/lib/i18n";
import type { WeaknessRow } from "@/shared/types/weakness";
import { startTargetedPractice } from "../tutor.practice.server";

/**
 * Rien à afficher tant que l'élève n'a pas cliqué : ce composant est rendu une
 * fois par point faible (cinq au plus), et un état de chargement par ligne
 * transformerait le panneau en sapin de Noël.
 */
type EntryState =
  | { kind: "idle" }
  | { kind: "loading" }
  /** Un refus, une absence : une phrase sous le bouton, jamais une exception. */
  | { kind: "message"; text: string };

/**
 * R-1 — les refus de la porte, dits en langage d'élève. Les clés existent déjà
 * (lot 1) : on les réutilise plutôt que d'en écrire des jumelles qui
 * divergeraient. Un code qu'on ne sait pas traduire rend `null` — le composant
 * se tait alors, il n'affiche jamais un identifiant technique (R-A1.2-3).
 */
function lockedCopy(reason: string, t: ReturnType<typeof useT>): string | null {
  if (reason === "ACTIVE_DUNGEON") return t.tutor.lockedDungeon;
  if (reason === "ACTIVE_DUEL") return t.tutor.lockedDuel;
  if (reason === "ACTIVE_SESSION") return t.tutor.lockedSession;
  return null;
}

export function TutorPracticeEntry({ weakness }: { weakness: WeaknessRow }) {
  const t = useT();
  const navigate = useNavigate();
  const start = useServerFn(startTargetedPractice);
  const [state, setState] = useState<EntryState>({ kind: "idle" });

  async function run() {
    setState({ kind: "loading" });
    try {
      const result = await start({
        data: {
          tag: weakness.tag,
          competency: weakness.competency,
          chapterId: weakness.chapter_id,
        },
      });

      if (result.kind === "exercises") {
        const first = result.items[0];
        if (first) {
          // `onTarget: false` ⇒ le matériel est du VOISINAGE, pas de l'erreur.
          // On l'annonce avant de partir : la phrase reste à l'écran le temps de
          // la navigation, et l'élève sait sur quoi il va tomber.
          if (!result.onTarget) setState({ kind: "message", text: t.tutor.practice.offTargetHint });
          void navigate({ to: "/quest/$exerciseId", params: { exerciseId: first.exerciseId } });
          return;
        }
        // Une liste vide malgré `kind: "exercises"` ne devrait pas arriver — le
        // serveur bascule sur `none` dans ce cas. On ne navigue pas vers `undefined`.
        setState({ kind: "message", text: t.tutor.practice.noMaterial });
        return;
      }

      if (result.kind === "forge") {
        setState({ kind: "message", text: t.tutor.practice.forgingHint });
        void navigate({ to: "/forge", search: { chapitre: result.chapterId } });
        return;
      }

      if (result.kind === "locked") {
        setState({
          kind: "message",
          text: lockedCopy(result.reason, t) ?? t.tutor.practice.noMaterial,
        });
        return;
      }

      setState({
        kind: "message",
        text:
          result.reason === "no-chapter" ? t.tutor.practice.noChapter : t.tutor.practice.noMaterial,
      });
    } catch {
      // R-15 : même une panne réseau est un ÉTAT. Le panneau reste utilisable,
      // les autres points faibles gardent leur bouton.
      setState({ kind: "message", text: t.tutor.practice.noMaterial });
    }
  }

  return (
    <div className="flex flex-col gap-1">
      <button
        type="button"
        data-testid="tutor-practice-entry"
        disabled={state.kind === "loading"}
        onClick={() => void run()}
        className="border-border hover:bg-surface-2 inline-flex items-center gap-1 self-start rounded-lg border px-2 py-1 text-xs font-bold transition disabled:opacity-50"
      >
        <Dumbbell className="size-3" aria-hidden="true" />
        {state.kind === "loading" ? t.tutor.practice.loading : t.tutor.practice.cta}
      </button>

      {state.kind === "message" && (
        <p
          data-testid="tutor-practice-message"
          dir="auto"
          role="status"
          className="text-muted-foreground text-xs"
        >
          {state.text}
        </p>
      )}
    </div>
  );
}
