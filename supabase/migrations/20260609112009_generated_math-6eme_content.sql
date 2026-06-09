-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: math-6eme (Mathématiques)
-- Regenerate with: npm run content:build
-- Source of truth: content/math-6eme/
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
  ('math-6eme', 'Mathématiques', 'الأنشطة العددية والهندسية وفق برنامج السنة السادسة من التعليم الأساسي', 'Force', 'subject-math', 'Calculator', 1, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '6eme-base'))
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
      AND e.subject_id = 'math-6eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('00d19597-764d-52d9-a251-b593748864e5', 'f5f5f9ba-119e-5573-aa31-919b7d4096c9', '526022da-43ba-5351-ba7f-22c88e20e9d0', 'f4a93be4-a45e-51bb-b489-da4495be783c', 'c4eeac9c-c565-5372-9aee-3936c295ea57', 'ad0e9663-0007-5000-9794-25df8c84deba', '38cb57ce-5b76-59eb-ac86-848f51dcb206', '36458ae1-5720-57c3-ae10-7701ff5b033b', '926877d1-8237-5a1f-8721-491116245990', '127d99dc-4446-59de-bfbd-9b64faf60da6', 'fe8ec271-ad30-538a-83a5-ffe7d6af17fd', 'e52cb4de-b360-524e-8896-3d8b67143281', 'deb76850-b242-519d-809c-e9998c7f2770', 'fbdd0512-8ebd-5910-bb1a-58fa957d08a4', 'd105bead-e998-5ac0-b0d6-0ca32c89c527', '3d01f743-8203-5ebd-90f5-24242ba875d5', '743eab91-a3e3-5520-b302-cfc329defaed', '0bad960f-2dc0-5d4c-b838-15932cd66ea4', 'a95c3e05-4c70-5128-8b97-feb330d66b85', '31346851-9af1-5aa0-a155-ce3c8d695c06', 'ae3df9d3-e85a-5323-9016-50bb23cfac15', '49fe9df7-5caf-5b0e-b663-420fe36538e9', 'd7c2736d-bcb6-5fca-bbcc-aba8e3ef8b56', '4a2c69ad-81d9-58b0-8360-2d66b4059f1c', '1e0583ba-a078-5a68-9d41-d21e92695596', 'b5f96abc-7bc8-5080-8a07-7b5f2a4a66d9', '3ca33026-1c62-57af-8516-b812537d0890', 'eb9f4ee2-0390-5ee6-84e3-b308468242d5', 'cf561c79-89ef-5c68-a694-109fa8757ffe', 'd64e0895-226f-5946-9bdf-1a5043be059b', '8c2342bf-efa3-5c68-8bc5-193d8a151e8a', '3fc2ba1a-17ca-5bf7-8645-4f7215632ce6', '4f3cbe47-adf6-5785-a7d8-86290d23de6e', '1adfd6db-987b-5f3d-9f50-ce0f9617e616', 'd9283d1a-3333-521c-8f47-c45c7be98bc6');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'math-6eme' AND source = 'admin' AND id NOT IN ('abf07a3b-2e3b-5b48-852f-88db3a74f5a3', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'd8796a14-723c-51d3-bffa-70c26cd05071', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749');
