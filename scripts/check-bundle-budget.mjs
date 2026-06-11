import { readdirSync, statSync } from "node:fs";
import { join } from "node:path";

const clientAssetsDir = join(process.cwd(), "dist", "client", "assets");

const BUDGETS = {
  "index-": 450 * 1024,
  "i18n-": 80 * 1024,
  "vendor-charts-": 390 * 1024,
  "vendor-supabase-": 240 * 1024,
  "vendor-motion-": 150 * 1024,
  "dashboard-": 30 * 1024,
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
