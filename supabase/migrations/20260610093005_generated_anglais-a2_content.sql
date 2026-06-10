-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: anglais-a2 (Anglais — Élémentaire (A2))
-- Regenerate with: npm run content:build
-- Source of truth: content/anglais-a2/
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
  ('anglais-a2', 'Anglais — Élémentaire (A2)', 'Step up from beginner: the past simple, present continuous, the future (going to & will), comparatives & superlatives, and quantifiers. Elementary level (CEFR A2), building on the A1 foundations.', 'Agilité', 'subject-english', 'Globe', 2, 'en', false, 'anglais', NULL)
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
      AND e.subject_id = 'anglais-a2'
      AND e.source = 'admin'
      AND q.id NOT IN ('3e037a7a-5ed7-5ed2-af30-3d16cca4721e', 'f36cb4ed-8c2b-5caf-88c1-640ca39a6eac', '4f63f32f-97f5-5838-9b4b-b5cd5706bcda', 'f917cc3e-a44b-57e1-8c2c-9a2fbaceae82', '10613ce9-c71d-5bc5-8f6a-c9f99a3ec983', '67803171-4ef0-5d7b-ab28-77681a257e14', '750cc1a9-9304-5fd3-bd9d-1eaa5dfaa5c5', 'd762f612-a069-55df-acb9-00b5dbea0d5e', '8294275b-4f33-5208-b3ea-1607a0fbc5d7', '4033fd02-4785-52a6-8eb4-a34889b627cb', '8ca5c548-d4fd-567c-923f-8f7a8eed2cfb', 'de82bb98-dd15-5d5c-a9b2-64fce35073c8', 'd8addc12-2b57-5e04-9fc8-ab1d52b10477', '1a0ede4d-ee13-54e7-a4c9-cfd9cc774457', '44debdc5-4d4c-58ab-a96d-3c3c177dd515', '6241e55b-934f-5ce2-bf21-0dfef0243070', 'fee3b50e-c03b-5728-a0ac-16295d1eb33a', '5350a3cb-facd-5a7a-8acc-115980bcfb3b', '2fe84986-3d09-5c31-9966-cccab0da6192', '99fd1425-4c06-51a6-8470-e87f4bdac84f', 'f4784ce0-089c-53da-b1b9-8877c96da597', 'abbd5bd5-238a-5a92-9088-a08552b99086', 'c83c08c6-2013-535e-8ebf-a77b3d74b94d', 'c3ef3d74-a505-5e44-a1d1-02e7f4baa8a4', 'f4a7c5b3-b149-59a7-bb77-e2c89b902797', 'd7f5e248-7df5-50e3-9d37-214173691cde', '4fd2403a-b955-5017-9884-d0c3e6602b1f', '431ad58a-724c-5673-9110-b8bf0802cc2f', '178c3f6a-db01-5429-be7f-9e05160129d7', '5e859810-7689-5777-9235-f7c25c6e128e', '0f797a8a-83f2-5701-ad1a-88fb6259ff34', '65f44302-6616-512e-89af-0ba815e557e7', '5e490fcb-583f-55fb-aaa6-fb39d51a4d8a', '4af03ffb-a282-5e94-a7a1-7ff4a3d8f6bd', 'fe21edf0-18f0-5bca-baa6-946f2d97bf33', 'ba25f9fc-5a57-5445-8641-8f99e4d79855', '56a4079e-1c05-57a3-8832-d5bc5d530f61', '20bd7587-e0cf-59de-93bb-7e7d7c726b52', '733369a5-6ccf-543e-921e-d97a4e0957d1', 'b5655229-cc6d-5771-9533-d38dc872d330', 'c7f4ad66-251b-5c52-b41b-5f84216c412a', 'ff8598da-2ad7-5dff-bff4-2d8fbba8d362', '1286ea84-6fda-5fae-8ac8-59cf978fef43', '83875e9e-8bce-5e80-99e0-5f82cd0635c9', '51084542-941c-55ea-8307-d00ea4f6dc4f', 'ba37186c-a4e3-5438-bbd3-772d87cc9d78', '52b2b34e-f892-5389-abb0-a2e63c739860', '2a98f5c9-075a-5832-8d89-c109bc29e594', 'd778437c-a132-5099-aa77-c1aaa01a227c', '456cf5c8-c04c-554a-a8d9-901428741ae6', '32792bc5-eddf-50bd-99fd-c91da5869914', '381d8e07-5082-5b40-b06d-16697ceb4fc1', '4d29eef2-e641-5ec2-80a1-c56da7888787', 'b91b436c-cc5f-5696-a3b6-f755386cff91', '073a2381-a05e-5d51-92dc-25b64dcc71bb', 'b717bb55-1b37-58e7-876c-bb4f29a08604', '411a7bae-573d-5720-aacd-e5f4cc03d2fc', '57773bbe-a631-5740-a137-13df78bede07', 'cea89bf6-1be7-5b23-b5f5-97da85026053', '16c44583-2261-596d-9bfd-1c6ea8faa4b4', '502a39aa-0576-5e56-90e1-dfb96f8ded7f', '23610b43-099b-5ddc-a4d5-663359fdb8a4', 'a949ceb2-b65c-5999-a564-b28c95b0e5bc', '3a6021de-bd99-510a-8a85-30ff7d55045b', 'a708b7da-f87d-5f35-bfa6-296027046778', 'e36d3bb8-886b-51cb-86b4-d189341c7d4d', 'fa84d274-2d45-52e3-8d04-fe5a4f8fb994', '9a8ec7b0-728f-55f2-a3bb-e6eab8806f4f', '4fa5c943-05da-5b19-b908-f8a46f05f2cc', 'db74d52f-4dd2-5f4c-a3c7-bd9c8c7dfebf', 'aa9fa7e6-675c-5e90-b8f8-546b4ebe006f', 'cf6bf9ce-6aec-51a3-b114-8935ad5be3f2', 'dae83ff0-7da8-5c2a-a8e1-7ea9e0510ea7', 'a7616ddf-18ce-5a10-8638-9c8e91fc988b', '74e77b4a-e803-5416-8a18-9f2b73ebcaa4', 'a877c13f-f3ab-500c-82c2-444c74dc8d30', '88838816-e99c-5f9a-a8bd-357a8a58bc18', '0108e45b-c7bc-559f-8d42-b8dacfec8866', 'c3c0d9ec-1165-5983-804d-f294df94fe31', 'b3412a95-d153-5712-a756-670894271110', 'c8d54da2-4030-5889-98e7-be9e06dcf215', 'e0f06629-1a6d-52fd-9c9d-4b9d4e76b6ca', '1faee336-67eb-598c-b3fc-26a9ae3e4889', 'b7209048-9f87-5fbb-9d08-0ffe7b8c7196', '9dfee013-d1e0-5e51-b55d-1e2bdbe4d965', '5c4bb149-e0e3-59f9-a76a-7ed9a0004311', '4ba358b7-f193-5a94-8962-1c35905d45c0', 'd45ded3b-0a28-54b5-bf8a-38a4448595fd', 'ebb7438a-e17e-5fb2-af0a-8a9a6b68b2e9', '6568e74d-fc4c-5cc5-ac27-6f87b168166e', '076fb52e-e528-5b61-bf65-eabc0bf08dbe', '0e54903c-d564-524f-9429-cc362d494211', '0018a4f0-38e5-536e-abf0-bff222543247', '2fa44d4d-01f7-5736-be0d-cce7aa752a6e', '826968a5-a6a6-5ff0-8c3f-d2064e24d539', '66618313-f12d-524a-b5e6-359e71ec0197', 'adc4f7e9-0e52-5124-bb58-c3868cf2d21a', '66b84bda-b6c1-5b96-ae5d-76bca44ffda1', '44dabcb9-8e4a-5ced-8d14-b4b2dd242948', '5f5d8ad9-49d6-5b2f-9c6c-c319312b52be', 'd1e4db9a-ef0d-5ef1-a7f2-2c25439983bd', '173c664d-840f-5f7c-8149-1c7b1cfec277', 'fb1a1519-3ad3-5a39-9d1b-338037d7083c', '3496518f-5cc2-5d2f-9875-282e13d18e13', '1cdbd8ff-4809-520a-b1c2-e4b4200cf55d', '6515db40-efc6-5fd0-8aed-db9a6fe0bce4', '65d70e77-273c-5206-8aa8-0a382fe39f7e', 'fffa044c-7217-5a06-a992-f41813d46c6b', '33c36885-1da3-5144-be8c-8726b18bdc5d', '9eb0e927-6a88-508f-8e83-04188c72c532', 'ae2dbfee-567e-5a54-b7cc-615e874969db', 'd5f2940e-ac61-53bc-8c95-d82056e89b1c', '2cdc8c6b-e46c-5c11-a059-f5af27926417', '5f140249-cafa-5b80-aa46-fc91615eac19', '4bfdd249-c85e-5636-a0f1-c417f8129ae5', 'd83ca647-88a6-5707-aeb0-75cbd1ed444c', '05b38fbb-5f1c-55b2-b31e-79c915e4613e', '4645cf87-9116-5436-bf87-a6f2daa8193e', '1eae62bf-a143-5e80-8778-13076dcb6990', '9a297ed8-fb96-500a-bd04-f7f3617e4cf9', '4b714276-5b15-594b-aa83-efbf026b160c', '1a1731b2-4da6-583c-830d-a4e6ebb9cd60', 'f8c8eceb-7d0e-5c4d-916c-3de4daa48c3e', '86da6674-3174-50df-a091-6a86a2647ab0', '18f5ebdb-803e-55f3-ab1c-d8b64acbc9f6', '13725910-cc7a-5cdc-a6ec-6fb709c87996', '1fbb3d79-512d-5eec-97a2-fc07c99132df', '594e4cf0-850f-5ff5-8f54-b39e0a4bc164', '12c95499-a7dc-54cc-9bbb-9aa7ad99f0ff', 'de02d447-34d2-5152-bb34-cb476786ba29', '432f296e-7274-5812-b5f3-fe76b86650b6', '276f00e2-fa35-58d7-9751-54dc8f37d00a', '91f548dd-60f7-5a5d-a30e-dcf131ef6cad', '281b6cd5-39a2-54f4-b416-57ff57cd3e82', '6bba7a52-553a-5d61-87be-800cdf7cef90', 'fb6cc96b-cd13-515f-a2a3-d91dc84c36e5', '6d2dae3b-5be4-545f-bbd4-8272fc6d025b', 'a0f08a04-5d92-5eb4-9e7b-2e77a3b5c7df', '0688bba7-315f-54a3-8636-f3116f8a30aa', '18ab785c-e4ef-5248-934d-e75d051f1add', 'e5f6fa3b-39ed-59b2-8bc1-1077b2be432c', 'ef845654-0c13-5c48-9b52-8e950e5924a9', 'a19a017d-29ed-5802-9fb8-3f2f7d604e4c', 'a6baa9cc-9ca0-58a2-b26f-6f8ee1fc53e5', 'd678d2e0-d116-5579-95a6-46b08d0b347c');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'anglais-a2' AND source = 'admin' AND id NOT IN ('6de36006-7b5b-5ba7-8afd-13ce903f5f42', '6867f421-cea5-5df0-9666-7babe2a90b3b', 'c5491462-662b-5a15-b533-46415e1bf4b7', '178872f7-43eb-528d-8246-28ad0e7eab21', '09f3cd3d-f920-5a07-8b30-fee999a986cd', '50b8981a-78f0-5565-8f3c-f8c659daa8ec', '98045a56-5be0-53c5-a627-7d0d17deb05e', 'e691367c-515b-597d-8d57-e244dd24c850', '754775f8-d378-53b6-98f9-a0924b494121', '47e54093-2203-5414-a472-cc9e4917aeb3', 'cf9ddcb7-22b8-5c5b-b828-dfa6cb2835e4', '4dcffdb4-597d-5fbc-a122-b94d47ebcff2', '6ca0d95b-c9f7-5c0c-97c2-95da614e145e', 'de9404d0-8667-53f3-a654-f04f6d8955c8', 'd60c44d2-ce2f-59a5-9375-e8c2868f66b3', 'e1bf4d50-774d-5cb1-9926-2ea2e341c3d6', 'ffa96f28-789e-5809-8d85-b5d640ee3082', '4bc456d2-9039-5c36-88cb-c5ea5bc548ff', 'ba43d85c-68f2-55c8-bde9-6c26c3c03d63', 'd3fad499-2659-5b82-a444-c0478c8fe11a', '736f94be-5dfa-5675-92aa-9a74e7519799', '93b7785b-3211-5965-af18-70b9bbf85c28', '6e52817f-3bd5-55fa-9132-46e7ca8e5328', '9c248cdd-3bd5-582b-a6c5-d51920cea289', '58d964b6-70a2-59e5-8cea-1bdf567dcd59');
