-- =========================================================
-- client_errors : un plafond durable sur la seule écriture NON authentifiée du produit
-- ---------------------------------------------------------
-- Constat (revue de sécurité du 2026-11-12). `/api/client-log` n'exige aucun jeton — c'est
-- voulu, voir 20260831140000 — et insère avec la clé service jusqu'à 8 ko par requête. Ses
-- seules bornes étaient le garde de rafales de `bot-guard.ts` : 600 requêtes/min PAR IP et
-- PAR INSTANCE Vercel, en mémoire. Aucune purge, aucun plafond en base : une boucle depuis
-- un seul poste écrit ~290 Mo par heure, et une base Supabase dont le disque est plein passe
-- en lecture seule — plus aucun élève ne peut enregistrer une tentative.
--
-- La borne vit ici, dans un trigger, parce que c'est le seul endroit que toutes les
-- instances partagent :
--   · 30 lignes par minute, 1 000 par jour, 20 000 au total (≈ 160 Mo au pire) ;
--   · au-delà, la ligne est IGNORÉE en silence (`RETURN NULL`) — la route ne rend jamais
--     d'erreur, et une télémétrie saturée ne doit rien casser ;
--   · purge opportuniste des lignes de plus de 30 jours.
-- Le volume légitime est de quelques lignes par jour : ces seuils ne le touchent pas.
-- ADDITIVE : une fonction, un trigger.
-- =========================================================

CREATE OR REPLACE FUNCTION public.client_errors_enforce_cap()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  v_now TIMESTAMPTZ := clock_timestamp();
BEGIN
  IF random() < 0.02 THEN
    DELETE FROM public.client_errors WHERE created_at < v_now - interval '30 days';
  END IF;

  IF (SELECT count(*) FROM public.client_errors
       WHERE created_at > v_now - interval '1 minute') >= 30 THEN
    RETURN NULL;
  END IF;
  IF (SELECT count(*) FROM public.client_errors
       WHERE created_at > v_now - interval '1 day') >= 1000 THEN
    RETURN NULL;
  END IF;
  IF (SELECT count(*) FROM public.client_errors) >= 20000 THEN
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public.client_errors_enforce_cap() FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE TRIGGER client_errors_cap
  BEFORE INSERT ON public.client_errors
  FOR EACH ROW EXECUTE FUNCTION public.client_errors_enforce_cap();

COMMENT ON FUNCTION public.client_errors_enforce_cap() IS
  'Plafond durable de client_errors (écriture non authentifiée) : 30/min, 1 000/jour, 20 000 au total ; au-delà la ligne est ignorée. Purge > 30 jours.';

-- 20260831140000 n'a pas posé de GRANT pour le rôle qui écrit : en production les
-- privilèges par défaut de Supabase le donnent, une base rejouée à nu ne l'a pas (règle
-- maison : toute table embarque ses GRANT). Idempotent.
GRANT ALL ON public.client_errors TO service_role;
