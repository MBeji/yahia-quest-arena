# Audit de sécurité — surface publique (accès anonyme) — 2026-07

> Audit point-dans-le-temps de la surface **anonyme** (non authentifiée) de l'app :
> routes `_public/*`, `login`/`signup`/`auth`, rôle Postgres `anon`, RPC appelables en
> anonyme, entrée SSR / en-têtes. Ce document **constate** ; il ne redéfinit aucune
> décision produit. Les points marqués « acceptation documentée » renvoient à un choix
> déjà pris et tracé dans le code / les études.

## Verdict

**Posture solide. Aucune faille Critique ni Haute.** Les protections de fond sont
réellement en place et vérifiées :

- **Clé de correction masquée pour `anon`.** `correct_option`, `explanation`,
  `answer_key`, `distractor_tags` ne sont pas accordés à `anon` — whitelist colonne
  `(id, exercise_id, prompt, options, display_order, question_type)`
  (`20260610170000_hide_answer_key.sql`, revoke `distractor_tags`
  `20260706120000_adaptive_telemetry_a0_schema.sql`). Un
  `GET /rest/v1/questions?select=correct_option` anonyme échoue.
- **Données personnelles (mineurs) fermées à `anon`.** La policy ouverte d'origine
  (`Profiles viewable by everyone USING(true)`) a été **remplacée** par
  `auth.uid()=id OR linked` (`20260522153000_family_content_rewards.sql`). `profiles`,
  `attempts`, télémétrie, `parcours_entitlements`, duels, `beta_access_requests`
  (emails), `content_reports`/`bug_reports`, `push_subscriptions` : aucun accès `anon`
  en lecture **ni** en écriture. **Aucune écriture `anon` nulle part.**
- **Signature JWT vérifiée côté serveur** (`getClaims`) — token non-forgeable. Seule la
  clé _publishable_ est embarquée côté client ; aucun `service_role`/secret dans le
  bundle.
- **Inscription non-escaladante** — `handle_new_user` n'écrit que `id`+`display_name` ;
  `role/xp/premium` restent aux défauts, trigger anti-escalade présent.
- **CSRF** sur toutes les server fns, **6 en-têtes** de sécurité présents, **CSP à
  nonce** (`frame-ancestors 'none'`, `object-src 'none'`). Pas d'open redirect. SVG
  sanitisé (`foreignObject`/`script`/`href`/`use` retirés + strip `javascript:`).

## Findings

| #   | Sévérité | Sujet                                                                                             | Nature                                       |
| --- | -------- | ------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| 1   | Moyen    | Récolte non limitée de la clé de correction + explications via `check_answers` (PostgREST direct) | Anti-abus / décision produit                 |
| 2   | Moyen    | `get_student_report_by_code` : RPC lourde **sans rate-limit**, appelable en anonyme               | Anti-abus (DoS)                              |
| 3   | Moyen    | `?debug=1` renvoie la **stack complète** à tout visiteur anonyme                                  | **Corrigé dans cette PR**                    |
| 4   | Moyen    | Rate-limiting anonyme inopérant (mémoire par-instance + clé `x-forwarded-for` spoofable)          | Anti-abus / infra                            |
| 5   | Moyen    | Pas de CAPTCHA/anti-bot sur signup/login                                                          | Config Supabase                              |
| 6   | Faible   | DOMPurify no-op sans DOM (XSS SSR latente)                                                        | **Corrigé (fail-closed)**                    |
| 7   | Faible   | Énumération d'emails au signup + politique de mot de passe client-only                            | Config Supabase                              |
| 8   | Faible   | Tokens de session en `localStorage`                                                               | Atténué (CSP)                                |
| 9   | Faible   | `display_name` non borné via metadata signup (chemin trigger)                                     | **Corrigé dans cette PR**                    |
| 10  | Faible   | Page d'erreur / sitemap / bot-guard sans CSP                                                      | Durcissement                                 |
| —   | Info     | Messages d'erreur distincts « not found » vs « not a student » sur le code parent                 | **Acceptation documentée** (voir ci-dessous) |

### 1 — `check_answers` : récolte de la clé de correction, non throttlée (Moyen)

`check_answers(uuid, jsonb)` est `SECURITY DEFINER` et `GRANT EXECUTE … TO anon`
(`20260621181000`, redéfinie `20260705190000`). La clé publishable étant côté navigateur,
un attaquant appelle la RPC **directement** en `POST /rest/v1/rpc/check_answers`, ce qui
**contourne** la server fn `checkAnswersPublic` et son limiteur. Elle renvoie la bonne
réponse **et** `explanation` pour toute question `source='admin'` non-quiz, **sans qu'il
faille répondre juste**. En énumérant les `id` (colonne lisible par `anon`), on aspire toute
la banque de réponses + explications — court-circuitant aussi l'économie d'indices payants
(`consume_hint`). Seul le `quiz` de compréhension (la porte) est protégé.

C'est un **choix produit** (correction publique, entraînement anonyme). Recommandation :
acceptation de risque explicite + throttling au **bord** (Cloudflare / Vercel Edge — la
seule couche qui compte puisque PostgREST est joignable directement), et envisager de ne
pas renvoyer `explanation` à l'anonyme.

