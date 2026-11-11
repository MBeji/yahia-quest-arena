-- =========================================================
-- Étude 31, Q-2 — LE CALENDRIER 2026-2027 SEMÉ EN ENTIER.
-- ---------------------------------------------------------
-- Le lot 8 a posé la machinerie et n'a semé QUE le pilote (son stop-point le
-- demandait). Q-2 en avait arbitré quatre. Les trois autres sont semés le
-- 2026-09-03, et ce fichier garde le SEMIS lui-même — pas le mécanisme, que
-- `93_app_events` couvre déjà sur un événement synthétique.
--
-- La distinction compte : ici les assertions portent sur les VRAIES lignes de
-- production. Un calendrier faux passerait toutes les assertions de `93`.
--
--   1. ⭐ LES QUATRE MOMENTS EXISTENT, disjoints, et COURTS (R-21 : 7 à 15 jours —
--      un défi long n'est plus un événement, c'est un devoir permanent).
--   2. ⭐ LA NORMALISATION DES GLYPHES A EU LIEU. Quatre badges rendaient le
--      glyphe passe-partout : trois par une casse minuscule héritée du premier
--      seed (que le seed suivant n'a pas corrigée, `ON CONFLICT DO NOTHING`), un
--      par un nom absent de la carte du composant. C'est le pendant SQL du test
--      de glyphes : lui lit la carte, celui-ci lit la BASE.
--   3. R-22 — les trois langues sur chaque nom et chaque description.
--   4. R-2 — la table ne peut pas borner un contenu : elle n'a aucune colonne
--      qui en désigne un. Vérifié en structure, pas en intention.
--
-- Aucune fixture : ce fichier lit le semis. Rien à préfixer.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(16);

-- ---------------------------------------------------------
-- 1. Les quatre moments
-- ---------------------------------------------------------
SELECT is(
  (SELECT COUNT(*)::int FROM public.app_events
    WHERE code IN ('rentree-2026','synthese-2026','ramadan-2027','revisions-mai-2027')),
  4,
  '⭐ les QUATRE événements de Q-2 sont semés — le pilote et les trois de la suite'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.app_events a, public.app_events b
    WHERE a.code < b.code
      AND tstzrange(a.starts_at, a.ends_at) && tstzrange(b.starts_at, b.ends_at)),
  0,
  '⭐ aucune paire de fenêtres ne se chevauche (R-21) — un seul défi actif à la fois'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.app_events
    WHERE ends_at - starts_at > INTERVAL '15 days'),
  0,
  'aucune fenêtre ne dépasse 15 jours (R-21) — au-delà, ce n''est plus un événement'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.app_events
    WHERE ends_at - starts_at < INTERVAL '7 days'),
  0,
  'aucune fenêtre ne descend sous 7 jours (R-21) — en dessous, elle est inatteignable'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.app_events WHERE badge_code IS NULL),
  0,
  'chaque événement porte son badge — un défi sans trace ne récompense rien'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.app_events e
     JOIN public.badges b ON b.code = e.badge_code
    WHERE b.family <> 'saison'),
  0,
  'les badges d''événement sont tous de la famille `saison` (R-13)'
);

SELECT is(
  (SELECT MAX(goal_target)::int FROM public.app_events),
  5,
  'les objectifs restent modestes — 5 au plus (R-8 : un défi de dix n''est pas une fête)'
);

-- La fenêtre du Ramadan ne s'écrit pas au jour près : son début civil dépend de
-- l'observation lunaire. On assert la MARGE, pas la date — la quinzaine retenue
-- est au milieu du mois probable, donc robuste à un glissement de deux jours.
SELECT ok(
  (SELECT starts_at >= '2027-02-10 00:00:00+01'::timestamptz
      AND ends_at   <= '2027-03-10 00:00:00+01'::timestamptz
     FROM public.app_events WHERE code = 'ramadan-2027'),
  'la quinzaine du Ramadan tient dans le mois lunaire probable, marge comprise'
);

-- ---------------------------------------------------------
-- 2. ⭐ Les glyphes : la normalisation a bien eu lieu
-- ---------------------------------------------------------
SELECT is(
  (SELECT icon_name FROM public.badges WHERE code = 'streak_7'),
  'Flame',
  '⭐ `streak_7` ne porte plus `flame` en minuscule — quatre mois de flammes invisibles'
);

SELECT is(
  (SELECT icon_name FROM public.badges WHERE code = 'boss_slayer'),
  'Swords',
  '⭐ `boss_slayer` ne porte plus `swords` en minuscule'
);

SELECT is(
  (SELECT icon_name FROM public.badges WHERE code = 'math_blitz'),
  'Zap',
  '⭐ `math_blitz` ne porte plus `zap` en minuscule'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.badges
    WHERE icon_name IS NOT NULL AND icon_name !~ '^[A-Z]'),
  0,
  '⭐ AUCUN glyphe de la base n''est en mauvaise casse — le composant ne rattrape pas la graphie'
);

-- ---------------------------------------------------------
-- 3. R-22 — les trois langues
-- ---------------------------------------------------------
SELECT is(
  (SELECT COUNT(*)::int FROM public.app_events
    WHERE COALESCE(name->>'fr','') = '' OR COALESCE(name->>'en','') = ''
       OR COALESCE(name->>'ar','') = ''),
  0,
  'chaque NOM d''événement naît FR/EN/AR (R-22)'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.app_events
    WHERE COALESCE(description->>'fr','') = '' OR COALESCE(description->>'en','') = ''
       OR COALESCE(description->>'ar','') = ''),
  0,
  'chaque DESCRIPTION d''événement naît FR/EN/AR (R-22)'
);

-- ---------------------------------------------------------
-- 4. R-2 — une fenêtre ne peut pas borner un contenu
-- ---------------------------------------------------------
SELECT is(
  (SELECT COUNT(*)::int FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'app_events'
      AND column_name IN ('chapter_id','exercise_id','question_id','subject_id','grade_id')),
  0,
  '⭐ R-2 par STRUCTURE : `app_events` ne désigne aucun contenu, donc n''en périme aucun'
);

-- L'ordre chronologique du calendrier est celui de l'année scolaire tunisienne :
-- rentrée, devoirs de synthèse, Ramadan, révisions de mai.
SELECT is(
  (SELECT string_agg(code, ',' ORDER BY starts_at) FROM public.app_events),
  'rentree-2026,synthese-2026,ramadan-2027,revisions-mai-2027',
  'le calendrier se lit dans l''ordre de l''année scolaire'
);

SELECT * FROM finish();
ROLLBACK;
