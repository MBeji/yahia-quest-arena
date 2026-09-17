/**
 * Le volet LEÇON du gate de contenu : les directives de é18, et le patron de notion de é35.
 *
 * Extrait de `qa-checks.ts` au lot 5 de é35 : la règle ESLint `max-lines` a refusé un fichier
 * de 928 lignes de code pour un budget de 750, et elle avait raison. La couture suit la
 * matière, pas la taille : `qa-checks.ts` garde ce qui juge les QUESTIONS (énoncés, clés,
 * figures, notation), ce fichier prend tout ce qui juge les TEXTES (`cours.md`, `resume.md`).
 *
 * Tout ce qui est ici vérifie la FORME et rien d'autre (é35 D-7) : on compte des blocs et des
 * lignes, on ne renifle jamais la prose. Le fond est l'affaire de `content-audit` et de la
 * re-résolution à l'aveugle.
 */

import {
  ARABIC_PROSE_RE,
  auditRenderedFields,
  FIGURE_REFERENCE,
  type Flag,
  rendersRtl,
} from "./qa-checks.ts";

/** Un bloc `<svg>` complet — une figure, quel que soit le nombre de lignes qu'elle occupe. */
const SVG_BLOCK = /<svg[\s\S]*?<\/svg>/i;

/** Les blocs qui ÉNONCENT un savoir : c'est eux qui appellent un exemple (é35, C-1). */
const KNOWLEDGE_DIRECTIVES = new Set(["definition", "propriete", "methode"]);

/** Le séparateur question / réponse d'un `::: verifie` — miroir de `CHECK_SPLIT` du renderer. */
const CHECK_SPLIT = /^---[ \t]*$/;

/**
 * Le patron de notion (étude 35) : les sept temps dont l'ORDRE est fermé. Ces contrôles
 * vérifient la FORME et rien d'autre (D-7) — C-2 compte des lignes, il ne juge pas qu'elles
 * sont « concrètes ». Le fond est l'affaire de `content-audit` (grille §2.4 de l'étude) et de
 * la re-résolution à l'aveugle ; aucun reniflage de prose ici, é18 D-1 tient toujours.
 *
 * Deux régimes, et c'est ce qui rend l'adoption possible matière par matière (D-9) :
 *  - matière SANS `coursePattern` → `warn` : le constat existe, il ne bloque pas. C'est le
 *    backlog de la campagne de fond, pas son gate ;
 *  - matière AVEC `coursePattern: "notion"` → `error` : elle a fini sa campagne, elle s'y tient.
 */
export type PatternLevel = "error" | "warn";

/** Une section `##` d'une leçon, avec ses lignes — l'unité du patron : une section, une notion. */
type LessonSection = { title: string; start: number; lines: string[] };

export function lessonSections(lines: string[]): LessonSection[] {
  const out: LessonSection[] = [];
  let current: LessonSection | null = null;
  for (let i = 0; i < lines.length; i++) {
    const heading = /^##[ \t]+(.+)$/.exec(lines[i]);
    if (heading) {
      if (current) out.push(current);
      current = { title: heading[1].trim(), start: i + 1, lines: [] };
      continue;
    }
    if (current) current.lines.push(lines[i]);
  }
  if (current) out.push(current);
  return out;
}

/**
 * Les lignes d'une section qui portent réellement du contenu — la mesure de C-6.
 *
 * Compter les lignes PHYSIQUES mesure la mise en forme, pas la matière, et C-6 s'est trompé
 * sur les sept sections de maths 9ᵉ qu'il dénonçait (étude 35, lot 5) :
 *
 * - une **ligne vide** ne porte aucune notion, et la convention qui protège les clôtures de
 *   directive de Prettier (une ligne vide avant un `:::` qui suit une liste) en ajoute une par
 *   bloc — cinq sections ont franchi le seuil sans gagner un mot ;
 * - un **`<svg>`** est UNE figure, quel que soit le nombre de lignes qu'il occupe. La section
 *   « شبه المنحرف » de `18-quadrilateres` était signalée à 72 lignes : elle en porte **19**,
 *   le reste étant le corps d'une figure.
 *
 * C'est la même erreur de mesure que R-13 corrigeait un étage plus haut — compter le fichier
 * au lieu de compter la matière. Le seuil de 60 ne bouge pas ; c'est la règle de comptage qui
 * devient honnête.
 */
