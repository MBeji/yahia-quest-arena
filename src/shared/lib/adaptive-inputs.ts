/**
 * LE PRODUCTEUR QUI MANQUAIT AUX RANGS 2 ET 4 — étude 30, amendement C (#870).
 *
 * `resolveNextAction` porte six rangs depuis le lot 4. Deux d'entre eux —
 * `remediate` et `strengthen` — lisent `input.remediation` et `input.strengthen`,
 * et **aucun appelant ne les renseignait** : les deux rangs rendaient `null` et
 * l'ordre observé restait celui d'avant l'amendement. Livrés, testés, inertes.
 *
 * Le §3.11 de l'étude ne prévoyait pour le lot 4 ni server fn ni composant : où
 * ces entrées sont PRODUITES était une question de surface non tranchée. Elle
 * l'est (arbitrage du 2026-09-03) — une résolution partagée, appelée par les deux
 * écrans.
 *
 * ── POURQUOI CE FICHIER EST DANS `shared/` ET PAS DANS UNE FEATURE ──────────
 *
 * Les deux consommateurs vivent dans deux features différentes : le tableau de
 * bord (`dashboard.server.ts`, qui résout côté SERVEUR) et le hub matière
 * (`subject-hub.tsx`, qui résout côté CLIENT par une server fn de `progression`).
 * Or une feature n'importe jamais une autre feature (AGENTS.md). Le seul endroit
 * d'où les deux peuvent lire la MÊME résolution est donc `shared/` — et c'est
 * ce qui fait tenir é22 D-8 : deux écrans qui désignent deux cibles différentes,
 * personne ne suit ni l'une ni l'autre.
 *
 * ⚠️ CE N'EST PAS UNE RPC DE DÉCISION (é22 D-8 l'interdit). Ce module ne décide
 * rien : il produit des ENTRÉES. Le choix du rang reste `resolveNextAction`, une
 * fonction TS partagée, et il reste le seul à trancher.
 *
 * ── CE QUE ÇA COÛTE, ET CE QUE ÇA NE COÛTE PAS ─────────────────────────────
 *
 * La résolution enchaîne au plus trois RPC. Sur une matière non taggée elle rend
 * `{}` — `get_learning_state` ne renvoie alors aucune ligne (R-6), donc **aucune
 * des deux RPC suivantes n'est appelée**. C'est le cas de la grande majorité du
 * catalogue aujourd'hui, et il coûte exactement un appel.
 *
 * Côté tableau de bord, `getDashboard` appelle CETTE fonction directement, sur le
 * serveur : pas d'aller-retour supplémentaire sur le chemin SSR — la latence que
 * le lot 3 avait justement évitée n'est pas réintroduite.
 */
import type { CompetencyExercise, LearningStateRow } from "@/shared/types/competency";
import { logger } from "./logger";

/** Une étape du chemin de remontée (`get_remediation_path`, étude 07/30). */
export type RemediationPathRow = {
  slug: string;
  entry_exercise_id: string | null;
  is_root_cause: boolean;
  depth: number;
};

/**
 * Le strict minimum que ce module appelle. Les trois RPC sont postérieures aux
 * types Supabase générés (qui ne se régénèrent pas sans accès base) : leur
 * contrat est figé ici, même patron que `progression.server.ts`.
 *
 * Le périmètre est `auth.uid()` EN DUR côté SQL — aucune de ces fonctions ne
 * prend d'identifiant d'élève.
 */
export type AdaptiveRpcClient = {
  rpc: ((
    fn: "get_learning_state",
    args: { p_family: string | null },
  ) => PromiseLike<{ data: LearningStateRow[] | null; error: { message: string } | null }>) &
    ((
      fn: "get_remediation_path",
      args: { p_competency: string },
    ) => PromiseLike<{ data: RemediationPathRow[] | null; error: { message: string } | null }>) &
    ((
      fn: "get_exercises_for_competency",
      args: { p_competency: string },
    ) => PromiseLike<{ data: CompetencyExercise[] | null; error: { message: string } | null }>);
};

/** Ce que les rangs 2 et 4 de `resolveNextAction` attendent. */
export type AdaptiveInputs = {
  remediation?: { competencySlug: string; exerciseId: string } | null;
  strengthen?: { competencySlug: string; exerciseId: string } | null;
};

/**
 * La LACUNE à traiter, parmi les compétences de la famille.
 *
 * On prend celle sur laquelle l'élève a le plus de preuves : une lacune vue dix
 * fois est plus sûrement une lacune qu'une lacune vue une fois, et R-5 veut
 * qu'on remonte à ce qui est ÉTABLI, pas à ce qui est soupçonné. À égalité, le
 * slug départage — la cible doit être la même d'un écran à l'autre et d'une
 * seconde à l'autre, sinon é22 D-8 tombe pour une raison idiote.
 */
export function pickLacune(rows: LearningStateRow[]): LearningStateRow | null {
  const candidates = rows.filter((r) => r.state === "lacune");
  if (candidates.length === 0) return null;
  return [...candidates].sort(
    (a, b) => b.evidence_count - a.evidence_count || a.slug.localeCompare(b.slug),
  )[0] as LearningStateRow;
}