### 2 — `get_student_report_by_code` : DoS sur RPC lourde (Moyen)

RPC lourde (plusieurs agrégations sur `attempts`) `SECURITY DEFINER` accordée à `anon`,
**sans aucun rate-limit** → amplification DoS directement appelable. La **confidentialité**
tient à l'entropie de l'UUID v4 (122 bits, non devinable) et au fait qu'aucune surface
`anon` ne divulgue d'UUID d'élève — donc pas de fuite. Résiduel : ajouter un rate-limit au
bord, et (design, non urgent) séparer un jeton de rapport rotatif de l'UUID de compte.

### 3 — `?debug=1` divulgue la stack (Moyen) — **corrigé**

`src/routes/__root.tsx` affichait `error.stack` à quiconque ajoute `?debug=1`, révélant la
structure interne des modules. **Correctif :** en production, ne surfacer que l'identité de
l'erreur (`name: message`, déjà cliente-safe) ; la stack reste disponible hors production
pour le forensic mobile. Logique extraite dans `src/shared/lib/error-debug.ts` (testée).

### 4 — Anti-abus anonyme inopérant (Moyen)

`isRateLimitedLocal` est une `Map` en mémoire **par instance lambda** (Vercel scale
horizontalement → limite multipliée), et la clé vient du **premier** `x-forwarded-for`,
**contrôlable par le client** (`quest.server.ts:503-511`). Conjugué à #1/#2 (RPC directes),
les contrôles d'abus anonymes sont en pratique absents. Reco : limiteur distribué sur IP de
confiance fournie par la plateforme, ou rate-limit au bord.

### 5 / 7 — Durcissement auth (Moyen / Faible — config Supabase)

Pas de CAPTCHA sur `signUp`/`signInWithPassword` (création de masse, credential-stuffing) ;
énumération d'emails possible si la confirmation d'email est désactivée ; politique de mot
de passe seulement côté client. Ces protections vivent dans la config Supabase hébergée,
**non versionnée** (`supabase/config.toml` ne contient que `project_id`). Reco : activer
hCaptcha/Turnstile (`options.captchaToken`), confirmation d'email, longueur min ≥ 8 +
protection des mots de passe fuités, et **versionner** cette posture.

### 6 / 10 — Durcissement SSR (Faible)

`jsdom` est en devDependency uniquement → `DOMPurify.sanitize` est un no-op sans DOM. Non
exploitable aujourd'hui (le contenu public est rendu côté client, et il est _authored_, pas
_user-generated_). **Corrigé :** `sanitizeSvg` **échoue désormais en sécurité** (retourne
une chaîne vide, la figure est abandonnée) quand `DOMPurify.isSupported` est faux ; et
`renderMarkdown` saute explicitement la passe de sanitisation indisponible (son corps est
déjà HTML-échappé, donc sûr) au lieu de dépendre du comportement pass-through. Reste ouvert
(#10) : les réponses page-d'erreur/sitemap/bot-guard sortent hors du chemin routeur et ne
portent pas de CSP (ni script → impact minime).

### 9 — `display_name` non borné (Faible) — **corrigé**

Le chemin trigger (`handle_new_user`, pris quand la confirmation d'email est en attente)
stockait `raw_user_meta_data->>'display_name'` sans borne, alors que le chemin authentifié
(`bootstrapProfile`) valide `max(80)`. **Correctif :** `left(…, 80)` dans le trigger, pour
aligner l'écriture pré-auth sur le chemin validé (migration
`20260712120000_bound_display_name.sql`).

### Acceptation documentée — messages d'erreur du code parent

Les messages distincts « Student not found » vs « does not belong to a student account »
(`get_student_report_by_code`) constituent un **oracle d'énumération théorique**. C'est une
**décision délibérée et tracée** (`src/features/parent-report/parent-code-errors.ts:11-13`,
étude 15 lot 3) : atteindre l'une ou l'autre branche exige de **déjà posséder l'UUID complet
(128 bits)**, donc distinguer les deux ne révèle rien d'exploitable. **Non modifié** — le
gain sécurité est nul et la précision de l'erreur sert le parent.

## Remédiations prioritaires

1. **Throttler au bord** les deux RPC anon (`check_answers`, `get_student_report_by_code`)
   et, plus largement, les server fns publiques — seule couche efficace car PostgREST est
   joignable directement (findings #1, #2, #4).
2. **Anti-bot signup/login** + versionner la config auth dans `supabase/config.toml`
   (findings #5, #7).
3. Décider explicitement du **risque « banque de réponses publique »** : accepter, exiger
   une réponse pour révéler, ou retirer `explanation` de la réponse anonyme (finding #1).

## Findings corrigés

- **#3** (stack `?debug=1`) et **#9** (`display_name` borné) — PR #384 (mergée).
- **#6** (sanitisation SSR fail-closed) — PR de suivi.

## Reste ouvert (edge / infra / config)

Findings **#1, #2, #4** (throttling au bord des RPC/server fns anon), **#5, #7** (anti-bot +
config auth versionnée), **#10** (CSP sur les réponses hors routeur) — décisions
infra/produit, hors correctif de code.
