---
name: content-videos
description: >-
  Curate free external explainer videos (YouTube) for a chapter of content/ and
  register them in the versioned registry content/videos.json (étude 23). Use
  whenever the user wants to "ajouter des vidéos" to a chapter/subject, "trouver
  une vidéo qui explique <notion>", run a video curation campaign for a grade or
  matière, replace a dead video flagged by the weekly health-check, or fill the
  « En vidéo » section of a course. This skill PROPOSES and DOCUMENTS a video —
  it never embeds one that a human has not watched end-to-end (R-3). It writes
  registry entries + chapter/exercise refs + a local poster; never SQL, never a
  DB write. Defers to content-engine for the content pipeline and to
  content-ecole-tn for official-programme fidelity.
---

# content-videos — curating explainer videos

The app embeds **free, external, hand-picked** videos (phase A of étude 23). It
hosts nothing, produces nothing, and never lets an algorithmic feed near a
student. Every video is chosen one by one, watched in full, and recorded with
who validated it and when.

**Read first**: `FableEtudes/23-videos-explicatives/ETUDE.md` (the closed design)
and `references/video-sources.md` (the channel allowlist + known gaps).

## Non-negotiables

1. **A video the curator has not watched IN FULL never ships.** One wrong video
   is worse than no video (same doctrine as the étude-18 figures).
2. **The registry is the source of truth.** Content files reference **ids**, never
   URLs. `content/videos.json` holds the full record.
3. **Never edit the DB or write SQL.** You produce files; the build compiles them.
4. **The language of the video = the subject's `contentLanguage`** (R-8). A maths
   9ᵉ video must be in Arabic — the subject's language of instruction. If the
   Arabic pool is too thin for a chapter, **document the gap; never substitute
   French.** Escalate to Mohamed rather than deciding alone.
5. **Only channels on the allowlist** (`references/video-sources.md`, arbitrated
   in Q-1). The allowlist authorises a _channel_; each _video_ still passes the
   grid below.
6. **0–3 videos per chapter**, ordered — the first is the chapter's default
   review video on a failed run (R-6/R-11).

## The relevance grid (R-2) — every criterion is eliminatory

Record the verdict of each in the entry's `notes`.

1. **Language** — equals the subject's `contentLanguage`.
2. **Programme alignment** — explains the notion **as the official Tunisian
   programme defines it**, not merely the same topic. A divergence of _method_
   eliminates; a divergence of progression/terminology is noted in `notes`.
3. **Level** — vocabulary, prerequisites and pace fit the target grade's age.
4. **Format** — one notion per video; 2–15 min (a longer format is usable only as
   an extract via `startSec`/`endSec`; `content:qa` warns above 15 min).
5. **Accuracy** — watched in full, zero mathematical/scientific error tolerated.
6. **Notation** — consistent with `math-and-notation.md` (Western digits, standard
   notation). A divergent notation eliminates for the primary cycle; it is noted
   for the lycée.
7. **Channel** — on the allowlist, embedding enabled, established, no intrusive
   product placement inside the video.

## Runbook

1. **Scope** — one chapter at a time. Read its `cours.md` to know the exact
   notion, its vocabulary and the programme's method.
2. **Search** — inside the allowlisted channels for that cycle × matière × language.
3. **Watch in full.** Apply the grid. Reject fast and without regret.
4. **Collect the record**: `videoId` (the 11-char id — from `watch?v=…`), exact
   title, channel, real duration (or the extract bounds), and the
   **made-for-kids** status (R-14, a developer obligation). With a _local,
   optional_ YouTube Data API key you can read `status.embeddable`,
   `status.madeForKids` and `contentDetails.regionRestriction` in one call — it
   is a curation-workstation convenience, **never a dependency of the app, the
   CI or the workflow**. Without it, note them manually.
5. **Download the poster** to `public/video-posters/<registry id>.jpg` (D-11 —
   this is what makes the facade truly zero-third-party-request before the click;
   ~15–30 KB, named by the REGISTRY id, not the YouTube id). If you cannot, skip
   it: the facade degrades to a styled card, it never breaks.
6. **Write the registry entry** in `content/videos.json` (shape below).
7. **Reference it**: `videos: ["<id>"]` in `chapter.json`, and/or
   `correctionVideo: "<id>"` on a boss exercise when a dedicated
   "classic mistakes" video exists.
8. **Validate**: `npm run content:check` then `npm run content:qa:strict`.
9. **Rebuild only the touched subject**: `npm run content:build -- --subject <id>`
   — **never** bare `content:build` (it regenerates all ~60 subjects).
10. **The PR description lists every video added** with channel, duration, notion
    and the reason it was selected (R-3).

## Registry entry

```jsonc
{
  "math.thales-configuration": {
    "provider": "youtube",
    "videoId": "AbCdEfGhIjK", // 11 chars — the ONLY field used to build the embed URL
    "title": "Théorème de Thalès — la configuration", // in `lang`
    "channel": "Maths et tiques",
    "channelUrl": "https://www.youtube.com/@MathsetTiques", // registry only, never compiled
    "lang": "fr", // MUST equal the subject's contentLanguage
    "durationSec": 480, // of the EXTRACT when start/end are set
    "kind": "teacher", // teacher | official | ai
    "grades": ["9eme-base"], // curation hints (canonical slugs)
    "notions": ["configuration de Thalès"],
    "competencies": ["math.geo.thales-direct"], // OPTIONAL — étude 07 ids
    "startSec": 312, // OPTIONAL — extract of a long format
    "endSec": 540, // OPTIONAL — must exceed startSec
    "madeForKids": false, // relevé à la curation (R-14)
    "addedOn": "2026-07-20",
    "verifiedOn": "2026-07-20", // REQUIRED while status is active (R-3)
    "verifiedBy": "Mohamed",
    "status": "active", // active | broken | retired
    "notes": "Notation identique au cours ; aucune divergence de méthode.",
  },
}
```

**Ids are stable for life**: create or retire, never rename (they key the poster
file, the analytics and the content refs).

## Lifecycle (R-12)

Only an `active` entry is compiled. Referencing a non-`active` video from content
is a `content:qa` **error**.

The weekly workflow `.github/workflows/video-health.yml` runs
`npm run content:videos:check` (anonymous oEmbed probe, no key) and opens a
tracking issue listing dead videos **and the subjects to rebuild**. It only ever
_proposes_: **a human applies the change.** To retire one:

1. set its `status` to `broken` (or `retired`), or replace the video;
2. drop or re-point the refs in the affected `chapter.json` / exercise files;
3. rebuild those subjects (`content:build -- --subject <id>`).

A network failure is reported as `unknown`, never `broken` — never retire a video
on an unverified verdict.

## Out of scope

Per-question videos (the text `explanation` covers that — D-7); hosting anything;
generating videos (phase B, gated behind Q-4); any gameplay coupling — no XP, no
coins, no badge, no "watch to continue" gate (R-10); any link that sends a student
out to YouTube (R-9).
