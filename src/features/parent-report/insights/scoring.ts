/**
 * La mécanique commune aux deux indices du tableau de bord parental
 * (engagement et efficacité).
 *
 * Une règle gouverne tout : **un indice doit être explicable**. Le parent ne
 * voit pas « 72/100 » tombé du ciel, il voit les facteurs qui l'ont porté et
 * ceux qui l'ont retenu. D'où la forme retournue ici — non pas un nombre, mais
 * la liste des facteurs avec, pour chacun, sa valeur brute, son poids et les
 * points qu'il a réellement apportés.
 *
 * Deuxième règle : **on ne note pas ce qu'on n'a pas mesuré**. Un facteur sans
 * donnée (`ratio: null`) est retiré du calcul et les poids des autres sont
 * renormalisés, au lieu d'être compté zéro. Compter zéro punirait un enfant pour
 * une absence d'instrumentation — par exemple le temps de lecture sur une
 * période antérieure à sa mise en place. Si plus rien n'est mesurable, l'indice
 * se déclare insuffisant plutôt que d'afficher 0.
 */

export type IndexBand = "excellent" | "good" | "fair" | "weak";

/** Seuils communs aux deux indices, alignés sur le verdict du bilan famille. */
export const BAND_THRESHOLDS = { excellent: 80, good: 60, fair: 40 } as const;

export function bandFor(score: number): IndexBand {
  if (score >= BAND_THRESHOLDS.excellent) return "excellent";
  if (score >= BAND_THRESHOLDS.good) return "good";
  if (score >= BAND_THRESHOLDS.fair) return "fair";
  return "weak";
}

export type FactorInput<K extends string> = {
  key: K;
  /** Poids nominal. La somme des poids d'une famille vaut 100. */
  weight: number;
  /** 0–1, ou `null` quand la donnée n'existe pas sur cette période. */
  ratio: number | null;
  /** Valeurs brutes à afficher au parent (« 4 jours actifs sur 5 attendus »). */
  detail: Record<string, number>;
};

export type ScoredFactor<K extends string> = FactorInput<K> & {
  /** Poids après renormalisation sur les seuls facteurs disponibles. */
  effectiveWeight: number;
  /** Points réellement apportés au score (0 → effectiveWeight). */
  points: number;
  /** Ce qui manque pour que ce facteur soit au maximum. */
  missingPoints: number;
};

export type IndexResult<K extends string> = {
  /** 0–100. Vaut 0 quand `insufficientData` est vrai — ne pas l'afficher alors. */
  score: number;
  band: IndexBand;
  /** Triés par contribution décroissante. */
  factors: ScoredFactor<K>[];
  insufficientData: boolean;
};

export function clamp01(value: number): number {
  if (!Number.isFinite(value)) return 0;
  return Math.min(1, Math.max(0, value));
}

/**
 * Projette une valeur sur 0–1 entre deux bornes. `worst` peut être supérieur à
 * `best` : c'est le cas des métriques où « moins, c'est mieux » (minutes par
 * exercice réussi, tentatives avant réussite).
 */
export function ratioBetween(value: number, worst: number, best: number): number {
  if (!Number.isFinite(value) || worst === best) return 0;
  return clamp01((value - worst) / (best - worst));
}

export function scoreIndex<K extends string>(inputs: FactorInput<K>[]): IndexResult<K> {
  const available = inputs.filter((f) => f.ratio !== null);
  const totalWeight = available.reduce((sum, f) => sum + f.weight, 0);

  if (totalWeight <= 0) {
    return {
      score: 0,
      band: "weak",
      insufficientData: true,
      factors: inputs.map((f) => ({
        ...f,
        effectiveWeight: 0,
        points: 0,
        missingPoints: 0,
      })),
    };
  }

  const factors: ScoredFactor<K>[] = inputs.map((f) => {
    if (f.ratio === null) {
      return { ...f, effectiveWeight: 0, points: 0, missingPoints: 0 };
    }
    const effectiveWeight = (f.weight / totalWeight) * 100;
    const points = clamp01(f.ratio) * effectiveWeight;
    return { ...f, effectiveWeight, points, missingPoints: effectiveWeight - points };
  });

  const score = Math.round(factors.reduce((sum, f) => sum + f.points, 0));

  return {
    score,
    band: bandFor(score),
    insufficientData: false,
    factors: [...factors].sort((a, b) => b.points - a.points),
  };
}

/** Les deux facteurs qui ont le plus porté l'indice (ratio réellement bon). */
export function topContributors<K extends string>(
  result: IndexResult<K>,
  count = 2,
): ScoredFactor<K>[] {
  return result.factors.filter((f) => f.ratio !== null && f.ratio >= 0.6).slice(0, count);
}

/** Les deux facteurs qui l'ont le plus retenu — la marge de progression. */
export function topGaps<K extends string>(result: IndexResult<K>, count = 2): ScoredFactor<K>[] {
  return result.factors
    .filter((f) => f.ratio !== null && f.ratio < 0.6)
    .sort((a, b) => b.missingPoints - a.missingPoints)
    .slice(0, count);
}
