-- =========================================================
-- Étude 11 lot 6 — LE BILAN HEBDOMADAIRE. Ce que ce fichier garde.
-- ---------------------------------------------------------
-- Quatre familles d'invariants, et la première est la seule dont un défaut ne
-- se rattrape pas :
--
--   R-14 — le bloc de faits PART CHEZ UN FOURNISSEUR DE MODÈLE. Il ne doit
--          contenir ni nom, ni e-mail, ni UUID. Le contrôle est NÉGATIF : on
--          plante un nom reconnaissable dans le profil et on prouve qu'il ne
--          ressort nulle part. Un test qui vérifierait seulement la présence
--          des chiffres passerait sur une fonction qui fuit.
--   Q-5  — chaque audience ne lit QUE ce qui a été écrit pour elle. Un parent
--          non lié ne lit rien, un parent lié ne lit pas le bilan de l'enfant,
--          et la table n'a aucune colonne qui pourrait porter un verbatim.
--   R-10 — les chiffres sont ARRÊTÉS en SQL : deux fenêtres de semaine
--          distinctes, un écart calculé, le seuil R-2 appliqué par la fonction
--          canonique. Le modèle n'a rien à compter.
--   R-14 (rétentions) — les deux purges suppriment ce qui est vieux ET
--          conservent ce qui ne l'est pas. Une purge testée d'un seul côté
--          laisserait passer un `DELETE` sans `WHERE`.
--
-- ⚠️ Préfixe d'UUID `d19e0000-` : libre, vérifié contre les 72 fichiers voisins
-- (d7000000 et d9000000 sont pris, celui-ci ne l'est pas). Une collision avec
-- le contenu d'une migration ferait rougir `db:check-chain`.
--
-- ⚠️ PIÈGE DE FIXTURE (précédent #817) : `exercises.source` n'accepte que
-- 'admin' | 'parent'. Une valeur inventée avorte le fichier AVANT la première
-- assertion — le TAP est alors VIDE, pas rouge.
--
-- ⚠️ La semaine de référence est CALCULÉE (`pg_temp.wk()`), jamais écrite en
-- dur : un bilan est adossé au calendrier, et une date figée rendrait ce
-- fichier rouge un lundi de l'année prochaine.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(33);

-- La semaine résumée par le bilan : celle qui vient de s'achever. Tout le décor
-- s'y accroche, et la précédente s'en déduit — c'est ce qui rend la
-- comparaison des deux fenêtres testable sans figer une date.
CREATE OR REPLACE FUNCTION pg_temp.wk()
RETURNS DATE LANGUAGE sql STABLE AS $fn$
  SELECT public.tutor_week_start(CURRENT_DATE - 7);
$fn$;

-- ---------------------------------------------------------
-- Décor. Une matière SANS parcours (aucune porte d'accès à franchir : le lot 6
-- ne sélectionne aucun exercice, il ne fait que compter des tentatives).
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('dg-theme', 'DG Theme', 'Brain', 'subject-math', true);

-- `display_order = 9` ⇒ bande d'âge '12-14' (tutor_age_band). C'est la seule
-- chose que le modèle apprendra de l'âge de cet enfant.
INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES ('d19e0000-0000-4000-8000-0000000000f1'::uuid, 'dg-theme', 'dg-9', 'DG 9ème', 'college', 9);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, content_language)
VALUES ('dg-subj', 'DG Maths', 'Esprit', 'subject-math', 'Brain', 'dg-theme',
        'd19e0000-0000-4000-8000-0000000000f1'::uuid, 'fr');

INSERT INTO public.chapters (id, subject_id, title, display_order)
VALUES ('d19e0000-0000-4000-8000-0000000000c1'::uuid, 'dg-subj', 'DG Fractions', 1);

INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, difficulty, display_order, source)
VALUES ('d19e0000-0000-4000-8000-0000000000e1'::uuid,
        'd19e0000-0000-4000-8000-0000000000c1'::uuid, 'dg-subj', 'DG Ex', 'practice', 1, 1, 'admin');

INSERT INTO public.misconceptions (tag, subject, label_fr, label_en, label_ar)
VALUES ('dg.frac.add-denominators', 'math', 'Tu additionnes les dénominateurs',
        'You add the denominators', 'تجمع المقامات')
