-- Étude 29 — lot 2 : LE COFFRE. Une clé d'API d'un tiers, stockée pour le compte
-- d'une famille, et exécutée pour un mineur.
--
-- L'INVARIANT CENTRAL, ET IL TIENT EN UNE LIGNE
-- ---------------------------------------------------------------------------
--     REVOKE ALL ON public.ai_credentials FROM anon, authenticated;
--
-- Aucun rôle client n'a le moindre droit sur cette table. PostgREST ne peut pas
-- l'atteindre, quelle que soit la policy — et c'est justement le point : une
-- erreur de RLS ne suffit donc pas à produire une fuite. Il faudrait AUSSI une
-- erreur de grant, ET la clé de chiffrement, qui n'est pas dans cette base.
--
-- Il n'y a délibérément AUCUNE policy pour anon/authenticated : il n'y a rien à
-- autoriser. Le test pgTAP S62 vérifie cette absence — l'ajouter serait le genre
-- de « petite ouverture pour le support » qui produit les fuites (D-3).
--
-- CHIFFREMENT ENVELOPPE : LE COFFRE ET SA CLÉ NE VIVENT PAS AU MÊME ENDROIT
-- ---------------------------------------------------------------------------
-- `secret_enc` est un chiffré AES-256-GCM produit par Node (`node:crypto`) ; la
-- clé maîtresse (`AI_KEY_ENC_KEY`) vit dans l'environnement Vercel, JAMAIS en
-- base. Un dump volé — y compris une sauvegarde de `db-backup.yml` — ne rend
-- rien d'exploitable. C'est le D-5 : ni `pgcrypto` (la clé finirait dans une
-- fonction SQL, donc dans le dump), ni `pgsodium`, ni un KMS tiers.
--
-- Conséquence : aucune fonction de ce fichier ne déchiffre quoi que ce soit.
-- Le SQL décide QUI a le droit ; Node déchiffre. Les deux moitiés doivent tomber
-- d'accord, et un bug d'un seul côté ne suffit pas (§3.1).
--
-- CE QUI N'EXISTE PAS ICI, ET N'EXISTERA PAS
-- ---------------------------------------------------------------------------
-- Aucune fonction ne rend `secret_enc`. Pas d'endpoint « afficher », pas
-- d'export, pas de déchiffrement admin « pour dépanner » (D-3). Le dépannage se
-- fait avec `last4` et un code d'erreur de l'annexe C — et si un besoin de
-- support semble exiger davantage, c'est le besoin qu'il faut redéfinir.
--
-- AGENTS.md : une table neuve embarque ses propres GRANT explicites.

