-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-geographie-en (Culture générale — Géographie (EN))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-geographie-en/
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
  ('culture-generale-geographie-en', 'Culture générale — Géographie (EN)', 'Countries, capitals, continents, oceans and records of the planet: world geography in a general-knowledge format.', 'Exploration', 'subject-english', 'Globe', 14, 'en', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-geographie-en'
      AND e.source = 'admin'
      AND q.id NOT IN ('e4c6c50b-4c33-5939-81d8-19e60d9e8858', '12067dab-14ca-5365-b03a-318243a7fe97', '5a678a31-5eb5-5fc4-a989-392a34ea1aee', '0ff11f00-1ca3-5fe2-b3a4-d0427ad095d2', '084b0762-4bce-5866-b70e-ce3c6316af63', 'c9020c8d-b7fb-554b-832d-37fd51027ab0', '31addacb-a32c-5af8-bc38-749f8d502c5f', '769761e6-3f6a-51f3-b5f4-cc9c00452806', '08fcffaa-d26d-5874-b310-75181b509363', '5c89b5f4-b604-5b61-b4df-bd3e20dac180', 'e136c4d7-f1f0-53ee-bdbd-3e261fc55f31', '31c9f389-6c6a-52b6-b1b2-162039813b7e', '29bc3dde-78d1-5ab2-ab52-6879bbd1f836', '6aa1f71a-8c73-5966-902d-8adc46e0c9e7', '76abc12a-3109-5868-bd1a-8b801a2bcdc5', '58a7cf84-9697-5218-af03-ccde2bb9b0a6', '44b362da-69cd-5713-b87f-b074c671e14f', '6f8faded-b550-59a4-a0bc-9294e750aba8', '6a8e97be-8b80-51aa-aeee-e2797cbeae84', 'b94e1623-a2d6-5dcf-a5c0-1fb750590a72', '58786b45-10a2-5cad-aa7a-10414eab4ab2', '0b4ee21d-bcfa-5781-a4f9-04254283674a', '388d9385-0be2-5b1f-8dcf-67080ad867dd', 'ada238de-39a2-56a3-b747-0235b7f92214', '1747f4af-8a69-53d6-9665-d2c91d9c6df0', '8275e9b7-d087-56d6-a010-da3a835eba2d', 'a1588fa9-b58a-5d18-935b-be40fb9c290d', 'f1fb260a-b244-5382-a8e1-feaf661087c2', 'e4e5c5f2-3518-5ccf-81a2-da006d1b49ba');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-geographie-en' AND source = 'admin' AND id NOT IN ('9c3437a3-9f42-5a85-bcbb-9406b3935729', '91cf82c1-3264-5716-852b-ad3854c6ef3c', '051ce33b-5ce6-5335-9b85-3292b246a020', 'b9b18213-1db6-5199-83cb-c15b87b2fb9b', 'f2d68c41-9bb5-5be4-b151-be60c0b848ed');
DELETE FROM public.questions WHERE exercise_id IN ('9c3437a3-9f42-5a85-bcbb-9406b3935729', '91cf82c1-3264-5716-852b-ad3854c6ef3c', '051ce33b-5ce6-5335-9b85-3292b246a020', 'b9b18213-1db6-5199-83cb-c15b87b2fb9b', 'f2d68c41-9bb5-5be4-b151-be60c0b848ed') AND id NOT IN ('e4c6c50b-4c33-5939-81d8-19e60d9e8858', '12067dab-14ca-5365-b03a-318243a7fe97', '5a678a31-5eb5-5fc4-a989-392a34ea1aee', '0ff11f00-1ca3-5fe2-b3a4-d0427ad095d2', '084b0762-4bce-5866-b70e-ce3c6316af63', 'c9020c8d-b7fb-554b-832d-37fd51027ab0', '31addacb-a32c-5af8-bc38-749f8d502c5f', '769761e6-3f6a-51f3-b5f4-cc9c00452806', '08fcffaa-d26d-5874-b310-75181b509363', '5c89b5f4-b604-5b61-b4df-bd3e20dac180', 'e136c4d7-f1f0-53ee-bdbd-3e261fc55f31', '31c9f389-6c6a-52b6-b1b2-162039813b7e', '29bc3dde-78d1-5ab2-ab52-6879bbd1f836', '6aa1f71a-8c73-5966-902d-8adc46e0c9e7', '76abc12a-3109-5868-bd1a-8b801a2bcdc5', '58a7cf84-9697-5218-af03-ccde2bb9b0a6', '44b362da-69cd-5713-b87f-b074c671e14f', '6f8faded-b550-59a4-a0bc-9294e750aba8', '6a8e97be-8b80-51aa-aeee-e2797cbeae84', 'b94e1623-a2d6-5dcf-a5c0-1fb750590a72', '58786b45-10a2-5cad-aa7a-10414eab4ab2', '0b4ee21d-bcfa-5781-a4f9-04254283674a', '388d9385-0be2-5b1f-8dcf-67080ad867dd', 'ada238de-39a2-56a3-b747-0235b7f92214', '1747f4af-8a69-53d6-9665-d2c91d9c6df0', '8275e9b7-d087-56d6-a010-da3a835eba2d', 'a1588fa9-b58a-5d18-935b-be40fb9c290d', 'f1fb260a-b244-5382-a8e1-feaf661087c2', 'e4e5c5f2-3518-5ccf-81a2-da006d1b49ba');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-geographie-en' AND c.id NOT IN ('f314d816-1cfb-5fef-8da2-23e38b46ce1f') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('f314d816-1cfb-5fef-8da2-23e38b46ce1f', 'culture-generale-geographie-en', 'Countries and capitals', 'World capitals (including the famous traps), continents, oceans and the great geographical records of the planet.', '# ⚔️ World atlas — set off to conquer countries and capitals

> 💡 "Whoever knows the map never gets lost: every capital is a gateway, every border a challenge."

Welcome, explorer. This chapter is your first geographical dungeon. You will learn to read the planet the way an adventurer reads a treasure map: the **continents**, the **oceans**, the **countries**, their **capitals** and the great **records** that make Earth such a fascinating world. Master them, and no general-knowledge question will ever catch you off guard again.

## 🌍 Continents and oceans

The Earth traditionally has **7 continents**: Asia, Africa, North America, South America, Antarctica, Europe and Oceania. **Asia** is by far the largest and the most populated.

As for the waters, there are **5 oceans**. The largest is the **Pacific Ocean**, followed by the Atlantic, the Indian, the Southern and the Arctic (the smallest).

| Element | Record | Detail |
|---|---|---|
| Largest continent | **Asia** | ~44.5 million km² |
| Largest ocean | **Pacific** | covers nearly a third of the globe |
| Largest desert | **Antarctica** | cold desert, ~14 million km² |
| Largest hot desert | **Sahara** | ~9.4 million km² |

> 🗡️ Adventurer''s tip: a **desert** is defined by its lack of precipitation, not by sand. That is why icy **Antarctica** is the largest desert in the world.

## 🏛️ Capitals… and their traps

A **capital** is the city where a country''s government is seated — it is not always the most famous city! Examiners love these traps:

- **Australia** → the capital is **Canberra**, not Sydney or Melbourne (Canberra was created in 1913 as a compromise between the two rivals).
- **Canada** → **Ottawa**, not Toronto.
- **Brazil** → **Brasília**, a city built from scratch and inaugurated in 1960, not Rio de Janeiro.
- **Turkey** → **Ankara**, not Istanbul (Ankara became the capital in 1923).
- **United States** → **Washington, D.C.**, not New York.

> ⚠️ Classic trap: a country''s largest city is not necessarily its capital. Always check which city houses the **seat of government**.

## 📏 The giant countries and the tiny countries

The largest country in the world by area is **Russia** (~17 million km²), which spans two continents, Europe and Asia. The smallest is **Vatican City** (~0.44 km²), enclosed within Rome.

| Superlative | Country | Remember |
|---|---|---|
| Largest country | **Russia** | straddles 2 continents |
| Smallest country | **Vatican City** | a sovereign state inside Rome |
| Most populated country | **India** | overtook China in 2023 |

## 👥 Shifting demographics

For decades, **China** was the most populated country. But in **2023**, **India** overtook it and now has more than **1.4 billion** inhabitants. The world''s population is therefore not fixed: it shifts, and the map of records keeps changing.

## 🏔️ The natural records to know

- Highest peak: **Mount Everest**, at **8,849 m** (Nepal–China border).
- Longest river: the **Nile** (~6,650 km) in Africa, closely followed by the **Amazon** — a debate still open among geographers.
- Largest hot desert: the **Sahara**, in North Africa.

> 🏆 First gateway cleared! You can now tell continents, oceans, trap capitals and the records of the planet apart. Sharpen your mental map: the next dungeon will take you further into the wonders of the world.', '# 📜 Summary: Countries and capitals

- **7 continents**: Asia is the largest and the most populated.
- **5 oceans**: the **Pacific** is the largest, the Arctic the smallest.
- **Capital ≠ largest city**: Australia → **Canberra**, Canada → **Ottawa**, Brazil → **Brasília**, Turkey → **Ankara**, United States → **Washington, D.C.**
- **Largest country**: **Russia** (~17 million km²), straddling Europe and Asia.
- **Smallest country**: **Vatican City** (~0.44 km²), enclosed within Rome.
- **Most populated country**: **India**, which overtook China in **2023** (more than 1.4 billion inhabitants).
- **Largest desert**: **Antarctica** (a cold desert); the largest hot desert is the **Sahara**.
- **Natural records**: highest peak **Mount Everest** (8,849 m); longest river the **Nile** (~6,650 km).', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9c3437a3-9f42-5a85-bcbb-9406b3935729', 'f314d816-1cfb-5fef-8da2-23e38b46ce1f', 'culture-generale-geographie-en', 'Comprehension test ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('e4c6c50b-4c33-5939-81d8-19e60d9e8858', '9c3437a3-9f42-5a85-bcbb-9406b3935729', 'What is the capital of Australia?', '[{"id":"a","text":"Sydney"},{"id":"b","text":"Melbourne"},{"id":"c","text":"Canberra"},{"id":"d","text":"Perth"}]'::jsonb, 'c', 'The capital of Australia is Canberra, created in 1913 as a political compromise between Sydney and Melbourne, which were both vying for the title. Sydney is the country''s largest city, but the capital is where the government is seated.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12067dab-14ca-5365-b03a-318243a7fe97', '9c3437a3-9f42-5a85-bcbb-9406b3935729', 'Which is the largest country in the world by area?', '[{"id":"a","text":"Russia"},{"id":"b","text":"Canada"},{"id":"c","text":"China"},{"id":"d","text":"The United States"}]'::jsonb, 'a', 'Russia is the largest country in the world at about 17 million km², straddling Europe and Asia. Canada comes second: it is a common trap, because it is vast but still nearly twice as small as Russia.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a678a31-5eb5-5fc4-a989-392a34ea1aee', '9c3437a3-9f42-5a85-bcbb-9406b3935729', 'What is the largest ocean in the world?', '[{"id":"a","text":"The Atlantic Ocean"},{"id":"b","text":"The Indian Ocean"},{"id":"c","text":"The Arctic Ocean"},{"id":"d","text":"The Pacific Ocean"}]'::jsonb, 'd', 'The Pacific Ocean is the largest: it alone covers nearly a third of the planet''s surface. The Atlantic is second; the Arctic is the smallest of the five oceans.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ff11f00-1ca3-5fe2-b3a4-d0427ad095d2', '9c3437a3-9f42-5a85-bcbb-9406b3935729', 'Since 2023, which country is the most populated in the world?', '[{"id":"a","text":"China"},{"id":"b","text":"India"},{"id":"c","text":"The United States"},{"id":"d","text":"Indonesia"}]'::jsonb, 'b', 'India overtook China in 2023 and now has more than 1.4 billion inhabitants. China held this record for a long time, but its population has begun to decline, while India''s keeps growing.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('084b0762-4bce-5866-b70e-ce3c6316af63', '9c3437a3-9f42-5a85-bcbb-9406b3935729', 'How many continents does the Earth traditionally have?', '[{"id":"a","text":"Five"},{"id":"b","text":"Six"},{"id":"c","text":"Seven"},{"id":"d","text":"Eight"}]'::jsonb, 'c', 'There are traditionally 7 continents: Asia, Africa, North America, South America, Antarctica, Europe and Oceania. Asia is the largest and the most populated of them all.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('91cf82c1-3264-5716-852b-ad3854c6ef3c', 'f314d816-1cfb-5fef-8da2-23e38b46ce1f', 'culture-generale-geographie-en', '⭐ Quiz: Geography', 1, 50, 10, 'practice', 'admin', 1)
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
  ('c9020c8d-b7fb-554b-832d-37fd51027ab0', '91cf82c1-3264-5716-852b-ad3854c6ef3c', 'What is the capital of France?', '[{"id":"a","text":"Lyon"},{"id":"b","text":"Marseille"},{"id":"c","text":"Paris"},{"id":"d","text":"Bordeaux"}]'::jsonb, 'c', 'Paris is the capital of France and its largest city. Crossed by the Seine, it houses the seat of government and the institutions of the Republic.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31addacb-a32c-5af8-bc38-749f8d502c5f', '91cf82c1-3264-5716-852b-ad3854c6ef3c', 'On which continent is Egypt located?', '[{"id":"a","text":"Asia"},{"id":"b","text":"Africa"},{"id":"c","text":"Europe"},{"id":"d","text":"Oceania"}]'::jsonb, 'b', 'Egypt lies in North Africa, crossed by the Nile. A small part of its territory, the Sinai, is in Asia: that is what makes the question tricky, but the country belongs to Africa.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('769761e6-3f6a-51f3-b5f4-cc9c00452806', '91cf82c1-3264-5716-852b-ad3854c6ef3c', 'What is the smallest country in the world by area?', '[{"id":"a","text":"Monaco"},{"id":"b","text":"Vatican City"},{"id":"c","text":"San Marino"},{"id":"d","text":"Liechtenstein"}]'::jsonb, 'b', 'Vatican City is the smallest state in the world, at about 0.44 km², entirely enclosed within the city of Rome. Monaco is the second smallest: that is the classic trap of this question.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08fcffaa-d26d-5874-b310-75181b509363', '91cf82c1-3264-5716-852b-ad3854c6ef3c', 'What is the capital of Japan?', '[{"id":"a","text":"Osaka"},{"id":"b","text":"Kyoto"},{"id":"c","text":"Tokyo"},{"id":"d","text":"Nagoya"}]'::jsonb, 'c', 'Tokyo has been the capital of Japan since 1868. Kyoto, the former imperial capital, is a frequent trap: it lost that status when the emperor moved to Tokyo ("the Eastern capital").', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c89b5f4-b604-5b61-b4df-bd3e20dac180', '91cf82c1-3264-5716-852b-ad3854c6ef3c', 'What is the highest peak in the world?', '[{"id":"a","text":"Mount Everest"},{"id":"b","text":"K2"},{"id":"c","text":"Mont Blanc"},{"id":"d","text":"Kilimanjaro"}]'::jsonb, 'a', 'Mount Everest, at 8,849 m, is the highest peak in the world; it rises on the border between Nepal and China. K2 is the second highest, which makes it a tempting distractor.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e136c4d7-f1f0-53ee-bdbd-3e261fc55f31', '91cf82c1-3264-5716-852b-ad3854c6ef3c', 'What is the largest hot desert in the world?', '[{"id":"a","text":"The Gobi Desert"},{"id":"b","text":"The Arabian Desert"},{"id":"c","text":"The Kalahari Desert"},{"id":"d","text":"The Sahara"}]'::jsonb, 'd', 'The Sahara, in North Africa, is the largest hot desert in the world (~9.4 million km²). Careful: the largest desert overall is Antarctica, a cold desert, because a desert is defined by the absence of precipitation, not by sand.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('051ce33b-5ce6-5335-9b85-3292b246a020', 'f314d816-1cfb-5fef-8da2-23e38b46ce1f', 'culture-generale-geographie-en', '⚔️ Boss ⭐⭐⭐: Geography', 3, 120, 30, 'boss', 'admin', 2)
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
  ('31c9f389-6c6a-52b6-b1b2-162039813b7e', '051ce33b-5ce6-5335-9b85-3292b246a020', 'What is the capital of Canada?', '[{"id":"a","text":"Toronto"},{"id":"b","text":"Ottawa"},{"id":"c","text":"Montreal"},{"id":"d","text":"Vancouver"}]'::jsonb, 'b', 'The capital of Canada is Ottawa, in Ontario. The common trap is Toronto, which is the country''s largest city: remember that the capital is the seat of government, not necessarily the most populated metropolis.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29bc3dde-78d1-5ab2-ab52-6879bbd1f836', '051ce33b-5ce6-5335-9b85-3292b246a020', 'What is the capital of Brazil?', '[{"id":"a","text":"Rio de Janeiro"},{"id":"b","text":"São Paulo"},{"id":"c","text":"Brasília"},{"id":"d","text":"Salvador"}]'::jsonb, 'c', 'Brasília is the capital of Brazil: a city built from scratch and inaugurated in 1960 to develop the country''s interior. Rio de Janeiro, the former capital, remains the most tempting trap because it is world-famous.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6aa1f71a-8c73-5966-902d-8adc46e0c9e7', '051ce33b-5ce6-5335-9b85-3292b246a020', 'What is the capital of Turkey?', '[{"id":"a","text":"Istanbul"},{"id":"b","text":"Izmir"},{"id":"c","text":"Bursa"},{"id":"d","text":"Ankara"}]'::jsonb, 'd', 'The capital of Turkey is Ankara, chosen in 1923 by Mustafa Kemal for its central location and to mark a break with the Ottoman era. Istanbul, straddling Europe and Asia, is the largest city but is not the capital.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76abc12a-3109-5868-bd1a-8b801a2bcdc5', '051ce33b-5ce6-5335-9b85-3292b246a020', 'Which ocean is the smallest in the world?', '[{"id":"a","text":"The Arctic Ocean"},{"id":"b","text":"The Indian Ocean"},{"id":"c","text":"The Southern Ocean"},{"id":"d","text":"The Atlantic Ocean"}]'::jsonb, 'a', 'The Arctic Ocean, around the North Pole, is the smallest and shallowest of the five oceans. The trap is to confuse "smallest" with the Southern Ocean, the most recent on the list: it really is the Arctic that is the most modest.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('58a7cf84-9697-5218-af03-ccde2bb9b0a6', '051ce33b-5ce6-5335-9b85-3292b246a020', 'Which river is generally considered the longest in the world?', '[{"id":"a","text":"The Amazon"},{"id":"b","text":"The Yangtze"},{"id":"c","text":"The Nile"},{"id":"d","text":"The Mississippi"}]'::jsonb, 'c', 'The Nile (~6,650 km), in Africa, is traditionally considered the longest river in the world. The Amazon follows very closely and some geographers even judge it longer depending on the measurement used: it is an open debate, but the Nile remains the reference answer.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44b362da-69cd-5713-b87f-b074c671e14f', '051ce33b-5ce6-5335-9b85-3292b246a020', 'The largest desert in the world, by area, is:', '[{"id":"a","text":"The Sahara"},{"id":"b","text":"Antarctica"},{"id":"c","text":"The Arabian Desert"},{"id":"d","text":"The Gobi Desert"}]'::jsonb, 'b', 'The largest desert in the world is Antarctica (~14 million km²), a cold polar desert. The common trap is the Sahara: it is only the largest hot desert, because a desert is defined by scarce precipitation and not by heat or sand.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b9b18213-1db6-5199-83cb-c15b87b2fb9b', 'f314d816-1cfb-5fef-8da2-23e38b46ce1f', 'culture-generale-geographie-en', '⭐⭐ Review: Geography', 2, 70, 15, 'practice', 'admin', 3)
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
  ('6f8faded-b550-59a4-a0bc-9294e750aba8', 'b9b18213-1db6-5199-83cb-c15b87b2fb9b', 'What is the capital of the United States?', '[{"id":"a","text":"New York"},{"id":"b","text":"Washington, D.C."},{"id":"c","text":"Los Angeles"},{"id":"d","text":"Chicago"}]'::jsonb, 'b', 'The capital of the United States is Washington, D.C., a federal district distinct from the states. New York, the largest city and home to the UN headquarters, is the usual trap because many believe it is the capital.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a8e97be-8b80-51aa-aeee-e2797cbeae84', 'b9b18213-1db6-5199-83cb-c15b87b2fb9b', 'Which is the most populated continent in the world?', '[{"id":"a","text":"Africa"},{"id":"b","text":"Europe"},{"id":"c","text":"Asia"},{"id":"d","text":"America"}]'::jsonb, 'c', 'Asia is the most populated continent: it is home to more than half of humanity, including China and India, the two most populated countries. It is also the largest of the continents.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b94e1623-a2d6-5dcf-a5c0-1fb750590a72', 'b9b18213-1db6-5199-83cb-c15b87b2fb9b', 'What is the capital of Spain?', '[{"id":"a","text":"Barcelona"},{"id":"b","text":"Seville"},{"id":"c","text":"Valencia"},{"id":"d","text":"Madrid"}]'::jsonb, 'd', 'Madrid, located in the centre of the country, is the capital of Spain and its largest city. Barcelona, the capital of Catalonia and a famous coastal metropolis, is the most tempting distractor.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('58786b45-10a2-5cad-aa7a-10414eab4ab2', 'b9b18213-1db6-5199-83cb-c15b87b2fb9b', 'Across which two continents does Russia extend?', '[{"id":"a","text":"Europe and Asia"},{"id":"b","text":"Asia and Africa"},{"id":"c","text":"Europe and North America"},{"id":"d","text":"Asia and Oceania"}]'::jsonb, 'a', 'Russia is a transcontinental country that extends across Europe (west of the Urals) and Asia (Siberia, to the east). It is also the largest country in the world by area.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b4ee21d-bcfa-5781-a4f9-04254283674a', 'b9b18213-1db6-5199-83cb-c15b87b2fb9b', 'Which country was for a long time the most populated before being overtaken by India in 2023?', '[{"id":"a","text":"Indonesia"},{"id":"b","text":"China"},{"id":"c","text":"The United States"},{"id":"d","text":"Pakistan"}]'::jsonb, 'b', 'China was the most populated country in the world for decades, until India overtook it in 2023. China''s population has even begun to decline, a consequence of a low birth rate.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('388d9385-0be2-5b1f-8dcf-67080ad867dd', 'b9b18213-1db6-5199-83cb-c15b87b2fb9b', 'How many oceans are recognized on Earth today?', '[{"id":"a","text":"Three"},{"id":"b","text":"Four"},{"id":"c","text":"Five"},{"id":"d","text":"Six"}]'::jsonb, 'c', 'Today 5 oceans are recognized: Pacific, Atlantic, Indian, Southern and Arctic. The Southern Ocean, around Antarctica, is the most recently added to the list: it used to be said there were only four.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f2d68c41-9bb5-5be4-b151-be60c0b848ed', 'f314d816-1cfb-5fef-8da2-23e38b46ce1f', 'culture-generale-geographie-en', '👑 Elite challenge ⭐⭐⭐⭐: Geography', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('ada238de-39a2-56a3-b747-0235b7f92214', 'f2d68c41-9bb5-5be4-b151-be60c0b848ed', 'What is the capital of Switzerland?', '[{"id":"a","text":"Zurich"},{"id":"b","text":"Geneva"},{"id":"c","text":"Bern"},{"id":"d","text":"Basel"}]'::jsonb, 'c', 'Bern is the "federal city" and the seat of the Swiss government since 1848. The common trap is Zurich, the largest city, and Geneva, home to many international organizations; but neither of them is the capital.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1747f4af-8a69-53d6-9665-d2c91d9c6df0', 'f2d68c41-9bb5-5be4-b151-be60c0b848ed', 'What is the administrative (executive) capital of South Africa?', '[{"id":"a","text":"Cape Town"},{"id":"b","text":"Johannesburg"},{"id":"c","text":"Durban"},{"id":"d","text":"Pretoria"}]'::jsonb, 'd', 'South Africa has three capitals: Pretoria (executive), Cape Town (legislative) and Bloemfontein (judicial); the seat of government is therefore Pretoria. This split, dating from 1910, was a compromise so that no region would dominate. Johannesburg, the largest city, holds none of these roles.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8275e9b7-d087-56d6-a010-da3a835eba2d', 'f2d68c41-9bb5-5be4-b151-be60c0b848ed', 'What is the capital of Kazakhstan?', '[{"id":"a","text":"Almaty"},{"id":"b","text":"Astana"},{"id":"c","text":"Tashkent"},{"id":"d","text":"Bishkek"}]'::jsonb, 'b', 'The capital of Kazakhstan is Astana, which replaced Almaty in 1997 (it was even briefly named Nur-Sultan from 2019 to 2022). Tashkent and Bishkek are distractors: they are the capitals of neighbouring Uzbekistan and Kyrgyzstan.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1588fa9-b58a-5d18-935b-be40fb9c290d', 'f2d68c41-9bb5-5be4-b151-be60c0b848ed', 'What is the largest inland body of water (the largest lake) in the world?', '[{"id":"a","text":"The Caspian Sea"},{"id":"b","text":"Lake Superior"},{"id":"c","text":"Lake Victoria"},{"id":"d","text":"Lake Baikal"}]'::jsonb, 'a', 'Despite its name of "sea," the Caspian Sea is the largest lake in the world by area. Lake Superior is the largest freshwater lake, and Baikal the deepest: those are the classic traps of this question.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1fb260a-b244-5382-a8e1-feaf661087c2', 'f2d68c41-9bb5-5be4-b151-be60c0b848ed', 'Which country is entirely surrounded by South Africa (an enclave)?', '[{"id":"a","text":"Eswatini (Swaziland)"},{"id":"b","text":"Botswana"},{"id":"c","text":"Lesotho"},{"id":"d","text":"Zimbabwe"}]'::jsonb, 'c', 'Lesotho is a state entirely enclosed within South Africa, a rare case in the world. Eswatini is tempting because it is also small and nearby, but it shares a border with Mozambique: so it is not entirely enclaved.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4e5c5f2-3518-5ccf-81a2-da006d1b49ba', 'f2d68c41-9bb5-5be4-b151-be60c0b848ed', 'Which strait separates Europe from Africa, linking the Atlantic to the Mediterranean?', '[{"id":"a","text":"The Bosphorus Strait"},{"id":"b","text":"The Strait of Gibraltar"},{"id":"c","text":"The Strait of Messina"},{"id":"d","text":"The Suez Canal"}]'::jsonb, 'b', 'The Strait of Gibraltar separates Spain from Morocco and links the Atlantic Ocean to the Mediterranean Sea. The Bosphorus is the trap: it does separate two continents, but it is Europe from Asia, at Istanbul, and not Europe from Africa.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

