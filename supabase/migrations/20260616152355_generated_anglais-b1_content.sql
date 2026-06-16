-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: anglais-b1 (Anglais — Intermédiaire (B1))
-- Regenerate with: npm run content:build
-- Source of truth: content/anglais-b1/
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
  ('anglais-b1', 'Anglais — Intermédiaire (B1)', 'Reach the intermediate threshold: the present perfect, the past continuous, conditionals, modals of obligation and advice, and relative clauses. Intermediate level (CEFR B1), building on A1 and A2.', 'Agilité', 'subject-english', 'Globe', 3, 'en', false, 'anglais', NULL)
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
      AND e.subject_id = 'anglais-b1'
      AND e.source = 'admin'
      AND q.id NOT IN ('d21f78fc-18fc-5d23-844f-76c0ba5c1a9c', '770935af-8772-597c-bd88-e45d10860635', '9ebefaa9-16f9-52c8-ad20-4aa6273fc1a3', '0b8adf2a-9e97-533c-80a6-f072e4cf724e', 'dd98b25a-37f5-56f1-b00a-105cf533d89d', '25605f4a-30a8-5d60-8140-139d856a0ab0', '863cec36-9b4c-5aab-bd2b-68c363f61ab2', '0ae5d7f5-7a89-5a88-aa95-a1eb129e68ec', 'a03456e2-2ea2-5135-96fd-b469e38a469a', '8c24e4ee-7b6e-513c-9792-e72f2725dc1b', '82f6e766-275a-5cff-84ef-66311337c01f', 'f0f12d8e-b670-5e66-adef-8fce2afbea13', '995363e9-e638-539d-92c1-9e6ad2df4b6c', 'ca80caa8-05d8-5a7f-a597-cfdbc7390163', 'd81612b2-e9af-505b-ad9f-bc5b2c1b0fc5', 'fcc14fbb-aa3f-5625-aa28-b40f59a6d7d0', '9226c7a4-0868-522a-af08-cdd067667f30', '8ac1b05f-cca4-5f89-9042-ea8e83f6a392', '4dd59d5b-b41d-50b5-bc3d-47fb0c37fae4', '03fb821a-9fa6-5204-8d29-126e799d7131', '01dd93ec-1132-5511-af21-00e89f0e41d6', '90240e9c-89b2-5276-ba66-880d30507cdb', 'd2ff8dc0-517c-5b7e-9dbb-27560bbf23e9', '7849c87b-b79d-5eef-91e0-e7188d911e25', 'd4cf135a-984d-59c1-a5fd-9f5d70dcda94', 'b92c39c7-56f8-5d20-af87-80cf1960efad', '58065b06-65bd-5dd4-97f1-dc08a467ecc8', '8eb330d6-6755-5131-b1eb-e1ca0bbede5a', '8e1e9934-1a94-556f-a97d-b8737ee355ff', 'eaab1805-0de3-5ff8-8dc8-6c274886bbc9', '9b0ef4ac-f2ff-5e25-8858-1bacd6f4c765', 'c15ff13c-57b0-5196-b5ba-7717cad31c6e', '5695972e-54fd-5c9e-9323-a364bbb0610a', 'a2b64c56-95ea-5d59-ab24-ecf6dc84f68f', '96c312b6-87f3-5f3a-8690-1eec39734321', '2ce5d7df-c927-561a-8461-c76dcc8da384', '6edf674a-90ee-5f4e-a847-79f26805ac2a', '293e5e74-e17f-52e2-af55-7bb2425e4995', '9c612545-2b57-5a30-94e0-6bd9f509e5af', 'a9dabafb-ff48-5116-9ee9-b9248c76ba92', '90505f8e-53bf-5ecf-b905-de047fbcb141', 'b0d27e80-38cc-568c-a19a-0d65a6ee12a3', '06a227a6-ff83-53d1-8275-36a45701b85d', '1abf2718-4740-56b5-a8ce-b2799b9a01a0', 'df4e924a-4f94-51ca-9edb-652719a57112', '28f66ad0-2948-5968-b0c0-3891fb9c7f89', 'a1960c69-62dd-52db-8261-3410a4d084d1', '44ba31eb-4e53-5280-8886-8db0fd299512', 'bdba3627-8e92-5215-9440-8647181cd83d', '8f689f63-a49a-5079-86eb-039efad047b6', 'b55becca-f73c-582d-bc19-79764c189cab', '8c69b63c-6a84-510b-a7cc-d213ff949911', 'c3f4817e-5e42-5819-8045-d23d5afa8a56', 'c0cf3d8e-29b2-554e-8396-233da299a03a', 'e630f48b-9ddd-5783-8091-fd7cac3c8aa0', '92899ae3-6f82-5197-afce-5c3cdf5b6c1c', '27f29a01-c96e-589f-9bd0-0c5ccc93d7d2', '77762ad6-0d34-5dc4-ad34-48d91277fedf', 'ece859ee-4559-531f-8276-185680341543', '6cae7f54-e2ba-5852-9100-7974d4edc9f3', '36258cec-198e-5ef5-a153-2557cf16b7bf', '51f9c6e0-600a-55e0-ac29-6b74e2b4f21e', '8404350f-0f6a-5fae-ba92-40ee54461fb1', '08122a2b-ebee-50ea-a7fc-3efa9c703608', 'f4197b11-0616-50d9-890e-34ab74dc614d', '3c5256db-a943-554f-ba38-d1f6fc407c88', '6d097239-c36c-56ff-aac8-6ce12ee05ceb', '0449118d-6079-5393-beac-6e206957bf3f', 'fb999032-2564-5398-ba08-3fba28729101', '2b297cbf-d770-50f3-b5bb-db0e8c9c17fe', 'bc0edb61-6e7f-518f-bae1-19cd55652632', '84554d85-5317-5017-8097-1d8fea742d35', '2e5d08e4-1bc4-551f-9db5-462cf889046e', '10b1be7d-c21e-5949-89da-04c06deb9077', '1db1ee7c-f255-5f9e-bafa-cdd1169ab692', '2d3e5507-5402-5629-85d1-bae63a1a8f91', '6580bb6d-36bb-5aa2-afbe-2e6369d0bc8b', '8113315b-c396-5415-98b9-9d75a65e6cf0', 'b3eede3a-aa03-5f95-9314-babc6c386692', 'e5f44117-bd7f-531a-ae7e-090a8b8ec775', '4ee52991-eb43-5e60-9a35-5a90d303b21e', '8fcd058c-a7a4-537b-9414-63c2d55787ac', '71cdecc6-9c1d-52fc-822c-00b5b3eac009', '140c628a-1a79-5314-8b6c-b7307ff6982a', '12bdddc9-2f19-53d2-8098-c33b66290195', 'fb3afd92-d2fe-52b6-954e-c84c64e154e9', '78cc6040-c588-5ed0-9bb7-c4db9da0985d', 'b5e6e485-dc7d-58a1-a0f5-a5984b545774', 'ac3af235-6167-5675-aa56-dd2f351cbd8a', '1d9ea7bc-4f55-5522-a1b2-b4648ef39f4e', 'cbe9cac9-f725-5b69-bfc2-e3ad46280dea', '69f8c605-be12-5d27-b744-f1a83582caa9', '987ef75b-b924-5e4a-9fcc-6cbf92b086e7', '0238c85f-0e73-5fd5-862c-22fd6d555d25', '4fac49fc-f563-54f9-a918-e3cf31acc907', 'e2c3dfac-1b06-5597-811b-9f05e96f2c7c', '924d5ccb-5fc5-55fb-8dae-a97704551fe7', '8d1d3a86-daf8-56a1-855e-d0ba09e87c36', 'b963b579-1234-51a9-a179-9e577cd5765c', '481130c6-d407-56bc-88ec-78ef4cb1ad8d', '132d8118-20c5-56b0-b24d-0d6fdeddc501', '8973ba3b-12fe-5f8e-ab37-0559533cf048', '554943ea-c09a-528c-b40c-985badae2b84', '8c1cff10-fb30-59fd-bc34-01377caf444f', '058eb948-16eb-5140-9673-c046f1f85c59', '760a2799-19ca-5390-a2fb-4eaee959eacf', '1547cc51-5271-5684-b077-7c06e3f11f4e', '3257e99d-2660-5323-9aa5-049dcfea235a', 'f9a46e71-9cba-5b1c-9972-27593d20fd4a', '5ccf770d-2bbb-51d6-b3eb-44cbc4879729', '09e00934-ae5d-5a82-8a12-74bb212acc51', 'a761414c-4656-570d-9797-84088854db6f', '606502f9-7a42-5706-ba52-538e290fc574', '84534f92-387a-5aae-a085-663ea92bbfa9', 'e6e8d472-ffb3-560c-b254-70585341c6a2', '9c4b0c26-1807-5937-9209-f8600b893c23', '6289d8ca-7f89-5274-a661-454ea6f98528', '04aba842-0089-5bd8-9192-0aa0a00d217a', 'a7926885-cba9-57a2-94cb-28fb34528811', '86eabef9-eb17-50c0-9b2e-573c9e621c10', '7fe66ce5-b374-5291-913f-f2366d748628', '53e0e708-72b8-5ffd-beaf-b48f5d673434', 'e12a5532-a554-5ef4-aabb-51490a2c331f', '89b472c2-e11f-5db4-8788-277868af1765', 'ff83ad6a-d8ac-59f2-9d8c-41fe9cd2c7ca', 'bc3660ce-c60e-5d1b-8ee6-8390ac5cea87', '457504ee-db4c-597d-b3d5-173059263078', 'd22fe2dd-dde1-5d91-827a-e4863e5eb325', '16587e62-5f62-58b8-bdab-0ed45705ffdf', 'be179cfc-06fe-59d9-9c40-8701a8d86ad1', '73352b6d-23ce-53ad-a480-41d7d3ad82cc', '1c78cf3c-1ba9-5708-8973-a657855ea469', 'e6765073-0b37-5ac8-ade2-98be8d7b19c7', 'a1354dd9-ce9f-50bc-8523-24a1135f78c1', 'c554e7f4-ae80-557d-aaa8-53143b9d619f', 'be82507b-76aa-5f51-adda-8ca6085d6df4', '1da7af6c-1a95-55bb-9c40-b05ba6ff087b', '187c048c-c484-5e98-9e03-1cc40a34daf1', '777c5972-5e8a-56c4-b4cf-8b3a6cd86b54', 'a0b097d8-f0d8-5236-8ecc-72af95555c5c', '7855d649-82ea-5b02-81cf-326afc40dcc3', '4991d957-7742-5aec-a2f6-4f8ac1713078', '60c9ba60-c9a5-5944-a549-70732127877f', '29b8bf81-87a7-5257-8ed8-9dfc20f24f06', 'c3360361-8de7-5491-a29c-9e3c5fa80b8b', 'db250069-c0d0-5a84-82b9-e310c036bfbe', 'c485e0c6-2051-52e1-b28c-5a7ad4daed8b', 'd419fd09-2a78-5042-9b4a-0ae9bfdb3ccb', '443d6be7-214a-5e41-8a09-d8dd0559ebc7', '60a2e2b4-cffd-58f7-971c-ccf7e95f34eb', '3ef4230f-a1ca-57aa-8648-69d1b46ed1e2', '6835d0cd-7a8d-5416-a7e2-a7bd9768679e', 'a7bc8a6d-949c-50b8-a0df-08a649028bb6', '7f35a666-cd6d-5899-a5bf-2c4c67a793c9', 'b4dfec0e-5b28-5764-9ef4-b4ffd40b83af', 'fb96c944-c197-5a3e-8be5-a6ebdc8a2753', '600e2c60-c2a2-5925-988a-5bd41b4bee33', '2189b79f-f14c-5c54-a7fc-cab8bbf2db79', '9d5d564b-acf2-5119-8441-8666f1156e80', '70cdc1fd-92d9-5dad-a54e-a638f3f51e74', '722365dd-6107-5607-9184-ddafc2ca4613', '2f1241d3-dec9-5cc3-bafe-214c49c19eb3', 'ad873ea6-b61b-53a3-a321-1d7170e6b5f0', '0f97ee10-fad9-5cbc-90f0-cd7ee25621b8', '4497b4b8-d5e9-5cff-80be-9917515644a1', '8c8acaf3-841e-51ba-b2e2-efe1398abba7', 'c9a71e4e-f4dd-5725-bda1-f8174d5f0ad0', 'ad8a9816-c107-52e5-9d22-262c4619b6ad', 'b06fe6d0-127c-5511-9b1e-f6eb14ab2d0f', '9e666eae-abce-52b4-9224-63d4753624a0', '75ab7c72-9799-564c-ac54-49ae6593b635', 'c0efbb21-3093-5def-9634-3aedbc54ac4a', '4928f93e-c19a-5c6e-a80b-382be2148e2f', '6b376cde-8f56-5528-948f-bf75ac2111b8', 'd424fcfe-6b26-5c86-9797-e2fe4e065e18', '22546303-f91d-51fb-a92b-b2e10f884324', '4e87994a-baf0-54ce-9df2-f79501aed4c4', 'be48946f-213a-56e5-9904-4257f96a7992', '5976220a-969b-564c-aed9-9bc7f08eb752', 'c707cf03-c002-5367-9322-1e263232c331', 'e064b766-61d0-5da7-90d3-2ac43970b0dc', '9381ccf8-1cf7-5b1c-96a2-b49d4c2a5f7b', '759625f5-61a1-58d0-b206-8bbba18f6c12', '217d042b-3a8d-5e84-9910-ddd2b674805a', 'adde924f-5cf8-5814-9303-306ca67cd712', 'd7cc2990-c2dd-5e36-8ef9-5051ab16a1d6', '705369ce-5f06-5b03-9d5f-066f6fb9800a', '2cf9a555-1d18-54f7-8af8-1a3d3787eefb', '1b2b37ef-b099-5e55-b118-48b6032fc110', '9b657e2f-be13-546e-bcde-9adaae57c8f9', '7e93fb82-7047-5f3f-8a45-a323fb700e52', '307309a7-21e3-5a2a-9fd7-c1a9b647a735', '1fd909f6-6154-5fe9-9c8a-ccbca6de177a', '7e0960d2-a42f-53ae-86b8-3dd71c394505', '9bb06d9a-78b4-5b8a-8c3e-74376e21aa1e', '9946b2ef-6d22-57a0-a84a-2033818f5575', '5ece2ef1-7da9-52ac-9df2-101335757174', '512017cc-7729-5f01-8c13-5004d9ebc70c', '5cc61bd1-3d73-52af-85a0-bc35697cc948', 'f30ae529-a03a-5252-8364-b679aeb69228', '5f7ea747-a34d-5e69-ab5b-556c41148c7c', '348f4483-9030-5dd5-8eb3-b523fda04a50', '13b78b32-26f0-53fd-9fa1-ae461f258c53', 'bf9113d8-290d-568c-8b90-67ab7886e306', '5112ae05-527f-5455-b5bc-3b634ad40458', '8eebca91-b927-5602-8c1b-cc0b600a2582', '31a2be63-9e80-5f7e-9edd-2f30f43d4eb6', '45f2153d-35af-5c79-aaf7-c40b52822505', '55040d52-b6be-5cb9-907b-d8386ffd2603', 'a912403f-7588-5184-82a2-464482286d08', 'ab010f00-6273-54bc-a9d3-fe2746fb3c96', '2b6790c9-b5c2-5e9d-a6bc-7141ed52cd01', 'e837019f-74ac-5462-93d4-48b4ffc30e29', 'e8af98c2-c5ba-5491-9c30-9fc8814483db', 'babd46bf-0286-5af5-a5d0-6af03f0d664f', 'e4dac40a-951f-50b6-8138-c8c3ce63116e', 'b5e725af-8d1f-50af-b188-41429c579da0', 'dab2b9c8-6df6-5d1d-a276-781843804335', '38260523-805e-53ca-8baf-a8603e5e1032', 'a2ab265b-1884-5323-9fe3-15e8d4c14a1d', 'eb5797b5-320d-5dfc-8fc3-a6c8250dffdc', '659ddeb8-6fb3-5a5f-bf04-34e098714399', '9d700b47-9e07-59d2-836e-e3c6c63b9d12', '3af6193f-dddb-57c9-8776-d5949c8bef0a', '6a45bf2e-9ebd-59f8-ad6a-ecf26f14b7bf', '25ed06b2-1352-5ca6-b157-779a0a6e31a2', 'b503bdaf-bc6e-5c12-8ae6-28e1f20d36af', '72a5a8ea-0126-5eeb-bf63-5f4629291555', '810fb975-00d4-523b-9be9-30cb7e9b1d39', '696dc7f7-83b9-5a49-a568-f97645ce1d3c', '4b6b8206-28fe-58c1-b62c-31986c9f9ed9', '794e4218-1a71-53b9-aedd-6dd8892217c4');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'anglais-b1' AND source = 'admin' AND id NOT IN ('40fd289c-37a4-53db-93d9-38b367e29e5f', 'a1e6f69c-9aa0-5447-a0f9-1e2f81479615', '9ef6f6ea-2f89-5519-b6ba-a41b3329c3a8', '5afd1fa5-52f7-5c8f-9799-62d189c5f77c', '6b85c952-5fee-56f8-a474-b5113d3fb46d', '1993e981-3f08-5cb9-a035-9f51b6fe83e5', '5215da47-c957-5eb9-a8ba-0769355e8c1e', '4bea5507-af8e-51db-9d78-27c594203dba', '655870b0-3a82-57d6-8b66-df037e3f20f0', '14bd58a6-41b9-5534-a32c-371feae58b9a', 'a39d1f14-cad1-583a-87e8-3dbda3a634ff', '01527ceb-d29a-5b63-863d-32721d7ec78f', 'e8e88986-bcbe-5dd8-b0cf-7f993599de60', 'd95fd47f-b045-5ec7-a5a3-7c55dc46acc4', 'c2af895f-335f-573f-b73b-071af11d1a14', 'fe4eb78e-6011-5328-bd7d-207ae5b8f21c', 'bf69c0eb-1b3a-5b6f-9c70-0ccc5221db6f', '9d2a171f-0019-564f-b720-1e0a3c333cab', 'c4bb6149-7cb3-5743-809c-e8db215da654', '1b58c970-ed85-552d-ad5a-e826dd0a4605', '6c7fec37-efed-5bb6-b3ae-d2c0588b73da', 'b118995d-87bc-539b-969d-5e971f98ff7a', 'f6cfa647-7511-5bc3-ac55-3a414bbfa939', '2f8279d5-6792-59a1-a5a3-315f3f921cd1', '6e3123e2-e3b7-58f3-97ef-bd81c64a486b', '613c498b-4dfd-5e31-8fc2-46ce28996c88', '8ab2550a-800d-572c-8f39-959b128f8c91', '8144efc4-8228-5d01-b3cc-1e36c3bdef4f', 'f7a5a7aa-5d82-5ffe-a31d-c098d4e4a52c', '7e9dc9ca-d981-5203-b9b2-a00276e23f81', '5cc36d18-273a-56f9-9b31-59562c739128', '1c491d91-b7dc-5483-b1fc-3aed50e185ba', '6ae4d1fc-bcb0-560a-95cc-7af77fa6060e', '6ccd5b92-839b-5432-9d9e-323f2571f5af', '3dfa33ef-a915-5031-92e1-5bb239e854d0', '6ff657d4-5067-5cd8-a1ea-404fd0353cd9', 'c1daf195-1ce7-580e-9312-32faac9b9cb9', '02bbcf36-9d72-58cd-8342-f43be55f614b', '197c7611-5824-5ad4-86a5-d347ee439560', '908ff8d4-8874-59f6-b55f-3af35813c89d');
