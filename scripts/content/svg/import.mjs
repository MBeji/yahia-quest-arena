// Turn an SVG downloaded from a free-licence library (Openclipart, SVG Repo, OpenMoji,
// Wikimedia Commons…) into a figure this project can actually embed.
//
// WHY THIS EXISTS — the trap it removes:
// pasting such a file straight into content does not fail loudly, it fails SILENTLY.
// The content sanitizer (`src/shared/lib/figure.ts`) strips `<style>`, `<use>` and
// `<image>`; the figure still "renders", but with its colours gone (every fill falls
// back to black) or with half its shapes missing. Measured on the real sanitizer:
//
//   clipart with a <style> block  → all fills lost
//   clipart with <defs>/<use>     → the reused shapes vanish
//   embedded bitmap <image>       → empty figure
//
// So this tool resolves those constructs BEFORE the sanitizer can eat them: it flattens
// the CSS cascade into presentation attributes, inlines `<use>`, flattens gradients to a
// solid colour, drops what cannot be carried, and then PROVES the result by (1) replaying
// the real sanitizer over the output and (2) comparing the rendered pixels of the original
// against the sanitized output. The cascade is resolved by Chromium itself
// (`getComputedStyle`), not by a hand-rolled CSS engine — no specificity guesswork.
//
// Usage:
//   node scripts/content/svg/import.mjs <input.svg> --title "Une vache dans un pré" \
//        [--out figure.svg] [--proof proof.png] [--max-bytes 12000]
//
// Prints the figure on stdout when --out is omitted, so it can be piped into content.
// Exits non-zero if the result would not satisfy the house contract.
//
// LICENCE IS NOT CHECKED HERE. This tool cannot know where the file came from. Recording
// the source and its licence is the author's job — see README.md § « Provenance ».
import { readFileSync, writeFileSync } from "node:fs";
import { createRequire } from "node:module";
import { chromium } from "playwright";
import { lintSvg, DOMPURIFY_CONFIG, ALLOWED, NON_RENDERING } from "./sanitizer-contract.mjs";

const require = createRequire(import.meta.url);

// ---------------------------------------------------------------- CLI

const VALUE_FLAGS = new Set(["title", "out", "proof", "max-bytes"]);
const USAGE =
  'usage: node scripts/content/svg/import.mjs <input.svg> --title "…" [--out f.svg] [--proof p.png] [--max-bytes N]';

const opts = {};
const positional = [];
for (let i = 0; i < process.argv.length - 2; i++) {
  const a = process.argv[i + 2];
  if (a.startsWith("--")) {
    const name = a.slice(2);
    if (!VALUE_FLAGS.has(name)) {
      console.error(`unknown option --${name}\n${USAGE}`);
      process.exit(2);
    }
    opts[name] = process.argv[i + 3];
    i++; // the value belongs to this flag, never to the source path
  } else {
    positional.push(a);
  }
}

const src = positional[0];
if (!src || positional.length > 1) {
  console.error(
    `${positional.length > 1 ? "expected a single input file" : "missing input file"}\n${USAGE}`,
  );
  process.exit(2);
}

const title = opts.title ?? null;
const outPath = opts.out ?? null;
const proofPath = opts.proof ?? null;
const maxBytes = Number(opts["max-bytes"] ?? 12000);

const source = readFileSync(src, "utf8");

// A bitmap cannot be carried by a figure: `<image>` is stripped by the sanitizer and the
// house contract has no vector to fall back on. This is the medium boundary — a real
// photograph is a different chantier (bucket + licence + offline cache), not this tool.
if (/<image\b/i.test(source)) {
  console.error(
    `✗ ${src}: the file embeds a bitmap (<image>). Figures are vector-only — the sanitizer\n` +
      `  strips <image>, which would leave an EMPTY figure. Pick a vector illustration, or\n` +
      `  raise the "photo" chantier (medium change, decision D-8 of étude 18).`,
  );
  process.exit(1);
}

// ------------------------------------------------- normalization (runs inside Chromium)

/**
 * Rewrites the SVG into the flat subset the contract allows.
 * Runs in the page so the CSS cascade is resolved by the browser itself.
 * Returns { svg, notes } — `notes` lists every lossy or surprising step, so nothing
 * is silently dropped.
 */
