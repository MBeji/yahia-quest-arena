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
  // namespace (étude 05: hub/arena/recap copy). The chunk gzips to ~30 KB, so
  // the real over-the-wire impact is marginal; keep new strings lean to stay
  // well under this ceiling.
  "i18n-": 100 * 1024,
  "vendor-supabase-": 240 * 1024,
  "vendor-motion-": 150 * 1024,
  // @dnd-kit (core+sortable+utilities) powering the B2 ordering/matching
  // boards — dedicated chunk (see vite.config manualChunks).
  "vendor-dndkit-": 64 * 1024,
  // Dashboard route chunk. Bumped 30→32 KB for the flagship-concours banner
  // integration (the banner trio is lazy-loaded into its own chunk; only the
  // small lazy glue lands here). Heavy sections (radar/3D, badges/shop) stay lazy.
  "dashboard-": 32 * 1024,
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