DELETE FROM public.questions WHERE exercise_id IN ('40fd289c-37a4-53db-93d9-38b367e29e5f', 'a1e6f69c-9aa0-5447-a0f9-1e2f81479615', '9ef6f6ea-2f89-5519-b6ba-a41b3329c3a8', '5afd1fa5-52f7-5c8f-9799-62d189c5f77c', '6b85c952-5fee-56f8-a474-b5113d3fb46d', '1993e981-3f08-5cb9-a035-9f51b6fe83e5', '5215da47-c957-5eb9-a8ba-0769355e8c1e', '4bea5507-af8e-51db-9d78-27c594203dba', '655870b0-3a82-57d6-8b66-df037e3f20f0', '14bd58a6-41b9-5534-a32c-371feae58b9a', 'a39d1f14-cad1-583a-87e8-3dbda3a634ff', '01527ceb-d29a-5b63-863d-32721d7ec78f', 'e8e88986-bcbe-5dd8-b0cf-7f993599de60', 'd95fd47f-b045-5ec7-a5a3-7c55dc46acc4', 'c2af895f-335f-573f-b73b-071af11d1a14', 'fe4eb78e-6011-5328-bd7d-207ae5b8f21c', 'bf69c0eb-1b3a-5b6f-9c70-0ccc5221db6f', '9d2a171f-0019-564f-b720-1e0a3c333cab', 'c4bb6149-7cb3-5743-809c-e8db215da654', '1b58c970-ed85-552d-ad5a-e826dd0a4605', '6c7fec37-efed-5bb6-b3ae-d2c0588b73da', 'b118995d-87bc-539b-969d-5e971f98ff7a', 'f6cfa647-7511-5bc3-ac55-3a414bbfa939', '2f8279d5-6792-59a1-a5a3-315f3f921cd1', '6e3123e2-e3b7-58f3-97ef-bd81c64a486b', '613c498b-4dfd-5e31-8fc2-46ce28996c88', '8ab2550a-800d-572c-8f39-959b128f8c91', '8144efc4-8228-5d01-b3cc-1e36c3bdef4f', 'f7a5a7aa-5d82-5ffe-a31d-c098d4e4a52c', '7e9dc9ca-d981-5203-b9b2-a00276e23f81', '5cc36d18-273a-56f9-9b31-59562c739128', '1c491d91-b7dc-5483-b1fc-3aed50e185ba', '6ae4d1fc-bcb0-560a-95cc-7af77fa6060e', '6ccd5b92-839b-5432-9d9e-323f2571f5af', '3dfa33ef-a915-5031-92e1-5bb239e854d0', '6ff657d4-5067-5cd8-a1ea-404fd0353cd9', 'c1daf195-1ce7-580e-9312-32faac9b9cb9', '02bbcf36-9d72-58cd-8342-f43be55f614b', '197c7611-5824-5ad4-86a5-d347ee439560', '908ff8d4-8874-59f6-b55f-3af35813c89d') AND id NOT IN ('d21f78fc-18fc-5d23-844f-76c0ba5c1a9c', '770935af-8772-597c-bd88-e45d10860635', '9ebefaa9-16f9-52c8-ad20-4aa6273fc1a3', '0b8adf2a-9e97-533c-80a6-f072e4cf724e', 'dd98b25a-37f5-56f1-b00a-105cf533d89d', '25605f4a-30a8-5d60-8140-139d856a0ab0', '863cec36-9b4c-5aab-bd2b-68c363f61ab2', '0ae5d7f5-7a89-5a88-aa95-a1eb129e68ec', 'a03456e2-2ea2-5135-96fd-b469e38a469a', '8c24e4ee-7b6e-513c-9792-e72f2725dc1b', '82f6e766-275a-5cff-84ef-66311337c01f', 'f0f12d8e-b670-5e66-adef-8fce2afbea13', '995363e9-e638-539d-92c1-9e6ad2df4b6c', 'ca80caa8-05d8-5a7f-a597-cfdbc7390163', 'd81612b2-e9af-505b-ad9f-bc5b2c1b0fc5', 'fcc14fbb-aa3f-5625-aa28-b40f59a6d7d0', '9226c7a4-0868-522a-af08-cdd067667f30', '8ac1b05f-cca4-5f89-9042-ea8e83f6a392', '4dd59d5b-b41d-50b5-bc3d-47fb0c37fae4', '03fb821a-9fa6-5204-8d29-126e799d7131', '01dd93ec-1132-5511-af21-00e89f0e41d6', '90240e9c-89b2-5276-ba66-880d30507cdb', 'd2ff8dc0-517c-5b7e-9dbb-27560bbf23e9', '7849c87b-b79d-5eef-91e0-e7188d911e25', 'd4cf135a-984d-59c1-a5fd-9f5d70dcda94', 'b92c39c7-56f8-5d20-af87-80cf1960efad', '58065b06-65bd-5dd4-97f1-dc08a467ecc8', '8eb330d6-6755-5131-b1eb-e1ca0bbede5a', '8e1e9934-1a94-556f-a97d-b8737ee355ff', 'eaab1805-0de3-5ff8-8dc8-6c274886bbc9', '9b0ef4ac-f2ff-5e25-8858-1bacd6f4c765', 'c15ff13c-57b0-5196-b5ba-7717cad31c6e', '5695972e-54fd-5c9e-9323-a364bbb0610a', 'a2b64c56-95ea-5d59-ab24-ecf6dc84f68f', '96c312b6-87f3-5f3a-8690-1eec39734321', '2ce5d7df-c927-561a-8461-c76dcc8da384', '6edf674a-90ee-5f4e-a847-79f26805ac2a', '293e5e74-e17f-52e2-af55-7bb2425e4995', '9c612545-2b57-5a30-94e0-6bd9f509e5af', 'a9dabafb-ff48-5116-9ee9-b9248c76ba92', '90505f8e-53bf-5ecf-b905-de047fbcb141', 'b0d27e80-38cc-568c-a19a-0d65a6ee12a3', '06a227a6-ff83-53d1-8275-36a45701b85d', '1abf2718-4740-56b5-a8ce-b2799b9a01a0', 'df4e924a-4f94-51ca-9edb-652719a57112', '28f66ad0-2948-5968-b0c0-3891fb9c7f89', 'a1960c69-62dd-52db-8261-3410a4d084d1', '44ba31eb-4e53-5280-8886-8db0fd299512', 'bdba3627-8e92-5215-9440-8647181cd83d', '8f689f63-a49a-5079-86eb-039efad047b6', 'b55becca-f73c-582d-bc19-79764c189cab', '8c69b63c-6a84-510b-a7cc-d213ff949911', 'c3f4817e-5e42-5819-8045-d23d5afa8a56', 'c0cf3d8e-29b2-554e-8396-233da299a03a', 'e630f48b-9ddd-5783-8091-fd7cac3c8aa0', '92899ae3-6f82-5197-afce-5c3cdf5b6c1c', '27f29a01-c96e-589f-9bd0-0c5ccc93d7d2', '77762ad6-0d34-5dc4-ad34-48d91277fedf', 'ece859ee-4559-531f-8276-185680341543', '6cae7f54-e2ba-5852-9100-7974d4edc9f3', '36258cec-198e-5ef5-a153-2557cf16b7bf', '51f9c6e0-600a-55e0-ac29-6b74e2b4f21e', '8404350f-0f6a-5fae-ba92-40ee54461fb1', '08122a2b-ebee-50ea-a7fc-3efa9c703608', 'f4197b11-0616-50d9-890e-34ab74dc614d', '3c5256db-a943-554f-ba38-d1f6fc407c88', '6d097239-c36c-56ff-aac8-6ce12ee05ceb', '0449118d-6079-5393-beac-6e206957bf3f', 'fb999032-2564-5398-ba08-3fba28729101', '2b297cbf-d770-50f3-b5bb-db0e8c9c17fe', 'bc0edb61-6e7f-518f-bae1-19cd55652632', '84554d85-5317-5017-8097-1d8fea742d35', '2e5d08e4-1bc4-551f-9db5-462cf889046e', '10b1be7d-c21e-5949-89da-04c06deb9077', '1db1ee7c-f255-5f9e-bafa-cdd1169ab692', '2d3e5507-5402-5629-85d1-bae63a1a8f91', '6580bb6d-36bb-5aa2-afbe-2e6369d0bc8b', '8113315b-c396-5415-98b9-9d75a65e6cf0', 'b3eede3a-aa03-5f95-9314-babc6c386692', 'e5f44117-bd7f-531a-ae7e-090a8b8ec775', '4ee52991-eb43-5e60-9a35-5a90d303b21e', '8fcd058c-a7a4-537b-9414-63c2d55787ac', '71cdecc6-9c1d-52fc-822c-00b5b3eac009', '140c628a-1a79-5314-8b6c-b7307ff6982a', '12bdddc9-2f19-53d2-8098-c33b66290195', 'fb3afd92-d2fe-52b6-954e-c84c64e154e9', '78cc6040-c588-5ed0-9bb7-c4db9da0985d', 'b5e6e485-dc7d-58a1-a0f5-a5984b545774', 'ac3af235-6167-5675-aa56-dd2f351cbd8a', '1d9ea7bc-4f55-5522-a1b2-b4648ef39f4e', 'cbe9cac9-f725-5b69-bfc2-e3ad46280dea', '69f8c605-be12-5d27-b744-f1a83582caa9', '987ef75b-b924-5e4a-9fcc-6cbf92b086e7', '0238c85f-0e73-5fd5-862c-22fd6d555d25', '4fac49fc-f563-54f9-a918-e3cf31acc907', 'e2c3dfac-1b06-5597-811b-9f05e96f2c7c', '924d5ccb-5fc5-55fb-8dae-a97704551fe7', '8d1d3a86-daf8-56a1-855e-d0ba09e87c36', 'b963b579-1234-51a9-a179-9e577cd5765c', '481130c6-d407-56bc-88ec-78ef4cb1ad8d', '132d8118-20c5-56b0-b24d-0d6fdeddc501', '8973ba3b-12fe-5f8e-ab37-0559533cf048', '554943ea-c09a-528c-b40c-985badae2b84', '8c1cff10-fb30-59fd-bc34-01377caf444f', '058eb948-16eb-5140-9673-c046f1f85c59', '760a2799-19ca-5390-a2fb-4eaee959eacf', '1547cc51-5271-5684-b077-7c06e3f11f4e', '3257e99d-2660-5323-9aa5-049dcfea235a', 'f9a46e71-9cba-5b1c-9972-27593d20fd4a', '5ccf770d-2bbb-51d6-b3eb-44cbc4879729', '09e00934-ae5d-5a82-8a12-74bb212acc51', 'a761414c-4656-570d-9797-84088854db6f', '606502f9-7a42-5706-ba52-538e290fc574', '84534f92-387a-5aae-a085-663ea92bbfa9', 'e6e8d472-ffb3-560c-b254-70585341c6a2', '9c4b0c26-1807-5937-9209-f8600b893c23', '6289d8ca-7f89-5274-a661-454ea6f98528', '04aba842-0089-5bd8-9192-0aa0a00d217a', 'a7926885-cba9-57a2-94cb-28fb34528811', '86eabef9-eb17-50c0-9b2e-573c9e621c10', '7fe66ce5-b374-5291-913f-f2366d748628', '53e0e708-72b8-5ffd-beaf-b48f5d673434', 'e12a5532-a554-5ef4-aabb-51490a2c331f', '89b472c2-e11f-5db4-8788-277868af1765', 'ff83ad6a-d8ac-59f2-9d8c-41fe9cd2c7ca', 'bc3660ce-c60e-5d1b-8ee6-8390ac5cea87', '457504ee-db4c-597d-b3d5-173059263078', 'd22fe2dd-dde1-5d91-827a-e4863e5eb325', '16587e62-5f62-58b8-bdab-0ed45705ffdf', 'be179cfc-06fe-59d9-9c40-8701a8d86ad1', '73352b6d-23ce-53ad-a480-41d7d3ad82cc', '1c78cf3c-1ba9-5708-8973-a657855ea469', 'e6765073-0b37-5ac8-ade2-98be8d7b19c7', 'a1354dd9-ce9f-50bc-8523-24a1135f78c1', 'c554e7f4-ae80-557d-aaa8-53143b9d619f', 'be82507b-76aa-5f51-adda-8ca6085d6df4', '1da7af6c-1a95-55bb-9c40-b05ba6ff087b', '187c048c-c484-5e98-9e03-1cc40a34daf1', '777c5972-5e8a-56c4-b4cf-8b3a6cd86b54', 'a0b097d8-f0d8-5236-8ecc-72af95555c5c', '7855d649-82ea-5b02-81cf-326afc40dcc3', '4991d957-7742-5aec-a2f6-4f8ac1713078', '60c9ba60-c9a5-5944-a549-70732127877f', '29b8bf81-87a7-5257-8ed8-9dfc20f24f06', 'c3360361-8de7-5491-a29c-9e3c5fa80b8b', 'db250069-c0d0-5a84-82b9-e310c036bfbe', 'c485e0c6-2051-52e1-b28c-5a7ad4daed8b', 'd419fd09-2a78-5042-9b4a-0ae9bfdb3ccb', '443d6be7-214a-5e41-8a09-d8dd0559ebc7', '60a2e2b4-cffd-58f7-971c-ccf7e95f34eb', '3ef4230f-a1ca-57aa-8648-69d1b46ed1e2', '6835d0cd-7a8d-5416-a7e2-a7bd9768679e', 'a7bc8a6d-949c-50b8-a0df-08a649028bb6', '7f35a666-cd6d-5899-a5bf-2c4c67a793c9', 'b4dfec0e-5b28-5764-9ef4-b4ffd40b83af', 'fb96c944-c197-5a3e-8be5-a6ebdc8a2753', '600e2c60-c2a2-5925-988a-5bd41b4bee33', '2189b79f-f14c-5c54-a7fc-cab8bbf2db79', '9d5d564b-acf2-5119-8441-8666f1156e80', '70cdc1fd-92d9-5dad-a54e-a638f3f51e74', '722365dd-6107-5607-9184-ddafc2ca4613', '2f1241d3-dec9-5cc3-bafe-214c49c19eb3', 'ad873ea6-b61b-53a3-a321-1d7170e6b5f0', '0f97ee10-fad9-5cbc-90f0-cd7ee25621b8', '4497b4b8-d5e9-5cff-80be-9917515644a1', '8c8acaf3-841e-51ba-b2e2-efe1398abba7', 'c9a71e4e-f4dd-5725-bda1-f8174d5f0ad0', 'ad8a9816-c107-52e5-9d22-262c4619b6ad', 'b06fe6d0-127c-5511-9b1e-f6eb14ab2d0f', '9e666eae-abce-52b4-9224-63d4753624a0', '75ab7c72-9799-564c-ac54-49ae6593b635', 'c0efbb21-3093-5def-9634-3aedbc54ac4a', '4928f93e-c19a-5c6e-a80b-382be2148e2f', '6b376cde-8f56-5528-948f-bf75ac2111b8', 'd424fcfe-6b26-5c86-9797-e2fe4e065e18', '22546303-f91d-51fb-a92b-b2e10f884324', '4e87994a-baf0-54ce-9df2-f79501aed4c4', 'be48946f-213a-56e5-9904-4257f96a7992', '5976220a-969b-564c-aed9-9bc7f08eb752', 'c707cf03-c002-5367-9322-1e263232c331', 'e064b766-61d0-5da7-90d3-2ac43970b0dc', '9381ccf8-1cf7-5b1c-96a2-b49d4c2a5f7b', '759625f5-61a1-58d0-b206-8bbba18f6c12', '217d042b-3a8d-5e84-9910-ddd2b674805a', 'adde924f-5cf8-5814-9303-306ca67cd712', 'd7cc2990-c2dd-5e36-8ef9-5051ab16a1d6', '705369ce-5f06-5b03-9d5f-066f6fb9800a', '2cf9a555-1d18-54f7-8af8-1a3d3787eefb', '1b2b37ef-b099-5e55-b118-48b6032fc110', '9b657e2f-be13-546e-bcde-9adaae57c8f9', '7e93fb82-7047-5f3f-8a45-a323fb700e52', '307309a7-21e3-5a2a-9fd7-c1a9b647a735', '1fd909f6-6154-5fe9-9c8a-ccbca6de177a', '7e0960d2-a42f-53ae-86b8-3dd71c394505', '9bb06d9a-78b4-5b8a-8c3e-74376e21aa1e', '9946b2ef-6d22-57a0-a84a-2033818f5575', '5ece2ef1-7da9-52ac-9df2-101335757174', '512017cc-7729-5f01-8c13-5004d9ebc70c', '5cc61bd1-3d73-52af-85a0-bc35697cc948', 'f30ae529-a03a-5252-8364-b679aeb69228', '5f7ea747-a34d-5e69-ab5b-556c41148c7c', '348f4483-9030-5dd5-8eb3-b523fda04a50', '13b78b32-26f0-53fd-9fa1-ae461f258c53', 'bf9113d8-290d-568c-8b90-67ab7886e306', '5112ae05-527f-5455-b5bc-3b634ad40458', '8eebca91-b927-5602-8c1b-cc0b600a2582', '31a2be63-9e80-5f7e-9edd-2f30f43d4eb6', '45f2153d-35af-5c79-aaf7-c40b52822505', '55040d52-b6be-5cb9-907b-d8386ffd2603', 'a912403f-7588-5184-82a2-464482286d08', 'ab010f00-6273-54bc-a9d3-fe2746fb3c96', '2b6790c9-b5c2-5e9d-a6bc-7141ed52cd01', 'e837019f-74ac-5462-93d4-48b4ffc30e29', 'e8af98c2-c5ba-5491-9c30-9fc8814483db', 'babd46bf-0286-5af5-a5d0-6af03f0d664f', 'e4dac40a-951f-50b6-8138-c8c3ce63116e', 'b5e725af-8d1f-50af-b188-41429c579da0', 'dab2b9c8-6df6-5d1d-a276-781843804335', '38260523-805e-53ca-8baf-a8603e5e1032', 'a2ab265b-1884-5323-9fe3-15e8d4c14a1d', 'eb5797b5-320d-5dfc-8fc3-a6c8250dffdc', '659ddeb8-6fb3-5a5f-bf04-34e098714399', '9d700b47-9e07-59d2-836e-e3c6c63b9d12', '3af6193f-dddb-57c9-8776-d5949c8bef0a', '6a45bf2e-9ebd-59f8-ad6a-ecf26f14b7bf', '25ed06b2-1352-5ca6-b157-779a0a6e31a2', 'b503bdaf-bc6e-5c12-8ae6-28e1f20d36af', '72a5a8ea-0126-5eeb-bf63-5f4629291555', '810fb975-00d4-523b-9be9-30cb7e9b1d39', '696dc7f7-83b9-5a49-a568-f97645ce1d3c', '4b6b8206-28fe-58c1-b62c-31986c9f9ed9', '794e4218-1a71-53b9-aedd-6dd8892217c4');
DELETE FROM public.chapters c WHERE c.subject_id = 'anglais-b1' AND c.id NOT IN ('d3573188-ea41-5396-b14c-c7c1f7fae1e1', 'd1dc7e47-b0d8-5f2d-866b-378c7e8e4f53', '589c4ce0-c4da-5533-947d-7432b122e351', '442e97bd-5019-5a8e-b7eb-861f9cf2b597', '97bbe81f-2f56-59be-a5de-bf2292f92b73', '103f22ad-0c64-534c-b534-dc30a036c9fb', '777eefdf-d77b-55c6-be60-dee5cdaf1fae', '3f0bbd99-331c-57c0-bf91-79e182a825a3') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('d3573188-ea41-5396-b14c-c7c1f7fae1e1', 'anglais-b1', 'The Present Perfect', 'Link the past to now with have/has + past participle: experiences (ever/never), recent actions (just/already/yet) and unfinished time (for/since) — and when to use it instead of the past simple.', '# ⚔️ The Present Perfect — The Bridge Between Past and Now

> 💡 «Some actions are over, yet their result still lives in the present. The present perfect is how English ties yesterday to today.»

## 🏰 What the present perfect is for

The **present perfect** connects a past action to **now**. We usually don''t say exactly _when_ it happened — what matters is the **result or relevance in the present**.

_I **have finished** my homework. (it''s done now) — She **has lost** her keys. (she can''t find them now)_

## ⚡ Form: have / has + past participle

| Subject             | Auxiliary      | + past participle      |
| ------------------- | -------------- | ---------------------- |
| I / you / we / they | **have** (''ve) | _worked / seen / been_ |
| he / she / it       | **has** (''s)   | _worked / seen / been_ |

Negative: **haven''t / hasn''t**. Question: _**Have** you…? **Has** she…?_

## 🛡️ Past participles: regular & irregular

Regular verbs use the same **-ed** form as the past simple (_worked, played, studied_). Many common verbs are irregular — learn the **third** column:

| Base  | Past  | Participle      |
| ----- | ----- | --------------- |
| go    | went  | **gone / been** |
| see   | saw   | **seen**        |
| do    | did   | **done**        |
| eat   | ate   | **eaten**       |
| write | wrote | **written**     |

> 🗡️ Tip: after _have/has_, never use the past simple — say _I have **seen** it_, not _~~I have saw it~~_.

## 🔮 Three core uses

1. **Experience** in your life so far — _ever / never_: _**Have** you **ever been** to Rome? I''ve **never tried** sushi._
2. **A recent action with a result now** — _just / already / yet_: _I''ve **just** arrived. She''s **already** left. They haven''t finished **yet**._
3. **Unfinished time up to now** — _for / since_: _I''ve lived here **for** ten years. We''ve known them **since** 2015._

> 🗡️ **for** + a length of time (_for two hours_); **since** + a starting point (_since Monday_).

## 🧭 Present perfect vs past simple

Use the **past simple** for a **finished time you can name** (_yesterday, last week, in 2010, two days ago_). Use the **present perfect** for an **unspecified** time or one that is **still relevant now**.

_I **saw** Sami yesterday. (finished time) — I **have seen** that film. (sometime; an experience)_

> ⚠️ Trap: never put a finished-time word with the present perfect: _~~I have seen him yesterday~~_ → **I saw him yesterday**.

## 🌍 gone vs been

_He **has gone** to Tunis._ = he is there now. — _He **has been** to Tunis._ = he visited and is back.

> 🏆 Gate cleared! The present perfect is the trickiest B1 tense — master it and the rest of B1 opens up. Next: the **past continuous**, for setting the scene of a story.', '# 📜 Résumé: The Present Perfect

- **Form** — _have / has_ + past participle (_I have worked, she has gone_); negatives _haven''t / hasn''t_.
- **Past participles** — regular _-ed_; irregulars must be learned (_see → seen, do → done, write → written, be → been_).
- **Experience** — _ever / never_: _Have you ever been…? I''ve never tried…_
- **Recent action, result now** — _just / already / yet_: _I''ve just arrived; she''s already left; not finished yet_.
- **Unfinished time up to now** — _for_ + a length (_for ten years_), _since_ + a start point (_since 2015_).
- **vs past simple** — a finished, named time → past simple (_I saw him yesterday_); unspecified or still-relevant → present perfect (_I''ve seen that film_).
- ⚠️ Never use a finished-time word (_yesterday, last week, in 2010_) with the present perfect.
- **gone vs been** — _has gone_ (still away) vs _has been_ (visited, now back).', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('d1dc7e47-b0d8-5f2d-866b-378c7e8e4f53', 'anglais-b1', 'The Past Continuous', 'Set the scene of a story with was/were + verb-ing: an action in progress at a past moment, background actions interrupted by the past simple, and the contrast of while and when.', '# ⚔️ The Past Continuous — Setting the Scene of the Story

> 💡 «Every great story needs a backdrop. The past continuous paints what was already happening when the action struck.»

## 🏰 What the past continuous is for

The **past continuous** describes an action that **was in progress** at a particular moment in the past. We zoom in on the middle of the action, not its start or end.

_At 8 p.m. I **was having** dinner. This time last year we **were living** in Tunis._

It is also the tense of **background and setting** — the scene a story unfolds against: _The sun **was shining** and the birds **were singing**._

## ⚡ Form: was / were + verb-ing

The past continuous is the past of _to be_ (**was / were**) plus the **-ing** form of the main verb:

| Subject           | Auxiliary | + -ing form         |
| ----------------- | --------- | ------------------- |
| I / he / she / it | **was**   | _working / playing_ |
| you / we / they   | **were**  | _working / playing_ |

Negative: **wasn''t / weren''t** + -ing (_She **wasn''t listening**_). Question: _**Was** she **sleeping**? What **were** you **doing**?_

> 🗡️ Match the auxiliary to the subject: _I/he/she/it_ → **was**, _you/we/they_ → **were**. Say _They **were** playing_, never _~~They was playing~~_.

## 🛡️ Spelling the -ing form

Most verbs simply add **-ing**, but watch three patterns:

| Rule                                        | Example                              |
| ------------------------------------------- | ------------------------------------ |
| ends in **-e** → drop the e, add -ing       | make → **making**                    |
| **one short vowel + consonant** → double it | run → **running**, sit → **sitting** |
| ends in **-ie** → change to **-ying**       | lie → **lying**                      |

_He was **making** tea. The kids were **running** outside. The cat was **lying** on the sofa._

> ⚠️ Trap: don''t keep a silent _-e_ (_~~makeing~~_ → **making**) and don''t forget to double the consonant (_~~runing, siting~~_ → **running, sitting**).

## 🔮 Interrupted action: past continuous vs past simple

This is the heart of the chapter. A **longer** action that was already in progress (past continuous) is **interrupted** by a **shorter**, completed action (past simple):

_I **was reading** when the phone **rang**. They **were sleeping** when the alarm **went off**._

The long background action takes the **past continuous**; the short event that cuts in takes the **past simple**.

> ⚠️ Trap: don''t put the background action in the past simple — _~~I read when the phone rang~~_ means a different thing. The action in progress must be **was reading**.

## 🧭 while + long action · when + short action

Two signal words split the work:

- **while** introduces the **long** action (past continuous): _**While** I **was cooking**, the doorbell rang._
- **when** introduces the **short** action (past simple): _I was cooking **when** the doorbell rang._

For **two long actions happening in parallel**, use the past continuous in both halves: _**While** she **was studying**, he **was watching** TV._

> 🗡️ Quick test: _while_ + _was/were …-ing_, _when_ + past simple. If both clauses are long and parallel, both are continuous.

## 🌍 Stative verbs stay simple

Verbs of **state** — _know, want, like, believe, be_ — describe a condition, not an action, so they are **not** normally used in the continuous. Use the past simple instead.

_I **knew** the answer. (not ~~I was knowing the answer~~) — She **wanted** to leave. (not ~~was wanting~~)_

> 🏆 Gate cleared! You can now set any scene and interrupt it on cue. Next: **conditionals** — _if_ this happens, that follows — where you bend past, present, and future to your will.', '# 📜 Résumé: The Past Continuous

- **Use** — an action in progress at a past moment (_At 8 p.m. I was having dinner_) and the background/setting of a story.
- **Form** — _was / were_ + verb-**ing** (_I was working, they were playing_); negatives _wasn''t / weren''t_ + -ing.
- **Questions** — _Was she sleeping? What were you doing?_
- **Agreement** — _I/he/she/it_ → **was**, _you/we/they_ → **were** (never _they was_).
- **-ing spelling** — _make → making_ (drop -e), _run → running_ / _sit → sitting_ (double the consonant), _lie → lying_.
- **Interrupted action** — long background action (past continuous) cut by a short event (past simple): _I was reading when the phone rang_.
- **while vs when** — _while_ + the long action (_while I was cooking_), _when_ + the short action (_when the doorbell rang_).
- **Two parallel actions** — both in the past continuous: _While she was studying, he was watching TV_.
- ⚠️ **Stative verbs** (_know, want, like, be_) are normally NOT used in the continuous — use the past simple (_I knew_, not _I was knowing_).', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('589c4ce0-c4da-5533-947d-7432b122e351', 'anglais-b1', 'Conditionals (Zero, First, Second)', 'Talk about consequences with if: the zero conditional for facts (if + present, present), the first for real future situations (if + present, will + base) and the second for unreal or hypothetical ones (if + past, would + base) — and the rule that will and would never go inside the if-clause.', '# ⚔️ Conditionals — The Art of "What If"

> 💡 «Every choice has a consequence. Conditionals are how English maps a cause to its effect — from certain facts to wild daydreams.»

## 🏰 What a conditional sentence is

A **conditional** has two halves: an **if-clause** (the condition) and a **result clause** (the consequence). Change the tenses and you change the _meaning_ — from a guaranteed fact, to a likely future, to a pure fantasy.

_**If** you heat ice, it **melts**. — **If** it **rains**, I **''ll stay** in. — **If** I **won** the lottery, I **would travel** the world._

> 🗡️ Punctuation rule: when the **if-clause comes first**, put a **comma** before the result (_If it rains, I''ll stay in_). When the result comes first, no comma is needed (_I''ll stay in if it rains_).

## ⚡ The zero conditional — general truths

Use the **zero conditional** for things that are **always true**: facts, science, habits, instructions. Both halves are in the **present simple**.

**Form:** _If + present simple, … present simple._

_If you **mix** blue and yellow, you **get** green. — If water **reaches** 100°C, it **boils**. — If I **''m** tired, I **go** to bed early._

Here _if_ means roughly **"whenever"** — the result is automatic, not a one-time future event.

## 🛡️ The first conditional — real future

Use the **first conditional** for a **real, possible future** situation and its likely result. The if-clause stays in the **present simple**; the result uses **will** (or **won''t**) + the base verb.

**Form:** _If + present simple, … will + base verb._

_If it **rains** tomorrow, I **''ll stay** at home. — If you **study** hard, you **''ll pass** the exam. — If we **don''t hurry**, we **''ll miss** the bus._

> ⚠️ Classic trap: **never** put _will_ in the if-clause. Say _If it **rains**…_, never _~~If it will rain…~~_. The condition is in the present, even though it points to the future.

## 🔮 The second conditional — unreal & hypothetical

Use the **second conditional** for situations that are **imaginary, unlikely, or untrue now** — daydreams and pure hypotheses. The if-clause moves to the **past simple**; the result uses **would** (or **wouldn''t**) + the base verb.

**Form:** _If + past simple, … would + base verb._

_If I **won** the lottery, I **would travel** the world. — If she **had** more time, she **would learn** Japanese. — If we **lived** by the sea, we **''d swim** every day._

The past tense here does **not** mean past time — it signals **distance from reality**. To give advice, the fixed phrase is **If I were you** (standard form with _were_ for every subject): _If I **were** you, I **''d apologise**._

> 🗡️ Tip: _would_ belongs in the **result** only — _If I **had**… I **would**…_, never _~~If I would have…~~_.

## 🧭 The three forms side by side

| Type   | Use                       | If-clause        | Result clause      | Example                           |
| ------ | ------------------------- | ---------------- | ------------------ | --------------------------------- |
| Zero   | general truth / fact      | _present simple_ | _present simple_   | _If you heat ice, it **melts**._  |
| First  | real, likely future       | _present simple_ | _**will** + base_  | _If it rains, I **''ll stay** in._ |
| Second | unreal / hypothetical now | _past simple_    | _**would** + base_ | _If I won, I **would travel**._   |

The split is simple: **will → real future**, **would → imaginary**. And whatever the type, the helper (_will_ / _would_) lives in the **result**, never in the _if_.

> ⚠️ Trap: don''t **mix** the conditionals. It''s either _If I **win**, I **will**…_ (first) or _If I **won**, I **would**…_ (second) — never _~~If I win, I would…~~_ or _~~If I won, I will…~~_.

## 🧪 After will / would: always the base verb

Both _will_ and _would_ are followed by the **bare base verb** — no _to_, no _-s_, no _-ed_.

_She will **go** (not ~~will to go~~, not ~~will goes~~). — He would **come** (not ~~would comes~~, not ~~would to come~~)._

> 🏆 Gate cleared! You can now reason about facts, real plans and pure fantasies. The doorway beyond this is **modal verbs** (_can, must, should, might_) — the precise tools for ability, obligation and possibility.', '# 📜 Résumé: Conditionals

- **Two halves** — an _if-clause_ (the condition) + a _result clause_ (the consequence); the tenses you choose decide the meaning.
- **Comma rule** — put a comma when the _if-clause_ comes first (_If it rains, I''ll stay in_); none when the result comes first (_I''ll stay in if it rains_).
- **Zero conditional** — general truths/facts: _if + present simple, … present simple_ (_If you heat ice, it melts_). Here _if_ ≈ _whenever_.
- **First conditional** — real, likely future: _if + present simple, … will + base_ (_If it rains, I''ll stay in_).
- **Second conditional** — unreal/hypothetical now: _if + past simple, … would + base_ (_If I won, I would travel_). The past = distance from reality, not past time.
- **Advice phrase** — _If I were you, I''d…_ uses _were_ for every subject.
- ⚠️ **Never** put _will_ or _would_ inside the _if-clause_ (_If it rains…_, not _If it will rain…_).
- ⚠️ **Don''t mix** the types: _If I win, I will…_ (first) or _If I won, I would…_ (second) — not a blend of the two.
- **Base verb** — _will_ and _would_ are always followed by the bare base verb (_will go_, _would come_, never _will to go_ / _would goes_).', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('442e97bd-5019-5a8e-b7eb-861f9cf2b597', 'anglais-b1', 'Modals of Obligation & Advice', 'Say what is necessary, forbidden, optional or wise with must, have to, mustn''t, don''t have to and should — and master the classic contrast between mustn''t (forbidden) and don''t have to (not necessary).', '# ⚔️ Modals of Obligation & Advice — The Rules of the Realm

> 💡 «Every quest has its rules: what you must do, what is forbidden, what is optional, and what is simply wise. These five modals are how English gives orders and advice.»

## 🏰 What these modals do

A **modal** is a helper verb that adds meaning to a main verb. This chapter''s modals tell you about **rules and choices**: what is **necessary** (_must / have to_), what is **forbidden** (_mustn''t_), what is **optional** (_don''t have to_), and what is a **good or bad idea** (_should / shouldn''t_).

_You **must** wear a seatbelt. You **mustn''t** smoke here. You **don''t have to** come. You **should** see a doctor._

## ⚡ The map of meanings

Learn this table by heart — choosing the wrong modal changes the whole message.

| Modal              | Meaning                       | Example                              |
| ------------------ | ----------------------------- | ------------------------------------ |
| **must / have to** | obligation, it is necessary   | _I **must** finish this today._      |
| **mustn''t**        | prohibition, it is forbidden  | _You **mustn''t** park here._         |
| **don''t have to**  | no obligation, it is optional | _You **don''t have to** wait for me._ |
| **should**         | advice, a good idea           | _You **should** rest more._          |
| **shouldn''t**      | advice against, a bad idea    | _You **shouldn''t** eat so late._     |

## 🛡️ Form: always the base verb

Every modal here is followed by the **base verb** — no _to_, no _-s_, no _-ing_.

_She **must go** now._ — _He **should see** a doctor._ — _They **mustn''t be** late._

The one exception in spelling is **have to**, a semi-modal that **agrees** with the subject: _I/you/we/they_ **have to**, but _he/she/it_ **has to**.

_I **have to** study. — She **has to** study._

> 🗡️ Tip: never add _to_ after _must_, _mustn''t_ or _should_. Say _You **must wait**_ and _You **should call**_, never _~~must to wait~~_ or _~~should to call~~_.

## 🔮 must vs have to

Both express obligation and are usually interchangeable. A subtle difference: **must** often signals the speaker''s own feeling or a written rule (_I must call my mother_), while **have to** points to an outside obligation (_I have to wear a uniform at work_). For past obligation, both become **had to**: _Yesterday I **had to** work late._

_You **must** try this cake! (my strong recommendation) — I **have to** renew my passport. (the law requires it)_

## 🧭 should — the voice of advice

Use **should / shouldn''t** to recommend, not to command. It is softer than _must_: it means _it is a good idea_, not _it is required_.

_You **should** drink more water. — You **shouldn''t** drink so much coffee. — **Should** I apologise?_

> 🗡️ Tip: in questions, the modal comes first: _**Should** I call her?_ — _**Do** I **have to** sign this?_ (_have to_ uses _do_ in questions).

## ⚠️ The great trap: mustn''t ≠ don''t have to

This is the most important contrast in the chapter — and the classic B1 error.

- **mustn''t** = it is **forbidden**. _You **mustn''t** park here_ = parking is **not allowed**; don''t do it.
- **don''t have to** = it is **not necessary**. _You **don''t have to** park here_ = it is **optional**; you can if you want.

They are **opposites, not synonyms**. _Mustn''t_ closes the door; _don''t have to_ leaves it open.

_You **mustn''t** tell anyone. (it''s a secret — forbidden) — You **don''t have to** tell anyone. (it''s up to you — optional)_

> 🏆 Gate cleared! You can now command, forbid, free and advise like a native. Next quest: **relative clauses** (_who, which, that_) — the tool that joins two ideas into one elegant sentence.', '# 📜 Résumé: Modals of Obligation & Advice

- **must / have to** — obligation, it is necessary (_I must finish this; I have to wear a uniform_).
- **mustn''t** — prohibition, it is forbidden (_You mustn''t smoke here_ = don''t do it).
- **don''t have to** — no obligation, it is optional (_You don''t have to come_ = you can if you want).
- ⚠️ **mustn''t ≠ don''t have to** — _mustn''t_ = forbidden; _don''t have to_ = not necessary. They are opposites, not synonyms.
- **should / shouldn''t** — advice, a good or bad idea (_You should rest; you shouldn''t worry_) — softer than _must_.
- **Base verb always** — modal + base, no _to_ and no _-s_ (_she must go_, _you should call_), never _~~must to go~~_.
- **have to agrees** — _I/you/we/they have to_, but _he/she/it has to_ (_She has to study_).
- **Questions** — _Should I…?_ (modal first); _have to_ uses _do_: _Do I have to…?_
- **Past** — _must_ and _have to_ both become **had to** (_Yesterday I had to work late_).', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('97bbe81f-2f56-59be-a5de-bf2292f92b73', 'anglais-b1', 'Relative Clauses', 'Join two ideas into one with relative pronouns: who for people, which for things, that for either, where for places and whose for possession — defining clauses that take no commas, and the object pronoun you can leave out.', '# ⚔️ Relative Clauses — Forge Two Sentences Into One

> 💡 «A skilled storyteller never repeats a noun. Relative clauses are the chain that links two ideas into a single, smooth blade.»

## 🏰 What a relative clause does

A **relative clause** adds information about a noun without starting a new sentence. Instead of saying two short sentences, you weld them together with a **relative pronoun**.

_I know a man. He repairs bikes._ → _I know a man **who** repairs bikes._

The relative pronoun (_who, which, that, where, whose_) points back to the noun and introduces the extra information.

## ⚡ The relative pronouns at a glance

Each pronoun matches a kind of noun. Learn this table — it is the heart of the whole chapter.

| Pronoun   | Use it for           | Example                                       |
| --------- | -------------------- | --------------------------------------------- |
| **who**   | people               | _The girl **who** sits next to me is Lina._   |
| **which** | things / animals     | _The phone **which** broke was new._          |
| **that**  | people **or** things | _The film **that** we saw was great._         |
| **where** | places               | _The town **where** I was born is small._     |
| **whose** | possession           | _The boy **whose** bag was stolen is crying._ |
| **when**  | times                | _I remember the day **when** we met._         |

> 🗡️ Tip: **that** is the all-rounder. In everyday, informal English it replaces _who_ (for people) and _which_ (for things): _the man **that** called_, _the book **that** I read_. Both are correct.

## 🛡️ Defining clauses take NO commas

A **defining** relative clause gives **essential** information — it tells you _which_ one we mean. Remove it and the sentence loses its point. Defining clauses take **no commas**.

_The student **who won the prize** is my cousin._ (which student? — the one who won)

Without the clause, _the student_ could be anyone. The clause is doing real work, so no commas separate it.

## 🔮 "Whose" and "where" — the special agents

**Whose** shows **possession** — it replaces _his / her / its / their_. It works for people and things.

_That''s the woman **whose** car was stolen._ (her car) — _A house **whose** roof is red…_ (its roof)

**Where** points to a **place**, replacing _in / at / on which_.

_This is the diner **where** we first met._ (= the diner in which we met)

> ⚠️ Trap: never use **what** as a relative pronoun. Say _the thing **that** I need_, never _~~the thing what I need~~_. And don''t confuse **whose** (possession) with **who''s** (= _who is_): _the man **whose** son…_ vs _the man **who''s** here_.

## 🧭 Leaving out the pronoun (object clauses)

When the relative pronoun is the **object** of its clause — the _thing acted on_, not the doer — you can **drop it** completely. The sentence stays perfectly correct.

_The film **(that)** we watched was great._ — _The man **(who)** I met yesterday called again._

But when the pronoun is the **subject** (the doer), you **cannot** leave it out:

_The man **who** lives next door…_ → never _~~the man lives next door~~_.

> 🗡️ Quick test: if a noun or pronoun (_we, I, she_) comes straight after the relative pronoun, the pronoun is the object — you may drop it. If a verb comes next, it''s the subject — keep it.

## 🌍 Defining vs the rest

Use **who / which / that** to identify _which_ person or thing, **where** for the place, and **whose** for the owner: _the woman **who** called, the phone **which** broke, the city **where** I live, the man **whose** car was stolen._ Choose the pronoun by what the noun **is**, not by what sounds familiar.

> 🏆 Final B1 gate cleared! Relative clauses are the last competence of your intermediate journey — with them you can link ideas like a fluent speaker. You''ve conquered the present perfect, the past, conditionals, modals and now relative clauses. Your reward awaits: the **B1 Donjon**, where every B1 skill is tested at once in a single varied gauntlet. Step in, hero.', '# 📜 Résumé: Relative Clauses

- **Purpose** — a relative clause adds information about a noun so you join two sentences into one (_I know a man who repairs bikes_).
- **who** — for people: _the girl who sits next to me_.
- **which** — for things and animals: _the phone which broke_.
- **that** — the all-rounder, for people **or** things, very common in informal English: _the film that we saw_.
- **where** — for places (= _in/at which_): _the town where I was born_.
- **whose** — for possession, replacing _his/her/its/their_: _the boy whose bag was stolen_.
- **when** — for times: _the day when we met_.
- **Defining clauses take no commas** — they give essential information that tells you _which_ one (_the student who won the prize is my cousin_).
- **Drop the object pronoun** — when the pronoun is the object you can leave it out: _the film (that) we watched_; but keep it when it is the subject (_the man who lives next door_).
- ⚠️ Never use **what** as a relative pronoun (_the thing that I need_, not _the thing what I need_), and don''t confuse **whose** (possession) with **who''s** (= _who is_).', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('103f22ad-0c64-534c-b534-dc30a036c9fb', 'anglais-b1', 'Past Habits: Used to and Would', 'Talk about past states and repeated habits with used to and would — and avoid mixing them up with the past simple or confusing would with be/get used to + -ing.', '# 🏚️ Past Habits: Used to and Would — Memories from Another Time

> 💡 «When you look back at your childhood and say "things were different then", English has two special weapons for the job: _used to_ and _would_.»

## 🏰 Used to + base verb — past states AND habits

**Used to** refers to something that was **true in the past but is no longer true now** — it can be a state or a repeated action.

| Subject                        | Form                              | Example                                   |
| ------------------------------ | --------------------------------- | ----------------------------------------- |
| I / you / he / she / we / they | **used to** + base verb           | _I **used to live** in Tunis._            |
| negative                       | **didn''t use to** + base verb     | _She **didn''t use to like** coffee._      |
| question                       | **Did** … **use to** + base verb? | **\*Did** you **use to** play football?\* |

_He **used to be** very shy._ (state — now he isn''t) — _We **used to walk** to school every day._ (repeated habit)

> ⚠️ Trap: in negatives and questions, the **-d** disappears: _Did you use to…?_ (NOT ~~Did you used to~~ )

## ⚡ Would + base verb — repeated past actions ONLY

**Would** can replace _used to_ for **repeated past actions**, but **NOT for states**.

_Every summer, we **would visit** my grandmother._ ✔ (repeated action)
_I **would live** near the sea._ ✘ → use _I **used to live** near the sea._ (state — "live" is a state here)

> 🗡️ Tip: if the verb is a state verb (be, have, know, like, love, hate, want, believe), **only used to** works — never _would_.

Common state verbs that **cannot take would**:

| State verb | Correct                         | Wrong                           |
| ---------- | ------------------------------- | ------------------------------- |
| be         | _I used to be nervous._         | ~~I would be nervous.~~         |
| have       | _She used to have a dog._       | ~~She would have a dog.~~       |
| know       | _They used to know each other._ | ~~They would know each other.~~ |

## 🗡️ Used to vs Past Simple

Both describe finished past situations, but _used to_ adds the idea that things are **different now**.

_I **used to play** tennis._ (I don''t play now — there''s an implied contrast)
_I **played** tennis last Saturday._ (just a past event — no contrast with now)

Use the **past simple** for a single past event; use _used to_ for a long-lasting state or a habit over time.

## 🔮 Be/Get used to + -ing — a DIFFERENT structure!

**Be used to** and **get used to** are **completely different** from _used to_. They mean "be/become accustomed to."

| Structure                     | Meaning             | Example                                        |
| ----------------------------- | ------------------- | ---------------------------------------------- |
| **be used to** + -ing / noun  | already accustomed  | _I **am used to waking** up early._            |
| **get used to** + -ing / noun | becoming accustomed | _She is **getting used to** the cold weather._ |

> ⚠️ Trap: after _be/get used to_, the next verb is always **-ing** (gerund), NOT the base: _I''m used to **working** late._ (NOT ~~I''m used to work late~~)

> 🗡️ Tip: spot the difference — _used to work_ (past habit, no longer true) vs _be used to working_ (accustomed now).

## 🧭 Quick comparison table

| Structure            | Tense     | Use                                | Example                             |
| -------------------- | --------- | ---------------------------------- | ----------------------------------- |
| _used to_ + base     | past only | past state or habit (now finished) | _I used to hate mornings._          |
| _would_ + base       | past only | past repeated action only          | _We would play cards after dinner._ |
| _be used to_ + -ing  | any tense | accustomed to                      | _I''m used to long journeys._        |
| _get used to_ + -ing | any tense | becoming accustomed                | _She got used to the noise._        |

> 🏆 Quest complete! You can now describe the past like a real storyteller. Next up: the action-packed world of **Phrasal Verbs**.', '# 📜 Résumé: Past Habits: Used to and Would

- **used to + base verb** — past state or repeated habit that is **no longer true**: _I used to live in Tunis; she used to hate coffee._
- **Negative/question** — the -d drops: _I didn''t use to…; Did you use to…?_
- **would + base verb** — repeated past **action** only (not states): _We would visit my grandmother every summer._
- **State verbs (be, have, know, like, love, hate, want)** → only _used to_, never _would_: _I used to be shy._ (NOT ~~I would be shy~~)
- **used to vs past simple** — _used to_ implies contrast with now; past simple is just a past fact: _I used to play tennis_ (I don''t now) vs _I played tennis last Saturday_ (single event).
- **be used to + -ing** — already accustomed: _I am used to waking up early._
- **get used to + -ing** — becoming accustomed: _She got used to the cold weather._
- ⚠️ After _be/get used to_, always use **-ing**, never the base: _used to working_ NOT ~~used to work~~.
- ⚠️ Don''t confuse _used to do_ (past habit) with _be used to doing_ (accustomed now) — they look similar but mean very different things.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('777eefdf-d77b-55c6-be60-dee5cdaf1fae', 'anglais-b1', 'Phrasal Verbs', 'Master the essential multi-word verbs of English — verb + particle combinations — distinguishing literal from idiomatic meanings and separable from inseparable structures, with the most common B1 phrasal verbs in context.', '# 🗡️ Phrasal Verbs — The Secret Weapons of English

> 💡 «A native speaker doesn''t "extinguish" a fire — they **put it out**. Welcome to phrasal verbs: two small words that pack a mighty punch.»

## 🏰 What is a Phrasal Verb?

A **phrasal verb** = **verb + particle** (preposition or adverb). Together, they create a new, often **idiomatic** meaning — different from the words alone.

| Verb | + Particle | New Meaning             | Example                              |
| ---- | ---------- | ----------------------- | ------------------------------------ |
| give | up         | stop trying / surrender | _She **gave up** smoking._           |
| find | out        | discover                | _I need to **find out** the answer._ |
| look | after      | take care of            | _He **looks after** his sister._     |
| get  | up         | rise from bed           | _I **got up** at seven._             |
| turn | on         | activate / switch on    | _Can you **turn on** the light?_     |
| turn | off        | deactivate / switch off | _Please **turn off** your phone._    |
| put  | off        | delay / postpone        | _Don''t **put off** your homework!_   |

## ⚡ Literal vs Idiomatic Meaning

Some phrasal verbs keep a **literal** meaning (you can guess it):

_She **went up** the stairs._ → went + up = climbed upward (literal)

Others are **idiomatic** — you must learn them:

_Don''t **give up**!_ → give + up ≠ physically give something upward → it means _stop trying_ (idiomatic)

> ⚠️ Trap: never guess an idiomatic phrasal verb from its parts. _She **looked after** the cat_ does NOT mean she looked behind the cat — it means she took care of it.

## 🔮 Separable vs Inseparable Phrasal Verbs

This is the most important grammar rule for phrasal verbs.

### Separable phrasal verbs

The **object can go between** the verb and the particle OR after the particle:

| Particle after object | Particle split        | Rule                             |
| --------------------- | --------------------- | -------------------------------- |
| _Turn on **the TV**._ | _Turn **the TV** on._ | ✔ both fine with a noun          |
| _Turn on **it**._     | _Turn **it** on._ ✔   | ⚠️ pronoun MUST go in the middle |

> 🗡️ Tip: when the object is a **pronoun** (it, him, her, them), you **must** separate: _Turn **it** on._ (NOT ~~Turn on it.~~)

### Inseparable phrasal verbs

The object always comes **after** the particle — never in the middle:

_She **looks after** her grandmother._ ✔
_She **looks** her grandmother **after**._ ✘

Common inseparable phrasal verbs:

| Phrasal verb        | Meaning                  | Example                            |
| ------------------- | ------------------------ | ---------------------------------- |
| **look after**      | take care of             | _She looks after the baby._        |
| **get on** (with)   | have a good relationship | _Do you get on with your boss?_    |
| **run into**        | meet by chance           | _I ran into an old friend._        |
| **look forward to** | feel excited about       | _I''m looking forward to the trip._ |

> ⚠️ Trap: _look forward to_ is inseparable AND takes **-ing** (gerund) after _to_: _I''m looking forward to **meeting** you._ (NOT ~~to meet~~)

## 🧭 Key B1 Phrasal Verbs — Quick Reference

| Phrasal verb   | Meaning                  | Type         | Example                    |
| -------------- | ------------------------ | ------------ | -------------------------- |
| **get up**     | rise from bed            | inseparable  | _I get up at 6._           |
| **give up**    | stop / quit              | separable    | _Don''t give it up!_        |
| **find out**   | discover                 | separable    | _I found out the truth._   |
| **turn on**    | switch on                | separable    | _Turn the radio on._       |
| **turn off**   | switch off               | separable    | _Turn it off please._      |
| **put off**    | postpone                 | separable    | _She put off the meeting._ |
| **look after** | take care of             | inseparable  | _He looks after his dog._  |
| **look up**    | search / look to the sky | separable    | _Look the word up._        |
| **run out of** | have no more of          | inseparable  | _We''ve run out of milk._   |
| **set off**    | begin a journey          | intransitive | _We set off at dawn._      |

## 🗡️ Multiple Particles — Three-word phrasal verbs

Some phrasal verbs have **two particles** and are always inseparable:

_I''m looking forward **to seeing** you._
_We''ve run out **of** coffee._
_Can you come up **with** an idea?_ (come up with = think of)

> 🏆 Quest complete! You now hold the key to one of English''s most powerful systems. Next: tackle real texts in **Reading Comprehension**.', '# 📜 Résumé: Phrasal Verbs

- A **phrasal verb** = verb + particle (preposition or adverb) → creates a new meaning.
- **Literal**: _go up the stairs_ (upward motion — guessable).
- **Idiomatic**: _give up_ (stop trying — must be learned, not guessed).

## Separable vs Inseparable

- **Separable**: object can go after the particle OR between verb + particle.
  - Noun: _Turn on the TV_ or _Turn the TV on_ — both correct.
  - Pronoun: MUST separate → _Turn **it** on._ (NEVER _Turn on it._)
- **Inseparable**: object ALWAYS after the particle.
  - _She looks after her sister._ (never _looks her sister after_)

## Key B1 Phrasal Verbs

| Phrasal verb    | Meaning                     | Type         |
| --------------- | --------------------------- | ------------ |
| get up          | rise from bed               | inseparable  |
| give up         | stop / quit                 | separable    |
| find out        | discover                    | separable    |
| turn on / off   | switch on / off             | separable    |
| put off         | postpone                    | separable    |
| look after      | take care of                | inseparable  |
| look up         | search for                  | separable    |
| run out of      | have no more of             | inseparable  |
| set off         | begin a journey             | intransitive |
| get on (with)   | have a good relationship    | inseparable  |
| run into        | meet by chance              | inseparable  |
| look forward to | feel excited about (+ -ing) | inseparable  |

## ⚠️ Traps

- Never guess the meaning of an idiomatic phrasal verb from its parts.
- **Pronouns MUST go in the middle** of separable verbs: _pick it up_, not _pick up it_.
- _look forward to_ takes **-ing** after _to_: _looking forward to meeting_ (not _to meet_).
- Three-word phrasal verbs (_run out of_, _come up with_) are always inseparable.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('3f0bbd99-331c-57c0-bf91-79e182a825a3', 'anglais-b1', 'Reading Comprehension: Texts and Inference', 'Build B1 reading skills across real-world text types — articles, stories, emails and notices — learning to identify main ideas, locate specific details, make basic inferences, and work out vocabulary meaning from context.', '# 📖 Reading Comprehension: Texts and Inference

> 💡 «A B1 reader doesn''t read every word — they _hunt_ for the right information. Learn the strategies and you''ll answer questions faster and more accurately.»

## 🏰 Types of Reading at B1

At B1 level you will encounter several types of texts:

| Text type             | What it is                    | Example                     |
| --------------------- | ----------------------------- | --------------------------- |
| **Article**           | informational or opinion text | blog post, magazine article |
| **Story / narrative** | sequence of events            | short fiction, anecdote     |
| **Email / message**   | personal or professional      | invitation, complaint       |
| **Notice / advert**   | short public information      | sign, announcement, flyer   |

You need three reading **skills**: find the **main idea**, locate **specific details**, and make **inferences**.

## ⚡ Strategy 1 — Read the Question FIRST

Before reading the text, read every question. This tells you **what to look for** and saves time.

> 🗡️ Tip: underline key words in each question. When you read the text, you are scanning for those key words — not absorbing every sentence.

## 🔮 Strategy 2 — Main Idea vs Specific Detail

- **Main idea** = what is the text MAINLY about? → skim the title, first paragraph, and final sentence.
- **Specific detail** = a fact, number, name, or event mentioned in the text → scan for the exact word.

_The article is about a young chef who opened a restaurant._ (main idea)
_The restaurant opened in March 2022._ (specific detail — scan for a date)

> ⚠️ Trap: a "main idea" distractor often picks a detail that is true but too narrow — it mentions something in the text but not the central topic.

## 🧭 Strategy 3 — Inference (Reading Between the Lines)

An **inference** is a conclusion you draw from clues in the text — it is not stated directly.

_Text: "Nour arrived at the office at 7 a.m. Her colleagues were still sleeping."_
_Inference: Nour came to work unusually early._

Steps for inference questions:

1. Find the relevant part of the text.
2. Ask: what does this **suggest** or **imply** that is not directly said?
3. Choose the option that follows logically from the clues.

> ⚠️ Trap: do not use your **general knowledge** or personal opinions. The answer must come from the text — only from the text.

## 🗡️ Strategy 4 — Vocabulary in Context

When you don''t know a word, use the **surrounding words and sentence** to guess its meaning.

_"The hikers were exhausted. They sat down and refused to walk another step."_
→ _exhausted_ must mean very tired (because they sat down and refused to walk).

Steps:

1. Re-read the whole sentence containing the word.
2. Look for clues: cause-and-effect, contrast words (_but_, _however_, _although_), synonyms nearby.
3. Replace the word with each option and check which makes logical sense.

> 🗡️ Tip: contrast words (_but_, _however_, _although_, _despite_) often mean the unknown word is the **opposite** of what comes before.

## 🔮 Strategy 5 — True / False / Not Given

A common question type: you must decide if a statement is:

- **True** — the text explicitly supports it.
- **False** — the text explicitly contradicts it.
- **Not Given** — the text says nothing about it.

> ⚠️ Trap: **Not Given ≠ False**. If the text simply doesn''t mention a topic, it is Not Given — not False. False means the text says the _opposite_.

## 🧭 Strategy 6 — Elimination

When unsure, eliminate clearly wrong answers:

1. Cross out any option that **contradicts** the text.
2. Cross out any option that uses **extreme language** not in the text (_always_, _never_, _all_, _none_) unless the text says so.
3. Cross out options that **distort** what the text says (a detail mixed up or exaggerated).

The remaining option is almost always correct.

> 🏆 Quest complete! You now have a full B1 reading toolkit. Use these strategies on every text — articles, stories, emails, notices — and watch your accuracy climb.', '# 📜 Résumé: Reading Comprehension: Texts and Inference

## B1 Text Types

- **Articles** (blog, magazine), **stories/narratives**, **emails/messages**, **notices/adverts**.

## Six Reading Strategies

1. **Read the question first** — know what to look for before reading the text.
2. **Main idea vs specific detail**
   - Main idea → skim title, first and last paragraph.
   - Specific detail → scan for key words, names, numbers, dates.
3. **Inference** — a logical conclusion not directly stated in the text.
   - Find the relevant clue → ask what it _suggests_ → pick what follows logically.
   - Never use general knowledge — stay inside the text.
4. **Vocabulary in context** — use surrounding words/sentences to guess meaning.
   - Contrast words (_but_, _however_, _although_) often signal the opposite meaning.
5. **True / False / Not Given**
   - True = text explicitly supports it.
   - False = text explicitly contradicts it.
   - Not Given = text says nothing about it (≠ False).
6. **Elimination** — cross out options that contradict the text, use extreme language not in the text, or distort a detail.

## ⚠️ Traps

- A "main idea" distractor picks a true detail that is too **narrow** — it''s in the text but not the central point.
- **Not Given ≠ False**. Silence on a topic is Not Given, not False.
- Extreme words (_always_, _never_, _all_) are wrong unless the text actually says them.
- Inference answers must be supported by text clues — not by your personal knowledge or opinion.', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('40fd289c-37a4-53db-93d9-38b367e29e5f', 'd3573188-ea41-5396-b14c-c7c1f7fae1e1', 'anglais-b1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d21f78fc-18fc-5d23-844f-76c0ba5c1a9c', '40fd289c-37a4-53db-93d9-38b367e29e5f', 'Complete: "She ___ her homework, so she''s free now."', '[{"id":"a","text":"have finished"},{"id":"b","text":"has finished"},{"id":"c","text":"has finish"},{"id":"d","text":"is finished"}]'::jsonb, 'b', 'The present perfect is have/has + past participle. With she we use has + finished: She has finished. "have" is for I/you/we/they, "has finish" is missing the participle ending -ed, and "is finished" is passive, not the present perfect.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('770935af-8772-597c-bd88-e45d10860635', '40fd289c-37a4-53db-93d9-38b367e29e5f', 'Complete: "I have ___ that film before."', '[{"id":"a","text":"saw"},{"id":"b","text":"see"},{"id":"c","text":"seen"},{"id":"d","text":"seed"}]'::jsonb, 'c', 'After have/has you need the past participle, not the past simple: I have seen. The verb see goes see → saw (past) → seen (participle). "saw" is the past simple, "see" is the base, and "seed" is not a verb form.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9ebefaa9-16f9-52c8-ad20-4aa6273fc1a3', '40fd289c-37a4-53db-93d9-38b367e29e5f', 'Complete: "We have lived in this town ___ 2015."', '[{"id":"a","text":"for"},{"id":"b","text":"during"},{"id":"c","text":"ago"},{"id":"d","text":"since"}]'::jsonb, 'd', 'Use since with a starting point in time (since 2015) and for with a length of time (for ten years). "during" needs an event (during the summer) and "ago" counts back from now with the past simple, not since.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b8adf2a-9e97-533c-80a6-f072e4cf724e', '40fd289c-37a4-53db-93d9-38b367e29e5f', 'Complete: "I ___ Sami yesterday at the market."', '[{"id":"a","text":"have seen"},{"id":"b","text":"has seen"},{"id":"c","text":"saw"},{"id":"d","text":"have saw"}]'::jsonb, 'c', '"yesterday" is a finished time, so we use the past simple: I saw Sami yesterday. The present perfect (have/has seen) cannot go with a finished-time word like yesterday, and "have saw" also uses the wrong participle.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd98b25a-37f5-56f1-b00a-105cf533d89d', '40fd289c-37a4-53db-93d9-38b367e29e5f', 'Complete: "Have you finished your essay ___?"', '[{"id":"a","text":"yet"},{"id":"b","text":"already"},{"id":"c","text":"since"},{"id":"d","text":"ever"}]'::jsonb, 'a', 'In questions and negatives about something expected, we use yet, usually at the end: Have you finished yet? "already" is for affirmatives (I''ve already finished), and "since/ever" express a start point or life experience, not this idea.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a1e6f69c-9aa0-5447-a0f9-1e2f81479615', 'd3573188-ea41-5396-b14c-c7c1f7fae1e1', 'anglais-b1', '⭐ Practice: Form & Past Participles', 1, 50, 10, 'practice', 'admin', 1)
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
  ('25605f4a-30a8-5d60-8140-139d856a0ab0', 'a1e6f69c-9aa0-5447-a0f9-1e2f81479615', 'Complete: "They ___ just arrived at the station."', '[{"id":"a","text":"has"},{"id":"b","text":"have"},{"id":"c","text":"are"},{"id":"d","text":"had"}]'::jsonb, 'b', 'They takes have in the present perfect: They have just arrived. Has is only for he/she/it, "are" would make a continuous form, and "had" is the past perfect, not the present perfect.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('863cec36-9b4c-5aab-bd2b-68c363f61ab2', 'a1e6f69c-9aa0-5447-a0f9-1e2f81479615', 'Complete: "I have ___ all my homework."', '[{"id":"a","text":"did"},{"id":"b","text":"do"},{"id":"c","text":"doed"},{"id":"d","text":"done"}]'::jsonb, 'd', 'do is irregular: do → did (past) → done (participle). After have we need the participle: I have done. "did" is the past simple, "do" is the base, and "doed" is not a word.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ae5d7f5-7a89-5a88-aa95-a1eb129e68ec', 'a1e6f69c-9aa0-5447-a0f9-1e2f81479615', 'Complete: "He ___ lost his wallet again."', '[{"id":"a","text":"have"},{"id":"b","text":"is"},{"id":"c","text":"has"},{"id":"d","text":"had"}]'::jsonb, 'c', 'He takes has + the participle: He has lost his wallet. Have is for I/you/we/they, "is" doesn''t form the present perfect, and "had" would be the past perfect (an earlier past).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a03456e2-2ea2-5135-96fd-b469e38a469a', 'a1e6f69c-9aa0-5447-a0f9-1e2f81479615', 'Complete: "We have ___ lunch already, thanks."', '[{"id":"a","text":"ate"},{"id":"b","text":"eaten"},{"id":"c","text":"eat"},{"id":"d","text":"eated"}]'::jsonb, 'b', 'eat is irregular: eat → ate (past) → eaten (participle). After have we use the participle: We have eaten. "ate" is the past simple, "eat" the base, and "eated" is not a real form.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c24e4ee-7b6e-513c-9792-e72f2725dc1b', 'a1e6f69c-9aa0-5447-a0f9-1e2f81479615', 'Complete: "___ you ever been to London?"', '[{"id":"a","text":"Have"},{"id":"b","text":"Did"},{"id":"c","text":"Are"},{"id":"d","text":"Has"}]'::jsonb, 'a', 'To ask about life experience we use the present perfect: Have you ever been to London? With you the auxiliary is Have (Has is for he/she/it). "Did" makes a past-simple question, and "Are" doesn''t fit "been" here.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82f6e766-275a-5cff-84ef-66311337c01f', 'a1e6f69c-9aa0-5447-a0f9-1e2f81479615', 'Complete the negative: "She ___ finished the report yet."', '[{"id":"a","text":"doesn''t"},{"id":"b","text":"haven''t"},{"id":"c","text":"isn''t"},{"id":"d","text":"hasn''t"}]'::jsonb, 'd', 'The present perfect negative with she is hasn''t + participle: She hasn''t finished yet. "haven''t" is for I/you/we/they, and "doesn''t/isn''t" belong to other tenses, not the present perfect.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9ef6f6ea-2f89-5519-b6ba-a41b3329c3a8', 'd3573188-ea41-5396-b14c-c7c1f7fae1e1', 'anglais-b1', '⭐⭐ Review: For/Since, Just/Already/Yet, Gone/Been', 2, 75, 15, 'practice', 'admin', 2)
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
  ('f0f12d8e-b670-5e66-adef-8fce2afbea13', '9ef6f6ea-2f89-5519-b6ba-a41b3329c3a8', 'Complete: "I have known her ___ five years."', '[{"id":"a","text":"since"},{"id":"b","text":"for"},{"id":"c","text":"ago"},{"id":"d","text":"from"}]'::jsonb, 'b', 'Use for with a length of time: for five years. "since" needs a starting point (since 2019), "ago" goes with the past simple (five years ago), and "from" needs a matching "to" (from… to…).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('995363e9-e638-539d-92c1-9e6ad2df4b6c', '9ef6f6ea-2f89-5519-b6ba-a41b3329c3a8', 'Complete: "They have been married ___ 2010."', '[{"id":"a","text":"for"},{"id":"b","text":"during"},{"id":"c","text":"since"},{"id":"d","text":"by"}]'::jsonb, 'c', '2010 is a point when something started, so we use since: since 2010. "for" needs a duration (for ten years), "during" needs an event, and "by" means "not later than", a different idea.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca80caa8-05d8-5a7f-a597-cfdbc7390163', '9ef6f6ea-2f89-5519-b6ba-a41b3329c3a8', 'Complete: "We''ve ___ eaten, so we''re not hungry."', '[{"id":"a","text":"yet"},{"id":"b","text":"ever"},{"id":"c","text":"already"},{"id":"d","text":"since"}]'::jsonb, 'c', 'already shows something happened sooner than expected, in affirmatives: We''ve already eaten. "yet" is for questions/negatives, "ever" asks about experience, and "since" marks a start point.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d81612b2-e9af-505b-ad9f-bc5b2c1b0fc5', '9ef6f6ea-2f89-5519-b6ba-a41b3329c3a8', 'Complete: "My parents have ___ to Italy; they''re still there now."', '[{"id":"a","text":"been"},{"id":"b","text":"gone"},{"id":"c","text":"went"},{"id":"d","text":"being"}]'::jsonb, 'b', 'have gone means they travelled there and are still away: they''re still there now → have gone. "have been" would mean they visited and came back, "went" is the past simple (no have), and "being" is not a participle of go.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fcc14fbb-aa3f-5625-aa28-b40f59a6d7d0', '9ef6f6ea-2f89-5519-b6ba-a41b3329c3a8', 'Complete: "Has the postman come ___?"', '[{"id":"a","text":"already"},{"id":"b","text":"ever"},{"id":"c","text":"since"},{"id":"d","text":"yet"}]'::jsonb, 'd', 'In a question about something we expect to happen, we use yet at the end: Has the postman come yet? "already" belongs to affirmatives, "ever" asks about a whole life, and "since" marks a start point.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9226c7a4-0868-522a-af08-cdd067667f30', '9ef6f6ea-2f89-5519-b6ba-a41b3329c3a8', 'Complete: "I ___ never eaten octopus in my life."', '[{"id":"a","text":"have"},{"id":"b","text":"has"},{"id":"c","text":"am"},{"id":"d","text":"didn''t"}]'::jsonb, 'a', 'Experience uses the present perfect: I have never eaten octopus. With I the auxiliary is have (has is for he/she/it). "am" doesn''t form the present perfect, and "didn''t" would need the past simple without never+participle.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5afd1fa5-52f7-5c8f-9799-62d189c5f77c', 'd3573188-ea41-5396-b14c-c7c1f7fae1e1', 'anglais-b1', '⚔️ Chapter Boss ⭐⭐⭐: The Present Perfect', 3, 120, 30, 'boss', 'admin', 3)
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
  ('8ac1b05f-cca4-5f89-9042-ea8e83f6a392', '5afd1fa5-52f7-5c8f-9799-62d189c5f77c', 'Complete: "I ___ to Paris last year."', '[{"id":"a","text":"have gone"},{"id":"b","text":"went"},{"id":"c","text":"have been"},{"id":"d","text":"has gone"}]'::jsonb, 'b', '"last year" is a finished time, so we use the past simple: I went to Paris last year. The present perfect (have gone/been) cannot take a finished-time marker, and "has gone" is the wrong subject form for I.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4dd59d5b-b41d-50b5-bc3d-47fb0c37fae4', '5afd1fa5-52f7-5c8f-9799-62d189c5f77c', 'Find the INCORRECT sentence.', '[{"id":"a","text":"I have seen him yesterday."},{"id":"b","text":"She has just left the office."},{"id":"c","text":"They have lived here for years."},{"id":"d","text":"Have you finished yet?"}]'::jsonb, 'a', 'The error is (a): "yesterday" is a finished time, so it needs the past simple — I saw him yesterday, not "have seen". (b), (c) and (d) all use the present perfect correctly (just, for years, yet).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03fb821a-9fa6-5204-8d29-126e799d7131', '5afd1fa5-52f7-5c8f-9799-62d189c5f77c', 'Complete: "She has ___ three novels so far."', '[{"id":"a","text":"wrote"},{"id":"b","text":"writed"},{"id":"c","text":"written"},{"id":"d","text":"write"}]'::jsonb, 'c', 'write is irregular: write → wrote (past) → written (participle). After has we use the participle: She has written. "wrote" is the past simple, "writed" is not a word, and "write" is the base form.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01dd93ec-1132-5511-af21-00e89f0e41d6', '5afd1fa5-52f7-5c8f-9799-62d189c5f77c', 'Complete: "We ___ in this house since 2018."', '[{"id":"a","text":"lived"},{"id":"b","text":"have lived"},{"id":"c","text":"live"},{"id":"d","text":"had lived"}]'::jsonb, 'b', '"since 2018" describes a period from the past up to now, which takes the present perfect: We have lived here since 2018. "lived" (past simple) and "had lived" (past perfect) cut the link to now, and "live" is the present simple.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90240e9c-89b2-5276-ba66-880d30507cdb', '5afd1fa5-52f7-5c8f-9799-62d189c5f77c', 'You have been to Egypt. Choose the correct short answer to "Have you ever been to Egypt?"', '[{"id":"a","text":"Yes, I did."},{"id":"b","text":"Yes, I am."},{"id":"c","text":"Yes, I was."},{"id":"d","text":"Yes, I have."}]'::jsonb, 'd', 'A present-perfect question is answered with the same auxiliary: Have you…? — Yes, I have. "I did" answers a past-simple question, and "I am / I was" answer questions with the verb to be, not the present perfect.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2ff8dc0-517c-5b7e-9dbb-27560bbf23e9', '5afd1fa5-52f7-5c8f-9799-62d189c5f77c', 'Find the INCORRECT sentence.', '[{"id":"a","text":"She has gone to the shop, but she''s back now."},{"id":"b","text":"He has been to Japan twice."},{"id":"c","text":"They have gone home; they left an hour ago."},{"id":"d","text":"I have been very busy this week."}]'::jsonb, 'a', 'The error is (a): "has gone" means she is still away, which contradicts "she''s back now" — it should be has been (visited and returned). (b), (c) and (d) use been/gone correctly for their meanings.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6b85c952-5fee-56f8-a474-b5113d3fb46d', 'd3573188-ea41-5396-b14c-c7c1f7fae1e1', 'anglais-b1', '👑 Elite Challenge ⭐⭐⭐⭐: The Present Perfect', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('7849c87b-b79d-5eef-91e0-e7188d911e25', '6b85c952-5fee-56f8-a474-b5113d3fb46d', 'Read: "Sami has worked at the hospital for ten years. He has never taken a long holiday. This year, he has decided to travel."
Which sentence is TRUE?', '[{"id":"a","text":"Sami took a long holiday last year."},{"id":"b","text":"Sami has worked at the hospital for ten years."},{"id":"c","text":"Sami started working this year."},{"id":"d","text":"Sami has decided not to travel."}]'::jsonb, 'b', 'The text says "Sami has worked at the hospital for ten years", so (b) is true. He has never taken a long holiday (a is false), the ten years show he didn''t start this year (c), and he has decided to travel, not to stay (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4cf135a-984d-59c1-a5fd-9f5d70dcda94', '6b85c952-5fee-56f8-a474-b5113d3fb46d', 'Find the INCORRECT sentence.', '[{"id":"a","text":"I''ve known him since we were children."},{"id":"b","text":"Have you finished your work yet?"},{"id":"c","text":"She has wrote to me twice this month."},{"id":"d","text":"We haven''t seen them for ages."}]'::jsonb, 'c', 'The error is (c): after has we need the past participle written, not the past simple wrote — She has written to me. (a), (b) and (d) correctly use since, yet and for with the present perfect.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b92c39c7-56f8-5d20-af87-80cf1960efad', '6b85c952-5fee-56f8-a474-b5113d3fb46d', 'Complete: "I can''t find my phone anywhere. I think I ___ it!"', '[{"id":"a","text":"lost"},{"id":"b","text":"''ve lost"},{"id":"c","text":"was losing"},{"id":"d","text":"had lost"}]'::jsonb, 'b', 'The past action has a result now (the phone is missing), so we use the present perfect: I''ve lost it. The past simple "lost" names no time and breaks the now-link, "was losing" is continuous, and "had lost" is the past perfect.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('58065b06-65bd-5dd4-97f1-dc08a467ecc8', '6b85c952-5fee-56f8-a474-b5113d3fb46d', 'Complete: "We ___ each other since we were at university together."', '[{"id":"a","text":"know"},{"id":"b","text":"knew"},{"id":"c","text":"are knowing"},{"id":"d","text":"have known"}]'::jsonb, 'd', '"since…" describes a state lasting from the past until now, so we use the present perfect: We have known each other since… "know" is the present simple, "knew" cuts the link to now, and know is a stative verb, so "are knowing" is not used.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8eb330d6-6755-5131-b1eb-e1ca0bbede5a', '6b85c952-5fee-56f8-a474-b5113d3fb46d', 'Complete the reply: "Would you like some lunch?" — "No thanks, I ___ eaten."', '[{"id":"a","text":"''ve already"},{"id":"b","text":"didn''t"},{"id":"c","text":"''ve yet"},{"id":"d","text":"am already"}]'::jsonb, 'a', 'To explain why you don''t want lunch now, use the present perfect with already: I''ve already eaten. "didn''t" is past simple without a participle, "''ve yet" is wrong (yet is for questions/negatives), and "am already" doesn''t form the present perfect.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8e1e9934-1a94-556f-a97d-b8737ee355ff', '6b85c952-5fee-56f8-a474-b5113d3fb46d', 'Read: "The kitchen floor is shining and still wet, and there is an empty bucket by the door. Nadia is putting the mop away."
What has Nadia probably just done?', '[{"id":"a","text":"She has cooked dinner."},{"id":"b","text":"She has broken a glass."},{"id":"c","text":"She has cleaned the floor."},{"id":"d","text":"She has watered the plants."}]'::jsonb, 'c', 'The clues — a wet, shining floor, an empty bucket and a mop being put away — show she has cleaned the floor (c). Cooking (a), breaking a glass (b) and watering plants (d) don''t fit a mop, a bucket and a wet floor.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1993e981-3f08-5cb9-a035-9f51b6fe83e5', 'd1dc7e47-b0d8-5f2d-866b-378c7e8e4f53', 'anglais-b1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('eaab1805-0de3-5ff8-8dc8-6c274886bbc9', '1993e981-3f08-5cb9-a035-9f51b6fe83e5', 'Complete: "At 8 p.m. last night, I ___ dinner."', '[{"id":"a","text":"was having"},{"id":"b","text":"were having"},{"id":"c","text":"am having"},{"id":"d","text":"was have"}]'::jsonb, 'a', 'The past continuous is was/were + -ing for an action in progress at a past moment. With I we use was: I was having dinner. "were having" is for you/we/they, "am having" is present, and "was have" is missing the -ing form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b0ef4ac-f2ff-5e25-8858-1bacd6f4c765', '1993e981-3f08-5cb9-a035-9f51b6fe83e5', 'Complete: "They ___ football when it started to rain."', '[{"id":"a","text":"was playing"},{"id":"b","text":"were playing"},{"id":"c","text":"were play"},{"id":"d","text":"are playing"}]'::jsonb, 'b', 'They takes were in the past continuous: They were playing. "was playing" is the wrong agreement (was is for I/he/she/it), "were play" drops the -ing, and "are playing" is the present continuous.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c15ff13c-57b0-5196-b5ba-7717cad31c6e', '1993e981-3f08-5cb9-a035-9f51b6fe83e5', 'Complete: "I was reading when the phone ___."', '[{"id":"a","text":"was ringing"},{"id":"b","text":"were ringing"},{"id":"c","text":"rang"},{"id":"d","text":"ringing"}]'::jsonb, 'c', 'The short action that interrupts the long one takes the past simple: the phone rang. The long background action (was reading) is continuous, but the sudden event is simple, so "was/were ringing" and bare "ringing" are wrong here.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5695972e-54fd-5c9e-9323-a364bbb0610a', '1993e981-3f08-5cb9-a035-9f51b6fe83e5', 'Complete: "___ I was cooking, the doorbell rang."', '[{"id":"a","text":"Since"},{"id":"b","text":"For"},{"id":"c","text":"When"},{"id":"d","text":"While"}]'::jsonb, 'd', 'while introduces the long action in progress (was cooking): While I was cooking… "when" introduces the short action (when the doorbell rang), "since" marks a start point, and "for" marks a length of time.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2b64c56-95ea-5d59-ab24-ecf6dc84f68f', '1993e981-3f08-5cb9-a035-9f51b6fe83e5', 'Complete with the correct -ing form of run: "He was ___ to catch the bus."', '[{"id":"a","text":"runing"},{"id":"b","text":"running"},{"id":"c","text":"runnning"},{"id":"d","text":"runned"}]'::jsonb, 'b', 'After one short vowel + a single consonant, we double the consonant before -ing: run → running. "runing" keeps only one n, "runnning" adds one too many, and "runned" is a past-style form, not an -ing form. The correct form is running.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5215da47-c957-5eb9-a8ba-0769355e8c1e', 'd1dc7e47-b0d8-5f2d-866b-378c7e8e4f53', 'anglais-b1', '⭐ Practice: Past Continuous', 1, 50, 10, 'practice', 'admin', 1)
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
  ('96c312b6-87f3-5f3a-8690-1eec39734321', '5215da47-c957-5eb9-a8ba-0769355e8c1e', 'Complete: "She ___ a book at 9 o''clock last night."', '[{"id":"a","text":"were reading"},{"id":"b","text":"was reading"},{"id":"c","text":"is reading"},{"id":"d","text":"was read"}]'::jsonb, 'b', 'The past continuous is was/were + -ing for an action in progress at a past moment. With she we use was: She was reading. "were reading" is for you/we/they, "is reading" is present, and "was read" has no -ing.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ce5d7df-c927-561a-8461-c76dcc8da384', '5215da47-c957-5eb9-a8ba-0769355e8c1e', 'Complete: "We ___ in the garden when you called."', '[{"id":"a","text":"was working"},{"id":"b","text":"were work"},{"id":"c","text":"were working"},{"id":"d","text":"are working"}]'::jsonb, 'c', 'We takes were in the past continuous: We were working. "was working" is the wrong agreement (was is for I/he/she/it), "were work" drops the -ing, and "are working" is the present continuous.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6edf674a-90ee-5f4e-a847-79f26805ac2a', '5215da47-c957-5eb9-a8ba-0769355e8c1e', 'Complete the negative: "He ___ to the teacher; he was looking out of the window."', '[{"id":"a","text":"wasn''t listening"},{"id":"b","text":"weren''t listening"},{"id":"c","text":"didn''t listening"},{"id":"d","text":"isn''t listening"}]'::jsonb, 'a', 'The past continuous negative with he is wasn''t + -ing: He wasn''t listening. "weren''t" is for you/we/they, "didn''t listening" mixes two tenses (it should be didn''t listen), and "isn''t listening" is present.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('293e5e74-e17f-52e2-af55-7bb2425e4995', '5215da47-c957-5eb9-a8ba-0769355e8c1e', 'Choose the correct -ing form: "I was ___ a cake when the lights went out."', '[{"id":"a","text":"makeing"},{"id":"b","text":"macking"},{"id":"c","text":"making"},{"id":"d","text":"makking"}]'::jsonb, 'c', 'When a verb ends in -e, drop the e before -ing: make → making. "makeing" wrongly keeps the silent e, and "macking/makking" double the wrong letter. The correct form is making.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c612545-2b57-5a30-94e0-6bd9f509e5af', '5215da47-c957-5eb9-a8ba-0769355e8c1e', 'Make a question: "What ___ at midnight?"', '[{"id":"a","text":"you were doing"},{"id":"b","text":"did you doing"},{"id":"c","text":"was you doing"},{"id":"d","text":"were you doing"}]'::jsonb, 'd', 'A past continuous question inverts subject and auxiliary: What + were + you + doing? → What were you doing? "you were doing" keeps statement order, "did you doing" mixes tenses, and "was you" is the wrong agreement for you.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9dabafb-ff48-5116-9ee9-b9248c76ba92', '5215da47-c957-5eb9-a8ba-0769355e8c1e', 'Choose the correct -ing form: "The cat was ___ on the warm sofa."', '[{"id":"a","text":"lieing"},{"id":"b","text":"lying"},{"id":"c","text":"laying"},{"id":"d","text":"lieng"}]'::jsonb, 'b', 'Verbs ending in -ie change to -ying: lie → lying. "lieing" keeps the -ie, "lieng" is misspelled, and "laying" comes from lay (to put something down), a different verb. The cat was lying down.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4bea5507-af8e-51db-9d78-27c594203dba', 'd1dc7e47-b0d8-5f2d-866b-378c7e8e4f53', 'anglais-b1', '⭐⭐ Review: While & When', 2, 75, 15, 'practice', 'admin', 2)
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
  ('90505f8e-53bf-5ecf-b905-de047fbcb141', '4bea5507-af8e-51db-9d78-27c594203dba', 'Complete: "I was having a shower ___ the phone rang."', '[{"id":"a","text":"when"},{"id":"b","text":"while"},{"id":"c","text":"since"},{"id":"d","text":"during"}]'::jsonb, 'a', 'when introduces the short, completed action (the phone rang) that interrupts the long one: …when the phone rang. "while" goes with the long action in progress, "since" marks a start point, and "during" is followed by a noun, not a clause.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0d27e80-38cc-568c-a19a-0d65a6ee12a3', '4bea5507-af8e-51db-9d78-27c594203dba', 'Complete: "___ we were driving home, we saw an accident."', '[{"id":"a","text":"When"},{"id":"b","text":"While"},{"id":"c","text":"For"},{"id":"d","text":"Until"}]'::jsonb, 'b', 'while introduces the long action in progress (we were driving): While we were driving home… The short event (we saw an accident) is in the past simple. "For" marks a length of time and "until" marks an end point, neither of which fits here.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('06a227a6-ff83-53d1-8275-36a45701b85d', '4bea5507-af8e-51db-9d78-27c594203dba', 'Complete: "While she was studying, he ___ TV."', '[{"id":"a","text":"watched"},{"id":"b","text":"watch"},{"id":"c","text":"was watching"},{"id":"d","text":"watches"}]'::jsonb, 'c', 'When two long actions happen in parallel, both take the past continuous: While she was studying, he was watching TV. "watched" (past simple) would suggest a single short event, "watch/watches" are present forms.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1abf2718-4740-56b5-a8ce-b2799b9a01a0', '4bea5507-af8e-51db-9d78-27c594203dba', 'Complete: "They ___ dinner when the guests arrived."', '[{"id":"a","text":"had"},{"id":"b","text":"was having"},{"id":"c","text":"are having"},{"id":"d","text":"were having"}]'::jsonb, 'd', 'The long background action in progress takes the past continuous, and with they we use were: They were having dinner when the guests arrived. "was having" is the wrong agreement, "had" loses the in-progress sense, and "are having" is present.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df4e924a-4f94-51ca-9edb-652719a57112', '4bea5507-af8e-51db-9d78-27c594203dba', 'Which sentence describes two actions happening at the same time?', '[{"id":"a","text":"I was sleeping when the storm started."},{"id":"b","text":"While Dad was cooking, Mum was setting the table."},{"id":"c","text":"She was reading when the door slammed."},{"id":"d","text":"We were leaving when it began to snow."}]'::jsonb, 'b', 'Two long actions in parallel use the past continuous in both halves: While Dad was cooking, Mum was setting the table. The other three each pair a long action (past continuous) with a single short interruption (past simple), so they are not two simultaneous ongoing actions.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('28f66ad0-2948-5968-b0c0-3891fb9c7f89', '4bea5507-af8e-51db-9d78-27c594203dba', 'Complete: "While I ___ for the bus, it started to rain."', '[{"id":"a","text":"waited"},{"id":"b","text":"wait"},{"id":"c","text":"am waiting"},{"id":"d","text":"was waiting"}]'::jsonb, 'd', 'After while, the long action in progress takes the past continuous: While I was waiting for the bus… The short event (it started to rain) is past simple. "waited" is past simple, "wait" is the base, and "am waiting" is present.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('655870b0-3a82-57d6-8b66-df037e3f20f0', 'd1dc7e47-b0d8-5f2d-866b-378c7e8e4f53', 'anglais-b1', '⚔️ Chapter Boss ⭐⭐⭐: Past Continuous vs Past Simple', 3, 120, 30, 'boss', 'admin', 3)
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
  ('a1960c69-62dd-52db-8261-3410a4d084d1', '655870b0-3a82-57d6-8b66-df037e3f20f0', 'Complete: "When I ___ into the room, the children were sleeping."', '[{"id":"a","text":"walked"},{"id":"b","text":"was walking"},{"id":"c","text":"were walking"},{"id":"d","text":"walk"}]'::jsonb, 'a', 'The short action introduced by when takes the past simple: When I walked into the room… The long background action (the children were sleeping) is the continuous one. "was/were walking" wrongly makes the short event continuous, and "walk" is the base form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44ba31eb-4e53-5280-8886-8db0fd299512', '655870b0-3a82-57d6-8b66-df037e3f20f0', 'Find the INCORRECT sentence.', '[{"id":"a","text":"They were playing chess when I arrived."},{"id":"b","text":"While we were waiting, it started to rain."},{"id":"c","text":"I was knowing the answer immediately."},{"id":"d","text":"She was cooking dinner at seven o''clock."}]'::jsonb, 'c', 'The error is (c): know is a stative verb and is not used in the continuous — it should be I knew the answer immediately. (a), (b) and (d) all use the past continuous correctly with action verbs (play, wait, cook).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bdba3627-8e92-5215-9440-8647181cd83d', '655870b0-3a82-57d6-8b66-df037e3f20f0', 'Complete: "I was reading a book when the lights ___."', '[{"id":"a","text":"were going out"},{"id":"b","text":"went out"},{"id":"c","text":"go out"},{"id":"d","text":"was going out"}]'::jsonb, 'b', 'The sudden, short event that interrupts the long action takes the past simple: …when the lights went out. The background action (was reading) is continuous, but the interruption is simple, so "were/was going out" and the present "go out" are wrong.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8f689f63-a49a-5079-86eb-039efad047b6', '655870b0-3a82-57d6-8b66-df037e3f20f0', 'Choose the fully correct sentence.', '[{"id":"a","text":"While she studied, the phone was ringing."},{"id":"b","text":"While she studying, the phone rang."},{"id":"c","text":"While she was studying, the phone was rang."},{"id":"d","text":"While she was studying, the phone rang."}]'::jsonb, 'd', 'while marks the long action in the past continuous and the short interruption is past simple: While she was studying, the phone rang. (a) swaps the tenses, (b) drops was, and (c) wrongly puts the short event in a broken continuous form ("was rang").', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b55becca-f73c-582d-bc19-79764c189cab', '655870b0-3a82-57d6-8b66-df037e3f20f0', 'Complete: "At that moment, I ___ what to say, so I stayed silent."', '[{"id":"a","text":"wasn''t knowing"},{"id":"b","text":"didn''t know"},{"id":"c","text":"weren''t knowing"},{"id":"d","text":"am not knowing"}]'::jsonb, 'b', 'know is a stative verb, so it stays simple even at a past moment: I didn''t know what to say. The continuous forms "wasn''t/weren''t knowing" and the present "am not knowing" are all wrong because state verbs are not used in the continuous.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c69b63c-6a84-510b-a7cc-d213ff949911', '655870b0-3a82-57d6-8b66-df037e3f20f0', 'Find the INCORRECT sentence.', '[{"id":"a","text":"He hurt his leg while he was playing football."},{"id":"b","text":"We were having lunch when the news came on."},{"id":"c","text":"I was wanting an ice cream all afternoon."},{"id":"d","text":"The baby was crying when the doctor came in."}]'::jsonb, 'c', 'The error is (c): want is a stative verb and is not used in the continuous — it should be I wanted an ice cream. (a), (b) and (d) correctly pair a long action in the past continuous with a short past-simple event.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('14bd58a6-41b9-5534-a32c-371feae58b9a', 'd1dc7e47-b0d8-5f2d-866b-378c7e8e4f53', 'anglais-b1', '👑 Elite Challenge ⭐⭐⭐⭐: Past Continuous', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('c3f4817e-5e42-5819-8045-d23d5afa8a56', '14bd58a6-41b9-5534-a32c-371feae58b9a', 'Read: "It was a quiet evening. Rim was doing her homework and her brother was playing a video game. Suddenly, the lights went out and the whole street fell dark."
Which sentence is TRUE?', '[{"id":"a","text":"Rim was doing her homework when the lights went out."},{"id":"b","text":"Rim and her brother were doing the same activity."},{"id":"c","text":"The lights went out before the evening began."},{"id":"d","text":"Her brother was reading a book."}]'::jsonb, 'a', 'The text shows two long actions in progress (Rim doing homework, her brother gaming) interrupted by a short event: Rim was doing her homework when the lights went out, so (a) is true. They were doing different activities (b is false), the lights went out during the evening, not before it (c), and her brother was gaming, not reading (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c0cf3d8e-29b2-554e-8396-233da299a03a', '14bd58a6-41b9-5534-a32c-371feae58b9a', 'Find the INCORRECT sentence.', '[{"id":"a","text":"While the teacher was explaining, the bell rang."},{"id":"b","text":"I was wanting to leave the party early."},{"id":"c","text":"They were arguing when I walked in."},{"id":"d","text":"She was reading while he was cooking."}]'::jsonb, 'b', 'The error is (b): want is a stative verb and is not used in the continuous — it should be I wanted to leave the party early. (a) and (c) correctly interrupt a long action with a short one, and (d) correctly shows two parallel actions in the past continuous.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e630f48b-9ddd-5783-8091-fd7cac3c8aa0', '14bd58a6-41b9-5534-a32c-371feae58b9a', 'Complete: "I burnt my hand while I ___ the soup."', '[{"id":"a","text":"stirred"},{"id":"b","text":"stir"},{"id":"c","text":"was stirring"},{"id":"d","text":"am stirring"}]'::jsonb, 'c', 'After while, the long action in progress takes the past continuous: …while I was stirring the soup. The short result (I burnt my hand) is past simple. "stirred" is past simple, "stir" is the base, and "am stirring" is present — and note the double r in stirring (short vowel + consonant).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92899ae3-6f82-5197-afce-5c3cdf5b6c1c', '14bd58a6-41b9-5534-a32c-371feae58b9a', 'Choose the fully correct sentence.', '[{"id":"a","text":"They were sitting in the garden when it rained."},{"id":"b","text":"They were siting in the garden when it rained."},{"id":"c","text":"They was sitting in the garden when it rained."},{"id":"d","text":"They were sitting in the garden when it was raining."}]'::jsonb, 'a', 'sit doubles the t before -ing (sitting), they takes were, and the short interruption is past simple: They were sitting in the garden when it rained. (b) misspells "siting", (c) uses the wrong agreement ("was"), and (d) wrongly makes the short event continuous ("was raining").', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27f29a01-c96e-589f-9bd0-0c5ccc93d7d2', '14bd58a6-41b9-5534-a32c-371feae58b9a', 'Complete: "This time last year, we ___ on a beach in Tunisia."', '[{"id":"a","text":"relaxed"},{"id":"b","text":"have relaxed"},{"id":"c","text":"were relaxing"},{"id":"d","text":"was relaxing"}]'::jsonb, 'c', '"This time last year" points to an action in progress at a past moment, which takes the past continuous; with we we use were: we were relaxing. "relaxed" (past simple) loses the in-progress sense, "have relaxed" is the present perfect, and "was relaxing" is the wrong agreement for we.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('77762ad6-0d34-5dc4-ad34-48d91277fedf', '14bd58a6-41b9-5534-a32c-371feae58b9a', 'Read: "When Karim got home, water was dripping from the ceiling, a bucket was standing on the floor, and his flatmate was holding a phone to his ear, looking worried."
What was probably happening?', '[{"id":"a","text":"His flatmate was cooking a big meal."},{"id":"b","text":"They were celebrating a birthday."},{"id":"c","text":"His flatmate was painting the ceiling."},{"id":"d","text":"His flatmate was calling for help about a leak."}]'::jsonb, 'd', 'The clues — water dripping from the ceiling, a bucket on the floor, and a worried flatmate on the phone — show he was calling for help about a leak (d). Cooking (a), celebrating (b) and painting (c) don''t fit dripping water and a worried phone call.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a39d1f14-cad1-583a-87e8-3dbda3a634ff', '589c4ce0-c4da-5533-947d-7432b122e351', 'anglais-b1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('ece859ee-4559-531f-8276-185680341543', 'a39d1f14-cad1-583a-87e8-3dbda3a634ff', 'Complete the zero conditional: "If you heat ice, it ___."', '[{"id":"a","text":"will melt"},{"id":"b","text":"melts"},{"id":"c","text":"would melt"},{"id":"d","text":"melted"}]'::jsonb, 'b', 'The zero conditional describes a general truth, so both clauses use the present simple: If you heat ice, it melts. "will melt" and "would melt" belong to the first and second conditionals, and "melted" is the past simple, which is not used here.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6cae7f54-e2ba-5852-9100-7974d4edc9f3', 'a39d1f14-cad1-583a-87e8-3dbda3a634ff', 'Complete the first conditional: "If it rains tomorrow, I ___ at home."', '[{"id":"a","text":"stay"},{"id":"b","text":"stayed"},{"id":"c","text":"will stay"},{"id":"d","text":"would stay"}]'::jsonb, 'c', 'The first conditional talks about a real future result, so the result clause uses will + base verb: I will stay at home. "stay" alone is the present simple, "stayed" is past, and "would stay" is the second conditional (imaginary), not a real plan.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36258cec-198e-5ef5-a153-2557cf16b7bf', 'a39d1f14-cad1-583a-87e8-3dbda3a634ff', 'Complete the second conditional: "If I won the lottery, I ___ the world."', '[{"id":"a","text":"would travel"},{"id":"b","text":"will travel"},{"id":"c","text":"travel"},{"id":"d","text":"travelled"}]'::jsonb, 'a', 'Winning the lottery is imaginary, so this is the second conditional: if + past simple (won), then would + base verb in the result — I would travel. "will travel" is the real-future first conditional, and "travel/travelled" leave out the modal would.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51f9c6e0-600a-55e0-ac29-6b74e2b4f21e', 'a39d1f14-cad1-583a-87e8-3dbda3a634ff', 'Which sentence is correct?', '[{"id":"a","text":"If it will rain, I will take an umbrella."},{"id":"b","text":"If it would rain, I will take an umbrella."},{"id":"c","text":"If it rains, I take will an umbrella."},{"id":"d","text":"If it rains, I will take an umbrella."}]'::jsonb, 'd', 'In the first conditional the if-clause stays in the present simple and only the result uses will: If it rains, I will take an umbrella. Options (a) and (b) wrongly put will/would inside the if-clause, and (c) breaks the word order of will + take.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8404350f-0f6a-5fae-ba92-40ee54461fb1', 'a39d1f14-cad1-583a-87e8-3dbda3a634ff', 'When the if-clause comes first, what do we put between the two clauses? "If you study hard ___ you will pass."', '[{"id":"a","text":"nothing (no punctuation)"},{"id":"b","text":"a comma"},{"id":"c","text":"a full stop"},{"id":"d","text":"the word then is required"}]'::jsonb, 'b', 'When the if-clause comes first, we separate it from the result with a comma: If you study hard, you will pass. A full stop would cut the sentence in two, "then" is optional (not required), and leaving out the comma is a punctuation mistake here.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('01527ceb-d29a-5b63-863d-32721d7ec78f', '589c4ce0-c4da-5533-947d-7432b122e351', 'anglais-b1', '⭐ Practice: Zero & First Conditional', 1, 50, 10, 'practice', 'admin', 1)
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
  ('08122a2b-ebee-50ea-a7fc-3efa9c703608', '01527ceb-d29a-5b63-863d-32721d7ec78f', 'Complete the zero conditional: "If you mix blue and yellow, you ___ green."', '[{"id":"a","text":"get"},{"id":"b","text":"will get"},{"id":"c","text":"would get"},{"id":"d","text":"got"}]'::jsonb, 'a', 'Mixing blue and yellow is always true, so this is the zero conditional: both clauses use the present simple — you get green. "will get" and "would get" belong to the first and second conditionals, and "got" is the past simple.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4197b11-0616-50d9-890e-34ab74dc614d', '01527ceb-d29a-5b63-863d-32721d7ec78f', 'Complete the first conditional: "If you study tonight, you ___ the test."', '[{"id":"a","text":"pass"},{"id":"b","text":"will pass"},{"id":"c","text":"would pass"},{"id":"d","text":"passed"}]'::jsonb, 'b', 'This is a real, possible future, so the first conditional uses will + base verb in the result: you will pass the test. "would pass" is the imaginary second conditional, while "pass" and "passed" leave out the modal will.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c5256db-a943-554f-ba38-d1f6fc407c88', '01527ceb-d29a-5b63-863d-32721d7ec78f', 'Complete the if-clause: "If it ___ tomorrow, we will cancel the picnic."', '[{"id":"a","text":"will rain"},{"id":"b","text":"would rain"},{"id":"c","text":"rains"},{"id":"d","text":"rained"}]'::jsonb, 'c', 'In the first conditional the if-clause stays in the present simple, even about the future: If it rains tomorrow… The word "will" goes in the result only, so "will rain" and "would rain" are wrong here, and "rained" (past) would start a different conditional.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d097239-c36c-56ff-aac8-6ce12ee05ceb', '01527ceb-d29a-5b63-863d-32721d7ec78f', 'Complete the zero conditional: "If water ___ 100°C, it boils."', '[{"id":"a","text":"will reach"},{"id":"b","text":"reaches"},{"id":"c","text":"reach"},{"id":"d","text":"reached"}]'::jsonb, 'b', 'This is a scientific fact (zero conditional), so the if-clause uses the present simple with the third-person -s: If water reaches 100°C… "will reach" adds a wrong future, "reach" misses the -s after water, and "reached" is the past simple.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0449118d-6079-5393-beac-6e206957bf3f', '01527ceb-d29a-5b63-863d-32721d7ec78f', 'Complete the result: "If we don''t leave now, we ___ the train."', '[{"id":"a","text":"miss"},{"id":"b","text":"would miss"},{"id":"c","text":"missed"},{"id":"d","text":"will miss"}]'::jsonb, 'd', 'This is a likely future consequence, so the first conditional result uses will + base verb: we will miss the train. "would miss" is for imaginary situations, and "miss/missed" drop the modal will needed in the result.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb999032-2564-5398-ba08-3fba28729101', '01527ceb-d29a-5b63-863d-32721d7ec78f', 'After will, which verb form is correct? "If you ask her, she will ___ you."', '[{"id":"a","text":"helps"},{"id":"b","text":"to help"},{"id":"c","text":"helped"},{"id":"d","text":"help"}]'::jsonb, 'd', 'After will we always use the bare base verb: she will help you. "helps" wrongly adds -s, "to help" wrongly adds to, and "helped" is the past form — none of these follow will.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e8e88986-bcbe-5dd8-b0cf-7f993599de60', '589c4ce0-c4da-5533-947d-7432b122e351', 'anglais-b1', '⭐⭐ Review: First & Second Conditional', 2, 75, 15, 'practice', 'admin', 2)
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
  ('2b297cbf-d770-50f3-b5bb-db0e8c9c17fe', 'e8e88986-bcbe-5dd8-b0cf-7f993599de60', 'Complete the second conditional: "If she had more money, she ___ a new car."', '[{"id":"a","text":"will buy"},{"id":"b","text":"would buy"},{"id":"c","text":"buys"},{"id":"d","text":"bought"}]'::jsonb, 'b', 'She does not have the money now, so this is the imaginary second conditional: if + past simple (had), then would + base verb — she would buy a car. "will buy" is the real-future first conditional, and "buys/bought" leave out the modal would.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc0edb61-6e7f-518f-bae1-19cd55652632', 'e8e88986-bcbe-5dd8-b0cf-7f993599de60', 'Complete the if-clause of a second conditional: "If I ___ you, I would apologise."', '[{"id":"a","text":"am"},{"id":"b","text":"will be"},{"id":"c","text":"were"},{"id":"d","text":"would be"}]'::jsonb, 'c', 'To give advice we use the fixed second-conditional phrase If I were you (were is used for every subject here): If I were you, I would apologise. "am" is the present simple, while "will be" and "would be" wrongly put a modal inside the if-clause.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84554d85-5317-5017-8097-1d8fea742d35', 'e8e88986-bcbe-5dd8-b0cf-7f993599de60', 'Which sentence is a correct FIRST conditional?', '[{"id":"a","text":"If I will see him, I tell him."},{"id":"b","text":"If I saw him, I will tell him."},{"id":"c","text":"If I see him, I would tell him."},{"id":"d","text":"If I see him, I will tell him."}]'::jsonb, 'd', 'The first conditional is if + present simple, then will + base: If I see him, I will tell him. Option (a) wrongly puts will in the if-clause, (b) mixes a past if-clause with will, and (c) mixes a present if-clause with would.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e5d08e4-1bc4-551f-9db5-462cf889046e', 'e8e88986-bcbe-5dd8-b0cf-7f993599de60', 'Complete the if-clause of a second conditional: "If we ___ near the beach, we would swim every day."', '[{"id":"a","text":"lived"},{"id":"b","text":"live"},{"id":"c","text":"will live"},{"id":"d","text":"would live"}]'::jsonb, 'a', 'Living near the beach is imaginary, so the second-conditional if-clause uses the past simple: If we lived near the beach… The modal would goes in the result only, so "will live" and "would live" are wrong, and "live" (present) would start a different conditional.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('10b1be7d-c21e-5949-89da-04c06deb9077', 'e8e88986-bcbe-5dd8-b0cf-7f993599de60', 'After would, which verb form is correct? "If he had time, he would ___ more often."', '[{"id":"a","text":"travels"},{"id":"b","text":"travelled"},{"id":"c","text":"to travel"},{"id":"d","text":"travel"}]'::jsonb, 'd', 'After would we always use the bare base verb: he would travel more often. "travels" adds a wrong -s, "travelled" is the past form, and "to travel" wrongly keeps to — none of these follow would.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1db1ee7c-f255-5f9e-bafa-cdd1169ab692', 'e8e88986-bcbe-5dd8-b0cf-7f993599de60', 'Choose the sentence that talks about a REAL, likely future plan.', '[{"id":"a","text":"If I were rich, I would help everyone."},{"id":"b","text":"If I finish early, I will call you."},{"id":"c","text":"If I won the race, I would be proud."},{"id":"d","text":"If I had wings, I would fly home."}]'::jsonb, 'b', 'A real, likely future uses the first conditional (if + present, will + base): If I finish early, I will call you. Options (a), (c) and (d) are second conditionals (if + past, would + base) about imaginary or unlikely situations, not a real plan.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d95fd47f-b045-5ec7-a5a3-7c55dc46acc4', '589c4ce0-c4da-5533-947d-7432b122e351', 'anglais-b1', '⚔️ Chapter Boss ⭐⭐⭐: Conditionals', 3, 120, 30, 'boss', 'admin', 3)
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
  ('2d3e5507-5402-5629-85d1-bae63a1a8f91', 'd95fd47f-b045-5ec7-a5a3-7c55dc46acc4', 'Match the clause: "If I had a car, ___"', '[{"id":"a","text":"I will drive to work."},{"id":"b","text":"I drive to work."},{"id":"c","text":"I would drive to work."},{"id":"d","text":"I would to drive to work."}]'::jsonb, 'c', 'The if-clause "If I had…" is past simple, which signals the second conditional, so the result must be would + base verb: I would drive to work. "will drive" mixes in the first conditional, "I drive" drops the modal, and "would to drive" wrongly adds to after would.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6580bb6d-36bb-5aa2-afbe-2e6369d0bc8b', 'd95fd47f-b045-5ec7-a5a3-7c55dc46acc4', 'Find the INCORRECT sentence.', '[{"id":"a","text":"If it will snow, we will stay home."},{"id":"b","text":"If you press this button, the machine stops."},{"id":"c","text":"If I had time, I would help you."},{"id":"d","text":"If she calls, I will answer."}]'::jsonb, 'a', 'The error is (a): you must never put will in the if-clause — it should be If it snows, we will stay home. (b) is a correct zero conditional, (c) a correct second conditional, and (d) a correct first conditional.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8113315b-c396-5415-98b9-9d75a65e6cf0', 'd95fd47f-b045-5ec7-a5a3-7c55dc46acc4', 'Complete: "If you ___ harder, you would get better marks."', '[{"id":"a","text":"will work"},{"id":"b","text":"work"},{"id":"c","text":"would work"},{"id":"d","text":"worked"}]'::jsonb, 'd', 'The result "would get" tells us this is the second conditional, so the if-clause needs the past simple: If you worked harder… The modal goes in the result only, so "will work" and "would work" are wrong, and "work" (present) would not match "would get".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3eede3a-aa03-5f95-9314-babc6c386692', 'd95fd47f-b045-5ec7-a5a3-7c55dc46acc4', 'Choose the correct FIRST conditional.', '[{"id":"a","text":"If the weather is nice, we would go hiking."},{"id":"b","text":"If the weather is nice, we will go hiking."},{"id":"c","text":"If the weather will be nice, we go hiking."},{"id":"d","text":"If the weather were nice, we will go hiking."}]'::jsonb, 'b', 'A real future plan uses the first conditional: if + present simple, then will + base — If the weather is nice, we will go hiking. (a) wrongly uses would, (c) puts will in the if-clause, and (d) mixes a past if-clause with will.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5f44117-bd7f-531a-ae7e-090a8b8ec775', 'd95fd47f-b045-5ec7-a5a3-7c55dc46acc4', 'Complete the zero conditional: "If you ___ plants regularly, they grow well."', '[{"id":"a","text":"will water"},{"id":"b","text":"would water"},{"id":"c","text":"water"},{"id":"d","text":"watered"}]'::jsonb, 'c', 'This is a general truth (zero conditional), so both clauses use the present simple: If you water plants regularly, they grow well. "will water" and "would water" wrongly add a modal, and "watered" is the past simple, not used for a permanent fact.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ee52991-eb43-5e60-9a35-5a90d303b21e', 'd95fd47f-b045-5ec7-a5a3-7c55dc46acc4', 'Find the INCORRECT sentence.', '[{"id":"a","text":"If I were you, I would see a doctor."},{"id":"b","text":"If you heat metal, it expands."},{"id":"c","text":"If we leave now, we will be on time."},{"id":"d","text":"If I won the prize, I will buy a house."}]'::jsonb, 'd', 'The error is (d): it mixes conditionals — a past if-clause (won) needs would, not will, so it should be If I won the prize, I would buy a house. (a) is a correct second conditional, (b) a correct zero conditional, and (c) a correct first conditional.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c2af895f-335f-573f-b73b-071af11d1a14', '589c4ce0-c4da-5533-947d-7432b122e351', 'anglais-b1', '👑 Elite Challenge ⭐⭐⭐⭐: Conditionals', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('8fcd058c-a7a4-537b-9414-63c2d55787ac', 'c2af895f-335f-573f-b73b-071af11d1a14', 'Read: "Lina doesn''t speak Spanish. She often says: ''If I spoke Spanish, I would work in Madrid.'' But her real plan is simpler — she tells her boss: ''If the company opens an office in Tunis, I will apply for it.''"
Which statement is TRUE?', '[{"id":"a","text":"Lina speaks Spanish fluently."},{"id":"b","text":"Lina is certain she will move to Madrid."},{"id":"c","text":"Working in Madrid is Lina''s confirmed plan."},{"id":"d","text":"Working in Madrid is an imaginary situation for Lina."}]'::jsonb, 'd', 'Lina uses the second conditional ("If I spoke Spanish, I would work in Madrid"), which marks an imaginary situation — so (d) is true. The text says she doesn''t speak Spanish (a is false), and Madrid is only hypothetical, while the real plan (first conditional) is about a Tunis office, so (b) and (c) are false.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('71cdecc6-9c1d-52fc-822c-00b5b3eac009', 'c2af895f-335f-573f-b73b-071af11d1a14', 'Find the INCORRECT sentence.', '[{"id":"a","text":"If I would have money, I would travel."},{"id":"b","text":"If you mix red and white, you get pink."},{"id":"c","text":"If it rains, the match will be cancelled."},{"id":"d","text":"If I lived abroad, I would miss my family."}]'::jsonb, 'a', 'The error is (a): would must never go in the if-clause — the second conditional is If I had money, I would travel. (b) is a correct zero conditional, (c) a correct first conditional, and (d) a correct second conditional.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('140c628a-1a79-5314-8b6c-b7307ff6982a', 'c2af895f-335f-573f-b73b-071af11d1a14', 'Complete the dialogue: "I''m so tired lately." — "___ , I would take a few days off."', '[{"id":"a","text":"If I am you"},{"id":"b","text":"If I were you"},{"id":"c","text":"If I will be you"},{"id":"d","text":"If I would be you"}]'::jsonb, 'b', 'The advice phrase is the fixed second conditional If I were you (were for every subject), matching the result would take: If I were you, I would take a few days off. "If I am you" uses the present, while "will be" and "would be" wrongly place a modal in the if-clause.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12bdddc9-2f19-53d2-8098-c33b66290195', 'c2af895f-335f-573f-b73b-071af11d1a14', 'Complete: "Please call me if you ___ any problems with the order."', '[{"id":"a","text":"will have"},{"id":"b","text":"would have"},{"id":"c","text":"had"},{"id":"d","text":"have"}]'::jsonb, 'd', 'This is a real first conditional with the result first (no comma needed): the if-clause keeps the present simple — call me if you have any problems. "will have" and "would have" wrongly put a modal in the if-clause, and "had" (past) would make it imaginary, which doesn''t fit a real request.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb3afd92-d2fe-52b6-954e-c84c64e154e9', 'c2af895f-335f-573f-b73b-071af11d1a14', 'Which sentence correctly expresses an UNLIKELY, imaginary future?', '[{"id":"a","text":"If I become president, I will lower taxes."},{"id":"b","text":"If I will become president, I lower taxes."},{"id":"c","text":"If I became president, I would lower taxes."},{"id":"d","text":"If I became president, I will lower taxes."}]'::jsonb, 'c', 'An imaginary, unlikely future uses the second conditional: if + past simple, then would + base — If I became president, I would lower taxes. (a) is a real first conditional, (b) wrongly puts will in the if-clause, and (d) mixes a past if-clause with will instead of would.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78cc6040-c588-5ed0-9bb7-c4db9da0985d', 'c2af895f-335f-573f-b73b-071af11d1a14', 'Read: "Omar is standing by his bike. The chain has come off and his hands are covered in grease. A friend says: ''If you ___ me, I''ll lend you my spare bike.''"
Complete the sentence.', '[{"id":"a","text":"would ask"},{"id":"b","text":"ask"},{"id":"c","text":"will ask"},{"id":"d","text":"asked"}]'::jsonb, 'b', 'The friend is offering real, immediate help, so this is the first conditional: the if-clause stays present simple to match the result I''ll lend — If you ask me, I''ll lend you my spare bike. "will ask" and "would ask" wrongly put a modal in the if-clause, and "asked" (past) would make the offer imaginary instead of real.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fe4eb78e-6011-5328-bd7d-207ae5b8f21c', '442e97bd-5019-5a8e-b7eb-861f9cf2b597', 'anglais-b1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('b5e6e485-dc7d-58a1-a0f5-a5984b545774', 'fe4eb78e-6011-5328-bd7d-207ae5b8f21c', 'Complete: "You ___ wear a seatbelt in the car. It''s the law."', '[{"id":"a","text":"don''t have to"},{"id":"b","text":"must"},{"id":"c","text":"shouldn''t"},{"id":"d","text":"must to"}]'::jsonb, 'b', 'A legal obligation is expressed with must (or have to): You must wear a seatbelt. "don''t have to" means it''s optional, "shouldn''t" gives advice against, and "must to" is wrong because must is followed by the base verb with no to.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac3af235-6167-5675-aa56-dd2f351cbd8a', 'fe4eb78e-6011-5328-bd7d-207ae5b8f21c', 'Complete: "You look exhausted. You ___ see a doctor."', '[{"id":"a","text":"mustn''t"},{"id":"b","text":"don''t have to"},{"id":"c","text":"should to"},{"id":"d","text":"should"}]'::jsonb, 'd', 'This is friendly advice, so we use should + base verb: You should see a doctor. "should to" is wrong (no to after should), "mustn''t" would forbid it, and "don''t have to" says it''s optional rather than recommended.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1d9ea7bc-4f55-5522-a1b2-b4648ef39f4e', 'fe4eb78e-6011-5328-bd7d-207ae5b8f21c', 'Complete: "This is a secret. You ___ tell anyone."', '[{"id":"a","text":"don''t have to"},{"id":"b","text":"should"},{"id":"c","text":"mustn''t"},{"id":"d","text":"have to"}]'::jsonb, 'c', 'Telling the secret is forbidden, so we use mustn''t: You mustn''t tell anyone. "don''t have to" would mean it''s optional (the opposite), while "should" and "have to" suggest a good idea or an obligation to tell — not a prohibition.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbe9cac9-f725-5b69-bfc2-e3ad46280dea', 'fe4eb78e-6011-5328-bd7d-207ae5b8f21c', 'Complete: "It''s a casual party, so you ___ wear a suit if you don''t want to."', '[{"id":"a","text":"don''t have to"},{"id":"b","text":"mustn''t"},{"id":"c","text":"must"},{"id":"d","text":"have to"}]'::jsonb, 'a', '"if you don''t want to" shows the suit is optional, so we use don''t have to: you don''t have to wear a suit. "mustn''t" would forbid it, and "must / have to" would make it obligatory — neither matches a free choice.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('69f8c605-be12-5d27-b744-f1a83582caa9', 'fe4eb78e-6011-5328-bd7d-207ae5b8f21c', 'Complete: "She ___ get up early because her job starts at seven."', '[{"id":"a","text":"have to"},{"id":"b","text":"has to"},{"id":"c","text":"must to"},{"id":"d","text":"having to"}]'::jsonb, 'b', 'With she, have to becomes has to: She has to get up early. "have to" doesn''t agree with she, "must to" adds a wrong to, and "having to" is not a finite verb form here.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bf69c0eb-1b3a-5b6f-9c70-0ccc5221db6f', '442e97bd-5019-5a8e-b7eb-861f9cf2b597', 'anglais-b1', '⭐ Practice: Must, Have to, Should', 1, 50, 10, 'practice', 'admin', 1)
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
  ('987ef75b-b924-5e4a-9fcc-6cbf92b086e7', 'bf69c0eb-1b3a-5b6f-9c70-0ccc5221db6f', 'Complete: "I ___ finish this report before five o''clock."', '[{"id":"a","text":"must to"},{"id":"b","text":"must"},{"id":"c","text":"musts"},{"id":"d","text":"am must"}]'::jsonb, 'b', 'must is followed by the base verb with no to: I must finish. "must to" wrongly adds to, "musts" wrongly adds -s (modals never change), and "am must" doubles the verb.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0238c85f-0e73-5fd5-862c-22fd6d555d25', 'bf69c0eb-1b3a-5b6f-9c70-0ccc5221db6f', 'Complete: "You ___ drink more water; it''s good for you."', '[{"id":"a","text":"shouldn''t"},{"id":"b","text":"mustn''t"},{"id":"c","text":"should"},{"id":"d","text":"should to"}]'::jsonb, 'c', '"it''s good for you" signals positive advice, so we use should: You should drink more water. "shouldn''t" and "mustn''t" would advise or forbid against it, and "should to" wrongly adds to after should.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4fac49fc-f563-54f9-a918-e3cf31acc907', 'bf69c0eb-1b3a-5b6f-9c70-0ccc5221db6f', 'Complete: "He ___ wear a uniform at his school."', '[{"id":"a","text":"has to"},{"id":"b","text":"have to"},{"id":"c","text":"has"},{"id":"d","text":"have"}]'::jsonb, 'a', 'With he, have to becomes has to: He has to wear a uniform. "have to" doesn''t agree with he, and "has" or "have" alone (without to) don''t express obligation here.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2c3dfac-1b06-5597-811b-9f05e96f2c7c', 'bf69c0eb-1b3a-5b6f-9c70-0ccc5221db6f', 'Complete: "We ___ be quiet in the library."', '[{"id":"a","text":"musts"},{"id":"b","text":"must to"},{"id":"c","text":"are must"},{"id":"d","text":"must"}]'::jsonb, 'd', 'must has only one form for every subject, followed by the base verb: We must be quiet. "musts" adds a wrong -s, "must to" adds a wrong to, and "are must" doubles the verb.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('924d5ccb-5fc5-55fb-8dae-a97704551fe7', 'bf69c0eb-1b3a-5b6f-9c70-0ccc5221db6f', 'Complete: "You ___ smoke in here. It''s forbidden."', '[{"id":"a","text":"don''t have to"},{"id":"b","text":"mustn''t"},{"id":"c","text":"should"},{"id":"d","text":"have to"}]'::jsonb, 'b', '"It''s forbidden" means prohibition, so we use mustn''t: You mustn''t smoke in here. "don''t have to" would mean it''s optional, while "should" and "have to" suggest advice or obligation, not a ban.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d1d3a86-daf8-56a1-855e-d0ba09e87c36', 'bf69c0eb-1b3a-5b6f-9c70-0ccc5221db6f', 'Complete: "They ___ study hard for the exam next week."', '[{"id":"a","text":"has to"},{"id":"b","text":"must to"},{"id":"c","text":"have to"},{"id":"d","text":"having to"}]'::jsonb, 'c', 'With they we use have to (the plural form): They have to study hard. "has to" is only for he/she/it, "must to" adds a wrong to, and "having to" is not a finite verb here.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9d2a171f-0019-564f-b720-1e0a3c333cab', '442e97bd-5019-5a8e-b7eb-861f9cf2b597', 'anglais-b1', '⭐⭐ Review: Obligation & Advice', 2, 75, 15, 'practice', 'admin', 2)
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
  ('b963b579-1234-51a9-a179-9e577cd5765c', '9d2a171f-0019-564f-b720-1e0a3c333cab', 'Complete: "The museum is free, so you ___ pay anything to enter."', '[{"id":"a","text":"mustn''t"},{"id":"b","text":"must"},{"id":"c","text":"don''t have to"},{"id":"d","text":"have to"}]'::jsonb, 'c', '"It''s free" means paying is not necessary, so we use don''t have to: you don''t have to pay. "mustn''t" would forbid paying, and "must / have to" would make paying obligatory — the opposite of free.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('481130c6-d407-56bc-88ec-78ef4cb1ad8d', '9d2a171f-0019-564f-b720-1e0a3c333cab', 'Which sentence gives ADVICE (not an obligation)?', '[{"id":"a","text":"You must show your passport at the border."},{"id":"b","text":"Drivers have to stop at a red light."},{"id":"c","text":"You mustn''t touch the paintings."},{"id":"d","text":"You should try the local food while you''re here."}]'::jsonb, 'd', 'should expresses advice — a good idea, not a rule: You should try the local food. "must" and "have to" (a, b) state obligations, and "mustn''t" (c) states a prohibition.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('132d8118-20c5-56b0-b24d-0d6fdeddc501', '9d2a171f-0019-564f-b720-1e0a3c333cab', 'Complete: "My sister ___ wake up at 5 a.m. because her train leaves early."', '[{"id":"a","text":"have to"},{"id":"b","text":"has to"},{"id":"c","text":"must to"},{"id":"d","text":"should to"}]'::jsonb, 'b', '"My sister" is third person singular (= she), so have to becomes has to: My sister has to wake up at 5 a.m. "have to" doesn''t agree, and "must to / should to" wrongly add to after the modal.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8973ba3b-12fe-5f8e-ab37-0559533cf048', '9d2a171f-0019-564f-b720-1e0a3c333cab', 'Find the INCORRECT sentence.', '[{"id":"a","text":"You must to finish your dinner."},{"id":"b","text":"She has to leave early today."},{"id":"c","text":"We should call them tonight."},{"id":"d","text":"They mustn''t be late."}]'::jsonb, 'a', 'The error is (a): must is followed by the base verb with no to — You must finish your dinner. (b), (c) and (d) are all correct (has to + base, should + base, mustn''t + base).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('554943ea-c09a-528c-b40c-985badae2b84', '9d2a171f-0019-564f-b720-1e0a3c333cab', 'Complete: "You ___ ride a bike without a helmet — it''s dangerous."', '[{"id":"a","text":"don''t have to"},{"id":"b","text":"have to"},{"id":"c","text":"shouldn''t"},{"id":"d","text":"must"}]'::jsonb, 'c', '"it''s dangerous" signals advice against doing it, so we use shouldn''t: You shouldn''t ride a bike without a helmet. "don''t have to" means it''s optional, while "have to / must" would make riding without a helmet obligatory.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c1cff10-fb30-59fd-bc34-01377caf444f', '9d2a171f-0019-564f-b720-1e0a3c333cab', 'Complete the question: "___ I have to book a ticket in advance?"', '[{"id":"a","text":"Must"},{"id":"b","text":"Do"},{"id":"c","text":"Have"},{"id":"d","text":"Should to"}]'::jsonb, 'b', 'have to forms questions with do/does: Do I have to book a ticket? "Must" would not combine with "have to" here, "Have I have to" is wrong, and "Should to" adds a wrong to after should.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c4bb6149-7cb3-5743-809c-e8db215da654', '442e97bd-5019-5a8e-b7eb-861f9cf2b597', 'anglais-b1', '⚔️ Chapter Boss ⭐⭐⭐: Mustn''t vs Don''t Have To', 3, 120, 30, 'boss', 'admin', 3)
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
  ('058eb948-16eb-5140-9673-c046f1f85c59', 'c4bb6149-7cb3-5743-809c-e8db215da654', 'Complete: "This medicine is dangerous for children. You ___ leave it where they can reach it."', '[{"id":"a","text":"mustn''t"},{"id":"b","text":"don''t have to"},{"id":"c","text":"should"},{"id":"d","text":"have to"}]'::jsonb, 'a', 'Leaving dangerous medicine within reach must be prevented, so we use mustn''t (it is forbidden): You mustn''t leave it where they can reach it. The trap is "don''t have to", which would mean it''s merely optional — the opposite of a safety ban.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('760a2799-19ca-5390-a2fb-4eaee959eacf', 'c4bb6149-7cb3-5743-809c-e8db215da654', 'Complete: "It''s Saturday tomorrow, so I ___ get up early. I can sleep in."', '[{"id":"a","text":"mustn''t"},{"id":"b","text":"must"},{"id":"c","text":"have to"},{"id":"d","text":"don''t have to"}]'::jsonb, 'd', '"I can sleep in" shows getting up early is not necessary, so we use don''t have to: I don''t have to get up early. The trap is "mustn''t": that would forbid getting up early, but here it''s simply optional — not banned.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1547cc51-5271-5684-b077-7c06e3f11f4e', 'c4bb6149-7cb3-5743-809c-e8db215da654', '"You mustn''t park here" means:', '[{"id":"a","text":"You can park here if you want to."},{"id":"b","text":"Parking here is a good idea."},{"id":"c","text":"Parking here is forbidden; don''t do it."},{"id":"d","text":"You don''t need to park here."}]'::jsonb, 'c', 'mustn''t expresses prohibition: "You mustn''t park here" = parking here is forbidden, so don''t do it. Options (a) and (d) describe a free choice (that would be don''t have to), and (b) describes advice (should).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3257e99d-2660-5323-9aa5-049dcfea235a', 'c4bb6149-7cb3-5743-809c-e8db215da654', 'Find the sentence that means parking is OPTIONAL (you can, but you don''t need to).', '[{"id":"a","text":"You mustn''t park here."},{"id":"b","text":"You don''t have to park here."},{"id":"c","text":"You must park here."},{"id":"d","text":"You should park here."}]'::jsonb, 'b', 'don''t have to means it isn''t necessary, so it''s optional: You don''t have to park here = you can if you want. "mustn''t" forbids it (a), "must" makes it obligatory (c), and "should" recommends it (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9a46e71-9cba-5b1c-9972-27593d20fd4a', 'c4bb6149-7cb3-5743-809c-e8db215da654', 'Find the INCORRECT sentence (watch the form after the modal).', '[{"id":"a","text":"Visitors mustn''t feed the animals."},{"id":"b","text":"You don''t have to come if you''re busy."},{"id":"c","text":"He has to renew his passport."},{"id":"d","text":"She must to apologise to her teacher."}]'::jsonb, 'd', 'The error is (d): must is followed by the base verb with no to — She must apologise. (a), (b) and (c) are all correct: mustn''t + base (prohibition), don''t have to + base (optional), and has to + base (obligation).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ccf770d-2bbb-51d6-b3eb-44cbc4879729', 'c4bb6149-7cb3-5743-809c-e8db215da654', 'Your friend says: "I don''t have to wear a tie at work, but I mustn''t wear jeans." Which is TRUE?', '[{"id":"a","text":"Wearing a tie is optional, but jeans are forbidden."},{"id":"b","text":"A tie is forbidden, but jeans are optional."},{"id":"c","text":"Both a tie and jeans are forbidden."},{"id":"d","text":"Both a tie and jeans are required."}]'::jsonb, 'a', 'don''t have to wear a tie = wearing a tie is optional; mustn''t wear jeans = jeans are forbidden. So (a) is true. The pair contrasts the two modals: don''t have to (not necessary) versus mustn''t (not allowed) — they are opposites, not synonyms.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1b58c970-ed85-552d-ad5a-e826dd0a4605', '442e97bd-5019-5a8e-b7eb-861f9cf2b597', 'anglais-b1', '👑 Elite Challenge ⭐⭐⭐⭐: Modals of Obligation', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('09e00934-ae5d-5a82-8a12-74bb212acc51', '1b58c970-ed85-552d-ad5a-e826dd0a4605', 'Read the sign: "STAFF ONLY. Visitors must report to reception. Photography is not permitted. You do not need to sign out when you leave."
Which sentence is TRUE?', '[{"id":"a","text":"Visitors don''t have to report to reception."},{"id":"b","text":"Visitors mustn''t take photographs."},{"id":"c","text":"Visitors must sign out when they leave."},{"id":"d","text":"Visitors should avoid reception."}]'::jsonb, 'b', '"Photography is not permitted" is a prohibition, so "Visitors mustn''t take photographs" (b) is true. Reporting to reception is required, not optional (a is false); signing out is not needed, so it isn''t obligatory (c); and nothing advises avoiding reception (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a761414c-4656-570d-9797-84088854db6f', '1b58c970-ed85-552d-ad5a-e826dd0a4605', 'Complete: "When I was a child, I ___ go to bed at eight, even at weekends."', '[{"id":"a","text":"must"},{"id":"b","text":"have to"},{"id":"c","text":"had to"},{"id":"d","text":"must to"}]'::jsonb, 'c', '"When I was a child" is in the past, and the past of must / have to is had to: I had to go to bed at eight. must has no past form of its own, "have to" is present, and "must to" wrongly adds to.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('606502f9-7a42-5706-ba52-538e290fc574', '1b58c970-ed85-552d-ad5a-e826dd0a4605', 'Find the INCORRECT sentence (one has a doubled or wrong particle).', '[{"id":"a","text":"You don''t have to to wait for me."},{"id":"b","text":"She mustn''t forget her passport."},{"id":"c","text":"We should book the tickets early."},{"id":"d","text":"He has to work this weekend."}]'::jsonb, 'a', 'The error is (a): "don''t have to" already contains one to, so the base verb follows directly — You don''t have to wait for me (not "to to wait"). (b), (c) and (d) are correct: mustn''t + base, should + base, and has to + base.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84534f92-387a-5aae-a085-663ea92bbfa9', '1b58c970-ed85-552d-ad5a-e826dd0a4605', 'Read: "At Karim''s new job, the rules are clear. He must arrive by 9 a.m. He mustn''t use his phone at his desk. He doesn''t have to wear a suit, but he should look tidy."
Which statement is TRUE?', '[{"id":"a","text":"Karim can arrive whenever he likes."},{"id":"b","text":"Using his phone at his desk is optional."},{"id":"c","text":"Wearing a suit is forbidden."},{"id":"d","text":"Wearing a suit is optional, but looking tidy is advised."}]'::jsonb, 'd', '"doesn''t have to wear a suit" makes the suit optional, and "should look tidy" is advice, so (d) is true. He must arrive by 9 (a is false); the phone is forbidden, not optional (b); and the suit is optional, not forbidden (c) — note mustn''t would have made it forbidden.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e6e8d472-ffb3-560c-b254-70585341c6a2', '1b58c970-ed85-552d-ad5a-e826dd0a4605', 'Complete: "It''s a surprise party for Lina, so we ___ tell her about it!"', '[{"id":"a","text":"don''t have to"},{"id":"b","text":"should"},{"id":"c","text":"mustn''t"},{"id":"d","text":"have to"}]'::jsonb, 'c', 'To keep the surprise, telling Lina must be prevented, so we use mustn''t (it''s forbidden): we mustn''t tell her. The trap is "don''t have to", which would only mean telling her is optional — but a surprise depends on not telling at all.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c4b0c26-1807-5937-9209-f8600b893c23', '1b58c970-ed85-552d-ad5a-e826dd0a4605', 'Read: "Sofia feels tired and stressed lately. She drinks coffee all day and rarely sleeps before midnight. Her doctor gave her some advice."
What did the doctor most likely say?', '[{"id":"a","text":"You mustn''t sleep at night."},{"id":"b","text":"You should drink less coffee and sleep earlier."},{"id":"c","text":"You have to drink coffee all day."},{"id":"d","text":"You don''t have to rest at all."}]'::jsonb, 'b', 'A doctor gives advice with should: "You should drink less coffee and sleep earlier" (b) fits Sofia''s problem. (a) forbids sleeping at night (the opposite of good advice), (c) tells her to keep the harmful habit, and (d) says rest is optional — none of which helps a tired, stressed patient.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6c7fec37-efed-5bb6-b3ae-d2c0588b73da', '97bbe81f-2f56-59be-a5de-bf2292f92b73', 'anglais-b1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('6289d8ca-7f89-5274-a661-454ea6f98528', '6c7fec37-efed-5bb6-b3ae-d2c0588b73da', 'Complete: "The doctor ___ treated me was very kind."', '[{"id":"a","text":"who"},{"id":"b","text":"which"},{"id":"c","text":"where"},{"id":"d","text":"whose"}]'::jsonb, 'a', 'Use who for people: the doctor who treated me. "which" is for things, not people; "where" is for places; and "whose" shows possession (the doctor whose car…), which is not the meaning here.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('04aba842-0089-5bd8-9192-0aa0a00d217a', '6c7fec37-efed-5bb6-b3ae-d2c0588b73da', 'Complete: "That''s the village ___ my grandparents live."', '[{"id":"a","text":"which"},{"id":"b","text":"who"},{"id":"c","text":"that"},{"id":"d","text":"where"}]'::jsonb, 'd', 'Use where for a place (= in which): the village where my grandparents live. "which"/"that" would need the place as an object (the village that I visited), and "who" is only for people.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a7926885-cba9-57a2-94cb-28fb34528811', '6c7fec37-efed-5bb6-b3ae-d2c0588b73da', 'Complete: "I met a girl ___ brother plays for the national team."', '[{"id":"a","text":"who"},{"id":"b","text":"which"},{"id":"c","text":"whose"},{"id":"d","text":"who''s"}]'::jsonb, 'c', 'whose shows possession — it replaces her here (her brother): a girl whose brother plays. "who" would need a verb after it (a girl who plays), "which" is for things, and "who''s" means "who is".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86eabef9-eb17-50c0-9b2e-573c9e621c10', '6c7fec37-efed-5bb6-b3ae-d2c0588b73da', 'Complete: "This is the bridge ___ connects the two parts of the city."', '[{"id":"a","text":"who"},{"id":"b","text":"which"},{"id":"c","text":"where"},{"id":"d","text":"whose"}]'::jsonb, 'b', 'A bridge is a thing, so use which (the doer of "connects"): the bridge which connects the two parts. "who" is only for people, "where" marks a place inside the clause, and "whose" shows possession.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7fe66ce5-b374-5291-913f-f2366d748628', '6c7fec37-efed-5bb6-b3ae-d2c0588b73da', 'Which sentence is correct?', '[{"id":"a","text":"The book what I bought is interesting."},{"id":"b","text":"The book who I bought is interesting."},{"id":"c","text":"The book where I bought is interesting."},{"id":"d","text":"The book that I bought is interesting."}]'::jsonb, 'd', 'For a thing, use that (or which): the book that I bought. Never use "what" as a relative pronoun (a) — a very common error; "who" (b) is for people; and "where" (c) is for places, not a thing.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b118995d-87bc-539b-969d-5e971f98ff7a', '97bbe81f-2f56-59be-a5de-bf2292f92b73', 'anglais-b1', '⭐ Practice: Who, Which, That', 1, 50, 10, 'practice', 'admin', 1)
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
  ('53e0e708-72b8-5ffd-beaf-b48f5d673434', 'b118995d-87bc-539b-969d-5e971f98ff7a', 'Complete: "The man ___ lives next door is a firefighter."', '[{"id":"a","text":"who"},{"id":"b","text":"which"},{"id":"c","text":"where"},{"id":"d","text":"whose"}]'::jsonb, 'a', 'Use who for people: the man who lives next door. "which" is for things, "where" is for places, and "whose" shows possession (the man whose house…) — none fits a person doing the action here.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e12a5532-a554-5ef4-aabb-51490a2c331f', 'b118995d-87bc-539b-969d-5e971f98ff7a', 'Complete: "I lost the keys ___ open the garage."', '[{"id":"a","text":"who"},{"id":"b","text":"where"},{"id":"c","text":"which"},{"id":"d","text":"whose"}]'::jsonb, 'c', 'Keys are things, so use which: the keys which open the garage. "who" is only for people, "where" is for places, and "whose" shows possession, not the thing itself.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89b472c2-e11f-5db4-8788-277868af1765', 'b118995d-87bc-539b-969d-5e971f98ff7a', 'Complete the informal sentence: "She''s the teacher ___ helped me pass the exam."', '[{"id":"a","text":"which"},{"id":"b","text":"that"},{"id":"c","text":"where"},{"id":"d","text":"whose"}]'::jsonb, 'b', 'For people, that is a common informal choice (like who): the teacher that helped me. "which" is for things only, "where" is for places, and "whose" shows possession — wrong for the doer of "helped".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff83ad6a-d8ac-59f2-9d8c-41fe9cd2c7ca', 'b118995d-87bc-539b-969d-5e971f98ff7a', 'Complete: "This is the bag ___ I bought yesterday."', '[{"id":"a","text":"who"},{"id":"b","text":"where"},{"id":"c","text":"whose"},{"id":"d","text":"which"}]'::jsonb, 'd', 'A bag is a thing, so use which (the object of "bought"): the bag which I bought. "who" is for people, "where" is for places, and "whose" shows possession, not the thing acted on.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc3660ce-c60e-5d1b-8ee6-8390ac5cea87', 'b118995d-87bc-539b-969d-5e971f98ff7a', 'Find the INCORRECT sentence.', '[{"id":"a","text":"The book which I read was long."},{"id":"b","text":"The actor who won the award is famous."},{"id":"c","text":"The dog which barks all night is loud, and the man which owns it is my neighbour."},{"id":"d","text":"The phone that I dropped still works."}]'::jsonb, 'c', 'In (c), "the man which owns it" is wrong: people take who or that, not which. It should be the man who owns it. (a), (b) and (d) all match the pronoun to the noun correctly.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('457504ee-db4c-597d-b3d5-173059263078', 'b118995d-87bc-539b-969d-5e971f98ff7a', 'Which sentence is correct?', '[{"id":"a","text":"The song what I heard was beautiful."},{"id":"b","text":"The song that I heard was beautiful."},{"id":"c","text":"The song who I heard was beautiful."},{"id":"d","text":"The song where I heard was beautiful."}]'::jsonb, 'b', 'For a thing, use that (or which): the song that I heard. "what" is never a relative pronoun (a) — a very common mistake; "who" (c) is for people; and "where" (d) is for places, not a thing.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f6cfa647-7511-5bc3-ac55-3a414bbfa939', '97bbe81f-2f56-59be-a5de-bf2292f92b73', 'anglais-b1', '⭐⭐ Review: Where, Whose & That', 2, 75, 15, 'practice', 'admin', 2)
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
  ('d22fe2dd-dde1-5d91-827a-e4863e5eb325', 'f6cfa647-7511-5bc3-ac55-3a414bbfa939', 'Complete: "This is the restaurant ___ we had dinner last week."', '[{"id":"a","text":"which"},{"id":"b","text":"where"},{"id":"c","text":"who"},{"id":"d","text":"whose"}]'::jsonb, 'b', 'Use where for a place (= in which): the restaurant where we had dinner. "which" would need the place as an object (the restaurant which we liked), "who" is for people, and "whose" shows possession.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16587e62-5f62-58b8-bdab-0ed45705ffdf', 'f6cfa647-7511-5bc3-ac55-3a414bbfa939', 'Complete: "He''s the writer ___ books sell millions of copies."', '[{"id":"a","text":"whose"},{"id":"b","text":"who"},{"id":"c","text":"which"},{"id":"d","text":"where"}]'::jsonb, 'a', 'whose shows possession — it replaces his here (his books): the writer whose books sell. "who" needs a verb after it (the writer who writes), "which" is for things, and "where" is for places.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be179cfc-06fe-59d9-9c40-8701a8d86ad1', 'f6cfa647-7511-5bc3-ac55-3a414bbfa939', 'Complete: "That''s the stadium ___ the final was played."', '[{"id":"a","text":"who"},{"id":"b","text":"whose"},{"id":"c","text":"which"},{"id":"d","text":"where"}]'::jsonb, 'd', 'Use where for a place (= in which): the stadium where the final was played. "who" is for people, "whose" shows possession, and bare "which" would need the place as an object (the stadium which they built).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73352b6d-23ce-53ad-a480-41d7d3ad82cc', 'f6cfa647-7511-5bc3-ac55-3a414bbfa939', 'Complete: "That''s the neighbour ___ dog barks all night."', '[{"id":"a","text":"who"},{"id":"b","text":"who''s"},{"id":"c","text":"whose"},{"id":"d","text":"which"}]'::jsonb, 'c', 'whose shows possession (his/her dog): the neighbour whose dog barks. "who''s" means "who is" (the neighbour who''s angry), "who" needs a verb directly after it, and "which" is for things, not a person.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c78cf3c-1ba9-5708-8973-a657855ea469', 'f6cfa647-7511-5bc3-ac55-3a414bbfa939', 'Combine into one sentence: "I visited a museum. The museum had no entrance fee."', '[{"id":"a","text":"I visited a museum where had no entrance fee."},{"id":"b","text":"I visited a museum which had no entrance fee."},{"id":"c","text":"I visited a museum who had no entrance fee."},{"id":"d","text":"I visited a museum whose had no entrance fee."}]'::jsonb, 'b', 'The museum is a thing and the subject of "had", so use which: a museum which had no entrance fee. "where" can''t be the subject of "had" (a), "who" is for people (c), and "whose" needs a noun after it (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e6765073-0b37-5ac8-ade2-98be8d7b19c7', 'f6cfa647-7511-5bc3-ac55-3a414bbfa939', 'Find the INCORRECT sentence.', '[{"id":"a","text":"The hotel where we stayed was cheap."},{"id":"b","text":"The friend whose car we borrowed lives in Tunis."},{"id":"c","text":"The pen where I write with is broken."},{"id":"d","text":"The street where I grew up has changed a lot."}]'::jsonb, 'c', 'In (c), "the pen where I write with" is wrong: a pen is a thing, so use which or that (the pen which I write with). "where" is only for places. (a), (b) and (d) use where and whose correctly.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2f8279d5-6792-59a1-a5a3-315f3f921cd1', '97bbe81f-2f56-59be-a5de-bf2292f92b73', 'anglais-b1', '⚔️ Chapter Boss ⭐⭐⭐: Relative Clauses', 3, 120, 30, 'boss', 'admin', 3)
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
  ('a1354dd9-ce9f-50bc-8523-24a1135f78c1', '2f8279d5-6792-59a1-a5a3-315f3f921cd1', 'In which sentence can the relative pronoun be correctly left out?', '[{"id":"a","text":"The man who called you is waiting outside."},{"id":"b","text":"The bus which goes to the centre is late."},{"id":"c","text":"The film that we watched was boring."},{"id":"d","text":"The woman who lives upstairs is a nurse."}]'::jsonb, 'c', 'You can drop the pronoun only when it is the object: in (c), "we" follows, so that is the object — The film we watched. In (a), (b) and (d) the pronoun is the subject (a verb follows: called, goes, lives), so it must stay.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c554e7f4-ae80-557d-aaa8-53143b9d619f', '2f8279d5-6792-59a1-a5a3-315f3f921cd1', 'Combine into one sentence: "I''ll never forget the day. We won the championship that day."', '[{"id":"a","text":"I''ll never forget the day which we won the championship."},{"id":"b","text":"I''ll never forget the day when we won the championship."},{"id":"c","text":"I''ll never forget the day who we won the championship."},{"id":"d","text":"I''ll never forget the day whose we won the championship."}]'::jsonb, 'b', 'For a time, use when (= on which): the day when we won. Bare "which" can''t carry the meaning "on that day" here (a), "who" is for people (c), and "whose" shows possession and needs a noun after it (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be82507b-76aa-5f51-adda-8ca6085d6df4', '2f8279d5-6792-59a1-a5a3-315f3f921cd1', 'Complete: "I apologised to the customer ___ order had been lost."', '[{"id":"a","text":"whose"},{"id":"b","text":"who''s"},{"id":"c","text":"who"},{"id":"d","text":"which"}]'::jsonb, 'a', 'whose shows possession (their order): the customer whose order had been lost. The common trap is "who''s", which means "who is" (b); "who" needs a verb after it (c); and "which" is for things, not a person (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1da7af6c-1a95-55bb-9c40-b05ba6ff087b', '2f8279d5-6792-59a1-a5a3-315f3f921cd1', 'Find the INCORRECT sentence.', '[{"id":"a","text":"The parcel that arrived this morning is for you."},{"id":"b","text":"The girl whose phone rang left the room."},{"id":"c","text":"The diner where we met has closed down."},{"id":"d","text":"The engineer designed the bridge is from Sfax."}]'::jsonb, 'd', 'In (d) the subject pronoun is missing: it should be the engineer who designed the bridge. When the pronoun is the subject (a verb follows: designed) you cannot drop it. (a), (b) and (c) are all correct.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('187c048c-c484-5e98-9e03-1cc40a34daf1', '2f8279d5-6792-59a1-a5a3-315f3f921cd1', 'Complete: "The scientist ___ discovered the cure works in a lab ___ is funded by the state."', '[{"id":"a","text":"which … who"},{"id":"b","text":"who … which"},{"id":"c","text":"whose … where"},{"id":"d","text":"where … that"}]'::jsonb, 'b', 'The scientist is a person (who discovered), and the lab is a thing that is the subject of "is funded" (which). So: who … which. The other pairs mismatch the pronoun to the noun — a person is never "which" and a lab is never "who".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('777c5972-5e8a-56c4-b4cf-8b3a6cd86b54', '2f8279d5-6792-59a1-a5a3-315f3f921cd1', 'Read: "My uncle, a man that everyone trusts, runs a shop where you can buy anything you need." Which sentence is true?', '[{"id":"a","text":"Everyone trusts my uncle."},{"id":"b","text":"Nobody trusts my uncle."},{"id":"c","text":"The shop sells only food."},{"id":"d","text":"My uncle works in a bank."}]'::jsonb, 'a', '"a man that everyone trusts" means everyone trusts him, so (a) is true. (b) reverses it; the clause "where you can buy anything" shows the shop is not food-only (c); and it is a shop, not a bank (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6e3123e2-e3b7-58f3-97ef-bd81c64a486b', '97bbe81f-2f56-59be-a5de-bf2292f92b73', 'anglais-b1', '👑 Elite Challenge ⭐⭐⭐⭐: Relative Clauses', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('a0b097d8-f0d8-5236-8ecc-72af95555c5c', '6e3123e2-e3b7-58f3-97ef-bd81c64a486b', 'Read: "The candidate who got the job is the one whose CV impressed the panel and who speaks three languages." Which statement is true?', '[{"id":"a","text":"The candidate speaks only one language."},{"id":"b","text":"Nobody was given the job."},{"id":"c","text":"The panel disliked the candidate''s CV."},{"id":"d","text":"The person who was hired speaks three languages."}]'::jsonb, 'd', 'The clauses describe one candidate: who got the job, whose CV impressed the panel, and who speaks three languages — so (d) is true. (a) contradicts "three languages", (b) contradicts "got the job", and (c) contradicts "impressed the panel".', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7855d649-82ea-5b02-81cf-326afc40dcc3', '6e3123e2-e3b7-58f3-97ef-bd81c64a486b', 'In which sentence can the relative pronoun NOT be left out?', '[{"id":"a","text":"The song (that) she sang was beautiful."},{"id":"b","text":"The people (who) we invited didn''t come."},{"id":"c","text":"The train that leaves at noon is always full."},{"id":"d","text":"The letter (which) I wrote got lost."}]'::jsonb, 'c', 'In (c) the pronoun is the subject (a verb, "leaves", follows), so it must stay: the train that leaves at noon. In (a), (b) and (d) a subject (she, we, I) follows, making the pronoun the object — which can be dropped.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4991d957-7742-5aec-a2f6-4f8ac1713078', '6e3123e2-e3b7-58f3-97ef-bd81c64a486b', 'Combine into one sentence: "They bought a house. The roof of the house was damaged."', '[{"id":"a","text":"They bought a house which roof was damaged."},{"id":"b","text":"They bought a house whose roof was damaged."},{"id":"c","text":"They bought a house who roof was damaged."},{"id":"d","text":"They bought a house where roof was damaged."}]'::jsonb, 'b', 'whose shows possession and works for things too, replacing "of the house": a house whose roof was damaged. "which" can''t sit before a noun like this (a), "who" is for people (c), and "where" marks a place, not possession (d).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('60c9ba60-c9a5-5944-a549-70732127877f', '6e3123e2-e3b7-58f3-97ef-bd81c64a486b', 'Choose the fully correct sentence.', '[{"id":"a","text":"The colleague whose idea we used got a bonus."},{"id":"b","text":"The colleague who''s idea we used got a bonus."},{"id":"c","text":"The colleague which idea we used got a bonus."},{"id":"d","text":"The colleague what idea we used got a bonus."}]'::jsonb, 'a', 'whose shows possession (their idea): the colleague whose idea we used. "who''s" means "who is" (b), "which" is for things and can''t be possessive here (c), and "what" is never a relative pronoun (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29b8bf81-87a7-5257-8ed8-9dfc20f24f06', '6e3123e2-e3b7-58f3-97ef-bd81c64a486b', 'Complete: "I work with people ___ come from a country ___ four languages are spoken."', '[{"id":"a","text":"which … whose"},{"id":"b","text":"whose … who"},{"id":"c","text":"that … which"},{"id":"d","text":"who … where"}]'::jsonb, 'd', '"people" are persons and the subject of "come" (who), and a country is a place where languages are spoken (where). So: who … where. The other pairs mismatch — people are never "which/whose" as the doer, and "in a country which" would need the place as an object.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3360361-8de7-5491-a29c-9e3c5fa80b8b', '6e3123e2-e3b7-58f3-97ef-bd81c64a486b', 'Find the INCORRECT sentence.', '[{"id":"a","text":"The town where I was born has a famous market."},{"id":"b","text":"The author whose novel won the prize is only twenty."},{"id":"c","text":"The thing what surprised me most was the silence."},{"id":"d","text":"The man who fixed my car charged too much."}]'::jsonb, 'c', 'In (c), "the thing what surprised me" is wrong: never use "what" as a relative pronoun — say the thing that surprised me. (a) uses where for a place, (b) uses whose for possession, and (d) uses who for a person — all correct.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('613c498b-4dfd-5e31-8fc2-46ce28996c88', '103f22ad-0c64-534c-b534-dc30a036c9fb', 'anglais-b1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('db250069-c0d0-5a84-82b9-e310c036bfbe', '613c498b-4dfd-5e31-8fc2-46ce28996c88', 'Complete: "When I was a child, I ___ hate vegetables."', '[{"id":"a","text":"used to"},{"id":"b","text":"was used to"},{"id":"c","text":"would"},{"id":"d","text":"got used to"}]'::jsonb, 'a', '"hate" is a state verb, so only "used to" works here: I used to hate vegetables. "would" cannot be used with state verbs like hate, and "was/got used to" means accustomed to, which is a different structure.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c485e0c6-2051-52e1-b28c-5a7ad4daed8b', '613c498b-4dfd-5e31-8fc2-46ce28996c88', 'Complete: "Every evening, my father ___ read us a story."', '[{"id":"a","text":"was used to"},{"id":"b","text":"got used to"},{"id":"c","text":"would"},{"id":"d","text":"is used to"}]'::jsonb, 'c', 'Reading a story is a repeated past action (not a state), so "would" is correct: my father would read us a story. "be/get used to" means accustomed and takes -ing after it, which is a completely different idea.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d419fd09-2a78-5042-9b4a-0ae9bfdb3ccb', '613c498b-4dfd-5e31-8fc2-46ce28996c88', 'Which sentence is CORRECT?', '[{"id":"a","text":"I would have a dog when I was young."},{"id":"b","text":"She used to be very quiet as a teenager."},{"id":"c","text":"Did you used to live here?"},{"id":"d","text":"We would know each other at school."}]'::jsonb, 'b', '"be" is a state verb, so only "used to" works: She used to be very quiet. "would have" and "would know" are wrong because have and know are state verbs. "Did you used to" is wrong — the -d drops in questions: Did you use to.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('443d6be7-214a-5e41-8a09-d8dd0559ebc7', '613c498b-4dfd-5e31-8fc2-46ce28996c88', 'Complete: "She is ___ working night shifts now."', '[{"id":"a","text":"used to"},{"id":"b","text":"used to be"},{"id":"c","text":"get used to"},{"id":"d","text":"used to working"}]'::jsonb, 'd', '"be used to + -ing" expresses being accustomed: she is used to working. The full phrase here is "used to working". "used to" alone (without be) is the past-habit structure, and "get used to" means becoming accustomed, not already there.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('60a2e2b4-cffd-58f7-971c-ccf7e95f34eb', '613c498b-4dfd-5e31-8fc2-46ce28996c88', 'What is the KEY difference between "I used to work late" and "I am used to working late"?', '[{"id":"a","text":"The first is present, the second is past."},{"id":"b","text":"The first describes a past habit (now stopped); the second means I am accustomed to it now."},{"id":"c","text":"They mean exactly the same thing."},{"id":"d","text":"The first is more formal than the second."}]'::jsonb, 'b', '"used to work late" describes a past habit that has stopped. "am used to working late" means it is normal for me now — I am accustomed to it. They look similar but have very different meanings: past habit vs present familiarity.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8ab2550a-800d-572c-8f39-959b128f8c91', '103f22ad-0c64-534c-b534-dc30a036c9fb', 'anglais-b1', '⭐ Practice: Used to and Would', 1, 50, 10, 'practice', 'admin', 1)
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
  ('3ef4230f-a1ca-57aa-8648-69d1b46ed1e2', '8ab2550a-800d-572c-8f39-959b128f8c91', 'Complete: "I ___ play outside until dark when I was a kid."', '[{"id":"a","text":"used to"},{"id":"b","text":"am used to"},{"id":"c","text":"get used to"},{"id":"d","text":"was used to"}]'::jsonb, 'a', 'Playing outside is a repeated past habit that no longer happens, so "used to" is correct: I used to play outside. "am/was used to" and "get used to" mean accustomed to, which is a different idea.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6835d0cd-7a8d-5416-a7e2-a7bd9768679e', '8ab2550a-800d-572c-8f39-959b128f8c91', 'Complete: "My grandmother ___ bake bread every Sunday morning."', '[{"id":"a","text":"got used to"},{"id":"b","text":"is used to"},{"id":"c","text":"would"},{"id":"d","text":"used to be"}]'::jsonb, 'c', 'Baking bread is a repeated past action (not a state), so "would" fits perfectly: she would bake bread every Sunday. "got/is used to" means accustomed to and takes -ing. "used to be" adds "be" which doesn''t fit before "bake".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a7bc8a6d-949c-50b8-a0df-08a649028bb6', '8ab2550a-800d-572c-8f39-959b128f8c91', 'Complete: "He ___ have long hair when he was a student."', '[{"id":"a","text":"would"},{"id":"b","text":"used to"},{"id":"c","text":"was used to"},{"id":"d","text":"is used to"}]'::jsonb, 'b', '"have" (possess) is a state verb, so "would" cannot be used — only "used to" works: He used to have long hair. "was/is used to" means accustomed to, not a past habit.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f35a666-cd6d-5899-a5bf-2c4c67a793c9', '8ab2550a-800d-572c-8f39-959b128f8c91', 'Complete: "Did you ___ walk to school?"', '[{"id":"a","text":"used to"},{"id":"b","text":"use to"},{"id":"c","text":"would"},{"id":"d","text":"using to"}]'::jsonb, 'b', 'In questions with did, the -d disappears: Did you use to walk to school? This is the standard question form. "used to" keeps the -d which is wrong after did, and "using to" / "would" do not fit this question structure.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4dfec0e-5b28-5764-9ef4-b4ffd40b83af', '8ab2550a-800d-572c-8f39-959b128f8c91', 'Complete: "She is slowly ___ living alone."', '[{"id":"a","text":"used to"},{"id":"b","text":"would"},{"id":"c","text":"getting used to"},{"id":"d","text":"use to"}]'::jsonb, 'c', '"get used to + -ing" means to become accustomed to something: she is getting used to living alone. "used to" alone describes a past habit (finished), and "would" describes repeated past actions, neither of which fits this present-progressive context.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb96c944-c197-5a3e-8be5-a6ebdc8a2753', '8ab2550a-800d-572c-8f39-959b128f8c91', 'Complete: "We ___ spend our summers at the beach when the children were small."', '[{"id":"a","text":"are used to"},{"id":"b","text":"used to"},{"id":"c","text":"got used to"},{"id":"d","text":"use to"}]'::jsonb, 'b', 'Spending summers at the beach is a past repeated habit now finished, so "used to" is correct: We used to spend our summers at the beach. "are/got used to" means accustomed to, and "use to" is only correct after did in a question.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8144efc4-8228-5d01-b3cc-1e36c3bdef4f', '103f22ad-0c64-534c-b534-dc30a036c9fb', 'anglais-b1', '⭐⭐ Review: Used to vs Would vs Be/Get Used to', 2, 75, 15, 'practice', 'admin', 2)
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
  ('600e2c60-c2a2-5925-988a-5bd41b4bee33', '8144efc4-8228-5d01-b3cc-1e36c3bdef4f', 'Complete: "My brother ___ be very shy, but now he''s very confident."', '[{"id":"a","text":"would"},{"id":"b","text":"is used to"},{"id":"c","text":"used to"},{"id":"d","text":"was getting used to"}]'::jsonb, 'c', '"be" is a state verb, so only "used to" can express this past state: My brother used to be shy. "would" is only for repeated actions, not states, "is used to" means accustomed to, and "was getting used to" means becoming accustomed.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2189b79f-f14c-5c54-a7fc-cab8bbf2db79', '8144efc4-8228-5d01-b3cc-1e36c3bdef4f', 'Complete: "On weekends, we ___ go fishing at the lake with our father."', '[{"id":"a","text":"used to"},{"id":"b","text":"would"},{"id":"c","text":"are used to"},{"id":"d","text":"got used to"}]'::jsonb, 'b', 'Going fishing is a repeated past action (not a state), so both "used to" and "would" work — but (a) is also correct. Here (b) is the target answer because "would" with a time frame like "on weekends" is the classic narrative pattern. "are/got used to" mean accustomed to.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d5d564b-acf2-5119-8441-8666f1156e80', '8144efc4-8228-5d01-b3cc-1e36c3bdef4f', 'Find the ERROR: "They would know all their neighbours when they lived in the village."', '[{"id":"a","text":"would know"},{"id":"b","text":"all their neighbours"},{"id":"c","text":"when they lived"},{"id":"d","text":"in the village"}]'::jsonb, 'a', 'The error is "would know": know is a state verb, so "would" cannot replace "used to" here. The correct sentence is: They used to know all their neighbours. "would" is only valid with action verbs, never with state verbs like know.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70cdc1fd-92d9-5dad-a54e-a638f3f51e74', '8144efc4-8228-5d01-b3cc-1e36c3bdef4f', 'Complete: "She didn''t ___ eating spicy food, but she loves it now."', '[{"id":"a","text":"use to"},{"id":"b","text":"used to"},{"id":"c","text":"would"},{"id":"d","text":"get used to"}]'::jsonb, 'a', 'In the negative form with "didn''t", the -d disappears: she didn''t use to eat spicy food. "didn''t used to" keeps the -d wrongly after did. "would" doesn''t form negatives the same way in this context, and "get used to" means to become accustomed.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('722365dd-6107-5607-9184-ddafc2ca4613', '8144efc4-8228-5d01-b3cc-1e36c3bdef4f', 'Complete: "My grandfather ___ tell us old stories about the war after dinner."', '[{"id":"a","text":"is used to"},{"id":"b","text":"would"},{"id":"c","text":"gets used to"},{"id":"d","text":"was used to"}]'::jsonb, 'b', 'Telling stories is a repeated past action (action verb "tell"), so "would" is the perfect nostalgic narrative choice: my grandfather would tell us stories. "is/was/gets used to" all mean accustomed to and take -ing after them.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2f1241d3-dec9-5cc3-bafe-214c49c19eb3', '8144efc4-8228-5d01-b3cc-1e36c3bdef4f', 'Complete: "He has just moved to the city and is slowly ___ the noise."', '[{"id":"a","text":"used to"},{"id":"b","text":"would"},{"id":"c","text":"getting used to"},{"id":"d","text":"use to"}]'::jsonb, 'c', '"get used to + -ing/noun" describes the process of becoming accustomed: he is getting used to the noise. "used to" (without be/get) is the past habit structure, "would" describes repeated past actions, and "use to" is only correct after did in a question or negative.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f7a5a7aa-5d82-5ffe-a31d-c098d4e4a52c', '103f22ad-0c64-534c-b534-dc30a036c9fb', 'anglais-b1', '⚔️ Chapter Boss ⭐⭐⭐: Past Habits: Used to and Would', 3, 120, 30, 'boss', 'admin', 3)
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
  ('ad873ea6-b61b-53a3-a321-1d7170e6b5f0', 'f7a5a7aa-5d82-5ffe-a31d-c098d4e4a52c', 'Find the INCORRECT sentence.', '[{"id":"a","text":"I used to live near the sea."},{"id":"b","text":"We would visit my aunt every summer."},{"id":"c","text":"She would have a red bicycle as a child."},{"id":"d","text":"Did you use to play the piano?"}]'::jsonb, 'c', 'The error is (c): "have" (possess) is a state verb, so "would" cannot be used. The correct form is: She used to have a red bicycle. (a) and (b) are correct — used to for a state, would for a repeated action. (d) correctly drops the -d after did.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f97ee10-fad9-5cbc-90f0-cd7ee25621b8', 'f7a5a7aa-5d82-5ffe-a31d-c098d4e4a52c', 'Complete: "I ___ wake up at 6 a.m. every day when I was training for the marathon."', '[{"id":"a","text":"am used to"},{"id":"b","text":"would"},{"id":"c","text":"get used to"},{"id":"d","text":"was used to"}]'::jsonb, 'b', 'Waking up every day at 6 a.m. is a repeated past action (action verb), so "would" is correct: I would wake up at 6 a.m. every day. "am/was used to" and "get used to" mean accustomed to — a different idea — and both need -ing after them.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4497b4b8-d5e9-5cff-80be-9917515644a1', 'f7a5a7aa-5d82-5ffe-a31d-c098d4e4a52c', 'Complete: "___ she use to walk to school, or did she take the bus?"', '[{"id":"a","text":"Has"},{"id":"b","text":"Was"},{"id":"c","text":"Would"},{"id":"d","text":"Did"}]'::jsonb, 'd', 'The question form of "used to" is: Did + subject + use to + verb? — Did she use to walk to school? "Has" forms the present perfect, "Was" starts a past-continuous question, and "Would" needs a different word order: Would she walk to school? — which is also possible but doesn''t fit the "use to" that follows.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c8acaf3-841e-51ba-b2e2-efe1398abba7', 'f7a5a7aa-5d82-5ffe-a31d-c098d4e4a52c', 'Complete: "After a few weeks, the new students ___ waking up early for lectures."', '[{"id":"a","text":"got used to"},{"id":"b","text":"would"},{"id":"c","text":"used to"},{"id":"d","text":"were used to be"}]'::jsonb, 'a', 'The context describes becoming accustomed to something (after a few weeks, a process), so "get used to + -ing" in the past is correct: they got used to waking up early. "used to" describes a finished past habit, "would" describes repeated actions, and "were used to be" is ungrammatical (it should be "were used to being").', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9a71e4e-f4dd-5725-bda1-f8174d5f0ad0', 'f7a5a7aa-5d82-5ffe-a31d-c098d4e4a52c', 'Complete: "My teacher ___ give us extra homework on Fridays — we dreaded it every week."', '[{"id":"a","text":"was used to"},{"id":"b","text":"used to"},{"id":"c","text":"would"},{"id":"d","text":"got used to"}]'::jsonb, 'c', 'Giving homework every Friday is a repeated past action (action verb "give"), and the narrative tone ("we dreaded it every week") suits the nostalgic "would" for vivid storytelling: would give. "used to give" is also grammatically valid, but (c) is the target here as the more natural narrative choice. "was/got used to" mean accustomed to.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad8a9816-c107-52e5-9d22-262c4619b6ad', 'f7a5a7aa-5d82-5ffe-a31d-c098d4e4a52c', 'Complete: "I think I ___ speak English better when I was in London — I''ve lost some fluency."', '[{"id":"a","text":"used to"},{"id":"b","text":"would"},{"id":"c","text":"am used to"},{"id":"d","text":"get used to"}]'::jsonb, 'a', 'Speaking English better in London was a past state (a capability that is no longer true now — "I''ve lost some fluency"). Since it''s a state, not a repeated action, only "used to" is correct: I used to speak English better. "would" is for past repeated actions, not states, and "am/get used to" mean accustomed to.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7e9dc9ca-d981-5203-b9b2-a00276e23f81', '103f22ad-0c64-534c-b534-dc30a036c9fb', 'anglais-b1', '👑 Elite Challenge ⭐⭐⭐⭐: Past Habits: Used to and Would', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('b06fe6d0-127c-5511-9b1e-f6eb14ab2d0f', '7e9dc9ca-d981-5203-b9b2-a00276e23f81', 'Read: "Layla grew up in a small town. She would cycle to school every morning and used to know every family on her street. Now she lives in a big city and is getting used to the anonymous life."
Which statement is TRUE?', '[{"id":"a","text":"Layla still knows every family on her old street."},{"id":"b","text":"Layla finds city life easy because she always lived there."},{"id":"c","text":"Layla used to cycle to school as a child in her town."},{"id":"d","text":"Layla is already fully accustomed to anonymous city life."}]'::jsonb, 'c', 'The text says she "would cycle to school every morning" in her town, so she used to cycle as a child (c is true). "used to know every family" means she no longer knows them, so (a) is false. She is "getting used to" city life — still in process — so (d) is false. She grew up in a small town, not a city, so (b) is false.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e666eae-abce-52b4-9224-63d4753624a0', '7e9dc9ca-d981-5203-b9b2-a00276e23f81', 'Find the sentence that is GRAMMATICALLY CORRECT.', '[{"id":"a","text":"I am used to wake up early."},{"id":"b","text":"We would know the answer in those days."},{"id":"c","text":"She didn''t used to like tea."},{"id":"d","text":"He used to play chess every evening."}]'::jsonb, 'd', '"He used to play chess every evening" is correct: used to + base verb for a past habit (d). (a) is wrong — after "be used to" we need -ing: I am used to waking up. (b) is wrong — "know" is a state verb and cannot take "would". (c) is wrong — after "didn''t" the -d drops: didn''t use to.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75ab7c72-9799-564c-ac54-49ae6593b635', '7e9dc9ca-d981-5203-b9b2-a00276e23f81', 'Complete with the most natural choice: "In the 1980s, people ___ write letters instead of sending messages online."', '[{"id":"a","text":"would"},{"id":"b","text":"get used to"},{"id":"c","text":"are used to"},{"id":"d","text":"used to be"}]'::jsonb, 'a', 'Writing letters is a repeated past action (action verb "write"), and the narrative context of "in the 1980s" suits the vivid storytelling "would": people would write letters. "used to write" is also grammatically valid, but "would" is more natural in this narrative-history register. "are/get used to" mean accustomed to, and "used to be" adds "be" which doesn''t fit before "write".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c0efbb21-3093-5def-9634-3aedbc54ac4a', '7e9dc9ca-d981-5203-b9b2-a00276e23f81', 'Complete: "After working night shifts for a month, she ___ sleeping during the day."', '[{"id":"a","text":"used to"},{"id":"b","text":"got used to"},{"id":"c","text":"would"},{"id":"d","text":"was used to be"}]'::jsonb, 'b', '"After working… for a month" shows a process of becoming accustomed. "get used to + -ing" in the past: she got used to sleeping during the day. "used to" alone describes a finished past habit (without the sense of adaptation), "would" describes repeated actions, and "was used to be" is ungrammatical (it should be "was used to being").', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4928f93e-c19a-5c6e-a80b-382be2148e2f', '7e9dc9ca-d981-5203-b9b2-a00276e23f81', 'Read: "Omar has moved to Canada. At first, the cold was a shock. He used to live in a hot climate, and he wasn''t used to wearing heavy coats. After two winters, though, he has got used to it."
What can we infer?', '[{"id":"a","text":"Omar always loved cold weather."},{"id":"b","text":"Omar is still struggling to adjust to the cold."},{"id":"c","text":"Omar now feels comfortable with the cold climate."},{"id":"d","text":"Omar used to wear heavy coats in his home country."}]'::jsonb, 'c', '"He has got used to it" after two winters means he is now comfortable with the cold (c). He lived in a hot climate and was NOT used to heavy coats (a and d are false). He has already adapted, so he is no longer struggling (b is false).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6b376cde-8f56-5528-948f-bf75ac2111b8', '7e9dc9ca-d981-5203-b9b2-a00276e23f81', 'Complete: "The children ___ be afraid of the dark, but since their parents bought them a nightlight, they''ve stopped worrying."', '[{"id":"a","text":"used to"},{"id":"b","text":"are getting used to"},{"id":"c","text":"would"},{"id":"d","text":"are used to"}]'::jsonb, 'a', 'Being afraid is a state (state verb: be afraid), so only "used to" can describe this finished past state: the children used to be afraid. "would" cannot be used with state verbs. "are getting used to" means becoming accustomed to — a different idea. "are used to" describes being accustomed right now, which contradicts "they''ve stopped worrying" suggesting the habit is gone.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5cc36d18-273a-56f9-9b31-59562c739128', '777eefdf-d77b-55c6-be60-dee5cdaf1fae', 'anglais-b1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d424fcfe-6b26-5c86-9797-e2fe4e065e18', '5cc36d18-273a-56f9-9b31-59562c739128', 'What does "give up" mean?', '[{"id":"a","text":"To offer something to someone"},{"id":"b","text":"To stop trying or quit"},{"id":"c","text":"To look for something"},{"id":"d","text":"To find something by accident"}]'::jsonb, 'b', '"Give up" is an idiomatic phrasal verb meaning to stop trying or to quit something. It does not mean to physically give something in an upward direction. Giving something to someone is just "give", and "find out" means to discover.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22546303-f91d-51fb-a92b-b2e10f884324', '5cc36d18-273a-56f9-9b31-59562c739128', 'Complete: "Can you ___ the music? I can''t hear it."', '[{"id":"a","text":"turn off"},{"id":"b","text":"put off"},{"id":"c","text":"give up"},{"id":"d","text":"turn up"}]'::jsonb, 'd', '"Turn up" means to increase the volume. "Turn off" means to switch off completely. "Put off" means to postpone, and "give up" means to stop trying. If you can''t hear something, you need to make it louder — turn it up.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e87994a-baf0-54ce-9df2-f79501aed4c4', '5cc36d18-273a-56f9-9b31-59562c739128', 'Which sentence uses the pronoun rule CORRECTLY?', '[{"id":"a","text":"Turn on it."},{"id":"b","text":"She turned it on."},{"id":"c","text":"She turned on it."},{"id":"d","text":"Turn it on off."}]'::jsonb, 'b', 'When the object of a separable phrasal verb is a pronoun, it MUST go between the verb and the particle: she turned it on. "Turn on it" and "turned on it" place the pronoun after the particle — incorrect. "Turn it on off" is nonsense.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be48946f-213a-56e5-9904-4257f96a7992', '5cc36d18-273a-56f9-9b31-59562c739128', 'Complete: "I ___ an old school friend on the bus yesterday."', '[{"id":"a","text":"ran into"},{"id":"b","text":"looked after"},{"id":"c","text":"set off"},{"id":"d","text":"found out"}]'::jsonb, 'a', '"Run into" means to meet someone by chance: I ran into an old friend. "Look after" means to take care of, "set off" means to begin a journey, and "find out" means to discover information. Only running into fits an unexpected meeting.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5976220a-969b-564c-aed9-9bc7f08eb752', '5cc36d18-273a-56f9-9b31-59562c739128', 'What is the KEY difference between SEPARABLE and INSEPARABLE phrasal verbs?', '[{"id":"a","text":"Separable phrasal verbs have two words; inseparable have three."},{"id":"b","text":"In separable verbs, the object (especially a pronoun) can go between verb and particle; in inseparable verbs, the object always follows the full phrasal verb."},{"id":"c","text":"Separable phrasal verbs are always literal; inseparable ones are always idiomatic."},{"id":"d","text":"Inseparable phrasal verbs can only be used in questions."}]'::jsonb, 'b', 'The core rule: with separable phrasal verbs, the object — especially pronouns — can (or must) go between the verb and particle (turn it on). With inseparable ones, the object always comes after the complete phrasal verb (look after the baby — never look the baby after). The number of words or literal/idiomatic status does not determine separability.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1c491d91-b7dc-5483-b1fc-3aed50e185ba', '777eefdf-d77b-55c6-be60-dee5cdaf1fae', 'anglais-b1', '⭐ Practice: Phrasal Verbs', 1, 50, 10, 'practice', 'admin', 1)
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
  ('c707cf03-c002-5367-9322-1e263232c331', '1c491d91-b7dc-5483-b1fc-3aed50e185ba', 'Complete: "I need to ___ at six o''clock for my early flight."', '[{"id":"a","text":"get up"},{"id":"b","text":"give up"},{"id":"c","text":"turn off"},{"id":"d","text":"put off"}]'::jsonb, 'a', '"Get up" means to rise from bed: I need to get up at six. "Give up" means to stop trying, "turn off" means to switch something off, and "put off" means to postpone — none of these fit waking up early for a flight.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e064b766-61d0-5da7-90d3-2ac43970b0dc', '1c491d91-b7dc-5483-b1fc-3aed50e185ba', 'Complete: "She has decided to ___ smoking. She hasn''t had a cigarette in weeks."', '[{"id":"a","text":"find out"},{"id":"b","text":"look after"},{"id":"c","text":"give up"},{"id":"d","text":"run into"}]'::jsonb, 'c', '"Give up" means to stop or quit: she has given up smoking. "Find out" means to discover, "look after" means to take care of, and "run into" means to meet by chance. Quitting a habit is always "give up".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9381ccf8-1cf7-5b1c-96a2-b49d4c2a5f7b', '1c491d91-b7dc-5483-b1fc-3aed50e185ba', 'Complete: "Can you ___ the lights? It''s dark in here."', '[{"id":"a","text":"put off"},{"id":"b","text":"set off"},{"id":"c","text":"get up"},{"id":"d","text":"turn on"}]'::jsonb, 'd', '"Turn on" means to activate or switch on: turn on the lights. "Turn off" would switch them off. "Put off" means to postpone, "set off" means to begin a journey, and "get up" means to rise from bed.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('759625f5-61a1-58d0-b206-8bbba18f6c12', '1c491d91-b7dc-5483-b1fc-3aed50e185ba', 'Complete: "My grandmother ___ my little brother when my parents are at work."', '[{"id":"a","text":"looks after"},{"id":"b","text":"finds out"},{"id":"c","text":"gives up"},{"id":"d","text":"sets off"}]'::jsonb, 'a', '"Look after" means to take care of someone: my grandmother looks after my brother. "Find out" means to discover, "give up" means to quit, and "set off" means to begin a journey — none of these fit taking care of a child.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('217d042b-3a8d-5e84-9910-ddd2b674805a', '1c491d91-b7dc-5483-b1fc-3aed50e185ba', 'Complete: "We''ve ___ milk. Can you go to the shop?"', '[{"id":"a","text":"put off"},{"id":"b","text":"run out of"},{"id":"c","text":"looked up"},{"id":"d","text":"turned on"}]'::jsonb, 'b', '"Run out of" means to have no more of something: we''ve run out of milk. "Put off" means to postpone, "look up" means to search for information, and "turn on" means to switch something on — none of these describe having no more milk.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('adde924f-5cf8-5814-9303-306ca67cd712', '1c491d91-b7dc-5483-b1fc-3aed50e185ba', 'Complete: "Don''t ___ your homework. Do it now!"', '[{"id":"a","text":"run into"},{"id":"b","text":"get up"},{"id":"c","text":"put off"},{"id":"d","text":"find out"}]'::jsonb, 'c', '"Put off" means to delay or postpone: don''t put off your homework. "Run into" means to meet by chance, "get up" means to rise from bed, and "find out" means to discover — none of these fit the idea of not delaying a task.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6ae4d1fc-bcb0-560a-95cc-7af77fa6060e', '777eefdf-d77b-55c6-be60-dee5cdaf1fae', 'anglais-b1', '⭐⭐ Review: Separable, Inseparable & Idiomatic', 2, 75, 15, 'practice', 'admin', 2)
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
  ('d7cc2990-c2dd-5e36-8ef9-5051ab16a1d6', '6ae4d1fc-bcb0-560a-95cc-7af77fa6060e', 'Choose the CORRECT sentence with the pronoun.', '[{"id":"a","text":"Please turn on it."},{"id":"b","text":"Please turn it on."},{"id":"c","text":"Please it turn on."},{"id":"d","text":"Please on turn it."}]'::jsonb, 'b', 'When the object of a separable phrasal verb is a pronoun, it must go between the verb and the particle: Please turn it on. Placing a pronoun after the particle (turn on it) is ungrammatical in standard English.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('705369ce-5f06-5b03-9d5f-066f6fb9800a', '6ae4d1fc-bcb0-560a-95cc-7af77fa6060e', 'Complete: "I need to ___ what time the train leaves. Let me check online."', '[{"id":"a","text":"give up"},{"id":"b","text":"find out"},{"id":"c","text":"look after"},{"id":"d","text":"get up"}]'::jsonb, 'b', '"Find out" means to discover information: I need to find out the train time. "Give up" means to quit, "look after" means to take care of someone, and "get up" means to rise from bed. Searching for information is "find out".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2cf9a555-1d18-54f7-8af8-1a3d3787eefb', '6ae4d1fc-bcb0-560a-95cc-7af77fa6060e', 'Complete: "They were ___ the trip all month — finally it arrived!"', '[{"id":"a","text":"running out of"},{"id":"b","text":"putting off"},{"id":"c","text":"looking forward to"},{"id":"d","text":"getting up for"}]'::jsonb, 'c', '"Look forward to" means to feel excited and happy about something in the future: they were looking forward to the trip. "Run out of" means to have no more, "put off" means to postpone, and "get up for" doesn''t convey excitement.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b2b37ef-b099-5e55-b118-48b6032fc110', '6ae4d1fc-bcb0-560a-95cc-7af77fa6060e', 'Which sentence is INCORRECT?', '[{"id":"a","text":"She looked the word up in the dictionary."},{"id":"b","text":"He looked up it in the dictionary."},{"id":"c","text":"They found out the truth eventually."},{"id":"d","text":"We set off very early in the morning."}]'::jsonb, 'b', 'The error is (b): "look up" is a separable phrasal verb, and when the object is a pronoun, it must go between verb and particle — He looked it up, not "looked up it". (a) uses a noun after the particle (fine), (c) and (d) are correctly formed.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b657e2f-be13-546e-bcde-9adaae57c8f9', '6ae4d1fc-bcb0-560a-95cc-7af77fa6060e', 'Complete: "The boss ___ the meeting until next Monday."', '[{"id":"a","text":"put off"},{"id":"b","text":"ran into"},{"id":"c","text":"set off"},{"id":"d","text":"got up"}]'::jsonb, 'a', '"Put off" means to postpone or delay: the boss put off the meeting. "Run into" means to meet by chance, "set off" means to begin a journey, and "get up" means to rise from bed. Only "put off" fits the context of delaying a scheduled event.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e93fb82-7047-5f3f-8a45-a323fb700e52', '6ae4d1fc-bcb0-560a-95cc-7af77fa6060e', 'Complete: "I''m looking forward to ___ you at the conference next week."', '[{"id":"a","text":"see"},{"id":"b","text":"seen"},{"id":"c","text":"will see"},{"id":"d","text":"seeing"}]'::jsonb, 'd', 'After "look forward to", the next verb must be in the -ing form (gerund), because "to" here is a preposition, not the infinitive marker: looking forward to seeing you. "See" is the base, "seen" is the participle, and "will see" adds an extra auxiliary that doesn''t fit.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6ccd5b92-839b-5432-9d9e-323f2571f5af', '777eefdf-d77b-55c6-be60-dee5cdaf1fae', 'anglais-b1', '⚔️ Chapter Boss ⭐⭐⭐: Phrasal Verbs', 3, 120, 30, 'boss', 'admin', 3)
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
  ('307309a7-21e3-5a2a-9fd7-c1a9b647a735', '6ccd5b92-839b-5432-9d9e-323f2571f5af', 'Complete: "We need to ___ a solution to this problem quickly."', '[{"id":"a","text":"come up with"},{"id":"b","text":"run out of"},{"id":"c","text":"put off"},{"id":"d","text":"look after"}]'::jsonb, 'a', '"Come up with" means to think of or produce an idea/solution: we need to come up with a solution. "Run out of" means to have no more, "put off" means to postpone, and "look after" means to take care of someone — none of these fit producing an idea.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1fd909f6-6154-5fe9-9c8a-ccbca6de177a', '6ccd5b92-839b-5432-9d9e-323f2571f5af', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Can you look after the dog this weekend?"},{"id":"b","text":"She looked the baby after all afternoon."},{"id":"c","text":"He picked her up at the airport."},{"id":"d","text":"I ran into him accidentally last night."}]'::jsonb, 'b', 'The error is (b): "look after" is inseparable — the object must always come after the full phrasal verb, never in the middle. The correct sentence is: She looked after the baby all afternoon. (a) and (d) use inseparable verbs correctly, and (c) correctly places the pronoun between verb and particle.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e0960d2-a42f-53ae-86b8-3dd71c394505', '6ccd5b92-839b-5432-9d9e-323f2571f5af', 'Choose the CORRECT sentence.', '[{"id":"a","text":"She looked him after carefully."},{"id":"b","text":"Turn off it, please."},{"id":"c","text":"They gave up their plans it."},{"id":"d","text":"She looked after him carefully."}]'::jsonb, 'd', '"Look after" is inseparable, so the object always follows the full phrasal verb: she looked after him (d) is correct. (a) splits an inseparable verb — wrong. (b) should be "Turn it off" — pronoun must go between verb and particle. (c) is ungrammatical.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bb06d9a-78b4-5b8a-8c3e-74376e21aa1e', '6ccd5b92-839b-5432-9d9e-323f2571f5af', 'Complete: "The light was already on, so she ___ before leaving."', '[{"id":"a","text":"turned off it"},{"id":"b","text":"found it out"},{"id":"c","text":"put it off"},{"id":"d","text":"turned it off"}]'::jsonb, 'd', 'To switch off an electric device: turn off. Since the object is a pronoun (it), it goes between verb and particle: she turned it off (d). (a) incorrectly places the pronoun after the particle. (b) "found it out" is not natural English for this context — the idiom is "found out the truth". (c) "put off" means to postpone.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9946b2ef-6d22-57a0-a84a-2033818f5575', '6ccd5b92-839b-5432-9d9e-323f2571f5af', 'Complete: "She''s training for a marathon every day — I admire that she hasn''t ___ yet."', '[{"id":"a","text":"put it off"},{"id":"b","text":"run out of it"},{"id":"c","text":"given up"},{"id":"d","text":"set off"}]'::jsonb, 'c', 'The context is about persisting with a challenging activity — not quitting. "Give up" means to stop trying: she hasn''t given up. "Put off" means to postpone, "run out of" means to have no more of something, and "set off" means to begin a journey.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ece2ef1-7da9-52ac-9df2-101335757174', '6ccd5b92-839b-5432-9d9e-323f2571f5af', 'Complete: "He ___ an old university friend while shopping at the market."', '[{"id":"a","text":"found out"},{"id":"b","text":"looked after"},{"id":"c","text":"ran into"},{"id":"d","text":"set off"}]'::jsonb, 'c', '"Run into" means to meet someone unexpectedly or by chance: he ran into an old friend. "Find out" means to discover information, "look after" means to take care of someone, and "set off" means to begin a journey. An unexpected meeting is always "run into".', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3dfa33ef-a915-5031-92e1-5bb239e854d0', '777eefdf-d77b-55c6-be60-dee5cdaf1fae', 'anglais-b1', '👑 Elite Challenge ⭐⭐⭐⭐: Phrasal Verbs', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('512017cc-7729-5f01-8c13-5004d9ebc70c', '3dfa33ef-a915-5031-92e1-5bb239e854d0', 'Read: "Karim set off early but ran into heavy traffic on the motorway. He had already run out of patience when he finally found out there was an accident two kilometres ahead."
Which phrasal verb means to DISCOVER information?', '[{"id":"a","text":"set off"},{"id":"b","text":"ran into"},{"id":"c","text":"run out of"},{"id":"d","text":"found out"}]'::jsonb, 'd', '"Find out" means to discover information: he found out there was an accident. "Set off" means to begin a journey, "run into" means to meet/encounter by chance (here: encountered traffic), and "run out of" means to have no more of something (here: patience).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5cc61bd1-3d73-52af-85a0-bc35697cc948', '3dfa33ef-a915-5031-92e1-5bb239e854d0', 'Complete with the correct form: "The teacher handed out the test papers and asked students to ___ their phones."', '[{"id":"a","text":"turn off them"},{"id":"b","text":"turn them off"},{"id":"c","text":"off turn them"},{"id":"d","text":"them turn off"}]'::jsonb, 'b', '"Turn off" is a separable phrasal verb. When the object is a pronoun (them), it must go between the verb and particle: turn them off. "Turn off them" places the pronoun after the particle — incorrect with pronouns. The other options are ungrammatical word orders.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f30ae529-a03a-5252-8364-b679aeb69228', '3dfa33ef-a915-5031-92e1-5bb239e854d0', 'Find the sentence that is GRAMMATICALLY CORRECT.', '[{"id":"a","text":"He gave up trying after an hour."},{"id":"b","text":"I''m looking forward to meet the team."},{"id":"c","text":"She ran into it unexpectedly."},{"id":"d","text":"We looked after them after of carefully."}]'::jsonb, 'a', '"He gave up trying" is correct: give up + -ing (gerund) works naturally here (a). (b) is wrong — after "look forward to", use -ing: looking forward to meeting. (c) is wrong — "run into" is inseparable: you can''t split it with a pronoun this way. (d) is ungrammatical — "after of" is not English.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f7ea747-a34d-5e69-ab5b-556c41148c7c', '3dfa33ef-a915-5031-92e1-5bb239e854d0', 'Complete: "Don''t ___ calling the doctor. It might be serious."', '[{"id":"a","text":"run into"},{"id":"b","text":"look after"},{"id":"c","text":"find out"},{"id":"d","text":"put off"}]'::jsonb, 'd', '"Put off" means to delay or postpone. Here it takes a gerund after it: don''t put off calling. "Run into" means to meet by chance, "look after" means to take care of, and "find out" means to discover — none of these fit the warning not to delay something serious.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('348f4483-9030-5dd5-8eb3-b523fda04a50', '3dfa33ef-a915-5031-92e1-5bb239e854d0', 'Read: "Sara is a talented artist. At school, her teachers often told her to give up painting and focus on academic subjects. But Sara didn''t listen. She looked up techniques online, got up at 5 a.m. to practise, and set off to art college at 18."
Which statement is TRUE?', '[{"id":"a","text":"Sara gave up painting because of her teachers."},{"id":"b","text":"Sara researched painting techniques using the internet."},{"id":"c","text":"Sara''s teachers looked after her artistic career."},{"id":"d","text":"Sara put off going to art college until she was 20."}]'::jsonb, 'b', '"She looked up techniques online" means she researched/searched for them online (b is true). She did NOT give up — she resisted her teachers'' advice (a is false). Her teachers told her to give up, not looked after her artistic career (c is false). She set off to art college at 18, not 20 (d is false).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13b78b32-26f0-53fd-9fa1-ae461f258c53', '3dfa33ef-a915-5031-92e1-5bb239e854d0', 'Complete: "We''ve ___ ideas — we need some inspiration from outside the team."', '[{"id":"a","text":"put off"},{"id":"b","text":"turned off"},{"id":"c","text":"run out of"},{"id":"d","text":"given up with"}]'::jsonb, 'c', '"Run out of" means to have no more of something: we''ve run out of ideas. The context (needing inspiration) confirms they have exhausted their ideas. "Put off" means to postpone, "turned off" means switched off, and "given up with" is not a standard phrasal verb collocation.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6ff657d4-5067-5cd8-a1ea-404fd0353cd9', '3f0bbd99-331c-57c0-bf91-79e182a825a3', 'anglais-b1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('bf9113d8-290d-568c-8b90-67ab7886e306', '6ff657d4-5067-5cd8-a1ea-404fd0353cd9', 'What should you do BEFORE reading a B1 comprehension text?', '[{"id":"a","text":"Read the text slowly from start to finish."},{"id":"b","text":"Read all the questions first to know what to look for."},{"id":"c","text":"Look up every unknown word in a dictionary."},{"id":"d","text":"Translate the whole text into your first language."}]'::jsonb, 'b', 'The first strategy is to read the questions before the text so you know exactly what information to hunt for. Reading slowly from start to finish wastes time, and looking up every word or translating the whole text are inefficient strategies at B1 level.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5112ae05-527f-5455-b5bc-3b634ad40458', '6ff657d4-5067-5cd8-a1ea-404fd0353cd9', 'What is an INFERENCE in reading comprehension?', '[{"id":"a","text":"A piece of information stated directly in the text."},{"id":"b","text":"A translation of a difficult word."},{"id":"c","text":"A logical conclusion drawn from clues in the text, not stated directly."},{"id":"d","text":"The title of the article."}]'::jsonb, 'c', 'An inference is a conclusion you draw from textual clues — it is implied but not directly written. Direct information is a specific detail, not an inference. Translating a word and identifying the title are separate reading skills.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8eebca91-b927-5602-8c1b-cc0b600a2582', '6ff657d4-5067-5cd8-a1ea-404fd0353cd9', 'You see the word "reluctant" in a text: "Despite the rain, she reluctantly went outside."
What does "reluctant" most likely mean?', '[{"id":"a","text":"Enthusiastically"},{"id":"b","text":"Unwillingly / not wanting to"},{"id":"c","text":"Quickly"},{"id":"d","text":"Happily"}]'::jsonb, 'b', 'The word "despite" signals a contrast: even though she did not want to go out (because of the rain), she went. "Reluctantly" therefore means unwillingly — not enthusiastically, quickly, or happily. Contrast words like despite are key context clues for vocabulary guessing.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31a2be63-9e80-5f7e-9edd-2f30f43d4eb6', '6ff657d4-5067-5cd8-a1ea-404fd0353cd9', 'In a True/False/Not Given question, the text says: "The café opens at 9 a.m. on weekdays."
Statement: "The café is open on Saturdays."
Which is correct?', '[{"id":"a","text":"True"},{"id":"b","text":"False"},{"id":"c","text":"Not Given"},{"id":"d","text":"Cannot be decided"}]'::jsonb, 'c', 'The text only mentions weekday hours — it says nothing about Saturdays. The answer is Not Given, not False. False would require the text to say it is closed on Saturdays. Not Given means the text is silent on the topic, so we cannot conclude either way.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('45f2153d-35af-5c79-aaf7-c40b52822505', '6ff657d4-5067-5cd8-a1ea-404fd0353cd9', 'Which answer is most likely a DISTRACTOR for a "main idea" question about an article titled "How City Cycling Changed My Life"?', '[{"id":"a","text":"The writer''s experiences of cycling in the city transformed her daily routine and wellbeing."},{"id":"b","text":"The writer bought a red bicycle in March."},{"id":"c","text":"The article explores how one person''s life improved through urban cycling."},{"id":"d","text":"The writer describes a personal journey of change through cycling."}]'::jsonb, 'b', 'A distractor for a main-idea question picks a true but too-narrow detail from the text. Buying a red bicycle in March may be mentioned in the article, but it is a specific detail, not the central idea. Options (a), (c) and (d) all capture the broad personal-change-through-cycling theme of the article.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c1daf195-1ce7-580e-9312-32faac9b9cb9', '3f0bbd99-331c-57c0-bf91-79e182a825a3', 'anglais-b1', '⭐ Practice: Main Idea and Specific Details', 1, 50, 10, 'practice', 'admin', 1)
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
  ('55040d52-b6be-5cb9-907b-d8386ffd2603', 'c1daf195-1ce7-580e-9312-32faac9b9cb9', 'Read the notice:
"LIBRARY NOTICE
The library will be CLOSED on Monday 15th for staff training. It will reopen on Tuesday 16th at 9 a.m. as usual. We apologize for any inconvenience."

Why is the library closing?', '[{"id":"a","text":"For building repairs"},{"id":"b","text":"For a public holiday"},{"id":"c","text":"For staff training"},{"id":"d","text":"Because of bad weather"}]'::jsonb, 'c', 'The notice clearly states the library will be closed "for staff training". Repairs, a public holiday, and bad weather are not mentioned anywhere in the text.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a912403f-7588-5184-82a2-464482286d08', 'c1daf195-1ce7-580e-9312-32faac9b9cb9', 'Read the email:
"Hi Marco,
I hope you''re well. Just a quick note — the team meeting has been moved from Thursday to Friday at 3 p.m. Please let the others know.
Best, Sarah"

What is the main purpose of this email?', '[{"id":"a","text":"To cancel a meeting"},{"id":"b","text":"To inform Marco about a change of meeting day"},{"id":"c","text":"To ask Marco to organise a meeting"},{"id":"d","text":"To invite Marco to a new project"}]'::jsonb, 'b', 'Sarah''s email informs Marco that the meeting has moved from Thursday to Friday — a change of day, not a cancellation. She doesn''t ask Marco to organise anything and there is no mention of a new project.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab010f00-6273-54bc-a9d3-fe2746fb3c96', 'c1daf195-1ce7-580e-9312-32faac9b9cb9', 'Read the article extract:
"Urban gardens are growing in popularity across Europe. In the last ten years, city councils have created over 500 community growing spaces in major cities. These gardens provide fresh vegetables, improve air quality, and bring neighbours together."

What is the article MAINLY about?', '[{"id":"a","text":"The rise of urban gardens in European cities"},{"id":"b","text":"The health benefits of eating vegetables"},{"id":"c","text":"How to start a community garden"},{"id":"d","text":"Air pollution problems in European cities"}]'::jsonb, 'a', 'The main topic is the growing popularity of urban gardens across European cities. Vegetables and air quality are mentioned as benefits but are details, not the main idea. The text does not explain how to start a garden, and pollution is not the focus.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b6790c9-b5c2-5e9d-a6bc-7141ed52cd01', 'c1daf195-1ce7-580e-9312-32faac9b9cb9', 'Read the article extract:
"Urban gardens are growing in popularity across Europe. In the last ten years, city councils have created over 500 community growing spaces in major cities. These gardens provide fresh vegetables, improve air quality, and bring neighbours together."

How many community growing spaces have been created in the last ten years?', '[{"id":"a","text":"50"},{"id":"b","text":"500"},{"id":"c","text":"5,000"},{"id":"d","text":"The text does not say."}]'::jsonb, 'b', 'The text states that city councils have created "over 500 community growing spaces" in the last ten years. 50 and 5,000 are common confusion errors with numbers. The number is clearly given, so option (d) is incorrect.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e837019f-74ac-5462-93d4-48b4ffc30e29', 'c1daf195-1ce7-580e-9312-32faac9b9cb9', 'Read the story extract:
"Ali arrived at the station just as the train doors were closing. He ran as fast as he could, but the train pulled away before he could reach it. He stood on the empty platform, breathing hard."

How does Ali probably FEEL at the end?', '[{"id":"a","text":"Relieved"},{"id":"b","text":"Excited"},{"id":"c","text":"Angry at the station staff"},{"id":"d","text":"Disappointed and tired"}]'::jsonb, 'd', 'Ali missed the train despite running hard — he is likely disappointed (he failed to catch the train) and tired (he ran as fast as he could and is now breathing hard). There is no reason to feel relieved or excited. The text does not mention anger at staff.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e8af98c2-c5ba-5491-9c30-9fc8814483db', 'c1daf195-1ce7-580e-9312-32faac9b9cb9', 'Read the advert:
"SALSA DANCE CLASSES — Beginners Welcome!
Every Tuesday, 7–9 p.m., Community Centre Room 4.
No partner needed. All ages. First class FREE.
Call 0123 456789 to book your place."

Which statement is TRUE?', '[{"id":"a","text":"You must bring a dance partner to join."},{"id":"b","text":"Classes are held on Wednesday evenings."},{"id":"c","text":"The first class costs nothing."},{"id":"d","text":"Only young people can attend."}]'::jsonb, 'c', 'The advert says "First class FREE", so the first lesson costs nothing (c). It also says "No partner needed" (so a is false), classes are on Tuesday (not Wednesday, so b is false), and "All ages" means everyone can attend (d is false).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('02bbcf36-9d72-58cd-8342-f43be55f614b', '3f0bbd99-331c-57c0-bf91-79e182a825a3', 'anglais-b1', '⭐⭐ Review: Inference and Vocabulary in Context', 2, 75, 15, 'practice', 'admin', 2)
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
  ('babd46bf-0286-5af5-a5d0-6af03f0d664f', '02bbcf36-9d72-58cd-8342-f43be55f614b', 'Read the extract:
"Maria opened her laptop and stared at the blank document. She had promised her editor the article by noon. It was now 11:45 a.m."

What can we INFER about Maria?', '[{"id":"a","text":"Maria has already sent the article."},{"id":"b","text":"Maria is running out of time and has not finished the article."},{"id":"c","text":"Maria''s editor has cancelled the deadline."},{"id":"d","text":"Maria does not like writing articles."}]'::jsonb, 'b', 'The blank document at 11:45 a.m. with a noon deadline shows Maria has not finished the article and has very little time left (b). She clearly hasn''t sent it (a is false), there is no mention of the editor cancelling (c), and disliking writing is not implied — she is under pressure, not showing dislike (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4dac40a-951f-50b6-8138-c8c3ce63116e', '02bbcf36-9d72-58cd-8342-f43be55f614b', 'Read the sentence:
"Although the film received mixed reviews, it was a box-office triumph."
What does TRIUMPH most likely mean here?', '[{"id":"a","text":"Failure"},{"id":"b","text":"Surprise"},{"id":"c","text":"Great success"},{"id":"d","text":"Disappointment"}]'::jsonb, 'c', 'The word "although" signals a contrast: despite mixed reviews (negative), it was a box-office triumph (positive). The contrast tells us triumph is something positive — a great success. Failure and disappointment are the opposite, and surprise does not capture the meaning of commercial success.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5e725af-8d1f-50af-b188-41429c579da0', '02bbcf36-9d72-58cd-8342-f43be55f614b', 'Read the email:
"Dear Customer,
Thank you for your order. Unfortunately, the item you requested is currently out of stock. We expect it to be available again in approximately two weeks. You may cancel your order or choose to wait. Please reply to confirm your preference.
Regards, The Shop Team"

What does the shop want the customer to do?', '[{"id":"a","text":"Visit the shop in person"},{"id":"b","text":"Call a customer service number"},{"id":"c","text":"Send a reply confirming whether to cancel or wait"},{"id":"d","text":"Choose a different item immediately"}]'::jsonb, 'c', 'The last sentence asks the customer to "reply to confirm your preference" — meaning cancel or wait. There is no mention of visiting the shop, calling a number, or choosing a different item.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dab2b9c8-6df6-5d1d-a276-781843804335', '02bbcf36-9d72-58cd-8342-f43be55f614b', 'Read the sentence:
"The scientist was meticulous in her work, checking every measurement three times before recording it."
What does METICULOUS most likely mean?', '[{"id":"a","text":"Fast"},{"id":"b","text":"Careless"},{"id":"c","text":"Bored"},{"id":"d","text":"Very careful and precise"}]'::jsonb, 'd', 'The context — checking every measurement three times — describes extreme care and precision. "Meticulous" therefore means very careful and precise. The behaviour described is the opposite of fast, careless, or bored.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('38260523-805e-53ca-8baf-a8603e5e1032', '02bbcf36-9d72-58cd-8342-f43be55f614b', 'Read the article extract:
"The town of Greenvale has seen its population double in the last decade, largely thanks to a new technology company that moved its headquarters there in 2015."

Statement: "The technology company was founded in Greenvale."
Is this True, False, or Not Given?', '[{"id":"a","text":"True"},{"id":"b","text":"Not Given"},{"id":"c","text":"False"},{"id":"d","text":"Cannot be determined from any source"}]'::jsonb, 'b', 'The text says the company "moved its headquarters there" — it came from somewhere else. But where it was originally founded is not mentioned. The answer is Not Given, not False: the text doesn''t say it was NOT founded in Greenvale, it simply doesn''t say where it was founded.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2ab265b-1884-5323-9fe3-15e8d4c14a1d', '02bbcf36-9d72-58cd-8342-f43be55f614b', 'Read the story extract:
"Youssef smiled as he stepped off the stage. His hands were still shaking, but the audience had clapped for what felt like forever."

What is the most likely INFERENCE?', '[{"id":"a","text":"Youssef was nervous before but feels relieved and pleased after a successful performance."},{"id":"b","text":"Youssef hurt his hands on the stage."},{"id":"c","text":"The audience was bored and left early."},{"id":"d","text":"Youssef forgot his lines and felt embarrassed."}]'::jsonb, 'a', 'Youssef''s shaking hands suggest pre-performance nerves, but his smile and the long applause indicate success and relief (a). Shaking hands from an injury is not implied, the audience clearly applauded at length (not bored or leaving early), and forgetting lines would not produce a smile and prolonged applause.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('197c7611-5824-5ad4-86a5-d347ee439560', '3f0bbd99-331c-57c0-bf91-79e182a825a3', 'anglais-b1', '⚔️ Chapter Boss ⭐⭐⭐: Reading Comprehension: Texts and Inference', 3, 120, 30, 'boss', 'admin', 3)
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
  ('eb5797b5-320d-5dfc-8fc3-a6c8250dffdc', '197c7611-5824-5ad4-86a5-d347ee439560', 'Read the article:
"Every year, thousands of young people in Europe take a gap year before university. They travel, volunteer, or work abroad. Research shows that students who take a gap year often perform better academically than those who go straight to university, possibly because they are more motivated and mature."

What is the MAIN IDEA of the article?', '[{"id":"a","text":"Gap years are more popular in Europe than in other parts of the world."},{"id":"b","text":"Taking a gap year can have academic benefits for students."},{"id":"c","text":"Young people enjoy travelling before starting university."},{"id":"d","text":"Research on gap years is unreliable."}]'::jsonb, 'b', 'The article''s central point is that gap years can benefit students academically — they often perform better (b). Comparing Europe to other regions is not mentioned (a), enjoying travel is a detail not the main claim (c), and the text treats the research as valid, not unreliable (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('659ddeb8-6fb3-5a5f-bf04-34e098714399', '197c7611-5824-5ad4-86a5-d347ee439560', 'Read the story:
"Lina pushed open the door of her old school. The corridors smelled of paint and chalk, exactly as she remembered. A small girl ran past her, laughing. Lina smiled — it felt like stepping back twenty years."

What can we INFER about Lina?', '[{"id":"a","text":"Lina feels nostalgic because she used to study at this school."},{"id":"b","text":"Lina is visiting the school for the first time."},{"id":"c","text":"Lina works as a teacher at the school."},{"id":"d","text":"Lina dislikes children."}]'::jsonb, 'a', 'The smells that were "exactly as she remembered" and the phrase "stepping back twenty years" strongly suggest Lina studied there long ago and feels nostalgic (a). She is clearly not visiting for the first time (b). There is no evidence she is a teacher (c), and her smile when the girl runs past contradicts disliking children (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d700b47-9e07-59d2-836e-e3c6c63b9d12', '197c7611-5824-5ad4-86a5-d347ee439560', 'Read the notice:
"The swimming pool will be closed for maintenance from Monday 3rd to Friday 7th. Members wishing to swim during this period are welcome to use the Eastside Sports Centre pool free of charge. Please bring your membership card."

Statement: "Members must pay to use the Eastside Sports Centre pool during the closure."
True, False, or Not Given?', '[{"id":"a","text":"True"},{"id":"b","text":"Not Given"},{"id":"c","text":"False"},{"id":"d","text":"True, but only for new members"}]'::jsonb, 'c', 'The notice states members can use the Eastside pool "free of charge" during the closure — so the statement that they must pay is False. Not Given would mean the text is silent on the topic, but it explicitly says "free of charge". Option (d) introduces a distinction (new vs existing members) that is not in the text.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3af6193f-dddb-57c9-8776-d5949c8bef0a', '197c7611-5824-5ad4-86a5-d347ee439560', 'Read the sentence:
"The new policy was met with fierce opposition from the majority of the committee members, who felt it was both premature and poorly thought out."
What does PREMATURE most likely mean in this context?', '[{"id":"a","text":"Too expensive"},{"id":"b","text":"Too detailed"},{"id":"c","text":"Too early / introduced before the right time"},{"id":"d","text":"Too popular"}]'::jsonb, 'c', 'The committee members criticised the policy on two grounds: it was premature AND poorly thought out. "Poorly thought out" means not planned well. "Premature" adds a separate idea, suggesting it was introduced before the right time — too soon. Nothing in the sentence points to cost (a), detail (b), or popularity (d).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a45bf2e-9ebd-59f8-ad6a-ecf26f14b7bf', '197c7611-5824-5ad4-86a5-d347ee439560', 'Read the article extract:
"Despite living in the city for fifteen years, Omar still found the noise overwhelming on some days. He would often put on headphones and close his eyes on the metro, imagining the quiet fields of his village."

What does this paragraph SUGGEST about Omar?', '[{"id":"a","text":"Omar plans to move back to his village very soon."},{"id":"b","text":"Omar is afraid of travelling on the metro."},{"id":"c","text":"Omar has fully adapted to city life and enjoys the noise."},{"id":"d","text":"Omar sometimes misses the quietness of where he grew up."}]'::jsonb, 'd', 'Omar imagines "the quiet fields of his village" to escape the overwhelming city noise — this suggests he misses the peace of his rural origins (d). There is no mention of plans to move back (a), and the text explicitly says he finds the noise overwhelming, so he has NOT fully adapted (c). He uses headphones as a coping strategy, not from fear of the metro (b).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25ed06b2-1352-5ca6-b157-779a0a6e31a2', '197c7611-5824-5ad4-86a5-d347ee439560', 'Read the email:
"Dear Ms Hariri,
I am writing to express my dissatisfaction with the laptop I purchased from your store last week. The screen flickers constantly and the keyboard sticks. I have tried all the suggested troubleshooting steps, but the problems persist. I would like either a full refund or a replacement."

What is the WRITER''S purpose?', '[{"id":"a","text":"To recommend the store to other customers"},{"id":"b","text":"To report a technical fault and request a solution"},{"id":"c","text":"To ask for troubleshooting advice for the laptop"},{"id":"d","text":"To apologise for returning a product"}]'::jsonb, 'b', 'The writer describes two faults (flickering screen, sticky keyboard), explains they''ve already tried troubleshooting, and requests a refund or replacement (b). The tone is the opposite of a recommendation (a). The writer has already tried the troubleshooting steps — they are not asking for more advice (c). There is no apology in the email (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('908ff8d4-8874-59f6-b55f-3af35813c89d', '3f0bbd99-331c-57c0-bf91-79e182a825a3', 'anglais-b1', '👑 Elite Challenge ⭐⭐⭐⭐: Reading Comprehension: Texts and Inference', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('b503bdaf-bc6e-5c12-8ae6-28e1f20d36af', '908ff8d4-8874-59f6-b55f-3af35813c89d', 'Read the article:
"In 2019, the small coastal town of Portmere attracted just 3,000 tourists a year. Then a travel blogger posted a photo of its turquoise bay, and within weeks the post had been shared half a million times. By 2022, Portmere was welcoming over 80,000 visitors annually. Local residents have mixed feelings: tourism has created jobs, but traffic and litter have become serious problems."

What is the MAIN IDEA of the article?', '[{"id":"a","text":"Social media can rapidly transform a quiet place into a popular tourist destination, with both benefits and problems."},{"id":"b","text":"Travel bloggers earn a lot of money by posting photos online."},{"id":"c","text":"Portmere has the most beautiful bay in Europe."},{"id":"d","text":"Local residents of Portmere want tourists to stop visiting."}]'::jsonb, 'a', 'The article shows how a social media post rapidly made Portmere popular, then discusses both positive effects (jobs) and negative ones (traffic, litter) — the main idea is that social media can transform a place, with mixed results (a). The blogger''s income is not mentioned (b). The bay is described as turquoise but not compared to all of Europe (c). Residents have "mixed feelings" — not uniformly against tourists (d).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('72a5a8ea-0126-5eeb-bf63-5f4629291555', '908ff8d4-8874-59f6-b55f-3af35813c89d', 'Read the email:
"Hi Jade,
Just to let you know — the project deadline has been moved forward by two days. It''s now due on the 14th instead of the 16th. I know this is short notice, so let me know if you need any help.
Thanks, Leo"

What does "moved forward" mean in this context?', '[{"id":"a","text":"The deadline has been extended by two days."},{"id":"b","text":"The deadline has been cancelled."},{"id":"c","text":"The deadline has been postponed until next week."},{"id":"d","text":"The deadline is now earlier than before."}]'::jsonb, 'd', 'The email shows the deadline changed from the 16th to the 14th — it is now two days earlier. "Moved forward" in deadline contexts means earlier, not later. Leo acknowledges "this is short notice", confirming the urgency. Extended (a), cancelled (b), and postponed (c) all suggest a later or no deadline — the opposite of what happened.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('810fb975-00d4-523b-9be9-30cb7e9b1d39', '908ff8d4-8874-59f6-b55f-3af35813c89d', 'Read the same article about Portmere.

Statement: "The travel blogger visited Portmere in 2019."
True, False, or Not Given?', '[{"id":"a","text":"True"},{"id":"b","text":"False"},{"id":"c","text":"Not Given"},{"id":"d","text":"True — the text implies the blogger was there in 2019."}]'::jsonb, 'c', 'The text says the blogger posted a photo of the bay, but it does not say when or whether the blogger visited in person. The year 2019 refers to tourist numbers before the post, not to when the blogger visited. This is Not Given — the text provides no information about whether the blogger visited at all.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('696dc7f7-83b9-5a49-a568-f97645ce1d3c', '908ff8d4-8874-59f6-b55f-3af35813c89d', 'Read the story:
"The old woman set the tray of tea on the table without a word. She sat down opposite her daughter and stared at the window. Neither of them spoke for a long time. Finally, the daughter reached across and took her mother''s hand."

What does this scene most likely SUGGEST?', '[{"id":"a","text":"The daughter and her mother enjoy comfortable silence together."},{"id":"b","text":"The two women are strangers who have just met."},{"id":"c","text":"They are both watching something interesting through the window."},{"id":"d","text":"There is tension or sadness between them, but also care."}]'::jsonb, 'd', 'The silence, the averted gaze (staring at the window), and the lack of words suggest discomfort or sadness. But the daughter reaching to take her mother''s hand shows affection and care. Together these clues suggest emotional tension combined with love (d). A comfortable silence would be warmer in tone (a). They are clearly family — mother and daughter — not strangers (b). The window staring is about avoiding eye contact, not watching something (c).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b6b8206-28fe-58c1-b62c-31986c9f9ed9', '908ff8d4-8874-59f6-b55f-3af35813c89d', 'Read the article:
"Schools in several countries have recently banned smartphones in classrooms. Supporters argue that phones distract students and reduce academic performance. Critics, however, believe that smartphones are essential learning tools and that banning them is an outdated response to a modern challenge."

Which statement BEST describes the article?', '[{"id":"a","text":"The article argues strongly that smartphones should be banned from schools."},{"id":"b","text":"The article presents both sides of the debate about smartphones in schools."},{"id":"c","text":"The article concludes that banning smartphones is the correct solution."},{"id":"d","text":"The article reports that smartphones have been banned in all countries."}]'::jsonb, 'b', 'The article gives both the supporters'' view (phones distract students) and the critics'' view (phones are useful learning tools) — it presents both sides without taking a position (b). The article does not argue for a ban (a) or against one (c). It says bans have happened in "several countries", not all (d).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('794e4218-1a71-53b9-aedd-6dd8892217c4', '908ff8d4-8874-59f6-b55f-3af35813c89d', 'Read the notice:
"IMPORTANT NOTICE — LIFT OUT OF SERVICE
The lift in Block C will be out of service from 8 a.m. on Monday until approximately 6 p.m. on Wednesday for essential maintenance. Residents requiring assistance with heavy items during this period should contact the building manager on extension 205."

Statement: "Residents cannot use the stairs in Block C during the maintenance period."
True, False, or Not Given?', '[{"id":"a","text":"True"},{"id":"b","text":"False"},{"id":"c","text":"Not Given"},{"id":"d","text":"True — the maintenance blocks all access to Block C."}]'::jsonb, 'c', 'The notice only mentions the lift being out of service — it says nothing at all about the stairs. Whether or not residents can use the stairs is Not Given. False would require the text to say they CAN use the stairs, and True would require it to say they CANNOT. The stairs are simply not mentioned.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

