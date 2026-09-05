/**
 * Content QA — heuristic double-check of answer keys (AI-authored content).
 *
 * Thin CLI over the pure checks in qa-checks.ts. Beyond structural Zod validation
 * (`content:check`), this flags *suspicious* corrigés for human review. It cannot
 * prove a free-text answer is correct, so it favours HIGH-PRECISION signals.
 *
 * Usage:
 *   node --experimental-strip-types scripts/content/qa.ts [--strict] [--subject <id>]
 * `--strict` exits 1 when any [error] is found (for CI); otherwise exits 0.
 */
import { argv, cwd, exit, stdout } from "node:process";
import { join, resolve } from "node:path";
import {
  expandSubjects,
  loadAllSubjects,
  loadCompetencyRegistries,
  loadMisconceptionRegistry,
  loadSubject,
  loadVideosRegistry,
} from "../../src/shared/content/loader.ts";
import {
  auditAcceptedAnswers,
  auditBoardQuestion,
  auditChapterDomains,
  auditCompetencyRefs,
  auditLesson,
  auditMisconceptionTags,
  auditShortAnswerQuestion,
  auditNumericQuestion,
  auditQuestion,
  auditVideoRefs,
  auditVideoRegistry,
  isSpatialChapter,
  type CompetencyVocabulary,
  type Flag,
} from "./qa-checks.ts";
import { auditExerciseManuelPages, auditManuelRefs } from "./qa-manuel-refs.ts";
import { auditVerbatim, buildVerbatimIndex, questionTextSurface } from "./verbatim-checks.ts";
import { loadCnpCorpusFiles, loadSurveilledSources } from "./programmes-io.ts";

const hasFlag = (n: string) => argv.includes(`--${n}`);
const getFlag = (n: string) => {
  const i = argv.indexOf(`--${n}`);
  return i !== -1 ? argv[i + 1] : undefined;
};

