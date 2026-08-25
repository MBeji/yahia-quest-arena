/**
 * Knowledge graph — profils de maîtrise (étude 07, lot 4).
 *
 * Les lignes rendues par les trois RPC de lecture (`get_my_competency_map`,
 * `get_competency_blockers`, `get_exercises_for_competency`). Comme pour
 * `DailyPlanItem`, le type vit dans `shared/` parce que deux côtés le partagent
 * sans se connaître — la server fn / le tableau de bord qui appelle la RPC, et le
 * panneau de la feature `progression` qui l'affiche — et les noms de champs sont
 * ceux des colonnes (snake_case) : ce sont des lignes de base, pas des modèles de
 * vue. Le serveur ne rend que des FAITS ; les libellés trilingues voyagent tous
 * les trois, la mise en langue (et la flèche de tendance) se fait dans l'UI.
 */

/** Une compétence de la carte de l'élève (US-1) — maîtrise avec oubli appliqué. */
export type CompetencyMasteryRow = {
  competency_id: string;
  slug: string;
  /** Matière trans-grades (`math`) — la carte se groupe d'abord par famille. */
  family: string;
  /** 2ᵉ segment de l'id (`math.geo.thales-direct` → `geo`) — sous-groupe de la carte. */
  domain: string;
  label_fr: string;
  label_en: string;
  label_ar: string;
  /** 0–100, oubli compris (R-4). */
  mastery: number;
  /** Nombre de tentatives : sous 5, l'UI affiche « en cours d'évaluation » (Q-2 / RISK-2). */
  attempts: number;
  /**
   * Réussite moyenne (0–100) des 14 derniers jours sur la compétence, ou `null`
   * si rien n'a été joué. L'UI en tire la tendance ▲▼ en la comparant à `mastery`
   * — il n'existe pas d'historique de maîtrise à diffuser.
   */
  recent_result: number | null;
};

/** Un prérequis faible qui explique un échec (R-5) — « ce qui te bloque ». */
export type CompetencyBlocker = {
  competency_id: string;
  slug: string;
  label_fr: string;
  label_en: string;
  label_ar: string;
  /** 0–100, oubli compris ; < 60 par construction (seuil R-5). */
  mastery: number;
  /** Profondeur dans le DAG de prérequis (1 = direct), bornée à 3. */
  depth: number;
};

/** Un exercice existant qui évalue une compétence, déjà passé par la porte d'accès (US-2/R-3). */
export type CompetencyExercise = {
  exercise_id: string;
  chapter_id: string;
  subject_id: string;
  exercise_title: string;
  difficulty: number;
};

// ---------------------------------------------------------------------------
// Tuteur déterministe (étude 30, lot 3) — les lectures de croyance.
// ---------------------------------------------------------------------------
// Même posture que ci-dessus : ce sont des LIGNES DE BASE (snake_case), pas des modèles de
// vue, et le serveur n'y met que des faits. La nouveauté est que deux de ces faits sont des
// IDENTIFIANTS et non des nombres — `state` et `zone` — parce qu'un état se met en langue et
// qu'un pourcentage ne se met pas en question (§2.3, D-1).

/** Les quatre états de R-4/R-5, plus l'absence de jugement. */
export type CompetencyState = "maitrisee" | "en-cours" | "fragile" | "lacune" | "inconnue";

/** Les trois zones du graphe (§3.4). `hors-portee` n'interdit rien (R-17). */
export type CompetencyZone = "interieur" | "frontiere" | "hors-portee";

/** D'où vient la croyance : jouée, déduite, ou établie par un bilan d'entrée. */
export type BeliefSource = "evidence" | "inference" | "placement";

/**
 * Une compétence de la carte à 4 états (`get_learning_state`).
 *
 * ⚠️ `p_known` voyage jusqu'ici parce que la console d'admin en a besoin (US-8) — et il ne
 * doit atteindre AUCUNE surface élève (D-1). Le composant `LearningStateMap` ne le lit pas,
 * et son test l'assert littéralement : aucun pourcentage de croyance dans le DOM rendu.
 */
export type LearningStateRow = {
  competency_id: string;
  slug: string;
  family: string;
  domain: string;
  label_fr: string;
  label_en: string;
  label_ar: string;
  state: CompetencyState;
  zone: CompetencyZone;
  /** Réservé à la console d'admin. Ne jamais rendre à un élève. */
  p_known: number | null;
  evidence_count: number;
  sessions_seen: number;
  /** Nombre de TYPES d'items distincts — le « et variée » de R-4, montré tel quel. */
  forms_count: number;
  belief_source: BeliefSource;
  /** Marquée à sonder en priorité (R-8, ou après une contestation). Jamais une sanction. */
  suspect: boolean;
};

/** Une compétence « prête à apprendre » (`get_learning_frontier`). */
export type LearningFrontierRow = {
  competency_id: string;
  slug: string;
  label_fr: string;
  label_en: string;
  label_ar: string;
  state: CompetencyState;
  /** Réservé à la console d'admin (voir ci-dessus). */
  p_known: number | null;
  /** Fan-out : combien de compétences celle-ci débloque. Le tri de la frontière. */
  unlocks: number;
  /** Exercice d'entrée visant la ZPD (§3.4) — `null` si le corpus n'en offre aucun. */
  entry_exercise_id: string | null;
  entry_subject_id: string | null;
  /** P(réussite) prédite de cet exercice. Diagnostic, jamais affiché. */
  entry_odds: number | null;
};
