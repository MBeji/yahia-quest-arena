# Sonde de navigation (audit du 2026-11-21)

Les scripts qui ont produit les mesures de
[`../../audit-navigation-2026-11-21.md`](../../audit-navigation-2026-11-21.md). Ils ne font pas
partie du gate : ce sont des relevés rejouables, à convertir en specs e2e quand un lot corrige
un constat (lot 4 du rapport).

## Ce que la sonde ne fait jamais

- **Aucun compte n'est créé, aucune session réelle n'est ouverte.** Le mode connecté est une
  session **simulée** (`session-simulee.cjs`) : un faux jeton posé dans le stockage du navigateur,
  et chaque appel qui le porterait est intercepté — le profil est servi par la sonde, les lectures
  publiques repartent en anonyme, toute écriture est bloquée. Conséquence : les écrans connectés
  affichent leur **coquille** (en-tête, onglets, gardes) mais pas leurs données ; les constats sur
  le contenu de ces écrans viennent de la lecture du code, pas de la sonde.
- **Aucune mesure d'audience ne part** (Google Analytics, PostHog et Sentry sont coupés).
- Les lectures anonymes vont au projet que désigne `VITE_SUPABASE_URL` — les mêmes que celles
  d'un visiteur du site.

## Rejouer

```bash
# depuis la racine du dépôt — VITE_SUPABASE_URL / VITE_SUPABASE_PUBLISHABLE_KEY dans l'environnement
export SUPABASE_URL="$VITE_SUPABASE_URL" SUPABASE_PUBLISHABLE_KEY="$VITE_SUPABASE_PUBLISHABLE_KEY"
npx vite build
node docs/audit-navigation-2026-11-21/sonde/serveur-prod.mjs &   # le build de production, sur 127.0.0.1:5198

cd docs/audit-navigation-2026-11-21/sonde
# Chromium : `npm run test:e2e:install`, ou CHROMIUM_PATH=<binaire> pour un Chromium déjà présent
node inventaire.cjs        # quelle navigation est visible, par rôle et par largeur        (§3)
node debordement.cjs       # l'en-tête public d'un connecté, de 320 à 412 px, fr et ar     (N-2)
node historique.cjs        # le bouton Retour après une garde, une connexion, une sortie   (N-3, N-7)
node impasse.cjs           # un exercice dont la lecture échoue                            (N-4)
node liens-visiteur.cjs    # combien de temps un connecté reçoit des liens /exercice       (N-5)
node fluidite.cjs          # délais au tap, bascules de coquille, défilement               (§5)
node decalage.cjs          # d'où vient le décalage à la première ouverture du catalogue   (N-6)
```

`historique.cjs` et `fluidite.cjs` prennent en argument le début du nom d'un scénario
(`node fluidite.cjs F5`). Le profil « téléphone de référence » (processeur ÷4, 1,6 Mbit/s
descendant, 750 kbit/s montant, 150 ms) est celui du relevé du 2026-11-12.
