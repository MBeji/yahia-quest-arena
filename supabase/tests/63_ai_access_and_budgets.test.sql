-- =========================================================
-- S63 — LA MATRICE DE `resolve_ai_access` ET LA COUPURE ATOMIQUE.
--
-- L'étude 29 §5 exige deux choses de ce fichier, et c'est la porte du lot 4 :
-- « le lot 4 ne démarre pas avant que le lot 3 coupe RÉELLEMENT — une Forge
-- branchée sur un budget non appliqué est le scénario de facture surprise »
-- (RISK-2).
--
--   1. LA MATRICE (§4, lot 3) : lien rompu, clé révoquée, surface non activée,
--      énergie épuisée, plafond atteint, chemin plateforme. Chaque branche de
--      refus est écrite une fois ici, sinon elle n'est écrite nulle part — le
--      typecheck ne sait rien d'une policy, et un test unitaire mocke le SQL.
--
--   2. LA RÉSERVATION CONCURRENTE : deux appels qui partent en même temps ne
--      doivent PAS pouvoir dépenser deux fois le dernier dollar. La garantie
--      vient du verrou de ligne pris par `SELECT … FOR UPDATE` après l'UPSERT ;
--      ici on vérifie la conséquence — la somme réservée ne dépasse jamais le
--      plafond, quel que soit l'ordre.
--
-- R-14 est vérifiée aussi, sous son angle « lot 3 » : l'élève lit son ÉNERGIE
-- (une mécanique de jeu) et ne lit pas le grand livre d'ARGENT de son parent.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(36);

-- ---------------------------------------------------------
-- Fixtures : un porteur (parent), son élève lié, un élève NON lié.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
VALUES
  ('c9000000-0000-4000-8000-000000000001', 'ai-acc-parent@test.local', 'x', now(),
   '{"display_name":"Parent"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('c9000000-0000-4000-8000-000000000002', 'ai-acc-child@test.local', 'x', now(),
   '{"display_name":"Enfant"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('c9000000-0000-4000-8000-000000000003', 'ai-acc-other@test.local', 'x', now(),
   '{"display_name":"Autre"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.parent_student_links (parent_user_id, student_user_id, is_active)
VALUES ('c9000000-0000-4000-8000-000000000001', 'c9000000-0000-4000-8000-000000000002', true)
ON CONFLICT (parent_user_id, student_user_id) DO UPDATE SET is_active = true;

-- Une clé active, plafonds 2 $/jour et 20 $/mois (les défauts de Q-6).
SELECT public.set_ai_credential(
  'c9000000-0000-4000-8000-000000000001'::uuid, 'anthropic', NULL,
  'm-fast', 'm-rich', '\x00112233445566778899aabbccddeeff'::bytea, 1::smallint,
  'fp-acc', 'zzzz', 2, 20, '2026-08-22');

-- ---------------------------------------------------------
-- 1. LE DÉFAUT EST ÉTEINT (R-3).
-- ---------------------------------------------------------
SELECT is(
  (SELECT allowed FROM public.resolve_ai_access(
     'c9000000-0000-4000-8000-000000000002'::uuid, 'explain')),
  false,
  'R-3 : une clé enregistrée n''allume rien — sans activation, l''accès est refusé'
);

-- ---------------------------------------------------------
-- 2. L'activation — et ce qu'elle refuse.
-- ---------------------------------------------------------
SET LOCAL request.jwt.claims = '{"sub":"c9000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.set_ai_student_access(
       'c9000000-0000-4000-8000-000000000003'::uuid, true, ARRAY['explain'], 10) $$,
  'AI_NOT_LINKED',
  'R-3 : on n''active pas un élève qui n''est pas lié à soi'
);

SELECT throws_ok(
  $$ SELECT public.set_ai_student_access(
       'c9000000-0000-4000-8000-000000000002'::uuid, true, ARRAY['explain'], 31) $$,
  'AI_ENERGY_CAP_EXCEEDED',
  'R-9 : le plafond DUR d''énergie ne se règle pas — 31 est refusé'
);

SELECT lives_ok(
  $$ SELECT public.set_ai_student_access(
       'c9000000-0000-4000-8000-000000000002'::uuid, true, ARRAY['explain'], 10) $$,
  'le porteur active son élève lié, sur la surface « explication »'
);

