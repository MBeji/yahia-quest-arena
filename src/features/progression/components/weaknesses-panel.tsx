import { useState, type ReactNode } from "react";
import { Link, useNavigate } from "@tanstack/react-router";
import { BookOpen, Dumbbell, Minus, Target, TrendingDown, TrendingUp } from "lucide-react";

import { useI18n } from "@/lib/i18n";
import type { Locale } from "@/lib/i18n";
import type { WeaknessRow } from "@/shared/types/weakness";
import { getCompetencyExercises } from "../progression.server";

/**
 * « Tes points faibles » — étude 04, lot A2.1 (US-2, R-2).
 *
 * LE PANNEAU QUI NOMME L'ERREUR, ET CE QUI LE DISTINGUE DE SES VOISINS
 * ---------------------------------------------------------------------------
 * Le tableau de bord sait déjà dire deux choses proches et pourtant différentes :
 * la carte de compétences dit « comparaison de fractions : 41 % » — OÙ ça coince —
 * et la révision du jour dit quoi rejouer. Ce panneau-ci dit **ce que l'élève
 * croit à tort** : « tu additionnes les dénominateurs ». C'est la seule des trois
 * formulations qu'un enfant peut répéter à voix haute, et donc corriger.
 *
 * DEUX GARDES DE SINCÉRITÉ, HÉRITÉES DE LA CARTE DE COMPÉTENCES
 * ---------------------------------------------------------------------------
 * 1. **L'absence n'est pas un vide.** Sans erreur active, le panneau ne s'affiche
 *    pas du tout — pas d'encadré « rien à signaler », qui donnerait à un écran
 *    neuf l'allure d'un bulletin. C'est aussi l'état NORMAL aujourd'hui : seul
 *    `math` 9ᵉ est tagué, et il faut avoir joué pour qu'une erreur s'installe.
 * 2. **La flèche ne s'invente pas.** Le serveur rend `stable` tant que les deux
 *    fenêtres de 7 jours totalisent moins de trois occurrences ; ici on affiche
 *    alors un tiret, jamais une tendance. Une flèche sur deux points ment.
 *
 * Le tag n'est JAMAIS affiché (R-A1.2-1) : c'est un identifiant. La phrase vient
 * du registre, rendue dans les trois langues par le serveur — on met en langue
 * ici, comme partout ailleurs.
 */

function pickLabel(row: WeaknessRow, locale: Locale): string {
  return locale === "ar" ? row.label_ar : locale === "en" ? row.label_en : row.label_fr;
}

function TrendMark({
  trend,
  labels,
}: {
  trend: WeaknessRow["trend"];
  labels: Record<string, string>;
}) {
  if (trend === "improving") {
    return (
      <span
        className="text-success inline-flex items-center gap-1 text-xs"
        title={labels.improving}
      >
        <TrendingDown className="size-3" aria-hidden="true" />
        {labels.improving}
      </span>
    );
  }
  if (trend === "worsening") {
    return (
      <span
        className="text-destructive inline-flex items-center gap-1 text-xs"
        title={labels.worsening}
      >
        <TrendingUp className="size-3" aria-hidden="true" />
        {labels.worsening}
      </span>
    );
  }
  // `stable` couvre « pas assez de données » : un tiret, pas une flèche.
  return (
    <span className="text-muted-foreground inline-flex items-center gap-1 text-xs">
      <Minus className="size-3" aria-hidden="true" />
      {labels.stable}
    </span>
  );
}

