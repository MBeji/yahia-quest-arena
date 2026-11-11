import { useId, useMemo, useState } from "react";
import {
  CheckCircle2,
  ChevronDown,
  CircleDashed,
  HelpCircle,
  Sparkles,
  TriangleAlert,
} from "lucide-react";

import { useI18n } from "@/lib/i18n";
import type { Locale } from "@/lib/i18n";
import type { CompetencyState, LearningStateRow } from "@/shared/types/competency";
import { disputeInference } from "../progression.server";

/**
 * « Où tu en es » — la carte à 4 états (étude 30, lot 3 · US-2, US-3).
 *
 * CE QU'ELLE REMPLACE, ET POURQUOI. La carte de é07 (lot 4) dit « fractions 41 % ». Un
 * pourcentage est un score : il classe, il se compare, et il ne dit pas quoi faire. Cette
 * carte-ci dit « fragile », « lacune », « prêt à apprendre » — un ÉTAT, qui se lit comme une
 * consigne. C'est la différence entre un bulletin et un plan.
 *
 * ⚠️ L'INTERDIT QUI GOUVERNE CE FICHIER (D-1). `p_known` arrive dans les données parce que la
 * console d'admin en a besoin ; il ne doit atteindre AUCUN pixel de cet écran. La règle n'est
 * pas de politesse : un élève ne lit pas une probabilité, il lit un verdict — et le produit a
 * déjà un score (l'EWMA de é07, qui reste la variable d'affichage). Le test de ce composant
 * assert littéralement l'absence de tout pourcentage dans le DOM rendu.
 *
 * ⚠️ ET CELUI DE R-17 : l'état ne verrouille RIEN. Une compétence hors-portée porte un
 * avertissement motivé et une invitation à remonter — jamais un cadenas. L'étude 22 a retiré
 * les faux verrous séquentiels ; on ne les remet pas par la bande.
 *
 * ELLE SE REPLIE (2026-09-04). Sur le tableau de bord, la carte déroulait TOUTES les
 * compétences de la matière taggée — une vingtaine de lignes, chacune avec son état, sa preuve
 * et son « il manque une base » — au milieu du menu principal. Le propriétaire l'a dit en une
 * phrase : ça ne sert à rien d'afficher tout ça là, c'est encombrant. Et `learning-panels.tsx`
 * le disait déjà : l'élève vient jouer, pas s'auditer ; la carte est là pour qui veut
 * comprendre pourquoi. Elle le devient littéralement : par défaut, le panneau ne montre que le
 * titre, le sous-titre et UN RÉSUMÉ PAR ÉTAT — seuls les états présents, dans l'ordre
 * d'urgence — et un bouton déplie la liste complète. Rien n'en est retiré : la preuve (R-4),
 * la contestation (US-3), le hors-portée (R-17) sont un geste plus loin, pas ailleurs. Le
 * repli n'est pas mémorisé : on revient au hall pour jouer, et un audit qu'on a ouvert une
 * fois n'a pas à rester ouvert à chaque visite.
 *
 * Le serveur rend des identifiants (`maitrisee`, `frontiere`, `inference`) ; c'est ici qu'on
 * les met en langue, qu'on groupe par domaine et qu'on compose. Aucune phrase n'est en base.
 */

/** L'ordre de lecture : ce qui bloque d'abord, ce qui est acquis en dernier. Une carte se lit
 *  pour agir, et l'action urgente est en haut. */
const STATE_ORDER: CompetencyState[] = ["lacune", "fragile", "en-cours", "maitrisee", "inconnue"];

const STATE_ICON = {
  maitrisee: CheckCircle2,
  "en-cours": Sparkles,
  fragile: CircleDashed,
  lacune: TriangleAlert,
  inconnue: HelpCircle,
} as const;

/**
 * Les couleurs viennent des tokens de surface (`docs/design-surfaces.md`) — jamais une valeur
 * en dur. `lacune` emprunte le registre d'alerte, `maitrisee` celui du succès, et les trois
 * autres restent neutres : trois couleurs vives sur cinq états feraient un sapin de Noël où
 * plus rien ne ressort.
 */