export function contentLineCount(lines: string[]): number {
  let count = 0;
  let inSvg = false;
  for (const line of lines) {
    if (inSvg) {
      if (/<\/svg>/i.test(line)) inSvg = false;
      continue;
    }
    if (/<svg\b/i.test(line)) {
      count += 1; // la figure compte pour une ligne, fermée sur la même ou plus bas
      if (!/<\/svg>/i.test(line)) inSvg = true;
      continue;
    }
    if (line.trim()) count += 1;
  }
  return count;
}

/** Les types de directives ouverts dans ces lignes, dans l'ordre du document. */
export function directiveSequence(lines: string[]): string[] {
  const out: string[] = [];
  for (const line of lines) {
    const opener = DIRECTIVE_OPEN.exec(line);
    if (opener) out.push(opener[1]);
  }
  return out;
}

/**
 * Les contrôles de PATRON d'une leçon (étude 35, C-1…C-3 et C-6).
 *
 * C-1 « une règle, un exemple » — une section qui pose un savoir montre comment on l'applique.
 * C-2 « le concret d'abord » — un savoir ne peut pas ouvrir sa section : quelque chose doit
 *     l'amener (deux lignes de prose au moins, ou une figure). La règle générale vient APRÈS
 *     l'exemple, jamais avant (le manuel fait déjà ainsi : نشاط → encadré).
 * C-3 « vérifie sur place » — une section qui montre un exemple donne de quoi l'essayer.
 * C-6 « segmenter » — au-delà de 60 lignes DE CONTENU (lignes vides et corps de `<svg>` exclus,
 *     cf. `contentLineCount`), une section porte deux notions : elle se scinde.
 */
export function auditCoursePattern(lines: string[], where: string, level: PatternLevel): Flag[] {
  const flags: Flag[] = [];
  const sections = lessonSections(lines);

  // Une matière qui s'est mise sous patron doit s'en SERVIR. Sans ce contrôle, `coursePattern`
  // serait décoratif : tous les autres ne se déclenchent qu'en présence d'un bloc de savoir,
  // donc un cours qui n'en pose aucun les traverse tous en silence — et c'est exactement
  // l'état du corpus d'aujourd'hui (maths 9ᵉ : 54 `figure`, 1 `methode`, zéro `definition`).
  // Le contrôle ne vaut QUE dans le régime « error » : ailleurs, l'absence est le backlog.
  if (level === "error" && sections.length > 0) {
    const all = directiveSequence(lines);
    if (!all.some((t) => KNOWLEDGE_DIRECTIVES.has(t)) && !all.includes("exemple")) {
      flags.push({
        level,
        where,
        msg: 'subject declares `coursePattern: "notion"` but this course carries no knowledge block and no worked example — the pattern is a way of writing, not a flag (é35 C-1)',
      });
    }
  }

  for (const section of sections) {
    const seq = directiveSequence(section.lines);
    const at = `${where} § ${section.title} (l.${section.start})`;

    const knowledgeIdx = seq.findIndex((t) => KNOWLEDGE_DIRECTIVES.has(t));
    if (knowledgeIdx > -1 && !seq.includes("exemple")) {
      flags.push({
        level,
        where: at,
        msg: "section poses a rule (definition/propriete/methode) with no `::: exemple` — a rule without a worked example is not taught (é35 C-1)",
      });
    }

    if (knowledgeIdx > -1) {
      // Ce qui précède la PREMIÈRE directive de savoir : de la prose, ou une figure ?
      const firstKnowledge = section.lines.findIndex((l) => {
        const o = DIRECTIVE_OPEN.exec(l);
        return o !== null && KNOWLEDGE_DIRECTIVES.has(o[1]);
      });
      const before = section.lines.slice(0, firstKnowledge);
      // De la prose : les lignes non vides qui ne sont ni une directive, ni un `:::` de
      // fermeture, ni un `<svg>` — c'est ce qui AMÈNE la règle.
      const prose = before.filter(
        (l) =>
          l.trim() &&
          !DIRECTIVE_OPEN.test(l) &&
          !DIRECTIVE_CLOSE.test(l) &&
          !SVG_BLOCK.test(l) &&
          !l.trim().startsWith("</svg"),
      ).length;
      // Une figure d'ancrage vaut l'amorce : montrer la situation est une façon de la poser.
      const figure = before.some((l) => {
        const o = DIRECTIVE_OPEN.exec(l);
        return (o !== null && o[1] === "figure") || SVG_BLOCK.test(l);
      });
      if (prose < 2 && !figure) {
        flags.push({
          level,
          where: at,
          msg: "section opens straight on its rule — anchor it first in a concrete situation and the question it raises (é35 C-2)",
        });
      }
    }

    if (seq.includes("exemple") && !seq.includes("verifie")) {
      flags.push({
        level,
        where: at,
        msg: "section shows a worked example but never lets the student try one — add a `::: verifie` (é35 C-3)",
      });
    }

    const measured = contentLineCount(section.lines);
    if (measured > 60) {
      flags.push({
        level: "warn",
        where: at,
        msg: `section runs ${measured} content lines — over 60 it carries two notions; split it (é35 C-6)`,
      });
    }
  }

  return flags;
}

