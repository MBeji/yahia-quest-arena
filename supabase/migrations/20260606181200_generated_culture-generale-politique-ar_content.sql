-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: culture-generale-politique-ar (Culture générale — Politique (AR))
-- Regenerate with: npm run content:build
-- Source of truth: content/culture-generale-politique-ar/
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
  ('culture-generale-politique-ar', 'Culture générale — Politique (AR)', 'فهم الحياة السياسية: الديمقراطية، الفصل بين السلطات، الأنظمة والمؤسسات، باللغة العربية.', 'Stratégie', 'subject-arabic', 'Scale', 18, 'ar', false, 'culture-generale', NULL)
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
      AND e.subject_id = 'culture-generale-politique-ar'
      AND e.source = 'admin'
      AND q.id NOT IN ('95a3ed1d-7e3f-50a1-99ef-76899c1e025b', '9910f999-30ef-5207-9642-b182316c67b7', '64a0fd20-f38c-5607-8c01-7b9889d9cd62', '54438053-b9da-57bf-8e2e-f7f054d60b88', 'd82edd8d-aed3-580d-9c04-56d3c02066b8', '2c465afc-6f2e-592f-9f65-b62db638eea0', 'd7adb987-63ec-5fb9-a4c0-9f28f388e676', 'f59e6a72-9048-5f70-841c-81a6dd7dc3a6', '6cfe9e42-c91c-5464-bca4-9c4bd113a8d6', '2f217d09-5d27-5fc1-8c05-738b3db0f079', '8c712910-ae70-505c-92e6-3b50f06b6080', 'ca700a94-16d7-5005-af38-4bb7c70ad8c1', 'd4eb579f-4d13-5e4b-a9d9-5aaf176cb773', '18da659d-9363-5a1e-b341-0bd7eadf7a74', 'a66957ae-4cce-5d63-a52a-8f95aded1e8d', 'f267e03e-4e80-5639-9861-4afd798b625e', '48e3713c-6097-5bfa-80f6-ced355d50693', 'b327ad99-a07c-55de-bafc-fc14e4304d3a', '44d7e48b-152e-5a68-a80e-8574db51f8cb', 'd9ea84cd-c11c-5a2c-8b9e-18fdfa3da72e', 'f04adc2d-5496-5e62-9d89-05e874b0f66a', 'd06ef9b2-1446-5264-b39b-6b82ef1f0651', 'ac3953f5-f8cc-5c80-88c2-7b1b63ad453d', '7740dad6-3c5e-571f-8bab-68e754766b51', 'bbbc6150-5653-5bfa-be85-9147405320fe', 'f6ebfa85-5b66-5342-a7d6-2d5ea6058ffe', '799e2ea6-ba99-5772-b8dd-3796896c2d7f', 'b56c057a-6e52-5ee8-9e82-f1ec9b3a4173', '6fd5ce15-7ee5-5b30-bd66-d3831787cefd');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'culture-generale-politique-ar' AND source = 'admin' AND id NOT IN ('8b1a9a7e-289a-5699-8f61-2c173778c014', 'd994b233-db51-5c35-977d-3e7bfdfa8f1b', '7d1976ca-0401-5354-86fc-7d5f56dff816', '177f084a-69fd-5891-8eac-c8d2806fb424', '460376f2-6dc0-5ac8-bdb3-292216181b57');