function normalizeInPage({ source, title, allowed, nonRendering }) {
  const notes = [];
  const ALLOWED = new Set(allowed);

  const doc = new DOMParser().parseFromString(source, "image/svg+xml");
  if (doc.querySelector("parsererror")) return { error: "input is not well-formed XML/SVG" };
  const root = doc.documentElement;
  if (root.localName !== "svg") return { error: `root element is <${root.localName}>, not <svg>` };

  // Live in the document: getComputedStyle only resolves for rendered elements, and the
  // SVG's own <style> rules only apply once the subtree is in a document.
  const host = document.createElement("div");
  host.style.cssText = "position:absolute;left:-9999px;top:0";
  document.body.appendChild(host);
  let live = document.importNode(root, true);
  host.appendChild(live);

  const svgNS = "http://www.w3.org/2000/svg";
  const byId = (ref) => {
    const m = /^url\(["']?#([^"')]+)["']?\)$|^#(.+)$/.exec((ref || "").trim());
    const id = m && (m[1] || m[2]);
    return id ? live.querySelector(`[id="${CSS.escape(id)}"]`) : null;
  };

  // 1 ── Inline <use>. Cloned nodes keep their class/id so the CSS below still matches.
  for (let pass = 0; pass < 4; pass++) {
    const uses = [...live.querySelectorAll("use")];
    if (!uses.length) break;
    if (pass === 3) notes.push("nested <use> deeper than 4 levels — the rest was dropped");
    for (const use of uses) {
      const target = byId(use.getAttribute("href") || use.getAttribute("xlink:href"));
      if (!target) {
        notes.push("a <use> pointed at a missing id — shape dropped");
        use.remove();
        continue;
      }
      const g = doc.createElementNS(svgNS, "g");
      const x = use.getAttribute("x"),
        y = use.getAttribute("y");
      const parts = [];
      if (use.getAttribute("transform")) parts.push(use.getAttribute("transform"));
      if ((x && x !== "0") || (y && y !== "0")) parts.push(`translate(${x || 0} ${y || 0})`);
      if (parts.length) g.setAttribute("transform", parts.join(" "));
      // A <symbol> is a container that only renders through <use>: lift its children.
      const clone = target.cloneNode(true);
      if (clone.localName === "symbol" || clone.localName === "svg") {
        while (clone.firstChild) g.appendChild(clone.firstChild);
      } else {
        g.appendChild(clone);
      }
      use.replaceWith(g);
    }
    if (uses.length) notes.push(`inlined ${uses.length} <use> reference(s)`);
  }

  // 2 ── Resolve gradients to a single solid colour (the contract forbids <defs>).
  const toRgb = (c) => {
    const probe = document.createElement("span");
    probe.style.color = "";
    probe.style.color = c;
    document.body.appendChild(probe);
    const v = getComputedStyle(probe).color;
    probe.remove();
    const m = /rgba?\(([^)]+)\)/.exec(v);
    return m ? m[1].split(",").map(Number) : null;
  };
  const gradientColour = (node, depth = 0) => {
    if (!node || depth > 2) return null;
    let stops = [...node.querySelectorAll("stop")];
    if (!stops.length) {
      const inherited = byId(node.getAttribute("href") || node.getAttribute("xlink:href"));
      return gradientColour(inherited, depth + 1);
    }
    const cols = stops
      .map((s) => toRgb(getComputedStyle(s).stopColor || s.getAttribute("stop-color") || "#000"))
      .filter(Boolean);
    if (!cols.length) return null;
    const avg = [0, 1, 2].map((i) => Math.round(cols.reduce((a, c) => a + c[i], 0) / cols.length));
    return `rgb(${avg.join(", ")})`;
  };

  // 3 ── Stamp the computed paint as presentation attributes, then the CSS can go.
  // Only values that differ from the SVG initial value are written, to keep output small.
  const INITIAL = {
    fill: "rgb(0, 0, 0)",
    stroke: "none",
    "stroke-width": "1px",
    "stroke-linecap": "butt",
    "stroke-linejoin": "miter",
    "stroke-dasharray": "none",
    "fill-opacity": "1",
    "stroke-opacity": "1",
    opacity: "1",
    "text-anchor": "start",
    "font-weight": "400",
  };
  const CAMEL = {
    fill: "fill",
    stroke: "stroke",
    "stroke-width": "strokeWidth",
    "stroke-linecap": "strokeLinecap",
    "stroke-linejoin": "strokeLinejoin",
    "stroke-dasharray": "strokeDasharray",
    "fill-opacity": "fillOpacity",
    "stroke-opacity": "strokeOpacity",
    opacity: "opacity",
    "text-anchor": "textAnchor",
    "font-weight": "fontWeight",
  };

  let flattenedGradients = 0;
  for (const el of [live, ...live.querySelectorAll("*")]) {
    if (!ALLOWED.has(el.localName) && el.localName !== "svg") continue;
    const cs = getComputedStyle(el);
    for (const [prop, camel] of Object.entries(CAMEL)) {
      let value = cs[camel];
      if (!value) continue;
      if (/^url\(/.test(value)) {
        const solid = gradientColour(byId(value));
        if (solid) {
          value = solid;
          flattenedGradients++;
        } else {
          value = prop === "stroke" ? "none" : "rgb(120, 120, 120)";
          notes.push(`a ${prop}="${cs[camel]}" could not be resolved — replaced by ${value}`);
        }
      }
      if (value === INITIAL[prop]) continue;
      el.setAttribute(prop, prop === "stroke-width" ? value.replace(/px$/, "") : value);
    }
    // font-size is only stamped when the source actually asked for one: otherwise we would
    // bake Chromium's 16px default into every figure and lose the app's own typography.
    if (
      (el.localName === "text" || el.localName === "tspan") &&
      (el.hasAttribute("font-size") || /font-size/.test(el.getAttribute("style") || ""))
    ) {
      el.setAttribute("font-size", cs.fontSize.replace(/px$/, ""));
    }
  }
  if (flattenedGradients)
    notes.push(
      `flattened ${flattenedGradients} gradient(s) to a solid colour — the contract forbids <defs>`,
    );

  // 4 ── Prune everything the contract does not allow.
  //
  // The distinction that matters: some containers hold shapes that are NEVER drawn where
  // they sit — they only paint through a reference (`clip-path="url(#…)"`, `<use>`, a
  // gradient). Unwrapping one of those would promote an invisible mask into a visible
  // black shape on top of the drawing. They are dropped whole, subtree included.
  const NON_RENDERING = new Set(nonRendering);

  const dropped = new Map();
  const note = (name) => dropped.set(name, (dropped.get(name) || 0) + 1);
  // Reverse document order: children are visited before their parents, so unwrapping a
  // container never re-introduces a child that was just pruned.
  for (const el of [...live.querySelectorAll("*")].reverse()) {
    const name = el.localName;
    if (ALLOWED.has(name)) continue;
    if (NON_RENDERING.has(name)) {
      el.remove();
      note(`<${name}>`);
      continue;
    }
    if (el.children.length) {
      // An unknown RENDERING container (switch, a, a namespaced wrapper…): the drawing
      // inside it is really drawn, so keep it and drop only the wrapper.
      const g = doc.createElementNS(svgNS, "g");
      if (el.getAttribute("transform")) g.setAttribute("transform", el.getAttribute("transform"));
      while (el.firstChild) g.appendChild(el.firstChild);
      el.replaceWith(g);
      note(`<${name}> (unwrapped)`);
    } else {
      el.remove();
      note(`<${name}>`);
    }
  }
  for (const [name, n] of dropped) notes.push(`dropped ${n}× ${name}`);

  // 5 ── Attribute hygiene: ids/classes are dead once the cascade is flattened, and
  // clip-path/mask/filter would dangle now that <defs> is gone.
  let dangling = 0;
  for (const el of [live, ...live.querySelectorAll("*")]) {
    for (const attr of [...el.attributes]) {
      const n = attr.name;
      if (n === "id" || n === "class" || n === "style") {
        el.removeAttribute(n);
      } else if (n === "clip-path" || n === "mask" || n === "filter") {
        el.removeAttribute(n);
        dangling++;
      } else if (/^(inkscape|sodipodi|rdf|cc|dc|xlink|xml):/.test(n) || n === "xmlns:xlink") {
        el.removeAttribute(n);
      }
    }
  }
  if (dangling)
    notes.push(
      `removed ${dangling} clip-path/mask/filter reference(s) — shapes may extend further than in the original`,
    );

  // 5b ── Collapse the groups that inlining and unwrapping just created. A figure travels
  // inside every question row it illustrates, so empty indirection is not free.
  for (const g of [...live.querySelectorAll("g")].reverse()) {
    if (!g.children.length && !g.textContent.trim()) {
      g.remove();
      continue;
    }
    const bare = g.attributes.length === 0;
    const onlyChildGroup =
      g.children.length === 1 &&
      g.children[0].localName === "g" &&
      !g.children[0].attributes.length;
    if (bare && g.parentElement) g.replaceWith(...g.childNodes);
    else if (onlyChildGroup) g.children[0].replaceWith(...g.children[0].childNodes);
  }

  // 5c ── Drop namespace PREFIXES. A file may declare SVG under a prefix — `<ns0:svg>`,
  // `<ns0:path>` — which Inkscape and several exporters do. XMLSerializer would faithfully
  // keep the prefix, and the figure would ship as `<ns0:path>`: rejected by the contract,
  // and drawn by nothing. Rebuilding each node in the default SVG namespace fixes it at the
  // structure, not with a regex over the serialized string.
  const dePrefix = (el) => {
    for (const child of [...el.children]) dePrefix(child);
    if (!el.prefix) return el;
    const fresh = doc.createElementNS(svgNS, el.localName);
    for (const a of [...el.attributes]) {
      if (a.name === "xmlns" || a.name.startsWith("xmlns:")) continue;
      fresh.setAttribute(a.localName, a.value);
    }
    while (el.firstChild) fresh.appendChild(el.firstChild);
    el.replaceWith(fresh);
    return fresh;
  };
  // The root is replaced too, so the reference has to follow it.
  live = dePrefix(live);

  // 6 ── Root: a viewBox drives the size (the renderer gives the figure its width), so an
  // intrinsic width/height would fight it. See svg-figure.tsx.
  if (!live.getAttribute("viewBox")) {
    const w = parseFloat(live.getAttribute("width")),
      h = parseFloat(live.getAttribute("height"));
    if (w && h) {
      live.setAttribute("viewBox", `0 0 ${w} ${h}`);
      notes.push(`no viewBox — synthesized from width/height (${w}×${h})`);
    } else {
      const b = live.getBBox();
      live.setAttribute(
        "viewBox",
        `${Math.floor(b.x)} ${Math.floor(b.y)} ${Math.ceil(b.width)} ${Math.ceil(b.height)}`,
      );
      notes.push("no viewBox and no width/height — synthesized from the rendered bounding box");
    }
  }
  live.removeAttribute("width");
  live.removeAttribute("height");
  for (const a of ["version", "x", "y", "enable-background", "space"]) live.removeAttribute(a);

  // 7 ── <title> first: it is the figure's accessible name (house rule).
  for (const t of [...live.querySelectorAll("title")]) t.remove();
  if (title) {
    const t = doc.createElementNS(svgNS, "title");
    t.textContent = title;
    live.insertBefore(t, live.firstChild);
  }

  const out = new XMLSerializer().serializeToString(live);
  host.remove();
  return { svg: out, notes };
}

