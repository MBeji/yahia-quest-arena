---
name: verify
description: >-
  Run the local quality gate for yahia-quest-arena before declaring any task
  done or pushing. Runs lint + typecheck + tests (and optionally the full CI
  gate with coverage + build). Use whenever the user asks to "verify", "check
  before push", confirm a change is safe, or after finishing an implementation.
---

# Local quality gate

This project ships with a strict, zero-warning gate. **Never declare a coding
task complete until this gate is green.**

## Steps

1. Run the fast gate:

   ```bash
   npm run verify
   ```

   This runs, in order — les quatre gates à ~2 s **d'abord**, pour qu'un invariant
   cassé rougisse en 8 s au lieu d'attendre ~4 min de tests :
   - `npm run eol:check` — aucun CRLF dans l'arbre (piège Windows).
   - `npm run leak:check` — aucun corpus ni skill pédagogique au tip (étude 24).
   - `npm run db:check-chain` — une base VIERGE se reconstruit depuis les migrations.
   - `npm run harness:check` — anti-dérive du harnais (pointeurs, budget d'AGENTS.md et
     son inventaire de features, Unicode invisible, ids de modèle, Actions épinglées,
     YAML strict de `.github/**`, vues générées en phase).
   - `npm run lint` — ESLint, `--max-warnings=0` (Prettier rules included) + les gardes
     RTL et tokens de couleur.
   - `npm run typecheck` — `tsc --noEmit` (strict).
   - `npm run test` — Vitest (full suite).

2. If anything fails:
   - Read the actual error output; do not guess.
   - Fix the **root cause** in the source — do not weaken the gate
     (no disabling ESLint rules, no `// @ts-ignore`, no lowering coverage
     thresholds, no `--no-verify`) unless the user explicitly approves and you
     document why.
   - Re-run `npm run verify` until clean.

3. For a release-grade check (matches CI exactly), also run:

   ```bash
   npm run ci:verify
   ```

   This adds `perf:check` (le harnais k6 parse et ses constantes suivent le produit),
   `test:coverage` (enforces coverage thresholds), `build:check` (production build +
   bundle budget) and `audit:deps` — ce dernier **en dernier**, parce qu'il interroge le
   registre au moment du run et peut rougir sur un arbre qui n'a pas bougé.

   ⚠️ **Les gates contenu n'en font plus partie.** `content:qa:strict` et
   `content:audit:strict` sont partis avec le corpus dans le dépôt **privé** (étude 24) ;
   ils tournent dans sa Content CI, qui checkout ce dépôt-ci pour le moteur. Et la CI
   d'ici n'est pas non plus l'exact miroir de `ci:verify` : elle ajoute `smoke:shell`
   (le seul étage qui exécute le bundle prod dans un vrai Chromium).

## Reporting

End with a clear go/no-go:

- ✅ green: state which steps passed.
- ❌ red: name the failing step, the root cause, and what you changed (or what
  remains) — never report success on a red gate.
