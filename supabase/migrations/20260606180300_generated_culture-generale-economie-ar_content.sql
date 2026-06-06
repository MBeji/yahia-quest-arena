-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-economie-ar (Culture générale — Économie (AR))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-economie-ar/
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
  ('culture-generale-economie-ar', 'Culture générale — Économie (AR)', 'المفاهيم الكبرى في الاقتصاد: الثروة، السوق، النقود والأطراف الفاعلة التي تدير العالم.', 'Richesse', 'subject-french', 'TrendingUp', 21, 'ar', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-economie-ar'
      AND e.source = 'admin'
      AND q.id NOT IN ('ace59731-b113-5d53-ad10-68524b392d1b', 'dc3955b3-5d9b-5158-b55d-b02dbdea4199', '0888172b-8378-5a49-bd91-a1f35996e131', 'a958063d-a42a-5a52-be7c-cf06e55471c2', '650a7aa3-a4d9-53ad-acfb-e4ab4399a720', '0a1ac4ef-93be-511c-b93a-55b73eb5ff85', '52c143d3-9584-5f74-8354-3b8fafdbf35f', 'ee63c874-e934-5e49-9a51-34b63a7c9162', '7bb44ad9-ee95-523d-8989-c90f49203458', 'cbb354e8-f081-55b8-bb48-01407328cfe5', '3df3cf6a-1179-53e4-907f-bf522e9d4d7b', '477e4dd4-5510-5184-8f71-fe8c0a8e9fa7', 'cd26033c-3627-5e62-b010-4e6b7d6db57d', 'aaba64c4-07b0-5591-94bc-394d959f8dc3', 'f9dd4c45-5cd4-564f-a62f-18a30f36eb2f', 'd359b1d7-03c4-5f33-a097-f49ba91ab348', '0121ece8-e62f-510c-af10-4e339705a5f2', '361bf6d2-47ad-5e11-bd4c-8ce955d8e4d6', '2c8b113d-30f2-56ad-a3fd-639be0576754', '36335568-4f22-574f-afd2-b432f4c2e684', '4f563a16-223b-54fd-aef5-91954e633903', '445c3fd8-8138-5ad3-886c-2588a03e8cd2', '6558f1ed-97b0-563b-834b-68edb67ee063', '5b029311-4595-56f7-8301-05e633d287e7', 'c0836029-8405-5a69-877b-5f602cd9fe10', 'be4cfbb2-d9cd-5bdc-b781-57b69fe901de', '60450f82-57f8-5b37-aaf2-fac829205286', '26a325c7-50d0-54d3-8569-1311cff90a0a', 'a99bdbce-0fdf-5d00-8179-4be7ef317c04');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-economie-ar' AND source = 'admin' AND id NOT IN ('6b36c043-99fe-55ce-8f95-31ee4281d584', '1bc20cb3-213c-5281-9e3e-a036e438eed4', '38e68f2a-007c-55d2-8c23-f77f2c4b07a1', '75d448c0-0324-5d0b-a02d-6150acddd8aa', 'c3440ed3-4893-5106-a04c-a3674c6143d7');
DELETE FROM public.questions WHERE exercise_id IN ('6b36c043-99fe-55ce-8f95-31ee4281d584', '1bc20cb3-213c-5281-9e3e-a036e438eed4', '38e68f2a-007c-55d2-8c23-f77f2c4b07a1', '75d448c0-0324-5d0b-a02d-6150acddd8aa', 'c3440ed3-4893-5106-a04c-a3674c6143d7') AND id NOT IN ('ace59731-b113-5d53-ad10-68524b392d1b', 'dc3955b3-5d9b-5158-b55d-b02dbdea4199', '0888172b-8378-5a49-bd91-a1f35996e131', 'a958063d-a42a-5a52-be7c-cf06e55471c2', '650a7aa3-a4d9-53ad-acfb-e4ab4399a720', '0a1ac4ef-93be-511c-b93a-55b73eb5ff85', '52c143d3-9584-5f74-8354-3b8fafdbf35f', 'ee63c874-e934-5e49-9a51-34b63a7c9162', '7bb44ad9-ee95-523d-8989-c90f49203458', 'cbb354e8-f081-55b8-bb48-01407328cfe5', '3df3cf6a-1179-53e4-907f-bf522e9d4d7b', '477e4dd4-5510-5184-8f71-fe8c0a8e9fa7', 'cd26033c-3627-5e62-b010-4e6b7d6db57d', 'aaba64c4-07b0-5591-94bc-394d959f8dc3', 'f9dd4c45-5cd4-564f-a62f-18a30f36eb2f', 'd359b1d7-03c4-5f33-a097-f49ba91ab348', '0121ece8-e62f-510c-af10-4e339705a5f2', '361bf6d2-47ad-5e11-bd4c-8ce955d8e4d6', '2c8b113d-30f2-56ad-a3fd-639be0576754', '36335568-4f22-574f-afd2-b432f4c2e684', '4f563a16-223b-54fd-aef5-91954e633903', '445c3fd8-8138-5ad3-886c-2588a03e8cd2', '6558f1ed-97b0-563b-834b-68edb67ee063', '5b029311-4595-56f7-8301-05e633d287e7', 'c0836029-8405-5a69-877b-5f602cd9fe10', 'be4cfbb2-d9cd-5bdc-b781-57b69fe901de', '60450f82-57f8-5b37-aaf2-fac829205286', '26a325c7-50d0-54d3-8569-1311cff90a0a', 'a99bdbce-0fdf-5d00-8179-4be7ef317c04');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-economie-ar' AND c.id NOT IN ('f1819ea6-a660-5883-bb86-5f89270629e5') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('f1819ea6-a660-5883-bb86-5f89270629e5', 'culture-generale-economie-ar', 'الاقتصاد: المفاهيم الأساسية', 'الثروة، الناتج المحلي الإجمالي، السوق، قانون العرض والطلب، النقود، التضخم والأطراف الاقتصادية الكبرى: صندوق الأدوات لفهم الاقتصاد.', '# ⚔️ الاقتصاد — حلبة الثروة الكبرى

> 💡 «الاقتصاد هو فنّ استخلاص أفضل ما يمكن من موارد لا تكفي الجميع أبدًا.»

مرحبًا بك أيها الاستراتيجي المتدرّب. قبل أن تغزو الأسواق، عليك أن تتقن التعويذات الأساسية: ماذا يعني أن **تُنتج**، أن **تتبادل**، أن **تُنفق**؟ يمنحك هذا الفصل صندوق الأدوات اللازم لفكّ شيفرة الأخبار الاقتصادية والتألق في الثقافة العامة.

## 🏰 ما هو الاقتصاد؟

**الاقتصاد** هو العلم الذي يدرس كيف يُنتج البشر ويتبادلون ويوزّعون ويستهلكون **السلع** (الأشياء) و**الخدمات** (المنافع) في مواجهة موارد **نادرة**. النُّدرة هي نقطة الانطلاق: حاجاتنا غير محدودة، أمّا الوقت والمال والمواد الأولية فهي محدودة. لذلك فإن كل قرار اقتصادي هو **اختيار** — ولكل اختيار كلفة.

نميّز بين نظرتين كبيرتين:

| المستوى | ما الذي يلاحظه | مثال على سؤال |
|---|---|---|
| **الاقتصاد الجزئي** | الأطراف الفردية (أسرة، مؤسسة) | «بأي سعر أبيع خبزي؟» |
| **الاقتصاد الكلّي** | اقتصاد بلد بأكمله | «هل ستنخفض البطالة هذا العام؟» |

## ⚡ الأطراف وعوامل الإنتاج

ثلاثة **أطراف اقتصادية** كبرى تُدير الآلة: **الأسر** (التي تستهلك وتعمل)، و**المؤسسات** (التي تُنتج)، و**الدولة** (التي تجبي الضرائب وتُعيد التوزيع). وللإنتاج، نجمع بين **عوامل الإنتاج**: **العمل** (الجهد البشري) و**رأس المال** (الآلات والأدوات والمباني).

> 🗡️ حيلة للحفظ: *الأسر، المؤسسات، الدولة* — الركائز الثلاث. يكفي أن تضعف واحدة حتى تهتزّ الحلبة.

## 🔮 السوق: حين يلتقي العرض بالطلب

**السوق** هو المكان (الحقيقي أو الافتراضي) الذي تُتبادل فيه سلعة أو خدمة. و**قانون العرض والطلب** هو السحر الذي يحدّد فيه الأسعار:

- عندما يتجاوز **الطلب** **العرض**، تصبح السلعة نادرة ← **يرتفع السعر**.
- عندما يتجاوز العرض الطلب، تتوفّر السلعة بكثرة ← **ينخفض السعر**.

**سعر التوازن** هو النقطة السحرية التي تتساوى عندها الكمية المعروضة مع الكمية المطلوبة: لا نقص ولا فائض. وهكذا يُعبّر السعر عن **ندرة** السلعة.

> ⚠️ فخّ شائع: الاعتقاد بأن «السعر المرتفع = اقتصاد سيّئ». السعر المرتفع غالبًا ما يشير إلى طلب قوي أو عرض نادر — إنه إشارة، وليس عقابًا.

## 🛡️ النقود والتضخم

تخدم **النقود** ثلاثة أغراض: الدفع (وسيط للتبادل)، وقياس القيمة (وحدة حساب)، والادخار (مخزن للقيمة). من دونها، لكان علينا العودة إلى **المقايضة**.

**التضخم** هو **الارتفاع العام والمستمر للأسعار**. تضخّم بنسبة 5٪ يعني أن ما كان يكلّف 100 في المتوسط أصبح يكلّف 105: مالك يفقد جزءًا من **قدرته الشرائية**. أمّا الانخفاض العام والمستمر للأسعار فيُسمّى **الانكماش** — وهو أندر، لكنه خطير.

## 🧮 قياس الثروة: الناتج المحلي الإجمالي

يقيس **الناتج المحلي الإجمالي** قيمة كل السلع والخدمات المُنتَجة داخل بلد ما خلال سنة. إنه «نتيجة» الاقتصاد الوطني.

- **الناتج المحلي الإجمالي الاسمي**: محسوب بالأسعار الجارية (يشمل التضخم).
- **الناتج المحلي الإجمالي الحقيقي**: مُصحَّح من التضخم ← يعكس الإنتاج الحقيقي.

**النمو الاقتصادي** هو زيادة الناتج المحلي الإجمالي الحقيقي من سنة إلى أخرى.

## 🧪 حُرّاس النظام الكبار

بعض الشخصيات والمؤسسات التي ينبغي معرفتها:

- نشر **آدم سميث** سنة **1776** كتاب *ثروة الأمم*، وهو شهادة ميلاد الاقتصاد الحديث ومفهوم **«اليد الخفية»** الشهير: السعي وراء المصلحة الفردية يعود بالنفع على الجميع.
- يُحدّد **البنك المركزي** (البنك المركزي الأوروبي بالنسبة إلى منطقة اليورو) **أسعار الفائدة الرئيسية** ويسهر على استقرار الأسعار.
- يُراقب **صندوق النقد الدولي**، الذي أُنشئ سنة **1944** في اتفاقيات **بريتون وودز**، استقرار النقد العالمي ويساعد البلدان المتعثرة.
- **اليورو**، المتداول على شكل أوراق وقطع نقدية منذ **1 جانفي 2002**، هو عملة منطقة اليورو.

> 🏆 لقد عبرت البوابة الأولى! أصبحت الآن قادرًا على قراءة سوق، وقياس ثروة، وتسمية حُرّاسها. الخطوة التالية: مواجهة الزعيم وإثبات أنك تتقن حلبة الثروة.', '# 📜 ملخّص: الاقتصاد — المفاهيم الأساسية

- **الاقتصاد**: علم الاختيارات في مواجهة **النُّدرة** — الإنتاج والتبادل والتوزيع واستهلاك السلع والخدمات.
- **الجزئي مقابل الكلّي**: يلاحظ الاقتصاد الجزئي الأطراف الفردية (الأسرة، المؤسسة)؛ بينما يلاحظ الاقتصاد الكلّي البلد بأكمله.
- **الأطراف الاقتصادية**: الأسر (تستهلك وتعمل)، والمؤسسات (تُنتج)، والدولة (تجبي وتُعيد التوزيع). عوامل الإنتاج: **العمل** + **رأس المال**.
- **السوق وقانون العرض والطلب**: عندما يتجاوز الطلب العرض، يرتفع السعر؛ و**سعر التوازن** يساوي بين الكمية المعروضة والكمية المطلوبة.
- **النقود**: وسيط للتبادل، ووحدة حساب، ومخزن للقيمة؛ تحلّ محلّ المقايضة.
- **التضخم**: ارتفاع عام ومستمر للأسعار ← انخفاض **القدرة الشرائية**؛ ونقيضه هو **الانكماش**.
- **الناتج المحلي الإجمالي**: قيمة إنتاج بلد خلال سنة؛ الناتج المحلي الإجمالي **الحقيقي** مُصحَّح من التضخم؛ وارتفاعه = **نمو**.
- **معالم**: آدم سميث، *ثروة الأمم* (**1776**)، «اليد الخفية»؛ **صندوق النقد الدولي** أُنشئ سنة **1944** (بريتون وودز)؛ **اليورو** متداول منذ **1 جانفي 2002**.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6b36c043-99fe-55ce-8f95-31ee4281d584', 'f1819ea6-a660-5883-bb86-5f89270629e5', 'culture-generale-economie-ar', 'اختبار الفهم ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('ace59731-b113-5d53-ad10-68524b392d1b', '6b36c043-99fe-55ce-8f95-31ee4281d584', 'ماذا يقيس الناتج المحلي الإجمالي لبلد ما؟', '[{"id":"a","text":"قيمة كل السلع والخدمات المُنتَجة داخل البلد خلال سنة"},{"id":"b","text":"المبلغ الإجمالي لمدّخرات الأسر"},{"id":"c","text":"كمية النقود المتداولة"},{"id":"d","text":"دَيْن الدولة تجاه الخارج"}]'::jsonb, 'a', 'يجمع الناتج المحلي الإجمالي قيمة كل إنتاج السلع والخدمات في بلد خلال سنة: إنه المؤشر الرئيسي لنشاطه الاقتصادي. وارتفاعه من سنة إلى أخرى يُسمّى النمو. لا يجب الخلط بينه وبين الادخار أو الدَّيْن، اللذين يقيسان أشياء أخرى مختلفة تمامًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dc3955b3-5d9b-5158-b55d-b02dbdea4199', '6b36c043-99fe-55ce-8f95-31ee4281d584', 'وفقًا لقانون العرض والطلب، ماذا يحدث عادةً عندما يرتفع الطلب على سلعة بقوة بينما يبقى العرض ثابتًا؟', '[{"id":"a","text":"يميل سعر السلعة إلى الانخفاض"},{"id":"b","text":"يميل سعر السلعة إلى الارتفاع"},{"id":"c","text":"يبقى السعر مطابقًا تمامًا"},{"id":"d","text":"تختفي السلعة نهائيًا من السوق"}]'::jsonb, 'b', 'عندما يتجاوز الطلب العرض، تصبح السلعة نادرة نسبيًا فيرتفع سعرها حتى يبلغ سعر التوازن. ويعمل السعر كإشارة على النُّدرة. وهو لا يبقى جامدًا: فتعديله هو بالضبط ما يوازن بين الكميات المعروضة والمطلوبة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0888172b-8378-5a49-bd91-a1f35996e131', '6b36c043-99fe-55ce-8f95-31ee4281d584', 'كيف يُعرَّف التضخم؟', '[{"id":"a","text":"انخفاض عدد سكان بلد ما"},{"id":"b","text":"إنشاء عملة جديدة"},{"id":"c","text":"ارتفاع عام ومستمر للأسعار"},{"id":"d","text":"زيادة الصادرات"}]'::jsonb, 'c', 'التضخم هو الارتفاع العام والمستمر لمستوى الأسعار: مالك يفقد جزءًا من قدرته الشرائية. ونقيضه، الانكماش، هو انخفاض عام للأسعار. تضخّم بنسبة 5٪ يعني أن سلّة بـ100 أصبحت تكلّف 105.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a958063d-a42a-5a52-be7c-cf06e55471c2', '6b36c043-99fe-55ce-8f95-31ee4281d584', 'أي فرع من فروع الاقتصاد يدرس سلوك طرف فردي مثل أسرة أو مؤسسة؟', '[{"id":"a","text":"الاقتصاد الكلّي"},{"id":"b","text":"الاقتصاد الجزئي"},{"id":"c","text":"الجيوسياسة"},{"id":"d","text":"المحاسبة الوطنية"}]'::jsonb, 'b', 'يدرس الاقتصاد الجزئي اختيارات الأطراف الفردية (أسرة، مؤسسة)، بينما يلاحظ الاقتصاد الكلّي اقتصاد بلد بأكمله (البطالة، النمو، التضخم). تساعد البادئة «جزئي» (الصغير) على التمييز بينهما.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('650a7aa3-a4d9-53ad-acfb-e4ab4399a720', '6b36c043-99fe-55ce-8f95-31ee4281d584', 'من بين هذه الوظائف، أيٌّ منها ليست وظيفة من وظائف النقود؟', '[{"id":"a","text":"أن تكون وسيطًا للتبادل من أجل الدفع"},{"id":"b","text":"أن تكون وحدة حساب لقياس القيمة"},{"id":"c","text":"أن تكون مخزنًا للقيمة من أجل الادخار"},{"id":"d","text":"أن تُحدّد بمفردها معدّل البطالة في البلد"}]'::jsonb, 'd', 'تؤدّي النقود ثلاث وظائف: وسيط للتبادل، ووحدة حساب، ومخزن للقيمة. أمّا معدّل البطالة فيتوقّف على سوق العمل والظرفية، لا على النقود وحدها. ومن دون النقود، لكان علينا العودة إلى المقايضة، وهي أقل عملية بكثير.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1bc20cb3-213c-5281-9e3e-a036e438eed4', 'f1819ea6-a660-5883-bb86-5f89270629e5', 'culture-generale-economie-ar', '⭐ اختبار قصير: الاقتصاد', 1, 50, 10, 'practice', 'admin', 1)
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
  ('0a1ac4ef-93be-511c-b93a-55b73eb5ff85', '1bc20cb3-213c-5281-9e3e-a036e438eed4', 'أي مفهوم أساسي يدلّ على أن الموارد محدودة بينما الحاجات غير محدودة؟', '[{"id":"a","text":"النُّدرة"},{"id":"b","text":"الوفرة"},{"id":"c","text":"المجانية"},{"id":"d","text":"التبذير"}]'::jsonb, 'a', 'النُّدرة هي نقطة انطلاق الاقتصاد: بما أن الموارد (الوقت، المال، المواد) محدودة، يجب القيام باختيارات. إنها نقيض الوفرة. وهكذا فإن لكل اختيار اقتصادي كلفة، تُسمّى كلفة الفرصة البديلة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('52c143d3-9584-5f74-8354-3b8fafdbf35f', '1bc20cb3-213c-5281-9e3e-a036e438eed4', 'أيٌّ من هذه العناصر هو خدمة وليس سلعة؟', '[{"id":"a","text":"استشارة عند الطبيب"},{"id":"b","text":"قارورة ماء"},{"id":"c","text":"هاتف محمول"},{"id":"d","text":"زوج من الأحذية"}]'::jsonb, 'a', 'الخدمة هي منفعة غير مادية (استشارة، نقل، قصّ شعر)، بينما السلعة شيء مادي يمكن تخزينه. لذلك فإن الاستشارة الطبية خدمة؛ أمّا الثلاثة الأخرى فهي سلع.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee63c874-e934-5e49-9a51-34b63a7c9162', '1bc20cb3-213c-5281-9e3e-a036e438eed4', 'ما هي الأطراف الاقتصادية الثلاثة الكبرى في بلد ما؟', '[{"id":"a","text":"البنوك والمصانع والمتاجر"},{"id":"b","text":"المشترون والبائعون والسيّاح"},{"id":"c","text":"الأسر والمؤسسات والدولة"},{"id":"d","text":"الأغنياء والفقراء والطبقة الوسطى"}]'::jsonb, 'c', 'الأطراف الاقتصادية الثلاثة الأساسية هي الأسر (التي تستهلك وتعمل)، والمؤسسات (التي تُنتج)، والدولة (التي تجبي الضرائب وتُعيد التوزيع). أمّا البنوك والمتاجر فهي أنواع من المؤسسات، وليست صنفًا مستقلًّا من الأطراف.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7bb44ad9-ee95-523d-8989-c90f49203458', '1bc20cb3-213c-5281-9e3e-a036e438eed4', 'ما الفائدة الأساسية من النقود في الاقتصاد؟', '[{"id":"a","text":"تزيين المحافظ"},{"id":"b","text":"تعويض العمل تعويضًا كاملًا"},{"id":"c","text":"تسهيل التبادل وقياس القيمة"},{"id":"d","text":"تحديد حالة طقس الأسواق"}]'::jsonb, 'c', 'تُسهّل النقود التبادل (وسيط)، وتقيس القيمة (وحدة حساب)، وتتيح الادخار (مخزن للقيمة). من دونها، لكان علينا اللجوء إلى المقايضة، وهي أكثر إرهاقًا لأنها تتطلّب توافقًا مزدوجًا للحاجات.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbb354e8-f081-55b8-bb48-01407328cfe5', '1bc20cb3-213c-5281-9e3e-a036e438eed4', 'ماذا نسمّي زيادة الإنتاج (الناتج المحلي الإجمالي الحقيقي) لبلد ما من سنة إلى أخرى؟', '[{"id":"a","text":"التضخم"},{"id":"b","text":"النمو الاقتصادي"},{"id":"c","text":"الركود"},{"id":"d","text":"البطالة"}]'::jsonb, 'b', 'النمو الاقتصادي هو ارتفاع الناتج المحلي الإجمالي الحقيقي من سنة إلى أخرى. لا يجب الخلط بينه وبين التضخم (ارتفاع الأسعار) ولا الركود، الذي هو على العكس تراجع للنشاط. وعندما ينخفض الناتج المحلي الإجمالي بشكل مستمر، نتحدث عن الركود.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3df3cf6a-1179-53e4-907f-bf522e9d4d7b', '1bc20cb3-213c-5281-9e3e-a036e438eed4', 'في السوق، ماذا نسمّي السعر الذي تتساوى عنده الكمية المعروضة مع الكمية المطلوبة؟', '[{"id":"a","text":"سعر التكلفة"},{"id":"b","text":"سعر الجملة"},{"id":"c","text":"سعر التوازن"},{"id":"d","text":"السعر الفاخر"}]'::jsonb, 'c', 'سعر التوازن هو السعر الذي يلتقي عنده العرض مع الطلب تمامًا: لا نقص ولا فائض. إنه نقطة تقاطع المنحنيين. أمّا سعر التكلفة فهو ما يكلّفه تصنيع منتج، وهو مفهوم مختلف.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('38e68f2a-007c-55d2-8c23-f77f2c4b07a1', 'f1819ea6-a660-5883-bb86-5f89270629e5', 'culture-generale-economie-ar', '⚔️ الزعيم ⭐⭐⭐: الاقتصاد', 3, 120, 30, 'boss', 'admin', 2)
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
  ('477e4dd4-5510-5184-8f71-fe8c0a8e9fa7', '38e68f2a-007c-55d2-8c23-f77f2c4b07a1', 'أيٌّ من هذه الأزواج يشكّل عاملَي الإنتاج الأساسيين؟', '[{"id":"a","text":"العمل ورأس المال"},{"id":"b","text":"العرض والطلب"},{"id":"c","text":"الضريبة والدعم"},{"id":"d","text":"الادخار والدَّيْن"}]'::jsonb, 'a', 'يجمع الإنتاج بين عاملين: العمل (الجهد البشري) ورأس المال (الآلات والأدوات والمباني). أمّا العرض والطلب فيصفان آلية عمل السوق، لا وسائل الإنتاج. ويضيف بعض الاقتصاديين الأرض كعامل ثالث.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd26033c-3627-5e62-b010-4e6b7d6db57d', '38e68f2a-007c-55d2-8c23-f77f2c4b07a1', 'أيّ فيلسوف اسكتلندي يُعدّ أب الاقتصاد الحديث بفضل كتابه ثروة الأمم الصادر سنة 1776؟', '[{"id":"a","text":"كارل ماركس"},{"id":"b","text":"جون ماينارد كينز"},{"id":"c","text":"ديفيد ريكاردو"},{"id":"d","text":"آدم سميث"}]'::jsonb, 'd', 'نشر آدم سميث كتاب ثروة الأمم سنة 1776، وهو شهادة ميلاد الاقتصاد الحديث ومفهوم «اليد الخفية». أمّا ماركس (القرن التاسع عشر) وكينز (القرن العشرون) فجاءا لاحقًا؛ وريكاردو، معاصر سميث، نظّر أساسًا للميزة النسبية، ولم يؤسّس العلم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aaba64c4-07b0-5591-94bc-394d959f8dc3', '38e68f2a-007c-55d2-8c23-f77f2c4b07a1', 'ما الفرق الجوهري بين الناتج المحلي الإجمالي الاسمي والناتج المحلي الإجمالي الحقيقي؟', '[{"id":"a","text":"الناتج الحقيقي يشمل التضخم، والناتج الاسمي يستبعده"},{"id":"b","text":"الناتج الحقيقي مُصحَّح من التضخم، والناتج الاسمي محسوب بالأسعار الجارية"},{"id":"c","text":"الناتج الاسمي يخصّ الخدمات فقط"},{"id":"d","text":"الناتج الحقيقي يقيس الصادرات فقط"}]'::jsonb, 'b', 'الناتج المحلي الإجمالي الاسمي محسوب بالأسعار الجارية ويتضخّم مع التضخم؛ أمّا الناتج الحقيقي فمُصحَّح من التضخم، لذلك يعكس الإنتاج الحقيقي. والناتج الحقيقي هو ما نتابعه للحكم على النمو. الخيار «a» يعكس المفهومين تمامًا: هذا هو الفخّ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9dd4c45-5cd4-564f-a62f-18a30f36eb2f', '38e68f2a-007c-55d2-8c23-f77f2c4b07a1', 'سنة 1944، أنجبت اتفاقيات بريتون وودز مؤسسة مكلّفة بالسهر على استقرار النظام النقدي الدولي. أيّ مؤسسة؟', '[{"id":"a","text":"منظمة التجارة العالمية"},{"id":"b","text":"منظمة الأمم المتحدة"},{"id":"c","text":"البنك المركزي الأوروبي"},{"id":"d","text":"صندوق النقد الدولي"}]'::jsonb, 'd', 'وُلد صندوق النقد الدولي في جويلية 1944 في مؤتمر بريتون وودز لتثبيت النظام النقدي بعد الحرب ومساعدة البلدان المتعثرة. أمّا منظمة التجارة العالمية فتعود إلى 1995، والبنك المركزي الأوروبي إلى 1998 (منطقة اليورو)، ومنظمة الأمم المتحدة، التي تأسّست سنة 1945، ليس لها دور نقدي خاص.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d359b1d7-03c4-5f33-a097-f49ba91ab348', '38e68f2a-007c-55d2-8c23-f77f2c4b07a1', 'يشهد اقتصاد تضخمًا بنسبة 10٪ خلال السنة. ماذا يحدث للقدرة الشرائية لمبلغ 100 محفوظ تحت الوسادة، بالقيمة الحقيقية؟', '[{"id":"a","text":"تزيد، لأن الأسعار ترتفع"},{"id":"b","text":"تنخفض: الـ100 تشتري سلعًا أقل من قبل"},{"id":"c","text":"تبقى مطابقة تمامًا"},{"id":"d","text":"تتضاعف تلقائيًا"}]'::jsonb, 'b', 'مع تضخّم بنسبة 10٪، ما كان يكلّف 100 أصبح يكلّف 110: لذلك فإن الـ100 نفسها تشتري سلعًا أقل، فتنخفض قدرتها الشرائية. والفخّ الشائع هو الاعتقاد بأن ارتفاع الأسعار يُثري من يملكون السيولة النقدية: العكس صحيح، فالتضخم يُآكِل المدّخرات غير المستثمرة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0121ece8-e62f-510c-af10-4e339705a5f2', '38e68f2a-007c-55d2-8c23-f77f2c4b07a1', 'في سوق تنافسية، يتضاعف فجأة عرض منتج بينما يبقى الطلب على حاله. ما الأثر الأرجح على سعر التوازن؟', '[{"id":"a","text":"ينخفض سعر التوازن"},{"id":"b","text":"يرتفع سعر التوازن"},{"id":"c","text":"يتضاعف سعر التوازن"},{"id":"d","text":"يختفي السوق فورًا"}]'::jsonb, 'a', 'عندما يزيد العرض دون أن يتبعه الطلب، يصبح المنتج وفيرًا نسبيًا فينخفض سعر التوازن لتصريف الكميات. والفخّ هو الاعتقاد بأن مضاعفة العرض تضاعف السعر: الكمية المعروضة والسعر يتحرّكان في اتجاهين متعاكسين، لا في الاتجاه نفسه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('75d448c0-0324-5d0b-a02d-6150acddd8aa', 'f1819ea6-a660-5883-bb86-5f89270629e5', 'culture-generale-economie-ar', '⭐⭐ مراجعة: الاقتصاد', 2, 70, 15, 'practice', 'admin', 3)
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
  ('361bf6d2-47ad-5e11-bd4c-8ce955d8e4d6', '75d448c0-0324-5d0b-a02d-6150acddd8aa', 'ماذا نسمّي الانخفاض العام والمستمر للأسعار، وهو الظاهرة المعاكسة للتضخم؟', '[{"id":"a","text":"الانكماش"},{"id":"b","text":"الركود التضخمي"},{"id":"c","text":"تخفيض قيمة العملة"},{"id":"d","text":"الركود"}]'::jsonb, 'a', 'الانكماش هو الانخفاض العام والمستمر للأسعار: لا يجب الخلط بينه وبين الركود (تراجع النشاط) ولا تخفيض قيمة العملة (خفض إرادي لقيمة عملة). ويُخشى الانكماش لأنه يدفع إلى تأجيل المشتريات، ما يُبطئ الاقتصاد.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2c8b113d-30f2-56ad-a3fd-639be0576754', '75d448c0-0324-5d0b-a02d-6150acddd8aa', 'أيّ مستوى من التحليل الاقتصادي يدرس المجاميع الكبرى لبلد ما مثل الناتج المحلي الإجمالي والبطالة والتضخم؟', '[{"id":"a","text":"الاقتصاد الجزئي"},{"id":"b","text":"تسيير المؤسسات"},{"id":"c","text":"التسويق"},{"id":"d","text":"الاقتصاد الكلّي"}]'::jsonb, 'd', 'يدرس الاقتصاد الكلّي اقتصاد بلد في شموليته من خلال مجاميعه الكبرى (الناتج المحلي الإجمالي، البطالة، التضخم). أمّا الاقتصاد الجزئي فيركّز على اختيارات طرف فردي. وتشير البادئة «كلّي» (الكبير) إلى أننا نفكّر على مستوى الأمة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36335568-4f22-574f-afd2-b432f4c2e684', '75d448c0-0324-5d0b-a02d-6150acddd8aa', 'أيّ عبارة لآدم سميث تدلّ على فكرة أن السعي وراء المصلحة الفردية قد يعود بالنفع على المجتمع بأكمله؟', '[{"id":"a","text":"التدمير الخلّاق"},{"id":"b","text":"صراع الطبقات"},{"id":"c","text":"اليد الخفية"},{"id":"d","text":"المضاعِف الكينزي"}]'::jsonb, 'c', 'تصف «اليد الخفية» لآدم سميث كيف تُسهم الأفعال الفردية الموجَّهة بالمصلحة الشخصية في الصالح العام عبر السوق. أمّا التدمير الخلّاق فهو لشومبيتر، وصراع الطبقات لماركس، والمضاعِف لكينز: مؤلّفون وأفكار مختلفة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f563a16-223b-54fd-aef5-91954e633903', '75d448c0-0324-5d0b-a02d-6150acddd8aa', 'أيّ مؤسسة مكلّفة بتحديد أسعار الفائدة الرئيسية والسهر على استقرار الأسعار في منطقة اليورو؟', '[{"id":"a","text":"البنك المركزي الأوروبي"},{"id":"b","text":"المفوضية الأوروبية"},{"id":"c","text":"البرلمان الأوروبي"},{"id":"d","text":"صندوق النقد الدولي"}]'::jsonb, 'a', 'يقود البنك المركزي الأوروبي السياسة النقدية لمنطقة اليورو: فهو يحدّد أسعار الفائدة الرئيسية للتحكّم في التضخم والحفاظ على استقرار الأسعار. أمّا المفوضية والبرلمان فلهما أدوار سياسية وتشريعية، وصندوق النقد الدولي يعمل على المستوى العالمي، لا في منطقة اليورو وحدها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('445c3fd8-8138-5ad3-886c-2588a03e8cd2', '75d448c0-0324-5d0b-a02d-6150acddd8aa', 'منذ متى تتداول أوراق اليورو وقطعه النقدية فعليًا في جيوب مواطني منطقة اليورو؟', '[{"id":"a","text":"منذ 1 جانفي 1999"},{"id":"b","text":"منذ 1 جانفي 2002"},{"id":"c","text":"منذ 1 جانفي 1995"},{"id":"d","text":"منذ 1 جانفي 2010"}]'::jsonb, 'b', 'وُضعت أوراق اليورو وقطعه النقدية في التداول في 1 جانفي 2002. وكان اليورو موجودًا أصلًا منذ 1 جانفي 1999، لكن كعملة «غير مرئية» فقط (مدفوعات إلكترونية ومحاسبية): هذا هو الفخّ بين إنشاء العملة ووصول السيولة النقدية.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6558f1ed-97b0-563b-834b-68edb67ee063', '75d448c0-0324-5d0b-a02d-6150acddd8aa', 'تشهد مؤسسة ارتفاعًا قويًا في سعر موادها الأولية فتعكس هذه الكلفة على أسعار بيعها. إلى أيّ آلية تضخّم يتوافق ذلك؟', '[{"id":"a","text":"التضخم بفعل الطلب"},{"id":"b","text":"التضخم بفعل الكلفة"},{"id":"c","text":"الانكماش المستورَد"},{"id":"d","text":"تباطؤ التضخم"}]'::jsonb, 'b', 'عندما يدفع ارتفاع كلفة الإنتاج (المواد الأولية، الأجور) المؤسسات إلى رفع أسعارها، نتحدث عن التضخم بفعل الكلفة. أمّا التضخم بفعل الطلب فينشأ من طلب يفوق العرض. وتباطؤ التضخم هو مجرد تراجع لوتيرة التضخم، وليس سببًا له.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c3440ed3-4893-5106-a04c-a3674c6143d7', 'f1819ea6-a660-5883-bb86-5f89270629e5', 'culture-generale-economie-ar', '👑 تحدّي النخبة ⭐⭐⭐⭐: الاقتصاد', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('5b029311-4595-56f7-8301-05e633d287e7', 'c3440ed3-4893-5106-a04c-a3674c6143d7', 'يُقال إن الناتج المحلي الإجمالي لا يقيس كل شيء. أيٌّ من هذه الأنشطة لا يُحتسب في الناتج المحلي الإجمالي الرسمي لبلد ما؟', '[{"id":"a","text":"الأجر المدفوع لطاهٍ في مطعم"},{"id":"b","text":"العمل المنزلي غير المأجور المُنجَز في البيت"},{"id":"c","text":"بناء طريق من قِبل مؤسسة"},{"id":"d","text":"بيع تذاكر القطار"}]'::jsonb, 'b', 'لا يحتسب الناتج المحلي الإجمالي إلا الإنتاج الذي يُفضي إلى تبادل سوقي أو قابل للقياس؛ أمّا العمل المنزلي غير المأجور (التنظيف، رعاية الأطفال في البيت) فهو مستبعَد منه. وهذا أحد أبرز حدود الناتج المحلي الإجمالي، وغالبًا ما يُذكر. أمّا الأنشطة الثلاثة الأخرى فهي مأجورة وبالتالي محتسَبة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c0836029-8405-5a69-877b-5f602cd9fe10', 'c3440ed3-4893-5106-a04c-a3674c6143d7', 'يريد بنك مركزي مكافحة تضخّم يُعتبر مرتفعًا أكثر من اللازم. أيّ إجراء يكون الأكثر انسجامًا مع هذا الهدف؟', '[{"id":"a","text":"رفع أسعار الفائدة الرئيسية لكبح القروض والطلب"},{"id":"b","text":"خفض أسعار الفائدة الرئيسية لتشجيع الاقتراض"},{"id":"c","text":"توزيع النقود مجانًا على الأسر"},{"id":"d","text":"منع الادخار"}]'::jsonb, 'a', 'لتهدئة التضخم، يرفع البنك المركزي أسعار الفائدة الرئيسية: فيصبح القرض أغلى، ويتباطأ الطلب، ويخفّ الضغط على الأسعار. والفخّ هو الاعتقاد بوجوب خفض الأسعار: فهذا على العكس يُنعش الطلب وبالتالي التضخم. أمّا توزيع النقود فيزيد الأمر سوءًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be4cfbb2-d9cd-5bdc-b781-57b69fe901de', 'c3440ed3-4893-5106-a04c-a3674c6143d7', 'ماذا نسمّي القيمة التي نتخلّى عنها حين نختار خيارًا بدلًا من آخر، لعدم توفّر الموارد للقيام بكل شيء؟', '[{"id":"a","text":"الكلفة الحدّية"},{"id":"b","text":"كلفة الفرصة البديلة"},{"id":"c","text":"الكلفة الثابتة"},{"id":"d","text":"سعر التكلفة"}]'::jsonb, 'b', 'كلفة الفرصة البديلة هي قيمة أفضل خيار نتخلّى عنه: أن تدرس في أمسية، يعني أن تتخلّى عن الخروج المقابل لها. أمّا الكلفة الحدّية فهي كلفة وحدة إضافية مُنتَجة، والكلفة الثابتة لا تتوقّف على الكمية، وسعر التكلفة هو الكلفة الإجمالية للتصنيع.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('60450f82-57f8-5b37-aaf2-fac829205286', 'c3440ed3-4893-5106-a04c-a3674c6143d7', 'يُسجّل بلد فصلين متتاليين من انخفاض ناتجه المحلي الإجمالي الحقيقي. أيّ مصطلح اقتصادي يصف هذه الوضعية على أفضل وجه؟', '[{"id":"a","text":"توسّع"},{"id":"b","text":"ركود"},{"id":"c","text":"تضخم جامح"},{"id":"d","text":"إنعاش مالي"}]'::jsonb, 'b', 'تعريف شائع للركود هو تراجع الناتج المحلي الإجمالي الحقيقي على مدى فصلين متتاليين. أمّا التوسّع فهو النقيض (نمو مستدام). والتضخم يخصّ الأسعار، لا الإنتاج، والإنعاش المالي سياسة تنتهجها الدولة، وليس حالة للاقتصاد: هذه هي الفخاخ التي ينبغي تجنّبها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26a325c7-50d0-54d3-8569-1311cff90a0a', 'c3440ed3-4893-5106-a04c-a3674c6143d7', 'في سوق منافسة تامة وكاملة، أيٌّ من هذه الشروط مطلوب؟', '[{"id":"a","text":"بائع وحيد يتحكّم في كامل السوق"},{"id":"b","text":"المشترون لا يعرفون الأسعار المعمول بها"},{"id":"c","text":"المنتجات المتبادَلة متجانسة والبائعون كثيرون جدًّا"},{"id":"d","text":"الدولة تحدّد بنفسها كل الأسعار"}]'::jsonb, 'c', 'تفترض المنافسة التامة والكاملة منتجات متجانسة، وبائعين ومشترين كثيرين، ومعلومات تامة عن الأسعار، وحرية الدخول إلى السوق. أمّا البائع الوحيد فيقابل احتكارًا (الخيار a)، وغموض الأسعار (b) أو الأسعار التي تحدّدها الدولة (d) يتعارضان بالضبط مع هذا النموذج.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a99bdbce-0fdf-5d00-8179-4be7ef317c04', 'c3440ed3-4893-5106-a04c-a3674c6143d7', 'في عبارة «الأطراف الاقتصادية مترابطة عبر تدفّقات»، إلامَ يتوافق التدفّق الذي يذهب من الأسر نحو المؤسسات مقابل أجر؟', '[{"id":"a","text":"عامل العمل"},{"id":"b","text":"عامل رأس المال"},{"id":"c","text":"الضرائب"},{"id":"d","text":"أرباح الأسهم"}]'::jsonb, 'a', 'تقدّم الأسر عملها للمؤسسات وتتلقّى في المقابل أجرًا: هذا هو عامل العمل. أمّا رأس المال فيدلّ على الآلات والأدوات، والضرائب تذهب نحو الدولة، وأرباح الأسهم تكافئ المساهمين، لا العمل المقدَّم. والتمييز بين هذه التدفّقات هو مفتاح الدورة الاقتصادية.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