-- ---------------------------------------------------------------------------
-- 1. Le coffre — une clé par compte (D-10).
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.ai_credentials (
  -- Une seule clé par porteur en v1 : la clé primaire EST le propriétaire.
  -- Depuis Q-2, ce porteur peut être n'importe quel compte authentifié — un
  -- élève qui porte sa propre clé compris.
  owner_user_id   UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  provider        TEXT NOT NULL CHECK (provider IN ('anthropic', 'openai_compatible')),
  -- NULL sauf `openai_compatible`. Validée par les sept conditions de R-6, à
  -- l'enregistrement ET à chaque appel — ici on ne garde que la forme minimale
  -- que la base peut juger seule : https, et pas de littéral IPv4 évident. La
  -- résolution DNS et l'épinglage d'IP appartiennent à Node (egress.server.ts) :
  -- une base de données n'a pas à résoudre des noms.
  base_url        TEXT,
  model_fast      TEXT NOT NULL,
  model_rich      TEXT NOT NULL,
  -- iv (12) ‖ tag (16) ‖ ciphertext — UN seul champ, pas trois : impossible d'en
  -- désynchroniser un (§3.2).
  secret_enc      BYTEA NOT NULL,
  -- Version du SCHÉMA de chiffrement, pas de la clé maîtresse. Elle entre dans
  -- l'AAD, donc elle doit rester stable pendant une rotation de KEK — sinon la
  -- lecture « essaie la courante puis la précédente » ne pourrait pas marcher.
  enc_version     SMALLINT NOT NULL DEFAULT 1,
  -- HMAC de la clé brute sous une sous-clé dédiée. Permet de reconnaître une clé
  -- DÉJÀ CONNUE (même clé recollée, clé partagée entre deux comptes) sans
  -- pouvoir remonter à la clé.
  key_fingerprint TEXT NOT NULL,
  -- Les 4 derniers caractères — le SEUL fragment qui existe en clair (R-4).
  last4           TEXT NOT NULL CHECK (char_length(last4) = 4),
  status          TEXT NOT NULL DEFAULT 'unverified'
                    CHECK (status IN ('unverified', 'active', 'invalid', 'revoked')),
  -- Code STABLE de l'annexe C. Jamais le corps d'erreur du fournisseur (R-5) :
  -- certains y répètent un fragment de clé.
  last_error_code TEXT,
  verified_at     TIMESTAMPTZ,
  last_used_at    TIMESTAMPTZ,
  -- Plafonds monétaires (R-11). Défauts arbitrés Q-6 : 2 $/jour, 20 $/mois.
  -- Les bornes dures sont ici ET dans `src/shared/constants/ai.ts` : la base est
  -- le juge, la constante est ce que l'écran propose.
  daily_budget_usd   NUMERIC(6, 2) NOT NULL DEFAULT 2
                       CHECK (daily_budget_usd > 0 AND daily_budget_usd <= 50),
  monthly_budget_usd NUMERIC(7, 2) NOT NULL DEFAULT 20
                       CHECK (monthly_budget_usd > 0 AND monthly_budget_usd <= 500),
  -- R-18bis : la double résolution de la Forge est ACTIVE par défaut, et
  -- désactivable par le porteur (Q-7, contre la recommandation de l'architecte).
  -- Même coupée, un échantillon de 20 % reste vérifié — sans lui on perdrait le
  -- taux de rebut, donc l'avertissement R-19.
  double_solve    BOOLEAN NOT NULL DEFAULT true,
  -- R-20 : consentement VERSIONNÉ, préalable, révocable. Un changement de
  -- fournisseur OU de version du texte le redemande.
  consent_version TEXT NOT NULL,
  consent_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  -- Une base_url n'a de sens que pour le protocole compatible : chez Anthropic
  -- l'adresse est fixe, ce qui rend sa surface SSRF nulle (§3.5).
  CONSTRAINT ai_credentials_base_url_scope
    CHECK ((provider = 'openai_compatible') OR base_url IS NULL)
);

COMMENT ON TABLE public.ai_credentials IS
  'Coffre des clés d''API apportées par les familles (étude 29 lot 2). Chiffrement enveloppe : le chiffré est ici, la clé du coffre est dans l''environnement. AUCUN droit client — REVOKE ALL, aucune policy. Aucune fonction ne rend le secret (D-3).';
COMMENT ON COLUMN public.ai_credentials.secret_enc IS
  'iv (12 o) ‖ tag GCM (16 o) ‖ ciphertext. Déchiffrable UNIQUEMENT en Node avec AI_KEY_ENC_KEY, jamais en SQL.';
COMMENT ON COLUMN public.ai_credentials.key_fingerprint IS
  'HMAC-SHA256 tronqué de la clé brute : reconnaît une clé déjà connue sans permettre de la reconstituer.';
COMMENT ON COLUMN public.ai_credentials.last4 IS
  'R-4 : le seul fragment de clé qui existe en clair. La console affiche « sk-…4f2a » et rien d''autre.';

-- Détecter une clé partagée entre deux comptes, ou recollée après révocation.
CREATE INDEX IF NOT EXISTS idx_ai_credentials_fingerprint
  ON public.ai_credentials (key_fingerprint);

ALTER TABLE public.ai_credentials ENABLE ROW LEVEL SECURITY;

-- ⚠️ L'INVARIANT. Ne pas ajouter de GRANT ici, ni de policy : le lot 2 vaut
-- exactement ce que vaut cette ligne (pgTAP S62 la garde).
REVOKE ALL ON public.ai_credentials FROM anon, authenticated;
GRANT ALL ON public.ai_credentials TO service_role;

-- ---------------------------------------------------------------------------
-- 2. Écriture — un seul appel, atomique.
-- ---------------------------------------------------------------------------
-- ÉCART ASSUMÉ vs §3.4 : l'étude décrivait `set_ai_credential_meta`, « écrit
-- tout sauf le secret », le `bytea` étant posé par le même appel Node. Comme
-- `secret_enc` est NOT NULL, ce découpage exigerait soit une colonne nullable,
-- soit deux écritures — donc une fenêtre pendant laquelle une ligne existe sans
-- son secret, ou un `status='active'` sans clé derrière. La fonction reçoit donc
-- le CHIFFRÉ (opaque : le SQL ne voit toujours pas la clé en clair, §3.1) et
-- écrit la ligne d'un bloc.
CREATE OR REPLACE FUNCTION public.set_ai_credential(
  p_owner UUID,
  p_provider TEXT,
  p_base_url TEXT,
  p_model_fast TEXT,
  p_model_rich TEXT,
  p_secret_enc BYTEA,
  p_enc_version SMALLINT,
  p_key_fingerprint TEXT,
  p_last4 TEXT,
  p_daily_budget_usd NUMERIC,
  p_monthly_budget_usd NUMERIC,
  p_consent_version TEXT,
  p_double_solve BOOLEAN DEFAULT true,
  p_status TEXT DEFAULT 'active'
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF p_owner IS NULL THEN
    RAISE EXCEPTION 'AI_CRED_NO_OWNER';
  END IF;

  -- R-2 (réécrite par Q-2) : AUCUN filtre de rôle. N'importe quel compte
  -- authentifié peut attacher une clé — un `student` comme un `parent`. La
  -- contrepartie n'est pas un CHECK mais un écran : niveau scolaire lu,
  -- confirmation d'un adulte exigée sous la 4ᵉ année secondaire (R-2a), et un
  -- consentement versionné signé par celui qui attache (R-20). Ce que la base
  -- peut garantir, elle : qu'aucune ligne n'existe sans ce consentement.
  IF p_consent_version IS NULL OR btrim(p_consent_version) = '' THEN
    RAISE EXCEPTION 'AI_CRED_NO_CONSENT';
  END IF;

  -- R-6, la part que la base peut juger seule. Le reste — résolution DNS, plages
  -- privées, épinglage d'IP, redirections — est en Node, à CHAQUE appel.
  IF p_provider = 'openai_compatible' THEN
    IF p_base_url IS NULL OR p_base_url !~* '^https://' THEN
      RAISE EXCEPTION 'AI_HOST_NOT_ALLOWED';
    END IF;
  ELSIF p_base_url IS NOT NULL THEN
    RAISE EXCEPTION 'AI_HOST_NOT_ALLOWED';
  END IF;

  INSERT INTO public.ai_credentials AS c (
    owner_user_id, provider, base_url, model_fast, model_rich,
    secret_enc, enc_version, key_fingerprint, last4,
    daily_budget_usd, monthly_budget_usd, double_solve,
    consent_version, consent_at, status, verified_at
  )
  VALUES (
    p_owner, p_provider, p_base_url, p_model_fast, p_model_rich,
    p_secret_enc, COALESCE(p_enc_version, 1), p_key_fingerprint, p_last4,
    p_daily_budget_usd, p_monthly_budget_usd, COALESCE(p_double_solve, true),
    p_consent_version, now(), p_status,
    CASE WHEN p_status = 'active' THEN now() ELSE NULL END
  )
  -- R-4 : « une clé enregistrée ne peut être que REMPLACÉE ». Le conflit sur le
  -- propriétaire écrase donc tout, y compris le chiffré : il n'y a pas de
  -- « modifier partiellement ma clé ».
  ON CONFLICT (owner_user_id) DO UPDATE SET
    provider           = EXCLUDED.provider,
    base_url           = EXCLUDED.base_url,
    model_fast         = EXCLUDED.model_fast,
    model_rich         = EXCLUDED.model_rich,
    secret_enc         = EXCLUDED.secret_enc,
    enc_version        = EXCLUDED.enc_version,
    key_fingerprint    = EXCLUDED.key_fingerprint,
    last4              = EXCLUDED.last4,
    daily_budget_usd   = EXCLUDED.daily_budget_usd,
    monthly_budget_usd = EXCLUDED.monthly_budget_usd,
    double_solve       = EXCLUDED.double_solve,
    consent_version    = EXCLUDED.consent_version,
    consent_at         = EXCLUDED.consent_at,
    status             = EXCLUDED.status,
    verified_at        = EXCLUDED.verified_at,
    last_error_code    = NULL,
    updated_at         = now()
  WHERE c.owner_user_id = p_owner;
END;
$$;

COMMENT ON FUNCTION public.set_ai_credential(UUID, TEXT, TEXT, TEXT, TEXT, BYTEA, SMALLINT, TEXT, TEXT, NUMERIC, NUMERIC, TEXT, BOOLEAN, TEXT) IS
  'Écrit (ou remplace) le crédential d''un porteur. Reçoit le secret DÉJÀ CHIFFRÉ : le SQL ne voit jamais la clé en clair. Exige un consentement versionné (R-20).';

REVOKE EXECUTE ON FUNCTION public.set_ai_credential(UUID, TEXT, TEXT, TEXT, TEXT, BYTEA, SMALLINT, TEXT, TEXT, NUMERIC, NUMERIC, TEXT, BOOLEAN, TEXT)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. Mise à jour d'état — après un appel, ou après une rotation de KEK.
-- ---------------------------------------------------------------------------
-- L'appelant est l'orchestrateur, en service_role. Un client ne déclare pas que
-- sa clé est redevenue valide.
CREATE OR REPLACE FUNCTION public.set_ai_credential_state(
  p_owner UUID,
  p_status TEXT,
  p_error_code TEXT DEFAULT NULL,
  p_touch_used BOOLEAN DEFAULT false
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.ai_credentials
     SET status          = p_status,
         last_error_code = p_error_code,
         verified_at     = CASE WHEN p_status = 'active' THEN now() ELSE verified_at END,
         last_used_at    = CASE WHEN p_touch_used THEN now() ELSE last_used_at END,
         updated_at      = now()
   WHERE owner_user_id = p_owner;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.set_ai_credential_state(UUID, TEXT, TEXT, BOOLEAN)
  FROM PUBLIC, anon, authenticated;

-- Rotation PARESSEUSE de la clé maîtresse (§3.2) : quand une lecture réussit
-- avec `AI_KEY_ENC_KEY_PREVIOUS`, Node ré-écrit le chiffré sous la clé courante,
-- au passage. Pas de migration de données, pas de fenêtre de panne.
CREATE OR REPLACE FUNCTION public.rewrite_ai_credential_secret(
  p_owner UUID,
  p_secret_enc BYTEA,
  p_enc_version SMALLINT
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.ai_credentials
     SET secret_enc  = p_secret_enc,
         enc_version = COALESCE(p_enc_version, 1),
         updated_at  = now()
   WHERE owner_user_id = p_owner;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.rewrite_ai_credential_secret(UUID, BYTEA, SMALLINT)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. Révocation — US-8 : la ligne est SUPPRIMÉE, pas marquée.
-- ---------------------------------------------------------------------------
-- « Un bouton, un effet immédiat. » Marquer `status='revoked'` laisserait le
-- chiffré en base : le seul geste qui vaut est de le faire disparaître. La
-- dépense historique reste (`ai_usage_events` n'a pas de FK vers ici).
--
-- Ce que nous NE POUVONS PAS faire, et que l'écran doit rappeler : révoquer la
-- clé chez le FOURNISSEUR. Supprimer notre copie n'invalide pas la clé.
--
-- Le lot 3 remplacera cette fonction pour éteindre aussi les activations par
-- élève (`ai_student_access`) — la table n'existe pas encore.
CREATE OR REPLACE FUNCTION public.revoke_ai_credential()
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_deleted INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  DELETE FROM public.ai_credentials WHERE owner_user_id = v_user;
  GET DIAGNOSTICS v_deleted = ROW_COUNT;
  RETURN v_deleted > 0;
END;
$$;

COMMENT ON FUNCTION public.revoke_ai_credential() IS
  'US-8 : supprime la ligne du coffre de l''appelant (jamais un simple marquage). Ne révoque PAS la clé chez le fournisseur — nous ne pouvons pas le faire à sa place.';

REVOKE EXECUTE ON FUNCTION public.revoke_ai_credential() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.revoke_ai_credential() TO authenticated;

-- ---------------------------------------------------------------------------
-- 5. Lecture — ce que la console affiche, et RIEN de plus.
-- ---------------------------------------------------------------------------
-- La liste des colonnes rendues est la spécification de R-4 : `secret_enc` et
-- `key_fingerprint` n'y sont pas, et ne doivent jamais y entrer. C'est la seule
-- porte de lecture ouverte à un client, et elle est bornée à SA propre ligne.
CREATE OR REPLACE FUNCTION public.get_ai_credential_status()
RETURNS TABLE (
  provider TEXT,
  base_url TEXT,
  model_fast TEXT,
  model_rich TEXT,
  last4 TEXT,
  status TEXT,
  last_error_code TEXT,
  verified_at TIMESTAMPTZ,
  last_used_at TIMESTAMPTZ,
  daily_budget_usd NUMERIC,
  monthly_budget_usd NUMERIC,
  double_solve BOOLEAN,
  consent_version TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT c.provider, c.base_url, c.model_fast, c.model_rich, c.last4, c.status,
         c.last_error_code, c.verified_at, c.last_used_at,
         c.daily_budget_usd, c.monthly_budget_usd, c.double_solve, c.consent_version
    FROM public.ai_credentials c
   WHERE c.owner_user_id = v_user;
END;
$$;

COMMENT ON FUNCTION public.get_ai_credential_status() IS
  'R-4 : l''état de SA propre clé, sans le secret ni son empreinte. `last4` est le seul fragment en clair. Aucune autre porte de lecture n''existe.';

REVOKE EXECUTE ON FUNCTION public.get_ai_credential_status() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_ai_credential_status() TO authenticated;

-- ---------------------------------------------------------------------------
-- 6. Le niveau scolaire du compte — la donnée de R-2a.
-- ---------------------------------------------------------------------------
-- « L'écran de saisie lit le niveau scolaire du compte (`grades`, déjà en base)
-- et, sous la 4ᵉ année secondaire, exige une confirmation explicite qu'un adulte
-- responsable est présent — un signal que l'app possède, au lieu d'un "je
-- certifie être majeur" que personne ne lit. »
--
-- Rend NULL quand le compte n'a pas de niveau : parcours libre, compte ancien,
-- compte parent. L'appelant traite NULL comme MINEUR — consigne explicite du §7.
CREATE OR REPLACE FUNCTION public.get_my_grade_rank()
RETURNS INT
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT g.display_order
    FROM public.profiles p
    JOIN public.parcours pc ON pc.id = p.current_parcours_id
    JOIN public.grades g ON g.id = pc.grade_id
   WHERE p.id = auth.uid();
$$;

COMMENT ON FUNCTION public.get_my_grade_rank() IS
  'R-2a : le rang du niveau scolaire de l''appelant (1 = 1ère année de base … 13 = Bac). NULL = niveau inconnu, à traiter comme mineur.';

REVOKE EXECUTE ON FUNCTION public.get_my_grade_rank() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_my_grade_rank() TO authenticated;

-- ---------------------------------------------------------------------------
-- 7. Réglages sans re-saisie — plafonds et double résolution.
-- ---------------------------------------------------------------------------
-- Changer un plafond ne doit pas obliger à recoller sa clé. Ces trois colonnes
-- n'ont aucune règle métier propre — leurs bornes sont des CHECK de la table —
-- donc la fonction se contente d'être self-scoped : elle n'écrit jamais que la
-- ligne de son appelant, ce qu'une écriture directe depuis Node ne garantirait
-- pas aussi lisiblement.
--
-- R-18bis.1 : le défaut de `double_solve` est `true`, et le COUPER est un geste
-- délibéré. La base ne juge pas ce geste — elle l'enregistre ; c'est l'écran qui
-- porte l'avertissement (« une correction fausse ne se voit pas, elle s'apprend »).
CREATE OR REPLACE FUNCTION public.set_ai_preferences(
  p_daily_budget_usd NUMERIC,
  p_monthly_budget_usd NUMERIC,
  p_double_solve BOOLEAN
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_updated INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  UPDATE public.ai_credentials
     SET daily_budget_usd   = p_daily_budget_usd,
         monthly_budget_usd = p_monthly_budget_usd,
         double_solve       = COALESCE(p_double_solve, true),
         updated_at         = now()
   WHERE owner_user_id = v_user;

  GET DIAGNOSTICS v_updated = ROW_COUNT;
  RETURN v_updated > 0;
END;
$$;

COMMENT ON FUNCTION public.set_ai_preferences(NUMERIC, NUMERIC, BOOLEAN) IS
  'Plafonds monétaires (R-11) et double résolution (R-18bis) du porteur appelant. Self-scoped : n''écrit jamais la ligne d''un autre.';

REVOKE EXECUTE ON FUNCTION public.set_ai_preferences(NUMERIC, NUMERIC, BOOLEAN) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_ai_preferences(NUMERIC, NUMERIC, BOOLEAN) TO authenticated;
