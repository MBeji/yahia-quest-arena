-- Étude 11 — lot 1 : « Demander au Prof », côté base. La première brique
-- PÉDAGOGIQUE de l'étage IA.
--
-- CE QUE CE LOT N'A PAS À CONSTRUIRE
-- ---------------------------------------------------------------------------
-- L'étude 11 a été écrite AVANT l'étude 29. Son §3.2 prévoyait sa propre
-- comptabilité (`ai_usage_events`), sa propre énergie (`tutor_daily_usage`) et
-- son propre kill-switch (R-13). Les trois sont livrés depuis le 2026-08-22, en
-- mieux : `ai_usage_events` porte un PAYEUR, `ai_energy_ledger` réserve l'énergie
-- dans la même transaction que l'argent, et `resolve_ai_access` décide de tout
-- en SQL. Q-1 l'a arbitré — « il n'y a qu'un seul socle ».
--
-- Cette migration ne recrée donc AUCUN de ces objets. Elle ajoute les quatre
-- tables que é29 ne pouvait pas connaître, parce qu'elles parlent de PÉDAGOGIE :
-- ce que l'élève aime, ce qu'on lui a déjà dit, ce qui a été utile, et le
-- vocabulaire d'explications déjà produites qu'on peut resservir.
--
-- LA RÈGLE QUI COMMANDE TOUT LE LOT — R-1, ANTI-TRICHE
-- ---------------------------------------------------------------------------
-- Le tuteur n'existe qu'APRÈS une réponse soumise. Ce n'est pas une préférence
-- de produit : c'est ce qui rend légitime de mettre la clé de réponse et
-- l'explication canonique dans le contexte du modèle (R-2/R-16). Tant qu'une
-- question n'est pas soumise, le modèle ne doit pas pouvoir divulguer ce qu'il
-- ne connaît pas. La porte est en SQL (`can_use_tutor`, migration suivante),
-- l'écran ne fait que la refléter.
--
-- AGENTS.md : chaque table neuve embarque ses propres GRANT explicites.

-- ---------------------------------------------------------------------------
-- 1. Les préférences d'accompagnement — la seule donnée NEUVE sur l'élève.
-- ---------------------------------------------------------------------------
-- R-14 : zéro PII nouvelle. Des centres d'intérêt choisis dans une liste fermée
-- (« foot », « animaux »…) ne disent rien d'identifiant ; ils servent à ancrer
-- une analogie. La verbosité est un réglage de confort, pas un profil.
CREATE TABLE IF NOT EXISTS public.tutor_prefs (
  user_id    UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  -- Vocabulaire fermé côté application (`TUTOR_INTERESTS`). La cardinalité est
  -- bornée ICI et pas seulement dans l'écran : trois centres d'intérêt tiennent
  -- dans un prompt, trente le noieraient.
  interests  TEXT[] NOT NULL DEFAULT '{}' CHECK (cardinality(interests) <= 3),
  verbosity  TEXT NOT NULL DEFAULT 'normale' CHECK (verbosity IN ('courte', 'normale')),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.tutor_prefs IS
  'Préférences d''accompagnement du tuteur (étude 11 lot 1, §2.2). Liste fermée, zéro PII : ce que l''élève aime, pas qui il est. Écriture via set_tutor_prefs().';

ALTER TABLE public.tutor_prefs ENABLE ROW LEVEL SECURITY;

-- Lecture par le propriétaire seul. L'écriture passe par la RPC : le motif
-- `20260610160000_revoke_gameplay_table_writes` vaut ici comme ailleurs.
CREATE POLICY tutor_prefs_select_own ON public.tutor_prefs
  FOR SELECT TO authenticated
  USING (user_id = (SELECT auth.uid()));

REVOKE ALL ON public.tutor_prefs FROM anon, authenticated;
GRANT SELECT ON public.tutor_prefs TO authenticated;
GRANT ALL ON public.tutor_prefs TO service_role;

-- ---------------------------------------------------------------------------
-- 2. Le fil — ce que le tuteur a déjà dit à CET élève sur CETTE question.
-- ---------------------------------------------------------------------------
-- Deux colonnes portent à elles seules la pédagogie du lot : `variant_served`
-- (R-7, l'escalier de registres) et `context_snapshot` (l'auditabilité — on sait
-- ce que le tuteur « savait » quand il a répondu).
CREATE TABLE IF NOT EXISTS public.tutor_threads (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  -- `chapter` est réservé au chat du lot 3. Le lot 1 n'ouvre que `question` —
  -- mais le vocabulaire est posé une fois, pour que le lot 3 n'ait pas à
  -- migrer une colonne en production.
  scope            TEXT NOT NULL CHECK (scope IN ('question', 'chapter')),
  question_id      UUID REFERENCES public.questions(id) ON DELETE SET NULL,
  chapter_id       UUID REFERENCES public.chapters(id) ON DELETE SET NULL,
  attempt_id       UUID REFERENCES public.attempts(id) ON DELETE SET NULL,
  -- R-3 : la langue de SORTIE est celle de la matière, pas celle de l'interface.
  lang             TEXT NOT NULL CHECK (lang IN ('fr', 'en', 'ar')),
  -- R-4 : dérivée de la classe, jamais collectée (R-14).
  age_band         TEXT NOT NULL CHECK (age_band IN ('6-8', '9-11', '12-14', '15-19')),
  status           TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'closed')),
  -- R-8, lot 4. La colonne existe dès maintenant parce que le lot 1 en écrit
  -- déjà la valeur de départ, et qu'une escalade se lit sur un historique.
  escalation_level INT NOT NULL DEFAULT 0 CHECK (escalation_level BETWEEN 0 AND 4),
  -- R-7 : combien de registres ont déjà été servis (0 = aucun, 3 = épuisés).
  -- C'est le compteur qui garantit qu'« Explique autrement » ne redit jamais la
  -- même chose — la garantie est en base, pas dans la mémoire d'un composant.
  variant_served   INT NOT NULL DEFAULT 0 CHECK (variant_served BETWEEN 0 AND 3),
  resolved         BOOLEAN,
  -- Append-only : [{role, kind, content, at}]. Écrit par append_tutor_message().
  messages         JSONB NOT NULL DEFAULT '[]' CHECK (jsonb_typeof(messages) = 'array'),
  context_snapshot JSONB,
  summary          TEXT,
  tokens_in        BIGINT NOT NULL DEFAULT 0 CHECK (tokens_in >= 0),
  tokens_out       BIGINT NOT NULL DEFAULT 0 CHECK (tokens_out >= 0),
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  -- Un fil de question SANS question serait un fil sur rien ; un fil de chapitre
  -- AVEC une question mentirait sur sa portée.
  CONSTRAINT tutor_threads_scope_question CHECK ((scope = 'question') = (question_id IS NOT NULL))
);

