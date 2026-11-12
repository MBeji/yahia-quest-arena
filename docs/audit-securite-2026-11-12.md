# Revue de sécurité — 2026-11-12 (axe Sécurité de la vague d'amélioration)

Travail défensif sur l'application, qui sert des mineurs. Méthode : la chaîne de migrations
rejouée en local **avec les privilèges par défaut de Supabase** (toute fonction de `public`
naît exécutable par `anon`, `authenticated`, `service_role`), lecture des grants réels dans
`pg_proc`/`pg_class`, lecture du code, et une sonde de la production **en lecture seule**
(six requêtes, en-têtes et HTML). La base de production n'a pas été lue.

Suite de [`audit-global-2026-09-12.md`](./audit-global-2026-09-12.md) §3.2 (S-1, geste 8).

## 1. Constats et corrections

| #   | Gravité | Constat                                                                                                                                                                                                                                                                                                                      | Correction                                                                                                                                                   | Preuve                                                   | État                         |
| --- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------- | ---------------------------- |
| A   | Élevée¹ | `award_badge_if_new` (SECURITY DEFINER, aucun contrôle de l'appelant) n'a été révoquée que de `PUBLIC, anon` : un compte connecté peut s'attribuer n'importe quel badge par PostgREST. Même motif, en lecture : `resolve_ai_access` (qui paie le mode IA d'un élève), `app_daily_mission_pool`, `cleanup_rate_limit_events`. | `REVOKE … FROM authenticated` sur les quatre ; le shim local rejoue les privilèges par défaut ; cliquet pgTAP sur toute SECURITY DEFINER exposée sans garde. | pgTAP 110                                                | **Prête, en attente** (§3)   |
| B   | Moyenne | `/api/client-log` écrit sans jeton dans `client_errors`, 8 ko par requête, sans plafond durable ni purge : ~290 Mo/h depuis un poste, puis base en lecture seule.                                                                                                                                                            | Trigger : 30/min, 1 000/jour, 20 000 au total, purge à 30 jours ; ligne ignorée sans erreur.                                                                 | pgTAP 109                                                | Fusionnée (#1260), appliquée |
| C   | Moyenne | 14 RPC SECURITY DEFINER exécutables par `anon` (8 en septembre), limitées par une `Map` en mémoire par instance, contournable en appelant PostgREST directement.                                                                                                                                                             | `enforce_rpc_rate_limit` : paliers compte / source / global comptés en base, seuils en données, refus `PT429` (HTTP 429), sur les 8 RPC volatiles.           | pgTAP 108                                                | Fusionnée (#1260), appliquée |
| D   | Moyenne | `check_rate_limit` prenait la clé telle que fournie : un compte vidait le seau `submit_<uuid>` d'un autre élève (déni de service ciblé) ou gonflait `rate_limit_events` sans borne.                                                                                                                                          | Clé préfixée par `auth.uid()` ; plafonds 1 000 événements / 1 h.                                                                                             | pgTAP 108 (§9)                                           | Fusionnée (#1260), appliquée |
| E   | Faible  | Le journal ne caviardait que les clés de premier niveau, aucune valeur : `{ headers: { authorization } }` ou le message d'un fournisseur d'IA recopiant la clé refusée partaient en clair (logs Vercel, Sentry).                                                                                                             | `redact.ts` : clés à toute profondeur, formes de secret dans les valeurs, `Error` lisible ; même filtre vers Sentry.                                         | `redact.test.ts`, `logger.test.ts`, `monitoring.test.ts` | Cette PR                     |
| F   | Faible  | Le cours rendu côté serveur n'est pas passé par DOMPurify (pas de DOM), et rien ne le testait : `markdown.test.ts` tourne sous jsdom, où DOMPurify masque une régression d'échappement.                                                                                                                                      | Aucune faille trouvée ; test en environnement `node` sur un corpus de charges, et la politique XSS dit désormais ce qui tient ce chemin.                     | `markdown-ssr.test.ts`                                   | Cette PR                     |

¹ Élevée **si** le projet de production porte les privilèges par défaut historiques de
Supabase, ce qui est le cas de tout projet créé avant mi-2026 et n'a pas été lu en base. Si
ce n'est pas le cas, A est sans effet en production — et la correction reste juste.

## 2. Ce qui a été vérifié et tient

- **Clé de réponse.** `questions.correct_option`, `answer_key`, `accepted_answers`,
  `distractor_tags`, `explanation` ne sont accordées en `SELECT` ni à `anon` ni à
  `authenticated` (privilèges de colonne) : aucune server fn ne peut les lire, quelle que soit
  sa requête. Elles ne sortent que par des RPC SECURITY DEFINER dont c'est le rôle
  (`check_answers` hors quiz, bilan d'un test de niveau terminé, détail d'une tentative).
  HTML de production d'une page de cours et d'une page d'exercice : zéro occurrence.
- **Rendu serveur anonyme.** Une requête de page ne porte pas d'`Authorization` ;
  `optionalSupabaseAuth` répond en `anon`. Le HTML part en
  `cache-control: public, max-age=0, must-revalidate` (pas de cache partagé de contenu
  personnel) ; `getExerciseMeta` ne lit que titre, mode, chapitre, matière, sous la RLS
  d'`anon` (catalogue `source = 'admin'` seulement).
- **JSON-LD et métadonnées.** `serializeJsonLd` échappe `<` ; les balises `meta` sont des
  attributs React. Vérifié sur une page en arabe en production.
- **En-têtes de production** (`/`, `/sitemap.xml`, `/robots.txt`, `/api/health`) : CSP à nonce
  sans `unsafe-inline` pour les scripts, `frame-ancestors 'none'`, HSTS deux ans `preload`,
  `nosniff`, `X-Frame-Options: DENY`, `Referrer-Policy`, `Permissions-Policy`.
- **Base.** RLS activée sur toutes les tables ; toutes les fonctions SECURITY DEFINER ont un
  `search_path` ; les vues `econ_*`/`eng_*` et les vues matérialisées de classement ne sont
  accordées à aucun rôle client ; les classements ne rendent aucun identifiant d'élève.
  Migrations Parents du jour (`parent_digest_prefs`, `get_student_exam_summary`) : gardes et
  droits corrects, un parent non lié est refusé par `assert_can_read_student_activity`.
- **Server fns.** Chacune porte son middleware (`local/require-server-fn-auth`, dans le
  gate) ; les 19 fonctions publiques (`optionalSupabaseAuth`) valident leur entrée par zod.

## 3. Ce qui attend

**Le lot A est prêt et n'est pas poussé.** Vercel refuse tout déploiement depuis ~09:00 UTC
(plafond du plan) ; consigne de la session orchestratrice : aucun `REVOKE` tant que la
production est figée. Le lot ne touche pourtant aucun chemin que le code déployé emprunte
(les appelants sont des fonctions SECURITY DEFINER ou la clé service). Il tient en une
migration (`REVOKE EXECUTE … FROM PUBLIC, anon, authenticated` sur les quatre fonctions du
constat A, puis `GRANT … TO service_role`), une ligne dans `scripts/db/local/supabase-shim.sql`
(`ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO anon, authenticated,
service_role`) et `supabase/tests/110_internal_functions_not_exposed.test.sql`.

## 4. Noté, non corrigé (pas d'exploitation réaliste, ou hors périmètre)

- **`/sitemap.xml` est servi avant le garde anti-robots** et ne vit que du cache du CDN : une
  chaîne de requête aléatoire (`?x=…`) force une régénération (lecture du catalogue) à chaque
  appel. Remède : mémoriser le XML quelques minutes dans `generateSitemap`. → axe SEO.
- **Une RPC refusée par la borne rend `PT429`**, que les server fns traduisent en erreur
  générique. Un message « trop de requêtes » demanderait une ligne dans
  `quest.practice.server.ts`, `placement.server.ts`, `parent-report.server.ts`.
- **Les six RPC anonymes STABLE** ne sont pas bornées (transaction en lecture seule ; données
  de catalogue). Motivé dans la migration et figé par le cliquet de pgTAP 108.
- **Le palier « source » ne distingue pas un visiteur d'un autre derrière Vercel** : les
  fonctions sortent groupées sous quelques IP. Il borne un attaquant direct et le coût total,
  pas l'équité entre visiteurs — celle-ci reste au premier étage en mémoire. Le resserrer
  demanderait que le serveur signe l'IP du visiteur (un secret partagé avec la base).
- **Un `x-forwarded-for` se forge** ; `cf-connecting-ip` prime quand la passerelle le pose.
  Quel en-tête la passerelle Supabase transmet réellement n'a pas été observé (base non lue) :
  c'est le plafond global qui tient dans tous les cas.
- **`score_quiz` est un oracle** : n+1 appels donnent la clé d'un quiz de n questions. Borné
  désormais (120/min par compte, 300/min par source), pas supprimé — c'est le prix d'un score
  public.
- **Le code alliance est l'uuid de l'élève** (décision produit du 2026-07-08, 122 bits) : qui
  le connaît lit son rapport. Aucun classement ni duel ne le rend ; à garder vrai.
- **`has_parcours_entitlement`, `can_play_open_questions`, `ai_forge_quota_left`** répondent
  pour l'uuid de n'importe qui (un booléen, un compteur de 0 à 3). Accepté, nommé dans la
  liste d'exemptions de pgTAP 110.
- **Secret des routes cron comparé par `!==`** (pas à temps constant), routes placées avant le
  garde : non exploitable à travers le réseau contre un secret long.
- **Tables anciennes** : `anon` y garde les privilèges par défaut (`TRUNCATE` compris), sans
  effet par PostgREST, qui ne l'expose pas ; la RLS porte l'accès.
