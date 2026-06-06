-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-geographie-ar (Culture générale — Géographie (AR))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-geographie-ar/
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
  ('culture-generale-geographie-ar', 'Culture générale — Géographie (AR)', 'البلدان والعواصم والقارات والمحيطات وأرقام الكوكب القياسية: جغرافيا العالم في صيغة الثقافة العامة.', 'Exploration', 'subject-english', 'Globe', 15, 'ar', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-geographie-ar'
      AND e.source = 'admin'
      AND q.id NOT IN ('532e15fd-1af2-5913-bba3-0c16bc106343', 'e3a63ba2-975d-59bb-84c2-060909f92e36', 'eda2b406-46dd-5e26-9683-2938f76ba3b2', 'c6f72d84-fb97-57b0-a174-bf0e752e3065', '348d823e-a0f4-5e1c-89c0-75c8e81df71b', '3aef2aa1-148b-5e32-b252-bfa7c2589b2e', 'a4a26912-efbd-5afa-842d-9c1eff05070c', '9fbb844e-138b-543e-b064-5f9a68ce2046', 'cb9b49ab-bae5-516a-abc9-f5d86c03a32b', 'fab82e5c-055f-540c-86ac-89d88ca90042', '430f7d1a-7487-530b-a934-cc8356d86554', '74c7f9af-a624-5c46-bf29-da7d4d4bc139', '38a14ee5-fdbc-50d9-a1e3-e886ecdb5b1b', 'f65dfc18-ddf0-5ac8-bb2b-81a10edb5bd7', '2f87c48f-ce6c-57af-80a8-cd377553e5a7', '3592b269-7a4c-5b89-90eb-2cfd30e75110', '3da9234c-54fd-5502-8c2c-05defd952e1a', 'a68f293d-3731-5319-aaf1-ef309af6b66f', '80b7abd8-6c82-5c12-b232-64389bd8efa6', 'cb4f52a2-bf0b-558e-9d7b-8b1f72987d0d', 'ac175de6-745d-5a3e-b93a-21965b691bfd', '2940cd92-d758-5608-911e-5de11216c3dd', '0e5aff9c-480f-5140-ba27-7868afebef2f', 'c5d33d0c-caca-58f5-8c0b-d2026f3435a5', '44908bab-7857-5e93-a4f4-d3040bd17469', 'b04da0ec-d65f-5bba-8f4c-b2d4d1b941e5', '2bb41a0b-56e1-5e05-96b9-077369a7c6dc', 'ab12ba49-1ffa-5b82-a89c-b25f3deadca1', '78a1efde-ef66-5d5b-a81e-646e30fc4ea2');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-geographie-ar' AND source = 'admin' AND id NOT IN ('13125378-eb2f-5d4e-a86a-ed05d45baba2', 'bb5d007e-1462-5d20-950b-341526a1e60c', 'fdb35888-9e9c-5e38-9e1e-c9047a089f50', 'bdd76f63-3701-5f28-928a-bc1aa3a8302e', '347b3125-cfd7-53f7-ab95-1c5ca91eadd9');
DELETE FROM public.questions WHERE exercise_id IN ('13125378-eb2f-5d4e-a86a-ed05d45baba2', 'bb5d007e-1462-5d20-950b-341526a1e60c', 'fdb35888-9e9c-5e38-9e1e-c9047a089f50', 'bdd76f63-3701-5f28-928a-bc1aa3a8302e', '347b3125-cfd7-53f7-ab95-1c5ca91eadd9') AND id NOT IN ('532e15fd-1af2-5913-bba3-0c16bc106343', 'e3a63ba2-975d-59bb-84c2-060909f92e36', 'eda2b406-46dd-5e26-9683-2938f76ba3b2', 'c6f72d84-fb97-57b0-a174-bf0e752e3065', '348d823e-a0f4-5e1c-89c0-75c8e81df71b', '3aef2aa1-148b-5e32-b252-bfa7c2589b2e', 'a4a26912-efbd-5afa-842d-9c1eff05070c', '9fbb844e-138b-543e-b064-5f9a68ce2046', 'cb9b49ab-bae5-516a-abc9-f5d86c03a32b', 'fab82e5c-055f-540c-86ac-89d88ca90042', '430f7d1a-7487-530b-a934-cc8356d86554', '74c7f9af-a624-5c46-bf29-da7d4d4bc139', '38a14ee5-fdbc-50d9-a1e3-e886ecdb5b1b', 'f65dfc18-ddf0-5ac8-bb2b-81a10edb5bd7', '2f87c48f-ce6c-57af-80a8-cd377553e5a7', '3592b269-7a4c-5b89-90eb-2cfd30e75110', '3da9234c-54fd-5502-8c2c-05defd952e1a', 'a68f293d-3731-5319-aaf1-ef309af6b66f', '80b7abd8-6c82-5c12-b232-64389bd8efa6', 'cb4f52a2-bf0b-558e-9d7b-8b1f72987d0d', 'ac175de6-745d-5a3e-b93a-21965b691bfd', '2940cd92-d758-5608-911e-5de11216c3dd', '0e5aff9c-480f-5140-ba27-7868afebef2f', 'c5d33d0c-caca-58f5-8c0b-d2026f3435a5', '44908bab-7857-5e93-a4f4-d3040bd17469', 'b04da0ec-d65f-5bba-8f4c-b2d4d1b941e5', '2bb41a0b-56e1-5e05-96b9-077369a7c6dc', 'ab12ba49-1ffa-5b82-a89c-b25f3deadca1', '78a1efde-ef66-5d5b-a81e-646e30fc4ea2');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-geographie-ar' AND c.id NOT IN ('4bfc26bf-0d13-5783-82af-3a8d52d4288f') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('4bfc26bf-0d13-5783-82af-3a8d52d4288f', 'culture-generale-geographie-ar', 'البلدان والعواصم', 'عواصم العالم (بما في ذلك الأفخاخ الشهيرة)، والقارات، والمحيطات، وأبرز الأرقام الجغرافية القياسية للكوكب.', '# ⚔️ أطلس العالم — انطلق لغزو البلدان والعواصم

> 💡 «من يعرف الخريطة لا يضلّ أبدًا: كل عاصمة بوابة، وكل حدود تحدٍّ.»

مرحبًا أيها المستكشف. هذا الفصل هو أول معاقلك الجغرافية. ستتعلم كيف تقرأ الكوكب كما يقرأ المغامر خريطة كنز: **القارات** و**المحيطات** و**البلدان** و**عواصمها** وكبرى **الأرقام القياسية** التي تجعل الأرض عالمًا مدهشًا. أتقنها، ولن يأخذك أي سؤال في الثقافة العامة على حين غرّة.

## 🌍 القارات والمحيطات

تتألف الأرض تقليديًّا من **7 قارات**: آسيا، وإفريقيا، وأمريكا الشمالية، وأمريكا الجنوبية، والقارة القطبية الجنوبية (أنتاركتيكا)، وأوروبا، وأوقيانوسيا. و**آسيا** هي الأوسع والأكثر سكانًا بفارق كبير.

أما من ناحية المياه، فهناك **5 محيطات**. أكبرها هو **المحيط الهادئ**، يليه الأطلسي، فالهندي، فالجنوبي، فالمتجمد الشمالي (وهو الأصغر).

| العنصر | الرقم القياسي | التفصيل |
|---|---|---|
| أكبر قارة | **آسيا** | نحو 44.5 مليون كم² |
| أكبر محيط | **الهادئ** | يغطي قرابة ثلث الكرة الأرضية |
| أكبر صحراء | **أنتاركتيكا** | صحراء باردة، نحو 14 مليون كم² |
| أكبر صحراء حارة | **الصحراء الكبرى** | نحو 9.4 مليون كم² |

> 🗡️ نصيحة مغامر: تُعرَّف **الصحراء** بقلّة تساقط الأمطار فيها، لا بالرمال. لهذا فإن **أنتاركتيكا** المتجمدة هي أكبر صحراء في العالم.

## 🏛️ العواصم… وأفخاخها

**العاصمة** هي المدينة التي يوجد فيها مقرّ حكومة البلد — وليست دائمًا أشهر مدنه! يعشق الممتحِنون هذه الأفخاخ:

- **أستراليا** ← العاصمة هي **كانبيرا**، لا سيدني ولا ملبورن (أُنشئت كانبيرا عام 1913 كحلّ وسط بين المدينتين المتنافستين).
- **كندا** ← **أوتاوا**، لا تورنتو.
- **البرازيل** ← **برازيليا**، مدينة بُنيت من العدم وافتُتحت عام 1960، لا ريو دي جانيرو.
- **تركيا** ← **أنقرة**، لا إسطنبول (أصبحت أنقرة عاصمة عام 1923).
- **الولايات المتحدة** ← **واشنطن العاصمة (D.C.)**، لا نيويورك.

> ⚠️ فخّ كلاسيكي: أكبر مدينة في بلد ما ليست بالضرورة عاصمته. تحقّق دائمًا من المدينة التي تحتضن **مقرّ الحكومة**.

## 📏 البلدان العملاقة والبلدان المتناهية الصغر

أكبر بلد في العالم من حيث المساحة هو **روسيا** (نحو 17 مليون كم²)، التي تمتد على قارّتين: أوروبا وآسيا. وأصغرها هو **الفاتيكان** (نحو 0.44 كم²)، المحاط بمدينة روما.

| الأعلى مرتبة | البلد | ما يجب تذكّره |
|---|---|---|
| أكبر بلد | **روسيا** | تمتد على قارّتين |
| أصغر بلد | **الفاتيكان** | دولة ذات سيادة داخل روما |
| أكثر البلدان سكانًا | **الهند** | تجاوزت الصين عام 2023 |

## 👥 الديموغرافيا المتغيّرة

ظلّت **الصين** لعقود البلد الأكثر سكانًا. لكن في عام **2023** تجاوزتها **الهند**، التي يبلغ عدد سكانها اليوم أكثر من **1.4 مليار** نسمة. فعدد سكان العالم إذًا ليس ثابتًا: إنه يتنقّل، وخريطة الأرقام القياسية تتطوّر.

## 🏔️ الأرقام القياسية الطبيعية التي يجب معرفتها

- أعلى قمة: **جبل إيفرست**، على ارتفاع **8849 م** (على الحدود بين النيبال والصين).
- أطول نهر: **النيل** (نحو 6650 كم) في إفريقيا، يتبعه عن قرب نهر **الأمازون** — نقاش لا يزال مفتوحًا بين الجغرافيين.
- أكبر صحراء حارة: **الصحراء الكبرى**، في شمال إفريقيا.

> 🏆 لقد اجتزت البوابة الأولى! صرت الآن تميّز بين القارات والمحيطات والعواصم-الأفخاخ والأرقام القياسية للكوكب. اشحذ خريطتك الذهنية: المعقل التالي سيأخذك أبعد في عجائب العالم.', '# 📜 ملخّص: البلدان والعواصم

- **7 قارات**: آسيا هي الأوسع والأكثر سكانًا.
- **5 محيطات**: **الهادئ** هو الأكبر، والمتجمد الشمالي هو الأصغر.
- **العاصمة ≠ أكبر مدينة**: أستراليا ← **كانبيرا**، كندا ← **أوتاوا**، البرازيل ← **برازيليا**، تركيا ← **أنقرة**، الولايات المتحدة ← **واشنطن العاصمة (D.C.)**.
- **أكبر بلد**: **روسيا** (نحو 17 مليون كم²)، تمتد على أوروبا وآسيا.
- **أصغر بلد**: **الفاتيكان** (نحو 0.44 كم²)، المحاط بمدينة روما.
- **أكثر البلدان سكانًا**: **الهند**، التي تجاوزت الصين عام **2023** (أكثر من 1.4 مليار نسمة).
- **أكبر صحراء**: **أنتاركتيكا** (صحراء باردة)؛ وأكبر صحراء حارة هي **الصحراء الكبرى**.
- **الأرقام القياسية الطبيعية**: أعلى قمة هي **جبل إيفرست** (8849 م)؛ وأطول نهر هو **النيل** (نحو 6650 كم).', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('13125378-eb2f-5d4e-a86a-ed05d45baba2', '4bfc26bf-0d13-5783-82af-3a8d52d4288f', 'culture-generale-geographie-ar', 'اختبار الفهم ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('532e15fd-1af2-5913-bba3-0c16bc106343', '13125378-eb2f-5d4e-a86a-ed05d45baba2', 'ما هي عاصمة أستراليا؟', '[{"id":"a","text":"سيدني"},{"id":"b","text":"ملبورن"},{"id":"c","text":"كانبيرا"},{"id":"d","text":"بيرث"}]'::jsonb, 'c', 'عاصمة أستراليا هي كانبيرا، التي أُنشئت عام 1913 كحلّ سياسي وسط بين سيدني وملبورن اللتين كانتا تتنازعان اللقب. سيدني هي أكبر مدن البلاد، لكن العاصمة هي حيث يوجد مقرّ الحكومة. والفخّ هنا اختيار سيدني لشهرتها فحسب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3a63ba2-975d-59bb-84c2-060909f92e36', '13125378-eb2f-5d4e-a86a-ed05d45baba2', 'ما هو أكبر بلد في العالم من حيث المساحة؟', '[{"id":"a","text":"روسيا"},{"id":"b","text":"كندا"},{"id":"c","text":"الصين"},{"id":"d","text":"الولايات المتحدة"}]'::jsonb, 'a', 'روسيا هي أكبر بلد في العالم بمساحة تناهز 17 مليون كم²، وتمتد على قارّتي أوروبا وآسيا. وتأتي كندا في المرتبة الثانية: هذا فخّ شائع، فهي شاسعة جدًّا لكنها تظلّ أصغر من روسيا بنحو الضعف.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eda2b406-46dd-5e26-9683-2938f76ba3b2', '13125378-eb2f-5d4e-a86a-ed05d45baba2', 'ما هو أكبر محيط في العالم؟', '[{"id":"a","text":"المحيط الأطلسي"},{"id":"b","text":"المحيط الهندي"},{"id":"c","text":"المحيط المتجمد الشمالي"},{"id":"d","text":"المحيط الهادئ"}]'::jsonb, 'd', 'المحيط الهادئ هو الأكبر: فهو وحده يغطي قرابة ثلث مساحة الكرة الأرضية. والأطلسي هو الثاني؛ أما المتجمد الشمالي فهو أصغر المحيطات الخمسة، وهو ما يجعل اختياره فخًّا معاكسًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c6f72d84-fb97-57b0-a174-bf0e752e3065', '13125378-eb2f-5d4e-a86a-ed05d45baba2', 'منذ عام 2023، ما هو البلد الأكثر سكانًا في العالم؟', '[{"id":"a","text":"الصين"},{"id":"b","text":"الهند"},{"id":"c","text":"الولايات المتحدة"},{"id":"d","text":"إندونيسيا"}]'::jsonb, 'b', 'تجاوزت الهند الصين عام 2023، وصار عدد سكانها اليوم أكثر من 1.4 مليار نسمة. احتفظت الصين بهذا الرقم القياسي طويلًا، لكن عدد سكانها بدأ يتراجع، في حين يواصل سكان الهند النموّ، وهو ما يجعل اختيار الصين فخًّا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('348d823e-a0f4-5e1c-89c0-75c8e81df71b', '13125378-eb2f-5d4e-a86a-ed05d45baba2', 'كم عدد القارات التي تتألف منها الأرض تقليديًّا؟', '[{"id":"a","text":"خمس"},{"id":"b","text":"ست"},{"id":"c","text":"سبع"},{"id":"d","text":"ثمان"}]'::jsonb, 'c', 'تُعدّ القارات تقليديًّا 7: آسيا، وإفريقيا، وأمريكا الشمالية، وأمريكا الجنوبية، وأنتاركتيكا، وأوروبا، وأوقيانوسيا. وآسيا هي الأوسع والأكثر سكانًا بينها. ويأتي الرقم ست من بعض التصنيفات التي تدمج الأمريكتين، لكن العدّ المرجعي هو سبع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bb5d007e-1462-5d20-950b-341526a1e60c', '4bfc26bf-0d13-5783-82af-3a8d52d4288f', 'culture-generale-geographie-ar', '⭐ اختبار: الجغرافيا', 1, 50, 10, 'practice', 'admin', 1)
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
  ('3aef2aa1-148b-5e32-b252-bfa7c2589b2e', 'bb5d007e-1462-5d20-950b-341526a1e60c', 'ما هي عاصمة فرنسا؟', '[{"id":"a","text":"ليون"},{"id":"b","text":"مرسيليا"},{"id":"c","text":"باريس"},{"id":"d","text":"بوردو"}]'::jsonb, 'c', 'باريس هي عاصمة فرنسا وأكبر مدنها. يخترقها نهر السين، وتحتضن مقرّ الحكومة ومؤسسات الجمهورية. أما مرسيليا فهي أكبر ميناء فرنسي وثاني أكبر مدينة، لكنها ليست العاصمة، وهذا ما يجعلها مشتِّتًا مغريًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4a26912-efbd-5afa-842d-9c1eff05070c', 'bb5d007e-1462-5d20-950b-341526a1e60c', 'في أي قارة تقع مصر؟', '[{"id":"a","text":"آسيا"},{"id":"b","text":"إفريقيا"},{"id":"c","text":"أوروبا"},{"id":"d","text":"أوقيانوسيا"}]'::jsonb, 'b', 'تقع مصر في شمال إفريقيا، يخترقها نهر النيل. وجزء صغير من أراضيها، وهو سيناء، يقع في آسيا: هذا ما يجعل السؤال فخًّا، لكن البلد يُنسب إلى إفريقيا. وعاصمتها القاهرة، أكبر مدينة عربية.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fbb844e-138b-543e-b064-5f9a68ce2046', 'bb5d007e-1462-5d20-950b-341526a1e60c', 'ما هو أصغر بلد في العالم من حيث المساحة؟', '[{"id":"a","text":"موناكو"},{"id":"b","text":"الفاتيكان"},{"id":"c","text":"سان مارينو"},{"id":"d","text":"ليختنشتاين"}]'::jsonb, 'b', 'الفاتيكان هو أصغر دولة في العالم بمساحة تناهز 0.44 كم²، وهو محاط بالكامل بمدينة روما. وتأتي موناكو في المرتبة الثانية كأصغر دولة: هذا هو الفخّ الكلاسيكي لهذا السؤال.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb9b49ab-bae5-516a-abc9-f5d86c03a32b', 'bb5d007e-1462-5d20-950b-341526a1e60c', 'ما هي عاصمة اليابان؟', '[{"id":"a","text":"أوساكا"},{"id":"b","text":"كيوتو"},{"id":"c","text":"طوكيو"},{"id":"d","text":"ناغويا"}]'::jsonb, 'c', 'طوكيو هي عاصمة اليابان منذ عام 1868. وكيوتو، العاصمة الإمبراطورية القديمة، فخّ متكرّر: فقد فقدت هذه المكانة حين انتقل الإمبراطور إلى طوكيو (التي يعني اسمها «عاصمة الشرق»).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fab82e5c-055f-540c-86ac-89d88ca90042', 'bb5d007e-1462-5d20-950b-341526a1e60c', 'ما هي أعلى قمة في العالم؟', '[{"id":"a","text":"جبل إيفرست"},{"id":"b","text":"قمة كي 2"},{"id":"c","text":"جبل مون بلان"},{"id":"d","text":"كيليمنجارو"}]'::jsonb, 'a', 'جبل إيفرست، على ارتفاع 8849 م، هو أعلى قمة في العالم؛ وينتصب على الحدود بين النيبال والصين. أما قمة كي 2 فهي ثاني أعلى قمة، وهذا ما يجعلها مشتِّتًا مغريًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('430f7d1a-7487-530b-a934-cc8356d86554', 'bb5d007e-1462-5d20-950b-341526a1e60c', 'ما هي أكبر صحراء حارة في العالم؟', '[{"id":"a","text":"صحراء جوبي"},{"id":"b","text":"الصحراء العربية"},{"id":"c","text":"صحراء كالاهاري"},{"id":"d","text":"الصحراء الكبرى"}]'::jsonb, 'd', 'الصحراء الكبرى، في شمال إفريقيا، هي أكبر صحراء حارة في العالم (نحو 9.4 مليون كم²). انتبه: أكبر صحراء على الإطلاق هي أنتاركتيكا، وهي صحراء باردة، لأن الصحراء تُعرَّف بقلّة تساقط الأمطار لا بالرمال.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fdb35888-9e9c-5e38-9e1e-c9047a089f50', '4bfc26bf-0d13-5783-82af-3a8d52d4288f', 'culture-generale-geographie-ar', '⚔️ الزعيم ⭐⭐⭐: الجغرافيا', 3, 120, 30, 'boss', 'admin', 2)
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
  ('74c7f9af-a624-5c46-bf29-da7d4d4bc139', 'fdb35888-9e9c-5e38-9e1e-c9047a089f50', 'ما هي عاصمة كندا؟', '[{"id":"a","text":"تورنتو"},{"id":"b","text":"أوتاوا"},{"id":"c","text":"مونتريال"},{"id":"d","text":"فانكوفر"}]'::jsonb, 'b', 'عاصمة كندا هي أوتاوا، في مقاطعة أونتاريو. والفخّ الشائع هو تورنتو، وهي أكبر مدن البلاد: تذكّر أن العاصمة هي مقرّ الحكومة، وليست بالضرورة المدينة الأكثر سكانًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('38a14ee5-fdbc-50d9-a1e3-e886ecdb5b1b', 'fdb35888-9e9c-5e38-9e1e-c9047a089f50', 'ما هي عاصمة البرازيل؟', '[{"id":"a","text":"ريو دي جانيرو"},{"id":"b","text":"ساو باولو"},{"id":"c","text":"برازيليا"},{"id":"d","text":"سلفادور"}]'::jsonb, 'c', 'برازيليا هي عاصمة البرازيل: مدينة بُنيت من العدم وافتُتحت عام 1960 لتنمية داخل البلاد. أما ريو دي جانيرو، العاصمة القديمة، فتظلّ الفخّ الأكثر إغراءً لأنها معروفة عالميًّا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f65dfc18-ddf0-5ac8-bb2b-81a10edb5bd7', 'fdb35888-9e9c-5e38-9e1e-c9047a089f50', 'ما هي عاصمة تركيا؟', '[{"id":"a","text":"إسطنبول"},{"id":"b","text":"إزمير"},{"id":"c","text":"بورصة"},{"id":"d","text":"أنقرة"}]'::jsonb, 'd', 'عاصمة تركيا هي أنقرة، التي اختارها مصطفى كمال عام 1923 لموقعها المركزي وللإيذان بقطيعة مع الحقبة العثمانية. أما إسطنبول، الممتدة على أوروبا وآسيا، فهي أكبر مدينة لكنها ليست العاصمة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2f87c48f-ce6c-57af-80a8-cd377553e5a7', 'fdb35888-9e9c-5e38-9e1e-c9047a089f50', 'أي محيط هو الأصغر في العالم؟', '[{"id":"a","text":"المحيط المتجمد الشمالي"},{"id":"b","text":"المحيط الهندي"},{"id":"c","text":"المحيط الجنوبي"},{"id":"d","text":"المحيط الأطلسي"}]'::jsonb, 'a', 'المحيط المتجمد الشمالي، حول القطب الشمالي، هو أصغر المحيطات الخمسة وأقلّها عمقًا. والفخّ هو الخلط بين «الأصغر» والمحيط الجنوبي، الأحدث في القائمة: لكن الأصغر فعلًا هو المتجمد الشمالي.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3592b269-7a4c-5b89-90eb-2cfd30e75110', 'fdb35888-9e9c-5e38-9e1e-c9047a089f50', 'أي نهر يُعتبر عمومًا أطول نهر في العالم؟', '[{"id":"a","text":"الأمازون"},{"id":"b","text":"اليانغتسي"},{"id":"c","text":"النيل"},{"id":"d","text":"المسيسيبي"}]'::jsonb, 'c', 'النيل (نحو 6650 كم)، في إفريقيا، يُعتبر تقليديًّا أطول نهر في العالم. ويتبعه الأمازون عن قرب شديد، بل يرى بعض الجغرافيين أنه أطول حسب طريقة القياس المعتمدة: إنه نقاش مفتوح، لكن النيل يظلّ الجواب المرجعي.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3da9234c-54fd-5502-8c2c-05defd952e1a', 'fdb35888-9e9c-5e38-9e1e-c9047a089f50', 'أكبر صحراء في العالم، من حيث المساحة، هي:', '[{"id":"a","text":"الصحراء الكبرى"},{"id":"b","text":"أنتاركتيكا"},{"id":"c","text":"الصحراء العربية"},{"id":"d","text":"صحراء جوبي"}]'::jsonb, 'b', 'أكبر صحراء في العالم هي أنتاركتيكا (نحو 14 مليون كم²)، وهي صحراء قطبية باردة. والفخّ الشائع هو الصحراء الكبرى: فهي ليست سوى أكبر صحراء حارة، لأن الصحراء تُعرَّف بندرة الأمطار لا بالحرارة أو الرمال.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bdd76f63-3701-5f28-928a-bc1aa3a8302e', '4bfc26bf-0d13-5783-82af-3a8d52d4288f', 'culture-generale-geographie-ar', '⭐⭐ مراجعة: الجغرافيا', 2, 70, 15, 'practice', 'admin', 3)
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
  ('a68f293d-3731-5319-aaf1-ef309af6b66f', 'bdd76f63-3701-5f28-928a-bc1aa3a8302e', 'ما هي عاصمة الولايات المتحدة؟', '[{"id":"a","text":"نيويورك"},{"id":"b","text":"واشنطن العاصمة (D.C.)"},{"id":"c","text":"لوس أنجلوس"},{"id":"d","text":"شيكاغو"}]'::jsonb, 'b', 'عاصمة الولايات المتحدة هي واشنطن العاصمة (D.C.)، وهي مقاطعة فيدرالية منفصلة عن الولايات. أما نيويورك، أكبر مدينة ومقرّ الأمم المتحدة، فهي الفخّ المعتاد لأن كثيرين يظنّونها العاصمة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80b7abd8-6c82-5c12-b232-64389bd8efa6', 'bdd76f63-3701-5f28-928a-bc1aa3a8302e', 'ما هي القارة الأكثر سكانًا في العالم؟', '[{"id":"a","text":"إفريقيا"},{"id":"b","text":"أوروبا"},{"id":"c","text":"آسيا"},{"id":"d","text":"الأمريكتان"}]'::jsonb, 'c', 'آسيا هي القارة الأكثر سكانًا: فهي تحتضن أكثر من نصف البشرية، ومن بينها الصين والهند، أكثر بلدين سكانًا. وهي أيضًا أوسع القارات.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb4f52a2-bf0b-558e-9d7b-8b1f72987d0d', 'bdd76f63-3701-5f28-928a-bc1aa3a8302e', 'ما هي عاصمة إسبانيا؟', '[{"id":"a","text":"برشلونة"},{"id":"b","text":"إشبيلية"},{"id":"c","text":"بلنسية"},{"id":"d","text":"مدريد"}]'::jsonb, 'd', 'مدريد، الواقعة في وسط البلاد، هي عاصمة إسبانيا وأكبر مدنها. أما برشلونة، عاصمة كتالونيا والمدينة الساحلية الشهيرة، فهي المشتِّت الأكثر إغراءً.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac175de6-745d-5a3e-b93a-21965b691bfd', 'bdd76f63-3701-5f28-928a-bc1aa3a8302e', 'على أي قارّتين تمتد روسيا؟', '[{"id":"a","text":"أوروبا وآسيا"},{"id":"b","text":"آسيا وإفريقيا"},{"id":"c","text":"أوروبا وأمريكا الشمالية"},{"id":"d","text":"آسيا وأوقيانوسيا"}]'::jsonb, 'a', 'روسيا بلد عابر للقارات يمتد على أوروبا (غرب جبال الأورال) وآسيا (سيبيريا، إلى الشرق). وهي أيضًا أكبر بلد في العالم من حيث المساحة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2940cd92-d758-5608-911e-5de11216c3dd', 'bdd76f63-3701-5f28-928a-bc1aa3a8302e', 'أي بلد ظلّ طويلًا الأكثر سكانًا قبل أن تتجاوزه الهند عام 2023؟', '[{"id":"a","text":"إندونيسيا"},{"id":"b","text":"الصين"},{"id":"c","text":"الولايات المتحدة"},{"id":"d","text":"باكستان"}]'::jsonb, 'b', 'كانت الصين البلد الأكثر سكانًا في العالم لعقود، إلى أن تجاوزتها الهند عام 2023. بل إن عدد سكان الصين بدأ يتراجع، نتيجة لانخفاض معدّل المواليد.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e5aff9c-480f-5140-ba27-7868afebef2f', 'bdd76f63-3701-5f28-928a-bc1aa3a8302e', 'كم عدد المحيطات المعترف بها على الأرض اليوم؟', '[{"id":"a","text":"ثلاثة"},{"id":"b","text":"أربعة"},{"id":"c","text":"خمسة"},{"id":"d","text":"ستة"}]'::jsonb, 'c', 'يُعترف اليوم بـ 5 محيطات: الهادئ، والأطلسي، والهندي، والجنوبي، والمتجمد الشمالي. والمحيط الجنوبي، حول أنتاركتيكا، هو الأحدث إضافةً إلى القائمة: كان يُقال قديمًا إنها أربعة فقط، وهو ما يجعل اختيار أربعة فخًّا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('347b3125-cfd7-53f7-ab95-1c5ca91eadd9', '4bfc26bf-0d13-5783-82af-3a8d52d4288f', 'culture-generale-geographie-ar', '👑 تحدي النخبة ⭐⭐⭐⭐: الجغرافيا', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('c5d33d0c-caca-58f5-8c0b-d2026f3435a5', '347b3125-cfd7-53f7-ab95-1c5ca91eadd9', 'ما هي عاصمة سويسرا؟', '[{"id":"a","text":"زيورخ"},{"id":"b","text":"جنيف"},{"id":"c","text":"برن"},{"id":"d","text":"بازل"}]'::jsonb, 'c', 'برن هي «المدينة الفيدرالية» ومقرّ الحكومة السويسرية منذ عام 1848. والفخّ الشائع هو زيورخ، أكبر مدينة، وجنيف، مقرّ منظمات دولية كثيرة؛ لكن أيًّا منهما ليست العاصمة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44908bab-7857-5e93-a4f4-d3040bd17469', '347b3125-cfd7-53f7-ab95-1c5ca91eadd9', 'ما هي العاصمة الإدارية (التنفيذية) لجنوب إفريقيا؟', '[{"id":"a","text":"كيب تاون"},{"id":"b","text":"جوهانسبرغ"},{"id":"c","text":"ديربان"},{"id":"d","text":"بريتوريا"}]'::jsonb, 'd', 'لجنوب إفريقيا ثلاث عواصم: بريتوريا (التنفيذية)، وكيب تاون (التشريعية)، وبلومفونتين (القضائية)؛ فعاصمة الحكومة إذًا هي بريتوريا. وهذا التوزيع، الذي يعود إلى عام 1910، كان حلًّا وسطًا كي لا تهيمن أي منطقة. أما جوهانسبرغ، أكبر مدينة، فلا تؤدّي أيًّا من هذه الأدوار.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b04da0ec-d65f-5bba-8f4c-b2d4d1b941e5', '347b3125-cfd7-53f7-ab95-1c5ca91eadd9', 'ما هي عاصمة كازاخستان؟', '[{"id":"a","text":"ألماتي"},{"id":"b","text":"أستانا"},{"id":"c","text":"طشقند"},{"id":"d","text":"بيشكك"}]'::jsonb, 'b', 'عاصمة كازاخستان هي أستانا، التي حلّت محلّ ألماتي عام 1997 (بل حملت لفترة وجيزة اسم نور سلطان بين عامي 2019 و2022). أما طشقند وبيشكك فمشتِّتان: إنهما عاصمتا أوزبكستان وقيرغيزستان المجاورتين.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2bb41a0b-56e1-5e05-96b9-077369a7c6dc', '347b3125-cfd7-53f7-ab95-1c5ca91eadd9', 'ما هي أكبر مسطّح مائي داخلي (أكبر بحيرة) في العالم؟', '[{"id":"a","text":"بحر قزوين"},{"id":"b","text":"بحيرة سوبيريور"},{"id":"c","text":"بحيرة فيكتوريا"},{"id":"d","text":"بحيرة بايكال"}]'::jsonb, 'a', 'رغم تسميته «بحرًا»، فإن بحر قزوين هو أكبر بحيرة في العالم من حيث المساحة. أما بحيرة سوبيريور فهي أكبر بحيرة مياه عذبة، وبايكال هي الأعمق: وهذان هما الفخّان الكلاسيكيان لهذا السؤال.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab12ba49-1ffa-5b82-a89c-b25f3deadca1', '347b3125-cfd7-53f7-ab95-1c5ca91eadd9', 'أي بلد محاط بالكامل بجنوب إفريقيا (جيب داخلي)؟', '[{"id":"a","text":"إسواتيني (سوازيلاند)"},{"id":"b","text":"بوتسوانا"},{"id":"c","text":"ليسوتو"},{"id":"d","text":"زيمبابوي"}]'::jsonb, 'c', 'ليسوتو دولة محصورة بالكامل داخل جنوب إفريقيا، وهي حالة نادرة في العالم. وإسواتيني مغرية لأنها أيضًا صغيرة ومجاورة، لكنها تشترك في حدود مع موزمبيق: فهي إذًا ليست محاطة بالكامل.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78a1efde-ef66-5d5b-a81e-646e30fc4ea2', '347b3125-cfd7-53f7-ab95-1c5ca91eadd9', 'أي مضيق يفصل أوروبا عن إفريقيا واصلًا المحيط الأطلسي بالبحر المتوسط؟', '[{"id":"a","text":"مضيق البوسفور"},{"id":"b","text":"مضيق جبل طارق"},{"id":"c","text":"مضيق ميسينا"},{"id":"d","text":"قناة السويس"}]'::jsonb, 'b', 'يفصل مضيق جبل طارق إسبانيا عن المغرب، ويصل المحيط الأطلسي بالبحر المتوسط. والبوسفور هو الفخّ: فهو يفصل بالفعل بين قارّتين، لكنهما أوروبا وآسيا، عند إسطنبول، وليس أوروبا وإفريقيا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

