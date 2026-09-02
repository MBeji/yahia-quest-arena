-- =========================================================
-- Étude 31, lot 4 — LES SIX AUDIENCES DU SOIR (R-16, R-17).
-- ---------------------------------------------------------
-- Le constat n° 2 de l'étude tient en une phrase : **l'élève qui a PERDU sa série
-- n'est plus jamais recontacté.** Le seul rappel d'élève visait
-- `current_streak > 0`, c'est-à-dire exactement ceux qui n'ont rien perdu. Ni
-- relance J+7, ni résultat de ligue, ni jalon — et trois payloads en français
-- pour tout le monde.
--
-- Ce fichier garde ce que le pipeline TypeScript ne peut pas garder : QUI entre
-- dans chaque audience, et à quel jour EXACT.
--
--   1. ⭐ CHAQUE AUDIENCE EST ANCRÉE SUR UN JOUR PRÉCIS. C'est ce qui tient « une
--      seule fois par période d'absence » (R-16) SANS colonne d'état : hier et
--      demain, l'élève n'y est pas. Le stop-point du lot demandait de proposer
--      une colonne si la garantie n'était pas atteignable — elle l'est.
--   2. ⭐ LA SÉRIE PERDUE EST UNE AUDIENCE. Sans elle, le canal ne parle qu'à ceux
--      qui vont déjà bien.
--   3. ⭐ LA LANGUE VOYAGE AVEC LE CANDIDAT (R-17) : le dispatcher n'a pas à la
--      redemander, et un élève arabophone ne reçoit pas un texte français.
--
-- Espace de noms des fixtures : préfixe `p31…`.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(16);

INSERT INTO auth.users (id, email)
SELECT ('c3100000-0000-4000-8000-00000000000' || g)::uuid, 'c31-u' || g || '@test.local'
FROM generate_series(1, 8) AS g;

-- ---------------------------------------------------------
-- Le décor : un « aujourd'hui » fixé au LUNDI de la semaine en cours, pour que
-- l'audience de ligue soit dans sa fenêtre. Tout le reste est relatif à lui.
-- ---------------------------------------------------------
CREATE TEMP TABLE p31_today AS SELECT public.app_current_week_start() AS d;

-- u1 : série de 12 perdue AVANT-HIER  → streak-lost (et streak-at-risk)
UPDATE public.profiles SET current_streak = 12, last_active_date = (SELECT d FROM p31_today) - 2,
       locale = 'ar'
 WHERE id = 'c3100000-0000-4000-8000-000000000001';

-- u2 : série de 4 non jouée AUJOURD'HUI → streak-at-risk seul
UPDATE public.profiles SET current_streak = 4, last_active_date = (SELECT d FROM p31_today) - 1
 WHERE id = 'c3100000-0000-4000-8000-000000000002';

-- u3 : série de 7 atteinte AUJOURD'HUI → streak-milestone
UPDATE public.profiles SET current_streak = 7, last_active_date = (SELECT d FROM p31_today),
       locale = 'en'
 WHERE id = 'c3100000-0000-4000-8000-000000000003';

-- u4 : absent depuis EXACTEMENT 7 jours → comeback
UPDATE public.profiles SET current_streak = 0, last_active_date = (SELECT d FROM p31_today) - 7
 WHERE id = 'c3100000-0000-4000-8000-000000000004';

-- u5 : absent depuis 8 jours → PLUS RIEN (la relance est unique)
UPDATE public.profiles SET current_streak = 0, last_active_date = (SELECT d FROM p31_today) - 8
 WHERE id = 'c3100000-0000-4000-8000-000000000005';

-- u6 : série de 2 perdue avant-hier → PAS de streak-lost (sous le seuil de 3)
UPDATE public.profiles SET current_streak = 2, last_active_date = (SELECT d FROM p31_today) - 2
 WHERE id = 'c3100000-0000-4000-8000-000000000006';

-- u7 : classé en ligue la semaine close → league-result
INSERT INTO public.duel_league_awards (user_id, week_start, tier, rank, points, coins_awarded)
SELECT 'c3100000-0000-4000-8000-000000000007', (SELECT d FROM p31_today) - 7, 'gold', 2, 30, 25;

-- u8 : un PARENT, jamais dans les audiences d'élève.
UPDATE public.profiles SET role = 'parent', current_streak = 5,
       last_active_date = (SELECT d FROM p31_today) - 1
 WHERE id = 'c3100000-0000-4000-8000-000000000008';

