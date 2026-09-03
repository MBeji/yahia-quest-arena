-- Étude 31 — Q-2 : LE CALENDRIER 2026-2027 AU COMPLET (US-12, R-21).
--
-- Le lot 8 a posé la machinerie et n'a semé qu'UN événement — le pilote de la
-- rentrée — parce que son stop-point le demandait : « un seul événement seedé ».
-- Q-2 avait pourtant arbitré QUATRE moments le 2026-09-01 : Rentrée (septembre) ·
-- Devoirs de synthèse (fin novembre) · Révisions de mai · Défi Ramadan (objectif
-- réduit, ton calme).
--
-- Les trois manquants n'arriveraient pas tout seuls. Il n'y a pas d'admin UI (hors
-- périmètre v1, annexe §E), donc chacun demande une migration : sans celle-ci, le
-- produit n'aurait plus rien de daté après le 30 septembre 2026, et le constat n° 9
-- de l'étude — « aucun événement, aucune saison » — serait revenu tout seul en
-- trois semaines. Semés le 2026-09-03 sur arbitrage explicite.
--
-- AUCUN CODE N'EST TOUCHÉ : `get_active_event`, `claim_event_badge` et la bannière
-- lisent la table. C'était l'intérêt de la table — un événement de plus est une
-- ligne, pas un déploiement.
--
-- ⚠️ R-2, redit ici parce qu'il se perd : la fenêtre borne le DÉFI et son badge,
-- JAMAIS un contenu. Chaque chapitre reste jouable avant, pendant et après.
--
-- ⚠️ R-21, « au plus un actif à la fois » : la contrainte d'exclusion le VÉRIFIE
-- (`app_events_no_overlap`), donc cette migration échoue si l'une des fenêtres
-- ci-dessous en chevauche une autre. Les quatre, dans l'ordre :
--     rentree-2026        15 → 30 sept. 2026   (le pilote, déjà semé)
--     synthese-2026       22 nov. → 6 déc. 2026
--     ramadan-2027        15 févr. → 2 mars 2027
--     revisions-mai-2027   3 → 17 mai 2027
--
-- ⚠️ **LA DATE DU RAMADAN NE S'ÉCRIT PAS AU JOUR PRÈS.** Son début civil dépend
-- de l'observation lunaire et n'est arrêté qu'à quelques jours. Ramadan 1448 est
-- attendu vers le 8 février 2027, à ± 1 ou 2 jours. Deux mauvaises réponses se
-- présentaient : écrire le 8 février comme un fait (une fenêtre qui peut ouvrir
-- avant le mois qu'elle célèbre), ou étaler la fenêtre sur trente jours pour
-- couvrir l'incertitude — ce qui contredit R-21 (fenêtres COURTES, 7 à 15 jours :
-- un défi long n'est plus un événement, c'est un devoir permanent).
-- La réponse retenue est une QUINZAINE AU MILIEU du mois probable : même si le
-- début glisse de deux jours dans un sens ou l'autre, le 15 février → 2 mars
-- reste à l'intérieur du Ramadan. Le jour exact cesse d'être une hypothèse.

-- ===========================================================================
-- Les trois badges saisonniers. Famille `saison` (R-13), et DÉCERNABLES : la
-- règle est déclarée par `app_events.badge_code` ci-dessous, et
-- `claim_event_badge` passe le code dynamiquement — c'est la forme que la garde
-- structurelle R-13 accepte depuis le lot 8.
--
-- ⚠️ `icon_name` doit exister dans la carte `GLYPHS` de `badge-medal.tsx`. Un
-- nom absent ne casse rien et retombe sur le glyphe de repli — c'est ce qui est
-- arrivé à `event_rentree` (semé en `Sparkles`, absent de la carte). Les trois
-- glyphes ci-dessous y sont ajoutés dans le même commit, et un test compare
-- désormais les deux listes dans les deux sens.
-- ===========================================================================
INSERT INTO public.badges (code, name, description, rarity, icon_name, rule_key, family)
VALUES
  ('event_synthese',  'Devoirs de synthèse', 'Réussir 3 missions à 90 % pendant la quinzaine des devoirs de synthèse',
   'rare', 'BookOpen', 'event_synthese', 'saison'),
  ('event_ramadan',   'Ramadan 1448',        'Jouer 3 missions pendant la quinzaine du Défi Ramadan',
   'rare', 'Moon', 'event_ramadan', 'saison'),
  ('event_revisions', 'Révisions de mai',    'Réussir 5 missions à 90 % pendant la quinzaine des révisions de mai',
   'epic', 'Sun', 'event_revisions', 'saison')
ON CONFLICT (code) DO UPDATE SET family = EXCLUDED.family, icon_name = EXCLUDED.icon_name;

