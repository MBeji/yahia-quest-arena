# docs/archive — audits ponctuels archivés

Instantanés **datés et dépassés**, conservés pour l'historique et la traçabilité des
décisions. Ils ne servent plus de backlog ni de référence : la surface qu'ils décrivaient a
été refondue depuis (études 14/15) et le modèle produit a pivoté (gratuité de phase,
2026-07-10/11 — voir [STATUS.md](../../STATUS.md)).

| Fichier                                                                                    | Nature                                                                              | Supersédé par                                                                             |
| ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| [2026-06-13-audit-ecrans-ux.md](./2026-06-13-audit-ecrans-ux.md)                           | Audit UX/UI one-shot des ~18 écrans                                                 | études 14 (livrée) + 15 (livrée)                                                          |
| [2026-06-29-audit-fluidite-navigation.md](./2026-06-29-audit-fluidite-navigation.md)       | Audit lecture seule du routage anonyme ↔ connecté (verdict : sain)                  | la coquille adaptative de l'étude 15 ; specs e2e `navigation.spec.ts`                     |
| [2026-06-30-audit-affichage-multidevices.md](./2026-06-30-audit-affichage-multidevices.md) | Audit responsive one-shot (18 agents)                                               | correctifs appliqués + études 14/15                                                       |
| [2026-06-30-audit-codebase.md](./2026-06-30-audit-codebase.md) (+ `-metrics.csv`)          | Audit technique complet (qualité, sécurité, maintenabilité)                         | [`docs/dette-technique.md`](../dette-technique.md) — la dette encore ouverte, re-vérifiée |
| [2026-06-rapport-test-e2e.md](./2026-06-rapport-test-e2e.md)                               | Plan de non-régression rédigé à la main (scénario → étapes → verdict)               | les suites Playwright elles-mêmes ([`e2e/README.md`](../../e2e/README.md))                |
| [2026-07-audit-securite-surface-publique.md](./2026-07-audit-securite-surface-publique.md) | Audit point-dans-le-temps de la surface anonyme (verdict : 0 faille critique/haute) | le skill `/security-review` + la CodeQL requise sur `main`                                |

Règle : un audit one-shot vit ici dès qu'il est traité ou dépassé, préfixé de sa date.
Les documents **normatifs** (specs, policies, runbooks, guides) restent dans `docs/`.

**Ce qui n'est pas ici** : les cartes de programme `docs/wip/map-7eme-sciences.md` et
`map-8eme.md`, supprimées le 2026-08-02. Elles reconstruisaient les programmes de 7ᵉ et 8ᵉ
**par recoupement de résultats de recherche web** — leurs propres en-têtes signalaient que le
fetch direct était bloqué (403) et que tout venait de titres et d'extraits. Ce sont des
hypothèses, pas des fiches : les confondre avec une transcription CNP est exactement ce que le
registre `programmes-officiels/suivi/` existe pour empêcher. La 7ᵉ est ouverte depuis #674 sur
le programme officiel ; la 8ᵉ s'ouvrira pareil. Elles restent lisibles dans l'historique git
(`git show HEAD~1:docs/wip/map-8eme.md`) — ne pas les ressusciter comme source.
