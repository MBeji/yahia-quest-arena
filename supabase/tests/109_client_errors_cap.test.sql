-- =========================================================
-- client_errors — le plafond durable de la seule écriture non authentifiée
-- (migration 20261112110000_client_errors_durable_cap.sql)
-- ---------------------------------------------------------
-- La route `/api/client-log` insère avec la clé service, sans jeton. Ce qui coûte si ça
-- tombe : une boucle remplit le disque et la base passe en lecture seule.
--   ⭐ au-delà de 30 lignes par minute, les suivantes sont ignorées SANS erreur ;
--   ⭐ au-delà de 1 000 lignes par jour, de même ;
--   ⭐ la fenêtre glisse : une minute plus tard, la télémétrie repasse.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(6);

DELETE FROM public.client_errors;

SELECT has_trigger('public', 'client_errors', 'client_errors_cap',
  'client_errors porte son trigger de plafond');

-- La route écrit avec la clé service : c'est ce rôle qu'on borne.
SET LOCAL ROLE service_role;

SELECT lives_ok(
  $$INSERT INTO public.client_errors (stage) SELECT 'f109' FROM generate_series(1, 45)$$,
  '⭐ 45 insertions d''un coup : aucune erreur (la route ne doit jamais casser)'
);
RESET ROLE;
SELECT is(
  (SELECT count(*)::int FROM public.client_errors WHERE stage = 'f109'),
  30,
  '⭐ …mais 30 lignes seulement sont écrites : le plafond par minute tient'
);

-- La fenêtre glisse.
UPDATE public.client_errors SET created_at = created_at - interval '2 minutes';
SET LOCAL ROLE service_role;
INSERT INTO public.client_errors (stage) VALUES ('f109-apres');
RESET ROLE;
SELECT is(
  (SELECT count(*)::int FROM public.client_errors WHERE stage = 'f109-apres'),
  1,
  '⭐ deux minutes plus tard, une nouvelle ligne passe'
);

-- Plafond par jour : 1 000 lignes étalées sur les dernières heures, hors de la minute.
DELETE FROM public.client_errors;
ALTER TABLE public.client_errors DISABLE TRIGGER client_errors_cap;
INSERT INTO public.client_errors (stage, created_at)
SELECT 'f109-jour', clock_timestamp() - interval '2 hours' FROM generate_series(1, 1000);
ALTER TABLE public.client_errors ENABLE TRIGGER client_errors_cap;
SET LOCAL ROLE service_role;
INSERT INTO public.client_errors (stage) VALUES ('f109-de-trop');
RESET ROLE;
SELECT is(
  (SELECT count(*)::int FROM public.client_errors WHERE stage = 'f109-de-trop'),
  0,
  '⭐ 1 000 lignes dans la journée : la 1 001e est ignorée'
);

-- Une journée plus tard, la télémétrie repasse.
UPDATE public.client_errors SET created_at = created_at - interval '1 day';
SET LOCAL ROLE service_role;
INSERT INTO public.client_errors (stage) VALUES ('f109-lendemain');
RESET ROLE;
SELECT is(
  (SELECT count(*)::int FROM public.client_errors WHERE stage = 'f109-lendemain'),
  1,
  'le lendemain, une ligne passe de nouveau'
);

SELECT * FROM finish();
ROLLBACK;
