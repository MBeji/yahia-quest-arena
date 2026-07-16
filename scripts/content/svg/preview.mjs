// Render the inline SVG figures found in a content file to a PNG grid, for visual QA.
//
// Usage:
//   node scripts/content/svg/preview.mjs <input> <out.png>
//
//   <input> may be:
//     • a raw .svg / .txt file, or a cours.md / resume.md   → SVG blocks are matched textually
//     • a content .json (quiz.json / exercices/*.json)       → SVGs are DECODED out of each
//       question's prompt/explanation and each option.text (json.parse, so escaped quotes
//       become real). This is the authoritative check: it renders exactly what ships, and
//       catches "blank figure" bugs caused by rendering the raw (backslash-escaped) JSON text.
//
// Requires the repo's dev deps (Playwright). Uses the pre-installed Chromium when present
// (PLAYWRIGHT_BROWSERS_PATH), else falls back to Playwright's managed browser.
import { readFileSync } from "node:fs";
import { chromium } from "playwright";

const [, , src, out] = process.argv;
if (!src || !out) {
  console.error("usage: node scripts/content/svg/preview.mjs <input> <out.png>");
  process.exit(2);
}

const SVG_RE = /<svg[\s\S]*?<\/svg>/gi;
const firstSvg = (s) => {
  if (typeof s !== "string") return null;
  const i = s.indexOf("<svg");
  if (i === -1) return null;
  const j = s.indexOf("</svg>", i);
  return j === -1 ? null : s.slice(i, j + 6);
};

function extractSvgs(path) {
  const text = readFileSync(path, "utf8");
  if (path.endsWith(".json")) {
    // Decode SVGs out of the parsed strings (real quotes/newlines), not the raw file text.
    const data = JSON.parse(text);
    const out = [];
    const scan = (s) => {
      const svg = firstSvg(s);
      if (svg) out.push(svg);
    };
    const questions = Array.isArray(data) ? data : data.questions || [];
    for (const q of questions) {
      scan(q.prompt);
      scan(q.explanation);
      for (const o of q.options || []) scan(o.text);
    }
    return out;
  }
  return text.match(SVG_RE) || [];
}

const svgs = extractSvgs(src);
if (!svgs.length) {
  console.error("no <svg> found in", src);
  process.exit(1);
}

const html = `<!doctype html><meta charset="utf8">
<body style="margin:0;background:#fff;font-family:sans-serif">
${svgs
  .map(
    (s, i) =>
      `<figure style="display:inline-block;margin:8px;padding:8px;border:1px solid #ddd;vertical-align:top">
  <figcaption style="font-size:11px;color:#555">#${i}</figcaption>
  <div style="width:320px">${s.replace(/<svg /, '<svg style="width:100%;height:auto" ')}</div>
</figure>`,
  )
  .join("\n")}
</body>`;

const browser = await chromium
  .launch({ executablePath: "/opt/pw-browsers/chromium" })
  .catch(() => chromium.launch());
const page = await browser.newPage({ viewport: { width: 720, height: 900 } });
await page.setContent(html, { waitUntil: "networkidle" });
await page.screenshot({ path: out, fullPage: true });
await browser.close();
console.log(`rendered ${svgs.length} svg(s) -> ${out}`);
