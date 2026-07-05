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
import { loadAllSubjects, loadSubject } from "../../src/shared/content/loader.ts";
import { auditBoardQuestion, auditNumericQuestion, auditQuestion, type Flag } from "./qa-checks.ts";

const hasFlag = (n: string) => argv.includes(`--${n}`);
const getFlag = (n: string) => {
  const i = argv.indexOf(`--${n}`);
  return i !== -1 ? argv[i + 1] : undefined;
};

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
          // Per-type lints (Tier B): numeric has its own audit; mcq keeps the
          // historical one. Future types get theirs when their phase ships.
          flags.push(
            ...(q.type === "numeric"
              ? auditNumericQuestion(q, where)
              : q.type === "ordering" || q.type === "matching"
                ? auditBoardQuestion(q, where)
                : auditQuestion(q, where)),
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
