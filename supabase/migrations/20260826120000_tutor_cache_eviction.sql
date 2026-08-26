-- ÉTUDE 29, R-15 GARDE-FOU 3 — LA SORTIE DU POT COMMUN.
--
-- « Éviction sur signal : deux 👎 sur une entrée partagée la retirent du pot et
--   forcent une régénération. Le taux d'éviction est un indicateur de la console
--   admin. » (é29 R-15.3, arbitrée le 2026-08-20 avec Q-3.)
--
-- L'ENTRÉE ÉTAIT GARDÉE, LA SORTIE N'EXISTAIT PAS
-- ---------------------------------------------------------------------------
-- Les deux premiers garde-fous de R-15 sont en place : le contenu mutualisé ne
-- porte aucune donnée personnelle (l'unité de cache est dérivée de la QUESTION),
-- et l'entrée dans le pot exige un modèle de `AI_CURATED_MODELS` plus le
-- validateur de sortie — fermé pour les deux payeurs par #872, élargi ensuite,
-- ramené à une barrière unique par #875. Le troisième, lui, n'a jamais été
-- écrit : rien dans `src/**` ni dans `supabase/**` ne retirait quoi que ce soit
-- du pot. `rate_tutor_message` écrivait dans `tutor_feedback` et s'arrêtait là.
--
-- Le défaut n'était pas seulement une règle manquante, il était AGGRAVANT :
-- `find_tutor_explanation` trie par `ORDER BY e.shared DESC, e.serve_count DESC`.
-- L'entrée la plus servie est donc la plus collante — une mauvaise explication
-- très servie se servait de plus en plus, à des enfants de plus en plus
-- nombreux, sans aucun chemin de retour. C'est RISK-4 d'é29 atteint par sa pente
-- la plus douce.
--
-- ⭐ CE QUI MANQUAIT VRAIMENT : LE LIEN MESSAGE → ENTRÉE DE CACHE
-- ---------------------------------------------------------------------------
-- `tutor_feedback` porte `(thread_id, message_ix)` — un RANG dans un fil, choisi
-- exprès par é11 lot 1 pour ne pas dupliquer le verbatim. Ce rang ne dit RIEN de
-- l'entrée de cache qui a produit le message. Un 👎 était donc imputable à un
-- message et à personne d'autre : il n'existait aucun moyen, même en SQL à la
-- main, de savoir quelle ligne de `tutor_explanations` venait de se faire
-- désavouer. Voilà pourquoi ce sujet est un LOT et pas un correctif — il faut
-- créer le lien avant de pouvoir compter quoi que ce soit.
--
-- ARBITRAGE 1 — TABLE DE JONCTION, PAS COLONNE DE LIEN. Trois formes étaient
-- possibles :
--
--   (a) une clé `explanation_id` dans l'objet JSON du message
--       (`tutor_threads.messages`). Le lien vit alors exactement où vit le
--       message, et se purge avec lui. Rejeté pour DEUX raisons : compter les 👎
--       d'une entrée demanderait de balayer `tutor_threads` en extrayant du
--       JSONB, sans index — or c'est précisément la requête que fait chaque 👎 ;
--       et `tutor_threads` est LISIBLE par son propriétaire (`GRANT SELECT`),
--       donc l'identifiant interne du cache deviendrait une donnée de client.
--   (b) une colonne `explanation_id` sur `tutor_feedback`, remplie par le
--       client. Rejeté net : le client DÉSIGNERAIT alors l'entrée à évincer. Le
--       jour où quelqu'un devine ou obtient un UUID, il vide le pot commun.
--   (c) ⭐ une table de jonction écrite par le SERVEUR, invisible du client —
--       celle retenue. Intégrité par FK, cascade des deux côtés, un index sur
--       `explanation_id` pour la seule requête chaude, et aucun droit client :
--       personne ne peut prétendre qu'un message vient d'une entrée qu'il
--       choisit.
--
-- ARBITRAGE 2 — « DEUX 👎 » SE LIT « DEUX VOIX », PAS « DEUX CLICS ». La règle
-- dit deux 👎 sur une entrée PARTAGÉE. Une entrée partagée est par construction
-- servie à plusieurs élèves ; et le même élève PEUT se faire resservir la même
-- entrée deux fois (rouvrir le panneau de correction re-sert le registre déjà
-- servi, é11 R-7), donc produire deux 👎 à lui seul. Compter ces deux-là comme
-- un signal reviendrait à évincer sur l'avis d'un seul enfant — et à offrir à un
-- seul compte le pouvoir de vider le pot. On compte donc des `user_id`
-- DISTINCTS. `tutor_feedback` portait déjà la même intention avec son
-- `UNIQUE (thread_id, message_ix, user_id)` : « un avis par message ». Ici, un
-- avis par personne et par entrée.
--
-- Conséquence assumée, dite plutôt que tue : une entrée PRIVÉE ne peut pas être
-- évincée, puisque `find_tutor_explanation` ne la sert qu'à son propriétaire —
-- une seule voix, jamais deux. C'est exactement le périmètre de R-15.3, qui ne
-- parle que du pot. L'élève qu'une explication privée ne satisfait pas a déjà sa
-- porte de sortie : « Explique autrement » change de registre, donc de clé de
-- cache.
--
-- ARBITRAGE 3 — `evicted_at`, ET `shared` N'EST PAS RETOURNÉ. « Retirer du pot »
-- pouvait s'écrire `shared = false`. Deux raisons de ne pas le faire :
--
--   * ça ne suffirait pas. `find_tutor_explanation` sert sur
--     `(e.shared OR e.owner_user_id = v_user)` : basculer `shared` continuerait
--     de servir la mauvaise explication à la famille qui l'a payée — la seule à
--     qui on doit une régénération, justement ;
--   * ça effacerait la mesure. `shared` est « un fait constaté à l'écriture »
--     (é11 lot 1) ; le retourner ferait disparaître l'entrée du dénominateur, et
--     le taux d'éviction que R-15.3 réclame deviendrait incalculable.
--
-- L'entrée et la sortie sont donc DEUX faits, chacun sa colonne. « Dans le pot »
-- se lit `shared AND evicted_at IS NULL`, et la console peut dire combien de ce
-- qui est entré en est ressorti.
--
-- L'éviction est un ALLER SIMPLE : un 👍 postérieur ne remet rien dans le pot.
-- Deux enfants ont dit que cette explication était mauvaise ; la régénérer coûte
-- un appel, la resservir coûte un contresens. Le compte, lui, reste vivant (il
-- lit `rating = -1` à l'instant du calcul) : c'est le franchissement du seuil
-- qui est définitif, pas le vote.
--
-- CE QUE CETTE MIGRATION NE FAIT PAS, ET POURQUOI
-- ---------------------------------------------------------------------------
-- Elle ne rebranche PAS le hit-rate de la console sur la nouvelle table.
-- `20260824130000` avait écarté l'option « dater les hits » (arbitrage (b) de
-- son en-tête) comme trop chère pour un chiffre d'observabilité ; la jonction
-- posée ici en paie une partie du prix pour une raison de CORRECTION. La
-- tentation serait d'en tirer aussitôt un hit-rate fenêtré — ce serait changer
-- le contrat d'un écran dans une migration qui répare une règle. La mesure par
-- cohorte reste ce qu'elle est ; le jour où quelqu'un voudra la fenêtrer, il
-- aura la table, et il le fera dans son propre lot.
--
-- AGENTS.md : table neuve ⇒ GRANT explicites (le piège de la base vierge).

-- ---------------------------------------------------------------------------
-- 1. Le seuil, en miroir documenté du code.
-- ---------------------------------------------------------------------------
-- Même posture que `tutor_daily_energy()` : le seuil vit dans
-- `src/shared/constants/ai.ts`, et la base en garde un miroir IMMUTABLE parce
-- qu'elle décide seule, dans la transaction qui enregistre le 👎. Le changer
-- demande une migration, donc une revue — c'est le but.
CREATE OR REPLACE FUNCTION public.tutor_eviction_downvotes()
RETURNS INT
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT 2;
$$;

COMMENT ON FUNCTION public.tutor_eviction_downvotes() IS
  'Étude 29 R-15.3 : nombre de VOIX distinctes en 👎 qui retirent une explication du pot commun. Miroir de TUTOR_EVICTION_DOWNVOTES. Des utilisateurs distincts, pas des clics : le même élève peut se faire resservir la même entrée (é11 R-7).';

REVOKE EXECUTE ON FUNCTION public.tutor_eviction_downvotes() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.tutor_eviction_downvotes() TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. La SORTIE du pot — la colonne qui manquait à `tutor_explanations`.
-- ---------------------------------------------------------------------------
ALTER TABLE public.tutor_explanations
  ADD COLUMN IF NOT EXISTS evicted_at TIMESTAMPTZ;

COMMENT ON COLUMN public.tutor_explanations.evicted_at IS
  'Étude 29 R-15.3 : instant où deux voix distinctes en 👎 ont retiré cette explication du service. Non NULL ⇒ find_tutor_explanation ne la rend plus à PERSONNE, pas même à son payeur (« forcent une régénération »). `shared` n''est PAS retourné : l''entrée reste un fait d''écriture, la sortie est ce fait-ci — c''est ce qui rend le taux d''éviction calculable.';

-- ---------------------------------------------------------------------------
-- 3. ⭐ LE LIEN QUI MANQUAIT — quelle entrée de cache a produit ce message.
-- ---------------------------------------------------------------------------
-- Une ligne = « l'entrée E a été servie dans le message n° I du fil T ». C'est
-- le SEUL chemin entre un 👎 et une entrée de cache, et il est écrit par le
-- serveur ou pas du tout.
CREATE TABLE IF NOT EXISTS public.tutor_explanation_servings (
  thread_id      UUID NOT NULL REFERENCES public.tutor_threads(id) ON DELETE CASCADE,
  message_ix     INT NOT NULL CHECK (message_ix >= 0),
  explanation_id UUID NOT NULL REFERENCES public.tutor_explanations(id) ON DELETE CASCADE,
  served_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  -- Un message ne peut venir que d'une seule entrée. La clé primaire est donc
  -- celle de `tutor_feedback` moins l'utilisateur : c'est la jointure exacte
  -- que fait l'éviction.
  PRIMARY KEY (thread_id, message_ix)
);

COMMENT ON TABLE public.tutor_explanation_servings IS
  'Étude 29 R-15.3 : le lien message → entrée de cache, sans lequel un 👎 n''est imputable à rien (tutor_feedback ne porte qu''un RANG dans un fil). Écrite par record_tutor_explanation_serving(), service_role SEUL : si le client pouvait la remplir, il désignerait l''entrée à évincer. Aucun droit client, aucune policy.';

-- La requête de l'éviction part de l'entrée, pas du fil : « qui a désavoué
-- CETTE explication ». Sans cet index, chaque 👎 balaierait la table.
CREATE INDEX IF NOT EXISTS idx_tutor_servings_explanation
  ON public.tutor_explanation_servings (explanation_id);

ALTER TABLE public.tutor_explanation_servings ENABLE ROW LEVEL SECURITY;

-- ⚠️ Aucun droit client, aucune policy — comme `tutor_explanations` elle-même.
-- Le motif n'est pas le secret du contenu (il n'y en a pas ici) mais
-- l'INTÉGRITÉ du signal : ce lien décide d'une éviction, et une éviction est
-- une perte pour tout le parc.
REVOKE ALL ON public.tutor_explanation_servings FROM anon, authenticated;
GRANT ALL ON public.tutor_explanation_servings TO service_role;

