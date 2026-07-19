#!/usr/bin/env node
/**
 * Curated-video health check (étude 23 lot 4, R-12/US-8).
 *
 * For every `active` entry of `content/videos.json`, asks the PUBLIC oEmbed
 * endpoint whether the video is still live AND embeddable. No API key, no
 * secret, no dependency — the endpoint is anonymous.
 *
 *   200 → ok       public + embeddable
 *   400 → broken   malformed video id
 *   401 → broken   embedding disabled by the owner
 *   403 → broken   video is private
 *   404 → broken   video was deleted
 *   anything else / network failure / timeout → unknown
 *
 * `unknown` is deliberate: the endpoint carries no SLA, so a flaky network must
 * never produce a FALSE `broken`. The checker only ever PROPOSES a verdict — it
 * NEVER writes to content/videos.json (R-12: a human session applies the change,
 * an issue traces it).
 *
 * Usage:
 *   node scripts/content/check-videos.mjs [--content-dir content] [--throttle-ms 1000]
 *
 * Exit code: 1 when at least one `broken` video was found (so CI can react),
 * 0 otherwise — including when everything is `unknown` (network trouble is not
 * a content defect).
 */
import { existsSync, readFileSync, readdirSync, statSync } from "node:fs";
import { join, resolve } from "node:path";
import { argv, cwd, exit, stdout } from "node:process";

export const OEMBED_ENDPOINT = "https://www.youtube.com/oembed";

/** Map an oEmbed HTTP status onto the verdict proposed for the registry. */
export function verdictForStatus(status) {
  switch (status) {
    case 200:
      return { verdict: "ok", reason: "public and embeddable" };
    case 400:
      return { verdict: "broken", reason: "malformed video id" };
    case 401:
      return { verdict: "broken", reason: "embedding disabled by the owner" };
    case 403:
      return { verdict: "broken", reason: "video is private" };
    case 404:
      return { verdict: "broken", reason: "video was deleted" };
    default:
      return { verdict: "unknown", reason: `unexpected HTTP ${status}` };
  }
}

/** The anonymous oEmbed probe URL for a YouTube video id. */
export function oembedUrl(videoId) {
  const watch = `https://www.youtube.com/watch?v=${videoId}`;
  return `${OEMBED_ENDPOINT}?url=${encodeURIComponent(watch)}&format=json`;
}

/**
 * Probe ONE registry entry. Any throw (network, DNS, timeout) degrades to
 * `unknown` — never to `broken`.
 */
export async function checkEntry(id, entry, { fetchImpl = fetch, timeoutMs = 10_000 } = {}) {
  if (entry.provider !== "youtube") {
    return { id, verdict: "unknown", reason: `unsupported provider "${entry.provider}"` };
  }
  try {
    const res = await fetchImpl(oembedUrl(entry.videoId), {
      signal: AbortSignal.timeout(timeoutMs),
    });
    return { id, videoId: entry.videoId, ...verdictForStatus(res.status) };
  } catch (err) {
    return {
      id,
      videoId: entry.videoId,
      verdict: "unknown",
      reason: `network error: ${err?.message ?? String(err)}`,
    };
  }
}

/** Probe every `active` entry, throttled (~1 req/s by default — be a good citizen). */
export async function checkRegistry(registry, { fetchImpl, throttleMs = 1000, onResult } = {}) {
  const active = Object.entries(registry).filter(([, e]) => e?.status === "active");
  const results = [];
  for (let i = 0; i < active.length; i++) {
    if (i > 0 && throttleMs > 0) await new Promise((r) => setTimeout(r, throttleMs));
    const [id, entry] = active[i];
    const result = await checkEntry(id, entry, { fetchImpl });
    results.push(result);
    onResult?.(result);
  }
  return results;
}

/**
 * Which subjects reference the given video ids — the list of `content:build
 * --subject <id>` rebuilds a session must run after retiring a dead video
 * (US-8: the issue names them so nobody has to hunt).
 */
export function findReferencingSubjects(contentDir, ids) {
  const wanted = new Set(ids);
  const hits = new Map(); // subjectId -> Set(videoId)
  if (wanted.size === 0 || !existsSync(contentDir)) return [];

  const note = (subject, videoId) => {
    if (!hits.has(subject)) hits.set(subject, new Set());
    hits.get(subject).add(videoId);
  };
  const readJson = (p) => {
    try {
      return JSON.parse(readFileSync(p, "utf8"));
    } catch {
      return null;
    }
  };
  const dirs = (p) =>
    existsSync(p) ? readdirSync(p).filter((n) => statSync(join(p, n)).isDirectory()) : [];

  for (const subject of dirs(contentDir)) {
    const subjectDir = join(contentDir, subject);
    if (!existsSync(join(subjectDir, "subject.json"))) continue;
    for (const chapter of dirs(subjectDir)) {
      const chapterDir = join(subjectDir, chapter);
      const meta = readJson(join(chapterDir, "chapter.json"));
      for (const ref of meta?.videos ?? []) if (wanted.has(ref)) note(subject, ref);

      const exDir = join(chapterDir, "exercices");
      if (!existsSync(exDir)) continue;
      for (const file of readdirSync(exDir).filter((f) => f.endsWith(".json"))) {
        const ref = readJson(join(exDir, file))?.correctionVideo;
        if (ref && wanted.has(ref)) note(subject, ref);
      }
    }
  }
  return [...hits.entries()]
    .map(([subject, vids]) => ({ subject, videos: [...vids].sort() }))
    .sort((a, b) => a.subject.localeCompare(b.subject));
}

const getFlag = (name, fallback) => {
  const i = argv.indexOf(`--${name}`);
  return i !== -1 ? argv[i + 1] : fallback;
};

async function main() {
  const contentDir = resolve(cwd(), getFlag("content-dir", "content"));
  const throttleMs = Number(getFlag("throttle-ms", "1000"));
  const registryPath = join(contentDir, "videos.json");

  const registry = existsSync(registryPath)
    ? JSON.parse(readFileSync(registryPath, "utf8"))
    : /* absent registry = nothing to check (pre-campaign) */ {};

  const results = await checkRegistry(registry, { throttleMs });
  const broken = results.filter((r) => r.verdict === "broken");
  const unknown = results.filter((r) => r.verdict === "unknown");

  const report = {
    checkedAt: new Date().toISOString(),
    total: results.length,
    ok: results.length - broken.length - unknown.length,
    broken,
    unknown,
    // Rebuild targets for the broken ones (R-12): retire the video, then rebuild.
    subjectsToRebuild: findReferencingSubjects(
      contentDir,
      broken.map((b) => b.id),
    ),
  };
  stdout.write(`${JSON.stringify(report, null, 2)}\n`);
  exit(broken.length > 0 ? 1 : 0);
}

// Run only as a CLI — importing the module (tests) must never probe the network.
if (argv[1]?.endsWith("check-videos.mjs")) {
  await main();
}
