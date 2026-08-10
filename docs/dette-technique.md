# Dette technique — ce qui reste vraiment ouvert

> **Vérifié dans le code le 2026-08-02** (`main` à #703). Ce fichier remplace le plan d'action
> de l'audit du 2026-06-30, dont la moitié des items « ouverts » étaient soldés sans que
> personne ne coche la case — c'est précisément le genre de rot qu'un backlog non vérifié
> produit. **Règle** : on n'inscrit ici qu'une dette dont on a re-lu la ligne de code, et on
> la sort quand la ligne a changé, pas quand on croit s'en souvenir.
>
> L'audit d'origine est archivé : [`docs/archive/2026-06-30-audit-codebase.md`](./archive/2026-06-30-audit-codebase.md)
> (+ ses métriques `.csv`). Les axes **perf** ont leur propre document vivant,
> [`docs/performance-audit.md`](./performance-audit.md), et son harnais de charge
> [`perf/README.md`](../perf/README.md).

## Ouvert

| Dette                                                                                                                                                                                                                                                                                                                                                                                                | Où                                                                              | Effort | Axe          |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------ | ------------ |
| **Deux gros fichiers** — `quest.server.ts` (1 008 l.) mêle session, contenu et surface publique ; `dashboard.tsx` (547 l.) gagnerait à extraire ses sous-composants                                                                                                                                                                                                                                  | `src/features/quest/quest.server.ts`, `src/routes/_authenticated/dashboard.tsx` | M      | 📝 Qualité   |
| **Pas de budget de perf runtime** — le budget **bundle** existe (`build:check`, 9 chunks gardés depuis le 2026-08-10) et le harnais de charge aussi (`perf:check` = k6 côté Postgres/RPC), mais rien ne surveille le **LCP réel**. Un Lighthouse CI comblerait le trou                                                                                                                               | CI                                                                              | M      | 🧪 Tests     |
| **`npm ci` échoue sur Node 22** — le runtime que documentait AGENTS.md. #716 a retiré du lock le `typescript@5.9.3` imbriqué dont `tsconfck` a besoin ; npm 11 s'en sort, npm 10 (celui de Node 22) meurt en `EUSAGE`. `.nvmrc` dit 24, la CI dit 24. **À vérifier en priorité : la version de npm de l'image de _build_ Vercel** — si elle est < 11, les déploiements échouent depuis le 2026-08-09 | `package-lock.json`, `.nvmrc`, `scripts/build-vercel.mjs:107`                   | S      | 🔧 Outillage |

## Latent — réveillé seulement par un retour du premium

| Dette                                                                                                                                                                                                                                                                              | Où                                                     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| **N+1 sur `has_parcours_entitlement`** — un appel RPC par parcours. **Ne se déclenche pas aujourd'hui** : les deux sites d'appel court-circuitent sur `!p.is_premium`, et la phase gratuite met `is_premium = false` partout. À batcher **avant** tout dégel du premium (étude 01) | `src/features/dashboard/dashboard.server.ts:323, :769` |

## Soldé depuis l'audit (2026-06-30 → 2026-08-10)

- **Élagage push ligne à ligne** — soldé le 2026-08-10 : les endpoints morts sont
  collectés puis supprimés en **un** `DELETE … IN (…)` par lot de 200 (l'`.in()`
  voyage dans l'URL, qui a un plafond). L'élagage est best-effort — les notifications
  sont déjà parties, un nettoyage raté ne fait plus échouer le cron.
  `notifications.cron.server.ts` ; deux tests épinglent le comportement (un seul
  aller-retour pour 5 endpoints morts, et `pruned: 0` si la suppression échoue).
- **Chunks vendor sans budget** (M1-fe de l'audit perf) — soldé le 2026-08-10 :
  `vendor-radix`, `vendor-icons` et `vendor-three` ont désormais un plafond.

Consigné parce que le plan d'action les portait encore comme ouverts :

- **Agrégats `subject_stats`** — le fetch non borné des `attempts` dans `getDashboard` a été
  remplacé par la RPC `get_user_subject_stats` (`GROUP BY subject_id`, une ligne bornée par
  matière). `dashboard.server.ts:238`.
- **Trous de tests** — `recoverStreak` est couvert (`progression/__tests__/progression.test.ts`),
  `handlePushCron` aussi (`notifications/__tests__/notifications.cron.test.ts`), et
  `content-protection.ts` a le sien (`shared/lib/__tests__/content-protection.test.ts`).
- **Quick wins de la PR #245** — redaction du logger étendue, `npm audit fix`,
  `no-unused-vars` réactivé, tag SemVer outillé (`release.yml`).