ON CONFLICT (tag) DO NOTHING;

INSERT INTO auth.users (id, email) VALUES
  ('d19e0000-0000-4000-8000-000000000001', 'dg-eleve@test.local'),
  ('d19e0000-0000-4000-8000-000000000002', 'dg-autre-eleve@test.local'),
  ('d19e0000-0000-4000-8000-000000000003', 'dg-parent-actif@test.local'),
  ('d19e0000-0000-4000-8000-000000000004', 'dg-parent-coupe@test.local'),
  ('d19e0000-0000-4000-8000-000000000005', 'dg-tiers@test.local'),
  ('d19e0000-0000-4000-8000-000000000006', 'dg-eleve-sans-bilan@test.local');

-- Le nom est l'APPÂT du contrôle négatif R-14 : il est volontairement
-- reconnaissable, et il ne doit apparaître dans aucun octet du bloc de faits.
UPDATE public.profiles
   SET display_name     = 'Yahia Ben Salem',
       current_grade_id = 'd19e0000-0000-4000-8000-0000000000f1'::uuid
 WHERE id = 'd19e0000-0000-4000-8000-000000000001';

-- Un parent LIÉ ACTIF, un parent dont le lien a été COUPÉ. Le second est tout
-- l'intérêt du décor : `is_active = false` doit refuser, pas servir du vide.
INSERT INTO public.parent_student_links (parent_user_id, student_user_id, is_active) VALUES
  ('d19e0000-0000-4000-8000-000000000003'::uuid, 'd19e0000-0000-4000-8000-000000000001'::uuid, true),
  ('d19e0000-0000-4000-8000-000000000004'::uuid, 'd19e0000-0000-4000-8000-000000000001'::uuid, false);

-- La semaine du bilan : trois missions, trois jours distincts, moyenne 60.
-- Les horodatages sont ancrés explicitement en UTC — les mêmes bornes que
-- `get_tutor_digest_inputs`. Sans cet ancrage, un poste réglé sur un autre
-- fuseau ferait glisser une mission d'une semaine à l'autre.
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, completed_at)
VALUES
  ('d19e0000-0000-4000-8000-000000000001'::uuid, 'd19e0000-0000-4000-8000-0000000000e1'::uuid,
   'dg-subj', 8, 10, 80, 600, 0, (pg_temp.wk() + INTERVAL '1 day') AT TIME ZONE 'UTC'),
  ('d19e0000-0000-4000-8000-000000000001'::uuid, 'd19e0000-0000-4000-8000-0000000000e1'::uuid,
   'dg-subj', 6, 10, 60, 600, 0, (pg_temp.wk() + INTERVAL '2 days') AT TIME ZONE 'UTC'),
  ('d19e0000-0000-4000-8000-000000000001'::uuid, 'd19e0000-0000-4000-8000-0000000000e1'::uuid,
   'dg-subj', 4, 10, 40, 600, 0, (pg_temp.wk() + INTERVAL '3 days') AT TIME ZONE 'UTC'),
  -- La semaine PRÉCÉDENTE : une seule mission, moyenne 30. Elle est ici pour
  -- que les deux fenêtres rendent des nombres DIFFÉRENTS — deux fenêtres qui
  -- rendraient le même total ne prouveraient pas qu'elles sont distinctes.
  ('d19e0000-0000-4000-8000-000000000001'::uuid, 'd19e0000-0000-4000-8000-0000000000e1'::uuid,
   'dg-subj', 3, 10, 30, 300, 0, (pg_temp.wk() - INTERVAL '6 days') AT TIME ZONE 'UTC');

-- Trois erreurs, une seule ACTIVE ET nommée par le registre :
--   * la nominale passe le seuil R-2 (≥ 3 occurrences, ≥ 2 séances, 30 j) ;
--   * la deuxième est installée mais vue sur UNE séance → hors seuil ;
--   * la troisième passe le seuil mais n'est dans AUCUN registre → la jointure
--     interne l'écarte, plutôt que d'envoyer un identifiant technique au modèle.
INSERT INTO public.user_misconceptions (user_id, tag, occurrences, sessions_seen, last_seen_at)
VALUES
  ('d19e0000-0000-4000-8000-000000000001'::uuid, 'dg.frac.add-denominators', 5, 3, now() - INTERVAL '2 days'),
  ('d19e0000-0000-4000-8000-000000000001'::uuid, 'dg.une-seule-seance',      7, 1, now() - INTERVAL '2 days'),
  ('d19e0000-0000-4000-8000-000000000001'::uuid, 'dg.hors-registre',         9, 4, now() - INTERVAL '1 day');