/** C-4 — la forme d'un `::: verifie` : un séparateur, deux côtés non vides (é35 R-16/R-17). */
export function auditCheckBlock(block: { line: number; body: string[] }, where: string): Flag[] {
  const split = block.body.findIndex((l) => CHECK_SPLIT.test(l));
  if (split === -1) {
    return [
      {
        level: "error",
        where,
        msg: `\`::: verifie\` (l.${block.line}) has no \`---\` separator — question above, answer below, or the answer shows unfolded (é35 C-4)`,
      },
    ];
  }
  const question = block.body.slice(0, split).some((l) => l.trim());
  const answer = block.body.slice(split + 1).some((l) => l.trim());
  if (!question || !answer) {
    return [
      {
        level: "error",
        where,
        msg: `\`::: verifie\` (l.${block.line}) has an empty ${question ? "answer" : "question"} — both sides of the \`---\` carry text (é35 C-4)`,
      },
    ];
  }
  return [];
}

/**
 * C-5 (suite) — les erreurs typiques DÉCLARÉES par le chapitre (étude 35, R-5/D-5).
 *
 * `chapter.json` → `coursePitfalls` nomme, avec le vocabulaire du registre, les erreurs que
 * le cours montre et corrige. Deux contrôles, et le second est celui qui compte : un tag
 * inconnu du registre est une faute de frappe, mais un tag qu'AUCUN distracteur du chapitre
 * n'encode est une boucle qui ne se referme pas — le cours enseignerait contre une erreur que
 * les exercices ne mesurent jamais. La déclaration devient alors un fait vérifiable, pas une
 * intention.
 *
 * Et dans l'autre sens : une matière qui s'est mise sous patron déclare ses erreurs, sinon
 * rien ne distingue « ce chapitre n'en a pas » de « personne n'y a pensé ».
 */
export function auditCoursePitfalls(
  declared: string[] | undefined,
  chapterTags: Set<string>,
  knownTags: Set<string>,
  where: string,
  level: PatternLevel,
): Flag[] {
  const flags: Flag[] = [];

  for (const tag of declared ?? []) {
    if (!knownTags.has(tag)) {
      flags.push({
        level: "error",
        where,
        msg: `coursePitfalls: unknown misconception tag \`${tag}\` — declare it in content/misconceptions.json first`,
      });
      continue;
    }
    if (!chapterTags.has(tag)) {
      flags.push({
        level: "error",
        where,
        msg: `coursePitfalls: \`${tag}\` is taught against but no distractor of this chapter encodes it — the course would fight an error the exercises never measure (é35 C-5)`,
      });
    }
  }

  if (level === "error" && (declared ?? []).length === 0) {
    flags.push({
      level,
      where,
      msg: "chapter under the notion pattern declares no coursePitfalls — name at least the one classic mistake its course corrects (é35 C-5)",
    });
  }

  return flags;
}