DELETE FROM public.questions WHERE exercise_id IN ('abf07a3b-2e3b-5b48-852f-88db3a74f5a3', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'd8796a14-723c-51d3-bffa-70c26cd05071', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749') AND id NOT IN ('00d19597-764d-52d9-a251-b593748864e5', 'f5f5f9ba-119e-5573-aa31-919b7d4096c9', '526022da-43ba-5351-ba7f-22c88e20e9d0', 'f4a93be4-a45e-51bb-b489-da4495be783c', 'c4eeac9c-c565-5372-9aee-3936c295ea57', 'ad0e9663-0007-5000-9794-25df8c84deba', '38cb57ce-5b76-59eb-ac86-848f51dcb206', '36458ae1-5720-57c3-ae10-7701ff5b033b', '926877d1-8237-5a1f-8721-491116245990', '127d99dc-4446-59de-bfbd-9b64faf60da6', 'fe8ec271-ad30-538a-83a5-ffe7d6af17fd', 'e52cb4de-b360-524e-8896-3d8b67143281', 'deb76850-b242-519d-809c-e9998c7f2770', 'fbdd0512-8ebd-5910-bb1a-58fa957d08a4', 'd105bead-e998-5ac0-b0d6-0ca32c89c527', '3d01f743-8203-5ebd-90f5-24242ba875d5', '743eab91-a3e3-5520-b302-cfc329defaed', '0bad960f-2dc0-5d4c-b838-15932cd66ea4', 'a95c3e05-4c70-5128-8b97-feb330d66b85', '31346851-9af1-5aa0-a155-ce3c8d695c06', 'ae3df9d3-e85a-5323-9016-50bb23cfac15', '49fe9df7-5caf-5b0e-b663-420fe36538e9', 'd7c2736d-bcb6-5fca-bbcc-aba8e3ef8b56', '4a2c69ad-81d9-58b0-8360-2d66b4059f1c', '1e0583ba-a078-5a68-9d41-d21e92695596', 'b5f96abc-7bc8-5080-8a07-7b5f2a4a66d9', '3ca33026-1c62-57af-8516-b812537d0890', 'eb9f4ee2-0390-5ee6-84e3-b308468242d5', 'cf561c79-89ef-5c68-a694-109fa8757ffe', 'd64e0895-226f-5946-9bdf-1a5043be059b', '8c2342bf-efa3-5c68-8bc5-193d8a151e8a', '3fc2ba1a-17ca-5bf7-8645-4f7215632ce6', '4f3cbe47-adf6-5785-a7d8-86290d23de6e', '1adfd6db-987b-5f3d-9f50-ce0f9617e616', 'd9283d1a-3333-521c-8f47-c45c7be98bc6');
DELETE FROM public.chapters c WHERE c.subject_id = 'math-6eme' AND c.id NOT IN ('249c14a0-d837-5f73-a270-c9c1d16631a6') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', 'الأعداد الطبيعية', 'نظام العدّ العشري، قراءة وكتابة الأعداد الكبيرة، التفكيك، المقارنة والترتيب، والتدوير', '# ⚔️ الأعداد الطبيعية — بوّابة عالَم الأعداد

> 💡 «من يُتقن الأعداد الكبيرة يُمسك بأوّل مفاتيح الرياضيات.»

أهلًا بك أيّها البطل في أوّل بوّابة من مغامرة السنة السادسة. هنا تتعلّم كيف **تقرأ** و**تكتب** و**تُفكّك** و**تقارن** و**تُدوّر** الأعداد الطبيعية مهما كَبُرت — هذا سلاحك الأوّل قبل خوض بقيّة المعارك.

## 🏰 ما هي الأعداد الطبيعية؟

الأعداد الطبيعية هي الأعداد التي نَعُدّ بها: **0، 1، 2، 3، 4، …** وتستمرّ بلا نهاية. نرمز إلى مجموعتها بالرمز **ℕ**.

- لكلّ عدد طبيعي *عددٌ يليه* (تالٍ): بعد 9 يأتي 10، وبعد 999 يأتي 1000.
- أصغر عدد طبيعي هو **0**، ولا يوجد **أكبر** عدد طبيعي.

## 🧮 نظام العدّ العشري: الأصناف والرتب

نكتب كلّ الأعداد باستعمال عشرة رموز فقط (من 0 إلى 9)، وتتعلّق قيمة الرقم بـ**موضعه** (رتبته). كلّ عشر وحدات من رتبةٍ تُكوّن وحدةً واحدة من الرتبة الأعلى.

| الرتبة | آحاد | عشرات | مئات | آلاف | عشرات الآلاف | مئات الآلاف | ملايين |
| --- | --- | --- | --- | --- | --- | --- | --- |
| قيمتها | 1 | 10 | 100 | 1 000 | 10 000 | 100 000 | 1 000 000 |

نُجمّع الأرقام في **أصناف** (ثلاثيّات) انطلاقًا من اليمين: صنف **الوحدات البسيطة**، ثمّ **الآلاف**، ثمّ **الملايين**، ثمّ **المليارات**.

## 🔮 قراءة وكتابة الأعداد الكبيرة

لقراءة عددٍ كبير: نُجمّع أرقامه ثلاثةً ثلاثةً انطلاقًا من اليمين، ثمّ نقرأ كلّ صنفٍ متبوعًا باسمه (مليار، مليون، ألف).

- *مثال:* العدد 45 207 089 يُقرأ: «خمسة وأربعون مليونًا، ومئتان وسبعة آلاف، وتسعة وثمانون».

> 🗡️ عند الكتابة بالأرقام نترك **فراغًا صغيرًا** بين الأصناف (لا فاصلة): 1 250 000، حتّى تَسهُل القراءة.

## ⚡ تفكيك عدد

تفكيك عددٍ يعني كتابته **مجموعَ حاصلات ضربٍ** حسب رتب أرقامه:

$$45\ 207 = 4\times10\,000 + 5\times1\,000 + 2\times100 + 0\times10 + 7\times1$$

- الرقم **0** في رتبةٍ يعني *لا شيء في تلك الرتبة*، لكنّه ضروريّ ليحفظ مواضع بقيّة الأرقام.

## 🛡️ المقارنة والترتيب

لمقارنة عددين طبيعيّين:

1. العدد ذو **عددِ الأرقام الأكبر** هو الأكبر (بعد إهمال الأصفار غير المفيدة على اليسار).
2. إذا تساوى عددُ الأرقام، نقارن **رقمًا رقمًا** من اليسار إلى اليمين عند أوّل اختلاف.

ثمّ نرتّب الأعداد **تصاعديًّا** (من الأصغر إلى الأكبر) أو **تنازليًّا** (العكس)، مستعملين الرموز < و > و =.

> ⚠️ الفخّ الشائع: الظنّ أنّ العدد ذا الأرقام الأكثر أكبرُ دائمًا دون الانتباه إلى الأصفار على اليسار، أو الخلط بين اتّجاهَي الرمزَين < و >.

## 📐 تدوير عدد (القيمة المقرّبة)

لتدوير عددٍ إلى رتبةٍ معيّنة (أقرب عشرة، مئة، ألف…):

- ننظر إلى الرقم الذي **يلي** الرتبة المطلوبة مباشرةً.
- إذا كان **5 أو أكثر** نُدوّر إلى الأعلى؛ وإذا كان **أقلّ من 5** نُبقي الرتبة كما هي، ثمّ نُعوّض كلّ ما بعدها أصفارًا.
- *مثال:* تدوير 4 729 إلى أقرب **مئة**: الرقم بعد المئات هو 2 (أقلّ من 5) ⟸ النتيجة 4 700. وتدويره إلى أقرب **ألف**: الرقم بعد الآلاف هو 7 (≥ 5) ⟸ النتيجة 5 000.

> 🏆 لقد عبرت البوّابة الأولى! صرت تتحكّم في الأعداد الطبيعية الكبيرة قراءةً وكتابةً وتفكيكًا ومقارنةً وتدويرًا. استعدّ الآن لبوّابة العمليّات على هذه الأعداد.', '# 📜 ملخّص: الأعداد الطبيعية

- **الأعداد الطبيعية (ℕ):** 0، 1، 2، 3، … بلا نهاية؛ أصغرها 0 ولا أكبر لها، ولكلّ عددٍ تالٍ.
- **نظام العدّ العشري:** عشرة رموز (0–9)، وقيمة الرقم حسب رتبته؛ كلّ 10 وحداتٍ من رتبةٍ = وحدةٌ من الرتبة الأعلى.
- **الأصناف:** نُجمّع الأرقام ثلاثيّاتٍ من اليمين: الوحدات، الآلاف، الملايين، المليارات.
- **القراءة والكتابة:** نقرأ كلّ صنفٍ متبوعًا باسمه؛ ونكتب بفراغٍ صغير بين الأصناف (1 250 000).
- **التفكيك:** كتابة العدد مجموعَ حاصلات ضربٍ حسب الرتب، مثل 45 207 = 4×10000 + 5×1000 + 2×100 + 7.
- **المقارنة:** الأكثر أرقامًا أكبر (بعد إهمال أصفار اليسار)، وعند التساوي نقارن رقمًا رقمًا من اليسار.
- **الترتيب:** تصاعديًّا (الأصغر ← الأكبر) أو تنازليًّا، بالرموز < و > و =.
- **التدوير:** ننظر إلى الرقم التالي للرتبة: إن كان ≥ 5 نُدوّر إلى الأعلى وإلّا نُبقيها، ونعوّض ما بعدها أصفارًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('abf07a3b-2e3b-5b48-852f-88db3a74f5a3', '249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('00d19597-764d-52d9-a251-b593748864e5', 'abf07a3b-2e3b-5b48-852f-88db3a74f5a3', 'ما أصغر عددٍ طبيعيّ؟', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"−1"},{"id":"d","text":"لا يوجد أصغر عددٍ طبيعيّ"}]'::jsonb, 'a', 'أصغر عددٍ طبيعيّ هو 0، ثمّ تتوالى الأعداد 1، 2، 3… بلا نهاية. أمّا −1 فليس عددًا طبيعيًّا لأنّه سالب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5f5f9ba-119e-5573-aa31-919b7d4096c9', 'abf07a3b-2e3b-5b48-852f-88db3a74f5a3', 'كيف نكتب بالأرقام العددَ «اثنا عشر ألفًا وخمسة»؟', '[{"id":"a","text":"12 050"},{"id":"b","text":"12 005"},{"id":"c","text":"1 205"},{"id":"d","text":"12 500"}]'::jsonb, 'b', 'اثنا عشر ألفًا = 12 000، وخمسة آحاد = 5، فيكون العدد 12 005 (مع صفرٍ في المئات وصفرٍ في العشرات للحفاظ على المواضع).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('526022da-43ba-5351-ba7f-22c88e20e9d0', 'abf07a3b-2e3b-5b48-852f-88db3a74f5a3', 'في العدد 38 461، ما رتبة الرقم 8؟', '[{"id":"a","text":"العشرات"},{"id":"b","text":"المئات"},{"id":"c","text":"الآلاف"},{"id":"d","text":"عشرات الآلاف"}]'::jsonb, 'c', 'ابتداءً من اليمين في 38 461: الرقم 1 آحاد، 6 عشرات، 4 مئات، 8 آلاف، 3 عشرات الآلاف. إذن الرقم 8 في رتبة الآلاف.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4a93be4-a45e-51bb-b489-da4495be783c', 'abf07a3b-2e3b-5b48-852f-88db3a74f5a3', 'ما العلاقة الصحيحة بين العددين 7 080 و 7 800؟', '[{"id":"a","text":"7 080 = 7 800"},{"id":"b","text":"7 080 > 7 800"},{"id":"c","text":"لا يمكن المقارنة"},{"id":"d","text":"7 080 < 7 800"}]'::jsonb, 'd', 'للعددين 4 أرقام؛ نقارن من اليسار: الآلاف متساوية (7 = 7)، ثمّ المئات: 0 < 8. إذن 7 080 < 7 800.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4eeac9c-c565-5372-9aee-3936c295ea57', 'abf07a3b-2e3b-5b48-852f-88db3a74f5a3', 'ما القيمة المقرّبة للعدد 3 472 إلى أقرب مئة؟', '[{"id":"a","text":"3 400"},{"id":"b","text":"3 500"},{"id":"c","text":"3 470"},{"id":"d","text":"3 000"}]'::jsonb, 'b', 'للتدوير إلى أقرب مئة ننظر إلى رقم العشرات: هو 7 (أكبر من أو يساوي 5)، فنُدوّر إلى الأعلى. إذن 3 472 يصبح 3 500.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('93a4884b-00bf-590a-8bb8-f45f9b7384e4', '249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', '⭐ تمرين: أوّل خطوات في عالَم الأعداد', 1, 50, 10, 'practice', 'admin', 1)
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
  ('ad0e9663-0007-5000-9794-25df8c84deba', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'في العدد 5 327، ما رتبة الرقم 3؟', '[{"id":"a","text":"الآحاد"},{"id":"b","text":"العشرات"},{"id":"c","text":"المئات"},{"id":"d","text":"الآلاف"}]'::jsonb, 'c', 'ابتداءً من اليمين في 5 327: الرقم 7 آحاد، 2 عشرات، 3 مئات، 5 آلاف. إذن الرقم 3 في رتبة المئات.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('38cb57ce-5b76-59eb-ac86-848f51dcb206', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'كيف يُقرأ العدد 4 060؟', '[{"id":"a","text":"أربعمئة وستّون"},{"id":"b","text":"أربعة آلاف وستّون"},{"id":"c","text":"أربعة آلاف وستّمئة"},{"id":"d","text":"أربعون ألفًا وستّون"}]'::jsonb, 'b', 'العدد 4 060 = 4 آلاف + 0 مئات + 6 عشرات + 0 آحاد، فيُقرأ «أربعة آلاف وستّون».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36458ae1-5720-57c3-ae10-7701ff5b033b', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'كيف نكتب بالأرقام العددَ «ثلاثمئة وسبعة»؟', '[{"id":"a","text":"307"},{"id":"b","text":"370"},{"id":"c","text":"3 007"},{"id":"d","text":"3 070"}]'::jsonb, 'a', 'ثلاثمئة = 300 وسبعة آحاد = 7، مع صفرٍ في رتبة العشرات، فيكون العدد 307.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('926877d1-8237-5a1f-8721-491116245990', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'أيّ تفكيكٍ يوافق العدد 2 503؟', '[{"id":"a","text":"2×100 + 5×10 + 3"},{"id":"b","text":"25×100 + 3"},{"id":"c","text":"2×1000 + 5×10 + 3"},{"id":"d","text":"2×1000 + 5×100 + 3"}]'::jsonb, 'd', 'العدد 2 503 = 2 آلاف + 5 مئات + 0 عشرات + 3 آحاد، أي 2×1000 + 5×100 + 3.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('127d99dc-4446-59de-bfbd-9b64faf60da6', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'أيّ الأعداد التالية هو الأكبر؟', '[{"id":"a","text":"9 100"},{"id":"b","text":"8 910"},{"id":"c","text":"8 099"},{"id":"d","text":"9 010"}]'::jsonb, 'a', 'نقارن رتبة الآلاف أوّلًا: 9 > 8 فيبقى المرشّحان 9 100 و 9 010؛ ثمّ المئات: 1 > 0، إذن الأكبر هو 9 100.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe8ec271-ad30-538a-83a5-ffe7d6af17fd', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'ما العدد الطبيعيّ الذي يلي مباشرةً العددَ 6 999؟', '[{"id":"a","text":"6 998"},{"id":"b","text":"6 990"},{"id":"c","text":"7 000"},{"id":"d","text":"60 000"}]'::jsonb, 'c', 'العدد التالي مباشرةً يساوي العددَ زائد 1: 6 999 + 1 = 7 000.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d8796a14-723c-51d3-bffa-70c26cd05071', '249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', '⚔️ زعيم الفصل ⭐⭐⭐: تحدّي الأعداد الكبيرة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('e52cb4de-b360-524e-8896-3d8b67143281', 'd8796a14-723c-51d3-bffa-70c26cd05071', 'في العدد 7 254 130، ما رتبة الرقم 5؟', '[{"id":"a","text":"الآلاف"},{"id":"b","text":"عشرات الآلاف"},{"id":"c","text":"مئات الآلاف"},{"id":"d","text":"الملايين"}]'::jsonb, 'b', 'من اليمين في 7 254 130: 0 آحاد، 3 عشرات، 1 مئات، 4 آلاف، 5 عشرات الآلاف، 2 مئات الآلاف، 7 ملايين. إذن الرقم 5 في رتبة عشرات الآلاف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('deb76850-b242-519d-809c-e9998c7f2770', 'd8796a14-723c-51d3-bffa-70c26cd05071', 'كيف يُقرأ العدد 1 005 200؟', '[{"id":"a","text":"مليون وخمسمئة ألفٍ ومئتان"},{"id":"b","text":"مئة ألفٍ وخمسة آلاف ومئتان"},{"id":"c","text":"مليون وخمسة آلاف ومئتان"},{"id":"d","text":"مليون وخمسون ألفًا ومئتان"}]'::jsonb, 'c', 'نُجمّع الأرقام ثلاثيّاتٍ من اليمين: 1 (مليون) | 005 (خمسة آلاف) | 200 (مئتان). فيُقرأ «مليون وخمسة آلاف ومئتان».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fbdd0512-8ebd-5910-bb1a-58fa957d08a4', 'd8796a14-723c-51d3-bffa-70c26cd05071', 'ما الترتيب التصاعدي للأعداد: 4 050 ؛ 4 500 ؛ 4 005 ؛ 4 055؟', '[{"id":"a","text":"4 500 < 4 055 < 4 050 < 4 005"},{"id":"b","text":"4 005 < 4 050 < 4 055 < 4 500"},{"id":"c","text":"4 005 < 4 055 < 4 050 < 4 500"},{"id":"d","text":"4 050 < 4 005 < 4 055 < 4 500"}]'::jsonb, 'b', 'الآلاف متساوية (4)؛ نقارن المئات ثمّ العشرات: 4 005 ثمّ 4 050 ثمّ 4 055 ثمّ 4 500. الترتيب التصاعدي: 4 005 < 4 050 < 4 055 < 4 500.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d105bead-e998-5ac0-b0d6-0ca32c89c527', 'd8796a14-723c-51d3-bffa-70c26cd05071', 'ما القيمة المقرّبة للعدد 28 617 إلى أقرب ألف؟', '[{"id":"a","text":"28 000"},{"id":"b","text":"30 000"},{"id":"c","text":"29 000"},{"id":"d","text":"28 600"}]'::jsonb, 'c', 'للتدوير إلى أقرب ألف ننظر إلى رقم المئات: 6 (أكبر من أو يساوي 5)، فنُدوّر الآلاف إلى الأعلى: 28 617 يصبح 29 000.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d01f743-8203-5ebd-90f5-24242ba875d5', 'd8796a14-723c-51d3-bffa-70c26cd05071', 'حضر مباراةً 38 920 متفرّجًا. ما هذا العدد مقرّبًا إلى أقرب ألف؟', '[{"id":"a","text":"39 000"},{"id":"b","text":"38 000"},{"id":"c","text":"38 900"},{"id":"d","text":"40 000"}]'::jsonb, 'a', 'رقم المئات هو 9 (أكبر من أو يساوي 5) فنُدوّر الآلاف إلى الأعلى: 38 920 يصبح 39 000. الخطأ الشائع تدويرها نزولًا إلى 38 000.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('743eab91-a3e3-5520-b302-cfc329defaed', 'd8796a14-723c-51d3-bffa-70c26cd05071', 'ما أكبر عددٍ من أربعة أرقامٍ مختلفة نُكوّنه بالأرقام 7 و 0 و 5 و 2 (دون تكرار)؟', '[{"id":"a","text":"7 250"},{"id":"b","text":"2 750"},{"id":"c","text":"5 720"},{"id":"d","text":"7 520"}]'::jsonb, 'd', 'لأكبر قيمةٍ نضع الأرقام تنازليًّا من اليسار: 7 ثمّ 5 ثمّ 2 ثمّ 0، فيكون العدد 7 520.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('71e406d6-2a21-5b53-a2cc-fd4445e86f6e', '249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الأعداد الطبيعية', 2, 70, 15, 'practice', 'admin', 3)
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
  ('0bad960f-2dc0-5d4c-b838-15932cd66ea4', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'في العدد 902 340، ما رتبة الرقم 9؟', '[{"id":"a","text":"الملايين"},{"id":"b","text":"مئات الآلاف"},{"id":"c","text":"عشرات الآلاف"},{"id":"d","text":"الآلاف"}]'::jsonb, 'b', 'في 902 340 الرقم 9 في أقصى اليسار، وهو في رتبة مئات الآلاف (قيمته 900 000).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a95c3e05-4c70-5128-8b97-feb330d66b85', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'كيف نكتب بالأرقام العددَ «مئتا ألفٍ وثلاثة»؟', '[{"id":"a","text":"200 300"},{"id":"b","text":"200 030"},{"id":"c","text":"200 003"},{"id":"d","text":"23 000"}]'::jsonb, 'c', 'مئتا ألفٍ = 200 000 وثلاثة آحاد = 3، مع أصفارٍ في بقيّة الرتب، فيكون العدد 200 003.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31346851-9af1-5aa0-a155-ce3c8d695c06', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'أيّ الأعداد التالية محصورٌ بين 5 000 و 6 000؟', '[{"id":"a","text":"4 950"},{"id":"b","text":"6 050"},{"id":"c","text":"5 500"},{"id":"d","text":"6 500"}]'::jsonb, 'c', 'العدد المحصور بين 5 000 و 6 000 يبدأ بالرقم 5 في رتبة الآلاف؛ من بين الخيارات هو 5 500.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae3df9d3-e85a-5323-9016-50bb23cfac15', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'ما الترتيب التنازلي للأعداد: 1 200 ؛ 1 020 ؛ 1 002 ؛ 1 220؟', '[{"id":"a","text":"1 002 > 1 020 > 1 200 > 1 220"},{"id":"b","text":"1 220 > 1 020 > 1 200 > 1 002"},{"id":"c","text":"1 200 > 1 220 > 1 020 > 1 002"},{"id":"d","text":"1 220 > 1 200 > 1 020 > 1 002"}]'::jsonb, 'd', 'الآلاف متساوية (1)؛ نقارن المئات ثمّ العشرات: الترتيب التنازلي هو 1 220 > 1 200 > 1 020 > 1 002.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49fe9df7-5caf-5b0e-b663-420fe36538e9', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'ما القيمة المقرّبة للعدد 7 486 إلى أقرب عشرة؟', '[{"id":"a","text":"7 490"},{"id":"b","text":"7 480"},{"id":"c","text":"7 500"},{"id":"d","text":"7 400"}]'::jsonb, 'a', 'للتدوير إلى أقرب عشرة ننظر إلى رقم الآحاد: 6 (أكبر من أو يساوي 5) فنُدوّر العشرات إلى الأعلى: 7 486 يصبح 7 490.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7c2736d-bcb6-5fca-bbcc-aba8e3ef8b56', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'قطع عدّاءٌ مسافة 8 750 مترًا. ما هذه المسافة مقرّبةً إلى أقرب مئة متر؟', '[{"id":"a","text":"8 700"},{"id":"b","text":"8 800"},{"id":"c","text":"8 750"},{"id":"d","text":"9 000"}]'::jsonb, 'b', 'رقم العشرات هو 5 (أكبر من أو يساوي 5) فنُدوّر المئات إلى الأعلى: 8 750 يصبح 8 800.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b386e00e-ef4e-56a2-be56-41de1a2a68db', '249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سادة الأعداد', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('4a2c69ad-81d9-58b0-8360-2d66b4059f1c', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'ما القيمة التي يمثّلها الرقم 3 في العدد 6 308 152؟', '[{"id":"a","text":"3 000"},{"id":"b","text":"30 000"},{"id":"c","text":"300 000"},{"id":"d","text":"3 000 000"}]'::jsonb, 'c', 'الرقم 3 في 6 308 152 يقع في رتبة مئات الآلاف، فقيمته 3 × 100 000 = 300 000.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e0583ba-a078-5a68-9d41-d21e92695596', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'كيف يُقرأ العدد 40 007 030؟', '[{"id":"a","text":"أربعمئة مليونٍ وسبعة آلاف وثلاثون"},{"id":"b","text":"أربعون مليونًا وسبعة آلاف وثلاثون"},{"id":"c","text":"أربعون مليونًا وسبعون ألفًا وثلاثون"},{"id":"d","text":"أربعة ملايين وسبعة آلاف وثلاثون"}]'::jsonb, 'b', 'نُجمّع الأرقام ثلاثيّاتٍ من اليمين: 40 (أربعون مليونًا) | 007 (سبعة آلاف) | 030 (ثلاثون). إذن «أربعون مليونًا وسبعة آلاف وثلاثون».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5f96abc-7bc8-5080-8a07-7b5f2a4a66d9', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'ما أصغر عددٍ من خمسة أرقامٍ مختلفة (لا يبدأ بالصفر)؟', '[{"id":"a","text":"10 234"},{"id":"b","text":"01 234"},{"id":"c","text":"12 340"},{"id":"d","text":"10 000"}]'::jsonb, 'a', 'لا نبدأ بالصفر وإلّا صار العدد من 4 أرقام؛ نبدأ بأصغر رقمٍ غير الصفر (1) ثمّ نرتّب الباقي تصاعديًّا 0، 2، 3، 4، فنحصل على 10 234. أمّا 10 000 فأرقامه غير مختلفة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ca33026-1c62-57af-8516-b812537d0890', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'ما القيمة المقرّبة للعدد 6 970 إلى أقرب مئة؟', '[{"id":"a","text":"6 900"},{"id":"b","text":"6 970"},{"id":"c","text":"7 100"},{"id":"d","text":"7 000"}]'::jsonb, 'd', 'رقم العشرات 7 (أكبر من أو يساوي 5) فنُدوّر المئات إلى الأعلى؛ والمئات 9 تصبح 10 فيُحمل 1 إلى الآلاف: 6 970 يصبح 7 000. الخطأ الشائع كتابة 7 100 أو 6 900.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eb9f4ee2-0390-5ee6-84e3-b308468242d5', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'عند مقارنة عددٍ مكوّنٍ من 6 أرقام بعددٍ مكوّنٍ من 5 أرقام (كلاهما طبيعيّ بلا أصفارٍ على اليسار)، فالعدد ذو الـ6 أرقام:', '[{"id":"a","text":"أكبر دائمًا"},{"id":"b","text":"قد يكون أصغر"},{"id":"c","text":"قد يتساوى معه"},{"id":"d","text":"لا يمكن الجزم"}]'::jsonb, 'a', 'أصغر عددٍ من 6 أرقام هو 100 000، وأكبر عددٍ من 5 أرقام هو 99 999. وبما أنّ 100 000 > 99 999 فإنّ كلّ عددٍ من 6 أرقام أكبر من أيّ عددٍ من 5 أرقام.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf561c79-89ef-5c68-a694-109fa8757ffe', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'كم عددًا طبيعيًّا محصورًا تمامًا بين 997 و 1 002؟', '[{"id":"a","text":"3"},{"id":"b","text":"5"},{"id":"c","text":"4"},{"id":"d","text":"6"}]'::jsonb, 'c', 'الأعداد المحصورة تمامًا بين 997 و 1 002 هي: 998، 999، 1 000، 1 001، أي 4 أعداد.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d6e81f7f-72d3-5c58-a1e5-9a5313f70749', '249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للأعداد الطبيعية', 3, 120, 30, 'boss', 'admin', 5)
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
  ('d64e0895-226f-5946-9bdf-1a5043be059b', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', 'ما العدد الطبيعيّ الذي يسبق مباشرةً العددَ 10 000؟', '[{"id":"a","text":"9 999"},{"id":"b","text":"10 001"},{"id":"c","text":"9 000"},{"id":"d","text":"1 000"}]'::jsonb, 'a', 'العدد السابق مباشرةً يساوي العددَ ناقص 1: 10 000 − 1 = 9 999.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c2342bf-efa3-5c68-8bc5-193d8a151e8a', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', 'كيف يُقرأ العدد 305 040؟', '[{"id":"a","text":"ثلاثمئة ألفٍ وخمسة آلاف وأربعون"},{"id":"b","text":"ثلاثة آلاف وخمسمئة وأربعون"},{"id":"c","text":"ثلاثمئة وخمسة آلاف وأربعون"},{"id":"d","text":"ثلاثمئة وخمسون ألفًا وأربعون"}]'::jsonb, 'c', 'نُجمّع الأرقام ثلاثيّاتٍ من اليمين: 305 آلاف | 040. والصنف 305 يُقرأ «ثلاثمئة وخمسة»، فيكون العدد «ثلاثمئة وخمسة آلاف وأربعون».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3fc2ba1a-17ca-5bf7-8645-4f7215632ce6', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', 'ما العدد الذي يساوي 3×100000 + 7×1000 + 4×10؟', '[{"id":"a","text":"370 040"},{"id":"b","text":"307 040"},{"id":"c","text":"307 400"},{"id":"d","text":"30 740"}]'::jsonb, 'b', '3×100000 = 300 000، و7×1000 = 7 000، و4×10 = 40. وبجمع القيم حسب الرتب نحصل على 307 040.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f3cbe47-adf6-5785-a7d8-86290d23de6e', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', 'ما الترتيب التنازلي للأعداد: 60 100 ؛ 6 100 ؛ 60 010 ؛ 16 000؟', '[{"id":"a","text":"6 100 > 16 000 > 60 010 > 60 100"},{"id":"b","text":"60 100 > 60 010 > 16 000 > 6 100"},{"id":"c","text":"60 010 > 60 100 > 16 000 > 6 100"},{"id":"d","text":"60 100 > 16 000 > 60 010 > 6 100"}]'::jsonb, 'b', 'العدد 6 100 وحده من 4 أرقام فهو الأصغر؛ وبين أعداد الـ5 أرقام: 60 100 > 60 010 (المئات 1 > 0) وكلاهما > 16 000 (يبدأ بـ1). الترتيب التنازلي: 60 100 > 60 010 > 16 000 > 6 100.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1adfd6db-987b-5f3d-9f50-ce0f9617e616', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', 'ما القيمة المقرّبة للعدد 149 500 إلى أقرب ألف؟', '[{"id":"a","text":"149 000"},{"id":"b","text":"149 500"},{"id":"c","text":"200 000"},{"id":"d","text":"150 000"}]'::jsonb, 'd', 'رقم المئات هو 5 (أكبر من أو يساوي 5) فنُدوّر الآلاف إلى الأعلى: 149 500 يصبح 150 000.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9283d1a-3333-521c-8f47-c45c7be98bc6', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', 'ما أكبر عددٍ طبيعيّ تكون قيمتُه المقرّبة إلى أقرب مئة مساويةً لـ 500؟', '[{"id":"a","text":"599"},{"id":"b","text":"550"},{"id":"c","text":"549"},{"id":"d","text":"500"}]'::jsonb, 'c', 'الأعداد التي تُدوّر إلى 500 (أقرب مئة) محصورة من 450 إلى 549؛ أكبرها 549، لأنّ 550 تُدوّر صعودًا إلى 600.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

