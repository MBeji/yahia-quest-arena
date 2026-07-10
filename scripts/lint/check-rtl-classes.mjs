/**
 * RTL guard (étude 14, D-4 / R-2) — forbids PHYSICAL directional Tailwind
 * classes in métier code, where the trilingual app must mirror under RTL.
 * Logical properties are the rule: ms-/me-, ps-/pe-, start-/end-,
 * text-start/text-end, rounded-s/e, border-s/e.
 *
 * Scope: src/features, src/routes, src/lib, src/shared, src/components
 * EXCEPT src/components/ui (vendored shadcn, LTR-audited separately) and
 * __tests__ (tests may assert literal class names).
 *
 * Documented exception (RISK-3): append `// rtl-ok: <reason>` (or embed
 * `rtl-ok` in a comment on the same line) when a physical class is correct
 * in BOTH directions — e.g. `left-1/2` centering is already allowed, and a
 * numeric input pinned LTR keeps its physical alignment.
 *
 * Runs in `npm run lint` (zero-warning gate) and therefore in CI.
 */
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";

const ROOT = new URL("../..", import.meta.url).pathname;
const SRC = join(ROOT, "src");

const INCLUDED = ["features", "routes", "lib", "shared", "components"];
const EXCLUDED_SEGMENTS = ["/components/ui/", "/__tests__/"];

const RULES = [
  {
    name: "margin/padding physiques",
    re: /(?:^|[\s"'`:])-?(?:ml|mr|pl|pr)-(?:\d|\[|px)/,
    fix: "ms-/me-/ps-/pe-",
  },
  {
    name: "text-left/text-right",
    re: /\btext-(?:left|right)\b/,
    fix: "text-start/text-end",
  },
  {
    name: "position left-/right- physique",
    // left-1/2 + -translate-x-1/2 centering is symmetric in RTL — allowed.
    re: /(?:^|[\s"'`])-?(?:left|right)-(?!1\/2)(?:\d|\[)/,
    fix: "start-/end-",
  },
  {
    name: "rounded-l/r physiques",
    re: /\brounded-(?:l|r|tl|tr|bl|br)(?:\b|-)/,
    fix: "rounded-s/e (ss/se/es/ee)",
  },
  {
    name: "border-l/r physiques",
    re: /\bborder-(?:l|r)(?:\b|-(?:\d|\[))/,
    fix: "border-s/border-e",
  },
];

function* walk(dir) {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) yield* walk(full);
    else if (/\.(ts|tsx)$/.test(entry)) yield full;
  }
}

const violations = [];
for (const top of INCLUDED) {
  for (const file of walk(join(SRC, top))) {
    const posix = file.split("\\").join("/");
    if (EXCLUDED_SEGMENTS.some((seg) => posix.includes(seg))) continue;
    const lines = readFileSync(file, "utf8").split("\n");
    lines.forEach((line, i) => {
      // Exception marker on the line itself or up to 3 lines above (multi-line JSX).
      for (let back = 0; back <= 3; back++) {
        if (lines[i - back]?.includes("rtl-ok")) return;
      }
      for (const rule of RULES) {
        if (rule.re.test(line)) {
          violations.push(
            `${relative(ROOT, file)}:${i + 1} — ${rule.name} (→ ${rule.fix})\n    ${line.trim()}`,
          );
        }
      }
    });
  }
}

if (violations.length > 0) {
  console.error(
    `RTL guard: ${violations.length} classe(s) directionnelle(s) physique(s) en code métier.`,
  );
  console.error(
    `Utilise les propriétés logiques, ou documente l'exception avec \`// rtl-ok: <raison>\`.\n`,
  );
  for (const v of violations) console.error(v + "\n");
  process.exit(1);
}
console.log("RTL guard: OK (aucune classe directionnelle physique en code métier).");