-- =========================================================
-- 1. ⭐ La série PERDUE — le trou du canal d'avant ce lot.
-- =========================================================
SELECT ok(
  EXISTS (SELECT 1 FROM public.push_daily_audiences((SELECT d FROM p31_today))
           WHERE user_id = 'c3100000-0000-4000-8000-000000000001' AND tag = 'streak-lost'),
  '⭐ l''élève dont la série de 12 est tombée avant-hier est ENFIN une audience'
);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.push_daily_audiences((SELECT d FROM p31_today))
               WHERE user_id = 'c3100000-0000-4000-8000-000000000006' AND tag = 'streak-lost'),
  'une série de 2 jours ne déclenche pas la relance : elle ne représente rien à sauver'
);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.push_daily_audiences((SELECT d FROM p31_today) + 1)
               WHERE user_id = 'c3100000-0000-4000-8000-000000000001' AND tag = 'streak-lost'),
  '⭐ DEMAIN, il n''y est plus : l''ancrage sur un jour exact tient « une seule fois » sans colonne d''état'
);

-- =========================================================
-- 2. La série en danger — l'audience historique, intacte.
-- =========================================================
SELECT ok(
  EXISTS (SELECT 1 FROM public.push_daily_audiences((SELECT d FROM p31_today))
           WHERE user_id = 'c3100000-0000-4000-8000-000000000002' AND tag = 'streak-at-risk'),
  'la série en danger reste ce qu''elle était : vivante, mais pas jouée aujourd''hui'
);

SELECT is(
  (SELECT arg FROM public.push_daily_audiences((SELECT d FROM p31_today))
    WHERE user_id = 'c3100000-0000-4000-8000-000000000002' AND tag = 'streak-at-risk'),
  4,
  'le nombre de jours voyage avec le candidat — le texte dit COMBIEN'
);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.push_daily_audiences((SELECT d FROM p31_today))
               WHERE user_id = 'c3100000-0000-4000-8000-000000000003' AND tag = 'streak-at-risk'),
  'celui qui a déjà joué aujourd''hui n''est appelé par personne'
);

-- =========================================================
-- 3. Le jalon, le retour, et la borne de la relance.
-- =========================================================
SELECT ok(
  EXISTS (SELECT 1 FROM public.push_daily_audiences((SELECT d FROM p31_today))
           WHERE user_id = 'c3100000-0000-4000-8000-000000000003' AND tag = 'streak-milestone'),
  'le jalon tombe le SOIR MÊME des 7 jours — trois jours plus tard, il ne félicite rien'
);

SELECT ok(
  EXISTS (SELECT 1 FROM public.push_daily_audiences((SELECT d FROM p31_today))
           WHERE user_id = 'c3100000-0000-4000-8000-000000000004' AND tag = 'comeback'),
  'le retour au calme est proposé à J+7 exact'
);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.push_daily_audiences((SELECT d FROM p31_today))
               WHERE user_id = 'c3100000-0000-4000-8000-000000000005'),
  '⭐ à J+8, plus AUCUNE audience — R-4 interdit la relance répétée, et un absent de longue date n''a pas besoin d''un rappel de plus'
);

-- =========================================================
-- 4. La ligue — le lundi, et le lundi seulement.
-- =========================================================
SELECT ok(
  EXISTS (SELECT 1 FROM public.push_daily_audiences((SELECT d FROM p31_today))
           WHERE user_id = 'c3100000-0000-4000-8000-000000000007' AND tag = 'league-result'),
  'le lundi, le participant de la semaine close reçoit son résultat (dette é05 US-7)'
);

SELECT is(
  (SELECT detail FROM public.push_daily_audiences((SELECT d FROM p31_today))
    WHERE user_id = 'c3100000-0000-4000-8000-000000000007' AND tag = 'league-result'),
  'gold',
  'le palier voyage avec le candidat'
);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.push_daily_audiences((SELECT d FROM p31_today) + 2)
               WHERE tag = 'league-result'),
  '⭐ le mercredi, aucun résultat de ligue : sans cette borne, le même podium serait annoncé sept soirs de suite'
);

-- =========================================================
-- 5. La langue et la population.
-- =========================================================
SELECT is(
  (SELECT locale FROM public.push_daily_audiences((SELECT d FROM p31_today))
    WHERE user_id = 'c3100000-0000-4000-8000-000000000001' AND tag = 'streak-lost'),
  'ar',
  '⭐ la langue du profil voyage avec le candidat (R-17) — le canal cesse de parler français à tout le monde'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.push_daily_audiences((SELECT d FROM p31_today))
    WHERE user_id = 'c3100000-0000-4000-8000-000000000008'),
  0,
  'un PARENT n''entre dans aucune audience d''élève : il a son propre canal, le dimanche'
);

SELECT ok(
  NOT has_function_privilege('authenticated', 'public.push_daily_audiences(date)', 'EXECUTE'),
  'l''audience n''est pas lisible depuis le navigateur — elle porte le user_id de tout le parc'
);

-- =========================================================
-- 6. Le badge de podium (R-14) — décerné par la clôture, jamais dégradé.
-- =========================================================
SELECT ok(
  EXISTS (SELECT 1 FROM public.badges WHERE code = 'league_podium' AND family = 'saison'),
  'le badge de ligue existe, dans la famille `saison`'
);

SELECT * FROM finish();
ROLLBACK;