/* ============================================================================
   Leçons (`cours.md` / `resume.md`) — étude 18, lot 4.

   Jusqu'ici, `content:qa` ne lisait QUE les questions : les 541 leçons étaient
   hors de tout gate déterministe, et c'est précisément pour cela que la dérive
   « aucune figure en géométrie » a pu durer sans qu'aucune CI ne bronche.
   ========================================================================== */

/**
 * Miroir de `DIRECTIVE_TYPES` dans `src/shared/lib/lesson-blocks.ts` — garder en phase.
 * Un test de synchronisation échoue si les deux listes divergent (`qa-lesson.test.ts`) :
 * un type que le renderer connaît et que le gate ignore laisserait passer une faute, et
 * l'inverse ferait rougir un contenu parfaitement rendu.
 */
const LESSON_DIRECTIVES = new Set([
  "definition",
  "propriete",
  "exemple",
  "methode",
  "figure",
  "piege",
  "astuce",
  "retenir",
  "verifie",
]);

const DIRECTIVE_OPEN = /^:::[ \t]+([a-z]+)(?:[ \t]+(.*))?$/;
const DIRECTIVE_CLOSE = /^:::[ \t]*$/;

/**
 * Chapitres dont les notions sont intrinsèquement SPATIALES : y énoncer une règle sur des
 * formes sans la dessiner est une non-conformité (axe 5 « Illustration »). Testé sur le SLUG
 * du chapitre. Liste normative : `content-engine/references/course-figures.md` — garder les
 * deux en phase.
 */
const SPATIAL_CHAPTER =
  // Formes & espace. `ligne`/`reperage`/`forme` ajoutés le 2026-07-14 : le chapitre
  // «التموقع في الفضاء» (`07-reperage-espace`) et «الخطوط» (`10-lignes`, `07-formes-lignes`)
  // du primaire — les plus visuels qui soient pour un enfant de 6  ans — passaient inaperçus.
  /thales|thal[eè]s|pythagore|triangle|g[ée]om[ée]tri|forme|cercle|angle|vecteur|rep[eè]re|espace|solide|sym[ée]trie|translation|rotation|quart.?tour|homoth[ée]tie|section|perim[eè]tre|p[ée]rim[eè]tre|quadrilat[eè]re|polygone|trigo|prisme|pyramide|c[oô]ne|cylindre|sph[eè]re|droites|ligne/i;

/**
 * Deuxième famille — les notions qui se LISENT sur un graphique. Une leçon sur les fonctions
 * linéaires sans sa droite, ou sur les statistiques sans son diagramme, souffre exactement du
 * même défaut qu'une géométrie sans triangle : elle décrit ce qu'il fallait montrer.
 * Ajoutée le 2026-07-14 en illustrant math-1ere-sec — la première version de la liste ne
 * couvrait que les formes, et laissait passer `12-fonctions-lineaires` et
 * `16-exploitation-information` sans le moindre dessin.
 */
const GRAPHICAL_CHAPTER =
  /fonction|graphique|diagramme|statistiq|donn[ée]es|exploitation.?information|frise|chronolog/i;

/**
 * Audit d'une leçon. Contrôles :
 *  - directives `:::` : type inconnu, non fermée, `:::` orphelin, `::: figure` sans légende ;
 *  - la leçon DÉSIGNE une figure (« ci-dessous », « الشكل المجاور »…) mais n'en porte aucune ;
 *  - chapitre spatial sans la moindre figure ;
 *  - notation (viewBox, bidi, virgule arabe, LaTeX, chiffres arabo-indiens) — via
 *    `auditRenderedFields`, dont c'est le tout premier passage sur des leçons.
 */
