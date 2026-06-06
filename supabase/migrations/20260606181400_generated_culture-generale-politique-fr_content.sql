-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-politique-fr (Culture générale — Politique (FR))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-politique-fr/
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
  ('culture-generale-politique-fr', 'Culture générale — Politique (FR)', 'Comprendre la vie politique : démocratie, séparation des pouvoirs, régimes et institutions, en français.', 'Stratégie', 'subject-arabic', 'Scale', 16, 'fr', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-politique-fr'
      AND e.source = 'admin'
      AND q.id NOT IN ('1c944745-a5a8-52ee-9d94-03410238c862', '2e8b850b-ad44-59b3-957f-7cfd162c1416', '90fc95e6-a7e7-5afb-aaa6-9812a34c06c3', '3ea4f938-a791-5874-920d-0cc49148a307', '8b2fc0ef-263f-58d1-bc06-020fa9921199', 'd626e2a8-219a-5389-a481-84fe43f7e79e', '7841a93d-8819-5d27-892a-2239c5f2b5d8', '476a4817-f2df-564e-8c98-94b5a433f7d4', '79275768-2825-5c99-94f2-0a7095619390', '496aa5b3-9ae6-5203-acb6-49fa9732b97e', '30959f2a-2427-5c7f-8db6-4034b231c0cd', 'a075cfcd-7a8a-5ba8-8d0d-0c221aa7ae1a', 'd03b93cf-24f6-534e-95d4-9683b221fdd3', '0e48d508-ee22-5770-9f4a-8b78739e3485', '5d4eb9c5-542b-5f31-b5d9-ee30b7847a2a', '8cbf6150-a69a-5baf-8bf0-a64e3a6e6e36', '72e73ee4-d39d-5a36-b58b-6774368e4fda', 'b5ba9fea-3665-5ba5-8d41-e3c13b7416e5', 'fd6a3796-7b51-513c-a27e-68212507d19e', 'ee886c1f-849a-504c-b53e-5aa9706ffd1a', '23696a11-a186-5ea8-8379-18aea0241039', '0fdbb5a7-3321-5b74-a1ac-7b7d8e59bc97', '15a691dc-6063-58a5-ad7f-0efa5d4549f8', '53070e96-609e-5cb3-8d4f-17869889f409', '7eca4335-64ee-51ec-b1a6-3dfba9cf397c', '40f219b5-1ca8-5d88-80ac-529fb9a5085c', '95bf7450-e679-5bf9-913c-c2ee82106765', 'adc886d7-dfcd-50e3-98a9-3c0bb66441ca', 'ef0c6e87-4a0b-55fe-b067-116a0758ccbf');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-politique-fr' AND source = 'admin' AND id NOT IN ('b97fbddc-ac33-5d24-9ca0-2bdf3b1d7208', 'd34aeb2a-c30a-5e37-87a2-8cf4f1fcfe97', 'e4f7dc73-f588-5288-926c-62120048a6e0', 'efe9a64e-06ea-52f6-be31-e7c80c756832', 'cdaba43f-513d-54a9-a977-09f36934d0c9');
DELETE FROM public.questions WHERE exercise_id IN ('b97fbddc-ac33-5d24-9ca0-2bdf3b1d7208', 'd34aeb2a-c30a-5e37-87a2-8cf4f1fcfe97', 'e4f7dc73-f588-5288-926c-62120048a6e0', 'efe9a64e-06ea-52f6-be31-e7c80c756832', 'cdaba43f-513d-54a9-a977-09f36934d0c9') AND id NOT IN ('1c944745-a5a8-52ee-9d94-03410238c862', '2e8b850b-ad44-59b3-957f-7cfd162c1416', '90fc95e6-a7e7-5afb-aaa6-9812a34c06c3', '3ea4f938-a791-5874-920d-0cc49148a307', '8b2fc0ef-263f-58d1-bc06-020fa9921199', 'd626e2a8-219a-5389-a481-84fe43f7e79e', '7841a93d-8819-5d27-892a-2239c5f2b5d8', '476a4817-f2df-564e-8c98-94b5a433f7d4', '79275768-2825-5c99-94f2-0a7095619390', '496aa5b3-9ae6-5203-acb6-49fa9732b97e', '30959f2a-2427-5c7f-8db6-4034b231c0cd', 'a075cfcd-7a8a-5ba8-8d0d-0c221aa7ae1a', 'd03b93cf-24f6-534e-95d4-9683b221fdd3', '0e48d508-ee22-5770-9f4a-8b78739e3485', '5d4eb9c5-542b-5f31-b5d9-ee30b7847a2a', '8cbf6150-a69a-5baf-8bf0-a64e3a6e6e36', '72e73ee4-d39d-5a36-b58b-6774368e4fda', 'b5ba9fea-3665-5ba5-8d41-e3c13b7416e5', 'fd6a3796-7b51-513c-a27e-68212507d19e', 'ee886c1f-849a-504c-b53e-5aa9706ffd1a', '23696a11-a186-5ea8-8379-18aea0241039', '0fdbb5a7-3321-5b74-a1ac-7b7d8e59bc97', '15a691dc-6063-58a5-ad7f-0efa5d4549f8', '53070e96-609e-5cb3-8d4f-17869889f409', '7eca4335-64ee-51ec-b1a6-3dfba9cf397c', '40f219b5-1ca8-5d88-80ac-529fb9a5085c', '95bf7450-e679-5bf9-913c-c2ee82106765', 'adc886d7-dfcd-50e3-98a9-3c0bb66441ca', 'ef0c6e87-4a0b-55fe-b067-116a0758ccbf');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-politique-fr' AND c.id NOT IN ('002a5f08-8fd3-5647-a90b-188eab2839c2') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('002a5f08-8fd3-5647-a90b-188eab2839c2', 'culture-generale-politique-fr', 'Institutions et régimes politiques', 'Les bases de la vie politique : la démocratie et son étymologie, la séparation des pouvoirs selon Montesquieu, la différence entre régime parlementaire et présidentiel, monarchie et république, et quelques repères clés (Ve République, ONU, droit de vote).', '# ⚔️ Institutions et régimes — la grande arène du pouvoir

> 💡 « Pour qu''on ne puisse abuser du pouvoir, il faut que, par la disposition des choses, le pouvoir arrête le pouvoir. » — Montesquieu

Bienvenue, stratège. Ici, l''arme n''est pas l''épée mais la **règle du jeu** : qui décide, qui applique, qui juge. Maîtrise ces lois invisibles et tu liras la politique comme une carte de donjon. Avance niveau par niveau.

## 🏛️ Le mot de départ : démocratie

Le mot vient du grec **dêmos** (« le peuple ») + **kratos** (« le pouvoir ») : littéralement, *le pouvoir du peuple*. Née à **Athènes** au Ve siècle av. J.-C., la démocratie s''oppose à deux autres familles de régimes : l''**aristocratie** (le pouvoir de quelques-uns) et la **monarchie** (le pouvoir d''un seul).

Dans une démocratie, le peuple est **souverain** : il choisit ses dirigeants par le vote. C''est le principe de la **souveraineté nationale**, gravé dans l''article 3 de la Déclaration des droits de l''homme et du citoyen de **1789**.

## ⚖️ La trinité du pouvoir : Montesquieu

Dans *De l''esprit des lois* (**1748**), le philosophe **Montesquieu** théorise la **séparation des pouvoirs** pour éviter la tyrannie. Trois pouvoirs, trois gardiens distincts :

| Pouvoir | Rôle | Qui l''exerce (en général) |
|---|---|---|
| **Législatif** | Faire les lois | Le Parlement (assemblée élue) |
| **Exécutif** | Appliquer les lois | Le chef de l''État / le gouvernement |
| **Judiciaire** | Juger, interpréter les lois | Les tribunaux, des juges indépendants |

> 🗡️ Astuce de héros : pense « **écrire / appliquer / juger** ». Si une seule personne fait les trois, c''est la dictature.

## 🛡️ Parlementaire vs présidentiel

Deux grandes architectures de la démocratie moderne :

- **Régime parlementaire** : le gouvernement est **responsable devant le Parlement**, qui peut le renverser (motion de censure). Le chef de l''État est souvent symbolique. Exemples : Royaume-Uni, Allemagne.
- **Régime présidentiel** : le président, élu par le peuple, est à la fois chef de l''État et du gouvernement ; il **n''est pas renversable** par le Parlement. Exemple type : les **États-Unis**.

La **France** de la Ve République mêle les deux : on parle de régime **semi-présidentiel**.

## 👑 Monarchie ou république ?

La vraie ligne de partage tient à **l''accès au pouvoir** du chef de l''État :

- **Monarchie** : le chef d''État (roi, reine) accède au trône par **hérédité**. Dans une **monarchie constitutionnelle** (Royaume-Uni, Espagne, Japon), ses pouvoirs sont limités par une constitution.
- **République** : le chef de l''État est **élu** (directement ou non) pour une durée limitée.

> ⚠️ Piège classique : « monarchie » ne veut pas dire « pouvoir absolu ». La plupart des monarchies actuelles sont **constitutionnelles** et parfaitement démocratiques.

## 🇫🇷 Repères de la Ve République

La **Ve République** française est régie par la **Constitution du 4 octobre 1958**, voulue par **Charles de Gaulle**, son premier président. Quelques jalons à retenir :

- **2000** : le mandat présidentiel passe de 7 à **5 ans** (le *quinquennat*), par référendum, sous Jacques Chirac.
- **1944** : ordonnance accordant le **droit de vote aux femmes** ; premier vote en **1945**.
- **2008** : le président ne peut plus exercer plus de **deux mandats consécutifs**.

## 🌍 Au-delà des frontières : l''ONU

Au niveau mondial, l''**Organisation des Nations unies (ONU)** est fondée en **1945** (charte signée à San Francisco) par **51 États** au sortir de la Seconde Guerre mondiale, pour préserver la paix. Son **siège** est à **New York**, et elle compte aujourd''hui **193 États membres**.

> 🏆 Première porte franchie, stratège ! Tu sais maintenant nommer les trois pouvoirs et distinguer les régimes. Au prochain niveau : les partis, les élections et les grands courants d''idées. En garde !', '# 📜 Résumé : Institutions et régimes politiques

- **Démocratie** : du grec *dêmos* (peuple) + *kratos* (pouvoir) → le pouvoir du peuple ; née à Athènes au Ve siècle av. J.-C.
- **Souveraineté nationale** : le peuple est souverain et choisit ses dirigeants par le vote (article 3 de la DDHC de 1789).
- **Séparation des pouvoirs** (Montesquieu, *De l''esprit des lois*, 1748) : trois pouvoirs distincts — **législatif** (faire les lois), **exécutif** (les appliquer), **judiciaire** (juger).
- **Régime parlementaire** : le gouvernement est responsable devant le Parlement, qui peut le renverser (Royaume-Uni, Allemagne).
- **Régime présidentiel** : le président, chef de l''État et du gouvernement, n''est pas renversable par le Parlement (États-Unis) ; la France est **semi-présidentielle**.
- **Monarchie vs république** : chef d''État **héréditaire** (monarchie, souvent constitutionnelle) ou **élu** (république).
- **Ve République** : Constitution du 4 octobre 1958 ; quinquennat depuis 2000 ; droit de vote des femmes en France par ordonnance de 1944 (premier vote en 1945).
- **ONU** : fondée en 1945 par 51 États, siège à New York, 193 membres aujourd''hui ; mission première : préserver la paix.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b97fbddc-ac33-5d24-9ca0-2bdf3b1d7208', '002a5f08-8fd3-5647-a90b-188eab2839c2', 'culture-generale-politique-fr', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('1c944745-a5a8-52ee-9d94-03410238c862', 'b97fbddc-ac33-5d24-9ca0-2bdf3b1d7208', 'Que signifie littéralement le mot « démocratie », d''après son origine grecque ?', '[{"id":"a","text":"Le pouvoir du peuple"},{"id":"b","text":"Le pouvoir d''un seul"},{"id":"c","text":"Le pouvoir des plus riches"},{"id":"d","text":"Le pouvoir des militaires"}]'::jsonb, 'a', '« Démocratie » vient du grec dêmos (« le peuple ») et kratos (« le pouvoir ») : le pouvoir du peuple. Le régime est né à Athènes au Ve siècle av. J.-C. Le « pouvoir d''un seul » désigne au contraire la monarchie, et celui « de quelques-uns » l''aristocratie.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e8b850b-ad44-59b3-957f-7cfd162c1416', 'b97fbddc-ac33-5d24-9ca0-2bdf3b1d7208', 'Quel philosophe a théorisé la séparation des pouvoirs dans « De l''esprit des lois » (1748) ?', '[{"id":"a","text":"Voltaire"},{"id":"b","text":"Montesquieu"},{"id":"c","text":"Rousseau"},{"id":"d","text":"Descartes"}]'::jsonb, 'b', 'C''est Montesquieu qui, dans « De l''esprit des lois » (1748), distingue les pouvoirs législatif, exécutif et judiciaire pour éviter la tyrannie. Rousseau (« Du contrat social ») a surtout développé l''idée de souveraineté populaire, et Voltaire celle de tolérance : ce ne sont pas eux qui ont théorisé cette séparation.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90fc95e6-a7e7-5afb-aaa6-9812a34c06c3', 'b97fbddc-ac33-5d24-9ca0-2bdf3b1d7208', 'Combien de pouvoirs distincts la séparation des pouvoirs identifie-t-elle ?', '[{"id":"a","text":"Deux"},{"id":"b","text":"Quatre"},{"id":"c","text":"Trois"},{"id":"d","text":"Cinq"}]'::jsonb, 'c', 'Il y a trois pouvoirs : le législatif (faire les lois), l''exécutif (les appliquer) et le judiciaire (juger). On parle parfois de la presse comme d''un « quatrième pouvoir », mais c''est une image : seuls les trois premiers sont les pouvoirs publics au sens constitutionnel.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ea4f938-a791-5874-920d-0cc49148a307', 'b97fbddc-ac33-5d24-9ca0-2bdf3b1d7208', 'Quel pouvoir a pour rôle principal de voter et de faire les lois ?', '[{"id":"a","text":"Le pouvoir exécutif"},{"id":"b","text":"Le pouvoir judiciaire"},{"id":"c","text":"Le pouvoir militaire"},{"id":"d","text":"Le pouvoir législatif"}]'::jsonb, 'd', 'Le pouvoir législatif, exercé par le Parlement (une assemblée élue), vote les lois. L''exécutif (chef de l''État, gouvernement) les applique, et le judiciaire (les tribunaux) les fait respecter. Confondre exécutif et législatif est l''erreur la plus fréquente.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b2fc0ef-263f-58d1-bc06-020fa9921199', 'b97fbddc-ac33-5d24-9ca0-2bdf3b1d7208', 'Dans une république, comment le chef de l''État accède-t-il au pouvoir ?', '[{"id":"a","text":"Par hérédité, de père en fils"},{"id":"b","text":"Par une élection"},{"id":"c","text":"Par tirage au sort à vie"},{"id":"d","text":"Par un coup d''État systématique"}]'::jsonb, 'b', 'Dans une république, le chef de l''État est élu (directement ou indirectement) pour une durée limitée. C''est ce qui la distingue de la monarchie, où le chef d''État (roi ou reine) accède au trône par hérédité. Le mot « république » vient du latin res publica, « la chose publique ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d34aeb2a-c30a-5e37-87a2-8cf4f1fcfe97', '002a5f08-8fd3-5647-a90b-188eab2839c2', 'culture-generale-politique-fr', '⭐ Quiz : Politique', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d626e2a8-219a-5389-a481-84fe43f7e79e', 'd34aeb2a-c30a-5e37-87a2-8cf4f1fcfe97', 'Le mot « démocratie » est formé à partir de deux mots grecs. Lesquels ?', '[{"id":"a","text":"Dêmos (peuple) et kratos (pouvoir)"},{"id":"b","text":"Polis (cité) et nomos (loi)"},{"id":"c","text":"Monos (seul) et arkhê (commandement)"},{"id":"d","text":"Aristos (meilleur) et kratos (pouvoir)"}]'::jsonb, 'a', 'Démocratie = dêmos (« peuple ») + kratos (« pouvoir »), soit le pouvoir du peuple. « Monos + arkhê » donne « monarchie » (pouvoir d''un seul) et « aristos + kratos » donne « aristocratie » (pouvoir des meilleurs / de quelques-uns) : ces racines existent bien, mais elles forment d''autres régimes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7841a93d-8819-5d27-892a-2239c5f2b5d8', 'd34aeb2a-c30a-5e37-87a2-8cf4f1fcfe97', 'Quel est le rôle du pouvoir exécutif ?', '[{"id":"a","text":"Voter les lois"},{"id":"b","text":"Appliquer les lois"},{"id":"c","text":"Juger les procès"},{"id":"d","text":"Écrire la presse"}]'::jsonb, 'b', 'Le pouvoir exécutif applique et fait exécuter les lois ; il est incarné par le chef de l''État et le gouvernement. Voter les lois relève du législatif, et juger relève du judiciaire. Le mot « exécutif » vient d''« exécuter », c''est-à-dire mettre en œuvre.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('476a4817-f2df-564e-8c98-94b5a433f7d4', 'd34aeb2a-c30a-5e37-87a2-8cf4f1fcfe97', 'Dans une monarchie, comment le chef de l''État accède-t-il généralement au pouvoir ?', '[{"id":"a","text":"Par élection au suffrage universel"},{"id":"b","text":"Par concours administratif"},{"id":"c","text":"Par hérédité"},{"id":"d","text":"Par référendum annuel"}]'::jsonb, 'c', 'Dans une monarchie, le roi ou la reine accède au trône par hérédité (succession familiale). Dans une république, au contraire, le chef de l''État est élu. Aujourd''hui, la plupart des monarchies sont « constitutionnelles » : une constitution limite les pouvoirs du monarque.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79275768-2825-5c99-94f2-0a7095619390', 'd34aeb2a-c30a-5e37-87a2-8cf4f1fcfe97', 'Quel pays est l''exemple type d''un régime présidentiel ?', '[{"id":"a","text":"Le Royaume-Uni"},{"id":"b","text":"L''Allemagne"},{"id":"c","text":"L''Italie"},{"id":"d","text":"Les États-Unis"}]'::jsonb, 'd', 'Les États-Unis sont le modèle du régime présidentiel : le président est à la fois chef de l''État et du gouvernement, et n''est pas renversable par le Congrès. Le Royaume-Uni, l''Allemagne et l''Italie sont au contraire des régimes parlementaires, où le gouvernement répond devant le Parlement.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('496aa5b3-9ae6-5203-acb6-49fa9732b97e', 'd34aeb2a-c30a-5e37-87a2-8cf4f1fcfe97', 'Quelle est la mission première de l''Organisation des Nations unies (ONU) ?', '[{"id":"a","text":"Maintenir la paix et la sécurité internationales"},{"id":"b","text":"Fixer le prix mondial du pétrole"},{"id":"c","text":"Organiser les Jeux olympiques"},{"id":"d","text":"Décerner les prix Nobel"}]'::jsonb, 'a', 'Créée en 1945 après la Seconde Guerre mondiale, l''ONU a pour but premier de maintenir la paix et la sécurité dans le monde. Les Jeux olympiques relèvent du CIO et les prix Nobel de fondations suédoises et norvégiennes : ces missions n''ont rien à voir avec l''ONU.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30959f2a-2427-5c7f-8db6-4034b231c0cd', 'd34aeb2a-c30a-5e37-87a2-8cf4f1fcfe97', 'Qui est le premier président de la Ve République française ?', '[{"id":"a","text":"Georges Pompidou"},{"id":"b","text":"Charles de Gaulle"},{"id":"c","text":"François Mitterrand"},{"id":"d","text":"Vincent Auriol"}]'::jsonb, 'b', 'Charles de Gaulle, à l''origine de la Constitution du 4 octobre 1958, en est le premier président. Georges Pompidou lui succède en 1969 et François Mitterrand est élu en 1981. Vincent Auriol, lui, fut président sous la IVe République, et non la Ve.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e4f7dc73-f588-5288-926c-62120048a6e0', '002a5f08-8fd3-5647-a90b-188eab2839c2', 'culture-generale-politique-fr', '⚔️ Boss ⭐⭐⭐ : Politique', 3, 120, 30, 'boss', 'admin', 2)
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
  ('a075cfcd-7a8a-5ba8-8d0d-0c221aa7ae1a', 'e4f7dc73-f588-5288-926c-62120048a6e0', 'Quel pouvoir a pour rôle de juger et d''interpréter les lois ?', '[{"id":"a","text":"Le pouvoir judiciaire"},{"id":"b","text":"Le pouvoir législatif"},{"id":"c","text":"Le pouvoir exécutif"},{"id":"d","text":"Le pouvoir constituant"}]'::jsonb, 'a', 'Le pouvoir judiciaire, exercé par des juges indépendants, tranche les litiges et interprète les lois. Le « pouvoir constituant » désigne, lui, l''autorité qui rédige ou révise la Constitution : c''est un piège, car il sonne juste mais ne fait pas partie des trois pouvoirs de Montesquieu.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d03b93cf-24f6-534e-95d4-9683b221fdd3', 'e4f7dc73-f588-5288-926c-62120048a6e0', 'En quelle année les femmes ont-elles obtenu le droit de vote en France ?', '[{"id":"a","text":"1936"},{"id":"b","text":"1944"},{"id":"c","text":"1958"},{"id":"d","text":"1968"}]'::jsonb, 'b', 'L''ordonnance du 21 avril 1944, prise par le Gouvernement provisoire du général de Gaulle, accorde le droit de vote aux femmes ; elles votent pour la première fois en 1945. La France est tardive : la Nouvelle-Zélande l''avait fait dès 1893. 1958 (Ve République) et 1968 (mai 68) sont des leurres d''années marquantes voisines.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e48d508-ee22-5770-9f4a-8b78739e3485', 'e4f7dc73-f588-5288-926c-62120048a6e0', 'Dans un régime parlementaire, quel mécanisme permet au Parlement de renverser le gouvernement ?', '[{"id":"a","text":"La motion de censure"},{"id":"b","text":"Le veto présidentiel"},{"id":"c","text":"La question préalable"},{"id":"d","text":"Le référendum d''initiative partagée"}]'::jsonb, 'a', 'La motion de censure, votée par les députés, contraint le gouvernement à démissionner : c''est la marque du régime parlementaire, où l''exécutif est responsable devant le Parlement. Le veto est un outil du président (régime présidentiel), et le référendum d''initiative partagée sert à proposer une loi, pas à renverser un gouvernement.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5d4eb9c5-542b-5f31-b5d9-ee30b7847a2a', 'e4f7dc73-f588-5288-926c-62120048a6e0', 'Quelle est la durée actuelle du mandat du président de la République française (le quinquennat) ?', '[{"id":"a","text":"4 ans"},{"id":"b","text":"6 ans"},{"id":"c","text":"5 ans"},{"id":"d","text":"7 ans"}]'::jsonb, 'c', 'Depuis le référendum de 2000 (sous Jacques Chirac), le mandat présidentiel français dure 5 ans : c''est le quinquennat, appliqué dès 2002. Auparavant, il était de 7 ans (le septennat) : le « 7 ans » est donc l''ancienne durée, un distracteur volontairement crédible.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8cbf6150-a69a-5baf-8bf0-a64e3a6e6e36', 'e4f7dc73-f588-5288-926c-62120048a6e0', 'Combien d''États ont fondé l''Organisation des Nations unies en 1945 ?', '[{"id":"a","text":"27"},{"id":"b","text":"193"},{"id":"c","text":"100"},{"id":"d","text":"51"}]'::jsonb, 'd', 'L''ONU a été fondée en 1945 par 51 États membres, à la suite de la conférence de San Francisco. À ne pas confondre avec les 193 membres actuels : c''est le piège classique. Le nombre 27 évoque, lui, les États membres de l''Union européenne — une autre organisation.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('72e73ee4-d39d-5a36-b58b-6774368e4fda', 'e4f7dc73-f588-5288-926c-62120048a6e0', 'Quel article de la Déclaration des droits de l''homme et du citoyen de 1789 affirme que « le principe de toute souveraineté réside essentiellement dans la nation » ?', '[{"id":"a","text":"L''article 1er"},{"id":"b","text":"L''article 3"},{"id":"c","text":"L''article 16"},{"id":"d","text":"L''article 10"}]'::jsonb, 'b', 'C''est l''article 3 de la DDHC de 1789 qui pose la souveraineté nationale : le pouvoir émane de la nation, non du roi. Attention au piège : l''article 16, lui aussi célèbre, est celui qui exige la séparation des pouvoirs (« Toute société dans laquelle… la séparation des pouvoirs [n''est pas] déterminée, n''a point de Constitution »). L''article 1er proclame que « les hommes naissent libres et égaux ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('efe9a64e-06ea-52f6-be31-e7c80c756832', '002a5f08-8fd3-5647-a90b-188eab2839c2', 'culture-generale-politique-fr', '⭐⭐ Révision : Politique', 2, 70, 15, 'practice', 'admin', 3)
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
  ('b5ba9fea-3665-5ba5-8d41-e3c13b7416e5', 'efe9a64e-06ea-52f6-be31-e7c80c756832', 'Le « pouvoir du peuple » s''oppose, dans les régimes classiques, à l''aristocratie. Que désigne l''aristocratie ?', '[{"id":"a","text":"Le pouvoir d''un seul"},{"id":"b","text":"Le pouvoir de quelques-uns"},{"id":"c","text":"Le pouvoir des juges"},{"id":"d","text":"Le pouvoir de la majorité"}]'::jsonb, 'b', 'L''aristocratie (du grec aristos, « le meilleur ») est le gouvernement de quelques-uns, censés être les plus qualifiés. Le pouvoir d''un seul est la monarchie ; celui de la majorité, la démocratie. Ces trois familles de régimes ont été décrites dès l''Antiquité par Aristote.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd6a3796-7b51-513c-a27e-68212507d19e', 'efe9a64e-06ea-52f6-be31-e7c80c756832', 'Pourquoi Montesquieu défend-il la séparation des pouvoirs ?', '[{"id":"a","text":"Pour accélérer le vote des lois"},{"id":"b","text":"Pour rendre l''État moins coûteux"},{"id":"c","text":"Pour empêcher l''abus de pouvoir et garantir la liberté"},{"id":"d","text":"Pour donner tous les pouvoirs au roi"}]'::jsonb, 'c', 'Pour Montesquieu, « le pouvoir arrête le pouvoir » : en confiant les trois fonctions à des organes distincts, on empêche la tyrannie et on protège la liberté. L''objectif n''est ni la rapidité ni l''économie, et certainement pas de concentrer le pouvoir entre les mains d''un seul — ce serait l''inverse de sa thèse.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee886c1f-849a-504c-b53e-5aa9706ffd1a', 'efe9a64e-06ea-52f6-be31-e7c80c756832', 'Quelle affirmation décrit correctement un régime parlementaire ?', '[{"id":"a","text":"Le gouvernement est responsable devant le Parlement, qui peut le renverser"},{"id":"b","text":"Le président ne peut jamais être renversé par le Parlement"},{"id":"c","text":"Il n''existe aucune assemblée élue"},{"id":"d","text":"Les juges votent les lois"}]'::jsonb, 'a', 'Dans un régime parlementaire, le gouvernement tient sa légitimité du Parlement et peut être renversé par lui (motion de censure). L''impossibilité de renverser l''exécutif caractérise au contraire le régime présidentiel. Un Parlement existe toujours, et les juges ne votent jamais les lois.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('23696a11-a186-5ea8-8379-18aea0241039', 'efe9a64e-06ea-52f6-be31-e7c80c756832', 'Le Royaume-Uni est un exemple de quel type de régime ?', '[{"id":"a","text":"Une république présidentielle"},{"id":"b","text":"Une dictature militaire"},{"id":"c","text":"Une monarchie absolue"},{"id":"d","text":"Une monarchie constitutionnelle"}]'::jsonb, 'd', 'Le Royaume-Uni est une monarchie constitutionnelle : un roi (chef d''État héréditaire) au rôle largement symbolique, et un Premier ministre qui gouverne avec le soutien du Parlement. Ce n''est pas une monarchie absolue (les pouvoirs du souverain sont strictement limités) ni une république, puisque le chef d''État n''est pas élu.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0fdbb5a7-3321-5b74-a1ac-7b7d8e59bc97', 'efe9a64e-06ea-52f6-be31-e7c80c756832', 'Quelle Constitution régit la Ve République française ?', '[{"id":"a","text":"La Constitution de 1946"},{"id":"b","text":"La Constitution de 1958"},{"id":"c","text":"La Constitution de 1875"},{"id":"d","text":"La Constitution de 1791"}]'::jsonb, 'b', 'La Ve République est régie par la Constitution du 4 octobre 1958, portée par Charles de Gaulle. Celle de 1946 fondait la IVe République, et celle de 1791 (issue de la Révolution) instaurait une monarchie constitutionnelle : ce sont des textes voisins mais d''autres régimes.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('15a691dc-6063-58a5-ad7f-0efa5d4549f8', 'efe9a64e-06ea-52f6-be31-e7c80c756832', 'Où se trouve le siège des Nations unies ?', '[{"id":"a","text":"Genève"},{"id":"b","text":"Paris"},{"id":"c","text":"New York"},{"id":"d","text":"Bruxelles"}]'::jsonb, 'c', 'Le siège de l''ONU est à New York, aux États-Unis. Genève abrite bien un grand bureau de l''ONU (et d''anciennes institutions de la SDN), mais pas le siège ; Bruxelles est le cœur de l''Union européenne et de l''OTAN, et Paris celui de l''UNESCO.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cdaba43f-513d-54a9-a977-09f36934d0c9', '002a5f08-8fd3-5647-a90b-188eab2839c2', 'culture-generale-politique-fr', '👑 Défi élite ⭐⭐⭐⭐ : Politique', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('53070e96-609e-5cb3-8d4f-17869889f409', 'cdaba43f-513d-54a9-a977-09f36934d0c9', 'Dans quel ouvrage Montesquieu expose-t-il sa théorie de la séparation des pouvoirs ?', '[{"id":"a","text":"Du contrat social"},{"id":"b","text":"De l''esprit des lois"},{"id":"c","text":"Le Léviathan"},{"id":"d","text":"Les Lettres persanes"}]'::jsonb, 'b', 'La séparation des pouvoirs est exposée dans « De l''esprit des lois » (1748). « Du contrat social » est de Rousseau, « Le Léviathan » de Hobbes (qui défend au contraire un pouvoir fort), et « Les Lettres persanes » sont bien de Montesquieu mais constituent un roman satirique, pas son traité politique : un piège fin.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7eca4335-64ee-51ec-b1a6-3dfba9cf397c', 'cdaba43f-513d-54a9-a977-09f36934d0c9', 'En quelle année le quinquennat a-t-il été adopté par référendum en France ?', '[{"id":"a","text":"1995"},{"id":"b","text":"2002"},{"id":"c","text":"2000"},{"id":"d","text":"2008"}]'::jsonb, 'c', 'Le quinquennat a été approuvé par référendum en 2000, sous Jacques Chirac, et appliqué pour la première fois en 2002. 2002 est l''année de la première application (le piège), et 2008 celle de la révision limitant à deux mandats consécutifs : des années réelles, mais qui ne correspondent pas au référendum.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40f219b5-1ca8-5d88-80ac-529fb9a5085c', 'cdaba43f-513d-54a9-a977-09f36934d0c9', 'Quel article de la DDHC de 1789 énonce que toute société sans séparation des pouvoirs « n''a point de Constitution » ?', '[{"id":"a","text":"L''article 16"},{"id":"b","text":"L''article 3"},{"id":"c","text":"L''article 6"},{"id":"d","text":"L''article 17"}]'::jsonb, 'a', 'C''est l''article 16 : « Toute société dans laquelle la garantie des droits n''est pas assurée, ni la séparation des pouvoirs déterminée, n''a point de Constitution. » L''article 3 traite de la souveraineté nationale, l''article 6 de la loi comme « expression de la volonté générale » et l''article 17 du droit de propriété.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('95bf7450-e679-5bf9-913c-c2ee82106765', 'cdaba43f-513d-54a9-a977-09f36934d0c9', 'La France de la Ve République est le plus souvent qualifiée de régime :', '[{"id":"a","text":"Présidentiel pur"},{"id":"b","text":"Parlementaire pur"},{"id":"c","text":"Semi-présidentiel"},{"id":"d","text":"D''assemblée"}]'::jsonb, 'c', 'La Ve République combine un président élu au suffrage universel et un gouvernement responsable devant l''Assemblée : on parle de régime semi-présidentiel (ou mixte). Elle n''est pas présidentielle « pure » comme les États-Unis (où il n''y a pas de Premier ministre responsable), ni un régime d''assemblée, où le Parlement domine tout.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('adc886d7-dfcd-50e3-98a9-3c0bb66441ca', 'cdaba43f-513d-54a9-a977-09f36934d0c9', 'Combien d''États membres compte aujourd''hui l''Organisation des Nations unies ?', '[{"id":"a","text":"151"},{"id":"b","text":"193"},{"id":"c","text":"27"},{"id":"d","text":"200"}]'::jsonb, 'b', 'L''ONU compte 193 États membres depuis l''adhésion du Soudan du Sud en 2011. Le 51 des origines (1945) et le 27 de l''Union européenne sont des chiffres voisins souvent confondus ; il n''existe pas exactement 200 États reconnus dans le monde, ce qui rend ce distracteur tentant mais faux.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef0c6e87-4a0b-55fe-b067-116a0758ccbf', 'cdaba43f-513d-54a9-a977-09f36934d0c9', 'Quel principe affirme que l''autorité politique émane du peuple et non d''un roi de droit divin ?', '[{"id":"a","text":"La souveraineté nationale"},{"id":"b","text":"La subsidiarité"},{"id":"c","text":"La laïcité"},{"id":"d","text":"Le fédéralisme"}]'::jsonb, 'a', 'La souveraineté nationale (ou populaire) pose que le pouvoir vient du peuple, rompant avec la monarchie de droit divin : c''est l''esprit de l''article 3 de la DDHC de 1789. La subsidiarité concerne la répartition des compétences entre échelons, la laïcité la séparation des Églises et de l''État, et le fédéralisme l''organisation territoriale du pouvoir.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