-- ===========================================================================
-- LES TROIS ÉVÉNEMENTS RESTANTS.
--
-- Fuseau `+01` comme le pilote : la Tunisie est à UTC+1 toute l'année, sans
-- heure d'été — une fenêtre écrite en UTC ouvrirait une heure trop tôt.
--
-- Les objectifs montent avec l'année scolaire, et JAMAIS au-dessus du modeste :
-- un défi qui demande dix exercices n'est pas une fête, c'est un devoir de plus
-- (R-8, et c'est le raisonnement du pilote à 5 exercices).
--   · synthèse   → 3 missions à 90 % : la période récompense la QUALITÉ de
--                  révision, pas le volume ;
--   · Ramadan    → 3 missions, sans seuil de score : objectif RÉDUIT et ton
--                  calme, exactement ce que Q-2 demande pour ce mois ;
--   · révisions  → 5 missions à 90 % : fin d'année, l'élève a un an de pratique.
-- ===========================================================================
INSERT INTO public.app_events (code, starts_at, ends_at, goal_type, goal_target, badge_code, name, description)
VALUES
  (
    'synthese-2026',
    '2026-11-22 00:00:00+01',
    '2026-12-06 00:00:00+01',
    'score_90_n', 3, 'event_synthese',
    '{"fr":"Cap sur les devoirs de synthèse","en":"Heading into the synthesis exams","ar":"نحو فروض التأليف"}'::jsonb,
    '{"fr":"Trois missions réussies à 90 % pendant la quinzaine, et le badge est à toi. Révise à ton rythme.","en":"Three missions passed at 90 % during the fortnight, and the badge is yours. Revise at your own pace.","ar":"ثلاث مهامّ بنسبة 90٪ خلال الأسبوعين، وتكون الشارة لك. راجع على راحتك."}'::jsonb
  ),
  (
    'ramadan-2027',
    '2027-02-15 00:00:00+01',
    '2027-03-02 00:00:00+01',
    'exercises_n', 3, 'event_ramadan',
    '{"fr":"Défi Ramadan","en":"Ramadan challenge","ar":"تحدّي رمضان"}'::jsonb,
    '{"fr":"Trois missions, quand tu veux dans la quinzaine. Un petit rythme, gardé — c''est tout ce que demande ce défi.","en":"Three missions, whenever suits you in the fortnight. A small rhythm, kept — that is all this challenge asks.","ar":"ثلاث مهامّ، في أيّ وقت خلال الأسبوعين. إيقاع صغير تحافظ عليه — هذا كلّ ما يطلبه هذا التحدّي."}'::jsonb
  ),
  (
    'revisions-mai-2027',
    '2027-05-03 00:00:00+01',
    '2027-05-17 00:00:00+01',
    'score_90_n', 5, 'event_revisions',
    '{"fr":"Révisions de mai","en":"May revisions","ar":"مراجعات مايو"}'::jsonb,
    '{"fr":"Cinq missions réussies à 90 % pendant la quinzaine des révisions. Tu as une année de pratique derrière toi.","en":"Five missions passed at 90 % during the revision fortnight. You have a year of practice behind you.","ar":"خمس مهامّ بنسبة 90٪ خلال أسبوعَي المراجعة. لديك سنة كاملة من التمرّن وراءك."}'::jsonb
  )
ON CONFLICT (code) DO NOTHING;

-- ===========================================================================
-- AU PASSAGE — QUATRE BADGES RENDAIENT LE GLYPHE GÉNÉRIQUE, EN SILENCE.
--
-- Trouvé par le test de glyphes que ce commit ajoute, pas par une relecture :
-- `BadgeMedal` fait `GLYPHS[iconName] || Award`, donc un `icon_name` que la carte
-- ne connaît pas rend une médaille correcte — avec le glyphe passe-partout. La
-- conduite est bonne, le silence est le défaut.
--
--   · `streak_7`      → `'flame'`   (minuscule)
--   · `boss_slayer`   → `'swords'`  (minuscule)
--   · `math_blitz`    → `'zap'`     (minuscule)
--
-- Les trois viennent du PREMIER seed (`20260522153000`), en minuscules. Le seed
-- plus riche du même jour (`20260522170000`) écrit bien `Flame`, `Shield`, … mais
-- il porte `ON CONFLICT (code) DO NOTHING` : les lignes existaient déjà, donc la
-- bonne casse n'a jamais été appliquée. Quatre mois de flammes invisibles.
--
-- Le quatrième, `league_podium` → `'Trophy'`, est en bonne casse : c'est la CARTE
-- qui ne connaissait pas ce glyphe. Elle l'apprend dans ce commit, côté code.
--
-- ⚠️ Pourquoi un UPDATE et pas une correction du seed d'origine : cette migration
-- est appliquée en prod depuis mai. La réécrire ne rejouerait rien là-bas (le
-- suivi se fait par VERSION, pas par contenu) et ferait diverger une base vierge
-- de la prod — le piège que CLAUDE.md nomme. On converge par un UPDATE.
--
-- La casse choisie est celle du glyphe VOULU par chaque seed, pas un redesign :
-- une flamme reste une flamme, des épées restent des épées.
-- ===========================================================================
UPDATE public.badges SET icon_name = 'Flame'  WHERE code = 'streak_7'    AND icon_name = 'flame';
UPDATE public.badges SET icon_name = 'Swords' WHERE code = 'boss_slayer' AND icon_name = 'swords';
UPDATE public.badges SET icon_name = 'Zap'    WHERE code = 'math_blitz'  AND icon_name = 'zap';
