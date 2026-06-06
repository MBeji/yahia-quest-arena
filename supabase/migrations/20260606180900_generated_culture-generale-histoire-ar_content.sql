-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-histoire-ar (Culture générale — Histoire (AR))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-histoire-ar/
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
  ('culture-generale-histoire-ar', 'Culture générale — Histoire (AR)', 'أهم التواريخ والشخصيات في التاريخ العالمي والتونسي، من العصور القديمة إلى أيامنا، لبناء ثقافة تاريخية متينة.', 'Mémoire', 'subject-svt', 'Landmark', 12, 'ar', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-histoire-ar'
      AND e.source = 'admin'
      AND q.id NOT IN ('7a30a343-38e8-5854-bbad-bbfa2ccfcd88', 'f71750c0-5233-5473-a829-f00f16c5bb2c', '6296ba20-fd9c-54f1-82ca-f926c381388a', 'caddd44b-839f-5625-8b2a-70a13a6aaf25', '25a845e2-8006-5f66-9547-01e0dcba5a5c', '11260ed4-e3ad-583f-a9e8-8a887b79a3f9', '278bb21d-c7d2-57cf-b4aa-2bbcd99c98a5', 'abf737c5-cd12-5016-bee5-faad42344c75', 'c28e78f4-2b4b-5ecd-8d31-c87e5a0f3c47', '28b9b74a-cae0-54a6-8afd-b47266a998ad', '04f68ea6-0b5b-5c55-ad57-cea1d9990857', 'b9a8c7db-ef3c-5a5a-a4ff-8d37fcebc4e1', 'f6c91e7e-fd20-5fab-86f0-b3bf24684b28', 'f891134e-301e-5574-af26-7644cb0eacc9', 'a631d6d2-ab63-533e-8ff6-dd63772dee8a', '5b7b7f24-9c6b-5de7-8d4f-8b3212ae8fc4', '59117379-2e07-5c53-9379-b6f533ec5c87', 'd586466e-fb0a-5faf-90e8-e2bdc3dab0da', '9fa6df3b-cf61-501d-affb-814f8b54b798', '5b4155b3-7c5f-562d-8299-460067ce32e9', '14a7982d-c765-57bd-bc35-e07b1d77aa0e', '481ab2d0-3d3f-5b67-bcb1-c11cb622dace', 'abe1e84b-a3a2-5967-8feb-2d872ee13cb1', '0eb6d12e-103f-5d5a-a44e-a01b6d9ec8f9', '370265a5-6454-5dc9-9af2-bcdbab6830ae', 'faaf6698-6829-5c82-9941-c21f7b900b8d', '669822e4-e3e5-5b55-9853-abb9a3302df0', '3f54ef61-458d-55e5-b98d-c527fd1e750c', 'a1216f8a-e3f0-5d09-b5ac-826a3a828d7e');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-histoire-ar' AND source = 'admin' AND id NOT IN ('557404f1-ea8d-5d99-a426-c8451bc8e65f', 'dfa852f7-eb8e-5898-88f6-5caa62b95d3e', '6d662471-c6c6-520c-ac13-245814621b36', 'd2f648ef-6a28-52c7-a1e7-d117a5c91de2', '2a3822ef-f201-59d5-b602-4a64531d084e');
DELETE FROM public.questions WHERE exercise_id IN ('557404f1-ea8d-5d99-a426-c8451bc8e65f', 'dfa852f7-eb8e-5898-88f6-5caa62b95d3e', '6d662471-c6c6-520c-ac13-245814621b36', 'd2f648ef-6a28-52c7-a1e7-d117a5c91de2', '2a3822ef-f201-59d5-b602-4a64531d084e') AND id NOT IN ('7a30a343-38e8-5854-bbad-bbfa2ccfcd88', 'f71750c0-5233-5473-a829-f00f16c5bb2c', '6296ba20-fd9c-54f1-82ca-f926c381388a', 'caddd44b-839f-5625-8b2a-70a13a6aaf25', '25a845e2-8006-5f66-9547-01e0dcba5a5c', '11260ed4-e3ad-583f-a9e8-8a887b79a3f9', '278bb21d-c7d2-57cf-b4aa-2bbcd99c98a5', 'abf737c5-cd12-5016-bee5-faad42344c75', 'c28e78f4-2b4b-5ecd-8d31-c87e5a0f3c47', '28b9b74a-cae0-54a6-8afd-b47266a998ad', '04f68ea6-0b5b-5c55-ad57-cea1d9990857', 'b9a8c7db-ef3c-5a5a-a4ff-8d37fcebc4e1', 'f6c91e7e-fd20-5fab-86f0-b3bf24684b28', 'f891134e-301e-5574-af26-7644cb0eacc9', 'a631d6d2-ab63-533e-8ff6-dd63772dee8a', '5b7b7f24-9c6b-5de7-8d4f-8b3212ae8fc4', '59117379-2e07-5c53-9379-b6f533ec5c87', 'd586466e-fb0a-5faf-90e8-e2bdc3dab0da', '9fa6df3b-cf61-501d-affb-814f8b54b798', '5b4155b3-7c5f-562d-8299-460067ce32e9', '14a7982d-c765-57bd-bc35-e07b1d77aa0e', '481ab2d0-3d3f-5b67-bcb1-c11cb622dace', 'abe1e84b-a3a2-5967-8feb-2d872ee13cb1', '0eb6d12e-103f-5d5a-a44e-a01b6d9ec8f9', '370265a5-6454-5dc9-9af2-bcdbab6830ae', 'faaf6698-6829-5c82-9941-c21f7b900b8d', '669822e4-e3e5-5b55-9853-abb9a3302df0', '3f54ef61-458d-55e5-b98d-c527fd1e750c', 'a1216f8a-e3f0-5d09-b5ac-826a3a828d7e');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-histoire-ar' AND c.id NOT IN ('d20c9a31-2ef2-5273-95d8-81e32f316dbe') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('d20c9a31-2ef2-5273-95d8-81e32f316dbe', 'culture-generale-histoire-ar', 'أهم التواريخ في التاريخ', 'رحلة عبر أبرز منعطفات التاريخ العالمي والتونسي: سقوط روما، 1492، الثورة الفرنسية، الحربان العالميتان، استقلال تونس، غزو القمر وسقوط جدار برلين.', '# ⚔️ أهم التواريخ في التاريخ — خط الأبطال والإمبراطوريات الزمني

> 💡 «شعبٌ يجهل ماضيه يسير مغمض العينين. معرفة التواريخ تعني الإمساك بخريطة الزمن.»

مرحبًا بك أيها المتدرّب ساحر الزمن. هذا الباب الأوّل يفتح لك خطّ البشرية الزمني الكبير: المعارك الحاسمة، والثورات التي أطاحت بالملوك، والاكتشافات التي غيّرت العالم. كلّ تاريخ هو مفتاح. احفظها، ولن يبقى للزمن أيّ سرّ أمامك.

## 🏛️ أفول العصور القديمة (476)

طوال قرون، سيطرت **روما** على العالم المتوسّطي. لكنّ الإمبراطورية ضعفت، وانقسمت بين **الغرب** و**الشرق**.

- في سنة **476**، خلع الزعيم الجرماني **أودواكر** الإمبراطور الشابّ **رومولوس أوغستولوس**: هذه هي النهاية المتعارف عليها لـ**الإمبراطورية الرومانية الغربية**.
- يؤرّخ هذا التاريخ تقليديًّا لـ**نهاية العصور القديمة** وبداية **العصور الوسطى**.
- أمّا الإمبراطورية الرومانية **الشرقية** (بيزنطة)، فستصمد قرابة ألف سنة أخرى، إلى غاية سنة **1453**.

> 🗡️ حيلة للحفظ: 476 = سقوط روما؛ 1453 = سقوط القسطنطينية. «نهايتان» تحيطان بكامل العصور الوسطى.

## 🌍 العالم يتّسع (1492)

- في سنة **1492**، بلغ **كريستوف كولومبوس**، المموَّل من إسبانيا، جزيرة من جزر **الباهاماس** بحثًا عن طريق الهند نحو الغرب.
- ظنّ أنّه وجد آسيا: ولم يعلم قطّ أنّه وصل إلى **عالم جديد**.
- يفتح هذا التاريخ عصر **الاكتشافات الكبرى** ويؤرّخ غالبًا لبداية **الأزمنة الحديثة**.

> ⚠️ فخّ شائع: كولومبوس **لم** «يكتشف» أمريكا بالنسبة إلى البشرية جمعاء — فقد وصل إليها **الفايكنغ** نحو سنة 1000، وكانت شعوبٌ تعيش فيها منذ آلاف السنين. ما فعله عبوره أساسًا هو ربط العالمين ربطًا دائمًا.

## 🔥 الثورة الفرنسية (1789)

الحدث المؤسِّس لفرنسا الحديثة ورمزٌ كوني للحرّية.

- في **14 جويلية 1789**، اقتحم أهالي باريس **الباستيل**، وهو سجن-قلعة ملكي: بداية رمزية لـ**الثورة الفرنسية**.
- في **26 أوت 1789**، تبنّت الجمعية **إعلان حقوق الإنسان والمواطن**.
- سيصبح **14 جويلية** **العيد الوطني** الفرنسي سنة **1880**.

## 📅 خطّ المنعطفات الكبرى الزمني

| التاريخ | الحدث | ما الذي غيّره |
|---|---|---|
| **476** | سقوط روما (الغرب) | نهاية العصور القديمة |
| **1492** | بلوغ كولومبوس أمريكا | بداية الأزمنة الحديثة |
| **1789** | اقتحام الباستيل | ميلاد فرنسا الحديثة |
| **1914-1918** | الحرب العالمية الأولى | انهيار الإمبراطوريات |
| **1939-1945** | الحرب العالمية الثانية | ميلاد منظّمة الأمم المتّحدة |
| **1969** | أولى الخطوات على القمر | البشرية تغادر الأرض |
| **1989** | سقوط جدار برلين | نهاية الحرب الباردة |

## 🌐 الحربان العالميتان (1914-1945)

- انتهت **الحرب العالمية الأولى** (1914-1918) بـ**هدنة 11 نوفمبر 1918**، الموقَّعة في ريتوند.
- انتهت **الحرب العالمية الثانية** (1939-1945) في أوروبا يوم **8 ماي 1945** (استسلام ألمانيا) وفي العالم يوم **2 سبتمبر 1945** (استسلام اليابان).
- من أنقاضها وُلدت **منظّمة الأمم المتّحدة** سنة **1945**، حفاظًا على السلم.

## 🇹🇳 استقلال تونس (1956)

منعطف حاسم في تاريخنا الوطني.

- في **20 مارس 1956**، اعترفت فرنسا بـ**استقلال** تونس وألغت **معاهدة باردو** لسنة 1881 التي كانت قد أرست نظام الحماية.
- صانعه الرئيسي هو **الحبيب بورقيبة**، زعيم **الحزب الحرّ الدستوري الجديد**، الذي سيصبح أوّل رئيس للجمهورية التونسية سنة **1957**.
- صار **20 مارس** اليوم **العيد الوطني** التونسي.

## 🚀 البشرية تغزو الفضاء (1969)

- في **21 جويلية 1969** (بالتوقيت الفرنسي)، صار **نيل أرمسترونغ** أوّل إنسان يمشي على **القمر**، خلال مهمّة **أبولو 11**.
- ظلّت عبارته شهيرة: «*خطوة صغيرة للإنسان، وقفزة عملاقة للبشرية.*»
- هذا الإنجاز، الذي تابعه نحو **600 مليون** مشاهد، يمثّل ذروة **سباق الفضاء** بين الولايات المتّحدة والاتّحاد السوفياتي.

> 🏆 الباب الأوّل قد عُبر، يا ساحر الزمن! أصبحت الآن تمسك التواريخ المفتاحية للتاريخ العالمي والتونسي. في المستوى القادم تنتظرك الشخصيات الكبرى والحضارات — اشحذ ذاكرتك، فالمعركة مستمرّة.', '# 📜 ملخّص: أهم التواريخ في التاريخ

- **476**: الزعيم الجرماني أودواكر يخلع رومولوس أوغستولوس ← سقوط **الإمبراطورية الرومانية الغربية** ونهاية العصور القديمة.
- **1492**: **كريستوف كولومبوس** يبلغ أمريكا (الباهاماس) ← بداية الاكتشافات الكبرى والأزمنة الحديثة.
- **14 جويلية 1789**: **اقتحام الباستيل** ← بداية **الثورة الفرنسية**؛ ويتبعه إعلان حقوق الإنسان في 26 أوت.
- **1914-1918**: **الحرب العالمية الأولى**، انتهت بـ**هدنة 11 نوفمبر 1918** في ريتوند.
- **1939-1945**: **الحرب العالمية الثانية**؛ استسلام ألمانيا في **8 ماي 1945**، واليابان في **2 سبتمبر 1945**؛ تأسيس **منظّمة الأمم المتّحدة** سنة 1945.
- **20 مارس 1956**: **استقلال تونس**، تحقّق بفضل **الحبيب بورقيبة** والحزب الحرّ الدستوري الجديد؛ العيد الوطني التونسي.
- **21 جويلية 1969**: **نيل أرمسترونغ** (أبولو 11) أوّل إنسان على **القمر**.
- **9 نوفمبر 1989**: **سقوط جدار برلين** ← رمز نهاية **الحرب الباردة** والانقسام بين الشرق والغرب.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('557404f1-ea8d-5d99-a426-c8451bc8e65f', 'd20c9a31-2ef2-5273-95d8-81e32f316dbe', 'culture-generale-histoire-ar', 'اختبار الفهم ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('7a30a343-38e8-5854-bbad-bbfa2ccfcd88', '557404f1-ea8d-5d99-a426-c8451bc8e65f', 'ما الحدث الذي وقع في 14 جويلية 1789 ويمثّل البداية الرمزية للثورة الفرنسية؟', '[{"id":"a","text":"تتويج نابليون الأوّل"},{"id":"b","text":"اقتحام الباستيل"},{"id":"c","text":"معركة واترلو"},{"id":"d","text":"إعلان الجمهورية"}]'::jsonb, 'b', 'في 14 جويلية 1789، اقتحم أهالي باريس الباستيل، وهو سجن-قلعة كان رمزًا للحكم الملكي المطلق: هذه هي البداية الرمزية للثورة الفرنسية. وقد صار هذا التاريخ العيد الوطني الفرنسي سنة 1880. أمّا تتويج نابليون (أ) فكان سنة 1804، وواترلو (ج) سنة 1815؛ والجمهورية الأولى (د) لن تُعلن إلّا سنة 1792.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f71750c0-5233-5473-a829-f00f16c5bb2c', '557404f1-ea8d-5d99-a426-c8451bc8e65f', 'في أيّ سنة بلغ كريستوف كولومبوس القارّة الأمريكية؟', '[{"id":"a","text":"1452"},{"id":"b","text":"1789"},{"id":"c","text":"1492"},{"id":"d","text":"1519"}]'::jsonb, 'c', 'في 12 أكتوبر 1492، وصل كريستوف كولومبوس إلى جزيرة من جزر الباهاماس بحثًا عن طريق الهند نحو الغرب، فاتحًا عصر الاكتشافات الكبرى. وقد ظلّ يعتقد حتّى وفاته أنّه بلغ آسيا. أمّا سنة 1519 (د) فهي سنة انطلاق رحلة ماجلان؛ و1452 (أ) هي بالأحرى سنة ميلاد ليوناردو دافنشي.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6296ba20-fd9c-54f1-82ca-f926c381388a', '557404f1-ea8d-5d99-a426-c8451bc8e65f', 'سقوط أيّ جدار، في 9 نوفمبر 1989، يرمز إلى نهاية الحرب الباردة؟', '[{"id":"a","text":"سور هادريان"},{"id":"b","text":"سور الصين العظيم"},{"id":"c","text":"جدار برلين"},{"id":"d","text":"حائط البراق (المبكى)"}]'::jsonb, 'c', 'في 9 نوفمبر 1989، فُتح جدار برلين الذي كان يفصل منذ 1961 بين ألمانيا الشرقية الشيوعية وألمانيا الغربية: وهو رمز نهاية الحرب الباردة والانقسام بين الشرق والغرب. أمّا سور هادريان (أ) فهو تحصين روماني في بريطانيا، وسور الصين العظيم (ب) كان يحمي الصين، وحائط البراق (د) مكان مقدّس في القدس.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('caddd44b-839f-5625-8b2a-70a13a6aaf25', '557404f1-ea8d-5d99-a426-c8451bc8e65f', 'أيّ بلد نال استقلاله في 20 مارس 1956، وهو التاريخ الذي صار عيده الوطني؟', '[{"id":"a","text":"المغرب"},{"id":"b","text":"الجزائر"},{"id":"c","text":"ليبيا"},{"id":"d","text":"تونس"}]'::jsonb, 'd', 'في 20 مارس 1956، اعترفت فرنسا باستقلال تونس وألغت معاهدة باردو لسنة 1881. والحبيب بورقيبة، زعيم الحزب الحرّ الدستوري الجديد، هو صانعه الرئيسي. أمّا المغرب (أ) فقد نال استقلاله قبل بضعة أسابيع في سنة 1956 نفسها، والجزائر (ب) سنة 1962، وليبيا (ج) منذ سنة 1951.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25a845e2-8006-5f66-9547-01e0dcba5a5c', '557404f1-ea8d-5d99-a426-c8451bc8e65f', 'من كان أوّل إنسان يمشي على القمر سنة 1969؟', '[{"id":"a","text":"نيل أرمسترونغ"},{"id":"b","text":"يوري غاغارين"},{"id":"c","text":"باز ألدرين"},{"id":"d","text":"مايكل كولينز"}]'::jsonb, 'a', 'في 21 جويلية 1969 (بالتوقيت الفرنسي)، صار نيل أرمسترونغ، قائد أبولو 11، أوّل إنسان تطأ قدمه القمر. وقد لحق به باز ألدرين (ج) بعد دقائق قليلة؛ أمّا مايكل كولينز (د) فبقي في المدار داخل مركبة القيادة. وأمّا يوري غاغارين (ب) فكان أوّل إنسان في الفضاء سنة 1961، لكنّه لم يذهب قطّ إلى القمر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('dfa852f7-eb8e-5898-88f6-5caa62b95d3e', 'd20c9a31-2ef2-5273-95d8-81e32f316dbe', 'culture-generale-histoire-ar', '⭐ اختبار سريع: التاريخ', 1, 50, 10, 'practice', 'admin', 1)
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
  ('11260ed4-e3ad-583f-a9e8-8a887b79a3f9', 'dfa852f7-eb8e-5898-88f6-5caa62b95d3e', 'في أيّ سنة وقع اقتحام الباستيل؟', '[{"id":"a","text":"1789"},{"id":"b","text":"1799"},{"id":"c","text":"1689"},{"id":"d","text":"1804"}]'::jsonb, 'a', 'وقع اقتحام الباستيل في 14 جويلية 1789، وهو نقطة الانطلاق الرمزية للثورة الفرنسية. وللحفظ: صار هذا اليوم العيد الوطني الفرنسي. أمّا 1799 (ب) فهي سنة انقلاب نابليون، و1804 (د) سنة تتويجه إمبراطورًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('278bb21d-c7d2-57cf-b4aa-2bbcd99c98a5', 'dfa852f7-eb8e-5898-88f6-5caa62b95d3e', 'أيّ ملّاح، انطلق في خدمة إسبانيا، بلغ أمريكا سنة 1492؟', '[{"id":"a","text":"فاسكو دا غاما"},{"id":"b","text":"فرديناند ماجلان"},{"id":"c","text":"كريستوف كولومبوس"},{"id":"d","text":"ماركو بولو"}]'::jsonb, 'c', 'بلغ كريستوف كولومبوس، في خدمة إسبانيا، أمريكا سنة 1492 بحثًا عن طريق الهند نحو الغرب. أمّا فاسكو دا غاما (أ) فقد التفّ حول إفريقيا ليبلغ الهند سنة 1498؛ وماجلان (ب) أطلق أوّل رحلة حول العالم سنة 1519؛ وماركو بولو (د) كان رحّالة من القرن الثالث عشر قصد الصين.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('abf737c5-cd12-5016-bee5-faad42344c75', 'dfa852f7-eb8e-5898-88f6-5caa62b95d3e', 'بأيّ بلد يرتبط عيد الاستقلال في 20 مارس 1956؟', '[{"id":"a","text":"مصر"},{"id":"b","text":"تونس"},{"id":"c","text":"السنغال"},{"id":"d","text":"ليبيا"}]'::jsonb, 'b', 'نالت تونس استقلالها عن فرنسا في 20 مارس 1956، وهو تاريخ عيدها الوطني. والحبيب بورقيبة هو من كان واجهة هذا الإنجاز. أمّا ليبيا (د) فكانت مستقلّة منذ 1951، والسنغال (ج) سيستقلّ سنة 1960، ومصر (أ) كان لها وضع مختلف منذ النصف الأوّل من القرن العشرين.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c28e78f4-2b4b-5ecd-8d31-c87e5a0f3c47', 'dfa852f7-eb8e-5898-88f6-5caa62b95d3e', 'أيّ مهمّة فضائية مكّنت أوّل البشر من المشي على القمر سنة 1969؟', '[{"id":"a","text":"سبوتنيك 1"},{"id":"b","text":"فوستوك 1"},{"id":"c","text":"أبولو 11"},{"id":"d","text":"أبولو 13"}]'::jsonb, 'c', 'هي المهمّة الأمريكية أبولو 11 التي أنزلت أوّل البشر على القمر في جويلية 1969، مع نيل أرمسترونغ وباز ألدرين. أمّا سبوتنيك 1 (أ) فكان أوّل قمر صناعي (1957)، وفوستوك 1 (ب) أوّل رحلة مأهولة (غاغارين، 1961). وأبولو 13 (د) هي مهمّة سنة 1970 التي كادت تتحوّل إلى مأساة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('28b9b74a-cae0-54a6-8afd-b47266a998ad', 'dfa852f7-eb8e-5898-88f6-5caa62b95d3e', 'سقوط جدار برلين سنة 1989 يؤرّخ لنهاية أيّ فترة من التوتّرات؟', '[{"id":"a","text":"الحرب الباردة"},{"id":"b","text":"الحرب العالمية الأولى"},{"id":"c","text":"حرب المئة عام"},{"id":"d","text":"الحروب النابليونية"}]'::jsonb, 'a', 'يرمز سقوط جدار برلين (1989) إلى نهاية الحرب الباردة، وهي المواجهة الإيديولوجية بين المعسكر الغربي والمعسكر السوفياتي بعد 1945. أمّا الحرب العالمية الأولى (ب) فانتهت سنة 1918، وحرب المئة عام (ج) في القرن الخامس عشر، والحروب النابليونية (د) سنة 1815.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('04f68ea6-0b5b-5c55-ad57-cea1d9990857', 'dfa852f7-eb8e-5898-88f6-5caa62b95d3e', 'في أيّ سنة انتهت الحرب العالمية الثانية؟', '[{"id":"a","text":"1918"},{"id":"b","text":"1939"},{"id":"c","text":"1950"},{"id":"d","text":"1945"}]'::jsonb, 'd', 'انتهت الحرب العالمية الثانية سنة 1945: استسلام ألمانيا في 8 ماي، ثمّ اليابان في 2 سبتمبر. وللحفظ: أُنشئت منظّمة الأمم المتّحدة في السنة نفسها حفاظًا على السلم. أمّا 1918 (أ) فهي نهاية الحرب العالمية الأولى، و1939 (ب) بداية الحرب الثانية.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6d662471-c6c6-520c-ac13-245814621b36', 'd20c9a31-2ef2-5273-95d8-81e32f316dbe', 'culture-generale-histoire-ar', '⚔️ الزعيم ⭐⭐⭐: التاريخ', 3, 120, 30, 'boss', 'admin', 2)
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
  ('b9a8c7db-ef3c-5a5a-a4ff-8d37fcebc4e1', '6d662471-c6c6-520c-ac13-245814621b36', 'أيّ تاريخ يؤرّخ تقليديًّا لبداية الحرب العالمية الأولى؟', '[{"id":"a","text":"1914"},{"id":"b","text":"1918"},{"id":"c","text":"1939"},{"id":"d","text":"1871"}]'::jsonb, 'a', 'بدأت الحرب العالمية الأولى سنة 1914 وانتهت سنة 1918. واندلعت إثر اغتيال الأرشيدوق فرانز فرديناند في سراييفو. أمّا 1918 (ب) فهي نهايتها، و1939 (ج) بداية الحرب العالمية الثانية، و1871 (د) سنة الوحدة الألمانية.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f6c91e7e-fd20-5fab-86f0-b3bf24684b28', '6d662471-c6c6-520c-ac13-245814621b36', 'أيّ زعيم للحزب الحرّ الدستوري الجديد تفاوض على استقلال تونس وصار أوّل رئيس لها؟', '[{"id":"a","text":"جمال عبد الناصر"},{"id":"b","text":"الطاهر بن عمّار"},{"id":"c","text":"فرحات حشّاد"},{"id":"d","text":"الحبيب بورقيبة"}]'::jsonb, 'd', 'قاد الحبيب بورقيبة، مؤسّس الحزب الحرّ الدستوري الجديد، معركة الاستقلال الذي تحقّق في 20 مارس 1956، وصار أوّل رئيس للجمهورية التونسية سنة 1957. أمّا الطاهر بن عمّار (ب) فكان رئيس الحكومة الموقّع، لا زعيم الحركة. وفرحات حشّاد (ج) كان نقابيًّا اغتيل سنة 1952. وعبد الناصر (أ) كان يقود مصر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f891134e-301e-5574-af26-7644cb0eacc9', '6d662471-c6c6-520c-ac13-245814621b36', 'أيّ زعيم جرماني خلع آخر إمبراطور روماني غربي سنة 476؟', '[{"id":"a","text":"أتيلا"},{"id":"b","text":"كلوفيس"},{"id":"c","text":"أودواكر"},{"id":"d","text":"شارلمان"}]'::jsonb, 'c', 'في سنة 476، خلع الزعيم الجرماني أودواكر رومولوس أوغستولوس، مؤرّخًا لنهاية الإمبراطورية الرومانية الغربية والعصور القديمة. أمّا أتيلا (أ)، ملك الهون، فقد مات منذ سنة 453. وكلوفيس (ب)، ملك الفرنجة، وشارلمان (د)، الذي تُوّج إمبراطورًا سنة 800، شخصيتان لاحقتان من العصور الوسطى.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a631d6d2-ab63-533e-8ff6-dd63772dee8a', '6d662471-c6c6-520c-ac13-245814621b36', 'في أيّ مكان وُقّعت هدنة 11 نوفمبر 1918 التي أنهت قتال الحرب العالمية الأولى؟', '[{"id":"a","text":"في قاعة المرايا بقصر فرساي"},{"id":"b","text":"في عربة قطار، في ريتوند (غابة كومبيين)"},{"id":"c","text":"في قصر يالطا"},{"id":"d","text":"في ريمس، داخل مدرسة"}]'::jsonb, 'b', 'وُقّعت هدنة 11 نوفمبر 1918 في عربة قطار-مطعم، في فسحة ريتوند (غابة كومبيين). أمّا معاهدة فرساي (أ) فستُوقّع سنة 1919. ويالطا (ج) هي مؤتمر سنة 1945 بين الحلفاء، وريمس (د) هي مكان أوّل استسلام ألماني سنة 1945 — وهو فخّ زمني شائع.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b7b7f24-9c6b-5de7-8d4f-8b3212ae8fc4', '6d662471-c6c6-520c-ac13-245814621b36', 'أيّ نصّ أساسي، تبنّي في 26 أوت 1789، يعلن أنّ «الناس يولدون ويبقون أحرارًا متساوين في الحقوق»؟', '[{"id":"a","text":"المجلّة المدنية"},{"id":"b","text":"إعلان حقوق الإنسان والمواطن"},{"id":"c","text":"ميثاق الأمم المتّحدة"},{"id":"d","text":"مرسوم نانت"}]'::jsonb, 'b', 'إعلان حقوق الإنسان والمواطن، المتبنّى في 26 أوت 1789، يقرّر هذا المبدأ المؤسّس؛ ويبقى نصًّا مرجعيًّا لحقوق الإنسان. أمّا المجلّة المدنية (أ) فتعود إلى سنة 1804 (نابليون)، وميثاق الأمم المتّحدة (ج) إلى سنة 1945، ومرسوم نانت (د) إلى سنة 1598 (التسامح الديني) — وكلّها نصوص من حقب مختلفة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59117379-2e07-5c53-9379-b6f533ec5c87', '6d662471-c6c6-520c-ac13-245814621b36', 'تنتهي الحرب العالمية الثانية في تاريخين مختلفين في أوروبا وآسيا. أيّ تطابق هو الصحيح؟', '[{"id":"a","text":"أوروبا: 2 سبتمبر 1945؛ اليابان: 8 ماي 1945"},{"id":"b","text":"أوروبا: 8 ماي 1945؛ اليابان: 2 سبتمبر 1945"},{"id":"c","text":"أوروبا: 11 نوفمبر 1945؛ اليابان: 8 ماي 1945"},{"id":"d","text":"أوروبا: 8 ماي 1939؛ اليابان: 2 سبتمبر 1939"}]'::jsonb, 'b', 'وُقّع استسلام ألمانيا في 8 ماي 1945 (نهاية الحرب في أوروبا)، بينما جاء استسلام اليابان، بعد هيروشيما وناغازاكي، في 2 سبتمبر 1945 (النهاية العالمية للنزاع). والفخّ الشائع (أ) هو عكس التاريخين. أمّا 11 نوفمبر (ج) فيحيل إلى 1918، و1939 (د) سنة الاندلاع لا النهاية.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d2f648ef-6a28-52c7-a1e7-d117a5c91de2', 'd20c9a31-2ef2-5273-95d8-81e32f316dbe', 'culture-generale-histoire-ar', '⭐⭐ المراجعة: التاريخ', 2, 70, 15, 'practice', 'admin', 3)
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
  ('d586466e-fb0a-5faf-90e8-e2bdc3dab0da', 'd2f648ef-6a28-52c7-a1e7-d117a5c91de2', 'سقوط الإمبراطورية الرومانية الغربية سنة 476 يؤرّخ تقليديًّا لنهاية أيّ فترة تاريخية؟', '[{"id":"a","text":"عصور ما قبل التاريخ"},{"id":"b","text":"العصور القديمة"},{"id":"c","text":"الأزمنة الحديثة"},{"id":"d","text":"عصر النهضة"}]'::jsonb, 'b', 'يؤرّخ سقوط روما سنة 476 لنهاية العصور القديمة وبداية العصور الوسطى. وللحفظ: يقسّم المؤرّخون التاريخ تقليديًّا إلى عصور ما قبل التاريخ، فالعصور القديمة، فالعصور الوسطى، فالأزمنة الحديثة، ثمّ العصر المعاصر. أمّا عصر النهضة (د) والأزمنة الحديثة (ج) فلا يبدآن إلّا في القرن الخامس عشر-السادس عشر.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fa6df3b-cf61-501d-affb-814f8b54b798', 'd2f648ef-6a28-52c7-a1e7-d117a5c91de2', 'أيّ حدث من أحداث سنة 1492 يُتّخذ غالبًا بداية للأزمنة الحديثة؟', '[{"id":"a","text":"اقتحام الباستيل"},{"id":"b","text":"سقوط القسطنطينية"},{"id":"c","text":"وصول كريستوف كولومبوس إلى أمريكا"},{"id":"d","text":"تتويج شارلمان"}]'::jsonb, 'c', 'يفتح وصول كولومبوس إلى أمريكا سنة 1492 عصر الاكتشافات الكبرى، ويُتّخذ غالبًا حدًّا لبداية الأزمنة الحديثة. أمّا سقوط القسطنطينية (ب) فكان سنة 1453 (حدّ ممكن آخر)، واقتحام الباستيل (أ) سنة 1789، وتتويج شارلمان (د) سنة 800.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b4155b3-7c5f-562d-8299-460067ce32e9', 'd2f648ef-6a28-52c7-a1e7-d117a5c91de2', 'أيّ معاهدة لسنة 1881 أرست نظام الحماية الفرنسية على تونس، وأُلغيت عند الاستقلال سنة 1956؟', '[{"id":"a","text":"معاهدة فرساي"},{"id":"b","text":"معاهدة باردو"},{"id":"c","text":"معاهدة تورديسيلاس"},{"id":"d","text":"معاهدة روما"}]'::jsonb, 'b', 'معاهدة باردو، الموقّعة سنة 1881، أرست نظام الحماية الفرنسية على تونس؛ وأُلغيت عند الاستقلال في 20 مارس 1956. أمّا معاهدة فرساي (أ) فأنهت الحرب العالمية الأولى (1919)، وتورديسيلاس (ج) قسّمت العالم الجديد بين إسبانيا والبرتغال (1494)، ومعاهدة روما (د) أسّست المجموعة الاقتصادية الأوروبية (1957).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14a7982d-c765-57bd-bc35-e07b1d77aa0e', 'd2f648ef-6a28-52c7-a1e7-d117a5c91de2', 'ما العبارة الشهيرة التي قالها نيل أرمسترونغ وهو يطأ القمر بقدمه؟', '[{"id":"a","text":"«هيوستن، لدينا مشكلة.»"},{"id":"b","text":"«خطوة صغيرة للإنسان، وقفزة عملاقة للبشرية.»"},{"id":"c","text":"«الأرض زرقاء.»"},{"id":"d","text":"«جئت، رأيت، انتصرت.»"}]'::jsonb, 'b', 'في سنة 1969، قال أرمسترونغ «خطوة صغيرة للإنسان، وقفزة عملاقة للبشرية». أمّا العبارة (أ) فترتبط بمهمّة أبولو 13 (1970)؛ و«الأرض زرقاء» (ج) تُنسب إلى غاغارين سنة 1961؛ و«جئت، رأيت، انتصرت» (د) عبارة ليوليوس قيصر، لا علاقة لها بالفضاء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('481ab2d0-3d3f-5b67-bcb1-c11cb622dace', 'd2f648ef-6a28-52c7-a1e7-d117a5c91de2', 'كان جدار برلين يفصل بين كيانين سياسيين. ما هما؟', '[{"id":"a","text":"ألمانيا وفرنسا"},{"id":"b","text":"بولندا وألمانيا"},{"id":"c","text":"ألمانيا الشرقية وألمانيا الغربية"},{"id":"d","text":"الاتّحاد السوفياتي والولايات المتّحدة"}]'::jsonb, 'c', 'بُني جدار برلين سنة 1961، وكان يفصل ألمانيا الشرقية الشيوعية (جمهورية ألمانيا الديمقراطية) عن ألمانيا الغربية (جمهورية ألمانيا الاتّحادية)، في قلب الحرب الباردة. وسيفتح سقوطه سنة 1989 الطريق أمام الوحدة الألمانية سنة 1990. ولم يكن يؤرّخ لحدود بين بلدين مختلفين مثل فرنسا (أ) أو بولندا (ب).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('abe1e84b-a3a2-5967-8feb-2d872ee13cb1', 'd2f648ef-6a28-52c7-a1e7-d117a5c91de2', 'أيّ منظّمة دولية تأسّست سنة 1945 حفاظًا على السلم بعد الحرب العالمية الثانية؟', '[{"id":"a","text":"منظّمة الأمم المتّحدة"},{"id":"b","text":"عصبة الأمم"},{"id":"c","text":"الاتّحاد الأوروبي"},{"id":"d","text":"حلف شمال الأطلسي (الناتو)"}]'::jsonb, 'a', 'أُنشئت منظّمة الأمم المتّحدة سنة 1945، غداة الحرب العالمية الثانية، للحفاظ على السلم والأمن الدوليين. أمّا عصبة الأمم (ب) فقد سبقتها بعد 1918 لكنّها أخفقت في منع الحرب. وحلف الناتو (د) تحالف عسكري تأسّس سنة 1949، والاتّحاد الأوروبي (ج) بشكله الحالي يعود إلى سنة 1992.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2a3822ef-f201-59d5-b602-4a64531d084e', 'd20c9a31-2ef2-5273-95d8-81e32f316dbe', 'culture-generale-histoire-ar', '👑 تحدّي النخبة ⭐⭐⭐⭐: التاريخ', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('0eb6d12e-103f-5d5a-a44e-a01b6d9ec8f9', '2a3822ef-f201-59d5-b602-4a64531d084e', 'في أيّ سنة أنهى فتح القسطنطينية على يد العثمانيين الإمبراطورية البيزنطية (الرومانية الشرقية)؟', '[{"id":"a","text":"476"},{"id":"b","text":"1453"},{"id":"c","text":"1492"},{"id":"d","text":"1204"}]'::jsonb, 'b', 'سقطت القسطنطينية في 29 ماي 1453 أمام السلطان محمد الثاني (الفاتح)، فأنهت الإمبراطورية البيزنطية، وريثة روما في الشرق طوال قرابة ألف سنة. والفخّ الشائع هو الخلط مع 476 (أ) التي تخصّ الإمبراطورية الغربية. أمّا 1204 (د) فهي نهب المدينة على يد الصليبيين (احتلال مؤقّت)، و1492 (ج) وصول كولومبوس إلى أمريكا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('370265a5-6454-5dc9-9af2-bcdbab6830ae', '2a3822ef-f201-59d5-b602-4a64531d084e', 'أيّ نقابي تونسي، مؤسّس الاتّحاد العامّ التونسي للشغل وأحد رموز الكفاح الاستقلالي، اغتيل في 5 ديسمبر 1952؟', '[{"id":"a","text":"الطاهر بن عمّار"},{"id":"b","text":"صالح بن يوسف"},{"id":"c","text":"فرحات حشّاد"},{"id":"d","text":"المنجي سليم"}]'::jsonb, 'c', 'فرحات حشّاد، مؤسّس الاتّحاد العامّ التونسي للشغل سنة 1946 ورفيق كفاح الحزب الحرّ الدستوري الجديد، اغتيل في 5 ديسمبر 1952، فصار شهيدًا من شهداء الاستقلال. أمّا صالح بن يوسف (ب) فكان منافسًا لبورقيبة؛ والطاهر بن عمّار (أ) وقّع اتّفاق الاستقلال بصفته رئيس الحكومة؛ والمنجي سليم (د) كان دبلوماسيًّا دستوريًّا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('faaf6698-6829-5c82-9941-c21f7b900b8d', '2a3822ef-f201-59d5-b602-4a64531d084e', 'اختير 14 جويلية 1789 عيدًا وطنيًّا فرنسيًّا. لكن في أيّ سنة اتُّخذ هذا القرار رسميًّا؟', '[{"id":"a","text":"1789"},{"id":"b","text":"1804"},{"id":"c","text":"1880"},{"id":"d","text":"1918"}]'::jsonb, 'c', 'في سنة 1880، إبّان الجمهورية الثالثة، أُقرّ 14 جويلية عيدًا وطنيًّا فرنسيًّا، نسبةً إلى اقتحام الباستيل سنة 1789. والفخّ هو الإجابة بـ1789 (أ)، أي سنة الحدث نفسه لا سنة إقراره عيدًا. أمّا 1804 (ب) فهي تتويج نابليون، و1918 (د) نهاية الحرب العالمية الأولى.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('669822e4-e3e5-5b55-9853-abb9a3302df0', '2a3822ef-f201-59d5-b602-4a64531d084e', 'أوّل استسلام ألماني في الحرب العالمية الثانية، في 7 ماي 1945، أُتبع بتوقيع ثانٍ بطلب من ستالين. في أيّ مدينة جرى هذا التوقيع الأوّل؟', '[{"id":"a","text":"برلين"},{"id":"b","text":"ريمس"},{"id":"c","text":"يالطا"},{"id":"d","text":"بوتسدام"}]'::jsonb, 'b', 'وُقّع استسلام ألمانيا أوّلًا في ريمس يوم 7 ماي 1945، في مقرّ قيادة آيزنهاور؛ وطالب ستالين بتوقيع ثانٍ في برلين (كارلسهورست) ليلة 8 إلى 9 ماي، ومن هنا الاحتفال بـ8 ماي. أمّا يالطا (ج) وبوتسدام (د) فهما مؤتمران بين الحلفاء سنة 1945، لا مكانا استسلام.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f54ef61-458d-55e5-b98d-c527fd1e750c', '2a3822ef-f201-59d5-b602-4a64531d084e', 'أيّ روّاد أبولو 11 لم يمشِ على القمر، إذ بقي في المدار داخل مركبة القيادة؟', '[{"id":"a","text":"نيل أرمسترونغ"},{"id":"b","text":"يوري غاغارين"},{"id":"c","text":"باز ألدرين"},{"id":"d","text":"مايكل كولينز"}]'::jsonb, 'd', 'بقي مايكل كولينز وحده في المدار القمري على متن مركبة القيادة «كولومبيا» بينما كان أرمسترونغ وألدرين ينزلان على القمر سنة 1969. والفخّ هو ذكر غاغارين (ب)، الذي لم يشارك قطّ في أبولو 11: فقد كان أوّل إنسان في الفضاء (الاتّحاد السوفياتي، 1961). أمّا أرمسترونغ (أ) وألدرين (ج) فقد وطئا سطح القمر فعلًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1216f8a-e3f0-5d09-b5ac-826a3a828d7e', '2a3822ef-f201-59d5-b602-4a64531d084e', 'رتّب هذه الأحداث الأربعة من الأقدم إلى الأحدث: سقوط روما، سقوط القسطنطينية، اقتحام الباستيل، سقوط جدار برلين.', '[{"id":"a","text":"سقوط روما، سقوط القسطنطينية، اقتحام الباستيل، سقوط جدار برلين"},{"id":"b","text":"سقوط القسطنطينية، سقوط روما، اقتحام الباستيل، سقوط جدار برلين"},{"id":"c","text":"سقوط روما، اقتحام الباستيل، سقوط القسطنطينية، سقوط جدار برلين"},{"id":"d","text":"اقتحام الباستيل، سقوط روما، سقوط القسطنطينية، سقوط جدار برلين"}]'::jsonb, 'a', 'الترتيب الزمني هو: سقوط روما (476)، سقوط القسطنطينية (1453)، اقتحام الباستيل (1789)، سقوط جدار برلين (1989). والفخّ الشائع هو عكس سقوطي الإمبراطوريتين (ب): فروما الغربية تسقط قبل القسطنطينية بقرابة ألف سنة. أمّا الخياران (ج) و(د) فينقلان الباستيل خارج موضعه الزمني.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

