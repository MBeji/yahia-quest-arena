import { useState } from "react";
import { useNavigate } from "@tanstack/react-router";
import { Compass, Dumbbell, Minus, TrendingDown, TrendingUp } from "lucide-react";

import { useI18n } from "@/lib/i18n";
import type { Locale } from "@/lib/i18n";
import type { CompetencyBlocker, CompetencyMasteryRow } from "@/shared/types/competency";
import { getCompetencyExercises } from "../progression.server";

/**
 * « Carte de compétences » — étude 07, lot 4 (US-1, US-2, R-5, R-6).
 *
 * Le panneau qui répond à « où j'en suis, VRAIMENT ». La hiérarchie du catalogue sait dire
 * « Math 72 % » ; la carte dit « fractions 95 %, comparaison de fractions 41 % » — et, sous
 * une compétence en échec, « ce qui te bloque » : les prérequis faibles qui l'expliquent (R-5).
 *
 * Le serveur ne rend que des FAITS (maîtrise, tentatives, réussite récente, libellés dans les
 * trois langues). Ici on met en langue, on groupe par matière puis domaine, et on compose la
 * tendance — un score fabriqué en SQL serait le même pour tout le monde, une flèche décidée en
 * SQL parlerait une seule langue.
 *
 * Deux gardes de sincérité : sous cinq tentatives, on affiche « en cours d'évaluation » et
 * JAMAIS le 50 de départ comme un vrai score (Q-2 / RISK-2) ; et l'état vide est une invitation,
 * pas un reproche — on ne connaît pas encore l'élève, on l'invite à jouer.
 */

/** Sous ce nombre de tentatives, la maîtrise n'est pas encore un score (Q-2, centralisé ici). */
export const COMPETENCY_EVALUATING_MIN_ATTEMPTS = 5;
/** Marge morte de la tendance : en deçà, ni ▲ ni ▼ — on n'invente pas un mouvement. */
const TREND_EPSILON = 5;

function pickLabel(
  row: { label_fr: string; label_en: string; label_ar: string },
  locale: Locale,
): string {
  return locale === "ar" ? row.label_ar : locale === "en" ? row.label_en : row.label_fr;
}

type Group = { family: string; domains: { domain: string; items: CompetencyMasteryRow[] }[] };

/** Group by family, then domain, preserving the server's order (already sorted). */
function groupByFamilyDomain(map: CompetencyMasteryRow[]): Group[] {
  const groups: Group[] = [];
  for (const row of map) {
    let g = groups.find((x) => x.family === row.family);
    if (!g) {
      g = { family: row.family, domains: [] };
      groups.push(g);
    }
    let d = g.domains.find((x) => x.domain === row.domain);
    if (!d) {
      d = { domain: row.domain, items: [] };
      g.domains.push(d);
    }
    d.items.push(row);
  }
  return groups;
}

