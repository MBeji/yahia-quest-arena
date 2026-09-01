// Quel texte de figure sort de son `viewBox` — donc arrive rogné chez l'élève ?
//
// L'angle mort que ceci ferme : `check-figures.mjs` lit le MARKUP (éléments
// autorisés, références qui résolvent, chiffres occidentaux). Il ne sait rien de
// ce que le markup DESSINE. Une étiquette trop longue pour sa planche est du SVG
// parfaitement valide — et l'élève lit « attracti ». Trouvé à l'œil le
// 2026-09-01 sur `physique-1ere-sec/01`, jamais par un gate.
//
// Un `<svg>` a `overflow: hidden` par défaut : ce qui sort du viewBox est coupé,
// à n'importe quelle échelle de rendu. La mesure est donc invariante — pas
// besoin de reproduire la largeur de la planche.
//
// ⚠️ LA POLICE EST LA MESURE. Une largeur de texte sans sa police ne veut rien
// dire, et l'erreur est SILENCIEUSE : une police de secours plus étroite rend un
// débordement invisible. Deux pièges, tous deux vérifiés ici :
//   • un `@font-face` en `file://` est refusé sur la page `about:blank` que
//     `setContent` crée → les polices voyagent en base64 ;
//   • une `@font-face` n'est chargée QUE si quelque chose l'utilise : sur une
//     page vide, `document.fonts.ready` résout avec les faces encore en
//     « loading » → on force `document.fonts.load()` avant de mesurer.
// Sans ces deux-là, la figure de calibration sortait à +2 u ; avec, à +9,8 u —
// contre +9,7 u mesurés dans l'app en production. C'est ce que « fidèle » veut
// dire, et c'est pourquoi `--calibrate` existe.
//
// Usage :
//   node scripts/content/svg/check-overflow.mjs [contentDir] [--json out.json]
//   node scripts/content/svg/check-overflow.mjs --calibrate   # prouve la méthode
//
// Sortie : la liste triée par gravité. Code de retour 1 s'il existe au moins un
// débordement — c'est un constat de contenu, pas une panne de l'outil.
//
// Chromium vient de Playwright (déjà en devDeps) : `npx playwright install
// chromium` si l'exécutable manque.
import { readFileSync, readdirSync, statSync, writeFileSync, existsSync } from "node:fs";
import { join } from "node:path";
import { argv, exit, stdout } from "node:process";
import { pathToFileURL } from "node:url";

const ROOT = join(import.meta.dirname, "..", "..", "..");
const SVG_BLOCK = /<svg[\s\S]*?<\/svg>/gi;

/** Le seuil : sous 0,5 unité, c'est de l'arrondi de rendu, pas un défaut. */
export const OVERFLOW_TOLERANCE = 0.5;

/** Toutes les figures d'un dossier de contenu, avec d'où elles viennent. */
export function collectFigures(dir) {
  const figures = [];
  const walk = (d) => {
    for (const entry of readdirSync(d)) {
      const p = join(d, entry);
      if (statSync(p).isDirectory()) walk(p);
      else if (/\.(md|json)$/.test(entry)) read(p);
    }
  };
  const read = (path) => {
    const text = readFileSync(path, "utf8");
    if (path.endsWith(".md")) {
      (text.match(SVG_BLOCK) || []).forEach((svg, i) =>
        figures.push({ file: path, where: `figure ${i + 1}`, svg }),
      );
      return;
    }
    let data;
    try {
      data = JSON.parse(text);
    } catch {
      return; // json hors contenu — ignoré, comme dans check-figures.mjs
    }
    for (const [i, q] of (Array.isArray(data) ? data : (data.questions ?? [])).entries()) {
      const fields = [
        ["prompt", q.prompt],
        ["explanation", q.explanation],
        ...(q.options ?? []).map((o, j) => [`option ${j + 1}`, o.text]),
      ];
      for (const [name, value] of fields) {
        if (typeof value !== "string") continue;
        for (const svg of value.match(SVG_BLOCK) || [])
          figures.push({ file: path, where: `q${i + 1}.${name}`, svg });
      }
    }
  };
  walk(dir);
  return figures;
}