DELETE FROM public.questions WHERE exercise_id IN ('6de36006-7b5b-5ba7-8afd-13ce903f5f42', '6867f421-cea5-5df0-9666-7babe2a90b3b', 'c5491462-662b-5a15-b533-46415e1bf4b7', '178872f7-43eb-528d-8246-28ad0e7eab21', '09f3cd3d-f920-5a07-8b30-fee999a986cd', '50b8981a-78f0-5565-8f3c-f8c659daa8ec', '98045a56-5be0-53c5-a627-7d0d17deb05e', 'e691367c-515b-597d-8d57-e244dd24c850', '754775f8-d378-53b6-98f9-a0924b494121', '47e54093-2203-5414-a472-cc9e4917aeb3', 'cf9ddcb7-22b8-5c5b-b828-dfa6cb2835e4', '4dcffdb4-597d-5fbc-a122-b94d47ebcff2', '6ca0d95b-c9f7-5c0c-97c2-95da614e145e', 'de9404d0-8667-53f3-a654-f04f6d8955c8', 'd60c44d2-ce2f-59a5-9375-e8c2868f66b3', 'e1bf4d50-774d-5cb1-9926-2ea2e341c3d6', 'ffa96f28-789e-5809-8d85-b5d640ee3082', '4bc456d2-9039-5c36-88cb-c5ea5bc548ff', 'ba43d85c-68f2-55c8-bde9-6c26c3c03d63', 'd3fad499-2659-5b82-a444-c0478c8fe11a', '736f94be-5dfa-5675-92aa-9a74e7519799', '93b7785b-3211-5965-af18-70b9bbf85c28', '6e52817f-3bd5-55fa-9132-46e7ca8e5328', '9c248cdd-3bd5-582b-a6c5-d51920cea289', '58d964b6-70a2-59e5-8cea-1bdf567dcd59') AND id NOT IN ('3e037a7a-5ed7-5ed2-af30-3d16cca4721e', 'f36cb4ed-8c2b-5caf-88c1-640ca39a6eac', '4f63f32f-97f5-5838-9b4b-b5cd5706bcda', 'f917cc3e-a44b-57e1-8c2c-9a2fbaceae82', '10613ce9-c71d-5bc5-8f6a-c9f99a3ec983', '67803171-4ef0-5d7b-ab28-77681a257e14', '750cc1a9-9304-5fd3-bd9d-1eaa5dfaa5c5', 'd762f612-a069-55df-acb9-00b5dbea0d5e', '8294275b-4f33-5208-b3ea-1607a0fbc5d7', '4033fd02-4785-52a6-8eb4-a34889b627cb', '8ca5c548-d4fd-567c-923f-8f7a8eed2cfb', 'de82bb98-dd15-5d5c-a9b2-64fce35073c8', 'd8addc12-2b57-5e04-9fc8-ab1d52b10477', '1a0ede4d-ee13-54e7-a4c9-cfd9cc774457', '44debdc5-4d4c-58ab-a96d-3c3c177dd515', '6241e55b-934f-5ce2-bf21-0dfef0243070', 'fee3b50e-c03b-5728-a0ac-16295d1eb33a', '5350a3cb-facd-5a7a-8acc-115980bcfb3b', '2fe84986-3d09-5c31-9966-cccab0da6192', '99fd1425-4c06-51a6-8470-e87f4bdac84f', 'f4784ce0-089c-53da-b1b9-8877c96da597', 'abbd5bd5-238a-5a92-9088-a08552b99086', 'c83c08c6-2013-535e-8ebf-a77b3d74b94d', 'c3ef3d74-a505-5e44-a1d1-02e7f4baa8a4', 'f4a7c5b3-b149-59a7-bb77-e2c89b902797', 'd7f5e248-7df5-50e3-9d37-214173691cde', '4fd2403a-b955-5017-9884-d0c3e6602b1f', '431ad58a-724c-5673-9110-b8bf0802cc2f', '178c3f6a-db01-5429-be7f-9e05160129d7', '5e859810-7689-5777-9235-f7c25c6e128e', '0f797a8a-83f2-5701-ad1a-88fb6259ff34', '65f44302-6616-512e-89af-0ba815e557e7', '5e490fcb-583f-55fb-aaa6-fb39d51a4d8a', '4af03ffb-a282-5e94-a7a1-7ff4a3d8f6bd', 'fe21edf0-18f0-5bca-baa6-946f2d97bf33', 'ba25f9fc-5a57-5445-8641-8f99e4d79855', '56a4079e-1c05-57a3-8832-d5bc5d530f61', '20bd7587-e0cf-59de-93bb-7e7d7c726b52', '733369a5-6ccf-543e-921e-d97a4e0957d1', 'b5655229-cc6d-5771-9533-d38dc872d330', 'c7f4ad66-251b-5c52-b41b-5f84216c412a', 'ff8598da-2ad7-5dff-bff4-2d8fbba8d362', '1286ea84-6fda-5fae-8ac8-59cf978fef43', '83875e9e-8bce-5e80-99e0-5f82cd0635c9', '51084542-941c-55ea-8307-d00ea4f6dc4f', 'ba37186c-a4e3-5438-bbd3-772d87cc9d78', '52b2b34e-f892-5389-abb0-a2e63c739860', '2a98f5c9-075a-5832-8d89-c109bc29e594', 'd778437c-a132-5099-aa77-c1aaa01a227c', '456cf5c8-c04c-554a-a8d9-901428741ae6', '32792bc5-eddf-50bd-99fd-c91da5869914', '381d8e07-5082-5b40-b06d-16697ceb4fc1', '4d29eef2-e641-5ec2-80a1-c56da7888787', 'b91b436c-cc5f-5696-a3b6-f755386cff91', '073a2381-a05e-5d51-92dc-25b64dcc71bb', 'b717bb55-1b37-58e7-876c-bb4f29a08604', '411a7bae-573d-5720-aacd-e5f4cc03d2fc', '57773bbe-a631-5740-a137-13df78bede07', 'cea89bf6-1be7-5b23-b5f5-97da85026053', '16c44583-2261-596d-9bfd-1c6ea8faa4b4', '502a39aa-0576-5e56-90e1-dfb96f8ded7f', '23610b43-099b-5ddc-a4d5-663359fdb8a4', 'a949ceb2-b65c-5999-a564-b28c95b0e5bc', '3a6021de-bd99-510a-8a85-30ff7d55045b', 'a708b7da-f87d-5f35-bfa6-296027046778', 'e36d3bb8-886b-51cb-86b4-d189341c7d4d', 'fa84d274-2d45-52e3-8d04-fe5a4f8fb994', '9a8ec7b0-728f-55f2-a3bb-e6eab8806f4f', '4fa5c943-05da-5b19-b908-f8a46f05f2cc', 'db74d52f-4dd2-5f4c-a3c7-bd9c8c7dfebf', 'aa9fa7e6-675c-5e90-b8f8-546b4ebe006f', 'cf6bf9ce-6aec-51a3-b114-8935ad5be3f2', 'dae83ff0-7da8-5c2a-a8e1-7ea9e0510ea7', 'a7616ddf-18ce-5a10-8638-9c8e91fc988b', '74e77b4a-e803-5416-8a18-9f2b73ebcaa4', 'a877c13f-f3ab-500c-82c2-444c74dc8d30', '88838816-e99c-5f9a-a8bd-357a8a58bc18', '0108e45b-c7bc-559f-8d42-b8dacfec8866', 'c3c0d9ec-1165-5983-804d-f294df94fe31', 'b3412a95-d153-5712-a756-670894271110', 'c8d54da2-4030-5889-98e7-be9e06dcf215', 'e0f06629-1a6d-52fd-9c9d-4b9d4e76b6ca', '1faee336-67eb-598c-b3fc-26a9ae3e4889', 'b7209048-9f87-5fbb-9d08-0ffe7b8c7196', '9dfee013-d1e0-5e51-b55d-1e2bdbe4d965', '5c4bb149-e0e3-59f9-a76a-7ed9a0004311', '4ba358b7-f193-5a94-8962-1c35905d45c0', 'd45ded3b-0a28-54b5-bf8a-38a4448595fd', 'ebb7438a-e17e-5fb2-af0a-8a9a6b68b2e9', '6568e74d-fc4c-5cc5-ac27-6f87b168166e', '076fb52e-e528-5b61-bf65-eabc0bf08dbe', '0e54903c-d564-524f-9429-cc362d494211', '0018a4f0-38e5-536e-abf0-bff222543247', '2fa44d4d-01f7-5736-be0d-cce7aa752a6e', '826968a5-a6a6-5ff0-8c3f-d2064e24d539', '66618313-f12d-524a-b5e6-359e71ec0197', 'adc4f7e9-0e52-5124-bb58-c3868cf2d21a', '66b84bda-b6c1-5b96-ae5d-76bca44ffda1', '44dabcb9-8e4a-5ced-8d14-b4b2dd242948', '5f5d8ad9-49d6-5b2f-9c6c-c319312b52be', 'd1e4db9a-ef0d-5ef1-a7f2-2c25439983bd', '173c664d-840f-5f7c-8149-1c7b1cfec277', 'fb1a1519-3ad3-5a39-9d1b-338037d7083c', '3496518f-5cc2-5d2f-9875-282e13d18e13', '1cdbd8ff-4809-520a-b1c2-e4b4200cf55d', '6515db40-efc6-5fd0-8aed-db9a6fe0bce4', '65d70e77-273c-5206-8aa8-0a382fe39f7e', 'fffa044c-7217-5a06-a992-f41813d46c6b', '33c36885-1da3-5144-be8c-8726b18bdc5d', '9eb0e927-6a88-508f-8e83-04188c72c532', 'ae2dbfee-567e-5a54-b7cc-615e874969db', 'd5f2940e-ac61-53bc-8c95-d82056e89b1c', '2cdc8c6b-e46c-5c11-a059-f5af27926417', '5f140249-cafa-5b80-aa46-fc91615eac19', '4bfdd249-c85e-5636-a0f1-c417f8129ae5', 'd83ca647-88a6-5707-aeb0-75cbd1ed444c', '05b38fbb-5f1c-55b2-b31e-79c915e4613e', '4645cf87-9116-5436-bf87-a6f2daa8193e', '1eae62bf-a143-5e80-8778-13076dcb6990', '9a297ed8-fb96-500a-bd04-f7f3617e4cf9', '4b714276-5b15-594b-aa83-efbf026b160c', '1a1731b2-4da6-583c-830d-a4e6ebb9cd60', 'f8c8eceb-7d0e-5c4d-916c-3de4daa48c3e', '86da6674-3174-50df-a091-6a86a2647ab0', '18f5ebdb-803e-55f3-ab1c-d8b64acbc9f6', '13725910-cc7a-5cdc-a6ec-6fb709c87996', '1fbb3d79-512d-5eec-97a2-fc07c99132df', '594e4cf0-850f-5ff5-8f54-b39e0a4bc164', '12c95499-a7dc-54cc-9bbb-9aa7ad99f0ff', 'de02d447-34d2-5152-bb34-cb476786ba29', '432f296e-7274-5812-b5f3-fe76b86650b6', '276f00e2-fa35-58d7-9751-54dc8f37d00a', '91f548dd-60f7-5a5d-a30e-dcf131ef6cad', '281b6cd5-39a2-54f4-b416-57ff57cd3e82', '6bba7a52-553a-5d61-87be-800cdf7cef90', 'fb6cc96b-cd13-515f-a2a3-d91dc84c36e5', '6d2dae3b-5be4-545f-bbd4-8272fc6d025b', 'a0f08a04-5d92-5eb4-9e7b-2e77a3b5c7df', '0688bba7-315f-54a3-8636-f3116f8a30aa', '18ab785c-e4ef-5248-934d-e75d051f1add', 'e5f6fa3b-39ed-59b2-8bc1-1077b2be432c', 'ef845654-0c13-5c48-9b52-8e950e5924a9', 'a19a017d-29ed-5802-9fb8-3f2f7d604e4c', 'a6baa9cc-9ca0-58a2-b26f-6f8ee1fc53e5', 'd678d2e0-d116-5579-95a6-46b08d0b347c');
DELETE FROM public.chapters c WHERE c.subject_id = 'anglais-a2' AND c.id NOT IN ('828b2648-a030-59f8-b7b9-88e35658bf5f', '236d3b84-54b3-5186-83fe-611b3a86b7e2', '6121c3f0-68ee-5aff-9817-4f8d3b282fb8', '72d00d0a-78ad-5435-8450-9fc83f5c11ce', '83aa1163-dcf2-5f5b-89ee-833725ca1832') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('828b2648-a030-59f8-b7b9-88e35658bf5f', 'anglais-a2', 'The Past Simple', 'Tell stories about finished past events: was/were, regular -ed verbs and their spelling, common irregular verbs, and negatives and questions with did/didn''t.', '# ⚔️ The Past Simple — Tales of What Already Happened

> 💡 «Every hero has a story. The past simple is how you tell it: what happened, and when.»

## 🏰 What the past simple is for

The **past simple** describes a **finished** action at a **definite** time in the past. The moment is over and closed — _yesterday, last week, in 2015, two days ago_.

_I **watched** a film yesterday. She **travelled** to Tunis last summer._

## ⚡ "To be" in the past: was / were

The verb *to be* has two past forms. Learn this first — you will use it constantly.

| Subject           | Past form | Example                |
| ----------------- | --------- | ---------------------- |
| I / he / she / it | **was**   | _I **was** tired._     |
| you / we / they   | **were**  | _They **were** at home._ |

Negative: **wasn''t / weren''t**. Question (inversion, like the present): _**Was** he late? **Were** you happy?_

## 🛡️ Regular verbs: add -ed

Most verbs are regular: just add **-ed**. _work → worked, play → played, open → opened._

| Spelling rule                          | Example          |
| -------------------------------------- | ---------------- |
| ends in **-e** → just add **-d**       | like → liked     |
| **consonant + y** → **-ied**           | study → studied  |
| **one short vowel + consonant** → double it | stop → stopped |

_He **liked** the film. We **studied** all night. The bus **stopped** suddenly._

## 🔮 Irregular verbs: learn them one by one

Many of the most common verbs are **irregular** — no *-ed*, just a new form you must memorize:

| Base | Past  | Base | Past |
| ---- | ----- | ---- | ---- |
| go   | went  | get  | got  |
| have | had   | make | made |
| do   | did   | take | took |
| see  | saw   | come | came |
| say  | said  | eat  | ate  |

_She **went** out. We **had** lunch. I **saw** them at the market._

> 🗡️ Tip: there is no rule for irregulars — make a list and drill the **top 40**. They cover most of what you''ll ever say.

## 🧭 Negatives & questions: did / didn''t + the BASE verb

For negatives and questions, use the helper **did**, and the main verb goes back to its **base form** (no *-ed*, no irregular change):

_I **didn''t go** out. (not ~~didn''t went~~)_
_**Did** you **see** it? — Yes, I **did**. / No, I **didn''t**._

> ⚠️ Trap: the past tense is already carried by **did/didn''t**, so never mark it twice — say _Did you **go**?_, never _~~Did you went?~~_

## ⏳ Words that signal the past

_yesterday · last night / week / year · two days **ago** · in 2010 · when I was young._

> 🏆 Gate cleared! You can now tell any past story — affirmative, negative, and question. Next stop: the **present continuous**, for actions happening right now.', '# 📜 Résumé: The Past Simple

- **Use** — a finished action at a definite past time (*yesterday, last week, in 2015, ago*).
- **was / were** — past of *to be*: I/he/she/it **was**, you/we/they **were**; negatives *wasn''t / weren''t*.
- **Regular verbs** — add **-ed**; spelling: *like → liked*, *study → studied*, *stop → stopped*.
- **Irregular verbs** — memorize them: *go → went, have → had, see → saw, take → took, get → got…*
- **Negative** — *didn''t* + **base verb** (*I didn''t go*, never *didn''t went*).
- **Questions** — *did* + subject + **base verb** (*Did you see?*); short answers *Yes, I did / No, I didn''t*.
- ⚠️ The past is carried by **did / didn''t** — never mark it twice (*Did you go?*, not *Did you went?*).', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('236d3b84-54b3-5186-83fe-611b3a86b7e2', 'anglais-a2', 'Present Continuous vs Present Simple', 'Talk about what is happening now versus what happens every day: am/is/are + verb-ing, its spelling and negatives/questions, the time words that pick the right tense, and the stative verbs that stay simple.', '# ⚔️ Present Continuous vs Present Simple — Now or Always?

> 💡 «Two tenses, one question: is it happening right now, or does it happen every day? Master the choice and you control time itself.»

## 🏰 Two tenses, two jobs

English has two ways to talk about the present, and they do **different** jobs. The **present simple** is for **habits, routines and general truths** — things that are always true or happen again and again. The **present continuous** is for actions happening **now**, around now, or just for a while (temporary).

_She **drinks** coffee every morning._ (habit → present simple)
_Look! She **is drinking** coffee right now._ (happening now → present continuous)

Pick the wrong one and the meaning breaks. This chapter is all about choosing correctly.

## ⚡ How to build the present continuous

The formula is simple: **am / is / are** + the **-ing** form of the verb.

| Subject         | be  | + verb-ing | Example                       |
| --------------- | --- | ---------- | ----------------------------- |
| I               | am  | working    | _I **am working**._           |
| he / she / it   | is  | reading    | _She **is reading**._         |
| you / we / they | are | playing    | _They **are playing**._       |

> 🗡️ Quick rule: you **always** need both pieces — the right form of *be* **and** the *-ing*. _He **is** playing_, never _~~He playing~~_ and never _~~He is play~~_.

## 🛡️ The -ing spelling rules

Most verbs just add **-ing**. Three groups change first:

| Rule                                   | Base   | -ing form  |
| -------------------------------------- | ------ | ---------- |
| most verbs → just add **-ing**         | play   | playing    |
| ends in **-e** → drop the *e*          | make   | making     |
| short vowel + consonant → **double** it | run    | running    |
| ends in **-ie** → **-ie → -ying**      | lie    | lying      |

_He is **making** dinner. The dog is **running** in the park. She is **studying** for an exam (keep the **y**)._

> ⚠️ Trap: don''t keep the silent *e* (*makeing* ✗ → **making**), and don''t forget to double after a short vowel (*runing* ✗ → **running**). But verbs ending in *-y* simply add *-ing*: study → **studying**, not *~~studing~~*.

## 🔮 Negatives and questions

To make the **negative**, add **not** to *be* (usually **isn''t / aren''t**) and keep the *-ing*:

_He **isn''t** working today. They **aren''t** playing._

For **questions**, put *be* **before** the subject (inversion, just like the verb *to be*):

_**Is** she **working**? **Are** you **listening**?_
_**What are** you **doing**? **Why is** he **crying**?_

Short answers reuse *be*: _**Is** he sleeping? — **Yes, he is.** / **No, he isn''t.**_

## 🧭 Time words decide the tense

The clue is usually a **time expression**. They split into two teams:

| Present continuous (NOW)                         | Present simple (ALWAYS)                       |
| ------------------------------------------------ | --------------------------------------------- |
| now, right now, at the moment                    | always, usually, often, sometimes             |
| today, this week, these days                     | every day / week, on Mondays                  |
| Look! / Listen! / (it''s happening as you speak)  | as a rule, generally, never                   |

_**Right now** I **am studying**, but I **usually study** at night._
_**Look!** It **is raining**. It **always rains** in winter here._

> ⚠️ Classic trap: a daily habit takes the **simple**, not the continuous. Say _**Every morning** I **drink** coffee_, never _~~Every morning I am drinking coffee~~_. And a now-action takes the **continuous**: _**Look!** He **is playing**_, not _~~Look! He plays~~_.

## 🧪 Stative verbs stay simple

Some verbs describe a **state**, not an action — feelings, thoughts, the senses, possession. These **stative verbs** are **not** normally used in the continuous, even when you mean *now*:

**like, love, want, need, know, understand, believe, have** (= possess).

_I **want** a coffee._ (not _~~I am wanting~~_)
_She **knows** the answer._ (not _~~She is knowing~~_)
_I **have** two brothers._ (= possess; not _~~I am having two brothers~~_)

> 🗡️ Tip: if a verb names a thought, a feeling, or something you own — keep it **simple**, whatever the moment.

> 🏆 Gate cleared! You can now separate **now** from **always** and choose the right present tense every time. Next stop: the **future** — *going to* and *will*, for plans and predictions about what hasn''t happened yet.', '# 📜 Résumé: Present Continuous vs Present Simple

- **Two jobs** — present continuous = happening **now** / temporary; present simple = **habits**, routines, general truths.
- **Form (continuous)** — *am / is / are* + **verb-ing**: *I am working, she is reading, they are playing*. You need **both** pieces.
- **-ing spelling** — *make → making* (drop *e*), *run → running* (double consonant), *study → studying* (keep *y*), *lie → lying*.
- **Negative** — *isn''t / aren''t* + *-ing*: *He isn''t working*.
- **Questions** — invert *be* and subject: *Is she working? What are you doing?*; short answers *Yes, she is / No, she isn''t*.
- **Time words decide** — *now, at the moment, Look!, today* → continuous; *always, usually, every day, on Mondays* → simple.
- **Stative verbs stay simple** — *like, love, want, need, know, understand, believe, have* (= possess): say *I want*, not *I am wanting*.
- ⚠️ Don''t put a **habit** in the continuous (*Every morning I drink coffee*, not *am drinking*) or a **now-action** in the simple (*Look! He is playing*, not *plays*).', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('6121c3f0-68ee-5aff-9817-4f8d3b282fb8', 'anglais-a2', 'Talking About the Future: going to & will', 'Talk about the future two ways: be going to for plans and evidence-based predictions, and will for instant decisions, opinions, promises and offers — with their forms, negatives and questions.', '# ⚔️ Talking About the Future — going to & will

> 💡 «The future is a fork in the road: a plan you already chose, or a decision you make on the spot. English has one tool for each.»

## 🏰 Two roads to the future

English gives you two main ways to talk about what hasn''t happened yet: **be going to** and **will**. They are not random twins — each one carries a different message. Learn *when* to reach for each and your future English will sound natural, not translated.

_I**''m going to** study tonight. — The phone''s ringing; I**''ll** get it._

The first speaker already had a plan. The second decided at that very second. That is the whole battle.

## ⚡ "be going to" — plans and evidence

Use **be going to + base verb** for a **plan or intention decided before now**, and for a **prediction based on what you can see right now** (present evidence).

| Subject         | Form              | Example                              |
| --------------- | ----------------- | ------------------------------------ |
| I               | am going to       | _I **am going to** travel in July._  |
| he / she / it   | is going to       | _She **is going to** call you._      |
| you / we / they | are going to      | _They **are going to** move house._  |

_I**''m going to** visit my aunt on Sunday._ (a plan I already made)
_Look at those clouds — it**''s going to** rain._ (I can see the evidence)

Negative: **not going to**. Question: invert *be* → **Are you going to…?**
_He**''s not going to** come. — **Are** you **going to** help?_

## 🛡️ "will" — instant decisions, predictions, promises

Use **will + base verb** for a **decision made at the moment of speaking**, for **predictions, opinions and beliefs**, and for **promises and offers**.

| Use                    | Example                                   |
| ---------------------- | ----------------------------------------- |
| instant decision       | _Someone''s at the door — I**''ll** open it._ |
| prediction / opinion   | _I think it **will** be cold tomorrow._   |
| promise / offer        | _Don''t worry, I**''ll** help you._         |

The short form is **''ll** (_I''ll, she''ll, we''ll_). Negative: **won''t** (= will not). Question: **Will you…?**
_I **won''t** forget. — **Will** you **be** there?_

> 🗡️ Tip: after **will**, always use the **base verb** with **no "to"**: _I**''ll go**_, never _~~I''ll to go~~_. Same after *going to*: _going to **go**_, never _~~going to goes~~_.

## 🔮 The big contrast: already-decided vs spontaneous

This is the heart of the chapter. Ask yourself one question: **Did I plan this before, or am I deciding now?**

| Situation                                    | Use          | Example                                  |
| -------------------------------------------- | ------------ | ---------------------------------------- |
| a plan you already made                      | **going to** | _We**''re going to** watch a film tonight._ |
| a decision/offer made right now              | **will**     | _It''s heavy — I**''ll** carry it for you._ |
| prediction from evidence you can see         | **going to** | _The car**''s going to** stop; it''s out of fuel._ |
| prediction from opinion/belief               | **will**     | _I think our team **will** win._         |

_"What are you doing this weekend?" — "I**''m going to** paint my room."_ (planned)
_"I''m thirsty." — "I**''ll** get you some water."_ (offer, decided now)

## 🧭 Don''t double the future

Each future has **one** structure. Never mix them, and never stack two futures together.

> ⚠️ Trap: there is no _~~will going to~~_ and no _~~will goes~~_. Pick **one**: either *going to + base verb* **or** *will + base verb*. And don''t drop the **be** — say _I **am** going to_, never _~~I going to~~_.

A quick checklist before you speak:
- Plan already made or visible evidence? → **going to** (+ am/is/are, + base verb).
- Deciding now, predicting from belief, promising, offering? → **will** (+ base verb, no *to*).

> 🏆 Gate cleared! You can now point at the future two ways — the planned road with **going to** and the spontaneous road with **will**. Next stop: **comparatives and superlatives**, to say which path is *bigger*, *faster*, and *the best*.', '# 📜 Résumé: Talking About the Future

- **Two futures** — *be going to* and *will* carry different meanings; choose by intention, not at random.
- **be going to** — *am / is / are going to* + **base verb**: a plan decided before now (*I''m going to study tonight*).
- **going to for evidence** — a prediction from what you can see now (*Look at those clouds — it''s going to rain*).
- **will** — *will / ''ll* + **base verb**: an instant decision made as you speak (*The phone''s ringing — I''ll get it*).
- **will for opinions** — predictions, beliefs, promises and offers (*I think it will be cold*; *I''ll help you*).
- **The contrast** — already-decided plan → **going to**; spontaneous decision/offer/belief → **will**.
- **Forms** — negatives *not going to* / *won''t*; questions *Are you going to…?* / *Will you…?*
- ⚠️ After *will* use the **base verb, no "to"** (*I''ll go*, not *I''ll to go*); never double the future (*~~will going to~~*) and never drop the **be** (*~~I going to~~*).', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('72d00d0a-78ad-5435-8450-9fc83f5c11ce', 'anglais-a2', 'Comparatives & Superlatives', 'Compare people and things with comparatives and superlatives: short adjectives (-er / the -est), long adjectives (more / the most), the spelling changes, and the key irregulars good, bad and far.', '# ⚔️ Comparatives & Superlatives — Ranking the Whole Party

> 💡 «A hero is never alone. The moment there are two of you, you need the words to say who is stronger, faster, and best.»

## 🏰 Two tools, two jobs

When you put things side by side, English gives you two weapons. The **comparative** measures **two** things against each other — it almost always travels with the word **than**. The **superlative** crowns the **top of a whole group** — it almost always travels with **the**.

_My sword is **sharper than** yours._ (two swords)
_This is **the sharpest** sword in the armoury._ (one winner among many)

## ⚡ Short adjectives: -er and the -est

A **short adjective** (one syllable, or two syllables ending in **-y**) takes the endings **-er** for the comparative and **the …-est** for the superlative.

| Adjective | Comparative (+ than) | Superlative (the …) |
| --------- | -------------------- | ------------------- |
| tall      | tall**er** than      | **the** tall**est** |
| fast      | fast**er** than      | **the** fast**est** |
| happy     | happ**ier** than     | **the** happ**iest** |

_She is **taller than** her brother. He is **the fastest** runner in the class._

## 🛡️ Long adjectives: more and the most

A **long adjective** (two syllables or more — most adjectives that don''t end in **-y**) does **not** add an ending. Put **more** in front for the comparative and **the most** in front for the superlative.

| Adjective   | Comparative (+ than)       | Superlative (the …)        |
| ----------- | -------------------------- | -------------------------- |
| expensive   | **more** expensive than    | **the most** expensive     |
| difficult   | **more** difficult than    | **the most** difficult     |
| beautiful   | **more** beautiful than    | **the most** beautiful     |

_Gold is **more expensive than** iron. This is **the most difficult** quest of all._

## 🔮 Spelling: small changes that trip everyone

Short adjectives change their spelling before the ending. Learn the three patterns.

| Pattern                              | Base → forms                  |
| ------------------------------------ | ----------------------------- |
| one short vowel + consonant → double it | big → big**g**er → the big**g**est |
| **consonant + y** → **y becomes i**  | happy → happ**i**er → the happ**i**est |
| already ends in **-e** → just add **-r / -st** | nice → nice**r** → the nice**st** |

_The dragon got **bigger**. This is **the nicest** inn on the road._

## 🧭 The irregular champions

A handful of the most common adjectives ignore every rule. Memorize these — you will use them daily.

| Base | Comparative          | Superlative              |
| ---- | -------------------- | ------------------------ |
| good | **better** than      | **the best**             |
| bad  | **worse** than       | **the worst**            |
| far  | **further / farther** than | **the furthest / farthest** |

_Today is **better than** yesterday. That was **the worst** idea of all. The tower is **further** than it looks._

> 🗡️ Tip: a quick way to sort an adjective — count the syllables. **One syllable (or -y)** → use **-er / -est**; **two or more** → use **more / the most**. *Good*, *bad* and *far* are the only big exceptions.

> ⚠️ Trap: never **double-mark** the comparison. The ending **-er** and the word **more** do the same job, so you choose one, never both. _~~more taller~~_, _~~more better~~_ and _~~the most tallest~~_ are all wrong — say **taller**, **better**, **the tallest**.

## 🌍 Bonus move: as … as

To say two things are **equal**, frame the adjective with **as … as**; add **not** to say they are not equal.

_She is **as tall as** her brother._ (the same height)
_Silver is **not as expensive as** gold._ (gold is more expensive)

> 🏆 Gate cleared! You can now rank any two heroes — or crown the champion of a whole guild — with short forms, long forms, and the irregulars. Next stop: **quantifiers** — *some, any, much, many, a lot of* — to say exactly *how much* and *how many*.', '# 📜 Résumé: Comparatives & Superlatives

- **Two jobs** — the *comparative* compares **two** things (with *than*); the *superlative* picks the top of a **group** (with *the*).
- **Short adjectives** (1 syllable, or 2 ending in *-y*) — add **-er** / **the -est**: *taller than*, *the tallest*; *happier than*, *the happiest*.
- **Long adjectives** (2+ syllables) — use **more** / **the most**: *more expensive than*, *the most expensive*. No ending.
- **Spelling** — double the consonant (*big → bigger → biggest*), *y → i* (*happy → happier → happiest*), keep silent *-e* (*nice → nicer → nicest*).
- **Irregulars** — *good → better → the best*, *bad → worse → the worst*, *far → further/farther → the furthest/farthest*.
- **as … as** — to say two things are equal (*as tall as*); *not as … as* for unequal (*not as expensive as*).
- ⚠️ Never double-mark: no *more taller*, no *more better*, no *the most tallest* — pick **-er/-est** OR **more/most**, never both.
- ⚠️ *than* (comparison) ≠ *then* (time); don''t drop **the** before a superlative (*She is the tallest*, not *She is tallest*).', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('83aa1163-dcf2-5f5b-89ee-833725ca1832', 'anglais-a2', 'Countable, Uncountable & Quantifiers', 'Tell countable nouns from uncountable ones and pick the right quantifier: some/any, much/many, a lot of, a few/a little, and how much/how many.', '# ⚔️ Countable, Uncountable & Quantifiers — Counting Your Loot

> 💡 «A hero weighs the treasure before the fight: how many swords, how much gold? Master the words of quantity and nothing surprises you.»

## 🏰 Two kinds of noun

Before you can say *how much* of something you have, you must know **what kind** of noun it is.

- **Countable nouns** can be counted one by one. They have a plural and can take *a / an* and a number: *a book, two books, three friends.*
- **Uncountable nouns** are seen as a single mass — no plural, no *a / an*, and they take a **singular verb**: *water, money, rice, music, time, information, advice, bread, homework.*

_I have **two books** and **a little money**. The **information** **is** useful (not ~~informations are~~)._

> ⚠️ Classic trap: some everyday words are **uncountable** in English even though your language may count them. Never say ~~informations, advices, breads, homeworks~~ — they have **no plural** at all.

## ⚡ some vs any

Both mean "an unspecified amount", but they live in different sentences.

| Use **some**                         | Use **any**                                  |
| ------------------------------------ | -------------------------------------------- |
| affirmative sentences                | negatives and questions                      |
| _I have **some** money._             | _I don''t have **any** money._                |
| _There are **some** apples._         | _Are there **any** apples?_                  |

_She bought **some** bread. — Did she buy **any** bread? — No, she didn''t buy **any**._

> 🗡️ Tip: use **some** in offers and requests even though they are questions — *Would you like **some** tea?* sounds friendly and expects "yes".

## 🛡️ much vs many vs a lot of

This pair depends entirely on the noun type.

| Quantifier   | Goes with               | Example                          |
| ------------ | ----------------------- | -------------------------------- |
| **many**     | countable (plural)      | _**many** friends, **many** books_ |
| **much**     | uncountable             | _**much** time, **much** money_  |
| **a lot of** | **both**                | _**a lot of** friends / money_   |

*Much* and *many* are most natural in **negatives and questions**; in affirmatives we usually prefer *a lot of*.

_How **many** books do you read? I don''t have **much** time. She has **a lot of** friends._

> ⚠️ Trap: never put **many** with an uncountable noun (~~many money, many informations~~) or **much** with a plural (~~much books~~). Match the quantifier to the noun.

## 🔮 a few vs a little

Both mean "a small quantity", and again the noun type decides.

- **a few** + countable plural: *a few friends, a few books.*
- **a little** + uncountable: *a little milk, a little time.*

_We have **a few** eggs and **a little** flour, so we can bake a cake._

> 🗡️ Tip: think *a **few f**riends* (both start with the same family of countable, plural ideas) and *a **little l**iquid* — *little* pairs with the mass nouns like milk, water and time.

## 🧭 how much vs how many

To ask about quantity, mirror the same rule:

- **How many** + countable plural → *How many students are there?*
- **How much** + uncountable → *How much water do you drink?* / *How much is it?* (price)

_**How many** brothers do you have? **How much** homework did the teacher give?_

> 🏆 Gate cleared — and this is the **last gate of A2**! With countable vs uncountable nouns and the full quantifier kit (*some/any, much/many, a few/a little, how much/how many*), you can measure anything. You have powered through the whole A2 ladder: past simple, present continuous, the future, comparatives, and now quantity. Next, step into the **Donjon** — the mixed-skills gauntlet where every chapter you have beaten comes back at once.', '# 📜 Résumé: Countable, Uncountable & Quantifiers

- **Countable nouns** — can be counted, have a plural, take *a/an* and numbers: *a book, two books*.
- **Uncountable nouns** — a single mass, no plural, **singular verb**: *water, money, rice, time, information, advice, bread, homework*.
- ⚠️ No plural on uncountables — never *informations, advices, breads, homeworks*.
- **some / any** — *some* in affirmatives (*I have some money*); *any* in negatives & questions (*I don''t have any / Do you have any?*). *Some* also for offers (*Would you like some tea?*).
- **many** + countable, **much** + uncountable, **a lot of** + both: *many books, much time, a lot of friends*.
- **a few** + countable (*a few books*) vs **a little** + uncountable (*a little milk*).
- **how many** + countable (*How many friends?*) vs **how much** + uncountable (*How much water?*).
- ⚠️ Match the quantifier to the noun — never *many money*, *much books*, *a few money*, or *a little books*.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6de36006-7b5b-5ba7-8afd-13ce903f5f42', '828b2648-a030-59f8-b7b9-88e35658bf5f', 'anglais-a2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('3e037a7a-5ed7-5ed2-af30-3d16cca4721e', '6de36006-7b5b-5ba7-8afd-13ce903f5f42', 'Complete: "They ___ at school yesterday."', '[{"id":"a","text":"was"},{"id":"b","text":"were"},{"id":"c","text":"are"},{"id":"d","text":"been"}]'::jsonb, 'b', 'You/we/they take were in the past: They were at school. I/he/she/it take was. Are is the present, and been is the past participle (used after have), not the simple past.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f36cb4ed-8c2b-5caf-88c1-640ca39a6eac', '6de36006-7b5b-5ba7-8afd-13ce903f5f42', 'Complete: "Yesterday I ___ football with my friends."', '[{"id":"a","text":"play"},{"id":"b","text":"playd"},{"id":"c","text":"played"},{"id":"d","text":"plaied"}]'::jsonb, 'c', 'Regular verbs add -ed: play → played. Play ends in a vowel + y, so we keep the y and simply add -ed (only consonant + y becomes -ied, like study → studied). "playd" and "plaied" are misspellings.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f63f32f-97f5-5838-9b4b-b5cd5706bcda', '6de36006-7b5b-5ba7-8afd-13ce903f5f42', 'Complete: "She ___ to the market this morning."', '[{"id":"a","text":"went"},{"id":"b","text":"goed"},{"id":"c","text":"gone"},{"id":"d","text":"goes"}]'::jsonb, 'a', 'go is irregular — its past is went, with no -ed: She went to the market. "goed" wrongly applies the regular rule, "gone" is the past participle (have gone), and "goes" is the present tense.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f917cc3e-a44b-57e1-8c2c-9a2fbaceae82', '6de36006-7b5b-5ba7-8afd-13ce903f5f42', 'Complete the negative: "He ___ his homework last night."', '[{"id":"a","text":"didn''t did"},{"id":"b","text":"not did"},{"id":"c","text":"didn''t done"},{"id":"d","text":"didn''t do"}]'::jsonb, 'd', 'Negatives use didn''t + the BASE verb: He didn''t do his homework. The past is already carried by didn''t, so the main verb stays as the base form do — never "didn''t did" or "didn''t done".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('10613ce9-c71d-5bc5-8f6a-c9f99a3ec983', '6de36006-7b5b-5ba7-8afd-13ce903f5f42', 'Complete the question: "___ you see the film last weekend?"', '[{"id":"a","text":"Was"},{"id":"b","text":"Did"},{"id":"c","text":"Do"},{"id":"d","text":"Were"}]'::jsonb, 'b', 'Past questions begin with Did + subject + base verb: Did you see the film? Was/Were ask about the verb to be, not about an action, and Do is the present tense, not the past.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6867f421-cea5-5df0-9666-7babe2a90b3b', '828b2648-a030-59f8-b7b9-88e35658bf5f', 'anglais-a2', '⭐ Practice: Was/Were & Regular Verbs', 1, 50, 10, 'practice', 'admin', 1)
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
  ('67803171-4ef0-5d7b-ab28-77681a257e14', '6867f421-cea5-5df0-9666-7babe2a90b3b', 'Complete: "Last year we ___ in Sousse on holiday."', '[{"id":"a","text":"was"},{"id":"b","text":"were"},{"id":"c","text":"are"},{"id":"d","text":"been"}]'::jsonb, 'b', 'We takes were in the past: Last year we were in Sousse. Was goes with I/he/she/it, are is the present, and been is the past participle, not the simple past.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('750cc1a9-9304-5fd3-bd9d-1eaa5dfaa5c5', '6867f421-cea5-5df0-9666-7babe2a90b3b', 'Complete: "I ___ very tired after the match."', '[{"id":"a","text":"was"},{"id":"b","text":"were"},{"id":"c","text":"am"},{"id":"d","text":"been"}]'::jsonb, 'a', 'I takes was in the past: I was very tired. Were is for you/we/they, am is the present, and been needs an auxiliary like have before it.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d762f612-a069-55df-acb9-00b5dbea0d5e', '6867f421-cea5-5df0-9666-7babe2a90b3b', 'Complete: "She ___ the window because it was cold."', '[{"id":"a","text":"close"},{"id":"b","text":"closeed"},{"id":"c","text":"closed"},{"id":"d","text":"closd"}]'::jsonb, 'c', 'close already ends in -e, so we add only -d: closed. We never write "closeed" (double e) or "closd" (missing e). "close" alone is the base form, not the past.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8294275b-4f33-5208-b3ea-1607a0fbc5d7', '6867f421-cea5-5df0-9666-7babe2a90b3b', 'Complete: "They ___ for the exam all weekend."', '[{"id":"a","text":"studyed"},{"id":"b","text":"studed"},{"id":"c","text":"studies"},{"id":"d","text":"studied"}]'::jsonb, 'd', 'study ends in consonant + y, so the y becomes -ied: studied. "studyed" keeps the y wrongly, "studed" drops a letter, and "studies" is the present he/she/it form.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4033fd02-4785-52a6-8eb4-a34889b627cb', '6867f421-cea5-5df0-9666-7babe2a90b3b', 'Complete: "The taxi ___ in front of the house."', '[{"id":"a","text":"stoped"},{"id":"b","text":"stopt"},{"id":"c","text":"stopped"},{"id":"d","text":"stopd"}]'::jsonb, 'c', 'stop has one short vowel + one consonant, so we double the p before -ed: stopped. "stoped" forgets to double, and "stopt"/"stopd" are not English spellings.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ca5c548-d4fd-567c-923f-8f7a8eed2cfb', '6867f421-cea5-5df0-9666-7babe2a90b3b', 'Complete: "He ___ at school yesterday; he was ill at home."', '[{"id":"a","text":"weren''t"},{"id":"b","text":"wasn''t"},{"id":"c","text":"didn''t"},{"id":"d","text":"isn''t"}]'::jsonb, 'b', 'He takes was, so the negative is wasn''t: He wasn''t at school. Weren''t is for you/we/they, didn''t is for action verbs (not to be), and isn''t is the present.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c5491462-662b-5a15-b533-46415e1bf4b7', '828b2648-a030-59f8-b7b9-88e35658bf5f', 'anglais-a2', '⭐⭐ Review: Irregular Verbs, Negatives & Time', 2, 75, 15, 'practice', 'admin', 2)
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
  ('de82bb98-dd15-5d5c-a9b2-64fce35073c8', 'c5491462-662b-5a15-b533-46415e1bf4b7', 'Complete: "We ___ a great time at the party."', '[{"id":"a","text":"haved"},{"id":"b","text":"had"},{"id":"c","text":"has"},{"id":"d","text":"haded"}]'::jsonb, 'b', 'have is irregular: its past is had (We had a great time). There is no "haved" or "haded" — irregular verbs never take -ed — and "has" is the present he/she/it form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8addc12-2b57-5e04-9fc8-ab1d52b10477', 'c5491462-662b-5a15-b533-46415e1bf4b7', 'Complete: "I ___ a really good film last night."', '[{"id":"a","text":"saw"},{"id":"b","text":"seed"},{"id":"c","text":"seen"},{"id":"d","text":"sawed"}]'::jsonb, 'a', 'see is irregular: past = saw (I saw a film). "seed"/"sawed" wrongly add -ed, and "seen" is the past participle (used with have: I have seen it).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a0ede4d-ee13-54e7-a4c9-cfd9cc774457', 'c5491462-662b-5a15-b533-46415e1bf4b7', 'Complete: "She ___ the message, so she didn''t reply."', '[{"id":"a","text":"didn''t saw"},{"id":"b","text":"not saw"},{"id":"c","text":"didn''t seen"},{"id":"d","text":"didn''t see"}]'::jsonb, 'd', 'After didn''t, the verb returns to its base form: She didn''t see the message. "didn''t saw" and "didn''t seen" keep a past form wrongly, and "not saw" is missing the helper did.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44debdc5-4d4c-58ab-a96d-3c3c177dd515', 'c5491462-662b-5a15-b533-46415e1bf4b7', 'Complete: "We moved to this town three years ___."', '[{"id":"a","text":"before"},{"id":"b","text":"ago"},{"id":"c","text":"last"},{"id":"d","text":"since"}]'::jsonb, 'b', 'ago means "in the past, counting back from now" and follows the time: three years ago. "before" needs a reference point (before 2010), "last" comes before a noun (last year), and "since" marks a starting point (since 2010).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6241e55b-934f-5ce2-bf21-0dfef0243070', 'c5491462-662b-5a15-b533-46415e1bf4b7', 'Complete: "He ___ a new phone for his birthday."', '[{"id":"a","text":"getted"},{"id":"b","text":"gotten"},{"id":"c","text":"got"},{"id":"d","text":"gets"}]'::jsonb, 'c', 'get is irregular: past = got (He got a new phone). "getted" invents an -ed form, "gotten" is a past participle (mainly US English, used with have), and "gets" is the present.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fee3b50e-c03b-5728-a0ac-16295d1eb33a', 'c5491462-662b-5a15-b533-46415e1bf4b7', 'Choose the correct sentence.', '[{"id":"a","text":"She took the bus to work."},{"id":"b","text":"She taked the bus to work."},{"id":"c","text":"She tooked the bus to work."},{"id":"d","text":"She did took the bus to work."}]'::jsonb, 'a', 'take is irregular: past = took, used on its own in an affirmative sentence: She took the bus. "taked"/"tooked" are wrong forms, and "did took" double-marks the past (did already makes it past, so the verb would be the base: she did take, for emphasis only).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('178872f7-43eb-528d-8246-28ad0e7eab21', '828b2648-a030-59f8-b7b9-88e35658bf5f', 'anglais-a2', '⚔️ Chapter Boss ⭐⭐⭐: The Past Simple', 3, 120, 30, 'boss', 'admin', 3)
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
  ('5350a3cb-facd-5a7a-8acc-115980bcfb3b', '178872f7-43eb-528d-8246-28ad0e7eab21', 'Put the words in the correct order: (you / did / where / go)', '[{"id":"a","text":"Where did you go?"},{"id":"b","text":"Where you did go?"},{"id":"c","text":"Where did you went?"},{"id":"d","text":"Where went you?"}]'::jsonb, 'a', 'A past question with an action verb is: question word + did + subject + base verb → Where did you go? "Where you did go" misplaces did, "did you went" double-marks the past, and "Where went you?" has no helper did.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2fe84986-3d09-5c31-9966-cccab0da6192', '178872f7-43eb-528d-8246-28ad0e7eab21', 'Find the INCORRECT sentence.', '[{"id":"a","text":"They didn''t come to the party."},{"id":"b","text":"I saw her yesterday."},{"id":"c","text":"We didn''t went home early."},{"id":"d","text":"Did you call me last night?"}]'::jsonb, 'c', 'The error is (c): after didn''t the verb must be the base form — We didn''t go home, not "didn''t went". The past is already carried by didn''t. (a), (b) and (d) are all correct.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('99fd1425-4c06-51a6-8470-e87f4bdac84f', '178872f7-43eb-528d-8246-28ad0e7eab21', 'What is the past simple of "make"?', '[{"id":"a","text":"maked"},{"id":"b","text":"made"},{"id":"c","text":"maded"},{"id":"d","text":"mades"}]'::jsonb, 'b', 'make is irregular: its past is made (She made a cake). "maked" and "maded" wrongly add -ed, and "mades" is not a verb form at all.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4784ce0-089c-53da-b1b9-8877c96da597', '178872f7-43eb-528d-8246-28ad0e7eab21', 'They won the game. Choose the correct short answer to "Did they win the game?"', '[{"id":"a","text":"Yes, they win."},{"id":"b","text":"Yes, they won."},{"id":"c","text":"Yes, they did."},{"id":"d","text":"Yes, they didn''t."}]'::jsonb, 'c', 'A short answer to a past question reuses the helper did: Did they win? — Yes, they did. "they win" drops the past, "they won" repeats the main verb instead of the helper, and "they didn''t" would mean they lost.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('abbd5bd5-238a-5a92-9088-a08552b99086', '178872f7-43eb-528d-8246-28ad0e7eab21', 'Complete: "He ___ that he was very busy at work."', '[{"id":"a","text":"sayed"},{"id":"b","text":"sed"},{"id":"c","text":"says"},{"id":"d","text":"said"}]'::jsonb, 'd', 'say is irregular: past = said (pronounced /sed/). The correct spelling is said — not the phonetic "sed" or the regular "sayed" — and "says" is the present tense.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c83c08c6-2013-535e-8ebf-a77b3d74b94d', '178872f7-43eb-528d-8246-28ad0e7eab21', 'Choose the correct question.', '[{"id":"a","text":"Did she found her keys?"},{"id":"b","text":"Did she find her keys?"},{"id":"c","text":"Did she finds her keys?"},{"id":"d","text":"She did find her keys."}]'::jsonb, 'b', 'A past yes/no question is Did + subject + base verb: Did she find her keys? "found" and "finds" wrongly change the base verb, and (d) is a statement, not a question.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('09f3cd3d-f920-5a07-8b30-fee999a986cd', '828b2648-a030-59f8-b7b9-88e35658bf5f', 'anglais-a2', '👑 Elite Challenge ⭐⭐⭐⭐: The Past Simple', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('c3ef3d74-a505-5e44-a1d1-02e7f4baa8a4', '09f3cd3d-f920-5a07-8b30-fee999a986cd', 'Read: "Last summer, Yassine visited his grandparents in Bizerte. He stayed for two weeks. He helped his grandfather in the garden and learned to swim."
Which sentence is TRUE?', '[{"id":"a","text":"He stayed for two months."},{"id":"b","text":"Yassine visited his grandparents in Bizerte."},{"id":"c","text":"He taught his grandfather to swim."},{"id":"d","text":"He went in winter."}]'::jsonb, 'b', 'The text says "Yassine visited his grandparents in Bizerte", so (b) is true. He stayed two weeks, not months (a); he learned to swim himself — he didn''t teach his grandfather (c); and it was last summer, not winter (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4a7c5b3-b149-59a7-bb77-e2c89b902797', '09f3cd3d-f920-5a07-8b30-fee999a986cd', 'Find the INCORRECT sentence.', '[{"id":"a","text":"She didn''t understand the question."},{"id":"b","text":"We went to the cinema on Friday."},{"id":"c","text":"Did he brought his book?"},{"id":"d","text":"They were very happy with the result."}]'::jsonb, 'c', 'The error is (c): after did the verb must be the base form — Did he bring his book?, not "brought". (a), (b) and (d) are all correct past-simple sentences (didn''t + base, an irregular past, and were).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7f5e248-7df5-50e3-9d37-214173691cde', '09f3cd3d-f920-5a07-8b30-fee999a986cd', 'Complete: "I ___ my keys two days ago, and I still can''t find them."', '[{"id":"a","text":"losed"},{"id":"b","text":"lost"},{"id":"c","text":"lose"},{"id":"d","text":"loosed"}]'::jsonb, 'b', 'lose is irregular: its past is lost (I lost my keys). "losed" and "loosed" are not real forms, and "lose" is the base/present, which doesn''t fit the time marker "two days ago".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4fd2403a-b955-5017-9884-d0c3e6602b1f', '09f3cd3d-f920-5a07-8b30-fee999a986cd', 'You were NOT at the meeting. Choose the correct short answer to "Were you at the meeting?"', '[{"id":"a","text":"No, I wasn''t."},{"id":"b","text":"No, I weren''t."},{"id":"c","text":"No, I didn''t."},{"id":"d","text":"No, I am not."}]'::jsonb, 'a', 'With I the past of to be is was, so the negative short answer is No, I wasn''t. "weren''t" doesn''t agree with I, "didn''t" is for action verbs (not to be), and "I am not" is present, not past.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('431ad58a-724c-5673-9110-b8bf0802cc2f', '09f3cd3d-f920-5a07-8b30-fee999a986cd', 'Complete: "___ did the film start?" (you want to know the time)', '[{"id":"a","text":"Where"},{"id":"b","text":"Who"},{"id":"c","text":"Why"},{"id":"d","text":"What time"}]'::jsonb, 'd', 'To ask about a time, use What time (or When): What time did the film start? Where asks for a place, Who for a person, and Why for a reason — none of them asks for a time.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('178c3f6a-db01-5429-be7f-9e05160129d7', '09f3cd3d-f920-5a07-8b30-fee999a986cd', 'Read: "Nadia woke up late. She missed the bus and arrived at work at ten. Her boss was not happy."
Why was the boss probably unhappy?', '[{"id":"a","text":"Because Nadia was late for work."},{"id":"b","text":"Because Nadia woke up early."},{"id":"c","text":"Because the bus was empty."},{"id":"d","text":"Because Nadia finished all her work."}]'::jsonb, 'a', 'The clues — Nadia missed the bus and arrived at ten, and the boss was not happy — point to lateness: the boss was unhappy because she was late (a). She woke up late, not early (b); nothing says the bus was empty (c); and she didn''t finish her work (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('50b8981a-78f0-5565-8f3c-f8c659daa8ec', '236d3b84-54b3-5186-83fe-611b3a86b7e2', 'anglais-a2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('5e859810-7689-5777-9235-f7c25c6e128e', '50b8981a-78f0-5565-8f3c-f8c659daa8ec', 'Complete: "Listen! The baby ___ in the next room."', '[{"id":"a","text":"cries"},{"id":"b","text":"is crying"},{"id":"c","text":"cry"},{"id":"d","text":"are crying"}]'::jsonb, 'b', '"Listen!" signals something happening now, so use the present continuous (am/is/are + -ing). The baby = it, so the form is is crying. "cries"/"cry" are the present simple (habits), and "are crying" uses the wrong form of be for a singular subject.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f797a8a-83f2-5701-ad1a-88fb6259ff34', '50b8981a-78f0-5565-8f3c-f8c659daa8ec', 'Complete: "My father ___ to work by bus every day."', '[{"id":"a","text":"is going"},{"id":"b","text":"go"},{"id":"c","text":"goes"},{"id":"d","text":"are going"}]'::jsonb, 'c', '"every day" signals a habit, so use the present simple. With he/she/it the verb takes -s: my father goes. "is going"/"are going" are the continuous (for now, not habits), and "go" forgets the -s needed after he/she/it.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('65f44302-6616-512e-89af-0ba815e557e7', '50b8981a-78f0-5565-8f3c-f8c659daa8ec', 'What is the correct -ing form of "make"?', '[{"id":"a","text":"making"},{"id":"b","text":"makeing"},{"id":"c","text":"makking"},{"id":"d","text":"maing"}]'::jsonb, 'a', 'make ends in a silent -e, so we drop the e before -ing: making. "makeing" wrongly keeps the e, "makking" doubles the wrong letter, and "maing" drops too much.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e490fcb-583f-55fb-aaa6-fb39d51a4d8a', '50b8981a-78f0-5565-8f3c-f8c659daa8ec', 'Complete the negative: "They ___ TV at the moment; they''re asleep."', '[{"id":"a","text":"don''t watch"},{"id":"b","text":"isn''t watching"},{"id":"c","text":"aren''t watch"},{"id":"d","text":"aren''t watching"}]'::jsonb, 'd', '"at the moment" needs the present continuous, and the negative is aren''t (they) + the -ing form: they aren''t watching. "isn''t" is singular, "aren''t watch" drops the -ing, and "don''t watch" is the present simple (for habits, not now).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4af03ffb-a282-5e94-a7a1-7ff4a3d8f6bd', '50b8981a-78f0-5565-8f3c-f8c659daa8ec', 'Which sentence is correct?', '[{"id":"a","text":"I am wanting a glass of water."},{"id":"b","text":"I want a glass of water."},{"id":"c","text":"I am want a glass of water."},{"id":"d","text":"I wanting a glass of water."}]'::jsonb, 'b', 'want is a stative verb (it names a desire, not an action), so it stays in the present simple even about now: I want a glass of water. We don''t say "am wanting"; "am want" mixes two forms, and "I wanting" has no verb be and no reason for -ing.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('98045a56-5be0-53c5-a627-7d0d17deb05e', '236d3b84-54b3-5186-83fe-611b3a86b7e2', 'anglais-a2', '⭐ Practice: Present Continuous', 1, 50, 10, 'practice', 'admin', 1)
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
  ('fe21edf0-18f0-5bca-baa6-946f2d97bf33', '98045a56-5be0-53c5-a627-7d0d17deb05e', 'Complete: "I ___ my homework right now."', '[{"id":"a","text":"doing"},{"id":"b","text":"do"},{"id":"c","text":"am doing"},{"id":"d","text":"is doing"}]'::jsonb, 'c', 'The present continuous is be + verb-ing, and with I the form of be is am: I am doing. "doing" alone has no be, "is doing" uses the wrong be for I, and "do" is the present simple (for habits, not for right now).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba25f9fc-5a57-5445-8641-8f99e4d79855', '98045a56-5be0-53c5-a627-7d0d17deb05e', 'Complete: "Look! It ___ outside."', '[{"id":"a","text":"is raining"},{"id":"b","text":"are raining"},{"id":"c","text":"raining"},{"id":"d","text":"rains"}]'::jsonb, 'a', '"Look!" tells us it is happening now, so use the present continuous. With it the form is is + -ing: it is raining. "are raining" uses the plural be wrongly, "raining" has no be, and "rains" is the present simple (a general habit).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('56a4079e-1c05-57a3-8832-d5bc5d530f61', '98045a56-5be0-53c5-a627-7d0d17deb05e', 'What is the correct -ing form of "run"?', '[{"id":"a","text":"runing"},{"id":"b","text":"running"},{"id":"c","text":"runnning"},{"id":"d","text":"runeing"}]'::jsonb, 'b', 'run has one short vowel + one consonant, so we double the n before -ing: running. "runing" forgets to double, "runnning" has too many n''s, and "runeing" adds an extra e that does not belong.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('20bd7587-e0cf-59de-93bb-7e7d7c726b52', '98045a56-5be0-53c5-a627-7d0d17deb05e', 'Complete: "She ___ a letter to her friend."', '[{"id":"a","text":"are writing"},{"id":"b","text":"am writing"},{"id":"c","text":"is write"},{"id":"d","text":"is writing"}]'::jsonb, 'd', 'With she the form of be is is, and the continuous keeps the -ing: she is writing. "are writing" uses the plural be, "am writing" is only for I, and "is write" drops the -ing the continuous needs.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('733369a5-6ccf-543e-921e-d97a4e0957d1', '98045a56-5be0-53c5-a627-7d0d17deb05e', 'Complete: "We ___ to music in the garden."', '[{"id":"a","text":"is listening"},{"id":"b","text":"are listening"},{"id":"c","text":"listening"},{"id":"d","text":"am listening"}]'::jsonb, 'b', 'With we the form of be is are, plus the -ing form: we are listening. "is listening" is singular (he/she/it), "am listening" is only for I, and "listening" alone is missing the verb be.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5655229-cc6d-5771-9533-d38dc872d330', '98045a56-5be0-53c5-a627-7d0d17deb05e', 'Which is the correct -ing form of "have" (as in eating) in "They ___ lunch now."?', '[{"id":"a","text":"are having"},{"id":"b","text":"are haveing"},{"id":"c","text":"are have"},{"id":"d","text":"having"}]'::jsonb, 'a', 'have ends in a silent -e, so we drop the e before -ing: having. With they the be is are: they are having lunch. "are haveing" keeps the e wrongly, "are have" forgets the -ing, and "having" alone has no be.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e691367c-515b-597d-8d57-e244dd24c850', '236d3b84-54b3-5186-83fe-611b3a86b7e2', 'anglais-a2', '⭐⭐ Review: Now vs Habits', 2, 75, 15, 'practice', 'admin', 2)
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
  ('c7f4ad66-251b-5c52-b41b-5f84216c412a', 'e691367c-515b-597d-8d57-e244dd24c850', 'Complete: "Every Saturday my brother ___ football with his team."', '[{"id":"a","text":"is playing"},{"id":"b","text":"plays"},{"id":"c","text":"are playing"},{"id":"d","text":"playing"}]'::jsonb, 'b', '"Every Saturday" signals a habit, so use the present simple, with -s after he: my brother plays. "is playing"/"are playing" are the continuous (for now, not routines), and "playing" alone is not a finite verb.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff8598da-2ad7-5dff-bff4-2d8fbba8d362', 'e691367c-515b-597d-8d57-e244dd24c850', 'Complete: "Be quiet, please! I ___ to study at the moment."', '[{"id":"a","text":"am trying"},{"id":"b","text":"try"},{"id":"c","text":"tries"},{"id":"d","text":"is trying"}]'::jsonb, 'a', '"at the moment" signals now, so use the present continuous; with I the be is am: I am trying. "try"/"tries" are the present simple (habits), and "is trying" uses the wrong be for I.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1286ea84-6fda-5fae-8ac8-59cf978fef43', 'e691367c-515b-597d-8d57-e244dd24c850', 'Choose the correct sentence.', '[{"id":"a","text":"Now she watches a film."},{"id":"b","text":"She watch a film now."},{"id":"c","text":"She watching a film now."},{"id":"d","text":"She is watching a film now."}]'::jsonb, 'd', 'The word now points to an action in progress, so use the present continuous: she is watching. "Now she watches" wrongly uses the present simple for a now-action, "She watch" has no be and no -s, and "She watching" is missing the verb be.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83875e9e-8bce-5e80-99e0-5f82cd0635c9', 'e691367c-515b-597d-8d57-e244dd24c850', 'Complete: "My grandmother ___ tea, not coffee, in the mornings."', '[{"id":"a","text":"is drinking"},{"id":"b","text":"are drinking"},{"id":"c","text":"drinks"},{"id":"d","text":"drink"}]'::jsonb, 'c', '"in the mornings" describes a regular habit, so use the present simple with -s after she: she drinks tea. "is/are drinking" are the continuous (for what is happening right now), and "drink" forgets the -s needed after he/she/it.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51084542-941c-55ea-8307-d00ea4f6dc4f', 'e691367c-515b-597d-8d57-e244dd24c850', 'Complete: "Where are the children? — They ___ in the park."', '[{"id":"a","text":"play"},{"id":"b","text":"are playing"},{"id":"c","text":"is playing"},{"id":"d","text":"plays"}]'::jsonb, 'b', 'The question "Where are the children?" asks what they are doing right now, so use the present continuous with are (they): they are playing. "is playing" is singular, "play"/"plays" are the present simple (habits, not this moment).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba37186c-a4e3-5438-bbd3-772d87cc9d78', 'e691367c-515b-597d-8d57-e244dd24c850', 'Complete: "He usually walks to school, but today he ___ the bus because it''s raining."', '[{"id":"a","text":"takes"},{"id":"b","text":"take"},{"id":"c","text":"is taking"},{"id":"d","text":"are taking"}]'::jsonb, 'c', '"today" marks a temporary, one-off action against the usual habit, so use the present continuous: today he is taking the bus. "usually walks" is the habit (simple), but "today" switches us to the continuous; "takes"/"take" are simple, and "are taking" uses the wrong be for he.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('754775f8-d378-53b6-98f9-a0924b494121', '236d3b84-54b3-5186-83fe-611b3a86b7e2', 'anglais-a2', '⚔️ Chapter Boss ⭐⭐⭐: Present Continuous vs Simple', 3, 120, 30, 'boss', 'admin', 3)
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
  ('52b2b34e-f892-5389-abb0-a2e63c739860', '754775f8-d378-53b6-98f9-a0924b494121', 'Put the words in the correct order: (you / what / are / doing)', '[{"id":"a","text":"What you are doing?"},{"id":"b","text":"What are doing you?"},{"id":"c","text":"What are you doing?"},{"id":"d","text":"What do you doing?"}]'::jsonb, 'c', 'A present-continuous question is: question word + be + subject + verb-ing → What are you doing? "What you are doing" keeps statement order (no inversion), "What are doing you" misplaces the subject, and "What do you doing" mixes in do, which the continuous never uses.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a98f5c9-075a-5832-8d89-c109bc29e594', '754775f8-d378-53b6-98f9-a0924b494121', 'Complete: "My sister ___ the answer, so ask her."', '[{"id":"a","text":"is knowing"},{"id":"b","text":"are knowing"},{"id":"c","text":"know"},{"id":"d","text":"knows"}]'::jsonb, 'd', 'know is a stative verb (it names a mental state, not an action), so it stays in the present simple even now: she knows. The common trap is "is knowing" — but stative verbs are not used in the continuous. "are knowing" also uses the continuous, and "know" forgets the -s after she.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d778437c-a132-5099-aa77-c1aaa01a227c', '754775f8-d378-53b6-98f9-a0924b494121', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Every morning I am drinking coffee."},{"id":"b","text":"Right now I am drinking coffee."},{"id":"c","text":"I usually drink coffee at breakfast."},{"id":"d","text":"Look — she is drinking my coffee!"}]'::jsonb, 'a', 'The error is (a): "Every morning" signals a habit, which takes the present simple — Every morning I drink coffee, not "am drinking". (b) and (d) correctly use the continuous for a now-action (right now, Look), and (c) correctly uses the simple for a habit (usually).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('456cf5c8-c04c-554a-a8d9-901428741ae6', '754775f8-d378-53b6-98f9-a0924b494121', 'Complete the negative: "It''s a holiday, so the shops ___ today."', '[{"id":"a","text":"don''t open"},{"id":"b","text":"aren''t opening"},{"id":"c","text":"isn''t opening"},{"id":"d","text":"not opening"}]'::jsonb, 'b', '"today" marks a temporary situation, so use the present continuous; the negative is aren''t (the shops = they) + -ing: the shops aren''t opening. "isn''t" is singular, "don''t open" is the present simple (a general habit), and "not opening" is missing the verb be.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('32792bc5-eddf-50bd-99fd-c91da5869914', '754775f8-d378-53b6-98f9-a0924b494121', 'Choose the fully correct sentence.', '[{"id":"a","text":"He is wanting a new bike for his birthday."},{"id":"b","text":"Listen! The teacher is speak now."},{"id":"c","text":"They playing in the garden at the moment."},{"id":"d","text":"She is studying for her exam this week."}]'::jsonb, 'd', 'Only (d) is fully correct: "this week" is temporary, so present continuous (is + studying, keeping the y). (a) puts the stative verb want in the continuous (should be "He wants"), (b) drops the -ing (should be "is speaking"), and (c) is missing the verb be (should be "They are playing").', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('381d8e07-5082-5b40-b06d-16697ceb4fc1', '754775f8-d378-53b6-98f9-a0924b494121', 'Complete: "Water ___ at 100 degrees Celsius — that''s a scientific fact."', '[{"id":"a","text":"boils"},{"id":"b","text":"is boiling"},{"id":"c","text":"are boiling"},{"id":"d","text":"boil"}]'::jsonb, 'a', 'A general truth or scientific fact always takes the present simple, with -s after water (= it): water boils. "is boiling"/"are boiling" are the continuous (for water boiling right now, in a pot), and "boil" forgets the -s after a singular subject.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('47e54093-2203-5414-a472-cc9e4917aeb3', '236d3b84-54b3-5186-83fe-611b3a86b7e2', 'anglais-a2', '👑 Elite Challenge ⭐⭐⭐⭐: Present Continuous vs Simple', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('4d29eef2-e641-5ec2-80a1-c56da7888787', '47e54093-2203-5414-a472-cc9e4917aeb3', 'Read: "Sami works in a bank from Monday to Friday. But this week he is on holiday, so he is painting his bedroom." Which sentence is TRUE?', '[{"id":"a","text":"Sami is working in the bank today."},{"id":"b","text":"Sami paints bedrooms every day."},{"id":"c","text":"Sami is painting his bedroom this week."},{"id":"d","text":"Sami never works in a bank."}]'::jsonb, 'c', '"this week he is on holiday, so he is painting" — the continuous marks a temporary activity now, so (c) is true. (a) is false: he is on holiday this week, not at the bank. (b) misreads a one-off as a habit. (d) contradicts "Sami works in a bank from Monday to Friday".', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b91b436c-cc5f-5696-a3b6-f755386cff91', '47e54093-2203-5414-a472-cc9e4917aeb3', 'Find the INCORRECT sentence.', '[{"id":"a","text":"She is making a cake right now."},{"id":"b","text":"I don''t usually drink tea in the evening."},{"id":"c","text":"We are studying English this term."},{"id":"d","text":"He is needing some help with his bags."}]'::jsonb, 'd', 'The error is (d): need is a stative verb and is not used in the continuous — He needs some help, not "is needing". (a) and (c) correctly use the continuous (right now, this term), and (b) correctly uses the simple for a habit (usually).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('073a2381-a05e-5d51-92dc-25b64dcc71bb', '47e54093-2203-5414-a472-cc9e4917aeb3', 'Complete: "Normally the train ___ on time, but today it ___ very late."', '[{"id":"a","text":"is arriving / arrives"},{"id":"b","text":"arrives / is arriving"},{"id":"c","text":"arrive / is arriving"},{"id":"d","text":"is arriving / is arriving"}]'::jsonb, 'b', '"Normally" signals a habit → present simple (the train arrives), while "today" signals a temporary exception → present continuous (it is arriving). Only (b) matches each time word to its tense. The other pairs put the habit in the continuous or the now-action in the simple.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b717bb55-1b37-58e7-876c-bb4f29a08604', '47e54093-2203-5414-a472-cc9e4917aeb3', 'Complete: "___ you ___ for the bus, or are you just standing here?"', '[{"id":"a","text":"Are / waiting"},{"id":"b","text":"Do / waiting"},{"id":"c","text":"Are / wait"},{"id":"d","text":"Is / waiting"}]'::jsonb, 'a', 'A present-continuous question is be + subject + verb-ing: Are you waiting? "Do ... waiting" wrongly mixes do with -ing, "Are ... wait" drops the -ing, and "Is" is the wrong form of be for you. The hint "are you just standing here" confirms the continuous.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('411a7bae-573d-5720-aacd-e5f4cc03d2fc', '47e54093-2203-5414-a472-cc9e4917aeb3', 'Choose the fully correct sentence.', '[{"id":"a","text":"My parents are beliving the story."},{"id":"b","text":"The sun is rising in the east every day."},{"id":"c","text":"Why you are crying now?"},{"id":"d","text":"The children are lying on the grass and looking at the clouds."}]'::jsonb, 'd', 'Only (d) is fully correct: lie → lying (the -ie becomes -ying), with are for a plural now-action. (a) puts the stative verb believe in the continuous and misspells it (should be "believe the story"), (b) uses the continuous for the daily-truth "every day" (should be "rises"), and (c) misses the inversion (should be "Why are you crying?").', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('57773bbe-a631-5740-a137-13df78bede07', '47e54093-2203-5414-a472-cc9e4917aeb3', 'Read: "It''s 8 p.m. Lina is in the kitchen. There is a wonderful smell, and a pot is on the stove." What is Lina probably doing?', '[{"id":"a","text":"She is sleeping in her bed."},{"id":"b","text":"She is cooking dinner."},{"id":"c","text":"She cooks dinner every evening."},{"id":"d","text":"She is washing the car outside."}]'::jsonb, 'b', 'The clues — in the kitchen, a wonderful smell, a pot on the stove — point to an action in progress now: she is cooking dinner (present continuous). (a) and (d) contradict "is in the kitchen". (c) is grammatically fine but uses the simple for a habit, which doesn''t answer what she is doing at this moment.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cf9ddcb7-22b8-5c5b-b828-dfa6cb2835e4', '6121c3f0-68ee-5aff-9817-4f8d3b282fb8', 'anglais-a2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('cea89bf6-1be7-5b23-b5f5-97da85026053', 'cf9ddcb7-22b8-5c5b-b828-dfa6cb2835e4', 'Complete: "I''ve already decided. I ___ study English tonight."', '[{"id":"a","text":"am going to"},{"id":"b","text":"will to"},{"id":"c","text":"going to"},{"id":"d","text":"will going to"}]'::jsonb, 'a', 'A plan decided before now uses be going to + base verb: I am going to study tonight. "will to" is wrong (will never takes to), "going to" alone drops the be (am), and "will going to" stacks two futures together.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16c44583-2261-596d-9bfd-1c6ea8faa4b4', 'cf9ddcb7-22b8-5c5b-b828-dfa6cb2835e4', 'The phone is ringing. You decide right now to answer it. What do you say?', '[{"id":"a","text":"I''m going to get it."},{"id":"b","text":"I''ll get it."},{"id":"c","text":"I get it."},{"id":"d","text":"I will to get it."}]'::jsonb, 'b', 'A decision made at the moment of speaking uses will: I''ll get it. "I''m going to" suggests a plan you already had, the present "I get it" doesn''t point to the future, and "will to get" wrongly adds to after will.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('502a39aa-0576-5e56-90e1-dfb96f8ded7f', 'cf9ddcb7-22b8-5c5b-b828-dfa6cb2835e4', 'Complete the prediction from evidence: "Look at those dark clouds! It ___ rain."', '[{"id":"a","text":"will to"},{"id":"b","text":"is going"},{"id":"c","text":"going to"},{"id":"d","text":"is going to"}]'::jsonb, 'd', 'A prediction based on evidence you can see uses be going to: it is going to rain. "is going" is missing to, "going to" is missing the be (is), and "will to" is never correct because will takes no to.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('23610b43-099b-5ddc-a4d5-663359fdb8a4', 'cf9ddcb7-22b8-5c5b-b828-dfa6cb2835e4', 'Complete the negative: "Don''t worry, I ___ forget your birthday."', '[{"id":"a","text":"willn''t"},{"id":"b","text":"amn''t"},{"id":"c","text":"won''t"},{"id":"d","text":"don''t will"}]'::jsonb, 'c', 'The negative of will is won''t (= will not): I won''t forget. "willn''t" is not an English word, "amn''t" belongs to be (and there is no such form anyway), and "don''t will" mixes two helpers.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a949ceb2-b65c-5999-a564-b28c95b0e5bc', 'cf9ddcb7-22b8-5c5b-b828-dfa6cb2835e4', 'Make a question: "___ you going to visit your cousins next week?"', '[{"id":"a","text":"Do"},{"id":"b","text":"Are"},{"id":"c","text":"Will"},{"id":"d","text":"Is"}]'::jsonb, 'b', 'A going-to question inverts be: with you the form is Are you going to…? "Is" is for he/she/it, "Do" is the present-simple helper (not used with going to), and "Will" would start a different structure (Will you visit…?).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4dcffdb4-597d-5fbc-a122-b94d47ebcff2', '6121c3f0-68ee-5aff-9817-4f8d3b282fb8', 'anglais-a2', '⭐ Practice: going to & will', 1, 50, 10, 'practice', 'admin', 1)
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
  ('3a6021de-bd99-510a-8a85-30ff7d55045b', '4dcffdb4-597d-5fbc-a122-b94d47ebcff2', 'Complete: "She ___ start a new job next month." (a plan already decided)', '[{"id":"a","text":"is go to"},{"id":"b","text":"is going to"},{"id":"c","text":"are going to"},{"id":"d","text":"going to"}]'::jsonb, 'b', 'With she, be going to is is going to + base verb: She is going to start a new job. "are going to" is for you/we/they, "going to" alone drops the be, and "is go to" mangles the verb form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a708b7da-f87d-5f35-bfa6-296027046778', '4dcffdb4-597d-5fbc-a122-b94d47ebcff2', 'Complete: "The bag is heavy. I ___ carry it for you." (you decide right now)', '[{"id":"a","text":"am carry"},{"id":"b","text":"carry"},{"id":"c","text":"''ll carry"},{"id":"d","text":"''ll to carry"}]'::jsonb, 'c', 'An offer decided as you speak uses will (short form ''ll) + base verb: I''ll carry it. "''ll to carry" wrongly adds to after will, "carry" alone is the present, and "am carry" is not a real form.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e36d3bb8-886b-51cb-86b4-d189341c7d4d', '4dcffdb4-597d-5fbc-a122-b94d47ebcff2', 'Complete: "They ___ buy a new car. They''ve saved enough money."', '[{"id":"a","text":"are going to"},{"id":"b","text":"is going to"},{"id":"c","text":"going to"},{"id":"d","text":"will to"}]'::jsonb, 'a', 'With they, be going to is are going to: They are going to buy a new car. "is going to" is singular (he/she/it), "going to" drops the be (are), and "will to" is never correct — will takes no to.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa84d274-2d45-52e3-8d04-fe5a4f8fb994', '4dcffdb4-597d-5fbc-a122-b94d47ebcff2', 'Complete the prediction: "I think it ___ be sunny tomorrow." (just my opinion)', '[{"id":"a","text":"is going"},{"id":"b","text":"will to"},{"id":"c","text":"going to"},{"id":"d","text":"will"}]'::jsonb, 'd', 'A prediction based on opinion or belief ("I think…") uses will + base verb: it will be sunny. "will to" adds an extra to, while "is going" and "going to" are both broken going-to forms here.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a8ec7b0-728f-55f2-a3bb-e6eab8806f4f', '4dcffdb4-597d-5fbc-a122-b94d47ebcff2', 'Complete the negative: "We ___ go to the beach; the weather is too bad."', '[{"id":"a","text":"are going to"},{"id":"b","text":"aren''t going to"},{"id":"c","text":"isn''t going to"},{"id":"d","text":"don''t going to"}]'::jsonb, 'b', 'The negative of going to puts not on be: We aren''t going to go. "isn''t going to" is singular (he/she/it), "don''t going to" uses the wrong helper, and "are going to" is affirmative, not negative.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4fa5c943-05da-5b19-b908-f8a46f05f2cc', '4dcffdb4-597d-5fbc-a122-b94d47ebcff2', 'Complete: "A: I forgot my pen. B: No problem, I ___ lend you one."', '[{"id":"a","text":"am going to"},{"id":"b","text":"going to"},{"id":"c","text":"will"},{"id":"d","text":"will to"}]'::jsonb, 'c', 'B offers help on the spot, deciding as they speak, so use will + base verb: I''ll lend you one. "am going to" would imply a pre-made plan, "going to" alone is incomplete, and "will to" adds an incorrect to.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6ca0d95b-c9f7-5c0c-97c2-95da614e145e', '6121c3f0-68ee-5aff-9817-4f8d3b282fb8', 'anglais-a2', '⭐⭐ Review: Plans vs Decisions', 2, 75, 15, 'practice', 'admin', 2)
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
  ('db74d52f-4dd2-5f4c-a3c7-bd9c8c7dfebf', '6ca0d95b-c9f7-5c0c-97c2-95da614e145e', '"What are your plans for the holidays?" Which reply fits best?', '[{"id":"a","text":"I''ll stay with my grandparents."},{"id":"b","text":"I stay with my grandparents."},{"id":"c","text":"I''m going to stay with my grandparents."},{"id":"d","text":"I will to stay with my grandparents."}]'::jsonb, 'c', 'A plan you already made is expressed with be going to: I''m going to stay with my grandparents. "I''ll stay" sounds like a decision made at this second, the present "I stay" isn''t about the future, and "will to stay" adds a wrong to.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa9fa7e6-675c-5e90-b8f8-546b4ebe006f', '6ca0d95b-c9f7-5c0c-97c2-95da614e145e', '"The soup looks delicious but there are no spoons." "Oh, ___ get some." (deciding now)', '[{"id":"a","text":"I''ll"},{"id":"b","text":"I''m going to"},{"id":"c","text":"I going to"},{"id":"d","text":"I will to"}]'::jsonb, 'a', 'Reacting on the spot to a problem is a will moment: I''ll get some. "I''m going to" would suggest a plan you had earlier, "I going to" is missing the be (am), and "I will to" wrongly puts to after will.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf6bf9ce-6aec-51a3-b114-8935ad5be3f2', '6ca0d95b-c9f7-5c0c-97c2-95da614e145e', 'Complete: "Be careful! You ___ drop those plates!" (you can see it about to happen)', '[{"id":"a","text":"will to"},{"id":"b","text":"are go to"},{"id":"c","text":"will going to"},{"id":"d","text":"are going to"}]'::jsonb, 'd', 'A prediction from what you can see right now uses be going to: You are going to drop those plates! "will going to" stacks two futures, "are go to" breaks the form, and "will to" is never correct.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dae83ff0-7da8-5c2a-a8e1-7ea9e0510ea7', '6ca0d95b-c9f7-5c0c-97c2-95da614e145e', 'Complete the question: "___ you going to invite Sara to the party?"', '[{"id":"a","text":"Will"},{"id":"b","text":"Are"},{"id":"c","text":"Do"},{"id":"d","text":"Is"}]'::jsonb, 'b', 'A going-to question with you inverts be: Are you going to invite…? "Is" is for he/she/it, "Do" is the present-simple helper (not used with going to), and "Will" starts a different structure (Will you invite…?).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a7616ddf-18ce-5a10-8638-9c8e91fc988b', '6ca0d95b-c9f7-5c0c-97c2-95da614e145e', 'Choose the correct sentence for a promise.', '[{"id":"a","text":"I''ll pay you back on Friday, I promise."},{"id":"b","text":"I''ll to pay you back on Friday, I promise."},{"id":"c","text":"I pay you back on Friday, I promise."},{"id":"d","text":"I will paying you back on Friday, I promise."}]'::jsonb, 'a', 'A promise uses will + base verb: I''ll pay you back. "I''ll to pay" adds a wrong to, "I pay" is the present (not a future promise), and "will paying" uses the -ing form instead of the base verb.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74e77b4a-e803-5416-8a18-9f2b73ebcaa4', '6ca0d95b-c9f7-5c0c-97c2-95da614e145e', 'Complete the negative plan: "He ___ come to the meeting; he told us yesterday."', '[{"id":"a","text":"won''t to"},{"id":"b","text":"don''t going to"},{"id":"c","text":"isn''t going to"},{"id":"d","text":"aren''t going to"}]'::jsonb, 'c', 'A plan already known ("he told us yesterday") is negated with be going to + not, and with he that is isn''t going to: He isn''t going to come. "aren''t going to" is plural, "don''t going to" uses the wrong helper, and "won''t to" adds a wrong to after won''t.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('de9404d0-8667-53f3-a654-f04f6d8955c8', '6121c3f0-68ee-5aff-9817-4f8d3b282fb8', 'anglais-a2', '⚔️ Chapter Boss ⭐⭐⭐: The Future', 3, 120, 30, 'boss', 'admin', 3)
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
  ('a877c13f-f3ab-500c-82c2-444c74dc8d30', 'de9404d0-8667-53f3-a654-f04f6d8955c8', 'Find the INCORRECT sentence.', '[{"id":"a","text":"I''m going to call her tonight."},{"id":"b","text":"She''ll be here soon."},{"id":"c","text":"We will going to leave at six."},{"id":"d","text":"Are you going to help me?"}]'::jsonb, 'c', 'The error is (c): you can''t stack two futures — say either "We are going to leave" or "We will leave", never "will going to". (a), (b) and (d) are all correct (going-to plan, will prediction, going-to question).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('88838816-e99c-5f9a-a8bd-357a8a58bc18', 'de9404d0-8667-53f3-a654-f04f6d8955c8', 'Put the words in the correct order: (you / are / what / going / do / to)', '[{"id":"a","text":"What are going you to do?"},{"id":"b","text":"What are you going to do?"},{"id":"c","text":"What you are going to do?"},{"id":"d","text":"What going to you are do?"}]'::jsonb, 'b', 'A going-to question is: question word + be + subject + going to + base verb → What are you going to do? "What you are going to do?" keeps statement order (no inversion), and the other two scramble be, the subject and going to.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0108e45b-c7bc-559f-8d42-b8dacfec8866', 'de9404d0-8667-53f3-a654-f04f6d8955c8', 'Complete: "This box is too heavy for you. Don''t worry — I ___ help you with it."', '[{"id":"a","text":"am help"},{"id":"b","text":"going to help"},{"id":"c","text":"will helping"},{"id":"d","text":"will help"}]'::jsonb, 'd', 'Offering help in the moment uses will + base verb: I will help you. "will helping" wrongly uses -ing, "going to help" is missing the be (am), and "am help" is not a real form. After will, the verb stays in its base form.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3c0d9ec-1165-5983-804d-f294df94fe31', 'de9404d0-8667-53f3-a654-f04f6d8955c8', 'Find the INCORRECT sentence.', '[{"id":"a","text":"It''s going to rains this evening."},{"id":"b","text":"I think they will win the match."},{"id":"c","text":"We aren''t going to travel this year."},{"id":"d","text":"Will you be at home tonight?"}]'::jsonb, 'a', 'The error is (a): after going to the verb must be the base form — "It''s going to rain", not "rains". The third-person -s never appears on a base verb in the future. (b), (c) and (d) are all correct.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3412a95-d153-5712-a756-670894271110', 'de9404d0-8667-53f3-a654-f04f6d8955c8', 'Complete the negative: "A: Is Tom coming? B: No, he ___ come; he changed his plans last week."', '[{"id":"a","text":"won''t to"},{"id":"b","text":"isn''t going to"},{"id":"c","text":"don''t going to"},{"id":"d","text":"not going to"}]'::jsonb, 'b', 'A plan that changed earlier is negated with be going to: he isn''t going to come. "not going to" is missing the be (isn''t), "don''t going to" uses the wrong helper, and "won''t to" wrongly adds to after won''t.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8d54da2-4030-5889-98e7-be9e06dcf215', 'de9404d0-8667-53f3-a654-f04f6d8955c8', 'Choose the fully correct sentence.', '[{"id":"a","text":"I''m going to visit my aunt, and I think I will to stay two days."},{"id":"b","text":"I will visiting my aunt, and I think I''m going stay two days."},{"id":"c","text":"I''m going to visit my aunt, and I think I''ll stay two days."},{"id":"d","text":"I going to visit my aunt, and I think I will stay to two days."}]'::jsonb, 'c', 'Only (c) is fully correct: a planned visit (going to + base verb) plus an opinion (I''ll stay). (a) adds a wrong to after will, (b) uses "will visiting" and drops to in "going stay", and (d) drops the be in "I going to" and misplaces to.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d60c44d2-ce2f-59a5-9375-e8c2868f66b3', '6121c3f0-68ee-5aff-9817-4f8d3b282fb8', 'anglais-a2', '👑 Elite Challenge ⭐⭐⭐⭐: The Future', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('e0f06629-1a6d-52fd-9c9d-4b9d4e76b6ca', 'd60c44d2-ce2f-59a5-9375-e8c2868f66b3', 'Read: "Mum, I''m bored." "OK, ___ take you to the park, then." The parent decides at that moment. Which reply fits?', '[{"id":"a","text":"I''m going to"},{"id":"b","text":"I''ll"},{"id":"c","text":"I going to"},{"id":"d","text":"I will to"}]'::jsonb, 'b', 'The parent reacts on the spot, so it''s a will decision: I''ll take you to the park. "I''m going to" implies a plan made before the child spoke, "I going to" drops the be (am), and "I will to" adds a wrong to after will.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1faee336-67eb-598c-b3fc-26a9ae3e4889', 'd60c44d2-ce2f-59a5-9375-e8c2868f66b3', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Look — that glass is going to fall!"},{"id":"b","text":"I promise I won''t be late."},{"id":"c","text":"Are they going to sell the house?"},{"id":"d","text":"She will going to start university in September."}]'::jsonb, 'd', 'The error is (d): you can''t combine will and going to — say "She is going to start" or "She will start". (a) is an evidence prediction, (b) a promise with won''t, and (c) a correct going-to question — all fine.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7209048-9f87-5fbb-9d08-0ffe7b8c7196', 'd60c44d2-ce2f-59a5-9375-e8c2868f66b3', 'Read: "We''ve booked the tickets and packed our bags. We leave on Saturday." Which sentence best describes the trip?', '[{"id":"a","text":"They are going to travel on Saturday."},{"id":"b","text":"They will maybe travel one day."},{"id":"c","text":"They aren''t going to travel."},{"id":"d","text":"They will going to travel on Saturday."}]'::jsonb, 'a', 'Booked tickets and packed bags show a firm plan decided in advance, so use be going to: They are going to travel on Saturday. (b) sounds vague and uncertain, (c) contradicts the text, and (d) wrongly stacks will and going to.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9dfee013-d1e0-5e51-b55d-1e2bdbe4d965', 'd60c44d2-ce2f-59a5-9375-e8c2868f66b3', 'Complete the pair: "___ you ___ apply for the job?" — "Yes, I sent the form yesterday."', '[{"id":"a","text":"Will / to"},{"id":"b","text":"Do / going to"},{"id":"c","text":"Are / going to"},{"id":"d","text":"Is / going to"}]'::jsonb, 'c', 'The answer ("I sent the form yesterday") shows an existing plan, so the question is a going-to one, inverting be with you: Are you going to apply? "Is" is for he/she/it, "Do" is the wrong helper, and "Will / to" both misuses will and adds an extra to.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c4bb149-e0e3-59f9-a76a-7ed9a0004311', 'd60c44d2-ce2f-59a5-9375-e8c2868f66b3', 'Choose the fully correct sentence.', '[{"id":"a","text":"I think it going to be a great match, and our team will to win."},{"id":"b","text":"I think it''s going to be a great match, and our team will win."},{"id":"c","text":"I think it will to be a great match, and our team is going win."},{"id":"d","text":"I think it be going to a great match, and our team will winning."}]'::jsonb, 'b', 'Only (b) is correct: an evidence/feeling prediction (it''s going to be) plus an opinion (our team will win), both with the base verb. (a) drops the be and adds "will to", (c) adds "will to" and drops to in "going win", and (d) breaks the form and uses "will winning".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ba358b7-f193-5a94-8962-1c35905d45c0', 'd60c44d2-ce2f-59a5-9375-e8c2868f66b3', 'Read: "Ahmed studied medicine for six years. He has just finished his exams and accepted a job at the city hospital. He starts next month." Which statement is TRUE?', '[{"id":"a","text":"He is going to stop studying and travel the world."},{"id":"b","text":"He will probably never work in a hospital."},{"id":"c","text":"He is going to begin working at the hospital next month."},{"id":"d","text":"He is going to retake his exams."}]'::jsonb, 'c', 'He accepted a hospital job and "starts next month", so the planned future is: He is going to begin working at the hospital next month. (a), (b) and (d) all contradict the text — he finished his exams and took the job, so he isn''t retaking exams, avoiding hospitals, or off to travel.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e1bf4d50-774d-5cb1-9926-2ea2e341c3d6', '72d00d0a-78ad-5435-8450-9fc83f5c11ce', 'anglais-a2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d45ded3b-0a28-54b5-bf8a-38a4448595fd', 'e1bf4d50-774d-5cb1-9926-2ea2e341c3d6', 'Complete: "A cheetah is ___ a lion."', '[{"id":"a","text":"faster then"},{"id":"b","text":"faster than"},{"id":"c","text":"more fast than"},{"id":"d","text":"the fastest"}]'::jsonb, 'b', 'Fast is a short adjective, so the comparative is faster, and a comparison of two things uses than: faster than a lion. "more fast" wrongly adds more to a short adjective, "then" is about time (not comparison), and "the fastest" is the superlative (for a whole group).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ebb7438a-e17e-5fb2-af0a-8a9a6b68b2e9', 'e1bf4d50-774d-5cb1-9926-2ea2e341c3d6', 'Complete: "Mount Everest is ___ mountain in the world."', '[{"id":"a","text":"higher"},{"id":"b","text":"more high"},{"id":"c","text":"the highest"},{"id":"d","text":"highest"}]'::jsonb, 'c', 'Picking the top of a whole group (in the world) needs the superlative with the: the highest mountain. "higher" is the comparative (for two things), "more high" misuses more on a short adjective, and a superlative needs the in front, so "highest" alone is incomplete.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6568e74d-fc4c-5cc5-ac27-6f87b168166e', 'e1bf4d50-774d-5cb1-9926-2ea2e341c3d6', 'Complete: "This restaurant is ___ than the one near my house."', '[{"id":"a","text":"more expensive"},{"id":"b","text":"expensiver"},{"id":"c","text":"the most expensive"},{"id":"d","text":"most expensive"}]'::jsonb, 'a', 'Expensive is a long adjective (three syllables), so its comparative is more expensive (not an -er ending): more expensive than. "expensiver" wrongly adds -er to a long adjective, and "the most expensive" / "most expensive" are superlative forms, which don''t go with than.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('076fb52e-e528-5b61-bf65-eabc0bf08dbe', 'e1bf4d50-774d-5cb1-9926-2ea2e341c3d6', 'Complete: "My new phone is ___ than my old one."', '[{"id":"a","text":"gooder"},{"id":"b","text":"more good"},{"id":"c","text":"the best"},{"id":"d","text":"better"}]'::jsonb, 'd', 'Good is irregular: its comparative is better (My new phone is better than my old one). "gooder" and "more good" both invent a regular form that doesn''t exist, and "the best" is the superlative, which can''t take than.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e54903c-d564-524f-9429-cc362d494211', 'e1bf4d50-774d-5cb1-9926-2ea2e341c3d6', 'Which sentence is correct?', '[{"id":"a","text":"Today is more hotter than yesterday."},{"id":"b","text":"Today is more hot than yesterday."},{"id":"c","text":"Today is hotter than yesterday."},{"id":"d","text":"Today is the hottest than yesterday."}]'::jsonb, 'c', 'Hot is a short adjective, so the comparative doubles the t and adds -er: hotter than. "more hotter" double-marks the comparison (more + -er), "more hot" wrongly uses more on a short adjective, and a superlative (the hottest) never goes with than.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ffa96f28-789e-5809-8d85-b5d640ee3082', '72d00d0a-78ad-5435-8450-9fc83f5c11ce', 'anglais-a2', '⭐ Practice: Comparatives', 1, 50, 10, 'practice', 'admin', 1)
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
  ('0018a4f0-38e5-536e-abf0-bff222543247', 'ffa96f28-789e-5809-8d85-b5d640ee3082', 'Complete: "My brother is ___ than me."', '[{"id":"a","text":"old"},{"id":"b","text":"older"},{"id":"c","text":"more old"},{"id":"d","text":"oldest"}]'::jsonb, 'b', 'Old is a short adjective, so the comparative adds -er: older than. "old" is the base form (no comparison), "more old" wrongly puts more on a short adjective, and "oldest" is the superlative (and would need the).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2fa44d4d-01f7-5736-be0d-cce7aa752a6e', 'ffa96f28-789e-5809-8d85-b5d640ee3082', 'Complete: "A train is ___ than a bicycle."', '[{"id":"a","text":"more fast"},{"id":"b","text":"fast"},{"id":"c","text":"faster"},{"id":"d","text":"fastest"}]'::jsonb, 'c', 'Fast is short, so the comparative is faster than. "more fast" doubles up on a short adjective, "fast" is the plain base form, and "fastest" is the superlative form, which needs the and doesn''t take than.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('826968a5-a6a6-5ff0-8c3f-d2064e24d539', 'ffa96f28-789e-5809-8d85-b5d640ee3082', 'Complete: "This box is ___ than that one."', '[{"id":"a","text":"heavier"},{"id":"b","text":"heavyer"},{"id":"c","text":"more heavy"},{"id":"d","text":"heaviest"}]'::jsonb, 'a', 'Heavy ends in consonant + y, so the y becomes i before -er: heavier than. "heavyer" keeps the y wrongly, "more heavy" treats a two-syllable -y adjective as long (it isn''t), and "heaviest" is the superlative.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('66618313-f12d-524a-b5e6-359e71ec0197', 'ffa96f28-789e-5809-8d85-b5d640ee3082', 'Complete: "Maths is ___ than English for me."', '[{"id":"a","text":"difficulter"},{"id":"b","text":"more difficulter"},{"id":"c","text":"most difficult"},{"id":"d","text":"more difficult"}]'::jsonb, 'd', 'Difficult is a long adjective (three syllables), so the comparative is more difficult than. "difficulter" wrongly adds -er to a long adjective, "more difficulter" double-marks it, and "most difficult" is the superlative, which can''t follow than.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('adc4f7e9-0e52-5124-bb58-c3868cf2d21a', 'ffa96f28-789e-5809-8d85-b5d640ee3082', 'Complete: "The weather today is ___ than yesterday."', '[{"id":"a","text":"more bad"},{"id":"b","text":"worse"},{"id":"c","text":"badder"},{"id":"d","text":"worst"}]'::jsonb, 'b', 'Bad is irregular: its comparative is worse (worse than yesterday). "more bad" and "badder" both invent a regular form that doesn''t exist, and "worst" is the superlative (the worst), which doesn''t take than.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('66b84bda-b6c1-5b96-ae5d-76bca44ffda1', 'ffa96f28-789e-5809-8d85-b5d640ee3082', 'Which sentence is correct?', '[{"id":"a","text":"She is more taller than her sister."},{"id":"b","text":"She is more tall than her sister."},{"id":"c","text":"She is taller than her sister."},{"id":"d","text":"She is taller then her sister."}]'::jsonb, 'c', 'Tall is short, so the comparative is taller, and a comparison uses than: taller than her sister. "more taller" double-marks the comparison, "more tall" misuses more on a short adjective, and "then" is a time word, not the comparison word than.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4bc456d2-9039-5c36-88cb-c5ea5bc548ff', '72d00d0a-78ad-5435-8450-9fc83f5c11ce', 'anglais-a2', '⭐⭐ Review: Comparatives & Superlatives', 2, 75, 15, 'practice', 'admin', 2)
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
  ('44dabcb9-8e4a-5ced-8d14-b4b2dd242948', '4bc456d2-9039-5c36-88cb-c5ea5bc548ff', 'Complete: "This is ___ book in the whole library."', '[{"id":"a","text":"more old"},{"id":"b","text":"older"},{"id":"c","text":"the oldest"},{"id":"d","text":"oldest"}]'::jsonb, 'c', '"In the whole library" marks the top of a group, so use the superlative with the: the oldest book. "older" is the comparative (for two things), "more old" misuses more on a short adjective, and a superlative needs the, so "oldest" alone is incomplete.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f5d8ad9-49d6-5b2f-9c6c-c319312b52be', '4bc456d2-9039-5c36-88cb-c5ea5bc548ff', 'Complete: "Of all my friends, Sami is ___."', '[{"id":"a","text":"the funniest"},{"id":"b","text":"the funnyest"},{"id":"c","text":"funnier"},{"id":"d","text":"the most funny"}]'::jsonb, 'a', 'Funny ends in consonant + y, so the superlative is the funniest (y → i, then -est). "the funnyest" keeps the y wrongly, "funnier" is the comparative, and "the most funny" treats a short -y adjective as long, which it isn''t.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1e4db9a-ef0d-5ef1-a7f2-2c25439983bd', '4bc456d2-9039-5c36-88cb-c5ea5bc548ff', 'Complete: "A plane is ___ way to travel between countries."', '[{"id":"a","text":"more fast"},{"id":"b","text":"faster"},{"id":"c","text":"fastest"},{"id":"d","text":"the fastest"}]'::jsonb, 'd', 'There is no than here and we mean the top way of all, so use the superlative: the fastest way. "faster" needs a than (two things), "more fast" misuses more on a short adjective, and a superlative needs the, so "fastest" alone is wrong.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('173c664d-840f-5f7c-8149-1c7b1cfec277', '4bc456d2-9039-5c36-88cb-c5ea5bc548ff', 'Complete: "Health is ___ than money."', '[{"id":"a","text":"importanter"},{"id":"b","text":"more important"},{"id":"c","text":"the most important"},{"id":"d","text":"most important"}]'::jsonb, 'b', 'Important is a long adjective, so the comparative is more important than. "importanter" wrongly adds -er to a long adjective, and "the most important"/"most important" are superlatives, which don''t go with than.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb1a1519-3ad3-5a39-9d1b-338037d7083c', '4bc456d2-9039-5c36-88cb-c5ea5bc548ff', 'Complete: "That was ___ meal I have ever eaten."', '[{"id":"a","text":"the goodest"},{"id":"b","text":"the better"},{"id":"c","text":"the best"},{"id":"d","text":"the most good"}]'::jsonb, 'c', 'Good is irregular: its superlative is the best (the best meal I have ever eaten). "the goodest" and "the most good" invent a regular form that doesn''t exist, and "the better" is the comparative form, used for two things, not the top of a group.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3496518f-5cc2-5d2f-9875-282e13d18e13', '4bc456d2-9039-5c36-88cb-c5ea5bc548ff', 'Which sentence is correct?', '[{"id":"a","text":"She is the most tallest in her class."},{"id":"b","text":"She is the tallest in her class."},{"id":"c","text":"She is tallest in her class."},{"id":"d","text":"She is more tallest in her class."}]'::jsonb, 'b', 'Tall is short, so the superlative is the tallest in her class. "the most tallest" double-marks it (most + -est), "more tallest" mixes comparative and superlative, and "tallest" without the is incomplete — a superlative needs the.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ba43d85c-68f2-55c8-bde9-6c26c3c03d63', '72d00d0a-78ad-5435-8450-9fc83f5c11ce', 'anglais-a2', '⚔️ Chapter Boss ⭐⭐⭐: Comparatives & Superlatives', 3, 120, 30, 'boss', 'admin', 3)
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
  ('1cdbd8ff-4809-520a-b1c2-e4b4200cf55d', 'ba43d85c-68f2-55c8-bde9-6c26c3c03d63', 'Complete: "The Nile is ___ river in Africa."', '[{"id":"a","text":"longer"},{"id":"b","text":"the longer"},{"id":"c","text":"the longest"},{"id":"d","text":"longest"}]'::jsonb, 'c', 'Picking the top of a whole group (in Africa) needs the superlative with the: the longest river. "longer"/"the longer" are comparative (two things), and a superlative must keep the, so "longest" alone is incomplete.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6515db40-efc6-5fd0-8aed-db9a6fe0bce4', 'ba43d85c-68f2-55c8-bde9-6c26c3c03d63', 'Find the INCORRECT sentence.', '[{"id":"a","text":"This phone is better than that one."},{"id":"b","text":"She is the happiest person I know."},{"id":"c","text":"Gold is more expensive than silver."},{"id":"d","text":"He is more taller than his father."}]'::jsonb, 'd', 'The error is (d): tall is a short adjective, so the comparative is just taller than — adding more on top double-marks the comparison (more + -er). (a) uses the irregular better, (b) the superlative the happiest, and (c) more for a long adjective — all correct.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('65d70e77-273c-5206-8aa8-0a382fe39f7e', 'ba43d85c-68f2-55c8-bde9-6c26c3c03d63', 'Put the words in the correct order: (the / it / film / boring / most / is)', '[{"id":"a","text":"It is most the boring film."},{"id":"b","text":"It is the most boring film."},{"id":"c","text":"It is the boring most film."},{"id":"d","text":"It is more boring the film."}]'::jsonb, 'b', 'Boring is a long adjective, so its superlative is the most + adjective + noun: the most boring film. The is followed straight by most, then the adjective, then the noun, so "most the" and "boring most" are out of order, and "more boring" is the comparative, not the superlative.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fffa044c-7217-5a06-a992-f41813d46c6b', 'ba43d85c-68f2-55c8-bde9-6c26c3c03d63', 'Complete: "My grades this term are ___ than last term."', '[{"id":"a","text":"better"},{"id":"b","text":"the best"},{"id":"c","text":"gooder"},{"id":"d","text":"more good"}]'::jsonb, 'a', 'Good is irregular: its comparative is better, and the word than confirms we compare two things: better than last term. "the best" is the superlative (no than), and "gooder"/"more good" invent a regular form that does not exist.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33c36885-1da3-5144-be8c-8726b18bdc5d', 'ba43d85c-68f2-55c8-bde9-6c26c3c03d63', 'Complete: "My bag isn''t ___ heavy ___ yours; yours weighs more."', '[{"id":"a","text":"more … than"},{"id":"b","text":"so … then"},{"id":"c","text":"as … as"},{"id":"d","text":"the … est"}]'::jsonb, 'c', 'To say two things are not equal we use not as + adjective + as: isn''t as heavy as yours. "more … than" would compare them but doesn''t fit this not-equal frame, "then" is a time word (not than), and "the …est" is the superlative pattern, not a comparison of two bags.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9eb0e927-6a88-508f-8e83-04188c72c532', 'ba43d85c-68f2-55c8-bde9-6c26c3c03d63', 'Which sentence is correct?', '[{"id":"a","text":"Today is worse than yesterday, but tomorrow will be the worse day."},{"id":"b","text":"Today is worse than yesterday, but tomorrow will be the worst day."},{"id":"c","text":"Today is worst than yesterday, but tomorrow will be the worst day."},{"id":"d","text":"Today is more worse than yesterday, but tomorrow will be the worst day."}]'::jsonb, 'b', 'Bad is irregular: comparative worse (with than) and superlative the worst (the top of a group). Only (b) gets both right. (a) uses the comparative worse where the superlative the worst is needed, (c) uses the superlative worst with than, and (d) double-marks the comparative with more worse.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d3fad499-2659-5b82-a444-c0478c8fe11a', '72d00d0a-78ad-5435-8450-9fc83f5c11ce', 'anglais-a2', '👑 Elite Challenge ⭐⭐⭐⭐: Comparatives & Superlatives', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('ae2dbfee-567e-5a54-b7cc-615e874969db', 'd3fad499-2659-5b82-a444-c0478c8fe11a', 'Read: "Ali is 12, Sami is 14, and Nour is 15. Sami is taller than Ali, but Nour is the tallest of the three."
Which sentence is TRUE?', '[{"id":"a","text":"Ali is the oldest of the three."},{"id":"b","text":"Nour is taller than Sami."},{"id":"c","text":"Ali is taller than Sami."},{"id":"d","text":"Sami is the youngest."}]'::jsonb, 'b', 'If Nour is the tallest of all three, then Nour is taller than Sami, so (b) is true. (a) is false — Ali is the youngest, not the oldest; (c) reverses the text (Sami is taller than Ali); and (d) is false — Ali is the youngest at 12.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d5f2940e-ac61-53bc-8c95-d82056e89b1c', 'd3fad499-2659-5b82-a444-c0478c8fe11a', 'Find the INCORRECT sentence.', '[{"id":"a","text":"This is the most interesting book I have read."},{"id":"b","text":"Winter is colder than autumn here."},{"id":"c","text":"He runs more faster than everyone in his team."},{"id":"d","text":"She is the best student in the school."}]'::jsonb, 'c', 'The error is (c): fast is a short adjective, so the comparative is just faster than — "more faster" double-marks it (more + -er). (a) uses the most for a long adjective, (b) the -er comparative with than, and (d) the irregular superlative the best — all correct.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2cdc8c6b-e46c-5c11-a059-f5af27926417', 'd3fad499-2659-5b82-a444-c0478c8fe11a', 'Complete: "The blue car is expensive, the red car is ___, but the black car is ___ of all."', '[{"id":"a","text":"expensiver … the most expensive"},{"id":"b","text":"more expensive … the most expensive"},{"id":"c","text":"more expensive … the expensivest"},{"id":"d","text":"the most expensive … more expensive"}]'::jsonb, 'b', 'Expensive is a long adjective: comparative more expensive (the red car vs the blue), superlative the most expensive (top of all). Only (b) is right. "expensiver"/"the expensivest" wrongly add endings to a long adjective, and (d) swaps the comparative and superlative.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f140249-cafa-5b80-aa46-fc91615eac19', 'd3fad499-2659-5b82-a444-c0478c8fe11a', 'Choose the fully correct sentence.', '[{"id":"a","text":"My house is bigger than yours, but theirs is the biggest."},{"id":"b","text":"My house is more big than yours, but theirs is the biggest."},{"id":"c","text":"My house is bigger than yours, but theirs is the most big."},{"id":"d","text":"My house is more bigger than yours, but theirs is the biggest."}]'::jsonb, 'a', 'Big is a short adjective: it doubles the g for both forms — comparative bigger than, superlative the biggest. Only (a) has both. (b) uses "more big", (c) uses "the most big", and (d) double-marks the comparative with "more bigger".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4bfdd249-c85e-5636-a0f1-c417f8129ae5', 'd3fad499-2659-5b82-a444-c0478c8fe11a', 'Complete: "The library is ___ from here than the school, so let''s go to the school first."', '[{"id":"a","text":"farer"},{"id":"b","text":"more far"},{"id":"c","text":"the furthest"},{"id":"d","text":"further"}]'::jsonb, 'd', 'Far is irregular: its comparative is further (or farther), used here with than to compare two distances: further from here than the school. "farer"/"more far" invent regular forms that don''t exist, and "the furthest" is the superlative, which doesn''t take than.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d83ca647-88a6-5707-aeb0-75cbd1ed444c', 'd3fad499-2659-5b82-a444-c0478c8fe11a', 'Read: "The phone shop sells three models. The basic one is the cheapest. The pro model is more expensive than the basic one, and the ultra model costs even more than the pro."
Which model is the most expensive?', '[{"id":"a","text":"The basic model."},{"id":"b","text":"The pro model."},{"id":"c","text":"The ultra model."},{"id":"d","text":"They all cost the same."}]'::jsonb, 'c', 'The ultra costs more than the pro, and the pro costs more than the basic, so the ultra model is the most expensive (c). The basic is the cheapest (a is wrong), the pro is in the middle (b), and the three prices are clearly different, so (d) is false.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('736f94be-5dfa-5675-92aa-9a74e7519799', '83aa1163-dcf2-5f5b-89ee-833725ca1832', 'anglais-a2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('05b38fbb-5f1c-55b2-b31e-79c915e4613e', '736f94be-5dfa-5675-92aa-9a74e7519799', 'Complete: "I have ___ money in my pocket."', '[{"id":"a","text":"some"},{"id":"b","text":"any"},{"id":"c","text":"many"},{"id":"d","text":"a few"}]'::jsonb, 'a', 'In an affirmative sentence we use some: I have some money. Any belongs to negatives and questions, many goes with countable plurals (not money), and a few is also for countable nouns.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4645cf87-9116-5436-bf87-a6f2daa8193e', '736f94be-5dfa-5675-92aa-9a74e7519799', 'Complete: "How ___ books are there on the shelf?"', '[{"id":"a","text":"much"},{"id":"b","text":"many"},{"id":"c","text":"a lot"},{"id":"d","text":"few"}]'::jsonb, 'b', 'Books is countable and plural, so we ask How many books…?. How much is for uncountable nouns (How much water?), and "how a lot" / "how few" are not correct question forms.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1eae62bf-a143-5e80-8778-13076dcb6990', '736f94be-5dfa-5675-92aa-9a74e7519799', 'Complete: "There isn''t ___ bread left."', '[{"id":"a","text":"some"},{"id":"b","text":"many"},{"id":"c","text":"any"},{"id":"d","text":"a few"}]'::jsonb, 'c', 'After a negative (isn''t) we use any: There isn''t any bread. Some is for affirmatives, and many / a few go with countable nouns, while bread is uncountable.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a297ed8-fb96-500a-bd04-f7f3617e4cf9', '736f94be-5dfa-5675-92aa-9a74e7519799', 'Complete: "We need ___ milk for the recipe."', '[{"id":"a","text":"a few"},{"id":"b","text":"a little"},{"id":"c","text":"many"},{"id":"d","text":"a lot"}]'::jsonb, 'b', 'Milk is uncountable, so a small amount is a little milk. A few and many are for countable nouns, and "a lot" needs of before a noun (a lot of milk).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b714276-5b15-594b-aa83-efbf026b160c', '736f94be-5dfa-5675-92aa-9a74e7519799', 'Which sentence uses the uncountable noun correctly?', '[{"id":"a","text":"She gave me many informations."},{"id":"b","text":"She gave me much advices."},{"id":"c","text":"She gave me some breads."},{"id":"d","text":"She gave me a lot of information."}]'::jsonb, 'd', 'Information is uncountable: it has no plural and works with a lot of — a lot of information. "informations", "advices" and "breads" are all wrong because these nouns are uncountable and never take an -s.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('93b7785b-3211-5965-af18-70b9bbf85c28', '83aa1163-dcf2-5f5b-89ee-833725ca1832', 'anglais-a2', '⭐ Practice: Some, Any, Much, Many', 1, 50, 10, 'practice', 'admin', 1)
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
  ('1a1731b2-4da6-583c-830d-a4e6ebb9cd60', '93b7785b-3211-5965-af18-70b9bbf85c28', 'Complete: "There are ___ apples on the table."', '[{"id":"a","text":"some"},{"id":"b","text":"any"},{"id":"c","text":"much"},{"id":"d","text":"a little"}]'::jsonb, 'a', 'This is an affirmative sentence, so we use some: There are some apples. Any is for negatives and questions, much is for uncountable nouns, and a little is also uncountable — but apples are countable.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8c8eceb-7d0e-5c4d-916c-3de4daa48c3e', '93b7785b-3211-5965-af18-70b9bbf85c28', 'Complete: "Do you have ___ brothers or sisters?"', '[{"id":"a","text":"some"},{"id":"b","text":"much"},{"id":"c","text":"any"},{"id":"d","text":"a little"}]'::jsonb, 'c', 'In a question we normally use any: Do you have any brothers or sisters? Some is for affirmative statements, while much and a little go with uncountable nouns, not countable people.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86da6674-3174-50df-a091-6a86a2647ab0', '93b7785b-3211-5965-af18-70b9bbf85c28', 'Complete: "I don''t have ___ time today."', '[{"id":"a","text":"many"},{"id":"b","text":"any"},{"id":"c","text":"a few"},{"id":"d","text":"some"}]'::jsonb, 'b', 'After a negative (don''t) we use any: I don''t have any time. Many and a few are for countable nouns, but time here is uncountable, and some is used in affirmatives, not negatives.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18f5ebdb-803e-55f3-ab1c-d8b64acbc9f6', '93b7785b-3211-5965-af18-70b9bbf85c28', 'Complete: "How ___ friends do you have on the team?"', '[{"id":"a","text":"many"},{"id":"b","text":"much"},{"id":"c","text":"a lot"},{"id":"d","text":"little"}]'::jsonb, 'a', 'Friends is a countable plural, so we ask How many friends…?. How much is for uncountable nouns (How much money?), and "how a lot" / "how little" are not standard question forms.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13725910-cc7a-5cdc-a6ec-6fb709c87996', '93b7785b-3211-5965-af18-70b9bbf85c28', 'Complete: "There isn''t ___ water in the bottle."', '[{"id":"a","text":"many"},{"id":"b","text":"some"},{"id":"c","text":"much"},{"id":"d","text":"a few"}]'::jsonb, 'c', 'Water is uncountable, so the amount word is much, and in a negative it fits naturally: There isn''t much water. Many and a few need countable nouns, and some is for affirmative sentences.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1fbb3d79-512d-5eec-97a2-fc07c99132df', '93b7785b-3211-5965-af18-70b9bbf85c28', 'Complete: "She has ___ books in her bag."', '[{"id":"a","text":"much"},{"id":"b","text":"any"},{"id":"c","text":"a little"},{"id":"d","text":"some"}]'::jsonb, 'd', 'This is an affirmative sentence about countable books, so we use some: She has some books. Much and a little are for uncountable nouns, and any would need a negative or a question.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6e52817f-3bd5-55fa-9132-46e7ca8e5328', '83aa1163-dcf2-5f5b-89ee-833725ca1832', 'anglais-a2', '⭐⭐ Review: Quantifiers', 2, 75, 15, 'practice', 'admin', 2)
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
  ('594e4cf0-850f-5ff5-8f54-b39e0a4bc164', '6e52817f-3bd5-55fa-9132-46e7ca8e5328', 'Complete: "There are ___ eggs left, just enough for breakfast."', '[{"id":"a","text":"a few"},{"id":"b","text":"a little"},{"id":"c","text":"much"},{"id":"d","text":"any"}]'::jsonb, 'a', 'Eggs is a countable plural, so a small number is a few eggs. A little and much go with uncountable nouns, and any would need a negative or a question, not this affirmative.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12c95499-a7dc-54cc-9bbb-9aa7ad99f0ff', '6e52817f-3bd5-55fa-9132-46e7ca8e5328', 'Complete: "Add ___ salt to the soup — not too much."', '[{"id":"a","text":"a few"},{"id":"b","text":"many"},{"id":"c","text":"a number of"},{"id":"d","text":"a little"}]'::jsonb, 'd', 'Salt is uncountable, so a small amount is a little salt. A few, many and a number of all need countable plural nouns, which salt is not.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de02d447-34d2-5152-bb34-cb476786ba29', '6e52817f-3bd5-55fa-9132-46e7ca8e5328', 'Complete: "How ___ sugar do you take in your coffee?"', '[{"id":"a","text":"much"},{"id":"b","text":"many"},{"id":"c","text":"few"},{"id":"d","text":"lot"}]'::jsonb, 'a', 'Sugar is uncountable, so we ask How much sugar…?. How many is for countable plurals (How many spoons?), and "how few" / "how lot" are not correct question forms.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('432f296e-7274-5812-b5f3-fe76b86650b6', '6e52817f-3bd5-55fa-9132-46e7ca8e5328', 'Complete: "I have ___ homework tonight, so I can''t go out."', '[{"id":"a","text":"many"},{"id":"b","text":"a few"},{"id":"c","text":"a lot of"},{"id":"d","text":"a number of"}]'::jsonb, 'c', 'Homework is uncountable, and a lot of works with both countable and uncountable nouns: a lot of homework. Many, a few and a number of all require countable plurals, which homework is not.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('276f00e2-fa35-58d7-9751-54dc8f37d00a', '6e52817f-3bd5-55fa-9132-46e7ca8e5328', 'Choose the sentence with the correct quantifier.', '[{"id":"a","text":"We don''t have many time."},{"id":"b","text":"We don''t have much friends."},{"id":"c","text":"We don''t have much time."},{"id":"d","text":"We don''t have any times."}]'::jsonb, 'c', 'Time is uncountable, so it pairs with much: We don''t have much time. "many time" mismatches (many needs a countable plural), "much friends" mismatches the other way, and "times" wrongly pluralizes the uncountable noun time.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('91f548dd-60f7-5a5d-a30e-dcf131ef6cad', '6e52817f-3bd5-55fa-9132-46e7ca8e5328', 'Complete: "She speaks ___ languages: English, French and Arabic."', '[{"id":"a","text":"much"},{"id":"b","text":"several"},{"id":"c","text":"a little"},{"id":"d","text":"a great deal of"}]'::jsonb, 'b', 'Languages is a countable plural, so several languages fits (it means "more than two"). Much, a little and a great deal of all go with uncountable nouns, so they cannot describe a list of separate languages.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9c248cdd-3bd5-582b-a6c5-d51920cea289', '83aa1163-dcf2-5f5b-89ee-833725ca1832', 'anglais-a2', '⚔️ Chapter Boss ⭐⭐⭐: Quantifiers', 3, 120, 30, 'boss', 'admin', 3)
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
  ('281b6cd5-39a2-54f4-b416-57ff57cd3e82', '9c248cdd-3bd5-582b-a6c5-d51920cea289', 'Find the INCORRECT sentence.', '[{"id":"a","text":"She gave me some good advice."},{"id":"b","text":"I need some information about the trip."},{"id":"c","text":"He gave me many advices yesterday."},{"id":"d","text":"We bought some fresh bread."}]'::jsonb, 'c', 'The error is (c): advice is uncountable, so it has no plural and never takes many — say some advice, not "many advices". (a), (b) and (d) all use uncountable nouns (advice, information, bread) correctly with some.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6bba7a52-553a-5d61-87be-800cdf7cef90', '9c248cdd-3bd5-582b-a6c5-d51920cea289', 'Which noun is UNCOUNTABLE (it has no plural)?', '[{"id":"a","text":"chair"},{"id":"b","text":"information"},{"id":"c","text":"apple"},{"id":"d","text":"friend"}]'::jsonb, 'b', 'Information is uncountable: we say a piece of information, never "informations". Chair, apple and friend are all countable — they have plurals (chairs, apples, friends) and can take a number.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb6cc96b-cd13-515f-a2a3-d91dc84c36e5', '9c248cdd-3bd5-582b-a6c5-d51920cea289', 'Complete: "I asked for ___ information, but they didn''t give me ___."', '[{"id":"a","text":"some / any"},{"id":"b","text":"any / some"},{"id":"c","text":"many / some"},{"id":"d","text":"some / many"}]'::jsonb, 'a', 'The first clause is affirmative → some information; the second is negative (didn''t give) → any. So it is some / any. Many can''t be used at all here because information is uncountable.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d2dae3b-5be4-545f-bbd4-8272fc6d025b', '9c248cdd-3bd5-582b-a6c5-d51920cea289', 'Find the INCORRECT sentence.', '[{"id":"a","text":"There are a few cars in the street."},{"id":"b","text":"There is a little milk in the fridge."},{"id":"c","text":"I have a few money for the bus."},{"id":"d","text":"She knows a few words of Spanish."}]'::jsonb, 'c', 'The error is (c): money is uncountable, so it takes a little, not a few — say a little money. The trap is to copy a few onto an uncountable noun. (a), (b) and (d) match a few with countable nouns and a little with milk correctly.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a0f08a04-5d92-5eb4-9e7b-2e77a3b5c7df', '9c248cdd-3bd5-582b-a6c5-d51920cea289', 'Complete: "This soup needs ___ pepper but only ___ tomatoes."', '[{"id":"a","text":"a few / a little"},{"id":"b","text":"a little / a few"},{"id":"c","text":"many / much"},{"id":"d","text":"much / a little"}]'::jsonb, 'b', 'Pepper is uncountable → a little pepper; tomatoes is a countable plural → a few tomatoes. So it is a little / a few. Option (a) reverses the two, and (c)/(d) misuse many/much, which usually appear in questions and negatives.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0688bba7-315f-54a3-8636-f3116f8a30aa', '9c248cdd-3bd5-582b-a6c5-d51920cea289', 'Choose the fully correct sentence.', '[{"id":"a","text":"How much homeworks do we have?"},{"id":"b","text":"How many homework do we have?"},{"id":"c","text":"How many homeworks do we have?"},{"id":"d","text":"How much homework do we have?"}]'::jsonb, 'd', 'Homework is uncountable with no plural, so we ask How much homework…?. The plural "homeworks" is never correct (a and c add a wrong -s), and How many (b) is for countable plurals, not homework.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('58d964b6-70a2-59e5-8cea-1bdf567dcd59', '83aa1163-dcf2-5f5b-89ee-833725ca1832', 'anglais-a2', '👑 Elite Challenge ⭐⭐⭐⭐: Quantifiers', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('18ab785c-e4ef-5248-934d-e75d051f1add', '58d964b6-70a2-59e5-8cea-1bdf567dcd59', 'Read: "We''re almost ready to cook. We have a lot of vegetables and a few eggs, but there isn''t much oil and we don''t have any rice."
Which sentence is TRUE?', '[{"id":"a","text":"There is plenty of oil."},{"id":"b","text":"They have no rice."},{"id":"c","text":"They have a lot of eggs."},{"id":"d","text":"They have only a little vegetables."}]'::jsonb, 'b', '"We don''t have any rice" means they have no rice, so (b) is true. (a) is false — there isn''t much oil; (c) overstates it — only a few eggs; and (d) is wrong twice — they have a lot of vegetables, and vegetables (countable) would take a few, not a little.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5f6fa3b-39ed-59b2-8bc1-1077b2be432c', '58d964b6-70a2-59e5-8cea-1bdf567dcd59', 'Find the INCORRECT sentence.', '[{"id":"a","text":"How many pieces of furniture are there?"},{"id":"b","text":"There isn''t much furniture in the room."},{"id":"c","text":"We bought some new furnitures."},{"id":"d","text":"There is a lot of furniture here."}]'::jsonb, 'c', 'The error is (c): furniture is uncountable, so it has no plural — never "furnitures". To count it we say pieces of furniture (a). (b) and (d) correctly use much and a lot of with the uncountable noun.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef845654-0c13-5c48-9b52-8e950e5924a9', '58d964b6-70a2-59e5-8cea-1bdf567dcd59', 'Complete: "There were ___ people at the concert, but ___ of them stayed until the end."', '[{"id":"a","text":"much / a little"},{"id":"b","text":"many / few"},{"id":"c","text":"a little / many"},{"id":"d","text":"a great deal / a few"}]'::jsonb, 'b', 'People is countable and plural, so both gaps need countable quantifiers: many people, and few of them (meaning "not many"). So it is many / few. Much, a little and a great deal are for uncountable nouns and don''t fit people.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a19a017d-29ed-5802-9fb8-3f2f7d604e4c', '58d964b6-70a2-59e5-8cea-1bdf567dcd59', 'Choose the fully correct sentence.', '[{"id":"a","text":"I don''t have some money, so I can''t buy many bread."},{"id":"b","text":"I don''t have many money, so I can''t buy any breads."},{"id":"c","text":"I haven''t any money, so I can''t buy a few bread."},{"id":"d","text":"I don''t have any money, so I can''t buy much bread."}]'::jsonb, 'd', 'In negatives we use any (any money), and bread is uncountable, so we measure it with much (much bread): that is (d). (a) wrongly uses some in a negative and many with bread; (b) uses many with the uncountable money and pluralizes bread; (c) uses a few with uncountable bread.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6baa9cc-9ca0-58a2-b26f-6f8ee1fc53e5', '58d964b6-70a2-59e5-8cea-1bdf567dcd59', 'Complete: "There is ___ traffic this morning, so the bus will be late."', '[{"id":"a","text":"a lot of"},{"id":"b","text":"many"},{"id":"c","text":"a few"},{"id":"d","text":"a great number of"}]'::jsonb, 'a', 'Traffic is uncountable, and a lot of works with uncountable nouns: a lot of traffic. Many, a few and a great number of all require countable plural nouns, which traffic is not (we never say "traffics").', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d678d2e0-d116-5579-95a6-46b08d0b347c', '58d964b6-70a2-59e5-8cea-1bdf567dcd59', 'Read: "Sami had very little money left. He counted his coins: he had just enough for one ticket, but not for a drink as well."
Which statement is TRUE?', '[{"id":"a","text":"Sami had a lot of money."},{"id":"b","text":"Sami could buy a ticket and a drink."},{"id":"c","text":"Sami had almost no money left."},{"id":"d","text":"Sami had many money."}]'::jsonb, 'c', '"Very little money" means almost none, so (c) is true. (a) says the opposite; (b) contradicts "not for a drink as well"; and (d) is ungrammatical anyway — money is uncountable, so it takes much/little, never "many money".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

