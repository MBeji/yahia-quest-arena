// LE BILAN, côté client — tout ce qui se calcule SANS appel réseau à partir de ce que le serveur a
// rendu : la bande à afficher, les chapitres tenus et à revoir, le texte et le lien de partage.
//
// Rien ici ne JUGE : la note, la bande et les verdicts viennent du serveur (`placement_bilan_json`)
// et sont figés en base (étude 39 R-13). Ce module ne fait que les lire et les mettre en mots.

import {
  PLACEMENT_PATH,
  PLACEMENT_SHARE_SCORE_FLOOR,
  type PlacementBand,
} from "@/shared/constants/placement";
import { SITE_URL } from "@/shared/constants/site";
import { shareEnvFrom, shareText } from "@/shared/lib/share-text";
import type { PlacementTranslations } from "@/lib/i18n/placement.types";

/** Un chapitre du bilan, tel que le snapshot le porte. */
export type BilanChapter = {
  chapterId: string;
  title: string;
  displayOrder: number;
  correct: number;
  total: number;
  held: boolean;
  hasLesson: boolean;
};

/** Ce que le texte de partage a besoin de savoir — un sous-ensemble du bilan. */
export type ShareFacts = {
  scoreOn20: number;
  subjectName: string;
  gradeName: string | null;
  subjectId: string;
  percentile: number | null;
};

/** Les chapitres tenus d'abord, puis ceux à revoir — chacun dans l'ordre du programme (R-7). */
export function splitChapters(chapters: readonly BilanChapter[]): {
  held: BilanChapter[];
  toReview: BilanChapter[];
} {
  const sorted = [...chapters].sort(
    (a, b) => a.displayOrder - b.displayOrder || a.chapterId.localeCompare(b.chapterId),
  );
  return {
    held: sorted.filter((c) => c.held),
    toReview: sorted.filter((c) => !c.held),
  };
}

/**
 * Le lien qui rouvre LE MÊME test (R-8 du partage) : l'entrée publique, la matière
 * présélectionnée. Absolu, sur l'origine canonique — un lien relatif collé dans WhatsApp
 * n'ouvre rien.
 */
export function placementShareUrl(subjectId: string): string {
  return `${SITE_URL}${PLACEMENT_PATH}?matiere=${encodeURIComponent(subjectId)}`;
}

/** Le lien d'une matière vers son test, en relatif — pour les `<Link>` internes. */
export function placementEntrySearch(subjectId: string): { matiere: string } {
  return { matiere: subjectId };
}

/** « 14 » plutôt que « 14.0 », « 13,3 » plutôt que « 13.333 » : la note comme on la dit. */
export function formatScoreOn20(scoreOn20: number, locale: string): string {
  const rounded = Math.round(scoreOn20 * 10) / 10;
  const text = Number.isInteger(rounded) ? String(rounded) : rounded.toFixed(1);
  // Le séparateur décimal suit la langue de l'interface ; les chiffres restent occidentaux
  // partout (politique du projet, y compris en arabe).
  return locale === "fr" ? text.replace(".", ",") : text;
}

/**
 * Le texte proposé au partage (US-3). Sous le plancher, le chiffre est tu (RISK-2) : l'élève
 * peut l'ajouter lui-même, rien ne part sans son geste. Le percentile s'ajoute quand il existe
 * — c'est la phrase la plus partageable qui soit.
 */
export function buildShareText(
  facts: ShareFacts,
  t: PlacementTranslations["placement"]["summary"],
  locale: string,
): string {
  const url = placementShareUrl(facts.subjectId);
  const grade = facts.gradeName ?? "";
  const base =
    facts.scoreOn20 >= PLACEMENT_SHARE_SCORE_FLOOR
      ? t.shareText
          .replace("{score}", formatScoreOn20(facts.scoreOn20, locale))
          .replace("{subject}", facts.subjectName)
          .replace("{grade}", grade)
          .replace("{url}", url)
      : t.shareTextNoScore
          .replace("{subject}", facts.subjectName)
          .replace("{grade}", grade)
          .replace("{url}", url);
  // Sans classe (matière libre), « (…) » vide : on l'ôte plutôt que de le montrer.
  const cleaned = base.replace(/\s*\(\)\s*/, " ");
  if (facts.percentile === null || facts.scoreOn20 < PLACEMENT_SHARE_SCORE_FLOOR) return cleaned;
  return `${t.sharePercentile.replace("{pct}", String(facts.percentile))} ${cleaned}`;
}

/** Le nom et la phrase d'une bande, dans la langue de l'interface. */
export function bandCopy(
  band: PlacementBand,
  t: PlacementTranslations["placement"]["summary"],
): { name: string; line: string } {
  return t.band[band];
}

/**
 * Partager : la feuille de partage de l'appareil quand elle existe, le presse-papiers sinon.
 * Rend ce qui a été fait, pour que l'écran le dise et que la mesure le nomme (`method`).
 * Un refus de l'utilisateur (il ferme la feuille) n'est pas une erreur : rien n'est parti.
 *
 * Le geste est celui de `shareText` (é40 R-18), réglé comme ce bilan l'a toujours fait : pas de
 * WhatsApp, et une feuille fermée retombe sur la copie.
 */
export async function sharePlacementText(
  text: string,
  nav: Pick<Navigator, "share" | "clipboard"> | undefined = typeof navigator === "undefined"
    ? undefined
    : navigator,
): Promise<"share" | "copy" | "none"> {
  const method = await shareText(
    text,
    { channels: ["share", "copy"], afterUnsharedSheet: "next" },
    shareEnvFrom(nav),
  );
  return method === "whatsapp" ? "none" : method;
}
