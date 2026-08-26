import { readdirSync, statSync } from "node:fs";
import { join } from "node:path";

const clientAssetsDir = join(process.cwd(), "dist", "client", "assets");

const BUDGETS = {
  "index-": 450 * 1024,
  // ---------------------------------------------------------------------------
  // Catalogues i18n. DEUX budgets depuis le 2026-08-26, parce que le catalogue
  // n'est plus monolithique :
  //   `i18n-`        le catalogue app-wide (fr/en/ar) — chargé par tout le monde ;
  //   `i18n-parent-` la surface parent — chargée avec /suivi et /parent-report.
  //
  // ## Pourquoi le plafond app-wide a BAISSÉ (208 → 184 KB)
  //
  // Le 2026-08-26 le chunk mesurait 207,65 KB pour 208,00 : 0,17 % de marge. La PR
  // #871 avait dû RETIRER deux de ses trois clés pour repasser le gate, et le
  // dix-septième relèvement était dû. Il n'a pas eu lieu. `parentReport.*` — que
  // l'entrée « 136→156 » désignait comme le premier candidat au découpage — est
  // sorti du catalogue, avec `parentDaily.*` qui sert les deux mêmes écrans :
  //
  //   avant   i18n 207,65 KB
  //   après   i18n 171,27 KB  +  i18n-parent 36,53 KB (chargé par les seuls parents)
  //
  // 36 KB rendus à chaque élève, et 12,7 KB de marge rendus au plafond app-wide.
  // Le mécanisme : `src/lib/i18n/parent/{fr,en,ar}.ts` (données pures, isolées par
  // `manualChunks`) + `useParentT()`, qui fusionne les deux catalogues — aucun
  // chemin de clé ne change côté écran. Détail : `src/lib/i18n/parent/index.ts`.
  //
  // ## Ce que la mesure a dit des DEUX AUTRES candidats
  //
  // Les entrées « 164→192 » et « 192→208 » ajoutaient `ai.*` et `tutor.*` à la liste
  // de ce qui justifierait le découpage. Le graphe d'imports, relu le 2026-08-26,
  // n'est d'accord que pour l'un des deux :
  //
  //   `tutor.*` (19,3 KB de source, fr+en+ar) — NON. Ses composants sont importés par `dashboard.tsx`,
  //     `quest.$exerciseId.tsx` et `chapitre.$chapterId.tsx` (route PUBLIQUE). Le
  //     sortir en chunk n'en ferait qu'une dépendance statique de plus du tableau de
  //     bord : les mêmes octets, dans un autre fichier. L'entrée « 192→208 » se
  //     trompait — la corriger ici plutôt que de la laisser induire un lot inutile.
  //
  //   `ai.*` (25,6 KB de source, fr+en+ar) — OUI, à deux clés près. Ses écrans (/forge, /console,
  //     /admin/ia, /parametrage) sont tous des routes paresseuses ; le seul
  //     consommateur monté par le dashboard et le lecteur de chapitre est
  //     `ForgeEntry`, et il n'utilise que `ai.forgeTitle` et `ai.forgeDesc`. Ces
  //     deux-là restent app-wide, les 116 autres partent (118 clés comptées dans
  //     `fr.ts` le 2026-08-26 — l'entrée « 164→192 » en annonçait 63, le namespace a
  //     doublé depuis). C'est le prochain lot.
  //
  // ## La règle, maintenant
  //
  // Une microcopy qui ne sert QU'À UNE SURFACE atteinte par des routes paresseuses
  // n'entre pas dans `TranslationKeys` : elle prend son catalogue et son budget, sur
  // le modèle de `parent/`. Relever `i18n-` reste permis, mais c'est devenu
  // l'exception qui doit dire pourquoi le découpage ne s'appliquait pas.
  //
  // ## Les seize paliers 80 → 208 KB, et ce que chacun a payé
  //
  // (La prose d'origine de chaque palier est dans `git log -p` sur ce fichier ; ce
  // qui reste utile ici, c'est la cadence — et elle est le vrai argument.)
  //    80→ 84  mentions légales + propriété intellectuelle trilingues
  //    84→ 88  badge bêta + canal de signalement de bug
  //    88→ 96  rapport famille actionnable + section « Espace Famille »
  //    96→100  namespace duels (étude 05)
  //   100→104  clés d'erreur de route (étude 14 lot 3, R-6)
  //   104→108  hub Arène + libellés de nav « Suivi parent » (étude 15 lot 5)
  //   108→116  funnel public (étude 15 lot 8) + drill-down lycée (étude 16 lot 3)
  //   116→118  mode rappel actif (étude 17 lot 4)
  //   118→120  lecteur « En vidéo » (étude 23 lot 2)
  //   120→128  parcours élève (étude 22)
  //   128→136  examen blanc, namespace `exam.*` (étude 02)
  //   136→156  suivi parental « jour par jour », ~110 clés ×3 — le plus gros d'un
  //            seul coup, et le premier à nommer le découpage comme le vrai correctif
  //   156→160  menu « Paramétrage » unique (`settings.*` + `adminHub.*`)
  //   160→164  suppression de compte (GAP-024) — 0,02 KB de dépassement
  //   164→192  mode IA « à la clé de la famille » (étude 29 lot 2), namespace `ai.*`
  //   192→208  tuteur « El Ostedh » (étude 11 lots 2-3), coaching + `tutor.chat.*`
  //
  // Le chunk app-wide gzippe à ~61 KB : l'impact réseau est plus doux que le chiffre
  // brut, mais le coût de parse se paie plein, lui, et sur chaque appareil d'élève.
  "i18n-": 184 * 1024,
  // Surface parent (`parentReport.*` + `parentDaily.*`), mesurée 36,52 KB le
  // 2026-08-26 ; plafond à +20 % parce que le suivi « jour par jour » est récent et
  // bouge encore. Ces octets ne descendent QUE chez les comptes parent — ils sont
  // tirés par l'import dynamique des routes /suivi et /parent-report. Si ce chunk
  // réapparaît un jour dans les imports STATIQUES du chunk index, le découpage est
  // cassé sans que rien ne rougisse : relire `manualChunks` dans `vite.config.ts`.
  "i18n-parent-": 44 * 1024,
  "vendor-supabase-": 240 * 1024,
  "vendor-motion-": 150 * 1024,
  // @dnd-kit (core+sortable+utilities) powering the B2 ordering/matching
  // boards — dedicated chunk (see vite.config manualChunks).
  "vendor-dndkit-": 64 * 1024,
  // Dashboard route chunk. Bumped 30→32 KB for the flagship-concours banner
  // integration (the banner trio is lazy-loaded into its own chunk; only the
  // small lazy glue lands here). Heavy sections (radar/3D, badges/shop) stay lazy.
  "dashboard-": 32 * 1024,
  // --- Vendor chunks that had NO budget until the 2026-08-10 perf/quality pass
  // (finding M1-fe). They were free to grow uncaught: every Radix primitive or
  // Lucide icon added anywhere in the app lands here, and nothing complained.
  // Ceilings are set ~15 % above the measured size at that date, so they catch a
  // real regression without tripping on ordinary churn.
  //
  // Radix primitives (measured 76.03 KB). Shared by every screen — it is on the
  // critical path, so growth here is felt everywhere.
  "vendor-radix-": 88 * 1024,
  // Lucide icons (measured 23.27 KB). Tree-shaken per import: a jump usually
  // means a barrel/namespace import (`import * as Icons`) slipped in.
  "vendor-icons-": 32 * 1024,
  // three.js landing scene (measured 856.85 KB). Lazy, desktop-only and
  // reduced-motion gated, so it never blocks first paint — but it is by far the
  // largest asset we ship, and it deserves a ceiling like everything else.
  "vendor-three-": 900 * 1024,
};

