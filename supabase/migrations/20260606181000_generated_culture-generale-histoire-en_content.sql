-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-histoire-en (Culture générale — Histoire (EN))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-histoire-en/
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
  ('culture-generale-histoire-en', 'Culture générale — Histoire (EN)', 'The great dates and figures of world and Tunisian history, from Antiquity to the present day, to build a solid grounding in historical knowledge.', 'Mémoire', 'subject-svt', 'Landmark', 11, 'en', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-histoire-en'
      AND e.source = 'admin'
      AND q.id NOT IN ('ee99053f-7f5d-545f-b4f4-b8be41e55339', '51fc430e-3536-5827-970f-14cb613c094b', '564b51dc-dac0-5fb0-8017-b5d523660d76', '2642f5ca-ce2a-5c97-8c1b-3c8169f1c928', '937d8642-a6fa-5b42-a69c-c55191e88541', '1fdcce0f-9f04-59cb-918d-2f843325e416', 'a343bbfa-8d3e-54c2-85f3-d5b27987c0e8', 'c30a93c5-f3ca-57d7-a7ec-de7a6c38c5bf', 'ea2cffa7-27a5-5c2a-b69a-46d5db0c7d68', 'd07b6dca-4ecf-5ad0-9847-46e28fb4064a', 'd28ed78d-ed46-5747-83fa-4f35806130e9', '53346222-b549-5038-8f7a-c4cbe0ad3886', 'be43cb6a-399c-53d4-bace-88e4a8e6011c', '239442db-cc0a-5b2c-bfb6-fa2d32143e38', 'd61f1f78-74a6-5766-b674-3127d912be0d', '0d899cf4-ffc8-548e-a60f-717ca4142e3c', '16960795-b4ab-544e-b743-dc80a5a7dd92', '96da4dab-83e4-5183-8de5-dcb06470d802', '36ad78c8-aaca-5bba-a47d-d8a909d593a3', '98243e2b-ee81-566f-9569-252f8e2c5a12', '69c5d77b-4b50-5fce-88c9-77e0076ba139', '3699eeb7-a859-5082-b03e-37e8c08386b5', '01ce4b70-78f3-568e-9717-686b7a8d9709', 'd656c6d5-3eb1-5a3d-b01e-9e16c26d1615', '8d98a3bd-f650-5bb9-989c-d32f061fe39a', '9b0e1b01-5d34-513a-8cc2-54b741bbcc18', '013b824a-e5cf-5a09-afdb-e08f44c00054', 'fb4cff1f-36d8-56ed-a68e-7cb7bfb27b1d', '7c9f3f61-bd7d-5909-8721-9810bf19038f');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-histoire-en' AND source = 'admin' AND id NOT IN ('1cb82e92-904b-52e2-b0a3-96ea653f2b71', 'f948385f-a439-5d93-b58a-52a8d9eb8ae3', '8c67294b-517d-5c15-8754-01f591e8f208', 'ceb989dc-3e31-526c-8c4e-068f645a4e86', '2f581c54-d8ed-5c45-91b7-26dbb9dc3379');
DELETE FROM public.questions WHERE exercise_id IN ('1cb82e92-904b-52e2-b0a3-96ea653f2b71', 'f948385f-a439-5d93-b58a-52a8d9eb8ae3', '8c67294b-517d-5c15-8754-01f591e8f208', 'ceb989dc-3e31-526c-8c4e-068f645a4e86', '2f581c54-d8ed-5c45-91b7-26dbb9dc3379') AND id NOT IN ('ee99053f-7f5d-545f-b4f4-b8be41e55339', '51fc430e-3536-5827-970f-14cb613c094b', '564b51dc-dac0-5fb0-8017-b5d523660d76', '2642f5ca-ce2a-5c97-8c1b-3c8169f1c928', '937d8642-a6fa-5b42-a69c-c55191e88541', '1fdcce0f-9f04-59cb-918d-2f843325e416', 'a343bbfa-8d3e-54c2-85f3-d5b27987c0e8', 'c30a93c5-f3ca-57d7-a7ec-de7a6c38c5bf', 'ea2cffa7-27a5-5c2a-b69a-46d5db0c7d68', 'd07b6dca-4ecf-5ad0-9847-46e28fb4064a', 'd28ed78d-ed46-5747-83fa-4f35806130e9', '53346222-b549-5038-8f7a-c4cbe0ad3886', 'be43cb6a-399c-53d4-bace-88e4a8e6011c', '239442db-cc0a-5b2c-bfb6-fa2d32143e38', 'd61f1f78-74a6-5766-b674-3127d912be0d', '0d899cf4-ffc8-548e-a60f-717ca4142e3c', '16960795-b4ab-544e-b743-dc80a5a7dd92', '96da4dab-83e4-5183-8de5-dcb06470d802', '36ad78c8-aaca-5bba-a47d-d8a909d593a3', '98243e2b-ee81-566f-9569-252f8e2c5a12', '69c5d77b-4b50-5fce-88c9-77e0076ba139', '3699eeb7-a859-5082-b03e-37e8c08386b5', '01ce4b70-78f3-568e-9717-686b7a8d9709', 'd656c6d5-3eb1-5a3d-b01e-9e16c26d1615', '8d98a3bd-f650-5bb9-989c-d32f061fe39a', '9b0e1b01-5d34-513a-8cc2-54b741bbcc18', '013b824a-e5cf-5a09-afdb-e08f44c00054', 'fb4cff1f-36d8-56ed-a68e-7cb7bfb27b1d', '7c9f3f61-bd7d-5909-8721-9810bf19038f');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-histoire-en' AND c.id NOT IN ('fcb54b51-38cc-5c1a-890b-f4eddd42ff70') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('fcb54b51-38cc-5c1a-890b-f4eddd42ff70', 'culture-generale-histoire-en', 'The Great Dates of History', 'A journey through the major turning points of world and Tunisian history: the fall of Rome, 1492, the French Revolution, the world wars, Tunisia''s independence, the conquest of the Moon and the fall of the Berlin Wall.', '# ⚔️ The Great Dates of History — the timeline of heroes and empires

> 💡 "A people who ignore their past walk forward blindfolded. To know the dates is to hold the map of time."

Welcome, apprentice chrono-mage. This first gateway opens for you the great timeline of humanity: the decisive battles, the revolutions that toppled kings, the discoveries that changed the world. Each date is a key. Memorize them, and time will hold no more secrets for you.

## 🏛️ Antiquity fades away (476)

For centuries, **Rome** dominated the Mediterranean world. But the Empire grew weaker, split between **West** and **East**.

- In **476**, the Germanic chieftain **Odoacer** deposed the young emperor **Romulus Augustulus**: this is the conventional end of the **Western Roman Empire**.
- This date traditionally marks the **end of Antiquity** and the beginning of the **Middle Ages**.
- The **Eastern** Roman Empire (Byzantium), however, would survive for nearly a thousand more years, until **1453**.

> 🗡️ Memory tip: 476 = the fall of Rome; 1453 = the fall of Constantinople. Two "endings" that bracket the entire Middle Ages.

## 🌍 The world grows larger (1492)

- In **1492**, **Christopher Columbus**, funded by Spain, reached an island in the **Bahamas** while searching for a westward route to the Indies.
- He believed he had found Asia: he would never know that he had landed on a **New World**.
- This date opened the age of the **Great Discoveries** and is often taken as the start of the **Early Modern period**.

> ⚠️ Classic trap: Columbus did **not** "discover" America for humanity — the **Vikings** had landed there around the year 1000, and peoples had lived there for thousands of years. His crossing chiefly forged a lasting link between the two worlds.

## 🔥 The French Revolution (1789)

The founding event of modern France and a universal symbol of liberty.

- On **14 July 1789**, the people of Paris stormed the **Bastille**, a royal prison-fortress: the symbolic beginning of the **French Revolution**.
- On **26 August 1789**, the Assembly adopted the **Declaration of the Rights of Man and of the Citizen**.
- The **14th of July** would become the French **national holiday** in **1880**.

## 📅 The timeline of major turning points

| Date | Event | What it changes |
|---|---|---|
| **476** | Fall of Rome (West) | End of Antiquity |
| **1492** | Columbus reaches America | Start of the Early Modern period |
| **1789** | Storming of the Bastille | Birth of modern France |
| **1914-1918** | First World War | Collapse of the empires |
| **1939-1945** | Second World War | Birth of the UN |
| **1969** | First steps on the Moon | Humanity leaves the Earth |
| **1989** | Fall of the Berlin Wall | End of the Cold War |

## 🌐 The two world wars (1914-1945)

- The **First World War** (1914-1918) ended with the **armistice of 11 November 1918**, signed at Rethondes.
- The **Second World War** (1939-1945) ended in Europe on **8 May 1945** (German surrender) and worldwide on **2 September 1945** (Japan''s surrender).
- From its ruins was born the **United Nations (UN)** in **1945**, to safeguard peace.

## 🇹🇳 Tunisia''s independence (1956)

A pivotal turning point in our national history.

- On **20 March 1956**, France recognized Tunisia''s **independence** and abrogated the **Treaty of Bardo** of 1881, which had established the protectorate.
- Its principal architect was **Habib Bourguiba**, leader of the **Neo-Destour**, who would become the first president of the Tunisian Republic in **1957**.
- The **20th of March** is today Tunisia''s **national holiday**.

## 🚀 Humanity conquers space (1969)

- On **21 July 1969** (French time), **Neil Armstrong** became the first person to walk on the **Moon**, during the **Apollo 11** mission.
- His sentence remains famous: "*That''s one small step for man, one giant leap for mankind.*"
- The feat, watched by around **600 million** television viewers, marked the high point of the **space race** between the United States and the USSR.

> 🏆 First gateway cleared, chrono-mage! You now hold the key dates of world and Tunisian history. At the next level, the great figures and civilizations await you — sharpen your memory, the battle goes on.', '# 📜 Summary: The Great Dates of History

- **476**: the Germanic chieftain Odoacer deposes Romulus Augustulus → fall of the **Western Roman Empire** and end of Antiquity.
- **1492**: **Christopher Columbus** reaches America (the Bahamas) → start of the Great Discoveries and the Early Modern period.
- **14 July 1789**: **storming of the Bastille** → beginning of the **French Revolution**; the Declaration of the Rights of Man follows on 26 August.
- **1914-1918**: **First World War**, ended by the **armistice of 11 November 1918** at Rethondes.
- **1939-1945**: **Second World War**; German surrender on **8 May 1945**, Japanese surrender on **2 September 1945**; creation of the **UN** in 1945.
- **20 March 1956**: **Tunisia''s independence**, won thanks to **Habib Bourguiba** and the Neo-Destour; Tunisia''s national holiday.
- **21 July 1969**: **Neil Armstrong** (Apollo 11) is the first person on the **Moon**.
- **9 November 1989**: **fall of the Berlin Wall** → symbol of the end of the **Cold War** and of the East-West divide.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1cb82e92-904b-52e2-b0a3-96ea653f2b71', 'fcb54b51-38cc-5c1a-890b-f4eddd42ff70', 'culture-generale-histoire-en', 'Comprehension test ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('ee99053f-7f5d-545f-b4f4-b8be41e55339', '1cb82e92-904b-52e2-b0a3-96ea653f2b71', 'Which event, on 14 July 1789, marks the symbolic beginning of the French Revolution?', '[{"id":"a","text":"The coronation of Napoleon I"},{"id":"b","text":"The storming of the Bastille"},{"id":"c","text":"The Battle of Waterloo"},{"id":"d","text":"The proclamation of the Republic"}]'::jsonb, 'b', 'On 14 July 1789, the people of Paris stormed the Bastille, a prison-fortress that symbolized royal absolutism: this is the symbolic beginning of the French Revolution. The date became the French national holiday in 1880. Napoleon''s coronation (a) dates from 1804 and Waterloo (c) from 1815; the First Republic (d) would not be proclaimed until 1792.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51fc430e-3536-5827-970f-14cb613c094b', '1cb82e92-904b-52e2-b0a3-96ea653f2b71', 'In what year did Christopher Columbus reach the American continent?', '[{"id":"a","text":"1452"},{"id":"b","text":"1789"},{"id":"c","text":"1492"},{"id":"d","text":"1519"}]'::jsonb, 'c', 'On 12 October 1492, Christopher Columbus landed on an island in the Bahamas while searching for a westward route to the Indies, opening the age of the Great Discoveries. He believed until his death that he had reached Asia. The year 1519 (d) marks the start of Magellan''s expedition; 1452 (a) is instead the birth year of Leonardo da Vinci.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('564b51dc-dac0-5fb0-8017-b5d523660d76', '1cb82e92-904b-52e2-b0a3-96ea653f2b71', 'The fall of which wall, on 9 November 1989, symbolizes the end of the Cold War?', '[{"id":"a","text":"Hadrian''s Wall"},{"id":"b","text":"The Great Wall of China"},{"id":"c","text":"The Berlin Wall"},{"id":"d","text":"The Western Wall"}]'::jsonb, 'c', 'On 9 November 1989, the Berlin Wall, which since 1961 had separated communist East Germany from the West, was opened: it is the symbol of the end of the Cold War and of the East-West divide. Hadrian''s Wall (a) is a Roman fortification in Britain, the Great Wall (b) protected China, and the Western Wall (d) is a sacred site in Jerusalem.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2642f5ca-ce2a-5c97-8c1b-3c8169f1c928', '1cb82e92-904b-52e2-b0a3-96ea653f2b71', 'Which country gained its independence on 20 March 1956, a date that became its national holiday?', '[{"id":"a","text":"Morocco"},{"id":"b","text":"Algeria"},{"id":"c","text":"Libya"},{"id":"d","text":"Tunisia"}]'::jsonb, 'd', 'On 20 March 1956, France recognized Tunisia''s independence and abrogated the Treaty of Bardo of 1881. Habib Bourguiba, leader of the Neo-Destour, was its principal architect. Morocco (a) became independent a few weeks earlier in 1956, Algeria (b) in 1962, and Libya (c) as early as 1951.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('937d8642-a6fa-5b42-a69c-c55191e88541', '1cb82e92-904b-52e2-b0a3-96ea653f2b71', 'Who was the first human being to walk on the Moon, in 1969?', '[{"id":"a","text":"Neil Armstrong"},{"id":"b","text":"Yuri Gagarin"},{"id":"c","text":"Buzz Aldrin"},{"id":"d","text":"Michael Collins"}]'::jsonb, 'a', 'On 21 July 1969 (French time), Neil Armstrong, commander of Apollo 11, became the first person to set foot on the Moon. Buzz Aldrin (c) joined him a few minutes later; Michael Collins (d) remained in orbit in the command module. Yuri Gagarin (b) was the first man in space in 1961, but he never went to the Moon.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f948385f-a439-5d93-b58a-52a8d9eb8ae3', 'fcb54b51-38cc-5c1a-890b-f4eddd42ff70', 'culture-generale-histoire-en', '⭐ Quiz: History', 1, 50, 10, 'practice', 'admin', 1)
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
  ('1fdcce0f-9f04-59cb-918d-2f843325e416', 'f948385f-a439-5d93-b58a-52a8d9eb8ae3', 'In what year did the storming of the Bastille take place?', '[{"id":"a","text":"1789"},{"id":"b","text":"1799"},{"id":"c","text":"1689"},{"id":"d","text":"1804"}]'::jsonb, 'a', 'The storming of the Bastille took place on 14 July 1789, the symbolic starting point of the French Revolution. Worth remembering: this day became the French national holiday. 1799 (b) is the year of Napoleon''s coup d''état, and 1804 (d) the year of his coronation as emperor.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a343bbfa-8d3e-54c2-85f3-d5b27987c0e8', 'f948385f-a439-5d93-b58a-52a8d9eb8ae3', 'Which navigator, sailing for Spain, reached America in 1492?', '[{"id":"a","text":"Vasco da Gama"},{"id":"b","text":"Ferdinand Magellan"},{"id":"c","text":"Christopher Columbus"},{"id":"d","text":"Marco Polo"}]'::jsonb, 'c', 'Christopher Columbus, in the service of Spain, reached America in 1492 while searching for a westward route to the Indies. Vasco da Gama (a) sailed around Africa to reach India in 1498; Magellan (b) launched the first voyage around the world in 1519; Marco Polo (d) was a 13th-century traveller to China.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c30a93c5-f3ca-57d7-a7ec-de7a6c38c5bf', 'f948385f-a439-5d93-b58a-52a8d9eb8ae3', 'Which country celebrates its independence day on 20 March 1956?', '[{"id":"a","text":"Egypt"},{"id":"b","text":"Tunisia"},{"id":"c","text":"Senegal"},{"id":"d","text":"Libya"}]'::jsonb, 'b', 'Tunisia gained its independence from France on 20 March 1956, the date of its national holiday. Habib Bourguiba was its leading figure. Libya (d) had been independent since 1951, Senegal (c) would become so in 1960, and Egypt (a) had a distinct status from the first half of the 20th century.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea2cffa7-27a5-5c2a-b69a-46d5db0c7d68', 'f948385f-a439-5d93-b58a-52a8d9eb8ae3', 'Which space mission put the first humans on the Moon in 1969?', '[{"id":"a","text":"Sputnik 1"},{"id":"b","text":"Vostok 1"},{"id":"c","text":"Apollo 11"},{"id":"d","text":"Apollo 13"}]'::jsonb, 'c', 'It was the American Apollo 11 mission that landed the first humans on the Moon in July 1969, with Neil Armstrong and Buzz Aldrin. Sputnik 1 (a) was the first satellite (1957) and Vostok 1 (b) the first crewed flight (Gagarin, 1961). Apollo 13 (d) is the 1970 mission that nearly turned to disaster.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d07b6dca-4ecf-5ad0-9847-46e28fb4064a', 'f948385f-a439-5d93-b58a-52a8d9eb8ae3', 'The fall of the Berlin Wall in 1989 marks the end of which period of tensions?', '[{"id":"a","text":"The Cold War"},{"id":"b","text":"The First World War"},{"id":"c","text":"The Hundred Years'' War"},{"id":"d","text":"The Napoleonic Wars"}]'::jsonb, 'a', 'The fall of the Berlin Wall (1989) symbolizes the end of the Cold War, the ideological confrontation between the Western bloc and the Soviet bloc after 1945. The First World War (b) ended in 1918, the Hundred Years'' War (c) in the 15th century, and the Napoleonic Wars (d) in 1815.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d28ed78d-ed46-5747-83fa-4f35806130e9', 'f948385f-a439-5d93-b58a-52a8d9eb8ae3', 'In what year did the Second World War end?', '[{"id":"a","text":"1918"},{"id":"b","text":"1939"},{"id":"c","text":"1950"},{"id":"d","text":"1945"}]'::jsonb, 'd', 'The Second World War ended in 1945: German surrender on 8 May, then Japanese surrender on 2 September. Worth remembering: the UN was created the same year to safeguard peace. 1918 (a) is the end of the First World War, and 1939 (b) the start of the Second.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8c67294b-517d-5c15-8754-01f591e8f208', 'fcb54b51-38cc-5c1a-890b-f4eddd42ff70', 'culture-generale-histoire-en', '⚔️ Boss ⭐⭐⭐: History', 3, 120, 30, 'boss', 'admin', 2)
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
  ('53346222-b549-5038-8f7a-c4cbe0ad3886', '8c67294b-517d-5c15-8754-01f591e8f208', 'Which date conventionally marks the beginning of the First World War?', '[{"id":"a","text":"1914"},{"id":"b","text":"1918"},{"id":"c","text":"1939"},{"id":"d","text":"1871"}]'::jsonb, 'a', 'The First World War began in 1914 and ended in 1918. It was triggered after the assassination of Archduke Franz Ferdinand in Sarajevo. 1918 (b) is its end, 1939 (c) the start of the Second World War, and 1871 (d) the year of German unification.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be43cb6a-399c-53d4-bace-88e4a8e6011c', '8c67294b-517d-5c15-8754-01f591e8f208', 'Which Neo-Destour leader negotiated Tunisia''s independence and became its first president?', '[{"id":"a","text":"Gamal Abdel Nasser"},{"id":"b","text":"Tahar Ben Ammar"},{"id":"c","text":"Farhat Hached"},{"id":"d","text":"Habib Bourguiba"}]'::jsonb, 'd', 'Habib Bourguiba, founder of the Neo-Destour, led the fight for independence won on 20 March 1956 and became the first president of the Tunisian Republic in 1957. Tahar Ben Ammar (b) was the head of government who signed the accord, but not the leader of the movement. Farhat Hached (c) was a trade unionist assassinated in 1952. Nasser (a) led Egypt.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('239442db-cc0a-5b2c-bfb6-fa2d32143e38', '8c67294b-517d-5c15-8754-01f591e8f208', 'Which Germanic chieftain deposed the last Western Roman emperor in 476?', '[{"id":"a","text":"Attila"},{"id":"b","text":"Clovis"},{"id":"c","text":"Odoacer"},{"id":"d","text":"Charlemagne"}]'::jsonb, 'c', 'In 476, the Germanic chieftain Odoacer deposed Romulus Augustulus, marking the end of the Western Roman Empire and of Antiquity. Attila (a), king of the Huns, had died back in 453. Clovis (b), king of the Franks, and Charlemagne (d), crowned emperor in the year 800, are later figures of the Middle Ages.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d61f1f78-74a6-5766-b674-3127d912be0d', '8c67294b-517d-5c15-8754-01f591e8f208', 'Where was the armistice of 11 November 1918 signed, ending the fighting of the First World War?', '[{"id":"a","text":"In the Hall of Mirrors at Versailles"},{"id":"b","text":"In a railway carriage at Rethondes (Compiègne forest)"},{"id":"c","text":"At the palace of Yalta"},{"id":"d","text":"In a school in Reims"}]'::jsonb, 'b', 'The armistice of 11 November 1918 was signed in a dining car, in the clearing of Rethondes (Compiègne forest). The Treaty of Versailles (a), by contrast, would be signed in 1919. Yalta (c) is the 1945 conference between the Allies, and Reims (d) is where the first German surrender of 1945 was signed — a common chronological trap.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d899cf4-ffc8-548e-a60f-717ca4142e3c', '8c67294b-517d-5c15-8754-01f591e8f208', 'Which fundamental text, adopted on 26 August 1789, proclaims that "men are born and remain free and equal in rights"?', '[{"id":"a","text":"The Civil Code"},{"id":"b","text":"The Declaration of the Rights of Man and of the Citizen"},{"id":"c","text":"The Charter of the United Nations"},{"id":"d","text":"The Edict of Nantes"}]'::jsonb, 'b', 'The Declaration of the Rights of Man and of the Citizen, adopted on 26 August 1789, sets out this founding principle; it remains a reference text for human rights. The Civil Code (a) dates from 1804 (Napoleon), the Charter of the United Nations (c) from 1945, and the Edict of Nantes (d) from 1598 (religious tolerance) — texts from entirely different eras.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16960795-b4ab-544e-b743-dc80a5a7dd92', '8c67294b-517d-5c15-8754-01f591e8f208', 'The Second World War ended on different dates in Europe and in Asia. Which pairing is correct?', '[{"id":"a","text":"Europe: 2 September 1945; Japan: 8 May 1945"},{"id":"b","text":"Europe: 8 May 1945; Japan: 2 September 1945"},{"id":"c","text":"Europe: 11 November 1945; Japan: 8 May 1945"},{"id":"d","text":"Europe: 8 May 1939; Japan: 2 September 1939"}]'::jsonb, 'b', 'The German surrender was signed on 8 May 1945 (end of the war in Europe), while the Japanese surrender, after Hiroshima and Nagasaki, came on 2 September 1945 (worldwide end of the conflict). The common trap (a) is to swap the two dates. 11 November (c) refers to 1918, and 1939 (d) is the year the war broke out, not when it ended.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ceb989dc-3e31-526c-8c4e-068f645a4e86', 'fcb54b51-38cc-5c1a-890b-f4eddd42ff70', 'culture-generale-histoire-en', '⭐⭐ Revision: History', 2, 70, 15, 'practice', 'admin', 3)
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
  ('96da4dab-83e4-5183-8de5-dcb06470d802', 'ceb989dc-3e31-526c-8c4e-068f645a4e86', 'The fall of the Western Roman Empire in 476 traditionally marks the end of which historical period?', '[{"id":"a","text":"Prehistory"},{"id":"b","text":"Antiquity"},{"id":"c","text":"The Early Modern period"},{"id":"d","text":"The Renaissance"}]'::jsonb, 'b', 'The fall of Rome in 476 marks the end of Antiquity and the beginning of the Middle Ages. Worth remembering: historians traditionally divide history into Prehistory, Antiquity, the Middle Ages, the Early Modern period and then the contemporary era. The Renaissance (d) and the Early Modern period (c) do not begin until the 15th-16th century.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36ad78c8-aaca-5bba-a47d-d8a909d593a3', 'ceb989dc-3e31-526c-8c4e-068f645a4e86', 'Which event of 1492 is often taken as the start of the Early Modern period?', '[{"id":"a","text":"The storming of the Bastille"},{"id":"b","text":"The fall of Constantinople"},{"id":"c","text":"Christopher Columbus''s arrival in America"},{"id":"d","text":"The coronation of Charlemagne"}]'::jsonb, 'c', 'Columbus''s arrival in America in 1492 opens the age of the Great Discoveries and is often used as a marker for the start of the Early Modern period. The fall of Constantinople (b) dates from 1453 (another possible marker), the storming of the Bastille (a) from 1789, and the coronation of Charlemagne (d) from the year 800.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98243e2b-ee81-566f-9569-252f8e2c5a12', 'ceb989dc-3e31-526c-8c4e-068f645a4e86', 'Which treaty of 1881 had established the French protectorate over Tunisia, abolished at independence in 1956?', '[{"id":"a","text":"The Treaty of Versailles"},{"id":"b","text":"The Treaty of Bardo"},{"id":"c","text":"The Treaty of Tordesillas"},{"id":"d","text":"The Treaty of Rome"}]'::jsonb, 'b', 'The Treaty of Bardo, signed in 1881, had established the French protectorate over Tunisia; it was abrogated at independence on 20 March 1956. The Treaty of Versailles (a) closed the First World War (1919), Tordesillas (c) divided the New World between Spain and Portugal (1494), and the Treaty of Rome (d) founded the EEC (1957).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('69c5d77b-4b50-5fce-88c9-77e0076ba139', 'ceb989dc-3e31-526c-8c4e-068f645a4e86', 'Which famous sentence did Neil Armstrong utter as he set foot on the Moon?', '[{"id":"a","text":"\"Houston, we have a problem.\""},{"id":"b","text":"\"That''s one small step for man, one giant leap for mankind.\""},{"id":"c","text":"\"The Earth is blue.\""},{"id":"d","text":"\"Veni, vidi, vici.\""}]'::jsonb, 'b', 'In 1969, Armstrong said "That''s one small step for man, one giant leap for mankind." The sentence (a) is associated with the Apollo 13 mission (1970); "The Earth is blue" (c) is attributed to Gagarin in 1961; "Veni, vidi, vici" (d) is a phrase of Julius Caesar, unrelated to space.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3699eeb7-a859-5082-b03e-37e8c08386b5', 'ceb989dc-3e31-526c-8c4e-068f645a4e86', 'The Berlin Wall separated two political entities. Which ones?', '[{"id":"a","text":"Germany and France"},{"id":"b","text":"Poland and Germany"},{"id":"c","text":"East Germany and West Germany"},{"id":"d","text":"The USSR and the United States"}]'::jsonb, 'c', 'Built in 1961, the Berlin Wall separated communist East Germany (GDR) from West Germany (FRG), at the heart of the Cold War. Its fall in 1989 would pave the way for German reunification in 1990. It did not mark a border between distinct countries such as France (a) or Poland (b).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01ce4b70-78f3-568e-9717-686b7a8d9709', 'ceb989dc-3e31-526c-8c4e-068f645a4e86', 'Which international organization was founded in 1945 to safeguard peace after the Second World War?', '[{"id":"a","text":"The United Nations (UN)"},{"id":"b","text":"The League of Nations"},{"id":"c","text":"The European Union"},{"id":"d","text":"NATO"}]'::jsonb, 'a', 'The UN was created in 1945, in the aftermath of the Second World War, to maintain international peace and security. The League of Nations (b) had preceded it after 1918 but failed to prevent the war. NATO (d) is a military alliance founded in 1949, and the European Union (c) in its current form dates from 1992.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2f581c54-d8ed-5c45-91b7-26dbb9dc3379', 'fcb54b51-38cc-5c1a-890b-f4eddd42ff70', 'culture-generale-histoire-en', '👑 Elite challenge ⭐⭐⭐⭐: History', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('d656c6d5-3eb1-5a3d-b01e-9e16c26d1615', '2f581c54-d8ed-5c45-91b7-26dbb9dc3379', 'In what year did the capture of Constantinople by the Ottomans end the Byzantine (Eastern Roman) Empire?', '[{"id":"a","text":"476"},{"id":"b","text":"1453"},{"id":"c","text":"1492"},{"id":"d","text":"1204"}]'::jsonb, 'b', 'Constantinople fell on 29 May 1453 to Sultan Mehmed II, ending the Byzantine Empire, heir to Rome in the East for nearly a thousand years. The common trap is to confuse it with 476 (a), which concerns the Western Empire. 1204 (d) is the sack of the city by the Crusaders (a temporary occupation), and 1492 (c) is Columbus''s arrival in America.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d98a3bd-f650-5bb9-989c-d32f061fe39a', '2f581c54-d8ed-5c45-91b7-26dbb9dc3379', 'Which Tunisian trade unionist, founder of the UGTT and a figure of the independence struggle, was assassinated on 5 December 1952?', '[{"id":"a","text":"Tahar Ben Ammar"},{"id":"b","text":"Salah Ben Youssef"},{"id":"c","text":"Farhat Hached"},{"id":"d","text":"Mongi Slim"}]'::jsonb, 'c', 'Farhat Hached, founder of the UGTT in 1946 and a comrade-in-arms of the Neo-Destour, was assassinated on 5 December 1952, becoming a martyr of independence. Salah Ben Youssef (b) was a rival of Bourguiba; Tahar Ben Ammar (a) signed the independence accord as head of government; Mongi Slim (d) was a Destourian diplomat.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b0e1b01-5d34-513a-8cc2-54b741bbcc18', '2f581c54-d8ed-5c45-91b7-26dbb9dc3379', 'The 14th of July 1789 was chosen as the French national holiday. But in what year was this decision officially made?', '[{"id":"a","text":"1789"},{"id":"b","text":"1804"},{"id":"c","text":"1880"},{"id":"d","text":"1918"}]'::jsonb, 'c', 'It was in 1880, under the Third Republic, that the 14th of July was instituted as the French national holiday, in reference to the storming of the Bastille of 1789. The trap is to answer 1789 (a), the year of the event itself, rather than that of its institution as a holiday. 1804 (b) is Napoleon''s coronation and 1918 (d) the end of the First World War.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('013b824a-e5cf-5a09-afdb-e08f44c00054', '2f581c54-d8ed-5c45-91b7-26dbb9dc3379', 'The first German surrender of the Second World War, on 7 May 1945, was followed by a second signing at Stalin''s request. In which city did this first signing take place?', '[{"id":"a","text":"Berlin"},{"id":"b","text":"Reims"},{"id":"c","text":"Yalta"},{"id":"d","text":"Potsdam"}]'::jsonb, 'b', 'The German surrender was first signed at Reims on 7 May 1945, at Eisenhower''s headquarters; Stalin demanded a second signing in Berlin (Karlshorst) during the night of 8 to 9 May, hence the celebration of 8 May. Yalta (c) and Potsdam (d) are inter-Allied conferences of 1945, not surrender venues.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb4cff1f-36d8-56ed-a68e-7cb7bfb27b1d', '2f581c54-d8ed-5c45-91b7-26dbb9dc3379', 'Which Apollo 11 astronaut did NOT walk on the Moon, having remained in orbit in the command module?', '[{"id":"a","text":"Neil Armstrong"},{"id":"b","text":"Yuri Gagarin"},{"id":"c","text":"Buzz Aldrin"},{"id":"d","text":"Michael Collins"}]'::jsonb, 'd', 'Michael Collins stayed alone in lunar orbit aboard the command module Columbia while Armstrong and Aldrin descended to the Moon in 1969. The trap is to name Gagarin (b), who never took part in Apollo 11: he was the first man in space (USSR, 1961). Armstrong (a) and Aldrin (c) did indeed walk on the lunar surface.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c9f3f61-bd7d-5909-8721-9810bf19038f', '2f581c54-d8ed-5c45-91b7-26dbb9dc3379', 'Order these four events from oldest to most recent: fall of Rome, fall of Constantinople, storming of the Bastille, fall of the Berlin Wall.', '[{"id":"a","text":"Fall of Rome, fall of Constantinople, storming of the Bastille, fall of the Berlin Wall"},{"id":"b","text":"Fall of Constantinople, fall of Rome, storming of the Bastille, fall of the Berlin Wall"},{"id":"c","text":"Fall of Rome, storming of the Bastille, fall of Constantinople, fall of the Berlin Wall"},{"id":"d","text":"Storming of the Bastille, fall of Rome, fall of Constantinople, fall of the Berlin Wall"}]'::jsonb, 'a', 'The chronological order is: fall of Rome (476), fall of Constantinople (1453), storming of the Bastille (1789), fall of the Berlin Wall (1989). The common trap is to swap the two imperial falls (b): the Western Roman Empire fell almost a thousand years before Constantinople. Options (c) and (d) move the Bastille out of its chronological place.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

