# Pièges du code applicatif

> Des comportements que **le gate local ne montre pas** et qu'on ne devine pas en lisant le
> code : chacun a coûté soit un bug en production, soit un cycle de build. Ils ne sont pas dans
> [`AGENTS.md`](../../AGENTS.md) § Known gotchas parce que ce fichier a un budget dur de
> 250 lignes (il est injecté dans chaque session) — ici, il n'y en a pas.
>
> **Une entrée n'arrive ici que mesurée.** Pas « je crois que » : le chiffre, la commande qui
> l'a produit, la date. Si l'outillage change et qu'elle devient fausse, elle se corrige — elle
> ne se garde pas par respect pour l'ancienneté.

## Exporter le composant d'une route défait le code-splitting

**Symptôme** : `npm run verify` est vert, la CI rougit sur `build:check` — le chunk d'entrée
`index-*.js` dépasse son budget de 450 kB pour un diff de 150 lignes.

**Cause** : un `export function MaPage()` dans `src/routes/*.tsx`, ajouté pour qu'un test unitaire
puisse importer la page. Le splitter de TanStack Start ne peut plus sortir le composant du graphe
principal — ses imports (motion, icônes, primitives de formulaire) remontent avec lui dans le
chunk d'entrée.

**Mesuré le 2026-08-16** sur `/auth`, trois `npm run build:check` successifs dans le même
worktree :

| Arbre                                           | `index-*.js` |
| ----------------------------------------------- | ------------ |
| référence (sans le correctif)                   | 439,75 kB    |
| correctif **avec** `export function AuthPage()` | 520,52 kB    |
| correctif **sans** l'export du composant        | 439,75 kB    |

Soit **+80,77 kB pour le seul mot-clé `export`**. Les deux helpers **purs** exportés du même
fichier (`friendlyAuthError`, `isEmailNotConfirmed`) coûtent **0** : ils ne référencent aucun
import lourd, le tree-shaking fait le reste.

**Ce qu'il faut faire** : garder le composant non exporté et le lire via `Route.component`, avec
`createFileRoute` mocké pour rendre ses options —
voir [`auth-signup.test.tsx`](../../src/routes/__tests__/auth-signup.test.tsx). N'exporter d'un
fichier de route que des fonctions pures.

**Pourquoi ça échappe au gate local** : `build:check` n'est pas dans `verify` (voir AGENTS.md
§ Known gotchas, « CI runs a superset of local verify »). Le lancer avant de pousser dès qu'on
touche à un fichier de route ou qu'on ajoute des clés i18n.

## Une inscription Supabase peut réussir sans qu'aucun mail ne parte

**Symptôme** : l'écran « Confirme ton email » s'affiche, aucun mail n'arrive — ni en boîte, ni en
spam — et les logs SMTP ne montrent **rien** à envoyer. Aucune erreur nulle part.

**Cause** : la protection anti-énumération d'e-mail. Sur une adresse qui a **déjà** un compte,
GoTrue répond **200** avec un utilisateur **factice** — id aléatoire (différent du vrai), `role`
vide, `confirmation_sent_at` horodaté à l'instant — et n'envoie rien. Le but est de ne pas révéler
quelles adresses sont inscrites ; l'effet de bord est qu'un client naïf annonce un mail qui
n'existera jamais.

**Le seul indice honnête est un tableau `identities` vide.** `confirmation_sent_at` ment, l'`id`
ment, le code HTTP ment.

```ts
// `undefined` ≠ vide : seul un vrai tableau vide signifie « rien n'a été créé ici ».
const identities = data.user?.identities;
if (!data.session && Array.isArray(identities) && identities.length === 0) {
  /* l'adresse a déjà un compte — aucun mail n'est parti */
}
```

**Vérifié contre la prod le 2026-08-16** (trois `POST /auth/v1/signup`, boîte de réception
relue) : deux adresses neuves → deux mails en 2 secondes, en boîte de réception ; la répétition
sur une adresse existante → 200, `identities: []`, **zéro mail**.

**Ce que ça implique côté produit** : sans cette branche, l'adresse est **murée** — se
réinscrire répète le mensonge, se connecter répond « confirme d'abord ton compte ». Tout écran
qui dit « on t'a envoyé un lien » doit donc offrir un **renvoi** (`auth.resend`), et un échec
d'envoi (`Error sending confirmation email`) doit se distinguer d'une erreur d'identifiants :
le compte, lui, existe. Voir [`auth.tsx`](../../src/routes/auth.tsx).
