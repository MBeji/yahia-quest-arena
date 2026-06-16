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
      AND q.id NOT IN ('3e037a7a-5ed7-5ed2-af30-3d16cca4721e', 'f36cb4ed-8c2b-5caf-88c1-640ca39a6eac', '4f63f32f-97f5-5838-9b4b-b5cd5706bcda', 'f917cc3e-a44b-57e1-8c2c-9a2fbaceae82', '10613ce9-c71d-5bc5-8f6a-c9f99a3ec983', '67803171-4ef0-5d7b-ab28-77681a257e14', '750cc1a9-9304-5fd3-bd9d-1eaa5dfaa5c5', 'd762f612-a069-55df-acb9-00b5dbea0d5e', '8294275b-4f33-5208-b3ea-1607a0fbc5d7', '4033fd02-4785-52a6-8eb4-a34889b627cb', '8ca5c548-d4fd-567c-923f-8f7a8eed2cfb', 'de82bb98-dd15-5d5c-a9b2-64fce35073c8', 'd8addc12-2b57-5e04-9fc8-ab1d52b10477', '1a0ede4d-ee13-54e7-a4c9-cfd9cc774457', '44debdc5-4d4c-58ab-a96d-3c3c177dd515', '6241e55b-934f-5ce2-bf21-0dfef0243070', 'fee3b50e-c03b-5728-a0ac-16295d1eb33a', '5350a3cb-facd-5a7a-8acc-115980bcfb3b', '2fe84986-3d09-5c31-9966-cccab0da6192', '99fd1425-4c06-51a6-8470-e87f4bdac84f', 'f4784ce0-089c-53da-b1b9-8877c96da597', 'abbd5bd5-238a-5a92-9088-a08552b99086', 'c83c08c6-2013-535e-8ebf-a77b3d74b94d', 'c3ef3d74-a505-5e44-a1d1-02e7f4baa8a4', 'f4a7c5b3-b149-59a7-bb77-e2c89b902797', 'd7f5e248-7df5-50e3-9d37-214173691cde', '4fd2403a-b955-5017-9884-d0c3e6602b1f', '431ad58a-724c-5673-9110-b8bf0802cc2f', '178c3f6a-db01-5429-be7f-9e05160129d7', 'e9dfb0ec-6829-59a0-8847-a883330459aa', '10882f0b-efba-5472-b2b4-5f4772f19876', 'a52adf51-2ad4-5711-9832-0c523c2b5787', '3e5718e1-ded0-5c5d-b3ff-2da4639a1c25', '6ac15951-5c1a-5a7e-b9ba-b39528f61a94', 'f42cbb42-39ab-5720-a2f4-637916028bea', '5e859810-7689-5777-9235-f7c25c6e128e', '0f797a8a-83f2-5701-ad1a-88fb6259ff34', '65f44302-6616-512e-89af-0ba815e557e7', '5e490fcb-583f-55fb-aaa6-fb39d51a4d8a', '4af03ffb-a282-5e94-a7a1-7ff4a3d8f6bd', 'fe21edf0-18f0-5bca-baa6-946f2d97bf33', 'ba25f9fc-5a57-5445-8641-8f99e4d79855', '56a4079e-1c05-57a3-8832-d5bc5d530f61', '20bd7587-e0cf-59de-93bb-7e7d7c726b52', '733369a5-6ccf-543e-921e-d97a4e0957d1', 'b5655229-cc6d-5771-9533-d38dc872d330', 'c7f4ad66-251b-5c52-b41b-5f84216c412a', 'ff8598da-2ad7-5dff-bff4-2d8fbba8d362', '1286ea84-6fda-5fae-8ac8-59cf978fef43', '83875e9e-8bce-5e80-99e0-5f82cd0635c9', '51084542-941c-55ea-8307-d00ea4f6dc4f', 'ba37186c-a4e3-5438-bbd3-772d87cc9d78', '52b2b34e-f892-5389-abb0-a2e63c739860', '2a98f5c9-075a-5832-8d89-c109bc29e594', 'd778437c-a132-5099-aa77-c1aaa01a227c', '456cf5c8-c04c-554a-a8d9-901428741ae6', '32792bc5-eddf-50bd-99fd-c91da5869914', '381d8e07-5082-5b40-b06d-16697ceb4fc1', '4d29eef2-e641-5ec2-80a1-c56da7888787', 'b91b436c-cc5f-5696-a3b6-f755386cff91', '073a2381-a05e-5d51-92dc-25b64dcc71bb', 'b717bb55-1b37-58e7-876c-bb4f29a08604', '411a7bae-573d-5720-aacd-e5f4cc03d2fc', '57773bbe-a631-5740-a137-13df78bede07', 'dfa6adf6-f903-53fe-b774-6c31eaadf2d9', '6828d1bf-7b78-56e6-81cb-3b162fa0a0ce', 'ec0739ca-33c3-595e-a330-d17c39e4948a', 'e41ece63-9bd5-54ca-a0d0-5da1af711911', '646286bd-541c-5cef-848e-f65ee44da7f1', 'cc92b810-c595-540f-ace3-9cc89cbdafae', 'cea89bf6-1be7-5b23-b5f5-97da85026053', '16c44583-2261-596d-9bfd-1c6ea8faa4b4', '502a39aa-0576-5e56-90e1-dfb96f8ded7f', '23610b43-099b-5ddc-a4d5-663359fdb8a4', 'a949ceb2-b65c-5999-a564-b28c95b0e5bc', '3a6021de-bd99-510a-8a85-30ff7d55045b', 'a708b7da-f87d-5f35-bfa6-296027046778', 'e36d3bb8-886b-51cb-86b4-d189341c7d4d', 'fa84d274-2d45-52e3-8d04-fe5a4f8fb994', '9a8ec7b0-728f-55f2-a3bb-e6eab8806f4f', '4fa5c943-05da-5b19-b908-f8a46f05f2cc', 'db74d52f-4dd2-5f4c-a3c7-bd9c8c7dfebf', 'aa9fa7e6-675c-5e90-b8f8-546b4ebe006f', 'cf6bf9ce-6aec-51a3-b114-8935ad5be3f2', 'dae83ff0-7da8-5c2a-a8e1-7ea9e0510ea7', 'a7616ddf-18ce-5a10-8638-9c8e91fc988b', '74e77b4a-e803-5416-8a18-9f2b73ebcaa4', 'a877c13f-f3ab-500c-82c2-444c74dc8d30', '88838816-e99c-5f9a-a8bd-357a8a58bc18', '0108e45b-c7bc-559f-8d42-b8dacfec8866', 'c3c0d9ec-1165-5983-804d-f294df94fe31', 'b3412a95-d153-5712-a756-670894271110', 'c8d54da2-4030-5889-98e7-be9e06dcf215', 'e0f06629-1a6d-52fd-9c9d-4b9d4e76b6ca', '1faee336-67eb-598c-b3fc-26a9ae3e4889', 'b7209048-9f87-5fbb-9d08-0ffe7b8c7196', '9dfee013-d1e0-5e51-b55d-1e2bdbe4d965', '5c4bb149-e0e3-59f9-a76a-7ed9a0004311', '4ba358b7-f193-5a94-8962-1c35905d45c0', 'c8315512-22e2-5173-8a92-a4a452371226', '372f80c2-fc84-5aec-90c1-ce8b62acb33b', 'f67e9449-645e-58a9-b62f-5ad8472ebeee', '9e674c12-79cb-5dfc-a8b9-3f5031c3f6a7', '624c1ee8-e05e-57e0-961e-ff36306c335c', 'c0da9dc8-2043-5d43-91c4-45befd5b2fd9', 'd45ded3b-0a28-54b5-bf8a-38a4448595fd', 'ebb7438a-e17e-5fb2-af0a-8a9a6b68b2e9', '6568e74d-fc4c-5cc5-ac27-6f87b168166e', '076fb52e-e528-5b61-bf65-eabc0bf08dbe', '0e54903c-d564-524f-9429-cc362d494211', '0018a4f0-38e5-536e-abf0-bff222543247', '2fa44d4d-01f7-5736-be0d-cce7aa752a6e', '826968a5-a6a6-5ff0-8c3f-d2064e24d539', '66618313-f12d-524a-b5e6-359e71ec0197', 'adc4f7e9-0e52-5124-bb58-c3868cf2d21a', '66b84bda-b6c1-5b96-ae5d-76bca44ffda1', '44dabcb9-8e4a-5ced-8d14-b4b2dd242948', '5f5d8ad9-49d6-5b2f-9c6c-c319312b52be', 'd1e4db9a-ef0d-5ef1-a7f2-2c25439983bd', '173c664d-840f-5f7c-8149-1c7b1cfec277', 'fb1a1519-3ad3-5a39-9d1b-338037d7083c', '3496518f-5cc2-5d2f-9875-282e13d18e13', '1cdbd8ff-4809-520a-b1c2-e4b4200cf55d', '6515db40-efc6-5fd0-8aed-db9a6fe0bce4', '65d70e77-273c-5206-8aa8-0a382fe39f7e', 'fffa044c-7217-5a06-a992-f41813d46c6b', '33c36885-1da3-5144-be8c-8726b18bdc5d', '9eb0e927-6a88-508f-8e83-04188c72c532', 'ae2dbfee-567e-5a54-b7cc-615e874969db', 'd5f2940e-ac61-53bc-8c95-d82056e89b1c', '2cdc8c6b-e46c-5c11-a059-f5af27926417', '5f140249-cafa-5b80-aa46-fc91615eac19', '4bfdd249-c85e-5636-a0f1-c417f8129ae5', 'd83ca647-88a6-5707-aeb0-75cbd1ed444c', '8212b7ed-3e99-533a-a7fd-cd5273e6fef3', 'f5cda5e8-39e1-50d4-9ca7-e45f56a9fc40', 'd5ef99ab-c6fb-557e-a540-f9d3aaec27fd', '24121150-1cc9-5ea4-8942-3eed1f5c39a5', 'a531f411-28b0-5a33-b2da-029673146b04', '89a61b11-f39a-5eaf-8fb7-ee5c6e16a57a', '05b38fbb-5f1c-55b2-b31e-79c915e4613e', '4645cf87-9116-5436-bf87-a6f2daa8193e', '1eae62bf-a143-5e80-8778-13076dcb6990', '9a297ed8-fb96-500a-bd04-f7f3617e4cf9', '4b714276-5b15-594b-aa83-efbf026b160c', '1a1731b2-4da6-583c-830d-a4e6ebb9cd60', 'f8c8eceb-7d0e-5c4d-916c-3de4daa48c3e', '86da6674-3174-50df-a091-6a86a2647ab0', '18f5ebdb-803e-55f3-ab1c-d8b64acbc9f6', '13725910-cc7a-5cdc-a6ec-6fb709c87996', '1fbb3d79-512d-5eec-97a2-fc07c99132df', '594e4cf0-850f-5ff5-8f54-b39e0a4bc164', '12c95499-a7dc-54cc-9bbb-9aa7ad99f0ff', 'de02d447-34d2-5152-bb34-cb476786ba29', '432f296e-7274-5812-b5f3-fe76b86650b6', '276f00e2-fa35-58d7-9751-54dc8f37d00a', '91f548dd-60f7-5a5d-a30e-dcf131ef6cad', '281b6cd5-39a2-54f4-b416-57ff57cd3e82', '6bba7a52-553a-5d61-87be-800cdf7cef90', 'fb6cc96b-cd13-515f-a2a3-d91dc84c36e5', '6d2dae3b-5be4-545f-bbd4-8272fc6d025b', 'a0f08a04-5d92-5eb4-9e7b-2e77a3b5c7df', '0688bba7-315f-54a3-8636-f3116f8a30aa', '18ab785c-e4ef-5248-934d-e75d051f1add', 'e5f6fa3b-39ed-59b2-8bc1-1077b2be432c', 'ef845654-0c13-5c48-9b52-8e950e5924a9', 'a19a017d-29ed-5802-9fb8-3f2f7d604e4c', 'a6baa9cc-9ca0-58a2-b26f-6f8ee1fc53e5', 'd678d2e0-d116-5579-95a6-46b08d0b347c', '7e001ec5-db56-521a-8c7c-77be590f44d4', 'b7ab0ae1-774d-5f08-88f9-d1084ddaae13', 'f8b84f43-d799-587d-ba64-ab723ed8c875', '0136d4ad-070c-5298-bd0b-f7956cd16081', 'b5e91a2b-1fbd-5049-a357-ce227c1f28d5', '7c8e2cd4-843e-53e9-bde1-7872d075c471', '48cf1208-d25b-56d3-8ba3-fa6417161633', '51a3463c-2043-5b01-8888-50b1ac20ea3f', '267ce76a-49e2-58f5-9384-af3fc8556934', 'bcbcf788-05f5-5f39-ab7d-d5a84df69d14', 'f5eb06c5-c5b1-5388-a491-e2e43492d5cc', 'd0bf53b7-6f40-5d9d-aa39-f4a14e514692', '3909cafc-6249-5114-bcb7-47b320bb06bb', '18a6405b-6ec5-54ea-9ffb-5ebb5b5cbbbe', '41bb041d-e7cb-5bdd-bfc7-5b3d5c8a1c2c', '459bb446-ad2b-5e30-9d37-f4747a6e6508', '5acab18d-af1d-5842-a648-720e1115fb89', 'de154505-e56c-526b-ae89-d6fcda4a6998', 'e8d20483-ae14-5faf-b43b-43772941277f', '5243244e-9818-5f09-90e5-501cc9da5f11', '238ccef9-22b5-55ef-9afb-4776b134b83b', '6e3cf808-de27-5f42-95d3-4d995f9a34ab', '7ef1c917-4f0d-5a52-9c3c-c96fbc617721', '4b702ee1-571e-5d9d-b627-3974a2bb604d', 'b94e1b4c-7e87-5f8a-9cf6-97552fa8be08', 'f8216c40-63b0-5310-8e42-2b7d03db91db', '0baa5ffc-292a-5c47-9ab4-de47c739d760', '6a24326e-fe30-59b9-af01-0432a819a43f', 'd8d9e7b1-aff6-5d40-b63f-13ffcaa85882', '0e555c1c-3aa5-5509-ac64-ad06b7beb4f6', 'fb3ed2ea-c8d8-58a9-805f-0f60fb2e28d7', '19d78e4b-3646-5c69-be07-f22777792935', '7b12308a-0e99-510c-a2cd-b1742b141853', '4154ec58-3678-506f-951c-91b28a4519c8', 'ce1369ab-cd0e-589c-bf5f-7884eec5089e', 'd8e7279f-3de0-5566-a269-0a9087102a2d', '87968325-2a83-55cd-ade1-a4615a9a2e5d', 'f1644f94-22b9-54de-bdac-3c13728ed4d1', '17b5f9a2-bad9-5a37-9f4a-942a602fd2d5', 'd6431b59-04f2-5bd4-b126-6855b45ea648', '43b057de-af33-54e4-a805-c4514a5ba9d7', '86e6fa2c-8451-515d-a43f-2719b82b7fe7', '3245ca57-e9ab-5238-9988-db1ab69b55ec', '5725bff7-4ede-5a84-b7fc-a41601f457f1', 'e2d501dd-045c-57be-87f7-51786652cf71', '158c646b-732d-5bda-8e24-220c33d900c1', 'cc1e9530-5f95-549d-bf98-7c00a503adce', '02cea6a7-05c5-5dd6-a4ec-684361d2275f', '6c550b1c-609c-5ca7-a51c-c61f2ed8e3da', 'c665cc40-f950-5a5a-ade5-b8cb74625f26', '034a8538-2ec1-5bbf-ae7e-1a8789e11930', '94d195af-5fb0-5c75-aa51-cbc31147cbb5', 'b118a00a-466d-529e-b714-9a04b7b7a2cd', 'a55f08b3-158a-5f96-933b-ea556e605bd7', '6908b798-4a8b-5702-b926-fd38567a9f0c', '6abdeb63-5a53-5311-b510-6c940628d51e', '21d3403c-2bc5-51da-b0f9-132936ea3112', 'cb0c321a-cc5e-5741-aefa-ae01518acd40', '834a8a76-96bd-538f-a49f-8382b6692191', '83f9481a-0810-52de-93e3-d59445e57a83', 'f15e48a0-ad38-5db5-a0d0-490881910e2c', '7cfaea87-0de2-58d3-b40b-c9c94ee0ddfb', '5b77f353-5833-5e33-a765-e54964d9abcd', 'd7e4d5d2-d516-51cc-82d7-d2aee834a186', 'a13fd8a3-e9e8-5436-9660-207e5c730edf', '1923bd2f-3da2-5a50-847d-aa724ecd14fc', 'b3f9d448-19a2-5a44-ab3a-6d4229fd7461', 'f59943f3-9cdd-516b-93d2-2817b2230899', 'd59b78ad-2379-5615-9279-c5d5880fb8d8', 'e555c279-c294-58ac-9498-8987e20f6c0f', 'f6cd47a2-af29-5ca8-bbfc-243679b2acae', '0dcea926-7443-522d-bbda-9a5d16244f14', 'daea48a6-bbf3-5d6f-9cf9-5c7e1839e43d', '9a7ec926-c9f2-5692-9d6b-f95306330738', '7c80243b-c44f-573f-bad3-8e88cda69bc6', '9f1aa005-91bf-5b00-b3df-01a7bc009499', '55dd64c4-ad42-510d-a510-6b39a348d832', '0058b759-e051-5277-beb0-34e89ce1fe16', '13ba66d5-e0c6-568c-a6e5-21f96cdefe10', '7a758fa2-e953-5a7d-b884-617963921991', 'fb93e953-c700-5117-ab8a-73d5c3846eb2', 'eb936c96-9535-501a-b8c3-4d8dd6ea9953', 'd8200187-70a9-5451-8d0c-38ea70d4bf3c', 'cbd97f1f-bf82-5e14-a6f3-eeb0139ed2ff', '020bf4b9-d3b5-53fc-8f29-57ff4ba61427', 'd511d64d-3924-5beb-90e9-7664472a6ad5', '00326ff7-4584-5f8f-b01d-72052acb7867', '3a3608ee-6263-5111-96be-d565962adfc4', 'f09daf22-6a13-5293-b06f-daa3820e1be0', '54451583-7665-5291-b32a-52a0c558a276', 'ea5e76a1-da62-5e83-b477-4c36b78db067', 'a6144993-8667-5a22-9d71-28ea3d921a44', 'eedfc518-bcca-54bf-821d-958bdd4aa41e', 'c82da18d-3a81-51a4-b943-1e8bc12ac124', '9d120d0b-5e43-5cba-a33a-aa6965ff7673', '761779ed-1e38-5a8b-8446-03b4e45bbca9', 'f8681401-2a05-5ed6-8bbb-009d5d36112f', '25caccd6-b43b-5ab4-8c6e-db60e9a7fa51', '1b2ba23b-091b-5d4d-baff-2fc9b4b53c0c', 'd5a67d97-fdb0-5c0a-a08e-f99d8d2482d1', 'cb29da7b-fb9b-5e30-941b-6964741cd6ce', '2e9c9ef5-7275-5b83-b91e-b96ecf857bab', 'f0e2c288-e2ef-55d1-b0c8-7e409807f2f2', '34fdca4f-617a-56c3-ad53-c608205e8be4', 'c9b20585-1550-5f19-af02-dbac1ecf6ee0', '9ce8230b-4ba0-57a9-b129-b2d01ad50e7b', '3fda5347-f46b-5ca8-b844-cb4eb618105b', '089b52b5-9a33-5935-8a48-d8b86a788cd9', '0af07854-57fb-59ee-9cc5-041db6740343', '51c917de-4eb1-5983-86fb-36d80ff776f1', '1ba5387d-6b3f-5c59-9d0d-cda8ba088086');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'anglais-a2' AND source = 'admin' AND id NOT IN ('6de36006-7b5b-5ba7-8afd-13ce903f5f42', '6867f421-cea5-5df0-9666-7babe2a90b3b', 'c5491462-662b-5a15-b533-46415e1bf4b7', '178872f7-43eb-528d-8246-28ad0e7eab21', '09f3cd3d-f920-5a07-8b30-fee999a986cd', '0c33fe5a-4c6d-546d-aa01-4d79fbe98ab8', '50b8981a-78f0-5565-8f3c-f8c659daa8ec', '98045a56-5be0-53c5-a627-7d0d17deb05e', 'e691367c-515b-597d-8d57-e244dd24c850', '754775f8-d378-53b6-98f9-a0924b494121', '47e54093-2203-5414-a472-cc9e4917aeb3', '3ff0815b-c740-5e4e-80cf-c9ebed192025', 'cf9ddcb7-22b8-5c5b-b828-dfa6cb2835e4', '4dcffdb4-597d-5fbc-a122-b94d47ebcff2', '6ca0d95b-c9f7-5c0c-97c2-95da614e145e', 'de9404d0-8667-53f3-a654-f04f6d8955c8', 'd60c44d2-ce2f-59a5-9375-e8c2868f66b3', 'f809962f-a982-5f28-b722-48c9d35f2865', 'e1bf4d50-774d-5cb1-9926-2ea2e341c3d6', 'ffa96f28-789e-5809-8d85-b5d640ee3082', '4bc456d2-9039-5c36-88cb-c5ea5bc548ff', 'ba43d85c-68f2-55c8-bde9-6c26c3c03d63', 'd3fad499-2659-5b82-a444-c0478c8fe11a', 'c0724d6f-251f-57b3-9043-d309c4ff074a', '736f94be-5dfa-5675-92aa-9a74e7519799', '93b7785b-3211-5965-af18-70b9bbf85c28', '6e52817f-3bd5-55fa-9132-46e7ca8e5328', '9c248cdd-3bd5-582b-a6c5-d51920cea289', '58d964b6-70a2-59e5-8cea-1bdf567dcd59', '81a7d66b-1a39-5afa-9a39-64ac86e3a15b', '1fb21b23-9789-5655-b2fe-2e9de98536c2', '769ecc3e-864b-55c6-870d-8cdf24bbab11', 'a218ba57-5504-5972-b614-0b365324eb4f', '35da4b80-c7e0-5c36-9fc9-56c13b45bf97', 'a96228f1-afe4-507c-bc06-069588dbb977', '559ccfa4-5113-5eb1-ae42-8839bdd0486d', '2846d3b6-cbd0-5a0d-b12b-ef2549bf7c06', '7758e2ca-fce5-566b-bf94-b3f99dfbfbe6', '21228e92-c390-502c-ab8c-a19f0e3868d5', 'eb3dd319-cefc-5512-9e5e-6d26c217f410', '3b2a3c3d-4c95-5947-b263-1d6102d7c52a', '8ae4d96c-0b6a-59f7-99ca-cc387b3c0206', 'bab4adf5-961b-5821-a1b3-805fdfe17dd8', '5e7ed9ea-d718-5846-92b6-0b1a38d83023', '8408e2c1-21ed-5c60-8158-8923c6ef542f', 'cef5393a-cdbb-5a7a-a263-5d569e8abbe0', '94de84a3-e87f-5b67-af91-71f3373053f7', 'c534779a-9369-5e62-b816-29adcd746674');
