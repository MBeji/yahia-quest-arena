-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-economie-en (Culture générale — Économie (EN))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-economie-en/
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
  ('culture-generale-economie-en', 'Culture générale — Économie (EN)', 'The big ideas of economics: wealth, markets, money, and the players that keep the world turning.', 'Richesse', 'subject-french', 'TrendingUp', 20, 'en', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-economie-en'
      AND e.source = 'admin'
      AND q.id NOT IN ('ed8c8cc3-1a56-5723-84c7-0d02cb126101', '55552e38-5494-53ba-aa6a-14ce3a07c710', 'cbe47107-0313-5b62-a11b-be68aaf34014', 'c8881fc2-4acc-5c30-bf98-cde222191f66', '4cefbc02-b124-5322-bf7f-75e5c1573d83', '51dcc51a-c7e8-5078-b571-9ca8fff15ad9', 'afbc87d7-ca88-51e5-abe6-24895828f6a5', 'e4ff423a-bbdb-5adf-a7e1-0cc97fe6e026', 'c471bf88-73c5-5687-9093-018b2e3e6794', 'e4a007da-7d0b-5227-bbef-e8a8de58571d', 'cb77a718-f382-584b-a388-05d64f778ce5', '785fb21a-b99f-5960-8fd3-7246f67c02ee', 'd3c6746e-94f5-522b-9668-761729f79ea9', '77436ab6-655b-5b7f-9d23-46684fa7ab90', 'ee35f14f-ec6d-5d27-b931-ae41de34bf95', '8ffea12e-2558-599a-a5d5-2a1c288206c4', '33e9b0d8-cc6d-5811-a2c1-c3d3faa181bf', '3c6c1476-50de-5d4b-90b5-a4549568bb71', '6feeabd0-8a7b-5e04-a5da-33629a2f48ad', 'a3e66758-6702-5a78-a357-b4010ad33017', 'afec5bf5-aee1-5ed5-adbb-6b23d33385a8', '14bfed62-70ce-50e2-88c9-673eb5e88f02', '12e31386-18f6-5771-913a-606458bcd3f5', 'f85eb087-b184-5baa-990d-1e903c163f7c', '6e99d83e-5135-5499-8025-e32f0a6a5925', '19d19a9b-bc9e-51f4-badc-4aabb92d5382', '5f3d855c-0ea1-58a7-9116-254a6e27de37', 'ae5fa44e-b4b9-5f04-8d7c-3efa61ae60d7', '755a44e3-0d2b-5b9e-bbf1-9f7db6ca8ca6');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-economie-en' AND source = 'admin' AND id NOT IN ('ddea1daa-e463-5f22-8113-a8a4888363db', 'e6d0d276-27c3-546f-abb3-20c56f6425cb', '087b8817-e327-5254-9138-ee65f5b36385', '75475a3d-504a-55e7-903d-f6dcae81b9b1', '613704a3-995b-5eca-a0e5-ee7ba2004166');
DELETE FROM public.questions WHERE exercise_id IN ('ddea1daa-e463-5f22-8113-a8a4888363db', 'e6d0d276-27c3-546f-abb3-20c56f6425cb', '087b8817-e327-5254-9138-ee65f5b36385', '75475a3d-504a-55e7-903d-f6dcae81b9b1', '613704a3-995b-5eca-a0e5-ee7ba2004166') AND id NOT IN ('ed8c8cc3-1a56-5723-84c7-0d02cb126101', '55552e38-5494-53ba-aa6a-14ce3a07c710', 'cbe47107-0313-5b62-a11b-be68aaf34014', 'c8881fc2-4acc-5c30-bf98-cde222191f66', '4cefbc02-b124-5322-bf7f-75e5c1573d83', '51dcc51a-c7e8-5078-b571-9ca8fff15ad9', 'afbc87d7-ca88-51e5-abe6-24895828f6a5', 'e4ff423a-bbdb-5adf-a7e1-0cc97fe6e026', 'c471bf88-73c5-5687-9093-018b2e3e6794', 'e4a007da-7d0b-5227-bbef-e8a8de58571d', 'cb77a718-f382-584b-a388-05d64f778ce5', '785fb21a-b99f-5960-8fd3-7246f67c02ee', 'd3c6746e-94f5-522b-9668-761729f79ea9', '77436ab6-655b-5b7f-9d23-46684fa7ab90', 'ee35f14f-ec6d-5d27-b931-ae41de34bf95', '8ffea12e-2558-599a-a5d5-2a1c288206c4', '33e9b0d8-cc6d-5811-a2c1-c3d3faa181bf', '3c6c1476-50de-5d4b-90b5-a4549568bb71', '6feeabd0-8a7b-5e04-a5da-33629a2f48ad', 'a3e66758-6702-5a78-a357-b4010ad33017', 'afec5bf5-aee1-5ed5-adbb-6b23d33385a8', '14bfed62-70ce-50e2-88c9-673eb5e88f02', '12e31386-18f6-5771-913a-606458bcd3f5', 'f85eb087-b184-5baa-990d-1e903c163f7c', '6e99d83e-5135-5499-8025-e32f0a6a5925', '19d19a9b-bc9e-51f4-badc-4aabb92d5382', '5f3d855c-0ea1-58a7-9116-254a6e27de37', 'ae5fa44e-b4b9-5f04-8d7c-3efa61ae60d7', '755a44e3-0d2b-5b9e-bbf1-9f7db6ca8ca6');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-economie-en' AND c.id NOT IN ('3d010e95-8c55-531f-93d3-ca3c9753bb50') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('3d010e95-8c55-531f-93d3-ca3c9753bb50', 'culture-generale-economie-en', 'Economics: the basics', 'Wealth, GDP, markets, the law of supply and demand, money, inflation, and the major economic players: the toolkit for understanding the economy.', '# ⚔️ Economics — the grand arena of wealth

> 💡 "Economics is the art of making the most of resources that are never enough for everyone."

Welcome, apprentice strategist. Before you can conquer the markets, you must master the basic spells: what does it really mean to **produce**, to **trade**, to **spend**? This chapter hands you the toolkit to decode economic news and shine in general knowledge.

## 🏰 What is economics?

**Economics** is the science that studies how humans produce, trade, distribute, and consume **goods** (objects) and **services** (provided work) in the face of **scarce** resources. Scarcity is the starting point: our wants are unlimited, but time, money, and raw materials are limited. Every economic decision is therefore a **choice** — and every choice has a cost.

There are two main lenses:

| Level | What it observes | Sample question |
|---|---|---|
| **Microeconomics** | Individual agents (a household, a firm) | "What price should I sell my bread at?" |
| **Macroeconomics** | A country''s economy as a whole | "Will unemployment fall this year?" |

## ⚡ The players and the factors

Three major **economic agents** keep the machine running: **households** (who consume and work), **firms** (who produce), and the **State** (which collects taxes and redistributes). To produce, you combine **factors of production**: **labour** (human effort) and **capital** (machines, tools, buildings).

> 🗡️ Memory tip: *households, firms, State* — the three pillars. Let one falter and the arena wobbles.

## 🔮 The market: supply meets demand

A **market** is the place (real or virtual) where a good or a service is traded. The **law of supply and demand** is the magic that sets prices there:

- When **demand** outstrips **supply**, the good becomes scarce → the **price rises**.
- When supply outstrips demand, the good is plentiful → the **price falls**.

The **equilibrium price** is the magic point where the quantity supplied equals the quantity demanded: neither shortage nor surplus. The price thus expresses the **scarcity** of a good.

> ⚠️ Classic trap: believing that "a high price = a bad economy." A high price often signals strong demand or scarce supply — it is a signal, not a punishment.

## 🛡️ Money and inflation

**Money** serves three purposes: to pay (medium of exchange), to measure value (unit of account), and to save (store of value). Without it, we would have to go back to **barter**.

**Inflation** is the **general and lasting rise in prices**. Inflation of 5% means that, on average, what used to cost 100 now costs 105: your money loses **purchasing power**. A general and lasting fall in prices is called **deflation** — rarer, but fearsome.

## 🧮 Measuring wealth: GDP

**Gross Domestic Product (GDP)** measures the value of all the goods and services produced in a country over one year. It is the "score" of the national economy.

- **Nominal GDP**: calculated at current prices (includes inflation).
- **Real GDP**: adjusted for inflation → reflects true production.

**Economic growth** is the increase in real GDP from one year to the next.

## 🧪 The great guardians of the system

A few figures and institutions worth knowing:

- **Adam Smith** publishes *The Wealth of Nations* in **1776**, the birth certificate of modern economics and of the famous **"invisible hand"**: the pursuit of self-interest is said to benefit everyone.
- The **central bank** (the ECB for the eurozone) sets the **key interest rates** and watches over price stability.
- The **International Monetary Fund (IMF)**, created in **1944** at the **Bretton Woods** agreements, monitors global monetary stability and helps countries in difficulty.
- The **euro**, in circulation as banknotes and coins since **1 January 2002**, is the currency of the eurozone.

> 🏆 First gate cleared! You now know how to read a market, measure wealth, and name its guardians. Next step: face the Boss and prove that you have mastered the arena of wealth.', '# 📜 Summary: Economics — the basics

- **Economics**: the science of choices in the face of **scarcity** — producing, trading, distributing, and consuming goods and services.
- **Micro vs macro**: microeconomics observes individual agents (household, firm); macroeconomics observes the whole country.
- **Economic agents**: households (consume, work), firms (produce), the State (collects and redistributes). Factors of production: **labour** + **capital**.
- **Market & the law of supply and demand**: when demand outstrips supply, the price rises; the **equilibrium price** matches the quantity supplied and demanded.
- **Money**: medium of exchange, unit of account, and store of value; it replaces barter.
- **Inflation**: a general and lasting rise in prices → a fall in **purchasing power**; its opposite is **deflation**.
- **GDP**: the value of a country''s output over one year; **real** GDP is adjusted for inflation; its rise = **growth**.
- **Landmarks**: Adam Smith, *The Wealth of Nations* (**1776**), the "invisible hand"; the **IMF** created in **1944** (Bretton Woods); the **euro** in circulation since **1 January 2002**.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ddea1daa-e463-5f22-8113-a8a4888363db', '3d010e95-8c55-531f-93d3-ca3c9753bb50', 'culture-generale-economie-en', 'Comprehension check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('ed8c8cc3-1a56-5723-84c7-0d02cb126101', 'ddea1daa-e463-5f22-8113-a8a4888363db', 'What does a country''s Gross Domestic Product (GDP) measure?', '[{"id":"a","text":"The value of all goods and services produced in the country over one year"},{"id":"b","text":"The total amount of household savings"},{"id":"c","text":"The quantity of money in circulation"},{"id":"d","text":"The State''s debt owed to foreign creditors"}]'::jsonb, 'a', 'GDP adds up the value of all the goods and services a country produces over one year: it is the main indicator of its economic activity. Its rise from one year to the next is called growth. Don''t confuse it with savings or debt, which measure something else entirely.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55552e38-5494-53ba-aa6a-14ce3a07c710', 'ddea1daa-e463-5f22-8113-a8a4888363db', 'According to the law of supply and demand, what generally happens when demand for a good rises sharply while supply stays steady?', '[{"id":"a","text":"The price of the good tends to fall"},{"id":"b","text":"The price of the good tends to rise"},{"id":"c","text":"The price stays exactly the same"},{"id":"d","text":"The good disappears from the market for good"}]'::jsonb, 'b', 'When demand outstrips supply, the good becomes relatively scarce and its price rises toward the equilibrium price. The price acts as a signal of scarcity. It does not stay frozen: it is precisely its adjustment that balances the quantities supplied and demanded.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbe47107-0313-5b62-a11b-be68aaf34014', 'ddea1daa-e463-5f22-8113-a8a4888363db', 'How is inflation defined?', '[{"id":"a","text":"A fall in a country''s population"},{"id":"b","text":"The creation of a new currency"},{"id":"c","text":"A general and lasting rise in prices"},{"id":"d","text":"An increase in exports"}]'::jsonb, 'c', 'Inflation is the general and lasting rise in the price level: your money loses purchasing power. Its opposite, deflation, is a general fall in prices. Inflation of 5% means a basket that cost 100 now costs 105.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8881fc2-4acc-5c30-bf98-cde222191f66', 'ddea1daa-e463-5f22-8113-a8a4888363db', 'Which branch of economics studies the behaviour of an individual agent such as a household or a firm?', '[{"id":"a","text":"Macroeconomics"},{"id":"b","text":"Microeconomics"},{"id":"c","text":"Geopolitics"},{"id":"d","text":"National accounting"}]'::jsonb, 'b', 'Microeconomics studies the choices of individual agents (a household, a firm), while macroeconomics observes a country''s economy as a whole (unemployment, growth, inflation). The prefix "micro" (small) helps tell them apart.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4cefbc02-b124-5322-bf7f-75e5c1573d83', 'ddea1daa-e463-5f22-8113-a8a4888363db', 'Which of these is NOT a function of money?', '[{"id":"a","text":"Serving as a medium of exchange to pay"},{"id":"b","text":"Serving as a unit of account to measure value"},{"id":"c","text":"Serving as a store of value to save"},{"id":"d","text":"Single-handedly setting the country''s unemployment rate"}]'::jsonb, 'd', 'Money fulfils three functions: medium of exchange, unit of account, and store of value. The unemployment rate depends on the labour market and the economic climate, not on money alone. Without money, we would have to go back to barter, which is far less practical.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e6d0d276-27c3-546f-abb3-20c56f6425cb', '3d010e95-8c55-531f-93d3-ca3c9753bb50', 'culture-generale-economie-en', '⭐ Quiz: Economics', 1, 50, 10, 'practice', 'admin', 1)
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
  ('51dcc51a-c7e8-5078-b571-9ca8fff15ad9', 'e6d0d276-27c3-546f-abb3-20c56f6425cb', 'Which basic concept describes the fact that resources are limited while wants are unlimited?', '[{"id":"a","text":"Scarcity"},{"id":"b","text":"Abundance"},{"id":"c","text":"Free availability"},{"id":"d","text":"Waste"}]'::jsonb, 'a', 'Scarcity is the starting point of economics: because resources (time, money, materials) are limited, we have to make choices. It is the opposite of abundance. Every economic choice therefore has a cost, called the opportunity cost.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('afbc87d7-ca88-51e5-abe6-24895828f6a5', 'e6d0d276-27c3-546f-abb3-20c56f6425cb', 'Which of these is a service rather than a good?', '[{"id":"a","text":"A consultation with a doctor"},{"id":"b","text":"A bottle of water"},{"id":"c","text":"A mobile phone"},{"id":"d","text":"A pair of shoes"}]'::jsonb, 'a', 'A service is an intangible provision (a consultation, transport, a haircut), whereas a good is a physical object you can store. The medical consultation is therefore a service; the other three are goods.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4ff423a-bbdb-5adf-a7e1-0cc97fe6e026', 'e6d0d276-27c3-546f-abb3-20c56f6425cb', 'What are the three major economic agents of a country?', '[{"id":"a","text":"Banks, factories, and shops"},{"id":"b","text":"Buyers, sellers, and tourists"},{"id":"c","text":"Households, firms, and the State"},{"id":"d","text":"The rich, the poor, and the middle class"}]'::jsonb, 'c', 'The three basic economic agents are households (who consume and work), firms (who produce), and the State (which collects taxes and redistributes). Banks and shops are types of firms, not a separate category of agents.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c471bf88-73c5-5687-9093-018b2e3e6794', 'e6d0d276-27c3-546f-abb3-20c56f6425cb', 'What is money mainly used for in an economy?', '[{"id":"a","text":"To decorate wallets"},{"id":"b","text":"To completely replace work"},{"id":"c","text":"To make trade easier and to measure value"},{"id":"d","text":"To set the weather of the markets"}]'::jsonb, 'c', 'Money makes trade easier (medium of exchange), measures value (unit of account), and lets us save (store of value). Without it, we would have to fall back on barter, which is far more cumbersome because it requires a double coincidence of wants.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4a007da-7d0b-5227-bbef-e8a8de58571d', 'e6d0d276-27c3-546f-abb3-20c56f6425cb', 'What do we call the increase in a country''s output (real GDP) from one year to the next?', '[{"id":"a","text":"Inflation"},{"id":"b","text":"Economic growth"},{"id":"c","text":"Recession"},{"id":"d","text":"Unemployment"}]'::jsonb, 'b', 'Economic growth is the rise in real GDP from one year to the next. Don''t confuse it with inflation (a rise in prices) or with recession, which is on the contrary a fall in activity. When GDP falls in a lasting way, we speak of a recession.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb77a718-f382-584b-a388-05d64f778ce5', 'e6d0d276-27c3-546f-abb3-20c56f6425cb', 'On a market, what do we call the price at which the quantity supplied equals the quantity demanded?', '[{"id":"a","text":"The cost price"},{"id":"b","text":"The wholesale price"},{"id":"c","text":"The equilibrium price"},{"id":"d","text":"The luxury price"}]'::jsonb, 'c', 'The equilibrium price is the one where supply meets demand exactly: neither shortage nor surplus. It is the meeting point of the two curves. The cost price, by contrast, is what it costs to make a product, which is a different notion.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('087b8817-e327-5254-9138-ee65f5b36385', '3d010e95-8c55-531f-93d3-ca3c9753bb50', 'culture-generale-economie-en', '⚔️ Boss ⭐⭐⭐: Economics', 3, 120, 30, 'boss', 'admin', 2)
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
  ('785fb21a-b99f-5960-8fd3-7246f67c02ee', '087b8817-e327-5254-9138-ee65f5b36385', 'Which of these pairs makes up the two main factors of production?', '[{"id":"a","text":"Labour and capital"},{"id":"b","text":"Supply and demand"},{"id":"c","text":"Tax and subsidy"},{"id":"d","text":"Savings and debt"}]'::jsonb, 'a', 'Producing combines two factors: labour (human effort) and capital (machines, tools, buildings). Supply and demand, by contrast, describe how the market works, not the means of production. Some economists add land as a third factor.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3c6746e-94f5-522b-9668-761729f79ea9', '087b8817-e327-5254-9138-ee65f5b36385', 'Which Scottish philosopher is regarded as the father of modern economics with his 1776 work, The Wealth of Nations?', '[{"id":"a","text":"Karl Marx"},{"id":"b","text":"John Maynard Keynes"},{"id":"c","text":"David Ricardo"},{"id":"d","text":"Adam Smith"}]'::jsonb, 'd', 'Adam Smith publishes The Wealth of Nations in 1776, the birth certificate of modern economics and of the "invisible hand." Marx (19th c.) and Keynes (20th c.) came later; Ricardo, a contemporary of Smith, mainly theorised comparative advantage rather than founding the discipline.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('77436ab6-655b-5b7f-9d23-46684fa7ab90', '087b8817-e327-5254-9138-ee65f5b36385', 'What is the essential difference between nominal GDP and real GDP?', '[{"id":"a","text":"Real GDP includes inflation, nominal GDP excludes it"},{"id":"b","text":"Real GDP is adjusted for inflation, nominal GDP is calculated at current prices"},{"id":"c","text":"Nominal GDP covers services only"},{"id":"d","text":"Real GDP measures exports only"}]'::jsonb, 'b', 'Nominal GDP is measured at current prices and swells with inflation; real GDP is adjusted for inflation, so it reflects true production. It is real GDP that we track to judge growth. Option a flips the two notions exactly: that''s the trap.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee35f14f-ec6d-5d27-b931-ae41de34bf95', '087b8817-e327-5254-9138-ee65f5b36385', 'In 1944, the Bretton Woods agreements created an institution tasked with safeguarding the stability of the international monetary system. Which one?', '[{"id":"a","text":"The World Trade Organization (WTO)"},{"id":"b","text":"The United Nations (UN)"},{"id":"c","text":"The European Central Bank (ECB)"},{"id":"d","text":"The International Monetary Fund (IMF)"}]'::jsonb, 'd', 'The IMF was born in July 1944 at the Bretton Woods conference to stabilise the post-war monetary system and help countries in difficulty. The WTO dates from 1995, the ECB from 1998 (eurozone), and the UN, founded in 1945, has no specific monetary role.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ffea12e-2558-599a-a5d5-2a1c288206c4', '087b8817-e327-5254-9138-ee65f5b36385', 'An economy experiences 10% inflation over the year. What happens to the purchasing power of 100 kept under the mattress, in real terms?', '[{"id":"a","text":"It rises, because prices go up"},{"id":"b","text":"It falls: 100 buys fewer goods than before"},{"id":"c","text":"It stays exactly the same"},{"id":"d","text":"It automatically doubles"}]'::jsonb, 'b', 'With 10% inflation, what cost 100 now costs 110: the same 100 therefore buys fewer goods, so its purchasing power falls. The common trap is to think rising prices enrich those holding cash: it''s the opposite, inflation erodes uninvested savings.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33e9b0d8-cc6d-5811-a2c1-c3d3faa181bf', '087b8817-e327-5254-9138-ee65f5b36385', 'On a competitive market, the supply of a product suddenly doubles while demand stays unchanged. What is the most likely effect on the equilibrium price?', '[{"id":"a","text":"The equilibrium price falls"},{"id":"b","text":"The equilibrium price rises"},{"id":"c","text":"The equilibrium price is multiplied by two"},{"id":"d","text":"The market vanishes immediately"}]'::jsonb, 'a', 'When supply rises without demand following, the product becomes relatively plentiful and the equilibrium price falls to clear the quantities. The trap is to think that doubling supply doubles the price: the quantity supplied and the price move in opposite directions, not the same one.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('75475a3d-504a-55e7-903d-f6dcae81b9b1', '3d010e95-8c55-531f-93d3-ca3c9753bb50', 'culture-generale-economie-en', '⭐⭐ Review: Economics', 2, 70, 15, 'practice', 'admin', 3)
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
  ('3c6c1476-50de-5d4b-90b5-a4549568bb71', '75475a3d-504a-55e7-903d-f6dcae81b9b1', 'What do we call a general and lasting fall in prices, the opposite phenomenon of inflation?', '[{"id":"a","text":"Deflation"},{"id":"b","text":"Stagflation"},{"id":"c","text":"Devaluation"},{"id":"d","text":"Recession"}]'::jsonb, 'a', 'Deflation is the general and lasting fall in prices: don''t confuse it with recession (a fall in activity) or devaluation (a deliberate lowering of a currency''s value). Deflation is dreaded because it encourages people to postpone purchases, which slows the economy.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6feeabd0-8a7b-5e04-a5da-33629a2f48ad', '75475a3d-504a-55e7-903d-f6dcae81b9b1', 'Which level of economic analysis studies a country''s broad aggregates such as GDP, unemployment, or inflation?', '[{"id":"a","text":"Microeconomics"},{"id":"b","text":"Business management"},{"id":"c","text":"Marketing"},{"id":"d","text":"Macroeconomics"}]'::jsonb, 'd', 'Macroeconomics studies a country''s economy as a whole through its broad aggregates (GDP, unemployment, inflation). Microeconomics, by contrast, focuses on the choices of an individual agent. The prefix "macro" (large) signals that we are reasoning at the scale of the nation.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3e66758-6702-5a78-a357-b4010ad33017', '75475a3d-504a-55e7-903d-f6dcae81b9b1', 'Which expression by Adam Smith captures the idea that the pursuit of self-interest can benefit society as a whole?', '[{"id":"a","text":"Creative destruction"},{"id":"b","text":"Class struggle"},{"id":"c","text":"The invisible hand"},{"id":"d","text":"The Keynesian multiplier"}]'::jsonb, 'c', 'Adam Smith''s "invisible hand" describes how individual actions driven by self-interest contribute to the common good through the market. Creative destruction is Schumpeter''s, class struggle is Marx''s, and the multiplier is Keynes''s: each a different author and idea.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('afec5bf5-aee1-5ed5-adbb-6b23d33385a8', '75475a3d-504a-55e7-903d-f6dcae81b9b1', 'Which institution is tasked with setting key interest rates and safeguarding price stability in the eurozone?', '[{"id":"a","text":"The European Central Bank (ECB)"},{"id":"b","text":"The European Commission"},{"id":"c","text":"The European Parliament"},{"id":"d","text":"The International Monetary Fund (IMF)"}]'::jsonb, 'a', 'The ECB conducts the eurozone''s monetary policy: it sets key interest rates to keep inflation in check and prices stable. The Commission and Parliament have political and legislative roles, and the IMF acts at the global scale, not just within the eurozone.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14bfed62-70ce-50e2-88c9-673eb5e88f02', '75475a3d-504a-55e7-903d-f6dcae81b9b1', 'Since when have euro banknotes and coins physically circulated in the pockets of eurozone citizens?', '[{"id":"a","text":"Since 1 January 1999"},{"id":"b","text":"Since 1 January 2002"},{"id":"c","text":"Since 1 January 1995"},{"id":"d","text":"Since 1 January 2010"}]'::jsonb, 'b', 'Euro banknotes and coins were put into circulation on 1 January 2002. The euro had already existed since 1 January 1999, but only as an "invisible" currency (electronic and accounting payments): that''s the trap between the creation of the currency and the arrival of cash.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12e31386-18f6-5771-913a-606458bcd3f5', '75475a3d-504a-55e7-903d-f6dcae81b9b1', 'A firm sees the price of its raw materials rise sharply and passes that cost on to its selling prices. Which mechanism of inflation does this correspond to?', '[{"id":"a","text":"Demand-pull inflation"},{"id":"b","text":"Cost-push inflation"},{"id":"c","text":"Imported deflation"},{"id":"d","text":"Disinflation"}]'::jsonb, 'b', 'When a rise in production costs (raw materials, wages) pushes firms to raise their prices, we speak of cost-push inflation. Demand-pull inflation, by contrast, comes from demand exceeding supply. Disinflation is merely a slowdown of inflation, not a cause.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('613704a3-995b-5eca-a0e5-ee7ba2004166', '3d010e95-8c55-531f-93d3-ca3c9753bb50', 'culture-generale-economie-en', '👑 Elite challenge ⭐⭐⭐⭐: Economics', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('f85eb087-b184-5baa-990d-1e903c163f7c', '613704a3-995b-5eca-a0e5-ee7ba2004166', 'It is said that GDP does not measure everything. Which of these activities is NOT counted in a country''s official GDP?', '[{"id":"a","text":"The wage paid to a restaurant cook"},{"id":"b","text":"Unpaid domestic work done at home"},{"id":"c","text":"The building of a road by a company"},{"id":"d","text":"The sale of train tickets"}]'::jsonb, 'b', 'GDP counts only production that gives rise to a market or measurable exchange; unpaid domestic work (housework, childcare at home) is excluded. This is one of the great limits of GDP, often cited. The other three activities are paid and therefore counted.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6e99d83e-5135-5499-8025-e32f0a6a5925', '613704a3-995b-5eca-a0e5-ee7ba2004166', 'A central bank wants to fight inflation it judges too high. Which action is most consistent with that goal?', '[{"id":"a","text":"Raise its key interest rates to curb credit and demand"},{"id":"b","text":"Lower its key interest rates to encourage borrowing"},{"id":"c","text":"Hand out money to households for free"},{"id":"d","text":"Ban saving"}]'::jsonb, 'a', 'To calm inflation, a central bank raises its key interest rates: credit becomes more expensive, demand slows, and pressure on prices eases. The trap is to think rates should be lowered: that instead revives demand and therefore inflation. Handing out money would make it worse still.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19d19a9b-bc9e-51f4-badc-4aabb92d5382', '613704a3-995b-5eca-a0e5-ee7ba2004166', 'What do we call the value we give up when we choose one option over another, since we lack the resources to do everything?', '[{"id":"a","text":"Marginal cost"},{"id":"b","text":"Opportunity cost"},{"id":"c","text":"Fixed cost"},{"id":"d","text":"Cost price"}]'::jsonb, 'b', 'Opportunity cost is the value of the best option you give up: studying one evening means giving up the corresponding outing. Marginal cost is the cost of one extra unit produced, fixed cost does not depend on quantity, and cost price is the total cost of making a product.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f3d855c-0ea1-58a7-9116-254a6e27de37', '613704a3-995b-5eca-a0e5-ee7ba2004166', 'A country records two consecutive quarters of falling real GDP. Which economic term best describes this situation?', '[{"id":"a","text":"An expansion"},{"id":"b","text":"A recession"},{"id":"c","text":"Runaway inflation"},{"id":"d","text":"A fiscal stimulus"}]'::jsonb, 'b', 'A common definition of a recession is a fall in real GDP over two consecutive quarters. Expansion is the opposite (sustained growth). Inflation concerns prices, not output, and a fiscal stimulus is a government policy, not a state of the economy: those are the traps to avoid.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae5fa44e-b4b9-5f04-8d7c-3efa61ae60d7', '613704a3-995b-5eca-a0e5-ee7ba2004166', 'On a market of perfect competition, which of these conditions is required?', '[{"id":"a","text":"A single seller controls the whole market"},{"id":"b","text":"Buyers do not know the prices being charged"},{"id":"c","text":"The goods traded are homogeneous and the sellers very numerous"},{"id":"d","text":"The State itself sets all the prices"}]'::jsonb, 'c', 'Perfect competition assumes homogeneous goods, numerous sellers and buyers, perfect information on prices, and free entry into the market. A single seller is a monopoly (option a), while opaque prices (b) or State-set prices (d) directly contradict this model.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('755a44e3-0d2b-5b9e-bbf1-9f7db6ca8ca6', '613704a3-995b-5eca-a0e5-ee7ba2004166', 'In the phrase "economic agents are linked by flows," what does the flow running from households to firms in exchange for a wage correspond to?', '[{"id":"a","text":"The labour factor"},{"id":"b","text":"The capital factor"},{"id":"c","text":"Taxes"},{"id":"d","text":"Dividends"}]'::jsonb, 'a', 'Households supply their labour to firms and receive a wage in return: that is the labour factor. Capital refers to machines and tools, taxes flow to the State, and dividends reward shareholders, not the labour supplied. Telling these flows apart is the key to the economic circuit.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