-- Les bilans déjà rédigés. Insérés en direct (rôle propriétaire) : la RPC
-- d'écriture est éprouvée plus bas, ce décor-ci sert à juger les LECTURES.
INSERT INTO public.tutor_digests (user_id, week_start, audience, lang, body, model) VALUES
  ('d19e0000-0000-4000-8000-000000000001'::uuid, pg_temp.wk(), 'student', 'fr',
   'Bilan élève de la semaine', 'modele-eleve'),
  ('d19e0000-0000-4000-8000-000000000001'::uuid, pg_temp.wk(), 'parent', 'fr',
   'Bilan parent de la semaine', 'modele-parent'),
  ('d19e0000-0000-4000-8000-000000000002'::uuid, pg_temp.wk(), 'student', 'fr',
   'Bilan d''un autre élève', 'modele-eleve');

-- =========================================================
-- 1. La table : ce qu'elle ne peut pas porter, et qui ne peut pas l'écrire.
-- =========================================================
-- ⭐ LE CONTRÔLE NÉGATIF DE Q-5. Le parent voit un texte AGRÉGÉ ; aucune
-- colonne ne doit pouvoir contenir une phrase de la conversation. La garantie
-- la plus solide n'est pas « la RPC ne le rend pas » — c'est que la donnée
-- n'existe pas dans la table. Un jour où quelqu'un ajouterait `transcript` pour
-- « aider au debug », cette assertion tombe.
SELECT is(
  (SELECT count(*)::int FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'tutor_digests'
      AND column_name IN ('messages', 'summary', 'transcript', 'conversation',
                          'context_snapshot', 'thread_id')),
  0,
  'Q-5 ⭐ : la table des bilans n''a AUCUNE colonne capable de porter un verbatim de conversation'
);

SELECT ok(
  NOT has_table_privilege('anon', 'public.tutor_digests', 'SELECT'),
  'Grants : anon ne lit rien des bilans — un mineur ne se résume pas au porteur d''un lien public'
);

SELECT ok(
  NOT has_table_privilege('authenticated', 'public.tutor_digests', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.tutor_digests', 'UPDATE')
  AND NOT has_table_privilege('authenticated', 'public.tutor_digests', 'DELETE'),
  'Grants ⭐ : aucune écriture pour authenticated — sinon un élève s''écrirait un bilan flatteur, et un parent en écrirait un à son enfant'
);

-- =========================================================
-- 2. La RLS : chaque audience ne lit que ce qui lui est adressé.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"d19e0000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.tutor_digests
    WHERE user_id = 'd19e0000-0000-4000-8000-000000000001'::uuid AND audience = 'student'),
  1,
  'l''élève lit le bilan écrit POUR LUI'
);

SELECT is(
  (SELECT count(*)::int FROM public.tutor_digests WHERE audience = 'parent'),
  0,
  'l''élève ne lit PAS le bilan parent qui parle de lui — un texte adressé à quelqu''un d''autre, dans un autre registre'
);

SELECT is(
  (SELECT count(*)::int FROM public.tutor_digests
    WHERE user_id = 'd19e0000-0000-4000-8000-000000000002'::uuid),
  0,
  'l''élève ne lit pas le bilan d''un autre élève'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"d19e0000-0000-4000-8000-000000000003","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.tutor_digests
    WHERE user_id = 'd19e0000-0000-4000-8000-000000000001'::uuid),
  1,
  'le parent LIÉ ACTIF lit le bilan parent de son enfant, et lui seul'
);