/**
 * Rasterize both SVGs and compare them on two axes, because they answer two different
 * questions and only one of them is a defect:
 *
 *   • INK  — did a shape disappear (or appear)? A binarized "is there ink here" map, so a
 *            recoloured area still counts as present. This is the real failure mode: a leg
 *            eaten by a dropped <use>, a figure emptied by a stripped <image>.
 *   • COLOUR — how much of the palette moved. Flattening a gradient legitimately moves a
 *            lot of it (a sky rect is most of the canvas), so this is reported, not judged.
 */
async function pixelDiffInPage({ a, b, size }) {
  const raster = async (text) => {
    const img = new Image();
    img.src = "data:image/svg+xml;charset=utf-8," + encodeURIComponent(text);
    await img.decode();
    const c = document.createElement("canvas");
    c.width = size;
    c.height = size;
    const ctx = c.getContext("2d");
    ctx.fillStyle = "#fff";
    ctx.fillRect(0, 0, size, size);
    // contain-fit both drawings in the same box: an intrinsic width/height on the original
    // vs a bare viewBox on the output must not register as a difference.
    const r = Math.min(size / img.naturalWidth, size / img.naturalHeight) || 1;
    const w = img.naturalWidth * r,
      h = img.naturalHeight * r;
    ctx.drawImage(img, (size - w) / 2, (size - h) / 2, w, h);
    return ctx.getImageData(0, 0, size, size).data;
  };
  try {
    const [pa, pb] = [await raster(a), await raster(b)];
    // "ink" = visibly not the white paper behind it.
    const ink = (p, i) => p[i] < 224 || p[i + 1] < 224 || p[i + 2] < 224;
    let inkDiff = 0,
      colourDiff = 0;
    for (let i = 0; i < pa.length; i += 4) {
      if (ink(pa, i) !== ink(pb, i)) inkDiff++;
      if (
        Math.abs(pa[i] - pb[i]) > 24 ||
        Math.abs(pa[i + 1] - pb[i + 1]) > 24 ||
        Math.abs(pa[i + 2] - pb[i + 2]) > 24
      )
        colourDiff++;
    }
    const n = pa.length / 4;
    return { ink: inkDiff / n, colour: colourDiff / n };
  } catch (e) {
    return { error: String(e?.message || e) };
  }
}

