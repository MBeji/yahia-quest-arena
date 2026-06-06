-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-dungeon-en (Culture générale — Donjon multi-thèmes (EN))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-dungeon-en/
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
  ('culture-generale-dungeon-en', 'Culture générale — Donjon multi-thèmes (EN)', 'General-knowledge dungeon where every question comes from a different domain (history, geography, politics, economics, sciences, arts): a gauntlet of varied knowledge in English.', 'Polyvalence', 'subject-math', 'Swords', 23, 'en', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-dungeon-en'
      AND e.source = 'admin'
      AND q.id NOT IN ('b3038d75-2f66-5cac-8ebb-58c768018d6f', '253ccb85-a3b3-51fb-988e-2606599255b5', '1a750bf6-be78-56b4-a3bc-076320ea501e', '824c04f6-915f-555b-b8de-64b16d5e13ee', '53d261bd-3833-5b95-8b0f-255672f063c6', 'f20a9619-488f-5aa6-8961-3d3922e59228', '694b8036-61e0-52c3-81cb-3834f4989235', '68633c36-d24c-594e-8695-60ed8756b2ca', 'cce4ea15-fdea-53b0-8e4e-5906915d4f3d', '8d080513-7f3a-5059-a567-550bba69984e', '68266b99-8d79-50ad-b79f-ee2ebd57e5ea', 'b214e8b2-d19b-5948-8471-ea500262b9b0', 'ce056bf8-31ad-5d37-8e52-3f5d64485c44', 'bbbd7569-b8d5-5bd2-bae6-7f3335f288b4', '84c23b2d-507a-502d-930b-b7c73688f2b1', '9db1c3a7-61d9-5261-8d67-a93179254751', '27f55a13-3aaf-522d-86fa-8d3eb4c03ed3');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-dungeon-en' AND source = 'admin' AND id NOT IN ('80690ff4-a49e-5cf7-9999-d69c93406c70', 'e98e2323-8c88-50a2-88a9-591a35704783', '9eda11d9-ac3e-5716-9e51-2433009752be');
DELETE FROM public.questions WHERE exercise_id IN ('80690ff4-a49e-5cf7-9999-d69c93406c70', 'e98e2323-8c88-50a2-88a9-591a35704783', '9eda11d9-ac3e-5716-9e51-2433009752be') AND id NOT IN ('b3038d75-2f66-5cac-8ebb-58c768018d6f', '253ccb85-a3b3-51fb-988e-2606599255b5', '1a750bf6-be78-56b4-a3bc-076320ea501e', '824c04f6-915f-555b-b8de-64b16d5e13ee', '53d261bd-3833-5b95-8b0f-255672f063c6', 'f20a9619-488f-5aa6-8961-3d3922e59228', '694b8036-61e0-52c3-81cb-3834f4989235', '68633c36-d24c-594e-8695-60ed8756b2ca', 'cce4ea15-fdea-53b0-8e4e-5906915d4f3d', '8d080513-7f3a-5059-a567-550bba69984e', '68266b99-8d79-50ad-b79f-ee2ebd57e5ea', 'b214e8b2-d19b-5948-8471-ea500262b9b0', 'ce056bf8-31ad-5d37-8e52-3f5d64485c44', 'bbbd7569-b8d5-5bd2-bae6-7f3335f288b4', '84c23b2d-507a-502d-930b-b7c73688f2b1', '9db1c3a7-61d9-5261-8d67-a93179254751', '27f55a13-3aaf-522d-86fa-8d3eb4c03ed3');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-dungeon-en' AND c.id NOT IN ('5338e44a-d0c7-5ccb-866a-8a9caf46e688') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('5338e44a-d0c7-5ccb-866a-8a9caf46e688', 'culture-generale-dungeon-en', 'Multi-theme dungeon', 'A general-knowledge gauntlet: every question springs from a different domain — history, geography, politics, economics, sciences, arts. Warm up, face the Boss, then dare the Elite.', '# ⚔️ The Multi-Theme Dungeon — a gauntlet of general knowledge

> 💡 "The most dangerous hero is not the one who hits hardest, but the one who knows a little about everything."

Welcome, adventurer. There is no quiet chapter on a single subject here: this dungeon is a **gauntlet of varied knowledge**. In every room a different door swings open — **history**, **geography**, **politics**, **economics**, **sciences** or **arts** — and you never know which one. Your only weapon: broad, solid general knowledge.

## 🏰 The rule of the dungeon

Each battle chains together questions from **different domains**. You can jump from the date of a revolution to a capital city, from a chemical symbol to a famous painting, with no warning. That is exactly what gives real general knowledge its value: being **versatile**, ready for anything.

## ⚡ The six doors (the domains)

| Door | Domain | Sample challenge |
|---|---|---|
| 🛡️ | History | dates, events, figures |
| 🗺️ | Geography | capitals, rivers, peaks |
| 🏛️ | Politics | institutions, organizations, regimes |
| 💰 | Economics | GDP, inflation, major agreements |
| 🔬 | Sciences | physics, chemistry, astronomy |
| 🎨 | Arts | painting, music, literature |

## 🔮 The adventurer''s journey

1. **Warm-up** ⭐ — a quiz of 5 easy questions to open the dungeon (you need **≥ 80 %** to unlock what follows).
2. **Boss** ⭐⭐⭐ — 6 questions, **one per domain**, rising difficulty (1 → 3).
3. **Elite** ⭐⭐⭐⭐ — 6 tough, shuffled questions, for true masters.

> 🗡️ **Hero''s tip**: faced with a trap, first eliminate the absurd options, then hunt down the **false friend** — the neighboring country, the year off by one notch, the almost-right number.

> ⚠️ **Classic trap**: confusing a famous large city with a capital (Sydney is *not* the capital of Australia). Fame is not authority.

## 🧪 Why train here

Every correction is a **mini-lesson**: you always leave with the right answer, the *why*, and one or two bonus facts to grow. Even a mistake leaves you more cultured than before you entered the room.

## 📜 The mindset

- Stay **calm**: an unfamiliar domain can often be reasoned out by logic.
- Stay **curious**: note what you miss — it is your loot for the next run.
- Stay **fast but sure**: the dungeon rewards precision, not haste.

> 🏆 You now know the rules of the dungeon. Clear the warm-up, slay the Boss, then dare the Elite challenge — and prove your general knowledge has no weak spot.', '# 📜 Summary: Multi-theme dungeon

- **Goal**: a general-knowledge gauntlet where every question comes from a different domain.
- **Six domains**: history, geography, politics, economics, sciences, arts.
- **Journey**: Warm-up (quiz ⭐, ≥ 80 % to unlock) → Boss ⭐⭐⭐ (one question per domain) → Elite ⭐⭐⭐⭐ (6 tough, shuffled questions).
- **Method**: eliminate the absurd options, then spot the false friend (neighboring country, year off by one, almost-right number).
- **Common trap**: confusing a famous city with a capital (e.g. Sydney ≠ capital of Australia).
- **Spirit**: calm, curious, precise — every correction is a mini-lesson that makes you more cultured.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('80690ff4-a49e-5cf7-9999-d69c93406c70', '5338e44a-d0c7-5ccb-866a-8a9caf46e688', 'culture-generale-dungeon-en', 'Dungeon warm-up ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('b3038d75-2f66-5cac-8ebb-58c768018d6f', '80690ff4-a49e-5cf7-9999-d69c93406c70', 'In which year did the Storming of the Bastille take place, the founding event of the French Revolution?', '[{"id":"a","text":"1789"},{"id":"b","text":"1799"},{"id":"c","text":"1769"},{"id":"d","text":"1815"}]'::jsonb, 'a', 'The Storming of the Bastille happened on 14 July 1789, marking the symbolic start of the French Revolution. Worth knowing: 14 July only became France''s national holiday in 1880. The year 1799 is when Bonaparte staged his coup (the end of the Revolution), not its beginning.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('253ccb85-a3b3-51fb-988e-2606599255b5', '80690ff4-a49e-5cf7-9999-d69c93406c70', 'What is the chemical symbol for gold in the periodic table?', '[{"id":"a","text":"Ag"},{"id":"b","text":"Au"},{"id":"c","text":"Go"},{"id":"d","text":"Gd"}]'::jsonb, 'b', 'The symbol for gold is Au, from the first two letters of its Latin name "aurum"; its atomic number is 79. The trap "Ag" is the symbol for silver (from the Latin "argentum"): gold and silver belong to the same group 11.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a750bf6-be78-56b4-a3bc-076320ea501e', '80690ff4-a49e-5cf7-9999-d69c93406c70', 'What is the capital of Australia?', '[{"id":"a","text":"Sydney"},{"id":"b","text":"Melbourne"},{"id":"c","text":"Canberra"},{"id":"d","text":"Perth"}]'::jsonb, 'c', 'The capital of Australia is Canberra, chosen in 1908 as a compromise between rivals Sydney and Melbourne and built from scratch. Sydney and Melbourne are the largest cities, but neither is the capital: a city''s fame does not make it the seat of government.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('824c04f6-915f-555b-b8de-64b16d5e13ee', '80690ff4-a49e-5cf7-9999-d69c93406c70', 'Who painted the Mona Lisa, displayed at the Louvre Museum?', '[{"id":"a","text":"Michelangelo"},{"id":"b","text":"Raphael"},{"id":"c","text":"Leonardo da Vinci"},{"id":"d","text":"Botticelli"}]'::jsonb, 'c', 'The Mona Lisa was painted by Leonardo da Vinci in the early 16th century, using the famous sfumato technique (softened, blurred outlines). Michelangelo, his contemporary and rival, was mainly a sculptor and fresco painter (the Sistine Chapel ceiling): he did not paint this portrait.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53d261bd-3833-5b95-8b0f-255672f063c6', '80690ff4-a49e-5cf7-9999-d69c93406c70', 'What does a country''s GDP (gross domestic product) measure?', '[{"id":"a","text":"The wealth produced within the territory over a given period"},{"id":"b","text":"The total number of inhabitants of the country"},{"id":"c","text":"The amount of money held by the state"},{"id":"d","text":"The total area of the country"}]'::jsonb, 'a', 'GDP measures the value of all goods and services produced within a territory over a period (often a year); its change indicates economic growth. It counts neither the population nor the territory: a large, unproductive country can have a lower GDP than a small, highly productive one.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e98e2323-8c88-50a2-88a9-591a35704783', '5338e44a-d0c7-5ccb-866a-8a9caf46e688', 'culture-generale-dungeon-en', '⚔️ Dungeon — Boss ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 1)
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
  ('f20a9619-488f-5aa6-8961-3d3922e59228', 'e98e2323-8c88-50a2-88a9-591a35704783', 'History — In which year did the Berlin Wall fall, marking the end of Germany''s division?', '[{"id":"a","text":"1989"},{"id":"b","text":"1991"},{"id":"c","text":"1985"},{"id":"d","text":"1961"}]'::jsonb, 'a', 'The Berlin Wall fell on the night of 9 November 1989, after 28 years of separation. Worth knowing: it had been built in 1961 (the trap "1961" is its construction, not its fall). 1991 is the year the USSR was dissolved, a distinct and later event.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('694b8036-61e0-52c3-81cb-3834f4989235', 'e98e2323-8c88-50a2-88a9-591a35704783', 'Geography — On which continent is the Sahara, the largest hot desert in the world, located?', '[{"id":"a","text":"Asia"},{"id":"b","text":"Africa"},{"id":"c","text":"South America"},{"id":"d","text":"Oceania"}]'::jsonb, 'b', 'The Sahara covers a wide band of northern Africa, across about a dozen countries. It is the largest hot desert in the world (around 9 million km²). The trap "Asia" points to the Gobi Desert: vast as well, but it is a cold desert, distinct from the Sahara.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68633c36-d24c-594e-8695-60ed8756b2ca', 'e98e2323-8c88-50a2-88a9-591a35704783', 'Politics — Which UN body holds the primary responsibility for maintaining international peace and security?', '[{"id":"a","text":"The General Assembly"},{"id":"b","text":"The International Court of Justice"},{"id":"c","text":"The Security Council"},{"id":"d","text":"The Secretariat"}]'::jsonb, 'c', 'The Security Council is responsible for maintaining peace; its five permanent members (United States, Russia, China, France, United Kingdom) hold veto power. The General Assembly gathers all 193 member states but its resolutions are not binding: it debates, while the Council decides and can impose sanctions.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cce4ea15-fdea-53b0-8e4e-5906915d4f3d', 'e98e2323-8c88-50a2-88a9-591a35704783', 'Economics — What does the term "inflation" mean in economics?', '[{"id":"a","text":"A general and sustained rise in prices"},{"id":"b","text":"A general fall in prices"},{"id":"c","text":"A rise in unemployment"},{"id":"d","text":"An increase in exports"}]'::jsonb, 'a', 'Inflation is the general, sustained rise in prices, which reduces the purchasing power of money. The European Central Bank aims for around 2 % per year. The trap "fall in prices" has its own name: deflation, the opposite phenomenon, often judged dangerous because it can paralyze economic activity.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d080513-7f3a-5059-a567-550bba69984e', 'e98e2323-8c88-50a2-88a9-591a35704783', 'Sciences — What is, in order of magnitude, the speed of light in a vacuum?', '[{"id":"a","text":"About 300,000 km/s"},{"id":"b","text":"About 300,000 km/h"},{"id":"c","text":"About 3,000 km/s"},{"id":"d","text":"About 30,000,000 km/s"}]'::jsonb, 'a', 'Light travels at 299,792,458 m/s in a vacuum, that is about 300,000 km/s — a fundamental constant that has even been used to define the metre since 1983. The trap "km/h" uses the wrong unit: 300,000 km/h would be hundreds of thousands of times too slow.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68266b99-8d79-50ad-b79f-ee2ebd57e5ea', 'e98e2323-8c88-50a2-88a9-591a35704783', 'Arts — Which country was Wolfgang Amadeus Mozart, composer of "The Magic Flute", from?', '[{"id":"a","text":"Germany"},{"id":"b","text":"Italy"},{"id":"c","text":"Austria"},{"id":"d","text":"France"}]'::jsonb, 'c', 'Mozart was born in Salzburg in 1756, then part of the Holy Roman Empire but a city that is Austrian today; he is one of the great figures of Viennese classical music. The trap "Germany" comes from the German language he spoke: but Salzburg and Vienna, where he built his career, are in Austria, not Germany.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9eda11d9-ac3e-5716-9e51-2433009752be', '5338e44a-d0c7-5ccb-866a-8a9caf46e688', 'culture-generale-dungeon-en', '👑 Dungeon — Elite ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 2)
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
  ('b214e8b2-d19b-5948-8471-ea500262b9b0', '9eda11d9-ac3e-5716-9e51-2433009752be', 'History — In 1215, the English barons forced King John to accept a document limiting his power, regarded as a major step toward the rule of law. What is this document?', '[{"id":"a","text":"The Magna Carta (Great Charter)"},{"id":"b","text":"The Declaration of the Rights of Man"},{"id":"c","text":"The English Bill of Rights"},{"id":"d","text":"The Habeas Corpus Act"}]'::jsonb, 'a', 'The Magna Carta, signed in 1215 at Runnymede, subjects the king to the law and guarantees free men a lawful judgment; it foreshadows constitutional liberties. The traps are later: the Habeas Corpus Act dates from 1679 and the English Bill of Rights from 1689, both several centuries afterward.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce056bf8-31ad-5d37-8e52-3f5d64485c44', '9eda11d9-ac3e-5716-9e51-2433009752be', 'Geography — What is the approximate elevation of Mount Everest, the highest point on Earth above sea level?', '[{"id":"a","text":"About 6,500 m"},{"id":"b","text":"About 7,200 m"},{"id":"c","text":"About 8,849 m"},{"id":"d","text":"About 9,600 m"}]'::jsonb, 'c', 'Everest, in the Himalayas, rises to about 8,849 m above sea level (the 2020 China-Nepal measurement). Worth knowing: measured from its underwater base, Hawaii''s Mauna Kea would be "taller", but the official criterion remains elevation above sea level, which crowns Everest.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bbbd7569-b8d5-5bd2-bae6-7f3335f288b4', '9eda11d9-ac3e-5716-9e51-2433009752be', 'Economics — The Bretton Woods Agreements, signed in 1944, gave birth to two major international economic institutions. Which ones?', '[{"id":"a","text":"The WTO and the OECD"},{"id":"b","text":"The IMF and the World Bank"},{"id":"c","text":"The ECB and the Federal Reserve"},{"id":"d","text":"OPEC and the G7"}]'::jsonb, 'b', 'Bretton Woods (1944) created the International Monetary Fund (IMF) and the World Bank, to stabilize currencies and finance postwar reconstruction. The trap "WTO" is more recent (1995, born from the GATT) and deals not with currency but with trade: a different role, a different era.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84c23b2d-507a-502d-930b-b7c73688f2b1', '9eda11d9-ac3e-5716-9e51-2433009752be', 'Sciences — Which is the closest planet to the Sun in the solar system?', '[{"id":"a","text":"Venus"},{"id":"b","text":"Mars"},{"id":"c","text":"Mercury"},{"id":"d","text":"Earth"}]'::jsonb, 'c', 'Mercury is the closest planet to the Sun and the smallest in the solar system. A curiosity: it is not the hottest — that is Venus, whose thick CO₂ atmosphere traps heat (the greenhouse effect). The trap "Venus" confuses the second planet (the hottest) with the first (the closest).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9db1c3a7-61d9-5261-8d67-a93179254751', '9eda11d9-ac3e-5716-9e51-2433009752be', 'Arts — The painting "Guernica", a powerful anti-war work inspired by a 1937 bombing, is the work of which painter?', '[{"id":"a","text":"Salvador Dalí"},{"id":"b","text":"Pablo Picasso"},{"id":"c","text":"Joan Miró"},{"id":"d","text":"Francisco Goya"}]'::jsonb, 'b', '"Guernica" was painted by Pablo Picasso in 1937, in reaction to the bombing of the Basque town of Guernica during the Spanish Civil War; it is a gray-and-black icon of anti-war art, displayed in Madrid. The trap "Goya" is plausible (another Spaniard famous for war scenes) but he lived around the turn of the 19th century.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27f55a13-3aaf-522d-86fa-8d3eb4c03ed3', '9eda11d9-ac3e-5716-9e51-2433009752be', 'Politics — In which year was the United Nations (UN) officially founded?', '[{"id":"a","text":"1919"},{"id":"b","text":"1948"},{"id":"c","text":"1945"},{"id":"d","text":"1950"}]'::jsonb, 'c', 'The UN was founded on 24 October 1945, after its Charter was ratified by the 51 founding states; it now has 193 members and is headquartered in New York. The trap "1919" is the League of Nations, the organization that preceded the UN and that it replaced after the League failed to prevent the Second World War.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