export function auditLesson(
  md: string,
  where: string,
  opts: { spatial?: boolean; pattern?: PatternLevel; summary?: boolean } = {},
): Flag[] {
  const flags: Flag[] = [];
  // `\r?\n` et non `\n` : un checkout Windows matérialise le corpus en CRLF, et
  // un `split("\n")` laisse alors un `\r` en fin de chaque ligne. Les directives
  // sont reconnues par des regex ancrées sur `$` (`::: figure …`, `:::`), qui
  // cessent toutes de matcher — l'ouverture n'est plus vue, et la fermeture est
  // rapportée « stray `:::` closes nothing ». Le gate inventait donc deux
  // erreurs par chapitre à figure, en local seulement : la CI (Linux, checkout
  // LF) restait verte, ce qui rendait l'écart incompréhensible côté auteur.
  const lines = md.split(/\r?\n/);

  let open: { type: string; line: number; body: string[] } | null = null;
  for (let i = 0; i < lines.length; i++) {
    const opener = DIRECTIVE_OPEN.exec(lines[i]);
    if (opener) {
      const [, type, caption] = opener;
      if (open) {
        flags.push({
          level: "error",
          where,
          msg: `directive \`::: ${open.type}\` (l.${open.line}) is never closed — \`::: ${type}\` opens at l.${i + 1}`,
        });
      }
      if (!LESSON_DIRECTIVES.has(type)) {
        flags.push({
          level: "error",
          where,
          msg: `unknown block directive \`::: ${type}\` (l.${i + 1}) — allowed: ${[...LESSON_DIRECTIVES].join(", ")}`,
        });
      }
      if (type === "figure" && !(caption ?? "").trim()) {
        flags.push({
          level: "error",
          where,
          msg: `\`::: figure\` (l.${i + 1}) carries no caption — every course figure is captioned and numbered`,
        });
      }
      if (type === "verifie" && opts.summary) {
        // R-21 : le résumé ne pose pas de question, il sert la révision. Et son renderer
        // n'a pas de grammaire de blocs : un `::: verifie` y afficherait sa réponse en clair.
        flags.push({
          level: "error",
          where,
          msg: `\`::: verifie\` (l.${i + 1}) has no place in a summary — the revision cards answer, they do not ask (é35 R-21)`,
        });
      }
      open = { type, line: i + 1, body: [] };
      continue;
    }
    if (DIRECTIVE_CLOSE.test(lines[i])) {
      if (!open) {
        flags.push({ level: "error", where, msg: `stray \`:::\` (l.${i + 1}) closes nothing` });
      }
      // C-4 « la réponse est repliée » : un `::: verifie` a un séparateur et DEUX côtés
      // non vides. Sans cela le renderer dégrade en bloc neutre — la réponse s'affiche donc
      // sous la question, et le contrôle ne contrôle plus rien.
      if (open?.type === "verifie") flags.push(...auditCheckBlock(open, where));
      open = null;
      continue;
    }
    if (open) open.body.push(lines[i]);
  }
  if (open) {
    flags.push({
      level: "error",
      where,
      msg: `directive \`::: ${open.type}\` (l.${open.line}) is never closed`,
    });
  }

  const hasFigure = SVG_BLOCK.test(md);

  // Le contrôle le plus discriminant : la leçon parle d'une image absente.
  if (!hasFigure && FIGURE_REFERENCE.test(md)) {
    flags.push({
      level: "error",
      where,
      msg: "the lesson points at a figure («ci-dessous», «الشكل المجاور»…) but carries none — the student is sent to an image that does not exist",
    });
  }

  // C-5a « l'erreur est nommée » : un cours qui ne montre AUCUNE erreur typique laisse
  // l'élève la découvrir au quiz. Le piège s'écrit en directive (`::: piege`) ou en callout
  // promu (`> ⚠️`) — les deux comptent, et le corpus emploie massivement le second.
  //
  // Le contrôle ne vaut que pour un vrai COURS, reconnu à ses sections : un fragment sans un
  // seul `##` n'est pas une leçon à laquelle réclamer un piège. Même raison que pour les
  // contrôles de patron, qui itèrent sur les sections et n'ont rien à dire sans elles.
  if (!opts.summary && lessonSections(lines).length > 0) {
    const hasPitfall =
      lines.some((l) => {
        const o = DIRECTIVE_OPEN.exec(l);
        return o !== null && o[1] === "piege";
      }) || /^>[ \t]?⚠/m.test(md);
    if (!hasPitfall) {
      flags.push({
        level: opts.pattern ?? "warn",
        where,
        msg: "course shows no classic mistake at all — name the error where the confusion is born, and correct it (é35 C-5)",
      });
    }
  }

  // Axe 5 « Illustration » : un chapitre de formes enseigné sans un seul dessin.
  if (opts.spatial && !hasFigure) {
    flags.push({
      level: "warn",
      where,
      msg: "spatial chapter with no figure at all — a rule about shapes taught without a drawing (course-quality.md, axis 5)",
    });
  }

  // `markdown: true` : une leçon EST du Markdown (`src/shared/lib/markdown.ts` la
  // parse), donc `**gras**` et `## Titre` y sont la notation attendue — la garde
  // « piège n°6 » ne vaut que pour les champs rendus en texte brut.
  flags.push(...auditRenderedFields([["lesson", md]], where, { markdown: true }));

  // Le patron de notion (étude 35) — sur le COURS seulement : un résumé est une compression,
  // il n'explique pas, et lui demander un exemple par règle serait lui demander d'être le cours.
  if (!opts.summary) flags.push(...auditCoursePattern(lines, where, opts.pattern ?? "warn"));

  // C-7 sur les DEUX : le résumé a fui autant que le cours (« القيم donnent المعدّل »), et
  // c'est la surface que l'élève relit la veille du devoir.
  flags.push(...auditScriptMixing(lines, where, opts.pattern ?? "warn"));

  return flags;
}

