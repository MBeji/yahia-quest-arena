-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: iq-training-fr (Muscle ton cerveau — Entraînement QI (FR))
-- Regenerate with: npm run content:build
-- Source of truth: content/iq-training-fr/
-- =========================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'exercises_mode_check') THEN
    ALTER TABLE public.exercises DROP CONSTRAINT exercises_mode_check;
  END IF;
  ALTER TABLE public.exercises
    ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss', 'quiz', 'challenge'));
END $$;

INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order, content_language, is_premium, theme_id, grade_id) VALUES
  ('iq-training-fr', 'Muscle ton cerveau — Entraînement QI (FR)', 'Des défis visuels de logique pure : observe la figure, déduis la règle cachée, choisis la bonne réponse — aucune mémoire, que du raisonnement.', 'Logique', 'subject-math', 'Brain', 60, 'fr', false, 'muscle-cerveau', NULL)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr,
  description = EXCLUDED.description,
  attribute = EXCLUDED.attribute,
  color_token = EXCLUDED.color_token,
  icon = EXCLUDED.icon,
  display_order = EXCLUDED.display_order,
  content_language = EXCLUDED.content_language,
  is_premium = EXCLUDED.is_premium,
  theme_id = EXCLUDED.theme_id,
  grade_id = EXCLUDED.grade_id;