/**
 * What the runtime sanitizer actually took away — element by element, attribute by
 * attribute. A string comparison cannot be used here: DOMPurify re-serializes (self-closing
 * tags, attribute order), so it would report a difference on every single figure.
 */
function sanitizerDeltaInPage({ before, after }) {
  const describe = (text) => {
    const doc = new DOMParser().parseFromString(text, "image/svg+xml");
    if (doc.querySelector("parsererror")) return null;
    const out = [];
    const walk = (el) => {
      out.push({
        tag: el.localName,
        attrs: Object.fromEntries([...el.attributes].map((a) => [a.name, a.value])),
      });
      for (const c of el.children) walk(c);
    };
    walk(doc.documentElement);
    return out;
  };
  const a = describe(before),
    b = describe(after);
  if (!a || !b) return ["output is not well-formed after sanitizing"];

  const lost = [];
  const countTags = (list) =>
    list.reduce((m, e) => m.set(e.tag, (m.get(e.tag) || 0) + 1), new Map());
  const ca = countTags(a),
    cb = countTags(b);
  for (const [tag, n] of ca) {
    const kept = cb.get(tag) || 0;
    if (kept < n) lost.push(`${n - kept}× <${tag}> removed`);
  }
  // Attributes, positionally — the element order is stable through DOMPurify.
  if (a.length === b.length) {
    a.forEach((el, i) => {
      for (const [k, v] of Object.entries(el.attrs)) {
        if (!(k in b[i].attrs)) lost.push(`<${el.tag}> lost attribute ${k}="${v}"`);
      }
    });
  }
  return lost;
}

