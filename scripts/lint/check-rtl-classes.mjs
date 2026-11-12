/**
 * RTL guard (étude 14, D-4 / R-2) — forbids PHYSICAL directional styling where the
 * trilingual app must mirror under RTL. Logical properties are the rule: ms-/me-,
 * ps-/pe-, start-/end-, text-start/text-end, rounded-s/e, border-s/e.
 *
 * Scope: src/features, src/routes, src/lib, src/shared, src/components — since
 * 2026-11-12 INCLUDING src/components/ui (the vendored shadcn primitives carried
 * the RTL defects of the display audit: dialog close button, sheet side) — plus
 * the stylesheet `src/styles.css`. Excluded: __tests__ (tests may assert literal
 * class names) and the files of `PENDING` below.
 *
 * What it reads, and the rules themselves: `rtl-rules.mjs` (pure, unit-tested).
 *
 * Documented exception (RISK-3): append `// rtl-ok: <reason>` (or embed `rtl-ok`
 * in a comment on the same line, or up to 3 lines above) when a physical value is
 * correct in BOTH directions — e.g. a numeric input pinned LTR.
 *
 * Runs in `npm run lint` (zero-warning gate) and therefore in CI.
 */
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";
import { fileURLToPath } from "node:url";
import { findRtlViolations } from "./rtl-rules.mjs";

// fileURLToPath, not URL#pathname: pathname yields "/D:/…" on Windows, which
// join() then mangles into "D:\D:\…" (gate broken on every Windows checkout).
const ROOT = fileURLToPath(new URL("../..", import.meta.url));
const SRC = join(ROOT, "src");

const INCLUDED = ["features", "routes", "lib", "shared", "components"];
const EXCLUDED_SEGMENTS = ["/__tests__/"];
const STYLESHEETS = ["styles.css"];

/**
 * Dette connue, tenue par un autre chantier : ces fichiers ne sont pas encore
 * relus. La liste ne peut que RÉTRÉCIR — un fichier qui en sort est gardé. Une
 * entrée dont le fichier n'a plus de faute est signalée (sans bloquer : le
 * correctif arrive par une autre PR, qui n'a pas à connaître cette liste).
 */
const PENDING = [
  // « +XP » flottant et confettis de la montée de niveau (constat
  // `level-up-seal-modals-keyboard-and-reduced-motion`, axe accessibilité).
  "src/components/ui/level-up-celebration.tsx",
];

function* walk(dir) {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) yield* walk(full);
    else if (/\.(ts|tsx)$/.test(entry)) yield full;
  }
}

const violations = [];
const pendingSeen = new Set();

function check(file, kind) {
  const rel = relative(ROOT, file).split("\\").join("/");
  const found = findRtlViolations(readFileSync(file, "utf8"), kind);
  if (PENDING.includes(rel)) {
    if (found.length > 0) pendingSeen.add(rel);
    return;
  }
  for (const v of found) {
    violations.push(`${rel}:${v.line} — ${v.rule} (→ ${v.fix})\n    ${v.text}`);
  }
}

for (const top of INCLUDED) {
  for (const file of walk(join(SRC, top))) {
    const posix = file.split("\\").join("/");
    if (EXCLUDED_SEGMENTS.some((seg) => posix.includes(seg))) continue;
    check(file, file.endsWith(".tsx") ? "tsx" : "ts");
  }
}
for (const sheet of STYLESHEETS) check(join(SRC, sheet), "css");

const stale = PENDING.filter((file) => !pendingSeen.has(file));
if (stale.length > 0) {
  console.warn(
    `RTL guard: entrée(s) de PENDING sans faute restante, à retirer de la liste :\n  ${stale.join("\n  ")}`,
  );
}

if (violations.length > 0) {
  console.error(`RTL guard: ${violations.length} écart(s) directionnel(s) physique(s).`);
  console.error(
    `Utilise les propriétés logiques, ou documente l'exception avec \`// rtl-ok: <raison>\`.\n`,
  );
  for (const v of violations) console.error(v + "\n");
  process.exit(1);
}
console.log("RTL guard: OK (classes, styles en ligne, feuille de style, flèches et signes).");