/**
 * La compétence à CONSOLIDER : « en cours », vue sous le moins de formes.
 *
 * `forms_count` compte les TYPES D'ITEMS distincts — c'est littéralement le
 * « répétée ET variée » de R-4, déjà mesuré côté SQL. La servir sous une autre
 * forme est ce que le rang 4 promet ; la moins variée est donc la bonne cible,
 * et c'est aussi celle où un exercice de plus apprend le plus.
 *
 * ⚠️ Une compétence `fragile` n'est PAS retenue : elle relève de la remontée, pas
 * de la consolidation. Mélanger les deux ferait proposer « encore un peu » là où
 * l'élève a besoin qu'on reprenne en amont.
 */
export function pickAConsolider(rows: LearningStateRow[]): LearningStateRow | null {
  const candidates = rows.filter((r) => r.state === "en-cours");
  if (candidates.length === 0) return null;
  return [...candidates].sort(
    (a, b) => a.forms_count - b.forms_count || a.slug.localeCompare(b.slug),
  )[0] as LearningStateRow;
}

/**
 * La CAUSE RACINE du chemin de remontée, et son exercice d'entrée.
 *
 * `get_remediation_path` rend le chemin ordonné ; la racine est marquée. À défaut
 * de marque exploitable (racine sans exercice d'entrée — le corpus n'en offre
 * pas), on ne retombe PAS sur une étape intermédiaire : proposer le symptôme
 * quand on cherchait la cause est exactement le piétinement que l'amendement C
 * veut faire baisser. Mieux vaut ne rien proposer et laisser le rang suivant
 * parler.
 */
export function pickRacine(path: RemediationPathRow[]): RemediationPathRow | null {
  const racine = path.find((r) => r.is_root_cause && r.entry_exercise_id);
  return racine ?? null;
}

/**
 * Produit les entrées des rangs 2 et 4. Ne décide rien, ne lève jamais.
 *
 * Dégradation gracieuse, comme les trois lectures de croyance du lot 3 : une RPC
 * absente ou en erreur rend l'entrée `null`, donc un rang qui ne se déclenche
 * pas, donc l'ordre d'avant l'amendement. L'élève voit alors exactement l'écran
 * d'aujourd'hui — jamais une page cassée, jamais une erreur.
 *
 * @param client un client Supabase authentifié (le périmètre est `auth.uid()`)
 * @param family la famille de compétences de la matière courante, ou `null`
 */
export async function resolveAdaptiveInputs(
  client: AdaptiveRpcClient,
  family: string | null,
): Promise<AdaptiveInputs> {
  const etat = await client.rpc("get_learning_state", { p_family: family });
  if (etat.error) {
    logger.warn("adaptive: get_learning_state failed, ranks 2/4 stay dormant", {
      error: etat.error.message,
    });
    return {};
  }
  const rows = etat.data ?? [];
  // Matière non taggée : R-6 parle, ce n'est pas une erreur — et on s'arrête ici,
  // donc la résolution ne coûte QU'UN appel sur la majorité du catalogue.
  if (rows.length === 0) return {};

  const [remediation, strengthen] = await Promise.all([
    resolveRemediation(client, pickLacune(rows)),
    resolveStrengthen(client, pickAConsolider(rows)),
  ]);
  return { remediation, strengthen };
}

async function resolveRemediation(
  client: AdaptiveRpcClient,
  lacune: LearningStateRow | null,
): Promise<AdaptiveInputs["remediation"]> {
  if (!lacune) return null;
  const res = await client.rpc("get_remediation_path", { p_competency: lacune.slug });
  if (res.error) {
    logger.warn("adaptive: get_remediation_path failed, rank 2 stays dormant", {
      error: res.error.message,
    });
    return null;
  }
  const racine = pickRacine(res.data ?? []);
  if (!racine?.entry_exercise_id) return null;
  // Le slug qui voyage est celui de la RACINE, pas celui de la lacune observée :
  // R-14 veut la raison en langage élève, et la raison est le prérequis manquant.
  return { competencySlug: racine.slug, exerciseId: racine.entry_exercise_id };
}

async function resolveStrengthen(
  client: AdaptiveRpcClient,
  aConsolider: LearningStateRow | null,
): Promise<AdaptiveInputs["strengthen"]> {
  if (!aConsolider) return null;
  const res = await client.rpc("get_exercises_for_competency", {
    p_competency: aConsolider.slug,
  });
  if (res.error) {
    logger.warn("adaptive: get_exercises_for_competency failed, rank 4 stays dormant", {
      error: res.error.message,
    });
    return null;
  }
  // Le plus facile d'abord : consolider n'est pas éprouver. À égalité, l'id
  // départage — même raison de stabilité que ci-dessus.
  const exercice = [...(res.data ?? [])].sort(
    (a, b) => a.difficulty - b.difficulty || a.exercise_id.localeCompare(b.exercise_id),
  )[0];
  if (!exercice) return null;
  return { competencySlug: aConsolider.slug, exerciseId: exercice.exercise_id };
}