-- ⭐ La ligne que le brief nomme explicitement : lié ou non, le parent ne lit
-- jamais le texte tutoyé écrit pour l'enfant.
SELECT is(
  (SELECT count(*)::int FROM public.tutor_digests WHERE audience = 'student'),
  0,
  'Q-5 ⭐ : même LIÉ, le parent ne lit pas le bilan d''audience student — la policy porte sur l''audience, pas seulement sur le lien'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"d19e0000-0000-4000-8000-000000000004","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.tutor_digests),
  0,
  'Q-5 ⭐ : un lien parent COUPÉ ne lit RIEN — un parent séparé ou un compte révoqué cesse d''observer un mineur'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"d19e0000-0000-4000-8000-000000000005","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.tutor_digests),
  0,
  'Q-5 ⭐ : un tiers sans aucun lien ne lit RIEN'
);

RESET ROLE;

-- =========================================================
-- 3. L'écriture : le batch, et lui seul.
-- =========================================================
-- Photo d'avant, pour R-11 : un bilan ne verse RIEN.
CREATE TEMP TABLE dg_economie AS
  SELECT xp, yahia_coins, level FROM public.profiles
   WHERE id = 'd19e0000-0000-4000-8000-000000000001';

-- Deux écritures sur la MÊME semaine, la seconde datée d'un mercredi : c'est
-- le scénario réel d'une reprise après incident. Elle doit REMPLACER, pas
-- empiler — et retomber sur le lundi.
SELECT public.store_tutor_digest(
  'd19e0000-0000-4000-8000-000000000001'::uuid, pg_temp.wk() - 7, 'student',
  'Premier jet', 'modele-a', 'fr'
);
SELECT public.store_tutor_digest(
  'd19e0000-0000-4000-8000-000000000001'::uuid, (pg_temp.wk() - 7) + 2, 'student',
  'Second jet, écrit un mercredi', 'modele-b', 'ar'
);

SELECT is(
  (SELECT count(*)::int FROM public.tutor_digests
    WHERE user_id = 'd19e0000-0000-4000-8000-000000000001'::uuid
      AND week_start = pg_temp.wk() - 7),
  1,
  '⭐ le batch est REJOUABLE : deux exécutions pour la même semaine laissent UNE ligne, pas deux bilans contradictoires'
);

SELECT is(
  (SELECT body FROM public.tutor_digests
    WHERE user_id = 'd19e0000-0000-4000-8000-000000000001'::uuid
      AND week_start = pg_temp.wk() - 7 AND audience = 'student'),
  'Second jet, écrit un mercredi',
  'la ré-exécution REMPLACE le texte — un bilan corrigé doit remplacer celui qui était faux'
);

SELECT is(
  (SELECT count(*)::int FROM public.tutor_digests
    WHERE user_id = 'd19e0000-0000-4000-8000-000000000001'::uuid
      AND week_start = (pg_temp.wk() - 7) + 2),
  0,
  '⭐ la semaine est NORMALISÉE au lundi : un mercredi passé par le batch ne crée pas une seconde semaine qui recouvrirait la première'
);

SELECT is(
  (SELECT xp || '/' || yahia_coins || '/' || level FROM public.profiles
    WHERE id = 'd19e0000-0000-4000-8000-000000000001'),
  (SELECT xp || '/' || yahia_coins || '/' || level FROM dg_economie),
  'R-11 ⭐ : écrire un bilan ne verse AUCUN XP, AUCUNE pièce, aucun niveau — un bilan n''est pas un geste de jeu'
);

SELECT throws_ok(
  $$ SELECT public.store_tutor_digest(
       'd19e0000-0000-4000-8000-000000000001'::uuid, CURRENT_DATE, 'student', '   ', NULL, 'fr') $$,
  'P0001',
  'EMPTY_DIGEST',
  'un corps vide est REFUSÉ — figer un écran blanc pour une semaine serait pire qu''un batch qui échoue bruyamment'
);

SELECT ok(
  NOT has_function_privilege('authenticated',
    'public.store_tutor_digest(uuid,date,text,text,text,text)', 'EXECUTE'),
  'Grants ⭐ : authenticated n''écrit pas de bilan — la RPC est réservée au batch en service_role'
);

-- =========================================================
-- 4. Les FAITS de la semaine (R-10) et leur dépersonnalisation (R-14).
-- =========================================================
SELECT is(
  (public.get_tutor_digest_inputs(
     'd19e0000-0000-4000-8000-000000000001'::uuid, pg_temp.wk()))->'thisWeek'->>'missions',
  '3',
  'R-10 : la semaine résumée est comptée en SQL — trois missions, arrêtées avant tout appel de modèle'
);