/**
 * ⚠️ Ici « kB » veut dire **KiB** (1024 octets) — les budgets ci-dessus aussi.
 * Le log de `vite build`, lui, compte en kB **décimaux** (1000 octets) : le même
 * chunk s'y affiche 2,34 % plus gros. Un `i18n-…js 175.38 kB` chez Vite est le
 * `171,27 kB` mesuré ici, et comparer les deux colonnes fait conclure à une
 * régression de 10 KB qui n'existe pas (perdu une reconstruction complète à ce
 * piège le 2026-08-26). Pour comparer un avant/après, lire **une seule** des deux
 * sources de bout en bout.
 */
function bytesToKb(bytes) {
  return (bytes / 1024).toFixed(2);
}

const BUDGET_PREFIXES = Object.keys(BUDGETS);

/**
 * Attribue un chunk à son budget LE PLUS SPÉCIFIQUE.
 *
 * Sans ça, `i18n-parent-<hash>.js` compterait aussi pour la clé `i18n-` — dont il
 * porte le préfixe — et comme on garde le plus GROS match, le jour où une surface
 * dépasserait le catalogue app-wide le budget `i18n-` mesurerait silencieusement
 * le mauvais fichier. Départager par longueur de hash est exclu : les hash Vite
 * contiennent des tirets (`vendor-radix-v7Qir-fi.js`). C'est donc le préfixe le
 * plus long qui gagne.
 */
function findLatestChunkSize(prefix) {
  const entries = readdirSync(clientAssetsDir).filter(
    (name) =>
      name.endsWith(".js") &&
      name.startsWith(prefix) &&
      !BUDGET_PREFIXES.some((other) => other.length > prefix.length && name.startsWith(other)),
  );
  if (entries.length === 0) return null;
  const sizes = entries.map((name) => ({
    name,
    size: statSync(join(clientAssetsDir, name)).size,
  }));
  sizes.sort((a, b) => b.size - a.size);
  return sizes[0];
}

let failed = false;

console.log("Bundle budget check:\n");
for (const [prefix, maxSize] of Object.entries(BUDGETS)) {
  const chunk = findLatestChunkSize(prefix);
  if (!chunk) {
    console.log(`- ${prefix}: skipped (chunk not found)`);
    continue;
  }

  const ok = chunk.size <= maxSize;
  const status = ok ? "OK" : "FAIL";
  console.log(
    `- ${chunk.name}: ${bytesToKb(chunk.size)} kB / budget ${bytesToKb(maxSize)} kB => ${status}`,
  );

  if (!ok) failed = true;
}

if (failed) {
  console.error("\nBundle budget check failed.");
  process.exit(1);
}

console.log("\nBundle budget check passed.");