DELETE FROM public.questions WHERE exercise_id IN ('8b1a9a7e-289a-5699-8f61-2c173778c014', 'd994b233-db51-5c35-977d-3e7bfdfa8f1b', '7d1976ca-0401-5354-86fc-7d5f56dff816', '177f084a-69fd-5891-8eac-c8d2806fb424', '460376f2-6dc0-5ac8-bdb3-292216181b57') AND id NOT IN ('95a3ed1d-7e3f-50a1-99ef-76899c1e025b', '9910f999-30ef-5207-9642-b182316c67b7', '64a0fd20-f38c-5607-8c01-7b9889d9cd62', '54438053-b9da-57bf-8e2e-f7f054d60b88', 'd82edd8d-aed3-580d-9c04-56d3c02066b8', '2c465afc-6f2e-592f-9f65-b62db638eea0', 'd7adb987-63ec-5fb9-a4c0-9f28f388e676', 'f59e6a72-9048-5f70-841c-81a6dd7dc3a6', '6cfe9e42-c91c-5464-bca4-9c4bd113a8d6', '2f217d09-5d27-5fc1-8c05-738b3db0f079', '8c712910-ae70-505c-92e6-3b50f06b6080', 'ca700a94-16d7-5005-af38-4bb7c70ad8c1', 'd4eb579f-4d13-5e4b-a9d9-5aaf176cb773', '18da659d-9363-5a1e-b341-0bd7eadf7a74', 'a66957ae-4cce-5d63-a52a-8f95aded1e8d', 'f267e03e-4e80-5639-9861-4afd798b625e', '48e3713c-6097-5bfa-80f6-ced355d50693', 'b327ad99-a07c-55de-bafc-fc14e4304d3a', '44d7e48b-152e-5a68-a80e-8574db51f8cb', 'd9ea84cd-c11c-5a2c-8b9e-18fdfa3da72e', 'f04adc2d-5496-5e62-9d89-05e874b0f66a', 'd06ef9b2-1446-5264-b39b-6b82ef1f0651', 'ac3953f5-f8cc-5c80-88c2-7b1b63ad453d', '7740dad6-3c5e-571f-8bab-68e754766b51', 'bbbc6150-5653-5bfa-be85-9147405320fe', 'f6ebfa85-5b66-5342-a7d6-2d5ea6058ffe', '799e2ea6-ba99-5772-b8dd-3796896c2d7f', 'b56c057a-6e52-5ee8-9e82-f1ec9b3a4173', '6fd5ce15-7ee5-5b30-bd66-d3831787cefd');
DELETE FROM public.chapters c WHERE c.subject_id = 'culture-generale-politique-ar' AND c.id NOT IN ('b7b5e56f-b717-5901-8942-b4f8a026a1f2') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('b7b5e56f-b717-5901-8942-b4f8a026a1f2', 'culture-generale-politique-ar', 'المؤسسات والأنظمة السياسية', 'أسس الحياة السياسية: الديمقراطية وأصلها اللغوي، الفصل بين السلطات حسب مونتسكيو، الفرق بين النظام البرلماني والرئاسي، الملكية والجمهورية، وبعض المعالم الأساسية (الجمهورية الخامسة، الأمم المتحدة، حق الاقتراع).', '# ⚔️ المؤسسات والأنظمة — الحلبة الكبرى للسلطة

> 💡 « لكي لا يُساء استعمال السلطة، لا بدّ أن توقف السلطةُ السلطةَ بحكم ترتيب الأشياء. » — مونتسكيو

أهلاً بك أيها الاستراتيجي. هنا، السلاح ليس السيف بل **قاعدة اللعبة**: مَن يقرّر، ومَن يطبّق، ومَن يحكم. أتقِن هذه القوانين الخفية وستقرأ السياسة كما تقرأ خريطة زنزانة. تقدّم مستوى بعد مستوى.

## 🏛️ الكلمة الأولى: الديمقراطية

تأتي الكلمة من اليونانية **ديموس** (« الشعب ») + **كراتوس** (« السلطة »)؛ أي حرفياً *سلطة الشعب*. وُلدت الديمقراطية في **أثينا** في القرن الخامس قبل الميلاد، وهي تتعارض مع عائلتين أخريين من الأنظمة: **الأرستقراطية** (سلطة قلّة من الناس) و**الملكية** (سلطة فرد واحد).

في الديمقراطية، الشعب هو **صاحب السيادة**: فهو يختار حكّامه عن طريق الاقتراع. هذا هو مبدأ **السيادة الوطنية**، المنصوص عليه في المادة 3 من إعلان حقوق الإنسان والمواطن لسنة **1789**.

## ⚖️ ثالوث السلطة: مونتسكيو

في كتابه *روح القوانين* (**1748**)، نظّر الفيلسوف **مونتسكيو** لمبدأ **الفصل بين السلطات** لتفادي الاستبداد. ثلاث سلطات، وثلاثة حرّاس متمايزون:

| السلطة | الدور | مَن يمارسها (عموماً) |
|---|---|---|
| **التشريعية** | سنّ القوانين | البرلمان (مجلس منتخَب) |
| **التنفيذية** | تطبيق القوانين | رئيس الدولة / الحكومة |
| **القضائية** | الحكم وتأويل القوانين | المحاكم، قضاة مستقلّون |

> 🗡️ نصيحة البطل: فكّر بـ « **يكتب / يطبّق / يحكم** ». إذا قام شخص واحد بالثلاثة معاً، فتلك هي الديكتاتورية.

## 🛡️ برلماني مقابل رئاسي

هناك بنيتان كبيرتان للديمقراطية الحديثة:

- **النظام البرلماني**: الحكومة **مسؤولة أمام البرلمان**، الذي يمكنه إسقاطها (لائحة لوم/سحب الثقة). وغالباً ما يكون رئيس الدولة رمزياً. أمثلة: المملكة المتحدة، ألمانيا.
- **النظام الرئاسي**: الرئيس، المنتخَب من الشعب، هو في آنٍ واحد رئيس الدولة ورئيس الحكومة؛ و**لا يمكن للبرلمان إسقاطه**. المثال النموذجي: **الولايات المتحدة**.

أما **فرنسا** في الجمهورية الخامسة فتمزج بين الاثنين: ويُسمّى نظامها **شبه رئاسي**.

## 👑 ملكية أم جمهورية؟

الخط الفاصل الحقيقي يتعلّق بـ**طريقة وصول رئيس الدولة إلى السلطة**:

- **الملكية**: يصل رئيس الدولة (ملك أو ملكة) إلى العرش عن طريق **الوراثة**. وفي **الملكية الدستورية** (المملكة المتحدة، إسبانيا، اليابان) تكون صلاحياته محدودة بدستور.
- **الجمهورية**: يكون رئيس الدولة **منتخَباً** (مباشرةً أو بشكل غير مباشر) لمدة محدودة.

> ⚠️ فخّ كلاسيكي: « الملكية » لا تعني « السلطة المطلقة ». فمعظم الملكيات الحالية **دستورية** وديمقراطية تماماً.

## 🇫🇷 معالم الجمهورية الخامسة

تخضع **الجمهورية الخامسة** الفرنسية لـ**دستور 4 أكتوبر 1958**، الذي أراده **شارل ديغول**، أول رئيس لها. وإليك بعض المحطات الجديرة بالحفظ:

- **2000**: تقلّصت مدة الولاية الرئاسية من 7 إلى **5 سنوات** (*الخماسية*)، عبر استفتاء، في عهد جاك شيراك.
- **1944**: مرسوم يمنح **حق الاقتراع للنساء**؛ وكان أول تصويت لهن سنة **1945**.
- **2008**: لم يعد بإمكان الرئيس أن يتولّى أكثر من **ولايتين متتاليتين**.

## 🌍 ما وراء الحدود: الأمم المتحدة

على المستوى العالمي، تأسّست **منظمة الأمم المتحدة** سنة **1945** (وُقِّع ميثاقها في سان فرانسيسكو) على يد **51 دولة** غداة الحرب العالمية الثانية، بهدف الحفاظ على السلام. ويوجد **مقرّها** في **نيويورك**، وتضمّ اليوم **193 دولة عضواً**.

> 🏆 لقد اجتزت البوابة الأولى أيها الاستراتيجي! صرتَ الآن قادراً على تسمية السلطات الثلاث والتمييز بين الأنظمة. وفي المستوى المقبل: الأحزاب، والانتخابات، والتيارات الفكرية الكبرى. استعدّ!', '# 📜 ملخّص: المؤسسات والأنظمة السياسية

- **الديمقراطية**: من اليونانية *ديموس* (الشعب) + *كراتوس* (السلطة) ← سلطة الشعب؛ وُلدت في أثينا في القرن الخامس قبل الميلاد.
- **السيادة الوطنية**: الشعب صاحب السيادة، وهو يختار حكّامه عن طريق الاقتراع (المادة 3 من إعلان حقوق الإنسان والمواطن لسنة 1789).
- **الفصل بين السلطات** (مونتسكيو، *روح القوانين*، 1748): ثلاث سلطات متمايزة — **التشريعية** (سنّ القوانين)، **التنفيذية** (تطبيقها)، **القضائية** (الحكم).
- **النظام البرلماني**: الحكومة مسؤولة أمام البرلمان الذي يمكنه إسقاطها (المملكة المتحدة، ألمانيا).
- **النظام الرئاسي**: الرئيس هو رئيس الدولة والحكومة معاً، ولا يمكن للبرلمان إسقاطه (الولايات المتحدة)؛ أما فرنسا فهي **شبه رئاسية**.
- **الملكية مقابل الجمهورية**: رئيس دولة **وراثي** (الملكية، وغالباً دستورية) أو **منتخَب** (الجمهورية).
- **الجمهورية الخامسة**: دستور 4 أكتوبر 1958؛ الخماسية منذ 2000؛ حق اقتراع النساء في فرنسا بمرسوم سنة 1944 (أول تصويت سنة 1945).
- **الأمم المتحدة**: تأسّست سنة 1945 على يد 51 دولة، ومقرّها في نيويورك، وتضمّ 193 عضواً اليوم؛ ومهمّتها الأولى: الحفاظ على السلام.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8b1a9a7e-289a-5699-8f61-2c173778c014', 'b7b5e56f-b717-5901-8942-b4f8a026a1f2', 'culture-generale-politique-ar', 'اختبار الفهم ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('95a3ed1d-7e3f-50a1-99ef-76899c1e025b', '8b1a9a7e-289a-5699-8f61-2c173778c014', 'ماذا تعني كلمة « ديمقراطية » حرفياً، استناداً إلى أصلها اليوناني؟', '[{"id":"a","text":"سلطة الشعب"},{"id":"b","text":"سلطة فرد واحد"},{"id":"c","text":"سلطة الأكثر ثراءً"},{"id":"d","text":"سلطة العسكر"}]'::jsonb, 'a', '« الديمقراطية » تأتي من اليونانية ديموس (« الشعب ») وكراتوس (« السلطة »): أي سلطة الشعب. وقد وُلد هذا النظام في أثينا في القرن الخامس قبل الميلاد. أما « سلطة فرد واحد » فتدلّ على الملكية، و« سلطة قلّة » تدلّ على الأرستقراطية، لذلك فهذان الخياران خاطئان.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9910f999-30ef-5207-9642-b182316c67b7', '8b1a9a7e-289a-5699-8f61-2c173778c014', 'أيّ فيلسوف نظّر للفصل بين السلطات في كتاب « روح القوانين » (1748)؟', '[{"id":"a","text":"فولتير"},{"id":"b","text":"مونتسكيو"},{"id":"c","text":"روسو"},{"id":"d","text":"ديكارت"}]'::jsonb, 'b', 'مونتسكيو هو الذي ميّز، في « روح القوانين » (1748)، بين السلطات التشريعية والتنفيذية والقضائية لتفادي الاستبداد. أما روسو (« العقد الاجتماعي ») فطوّر بالأساس فكرة السيادة الشعبية، وفولتير فكرة التسامح: فليسا هما مَن نظّر لهذا الفصل، لذلك خياراهما خاطئان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('64a0fd20-f38c-5607-8c01-7b9889d9cd62', '8b1a9a7e-289a-5699-8f61-2c173778c014', 'كم عدد السلطات المتمايزة التي يحدّدها مبدأ الفصل بين السلطات؟', '[{"id":"a","text":"اثنتان"},{"id":"b","text":"أربع"},{"id":"c","text":"ثلاث"},{"id":"d","text":"خمس"}]'::jsonb, 'c', 'هناك ثلاث سلطات: التشريعية (سنّ القوانين)، والتنفيذية (تطبيقها)، والقضائية (الحكم). ويُطلَق أحياناً على الصحافة اسم « السلطة الرابعة »، لكن ذلك مجرّد صورة مجازية: فالسلطات العمومية بالمعنى الدستوري هي الثلاث الأولى فقط، لذلك « أربع » خيار خاطئ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('54438053-b9da-57bf-8e2e-f7f054d60b88', '8b1a9a7e-289a-5699-8f61-2c173778c014', 'أيّ سلطة دورها الأساسي هو التصويت على القوانين وسنّها؟', '[{"id":"a","text":"السلطة التنفيذية"},{"id":"b","text":"السلطة القضائية"},{"id":"c","text":"السلطة العسكرية"},{"id":"d","text":"السلطة التشريعية"}]'::jsonb, 'd', 'السلطة التشريعية، التي يمارسها البرلمان (مجلس منتخَب)، هي التي تصوّت على القوانين. أما التنفيذية (رئيس الدولة، الحكومة) فتطبّقها، والقضائية (المحاكم) تسهر على احترامها. والخلط بين التنفيذية والتشريعية هو الخطأ الأكثر شيوعاً.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d82edd8d-aed3-580d-9c04-56d3c02066b8', '8b1a9a7e-289a-5699-8f61-2c173778c014', 'في الجمهورية، كيف يصل رئيس الدولة إلى السلطة؟', '[{"id":"a","text":"بالوراثة، من الأب إلى الابن"},{"id":"b","text":"عن طريق الانتخاب"},{"id":"c","text":"بالقرعة مدى الحياة"},{"id":"d","text":"بانقلاب منهجي"}]'::jsonb, 'b', 'في الجمهورية، يكون رئيس الدولة منتخَباً (مباشرةً أو بشكل غير مباشر) لمدة محدودة. وهذا ما يميّزها عن الملكية، حيث يصل رئيس الدولة (ملك أو ملكة) إلى العرش بالوراثة. وكلمة « جمهورية » تأتي من اللاتينية res publica، أي « الشأن العام ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d994b233-db51-5c35-977d-3e7bfdfa8f1b', 'b7b5e56f-b717-5901-8942-b4f8a026a1f2', 'culture-generale-politique-ar', '⭐ اختبار: السياسة', 1, 50, 10, 'practice', 'admin', 1)
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
  ('2c465afc-6f2e-592f-9f65-b62db638eea0', 'd994b233-db51-5c35-977d-3e7bfdfa8f1b', 'تتألف كلمة « ديمقراطية » من كلمتين يونانيتين. ما هما؟', '[{"id":"a","text":"ديموس (الشعب) وكراتوس (السلطة)"},{"id":"b","text":"بوليس (المدينة) ونوموس (القانون)"},{"id":"c","text":"مونوس (واحد) وأركيه (الحُكم)"},{"id":"d","text":"أريستوس (الأفضل) وكراتوس (السلطة)"}]'::jsonb, 'a', 'ديمقراطية = ديموس (« الشعب ») + كراتوس (« السلطة »)، أي سلطة الشعب. أما « مونوس + أركيه » فتعطي « مونارشية/ملكية » (سلطة فرد واحد)، و« أريستوس + كراتوس » تعطي « أرستقراطية » (سلطة الأفضل / قلّة من الناس): هذه الجذور موجودة فعلاً، لكنها تكوّن أنظمة أخرى، لذلك الخياران الأخيران خاطئان.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7adb987-63ec-5fb9-a4c0-9f28f388e676', 'd994b233-db51-5c35-977d-3e7bfdfa8f1b', 'ما هو دور السلطة التنفيذية؟', '[{"id":"a","text":"التصويت على القوانين"},{"id":"b","text":"تطبيق القوانين"},{"id":"c","text":"الفصل في القضايا"},{"id":"d","text":"تحرير الصحافة"}]'::jsonb, 'b', 'السلطة التنفيذية تطبّق القوانين وتسهر على تنفيذها؛ ويجسّدها رئيس الدولة والحكومة. أما التصويت على القوانين فهو من اختصاص السلطة التشريعية، والفصل في القضايا من اختصاص السلطة القضائية. وكلمة « تنفيذية » مشتقّة من « تنفيذ »، أي وضع القانون موضع التطبيق.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f59e6a72-9048-5f70-841c-81a6dd7dc3a6', 'd994b233-db51-5c35-977d-3e7bfdfa8f1b', 'في الملكية، كيف يصل رئيس الدولة إلى السلطة عموماً؟', '[{"id":"a","text":"بالانتخاب عن طريق الاقتراع العام"},{"id":"b","text":"عبر مناظرة إدارية"},{"id":"c","text":"بالوراثة"},{"id":"d","text":"باستفتاء سنوي"}]'::jsonb, 'c', 'في الملكية، يصل الملك أو الملكة إلى العرش بالوراثة (التوريث العائلي). أما في الجمهورية فيكون رئيس الدولة منتخَباً. واليوم، معظم الملكيات « دستورية »: أي أن دستوراً يحدّ من صلاحيات الملك، لذلك خيارا الانتخاب والمناظرة خاطئان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6cfe9e42-c91c-5464-bca4-9c4bd113a8d6', 'd994b233-db51-5c35-977d-3e7bfdfa8f1b', 'أيّ بلد هو المثال النموذجي للنظام الرئاسي؟', '[{"id":"a","text":"المملكة المتحدة"},{"id":"b","text":"ألمانيا"},{"id":"c","text":"إيطاليا"},{"id":"d","text":"الولايات المتحدة"}]'::jsonb, 'd', 'الولايات المتحدة هي النموذج للنظام الرئاسي: فالرئيس هو في آنٍ واحد رئيس الدولة ورئيس الحكومة، ولا يمكن للكونغرس إسقاطه. أما المملكة المتحدة وألمانيا وإيطاليا فهي على العكس أنظمة برلمانية، تكون فيها الحكومة مسؤولة أمام البرلمان.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2f217d09-5d27-5fc1-8c05-738b3db0f079', 'd994b233-db51-5c35-977d-3e7bfdfa8f1b', 'ما هي المهمة الأولى لمنظمة الأمم المتحدة؟', '[{"id":"a","text":"حفظ السلام والأمن الدوليين"},{"id":"b","text":"تحديد سعر النفط العالمي"},{"id":"c","text":"تنظيم الألعاب الأولمبية"},{"id":"d","text":"منح جوائز نوبل"}]'::jsonb, 'a', 'تأسّست الأمم المتحدة سنة 1945 بعد الحرب العالمية الثانية، وهدفها الأول هو حفظ السلام والأمن في العالم. أما الألعاب الأولمبية فهي من اختصاص اللجنة الأولمبية الدولية، وجوائز نوبل من اختصاص مؤسسات سويدية ونرويجية: وهذه المهامّ لا علاقة لها بالأمم المتحدة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c712910-ae70-505c-92e6-3b50f06b6080', 'd994b233-db51-5c35-977d-3e7bfdfa8f1b', 'مَن هو أول رئيس للجمهورية الفرنسية الخامسة؟', '[{"id":"a","text":"جورج بومبيدو"},{"id":"b","text":"شارل ديغول"},{"id":"c","text":"فرانسوا ميتران"},{"id":"d","text":"فانسان أوريول"}]'::jsonb, 'b', 'شارل ديغول، صاحب دستور 4 أكتوبر 1958، هو أول رئيس لها. وقد خلفه جورج بومبيدو سنة 1969، وانتُخب فرانسوا ميتران سنة 1981. أما فانسان أوريول فقد كان رئيساً في عهد الجمهورية الرابعة، لا الخامسة، لذلك هذا الخيار خاطئ.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7d1976ca-0401-5354-86fc-7d5f56dff816', 'b7b5e56f-b717-5901-8942-b4f8a026a1f2', 'culture-generale-politique-ar', '⚔️ الزعيم ⭐⭐⭐ : السياسة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('ca700a94-16d7-5005-af38-4bb7c70ad8c1', '7d1976ca-0401-5354-86fc-7d5f56dff816', 'أيّ سلطة دورها الحكم وتأويل القوانين؟', '[{"id":"a","text":"السلطة القضائية"},{"id":"b","text":"السلطة التشريعية"},{"id":"c","text":"السلطة التنفيذية"},{"id":"d","text":"السلطة التأسيسية"}]'::jsonb, 'a', 'السلطة القضائية، التي يمارسها قضاة مستقلّون، تفصل في النزاعات وتؤوّل القوانين. أما « السلطة التأسيسية » فتدلّ على الجهة التي تكتب الدستور أو تراجعه: وهي فخّ لأنها تبدو صحيحة لكنها ليست من سلطات مونتسكيو الثلاث، لذلك هذا الخيار خاطئ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4eb579f-4d13-5e4b-a9d9-5aaf176cb773', '7d1976ca-0401-5354-86fc-7d5f56dff816', 'في أيّ سنة حصلت النساء على حق الاقتراع في فرنسا؟', '[{"id":"a","text":"1936"},{"id":"b","text":"1944"},{"id":"c","text":"1958"},{"id":"d","text":"1968"}]'::jsonb, 'b', 'مرسوم 21 أبريل 1944، الصادر عن الحكومة المؤقتة بقيادة الجنرال ديغول، يمنح حق الاقتراع للنساء؛ وقد صوّتن للمرة الأولى سنة 1945. وكانت فرنسا متأخرة في ذلك: فنيوزيلندا فعلتها منذ 1893. أما 1958 (الجمهورية الخامسة) و1968 (ماي 68) فهما سنتان بارزتان قريبتان وُضِعتا للتضليل، لذلك هما خياران خاطئان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18da659d-9363-5a1e-b341-0bd7eadf7a74', '7d1976ca-0401-5354-86fc-7d5f56dff816', 'في النظام البرلماني، ما هي الآلية التي تتيح للبرلمان إسقاط الحكومة؟', '[{"id":"a","text":"لائحة سحب الثقة (اللوم)"},{"id":"b","text":"الفيتو الرئاسي"},{"id":"c","text":"المسألة المسبقة"},{"id":"d","text":"الاستفتاء بمبادرة مشتركة"}]'::jsonb, 'a', 'لائحة سحب الثقة (اللوم)، التي يصوّت عليها النواب، تجبر الحكومة على الاستقالة: وهي سمة النظام البرلماني، حيث تكون السلطة التنفيذية مسؤولة أمام البرلمان. أما الفيتو فهو أداة بيد الرئيس (النظام الرئاسي)، والاستفتاء بمبادرة مشتركة يُستعمل لاقتراح قانون لا لإسقاط حكومة، لذلك هما خياران خاطئان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a66957ae-4cce-5d63-a52a-8f95aded1e8d', '7d1976ca-0401-5354-86fc-7d5f56dff816', 'ما هي المدة الحالية لولاية رئيس الجمهورية الفرنسية (الخماسية)؟', '[{"id":"a","text":"4 سنوات"},{"id":"b","text":"6 سنوات"},{"id":"c","text":"5 سنوات"},{"id":"d","text":"7 سنوات"}]'::jsonb, 'c', 'منذ استفتاء سنة 2000 (في عهد جاك شيراك)، صارت الولاية الرئاسية الفرنسية 5 سنوات: وهي الخماسية، التي طُبّقت بدءاً من 2002. وكانت في السابق 7 سنوات (السباعية): لذا فـ« 7 سنوات » هي المدة القديمة، وهي مشتِّت موضوع عمداً ليبدو معقولاً.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f267e03e-4e80-5639-9861-4afd798b625e', '7d1976ca-0401-5354-86fc-7d5f56dff816', 'كم عدد الدول التي أسّست منظمة الأمم المتحدة سنة 1945؟', '[{"id":"a","text":"27"},{"id":"b","text":"193"},{"id":"c","text":"100"},{"id":"d","text":"51"}]'::jsonb, 'd', 'تأسّست الأمم المتحدة سنة 1945 على يد 51 دولة عضواً، إثر مؤتمر سان فرانسيسكو. ولا ينبغي الخلط بينها وبين الأعضاء الحاليين البالغ عددهم 193: وهو الفخّ الكلاسيكي. أما الرقم 27 فيُحيل إلى الدول الأعضاء في الاتحاد الأوروبي — وهي منظمة أخرى، لذلك هذا الخيار خاطئ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48e3713c-6097-5bfa-80f6-ced355d50693', '7d1976ca-0401-5354-86fc-7d5f56dff816', 'أيّ مادة من إعلان حقوق الإنسان والمواطن لسنة 1789 تؤكّد أن « مبدأ كل سيادة يكمن جوهرياً في الأمة »؟', '[{"id":"a","text":"المادة الأولى"},{"id":"b","text":"المادة 3"},{"id":"c","text":"المادة 16"},{"id":"d","text":"المادة 10"}]'::jsonb, 'b', 'المادة 3 من إعلان 1789 هي التي تُرسي السيادة الوطنية: فالسلطة تنبع من الأمة لا من الملك. انتبه للفخّ: فالمادة 16، وهي شهيرة أيضاً، هي التي تشترط الفصل بين السلطات (« كل مجتمع لا يُحدَّد فيه الفصل بين السلطات لا دستور له »). أما المادة الأولى فتُعلن أن « الناس يولدون أحراراً ومتساوين ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('177f084a-69fd-5891-8eac-c8d2806fb424', 'b7b5e56f-b717-5901-8942-b4f8a026a1f2', 'culture-generale-politique-ar', '⭐⭐ مراجعة: السياسة', 2, 70, 15, 'practice', 'admin', 3)
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
  ('b327ad99-a07c-55de-bafc-fc14e4304d3a', '177f084a-69fd-5891-8eac-c8d2806fb424', '« سلطة الشعب » تتعارض، في الأنظمة الكلاسيكية، مع الأرستقراطية. فماذا تعني الأرستقراطية؟', '[{"id":"a","text":"سلطة فرد واحد"},{"id":"b","text":"سلطة قلّة من الناس"},{"id":"c","text":"سلطة القضاة"},{"id":"d","text":"سلطة الأغلبية"}]'::jsonb, 'b', 'الأرستقراطية (من اليونانية أريستوس، « الأفضل ») هي حُكم قلّة من الناس، يُفترَض أنهم الأكثر كفاءة. أما سلطة فرد واحد فهي الملكية؛ وسلطة الأغلبية فهي الديمقراطية. وهذه العائلات الثلاث من الأنظمة وصفها أرسطو منذ العصور القديمة، لذلك الخيارات الأخرى خاطئة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44d7e48b-152e-5a68-a80e-8574db51f8cb', '177f084a-69fd-5891-8eac-c8d2806fb424', 'لماذا يدافع مونتسكيو عن الفصل بين السلطات؟', '[{"id":"a","text":"لتسريع التصويت على القوانين"},{"id":"b","text":"لجعل الدولة أقلّ كلفة"},{"id":"c","text":"لمنع إساءة استعمال السلطة وضمان الحرية"},{"id":"d","text":"لمنح كل السلطات للملك"}]'::jsonb, 'c', 'يرى مونتسكيو أن « السلطة توقف السلطة »: فبإسناد الوظائف الثلاث إلى أجهزة متمايزة، نمنع الاستبداد ونحمي الحرية. وليس الهدف هو السرعة ولا الاقتصاد، ولا قطعاً تركيز السلطة بيد فرد واحد — فذلك عكس أطروحته تماماً، لذلك الخيارات الأخرى خاطئة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9ea84cd-c11c-5a2c-8b9e-18fdfa3da72e', '177f084a-69fd-5891-8eac-c8d2806fb424', 'أيّ عبارة تصف النظام البرلماني وصفاً صحيحاً؟', '[{"id":"a","text":"الحكومة مسؤولة أمام البرلمان الذي يمكنه إسقاطها"},{"id":"b","text":"لا يمكن للبرلمان أبداً إسقاط الرئيس"},{"id":"c","text":"لا وجود لأيّ مجلس منتخَب"},{"id":"d","text":"القضاة هم مَن يصوّتون على القوانين"}]'::jsonb, 'a', 'في النظام البرلماني، تستمدّ الحكومة شرعيتها من البرلمان، ويمكنه إسقاطها (لائحة سحب الثقة). أما استحالة إسقاط السلطة التنفيذية فتميّز على العكس النظام الرئاسي. والبرلمان موجود دائماً، والقضاة لا يصوّتون أبداً على القوانين، لذلك الخيارات الأخرى خاطئة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f04adc2d-5496-5e62-9d89-05e874b0f66a', '177f084a-69fd-5891-8eac-c8d2806fb424', 'المملكة المتحدة مثال على أيّ نوع من الأنظمة؟', '[{"id":"a","text":"جمهورية رئاسية"},{"id":"b","text":"ديكتاتورية عسكرية"},{"id":"c","text":"ملكية مطلقة"},{"id":"d","text":"ملكية دستورية"}]'::jsonb, 'd', 'المملكة المتحدة ملكية دستورية: ملك (رئيس دولة وراثي) دوره رمزي إلى حدّ كبير، ورئيس وزراء يحكم بدعم من البرلمان. وهي ليست ملكية مطلقة (فصلاحيات الملك محدودة بصرامة) ولا جمهورية، لأن رئيس الدولة غير منتخَب، لذلك الخيارات الأخرى خاطئة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d06ef9b2-1446-5264-b39b-6b82ef1f0651', '177f084a-69fd-5891-8eac-c8d2806fb424', 'أيّ دستور يحكم الجمهورية الفرنسية الخامسة؟', '[{"id":"a","text":"دستور 1946"},{"id":"b","text":"دستور 1958"},{"id":"c","text":"دستور 1875"},{"id":"d","text":"دستور 1791"}]'::jsonb, 'b', 'تحكم الجمهورية الخامسة دستور 4 أكتوبر 1958، الذي حمله شارل ديغول. أما دستور 1946 فقد أسّس الجمهورية الرابعة، ودستور 1791 (المنبثق عن الثورة) أقام ملكية دستورية: وهي نصوص متجاورة لكنها لأنظمة أخرى، لذلك الخيارات الأخرى خاطئة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac3953f5-f8cc-5c80-88c2-7b1b63ad453d', '177f084a-69fd-5891-8eac-c8d2806fb424', 'أين يقع مقرّ الأمم المتحدة؟', '[{"id":"a","text":"جنيف"},{"id":"b","text":"باريس"},{"id":"c","text":"نيويورك"},{"id":"d","text":"بروكسل"}]'::jsonb, 'c', 'يقع مقرّ الأمم المتحدة في نيويورك بالولايات المتحدة. وتحتضن جنيف مكتباً كبيراً للأمم المتحدة (وكذلك مؤسسات عصبة الأمم سابقاً)، لكنها ليست المقرّ؛ أما بروكسل فهي قلب الاتحاد الأوروبي وحلف الناتو، وباريس مقرّ اليونسكو، لذلك الخيارات الأخرى خاطئة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('460376f2-6dc0-5ac8-bdb3-292216181b57', 'b7b5e56f-b717-5901-8942-b4f8a026a1f2', 'culture-generale-politique-ar', '👑 تحدّي النخبة ⭐⭐⭐⭐ : السياسة', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('7740dad6-3c5e-571f-8bab-68e754766b51', '460376f2-6dc0-5ac8-bdb3-292216181b57', 'في أيّ مؤلَّف يعرض مونتسكيو نظريته في الفصل بين السلطات؟', '[{"id":"a","text":"العقد الاجتماعي"},{"id":"b","text":"روح القوانين"},{"id":"c","text":"اللوياثان"},{"id":"d","text":"الرسائل الفارسية"}]'::jsonb, 'b', 'يُعرَض الفصل بين السلطات في « روح القوانين » (1748). أما « العقد الاجتماعي » فهو لروسو، و« اللوياثان » لهوبز (الذي يدافع على العكس عن سلطة قوية)، و« الرسائل الفارسية » فهي فعلاً لمونتسكيو لكنها رواية ساخرة لا مؤلَّفه السياسي: وهو فخّ دقيق.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bbbc6150-5653-5bfa-be85-9147405320fe', '460376f2-6dc0-5ac8-bdb3-292216181b57', 'في أيّ سنة اعتُمدت الخماسية باستفتاء في فرنسا؟', '[{"id":"a","text":"1995"},{"id":"b","text":"2002"},{"id":"c","text":"2000"},{"id":"d","text":"2008"}]'::jsonb, 'c', 'أُقرّت الخماسية باستفتاء سنة 2000، في عهد جاك شيراك، وطُبّقت للمرة الأولى سنة 2002. فـ2002 هي سنة أول تطبيق (وهي الفخّ)، و2008 هي سنة المراجعة التي حدّدت الولايات بولايتين متتاليتين: وهي سنوات حقيقية، لكنها لا تطابق الاستفتاء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f6ebfa85-5b66-5342-a7d6-2d5ea6058ffe', '460376f2-6dc0-5ac8-bdb3-292216181b57', 'أيّ مادة من إعلان 1789 تنصّ على أن كل مجتمع بلا فصل بين السلطات « لا دستور له »؟', '[{"id":"a","text":"المادة 16"},{"id":"b","text":"المادة 3"},{"id":"c","text":"المادة 6"},{"id":"d","text":"المادة 17"}]'::jsonb, 'a', 'إنها المادة 16: « كل مجتمع لا تُكفَل فيه ضمانة الحقوق ولا يُحدَّد فيه الفصل بين السلطات لا دستور له. » أما المادة 3 فتتناول السيادة الوطنية، والمادة 6 القانون بوصفه « تعبيراً عن الإرادة العامة »، والمادة 17 حق الملكية.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('799e2ea6-ba99-5772-b8dd-3796896c2d7f', '460376f2-6dc0-5ac8-bdb3-292216181b57', 'فرنسا في الجمهورية الخامسة تُوصَف غالباً بأنها نظام:', '[{"id":"a","text":"رئاسي خالص"},{"id":"b","text":"برلماني خالص"},{"id":"c","text":"شبه رئاسي"},{"id":"d","text":"حُكم الجمعية"}]'::jsonb, 'c', 'تجمع الجمهورية الخامسة بين رئيس منتخَب بالاقتراع العام وحكومة مسؤولة أمام الجمعية: ويُسمّى ذلك نظاماً شبه رئاسي (أو مختلطاً). فهي ليست رئاسية « خالصة » كالولايات المتحدة (حيث لا يوجد رئيس وزراء مسؤول)، ولا نظام حُكم جمعية يهيمن فيه البرلمان على كل شيء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b56c057a-6e52-5ee8-9e82-f1ec9b3a4173', '460376f2-6dc0-5ac8-bdb3-292216181b57', 'كم عدد الدول الأعضاء في منظمة الأمم المتحدة اليوم؟', '[{"id":"a","text":"151"},{"id":"b","text":"193"},{"id":"c","text":"27"},{"id":"d","text":"200"}]'::jsonb, 'b', 'تضمّ الأمم المتحدة 193 دولة عضواً منذ انضمام جنوب السودان سنة 2011. أما الرقم 51 الأصلي (1945) والرقم 27 الخاص بالاتحاد الأوروبي فهما رقمان قريبان كثيراً ما يقع الخلط بينهما؛ ولا يوجد بالضبط 200 دولة معترَف بها في العالم، ما يجعل هذا المشتِّت مغرياً لكنه خاطئ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6fd5ce15-7ee5-5b30-bd66-d3831787cefd', '460376f2-6dc0-5ac8-bdb3-292216181b57', 'أيّ مبدأ يؤكّد أن السلطة السياسية تنبع من الشعب لا من ملك بحقّ إلهي؟', '[{"id":"a","text":"السيادة الوطنية"},{"id":"b","text":"التفريع (التبعية)"},{"id":"c","text":"العلمانية"},{"id":"d","text":"الفدرالية"}]'::jsonb, 'a', 'السيادة الوطنية (أو الشعبية) تقرّر أن السلطة تأتي من الشعب، قاطعةً مع الملكية بالحقّ الإلهي: وهي روح المادة 3 من إعلان 1789. أما التفريع (التبعية) فيخصّ توزيع الاختصاصات بين المستويات، والعلمانية تخصّ الفصل بين الدين والدولة، والفدرالية تخصّ التنظيم الترابي للسلطة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

