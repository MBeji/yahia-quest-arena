-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-politique-en (Culture générale — Politique (EN))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-politique-en/
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
  ('culture-generale-politique-en', 'Culture générale — Politique (EN)', 'Understand political life: democracy, separation of powers, regimes and institutions, in English.', 'Stratégie', 'subject-arabic', 'Scale', 17, 'en', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-politique-en'
      AND e.source = 'admin'
      AND q.id NOT IN ('97bd4c8f-4bb7-501d-8e12-0c161a523c59', '840fca32-ccdc-526a-8da2-c339f29dba27', '2691e121-bdac-5251-8187-bf0b9b4285e0', 'a02ef10a-1ef0-5f9f-8628-341bc3299819', '9b2ba171-0c68-5f6b-8af9-f52beb41fc8f', '1cdfff14-8892-58c3-a2db-d0ed8ba15177', '55847fc9-ccce-5bf4-b8ae-3a93b1b465f0', 'd6903b7f-2859-5c2a-962e-9d638ab0e32c', '53be08c9-c20f-50db-8f37-099d00f1600b', '2a47e580-29a9-511b-968f-1582cc9abe3a', '0696b124-6e65-5557-9ade-3dd26a1ec49e', 'ed48840e-abd7-5c8d-bf01-568713fe676b', 'a09708df-9cf8-513a-8de3-f785bc4bc42c', 'aff9b6d4-7a7d-566c-9c54-d0b4d5cbebd8', '44736310-e7b1-5ba7-aa11-bf9ad3368b85', 'b6921b03-0b60-5784-acd9-e1f59badce3d', 'cd2177a2-8ab3-52ca-a42b-dd21eabb5368', 'cca650a8-5433-582e-9d45-b578435b4e95', '2521889e-8b6f-53ab-b51b-66e0b8e3e352', '9703385b-21d6-5b63-b4a4-837a3abb6b5a', 'cefcc590-d8b9-558b-b253-b92f3947ae29', '9071759c-1ae4-50d5-bcfb-d52f328d1a7d', '51a7f317-b934-5a30-b96e-c12b3ed70f41', '7a469564-fbfe-5236-a613-068b4d4ed5be', 'c961710f-3829-5d64-a5e9-93f9ff3de8a2', '08b53f34-a72d-5df4-935d-b09bb4359a47', '6b774381-163c-5fb6-bbf8-b8df2e954b0e', 'f0e3518a-d9c8-591c-ad07-251a54655c86', '770bea83-c428-5f8d-82b6-75ab489c1572');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-politique-en' AND source = 'admin' AND id NOT IN ('340dc3d7-8761-5f7d-b424-93fe5624428c', '63b1cacf-d380-550b-b816-9982f84ee159', '4e83a754-eade-58f5-9a8a-7b61fba7dfa3', '5a52706d-eb61-5430-80c1-75307ea90993', 'ef7d2ae2-19a0-5545-9977-1878de71fa5b');
DELETE FROM public.questions WHERE exercise_id IN ('340dc3d7-8761-5f7d-b424-93fe5624428c', '63b1cacf-d380-550b-b816-9982f84ee159', '4e83a754-eade-58f5-9a8a-7b61fba7dfa3', '5a52706d-eb61-5430-80c1-75307ea90993', 'ef7d2ae2-19a0-5545-9977-1878de71fa5b') AND id NOT IN ('97bd4c8f-4bb7-501d-8e12-0c161a523c59', '840fca32-ccdc-526a-8da2-c339f29dba27', '2691e121-bdac-5251-8187-bf0b9b4285e0', 'a02ef10a-1ef0-5f9f-8628-341bc3299819', '9b2ba171-0c68-5f6b-8af9-f52beb41fc8f', '1cdfff14-8892-58c3-a2db-d0ed8ba15177', '55847fc9-ccce-5bf4-b8ae-3a93b1b465f0', 'd6903b7f-2859-5c2a-962e-9d638ab0e32c', '53be08c9-c20f-50db-8f37-099d00f1600b', '2a47e580-29a9-511b-968f-1582cc9abe3a', '0696b124-6e65-5557-9ade-3dd26a1ec49e', 'ed48840e-abd7-5c8d-bf01-568713fe676b', 'a09708df-9cf8-513a-8de3-f785bc4bc42c', 'aff9b6d4-7a7d-566c-9c54-d0b4d5cbebd8', '44736310-e7b1-5ba7-aa11-bf9ad3368b85', 'b6921b03-0b60-5784-acd9-e1f59badce3d', 'cd2177a2-8ab3-52ca-a42b-dd21eabb5368', 'cca650a8-5433-582e-9d45-b578435b4e95', '2521889e-8b6f-53ab-b51b-66e0b8e3e352', '9703385b-21d6-5b63-b4a4-837a3abb6b5a', 'cefcc590-d8b9-558b-b253-b92f3947ae29', '9071759c-1ae4-50d5-bcfb-d52f328d1a7d', '51a7f317-b934-5a30-b96e-c12b3ed70f41', '7a469564-fbfe-5236-a613-068b4d4ed5be', 'c961710f-3829-5d64-a5e9-93f9ff3de8a2', '08b53f34-a72d-5df4-935d-b09bb4359a47', '6b774381-163c-5fb6-bbf8-b8df2e954b0e', 'f0e3518a-d9c8-591c-ad07-251a54655c86', '770bea83-c428-5f8d-82b6-75ab489c1572');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-politique-en' AND c.id NOT IN ('6b5b357a-4aa7-5531-a0b6-250fc61d5c15') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('6b5b357a-4aa7-5531-a0b6-250fc61d5c15', 'culture-generale-politique-en', 'Institutions and political regimes', 'The foundations of political life: democracy and its etymology, the separation of powers according to Montesquieu, the difference between parliamentary and presidential regimes, monarchy versus republic, and a few key landmarks (the French Fifth Republic, the UN, the right to vote).', '# ⚔️ Institutions and regimes — the great arena of power

> 💡 "So that power cannot be abused, it is necessary that, by the arrangement of things, power should check power." — Montesquieu

Welcome, strategist. Here, the weapon is not the sword but the **rules of the game**: who decides, who enforces, who judges. Master these invisible laws and you will read politics like a dungeon map. Advance level by level.

## 🏛️ The starting word: democracy

The word comes from the Greek **dêmos** ("the people") + **kratos** ("power"): literally, *the power of the people*. Born in **Athens** in the 5th century BC, democracy stands in contrast to two other families of regimes: **aristocracy** (the power of the few) and **monarchy** (the power of one).

In a democracy, the people are **sovereign**: they choose their leaders through the vote. This is the principle of **national sovereignty**, enshrined in Article 3 of the Declaration of the Rights of Man and of the Citizen of **1789**.

## ⚖️ The trinity of power: Montesquieu

In *The Spirit of the Laws* (**1748**), the philosopher **Montesquieu** developed the theory of the **separation of powers** to prevent tyranny. Three powers, three distinct guardians:

| Power | Role | Who exercises it (in general) |
|---|---|---|
| **Legislative** | Make the laws | Parliament (an elected assembly) |
| **Executive** | Enforce the laws | The head of state / the government |
| **Judicial** | Judge and interpret the laws | The courts, independent judges |

> 🗡️ Hero''s tip: think "**write / enforce / judge**". If a single person does all three, it is dictatorship.

## 🛡️ Parliamentary vs presidential

Two great architectures of modern democracy:

- **Parliamentary regime**: the government is **accountable to Parliament**, which can bring it down (a vote of no confidence). The head of state is often symbolic. Examples: the United Kingdom, Germany.
- **Presidential regime**: the president, elected by the people, is both head of state and head of government; they **cannot be removed** by Parliament. The textbook example is the **United States**.

**France** under the Fifth Republic blends the two: this is called a **semi-presidential** regime.

## 👑 Monarchy or republic?

The real dividing line lies in **how the head of state comes to power**:

- **Monarchy**: the head of state (king, queen) ascends to the throne by **heredity**. In a **constitutional monarchy** (the United Kingdom, Spain, Japan), their powers are limited by a constitution.
- **Republic**: the head of state is **elected** (directly or not) for a limited term.

> ⚠️ Classic trap: "monarchy" does not mean "absolute power". Most monarchies today are **constitutional** and perfectly democratic.

## 🇫🇷 Landmarks of the Fifth Republic

The French **Fifth Republic** is governed by the **Constitution of 4 October 1958**, championed by **Charles de Gaulle**, its first president. A few milestones to remember:

- **2000**: the presidential term was reduced from 7 to **5 years** (the *quinquennat*), by referendum, under Jacques Chirac.
- **1944**: an ordinance granting **women the right to vote**; their first vote came in **1945**.
- **2008**: the president can no longer serve more than **two consecutive terms**.

## 🌍 Beyond borders: the UN

At the global level, the **United Nations (UN)** was founded in **1945** (its charter signed in San Francisco) by **51 states** in the aftermath of the Second World War, to preserve peace. Its **headquarters** is in **New York**, and it now has **193 member states**.

> 🏆 First gate cleared, strategist! You can now name the three powers and tell the regimes apart. Next level: parties, elections and the great currents of ideas. On guard!', '# 📜 Summary: Institutions and political regimes

- **Democracy**: from the Greek *dêmos* (people) + *kratos* (power) → the power of the people; born in Athens in the 5th century BC.
- **National sovereignty**: the people are sovereign and choose their leaders through the vote (Article 3 of the 1789 Declaration of the Rights of Man and of the Citizen).
- **Separation of powers** (Montesquieu, *The Spirit of the Laws*, 1748): three distinct powers — **legislative** (make the laws), **executive** (enforce them), **judicial** (judge).
- **Parliamentary regime**: the government is accountable to Parliament, which can bring it down (United Kingdom, Germany).
- **Presidential regime**: the president, both head of state and head of government, cannot be removed by Parliament (United States); France is **semi-presidential**.
- **Monarchy vs republic**: a **hereditary** head of state (monarchy, often constitutional) or an **elected** one (republic).
- **Fifth Republic**: Constitution of 4 October 1958; five-year presidential term (quinquennat) since 2000; women''s right to vote in France by ordinance in 1944 (first vote in 1945).
- **UN**: founded in 1945 by 51 states, headquarters in New York, 193 members today; primary mission: to preserve peace.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('340dc3d7-8761-5f7d-b424-93fe5624428c', '6b5b357a-4aa7-5531-a0b6-250fc61d5c15', 'culture-generale-politique-en', 'Comprehension test ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('97bd4c8f-4bb7-501d-8e12-0c161a523c59', '340dc3d7-8761-5f7d-b424-93fe5624428c', 'What does the word "democracy" literally mean, according to its Greek origin?', '[{"id":"a","text":"The power of the people"},{"id":"b","text":"The power of one"},{"id":"c","text":"The power of the wealthiest"},{"id":"d","text":"The power of the military"}]'::jsonb, 'a', '"Democracy" comes from the Greek dêmos ("the people") and kratos ("power"): the power of the people. The regime was born in Athens in the 5th century BC. The "power of one" describes a monarchy instead, and the "power of the few" describes an aristocracy.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('840fca32-ccdc-526a-8da2-c339f29dba27', '340dc3d7-8761-5f7d-b424-93fe5624428c', 'Which philosopher developed the theory of the separation of powers in "The Spirit of the Laws" (1748)?', '[{"id":"a","text":"Voltaire"},{"id":"b","text":"Montesquieu"},{"id":"c","text":"Rousseau"},{"id":"d","text":"Descartes"}]'::jsonb, 'b', 'It was Montesquieu who, in "The Spirit of the Laws" (1748), distinguished the legislative, executive and judicial powers to prevent tyranny. Rousseau ("The Social Contract") mainly developed the idea of popular sovereignty, and Voltaire that of tolerance: neither of them theorized this separation.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2691e121-bdac-5251-8187-bf0b9b4285e0', '340dc3d7-8761-5f7d-b424-93fe5624428c', 'How many distinct powers does the separation of powers identify?', '[{"id":"a","text":"Two"},{"id":"b","text":"Four"},{"id":"c","text":"Three"},{"id":"d","text":"Five"}]'::jsonb, 'c', 'There are three powers: the legislative (make the laws), the executive (enforce them) and the judicial (judge). The press is sometimes called the "fourth estate", but that is a figure of speech: only the first three are public powers in the constitutional sense.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a02ef10a-1ef0-5f9f-8628-341bc3299819', '340dc3d7-8761-5f7d-b424-93fe5624428c', 'Which power has the main role of voting on and making the laws?', '[{"id":"a","text":"The executive power"},{"id":"b","text":"The judicial power"},{"id":"c","text":"The military power"},{"id":"d","text":"The legislative power"}]'::jsonb, 'd', 'The legislative power, exercised by Parliament (an elected assembly), votes on the laws. The executive (head of state, government) enforces them, and the judiciary (the courts) makes sure they are respected. Confusing the executive and the legislative is the most common mistake.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b2ba171-0c68-5f6b-8af9-f52beb41fc8f', '340dc3d7-8761-5f7d-b424-93fe5624428c', 'In a republic, how does the head of state come to power?', '[{"id":"a","text":"By heredity, from father to son"},{"id":"b","text":"Through an election"},{"id":"c","text":"By a lottery for life"},{"id":"d","text":"Through a systematic coup d''état"}]'::jsonb, 'b', 'In a republic, the head of state is elected (directly or indirectly) for a limited term. That is what sets it apart from a monarchy, where the head of state (king or queen) ascends to the throne by heredity. The word "republic" comes from the Latin res publica, "the public thing".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('63b1cacf-d380-550b-b816-9982f84ee159', '6b5b357a-4aa7-5531-a0b6-250fc61d5c15', 'culture-generale-politique-en', '⭐ Quiz: Politics', 1, 50, 10, 'practice', 'admin', 1)
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
  ('1cdfff14-8892-58c3-a2db-d0ed8ba15177', '63b1cacf-d380-550b-b816-9982f84ee159', 'The word "democracy" is built from two Greek words. Which ones?', '[{"id":"a","text":"Dêmos (people) and kratos (power)"},{"id":"b","text":"Polis (city) and nomos (law)"},{"id":"c","text":"Monos (one) and arkhê (rule)"},{"id":"d","text":"Aristos (best) and kratos (power)"}]'::jsonb, 'a', 'Democracy = dêmos ("people") + kratos ("power"), that is, the power of the people. "Monos + arkhê" gives "monarchy" (the power of one) and "aristos + kratos" gives "aristocracy" (the power of the best / of the few): those roots are real, but they form other regimes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55847fc9-ccce-5bf4-b8ae-3a93b1b465f0', '63b1cacf-d380-550b-b816-9982f84ee159', 'What is the role of the executive power?', '[{"id":"a","text":"To vote on the laws"},{"id":"b","text":"To enforce the laws"},{"id":"c","text":"To judge trials"},{"id":"d","text":"To write the press"}]'::jsonb, 'b', 'The executive power enforces and carries out the laws; it is embodied by the head of state and the government. Voting on the laws belongs to the legislative, and judging belongs to the judiciary. The word "executive" comes from "execute", that is, to put into action.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6903b7f-2859-5c2a-962e-9d638ab0e32c', '63b1cacf-d380-550b-b816-9982f84ee159', 'In a monarchy, how does the head of state generally come to power?', '[{"id":"a","text":"By election through universal suffrage"},{"id":"b","text":"By an administrative examination"},{"id":"c","text":"By heredity"},{"id":"d","text":"By an annual referendum"}]'::jsonb, 'c', 'In a monarchy, the king or queen ascends to the throne by heredity (family succession). In a republic, by contrast, the head of state is elected. Today most monarchies are "constitutional": a constitution limits the monarch''s powers.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53be08c9-c20f-50db-8f37-099d00f1600b', '63b1cacf-d380-550b-b816-9982f84ee159', 'Which country is the textbook example of a presidential regime?', '[{"id":"a","text":"The United Kingdom"},{"id":"b","text":"Germany"},{"id":"c","text":"Italy"},{"id":"d","text":"The United States"}]'::jsonb, 'd', 'The United States is the model of the presidential regime: the president is both head of state and head of government, and cannot be removed by Congress. The United Kingdom, Germany and Italy are parliamentary regimes instead, where the government answers to Parliament.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a47e580-29a9-511b-968f-1582cc9abe3a', '63b1cacf-d380-550b-b816-9982f84ee159', 'What is the primary mission of the United Nations (UN)?', '[{"id":"a","text":"To maintain international peace and security"},{"id":"b","text":"To set the world price of oil"},{"id":"c","text":"To organize the Olympic Games"},{"id":"d","text":"To award the Nobel Prizes"}]'::jsonb, 'a', 'Created in 1945 after the Second World War, the UN''s primary goal is to maintain peace and security in the world. The Olympic Games are run by the IOC and the Nobel Prizes by Swedish and Norwegian foundations: those missions have nothing to do with the UN.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0696b124-6e65-5557-9ade-3dd26a1ec49e', '63b1cacf-d380-550b-b816-9982f84ee159', 'Who was the first president of the French Fifth Republic?', '[{"id":"a","text":"Georges Pompidou"},{"id":"b","text":"Charles de Gaulle"},{"id":"c","text":"François Mitterrand"},{"id":"d","text":"Vincent Auriol"}]'::jsonb, 'b', 'Charles de Gaulle, the driving force behind the Constitution of 4 October 1958, was its first president. Georges Pompidou succeeded him in 1969 and François Mitterrand was elected in 1981. Vincent Auriol, for his part, was president under the Fourth Republic, not the Fifth.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4e83a754-eade-58f5-9a8a-7b61fba7dfa3', '6b5b357a-4aa7-5531-a0b6-250fc61d5c15', 'culture-generale-politique-en', '⚔️ Boss ⭐⭐⭐: Politics', 3, 120, 30, 'boss', 'admin', 2)
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
  ('ed48840e-abd7-5c8d-bf01-568713fe676b', '4e83a754-eade-58f5-9a8a-7b61fba7dfa3', 'Which power has the role of judging and interpreting the laws?', '[{"id":"a","text":"The judicial power"},{"id":"b","text":"The legislative power"},{"id":"c","text":"The executive power"},{"id":"d","text":"The constituent power"}]'::jsonb, 'a', 'The judicial power, exercised by independent judges, settles disputes and interprets the laws. The "constituent power" refers to the authority that drafts or revises the Constitution: it is a trap, because it sounds right but is not one of Montesquieu''s three powers.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a09708df-9cf8-513a-8de3-f785bc4bc42c', '4e83a754-eade-58f5-9a8a-7b61fba7dfa3', 'In what year did women win the right to vote in France?', '[{"id":"a","text":"1936"},{"id":"b","text":"1944"},{"id":"c","text":"1958"},{"id":"d","text":"1968"}]'::jsonb, 'b', 'The ordinance of 21 April 1944, issued by General de Gaulle''s Provisional Government, granted women the right to vote; they voted for the first time in 1945. France was late: New Zealand had done so as early as 1893. 1958 (the Fifth Republic) and 1968 (May 1968) are decoys drawn from nearby landmark years.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aff9b6d4-7a7d-566c-9c54-d0b4d5cbebd8', '4e83a754-eade-58f5-9a8a-7b61fba7dfa3', 'In a parliamentary regime, which mechanism allows Parliament to bring down the government?', '[{"id":"a","text":"The vote of no confidence"},{"id":"b","text":"The presidential veto"},{"id":"c","text":"The motion to proceed"},{"id":"d","text":"The shared-initiative referendum"}]'::jsonb, 'a', 'A vote of no confidence, passed by members of parliament, forces the government to resign: it is the hallmark of the parliamentary regime, where the executive is accountable to Parliament. The veto is a tool of the president (presidential regime), and a shared-initiative referendum serves to propose a law, not to bring down a government.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44736310-e7b1-5ba7-aa11-bf9ad3368b85', '4e83a754-eade-58f5-9a8a-7b61fba7dfa3', 'What is the current length of the French president''s term of office (the quinquennat)?', '[{"id":"a","text":"4 years"},{"id":"b","text":"6 years"},{"id":"c","text":"5 years"},{"id":"d","text":"7 years"}]'::jsonb, 'c', 'Since the referendum of 2000 (under Jacques Chirac), the French presidential term has lasted 5 years: this is the quinquennat, first applied in 2002. Previously it was 7 years (the septennat): "7 years" is therefore the old length, a deliberately credible distractor.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b6921b03-0b60-5784-acd9-e1f59badce3d', '4e83a754-eade-58f5-9a8a-7b61fba7dfa3', 'How many states founded the United Nations in 1945?', '[{"id":"a","text":"27"},{"id":"b","text":"193"},{"id":"c","text":"100"},{"id":"d","text":"51"}]'::jsonb, 'd', 'The UN was founded in 1945 by 51 member states, following the San Francisco conference. Do not confuse this with the 193 members today: that is the classic trap. The number 27, for its part, evokes the member states of the European Union — a different organization.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd2177a2-8ab3-52ca-a42b-dd21eabb5368', '4e83a754-eade-58f5-9a8a-7b61fba7dfa3', 'Which article of the 1789 Declaration of the Rights of Man and of the Citizen states that "the principle of all sovereignty resides essentially in the nation"?', '[{"id":"a","text":"Article 1"},{"id":"b","text":"Article 3"},{"id":"c","text":"Article 16"},{"id":"d","text":"Article 10"}]'::jsonb, 'b', 'It is Article 3 of the 1789 Declaration that establishes national sovereignty: power emanates from the nation, not from the king. Beware the trap: Article 16, also famous, is the one that requires the separation of powers ("Any society in which... the separation of powers [is] not determined has no Constitution"). Article 1 proclaims that "men are born free and equal".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5a52706d-eb61-5430-80c1-75307ea90993', '6b5b357a-4aa7-5531-a0b6-250fc61d5c15', 'culture-generale-politique-en', '⭐⭐ Review: Politics', 2, 70, 15, 'practice', 'admin', 3)
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
  ('cca650a8-5433-582e-9d45-b578435b4e95', '5a52706d-eb61-5430-80c1-75307ea90993', 'In the classical regimes, the "power of the people" stands in contrast to aristocracy. What does aristocracy mean?', '[{"id":"a","text":"The power of one"},{"id":"b","text":"The power of the few"},{"id":"c","text":"The power of the judges"},{"id":"d","text":"The power of the majority"}]'::jsonb, 'b', 'Aristocracy (from the Greek aristos, "the best") is the rule of the few, supposedly the most qualified. The power of one is monarchy; the power of the majority is democracy. These three families of regimes were already described in antiquity by Aristotle.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2521889e-8b6f-53ab-b51b-66e0b8e3e352', '5a52706d-eb61-5430-80c1-75307ea90993', 'Why does Montesquieu defend the separation of powers?', '[{"id":"a","text":"To speed up the passing of laws"},{"id":"b","text":"To make the state less expensive"},{"id":"c","text":"To prevent the abuse of power and safeguard liberty"},{"id":"d","text":"To give all power to the king"}]'::jsonb, 'c', 'For Montesquieu, "power should check power": by entrusting the three functions to distinct bodies, tyranny is prevented and liberty is protected. The aim is neither speed nor economy, and certainly not to concentrate power in the hands of one person — that would be the opposite of his thesis.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9703385b-21d6-5b63-b4a4-837a3abb6b5a', '5a52706d-eb61-5430-80c1-75307ea90993', 'Which statement correctly describes a parliamentary regime?', '[{"id":"a","text":"The government is accountable to Parliament, which can bring it down"},{"id":"b","text":"The president can never be removed by Parliament"},{"id":"c","text":"There is no elected assembly at all"},{"id":"d","text":"The judges vote on the laws"}]'::jsonb, 'a', 'In a parliamentary regime, the government derives its legitimacy from Parliament and can be brought down by it (a vote of no confidence). The impossibility of removing the executive characterizes the presidential regime instead. A Parliament always exists, and judges never vote on the laws.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cefcc590-d8b9-558b-b253-b92f3947ae29', '5a52706d-eb61-5430-80c1-75307ea90993', 'The United Kingdom is an example of which type of regime?', '[{"id":"a","text":"A presidential republic"},{"id":"b","text":"A military dictatorship"},{"id":"c","text":"An absolute monarchy"},{"id":"d","text":"A constitutional monarchy"}]'::jsonb, 'd', 'The United Kingdom is a constitutional monarchy: a king (a hereditary head of state) with a largely symbolic role, and a Prime Minister who governs with the support of Parliament. It is not an absolute monarchy (the sovereign''s powers are strictly limited) nor a republic, since the head of state is not elected.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9071759c-1ae4-50d5-bcfb-d52f328d1a7d', '5a52706d-eb61-5430-80c1-75307ea90993', 'Which Constitution governs the French Fifth Republic?', '[{"id":"a","text":"The Constitution of 1946"},{"id":"b","text":"The Constitution of 1958"},{"id":"c","text":"The Constitution of 1875"},{"id":"d","text":"The Constitution of 1791"}]'::jsonb, 'b', 'The Fifth Republic is governed by the Constitution of 4 October 1958, championed by Charles de Gaulle. The one of 1946 founded the Fourth Republic, and the one of 1791 (born of the Revolution) established a constitutional monarchy: these are neighbouring texts but other regimes.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51a7f317-b934-5a30-b96e-c12b3ed70f41', '5a52706d-eb61-5430-80c1-75307ea90993', 'Where is the headquarters of the United Nations located?', '[{"id":"a","text":"Geneva"},{"id":"b","text":"Paris"},{"id":"c","text":"New York"},{"id":"d","text":"Brussels"}]'::jsonb, 'c', 'The UN headquarters is in New York, in the United States. Geneva does host a major UN office (and the former institutions of the League of Nations), but not the headquarters; Brussels is the heart of the European Union and NATO, and Paris that of UNESCO.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ef7d2ae2-19a0-5545-9977-1878de71fa5b', '6b5b357a-4aa7-5531-a0b6-250fc61d5c15', 'culture-generale-politique-en', '👑 Elite challenge ⭐⭐⭐⭐: Politics', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('7a469564-fbfe-5236-a613-068b4d4ed5be', 'ef7d2ae2-19a0-5545-9977-1878de71fa5b', 'In which work does Montesquieu set out his theory of the separation of powers?', '[{"id":"a","text":"The Social Contract"},{"id":"b","text":"The Spirit of the Laws"},{"id":"c","text":"Leviathan"},{"id":"d","text":"Persian Letters"}]'::jsonb, 'b', 'The separation of powers is set out in "The Spirit of the Laws" (1748). "The Social Contract" is by Rousseau, "Leviathan" by Hobbes (who argues, on the contrary, for a strong power), and "Persian Letters" is indeed by Montesquieu but is a satirical novel, not his political treatise: a subtle trap.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c961710f-3829-5d64-a5e9-93f9ff3de8a2', 'ef7d2ae2-19a0-5545-9977-1878de71fa5b', 'In what year was the quinquennat adopted by referendum in France?', '[{"id":"a","text":"1995"},{"id":"b","text":"2002"},{"id":"c","text":"2000"},{"id":"d","text":"2008"}]'::jsonb, 'c', 'The quinquennat was approved by referendum in 2000, under Jacques Chirac, and applied for the first time in 2002. 2002 is the year of the first application (the trap), and 2008 that of the revision limiting the president to two consecutive terms: real years, but they do not match the referendum.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08b53f34-a72d-5df4-935d-b09bb4359a47', 'ef7d2ae2-19a0-5545-9977-1878de71fa5b', 'Which article of the 1789 Declaration states that any society without a separation of powers "has no Constitution"?', '[{"id":"a","text":"Article 16"},{"id":"b","text":"Article 3"},{"id":"c","text":"Article 6"},{"id":"d","text":"Article 17"}]'::jsonb, 'a', 'It is Article 16: "Any society in which the guarantee of rights is not assured, nor the separation of powers determined, has no Constitution." Article 3 deals with national sovereignty, Article 6 with the law as "the expression of the general will", and Article 17 with the right to property.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6b774381-163c-5fb6-bbf8-b8df2e954b0e', 'ef7d2ae2-19a0-5545-9977-1878de71fa5b', 'France under the Fifth Republic is most often described as a regime that is:', '[{"id":"a","text":"Purely presidential"},{"id":"b","text":"Purely parliamentary"},{"id":"c","text":"Semi-presidential"},{"id":"d","text":"An assembly regime"}]'::jsonb, 'c', 'The Fifth Republic combines a president elected by universal suffrage with a government accountable to the National Assembly: this is called a semi-presidential (or mixed) regime. It is not "purely" presidential like the United States (where there is no accountable Prime Minister), nor an assembly regime, where Parliament dominates everything.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0e3518a-d9c8-591c-ad07-251a54655c86', 'ef7d2ae2-19a0-5545-9977-1878de71fa5b', 'How many member states does the United Nations have today?', '[{"id":"a","text":"151"},{"id":"b","text":"193"},{"id":"c","text":"27"},{"id":"d","text":"200"}]'::jsonb, 'b', 'The UN has 193 member states since South Sudan joined in 2011. The original 51 (1945) and the 27 of the European Union are nearby figures often confused with it; there are not exactly 200 recognized states in the world, which makes that distractor tempting but wrong.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('770bea83-c428-5f8d-82b6-75ab489c1572', 'ef7d2ae2-19a0-5545-9977-1878de71fa5b', 'Which principle states that political authority emanates from the people and not from a king by divine right?', '[{"id":"a","text":"National sovereignty"},{"id":"b","text":"Subsidiarity"},{"id":"c","text":"Secularism"},{"id":"d","text":"Federalism"}]'::jsonb, 'a', 'National (or popular) sovereignty holds that power comes from the people, breaking with the divine-right monarchy: this is the spirit of Article 3 of the 1789 Declaration. Subsidiarity concerns the distribution of powers between levels of government, secularism the separation of church and state, and federalism the territorial organization of power.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