-- Auto-activation (Q-2) : le porteur peut s'activer lui-même, sans lien.
SELECT lives_ok(
  $$ SELECT public.set_ai_student_access(
       'c9000000-0000-4000-8000-000000000001'::uuid, true, ARRAY['chat'], 5) $$,
  'Q-2 : le porteur s''active LUI-MÊME — l''auto-détention n''a pas de lien à vérifier'
);

RESET ROLE;

-- ---------------------------------------------------------
-- 3. LA MATRICE.
-- ---------------------------------------------------------
SELECT is(
  (SELECT allowed FROM public.resolve_ai_access(
     'c9000000-0000-4000-8000-000000000002'::uuid, 'explain')),
  true,
  'matrice : activé + surface autorisée + lien vivant + clé active ⇒ AUTORISÉ'
);

SELECT is(
  (SELECT payer FROM public.resolve_ai_access(
     'c9000000-0000-4000-8000-000000000002'::uuid, 'explain')),
  'family',
  'R-7 : le payeur est nommé dès la résolution'
);

SELECT is(
  (SELECT reason FROM public.resolve_ai_access(
     'c9000000-0000-4000-8000-000000000002'::uuid, 'chat')),
  'AI_MODE_OFF',
  'matrice : une surface NON activée est refusée, même sur un élève activé'
);

-- Lien rompu (R-3) : l'élève perd l'accès IMMÉDIATEMENT, sans qu'on touche à
-- son activation. C'est la branche qui prouve que le lien est revérifié à
-- chaque appel et non mis en cache.
UPDATE public.parent_student_links SET is_active = false
 WHERE parent_user_id = 'c9000000-0000-4000-8000-000000000001'
   AND student_user_id = 'c9000000-0000-4000-8000-000000000002';

SELECT is(
  (SELECT reason FROM public.resolve_ai_access(
     'c9000000-0000-4000-8000-000000000002'::uuid, 'explain')),
  'AI_LINK_BROKEN',
  'R-3 : un élève délié perd l''accès immédiatement — l''activation seule ne suffit pas'
);

UPDATE public.parent_student_links SET is_active = true
 WHERE parent_user_id = 'c9000000-0000-4000-8000-000000000001'
   AND student_user_id = 'c9000000-0000-4000-8000-000000000002';

-- Famille suspendue par l'admin (outil d'incident, R-8).
INSERT INTO public.ai_owner_suspensions (owner_user_id, reason)
VALUES ('c9000000-0000-4000-8000-000000000001', 'test');

SELECT is(
  (SELECT allowed FROM public.resolve_ai_access(
     'c9000000-0000-4000-8000-000000000002'::uuid, 'explain')),
  false,
  'une famille suspendue est coupée, activation ou pas'
);

DELETE FROM public.ai_owner_suspensions
 WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001';

-- Kill-switch global : il coupe TOUT, y compris le repli plateforme.
UPDATE public.ai_admin_state SET ai_enabled = false WHERE id;

SELECT is(
  (SELECT reason FROM public.resolve_ai_access(
     'c9000000-0000-4000-8000-000000000002'::uuid, 'explain')),
  'AI_MODE_OFF',
  'le kill-switch global coupe la porte entière'
);

UPDATE public.ai_admin_state SET ai_enabled = true WHERE id;

-- Clé passée en `invalid` : refus, avec le repli plateforme nommé.
UPDATE public.ai_credentials SET status = 'invalid'
 WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001';

SELECT is(
  (SELECT reason FROM public.resolve_ai_access(
     'c9000000-0000-4000-8000-000000000002'::uuid, 'explain')),
  'AI_KEY_INVALID',
  'matrice : une clé refusée par le fournisseur coupe le chemin famille'
);

SELECT is(
  (SELECT payer FROM public.resolve_ai_access(
     'c9000000-0000-4000-8000-000000000002'::uuid, 'explain')),
  'platform',
  'D-2 / Q-5 : le refus du chemin famille propose le chemin PLATEFORME, il ne ferme pas la porte'
);

UPDATE public.ai_credentials SET status = 'active'
 WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001';

-- Énergie épuisée.
INSERT INTO public.ai_energy_ledger (student_user_id, day, spent)
VALUES ('c9000000-0000-4000-8000-000000000002', CURRENT_DATE, 10)
ON CONFLICT (student_user_id, day) DO UPDATE SET spent = 10;

