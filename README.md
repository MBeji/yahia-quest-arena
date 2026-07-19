# Na9ra Nal3ab — yahia-quest-arena

Académie d'apprentissage **gamifiée** pour le programme scolaire tunisien (13 niveaux, lycée en
ouverture) et des pistes libres (culture générale, entraînement cérébral, langues). Trilingue
FR/EN/AR (RTL), esthétique manga/RPG : cours, quêtes QCM, XP, badges, donjon, duels, classement.

**Phase actuelle : bêta publique 100 % gratuite** — tout le contenu se consulte et se pratique
sans compte. Détails, décisions et état des features : [STATUS.md](./STATUS.md).

## Par où commencer

| Besoin                                                      | Document                                                 |
| ----------------------------------------------------------- | -------------------------------------------------------- |
| État du projet (phase, décisions, features, travaux en vol) | [STATUS.md](./STATUS.md)                                 |
| Conventions, commandes, Definition of Done — **canonique**  | [CLAUDE.md](./CLAUDE.md)                                 |
| Architecture (stack, flux, modèle de données, sécurité)     | [ARCHITECTURE.md](./ARCHITECTURE.md)                     |
| Études d'architecture des epics                             | [FableEtudes/](./FableEtudes/README.md)                  |
| **Contribuer à une étude** (collaborateur / dév)            | [FableEtudes/CONTRIBUER.md](./FableEtudes/CONTRIBUER.md) |
| Specs normatives, guides et runbooks                        | [docs/](./docs)                                          |
| Pipeline de contenu pédagogique (fichiers → migrations SQL) | [content/README.md](./content/README.md)                 |
| Tests end-to-end (Playwright, projet TEST dédié)            | [e2e/README.md](./e2e/README.md)                         |

## Stack & commandes essentielles

Vite 8 · TanStack Start (SSR) · React 19 · TanStack Query 5 · Supabase (Postgres + Auth + RLS) ·
Tailwind 4 / Radix-shadcn · déploiement Vercel (push sur `main` = prod + migrations auto).
Package manager : **npm** (Node 22).

```bash
npm run dev        # serveur de dev (SSR)
npm run verify     # lint + typecheck + tests — le gate local
npm run ci:verify  # gate complet (coverage + build + audit + QA contenu)
```

La règle du jeu complète (gate, contenu, migrations, PRs) est dans [CLAUDE.md](./CLAUDE.md).

## Licence & propriété intellectuelle

- **Code source** (moteur) : [PolyForm Noncommercial 1.0.0](./LICENSE.md) — lecture et usage
  non commercial autorisés ; tout usage commercial par des tiers est interdit.
- **Contenu pédagogique, skills de génération, études** :
  [tous droits réservés](./LICENSE-CONTENT.md) — aucune réutilisation ni rediffusion sans
  autorisation écrite (étude 24).

© 2026 Mohamed Beji — « Na9ra Nal3ab ».
