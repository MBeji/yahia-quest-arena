// LA DÉCISION « SÉLECTION OU GÉNÉRATION » — étude 11 lot 5 (US-11, US-12, Q-8).
//
// POURQUOI CETTE RÈGLE VIT DANS UN FICHIER PUR
// ---------------------------------------------------------------------------
// Deux raisons, et la seconde est la vraie. La première : `tutor.server.ts` est
// à 725 lignes effectives pour un plafond de 750 (`max-lines`), et il a déjà été
// scindé une fois pour ça (`tutor.stream.server.ts`) — y verser une matrice de
// décision le ferait rougir. La seconde : cette règle décide de DÉPENSER DE
// L'ARGENT. Une règle qui engage un appel de modèle doit être lisible et
// testable sans base, sans réseau et sans session — c'est le motif de
// `coaching.ts` et d'`escalation.ts`, purs et testés pour la même raison.
//
// ⚠️ LE SEUIL DES 3 QUESTIONS FRAÎCHES N'EST PAS ICI, ET NE DOIT JAMAIS Y ÊTRE.
// Il vit dans `tutor_practice_needs_generation` (migration 20260823150000), qui
// l'obtient elle-même de `get_targeted_exercises` — un seul endroit, une seule
// migration pour le changer, donc une revue. C'est la leçon payée par R-2, dont
// le triplet (3 occurrences / 2 séances / 30 jours) avait fini recopié à quatre
// endroits qui divergeaient (20260823100000 l'a rapatrié).
//
// Ce module reçoit donc un BOOLÉEN déjà décidé par le SQL, jamais un décompte à
// comparer. S'il recevait `freshCount`, la première tentation serait d'écrire
// `>= 3` ici, et le seuil vivrait à deux endroits le jour même.

/**
 * Ce que la Forge sait faire AUJOURD'HUI, et c'est la contrainte qui façonne
 * toute cette décision : elle ne prend qu'un CHAPITRE.
 *
 * `ai_forged_quizzes.scope` accepte bien `('chapter','competency','mistakes')`,
 * mais côté Node `forgeQuiz` n'accepte que `{chapterId, size, difficulty}` et
 * code `p_scope` en dur à `"chapter"` ; `get_forge_context(p_chapter UUID)` est
 * chapitre-seule et REVOKE de `authenticated` ; la route est `/forge?chapitre=`.
 * Il n'existe AUCUN scope `tag`.
 *
 * Conséquence assumée : sans chapitre, on ne forge pas. Et `chapter_id` EST
 * nullable dans `get_my_weaknesses` (LEFT JOIN `home`) — une erreur qui n'a
 * jamais été commise dans un chapitre identifié est un cas réel, pas un cas
 * limite. L'écran doit savoir le dire plutôt que d'inventer un scope que ni la
 * RPC ni la route n'accepteraient.
 */
export type TutorPracticeIntent =
  | {
      readonly kind: "exercises";
      /**
       * `true` : le stock couvre l'erreur (le SQL n'a pas ouvert Q-8).
       * `false` : on joue quand même ce qu'on a — voir `decidePractice`.
       * L'écran DOIT le refléter : promettre « sur ton erreur » en servant du
       * repli serait un mensonge, et l'élève le repère au premier énoncé.
       */
      readonly onTarget: boolean;
    }
  | { readonly kind: "forge"; readonly chapterId: string }
  | {
      readonly kind: "none";
      /**
       * `no-chapter` — on ne sait pas OÙ vit cette erreur : ni stock, ni cible
       * à forger. `no-material` — on sait où, mais il n'y a rien à jouer et la
       * Forge n'est pas ouverte à cet élève.
       */
      readonly reason: "no-chapter" | "no-material";
    };

export type TutorPracticeFacts = {
  /**
   * Le verdict de `tutor_practice_needs_generation`, tel quel. JAMAIS recalculé
   * ici : c'est le SQL qui sait ce que « fraîche » veut dire (la fenêtre de 30
   * jours, la porte d'accès, le bornage aux chapitres de l'erreur).
   */
  readonly needsGeneration: boolean;
  /** Combien de lignes la sélection a rendues — repli compris. */
  readonly itemCount: number;
  /** Le chapitre où l'erreur se commet le plus. Nullable par conception. */
  readonly chapterId: string | null;
  /** La Forge est-elle ouverte à CET élève ? (`AI_LIVE_FEATURES` + accord parental.) */
  readonly forgeEnabled: boolean;
};

/**
 * L'ordre des quatre branches EST la règle de Q-8, et il se lit de haut en bas.
 *
 * 1. **Le stock d'abord, toujours.** Q-8 n'autorise la génération qu'en repli
 *    conditionnel : tant que la sélection couvre l'erreur, on ne dépense rien.
 *    C'est aussi la voie la meilleure pédagogiquement — une question du
 *    catalogue a été relue par un humain, une question forgée ne l'a pas été.
 *
 * 2. **La Forge ensuite, si elle est ouverte ET si on sait où.** Les deux
 *    conditions, pas une : un `chapterId` absent ne se remplace pas par un
 *    défaut, et une Forge fermée ne s'ouvre pas parce que le stock est vide.
 *
 * 3. **Sinon, on joue ce qu'on a — même en repli.** C'est la branche que la
 *    lecture littérale du brief oublierait, et elle a coûté cher ailleurs : un
 *    élève avec deux questions fraîches et une de repli a de quoi travailler.
 *    Basculer sur « rien à te proposer » parce que le compte s'arrête à deux
 *    jetterait du matériel réel et utilisable. R-15 : on dégrade, on ne casse
 *    pas. `onTarget: false` oblige l'écran à l'annoncer honnêtement.
 *
 * 4. **Et seulement alors, l'aveu.** Deux aveux distincts, parce qu'ils
 *    appellent deux phrases différentes : on ne sait pas où (`no-chapter`), ou
 *    on sait mais il n'y a rien et rien ne peut être écrit (`no-material`).
 */
export function decidePractice(facts: TutorPracticeFacts): TutorPracticeIntent {
  if (!facts.needsGeneration) {
    return { kind: "exercises", onTarget: true };
  }

  if (facts.forgeEnabled && facts.chapterId) {
    return { kind: "forge", chapterId: facts.chapterId };
  }

  if (facts.itemCount > 0) {
    return { kind: "exercises", onTarget: false };
  }

  return { kind: "none", reason: facts.chapterId ? "no-material" : "no-chapter" };
}