-- Prune admin-authored content that is no longer in the source tree.
DO $$
BEGIN
  IF to_regclass('public.dungeon_run_questions') IS NOT NULL THEN
    DELETE FROM public.dungeon_run_questions d
    USING public.questions q, public.exercises e
    WHERE d.question_id = q.id
      AND q.exercise_id = e.id
      AND e.subject_id = 'iq-training-fr'
      AND e.source = 'admin'
      AND q.id NOT IN ('7c0f6897-cf03-5f3b-80d9-00b91d12ecfa', '3645e716-151b-50bc-90aa-b455b3a67223', '4b0df262-0227-57e1-9400-b70cf27ed456', '30fc5820-fd1e-58af-b3cb-aa757695d61a', '65892922-f253-5ed5-9453-42a2c33a46af', '9e806a6e-8b3a-5e21-a782-e3a09756a4fb', 'cca97f2b-3298-5382-bf90-5c01fd3e98ff', 'ae43cb5a-4fe5-5f90-8213-3d4cc965f1a4', '415526d1-a445-5ef0-802a-b0cb09981760', 'e3f134c5-32a2-587a-9bd9-c910b766d4d6', '5ac76dd6-8638-58e8-abed-7975f79148b8', 'dfe40371-697e-5362-ad9b-33e76e0e793e', 'ef36fab6-25d4-5bec-929b-1a0c462de1a6', '17e4190f-2881-5efb-a79b-493caaf9b138', '09bd6e27-5972-57ef-996f-fa22ae19e457', '2eef23b9-2e2c-56e6-81b7-06a91cd1d9ba', '2fb8d33b-2b59-53a7-8f38-0ea70444a478', 'f9d02d75-3bc5-59a9-b0c2-834508fa5b3b', 'e7346b4c-f88c-5b6f-a0e4-17be32d59f0a', '90184c02-c321-5695-ae42-a12e3e05e540', '99daffa1-aa81-5112-bf53-f536ff68e009', '68ebeba9-6eb3-53cc-8fd0-bba593a01979', 'bda2e0b3-73b0-529f-a96f-ff37f515e2a1');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'iq-training-fr' AND source = 'admin' AND id NOT IN ('02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'b0b641df-a429-576c-a050-3ef46d05aa72', '0f3b76c5-0078-590d-abb8-090763eb1855', '4629386d-31c9-52f2-8a06-04546c5f0e21');
DELETE FROM public.questions WHERE exercise_id IN ('02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'b0b641df-a429-576c-a050-3ef46d05aa72', '0f3b76c5-0078-590d-abb8-090763eb1855', '4629386d-31c9-52f2-8a06-04546c5f0e21') AND id NOT IN ('7c0f6897-cf03-5f3b-80d9-00b91d12ecfa', '3645e716-151b-50bc-90aa-b455b3a67223', '4b0df262-0227-57e1-9400-b70cf27ed456', '30fc5820-fd1e-58af-b3cb-aa757695d61a', '65892922-f253-5ed5-9453-42a2c33a46af', '9e806a6e-8b3a-5e21-a782-e3a09756a4fb', 'cca97f2b-3298-5382-bf90-5c01fd3e98ff', 'ae43cb5a-4fe5-5f90-8213-3d4cc965f1a4', '415526d1-a445-5ef0-802a-b0cb09981760', 'e3f134c5-32a2-587a-9bd9-c910b766d4d6', '5ac76dd6-8638-58e8-abed-7975f79148b8', 'dfe40371-697e-5362-ad9b-33e76e0e793e', 'ef36fab6-25d4-5bec-929b-1a0c462de1a6', '17e4190f-2881-5efb-a79b-493caaf9b138', '09bd6e27-5972-57ef-996f-fa22ae19e457', '2eef23b9-2e2c-56e6-81b7-06a91cd1d9ba', '2fb8d33b-2b59-53a7-8f38-0ea70444a478', 'f9d02d75-3bc5-59a9-b0c2-834508fa5b3b', 'e7346b4c-f88c-5b6f-a0e4-17be32d59f0a', '90184c02-c321-5695-ae42-a12e3e05e540', '99daffa1-aa81-5112-bf53-f536ff68e009', '68ebeba9-6eb3-53cc-8fd0-bba593a01979', 'bda2e0b3-73b0-529f-a96f-ff37f515e2a1');
DELETE FROM public.chapters c WHERE c.subject_id = 'iq-training-fr' AND c.id NOT IN ('b809d08f-d131-5d5a-9a43-0be3a6e49aeb') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('b809d08f-d131-5d5a-9a43-0be3a6e49aeb', 'iq-training-fr', 'Raisonnement visuel', 'Matrices, suites de formes, rotations, symétries et intrus : trouve la règle cachée dans chaque figure et applique-la.', '# 🧠 Entraînement — aucune leçon. Observe chaque figure, déduis la règle, applique-la.

Ici on ne révise rien : chaque mission est une énigme à résoudre par pure déduction. Fais confiance à ton œil et à ta logique. 💪', '📜 Résous par déduction, jamais par mémoire.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'b809d08f-d131-5d5a-9a43-0be3a6e49aeb', 'iq-training-fr', 'Échauffement visuel ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c0f6897-cf03-5f3b-80d9-00b91d12ecfa', '02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'Observe la suite de cercles. Quel cercle continue la série ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="15" cy="50" r="6" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="38" cy="50" r="11" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="68" cy="50" r="16" fill="none" stroke="#1d4ed8" stroke-width="2"/><text x="92" y="56" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"21\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"16\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"6\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"21\" fill=\"#1d4ed8\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'La règle cachée : le rayon grandit de 5 à chaque étape (6, 11, 16…). ✓ Le suivant vaut donc 21, soit l''option a. L''option b (16) répète le dernier cercle au lieu d''augmenter. L''option c (6) revient au tout premier. L''option d a la bonne taille mais devient pleine : la couleur n''a jamais changé dans la série, on ne doit pas inventer une nouvelle règle.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3645e716-151b-50bc-90aa-b455b3a67223', '02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'Trois figures suivent la même règle, une seule est l''intrus. Laquelle ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="40" width="18" height="18" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/><rect x="32" y="40" width="18" height="18" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/><rect x="56" y="40" width="18" height="18" fill="none" stroke="#7c3aed" stroke-width="2"/><rect x="80" y="40" width="18" height="18" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">1</text></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">2</text></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">3</text></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">4</text></svg>"}]'::jsonb, 'c', 'La règle commune : tous les carrés sont pleins. ✓ Le carré n°3 est le seul vide (juste un contour), c''est donc l''intrus, l''option c. Les options a, b et d montrent des carrés pleins, identiques aux autres : ils respectent la règle et ne peuvent pas être l''intrus.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b0df262-0227-57e1-9400-b70cf27ed456', '02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'À gauche, une flèche modèle. Choisis son image dans un miroir vertical (gauche-droite). <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><line x1="30" y1="50" x2="70" y2="50" stroke="#0f766e" stroke-width="4"/><polyline points="56,38 70,50 56,62" fill="none" stroke="#0f766e" stroke-width="4"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"56,38 70,50 56,62\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"70\" y1=\"50\" x2=\"30\" y2=\"50\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"44,38 30,50 44,62\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"70\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"38,56 50,70 62,56\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"70\" x2=\"50\" y2=\"30\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"38,44 50,30 62,44\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'b', 'Un miroir vertical échange la gauche et la droite : une flèche qui pointe à droite pointe alors à gauche. ✓ C''est l''option b. L''option a est identique au modèle (aucune réflexion). Les options c et d pointent vers le bas et vers le haut : ce serait une rotation, pas un miroir gauche-droite.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30fc5820-fd1e-58af-b3cb-aa757695d61a', '02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'Une seule flèche tourne d''un quart de tour dans le sens des aiguilles d''une montre à chaque étape. Que vient ensuite ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><g><line x1="12" y1="58" x2="12" y2="30" stroke="#b45309" stroke-width="4"/><polyline points="5,38 12,30 19,38" fill="none" stroke="#b45309" stroke-width="4"/></g><g><line x1="40" y1="44" x2="68" y2="44" stroke="#b45309" stroke-width="4"/><polyline points="60,37 68,44 60,51" fill="none" stroke="#b45309" stroke-width="4"/></g><text x="88" y="50" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"32\" x2=\"50\" y2=\"68\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"42,60 50,68 58,60\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"68\" y1=\"50\" x2=\"32\" y2=\"50\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"40,42 32,50 40,58\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"68\" x2=\"50\" y2=\"32\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"42,40 50,32 58,40\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"32\" y1=\"50\" x2=\"68\" y2=\"50\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"60,42 68,50 60,58\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'a', 'La flèche pointe d''abord vers le haut, puis vers la droite : c''est un quart de tour horaire. ✓ Le pas suivant donne une flèche vers le bas, soit l''option a. L''option d (vers la droite) répète l''étape précédente. L''option b (vers la gauche) tourne dans le mauvais sens. L''option c (vers le haut) revient au point de départ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('65892922-f253-5ed5-9453-42a2c33a46af', '02a8bde6-52d8-5f69-b70c-572f2bbfb535', 'Observe le nombre de côtés des polygones. Quelle figure complète la suite ? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="18,58 8,42 28,42" fill="none" stroke="#be123c" stroke-width="2"/><rect x="40" y="40" width="18" height="18" fill="none" stroke="#be123c" stroke-width="2"/><polygon points="78,38 88,46 84,58 72,58 68,46" fill="none" stroke="#be123c" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,32 64,42 59,58 41,58 36,42\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,32 62,39 62,53 50,60 38,53 38,39\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,33 58,58 38,42 62,42 42,58\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'La règle : le nombre de côtés augmente de 1 à chaque pas — triangle (3), carré (4), pentagone (5). ✓ Le suivant doit avoir 6 côtés, donc l''hexagone de l''option b. L''option a est un pentagone (5 côtés), elle répète la figure précédente. L''option c est un carré (4 côtés), déjà passé. L''option d est une étoile à 5 branches : on a compté les pointes au lieu des côtés du polygone.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b0b641df-a429-576c-a050-3ef46d05aa72', 'b809d08f-d131-5d5a-9a43-0be3a6e49aeb', 'iq-training-fr', '⭐ Échauffement', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e806a6e-8b3a-5e21-a782-e3a09756a4fb', 'b0b641df-a429-576c-a050-3ef46d05aa72', 'Observe la suite : le nombre de points augmente de 1 à chaque étape. Quelle figure vient ensuite ? <svg viewBox="0 0 100 100"><rect x="2" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2"/><circle cx="13" cy="50" r="4" fill="#222"/><rect x="27" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2"/><circle cx="33" cy="50" r="4" fill="#222"/><circle cx="43" cy="50" r="4" fill="#222"/><rect x="52" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2"/><circle cx="57" cy="50" r="4" fill="#222"/><circle cx="63" cy="50" r="4" fill="#222"/><circle cx="69" cy="50" r="4" fill="#222"/><rect x="77" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2" stroke-dasharray="3 3"/><text x="88" y="55" font-size="16" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"38\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"62\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"38\" r=\"5\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"38\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"62\" cy=\"50\" r=\"5\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"34\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"45\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"56\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"67\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"38\" r=\"5\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"42\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"58\" cy=\"50\" r=\"5\" fill=\"#222\"/></svg>"}]'::jsonb, 'a', 'La règle est : +1 point à chaque case (1, puis 2, puis 3). La case suivante doit donc contenir 4 points → l''option a ✓. Le piège : b répète 3 points (on a oublié d''ajouter), d revient à 2 points (on lit la suite à l''envers) et c en met 5 (on a sauté une étape). On ajoute UN seul point par étape, donc 3 + 1 = 4.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cca97f2b-3298-5382-bf90-5c01fd3e98ff', 'b0b641df-a429-576c-a050-3ef46d05aa72', 'La flèche tourne d''un quart de tour (90°) dans le sens des aiguilles d''une montre à chaque étape : haut, droite, bas… Quelle est l''étape suivante ? <svg viewBox="0 0 100 100"><g stroke="#222" stroke-width="3" fill="#222"><line x1="15" y1="62" x2="15" y2="38"/><polygon points="15,30 10,40 20,40"/></g><g stroke="#222" stroke-width="3" fill="#222"><line x1="38" y1="50" x2="62" y2="50"/><polygon points="70,50 60,45 60,55"/></g><g stroke="#222" stroke-width="3" fill="#222"><line x1="85" y1="38" x2="85" y2="62"/><polygon points="85,70 80,60 90,60"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"62\" x2=\"50\" y2=\"38\"/><polygon points=\"50,30 44,40 56,40\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\"/><polygon points=\"70,50 60,44 60,56\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"62\" y1=\"50\" x2=\"38\" y2=\"50\"/><polygon points=\"30,50 40,44 40,56\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"38\" x2=\"50\" y2=\"62\"/><polygon points=\"50,70 44,60 56,60\"/></g></svg>"}]'::jsonb, 'c', 'À chaque pas la flèche tourne de 90° dans le sens horaire : haut → droite → bas → gauche. Après « bas » vient donc « gauche » → l''option c ✓. Le piège : a (haut) et b (droite) reviennent en arrière dans la suite, et d (bas) répète l''étape précédente. Il faut continuer la rotation, pas la stopper ni l''inverser.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae43cb5a-4fe5-5f90-8213-3d4cc965f1a4', 'b0b641df-a429-576c-a050-3ef46d05aa72', 'Trois de ces figures suivent la même règle, une seule est différente. Quel est l''intrus ? <svg viewBox="0 0 100 100"><text x="50" y="55" font-size="12" text-anchor="middle" fill="#222">3 triangles + 1 carré</text><polygon points="50,15 40,30 60,30" fill="none" stroke="#222" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,25 30,70 70,70\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"25,70 50,25 75,70\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,30 70,40 45,72\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'La règle est : chaque figure est un triangle (3 côtés). L''intrus est l''option c ✓, qui est un carré (4 côtés). On compte les côtés : a, b et d en ont 3, seul c en a 4. Le piège est de regarder la taille ou l''orientation au lieu du nombre de côtés ; ici c''est bien le carré qui rompt la règle « 3 côtés ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('415526d1-a445-5ef0-802a-b0cb09981760', 'b0b641df-a429-576c-a050-3ef46d05aa72', 'Le petit carré noir se déplace d''un coin à chaque étape, dans le sens des aiguilles d''une montre. Où sera-t-il ensuite ? <svg viewBox="0 0 100 100"><rect x="4" y="38" width="24" height="24" fill="none" stroke="#222" stroke-width="2"/><rect x="6" y="40" width="7" height="7" fill="#222"/><rect x="38" y="38" width="24" height="24" fill="none" stroke="#222" stroke-width="2"/><rect x="53" y="40" width="7" height="7" fill="#222"/><rect x="72" y="38" width="24" height="24" fill="none" stroke="#222" stroke-width="2"/><rect x="87" y="53" width="7" height="7" fill="#222"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"32\" y=\"32\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"58\" y=\"32\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"58\" y=\"58\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"32\" y=\"58\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"}]'::jsonb, 'd', 'Le carré noir tourne dans le sens horaire : haut-gauche → haut-droite → bas-droite → bas-gauche. Après le coin bas-droite vient donc le coin bas-gauche → l''option d ✓. Le piège : c répète le bas-droite (étape précédente), b (haut-droite) et a (haut-gauche) reviennent en arrière. On poursuit la rotation jusqu''au coin suivant.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3f134c5-32a2-587a-9bd9-c910b766d4d6', 'b0b641df-a429-576c-a050-3ef46d05aa72', 'Trois ronds suivent la même règle, un seul est différent. Quel est l''intrus ? <svg viewBox="0 0 100 100"><text x="50" y="45" font-size="11" text-anchor="middle" fill="#222">3 ronds pleins</text><text x="50" y="60" font-size="11" text-anchor="middle" fill="#222">+ 1 rond vide</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"48\" cy=\"50\" r=\"24\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"24\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"24\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"52\" cy=\"50\" r=\"24\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'La règle est : chaque rond est plein (rempli de noir). L''intrus est l''option b ✓, le seul rond vide (juste un contour). a, c et d sont identiques et pleins ; b rompt la règle du remplissage. Le piège est de chercher une différence de taille ou de position : ici toutes les tailles sont égales, c''est le remplissage qui distingue b.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ac76dd6-8638-58e8-abed-7975f79148b8', 'b0b641df-a429-576c-a050-3ef46d05aa72', 'Observe la suite des polygones : le nombre de côtés augmente de 1 à chaque étape (3, puis 4, puis 5…). Quelle figure vient ensuite ? <svg viewBox="0 0 100 100"><polygon points="15,68 5,82 25,82" fill="none" stroke="#222" stroke-width="2"/><polygon points="33,30 51,30 51,48 33,48" fill="none" stroke="#222" stroke-width="2"/><polygon points="70,28 82,37 78,51 62,51 58,37" fill="none" stroke="#222" stroke-width="2"/><text x="50" y="92" font-size="10" text-anchor="middle" fill="#888">3 côtés, 4 côtés, 5 côtés, ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"32,32 68,32 68,68 32,68\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,20 73,33 73,60 50,73 27,60 27,33\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,22 71,37 63,62 37,62 29,37\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,20 70,30 75,52 62,70 38,70 25,52 30,30\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'b', 'La règle est : +1 côté à chaque étape (triangle 3, carré 4, pentagone 5…). Le polygone suivant doit avoir 6 côtés → l''hexagone, option b ✓. Le piège : c est un pentagone (5 côtés, on a oublié d''ajouter), a un carré (4, retour en arrière) et d un heptagone (7, on a sauté de deux). On ajoute UN seul côté, donc 5 + 1 = 6.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0f3b76c5-0078-590d-abb8-090763eb1855', 'b809d08f-d131-5d5a-9a43-0be3a6e49aeb', 'iq-training-fr', '⚔️ Défi logique ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dfe40371-697e-5362-ad9b-33e76e0e793e', '0f3b76c5-0078-590d-abb8-090763eb1855', 'La flèche tourne d''un quart de tour (90°) dans le sens des aiguilles d''une montre à chaque étape. Quelle flèche vient ensuite ? <svg viewBox="0 0 100 100"><line x1="15" y1="75" x2="15" y2="30" stroke="#1f2937" stroke-width="4"/><polygon points="8,38 22,38 15,24" fill="#1f2937"/><line x1="40" y1="50" x2="85" y2="50" stroke="#1f2937" stroke-width="4"/><polygon points="77,43 77,57 91,50" fill="#1f2937"/><line x1="60" y1="25" x2="60" y2="70" stroke="#1f2937" stroke-width="4"/><polygon points="53,62 67,62 60,76" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"75\" y1=\"50\" x2=\"30\" y2=\"50\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"38,42 38,58 22,50\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"25\" y1=\"50\" x2=\"70\" y2=\"50\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"62,42 62,58 78,50\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"75\" x2=\"50\" y2=\"30\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"42,38 58,38 50,22\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"42,62 58,62 50,78\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'La règle cachée : +90° dans le sens horaire à chaque étape. Haut → droite → bas → gauche. ✓ L''option a pointe vers la gauche : c''est la suite correcte. L''option d (vers le bas) répète l''étape précédente sans tourner. L''option c (vers le haut) revient en arrière (rotation inverse). L''option b (vers la droite) saute une étape. Astuce : suis toujours le même sens de rotation, sans sauter ni revenir.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef36fab6-25d4-5bec-929b-1a0c462de1a6', '0f3b76c5-0078-590d-abb8-090763eb1855', 'A est à B ce que C est à ? — observe la transformation entre les deux premières figures, puis applique-la. <svg viewBox="0 0 100 100"><rect x="8" y="38" width="16" height="16" fill="none" stroke="#1f2937" stroke-width="3"/><text x="32" y="52" font-size="12" fill="#1f2937">:</text><rect x="40" y="26" width="40" height="40" fill="none" stroke="#1f2937" stroke-width="3"/><text x="86" y="52" font-size="12" fill="#1f2937">::</text><circle cx="96" cy="46" r="3" fill="none" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"8\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"30\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"30\" fill=\"#1f2937\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'La règle cachée : la figure grandit fortement, la forme et le contour restant identiques (un petit carré vide devient un grand carré vide). On applique le même agrandissement au petit cercle vide. ✓ L''option c est un grand cercle vide : c''est la bonne analogie. L''option b garde la petite taille (aucune transformation). L''option a change la forme (carré au lieu de cercle). L''option d change l''attribut couleur (cercle plein), ce que la transformation A→B ne faisait pas. Garde une seule transformation : la taille.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17e4190f-2881-5efb-a79b-493caaf9b138', '0f3b76c5-0078-590d-abb8-090763eb1855', 'La suite de points grandit selon une règle simple. Combien de points doit contenir la figure suivante ? <svg viewBox="0 0 100 100"><rect x="4" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><circle cx="13" cy="49" r="3" fill="#1f2937"/><rect x="30" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><circle cx="37" cy="49" r="3" fill="#1f2937"/><circle cx="44" cy="49" r="3" fill="#1f2937"/><rect x="56" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><circle cx="61" cy="49" r="3" fill="#1f2937"/><circle cx="68" cy="49" r="3" fill="#1f2937"/><circle cx="65" cy="43" r="3" fill="#1f2937"/><rect x="82" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><text x="88" y="54" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"35\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"35\" cy=\"62\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"62\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'b', 'La règle cachée : on ajoute un point à chaque étape (1, puis 2, puis 3…), l''écart constant étant +1. La figure suivante doit donc contenir 4 points. ✓ L''option b affiche exactement 4 points : c''est la bonne. L''option a (3 points) répète l''étape précédente sans avancer. L''option c (5 points) ajoute deux points d''un coup (mauvais écart). L''option d (6 points) double le saut. Compte précisément : il faut passer de 3 à 4, soit +1.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('09bd6e27-5972-57ef-996f-fa22ae19e457', '0f3b76c5-0078-590d-abb8-090763eb1855', 'A est à B ce que C est à ? — la transformation est une symétrie (effet miroir) gauche-droite. Quelle figure complète l''analogie ? <svg viewBox="0 0 100 100"><polygon points="6,30 6,66 26,48" fill="#1f2937"/><text x="30" y="52" font-size="11" fill="#1f2937">:</text><polygon points="58,30 58,66 38,48" fill="#1f2937"/><text x="62" y="52" font-size="11" fill="#1f2937">::</text><polyline points="78,30 96,40 78,50" fill="none" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"38,30 62,50 38,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,38 50,62 70,38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,62 50,38 70,62\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"62,30 38,50 62,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"}]'::jsonb, 'd', 'La règle cachée : symétrie miroir gauche-droite (la figure est retournée horizontalement, comme dans un miroir vertical). Un chevron pointant à droite ( > ) devient un chevron pointant à gauche ( < ). ✓ L''option d est le miroir horizontal exact : c''est la bonne. L''option a est identique à C (aucune transformation appliquée). Les options b et c appliquent une rotation de 90° (chevron vers le bas ou vers le haut) au lieu d''un miroir gauche-droite. Distingue bien miroir et rotation.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2eef23b9-2e2c-56e6-81b7-06a91cd1d9ba', '0f3b76c5-0078-590d-abb8-090763eb1855', 'Matrice 3×3 : dans chaque ligne, le nombre de points augmente de 1 en allant vers la droite (1, 2, 3). Quelle figure remplit la case manquante (en bas à droite) ? <svg viewBox="0 0 100 100"><line x1="34" y1="4" x2="34" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="34" x2="96" y2="34" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#9ca3af" stroke-width="1"/><circle cx="19" cy="19" r="3" fill="#1f2937"/><circle cx="45" cy="19" r="3" fill="#1f2937"/><circle cx="55" cy="19" r="3" fill="#1f2937"/><circle cx="78" cy="19" r="3" fill="#1f2937"/><circle cx="84" cy="19" r="3" fill="#1f2937"/><circle cx="81" cy="13" r="3" fill="#1f2937"/><circle cx="19" cy="51" r="3" fill="#1f2937"/><circle cx="45" cy="51" r="3" fill="#1f2937"/><circle cx="55" cy="51" r="3" fill="#1f2937"/><circle cx="78" cy="51" r="3" fill="#1f2937"/><circle cx="84" cy="51" r="3" fill="#1f2937"/><circle cx="81" cy="45" r="3" fill="#1f2937"/><circle cx="19" cy="83" r="3" fill="#1f2937"/><circle cx="45" cy="83" r="3" fill="#1f2937"/><circle cx="55" cy="83" r="3" fill="#1f2937"/><text x="77" y="88" font-size="16" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"38\" cy=\"50\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"50\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"38\" cy=\"58\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"58\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"36\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"70\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"40\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'c', 'La règle cachée : sur chaque ligne, la 1re case a 1 point, la 2e en a 2, la 3e en a 3. La case manquante est la 3e de la dernière ligne : elle doit donc contenir 3 points. ✓ L''option c montre 3 points : c''est la bonne. L''option b (2 points) répète la colonne du milieu. L''option a (1 point) répète la première colonne. L''option d (4 points) dépasse la règle (+1 de trop). Lis la matrice ligne par ligne pour fixer l''écart constant : +1 par colonne.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2fb8d33b-2b59-53a7-8f38-0ea70444a478', '0f3b76c5-0078-590d-abb8-090763eb1855', 'L''aiguille tourne toujours de 45° dans le sens des aiguilles d''une montre, autour de son point central. Quelle figure poursuit la suite ? <svg viewBox="0 0 100 100"><circle cx="17" cy="50" r="2.5" fill="#1f2937"/><line x1="17" y1="50" x2="17" y2="28" stroke="#1f2937" stroke-width="3"/><polygon points="17,24 12,33 22,33" fill="#1f2937"/><circle cx="50" cy="50" r="2.5" fill="#1f2937"/><line x1="50" y1="50" x2="66" y2="34" stroke="#1f2937" stroke-width="3"/><polygon points="69,31 58,34 65,41" fill="#1f2937"/><circle cx="83" cy="50" r="2.5" fill="#1f2937"/><line x1="83" y1="50" x2="95" y2="50" stroke="#1f2937" stroke-width="3"/><polygon points="99,50 90,45 90,55" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"70\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"75,75 62,72 72,62\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"50\" y2=\"75\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"50,80 44,68 56,68\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"70\" y2=\"30\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"75,25 62,28 72,38\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"30\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"25,75 28,62 38,72\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'La règle cachée : +45° dans le sens horaire à chaque étape. L''aiguille pointe vers le haut (90°), puis vers le haut-droite (45°), puis vers la droite (0°)… l''étape suivante doit pointer vers le bas-droite. ✓ L''option a pointe vers le bas-droite : c''est la bonne suite. L''option c (haut-droite) revient en arrière d''un cran (rotation inverse). L''option b (vers le bas) saute un cran de 45°. L''option d (bas-gauche) part dans le mauvais sens (sens anti-horaire). Garde un pas constant de 45°, toujours dans le même sens horaire.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4629386d-31c9-52f2-8a06-04546c5f0e21', 'b809d08f-d131-5d5a-9a43-0be3a6e49aeb', 'iq-training-fr', '👑 Élite QI ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9d02d75-3bc5-59a9-b0c2-834508fa5b3b', '4629386d-31c9-52f2-8a06-04546c5f0e21', 'Voici une figure et l''axe vertical en pointillés à sa droite. Quelle option est son image par RÉFLEXION dans ce miroir vertical (gauche-droite) ? <svg viewBox="0 0 100 100"><polyline points="30,20 30,80 70,80" fill="none" stroke="#1e293b" stroke-width="6"/><circle cx="30" cy="20" r="7" fill="#ef4444" stroke="#1e293b" stroke-width="2"/><line x1="88" y1="10" x2="88" y2="90" stroke="#64748b" stroke-width="2" stroke-dasharray="4 4"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,20 30,80 70,80\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"20\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,20 70,80 30,80\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"70\" cy=\"20\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,80 30,20 70,20\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"80\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,80 70,20 30,20\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"70\" cy=\"80\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'Règle cachée : une réflexion verticale (miroir gauche-droite) inverse l''axe horizontal et garde l''axe vertical. La figure en L a son angle en bas à gauche et la boule rouge en haut à gauche ; après le miroir, l''angle passe en bas à droite et la boule reste EN HAUT, à droite. ✓ option b. Piège a : c''est la figure de départ inchangée (aucun miroir). Piège c : c''est un retournement haut-bas, pas gauche-droite (la boule descendrait). Piège d : c''est une rotation de 180°, qui inverse les DEUX axes à la fois.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7346b4c-f88c-5b6f-a0e4-17be32d59f0a', '4629386d-31c9-52f2-8a06-04546c5f0e21', 'Cet escalier est construit avec des cubes identiques. En comptant aussi les cubes cachés derrière, combien de cubes au total le composent ? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="1.5" fill="#cbd5e1"><rect x="20" y="70" width="18" height="18"/><rect x="38" y="70" width="18" height="18"/><rect x="56" y="70" width="18" height="18"/><rect x="20" y="52" width="18" height="18"/><rect x="38" y="52" width="18" height="18"/><rect x="20" y="34" width="18" height="18"/></g><text x="50" y="24" font-size="10" text-anchor="middle" fill="#1e293b">profondeur 1</text></svg>', '[{"id":"a","text":"5"},{"id":"b","text":"9"},{"id":"c","text":"6"},{"id":"d","text":"10"}]'::jsonb, 'c', 'Règle : on additionne les cubes colonne par colonne, profondeur 1 (rien de caché derrière, comme indiqué). Colonne de gauche = 3 cubes empilés, colonne du milieu = 2, colonne de droite = 1. Total = 3 + 2 + 1 = 6. ✓ option c. Piège a (5) : on a oublié un cube d''une colonne. Piège b (9) : on a supposé un carré 3×3 plein alors que c''est un escalier. Piège d (10) : on a ajouté une couche cachée derrière, mais la profondeur est de 1.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90184c02-c321-5695-ae42-a12e3e05e540', '4629386d-31c9-52f2-8a06-04546c5f0e21', 'Un seul de ces patrons (dépliés) peut se replier en un CUBE fermé, sans face manquante ni face qui se superpose. Lequel ? <svg viewBox="0 0 100 100"><text x="50" y="50" font-size="11" text-anchor="middle" fill="#1e293b">6 carrés = patron du cube</text><text x="50" y="66" font-size="11" text-anchor="middle" fill="#1e293b">Lequel se replie ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"40\" y=\"10\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"30\" width=\"20\" height=\"20\"/><rect x=\"20\" y=\"50\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"50\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"50\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"70\" width=\"20\" height=\"20\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"20\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"20\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"60\" width=\"20\" height=\"20\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"15\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"35\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"55\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"75\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"15\" y=\"60\" width=\"20\" height=\"20\"/><rect x=\"35\" y=\"60\" width=\"20\" height=\"20\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"20\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"20\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"40\" width=\"20\" height=\"20\"/></g></svg>"}]'::jsonb, 'a', 'Règle : un patron du cube valide a 6 carrés disposés de façon qu''aucun ne se chevauche au pliage ; le grand classique est la croix (un carré central avec un carré sur chaque côté + un en prolongement). Option a est cette croix en T allongé : colonne de 4 carrés avec deux carrés sur les côtés du 3ᵉ — elle se replie parfaitement. ✓ option a. Piège b : il forme un bloc 2×2 plus deux carrés en escalier ; au pliage deux faces se superposent et une manque. Piège d : c''est un rectangle 3×2 plein, qui se replie en boîte ouverte (deux faces se chevauchent, pas de cube fermé). Piège c : configuration 4+2 où les deux carrés du bas sont mal placés, deux faces tombent au même endroit.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('99daffa1-aa81-5112-bf53-f536ff68e009', '4629386d-31c9-52f2-8a06-04546c5f0e21', 'On superpose EXACTEMENT les deux figures de gauche (même centre), traits noirs par-dessus traits noirs. Quelle option montre le résultat de cette superposition ? <svg viewBox="0 0 100 100"><g fill="none" stroke="#1e293b" stroke-width="4"><rect x="12" y="30" width="34" height="34"/></g><text x="55" y="50" font-size="16" text-anchor="middle" fill="#1e293b">+</text><g fill="none" stroke="#1e293b" stroke-width="4"><line x1="66" y1="30" x2="94" y2="58"/><line x1="94" y1="30" x2="66" y2="58"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"22\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"34\" y1=\"34\" x2=\"66\" y2=\"66\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"66\" y1=\"34\" x2=\"34\" y2=\"66\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"70\" y1=\"30\" x2=\"30\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'd', 'Règle : la superposition garde TOUS les traits des deux figures, sans rien ajouter ni enlever. On a un carré ET une croix en X (deux diagonales) ; le résultat est donc le carré traversé par ses deux diagonales formant un X. ✓ option d. Piège a : c''est le carré seul, on a oublié la croix. Piège c : une seule diagonale, on a perdu la moitié du X. Piège b : on a remplacé le carré par un cercle, alors que la superposition ne transforme jamais une forme en une autre.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68ebeba9-6eb3-53cc-8fd0-bba593a01979', '4629386d-31c9-52f2-8a06-04546c5f0e21', 'Transformation A → B, applique la MÊME à C pour trouver le résultat. A→B : la flèche tourne de 90° dans le sens horaire ET un point noir apparaît. <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="10" y1="50" x2="34" y2="50"/><polyline points="28,44 34,50 28,56"/></g><text x="42" y="54" font-size="12" fill="#1e293b">→</text><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="58" y1="34" x2="58" y2="58"/><polyline points="52,52 58,58 64,52"/></g><circle cx="78" cy="40" r="4" fill="#1e293b"/><text x="50" y="82" font-size="11" text-anchor="middle" fill="#1e293b">C : flèche vers le bas, sans point</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><polyline points=\"62,42 70,50 62,58\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><polyline points=\"38,42 30,50 38,58\"/></g><circle cx=\"78\" cy=\"24\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"70\"/><polyline points=\"42,38 50,30 58,38\"/></g><circle cx=\"78\" cy=\"24\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><polyline points=\"62,42 70,50 62,58\"/></g><circle cx=\"78\" cy=\"24\" r=\"5\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'b', 'Règle : rotation de 90° dans le sens horaire + ajout d''un point. C pointe vers le BAS ; après un quart de tour horaire, le bas va vers la GAUCHE, donc la flèche pointe à gauche, et on ajoute le point. ✓ option b (flèche vers la gauche + point). Piège c : on a oublié de tourner (flèche encore verticale) tout en ajoutant le point. Piège d : rotation horaire mais flèche vers la DROITE — c''est l''erreur de sens (le bas qui tourne dans le sens horaire ne va pas à droite). Piège a : flèche vers la droite ET point oublié, deux erreurs cumulées.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bda2e0b3-73b0-529f-a96f-ff37f515e2a1', '4629386d-31c9-52f2-8a06-04546c5f0e21', 'Le motif tourne d''un quart de tour (90°) à chaque case, toujours dans le même sens. En observant la progression, quelle figure occupe la case avec le « ? » ? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="3" fill="none"><rect x="4" y="35" width="28" height="28"/><line x1="18" y1="49" x2="30" y2="49"/><rect x="36" y="35" width="28" height="28"/><line x1="50" y1="49" x2="50" y2="61"/><rect x="68" y="35" width="28" height="28"/><line x1="82" y1="49" x2="70" y2="49"/></g><text x="82" y="82" font-size="14" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"70\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"30\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"50\" y2=\"30\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"50\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'c', 'Règle : l''aiguille partant du centre tourne de 90° dans le sens horaire à chaque case. Case 1 : aiguille vers la DROITE. Case 2 : un quart de tour horaire → vers le BAS. Case 3 : encore un quart → vers la GAUCHE. Case 4 (le ?) : un dernier quart → vers le HAUT. ✓ option c (aiguille vers le haut). Piège a : retour vers la droite, comme si on revenait au départ au lieu de continuer. Piège d : aiguille vers le bas, on a sauté une étape de rotation. Piège b : aiguille vers la gauche, on a répété la case 3 sans tourner.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

