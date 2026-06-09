-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: eveil-scientifique-6eme (Éveil scientifique)
-- Regenerate with: npm run content:build
-- Source of truth: content/eveil-scientifique-6eme/
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
  ('eveil-scientifique-6eme', 'Éveil scientifique', 'اكتشافُ عالَم العلوم: الهواء والتنفّس والدم والتغذية والوسط البيئي والمغانط، وفق برنامج الإيقاظ العلمي للسنة السادسة من التعليم الأساسي', 'Observation', 'subject-svt', 'Microscope', 2, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '6eme-base'))
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
      AND e.subject_id = 'eveil-scientifique-6eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('22b1784b-cfc3-514b-9c28-f09f47b66944', '647cbfbc-b8e2-5b40-bba6-22e3c136e4cd', '5d2c2a2f-85de-50da-8e69-e418201c807b', '25148e63-2f62-5534-92f4-be9d4d5c8ce0', 'ab2c7b9c-0468-5dec-b731-4762c3bdfbcb', '82dcbdab-16a7-5df9-9cb7-f4cddb7cb0e1', 'e06a976d-142d-556b-811c-49bc1cadae23', 'c0061061-4c17-5e75-ab76-75793f41e464', 'b76bf2e4-e2a0-597d-a05a-6be2a216e4a2', '139e4b74-06da-5979-8395-f9497d98cb71', '8f9da4f4-5811-5f01-a30b-10d394173566', '23ba0a44-a33b-5cc0-b56c-0ed407c81516', 'faff4440-78e7-5010-b17d-3a2b46830f88', '8dff7eee-11c3-5ba3-98bc-ff8f02ead6db', 'f683b638-cc3c-5a55-a388-82ba940e7b29', '9b17c77a-462b-5ecb-b45a-8efe0e8e6c45', 'e8e67b32-c3ac-5bd8-a988-3f58829e1ad7', 'cb6656de-0f96-5120-bd27-cfe3d371dd65', 'fabdd1ed-2731-53e9-b46b-e7848bcca742', '6e1b2b61-5df0-58d5-847f-b84878fde7c9', '477d8191-370c-54f3-b72b-9c11054d1edd', '85e563a0-fd0f-5fd4-b229-fa1ffbdb5912', '642b9384-a3b7-5657-b727-de2b8817ce7b', '7ff2e5f0-a0d5-545e-aa4f-e6a68802bbc0', '2127e544-e2ff-5603-9d28-3dc492666a99', '353627f0-2068-5961-8f0a-4cb97333879c', '07d3d011-b650-5bc8-b293-607d11bcffff', '74666f2c-e6d6-5769-8c5d-2d0294955edc', 'd6709280-b3d8-5a2c-99f1-84ca6e159405', 'ef8fe2ed-827e-5bc2-9690-1f6133188c6d', 'e11a043e-95e0-593f-80b3-913cc03f1b0e', '09fd283e-06cc-5e66-a3de-3999e365a953', '08ff61cc-7013-5d02-a8df-34f4ea0d8559', '13349f24-ec96-5949-86bb-3971f68b5d2e', '1f6d5b40-df86-50b9-8d0b-5fbf6e753273', 'daf8a4c2-099a-5dbc-8de1-39c4e7fd305a', '9e96e371-8cfb-5e45-88b8-b335cfd4ddc8', 'bccab6fe-9303-559a-90c7-3b76e3aedc39', '1bf295eb-9a58-5cae-879c-2df38cdbba36', '7bd45187-54c3-5296-bcb5-bafb7c24bbe4', 'a9118ad3-48fd-54b7-8a88-74254fdcdb7a', '02b7493d-0a90-51b9-ab4d-2c6062fb8b2b', 'e1c04794-5255-56a7-8877-0c5575d985c7', '9fcadfa1-c422-577a-a63f-ac6e8515f591', '159c036b-42bc-56a3-aaf8-969b97f1496f', '0d03b54c-9422-51dc-85ff-7d37a59ac103', '6214cf7a-e549-588d-8cbb-b406af16aff0', 'abc98ba8-9d5c-5498-acc1-f743901e7879', '5a559640-7cd6-5fe1-ae7e-81f1de11de8e', '67b14cb9-a119-57db-8eba-706116074617', 'f7f33503-b459-5d27-adc8-d84ddd9cff08', 'dd185a0c-5964-5921-89c5-6efda6cc9cd4', 'd8a54c40-6502-5056-bf69-f383bc3a676a', 'd7655934-9e62-5a01-a5ed-22de92ae59cb', '0993075f-f19b-509e-825f-0ed08c7fd454', '18063625-8d57-5ff3-928c-639e90c4fa14', '6a967509-b002-58fc-b16d-d5ffd9242d63', '608c5491-da95-5c7d-893e-750d1b7b6f9d', '1f99edab-6543-54c6-ac7b-77f9f4a1d8c7', 'c03e30e1-b023-51fb-a85a-c0398441f94c', '386d67af-7e63-5a6a-8a0c-e2509a41a81b', '39959081-838f-544e-bc60-b45818a9f0ce', 'b93f158a-23c1-5475-9070-bd3f7855aaa8', 'f3cd1045-3d9f-55ce-9308-aa21205f383b', '76e167cd-8d4e-5be5-85ef-6fc2c010ef91', '25767b39-8d52-50ae-84b5-430398ee5bf3', 'dcd9b827-88b9-54d0-8744-f6a7c258031c', '1cc0ee4d-cb5d-5c0c-bcf1-95ef5f970df4', '4bb77781-f351-5501-9e6d-237773298888', '6dd95402-0204-5cd8-9f51-681b9577b53d', '57e35d02-c3b4-57d0-a79d-c78d60e826b7', 'd07f106a-5080-58ba-87c1-5f4b7778c331', 'f97d3e0d-fc52-58b2-8851-99a53f0ea7b4', 'ff728071-e2ab-5e02-a50f-9a0bae3ec40a', '83feb802-34ba-547d-86f5-afa61e0f361a', 'eb65f3da-8183-580d-a805-1f2d36292a0f', '27a56397-91e1-5876-814a-f8283f7a913a', '6778f97d-b31f-5c85-b06f-f31d204d840f', '509f07d9-78c5-573f-bfe1-c6a40f324ce2', 'a43c0482-0ff7-54b7-892b-e9a96e9f316d', '789f77cb-8f58-51f6-b872-c6db571d7355', '4251c047-26f4-55a4-b131-ee1af87d5bef', 'ce65fa02-3925-56b9-bad1-1e1a4f856b5c', '5dd3b035-e4b9-56bc-8d84-bb098ef7e407', '7cfe7c7b-ef68-57d9-8143-948130313ce7', '2841e9e5-9800-5ec2-bf00-6f62c4357b3e', '6fbf4970-b44d-57ae-8fef-942a73ec719d', '5346b05b-37c7-5fd6-aeda-1ef357eb8278', '38dc6a97-457f-5c42-b02e-069a87a11bc3', 'fbd347fa-698b-5e74-9e4c-049422a29781', '87623f38-b4f1-5bed-ab71-9b216463a61b', 'dfcb43b3-6192-5598-8236-2bcce1004488', 'deda32eb-75cc-532a-bfbd-f824f2f9d810', '811267f4-0bee-574b-b9f1-76291e74a596', 'd96dc9dc-8f78-5259-aded-3995906da600', '995f1b02-168d-59ae-b2b3-d84204c67ed9', 'b13a435f-81ba-57b4-b009-54a8978d619d', 'da55f641-4fd9-5828-8444-472d2388d0fb', '0c4cd92f-70c9-5c7a-a1f6-af7d4570dc3f', '7a23f433-a990-549e-8e5b-42066890bf8b', '200f2a92-1c5e-5594-bd59-6bac9037abf7', 'f7e5501e-298d-5303-9222-88503da6124d', '82e16296-f6d6-57b6-927e-04c21c48ac31', '198f99da-24d1-5be9-984c-4c2b81154870', '70237436-444d-5abf-912c-37e00c8aa73b');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'eveil-scientifique-6eme' AND source = 'admin' AND id NOT IN ('1c711c11-93d9-5c1a-a172-2e42e9639577', '95a7dd4f-f56f-5189-87f5-f8258dd27a5b', 'dbd48634-d6aa-59c9-96de-2e95e4c8e4be', '7552521d-0930-57e3-bc97-d27689d002f2', '3dd0f522-71ce-5d61-bbd7-1ff28f99740b', '31c7f00e-2811-5947-b3fb-96d2c5012f46', '785b1133-03dc-5ea6-a119-68343d35e8c5', '45614f7e-b1c0-5094-8f09-3d1ee809b452', 'c9471038-aa68-5d23-9828-c6787a18a851', '93e3ff54-751f-5338-9891-ed7496283db4', '83144a7b-33cd-5d46-981e-0d6aea1b6c3f', '9ce85352-fd3a-5438-b2c8-5490dc648e59', '21283609-6e6f-5624-bc24-cedd580c9f0a', 'ba04966f-d093-56cb-81c9-1dd689f6edc5', '25e852eb-166d-5524-beb5-573294fd9eb6', '5a8adbb4-f4f5-51ac-bbee-71e52c439c0a', 'd97ff5d4-e6f6-54be-8c0f-eaf6fe2e1a2a', '69aa3ace-412d-5b40-9cef-44addf566012');
