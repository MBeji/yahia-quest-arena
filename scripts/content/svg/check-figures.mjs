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
//   • no forbidden refs/attrs (image/use/foreignObject/script/style/href/xlink:href/marker/defs)
//   • a viewBox (or explicit width+height) so it scales
//   • balanced <svg>…</svg>
//   • Western digits only — no Arabic-Indic (٠-٩) / Persian (۰-۹) digits, incl. Arabic content
//   • one <svg> per field (the renderer extracts a single figure per field)
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join } from "node:path";

const ALLOWED = new Set([
  "svg",
  "title",
  "g",
  "line",
  "path",
  "polygon",
  "polyline",
  "rect",
  "circle",
  "ellipse",
  "text",
  "tspan",
]);
const FORBIDDEN = /<(image|use|foreignObject|script|style|marker|defs)\b|(?:xlink:)?href\s*=/i;
const INDIC = /[٠-٩۰-۹]/;

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
  const opens = (svg.match(/<svg[\s>]/g) || []).length;
  const closes = (svg.match(/<\/svg>/g) || []).length;
  if (opens !== 1 || closes !== 1)
    issues.push(`${where}: malformed <svg> (${opens} open / ${closes} close)`);
  const openTag = svg.match(/<svg[^>]*>/i)?.[0] || "";
  if (!/viewBox/i.test(openTag) && !(/\bwidth=/i.test(openTag) && /\bheight=/i.test(openTag)))
    issues.push(`${where}: <svg> has no viewBox (nor width+height) — will not scale`);
  if (FORBIDDEN.test(svg))
    issues.push(
      `${where}: forbidden element/attr (image/use/foreignObject/script/style/marker/defs/href)`,
    );
  for (const tag of svg.match(/<\/?([a-zA-Z][\w:-]*)/g) || []) {
    const name = tag.replace(/[<\/]/g, "");
    if (!ALLOWED.has(name)) issues.push(`${where}: disallowed element <${name}>`);
  }
  if (INDIC.test(svg))
    issues.push(`${where}: Arabic-Indic/Persian digits in figure — use Western digits (0-9)`);
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
    for (const b of text.match(/<svg[\s\S]*?<\/svg>/gi) || []) checkSvg(path, b);
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
