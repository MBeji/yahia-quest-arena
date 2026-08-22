// Le VALIDATEUR DE SORTIE — étude 11 §3.4.
//
// CE QU'IL PROTÈGE, ET DE QUI
// ---------------------------------------------------------------------------
// Pas d'un modèle malveillant : d'un modèle QUELCONQUE. Depuis l'étude 29, la
// clé est celle de la famille et le modèle est celui qu'elle a saisi — « la
// saisie libre d'un id reste ouverte, c'est sa clé, son choix » (D-11). Une
// explication peut donc arriver d'un modèle que personne ici n'a jamais testé.
//
// Le validateur est ce qui rend cette liberté tenable. Il ne juge pas la
// PÉDAGOGIE — aucun code ne sait faire ça — il vérifie quatre propriétés
// mécaniques dont la violation se voit à l'écran d'un enfant :
//
//   1. la langue rendue est celle demandée (un modèle qui répond en anglais à
//      une question d'arabe est inutilisable, pas « moyennement bon ») ;
//   2. la notation est celle du manuel (§3.4 renvoie à `math-and-notation.md`) ;
//   3. la longueur tient dans l'écran de la bande d'âge ;
//   4. rien qui ressemble à une adresse externe ou à du balisage.
//
// Échec ⇒ un retry, puis dégradé R-15. Le rejet est journalisé côté é29
// (`ai_usage_events.status = 'rejected'`), qui alimente déjà la console qualité.

import { HTML_TAG, violatesNotation } from "@/shared/integrations/ai/notation";
import type { TutorAgeBand, TutorLang } from "./prompt";

export type TutorRejection =
  "EMPTY" | "WRONG_SCRIPT" | "NOTATION" | "MARKUP" | "TOO_LONG" | "TOO_SHORT";

export type TutorValidation =
  | { readonly ok: true; readonly body: string }
  | { readonly ok: false; readonly reason: TutorRejection };

/** Plafonds de mots, alignés sur ceux annoncés au modèle, avec la marge d'usage. */
const MAX_WORDS: Record<TutorAgeBand, number> = {
  "6-8": 110,
  "9-11": 160,
  "12-14": 230,
  "15-19": 280,
};

const ARABIC_LETTER = /[؀-ۿ]/;
const LATIN_LETTER = /[A-Za-zÀ-ÿ]/;

/**
 * La langue, mesurée sur le SCRIPT et non sur un détecteur : le français et
 * l'anglais partagent l'alphabet latin, et les distinguer demanderait un modèle
 * de langue pour un gain nul — le prompt système impose déjà la langue, et le
 * cas qui casse vraiment un écran est l'arabe rendu en latin, ou l'inverse.
 *
 * Le seuil est une PROPORTION, pas une présence : une explication d'arabe peut
 * légitimement contenir « 12 cm » ou un mot latin isolé, et une explication de
 * français peut citer un mot arabe. Ce qui n'est jamais légitime, c'est qu'une
 * moitié du texte soit dans l'autre écriture.
 */
function scriptMatches(body: string, lang: TutorLang): boolean {
  const arabic = (body.match(new RegExp(ARABIC_LETTER, "g")) ?? []).length;
  const latin = (body.match(new RegExp(LATIN_LETTER, "g")) ?? []).length;
  const letters = arabic + latin;
  if (letters === 0) return false;

  if (lang === "ar") return arabic / letters >= 0.5;
  return latin / letters >= 0.5;
}

export function countWords(body: string): number {
  return body.trim().split(/\s+/u).filter(Boolean).length;
}

/**
 * Valide une sortie de modèle destinée à un élève. Rend le corps NETTOYÉ (espaces
 * de bord, lignes vides multiples) plutôt que l'original : ce qui est stocké dans
 * le cache est ce qui a été validé, pas ce qui est arrivé.
 */
export function validateTutorOutput(
  raw: string,
  lang: TutorLang,
  ageBand: TutorAgeBand,
): TutorValidation {
  const body = raw
    .replace(/\r\n/g, "\n")
    .replace(/\n{3,}/g, "\n\n")
    .trim();

  if (body.length === 0) return { ok: false, reason: "EMPTY" };
  // Une explication de trois mots n'est pas courte, elle est vide de sens — et
  // c'est le symptôme d'un modèle qui a répondu à côté (« D'accord ! »).
  if (countWords(body) < 8) return { ok: false, reason: "TOO_SHORT" };
  if (countWords(body) > MAX_WORDS[ageBand]) return { ok: false, reason: "TOO_LONG" };
  if (!scriptMatches(body, lang)) return { ok: false, reason: "WRONG_SCRIPT" };
  if (violatesNotation(body)) return { ok: false, reason: "NOTATION" };
  if (HTML_TAG.test(body)) return { ok: false, reason: "MARKUP" };

  return { ok: true, body };
}