DELETE FROM public.questions WHERE exercise_id IN ('1c711c11-93d9-5c1a-a172-2e42e9639577', '95a7dd4f-f56f-5189-87f5-f8258dd27a5b', 'dbd48634-d6aa-59c9-96de-2e95e4c8e4be', '7552521d-0930-57e3-bc97-d27689d002f2', '3dd0f522-71ce-5d61-bbd7-1ff28f99740b', '31c7f00e-2811-5947-b3fb-96d2c5012f46', '785b1133-03dc-5ea6-a119-68343d35e8c5', '45614f7e-b1c0-5094-8f09-3d1ee809b452', 'c9471038-aa68-5d23-9828-c6787a18a851', '93e3ff54-751f-5338-9891-ed7496283db4', '83144a7b-33cd-5d46-981e-0d6aea1b6c3f', '9ce85352-fd3a-5438-b2c8-5490dc648e59', '21283609-6e6f-5624-bc24-cedd580c9f0a', 'ba04966f-d093-56cb-81c9-1dd689f6edc5', '25e852eb-166d-5524-beb5-573294fd9eb6', '5a8adbb4-f4f5-51ac-bbee-71e52c439c0a', 'd97ff5d4-e6f6-54be-8c0f-eaf6fe2e1a2a', '69aa3ace-412d-5b40-9cef-44addf566012') AND id NOT IN ('22b1784b-cfc3-514b-9c28-f09f47b66944', '647cbfbc-b8e2-5b40-bba6-22e3c136e4cd', '5d2c2a2f-85de-50da-8e69-e418201c807b', '25148e63-2f62-5534-92f4-be9d4d5c8ce0', 'ab2c7b9c-0468-5dec-b731-4762c3bdfbcb', '82dcbdab-16a7-5df9-9cb7-f4cddb7cb0e1', 'e06a976d-142d-556b-811c-49bc1cadae23', 'c0061061-4c17-5e75-ab76-75793f41e464', 'b76bf2e4-e2a0-597d-a05a-6be2a216e4a2', '139e4b74-06da-5979-8395-f9497d98cb71', '8f9da4f4-5811-5f01-a30b-10d394173566', '23ba0a44-a33b-5cc0-b56c-0ed407c81516', 'faff4440-78e7-5010-b17d-3a2b46830f88', '8dff7eee-11c3-5ba3-98bc-ff8f02ead6db', 'f683b638-cc3c-5a55-a388-82ba940e7b29', '9b17c77a-462b-5ecb-b45a-8efe0e8e6c45', 'e8e67b32-c3ac-5bd8-a988-3f58829e1ad7', 'cb6656de-0f96-5120-bd27-cfe3d371dd65', 'fabdd1ed-2731-53e9-b46b-e7848bcca742', '6e1b2b61-5df0-58d5-847f-b84878fde7c9', '477d8191-370c-54f3-b72b-9c11054d1edd', '85e563a0-fd0f-5fd4-b229-fa1ffbdb5912', '642b9384-a3b7-5657-b727-de2b8817ce7b', '7ff2e5f0-a0d5-545e-aa4f-e6a68802bbc0', '2127e544-e2ff-5603-9d28-3dc492666a99', '353627f0-2068-5961-8f0a-4cb97333879c', '07d3d011-b650-5bc8-b293-607d11bcffff', '74666f2c-e6d6-5769-8c5d-2d0294955edc', 'd6709280-b3d8-5a2c-99f1-84ca6e159405', 'ef8fe2ed-827e-5bc2-9690-1f6133188c6d', 'e11a043e-95e0-593f-80b3-913cc03f1b0e', '09fd283e-06cc-5e66-a3de-3999e365a953', '08ff61cc-7013-5d02-a8df-34f4ea0d8559', '13349f24-ec96-5949-86bb-3971f68b5d2e', '1f6d5b40-df86-50b9-8d0b-5fbf6e753273', 'daf8a4c2-099a-5dbc-8de1-39c4e7fd305a', '9e96e371-8cfb-5e45-88b8-b335cfd4ddc8', 'bccab6fe-9303-559a-90c7-3b76e3aedc39', '1bf295eb-9a58-5cae-879c-2df38cdbba36', '7bd45187-54c3-5296-bcb5-bafb7c24bbe4', 'a9118ad3-48fd-54b7-8a88-74254fdcdb7a', '02b7493d-0a90-51b9-ab4d-2c6062fb8b2b', 'e1c04794-5255-56a7-8877-0c5575d985c7', '9fcadfa1-c422-577a-a63f-ac6e8515f591', '159c036b-42bc-56a3-aaf8-969b97f1496f', '0d03b54c-9422-51dc-85ff-7d37a59ac103', '6214cf7a-e549-588d-8cbb-b406af16aff0', 'abc98ba8-9d5c-5498-acc1-f743901e7879', '5a559640-7cd6-5fe1-ae7e-81f1de11de8e', '67b14cb9-a119-57db-8eba-706116074617', 'f7f33503-b459-5d27-adc8-d84ddd9cff08', 'dd185a0c-5964-5921-89c5-6efda6cc9cd4', 'd8a54c40-6502-5056-bf69-f383bc3a676a', 'd7655934-9e62-5a01-a5ed-22de92ae59cb', '0993075f-f19b-509e-825f-0ed08c7fd454', '18063625-8d57-5ff3-928c-639e90c4fa14', '6a967509-b002-58fc-b16d-d5ffd9242d63', '608c5491-da95-5c7d-893e-750d1b7b6f9d', '1f99edab-6543-54c6-ac7b-77f9f4a1d8c7', 'c03e30e1-b023-51fb-a85a-c0398441f94c', '386d67af-7e63-5a6a-8a0c-e2509a41a81b', '39959081-838f-544e-bc60-b45818a9f0ce', 'b93f158a-23c1-5475-9070-bd3f7855aaa8', 'f3cd1045-3d9f-55ce-9308-aa21205f383b', '76e167cd-8d4e-5be5-85ef-6fc2c010ef91', '25767b39-8d52-50ae-84b5-430398ee5bf3', 'dcd9b827-88b9-54d0-8744-f6a7c258031c', '1cc0ee4d-cb5d-5c0c-bcf1-95ef5f970df4', '4bb77781-f351-5501-9e6d-237773298888', '6dd95402-0204-5cd8-9f51-681b9577b53d', '57e35d02-c3b4-57d0-a79d-c78d60e826b7', 'd07f106a-5080-58ba-87c1-5f4b7778c331', 'f97d3e0d-fc52-58b2-8851-99a53f0ea7b4', 'ff728071-e2ab-5e02-a50f-9a0bae3ec40a', '83feb802-34ba-547d-86f5-afa61e0f361a', 'eb65f3da-8183-580d-a805-1f2d36292a0f', '27a56397-91e1-5876-814a-f8283f7a913a', '6778f97d-b31f-5c85-b06f-f31d204d840f', '509f07d9-78c5-573f-bfe1-c6a40f324ce2', 'a43c0482-0ff7-54b7-892b-e9a96e9f316d', '789f77cb-8f58-51f6-b872-c6db571d7355', '4251c047-26f4-55a4-b131-ee1af87d5bef', 'ce65fa02-3925-56b9-bad1-1e1a4f856b5c', '5dd3b035-e4b9-56bc-8d84-bb098ef7e407', '7cfe7c7b-ef68-57d9-8143-948130313ce7', '2841e9e5-9800-5ec2-bf00-6f62c4357b3e', '6fbf4970-b44d-57ae-8fef-942a73ec719d', '5346b05b-37c7-5fd6-aeda-1ef357eb8278', '38dc6a97-457f-5c42-b02e-069a87a11bc3', 'fbd347fa-698b-5e74-9e4c-049422a29781', '87623f38-b4f1-5bed-ab71-9b216463a61b', 'dfcb43b3-6192-5598-8236-2bcce1004488', 'deda32eb-75cc-532a-bfbd-f824f2f9d810', '811267f4-0bee-574b-b9f1-76291e74a596', 'd96dc9dc-8f78-5259-aded-3995906da600', '995f1b02-168d-59ae-b2b3-d84204c67ed9', 'b13a435f-81ba-57b4-b009-54a8978d619d', 'da55f641-4fd9-5828-8444-472d2388d0fb', '0c4cd92f-70c9-5c7a-a1f6-af7d4570dc3f', '7a23f433-a990-549e-8e5b-42066890bf8b', '200f2a92-1c5e-5594-bd59-6bac9037abf7', 'f7e5501e-298d-5303-9222-88503da6124d', '82e16296-f6d6-57b6-927e-04c21c48ac31', '198f99da-24d1-5be9-984c-4c2b81154870', '70237436-444d-5abf-912c-37e00c8aa73b');
DELETE FROM public.chapters c WHERE c.subject_id = 'eveil-scientifique-6eme' AND c.id NOT IN ('e560f7f7-a314-5ca6-a3f1-a294385e4f28', '38976f55-d157-591a-9efd-ad38e0e0b33a', 'a5efe929-363c-5e01-a9bc-06eff4fbe288') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('e560f7f7-a314-5ca6-a3f1-a294385e4f28', 'eveil-scientifique-6eme', 'الهواء', 'خاصيّاتُ الهواء ومكوّناتُه (الآزوت والأكسجين)، وأهميّتُه للحياة، والاحتراقُ ودورُ الأكسجين', '# 💨 الهواء

> 💡 «الهواءُ غازٌ لا نراه، لكنّنا نحسّ به ولا نعيشُ من دونه. لنكتشفْ ممّ يتكوّن وكيف يحفظُ الحياة.»

## 🌬️ خاصيّاتُ الهواء

- **غيرُ مرئيّ**، لكنّه مادّةٌ حقيقيّة.
- **له كتلة** (يمكن وزنُه).
- **يشغلُ حيّزًا** (يملأ كلَّ إناءٍ يوجدُ فيه).
- **قابلٌ للانضغاط** (يمكن ضغطُه في حجمٍ أصغر، كما في إطار العجلة).

## 🧪 مكوّناتُ الهواء

الهواءُ **خليطٌ** من الغازات:

| الغاز                                | النسبة التقريبيّة |
| ------------------------------------ | ----------------- |
| الآزوت (النيتروجين)                  | حوالي 78%         |
| الأكسجين                             | حوالي 21%         |
| غازاتٌ أخرى (منها ثاني أكسيد الكربون) | حوالي 1%          |

## 🔥 الاحتراقُ وأهميّةُ الأكسجين

- **الأكسجينُ** غازٌ ضروريٌّ للتنفّس وللاحتراق.
- لا يحدثُ **احتراقٌ** بدون أكسجين: إذا غطّينا شمعةً مشتعلةً بكأسٍ مقلوب **تنطفئ** بعد نفاد الأكسجين.
- الهواءُ ضروريٌّ لحياة **الإنسان والحيوان والنبات**.

> ⚠️ الفخّ الشائع: الظنُّ أنّ الهواء كلَّه أكسجين. في الحقيقة الأكسجينُ حوالي **21%** فقط، والأغلبُ آزوت (حوالي 78%).

> 🏆 عرفتَ خاصيّاتِ الهواء ومكوّناتِه. التالي: كيف يستعملُ جسمُنا أكسجينَ الهواء في التنفّس.', '# 📜 ملخّص: الهواء

- **خاصيّاتُ الهواء:** غيرُ مرئيّ، له كتلة، يشغلُ حيّزًا، قابلٌ للانضغاط.
- **مكوّناتُه:** آزوت حوالي 78%، أكسجين حوالي 21%، غازاتٌ أخرى حوالي 1% (منها ثاني أكسيد الكربون).
- **الأكسجين** ضروريٌّ للتنفّس وللاحتراق؛ بدونه تنطفئُ الشعلة.
- الهواءُ ضروريٌّ لحياة الإنسان والحيوان والنبات.
- ⚠️ الأكسجينُ ليس كلَّ الهواء، بل حوالي 21% فقط.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('38976f55-d157-591a-9efd-ad38e0e0b33a', 'eveil-scientifique-6eme', 'التنفّس عند الإنسان', 'حركتا الشهيق والزفير، ومسارُ الهواء في جهاز التنفّس، والتبادلُ الغازيُّ في مستوى الرئتين', '# 🫁 التنفّس عند الإنسان

> 💡 «في كلّ لحظةٍ نتنفّس: نأخذُ الأكسجينَ من الهواء ونتخلّصُ من ثاني أكسيد الكربون. لنتتبّعْ رحلةَ الهواء داخل أجسامنا.»

## 🔄 حركتا التنفّس

- **الشهيق:** ندخلُ الهواءَ الغنيَّ بالأكسجين إلى الرئتين.
- **الزفير:** نُخرجُ الهواءَ المحمّلَ بثاني أكسيد الكربون.

## 🛣️ مسارُ الهواء (جهاز التنفّس)

الأنف ← القصبة الهوائيّة ← الرئتان ← الحويصلات الهوائيّة.

## 💨 التبادلُ الغازيُّ في الرئتين

في **الحويصلات الهوائيّة** يحدثُ التبادل:

- **الأكسجين** ينتقلُ من الهواء إلى **الدم**.
- **ثاني أكسيد الكربون** ينتقلُ من الدم إلى الهواء ليُطرحَ بالزفير.

> 🌬️ لذلك يكون **هواءُ الشهيق** أغنى بالأكسجين، و**هواءُ الزفير** أغنى بثاني أكسيد الكربون.

> ⚠️ الفخّ الشائع: الظنُّ أنّنا نطردُ كلَّ الأكسجين في الزفير. الحقيقة أنّنا نأخذُ جزءًا منه فقط؛ يبقى في الزفير أكسجين، لكنّ نسبةَ ثاني أكسيد الكربون فيه ترتفع.

> 🏆 فهمتَ كيف يدخلُ الأكسجينُ إلى الدم. التالي: كيف ينقلُ الدمُ هذا الأكسجينَ إلى كلّ الجسم.', '# 📜 ملخّص: التنفّس عند الإنسان

- **التنفّس:** أخذُ الأكسجين وطرحُ ثاني أكسيد الكربون.
- **حركتاه:** الشهيق (إدخال الهواء) والزفير (إخراج الهواء).
- **المسار:** الأنف ← القصبة الهوائيّة ← الرئتان ← الحويصلات الهوائيّة.
- **التبادلُ الغازيّ** في الحويصلات: الأكسجين إلى الدم، وثاني أكسيد الكربون من الدم إلى الهواء.
- هواءُ الشهيق غنيٌّ بالأكسجين، وهواءُ الزفير غنيٌّ بثاني أكسيد الكربون.
- ⚠️ الزفيرُ لا يخلو من الأكسجين، لكنّ نسبة ثاني أكسيد الكربون فيه أعلى.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('a5efe929-363c-5e01-a9bc-06eff4fbe288', 'eveil-scientifique-6eme', 'جهاز دوران الدم', 'تركيبةُ الدم (البلازما والكريّات الحمراء والبيضاء والصفيحات)، والقلبُ والأوعية، ودورُ الدم في نقل الأكسجين والمغذّيات', '# ❤️ جهاز دوران الدم

> 💡 «الدمُ نهرٌ أحمرُ يجري في جسمك ليلَ نهار، يحملُ الغذاءَ والأكسجينَ إلى كلّ خليّة، والقلبُ مضخّتُه التي لا تتوقّف.»

## 🩸 تركيبةُ الدم

| المكوّن            | الدور                              |
| ------------------ | ---------------------------------- |
| البلازما           | سائلٌ يحملُ المكوّناتِ والمغذّيات   |
| الكريّات الحمراء   | نقلُ الأكسجين                       |
| الكريّات البيضاء   | الدفاعُ عن الجسم ضدّ الميكروبات     |
| الصفيحات الدمويّة  | تخثّرُ الدم وإيقافُ النزيف          |

## 🫀 القلبُ والأوعية

- **القلب:** عضلةٌ تعملُ كـ**مضخّة** تدفعُ الدمَ باستمرار في كامل الجسم.
- **الأوعية الدمويّة:** الشرايينُ (يخرجُ فيها الدمُ من القلب)، والأوردةُ (يرجعُ فيها الدمُ إلى القلب)، والشعيراتُ الدمويّة (دقيقةٌ جدًّا).

## 🚚 وظيفةُ الدم

الدمُ ينقل:

- **الأكسجين** من الرئتين و**المغذّيات** من الأمعاء إلى كلّ الأعضاء.
- **ثاني أكسيد الكربون** والفضلاتِ بعيدًا عن الأعضاء لطرحها.

> ⚠️ الفخّ الشائع: الخلطُ بين دور الكريّات الحمراء (نقلُ الأكسجين) ودور الكريّات البيضاء (الدفاع). لكلٍّ منهما وظيفةٌ مختلفة.

> 🏆 عرفتَ كيف ينقلُ الدمُ الأكسجينَ والغذاء. والتالي في رحلتنا: من أين يأتي هذا الغذاء؟ التغذية عند الإنسان.', '# 📜 ملخّص: جهاز دوران الدم

- **تركيبةُ الدم:** البلازما + الكريّات الحمراء (نقل الأكسجين) + الكريّات البيضاء (الدفاع) + الصفيحات الدمويّة (التخثّر).
- **القلب:** مضخّةٌ تدفعُ الدمَ في كامل الجسم.
- **الأوعية:** الشرايين (من القلب) والأوردة (إلى القلب) والشعيرات الدمويّة.
- **وظيفةُ الدم:** نقلُ الأكسجين والمغذّيات إلى الأعضاء، ونقلُ ثاني أكسيد الكربون والفضلات بعيدًا.
- ⚠️ الكريّاتُ الحمراء تنقلُ الأكسجين، والبيضاءُ تدافعُ عن الجسم.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1c711c11-93d9-5c1a-a172-2e42e9639577', 'e560f7f7-a314-5ca6-a3f1-a294385e4f28', 'eveil-scientifique-6eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('22b1784b-cfc3-514b-9c28-f09f47b66944', '1c711c11-93d9-5c1a-a172-2e42e9639577', 'ما الغازُ الأكثرُ وفرةً في الهواء؟', '[{"id":"a","text":"الآزوت (النيتروجين)"},{"id":"b","text":"الأكسجين"},{"id":"c","text":"ثاني أكسيد الكربون"},{"id":"d","text":"بخار الماء"}]'::jsonb, 'a', 'الآزوتُ (النيتروجين) هو الغازُ الأكثرُ وفرةً في الهواء بنسبةٍ تقارب 78%.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('647cbfbc-b8e2-5b40-bba6-22e3c136e4cd', '1c711c11-93d9-5c1a-a172-2e42e9639577', 'ما الغازُ الضروريُّ للتنفّس وللاحتراق؟', '[{"id":"a","text":"الأكسجين"},{"id":"b","text":"الآزوت"},{"id":"c","text":"ثاني أكسيد الكربون"},{"id":"d","text":"الهيدروجين"}]'::jsonb, 'a', 'الأكسجينُ هو الغازُ الذي نستعملُه في التنفّس وفي الاحتراق.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5d2c2a2f-85de-50da-8e69-e418201c807b', '1c711c11-93d9-5c1a-a172-2e42e9639577', 'ما النسبةُ التقريبيّةُ للأكسجين في الهواء؟', '[{"id":"a","text":"حوالي 21%"},{"id":"b","text":"حوالي 78%"},{"id":"c","text":"حوالي 50%"},{"id":"d","text":"حوالي 1%"}]'::jsonb, 'a', 'يمثّلُ الأكسجينُ حوالي 21% من الهواء، بينما الآزوت حوالي 78%.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25148e63-2f62-5534-92f4-be9d4d5c8ce0', '1c711c11-93d9-5c1a-a172-2e42e9639577', 'شمعةٌ مشتعلةٌ غُطّيت بكأسٍ مقلوب. ماذا يحدثُ لها؟', '[{"id":"a","text":"تنطفئ بعد نفاد الأكسجين"},{"id":"b","text":"يزدادُ لهبُها أكثر"},{"id":"c","text":"لا يتغيّرُ شيء"},{"id":"d","text":"تتحوّلُ إلى ماء"}]'::jsonb, 'a', 'الاحتراقُ يحتاجُ الأكسجين؛ وعند حصره داخل الكأس ينفدُ الأكسجينُ فتنطفئُ الشمعة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab2c7b9c-0468-5dec-b731-4762c3bdfbcb', '1c711c11-93d9-5c1a-a172-2e42e9639577', 'أيُّ عبارةٍ صحيحةٌ عن الهواء؟', '[{"id":"a","text":"له كتلةٌ ويشغلُ حيّزًا"},{"id":"b","text":"لا كتلةَ له ولا يشغلُ حيّزًا"},{"id":"c","text":"مرئيٌّ بوضوحٍ كالماء"},{"id":"d","text":"لا يمكنُ ضغطُه أبدًا"}]'::jsonb, 'a', 'الهواءُ مادّةٌ لها كتلةٌ وتشغلُ حيّزًا، وهو غيرُ مرئيٍّ وقابلٌ للانضغاط.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('95a7dd4f-f56f-5189-87f5-f8258dd27a5b', 'e560f7f7-a314-5ca6-a3f1-a294385e4f28', 'eveil-scientifique-6eme', '⭐ تمرين: أوّلُ خطوات مع الهواء', 1, 50, 10, 'practice', 'admin', 1)
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
  ('82dcbdab-16a7-5df9-9cb7-f4cddb7cb0e1', '95a7dd4f-f56f-5189-87f5-f8258dd27a5b', 'الهواءُ ضروريٌّ لحياة:', '[{"id":"a","text":"الإنسان والحيوان والنبات"},{"id":"b","text":"الإنسان فقط"},{"id":"c","text":"الحيوان فقط"},{"id":"d","text":"الجمادات"}]'::jsonb, 'a', 'الهواءُ ضروريٌّ لحياة الكائنات الحيّة جميعها: الإنسان والحيوان والنبات.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e06a976d-142d-556b-811c-49bc1cadae23', '95a7dd4f-f56f-5189-87f5-f8258dd27a5b', 'ما الغازُ الذي نستعملُه في التنفّس؟', '[{"id":"a","text":"الأكسجين"},{"id":"b","text":"الآزوت"},{"id":"c","text":"ثاني أكسيد الكربون"},{"id":"d","text":"الهيليوم"}]'::jsonb, 'a', 'نستنشقُ الأكسجينَ من الهواء، وهو الغازُ الضروريُّ للتنفّس.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c0061061-4c17-5e75-ab76-75793f41e464', '95a7dd4f-f56f-5189-87f5-f8258dd27a5b', 'ما الغازُ الأكثرُ وفرةً في الهواء؟', '[{"id":"a","text":"الآزوت"},{"id":"b","text":"الأكسجين"},{"id":"c","text":"ثاني أكسيد الكربون"},{"id":"d","text":"بخار الماء"}]'::jsonb, 'a', 'الآزوتُ يمثّلُ النسبةَ الأكبرَ في الهواء (حوالي 78%).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b76bf2e4-e2a0-597d-a05a-6be2a216e4a2', '95a7dd4f-f56f-5189-87f5-f8258dd27a5b', 'هل الهواءُ مادّةٌ لها كتلة؟', '[{"id":"a","text":"نعم، له كتلةٌ يمكن وزنُها"},{"id":"b","text":"لا، لا كتلةَ له إطلاقًا"},{"id":"c","text":"له كتلةٌ سالبة"},{"id":"d","text":"يصبحُ ذا كتلةٍ إذا تجمّد فقط"}]'::jsonb, 'a', 'الهواءُ مادّةٌ حقيقيّةٌ له كتلة؛ فالكرةُ المنفوخةُ أثقلُ من الفارغة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('139e4b74-06da-5979-8395-f9497d98cb71', '95a7dd4f-f56f-5189-87f5-f8258dd27a5b', 'ما النسبةُ التقريبيّةُ للأكسجين في الهواء؟', '[{"id":"a","text":"حوالي 21%"},{"id":"b","text":"حوالي 78%"},{"id":"c","text":"حوالي 90%"},{"id":"d","text":"حوالي 5%"}]'::jsonb, 'a', 'يمثّلُ الأكسجينُ حوالي 21% من الهواء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8f9da4f4-5811-5f01-a30b-10d394173566', '95a7dd4f-f56f-5189-87f5-f8258dd27a5b', 'لماذا تنطفئُ شمعةٌ مشتعلةٌ وُضع عليها كأسٌ مقلوب؟', '[{"id":"a","text":"لنفاد الأكسجين داخل الكأس"},{"id":"b","text":"لأنّ الكأسَ بارد"},{"id":"c","text":"لزيادة الأكسجين"},{"id":"d","text":"لأنّ الشمعةَ تكره الزجاج"}]'::jsonb, 'a', 'الاحتراقُ يحتاجُ الأكسجين؛ وحين ينفدُ الأكسجينُ المحصورُ في الكأس تنطفئُ الشمعة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('dbd48634-d6aa-59c9-96de-2e95e4c8e4be', 'e560f7f7-a314-5ca6-a3f1-a294385e4f28', 'eveil-scientifique-6eme', '⚔️ زعيم الفصل ⭐⭐⭐: تحدّي الهواء', 3, 120, 30, 'boss', 'admin', 2)
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
  ('23ba0a44-a33b-5cc0-b56c-0ed407c81516', 'dbd48634-d6aa-59c9-96de-2e95e4c8e4be', 'ما الغازُ الذي يمثّلُ حوالي 78% من الهواء؟', '[{"id":"a","text":"الآزوت"},{"id":"b","text":"الأكسجين"},{"id":"c","text":"ثاني أكسيد الكربون"},{"id":"d","text":"الأوزون"}]'::jsonb, 'a', 'الآزوتُ هو المكوّنُ الأكبرُ للهواء بنسبةٍ تقارب 78%.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('faff4440-78e7-5010-b17d-3a2b46830f88', 'dbd48634-d6aa-59c9-96de-2e95e4c8e4be', 'أيٌّ ممّا يلي من خاصيّات الهواء؟', '[{"id":"a","text":"يشغلُ حيّزًا ويملأُ الإناء"},{"id":"b","text":"لا يشغلُ أيَّ حيّز"},{"id":"c","text":"صلبٌ في الظروف العاديّة"},{"id":"d","text":"مرئيٌّ كالحجر"}]'::jsonb, 'a', 'الهواءُ يشغلُ حيّزًا، فهو يملأُ كلَّ إناءٍ يوجدُ فيه ويأخذُ شكلَه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8dff7eee-11c3-5ba3-98bc-ff8f02ead6db', 'dbd48634-d6aa-59c9-96de-2e95e4c8e4be', 'الاحتراقُ في الهواء يحتاجُ أساسًا إلى:', '[{"id":"a","text":"الأكسجين"},{"id":"b","text":"الآزوت"},{"id":"c","text":"ثاني أكسيد الكربون"},{"id":"d","text":"بخار الماء"}]'::jsonb, 'a', 'الأكسجينُ هو الغازُ الذي يُغذّي الاحتراق؛ بدونه لا تشتعلُ النار.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f683b638-cc3c-5a55-a388-82ba940e7b29', 'dbd48634-d6aa-59c9-96de-2e95e4c8e4be', 'نضغطُ مكبسَ محقنٍ مسدودِ الفُوّهة وممتلئٍ بالهواء، فيتراجعُ المكبسُ قليلًا. ماذا نستنتج؟', '[{"id":"a","text":"الهواءُ قابلٌ للانضغاط"},{"id":"b","text":"الهواءُ لا كتلةَ له"},{"id":"c","text":"الهواءُ سائل"},{"id":"d","text":"الهواءُ اختفى"}]'::jsonb, 'a', 'إمكانيّةُ ضغط الهواء في حجمٍ أصغرَ تدلّ على أنّه قابلٌ للانضغاط.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b17c77a-462b-5ecb-b45a-8efe0e8e6c45', 'dbd48634-d6aa-59c9-96de-2e95e4c8e4be', 'ما الغازُ الذي يطرحُه الإنسانُ بكثرةٍ عند الزفير؟', '[{"id":"a","text":"ثاني أكسيد الكربون"},{"id":"b","text":"الأكسجين النقيّ"},{"id":"c","text":"الآزوت فقط"},{"id":"d","text":"الهيدروجين"}]'::jsonb, 'a', 'عند الزفير يطرحُ الإنسانُ هواءً غنيًّا بثاني أكسيد الكربون الناتج عن نشاط الجسم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e8e67b32-c3ac-5bd8-a988-3f58829e1ad7', 'dbd48634-d6aa-59c9-96de-2e95e4c8e4be', 'لماذا يُنصحُ بتهوية الغرف المغلقة؟', '[{"id":"a","text":"لتجديد الأكسجين وطرد ثاني أكسيد الكربون"},{"id":"b","text":"لزيادة ثاني أكسيد الكربون"},{"id":"c","text":"لإخراج كلّ الهواء نهائيًّا"},{"id":"d","text":"لتبريد الجدران فقط"}]'::jsonb, 'a', 'التهويةُ تُجدّدُ الهواءَ: تُدخلُ أكسجينًا جديدًا وتطردُ ثاني أكسيد الكربون المتراكم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7552521d-0930-57e3-bc97-d27689d002f2', 'e560f7f7-a314-5ca6-a3f1-a294385e4f28', 'eveil-scientifique-6eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الهواء', 2, 70, 15, 'practice', 'admin', 3)
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
  ('cb6656de-0f96-5120-bd27-cfe3d371dd65', '7552521d-0930-57e3-bc97-d27689d002f2', 'ما الغازُ المحيي للاحتراق؟', '[{"id":"a","text":"الأكسجين"},{"id":"b","text":"الآزوت"},{"id":"c","text":"ثاني أكسيد الكربون"},{"id":"d","text":"بخار الماء"}]'::jsonb, 'a', 'الأكسجينُ غازٌ محيٍّ للاحتراق: وجودُه ضروريٌّ لاستمرار اشتعال النار.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fabdd1ed-2731-53e9-b46b-e7848bcca742', '7552521d-0930-57e3-bc97-d27689d002f2', 'ما المكوّنان الرئيسيّان للهواء؟', '[{"id":"a","text":"الآزوت والأكسجين"},{"id":"b","text":"الأكسجين والهيدروجين"},{"id":"c","text":"بخار الماء والدخان"},{"id":"d","text":"ثاني أكسيد الكربون والهيليوم"}]'::jsonb, 'a', 'يتكوّنُ الهواءُ أساسًا من الآزوت (حوالي 78%) والأكسجين (حوالي 21%).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6e1b2b61-5df0-58d5-847f-b84878fde7c9', '7552521d-0930-57e3-bc97-d27689d002f2', 'ما النسبةُ التقريبيّةُ للآزوت في الهواء؟', '[{"id":"a","text":"حوالي 78%"},{"id":"b","text":"حوالي 21%"},{"id":"c","text":"حوالي 10%"},{"id":"d","text":"حوالي 100%"}]'::jsonb, 'a', 'يمثّلُ الآزوتُ حوالي 78% من الهواء، وهو الجزءُ الأكبر.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('477d8191-370c-54f3-b72b-9c11054d1edd', '7552521d-0930-57e3-bc97-d27689d002f2', 'هل الهواءُ مرئيّ؟', '[{"id":"a","text":"غيرُ مرئيّ لكنّه مادّةٌ حقيقيّة"},{"id":"b","text":"مرئيٌّ وملوّنٌ كالماء"},{"id":"c","text":"مرئيٌّ في الليل فقط"},{"id":"d","text":"ليس مادّةً أصلًا"}]'::jsonb, 'a', 'الهواءُ غيرُ مرئيّ، لكنّه مادّةٌ حقيقيّةٌ لها كتلةٌ وتشغلُ حيّزًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85e563a0-fd0f-5fd4-b229-fa1ffbdb5912', '7552521d-0930-57e3-bc97-d27689d002f2', 'ماذا يحدثُ للنبات إذا حُرم تمامًا من الهواء؟', '[{"id":"a","text":"لا يعيشُ (يذبلُ ويموت)"},{"id":"b","text":"ينمو أسرع"},{"id":"c","text":"لا يتأثّرُ إطلاقًا"},{"id":"d","text":"يتحوّلُ إلى حيوان"}]'::jsonb, 'a', 'النباتُ كائنٌ حيٌّ يحتاجُ الهواء؛ فحرمانُه منه يؤدّي إلى ذبوله وموته.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('642b9384-a3b7-5657-b727-de2b8817ce7b', '7552521d-0930-57e3-bc97-d27689d002f2', 'إناءٌ يبدو فارغًا قلبناه في الماء فلم يدخله الماءُ بسهولة. لماذا؟', '[{"id":"a","text":"لأنّه ممتلئٌ بالهواء الذي يشغلُ حيّزًا"},{"id":"b","text":"لأنّ الماءَ يخافُ الإناء"},{"id":"c","text":"لأنّ الإناءَ ممتلئٌ بالماء أصلًا"},{"id":"d","text":"لأنّ الهواءَ لا يشغلُ حيّزًا"}]'::jsonb, 'a', 'الإناءُ ليس فارغًا بل ممتلئٌ بالهواء الذي يشغلُ حيّزًا، فيمنعُ دخولَ الماء.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3dd0f522-71ce-5d61-bbd7-1ff28f99740b', 'e560f7f7-a314-5ca6-a3f1-a294385e4f28', 'eveil-scientifique-6eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّدُ الهواء', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('7ff2e5f0-a0d5-545e-aa4f-e6a68802bbc0', '3dd0f522-71ce-5d61-bbd7-1ff28f99740b', 'أيُّ نسبةٍ هي الأصحُّ للأكسجين في الهواء؟', '[{"id":"a","text":"حوالي 21%"},{"id":"b","text":"حوالي 78%"},{"id":"c","text":"حوالي 33%"},{"id":"d","text":"حوالي 12%"}]'::jsonb, 'a', 'نسبةُ الأكسجين في الهواء حوالي 21%، وهي ثابتةٌ تقريبًا في الهواء النقيّ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2127e544-e2ff-5603-9d28-3dc492666a99', '3dd0f522-71ce-5d61-bbd7-1ff28f99740b', 'شمعتان متماثلتان: الأولى تحت كأسٍ صغير والثانية تحت كأسٍ كبير. أيُّهما تنطفئُ أوّلًا؟', '[{"id":"a","text":"التي تحت الكأس الصغير"},{"id":"b","text":"التي تحت الكأس الكبير"},{"id":"c","text":"تنطفئان في الوقت نفسه"},{"id":"d","text":"لا تنطفئُ أيٌّ منهما"}]'::jsonb, 'a', 'الكأسُ الصغيرُ يحوي أكسجينًا أقلّ، فينفدُ أسرعَ وتنطفئُ شمعتُه أوّلًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('353627f0-2068-5961-8f0a-4cb97333879c', '3dd0f522-71ce-5d61-bbd7-1ff28f99740b', 'نُطلقُ فقّاعةَ هواءٍ في كأس ماء، فترتفعُ نحو السطح. لماذا؟', '[{"id":"a","text":"لأنّ الهواءَ أخفُّ من الماء"},{"id":"b","text":"لأنّ الهواءَ أثقلُ من الماء"},{"id":"c","text":"لأنّ الماءَ يدفعُها للأسفل"},{"id":"d","text":"لأنّ الهواءَ ذاب في الماء"}]'::jsonb, 'a', 'كتلةُ حجمٍ من الهواء أقلُّ من كتلة الحجم نفسِه من الماء، فالهواءُ أخفُّ ويصعدُ إلى السطح.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07d3d011-b650-5bc8-b293-607d11bcffff', '3dd0f522-71ce-5d61-bbd7-1ff28f99740b', 'عند احتراق الفحم في الهواء، يُستهلكُ الأكسجينُ ويتكوّنُ غالبًا:', '[{"id":"a","text":"ثاني أكسيد الكربون"},{"id":"b","text":"أكسجينٌ إضافيّ"},{"id":"c","text":"آزوتٌ نقيّ"},{"id":"d","text":"ماءٌ صالحٌ للشرب"}]'::jsonb, 'a', 'الاحتراقُ يستهلكُ الأكسجينَ ويُنتجُ غالبًا ثاني أكسيد الكربون.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74666f2c-e6d6-5769-8c5d-2d0294955edc', '3dd0f522-71ce-5d61-bbd7-1ff28f99740b', 'ما الدليلُ العمليّ على أنّ للهواء كتلة؟', '[{"id":"a","text":"كرةٌ منفوخةٌ أثقلُ من الكرة نفسِها فارغة"},{"id":"b","text":"الهواءُ غيرُ مرئيّ"},{"id":"c","text":"الهواءُ يملأُ الغرفة"},{"id":"d","text":"الهواءُ باردٌ في الشتاء"}]'::jsonb, 'a', 'إذا وزنّا كرةً قبل النفخ وبعده نجدُ المنفوخةَ أثقل، وهذا دليلٌ على أنّ للهواء كتلة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6709280-b3d8-5a2c-99f1-84ca6e159405', '3dd0f522-71ce-5d61-bbd7-1ff28f99740b', 'لماذا يحملُ الغوّاصُ قارورةً على ظهره تحت الماء؟', '[{"id":"a","text":"ليتزوّدَ بالأكسجين اللازم للتنفّس"},{"id":"b","text":"ليشربَ منها الماء"},{"id":"c","text":"ليثقلَ وزنَه فقط"},{"id":"d","text":"لأنّ الماءَ فيه أكسجينٌ كثير يتنفّسُه مباشرة"}]'::jsonb, 'a', 'لا يستطيعُ الإنسانُ أخذَ الأكسجين من الماء، فيحملُ قارورةَ هواءٍ ليتنفّسَ تحت الماء.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('31c7f00e-2811-5947-b3fb-96d2c5012f46', 'e560f7f7-a314-5ca6-a3f1-a294385e4f28', 'eveil-scientifique-6eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملةٌ للهواء', 3, 120, 30, 'boss', 'admin', 5)
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
  ('ef8fe2ed-827e-5bc2-9690-1f6133188c6d', '31c7f00e-2811-5947-b3fb-96d2c5012f46', 'ما الغازُ الضروريُّ للتنفّس وللاحتراق معًا؟', '[{"id":"a","text":"الأكسجين"},{"id":"b","text":"الآزوت"},{"id":"c","text":"ثاني أكسيد الكربون"},{"id":"d","text":"النيون"}]'::jsonb, 'a', 'الأكسجينُ ضروريٌّ للتنفّس وللاحتراق في آنٍ واحد.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e11a043e-95e0-593f-80b3-913cc03f1b0e', '31c7f00e-2811-5947-b3fb-96d2c5012f46', 'ما الغازُ صاحبُ النسبة الأكبر في الهواء؟', '[{"id":"a","text":"الآزوت"},{"id":"b","text":"الأكسجين"},{"id":"c","text":"ثاني أكسيد الكربون"},{"id":"d","text":"بخار الماء"}]'::jsonb, 'a', 'الآزوتُ هو الأكبرُ نسبةً في الهواء (حوالي 78%).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('09fd283e-06cc-5e66-a3de-3999e365a953', '31c7f00e-2811-5947-b3fb-96d2c5012f46', 'ما النسبةُ التقريبيّةُ للأكسجين في الهواء؟', '[{"id":"a","text":"حوالي 21%"},{"id":"b","text":"حوالي 78%"},{"id":"c","text":"حوالي 41%"},{"id":"d","text":"حوالي 8%"}]'::jsonb, 'a', 'يمثّلُ الأكسجينُ حوالي 21% من حجم الهواء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08ff61cc-7013-5d02-a8df-34f4ea0d8559', '31c7f00e-2811-5947-b3fb-96d2c5012f46', 'لماذا تنطفئُ النارُ إذا غطّيناها ببطّانيّةٍ مبلّلة؟', '[{"id":"a","text":"لأنّنا نمنعُ عنها الأكسجين"},{"id":"b","text":"لأنّنا نزيدُها أكسجينًا"},{"id":"c","text":"لأنّ البطّانيّةَ تُشعلُها أكثر"},{"id":"d","text":"لأنّ النارَ تحبُّ الماء"}]'::jsonb, 'a', 'تغطيةُ النار تعزلُها عن أكسجين الهواء، وبدون أكسجينٍ ينطفئُ الاحتراق.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13349f24-ec96-5949-86bb-3971f68b5d2e', '31c7f00e-2811-5947-b3fb-96d2c5012f46', 'أيُّ خاصيّةٍ تسمحُ بنفخ إطار العجلة بكمّيّةٍ كبيرةٍ من الهواء؟', '[{"id":"a","text":"الهواءُ قابلٌ للانضغاط"},{"id":"b","text":"الهواءُ غيرُ مرئيّ"},{"id":"c","text":"الهواءُ ثقيلٌ جدًّا"},{"id":"d","text":"الهواءُ صلب"}]'::jsonb, 'a', 'لأنّ الهواءَ قابلٌ للانضغاط يمكنُ حشرُ كمّيّةٍ كبيرةٍ منه في حجم الإطار الصغير.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f6d5b40-df86-50b9-8d0b-5fbf6e753273', '31c7f00e-2811-5947-b3fb-96d2c5012f46', 'في غرفةٍ مغلقةٍ مكتظّةٍ بالناس، ماذا يحدثُ لنسبة ثاني أكسيد الكربون مع الوقت؟', '[{"id":"a","text":"ترتفعُ تدريجيًّا"},{"id":"b","text":"تنعدمُ تمامًا"},{"id":"c","text":"تبقى ثابتةً دائمًا"},{"id":"d","text":"تتحوّلُ إلى أكسجين"}]'::jsonb, 'a', 'زفيرُ الناس يطرحُ ثاني أكسيد الكربون، فترتفعُ نسبتُه في الغرفة المغلقة، لذا تجبُ التهوية.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('785b1133-03dc-5ea6-a119-68343d35e8c5', '38976f55-d157-591a-9efd-ad38e0e0b33a', 'eveil-scientifique-6eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('daf8a4c2-099a-5dbc-8de1-39c4e7fd305a', '785b1133-03dc-5ea6-a119-68343d35e8c5', 'ما العضوان الرئيسيّان للتنفّس عند الإنسان؟', '[{"id":"a","text":"الرئتان"},{"id":"b","text":"الكليتان"},{"id":"c","text":"المعدة"},{"id":"d","text":"الكبد"}]'::jsonb, 'a', 'الرئتان هما العضوان الرئيسيّان للتنفّس، وفيهما يحدثُ التبادلُ الغازيّ مع الدم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e96e371-8cfb-5e45-88b8-b335cfd4ddc8', '785b1133-03dc-5ea6-a119-68343d35e8c5', 'حركةُ إدخال الهواء إلى الرئتين تُسمّى:', '[{"id":"a","text":"الشهيق"},{"id":"b","text":"الزفير"},{"id":"c","text":"الهضم"},{"id":"d","text":"النبض"}]'::jsonb, 'a', 'الشهيقُ هو حركةُ إدخال الهواء الغنيّ بالأكسجين إلى الرئتين.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bccab6fe-9303-559a-90c7-3b76e3aedc39', '785b1133-03dc-5ea6-a119-68343d35e8c5', 'عند الزفير نطرحُ هواءً غنيًّا بـ:', '[{"id":"a","text":"ثاني أكسيد الكربون"},{"id":"b","text":"الأكسجين النقيّ"},{"id":"c","text":"الآزوت فقط"},{"id":"d","text":"بخار البنزين"}]'::jsonb, 'a', 'هواءُ الزفير غنيٌّ بثاني أكسيد الكربون الناتج عن نشاط الجسم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1bf295eb-9a58-5cae-879c-2df38cdbba36', '785b1133-03dc-5ea6-a119-68343d35e8c5', 'أين يحدثُ التبادلُ الغازيُّ بين الهواء والدم؟', '[{"id":"a","text":"في الحويصلات الهوائيّة بالرئتين"},{"id":"b","text":"في المعدة"},{"id":"c","text":"في الأنف فقط"},{"id":"d","text":"في العظام"}]'::jsonb, 'a', 'يحدثُ التبادلُ الغازيُّ في الحويصلات الهوائيّة داخل الرئتين.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7bd45187-54c3-5296-bcb5-bafb7c24bbe4', '785b1133-03dc-5ea6-a119-68343d35e8c5', 'في الرئتين، ينتقلُ الأكسجينُ من الهواء إلى:', '[{"id":"a","text":"الدم"},{"id":"b","text":"العظام"},{"id":"c","text":"الجلد"},{"id":"d","text":"الشعر"}]'::jsonb, 'a', 'ينتقلُ الأكسجينُ من الحويصلات الهوائيّة إلى الدم ليُوزَّع على الجسم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('45614f7e-b1c0-5094-8f09-3d1ee809b452', '38976f55-d157-591a-9efd-ad38e0e0b33a', 'eveil-scientifique-6eme', '⭐ تمرين: أوّلُ خطوات مع التنفّس', 1, 50, 10, 'practice', 'admin', 1)
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
  ('a9118ad3-48fd-54b7-8a88-74254fdcdb7a', '45614f7e-b1c0-5094-8f09-3d1ee809b452', 'ما العضوان اللذان نتنفّسُ بهما؟', '[{"id":"a","text":"الرئتان"},{"id":"b","text":"الأمعاء"},{"id":"c","text":"القلب"},{"id":"d","text":"الدماغ"}]'::jsonb, 'a', 'نتنفّسُ بالرئتين، وهما العضوان الرئيسيّان للتنفّس.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02b7493d-0a90-51b9-ab4d-2c6062fb8b2b', '45614f7e-b1c0-5094-8f09-3d1ee809b452', 'حركةُ إدخال الهواء تُسمّى:', '[{"id":"a","text":"الشهيق"},{"id":"b","text":"الزفير"},{"id":"c","text":"العطس"},{"id":"d","text":"البلع"}]'::jsonb, 'a', 'الشهيقُ هو إدخالُ الهواء إلى الرئتين.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1c04794-5255-56a7-8877-0c5575d985c7', '45614f7e-b1c0-5094-8f09-3d1ee809b452', 'حركةُ إخراج الهواء تُسمّى:', '[{"id":"a","text":"الزفير"},{"id":"b","text":"الشهيق"},{"id":"c","text":"الهضم"},{"id":"d","text":"النبض"}]'::jsonb, 'a', 'الزفيرُ هو إخراجُ الهواء المحمّل بثاني أكسيد الكربون من الرئتين.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fcadfa1-c422-577a-a63f-ac6e8515f591', '45614f7e-b1c0-5094-8f09-3d1ee809b452', 'ما الغازُ الذي نأخذُه من الهواء عند التنفّس؟', '[{"id":"a","text":"الأكسجين"},{"id":"b","text":"ثاني أكسيد الكربون"},{"id":"c","text":"الآزوت"},{"id":"d","text":"الدخان"}]'::jsonb, 'a', 'نأخذُ الأكسجينَ من الهواء، فهو الغازُ الضروريُّ لنشاط الجسم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('159c036b-42bc-56a3-aaf8-969b97f1496f', '45614f7e-b1c0-5094-8f09-3d1ee809b452', 'ما الغازُ الذي نطرحُه بكثرةٍ عند الزفير؟', '[{"id":"a","text":"ثاني أكسيد الكربون"},{"id":"b","text":"الأكسجين"},{"id":"c","text":"الآزوت"},{"id":"d","text":"الهيليوم"}]'::jsonb, 'a', 'نطرحُ هواءً غنيًّا بثاني أكسيد الكربون عند الزفير.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d03b54c-9422-51dc-85ff-7d37a59ac103', '45614f7e-b1c0-5094-8f09-3d1ee809b452', 'من أين يدخلُ الهواءُ إلى جهاز التنفّس عادةً؟', '[{"id":"a","text":"الأنف"},{"id":"b","text":"الأذن"},{"id":"c","text":"العين"},{"id":"d","text":"الجلد"}]'::jsonb, 'a', 'يدخلُ الهواءُ عبر الأنف ثمّ يمرّ في القصبة الهوائيّة نحو الرئتين.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c9471038-aa68-5d23-9828-c6787a18a851', '38976f55-d157-591a-9efd-ad38e0e0b33a', 'eveil-scientifique-6eme', '⚔️ زعيم الفصل ⭐⭐⭐: تحدّي التنفّس', 3, 120, 30, 'boss', 'admin', 2)
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
  ('6214cf7a-e549-588d-8cbb-b406af16aff0', 'c9471038-aa68-5d23-9828-c6787a18a851', 'أين يحدثُ التبادلُ الغازيّ في جهاز التنفّس؟', '[{"id":"a","text":"في الحويصلات الهوائيّة"},{"id":"b","text":"في الأنف"},{"id":"c","text":"في القصبة الهوائيّة فقط"},{"id":"d","text":"في المريء"}]'::jsonb, 'a', 'يتمّ التبادلُ الغازيُّ في الحويصلات الهوائيّة الدقيقة داخل الرئتين.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('abc98ba8-9d5c-5498-acc1-f743901e7879', 'c9471038-aa68-5d23-9828-c6787a18a851', 'في الرئتين، ينتقلُ الأكسجينُ من الحويصلات إلى:', '[{"id":"a","text":"الدم"},{"id":"b","text":"المعدة"},{"id":"c","text":"العظام"},{"id":"d","text":"خارج الجسم مباشرة"}]'::jsonb, 'a', 'ينتقلُ الأكسجينُ من الحويصلات إلى الدم الذي يوزّعُه على أعضاء الجسم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a559640-7cd6-5fe1-ae7e-81f1de11de8e', 'c9471038-aa68-5d23-9828-c6787a18a851', 'ما الترتيبُ الصحيحُ لمسار الهواء عند الشهيق؟', '[{"id":"a","text":"الأنف ← القصبة الهوائيّة ← الرئتان"},{"id":"b","text":"الرئتان ← الأنف ← القصبة الهوائيّة"},{"id":"c","text":"القصبة الهوائيّة ← الأنف ← الرئتان"},{"id":"d","text":"الأنف ← المعدة ← الرئتان"}]'::jsonb, 'a', 'يدخلُ الهواءُ من الأنف، ثمّ يمرّ في القصبة الهوائيّة، ليصلَ إلى الرئتين.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67b14cb9-a119-57db-8eba-706116074617', 'c9471038-aa68-5d23-9828-c6787a18a851', 'لماذا يكون هواءُ الزفير غنيًّا بثاني أكسيد الكربون؟', '[{"id":"a","text":"لأنّ الدمَ ينقلُه من الأعضاء إلى الرئتين ليُطرح"},{"id":"b","text":"لأنّنا نأكلُ ثاني أكسيد الكربون"},{"id":"c","text":"لأنّ الرئتين تصنعان الأكسجين"},{"id":"d","text":"لأنّ الأنفَ يبرّدُ الهواء"}]'::jsonb, 'a', 'ينتجُ الجسمُ ثاني أكسيد الكربون، فينقلُه الدمُ إلى الرئتين ليُطرحَ مع هواء الزفير.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7f33503-b459-5d27-adc8-d84ddd9cff08', 'c9471038-aa68-5d23-9828-c6787a18a851', 'ماذا ينقلُ الدمُ انطلاقًا من الرئتين إلى بقيّة الأعضاء؟', '[{"id":"a","text":"الأكسجين"},{"id":"b","text":"ثاني أكسيد الكربون فقط"},{"id":"c","text":"الهواءَ كاملًا"},{"id":"d","text":"الفضلاتِ الصلبة"}]'::jsonb, 'a', 'بعد التبادل في الرئتين، ينقلُ الدمُ الأكسجينَ إلى كلّ أعضاء الجسم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd185a0c-5964-5921-89c5-6efda6cc9cd4', 'c9471038-aa68-5d23-9828-c6787a18a851', 'ما وظيفةُ القصبة الهوائيّة؟', '[{"id":"a","text":"نقلُ الهواء بين الأنف والرئتين"},{"id":"b","text":"هضمُ الطعام"},{"id":"c","text":"ضخُّ الدم"},{"id":"d","text":"تخزينُ الماء"}]'::jsonb, 'a', 'القصبةُ الهوائيّة أنبوبٌ ينقلُ الهواءَ بين الأنف والرئتين.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('93e3ff54-751f-5338-9891-ed7496283db4', '38976f55-d157-591a-9efd-ad38e0e0b33a', 'eveil-scientifique-6eme', '⭐⭐ تمرين مراجعة (نمط امتحان): التنفّس', 2, 70, 15, 'practice', 'admin', 3)
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
  ('d8a54c40-6502-5056-bf69-f383bc3a676a', '93e3ff54-751f-5338-9891-ed7496283db4', 'ما هما حركتا التنفّس؟', '[{"id":"a","text":"الشهيق والزفير"},{"id":"b","text":"الأكل والشرب"},{"id":"c","text":"النبض والضغط"},{"id":"d","text":"الهضم والامتصاص"}]'::jsonb, 'a', 'حركتا التنفّس هما الشهيق (إدخال الهواء) والزفير (إخراجه).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7655934-9e62-5a01-a5ed-22de92ae59cb', '93e3ff54-751f-5338-9891-ed7496283db4', 'ما العضو الذي يصلُ إليه الهواءُ في نهاية مساره؟', '[{"id":"a","text":"الرئتان"},{"id":"b","text":"المعدة"},{"id":"c","text":"الكبد"},{"id":"d","text":"الأمعاء"}]'::jsonb, 'a', 'يصلُ الهواءُ في نهاية مساره إلى الرئتين حيث يحدثُ التبادلُ الغازيّ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0993075f-f19b-509e-825f-0ed08c7fd454', '93e3ff54-751f-5338-9891-ed7496283db4', 'في الحويصلات، ينتقلُ ثاني أكسيد الكربون من الدم إلى:', '[{"id":"a","text":"الهواء ليُطرحَ بالزفير"},{"id":"b","text":"العظام"},{"id":"c","text":"المعدة"},{"id":"d","text":"العضلات"}]'::jsonb, 'a', 'ينتقلُ ثاني أكسيد الكربون من الدم إلى الهواء في الحويصلات، ثمّ يُطرحُ بالزفير.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18063625-8d57-5ff3-928c-639e90c4fa14', '93e3ff54-751f-5338-9891-ed7496283db4', 'هواءُ الشهيق غنيٌّ بـ:', '[{"id":"a","text":"الأكسجين"},{"id":"b","text":"ثاني أكسيد الكربون"},{"id":"c","text":"الدخان"},{"id":"d","text":"بخار الزيت"}]'::jsonb, 'a', 'هواءُ الشهيق هو هواءُ الجوّ، وهو غنيٌّ بالأكسجين.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a967509-b002-58fc-b16d-d5ffd9242d63', '93e3ff54-751f-5338-9891-ed7496283db4', 'لماذا نتنفّس؟', '[{"id":"a","text":"لأخذ الأكسجين وطرح ثاني أكسيد الكربون"},{"id":"b","text":"لهضم الطعام"},{"id":"c","text":"لتبريد الدم فقط"},{"id":"d","text":"لإنتاج الأكسجين"}]'::jsonb, 'a', 'نتنفّسُ لتزويد الجسم بالأكسجين وللتخلّص من ثاني أكسيد الكربون.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('608c5491-da95-5c7d-893e-750d1b7b6f9d', '93e3ff54-751f-5338-9891-ed7496283db4', 'إذا انسدّت القصبةُ الهوائيّة تمامًا، فما النتيجة؟', '[{"id":"a","text":"لا يصلُ الهواءُ إلى الرئتين"},{"id":"b","text":"يتحسّنُ التنفّس"},{"id":"c","text":"يزدادُ الأكسجين في الدم"},{"id":"d","text":"لا يتغيّرُ شيء"}]'::jsonb, 'a', 'القصبةُ الهوائيّة ممرُّ الهواء؛ فانسدادُها يمنعُ وصولَ الهواء إلى الرئتين.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('83144a7b-33cd-5d46-981e-0d6aea1b6c3f', '38976f55-d157-591a-9efd-ad38e0e0b33a', 'eveil-scientifique-6eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّدُ التنفّس', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('1f99edab-6543-54c6-ac7b-77f9f4a1d8c7', '83144a7b-33cd-5d46-981e-0d6aea1b6c3f', 'أين بالضبط يتمّ التبادلُ الغازيّ بين الهواء والدم؟', '[{"id":"a","text":"في الحويصلات الهوائيّة"},{"id":"b","text":"في القلب"},{"id":"c","text":"في المعدة"},{"id":"d","text":"في الكلى"}]'::jsonb, 'a', 'الحويصلاتُ الهوائيّة هي السطحُ الذي يتمّ عنده مرورُ الغازات بين الهواء والدم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c03e30e1-b023-51fb-a85a-c0398441f94c', '83144a7b-33cd-5d46-981e-0d6aea1b6c3f', 'أيُّ جملةٍ صحيحةٌ عند مقارنة هواء الزفير بهواء الشهيق؟', '[{"id":"a","text":"الزفيرُ نسبةُ ثاني أكسيد الكربون فيه أعلى"},{"id":"b","text":"الزفيرُ خالٍ تمامًا من الأكسجين"},{"id":"c","text":"الشهيقُ غنيٌّ بثاني أكسيد الكربون"},{"id":"d","text":"لا فرقَ بينهما إطلاقًا"}]'::jsonb, 'a', 'بعد التبادل في الرئتين ترتفعُ نسبةُ ثاني أكسيد الكربون في هواء الزفير مقارنةً بالشهيق.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('386d67af-7e63-5a6a-8a0c-e2509a41a81b', '83144a7b-33cd-5d46-981e-0d6aea1b6c3f', 'ما العلاقةُ بين التنفّس والدم؟', '[{"id":"a","text":"الدمُ يأخذُ الأكسجين من الرئتين وينقلُه للأعضاء"},{"id":"b","text":"لا علاقةَ بينهما"},{"id":"c","text":"الدمُ يصنعُ الهواء"},{"id":"d","text":"الرئتان تضخّان الدم"}]'::jsonb, 'a', 'في الرئتين يلتقطُ الدمُ الأكسجينَ ويتخلّصُ من ثاني أكسيد الكربون، ثمّ ينقلُ الأكسجينَ للأعضاء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('39959081-838f-544e-bc60-b45818a9f0ce', '83144a7b-33cd-5d46-981e-0d6aea1b6c3f', 'لماذا يتسارعُ تنفّسُنا بعد الجري؟', '[{"id":"a","text":"لأنّ الجسمَ يحتاجُ أكسجينًا أكثر فنتنفّسُ أسرع"},{"id":"b","text":"لأنّ الرئتين تتعبان وتتوقّفان"},{"id":"c","text":"لأنّنا لا نحتاجُ أكسجينًا أثناء الجري"},{"id":"d","text":"لأنّ الهواءَ يصبحُ أثقل"}]'::jsonb, 'a', 'يزيدُ نشاطُ العضلات الحاجةَ إلى الأكسجين، فيتسارعُ التنفّسُ لتوفيره وطرد ثاني أكسيد الكربون الزائد.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b93f158a-23c1-5475-9070-bd3f7855aaa8', '83144a7b-33cd-5d46-981e-0d6aea1b6c3f', 'ما الذي يميّزُ هواءَ الشهيق؟', '[{"id":"a","text":"أنّه أغنى بالأكسجين"},{"id":"b","text":"أنّه أغنى بثاني أكسيد الكربون"},{"id":"c","text":"أنّه بلا أكسجين"},{"id":"d","text":"أنّه دخانٌ كثيف"}]'::jsonb, 'a', 'هواءُ الشهيق هو هواءُ الجوّ الغنيُّ بالأكسجين قبل أن يأخذَ الجسمُ حاجتَه منه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3cd1045-3d9f-55ce-9308-aa21205f383b', '83144a7b-33cd-5d46-981e-0d6aea1b6c3f', 'ما دورُ الحويصلات الهوائيّة الدقيقة في الرئتين؟', '[{"id":"a","text":"توفّرُ سطحًا واسعًا للتبادل الغازيّ مع الدم"},{"id":"b","text":"تهضمُ الطعام"},{"id":"c","text":"تضخُّ الدم"},{"id":"d","text":"تخزّنُ البول"}]'::jsonb, 'a', 'الحويصلاتُ الكثيرةُ توفّرُ سطحًا واسعًا يسمحُ بتبادلٍ غازيٍّ سريعٍ بين الهواء والدم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9ce85352-fd3a-5438-b2c8-5490dc648e59', '38976f55-d157-591a-9efd-ad38e0e0b33a', 'eveil-scientifique-6eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملةٌ للتنفّس', 3, 120, 30, 'boss', 'admin', 5)
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
  ('76e167cd-8d4e-5be5-85ef-6fc2c010ef91', '9ce85352-fd3a-5438-b2c8-5490dc648e59', 'ما العضو المسؤولُ عن التنفّس؟', '[{"id":"a","text":"الرئتان"},{"id":"b","text":"المعدة"},{"id":"c","text":"الطحال"},{"id":"d","text":"المثانة"}]'::jsonb, 'a', 'الرئتان هما عضوُ التنفّس حيث يحدثُ التبادلُ الغازيّ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25767b39-8d52-50ae-84b5-430398ee5bf3', '9ce85352-fd3a-5438-b2c8-5490dc648e59', 'الشهيقُ هو:', '[{"id":"a","text":"إدخالُ الهواء إلى الرئتين"},{"id":"b","text":"إخراجُ الهواء من الرئتين"},{"id":"c","text":"بلعُ الطعام"},{"id":"d","text":"ضخُّ الدم"}]'::jsonb, 'a', 'الشهيقُ هو إدخالُ الهواء الغنيّ بالأكسجين إلى الرئتين.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dcd9b827-88b9-54d0-8744-f6a7c258031c', '9ce85352-fd3a-5438-b2c8-5490dc648e59', 'ما الغازُ الذي يكثرُ في هواء الزفير؟', '[{"id":"a","text":"ثاني أكسيد الكربون"},{"id":"b","text":"الأكسجين"},{"id":"c","text":"الآزوت وحدَه"},{"id":"d","text":"الأوزون"}]'::jsonb, 'a', 'يكثرُ ثاني أكسيد الكربون في هواء الزفير لأنّ الجسمَ يطرحُه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1cc0ee4d-cb5d-5c0c-bcf1-95ef5f970df4', '9ce85352-fd3a-5438-b2c8-5490dc648e59', 'ما الترتيبُ الصحيحُ لمسار الهواء؟', '[{"id":"a","text":"الأنف ← القصبة الهوائيّة ← الرئتان"},{"id":"b","text":"الفم ← المعدة ← الرئتان"},{"id":"c","text":"الرئتان ← القصبة الهوائيّة ← الأنف"},{"id":"d","text":"الأنف ← الرئتان ← القصبة الهوائيّة"}]'::jsonb, 'a', 'يسلكُ الهواءُ المسار: الأنف ← القصبة الهوائيّة ← الرئتان.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4bb77781-f351-5501-9e6d-237773298888', '9ce85352-fd3a-5438-b2c8-5490dc648e59', 'في الرئتين ينتقلُ الأكسجينُ إلى الدم عبر:', '[{"id":"a","text":"الحويصلات الهوائيّة"},{"id":"b","text":"العظام"},{"id":"c","text":"الجلد"},{"id":"d","text":"الأظافر"}]'::jsonb, 'a', 'يعبرُ الأكسجينُ من الحويصلات الهوائيّة إلى الدم المحيط بها.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6dd95402-0204-5cd8-9f51-681b9577b53d', '9ce85352-fd3a-5438-b2c8-5490dc648e59', 'لماذا يُعدُّ التنفّسُ ضروريًّا للحياة؟', '[{"id":"a","text":"لأنّه يزوّدُ الجسمَ بالأكسجين اللازم لنشاط الخلايا"},{"id":"b","text":"لأنّه يُنتجُ الطعام"},{"id":"c","text":"لأنّه يبرّدُ الجلد"},{"id":"d","text":"لأنّه يصنعُ العظام"}]'::jsonb, 'a', 'يحتاجُ الجسمُ الأكسجينَ لإنتاج الطاقة في خلاياه، والتنفّسُ هو ما يوفّرُه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('21283609-6e6f-5624-bc24-cedd580c9f0a', 'a5efe929-363c-5e01-a9bc-06eff4fbe288', 'eveil-scientifique-6eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('57e35d02-c3b4-57d0-a79d-c78d60e826b7', '21283609-6e6f-5624-bc24-cedd580c9f0a', 'ما العضو الذي يضخُّ الدمَ في الجسم؟', '[{"id":"a","text":"القلب"},{"id":"b","text":"الرئة"},{"id":"c","text":"المعدة"},{"id":"d","text":"الكبد"}]'::jsonb, 'a', 'القلبُ عضلةٌ تعملُ كمضخّةٍ تدفعُ الدمَ في كامل الجسم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d07f106a-5080-58ba-87c1-5f4b7778c331', '21283609-6e6f-5624-bc24-cedd580c9f0a', 'ما المكوّنُ الذي ينقلُ الأكسجينَ في الدم؟', '[{"id":"a","text":"الكريّات الحمراء"},{"id":"b","text":"الكريّات البيضاء"},{"id":"c","text":"الصفيحات الدمويّة"},{"id":"d","text":"البلازما وحدها"}]'::jsonb, 'a', 'الكريّاتُ الحمراء هي المسؤولةُ عن نقل الأكسجين إلى أعضاء الجسم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f97d3e0d-fc52-58b2-8851-99a53f0ea7b4', '21283609-6e6f-5624-bc24-cedd580c9f0a', 'ما دورُ الكريّات البيضاء؟', '[{"id":"a","text":"الدفاعُ عن الجسم ضدّ الميكروبات"},{"id":"b","text":"نقلُ الأكسجين"},{"id":"c","text":"هضمُ الطعام"},{"id":"d","text":"تبريدُ الجسم"}]'::jsonb, 'a', 'الكريّاتُ البيضاء تدافعُ عن الجسم وتحاربُ الميكروبات المسبّبةَ للأمراض.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff728071-e2ab-5e02-a50f-9a0bae3ec40a', '21283609-6e6f-5624-bc24-cedd580c9f0a', 'ما دورُ الصفيحات الدمويّة؟', '[{"id":"a","text":"تخثّرُ الدم وإيقافُ النزيف"},{"id":"b","text":"نقلُ الأكسجين"},{"id":"c","text":"ضخُّ الدم"},{"id":"d","text":"إنتاجُ الهواء"}]'::jsonb, 'a', 'الصفيحاتُ الدمويّة تساعدُ على تخثّر الدم وإيقاف النزيف عند الجروح.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83feb802-34ba-547d-86f5-afa61e0f361a', '21283609-6e6f-5624-bc24-cedd580c9f0a', 'ما اسمُ الجزء السائل من الدم؟', '[{"id":"a","text":"البلازما"},{"id":"b","text":"الكريّات الحمراء"},{"id":"c","text":"العظام"},{"id":"d","text":"العصارة"}]'::jsonb, 'a', 'البلازما هي الجزءُ السائلُ من الدم، وفيها تسبحُ الكريّاتُ والصفيحات.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ba04966f-d093-56cb-81c9-1dd689f6edc5', 'a5efe929-363c-5e01-a9bc-06eff4fbe288', 'eveil-scientifique-6eme', '⭐ تمرين: أوّلُ خطوات مع الدم', 1, 50, 10, 'practice', 'admin', 1)
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
  ('eb65f3da-8183-580d-a805-1f2d36292a0f', 'ba04966f-d093-56cb-81c9-1dd689f6edc5', 'ما العضو الذي يضخُّ الدم؟', '[{"id":"a","text":"القلب"},{"id":"b","text":"الرئة"},{"id":"c","text":"الكلية"},{"id":"d","text":"الدماغ"}]'::jsonb, 'a', 'القلبُ هو المضخّةُ التي تدفعُ الدمَ في الجسم كلّه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27a56397-91e1-5876-814a-f8283f7a913a', 'ba04966f-d093-56cb-81c9-1dd689f6edc5', 'ما لونُ الدم؟', '[{"id":"a","text":"أحمر"},{"id":"b","text":"أزرق"},{"id":"c","text":"أخضر"},{"id":"d","text":"عديمُ اللون"}]'::jsonb, 'a', 'الدمُ سائلٌ أحمرُ اللون بفضل الكريّات الحمراء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6778f97d-b31f-5c85-b06f-f31d204d840f', 'ba04966f-d093-56cb-81c9-1dd689f6edc5', 'ما المكوّنُ الذي ينقلُ الأكسجين؟', '[{"id":"a","text":"الكريّات الحمراء"},{"id":"b","text":"الكريّات البيضاء"},{"id":"c","text":"الصفيحات الدمويّة"},{"id":"d","text":"الماء فقط"}]'::jsonb, 'a', 'الكريّاتُ الحمراء تنقلُ الأكسجينَ إلى أعضاء الجسم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('509f07d9-78c5-573f-bfe1-c6a40f324ce2', 'ba04966f-d093-56cb-81c9-1dd689f6edc5', 'ما اسمُ الجزء السائل من الدم؟', '[{"id":"a","text":"البلازما"},{"id":"b","text":"الصفيحات"},{"id":"c","text":"العظم"},{"id":"d","text":"اللعاب"}]'::jsonb, 'a', 'البلازما هي السائلُ الذي يحملُ مكوّناتِ الدم والمغذّيات.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a43c0482-0ff7-54b7-892b-e9a96e9f316d', 'ba04966f-d093-56cb-81c9-1dd689f6edc5', 'ما دورُ الكريّات البيضاء؟', '[{"id":"a","text":"الدفاعُ عن الجسم"},{"id":"b","text":"نقلُ الأكسجين"},{"id":"c","text":"ضخُّ الدم"},{"id":"d","text":"تكوينُ العظام"}]'::jsonb, 'a', 'الكريّاتُ البيضاء تدافعُ عن الجسم ضدّ الميكروبات.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('789f77cb-8f58-51f6-b872-c6db571d7355', 'ba04966f-d093-56cb-81c9-1dd689f6edc5', 'ما الذي يوقفُ النزيفَ عند جرحٍ صغير؟', '[{"id":"a","text":"الصفيحات الدمويّة"},{"id":"b","text":"الكريّات الحمراء"},{"id":"c","text":"البلازما وحدها"},{"id":"d","text":"الأكسجين"}]'::jsonb, 'a', 'الصفيحاتُ الدمويّة تساعدُ على تخثّر الدم فيتوقّفُ النزيف.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('25e852eb-166d-5524-beb5-573294fd9eb6', 'a5efe929-363c-5e01-a9bc-06eff4fbe288', 'eveil-scientifique-6eme', '⚔️ زعيم الفصل ⭐⭐⭐: تحدّي الدم', 3, 120, 30, 'boss', 'admin', 2)
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
  ('4251c047-26f4-55a4-b131-ee1af87d5bef', '25e852eb-166d-5524-beb5-573294fd9eb6', 'القلبُ في جهاز الدوران يعملُ كـ:', '[{"id":"a","text":"مضخّةٍ تدفعُ الدم"},{"id":"b","text":"مصفاةٍ للهواء"},{"id":"c","text":"خزّانٍ للطعام"},{"id":"d","text":"غدّةٍ للعرق"}]'::jsonb, 'a', 'القلبُ مضخّةٌ عضليّةٌ تدفعُ الدمَ في الأوعية إلى كامل الجسم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce65fa02-3925-56b9-bad1-1e1a4f856b5c', '25e852eb-166d-5524-beb5-573294fd9eb6', 'ماذا ينقلُ الدمُ إلى الأعضاء؟', '[{"id":"a","text":"الأكسجين والمغذّيات"},{"id":"b","text":"العظام"},{"id":"c","text":"الفضلاتِ فقط"},{"id":"d","text":"الهواءَ كاملًا"}]'::jsonb, 'a', 'ينقلُ الدمُ الأكسجينَ من الرئتين والمغذّياتِ من الأمعاء إلى كلّ الأعضاء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5dd3b035-e4b9-56bc-8d84-bb098ef7e407', '25e852eb-166d-5524-beb5-573294fd9eb6', 'ما الأوعيةُ التي يخرجُ فيها الدمُ من القلب؟', '[{"id":"a","text":"الشرايين"},{"id":"b","text":"الأوردة"},{"id":"c","text":"القصبة الهوائيّة"},{"id":"d","text":"المريء"}]'::jsonb, 'a', 'الشرايينُ هي الأوعيةُ التي يخرجُ فيها الدمُ من القلب نحو الأعضاء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7cfe7c7b-ef68-57d9-8143-948130313ce7', '25e852eb-166d-5524-beb5-573294fd9eb6', 'ماذا ينقلُ الدمُ بعيدًا عن الأعضاء ليُطرح؟', '[{"id":"a","text":"ثاني أكسيد الكربون والفضلات"},{"id":"b","text":"الأكسجين والمغذّيات"},{"id":"c","text":"العظامَ والعضلات"},{"id":"d","text":"الكريّاتِ الحمراء فقط"}]'::jsonb, 'a', 'يحملُ الدمُ ثاني أكسيد الكربون والفضلاتِ بعيدًا عن الأعضاء لطرحها (عبر الرئتين والكلى).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2841e9e5-9800-5ec2-bf00-6f62c4357b3e', '25e852eb-166d-5524-beb5-573294fd9eb6', 'لماذا يجبُ أن يدورَ الدمُ في الجسم باستمرار؟', '[{"id":"a","text":"ليصلَ الأكسجينُ والغذاءُ إلى كلّ الخلايا"},{"id":"b","text":"ليبقى الجسمُ ساكنًا"},{"id":"c","text":"ليصنعَ الهواء"},{"id":"d","text":"ليُوقفَ نبضَ القلب"}]'::jsonb, 'a', 'دورانُ الدم المستمرُّ يضمنُ وصولَ الأكسجين والغذاء لكلّ خلايا الجسم وإزالةَ الفضلات.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6fbf4970-b44d-57ae-8fef-942a73ec719d', '25e852eb-166d-5524-beb5-573294fd9eb6', 'لماذا تكثرُ الكريّاتُ الحمراء في الدم؟', '[{"id":"a","text":"لأنّها تنقلُ الأكسجينَ إلى كلّ الجسم"},{"id":"b","text":"لأنّها تهضمُ الطعام"},{"id":"c","text":"لأنّها تصنعُ العظام"},{"id":"d","text":"لأنّها تطردُ العرق"}]'::jsonb, 'a', 'يحتاجُ الجسمُ كمّيّةً كبيرةً من الأكسجين، لذلك تكثرُ الكريّاتُ الحمراءُ الناقلةُ له.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5a8adbb4-f4f5-51ac-bbee-71e52c439c0a', 'a5efe929-363c-5e01-a9bc-06eff4fbe288', 'eveil-scientifique-6eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الدم', 2, 70, 15, 'practice', 'admin', 3)
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
  ('5346b05b-37c7-5fd6-aeda-1ef357eb8278', '5a8adbb4-f4f5-51ac-bbee-71e52c439c0a', 'ممّ يتكوّنُ الدم؟', '[{"id":"a","text":"بلازما وكريّات حمراء وبيضاء وصفيحات"},{"id":"b","text":"ماءٍ وملحٍ فقط"},{"id":"c","text":"عظامٍ وعضلات"},{"id":"d","text":"أكسجينٍ وحدَه"}]'::jsonb, 'a', 'يتكوّنُ الدمُ من البلازما والكريّات الحمراء والكريّات البيضاء والصفيحات الدمويّة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('38dc6a97-457f-5c42-b02e-069a87a11bc3', '5a8adbb4-f4f5-51ac-bbee-71e52c439c0a', 'ما الذي ينقلُ الأكسجينَ في الدم؟', '[{"id":"a","text":"الكريّات الحمراء"},{"id":"b","text":"الكريّات البيضاء"},{"id":"c","text":"الصفيحات"},{"id":"d","text":"البلازما وحدها"}]'::jsonb, 'a', 'الكريّاتُ الحمراء هي ناقلُ الأكسجين في الدم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fbd347fa-698b-5e74-9e4c-049422a29781', '5a8adbb4-f4f5-51ac-bbee-71e52c439c0a', 'ما العضو المضخّةُ في جهاز الدوران؟', '[{"id":"a","text":"القلب"},{"id":"b","text":"الرئة"},{"id":"c","text":"الكبد"},{"id":"d","text":"المعدة"}]'::jsonb, 'a', 'القلبُ هو المضخّةُ التي تحرّكُ الدمَ في الأوعية.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87623f38-b4f1-5bed-ab71-9b216463a61b', '5a8adbb4-f4f5-51ac-bbee-71e52c439c0a', 'الأوردةُ هي الأوعيةُ التي يرجعُ فيها الدمُ إلى:', '[{"id":"a","text":"القلب"},{"id":"b","text":"الرئة مباشرة فقط"},{"id":"c","text":"المعدة"},{"id":"d","text":"الجلد"}]'::jsonb, 'a', 'الأوردةُ تُرجعُ الدمَ إلى القلب، بينما الشرايينُ تُخرجُه منه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dfcb43b3-6192-5598-8236-2bcce1004488', '5a8adbb4-f4f5-51ac-bbee-71e52c439c0a', 'ما دورُ الكريّات البيضاء؟', '[{"id":"a","text":"الدفاعُ عن الجسم ومحاربةُ الميكروبات"},{"id":"b","text":"نقلُ الأكسجين"},{"id":"c","text":"إيقافُ النزيف"},{"id":"d","text":"ضخُّ الدم"}]'::jsonb, 'a', 'الكريّاتُ البيضاء جنودُ الجسم: تدافعُ عنه وتحاربُ الميكروبات.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('deda32eb-75cc-532a-bfbd-f824f2f9d810', '5a8adbb4-f4f5-51ac-bbee-71e52c439c0a', 'عند جرحِ إصبعك يسيلُ الدمُ ثمّ يتوقّف. ما الذي ساعدَ على إيقافه؟', '[{"id":"a","text":"الصفيحات الدمويّة"},{"id":"b","text":"الكريّات الحمراء"},{"id":"c","text":"البلازما وحدها"},{"id":"d","text":"الأكسجين"}]'::jsonb, 'a', 'الصفيحاتُ الدمويّة تُحدثُ تخثّرَ الدم فيتوقّفُ النزيف.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d97ff5d4-e6f6-54be-8c0f-eaf6fe2e1a2a', 'a5efe929-363c-5e01-a9bc-06eff4fbe288', 'eveil-scientifique-6eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّدُ جهاز الدوران', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('811267f4-0bee-574b-b9f1-76291e74a596', 'd97ff5d4-e6f6-54be-8c0f-eaf6fe2e1a2a', 'أيُّ مكوّنٍ من الدم يدافعُ عن الجسم ضدّ الميكروبات؟', '[{"id":"a","text":"الكريّات البيضاء"},{"id":"b","text":"الكريّات الحمراء"},{"id":"c","text":"الصفيحات"},{"id":"d","text":"البلازما"}]'::jsonb, 'a', 'الكريّاتُ البيضاء هي خطُّ الدفاع الذي يحاربُ الميكروباتِ في الجسم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d96dc9dc-8f78-5259-aded-3995906da600', 'd97ff5d4-e6f6-54be-8c0f-eaf6fe2e1a2a', 'ما العلاقةُ بين الدم والتنفّس؟', '[{"id":"a","text":"الدمُ يحملُ الأكسجينَ من الرئتين إلى الأعضاء"},{"id":"b","text":"لا علاقةَ بينهما"},{"id":"c","text":"الدمُ يصنعُ الهواء"},{"id":"d","text":"الدمُ يطردُ الأكسجين خارج الجسم"}]'::jsonb, 'a', 'في الرئتين يلتقطُ الدمُ الأكسجينَ، ثمّ ينقلُه إلى كلّ أعضاء الجسم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('995f1b02-168d-59ae-b2b3-d84204c67ed9', 'd97ff5d4-e6f6-54be-8c0f-eaf6fe2e1a2a', 'ما العلاقةُ بين الدم والتغذية؟', '[{"id":"a","text":"الدمُ ينقلُ المغذّياتِ من الأمعاء إلى الأعضاء"},{"id":"b","text":"الدمُ يهضمُ الطعام"},{"id":"c","text":"الدمُ يصنعُ الطعام"},{"id":"d","text":"لا علاقةَ بينهما"}]'::jsonb, 'a', 'بعد الهضم تمتصُّ الأمعاءُ المغذّيات، فينقلُها الدمُ إلى أعضاء الجسم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b13a435f-81ba-57b4-b009-54a8978d619d', 'd97ff5d4-e6f6-54be-8c0f-eaf6fe2e1a2a', 'ما الفرقُ بين الشريان والوريد؟', '[{"id":"a","text":"الشريانُ يُخرجُ الدمَ من القلب، والوريدُ يُرجعُه إليه"},{"id":"b","text":"كلاهما يُخرجُ الدمَ من القلب"},{"id":"c","text":"الوريدُ ينقلُ الهواء"},{"id":"d","text":"لا فرقَ بينهما"}]'::jsonb, 'a', 'الشرايينُ تحملُ الدمَ خارجًا من القلب، والأوردةُ تُعيدُه إلى القلب.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da55f641-4fd9-5828-8444-472d2388d0fb', 'd97ff5d4-e6f6-54be-8c0f-eaf6fe2e1a2a', 'ماذا يحدثُ لو توقّفَ القلبُ عن ضخّ الدم؟', '[{"id":"a","text":"يتوقّفُ وصولُ الأكسجين والغذاء إلى الأعضاء"},{"id":"b","text":"يتحسّنُ نشاطُ الأعضاء"},{"id":"c","text":"يزدادُ الأكسجينُ في الجسم"},{"id":"d","text":"لا يتغيّرُ شيء"}]'::jsonb, 'a', 'بدون ضخّ القلب لا يصلُ الأكسجينُ والغذاءُ إلى الأعضاء، فيتوقّفُ نشاطُها.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c4cd92f-70c9-5c7a-a1f6-af7d4570dc3f', 'd97ff5d4-e6f6-54be-8c0f-eaf6fe2e1a2a', 'مريضٌ شاحبُ اللون ومُتعَبٌ بسبب نقصٍ في كريّاته الحمراء. ما التفسيرُ العلميّ؟', '[{"id":"a","text":"نقصُ الكريّات الحمراء يقلّلُ نقلَ الأكسجين"},{"id":"b","text":"زيادةُ الأكسجين في جسمه"},{"id":"c","text":"كثرةُ الكريّات الحمراء"},{"id":"d","text":"زيادةُ ضخّ القلب"}]'::jsonb, 'a', 'لأنّ الكريّاتِ الحمراء تنقلُ الأكسجين، فنقصُها يقلّلُ الأكسجينَ الواصلَ للأعضاء فيظهرُ الشحوبُ والتعب.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('69aa3ace-412d-5b40-9cef-44addf566012', 'a5efe929-363c-5e01-a9bc-06eff4fbe288', 'eveil-scientifique-6eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملةٌ للدم', 3, 120, 30, 'boss', 'admin', 5)
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
  ('7a23f433-a990-549e-8e5b-42066890bf8b', '69aa3ace-412d-5b40-9cef-44addf566012', 'ما العضو الذي يضخُّ الدم؟', '[{"id":"a","text":"القلب"},{"id":"b","text":"الرئة"},{"id":"c","text":"المعدة"},{"id":"d","text":"العين"}]'::jsonb, 'a', 'القلبُ مضخّةُ الدم التي تعملُ دون توقّف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('200f2a92-1c5e-5594-bd59-6bac9037abf7', '69aa3ace-412d-5b40-9cef-44addf566012', 'الكريّاتُ الحمراء تنقلُ:', '[{"id":"a","text":"الأكسجين"},{"id":"b","text":"العظام"},{"id":"c","text":"الميكروبات"},{"id":"d","text":"الماءَ فقط"}]'::jsonb, 'a', 'الكريّاتُ الحمراء تنقلُ الأكسجينَ إلى أعضاء الجسم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7e5501e-298d-5303-9222-88503da6124d', '69aa3ace-412d-5b40-9cef-44addf566012', 'ما دورُ الكريّات البيضاء؟', '[{"id":"a","text":"الدفاعُ عن الجسم"},{"id":"b","text":"نقلُ الأكسجين"},{"id":"c","text":"تخثّرُ الدم"},{"id":"d","text":"ضخُّ الدم"}]'::jsonb, 'a', 'الكريّاتُ البيضاء تدافعُ عن الجسم وتحاربُ الميكروبات.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82e16296-f6d6-57b6-927e-04c21c48ac31', '69aa3ace-412d-5b40-9cef-44addf566012', 'ماذا ينقلُ الدمُ انطلاقًا من الأمعاء؟', '[{"id":"a","text":"المغذّيات"},{"id":"b","text":"الهواءَ فقط"},{"id":"c","text":"العظام"},{"id":"d","text":"العرق"}]'::jsonb, 'a', 'تمتصُّ الأمعاءُ المغذّياتِ من الطعام فينقلُها الدمُ إلى الأعضاء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('198f99da-24d1-5be9-984c-4c2b81154870', '69aa3ace-412d-5b40-9cef-44addf566012', 'ما الذي يوقفُ النزيفَ عند الجرح؟', '[{"id":"a","text":"الصفيحات الدمويّة"},{"id":"b","text":"الكريّات الحمراء"},{"id":"c","text":"الأكسجين"},{"id":"d","text":"البلازما وحدها"}]'::jsonb, 'a', 'الصفيحاتُ الدمويّة تُسبّبُ تخثّرَ الدم فيتوقّفُ النزيف.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70237436-444d-5abf-912c-37e00c8aa73b', '69aa3ace-412d-5b40-9cef-44addf566012', 'لماذا يُعدُّ الدمُ مهمًّا للحياة؟', '[{"id":"a","text":"لأنّه ينقلُ الأكسجينَ والغذاءَ ويزيلُ الفضلات"},{"id":"b","text":"لأنّه يصنعُ الهواء"},{"id":"c","text":"لأنّه يبرّدُ الجلدَ فقط"},{"id":"d","text":"لأنّه يُنتجُ العظام"}]'::jsonb, 'a', 'الدمُ يحفظُ الحياةَ لأنّه ينقلُ الأكسجينَ والمغذّياتِ لكلّ الأعضاء ويُبعدُ الفضلات.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

