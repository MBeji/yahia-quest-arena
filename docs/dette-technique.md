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

| Dette                                                                                                                                                                                                                            | Où                                                                              | Effort | Axe        |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------ | ---------- |
| **Élagage push ligne à ligne** — un endpoint mort déclenche son propre `DELETE`. Une rafale d'abonnements expirés fait autant d'allers-retours que d'abonnés perdus ; un `DELETE … IN (…)` après la boucle suffit                | `src/features/notifications/notifications.cron.server.ts:69`                    | S      | ⚡ Perf    |
| **Deux gros fichiers** — `quest.server.ts` (1 001 l.) mêle session, contenu et surface publique ; `dashboard.tsx` (544 l.) gagnerait à extraire ses sous-composants                                                              | `src/features/quest/quest.server.ts`, `src/routes/_authenticated/dashboard.tsx` | M      | 📝 Qualité |
| **Pas de budget de perf runtime** — le budget **bundle** existe (`build:check`) et le harnais de charge aussi (`perf:check` = k6 côté Postgres/RPC), mais rien ne surveille le **LCP réel**. Un Lighthouse CI comblerait le trou | CI                                                                              | M      | 🧪 Tests   |

## Latent — réveillé seulement par un retour du premium

| Dette                                                                                                                                                                                                                                                                              | Où                                                     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| **N+1 sur `has_parcours_entitlement`** — un appel RPC par parcours. **Ne se déclenche pas aujourd'hui** : les deux sites d'appel court-circuitent sur `!p.is_premium`, et la phase gratuite met `is_premium = false` partout. À batcher **avant** tout dégel du premium (étude 01) | `src/features/dashboard/dashboard.server.ts:323, :769` |

## Soldé depuis l'audit (2026-06-30 → 2026-08-02)

Consigné parce que le plan d'action les portait encore comme ouverts :

- **Agrégats `subject_stats`** — le fetch non borné des `attempts` dans `getDashboard` a été
  remplacé par la RPC `get_user_subject_stats` (`GROUP BY subject_id`, une ligne bornée par
  matière). `dashboard.server.ts:238`.
- **Trous de tests** — `recoverStreak` est couvert (`progression/__tests__/progression.test.ts`),
  `handlePushCron` aussi (`notifications/__tests__/notifications.cron.test.ts`), et
  `content-protection.ts` a le sien (`shared/lib/__tests__/content-protection.test.ts`).
- **Quick wins de la PR #245** — redaction du logger étendue, `npm audit fix`,
  `no-unused-vars` réactivé, tag SemVer outillé (`release.yml`).