COMMENT ON TABLE public.tutor_threads IS
  'Fils du tuteur « El Ostedh » (étude 11 lot 1). `variant_served` porte l''escalier de reformulation R-7 ; `context_snapshot` rend auditable ce que le tuteur savait. Purge à 6 mois (R-14).';
COMMENT ON COLUMN public.tutor_threads.variant_served IS
  'R-7 : nombre de registres déjà servis (concret → visuel-verbal → formel). Le garant est en base : deux onglets ouverts ne peuvent pas servir deux fois le même.';

CREATE INDEX IF NOT EXISTS idx_tutor_threads_user_updated
  ON public.tutor_threads (user_id, updated_at DESC);

-- Un seul fil actif par (élève, question) : rouvrir l'écran de correction doit
-- retrouver la conversation, pas en démarrer une seconde.
CREATE UNIQUE INDEX IF NOT EXISTS uq_tutor_thread_active_question
  ON public.tutor_threads (user_id, question_id)
  WHERE status = 'active' AND scope = 'question';
CREATE UNIQUE INDEX IF NOT EXISTS uq_tutor_thread_active_chapter
  ON public.tutor_threads (user_id, chapter_id)
  WHERE status = 'active' AND scope = 'chapter';

ALTER TABLE public.tutor_threads ENABLE ROW LEVEL SECURITY;

CREATE POLICY tutor_threads_select_own ON public.tutor_threads
  FOR SELECT TO authenticated
  USING (user_id = (SELECT auth.uid()) OR public.is_admin());

REVOKE ALL ON public.tutor_threads FROM anon, authenticated;
GRANT SELECT ON public.tutor_threads TO authenticated;
GRANT ALL ON public.tutor_threads TO service_role;