function main(): void {
  const root = cwd();
  const contentDir = resolve(root, "content");
  const only = getFlag("subject");
  // QA audits COMPILED subjects (étude 16 D-4): a shared dir is checked once
  // per section target, exactly as it will land in the DB.
  const subjects = expandSubjects(
    only ? [loadSubject(join(contentDir, only))] : loadAllSubjects(contentDir),
  );
  const knownTags = new Set(Object.keys(loadMisconceptionRegistry(contentDir)));

  // Competency vocabulary (étude 07): declared ids + family→subject coverage.
  const registries = loadCompetencyRegistries(contentDir);
  const competencyVocab: CompetencyVocabulary = {
    ids: new Set(registries.flatMap((r) => r.competencies.map((c) => c.id))),
    subjectPrefixes: new Map(registries.map((r) => [r.family, r.subjectPrefixes])),
  };

  // Curated-video registry (étude 23): registry-level invariants once, then
  // per-chapter / per-exercise ref cross-checks against it.
  const videos = loadVideosRegistry(contentDir);

  // Codes manuel (liens « Manuel officiel ») : le registre CNP dit quels
  // documents existent vraiment. Le compte est imprimé même quand le contrôle
  // se met en veille — un gate muet ne se distingue pas d'un gate absent.
  const corpusFiles = loadCnpCorpusFiles();
  stdout.write(
    corpusFiles === null
      ? "• codes manuel : corpus CNP non branché — contrôle des liens « Manuel officiel » désarmé.\n"
      : `• codes manuel : ${corpusFiles.size} document(s) au corpus CNP — liens « Manuel officiel » contrôlés.\n`,
  );

  // Garde anti-verbatim (étude 27 R-8/D-7) : les séquences de mots des sources
  // externes NON autorisées ne doivent réapparaître dans aucun texte généré.
  // L'index est vide tant qu'aucune fiche `source-web` n'existe — le compte est
  // imprimé quand même, un gate muet ne se distingue pas d'un gate absent.
  const surveilled = loadSurveilledSources(contentDir);
  const verbatim = buildVerbatimIndex(surveilled);
  stdout.write(
    surveilled.length === 0
      ? "• garde anti-verbatim (étude 27 R-8) : 0 source sous surveillance — rien à comparer.\n"
      : `• garde anti-verbatim (étude 27 R-8) : ${surveilled.length} source(s) surveillée(s) ` +
          `(${surveilled.map((s) => s.slug).join(", ")}), ` +
          `${verbatim.grams.size} séquences de ${verbatim.n} mots indexées.\n`,
  );

  const flags: Flag[] = [];
  flags.push(...auditVideoRegistry(videos, competencyVocab.ids));

  for (const subject of subjects) {
    // Domaines de programme (« sections » de la matière) — une passe par MATIÈRE,
    // pas par chapitre : la faute qu'on cherche (deux graphies d'un même domaine,
    // moitié des chapitres non rattachés) n'existe qu'entre chapitres frères.
    flags.push(
      ...auditChapterDomains(
        subject.chapters.map((c) => ({ slug: c.slug, domain: c.meta.domain })),
        `${subject.meta.id}/domaines`,
        subject.meta.gradeSlug,
      ),
    );

    // Volumes du manuel déclarés par la MATIÈRE — repli du lecteur quand le
    // chapitre ne porte pas ses propres pages.
    flags.push(
      ...auditManuelRefs(
        (subject.meta.manuels ?? []).map((m) => m.code),
        corpusFiles,
        `${subject.meta.id}/manuels`,
      ),
    );

    for (const chapter of subject.chapters) {
      // Les LEÇONS entrent enfin dans le gate (étude 18, lot 4). Jusqu'ici la QA ne
      // parcourait que les questions : les 541 `cours.md` / `resume.md` n'avaient jamais
      // été inspectés — d'où une dérive (« aucune figure en géométrie ») qu'aucune CI ne
      // pouvait voir. Les contrôles de notation (bidi, virgule arabe, viewBox) s'y
      // appliquent donc pour la toute première fois.
      const spatial = isSpatialChapter(chapter.slug);
      flags.push(
        ...auditLesson(chapter.lesson, `${subject.meta.id}/${chapter.slug}/cours`, { spatial }),
        ...auditLesson(chapter.summary, `${subject.meta.id}/${chapter.slug}/resume`),
        // Le cours est la surface de copie la plus exposée : c'est là qu'un
        // encadré « verbatim » d'une fiche source atterrirait le plus vite.
        ...auditVerbatim(chapter.lesson, verbatim, `${subject.meta.id}/${chapter.slug}/cours`),
        ...auditVerbatim(chapter.summary, verbatim, `${subject.meta.id}/${chapter.slug}/resume`),
      );

      // Video refs (étude 23): chapter section + per-exercise correction video,
      // checked against the subject's language of instruction.
      const lang = subject.meta.contentLanguage;
      flags.push(
        ...auditManuelRefs(
          chapter.meta.manuel ? [chapter.meta.manuel.code] : [],
          corpusFiles,
          `${subject.meta.id}/${chapter.slug}`,
        ),
        ...auditVideoRefs(
          chapter.meta.videos ?? [],
          videos,
          lang,
          `${subject.meta.id}/${chapter.slug}`,
        ),
      );
      for (const ex of chapter.exercises) {
        // Reprise du manuel (étude 21 §3.5) : cohérence de pages, advisory.
        flags.push(
          ...auditExerciseManuelPages(
            ex.data.manuel,
            chapter.meta.manuel,
            `${subject.meta.id}/${chapter.slug}/${ex.slug}`,
          ),
        );
        if (ex.data.correctionVideo) {
          flags.push(
            ...auditVideoRefs(
              [ex.data.correctionVideo],
              videos,
              lang,
              `${subject.meta.id}/${chapter.slug}/${ex.slug}`,
            ),
          );
        }
      }

      // Check the chapter quiz too (its questions also have answer keys).
      const groups: Array<{ slug: string; questions: typeof chapter.quiz.questions }> = [
        { slug: "quiz", questions: chapter.quiz.questions },
        ...chapter.exercises.map((e) => ({ slug: e.slug, questions: e.data.questions })),
      ];

      for (const g of groups) {
        g.questions.forEach((q, i) => {
          const where = `${subject.meta.id}/${chapter.slug}/${g.slug} · Q${i + 1}`;
          // Per-type lints (Tier B): numeric has its own audit; mcq keeps the
          // historical one. Future types get theirs when their phase ships.
          flags.push(
            ...(q.type === "numeric"
              ? auditNumericQuestion(q, where)
              : q.type === "ordering" || q.type === "matching" || q.type === "multi"
                ? auditBoardQuestion(q, where)
                : q.type === "short_answer"
                  ? auditShortAnswerQuestion(q, knownTags, where)
                  : [...auditQuestion(q, where), ...auditMisconceptionTags(q, knownTags, where)]),
            // Competency refs apply to EVERY question type (étude 07 R-2).
            ...auditCompetencyRefs(q, subject.meta.id, competencyVocab, where),
            // Accepted-answer set (étude 20 R-4/R-5): also every type — the
            // guard's first job is to REJECT the field on a type that has no
            // scorer for it.
            ...auditAcceptedAnswers(
              {
                type: q.type,
                prompt: q.prompt,
                options: "options" in q ? q.options : [],
                correctOption: q.type === "mcq" ? q.correctOption : undefined,
                acceptedAnswers: q.acceptedAnswers,
                answerKey: q.type === "short_answer" ? q.answerKey : undefined,
                expectedMistakes: q.type === "short_answer" ? q.expectedMistakes : undefined,
              },
              where,
            ),
            // Anti-verbatim (étude 27 R-8) : énoncé, options et explication —
            // les trois champs qu'un auteur pourrait transposer d'une source.
            ...auditVerbatim(
              questionTextSurface({
                prompt: q.prompt,
                options: "options" in q ? q.options : undefined,
                explanation: q.explanation,
              }),
              verbatim,
              where,
            ),
          );
        });
      }
    }
  }

  const errors = flags.filter((f) => f.level === "error");
  const warns = flags.filter((f) => f.level === "warn");

  if (flags.length === 0) {
    stdout.write("✓ Content QA: no suspicious answer keys flagged.\n");
  } else {
    for (const f of flags) {
      stdout.write(`${f.level === "error" ? "✗ [error]" : "• [warn] "} ${f.where} — ${f.msg}\n`);
    }
    stdout.write(
      `\nContent QA: ${errors.length} error(s), ${warns.length} warning(s) to review.\n`,
    );
  }

  if (hasFlag("strict") && errors.length > 0) exit(1);
}

main();