/**
 * Troisième famille — les notions qui se lisent sur un **schéma légendé** : un mécanisme, un
 * cycle, une coupe. Un séisme, un volcan, une plaque qui plonge, un croisement génétique — on
 * ne les DÉCRIT pas, on les montre et on les annote.
 *
 * Ajoutée le 2026-09-17 en généralisant é35 au concours 9ᵉ : les deux familles précédentes
 * sont bâties sur du vocabulaire français et mathématique, et les chapitres de
 * `sciences-vie-terre` portent des slugs translittérés de l'arabe (`zalazil`, `barakin`,
 * `safaih-taktuniya`) qui ne ressemblent à rien qu'elles connaissent.
 *
 * ⚠️ **Elle se teste sur des SEGMENTS de slug, jamais en sous-chaîne libre, et jamais sur le
 * titre arabe.** La première version faisait les deux, et a reproduit en arabe très exactement
 * le défaut qu'elle corrigeait en français : `ضوء` (lumière) attrapé À L'INTÉRIEUR de وضوء
 * (ablution) sur six chapitres d'éducation islamique, et `takathur` dans **سورة التكاثر**, une
 * sourate. Le titre arabe semblait le signal le plus stable — un slug n'est qu'une
 * translittération de convenance — mais la morphologie arabe (préfixes ال، و، ب، ل) rend la
 * sous-chaîne inexploitable : اـلضوء et وـضوء se ressemblent trop. Le segment de slug, lui,
 * est délimité par des tirets et se teste exactement.
 */
// Mots ENTIERS, au singulier : le pluriel français est toléré (`seismes`, `volcans`), rien
// d'autre — `03-seismes-et-volcans` échouait sans cela, et c'est la forme la plus naturelle.
const SCHEMA_EXACT =
  "s[ée]isme|volcan|chromosome|reproduction|zalazil|zalzal|barakin|burkan|safaih|taktuniya|wiratha|manaa|takathur-insan";
// PRÉFIXES, dont la terminaison varie avec la langue et la fonction : tectonique/tectonic,
// hérédité/héréditaire, génétique/génétiques, immunité/immunitaire.
const SCHEMA_PREFIX = "tectoni|h[ée]r[ée]dit|g[ée]n[ée]tiq|immunit";
const SCHEMA_CHAPTER = new RegExp(
  `(?:^|[-_ ])(?:(?:${SCHEMA_EXACT})s?|(?:${SCHEMA_PREFIX})[a-z]*)(?:[-_ ]|$)`,
  "i",
);

