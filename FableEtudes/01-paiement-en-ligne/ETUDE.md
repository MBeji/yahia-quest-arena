# Étude 01 — Paiement en ligne (checkout → entitlement automatique)

> **Statut** : brouillon
> **Priorité** : 01 · **Valeur** : déblocage direct des revenus (tunnel d'achat self-service des parcours concours) · **Complexité** : moyenne+
> **Architecte** : Fable (claude-fable-5), 2026-07-04 · **Exécuteur cible** : Sonnet
> **Dépend de** : choix final du PSP + compte marchand + grille tarifaire (Q-1/Q-2, humain) · **Bloque** : rien (le paywall téléphone reste le repli)
> **Docs normatifs liés** : CLAUDE.md (Premium gate, DoD §7, gotcha grants), ARCHITECTURE.md, docs/environment-variables.md, docs/logging-standard.md

## 1. Contexte & objectif produit

Aujourd'hui l'accès premium est **hors-bande** : le composant paywall affiche un numéro de
téléphone, et un admin provisionne à la main (`admin_grant_parcours`, `parcours_entitlements.source='purchase'`).
Chaque acheteur passe par une friction humaine ; aucune conversion nocturne/week-end ; aucun
funnel mesurable. Objectif : un élève (ou son parent) achète un parcours concours (9ème, 6ème,
demain `bac-*`) en libre-service et son entitlement est actif **en secondes**, sans admin.
KPI : taux de conversion paywall→paiement, délai paiement→accès (< 60 s), 0 grant manuel pour les
achats standards, 0 divergence commande payée / entitlement (réconciliation).
Non-objectif : abonnements récurrents (les entitlements sont perpétuels ou à `expires_at` fixe),
facturation entreprise, multi-devises (TND uniquement).

## 2. Spécification fonctionnelle

**Acteurs** : élève connecté (acheteur pour lui-même, v1) ; admin (suivi, remboursement) ;
webhook PSP (machine). Parent-acheteur pour un enfant lié = v2 (hors périmètre, cf. §Hors périmètre).

- **US-1** : en tant qu'élève sur un contenu verrouillé, je clique « Débloquer le parcours », je
  vois le récapitulatif (parcours, prix TND, ce que ça débloque), je pars vers la page de paiement
  du PSP, je paie, je reviens sur une page succès et le contenu est déverrouillé.
- **US-2** : si j'annule/échoue, je reviens sur une page d'échec claire avec relance possible ;
  aucune trace « fantôme » (ma commande passe `failed`/`expired`, jamais bloquante).
- **US-3** : je vois mes achats (date, parcours, montant, statut, référence) dans mon profil.
- **US-4** : en tant qu'admin, je liste les commandes (filtre statut), je vois le détail webhook,
  je peux rembourser (révoque l'entitlement + marque `refunded`).
- **US-5** : si le webhook n'arrive jamais, ma commande payée est régularisée automatiquement
  (réconciliation) en ≤ 15 min.

**Flux UX** (mobile-first, FR/AR avec RTL — le checkout PSP est dans la langue du PSP) :
paywall (remplace le bloc téléphone ; garde le téléphone en lien secondaire « ou contactez-nous »)
→ écran récap → redirection PSP → retour `/paiement/succes?ref=…` (polling du statut de la
commande côté client jusqu'à `paid`, avec état « vérification en cours ») ou `/paiement/echec`.

**Règles métier** :

- **R-1** : le prix vient TOUJOURS de la DB (`parcours.price_millimes`), jamais du client.
- **R-2** : une commande est liée à `(user, parcours)` ; on refuse la création si un entitlement
  live existe déjà (409 fonctionnel avec message).
- **R-3** : transitions d'état strictes `pending → paid | failed | expired` puis `paid → refunded`
  (aucune autre) ; toute transition est journalisée.
- **R-4** : le fulfillment (grant) est **idempotent** : rejouer le webhook d'une commande `paid`
  ne crée pas de doublon (index unique live existant `uq_live_entitlement` + garde d'état).
- **R-5** : une commande `pending` expire à T+60 min (réconciliation la passe `expired` si le PSP
  confirme non-payée).
- **R-6** : remboursement = action admin uniquement ; révoque l'entitlement (`revoked_at`) et
  marque la commande `refunded` ; le remboursement monétaire réel se fait chez le PSP (v1 hors
  API).
- **R-7** : anti-abus création : max 5 commandes `pending` par user (rate limit serveur).

**i18n** : nouvelles clés FR/EN/AR pour paywall/récap/succès/échec/historique ; montants formatés
`X,XXX TND` (millimes), chiffres occidentaux partout (règle projet).
**Hors périmètre (v1)** : achat par le parent pour un enfant lié (le family pack couvre déjà
l'accès via lien parent), codes promo, remboursement via API PSP, factures PDF.

## 3. Architecture technique (décisions fermées)

- **D-1 — PSP : Konnect** (agrégateur tunisien : cartes, e-DINAR, wallets ; API REST
  init-payment → payUrl + webhook + get-payment). Alternatives rejetées : Stripe (pas de compte
  marchand TN), Paymee/Flouci (viables — l'intégration est isolée derrière un module
  `payment-provider.ts` pour pouvoir changer sans toucher au domaine ; si l'humain tranche
  autrement en Q-1, seul ce module change).
- **D-2 — Le webhook ne fait pas confiance au payload** : à réception, on **re-interroge l'API
  PSP** (`get-payment(ref)`) et on décide sur cette réponse (source de vérité), le payload servant
  d'audit. Élimine la falsification de payload même si le secret d'URL fuit.
- **D-3 — Fulfillment en SQL atomique** : une fonction `fulfill_payment_order(order_id)`
  SECURITY DEFINER fait (vérif état `pending` → `paid` + insert entitlement) dans UNE transaction.
  Jamais de grant côté TS.

**Modèle de données** (migration additive, avec GRANTs explicites — gotcha CLAUDE.md) :

```sql
ALTER TABLE public.parcours ADD COLUMN IF NOT EXISTS price_millimes INT;         -- NULL = pas vendable en ligne
CREATE TABLE public.payment_orders (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  parcours_id     TEXT NOT NULL REFERENCES public.parcours(id),
  amount_millimes INT  NOT NULL CHECK (amount_millimes > 0),
  currency        TEXT NOT NULL DEFAULT 'TND' CHECK (currency = 'TND'),
  status          TEXT NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','paid','failed','expired','refunded')),
  provider        TEXT NOT NULL DEFAULT 'konnect',
  provider_ref    TEXT UNIQUE,                    -- référence PSP (payUrl token)
  webhook_payload JSONB,                          -- dernier payload reçu (audit)
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  paid_at         TIMESTAMPTZ, refunded_at TIMESTAMPTZ
);
-- RLS: owner SELECT; admin ALL (is_admin()); aucun INSERT/UPDATE client (server-only via RPC/service role)
-- GRANT SELECT ON public.payment_orders TO authenticated;  + REVOKE write
-- Index: (user_id, created_at DESC), (status) WHERE status='pending'
```

**Server** :

- Server fns (`createServerFn` + `requireSupabaseAuth` + zod) dans
  `src/features/payment/payment.server.ts` : `createCheckout({parcoursId})` (applique R-1/R-2/R-7,
  crée l'order `pending`, appelle Konnect init, stocke `provider_ref`, retourne `payUrl`) ;
  `getMyOrders()` ; `getOrderStatus({orderId})` (pour le polling succès) ; admin :
  `adminListOrders`, `adminRefundOrder` (R-6, réutilise `admin_revoke_parcours`).
- **Webhook** : route serveur publique `src/routes/api/payment-webhook.ts`
  (TanStack Start server route, pas de middleware auth) sur URL à secret
  (`/api/payment-webhook?token=$PAYMENT_WEBHOOK_TOKEN`, comparaison constante) ; applique D-2 puis
  appelle `fulfill_payment_order` (D-3) ; toujours 200 après enregistrement (retries PSP).
- **Réconciliation** : job dans le cron existant (patron
  `src/features/notifications/notifications.cron.server.ts`) : toutes les 10 min, pour chaque
  `pending` de plus de 5 min → `get-payment` → fulfill / expire (US-5, R-5).
- RPC SQL : `fulfill_payment_order(order_id uuid)` SECURITY DEFINER, REVOKE anon/authenticated
  (appelée service-role uniquement) ; pgTAP dessus.

**Client** : `src/features/payment/` (barrel, `payment.server.ts`, `components/`
`CheckoutSummary`, `OrderHistory`, refonte du composant paywall de `subscription/` pour appeler
`createCheckout` — attention frontière : `payment` n'importe pas `subscription` ; le composant
paywall reste dans `subscription/` et appelle le serveur de `payment` via… **non** : les features
ne s'importent pas. **D-4** : le CTA d'achat vit dans `payment/components/` et la page paywall de
`subscription/` est déplacée/absorbée par `payment/` (le paywall devient un composant de
`payment`, `subscription/` garde entitlements/beta/admin). Routes : `/paiement/succes`,
`/paiement/echec`, section « Mes achats » dans le profil.

**Env** (+ docs/environment-variables.md) : `KONNECT_API_KEY`, `KONNECT_WALLET_ID`,
`KONNECT_BASE_URL` (sandbox/prod), `PAYMENT_WEBHOOK_TOKEN`. Jamais côté client.
**Observabilité** : logs structurés (logger partagé, secrets redacted) sur chaque transition
d'état ; compteur d'échecs webhook.

## 4. Plan d'exécution en lots

| lot | contenu                                                                             | objets créés                                                 | tests exigés                            | dépend de |
| --- | ----------------------------------------------------------------------------------- | ------------------------------------------------------------ | --------------------------------------- | --------- |
| 1   | Migration : `price_millimes`, `payment_orders`, `fulfill_payment_order`, RLS+grants | 1 migration SQL                                              | pgTAP (états, idempotence R-4, RLS)     | —         |
| 2   | Module provider + `createCheckout` + `getMyOrders`/`getOrderStatus`                 | `payment-provider.ts`, `payment.server.ts`, feature scaffold | Vitest (R-1/R-2/R-7, provider mocké)    | 1         |
| 3   | Webhook (D-2) + réconciliation cron (R-5, US-5)                                     | route `api/payment-webhook`, job cron                        | Vitest (signature, replay, transitions) | 2         |
| 4   | UI : paywall refondu (D-4), récap, succès (polling), échec, historique              | composants + routes + i18n FR/EN/AR                          | Vitest composants ; states RTL          | 2         |
| 5   | Admin : liste commandes + remboursement (R-6) ; e2e sandbox                         | server fns admin + UI admin                                  | Vitest ; 1 spec e2e authed (sandbox)    | 3, 4      |

- [ ] Lot 1 — DB & fulfillment (à merger seul, AVANT tout code qui l'utilise — DoD §7)
- [ ] Lot 2 — checkout serveur
- [ ] Lot 3 — webhook + réconciliation
- [ ] Lot 4 — UI acheteur
- [ ] Lot 5 — admin + e2e

**Stop-points** : lot 2 ne touche pas au paywall UI ; lot 3 n'expose aucune donnée PSP au client ;
lot 4 ne modifie pas `resolve_exercise_access` (le gate existant suffit — l'entitlement suffit à
déverrouiller) ; personne ne touche à la grille de prix sans Q-2 arbitrée.

## 5. Stratégie de test

pgTAP : machine d'états + idempotence fulfillment + RLS owner/admin. Vitest : provider mocké
(aucun appel réseau en test), transitions webhook (payload falsifié ⇒ D-2 protège), zod des fns.
E2E (TEST project) : parcours complet en sandbox Konnect derrière variable d'env dédiée — spec
skippée si secrets absents (même approche que l'auth tier). `smoke:shell` inchangé (pas de code
prod-gated nouveau au shell public).

## 6. Risques & mitigations

- **RISK-1** Webhook perdu/dupliqué (probable/majeur) → D-2 + R-4 + réconciliation US-5.
- **RISK-2** Fuite du token webhook (rare/majeur) → D-2 rend le payload non décisionnel ; rotation
  du token documentée.
- **RISK-3** Divergence prix affiché/facturé (rare/majeur) → R-1 (prix DB unique), test dédié.
- **RISK-4** PSP indisponible (possible/mineur) → paywall garde le canal téléphone en repli
  visible ; `createCheckout` échoue proprement (message + retry).
- **RISK-5** Choix PSP remis en cause (possible/mineur) → D-1 : tout l'adaptateur dans
  `payment-provider.ts`, contrat typé unique.

## 7. Questions ouvertes (pour l'humain)

- **Q-1** : PSP définitif (Konnect supposé) + ouverture du compte marchand + accès sandbox.
- **Q-2** : grille tarifaire par parcours (montants TND, promo de lancement ?) et durée des
  entitlements achetés (perpétuel vs année scolaire → `expires_at`).
- **Q-3** : faut-il des reçus (email récapitulatif via le système de notifications existant) en v1 ?
- **Q-4** : politique de remboursement affichée (délai, conditions) — texte légal.

## 8. Journal d'exécution

_(vide — rempli par l'exécuteur, lot par lot)_