/** Le CSS qui met la page dans les conditions de l'app — polices comprises. */
function appFontCss() {
  const b64 = (f) => readFileSync(join(ROOT, "public", "fonts", f)).toString("base64");
  const face = (family, file) =>
    `@font-face{font-family:"${family}";font-weight:400 700;` +
    `src:url(data:font/woff2;base64,${b64(file)}) format("woff2");}`;
  return [
    face("Space Grotesk", "space-grotesk-latin-var.woff2"),
    face("Space Grotesk", "space-grotesk-latin-ext-var.woff2"),
    face("Noto Kufi Arabic", "noto-kufi-arabic-var.woff2"),
    'body{margin:0;font-family:"Space Grotesk","Noto Kufi Arabic",system-ui,sans-serif}',
  ].join("\n");
}

/**
 * Mesuré DANS la page : chaque `<text>`/`<tspan>` contre le viewBox de sa figure.
 *
 * Un seul paramètre, et c'est structurel : `page.evaluate` SÉRIALISE cette
 * fonction vers le navigateur, où rien de ce module n'existe. Elle ne doit donc
 * rien capturer, et Playwright ne lui passe qu'un argument.
 */
function measureInPage([svgs, tolerance]) {
  const host = document.getElementById("host");
  const out = [];
  svgs.forEach((svg, index) => {
    host.innerHTML = svg;
    const root = host.querySelector("svg");
    if (!root?.viewBox?.baseVal?.width) return;
    const box = root.viewBox.baseVal;
    let worst = null;
    for (const node of root.querySelectorAll("text, tspan")) {
      if (!node.textContent.trim()) continue;
      let bbox;
      try {
        bbox = node.getBBox();
      } catch {
        continue;
      }
      if (!bbox.width) continue;
      const right = bbox.x + bbox.width - box.width;
      const left = -bbox.x;
      const excess = Math.max(right, left);
      if (excess > tolerance && (!worst || excess > worst.excess)) {
        worst = {
          excess: Math.round(excess * 10) / 10,
          side: right >= left ? "droite" : "gauche",
          viewBoxWidth: box.width,
          text: node.textContent.trim().slice(0, 70),
        };
      }
    }
    if (worst) out.push({ index, ...worst });
  });
  return out;
}

async function openMeasuringPage(browser) {
  const page = await browser.newPage();
  await page.setContent(`<style>${appFontCss()}</style><div id="host"></div>`);
  await page.evaluate(async () => {
    for (const family of ["Space Grotesk", "Noto Kufi Arabic"])
      for (const weight of [400, 700]) await document.fonts.load(`${weight} 12px "${family}"`);
    await document.fonts.ready;
  });
  return page;
}

/**
 * Preuve que la méthode mesure ce qu'elle prétend, sur un cas dont la réponse est
 * connue : la figure 1 de `physique-1ere-sec/01` débordait de 9,7 unités dans
 * l'app en production (mesuré à la `getBBox()` sur www.na9ranal3ab.tn), et son
 * viewBox élargi l'a ramenée à zéro. Sans contrôle positif, un balayage qui rend
 * « 0 débordement » ne se distingue pas d'un balayage cassé.
 */
const CALIBRATION = {
  text: "signes contraires → attraction",
  attrs: 'x="175" y="129" font-size="12" font-weight="700"',
  narrow: 340,
  wide: 356,
  expected: 9.7,
};