-- ---------------------------------------------------------------------------
-- 4. L'écriture du lien — `service_role` SEUL.
-- ---------------------------------------------------------------------------
-- Même posture que `store_tutor_explanation` : le serveur Node connaît
-- l'identifiant de l'entrée servie (rendu par `find_tutor_explanation` sur un
-- HIT, par `store_tutor_explanation` sur un MISS) et le range ici avec le rang
-- du message que `append_tutor_message` vient de lui rendre.
--
-- POURQUOI PAS UN PARAMÈTRE DE PLUS SUR `append_tutor_message` — ç'aurait été
-- une écriture de moins. Deux raisons : `append_tutor_message` est GRANT à
-- `authenticated`, donc un client forgerait le lien lui-même ; et lui ajouter un
-- paramètre à valeur par défaut CRÉERAIT UNE SURCHARGE (PostgreSQL garde
-- l'ancienne signature), ce qui rend l'appel ambigu pour PostgREST et laisse
-- traîner une fonction à sept arguments que les GRANT ne suivent plus.
--
-- `ON CONFLICT DO UPDATE` : le rang d'un message est stable, mais un rejeu de la
-- même écriture ne doit pas lever. Idempotent, jamais bloquant.
CREATE OR REPLACE FUNCTION public.record_tutor_explanation_serving(
  p_thread      UUID,
  p_message_ix  INT,
  p_explanation UUID
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF p_thread IS NULL OR p_message_ix IS NULL OR p_explanation IS NULL THEN
    RETURN;
  END IF;

  INSERT INTO public.tutor_explanation_servings (thread_id, message_ix, explanation_id)
  VALUES (p_thread, p_message_ix, p_explanation)
  ON CONFLICT (thread_id, message_ix)
  DO UPDATE SET explanation_id = EXCLUDED.explanation_id, served_at = now();
END;
$$;

COMMENT ON FUNCTION public.record_tutor_explanation_serving(UUID, INT, UUID) IS
  'Étude 29 R-15.3 : range le lien message → entrée de cache. service_role SEUL — un client qui pourrait l''appeler désignerait l''entrée que son 👎 évincera.';

REVOKE EXECUTE ON FUNCTION public.record_tutor_explanation_serving(UUID, INT, UUID)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.record_tutor_explanation_serving(UUID, INT, UUID)
  TO service_role;

-- ---------------------------------------------------------------------------
-- 5. RÉVISION VIVANTE 1/3 — `find_tutor_explanation` cesse de servir l'évincé.
-- ---------------------------------------------------------------------------
-- Corps repris À L'IDENTIQUE de `20260822231000_tutor_explain_rpcs.sql`, à trois
-- endroits près, tous marqués R-15.3 ci-dessous. Le reste n'est pas retapé : il
-- est recopié, pour ne pas perdre au passage un correctif venu d'ailleurs.
CREATE OR REPLACE FUNCTION public.find_tutor_explanation(
  p_question_id   UUID,
  p_misconception TEXT,
  p_lang          TEXT,
  p_age_band      TEXT,
  p_variant       TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_row  RECORD;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.question_attempts a
     WHERE a.user_id = v_user AND a.question_id = p_question_id
  ) THEN
    RAISE EXCEPTION 'NOT_ATTEMPTED';
  END IF;

  -- Le pot commun d'abord, la réserve privée ensuite : à qualité égale, une
  -- explication déjà payée par la communauté coûte moins qu'une des siennes.
  SELECT * INTO v_row
    FROM public.tutor_explanations e
   WHERE e.question_id = p_question_id
     AND e.misconception IS NOT DISTINCT FROM p_misconception
     AND e.lang = p_lang
     AND e.age_band = p_age_band
     AND e.variant = p_variant
     -- R-15.3 ⭐ — LA SORTIE. Une entrée évincée n'est resservie à PERSONNE, pas
     -- même à son payeur : « forcent une régénération » ne souffre pas
     -- d'exception, sinon la famille qui a payé la mauvaise explication serait
     -- la seule à qui on continue de la servir. La ligne, elle, reste en base :
     -- c'est elle qui porte le taux d'éviction de la console (§7).
     AND e.evicted_at IS NULL
     AND (e.shared OR e.owner_user_id = v_user)
   -- ⚠️ `serve_count DESC` rend l'entrée la PLUS servie la plus COLLANTE. C'est
   -- l'ordre qui amortit le pot commun, et c'était aussi ce qui rendait le trou
   -- de R-15.3 dangereux : sans sortie, une mauvaise explication très servie se
   -- servait de plus en plus. L'ordre ne change pas — il n'est simplement plus
   -- définitif, et c'est ce qui le rend tenable.
   ORDER BY e.shared DESC, e.serve_count DESC
   LIMIT 1;

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  UPDATE public.tutor_explanations SET serve_count = serve_count + 1 WHERE id = v_row.id;

  -- R-15.3 — `id` REJOINT LA CHARGE. C'est lui, et rien d'autre, qui permet au
  -- serveur de ranger le lien message → entrée (§4). Sans lui le 👎 retombe sur
  -- un rang de fil, c'est-à-dire sur rien. Ajout PUREMENT additif : les clés
  -- existantes ne bougent pas, et `cacheHitSchema` le lit en optionnel pour
  -- qu'un déploiement en avance sur sa migration serve encore le cache.
  RETURN jsonb_build_object(
    'id', v_row.id, 'body', v_row.body, 'model', v_row.model, 'shared', v_row.shared
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.find_tutor_explanation(UUID, TEXT, TEXT, TEXT, TEXT)
  FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.find_tutor_explanation(UUID, TEXT, TEXT, TEXT, TEXT)
  TO authenticated;

-- ---------------------------------------------------------------------------
-- 6. ⭐ RÉVISION VIVANTE 2/3 — `rate_tutor_message` ÉVINCE.
-- ---------------------------------------------------------------------------
-- C'est ici que R-15.3 devient un fait. Corps repris à l'identique, plus le
-- bloc d'éviction et ses deux variables.
--
-- POURQUOI L'ÉVICTION EST DANS LE CHEMIN DU 👎 et pas dans un cron : le motif
-- de é29 D-8, « la coupure est dans le chemin de requête ». Un balayage
-- nocturne découvrirait le seuil franchi après une nuit de service — donc après
-- avoir resservi la mauvaise explication à tous les élèves qui ont travaillé ce
-- soir-là. Le coût est d'un COUNT indexé par 👎, sur un geste qui est déjà une
-- écriture.
CREATE OR REPLACE FUNCTION public.rate_tutor_message(
  p_thread     UUID,
  p_message_ix INT,
  p_rating     SMALLINT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  -- R-15.3 — l'entrée de cache derrière ce message, et le nombre de voix qui
  -- l'ont désavouée. Les deux restent NULL sur un 👍 : on ne paie la requête
  -- que quand elle peut décider quelque chose.
  v_expl   UUID;
  v_voices INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.tutor_threads t WHERE t.id = p_thread AND t.user_id = v_user
  ) THEN
    RAISE EXCEPTION 'THREAD_NOT_FOUND';
  END IF;

  INSERT INTO public.tutor_feedback (thread_id, user_id, message_ix, rating)
  VALUES (p_thread, v_user, p_message_ix, p_rating)
  ON CONFLICT (thread_id, message_ix, user_id)
  DO UPDATE SET rating = EXCLUDED.rating, created_at = now();

  -- ⭐ R-15.3 — L'ÉVICTION. « Deux 👎 sur une entrée partagée la retirent du pot
  -- et forcent une régénération. »
  --
  -- Trois précisions que le code porte et que la règle laisse ouvertes, toutes
  -- argumentées dans l'en-tête de cette migration :
  --
  --   * on compte des VOIX (`count(DISTINCT f.user_id)`), pas des clics. Le même
  --     élève peut se faire resservir la même entrée (é11 R-7) et cliquer deux
  --     fois : ce serait l'avis d'un seul enfant, et la porte ouverte à un seul
  --     compte pour vider le pot ;
  --   * le compte est REFAIT à chaque 👎 plutôt qu'incrémenté. Un 👍 qui corrige
  --     un 👎 (`ON CONFLICT DO UPDATE` ci-dessus) doit donc REDESCENDRE le
  --     compte — un compteur incrémental l'aurait manqué, et aurait évincé sur
  --     un avis retiré ;
  --   * l'éviction elle-même est un ALLER SIMPLE (`AND evicted_at IS NULL`) :
  --     une fois le seuil franchi, un 👍 postérieur ne remet rien dans le pot.
  --
  -- Le 👎 reste enregistré quoi qu'il arrive : sans lien connu (un message
  -- antérieur à cette migration, ou une réponse qui ne venait pas du cache),
  -- l'avis vit sa vie dans `tutor_feedback` et n'évince rien.
  IF p_rating = -1 THEN
    SELECT s.explanation_id INTO v_expl
      FROM public.tutor_explanation_servings s
     WHERE s.thread_id = p_thread AND s.message_ix = p_message_ix;

    IF v_expl IS NOT NULL THEN
      SELECT count(DISTINCT f.user_id) INTO v_voices
        FROM public.tutor_explanation_servings s
        JOIN public.tutor_feedback f
          ON f.thread_id = s.thread_id AND f.message_ix = s.message_ix
       WHERE s.explanation_id = v_expl
         AND f.rating = -1;

      IF v_voices >= public.tutor_eviction_downvotes() THEN
        UPDATE public.tutor_explanations
           SET evicted_at = now()
         WHERE id = v_expl
           AND evicted_at IS NULL;
      END IF;
    END IF;
  END IF;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.rate_tutor_message(UUID, INT, SMALLINT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.rate_tutor_message(UUID, INT, SMALLINT) TO authenticated;

COMMENT ON FUNCTION public.rate_tutor_message(UUID, INT, SMALLINT) IS
  'Étude 11 R-17 (l''avis) + étude 29 R-15.3 (l''éviction) : enregistre le 👍/👎 et, sur un 👎, retire du service l''entrée de cache qui a produit ce message dès que tutor_eviction_downvotes() VOIX DISTINCTES l''ont désavouée. Le lien vient de tutor_explanation_servings ; sans lien, l''avis n''évince rien.';

-- ---------------------------------------------------------------------------
-- 7. RÉVISION VIVANTE 3/3 — l'indicateur que R-15.3 réclame nommément.
-- ---------------------------------------------------------------------------
-- « Le taux d'éviction est un indicateur de la console admin. » Corps repris à
-- l'identique de `20260824130000_tutor_energy_console.sql` — y compris son
-- en-tête d'arbitrage, qui reste vrai —, plus une variable, un `FILTER` et deux
-- clés. Le type de retour est un JSONB : ajouter des clés ne DÉPOSE rien et
-- n'emporte aucun GRANT (c'était l'argument de ce fichier-là contre un
-- `RETURNS TABLE`).
--
-- LE DÉNOMINATEUR EST `sharedRows`, PAS `misses`. Le taux répond à « quelle part
-- de ce qui est entré dans le pot en est ressorti » ; le rapporter à toutes les
-- générations le diluerait avec les réserves privées, qui ne peuvent pas être
-- évincées (une seule voix possible). Le numérateur, lui, compte TOUTES les
-- lignes évincées de la cohorte : si une privée l'était un jour — ce que le
-- seuil à deux voix rend impossible en l'état — le taux passerait au-dessus de
-- 100 % et se VERRAIT, au lieu d'être maquillé en chiffre plausible. C'est la
-- posture déjà écrite dans `tutor-cache-stats.tsx`.
CREATE OR REPLACE FUNCTION public.get_tutor_cache_stats(p_days INT DEFAULT 30)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_days      INT;
  v_since     TIMESTAMPTZ;
  -- Le cache, sur la cohorte : générations, services, et la coupe partagé/privé.
  v_generated BIGINT;
  v_served    BIGINT;
  v_sh_rows   BIGINT;
  v_sh_served BIGINT;
  -- R-15.3 : la sortie du pot, sur la même cohorte que le reste.
  v_evicted   BIGINT;
  -- La Forge : NUMERIC dès la source, pour que la division n'ait pas à caster.
  v_discarded NUMERIC;
  v_kept      NUMERIC;
BEGIN
  -- Comme `get_ai_admin_overview` : c'est la seule surface du lot qui voit
  -- au-delà d'une famille, donc la seule qui mérite une garde de rôle
  -- explicite. Elle LÈVE ; R-15 (dégradé gracieux) se tient côté serveur Node,
  -- qui traduit ce refus en un état d'écran — jamais l'inverse, car une
  -- fonction qui rendrait « {} » à un non-admin serait indistinguable d'un parc
  -- vide, et le jour où la garde casserait personne ne le verrait.
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  -- La fenêtre est BORNÉE en base, pas dans l'écran. Deux raisons : un
  -- `p_days` nul ou négatif rendrait `now() - interval` supérieur à `now()` et
  -- la fenêtre serait VIDE au lieu d'être invalide (un zéro silencieux, le pire
  -- des cas) ; et 365 est la borne haute utile, puisque R-14 purge la
  -- comptabilité à 12 mois — au-delà, on balaierait pour rien.
  v_days  := GREATEST(LEAST(COALESCE(p_days, 30), 365), 1);
  v_since := now() - make_interval(days => v_days);

  -- ⚠️ `serve_count` n'est PAS filtré par date : il ne le peut pas, et il n'en
  -- a pas besoin. Le filtre porte sur `created_at`, donc sur la cohorte ; tous
  -- les services d'une ligne de la cohorte lui sont postérieurs par
  -- construction. C'est tout l'argument de l'arbitrage (c) ci-dessus.
  --
  -- ⚠️ `evicted_at` n'est PAS filtré par date non plus, et pour la même raison
  -- que `serve_count` : une ligne de la cohorte ne peut être évincée qu'après
  -- avoir été créée. Le filtre sur `created_at` suffit à border les deux.
  SELECT COUNT(*),
         COALESCE(SUM(e.serve_count), 0),
         COUNT(*) FILTER (WHERE e.shared),
         COALESCE(SUM(e.serve_count) FILTER (WHERE e.shared), 0),
         COUNT(*) FILTER (WHERE e.evicted_at IS NOT NULL)
    INTO v_generated, v_served, v_sh_rows, v_sh_served, v_evicted
    FROM public.tutor_explanations e
   WHERE e.created_at >= v_since;

  -- LA FORMULE DU REBUT EST CELLE DE `get_ai_console`, DÉLIBÉRÉMENT À
  -- L'IDENTIQUE (20260822210000, CTE `forge`, révisée en 20260822220000) :
  -- `discarded / (discarded + kept)` où `kept` compte les items retenus dans
  -- `payload->'items'`, arrondi à 3 décimales. Deux écrans qui décrivent le
  -- MÊME phénomène avec deux formules différentes sont pires que pas d'écran du
  -- tout — on ne saurait plus lequel croire. Seules deux choses changent : le
  -- filtre `owner_user_id` disparaît (c'est le parc, pas une famille), et la
  -- fenêtre devient paramétrable.
  --
  -- Le `jsonb_typeof(...) = 'array'` est le seul écart, et il est délibéré :
  -- `jsonb_array_length` LÈVE sur un jsonb qui n'est pas un tableau. La version
  -- famille pouvait se le permettre — une charge malformée n'y casse que la
  -- console de son propre payeur. Ici, une seule ligne malformée n'importe où
  -- dans le parc éteindrait la console de TOUT LE MONDE. Le garde ne change
  -- aucune valeur sur une ligne bien formée (clé absente ⇒ 0 des deux côtés).
  SELECT COALESCE(SUM(q.discarded), 0)::NUMERIC,
         COALESCE(SUM(CASE WHEN jsonb_typeof(q.payload->'items') = 'array'
                           THEN jsonb_array_length(q.payload->'items')
                           ELSE 0 END), 0)::NUMERIC
    INTO v_discarded, v_kept
    FROM public.ai_forged_quizzes q
   WHERE q.created_at >= v_since;

  -- ⚠️ CHAQUE division est gardée par son dénominateur. Une console d'admin sur
  -- un parc VIDE — le jour 1 de la mise en service, exactement le moment où on
  -- la regarde le plus — doit afficher des zéros, jamais une erreur. Un
  -- `division_by_zero` ici remonterait jusqu'à l'écran sous forme de « accès
  -- refusé », et on chercherait la panne du mauvais côté.
  --
  -- ⚠️⚠️ CES NOMS DE CLÉS SONT UN CONTRAT, PAS UN GOÛT.
  -- `cacheStatsSchema` dans `src/features/tutor/tutor.energy.server.ts` les
  -- valide, et ses deux TAUX y sont volontairement SANS `.catch()` : renommer
  -- `hitRate` ou `discardRate` ici ne casse rien de visible — le zod échoue, la
  -- server fn rend `null`, et le panneau affiche « mesure indisponible ». Ce
  -- silence est délibéré côté client (« un aveu se corrige, un zéro silencieux
  -- se croit »), mais il n'aide personne si le renommage vient d'ici sans
  -- passer par là. Les deux fichiers se modifient ENSEMBLE.
  --
  -- `days` voyage avec les chiffres : un ratio dont on ignore la fenêtre est un
  -- chiffre qu'on ne peut pas contredire. L'écran doit pouvoir écrire « sur
  -- 30 j » sans le supposer — surtout après le bornage ci-dessus, qui a pu ne
  -- pas retenir ce que l'appelant demandait.
  --
  -- `lifetimeHitRate` répond à une question que le client a le droit de poser :
  -- « ce taux est-il fenêtré, ou depuis toujours ? ». La réponse est FALSE, et
  -- elle est explicite plutôt qu'absente : l'arbitrage (c) a retenu la cohorte,
  -- donc une vraie fenêtre. Le jour où quelqu'un rebasculerait sur le cumul à
  -- vie (arbitrage (a)), il lui suffirait de passer `true` et l'écran changerait
  -- son libellé tout seul, au lieu de mentir sur « 30 j ».
  RETURN jsonb_build_object(
    'days',            v_days,
    'lifetimeHitRate', false,
    -- Un « hit » est un service tiré du cache ; un « miss » est une génération.
    -- Le second nom est celui du client, et il mérite sa nuance : un miss suivi
    -- d'une génération REFUSÉE par le validateur, ou tombée en panne
    -- fournisseur, n'écrit aucune ligne — il n'a rien livré non plus. On compte
    -- donc des LIVRAISONS, pas des recherches de cache (biais n°2 de l'en-tête).
    'hits',            v_served,
    'misses',          v_generated,
    'delivered',       v_generated + v_served,
    'hitRate',         CASE WHEN v_generated + v_served > 0
                            THEN ROUND(v_served::NUMERIC / (v_generated + v_served), 3)
                            ELSE 0 END,
    -- R-15.2 / D-9 : la coupe partagé/privé dit si le POT COMMUN porte
    -- réellement la charge, ou si le parc s'est fragmenté en réserves privées.
    -- Un hit-rate haut porté par du privé ne mutualise rien : chaque famille
    -- repaie sa propre explication. Les deux chiffres se lisent ENSEMBLE.
    'sharedRows',      v_sh_rows,
    'privateRows',     v_generated - v_sh_rows,
    'sharedHits',      v_sh_served,
    'privateHits',     v_served - v_sh_served,
    'sharedRate',      CASE WHEN v_generated > 0
                            THEN ROUND(v_sh_rows::NUMERIC / v_generated, 3)
                            ELSE 0 END,
    -- R-15.3 — LA SORTIE, à côté de l'entrée. Les deux se lisent ensemble : un
    -- `sharedRate` haut avec un `evictionRate` qui monte dit que le pot se
    -- remplit d'explications que les élèves refusent — c'est-à-dire que la
    -- condition d'entrée (modèle curé + validateur) ne suffit plus, et que le
    -- modèle configuré est en cause. C'est exactement l'alerte que RISK-4
    -- attendait.
    'evictedRows',     v_evicted,
    'evictionRate',    CASE WHEN v_sh_rows > 0
                            THEN ROUND(v_evicted::NUMERIC / v_sh_rows, 3)
                            ELSE 0 END,
    'discarded',       v_discarded,
    'kept',            v_kept,
    'discardRate',     CASE WHEN v_discarded + v_kept > 0
                            THEN ROUND(v_discarded / (v_discarded + v_kept), 3)
                            ELSE 0 END
  );
END;
$$;

COMMENT ON FUNCTION public.get_tutor_cache_stats(INT) IS
  'Étude 11 lot 7 + étude 29 R-15.3 : hit-rate du cache mutualisé d''explications (cible §1.4 > 60 % à S+4), TAUX D''ÉVICTION du pot commun, et taux de rebut de la Forge, à l''échelle du PARC. Mesure par COHORTE (explications créées dans la fenêtre), faute de hit daté : elle SOUS-ESTIME le hit-rate instantané. evictionRate = lignes évincées / lignes entrées au pot, sur la cohorte. Rebut = la formule de get_ai_console, sans le filtre owner. Réservée à is_admin(), agrégats seuls (R-14).';

-- Le motif de toutes les RPC du dépôt : PUBLIC et anon perdent l'EXECUTE que
-- PostgreSQL accorde par défaut — sans ce REVOKE, une fonction SECURITY DEFINER
-- serait appelable sans session, et la garde `is_admin()` deviendrait le SEUL
-- rempart au lieu d'être le second.
REVOKE EXECUTE ON FUNCTION public.get_tutor_cache_stats(INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_tutor_cache_stats(INT) TO authenticated;
