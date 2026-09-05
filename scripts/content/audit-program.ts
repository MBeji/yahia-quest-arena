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
 *   --json                 Rend la couverture manuel en JSON sur stdout (étude 21 lot 4).
 *                          stdout ne porte ALORS QUE ce JSON : le rapport lisible part sur
 *                          stderr, sans quoi `audit-program --json | jq` échoue sur la
 *                          première ligne du rapport — un flag machine dont la sortie
 *                          n'est pas parsable ne sert à rien.
 *
 * ⚠️ La section « couverture manuel » (étude 21) est **advisory par construction** :
 * elle n'entre jamais dans `findingCount`, donc jamais dans le gate `--strict`.
 * Une campagne en cours n'est pas une régression.
 */
import { join, resolve } from "node:path";
import { argv, cwd, exit, stderr, stdout } from "node:process";
import {
  auditGrade,
  type GradeAudit,
  type SubjectAudit,
} from "../../src/shared/content/program-manifest.ts";
import {
  ContentValidationError,
  expandSubjects,
  loadAllSubjects,
} from "../../src/shared/content/loader.ts";
import {
  coverageRate,
  subjectCoverage,
  type ChapterCoverageInput,
  type SubjectCoverage,
} from "../../src/shared/content/manuel-coverage.ts";
import { loadManifests, PROGRAMMES_REL } from "./programmes-io.ts";
import type { LoadedSubject } from "../../src/shared/content/schema.ts";
import type { ProgramManifest } from "../../src/shared/content/program-manifest.ts";

function getFlag(name: string): string | undefined {
  const i = argv.indexOf(`--${name}`);
  return i !== -1 ? argv[i + 1] : undefined;
}
const hasFlag = (name: string): boolean => argv.includes(`--${name}`);

/** ✓/✗/• status glyph for a subject line. */
function subjectGlyph(s: SubjectAudit): string {
  if (!s.present) return "✗";
  if (s.findings.length > 0) return "✗";
  return "✓";
}

/**
 * Le flux du rapport LISIBLE. `stdout` par défaut ; `stderr` sous `--json`, pour que
 * la sortie machine reste seule sur stdout (cf. l'en-tête). Fixé une fois par `main`.
 */
let report: NodeJS.WritableStream = stdout;

