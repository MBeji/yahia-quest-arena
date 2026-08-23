/**
 * « Tes points faibles » — étude 04 lot A2.1 (US-2).
 *
 * Le contrat de `get_my_weaknesses`, tel que le serveur le rend : des FAITS,
 * dans les trois langues, et rien qui soit déjà mis en forme. Le composant met
 * en langue et compose la flèche — un libellé traduit en SQL parlerait une
 * seule langue, et une flèche décidée en SQL ne saurait pas si l'écran a la
 * place de l'afficher.
 *
 * Même posture, même fichier de types que `competency.ts` (é07 lot 4) : ces
 * lignes traversent le serveur, le composant et les tests, donc elles vivent
 * dans `shared/types` plutôt que dans l'une des trois features.
 */

/** La direction d'une erreur sur deux fenêtres de 7 jours. */
export type WeaknessTrend = "improving" | "worsening" | "stable";

export type WeaknessRow = {
  /**
   * L'identifiant de l'erreur. **Jamais affiché** (R-A1.2-1) — il ne sert qu'aux
   * clés de rendu et à la télémétrie.
   */
  tag: string;
  label_fr: string;
  label_en: string;
  label_ar: string;
  /**
   * La compétence que cette erreur met en défaut (A12). `null` par conception :
   * une confusion de vocabulaire n'en a pas, et l'écran doit alors se taire
   * plutôt que de proposer un exercice au hasard.
   */
  competency: string | null;
  occurrences: number;
  last_seen_at: string;
  /** Le chapitre où l'erreur se commet le plus — la cible de « revoir le cours ». */
  chapter_id: string | null;
  chapter_title: string | null;
  subject_id: string | null;
  recent_7d: number;
  previous_7d: number;
  /**
   * `stable` couvre aussi « pas encore assez de données » : sous trois
   * occurrences sur les deux fenêtres, aucune direction n'est honnête.
   */
  trend: WeaknessTrend;
};