export function CompetencyMapPanel({
  map,
  blockers,
  blockedSlug,
}: {
  map: CompetencyMasteryRow[];
  blockers: CompetencyBlocker[];
  blockedSlug: string | null;
}) {
  const { t, locale } = useI18n();
  const navigate = useNavigate();
  const [training, setTraining] = useState<string | null>(null);

  async function train(slug: string) {
    setTraining(slug);
    try {
      const exercises = await getCompetencyExercises({ data: { competency: slug } });
      if (exercises[0]) {
        navigate({ to: "/quest/$exerciseId", params: { exerciseId: exercises[0].exercise_id } });
      }
    } finally {
      setTraining(null);
    }
  }

  const blockedRow = blockedSlug ? map.find((c) => c.slug === blockedSlug) : undefined;

  return (
    <section
      aria-label={t.dashboard.competencyTitle}
      className="mt-4 rounded-2xl border border-[color:var(--gold)]/25 bg-black/40 p-5 backdrop-blur-md"
    >
      <div className="flex items-center gap-2 font-display text-lg font-bold">
        <Compass className="h-5 w-5 text-[color:var(--gold)]" />
        {t.dashboard.competencyTitle}
      </div>

      {map.length === 0 ? (
        <p className="mt-3 text-sm text-muted-foreground">{t.dashboard.competencyEmpty}</p>
      ) : (
        <div className="mt-3 space-y-4">
          {groupByFamilyDomain(map).map((group) => (
            <div key={group.family}>
              {group.domains.map((d) => (
                <ul key={d.domain} className="space-y-2">
                  {d.items.map((c) => (
                    <li key={c.competency_id}>
                      <div className="flex items-center gap-2">
                        <span className="min-w-0 flex-1 truncate text-sm">
                          {pickLabel(c, locale)}
                        </span>
                        <TrendIcon row={c} />
                        <span className="shrink-0 text-xs font-bold tabular-nums text-[color:var(--gold)]">
                          {c.attempts < COMPETENCY_EVALUATING_MIN_ATTEMPTS
                            ? t.dashboard.competencyEvaluating
                            : `${Math.round(c.mastery)}%`}
                        </span>
                      </div>
                      <div className="mt-1 h-2 overflow-hidden rounded-full bg-white/10">
                        <div
                          className="h-full rounded-full bg-[color:var(--gold)]"
                          style={{ width: `${Math.round(c.mastery)}%` }}
                          role="progressbar"
                          aria-valuenow={Math.round(c.mastery)}
                          aria-valuemin={0}
                          aria-valuemax={100}
                          aria-label={pickLabel(c, locale)}
                        />
                      </div>
                    </li>
                  ))}
                </ul>
              ))}
            </div>
          ))}
        </div>
      )}

      {/* « Ce qui te bloque » (R-5) : les prérequis faibles de la compétence en échec la plus
          basse. N'apparaît que s'il y a des blocages diagnostiqués — sinon, silence. */}
      {blockers.length > 0 && (
        <div className="mt-5 rounded-xl border border-[color:var(--flame)]/25 bg-[color:var(--flame)]/5 p-4">
          <div className="flex items-center gap-2 text-sm font-bold text-[color:var(--flame)]">
            {blockedRow
              ? t.dashboard.competencyBlockersTitle.replace(
                  "{competency}",
                  pickLabel(blockedRow, locale),
                )
              : t.dashboard.competencyBlockersTitleGeneric}
          </div>
          <ul className="mt-2 space-y-2">
            {blockers.map((b) => (
              <li key={b.competency_id} className="flex items-center gap-2">
                <span className="min-w-0 flex-1 truncate text-sm">{pickLabel(b, locale)}</span>
                <span className="shrink-0 text-xs tabular-nums text-muted-foreground">
                  {Math.round(b.mastery)}%
                </span>
                <button
                  type="button"
                  onClick={() => train(b.slug)}
                  disabled={training !== null}
                  className="inline-flex shrink-0 items-center gap-1 rounded-lg border border-[color:var(--gold)]/30 px-2 py-1 text-xs font-bold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10 disabled:opacity-50"
                >
                  <Dumbbell className="h-3 w-3" />
                  {t.dashboard.competencyTrainCta}
                </button>
              </li>
            ))}
          </ul>
        </div>
      )}
    </section>
  );
}

function TrendIcon({ row }: { row: CompetencyMasteryRow }) {
  if (row.recent_result == null) return null;
  const delta = row.recent_result - row.mastery;
  if (delta > TREND_EPSILON)
    return (
      <TrendingUp className="h-3.5 w-3.5 shrink-0 text-[color:var(--success)]" aria-label="up" />
    );
  if (delta < -TREND_EPSILON)
    return (
      <TrendingDown className="h-3.5 w-3.5 shrink-0 text-[color:var(--flame)]" aria-label="down" />
    );
  return <Minus className="h-3.5 w-3.5 shrink-0 text-muted-foreground" aria-label="flat" />;
}
