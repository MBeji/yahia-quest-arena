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

| Dette                                                                                                                                                                                                                                                                                                                                                                                         | Où                                   | Effort | Axe        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ | ------ | ---------- |
| **Un gros fichier** — `quest.server.ts` (**983 l.**, re-mesuré le 2026-08-14) mêle encore session, contenu et surface publique. ~~`dashboard.tsx`~~ **sort de la liste** : le remède que cette ligne nommait est appliqué (#732 a sorti objectifs & quêtes hebdo en composant chargé paresseusement), **547 → 455 l.**                                                                        | `src/features/quest/quest.server.ts` | M      | 📝 Qualité |
| **Pas de _budget_ de perf runtime** — le LCP réel est désormais **mesuré** (RUM `web-vitals.ts` → PostHog, depuis le 2026-08-10) et les server fns lentes sont journalisées (≥ 1 s), mais rien ne **bloque** une régression : le budget **bundle** existe (`build:check`, 9 chunks) et le harnais de charge aussi (`perf:check`), pas de gate sur le LCP. Un Lighthouse CI comblerait le trou | CI                                   | M      | 🧪 Tests   |

## Latent — réveillé seulement par un retour du premium

| Dette                                                                                                                                                                                                                                                                              | Où                                                     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| **N+1 sur `has_parcours_entitlement`** — un appel RPC par parcours. **Ne se déclenche pas aujourd'hui** : les deux sites d'appel court-circuitent sur `!p.is_premium`, et la phase gratuite met `is_premium = false` partout. À batcher **avant** tout dégel du premium (étude 01) | `src/features/dashboard/dashboard.server.ts:323, :769` |

## Soldé depuis l'audit (2026-06-30 → 2026-08-13)

- **`npm ci` cassé sur `main`** — diagnostiqué ici le 2026-08-10 (#716 avait retiré du lock le
  `typescript@5.9.3` imbriqué dont `tsconfck` a besoin ; npm 10 mourait en `EUSAGE`), **corrigé
  sur `main` le 2026-08-10 par le revert #718**, qui cite la même erreur — la cause profonde
  était que le bump undici embarquait un miniflare 5 alpha. Reste vrai, et sans gravité : dev+CI
  tournent en **Node 24** (`.nvmrc`), la fonction SSR en prod en **`nodejs22.x`**
  (`build-vercel.mjs`) — deux chiffres qui cohabitent légitimement.

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