// ---------------------------------------------------------------- run

const browser = await chromium
  .launch({ executablePath: "/opt/pw-browsers/chromium" })
  .catch(() => chromium.launch());
const page = await browser.newPage({ viewport: { width: 600, height: 600 } });
await page.setContent("<!doctype html><meta charset=utf8><body></body>");

const {
  svg: normalized,
  notes,
  error,
} = await page.evaluate(normalizeInPage, {
  source,
  title,
  // `page.evaluate` serializes the function: it cannot close over module imports, so the
  // contract travels as data. One definition still, in sanitizer-contract.mjs.
  allowed: [...ALLOWED],
  nonRendering: NON_RENDERING,
});

if (error) {
  console.error(`✗ ${src}: ${error}`);
  await browser.close();
  process.exit(1);
}

// Squeeze the output: imported paths routinely carry 6+ decimals for nothing, and
// `getComputedStyle` hands back `rgb(245, 245, 244)` where `#f5f5f4` says the same in a
// third of the bytes. A figure ships inside every content row that uses it.
const hex2 = (n) => Number(n).toString(16).padStart(2, "0");
let figure = normalized
  .replace(/ xmlns:[a-z]+="[^"]*"/g, "")
  .replace(/-?\d+\.\d{3,}/g, (m) => String(Math.round(parseFloat(m) * 100) / 100))
  .replace(
    /rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*1)?\)/g,
    (_m, r, g, b) => `#${hex2(r)}${hex2(g)}${hex2(b)}`,
  )
  .replace(/>\s+</g, "><")
  .trim();

