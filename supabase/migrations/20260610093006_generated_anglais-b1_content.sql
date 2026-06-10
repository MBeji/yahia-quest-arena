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
      AND q.id NOT IN ('d21f78fc-18fc-5d23-844f-76c0ba5c1a9c', '770935af-8772-597c-bd88-e45d10860635', '9ebefaa9-16f9-52c8-ad20-4aa6273fc1a3', '0b8adf2a-9e97-533c-80a6-f072e4cf724e', 'dd98b25a-37f5-56f1-b00a-105cf533d89d', '25605f4a-30a8-5d60-8140-139d856a0ab0', '863cec36-9b4c-5aab-bd2b-68c363f61ab2', '0ae5d7f5-7a89-5a88-aa95-a1eb129e68ec', 'a03456e2-2ea2-5135-96fd-b469e38a469a', '8c24e4ee-7b6e-513c-9792-e72f2725dc1b', '82f6e766-275a-5cff-84ef-66311337c01f', 'f0f12d8e-b670-5e66-adef-8fce2afbea13', '995363e9-e638-539d-92c1-9e6ad2df4b6c', 'ca80caa8-05d8-5a7f-a597-cfdbc7390163', 'd81612b2-e9af-505b-ad9f-bc5b2c1b0fc5', 'fcc14fbb-aa3f-5625-aa28-b40f59a6d7d0', '9226c7a4-0868-522a-af08-cdd067667f30', '8ac1b05f-cca4-5f89-9042-ea8e83f6a392', '4dd59d5b-b41d-50b5-bc3d-47fb0c37fae4', '03fb821a-9fa6-5204-8d29-126e799d7131', '01dd93ec-1132-5511-af21-00e89f0e41d6', '90240e9c-89b2-5276-ba66-880d30507cdb', 'd2ff8dc0-517c-5b7e-9dbb-27560bbf23e9', '7849c87b-b79d-5eef-91e0-e7188d911e25', 'd4cf135a-984d-59c1-a5fd-9f5d70dcda94', 'b92c39c7-56f8-5d20-af87-80cf1960efad', '58065b06-65bd-5dd4-97f1-dc08a467ecc8', '8eb330d6-6755-5131-b1eb-e1ca0bbede5a', '8e1e9934-1a94-556f-a97d-b8737ee355ff', 'eaab1805-0de3-5ff8-8dc8-6c274886bbc9', '9b0ef4ac-f2ff-5e25-8858-1bacd6f4c765', 'c15ff13c-57b0-5196-b5ba-7717cad31c6e', '5695972e-54fd-5c9e-9323-a364bbb0610a', 'a2b64c56-95ea-5d59-ab24-ecf6dc84f68f', '96c312b6-87f3-5f3a-8690-1eec39734321', '2ce5d7df-c927-561a-8461-c76dcc8da384', '6edf674a-90ee-5f4e-a847-79f26805ac2a', '293e5e74-e17f-52e2-af55-7bb2425e4995', '9c612545-2b57-5a30-94e0-6bd9f509e5af', 'a9dabafb-ff48-5116-9ee9-b9248c76ba92', '90505f8e-53bf-5ecf-b905-de047fbcb141', 'b0d27e80-38cc-568c-a19a-0d65a6ee12a3', '06a227a6-ff83-53d1-8275-36a45701b85d', '1abf2718-4740-56b5-a8ce-b2799b9a01a0', 'df4e924a-4f94-51ca-9edb-652719a57112', '28f66ad0-2948-5968-b0c0-3891fb9c7f89', 'a1960c69-62dd-52db-8261-3410a4d084d1', '44ba31eb-4e53-5280-8886-8db0fd299512', 'bdba3627-8e92-5215-9440-8647181cd83d', '8f689f63-a49a-5079-86eb-039efad047b6', 'b55becca-f73c-582d-bc19-79764c189cab', '8c69b63c-6a84-510b-a7cc-d213ff949911', 'c3f4817e-5e42-5819-8045-d23d5afa8a56', 'c0cf3d8e-29b2-554e-8396-233da299a03a', 'e630f48b-9ddd-5783-8091-fd7cac3c8aa0', '92899ae3-6f82-5197-afce-5c3cdf5b6c1c', '27f29a01-c96e-589f-9bd0-0c5ccc93d7d2', '77762ad6-0d34-5dc4-ad34-48d91277fedf', 'ece859ee-4559-531f-8276-185680341543', '6cae7f54-e2ba-5852-9100-7974d4edc9f3', '36258cec-198e-5ef5-a153-2557cf16b7bf', '51f9c6e0-600a-55e0-ac29-6b74e2b4f21e', '8404350f-0f6a-5fae-ba92-40ee54461fb1', '08122a2b-ebee-50ea-a7fc-3efa9c703608', 'f4197b11-0616-50d9-890e-34ab74dc614d', '3c5256db-a943-554f-ba38-d1f6fc407c88', '6d097239-c36c-56ff-aac8-6ce12ee05ceb', '0449118d-6079-5393-beac-6e206957bf3f', 'fb999032-2564-5398-ba08-3fba28729101', '2b297cbf-d770-50f3-b5bb-db0e8c9c17fe', 'bc0edb61-6e7f-518f-bae1-19cd55652632', '84554d85-5317-5017-8097-1d8fea742d35', '2e5d08e4-1bc4-551f-9db5-462cf889046e', '10b1be7d-c21e-5949-89da-04c06deb9077', '1db1ee7c-f255-5f9e-bafa-cdd1169ab692', '2d3e5507-5402-5629-85d1-bae63a1a8f91', '6580bb6d-36bb-5aa2-afbe-2e6369d0bc8b', '8113315b-c396-5415-98b9-9d75a65e6cf0', 'b3eede3a-aa03-5f95-9314-babc6c386692', 'e5f44117-bd7f-531a-ae7e-090a8b8ec775', '4ee52991-eb43-5e60-9a35-5a90d303b21e', '8fcd058c-a7a4-537b-9414-63c2d55787ac', '71cdecc6-9c1d-52fc-822c-00b5b3eac009', '140c628a-1a79-5314-8b6c-b7307ff6982a', '12bdddc9-2f19-53d2-8098-c33b66290195', 'fb3afd92-d2fe-52b6-954e-c84c64e154e9', '78cc6040-c588-5ed0-9bb7-c4db9da0985d', 'b5e6e485-dc7d-58a1-a0f5-a5984b545774', 'ac3af235-6167-5675-aa56-dd2f351cbd8a', '1d9ea7bc-4f55-5522-a1b2-b4648ef39f4e', 'cbe9cac9-f725-5b69-bfc2-e3ad46280dea', '69f8c605-be12-5d27-b744-f1a83582caa9', '987ef75b-b924-5e4a-9fcc-6cbf92b086e7', '0238c85f-0e73-5fd5-862c-22fd6d555d25', '4fac49fc-f563-54f9-a918-e3cf31acc907', 'e2c3dfac-1b06-5597-811b-9f05e96f2c7c', '924d5ccb-5fc5-55fb-8dae-a97704551fe7', '8d1d3a86-daf8-56a1-855e-d0ba09e87c36', 'b963b579-1234-51a9-a179-9e577cd5765c', '481130c6-d407-56bc-88ec-78ef4cb1ad8d', '132d8118-20c5-56b0-b24d-0d6fdeddc501', '8973ba3b-12fe-5f8e-ab37-0559533cf048', '554943ea-c09a-528c-b40c-985badae2b84', '8c1cff10-fb30-59fd-bc34-01377caf444f', '058eb948-16eb-5140-9673-c046f1f85c59', '760a2799-19ca-5390-a2fb-4eaee959eacf', '1547cc51-5271-5684-b077-7c06e3f11f4e', '3257e99d-2660-5323-9aa5-049dcfea235a', 'f9a46e71-9cba-5b1c-9972-27593d20fd4a', '5ccf770d-2bbb-51d6-b3eb-44cbc4879729', '09e00934-ae5d-5a82-8a12-74bb212acc51', 'a761414c-4656-570d-9797-84088854db6f', '606502f9-7a42-5706-ba52-538e290fc574', '84534f92-387a-5aae-a085-663ea92bbfa9', 'e6e8d472-ffb3-560c-b254-70585341c6a2', '9c4b0c26-1807-5937-9209-f8600b893c23', '6289d8ca-7f89-5274-a661-454ea6f98528', '04aba842-0089-5bd8-9192-0aa0a00d217a', 'a7926885-cba9-57a2-94cb-28fb34528811', '86eabef9-eb17-50c0-9b2e-573c9e621c10', '7fe66ce5-b374-5291-913f-f2366d748628', '53e0e708-72b8-5ffd-beaf-b48f5d673434', 'e12a5532-a554-5ef4-aabb-51490a2c331f', '89b472c2-e11f-5db4-8788-277868af1765', 'ff83ad6a-d8ac-59f2-9d8c-41fe9cd2c7ca', 'bc3660ce-c60e-5d1b-8ee6-8390ac5cea87', '457504ee-db4c-597d-b3d5-173059263078', 'd22fe2dd-dde1-5d91-827a-e4863e5eb325', '16587e62-5f62-58b8-bdab-0ed45705ffdf', 'be179cfc-06fe-59d9-9c40-8701a8d86ad1', '73352b6d-23ce-53ad-a480-41d7d3ad82cc', '1c78cf3c-1ba9-5708-8973-a657855ea469', 'e6765073-0b37-5ac8-ade2-98be8d7b19c7', 'a1354dd9-ce9f-50bc-8523-24a1135f78c1', 'c554e7f4-ae80-557d-aaa8-53143b9d619f', 'be82507b-76aa-5f51-adda-8ca6085d6df4', '1da7af6c-1a95-55bb-9c40-b05ba6ff087b', '187c048c-c484-5e98-9e03-1cc40a34daf1', '777c5972-5e8a-56c4-b4cf-8b3a6cd86b54', 'a0b097d8-f0d8-5236-8ecc-72af95555c5c', '7855d649-82ea-5b02-81cf-326afc40dcc3', '4991d957-7742-5aec-a2f6-4f8ac1713078', '60c9ba60-c9a5-5944-a549-70732127877f', '29b8bf81-87a7-5257-8ed8-9dfc20f24f06', 'c3360361-8de7-5491-a29c-9e3c5fa80b8b');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'anglais-b1' AND source = 'admin' AND id NOT IN ('40fd289c-37a4-53db-93d9-38b367e29e5f', 'a1e6f69c-9aa0-5447-a0f9-1e2f81479615', '9ef6f6ea-2f89-5519-b6ba-a41b3329c3a8', '5afd1fa5-52f7-5c8f-9799-62d189c5f77c', '6b85c952-5fee-56f8-a474-b5113d3fb46d', '1993e981-3f08-5cb9-a035-9f51b6fe83e5', '5215da47-c957-5eb9-a8ba-0769355e8c1e', '4bea5507-af8e-51db-9d78-27c594203dba', '655870b0-3a82-57d6-8b66-df037e3f20f0', '14bd58a6-41b9-5534-a32c-371feae58b9a', 'a39d1f14-cad1-583a-87e8-3dbda3a634ff', '01527ceb-d29a-5b63-863d-32721d7ec78f', 'e8e88986-bcbe-5dd8-b0cf-7f993599de60', 'd95fd47f-b045-5ec7-a5a3-7c55dc46acc4', 'c2af895f-335f-573f-b73b-071af11d1a14', 'fe4eb78e-6011-5328-bd7d-207ae5b8f21c', 'bf69c0eb-1b3a-5b6f-9c70-0ccc5221db6f', '9d2a171f-0019-564f-b720-1e0a3c333cab', 'c4bb6149-7cb3-5743-809c-e8db215da654', '1b58c970-ed85-552d-ad5a-e826dd0a4605', '6c7fec37-efed-5bb6-b3ae-d2c0588b73da', 'b118995d-87bc-539b-969d-5e971f98ff7a', 'f6cfa647-7511-5bc3-ac55-3a414bbfa939', '2f8279d5-6792-59a1-a5a3-315f3f921cd1', '6e3123e2-e3b7-58f3-97ef-bd81c64a486b');