/**
 * Ce qui nomme une notion de GRAMMAIRE n'est jamais un chapitre de formes, quoi qu'en disent
 * les deux premières familles. Deux faux positifs mesurés le 2026-09-17 sur `french` 9ᵉ :
 * `01-types-et-formes-de-phrases` déclenchait sur « **forme** » (qui y veut dire forme
 * grammaticale, pas forme géométrique) et `02-propositions-subordonnees` sur « donn[ée]es »,
 * attrapé À L'INTÉRIEUR de « subor-**donnees** » — un mot coupé en plein milieu.
 *
 * L'exclusion passe AVANT les familles, et c'est la règle honnête : exiger un dessin d'une
 * leçon sur les subordonnées, c'est réclamer une figure qui n'existe pas, et un auteur qui
 * obéit à un signal faux produit du remplissage.
 */
const GRAMMAR_CHAPTER =
  /phrase|subordonn|proposition|verbal|conjug|discours|lexique|grammai|orthograph|vocabulair/i;

/** Le chapitre relève-t-il d'une famille où la figure est exigible ? (axe 5) */
export function isSpatialChapter(slug: string): boolean {
  if (GRAMMAR_CHAPTER.test(slug)) return false;
  return SPATIAL_CHAPTER.test(slug) || GRAPHICAL_CHAPTER.test(slug) || SCHEMA_CHAPTER.test(slug);
}

/* ============================================================================
   C-7 — « une glose, pas une phrase » (é35 R-14, amendée le 2026-09-17)
   ========================================================================== */

/**
 * Lettres latines, et RIEN d'autre.
 *
 * ⚠️ Ne JAMAIS écrire cette classe `[A-Za-zÀ-ÿ]` : le bloc Latin-1 contient, entre ses
 * lettres accentuées, deux OPÉRATEURS — `×` (U+00D7) et `÷` (U+00F7). Une classe naïve les
 * avale comme des lettres, et `k×a` devient alors « un mot latin de trois lettres ». C'est
 * exactement la faute que `qa-checks.ts` a déjà consignée en miroir sur l'arabe (la virgule
 * U+060C n'est pas une lettre) ; elle a coûté ici 10 faux positifs sur 18 avant d'être vue.
 */
const LATIN_LETTER = "A-Za-z\\u00C0-\\u00D6\\u00D8-\\u00F6\\u00F8-\\u00FF";

/** Un mot latin : trois lettres au moins, pour ne pas mordre sur `a`, `x`, `cm`, `AB`. */
const LATIN_WORD = new RegExp(`(?<![(\\w])[${LATIN_LETTER}][${LATIN_LETTER}']{2,}`, "gu");

/**
 * Ce qui est de la NOTATION, pas un terme — donc hors de R-14, qui ne parle que des termes.
 *
 * Deux familles, et deux seulement : les symboles d'unités de trois lettres ou plus (les
 * autres — `cm`, `km`, `kg` — ne peuvent pas matcher) et les noms de fonctions
 * mathématiques. Un symbole d'unité ou `cos` n'a pas d'équivalent arabe à mettre devant :
 * les gloser serait absurde, et les interdire ferait rougir un tableau d'unités parfaitement
 * correct. Mesuré sur le corpus au 2026-09-17 : `min` (6×, math-4eme) et `dam` (2×,
 * math-5eme) sont les SEULES occurrences réelles ; les fonctions ne sortent jamais des
 * formules. La liste est donc volontairement courte — chaque ajout est un trou.
 */
const NOTATION_WORDS = new Set([
  // unités métriques ≥ 3 lettres
  "dam",
  "dal",
  "dag",
  "min",
  "mol",
  // fonctions et opérateurs nommés
  "cos",
  "sin",
  "tan",
  "cot",
  "log",
  "exp",
  "abs",
  "max",
  "arccos",
  "arcsin",
  "arctan",
  "pgcd",
  "ppcm",
]);

/**
 * Ce que R-14 AUTORISE, retiré de la ligne avant de chercher : la glose entre parenthèses
 * (`**الوتر** (hypoténuse)`), le code entre accents graves, les formules `$$…$$`, et les
 * groupes entre crochets, qui nomment des points (`[BC]`, `(AB)`).
 */