// ── Proof 1: the real runtime sanitizer, replayed. Anything it removes here would have
// been removed in the child's browser, silently.
let sanitized = figure;
let sanitizerAvailable = false;
try {
  await page.addScriptTag({ path: require.resolve("dompurify/dist/purify.js") });
  sanitized = await page.evaluate(({ svg, config }) => window.DOMPurify.sanitize(svg, config), {
    svg: figure,
    config: DOMPURIFY_CONFIG,
  });
  sanitizerAvailable = true;
} catch {
  // Degrade loudly, never silently: the house lint below is stricter on ELEMENTS but
  // cannot see an attribute the sanitizer would strip.
}

const lostToSanitizer = sanitizerAvailable
  ? await page.evaluate(sanitizerDeltaInPage, { before: figure, after: sanitized })
  : [];

// ── Proof 2: the pixels. Original vs what actually ships.
const diff = await page.evaluate(pixelDiffInPage, { a: source, b: sanitized, size: 320 });

// ── Proof 3: the house contract.
const issues = lintSvg(figure, src);

if (proofPath) {
  await page.setContent(
    `<!doctype html><meta charset=utf8><body style="margin:0;background:#fff;font:12px system-ui">
     <div style="display:flex;gap:12px;padding:12px">
       <figure style="margin:0"><figcaption>original (${source.length} o)</figcaption>
         <div style="width:280px;border:1px solid #ddd">${source.replace(/<svg /, '<svg style="width:100%;height:auto" ')}</div></figure>
       <figure style="margin:0"><figcaption>normalisé + assaini (${figure.length} o)</figcaption>
         <div style="width:280px;border:1px solid #ddd">${sanitized.replace(/<svg /, '<svg style="width:100%;height:auto" ')}</div></figure>
     </div></body>`,
    { waitUntil: "networkidle" },
  );
  await page.screenshot({ path: proofPath, fullPage: true });
}

await browser.close();

// ---------------------------------------------------------------- report

const pctInk = diff.ink === undefined ? null : (diff.ink * 100).toFixed(2);
const pctColour = diff.colour === undefined ? null : (diff.colour * 100).toFixed(2);
const lines = [];
lines.push(`source        ${src} (${source.length} o)`);
lines.push(
  `figure        ${figure.length} o${figure.length > maxBytes ? `  ⚠ > ${maxBytes} o` : ""}`,
);
lines.push(
  `sanitizer     ${sanitizerAvailable ? (lostToSanitizer.length ? "✗ AMPUTE la figure" : "✓ survit intact") : "⚠ non rejoué (dompurify introuvable)"}`,
);
lines.push(
  pctInk === null
    ? `pixels        ⚠ comparaison indisponible (${diff.error})`
    : `pixels        ${pctInk} % de formes différentes · ${pctColour} % de couleur déplacée`,
);
if (proofPath) lines.push(`preuve        ${proofPath}`);
for (const n of notes) lines.push(`  · ${n}`);
console.error(lines.join("\n"));

let fatal = false;
if (issues.length) {
  console.error("\n✗ contrat maison non respecté :");
  for (const i of issues) console.error("  " + i);
  fatal = true;
}
if (lostToSanitizer.length) {
  console.error(
    "\n✗ le sanitizer ampute encore la figure — elle s'afficherait FAUSSE en production :",
  );
  for (const l of lostToSanitizer) console.error("  " + l);
  fatal = true;
}
// Only the SHAPES are judged. Colour legitimately moves when a gradient is flattened —
// that step is reported above, and `--proof` is there for the author to confirm it.
if (pctInk !== null && diff.ink > 0.04) {
  console.error(
    `\n✗ ${pctInk} % des formes diffèrent de l'original : la normalisation a perdu (ou ajouté) du dessin.\n` +
      "  Relis la preuve (--proof) avant d'intégrer cette figure.",
  );
  fatal = true;
}
if (figure.length > maxBytes) {
  console.error(
    `\n✗ figure de ${figure.length} o (budget ${maxBytes} o) : elle voyagera dans chaque question.\n` +
      "  Simplifie les tracés à la source (moins de points) ou choisis une illustration plus sobre.",
  );
  fatal = true;
}

if (fatal) process.exit(1);

if (outPath) {
  writeFileSync(outPath, figure + "\n");
  console.error(`\n✓ écrit dans ${outPath}`);
} else {
  process.stdout.write(figure + "\n");
}
