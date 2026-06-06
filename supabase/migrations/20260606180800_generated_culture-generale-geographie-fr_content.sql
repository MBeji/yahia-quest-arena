-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-geographie-fr (Culture générale — Géographie (FR))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-geographie-fr/
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
  ('culture-generale-geographie-fr', 'Culture générale — Géographie (FR)', 'Pays, capitales, continents, océans et records de la planète : la géographie du monde en version culture générale.', 'Exploration', 'subject-english', 'Globe', 13, 'fr', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-geographie-fr'
      AND e.source = 'admin'
      AND q.id NOT IN ('6edda6d5-7e4a-55d2-8a24-3725f815152a', '187f5893-6571-589c-8cbc-bc999a4c78e6', '59f8751a-5da3-5b68-ad1f-a3072567b952', '19fd28b4-69cb-5d7d-915a-37bb682f4754', 'dc61c432-4be1-5f74-b869-50ebad811b6a', '51207b71-a581-571f-8bcd-0042c6d49704', 'd41ec4df-5d71-5298-97e4-9c8520b3e553', '37b2d57d-e004-586d-9275-5bdb03dbd264', '19861b80-821a-5df4-b51b-12da1a8c17cf', 'fd6ea4e1-3dae-5111-b260-37da6203577b', '64b54a95-1747-5968-8ca3-502675863449', '89624d8c-b6da-5334-a1bd-c18ea5a94133', 'b5191940-9885-550c-8fe5-c687bcdf4aa6', '677b8c14-e759-5a29-8251-1f3aa5c5b38a', '9f43d07e-bbc4-51c5-bd9d-ab3912fbcc08', 'cb3663ab-4904-5701-ac95-32038f59324e', '1e951b07-ef73-5a99-acb9-e8c071ed3dea', '62ec7816-6d26-503e-a159-e3f16a2ab8ad', 'd1ae0709-e50a-5f4b-bad2-b8616c709b28', 'fded9730-e29f-5176-b285-ddcdaa583664', 'ee0ba34b-5e5d-5989-88ac-f40892643209', '83e55dc4-256f-5e7e-a40d-ff2c24fe7b25', 'f10480c9-3796-5f8f-aa3f-78542a3fbe22', '82b9122d-58d7-5184-abca-c1cac81c4d54', 'b9ecd10d-21f6-5fe5-ac0d-615f66742e5f', '88a293bc-9c2b-5e3e-9373-b1c3b306485c', '600257b3-50f1-50a6-921f-c02d66f8a69f', '5eda1d0c-1cbb-54ed-9c69-4e24a68b9328', '599d68df-64c2-5a9e-a80b-9844bbf7701d');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-geographie-fr' AND source = 'admin' AND id NOT IN ('4caf2929-2f4e-5f61-8789-ea6e7f9ffeb7', 'cedd40b9-04b2-50cb-af84-6b90f284b254', 'f9d3c31f-371b-5231-9b9f-9f9966d7b827', '7a987022-ab16-5eda-b64a-f4fec214a754', '0b5d5749-10dc-5b5a-a506-f9b38ee649e0');
DELETE FROM public.questions WHERE exercise_id IN ('4caf2929-2f4e-5f61-8789-ea6e7f9ffeb7', 'cedd40b9-04b2-50cb-af84-6b90f284b254', 'f9d3c31f-371b-5231-9b9f-9f9966d7b827', '7a987022-ab16-5eda-b64a-f4fec214a754', '0b5d5749-10dc-5b5a-a506-f9b38ee649e0') AND id NOT IN ('6edda6d5-7e4a-55d2-8a24-3725f815152a', '187f5893-6571-589c-8cbc-bc999a4c78e6', '59f8751a-5da3-5b68-ad1f-a3072567b952', '19fd28b4-69cb-5d7d-915a-37bb682f4754', 'dc61c432-4be1-5f74-b869-50ebad811b6a', '51207b71-a581-571f-8bcd-0042c6d49704', 'd41ec4df-5d71-5298-97e4-9c8520b3e553', '37b2d57d-e004-586d-9275-5bdb03dbd264', '19861b80-821a-5df4-b51b-12da1a8c17cf', 'fd6ea4e1-3dae-5111-b260-37da6203577b', '64b54a95-1747-5968-8ca3-502675863449', '89624d8c-b6da-5334-a1bd-c18ea5a94133', 'b5191940-9885-550c-8fe5-c687bcdf4aa6', '677b8c14-e759-5a29-8251-1f3aa5c5b38a', '9f43d07e-bbc4-51c5-bd9d-ab3912fbcc08', 'cb3663ab-4904-5701-ac95-32038f59324e', '1e951b07-ef73-5a99-acb9-e8c071ed3dea', '62ec7816-6d26-503e-a159-e3f16a2ab8ad', 'd1ae0709-e50a-5f4b-bad2-b8616c709b28', 'fded9730-e29f-5176-b285-ddcdaa583664', 'ee0ba34b-5e5d-5989-88ac-f40892643209', '83e55dc4-256f-5e7e-a40d-ff2c24fe7b25', 'f10480c9-3796-5f8f-aa3f-78542a3fbe22', '82b9122d-58d7-5184-abca-c1cac81c4d54', 'b9ecd10d-21f6-5fe5-ac0d-615f66742e5f', '88a293bc-9c2b-5e3e-9373-b1c3b306485c', '600257b3-50f1-50a6-921f-c02d66f8a69f', '5eda1d0c-1cbb-54ed-9c69-4e24a68b9328', '599d68df-64c2-5a9e-a80b-9844bbf7701d');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-geographie-fr' AND c.id NOT IN ('802be628-5855-5d9a-a3c5-258a86a3e80d') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('802be628-5855-5d9a-a3c5-258a86a3e80d', 'culture-generale-geographie-fr', 'Pays et capitales', 'Capitales du monde (y compris les pièges célèbres), continents, océans et grands records géographiques de la planète.', '# ⚔️ Atlas du monde — pars à la conquête des pays et des capitales

> 💡 « Celui qui connaît la carte ne se perd jamais : chaque capitale est une porte, chaque frontière un défi. »

Bienvenue, explorateur. Ce chapitre est ton premier donjon géographique. Tu vas apprendre à lire la planète comme un aventurier lit une carte au trésor : les **continents**, les **océans**, les **pays**, leurs **capitales** et les grands **records** qui font de la Terre un monde fascinant. Maîtrise-les, et plus aucune question de culture générale ne te prendra par surprise.

## 🌍 Les continents et les océans

La Terre compte traditionnellement **7 continents** : Asie, Afrique, Amérique du Nord, Amérique du Sud, Antarctique, Europe et Océanie. L''**Asie** est de loin le plus vaste et le plus peuplé.

Côté eaux, il y a **5 océans**. Le plus grand est l''**océan Pacifique**, suivi de l''Atlantique, de l''Indien, de l''Austral et de l''Arctique (le plus petit).

| Élément | Record | Détail |
|---|---|---|
| Plus grand continent | **Asie** | ~44,5 millions de km² |
| Plus grand océan | **Pacifique** | couvre près d''un tiers du globe |
| Plus grand désert | **Antarctique** | désert froid, ~14 millions de km² |
| Plus grand désert chaud | **Sahara** | ~9,4 millions de km² |

> 🗡️ Astuce d''aventurier : un **désert** se définit par son manque de précipitations, pas par le sable. C''est pourquoi l''**Antarctique** glacée est le plus grand désert du monde.

## 🏛️ Les capitales… et leurs pièges

Une **capitale** est la ville où siège le gouvernement d''un pays — ce n''est pas toujours la ville la plus connue ! Les examinateurs adorent ces pièges :

- **Australie** → la capitale est **Canberra**, pas Sydney ni Melbourne (Canberra fut créée en 1913 comme compromis entre les deux rivales).
- **Canada** → **Ottawa**, pas Toronto.
- **Brésil** → **Brasília**, ville bâtie de toutes pièces et inaugurée en 1960, pas Rio de Janeiro.
- **Turquie** → **Ankara**, pas Istanbul (Ankara devient capitale en 1923).
- **États-Unis** → **Washington, D.C.**, pas New York.

> ⚠️ Piège classique : la plus grande ville d''un pays n''est pas forcément sa capitale. Vérifie toujours qui abrite le **siège du gouvernement**.

## 📏 Les pays géants et les pays minuscules

Le plus grand pays du monde par la superficie est la **Russie** (~17 millions de km²), qui s''étend sur deux continents, l''Europe et l''Asie. Le plus petit est le **Vatican** (~0,44 km²), enclavé dans Rome.

| Superlatif | Pays | À retenir |
|---|---|---|
| Plus grand pays | **Russie** | à cheval sur 2 continents |
| Plus petit pays | **Vatican** | État souverain dans Rome |
| Pays le plus peuplé | **Inde** | a dépassé la Chine en 2023 |

## 👥 La démographie qui change

Pendant des décennies, la **Chine** fut le pays le plus peuplé. Mais en **2023**, l''**Inde** l''a dépassée et compte désormais plus de **1,4 milliard** d''habitants. La population mondiale n''est donc pas figée : elle se déplace, et la carte des records évolue.

## 🏔️ Les records naturels à connaître

- Plus haut sommet : le **mont Everest**, à **8 849 m** (frontière Népal–Chine).
- Plus long fleuve : le **Nil** (~6 650 km) en Afrique, talonné par l''**Amazone** — un débat de géographes encore ouvert.
- Plus grand désert chaud : le **Sahara**, en Afrique du Nord.

> 🏆 Première porte franchie ! Tu sais désormais distinguer continents, océans, capitales-pièges et records de la planète. Affûte ta carte mentale : le prochain donjon t''emmènera plus loin dans les merveilles du monde.', '# 📜 Résumé : Pays et capitales

- **7 continents** : l''Asie est le plus vaste et le plus peuplé.
- **5 océans** : le **Pacifique** est le plus grand, l''Arctique le plus petit.
- **Capitale ≠ plus grande ville** : Australie → **Canberra**, Canada → **Ottawa**, Brésil → **Brasília**, Turquie → **Ankara**, États-Unis → **Washington, D.C.**
- **Plus grand pays** : la **Russie** (~17 millions de km²), à cheval sur l''Europe et l''Asie.
- **Plus petit pays** : le **Vatican** (~0,44 km²), enclavé dans Rome.
- **Pays le plus peuplé** : l''**Inde**, qui a dépassé la Chine en **2023** (plus de 1,4 milliard d''habitants).
- **Plus grand désert** : l''**Antarctique** (désert froid) ; le plus grand désert chaud est le **Sahara**.
- **Records naturels** : plus haut sommet le **mont Everest** (8 849 m) ; plus long fleuve le **Nil** (~6 650 km).', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4caf2929-2f4e-5f61-8789-ea6e7f9ffeb7', '802be628-5855-5d9a-a3c5-258a86a3e80d', 'culture-generale-geographie-fr', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('6edda6d5-7e4a-55d2-8a24-3725f815152a', '4caf2929-2f4e-5f61-8789-ea6e7f9ffeb7', 'Quelle est la capitale de l''Australie ?', '[{"id":"a","text":"Sydney"},{"id":"b","text":"Melbourne"},{"id":"c","text":"Canberra"},{"id":"d","text":"Perth"}]'::jsonb, 'c', 'La capitale de l''Australie est Canberra, créée en 1913 comme compromis politique entre Sydney et Melbourne, qui se disputaient le titre. Sydney est la plus grande ville du pays, mais la capitale est bien là où siège le gouvernement.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('187f5893-6571-589c-8cbc-bc999a4c78e6', '4caf2929-2f4e-5f61-8789-ea6e7f9ffeb7', 'Quel est le plus grand pays du monde par sa superficie ?', '[{"id":"a","text":"La Russie"},{"id":"b","text":"Le Canada"},{"id":"c","text":"La Chine"},{"id":"d","text":"Les États-Unis"}]'::jsonb, 'a', 'La Russie est le plus grand pays du monde avec environ 17 millions de km², à cheval sur l''Europe et l''Asie. Le Canada arrive deuxième : c''est un piège courant, car il est très étendu mais reste près de deux fois plus petit que la Russie.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59f8751a-5da3-5b68-ad1f-a3072567b952', '4caf2929-2f4e-5f61-8789-ea6e7f9ffeb7', 'Quel est le plus grand océan du monde ?', '[{"id":"a","text":"L''océan Atlantique"},{"id":"b","text":"L''océan Indien"},{"id":"c","text":"L''océan Arctique"},{"id":"d","text":"L''océan Pacifique"}]'::jsonb, 'd', 'L''océan Pacifique est le plus grand : il couvre à lui seul près d''un tiers de la surface du globe. L''Atlantique est le deuxième ; l''Arctique, lui, est le plus petit des cinq océans.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19fd28b4-69cb-5d7d-915a-37bb682f4754', '4caf2929-2f4e-5f61-8789-ea6e7f9ffeb7', 'Depuis 2023, quel pays est le plus peuplé du monde ?', '[{"id":"a","text":"La Chine"},{"id":"b","text":"L''Inde"},{"id":"c","text":"Les États-Unis"},{"id":"d","text":"L''Indonésie"}]'::jsonb, 'b', 'L''Inde a dépassé la Chine en 2023 et compte désormais plus de 1,4 milliard d''habitants. La Chine a longtemps détenu ce record, mais sa population a commencé à décliner, alors que celle de l''Inde continue de croître.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dc61c432-4be1-5f74-b869-50ebad811b6a', '4caf2929-2f4e-5f61-8789-ea6e7f9ffeb7', 'Combien de continents compte traditionnellement la Terre ?', '[{"id":"a","text":"Cinq"},{"id":"b","text":"Six"},{"id":"c","text":"Sept"},{"id":"d","text":"Huit"}]'::jsonb, 'c', 'On compte traditionnellement 7 continents : Asie, Afrique, Amérique du Nord, Amérique du Sud, Antarctique, Europe et Océanie. L''Asie est le plus vaste et le plus peuplé d''entre eux.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cedd40b9-04b2-50cb-af84-6b90f284b254', '802be628-5855-5d9a-a3c5-258a86a3e80d', 'culture-generale-geographie-fr', '⭐ Quiz : Géographie', 1, 50, 10, 'practice', 'admin', 1)
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
  ('51207b71-a581-571f-8bcd-0042c6d49704', 'cedd40b9-04b2-50cb-af84-6b90f284b254', 'Quelle est la capitale de la France ?', '[{"id":"a","text":"Lyon"},{"id":"b","text":"Marseille"},{"id":"c","text":"Paris"},{"id":"d","text":"Bordeaux"}]'::jsonb, 'c', 'Paris est la capitale de la France et sa plus grande ville. Traversée par la Seine, elle abrite le siège du gouvernement et des institutions de la République.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d41ec4df-5d71-5298-97e4-9c8520b3e553', 'cedd40b9-04b2-50cb-af84-6b90f284b254', 'Sur quel continent se trouve l''Égypte ?', '[{"id":"a","text":"L''Asie"},{"id":"b","text":"L''Afrique"},{"id":"c","text":"L''Europe"},{"id":"d","text":"L''Océanie"}]'::jsonb, 'b', 'L''Égypte se situe en Afrique du Nord, traversée par le Nil. Une petite partie de son territoire, le Sinaï, se trouve en Asie : c''est ce qui rend la question piégeuse, mais le pays est rattaché à l''Afrique.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('37b2d57d-e004-586d-9275-5bdb03dbd264', 'cedd40b9-04b2-50cb-af84-6b90f284b254', 'Quel est le plus petit pays du monde par sa superficie ?', '[{"id":"a","text":"Monaco"},{"id":"b","text":"Le Vatican"},{"id":"c","text":"Saint-Marin"},{"id":"d","text":"Le Liechtenstein"}]'::jsonb, 'b', 'Le Vatican est le plus petit État du monde, avec environ 0,44 km², entièrement enclavé dans la ville de Rome. Monaco est le deuxième plus petit : c''est le piège classique de cette question.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19861b80-821a-5df4-b51b-12da1a8c17cf', 'cedd40b9-04b2-50cb-af84-6b90f284b254', 'Quelle est la capitale du Japon ?', '[{"id":"a","text":"Osaka"},{"id":"b","text":"Kyoto"},{"id":"c","text":"Tokyo"},{"id":"d","text":"Nagoya"}]'::jsonb, 'c', 'Tokyo est la capitale du Japon depuis 1868. Kyoto, l''ancienne capitale impériale, est un piège fréquent : elle a perdu ce statut lorsque l''empereur s''est installé à Tokyo (« capitale de l''Est »).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd6ea4e1-3dae-5111-b260-37da6203577b', 'cedd40b9-04b2-50cb-af84-6b90f284b254', 'Quel est le plus haut sommet du monde ?', '[{"id":"a","text":"Le mont Everest"},{"id":"b","text":"le K2"},{"id":"c","text":"Le mont Blanc"},{"id":"d","text":"Le Kilimandjaro"}]'::jsonb, 'a', 'Le mont Everest, à 8 849 m, est le plus haut sommet du monde ; il se dresse sur la frontière entre le Népal et la Chine. Le K2 est le deuxième plus haut, ce qui en fait un distracteur tentant.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('64b54a95-1747-5968-8ca3-502675863449', 'cedd40b9-04b2-50cb-af84-6b90f284b254', 'Quel est le plus grand désert chaud du monde ?', '[{"id":"a","text":"Le désert de Gobi"},{"id":"b","text":"Le désert d''Arabie"},{"id":"c","text":"Le désert du Kalahari"},{"id":"d","text":"Le Sahara"}]'::jsonb, 'd', 'Le Sahara, en Afrique du Nord, est le plus grand désert chaud du monde (~9,4 millions de km²). Attention : le plus grand désert tout court est l''Antarctique, un désert froid, car un désert se définit par l''absence de précipitations, pas par le sable.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f9d3c31f-371b-5231-9b9f-9f9966d7b827', '802be628-5855-5d9a-a3c5-258a86a3e80d', 'culture-generale-geographie-fr', '⚔️ Boss ⭐⭐⭐ : Géographie', 3, 120, 30, 'boss', 'admin', 2)
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
  ('89624d8c-b6da-5334-a1bd-c18ea5a94133', 'f9d3c31f-371b-5231-9b9f-9f9966d7b827', 'Quelle est la capitale du Canada ?', '[{"id":"a","text":"Toronto"},{"id":"b","text":"Ottawa"},{"id":"c","text":"Montréal"},{"id":"d","text":"Vancouver"}]'::jsonb, 'b', 'La capitale du Canada est Ottawa, en Ontario. Le piège courant est Toronto, qui est la plus grande ville du pays : rappelle-toi que la capitale est le siège du gouvernement, pas forcément la métropole la plus peuplée.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5191940-9885-550c-8fe5-c687bcdf4aa6', 'f9d3c31f-371b-5231-9b9f-9f9966d7b827', 'Quelle est la capitale du Brésil ?', '[{"id":"a","text":"Rio de Janeiro"},{"id":"b","text":"São Paulo"},{"id":"c","text":"Brasília"},{"id":"d","text":"Salvador"}]'::jsonb, 'c', 'Brasília est la capitale du Brésil : une ville bâtie de toutes pièces et inaugurée en 1960 pour développer l''intérieur du pays. Rio de Janeiro, l''ancienne capitale, reste le piège le plus tentant car elle est mondialement connue.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('677b8c14-e759-5a29-8251-1f3aa5c5b38a', 'f9d3c31f-371b-5231-9b9f-9f9966d7b827', 'Quelle est la capitale de la Turquie ?', '[{"id":"a","text":"Istanbul"},{"id":"b","text":"Izmir"},{"id":"c","text":"Bursa"},{"id":"d","text":"Ankara"}]'::jsonb, 'd', 'La capitale de la Turquie est Ankara, choisie en 1923 par Mustafa Kemal pour sa position centrale et pour marquer une rupture avec l''époque ottomane. Istanbul, à cheval sur l''Europe et l''Asie, est la plus grande ville mais n''est pas la capitale.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f43d07e-bbc4-51c5-bd9d-ab3912fbcc08', 'f9d3c31f-371b-5231-9b9f-9f9966d7b827', 'Quel océan est le plus petit du monde ?', '[{"id":"a","text":"L''océan Arctique"},{"id":"b","text":"L''océan Indien"},{"id":"c","text":"L''océan Austral"},{"id":"d","text":"L''océan Atlantique"}]'::jsonb, 'a', 'L''océan Arctique, autour du pôle Nord, est le plus petit et le moins profond des cinq océans. Le piège est de confondre « plus petit » avec l''Austral, plus récent dans la liste : c''est bien l''Arctique le plus modeste.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb3663ab-4904-5701-ac95-32038f59324e', 'f9d3c31f-371b-5231-9b9f-9f9966d7b827', 'Quel fleuve est généralement considéré comme le plus long du monde ?', '[{"id":"a","text":"L''Amazone"},{"id":"b","text":"Le Yangtsé"},{"id":"c","text":"Le Nil"},{"id":"d","text":"Le Mississippi"}]'::jsonb, 'c', 'Le Nil (~6 650 km), en Afrique, est traditionnellement considéré comme le plus long fleuve du monde. L''Amazone le talonne de très près et certains géographes la jugent même plus longue selon la mesure retenue : c''est un débat ouvert, mais le Nil reste la réponse de référence.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e951b07-ef73-5a99-acb9-e8c071ed3dea', 'f9d3c31f-371b-5231-9b9f-9f9966d7b827', 'Le plus grand désert du monde, en superficie, est :', '[{"id":"a","text":"Le Sahara"},{"id":"b","text":"L''Antarctique"},{"id":"c","text":"Le désert d''Arabie"},{"id":"d","text":"Le désert de Gobi"}]'::jsonb, 'b', 'Le plus grand désert du monde est l''Antarctique (~14 millions de km²), un désert polaire froid. Le piège courant est le Sahara : il n''est que le plus grand désert chaud, car un désert se définit par la rareté des précipitations et non par la chaleur ou le sable.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7a987022-ab16-5eda-b64a-f4fec214a754', '802be628-5855-5d9a-a3c5-258a86a3e80d', 'culture-generale-geographie-fr', '⭐⭐ Révision : Géographie', 2, 70, 15, 'practice', 'admin', 3)
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
  ('62ec7816-6d26-503e-a159-e3f16a2ab8ad', '7a987022-ab16-5eda-b64a-f4fec214a754', 'Quelle est la capitale des États-Unis ?', '[{"id":"a","text":"New York"},{"id":"b","text":"Washington, D.C."},{"id":"c","text":"Los Angeles"},{"id":"d","text":"Chicago"}]'::jsonb, 'b', 'La capitale des États-Unis est Washington, D.C., un district fédéral distinct des États. New York, la plus grande ville et siège de l''ONU, est le piège habituel car beaucoup la croient capitale.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1ae0709-e50a-5f4b-bad2-b8616c709b28', '7a987022-ab16-5eda-b64a-f4fec214a754', 'Quel est le continent le plus peuplé du monde ?', '[{"id":"a","text":"L''Afrique"},{"id":"b","text":"L''Europe"},{"id":"c","text":"L''Asie"},{"id":"d","text":"L''Amérique"}]'::jsonb, 'c', 'L''Asie est le continent le plus peuplé : elle abrite plus de la moitié de l''humanité, dont la Chine et l''Inde, les deux pays les plus peuplés. C''est aussi le plus vaste des continents.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fded9730-e29f-5176-b285-ddcdaa583664', '7a987022-ab16-5eda-b64a-f4fec214a754', 'Quelle est la capitale de l''Espagne ?', '[{"id":"a","text":"Barcelone"},{"id":"b","text":"Séville"},{"id":"c","text":"Valence"},{"id":"d","text":"Madrid"}]'::jsonb, 'd', 'Madrid, située au centre du pays, est la capitale de l''Espagne et sa plus grande ville. Barcelone, capitale de la Catalogne et célèbre métropole côtière, est le distracteur le plus tentant.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee0ba34b-5e5d-5989-88ac-f40892643209', '7a987022-ab16-5eda-b64a-f4fec214a754', 'Sur quels deux continents s''étend la Russie ?', '[{"id":"a","text":"L''Europe et l''Asie"},{"id":"b","text":"L''Asie et l''Afrique"},{"id":"c","text":"L''Europe et l''Amérique du Nord"},{"id":"d","text":"L''Asie et l''Océanie"}]'::jsonb, 'a', 'La Russie est un pays transcontinental qui s''étend sur l''Europe (à l''ouest de l''Oural) et l''Asie (la Sibérie, à l''est). C''est aussi le plus grand pays du monde par sa superficie.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83e55dc4-256f-5e7e-a40d-ff2c24fe7b25', '7a987022-ab16-5eda-b64a-f4fec214a754', 'Quel pays a longtemps été le plus peuplé avant d''être dépassé par l''Inde en 2023 ?', '[{"id":"a","text":"L''Indonésie"},{"id":"b","text":"La Chine"},{"id":"c","text":"Les États-Unis"},{"id":"d","text":"Le Pakistan"}]'::jsonb, 'b', 'La Chine fut le pays le plus peuplé du monde pendant des décennies, jusqu''à ce que l''Inde la dépasse en 2023. La population chinoise a même commencé à décliner, conséquence d''un faible taux de natalité.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f10480c9-3796-5f8f-aa3f-78542a3fbe22', '7a987022-ab16-5eda-b64a-f4fec214a754', 'Combien d''océans compte-t-on aujourd''hui sur la Terre ?', '[{"id":"a","text":"Trois"},{"id":"b","text":"Quatre"},{"id":"c","text":"Cinq"},{"id":"d","text":"Six"}]'::jsonb, 'c', 'On reconnaît aujourd''hui 5 océans : Pacifique, Atlantique, Indien, Austral et Arctique. L''océan Austral, autour de l''Antarctique, est le plus récemment ajouté à la liste : on disait autrefois qu''il n''y en avait que quatre.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0b5d5749-10dc-5b5a-a506-f9b38ee649e0', '802be628-5855-5d9a-a3c5-258a86a3e80d', 'culture-generale-geographie-fr', '👑 Défi élite ⭐⭐⭐⭐ : Géographie', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('82b9122d-58d7-5184-abca-c1cac81c4d54', '0b5d5749-10dc-5b5a-a506-f9b38ee649e0', 'Quelle est la capitale de la Suisse ?', '[{"id":"a","text":"Zurich"},{"id":"b","text":"Genève"},{"id":"c","text":"Berne"},{"id":"d","text":"Bâle"}]'::jsonb, 'c', 'Berne est la « ville fédérale » et le siège du gouvernement suisse depuis 1848. Le piège courant est Zurich, la plus grande ville, et Genève, siège de nombreuses organisations internationales ; mais aucune des deux n''est la capitale.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9ecd10d-21f6-5fe5-ac0d-615f66742e5f', '0b5d5749-10dc-5b5a-a506-f9b38ee649e0', 'Quelle est la capitale administrative (exécutive) de l''Afrique du Sud ?', '[{"id":"a","text":"Le Cap"},{"id":"b","text":"Johannesburg"},{"id":"c","text":"Durban"},{"id":"d","text":"Pretoria"}]'::jsonb, 'd', 'L''Afrique du Sud a trois capitales : Pretoria (exécutive), Le Cap (législative) et Bloemfontein (judiciaire) ; la capitale du gouvernement est donc Pretoria. Cette répartition, datant de 1910, fut un compromis pour qu''aucune région ne domine. Johannesburg, la plus grande ville, n''a aucun de ces rôles.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('88a293bc-9c2b-5e3e-9373-b1c3b306485c', '0b5d5749-10dc-5b5a-a506-f9b38ee649e0', 'Quelle est la capitale du Kazakhstan ?', '[{"id":"a","text":"Almaty"},{"id":"b","text":"Astana"},{"id":"c","text":"Tachkent"},{"id":"d","text":"Bichkek"}]'::jsonb, 'b', 'La capitale du Kazakhstan est Astana, qui a remplacé Almaty en 1997 (elle s''est même brièvement appelée Nour-Soultan de 2019 à 2022). Tachkent et Bichkek sont des distracteurs : ce sont les capitales de l''Ouzbékistan et du Kirghizistan voisins.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('600257b3-50f1-50a6-921f-c02d66f8a69f', '0b5d5749-10dc-5b5a-a506-f9b38ee649e0', 'Quelle est la plus grande étendue d''eau intérieure (le plus grand lac) du monde ?', '[{"id":"a","text":"La mer Caspienne"},{"id":"b","text":"Le lac Supérieur"},{"id":"c","text":"Le lac Victoria"},{"id":"d","text":"Le lac Baïkal"}]'::jsonb, 'a', 'Malgré son nom de « mer », la mer Caspienne est le plus grand lac du monde par sa superficie. Le lac Supérieur est le plus grand lac d''eau douce, et le Baïkal le plus profond : ce sont les pièges classiques de cette question.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5eda1d0c-1cbb-54ed-9c69-4e24a68b9328', '0b5d5749-10dc-5b5a-a506-f9b38ee649e0', 'Quel pays est entièrement entouré par l''Afrique du Sud (enclave) ?', '[{"id":"a","text":"L''Eswatini (Swaziland)"},{"id":"b","text":"Le Botswana"},{"id":"c","text":"Le Lesotho"},{"id":"d","text":"Le Zimbabwe"}]'::jsonb, 'c', 'Le Lesotho est un État enclavé entièrement à l''intérieur de l''Afrique du Sud, un cas rare dans le monde. L''Eswatini est tentant car il est aussi petit et voisin, mais il possède une frontière avec le Mozambique : il n''est donc pas entièrement enclavé.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('599d68df-64c2-5a9e-a80b-9844bbf7701d', '0b5d5749-10dc-5b5a-a506-f9b38ee649e0', 'Quel détroit sépare l''Europe de l''Afrique en reliant l''Atlantique à la Méditerranée ?', '[{"id":"a","text":"Le détroit du Bosphore"},{"id":"b","text":"Le détroit de Gibraltar"},{"id":"c","text":"Le détroit de Messine"},{"id":"d","text":"Le canal de Suez"}]'::jsonb, 'b', 'Le détroit de Gibraltar sépare l''Espagne du Maroc et relie l''océan Atlantique à la mer Méditerranée. Le Bosphore est le piège : il sépare bien deux continents, mais c''est l''Europe de l''Asie, à Istanbul, et non l''Europe de l''Afrique.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