async function calibrate(page) {
  const svg = (width) =>
    `<svg viewBox="0 0 ${width} 170"><text ${CALIBRATION.attrs}>${CALIBRATION.text}</text></svg>`;
  const measure = (width) => page.evaluate(measureInPage, [[svg(width)], OVERFLOW_TOLERANCE]);

  // Contrôle POSITIF (la trop étroite doit déborder) ET négatif (l'élargie non) :
  // une méthode qui ne rend jamais rien passerait le second toute seule.
  const narrow = await measure(CALIBRATION.narrow);
  const wide = await measure(CALIBRATION.wide);
  const measured = narrow[0]?.excess ?? 0;
  const ok = Math.abs(measured - CALIBRATION.expected) <= 0.5 && wide.length === 0;
  stdout.write(
    `calibration : viewBox ${CALIBRATION.narrow} → +${measured} u ` +
      `(attendu +${CALIBRATION.expected}), viewBox ${CALIBRATION.wide} → ${wide.length} débordement\n` +
      (ok
        ? "✓ la méthode mesure bien ce qu'elle prétend.\n"
        : "✗ CALIBRATION EN ÉCHEC — la police ne s'applique probablement pas ; ne crois aucun résultat.\n"),
  );
  return ok;
}

async function main() {
  const flagAt = (name) => argv.indexOf(`--${name}`);
  const dir = argv[2] && !argv[2].startsWith("--") ? argv[2] : "content";
  // Import PARESSEUX : au niveau module, playwright se chargerait aussi pour qui
  // n'importe que `collectFigures` — le test unitaire, qui affirme précisément
  // ne lancer aucun navigateur. Un test qui traîne tout un driver derrière lui
  // ne teste plus ce qu'il annonce.
  const { chromium } = await import("playwright");
  const browser = await chromium.launch();
  const page = await openMeasuringPage(browser);

  // La calibration tourne TOUJOURS : un rapport non calibré ne vaut rien.
  const calibrated = await calibrate(page);
  if (flagAt("calibrate") !== -1) {
    await browser.close();
    exit(calibrated ? 0 : 1);
  }
  if (!calibrated) {
    await browser.close();
    exit(1);
  }

  if (!existsSync(dir)) {
    stdout.write(`✗ ${dir} introuvable — le corpus est-il branché ?\n`);
    await browser.close();
    exit(1);
  }

  const figures = collectFigures(dir);
  stdout.write(`\n${figures.length} figure(s) à mesurer sous ${dir}/…\n`);

  const findings = [];
  const BATCH = 60;
  for (let i = 0; i < figures.length; i += BATCH) {
    const batch = figures.slice(i, i + BATCH);
    const measured = await page.evaluate(measureInPage, [
      batch.map((f) => f.svg),
      OVERFLOW_TOLERANCE,
    ]);
    for (const m of measured) {
      const { svg, ...origin } = batch[m.index];
      void svg;
      findings.push({ ...origin, ...m, index: undefined });
    }
  }
  await browser.close();
  findings.sort((a, b) => b.excess - a.excess);

  const jsonAt = flagAt("json");
  if (jsonAt !== -1 && argv[jsonAt + 1])
    writeFileSync(argv[jsonAt + 1], JSON.stringify({ total: figures.length, findings }, null, 2));

  if (!findings.length) {
    stdout.write(`✓ aucun texte hors viewBox sur ${figures.length} figures.\n`);
    return 0;
  }
  stdout.write(`\n✗ ${findings.length} figure(s) dont un texte sort du viewBox :\n`);
  for (const f of findings) {
    stdout.write(
      `  +${String(f.excess).padStart(6)} u  ${f.side.padEnd(7)} vb ${String(f.viewBoxWidth).padEnd(4)} ` +
        `${f.file} · ${f.where} · « ${f.text} »\n`,
    );
  }
  return 1;
}

// Exécuté en CLI seulement — les tests importent les fonctions pures, sans jamais
// lancer un navigateur. Playwright doit être importable ET le navigateur installé :
// les deux échouent bruyamment, jamais en rendant « 0 débordement ».
if (argv[1] && pathToFileURL(argv[1]).href === import.meta.url) exit(await main());