const STATE_TONE = {
  maitrisee: "text-success border-success/40 bg-success/10",
  "en-cours": "text-foreground border-border bg-muted/40",
  fragile: "text-muted-foreground border-border bg-muted/20",
  lacune: "text-destructive border-destructive/40 bg-destructive/10",
  inconnue: "text-muted-foreground border-border/60 bg-transparent",
} as const;

function pickLabel(
  row: { label_fr: string; label_en: string; label_ar: string },
  locale: Locale,
): string {
  return locale === "ar" ? row.label_ar : locale === "en" ? row.label_en : row.label_fr;
}

/** Groupe par domaine, chaque groupe trié par urgence d'état puis par libellé. */
function groupByDomain(rows: LearningStateRow[], locale: Locale) {
  const groups = new Map<string, LearningStateRow[]>();
  for (const row of rows) {
    const bucket = groups.get(row.domain);
    if (bucket) bucket.push(row);
    else groups.set(row.domain, [row]);
  }
  return [...groups.entries()].map(([domain, items]) => ({
    domain,
    items: [...items].sort((a, b) => {
      const byState = STATE_ORDER.indexOf(a.state) - STATE_ORDER.indexOf(b.state);
      if (byState !== 0) return byState;
      return pickLabel(a, locale).localeCompare(pickLabel(b, locale), locale);
    }),
  }));
}

/**
 * Le résumé : combien de compétences par état, dans l'ordre d'urgence, et SEULEMENT les états
 * présents. Un compteur à zéro n'informe pas, il allonge — et « 0 lacune » sur une matière
 * jamais jouée ressemblerait à un satisfecit qu'on n'a pas mérité.
 */
function tallyByState(rows: LearningStateRow[]): { state: CompetencyState; count: number }[] {
  const counts = new Map<CompetencyState, number>();
  for (const row of rows) counts.set(row.state, (counts.get(row.state) ?? 0) + 1);
  return STATE_ORDER.flatMap((state) => {
    const count = counts.get(state) ?? 0;
    return count > 0 ? [{ state, count }] : [];
  });
}

