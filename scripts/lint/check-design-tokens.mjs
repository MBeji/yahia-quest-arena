/**
 * Colour-token guard (étude 14, D-4 volet 2 — activé au lot 10, après la purge).
 * Interdit en code métier :
 *  - les classes de PALETTE BRUTE Tailwind (`text-blue-400`, `from-amber-600`…) —
 *    elles ignorent les 2 thèmes ; la couleur passe par les tokens sémantiques
 *    (`primary`, `gold`, `success`, `destructive`, `flame`…) ;
 *  - `text-white` — encre codée en dur qui casse le thème clair (utiliser
 *    `text-foreground`, `text-primary-foreground` ou un token) ;
 *  - `bg-black` / `text-black` / `bg-white` — MAIS seulement dans les zones DÉJÀ
 *    migrées vers les tokens de surface (`MIGRATED`, levier 03). Ailleurs ils
 *    restent tolérés : le thème clair les rattrape encore par le remap
 *    `html.reference .app-shell { --color-black: … }`, et on ne bloque pas un
 *    dépôt entier sur une migration qui se fait écran par écran. Cette liste
 *    est un CLIQUET : elle s'allonge à chaque lot, elle ne raccourcit jamais.
 *
 * Périmètre et mécanique identiques au garde-fou RTL : src/{features,routes,
 * lib,shared,components} SAUF components/ui (shadcn vendorisé) et __tests__.
 * Exception documentée : `// token-ok: <raison>` sur la ligne ou juste au-dessus
 * (ex. les médailles du podium, les sections sombres fixes de la landing).
 *
 * Tourne dans `npm run lint` (zéro-warning → bloquant en CI).
 */
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";
import { fileURLToPath } from "node:url";

// fileURLToPath, not URL#pathname: pathname yields "/D:/…" on Windows, which
// join() then mangles into "D:\D:\…" (same fix as check-rtl-classes.mjs).
const ROOT = fileURLToPath(new URL("../..", import.meta.url));
const SRC = join(ROOT, "src");

const INCLUDED = ["features", "routes", "lib", "shared", "components"];
const EXCLUDED_SEGMENTS = ["/components/ui/", "/__tests__/"];

/**
 * Zones dont les surfaces passent par `bg-surface-{1,2,3}` : un `bg-black` qui y
 * réapparaît est une régression, parce que plus aucune règle CSS ne le repeindra
 * en clair (le remap `.game-surface` a été supprimé avec cette migration).
 * Chemins POSIX, comparés en préfixe depuis `src/`.
 */
const MIGRATED = ["features/quest/", "features/dashboard/", "routes/_authenticated/dashboard.tsx"];

const PALETTE =
  "(?:red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose|slate|gray|zinc|neutral|stone)";
const MIGRATED_RULES = [
  {
    name: "surface littérale dans une zone migrée",
    re: /\b(?:bg-black|text-black|bg-white)(?:\/\d+)?\b/,
    fix: "bg-surface-1|2|3, text-primary-foreground, ou media-scrim/ink-on-media pour du média",
  },
];

const RULES = [
  {
    name: "palette Tailwind brute",
    re: new RegExp(
      `(?:^|[\\s"'\`:])(?:bg|text|border|from|to|via|divide|ring|fill|stroke|shadow|outline|accent|caret|decoration)-${PALETTE}-\\d`,
    ),
    fix: "tokens sémantiques (primary/gold/success/destructive/flame…)",
  },
  {
    name: "text-white codé en dur",
    re: /\btext-white\b/,
    fix: "text-foreground / text-primary-foreground / token",
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
    let inBlock = false;
    lines.forEach((line, i) => {
      // Region exception: token-ok-block: <raison> … /token-ok-block (e.g. the
      // landing's fixed-dark showcase, whose real-gold accents are deliberate).
      if (line.includes("/token-ok-block")) inBlock = false;
      else if (line.includes("token-ok-block")) inBlock = true;
      if (inBlock) return;
      // Exception marker on the line itself or up to 3 lines above (multi-line JSX).
      for (let back = 0; back <= 3; back++) {
        if (lines[i - back]?.includes("token-ok")) return;
      }
      const rules = MIGRATED.some((zone) => posix.includes(`/src/${zone}`))
        ? [...RULES, ...MIGRATED_RULES]
        : RULES;
      for (const rule of rules) {
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
  console.error(`Token guard: ${violations.length} couleur(s) hors tokens en code métier.`);
  console.error(
    `Passe par les tokens sémantiques, ou documente l'exception avec \`// token-ok: <raison>\`.\n`,
  );
  for (const v of violations) console.error(v + "\n");
  process.exit(1);
}
console.log("Token guard: OK (aucune couleur hors tokens en code métier).");