DELETE FROM public.questions WHERE exercise_id IN ('40fd289c-37a4-53db-93d9-38b367e29e5f', 'a1e6f69c-9aa0-5447-a0f9-1e2f81479615', '9ef6f6ea-2f89-5519-b6ba-a41b3329c3a8', '5afd1fa5-52f7-5c8f-9799-62d189c5f77c', '6b85c952-5fee-56f8-a474-b5113d3fb46d', '1993e981-3f08-5cb9-a035-9f51b6fe83e5', '5215da47-c957-5eb9-a8ba-0769355e8c1e', '4bea5507-af8e-51db-9d78-27c594203dba', '655870b0-3a82-57d6-8b66-df037e3f20f0', '14bd58a6-41b9-5534-a32c-371feae58b9a', 'a39d1f14-cad1-583a-87e8-3dbda3a634ff', '01527ceb-d29a-5b63-863d-32721d7ec78f', 'e8e88986-bcbe-5dd8-b0cf-7f993599de60', 'd95fd47f-b045-5ec7-a5a3-7c55dc46acc4', 'c2af895f-335f-573f-b73b-071af11d1a14', 'fe4eb78e-6011-5328-bd7d-207ae5b8f21c', 'bf69c0eb-1b3a-5b6f-9c70-0ccc5221db6f', '9d2a171f-0019-564f-b720-1e0a3c333cab', 'c4bb6149-7cb3-5743-809c-e8db215da654', '1b58c970-ed85-552d-ad5a-e826dd0a4605', '6c7fec37-efed-5bb6-b3ae-d2c0588b73da', 'b118995d-87bc-539b-969d-5e971f98ff7a', 'f6cfa647-7511-5bc3-ac55-3a414bbfa939', '2f8279d5-6792-59a1-a5a3-315f3f921cd1', '6e3123e2-e3b7-58f3-97ef-bd81c64a486b') AND id NOT IN ('d21f78fc-18fc-5d23-844f-76c0ba5c1a9c', '770935af-8772-597c-bd88-e45d10860635', '9ebefaa9-16f9-52c8-ad20-4aa6273fc1a3', '0b8adf2a-9e97-533c-80a6-f072e4cf724e', 'dd98b25a-37f5-56f1-b00a-105cf533d89d', '25605f4a-30a8-5d60-8140-139d856a0ab0', '863cec36-9b4c-5aab-bd2b-68c363f61ab2', '0ae5d7f5-7a89-5a88-aa95-a1eb129e68ec', 'a03456e2-2ea2-5135-96fd-b469e38a469a', '8c24e4ee-7b6e-513c-9792-e72f2725dc1b', '82f6e766-275a-5cff-84ef-66311337c01f', 'f0f12d8e-b670-5e66-adef-8fce2afbea13', '995363e9-e638-539d-92c1-9e6ad2df4b6c', 'ca80caa8-05d8-5a7f-a597-cfdbc7390163', 'd81612b2-e9af-505b-ad9f-bc5b2c1b0fc5', 'fcc14fbb-aa3f-5625-aa28-b40f59a6d7d0', '9226c7a4-0868-522a-af08-cdd067667f30', '8ac1b05f-cca4-5f89-9042-ea8e83f6a392', '4dd59d5b-b41d-50b5-bc3d-47fb0c37fae4', '03fb821a-9fa6-5204-8d29-126e799d7131', '01dd93ec-1132-5511-af21-00e89f0e41d6', '90240e9c-89b2-5276-ba66-880d30507cdb', 'd2ff8dc0-517c-5b7e-9dbb-27560bbf23e9', '7849c87b-b79d-5eef-91e0-e7188d911e25', 'd4cf135a-984d-59c1-a5fd-9f5d70dcda94', 'b92c39c7-56f8-5d20-af87-80cf1960efad', '58065b06-65bd-5dd4-97f1-dc08a467ecc8', '8eb330d6-6755-5131-b1eb-e1ca0bbede5a', '8e1e9934-1a94-556f-a97d-b8737ee355ff', 'eaab1805-0de3-5ff8-8dc8-6c274886bbc9', '9b0ef4ac-f2ff-5e25-8858-1bacd6f4c765', 'c15ff13c-57b0-5196-b5ba-7717cad31c6e', '5695972e-54fd-5c9e-9323-a364bbb0610a', 'a2b64c56-95ea-5d59-ab24-ecf6dc84f68f', '96c312b6-87f3-5f3a-8690-1eec39734321', '2ce5d7df-c927-561a-8461-c76dcc8da384', '6edf674a-90ee-5f4e-a847-79f26805ac2a', '293e5e74-e17f-52e2-af55-7bb2425e4995', '9c612545-2b57-5a30-94e0-6bd9f509e5af', 'a9dabafb-ff48-5116-9ee9-b9248c76ba92', '90505f8e-53bf-5ecf-b905-de047fbcb141', 'b0d27e80-38cc-568c-a19a-0d65a6ee12a3', '06a227a6-ff83-53d1-8275-36a45701b85d', '1abf2718-4740-56b5-a8ce-b2799b9a01a0', 'df4e924a-4f94-51ca-9edb-652719a57112', '28f66ad0-2948-5968-b0c0-3891fb9c7f89', 'a1960c69-62dd-52db-8261-3410a4d084d1', '44ba31eb-4e53-5280-8886-8db0fd299512', 'bdba3627-8e92-5215-9440-8647181cd83d', '8f689f63-a49a-5079-86eb-039efad047b6', 'b55becca-f73c-582d-bc19-79764c189cab', '8c69b63c-6a84-510b-a7cc-d213ff949911', 'c3f4817e-5e42-5819-8045-d23d5afa8a56', 'c0cf3d8e-29b2-554e-8396-233da299a03a', 'e630f48b-9ddd-5783-8091-fd7cac3c8aa0', '92899ae3-6f82-5197-afce-5c3cdf5b6c1c', '27f29a01-c96e-589f-9bd0-0c5ccc93d7d2', '77762ad6-0d34-5dc4-ad34-48d91277fedf', 'ece859ee-4559-531f-8276-185680341543', '6cae7f54-e2ba-5852-9100-7974d4edc9f3', '36258cec-198e-5ef5-a153-2557cf16b7bf', '51f9c6e0-600a-55e0-ac29-6b74e2b4f21e', '8404350f-0f6a-5fae-ba92-40ee54461fb1', '08122a2b-ebee-50ea-a7fc-3efa9c703608', 'f4197b11-0616-50d9-890e-34ab74dc614d', '3c5256db-a943-554f-ba38-d1f6fc407c88', '6d097239-c36c-56ff-aac8-6ce12ee05ceb', '0449118d-6079-5393-beac-6e206957bf3f', 'fb999032-2564-5398-ba08-3fba28729101', '2b297cbf-d770-50f3-b5bb-db0e8c9c17fe', 'bc0edb61-6e7f-518f-bae1-19cd55652632', '84554d85-5317-5017-8097-1d8fea742d35', '2e5d08e4-1bc4-551f-9db5-462cf889046e', '10b1be7d-c21e-5949-89da-04c06deb9077', '1db1ee7c-f255-5f9e-bafa-cdd1169ab692', '2d3e5507-5402-5629-85d1-bae63a1a8f91', '6580bb6d-36bb-5aa2-afbe-2e6369d0bc8b', '8113315b-c396-5415-98b9-9d75a65e6cf0', 'b3eede3a-aa03-5f95-9314-babc6c386692', 'e5f44117-bd7f-531a-ae7e-090a8b8ec775', '4ee52991-eb43-5e60-9a35-5a90d303b21e', '8fcd058c-a7a4-537b-9414-63c2d55787ac', '71cdecc6-9c1d-52fc-822c-00b5b3eac009', '140c628a-1a79-5314-8b6c-b7307ff6982a', '12bdddc9-2f19-53d2-8098-c33b66290195', 'fb3afd92-d2fe-52b6-954e-c84c64e154e9', '78cc6040-c588-5ed0-9bb7-c4db9da0985d', 'b5e6e485-dc7d-58a1-a0f5-a5984b545774', 'ac3af235-6167-5675-aa56-dd2f351cbd8a', '1d9ea7bc-4f55-5522-a1b2-b4648ef39f4e', 'cbe9cac9-f725-5b69-bfc2-e3ad46280dea', '69f8c605-be12-5d27-b744-f1a83582caa9', '987ef75b-b924-5e4a-9fcc-6cbf92b086e7', '0238c85f-0e73-5fd5-862c-22fd6d555d25', '4fac49fc-f563-54f9-a918-e3cf31acc907', 'e2c3dfac-1b06-5597-811b-9f05e96f2c7c', '924d5ccb-5fc5-55fb-8dae-a97704551fe7', '8d1d3a86-daf8-56a1-855e-d0ba09e87c36', 'b963b579-1234-51a9-a179-9e577cd5765c', '481130c6-d407-56bc-88ec-78ef4cb1ad8d', '132d8118-20c5-56b0-b24d-0d6fdeddc501', '8973ba3b-12fe-5f8e-ab37-0559533cf048', '554943ea-c09a-528c-b40c-985badae2b84', '8c1cff10-fb30-59fd-bc34-01377caf444f', '058eb948-16eb-5140-9673-c046f1f85c59', '760a2799-19ca-5390-a2fb-4eaee959eacf', '1547cc51-5271-5684-b077-7c06e3f11f4e', '3257e99d-2660-5323-9aa5-049dcfea235a', 'f9a46e71-9cba-5b1c-9972-27593d20fd4a', '5ccf770d-2bbb-51d6-b3eb-44cbc4879729', '09e00934-ae5d-5a82-8a12-74bb212acc51', 'a761414c-4656-570d-9797-84088854db6f', '606502f9-7a42-5706-ba52-538e290fc574', '84534f92-387a-5aae-a085-663ea92bbfa9', 'e6e8d472-ffb3-560c-b254-70585341c6a2', '9c4b0c26-1807-5937-9209-f8600b893c23', '6289d8ca-7f89-5274-a661-454ea6f98528', '04aba842-0089-5bd8-9192-0aa0a00d217a', 'a7926885-cba9-57a2-94cb-28fb34528811', '86eabef9-eb17-50c0-9b2e-573c9e621c10', '7fe66ce5-b374-5291-913f-f2366d748628', '53e0e708-72b8-5ffd-beaf-b48f5d673434', 'e12a5532-a554-5ef4-aabb-51490a2c331f', '89b472c2-e11f-5db4-8788-277868af1765', 'ff83ad6a-d8ac-59f2-9d8c-41fe9cd2c7ca', 'bc3660ce-c60e-5d1b-8ee6-8390ac5cea87', '457504ee-db4c-597d-b3d5-173059263078', 'd22fe2dd-dde1-5d91-827a-e4863e5eb325', '16587e62-5f62-58b8-bdab-0ed45705ffdf', 'be179cfc-06fe-59d9-9c40-8701a8d86ad1', '73352b6d-23ce-53ad-a480-41d7d3ad82cc', '1c78cf3c-1ba9-5708-8973-a657855ea469', 'e6765073-0b37-5ac8-ade2-98be8d7b19c7', 'a1354dd9-ce9f-50bc-8523-24a1135f78c1', 'c554e7f4-ae80-557d-aaa8-53143b9d619f', 'be82507b-76aa-5f51-adda-8ca6085d6df4', '1da7af6c-1a95-55bb-9c40-b05ba6ff087b', '187c048c-c484-5e98-9e03-1cc40a34daf1', '777c5972-5e8a-56c4-b4cf-8b3a6cd86b54', 'a0b097d8-f0d8-5236-8ecc-72af95555c5c', '7855d649-82ea-5b02-81cf-326afc40dcc3', '4991d957-7742-5aec-a2f6-4f8ac1713078', '60c9ba60-c9a5-5944-a549-70732127877f', '29b8bf81-87a7-5257-8ed8-9dfc20f24f06', 'c3360361-8de7-5491-a29c-9e3c5fa80b8b');
DELETE FROM public.chapters c WHERE c.subject_id = 'anglais-b1' AND c.id NOT IN ('d3573188-ea41-5396-b14c-c7c1f7fae1e1', 'd1dc7e47-b0d8-5f2d-866b-378c7e8e4f53', '589c4ce0-c4da-5533-947d-7432b122e351', '442e97bd-5019-5a8e-b7eb-861f9cf2b597', '97bbe81f-2f56-59be-a5de-bf2292f92b73') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('d3573188-ea41-5396-b14c-c7c1f7fae1e1', 'anglais-b1', 'The Present Perfect', 'Link the past to now with have/has + past participle: experiences (ever/never), recent actions (just/already/yet) and unfinished time (for/since) — and when to use it instead of the past simple.', '# ⚔️ The Present Perfect — The Bridge Between Past and Now

> 💡 «Some actions are over, yet their result still lives in the present. The present perfect is how English ties yesterday to today.»

## 🏰 What the present perfect is for

The **present perfect** connects a past action to **now**. We usually don''t say exactly *when* it happened — what matters is the **result or relevance in the present**.

_I **have finished** my homework. (it''s done now) — She **has lost** her keys. (she can''t find them now)_

## ⚡ Form: have / has + past participle

| Subject             | Auxiliary       | + past participle      |
| ------------------- | --------------- | ---------------------- |
| I / you / we / they | **have** (''ve)  | _worked / seen / been_ |
| he / she / it       | **has** (''s)    | _worked / seen / been_ |

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

> 🗡️ Tip: after *have/has*, never use the past simple — say _I have **seen** it_, not _~~I have saw it~~_.

## 🔮 Three core uses

1. **Experience** in your life so far — *ever / never*: _**Have** you **ever been** to Rome? I''ve **never tried** sushi._
2. **A recent action with a result now** — *just / already / yet*: _I''ve **just** arrived. She''s **already** left. They haven''t finished **yet**._
3. **Unfinished time up to now** — *for / since*: _I''ve lived here **for** ten years. We''ve known them **since** 2015._

> 🗡️ **for** + a length of time (_for two hours_); **since** + a starting point (_since Monday_).

## 🧭 Present perfect vs past simple

Use the **past simple** for a **finished time you can name** (_yesterday, last week, in 2010, two days ago_). Use the **present perfect** for an **unspecified** time or one that is **still relevant now**.

_I **saw** Sami yesterday. (finished time) — I **have seen** that film. (sometime; an experience)_

> ⚠️ Trap: never put a finished-time word with the present perfect: _~~I have seen him yesterday~~_ → **I saw him yesterday**.

## 🌍 gone vs been

_He **has gone** to Tunis._ = he is there now. — _He **has been** to Tunis._ = he visited and is back.

> 🏆 Gate cleared! The present perfect is the trickiest B1 tense — master it and the rest of B1 opens up. Next: the **past continuous**, for setting the scene of a story.', '# 📜 Résumé: The Present Perfect

- **Form** — *have / has* + past participle (*I have worked, she has gone*); negatives *haven''t / hasn''t*.
- **Past participles** — regular *-ed*; irregulars must be learned (*see → seen, do → done, write → written, be → been*).
- **Experience** — *ever / never*: *Have you ever been…? I''ve never tried…*
- **Recent action, result now** — *just / already / yet*: *I''ve just arrived; she''s already left; not finished yet*.
- **Unfinished time up to now** — *for* + a length (*for ten years*), *since* + a start point (*since 2015*).
- **vs past simple** — a finished, named time → past simple (*I saw him yesterday*); unspecified or still-relevant → present perfect (*I''ve seen that film*).
- ⚠️ Never use a finished-time word (*yesterday, last week, in 2010*) with the present perfect.
- **gone vs been** — *has gone* (still away) vs *has been* (visited, now back).', 1)
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

The past continuous is the past of *to be* (**was / were**) plus the **-ing** form of the main verb:

| Subject             | Auxiliary | + -ing form          |
| ------------------- | --------- | -------------------- |
| I / he / she / it   | **was**   | _working / playing_  |
| you / we / they     | **were**  | _working / playing_  |

Negative: **wasn''t / weren''t** + -ing (_She **wasn''t listening**_). Question: _**Was** she **sleeping**? What **were** you **doing**?_

> 🗡️ Match the auxiliary to the subject: _I/he/she/it_ → **was**, _you/we/they_ → **were**. Say _They **were** playing_, never _~~They was playing~~_.

## 🛡️ Spelling the -ing form

Most verbs simply add **-ing**, but watch three patterns:

| Rule                                    | Example                |
| --------------------------------------- | ---------------------- |
| ends in **-e** → drop the e, add -ing   | make → **making**      |
| **one short vowel + consonant** → double it | run → **running**, sit → **sitting** |
| ends in **-ie** → change to **-ying**   | lie → **lying**        |

_He was **making** tea. The kids were **running** outside. The cat was **lying** on the sofa._

> ⚠️ Trap: don''t keep a silent *-e* (_~~makeing~~_ → **making**) and don''t forget to double the consonant (_~~runing, siting~~_ → **running, sitting**).

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

> 🗡️ Quick test: *while* + *was/were …-ing*, *when* + past simple. If both clauses are long and parallel, both are continuous.

## 🌍 Stative verbs stay simple

Verbs of **state** — *know, want, like, believe, be* — describe a condition, not an action, so they are **not** normally used in the continuous. Use the past simple instead.

_I **knew** the answer. (not ~~I was knowing the answer~~) — She **wanted** to leave. (not ~~was wanting~~)_

> 🏆 Gate cleared! You can now set any scene and interrupt it on cue. Next: **conditionals** — *if* this happens, that follows — where you bend past, present, and future to your will.', '# 📜 Résumé: The Past Continuous

- **Use** — an action in progress at a past moment (*At 8 p.m. I was having dinner*) and the background/setting of a story.
- **Form** — *was / were* + verb-**ing** (*I was working, they were playing*); negatives *wasn''t / weren''t* + -ing.
- **Questions** — *Was she sleeping? What were you doing?*
- **Agreement** — *I/he/she/it* → **was**, *you/we/they* → **were** (never *they was*).
- **-ing spelling** — *make → making* (drop -e), *run → running* / *sit → sitting* (double the consonant), *lie → lying*.
- **Interrupted action** — long background action (past continuous) cut by a short event (past simple): *I was reading when the phone rang*.
- **while vs when** — *while* + the long action (*while I was cooking*), *when* + the short action (*when the doorbell rang*).
- **Two parallel actions** — both in the past continuous: *While she was studying, he was watching TV*.
- ⚠️ **Stative verbs** (*know, want, like, be*) are normally NOT used in the continuous — use the past simple (*I knew*, not *I was knowing*).', 2)
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

A **conditional** has two halves: an **if-clause** (the condition) and a **result clause** (the consequence). Change the tenses and you change the *meaning* — from a guaranteed fact, to a likely future, to a pure fantasy.

_**If** you heat ice, it **melts**. — **If** it **rains**, I **''ll stay** in. — **If** I **won** the lottery, I **would travel** the world._

> 🗡️ Punctuation rule: when the **if-clause comes first**, put a **comma** before the result (_If it rains, I''ll stay in_). When the result comes first, no comma is needed (_I''ll stay in if it rains_).

## ⚡ The zero conditional — general truths

Use the **zero conditional** for things that are **always true**: facts, science, habits, instructions. Both halves are in the **present simple**.

**Form:** _If + present simple, … present simple._

_If you **mix** blue and yellow, you **get** green. — If water **reaches** 100°C, it **boils**. — If I **''m** tired, I **go** to bed early._

Here *if* means roughly **"whenever"** — the result is automatic, not a one-time future event.

## 🛡️ The first conditional — real future

Use the **first conditional** for a **real, possible future** situation and its likely result. The if-clause stays in the **present simple**; the result uses **will** (or **won''t**) + the base verb.

**Form:** _If + present simple, … will + base verb._

_If it **rains** tomorrow, I **''ll stay** at home. — If you **study** hard, you **''ll pass** the exam. — If we **don''t hurry**, we **''ll miss** the bus._

> ⚠️ Classic trap: **never** put *will* in the if-clause. Say _If it **rains**…_, never _~~If it will rain…~~_. The condition is in the present, even though it points to the future.

## 🔮 The second conditional — unreal & hypothetical

Use the **second conditional** for situations that are **imaginary, unlikely, or untrue now** — daydreams and pure hypotheses. The if-clause moves to the **past simple**; the result uses **would** (or **wouldn''t**) + the base verb.

**Form:** _If + past simple, … would + base verb._

_If I **won** the lottery, I **would travel** the world. — If she **had** more time, she **would learn** Japanese. — If we **lived** by the sea, we **''d swim** every day._

The past tense here does **not** mean past time — it signals **distance from reality**. To give advice, the fixed phrase is **If I were you** (standard form with *were* for every subject): _If I **were** you, I **''d apologise**._

> 🗡️ Tip: *would* belongs in the **result** only — _If I **had**… I **would**…_, never _~~If I would have…~~_.

## 🧭 The three forms side by side

| Type   | Use                          | If-clause          | Result clause     | Example                                  |
| ------ | ---------------------------- | ------------------ | ----------------- | ---------------------------------------- |
| Zero   | general truth / fact         | _present simple_   | _present simple_  | _If you heat ice, it **melts**._         |
| First  | real, likely future          | _present simple_   | _**will** + base_ | _If it rains, I **''ll stay** in._        |
| Second | unreal / hypothetical now    | _past simple_      | _**would** + base_| _If I won, I **would travel**._          |

The split is simple: **will → real future**, **would → imaginary**. And whatever the type, the helper (*will* / *would*) lives in the **result**, never in the *if*.

> ⚠️ Trap: don''t **mix** the conditionals. It''s either _If I **win**, I **will**…_ (first) or _If I **won**, I **would**…_ (second) — never _~~If I win, I would…~~_ or _~~If I won, I will…~~_.

## 🧪 After will / would: always the base verb

Both *will* and *would* are followed by the **bare base verb** — no *to*, no *-s*, no *-ed*.

_She will **go** (not ~~will to go~~, not ~~will goes~~). — He would **come** (not ~~would comes~~, not ~~would to come~~)._

> 🏆 Gate cleared! You can now reason about facts, real plans and pure fantasies. The doorway beyond this is **modal verbs** (*can, must, should, might*) — the precise tools for ability, obligation and possibility.', '# 📜 Résumé: Conditionals

- **Two halves** — an *if-clause* (the condition) + a *result clause* (the consequence); the tenses you choose decide the meaning.
- **Comma rule** — put a comma when the *if-clause* comes first (*If it rains, I''ll stay in*); none when the result comes first (*I''ll stay in if it rains*).
- **Zero conditional** — general truths/facts: *if + present simple, … present simple* (*If you heat ice, it melts*). Here *if* ≈ *whenever*.
- **First conditional** — real, likely future: *if + present simple, … will + base* (*If it rains, I''ll stay in*).
- **Second conditional** — unreal/hypothetical now: *if + past simple, … would + base* (*If I won, I would travel*). The past = distance from reality, not past time.
- **Advice phrase** — *If I were you, I''d…* uses *were* for every subject.
- ⚠️ **Never** put *will* or *would* inside the *if-clause* (*If it rains…*, not *If it will rain…*).
- ⚠️ **Don''t mix** the types: *If I win, I will…* (first) or *If I won, I would…* (second) — not a blend of the two.
- **Base verb** — *will* and *would* are always followed by the bare base verb (*will go*, *would come*, never *will to go* / *would goes*).', 3)
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

A **modal** is a helper verb that adds meaning to a main verb. This chapter''s modals tell you about **rules and choices**: what is **necessary** (*must / have to*), what is **forbidden** (*mustn''t*), what is **optional** (*don''t have to*), and what is a **good or bad idea** (*should / shouldn''t*).

_You **must** wear a seatbelt. You **mustn''t** smoke here. You **don''t have to** come. You **should** see a doctor._

## ⚡ The map of meanings

Learn this table by heart — choosing the wrong modal changes the whole message.

| Modal              | Meaning                          | Example                                  |
| ------------------ | -------------------------------- | ---------------------------------------- |
| **must / have to** | obligation, it is necessary      | _I **must** finish this today._          |
| **mustn''t**        | prohibition, it is forbidden     | _You **mustn''t** park here._             |
| **don''t have to**  | no obligation, it is optional    | _You **don''t have to** wait for me._     |
| **should**         | advice, a good idea              | _You **should** rest more._              |
| **shouldn''t**      | advice against, a bad idea       | _You **shouldn''t** eat so late._         |

## 🛡️ Form: always the base verb

Every modal here is followed by the **base verb** — no *to*, no *-s*, no *-ing*.

_She **must go** now._ — _He **should see** a doctor._ — _They **mustn''t be** late._

The one exception in spelling is **have to**, a semi-modal that **agrees** with the subject: *I/you/we/they* **have to**, but *he/she/it* **has to**.

_I **have to** study. — She **has to** study._

> 🗡️ Tip: never add *to* after *must*, *mustn''t* or *should*. Say _You **must wait**_ and _You **should call**_, never _~~must to wait~~_ or _~~should to call~~_.

## 🔮 must vs have to

Both express obligation and are usually interchangeable. A subtle difference: **must** often signals the speaker''s own feeling or a written rule (*I must call my mother*), while **have to** points to an outside obligation (*I have to wear a uniform at work*). For past obligation, both become **had to**: _Yesterday I **had to** work late._

_You **must** try this cake! (my strong recommendation) — I **have to** renew my passport. (the law requires it)_

## 🧭 should — the voice of advice

Use **should / shouldn''t** to recommend, not to command. It is softer than *must*: it means *it is a good idea*, not *it is required*.

_You **should** drink more water. — You **shouldn''t** drink so much coffee. — **Should** I apologise?_

> 🗡️ Tip: in questions, the modal comes first: _**Should** I call her?_ — _**Do** I **have to** sign this?_ (*have to* uses *do* in questions).

## ⚠️ The great trap: mustn''t ≠ don''t have to

This is the most important contrast in the chapter — and the classic B1 error.

- **mustn''t** = it is **forbidden**. _You **mustn''t** park here_ = parking is **not allowed**; don''t do it.
- **don''t have to** = it is **not necessary**. _You **don''t have to** park here_ = it is **optional**; you can if you want.

They are **opposites, not synonyms**. *Mustn''t* closes the door; *don''t have to* leaves it open.

_You **mustn''t** tell anyone. (it''s a secret — forbidden) — You **don''t have to** tell anyone. (it''s up to you — optional)_

> 🏆 Gate cleared! You can now command, forbid, free and advise like a native. Next quest: **relative clauses** (*who, which, that*) — the tool that joins two ideas into one elegant sentence.', '# 📜 Résumé: Modals of Obligation & Advice

- **must / have to** — obligation, it is necessary (*I must finish this; I have to wear a uniform*).
- **mustn''t** — prohibition, it is forbidden (*You mustn''t smoke here* = don''t do it).
- **don''t have to** — no obligation, it is optional (*You don''t have to come* = you can if you want).
- ⚠️ **mustn''t ≠ don''t have to** — *mustn''t* = forbidden; *don''t have to* = not necessary. They are opposites, not synonyms.
- **should / shouldn''t** — advice, a good or bad idea (*You should rest; you shouldn''t worry*) — softer than *must*.
- **Base verb always** — modal + base, no *to* and no *-s* (*she must go*, *you should call*), never *~~must to go~~*.
- **have to agrees** — *I/you/we/they have to*, but *he/she/it has to* (*She has to study*).
- **Questions** — *Should I…?* (modal first); *have to* uses *do*: *Do I have to…?*
- **Past** — *must* and *have to* both become **had to** (*Yesterday I had to work late*).', 4)
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

The relative pronoun (*who, which, that, where, whose*) points back to the noun and introduces the extra information.

## ⚡ The relative pronouns at a glance

Each pronoun matches a kind of noun. Learn this table — it is the heart of the whole chapter.

| Pronoun   | Use it for           | Example                                        |
| --------- | -------------------- | ---------------------------------------------- |
| **who**   | people               | _The girl **who** sits next to me is Lina._    |
| **which** | things / animals     | _The phone **which** broke was new._           |
| **that**  | people **or** things | _The film **that** we saw was great._          |
| **where** | places               | _The town **where** I was born is small._      |
| **whose** | possession           | _The boy **whose** bag was stolen is crying._  |
| **when**  | times                | _I remember the day **when** we met._          |

> 🗡️ Tip: **that** is the all-rounder. In everyday, informal English it replaces *who* (for people) and *which* (for things): _the man **that** called_, _the book **that** I read_. Both are correct.

## 🛡️ Defining clauses take NO commas

A **defining** relative clause gives **essential** information — it tells you *which* one we mean. Remove it and the sentence loses its point. Defining clauses take **no commas**.

_The student **who won the prize** is my cousin._ (which student? — the one who won)

Without the clause, *the student* could be anyone. The clause is doing real work, so no commas separate it.

## 🔮 "Whose" and "where" — the special agents

**Whose** shows **possession** — it replaces *his / her / its / their*. It works for people and things.

_That''s the woman **whose** car was stolen._ (her car) — _A house **whose** roof is red…_ (its roof)

**Where** points to a **place**, replacing *in / at / on which*.

_This is the diner **where** we first met._ (= the diner in which we met)

> ⚠️ Trap: never use **what** as a relative pronoun. Say _the thing **that** I need_, never _~~the thing what I need~~_. And don''t confuse **whose** (possession) with **who''s** (= *who is*): _the man **whose** son…_ vs _the man **who''s** here_.

## 🧭 Leaving out the pronoun (object clauses)

When the relative pronoun is the **object** of its clause — the *thing acted on*, not the doer — you can **drop it** completely. The sentence stays perfectly correct.

_The film **(that)** we watched was great._ — _The man **(who)** I met yesterday called again._

But when the pronoun is the **subject** (the doer), you **cannot** leave it out:

_The man **who** lives next door…_ → never _~~the man lives next door~~_.

> 🗡️ Quick test: if a noun or pronoun (*we, I, she*) comes straight after the relative pronoun, the pronoun is the object — you may drop it. If a verb comes next, it''s the subject — keep it.

## 🌍 Defining vs the rest

Use **who / which / that** to identify *which* person or thing, **where** for the place, and **whose** for the owner: _the woman **who** called, the phone **which** broke, the city **where** I live, the man **whose** car was stolen._ Choose the pronoun by what the noun **is**, not by what sounds familiar.

> 🏆 Final B1 gate cleared! Relative clauses are the last competence of your intermediate journey — with them you can link ideas like a fluent speaker. You''ve conquered the present perfect, the past, conditionals, modals and now relative clauses. Your reward awaits: the **B1 Donjon**, where every B1 skill is tested at once in a single varied gauntlet. Step in, hero.', '# 📜 Résumé: Relative Clauses

- **Purpose** — a relative clause adds information about a noun so you join two sentences into one (*I know a man who repairs bikes*).
- **who** — for people: *the girl who sits next to me*.
- **which** — for things and animals: *the phone which broke*.
- **that** — the all-rounder, for people **or** things, very common in informal English: *the film that we saw*.
- **where** — for places (= *in/at which*): *the town where I was born*.
- **whose** — for possession, replacing *his/her/its/their*: *the boy whose bag was stolen*.
- **when** — for times: *the day when we met*.
- **Defining clauses take no commas** — they give essential information that tells you *which* one (*the student who won the prize is my cousin*).
- **Drop the object pronoun** — when the pronoun is the object you can leave it out: *the film (that) we watched*; but keep it when it is the subject (*the man who lives next door*).
- ⚠️ Never use **what** as a relative pronoun (*the thing that I need*, not *the thing what I need*), and don''t confuse **whose** (possession) with **who''s** (= *who is*).', 5)
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

