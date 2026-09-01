// Structural lint for the inline SVG figures embedded in content/.
// Complements content:qa (which validates the pedagogy/schema): this checks that
// every figure is safe and renderable under the content sanitizer + notation rules.
//
// Usage:
//   node scripts/content/svg/check-figures.mjs [rootDir]     (default: content)
// Exits non-zero if any issue is found.
//
// Checks per <svg> block (in cours.md/resume.md and inside question prompt/explanation/option):
//   • only sanitizer-allowed elements (see src/shared/lib/figure.ts)
//   • no forbidden refs/attrs (image/use/foreignObject/script/style/href/xlink:href)
//   • `url(#…)` indirection (arrow markers, gradients) that actually resolves — and an
//     id that survives DOMPurify's anti-clobbering guard (see sanitizer-contract.mjs)
//   • a viewBox (or explicit width+height) so it scales
//   • balanced <svg>…</svg>
//   • Western digits only — no Arabic-Indic (٠-٩) / Persian (۰-۹) digits, incl. Arabic content
//   • one <svg> per field (the renderer extracts a single figure per field)
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join } from "node:path";
import { lintSvg } from "./sanitizer-contract.mjs";

const root = process.argv[2] || "content";
const issues = [];

function walk(dir) {
  for (const e of readdirSync(dir)) {
    const p = join(dir, e);
    const st = statSync(p);
    if (st.isDirectory()) walk(p);
    else if (/\.(md|json)$/.test(e)) checkFile(p);
  }
}

function checkSvg(where, svg) {
  issues.push(...lintSvg(svg, where));
}

function checkField(where, s) {
  if (typeof s !== "string" || !s.includes("<svg")) return;
  const blocks = s.match(/<svg[\s\S]*?<\/svg>/gi) || [];
  if (blocks.length > 1)
    issues.push(
      `${where}: ${blocks.length} <svg> in one field — the renderer shows only one per field`,
    );
  for (const b of blocks) checkSvg(where, b);
}

function checkFile(path) {
  const text = readFileSync(path, "utf8");
  if (path.endsWith(".md")) {
    const blocks = text.match(/<svg[\s\S]*?<\/svg>/gi) || [];
    for (const b of blocks) checkSvg(path, b);
    // Toutes les figures d'une leçon atterrissent dans UN SEUL document : deux `id`
    // identiques et `url(#…)` résout au premier, en silence. Le contrôle est ici et pas
    // dans `lintSvg`, qui ne voit qu'une figure à la fois. (Une question de quiz, elle,
    // s'affiche seule : la collision n'y existe pas.)
    const seen = new Map();
    for (const b of blocks)
      for (const [, id] of b.matchAll(/\bid="([^"]*)"/g)) seen.set(id, (seen.get(id) || 0) + 1);
    for (const [id, n] of seen)
      if (n > 1)
        issues.push(
          `${path}: id="${id}" defined ${n}× in the same lesson — every reference resolves to the first`,
        );
    return;
  }
  let data;
  try {
    data = JSON.parse(text);
  } catch {
    return; // non-content json or unparseable — skip
  }
  const questions = Array.isArray(data) ? data : data.questions || [];
  questions.forEach((q, i) => {
    checkField(`${path} · q${i}.prompt`, q.prompt);
    checkField(`${path} · q${i}.explanation`, q.explanation);
    (q.options || []).forEach((o, j) => checkField(`${path} · q${i}.opt${j}`, o.text));
  });
}

walk(root);
if (issues.length) {
  console.error(`✗ ${issues.length} figure issue(s):`);
  for (const i of issues) console.error("  " + i);
  process.exit(1);
}
console.log(`✓ figures OK — no structural/notation issues under ${root}/`);