const R14_ALLOWED = /\([^)]*\)|`[^`]*`|\$\$[\s\S]*?\$\$|\[[^\]]*\]/g;

/**
 * Le PRÉFIXE d'une directive (`::: figure`, `::: exemple`) — un mot-clé de la grammaire de
 * é18, pas de la prose. Seul le préfixe tombe : la LÉGENDE qui suit reste contrôlée, parce
 * qu'elle est lue par l'élève comme le reste. Retirer la ligne entière aurait été plus simple
 * et aurait ouvert un trou grand comme une légende — mesuré : sans cette distinction, le
 * mot-clé `figure` à lui seul faisait 500 des 550 constats du premier jet.
 */
const DIRECTIVE_PREFIX = /^:::[ \t]*[a-z]*/;

/**
 * C-7 « une glose, pas une phrase ».
 *
 * R-14 amendée autorise le terme français **entre parenthèses**, à sa première apparition :
 * l'élève qui apprend الوتر en 9ᵉ rencontre « hypoténuse » au lycée, et c'est la 9ᵉ qui doit
 * lui passer le couple. Ce qu'elle interdit est l'inverse exact : une PHRASE à moitié
 * française au milieu d'une proposition arabe — « ثلاث نسب égales, pas deux », « ثلاثة عدّات
 * différentes ». L'élève arabophone y bute sur une syntaxe qu'il n'a pas apprise, là où une
 * étiquette entre parenthèses se saute sans rien perdre.
 *
 * Ce contrôle existe parce que la règle a fuité TROIS FOIS dans la seule campagne pilote,
 * dont deux après une passe de purge manuelle. Une règle qu'aucune machine ne tient revient.
 *
 * ⚠️ Il ne renifle PAS la prose (D-7 tient) : il lit le SCRIPT des caractères, jamais leur
 * sens. Il ne sait pas le français de l'anglais, ni une bonne phrase d'une mauvaise — il sait
 * qu'un mot en lettres latines se tient hors des trois endroits où R-14 en autorise un.
 *
 * Portée : le COURS et le RÉSUMÉ (les deux ont fui), et seulement les lignes qui portent de
 * la prose arabe — une leçon en français n'est pas concernée.
 */
export function auditScriptMixing(lines: string[], where: string, level: PatternLevel): Flag[] {
  const flags: Flag[] = [];
  // La question se pose au DOCUMENT, pas à la ligne. Une leçon de français ou d'anglais qui
  // cite le nom arabe de l'examen (« ختم التعليم الأساسي ») n'est pas une leçon arabe, et la
  // juger ligne à ligne la faisait rougir deux fois. `rendersRtl` porte déjà exactement cette
  // distinction pour les questions — la réutiliser plutôt que la réinventer.
  if (!rendersRtl(lines.join("\n"))) return flags;

  let inSvg = false;

  for (let i = 0; i < lines.length; i++) {
    const raw = lines[i];
    // Le corps d'une figure est plein d'attributs latins (`viewBox`, `stroke`) : il n'est
    // pas de la prose, et le traverser ferait rougir toute leçon illustrée.
    if (inSvg) {
      if (/<\/svg>/i.test(raw)) inSvg = false;
      continue;
    }
    if (/<svg\b/i.test(raw)) {
      if (!/<\/svg>/i.test(raw)) inSvg = true;
      continue;
    }
    if (!ARABIC_PROSE_RE.test(raw)) continue;

    const probe = raw.replace(DIRECTIVE_PREFIX, " ").replace(R14_ALLOWED, " ");
    const found = [...probe.matchAll(LATIN_WORD)]
      .map((m) => m[0])
      // Une majuscule initiale nomme un point, un théorème ou une personne (`ABCD`,
      // `Thalès`, `Pythagore`) — jamais une phrase française qui coule dans l'arabe.
      .filter((w) => w[0] === w[0].toLowerCase() && !NOTATION_WORDS.has(w.toLowerCase()));

    if (found.length > 0) {
      flags.push({
        level,
        where: `${where} (l.${i + 1})`,
        msg: `Latin words sit in Arabic prose outside a parenthesised gloss: ${found
          .slice(0, 4)
          .map((w) => `«${w}»`)
          .join(
            ", ",
          )} — R-14 allows the French TERM in parentheses, never a French phrase inside an Arabic clause (é35 C-7)`,
      });
    }
  }

  return flags;
}
