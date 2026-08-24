import { readdirSync, statSync } from "node:fs";
import { join } from "node:path";

const clientAssetsDir = join(process.cwd(), "dist", "client", "assets");

const BUDGETS = {
  "index-": 450 * 1024,
  // i18n catalog (loaded app-wide). Bumped 80→84 KB for the trilingual legal /
  // intellectual-property notice + print/footer copy (public IP-protection
  // change), then 84→88 KB for the trilingual beta badge + bug-report channel
  // strings, then 88→96 KB for the trilingual actionable family report
  // (chapter insights, weekly comparison, advice, print) + the « Espace
  // Famille » landing section, then 96→100 KB for the trilingual duels
  // namespace (étude 05: hub/arena/recap copy), then 100→104 KB for the
  // trilingual route-error keys (étude 14 lot 3, R-6 : the public-tier
  // load-failure messages leave hardcoded French for the i18n catalog).
  // The chunk gzips to ~36 KB, so the real over-the-wire impact is marginal;
  // keep new strings lean to stay well under this ceiling. Then 104→108 KB for
  // the trilingual Arène-hub namespace + « Suivi parent » nav labels (étude 15
  // lot 5: the /arene pole + the public /suivi entry points) — the hub reuses
  // the modes' own titles/pitches (DRY) so only its reward hints are new keys.
  // Then 108→116 KB for the trilingual funnel-public keys (étude 15 lot 8: landing
  // proof band + per-door CTAs + per-theme extras descriptors) stacked on the lycée
  // drill-down namespace (étude 16 lot 3: `lycee.*` + `lyceeYearDesc`) — headroom
  // reserved for the remaining étude 15 lots (auth/onboarding/arène/parent/admin copy).
  // Then 116→118 KB for the trilingual recall-mode keys (étude 17 lot 4: result-screen
  // badge/unlock + hub chip copy) — a handful of short keys, restores the headroom.
  // Then 118→120 KB for the trilingual « En vidéo » reader keys (étude 23 lot 2: section
  // title, play aria-label, hosting attribution, duration badge, two-click consent hint).
  // Then 120→128 KB for étude 22 (parcours élève) : nœud « recommandé » de la carte, jalon
  // « chapitre terminé », libellés de pool du donjon, onglet + état creux « Ma classe »,
  // overline/titre de la révision du jour, et le libellé `beat_2_bosses` qui manquait aux
  // trois dictionnaires. Le lot 4 laissait 0,36 KB de marge : la réserve est reconstituée
  // pour le lot 3 (bannière de rentrée), sinon la CI casserait sur la première clé suivante.
  // Puis 128→136 KB pour l'étude 02 (examen blanc) : un namespace `exam.*` complet — catalogue,
  // passation (chrono, navigation entre épreuves, état de sauvegarde), et copie corrigée
  // (note /20, barème par épreuve, percentile, corrigé question par question). 35 clés payées
  // ×3 langues, l'arabe étant le plus lourd en octets : le seuil sautait de 0,89 KB. On reprend
  // 7 KB de marge plutôt que le strict nécessaire, sinon la clé suivante casse la CI d'une PR
  // qui n'y sera pour rien.
  // Puis 136→156 KB pour le **suivi parental « jour par jour »** : ~110 clés dans les trois
  // dictionnaires (sélecteur de période, résumé, KPI, facteurs des deux indices, tableau des
  // matières, 12 gabarits d'alerte). C'est de loin le plus gros namespace ajouté d'un coup, et
  // il ne sert qu'aux comptes PARENT : si le catalogue i18n doit un jour être découpé par
  // surface plutôt que chargé en bloc, c'est ce namespace-là qui le justifiera en premier.
  // Puis 156→160 KB pour le **menu « Paramétrage » unique** : 29 clés (namespace `settings.*`
  // + `adminHub.*` + deux libellés de nav) ×3 langues, soit 0,96 KB de dépassement — le lot
  // précédent ne laissait qu'un kilo-octet de marge. Toutes les clés sont utilisées : la page-pôle
  // nomme ses cinq sections et ce que chacune règle, ce qu'aucune chaîne existante ne disait. On
  // reprend ~3 KB de réserve plutôt que le strict nécessaire, par la même raison qu'au lot
  // précédent : sinon la clé suivante casse la CI d'une PR qui n'y sera pour rien.
  // Puis 160→164 KB pour la **suppression de compte** (GAP-024) : 15 clés `settings.delete*`
  // ×3 langues + un `not_found` reformulé, soit 160,03 KB pour un plafond à 160,00 — DEUX
  // CENTIÈMES de kilo-octet de dépassement. C'est le dixième relèvement documenté, et le
  // troisième d'affilée où la réserve laissée par le lot précédent est mangée à l'unité près :
  // les ~3 KB repris la dernière fois n'ont tenu qu'une PR. Aucune clé n'est superflue — le
  // typecheck l'exige, et deux d'entre elles existent pour ne PAS mentir (`deleteDialogWhatParent`,
  // parce qu'un parent n'a ni XP ni séries à perdre ; `deleteRowLabel`, parce que l'intitulé et
  // le bouton diraient sinon la même phrase). On reprend 4 KB.
  // ⚠️ Ce plafond n'est plus une garde, c'est un métronome : à ce rythme, le vrai correctif est
  // le découpage du catalogue i18n par surface — le namespace `parentReport.*` (~110 clés, comptes
  // PARENT uniquement) le justifie à lui seul, comme noté au relèvement 136→156.
  // Puis 164→192 KB pour le **mode IA « à la clé de la famille »** (étude 29 lot 2) : le namespace
  // `ai.*`, ~63 clés ×3 langues, mesuré à 171,89 KB — 7,89 KB au-dessus du plafond. Il porte
  // beaucoup de PHRASES et non des étiquettes, et ce n'est pas un travers de rédaction : R-20 exige
  // un texte de consentement qui liste ce qui part et ce qui ne part pas, R-2a un avertissement
  // calibré, R-12 une mention de renvoi au fournisseur PERMANENTE, R-18bis le risque de la
  // vérification coupée énoncé en une phrase, et l'annexe C neuf codes d'erreur traduits. Raccourcir
  // ces chaînes, c'est retirer la mitigation, pas de la graisse.
  // On reprend 20 KB de marge plutôt que les 8 nécessaires : les lots 3 à 5 de la même étude
  // (activation par élève, Forge, console de dépense) ajouteront leurs propres clés, et le
  // relèvement suivant tomberait sur la PR qui n'y sera pour rien — le motif exact des trois
  // derniers. Ce namespace-ci rejoint `parentReport.*` sur la liste de ce qui justifiera le
  // découpage : il ne sert qu'aux comptes ayant branché une clé, c'est-à-dire à presque personne.
  // Puis 192→208 KB pour le **tuteur « El Ostedh »** (étude 11, lots 2 et 3) : la bibliothèque
  // de coaching (18 phrases ×3 langues, R-10 — elles remplacent un appel de modèle par jour et
  // par élève, donc chaque octet ici est un token qui ne part pas) et le namespace `tutor.chat.*`
  // (15 clés ×3). Mesuré à 194,08 KB, soit 2,08 KB au-dessus.
  // On reprend 16 KB plutôt que les 3 nécessaires, pour la raison désormais habituelle : les lots
  // 4 à 7 de la même étude (mini-checks, escalades, bilans, énergie) ajouteront les leurs, et le
  // relèvement suivant tomberait sur la PR qui n'y sera pour rien.
  // ⚠️ Le constat du relèvement 164→192 tient toujours, et se renforce : c'est le SIXIÈME
  // relèvement de ce plafond. `tutor.*` rejoint `parentReport.*` et `ai.*` sur la liste de ce qui
  // justifie le découpage du catalogue par surface — il ne sert qu'aux comptes ayant le mode IA
  // allumé, et il est chargé par tout le monde.
  "i18n-": 208 * 1024,
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

function bytesToKb(bytes) {
  return (bytes / 1024).toFixed(2);
}

function findLatestChunkSize(prefix) {
  const entries = readdirSync(clientAssetsDir).filter(
    (name) => name.startsWith(prefix) && name.endsWith(".js"),
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
