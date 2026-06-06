-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-dungeon-ar (Culture générale — Donjon multi-thèmes (AR))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-dungeon-ar/
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
  ('culture-generale-dungeon-ar', 'Culture générale — Donjon multi-thèmes (AR)', 'زنزانة الثقافة العامة حيث يأتي كل سؤال من مجال مختلف (التاريخ، الجغرافيا، السياسة، الاقتصاد، العلوم، الفنون): قفازٌ من المعارف المتنوّعة باللغة العربية.', 'Polyvalence', 'subject-math', 'Swords', 24, 'ar', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-dungeon-ar'
      AND e.source = 'admin'
      AND q.id NOT IN ('8a0e76d7-c61b-56a5-8a52-7e6b6df3c1dd', '09744018-6b11-5c36-94ec-ca3f85d672e3', '14f0c8da-ae30-5323-875e-eeffd0fd9eda', 'e4853d07-9b1c-50b7-93bf-76507d4211cf', 'e8eaa129-190c-5bed-a6fd-c5e253591d97', 'e893d8e7-87b8-5824-b9ca-961a667519b7', '5bd8f6c4-372e-5285-bf22-6b19b0cc5070', 'f3bdc84d-6179-52c4-a333-a9fedea64522', '9fc0c169-9332-5718-b198-4a6b8de58642', 'f937eb26-dc72-5451-857d-376118ca2e0d', '76224425-1e9e-5dca-8847-53b17f81721c', 'b82b3a73-b0c7-53d0-aa7a-70bd7ca6d9ce', '79b3f26a-a9ee-569c-9561-4878aaf964f1', '5d80be96-be62-54ad-959e-8501511ac78a', '70453b57-79fd-5eca-8989-37eeb7b8d511', '6da1a679-2cd2-502e-86cc-d964112b4b7c', 'fd56384a-6826-5132-9b5a-d898a4d3acf8');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-dungeon-ar' AND source = 'admin' AND id NOT IN ('445e336e-b72a-5729-bbe8-982c9d886e3c', '142ba3c9-0a43-5258-8eef-c96c83d50006', '12880674-b9a0-5488-998b-20ba1223d56b');
DELETE FROM public.questions WHERE exercise_id IN ('445e336e-b72a-5729-bbe8-982c9d886e3c', '142ba3c9-0a43-5258-8eef-c96c83d50006', '12880674-b9a0-5488-998b-20ba1223d56b') AND id NOT IN ('8a0e76d7-c61b-56a5-8a52-7e6b6df3c1dd', '09744018-6b11-5c36-94ec-ca3f85d672e3', '14f0c8da-ae30-5323-875e-eeffd0fd9eda', 'e4853d07-9b1c-50b7-93bf-76507d4211cf', 'e8eaa129-190c-5bed-a6fd-c5e253591d97', 'e893d8e7-87b8-5824-b9ca-961a667519b7', '5bd8f6c4-372e-5285-bf22-6b19b0cc5070', 'f3bdc84d-6179-52c4-a333-a9fedea64522', '9fc0c169-9332-5718-b198-4a6b8de58642', 'f937eb26-dc72-5451-857d-376118ca2e0d', '76224425-1e9e-5dca-8847-53b17f81721c', 'b82b3a73-b0c7-53d0-aa7a-70bd7ca6d9ce', '79b3f26a-a9ee-569c-9561-4878aaf964f1', '5d80be96-be62-54ad-959e-8501511ac78a', '70453b57-79fd-5eca-8989-37eeb7b8d511', '6da1a679-2cd2-502e-86cc-d964112b4b7c', 'fd56384a-6826-5132-9b5a-d898a4d3acf8');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-dungeon-ar' AND c.id NOT IN ('8ebd2693-8369-5fba-be78-bb7d818e7573') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('8ebd2693-8369-5fba-be78-bb7d818e7573', 'culture-generale-dungeon-ar', 'زنزانة متعدّدة المجالات', 'قفازٌ من الثقافة العامة: كل سؤال ينبثق من مجال مختلف — التاريخ، الجغرافيا، السياسة، الاقتصاد، العلوم، الفنون. سخّن عضلاتك، واجه الزعيم (Boss)، ثم تحدَّ النخبة (Élite).', '# ⚔️ الزنزانة متعدّدة المجالات — قفازٌ من الثقافة العامة

> 💡 «البطل الأخطر ليس من يضرب بأقوى قوّة، بل من يعرف القليل عن كل شيء.»

مرحبًا أيها المغامر. هنا لا يوجد فصلٌ هادئ حول موضوع واحد: هذه الزنزانة هي **قفازٌ من المعارف المتنوّعة**. في كل قاعة، يُفتح بابٌ مختلف — **التاريخ**، **الجغرافيا**، **السياسة**، **الاقتصاد**، **العلوم** أو **الفنون** — ولا تعرف أبدًا أيّها سيُفتح. سلاحك الوحيد: ثقافة عامة واسعة ومتينة.

## 🏰 قاعدة الزنزانة

كل معركة تربط أسئلة قادمة من **مجالات مختلفة**. قد تنتقل من تاريخ ثورةٍ إلى عاصمة، ومن رمزٍ كيميائي إلى لوحةٍ شهيرة، بلا انتقال. وهذا تحديدًا ما يصنع قيمة الثقافة العامة الحقيقية: أن تكون **متعدّد المهارات**، مستعدًّا لكل شيء.

## ⚡ الأبواب الستّة (المجالات)

| الباب | المجال | مثال على التحدّي |
|---|---|---|
| 🛡️ | التاريخ | تواريخ، أحداث، شخصيات |
| 🗺️ | الجغرافيا | عواصم، أنهار، قمم |
| 🏛️ | السياسة | مؤسّسات، منظّمات، أنظمة |
| 💰 | الاقتصاد | الناتج المحلّي، التضخّم، الاتفاقيات الكبرى |
| 🔬 | العلوم | الفيزياء، الكيمياء، الفلك |
| 🎨 | الفنون | الرسم، الموسيقى، الأدب |

## 🔮 مسار المغامر

1. **الإحماء** ⭐ — اختبار من 5 أسئلة سهلة لفتح الزنزانة (يلزم **≥ 80 %** لفتح ما يليه).
2. **الزعيم (Boss)** ⭐⭐⭐ — 6 أسئلة، **سؤال لكل مجال**، بصعوبةٍ متصاعدة (1 ← 3).
3. **النخبة (Élite)** ⭐⭐⭐⭐ — 6 أسئلة صعبة، مختلطة، للأبطال الحقيقيين.

> 🗡️ **نصيحة البطل**: أمام أيّ فخّ، استبعد أولًا الخيارات السخيفة، ثم تعقّب **الصديق المخادع** — البلد المجاور، السنة المنزاحة بدرجةٍ واحدة، الرقم القريب من الصواب.

> ⚠️ **فخٌّ كلاسيكي**: الخلط بين مدينةٍ كبيرة شهيرة وعاصمة (سيدني *ليست* عاصمة أستراليا). الشهرة ليست هي السلطة.

## 🧪 لماذا تتدرّب هنا

كل تصحيح هو **درسٌ مُصغّر**: تخرج دائمًا ومعك الإجابة الصحيحة، و*السبب*، وحقيقة أو حقيقتين إضافيتين لتنمو. حتى الخطأ يجعلك أكثر ثقافةً ممّا كنت قبل دخولك القاعة.

## 📜 الذهنية

- ابقَ **هادئًا**: غالبًا ما يُستنتج المجال المجهول بالمنطق.
- ابقَ **فضوليًّا**: دوّن ما تخطئ فيه، فهو غنيمتك في الجولة القادمة.
- ابقَ **سريعًا لكن واثقًا**: الزنزانة تكافئ الدقّة، لا التسرّع.

> 🏆 أنت الآن تعرف قواعد الزنزانة. اجتز الإحماء، اصرع الزعيم، ثم تجرّأ على تحدّي النخبة — وأثبت أنّ ثقافتك العامة لا نقطة ضعف فيها.', '# 📜 ملخّص: الزنزانة متعدّدة المجالات

- **الهدف**: قفازٌ من الثقافة العامة حيث يأتي كل سؤال من مجال مختلف.
- **المجالات الستّة**: التاريخ، الجغرافيا، السياسة، الاقتصاد، العلوم، الفنون.
- **المسار**: الإحماء (اختبار ⭐، ≥ 80 % لفتح ما يليه) ← الزعيم ⭐⭐⭐ (سؤال لكل مجال) ← النخبة ⭐⭐⭐⭐ (6 أسئلة صعبة مختلطة).
- **المنهج**: استبعاد الخيارات السخيفة، ثم رصد الصديق المخادع (البلد المجاور، السنة المنزاحة، الرقم القريب من الصواب).
- **فخٌّ متكرّر**: الخلط بين مدينةٍ شهيرة وعاصمة (مثال: سيدني ≠ عاصمة أستراليا).
- **الذهنية**: هادئ، فضولي، دقيق — كل تصحيح درسٌ مُصغّر يجعلك أكثر ثقافة.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('445e336e-b72a-5729-bbe8-982c9d886e3c', '8ebd2693-8369-5fba-be78-bb7d818e7573', 'culture-generale-dungeon-ar', 'إحماء الزنزانة ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('8a0e76d7-c61b-56a5-8a52-7e6b6df3c1dd', '445e336e-b72a-5729-bbe8-982c9d886e3c', 'في أيّ سنة وقع اقتحام سجن الباستيل، الحدث المؤسِّس للثورة الفرنسية؟', '[{"id":"a","text":"1789"},{"id":"b","text":"1799"},{"id":"c","text":"1769"},{"id":"d","text":"1815"}]'::jsonb, 'a', 'وقع اقتحام سجن الباستيل في 14 يوليو 1789، ليكون البداية الرمزية للثورة الفرنسية. للعلم: لم يصبح 14 يوليو عيدًا وطنيًّا إلّا سنة 1880. أمّا سنة 1799 فهي سنة انقلاب بونابرت (نهاية الثورة)، لا بدايتها.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('09744018-6b11-5c36-94ec-ca3f85d672e3', '445e336e-b72a-5729-bbe8-982c9d886e3c', 'ما هو الرمز الكيميائي للذهب في الجدول الدوري؟', '[{"id":"a","text":"Ag"},{"id":"b","text":"Au"},{"id":"c","text":"Or"},{"id":"d","text":"Go"}]'::jsonb, 'b', 'رمز الذهب هو Au، من أوّل حرفين من اسمه اللاتيني «aurum»؛ وعدده الذرّي 79. أمّا الفخّ «Ag» فهو رمز الفضّة (من اللاتينية «argentum»): الذهب والفضّة ينتميان إلى المجموعة 11 نفسها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14f0c8da-ae30-5323-875e-eeffd0fd9eda', '445e336e-b72a-5729-bbe8-982c9d886e3c', 'ما هي عاصمة أستراليا؟', '[{"id":"a","text":"سيدني"},{"id":"b","text":"ملبورن"},{"id":"c","text":"كانبيرا"},{"id":"d","text":"بيرث"}]'::jsonb, 'c', 'عاصمة أستراليا هي كانبيرا، التي اختيرت سنة 1908 كحلٍّ وسط بين المدينتين المتنافستين سيدني وملبورن، وبُنيت من العدم. سيدني وملبورن هما أكبر المدن، لكن لا واحدة منهما عاصمة: شهرة المدينة لا تجعلها مقرًّا للحكومة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4853d07-9b1c-50b7-93bf-76507d4211cf', '445e336e-b72a-5729-bbe8-982c9d886e3c', 'من رسم لوحة الموناليزا (La Joconde) المعروضة في متحف اللوفر؟', '[{"id":"a","text":"مايكل أنجلو"},{"id":"b","text":"رافاييل"},{"id":"c","text":"ليوناردو دافنشي"},{"id":"d","text":"بوتيتشيلي"}]'::jsonb, 'c', 'رسم الموناليزا ليوناردو دافنشي في مطلع القرن السادس عشر، بتقنية «السفوماتو» الشهيرة (تدرّج الحدود بنعومة). أمّا مايكل أنجلو، معاصره ومنافسه، فكان نحّاتًا ورسّام جداريات بالأساس (سقف كنيسة سيستينا): لم يرسم هذا البورتريه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e8eaa129-190c-5bed-a6fd-c5e253591d97', '445e336e-b72a-5729-bbe8-982c9d886e3c', 'ماذا يقيس الناتج المحلّي الإجمالي (PIB) لبلدٍ ما؟', '[{"id":"a","text":"الثروة المُنتَجة على أرض البلد خلال فترة زمنية محدّدة"},{"id":"b","text":"العدد الإجمالي لسكّان البلد"},{"id":"c","text":"مجموع الأموال التي تملكها الدولة"},{"id":"d","text":"المساحة الإجمالية للبلد"}]'::jsonb, 'a', 'يقيس الناتج المحلّي الإجمالي قيمة كل السلع والخدمات المُنتَجة على أرضٍ ما خلال فترة (غالبًا سنة)؛ ويُشير تغيّره إلى النمو الاقتصادي. وهو لا يحسب عدد السكّان ولا المساحة: بلدٌ كبير قليل الإنتاج قد يكون ناتجه أقلّ من بلدٍ صغير عالي الإنتاج.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('142ba3c9-0a43-5258-8eef-c96c83d50006', '8ebd2693-8369-5fba-be78-bb7d818e7573', 'culture-generale-dungeon-ar', '⚔️ الزنزانة — الزعيم (Boss) ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 1)
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
  ('e893d8e7-87b8-5824-b9ca-961a667519b7', '142ba3c9-0a43-5258-8eef-c96c83d50006', 'التاريخ — في أيّ سنة سقط جدار برلين، مُعلنًا نهاية انقسام ألمانيا؟', '[{"id":"a","text":"1989"},{"id":"b","text":"1991"},{"id":"c","text":"1985"},{"id":"d","text":"1961"}]'::jsonb, 'a', 'سقط جدار برلين في ليلة 9 نوفمبر 1989، بعد 28 عامًا من الفصل. للعلم: كان قد شُيِّد سنة 1961 (الفخّ «1961» هو سنة بنائه، لا سقوطه). أمّا سنة 1991 فهي سنة انحلال الاتحاد السوفيتي، وهو حدثٌ مختلف ولاحق.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5bd8f6c4-372e-5285-bf22-6b19b0cc5070', '142ba3c9-0a43-5258-8eef-c96c83d50006', 'الجغرافيا — في أيّ قارّة تقع الصحراء الكبرى، أكبر صحراء حارّة في العالم؟', '[{"id":"a","text":"آسيا"},{"id":"b","text":"أفريقيا"},{"id":"c","text":"أمريكا الجنوبية"},{"id":"d","text":"أوقيانوسيا"}]'::jsonb, 'b', 'تغطّي الصحراء الكبرى شريطًا واسعًا من شمال أفريقيا، عبر نحو عشرة بلدان. وهي أكبر صحراء حارّة في العالم (حوالي 9 ملايين كم²). أمّا الفخّ «آسيا» فيقابل صحراء غوبي: شاسعة هي الأخرى، لكنّها صحراء باردة، مختلفة عن الصحراء الكبرى.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3bdc84d-6179-52c4-a333-a9fedea64522', '142ba3c9-0a43-5258-8eef-c96c83d50006', 'السياسة — أيّ جهازٍ في منظّمة الأمم المتّحدة يتحمّل المسؤولية الأساسية عن حفظ السلم والأمن الدوليين؟', '[{"id":"a","text":"الجمعية العامة"},{"id":"b","text":"محكمة العدل الدولية"},{"id":"c","text":"مجلس الأمن"},{"id":"d","text":"الأمانة العامة"}]'::jsonb, 'c', 'مجلس الأمن هو المكلَّف بحفظ السلم؛ ويتمتّع أعضاؤه الخمسة الدائمون (الولايات المتّحدة، روسيا، الصين، فرنسا، المملكة المتّحدة) بحقّ النقض (الفيتو). أمّا الجمعية العامة فتضمّ الدول الأعضاء الـ193، لكنّ قراراتها غير مُلزِمة: هي تتداول، والمجلس يقرّر ويستطيع فرض عقوبات.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fc0c169-9332-5718-b198-4a6b8de58642', '142ba3c9-0a43-5258-8eef-c96c83d50006', 'الاقتصاد — ماذا يعني مصطلح «التضخّم» في الاقتصاد؟', '[{"id":"a","text":"ارتفاع عامّ ومستمرّ في الأسعار"},{"id":"b","text":"انخفاض عامّ في الأسعار"},{"id":"c","text":"ارتفاع في البطالة"},{"id":"d","text":"زيادة في الصادرات"}]'::jsonb, 'a', 'التضخّم هو الارتفاع العامّ والمستمرّ في الأسعار، الذي يقلّص القدرة الشرائية للنقد. يستهدف البنك المركزي الأوروبي نحو 2 % سنويًّا. أمّا الفخّ «انخفاض الأسعار» فله اسمٌ خاصّ: الانكماش، وهو الظاهرة العكسية التي تُعَدّ غالبًا خطيرة لأنّها قد تشلّ النشاط الاقتصادي.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f937eb26-dc72-5451-857d-376118ca2e0d', '142ba3c9-0a43-5258-8eef-c96c83d50006', 'العلوم — ما هي، من حيث رتبة المقدار، سرعة الضوء في الفراغ؟', '[{"id":"a","text":"حوالي 300 000 كم/ثانية"},{"id":"b","text":"حوالي 300 000 كم/ساعة"},{"id":"c","text":"حوالي 3 000 كم/ثانية"},{"id":"d","text":"حوالي 30 000 000 كم/ثانية"}]'::jsonb, 'a', 'يسير الضوء بسرعة 299 792 458 م/ثانية في الفراغ، أي حوالي 300 000 كم/ثانية — وهو ثابتٌ أساسي يُستخدَم حتى في تعريف المتر منذ سنة 1983. أمّا الفخّ «كم/ساعة» فيخطئ في الوحدة: 300 000 كم/ساعة سيكون أبطأ بمئات آلاف المرّات.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76224425-1e9e-5dca-8847-53b17f81721c', '142ba3c9-0a43-5258-8eef-c96c83d50006', 'الفنون — من أيّ بلدٍ كان فولفغانغ أماديوس موتسارت، مؤلّف أوبرا «الناي السحري»؟', '[{"id":"a","text":"ألمانيا"},{"id":"b","text":"إيطاليا"},{"id":"c","text":"النمسا"},{"id":"d","text":"فرنسا"}]'::jsonb, 'c', 'وُلد موتسارت في مدينة سالزبورغ سنة 1756، وكانت آنذاك ضمن الإمبراطورية الرومانية المقدّسة، لكنّها اليوم مدينة نمساوية؛ وهو من كبار أعلام الموسيقى الكلاسيكية الفيينية. أمّا الفخّ «ألمانيا» فمصدره اللغة الألمانية التي كان يتحدّثها: لكنّ سالزبورغ وفيينا، حيث صنع مسيرته، تقعان في النمسا، لا في ألمانيا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('12880674-b9a0-5488-998b-20ba1223d56b', '8ebd2693-8369-5fba-be78-bb7d818e7573', 'culture-generale-dungeon-ar', '👑 الزنزانة — النخبة (Élite) ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 2)
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
  ('b82b3a73-b0c7-53d0-aa7a-70bd7ca6d9ce', '12880674-b9a0-5488-998b-20ba1223d56b', 'التاريخ — في سنة 1215، فرض البارونات الإنجليز على الملك يوحنا (جون) المفتقِر إلى الأرض وثيقةً تحدّ من سلطته، وتُعَدّ خطوة كبرى نحو دولة القانون. ما هذه الوثيقة؟', '[{"id":"a","text":"الماغنا كارتا (الميثاق الأعظم)"},{"id":"b","text":"إعلان حقوق الإنسان"},{"id":"c","text":"وثيقة الحقوق الإنجليزية (Bill of Rights)"},{"id":"d","text":"قانون الإحضار (Habeas Corpus)"}]'::jsonb, 'a', 'الماغنا كارتا، المُوقَّعة سنة 1215 في رانيميد، تُخضِع الملك للقانون وتضمن للأحرار محاكمةً نظامية؛ وهي تمهيد للحريات الدستورية. أمّا الفخّان فأحدث عهدًا: قانون الإحضار (Habeas Corpus) يعود إلى سنة 1679، ووثيقة الحقوق الإنجليزية إلى سنة 1689، وكلاهما لاحقٌ بقرونٍ عدّة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79b3f26a-a9ee-569c-9561-4878aaf964f1', '12880674-b9a0-5488-998b-20ba1223d56b', 'الجغرافيا — ما هو الارتفاع التقريبي لجبل إفرست، أعلى نقطة على الأرض بالنسبة إلى مستوى سطح البحر؟', '[{"id":"a","text":"حوالي 6 500 م"},{"id":"b","text":"حوالي 7 200 م"},{"id":"c","text":"حوالي 8 849 م"},{"id":"d","text":"حوالي 9 600 م"}]'::jsonb, 'c', 'يبلغ إفرست، في سلسلة الهيمالايا، ذروته عند حوالي 8 849 م فوق مستوى سطح البحر (القياس الصيني-النيبالي لسنة 2020). للعلم: لو قِيس من قاعدته تحت الماء، لكان جبل ماونا كيا في هاواي «أعلى»، لكنّ المعيار الرسمي يبقى الارتفاع بالنسبة إلى سطح البحر، وهو ما يُتوّج إفرست.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5d80be96-be62-54ad-959e-8501511ac78a', '12880674-b9a0-5488-998b-20ba1223d56b', 'الاقتصاد — اتفاقيات بريتون وودز، المُوقَّعة سنة 1944، أنجبت مؤسّستين اقتصاديتين دوليتين كبيرتين. ما هما؟', '[{"id":"a","text":"منظّمة التجارة العالمية ومنظّمة التعاون الاقتصادي والتنمية"},{"id":"b","text":"صندوق النقد الدولي والبنك الدولي"},{"id":"c","text":"البنك المركزي الأوروبي والاحتياطي الفيدرالي"},{"id":"d","text":"منظّمة أوبك ومجموعة السبع"}]'::jsonb, 'b', 'أنشأت بريتون وودز (1944) صندوق النقد الدولي والبنك الدولي، لتثبيت العملات وتمويل إعادة الإعمار بعد الحرب. أمّا الفخّ «منظّمة التجارة العالمية» فأحدث عهدًا (1995، انبثقت من اتفاقية الغات)، وهي لا تُعنى بالنقد بل بالتجارة: دورٌ آخر وزمنٌ آخر.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70453b57-79fd-5eca-8989-37eeb7b8d511', '12880674-b9a0-5488-998b-20ba1223d56b', 'العلوم — ما هو الكوكب الأقرب إلى الشمس في المجموعة الشمسية؟', '[{"id":"a","text":"الزهرة"},{"id":"b","text":"المرّيخ"},{"id":"c","text":"عطارد"},{"id":"d","text":"الأرض"}]'::jsonb, 'c', 'عطارد هو الكوكب الأقرب إلى الشمس وأصغر كواكب المجموعة الشمسية. طُرفة: ليس هو الأكثر حرارة — بل الزهرة، إذ يحبس غلافها الجوّي السميك من ثاني أكسيد الكربون الحرارة (الاحتباس الحراري). أمّا الفخّ «الزهرة» فيخلط بين الكوكب الثاني (الأكثر حرارة) والكوكب الأوّل (الأقرب).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6da1a679-2cd2-502e-86cc-d964112b4b7c', '12880674-b9a0-5488-998b-20ba1223d56b', 'الفنون — لوحة «غيرنيكا»، العمل القويّ المناهض للحرب المستوحى من قصفٍ وقع سنة 1937، هي من إبداع أيّ رسّام؟', '[{"id":"a","text":"سلفادور دالي"},{"id":"b","text":"بابلو بيكاسو"},{"id":"c","text":"خوان ميرو"},{"id":"d","text":"فرانسيسكو غويا"}]'::jsonb, 'b', 'رسم بابلو بيكاسو لوحة «غيرنيكا» سنة 1937، ردًّا على قصف مدينة غيرنيكا في إقليم الباسك خلال الحرب الأهلية الإسبانية؛ وهي أيقونة بالرمادي والأسود للفنّ المناهض للحرب، معروضة في مدريد. أمّا الفخّ «غويا» فمنطقي (إسباني آخر اشتهر بمشاهد الحرب)، لكنّه عاش في مطلع القرن التاسع عشر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd56384a-6826-5132-9b5a-d898a4d3acf8', '12880674-b9a0-5488-998b-20ba1223d56b', 'السياسة — في أيّ سنة تأسّست منظّمة الأمم المتّحدة رسميًّا؟', '[{"id":"a","text":"1919"},{"id":"b","text":"1948"},{"id":"c","text":"1945"},{"id":"d","text":"1950"}]'::jsonb, 'c', 'تأسّست الأمم المتّحدة في 24 أكتوبر 1945، بعد مصادقة الدول المؤسِّسة الإحدى والخمسين على ميثاقها؛ وتضمّ اليوم 193 عضوًا ويقع مقرّها في نيويورك. أمّا الفخّ «1919» فهو عصبة الأمم (SDN)، المنظّمة التي سبقت الأمم المتّحدة وحلّت محلّها بعد فشلها في منع الحرب العالمية الثانية.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

