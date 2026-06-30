# 📋 Plan d'action — Audit yahia-quest-arena

Checklist priorisée issue de l'audit du `2026-06-30` (commit `5fc5452`). Effort : **S** < 0.5 j · **M** 0.5–2 j · **L** > 2 j.

## 🔴 P1 — Important (montée en charge)

- [ ] **Agrégats `subject_stats`** — Créer une vue/RPC SQL `GROUP BY subject_id` et remplacer le fetch non borné des `attempts` dans `getDashboard` (`src/features/dashboard/dashboard.server.ts:50`, `TODO(review #18)`). _(Effort : M · Axe : ⚡ Perf)_

## 🟠 P2 — Prioritaire

- [ ] **Batcher l'entitlement** — Remplacer le N+1 `has_parcours_entitlement` de `getParcours` (`dashboard.server.ts:348-365`) par un RPC _batch_/jointure, avant tout élargissement du catalogue premium. _(M · ⚡ Perf)_
- [ ] **Tagging des releases** — Mettre en place un workflow « release » (tags SemVer annotés après CI verte) conformément à `docs/release-tagging-policy.md` (actuellement 0 tag). _(S · 🔀 Versions)_
- [ ] **Combler les trous de tests** — Couvrir `recoverStreak` (`progression.server.ts:9-77`) et `handlePushCron` (`notifications.cron.server.ts:36-100`) ; remonter `content-protection.ts` au‑dessus du seuil. _(M · 🧪 Tests)_

## 🟡 P3 — Recommandé

- [ ] **Corriger la vuln _low_** — `npm audit fix` pour `@babel/core` (GHSA‑4x5r‑pxfx‑6jf8, dev/transitive), puis monter le lot de _minors_ en retard via `upgrade-guard`. _(S · 📦 Stack)_
- [ ] **Réactiver `no-unused-vars`** — `@typescript-eslint/no-unused-vars` avec `argsIgnorePattern: "^_"` dans `eslint.config.js` pour outiller la détection de code mort. _(S · 📝 Qualité)_
- [ ] **Durcir la redaction du logger** — Ajouter `authorization`, `bearer`, `cookie` à la liste, ou masquer par valeur (`shared/lib/logger.ts:14-21`). _(S · 🪵 Logging)_
- [ ] **Découper les gros fichiers** — Scinder `quest.server.ts` (session / contenu / public) et extraire des sous‑composants de `routes/_authenticated/dashboard.tsx`. _(M · 📝 Qualité)_

## 🟢 P4 — Nice to have

- [ ] **Batcher l'élagage push** — Une requête `DELETE … IN (...)` au lieu d'un `DELETE` par endpoint mort (`notifications.cron.server.ts:73-92`). _(S · ⚡ Perf)_
- [ ] **Budget de perf runtime** — Ajouter Lighthouse CI / suivi LCP en complément du budget bundle. _(M · 🧪 Tests)_

---

### ✅ Points forts à préserver (ne pas régresser)

- [x] Isolation _feature_ totale (0 import croisé) — gardée par la convention `shared/`.
- [x] Sécurité défense‑en‑profondeur (RLS + RPC `SECURITY DEFINER` + trigger anti‑escalade + CSRF + Zod) prouvée en pgTAP.
- [x] Dette quasi nulle (0 `@ts-ignore`/`as any` applicatif) — gardée par la _gate_ `--max-warnings=0`.
- [x] Couverture 93.8 % scopée au code possédé — seuils 80 % non dilués.
- [x] CI/CD industrialisée (11 workflows : migration‑gate, prod‑apply gardé, regression/upgrade/content guards).