export function WeaknessesPanel({
  weaknesses,
  renderPractice,
}: {
  weaknesses: WeaknessRow[];
  /**
   * Le geste d'entraînement, POSÉ PAR LA ROUTE (étude 11 lot 5).
   *
   * Quand la route le fournit, il REMPLACE le bouton « S'entraîner » ci-dessous
   * — il ne s'ajoute pas à lui. Deux boutons promettant la même chose
   * obligeraient l'élève à choisir entre deux mots qu'il ne peut pas
   * distinguer, et le produit n'a qu'UN chemin de remédiation (A12).
   *
   * Optionnel, et ça compte : sans slot, le panneau garde son propre bouton et
   * reste parfaitement utilisable. Il ne dépend pas du tuteur — une feature
   * n'en importe pas une autre (AGENTS.md), c'est la route qui compose, motif
   * `renderCoach` (dashboard) et `renderTutor` (écran de correction).
   */
  renderPractice?: (weakness: WeaknessRow) => ReactNode;
}) {
  const { t, locale } = useI18n();
  const navigate = useNavigate();
  const [training, setTraining] = useState<string | null>(null);

  // Garde 1 : rien à dire ⇒ rien à l'écran.
  if (weaknesses.length === 0) return null;

  const trendLabels = {
    improving: t.dashboard.weakSpotTrendImproving,
    worsening: t.dashboard.weakSpotTrendWorsening,
    stable: t.dashboard.weakSpotTrendStable,
  };

  /**
   * Le geste « S'entraîner » réutilise `get_exercises_for_competency` (é07 lot 4),
   * exactement comme le bouton de la correction riche (A12 / R-A1.2-6) : il n'y a
   * qu'UN chemin de remédiation dans le produit. Si la RPC ne rend rien, on ne
   * navigue pas — un bouton qui ne mène nulle part vaut mieux qu'une page d'erreur.
   */
  async function train(competency: string) {
    setTraining(competency);
    try {
      const exercises = await getCompetencyExercises({ data: { competency } });
      if (exercises[0]) {
        navigate({ to: "/quest/$exerciseId", params: { exerciseId: exercises[0].exercise_id } });
      }
    } finally {
      setTraining(null);
    }
  }

  return (
    <section
      data-testid="weaknesses-panel"
      className="border-border bg-surface-1 rounded-2xl border p-4"
    >
      <h2 className="font-display flex items-center gap-2 text-lg font-bold">
        <Target className="size-5" aria-hidden="true" />
        {t.dashboard.weakSpotsTitle}
      </h2>
      <p className="text-muted-foreground mt-1 text-xs">{t.dashboard.weakSpotsSubtitle}</p>

      <ul className="mt-3 space-y-2">
        {weaknesses.map((row) => (
          <li
            key={row.tag}
            data-testid="weakness-item"
            className="border-border/60 bg-surface-3 rounded-xl border p-3"
          >
            {/* La phrase de l'erreur, dans la langue de l'interface. `dir="auto"` :
                le registre est trilingue et l'arabe s'y mélange aux chiffres. */}
            <p dir="auto" className="text-sm font-medium">
              {pickLabel(row, locale)}
            </p>

            <div className="mt-1 flex flex-wrap items-center gap-3">
              <span className="text-muted-foreground text-xs">
                {t.dashboard.weakSpotOccurrences.replace("{n}", String(row.occurrences))}
              </span>
              <TrendMark trend={row.trend} labels={trendLabels} />
            </div>

            <div className="mt-2 flex flex-wrap items-center gap-2">
              {/* Le slot du tuteur d'abord quand la route le pose : il cible aussi
                  par le TAG, donc il fonctionne là où le bouton ci-dessous se
                  taisait faute de compétence déclarée.
                  Garde du repli : pas de compétence ⇒ pas de bouton. Proposer un
                  exercice au hasard serait pire que ne rien proposer (A12). */}
              {renderPractice
                ? renderPractice(row)
                : row.competency && (
                    <button
                      type="button"
                      data-testid="weakness-train"
                      disabled={training === row.competency}
                      onClick={() => void train(row.competency as string)}
                      className="border-border hover:bg-surface-2 inline-flex items-center gap-1 rounded-lg border px-2 py-1 text-xs font-bold transition disabled:opacity-50"
                    >
                      <Dumbbell className="size-3" aria-hidden="true" />
                      {t.dashboard.competencyTrainCta}
                    </button>
                  )}
              {row.chapter_id && (
                <Link
                  to="/lesson/$chapterId"
                  params={{ chapterId: row.chapter_id }}
                  data-testid="weakness-course"
                  className="border-border inline-flex items-center gap-1 rounded-lg border px-2 py-1 text-xs font-bold transition hover:bg-surface-2"
                >
                  <BookOpen className="size-3" aria-hidden="true" />
                  {t.dashboard.weakSpotCourseCta}
                </Link>
              )}
            </div>
          </li>
        ))}
      </ul>
    </section>
  );
}
