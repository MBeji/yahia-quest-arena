# Environment variables (Supabase) & Vercel setup

The app **requires** Supabase environment variables at build and runtime. When
they are missing, the server renders the branded error page ("The scroll has
torn apart") and logs:

> Missing Supabase environment variable(s): SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY.

This is by design (see `src/shared/integrations/supabase/client.ts` and
`client.server.ts`) — the app never falls back to a hard-coded backend.

## Required variables

| Variable                        | Scope                  | Notes                                  |
| ------------------------------- | ---------------------- | -------------------------------------- |
| `VITE_SUPABASE_URL`             | client (build time)    | Project URL                            |
| `VITE_SUPABASE_PUBLISHABLE_KEY` | client (build time)    | anon / publishable key                 |
| `SUPABASE_URL`                  | server / SSR (runtime) | same Project URL                       |
| `SUPABASE_PUBLISHABLE_KEY`      | server / SSR (runtime) | same anon / publishable key            |
| `SUPABASE_SERVICE_ROLE_KEY`     | server only (runtime)  | **secret** — never prefix with `VITE_` |

`VITE_*` values are inlined into the client bundle at build time; the
non-prefixed ones are read from the server runtime (`process.env`). You need
both sets. See [`env.example`](../env.example).

Find the values in **Supabase → Project Settings → API** (Project URL, anon /
publishable key, service_role key).

## Vercel

1. Project → **Settings → Environment Variables** → add the five variables
   above. Tick **Production** (and **Preview** if preview deployments should
   work).
2. **Redeploy** so the values take effect — Deployments → ⋯ → **Redeploy**
   (uncheck "Use existing build cache" so the `VITE_*` values are re-inlined),
   or push a new commit.

> ⚠️ Never put `SUPABASE_SERVICE_ROLE_KEY` (or any secret) into a `VITE_*`
> variable — it would be shipped in the client bundle.

## Auth redirect / Site URL (Supabase Dashboard)

The post-login destination after **Google OAuth** and **email confirmation** is
controlled by the Supabase project's **URL configuration**, _not_ by env vars or
code. The app already passes the right target dynamically
(`${window.location.origin}/auth` for OAuth, `…/dashboard` for email signup — see
`src/routes/auth.tsx`), but Supabase only honours that target when it matches the
allow-listed **Redirect URLs**. Otherwise it falls back to the configured **Site
URL**.

**Symptom:** you sign in from the live domain but land on a different/old Vercel
URL afterwards → the Site URL still points at the old domain, and the live domain
is missing from Redirect URLs.

**Fix:** Supabase Dashboard → **Authentication → URL Configuration**:

1. **Site URL** → `https://www.na9ranal3ab.tn` — the canonical production host, the one
   that answers 200. Never a `*.vercel.app` URL.
2. **Redirect URLs** → add a pattern for every domain that must work:
   - `https://www.na9ranal3ab.tn/**` (production)
   - `http://localhost:8080/**` (local dev — the dev/Playwright port, see `playwright.config.ts`)
   - any Vercel **preview** deployment you also sign in from (`https://<project>-<hash>.vercel.app/**`).

> The Google OAuth client's **Authorized redirect URI** is the Supabase callback
> (`https://<project-ref>.supabase.co/auth/v1/callback`), which does **not** change
> when the production domain changes — only the two Supabase settings above do.

This config lives in the hosted project (it is **not** in `supabase/config.toml`),
so it must be updated in the Dashboard whenever the production domain changes.

## Local development

```bash
cp env.example .env
# fill in the values, then:
npm run dev
```

`.env` is gitignored and must never be committed.

## Analytics (Google Analytics 4)

Client-side analytics (`src/shared/lib/analytics.ts`) loads Google's `gtag.js` and reports
a `page_view` on the first load and on every SPA navigation. Like the Sentry integration it
is **dependency-free** (no npm package, nothing added to the client bundle) and it only runs
in a **production build** — local dev and the unit run never touch the analytics stream.

| Variable                 | Scope               | Notes                                                                 |
| ------------------------ | ------------------- | --------------------------------------------------------------------- |
| `VITE_GA_MEASUREMENT_ID` | client (build time) | GA4 **Measurement ID** (`G-XXXXXXXXXX`). Optional — defaults in code. |

The Measurement ID is **public** (it ships in the client bundle by design — not a secret).
When `VITE_GA_MEASUREMENT_ID` is unset the build falls back to the project's production data
stream hard-coded in `analytics.ts`; set the variable in Vercel → Settings → Environment
Variables to point a build (e.g. a staging property) at a different GA4 stream, then redeploy
without build cache so the value re-inlines. Find the ID in **GA4 → Admin → Data Streams →
your web stream**.

The Content-Security-Policy allow-lists the required origins (`src/shared/lib/csp.ts`):
`https://www.googletagmanager.com` in `script-src` for the loader, and in `connect-src` the
**five** hosts gtag.js actually beacons `/g/collect` to — `www.google-analytics.com`,
`*.google-analytics.com`, `analytics.google.com`, `*.analytics.google.com` and
`www.google.com`. The loader is an external `<script>` and every gtag call is plain JS, so no
CSP nonce is involved.

⚠️ **Un joker d'hôte CSP ne couvre pas le domaine nu.** `https://*.analytics.google.com` ne
matche que des sous-domaines (au moins un label) — `https://analytics.google.com` doit être
listé **en plus**, et `www.google.com` reçoit lui aussi des `/g/collect` (signaux Google,
endpoints régionaux). C'est ce piège qui a bloqué en silence une partie des `page_view` et des
`scroll` en prod (constat navigateur du 2026-08-19) : le défaut est **invisible côté serveur**
— rien ne rougit, aucun gate ne le voit, il ne se lit que dans la console du navigateur. Le
test `src/shared/lib/__tests__/csp.test.ts` assert désormais **un hôte à la fois**, sur le
jeton exact. Rester étroit : ne jamais élargir en `https://*.google.com`.

### 🔴 RÈGLE — re-sonder le navigateur après tout changement de CSP ou de balise tierce

**Aucun tier de test ne peut voir ce défaut, et c'est structurel** (#804) — donc la vérification
est une règle de conduite, pas un gate. Les trois tiers sont aveugles pour trois raisons
différentes, et il ne sert à rien d'espérer qu'ils s'améliorent :

| tier                                             | pourquoi il ne voit rien                                                                                                                                                    |
| ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Playwright `e2e/public/security-headers.spec.ts` | son `webServer` est `npm run dev`, donc `import.meta.env.PROD` est faux, donc `isAnalyticsEnabled()` rend `false` : **gtag.js ne se charge jamais**, il n'y a rien à violer |
| `smoke:shell`                                    | **hermétique par conception** — « every non-localhost request is blocked ». Une balise y serait arrêtée par le harnais, jamais par la CSP                                   |
| `csp.test.ts`                                    | il juge la **chaîne** de la politique — ce que _nous croyons_ que gtag appelle, pas ce que gtag appelle                                                                     |

La question « notre `connect-src` couvre-t-elle les hôtes que la balise appelle **réellement** ? »
porte sur un **fait externe** (le comportement de Google), qui peut changer sans qu'une seule
ligne bouge ici. Le trou se rouvrira donc tout seul le jour où gtag ajoutera une destination.

**À faire après toute PR qui touche `csp.ts`, `analytics.ts` ou une balise tierce** — depuis la
console d'un navigateur sur la prod. **Toujours avec le contrôle négatif** : sans lui, « aucune
erreur » ne prouve rien (il prouverait aussi bien que la sonde ne sonde pas).

```js
const probe = async (u) => {
  try {
    const r = await fetch(u, { mode: "no-cors" });
    return "ALLOWED " + r.type;
  } catch (e) {
    return "BLOCKED " + e.message;
  }
};
await probe("https://analytics.google.com/robots.txt"); // doit être ALLOWED
await probe("https://www.google.com/robots.txt"); // doit être ALLOWED
await probe("https://example.com/"); // DOIT être BLOCKED — sinon la mesure ne vaut rien
```

On sonde l'**origine** avec un chemin inoffensif : `connect-src` juge l'origine, pas le chemin.

**Pourquoi pas un canari prod automatique** (un job planifié chargeant une page publique dans un
Chromium non hermétique, à l'écoute de `securitypolicyviolation`) : c'est le seul dispositif qui
verrait un changement côté Google, et il a été **pesé puis écarté** — il fait sortir un tier de
test vers l'extérieur, avec la flakiness que ça implique, et il écrit du trafic réel dans GA4 à
chaque passage. Arbitrage du 2026-09-03. À rouvrir si la liste d'hôtes bouge une seconde fois.

**Developer-traffic tagging.** Every hit carries a `traffic_type` parameter, resolved at
runtime from `window.location.hostname` (`resolveTrafficType` in `analytics.ts`):
`developer` on local hosts (`localhost`, loopback — e.g. `vite preview`/smoke runs of the
prod bundle) and on **every** `*.vercel.app` host, `production` everywhere else. The canonical
`www.na9ranal3ab.tn` needs no entry, being neither local nor `*.vercel.app`.
`na9ranal3ab.vercel.app` was carved out while it counted as production; it answers 301 to the
canonical host on every route (sondé 2026-08-19), so no session runs analytics there — the
carve-out is gone. To actually drop those sessions from reports, create the
GA4 data filter once: **Admin → Data collection and modification → Data filters → Create
filter → Internal traffic**, parameter value `developer`, operation **Exclude** — try it in
**Testing** state first, then switch to **Active** (exclusion is permanent, never
retroactive).

## Product analytics (PostHog) — optional

GA4 above answers _how much traffic and from where_. PostHog
(`src/shared/lib/product-analytics.ts`) answers what GA4 cannot: **funnels**
(landing → chapitre → exercice corrigé → compte créé) and **retention** per cohort. Both
sinks share one call site — the `track*` functions of `analytics.ts` fan out to PostHog first,
then to GA4 — and each has its own gate, so disabling one never silences the other.

| Variable            | Scope               | Notes                                                           |
| ------------------- | ------------------- | --------------------------------------------------------------- |
| `VITE_POSTHOG_KEY`  | client (build time) | PostHog **project** key (`phc_…`). Unset ⇒ inert. No default.   |
| `VITE_POSTHOG_HOST` | client (build time) | Ingest origin override. Defaults to `https://eu.i.posthog.com`. |

Set the key in **Vercel → Settings → Environment Variables → Production**, then redeploy
**without build cache** so the value re-inlines. Unlike the GA4 Measurement ID there is no
hard-coded fallback: the key stays out of the repo, so no branch or fork build can ship it by
accident and rotating it is a Vercel change, not a code change. Find it in **PostHog →
Settings → Project → Project API Key**.

**Deliberately not used: `posthog-js`.** The SDK costs ~60 kB against a 450 kB index budget
(`scripts/check-bundle-budget.mjs`, ~437 kB used today), so events are POSTed straight to
`<host>/i/v0/e/` like Sentry envelopes are. The trade-off is explicit: no autocapture, no
heatmaps and **no session replay** — the last one is a data-protection decision, not an
oversight (recording the screens of minors needs the INPDP groundwork of GAP-003 and a privacy
policy that does not exist yet, GAP-024).

**No PII, by construction.** No e-mail, no name, no Supabase user id ever leaves the browser.
The `distinct_id` is a random UUID kept in `localStorage` (`na9ra.ph_did`), and every event
carries `$process_person_profile: false` — the wire equivalent of the snippet's
`person_profiles: 'identified_only'`: PostHog counts the event without building a person
profile.

**Developer traffic.** PostHog has no built-in internal-traffic filter, so each `$pageview`
carries the same `traffic_type` property as GA4 (`developer` on localhost and Vercel previews,
`production` elsewhere — `resolveTrafficType`). Filter on it in PostHog, or build the insights
on a cohort restricted to `traffic_type = production`.

The CSP allow-lists the ingest origin in **`connect-src` only** (`src/shared/lib/csp.ts`,
read from the same `POSTHOG_HOST` constant the sender uses). Nothing is added to `script-src`:
there is no external script to load.

## Error monitoring (Sentry) — optional

Error reporting (`src/shared/lib/monitoring.ts`, hooked into `logger.error` + browser
error handlers) is **off unless a DSN is set** — clean local/preview, no events leave the
machine. It is dependency-free (posts Sentry envelopes via `fetch`), so it works in both the
Worker and Node runtimes and adds **nothing** to the client bundle.

| Variable          | Scope                   | Notes                                                             |
| ----------------- | ----------------------- | ----------------------------------------------------------------- |
| `VITE_SENTRY_DSN` | client + server (build) | Sentry **DSN** (not a secret — it ships in the client bundle).    |
| `SENTRY_DSN`      | server (runtime)        | Optional server-runtime fallback (same value, no rebuild needed). |

The DSN is per-project: Sentry → Project → Settings → **Client Keys (DSN)**. Use a project in
the **EU** data region (INPDP / minors compliance, GAP-003). Events are **PII-scrubbed**
(e-mails redacted, `token`/`secret`/`password`/`email`/`key` extra fields redacted) and tagged
with the release (`VERCEL_GIT_COMMIT_SHA`) and environment. Set `VITE_SENTRY_DSN` in Vercel →
Settings → Environment Variables (Production), then redeploy without build cache.

## Web Push notifications

Scheduled push (streak reminders) needs a VAPID keypair and a cron secret:

| Variable                | Scope                 | Notes                                      |
| ----------------------- | --------------------- | ------------------------------------------ |
| `VAPID_PUBLIC_KEY`      | server (runtime)      | Web Push VAPID public key                  |
| `VAPID_PRIVATE_KEY`     | server only (runtime) | **secret** — VAPID private key             |
| `VAPID_SUBJECT`         | server (runtime)      | `mailto:` contact (VAPID requirement)      |
| `VITE_VAPID_PUBLIC_KEY` | client (build time)   | same public key (browser subscribe)        |
| `CRON_SECRET`           | server only (runtime) | **secret** — guards `GET /api/cron/notify` |

1. Generate the keypair once: `npx web-push generate-vapid-keys`.
2. Set the five variables in Vercel → Settings → Environment Variables.
   `VITE_VAPID_PUBLIC_KEY` must equal `VAPID_PUBLIC_KEY`; rebuild so it inlines.
3. The cron route is declared in `vercel.json` (`crons`); Vercel automatically
   sends `Authorization: Bearer $CRON_SECRET` on each scheduled run, which
   `src/server.ts` → `handlePushCron` verifies.

## Mode IA — la porte (étude 29)

L'étage IA a **deux payeurs derrière une seule porte** (étude 29 §1.3) : la clé
d'une famille (BYOK) ou la clé plateforme. Le mode « éteint » est l'état par
défaut de tout le monde, et le produit y est complet — aucune variable ci-dessous
n'est requise pour faire tourner l'application.

| Variable                       | Scope                 | Notes                                                                                                                         |
| ------------------------------ | --------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `AI_KEY_ENC_KEY`               | server only (runtime) | **secret** — KEK du coffre, 32 octets en base64. Absente ⇒ le chemin **famille** est éteint ; le chemin plateforme continue   |
| `AI_KEY_ENC_KEY_PREVIOUS`      | server only (runtime) | **secret** — KEK précédente pendant une rotation (optionnelle, retirée après)                                                 |
| `AI_MODE_ENABLED`              | server (runtime)      | Kill-switch **global** de la porte IA. Défaut `true` ; `0`/`false` éteint les deux payeurs                                    |
| `AI_BYOK_ENABLED`              | server (runtime)      | Kill-switch du **seul** chemin famille. Défaut `true` si `AI_KEY_ENC_KEY` est là                                              |
| `AI_FAKE_PROVIDER`             | server (runtime)      | `1` ⇒ fournisseur factice (CI, e2e, dev). Court-circuite tout appel réel                                                      |
| `AI_PLATFORM_API_KEY`          | server only (runtime) | **secret** — clé **plateforme** (chemin étude 11, budget A5), quel que soit le fournisseur. Absente ⇒ seul le BYOK fonctionne |
| `ANTHROPIC_API_KEY`            | server only (runtime) | **secret** — l'ancien nom de la même clé, toujours accepté en repli. `AI_PLATFORM_API_KEY` prime                              |
| `AI_PLATFORM_PROVIDER`         | server (runtime)      | Préréglage du fournisseur plateforme : `anthropic` (défaut), `openai`, `deepseek`, `xai`, `moonshot`, `zai`, `custom`         |
| `AI_PLATFORM_BASE_URL`         | server (runtime)      | Adresse compatible OpenAI. Facultative avec un préréglage nommé (elle le surcharge), **obligatoire** avec `custom`            |
| `AI_PLATFORM_MODEL_FAST`       | server (runtime)      | Modèle du palier `fast`. Défaut : celui du préréglage ; **obligatoire** avec `custom`                                         |
| `AI_PLATFORM_MODEL_RICH`       | server (runtime)      | Modèle du palier `rich`. Défaut : celui du préréglage ; **obligatoire** avec `custom`                                         |
| `AI_PLATFORM_DAILY_BUDGET_USD` | server (runtime)      | Plafond plateforme par jour (défaut `5`). Ne s'applique **jamais** au payeur `family`                                         |

**La clé plateforme est agnostique au fournisseur, comme celle d'une famille.**
Elle a longtemps été câblée sur Anthropic — le nom de la variable, le `provider`
du crédential et deux identifiants de modèle écrits en dur dans l'orchestrateur.
Une famille pouvait brancher DeepSeek, Grok, Kimi ou GLM depuis `/parametrage` ;
nous, non, alors que le moteur savait déjà le faire. Les cinq variables ci-dessus
se résolvent contre **les mêmes préréglages** que ce formulaire
([`src/shared/constants/ai.ts`](../src/shared/constants/ai.ts) →
`AI_PROVIDER_PRESETS`), porte « Autre » (`custom`) comprise.

Basculer la plateforme sur DeepSeek, par exemple, ne demande aucun déploiement de
code — deux variables :

```bash
AI_PLATFORM_PROVIDER=deepseek
AI_PLATFORM_API_KEY=sk-…
```

⚠️ **Le modèle choisi décide si le cache mutualisé se remplit — pas seulement ce
qu'il coûte.** Depuis [#872] la barrière de R-15.2 vaut pour **les deux payeurs** :
sur le chemin plateforme, une explication produite par un modèle absent
d'`AI_CURATED_MODELS` ([`src/shared/constants/ai.ts`](../src/shared/constants/ai.ts))
est servie à son demandeur et **rien n'est écrit** — le payeur plateforme n'a pas
d'`owner_user_id`, donc une entrée privée y serait morte à l'écriture
(`src/features/tutor/tutor.server.ts`, `curated || payer === "family"`).

[#876] a depuis élargi la liste curée à DeepSeek, Kimi, Grok, Gemini, GLM 5.2 et
Mistral : les préréglages nommés y entrent presque tous, et l'exemple DeepSeek
ci-dessus alimente bien le pot commun. Restent dehors `glm-5.3` (aucun tarif par
token publié — curer sans tarifer couperait le porteur à ~4 % de sa dépense) et
tout modèle saisi librement par `AI_PLATFORM_MODEL_FAST` / `AI_PLATFORM_MODEL_RICH`
via `custom`. Dans ces cas-là chaque explication est **régénérée** : la plateforme
peut coûter plus en agrégat qu'avec un modèle plus cher mais curé, et le panneau de
cache de `/admin/ia` lira 0 % sans en dire la raison. Vérifier le modèle contre la
liste curée fait donc partie du choix de fournisseur, au même titre que son tarif.

[#872]: https://github.com/MBeji/yahia-quest-arena/pull/872
[#876]: https://github.com/MBeji/yahia-quest-arena/pull/876

⚠️ **Une configuration incomplète éteint le chemin plateforme en silence** : pas
d'erreur à l'écran, l'élève retombe simplement sur le produit déterministe (R-1),
et le seul symptôme est une absence d'appels. Le motif est donc affiché dans
`/admin/ia` → « Clé plateforme » : `unknown_preset` (préréglage mal orthographié),
`missing_base_url` / `missing_model` (`custom` sans son adresse ou sans ses deux
modèles), `insecure_base_url` (adresse en `http://` — condition 1 de R-6).
Un préréglage inconnu est **refusé, pas rattrapé** : retomber sur Anthropic
enverrait la clé d'un autre fournisseur à l'adresse d'Anthropic, et le `401` qui
suivrait ne dirait pas pourquoi.

⚠️ **Aucune de ces variables n'est préfixée `VITE_`, et aucune ne doit l'être.**
Un préfixe `VITE_` inline la valeur dans le bundle client au build : ce serait la
clé plateforme en clair dans le navigateur de chaque élève.

⚠️ **Les plafonds de consommation ne sont plus un garde-fou d'environnement, et
ils ne coupent plus par défaut.** Depuis le 2026-08-22, `ai_credentials.limits_enforced`
vaut `false` à la création : la dépense et l'énergie sont **comptées et alertées**,
elles n'interrompent aucun appel. Le porteur réarme la coupure depuis
`/parametrage` → « Mode IA » → « Plafonds de consommation », sans redéploiement.
Ce qui reste actif sans elle : les seuils 50/80/100 % du repère et l'alerte
d'anomalie (une journée au-delà de 3× la médiane des sept précédentes) — c'est
désormais le **seul** signal automatique sur une facture qui dérape.

Générer la KEK du coffre (32 octets, base64) :

```bash
node -e "console.log(require('node:crypto').randomBytes(32).toString('base64'))"
```

**Rotation de la KEK** : poser la nouvelle valeur dans `AI_KEY_ENC_KEY`, l'ancienne
dans `AI_KEY_ENC_KEY_PREVIOUS`, redéployer. La lecture essaie la version courante
puis la précédente et **ré-écrit** en version courante au passage (rotation
paresseuse : pas de migration de données, pas de fenêtre de panne). Retirer
`AI_KEY_ENC_KEY_PREVIOUS` une fois toutes les lignes ré-écrites.

**Perte de la KEK** (RISK-10) : aucune donnée d'apprentissage n'est perdue — seules
les clés deviennent illisibles. Les crédentiaux passent en `invalid` et leurs
porteurs sont invités à re-saisir.

Tout le reste — identifiants de modèles, grille de prix **datée**, plafonds par
défaut, bornes de tokens, conditions de sortie réseau — est une **constante de
code**, dans [`src/shared/constants/ai.ts`](../src/shared/constants/ai.ts) et
nulle part ailleurs (étude 29 §3.10, étude 11 D-2 étendu).

### Runbook — couper le mode IA

Trois interrupteurs, du plus large au plus ciblé. Les deux premiers exigent un
redéploiement (variables d'environnement), le troisième non (données) :

| Geste                      | Où                                                 | Effet                                           |
| -------------------------- | -------------------------------------------------- | ----------------------------------------------- |
| Tout couper, tout de suite | `/admin/ia` → « Mode IA global »                   | Immédiat, sans redéploiement, journalisé        |
| Couper une famille         | RPC `set_ai_owner_suspension(owner, true, raison)` | Immédiat ; ses élèves retombent en déterministe |
| Couper la porte entière    | `AI_MODE_ENABLED=0` puis redéploiement             | Les deux payeurs, avant toute requête base      |
| Couper le seul BYOK        | `AI_BYOK_ENABLED=0` puis redéploiement             | Le chemin plateforme (étude 11) continue        |

⚠️ En cas de **suspicion de fuite de clé** (RISK-1), l'ordre compte : couper la
famille d'abord (elle cesse d'émettre), puis demander au porteur de révoquer sa
clé **chez son fournisseur** — c'est le seul geste qui l'invalide vraiment, et
nous ne pouvons pas le faire à sa place. Supprimer notre copie chiffrée
(`revoke_ai_credential`) vient après, pas avant.
