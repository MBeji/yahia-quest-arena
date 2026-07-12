/**
 * Program-conformance audit CLI.
 *
 * Diffs the authored content tree under `content/` against the per-grade
 * program manifests under
 * `.claude/skills/content-ecole-tn/references/programmes-officiels/manifest/`
 * and reports, per grade + subject:
 *   - coverage     — missing subjects, missing chapters, off-program chapters;
 *   - completeness — chapters lacking a course / summary / quiz / mission;
 *   - level-fit    — language mismatch vs the program.
 *
 * Advisory by default (always exits 0). With `--strict`, any finding on a
 * **sealed** grade (a grade declared complete in its manifest) fails the run —
 * the opt-in CI gate. Non-sealed grades never gate.
 *
 *   node --experimental-strip-types scripts/content/audit-program.ts [options]
 *
 * Options:
 *   --strict               Exit 1 if a SEALED grade has any finding.
 *   --grade <slug>         Audit a single grade (e.g. `1ere-base`).
 *   --manifest-dir <path>  Manifests root (default: the skill references path).
 *   --content-dir <path>   Content root (default: content).
 */
import { existsSync, readdirSync, readFileSync } from "node:fs";
import { basename, join, resolve } from "node:path";
import { argv, cwd, exit, stderr, stdout } from "node:process";
import {
  auditGrade,
  programManifestSchema,
  type GradeAudit,
  type SubjectAudit,
} from "../../src/shared/content/program-manifest.ts";
import {
  ContentValidationError,
  expandSubjects,
  loadAllSubjects,
} from "../../src/shared/content/loader.ts";

const DEFAULT_MANIFEST_DIR =
  ".claude/skills/content-ecole-tn/references/programmes-officiels/manifest";

function getFlag(name: string): string | undefined {
  const i = argv.indexOf(`--${name}`);
  return i !== -1 ? argv[i + 1] : undefined;
}
const hasFlag = (name: string): boolean => argv.includes(`--${name}`);

function loadManifests(dir: string, onlyGrade?: string) {
  if (!existsSync(dir)) {
    throw new ContentValidationError(`Manifest directory does not exist: ${dir}`);
  }
  return readdirSync(dir)
    .filter((f) => f.endsWith(".json"))
    .sort()
    .map((f) => {
      const filePath = join(dir, f);
      let raw: unknown;
      try {
        raw = JSON.parse(readFileSync(filePath, "utf8"));
      } catch (err) {
        throw new ContentValidationError(`Invalid JSON in ${filePath}: ${(err as Error).message}`);
      }
      const parsed = programManifestSchema.safeParse(raw);
      if (!parsed.success) {
        const issues = parsed.error.issues
          .map((i) => `  • ${i.path.join(".") || "<root>"}: ${i.message}`)
          .join("\n");
        throw new ContentValidationError(`Invalid manifest ${filePath}:\n${issues}`);
      }
      return { file: basename(f), manifest: parsed.data };
    })
    .filter(({ manifest }) => !onlyGrade || manifest.grade === onlyGrade);
}

/** ✓/✗/• status glyph for a subject line. */
function subjectGlyph(s: SubjectAudit): string {
  if (!s.present) return "✗";
  if (s.findings.length > 0) return "✗";
  return "✓";
}

function printGrade(g: GradeAudit): void {
  stdout.write(`\n━━ Niveau ${g.grade}  (scellé : ${g.sealed ? "oui" : "non"}) ━━\n`);
  let missingSubjects = 0;
  let missingChapters = 0;
  let offProgram = 0;
  let incomplete = 0;

  for (const s of g.subjects) {
    if (!s.present) {
      missingSubjects += 1;
      stdout.write(`  ✗ ${s.id.padEnd(26)} MATIÈRE MANQUANTE\n`);
      continue;
    }
    const cov =
      s.coveragePct === null
        ? "chapitres non codifiés"
        : `couverture ${s.presentExpected}/${s.expectedChapters} (${s.coveragePct}%)`;
    const incompleteHere = s.chapterCompleteness.filter((c) => !c.complete).length;
    incomplete += incompleteHere;
    missingChapters += s.missingChapters.length;
    offProgram += s.offProgramChapters.length;

    stdout.write(`  ${subjectGlyph(s)} ${s.id.padEnd(26)} ${cov}\n`);
    if (!s.languageOk && s.languageOk !== null) {
      stdout.write(`      ⚠ langue ≠ programme\n`);
    }
    for (const slug of s.missingChapters) stdout.write(`      − chapitre manquant : ${slug}\n`);
    for (const slug of s.offProgramChapters) stdout.write(`      + hors-programme : ${slug}\n`);
    for (const c of s.chapterCompleteness) {
      const mark = c.complete ? "·" : "✗";
      stdout.write(`      ${mark} ${c.slug} : ${c.issues.join(", ")}\n`);
    }
  }

  const present = g.subjects.filter((s) => s.present).length;
  stdout.write(
    `  Bilan : ${present}/${g.subjects.length} matières · ` +
      `${missingSubjects} matière(s) manquante(s) · ${missingChapters} chapitre(s) manquant(s) · ` +
      `${offProgram} hors-programme · ${incomplete} chapitre(s) incomplet(s)\n`,
  );
}

function main(): void {
  const root = cwd();
  const manifestDir = resolve(root, getFlag("manifest-dir") ?? DEFAULT_MANIFEST_DIR);
  const contentDir = resolve(root, getFlag("content-dir") ?? "content");
  const strict = hasFlag("strict");
  const onlyGrade = getFlag("grade");

  const manifests = loadManifests(manifestDir, onlyGrade);
  if (manifests.length === 0) {
    stderr.write(
      `No manifest found in ${manifestDir}${onlyGrade ? ` for grade '${onlyGrade}'` : ""}.\n`,
    );
    exit(onlyGrade ? 1 : 0);
  }

  // Program conformity is audited on COMPILED subjects (étude 16 D-4): each
  // grade manifest lists the per-section compiled ids, never a virtual source id.
  const subjects = expandSubjects(loadAllSubjects(contentDir));
  const audits = manifests.map(({ manifest }) => auditGrade(manifest, subjects));
  audits.forEach(printGrade);

  // Opt-in gate: only SEALED grades can fail the run, and only under --strict.
  const sealedFailures = audits.filter((a) => a.sealed && a.findingCount > 0);
  const totalFindings = audits.reduce((n, a) => n + a.findingCount, 0);

  stdout.write(
    `\n${audits.length} niveau(x) audité(s) · ${totalFindings} constat(s) au total` +
      `${sealedFailures.length > 0 ? ` · ${sealedFailures.length} niveau(x) scellé(s) en échec` : ""}.\n`,
  );

  if (strict && sealedFailures.length > 0) {
    stderr.write(
      `\n✗ Gate strict : ${sealedFailures.map((a) => a.grade).join(", ")} ` +
        `scellé(s) mais avec des constats. Complète le contenu ou retire 'sealed'.\n`,
    );
    exit(1);
  }
}

try {
  main();
} catch (err) {
  if (err instanceof ContentValidationError) {
    stderr.write(`\n✗ ${err.message}\n`);
  } else {
    stderr.write(`\n✗ Unexpected error: ${(err as Error).stack ?? String(err)}\n`);
  }
  exit(1);
}
