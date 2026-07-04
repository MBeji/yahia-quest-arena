# Étude NN — <Titre de l'epic>

> **Statut** : brouillon | validée | en exécution | livrée | gelée
> **Priorité** : NN · **Valeur** : <1 phrase> · **Complexité** : <faible/moyenne/haute/très haute>
> **Architecte** : <modèle/date> · **Exécuteur cible** : Sonnet (ou équiv.)
> **Dépend de** : <études/décisions/contenu préalables> · **Bloque** : <le cas échéant>
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, <docs/\*.md concernés>

## 1. Contexte & objectif produit

Le pourquoi en langage produit : problème actuel (avec l'état réel du code/DB), résultat attendu,
indicateurs de succès (KPI mesurables), et ce que l'epic ne cherche PAS à faire.

## 2. Spécification fonctionnelle

- **Acteurs & parcours** : qui (élève/parent/admin/anonyme), user stories numérotées `US-1…`,
  flux UX écran par écran (états vides, erreurs, chargement), mobile-first + RTL.
- **Règles métier** : toutes les règles décidées, y compris cas limites et anti-abus, chacune
  numérotée `R-1…` (l'exécuteur les référence dans ses tests).
- **i18n** : clés/langues concernées (FR/EN/AR), spécificités RTL.
- **Hors périmètre (v1)** : explicite, pour tuer le scope creep.

## 3. Architecture technique (décisions fermées)

- **Modèle de données** : tables/colonnes exactes (types, contraintes, index), RLS, **grants
  explicites**, migrations (toutes additives sauf mention; ordre §7 du DoD). Snippets SQL inclus.
- **Server** : RPCs SQL (`SECURITY DEFINER` ou non, signatures exactes) et/ou server fns
  (`createServerFn` + middleware auth + zod), avec leurs contrats d'entrée/sortie.
- **Client** : arborescence `src/features/<feature>/…` (barrel, `<name>.server.ts`, composants),
  routes, composants UI (shadcn/@/components/ui), états TanStack Query.
- **Sécurité & anti-triche** : ce qui reste server-side, invariants (ex. clé de réponse jamais
  sélectionnée côté client), validation, rate limiting, RLS par table.
- **Intégrations & env** : services externes, variables d'env (+ mise à jour
  `docs/environment-variables.md`), webhooks/secrets.
- **Observabilité** : logs structurés (logger partagé), métriques/événements à tracer.
- **Décisions d'architecture (ADR)** : `D-1…` — décision, alternatives rejetées, pourquoi.

## 4. Plan d'exécution en lots

Chaque lot = **une PR mergeable, gate verte, utile seul**. Tableau puis détail par lot :

| lot | contenu (résumé) | fichiers/objets créés | tests exigés | dépend de |
| --- | ---------------- | --------------------- | ------------ | --------- |

Pour chaque lot : périmètre exact, critères d'acceptation (mappés aux `US-x`/`R-x`), tests à
écrire (unit / pgTAP / e2e / smoke), et le **stop-point** (ce que l'exécuteur ne doit PAS
commencer). Case à cocher par lot :

- [ ] Lot 1 — …
- [ ] Lot 2 — …

## 5. Stratégie de test

Répartition par niveau (Vitest co-localisés, pgTAP pour toute logique SQL, Playwright e2e TEST
project, `smoke:shell` si le bundle prod est touché), données de test, et ce qui prouve la
non-régression de l'existant.

## 6. Risques & mitigations

`RISK-1…` — risque, probabilité/impact, mitigation décidée (pas « à étudier »).

## 7. Questions ouvertes (pour l'humain)

`Q-1…` — uniquement ce qu'un exécuteur ne peut pas trancher (prix, choix de prestataire,
politique produit). Une étude passe `validée` quand cette section est vidée ou arbitrée.

## 8. Journal d'exécution

Rempli au fil des lots par l'exécuteur : date, lot, PR, écarts acceptés, dettes notées.
