/**
 * Le cliquet du patron de notion (étude 35) — le pendant, pour les COURS, de ce que
 * `content:tranche --fresh --strict-longest` est pour les questions.
 *
 * `content:qa` juge le patron en deux régimes (é35 D-9) : une matière qui déclare
 * `coursePattern: "notion"` le voit en erreur, toutes les autres en avertissement. Ce
 * régime d'adoption laisse un trou : une session qui écrit AUJOURD'HUI un chapitre neuf
 * dans une matière non déclarée peut le faire à l'ancienne — un cours qui énonce, sans
 * exemple résolu ni `::: verifie` — et la CI reste verte, puisque les contrôles de forme ne
 * se déclenchent qu'en présence d'un bloc de savoir. Mesuré le 2026-09-27 : six matières
 * générées au patron ces dix derniers jours (arabe, anglais, français 9ᵉ et 6ᵉ, physique-
 * chimie 9ᵉ) ne le déclaraient pas, donc rien ne les empêchait de régresser.
 *
 * Le cliquet compte, chapitre par chapitre, les constats é35 du régime STRICT (celui d'une
 * matière déclarée, qui ajoute « aucun bloc de savoir ni exemple ») et compare à la base :
 *   - un chapitre NEUF d'une matière scolaire (`ecole-tn`) doit être à zéro : le contenu
 *     neuf s'écrit au patron ;
 *   - un chapitre MODIFIÉ, quelle que soit sa matière, ne doit pas en compter plus qu'avant :
 *     retoucher un vieux cours ne force pas sa réécriture, mais n'ajoute pas de dette.
 *
 * Les thèmes hors programme (langues CECRL, culture générale, entraînement cérébral) ne
 * sont pas tenus au zéro sur un chapitre neuf : `course-explanation.md` est la doctrine du
 * programme officiel, dont la séquence (نشاط → encadré → أطبق) vient des manuels CNP.
 *
 * Rien ici ne lit le disque : le CLI (`tranche.ts`) charge, ce module compte.
 */

import type { LoadedSubject } from "../../src/shared/content/schema.ts";
import { auditLesson, isSpatialChapter } from "./qa-lesson-checks.ts";

/** Le thème du programme officiel : le seul où un chapitre neuf doit naître au patron. */
export const PATTERN_THEME = "ecole-tn";

/** Un constat du patron de notion, reconnu à son renvoi `(é35 C-n)`. */
const PATTERN_FINDING = /\(é35 C-\d\)/;

/**
 * Les constats é35 d'un cours dans le régime strict. Seuls les `error` comptent : C-6 (section
 * de plus de 60 lignes) reste un avertissement même sous patron, il ne fait pas un cliquet.
 */
export function lessonPatternFindings(lesson: string, slug: string): number {
  return auditLesson(lesson, slug, { spatial: isSpatialChapter(slug), pattern: "error" }).filter(
    (f) => f.level === "error" && PATTERN_FINDING.test(f.msg),
  ).length;
}

export interface LessonRatchetEntry {
  chapter: string;
  /** Constats du cours dans la base, `null` si le chapitre n'y existe pas (neuf). */
  base: number | null;
  now: number;
  /** Vrai quand ce chapitre fait reculer le cliquet. */
  regressed: boolean;
}

/**
 * Le cliquet sur les chapitres de la tranche dont le COURS est neuf ou modifié. `base` est la
 * matière telle qu'elle est au point de départ de la branche, ou `null` si elle n'y existait
 * pas (alors tout est neuf, ce qui est la réponse juste).
 */
export function lessonRatchet(
  subject: LoadedSubject,
  tranche: ReadonlySet<string>,
  base: LoadedSubject | null,
): LessonRatchetEntry[] {
  const before = new Map((base?.chapters ?? []).map((c) => [c.slug, c.lesson]));
  const strictNew = subject.meta.themeId === PATTERN_THEME;
  const out: LessonRatchetEntry[] = [];
  for (const chapter of subject.chapters) {
    if (!tranche.has(chapter.slug)) continue;
    const previous = before.get(chapter.slug);
    if (previous === chapter.lesson) continue; // cours inchangé : rien à juger
    const now = lessonPatternFindings(chapter.lesson, chapter.slug);
    const was = previous === undefined ? null : lessonPatternFindings(previous, chapter.slug);
    const regressed = was === null ? strictNew && now > 0 : now > was;
    out.push({ chapter: chapter.slug, base: was, now, regressed });
  }
  return out;
}
