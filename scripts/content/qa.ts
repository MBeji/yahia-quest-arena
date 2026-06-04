/**
 * Content QA — heuristic double-check of answer keys (AI-authored content).
 *
 * Beyond the structural Zod validation (run via `content:check`), this flags
 * *suspicious* corrigés for human review. It cannot prove a free-text answer is
 * correct, so it favours HIGH-PRECISION signals (few false positives):
 *
 *   [error] duplicate option texts         → ambiguous question / likely mistake
 *   [warn]  value not echoed in explanation → for short "value" answers (numbers,
 *           short expressions), the correct option's text should appear in its
 *           explanation; if not, the key and the worked solution may disagree
 *   [warn]  thin explanation               → < 25 chars, low pedagogical quality
 *
 * Usage:
 *   node --experimental-strip-types scripts/content/qa.ts [--strict] [--subject <id>]
 * `--strict` exits 1 when any [error] is found (for CI); otherwise exits 0.
 */
import { argv, cwd, exit, stdout } from "node:process";
import { join, resolve } from "node:path";
import { loadAllSubjects, loadSubject } from "../../src/shared/content/loader.ts";

const hasFlag = (n: string) => argv.includes(`--${n}`);
const getFlag = (n: string) => {
  const i = argv.indexOf(`--${n}`);
  return i !== -1 ? argv[i + 1] : undefined;
};

/** Normalise for substring comparison: strip whitespace, fold Arabic-Indic digits, lowercase. */
function norm(s: string): string {
  const arabicDigits = "٠١٢٣٤٥٦٧٨٩";
  return s.replace(/[٠-٩]/g, (d) => String(arabicDigits.indexOf(d))).replace(/\s+/g, "");
}

/** All digit groups in a string (Arabic-Indic digits folded to Latin first). */
function numbersIn(s: string): string[] {
  const folded = s.replace(/[٠-٩]/g, (d) => String("٠١٢٣٤٥٦٧٨٩".indexOf(d)));
  return folded.match(/\d+(?:[.,]\d+)?/g) ?? [];
}

const hasArabic = (s: string) => /[؀-ۿ]/.test(s);

type Flag = { level: "error" | "warn"; where: string; msg: string };

function main(): void {
  const root = cwd();
  const contentDir = resolve(root, "content");
  const only = getFlag("subject");
  const subjects = only ? [loadSubject(join(contentDir, only))] : loadAllSubjects(contentDir);

  const flags: Flag[] = [];

  for (const subject of subjects) {
    for (const chapter of subject.chapters) {
      // Check the chapter quiz too (its questions also have answer keys).
      const groups: Array<{ slug: string; questions: typeof chapter.quiz.questions }> = [
        { slug: "quiz", questions: chapter.quiz.questions },
        ...chapter.exercises.map((e) => ({ slug: e.slug, questions: e.data.questions })),
      ];

      for (const g of groups) {
        g.questions.forEach((q, i) => {
          const where = `${subject.meta.id}/${chapter.slug}/${g.slug} · Q${i + 1}`;

          // 1) duplicate option texts (case-sensitive: "Na" and "na" are distinct).
          const texts = q.options.map((o) => norm(o.text));
          if (new Set(texts).size !== texts.length) {
            flags.push({ level: "error", where, msg: "duplicate option texts" });
          }

          // 2) numeric answer not echoed in the explanation. Only for symbolic /
          // numeric answers (no Arabic words — avoids morphology false positives);
          // checks each number in the answer appears among the explanation's numbers.
          const correct = q.options.find((o) => o.id === q.correctOption);
          // Only "value-like" answers (short) — full-sentence options contain
          // incidental numbers an explanation needn't echo.
          if (correct && !hasArabic(correct.text) && norm(correct.text).length <= 24) {
            const answerNums = numbersIn(correct.text);
            const explNums = new Set(numbersIn(q.explanation));
            const missing = answerNums.filter((n) => !explNums.has(n));
            if (answerNums.length > 0 && missing.length > 0) {
              flags.push({
                level: "warn",
                where,
                msg: `answer value(s) [${missing.join(", ")}] from "${correct.text}" not echoed in the explanation`,
              });
            }
          }

          // 3) thin explanation
          if (q.explanation.trim().length < 25) {
            flags.push({ level: "warn", where, msg: "explanation is very short" });
          }
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
