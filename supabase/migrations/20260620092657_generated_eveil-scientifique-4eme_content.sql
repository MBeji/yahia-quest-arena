-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: eveil-scientifique-4eme (Éveil scientifique)
-- Regenerate with: npm run content:build
-- Source of truth: content/eveil-scientifique-4eme/
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
  ('eveil-scientifique-4eme', 'Éveil scientifique', 'اكتشافُ عالَم العلوم: الأسنان والتغذية والحيوانات والماء والهواء والبيئة، وفق برنامج الإيقاظ العلمي للسنة الرابعة من التعليم الأساسي', 'Observation', 'subject-svt', 'Microscope', 2, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '4eme-base'))
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
      AND e.subject_id = 'eveil-scientifique-4eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('0c76d83d-cd47-59b3-ace6-ca8f2f6d0ee5', '8d66ce28-a241-5d1d-91ff-4084da0ad386', '1b4def41-330b-5999-82cb-4f1efc18f759', '6a10141a-ffc1-585c-a953-f86f11531973', '9c9feb27-c715-57a2-914e-566625147e63', '6197f186-04f1-585b-9e6b-fceac1054562', '542538ee-161a-58ab-9984-b7860838d331', '8342fea8-0cbf-594f-9039-8a08850e0396', '80e40f38-3cb0-5890-8c0d-1c73c0c4b5ed', '3ce7d42b-99ff-561e-bc6a-86d57ded0468', 'fa0de5f6-e0b5-5a19-bd27-395705024d6e', 'e1041414-92ed-5f6a-9c94-0e5531bcea7a', 'ede7e4fc-e779-5d88-8c98-1cc175cb038f', '74ddf4d7-826b-5915-84da-18212242f303', 'd2d011af-4368-53e0-af7a-d11f7c66b9a0', 'a55f050e-0d6b-59ae-97ec-a60b173074c4', '3e82ac04-5856-5b37-9e43-c238e1e350ed', 'eaa2887f-1b32-56bf-9438-ebc5c9fbcf63', '707519e4-2fcf-5943-b479-130053ca7290', '5ac393be-9656-5db8-aa22-79fe45ae9f8a', 'f8fc1bb2-58da-5aba-ae8c-3b53c92a3c75', '084190a4-6287-5d34-b93e-dfeabd5a5652', 'cd271de0-14b5-55a1-a5a1-ee2007f675fd', '6cbcb7e0-d9c8-54cd-a172-13c94193132a', '1a081b9a-2114-5ee0-8a91-e3b564be93b5', 'ba2a237a-dddf-5e32-8f96-4f63dd5d075f', 'e18634d9-c838-5c49-8a22-60d2e3a713e8', '7e736a41-19df-594e-8fda-9c75a6adf4d4', '33813b1c-2ca2-54df-8530-5ed3b9d459e9', 'b0d63013-0a39-5e43-92f5-785746735fce', '8bfa4954-bab3-5dbf-af8e-cbf4ffe4e7d6', 'f4ebfa5a-4093-5247-ac84-b7787ca3f27c', '40de2b8d-33ec-525c-b064-1ae7c94504bb', 'b8edc06c-e677-5cb8-9488-3b3921276338', '68e17039-f47a-595d-9901-52961e4cabaf', 'd3ff98d7-62e1-54f3-aea5-8e5a64e64d7c', '1a77d471-61f2-5ec5-9a95-a6488bd6d0c4', 'c293c1dd-cb69-594e-9124-518d7e208003', 'f128a54e-9d7b-5e95-ab6b-cdab9243e08e', '5dc097e4-ac70-5cc6-918b-53b302591c1c', '9aeaf4fa-32aa-515a-87b2-58ab4009de78', 'acb7f453-a2cc-5cc7-b71a-ecd10fd540ba', '0380faa9-4a08-5ac3-8953-5466127e0e59', '86f7cb8e-4e3e-5896-9e40-24aca9a83752', '7dd303ac-a904-50f9-bd50-b819e06429e6', '63036159-bb1f-5661-aa54-c06d41f68626', '69de082a-0bbb-586a-bdef-695a50c2d764', 'cf0550b8-7f84-5ea6-bec5-3eda0f4b8a04', 'a43c24c4-3dad-53a2-a8f5-3a7564f99cb7', 'a5c2f542-d8ba-55c9-9941-74b38513d5e3', 'd7052fd4-b85d-51af-89b3-4b15275a3f30', 'f5958931-d78d-5ca2-adee-1f310675092e', '23a87c8a-6a27-5267-a316-4d3b5b995840', '81301fb5-eee0-5e8e-9aa7-09e924c95822', 'edd61b7f-9dd2-5e89-8479-a026cad2ffc5', 'b2edca35-6bb9-52be-91c7-6101604568c4', '9cca089a-2d1c-5817-ad90-83931a4f8435', '80ecc15d-4877-59ef-9977-81e0ea02531e', '6071cb69-b784-5199-a037-b032c1824ba2', '44648260-ca2f-5875-86cc-49f644477c26', 'f3727d3f-f97b-5462-8684-f842621eae1f', '578b3b8d-0c84-5d4a-b347-f9ed37484b04', 'a25198f4-a080-557b-8da2-deaef62a055c', '96315407-d1b3-5555-a4da-692c11723bbf', '5e9daeb3-8a4b-5e3f-9a40-2f4ddab5326e', 'd8afa6e8-6858-581c-a50f-745dd391b5fa', 'f7e40bb9-75b7-5b8b-a3d0-497a54be6413', 'b1317621-009c-5ec2-9ff6-a939f89924cb', 'c442218f-ce95-5695-a4a3-a8ee58f934b7', '5e45565c-d5ea-5405-99b0-650f98722a7c', '9c740891-3ff8-5263-8f15-17139673634f', '0ad10810-03d2-5316-9e55-9aa8e4d142da', '0bbfa6b0-9075-5606-9645-51504d6e198c', '91da652f-7de0-573d-849e-7f2de35988a5', '9f5bdad6-0cd8-511e-bd96-a1dd8de9e45f', 'e6a67201-5ade-5e4f-a794-11c5893bd7cc', 'ddf3c54e-7180-5e1e-b71e-898adeeda33d', 'a819b559-9cf4-56d0-9f79-51aaff3566e0', '0e91ac39-f438-5607-b61a-cd31aee99ea8', '8ea6a3dd-2fdc-5db5-a85f-6239ac88502e', '4c889908-8a76-5eee-ba89-eb6d7b1364b3', '177dae34-bfd9-58ad-8c56-43c2f9f3469b', 'eca6f859-328e-520a-a576-f8e3798d95ca', '6c2e1db7-c849-56a7-be93-a4c2b468521f', '22796fab-e111-58cc-9309-a20f4cf6f1f5', 'ac998c1c-7ad7-5ff4-b050-3b65745b47e2', '377be3f8-a9ea-55e5-9291-b1801810673d', '87aabf01-d2a1-50ac-ba47-dc60f811a48d', 'f88142c8-0b26-5bc0-8004-89aaac96bc05', 'ecbc54b2-57f4-5088-8277-79040297bcfc', '1bce382a-f1cd-51f5-abf3-48f8198f9767', '9365ffdd-862e-57ac-855b-dec527e2a327', 'cc25120c-e6f1-5e32-a63d-5685e91a0c32', 'fcb92794-4fb8-5245-af4d-c3c2c4941e09', 'a2e3dc0d-dede-52a8-8179-27b239ccde5f', 'f5cd8817-7d20-50a3-8d0f-626631cb2da9', '99d62e06-46f1-58a8-81a7-4be68941a913', '0a71e2b0-9bcd-5727-bb9f-7a6f855465d5', '46e7944f-2911-5c28-b48a-d3ff6cb972af', 'c83e45ec-bd21-5a04-b925-20a1c76a3eaa', 'e7b35c0b-b315-5676-950b-2e615d7a107e', '98950c03-51e1-50f5-9ad9-b30e1abdebef', 'c57b906a-673a-5163-b376-9ba577960882', '8138a419-b453-5e6a-8512-6c35b6b5b5df', 'b10e97f1-58e0-556b-bd34-b4645779bd17', 'b5114512-5481-58ad-a8b5-20c09477e977', '74f502e1-e030-5508-85da-89b0549dead8', '6dd3fb9d-5ca5-5b28-82ca-a802f58bdbe0', '5fe0606d-7d83-55b3-aafd-b3b2a17c6adc', 'ff378a4b-c836-5851-a638-bab1aa427fb7', '06921fe4-f12d-5819-bcb9-fb6cfb8c474f', '7bc21821-b7d9-58b7-9eb9-1ba5d1c76989', '34b87d64-b37f-5207-86d9-9687a37c6575', '16df95b9-1878-5b0f-b072-5cf0d3c2f3de', '038c1806-31cd-52ba-a3bd-a74952fc5160', '4766d3df-f751-5f3e-b589-b27f34a1797c', '3e2257d6-5887-54f3-9930-c382e195d814', 'eaf483b2-fe2f-56e2-a95c-5d559a3b86e1', '0f1cb49c-836b-5e6b-acf1-ac6408ed2b36', '07d176ad-6a11-52db-b775-f7ea94a16541', 'c27d9b54-51db-5336-b8a3-cb7ee8c67fd8', '0306b933-68a8-589a-ab42-bc308ab17199', 'cfefd04f-b06d-548c-b830-7596a0d53a8c', '88d2d2fb-6b78-5bcb-adcb-d05667e58cf9', '981dfe9f-8c02-5878-b22c-ae23fd96ff06', '0a0e57ea-6c17-5aea-a09e-446cd5033035', '6fef9846-a6a2-5d08-b046-10b770cd1a97', '3bb995a9-bd1a-539a-aca3-2e75734bf0f5', '6e419c49-1772-5ba8-be34-708f001fb5b2', 'cab434eb-d6fa-52ed-9139-d4c29aa6df2d', 'f9df0e6a-2d5b-5dc3-b9a1-058dc6bf1cac', '93f3e1aa-e44f-57c0-9eb7-95387cdf8909', '825ed756-9b28-531f-bf57-be06295067c2', 'ac795e98-9ade-5e8a-a543-4048eff19191', '561de8d7-a7ce-5160-93f0-7295b3ee9269', '237af36f-b12b-5a2a-9a86-4bea5e923473', 'f08d3114-6bcb-53f8-b501-0f39ff8dfd3b', 'c2649d9d-d1d3-59da-8949-18ec29ac29bb', '0b7a65b1-fe99-55f5-b9e1-d7b3196e5d45', 'a8fc9ba6-2400-5d15-806a-4d3caead4899');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'eveil-scientifique-4eme' AND source = 'admin' AND id NOT IN ('b71f0680-2d69-58a7-a13d-22e0da126998', '80da2bee-6cec-5c07-819b-100636e30822', '74169495-aa5d-5b8a-a3a8-abc6199c0671', 'c6cab2c9-752f-5dc1-961a-4754d9ab9173', '70be6344-f68f-5069-a98b-fad45e53090a', 'cd4202a6-c60f-51c2-ad16-b8e628fd1131', '36e632a2-9b7a-5e07-8ce2-fedd6019dcdc', '53806760-025b-5607-a36f-c06aa58cb33d', '6efea3ef-f8ab-5f00-b008-2a6769877d9e', '49c12746-5cb9-55e9-970f-4f0fbb5e97a7', '4c35245e-5203-53aa-817f-2da7da2807d9', '0f554f05-97ae-5925-9ecf-e878d1738b42', 'bb1fd612-5940-561f-85a1-d6528f52c8ae', 'bd6c71f0-aef6-57d9-9c50-96d60dd83528', '1b604c61-0148-528e-ac2c-6bd85fa66a1a', '1c5f09ce-cf0b-5a6e-a592-1e202e1fb1ae', 'cc23f918-d59a-5571-a1cc-f0dcab282398', 'dbef3294-54da-52c4-95eb-57ea1057f597', 'a9803256-d8ec-55b7-ad38-4429605f21e4', '47cf114e-a8fd-50df-a526-2356d8ce5ca7', '19632060-b4a8-5a58-923a-baeaa00b3343', '07f68222-195a-501b-b8f7-79d55b1d4c95', '23a72c36-c437-5f07-a2c0-5d238cc76681', '34d0c10d-e0d7-5829-bcbb-cdfbcd39adf3');
