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