DELETE FROM public.questions WHERE exercise_id IN ('6de36006-7b5b-5ba7-8afd-13ce903f5f42', '6867f421-cea5-5df0-9666-7babe2a90b3b', 'c5491462-662b-5a15-b533-46415e1bf4b7', '178872f7-43eb-528d-8246-28ad0e7eab21', '09f3cd3d-f920-5a07-8b30-fee999a986cd', '0c33fe5a-4c6d-546d-aa01-4d79fbe98ab8', '50b8981a-78f0-5565-8f3c-f8c659daa8ec', '98045a56-5be0-53c5-a627-7d0d17deb05e', 'e691367c-515b-597d-8d57-e244dd24c850', '754775f8-d378-53b6-98f9-a0924b494121', '47e54093-2203-5414-a472-cc9e4917aeb3', '3ff0815b-c740-5e4e-80cf-c9ebed192025', 'cf9ddcb7-22b8-5c5b-b828-dfa6cb2835e4', '4dcffdb4-597d-5fbc-a122-b94d47ebcff2', '6ca0d95b-c9f7-5c0c-97c2-95da614e145e', 'de9404d0-8667-53f3-a654-f04f6d8955c8', 'd60c44d2-ce2f-59a5-9375-e8c2868f66b3', 'f809962f-a982-5f28-b722-48c9d35f2865', 'e1bf4d50-774d-5cb1-9926-2ea2e341c3d6', 'ffa96f28-789e-5809-8d85-b5d640ee3082', '4bc456d2-9039-5c36-88cb-c5ea5bc548ff', 'ba43d85c-68f2-55c8-bde9-6c26c3c03d63', 'd3fad499-2659-5b82-a444-c0478c8fe11a', 'c0724d6f-251f-57b3-9043-d309c4ff074a', '736f94be-5dfa-5675-92aa-9a74e7519799', '93b7785b-3211-5965-af18-70b9bbf85c28', '6e52817f-3bd5-55fa-9132-46e7ca8e5328', '9c248cdd-3bd5-582b-a6c5-d51920cea289', '58d964b6-70a2-59e5-8cea-1bdf567dcd59', '81a7d66b-1a39-5afa-9a39-64ac86e3a15b', '1fb21b23-9789-5655-b2fe-2e9de98536c2', '769ecc3e-864b-55c6-870d-8cdf24bbab11', 'a218ba57-5504-5972-b614-0b365324eb4f', '35da4b80-c7e0-5c36-9fc9-56c13b45bf97', 'a96228f1-afe4-507c-bc06-069588dbb977', '559ccfa4-5113-5eb1-ae42-8839bdd0486d', '2846d3b6-cbd0-5a0d-b12b-ef2549bf7c06', '7758e2ca-fce5-566b-bf94-b3f99dfbfbe6', '21228e92-c390-502c-ab8c-a19f0e3868d5', 'eb3dd319-cefc-5512-9e5e-6d26c217f410', '3b2a3c3d-4c95-5947-b263-1d6102d7c52a', '8ae4d96c-0b6a-59f7-99ca-cc387b3c0206', 'bab4adf5-961b-5821-a1b3-805fdfe17dd8', '5e7ed9ea-d718-5846-92b6-0b1a38d83023', '8408e2c1-21ed-5c60-8158-8923c6ef542f', 'cef5393a-cdbb-5a7a-a263-5d569e8abbe0', '94de84a3-e87f-5b67-af91-71f3373053f7', 'c534779a-9369-5e62-b816-29adcd746674') AND id NOT IN ('3e037a7a-5ed7-5ed2-af30-3d16cca4721e', 'f36cb4ed-8c2b-5caf-88c1-640ca39a6eac', '4f63f32f-97f5-5838-9b4b-b5cd5706bcda', 'f917cc3e-a44b-57e1-8c2c-9a2fbaceae82', '10613ce9-c71d-5bc5-8f6a-c9f99a3ec983', '67803171-4ef0-5d7b-ab28-77681a257e14', '750cc1a9-9304-5fd3-bd9d-1eaa5dfaa5c5', 'd762f612-a069-55df-acb9-00b5dbea0d5e', '8294275b-4f33-5208-b3ea-1607a0fbc5d7', '4033fd02-4785-52a6-8eb4-a34889b627cb', '8ca5c548-d4fd-567c-923f-8f7a8eed2cfb', 'de82bb98-dd15-5d5c-a9b2-64fce35073c8', 'd8addc12-2b57-5e04-9fc8-ab1d52b10477', '1a0ede4d-ee13-54e7-a4c9-cfd9cc774457', '44debdc5-4d4c-58ab-a96d-3c3c177dd515', '6241e55b-934f-5ce2-bf21-0dfef0243070', 'fee3b50e-c03b-5728-a0ac-16295d1eb33a', '5350a3cb-facd-5a7a-8acc-115980bcfb3b', '2fe84986-3d09-5c31-9966-cccab0da6192', '99fd1425-4c06-51a6-8470-e87f4bdac84f', 'f4784ce0-089c-53da-b1b9-8877c96da597', 'abbd5bd5-238a-5a92-9088-a08552b99086', 'c83c08c6-2013-535e-8ebf-a77b3d74b94d', 'c3ef3d74-a505-5e44-a1d1-02e7f4baa8a4', 'f4a7c5b3-b149-59a7-bb77-e2c89b902797', 'd7f5e248-7df5-50e3-9d37-214173691cde', '4fd2403a-b955-5017-9884-d0c3e6602b1f', '431ad58a-724c-5673-9110-b8bf0802cc2f', '178c3f6a-db01-5429-be7f-9e05160129d7', 'e9dfb0ec-6829-59a0-8847-a883330459aa', '10882f0b-efba-5472-b2b4-5f4772f19876', 'a52adf51-2ad4-5711-9832-0c523c2b5787', '3e5718e1-ded0-5c5d-b3ff-2da4639a1c25', '6ac15951-5c1a-5a7e-b9ba-b39528f61a94', 'f42cbb42-39ab-5720-a2f4-637916028bea', '5e859810-7689-5777-9235-f7c25c6e128e', '0f797a8a-83f2-5701-ad1a-88fb6259ff34', '65f44302-6616-512e-89af-0ba815e557e7', '5e490fcb-583f-55fb-aaa6-fb39d51a4d8a', '4af03ffb-a282-5e94-a7a1-7ff4a3d8f6bd', 'fe21edf0-18f0-5bca-baa6-946f2d97bf33', 'ba25f9fc-5a57-5445-8641-8f99e4d79855', '56a4079e-1c05-57a3-8832-d5bc5d530f61', '20bd7587-e0cf-59de-93bb-7e7d7c726b52', '733369a5-6ccf-543e-921e-d97a4e0957d1', 'b5655229-cc6d-5771-9533-d38dc872d330', 'c7f4ad66-251b-5c52-b41b-5f84216c412a', 'ff8598da-2ad7-5dff-bff4-2d8fbba8d362', '1286ea84-6fda-5fae-8ac8-59cf978fef43', '83875e9e-8bce-5e80-99e0-5f82cd0635c9', '51084542-941c-55ea-8307-d00ea4f6dc4f', 'ba37186c-a4e3-5438-bbd3-772d87cc9d78', '52b2b34e-f892-5389-abb0-a2e63c739860', '2a98f5c9-075a-5832-8d89-c109bc29e594', 'd778437c-a132-5099-aa77-c1aaa01a227c', '456cf5c8-c04c-554a-a8d9-901428741ae6', '32792bc5-eddf-50bd-99fd-c91da5869914', '381d8e07-5082-5b40-b06d-16697ceb4fc1', '4d29eef2-e641-5ec2-80a1-c56da7888787', 'b91b436c-cc5f-5696-a3b6-f755386cff91', '073a2381-a05e-5d51-92dc-25b64dcc71bb', 'b717bb55-1b37-58e7-876c-bb4f29a08604', '411a7bae-573d-5720-aacd-e5f4cc03d2fc', '57773bbe-a631-5740-a137-13df78bede07', 'dfa6adf6-f903-53fe-b774-6c31eaadf2d9', '6828d1bf-7b78-56e6-81cb-3b162fa0a0ce', 'ec0739ca-33c3-595e-a330-d17c39e4948a', 'e41ece63-9bd5-54ca-a0d0-5da1af711911', '646286bd-541c-5cef-848e-f65ee44da7f1', 'cc92b810-c595-540f-ace3-9cc89cbdafae', 'cea89bf6-1be7-5b23-b5f5-97da85026053', '16c44583-2261-596d-9bfd-1c6ea8faa4b4', '502a39aa-0576-5e56-90e1-dfb96f8ded7f', '23610b43-099b-5ddc-a4d5-663359fdb8a4', 'a949ceb2-b65c-5999-a564-b28c95b0e5bc', '3a6021de-bd99-510a-8a85-30ff7d55045b', 'a708b7da-f87d-5f35-bfa6-296027046778', 'e36d3bb8-886b-51cb-86b4-d189341c7d4d', 'fa84d274-2d45-52e3-8d04-fe5a4f8fb994', '9a8ec7b0-728f-55f2-a3bb-e6eab8806f4f', '4fa5c943-05da-5b19-b908-f8a46f05f2cc', 'db74d52f-4dd2-5f4c-a3c7-bd9c8c7dfebf', 'aa9fa7e6-675c-5e90-b8f8-546b4ebe006f', 'cf6bf9ce-6aec-51a3-b114-8935ad5be3f2', 'dae83ff0-7da8-5c2a-a8e1-7ea9e0510ea7', 'a7616ddf-18ce-5a10-8638-9c8e91fc988b', '74e77b4a-e803-5416-8a18-9f2b73ebcaa4', 'a877c13f-f3ab-500c-82c2-444c74dc8d30', '88838816-e99c-5f9a-a8bd-357a8a58bc18', '0108e45b-c7bc-559f-8d42-b8dacfec8866', 'c3c0d9ec-1165-5983-804d-f294df94fe31', 'b3412a95-d153-5712-a756-670894271110', 'c8d54da2-4030-5889-98e7-be9e06dcf215', 'e0f06629-1a6d-52fd-9c9d-4b9d4e76b6ca', '1faee336-67eb-598c-b3fc-26a9ae3e4889', 'b7209048-9f87-5fbb-9d08-0ffe7b8c7196', '9dfee013-d1e0-5e51-b55d-1e2bdbe4d965', '5c4bb149-e0e3-59f9-a76a-7ed9a0004311', '4ba358b7-f193-5a94-8962-1c35905d45c0', 'c8315512-22e2-5173-8a92-a4a452371226', '372f80c2-fc84-5aec-90c1-ce8b62acb33b', 'f67e9449-645e-58a9-b62f-5ad8472ebeee', '9e674c12-79cb-5dfc-a8b9-3f5031c3f6a7', '624c1ee8-e05e-57e0-961e-ff36306c335c', 'c0da9dc8-2043-5d43-91c4-45befd5b2fd9', 'd45ded3b-0a28-54b5-bf8a-38a4448595fd', 'ebb7438a-e17e-5fb2-af0a-8a9a6b68b2e9', '6568e74d-fc4c-5cc5-ac27-6f87b168166e', '076fb52e-e528-5b61-bf65-eabc0bf08dbe', '0e54903c-d564-524f-9429-cc362d494211', '0018a4f0-38e5-536e-abf0-bff222543247', '2fa44d4d-01f7-5736-be0d-cce7aa752a6e', '826968a5-a6a6-5ff0-8c3f-d2064e24d539', '66618313-f12d-524a-b5e6-359e71ec0197', 'adc4f7e9-0e52-5124-bb58-c3868cf2d21a', '66b84bda-b6c1-5b96-ae5d-76bca44ffda1', '44dabcb9-8e4a-5ced-8d14-b4b2dd242948', '5f5d8ad9-49d6-5b2f-9c6c-c319312b52be', 'd1e4db9a-ef0d-5ef1-a7f2-2c25439983bd', '173c664d-840f-5f7c-8149-1c7b1cfec277', 'fb1a1519-3ad3-5a39-9d1b-338037d7083c', '3496518f-5cc2-5d2f-9875-282e13d18e13', '1cdbd8ff-4809-520a-b1c2-e4b4200cf55d', '6515db40-efc6-5fd0-8aed-db9a6fe0bce4', '65d70e77-273c-5206-8aa8-0a382fe39f7e', 'fffa044c-7217-5a06-a992-f41813d46c6b', '33c36885-1da3-5144-be8c-8726b18bdc5d', '9eb0e927-6a88-508f-8e83-04188c72c532', 'ae2dbfee-567e-5a54-b7cc-615e874969db', 'd5f2940e-ac61-53bc-8c95-d82056e89b1c', '2cdc8c6b-e46c-5c11-a059-f5af27926417', '5f140249-cafa-5b80-aa46-fc91615eac19', '4bfdd249-c85e-5636-a0f1-c417f8129ae5', 'd83ca647-88a6-5707-aeb0-75cbd1ed444c', '8212b7ed-3e99-533a-a7fd-cd5273e6fef3', 'f5cda5e8-39e1-50d4-9ca7-e45f56a9fc40', 'd5ef99ab-c6fb-557e-a540-f9d3aaec27fd', '24121150-1cc9-5ea4-8942-3eed1f5c39a5', 'a531f411-28b0-5a33-b2da-029673146b04', '89a61b11-f39a-5eaf-8fb7-ee5c6e16a57a', '05b38fbb-5f1c-55b2-b31e-79c915e4613e', '4645cf87-9116-5436-bf87-a6f2daa8193e', '1eae62bf-a143-5e80-8778-13076dcb6990', '9a297ed8-fb96-500a-bd04-f7f3617e4cf9', '4b714276-5b15-594b-aa83-efbf026b160c', '1a1731b2-4da6-583c-830d-a4e6ebb9cd60', 'f8c8eceb-7d0e-5c4d-916c-3de4daa48c3e', '86da6674-3174-50df-a091-6a86a2647ab0', '18f5ebdb-803e-55f3-ab1c-d8b64acbc9f6', '13725910-cc7a-5cdc-a6ec-6fb709c87996', '1fbb3d79-512d-5eec-97a2-fc07c99132df', '594e4cf0-850f-5ff5-8f54-b39e0a4bc164', '12c95499-a7dc-54cc-9bbb-9aa7ad99f0ff', 'de02d447-34d2-5152-bb34-cb476786ba29', '432f296e-7274-5812-b5f3-fe76b86650b6', '276f00e2-fa35-58d7-9751-54dc8f37d00a', '91f548dd-60f7-5a5d-a30e-dcf131ef6cad', '281b6cd5-39a2-54f4-b416-57ff57cd3e82', '6bba7a52-553a-5d61-87be-800cdf7cef90', 'fb6cc96b-cd13-515f-a2a3-d91dc84c36e5', '6d2dae3b-5be4-545f-bbd4-8272fc6d025b', 'a0f08a04-5d92-5eb4-9e7b-2e77a3b5c7df', '0688bba7-315f-54a3-8636-f3116f8a30aa', '18ab785c-e4ef-5248-934d-e75d051f1add', 'e5f6fa3b-39ed-59b2-8bc1-1077b2be432c', 'ef845654-0c13-5c48-9b52-8e950e5924a9', 'a19a017d-29ed-5802-9fb8-3f2f7d604e4c', 'a6baa9cc-9ca0-58a2-b26f-6f8ee1fc53e5', 'd678d2e0-d116-5579-95a6-46b08d0b347c', '7e001ec5-db56-521a-8c7c-77be590f44d4', 'b7ab0ae1-774d-5f08-88f9-d1084ddaae13', 'f8b84f43-d799-587d-ba64-ab723ed8c875', '0136d4ad-070c-5298-bd0b-f7956cd16081', 'b5e91a2b-1fbd-5049-a357-ce227c1f28d5', '7c8e2cd4-843e-53e9-bde1-7872d075c471', '48cf1208-d25b-56d3-8ba3-fa6417161633', '51a3463c-2043-5b01-8888-50b1ac20ea3f', '267ce76a-49e2-58f5-9384-af3fc8556934', 'bcbcf788-05f5-5f39-ab7d-d5a84df69d14', 'f5eb06c5-c5b1-5388-a491-e2e43492d5cc', 'd0bf53b7-6f40-5d9d-aa39-f4a14e514692', '3909cafc-6249-5114-bcb7-47b320bb06bb', '18a6405b-6ec5-54ea-9ffb-5ebb5b5cbbbe', '41bb041d-e7cb-5bdd-bfc7-5b3d5c8a1c2c', '459bb446-ad2b-5e30-9d37-f4747a6e6508', '5acab18d-af1d-5842-a648-720e1115fb89', 'de154505-e56c-526b-ae89-d6fcda4a6998', 'e8d20483-ae14-5faf-b43b-43772941277f', '5243244e-9818-5f09-90e5-501cc9da5f11', '238ccef9-22b5-55ef-9afb-4776b134b83b', '6e3cf808-de27-5f42-95d3-4d995f9a34ab', '7ef1c917-4f0d-5a52-9c3c-c96fbc617721', '4b702ee1-571e-5d9d-b627-3974a2bb604d', 'b94e1b4c-7e87-5f8a-9cf6-97552fa8be08', 'f8216c40-63b0-5310-8e42-2b7d03db91db', '0baa5ffc-292a-5c47-9ab4-de47c739d760', '6a24326e-fe30-59b9-af01-0432a819a43f', 'd8d9e7b1-aff6-5d40-b63f-13ffcaa85882', '0e555c1c-3aa5-5509-ac64-ad06b7beb4f6', 'fb3ed2ea-c8d8-58a9-805f-0f60fb2e28d7', '19d78e4b-3646-5c69-be07-f22777792935', '7b12308a-0e99-510c-a2cd-b1742b141853', '4154ec58-3678-506f-951c-91b28a4519c8', 'ce1369ab-cd0e-589c-bf5f-7884eec5089e', 'd8e7279f-3de0-5566-a269-0a9087102a2d', '87968325-2a83-55cd-ade1-a4615a9a2e5d', 'f1644f94-22b9-54de-bdac-3c13728ed4d1', '17b5f9a2-bad9-5a37-9f4a-942a602fd2d5', 'd6431b59-04f2-5bd4-b126-6855b45ea648', '43b057de-af33-54e4-a805-c4514a5ba9d7', '86e6fa2c-8451-515d-a43f-2719b82b7fe7', '3245ca57-e9ab-5238-9988-db1ab69b55ec', '5725bff7-4ede-5a84-b7fc-a41601f457f1', 'e2d501dd-045c-57be-87f7-51786652cf71', '158c646b-732d-5bda-8e24-220c33d900c1', 'cc1e9530-5f95-549d-bf98-7c00a503adce', '02cea6a7-05c5-5dd6-a4ec-684361d2275f', '6c550b1c-609c-5ca7-a51c-c61f2ed8e3da', 'c665cc40-f950-5a5a-ade5-b8cb74625f26', '034a8538-2ec1-5bbf-ae7e-1a8789e11930', '94d195af-5fb0-5c75-aa51-cbc31147cbb5', 'b118a00a-466d-529e-b714-9a04b7b7a2cd', 'a55f08b3-158a-5f96-933b-ea556e605bd7', '6908b798-4a8b-5702-b926-fd38567a9f0c', '6abdeb63-5a53-5311-b510-6c940628d51e', '21d3403c-2bc5-51da-b0f9-132936ea3112', 'cb0c321a-cc5e-5741-aefa-ae01518acd40', '834a8a76-96bd-538f-a49f-8382b6692191', '83f9481a-0810-52de-93e3-d59445e57a83', 'f15e48a0-ad38-5db5-a0d0-490881910e2c', '7cfaea87-0de2-58d3-b40b-c9c94ee0ddfb', '5b77f353-5833-5e33-a765-e54964d9abcd', 'd7e4d5d2-d516-51cc-82d7-d2aee834a186', 'a13fd8a3-e9e8-5436-9660-207e5c730edf', '1923bd2f-3da2-5a50-847d-aa724ecd14fc', 'b3f9d448-19a2-5a44-ab3a-6d4229fd7461', 'f59943f3-9cdd-516b-93d2-2817b2230899', 'd59b78ad-2379-5615-9279-c5d5880fb8d8', 'e555c279-c294-58ac-9498-8987e20f6c0f', 'f6cd47a2-af29-5ca8-bbfc-243679b2acae', '0dcea926-7443-522d-bbda-9a5d16244f14', 'daea48a6-bbf3-5d6f-9cf9-5c7e1839e43d', '9a7ec926-c9f2-5692-9d6b-f95306330738', '7c80243b-c44f-573f-bad3-8e88cda69bc6', '9f1aa005-91bf-5b00-b3df-01a7bc009499', '55dd64c4-ad42-510d-a510-6b39a348d832', '0058b759-e051-5277-beb0-34e89ce1fe16', '13ba66d5-e0c6-568c-a6e5-21f96cdefe10', '7a758fa2-e953-5a7d-b884-617963921991', 'fb93e953-c700-5117-ab8a-73d5c3846eb2', 'eb936c96-9535-501a-b8c3-4d8dd6ea9953', 'd8200187-70a9-5451-8d0c-38ea70d4bf3c', 'cbd97f1f-bf82-5e14-a6f3-eeb0139ed2ff', '020bf4b9-d3b5-53fc-8f29-57ff4ba61427', 'd511d64d-3924-5beb-90e9-7664472a6ad5', '00326ff7-4584-5f8f-b01d-72052acb7867', '3a3608ee-6263-5111-96be-d565962adfc4', 'f09daf22-6a13-5293-b06f-daa3820e1be0', '54451583-7665-5291-b32a-52a0c558a276', 'ea5e76a1-da62-5e83-b477-4c36b78db067', 'a6144993-8667-5a22-9d71-28ea3d921a44', 'eedfc518-bcca-54bf-821d-958bdd4aa41e', 'c82da18d-3a81-51a4-b943-1e8bc12ac124', '9d120d0b-5e43-5cba-a33a-aa6965ff7673', '761779ed-1e38-5a8b-8446-03b4e45bbca9', 'f8681401-2a05-5ed6-8bbb-009d5d36112f', '25caccd6-b43b-5ab4-8c6e-db60e9a7fa51', '1b2ba23b-091b-5d4d-baff-2fc9b4b53c0c', 'd5a67d97-fdb0-5c0a-a08e-f99d8d2482d1', 'cb29da7b-fb9b-5e30-941b-6964741cd6ce', '2e9c9ef5-7275-5b83-b91e-b96ecf857bab', 'f0e2c288-e2ef-55d1-b0c8-7e409807f2f2', '34fdca4f-617a-56c3-ad53-c608205e8be4', 'c9b20585-1550-5f19-af02-dbac1ecf6ee0', '9ce8230b-4ba0-57a9-b129-b2d01ad50e7b', '3fda5347-f46b-5ca8-b844-cb4eb618105b', '089b52b5-9a33-5935-8a48-d8b86a788cd9', '0af07854-57fb-59ee-9cc5-041db6740343', '51c917de-4eb1-5983-86fb-36d80ff776f1', '1ba5387d-6b3f-5c59-9d0d-cda8ba088086');
DELETE FROM public.chapters c WHERE c.subject_id = 'anglais-a2' AND c.id NOT IN ('828b2648-a030-59f8-b7b9-88e35658bf5f', '236d3b84-54b3-5186-83fe-611b3a86b7e2', '6121c3f0-68ee-5aff-9817-4f8d3b282fb8', '72d00d0a-78ad-5435-8450-9fc83f5c11ce', '83aa1163-dcf2-5f5b-89ee-833725ca1832', 'ca3b7888-bc66-5ac7-98ec-b55bce3b5678', '2c2df23a-93d7-59b4-bcd6-6ffdc67281c9', '308ad6a2-e0c8-571a-a2ab-d473a9357085') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('828b2648-a030-59f8-b7b9-88e35658bf5f', 'anglais-a2', 'The Past Simple', 'Tell stories about finished past events: was/were, regular -ed verbs and their spelling, common irregular verbs, and negatives and questions with did/didn''t.', '# ⚔️ The Past Simple — Tales of What Already Happened

> 💡 «Every hero has a story. The past simple is how you tell it: what happened, and when.»

## 🏰 What the past simple is for

The **past simple** describes a **finished** action at a **definite** time in the past. The moment is over and closed — _yesterday, last week, in 2015, two days ago_.

_I **watched** a film yesterday. She **travelled** to Tunis last summer._

## ⚡ "To be" in the past: was / were

The verb _to be_ has two past forms. Learn this first — you will use it constantly.

| Subject           | Past form | Example                  |
| ----------------- | --------- | ------------------------ |
| I / he / she / it | **was**   | _I **was** tired._       |
| you / we / they   | **were**  | _They **were** at home._ |

Negative: **wasn''t / weren''t**. Question (inversion, like the present): _**Was** he late? **Were** you happy?_

## 🛡️ Regular verbs: add -ed

Most verbs are regular: just add **-ed**. _work → worked, play → played, open → opened._

| Spelling rule                               | Example         |
| ------------------------------------------- | --------------- |
| ends in **-e** → just add **-d**            | like → liked    |
| **consonant + y** → **-ied**                | study → studied |
| **one short vowel + consonant** → double it | stop → stopped  |

_He **liked** the film. We **studied** all night. The bus **stopped** suddenly._

## 🔮 Irregular verbs: learn them one by one

Many of the most common verbs are **irregular** — no _-ed_, just a new form you must memorize:

| Base | Past | Base | Past |
| ---- | ---- | ---- | ---- |
| go   | went | get  | got  |
| have | had  | make | made |
| do   | did  | take | took |
| see  | saw  | come | came |
| say  | said | eat  | ate  |

_She **went** out. We **had** lunch. I **saw** them at the market._

> 🗡️ Tip: there is no rule for irregulars — make a list and drill the **top 40**. They cover most of what you''ll ever say.

## 🧭 Negatives & questions: did / didn''t + the BASE verb

For negatives and questions, use the helper **did**, and the main verb goes back to its **base form** (no _-ed_, no irregular change):

_I **didn''t go** out. (not ~~didn''t went~~)_
_**Did** you **see** it? — Yes, I **did**. / No, I **didn''t**._

> ⚠️ Trap: the past tense is already carried by **did/didn''t**, so never mark it twice — say _Did you **go**?_, never _~~Did you went?~~_

## ⏳ Words that signal the past

_yesterday · last night / week / year · two days **ago** · in 2010 · when I was young._

> 🏆 Gate cleared! You can now tell any past story — affirmative, negative, and question. Next stop: the **present continuous**, for actions happening right now.', '# 📜 Résumé: The Past Simple

- **Use** — a finished action at a definite past time (_yesterday, last week, in 2015, ago_).
- **was / were** — past of _to be_: I/he/she/it **was**, you/we/they **were**; negatives _wasn''t / weren''t_.
- **Regular verbs** — add **-ed**; spelling: _like → liked_, _study → studied_, _stop → stopped_.
- **Irregular verbs** — memorize them: _go → went, have → had, see → saw, take → took, get → got…_
- **Negative** — _didn''t_ + **base verb** (_I didn''t go_, never _didn''t went_).
- **Questions** — _did_ + subject + **base verb** (_Did you see?_); short answers _Yes, I did / No, I didn''t_.
- ⚠️ The past is carried by **did / didn''t** — never mark it twice (_Did you go?_, not _Did you went?_).', 1)
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

| Subject         | be  | + verb-ing | Example                 |
| --------------- | --- | ---------- | ----------------------- |
| I               | am  | working    | _I **am working**._     |
| he / she / it   | is  | reading    | _She **is reading**._   |
| you / we / they | are | playing    | _They **are playing**._ |

> 🗡️ Quick rule: you **always** need both pieces — the right form of _be_ **and** the _-ing_. _He **is** playing_, never _~~He playing~~_ and never _~~He is play~~_.

## 🛡️ The -ing spelling rules

Most verbs just add **-ing**. Three groups change first:

| Rule                                    | Base | -ing form |
| --------------------------------------- | ---- | --------- |
| most verbs → just add **-ing**          | play | playing   |
| ends in **-e** → drop the _e_           | make | making    |
| short vowel + consonant → **double** it | run  | running   |
| ends in **-ie** → **-ie → -ying**       | lie  | lying     |

_He is **making** dinner. The dog is **running** in the park. She is **studying** for an exam (keep the **y**)._

> ⚠️ Trap: don''t keep the silent _e_ (_makeing_ ✗ → **making**), and don''t forget to double after a short vowel (_runing_ ✗ → **running**). But verbs ending in _-y_ simply add _-ing_: study → **studying**, not _~~studing~~_.

## 🔮 Negatives and questions

To make the **negative**, add **not** to _be_ (usually **isn''t / aren''t**) and keep the _-ing_:

_He **isn''t** working today. They **aren''t** playing._

For **questions**, put _be_ **before** the subject (inversion, just like the verb _to be_):

_**Is** she **working**? **Are** you **listening**?_
_**What are** you **doing**? **Why is** he **crying**?_

Short answers reuse _be_: _**Is** he sleeping? — **Yes, he is.** / **No, he isn''t.**_

## 🧭 Time words decide the tense

The clue is usually a **time expression**. They split into two teams:

| Present continuous (NOW)                        | Present simple (ALWAYS)           |
| ----------------------------------------------- | --------------------------------- |
| now, right now, at the moment                   | always, usually, often, sometimes |
| today, this week, these days                    | every day / week, on Mondays      |
| Look! / Listen! / (it''s happening as you speak) | as a rule, generally, never       |

_**Right now** I **am studying**, but I **usually study** at night._
_**Look!** It **is raining**. It **always rains** in winter here._

> ⚠️ Classic trap: a daily habit takes the **simple**, not the continuous. Say _**Every morning** I **drink** coffee_, never _~~Every morning I am drinking coffee~~_. And a now-action takes the **continuous**: _**Look!** He **is playing**_, not _~~Look! He plays~~_.

## 🧪 Stative verbs stay simple

Some verbs describe a **state**, not an action — feelings, thoughts, the senses, possession. These **stative verbs** are **not** normally used in the continuous, even when you mean _now_:

**like, love, want, need, know, understand, believe, have** (= possess).

_I **want** a coffee._ (not _~~I am wanting~~_)
_She **knows** the answer._ (not _~~She is knowing~~_)
_I **have** two brothers._ (= possess; not _~~I am having two brothers~~_)

> 🗡️ Tip: if a verb names a thought, a feeling, or something you own — keep it **simple**, whatever the moment.

> 🏆 Gate cleared! You can now separate **now** from **always** and choose the right present tense every time. Next stop: the **future** — _going to_ and _will_, for plans and predictions about what hasn''t happened yet.', '# 📜 Résumé: Present Continuous vs Present Simple

- **Two jobs** — present continuous = happening **now** / temporary; present simple = **habits**, routines, general truths.
- **Form (continuous)** — _am / is / are_ + **verb-ing**: _I am working, she is reading, they are playing_. You need **both** pieces.
- **-ing spelling** — _make → making_ (drop _e_), _run → running_ (double consonant), _study → studying_ (keep _y_), _lie → lying_.
- **Negative** — _isn''t / aren''t_ + _-ing_: _He isn''t working_.
- **Questions** — invert _be_ and subject: _Is she working? What are you doing?_; short answers _Yes, she is / No, she isn''t_.
- **Time words decide** — _now, at the moment, Look!, today_ → continuous; _always, usually, every day, on Mondays_ → simple.
- **Stative verbs stay simple** — _like, love, want, need, know, understand, believe, have_ (= possess): say _I want_, not _I am wanting_.
- ⚠️ Don''t put a **habit** in the continuous (_Every morning I drink coffee_, not _am drinking_) or a **now-action** in the simple (_Look! He is playing_, not _plays_).', 2)
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

English gives you two main ways to talk about what hasn''t happened yet: **be going to** and **will**. They are not random twins — each one carries a different message. Learn _when_ to reach for each and your future English will sound natural, not translated.

_I**''m going to** study tonight. — The phone''s ringing; I**''ll** get it._

The first speaker already had a plan. The second decided at that very second. That is the whole battle.

## ⚡ "be going to" — plans and evidence

Use **be going to + base verb** for a **plan or intention decided before now**, and for a **prediction based on what you can see right now** (present evidence).

| Subject         | Form         | Example                             |
| --------------- | ------------ | ----------------------------------- |
| I               | am going to  | _I **am going to** travel in July._ |
| he / she / it   | is going to  | _She **is going to** call you._     |
| you / we / they | are going to | _They **are going to** move house._ |

_I**''m going to** visit my aunt on Sunday._ (a plan I already made)
_Look at those clouds — it**''s going to** rain._ (I can see the evidence)

Negative: **not going to**. Question: invert _be_ → **Are you going to…?**
_He**''s not going to** come. — **Are** you **going to** help?_

## 🛡️ "will" — instant decisions, predictions, promises

Use **will + base verb** for a **decision made at the moment of speaking**, for **predictions, opinions and beliefs**, and for **promises and offers**.

| Use                  | Example                                     |
| -------------------- | ------------------------------------------- |
| instant decision     | _Someone''s at the door — I**''ll** open it._ |
| prediction / opinion | _I think it **will** be cold tomorrow._     |
| promise / offer      | _Don''t worry, I**''ll** help you._           |

The short form is **''ll** (_I''ll, she''ll, we''ll_). Negative: **won''t** (= will not). Question: **Will you…?**
_I **won''t** forget. — **Will** you **be** there?_

> 🗡️ Tip: after **will**, always use the **base verb** with **no "to"**: _I**''ll go**_, never _~~I''ll to go~~_. Same after _going to_: _going to **go**_, never _~~going to goes~~_.

## 🔮 The big contrast: already-decided vs spontaneous

This is the heart of the chapter. Ask yourself one question: **Did I plan this before, or am I deciding now?**

| Situation                            | Use          | Example                                          |
| ------------------------------------ | ------------ | ------------------------------------------------ |
| a plan you already made              | **going to** | _We**''re going to** watch a film tonight._       |
| a decision/offer made right now      | **will**     | _It''s heavy — I**''ll** carry it for you._        |
| prediction from evidence you can see | **going to** | _The car**''s going to** stop; it''s out of fuel._ |
| prediction from opinion/belief       | **will**     | _I think our team **will** win._                 |

_"What are you doing this weekend?" — "I**''m going to** paint my room."_ (planned)
_"I''m thirsty." — "I**''ll** get you some water."_ (offer, decided now)

## 🧭 Don''t double the future

Each future has **one** structure. Never mix them, and never stack two futures together.

> ⚠️ Trap: there is no _~~will going to~~_ and no _~~will goes~~_. Pick **one**: either _going to + base verb_ **or** _will + base verb_. And don''t drop the **be** — say _I **am** going to_, never _~~I going to~~_.

A quick checklist before you speak:

- Plan already made or visible evidence? → **going to** (+ am/is/are, + base verb).
- Deciding now, predicting from belief, promising, offering? → **will** (+ base verb, no _to_).

> 🏆 Gate cleared! You can now point at the future two ways — the planned road with **going to** and the spontaneous road with **will**. Next stop: **comparatives and superlatives**, to say which path is _bigger_, _faster_, and _the best_.', '# 📜 Résumé: Talking About the Future

- **Two futures** — _be going to_ and _will_ carry different meanings; choose by intention, not at random.
- **be going to** — _am / is / are going to_ + **base verb**: a plan decided before now (_I''m going to study tonight_).
- **going to for evidence** — a prediction from what you can see now (_Look at those clouds — it''s going to rain_).
- **will** — _will / ''ll_ + **base verb**: an instant decision made as you speak (_The phone''s ringing — I''ll get it_).
- **will for opinions** — predictions, beliefs, promises and offers (_I think it will be cold_; _I''ll help you_).
- **The contrast** — already-decided plan → **going to**; spontaneous decision/offer/belief → **will**.
- **Forms** — negatives _not going to_ / _won''t_; questions _Are you going to…?_ / _Will you…?_
- ⚠️ After _will_ use the **base verb, no "to"** (_I''ll go_, not _I''ll to go_); never double the future (_~~will going to~~_) and never drop the **be** (_~~I going to~~_).', 3)
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

| Adjective | Comparative (+ than) | Superlative (the …)  |
| --------- | -------------------- | -------------------- |
| tall      | tall**er** than      | **the** tall**est**  |
| fast      | fast**er** than      | **the** fast**est**  |
| happy     | happ**ier** than     | **the** happ**iest** |

_She is **taller than** her brother. He is **the fastest** runner in the class._

## 🛡️ Long adjectives: more and the most

A **long adjective** (two syllables or more — most adjectives that don''t end in **-y**) does **not** add an ending. Put **more** in front for the comparative and **the most** in front for the superlative.

| Adjective | Comparative (+ than)    | Superlative (the …)    |
| --------- | ----------------------- | ---------------------- |
| expensive | **more** expensive than | **the most** expensive |
| difficult | **more** difficult than | **the most** difficult |
| beautiful | **more** beautiful than | **the most** beautiful |

_Gold is **more expensive than** iron. This is **the most difficult** quest of all._

## 🔮 Spelling: small changes that trip everyone

Short adjectives change their spelling before the ending. Learn the three patterns.

| Pattern                                        | Base → forms                           |
| ---------------------------------------------- | -------------------------------------- |
| one short vowel + consonant → double it        | big → big**g**er → the big**g**est     |
| **consonant + y** → **y becomes i**            | happy → happ**i**er → the happ**i**est |
| already ends in **-e** → just add **-r / -st** | nice → nice**r** → the nice**st**      |

_The dragon got **bigger**. This is **the nicest** inn on the road._

## 🧭 The irregular champions

A handful of the most common adjectives ignore every rule. Memorize these — you will use them daily.

| Base | Comparative                | Superlative                 |
| ---- | -------------------------- | --------------------------- |
| good | **better** than            | **the best**                |
| bad  | **worse** than             | **the worst**               |
| far  | **further / farther** than | **the furthest / farthest** |

_Today is **better than** yesterday. That was **the worst** idea of all. The tower is **further** than it looks._

> 🗡️ Tip: a quick way to sort an adjective — count the syllables. **One syllable (or -y)** → use **-er / -est**; **two or more** → use **more / the most**. _Good_, _bad_ and _far_ are the only big exceptions.

> ⚠️ Trap: never **double-mark** the comparison. The ending **-er** and the word **more** do the same job, so you choose one, never both. _~~more taller~~_, _~~more better~~_ and _~~the most tallest~~_ are all wrong — say **taller**, **better**, **the tallest**.

## 🌍 Bonus move: as … as

To say two things are **equal**, frame the adjective with **as … as**; add **not** to say they are not equal.

_She is **as tall as** her brother._ (the same height)
_Silver is **not as expensive as** gold._ (gold is more expensive)

> 🏆 Gate cleared! You can now rank any two heroes — or crown the champion of a whole guild — with short forms, long forms, and the irregulars. Next stop: **quantifiers** — _some, any, much, many, a lot of_ — to say exactly _how much_ and _how many_.', '# 📜 Résumé: Comparatives & Superlatives

- **Two jobs** — the _comparative_ compares **two** things (with _than_); the _superlative_ picks the top of a **group** (with _the_).
- **Short adjectives** (1 syllable, or 2 ending in _-y_) — add **-er** / **the -est**: _taller than_, _the tallest_; _happier than_, _the happiest_.
- **Long adjectives** (2+ syllables) — use **more** / **the most**: _more expensive than_, _the most expensive_. No ending.
- **Spelling** — double the consonant (_big → bigger → biggest_), _y → i_ (_happy → happier → happiest_), keep silent _-e_ (_nice → nicer → nicest_).
- **Irregulars** — _good → better → the best_, _bad → worse → the worst_, _far → further/farther → the furthest/farthest_.
- **as … as** — to say two things are equal (_as tall as_); _not as … as_ for unequal (_not as expensive as_).
- ⚠️ Never double-mark: no _more taller_, no _more better_, no _the most tallest_ — pick **-er/-est** OR **more/most**, never both.
- ⚠️ _than_ (comparison) ≠ _then_ (time); don''t drop **the** before a superlative (_She is the tallest_, not _She is tallest_).', 4)
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

Before you can say _how much_ of something you have, you must know **what kind** of noun it is.

- **Countable nouns** can be counted one by one. They have a plural and can take _a / an_ and a number: _a book, two books, three friends._
- **Uncountable nouns** are seen as a single mass — no plural, no _a / an_, and they take a **singular verb**: _water, money, rice, music, time, information, advice, bread, homework._

_I have **two books** and **a little money**. The **information** **is** useful (not ~~informations are~~)._

> ⚠️ Classic trap: some everyday words are **uncountable** in English even though your language may count them. Never say ~~informations, advices, breads, homeworks~~ — they have **no plural** at all.

## ⚡ some vs any

Both mean "an unspecified amount", but they live in different sentences.

| Use **some**                 | Use **any**                   |
| ---------------------------- | ----------------------------- |
| affirmative sentences        | negatives and questions       |
| _I have **some** money._     | _I don''t have **any** money._ |
| _There are **some** apples._ | _Are there **any** apples?_   |

_She bought **some** bread. — Did she buy **any** bread? — No, she didn''t buy **any**._

> 🗡️ Tip: use **some** in offers and requests even though they are questions — _Would you like **some** tea?_ sounds friendly and expects "yes".

## 🛡️ much vs many vs a lot of

This pair depends entirely on the noun type.

| Quantifier   | Goes with          | Example                            |
| ------------ | ------------------ | ---------------------------------- |
| **many**     | countable (plural) | _**many** friends, **many** books_ |
| **much**     | uncountable        | _**much** time, **much** money_    |
| **a lot of** | **both**           | _**a lot of** friends / money_     |

_Much_ and _many_ are most natural in **negatives and questions**; in affirmatives we usually prefer _a lot of_.

_How **many** books do you read? I don''t have **much** time. She has **a lot of** friends._

> ⚠️ Trap: never put **many** with an uncountable noun (~~many money, many informations~~) or **much** with a plural (~~much books~~). Match the quantifier to the noun.

## 🔮 a few vs a little

Both mean "a small quantity", and again the noun type decides.

- **a few** + countable plural: _a few friends, a few books._
- **a little** + uncountable: _a little milk, a little time._

_We have **a few** eggs and **a little** flour, so we can bake a cake._

> 🗡️ Tip: think _a **few f**riends_ (both start with the same family of countable, plural ideas) and _a **little l**iquid_ — _little_ pairs with the mass nouns like milk, water and time.

## 🧭 how much vs how many

To ask about quantity, mirror the same rule:

- **How many** + countable plural → _How many students are there?_
- **How much** + uncountable → _How much water do you drink?_ / _How much is it?_ (price)

_**How many** brothers do you have? **How much** homework did the teacher give?_

> 🏆 Gate cleared — and this is the **last gate of A2**! With countable vs uncountable nouns and the full quantifier kit (_some/any, much/many, a few/a little, how much/how many_), you can measure anything. You have powered through the whole A2 ladder: past simple, present continuous, the future, comparatives, and now quantity. Next, step into the **Donjon** — the mixed-skills gauntlet where every chapter you have beaten comes back at once.', '# 📜 Résumé: Countable, Uncountable & Quantifiers

- **Countable nouns** — can be counted, have a plural, take _a/an_ and numbers: _a book, two books_.
- **Uncountable nouns** — a single mass, no plural, **singular verb**: _water, money, rice, time, information, advice, bread, homework_.
- ⚠️ No plural on uncountables — never _informations, advices, breads, homeworks_.
- **some / any** — _some_ in affirmatives (_I have some money_); _any_ in negatives & questions (_I don''t have any / Do you have any?_). _Some_ also for offers (_Would you like some tea?_).
- **many** + countable, **much** + uncountable, **a lot of** + both: _many books, much time, a lot of friends_.
- **a few** + countable (_a few books_) vs **a little** + uncountable (_a little milk_).
- **how many** + countable (_How many friends?_) vs **how much** + uncountable (_How much water?_).
- ⚠️ Match the quantifier to the noun — never _many money_, _much books_, _a few money_, or _a little books_.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('ca3b7888-bc66-5ac7-98ec-b55bce3b5678', 'anglais-a2', 'Prepositions of Place and Time', 'Master in/on/at for place and time, basic movement prepositions (to/from/into), and avoid the most common learner errors with prepositions.', '# 🗺️ Prepositions of Place and Time — The Navigator''s Toolkit

> 💡 «One wrong preposition can change everything: "I''ll meet you **in** the station" or "**at** the station"? Knowing this makes you sound natural.»

## 📍 Prepositions of Place: in / on / at

These three prepositions describe **where** something or someone is.

| Preposition | Use                                                        | Examples                                                    |
| ----------- | ---------------------------------------------------------- | ----------------------------------------------------------- |
| **in**      | inside a space (room, city, country, box)                  | _in the room, in London, in France, in a bag_               |
| **on**      | on a surface (floor, wall, table, street)                  | _on the table, on the wall, on a bus, on the second floor_  |
| **at**      | at a specific point or place (address, institution, event) | _at the door, at school, at the bus stop, at 14 Oak Street_ |

_The keys are **in** my bag. — The poster is **on** the wall. — I''ll meet you **at** the station entrance._

> 🗡️ Tip: We say **in bed** (resting), **in a car/taxi**, but **on a bus/train/plane** (public transport you board).

> ⚠️ Trap: Don''t say _~~at the kitchen~~_ or _~~on the box~~_ — use **in the kitchen** (a room) and **in the box** (a container).

## 🕐 Prepositions of Time: in / on / at

The same three words work for **when** — but each with a different time unit.

| Preposition | Use                                      | Examples                                             |
| ----------- | ---------------------------------------- | ---------------------------------------------------- |
| **in**      | months, years, seasons, parts of the day | _in July, in 2023, in summer, in the morning_        |
| **on**      | days and dates                           | _on Monday, on 15th March, on my birthday_           |
| **at**      | clock times, fixed time points           | _at 8 o''clock, at noon, at midnight, at the weekend_ |

_My birthday is **on** 3rd April. — The match starts **at** 7 pm. — It rains a lot **in** December._

> 🗡️ Tip: **at night** (not _in night_). British English: **at the weekend**; American English: **on the weekend**.

> ⚠️ Trap: No preposition before _this, next, last, every_: _**Next** Monday_ (not _~~on next Monday~~_); _**last** week_ (not _~~in last week~~_).

## 🧭 Movement Prepositions: to / from / into

These describe **direction of movement**.

| Preposition | Use                                 | Examples                                                       |
| ----------- | ----------------------------------- | -------------------------------------------------------------- |
| **to**      | movement towards a destination      | _go **to** school, walk **to** the park, come **to** my house_ |
| **from**    | starting point of movement          | _travel **from** Tunis, come **from** work_                    |
| **into**    | movement entering an enclosed space | _walk **into** the room, jump **into** the pool_               |

_She walked **from** the office **to** the bus stop. — He came **into** the kitchen and sat down._

> ⚠️ Trap: Don''t say _~~arrive to~~_ — say **arrive at** (a specific place) or **arrive in** (a town/country): _She arrived **at** the airport. / They arrived **in** Paris._

## 🔴 Common Errors to Avoid

- _~~I am at home in night.~~_ → **I am at home at night.**
- _~~She went to into the garden.~~_ → **She went into the garden.** (_into_ already shows direction)
- _~~We met on the afternoon.~~_ → **We met in the afternoon.**
- _~~He lives in 10 Park Road.~~_ → **He lives at 10 Park Road.** (specific address → _at_)

> 🏆 Gate cleared! You now have the navigator''s map of prepositions. In/on/at for place AND time, plus to/from/into for movement — master these and everyday English clicks into place.', '# 📜 Résumé: Prepositions of Place and Time

- **Place — in**: inside a space (room, city, country, container) — _in the kitchen, in France, in a bag_.
- **Place — on**: on a surface or transport you board — _on the table, on a bus, on the second floor_.
- **Place — at**: at a specific point or address — _at the bus stop, at school, at 14 Oak Street_.
- **Time — in**: months, years, seasons, parts of the day — _in July, in 2023, in the morning_.
- **Time — on**: days and dates — _on Monday, on 15th March, on my birthday_.
- **Time — at**: clock times and fixed points — _at 8 o''clock, at noon, at night, at the weekend_.
- **Movement — to**: towards a destination — _go to school, walk to the park_.
- **Movement — from**: starting point — _travel from Tunis, come from work_.
- **Movement — into**: entering an enclosed space — _walk into the room, jump into the pool_.
- ⚠️ No preposition before _this / next / last / every_: _next Monday_ (not _~~on next Monday~~_).
- ⚠️ **arrive at** a specific place / **arrive in** a town or country — never _arrive to_.
- ⚠️ **at night** (not _~~in night~~_); **in the morning/afternoon/evening** (not _~~on the morning~~_).
- ⚠️ **in bed**, **in a car/taxi**; but **on a bus/train/plane**.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('2c2df23a-93d7-59b4-bcd6-6ffdc67281c9', 'anglais-a2', 'Question Tags and Short Answers', 'Form and use question tags (isn''t it? didn''t you? can''t they?) to check or confirm information, and give short answers (Yes, I do. / No, she didn''t.) — two everyday tools for natural conversation.', '# 🎯 Question Tags and Short Answers — The Conversation Finisher

> 💡 «A native speaker doesn''t always say "Is it?" — they say "It''s cold today, **isn''t it?**" Learn this and every conversation sounds ten times more natural.»

## ❓ What Is a Question Tag?

A **question tag** is a short question added at the end of a statement. It is used to:

- **check** that information is correct: \*You''re from Tunis, **aren''t you?\***
- **invite** the other person to agree: \*It''s a great film, **isn''t it?\***

The rule is simple: **positive statement → negative tag / negative statement → positive tag.**

## 🔧 How to Build a Question Tag

The tag repeats the **auxiliary verb** (or the main verb _be_) from the statement, with the **subject pronoun**.

| Statement               | Tag                |
| ----------------------- | ------------------ |
| _She **is** a doctor,_  | _**isn''t** she?_   |
| _They **are** coming,_  | _**aren''t** they?_ |
| _You **can** swim,_     | _**can''t** you?_   |
| _He **wasn''t** there,_  | _**was** he?_      |
| _They **didn''t** call,_ | _**did** they?_    |

**Present simple / past simple (no auxiliary in the statement):** use _do/does/did_.

| Statement              | Tag                |
| ---------------------- | ------------------ |
| _You **like** coffee,_ | _**don''t** you?_   |
| _She **works** here,_  | _**doesn''t** she?_ |
| _They **went** home,_  | _**didn''t** they?_ |

\*It''s raining outside, **isn''t it?** — You didn''t sleep well, **did you?** — She can drive, **can''t she?\***

> 🗡️ Tip: "I am right, **aren''t I?**" — the tag for _I am_ is **aren''t I** (not _amn''t I_). This is the only irregular tag.

> ⚠️ Trap: Don''t reuse the main verb in the tag. \*She works here, **doesn''t she?\*** (not ~~_works she_~~).

## 🔁 Negative Statements → Positive Tags

When the main clause is **negative**, the tag is **positive** — no _not_, just the auxiliary.

| Negative statement     | Positive tag   |
| ---------------------- | -------------- |
| _He **isn''t** ready,_  | _**is** he?_   |
| _You **can''t** come,_  | _**can** you?_ |
| _They **don''t** know,_ | _**do** they?_ |
| _She **didn''t** call,_ | _**did** she?_ |

\*You haven''t eaten, **have you?** — He can''t drive, **can he?\***

> ⚠️ Trap: A **negative** statement + **positive** tag does NOT mean you expect a negative answer. Intonation decides: rising = genuine question; falling = you already know and want confirmation.

## ✅ Short Answers

A **short answer** echoes the auxiliary from the question — no need to repeat the full verb.

| Question          | Short answer (yes)   | Short answer (no)      |
| ----------------- | -------------------- | ---------------------- |
| _Do you like it?_ | _Yes, I **do**._     | _No, I **don''t**._     |
| _Did she call?_   | _Yes, she **did**._  | _No, she **didn''t**._  |
| _Are they ready?_ | _Yes, they **are**._ | _No, they **aren''t**._ |
| _Can he swim?_    | _Yes, he **can**._   | _No, he **can''t**._    |
| _Is it raining?_  | _Yes, it **is**._    | _No, it **isn''t**._    |

> 🗡️ Tip: Never use the main verb in a short answer. _Do you like football?_ → \*Yes, I **do\***.* (not ~~*Yes, I like*~~). And never answer *Yes, I do.* to a negative question like *Don''t you like it?* — answer the reality: *Yes, I do\* (= I like it).

> ⚠️ Trap: _Is she your teacher?_ → _Yes, she **is**._ (not ~~_Yes, she is be_~~ or ~~_Yes, she''s_~~ — the short answer never uses the contraction alone).

## 🔴 Common Errors to Avoid

- _~~It''s hot today, isn''t it is?~~_ → **It''s hot today, isn''t it?** (no verb after the pronoun in the tag)
- _~~She doesn''t like it, doesn''t she?~~_ → **She doesn''t like it, does she?** (negative → positive tag)
- _~~Do you work here?_ — _Yes, I work._~~\* → **Yes, I do.** (short answer, not the main verb)
- _~~He can swim, can he?~~_ (positive statement → should be negative tag) → **He can swim, can''t he?**

> 🏆 Gate cleared! Question tags = flip the polarity + echo the auxiliary. Short answers = echo the auxiliary, nothing more. These two patterns unlock natural, flowing conversation.', '# 📜 Résumé: Question Tags and Short Answers

- **Question tag rule**: positive statement → negative tag; negative statement → positive tag.
- **Build the tag**: repeat the **auxiliary** (or _be_) + subject pronoun — never the main verb.
  - _She is ready,_ → _isn''t she?_ | _They can''t come,_ → _can they?_
- **No auxiliary in statement?** Use _do/does/did_:
  - _You like it,_ → _don''t you?_ | _She works here,_ → _doesn''t she?_ | _They left,_ → _didn''t they?_
- **Special case**: _I am right,_ → **_aren''t I?_** (the only irregular tag — not _amn''t I_).
- **Short answers**: echo the auxiliary only — no main verb, no contraction alone.
  - _Do you like it?_ → _Yes, I **do**._ / _No, I **don''t**._
  - _Is she ready?_ → _Yes, she **is**._ / _No, she **isn''t**._
  - _Can he swim?_ → _Yes, he **can**._ / _No, he **can''t**._
- ⚠️ Negative → **positive** tag (no _not_): _He doesn''t know,_ → **_does he?_** (not _doesn''t he?_)
- ⚠️ Positive → **negative** tag: _They arrived,_ → **_didn''t they?_** (not _did they?_)
- ⚠️ Short answer never uses the main verb: _Do you work here?_ → **_Yes, I do._** (not _Yes, I work._)
- ⚠️ No contraction-only short answer: _Yes, she is._ (not _~~Yes, she''s.~~_)', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('308ad6a2-e0c8-571a-a2ab-d473a9357085', 'anglais-a2', 'Reading Comprehension: Everyday Texts', 'Read short A2 texts — notices, emails, simple stories — and answer comprehension questions using skim (main idea), scan (find a detail) and context-clue strategies for unknown words.', '# 📖 Reading Comprehension: Everyday Texts — The Scout''s Guide

> 💡 «You don''t have to understand every word. A good reader is a detective — they use clues, structure, and strategy to unlock the meaning.»

## 🔭 Strategy 1 — Skim: Get the Big Picture First

**Skimming** means reading quickly to find the **main topic** without reading every word. Look at:

- The **title** or **subject line**
- The **first sentence** of each paragraph
- Any **key words** repeated several times

_Before you read in detail, ask: "What is this text about?"_

> 🗡️ Tip: Spend about **5 seconds** skimming. You don''t need to understand every sentence — just get the overall topic and tone (positive/negative? formal/informal?).

## 🔍 Strategy 2 — Scan: Find the Detail You Need

**Scanning** means searching for a specific piece of information: a name, a number, a date, a time. You move your eyes quickly over the text until you spot the right word or phrase.

_If the question asks "What time does the shop open?", scan for a number or the word open._

| You need…           | Scan for…                        |
| ------------------- | -------------------------------- |
| A time or date      | numbers, words: Monday / at / on |
| A place             | capital letters, in / at / to    |
| A person''s name     | capital letters at the start     |
| A price or quantity | £ / $ / % or number + noun       |

> ⚠️ Trap: Don''t read the whole text again for every question. **Skim once → scan for each question**. This saves time.

## 🔑 Strategy 3 — Context Clues: Guess Unknown Words

When you meet an unknown word, don''t stop. Look at what **comes before and after** it.

_"He was exhausted after the race, so he sat down and closed his eyes."_
→ _exhausted_ must mean **very tired** (context: sat down, closed his eyes, after a race).

| Clue type        | What to look for                                        |
| ---------------- | ------------------------------------------------------- |
| **Synonym**      | "She was furious, that is, very angry."                 |
| **Contrast**     | "Unlike her noisy sister, Leila was quiet."             |
| **Cause/effect** | "It rained heavily, so the match was cancelled."        |
| **Example**      | "She loves citrus fruits: oranges, lemons, grapefruit." |

> 🗡️ Tip: Even if you guess wrong, you still understand the sentence direction (positive or negative idea?). That is often enough to answer a question.

## 📬 Reading Everyday Texts

At A2 level, you will read short everyday texts. Here are the most common types and what to look for:

| Text type     | What to look for                                       |
| ------------- | ------------------------------------------------------ |
| **Notice**    | rules, times, who can/cannot do something              |
| **Email**     | the reason for writing, the request, the writer''s name |
| **Story**     | who, what happened, when, how the character felt       |
| **Message**   | the main news or request                               |
| **Timetable** | times, days, places, activities                        |

_Example notice:_

> **LIBRARY — IMPORTANT NOTICE**
> _The library will be closed on Saturday 14th June for maintenance. It will reopen on Monday 16th June at 9 am. Members can return books by the drop box outside._

→ Skim: topic = library closure. Scan for details: when closed? 14th June. When reopens? Monday 16th, 9 am.

## 🔴 Common Errors to Avoid

- **Don''t answer from memory** — always go back to the text.
- **Don''t pick the first option that sounds familiar** — distractors often use words from the text with the wrong meaning.
- **Don''t confuse "not mentioned" with "false"** — if the text doesn''t say something, the answer is not false, just unknown.
- **Re-read the question** after choosing — check you answered _what was asked_, not what you assumed.

> 🏆 Gate cleared! Skim → scan → use context clues. Three strategies, infinite texts. Real-world reading is just a quest — find the information, answer the question, move on.', '# 📜 Résumé: Reading Comprehension: Everyday Texts

- **Skim first**: read quickly for the main topic — title, first sentences, repeated key words. Ask "What is this text about?"
- **Scan for details**: move eyes quickly for specific info (names, times, places, numbers) — don''t re-read everything.
- **Context clues for unknown words**: look before and after — synonyms, contrasts, cause/effect, examples.
  - _"He was exhausted… so he sat down"_ → exhausted = very tired.
- **Everyday text types to recognise**:
  - **Notice** → rules, times, who can/cannot do something.
  - **Email** → reason for writing, request, sender''s name.
  - **Story** → who, what, when, how the character felt.
  - **Message** → main news or request.
- ⚠️ Always go back to the text — don''t answer from memory or general knowledge.
- ⚠️ Distractors often use words _from_ the text but with the wrong meaning — re-read carefully.
- ⚠️ "Not mentioned" ≠ false — if the text doesn''t say it, choose accordingly.
- ⚠️ Re-read the question after choosing your answer to confirm you answered what was asked.', 8)
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
  ('0c33fe5a-4c6d-546d-aa01-4d79fbe98ab8', '828b2648-a030-59f8-b7b9-88e35658bf5f', 'anglais-a2', '⭐⭐ Drill: Past Simple', 2, 75, 15, 'practice', 'admin', 5)
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
  ('e9dfb0ec-6829-59a0-8847-a883330459aa', '0c33fe5a-4c6d-546d-aa01-4d79fbe98ab8', 'Complete: "My parents ___ married in 1998."', '[{"id":"a","text":"got"},{"id":"b","text":"getted"},{"id":"c","text":"gets"},{"id":"d","text":"gotten"}]'::jsonb, 'a', 'get is irregular: its past simple is got (My parents got married). There is no form getted. Gets is the present third-person singular. Gotten is a past participle (mainly American English), not the simple past form used here.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('10882f0b-efba-5472-b2b4-5f4772f19876', '0c33fe5a-4c6d-546d-aa01-4d79fbe98ab8', 'Complete: "I ___ up at six, ate breakfast, and left the house."', '[{"id":"a","text":"woke"},{"id":"b","text":"waked"},{"id":"c","text":"wake"},{"id":"d","text":"woken"}]'::jsonb, 'a', 'wake is irregular: its past simple is woke (I woke up at six). Waked is not a standard past form. Wake is the base/present form. Woken is the past participle (have woken), not the simple past.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a52adf51-2ad4-5711-9832-0c523c2b5787', '0c33fe5a-4c6d-546d-aa01-4d79fbe98ab8', 'Complete: "She ___ her bag on the chair and sat down."', '[{"id":"a","text":"putted"},{"id":"b","text":"put"},{"id":"c","text":"puts"},{"id":"d","text":"puted"}]'::jsonb, 'b', 'put is one of the few irregular verbs that looks the same in the present and past: the past simple is also put (She put her bag). Putted and puted are invented forms that do not exist. Puts is the present tense.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e5718e1-ded0-5c5d-b3ff-2da4639a1c25', '0c33fe5a-4c6d-546d-aa01-4d79fbe98ab8', 'Find the INCORRECT sentence.', '[{"id":"a","text":"We didn''t understand the instructions."},{"id":"b","text":"They buyed new shoes last week."},{"id":"c","text":"He wrote a long email yesterday."},{"id":"d","text":"Did you meet them at the airport?"}]'::jsonb, 'b', 'The error is in the second sentence: buy is irregular — its past is bought, not buyed. The other sentences are correct: didn''t + base verb understand, the irregular past wrote, and a correctly formed past question with did + base verb meet.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ac15951-5c1a-5a7e-b9ba-b39528f61a94', '0c33fe5a-4c6d-546d-aa01-4d79fbe98ab8', 'Complete the question: "When ___ you arrive in Tunis?"', '[{"id":"a","text":"do"},{"id":"b","text":"were"},{"id":"c","text":"did"},{"id":"d","text":"was"}]'::jsonb, 'c', 'Past questions with action verbs use Did + subject + base verb: When did you arrive? Do is the present helper. Were and Was are used only for the verb be, not for action verbs like arrive.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f42cbb42-39ab-5720-a2f4-637916028bea', '0c33fe5a-4c6d-546d-aa01-4d79fbe98ab8', 'Choose the sentence that is in the correct Past Simple form.', '[{"id":"a","text":"She didn''t came to the party, but we had fun."},{"id":"b","text":"She didn''t come to the party, but we had fun."},{"id":"c","text":"She not come to the party, but we had fun."},{"id":"d","text":"She didn''t come to the party, but we haved fun."}]'::jsonb, 'b', 'The correct negative is didn''t + base verb (come), and the irregular past of have is had. Only the second option has both right. The first keeps came after didn''t, which doubles the past marking. The third option is missing the auxiliary did. The fourth invents haved instead of using the irregular had.', 6)
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
  ('3ff0815b-c740-5e4e-80cf-c9ebed192025', '236d3b84-54b3-5186-83fe-611b3a86b7e2', 'anglais-a2', '⭐⭐ Drill: Present Continuous', 2, 75, 15, 'practice', 'admin', 5)
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
  ('dfa6adf6-f903-53fe-b774-6c31eaadf2d9', '3ff0815b-c740-5e4e-80cf-c9ebed192025', 'What is the correct -ing form of "sit"?', '[{"id":"a","text":"siting"},{"id":"b","text":"siiting"},{"id":"c","text":"siteing"},{"id":"d","text":"sitting"}]'::jsonb, 'd', 'sit has one short vowel + one final consonant, so we double the t before -ing: sitting. Siting forgets to double the t. Siiting adds an extra vowel. Siteing incorrectly adds an e before -ing.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6828d1bf-7b78-56e6-81cb-3b162fa0a0ce', '3ff0815b-c740-5e4e-80cf-c9ebed192025', 'Complete: "They ___ dinner at the moment, so please don''t disturb them."', '[{"id":"a","text":"have"},{"id":"b","text":"are having"},{"id":"c","text":"is having"},{"id":"d","text":"haveing"}]'::jsonb, 'b', 'At the moment signals an action in progress right now, so use the present continuous. With they the form of be is are: they are having dinner. Is having uses the wrong be for they. Have alone is the simple present. Haveing does not drop the silent e correctly (the correct -ing form is having).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ec0739ca-33c3-595e-a330-d17c39e4948a', '3ff0815b-c740-5e4e-80cf-c9ebed192025', 'Complete: "___ you ___ the new comedy series on TV?"', '[{"id":"a","text":"Do / watch"},{"id":"b","text":"Is / watching"},{"id":"c","text":"Are / watching"},{"id":"d","text":"Are / watch"}]'::jsonb, 'c', 'A present-continuous question is be + subject + -ing verb. With you the form of be is Are: Are you watching? Do + watch would be a present-simple question (for habits). Is + watching uses the singular be for you, which is wrong. Are + watch drops the -ing the continuous needs.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e41ece63-9bd5-54ca-a0d0-5da1af711911', '3ff0815b-c740-5e4e-80cf-c9ebed192025', 'Choose the correct sentence.', '[{"id":"a","text":"I''m not understanding this grammar rule."},{"id":"b","text":"I''m not understand this grammar rule."},{"id":"c","text":"I don''t understand this grammar rule."},{"id":"d","text":"I am not understands this grammar rule."}]'::jsonb, 'c', 'Understand is a stative verb — it names a mental state, not an ongoing action. Stative verbs stay in the present simple even when the situation is happening now: I don''t understand. I''m not understanding wrongly uses the continuous. I''m not understand drops the -ing. I am not understands adds a third-person -s where it does not belong.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('646286bd-541c-5cef-848e-f65ee44da7f1', '3ff0815b-c740-5e4e-80cf-c9ebed192025', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Look — the children are playing in the garden."},{"id":"b","text":"He usually takes the metro to work."},{"id":"c","text":"She is cook lunch for everyone right now."},{"id":"d","text":"We are waiting for the bus at the stop."}]'::jsonb, 'c', 'The error is in the third sentence: the present continuous needs be + -ing, not be + the base verb. The correct form is she is cooking lunch. The first sentence correctly uses are playing for a now-action (Look), the second uses the simple present for a habit (usually), and the fourth correctly uses are waiting for a now-action.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc92b810-c595-540f-ace3-9cc89cbdafae', '3ff0815b-c740-5e4e-80cf-c9ebed192025', 'Complete: "Normally he drives to school, but this week he ___ the train because his car is being repaired."', '[{"id":"a","text":"takes"},{"id":"b","text":"is taking"},{"id":"c","text":"are taking"},{"id":"d","text":"has taken"}]'::jsonb, 'b', 'This week marks a temporary change from the usual routine, so use the present continuous: he is taking the train. Takes would match the habit (normally), but this week signals the exception. Are taking uses the plural be — wrong for he. Has taken is the present perfect, which refers to completed past actions, not an ongoing temporary change.', 6)
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
  ('f809962f-a982-5f28-b722-48c9d35f2865', '6121c3f0-68ee-5aff-9817-4f8d3b282fb8', 'anglais-a2', '⭐⭐ Drill: Future (going to & will)', 2, 75, 15, 'practice', 'admin', 5)
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
  ('c8315512-22e2-5173-8a92-a4a452371226', 'f809962f-a982-5f28-b722-48c9d35f2865', 'Complete: "Look at those two players — they ___ score any minute now!" (evidence from what you see)', '[{"id":"a","text":"will to"},{"id":"b","text":"are going to"},{"id":"c","text":"is going to"},{"id":"d","text":"going to"}]'::jsonb, 'b', 'A prediction based on visible evidence uses be going to: they are going to score. Will to is never correct — will never takes to. Is going to uses the singular be, wrong for they. Going to alone drops the required be (are).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('372f80c2-fc84-5aec-90c1-ce8b62acb33b', 'f809962f-a982-5f28-b722-48c9d35f2865', 'Complete: "A: These bags are very heavy! B: Don''t worry, I ___ carry them for you." (deciding now)', '[{"id":"a","text":"am going to"},{"id":"b","text":"will to"},{"id":"c","text":"going to carry"},{"id":"d","text":"will"}]'::jsonb, 'd', 'An offer or decision made at the moment of speaking uses will + base verb: I will carry them. Am going to suggests a pre-made plan, not a spontaneous offer. Will to adds an incorrect to after will. Going to carry is missing the required be (am).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f67e9449-645e-58a9-b62f-5ad8472ebeee', 'f809962f-a982-5f28-b722-48c9d35f2865', 'Complete: "___ you going to call her, or should I?"', '[{"id":"a","text":"Is"},{"id":"b","text":"Will"},{"id":"c","text":"Are"},{"id":"d","text":"Do"}]'::jsonb, 'c', 'A going-to question inverts the verb be with the subject. With you, the form of be is Are: Are you going to call? Is is for he/she/it, not you. Will would start a different structure (Will you call?). Do is the helper for present simple — it does not go with going to.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e674c12-79cb-5dfc-a8b9-3f5031c3f6a7', 'f809962f-a982-5f28-b722-48c9d35f2865', 'Find the INCORRECT sentence.', '[{"id":"a","text":"They are going to open a new café next month."},{"id":"b","text":"I think she will pass the exam."},{"id":"c","text":"He will going to travel to London next week."},{"id":"d","text":"We won''t be there on time."}]'::jsonb, 'c', 'The error is in the third sentence: will and going to cannot be stacked together. Say either he is going to travel or he will travel. The first sentence correctly uses going to for a plan. The second uses will for an opinion prediction. The fourth correctly uses the negative won''t.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('624c1ee8-e05e-57e0-961e-ff36306c335c', 'f809962f-a982-5f28-b722-48c9d35f2865', 'Complete: "I''ve already chosen my university course. I ___ study computer science."', '[{"id":"a","text":"will"},{"id":"b","text":"am going to"},{"id":"c","text":"going to"},{"id":"d","text":"will to"}]'::jsonb, 'b', 'A plan already decided before the moment of speaking uses be going to: I am going to study. The phrase I''ve already chosen confirms a pre-made decision. Will would suggest a decision made right now, not an earlier one. Going to alone is missing the be (am). Will to adds an incorrect to.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c0da9dc8-2043-5d43-91c4-45befd5b2fd9', 'f809962f-a982-5f28-b722-48c9d35f2865', 'Choose the fully correct sentence.', '[{"id":"a","text":"Will you to help me move this furniture?"},{"id":"b","text":"Are you going help me move this furniture?"},{"id":"c","text":"Will you help me move this furniture?"},{"id":"d","text":"Are you will to help me move this furniture?"}]'::jsonb, 'c', 'A will question is Will + subject + base verb: Will you help? The first option adds a wrong to after will. The second is a going-to question missing to (should be going to help). The fourth mixes are and will, which cannot go together.', 6)
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
  ('c0724d6f-251f-57b3-9043-d309c4ff074a', '72d00d0a-78ad-5435-8450-9fc83f5c11ce', 'anglais-a2', '⭐⭐ Drill: Comparatives & Superlatives', 2, 75, 15, 'practice', 'admin', 5)
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
  ('8212b7ed-3e99-533a-a7fd-cd5273e6fef3', 'c0724d6f-251f-57b3-9043-d309c4ff074a', 'Complete: "The weather in July is ___ than in January here."', '[{"id":"a","text":"more warm"},{"id":"b","text":"warmest"},{"id":"c","text":"warmer"},{"id":"d","text":"the warmest"}]'::jsonb, 'c', 'Warm is a short adjective, so the comparative adds -er: warmer than. More warm wrongly puts more before a short adjective. Warmest and the warmest are superlatives — they do not go with than when comparing two things.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5cda5e8-39e1-50d4-9ca7-e45f56a9fc40', 'c0724d6f-251f-57b3-9043-d309c4ff074a', 'Complete: "This exercise is ___ one in the whole chapter."', '[{"id":"a","text":"more difficult"},{"id":"b","text":"the most difficult"},{"id":"c","text":"difficulter"},{"id":"d","text":"most difficult"}]'::jsonb, 'b', 'In the whole chapter points to the top of a group, so use the superlative with the: the most difficult one. More difficult is the comparative (needs than and two things). Difficulter wrongly adds -er to a long adjective. The superlative must include the, so most difficult alone is incomplete.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d5ef99ab-c6fb-557e-a540-f9d3aaec27fd', 'c0724d6f-251f-57b3-9043-d309c4ff074a', 'Complete: "My sister is bad at singing, but I am ___."', '[{"id":"a","text":"more bad"},{"id":"b","text":"badder"},{"id":"c","text":"the worst"},{"id":"d","text":"worse"}]'::jsonb, 'd', 'Bad is irregular: its comparative is worse (comparing two people). I am worse than my sister. More bad and badder both invent non-existent regular forms. The worst is the superlative and would need in a group, not a direct comparison of two people.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24121150-1cc9-5ea4-8942-3eed1f5c39a5', 'c0724d6f-251f-57b3-9043-d309c4ff074a', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Paris is more beautiful than this town."},{"id":"b","text":"He is the youngest player on the team."},{"id":"c","text":"This bag is more heavier than yours."},{"id":"d","text":"She is the most creative student in the class."}]'::jsonb, 'c', 'The error is in the third sentence: heavy ends in consonant + y, so the comparative is heavier — not more heavier, which double-marks the comparison with both more and -er. The first sentence correctly uses more for a long adjective. The second uses the -est superlative. The fourth uses the most for a long adjective.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a531f411-28b0-5a33-b2da-029673146b04', 'c0724d6f-251f-57b3-9043-d309c4ff074a', 'Complete: "The new library is not ___ large ___ the old one — the old one has more space."', '[{"id":"a","text":"more / than"},{"id":"b","text":"so / then"},{"id":"c","text":"as / as"},{"id":"d","text":"the most / than"}]'::jsonb, 'c', 'To say two things are not equal in size we use not as + adjective + as: not as large as the old one. More / than makes a comparative that cannot follow not in this structure. So / then uses then instead of as, and then is a time word. The most / than mixes a superlative with than, which is wrong.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89a61b11-f39a-5eaf-8fb7-ee5c6e16a57a', 'c0724d6f-251f-57b3-9043-d309c4ff074a', 'Choose the fully correct sentence.', '[{"id":"a","text":"This is the most big country in the world."},{"id":"b","text":"This is the biggest country in the world."},{"id":"c","text":"This is the more big country in the world."},{"id":"d","text":"This is the bigest country in the world."}]'::jsonb, 'b', 'Big is a short adjective ending in consonant-vowel-consonant, so both g''s are doubled for the superlative: the biggest. The most big wrongly uses most with a short adjective. The more big uses the comparative pattern. The bigest has only one g — the doubling rule requires biggest.', 6)
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

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('81a7d66b-1a39-5afa-9a39-64ac86e3a15b', '83aa1163-dcf2-5f5b-89ee-833725ca1832', 'anglais-a2', '⭐⭐ Drill: Quantifiers', 2, 75, 15, 'practice', 'admin', 5)
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
  ('7e001ec5-db56-521a-8c7c-77be590f44d4', '81a7d66b-1a39-5afa-9a39-64ac86e3a15b', 'Complete: "Can I have ___ water, please?"', '[{"id":"a","text":"any"},{"id":"b","text":"many"},{"id":"c","text":"a few"},{"id":"d","text":"some"}]'::jsonb, 'd', 'In polite requests and offers we use some even though it is a question: Can I have some water? Any is more common in neutral questions (Do you have any water?), but it does not fit the polite request tone. Many and a few go only with countable nouns — water is uncountable.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7ab0ae1-774d-5f08-88f9-d1084ddaae13', '81a7d66b-1a39-5afa-9a39-64ac86e3a15b', 'Complete: "There are ___ students in the library — maybe five or six."', '[{"id":"a","text":"a few"},{"id":"b","text":"much"},{"id":"c","text":"a little"},{"id":"d","text":"any"}]'::jsonb, 'a', 'Students is a countable plural, so a small number is a few students. Much and a little go with uncountable nouns. Any fits negatives and questions — not an affirmative count of five or six.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8b84f43-d799-587d-ba64-ab723ed8c875', '81a7d66b-1a39-5afa-9a39-64ac86e3a15b', 'Complete: "I''m sorry, there ___ seats left for the concert."', '[{"id":"a","text":"aren''t some"},{"id":"b","text":"aren''t any"},{"id":"c","text":"isn''t many"},{"id":"d","text":"aren''t much"}]'::jsonb, 'b', 'After a negative (aren''t) and with a countable plural (seats), we use any: there aren''t any seats left. Some belongs in affirmatives, not negatives. Isn''t many mismatches singular isn''t with the plural seats. Much goes with uncountable nouns — seats are countable.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0136d4ad-070c-5298-bd0b-f7956cd16081', '81a7d66b-1a39-5afa-9a39-64ac86e3a15b', 'Choose the sentence that is correct.', '[{"id":"a","text":"He has many money in his wallet."},{"id":"b","text":"Do you have much friends in this city?"},{"id":"c","text":"She ate a little biscuits before dinner."},{"id":"d","text":"We have a lot of work to finish today."}]'::jsonb, 'd', 'A lot of works with both countable and uncountable nouns, so a lot of work is correct. Many money is wrong because money is uncountable (use much or a lot of money). Much friends is wrong because friends is countable (use many friends). A little biscuits is wrong because biscuits are countable (use a few biscuits).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5e91a2b-1fbd-5049-a357-ce227c1f28d5', '81a7d66b-1a39-5afa-9a39-64ac86e3a15b', 'Find the INCORRECT sentence.', '[{"id":"a","text":"She has a few minutes to spare."},{"id":"b","text":"There isn''t much sugar in the bowl."},{"id":"c","text":"They didn''t give us any informations."},{"id":"d","text":"We need a little more time, please."}]'::jsonb, 'c', 'The error is in the third sentence: information is uncountable and never has a plural — there is no form informations. The correct sentence is they didn''t give us any information. The first uses a few correctly with the countable minutes. The second uses much correctly with the uncountable sugar. The fourth uses a little correctly with the uncountable time.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c8e2cd4-843e-53e9-bde1-7872d075c471', '81a7d66b-1a39-5afa-9a39-64ac86e3a15b', 'Complete: "___ of the students passed the test — only three out of twenty."', '[{"id":"a","text":"Few"},{"id":"b","text":"Much"},{"id":"c","text":"A little"},{"id":"d","text":"A lot"}]'::jsonb, 'a', 'Few (without a) means not many and carries a negative meaning — only three out of twenty is indeed very few. Students is a countable plural, so few is correct here. Much and a little go with uncountable nouns. A lot of would mean a large number, which contradicts three out of twenty.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1fb21b23-9789-5655-b2fe-2e9de98536c2', 'ca3b7888-bc66-5ac7-98ec-b55bce3b5678', 'anglais-a2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('48cf1208-d25b-56d3-8ba3-fa6417161633', '1fb21b23-9789-5655-b2fe-2e9de98536c2', 'Complete: "The cat is sleeping ___ the sofa."', '[{"id":"a","text":"in"},{"id":"b","text":"at"},{"id":"c","text":"on"},{"id":"d","text":"into"}]'::jsonb, 'c', 'We use on for surfaces: the cat is on the sofa (a flat surface). "in" would mean inside the sofa, "at" marks a specific point (not a surface), and "into" shows movement entering a space, not a resting position.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51a3463c-2043-5b01-8888-50b1ac20ea3f', '1fb21b23-9789-5655-b2fe-2e9de98536c2', 'Complete: "My sister''s birthday is ___ 20th June."', '[{"id":"a","text":"in"},{"id":"b","text":"on"},{"id":"c","text":"at"},{"id":"d","text":"by"}]'::jsonb, 'b', 'We use on with dates and days: on 20th June. "in" is for months and years (in June, in 2023), "at" is for clock times and fixed points (at noon), and "by" means not later than — a different idea.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('267ce76a-49e2-58f5-9384-af3fc8556934', '1fb21b23-9789-5655-b2fe-2e9de98536c2', 'Complete: "The meeting starts ___ 9 o''clock."', '[{"id":"a","text":"on"},{"id":"b","text":"in"},{"id":"c","text":"at"},{"id":"d","text":"from"}]'::jsonb, 'c', 'We use at for clock times: at 9 o''clock. "on" is for days and dates, "in" is for months, years and parts of the day, and "from" marks a starting point of movement, not a clock time.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bcbcf788-05f5-5f39-ab7d-d5a84df69d14', '1fb21b23-9789-5655-b2fe-2e9de98536c2', 'Complete: "She walked ___ the room and closed the door."', '[{"id":"a","text":"to"},{"id":"b","text":"at"},{"id":"c","text":"in"},{"id":"d","text":"into"}]'::jsonb, 'd', '"into" shows movement entering an enclosed space: she walked into the room. "to" would need a separate destination (walked to school), "at" marks a specific point without movement, and "in" shows position, not entry.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5eb06c5-c5b1-5388-a491-e2e43492d5cc', '1fb21b23-9789-5655-b2fe-2e9de98536c2', 'Find the INCORRECT sentence.', '[{"id":"a","text":"He lives at 5 Baker Street."},{"id":"b","text":"We arrived in Paris at midnight."},{"id":"c","text":"I''ll see you on next Friday."},{"id":"d","text":"They are on the bus."}]'::jsonb, 'c', 'The error is (c): no preposition is used before next/last/this/every — say "next Friday", not "on next Friday". The other sentences are correct: at a specific address, arrived in a city, at midnight, and on a bus (public transport).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('769ecc3e-864b-55c6-870d-8cdf24bbab11', 'ca3b7888-bc66-5ac7-98ec-b55bce3b5678', 'anglais-a2', '⭐ Practice: In, On, At (Place & Time)', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d0bf53b7-6f40-5d9d-aa39-f4a14e514692', '769ecc3e-864b-55c6-870d-8cdf24bbab11', 'Complete: "My books are ___ the shelf."', '[{"id":"a","text":"on"},{"id":"b","text":"at"},{"id":"c","text":"in"},{"id":"d","text":"into"}]'::jsonb, 'a', 'A shelf is a surface, so we use on: the books are on the shelf. "in" would mean inside the shelf (a closed space), "at" marks a specific point (not a surface), and "into" describes movement entering a space.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3909cafc-6249-5114-bcb7-47b320bb06bb', '769ecc3e-864b-55c6-870d-8cdf24bbab11', 'Complete: "The film starts ___ 8 pm."', '[{"id":"a","text":"in"},{"id":"b","text":"on"},{"id":"c","text":"at"},{"id":"d","text":"from"}]'::jsonb, 'c', 'Clock times take at: the film starts at 8 pm. "in" is for months and years, "on" is for days and dates, and "from" marks a starting point of movement, not a clock time.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18a6405b-6ec5-54ea-9ffb-5ebb5b5cbbbe', '769ecc3e-864b-55c6-870d-8cdf24bbab11', 'Complete: "She lives ___ a small village in the south."', '[{"id":"a","text":"at"},{"id":"b","text":"on"},{"id":"c","text":"into"},{"id":"d","text":"in"}]'::jsonb, 'd', 'We use in for enclosed spaces, towns and countries: she lives in a small village. "at" marks a specific point or address, "on" marks a surface, and "into" shows entering movement.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('41bb041d-e7cb-5bdd-bfc7-5b3d5c8a1c2c', '769ecc3e-864b-55c6-870d-8cdf24bbab11', 'Complete: "The concert is ___ Saturday evening."', '[{"id":"a","text":"in"},{"id":"b","text":"at"},{"id":"c","text":"on"},{"id":"d","text":"by"}]'::jsonb, 'c', 'Days of the week take on: on Saturday evening. "in" is for months and years (in July), "at" is for clock times (at noon), and "by" means not later than — a different idea.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('459bb446-ad2b-5e30-9d37-f4747a6e6508', '769ecc3e-864b-55c6-870d-8cdf24bbab11', 'Complete: "I''ll meet you ___ the bus stop."', '[{"id":"a","text":"in"},{"id":"b","text":"at"},{"id":"c","text":"on"},{"id":"d","text":"into"}]'::jsonb, 'b', 'A bus stop is a specific point, so we use at: I''ll meet you at the bus stop. "in" is for spaces you are inside (in a room), "on" is for surfaces, and "into" describes movement entering a space.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5acab18d-af1d-5842-a648-720e1115fb89', '769ecc3e-864b-55c6-870d-8cdf24bbab11', 'Complete: "My grandmother was born ___ 1955."', '[{"id":"a","text":"on"},{"id":"b","text":"at"},{"id":"c","text":"from"},{"id":"d","text":"in"}]'::jsonb, 'd', 'Years take in: born in 1955. "on" is for days and dates (on 3rd April), "at" is for clock times (at noon), and "from" shows a starting point of movement.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a218ba57-5504-5972-b614-0b365324eb4f', 'ca3b7888-bc66-5ac7-98ec-b55bce3b5678', 'anglais-a2', '⭐⭐ Review: Place, Time & Movement', 2, 75, 15, 'practice', 'admin', 2)
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
  ('de154505-e56c-526b-ae89-d6fcda4a6998', 'a218ba57-5504-5972-b614-0b365324eb4f', 'Complete: "He arrived ___ the airport two hours early."', '[{"id":"a","text":"to"},{"id":"b","text":"in"},{"id":"c","text":"at"},{"id":"d","text":"into"}]'::jsonb, 'c', 'The verb arrive takes at for specific places: he arrived at the airport. "arrive to" is a common error — never say arrive to. "in" is correct for arriving in a city or country, but an airport is a specific facility → at.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e8d20483-ae14-5faf-b43b-43772941277f', 'a218ba57-5504-5972-b614-0b365324eb4f', 'Complete: "The children jumped ___ the swimming pool."', '[{"id":"a","text":"in"},{"id":"b","text":"into"},{"id":"c","text":"on"},{"id":"d","text":"to"}]'::jsonb, 'b', '"into" shows movement entering an enclosed space: jumped into the pool. "in" describes a position (they are in the pool already), "to" points at a distant destination, and "on" is for surfaces.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5243244e-9818-5f09-90e5-501cc9da5f11', 'a218ba57-5504-5972-b614-0b365324eb4f', 'Complete: "I usually read ___ the morning before work."', '[{"id":"a","text":"at"},{"id":"b","text":"on"},{"id":"c","text":"in"},{"id":"d","text":"by"}]'::jsonb, 'c', 'Parts of the day (morning, afternoon, evening) take in: in the morning. "at" is for clock times and fixed points (at night is an exception), "on" is for days, and "by" means not later than.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('238ccef9-22b5-55ef-9afb-4776b134b83b', 'a218ba57-5504-5972-b614-0b365324eb4f', 'Find the INCORRECT sentence.', '[{"id":"a","text":"She works at a hospital in the city centre."},{"id":"b","text":"We go to school on foot every day."},{"id":"c","text":"I am in the bus right now."},{"id":"d","text":"He is sitting on the floor."}]'::jsonb, 'c', 'The error is (c): public transport you board uses on, not in — I am on the bus. The correct sentences are: at a hospital (specific institution), on foot (manner), and on the floor (surface).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6e3cf808-de27-5f42-95d3-4d995f9a34ab', 'a218ba57-5504-5972-b614-0b365324eb4f', 'Complete: "They travelled ___ London ___ Paris by train."', '[{"id":"a","text":"from / to"},{"id":"b","text":"at / in"},{"id":"c","text":"in / at"},{"id":"d","text":"to / from"}]'::jsonb, 'a', 'from marks the starting point and to marks the destination: travelled from London to Paris. Swapping them (d) would reverse the journey. "at/in" and "in/at" describe positions, not movement between two places.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ef1c917-4f0d-5a52-9c3c-c96fbc617721', 'a218ba57-5504-5972-b614-0b365324eb4f', 'Complete: "There''s a great market here ___ summer, especially ___ weekends."', '[{"id":"a","text":"in / at"},{"id":"b","text":"at / on"},{"id":"c","text":"on / in"},{"id":"d","text":"in / on"}]'::jsonb, 'd', 'Seasons take in (in summer) and days/recurring times take on or at (on weekends / at the weekend). So the answer is in summer … on weekends. The other combinations mix up the wrong prepositions for each time category.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('35da4b80-c7e0-5c36-9fc9-56c13b45bf97', 'ca3b7888-bc66-5ac7-98ec-b55bce3b5678', 'anglais-a2', '⚔️ Chapter Boss ⭐⭐⭐: Prepositions of Place and Time', 3, 120, 30, 'boss', 'admin', 3)
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
  ('4b702ee1-571e-5d9d-b627-3974a2bb604d', '35da4b80-c7e0-5c36-9fc9-56c13b45bf97', 'Complete: "The note is ___ the door."', '[{"id":"a","text":"in"},{"id":"b","text":"into"},{"id":"c","text":"on"},{"id":"d","text":"at"}]'::jsonb, 'c', 'A note stuck on a surface uses on: the note is on the door. "in" means inside, "into" shows entry movement, and "at" marks a specific location point (at the door = near the entrance, not attached to its surface).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b94e1b4c-7e87-5f8a-9cf6-97552fa8be08', '35da4b80-c7e0-5c36-9fc9-56c13b45bf97', 'Find the INCORRECT sentence.', '[{"id":"a","text":"My exam is on 12th May."},{"id":"b","text":"Call me at midnight."},{"id":"c","text":"She was born in March."},{"id":"d","text":"I''ll see you on next Monday."}]'::jsonb, 'd', 'The error is (d): no preposition is used before next/last/this/every — say "next Monday", not "on next Monday". The other sentences correctly use on a date (12th May), at a fixed time point (midnight), and in a month (March).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8216c40-63b0-5310-8e42-2b7d03db91db', '35da4b80-c7e0-5c36-9fc9-56c13b45bf97', 'Complete: "She walked quickly ___ the building without stopping."', '[{"id":"a","text":"into"},{"id":"b","text":"at"},{"id":"c","text":"to"},{"id":"d","text":"in"}]'::jsonb, 'a', '"into" shows movement entering an enclosed space: she walked into the building. "to" points to a destination from outside but does not confirm entry, "in" describes position inside (not entry), and "at" is a static point.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0baa5ffc-292a-5c47-9ab4-de47c739d760', '35da4b80-c7e0-5c36-9fc9-56c13b45bf97', 'Complete: "He lives ___ 34 Green Lane."', '[{"id":"a","text":"on"},{"id":"b","text":"in"},{"id":"c","text":"at"},{"id":"d","text":"by"}]'::jsonb, 'c', 'Specific addresses take at: he lives at 34 Green Lane. "on" is used for streets without a number (on Green Lane — you''re on the street), "in" is for areas and cities (in London), and "by" means beside.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a24326e-fe30-59b9-af01-0432a819a43f', '35da4b80-c7e0-5c36-9fc9-56c13b45bf97', 'Complete: "The train leaves ___ noon. We must arrive ___ the station before that."', '[{"id":"a","text":"in / at"},{"id":"b","text":"at / at"},{"id":"c","text":"on / in"},{"id":"d","text":"at / in"}]'::jsonb, 'b', 'Clock times and fixed points both take at: the train leaves at noon, and we must arrive at the station. "in" is for months/years/parts of the day, and "on" is for days and dates — neither fits clock times or specific locations here.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8d9e7b1-aff6-5d40-b63f-13ffcaa85882', '35da4b80-c7e0-5c36-9fc9-56c13b45bf97', 'Find the INCORRECT sentence.', '[{"id":"a","text":"They came from Italy last summer."},{"id":"b","text":"She arrived in the city at midnight."},{"id":"c","text":"I''m sleeping in the sofa tonight."},{"id":"d","text":"He put the keys on the table."}]'::jsonb, 'c', 'The error is (c): a sofa is a surface, so we sleep on the sofa, not "in the sofa" (which would mean inside it). The correct sentences use from for origin, in a city (larger area) and at for clock time, and on a surface for the keys.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a96228f1-afe4-507c-bc06-069588dbb977', 'ca3b7888-bc66-5ac7-98ec-b55bce3b5678', 'anglais-a2', '👑 Elite Challenge ⭐⭐⭐⭐: Prepositions of Place and Time', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('0e555c1c-3aa5-5509-ac64-ad06b7beb4f6', 'a96228f1-afe4-507c-bc06-069588dbb977', 'Read: "Leila has a meeting at 10 o''clock on Thursday. She works in the city centre, at a law firm on King Street. After work, she goes to the gym."
Which sentence is TRUE?', '[{"id":"a","text":"Leila''s meeting is in the morning on Friday."},{"id":"b","text":"Her office is at 10 King Street."},{"id":"c","text":"She works at a law firm in the city centre."},{"id":"d","text":"She goes into the gym before work."}]'::jsonb, 'c', 'The text says she works "in the city centre, at a law firm" — (c) correctly restates both. The meeting is on Thursday (not Friday), her address is on King Street (not a number given), and she goes to the gym after work, not before.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb3ed2ea-c8d8-58a9-805f-0f60fb2e28d7', 'a96228f1-afe4-507c-bc06-069588dbb977', 'Find the INCORRECT sentence.', '[{"id":"a","text":"I usually travel by bus on weekdays."},{"id":"b","text":"She arrived to Paris late at night."},{"id":"c","text":"The book is on the desk, next to the lamp."},{"id":"d","text":"We''ll meet at the entrance at 6 pm."}]'::jsonb, 'b', 'The error is (b): arrive is followed by in (for a city) or at (for a specific place), never arrive to — she arrived in Paris. (a) correctly uses on weekdays, (c) correctly uses on the desk (surface), and (d) correctly uses at the entrance and at 6 pm.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19d78e4b-3646-5c69-be07-f22777792935', 'a96228f1-afe4-507c-bc06-069588dbb977', 'Complete: "Please put your phone ___ your bag during the exam."', '[{"id":"a","text":"on"},{"id":"b","text":"at"},{"id":"c","text":"into"},{"id":"d","text":"in"}]'::jsonb, 'd', 'A bag is a container, so we use in: put your phone in your bag. "into" would suggest actively dropping it inside (movement entering), which is less natural here for a simple resting state. "on" is for surfaces, and "at" marks a point.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b12308a-0e99-510c-a2cd-b1742b141853', 'a96228f1-afe4-507c-bc06-069588dbb977', 'Complete: "The festival takes place ___ the main square ___ July every year."', '[{"id":"a","text":"in / at"},{"id":"b","text":"at / on"},{"id":"c","text":"in / in"},{"id":"d","text":"at / in"}]'::jsonb, 'd', 'The main square is a specific named location → at the main square; a month takes in → in July. So at / in is correct. "in the main square" suggests an enclosed area, but a public square uses at. "on / in" and "in / at" don''t match the location + month pattern.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4154ec58-3678-506f-951c-91b28a4519c8', 'a96228f1-afe4-507c-bc06-069588dbb977', 'Find the INCORRECT sentence.', '[{"id":"a","text":"She flew from Cairo to London last night."},{"id":"b","text":"He''s on his way to the hospital."},{"id":"c","text":"We arrived in the airport at midnight."},{"id":"d","text":"The meeting room is on the second floor."}]'::jsonb, 'c', 'The error is (c): an airport is a specific place, so use arrived at the airport, not "in the airport". "in" is for arriving in a city or country (arrived in London). (a) correctly uses from/to for a journey, (b) uses on his way to (fixed phrase), and (d) uses on the second floor (floor = surface level).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce1369ab-cd0e-589c-bf5f-7884eec5089e', 'a96228f1-afe4-507c-bc06-069588dbb977', 'Complete: "Could you put those files ___ the cabinet, please? ___ the second drawer, ___ the left."', '[{"id":"a","text":"into / In / on"},{"id":"b","text":"on / At / in"},{"id":"c","text":"at / On / at"},{"id":"d","text":"in / In / at"}]'::jsonb, 'a', 'You put files into a cabinet (movement entering), they go in the second drawer (inside a compartment), and on the left (surface/side). "into / In / on" fits all three. "on / At / in" doesn''t work — you don''t put files on a cabinet here, and "At" is wrong for a drawer.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('559ccfa4-5113-5eb1-ae42-8839bdd0486d', 'ca3b7888-bc66-5ac7-98ec-b55bce3b5678', 'anglais-a2', '⭐⭐ Drill: Prepositions of Place & Time', 2, 75, 15, 'practice', 'admin', 5)
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
  ('d8e7279f-3de0-5566-a269-0a9087102a2d', '559ccfa4-5113-5eb1-ae42-8839bdd0486d', 'Complete: "The doctor''s appointment is ___ Monday ___ 11 am."', '[{"id":"a","text":"in / at"},{"id":"b","text":"on / in"},{"id":"c","text":"at / on"},{"id":"d","text":"on / at"}]'::jsonb, 'd', 'Days of the week take on (on Monday) and clock times take at (at 11 am). So the pair is on / at. In / at swaps in for on, which is wrong for a day. On / in uses in for a clock time, which is wrong. At / on reverses the two prepositions.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87968325-2a83-55cd-ade1-a4615a9a2e5d', '559ccfa4-5113-5eb1-ae42-8839bdd0486d', 'Complete: "My cousin lives ___ a small flat ___ the third floor."', '[{"id":"a","text":"in / on"},{"id":"b","text":"on / in"},{"id":"c","text":"at / on"},{"id":"d","text":"in / at"}]'::jsonb, 'a', 'We live in an enclosed space (in a flat) and floors are surfaces or levels (on the third floor). So the pair is in / on. On / in reverses them wrongly. At / on uses at for a flat instead of in. In / at uses at for a floor instead of on.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1644f94-22b9-54de-bdac-3c13728ed4d1', '559ccfa4-5113-5eb1-ae42-8839bdd0486d', 'Complete: "She threw the letter ___ the bin."', '[{"id":"a","text":"on"},{"id":"b","text":"at"},{"id":"c","text":"into"},{"id":"d","text":"in"}]'::jsonb, 'c', 'Into shows movement entering an enclosed space: she threw the letter into the bin. On is for surfaces. At marks a specific point but doesn''t confirm entry. In describes a resting position already inside — throw requires the entry movement into.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17b5f9a2-bad9-5a37-9f4a-942a602fd2d5', '559ccfa4-5113-5eb1-ae42-8839bdd0486d', 'Find the INCORRECT sentence.', '[{"id":"a","text":"We usually have lunch at noon."},{"id":"b","text":"He was born in December 1990."},{"id":"c","text":"She always goes home in foot."},{"id":"d","text":"I''ll see you at the main entrance."}]'::jsonb, 'c', 'The error is in the third sentence: the correct phrase for travelling without a vehicle is on foot, not in foot. We say go on foot the same way we say on a bike or on the bus. At noon correctly uses at for a fixed time. In December 1990 correctly uses in for a month and year. At the main entrance correctly uses at for a specific meeting point.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6431b59-04f2-5bd4-b126-6855b45ea648', '559ccfa4-5113-5eb1-ae42-8839bdd0486d', 'Complete: "The class starts ___ the morning and finishes ___ 1 pm."', '[{"id":"a","text":"in / in"},{"id":"b","text":"at / at"},{"id":"c","text":"in / at"},{"id":"d","text":"at / in"}]'::jsonb, 'c', 'Parts of the day (morning, afternoon, evening) take in: in the morning. Clock times take at: at 1 pm. So the pair is in / at. In / in uses in for a clock time, which is wrong. At / at uses at for a part of the day, which is wrong. At / in reverses the two prepositions.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43b057de-af33-54e4-a805-c4514a5ba9d7', '559ccfa4-5113-5eb1-ae42-8839bdd0486d', 'Choose the fully correct sentence.', '[{"id":"a","text":"He arrived to the hotel at midnight."},{"id":"b","text":"She sat in the sofa and watched TV."},{"id":"c","text":"They left from Paris at 7 am on Monday."},{"id":"d","text":"We arrived in Rome on a Tuesday afternoon."}]'::jsonb, 'd', 'Only the fourth sentence is fully correct: in Rome (arrived in a city), on a Tuesday (day of the week), afternoon (part of the day — no preposition needed before it as it is part of on a Tuesday afternoon). The first wrongly uses arrived to instead of arrived at or in. The second uses in the sofa instead of on the sofa (a surface). The third adds a wrong from before Paris — we simply leave at a time, from is used for origin in journey expressions like from Paris to London.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2846d3b6-cbd0-5a0d-b12b-ef2549bf7c06', '2c2df23a-93d7-59b4-bcd6-6ffdc67281c9', 'anglais-a2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('86e6fa2c-8451-515d-a43f-2719b82b7fe7', '2846d3b6-cbd0-5a0d-b12b-ef2549bf7c06', 'Complete: "It''s a lovely day, ___ it?"', '[{"id":"a","text":"is"},{"id":"b","text":"doesn''t"},{"id":"c","text":"wasn''t"},{"id":"d","text":"isn''t"}]'::jsonb, 'd', 'Positive statement (It''s) → negative tag: isn''t it? "is" would be a positive tag, which is wrong here. "doesn''t" is for main verbs, not for the verb be. "wasn''t" is past tense — the statement is in the present.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3245ca57-e9ab-5238-9988-db1ab69b55ec', '2846d3b6-cbd0-5a0d-b12b-ef2549bf7c06', 'Complete: "You didn''t call me, ___ you?"', '[{"id":"a","text":"didn''t"},{"id":"b","text":"did"},{"id":"c","text":"don''t"},{"id":"d","text":"do"}]'::jsonb, 'b', 'Negative statement (didn''t call) → positive tag without not: did you? "didn''t" would repeat the negative (wrong rule — negative → positive tag). "don''t/do" are present tense, but the statement is in the past.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5725bff7-4ede-5a84-b7fc-a41601f457f1', '2846d3b6-cbd0-5a0d-b12b-ef2549bf7c06', 'Complete: "She works at the library, ___ she?"', '[{"id":"a","text":"isn''t"},{"id":"b","text":"doesn''t"},{"id":"c","text":"didn''t"},{"id":"d","text":"does"}]'::jsonb, 'b', 'Positive present-simple statement with no auxiliary → use does/doesn''t: she works → doesn''t she? "isn''t" uses the wrong auxiliary (be, not do), "didn''t" is past tense, and "does" would be a positive tag after a positive statement — wrong.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2d501dd-045c-57be-87f7-51786652cf71', '2846d3b6-cbd0-5a0d-b12b-ef2549bf7c06', 'Give the correct short answer: "Are they ready?" — "___, they are."', '[{"id":"a","text":"Yes"},{"id":"b","text":"No"},{"id":"c","text":"Sure"},{"id":"d","text":"Right"}]'::jsonb, 'a', 'The short answer confirms that they are ready: Yes, they are. The auxiliary are echoes the question. "No, they are" is contradictory. "Sure" and "Right" are informal fillers, not grammatical short answers — the formal structure is Yes/No + auxiliary.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('158c646b-732d-5bda-8e24-220c33d900c1', '2846d3b6-cbd0-5a0d-b12b-ef2549bf7c06', 'Find the INCORRECT question tag.', '[{"id":"a","text":"He can drive, can''t he?"},{"id":"b","text":"They don''t know, do they?"},{"id":"c","text":"She left early, wasn''t she?"},{"id":"d","text":"I am late, aren''t I?"}]'::jsonb, 'c', 'The error is (c): "left" is a past-simple main verb, so the tag uses did/didn''t — She left early, didn''t she? — not "wasn''t she" (which belongs to the verb be). The other tags are correct: can''t he (positive → negative), do they (negative → positive), and aren''t I (the special tag for I am).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7758e2ca-fce5-566b-bf94-b3f99dfbfbe6', '2c2df23a-93d7-59b4-bcd6-6ffdc67281c9', 'anglais-a2', '⭐ Practice: Building Question Tags', 1, 50, 10, 'practice', 'admin', 1)
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
  ('cc1e9530-5f95-549d-bf98-7c00a503adce', '7758e2ca-fce5-566b-bf94-b3f99dfbfbe6', 'Complete: "You are a student, ___ you?"', '[{"id":"a","text":"aren''t"},{"id":"b","text":"isn''t"},{"id":"c","text":"don''t"},{"id":"d","text":"are"}]'::jsonb, 'a', 'Positive statement (you are) → negative tag: aren''t you? "isn''t" is for he/she/it, not you. "don''t" belongs to main verbs, not the verb be. "are" would be a positive tag, which is wrong after a positive statement.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02cea6a7-05c5-5dd6-a4ec-684361d2275f', '7758e2ca-fce5-566b-bf94-b3f99dfbfbe6', 'Complete: "They can''t swim, ___ they?"', '[{"id":"a","text":"can''t"},{"id":"b","text":"can"},{"id":"c","text":"do"},{"id":"d","text":"aren''t"}]'::jsonb, 'b', 'Negative statement (can''t) → positive tag: can they? "can''t" would repeat the negative — wrong rule. "do" is used for main verbs, not for the modal can. "aren''t" uses the wrong auxiliary (be instead of can).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6c550b1c-609c-5ca7-a51c-c61f2ed8e3da', '7758e2ca-fce5-566b-bf94-b3f99dfbfbe6', 'Complete: "He doesn''t like fish, ___ he?"', '[{"id":"a","text":"doesn''t"},{"id":"b","text":"isn''t"},{"id":"c","text":"does"},{"id":"d","text":"is"}]'::jsonb, 'c', 'Negative statement (doesn''t like) → positive tag: does he? "doesn''t" would repeat the negative. "is/isn''t" use the wrong auxiliary — the main verb is like, so the tag uses do/does, not be.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c665cc40-f950-5a5a-ade5-b8cb74625f26', '7758e2ca-fce5-566b-bf94-b3f99dfbfbe6', 'Complete: "She called you last night, ___ she?"', '[{"id":"a","text":"doesn''t"},{"id":"b","text":"wasn''t"},{"id":"c","text":"did"},{"id":"d","text":"didn''t"}]'::jsonb, 'd', 'Positive past-simple statement (called) → negative past tag: didn''t she? The main verb called uses did/didn''t in the tag. "doesn''t" is present tense. "wasn''t" belongs to the verb be. "did" would be a positive tag — wrong after a positive statement.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('034a8538-2ec1-5bbf-ae7e-1a8789e11930', '7758e2ca-fce5-566b-bf94-b3f99dfbfbe6', 'Complete: "You haven''t seen this film, ___ you?"', '[{"id":"a","text":"haven''t"},{"id":"b","text":"didn''t"},{"id":"c","text":"have"},{"id":"d","text":"has"}]'::jsonb, 'c', 'Negative statement (haven''t seen) → positive tag: have you? "haven''t" repeats the negative. "didn''t" is past simple — but the statement uses the present perfect (haven''t). "has" is for he/she/it, not you.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94d195af-5fb0-5c75-aa51-cbc31147cbb5', '7758e2ca-fce5-566b-bf94-b3f99dfbfbe6', 'Complete: "I am the last one here, ___ I?"', '[{"id":"a","text":"amn''t"},{"id":"b","text":"am not"},{"id":"c","text":"isn''t"},{"id":"d","text":"aren''t"}]'::jsonb, 'd', 'The special tag for I am is aren''t I — there is no "amn''t I" in standard English. "am not" is the full form, which is not used in tags. "isn''t" uses he/she/it, not I.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('21228e92-c390-502c-ab8c-a19f0e3868d5', '2c2df23a-93d7-59b4-bcd6-6ffdc67281c9', 'anglais-a2', '⭐⭐ Review: Tags & Short Answers', 2, 75, 15, 'practice', 'admin', 2)
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
  ('b118a00a-466d-529e-b714-9a04b7b7a2cd', '21228e92-c390-502c-ab8c-a19f0e3868d5', 'Choose the correct short answer: "Do you enjoy cooking?" — "___"', '[{"id":"a","text":"Yes, I enjoy."},{"id":"b","text":"Yes, I do."},{"id":"c","text":"Yes, I am."},{"id":"d","text":"Yes, I cook."}]'::jsonb, 'b', 'A short answer echoes the auxiliary from the question: Do you…? → Yes, I do. Never use the main verb in a short answer (not "I enjoy" or "I cook"), and "I am" answers a be-question, not a do-question.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a55f08b3-158a-5f96-933b-ea556e605bd7', '21228e92-c390-502c-ab8c-a19f0e3868d5', 'Complete: "The shops were open yesterday, ___ they?"', '[{"id":"a","text":"weren''t"},{"id":"b","text":"didn''t"},{"id":"c","text":"don''t"},{"id":"d","text":"wasn''t"}]'::jsonb, 'a', 'Positive past statement with were (plural) → negative tag: weren''t they? "didn''t" is used for main verb past-simple, not the verb be. "don''t" is present tense. "wasn''t" is singular (he/she/it) — the subject is they, so use weren''t.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6908b798-4a8b-5702-b926-fd38567a9f0c', '21228e92-c390-502c-ab8c-a19f0e3868d5', 'Choose the correct short answer: "Can she drive?" — "No, ___."', '[{"id":"a","text":"she can''t."},{"id":"b","text":"she doesn''t."},{"id":"c","text":"she isn''t."},{"id":"d","text":"she didn''t."}]'::jsonb, 'a', 'Can she…? → No, she can''t. The auxiliary can is echoed as can''t in the negative short answer. "doesn''t" uses do, not can. "isn''t" and "didn''t" use the wrong auxiliary entirely.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6abdeb63-5a53-5311-b510-6c940628d51e', '21228e92-c390-502c-ab8c-a19f0e3868d5', 'Find the INCORRECT question tag.', '[{"id":"a","text":"You weren''t there, were you?"},{"id":"b","text":"He plays football, doesn''t he?"},{"id":"c","text":"We should go now, shouldn''t we?"},{"id":"d","text":"They finished on time, don''t they?"}]'::jsonb, 'd', 'The error is (d): finished is past simple, so the tag uses didn''t, not don''t — They finished on time, didn''t they? The other tags are correct: weren''t you (negative → positive), doesn''t he (present simple main verb), and shouldn''t we (modal should).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21d3403c-2bc5-51da-b0f9-132936ea3112', '21228e92-c390-502c-ab8c-a19f0e3868d5', 'Complete: "That was a great match, ___ it?"', '[{"id":"a","text":"wasn''t"},{"id":"b","text":"isn''t"},{"id":"c","text":"didn''t"},{"id":"d","text":"weren''t"}]'::jsonb, 'a', 'Positive past-tense statement with was (singular it) → negative past tag: wasn''t it? "isn''t" is present tense. "didn''t" is for main verbs, not the verb be. "weren''t" is plural (they) — the subject here is it (singular).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb0c321a-cc5e-5741-aefa-ae01518acd40', '21228e92-c390-502c-ab8c-a19f0e3868d5', 'Choose the correct short answer: "Did they arrive on time?" — "Yes, ___."', '[{"id":"a","text":"they arrived."},{"id":"b","text":"they were."},{"id":"c","text":"they did."},{"id":"d","text":"they do."}]'::jsonb, 'c', 'Did they…? → Yes, they did. The auxiliary did is echoed in the short answer. "they arrived" uses the main verb — not the short-answer pattern. "they were" uses be, not do. "they do" is present tense, but the question is past.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('eb3dd319-cefc-5512-9e5e-6d26c217f410', '2c2df23a-93d7-59b4-bcd6-6ffdc67281c9', 'anglais-a2', '⚔️ Chapter Boss ⭐⭐⭐: Question Tags and Short Answers', 3, 120, 30, 'boss', 'admin', 3)
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
  ('834a8a76-96bd-538f-a49f-8382b6692191', 'eb3dd319-cefc-5512-9e5e-6d26c217f410', 'Complete: "You have already eaten, ___ you?"', '[{"id":"a","text":"have"},{"id":"b","text":"haven''t"},{"id":"c","text":"didn''t"},{"id":"d","text":"don''t"}]'::jsonb, 'b', 'Positive present-perfect statement (have eaten) → negative tag: haven''t you? "have" would be a positive tag — wrong rule. "didn''t" is past simple, but the statement uses the present perfect (have). "don''t" belongs to main verbs in the present, not the present perfect.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83f9481a-0810-52de-93e3-d59445e57a83', 'eb3dd319-cefc-5512-9e5e-6d26c217f410', 'Find the INCORRECT sentence.', '[{"id":"a","text":"\"Is she at home?\" — \"Yes, she is.\""},{"id":"b","text":"\"Do they play tennis?\" — \"No, they don''t.\""},{"id":"c","text":"\"Did he call?\" — \"Yes, he did call.\""},{"id":"d","text":"\"Can you help me?\" — \"Yes, I can.\""}]'::jsonb, 'c', 'The error is (c): a short answer does not include the main verb — say "Yes, he did." not "Yes, he did call." The other short answers correctly echo only the auxiliary: she is, they don''t, and I can.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f15e48a0-ad38-5db5-a0d0-490881910e2c', 'eb3dd319-cefc-5512-9e5e-6d26c217f410', 'Complete: "Nobody told you, ___ they?"', '[{"id":"a","text":"didn''t"},{"id":"b","text":"did"},{"id":"c","text":"don''t"},{"id":"d","text":"weren''t"}]'::jsonb, 'b', 'Nobody is a negative subject, so the statement is negative → the tag is positive: did they? "didn''t" would make it a double negative. "don''t" is present tense. "weren''t" uses the wrong auxiliary — told is a past-simple main verb, so the tag uses did.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7cfaea87-0de2-58d3-b40b-c9c94ee0ddfb', 'eb3dd319-cefc-5512-9e5e-6d26c217f410', 'Complete: "Let''s go for a walk, ___ we?"', '[{"id":"a","text":"shall"},{"id":"b","text":"will"},{"id":"c","text":"don''t"},{"id":"d","text":"won''t"}]'::jsonb, 'a', 'The fixed tag for Let''s… (a suggestion) is shall we: Let''s go, shall we? This is an idiomatic exception — Let''s is short for Let us, and the tag is always shall we, not "will we" or "won''t we".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b77f353-5833-5e33-a765-e54964d9abcd', 'eb3dd319-cefc-5512-9e5e-6d26c217f410', 'Find the INCORRECT sentence.', '[{"id":"a","text":"She didn''t enjoy the party, did she?"},{"id":"b","text":"I am next, aren''t I?"},{"id":"c","text":"You must leave now, mustn''t you?"},{"id":"d","text":"Nothing works here, doesn''t it?"}]'::jsonb, 'd', 'The error is (d): nothing is a negative subject, so the statement is already negative → the tag must be positive: Nothing works here, does it? not "doesn''t it". The other tags are correct: did she (negative → positive), aren''t I (special I am tag), and mustn''t you (positive → negative).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7e4d5d2-d516-51cc-82d7-d2aee834a186', 'eb3dd319-cefc-5512-9e5e-6d26c217f410', 'Your friend says: "You''ve never been to Japan, have you?" You HAVE been to Japan. What do you say?', '[{"id":"a","text":"No, I haven''t."},{"id":"b","text":"Yes, I have."},{"id":"c","text":"Yes, I have been."},{"id":"d","text":"No, I have."}]'::jsonb, 'b', 'Regardless of the tag''s polarity, your answer reflects reality: you HAVE been → Yes, I have. Never say "No" if the fact is positive. "Yes, I have been" adds the main verb — short answers don''t include the participle. "No, I have" contradicts itself.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3b2a3c3d-4c95-5947-b263-1d6102d7c52a', '2c2df23a-93d7-59b4-bcd6-6ffdc67281c9', 'anglais-a2', '👑 Elite Challenge ⭐⭐⭐⭐: Question Tags and Short Answers', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('a13fd8a3-e9e8-5436-9660-207e5c730edf', '3b2a3c3d-4c95-5947-b263-1d6102d7c52a', 'Read: "Sara has just finished her exam. She thinks it went well, but she isn''t sure."
She turns to a classmate and says: "That wasn''t too hard, ___ it?"', '[{"id":"a","text":"is"},{"id":"b","text":"was"},{"id":"c","text":"wasn''t"},{"id":"d","text":"isn''t"}]'::jsonb, 'b', 'Negative past statement (wasn''t) → positive past tag: was it? "is/isn''t" are present tense — but the exam just finished (past). "wasn''t" repeats the negative. "was" correctly gives the positive past tag after a negative statement.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1923bd2f-3da2-5a50-847d-aa724ecd14fc', '3b2a3c3d-4c95-5947-b263-1d6102d7c52a', 'Find the INCORRECT exchange.', '[{"id":"a","text":"\"Have you seen my keys?\" — \"No, I haven''t.\""},{"id":"b","text":"\"Does your sister live here?\" — \"Yes, she does.\""},{"id":"c","text":"\"Were they at the party?\" — \"Yes, they were.\""},{"id":"d","text":"\"Did you enjoy it?\" — \"Yes, I enjoyed.\""}]'::jsonb, 'd', 'The error is (d): a short answer uses only the auxiliary — say "Yes, I did." not "Yes, I enjoyed." (which uses the main verb). The other exchanges are correct: I haven''t (present perfect echo), she does (present simple echo), they were (past be echo).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3f9d448-19a2-5a44-ab3a-6d4229fd7461', '3b2a3c3d-4c95-5947-b263-1d6102d7c52a', 'Complete: "Everyone knows the answer, ___ they?"', '[{"id":"a","text":"don''t"},{"id":"b","text":"doesn''t"},{"id":"c","text":"do"},{"id":"d","text":"isn''t"}]'::jsonb, 'a', 'Everyone sounds singular but takes a plural pronoun (they) in question tags: Everyone knows → don''t they? "doesn''t" uses a singular pronoun (he/she/it), but the tag pronoun for everyone is they. "do" would be a positive tag. "isn''t" uses the wrong auxiliary.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f59943f3-9cdd-516b-93d2-2817b2230899', '3b2a3c3d-4c95-5947-b263-1d6102d7c52a', 'Complete the dialogue: "You must be tired after that flight." — "___, I am. It was a long journey."', '[{"id":"a","text":"Well"},{"id":"b","text":"No"},{"id":"c","text":"Sure"},{"id":"d","text":"Yes"}]'::jsonb, 'd', 'The speaker confirms they are tired, so the answer is Yes, I am. This is a short-answer structure echoing the verb be. "No" contradicts the follow-up sentence. "Well" and "Sure" are informal fillers — not the grammatical short-answer Yes/No pattern.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d59b78ad-2379-5615-9279-c5d5880fb8d8', '3b2a3c3d-4c95-5947-b263-1d6102d7c52a', 'Find the INCORRECT question tag.', '[{"id":"a","text":"Nothing has changed, has it?"},{"id":"b","text":"Somebody called, did they?"},{"id":"c","text":"Let''s stop here, shall we?"},{"id":"d","text":"Everyone left early, didn''t they?"}]'::jsonb, 'b', 'The error is (b): somebody is a positive subject, so the statement is positive → the tag must be negative: Somebody called, didn''t they? — not "did they" (which would be a positive tag). (a) Nothing is negative → positive has it ✓; (c) Let''s → shall we ✓; (d) positive past → negative didn''t they ✓.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e555c279-c294-58ac-9498-8987e20f6c0f', '3b2a3c3d-4c95-5947-b263-1d6102d7c52a', 'Read: "Karim: You used to play basketball, didn''t you?
Leila: Yes, ___ — every weekend in school."
Choose the correct short answer.', '[{"id":"a","text":"I used to."},{"id":"b","text":"I play."},{"id":"c","text":"I did."},{"id":"d","text":"I was."}]'::jsonb, 'c', 'The question uses didn''t you (past simple tag), so the short answer echoes did: Yes, I did. "I used to" adds extra words — short answers use only the auxiliary. "I play" uses the present. "I was" uses be, not do.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8ae4d96c-0b6a-59f7-99ca-cc387b3c0206', '2c2df23a-93d7-59b4-bcd6-6ffdc67281c9', 'anglais-a2', '⭐⭐ Drill: Question Tags', 2, 75, 15, 'practice', 'admin', 5)
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
  ('f6cd47a2-af29-5ca8-bbfc-243679b2acae', '8ae4d96c-0b6a-59f7-99ca-cc387b3c0206', 'Complete: "The food was delicious, ___ it?"', '[{"id":"a","text":"wasn''t"},{"id":"b","text":"isn''t"},{"id":"c","text":"weren''t"},{"id":"d","text":"didn''t"}]'::jsonb, 'a', 'Positive past statement with was (singular it) → negative past tag: wasn''t it? Isn''t is present tense. Weren''t is plural (they were). Didn''t is the tag for past-simple action verbs, not for the verb be.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0dcea926-7443-522d-bbda-9a5d16244f14', '8ae4d96c-0b6a-59f7-99ca-cc387b3c0206', 'Complete: "We should leave soon, ___ we?"', '[{"id":"a","text":"don''t"},{"id":"b","text":"shouldn''t"},{"id":"c","text":"won''t"},{"id":"d","text":"aren''t"}]'::jsonb, 'b', 'Positive modal statement (should) → negative modal tag with the same modal: shouldn''t we? Don''t belongs to main verbs, not to the modal should. Won''t uses a different modal (will). Aren''t uses the verb be, which is wrong here.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('daea48a6-bbf3-5d6f-9cf9-5c7e1839e43d', '8ae4d96c-0b6a-59f7-99ca-cc387b3c0206', 'Complete: "She doesn''t speak Arabic, ___ she?"', '[{"id":"a","text":"doesn''t"},{"id":"b","text":"isn''t"},{"id":"c","text":"does"},{"id":"d","text":"did"}]'::jsonb, 'c', 'Negative present-simple statement (doesn''t) → positive tag: does she? Doesn''t would repeat the negative, which breaks the rule. Isn''t uses the wrong auxiliary — the main verb is speak, so the tag uses do/does, not be. Did is past tense, but the statement is in the present.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a7ec926-c9f2-5692-9d6b-f95306330738', '8ae4d96c-0b6a-59f7-99ca-cc387b3c0206', 'Find the INCORRECT question tag.', '[{"id":"a","text":"You can play the guitar, can''t you?"},{"id":"b","text":"He wasn''t at home, was he?"},{"id":"c","text":"They will come to dinner, won''t they?"},{"id":"d","text":"She studied hard, doesn''t she?"}]'::jsonb, 'd', 'The error is in the fourth sentence: studied is a past-simple verb, so the tag must use did/didn''t — She studied hard, didn''t she? Doesn''t is present tense and does not match the past studied. The first three are all correct: can''t you (positive modal → negative), was he (negative past be → positive), won''t they (positive will → negative).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c80243b-c44f-573f-bad3-8e88cda69bc6', '8ae4d96c-0b6a-59f7-99ca-cc387b3c0206', 'Your teacher says: "You have done the homework, haven''t you?" You HAVE done it. What do you reply?', '[{"id":"a","text":"Yes, I have done."},{"id":"b","text":"No, I have."},{"id":"c","text":"Yes, I have."},{"id":"d","text":"Yes, I did."}]'::jsonb, 'c', 'The reality is that you did do the homework, so the answer is affirmative: Yes, I have — echoing the present perfect auxiliary. Yes, I have done adds the main verb, which short answers never include. No, I have contradicts itself. Yes, I did uses the wrong tense (simple past instead of present perfect).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f1aa005-91bf-5b00-b3df-01a7bc009499', '8ae4d96c-0b6a-59f7-99ca-cc387b3c0206', 'Complete: "Nobody told us about the meeting, ___ they?"', '[{"id":"a","text":"did"},{"id":"b","text":"didn''t"},{"id":"c","text":"do"},{"id":"d","text":"were"}]'::jsonb, 'a', 'Nobody is a negative word, so the statement is already negative → the tag must be positive: did they? Didn''t would create a double negative, which is the wrong tag rule. Do is present tense. Were uses the verb be — but told is a past-simple action verb, so the tag uses did.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bab4adf5-961b-5821-a1b3-805fdfe17dd8', '308ad6a2-e0c8-571a-a2ab-d473a9357085', 'anglais-a2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('55dd64c4-ad42-510d-a510-6b39a348d832', 'bab4adf5-961b-5821-a1b3-805fdfe17dd8', 'What does "skimming" mean in reading?', '[{"id":"a","text":"Reading quickly to get the main topic."},{"id":"b","text":"Reading every word very slowly."},{"id":"c","text":"Translating the text word by word."},{"id":"d","text":"Searching for a specific detail."}]'::jsonb, 'a', 'Skimming means reading quickly to get the overall main topic — not every word, not a translation, and not hunting for one specific detail (that is scanning). It gives the big picture before you read closely.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0058b759-e051-5277-beb0-34e89ce1fe16', 'bab4adf5-961b-5821-a1b3-805fdfe17dd8', 'You need to find what time a shop opens in a long text. The best strategy is:', '[{"id":"a","text":"Read the whole text twice."},{"id":"b","text":"Scan for a number or the word \"open\"."},{"id":"c","text":"Skim the first sentence only."},{"id":"d","text":"Guess from the title."}]'::jsonb, 'b', 'Scanning means moving your eyes quickly to find a specific detail — here a time (number) or the word open. Reading the whole text twice wastes time. Skimming gives the topic, not a specific time. Guessing from the title is unreliable.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13ba66d5-e0c6-568c-a6e5-21f96cdefe10', 'bab4adf5-961b-5821-a1b3-805fdfe17dd8', 'Read: "She was famished after the long hike, so she ate three sandwiches."
What does "famished" mean?', '[{"id":"a","text":"Very happy."},{"id":"b","text":"Very tired."},{"id":"c","text":"Very thirsty."},{"id":"d","text":"Very hungry."}]'::jsonb, 'd', 'The context clue is the effect: she ate three sandwiches. This points to hunger, not happiness, tiredness, or thirst. Famished means extremely hungry — the cause (long hike) and the effect (eating three sandwiches) confirm this.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a758fa2-e953-5a7d-b884-617963921991', 'bab4adf5-961b-5821-a1b3-805fdfe17dd8', 'Read: "NOTICE: The gym will be closed on 5th December for a deep clean. Normal hours resume on 6th December."
On which date does the gym reopen?', '[{"id":"a","text":"5th December."},{"id":"b","text":"4th December."},{"id":"c","text":"7th December."},{"id":"d","text":"6th December."}]'::jsonb, 'd', 'Scan for the word resume or reopen: "Normal hours resume on 6th December." The gym is closed on 5th December (not the reopening date). 4th and 7th December are not mentioned in the notice.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb93e953-c700-5117-ab8a-73d5c3846eb2', 'bab4adf5-961b-5821-a1b3-805fdfe17dd8', 'A question about a text says: "Why did Tom leave early?"
The text does NOT mention Tom leaving. The best answer is:', '[{"id":"a","text":"Tom left because he was tired."},{"id":"b","text":"The text says Tom never leaves early."},{"id":"c","text":"This information is not given in the text."},{"id":"d","text":"Tom left at midnight."}]'::jsonb, 'c', 'If the text does not mention something, the correct answer is that it is not given — not that it is false, and not a guess. "Not mentioned" is different from "false". Making up a time (midnight) or a reason (tired) means answering from imagination, not from the text.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5e7ed9ea-d718-5846-92b6-0b1a38d83023', '308ad6a2-e0c8-571a-a2ab-d473a9357085', 'anglais-a2', '⭐ Practice: Notices & Short Messages', 1, 50, 10, 'practice', 'admin', 1)
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
  ('eb936c96-9535-501a-b8c3-4d8dd6ea9953', '5e7ed9ea-d718-5846-92b6-0b1a38d83023', 'Read the notice:
"SWIMMING POOL — NOTICE
The pool will be closed on Tuesday 10th for maintenance.
It will reopen on Wednesday 11th at 7 am.
Sorry for the inconvenience."

On which day does the pool reopen?', '[{"id":"a","text":"Wednesday 11th."},{"id":"b","text":"Tuesday 10th."},{"id":"c","text":"Thursday 12th."},{"id":"d","text":"Monday 9th."}]'::jsonb, 'a', 'Scan for reopen or reopen date: "reopen on Wednesday 11th at 7 am". Tuesday 10th is the day it is closed, not the reopening. Thursday 12th and Monday 9th are not mentioned in the notice.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8200187-70a9-5451-8d0c-38ea70d4bf3c', '5e7ed9ea-d718-5846-92b6-0b1a38d83023', 'Read the message:
"Hi Leila,
Can you bring the blue folder to the meeting tomorrow?
I left it on your desk this morning.
Thanks, Sara"

What does Sara want Leila to do?', '[{"id":"a","text":"Find a blue folder."},{"id":"b","text":"Come to Sara''s office."},{"id":"c","text":"Bring a blue folder to the meeting."},{"id":"d","text":"Buy a new folder."}]'::jsonb, 'c', 'The direct request is: "Can you bring the blue folder to the meeting?" Sara already left it on Leila''s desk, so Leila doesn''t need to find it. There is no mention of going to Sara''s office or buying anything.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbd97f1f-bf82-5e14-a6f3-eeb0139ed2ff', '5e7ed9ea-d718-5846-92b6-0b1a38d83023', 'Read the notice:
"CAFÉ LUNA — OPEN HOURS
Monday–Friday: 7 am – 8 pm
Saturday: 9 am – 6 pm
Closed on Sundays."

What time does Café Luna open on Saturday?', '[{"id":"a","text":"7 am."},{"id":"b","text":"8 pm."},{"id":"c","text":"9 am."},{"id":"d","text":"6 pm."}]'::jsonb, 'c', 'Scan for Saturday in the timetable: Saturday opens at 9 am and closes at 6 pm. 7 am is the weekday opening time. 8 pm is the weekday closing time. 6 pm is Saturday''s closing time, not the opening time.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('020bf4b9-d3b5-53fc-8f29-57ff4ba61427', '5e7ed9ea-d718-5846-92b6-0b1a38d83023', 'Read the email:
"Dear Mr Green,
I am writing to confirm your appointment on Friday 20th at 3 pm.
Please bring your ID.
Best regards,
The City Clinic"

What must Mr Green bring to the appointment?', '[{"id":"a","text":"A form."},{"id":"b","text":"Money."},{"id":"c","text":"His medical records."},{"id":"d","text":"His ID."}]'::jsonb, 'd', 'The email says: "Please bring your ID." A form, money, and medical records are not mentioned. Scan for the word bring to find the answer directly.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d511d64d-3924-5beb-90e9-7664472a6ad5', '5e7ed9ea-d718-5846-92b6-0b1a38d83023', 'Read the notice:
"LIBRARY RULES
- No food or drinks inside.
- Books must be returned within 3 weeks.
- Please speak quietly."

A student brings a bottle of water to the library. According to the notice, this is:', '[{"id":"a","text":"Allowed, because water is not food."},{"id":"b","text":"Not mentioned in the notice."},{"id":"c","text":"Not allowed, because drinks are prohibited."},{"id":"d","text":"Allowed, if you speak quietly."}]'::jsonb, 'c', 'The rule says "No food or drinks inside." A bottle of water is a drink, so it is not allowed. The rule covers both food and drinks — water is a drink. Speaking quietly is a separate rule and does not change the food/drink policy.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00326ff7-4584-5f8f-b01d-72052acb7867', '5e7ed9ea-d718-5846-92b6-0b1a38d83023', 'Read the text message:
"Hey! I''m running late. Start without me — I''ll be there in 20 minutes. Order me a coffee please! — Karim"

What does Karim ask his friend to do?', '[{"id":"a","text":"Wait for him outside."},{"id":"b","text":"Order a coffee for him."},{"id":"c","text":"Cancel the meeting."},{"id":"d","text":"Call him back."}]'::jsonb, 'b', 'Karim''s request is: "Order me a coffee please!" He also says to start without him (not to wait). He doesn''t ask anyone to cancel or to call. Scan for the imperative verb (order, start) to find the requests.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8408e2c1-21ed-5c60-8158-8923c6ef542f', '308ad6a2-e0c8-571a-a2ab-d473a9357085', 'anglais-a2', '⭐⭐ Review: Emails & Simple Stories', 2, 75, 15, 'practice', 'admin', 2)
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
  ('3a3608ee-6263-5111-96be-d565962adfc4', '8408e2c1-21ed-5c60-8158-8923c6ef542f', 'Read the email:
"Hi Nadia,
I''m organising a small birthday dinner for Mum next Saturday at 7 pm.
Could you come and help me cook? We need to keep it a surprise!
Love, Hana"

Why is Hana writing to Nadia?', '[{"id":"a","text":"To invite Nadia to a restaurant."},{"id":"b","text":"To ask Nadia to buy a birthday cake."},{"id":"c","text":"To ask Nadia to help cook for their mum''s surprise dinner."},{"id":"d","text":"To tell Nadia about Mum''s favourite recipe."}]'::jsonb, 'c', 'The main request is: "Could you come and help me cook?" It is a home dinner (not a restaurant). Buying a cake is not mentioned. No recipe is shared — the email just asks for help cooking a surprise dinner for their mum.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f09daf22-6a13-5293-b06f-daa3820e1be0', '8408e2c1-21ed-5c60-8158-8923c6ef542f', 'Read the story:
"Tom woke up late. He ran to the bus stop, but the bus had already left. He was annoyed, but then he saw his neighbour, Mrs Chen, in her car. She smiled and offered him a lift."

How did Tom get to his destination?', '[{"id":"a","text":"He got a lift from his neighbour."},{"id":"b","text":"He took the bus."},{"id":"c","text":"He walked."},{"id":"d","text":"He called a taxi."}]'::jsonb, 'a', 'The text says Mrs Chen "offered him a lift" — so Tom got a lift from his neighbour. He missed the bus (it had already left), there is no mention of walking or a taxi.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('54451583-7665-5291-b32a-52a0c558a276', '8408e2c1-21ed-5c60-8158-8923c6ef542f', 'Read the story:
"Tom woke up late. He ran to the bus stop, but the bus had already left. He was annoyed, but then he saw his neighbour, Mrs Chen, in her car. She smiled and offered him a lift."

How did Tom feel after missing the bus?', '[{"id":"a","text":"Happy."},{"id":"b","text":"Frightened."},{"id":"c","text":"Relaxed."},{"id":"d","text":"Annoyed."}]'::jsonb, 'd', 'The text says "He was annoyed" after the bus left. He felt better when Mrs Chen helped him, but his immediate feeling was annoyance. Happy, frightened, and relaxed are not mentioned as his reaction to missing the bus.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea5e76a1-da62-5e83-b477-4c36b78db067', '8408e2c1-21ed-5c60-8158-8923c6ef542f', 'Read the notice:
"SPORTS CENTRE — SPECIAL OFFER
Join this month and get the first two weeks FREE.
Monthly fee after that: £25.
Offer ends 30th June.
Call us on 0800 111 222 to sign up."

How much does a member pay per month after the free trial?', '[{"id":"a","text":"Nothing — it is always free."},{"id":"b","text":"£25."},{"id":"c","text":"£30."},{"id":"d","text":"£50."}]'::jsonb, 'b', 'Scan for the monthly fee: "Monthly fee after that: £25." The first two weeks are free, but the ongoing cost is £25. £30 and £50 are not mentioned. "Always free" contradicts the monthly fee stated in the notice.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6144993-8667-5a22-9d71-28ea3d921a44', '8408e2c1-21ed-5c60-8158-8923c6ef542f', 'Read the text:
"Zara is studying for her exams. She is very diligent — she studies for four hours every day and never misses a class."

What does "diligent" mean? Use context clues.', '[{"id":"a","text":"Very lazy."},{"id":"b","text":"Very nervous."},{"id":"c","text":"Very hardworking."},{"id":"d","text":"Very unhappy."}]'::jsonb, 'c', 'The context clues are the examples: four hours of study every day and never misses a class. This behaviour is the opposite of lazy and has nothing to do with being nervous or unhappy. Diligent means hardworking and consistent.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eedfc518-bcca-54bf-821d-958bdd4aa41e', '8408e2c1-21ed-5c60-8158-8923c6ef542f', 'Read the email:
"Dear Students,
The class trip to the science museum is on Thursday 8th.
Please bring your student card and £5 for lunch.
We leave at 9 am from the main gate.
Mr Salim"

Which sentence is TRUE according to the email?', '[{"id":"a","text":"The trip is on Friday."},{"id":"b","text":"Students must pay £10 for lunch."},{"id":"c","text":"The bus leaves at 9 am from the main gate."},{"id":"d","text":"Students should bring their student card and £5."}]'::jsonb, 'd', 'The email says: "bring your student card and £5 for lunch" — (d) is true. The trip is on Thursday (not Friday). The lunch cost is £5 (not £10). The email says "we leave at 9 am from the main gate" — it mentions leaving, not specifically a bus, so (c) adds an assumption.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cef5393a-cdbb-5a7a-a263-5d569e8abbe0', '308ad6a2-e0c8-571a-a2ab-d473a9357085', 'anglais-a2', '⚔️ Chapter Boss ⭐⭐⭐: Reading Comprehension: Everyday Texts', 3, 120, 30, 'boss', 'admin', 3)
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
  ('c82da18d-3a81-51a4-b943-1e8bc12ac124', 'cef5393a-cdbb-5a7a-a263-5d569e8abbe0', 'Read the email:
"Dear Mr Larbi,
Thank you for your application. We would like to invite you for an interview on Monday 15th at 10 am at our office (3rd floor, City Tower).
Please reply to confirm you can attend.
Kind regards,
HR Team — Nova Tech"

What is the purpose of this email?', '[{"id":"a","text":"To offer Mr Larbi a job."},{"id":"b","text":"To invite Mr Larbi to a job interview."},{"id":"c","text":"To reject Mr Larbi''s application."},{"id":"d","text":"To ask Mr Larbi to send his CV."}]'::jsonb, 'b', 'The email says "invite you for an interview" — not a job offer, not a rejection, and not a request for a CV. Skim the first two lines: the purpose is an invitation to an interview.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d120d0b-5e43-5cba-a33a-aa6965ff7673', 'cef5393a-cdbb-5a7a-a263-5d569e8abbe0', 'Read the email:
"Dear Mr Larbi,
Thank you for your application. We would like to invite you for an interview on Monday 15th at 10 am at our office (3rd floor, City Tower).
Please reply to confirm you can attend.
Kind regards,
HR Team — Nova Tech"

What does Mr Larbi need to do after reading the email?', '[{"id":"a","text":"Go to the office immediately."},{"id":"b","text":"Send a new application."},{"id":"c","text":"Reply to confirm he can come."},{"id":"d","text":"Call the HR team."}]'::jsonb, 'c', 'The instruction is: "Please reply to confirm you can attend." The interview is on Monday (not immediately). There is no request for a new application or a phone call — just a reply by email to confirm attendance.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('761779ed-1e38-5a8b-8446-03b4e45bbca9', 'cef5393a-cdbb-5a7a-a263-5d569e8abbe0', 'Read the story:
"Every morning, Mrs Park walks to the market near her house. She buys fresh vegetables and sometimes flowers. On rainy days, she drives instead. Last Tuesday, it was sunny, but she still chose to drive because she had a heavy bag from the day before."

Why did Mrs Park drive last Tuesday?', '[{"id":"a","text":"It was raining."},{"id":"b","text":"The market was far away."},{"id":"c","text":"She had a heavy bag."},{"id":"d","text":"She was late."}]'::jsonb, 'c', 'The text says: "it was sunny, but she still chose to drive because she had a heavy bag from the day before." It was NOT raining. The market is near her house (not far). Being late is not mentioned — the reason given is the heavy bag.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8681401-2a05-5ed6-8bbb-009d5d36112f', 'cef5393a-cdbb-5a7a-a263-5d569e8abbe0', 'Read the notice:
"FITNESS FIRST GYM
New members this month get a FREE personal training session.
Monthly membership: £30.
Students with a valid student card: £20.
Family passes (up to 4 people): £60."

A student wants to join. How much will they pay per month?', '[{"id":"a","text":"£20."},{"id":"b","text":"£30."},{"id":"c","text":"£0 — it is free for students."},{"id":"d","text":"£60."}]'::jsonb, 'a', 'Scan for student rate: "Students with a valid student card: £20." The standard rate is £30. £60 is for a family pass. The gym is not free for students — the free item is only a personal training session, not the membership.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25caccd6-b43b-5ab4-8c6e-db60e9a7fa51', 'cef5393a-cdbb-5a7a-a263-5d569e8abbe0', 'Read the story:
"Ahmed found an old map in his grandfather''s attic. The map showed a forest with a big X marked on it. He was intrigued — he decided to go and look for whatever was there."

What does "intrigued" most likely mean?', '[{"id":"a","text":"Frightened and confused."},{"id":"b","text":"Bored and uninterested."},{"id":"c","text":"Curious and interested."},{"id":"d","text":"Angry and surprised."}]'::jsonb, 'c', 'The effect of being intrigued is that Ahmed "decided to go and look" — he took action because he was curious. Being frightened or angry would not typically make someone investigate. Being bored would lead to the opposite action. Intrigued means curious and interested.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b2ba23b-091b-5d4d-baff-2fc9b4b53c0c', 'cef5393a-cdbb-5a7a-a263-5d569e8abbe0', 'Read the notice:
"IMPORTANT: From 1st September, the school canteen will only accept payments by card. Cash will not be accepted. Students who don''t have a card should speak to the school office before 31st August."

Which sentence is FALSE according to the notice?', '[{"id":"a","text":"The change starts on 1st September."},{"id":"b","text":"Students without a card should contact the office."},{"id":"c","text":"Card payment will be required in the canteen."},{"id":"d","text":"Students can still pay with cash after 1st September."}]'::jsonb, 'd', 'The notice says "Cash will not be accepted" from 1st September — so (b) is false. (a) The change starts on 1st September ✓. (c) Students without a card should speak to the office ✓. (d) Only card payments will be accepted ✓. (b) directly contradicts the notice.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('94de84a3-e87f-5b67-af91-71f3373053f7', '308ad6a2-e0c8-571a-a2ab-d473a9357085', 'anglais-a2', '👑 Elite Challenge ⭐⭐⭐⭐: Reading Comprehension: Everyday Texts', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('d5a67d97-fdb0-5c0a-a08e-f99d8d2482d1', '94de84a3-e87f-5b67-af91-71f3373053f7', 'Read the text:
"Maya moved to a new city for work. At first, she felt lonely — she didn''t know anyone and spent most evenings at home. But after a few weeks, she joined a running club. Soon she had friends, and the city started to feel like home."

Which sentence best describes Maya''s experience?', '[{"id":"a","text":"Maya felt lonely at first but then made friends."},{"id":"b","text":"Maya was happy from the moment she arrived."},{"id":"c","text":"Maya never felt comfortable in the new city."},{"id":"d","text":"Maya moved back to her old city after a few weeks."}]'::jsonb, 'a', 'The story has two stages: lonely at first → found friends through the running club. (b) is wrong — she was lonely at first. (c) is wrong — the city "started to feel like home" at the end. (d) is not mentioned — she stayed and settled in.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb29da7b-fb9b-5e30-941b-6964741cd6ce', '94de84a3-e87f-5b67-af91-71f3373053f7', 'Read the email:
"Hi team,
The Monday meeting is moved to Wednesday this week — same time (10 am), same room (B12).
Also, please send your weekly reports by Tuesday noon instead of Wednesday.
See you then,
Karim"

Which TWO things have changed according to the email? Choose the most complete answer.', '[{"id":"a","text":"The meeting time and the room number."},{"id":"b","text":"The meeting day and the report deadline."},{"id":"c","text":"The meeting room and the report deadline."},{"id":"d","text":"The meeting day and the meeting time."}]'::jsonb, 'b', 'Two things changed: (1) the meeting moved from Monday to Wednesday (the day changed, not the time or room), and (2) the report deadline moved from Wednesday to Tuesday noon. Time and room are the same. (a) and (c) include room — wrong, it is still B12. (d) the time did not change.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e9c9ef5-7275-5b83-b91e-b96ecf857bab', '94de84a3-e87f-5b67-af91-71f3373053f7', 'Read the story:
"The old theatre had been empty for twenty years. Many people thought it should be demolished and replaced with a car park. But a group of young artists disagreed. They raised money, repaired the building, and reopened it last spring. Now it hosts weekly shows and workshops."

What does "demolished" most likely mean?', '[{"id":"a","text":"Decorated."},{"id":"b","text":"Sold."},{"id":"c","text":"Destroyed."},{"id":"d","text":"Closed."}]'::jsonb, 'c', 'Context clue: demolished and replaced with a car park — the idea is to remove the building entirely and put something else in its place. That meaning is destroyed. Decorated and sold would not require replacing with a car park. Closed is what happened already (it was empty).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0e2c288-e2ef-55d1-b0c8-7e409807f2f2', '94de84a3-e87f-5b67-af91-71f3373053f7', 'Read the story:
"The old theatre had been empty for twenty years. Many people thought it should be demolished and replaced with a car park. But a group of young artists disagreed. They raised money, repaired the building, and reopened it last spring. Now it hosts weekly shows and workshops."

Which sentence is TRUE?', '[{"id":"a","text":"Everyone in the community wanted to demolish the theatre."},{"id":"b","text":"The theatre has been empty for ten years."},{"id":"c","text":"The theatre now has a car park next to it."},{"id":"d","text":"The artists raised money to save and repair the theatre."}]'::jsonb, 'd', 'The text says the artists "raised money, repaired the building, and reopened it" — (d) is true. (a) is false — "many people" wanted demolition, but the artists disagreed. (b) is false — it was empty for twenty years. (c) the car park was the alternative that was NOT built.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34fdca4f-617a-56c3-ad53-c608205e8be4', '94de84a3-e87f-5b67-af91-71f3373053f7', 'Read the notice:
"TRAIN SERVICE UPDATE
Due to engineering works, all trains between Central and Northfield will be replaced by buses on Saturday and Sunday.
Journey time will be approximately 45 minutes longer than normal.
Tickets remain valid."

A passenger has a train ticket for Sunday from Central to Northfield. What should they expect?', '[{"id":"a","text":"Their ticket is not valid and they must buy a bus ticket."},{"id":"b","text":"They will take a bus, which will take about 45 minutes longer."},{"id":"c","text":"The train will run on time on Sunday."},{"id":"d","text":"They cannot travel on Sunday."}]'::jsonb, 'b', 'The notice says trains are replaced by buses on Saturday and Sunday, the journey takes about 45 minutes longer, and "tickets remain valid." So the passenger takes a bus (not a train), the ticket is still valid (not invalid or needing to buy a new one), and travel is still possible.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9b20585-1550-5f19-af02-dbac1ecf6ee0', '94de84a3-e87f-5b67-af91-71f3373053f7', 'Read the email:
"Dear parents,
We are delighted to inform you that our school won first place in the regional science competition.
The winning team — Lina, Omar, and Sana — will receive their certificates at a special assembly on Friday at 2 pm.
All parents are welcome to attend.
Mrs Hamdi, Principal"

Which sentence is NOT true according to the email?', '[{"id":"a","text":"Three students won the competition."},{"id":"b","text":"The assembly is on Friday at 2 pm."},{"id":"c","text":"Parents must register to attend the assembly."},{"id":"d","text":"The school came first in the regional competition."}]'::jsonb, 'c', 'The email says "All parents are welcome to attend" — no registration is mentioned. (c) is not true (adding a condition not in the text). (a) Three students: Lina, Omar, and Sana ✓. (b) Assembly on Friday at 2 pm ✓. (d) First place in the regional competition ✓.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c534779a-9369-5e62-b816-29adcd746674', '308ad6a2-e0c8-571a-a2ab-d473a9357085', 'anglais-a2', '⭐⭐ Drill: Reading Comprehension', 2, 75, 15, 'practice', 'admin', 5)
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
  ('9ce8230b-4ba0-57a9-b129-b2d01ad50e7b', 'c534779a-9369-5e62-b816-29adcd746674', 'Read: "NOTICE — SCHOOL OFFICE
The office will be closed on Thursday afternoon for staff training.
Students who need a letter or document should collect it before 12 pm on Thursday.
The office reopens on Friday at 8 am."

A student wants a letter. When is the latest time to collect it on Thursday?', '[{"id":"a","text":"8 am."},{"id":"b","text":"12 pm."},{"id":"c","text":"All day Thursday."},{"id":"d","text":"Friday morning."}]'::jsonb, 'b', 'Scan for the deadline: students should collect it before 12 pm on Thursday. The office is closed on Thursday afternoon — so 12 pm is the cut-off. 8 am is Friday''s reopening time. The office is not open all day Thursday. Friday morning is too late for collecting on Thursday.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3fda5347-f46b-5ca8-b844-cb4eb618105b', 'c534779a-9369-5e62-b816-29adcd746674', 'Read: "Anna loves cooking. Last weekend, she made a large pot of soup and invited her neighbours to try it. Everyone said it was wonderful, and one neighbour, Mr Bitar, asked for the recipe."

Why did Mr Bitar ask Anna for the recipe?', '[{"id":"a","text":"He wanted to write a cookbook."},{"id":"b","text":"He was Anna''s cooking teacher."},{"id":"c","text":"He needed ingredients for a different dish."},{"id":"d","text":"He thought the soup was wonderful and wanted to cook it himself."}]'::jsonb, 'd', 'The text tells us everyone said the soup was wonderful, and then Mr Bitar asked for the recipe — the logical connection is that he liked it and wanted to make it himself. A cookbook, being a teacher, and needing different ingredients are all invented details not found in the text.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('089b52b5-9a33-5935-8a48-d8b86a788cd9', 'c534779a-9369-5e62-b816-29adcd746674', 'Read: "Ben is very exhausted after his long journey. He arrived at the hotel, dropped his bags on the floor, and fell asleep immediately without even eating dinner."

What does "exhausted" most likely mean?', '[{"id":"a","text":"Very tired."},{"id":"b","text":"Very happy."},{"id":"c","text":"Very hungry."},{"id":"d","text":"Very worried."}]'::jsonb, 'a', 'The context clues are fell asleep immediately and didn''t even eat dinner — both are signs of extreme tiredness, not hunger, happiness, or worry. Exhausted means extremely tired. If he were just hungry, he would have eaten rather than going straight to sleep.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0af07854-57fb-59ee-9cc5-041db6740343', 'c534779a-9369-5e62-b816-29adcd746674', 'Read: "MESSAGE FROM THE MANAGER
Dear team,
Our office will move to a new building on Water Street next month.
Parking will be available for all staff.
We will hold a welcome lunch on the first day in the new building.
More details to follow.
Regards, Ms Fahd"

Which statement is TRUE according to the message?', '[{"id":"a","text":"The new building has no parking."},{"id":"b","text":"The move is happening this week."},{"id":"c","text":"There will be a welcome lunch on the first day in the new building."},{"id":"d","text":"Ms Fahd has already given all the details."}]'::jsonb, 'c', 'Scan the message: it says there will be a welcome lunch on the first day in the new building — that is directly stated and true. Parking is available, not unavailable, so the first option is false. The move is next month, not this week. The manager says more details will follow, so the fourth option is false.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51c917de-4eb1-5983-86fb-36d80ff776f1', 'c534779a-9369-5e62-b816-29adcd746674', 'Read: "Omar grew up in a small town but moved to the capital for university. He found city life hectic at first. There were so many people, so much noise, and the streets were always busy. After a year, though, he started to enjoy the energy of the city."

Which sentence best describes Omar''s experience?', '[{"id":"a","text":"Omar found city life difficult at first but grew to enjoy it."},{"id":"b","text":"Omar never liked the capital and wanted to go home."},{"id":"c","text":"Omar was happy in the capital from the beginning."},{"id":"d","text":"Omar moved back to his small town after one year."}]'::jsonb, 'a', 'The text says Omar found city life hectic at first, but after a year he started to enjoy the energy. The story has two clear stages: difficult at first, then enjoyment. He never liked it and went home is wrong — he stayed and adjusted. Happy from the beginning contradicts hectic at first. Moved back is not mentioned — he stayed.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ba5387d-6b3f-5c59-9d0d-cda8ba088086', 'c534779a-9369-5e62-b816-29adcd746674', 'Read: "TRAVEL BLOG — Monday 9th
I woke up at 6 am and took the early train to the coast. The journey took about an hour. The beach was quiet because it was still early. I had a coffee at a small café by the sea, then walked along the shore for two hours before heading back to the city."

Which sentence is NOT true according to the text?', '[{"id":"a","text":"The writer took a train to get to the coast."},{"id":"b","text":"The writer had a coffee near the sea."},{"id":"c","text":"The writer walked along the shore before returning."},{"id":"d","text":"The beach was crowded when the writer arrived."}]'::jsonb, 'd', 'The text says the beach was quiet because it was still early — not crowded. The first option is true (took the early train). The second option is true (a coffee at a small café by the sea). The third is true (walked along the shore for two hours before heading back). Only the fourth option contradicts the text.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