export function LearningStateMap({ rows }: { rows: LearningStateRow[] }) {
  const { t, locale } = useI18n();
  const a = t.adaptive;
  // Les compétences contestées dans CETTE session : le serveur a déjà agi, mais recharger la
  // carte entière pour un geste serait disproportionné. L'état local ne ment pas — il reflète
  // une écriture qui a réussi.
  const [disputed, setDisputed] = useState<Record<string, boolean>>({});
  const [open, setOpen] = useState(false);
  const detailId = useId();

  const tally = useMemo(() => tallyByState(rows), [rows]);
  const groups = useMemo(() => groupByDomain(rows, locale), [rows, locale]);

  // L'état vide invite, il ne reproche pas (posture de é07 lot 4, tenue). Il couvre aussi le
  // cas R-6 : sur une matière non taggée la lecture rend zéro ligne, et l'écran est alors
  // exactement celui d'aujourd'hui — rien de neuf ne s'affiche.
  if (rows.length === 0) {
    return (
      <section aria-labelledby="learning-state-title" className="rounded-xl border p-4">
        <h2 id="learning-state-title" className="text-lg font-semibold">
          {a.mapTitle}
        </h2>
        <p className="text-muted-foreground mt-2 text-sm">{a.mapEmpty}</p>
      </section>
    );
  }

  return (
    <section aria-labelledby="learning-state-title" className="rounded-xl border p-4">
      <h2 id="learning-state-title" className="text-lg font-semibold">
        {a.mapTitle}
      </h2>
      <p className="text-muted-foreground mt-1 text-sm">{a.mapSubtitle}</p>

      {/* Le résumé, toujours visible : un compteur par état présent. Le libellé et le nombre
          sont deux éléments d'une rangée flex — pas une phrase — donc la rangée se retourne
          d'elle-même en RTL, sans le piège du nœud de texte mixte documenté plus bas. */}
      <ul aria-label={a.mapSummaryLabel} className="mt-3 flex flex-wrap gap-2">
        {tally.map(({ state, count }) => {
          const Icon = STATE_ICON[state];
          return (
            <li
              key={state}
              className={`inline-flex items-center gap-1.5 rounded-full border px-2.5 py-1 text-xs font-semibold ${STATE_TONE[state]}`}
            >
              <Icon className="size-3.5 shrink-0" aria-hidden />
              <span>{a.state[state]}</span>
              <span className="bg-foreground/10 rounded-full px-1.5 tabular-nums">{count}</span>
            </li>
          );
        })}
      </ul>

      <button
        type="button"
        aria-expanded={open}
        aria-controls={open ? detailId : undefined}
        onClick={() => setOpen((prev) => !prev)}
        className="text-muted-foreground hover:text-foreground mt-3 inline-flex items-center gap-1 py-1 text-sm font-medium underline-offset-2 hover:underline [@media(pointer:coarse)]:min-h-11"
      >
        {open ? a.mapHideDetail : a.mapShowDetail}
        <ChevronDown
          className={`size-4 shrink-0 transition-transform ${open ? "rotate-180" : ""}`}
          aria-hidden
        />
      </button>

      {open ? (
        <div id={detailId} data-testid="learning-state-detail" className="mt-4 space-y-5">
          {groups.map((group) => (
            <div key={group.domain}>
              <h3 className="text-muted-foreground text-xs font-semibold tracking-wide uppercase">
                {group.domain}
              </h3>
              <ul className="mt-2 space-y-2">
                {group.items.map((row) => {
                  const Icon = STATE_ICON[row.state];
                  const isInferred = row.belief_source === "inference" && !disputed[row.slug];
                  return (
                    <li
                      key={row.competency_id}
                      className={`flex flex-wrap items-center gap-2 rounded-lg border px-3 py-2 ${STATE_TONE[row.state]}`}
                    >
                      <Icon className="size-4 shrink-0" aria-hidden />
                      <span className="min-w-0 flex-1 text-sm font-medium">
                        {pickLabel(row, locale)}
                      </span>

                      <span className="text-xs font-semibold">{a.state[row.state]}</span>

                      {/* La PREUVE, montrée et non affirmée (R-4). « prouvé 4 fois, sous 2
                          formes » est ce qui distingue une maîtrise déclarée d'une opinion —
                          et c'est aussi ce que le rapport parent de é08 reprendra mot pour
                          mot. */}
                      {row.state === "maitrisee" && row.evidence_count > 0 ? (
                        <span className="text-muted-foreground w-full text-xs">
                          {a.provenBy
                            .replace("{n}", String(row.evidence_count))
                            .replace("{m}", String(row.forms_count))}
                        </span>
                      ) : null}

                      {/* Une croyance DÉDUITE se dit, et se conteste en un geste (US-3/R-10). */}
                      {isInferred ? (
                        <span className="flex w-full flex-wrap items-center gap-2 text-xs">
                          <span className="border-border rounded border px-1.5 py-0.5 font-semibold">
                            {a.inferredBadge}
                          </span>
                          <button
                            type="button"
                            className="text-muted-foreground hover:text-foreground underline underline-offset-2"
                            onClick={() => {
                              // Optimiste dans le seul sens sûr : on masque le badge tout de
                              // suite, et si l'écriture échoue le prochain chargement de la
                              // carte le ramènera. L'inverse — attendre le serveur pour un
                              // geste de refus — donnerait l'impression de n'être pas écouté.
                              setDisputed((prev) => ({ ...prev, [row.slug]: true }));
                              void disputeInference({ data: { competency: row.slug } });
                            }}
                          >
                            {a.disputeCta}
                          </button>
                        </span>
                      ) : null}

                      {disputed[row.slug] ? (
                        <span className="text-muted-foreground w-full text-xs" role="status">
                          {a.disputeDone}
                        </span>
                      ) : null}

                      {/* R-8 : « à revoir » n'est pas une sanction, c'est une priorité de
                          sondage. Le libellé le dit, et rien ici ne bloque quoi que ce soit. */}
                      {row.suspect && !disputed[row.slug] ? (
                        <span className="text-muted-foreground text-xs">{a.suspectBadge}</span>
                      ) : null}

                      {/* R-17 : hors-portée AVERTIT, n'interdit jamais. Pas de cadenas, pas de
                          bouton désactivé — une phrase, et l'élève décide. */}
                      {row.zone === "hors-portee" && row.state !== "maitrisee" ? (
                        <span className="text-muted-foreground w-full text-xs">
                          {a.zone["hors-portee"]}
                        </span>
                      ) : null}
                    </li>
                  );
                })}
              </ul>
            </div>
          ))}
        </div>
      ) : null}
    </section>
  );
}
