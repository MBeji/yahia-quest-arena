-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: iq-training-ar (Muscle ton cerveau — Entraînement QI (AR))
-- Regenerate with: npm run content:build
-- Source of truth: content/iq-training-ar/
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
  ('iq-training-ar', 'Muscle ton cerveau — Entraînement QI (AR)', 'تحديات بصرية في المنطق الخالص: تأمّل الشكل، استنتج القاعدة الخفية، واختر الإجابة الصحيحة — لا حاجة للحفظ، فقط الاستدلال.', 'Logique', 'subject-math', 'Brain', 62, 'ar', false, 'muscle-cerveau', NULL)
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
      AND e.subject_id = 'iq-training-ar'
      AND e.source = 'admin'
      AND q.id NOT IN ('335a40c8-0da5-5df3-8289-c67cc7f77002', '4b531524-c2ef-56c9-94c5-709a60d5b46d', '6d9252da-8f60-5bf9-a50c-d7916c85bb9e', 'c3666759-2c0e-5140-8b95-0bfe3ae1d23e', 'affa95aa-7930-5fbd-ba22-e55099c21dbe', 'ad7f1b0c-b854-5311-abbf-f6d5e76e2951', '3ff27478-e345-5909-9aac-ec5e886adee7', 'b2fb4d08-dd2d-5af1-85c2-18aca908c70b', '0a993414-e1a9-5482-ae20-4f2e307f88f5', '29c9bad4-b7b0-582e-bce4-de5a5b55c60e', '36fbeff0-7d40-50fe-afc7-19b976a14dca', '10c035c9-4cc3-5f6d-a719-14c648588cf3', 'a022afa1-35fe-5a5e-90ca-9f3d92d0dd7f', '0b91f4ee-5d3f-5a57-a5b0-57c676842fb1', '433e21a6-e774-575c-91fa-fa9857067ab3', '299c6fc4-3e89-558f-9e97-ab66670ea532', '7bdb2ac4-306c-556f-b22c-02938c4f2f94', '3cadfe49-f91c-5e25-a168-38377d42fa74', '6ec5669c-7a22-5e48-ab75-693fb4232a42', '2eed1404-5ae5-5e69-b0a7-afe472749347', 'fa6aa5f3-333d-5174-b018-912ba2cd3ba4', 'c3f02429-df24-5a85-bfea-588d959b2c94', '59181ea7-ea56-562e-988f-055b40dad562', '6e9c6712-9ff0-5a18-b23a-83e157200471', '304717c4-0c7f-5e4e-bc43-01be6c1e6d85', '748b6bc5-2d55-5dde-9e5d-7f09bf22a285', '600882c8-4f33-54d7-8566-afc5e5562613', '3c9b8464-f218-54ae-8997-e0df065a23cd', '44370ec7-aff6-5e2d-a033-e4fbf597a7f6', 'dfcda654-4a8e-57b8-891c-94bc6f9afd3e', 'fb4a68da-19dc-5159-9b9a-d76e8d75f60f', 'cabc5ae3-2aee-5ea1-839f-0eeffa90165b', 'bb58bce7-2a97-5635-8e93-bd46b7fd3426', 'bf1054a5-a38a-5fa0-9c52-1c88bd25e604', '39beb47d-995d-5161-ae74-2683320ebb90', 'c4cc56ac-63da-5456-8bf9-feb0bc54e80c', '571581fd-3c5e-5f0d-95a9-4faf6d951a36', 'd9249d31-3cce-5436-8866-c4a454b75e64', '3479c876-d176-5de6-ae25-1c2b852524d2', 'ac991928-7aba-5c7e-a892-92a8673155ae', '77cfda83-d79a-54b5-a711-70bf6fe64326', '347fc039-b8ea-527b-920c-e6fae785f614', 'a9fb5ebc-5704-5005-a00a-6c2cfc993404', '7a25e4c0-dbbd-5e0a-b4e9-2bb5a2bf0acd', 'bd79d725-261a-5bc4-9d65-266cc3924b6b', '0fb01dd2-1808-5d07-a31b-f57b169655e0', 'b68f7891-0005-5c67-b356-d2f622730d25', '22f97190-c7f9-555f-9f64-2cd31dd717d0', '528f0a45-fe3c-54ad-a752-4ac12d42dd97', '9cdb451a-8318-5f9e-a8a8-a7223ebdb53a', '22083648-9160-59af-b832-42e454f4c55f', 'bb37a426-5636-522b-bd9d-7d4a09111922', 'e447d766-ec7d-5966-9ff4-2f2d654f9dde', 'dcdec3bd-c933-53a1-82f4-ea8c5e35172f', 'add79ee1-14a9-50a8-a926-9bc684d2ae03', 'a36fd065-8b3d-57b1-8620-1fbe8f127c2f', 'c9074c9d-3285-5e33-b0a9-75bde9b0591b', '78ec22be-cfbf-5f82-8deb-9b0d64f7c31e', '036468ad-bdf3-5045-84d0-9f594df255f0', 'f7969220-c90f-567e-84f1-6d23f6cd27bf', 'd356ebca-8101-58d7-a78a-0ba5a41a881a', '70e80b22-b982-505f-8f38-92f12c2720ab', 'ff1c9abd-9e3e-5219-acb5-d326ca69e0fb', '4fa181bb-f651-5c63-ae8d-0f2f992d5650', '2ce3318e-8b99-56bb-85d1-6c1fd5f896f9', 'c5ea8bd5-6720-55af-82c1-301698eaabe4', '82f2deb6-1c85-5842-82c4-fcbb63e447a0', 'b450c4b4-18f0-50ad-82a1-97f14cecf3f1', '888cb3c2-f40d-5312-82a4-5d9394a7dbca', '96db6e0e-3e95-52d5-b762-5adec0116d89', '55d25c85-47ec-5251-ae5b-905df0921072', '037c81e6-179b-56b2-9062-f60cf0685106', '953fa7dd-cc4d-59c7-a40f-1371abf15811', 'f2fbc3cd-cc5b-5a67-ab7d-babcee474877', 'e31be173-5250-547f-95db-ae7338128173', '9240cfd0-794a-5baf-892a-80a9091baf17', 'c76b7756-2e6b-51e9-a283-e56f05c898fc', '369d2ceb-7d3a-5c29-b5b2-12d993ca9d4b', '6f0ae987-0d1f-5208-a276-a99808d29c19', '4a870f88-8b9c-5b7e-8079-96ebade0afd1', '114c8dd4-7fd4-5aa4-8ce6-3707101dfdbc', 'ec0d06b8-a733-5e6b-84fe-41284bc8f46a', '0f7a70db-dcbf-5279-a1ef-6b960089be87', 'ea7afbc5-9240-5028-935d-7cf31cd6659b', 'cfef7dbe-0335-5e9b-a0d4-138eb8a62d02', '89eeb119-5cd7-5fd8-988e-4e45a3361601', '12194ce2-dc24-5468-91c7-2fd34bbc45d4', '75413116-872b-5946-9a25-82606146b3dd', '2c3ea28b-010d-52d2-914f-54359b32ff37', '9b1c7690-5d00-5358-a319-be25c94a2a3b', 'ca9e0882-dc7b-5b7e-8df8-96500dbc186a', '2226f50e-ebf7-5b13-b40d-e24000058c33', '0ef34084-d305-5447-9e86-7d4b1a1b2295', '8442d8eb-98d6-5a92-91a7-29340698ff07', '7b996057-3ec6-5ac8-871f-b2c29d643291', '4b75734a-994d-5a50-ad8b-5d0eee187b7d', 'be6c1085-4681-5e64-94f8-adea6253c5a6', '35240517-3da3-5ef3-bc43-cc817e8a9522', '80d3c94d-023e-5b77-b4ca-f6b0752b349a', '7ed6cad4-6e3b-5a28-89e4-ccd59d2ccaac', '809b61bc-2ac1-5a7b-800a-bfe3e4b072de', '7cafe430-a055-571c-a708-3f23da30081c', 'b3dfc91c-37b1-5510-a23c-8fcdd26ea73a', '66d1f767-acea-5abf-a5b1-148eb058c4ea', '5181f5e7-4b62-5485-87b9-a3214f8e7a7f', '1cb688cc-5ff0-515b-88c4-915aacbcd867', '6c334633-b944-57a2-9517-d5f593b9a4f0', '91fe4dc0-58a2-5aaf-a36b-7791b9b4ae6a', '6aa72c74-d465-56a8-b993-cf20b7d6e1c2', 'a1a239ce-d70d-54d0-8ab7-39f0a75a46a0', 'b45eebd2-e70a-534f-9495-eaa033e7e335', '6f0c2056-1f59-5029-a19e-e773c805c0df', 'fde6d2de-ee50-503f-8eb5-18379679c30c', '838656dd-aaff-5215-b7b9-d6e977415dbb', 'd0a969ae-7d4c-5010-85d8-77c3f053aa4b');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'iq-training-ar' AND source = 'admin' AND id NOT IN ('4b66b74d-6891-51d1-91d2-b0b83cd5eb8d', '173f0008-f62a-587f-a504-4d8d8a5e96c6', '35a8b944-29ab-5137-9812-450c4fcf4733', '612f2e23-198b-52b7-9574-7910602ace5a', 'f8487b44-051f-5e1a-b1cf-d7d9eae4c408', '4212a2ce-dc73-58c6-b7f9-711137cc2f4e', '6f0e4817-1517-590d-8089-bafe582124ed', 'ef8eb95c-c1c9-5333-8cfc-29dd649c6d95', '28bccb54-dffd-5bac-af66-10f6cea1559c', 'e8e1afe6-52a0-5699-8ac5-9b008e2c7bf3', '8144cb53-8600-53c6-9eb1-cf65a8f5aaa8', '77cf718d-7b55-55cf-a6dd-de899ee244f9', 'ea9c5003-1a50-550f-95d7-de768f7c6af1', '0fe46ced-c606-51f1-aa0b-3fe06a65f299', 'db6431d0-68af-5686-a150-7ded73153182', 'b51b1f11-7518-52d2-b9ab-ebad569eaf45', '980ec638-3ca1-5d43-80b7-ad553192c84f', '0e4f0aee-576b-5d25-8991-c3ad5267012f', 'ed27948b-29ed-59ed-b1ab-568961395c0a', '62bcfe47-2174-541d-87d4-64f3df9b0a6e');
