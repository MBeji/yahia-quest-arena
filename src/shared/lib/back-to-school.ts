/**
 * Fenêtre de rentrée — étude 22, R-4.
 *
 * La promotion de rentrée est **proposée, jamais imposée** (D-6). Il n'existe donc aucun job de
 * septembre qui fait monter les élèves d'une classe : les redoublants, les sections de lycée et
 * les comptes dormants rendraient un tel batch faux par construction. Une bannière suffit — ce
 * fichier décide seulement À QUI et QUAND elle s'adresse.
 *
 * FUSEAU : tout est en UTC, comme le reste des helpers de date du projet (`dates.ts`). Le §3 de
 * l'étude annonce « fuseau Tunis, comme les semaines de ligue » — or les semaines de ligue sont
 * en réalité en UTC (`getCurrentWeekStartUtc`), la prémisse est donc inexacte. La Tunisie est à
 * UTC+1 sans heure d'été : sur une fenêtre de deux mois, l'écart d'une heure est immatériel, et
 * introduire ici la première couche de fuseau du projet coûterait plus qu'il ne rapporte.
 */
import { BACK_TO_SCHOOL_WINDOW } from "@/shared/constants/gamification";

/**
 * 1ᵉʳ septembre de l'ANNÉE SCOLAIRE courante, en UTC.
 *
 * Une année scolaire court de septembre à août : au 15 janvier 2027, l'année scolaire courante
 * a commencé le 1ᵉʳ septembre 2026. C'est cette date-là que la condition de R-4 interroge, et
 * pas le 1ᵉʳ septembre de l'année civile — sans quoi un élève ayant choisi sa classe en octobre
 * se verrait reproposer une promotion en janvier.
 */
export function schoolYearStartUtc(now: Date = new Date()): Date {
  const year =
    now.getUTCMonth() + 1 >= BACK_TO_SCHOOL_WINDOW.startMonth
      ? now.getUTCFullYear()
      : now.getUTCFullYear() - 1;
  return new Date(
    Date.UTC(year, BACK_TO_SCHOOL_WINDOW.startMonth - 1, BACK_TO_SCHOOL_WINDOW.startDay),
  );
}

/**
 * Identifiant de la saison scolaire — « 2026-2027 ». Sert de suffixe à la clé de rejet
 * persistée côté client (`na9ra.backToSchoolDismissed.<saison>`) : un « Je reste en 7ᵉ » vaut
 * pour cette rentrée-là et ne doit surtout pas museler celle de l'année suivante.
 */
export function schoolYearKey(now: Date = new Date()): string {
  const start = schoolYearStartUtc(now).getUTCFullYear();
  return `${start}-${start + 1}`;
}

/**
 * Sommes-nous dans la fenêtre d'affichage (1ᵉʳ septembre → 31 octobre inclus) ?
 *
 * Bornes arbitrées en Q-3 : assez tôt pour accompagner la vraie rentrée, assez court pour que
 * la bannière ne devienne pas un meuble qu'on n'voit plus.
 */
export function isWithinBackToSchoolWindow(now: Date = new Date()): boolean {
  const month = now.getUTCMonth() + 1;
  const day = now.getUTCDate();
  const afterStart =
    month > BACK_TO_SCHOOL_WINDOW.startMonth ||
    (month === BACK_TO_SCHOOL_WINDOW.startMonth && day >= BACK_TO_SCHOOL_WINDOW.startDay);
  const beforeEnd =
    month < BACK_TO_SCHOOL_WINDOW.endMonth ||
    (month === BACK_TO_SCHOOL_WINDOW.endMonth && day <= BACK_TO_SCHOOL_WINDOW.endDay);
  return afterStart && beforeEnd;
}

/**
 * La bannière doit-elle être proposée à cet élève ?
 *
 * Deux conditions, et seulement deux : on est dans la fenêtre, ET le dernier choix de parcours
 * est ANTÉRIEUR à la rentrée courante. La seconde évite l'absurdité de proposer un changement
 * de classe à quelqu'un qui vient précisément de la choisir.
 *
 * `null` (jamais horodaté depuis la migration `20260721090000`) compte comme antérieur : ces
 * comptes ont effectivement choisi leur classe avant cette rentrée.
 *
 * Ce que cette fonction NE décide PAS : si l'élève a une classe suivante (un bac terminal n'en
 * a pas — Q-3, pas de bannière), ni s'il a déjà refusé cette saison. Ces deux garde-fous
 * vivent chez l'appelant, qui seul connaît le catalogue et le stockage local.
 */