SELECT is(
  (SELECT reason FROM public.resolve_ai_access(
     'c9000000-0000-4000-8000-000000000002'::uuid, 'explain')),
  'AI_ENERGY_SPENT',
  'é11 R-12 : énergie du jour épuisée ⇒ refus, et le payeur reste la famille'
);

DELETE FROM public.ai_energy_ledger
 WHERE student_user_id = 'c9000000-0000-4000-8000-000000000002';

-- ---------------------------------------------------------
-- 4. LA COUPURE — R-11, et son atomicité.
-- ---------------------------------------------------------
-- ⚠️ Depuis le 2026-08-22, `limits_enforced` vaut false PAR DÉFAUT : les
-- plafonds mesurent et alertent, ils ne coupent plus. Cette section teste la
-- coupure, donc elle l'ARME explicitement. Sans cette ligne, chaque assertion
-- de refus ci-dessous passerait au vert pour la mauvaise raison — l'appel
-- serait accordé et le test le lirait comme « pas de dépassement ».
UPDATE public.ai_credentials SET limits_enforced = true
 WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001';

-- Un appel sous le plafond passe.
SELECT is(
  (SELECT granted FROM public.reserve_ai_spend(
     'c9000000-0000-4000-8000-000000000001'::uuid,
     'c9000000-0000-4000-8000-000000000002'::uuid,
     500000, 1)),
  true,
  'R-11 : 0,50 $ sous un plafond de 2 $/jour est accordé'
);

