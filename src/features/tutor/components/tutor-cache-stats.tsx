// LES DEUX MESURES DU LOT 7, POUR LA CONSOLE ADMIN — étude 11.
//
// POURQUOI CES DEUX CHIFFRES-LÀ ET PAS D'AUTRES
// ---------------------------------------------------------------------------
// Ce sont les deux seules mesures qui disent si l'étage IA tient sa promesse
// ÉCONOMIQUE et sa promesse de QUALITÉ, et aucune des deux n'existait :
//
//   * le HIT-RATE du cache mutualisé (R-15.2) — une explication déjà payée par
//     une famille, resservie à une autre sur la même question, la même erreur,
//     la même langue et le même âge, ne coûte ni argent ni énergie. C'est le
//     mécanisme qui rend le tuteur soutenable ; sans mesure, on ne saurait pas
//     s'il fonctionne, seulement qu'il existe ;
//   * le TAUX DE REBUT de la Forge (R-18bis/R-19) — la part des candidats jetés
//     par la double résolution. `get_ai_console` le calcule DÉJÀ pour une
//     famille, sur 7 jours ; la version plateforme reprend la MÊME formule sans
//     le filtre du porteur, sans quoi deux écrans donneraient deux chiffres
//     différents du même phénomène.
//
// LE COMPOSANT VIT DANS `features/tutor`, PAS DANS `features/ai`
// ---------------------------------------------------------------------------
// Il lit `get_tutor_cache_stats` par la server fn du tuteur, et une feature n'en
// importe jamais une autre : c'est donc la ROUTE `/console/ia` qui le compose,
// à côté des agrégats de `getAiAdminOverview`. Le nom du composant diffère
// volontairement du type `TutorCacheStats` (la forme rendue par la RPC) — un
// barrel ne peut pas ré-exporter deux membres du même nom, fût-ce un type et un
// composant.
//
// LA PORTE EST LA RPC, PAS CET ÉCRAN
// ---------------------------------------------------------------------------
// `get_tutor_cache_stats` est SECURITY DEFINER et refuse un non-admin. Ce
// composant n'a donc aucun contrôle d'accès à faire : la server fn rend `null`
// sur refus comme sur panne, et le panneau dit « indisponible ». Même posture
// que `getAiAdminOverview` — l'UI reflète, elle ne juge pas.

import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { Recycle } from "lucide-react";

import { useT } from "@/lib/i18n";
import { getTutorCacheStats, type TutorCacheStats } from "../tutor.energy.server";

/** Fenêtre par défaut : celle des autres agrégats de la console (30 jours). */
const DEFAULT_DAYS = 30;

/**
 * Un ratio 0 → 1 en pourcentage lisible.
 *
 * Une décimale, parce que la RPC arrondit déjà à trois (`ROUND(x, 3)`) : sur un
 * parc de quelques centaines d'appels, l'entier masquerait un mouvement réel.
 * Et pas de garde-fou qui écrêterait à 100 % — un taux aberrant doit se VOIR,
 * pas se faire maquiller en chiffre plausible.
 */
function pct(ratio: number): string {
  return `${(ratio * 100).toFixed(1)} %`;
}

export function TutorCachePanel({ days = DEFAULT_DAYS }: { days?: number }) {
  const t = useT();
  const fetchStats = useServerFn(getTutorCacheStats);

  const { data } = useQuery<TutorCacheStats | null>({
    queryKey: ["tutor-cache-stats", days],
    queryFn: () => fetchStats({ data: { days } }),
    // Deux agrégats sur des fenêtres de plusieurs jours : les rafraîchir à
    // chaque focus ferait balayer des tables pour un chiffre qui ne bouge pas.
    staleTime: 5 * 60_000,
  });

  // La FENÊTRE est affichée avec les taux, toujours : un ratio sans sa fenêtre
  // est un chiffre qu'on ne peut pas contredire. `lifetimeHitRate` est le cas où
  // le SQL a tranché pour le cumul — `serve_count` n'est pas daté — et l'écran
  // doit alors le dire au lieu de laisser croire à 30 jours.
  const windowLabel = t.tutor.cacheStats.window.replace("{n}", String(data?.days ?? days));
  const hitWindow = data?.lifetimeHitRate ? t.tutor.cacheStats.lifetime : windowLabel;

  return (
    <div className="mt-4" data-testid="tutor-cache-stats">
      <p className="flex items-center gap-1.5 text-sm font-semibold">
        <Recycle className="size-4 shrink-0 text-[color:var(--gold)]" aria-hidden="true" />
        {t.tutor.cacheStats.title}
      </p>

      {!data ? (
        <p className="text-muted-foreground mt-1 text-xs">{t.tutor.cacheStats.unavailable}</p>
      ) : (
        <div className="mt-2 grid gap-3 sm:grid-cols-2">
          <Measure
            label={t.tutor.cacheStats.hitTitle}
            value={pct(data.hitRate)}
            window={hitWindow}
            detail={
              data.hits === undefined || data.misses === undefined
                ? null
                : t.tutor.cacheStats.hitDetail
                    .replace("{hits}", String(data.hits))
                    .replace("{misses}", String(data.misses))
            }
            testId="tutor-cache-hit"
          />
          <Measure
            label={t.tutor.cacheStats.discardTitle}
            value={pct(data.discardRate)}
            window={windowLabel}
            detail={
              data.discarded === undefined || data.kept === undefined
                ? null
                : t.tutor.cacheStats.discardDetail
                    .replace("{discarded}", String(data.discarded))
                    .replace("{kept}", String(data.kept))
            }
            testId="tutor-cache-discard"
          />
        </div>
      )}
    </div>
  );
}

/**
 * Une mesure. `detail` est nullable par conception : les numérateurs sont
 * facultatifs dans le contrat de la RPC, et un tiret vaut mieux qu'un zéro
 * inventé — l'un se remarque, l'autre se croit.
 */
function Measure({
  label,
  value,
  window: windowLabel,
  detail,
  testId,
}: {
  label: string;
  value: string;
  window: string;
  detail: string | null;
  testId: string;
}) {
  return (
    <div className="border-border/60 rounded-xl border p-2.5" data-testid={testId}>
      <span className="text-muted-foreground block text-xs">{label}</span>
      {/* Chiffres en LTR : « 62.5 % » ne se lit pas à l'envers en arabe. */}
      <span className="font-display block text-xl font-bold" dir="ltr">
        {value}
      </span>
      <span className="text-muted-foreground block text-xs">{windowLabel}</span>
      <span className="text-muted-foreground block text-xs" dir="ltr">
        {detail ?? "—"}
      </span>
    </div>
  );
}
