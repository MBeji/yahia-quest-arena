import type { TranslationKeys } from "./types";

/**
 * L'attribut de héros d'une matière dans la langue de l'interface.
 *
 * La valeur vient du CONTENU (`subjects.attribute`), écrite en français : « Force »,
 * « Sagesse », « Esprit »… Affichée telle quelle, elle restait française dans une
 * interface arabe ou anglaise (audit de première visite du 2026-11-12). Les attributs
 * connus sont traduits ; un attribut que le catalogue ne connaît pas s'affiche tel
 * qu'il est écrit, plutôt que de disparaître.
 */
export function attributeLabel(t: TranslationKeys, attribute: string): string {
  const key = attribute.normalize("NFD").replace(/\p{M}/gu, "").toLowerCase();
  const known: Record<string, string> = t.public.attributes;
  return key !== "label" && key in known ? known[key] : attribute;
}