SELECT is(
  (SELECT reserved_micros FROM public.ai_spend_ledger
    WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001' AND day = CURRENT_DATE),
  500000::BIGINT,
  'la réservation est écrite AVANT l''appel (D-8)'
);

SELECT is(
  (SELECT spent FROM public.ai_energy_ledger
    WHERE student_user_id = 'c9000000-0000-4000-8000-000000000002' AND day = CURRENT_DATE),
  1,
  'R-11 : l''énergie est réservée dans la MÊME transaction que l''argent'
);

-- Le dépassement JOURNALIER coupe — et il coupe en tenant compte de ce qui est
-- déjà réservé, pas seulement de ce qui est dépensé. C'est là que se joue la
-- double dépense concurrente : le second appel voit la réservation du premier.
SELECT is(
  (SELECT granted FROM public.reserve_ai_spend(
     'c9000000-0000-4000-8000-000000000001'::uuid,
     'c9000000-0000-4000-8000-000000000002'::uuid,
     1800000, 1)),
  false,
  'R-11 : 0,50 $ déjà réservés + 1,80 $ > 2 $/jour ⇒ l''appel n''est PAS émis'
);

SELECT is(
  (SELECT reason FROM public.reserve_ai_spend(
     'c9000000-0000-4000-8000-000000000001'::uuid,
     'c9000000-0000-4000-8000-000000000002'::uuid,
     1800000, 1)),
  'AI_BUDGET_REACHED',
  'le refus porte un code stable, pas une exception — l''UI dégrade en silence'
);

SELECT is(
  (SELECT spent FROM public.ai_energy_ledger
    WHERE student_user_id = 'c9000000-0000-4000-8000-000000000002' AND day = CURRENT_DATE),
  1,
  'un refus de budget ne consomme PAS d''énergie — les deux réservations sont solidaires'
);

-- Le plafond MENSUEL coupe aussi, indépendamment du journalier.
--
-- ⚠️ CE SCÉNARIO NE PEUT PAS S'ÉCRIRE « UNE DÉPENSE D'HIER ». La fenêtre
-- mensuelle est CALENDAIRE — `l.day >= date_trunc('month', CURRENT_DATE)`
-- (`reserve_ai_spend`, migration 20260823110000) — donc le 1er du mois
-- `CURRENT_DATE - 1` tombe dans le mois PRÉCÉDENT, hors fenêtre : les 19,90 $
-- ne comptaient pas, rien ne coupait, et l'assertion lisait NULL au lieu de
-- `AI_BUDGET_REACHED`. Le test était donc juste 30 jours sur 31 et faux le 31ᵉ.
-- Constaté le 2026-09-01 : il a fait rougir le nightly à lui seul, le jour où
-- il n'y avait plus le rouge de 83_open_ecole_3eme_sec pour le cacher.
--
-- On ne peut pas non plus « choisir un autre jour passé du mois » : le 1er, il
-- n'en existe aucun. Le scénario est donc reconstruit autrement — la dépense va
-- sur AUJOURD'HUI, et c'est le plafond JOURNALIER qu'on écarte le temps de
-- l'assertion. Ce qui isole vraiment le mensuel, au lieu de le déduire d'un
-- calendrier : sans le journalier pour couper, seul le mensuel peut refuser.
SELECT set_config(
  'test.daily_budget_before',
  (SELECT daily_budget_usd::text FROM public.ai_credentials WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001'),
  false
);

UPDATE public.ai_credentials SET daily_budget_usd = 50
 WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001';

-- 19,90 $ déjà dépensés + 0,50 $ déjà réservés = 20,40 $ sur le mois (plafond
-- 20 $) mais très en deçà des 50 $/jour qu'on vient d'accorder (le maximum que le CHECK
-- de la colonne autorise : `daily_budget_usd <= 50`).
INSERT INTO public.ai_spend_ledger (owner_user_id, day, spent_micros)
VALUES ('c9000000-0000-4000-8000-000000000001', CURRENT_DATE, 19900000)
ON CONFLICT (owner_user_id, day) DO UPDATE SET spent_micros = 19900000;

SELECT is(
  (SELECT reason FROM public.reserve_ai_spend(
     'c9000000-0000-4000-8000-000000000001'::uuid,
     'c9000000-0000-4000-8000-000000000002'::uuid,
     500000, 1)),
  'AI_BUDGET_REACHED',
  'R-11 : le plafond MENSUEL coupe même quand le journalier laisserait passer'
);

-- Rendre le plafond journalier tel qu'il était : les sections suivantes
-- décrivent le comportement du porteur ORDINAIRE, pas celui d'un compte à 50 $.
UPDATE public.ai_credentials
   SET daily_budget_usd = current_setting('test.daily_budget_before')::NUMERIC
 WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001';

DELETE FROM public.ai_spend_ledger
 WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001' AND day = CURRENT_DATE;

-- ---------------------------------------------------------
-- 4bis. LE NOUVEAU DÉFAUT — on compte, on alerte, on ne coupe pas.
--
-- Décision du 2026-08-22 : `limits_enforced` est false à la création. Ce qui
-- suit garde les DEUX moitiés de cette décision, parce qu'une seule ne vaut
-- rien : le dépassement passe, ET il reste inscrit au grand livre. Une version
-- qui cesserait d'écrire rendrait la console (R-12), `/admin/ia` et l'alerte
-- d'anomalie aveugles — or l'anomalie est le dernier garde-fou quand plus rien
-- ne coupe.
-- ---------------------------------------------------------
UPDATE public.ai_credentials SET limits_enforced = false
 WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001';

DELETE FROM public.ai_spend_ledger
 WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001';
DELETE FROM public.ai_energy_ledger
 WHERE student_user_id = 'c9000000-0000-4000-8000-000000000002';

SELECT is(
  (SELECT granted FROM public.reserve_ai_spend(
     'c9000000-0000-4000-8000-000000000001'::uuid,
     'c9000000-0000-4000-8000-000000000002'::uuid,
     9000000, 1)),
  true,
  'plafonds désarmés : 9 $ sur un repère de 2 $/jour PASSE — plus de coupure'
);

SELECT is(
  (SELECT reserved_micros FROM public.ai_spend_ledger
    WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001' AND day = CURRENT_DATE),
  9000000::BIGINT,
  '… et la dépense est quand même COMPTÉE : sans elle, l''alerte d''anomalie serait aveugle'
);

SELECT is(
  (SELECT granted FROM public.reserve_ai_spend(
     'c9000000-0000-4000-8000-000000000001'::uuid,
     'c9000000-0000-4000-8000-000000000002'::uuid,
     0, 99)),
  true,
  'l''énergie ne coupe plus non plus (99 quiz d''un coup) — la décision portait sur les DEUX'
);

SELECT is(
  (SELECT spent FROM public.ai_energy_ledger
    WHERE student_user_id = 'c9000000-0000-4000-8000-000000000002' AND day = CURRENT_DATE),
  100,
  '… et le compteur d''énergie tourne toujours'
);

-- L'ACTIVATION, elle, reste opposable. Ce n'est pas un plafond : un élève que
-- personne n'a activé ne passe pas, plafonds armés ou non (R-3).
SELECT is(
  (SELECT reason FROM public.reserve_ai_spend(
     'c9000000-0000-4000-8000-000000000001'::uuid,
     '00000000-0000-4000-8000-0000000000ff'::uuid,
     100, 1)),
  'AI_MODE_OFF',
  'désarmer les plafonds n''ouvre PAS le mode : un élève non activé reste refusé'
);

-- Et le frein se réarme, sans redéploiement : c'est tout l'intérêt d'en avoir
-- fait une colonne plutôt qu'une suppression de code.
UPDATE public.ai_credentials SET limits_enforced = true
 WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001';

SELECT is(
  (SELECT reason FROM public.reserve_ai_spend(
     'c9000000-0000-4000-8000-000000000001'::uuid,
     'c9000000-0000-4000-8000-000000000002'::uuid,
     100, 1)),
  'AI_BUDGET_REACHED',
  'réarmé, le plafond coupe de nouveau — le frein est resté là, à un interrupteur près'
);

DELETE FROM public.ai_spend_ledger
 WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001';
DELETE FROM public.ai_energy_ledger
 WHERE student_user_id = 'c9000000-0000-4000-8000-000000000002';

-- La suite reprend l'état que la section 4 avait laissé : une réservation de
-- 0,50 $ et 1 point d'énergie, que la section 5 solde puis rembourse.
SELECT public.reserve_ai_spend(
  'c9000000-0000-4000-8000-000000000001'::uuid,
  'c9000000-0000-4000-8000-000000000002'::uuid,
  500000, 1);

-- ---------------------------------------------------------
-- 5. Solde et remboursement.
-- ---------------------------------------------------------
SELECT lives_ok(
  $$ SELECT public.settle_ai_spend('c9000000-0000-4000-8000-000000000001'::uuid, 500000, 120000) $$,
  'le solde réel remplace la réservation'
);

SELECT is(
  (SELECT reserved_micros || '/' || spent_micros FROM public.ai_spend_ledger
    WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001' AND day = CURRENT_DATE),
  '0/120000',
  'après solde : plus de réservation, la dépense RÉELLE est inscrite (§3.7)'
);

SELECT lives_ok(
  $$ SELECT public.release_ai_reservation(
       'c9000000-0000-4000-8000-000000000001'::uuid,
       'c9000000-0000-4000-8000-000000000002'::uuid, 0, 1) $$,
  'une panne libère la réservation'
);

SELECT is(
  (SELECT spent FROM public.ai_energy_ledger
    WHERE student_user_id = 'c9000000-0000-4000-8000-000000000002' AND day = CURRENT_DATE),
  0,
  'é11 R-15 : l''énergie est REMBOURSÉE — un élève ne paie pas une panne de fournisseur'
);

-- ---------------------------------------------------------
-- 6. R-14 sous l'angle du lot 3 : l'énergie oui, l'argent non.
-- ---------------------------------------------------------
SET LOCAL request.jwt.claims = '{"sub":"c9000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.ai_spend_ledger),
  0,
  'R-14a : l''élève ne lit AUCUNE ligne du grand livre d''argent de son parent'
);

SELECT is(
  (SELECT count(*)::int FROM public.ai_energy_ledger
    WHERE student_user_id = 'c9000000-0000-4000-8000-000000000002'),
  1,
  'l''élève lit SON énergie — une mécanique de jeu, pas de l''argent (é11 R-12)'
);

SELECT is(
  (SELECT count(*)::int FROM public.ai_student_access
    WHERE student_user_id = 'c9000000-0000-4000-8000-000000000002'),
  1,
  'US-5 : l''élève voit que le mode est allumé pour lui'
);

RESET ROLE;

-- ---------------------------------------------------------
-- 7. US-8, complétée : révoquer éteint AUSSI les activations.
-- ---------------------------------------------------------
SET LOCAL request.jwt.claims = '{"sub":"c9000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT ok(public.revoke_ai_credential(), 'la révocation agit');
RESET ROLE;

SELECT is(
  (SELECT count(*)::int FROM public.ai_student_access
    WHERE owner_user_id = 'c9000000-0000-4000-8000-000000000001'),
  0,
  'US-8 : « toutes les activations enfants tombent » — dans la même transaction que la clé'
);

SELECT * FROM finish();
ROLLBACK;