DELETE FROM public.questions WHERE exercise_id IN ('b71f0680-2d69-58a7-a13d-22e0da126998', '80da2bee-6cec-5c07-819b-100636e30822', '74169495-aa5d-5b8a-a3a8-abc6199c0671', 'c6cab2c9-752f-5dc1-961a-4754d9ab9173', '70be6344-f68f-5069-a98b-fad45e53090a', 'cd4202a6-c60f-51c2-ad16-b8e628fd1131', '36e632a2-9b7a-5e07-8ce2-fedd6019dcdc', '53806760-025b-5607-a36f-c06aa58cb33d', '6efea3ef-f8ab-5f00-b008-2a6769877d9e', '49c12746-5cb9-55e9-970f-4f0fbb5e97a7', '4c35245e-5203-53aa-817f-2da7da2807d9', '0f554f05-97ae-5925-9ecf-e878d1738b42', 'bb1fd612-5940-561f-85a1-d6528f52c8ae', 'bd6c71f0-aef6-57d9-9c50-96d60dd83528', '1b604c61-0148-528e-ac2c-6bd85fa66a1a', '1c5f09ce-cf0b-5a6e-a592-1e202e1fb1ae', 'cc23f918-d59a-5571-a1cc-f0dcab282398', 'dbef3294-54da-52c4-95eb-57ea1057f597', 'a9803256-d8ec-55b7-ad38-4429605f21e4', '47cf114e-a8fd-50df-a526-2356d8ce5ca7', '19632060-b4a8-5a58-923a-baeaa00b3343', '07f68222-195a-501b-b8f7-79d55b1d4c95', '23a72c36-c437-5f07-a2c0-5d238cc76681', '34d0c10d-e0d7-5829-bcbb-cdfbcd39adf3') AND id NOT IN ('0c76d83d-cd47-59b3-ace6-ca8f2f6d0ee5', '8d66ce28-a241-5d1d-91ff-4084da0ad386', '1b4def41-330b-5999-82cb-4f1efc18f759', '6a10141a-ffc1-585c-a953-f86f11531973', '9c9feb27-c715-57a2-914e-566625147e63', '6197f186-04f1-585b-9e6b-fceac1054562', '542538ee-161a-58ab-9984-b7860838d331', '8342fea8-0cbf-594f-9039-8a08850e0396', '80e40f38-3cb0-5890-8c0d-1c73c0c4b5ed', '3ce7d42b-99ff-561e-bc6a-86d57ded0468', 'fa0de5f6-e0b5-5a19-bd27-395705024d6e', 'e1041414-92ed-5f6a-9c94-0e5531bcea7a', 'ede7e4fc-e779-5d88-8c98-1cc175cb038f', '74ddf4d7-826b-5915-84da-18212242f303', 'd2d011af-4368-53e0-af7a-d11f7c66b9a0', 'a55f050e-0d6b-59ae-97ec-a60b173074c4', '3e82ac04-5856-5b37-9e43-c238e1e350ed', 'eaa2887f-1b32-56bf-9438-ebc5c9fbcf63', '707519e4-2fcf-5943-b479-130053ca7290', '5ac393be-9656-5db8-aa22-79fe45ae9f8a', 'f8fc1bb2-58da-5aba-ae8c-3b53c92a3c75', '084190a4-6287-5d34-b93e-dfeabd5a5652', 'cd271de0-14b5-55a1-a5a1-ee2007f675fd', '6cbcb7e0-d9c8-54cd-a172-13c94193132a', '1a081b9a-2114-5ee0-8a91-e3b564be93b5', 'ba2a237a-dddf-5e32-8f96-4f63dd5d075f', 'e18634d9-c838-5c49-8a22-60d2e3a713e8', '7e736a41-19df-594e-8fda-9c75a6adf4d4', '33813b1c-2ca2-54df-8530-5ed3b9d459e9', 'b0d63013-0a39-5e43-92f5-785746735fce', '8bfa4954-bab3-5dbf-af8e-cbf4ffe4e7d6', 'f4ebfa5a-4093-5247-ac84-b7787ca3f27c', '40de2b8d-33ec-525c-b064-1ae7c94504bb', 'b8edc06c-e677-5cb8-9488-3b3921276338', '68e17039-f47a-595d-9901-52961e4cabaf', 'd3ff98d7-62e1-54f3-aea5-8e5a64e64d7c', '1a77d471-61f2-5ec5-9a95-a6488bd6d0c4', 'c293c1dd-cb69-594e-9124-518d7e208003', 'f128a54e-9d7b-5e95-ab6b-cdab9243e08e', '5dc097e4-ac70-5cc6-918b-53b302591c1c', '9aeaf4fa-32aa-515a-87b2-58ab4009de78', 'acb7f453-a2cc-5cc7-b71a-ecd10fd540ba', '0380faa9-4a08-5ac3-8953-5466127e0e59', '86f7cb8e-4e3e-5896-9e40-24aca9a83752', '7dd303ac-a904-50f9-bd50-b819e06429e6', '63036159-bb1f-5661-aa54-c06d41f68626', '69de082a-0bbb-586a-bdef-695a50c2d764', 'cf0550b8-7f84-5ea6-bec5-3eda0f4b8a04', 'a43c24c4-3dad-53a2-a8f5-3a7564f99cb7', 'a5c2f542-d8ba-55c9-9941-74b38513d5e3', 'd7052fd4-b85d-51af-89b3-4b15275a3f30', 'f5958931-d78d-5ca2-adee-1f310675092e', '23a87c8a-6a27-5267-a316-4d3b5b995840', '81301fb5-eee0-5e8e-9aa7-09e924c95822', 'edd61b7f-9dd2-5e89-8479-a026cad2ffc5', 'b2edca35-6bb9-52be-91c7-6101604568c4', '9cca089a-2d1c-5817-ad90-83931a4f8435', '80ecc15d-4877-59ef-9977-81e0ea02531e', '6071cb69-b784-5199-a037-b032c1824ba2', '44648260-ca2f-5875-86cc-49f644477c26', 'f3727d3f-f97b-5462-8684-f842621eae1f', '578b3b8d-0c84-5d4a-b347-f9ed37484b04', 'a25198f4-a080-557b-8da2-deaef62a055c', '96315407-d1b3-5555-a4da-692c11723bbf', '5e9daeb3-8a4b-5e3f-9a40-2f4ddab5326e', 'd8afa6e8-6858-581c-a50f-745dd391b5fa', 'f7e40bb9-75b7-5b8b-a3d0-497a54be6413', 'b1317621-009c-5ec2-9ff6-a939f89924cb', 'c442218f-ce95-5695-a4a3-a8ee58f934b7', '5e45565c-d5ea-5405-99b0-650f98722a7c', '9c740891-3ff8-5263-8f15-17139673634f', '0ad10810-03d2-5316-9e55-9aa8e4d142da', '0bbfa6b0-9075-5606-9645-51504d6e198c', '91da652f-7de0-573d-849e-7f2de35988a5', '9f5bdad6-0cd8-511e-bd96-a1dd8de9e45f', 'e6a67201-5ade-5e4f-a794-11c5893bd7cc', 'ddf3c54e-7180-5e1e-b71e-898adeeda33d', 'a819b559-9cf4-56d0-9f79-51aaff3566e0', '0e91ac39-f438-5607-b61a-cd31aee99ea8', '8ea6a3dd-2fdc-5db5-a85f-6239ac88502e', '4c889908-8a76-5eee-ba89-eb6d7b1364b3', '177dae34-bfd9-58ad-8c56-43c2f9f3469b', 'eca6f859-328e-520a-a576-f8e3798d95ca', '6c2e1db7-c849-56a7-be93-a4c2b468521f', '22796fab-e111-58cc-9309-a20f4cf6f1f5', 'ac998c1c-7ad7-5ff4-b050-3b65745b47e2', '377be3f8-a9ea-55e5-9291-b1801810673d', '87aabf01-d2a1-50ac-ba47-dc60f811a48d', 'f88142c8-0b26-5bc0-8004-89aaac96bc05', 'ecbc54b2-57f4-5088-8277-79040297bcfc', '1bce382a-f1cd-51f5-abf3-48f8198f9767', '9365ffdd-862e-57ac-855b-dec527e2a327', 'cc25120c-e6f1-5e32-a63d-5685e91a0c32', 'fcb92794-4fb8-5245-af4d-c3c2c4941e09', 'a2e3dc0d-dede-52a8-8179-27b239ccde5f', 'f5cd8817-7d20-50a3-8d0f-626631cb2da9', '99d62e06-46f1-58a8-81a7-4be68941a913', '0a71e2b0-9bcd-5727-bb9f-7a6f855465d5', '46e7944f-2911-5c28-b48a-d3ff6cb972af', 'c83e45ec-bd21-5a04-b925-20a1c76a3eaa', 'e7b35c0b-b315-5676-950b-2e615d7a107e', '98950c03-51e1-50f5-9ad9-b30e1abdebef', 'c57b906a-673a-5163-b376-9ba577960882', '8138a419-b453-5e6a-8512-6c35b6b5b5df', 'b10e97f1-58e0-556b-bd34-b4645779bd17', 'b5114512-5481-58ad-a8b5-20c09477e977', '74f502e1-e030-5508-85da-89b0549dead8', '6dd3fb9d-5ca5-5b28-82ca-a802f58bdbe0', '5fe0606d-7d83-55b3-aafd-b3b2a17c6adc', 'ff378a4b-c836-5851-a638-bab1aa427fb7', '06921fe4-f12d-5819-bcb9-fb6cfb8c474f', '7bc21821-b7d9-58b7-9eb9-1ba5d1c76989', '34b87d64-b37f-5207-86d9-9687a37c6575', '16df95b9-1878-5b0f-b072-5cf0d3c2f3de', '038c1806-31cd-52ba-a3bd-a74952fc5160', '4766d3df-f751-5f3e-b589-b27f34a1797c', '3e2257d6-5887-54f3-9930-c382e195d814', 'eaf483b2-fe2f-56e2-a95c-5d559a3b86e1', '0f1cb49c-836b-5e6b-acf1-ac6408ed2b36', '07d176ad-6a11-52db-b775-f7ea94a16541', 'c27d9b54-51db-5336-b8a3-cb7ee8c67fd8', '0306b933-68a8-589a-ab42-bc308ab17199', 'cfefd04f-b06d-548c-b830-7596a0d53a8c', '88d2d2fb-6b78-5bcb-adcb-d05667e58cf9', '981dfe9f-8c02-5878-b22c-ae23fd96ff06', '0a0e57ea-6c17-5aea-a09e-446cd5033035', '6fef9846-a6a2-5d08-b046-10b770cd1a97', '3bb995a9-bd1a-539a-aca3-2e75734bf0f5', '6e419c49-1772-5ba8-be34-708f001fb5b2', 'cab434eb-d6fa-52ed-9139-d4c29aa6df2d', 'f9df0e6a-2d5b-5dc3-b9a1-058dc6bf1cac', '93f3e1aa-e44f-57c0-9eb7-95387cdf8909', '825ed756-9b28-531f-bf57-be06295067c2', 'ac795e98-9ade-5e8a-a543-4048eff19191', '561de8d7-a7ce-5160-93f0-7295b3ee9269', '237af36f-b12b-5a2a-9a86-4bea5e923473', 'f08d3114-6bcb-53f8-b501-0f39ff8dfd3b', 'c2649d9d-d1d3-59da-8949-18ec29ac29bb', '0b7a65b1-fe99-55f5-b9e1-d7b3196e5d45', 'a8fc9ba6-2400-5d15-806a-4d3caead4899');
DELETE FROM public.chapters c WHERE c.subject_id = 'eveil-scientifique-4eme' AND c.id NOT IN ('ad61aa96-63f7-5c91-941d-5c4bf69484fd', '64469134-2e63-51f3-b864-290f8542b2a5', 'd24bba9a-93d9-5ef0-98c4-b8ae4f833446', '70e8ea22-72f4-5c70-970d-39ca792e03bc') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('ad61aa96-63f7-5c91-941d-5c4bf69484fd', 'eveil-scientifique-4eme', 'الأسنان والعناية بها', 'أنواع الأسنان ووظائفها، الأسنان اللبنية والدائمة، بنية السنّ، تسوّس الأسنان وأسبابه، وقواعد العناية بالأسنان', '# ⚔️ الأسنان والعناية بها — درعُ الفم

> 💡 «أسنانك أدواتٌ ثمينة تساعدك على الأكل والكلام؛ من يعتني بها يحفظ ابتسامته مدى العمر.»

في كلّ وجبةٍ تستعمل أسنانك دون أن تنتبه. لكنّ لكلّ سنٍّ شكلًا ووظيفة، ولها أعداءٌ يهدّدونها. في هذه البوّابة تكتشف أنواع الأسنان وكيف تحميها من التسوّس.

## 🦷 أنواع الأسنان ووظائفها

في فمنا أسنانٌ مختلفة الأشكال، لكلّ نوعٍ مهمّة:

| النوع   | الموضع         | الوظيفة              |
| ------- | -------------- | -------------------- |
| القواطع | في مقدّمة الفم | **تقطيع** الطعام     |
| الأنياب | بجانب القواطع  | **تمزيق** الطعام     |
| الأضراس | في مؤخّرة الفم | **طحن** الطعام وسحقه |

فالقواطع حادّةٌ كالسكّين، والأضراس عريضةٌ كالرّحى.

## 👶 الأسنان اللبنية والدائمة

- **الأسنان اللبنية:** أوّل أسنانٍ تظهر عند الطفل، وعددها **20** سنًّا. تبدأ في السقوط نحو سنّ السادسة.
- **الأسنان الدائمة:** تحلّ محلّ اللبنية، وعددها عند البالغ **32** سنًّا. إذا سقطت لا تُعوَّض، لذلك يجب الحفاظ عليها.

## 🛡️ بنية السنّ

يتكوّن السنّ من جزأين أساسيّين:

- **التاج:** الجزء الظاهر فوق اللثة، يغطّيه **المينا** (أصلب مادّةٍ في الجسم).
- **الجذر:** الجزء المغروس في الفكّ، يثبّت السنّ.

> 🗡️ المينا يحمي السنّ، لكنّه يتضرّر بالأحماض، فإذا تلف لا يعود كما كان.

## ⚡ تسوّس الأسنان وأسبابه

**التسوّس** ثقبٌ يصيب السنّ ويسبّب الألم. يحدث عندما تتغذّى **البكتيريا** في الفم على **بقايا السكّر** والطعام، فتنتج **حمضًا** يُذيب المينا.

- أكل الحلويات كثيرًا وعدم التنظيف يسرّعان التسوّس.

## 🧼 العناية بالأسنان

للحفاظ على أسنانٍ سليمة:

- **نظّف أسنانك** بالفرشاة والمعجون **مرّتين يوميًّا** على الأقلّ (بعد الفطور وقبل النوم).
- **قلّل من السكّريات** والحلويات اللزجة.
- **زُر طبيب الأسنان** بانتظامٍ للفحص.

> ⚠️ الفخّ الشائع: الظنّ أنّ الأسنان اللبنية لا تحتاج عناية لأنّها ستسقط؛ والصواب أنّ إهمالها يضرّ باللثة والأسنان الدائمة تحتها.

> 🏆 صرت تعرف أسنانك وكيف تحميها! استعدّ لبوّابة **التغذية المتوازنة**، حيث نكتشف كيف نطعم أجسامنا جيّدًا.', '# 📜 ملخّص: الأسنان والعناية بها

- **أنواع الأسنان:** القواطع (تقطيع)، الأنياب (تمزيق)، الأضراس (طحن).
- **الأسنان اللبنية:** 20 سنًّا، تظهر أوّلًا وتسقط نحو سنّ السادسة.
- **الأسنان الدائمة:** 32 سنًّا عند البالغ، تحلّ محلّ اللبنية ولا تُعوَّض إذا سقطت.
- **بنية السنّ:** التاج (الظاهر، يغطّيه المينا) والجذر (المغروس في الفكّ).
- **التسوّس:** ثقبٌ في السنّ تسبّبه بكتيريا الفم التي تنتج حمضًا من بقايا السكّر فيُذيب المينا.
- **العناية:** تنظيفٌ بالفرشاة مرّتين يوميًّا، التقليل من السكّريات، وزيارة طبيب الأسنان بانتظام.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('64469134-2e63-51f3-b864-290f8542b2a5', 'eveil-scientifique-4eme', 'التغذية المتوازنة', 'لماذا نأكل، أصناف الأغذية الثلاثة (البناءة والطاقية والوقائية) ومصادرها، أهمّية الماء، والتوازن الغذائي ومخاطر الإفراط', '# ⚔️ التغذية المتوازنة — وقودُ الجسم

> 💡 «جسمك آلةٌ عجيبة تحتاج وقودًا متنوّعًا؛ من يأكل بتوازنٍ ينمو قويًّا ويقاوم المرض.»

نأكل كلّ يوم، لكن هل كلّ الأغذية متشابهة؟ لا! لكلّ صنفٍ دورٌ في الجسم. في هذه البوّابة تتعلّم أصناف الأغذية وكيف تبني وجبةً **متوازنة**.

## 🍽️ لماذا نأكل؟

نأكل لثلاثة أسبابٍ أساسية:

- **لننمو** ونبني أجسامنا.
- **لنتحرّك** ونعمل (الطاقة).
- **لنقاوم الأمراض** ونحافظ على الصحّة.

## 🧩 أصناف الأغذية الثلاثة

تُصنَّف الأغذية حسب فائدتها إلى ثلاث مجموعات:

| الصنف      | فائدته             | أمثلة                                |
| ---------- | ------------------ | ------------------------------------ |
| **بناءة**  | النموّ وبناء الجسم | اللحم، السمك، البيض، الحليب          |
| **طاقية**  | منح الطاقة للحركة  | الخبز، العجائن، الأرز، الزيت، السكّر |
| **وقائية** | الوقاية من الأمراض | الخضر والغلال                        |

## 💪 الأغذية البناءة

تساعد على **النموّ** وبناء العضلات والعظام، ويحتاجها الأطفال خاصّةً في مرحلة النموّ. مصدرها: اللحوم، السمك، البيض، الحليب ومشتقّاته.

## ⚡ الأغذية الطاقية

تمدّ الجسم بـ**الطاقة** اللازمة للحركة والنشاط، كما يحتاج المحرّك إلى الوقود. مصدرها: الخبز، العجائن، الأرز (سكّريات)، والزيت والزبدة (دهون).

## 🛡️ الأغذية الوقائية والماء

- **الأغذية الوقائية:** الخضر والغلال، تمدّ الجسم بالفيتامينات والأملاح المعدنية التي **تقي من الأمراض**.
- **الماء:** ليس غذاءً طاقيًّا ولا بناءً، لكنّه **ضروريّ** لتركيب الجسم وقيامه بوظائفه؛ نشرب منه كمّيةً كافية يوميًّا.

## ⚖️ التوازن الغذائي

**الغذاء المتوازن** وجبةٌ **متنوّعة** تجمع من المجموعات الثلاث معًا، مع شرب الماء. مثال لوجبةٍ متوازنة: خبزٌ + سمكٌ + سلطة خضرٍ + غلّة.

> ⚠️ الفخّ الشائع: الاكتفاء بصنفٍ واحد (كأكل الحلويات فقط)؛ والإفراط في السكّريات والدهون يسبّب **السمنة** وتسوّس الأسنان وأمراضًا أخرى.

> 🏆 صرت تعرف كيف تطعم جسمك بتوازن! استعدّ لبوّابة **الماء**، حيث نكتشف حالاته الثلاث العجيبة.', '# 📜 ملخّص: التغذية المتوازنة

- **لماذا نأكل:** لننمو، ولنتحرّك (طاقة)، ولنقاوم الأمراض.
- **الأغذية البناءة:** للنموّ وبناء الجسم؛ مصدرها اللحم والسمك والبيض والحليب.
- **الأغذية الطاقية:** لمنح الطاقة؛ مصدرها الخبز والعجائن والأرز والزيت والسكّر.
- **الأغذية الوقائية:** للوقاية من الأمراض؛ مصدرها الخضر والغلال (فيتامينات وأملاح).
- **الماء:** ضروريّ لتركيب الجسم وقيامه بوظائفه، نشرب كمّيةً كافية يوميًّا.
- **الغذاء المتوازن:** وجبةٌ متنوّعة تجمع المجموعات الثلاث؛ والإفراط في السكّر والدهون يسبّب السمنة وأمراضًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('d24bba9a-93d9-5ef0-98c4-b8ae4f833446', 'eveil-scientifique-4eme', 'حالات الماء الثلاث', 'الماء في الطبيعة، الحالة الصلبة والسائلة والغازية، تغيّرات الحالة (الانصهار والتجمّد والتبخّر والتكاثف)، ودرجتا التجمّد والغليان', '# ⚔️ حالات الماء الثلاث — تحوّلاتٌ عجيبة

> 💡 «الماء حِرباءُ الطبيعة: مرّةً صلبٌ كالحجر، ومرّةً سائلٌ يجري، ومرّةً بخارٌ يطير.»

الماء واحد، لكنّه يظهر في ثلاث صورٍ مختلفة حسب الحرارة. في هذه البوّابة تكتشف حالات الماء الثلاث وكيف يتحوّل من واحدةٍ إلى أخرى.

## 💧 الماء حولنا

نجد الماء في الطبيعة في **ثلاث حالات**: صلبة (الجليد)، وسائلة (ماء البحر والنهر)، وغازية (بخار الماء في الهواء). والمادّة نفسها هي **الماء** في كلّ الحالات.

## 🧊 الحالة الصلبة

في **الحالة الصلبة** يكون الماء **جليدًا** أو ثلجًا: له **شكلٌ ثابت** وصلابة. نجده في مكعّبات الثلج وفي قمم الجبال الباردة.

## 🌊 الحالة السائلة

في **الحالة السائلة** يجري الماء ويأخذ **شكل الإناء** الذي يحويه. هذا هو الماء الذي نشربه ونستحمّ به ونجده في البحار والأنهار.

## ☁️ الحالة الغازية

في **الحالة الغازية** يصير الماء **بخارًا** لا نراه، منتشرًا في الهواء. نلاحظ أثره فوق إناءٍ يغلي أو حين يجفّ الغسيل.

## ❄️ الانصهار والتجمّد

- **التجمّد:** تحوّل الماء السائل إلى جليدٍ صلب عند تبريده. يتجمّد الماء عند درجة حرارة **0 °C**.
- **الانصهار:** تحوّل الجليد الصلب إلى ماءٍ سائل عند تسخينه (عكس التجمّد).

> 🗡️ التجمّد والانصهار عمليّتان متعاكستان: التبريد يُجمّد، والتسخين يُذيب (يَنصهر).

## 💨 التبخّر والتكاثف

- **التبخّر:** تحوّل الماء السائل إلى بخار (غاز). يكون أسرع كلّما ارتفعت الحرارة، ويغلي الماء عند **100 °C**.
- **التكاثف:** تحوّل بخار الماء إلى قطراتٍ سائلة عند ملامسته سطحًا **باردًا** (مثل قطرات الماء على كأسٍ باردة).

> ⚠️ الفخّ الشائع: الظنّ أنّ البخار المتصاعد «دخان»؛ هو في الحقيقة بخار ماءٍ يتكاثف في الهواء البارد فيصير مرئيًّا كضبابٍ أبيض.

> 🏆 صرت تعرف حالات الماء وتحوّلاته! استعدّ لبوّابة **الهواء**، ذلك الشيء الذي لا نراه لكنّه يملأ كلّ مكان.', '# 📜 ملخّص: حالات الماء الثلاث

- **الحالات الثلاث:** صلبة (الجليد، شكلٌ ثابت)، سائلة (تأخذ شكل الإناء)، غازية (بخار الماء في الهواء)؛ والمادّة نفسها هي الماء.
- **التجمّد:** تحوّل الماء السائل إلى جليدٍ صلب عند التبريد، عند درجة 0 °C.
- **الانصهار:** تحوّل الجليد إلى ماءٍ سائل عند التسخين (عكس التجمّد).
- **التبخّر:** تحوّل الماء السائل إلى بخار، ويكون أسرع كلّما ارتفعت الحرارة؛ يغلي الماء عند 100 °C.
- **التكاثف:** تحوّل بخار الماء إلى قطراتٍ سائلة عند ملامسته سطحًا باردًا.
- **القاعدة:** التبريد يُجمّد ويُكاثف، والتسخين يُذيب ويُبخّر.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('70e8ea22-72f4-5c70-970d-39ca792e03bc', 'eveil-scientifique-4eme', 'الهواء وخصائصه', 'الهواء من حولنا، خصائصه (يشغل حيّزًا، له كتلة، يتحرّك)، الرياح، وأهمّية الهواء للتنفّس والحياة والاحتراق', '# ⚔️ الهواء وخصائصه — الشيء الخفيّ

> 💡 «لا تراه لكنّه يملأ كلّ مكان، ويحرّك الأشرعة، وبه نتنفّس: إنّه الهواء.»

نعيش غارقين في **الهواء** دون أن نراه. لكنّه موجودٌ حقًّا وله خصائص يمكن إثباتها. في هذه البوّابة الأخيرة من رحلتك تكتشف أسرار الهواء.

## 🌫️ الهواء من حولنا

الهواء **غازٌ شفّاف** لا لون له ولا رائحة، لذلك **لا نراه**. لكنّه موجودٌ في كلّ مكانٍ حولنا: في الغرفة، وبين الأشجار، وحتّى داخل قارورةٍ تبدو «فارغة».

## 📦 الهواء يشغل حيّزًا

رغم أنّنا لا نراه، فإنّ الهواء **يشغل حيّزًا** (مكانًا):

- إذا غمرنا قارورةً «فارغة» مقلوبةً في الماء، خرجت منها **فقاعات هواء**.
- إذا غمرنا كأسًا مقلوبةً بداخلها منديل، بقي المنديل **جافًّا** لأنّ الهواء يمنع الماء من الدخول.

## ⚖️ للهواء كتلة

للهواء **كتلة** (وزن) رغم خفّته: الكرة المنفوخة بالهواء **أثقل** قليلًا من الكرة الفارغة. فالهواء مادّةٌ حقيقية لها كتلة.

## 🌬️ الهواء يتحرّك: الرياح

**الرياح** ما هي إلّا **هواءٌ متحرّك**. والهواء المتحرّك له **قوّة**: يحرّك أوراق الأشجار، ويدفع أشرعة القوارب، ويُدير طواحين الهواء.

## 🫁 الهواء ضروريّ للحياة

- **للتنفّس:** يحتاج الإنسان والحيوان والنبات إلى الهواء (وخاصّةً **الأكسجين** الذي فيه) ليتنفّسوا ويبقوا أحياء.
- **للاحتراق:** تحتاج النار إلى الهواء أيضًا؛ فإذا غطّينا شمعةً مشتعلة بكأسٍ محكمة انطفأت بعد **نفاد الأكسجين**.

> ⚠️ الفخّ الشائع: الظنّ أنّ القارورة «الفارغة» فارغةٌ حقًّا؛ هي في الحقيقة **مملوءةٌ بالهواء**.

> 🏆 مبروك! بإتمامك درس الهواء تكون قد خطوت خطواتٍ ثابتة في عالَم العلوم، واكتشفت أنّ حتّى ما لا نراه له خصائص يمكن دراستها.', '# 📜 ملخّص: الهواء وخصائصه

- **الهواء:** غازٌ شفّاف لا لون له ولا رائحة، لا نراه لكنّه موجودٌ في كلّ مكانٍ حولنا.
- **يشغل حيّزًا:** قارورةٌ «فارغة» مغموسة في الماء تُخرج فقاعات هواء؛ والهواء يمنع الماء من دخول كأسٍ مقلوبة.
- **له كتلة:** الكرة المنفوخة أثقل من الفارغة، فالهواء مادّةٌ لها وزن.
- **يتحرّك:** الرياح هي هواءٌ متحرّك له قوّة تحرّك الأوراق والأشرعة وطواحين الهواء.
- **ضروريّ للحياة:** يتنفّسه الإنسان والحيوان والنبات (الأكسجين)، والنار تحتاجه للاحتراق.
- **الفخّ:** القارورة «الفارغة» مملوءةٌ في الحقيقة بالهواء.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b71f0680-2d69-58a7-a13d-22e0da126998', 'ad61aa96-63f7-5c91-941d-5c4bf69484fd', 'eveil-scientifique-4eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('0c76d83d-cd47-59b3-ace6-ca8f2f6d0ee5', 'b71f0680-2d69-58a7-a13d-22e0da126998', 'كم عدد الأسنان اللبنية عند الطفل؟', '[{"id":"a","text":"32"},{"id":"b","text":"20"},{"id":"c","text":"28"},{"id":"d","text":"16"}]'::jsonb, 'b', 'عدد الأسنان اللبنية 20 سنًّا، وهي أوّل ما يظهر عند الطفل ثمّ تسقط لتحلّ محلّها الدائمة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d66ce28-a241-5d1d-91ff-4084da0ad386', 'b71f0680-2d69-58a7-a13d-22e0da126998', 'أيّ الأسنان نستعملها لتقطيع الطعام؟', '[{"id":"a","text":"الأنياب"},{"id":"b","text":"الأضراس"},{"id":"c","text":"القواطع"},{"id":"d","text":"الجذور"}]'::jsonb, 'c', 'القواطع أسنانٌ حادّة في مقدّمة الفم وظيفتها تقطيع الطعام. أمّا الأضراس فتطحنه والأنياب تمزّقه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b4def41-330b-5999-82cb-4f1efc18f759', 'b71f0680-2d69-58a7-a13d-22e0da126998', 'ما السبب الرئيسيّ لتسوّس الأسنان؟', '[{"id":"a","text":"بكتيريا الفم تنتج حمضًا من بقايا السكّر فيُذيب المينا"},{"id":"b","text":"شرب الماء بكثرة"},{"id":"c","text":"أكل الخضر والفواكه"},{"id":"d","text":"تنظيف الأسنان بالفرشاة"}]'::jsonb, 'a', 'تتغذّى بكتيريا الفم على بقايا السكّر فتنتج حمضًا يُذيب المينا ويُحدث ثقب التسوّس.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a10141a-ffc1-585c-a953-f86f11531973', 'b71f0680-2d69-58a7-a13d-22e0da126998', 'كم مرّة يُنصح بتنظيف الأسنان في اليوم؟', '[{"id":"a","text":"مرّة في الأسبوع"},{"id":"b","text":"لا حاجة لتنظيفها"},{"id":"c","text":"مرّة في الشهر"},{"id":"d","text":"مرّتين على الأقلّ يوميًّا"}]'::jsonb, 'd', 'يُنصح بتنظيف الأسنان بالفرشاة والمعجون مرّتين على الأقلّ يوميًّا (بعد الفطور وقبل النوم).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c9feb27-c715-57a2-914e-566625147e63', 'b71f0680-2d69-58a7-a13d-22e0da126998', 'أيّ الأسنان نستعملها لطحن الطعام وسحقه؟', '[{"id":"a","text":"القواطع"},{"id":"b","text":"الأنياب"},{"id":"c","text":"الأضراس"},{"id":"d","text":"المينا"}]'::jsonb, 'c', 'الأضراس أسنانٌ عريضة في مؤخّرة الفم تطحن الطعام وتسحقه قبل بلعه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('80da2bee-6cec-5c07-819b-100636e30822', 'ad61aa96-63f7-5c91-941d-5c4bf69484fd', 'eveil-scientifique-4eme', '⭐ تمرين: أوّل خطوات في معرفة الأسنان', 1, 50, 10, 'practice', 'admin', 1)
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
  ('6197f186-04f1-585b-9e6b-fceac1054562', '80da2bee-6cec-5c07-819b-100636e30822', 'كم عدد الأسنان الدائمة عند البالغ؟', '[{"id":"a","text":"20"},{"id":"b","text":"32"},{"id":"c","text":"28"},{"id":"d","text":"30"}]'::jsonb, 'b', 'عدد الأسنان الدائمة عند البالغ 32 سنًّا، وهي تحلّ محلّ الأسنان اللبنية العشرين.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('542538ee-161a-58ab-9984-b7860838d331', '80da2bee-6cec-5c07-819b-100636e30822', 'ما وظيفة الأنياب؟', '[{"id":"a","text":"طحن الطعام"},{"id":"b","text":"تقطيع الطعام"},{"id":"c","text":"تمزيق الطعام"},{"id":"d","text":"بلع الطعام"}]'::jsonb, 'c', 'الأنياب أسنانٌ مدبّبة بجانب القواطع وظيفتها تمزيق الطعام.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8342fea8-0cbf-594f-9039-8a08850e0396', '80da2bee-6cec-5c07-819b-100636e30822', 'ما اسم الجزء الظاهر من السنّ فوق اللثة؟', '[{"id":"a","text":"التاج"},{"id":"b","text":"الجذر"},{"id":"c","text":"الفكّ"},{"id":"d","text":"اللثة"}]'::jsonb, 'a', 'الجزء الظاهر من السنّ فوق اللثة يُسمّى التاج، ويغطّيه المينا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80e40f38-3cb0-5890-8c0d-1c73c0c4b5ed', '80da2bee-6cec-5c07-819b-100636e30822', 'ما أصلب مادّة تغطّي تاج السنّ؟', '[{"id":"a","text":"اللثة"},{"id":"b","text":"الجذر"},{"id":"c","text":"اللعاب"},{"id":"d","text":"المينا"}]'::jsonb, 'd', 'المينا هو الطبقة التي تغطّي التاج، وهو أصلب مادّة في الجسم ويحمي السنّ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ce7d42b-99ff-561e-bc6a-86d57ded0468', '80da2bee-6cec-5c07-819b-100636e30822', 'متى تبدأ الأسنان اللبنية في السقوط تقريبًا؟', '[{"id":"a","text":"عند الولادة"},{"id":"b","text":"في سنّ العشرين"},{"id":"c","text":"نحو سنّ السادسة"},{"id":"d","text":"لا تسقط أبدًا"}]'::jsonb, 'c', 'تبدأ الأسنان اللبنية في السقوط نحو سنّ السادسة لتحلّ محلّها الأسنان الدائمة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa0de5f6-e0b5-5a19-bd27-395705024d6e', '80da2bee-6cec-5c07-819b-100636e30822', 'ما اسم الجزء المغروس في الفكّ من السنّ؟', '[{"id":"a","text":"الجذر"},{"id":"b","text":"التاج"},{"id":"c","text":"المينا"},{"id":"d","text":"القاطع"}]'::jsonb, 'a', 'الجذر هو الجزء المغروس في الفكّ، وهو يثبّت السنّ في مكانه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('74169495-aa5d-5b8a-a3a8-abc6199c0671', 'ad61aa96-63f7-5c91-941d-5c4bf69484fd', 'eveil-scientifique-4eme', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الابتسامة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('e1041414-92ed-5f6a-9c94-0e5531bcea7a', '74169495-aa5d-5b8a-a3a8-abc6199c0671', 'لماذا يجب الاعتناء بالأسنان اللبنية رغم أنّها ستسقط؟', '[{"id":"a","text":"لأنّ إهمالها يضرّ باللثة وبالأسنان الدائمة تحتها"},{"id":"b","text":"لأنّها لا تسقط في الحقيقة"},{"id":"c","text":"لأنّها أقوى من الأسنان الدائمة"},{"id":"d","text":"لا داعي للاعتناء بها فعلًا"}]'::jsonb, 'a', 'إهمال الأسنان اللبنية يسبّب التسوّس والألم ويضرّ باللثة وبالأسنان الدائمة التي تنمو تحتها، لذلك يجب الاعتناء بها.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ede7e4fc-e779-5d88-8c98-1cc175cb038f', '74169495-aa5d-5b8a-a3a8-abc6199c0671', 'ماذا تنتج بكتيريا الفم من بقايا السكّر؟', '[{"id":"a","text":"ماءً نقيًّا"},{"id":"b","text":"حمضًا"},{"id":"c","text":"مينا جديدًا"},{"id":"d","text":"سكّرًا إضافيًّا"}]'::jsonb, 'b', 'تتغذّى البكتيريا على بقايا السكّر فتنتج حمضًا يُذيب المينا ويُحدث التسوّس.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74ddf4d7-826b-5915-84da-18212242f303', '74169495-aa5d-5b8a-a3a8-abc6199c0671', 'أيّ هذه العادات تحمي الأسنان من التسوّس؟', '[{"id":"a","text":"أكل الحلويات قبل النوم مباشرةً"},{"id":"b","text":"عدم التنظيف بالفرشاة"},{"id":"c","text":"تجنّب زيارة طبيب الأسنان"},{"id":"d","text":"التقليل من الحلويات اللزجة"}]'::jsonb, 'd', 'التقليل من الحلويات اللزجة يقلّل غذاء البكتيريا فيحمي الأسنان من التسوّس.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2d011af-4368-53e0-af7a-d11f7c66b9a0', '74169495-aa5d-5b8a-a3a8-abc6199c0671', 'ما الفرق في الشكل بين القاطع والضرس؟', '[{"id":"a","text":"كلاهما حادّ ورقيق"},{"id":"b","text":"كلاهما عريض ومسطّح"},{"id":"c","text":"القاطع حادّ والضرس عريض"},{"id":"d","text":"القاطع عريض والضرس حادّ"}]'::jsonb, 'c', 'القاطع حادٌّ كالسكّين ليقطع، والضرس عريضٌ مسطّح ليطحن الطعام؛ ويتناسب شكل كلٍّ مع وظيفته.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a55f050e-0d6b-59ae-97ec-a60b173074c4', '74169495-aa5d-5b8a-a3a8-abc6199c0671', 'إذا سقط سنٌّ دائم عند البالغ، فإنّه:', '[{"id":"a","text":"يُعوَّض تلقائيًّا بسنٍّ جديد"},{"id":"b","text":"لا يُعوَّض بآخر طبيعيّ"},{"id":"c","text":"يكبر من جديد بعد أسبوع"},{"id":"d","text":"يتحوّل إلى سنٍّ لبنيّ"}]'::jsonb, 'b', 'الأسنان الدائمة لا تُعوَّض طبيعيًّا إذا سقطت، لذلك وجب الحفاظ عليها جيّدًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e82ac04-5856-5b37-9e43-c238e1e350ed', '74169495-aa5d-5b8a-a3a8-abc6199c0671', 'لماذا يُنصح بتنظيف الأسنان قبل النوم خاصّةً؟', '[{"id":"a","text":"لتبدو جميلة أمام الناس فقط"},{"id":"b","text":"لا فائدة من ذلك"},{"id":"c","text":"لإزالة بقايا الطعام ومنع البكتيريا من إنتاج الحمض أثناء النوم"},{"id":"d","text":"لتقوية اللثة فقط دون الأسنان"}]'::jsonb, 'c', 'أثناء النوم يقلّ اللعاب، فإذا بقيت بقايا الطعام نشطت البكتيريا وأنتجت الحمض؛ لذا التنظيف قبل النوم يحمي الأسنان.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c6cab2c9-752f-5dc1-961a-4754d9ab9173', 'ad61aa96-63f7-5c91-941d-5c4bf69484fd', 'eveil-scientifique-4eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الأسنان والعناية بها', 2, 70, 15, 'practice', 'admin', 3)
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
  ('eaa2887f-1b32-56bf-9438-ebc5c9fbcf63', 'c6cab2c9-752f-5dc1-961a-4754d9ab9173', 'ما وظيفة القواطع؟', '[{"id":"a","text":"طحن الطعام"},{"id":"b","text":"تقطيع الطعام"},{"id":"c","text":"تمزيق الطعام"},{"id":"d","text":"بلع الطعام"}]'::jsonb, 'b', 'القواطع أسنانٌ حادّة في مقدّمة الفم وظيفتها تقطيع الطعام.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('707519e4-2fcf-5943-b479-130053ca7290', 'c6cab2c9-752f-5dc1-961a-4754d9ab9173', 'كم عدد الأسنان اللبنية؟', '[{"id":"a","text":"32"},{"id":"b","text":"16"},{"id":"c","text":"20"},{"id":"d","text":"28"}]'::jsonb, 'c', 'عدد الأسنان اللبنية 20 سنًّا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ac393be-9656-5db8-aa22-79fe45ae9f8a', 'c6cab2c9-752f-5dc1-961a-4754d9ab9173', 'ما الذي يُحدث ثقب التسوّس في السنّ؟', '[{"id":"a","text":"الحمض الناتج عن بكتيريا الفم"},{"id":"b","text":"شرب الماء"},{"id":"c","text":"معجون الأسنان"},{"id":"d","text":"اللعاب"}]'::jsonb, 'a', 'بكتيريا الفم تنتج حمضًا من بقايا السكّر، وهذا الحمض يُذيب المينا ويُحدث ثقب التسوّس.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8fc1bb2-58da-5aba-ae8c-3b53c92a3c75', 'c6cab2c9-752f-5dc1-961a-4754d9ab9173', 'التاج هو الجزء:', '[{"id":"a","text":"المغروس في الفكّ"},{"id":"b","text":"الداخليّ غير المرئيّ"},{"id":"c","text":"اللثة المحيطة بالسنّ"},{"id":"d","text":"الظاهر فوق اللثة"}]'::jsonb, 'd', 'التاج هو الجزء الظاهر من السنّ فوق اللثة، أمّا الجذر فمغروسٌ في الفكّ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('084190a4-6287-5d34-b93e-dfeabd5a5652', 'c6cab2c9-752f-5dc1-961a-4754d9ab9173', 'كم سنًّا دائمًا عند البالغ؟', '[{"id":"a","text":"32"},{"id":"b","text":"20"},{"id":"c","text":"28"},{"id":"d","text":"24"}]'::jsonb, 'a', 'عدد الأسنان الدائمة عند البالغ 32 سنًّا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd271de0-14b5-55a1-a5a1-ee2007f675fd', 'c6cab2c9-752f-5dc1-961a-4754d9ab9173', 'أيّ هذه من العادات الصحّية للأسنان؟', '[{"id":"a","text":"أكل السكّريات بكثرة"},{"id":"b","text":"زيارة طبيب الأسنان بانتظام"},{"id":"c","text":"ترك الأسنان دون تنظيف"},{"id":"d","text":"تنظيفها مرّة في الشهر فقط"}]'::jsonb, 'b', 'زيارة طبيب الأسنان بانتظامٍ للفحص من العادات الصحّية التي تحمي الأسنان وتكشف التسوّس مبكّرًا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('70be6344-f68f-5069-a98b-fad45e53090a', 'ad61aa96-63f7-5c91-941d-5c4bf69484fd', 'eveil-scientifique-4eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: أسرار الأسنان', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('6cbcb7e0-d9c8-54cd-a172-13c94193132a', '70be6344-f68f-5069-a98b-fad45e53090a', 'شخصٌ يأكل الحلويات كثيرًا ولا ينظّف أسنانه. ما النتيجة المتوقّعة؟', '[{"id":"a","text":"أسنانٌ أقوى وأكثر بياضًا"},{"id":"b","text":"تسوّس الأسنان"},{"id":"c","text":"نموّ أسنان جديدة"},{"id":"d","text":"لا يحدث شيء"}]'::jsonb, 'b', 'كثرة السكّر مع عدم التنظيف توفّر غذاءً للبكتيريا التي تنتج الحمض، فيحدث التسوّس.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a081b9a-2114-5ee0-8a91-e3b564be93b5', '70be6344-f68f-5069-a98b-fad45e53090a', 'لماذا يُعدّ المينا مهمًّا جدًّا للسنّ؟', '[{"id":"a","text":"لأنّه يلوّن السنّ فقط"},{"id":"b","text":"لأنّه يثبّت السنّ في الفكّ"},{"id":"c","text":"لأنّه يحمي السنّ وهو أصلب مادّة في الجسم"},{"id":"d","text":"لأنّه ينتج اللعاب"}]'::jsonb, 'c', 'المينا أصلب مادّة في الجسم، وهو الدرع الذي يحمي السنّ من التآكل؛ لكنّه يتضرّر بالأحماض.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba2a237a-dddf-5e32-8f96-4f63dd5d075f', '70be6344-f68f-5069-a98b-fad45e53090a', 'ما الترتيب الصحيح لدور الأسنان أثناء الأكل؟', '[{"id":"a","text":"الأضراس تقطّع ثمّ القواطع تطحن"},{"id":"b","text":"الأنياب تطحن أوّلًا"},{"id":"c","text":"القواطع تطحن والأضراس تقطّع"},{"id":"d","text":"القواطع تقطّع، الأنياب تمزّق، الأضراس تطحن"}]'::jsonb, 'd', 'تبدأ القواطع بتقطيع الطعام، ثمّ تمزّقه الأنياب، وأخيرًا تطحنه الأضراس قبل البلع.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e18634d9-c838-5c49-8a22-60d2e3a713e8', '70be6344-f68f-5069-a98b-fad45e53090a', 'طفلٌ عمره 5 سنوات. أيّ نوعٍ من الأسنان غالبًا في فمه؟', '[{"id":"a","text":"الأسنان اللبنية"},{"id":"b","text":"الأسنان الدائمة فقط"},{"id":"c","text":"لا أسنان له بعد"},{"id":"d","text":"32 سنًّا دائمًا"}]'::jsonb, 'a', 'في سنّ الخامسة يكون للطفل أسنانٌ لبنية (تبدأ في السقوط نحو السادسة)، فالدائمة لم تكتمل بعد.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e736a41-19df-594e-8fda-9c75a6adf4d4', '70be6344-f68f-5069-a98b-fad45e53090a', 'لماذا يُنصح بالتقليل من المشروبات السكّرية؟', '[{"id":"a","text":"لأنّها غالية الثمن"},{"id":"b","text":"لأنّها تبيّض الأسنان"},{"id":"c","text":"لأنّ السكّر يغذّي البكتيريا التي تسبّب التسوّس"},{"id":"d","text":"لأنّها تقوّي المينا"}]'::jsonb, 'c', 'المشروبات السكّرية تمدّ بكتيريا الفم بالسكّر، فتنتج حمضًا أكثر ويزداد خطر التسوّس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33813b1c-2ca2-54df-8530-5ed3b9d459e9', '70be6344-f68f-5069-a98b-fad45e53090a', 'ما العلاقة بين الأسنان اللبنية والأسنان الدائمة؟', '[{"id":"a","text":"الدائمة تحلّ محلّ اللبنية بعد سقوطها"},{"id":"b","text":"اللبنية تحلّ محلّ الدائمة"},{"id":"c","text":"لا علاقة بينهما"},{"id":"d","text":"كلاهما يظهر في الوقت نفسه"}]'::jsonb, 'a', 'تظهر الأسنان اللبنية أوّلًا، وعند سقوطها تنمو مكانها الأسنان الدائمة التي تبقى مدى العمر.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cd4202a6-c60f-51c2-ad16-b8e628fd1131', 'ad61aa96-63f7-5c91-941d-5c4bf69484fd', 'eveil-scientifique-4eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للأسنان', 3, 120, 30, 'boss', 'admin', 5)
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
  ('b0d63013-0a39-5e43-92f5-785746735fce', 'cd4202a6-c60f-51c2-ad16-b8e628fd1131', 'ما وظيفة الأضراس؟', '[{"id":"a","text":"تقطيع الطعام"},{"id":"b","text":"تمزيق الطعام"},{"id":"c","text":"طحن الطعام"},{"id":"d","text":"بلع الطعام"}]'::jsonb, 'c', 'الأضراس أسنانٌ عريضة في مؤخّرة الفم تطحن الطعام وتسحقه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8bfa4954-bab3-5dbf-af8e-cbf4ffe4e7d6', 'cd4202a6-c60f-51c2-ad16-b8e628fd1131', 'الجذر هو الجزء:', '[{"id":"a","text":"الظاهر فوق اللثة"},{"id":"b","text":"المغروس في الفكّ"},{"id":"c","text":"الذي يغطّيه المينا في الأعلى"},{"id":"d","text":"اللثة نفسها"}]'::jsonb, 'b', 'الجذر هو الجزء المغروس في الفكّ ويثبّت السنّ، أمّا الظاهر فوق اللثة فهو التاج.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4ebfa5a-4093-5247-ac84-b7787ca3f27c', 'cd4202a6-c60f-51c2-ad16-b8e628fd1131', 'كم عدد الأسنان الدائمة؟', '[{"id":"a","text":"32"},{"id":"b","text":"20"},{"id":"c","text":"28"},{"id":"d","text":"16"}]'::jsonb, 'a', 'عدد الأسنان الدائمة عند البالغ 32 سنًّا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40de2b8d-33ec-525c-b064-1ae7c94504bb', 'cd4202a6-c60f-51c2-ad16-b8e628fd1131', 'ما الذي يُذيب مينا الأسنان ويسبّب التسوّس؟', '[{"id":"a","text":"الماء"},{"id":"b","text":"معجون الأسنان"},{"id":"c","text":"اللعاب"},{"id":"d","text":"الحمض الناتج عن بكتيريا الفم"}]'::jsonb, 'd', 'الحمض الذي تنتجه بكتيريا الفم من بقايا السكّر يُذيب المينا ويُحدث التسوّس.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b8edc06c-e677-5cb8-9488-3b3921276338', 'cd4202a6-c60f-51c2-ad16-b8e628fd1131', 'ما أفضل وقتين لتنظيف الأسنان يوميًّا؟', '[{"id":"a","text":"قبل الأكل فقط"},{"id":"b","text":"عند الاستيقاظ فقط"},{"id":"c","text":"بعد الفطور وقبل النوم"},{"id":"d","text":"مرّة واحدة في الأسبوع"}]'::jsonb, 'c', 'يُنصح بالتنظيف بعد الفطور وقبل النوم لإزالة بقايا الطعام ومنع نشاط البكتيريا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68e17039-f47a-595d-9901-52961e4cabaf', 'cd4202a6-c60f-51c2-ad16-b8e628fd1131', 'الأسنان اللبنية تبدأ في السقوط تقريبًا في سنّ:', '[{"id":"a","text":"الثانية"},{"id":"b","text":"السادسة"},{"id":"c","text":"الخامسة عشرة"},{"id":"d","text":"العشرين"}]'::jsonb, 'b', 'تبدأ الأسنان اللبنية في السقوط نحو سنّ السادسة لتحلّ محلّها الأسنان الدائمة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('36e632a2-9b7a-5e07-8ce2-fedd6019dcdc', '64469134-2e63-51f3-b864-290f8542b2a5', 'eveil-scientifique-4eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d3ff98d7-62e1-54f3-aea5-8e5a64e64d7c', '36e632a2-9b7a-5e07-8ce2-fedd6019dcdc', 'الأغذية التي تساعد على النموّ وبناء الجسم تُسمّى:', '[{"id":"a","text":"الطاقية"},{"id":"b","text":"البناءة"},{"id":"c","text":"الوقائية"},{"id":"d","text":"المالحة"}]'::jsonb, 'b', 'الأغذية البناءة (كاللحم والبيض والحليب) تساعد على النموّ وبناء الجسم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a77d471-61f2-5ec5-9a95-a6488bd6d0c4', '36e632a2-9b7a-5e07-8ce2-fedd6019dcdc', 'أيّ الأغذية التالية من الأغذية الطاقية؟', '[{"id":"a","text":"اللحم"},{"id":"b","text":"الجزر"},{"id":"c","text":"الخبز"},{"id":"d","text":"البيض"}]'::jsonb, 'c', 'الخبز من الأغذية الطاقية لأنّه يمدّ الجسم بالطاقة. أمّا اللحم والبيض فبناءة والجزر وقائيّ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c293c1dd-cb69-594e-9124-518d7e208003', '36e632a2-9b7a-5e07-8ce2-fedd6019dcdc', 'الخضر والغلال تُصنّف ضمن الأغذية:', '[{"id":"a","text":"الوقائية"},{"id":"b","text":"البناءة"},{"id":"c","text":"الطاقية"},{"id":"d","text":"لا تُصنّف غذاءً"}]'::jsonb, 'a', 'الخضر والغلال أغذية وقائية تمدّ الجسم بالفيتامينات والأملاح التي تقي من الأمراض.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f128a54e-9d7b-5e95-ab6b-cdab9243e08e', '36e632a2-9b7a-5e07-8ce2-fedd6019dcdc', 'ما هو الغذاء المتوازن؟', '[{"id":"a","text":"أكل اللحم فقط"},{"id":"b","text":"أكل الحلويات فقط"},{"id":"c","text":"الاكتفاء بصنفٍ واحد"},{"id":"d","text":"وجبةٌ متنوّعة من المجموعات الثلاث"}]'::jsonb, 'd', 'الغذاء المتوازن وجبةٌ متنوّعة تجمع الأغذية البناءة والطاقية والوقائية مع شرب الماء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5dc097e4-ac70-5cc6-918b-53b302591c1c', '36e632a2-9b7a-5e07-8ce2-fedd6019dcdc', 'ما الشراب الضروريّ لجسمنا والذي يجب أن نكثر منه يوميًّا؟', '[{"id":"a","text":"المشروبات الغازية"},{"id":"b","text":"العصير المحلّى"},{"id":"c","text":"الماء"},{"id":"d","text":"القهوة"}]'::jsonb, 'c', 'الماء ضروريّ لتركيب الجسم وقيامه بوظائفه، بخلاف المشروبات السكّرية التي قد تضرّ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('53806760-025b-5607-a36f-c06aa58cb33d', '64469134-2e63-51f3-b864-290f8542b2a5', 'eveil-scientifique-4eme', '⭐ تمرين: أوّل خطوات في التغذية', 1, 50, 10, 'practice', 'admin', 1)
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
  ('9aeaf4fa-32aa-515a-87b2-58ab4009de78', '53806760-025b-5607-a36f-c06aa58cb33d', 'اللحم والبيض والحليب أغذية:', '[{"id":"a","text":"طاقية"},{"id":"b","text":"بناءة"},{"id":"c","text":"وقائية"},{"id":"d","text":"ضارّة"}]'::jsonb, 'b', 'اللحم والبيض والحليب أغذية بناءة تساعد على النموّ وبناء الجسم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('acb7f453-a2cc-5cc7-b71a-ecd10fd540ba', '53806760-025b-5607-a36f-c06aa58cb33d', 'أيّ هذه من الأغذية الوقائية؟', '[{"id":"a","text":"الأرز"},{"id":"b","text":"الزبدة"},{"id":"c","text":"الغلال"},{"id":"d","text":"اللحم"}]'::jsonb, 'c', 'الغلال أغذية وقائية تمدّ الجسم بالفيتامينات والأملاح. أمّا الأرز والزبدة فطاقية واللحم بناء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0380faa9-4a08-5ac3-8953-5466127e0e59', '53806760-025b-5607-a36f-c06aa58cb33d', 'لماذا نأكل الأغذية الطاقية؟', '[{"id":"a","text":"لتمدّنا بالطاقة للحركة والنشاط"},{"id":"b","text":"لبناء العضلات فقط"},{"id":"c","text":"للوقاية من الأمراض فقط"},{"id":"d","text":"لا فائدة منها"}]'::jsonb, 'a', 'الأغذية الطاقية تمدّ الجسم بالطاقة اللازمة للحركة والنشاط، كالوقود للمحرّك.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86f7cb8e-4e3e-5896-9e40-24aca9a83752', '53806760-025b-5607-a36f-c06aa58cb33d', 'كم عدد مجموعات الأغذية الرئيسية حسب فائدتها؟', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"5"},{"id":"d","text":"3"}]'::jsonb, 'd', 'تُصنّف الأغذية إلى 3 مجموعات: بناءة وطاقية ووقائية.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7dd303ac-a904-50f9-bd50-b819e06429e6', '53806760-025b-5607-a36f-c06aa58cb33d', 'الزيت والزبدة والسكّر أغذية:', '[{"id":"a","text":"بناءة"},{"id":"b","text":"وقائية"},{"id":"c","text":"طاقية"},{"id":"d","text":"معدنية"}]'::jsonb, 'c', 'الزيت والزبدة والسكّر أغذية طاقية تمدّ الجسم بالطاقة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63036159-bb1f-5661-aa54-c06d41f68626', '53806760-025b-5607-a36f-c06aa58cb33d', 'ما الذي يوفّر للجسم الفيتامينات والأملاح المعدنية؟', '[{"id":"a","text":"الخضر والغلال"},{"id":"b","text":"الحلويات"},{"id":"c","text":"اللحوم فقط"},{"id":"d","text":"الزيوت"}]'::jsonb, 'a', 'الخضر والغلال (أغذية وقائية) توفّر الفيتامينات والأملاح المعدنية التي تقي الجسم من الأمراض.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6efea3ef-f8ab-5f00-b008-2a6769877d9e', '64469134-2e63-51f3-b864-290f8542b2a5', 'eveil-scientifique-4eme', '⚔️ زعيم الفصل ⭐⭐⭐: خبير التوازن الغذائي', 3, 120, 30, 'boss', 'admin', 2)
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
  ('69de082a-0bbb-586a-bdef-695a50c2d764', '6efea3ef-f8ab-5f00-b008-2a6769877d9e', 'لماذا يجب تنويع الطعام بين المجموعات الثلاث؟', '[{"id":"a","text":"لأنّ كلّ مجموعةٍ تقدّم فائدةً مختلفة يحتاجها الجسم"},{"id":"b","text":"لأنّ التنويع يزيد الوزن دائمًا"},{"id":"c","text":"لا فائدة من التنويع"},{"id":"d","text":"لأنّ صنفًا واحدًا يكفي الجسم"}]'::jsonb, 'a', 'كلّ مجموعةٍ غذائية تقدّم فائدةً مختلفة (بناء، طاقة، وقاية)، فالتنويع يضمن حصول الجسم على كلّ حاجاته.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf0550b8-7f84-5ea6-bec5-3eda0f4b8a04', '6efea3ef-f8ab-5f00-b008-2a6769877d9e', 'ما خطر الإفراط في السكّريات والدهون؟', '[{"id":"a","text":"يقوّي الجسم ويحسّن المناعة"},{"id":"b","text":"يسبّب السمنة وأمراضًا"},{"id":"c","text":"يحسّن النظر"},{"id":"d","text":"لا خطر منه"}]'::jsonb, 'b', 'الإفراط في السكّريات والدهون يسبّب السمنة وتسوّس الأسنان وأمراضًا أخرى.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a43c24c4-3dad-53a2-a8f5-3a7564f99cb7', '6efea3ef-f8ab-5f00-b008-2a6769877d9e', 'طفلٌ في مرحلة النموّ يحتاج خاصّةً إلى الأغذية:', '[{"id":"a","text":"المحلّاة"},{"id":"b","text":"الدهنية"},{"id":"c","text":"الغازية"},{"id":"d","text":"البناءة"}]'::jsonb, 'd', 'الطفل في مرحلة النموّ يحتاج خاصّةً إلى الأغذية البناءة (كالحليب والبيض) لبناء عظامه وعضلاته.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5c2f542-d8ba-55c9-9941-74b38513d5e3', '6efea3ef-f8ab-5f00-b008-2a6769877d9e', 'أيّ هذه الوجبات أكثر توازنًا؟', '[{"id":"a","text":"حلويات فقط"},{"id":"b","text":"خبز ومشروب غازيّ"},{"id":"c","text":"خبز + سمك + سلطة خضر + غلّة"},{"id":"d","text":"بطاطا مقلية فقط"}]'::jsonb, 'c', 'هذه الوجبة تجمع الأصناف الثلاثة: طاقية (خبز) وبناءة (سمك) ووقائية (خضر وغلّة)، فهي متوازنة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7052fd4-b85d-51af-89b3-4b15275a3f30', '6efea3ef-f8ab-5f00-b008-2a6769877d9e', 'لماذا يُعدّ الماء ضروريًّا للجسم؟', '[{"id":"a","text":"لأنّه يمنح الطاقة مثل السكّر"},{"id":"b","text":"لأنّه يدخل في تركيب الجسم ويساعده على القيام بوظائفه"},{"id":"c","text":"لأنّه غذاء بناء فقط"},{"id":"d","text":"لأنّ الجسم لا يحتاجه"}]'::jsonb, 'b', 'الماء يدخل في تركيب الجسم (معظم جسمنا ماء) ويساعد على القيام بوظائفه، فهو ضروريّ يوميًّا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5958931-d78d-5ca2-adee-1f310675092e', '6efea3ef-f8ab-5f00-b008-2a6769877d9e', 'الجري السريع في حصّة الرياضة يحتاج طاقةً من الأغذية:', '[{"id":"a","text":"الوقائية"},{"id":"b","text":"البناءة فقط"},{"id":"c","text":"الطاقية"},{"id":"d","text":"لا يحتاج طاقةً"}]'::jsonb, 'c', 'الحركة والجري يحتاجان طاقةً يوفّرها الجسم من الأغذية الطاقية كالخبز والعجائن.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('49c12746-5cb9-55e9-970f-4f0fbb5e97a7', '64469134-2e63-51f3-b864-290f8542b2a5', 'eveil-scientifique-4eme', '⭐⭐ تمرين مراجعة (نمط امتحان): التغذية المتوازنة', 2, 70, 15, 'practice', 'admin', 3)
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
  ('23a87c8a-6a27-5267-a316-4d3b5b995840', '49c12746-5cb9-55e9-970f-4f0fbb5e97a7', 'الأغذية البناءة تساعد على:', '[{"id":"a","text":"الوقاية من الأمراض فقط"},{"id":"b","text":"النموّ وبناء الجسم"},{"id":"c","text":"إعطاء الطاقة فقط"},{"id":"d","text":"لا فائدة لها"}]'::jsonb, 'b', 'الأغذية البناءة تساعد على النموّ وبناء الجسم (العظام والعضلات).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('81301fb5-eee0-5e8e-9aa7-09e924c95822', '49c12746-5cb9-55e9-970f-4f0fbb5e97a7', 'أيّ هذه غذاء طاقيّ؟', '[{"id":"a","text":"الجزر"},{"id":"b","text":"البرتقال"},{"id":"c","text":"الأرز"},{"id":"d","text":"السمك"}]'::jsonb, 'c', 'الأرز غذاء طاقيّ يمدّ الجسم بالطاقة. أمّا الجزر والبرتقال فوقائيّان والسمك بناء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('edd61b7f-9dd2-5e89-8479-a026cad2ffc5', '49c12746-5cb9-55e9-970f-4f0fbb5e97a7', 'الأغذية الوقائية مصدرها غالبًا:', '[{"id":"a","text":"الخضر والغلال"},{"id":"b","text":"اللحوم"},{"id":"c","text":"الزيوت"},{"id":"d","text":"الحلويات"}]'::jsonb, 'a', 'الأغذية الوقائية مصدرها الخضر والغلال، وهي غنيّة بالفيتامينات والأملاح المعدنية.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2edca35-6bb9-52be-91c7-6101604568c4', '49c12746-5cb9-55e9-970f-4f0fbb5e97a7', 'أيّ هذه الوجبات أكثر صحّة في الإفطار؟', '[{"id":"a","text":"حلوى وعصير محلّى"},{"id":"b","text":"مشروب غازيّ فقط"},{"id":"c","text":"بطاطا مقلية فقط"},{"id":"d","text":"حليب + خبز + غلّة"}]'::jsonb, 'd', 'هذه الوجبة متوازنة: حليب (بناء) وخبز (طاقة) وغلّة (وقاية).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9cca089a-2d1c-5817-ad90-83931a4f8435', '49c12746-5cb9-55e9-970f-4f0fbb5e97a7', 'أيّ المشروبات هو الأفضل لجسمك؟', '[{"id":"a","text":"الماء"},{"id":"b","text":"المشروب الغازيّ"},{"id":"c","text":"العصير المحلّى"},{"id":"d","text":"القهوة"}]'::jsonb, 'a', 'الماء هو الأفضل لأنّه ضروريّ للجسم ولا يحتوي على سكّرٍ مضرّ كالمشروبات الأخرى.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80ecc15d-4877-59ef-9977-81e0ea02531e', '49c12746-5cb9-55e9-970f-4f0fbb5e97a7', 'كم مجموعةً غذائية رئيسية تُصنّف إليها الأغذية؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"5"},{"id":"d","text":"6"}]'::jsonb, 'b', 'تُصنّف الأغذية إلى 3 مجموعات: بناءة وطاقية ووقائية.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4c35245e-5203-53aa-817f-2da7da2807d9', '64469134-2e63-51f3-b864-290f8542b2a5', 'eveil-scientifique-4eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: أسرار الغذاء السليم', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('6071cb69-b784-5199-a037-b032c1824ba2', '4c35245e-5203-53aa-817f-2da7da2807d9', 'شخصٌ يأكل الحلويات والدهون بإفراطٍ ويهمل الخضر والغلال. ما الخطر المتوقّع؟', '[{"id":"a","text":"صحّة مثالية"},{"id":"b","text":"السمنة ونقص العناصر الوقائية"},{"id":"c","text":"نموّ سريع وسليم"},{"id":"d","text":"لا خطر إطلاقًا"}]'::jsonb, 'b', 'الإفراط في السكّر والدهون يسبّب السمنة، وإهمال الخضر والغلال يحرم الجسم من الفيتامينات الوقائية.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44648260-ca2f-5875-86cc-49f644477c26', '4c35245e-5203-53aa-817f-2da7da2807d9', 'لماذا لا يكفي أن نأكل اللحم فقط؟', '[{"id":"a","text":"لأنّ اللحم غالي الثمن"},{"id":"b","text":"لأنّ اللحم ضارّ بالجسم"},{"id":"c","text":"لأنّ الجسم يحتاج إلى الطاقة والوقاية من مجموعاتٍ أخرى أيضًا"},{"id":"d","text":"لأنّ اللحم غذاء وقائيّ"}]'::jsonb, 'c', 'اللحم بناء فقط؛ والجسم يحتاج أيضًا إلى الطاقة (الطاقية) والوقاية (الوقائية)، لذا وجب التنويع.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3727d3f-f97b-5462-8684-f842621eae1f', '4c35245e-5203-53aa-817f-2da7da2807d9', 'رياضيٌّ يحتاج طاقةً كبيرة قبل سباق. أيّ الأغذية تناسبه أكثر؟', '[{"id":"a","text":"الماء فقط"},{"id":"b","text":"الخضر فقط"},{"id":"c","text":"لا شيء"},{"id":"d","text":"الأغذية الطاقية كالعجائن والخبز"}]'::jsonb, 'd', 'السباق يستهلك طاقةً كبيرة، فالأغذية الطاقية (العجائن والخبز) توفّرها للجسم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('578b3b8d-0c84-5d4a-b347-f9ed37484b04', '4c35245e-5203-53aa-817f-2da7da2807d9', 'لماذا تُنصح الوجبة المتوازنة التي تجمع الأصناف الثلاثة؟', '[{"id":"a","text":"لأنّها توفّر البناء والطاقة والوقاية معًا"},{"id":"b","text":"لأنّها أرخص ثمنًا"},{"id":"c","text":"لأنّها ألذّ طعمًا فقط"},{"id":"d","text":"لأنّها تزيد الوزن بسرعة"}]'::jsonb, 'a', 'الوجبة المتوازنة تجمع البناء والطاقة والوقاية، فيحصل الجسم على كلّ حاجاته في وقتٍ واحد.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a25198f4-a080-557b-8da2-deaef62a055c', '4c35245e-5203-53aa-817f-2da7da2807d9', 'لماذا يحتاج الجسم إلى الفيتامينات؟', '[{"id":"a","text":"لبناء العضلات فقط"},{"id":"b","text":"لإعطاء الطاقة فقط"},{"id":"c","text":"للوقاية من الأمراض والحفاظ على الصحّة"},{"id":"d","text":"لا حاجة للجسم بها"}]'::jsonb, 'c', 'الفيتامينات (من الخضر والغلال) تقي الجسم من الأمراض وتحافظ على صحّته.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('96315407-d1b3-5555-a4da-692c11723bbf', '4c35245e-5203-53aa-817f-2da7da2807d9', 'ماذا يحدث إذا لم يشرب الإنسان كمّيةً كافية من الماء؟', '[{"id":"a","text":"يصاب بالعطش والجفاف ويتعب جسمه"},{"id":"b","text":"يصبح أقوى"},{"id":"c","text":"لا يتأثّر إطلاقًا"},{"id":"d","text":"يزداد طاقةً ونشاطًا"}]'::jsonb, 'a', 'نقص الماء يسبّب العطش والجفاف ويُتعب الجسم، لأنّ الماء ضروريّ لوظائف الجسم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0f554f05-97ae-5925-9ecf-e878d1738b42', '64469134-2e63-51f3-b864-290f8542b2a5', 'eveil-scientifique-4eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للتغذية', 3, 120, 30, 'boss', 'admin', 5)
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
  ('5e9daeb3-8a4b-5e3f-9a40-2f4ddab5326e', '0f554f05-97ae-5925-9ecf-e878d1738b42', 'السمك والبيض من الأغذية:', '[{"id":"a","text":"الطاقية"},{"id":"b","text":"الوقائية"},{"id":"c","text":"البناءة"},{"id":"d","text":"الغازية"}]'::jsonb, 'c', 'السمك والبيض أغذية بناءة تساعد على النموّ وبناء الجسم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8afa6e8-6858-581c-a50f-745dd391b5fa', '0f554f05-97ae-5925-9ecf-e878d1738b42', 'أيّ هذه غذاء وقائيّ؟', '[{"id":"a","text":"الخبز"},{"id":"b","text":"الطماطم"},{"id":"c","text":"الزبدة"},{"id":"d","text":"السكّر"}]'::jsonb, 'b', 'الطماطم من الخضر، وهي غذاء وقائيّ غنيّ بالفيتامينات. أمّا الخبز والزبدة والسكّر فطاقية.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7e40bb9-75b7-5b8b-a3d0-497a54be6413', '0f554f05-97ae-5925-9ecf-e878d1738b42', 'الأغذية الطاقية تمدّ الجسم بـ:', '[{"id":"a","text":"الطاقة للحركة والنشاط"},{"id":"b","text":"الفيتامينات للوقاية"},{"id":"c","text":"مواد البناء فقط"},{"id":"d","text":"الماء"}]'::jsonb, 'a', 'الأغذية الطاقية (كالخبز والزيت) تمدّ الجسم بالطاقة اللازمة للحركة والنشاط.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b1317621-009c-5ec2-9ff6-a939f89924cb', '0f554f05-97ae-5925-9ecf-e878d1738b42', 'ما أساس الغذاء المتوازن؟', '[{"id":"a","text":"أكل صنفٍ واحد باستمرار"},{"id":"b","text":"الإكثار من الحلويات"},{"id":"c","text":"الإكثار من الدهون"},{"id":"d","text":"تنويع الأصناف من المجموعات الثلاث"}]'::jsonb, 'd', 'أساس الغذاء المتوازن هو تنويع الأصناف من المجموعات الثلاث (بناءة وطاقية ووقائية) مع الماء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c442218f-ce95-5695-a4a3-a8ee58f934b7', '0f554f05-97ae-5925-9ecf-e878d1738b42', 'لماذا نشرب الماء يوميًّا؟', '[{"id":"a","text":"لأنّه يمنح طاقة كبيرة"},{"id":"b","text":"لأنّه غذاء بناء"},{"id":"c","text":"لأنّه ضروريّ لتركيب الجسم وقيامه بوظائفه"},{"id":"d","text":"لا حاجة للجسم به"}]'::jsonb, 'c', 'الماء ضروريّ لأنّه يدخل في تركيب الجسم ويساعده على القيام بوظائفه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e45565c-d5ea-5405-99b0-650f98722a7c', '0f554f05-97ae-5925-9ecf-e878d1738b42', 'الإفراط في السكّر قد يسبّب:', '[{"id":"a","text":"تقوية المناعة"},{"id":"b","text":"تسوّس الأسنان والسمنة"},{"id":"c","text":"تحسين النظر"},{"id":"d","text":"لا ضرر منه"}]'::jsonb, 'b', 'الإفراط في السكّر يسبّب تسوّس الأسنان والسمنة، لذا يُنصح بالتقليل منه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bb1fd612-5940-561f-85a1-d6528f52c8ae', 'd24bba9a-93d9-5ef0-98c4-b8ae4f833446', 'eveil-scientifique-4eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('9c740891-3ff8-5263-8f15-17139673634f', 'bb1fd612-5940-561f-85a1-d6528f52c8ae', 'ما حالة الماء حين يكون جليدًا؟', '[{"id":"a","text":"سائلة"},{"id":"b","text":"صلبة"},{"id":"c","text":"غازية"},{"id":"d","text":"لا حالة له"}]'::jsonb, 'b', 'الجليد هو الماء في حالته الصلبة، وله شكلٌ ثابت وصلابة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ad10810-03d2-5316-9e55-9aa8e4d142da', 'bb1fd612-5940-561f-85a1-d6528f52c8ae', 'تحوّل الجليد إلى ماءٍ سائل يُسمّى:', '[{"id":"a","text":"التجمّد"},{"id":"b","text":"التبخّر"},{"id":"c","text":"الانصهار"},{"id":"d","text":"التكاثف"}]'::jsonb, 'c', 'تحوّل الجليد الصلب إلى ماءٍ سائل عند التسخين يُسمّى الانصهار.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0bbfa6b0-9075-5606-9645-51504d6e198c', 'bb1fd612-5940-561f-85a1-d6528f52c8ae', 'عند أيّ درجة حرارةٍ يتجمّد الماء؟', '[{"id":"a","text":"0 °C"},{"id":"b","text":"100 °C"},{"id":"c","text":"50 °C"},{"id":"d","text":"10 °C"}]'::jsonb, 'a', 'يتجمّد الماء (يتحوّل إلى جليد) عند درجة حرارة 0 °C.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('91da652f-7de0-573d-849e-7f2de35988a5', 'bb1fd612-5940-561f-85a1-d6528f52c8ae', 'تحوّل الماء السائل إلى بخار يُسمّى:', '[{"id":"a","text":"التجمّد"},{"id":"b","text":"الانصهار"},{"id":"c","text":"التكاثف"},{"id":"d","text":"التبخّر"}]'::jsonb, 'd', 'تحوّل الماء السائل إلى بخار (غاز) يُسمّى التبخّر، ويكون أسرع كلّما ارتفعت الحرارة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f5bdad6-0cd8-511e-bd96-a1dd8de9e45f', 'bb1fd612-5940-561f-85a1-d6528f52c8ae', 'بخار الماء هو الماء في حالته:', '[{"id":"a","text":"الصلبة"},{"id":"b","text":"السائلة"},{"id":"c","text":"الغازية"},{"id":"d","text":"المتجمّدة"}]'::jsonb, 'c', 'بخار الماء هو الحالة الغازية للماء، وهو منتشرٌ في الهواء ولا نراه عادةً.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bd6c71f0-aef6-57d9-9c50-96d60dd83528', 'd24bba9a-93d9-5ef0-98c4-b8ae4f833446', 'eveil-scientifique-4eme', '⭐ تمرين: أوّل خطوات مع حالات الماء', 1, 50, 10, 'practice', 'admin', 1)
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
  ('e6a67201-5ade-5e4f-a794-11c5893bd7cc', 'bd6c71f0-aef6-57d9-9c50-96d60dd83528', 'كم عدد حالات الماء؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"1"}]'::jsonb, 'b', 'للماء 3 حالات: صلبة وسائلة وغازية.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ddf3c54e-7180-5e1e-b71e-898adeeda33d', 'bd6c71f0-aef6-57d9-9c50-96d60dd83528', 'الماء الذي نشربه يكون في حالته:', '[{"id":"a","text":"الصلبة"},{"id":"b","text":"الغازية"},{"id":"c","text":"السائلة"},{"id":"d","text":"لا حالة له"}]'::jsonb, 'c', 'الماء الذي نشربه سائل، يأخذ شكل الإناء الذي يحويه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a819b559-9cf4-56d0-9f79-51aaff3566e0', 'bd6c71f0-aef6-57d9-9c50-96d60dd83528', 'تجمّد الماء يحوّله إلى:', '[{"id":"a","text":"جليدٍ صلب"},{"id":"b","text":"بخار"},{"id":"c","text":"سائلٍ أكثر"},{"id":"d","text":"غاز"}]'::jsonb, 'a', 'عند التجمّد يتحوّل الماء السائل إلى جليدٍ صلب.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e91ac39-f438-5607-b61a-cd31aee99ea8', 'bd6c71f0-aef6-57d9-9c50-96d60dd83528', 'عند أيّ درجة حرارةٍ يغلي الماء عادةً؟', '[{"id":"a","text":"0 °C"},{"id":"b","text":"10 °C"},{"id":"c","text":"50 °C"},{"id":"d","text":"100 °C"}]'::jsonb, 'd', 'يغلي الماء عادةً عند درجة حرارة 100 °C، فيتصاعد منه البخار بكثرة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ea6a3dd-2fdc-5db5-a85f-6239ac88502e', 'bd6c71f0-aef6-57d9-9c50-96d60dd83528', 'تحوّل بخار الماء إلى قطراتٍ سائلة يُسمّى:', '[{"id":"a","text":"التبخّر"},{"id":"b","text":"الانصهار"},{"id":"c","text":"التكاثف"},{"id":"d","text":"التجمّد"}]'::jsonb, 'c', 'تحوّل البخار إلى قطراتٍ سائلة عند ملامسته سطحًا باردًا يُسمّى التكاثف.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c889908-8a76-5eee-ba89-eb6d7b1364b3', 'bd6c71f0-aef6-57d9-9c50-96d60dd83528', 'الثلج والجليد هما الماء في حالته:', '[{"id":"a","text":"الصلبة"},{"id":"b","text":"السائلة"},{"id":"c","text":"الغازية"},{"id":"d","text":"لا حالة له"}]'::jsonb, 'a', 'الثلج والجليد هما الماء في حالته الصلبة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1b604c61-0148-528e-ac2c-6bd85fa66a1a', 'd24bba9a-93d9-5ef0-98c4-b8ae4f833446', 'eveil-scientifique-4eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد التحوّلات', 3, 120, 30, 'boss', 'admin', 2)
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
  ('177dae34-bfd9-58ad-8c56-43c2f9f3469b', '1b604c61-0148-528e-ac2c-6bd85fa66a1a', 'لماذا تظهر قطرات ماءٍ على سطح كأسٍ باردة في جوٍّ حارّ؟', '[{"id":"a","text":"لأنّ بخار الماء الموجود في الهواء يتكاثف على السطح البارد"},{"id":"b","text":"لأنّ الكأس يسرّب الماء من داخله"},{"id":"c","text":"لأنّ الماء داخل الكأس يغلي"},{"id":"d","text":"لا يوجد سبب علميّ"}]'::jsonb, 'a', 'بخار الماء في الهواء يلامس السطح البارد فيتكاثف ويتحوّل إلى قطراتٍ سائلة على الكأس.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eca6f859-328e-520a-a576-f8e3798d95ca', '1b604c61-0148-528e-ac2c-6bd85fa66a1a', 'ماذا يحدث للجليد إذا تركناه في غرفةٍ دافئة؟', '[{"id":"a","text":"يتجمّد أكثر"},{"id":"b","text":"ينصهر ويتحوّل إلى ماءٍ سائل"},{"id":"c","text":"يتحوّل مباشرةً إلى جليدٍ أصلب"},{"id":"d","text":"يختفي دون أيّ أثر"}]'::jsonb, 'b', 'الحرارة الدافئة تسخّن الجليد فينصهر ويتحوّل إلى ماءٍ سائل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6c2e1db7-c849-56a7-be93-a4c2b468521f', '1b604c61-0148-528e-ac2c-6bd85fa66a1a', 'متى يكون تبخّر الماء أسرع؟', '[{"id":"a","text":"عندما يبرد الجوّ"},{"id":"b","text":"عندما يتجمّد الماء"},{"id":"c","text":"عندما يقلّ الضوء"},{"id":"d","text":"عندما ترتفع الحرارة"}]'::jsonb, 'd', 'كلّما ارتفعت الحرارة زادت سرعة تبخّر الماء (لذلك يجفّ الغسيل أسرع في الشمس).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22796fab-e111-58cc-9309-a20f4cf6f1f5', '1b604c61-0148-528e-ac2c-6bd85fa66a1a', 'عند تبريد الماء السائل حتّى 0 °C يحدث:', '[{"id":"a","text":"التبخّر"},{"id":"b","text":"الانصهار"},{"id":"c","text":"التجمّد"},{"id":"d","text":"الغليان"}]'::jsonb, 'c', 'عند 0 °C يتجمّد الماء السائل ويتحوّل إلى جليدٍ صلب.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac998c1c-7ad7-5ff4-b050-3b65745b47e2', '1b604c61-0148-528e-ac2c-6bd85fa66a1a', 'أين نجد الماء في حالته الغازية في الطبيعة؟', '[{"id":"a","text":"في مكعّبات الثلج"},{"id":"b","text":"بخار الماء المنتشر في الهواء"},{"id":"c","text":"في مياه البحر السائلة"},{"id":"d","text":"لا وجود له في الطبيعة"}]'::jsonb, 'b', 'الماء في حالته الغازية موجودٌ كبخارٍ منتشرٍ في الهواء من حولنا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('377be3f8-a9ea-55e5-9291-b1801810673d', '1b604c61-0148-528e-ac2c-6bd85fa66a1a', 'في دورة الماء، يتبخّر ماء البحر ثمّ يتكاثف في الأعالي مكوّنًا:', '[{"id":"a","text":"الجليد على الأرض"},{"id":"b","text":"الصخور"},{"id":"c","text":"السحب"},{"id":"d","text":"الرمال"}]'::jsonb, 'c', 'يتبخّر ماء البحر بفعل حرارة الشمس، ثمّ يتكاثف بخاره في الجوّ البارد مكوّنًا السحب.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1c5f09ce-cf0b-5a6e-a592-1e202e1fb1ae', 'd24bba9a-93d9-5ef0-98c4-b8ae4f833446', 'eveil-scientifique-4eme', '⭐⭐ تمرين مراجعة (نمط امتحان): حالات الماء', 2, 70, 15, 'practice', 'admin', 3)
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
  ('87aabf01-d2a1-50ac-ba47-dc60f811a48d', '1c5f09ce-cf0b-5a6e-a592-1e202e1fb1ae', 'ما حالة الماء حين يكون بخارًا؟', '[{"id":"a","text":"الصلبة"},{"id":"b","text":"الغازية"},{"id":"c","text":"السائلة"},{"id":"d","text":"المتجمّدة"}]'::jsonb, 'b', 'البخار هو الماء في حالته الغازية.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f88142c8-0b26-5bc0-8004-89aaac96bc05', '1c5f09ce-cf0b-5a6e-a592-1e202e1fb1ae', 'الانصهار هو تحوّل:', '[{"id":"a","text":"السائل إلى غاز"},{"id":"b","text":"الغاز إلى سائل"},{"id":"c","text":"الصلب إلى سائل"},{"id":"d","text":"السائل إلى صلب"}]'::jsonb, 'c', 'الانصهار هو تحوّل المادّة من الحالة الصلبة إلى السائلة (مثل ذوبان الجليد).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ecbc54b2-57f4-5088-8277-79040297bcfc', '1c5f09ce-cf0b-5a6e-a592-1e202e1fb1ae', 'ماذا يحدث للماء عند درجة 0 °C؟', '[{"id":"a","text":"يتجمّد فيصير جليدًا"},{"id":"b","text":"يغلي ويتبخّر بسرعة"},{"id":"c","text":"لا يحدث له شيء"},{"id":"d","text":"يتحوّل إلى غازٍ مباشرةً"}]'::jsonb, 'a', 'عند 0 °C يتجمّد الماء ويتحوّل من الحالة السائلة إلى الصلبة (جليد).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1bce382a-f1cd-51f5-abf3-48f8198f9767', '1c5f09ce-cf0b-5a6e-a592-1e202e1fb1ae', 'تحوّل الماء السائل إلى بخار يُسمّى:', '[{"id":"a","text":"التجمّد"},{"id":"b","text":"التكاثف"},{"id":"c","text":"الانصهار"},{"id":"d","text":"التبخّر"}]'::jsonb, 'd', 'تحوّل الماء السائل إلى بخار (غاز) يُسمّى التبخّر.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9365ffdd-862e-57ac-855b-dec527e2a327', '1c5f09ce-cf0b-5a6e-a592-1e202e1fb1ae', 'عند أيّ درجة حرارةٍ يغلي الماء عادةً؟', '[{"id":"a","text":"100 °C"},{"id":"b","text":"0 °C"},{"id":"c","text":"50 °C"},{"id":"d","text":"10 °C"}]'::jsonb, 'a', 'يغلي الماء عادةً عند 100 °C.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc25120c-e6f1-5e32-a63d-5685e91a0c32', '1c5f09ce-cf0b-5a6e-a592-1e202e1fb1ae', 'مكعّب الثلج هو الماء في حالته:', '[{"id":"a","text":"السائلة"},{"id":"b","text":"الصلبة"},{"id":"c","text":"الغازية"},{"id":"d","text":"لا حالة له"}]'::jsonb, 'b', 'مكعّب الثلج هو ماءٌ متجمّد في الحالة الصلبة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cc23f918-d59a-5571-a1cc-f0dcab282398', 'd24bba9a-93d9-5ef0-98c4-b8ae4f833446', 'eveil-scientifique-4eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: أسرار الماء', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('fcb92794-4fb8-5245-af4d-c3c2c4941e09', 'cc23f918-d59a-5571-a1cc-f0dcab282398', 'غسيلٌ مبلّل عُلّق في الشمس فجفّ. ما الذي حدث للماء؟', '[{"id":"a","text":"تجمّد"},{"id":"b","text":"تبخّر وتحوّل إلى بخار"},{"id":"c","text":"انصهر"},{"id":"d","text":"بقي كما هو"}]'::jsonb, 'b', 'حرارة الشمس بخّرت ماء الغسيل فتحوّل إلى بخارٍ انتشر في الهواء، فجفّ الغسيل.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2e3dc0d-dede-52a8-8179-27b239ccde5f', 'cc23f918-d59a-5571-a1cc-f0dcab282398', 'لماذا يتحوّل الماء في المجمّد (الفريزر) إلى جليد؟', '[{"id":"a","text":"لأنّ الحرارة ترتفع كثيرًا"},{"id":"b","text":"بسبب الضوء داخل المجمّد"},{"id":"c","text":"لأنّ الحرارة تنخفض إلى ما دون 0 °C فيتجمّد"},{"id":"d","text":"لأنّ الماء يغلي"}]'::jsonb, 'c', 'المجمّد يبرّد الماء إلى ما دون 0 °C، فيتجمّد ويتحوّل إلى جليدٍ صلب.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5cd8817-7d20-50a3-8d0f-626631cb2da9', 'cc23f918-d59a-5571-a1cc-f0dcab282398', 'رتّب التحوّل: ماء سائل ← تبريدٌ شديد ← ؟', '[{"id":"a","text":"بخار"},{"id":"b","text":"سائلٌ أكثر"},{"id":"c","text":"غاز"},{"id":"d","text":"جليدٌ صلب"}]'::jsonb, 'd', 'التبريد الشديد للماء السائل يحوّله إلى جليدٍ صلب (تجمّد).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('99d62e06-46f1-58a8-81a7-4be68941a913', 'cc23f918-d59a-5571-a1cc-f0dcab282398', 'لماذا يتصاعد بخارٌ من إناء ماءٍ يغلي؟', '[{"id":"a","text":"لأنّ الماء يتبخّر بفعل الحرارة العالية"},{"id":"b","text":"لأنّ الماء يتجمّد"},{"id":"c","text":"لأنّ الماء ينصهر"},{"id":"d","text":"لا يوجد سبب"}]'::jsonb, 'a', 'الحرارة العالية (نحو 100 °C) تبخّر الماء بسرعة، فيتصاعد البخار من الإناء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a71e2b0-9bcd-5727-bb9f-7a6f855465d5', 'cc23f918-d59a-5571-a1cc-f0dcab282398', 'في الصباح نجد قطرات ندًى على أوراق النبات. ما تفسير ذلك؟', '[{"id":"a","text":"مطرٌ خفيف فقط"},{"id":"b","text":"تبخّر ماء النبات"},{"id":"c","text":"تكاثف بخار الماء على النبات عند برودة الليل"},{"id":"d","text":"تجمّد ماء البحر"}]'::jsonb, 'c', 'في برودة الليل يتكاثف بخار الماء الموجود في الهواء على أوراق النبات مكوّنًا قطرات الندى.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('46e7944f-2911-5c28-b48a-d3ff6cb972af', 'cc23f918-d59a-5571-a1cc-f0dcab282398', 'ما القاسم المشترك بين الجليد والماء السائل والبخار؟', '[{"id":"a","text":"كلّها حالاتٌ للمادّة نفسها: الماء"},{"id":"b","text":"كلّها موادّ مختلفة تمامًا"},{"id":"c","text":"لا علاقة بينها"},{"id":"d","text":"كلّها صلبة"}]'::jsonb, 'a', 'الجليد والماء والبخار ثلاث حالاتٍ مختلفة للمادّة نفسها (الماء)، يتحوّل بينها حسب الحرارة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('dbef3294-54da-52c4-95eb-57ea1057f597', 'd24bba9a-93d9-5ef0-98c4-b8ae4f833446', 'eveil-scientifique-4eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة لحالات الماء', 3, 120, 30, 'boss', 'admin', 5)
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
  ('c83e45ec-bd21-5a04-b925-20a1c76a3eaa', 'dbef3294-54da-52c4-95eb-57ea1057f597', 'تحوّل بخار الماء إلى ماءٍ سائل يُسمّى:', '[{"id":"a","text":"التبخّر"},{"id":"b","text":"التجمّد"},{"id":"c","text":"التكاثف"},{"id":"d","text":"الانصهار"}]'::jsonb, 'c', 'تحوّل البخار (الغاز) إلى ماءٍ سائل يُسمّى التكاثف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7b35c0b-b315-5676-950b-2e615d7a107e', 'dbef3294-54da-52c4-95eb-57ea1057f597', 'ماء البحيرة يكون في حالته:', '[{"id":"a","text":"الصلبة"},{"id":"b","text":"السائلة"},{"id":"c","text":"الغازية"},{"id":"d","text":"لا حالة له"}]'::jsonb, 'b', 'ماء البحيرة سائلٌ يأخذ شكل الحوض الذي يحويه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98950c03-51e1-50f5-9ad9-b30e1abdebef', 'dbef3294-54da-52c4-95eb-57ea1057f597', 'عند أيّ درجة حرارةٍ يتجمّد الماء؟', '[{"id":"a","text":"0 °C"},{"id":"b","text":"100 °C"},{"id":"c","text":"25 °C"},{"id":"d","text":"50 °C"}]'::jsonb, 'a', 'يتجمّد الماء عند درجة حرارة 0 °C.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c57b906a-673a-5163-b376-9ba577960882', 'dbef3294-54da-52c4-95eb-57ea1057f597', 'الانصهار يحوّل الجليد إلى:', '[{"id":"a","text":"بخار"},{"id":"b","text":"غاز"},{"id":"c","text":"جليدٍ أصلب"},{"id":"d","text":"ماءٍ سائل"}]'::jsonb, 'd', 'الانصهار يحوّل الجليد الصلب إلى ماءٍ سائل عند التسخين.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8138a419-b453-5e6a-8512-6c35b6b5b5df', 'dbef3294-54da-52c4-95eb-57ea1057f597', 'ما الذي يُسرّع تبخّر الماء؟', '[{"id":"a","text":"البرودة الشديدة"},{"id":"b","text":"الظلام"},{"id":"c","text":"ارتفاع الحرارة"},{"id":"d","text":"التجمّد"}]'::jsonb, 'c', 'ارتفاع الحرارة يُسرّع تبخّر الماء (يجفّ الغسيل أسرع في الجوّ الحارّ).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b10e97f1-58e0-556b-bd34-b4645779bd17', 'dbef3294-54da-52c4-95eb-57ea1057f597', 'كم عدد حالات الماء الثلاث؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'b', 'للماء 3 حالات: صلبة وسائلة وغازية.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a9803256-d8ec-55b7-ad38-4429605f21e4', '70e8ea22-72f4-5c70-970d-39ca792e03bc', 'eveil-scientifique-4eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('b5114512-5481-58ad-a8b5-20c09477e977', 'a9803256-d8ec-55b7-ad38-4429605f21e4', 'هل يشغل الهواء حيّزًا (مكانًا)؟', '[{"id":"a","text":"لا، لا يشغل أيّ شيء"},{"id":"b","text":"نعم، يشغل حيّزًا"},{"id":"c","text":"أحيانًا فقط"},{"id":"d","text":"لا أحد يعرف"}]'::jsonb, 'b', 'نعم، الهواء يشغل حيّزًا؛ والدليل خروج فقاعاته من قارورةٍ مغموسة في الماء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74f502e1-e030-5508-85da-89b0549dead8', 'a9803256-d8ec-55b7-ad38-4429605f21e4', 'ما هي الرياح؟', '[{"id":"a","text":"ماءٌ متحرّك"},{"id":"b","text":"بخارٌ متصاعد"},{"id":"c","text":"هواءٌ متحرّك"},{"id":"d","text":"غبارٌ فقط"}]'::jsonb, 'c', 'الرياح هي هواءٌ متحرّك، وله قوّة تحرّك الأشجار والأشرعة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6dd3fb9d-5ca5-5b28-82ca-a802f58bdbe0', 'a9803256-d8ec-55b7-ad38-4429605f21e4', 'لماذا الهواء ضروريّ للإنسان والحيوان؟', '[{"id":"a","text":"للتنفّس والبقاء على قيد الحياة"},{"id":"b","text":"للأكل"},{"id":"c","text":"للشرب"},{"id":"d","text":"لا فائدة منه"}]'::jsonb, 'a', 'يحتاج الإنسان والحيوان إلى الهواء (وخاصّةً الأكسجين) للتنفّس والبقاء أحياء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5fe0606d-7d83-55b3-aafd-b3b2a17c6adc', 'a9803256-d8ec-55b7-ad38-4429605f21e4', 'هل للهواء كتلة (وزن)؟', '[{"id":"a","text":"لا، الهواء بلا وزن"},{"id":"b","text":"لا أحد يستطيع معرفة ذلك"},{"id":"c","text":"فقط عندما يبرد"},{"id":"d","text":"نعم، للهواء كتلة"}]'::jsonb, 'd', 'نعم، للهواء كتلة؛ والدليل أنّ الكرة المنفوخة أثقل قليلًا من الكرة الفارغة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff378a4b-c836-5851-a638-bab1aa427fb7', 'a9803256-d8ec-55b7-ad38-4429605f21e4', 'لماذا لا نرى الهواء عادةً؟', '[{"id":"a","text":"لأنّه صغير الحجم"},{"id":"b","text":"لأنّه بعيدٌ عنّا"},{"id":"c","text":"لأنّه غازٌ شفّاف لا لون له"},{"id":"d","text":"لأنّه غير موجود"}]'::jsonb, 'c', 'الهواء غازٌ شفّاف لا لون له ولا رائحة، لذلك لا نراه رغم وجوده حولنا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('47cf114e-a8fd-50df-a526-2356d8ce5ca7', '70e8ea22-72f4-5c70-970d-39ca792e03bc', 'eveil-scientifique-4eme', '⭐ تمرين: أوّل خطوات في معرفة الهواء', 1, 50, 10, 'practice', 'admin', 1)
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
  ('06921fe4-f12d-5819-bcb9-fb6cfb8c474f', '47cf114e-a8fd-50df-a526-2356d8ce5ca7', 'أين يوجد الهواء؟', '[{"id":"a","text":"في الماء فقط"},{"id":"b","text":"حولنا في كلّ مكان"},{"id":"c","text":"في الجبال فقط"},{"id":"d","text":"لا وجود له"}]'::jsonb, 'b', 'الهواء موجودٌ حولنا في كلّ مكان، حتّى داخل ما يبدو «فارغًا».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7bc21821-b7d9-58b7-9eb9-1ba5d1c76989', '47cf114e-a8fd-50df-a526-2356d8ce5ca7', 'إذا غمرنا قارورةً «فارغة» مقلوبةً في الماء، ماذا يخرج منها؟', '[{"id":"a","text":"ماء فقط"},{"id":"b","text":"بخار"},{"id":"c","text":"فقاعات هواء"},{"id":"d","text":"لا شيء"}]'::jsonb, 'c', 'تخرج فقاعات هواء، وهذا يدلّ على أنّ القارورة كانت مملوءةً بالهواء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34b87d64-b37f-5207-86d9-9687a37c6575', '47cf114e-a8fd-50df-a526-2356d8ce5ca7', 'ما الذي يحرّك أوراق الأشجار وأشرعة القوارب؟', '[{"id":"a","text":"الهواء المتحرّك (الرياح)"},{"id":"b","text":"الماء"},{"id":"c","text":"الضوء"},{"id":"d","text":"الصوت"}]'::jsonb, 'a', 'الهواء المتحرّك (الرياح) له قوّة تحرّك الأوراق وتدفع أشرعة القوارب.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16df95b9-1878-5b0f-b072-5cf0d3c2f3de', '47cf114e-a8fd-50df-a526-2356d8ce5ca7', 'هل يحتاج النبات إلى الهواء؟', '[{"id":"a","text":"لا أبدًا"},{"id":"b","text":"فقط في الليل"},{"id":"c","text":"لا أحد يعرف"},{"id":"d","text":"نعم، يحتاجه للحياة"}]'::jsonb, 'd', 'نعم، النبات كائنٌ حيّ يحتاج إلى الهواء ليتنفّس ويبقى حيًّا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('038c1806-31cd-52ba-a3bd-a74952fc5160', '47cf114e-a8fd-50df-a526-2356d8ce5ca7', 'لماذا تنتفخ الكرة عند ضخّ الهواء فيها؟', '[{"id":"a","text":"لأنّ الماء يدخلها"},{"id":"b","text":"لأنّها تسخن"},{"id":"c","text":"لأنّ الهواء يملأ حيّزها الداخليّ"},{"id":"d","text":"لا يوجد سبب"}]'::jsonb, 'c', 'ينتفخ حجم الكرة لأنّ الهواء المضخوخ يشغل حيّزها الداخليّ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4766d3df-f751-5f3e-b589-b27f34a1797c', '47cf114e-a8fd-50df-a526-2356d8ce5ca7', 'ما حالة الهواء؟', '[{"id":"a","text":"غازية"},{"id":"b","text":"سائلة"},{"id":"c","text":"صلبة"},{"id":"d","text":"لا حالة له"}]'::jsonb, 'a', 'الهواء مادّةٌ في الحالة الغازية، شفّافٌ منتشرٌ في الفراغ من حولنا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('19632060-b4a8-5a58-923a-baeaa00b3343', '70e8ea22-72f4-5c70-970d-39ca792e03bc', 'eveil-scientifique-4eme', '⚔️ زعيم الفصل ⭐⭐⭐: صائد الهواء الخفيّ', 3, 120, 30, 'boss', 'admin', 2)
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
  ('3e2257d6-5887-54f3-9930-c382e195d814', '19632060-b4a8-5a58-923a-baeaa00b3343', 'كيف نُثبت أنّ الهواء يشغل حيّزًا؟', '[{"id":"a","text":"نغمر كأسًا مقلوبة في الماء فلا يدخلها الماء لأنّ الهواء يملؤها"},{"id":"b","text":"نتركها في الشمس فترةً"},{"id":"c","text":"نزن الكأس فقط"},{"id":"d","text":"لا يمكن إثبات ذلك"}]'::jsonb, 'a', 'عند غمر كأسٍ مقلوبة في الماء لا يدخلها الماء لأنّ الهواء بداخلها يشغل الحيّز ويمنعه، وهذا دليلٌ على أنّ الهواء يشغل مكانًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eaf483b2-fe2f-56e2-a95c-5d559a3b86e1', '19632060-b4a8-5a58-923a-baeaa00b3343', 'ما الذي يدلّ على أنّ للهواء كتلة؟', '[{"id":"a","text":"الكرة الفارغة أثقل من المنفوخة"},{"id":"b","text":"الكرة المنفوخة أثقل من الفارغة"},{"id":"c","text":"لا فرق في الوزن بينهما"},{"id":"d","text":"الهواء بلا كتلة"}]'::jsonb, 'b', 'الكرة المنفوخة بالهواء أثقل قليلًا من الفارغة، وهذا يدلّ على أنّ للهواء كتلة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f1cb49c-836b-5e6b-acf1-ac6408ed2b36', '19632060-b4a8-5a58-923a-baeaa00b3343', 'لماذا يحتاج اللهب (النار) إلى الهواء؟', '[{"id":"a","text":"لا يحتاج إليه إطلاقًا"},{"id":"b","text":"ليبرد فقط"},{"id":"c","text":"ليُطفئ نفسه"},{"id":"d","text":"لأنّ الاحتراق يحتاج إلى الأكسجين الموجود في الهواء"}]'::jsonb, 'd', 'الاحتراق يحتاج إلى الأكسجين الموجود في الهواء، ولهذا تنطفئ النار إذا حُرمت منه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07d176ad-6a11-52db-b775-f7ea94a16541', '19632060-b4a8-5a58-923a-baeaa00b3343', 'إذا غطّينا شمعةً مشتعلة بكأسٍ محكمة، ماذا يحدث؟', '[{"id":"a","text":"يزداد اللهب اشتعالًا"},{"id":"b","text":"لا يتغيّر شيء"},{"id":"c","text":"تنطفئ الشمعة بعد نفاد الأكسجين"},{"id":"d","text":"تنفجر الكأس"}]'::jsonb, 'c', 'تستهلك الشمعة الأكسجين داخل الكأس، فإذا نفد انطفأت؛ وهذا يثبت حاجة الاحتراق إلى الهواء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c27d9b54-51db-5336-b8a3-cb7ee8c67fd8', '19632060-b4a8-5a58-923a-baeaa00b3343', 'الرياح القويّة دليلٌ على أنّ الهواء:', '[{"id":"a","text":"ساكنٌ دائمًا"},{"id":"b","text":"يتحرّك ويملك قوّة"},{"id":"c","text":"لا وجود له"},{"id":"d","text":"سائلٌ يجري"}]'::jsonb, 'b', 'الرياح هواءٌ متحرّك، وقوّتها تدلّ على أنّ الهواء يتحرّك ويملك قوّةً تحرّك الأشياء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0306b933-68a8-589a-ab42-bc308ab17199', '19632060-b4a8-5a58-923a-baeaa00b3343', 'لماذا نشعر بنسيمٍ حين نحرّك مروحةً يدوية؟', '[{"id":"a","text":"لأنّها تنتج ماءً"},{"id":"b","text":"لأنّها تبرّد الضوء"},{"id":"c","text":"لأنّها تدفع الهواء فيتحرّك نحونا"},{"id":"d","text":"لا يوجد سبب"}]'::jsonb, 'c', 'المروحة تدفع الهواء المجاور فيتحرّك نحونا، فنشعر به نسيمًا على وجوهنا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('07f68222-195a-501b-b8f7-79d55b1d4c95', '70e8ea22-72f4-5c70-970d-39ca792e03bc', 'eveil-scientifique-4eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الهواء وخصائصه', 2, 70, 15, 'practice', 'admin', 3)
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
  ('cfefd04f-b06d-548c-b830-7596a0d53a8c', '07f68222-195a-501b-b8f7-79d55b1d4c95', 'هل نرى الهواء عادةً؟', '[{"id":"a","text":"نعم بوضوح"},{"id":"b","text":"لا، لأنّه غازٌ شفّاف"},{"id":"c","text":"فقط في النهار"},{"id":"d","text":"فقط داخل الماء"}]'::jsonb, 'b', 'لا نرى الهواء لأنّه غازٌ شفّاف لا لون له، لكنّه موجودٌ حولنا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('88d2d2fb-6b78-5bcb-adcb-d05667e58cf9', '07f68222-195a-501b-b8f7-79d55b1d4c95', 'الرياح هي:', '[{"id":"a","text":"ماءٌ متبخّر"},{"id":"b","text":"غبارٌ متطاير"},{"id":"c","text":"هواءٌ متحرّك"},{"id":"d","text":"سحابٌ منخفض"}]'::jsonb, 'c', 'الرياح هي هواءٌ متحرّك له قوّة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('981dfe9f-8c02-5878-b22c-ae23fd96ff06', '07f68222-195a-501b-b8f7-79d55b1d4c95', 'لماذا الهواء ضروريّ للكائنات الحيّة؟', '[{"id":"a","text":"لأنّها تتنفّسه لتبقى حيّة"},{"id":"b","text":"لتأكله"},{"id":"c","text":"لتشربه"},{"id":"d","text":"لا فائدة منه"}]'::jsonb, 'a', 'تتنفّس الكائنات الحيّة الهواء (الأكسجين) لتبقى على قيد الحياة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a0e57ea-6c17-5aea-a09e-446cd5033035', '07f68222-195a-501b-b8f7-79d55b1d4c95', 'عند نفخ بالونٍ يكبر حجمه لأنّ:', '[{"id":"a","text":"الماء يملؤه"},{"id":"b","text":"البالون يسخن"},{"id":"c","text":"البالون ينكمش"},{"id":"d","text":"الهواء يملأ حيّزه الداخليّ"}]'::jsonb, 'd', 'الهواء المنفوخ يملأ حيّز البالون الداخليّ فيكبر حجمه، وهذا يدلّ على أنّ الهواء يشغل حيّزًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6fef9846-a6a2-5d08-b046-10b770cd1a97', '07f68222-195a-501b-b8f7-79d55b1d4c95', 'هل للهواء كتلة؟', '[{"id":"a","text":"نعم، للهواء كتلة"},{"id":"b","text":"لا، بلا كتلة"},{"id":"c","text":"فقط عندما يبرد"},{"id":"d","text":"لا أحد يعرف"}]'::jsonb, 'a', 'نعم، للهواء كتلة؛ فالكرة المنفوخة أثقل من الفارغة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3bb995a9-bd1a-539a-aca3-2e75734bf0f5', '07f68222-195a-501b-b8f7-79d55b1d4c95', 'أين يوجد الهواء؟', '[{"id":"a","text":"في الماء فقط"},{"id":"b","text":"في كلّ مكانٍ حولنا"},{"id":"c","text":"في الفضاء البعيد فقط"},{"id":"d","text":"لا يوجد"}]'::jsonb, 'b', 'الهواء موجودٌ في كلّ مكانٍ حولنا، حتّى في ما يبدو فارغًا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('23a72c36-c437-5f07-a2c0-5d238cc76681', '70e8ea22-72f4-5c70-970d-39ca792e03bc', 'eveil-scientifique-4eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: أسرار الهواء', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('6e419c49-1772-5ba8-be34-708f001fb5b2', '23a72c36-c437-5f07-a2c0-5d238cc76681', 'قارورةٌ «فارغة» مغلقة بإحكام. هل هي فارغةٌ حقًّا؟', '[{"id":"a","text":"نعم، فارغةٌ تمامًا"},{"id":"b","text":"لا، هي مملوءةٌ بالهواء"},{"id":"c","text":"مملوءةٌ بالماء"},{"id":"d","text":"مملوءةٌ بالبخار فقط"}]'::jsonb, 'b', 'القارورة «الفارغة» مملوءةٌ في الحقيقة بالهواء، وهو ما نلاحظه حين تخرج فقاعاته عند غمرها في الماء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cab434eb-d6fa-52ed-9139-d4c29aa6df2d', '23a72c36-c437-5f07-a2c0-5d238cc76681', 'لماذا يرتفع منطاد الهواء الساخن أحيانًا في السماء؟', '[{"id":"a","text":"لأنّه ثقيلٌ جدًّا"},{"id":"b","text":"لأنّه مملوءٌ بالماء"},{"id":"c","text":"لأنّه مملوءٌ بهواءٍ ساخنٍ أخفّ من الهواء المحيط"},{"id":"d","text":"لا يوجد سبب"}]'::jsonb, 'c', 'الهواء الساخن أخفّ من الهواء البارد المحيط، فيرتفع المنطاد المملوء به إلى الأعلى.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9df0e6a-2d5b-5dc3-b9a1-058dc6bf1cac', '23a72c36-c437-5f07-a2c0-5d238cc76681', 'نغرق كأسًا مقلوبة بداخلها منديلٌ ورقيّ في الماء، فيبقى المنديل جافًّا. لماذا؟', '[{"id":"a","text":"لأنّ كمّية الماء قليلة"},{"id":"b","text":"لأنّ المنديل قويّ جدًّا"},{"id":"c","text":"لأنّ الماء يتبخّر بسرعة"},{"id":"d","text":"لأنّ الهواء داخل الكأس يشغل الحيّز ويمنع دخول الماء"}]'::jsonb, 'd', 'الهواء المحبوس داخل الكأس يشغل الحيّز ويمنع الماء من الوصول إلى المنديل، فيبقى جافًّا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('93f3e1aa-e44f-57c0-9eb7-95387cdf8909', '23a72c36-c437-5f07-a2c0-5d238cc76681', 'لماذا تموت الكائنات الحيّة إذا حُرمت من الهواء؟', '[{"id":"a","text":"لأنّها تحتاج إلى الأكسجين الموجود في الهواء للتنفّس"},{"id":"b","text":"لأنّها تحتاج الهواء لتأكله"},{"id":"c","text":"لأنّ الهواء يبرّدها فقط"},{"id":"d","text":"لا علاقة للهواء بالحياة"}]'::jsonb, 'a', 'تحتاج الكائنات الحيّة إلى الأكسجين الموجود في الهواء لتتنفّس؛ فبدونه لا تستطيع البقاء حيّة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('825ed756-9b28-531f-bf57-be06295067c2', '23a72c36-c437-5f07-a2c0-5d238cc76681', 'ما الذي يجعل طاحونة الهواء تدور؟', '[{"id":"a","text":"الماء الجاري"},{"id":"b","text":"ضوء الشمس مباشرةً"},{"id":"c","text":"الرياح (الهواء المتحرّك) تدفع أذرعها"},{"id":"d","text":"الحرارة وحدها"}]'::jsonb, 'c', 'الرياح هي هواءٌ متحرّك يدفع أذرع الطاحونة بقوّةٍ فتدور.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac795e98-9ade-5e8a-a543-4048eff19191', '23a72c36-c437-5f07-a2c0-5d238cc76681', 'ما القاسم المشترك بين نفخ بالونٍ وملء إطار درّاجة؟', '[{"id":"a","text":"في كليهما نملأ حيّزًا داخليًّا بالهواء"},{"id":"b","text":"في كليهما نملؤهما بالماء"},{"id":"c","text":"لا علاقة بينهما"},{"id":"d","text":"كلاهما يَفرغ من الهواء"}]'::jsonb, 'a', 'في الحالتين ندفع الهواء ليملأ حيّزًا داخليًّا (البالون أو الإطار)، فيدلّ ذلك على أنّ الهواء يشغل حيّزًا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('34d0c10d-e0d7-5829-bcbb-cdfbcd39adf3', '70e8ea22-72f4-5c70-970d-39ca792e03bc', 'eveil-scientifique-4eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للهواء', 3, 120, 30, 'boss', 'admin', 5)
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
  ('561de8d7-a7ce-5160-93f0-7295b3ee9269', '34d0c10d-e0d7-5829-bcbb-cdfbcd39adf3', 'الرياح هي هواءٌ:', '[{"id":"a","text":"ساكن"},{"id":"b","text":"سائل"},{"id":"c","text":"متحرّك"},{"id":"d","text":"متجمّد"}]'::jsonb, 'c', 'الرياح هي هواءٌ متحرّك له قوّة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('237af36f-b12b-5a2a-9a86-4bea5e923473', '34d0c10d-e0d7-5829-bcbb-cdfbcd39adf3', 'هل يشغل الهواء حيّزًا؟', '[{"id":"a","text":"لا، لا يشغل شيئًا"},{"id":"b","text":"نعم، يشغل حيّزًا"},{"id":"c","text":"أحيانًا فقط"},{"id":"d","text":"لا أحد يعرف"}]'::jsonb, 'b', 'نعم، الهواء يشغل حيّزًا، ويُثبَت ذلك بفقاعاته الخارجة من قارورةٍ مغموسة في الماء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f08d3114-6bcb-53f8-b501-0f39ff8dfd3b', '34d0c10d-e0d7-5829-bcbb-cdfbcd39adf3', 'لماذا الهواء ضروريّ؟', '[{"id":"a","text":"لأنّ الكائنات الحيّة تتنفّسه لتعيش"},{"id":"b","text":"ليُشرب بدل الماء"},{"id":"c","text":"ليُؤكل"},{"id":"d","text":"لا فائدة منه"}]'::jsonb, 'a', 'الهواء ضروريّ لأنّ الكائنات الحيّة تتنفّسه (الأكسجين) لتبقى حيّة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2649d9d-d1d3-59da-8949-18ec29ac29bb', '34d0c10d-e0d7-5829-bcbb-cdfbcd39adf3', 'ما الذي يدلّ على وجود الهواء داخل قارورةٍ «فارغة» مغموسة في الماء؟', '[{"id":"a","text":"خروج الماء منها"},{"id":"b","text":"خروج بخار"},{"id":"c","text":"لا يخرج شيء"},{"id":"d","text":"خروج فقاعات هواء"}]'::jsonb, 'd', 'خروج فقاعات الهواء من القارورة يدلّ على أنّها كانت مملوءةً بالهواء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b7a65b1-fe99-55f5-b9e1-d7b3196e5d45', '34d0c10d-e0d7-5829-bcbb-cdfbcd39adf3', 'لماذا تنطفئ الشمعة تحت كأسٍ محكمة؟', '[{"id":"a","text":"لزيادة الهواء حولها"},{"id":"b","text":"لوجود ماءٍ بالقرب"},{"id":"c","text":"لنفاد الأكسجين الموجود في الهواء"},{"id":"d","text":"لأنّها تكبر فجأةً"}]'::jsonb, 'c', 'تستهلك الشمعة أكسجين الهواء المحبوس تحت الكأس، فإذا نفد انطفأت.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a8fc9ba6-2400-5d15-806a-4d3caead4899', '34d0c10d-e0d7-5829-bcbb-cdfbcd39adf3', 'للهواء كتلة، والدليل أنّ:', '[{"id":"a","text":"الكرة الفارغة أثقل من المنفوخة"},{"id":"b","text":"الكرة المنفوخة أثقل من الفارغة"},{"id":"c","text":"لا فرق في الوزن"},{"id":"d","text":"الهواء بلا وزن"}]'::jsonb, 'b', 'الكرة المنفوخة بالهواء أثقل من الفارغة، وهذا دليلٌ على أنّ للهواء كتلة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