export function shouldOfferPromotion(args: {
  parcoursSetAt: string | Date | null | undefined;
  now?: Date;
}): boolean {
  const now = args.now ?? new Date();
  if (!isWithinBackToSchoolWindow(now)) return false;
  if (args.parcoursSetAt == null) return true;
  const setAt =
    args.parcoursSetAt instanceof Date ? args.parcoursSetAt : new Date(args.parcoursSetAt);
  if (Number.isNaN(setAt.getTime())) return true;
  return setAt.getTime() < schoolYearStartUtc(now).getTime();
}

/** Le minimum dont la résolution de promotion a besoin — le shape réel de `public.grades`. */
export type PromotionGrade = {
  id: string;
  slug: string;
  name_fr: string;
  theme_id: string;
  display_order: number;
  is_selectable?: boolean | null;
};

export type PromotionTarget = {
  /** Le grade visé — une classe à choisir directement, ou l'ANNÉE dont il faudra choisir la section. */
  gradeId: string;
  /** Slug du grade visé : l'appelant en dérive la clé d'année du drill-down (`lyceeYearOf`). */
  gradeSlug: string;
  gradeName: string;
  /**
   * `true` quand l'année visée se décline en sections (2ème, 3ème, bac depuis l'ouverture du
   * lycée) : la bannière ne promeut alors pas d'un clic, elle emmène choisir sa section.
   */
  isSectionDrilldown: boolean;
};

/**
 * Un nœud de SECTION est un grade dont le slug prolonge celui d'une année (`2eme-sec-sciences`
 * prolonge `2eme-sec`). On le déduit de la donnée plutôt que d'un seuil de `display_order` :
 * les sections ont été ajoutées après coup avec des rangs 14+, et coder ce nombre en dur
 * casserait au premier grade inséré.
 */
function yearNodeOf(grade: PromotionGrade, grades: PromotionGrade[]): PromotionGrade {
  const parent = grades
    .filter((g) => g.theme_id === grade.theme_id && g.slug !== grade.slug)
    .filter((g) => grade.slug.startsWith(`${g.slug}-`))
    // Le plus long préfixe gagne, au cas où plusieurs correspondraient.
    .sort((a, b) => b.slug.length - a.slug.length)[0];
  return parent ?? grade;
}

/**
 * Quelle classe proposer à la rentrée ? (R-4)
 *
 * On raisonne en ANNÉES, pas en grades : un élève de 2ème Sciences ne passe pas en 2ème
 * Lettres — le `display_order` seul, qui range les seize sections à la suite, conduirait
 * pourtant exactement à cette absurdité.
 *
 * Deux issues seulement :
 *   - l'année suivante est directement choisissable → promotion en un clic ;
 *   - elle se décline en sections (`is_selectable = false` sur le nœud d'année) → la bannière
 *     emmène choisir sa section, elle ne décide pas à la place de l'élève.
 *
 * `null` = pas de bannière : il n'y a pas d'année suivante. C'est le cas du bac (Q-3, aucune
 * bannière en v1) et de tout grade terminal.
 */
export function resolvePromotionTarget(
  grades: PromotionGrade[],
  currentGradeId: string | null | undefined,
): PromotionTarget | null {
  if (!currentGradeId) return null;
  const current = grades.find((g) => g.id === currentGradeId);
  if (!current) return null;

  const currentYear = yearNodeOf(current, grades);
  const years = grades
    .filter((g) => g.theme_id === current.theme_id)
    .filter((g) => yearNodeOf(g, grades).slug === g.slug)
    .sort((a, b) => a.display_order - b.display_order);

  const index = years.findIndex((g) => g.slug === currentYear.slug);
  const next = index >= 0 ? years[index + 1] : undefined;
  if (!next) return null;

  return {
    gradeId: next.id,
    gradeSlug: next.slug,
    gradeName: next.name_fr,
    isSectionDrilldown: next.is_selectable === false,
  };
}
