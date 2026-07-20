/**
 * « Révision du jour » — étude 04, lot A1.1 (US-1).
 *
 * Une ligne du plan servi par la RPC `get_daily_plan` : un exercice à revoir, plus de quoi
 * en dire la RAISON à l'élève sans jamais la traduire côté serveur. Le SQL ne rend que des
 * faits (quel chapitre, depuis combien de jours, combien de faiblesses actives) ; la phrase,
 * elle, se compose dans la langue de l'interface — sinon la révision parlerait français à un
 * élève qui lit en arabe.
 *
 * Le type est dans `shared/` parce que deux côtés le partagent sans se connaître : la server
 * fn du tableau de bord qui appelle la RPC, et le panneau de la feature `progression` qui
 * l'affiche. Les features ne s'importent jamais entre elles.
 *
 * Les noms de champs sont ceux des colonnes de la RPC (snake_case) : ce type décrit une ligne
 * de base, pas un modèle de vue — le renommer ici ne ferait qu'ajouter une couche à maintenir
 * en phase avec la migration.
 */
export type DailyPlanItem = {
  /** L'exercice à jouer — l'exercice dû, ou son repli d1–2 quand l'accès l'exigeait (R-3). */
  exercise_id: string;
  chapter_id: string;
  subject_id: string;
  exercise_title: string;
  /** Le chapitre porte la raison : c'est « Fractions » qu'on n'a pas revu, pas « Exercice 3 ». */
  chapter_title: string;
  /** Jours pleins depuis l'échéance SM-2. 0 = due aujourd'hui. */
  days_overdue: number;
  /** Misconceptions ACTIVES (seuil R-2) diagnostiquées dans ce chapitre. */
  weak_tags: number;
  /** Vrai quand l'exercice dû était verrouillé et qu'une mission du chapitre l'a remplacé. */
  is_fallback: boolean;
};