function printGrade(g: GradeAudit): void {
  report.write(`\n━━ Niveau ${g.grade}  (scellé : ${g.sealed ? "oui" : "non"}) ━━\n`);
  let missingSubjects = 0;
  let missingChapters = 0;
  let offProgram = 0;
  let incomplete = 0;

  for (const s of g.subjects) {
    if (!s.present) {
      missingSubjects += 1;
      report.write(`  ✗ ${s.id.padEnd(26)} MATIÈRE MANQUANTE\n`);
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

    report.write(`  ${subjectGlyph(s)} ${s.id.padEnd(26)} ${cov}\n`);
    if (!s.languageOk && s.languageOk !== null) {
      report.write(`      ⚠ langue ≠ programme\n`);
    }
    for (const slug of s.missingChapters) report.write(`      − chapitre manquant : ${slug}\n`);
    for (const slug of s.offProgramChapters) report.write(`      + hors-programme : ${slug}\n`);
    for (const c of s.chapterCompleteness) {
      const mark = c.complete ? "·" : "✗";
      report.write(`      ${mark} ${c.slug} : ${c.issues.join(", ")}\n`);
    }
  }

  const present = g.subjects.filter((s) => s.present).length;
  report.write(
    `  Bilan : ${present}/${g.subjects.length} matières · ` +
      `${missingSubjects} matière(s) manquante(s) · ${missingChapters} chapitre(s) manquant(s) · ` +
      `${offProgram} hors-programme · ${incomplete} chapitre(s) incomplet(s)\n`,
  );
}

/**
 * Couverture manuel (étude 21 lot 4) — croise ce que le manifeste DÉCLARE du
 * manuel avec ce que les missions déclarent REPRENDRE.
 *
 * Ne rend que les matières qui ont quelque chose à dire : une matière dont
 * aucun chapitre ne déclare de manuel et dont aucune mission ne trace de
 * reprise n'a pas de couverture à afficher — l'imprimer à zéro ferait passer
 * une matière hors périmètre pour une matière en retard.
 */
function manuelCoverage(
  manifests: readonly ProgramManifest[],
  subjects: readonly LoadedSubject[],
): SubjectCoverage[] {
  const byId = new Map(subjects.map((s) => [s.meta.id, s]));
  const out: SubjectCoverage[] = [];
  for (const manifest of manifests) {
    for (const expected of manifest.subjects) {
      const loaded = byId.get(expected.id);
      if (!loaded) continue;
      const chapters: ChapterCoverageInput[] = expected.chapters.map((declaredChapter) => {
        const chapter = loaded.chapters.find((c) => c.slug === declaredChapter.slug);
        return {
          slug: declaredChapter.slug,
          notion: declaredChapter.notion,
          ...(declaredChapter.manuel ? { declared: declaredChapter.manuel } : {}),
          ...(chapter?.meta.manuel ? { chapterManuelCode: chapter.meta.manuel.code } : {}),
          takenUp: (chapter?.exercises ?? []).flatMap((ex) =>
            ex.data.manuel
              ? [
                  {
                    exerciseSlug: ex.slug,
                    // Résolu par le loader — jamais `undefined` ici.
                    code: ex.data.manuel.code ?? "",
                    ...(ex.data.manuel.pages === undefined ? {} : { pages: ex.data.manuel.pages }),
                    items: ex.data.manuel.items,
                  },
                ]
              : [],
          ),
        };
      });
      const cov = subjectCoverage(expected.id, chapters);
      if (cov.declaredTotal > 0 || cov.takenUpTotal > 0) out.push(cov);
    }
  }
  return out;
}

/** La section imprimée. Rien ici n'entre dans `findingCount` (§3.5). */
function printCoverage(rows: readonly SubjectCoverage[]): void {
  if (rows.length === 0) return;
  report.write("\nCouverture des manuels élèves (advisory — hors gate)\n");
  for (const s of rows) {
    const rate = coverageRate(s);
    report.write(
      `  ${s.subjectId.padEnd(26)} ${s.takenUpTotal}/${s.declaredTotal}` +
        `${rate === null ? " (non mesurable)" : ` (${rate} %)`}` +
        `${s.unmeasurable > 0 ? ` · ${s.unmeasurable} chapitre(s) sans déclaration` : ""}\n`,
    );
    for (const c of s.chapters) {
      const notes: string[] = [];
      if (c.remaining && c.remaining.length > 0) notes.push(`reste : ${c.remaining.join(", ")}`);
      if (c.unknownItems.length > 0) notes.push(`hors plage : ${c.unknownItems.join(", ")}`);
      if (c.missingChapterManuel) notes.push("chapitre sans `manuel` (R-9)");
      if (c.codeMismatches.length > 0) notes.push(`autre livre : ${c.codeMismatches.join(", ")}`);
      if (notes.length > 0) report.write(`    − ${c.slug} — ${notes.join(" · ")}\n`);
    }
  }
}

function main(): void {
  const root = cwd();
  // Le chemin par défaut est RÉSOLU sous `root`, jamais recopié ici : trois copies de la
  // même constante vivaient dans trois fichiers, et c'est ce qui faisait du déplacement de
  // l'arbre un chantier à quatre fichiers plutôt qu'à un.
  const manifestDir = resolve(root, getFlag("manifest-dir") ?? join(PROGRAMMES_REL, "manifest"));
  const contentDir = resolve(root, getFlag("content-dir") ?? "content");
  const strict = hasFlag("strict");
  const asJson = hasFlag("json");
  report = asJson ? stderr : stdout;
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

  // Couverture manuel (étude 21 lot 4) — advisory, jamais dans `findingCount`.
  const coverage = manuelCoverage(
    manifests.map((m) => m.manifest),
    subjects,
  );
  if (asJson) stdout.write(`${JSON.stringify(coverage, null, 2)}\n`);
  else printCoverage(coverage);

  // Opt-in gate: only SEALED grades can fail the run, and only under --strict.
  const sealedFailures = audits.filter((a) => a.sealed && a.findingCount > 0);
  const totalFindings = audits.reduce((n, a) => n + a.findingCount, 0);

  report.write(
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