-- ---------------------------------------------------------------------------
-- 3. Le cache mutualisé d'explications — R-15.2 / D-9.
-- ---------------------------------------------------------------------------
-- C'est la pièce que l'étude 29 a laissée à ce lot en toutes lettres : elle a
-- livré `AI_CURATED_MODELS`, la CONDITION D'ENTRÉE du pot commun, et s'est
-- arrêtée là parce que la surface `explain` n'existait pas encore.
--
-- La règle vaut d'être dite deux fois. Une explication produite par un modèle
-- de la liste curée peut être resservie à N'IMPORTE QUEL élève qui tombe sur la
-- même question, la même erreur, la même langue et la même bande d'âge — et
-- cette famille-là ne paie rien. Une explication produite par un modèle hors
-- liste est servie à son demandeur et reste PRIVÉE à son payeur : sans cela,
-- la clé la moins chère du parc fixerait la qualité pour tous les enfants.
--
-- `shared` n'est donc pas un réglage : c'est un fait constaté à l'écriture,
-- que le serveur calcule et que personne ne peut retourner depuis un écran.
CREATE TABLE IF NOT EXISTS public.tutor_explanations (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id   UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
  -- L'erreur diagnostiquée. NULL = la question n'est pas taguée : l'explication
  -- porte alors sur la question seule, et le cache le sait.
  misconception TEXT,
  lang          TEXT NOT NULL CHECK (lang IN ('fr', 'en', 'ar')),
  age_band      TEXT NOT NULL CHECK (age_band IN ('6-8', '9-11', '12-14', '15-19')),
  -- R-7 : trois registres, trois entrées de cache distinctes pour la même
  -- question. « Explique autrement » doit pouvoir tirer du cache lui aussi.
  variant       TEXT NOT NULL CHECK (variant IN ('concret', 'visuel-verbal', 'formel')),
  body          TEXT NOT NULL CHECK (length(body) BETWEEN 1 AND 4000),
  model         TEXT NOT NULL,
  -- R-15.2 : entrée dans le pot commun. Calculé à l'écriture contre
  -- `AI_CURATED_MODELS`, jamais transmis par le client.
  shared        BOOLEAN NOT NULL DEFAULT false,
  -- Le payeur de la génération. Sert à deux choses : servir une explication
  -- privée à sa propre famille, et savoir qui a financé le pot commun.
  owner_user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  serve_count   INT NOT NULL DEFAULT 0 CHECK (serve_count >= 0),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.tutor_explanations IS
  'Cache d''explications du tuteur (étude 11 lot 1, R-15.2 / D-9). `shared = true` ⇒ pot commun, resservi à tous ; `false` ⇒ privé au payeur. La distinction se calcule contre AI_CURATED_MODELS à l''écriture.';
COMMENT ON COLUMN public.tutor_explanations.shared IS
  'R-15.2 : une explication d''un modèle hors liste curée reste privée à son payeur — sinon la clé la moins chère du parc fixerait la qualité pour tous.';

-- La requête du cache : (question, erreur, langue, âge, registre), le plus
-- souvent servi d'abord. `misconception` étant NULLable, l'égalité passe par
-- `IS NOT DISTINCT FROM` côté RPC — l'index reste utile pour le préfixe.
CREATE INDEX IF NOT EXISTS idx_tutor_explanations_lookup
  ON public.tutor_explanations (question_id, lang, age_band, variant);

ALTER TABLE public.tutor_explanations ENABLE ROW LEVEL SECURITY;

-- ⚠️ Aucun droit client, aucune policy de lecture. Le corps d'une explication
-- porte la correction d'une question — la servir par PostgREST à qui n'a pas
-- soumis sa réponse contournerait R-1 par la porte de derrière. La lecture
-- passe exclusivement par find_tutor_explanation(), qui vérifie la tentative.
REVOKE ALL ON public.tutor_explanations FROM anon, authenticated;
GRANT ALL ON public.tutor_explanations TO service_role;

-- ---------------------------------------------------------------------------
-- 4. Le retour de l'élève — R-17.
-- ---------------------------------------------------------------------------
-- Un 👎 n'est pas une statistique : c'est la seule mesure de qualité que ce lot
-- produise, et la console qualité de é29 lot 5 la lit déjà pour `ai_feedback`.
-- On garde le même geste, sur l'objet de é11 : le message d'un fil.
CREATE TABLE IF NOT EXISTS public.tutor_feedback (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  thread_id  UUID NOT NULL REFERENCES public.tutor_threads(id) ON DELETE CASCADE,
  user_id    UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  -- Rang du message dans `messages` — pas son texte : le verbatim vit déjà dans
  -- le fil, le dupliquer ici doublerait la surface à purger.
  message_ix INT NOT NULL CHECK (message_ix >= 0),
  rating     SMALLINT NOT NULL CHECK (rating IN (-1, 1)),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  -- Un avis par message : le 👎 puis le 👍 se corrigent, ils ne s'empilent pas.
  UNIQUE (thread_id, message_ix, user_id)
);

COMMENT ON TABLE public.tutor_feedback IS
  'Avis 👍/👎 sur un message du tuteur (étude 11 lot 1, R-17). Porte un RANG, jamais le verbatim — celui-ci vit dans tutor_threads.messages et se purge avec lui.';

CREATE INDEX IF NOT EXISTS idx_tutor_feedback_recent
  ON public.tutor_feedback (created_at DESC)
  WHERE rating = -1;

ALTER TABLE public.tutor_feedback ENABLE ROW LEVEL SECURITY;

CREATE POLICY tutor_feedback_select_own ON public.tutor_feedback
  FOR SELECT TO authenticated
  USING (user_id = (SELECT auth.uid()) OR public.is_admin());

REVOKE ALL ON public.tutor_feedback FROM anon, authenticated;
GRANT SELECT ON public.tutor_feedback TO authenticated;
GRANT ALL ON public.tutor_feedback TO service_role;