DELETE FROM public.questions WHERE exercise_id IN ('4b66b74d-6891-51d1-91d2-b0b83cd5eb8d', '173f0008-f62a-587f-a504-4d8d8a5e96c6', '35a8b944-29ab-5137-9812-450c4fcf4733', '612f2e23-198b-52b7-9574-7910602ace5a', 'f8487b44-051f-5e1a-b1cf-d7d9eae4c408', '4212a2ce-dc73-58c6-b7f9-711137cc2f4e', '6f0e4817-1517-590d-8089-bafe582124ed', 'ef8eb95c-c1c9-5333-8cfc-29dd649c6d95', '28bccb54-dffd-5bac-af66-10f6cea1559c', 'e8e1afe6-52a0-5699-8ac5-9b008e2c7bf3', '8144cb53-8600-53c6-9eb1-cf65a8f5aaa8', '77cf718d-7b55-55cf-a6dd-de899ee244f9', 'ea9c5003-1a50-550f-95d7-de768f7c6af1', '0fe46ced-c606-51f1-aa0b-3fe06a65f299', 'db6431d0-68af-5686-a150-7ded73153182', 'b51b1f11-7518-52d2-b9ab-ebad569eaf45', '980ec638-3ca1-5d43-80b7-ad553192c84f', '0e4f0aee-576b-5d25-8991-c3ad5267012f', 'ed27948b-29ed-59ed-b1ab-568961395c0a', '62bcfe47-2174-541d-87d4-64f3df9b0a6e') AND id NOT IN ('335a40c8-0da5-5df3-8289-c67cc7f77002', '4b531524-c2ef-56c9-94c5-709a60d5b46d', '6d9252da-8f60-5bf9-a50c-d7916c85bb9e', 'c3666759-2c0e-5140-8b95-0bfe3ae1d23e', 'affa95aa-7930-5fbd-ba22-e55099c21dbe', 'ad7f1b0c-b854-5311-abbf-f6d5e76e2951', '3ff27478-e345-5909-9aac-ec5e886adee7', 'b2fb4d08-dd2d-5af1-85c2-18aca908c70b', '0a993414-e1a9-5482-ae20-4f2e307f88f5', '29c9bad4-b7b0-582e-bce4-de5a5b55c60e', '36fbeff0-7d40-50fe-afc7-19b976a14dca', '10c035c9-4cc3-5f6d-a719-14c648588cf3', 'a022afa1-35fe-5a5e-90ca-9f3d92d0dd7f', '0b91f4ee-5d3f-5a57-a5b0-57c676842fb1', '433e21a6-e774-575c-91fa-fa9857067ab3', '299c6fc4-3e89-558f-9e97-ab66670ea532', '7bdb2ac4-306c-556f-b22c-02938c4f2f94', '3cadfe49-f91c-5e25-a168-38377d42fa74', '6ec5669c-7a22-5e48-ab75-693fb4232a42', '2eed1404-5ae5-5e69-b0a7-afe472749347', 'fa6aa5f3-333d-5174-b018-912ba2cd3ba4', 'c3f02429-df24-5a85-bfea-588d959b2c94', '59181ea7-ea56-562e-988f-055b40dad562', '6e9c6712-9ff0-5a18-b23a-83e157200471', '304717c4-0c7f-5e4e-bc43-01be6c1e6d85', '748b6bc5-2d55-5dde-9e5d-7f09bf22a285', '600882c8-4f33-54d7-8566-afc5e5562613', '3c9b8464-f218-54ae-8997-e0df065a23cd', '44370ec7-aff6-5e2d-a033-e4fbf597a7f6', 'dfcda654-4a8e-57b8-891c-94bc6f9afd3e', 'fb4a68da-19dc-5159-9b9a-d76e8d75f60f', 'cabc5ae3-2aee-5ea1-839f-0eeffa90165b', 'bb58bce7-2a97-5635-8e93-bd46b7fd3426', 'bf1054a5-a38a-5fa0-9c52-1c88bd25e604', '39beb47d-995d-5161-ae74-2683320ebb90', 'c4cc56ac-63da-5456-8bf9-feb0bc54e80c', '571581fd-3c5e-5f0d-95a9-4faf6d951a36', 'd9249d31-3cce-5436-8866-c4a454b75e64', '3479c876-d176-5de6-ae25-1c2b852524d2', 'ac991928-7aba-5c7e-a892-92a8673155ae', '77cfda83-d79a-54b5-a711-70bf6fe64326', '347fc039-b8ea-527b-920c-e6fae785f614', 'a9fb5ebc-5704-5005-a00a-6c2cfc993404', '7a25e4c0-dbbd-5e0a-b4e9-2bb5a2bf0acd', 'bd79d725-261a-5bc4-9d65-266cc3924b6b', '0fb01dd2-1808-5d07-a31b-f57b169655e0', 'b68f7891-0005-5c67-b356-d2f622730d25', '22f97190-c7f9-555f-9f64-2cd31dd717d0', '528f0a45-fe3c-54ad-a752-4ac12d42dd97', '9cdb451a-8318-5f9e-a8a8-a7223ebdb53a', '22083648-9160-59af-b832-42e454f4c55f', 'bb37a426-5636-522b-bd9d-7d4a09111922', 'e447d766-ec7d-5966-9ff4-2f2d654f9dde', 'dcdec3bd-c933-53a1-82f4-ea8c5e35172f', 'add79ee1-14a9-50a8-a926-9bc684d2ae03', 'a36fd065-8b3d-57b1-8620-1fbe8f127c2f', 'c9074c9d-3285-5e33-b0a9-75bde9b0591b', '78ec22be-cfbf-5f82-8deb-9b0d64f7c31e', '036468ad-bdf3-5045-84d0-9f594df255f0', 'f7969220-c90f-567e-84f1-6d23f6cd27bf', 'd356ebca-8101-58d7-a78a-0ba5a41a881a', '70e80b22-b982-505f-8f38-92f12c2720ab', 'ff1c9abd-9e3e-5219-acb5-d326ca69e0fb', '4fa181bb-f651-5c63-ae8d-0f2f992d5650', '2ce3318e-8b99-56bb-85d1-6c1fd5f896f9', 'c5ea8bd5-6720-55af-82c1-301698eaabe4', '82f2deb6-1c85-5842-82c4-fcbb63e447a0', 'b450c4b4-18f0-50ad-82a1-97f14cecf3f1', '888cb3c2-f40d-5312-82a4-5d9394a7dbca', '96db6e0e-3e95-52d5-b762-5adec0116d89', '55d25c85-47ec-5251-ae5b-905df0921072', '037c81e6-179b-56b2-9062-f60cf0685106', '953fa7dd-cc4d-59c7-a40f-1371abf15811', 'f2fbc3cd-cc5b-5a67-ab7d-babcee474877', 'e31be173-5250-547f-95db-ae7338128173', '9240cfd0-794a-5baf-892a-80a9091baf17', 'c76b7756-2e6b-51e9-a283-e56f05c898fc', '369d2ceb-7d3a-5c29-b5b2-12d993ca9d4b', '6f0ae987-0d1f-5208-a276-a99808d29c19', '4a870f88-8b9c-5b7e-8079-96ebade0afd1', '114c8dd4-7fd4-5aa4-8ce6-3707101dfdbc', 'ec0d06b8-a733-5e6b-84fe-41284bc8f46a', '0f7a70db-dcbf-5279-a1ef-6b960089be87', 'ea7afbc5-9240-5028-935d-7cf31cd6659b', 'cfef7dbe-0335-5e9b-a0d4-138eb8a62d02', '89eeb119-5cd7-5fd8-988e-4e45a3361601', '12194ce2-dc24-5468-91c7-2fd34bbc45d4', '75413116-872b-5946-9a25-82606146b3dd', '2c3ea28b-010d-52d2-914f-54359b32ff37', '9b1c7690-5d00-5358-a319-be25c94a2a3b', 'ca9e0882-dc7b-5b7e-8df8-96500dbc186a', '2226f50e-ebf7-5b13-b40d-e24000058c33', '0ef34084-d305-5447-9e86-7d4b1a1b2295', '8442d8eb-98d6-5a92-91a7-29340698ff07', '7b996057-3ec6-5ac8-871f-b2c29d643291', '4b75734a-994d-5a50-ad8b-5d0eee187b7d', 'be6c1085-4681-5e64-94f8-adea6253c5a6', '35240517-3da3-5ef3-bc43-cc817e8a9522', '80d3c94d-023e-5b77-b4ca-f6b0752b349a', '7ed6cad4-6e3b-5a28-89e4-ccd59d2ccaac', '809b61bc-2ac1-5a7b-800a-bfe3e4b072de', '7cafe430-a055-571c-a708-3f23da30081c', 'b3dfc91c-37b1-5510-a23c-8fcdd26ea73a', '66d1f767-acea-5abf-a5b1-148eb058c4ea', '5181f5e7-4b62-5485-87b9-a3214f8e7a7f', '1cb688cc-5ff0-515b-88c4-915aacbcd867', '6c334633-b944-57a2-9517-d5f593b9a4f0', '91fe4dc0-58a2-5aaf-a36b-7791b9b4ae6a', '6aa72c74-d465-56a8-b993-cf20b7d6e1c2', 'a1a239ce-d70d-54d0-8ab7-39f0a75a46a0', 'b45eebd2-e70a-534f-9495-eaa033e7e335', '6f0c2056-1f59-5029-a19e-e773c805c0df', 'fde6d2de-ee50-503f-8eb5-18379679c30c', '838656dd-aaff-5215-b7b9-d6e977415dbb', 'd0a969ae-7d4c-5010-85d8-77c3f053aa4b');
DELETE FROM public.chapters c WHERE c.subject_id = 'iq-training-ar' AND c.id NOT IN ('c26001cd-28bd-5577-a31b-c8729b7790ef', 'f1fe9612-e645-526d-bc44-3fa7363d066d', '4a093f2d-7950-50df-a390-9a288dcc4b77', '3c755566-06b5-5a65-b56d-b233748d0617', '006becf5-229a-58e9-8a5c-c81818b22ae9') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('c26001cd-28bd-5577-a31b-c8729b7790ef', 'iq-training-ar', 'الاستدلال البصري', 'مصفوفات، متتاليات أشكال، دورانات، تماثلات والشاذ: اكتشف القاعدة الخفية في كل شكل وطبّقها.', '# 🧠 تدريب — لا درس هنا. تأمّل كل شكل، استنتج القاعدة، طبّقها.

هنا لا نراجع شيئًا: كل مهمة لغز يُحلّ بالاستنتاج الخالص. ثق بعينك وبمنطقك. 💪', '📜 حُلّ بالاستنتاج، لا بالحفظ أبدًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('f1fe9612-e645-526d-bc44-3fa7363d066d', 'iq-training-ar', 'المنطق', 'متتاليات وتناظرات وأقيسة منطقية واستنتاجات شرطية: اكتشف القاعدة الخفية وطبّقها دون أن تحفظ شيئًا.', '# 🧠 المنطق — لا درس. لاحِظ، استنتج القاعدة، ثم طبّقها.', '📜 قاعدة واحدة تحكم كل لغز: اعثر عليها، ثم طبّقها.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('4a093f2d-7950-50df-a390-9a288dcc4b77', 'iq-training-ar', 'الرياضيات والاستدلال', 'متتاليات عددية، تماثلات رقمية، شبكات حسابية ونسب: اكتشف القاعدة الخفية بالاستنتاج، لا بصيغة محفوظة.', '# 🧠 الرياضيات والاستدلال — لا درس هنا. تأمّل الأعداد، استنتج القاعدة، ثم طبّقها.', '📜 القاعدة كامنة في الأعداد: استنتجها، لا تردّدها عن ظهر قلب.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('3c755566-06b5-5a65-b56d-b233748d0617', 'iq-training-ar', 'الذكاء السيّال', 'مسائل جديدة بلا طريقة محفوظة: استنتج النمط، واكتشف قاعدة التحويل وطبّقها — قدرة خالصة على الاستدلال.', '# 🧠 الذكاء السيّال — لا درس. لاحِظ، واستنتج القاعدة، وطبّقها.', '📜 أمام الجديد: استنتج النمط، وجِد القاعدة، وطبّقها — لا اعتماد على الذاكرة أبدًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('006becf5-229a-58e9-8a5c-c81818b22ae9', 'iq-training-ar', 'الهندسة والإدراك المكاني', 'دورانات وتماثلات وعدّ المكعبات المخفية ومخططات قابلة للطي: تخيّل الشكل في الفضاء واستنتج التحويل.', '# 🧠 الهندسة والإدراك المكاني — لا درس هنا. لاحظ الشكل، واستنتج القاعدة، ثم طبّقها.', '📐 أدِر الشكل في ذهنك: استنتج التحويل، ولا تحفظه.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4b66b74d-6891-51d1-91d2-b0b83cd5eb8d', 'c26001cd-28bd-5577-a31b-c8729b7790ef', 'iq-training-ar', 'إحماء بصري ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('335a40c8-0da5-5df3-8289-c67cc7f77002', '4b66b74d-6891-51d1-91d2-b0b83cd5eb8d', 'تأمّل متتالية الدوائر. أيّ دائرة تكمل السلسلة؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="15" cy="50" r="6" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="38" cy="50" r="11" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="68" cy="50" r="16" fill="none" stroke="#1d4ed8" stroke-width="2"/><text x="92" y="56" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"21\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"16\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"6\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"21\" fill=\"#1d4ed8\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية: نصف القطر يكبر بمقدار 5 في كل خطوة (6، 11، 16…). ✓ إذن التالي يساوي 21، أي الخيار a. الخيار b (16) يكرّر الدائرة الأخيرة بدل أن يزيد. الخيار c (6) يعود إلى الأولى تمامًا. الخيار d بالحجم الصحيح لكنه يصبح ممتلئًا: اللون لم يتغيّر قطّ في السلسلة، فلا يجوز اختراع قاعدة جديدة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b531524-c2ef-56c9-94c5-709a60d5b46d', '4b66b74d-6891-51d1-91d2-b0b83cd5eb8d', 'ثلاثة أشكال تتبع القاعدة نفسها، وواحد فقط هو الشاذ. أيّها؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="40" width="18" height="18" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/><rect x="32" y="40" width="18" height="18" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/><rect x="56" y="40" width="18" height="18" fill="none" stroke="#7c3aed" stroke-width="2"/><rect x="80" y="40" width="18" height="18" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">1</text></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">2</text></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">3</text></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">4</text></svg>"}]'::jsonb, 'c', 'القاعدة المشتركة: كل المربعات ممتلئة. ✓ المربع رقم 3 هو الوحيد الفارغ (مجرد إطار)، فهو الشاذ، أي الخيار c. الخيارات a وb وd تُظهر مربعات ممتلئة مطابقة للبقية: فهي تحترم القاعدة ولا يمكن أن تكون الشاذ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d9252da-8f60-5bf9-a50c-d7916c85bb9e', '4b66b74d-6891-51d1-91d2-b0b83cd5eb8d', 'إلى اليسار سهم نموذجي. اختر صورته في مرآة عمودية (يمين-يسار). <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><line x1="30" y1="50" x2="70" y2="50" stroke="#0f766e" stroke-width="4"/><polyline points="56,38 70,50 56,62" fill="none" stroke="#0f766e" stroke-width="4"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"56,38 70,50 56,62\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"70\" y1=\"50\" x2=\"30\" y2=\"50\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"44,38 30,50 44,62\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"70\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"38,56 50,70 62,56\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"70\" x2=\"50\" y2=\"30\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"38,44 50,30 62,44\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'b', 'المرآة العمودية تُبدّل اليمين واليسار: فالسهم المتّجه إلى اليمين يصبح متّجهًا إلى اليسار. ✓ إنه الخيار b. الخيار a مطابق للنموذج (لا انعكاس). الخياران c وd يتّجهان إلى الأسفل وإلى الأعلى: هذا دوران لا مرآة يمين-يسار.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3666759-2c0e-5140-8b95-0bfe3ae1d23e', '4b66b74d-6891-51d1-91d2-b0b83cd5eb8d', 'سهم واحد يدور ربع دورة في اتجاه عقارب الساعة في كل خطوة. ماذا يأتي بعد ذلك؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><g><line x1="12" y1="58" x2="12" y2="30" stroke="#b45309" stroke-width="4"/><polyline points="5,38 12,30 19,38" fill="none" stroke="#b45309" stroke-width="4"/></g><g><line x1="40" y1="44" x2="68" y2="44" stroke="#b45309" stroke-width="4"/><polyline points="60,37 68,44 60,51" fill="none" stroke="#b45309" stroke-width="4"/></g><text x="88" y="50" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"32\" x2=\"50\" y2=\"68\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"42,60 50,68 58,60\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"68\" y1=\"50\" x2=\"32\" y2=\"50\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"40,42 32,50 40,58\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"68\" x2=\"50\" y2=\"32\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"42,40 50,32 58,40\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"32\" y1=\"50\" x2=\"68\" y2=\"50\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"60,42 68,50 60,58\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'a', 'السهم يتّجه أولًا إلى الأعلى، ثم إلى اليمين: هذا ربع دورة في اتجاه عقارب الساعة. ✓ الخطوة التالية تعطي سهمًا إلى الأسفل، أي الخيار a. الخيار d (إلى اليمين) يكرّر الخطوة السابقة. الخيار b (إلى اليسار) يدور في الاتجاه الخاطئ. الخيار c (إلى الأعلى) يعود إلى نقطة البداية.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('affa95aa-7930-5fbd-ba22-e55099c21dbe', '4b66b74d-6891-51d1-91d2-b0b83cd5eb8d', 'تأمّل عدد أضلاع المضلّعات. أيّ شكل يكمل المتتالية؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="18,58 8,42 28,42" fill="none" stroke="#be123c" stroke-width="2"/><rect x="40" y="40" width="18" height="18" fill="none" stroke="#be123c" stroke-width="2"/><polygon points="78,38 88,46 84,58 72,58 68,46" fill="none" stroke="#be123c" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,32 64,42 59,58 41,58 36,42\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,32 62,39 62,53 50,60 38,53 38,39\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,33 58,58 38,42 62,42 42,58\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'القاعدة: عدد الأضلاع يزداد بمقدار 1 في كل خطوة — مثلث (3)، مربع (4)، خماسي (5). ✓ التالي يجب أن يكون له 6 أضلاع، أي السداسي في الخيار b. الخيار a خماسي (5 أضلاع)، فهو يكرّر الشكل السابق. الخيار c مربع (4 أضلاع)، سبق مروره. الخيار d نجمة خماسية الرؤوس: لقد عددنا الرؤوس بدل أضلاع المضلّع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('173f0008-f62a-587f-a504-4d8d8a5e96c6', 'c26001cd-28bd-5577-a31b-c8729b7790ef', 'iq-training-ar', '⭐ إحماء', 1, 50, 10, 'practice', 'admin', 1)
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
  ('ad7f1b0c-b854-5311-abbf-f6d5e76e2951', '173f0008-f62a-587f-a504-4d8d8a5e96c6', 'تأمّل المتتالية: عدد النقاط يزداد بمقدار 1 في كل خطوة. أيّ شكل يأتي بعد ذلك؟ <svg viewBox="0 0 100 100"><rect x="2" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2"/><circle cx="13" cy="50" r="4" fill="#222"/><rect x="27" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2"/><circle cx="33" cy="50" r="4" fill="#222"/><circle cx="43" cy="50" r="4" fill="#222"/><rect x="52" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2"/><circle cx="57" cy="50" r="4" fill="#222"/><circle cx="63" cy="50" r="4" fill="#222"/><circle cx="69" cy="50" r="4" fill="#222"/><rect x="77" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2" stroke-dasharray="3 3"/><text x="88" y="55" font-size="16" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"38\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"62\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"38\" r=\"5\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"38\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"62\" cy=\"50\" r=\"5\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"34\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"45\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"56\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"67\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"38\" r=\"5\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"42\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"58\" cy=\"50\" r=\"5\" fill=\"#222\"/></svg>"}]'::jsonb, 'a', 'القاعدة هي: +1 نقطة في كل خانة (1، ثم 2، ثم 3). فالخانة التالية يجب أن تحوي 4 نقاط ← الخيار a ✓. الفخّ: b يكرّر 3 نقاط (نسينا الإضافة)، وd يعود إلى نقطتين (نقرأ المتتالية بالمقلوب)، وc يضع 5 (قفزنا خطوة). نضيف نقطة واحدة فقط في كل خطوة، إذن 3 + 1 = 4.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ff27478-e345-5909-9aac-ec5e886adee7', '173f0008-f62a-587f-a504-4d8d8a5e96c6', 'السهم يدور ربع دورة (90°) في اتجاه عقارب الساعة في كل خطوة: أعلى، يمين، أسفل… ما هي الخطوة التالية؟ <svg viewBox="0 0 100 100"><g stroke="#222" stroke-width="3" fill="#222"><line x1="15" y1="62" x2="15" y2="38"/><polygon points="15,30 10,40 20,40"/></g><g stroke="#222" stroke-width="3" fill="#222"><line x1="38" y1="50" x2="62" y2="50"/><polygon points="70,50 60,45 60,55"/></g><g stroke="#222" stroke-width="3" fill="#222"><line x1="85" y1="38" x2="85" y2="62"/><polygon points="85,70 80,60 90,60"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"62\" x2=\"50\" y2=\"38\"/><polygon points=\"50,30 44,40 56,40\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\"/><polygon points=\"70,50 60,44 60,56\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"62\" y1=\"50\" x2=\"38\" y2=\"50\"/><polygon points=\"30,50 40,44 40,56\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"38\" x2=\"50\" y2=\"62\"/><polygon points=\"50,70 44,60 56,60\"/></g></svg>"}]'::jsonb, 'c', 'في كل خطوة يدور السهم 90° في اتجاه عقارب الساعة: أعلى ← يمين ← أسفل ← يسار. فبعد «أسفل» يأتي «يسار» ← الخيار c ✓. الفخّ: a (أعلى) وb (يمين) يرجعان إلى الوراء في المتتالية، وd (أسفل) يكرّر الخطوة السابقة. يجب مواصلة الدوران، لا إيقافه ولا عكسه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2fb4d08-dd2d-5af1-85c2-18aca908c70b', '173f0008-f62a-587f-a504-4d8d8a5e96c6', 'ثلاثة من هذه الأشكال تتبع القاعدة نفسها، وواحد فقط مختلف. ما هو الشاذ؟ <svg viewBox="0 0 100 100"><text x="50" y="55" font-size="12" text-anchor="middle" fill="#222">3 triangles + 1 carré</text><polygon points="50,15 40,30 60,30" fill="none" stroke="#222" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,25 30,70 70,70\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"25,70 50,25 75,70\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,30 70,40 45,72\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'القاعدة هي: كل شكل مثلث (3 أضلاع). الشاذ هو الخيار c ✓، فهو مربع (4 أضلاع). نعدّ الأضلاع: a وb وd لها 3، وحده c له 4. الفخّ أن ننظر إلى الحجم أو الاتجاه بدل عدد الأضلاع؛ هنا المربع هو الذي يخرق قاعدة «3 أضلاع».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a993414-e1a9-5482-ae20-4f2e307f88f5', '173f0008-f62a-587f-a504-4d8d8a5e96c6', 'المربع الأسود الصغير ينتقل من زاوية إلى أخرى في كل خطوة، في اتجاه عقارب الساعة. أين سيكون بعد ذلك؟ <svg viewBox="0 0 100 100"><rect x="4" y="38" width="24" height="24" fill="none" stroke="#222" stroke-width="2"/><rect x="6" y="40" width="7" height="7" fill="#222"/><rect x="38" y="38" width="24" height="24" fill="none" stroke="#222" stroke-width="2"/><rect x="53" y="40" width="7" height="7" fill="#222"/><rect x="72" y="38" width="24" height="24" fill="none" stroke="#222" stroke-width="2"/><rect x="87" y="53" width="7" height="7" fill="#222"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"32\" y=\"32\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"58\" y=\"32\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"58\" y=\"58\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"32\" y=\"58\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"}]'::jsonb, 'd', 'المربع الأسود يدور في اتجاه عقارب الساعة: أعلى-يسار ← أعلى-يمين ← أسفل-يمين ← أسفل-يسار. فبعد زاوية أسفل-يمين تأتي زاوية أسفل-يسار ← الخيار d ✓. الفخّ: c يكرّر أسفل-يمين (الخطوة السابقة)، وb (أعلى-يمين) وa (أعلى-يسار) يرجعان إلى الوراء. نواصل الدوران حتى الزاوية التالية.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29c9bad4-b7b0-582e-bce4-de5a5b55c60e', '173f0008-f62a-587f-a504-4d8d8a5e96c6', 'ثلاث دوائر تتبع القاعدة نفسها، وواحدة فقط مختلفة. ما هو الشاذ؟ <svg viewBox="0 0 100 100"><text x="50" y="45" font-size="11" text-anchor="middle" fill="#222">3 ronds pleins</text><text x="50" y="60" font-size="11" text-anchor="middle" fill="#222">+ 1 rond vide</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"48\" cy=\"50\" r=\"24\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"24\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"24\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"52\" cy=\"50\" r=\"24\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'القاعدة هي: كل دائرة ممتلئة (مملوءة بالأسود). الشاذ هو الخيار b ✓، وهو الدائرة الفارغة الوحيدة (مجرد إطار). a وc وd متطابقة وممتلئة؛ أما b فيخرق قاعدة الامتلاء. الفخّ أن نبحث عن فرق في الحجم أو الموضع: هنا كل الأحجام متساوية، والامتلاء هو ما يميّز b.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36fbeff0-7d40-50fe-afc7-19b976a14dca', '173f0008-f62a-587f-a504-4d8d8a5e96c6', 'تأمّل متتالية المضلّعات: عدد الأضلاع يزداد بمقدار 1 في كل خطوة (3، ثم 4، ثم 5…). أيّ شكل يأتي بعد ذلك؟ <svg viewBox="0 0 100 100"><polygon points="15,68 5,82 25,82" fill="none" stroke="#222" stroke-width="2"/><polygon points="33,30 51,30 51,48 33,48" fill="none" stroke="#222" stroke-width="2"/><polygon points="70,28 82,37 78,51 62,51 58,37" fill="none" stroke="#222" stroke-width="2"/><text x="50" y="92" font-size="10" text-anchor="middle" fill="#888">3 côtés, 4 côtés, 5 côtés, ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"32,32 68,32 68,68 32,68\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,20 73,33 73,60 50,73 27,60 27,33\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,22 71,37 63,62 37,62 29,37\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,20 70,30 75,52 62,70 38,70 25,52 30,30\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'b', 'القاعدة هي: +1 ضلع في كل خطوة (مثلث 3، مربع 4، خماسي 5…). فالمضلّع التالي يجب أن يكون له 6 أضلاع ← السداسي، الخيار b ✓. الفخّ: c خماسي (5 أضلاع، نسينا الإضافة)، وa مربع (4، رجوع إلى الوراء)، وd سباعي (7، قفزنا اثنين). نضيف ضلعًا واحدًا فقط، إذن 5 + 1 = 6.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('35a8b944-29ab-5137-9812-450c4fcf4733', 'c26001cd-28bd-5577-a31b-c8729b7790ef', 'iq-training-ar', '⚔️ تحدٍّ منطقي ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
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
  ('10c035c9-4cc3-5f6d-a719-14c648588cf3', '35a8b944-29ab-5137-9812-450c4fcf4733', 'السهم يدور ربع دورة (90°) في اتجاه عقارب الساعة في كل خطوة. أيّ سهم يأتي بعد ذلك؟ <svg viewBox="0 0 100 100"><line x1="15" y1="75" x2="15" y2="30" stroke="#1f2937" stroke-width="4"/><polygon points="8,38 22,38 15,24" fill="#1f2937"/><line x1="40" y1="50" x2="85" y2="50" stroke="#1f2937" stroke-width="4"/><polygon points="77,43 77,57 91,50" fill="#1f2937"/><line x1="60" y1="25" x2="60" y2="70" stroke="#1f2937" stroke-width="4"/><polygon points="53,62 67,62 60,76" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"75\" y1=\"50\" x2=\"30\" y2=\"50\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"38,42 38,58 22,50\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"25\" y1=\"50\" x2=\"70\" y2=\"50\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"62,42 62,58 78,50\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"75\" x2=\"50\" y2=\"30\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"42,38 58,38 50,22\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"42,62 58,62 50,78\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية: +90° في اتجاه عقارب الساعة في كل خطوة. أعلى ← يمين ← أسفل ← يسار. ✓ الخيار a يتّجه إلى اليسار: هذه هي المتابعة الصحيحة. الخيار d (إلى الأسفل) يكرّر الخطوة السابقة دون أن يدور. الخيار c (إلى الأعلى) يرجع إلى الوراء (دوران معاكس). الخيار b (إلى اليمين) يقفز خطوة. نصيحة: اتبع دائمًا اتجاه الدوران نفسه، دون قفز أو رجوع.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a022afa1-35fe-5a5e-90ca-9f3d92d0dd7f', '35a8b944-29ab-5137-9812-450c4fcf4733', 'A إلى B كما C إلى ؟ — تأمّل التحوّل بين الشكلين الأولين، ثم طبّقه. <svg viewBox="0 0 100 100"><rect x="8" y="38" width="16" height="16" fill="none" stroke="#1f2937" stroke-width="3"/><text x="32" y="52" font-size="12" fill="#1f2937">:</text><rect x="40" y="26" width="40" height="40" fill="none" stroke="#1f2937" stroke-width="3"/><text x="86" y="52" font-size="12" fill="#1f2937">::</text><circle cx="96" cy="46" r="3" fill="none" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"8\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"30\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"30\" fill=\"#1f2937\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'القاعدة الخفية: الشكل يكبر كثيرًا، مع بقاء الشكل والإطار كما هما (مربع صغير فارغ يصير مربعًا كبيرًا فارغًا). نطبّق التكبير نفسه على الدائرة الصغيرة الفارغة. ✓ الخيار c دائرة كبيرة فارغة: إنها المماثلة الصحيحة. الخيار b يحتفظ بالحجم الصغير (لا تحوّل). الخيار a يغيّر الشكل (مربع بدل دائرة). الخيار d يغيّر صفة اللون (دائرة ممتلئة)، وهذا ما لم يفعله التحوّل A←B. احتفظ بتحوّل واحد فقط: الحجم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b91f4ee-5d3f-5a57-a5b0-57c676842fb1', '35a8b944-29ab-5137-9812-450c4fcf4733', 'متتالية النقاط تكبر وفق قاعدة بسيطة. كم نقطة يجب أن يحتوي الشكل التالي؟ <svg viewBox="0 0 100 100"><rect x="4" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><circle cx="13" cy="49" r="3" fill="#1f2937"/><rect x="30" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><circle cx="37" cy="49" r="3" fill="#1f2937"/><circle cx="44" cy="49" r="3" fill="#1f2937"/><rect x="56" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><circle cx="61" cy="49" r="3" fill="#1f2937"/><circle cx="68" cy="49" r="3" fill="#1f2937"/><circle cx="65" cy="43" r="3" fill="#1f2937"/><rect x="82" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><text x="88" y="54" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"35\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"35\" cy=\"62\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"62\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'b', 'القاعدة الخفية: نضيف نقطة في كل خطوة (1، ثم 2، ثم 3…)، والفرق ثابت وهو +1. فالشكل التالي يجب أن يحتوي 4 نقاط. ✓ الخيار b يعرض 4 نقاط بالضبط: إنه الصحيح. الخيار a (3 نقاط) يكرّر الخطوة السابقة دون تقدّم. الخيار c (5 نقاط) يضيف نقطتين دفعة واحدة (فرق خاطئ). الخيار d (6 نقاط) يضاعف القفزة. عُدّ بدقّة: يجب الانتقال من 3 إلى 4، أي +1.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('433e21a6-e774-575c-91fa-fa9857067ab3', '35a8b944-29ab-5137-9812-450c4fcf4733', 'A إلى B كما C إلى ؟ — التحوّل تماثل (تأثير المرآة) يمين-يسار. أيّ شكل يكمل المماثلة؟ <svg viewBox="0 0 100 100"><polygon points="6,30 6,66 26,48" fill="#1f2937"/><text x="30" y="52" font-size="11" fill="#1f2937">:</text><polygon points="58,30 58,66 38,48" fill="#1f2937"/><text x="62" y="52" font-size="11" fill="#1f2937">::</text><polyline points="78,30 96,40 78,50" fill="none" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"38,30 62,50 38,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,38 50,62 70,38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,62 50,38 70,62\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"62,30 38,50 62,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"}]'::jsonb, 'd', 'القاعدة الخفية: تماثل مرآة يمين-يسار (الشكل ينقلب أفقيًا، كما في مرآة عمودية). علامة شيفرون تشير إلى اليمين ( > ) تصبح علامة تشير إلى اليسار ( < ). ✓ الخيار d هو المرآة الأفقية الدقيقة: إنه الصحيح. الخيار a مطابق لـ C (لم يُطبَّق أيّ تحوّل). الخياران b وc يطبّقان دورانًا بـ 90° (شيفرون إلى الأسفل أو إلى الأعلى) بدل مرآة يمين-يسار. ميّز جيدًا بين المرآة والدوران.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('299c6fc4-3e89-558f-9e97-ab66670ea532', '35a8b944-29ab-5137-9812-450c4fcf4733', 'مصفوفة 3×3: في كل سطر، عدد النقاط يزداد بمقدار 1 باتجاه اليمين (1، 2، 3). أيّ شكل يملأ الخانة الناقصة (أسفل اليمين)؟ <svg viewBox="0 0 100 100"><line x1="34" y1="4" x2="34" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="34" x2="96" y2="34" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#9ca3af" stroke-width="1"/><circle cx="19" cy="19" r="3" fill="#1f2937"/><circle cx="45" cy="19" r="3" fill="#1f2937"/><circle cx="55" cy="19" r="3" fill="#1f2937"/><circle cx="78" cy="19" r="3" fill="#1f2937"/><circle cx="84" cy="19" r="3" fill="#1f2937"/><circle cx="81" cy="13" r="3" fill="#1f2937"/><circle cx="19" cy="51" r="3" fill="#1f2937"/><circle cx="45" cy="51" r="3" fill="#1f2937"/><circle cx="55" cy="51" r="3" fill="#1f2937"/><circle cx="78" cy="51" r="3" fill="#1f2937"/><circle cx="84" cy="51" r="3" fill="#1f2937"/><circle cx="81" cy="45" r="3" fill="#1f2937"/><circle cx="19" cy="83" r="3" fill="#1f2937"/><circle cx="45" cy="83" r="3" fill="#1f2937"/><circle cx="55" cy="83" r="3" fill="#1f2937"/><text x="77" y="88" font-size="16" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"38\" cy=\"50\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"50\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"38\" cy=\"58\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"58\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"36\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"70\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"40\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'c', 'القاعدة الخفية: في كل سطر، الخانة الأولى فيها نقطة واحدة، والثانية فيها نقطتان، والثالثة فيها 3 نقاط. الخانة الناقصة هي الثالثة في السطر الأخير: إذن يجب أن تحوي 3 نقاط. ✓ الخيار c يُظهر 3 نقاط: إنه الصحيح. الخيار b (نقطتان) يكرّر العمود الأوسط. الخيار a (نقطة واحدة) يكرّر العمود الأول. الخيار d (4 نقاط) يتجاوز القاعدة (+1 زيادة). اقرأ المصفوفة سطرًا سطرًا لتثبّت الفرق الثابت: +1 لكل عمود.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7bdb2ac4-306c-556f-b22c-02938c4f2f94', '35a8b944-29ab-5137-9812-450c4fcf4733', 'العقرب يدور دائمًا 45° في اتجاه عقارب الساعة، حول نقطته المركزية. أيّ شكل يكمل المتتالية؟ <svg viewBox="0 0 100 100"><circle cx="17" cy="50" r="2.5" fill="#1f2937"/><line x1="17" y1="50" x2="17" y2="28" stroke="#1f2937" stroke-width="3"/><polygon points="17,24 12,33 22,33" fill="#1f2937"/><circle cx="50" cy="50" r="2.5" fill="#1f2937"/><line x1="50" y1="50" x2="66" y2="34" stroke="#1f2937" stroke-width="3"/><polygon points="69,31 58,34 65,41" fill="#1f2937"/><circle cx="83" cy="50" r="2.5" fill="#1f2937"/><line x1="83" y1="50" x2="95" y2="50" stroke="#1f2937" stroke-width="3"/><polygon points="99,50 90,45 90,55" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"70\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"75,75 62,72 72,62\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"50\" y2=\"75\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"50,80 44,68 56,68\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"70\" y2=\"30\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"75,25 62,28 72,38\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"30\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"25,75 28,62 38,72\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية: +45° في اتجاه عقارب الساعة في كل خطوة. العقرب يشير إلى الأعلى (90°)، ثم إلى أعلى-يمين (45°)، ثم إلى اليمين (0°)… فالخطوة التالية يجب أن تشير إلى أسفل-يمين. ✓ الخيار a يشير إلى أسفل-يمين: إنه المتابعة الصحيحة. الخيار c (أعلى-يمين) يرجع درجة إلى الوراء (دوران معاكس). الخيار b (إلى الأسفل) يقفز درجة 45°. الخيار d (أسفل-يسار) يذهب في الاتجاه الخاطئ (عكس عقارب الساعة). احتفظ بخطوة ثابتة 45°، دائمًا في الاتجاه نفسه مع عقارب الساعة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('612f2e23-198b-52b7-9574-7910602ace5a', 'c26001cd-28bd-5577-a31b-c8729b7790ef', 'iq-training-ar', '👑 نخبة الذكاء ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('3cadfe49-f91c-5e25-a168-38377d42fa74', '612f2e23-198b-52b7-9574-7910602ace5a', 'إليك شكلًا والمحور العمودي المنقّط إلى يمينه. أيّ خيار هو صورته بالانعكاس في هذه المرآة العمودية (يمين-يسار)؟ <svg viewBox="0 0 100 100"><polyline points="30,20 30,80 70,80" fill="none" stroke="#1e293b" stroke-width="6"/><circle cx="30" cy="20" r="7" fill="#ef4444" stroke="#1e293b" stroke-width="2"/><line x1="88" y1="10" x2="88" y2="90" stroke="#64748b" stroke-width="2" stroke-dasharray="4 4"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,20 30,80 70,80\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"20\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,20 70,80 30,80\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"70\" cy=\"20\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,80 30,20 70,20\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"80\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,80 70,20 30,20\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"70\" cy=\"80\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'القاعدة الخفية: الانعكاس العمودي (مرآة يمين-يسار) يقلب المحور الأفقي ويحافظ على المحور العمودي. الشكل على هيئة حرف L زاويته في الأسفل إلى اليسار والكرة الحمراء في الأعلى إلى اليسار؛ بعد المرآة تنتقل الزاوية إلى الأسفل يمينًا وتبقى الكرة في الأعلى، يمينًا. ✓ الخيار b. فخّ a: إنه الشكل الأصلي دون تغيير (لا مرآة). فخّ c: إنه قلب أعلى-أسفل، لا يمين-يسار (الكرة ستنزل). فخّ d: إنه دوران بـ 180°، يقلب المحورين معًا في آنٍ واحد.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ec5669c-7a22-5e48-ab75-693fb4232a42', '612f2e23-198b-52b7-9574-7910602ace5a', 'هذا الدَّرَج مبنيّ بمكعّبات متماثلة. مع عدّ المكعّبات المخفية وراءها أيضًا، كم عدد المكعّبات الإجمالي الذي يتألّف منه؟ <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="1.5" fill="#cbd5e1"><rect x="20" y="70" width="18" height="18"/><rect x="38" y="70" width="18" height="18"/><rect x="56" y="70" width="18" height="18"/><rect x="20" y="52" width="18" height="18"/><rect x="38" y="52" width="18" height="18"/><rect x="20" y="34" width="18" height="18"/></g><text x="50" y="24" font-size="10" text-anchor="middle" fill="#1e293b">profondeur 1</text></svg>', '[{"id":"a","text":"5"},{"id":"b","text":"9"},{"id":"c","text":"6"},{"id":"d","text":"10"}]'::jsonb, 'c', 'القاعدة: نجمع المكعّبات عمودًا عمودًا، والعمق 1 (لا شيء مخفيًّا وراءها، كما هو مبيّن). العمود الأيسر = 3 مكعّبات مكدّسة، العمود الأوسط = 2، العمود الأيمن = 1. المجموع = 3 + 2 + 1 = 6. ✓ الخيار c. فخّ a (5): نسينا مكعّبًا من أحد الأعمدة. فخّ b (9): افترضنا مربّعًا 3×3 ممتلئًا في حين أنه دَرَج. فخّ d (10): أضفنا طبقة مخفية وراءها، لكنّ العمق هو 1.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2eed1404-5ae5-5e69-b0a7-afe472749347', '612f2e23-198b-52b7-9574-7910602ace5a', 'واحد فقط من هذه النماذج (المفرودة) يمكن طيّه إلى مكعّب مغلق، دون وجه ناقص ولا وجه يتراكب. أيّها؟ <svg viewBox="0 0 100 100"><text x="50" y="50" font-size="11" text-anchor="middle" fill="#1e293b">6 carrés = patron du cube</text><text x="50" y="66" font-size="11" text-anchor="middle" fill="#1e293b">Lequel se replie ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"40\" y=\"10\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"30\" width=\"20\" height=\"20\"/><rect x=\"20\" y=\"50\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"50\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"50\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"70\" width=\"20\" height=\"20\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"20\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"20\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"60\" width=\"20\" height=\"20\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"15\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"35\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"55\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"75\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"15\" y=\"60\" width=\"20\" height=\"20\"/><rect x=\"35\" y=\"60\" width=\"20\" height=\"20\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"20\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"20\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"40\" width=\"20\" height=\"20\"/></g></svg>"}]'::jsonb, 'a', 'القاعدة: نموذج المكعّب الصالح له 6 مربعات موزّعة بحيث لا يتراكب أيّ منها عند الطيّ؛ والكلاسيكي الشهير هو الصليب (مربع مركزي مع مربع على كل جانب + مربع امتدادًا). الخيار a هو هذا الصليب على شكل حرف T مطوّل: عمود من 4 مربعات مع مربعين على جانبي المربع الثالث — يُطوى بإحكام تام. ✓ الخيار a. فخّ b: يشكّل كتلة 2×2 مع مربعين على شكل دَرَج؛ عند الطيّ يتراكب وجهان وينقص واحد. فخّ d: إنه مستطيل 3×2 ممتلئ، يُطوى إلى علبة مفتوحة (وجهان يتراكبان، لا مكعّب مغلق). فخّ c: تشكيل 4+2 حيث المربعان السفليان في غير موضعهما، فيقع وجهان في المكان نفسه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa6aa5f3-333d-5174-b018-912ba2cd3ba4', '612f2e23-198b-52b7-9574-7910602ace5a', 'نُطابق تمامًا الشكلين على اليسار (المركز نفسه)، الخطوط السوداء فوق الخطوط السوداء. أيّ خيار يُظهر نتيجة هذا التراكب؟ <svg viewBox="0 0 100 100"><g fill="none" stroke="#1e293b" stroke-width="4"><rect x="12" y="30" width="34" height="34"/></g><text x="55" y="50" font-size="16" text-anchor="middle" fill="#1e293b">+</text><g fill="none" stroke="#1e293b" stroke-width="4"><line x1="66" y1="30" x2="94" y2="58"/><line x1="94" y1="30" x2="66" y2="58"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"22\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"34\" y1=\"34\" x2=\"66\" y2=\"66\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"66\" y1=\"34\" x2=\"34\" y2=\"66\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"70\" y1=\"30\" x2=\"30\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'd', 'القاعدة: التراكب يحتفظ بجميع خطوط الشكلين، دون إضافة أو حذف. لدينا مربع وعلامة X (قطران)؛ فالنتيجة هي المربع تخترقه قطراه مشكّلين علامة X. ✓ الخيار d. فخّ a: إنه المربع وحده، نسينا العلامة. فخّ c: قطر واحد فقط، أضعنا نصف الـ X. فخّ b: استبدلنا المربع بدائرة، في حين أن التراكب لا يحوّل أبدًا شكلًا إلى آخر.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3f02429-df24-5a85-bfea-588d959b2c94', '612f2e23-198b-52b7-9574-7910602ace5a', 'التحوّل A ← B، طبّق التحوّل نفسه على C لإيجاد النتيجة. A←B: السهم يدور 90° في اتجاه عقارب الساعة وتظهر نقطة سوداء. <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="10" y1="50" x2="34" y2="50"/><polyline points="28,44 34,50 28,56"/></g><text x="42" y="54" font-size="12" fill="#1e293b">→</text><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="58" y1="34" x2="58" y2="58"/><polyline points="52,52 58,58 64,52"/></g><circle cx="78" cy="40" r="4" fill="#1e293b"/><text x="50" y="82" font-size="11" text-anchor="middle" fill="#1e293b">C : flèche vers le bas, sans point</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><polyline points=\"62,42 70,50 62,58\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><polyline points=\"38,42 30,50 38,58\"/></g><circle cx=\"78\" cy=\"24\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"70\"/><polyline points=\"42,38 50,30 58,38\"/></g><circle cx=\"78\" cy=\"24\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><polyline points=\"62,42 70,50 62,58\"/></g><circle cx=\"78\" cy=\"24\" r=\"5\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'b', 'القاعدة: دوران بـ 90° في اتجاه عقارب الساعة + إضافة نقطة. C يشير إلى الأسفل؛ بعد ربع دورة مع عقارب الساعة، يتّجه الأسفل نحو اليسار، فيشير السهم إلى اليسار، ونضيف النقطة. ✓ الخيار b (سهم إلى اليسار + نقطة). فخّ c: نسينا الدوران (السهم لا يزال عموديًّا) مع إضافة النقطة. فخّ d: دوران مع عقارب الساعة لكنّ السهم إلى اليمين — هذا خطأ في الاتجاه (الأسفل الذي يدور مع عقارب الساعة لا يذهب إلى اليمين). فخّ a: سهم إلى اليمين والنقطة منسيّة، خطآن مجتمعان.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59181ea7-ea56-562e-988f-055b40dad562', '612f2e23-198b-52b7-9574-7910602ace5a', 'النقش يدور ربع دورة (90°) في كل خانة، دائمًا في الاتجاه نفسه. بملاحظة التدرّج، أيّ شكل يحتلّ الخانة ذات «؟» <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="3" fill="none"><rect x="4" y="35" width="28" height="28"/><line x1="18" y1="49" x2="30" y2="49"/><rect x="36" y="35" width="28" height="28"/><line x1="50" y1="49" x2="50" y2="61"/><rect x="68" y="35" width="28" height="28"/><line x1="82" y1="49" x2="70" y2="49"/></g><text x="82" y="82" font-size="14" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"70\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"30\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"50\" y2=\"30\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"50\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'c', 'القاعدة: العقرب المنطلق من المركز يدور 90° في اتجاه عقارب الساعة في كل خانة. الخانة 1: العقرب إلى اليمين. الخانة 2: ربع دورة مع عقارب الساعة ← إلى الأسفل. الخانة 3: ربع آخر ← إلى اليسار. الخانة 4 (الـ؟): ربع أخير ← إلى الأعلى. ✓ الخيار c (العقرب إلى الأعلى). فخّ a: رجوع إلى اليمين، كأننا نعود إلى البداية بدل المتابعة. فخّ d: العقرب إلى الأسفل، قفزنا خطوة دوران. فخّ b: العقرب إلى اليسار، كرّرنا الخانة 3 دون أن ندور.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f8487b44-051f-5e1a-b1cf-d7d9eae4c408', 'f1fe9612-e645-526d-bc44-3fa7363d066d', 'iq-training-ar', 'إحماء المنطق ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('6e9c6712-9ff0-5a18-b23a-83e157200471', 'f8487b44-051f-5e1a-b1cf-d7d9eae4c408', 'مصفوفة 3×3: في كل سطر، يزداد عدد النقاط بمقدار 1 كلما اتجهنا نحو اليمين. أي شكل يحل محل علامة «؟» <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><line x1="35" y1="4" x2="35" y2="96" stroke="#94a3b8" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#94a3b8" stroke-width="1"/><line x1="4" y1="35" x2="96" y2="35" stroke="#94a3b8" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#94a3b8" stroke-width="1"/><circle cx="19" cy="19" r="3" fill="#1d4ed8"/><circle cx="44" cy="19" r="3" fill="#1d4ed8"/><circle cx="56" cy="19" r="3" fill="#1d4ed8"/><circle cx="75" cy="19" r="3" fill="#1d4ed8"/><circle cx="81" cy="19" r="3" fill="#1d4ed8"/><circle cx="87" cy="19" r="3" fill="#1d4ed8"/><circle cx="19" cy="50" r="3" fill="#1d4ed8"/><circle cx="44" cy="50" r="3" fill="#1d4ed8"/><circle cx="56" cy="50" r="3" fill="#1d4ed8"/><circle cx="75" cy="50" r="3" fill="#1d4ed8"/><circle cx="81" cy="50" r="3" fill="#1d4ed8"/><circle cx="87" cy="50" r="3" fill="#1d4ed8"/><circle cx="19" cy="81" r="3" fill="#1d4ed8"/><circle cx="44" cy="81" r="3" fill="#1d4ed8"/><circle cx="56" cy="81" r="3" fill="#1d4ed8"/><text x="81" y="86" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"32\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"68\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"41\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"59\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"26\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"42\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"58\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"74\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية: في كل سطر يكون عدد النقاط 1 ثم 2 ثم 3 (العمود الأيسر = 1، العمود الأوسط = 2، العمود الأيمن = 3). ✓ الخانة الناقصة في الأسفل إلى اليمين، فيجب أن تحتوي على 3 نقاط: إنه الخيار a. الخيار b (نقطتان) ينسخ العمود الأوسط. الخيار c (نقطة واحدة) ينسخ العمود الأيسر. الخيار d (4 نقاط) يمدّد المتتالية درجة زائدة: السطر يتوقف عند 3.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('304717c4-0c7f-5e4e-bc43-01be6c1e6d85', 'f8487b44-051f-5e1a-b1cf-d7d9eae4c408', 'لاحظ متتالية المربعات: يتغير حجمها وفق قاعدة منتظمة. أي مربع يأتي بعد ذلك؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="44" width="12" height="12" fill="none" stroke="#7c3aed" stroke-width="2"/><rect x="30" y="40" width="20" height="20" fill="none" stroke="#7c3aed" stroke-width="2"/><rect x="58" y="36" width="28" height="28" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="94" y="55" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"32\" y=\"32\" width=\"36\" height=\"36\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"36\" y=\"36\" width=\"28\" height=\"28\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"44\" y=\"44\" width=\"12\" height=\"12\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"32\" y=\"32\" width=\"36\" height=\"36\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'القاعدة: يزداد ضلع المربع بمقدار 8 في كل مرحلة (12، 20، 28…). ✓ فيكون المربع التالي طول ضلعه 36، فارغًا مثل البقية: إنه الخيار a. الخيار b (28) ينسخ المربع الأخير بدل تكبيره. الخيار c (12) يعود إلى المربع الأول تمامًا. الخيار d له الحجم الصحيح لكنه أصبح مملوءًا: اللون لم يتغير قط في المتتالية، فلا داعي لاختراع قاعدة جديدة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('748b6bc5-2d55-5dde-9e5d-7f09bf22a285', 'f8487b44-051f-5e1a-b1cf-d7d9eae4c408', 'تناظر: نسبة الدائرة إلى المثلث كنسبة المربع إلى…؟ على اليسار النموذج (دائرة ← مثلث): نستبدل الشكل بآخر له ضلع إضافي. طبّق التحويل نفسه على المربع. <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="16" cy="30" r="10" fill="none" stroke="#0f766e" stroke-width="2"/><text x="34" y="35" font-size="12" fill="#64748b" text-anchor="middle">→</text><polygon points="52,22 44,38 60,38" fill="none" stroke="#0f766e" stroke-width="2"/><rect x="8" y="66" width="18" height="18" fill="none" stroke="#0f766e" stroke-width="2"/><text x="40" y="79" font-size="12" fill="#64748b" text-anchor="middle">→</text><text x="66" y="80" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,28 64,40 58,58 42,58 36,40\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,30 60,42 50,54 40,42\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,30 42,46 58,46\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,28 60,34 60,46 50,52 40,46 40,34\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'تحويل النموذج: ننتقل من شكل إلى آخر له ضلع إضافي. الدائرة (تُعدّ كأنها بلا أضلاع مستقيمة) تصير مثلثًا (3 أضلاع)… لكن القاعدة الواضحة فعلًا هي «+1 ضلع» المطبّقة على المربع. للمربع 4 أضلاع، فيجب أن يصير مخمّسًا، أي 5 أضلاع. ✓ إنه الخيار a. الخيار b معيّن (4 أضلاع): العدد نفسه من أضلاع المربع، أي لا تحويل. الخيار c مثلث (3 أضلاع): ضلع أقل. الخيار d مسدّس (6 أضلاع): ضلعان إضافيان، أُضيف 2 بدل 1.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('600882c8-4f33-54d7-8566-afc5e5562613', 'f8487b44-051f-5e1a-b1cf-d7d9eae4c408', 'ثلاثة أشكال تشترك في القاعدة نفسها، واحد فقط هو الدخيل. أيها؟ (تلميح: عُدّ عدد الأضلاع.) <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="18,58 8,42 28,42" fill="none" stroke="#be123c" stroke-width="2"/><rect x="40" y="40" width="18" height="18" fill="none" stroke="#be123c" stroke-width="2"/><polygon points="78,40 88,48 84,60 72,60 68,48" fill="none" stroke="#be123c" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,28 42,44 58,44\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">1</text></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"40\" y=\"30\" width=\"20\" height=\"20\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">2</text></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"40\" r=\"11\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">3</text></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,28 60,36 56,48 44,48 40,36\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">4</text></svg>"}]'::jsonb, 'c', 'القاعدة المشتركة: كل هذه الأشكال مضلّعات، أي مكوّنة من أضلاع مستقيمة (مثلث، مربع، مخمّس). ✓ الدائرة في الخيار c ليس لها أي ضلع مستقيم: فهي الوحيدة التي ليست مضلّعًا، وبالتالي هي الدخيل. الخيار a (مثلث، 3 أضلاع) والخيار b (مربع، 4 أضلاع) والخيار d (مخمّس، 5 أضلاع) كلها تحترم قاعدة «رسم بأضلاع مستقيمة» فلا يمكن أن تكون الدخيل.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c9b8464-f218-54ae-8997-e0df065a23cd', 'f8487b44-051f-5e1a-b1cf-d7d9eae4c408', 'استنتاج: قاعدة — كل الأشكال الزرقاء دوائر. على البطاقة ترى شكلًا أزرق، لكن صورته مخفية تحت حجاب رمادي. أي من هذه الاقتراحات صحيح حتمًا؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="4" y="4" width="92" height="92" rx="6" fill="none" stroke="#94a3b8" stroke-width="2"/><rect x="32" y="32" width="36" height="36" rx="4" fill="#9ca3af" stroke="#6b7280" stroke-width="2"/><text x="50" y="55" font-size="22" fill="#374151" text-anchor="middle">?</text><text x="50" y="88" font-size="10" fill="#2563eb" text-anchor="middle">figure bleue</text></svg>', '[{"id":"a","text":"إنه دائرة حتمًا."},{"id":"b","text":"إنه مربع حتمًا."},{"id":"c","text":"قد يكون أي شكل، لا يمكننا قول شيء."},{"id":"d","text":"إنه مثلث حتمًا."}]'::jsonb, 'a', 'تقول القاعدة: «كل شكل أزرق دائرة.» الشكل المخفي أزرق، إذن ينطبق عليه الحكم: فهو دائرة حتمًا. ✓ إنه الخيار a. الخيار c ينسى أننا نعرف لونه أصلًا: القاعدة تنطبق وتسمح بالاستنتاج. الخيار b والخيار d يخترعان شكلًا تمنعه القاعدة عن أي شكل أزرق. حيلة: «إذا أزرق فدائرة» + «هو أزرق» ⇐ «هو دائرة» (استنتاج مباشر).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4212a2ce-dc73-58c6-b7f9-711137cc2f4e', 'f1fe9612-e645-526d-bc44-3fa7363d066d', 'iq-training-ar', '⭐ الإحماء', 1, 50, 10, 'practice', 'admin', 1)
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
  ('44370ec7-aff6-5e2d-a033-e4fbf597a7f6', '4212a2ce-dc73-58c6-b7f9-711137cc2f4e', 'في هذه الشبكة 3×3، عدد النقاط في كل خانة يساوي رقم سطرها (السطر 1 = نقطة واحدة، السطر 2 = نقطتان، السطر 3 = 3 نقاط). أي شكل يكمل الخانة المعلَّمة بـ«؟» <svg viewBox="0 0 100 100"><g fill="none" stroke="#222" stroke-width="1.5"><rect x="6" y="6" width="88" height="88"/><line x1="35" y1="6" x2="35" y2="94"/><line x1="65" y1="6" x2="65" y2="94"/><line x1="6" y1="35" x2="94" y2="35"/><line x1="6" y1="65" x2="94" y2="65"/></g><g fill="#222"><circle cx="20" cy="20" r="3.5"/><circle cx="50" cy="20" r="3.5"/><circle cx="80" cy="20" r="3.5"/><circle cx="15" cy="50" r="3.5"/><circle cx="25" cy="50" r="3.5"/><circle cx="45" cy="50" r="3.5"/><circle cx="55" cy="50" r="3.5"/><circle cx="75" cy="50" r="3.5"/><circle cx="85" cy="50" r="3.5"/><circle cx="14" cy="80" r="3.5"/><circle cx="20" cy="80" r="3.5"/><circle cx="26" cy="80" r="3.5"/><circle cx="44" cy="80" r="3.5"/><circle cx="50" cy="80" r="3.5"/><circle cx="56" cy="80" r="3.5"/></g><text x="80" y="85" font-size="16" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"15\" y=\"15\" width=\"70\" height=\"70\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"50\" cy=\"50\" r=\"6\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"15\" y=\"15\" width=\"70\" height=\"70\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"38\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"62\" cy=\"50\" r=\"6\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"15\" y=\"15\" width=\"70\" height=\"70\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"50\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"68\" cy=\"50\" r=\"6\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"15\" y=\"15\" width=\"70\" height=\"70\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"28\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"43\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"58\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"73\" cy=\"50\" r=\"6\" fill=\"#222\"/></svg>"}]'::jsonb, 'c', 'قاعدة الشبكة هي: عدد النقاط = رقم السطر. الخانة «؟» في السطر الثالث (حيث توجد بالفعل خانات بثلاث نقاط)، فيجب أن تحتوي على 3 نقاط ← الخيار c ✓. الفخّ: b يضع نقطتين (نقرأ رقم العمود بدل السطر)، a يضع نقطة واحدة (نخلط مع السطر الأول)، و d يضع 4 نقاط (أضفنا نقطة زائدة). نطبّق قاعدة السطر: السطر الثالث = 3 نقاط.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dfcda654-4a8e-57b8-891c-94bc6f9afd3e', '4212a2ce-dc73-58c6-b7f9-711137cc2f4e', 'لاحظ متتالية الأعداد: 2، 5، 8، 11، ؟ — يزداد كل حدّ دائمًا بالخطوة نفسها. أي عدد يأتي بعد ذلك؟', '[{"id":"a","text":"12"},{"id":"b","text":"13"},{"id":"c","text":"14"},{"id":"d","text":"15"}]'::jsonb, 'c', 'القاعدة هي: نضيف 3 في كل مرحلة (2 ← 5 ← 8 ← 11). فبعد 11 يأتي 11 + 3 = 14 ← الخيار c ✓. الفخّ: 12 يضيف 1 فقط (نسينا الخطوة الحقيقية)، 13 يضيف 2 (خطوة خاطئة)، و15 يضيف 4 (خطوة زائدة). نقيس الفرق بين حدّين متجاورين (دائمًا 3+) ونعيد إنتاجه: 11 + 3 = 14.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb4a68da-19dc-5159-9b9a-d76e8d75f60f', '4212a2ce-dc73-58c6-b7f9-711137cc2f4e', 'تناظر: يتحول الشكل على اليسار إلى الشكل على اليمين بنصف دورة (دوران 180°). طبّق التحويل نفسه على الشكل الثالث لإيجاد الجواب. <svg viewBox="0 0 100 100"><polygon points="15,15 15,40 35,27" fill="#222"/><text x="45" y="30" font-size="12" fill="#222">→</text><polygon points="85,15 85,40 65,27" fill="#222"/><text x="30" y="72" font-size="12" fill="#222">L''Éclair monte ↑, puis ?</text><polygon points="50,55 70,55 60,40" fill="#c33"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,45 60,45 50,60\" fill=\"#c33\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,60 60,60 50,45\" fill=\"#c33\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,40 55,50 40,60\" fill=\"#c33\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"60,40 60,60 40,50\" fill=\"#c33\"/></svg>"}]'::jsonb, 'a', 'التحويل هو نصف دورة (180°): السهم الممتلئ المتجه نحو اليمين يصير سهمًا متجهًا نحو اليسار. المثلث الأحمر يشير إلى الأعلى؛ وبعد نصف دورة يجب أن يشير إلى الأسفل ← الخيار a ✓. الفخّ: b ما زال يشير إلى الأعلى (لا دوران)، c يشير إلى اليمين و d إلى اليسار (دوران 90° بدل 180°). نصف الدورة يعكس الاتجاه تمامًا: أعلى ← أسفل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cabc5ae3-2aee-5ea1-839f-0eeffa90165b', '4212a2ce-dc73-58c6-b7f9-711137cc2f4e', 'ثلاثة من هذه الأسهم تشير في الاتجاه نفسه، واحد فقط مختلف. ما هو الدخيل؟ <svg viewBox="0 0 100 100"><text x="50" y="45" font-size="11" text-anchor="middle" fill="#222">Même direction</text><text x="50" y="60" font-size="11" text-anchor="middle" fill="#222">pour 3 flèches sur 4</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"70\" x2=\"50\" y2=\"38\"/><polygon points=\"50,28 42,42 58,42\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"62\"/><polygon points=\"50,72 42,58 58,58\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"72\" x2=\"50\" y2=\"40\"/><polygon points=\"50,30 42,44 58,44\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"68\" x2=\"50\" y2=\"36\"/><polygon points=\"50,26 42,40 58,40\"/></g></svg>"}]'::jsonb, 'b', 'القاعدة هي: كل سهم يشير إلى الأعلى. الدخيل هو الخيار b ✓، الوحيد الذي يشير إلى الأسفل (رأسه في الأسفل). ننظر فقط إلى موضع رأس السهم: a و c و d رؤوسها في الأعلى، وحده b رأسه في الأسفل. الفخّ هو مقارنة طول الخطوط أو موضعها؛ هنا يهمّ اتجاه الرأس فقط.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb58bce7-2a97-5635-8e93-bd46b7fd3426', '4212a2ce-dc73-58c6-b7f9-711137cc2f4e', 'استنتاج: «كل الزوغات تضع قبعة.» نلاحظ مخلوقًا لا يضع قبعة. ماذا يمكن أن نستنتج بيقين؟', '[{"id":"a","text":"هذا المخلوق زوغ."},{"id":"b","text":"هذا المخلوق ليس زوغًا."},{"id":"c","text":"كل من يضع قبعة هو زوغ."},{"id":"d","text":"لا أحد من المخلوقات يضع قبعة."}]'::jsonb, 'b', 'تقول القاعدة إن كل زوغ يضع قبعة. إذن مخلوق بلا قبعة لا يمكن أن يكون زوغًا (وإلا لكان يضعها) ← الخيار b ✓. الفخّ: a يناقض المشاهدة مباشرة؛ c يعكس القاعدة («كل زوغ له قبعة» لا يعني «كل قبعة لزوغ»)؛ d يخترع تأكيدًا لا علاقة له بشيء. نطبّق القاعدة بنقيضها: لا قبعة ⇐ ليس زوغًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bf1054a5-a38a-5fa0-9c52-1c88bd25e604', '4212a2ce-dc73-58c6-b7f9-711137cc2f4e', 'تناظر: يتحول الشكل على اليسار إلى الشكل على اليمين بأن يمتلئ باللون الأسود. طبّق القاعدة نفسها على الشكل الثالث. <svg viewBox="0 0 100 100"><circle cx="22" cy="28" r="14" fill="none" stroke="#222" stroke-width="3"/><text x="42" y="32" font-size="12" fill="#222">→</text><circle cx="78" cy="28" r="14" fill="#222" stroke="#222" stroke-width="2"/><rect x="36" y="60" width="28" height="28" fill="none" stroke="#222" stroke-width="3"/><text x="50" y="98" font-size="9" text-anchor="middle" fill="#888">carré vide → ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"32\" y=\"32\" width=\"36\" height=\"36\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"32\" y=\"32\" width=\"36\" height=\"36\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'التحويل لا يغيّر الشكل: إنه يملأ داخله باللون الأسود فقط (الدائرة الفارغة تصير دائرة ممتلئة). فيجب أن يصير المربع الفارغ مربعًا ممتلئًا ← الخيار c ✓. الفخّ: a يُبقي المربع فارغًا (نسينا أن نملأه)، d يصغّره (غيّرنا الحجم لا الملء)، و b يغيّر الشكل إلى دائرة (القاعدة تعمل على الملء لا على الشكل). نطبّق «الملء بالأسود» فقط مع الإبقاء على المربع.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6f0e4817-1517-590d-8089-bafe582124ed', 'f1fe9612-e645-526d-bc44-3fa7363d066d', 'iq-training-ar', '⚔️ تحدّي المنطق ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
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
  ('39beb47d-995d-5161-ae74-2683320ebb90', '6f0e4817-1517-590d-8089-bafe582124ed', 'متتالية أعداد: يُحصل على كل حدّ بإضافة الفرق نفسه دائمًا إلى سابقه. أي عدد يحل محل علامة ؟ <svg viewBox="0 0 100 100"><line x1="4" y1="60" x2="96" y2="60" stroke="#9ca3af" stroke-width="1.5"/><circle cx="14" cy="60" r="2" fill="#1f2937"/><circle cx="34" cy="60" r="2" fill="#1f2937"/><circle cx="54" cy="60" r="2" fill="#1f2937"/><circle cx="74" cy="60" r="2" fill="#1f2937"/><circle cx="90" cy="60" r="2" fill="#1f2937"/><text x="11" y="50" font-size="11" fill="#1f2937">2</text><text x="31" y="50" font-size="11" fill="#1f2937">5</text><text x="51" y="50" font-size="11" fill="#1f2937">8</text><text x="69" y="50" font-size="11" fill="#1f2937">11</text><text x="87" y="50" font-size="13" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"13"},{"id":"b","text":"14"},{"id":"c","text":"15"},{"id":"d","text":"16"}]'::jsonb, 'b', 'القاعدة الخفية: الفرق ثابت، 3+ في كل خطوة (2 ← 5 ← 8 ← 11). بعد 11 نضيف 3 مرة أخرى: 11 + 3 = 14. ✓ الخيار b (14) يحترم الفرق 3+: فهو الصحيح. الخيار a (13) يضيف 2+ فقط (فرق خاطئ). الخيار c (15) يضيف 4+ (واحد زائد). الخيار d (16) يقفز خطوتين (5+). حدّد أولًا الفرق بين حدّين متجاورين، ثم طبّقه كما هو.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4cc56ac-63da-5456-8bf9-feb0bc54e80c', '6f0e4817-1517-590d-8089-bafe582124ed', 'ثلاثة من هذه الأشكال تشترك في خاصية واحدة، وواحد فقط يكسرها: أيها الدخيل؟ لاحظ إن كان المحيط مغلقًا أم مفتوحًا. <svg viewBox="0 0 100 100"><text x="6" y="80" font-size="9" fill="#6b7280">Contour : fermé = boucle complète ; ouvert = ligne brisée non refermée.</text><line x1="6" y1="30" x2="94" y2="30" stroke="#9ca3af" stroke-width="1"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,72 50,30 70,72\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,30 30,70 70,70 70,30\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"22\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'c', 'القاعدة الخفية: هل المحيط مغلق (يعود الخط إلى نقطة انطلاقه) أم مفتوح؟ المثلث (a) والمربع (b) والدائرة (d) محيطات مغلقة: الحلقة كاملة. الخيار c يرسم ثلاثة أضلاع لمربع لكنه يترك الأعلى مفتوحًا: الخط لا ينغلق. ✓ الدخيل هو c: فهو الشكل الوحيد ذو المحيط المفتوح. الفخّ: الخلط بين c ومربع مثل b — يتشابهان، لكن b مغلق بينما c له فتحة في الأعلى. تتبّع الرسم بإصبعك: إن عاد إلى البداية فالمحيط مغلق.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('571581fd-3c5e-5f0d-95a9-4faf6d951a36', '6f0e4817-1517-590d-8089-bafe582124ed', 'نسبة A إلى B كنسبة C إلى ؟ — لاحظ التحويل بين الشكلين الأولين (دوران)، ثم طبّقه على C. <svg viewBox="0 0 100 100"><polygon points="6,30 6,60 24,45" fill="#1f2937"/><text x="28" y="50" font-size="11" fill="#1f2937">:</text><polygon points="38,30 68,30 53,48" fill="#1f2937"/><text x="72" y="50" font-size="11" fill="#1f2937">::</text><polyline points="82,32 96,40 82,48" fill="none" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"38,30 62,50 38,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,38 50,62 70,38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,62 50,38 70,62\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"62,30 38,50 62,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"}]'::jsonb, 'b', 'القاعدة الخفية: دوران بمقدار 90° في اتجاه عقارب الساعة. المثلث الممتلئ المتجه نحو اليمين (A) يصير مثلثًا متجهًا نحو الأسفل (B): إنه فعلًا ربع دورة مع عقارب الساعة. نطبّق ربع الدورة نفسه مع عقارب الساعة على الزاوية المنكسرة في C، التي تشير نحو اليمين ( < ): فيجب أن تشير نحو الأسفل ( v ). ✓ الخيار b هو الزاوية المتجهة نحو الأسفل: فهو الصحيح. الخيار d يشير نحو اليسار (دوران 180°، درجتان). الخيار c يشير نحو الأعلى (دوران عكس عقارب الساعة، اتجاه خاطئ). الخيار a مطابق لـ C (لا دوران). تحقّق من الاتجاه ومن المقدار معًا: ربع دورة واحد مع عقارب الساعة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9249d31-3cce-5436-8866-c4a454b75e64', '6f0e4817-1517-590d-8089-bafe582124ed', 'استنتاج منطقي. نعلم: «كل الغلومات فروكات» و«لا فروك أزرق». بما أن بيم غلوم، ماذا يمكن أن نستنتج بيقين؟ <svg viewBox="0 0 100 100"><circle cx="50" cy="52" r="40" fill="none" stroke="#9ca3af" stroke-width="2"/><text x="36" y="22" font-size="9" fill="#6b7280">Vrouks</text><circle cx="50" cy="58" r="20" fill="none" stroke="#1f2937" stroke-width="2"/><text x="38" y="50" font-size="9" fill="#1f2937">Gloms</text><circle cx="50" cy="60" r="3" fill="#1f2937"/><text x="54" y="63" font-size="9" fill="#1f2937">Pim</text></svg>', '[{"id":"a","text":"بيم ليس أزرق."},{"id":"b","text":"بيم أزرق."},{"id":"c","text":"بيم ليس فروكًا."},{"id":"d","text":"كل الفروكات غلومات."}]'::jsonb, 'a', 'القاعدة الخفية: نسلسل الاحتواءات. بيم غلوم، وكل الغلومات فروكات: إذن بيم فروك. وبما أن لا فروك أزرق: إذن بيم ليس أزرق. ✓ الخيار a هو الاستنتاج اليقيني الوحيد. الخيار b («بيم أزرق») يؤكد نقيض القاعدة تمامًا. الخيار c («بيم ليس فروكًا») يناقض السلسلة غلوم ← فروك. الخيار d يعكس الاحتواء: «كل الغلومات فروكات» لا يقول شيئًا عن العكس (قد توجد فروكات ليست غلومات). تتبّع أسهم الاحتواء في الاتجاه الصحيح دون قلبها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3479c876-d176-5de6-ae25-1c2b852524d2', '6f0e4817-1517-590d-8089-bafe582124ed', 'مصفوفة 3×3: في كل سطر، يبقى الشكل نفسه ويزداد عدد النقاط بداخله بمقدار 1 نحو اليمين (1، 2، 3). أي شكل يملأ الخانة الناقصة (في الأسفل إلى اليمين)؟ <svg viewBox="0 0 100 100"><line x1="34" y1="4" x2="34" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="34" x2="96" y2="34" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#9ca3af" stroke-width="1"/><circle cx="19" cy="19" r="11" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="19" cy="19" r="2.5" fill="#1f2937"/><circle cx="50" cy="19" r="11" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="45" cy="19" r="2.5" fill="#1f2937"/><circle cx="55" cy="19" r="2.5" fill="#1f2937"/><circle cx="82" cy="19" r="11" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="77" cy="19" r="2.5" fill="#1f2937"/><circle cx="82" cy="19" r="2.5" fill="#1f2937"/><circle cx="87" cy="19" r="2.5" fill="#1f2937"/><rect x="9" y="41" width="20" height="18" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="19" cy="50" r="2.5" fill="#1f2937"/><rect x="40" y="41" width="20" height="18" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="45" cy="50" r="2.5" fill="#1f2937"/><circle cx="55" cy="50" r="2.5" fill="#1f2937"/><rect x="72" y="41" width="20" height="18" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="77" cy="50" r="2.5" fill="#1f2937"/><circle cx="82" cy="50" r="2.5" fill="#1f2937"/><circle cx="87" cy="50" r="2.5" fill="#1f2937"/><polygon points="19,74 28,90 10,90" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="19" cy="85" r="2.5" fill="#1f2937"/><polygon points="50,74 59,90 41,90" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="45" cy="85" r="2.5" fill="#1f2937"/><circle cx="55" cy="85" r="2.5" fill="#1f2937"/><text x="78" y="90" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 78,76 22,76\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"60\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 78,76 22,76\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"40\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"46\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"24\" y=\"30\" width=\"52\" height=\"46\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"38\" cy=\"53\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"53\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"53\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 78,76 22,76\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"40\" cy=\"66\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"66\" r=\"5\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'b', 'للقاعدة الخفية مكوّنان: (1) الشكل ثابت في كل سطر — السطر الأخير مكوّن من مثلثات؛ (2) عدد النقاط يزداد بمقدار 1 نحو اليمين، فيحتوي العمود الثالث على 3. يجب أن تكون الخانة الناقصة مثلثًا يحتوي على 3 نقاط. ✓ الخيار b مثلث بثلاث نقاط: فهو الصحيح. الخيار d مثلث لكن بنقطتين فقط (يكرّر العمود الأوسط). الخيار c له 3 نقاط لكنه يغيّر الشكل (مربع بدل مثلث، سطر خاطئ). الخيار a مثلث بنقطة واحدة (يكرّر العمود الأول). تحقّق من القاعدتين معًا: الشكل الصحيح والعدد الصحيح.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac991928-7aba-5c7e-a892-92a8673155ae', '6f0e4817-1517-590d-8089-bafe582124ed', 'مصفوفة 3×3: في كل سطر، الخانة الثالثة هي التراكب (الشكلان مرسومان معًا) للخانتين الأوليين. أي شكل يكمل الخانة الناقصة (في الأسفل إلى اليمين)؟ <svg viewBox="0 0 100 100"><line x1="34" y1="4" x2="34" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="34" x2="96" y2="34" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#9ca3af" stroke-width="1"/><line x1="19" y1="10" x2="19" y2="28" stroke="#1f2937" stroke-width="2"/><line x1="42" y1="19" x2="58" y2="19" stroke="#1f2937" stroke-width="2"/><line x1="73" y1="10" x2="73" y2="28" stroke="#1f2937" stroke-width="2"/><line x1="73" y1="19" x2="89" y2="19" stroke="#1f2937" stroke-width="2"/><circle cx="19" cy="50" r="9" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="42" y1="50" x2="58" y2="50" stroke="#1f2937" stroke-width="2"/><circle cx="82" cy="50" r="9" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="74" y1="50" x2="90" y2="50" stroke="#1f2937" stroke-width="2"/><rect x="11" y="75" width="16" height="16" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="50" cy="83" r="8" fill="none" stroke="#1f2937" stroke-width="2"/><text x="78" y="88" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,26 74,72 26,72\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"56\" r=\"16\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية: في كل سطر، تُظهر الخانة الثالثة الشكلين الأولين متراكبين. السطر 1: خط عمودي + خط أفقي = صليب. السطر 2: دائرة + خط أفقي = دائرة مشطوبة. السطر 3: مربع (الخانة 1) ودائرة (الخانة 2)، فيجب أن تُظهر الخانة الناقصة المربع والدائرة متراكبين. ✓ الخيار a يجمع المربع والدائرة: فهو الصحيح. الخيار b يحتفظ بالمربع فقط (ينسى الشكل الثاني). الخيار c يحتفظ بالدائرة فقط (ينسى الشكل الأول). الخيار d يضيف مثلثًا لا يظهر في أي مكان على السطر (شكل مخترع). التراكب يجمع الشكلين المعطيين تمامًا، دون حذف أو اختراع.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ef8eb95c-c1c9-5333-8cfc-29dd649c6d95', 'f1fe9612-e645-526d-bc44-3fa7363d066d', 'iq-training-ar', '👑 نخبة المنطق ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('77cfda83-d79a-54b5-a711-70bf6fe64326', 'ef8eb95c-c1c9-5333-8cfc-29dd649c6d95', 'مصفوفة 3×3: لاحظ عدد النقاط السوداء في كل خانة. أي شكل يكمل الخانة المعلَّمة بـ«؟» (في الأسفل إلى اليمين)؟ <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="1.5" fill="none"><rect x="4" y="4" width="92" height="92"/><line x1="34.7" y1="4" x2="34.7" y2="96"/><line x1="65.3" y1="4" x2="65.3" y2="96"/><line x1="4" y1="34.7" x2="96" y2="34.7"/><line x1="4" y1="65.3" x2="96" y2="65.3"/></g><g fill="#1e293b"><circle cx="19" cy="19" r="3.5"/><circle cx="45" cy="15" r="3.5"/><circle cx="55" cy="23" r="3.5"/><circle cx="73" cy="14" r="3.5"/><circle cx="81" cy="19" r="3.5"/><circle cx="88" cy="24" r="3.5"/><circle cx="19" cy="50" r="3.5"/><circle cx="45" cy="46" r="3.5"/><circle cx="55" cy="54" r="3.5"/><circle cx="73" cy="45" r="3.5"/><circle cx="81" cy="50" r="3.5"/><circle cx="88" cy="55" r="3.5"/><circle cx="19" cy="81" r="3.5"/><circle cx="45" cy="77" r="3.5"/><circle cx="55" cy="85" r="3.5"/></g><text x="81" y="86" font-size="14" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#1e293b\"><circle cx=\"38\" cy=\"50\" r=\"6\"/><circle cx=\"62\" cy=\"50\" r=\"6\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#1e293b\"><circle cx=\"30\" cy=\"50\" r=\"6\"/><circle cx=\"50\" cy=\"50\" r=\"6\"/><circle cx=\"70\" cy=\"50\" r=\"6\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#1e293b\"><circle cx=\"25\" cy=\"50\" r=\"6\"/><circle cx=\"42\" cy=\"50\" r=\"6\"/><circle cx=\"58\" cy=\"50\" r=\"6\"/><circle cx=\"75\" cy=\"50\" r=\"6\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#1e293b\"><circle cx=\"50\" cy=\"50\" r=\"6\"/></g></svg>"}]'::jsonb, 'b', 'القاعدة الخفية: عدد النقاط يعتمد على العمود فقط — العمود 1 = نقطة واحدة، العمود 2 = نقطتان، العمود 3 = 3 نقاط، متطابق في كل سطر. الخانة «؟» في العمود 3، فيلزم 3 نقاط. ✓ الخيار b. فخّ a (نقطتان): نسخنا العمود الأوسط. فخّ c (4 نقاط): واصلنا بـ1+ بدل التوقف عند العمود 3. فخّ d (نقطة واحدة): خلطنا مع العمود الأيسر.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('347fc039-b8ea-527b-920c-e6fae785f614', 'ef8eb95c-c1c9-5333-8cfc-29dd649c6d95', 'متتالية أشكال: لاحظ كيف يتغير كل شكل لينتقل إلى التالي. أي شكل يحل محل علامة «؟» <svg viewBox="0 0 100 100"><g fill="none" stroke="#1e293b" stroke-width="3"><polygon points="15,38 25,22 35,38"/><polygon points="42,22 58,22 58,38 42,38"/><polygon points="75,21 84,28 80,38 70,38 66,28"/></g><text x="25" y="52" font-size="9" text-anchor="middle" fill="#64748b">3 côtés</text><text x="50" y="52" font-size="9" text-anchor="middle" fill="#64748b">4 côtés</text><text x="75" y="52" font-size="9" text-anchor="middle" fill="#64748b">5 côtés</text><text x="50" y="78" font-size="14" text-anchor="middle" fill="#ef4444">? = forme suivante</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"35,30 65,30 65,60 35,60\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 70,38 66,60 34,60 30,38\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,28 60,28 72,45 60,62 40,62 28,45\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,26 62,34 68,48 62,62 50,70 38,62 32,48 38,34\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'القاعدة: في كل مرحلة يكتسب الشكل ضلعًا واحدًا بالضبط — مثلث (3)، مربع (4)، مخمّس (5). فيجب أن يكون للشكل التالي 6 أضلاع: مسدّس. ✓ الخيار c. فخّ b (مخمّس، 5 أضلاع): نسخنا الشكل الأخير دون إضافة ضلع. فخّ d (مثمّن، 8 أضلاع): قفزنا إلى ما بعد 6. فخّ a (مربع، 4 أضلاع): تراجعنا في المتتالية بدل التقدّم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9fb5ebc-5704-5005-a00a-6c2cfc993404', 'ef8eb95c-c1c9-5333-8cfc-29dd649c6d95', 'تناظر: نسبة A إلى B كنسبة C إلى ؟ — اكتشف التحويل الذي يقود من A إلى B، ثم طبّقه على C. <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="12" y1="42" x2="12" y2="18"/><polyline points="7,25 12,18 17,25"/></g><text x="24" y="34" font-size="12" fill="#1e293b">→</text><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="34" y1="30" x2="58" y2="30"/><polyline points="51,25 58,30 51,35"/></g><text x="68" y="34" font-size="11" fill="#64748b">::</text><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="86" y1="30" x2="62" y2="30"/><polyline points="69,25 62,30 69,35"/></g><text x="50" y="78" font-size="13" text-anchor="middle" fill="#ef4444">C → ?</text><text x="50" y="92" font-size="9" text-anchor="middle" fill="#64748b">A: vers le haut, B: vers la droite, C: vers la gauche</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"50\" y1=\"68\" x2=\"50\" y2=\"32\"/><polyline points=\"42,42 50,32 58,42\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"50\" y1=\"32\" x2=\"50\" y2=\"68\"/><polyline points=\"42,58 50,68 58,58\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"32\" y1=\"50\" x2=\"68\" y2=\"50\"/><polyline points=\"58,42 68,50 58,58\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"68\" y1=\"50\" x2=\"32\" y2=\"50\"/><polyline points=\"42,42 32,50 42,58\"/></g></svg>"}]'::jsonb, 'a', 'القاعدة: من A إلى B يدور السهم ربع دورة (90°) في اتجاه عقارب الساعة — الأعلى يصير اليمين. نطبّق الدوران نفسه مع عقارب الساعة على C، الذي يشير نحو اليسار: اليسار مدارًا ربع دورة مع عقارب الساعة يصير الأعلى. ✓ الخيار a (سهم نحو الأعلى). فخّ b (نحو الأسفل): إنه دوران عكس عقارب الساعة، اتجاه خاطئ. فخّ d (نحو اليسار): نسخنا C دون تدويره. فخّ c (نحو اليمين): إنه دوران 180°، أي ربعا دورة بدل واحد.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a25e4c0-dbbd-5e0a-b4e9-2bb5a2bf0acd', 'ef8eb95c-c1c9-5333-8cfc-29dd649c6d95', 'الدخيل: ثلاثة من هذه الأشكال تخضع لقاعدة واحدة، وواحد فقط يكسرها. أيها الدخيل؟ <svg viewBox="0 0 100 100"><text x="50" y="44" font-size="11" text-anchor="middle" fill="#1e293b">Un point et un contour par figure.</text><text x="50" y="60" font-size="11" text-anchor="middle" fill="#1e293b">Trouve celle qui sort du lot.</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"26\" y=\"26\" width=\"48\" height=\"48\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,22 76,68 24,68\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"54\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"44\" cy=\"50\" r=\"22\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"82\" cy=\"50\" r=\"5\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'd', 'القاعدة: في كل شكل يجب أن تقع النقطة السوداء داخل المحيط. دائرة+نقطة بالداخل (a)، مربع+نقطة بالداخل (b)، مثلث+نقطة بالداخل (c) تحترم القاعدة. في (d) النقطة موضوعة خارج الدائرة: إنه الدخيل. ✓ الخيار d. فخّ a وb وc: إنها أشكال مختلفة (دائرة، مربع، مثلث)، لكن شكل المحيط ليس القاعدة — المهم فقط أن تكون النقطة بالداخل، وهذا ما يجعلها كلها مطابقة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bd79d725-261a-5bc4-9d65-266cc3924b6b', 'ef8eb95c-c1c9-5333-8cfc-29dd649c6d95', 'استنتاج منطقي. نعلم أن: (1) كل الغليبات بروماتٌ. (2) لا بروم زارن. (3) ميلو غليب. ما الاستنتاج الصحيح بالضرورة؟', '[{"id":"a","text":"ميلو زارن."},{"id":"b","text":"ميلو ليس زارنًا."},{"id":"c","text":"بعض البرومات زارنات."},{"id":"d","text":"ميلو ليس برومًا."}]'::jsonb, 'b', 'القاعدة: نسلسل الاستلزامات. ميلو غليب (3)، وكل الغليبات بروماتٌ (1)، إذن ميلو بروم. ولا بروم زارن (2)، إذن ميلو ليس زارنًا. ✓ الخيار b. فخّ a: استنتاج معاكس، يناقض (2). فخّ d: خاطئ، فقد استنتجنا للتو أن ميلو بروم عبر (1). فخّ c: يناقض مباشرة (2) التي تقول إن لا بروم زارن.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0fb01dd2-1808-5d07-a31b-f57b169655e0', 'ef8eb95c-c1c9-5333-8cfc-29dd649c6d95', 'متتالية أعداد: 2، 6، 12، 20، 30، ؟ — اكتشف القاعدة الخفية التي تربط كل حدّ بالتالي، ثم أعطِ العدد الناقص.', '[{"id":"a","text":"40"},{"id":"b","text":"42"},{"id":"c","text":"36"},{"id":"d","text":"56"}]'::jsonb, 'b', 'القاعدة: الفروق بين الحدود تزداد بمقدار 2 في كل مرة — 4+، 6+، 8+، 10+، فيكون الفرق التالي 12+. 30 + 12 = 42. ✓ (قراءة أخرى: كل حدّ يساوي n×(n+1): 1×2، 2×3، 3×4، 4×5، 5×6، ثم 6×7 = 42). فخّ a (40): أعدنا استعمال الفرق الأخير 10+ بدل 12+. فخّ c (36): أخذنا فرقًا قدره 6+، بتكرار قفزة قديمة. فخّ d (56): إنه 7×8، قفزنا عن حدّ من المتتالية.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('28bccb54-dffd-5bac-af66-10f6cea1559c', '4a093f2d-7950-50df-a390-9a288dcc4b77', 'iq-training-ar', 'إحماء الرياضيات والاستدلال ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('b68f7891-0005-5c67-b356-d2f622730d25', '28bccb54-dffd-5bac-af66-10f6cea1559c', 'تأمّل متتالية الأعداد واكتشف القاعدة الخفية: 3, 6, 9, 12, ؟ — ما العدد الذي يأتي بعد ذلك؟', '[{"id":"a","text":"15"},{"id":"b","text":"13"},{"id":"c","text":"16"},{"id":"d","text":"24"}]'::jsonb, 'a', 'القاعدة الخفية: نضيف 3 في كل خطوة (3, 6, 9, 12…). ✓ إذن الحدّ الموالي هو 12 + 3 = 15، أي الخيار a. الخيار b (13) يضيف 1 فقط، كأننا نعدّ تتابعًا. الخيار c (16) يضيف 4: العملية صحيحة لكن المقدار خاطئ. الخيار d (24) يضاعف الحدّ الأخير بدل مواصلة الإضافة المنتظمة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22f97190-c7f9-555f-9f64-2cd31dd717d0', '28bccb54-dffd-5bac-af66-10f6cea1559c', 'أكمل التماثل بالحفاظ على العلاقة نفسها: 3 إلى 6 كما 5 إلى ؟ (تلميح: بكم نضرب 3 لنحصل على 6؟)', '[{"id":"a","text":"11"},{"id":"b","text":"15"},{"id":"c","text":"10"},{"id":"d","text":"25"}]'::jsonb, 'c', 'العلاقة الخفية: نضرب في 2 (3 × 2 = 6). ✓ نطبّق القاعدة نفسها على 5: 5 × 2 = 10، أي الخيار c. الخيار a (11) يجمع 5 + 6، أي يضيف نتيجة الزوج الأول بدل إعادة استعمال قاعدته. الخيار b (15) يضرب في 3 (5 × 3)، آخذًا العدد الأول من النموذج عاملًا بدل «×2». الخيار d (25) يرفّع 5 إلى المربع: نغيّر العملية في منتصف الطريق.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('528f0a45-fe3c-54ad-a752-4ac12d42dd97', '28bccb54-dffd-5bac-af66-10f6cea1559c', 'في هذه الشبكة، للسطرين المجموع نفسه. ما العدد الناقص مكان «؟»؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="15" y="15" width="70" height="70" fill="none" stroke="#1d4ed8" stroke-width="2"/><line x1="38" y1="15" x2="38" y2="85" stroke="#1d4ed8" stroke-width="1.5"/><line x1="62" y1="15" x2="62" y2="85" stroke="#1d4ed8" stroke-width="1.5"/><line x1="15" y1="50" x2="85" y2="50" stroke="#1d4ed8" stroke-width="1.5"/><text x="26" y="37" font-size="13" fill="#0f172a" text-anchor="middle">2</text><text x="50" y="37" font-size="13" fill="#0f172a" text-anchor="middle">4</text><text x="74" y="37" font-size="13" fill="#0f172a" text-anchor="middle">3</text><text x="26" y="73" font-size="13" fill="#0f172a" text-anchor="middle">5</text><text x="50" y="73" font-size="13" fill="#0f172a" text-anchor="middle">?</text><text x="74" y="73" font-size="13" fill="#be123c" text-anchor="middle">2</text></svg>', '[{"id":"a","text":"4"},{"id":"b","text":"2"},{"id":"c","text":"9"},{"id":"d","text":"5"}]'::jsonb, 'b', 'القاعدة: للسطرين المجموع نفسه. السطر العلوي مجموعه 2 + 4 + 3 = 9. ✓ والسطر السفلي يجب أن يساوي 9 أيضًا: 5 + ؟ + 2 = 9، إذن ؟ = 9 − 7 = 2، أي الخيار b. الخيار a (4) ينسخ خانة مجاورة دون حساب. الخيار c (9) يعطي المجموع الكلي لسطر بدل الخانة الناقصة. الخيار d (5) يكرّر العدد الأول من السطر بدل إكمال المجموع.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9cdb451a-8318-5f9e-a8a8-a7223ebdb53a', '28bccb54-dffd-5bac-af66-10f6cea1559c', 'وصفة تستعمل 2 بيضة لـ 6 فطائر. بالحفاظ على النسبة نفسها، كم بيضة يلزم لـ 12 فطيرة؟', '[{"id":"a","text":"8"},{"id":"b","text":"6"},{"id":"c","text":"4"},{"id":"d","text":"3"}]'::jsonb, 'c', 'القاعدة: عدد الفطائر يتضاعف (6 → 12)، إذن كل شيء يتضاعف بنسبة متساوية. ✓ يلزم 2 × 2 = 4 بيضات، أي الخيار c. الخيار a (8) يضيف 6 للبيض كما أضفنا 6 للفطائر: نجمع بدل احترام النسبة. الخيار b (6) ينسخ عدد الفطائر الأولي. الخيار d (3) يضيف 1 فقط دون مراعاة التضاعف.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22083648-9160-59af-b832-42e454f4c55f', '28bccb54-dffd-5bac-af66-10f6cea1559c', 'كل شكل يحتوي عددًا. القاعدة هي نفسها من شكل إلى آخر. ما العدد الذي يجب أن يحلّ مكان «؟» في الشكل الأخير؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="15" cy="50" r="11" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="15" y="55" font-size="13" fill="#0f172a" text-anchor="middle">1</text><circle cx="39" cy="50" r="11" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="39" y="55" font-size="13" fill="#0f172a" text-anchor="middle">2</text><circle cx="63" cy="50" r="11" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="63" y="55" font-size="13" fill="#0f172a" text-anchor="middle">4</text><circle cx="87" cy="50" r="11" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="87" y="55" font-size="13" fill="#be123c" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"5"},{"id":"b","text":"6"},{"id":"c","text":"8"},{"id":"d","text":"16"}]'::jsonb, 'c', 'القاعدة الخفية: كل عدد هو ضعف سابقه (1، ثم 2، ثم 4…). ✓ الموالي يساوي 4 × 2 = 8، أي الخيار c. مع ثلاثة حدود معطاة (1, 2, 4)، تنطبق قاعدة «×2» وحدها: الجمع مستبعد لأن الفارق يتغيّر (من 1 إلى 2، ثم من 2 إلى 4). الخيار a (5) يضيف 1 للحدّ الأخير. الخيار b (6) يضيف الفارق الأخير (4 + 2) بدل المضاعفة. الخيار d (16) يضاعف مرتين (يقفز خطوة).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e8e1afe6-52a0-5699-8ac5-9b008e2c7bf3', '4a093f2d-7950-50df-a390-9a288dcc4b77', 'iq-training-ar', '⭐ إحماء', 1, 50, 10, 'practice', 'admin', 1)
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
  ('bb37a426-5636-522b-bd9d-7d4a09111922', 'e8e1afe6-52a0-5699-8ac5-9b008e2c7bf3', 'تأمّل المتتالية واكتشف القاعدة الخفية: 4, 7, 10, 13, ؟ ما العدد الذي يأتي بعد ذلك؟', '[{"id":"a","text":"16"},{"id":"b","text":"15"},{"id":"c","text":"17"},{"id":"d","text":"26"}]'::jsonb, 'a', 'القاعدة هي: +3 في كل خطوة (7−4 = 3، 10−7 = 3، 13−10 = 3). إذن العدد الموالي هو 13 + 3 = 16 ← الخيار a ✓. الفخّ: b (15) يضيف 2 فقط، c (17) يضيف 4، وd (26) يضاعف العدد الأخير. الفارق بين حدّين يبقى ثابتًا ويساوي 3.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e447d766-ec7d-5966-9ff4-2f2d654f9dde', 'e8e1afe6-52a0-5699-8ac5-9b008e2c7bf3', 'اكتشف القاعدة المشتركة بين المثالين، ثم طبّقها: 2 ← 4، 3 ← 6، إذن 5 ← ؟', '[{"id":"a","text":"8"},{"id":"b","text":"10"},{"id":"c","text":"9"},{"id":"d","text":"11"}]'::jsonb, 'b', 'مع مثالين، قاعدة واحدة فقط تصلح للاثنين معًا: نضرب في 2. تحقّق: 2 × 2 = 4 و3 × 2 = 6 ✓. نطبّق على 5: 5 × 2 = 10 ← الخيار b ✓. الفخّ: a (8) يفترض «إضافة 3» (3 + 3 = 6)، لكن هذه القاعدة تفشل في المثال الأول (2 + 3 = 5 ≠ 4)، فتُستبعد؛ c (9) هو 5 + 4 وd (11) هو 5 + 6، وكلاهما لا يطابق أيًّا من المثالين. الضرب في 2 وحده يعيد إنتاج 4 و6، إذن 5 يعطي 10.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dcdec3bd-c933-53a1-82f4-ea8c5e35172f', 'e8e1afe6-52a0-5699-8ac5-9b008e2c7bf3', 'في هذه الشبكة، كل سطر يتبع القاعدة نفسها: تُجمع الخانتان الأوليان لتعطيا الثالثة. ما العدد الذي يحلّ مكان «؟»؟ <svg viewBox="0 0 100 100"><rect x="10" y="15" width="80" height="70" fill="none" stroke="#222" stroke-width="2"/><line x1="36" y1="15" x2="36" y2="85" stroke="#222" stroke-width="2"/><line x1="63" y1="15" x2="63" y2="85" stroke="#222" stroke-width="2"/><line x1="10" y1="38" x2="90" y2="38" stroke="#222" stroke-width="2"/><line x1="10" y1="61" x2="90" y2="61" stroke="#222" stroke-width="2"/><text x="23" y="31" font-size="13" text-anchor="middle" fill="#222">2</text><text x="49" y="31" font-size="13" text-anchor="middle" fill="#222">3</text><text x="76" y="31" font-size="13" text-anchor="middle" fill="#222">5</text><text x="23" y="54" font-size="13" text-anchor="middle" fill="#222">4</text><text x="49" y="54" font-size="13" text-anchor="middle" fill="#222">1</text><text x="76" y="54" font-size="13" text-anchor="middle" fill="#222">5</text><text x="23" y="77" font-size="13" text-anchor="middle" fill="#222">3</text><text x="49" y="77" font-size="13" text-anchor="middle" fill="#222">4</text><text x="76" y="77" font-size="15" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"5"},{"id":"b","text":"12"},{"id":"c","text":"7"},{"id":"d","text":"1"}]'::jsonb, 'c', 'القاعدة، الظاهرة على السطرين الأولين: الخانة3 = الخانة1 + الخانة2 (2 + 3 = 5، ثم 4 + 1 = 5). للسطر الأخير: 3 + 4 = 7 ← الخيار c ✓. الفخّ: a (5) ينسخ نتيجة السطور الأخرى بدل الحساب، b (12) يضرب 3 × 4، وd (1) يطرح 4 − 3. العملية الصحيحة هي جمع الخانتين الأوليين.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('add79ee1-14a9-50a8-a926-9bc684d2ae03', 'e8e1afe6-52a0-5699-8ac5-9b008e2c7bf3', 'تأمّل المتتالية واكتشف القاعدة الخفية: 2, 4, 6, 8, ؟ ما العدد الذي يأتي بعد ذلك؟', '[{"id":"a","text":"9"},{"id":"b","text":"16"},{"id":"c","text":"12"},{"id":"d","text":"10"}]'::jsonb, 'd', 'القاعدة هي: +2 في كل خطوة، وهي الأعداد الزوجية (2, 4, 6, 8…). الموالي هو 8 + 2 = 10 ← الخيار d ✓. الفخّ: a (9) يضيف 1 ويعطي عددًا فرديًا، b (16) يضاعف الحدّ الأخير، وc (12) يقفز خطوة (+4). نتقدّم بانتظام 2 خانتين خانتين، إذن بعد 8 يأتي 10.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a36fd065-8b3d-57b1-8620-1fbe8f127c2f', 'e8e1afe6-52a0-5699-8ac5-9b008e2c7bf3', 'كريّتان متماثلتان تكلّفان 6 قطع ذهبية. بالسعر نفسه لكل كريّة، كم تكلّف 5 كريّات؟', '[{"id":"a","text":"9"},{"id":"b","text":"15"},{"id":"c","text":"12"},{"id":"d","text":"30"}]'::jsonb, 'b', 'نبحث أولًا عن سعر كريّة واحدة: 6 ÷ 2 = 3 قطع. لـ 5 كريّات: 5 × 3 = 15 ← الخيار b ✓. الفخّ: a (9) يضيف 3 فقط إلى 6 (كأننا انتقلنا من 2 إلى 3 كريّات)، c (12) يضاعف سعر كريّتين، وd (30) يضرب 6 في 5 دون ردّه إلى سعر الوحدة. يجب إيجاد سعر كريّة واحدة، ثم الضرب في 5.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9074c9d-3285-5e33-b0a9-75bde9b0591b', 'e8e1afe6-52a0-5699-8ac5-9b008e2c7bf3', 'في هذا الهرم، كل عدد هو مجموع العددين اللذين تحته مباشرة. ما العدد الموجود في القمّة؟ <svg viewBox="0 0 100 100"><rect x="38" y="10" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="50" y="26" font-size="15" text-anchor="middle" fill="#888">?</text><rect x="24" y="39" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="36" y="55" font-size="13" text-anchor="middle" fill="#222">5</text><rect x="52" y="39" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="64" y="55" font-size="13" text-anchor="middle" fill="#222">8</text><rect x="10" y="68" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="22" y="84" font-size="13" text-anchor="middle" fill="#222">2</text><rect x="38" y="68" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="50" y="84" font-size="13" text-anchor="middle" fill="#222">3</text><rect x="66" y="68" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="78" y="84" font-size="13" text-anchor="middle" fill="#222">5</text></svg>', '[{"id":"a","text":"10"},{"id":"b","text":"23"},{"id":"c","text":"13"},{"id":"d","text":"15"}]'::jsonb, 'c', 'تتحقّق القاعدة على القاعدة السفلية: 2 + 3 = 5 و3 + 5 = 8، وهما خانتا الوسط. إذن القمّة تساوي 5 + 8 = 13 ← الخيار c ✓. الفخّ: a (10) يجمع أطراف القاعدة (2 + 3 + 5 = 10)، b (23) يجمع كل الأعداد المعروضة، وd (15) يضيف 2 إلى القمّة. القمّة هي مجموع الخانتين اللتين تحتها مباشرة، أي 5 + 8 = 13.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8144cb53-8600-53c6-9eb1-cf65a8f5aaa8', '4a093f2d-7950-50df-a390-9a288dcc4b77', 'iq-training-ar', '⚔️ تحدّي الرياضيات والاستدلال ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
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
  ('78ec22be-cfbf-5f82-8deb-9b0d64f7c31e', '8144cb53-8600-53c6-9eb1-cf65a8f5aaa8', 'تأمّل المتتالية واكتشف القاعدة الخفية. ما العدد الذي يأتي بعد ذلك؟ 2, 5, 4, 7, 6, ؟', '[{"id":"a","text":"9"},{"id":"b","text":"8"},{"id":"c","text":"5"},{"id":"d","text":"10"}]'::jsonb, 'a', 'القاعدة الخفية تتناوب عمليتين: +3 ثم −1، وهكذا. 2 (+3)→5 (−1)→4 (+3)→7 (−1)→6 (+3)→9. ✓ بعد 6 الأخير، يأتي دور +3، إذن 9. الخيار b (8) يطبّق +2 كأن الفارق ثابت. الخيار c (5) يطبّق −1 في حين أن الدور للـ +3. الخيار d (10) يطبّق +4 (خانة زائدة). نصيحة: حين تصعد متتالية ثم تنزل، ابحث عن عمليتين تتناوبان.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('036468ad-bdf3-5045-84d0-9f594df255f0', '8144cb53-8600-53c6-9eb1-cf65a8f5aaa8', 'اكتشف العلاقة الخفية بين العدد الأول والثاني، ثم طبّقها. 2 ← 4، 3 ← 9، إذن 5 ← ؟', '[{"id":"a","text":"15"},{"id":"b","text":"10"},{"id":"c","text":"25"},{"id":"d","text":"11"}]'::jsonb, 'c', 'القاعدة الخفية: نرفّع العدد إلى المربّع (n × n). 2 → 2×2 = 4 ✓ و3 → 3×3 = 9 ✓، إذن 5 → 5×5 = 25. ✓ الجواب الصحيح هو 25. المثالان يُقصيان المسالك الخاطئة: الخيار a (15) يفترض ×3، لكن ×3 يعطي 2→6 (≠4)، فلا تثبت هذه القاعدة. الخيار b (10) يطبّق ×2، الذي يعطي 3→6 (≠9). الخيار d (11) يضيف 6، الذي يعطي 2→8 (≠4). الرفع إلى المربّع وحده يصلح للزوجين الأوليين. تحقّق دائمًا أن قاعدة واحدة بعينها تصلح لكل الأزواج المعروفة قبل تطبيقها على الجديد.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7969220-c90f-567e-84f1-6d23f6cd27bf', '8144cb53-8600-53c6-9eb1-cf65a8f5aaa8', 'في هذه الشبكة، كل سطر يتبع قاعدة الحساب نفسها التي تربط أعداده الثلاثة. ما العدد الذي يحلّ مكان «؟»؟ <svg viewBox="0 0 100 100"><line x1="4" y1="36" x2="96" y2="36" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="64" x2="96" y2="64" stroke="#9ca3af" stroke-width="1"/><line x1="35" y1="6" x2="35" y2="94" stroke="#9ca3af" stroke-width="1"/><line x1="65" y1="6" x2="65" y2="94" stroke="#9ca3af" stroke-width="1"/><text x="15" y="26" font-size="13" fill="#1f2937">4</text><text x="45" y="26" font-size="13" fill="#1f2937">3</text><text x="75" y="26" font-size="13" fill="#1f2937">7</text><text x="15" y="55" font-size="13" fill="#1f2937">6</text><text x="45" y="55" font-size="13" fill="#1f2937">2</text><text x="75" y="55" font-size="13" fill="#1f2937">8</text><text x="15" y="84" font-size="13" fill="#1f2937">5</text><text x="45" y="84" font-size="13" fill="#1f2937">3</text><text x="74" y="84" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"2"},{"id":"b","text":"8"},{"id":"c","text":"15"},{"id":"d","text":"7"}]'::jsonb, 'b', 'القاعدة الخفية: في كل سطر، العمود الثالث هو مجموع العمودين الأولين. السطر 1: 4+3 = 7 ✓. السطر 2: 6+2 = 8 ✓. السطر 3: 5+3 = 8، إذن «؟» = 8. ✓ الجواب الصحيح هو 8. الخيار a (2) يحسب الفرق (5−3) بدل المجموع. الخيار c (15) يضرب (5×3). الخيار d (7) ينسخ نتيجة السطر الأول دون إعادة الحساب. اختبر قاعدتك على كل السطور المعروفة قبل تطبيقها على السطر المجهول.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d356ebca-8101-58d7-a78a-0ba5a41a881a', '8144cb53-8600-53c6-9eb1-cf65a8f5aaa8', 'وصفة تحافظ دائمًا على النسبة نفسها: 2 مقادير من الدقيق تعطي 6 أقراص. باحترام هذه النسبة، كم قرصًا تعطي 5 مقادير؟ <svg viewBox="0 0 100 100"><rect x="6" y="30" width="40" height="40" fill="none" stroke="#9ca3af" stroke-width="1.5"/><text x="14" y="45" font-size="9" fill="#1f2937">2 mes.</text><text x="13" y="62" font-size="9" fill="#1f2937">6 gal.</text><text x="50" y="54" font-size="14" fill="#1f2937">→</text><rect x="60" y="30" width="40" height="40" fill="none" stroke="#9ca3af" stroke-width="1.5"/><text x="68" y="45" font-size="9" fill="#1f2937">5 mes.</text><text x="73" y="63" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"9"},{"id":"b","text":"12"},{"id":"c","text":"30"},{"id":"d","text":"15"}]'::jsonb, 'd', 'القاعدة الخفية: نسبة الأقراص/المقدار ثابتة. 6 أقراص مقابل 2 مقدار = 3 أقراص لكل مقدار. إذن 5 مقادير → 5 × 3 = 15 قرصًا. ✓ الجواب الصحيح هو 15. الخيار a (9) يضيف 3 (6+3) بدل احترام النسبة. الخيار b (12) يضاعف 6 ببساطة دون مراعاة الانتقال من 2 إلى 5 مقادير. الخيار c (30) يضرب 6 في 5 ناسيًا أن 6 تقابل 2 مقدار لا 1. في النسبة، ارجع أولًا إلى وحدة واحدة (هنا مقدار واحد).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70e80b22-b982-505f-8f38-92f12c2720ab', '8144cb53-8600-53c6-9eb1-cf65a8f5aaa8', 'مربّع سحري: كل سطر وكل عمود وكل قطر لها المجموع نفسه. ما العدد الذي يجب أن يشغل الخانة المعلّمة بـ «؟»؟ <svg viewBox="0 0 100 100"><rect x="6" y="6" width="88" height="88" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="35" y1="6" x2="35" y2="94" stroke="#1f2937" stroke-width="1"/><line x1="65" y1="6" x2="65" y2="94" stroke="#1f2937" stroke-width="1"/><line x1="6" y1="35" x2="94" y2="35" stroke="#1f2937" stroke-width="1"/><line x1="6" y1="65" x2="94" y2="65" stroke="#1f2937" stroke-width="1"/><text x="16" y="26" font-size="13" fill="#1f2937">8</text><text x="46" y="26" font-size="13" fill="#1f2937">1</text><text x="76" y="26" font-size="13" fill="#1f2937">6</text><text x="16" y="55" font-size="13" fill="#1f2937">3</text><text x="46" y="55" font-size="13" fill="#1f2937">5</text><text x="75" y="55" font-size="14" fill="#1f2937">?</text><text x="16" y="85" font-size="13" fill="#1f2937">4</text><text x="46" y="85" font-size="13" fill="#1f2937">9</text><text x="76" y="85" font-size="13" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"7"},{"id":"b","text":"6"},{"id":"c","text":"8"},{"id":"d","text":"5"}]'::jsonb, 'a', 'القاعدة الخفية: لكل السطور والأعمدة والأقطار المجموع نفسه. السطر الأول يعطي 8+1+6 = 15: المجموع السحري هو 15. السطر الأوسط هو 3+5+؟، إذن ؟ = 15−3−5 = 7. ✓ تحقّق بعمود اليمين: 6+7+2 = 15. الجواب الصحيح هو 7. الخيار b (6) يكرّر قيمة الركن العلوي الأيمن. الخيار d (5) ينسخ المركز. الخيار c (8) يعطي 3+5+8 = 16، وهو يتجاوز 15. أوجد أولًا المجموع السحري على سطر كامل، ثم استنتج الخانة الناقصة بالطرح.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff1c9abd-9e3e-5219-acb5-d326ca69e0fb', '8144cb53-8600-53c6-9eb1-cf65a8f5aaa8', 'هذه المتتالية تخفي قاعدة على الفوارق بين الأعداد. ما العدد الذي يكملها؟ 2, 6, 12, 20, 30, ؟', '[{"id":"a","text":"40"},{"id":"b","text":"44"},{"id":"c","text":"42"},{"id":"d","text":"36"}]'::jsonb, 'c', 'تُقرأ القاعدة الخفية على الفوارق: 6−2=4، 12−6=6، 20−12=8، 30−20=10. ترتفع الفوارق 2 خانتين خانتين (4, 6, 8, 10)، إذن الفارق الموالي هو 12: 30+12 = 42. ✓ الجواب الصحيح هو 42. الخيار a (40) يبقي على فارق +10 كأنه ثابت. الخيار b (44) يقفز إلى فارق +14 (خانتان زائدتان). الخيار d (36) يأخذ فارق +6، إلى الوراء. حين لا يكون الفارق ثابتًا، انظر إلى فارق الفوارق: هنا يزيد بانتظام 2.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('77cf718d-7b55-55cf-a6dd-de899ee244f9', '4a093f2d-7950-50df-a390-9a288dcc4b77', 'iq-training-ar', '👑 نخبة الرياضيات والاستدلال ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('4fa181bb-f651-5c63-ae8d-0f2f992d5650', '77cf718d-7b55-55cf-a6dd-de899ee244f9', 'تأمّل المتتالية واكتشف العدد الذي يحلّ مكان «؟»: 2, 6, 12, 20, 30, ؟', '[{"id":"a","text":"42"},{"id":"b","text":"40"},{"id":"c","text":"36"},{"id":"d","text":"38"}]'::jsonb, 'a', 'القاعدة الخفية: الفارق بين حدّين يزيد بانتظام 2. الفوارق هي 4, 6, 8, 10 (6−2=4، 12−6=6، 20−12=8، 30−20=10)، إذن الموالي يساوي 12. 30 + 12 = 42. ✓ الخيار a. (رؤية أخرى: كل حدّ هو n×(n+1): 1×2، 2×3، 3×4، 4×5، 5×6، ثم 6×7 = 42.) الفخّ b (40): أبقينا على الفارق الأخير 10 بدل رفعه إلى 12. الفخّ d (38): أضفنا 8 بدل 12، بتكرار فارق قديم جدًا. الفخّ c (36): افترضنا فارقًا ثابتًا قدره 6، وهو ما تناقضه المتتالية منذ البداية.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ce3318e-8b99-56bb-85d1-6c1fd5f896f9', '77cf718d-7b55-55cf-a6dd-de899ee244f9', 'قاعدة واحدة تربط العدد الأيسر بالأيمن. 3 ← 10 و5 ← 16. إذن 7 ← ؟', '[{"id":"a","text":"24"},{"id":"b","text":"21"},{"id":"c","text":"22"},{"id":"d","text":"20"}]'::jsonb, 'c', 'القاعدة الخفية: نضرب في 3 ثم نضيف 1. تحقّق بالزوجين المعطيين: 3×3+1 = 10 ✓ و5×3+1 = 16 ✓. قاعدة دقيقة واحدة تلائم المثالين، إذن 7×3+1 = 22. ✓ الخيار c. الفخّ b (21): ضربنا في 3 لكن نسينا «+1» (7×3 = 21). الفخّ d (20): رأينا «+7» (3+7=10) وطبّقنا +13، أو جمعنا عشوائيًا؛ هذه القاعدة لا تصلح لـ 5 ← 16. الفخّ a (24): فعلنا ×3+3، الذي يعطي 12 لـ 3، إذن خطأ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5ea8bd5-6720-55af-82c1-301698eaabe4', '77cf718d-7b55-55cf-a6dd-de899ee244f9', 'في هذا المربّع السحري، كل سطر وكل عمود وكل قطر له المجموع نفسه. ما العدد الذي يوضع في الخانة «؟»؟ <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="2" fill="none"><rect x="5" y="5" width="30" height="30"/><rect x="35" y="5" width="30" height="30"/><rect x="65" y="5" width="30" height="30"/><rect x="5" y="35" width="30" height="30"/><rect x="35" y="35" width="30" height="30"/><rect x="65" y="35" width="30" height="30"/><rect x="5" y="65" width="30" height="30"/><rect x="35" y="65" width="30" height="30"/><rect x="65" y="65" width="30" height="30"/></g><g font-size="15" text-anchor="middle" fill="#1e293b"><text x="20" y="25">8</text><text x="50" y="25">1</text><text x="80" y="25">6</text><text x="20" y="55">3</text><text x="50" y="55" fill="#ef4444">?</text><text x="80" y="55">7</text><text x="20" y="85">4</text><text x="50" y="85">9</text><text x="80" y="85">2</text></g></svg>', '[{"id":"a","text":"6"},{"id":"b","text":"5"},{"id":"c","text":"4"},{"id":"d","text":"7"}]'::jsonb, 'b', 'القاعدة: كل السطور/الأعمدة/الأقطار تتشارك المجموع نفسه. سطر كامل يعطيه: 8 + 1 + 6 = 15، إذن المجموع المشترك هو 15. الخانة «؟» في المركز؛ سطرها 3 + ؟ + 7 = 15 يفرض ؟ = 5. ✓ الخيار b. يمكن التحقّق: العمود 1 + ؟ + 9 = 15 يعطي 5 أيضًا، والقطر 8 + ؟ + 2 = 15 كذلك. ثلاثة تحقّقات متوافقة. الفخّ a (6): أخذنا المجموع 16 بدل 15، بالخطأ في سطر مرجعي. الفخّ c (4): جمعنا 3 + 7 + 1 فقط دون تثبيت المجموع الهدف الصحيح. الفخّ d (7): نسخنا قيمة مجاورة في الشبكة بدل الحساب.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82f2deb6-1c85-5842-82c4-fcbb63e447a0', '77cf718d-7b55-55cf-a6dd-de899ee244f9', 'قاعدة واحدة تربط العددين العلويين بالعدد السفلي في كل مثلّث. أوجد العدد السفلي للمثلّث الأخير («؟»). <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="1.5"><line x1="10" y1="22" x2="18" y2="55"/><line x1="26" y1="22" x2="18" y2="55"/><line x1="42" y1="22" x2="50" y2="55"/><line x1="58" y1="22" x2="50" y2="55"/><line x1="74" y1="22" x2="82" y2="55"/><line x1="90" y1="22" x2="82" y2="55"/></g><g stroke="#1e293b" stroke-width="1.5" fill="#e2e8f0"><circle cx="10" cy="22" r="9"/><circle cx="26" cy="22" r="9"/><circle cx="18" cy="60" r="9"/><circle cx="42" cy="22" r="9"/><circle cx="58" cy="22" r="9"/><circle cx="50" cy="60" r="9"/><circle cx="74" cy="22" r="9"/><circle cx="90" cy="22" r="9"/><circle cx="82" cy="60" r="9" fill="#fee2e2"/></g><g font-size="11" text-anchor="middle" fill="#1e293b"><text x="10" y="26">3</text><text x="26" y="26">4</text><text x="18" y="64">11</text><text x="42" y="26">2</text><text x="58" y="26">5</text><text x="50" y="64">9</text><text x="74" y="26">4</text><text x="90" y="26">6</text><text x="82" y="64" fill="#ef4444">?</text></g></svg>', '[{"id":"a","text":"22"},{"id":"b","text":"24"},{"id":"c","text":"10"},{"id":"d","text":"23"}]'::jsonb, 'd', 'القاعدة: العدد السفلي = (جداء العددين العلويين) − 1. نستنتجها من المثلّثين الكاملين: 3×4 − 1 = 11 ✓ و2×5 − 1 = 9 ✓. هي القاعدة الوحيدة التي تصلح للاثنين. نطبّقها: 4×6 − 1 = 24 − 1 = 23. ✓ الخيار d. الفخّ b (24): حسبنا الجداء 4×6 لكن نسينا طرح 1. الفخّ c (10): جمعنا 4 + 6 ثم عدّلنا، بالخلط بين المجموع والجداء. الفخّ a (22): طرحنا 2 بدل 1، بالخطأ في الثابت.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b450c4b4-18f0-50ad-82a1-97f14cecf3f1', '77cf718d-7b55-55cf-a6dd-de899ee244f9', 'لتحضير شراب بالمذاق نفسه، يلزم 12 كأسًا من الماء مقابل 3 كؤوس من المركّز. كم كأس ماء لـ 5 كؤوس من المركّز؟ <svg viewBox="0 0 100 100"><g font-size="9" fill="#1e293b"><text x="4" y="20">3 concentré</text><text x="4" y="58">5 concentré</text></g><g stroke="#1e293b" stroke-width="1"><rect x="4" y="24" width="12" height="10" fill="#fca5a5"/><rect x="16" y="24" width="12" height="10" fill="#fca5a5"/><rect x="28" y="24" width="12" height="10" fill="#fca5a5"/><rect x="4" y="62" width="12" height="10" fill="#fca5a5"/><rect x="16" y="62" width="12" height="10" fill="#fca5a5"/><rect x="28" y="62" width="12" height="10" fill="#fca5a5"/><rect x="40" y="62" width="12" height="10" fill="#fca5a5"/><rect x="52" y="62" width="12" height="10" fill="#fca5a5"/></g><g font-size="9" fill="#1e293b"><text x="50" y="32">+ 12 eau</text><text x="70" y="70" fill="#ef4444">+ ? eau</text></g></svg>', '[{"id":"a","text":"20"},{"id":"b","text":"14"},{"id":"c","text":"60"},{"id":"d","text":"36"}]'::jsonb, 'a', 'القاعدة: للحفاظ على المذاق نفسه، تبقى نسبة الماء/المركّز ثابتة. هنا 12 ÷ 3 = 4، إذن يلزم 4 كؤوس ماء لكل كأس مركّز. لـ 5 كؤوس مركّز: 5 × 4 = 20 كأس ماء. ✓ الخيار a. الفخّ b (14): استدلال جمعي — أضفنا فرق المركّز (5−3 = 2) إلى 12 بدل استعمال النسبة. الفخّ c (60): ضربنا 12 في 5 (العدد الكلي للمركّز) بدل الضرب في النسبة. الفخّ d (36): ضربنا 12 في 3، بإعادة استعمال عدد المركّز القديم. تُحفظ النسبة بضرب المعدّل، لا بالجمع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('888cb3c2-f40d-5312-82a4-5d9394a7dbca', '77cf718d-7b55-55cf-a6dd-de899ee244f9', 'تأمّل المتتالية واكتشف العدد الذي يحلّ مكان «؟»: 1, 2, 6, 24, 120, ؟', '[{"id":"a","text":"600"},{"id":"b","text":"720"},{"id":"c","text":"144"},{"id":"d","text":"840"}]'::jsonb, 'b', 'القاعدة الخفية: نضرب في عامل يكبر بمقدار 1 في كل خطوة. 1×2 = 2، 2×3 = 6، 6×4 = 24، 24×5 = 120، إذن الخطوة الموالية هي ×6: 120 × 6 = 720. ✓ الخيار b. الفخّ a (600): أبقينا على العامل نفسه (×5) بدل رفعه إلى ×6. الفخّ c (144): جمعنا الحدّين الأخيرين (120 + 24)، ردّ فعل من نوع فيبوناتشي لا يلائم المتتالية. الفخّ d (840): قفزنا عاملًا بالضرب في 7 بدل 6. يزيد العامل بمقدار 1 بالضبط في كل خطوة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ea9c5003-1a50-550f-95d7-de768f7c6af1', '3c755566-06b5-5a65-b56d-b233748d0617', 'iq-training-ar', 'إحماء الذكاء السيّال ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('96db6e0e-3e95-52d5-b762-5adec0116d89', 'ea9c5003-1a50-550f-95d7-de768f7c6af1', 'كل خانة تضيف نقطة واحدة مقارنة بالتي قبلها. كم عدد النقاط في الخانة الناقصة؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="38" width="20" height="24" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="16" cy="50" r="3" fill="#1d4ed8"/><rect x="30" y="38" width="20" height="24" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="37" cy="50" r="3" fill="#1d4ed8"/><circle cx="45" cy="50" r="3" fill="#1d4ed8"/><rect x="54" y="38" width="20" height="24" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="60" cy="50" r="3" fill="#1d4ed8"/><circle cx="68" cy="50" r="3" fill="#1d4ed8"/><circle cx="64" cy="43" r="3" fill="#1d4ed8"/><rect x="78" y="38" width="20" height="24" fill="none" stroke="#1d4ed8" stroke-width="2"/><text x="88" y="55" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/><circle cx=\"46\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"54\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/><circle cx=\"46\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"54\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"46\" cy=\"54\" r=\"3\" fill=\"#1d4ed8\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/><circle cx=\"46\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"54\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"46\" cy=\"54\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"54\" cy=\"54\" r=\"3\" fill=\"#1d4ed8\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1d4ed8\"/></svg>"}]'::jsonb, 'c', 'القاعدة الخفية: عدد النقاط يزداد بمقدار 1 في كل خانة — 1، 2، 3… ✓ فالخانة الناقصة يجب أن تحتوي على 4 نقاط، أي الخيار c. الخيار b (3 نقاط) يكرّر الخانة السابقة بدل الزيادة. الخيار a (نقطتان) يتراجع درجة واحدة. الخيار d (نقطة واحدة) يعود إلى بداية المتتالية تمامًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55d25c85-47ec-5251-ae5b-905df0921072', 'ea9c5003-1a50-550f-95d7-de768f7c6af1', 'قاعدة واحدة تؤثّر على المثلّث في كل مرحلة. ما الشكل الذي يأتي بعد ذلك؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="18,60 6,40 30,40" fill="none" stroke="#7c3aed" stroke-width="2"/><polygon points="45,60 33,40 57,40" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/><polygon points="72,60 60,40 84,40" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="94" y="54" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,62 36,40 64,40\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,62 36,40 64,40\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,40 36,62 64,62\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية: التعبئة تتناوب — فارغ، ممتلئ، فارغ… ✓ بعد المثلّث الفارغ يجب أن يكون التالي ممتلئًا، أي الخيار a. الخيار b فارغ: فهو يكرّر المرحلة السابقة بدل التناوب. الخيار c ممتلئ فعلًا لكنه مقلوب نحو الأسفل: والحال أنّ الشكل واتجاهه لم يتغيّرا قطّ في المتتالية. الخيار d يستبدل المثلّث بمربّع: نحن نغيّر اللون فقط، لا الشكل أبدًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('037c81e6-179b-56b2-9062-f60cf0685106', 'ea9c5003-1a50-550f-95d7-de768f7c6af1', 'في كل خانة، تتحرّك النقطة دائمًا زاوية واحدة نحو اليمين (في اتجاه عقارب الساعة). أين ستكون في الخانة الناقصة؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="38" width="22" height="22" fill="none" stroke="#0f766e" stroke-width="2"/><circle cx="11" cy="43" r="3.5" fill="#0f766e"/><rect x="32" y="38" width="22" height="22" fill="none" stroke="#0f766e" stroke-width="2"/><circle cx="49" cy="43" r="3.5" fill="#0f766e"/><rect x="58" y="38" width="22" height="22" fill="none" stroke="#0f766e" stroke-width="2"/><circle cx="75" cy="55" r="3.5" fill="#0f766e"/><rect x="84" y="38" width="22" height="22" fill="none" stroke="#0f766e" stroke-width="2"/><text x="95" y="55" font-size="15" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/><circle cx=\"56\" cy=\"44\" r=\"3.5\" fill=\"#0f766e\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/><circle cx=\"44\" cy=\"56\" r=\"3.5\" fill=\"#0f766e\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/><circle cx=\"56\" cy=\"56\" r=\"3.5\" fill=\"#0f766e\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/><circle cx=\"44\" cy=\"44\" r=\"3.5\" fill=\"#0f766e\"/></svg>"}]'::jsonb, 'b', 'القاعدة الخفية: تتقدّم النقطة زاوية واحدة في اتجاه عقارب الساعة في كل خانة — أعلى-يسار، أعلى-يمين، أسفل-يمين… ✓ والزاوية التالية في اتجاه عقارب الساعة هي أسفل-يسار، أي الخيار b. الخيار c (أسفل-يمين) يكرّر الخانة السابقة. الخيار a (أعلى-يمين) يتراجع درجة واحدة. الخيار d (أعلى-يسار) يعود إلى نقطة الانطلاق، كأنّ الدورة قد اكتملت من قبل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('953fa7dd-cc4d-59c7-a40f-1371abf15811', 'ea9c5003-1a50-550f-95d7-de768f7c6af1', 'نُركّب خانة اليسار وخانة الوسط: لا تُلوَّن الزاوية في النتيجة إلّا إذا كانت ملوّنة في خانة واحدة فقط من الخانتين (لا في كلتيهما). ما النتيجة؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="35" width="26" height="26" fill="none" stroke="#be123c" stroke-width="2"/><line x1="19" y1="35" x2="19" y2="61" stroke="#be123c" stroke-width="1"/><line x1="6" y1="48" x2="32" y2="48" stroke="#be123c" stroke-width="1"/><rect x="6" y="35" width="13" height="13" fill="#be123c"/><rect x="19" y="48" width="13" height="13" fill="#be123c"/><text x="42" y="52" font-size="16" fill="#64748b" text-anchor="middle">+</text><rect x="52" y="35" width="26" height="26" fill="none" stroke="#be123c" stroke-width="2"/><line x1="65" y1="35" x2="65" y2="61" stroke="#be123c" stroke-width="1"/><line x1="52" y1="48" x2="78" y2="48" stroke="#be123c" stroke-width="1"/><rect x="52" y="35" width="13" height="13" fill="#be123c"/><rect x="65" y="35" width="13" height="13" fill="#be123c"/><text x="88" y="52" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"37\" y=\"37\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><line x1=\"50\" y1=\"37\" x2=\"50\" y2=\"63\" stroke=\"#be123c\" stroke-width=\"1\"/><line x1=\"37\" y1=\"50\" x2=\"63\" y2=\"50\" stroke=\"#be123c\" stroke-width=\"1\"/><rect x=\"50\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"50\" y=\"50\" width=\"13\" height=\"13\" fill=\"#be123c\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"37\" y=\"37\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><line x1=\"50\" y1=\"37\" x2=\"50\" y2=\"63\" stroke=\"#be123c\" stroke-width=\"1\"/><line x1=\"37\" y1=\"50\" x2=\"63\" y2=\"50\" stroke=\"#be123c\" stroke-width=\"1\"/><rect x=\"37\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"37\" y=\"37\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><line x1=\"50\" y1=\"37\" x2=\"50\" y2=\"63\" stroke=\"#be123c\" stroke-width=\"1\"/><line x1=\"37\" y1=\"50\" x2=\"63\" y2=\"50\" stroke=\"#be123c\" stroke-width=\"1\"/><rect x=\"50\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"37\" y=\"50\" width=\"13\" height=\"13\" fill=\"#be123c\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"37\" y=\"37\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><line x1=\"50\" y1=\"37\" x2=\"50\" y2=\"63\" stroke=\"#be123c\" stroke-width=\"1\"/><line x1=\"37\" y1=\"50\" x2=\"63\" y2=\"50\" stroke=\"#be123c\" stroke-width=\"1\"/><rect x=\"37\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"50\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"37\" y=\"50\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"50\" y=\"50\" width=\"13\" height=\"13\" fill=\"#be123c\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية: تُلوَّن الزاوية فقط إذا كانت ملوّنة في خانة واحدة دون الأخرى. في خانة اليسار: أعلى-يسار وأسفل-يمين ملوّنتان؛ وفي الوسط: أعلى-يسار وأعلى-يمين. الزاوية أعلى-يسار ملوّنة في كلتيهما: فتنطفئ. ✓ تبقى أعلى-يمين وأسفل-يمين، أي الخيار a. الخيار d يجمع كل الزوايا الملوّنة دون أن يُطفئ أيًّا منها. الخيار c يبقي على أعلى-يسار المشتركة، التي كان يجب أن تختفي. الخيار b يبقي على زاوية واحدة فقط وينسى واحدة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2fbc3cd-cc5b-5a67-ab7d-babcee474877', 'ea9c5003-1a50-550f-95d7-de768f7c6af1', 'قاعدة واحدة تربط الخانات الثلاث الأولى. ما الشكل الذي يُكمل الخانة الأخيرة؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="15" cy="50" r="5" fill="none" stroke="#b45309" stroke-width="2"/><g stroke="#b45309" stroke-width="2" fill="none"><circle cx="38" cy="50" r="5"/><circle cx="38" cy="50" r="9"/></g><g stroke="#b45309" stroke-width="2" fill="none"><circle cx="63" cy="50" r="5"/><circle cx="63" cy="50" r="9"/><circle cx="63" cy="50" r="13"/></g><text x="88" y="55" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g stroke=\"#b45309\" stroke-width=\"2\" fill=\"none\"><circle cx=\"50\" cy=\"50\" r=\"5\"/><circle cx=\"50\" cy=\"50\" r=\"9\"/><circle cx=\"50\" cy=\"50\" r=\"13\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g stroke=\"#b45309\" stroke-width=\"2\" fill=\"none\"><circle cx=\"50\" cy=\"50\" r=\"5\"/><circle cx=\"50\" cy=\"50\" r=\"9\"/><circle cx=\"50\" cy=\"50\" r=\"13\"/><circle cx=\"50\" cy=\"50\" r=\"17\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g stroke=\"#b45309\" stroke-width=\"2\" fill=\"none\"><circle cx=\"50\" cy=\"50\" r=\"5\"/><circle cx=\"50\" cy=\"50\" r=\"9\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'القاعدة الخفية: عدد الدوائر المتراكزة يزداد بمقدار 1 في كل خانة — 1، 2، 3… ✓ فالخانة الأخيرة يجب أن تحتوي على 4 دوائر، أي الخيار b. الخيار a (3 دوائر) يكرّر الخانة السابقة بدل إضافة دائرة. الخيار c (دائرتان) يتراجع درجة واحدة. الخيار d (دائرة واحدة) يعود إلى الخانة الأولى تمامًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0fe46ced-c606-51f1-aa0b-3fe06a65f299', '3c755566-06b5-5a65-b56d-b233748d0617', 'iq-training-ar', '⭐ إحماء', 1, 50, 10, 'practice', 'admin', 1)
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
  ('e31be173-5250-547f-95db-ae7338128173', '0fe46ced-c606-51f1-aa0b-3fe06a65f299', 'قاعدة خفية تُحوّل الشكل في كل مرحلة: نُضيف خطًّا أفقيًّا واحدًا إضافيًّا داخل المربّع (0، ثم 1، ثم 2…). ما المرحلة التالية؟ <svg viewBox="0 0 100 100"><rect x="3" y="35" width="24" height="30" fill="none" stroke="#222" stroke-width="2"/><rect x="30" y="35" width="24" height="30" fill="none" stroke="#222" stroke-width="2"/><line x1="33" y1="50" x2="51" y2="50" stroke="#222" stroke-width="2"/><rect x="57" y="35" width="24" height="30" fill="none" stroke="#222" stroke-width="2"/><line x1="60" y1="45" x2="78" y2="45" stroke="#222" stroke-width="2"/><line x1="60" y1="55" x2="78" y2="55" stroke="#222" stroke-width="2"/><rect x="84" y="35" width="24" height="30" fill="none" stroke="#222" stroke-width="2" stroke-dasharray="3 3"/><text x="96" y="54" font-size="14" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"42\" x2=\"65\" y2=\"42\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"50\" x2=\"65\" y2=\"50\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"58\" x2=\"65\" y2=\"58\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"45\" x2=\"65\" y2=\"45\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"55\" x2=\"65\" y2=\"55\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"50\" y1=\"35\" x2=\"50\" y2=\"65\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"40\" y1=\"35\" x2=\"40\" y2=\"65\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"60\" y1=\"35\" x2=\"60\" y2=\"65\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"50\" x2=\"65\" y2=\"50\" stroke=\"#222\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية هي: +1 خط أفقي في كل مرحلة (0، 1، 2، إذن بعدها 3). الخانة التالية يجب أن تحتوي على 3 خطوط أفقية ← الخيار a ✓. الفخّ: الخيار b يكرّر خطّين (نسينا الإضافة)، والخيار d يعود إلى خطّ واحد (قراءة المتتالية بالمقلوب)، والخيار c يضع 3 خطوط فعلًا لكنها عموديّة (اتجاه خاطئ). نستنتج القاعدة ثم نطبّقها: 2 + 1 = 3 خطوط أفقيّة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9240cfd0-794a-5baf-892a-80a9091baf17', '0fe46ced-c606-51f1-aa0b-3fe06a65f299', 'قاعدة المجموعة: لا يدخل الشكل إلى الصندوق إلّا إذا كان ممتلئًا (مملوءًا بالأسود) وعليه صليب أبيض في المركز. أيّ شكل يستوفي الشرطين معًا؟ <svg viewBox="0 0 100 100"><circle cx="30" cy="32" r="14" fill="#222"/><line x1="24" y1="32" x2="36" y2="32" stroke="#fff" stroke-width="3"/><line x1="30" y1="26" x2="30" y2="38" stroke="#fff" stroke-width="3"/><rect x="58" y="18" width="28" height="28" fill="#222"/><line x1="64" y1="32" x2="80" y2="32" stroke="#fff" stroke-width="3"/><line x1="72" y1="24" x2="72" y2="40" stroke="#fff" stroke-width="3"/><text x="50" y="72" font-size="10" text-anchor="middle" fill="#222">PLEIN + croix = dans la boîte</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\" stroke=\"#222\" stroke-width=\"3\"/><line x1=\"50\" y1=\"38\" x2=\"50\" y2=\"62\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"#222\"/><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\" stroke=\"#fff\" stroke-width=\"4\"/><line x1=\"50\" y1=\"38\" x2=\"50\" y2=\"62\" stroke=\"#fff\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"24\" y=\"24\" width=\"52\" height=\"52\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\" stroke=\"#222\" stroke-width=\"3\"/><line x1=\"50\" y1=\"38\" x2=\"50\" y2=\"62\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'b', 'يجب أن يجتمع شرطان معًا: شكل ممتلئ وصليب أبيض في المركز. الخيار b وحده أسود ممتلئ مع صليب أبيض ← b ✓. الفخّ: الخيار c ممتلئ لكن بلا صليب (ينقصه شرط)، والخياران a وd يحملان صليبًا لكنهما فارغان (غير ممتلئين). حين تكون للقاعدة شرطان، يجب أن يتحقّق كلاهما — لا يكفي واحد فقط.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c76b7756-2e6b-51e9-a283-e56f05c898fc', '0fe46ced-c606-51f1-aa0b-3fe06a65f299', 'قاعدة خفية تحكم الحجم: تتغيّر الدائرة في الحجم بالتناوب كبيرة، صغيرة، كبيرة، صغيرة… ما الدائرة التي تأتي بعد ذلك؟ <svg viewBox="0 0 100 100"><circle cx="16" cy="50" r="13" fill="none" stroke="#222" stroke-width="2"/><circle cx="42" cy="50" r="6" fill="none" stroke="#222" stroke-width="2"/><circle cx="68" cy="50" r="13" fill="none" stroke="#222" stroke-width="2"/><circle cx="90" cy="50" r="9" fill="none" stroke="#888" stroke-width="2" stroke-dasharray="3 3"/><text x="90" y="54" font-size="11" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"10\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'd', 'القاعدة الخفية تُناوب الحجم: كبيرة، صغيرة، كبيرة، إذن بعدها صغيرة. الدائرة التالية صغيرة ← الخيار d ✓. الفخّ: الخيار b يستأنف دائرة كبيرة (نسينا التناوب)، والخيار c كبير وممتلئ معًا (غيّرنا التعبئة فضلًا عن الحجم)، والخيار a مربّع (غيّرنا الشكل). شيء واحد فقط يتغيّر هنا: الحجم الذي يتناوب.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('369d2ceb-7d3a-5c29-b5b2-12d993ca9d4b', '0fe46ced-c606-51f1-aa0b-3fe06a65f299', 'سلسلة تحويلات: لاحِظ كيف يتحوّل المثلّث في المثال الأعلى، ثم طبّق التحويل نفسه تمامًا على المثلّث الأسفل. ماذا يصير؟ <svg viewBox="0 0 100 100"><polygon points="18,8 8,26 28,26" fill="#222"/><text x="36" y="22" font-size="14" fill="#222">→</text><polygon points="68,8 50,18 68,28" fill="#222"/><text x="50" y="45" font-size="9" text-anchor="middle" fill="#888">exemple : pointe en haut devient pointe à gauche</text><polygon points="50,58 40,76 60,76" fill="#222"/><text x="68" y="71" font-size="14" fill="#222">→</text><text x="88" y="71" font-size="16" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"38,30 38,70 62,50\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"62,30 62,70 38,50\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,40 70,40 50,68\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,38 70,38 50,18\" fill=\"#222\"/></svg>"}]'::jsonb, 'b', 'في المثال، المثلّث الذي يشير إلى الأعلى يتحوّل إلى مثلّث يشير إلى اليسار (ربع دورة). والمثلّث الأسفل يشير هو أيضًا إلى الأعلى، إذن يجب أن يشير إلى اليسار ← الخيار b ✓. الفخّ: الخيار a يشير إلى اليمين (درنا في الاتجاه الخاطئ)، والخيار c يشير إلى الأسفل (نصف دورة، ربعان بدل ربع واحد)، والخيار d يشير إلى الأعلى (لم نُحوّل شيئًا). نُعيد إنتاج التحويل المعروض تمامًا: أعلى ← يسار.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f0ae987-0d1f-5208-a276-a99808d29c19', '0fe46ced-c606-51f1-aa0b-3fe06a65f299', 'تماثل بصري: الشكل على اليسار يتحوّل إلى الشكل على اليمين بقاعدة. طبّق القاعدة نفسها على الشكل الجديد. المربّع الفاتح هو إلى «مربّع داكن بالحجم نفسه» كما أنّ الدائرة الفاتحة هي إلى…؟ <svg viewBox="0 0 100 100"><rect x="6" y="30" width="20" height="20" fill="none" stroke="#222" stroke-width="2"/><text x="33" y="45" font-size="13" fill="#222">→</text><rect x="46" y="30" width="20" height="20" fill="#222"/><text x="78" y="45" font-size="13" fill="#222">| ?</text><circle cx="22" cy="78" r="20" fill="none" stroke="#222" stroke-width="2"/><text x="54" y="82" font-size="13" fill="#222">→</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"8\" fill=\"#222\"/></svg>"}]'::jsonb, 'a', 'القاعدة التي تُحوّل الزوج الأول هي: «الاحتفاظ بالشكل والحجم، مع التعبئة بالأسود» (المربّع الفارغ يصير مربّعًا ممتلئًا بالضلع نفسه؛ لا الشكل ولا الحجم يتغيّر). وبتطبيقها على الدائرة الفارغة (نصف القطر 20) تُنتج دائرة ممتلئة بنصف القطر نفسه 20 ← الخيار a ✓. الفخّ: الخيار b يحافظ على الحجم الصحيح لكنه يبقى فارغًا (لم نُطبّق التعبئة)، والخيار c ممتلئ لكنه يُغيّر الشكل إلى مربّع (نسخنا شكل النموذج بدل القاعدة)، والخيار d ممتلئ فعلًا لكنه مُصغَّر (نصف القطر 8 بدل 20: أضفنا تغييرًا في الحجم لا وجود له في القاعدة). الخيار a وحده دائرة ممتلئة بالحجم نفسه للنموذج.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a870f88-8b9c-5b7e-8079-96ebade0afd1', '0fe46ced-c606-51f1-aa0b-3fe06a65f299', 'اكتشف العلاقة الخفية: في كل شكل-مثال، عدد النقاط في الداخل يساوي عدد أضلاع المضلّع. المثلّث (3 أضلاع) يحتوي على 3 نقاط، والمربّع (4 أضلاع) يحتوي على 4 نقاط. كم نقطة يجب أن يحتوي المخمّس (5 أضلاع)؟ <svg viewBox="0 0 100 100"><polygon points="18,18 6,42 30,42" fill="none" stroke="#222" stroke-width="2"/><circle cx="18" cy="28" r="2" fill="#222"/><circle cx="14" cy="36" r="2" fill="#222"/><circle cx="22" cy="36" r="2" fill="#222"/><rect x="55" y="16" width="28" height="28" fill="none" stroke="#222" stroke-width="2"/><circle cx="63" cy="24" r="2" fill="#222"/><circle cx="75" cy="24" r="2" fill="#222"/><circle cx="63" cy="36" r="2" fill="#222"/><circle cx="75" cy="36" r="2" fill="#222"/><polygon points="50,58 68,71 61,90 39,90 32,71" fill="none" stroke="#222" stroke-width="2"/><text x="50" y="80" font-size="11" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"3 نقاط"},{"id":"b","text":"4 نقاط"},{"id":"c","text":"5 نقاط"},{"id":"d","text":"6 نقاط"}]'::jsonb, 'c', 'العلاقة الخفية هي: عدد النقاط = عدد الأضلاع. المثلّث (3 أضلاع) له 3 نقاط، والمربّع (4 أضلاع) له 4 نقاط؛ والمخمّس له 5 أضلاع، إذن 5 نقاط ← الخيار c ✓. الفخّ: الخيار b (4) ينسخ مجموع المربّع دون إعادة عدّ الأضلاع، والخيار a (3) ينسخ مجموع المثلّث، والخيار d (6) يضيف نقطة زائدة (خلط مع المسدّس). نستنتج القاعدة ثم نعدّ أضلاع المخمّس: 5.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('db6431d0-68af-5686-a150-7ded73153182', '3c755566-06b5-5a65-b56d-b233748d0617', 'iq-training-ar', '⚔️ تحدّي الذكاء السيّال ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
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
  ('114c8dd4-7fd4-5aa4-8ce6-3707101dfdbc', 'db6431d0-68af-5686-a150-7ded73153182', 'قاعدة جديدة: نُركّب الشبكتين الأوليين. لا تبقى النقطة في النتيجة إلّا إذا ظهرت في شبكة واحدة فقط من الاثنتين (لا في كلتيهما). أيّ شبكة هي النتيجة؟ <svg viewBox="0 0 100 100"><rect x="4" y="34" width="28" height="28" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="18" y1="34" x2="18" y2="62" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="48" x2="32" y2="48" stroke="#9ca3af" stroke-width="1"/><circle cx="11" cy="41" r="3" fill="#1f2937"/><circle cx="25" cy="55" r="3" fill="#1f2937"/><text x="36" y="53" font-size="14" fill="#1f2937">+</text><rect x="48" y="34" width="28" height="28" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="62" y1="34" x2="62" y2="62" stroke="#9ca3af" stroke-width="1"/><line x1="48" y1="48" x2="76" y2="48" stroke="#9ca3af" stroke-width="1"/><circle cx="55" cy="41" r="3" fill="#1f2937"/><circle cx="69" cy="41" r="3" fill="#1f2937"/><text x="80" y="53" font-size="14" fill="#1f2937">=</text><text x="90" y="53" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"75\" stroke=\"#9ca3af\" stroke-width=\"1\"/><line x1=\"25\" y1=\"50\" x2=\"75\" y2=\"50\" stroke=\"#9ca3af\" stroke-width=\"1\"/><circle cx=\"62\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"75\" stroke=\"#9ca3af\" stroke-width=\"1\"/><line x1=\"25\" y1=\"50\" x2=\"75\" y2=\"50\" stroke=\"#9ca3af\" stroke-width=\"1\"/><circle cx=\"37\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"75\" stroke=\"#9ca3af\" stroke-width=\"1\"/><line x1=\"25\" y1=\"50\" x2=\"75\" y2=\"50\" stroke=\"#9ca3af\" stroke-width=\"1\"/><circle cx=\"37\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"75\" stroke=\"#9ca3af\" stroke-width=\"1\"/><line x1=\"25\" y1=\"50\" x2=\"75\" y2=\"50\" stroke=\"#9ca3af\" stroke-width=\"1\"/><circle cx=\"37\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"37\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية هي «أو» حصري (XOR): نُبقي على خانة مسوَّدة فقط إذا كانت مُعلَّمة في واحدة بالضبط من الشبكتين. الشبكة 1 = أعلى-يسار + أسفل-يمين؛ الشبكة 2 = أعلى-يسار + أعلى-يمين. الخانة أعلى-يسار موجودة في كلتيهما ← فتُلغى. تبقى أعلى-يمين (الشبكة 2 وحدها) وأسفل-يمين (الشبكة 1 وحدها). ✓ الخيار a يُظهر هاتين النقطتين بالضبط (أعلى-يمين وأسفل-يمين). الخيار b هو الاتحاد (يحتفظ بالنقطة المشتركة أعلى-يسار، وهو الخطأ الكلاسيكي في «جمع كل شيء»). الخيار d هو أيضًا الاتحاد، أكثر ازدحامًا. الخيار c لا يُبقي إلّا على النقطة المشتركة، أي العكس التامّ للقاعدة (التقاطع). علّم نقطة فقط حين تظهر في شبكة واحدة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ec0d06b8-a733-5e6b-84fe-41284bc8f46a', 'db6431d0-68af-5686-a150-7ded73153182', 'سلسلة تحويل: لاحِظ كيف يتطوّر عدد أضلاع المضلّع من شكل إلى التالي، ثم مدّد المتتالية. ما الشكل الذي يأتي بعد ذلك؟ <svg viewBox="0 0 100 100"><polygon points="14,62 6,46 22,46" fill="none" stroke="#1f2937" stroke-width="2"/><rect x="30" y="42" width="18" height="18" fill="none" stroke="#1f2937" stroke-width="2"/><polygon points="64,40 73,47 70,58 58,58 55,47" fill="none" stroke="#1f2937" stroke-width="2"/><text x="84" y="56" font-size="16" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,22 68,34 74,54 62,72 38,72 26,54 32,34\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,24 70,38 62,62 38,62 30,38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,22 72,35 72,61 50,74 28,61 28,35\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'd', 'القاعدة الخفية: عدد الأضلاع يزداد بمقدار 1 في كل مرحلة. مثلّث (3) ← مربّع (4) ← مخمّس (5) ← ؟. إذن الشكل التالي يجب أن يكون له 6 أضلاع: مسدّس. ✓ الخيار d مسدّس (6 أضلاع): وهو الصحيح. الخيار b مخمّس (5 أضلاع) ويكرّر المرحلة السابقة دون تقدّم. الخيار c مربّع (4 أضلاع)، يعود درجتين إلى الوراء. الخيار a مسبّع (7 أضلاع)، يقفز درجة (2+ بدل 1+). عُدّ الأضلاع واحتفظ بالفارق الثابت 1+.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f7a70db-dcbf-5279-a1ef-6b960089be87', 'db6431d0-68af-5686-a150-7ded73153182', 'خاصّيتان تتغيّران بشكل مستقلّ على طول المتتالية: الشكل (دائرة / مربّع، بالتناوب) والتعبئة (فارغ / ممتلئ، بالتناوب). أيّ شكل يحتلّ الخانة «؟» <svg viewBox="0 0 100 100"><circle cx="14" cy="50" r="9" fill="none" stroke="#1f2937" stroke-width="2"/><rect x="30" y="41" width="18" height="18" fill="#1f2937" stroke="#1f2937" stroke-width="2"/><circle cx="66" cy="50" r="9" fill="none" stroke="#1f2937" stroke-width="2"/><text x="84" y="56" font-size="16" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"#1f2937\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"#1f2937\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'b', 'القاعدة الخفية: دورتان مستقلّتان نتابعهما كلًّا على حدة. الشكل يتناوب دائرة، مربّع، دائرة، … إذن الخانة الرابعة مربّع. والتعبئة تتناوب فارغ، ممتلئ، فارغ، … إذن الخانة الرابعة ممتلئة. الجواب يجمع الاثنين: مربّع ممتلئ. ✓ الخيار b (مربّع ممتلئ) يحترم الشكل = مربّع والتعبئة = ممتلئ. الخيار a (مربّع فارغ) له الشكل الصحيح لكنه يعكس التعبئة. الخيار d (دائرة ممتلئة) له التعبئة الصحيحة لكنه يُبقي الشكل السابق (نسيان تناوب الشكل). الخيار c (دائرة فارغة) يُخطئ في الخاصّيتين معًا. الفخّ الشائع: متابعة خاصّية واحدة فقط؛ والحال أنه يجب تقدّم الشكل والتعبئة كلٌّ في دورته.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea7afbc5-9240-5028-935d-7cf31cd6659b', 'db6431d0-68af-5686-a150-7ded73153182', 'سلسلة تحويل بأثرين مدمجين في كل خطوة: السهم يدور 90° في اتجاه عقارب الساعة وتظهر نقطة إضافية (1، ثم 2، ثم 3…). أيّ شكل يُكمل المتتالية؟ <svg viewBox="0 0 100 100"><line x1="14" y1="62" x2="14" y2="40" stroke="#1f2937" stroke-width="3"/><polygon points="14,34 9,44 19,44" fill="#1f2937"/><circle cx="14" cy="72" r="2.5" fill="#1f2937"/><line x1="40" y1="50" x2="62" y2="50" stroke="#1f2937" stroke-width="3"/><polygon points="68,50 58,45 58,55" fill="#1f2937"/><circle cx="46" cy="68" r="2.5" fill="#1f2937"/><circle cx="56" cy="68" r="2.5" fill="#1f2937"/><line x1="86" y1="40" x2="86" y2="62" stroke="#1f2937" stroke-width="3"/><polygon points="86,68 81,58 91,58" fill="#1f2937"/><circle cx="78" cy="34" r="2.5" fill="#1f2937"/><circle cx="86" cy="34" r="2.5" fill="#1f2937"/><circle cx="94" cy="34" r="2.5" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"60\" y1=\"40\" x2=\"38\" y2=\"40\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"32,40 42,34 42,46\" fill=\"#1f2937\"/><circle cx=\"38\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"40\" y1=\"40\" x2=\"62\" y2=\"40\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"68,40 58,34 58,46\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"44\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"56\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"60\" y1=\"40\" x2=\"38\" y2=\"40\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"32,40 42,34 42,46\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"44\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"56\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"60\" x2=\"50\" y2=\"38\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"50,32 44,42 56,42\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"70\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"44\" cy=\"70\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"56\" cy=\"70\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"70\" r=\"4\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'c', 'القاعدة الخفية تدمج أثرين متزامنين. الاتجاه: أعلى ← يمين ← أسفل ← ؟، أي 90°+ في اتجاه عقارب الساعة في كل خطوة، إذن التالي يشير إلى اليسار. النقاط: 1، 2، 3، … إذن المرحلة التالية فيها 4. ✓ الخيار c يجمع الاثنين: سهم نحو اليسار و4 نقاط. الخيار b فيه 4 نقاط فعلًا لكنّ السهم يشير إلى اليمين (دوران خاطئ، عودة إلى الوراء). الخيار a له الاتجاه الصحيح (يسار) لكن 3 نقاط فقط (نسيان 1+). الخيار d يُبقي 4 نقاط لكن سهمًا نحو الأعلى (قفز ربع دورة). طبّق دائمًا التحويلين معًا، لا واحدًا فقط.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cfef7dbe-0335-5e9b-a0d4-138eb8a62d02', 'db6431d0-68af-5686-a150-7ded73153182', 'مصفوفة 3×3، قاعدة جديدة بحسب السطر: نحصل على الخانة الثالثة بحذف المواقع المشغولة أيضًا في الخانة الثانية من الخانة الأولى (الخانة 1 ناقص الخانة 2). أيّ شكل يملأ الخانة الناقصة (أسفل اليمين)؟ <svg viewBox="0 0 100 100"><line x1="34" y1="4" x2="34" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="34" x2="96" y2="34" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#9ca3af" stroke-width="1"/><circle cx="12" cy="12" r="3" fill="#1f2937"/><circle cx="24" cy="12" r="3" fill="#1f2937"/><circle cx="12" cy="24" r="3" fill="#1f2937"/><circle cx="44" cy="12" r="3" fill="#1f2937"/><circle cx="56" cy="24" r="3" fill="#1f2937"/><circle cx="88" cy="12" r="3" fill="#1f2937"/><circle cx="76" cy="24" r="3" fill="#1f2937"/><circle cx="12" cy="44" r="3" fill="#1f2937"/><circle cx="24" cy="44" r="3" fill="#1f2937"/><circle cx="24" cy="56" r="3" fill="#1f2937"/><circle cx="56" cy="44" r="3" fill="#1f2937"/><circle cx="76" cy="44" r="3" fill="#1f2937"/><circle cx="88" cy="56" r="3" fill="#1f2937"/><circle cx="12" cy="76" r="3" fill="#1f2937"/><circle cx="24" cy="76" r="3" fill="#1f2937"/><circle cx="12" cy="88" r="3" fill="#1f2937"/><circle cx="24" cy="88" r="3" fill="#1f2937"/><circle cx="56" cy="76" r="3" fill="#1f2937"/><circle cx="44" cy="88" r="3" fill="#1f2937"/><circle cx="56" cy="88" r="3" fill="#1f2937"/><text x="76" y="86" font-size="16" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"40\" cy=\"40\" r=\"6\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"60\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"40\" cy=\"40\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"40\" cy=\"60\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"40\" cy=\"40\" r=\"6\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"40\" r=\"6\" fill=\"#1f2937\"/><circle cx=\"40\" cy=\"60\" r=\"6\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'b', 'القاعدة الخفية: الخانة 3 = الخانة 1، محذوفًا منها كلّ موقع مشغول من قبل في الخانة 2. تحقّق على السطر الأول: الخانة 1 تشغل أعلى-يسار، أعلى-يمين، أسفل-يسار؛ والخانة 2 تشغل أعلى-يسار وأسفل-يمين؛ نُزيل الموقع المشترك (أعلى-يسار) ← يبقى أعلى-يمين وأسفل-يسار، أي نقطتان، وهي بالضبط الخانة 3. والسطر الثاني يؤكّد ذلك: {أعلى-يسار، أعلى-يمين، أسفل-يمين} ناقص {أعلى-يمين} = {أعلى-يسار، أسفل-يمين}، نقطتان. السطر الأخير: الخانة 1 ممتلئة (أعلى-يسار، أعلى-يمين، أسفل-يسار، أسفل-يمين)، والخانة 2 تشغل أعلى-يمين، أسفل-يسار، أسفل-يمين؛ نُزيل هذه الثلاثة ← يبقى أعلى-يسار وحده. ✓ الخيار b نقطة واحدة في أعلى-يسار: وهو الصحيح. الخيار a يُبقي نقطتين (لم يُزِل إلّا جزءًا من المواقع المشتركة). الخيار d يُبقي 3 نقاط (يجمع أو ينسى الطرح). الخيار c يضع نقطة واحدة فعلًا لكن في أسفل-يسار، وهو موقع ألغته الخانة 2 بالذات. اطرح موقعًا موقعًا: لا تُبقِ إلّا ما لا تمسّه الخانة 2.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89eeb119-5cd7-5fd8-988e-4e45a3361601', 'db6431d0-68af-5686-a150-7ded73153182', 'قاعدة جديدة عليك اكتشافها: قطعة سوداء تدور حول زوايا مربّع في اتجاه عقارب الساعة؛ وفي كل خطوة يغلظ ضلع المربّع الذي يحمل القطعة (يصير خطًّا غليظًا). أيّ شكل يُكمل المتتالية؟ <svg viewBox="0 0 100 100"><rect x="6" y="38" width="22" height="22" fill="none" stroke="#1f2937" stroke-width="1.5"/><line x1="6" y1="38" x2="28" y2="38" stroke="#1f2937" stroke-width="4"/><circle cx="6" cy="38" r="3.5" fill="#1f2937"/><rect x="40" y="38" width="22" height="22" fill="none" stroke="#1f2937" stroke-width="1.5"/><line x1="62" y1="38" x2="62" y2="60" stroke="#1f2937" stroke-width="4"/><circle cx="62" cy="38" r="3.5" fill="#1f2937"/><rect x="74" y="38" width="22" height="22" fill="none" stroke="#1f2937" stroke-width="1.5"/><line x1="74" y1="60" x2="96" y2="60" stroke="#1f2937" stroke-width="4"/><circle cx="96" cy="60" r="3.5" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"30\" y1=\"30\" x2=\"30\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"30\" y1=\"30\" x2=\"30\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"30\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"30\" y1=\"70\" x2=\"70\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"30\" stroke=\"#1f2937\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية تدمج حركتين مترابطتين. القطعة تشغل الزوايا في اتجاه عقارب الساعة: زاوية أعلى-يسار ← زاوية أعلى-يمين ← زاوية أسفل-يمين ← بعدها زاوية أسفل-يسار. والضلع الغليظ هو دائمًا الذي يلي القطعة في هذا الاتجاه: أعلى، ثم يمين، ثم أسفل، إذن بعدها الضلع الأيسر. ✓ الخيار a يضع القطعة في أسفل-يسار ويُغلظ الضلع الأيسر: تتوافق الحركتان. الخيار b يُغلظ الضلع الأيسر فعلًا لكنه يُعيد القطعة إلى أعلى-يسار (عودة إلى الوراء). الخيار c يترك القطعة في أسفل-يسار لكنه يُغلظ الضلع الأسفل (الضلع السابق، لا التالي). الخيار d يخلط: القطعة في أسفل-يسار لكنّ الضلع الأعلى غليظ (درجتان من الفارق). قدّم القطعة والضلع الغليظ معًا، درجة واحدة في اتجاه عقارب الساعة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b51b1f11-7518-52d2-b9ab-ebad569eaf45', '3c755566-06b5-5a65-b56d-b233748d0617', 'iq-training-ar', '👑 نخبة الذكاء السيّال ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('12194ce2-dc24-5468-91c7-2fd34bbc45d4', 'b51b1f11-7518-52d2-b9ab-ebad569eaf45', 'اكتشف قاعدة هذه المتتالية: في كل خانة يتغيّر الشكل (مربّع ← دائرة ← مثلّث ← مربّع…) وتنقلب تعبئته (فارغ ↔ ممتلئ). أيّ شكل يحتلّ الخانة «؟» <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="3"><rect x="6" y="42" width="16" height="16" fill="#1e293b"/><circle cx="36" cy="50" r="8" fill="none"/><polygon points="58,42 66,58 50,58" fill="#1e293b"/></g><rect x="76" y="40" width="20" height="20" fill="none" stroke="#cbd5e1" stroke-width="2"/><text x="86" y="56" font-size="14" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"18\" fill=\"#1e293b\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"34\" y=\"34\" width=\"32\" height=\"32\" fill=\"#1e293b\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,32 68,68 32,68\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"34\" y=\"34\" width=\"32\" height=\"32\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'd', 'القاعدة الخفية: شيئان يتغيّران معًا في كل خطوة — الشكل يتبع الدورة مربّع ← دائرة ← مثلّث ← مربّع، والتعبئة تتناوب فارغ/ممتلئ. الخانة 1 مربّع ممتلئ، الخانة 2 دائرة فارغة، الخانة 3 مثلّث ممتلئ. إذن الخانة 4 تستعيد شكل المربّع (الدورة تُعيد الكرّة) وتعكس الممتلئ إلى فارغ: مربّع فارغ. ✓ الخيار d. الفخّ b: مربّع صحيح لكننا أبقينا الممتلئ بدل عكسه. الفخّ c: مثلّث فارغ — نسينا أنّ الشكل يعود إلى المربّع. الفخّ a: دائرة ممتلئة — شكل خاطئ وتعبئة خاطئة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75413116-872b-5946-9a25-82606146b3dd', 'b51b1f11-7518-52d2-b9ab-ebad569eaf45', 'ثلاث دوائر تتداخل. القاعدة الملاحَظة: الرمز الموضوع في منطقة يتوقّف على عدد الدوائر المتراكبة فيها — دائرة واحدة ← خطّ، دائرتان ← صليب، ثلاث دوائر ← نجمة. أيّ رمز يجب أن يحتلّ المنطقة المركزية المعلَّمة «؟»، المشتركة بين الدوائر الثلاث؟ <svg viewBox="0 0 100 100"><g fill="none" stroke="#1e293b" stroke-width="2"><circle cx="40" cy="42" r="26"/><circle cx="60" cy="42" r="26"/><circle cx="50" cy="60" r="26"/></g><line x1="22" y1="30" x2="30" y2="30" stroke="#1e293b" stroke-width="3"/><g stroke="#1e293b" stroke-width="2"><line x1="67" y1="26" x2="73" y2="32"/><line x1="73" y1="26" x2="67" y2="32"/></g><text x="50" y="50" font-size="12" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"5\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"38\" y1=\"38\" x2=\"62\" y2=\"62\" stroke=\"#1e293b\" stroke-width=\"5\"/><line x1=\"62\" y1=\"38\" x2=\"38\" y2=\"62\" stroke=\"#1e293b\" stroke-width=\"5\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 56,44 72,44 59,54 64,70 50,60 36,70 41,54 28,44 44,44\" fill=\"#1e293b\" stroke=\"#1e293b\" stroke-width=\"1\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"6\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'c', 'القاعدة الخفية: الرمز يرمّز عدد الدوائر المتراكبة في ذلك الموضع. والمفتاح يؤكّد ذلك — منطقة بدائرة واحدة تحمل خطًّا، ومنطقة بدائرتين تحمل صليبًا. والمنطقة المركزية تنتمي إلى الدوائر الثلاث معًا، إذن تحمل النجمة. ✓ الخيار c (النجمة). الفخّ a: الخطّ يصلح لدائرة واحدة فقط. الفخّ b: الصليب يصلح لدائرتين، لا لثلاث. الفخّ d: النقطة ليست ضمن رموز القاعدة (رمز مُختلَق).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2c3ea28b-010d-52d2-914f-54359b32ff37', 'b51b1f11-7518-52d2-b9ab-ebad569eaf45', 'قاعدة جديدة عليك استنتاجها: نُركّب شبكة اليسار وشبكة الوسط، لكن لا تنجو الحبّة إلّا إذا ظهرت في واحدة فقط من الشبكتين (إذا كانت في كلتيهما ألغت إحداهما الأخرى؛ وإذا لم تكن في أيّ منهما بقيت الخانة فارغة). أيّ شبكة هي النتيجة؟ <svg viewBox="0 0 100 100"><g stroke="#94a3b8" stroke-width="1" fill="none"><rect x="4" y="36" width="30" height="30"/><line x1="14" y1="36" x2="14" y2="66"/><line x1="24" y1="36" x2="24" y2="66"/><line x1="4" y1="46" x2="34" y2="46"/><line x1="4" y1="56" x2="34" y2="56"/></g><circle cx="9" cy="41" r="3" fill="#1e293b"/><circle cx="29" cy="41" r="3" fill="#1e293b"/><circle cx="19" cy="61" r="3" fill="#1e293b"/><text x="42" y="55" font-size="12" fill="#1e293b">+</text><g stroke="#94a3b8" stroke-width="1" fill="none"><rect x="52" y="36" width="30" height="30"/><line x1="62" y1="36" x2="62" y2="66"/><line x1="72" y1="36" x2="72" y2="66"/><line x1="52" y1="46" x2="82" y2="46"/><line x1="52" y1="56" x2="82" y2="56"/></g><circle cx="57" cy="41" r="3" fill="#1e293b"/><circle cx="77" cy="61" r="3" fill="#1e293b"/><circle cx="67" cy="61" r="3" fill="#1e293b"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#94a3b8\" stroke-width=\"1.5\" fill=\"none\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\"/><line x1=\"41.7\" y1=\"25\" x2=\"41.7\" y2=\"75\"/><line x1=\"58.3\" y1=\"25\" x2=\"58.3\" y2=\"75\"/><line x1=\"25\" y1=\"41.7\" x2=\"75\" y2=\"41.7\"/><line x1=\"25\" y1=\"58.3\" x2=\"75\" y2=\"58.3\"/></g><circle cx=\"67\" cy=\"33\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"67\" cy=\"67\" r=\"4\" fill=\"#1e293b\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#94a3b8\" stroke-width=\"1.5\" fill=\"none\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\"/><line x1=\"41.7\" y1=\"25\" x2=\"41.7\" y2=\"75\"/><line x1=\"58.3\" y1=\"25\" x2=\"58.3\" y2=\"75\"/><line x1=\"25\" y1=\"41.7\" x2=\"75\" y2=\"41.7\"/><line x1=\"25\" y1=\"58.3\" x2=\"75\" y2=\"58.3\"/></g><circle cx=\"33\" cy=\"33\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"50\" cy=\"67\" r=\"4\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#94a3b8\" stroke-width=\"1.5\" fill=\"none\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\"/><line x1=\"41.7\" y1=\"25\" x2=\"41.7\" y2=\"75\"/><line x1=\"58.3\" y1=\"25\" x2=\"58.3\" y2=\"75\"/><line x1=\"25\" y1=\"41.7\" x2=\"75\" y2=\"41.7\"/><line x1=\"25\" y1=\"58.3\" x2=\"75\" y2=\"58.3\"/></g><circle cx=\"33\" cy=\"33\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"67\" cy=\"33\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"50\" cy=\"67\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"67\" cy=\"67\" r=\"4\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#94a3b8\" stroke-width=\"1.5\" fill=\"none\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\"/><line x1=\"41.7\" y1=\"25\" x2=\"41.7\" y2=\"75\"/><line x1=\"58.3\" y1=\"25\" x2=\"58.3\" y2=\"75\"/><line x1=\"25\" y1=\"41.7\" x2=\"75\" y2=\"41.7\"/><line x1=\"25\" y1=\"58.3\" x2=\"75\" y2=\"58.3\"/></g><circle cx=\"50\" cy=\"50\" r=\"4\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية: إنها «أو حصري» (XOR). لا تنجو خانة إلّا إذا كانت لها حبّة في واحدة بالضبط من الشبكتين. الشبكة 1 = زاوية أعلى-يسار، زاوية أعلى-يمين، وسط-أسفل. الشبكة 2 = زاوية أعلى-يسار، وسط-أسفل، زاوية أسفل-يمين. الزاوية أعلى-يسار في الاثنتين ← تُلغى. والوسط-أسفل في الاثنتين ← يُلغى. يبقى: زاوية أعلى-يمين (الشبكة 1 وحدها) وزاوية أسفل-يمين (الشبكة 2 وحدها). النتيجة = حبّتان بالضبط: أعلى-يمين وأسفل-يمين، ولا شيء غيرهما. ✓ الخيار a (أعلى-يمين + أسفل-يمين). الفخّ b: احتفظنا بالتقاطع (أعلى-يسار + وسط-أسفل)، أي عكس القاعدة — أبقينا الخانات المشتركة بدل إلغائها. الفخّ c: أجرينا اتحاد الشبكتين (أعلى-يسار، أعلى-يمين، وسط-أسفل، أسفل-يمين) دون إلغاء شيء. الفخّ d: حبّة واحدة في المركز، موقع مُختلَق خارج الشبكتين.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b1c7690-5d00-5358-a319-be25c94a2a3b', 'b51b1f11-7518-52d2-b9ab-ebad569eaf45', 'متتالية عددية مخبّأة في الأشكال: كل مربّع يحتوي على عدد معيّن من النقاط. جِد القاعدة التي تربط حدًّا بالذي يليه، ثم أعطِ عدد نقاط الشكل «؟». الأعداد هي 2، 3، 5، 8، ثم ؟. <svg viewBox="0 0 100 100"><g stroke="#94a3b8" stroke-width="1" fill="none"><rect x="3" y="40" width="15" height="15"/><rect x="22" y="40" width="15" height="15"/><rect x="41" y="40" width="15" height="15"/><rect x="60" y="40" width="15" height="15"/><rect x="79" y="40" width="15" height="15"/></g><g fill="#1e293b"><circle cx="8" cy="45" r="2"/><circle cx="13" cy="50" r="2"/><circle cx="27" cy="44" r="2"/><circle cx="32" cy="44" r="2"/><circle cx="29" cy="51" r="2"/><circle cx="45" cy="44" r="2"/><circle cx="51" cy="44" r="2"/><circle cx="45" cy="51" r="2"/><circle cx="51" cy="51" r="2"/><circle cx="48" cy="47" r="2"/><circle cx="63" cy="43" r="2"/><circle cx="68" cy="43" r="2"/><circle cx="72" cy="43" r="2"/><circle cx="63" cy="48" r="2"/><circle cx="68" cy="48" r="2"/><circle cx="72" cy="48" r="2"/><circle cx="65" cy="52" r="2"/><circle cx="70" cy="52" r="2"/></g><text x="86" y="52" font-size="12" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"11"},{"id":"b","text":"13"},{"id":"c","text":"16"},{"id":"d","text":"10"}]'::jsonb, 'b', 'القاعدة الخفية: كل حدّ هو مجموع الحدّين السابقين (متتالية من نوع فيبوناتشي)، لا فارق ثابت. 2؛ 3؛ 2+3=5؛ 3+5=8؛ إذن التالي = 5+8 = 13. ✓ الخيار b (13). الفخّ a (11): أضفنا فارقًا ثابتًا قدره 3+ (8+3)، بالخلط مع متتالية حسابية. الفخّ d (10): حسبنا 8+2 (زوج حدود خاطئ). الفخّ c (16): ضاعفنا الحدّ الأخير (8×2)، قاعدة مُختلَقة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca9e0882-dc7b-5b7e-8df8-96500dbc186a', 'b51b1f11-7518-52d2-b9ab-ebad569eaf45', 'تماثل مصفوفي: «A إلى B كما C إلى ؟». من A إلى B يحدث شيئان في الوقت نفسه — الشريط يدور ربع دورة في اتجاه عقارب الساعة وعدد النقاط يُقسَم على اثنين. طبّق التحويل المزدوج نفسه تمامًا على C. <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="3"><line x1="6" y1="30" x2="30" y2="30"/></g><g fill="#1e293b"><circle cx="10" cy="40" r="2.5"/><circle cx="17" cy="40" r="2.5"/><circle cx="24" cy="40" r="2.5"/><circle cx="13" cy="46" r="2.5"/></g><text x="36" y="40" font-size="10" fill="#1e293b">:</text><g stroke="#1e293b" stroke-width="3"><line x1="48" y1="26" x2="48" y2="50"/></g><g fill="#1e293b"><circle cx="56" cy="34" r="2.5"/><circle cx="56" cy="42" r="2.5"/></g><text x="66" y="40" font-size="10" fill="#1e293b">::</text><g stroke="#1e293b" stroke-width="3"><line x1="74" y1="70" x2="98" y2="70"/></g><g fill="#1e293b"><circle cx="78" cy="80" r="2.5"/><circle cx="84" cy="80" r="2.5"/><circle cx="90" cy="80" r="2.5"/><circle cx="96" cy="80" r="2.5"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"26\" x2=\"50\" y2=\"54\" stroke=\"#1e293b\" stroke-width=\"4\"/><circle cx=\"62\" cy=\"34\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"62\" cy=\"46\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"32\" y1=\"50\" x2=\"68\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/><circle cx=\"40\" cy=\"62\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"52\" cy=\"62\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"26\" x2=\"50\" y2=\"54\" stroke=\"#1e293b\" stroke-width=\"4\"/><circle cx=\"62\" cy=\"32\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"62\" cy=\"42\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"62\" cy=\"52\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"62\" cy=\"62\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"32\" y1=\"50\" x2=\"68\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/><circle cx=\"44\" cy=\"62\" r=\"3\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية: تحويلان متزامنان. (1) الدوران: الشريط يدور ربع دورة في اتجاه عقارب الساعة. (2) الكمية: عدد النقاط يُقسَم على اثنين. بالنسبة إلى C، الشريط أفقي؛ وربع دورة في اتجاه عقارب الساعة يجعله عموديًّا. وتنتقل النقاط من 4 إلى 4÷2 = 2. ✓ الخيار a: شريط عمودي + نقطتان. الفخّ b: نسينا تدوير الشريط (ما زال أفقيًّا) مع قسمة النقاط قسمةً صحيحة. الفخّ d: شريط غير مُدار وقد بالغنا في التقليص (نقطة واحدة بدل اثنتين). الفخّ c: شريط مُدار جيّدًا لكننا أبقينا 4 نقاط (نسيان القسمة).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2226f50e-ebf7-5b13-b40d-e24000058c33', 'b51b1f11-7518-52d2-b9ab-ebad569eaf45', 'قاعدة جديدة عليك اكتشافها: في كل شكل، عدد أضلاع الشكل الخارجي يساوي دائمًا عدد النقاط الصغيرة التي يحتويها زائد واحد. خيار واحد فقط يحترم هذه القاعدة الخفية. أيّها؟ <svg viewBox="0 0 100 100"><polygon points="20,80 50,20 80,80" fill="none" stroke="#1e293b" stroke-width="3"/><circle cx="42" cy="62" r="3" fill="#1e293b"/><circle cx="58" cy="62" r="3" fill="#1e293b"/><text x="50" y="96" font-size="9" text-anchor="middle" fill="#64748b">exemple : 3 côtés, 2 points</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,24 72,40 64,68 36,68 28,40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"56\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,24 72,40 64,68 36,68 28,40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"42\" cy=\"52\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"50\" cy=\"52\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"58\" cy=\"52\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"42\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"58\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'd', 'القاعدة الخفية: الأضلاع = النقاط + 1 (يُظهر ذلك المثال: للمثلّث 3 أضلاع ويحتوي على نقطتين، و3 = 2 + 1). نختبر كل خيار. الخيار d: مربّع = 4 أضلاع، 3 نقاط ← 4 = 3 + 1 ✓. الخيار d يحترم القاعدة. الفخّ b: مربّع (4 أضلاع) بنقطتين ← يلزم 3 نقاط (4 = 2+1 خطأ). الفخّ c: مخمّس (5 أضلاع) بـ3 نقاط ← يلزم 4 نقاط. الفخّ a: مخمّس (5 أضلاع) بنقطة واحدة ← يلزم 4 نقاط. المفتاح هو ربط خاصّيتين (الأضلاع والنقاط) بصيغة واحدة، لا الحكم عليهما منفصلتين.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('980ec638-3ca1-5d43-80b7-ad553192c84f', '006becf5-229a-58e9-8a5c-c81818b22ae9', 'iq-training-ar', 'إحماء الهندسة والإدراك المكاني ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('0ef34084-d305-5447-9e86-7d4b1a1b2295', '980ec638-3ca1-5d43-80b7-ad553192c84f', 'يدور الشكل النموذجي ربع دورة (90°) في اتجاه عقارب الساعة. ما الرسم الذي نحصل عليه؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><line x1="30" y1="25" x2="30" y2="70" stroke="#1d4ed8" stroke-width="5"/><line x1="30" y1="70" x2="65" y2="70" stroke="#1d4ed8" stroke-width="5"/><circle cx="30" cy="25" r="6" fill="#1d4ed8"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"75\" y1=\"30\" x2=\"30\" y2=\"30\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><line x1=\"30\" y1=\"30\" x2=\"30\" y2=\"65\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><circle cx=\"75\" cy=\"30\" r=\"6\" fill=\"#1d4ed8\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"30\" y1=\"25\" x2=\"30\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><line x1=\"30\" y1=\"70\" x2=\"65\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><circle cx=\"30\" cy=\"25\" r=\"6\" fill=\"#1d4ed8\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"25\" y1=\"70\" x2=\"70\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><line x1=\"70\" y1=\"70\" x2=\"70\" y2=\"30\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><circle cx=\"25\" cy=\"70\" r=\"6\" fill=\"#1d4ed8\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"70\" y1=\"25\" x2=\"70\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><line x1=\"70\" y1=\"70\" x2=\"35\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><circle cx=\"70\" cy=\"25\" r=\"6\" fill=\"#1d4ed8\"/></svg>"}]'::jsonb, 'a', 'نتتبّع النقطة المرجعية. في النموذج توجد في الأعلى، عند طرف القضيب العمودي. ربع دورة في اتجاه عقارب الساعة ينقل الأعلى نحو اليمين: فتنتقل النقطة إلى أعلى اليمين ويصبح القضيب أفقيًّا، ثم تنزل الزاوية بعد ذلك. ✓ إنه الخيار a. الخيار b مطابق للنموذج (لا دوران). الخيار c دار في الاتجاه المعاكس (عكس عقارب الساعة). الخيار d له الشكل الصحيح لكن النقطة المرجعية في موضع خاطئ: فقد قُلب الشكل كما في مرآة بدل أن يُدار.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8442d8eb-98d6-5a92-91a7-29340698ff07', '980ec638-3ca1-5d43-80b7-ad553192c84f', 'هذا عَلَم نموذجي. اختر انعكاسه في مرآة عمودية (يسار-يمين). <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><line x1="30" y1="20" x2="30" y2="80" stroke="#0f766e" stroke-width="4"/><polygon points="30,22 62,34 30,46" fill="#0f766e" stroke="#0f766e" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"30\" y1=\"20\" x2=\"30\" y2=\"80\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"30,22 62,34 30,46\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"70\" y1=\"20\" x2=\"70\" y2=\"80\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"70,22 38,34 70,46\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"30\" y1=\"20\" x2=\"30\" y2=\"80\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"30,54 62,66 30,78\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"20\" y1=\"30\" x2=\"80\" y2=\"30\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"22,30 34,62 46,30\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'المرآة العمودية تبادل اليسار واليمين: تبقى السارية عمودية لكنها تنتقل إلى اليمين، والرايّة التي كانت تشير إلى اليمين صارت تشير إلى اليسار. ✓ إنه الخيار b. الخيار a مطابق للنموذج (لا انعكاس). الخيار c أنزل الرايّة إلى أسفل السارية: لكن مرآة اليسار-اليمين لا تغيّر الارتفاع. الخيار d أدار العَلَم كاملًا ربع دورة: هذا دوران لا انعكاس.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b996057-3ec6-5ac8-871f-b2c29d643291', '980ec638-3ca1-5d43-80b7-ad553192c84f', 'هذا التكديس مكوَّن من مكعبات متطابقة (لا مكعب مخفيًّا خلفه، والخلف ممتلئ حيث يلزم لكي يثبت البناء). كم عدد المكعبات فيه إجمالًا؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><g fill="#fde68a" stroke="#b45309" stroke-width="2"><rect x="20" y="66" width="20" height="20"/><rect x="40" y="66" width="20" height="20"/><rect x="60" y="66" width="20" height="20"/><rect x="20" y="46" width="20" height="20"/><rect x="40" y="46" width="20" height="20"/><rect x="20" y="26" width="20" height="20"/></g></svg>', '[{"id":"a","text":"5 مكعبات"},{"id":"b","text":"7 مكعبات"},{"id":"c","text":"6 مكعبات"},{"id":"d","text":"9 مكعبات"}]'::jsonb, 'c', 'نعدّ طابقًا طابقًا. في الأسفل: 3 مكعبات. في الوسط: مكعبان. في الأعلى: مكعب واحد. المجموع 3 + 2 + 1 = 6 مكعبات. ✓ إنه الخيار c. الخيار a (5) يُغفِل مكعبًا، غالبًا مكعب القمة. الخيار b (7) يضيف مكعبًا زائدًا. الخيار d (9) يفترض أن كل طابق ممتلئ (3 × 3) في حين يُظهر الشكل هرمًا على شكل سُلّم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b75734a-994d-5a50-ad8b-5d0eee187b7d', '980ec638-3ca1-5d43-80b7-ad553192c84f', 'واحد فقط من هذه المخططات (الرسوم المفرودة) يمكن طيّه ليكوّن مكعبًا مغلقًا بستة أوجه. أيها؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><g fill="#ddd6fe" stroke="#6d28d9" stroke-width="2"><rect x="42" y="10" width="16" height="16"/><rect x="42" y="26" width="16" height="16"/><rect x="26" y="42" width="16" height="16"/><rect x="42" y="42" width="16" height="16"/><rect x="58" y="42" width="16" height="16"/><rect x="42" y="58" width="16" height="16"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#ddd6fe\" stroke=\"#6d28d9\" stroke-width=\"2\"><rect x=\"18\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"50\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"66\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"58\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#ddd6fe\" stroke=\"#6d28d9\" stroke-width=\"2\"><rect x=\"26\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"58\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#ddd6fe\" stroke=\"#6d28d9\" stroke-width=\"2\"><rect x=\"26\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"42\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#ddd6fe\" stroke=\"#6d28d9\" stroke-width=\"2\"><rect x=\"42\" y=\"12\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"60\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"60\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"76\" width=\"16\" height=\"16\"/></g></svg>"}]'::jsonb, 'a', 'لصُنع مكعب نحتاج 6 مربّعات تنطوي دون أن يتراكب أيٌّ منها. الخيار a هو الصليب الكلاسيكي: صفّ من أربعة مربّعات (الجوانب) مع مربّع فوقه وآخر تحته (الأعلى والأسفل) — وينغلق بإحكام تامّ. ✓ الخيار c مستطيل ممتلئ 3 × 2: عند طيّه تتراكب الأوجه ويغيب الغطاء. الخيار b والخيار d يكوّنان عند الطيّ مربّعين يقعان في الموضع نفسه: فيبقى المكعب مثقوبًا من جهة ومُضاعَفًا من الأخرى.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be6c1085-4681-5e64-94f8-adea6253c5a6', '980ec638-3ca1-5d43-80b7-ad553192c84f', 'نريد ضمّ قطعتين، حافة مستقيمة إلى حافة مستقيمة، لإعادة تكوين مستطيل كامل. القطعة الأولى موجودة أدناه. أيُّ قطعة تُكمِلها تمامًا؟ <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="25,30 75,30 25,70" fill="#fca5a5" stroke="#b91c1c" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"25,30 75,30 75,70\" fill=\"#fca5a5\" stroke=\"#b91c1c\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"25,40 75,40 50,70\" fill=\"#fca5a5\" stroke=\"#b91c1c\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"30\" y=\"35\" width=\"40\" height=\"30\" fill=\"#fca5a5\" stroke=\"#b91c1c\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"75,30 75,70 25,70\" fill=\"#fca5a5\" stroke=\"#b91c1c\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'd', 'القطعة الأولى هي النصف العلوي الأيسر من مستطيل: وَتَرُها (الحافة المائلة) يمتدّ من الزاوية العليا اليمنى إلى الزاوية السفلى اليسرى. لإعادة تكوين المستطيل نحتاج المثلث الناقص، أي النصف السفلي الأيمن، الذي يكون لوَتَرِه الميلُ نفسه تمامًا فيلتصق بها. ✓ إنه الخيار d. الخيار a مثلث ميلُه في الاتجاه الآخر: إذا وُضع بمحاذاة النموذج ترك فجوة وتجاوز الحدود. الخيار b مثلث متساوي الساقين (رأسه إلى الأسفل)، وشكله لا يُكمِل المستطيل. الخيار c مستطيل ممتلئ بالفعل: إضافته تتجاوز المستطيل كثيرًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0e4f0aee-576b-5d25-8991-c3ad5267012f', '006becf5-229a-58e9-8a5c-c81818b22ae9', 'iq-training-ar', '⭐ إحماء', 1, 50, 10, 'practice', 'admin', 1)
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
  ('35240517-3da3-5ef3-bc43-cc817e8a9522', '0e4f0aee-576b-5d25-8991-c3ad5267012f', 'إليك شكلًا: عَلَم مثبَّت في أعلى سارية، يشير نحو اليمين. أيُّ الخيارات هو صورته في مرآة عمودية (يُعكَس اليسار واليمين)؟ <svg viewBox="0 0 100 100"><line x1="35" y1="15" x2="35" y2="85" stroke="#222" stroke-width="3"/><polygon points="35,18 70,30 35,42" fill="#222" stroke="#222" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"35\" y1=\"15\" x2=\"35\" y2=\"85\" stroke=\"#222\" stroke-width=\"3\"/><polygon points=\"35,58 70,70 35,82\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"35\" y1=\"15\" x2=\"35\" y2=\"85\" stroke=\"#222\" stroke-width=\"3\"/><polygon points=\"35,18 70,30 35,42\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"65\" y1=\"15\" x2=\"65\" y2=\"85\" stroke=\"#222\" stroke-width=\"3\"/><polygon points=\"65,18 30,30 65,42\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"65\" y1=\"15\" x2=\"65\" y2=\"85\" stroke=\"#222\" stroke-width=\"3\"/><polygon points=\"65,58 30,70 65,82\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'c', 'المرآة العمودية تبادل اليسار واليمين لكنها تُبقي الأعلى في الأعلى. فتنتقل السارية إلى اليمين، والعَلَم الذي كان يشير إلى اليمين يجب أن يشير إلى اليسار ← الخيار c ✓. الفخّ: b هو الشكل الأصلي دون تغيير (لا انعكاس)، و a يُبقي السارية في اليسار وينزل العَلَم فقط (خَلْطٌ بين المرآة العمودية والمرآة الأفقية)، و d يقلب الشكل من الأعلى إلى الأسفل إضافةً إلى الجهة (تحويل مزدوج، وليس مجرّد مرآة يسار-يمين).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80d3c94d-023e-5b77-b4ca-f6b0752b349a', '0e4f0aee-576b-5d25-8991-c3ad5267012f', 'القطعة نفسها على شكل «L» (4 مربّعات) تدور ربع دورة (90°) في اتجاه عقارب الساعة عند كل خطوة. إليك الاتجاهات 1 و2 و3. أيُّ شكل هو الاتجاه 4؟ <svg viewBox="0 0 100 100"><g fill="#222" stroke="#fff" stroke-width="1"><rect x="8" y="24" width="9" height="9"/><rect x="8" y="33" width="9" height="9"/><rect x="8" y="42" width="9" height="9"/><rect x="17" y="42" width="9" height="9"/><rect x="40" y="33" width="9" height="9"/><rect x="40" y="42" width="9" height="9"/><rect x="49" y="33" width="9" height="9"/><rect x="58" y="33" width="9" height="9"/><rect x="76" y="24" width="9" height="9"/><rect x="85" y="24" width="9" height="9"/><rect x="85" y="33" width="9" height="9"/><rect x="85" y="42" width="9" height="9"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#222\" stroke=\"#fff\" stroke-width=\"1\"><rect x=\"23\" y=\"32\" width=\"18\" height=\"18\"/><rect x=\"23\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"41\" y=\"32\" width=\"18\" height=\"18\"/><rect x=\"59\" y=\"32\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#222\" stroke=\"#fff\" stroke-width=\"1\"><rect x=\"32\" y=\"23\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"23\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"41\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"59\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#222\" stroke=\"#fff\" stroke-width=\"1\"><rect x=\"23\" y=\"32\" width=\"18\" height=\"18\"/><rect x=\"23\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"41\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"59\" y=\"50\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#222\" stroke=\"#fff\" stroke-width=\"1\"><rect x=\"23\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"41\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"59\" y=\"32\" width=\"18\" height=\"18\"/><rect x=\"59\" y=\"50\" width=\"18\" height=\"18\"/></g></svg>"}]'::jsonb, 'd', 'القطعة تظلّ دائمًا حرف «L» نفسه المكوَّن من 4 مربّعات؛ ندِيرها ربع دورة في اتجاه عقارب الساعة. في الاتجاه 3 يكون القضيب العمودي على اليمين والذراع في أعلى اليسار؛ وربع دورة إضافي في اتجاه عقارب الساعة ينقل القضيب إلى الوضع الأفقي في الأسفل مع صعود الذراع إلى اليمين ← الخيار d ✓. الفخّ: a هو الاتجاه 2 (ربع دورة إلى الوراء)، و b يكرّر الاتجاه 3 (نسينا أن نُدير)، و c هو حرف «L» مقلوب كما في مرآة (اتجاه خاطئ / قطعة معكوسة)، وهذا لا يحدث أبدًا بمجرّد دوران. نُبقي المربّعات الأربعة وندِير ربع دورة واحدة في اتجاه عقارب الساعة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ed6cad4-6e3b-5a28-89e4-ccd59d2ccaac', '0e4f0aee-576b-5d25-8991-c3ad5267012f', 'هذا التكديس من مكعبات متطابقة موضوع على شكل سُلّم. كم عدد المكعبات فيه إجمالًا (لا مكعب مخفيًّا خلفه)؟ <svg viewBox="0 0 100 100"><g fill="none" stroke="#222" stroke-width="2"><rect x="20" y="60" width="20" height="20"/><rect x="40" y="60" width="20" height="20"/><rect x="60" y="60" width="20" height="20"/><rect x="40" y="40" width="20" height="20"/><rect x="60" y="40" width="20" height="20"/><rect x="60" y="20" width="20" height="20"/></g></svg>', '[{"id":"a","text":"5 مكعبات"},{"id":"b","text":"6 مكعبات"},{"id":"c","text":"7 مكعبات"},{"id":"d","text":"9 مكعبات"}]'::jsonb, 'b', 'نعدّ المربّعات الظاهرة، وكلّها مكعبات (لا شيء مخفيًّا): الصفّ السفلي فيه 3، والصفّ الأوسط 2، والصفّ العلوي 1، أي 3 + 2 + 1 = 6 مكعبات ← الخيار b ✓. الفخّ: a (5) يُغفِل مكعبًا من صفٍّ ما، و c (7) يعدّ مكعبًا زائدًا، و d (9) يفترض مربّعًا كاملًا 3×3 في حين يترك السُّلّم فجوات. نجمع فقط المكعبات المرسومة فعلًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('809b61bc-2ac1-5a7b-800a-bfe3e4b072de', '0e4f0aee-576b-5d25-8991-c3ad5267012f', 'نطوي هذا المخطط للمكعب (صليب لاتيني، 6 مربّعات) لتكوين مكعب. يحمل المخطط قرصًا أسودَ على الذراع اليسرى وقرصًا أبيضَ (فارغًا) على الذراع اليمنى. أيُّ زوج من الرموز يقع على وجهين متقابلين من المكعب بعد طيّه؟ <svg viewBox="0 0 100 100"><g fill="none" stroke="#222" stroke-width="2"><rect x="40" y="10" width="20" height="20"/><rect x="20" y="30" width="20" height="20"/><rect x="40" y="30" width="20" height="20"/><rect x="60" y="30" width="20" height="20"/><rect x="40" y="50" width="20" height="20"/><rect x="40" y="70" width="20" height="20"/></g><circle cx="30" cy="40" r="6" fill="#222"/><circle cx="70" cy="40" r="6" fill="none" stroke="#222" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"50\" r=\"12\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"70\" cy=\"50\" r=\"12\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"50\" r=\"12\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"70\" cy=\"50\" r=\"12\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"50\" r=\"12\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/><circle cx=\"70\" cy=\"50\" r=\"12\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"50\" r=\"12\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"58\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'a', 'في الصليب اللاتيني، الذراعان الجانبيّتان (اليسرى واليمنى) هما الرفرفان المتقابلان: بعد الطيّ يصبحان وجهين متقابلين من المكعب. لذلك يقع القرص الأسود (الذراع اليسرى) مقابل القرص الأبيض (الذراع اليمنى) ← الخيار a ✓. الفخّ: b يُظهر قرصين أسودين و c قرصين أبيضين (في حين أن الرمزين مختلفان: ممتلئ وفارغ)، و d يستبدل القرص الأبيض بمربّع، وهو رمز لا وجود له في المخطط أصلًا. الذراعان المتقابلتان في الصليب تقعان دائمًا على وجهين متقابلين.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7cafe430-a055-571c-a708-3f23da30081c', '0e4f0aee-576b-5d25-8991-c3ad5267012f', 'نُراكِب هذين الشكلين الشفّافين مع الحفاظ على موضعهما الدقيق (مثلث كبير ومربّع صغير). أيُّ شكل نحصل عليه بتكديس أحدهما فوق الآخر؟ <svg viewBox="0 0 100 100"><polygon points="20,20 45,20 32,42" fill="none" stroke="#222" stroke-width="2"/><rect x="60" y="60" width="22" height="22" fill="none" stroke="#222" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"20,20 45,20 32,42\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"20,20 45,20 32,42\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"71\" cy=\"71\" r=\"12\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"20,20 45,20 32,42\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"60\" y=\"60\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"60,60 85,60 72,82\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"20\" y=\"20\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'c', 'المراكبة مع الحفاظ على الموضع الدقيق تعني أن كل شكل يبقى حيث كان: المثلث يبقى في أعلى اليسار والمربّع يبقى في أسفل اليمين، ويظهر الاثنان معًا ← الخيار c ✓. الفخّ: b يحوّل المربّع إلى دائرة (لا يحقّ لنا تغيير شكل)، و a يُخفي المربّع (نسينا شكلًا)، و d يبادل موضعَي الشكلين (في حين أن المراكبة تحافظ على المواضع). نُبقي الشكلين، كلٌّ في مكانه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3dfc91c-37b1-5510-a23c-8fcdd26ea73a', '0e4f0aee-576b-5d25-8991-c3ad5267012f', 'الحرف الكبير «F» موضوع باتجاهه الصحيح. أيُّ الخيارات هو انعكاسه في مرآة عمودية (يُعكَس اليسار واليمين)؟ <svg viewBox="0 0 100 100"><polygon points="40,15 70,15 70,25 50,25 50,45 65,45 65,55 50,55 50,85 40,85" fill="#222"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,15 70,15 70,25 50,25 50,45 65,45 65,55 30,55 30,85 40,85 40,55 30,55\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,15 70,15 70,25 50,25 50,45 65,45 65,55 50,55 50,85 40,85\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,85 70,85 70,75 50,75 50,55 65,55 65,45 50,45 50,15 40,15\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"60,15 30,15 30,25 50,25 50,45 35,45 35,55 50,55 50,85 60,85\" fill=\"#222\"/></svg>"}]'::jsonb, 'd', 'المرآة العمودية تعكس اليسار واليمين دون المساس بالأعلى/الأسفل: ينتقل القضيب العمودي للحرف «F» إلى اليمين ويتّجه فرعاه الآن نحو اليسار ← الخيار d ✓. الفخّ: b هو الحرف «F» الأصلي دون تغيير (لا انعكاس)، و c يقلب الحرف من الأعلى إلى الأسفل (الفرعان ينطلقان من الأسفل، وهذه مرآة أفقية لا عمودية)، و a شكل مشوّه ليس حرف «F» معكوسًا. في المرآة العمودية لا يتبادل سوى اليسار واليمين.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ed27948b-29ed-59ed-b1ab-568961395c0a', '006becf5-229a-58e9-8a5c-c81818b22ae9', 'iq-training-ar', '⚔️ تحدّي الهندسة والإدراك المكاني ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
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
  ('66d1f767-acea-5abf-a5b1-148eb058c4ea', 'ed27948b-29ed-59ed-b1ab-568961395c0a', 'تحمل هذه الزاوية القائمة نقطةً مرجعية سوداء صغيرة عند طرف ذراعها الأفقية. يدور الشكل ربع دورة (90°) في اتجاه عقارب الساعة. ما الرسم الذي نحصل عليه؟ <svg viewBox="0 0 100 100"><polyline points="30,30 30,70 70,70" fill="none" stroke="#1f2937" stroke-width="5"/><circle cx="70" cy="70" r="6" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,30 30,30 30,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,30 30,70 70,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><circle cx=\"70\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,30 30,30 30,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><circle cx=\"70\" cy=\"30\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,70 70,70 70,30\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'القاعدة: ‎+90°‎ في اتجاه عقارب الساعة. نتتبّع النقطة المرجعية الموضوعة عند طرف الذراع الأفقية، في أسفل اليمين. ربع دورة في اتجاه عقارب الساعة يرسل الأسفل نحو اليسار: فتنتقل النقطة إلى أسفل اليسار، وتصعد الزاوية القائمة إلى أعلى اليسار، وتنتصب الذراع نحو الأعلى ← الخيار a ✓. الفخّ: b هو النموذج دون تغيير (لا دوران)، و c له شكل الزاوية الصحيح لكنه يضع النقطة في أعلى اليمين — وهذا انعكاس مرآة لا دوران —، و d دار في الاتجاه المعاكس (عكس عقارب الساعة). أدِر ربع دورة واحدة في الاتجاه الصحيح وتتبّع المرجع.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5181f5e7-4b62-5485-87b9-a3214f8e7a7f', 'ed27948b-29ed-59ed-b1ab-568961395c0a', 'الحرف الكبير «R» باتجاهه الصحيح. أيُّ الخيارات هو انعكاسه في مرآة عمودية (يُعكَس اليسار واليمين، ويبقى الأعلى في الأعلى)؟ <svg viewBox="0 0 100 100"><polyline points="38,15 38,85" fill="none" stroke="#1f2937" stroke-width="5"/><path d="M38,15 H62 Q72,15 72,30 Q72,45 62,45 H38" fill="none" stroke="#1f2937" stroke-width="5"/><polyline points="50,45 70,85" fill="none" stroke="#1f2937" stroke-width="5"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"62,15 62,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><path d=\"M62,15 H38 Q28,15 28,30 Q28,45 38,45 H62\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><polyline points=\"50,45 30,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"38,15 38,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><path d=\"M38,15 H62 Q72,15 72,30 Q72,45 62,45 H38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><polyline points=\"50,45 70,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"38,15 38,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><path d=\"M38,85 H62 Q72,85 72,70 Q72,55 62,55 H38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><polyline points=\"50,55 70,15\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"62,15 62,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><path d=\"M62,85 H38 Q28,85 28,70 Q28,55 38,55 H62\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><polyline points=\"50,55 30,15\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"}]'::jsonb, 'a', 'المرآة العمودية تبادل اليسار واليمين دون المساس بالأعلى/الأسفل. ينتقل القضيب العمودي للحرف «R» إلى اليمين، وتنفتح الحلقة نحو اليسار، وتنطلق الساق المائلة نحو أسفل اليسار ← الخيار a ✓. الفخّ: b هو الحرف «R» الأصلي دون تغيير (لا انعكاس)، و c يقلب الحرف من الأعلى إلى الأسفل (الحلقة في الأسفل والساق نحو الأعلى: هذه مرآة أفقية لا عمودية)، و d يجمع القلبين معًا (يسار-يمين وأعلى-أسفل)، وهذا يعادل دورانًا بمقدار 180° لا مجرّد مرآة عمودية. لا يتبادل سوى اليسار واليمين.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1cb688cc-5ff0-515b-88c4-915aacbcd867', 'ed27948b-29ed-59ed-b1ab-568961395c0a', 'هذا التكديس مكوَّن من مكعبات متطابقة. كل مكعب ظاهر يستند إلى أرضية أو إلى مكعب آخر، ولا شيء مخفيًّا خلف الكومة. كم عدد المكعبات فيه إجمالًا؟ <svg viewBox="0 0 100 100"><g fill="none" stroke="#1f2937" stroke-width="2"><rect x="15" y="65" width="18" height="18"/><rect x="33" y="65" width="18" height="18"/><rect x="51" y="65" width="18" height="18"/><rect x="69" y="65" width="18" height="18"/><rect x="15" y="47" width="18" height="18"/><rect x="33" y="47" width="18" height="18"/><rect x="51" y="47" width="18" height="18"/><rect x="15" y="29" width="18" height="18"/><rect x="33" y="29" width="18" height="18"/><rect x="15" y="11" width="18" height="18"/></g></svg>', '[{"id":"a","text":"9 مكعبات"},{"id":"b","text":"10 مكعبات"},{"id":"c","text":"12 مكعبًا"},{"id":"d","text":"16 مكعبًا"}]'::jsonb, 'b', 'نجمع المكعبات طابقًا طابقًا، ولا نعدّ إلا المرسومة منها. في الأسفل: 4 مكعبات. فوقها: 3. ثم: 2. في القمة: 1. المجموع 4 + 3 + 2 + 1 = 10 مكعبات ← الخيار b ✓. الفخّ: a (9) يُغفِل مكعبًا من طابق ما، و c (12) يعدّ 4 + 4 + 2 + 2 بافتراض طوابق أكثر امتلاءً مما هي عليه، و d (16) يفترض مربّعًا كاملًا 4×4 في حين أن الشكل سُلّم مثقوب. نعدّ المربّعات الموجودة بالضبط.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6c334633-b944-57a2-9517-d5f593b9a4f0', 'ed27948b-29ed-59ed-b1ab-568961395c0a', 'واحد فقط من هذه الأشكال الأربعة يملك محور تماثل عموديًّا: يمكن طيّه على طول خطٍّ عمودي فينطبق النصفان تمامًا. أيها؟', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,15 20,80 80,80\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"50\" y1=\"15\" x2=\"50\" y2=\"80\" stroke=\"#1f2937\" stroke-width=\"2\" stroke-dasharray=\"3 3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"25,20 75,20 60,80 40,80\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><polygon points=\"55,30 75,45 60,60\" fill=\"#1f2937\" stroke=\"#1f2937\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"22\" y=\"35\" width=\"56\" height=\"30\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"38\" cy=\"50\" r=\"8\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,25 55,25 70,50 55,75 30,75 45,50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'a', 'وجود محور تماثل عمودي يعني أن النصف الأيسر هو صورة مرآتية تامّة للنصف الأيمن. المثلث المتساوي الساقين في a رأسه فوق منتصف قاعدته تمامًا: فالخطّ العمودي المارّ بالرأس يقسم الشكل إلى نصفين متطابقين ← الخيار a ✓. الفخّ: b متماثل تقريبًا لكن السهم الصغير الممتلئ مرسوم على اليمين فقط، وهذا يكسر التوازن بين اليسار واليمين؛ و c قرصه منزاح نحو اليسار، فالنصف الأيمن فارغ؛ و d ينطوي بشكل صحيح على خطٍّ أفقي (الأعلى = الأسفل) لا على خطٍّ عمودي (الرؤوس على اليسار واليمين بشكل غير متناظر). تحقّق دائمًا أنه المحور المطلوب فعلًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('91fe4dc0-58a2-5aaf-a36b-7791b9b4ae6a', 'ed27948b-29ed-59ed-b1ab-568961395c0a', 'واحد فقط من هذه المخططات المفرودة (6 مربّعات) يمكن طيّه ليكوّن مكعبًا مغلقًا بستة أوجه، دون أن يتراكب أيُّ مربّع ودون أن يغيب أيُّ وجه. أيها؟', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#e5e7eb\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"42\" y=\"12\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"60\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#e5e7eb\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"26\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"44\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#e5e7eb\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"34\" y=\"12\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"60\" width=\"16\" height=\"16\"/><rect x=\"50\" y=\"60\" width=\"16\" height=\"16\"/><rect x=\"50\" y=\"76\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#e5e7eb\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"42\" y=\"4\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"20\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"36\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"52\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"68\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"84\" width=\"16\" height=\"16\"/></g></svg>"}]'::jsonb, 'a', 'نحتاج 6 مربّعات تعطي عند الطيّ الأوجه الستة دون تراكب. الخيار a هو الصليب الكلاسيكي: عمود من أربعة مربّعات (الجوانب الأربعة) مع مربّع مُضاف إلى يسار المربّع الثاني وآخر إلى يمينه (الأعلى والأسفل)؛ وينغلق بإحكام تامّ ← الخيار a ✓. الفخّ: b كتلة ممتلئة 3×2 — عند طيّها تتراكب مربّعات ويغيب وجه؛ و c يكوّن بعد الطيّ مربّعين يقعان على الوجه نفسه فيترك المكعب مثقوبًا؛ و d عمود من ستة مربّعات (1×6): عند لفّه يصنع حلقة من الأوجه ويغيب الأعلى والأسفل. لا تنجح إلا الترتيبة على شكل «صليب/T» دون تكديس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6aa72c74-d465-56a8-b993-cf20b7d6e1c2', 'ed27948b-29ed-59ed-b1ab-568961395c0a', 'نُراكِب هاتين الشريحتين الشفّافتين مع الحفاظ على موضعهما الدقيق: على اليسار شريحة تحمل فقط القطر «\» لمربّع واحد، وعلى اليمين شريحة تحمل فقط القطر «/» للمربّع نفسه. أيُّ شكل نحصل عليه بتكديس الشريحتين؟ <svg viewBox="0 0 100 100"><g fill="none" stroke="#1f2937" stroke-width="2"><rect x="8" y="35" width="30" height="30"/><line x1="8" y1="35" x2="38" y2="65"/><rect x="58" y="35" width="30" height="30"/><line x1="88" y1="35" x2="58" y2="65"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\"/><line x1=\"70\" y1=\"30\" x2=\"30\" y2=\"70\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\"/><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"70\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\"/><line x1=\"70\" y1=\"30\" x2=\"30\" y2=\"70\"/><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/></g></svg>"}]'::jsonb, 'a', 'المراكبة تُبقي كل ما تحمله كل شريحة ولا تضيف شيئًا آخر. لذلك نُبقي محيط المربّع، إضافةً إلى القطرين «\» و«/» اللذين يتقاطعان في المركز ويكوّنان حرف X ← الخيار a ✓. الفخّ: b لم يُبقِ إلا قطرًا واحدًا (نسينا شريحة)، و c استبدل القطرين بصليب قائم أفقي + عمودي (خطوط خاطئة: المراكبة لا تُدير الخطوط)، و d يضيف خطًّا أفقيًّا لا وجود له في أيٍّ من الشريحتين (لا نخترع خطًّا أبدًا عند المراكبة). نجمع خطوط الشريحتين بالضبط، لا أكثر.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('62bcfe47-2174-541d-87d4-64f3df9b0a6e', '006becf5-229a-58e9-8a5c-c81818b22ae9', 'iq-training-ar', '👑 نخبة الهندسة والإدراك المكاني ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('a1a239ce-d70d-54d0-8ab7-39f0a75a46a0', '62bcfe47-2174-541d-87d4-64f3df9b0a6e', 'الشكل النموذجي (حرف «L» مع كرة حمراء عند طرف القضيب العمودي) يدور ربع دورة (90°) في الاتجاه المعاكس لعقارب الساعة (عكس عقارب الساعة). أيُّ خيار يُظهر النتيجة؟ <svg viewBox="0 0 100 100"><polyline points="30,20 30,75 75,75" fill="none" stroke="#1e293b" stroke-width="6"/><circle cx="30" cy="20" r="7" fill="#ef4444" stroke="#1e293b" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"20,70 75,70 75,25\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"20\" cy=\"70\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"80,30 25,30 25,75\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"80\" cy=\"30\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,20 30,75 75,75\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"20\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"20,30 75,30 75,75\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"20\" cy=\"30\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية: ربع دورة عكس عقارب الساعة يرسل الأعلى نحو اليسار والأسفل نحو اليمين. في النموذج تقع الكرة في الأعلى تمامًا وزاوية الحرف «L» في أسفل اليسار؛ وبعد الدوران عكس عقارب الساعة تنزل الكرة نحو اليسار (أسفل اليسار، عند طرف قضيب أفقي) وتصعد الزاوية إلى اليمين. ✓ الخيار a (الكرة في أسفل اليسار، قضيب أفقي نحو زاوية في اليمين، ثم صعود). الفخّ b: هذا الدوران في اتجاه عقارب الساعة — انطلقت الكرة نحو اليمين (أعلى اليمين)، أي الاتجاه الخاطئ. الفخّ c: هذا الشكل الأصلي، لا دوران. الفخّ d: الشكل مُدار بشكل صحيح لكن الكرة في الجهة الخاطئة — وهذا انعكاس مرآة لا دوران.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b45eebd2-e70a-534f-9495-eaa033e7e335', '62bcfe47-2174-541d-87d4-64f3df9b0a6e', 'إليك عَلَمًا نموذجيًّا: سارية على اليسار، تحمل رايّةً تشير نحو اليمين في النصف العلوي من السارية. أيُّ خيار هو صورته بالانعكاس في مرآة أفقية (محور أفقي، يتبادل الأعلى والأسفل)؟ <svg viewBox="0 0 100 100"><line x1="25" y1="15" x2="25" y2="85" stroke="#0f766e" stroke-width="4"/><polygon points="25,20 60,30 25,40" fill="#0f766e" stroke="#0f766e" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"25\" y1=\"15\" x2=\"25\" y2=\"85\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"25,60 60,70 25,80\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"25\" y1=\"15\" x2=\"25\" y2=\"85\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"25,20 60,30 25,40\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"75\" y1=\"15\" x2=\"75\" y2=\"85\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"75,60 40,70 75,80\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"75\" y1=\"15\" x2=\"75\" y2=\"85\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"75,20 40,30 75,40\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'القاعدة الخفية: المرآة الأفقية تبادل الأعلى والأسفل لكنها تُبقي اليسار واليمين دون تغيير. لذلك تبقى السارية على اليسار، والرايّة التي كانت في الأعلى تنزل إلى النصف السفلي مع استمرارها في الإشارة نحو اليمين. ✓ الخيار a. الفخّ b: هذا النموذج دون تغيير (لا انعكاس). الفخّ d: انتقلت السارية إلى اليمين وصارت الرايّة تشير إلى اليسار — وهذه مرآة عمودية (يسار-يمين) لا أفقية. الفخّ c: طُبِّقت المرآتان معًا (وهو ما يعادل دورانًا بمقدار 180°)، السارية على اليمين والرايّة في الأسفل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f0c2056-1f59-5029-a19e-e773c805c0df', '62bcfe47-2174-541d-87d4-64f3df9b0a6e', 'هذا السُّلّم مرسوم بالكامل: كل المكعبات المتطابقة ظاهرة، ولا مكعب مخفيًّا. كم عدد المكعبات فيه إجمالًا؟ <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="1.5" fill="#cbd5e1"><rect x="20" y="66" width="18" height="18"/><rect x="38" y="66" width="18" height="18"/><rect x="56" y="66" width="18" height="18"/><rect x="20" y="48" width="18" height="18"/><rect x="38" y="48" width="18" height="18"/><rect x="20" y="30" width="18" height="18"/></g></svg>', '[{"id":"a","text":"4"},{"id":"b","text":"5"},{"id":"c","text":"6"},{"id":"d","text":"7"}]'::jsonb, 'c', 'القاعدة: كل المكعبات ظاهرة، فيكفي عدّها صفًّا صفًّا دون افتراض شيء مخفيّ. الصفّ السفلي: 3 مكعبات. الصفّ الأوسط: مكعبان. القمة: مكعب واحد. 3 + 2 + 1 = 6. ✓ الخيار c. الفخّ a (4): أغفلنا صفًّا كاملًا. الفخّ b (5): عددنا الصفّ الأوسط مكعبًا واحدًا بدل مكعبين. الفخّ d (7): أضفنا مكعبًا مخفيًّا، في حين أن النصّ يوضّح أنه لا مكعب مخفيًّا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fde6d2de-ee50-503f-8eb5-18379679c30c', '62bcfe47-2174-541d-87d4-64f3df9b0a6e', 'واحد فقط من هذه المخططات (المفرودة) ينطوي إلى مكعب مغلق، دون وجه ناقص ودون وجه يتراكب. أيها؟ <svg viewBox="0 0 100 100"><text x="50" y="46" font-size="11" text-anchor="middle" fill="#1e293b">6 carrés = patron du cube.</text><text x="50" y="62" font-size="11" text-anchor="middle" fill="#1e293b">Lequel se replie sans faute ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#a7f3d0\"><rect x=\"20\" y=\"20\" width=\"18\" height=\"18\"/><rect x=\"38\" y=\"20\" width=\"18\" height=\"18\"/><rect x=\"38\" y=\"38\" width=\"18\" height=\"18\"/><rect x=\"56\" y=\"38\" width=\"18\" height=\"18\"/><rect x=\"56\" y=\"56\" width=\"18\" height=\"18\"/><rect x=\"74\" y=\"56\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#a7f3d0\"><rect x=\"20\" y=\"46\" width=\"18\" height=\"18\"/><rect x=\"38\" y=\"46\" width=\"18\" height=\"18\"/><rect x=\"56\" y=\"46\" width=\"18\" height=\"18\"/><rect x=\"74\" y=\"46\" width=\"18\" height=\"18\"/><rect x=\"20\" y=\"28\" width=\"18\" height=\"18\"/><rect x=\"38\" y=\"28\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#a7f3d0\"><rect x=\"32\" y=\"24\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"24\" width=\"18\" height=\"18\"/><rect x=\"32\" y=\"42\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"42\" width=\"18\" height=\"18\"/><rect x=\"32\" y=\"60\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"60\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#a7f3d0\"><rect x=\"24\" y=\"34\" width=\"18\" height=\"18\"/><rect x=\"42\" y=\"34\" width=\"18\" height=\"18\"/><rect x=\"24\" y=\"52\" width=\"18\" height=\"18\"/><rect x=\"42\" y=\"52\" width=\"18\" height=\"18\"/><rect x=\"60\" y=\"34\" width=\"18\" height=\"18\"/><rect x=\"78\" y=\"34\" width=\"18\" height=\"18\"/></g></svg>"}]'::jsonb, 'a', 'القاعدة: المخطط الصالح للمكعب يملك 6 مربّعات بحيث لا يتراكب أيٌّ منها عند الطيّ ويكون كل وجه فريدًا. الخيار a هو السُّلّم الكلاسيكي على شكل «زِغزاغ» (شكل درجات سُلّم 2-2-2 منزاحة): إنه أحد المخططات الأحد عشر الصالحة للمكعب، وينغلق بإحكام تامّ. ✓ الخيار a. الفخّ b: صفّ من أربعة مربّعات مع مربّعين مُضافين من الجهة نفسها (فوق المربّعين الأولين)؛ عند الطيّ يقع هذان على الوجه نفسه ويبقى وجه ناقصًا. الفخّ c: مستطيل ممتلئ 2×3؛ عند طيّه يتراكب وجهان ويغيب غطاء. الفخّ d: كتلة مربّعة 2×2 ممدودة بذراع من مربّعين؛ الكتلة 2×2 تجعل عدة أوجه تلتقي في الموضع نفسه، فتتراكب المربّعات.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('838656dd-aaff-5215-b7b9-d6e977415dbb', '62bcfe47-2174-541d-87d4-64f3df9b0a6e', 'نُراكِب بالضبط الشكلين على اليسار (المركز نفسه)، وتُحفظ جميع الخطوط. أيُّ خيار يُظهر النتيجة؟ على اليسار: مثلث رأسه إلى الأعلى؛ على اليمين: مثلث رأسه إلى الأسفل (بالحجم نفسه). <svg viewBox="0 0 100 100"><polygon points="22,58 46,58 34,30" fill="none" stroke="#1e293b" stroke-width="4"/><text x="55" y="50" font-size="16" text-anchor="middle" fill="#1e293b">+</text><polygon points="66,30 90,30 78,58" fill="none" stroke="#1e293b" stroke-width="4"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"28,66 72,66 50,28\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><polygon points=\"28,38 72,38 50,76\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"28,66 72,66 50,28\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"34\" width=\"40\" height=\"36\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"28,66 72,66 50,28\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><polygon points=\"36,52 64,52 50,72\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'a', 'القاعدة: المراكبة تُبقي جميع خطوط الشكلين دون تحويل أو محو. مثلث رأسه إلى الأعلى مكدّس فوق مثلث رأسه إلى الأسفل، بالحجم نفسه والمركز نفسه، يعطي النجمة السداسية (رمز «نجمة داود») حيث يتقاطع المثلثان. ✓ الخيار a. الفخّ b: هذا المثلث المتجه إلى الأعلى وحده، فقدنا الثاني. الفخّ c: استبدلنا المثلثين بمربّع — والمراكبة لا تخلق شكلًا جديدًا أبدًا. الفخّ d: المثلث الثاني صغير جدًّا ومُتداخل في الداخل؛ في حين أن للمثلثين الحجمَ نفسه ويجب أن يتقاطعا على شكل نجمة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d0a969ae-7d4c-5010-85d8-77c3f053aa4b', '62bcfe47-2174-541d-87d4-64f3df9b0a6e', 'كم محور تماثل يملك هذا الشكل؟ (محور التماثل خطٌّ مستقيم بحيث ينطبق الشكل على نفسه بالطيّ على طول هذا الخطّ.) <svg viewBox="0 0 100 100"><rect x="28" y="28" width="44" height="44" fill="none" stroke="#1e293b" stroke-width="4"/></svg>', '[{"id":"a","text":"محور واحد"},{"id":"b","text":"محوران"},{"id":"c","text":"4 محاور"},{"id":"d","text":"عدد لا نهائي من المحاور"}]'::jsonb, 'c', 'القاعدة: نبحث عن جميع خطوط الطيّ التي تُبقي الشكل دون تغيير. للمربّع 4 محاور بالضبط: المحور العمودي (منتصف الضلعين الأيسر/الأيمن)، والمحور الأفقي (منتصف الضلعين العلوي/السفلي)، والقطران الاثنان. ✓ الخيار c (4 محاور). الفخّ a (1): هذا عدد محاور شكل شبه متماثل كالقلب أو شبه المنحرف المتساوي الساقين، لا المربّع. الفخّ b (2): هذه حالة مستطيل غير مربّع (المتوسطان فقط، لا القطران) — نسينا أن قطرَي المربّع محوران أيضًا. الفخّ d (عدد لا نهائي): هذه خاصّية الدائرة، حيث كل خطٍّ مارٍّ بالمركز محور؛ أمّا المربّع فله 4 فقط.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