SELECT is(
  (public.get_tutor_digest_inputs(
     'd19e0000-0000-4000-8000-000000000001'::uuid, pg_temp.wk()))->'lastWeek'->>'missions',
  '1',
  'R-10 ⭐ : la semaine PRÉCÉDENTE est une fenêtre distincte — sans elle, « 3 missions » ne dit rien'
);

SELECT is(
  (public.get_tutor_digest_inputs(
     'd19e0000-0000-4000-8000-000000000001'::uuid, pg_temp.wk()))->'delta'->>'avgScore',
  '30',
  'R-10 ⭐ : l''écart est CALCULÉ ici (60 − 30), pas laissé à la soustraction d''un modèle'
);

SELECT is(
  (SELECT jsonb_array_length((public.get_tutor_digest_inputs(
     'd19e0000-0000-4000-8000-000000000001'::uuid, pg_temp.wk()))->'topErrors')),
  1,
  'R-2 ⭐ : une seule erreur retenue — la deuxième n''a qu''une séance, la troisième n''est dans aucun registre et n''a donc pas de phrase à donner au modèle'
);

-- ⭐⭐ L'ASSERTION QUI COMPTE. Ce JSON quitte l'infrastructure : le nom, le
-- courriel et l'identifiant de l'élève ne doivent apparaître dans aucun octet.
SELECT ok(
  (public.get_tutor_digest_inputs(
     'd19e0000-0000-4000-8000-000000000001'::uuid, pg_temp.wk()))::text NOT LIKE '%Yahia%'
  AND (public.get_tutor_digest_inputs(
     'd19e0000-0000-4000-8000-000000000001'::uuid, pg_temp.wk()))::text NOT LIKE '%dg-eleve%'
  AND (public.get_tutor_digest_inputs(
     'd19e0000-0000-4000-8000-000000000001'::uuid, pg_temp.wk()))::text NOT LIKE '%d19e0000%'
  AND (public.get_tutor_digest_inputs(
     'd19e0000-0000-4000-8000-000000000001'::uuid, pg_temp.wk()))::text NOT LIKE '%dg.frac%',
  'R-14 ⭐⭐ : le bloc envoyé au fournisseur ne porte NI nom, NI e-mail, NI UUID, NI tag technique — le contrôle est négatif, sur un appât planté dans le profil'
);

SELECT is(
  (public.get_tutor_digest_inputs(
     'd19e0000-0000-4000-8000-000000000001'::uuid, pg_temp.wk()))->>'ageBand',
  '12-14',
  'R-14 : l''âge est une BANDE dérivée de la classe (display_order 9) — aucune date de naissance n''est jamais lue'
);

SELECT ok(
  NOT has_function_privilege('authenticated',
    'public.get_tutor_digest_inputs(uuid,date)', 'EXECUTE'),
  'Grants ⭐ : la source des faits n''est PAS exposée aux sessions — seul le batch la lit, et il la dépersonnalise avant de l''envoyer'
);

-- =========================================================
-- 5. La lecture, et son dégradé (R-15).
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"d19e0000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_tutor_digest())->>'body',
  'Bilan élève de la semaine',
  'sans argument, l''élève reçoit son bilan le PLUS RÉCENT — un bilan produit le dimanche resterait invisible six jours sur sept autrement'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"d19e0000-0000-4000-8000-000000000006","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_tutor_digest())->>'available',
  'false',
  'R-15 ⭐ : un élève sans bilan reçoit un ÉTAT rendu, pas une exception — une semaine calme n''est pas un écran cassé'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"d19e0000-0000-4000-8000-000000000003","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_tutor_parent_digest('d19e0000-0000-4000-8000-000000000001'::uuid))->>'body',
  'Bilan parent de la semaine',
  'Q-5 : le parent LIÉ ACTIF reçoit le bilan écrit pour lui'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"d19e0000-0000-4000-8000-000000000004","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- ⭐ Refuser, et non rendre `available: false` : « lien à rétablir » et « bilan
-- pas encore écrit » demandent deux gestes opposés à un parent. Les confondre
-- ferait attendre dimanche quelqu'un dont le lien est simplement coupé.
SELECT throws_ok(
  $$ SELECT public.get_tutor_parent_digest('d19e0000-0000-4000-8000-000000000001'::uuid) $$,
  'P0001',
  'NOT_LINKED',
  'Q-5 ⭐ : un lien parent INACTIF est REFUSÉ — pas servi vide, ce qui se confondrait avec « pas encore de bilan »'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"d19e0000-0000-4000-8000-000000000005","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.get_tutor_parent_digest('d19e0000-0000-4000-8000-000000000001'::uuid) $$,
  'P0001',
  'NOT_LINKED',
  'Q-5 : un tiers sans lien est refusé — et par un P0001, donc le GRANT existe bien et c''est la garde qui a parlé'
);

RESET ROLE;

-- =========================================================
-- 6. Les rétentions R-14 : elles suppriment, et elles s'arrêtent.
-- =========================================================
INSERT INTO public.tutor_digests (user_id, week_start, audience, lang, body, model)
VALUES ('d19e0000-0000-4000-8000-000000000001'::uuid,
        public.tutor_week_start(CURRENT_DATE - 400), 'student', 'fr',
        'Bilan d''il y a plus d''un an', 'modele-ancien');

-- Deux fils : l'un abandonné depuis sept mois, l'autre vivant. Le vieux est
-- `closed` — l'index unique partiel n'admet qu'un fil ACTIF par (élève,
-- chapitre), et un fil qu'on n'a pas rouvert depuis sept mois l'est de fait.
INSERT INTO public.tutor_threads
  (id, user_id, scope, chapter_id, lang, age_band, status, created_at, updated_at)
VALUES
  ('d19e0000-0000-4000-8000-0000000000b1'::uuid, 'd19e0000-0000-4000-8000-000000000001'::uuid,
   'chapter', 'd19e0000-0000-4000-8000-0000000000c1'::uuid, 'fr', '12-14', 'closed',
   now() - INTERVAL '8 months', now() - INTERVAL '7 months'),
  ('d19e0000-0000-4000-8000-0000000000b2'::uuid, 'd19e0000-0000-4000-8000-000000000001'::uuid,
   'chapter', 'd19e0000-0000-4000-8000-0000000000c1'::uuid, 'fr', '12-14', 'active',
   now() - INTERVAL '9 months', now() - INTERVAL '2 days');

SELECT public.purge_tutor_digests();
SELECT public.purge_tutor_threads();

SELECT is(
  (SELECT count(*)::int FROM public.tutor_digests
    WHERE user_id = 'd19e0000-0000-4000-8000-000000000001'::uuid
      AND week_start < (CURRENT_DATE - INTERVAL '12 months')::DATE),
  0,
  'R-14 ⭐ : les bilans de plus de 12 mois sont supprimés'
);

SELECT is(
  (SELECT count(*)::int FROM public.tutor_digests
    WHERE user_id = 'd19e0000-0000-4000-8000-000000000001'::uuid
      AND week_start = pg_temp.wk()),
  2,
  'R-14 ⭐ : la purge S''ARRÊTE — les bilans vivants survivent. Un DELETE sans WHERE passerait l''assertion précédente et échouerait ici'
);

SELECT is(
  (SELECT count(*)::int FROM public.tutor_threads
    WHERE id = 'd19e0000-0000-4000-8000-0000000000b1'::uuid),
  0,
  'R-14 ⭐ : la purge des FILS à 6 mois existe enfin — promise dans le COMMENT de tutor_threads depuis le lot 1, aucun job ne l''exécutait'
);

SELECT is(
  (SELECT count(*)::int FROM public.tutor_threads
    WHERE id = 'd19e0000-0000-4000-8000-0000000000b2'::uuid),
  1,
  'R-14 ⭐ : un fil OUVERT il y a neuf mois mais rouvert avant-hier RESTE — la rétention se mesure sur la dernière fois qu''un enfant a parlé, pas sur la première'
);

SELECT ok(
  NOT has_function_privilege('authenticated', 'public.purge_tutor_digests()', 'EXECUTE')
  AND NOT has_function_privilege('authenticated', 'public.purge_tutor_threads()', 'EXECUTE'),
  'Grants : les purges ne sont exécutables par personne d''autre que le planificateur — un appel depuis une session effacerait l''historique de tout le monde'
);

SELECT * FROM finish();
ROLLBACK;
