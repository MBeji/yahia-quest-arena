-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: eveil-scientifique-1ere (Éveil scientifique)
-- Regenerate with: npm run content:build
-- Source of truth: content/eveil-scientifique-1ere/
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
  ('eveil-scientifique-1ere', 'Éveil scientifique', 'نكتشفُ معًا أجسامنا وحواسّنا الخمس، ونتعلّم النظافة، ونتعرّف على الحيوانات والنباتات من حولنا، والنهار والليل والفصول، وفق برنامج الإيقاظ العلمي للسنة الأولى من التعليم الأساسي', 'Observation', 'subject-svt', 'Microscope', 2, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '1ere-base'))
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
      AND e.subject_id = 'eveil-scientifique-1ere'
      AND e.source = 'admin'
      AND q.id NOT IN ('f413b18f-2145-58ac-86ff-86e0d45312d4', '13a3437d-9598-5d12-9da6-16262fcc7570', 'aebb6582-21b2-59a4-af84-7565db1d93f3', '371a912c-c0b8-5aaa-bbb6-c1d8c0ab5369', 'bb9c0e59-8f91-51e1-a0ae-5dcf5c75041a', '68896086-9f2e-5a1e-a8e6-12fb5fc46db9', 'b4ae0cf6-a688-5b14-96db-37611d96aa8d', '47017563-5075-5c51-a482-e398a39e2e4e', '985936da-d3e4-5aba-8786-8763c2dfd54e', 'a3884336-32f5-50df-b092-f8e5c5bfbd32', '9cd86e13-d8a4-5c25-a8fa-2e5b2971ccd2', '12d83787-32a4-5dda-8bd1-35db8e40deff', '3815ad35-313d-5322-8649-fd888b632dfe', '8074512e-3a15-5923-ab58-4c7661e66028', '410f42b9-9bda-56b3-a451-e3d5cb25187c', '8013ca9c-1db2-517e-89ac-433406672204', '5d741f24-57af-57cc-aa0e-d67b631bb9e0', 'b5794054-d04d-57b9-8e22-a50efe0b8d2c', 'a402028a-1ddc-595c-aaeb-38a1c4bf12d7', '06458902-9612-5a76-8ae7-3388b59b051b', 'd5b9c75c-864d-5d18-b415-931630735fbf', 'f1646e8a-0fce-5bae-a7b2-b36d0550f4b5', '4e2fecef-7727-54ab-bb6a-87128aaad904', '38c992f6-e1a3-50fc-901c-bbbec91b642a', 'f208823b-ae2a-5a2d-853a-709d8bd09873', '25c2ea08-a044-5d66-8ac0-f3efa124055d', '05cdeba4-f51f-5424-923c-844748539ca9', 'affce432-5f76-5dd4-9b73-5ceb96d10bfc', '92081640-0e4d-5770-a56a-b23895163dfe', 'd5c1308a-cff9-5005-ae16-756f41d19f24', '5295f07e-e5cc-5a55-a320-abd37c6a675f', 'a4e65455-a4e9-5e05-adad-25d355f5df3b', 'd53a5bf0-758e-54b9-b58d-3f6c0cdf5aa9', '40d68fa8-561a-538d-89e5-6f3a64701719', '38544506-b87c-5f58-93c6-1d5f87129295', '8aa60509-9d85-57e6-9330-372d006b5cad', '160096b0-649f-542e-82b5-48cd2e0aa89b', 'f19aa452-730c-536f-9f42-946552ae4aa6', '941de08f-7304-5a25-8473-e1988b7e8810', '83ca12bb-c0e1-50f7-8dee-76ad78501fcc', '7e9fc49d-83fa-5e6e-8987-ee2c14059ad7', '5fb926c2-f1be-5e82-99b4-750ae5a2b994', '49ae4b56-f99a-5d08-9cfb-b32e9adf7c1a', 'aaa1c6c8-77d2-55b1-88f1-d3f1a1fbd9dc', '6179b414-ec9c-5e37-abfa-e2fec95215dd', '3b11d26c-d49f-5bc8-bbac-93303e669e55', '78a6ed5e-5283-5b2e-8627-a0c2c13b1ff7', '690f651d-a432-5e82-9389-ec7857a16b77', 'efa0861c-748a-5219-8999-19a8a6b5cf37', '414094c6-3eb4-58fc-aeb3-f777513833f3', '0700838b-b802-5f4a-856d-a28a5f11810d', '17a977dd-e365-5b5f-a113-e169cda41ca6', '14129722-7659-52c3-8d3a-8d8ff23ac3de', '2a27cf14-2713-5271-ab14-c8010e6a7c7d', 'e900a87f-81b3-5747-b724-50611a008fa4', '7e78d0de-7a9d-55bc-9f78-57199deaf6b0', '7c85fd09-dfa5-55a5-997a-340a5bfdee48', '20927f2f-e7d2-51e0-9841-151c931ecb49', '2e24e50f-6f6c-5c67-b7ab-ec8709cf6f59', '6146ba6b-58e4-58da-b380-fe2b16bff227', '1dd19987-867f-5d1f-8df2-278b68a2c539', '7b83e220-97b2-5b09-adf0-070df19d568c', 'ffea6b78-826d-5fe7-aaf7-43ff7a3e17e2', '6da5dcb3-885a-5d5d-9ec4-d2339288fe26', 'b6c05609-6566-54d9-b911-86fc18fcb788', '74f3b64f-ddcc-5c19-a2de-a2a3fd100ec2', 'ead6aac3-c4f1-5735-81bc-b0d088fd5b25', 'e7be4a9c-5f12-5ce5-b147-f3dc60332cf6', 'e28ef9ab-7cea-575a-9e5d-d8f88133ed4e', 'f1412d85-b6e6-597d-b52e-8c7de35141cf', '09c2debc-7f79-5f2b-a738-570ee3bdeba6', '03450c8a-304e-5a07-809d-4c3832fa1426', '6a0047c3-525e-5c54-b371-75ad9aa9ac8f', '824b9e08-198c-5c7f-995d-e15b8d3b0b1f', 'bfe61f4c-acfa-56ca-9fe2-28524b740ea8', 'c683713a-1ec2-58ec-998f-b2fc53d818f3', 'e5811944-8830-5322-9de6-89d4ba498348', 'dbe39f54-6b90-5910-9448-5b0567edb374', 'bf5f0806-85cf-56e4-bf4f-5a7fb571b892', 'fefcf310-12e3-5f1f-97fe-4891ad2b22b4', '1097467e-b86d-57c0-ab95-4923f263aa78', '01ae65c7-0ebd-58aa-9e8b-711e5dae8cd4', '9897dd45-1219-5c32-871b-dec1a9d884ce', '3f3f5529-7552-5578-8bdc-6f06e7bebf2d', 'd425086a-24d2-5936-8a9e-26ca8b02ad6d', 'd1e06cc8-4c67-537b-88f8-adf3af4e846e', 'ce176db7-2870-558a-b735-57479f674490', '2c3f9c06-1aa9-5661-b932-541c2266cf9d', 'f2beb0cd-9cdf-5a44-aaa5-db6a4ad11c76', '5d3fcc3e-0e58-577e-afc5-60a726aa60d1', '87cfcefd-1217-5cd8-8a4a-1e62494a24ca', '6bf02dc4-c114-5d36-848c-9c4f4cd294c3', 'be89e03c-efd1-5945-8f63-03347cf940c1', '38dbd517-66f2-5f28-93eb-629176580f49', '6515830e-a7c4-5510-922a-fa7f48049b58', 'ee4050e2-0692-5f0d-9da2-f3f292f2cc11', 'd6652581-a2fc-53c5-b5e4-cd90de73a289', 'def62ca7-94a4-57f9-8175-b10ed2964cdb', '91c4636e-159f-5280-8c78-dbdc0d16667b', '6d6559f8-fa8c-581b-b2a1-f29655c5e9c3', '5622b1ef-9451-5ec1-b427-ad4e1f457a99', '11eb13da-e043-505e-83ba-270204a9259f', '42629960-53cd-52be-90b7-48adae414781', 'a20aab46-5e84-5685-877c-229d69d0083a', '1bdb134e-612f-5381-a1e3-04c3b5b4ec05', 'd09b3cfb-772f-5ada-a7d5-b2df71f58f97', '198750ac-138a-5434-b2c4-32f382ed126f', 'cd528d10-2134-5a73-b86c-c87e7ab8ca76', '183a7832-7a80-5f92-9e36-ebe6f009900e', 'dd0f7394-7678-53b8-979b-ddf0e61a1fdb', 'd591fd1c-5af6-5f46-8c95-7de0719af52e', 'b25564e2-96d5-5621-90b1-387cd9f2ad4e', 'a2eae94e-e3e6-550e-94da-53cbe4eb8b4b', '02781598-e0e1-520e-bf10-3037177db59b', '5577e2cd-67bf-5a69-a672-2031e82d5b6d', '7f72009b-d1c7-5aac-be38-21652c210dbf', '5849471a-6001-5564-875c-0c64348f885e', '83c59f29-cc44-579d-96a3-fa1242329f7f', '80ec6acf-2c36-532a-8050-cc3028e6a59c', '681295b3-d684-5034-b594-897bbb37b34a', 'c0987ef5-aa72-5659-a838-3624b333c8c1', '7377066b-22a8-504e-95df-cb33dcdddd85', '0c69c7bf-28e9-5bf5-b890-530f73846ed9', 'a79bd36c-57a1-5f1b-8421-904efa3d3ad4', 'c9bac5f2-5cb5-52d4-824c-a4b327f1baf8', '62b4b7da-6f76-5188-8733-602b5ddae12e', 'ed25ec8b-837f-5bdd-be9e-c4309945b137', 'd10d4907-e600-5a19-a7e7-3934c728915a', '7119c9e7-2a5d-514e-9630-f2703345baaf', 'ed8ee754-8f26-5fac-8ace-aa63e0a70e93', '74535e02-4f3a-568b-85f0-54aca140c4e3', '2e1c2825-23a4-53bb-a6f5-99f2d4f79c40', '618e0586-ab6e-57c9-9537-550baba3011e', 'cf10a527-4030-53ec-a8b2-980d9a62374d', 'e3ffb107-2969-5a12-a895-bb132bac09fd', 'b5b48c2a-f7f2-5004-aad4-d45b6cd236a9', '4ef1e289-926c-5f95-a3ee-1c676738c106', 'c2878cff-e378-50eb-a801-cf846ab5224f', 'f1e93022-4f4a-5084-b24b-9ea306f7a53e', '8ed22679-0091-54b2-a0c3-455084fedd21', 'ac766d9c-aed0-5540-b6db-68ed79f9709c', '2d8a4e03-722a-5c89-84d6-fbdaf4ce2f11', 'cc2313b2-e83f-5ac9-b1da-eb0e7d673236', '8700c4cd-c481-52b9-a4d5-6a0aa3402c23', 'e2148c54-c3e5-5640-bb4d-a2c217bc5b20', '13e6c945-ba5d-5634-9703-9b6d3bcf1d83', '5da38a90-8d09-5e9a-b5f7-d595cafd9a99', '0337352b-24be-54ab-ba6e-b5249e86a336', '1510fd45-2fe1-554d-8e05-ff9587769441', '42898e32-6de3-5671-b908-fccc40e90c15', '888ff244-04a5-58df-9022-1a15484560be', 'da542df7-7585-5415-81dd-f8132fb8f6f3', '1eba63fa-405a-5afa-948e-cbffb70ffa30', '1a70815b-b06b-5762-9deb-772388d413ab', '8e65d1cc-5ae7-548d-91eb-c561f1dfe8e5', 'e94718ea-855f-5115-a685-75aa9959e08e', '3cbe56eb-5650-5338-acb8-c3bc31fe29ab', '5e042e51-90d4-5b4f-9726-880576df4974', 'f4f0e588-601f-5108-9674-5d48d796ad4a', 'fd0de3d5-b629-588e-8d67-74908552ea7c', '0485b49a-8871-59bf-8597-c7ba23730b33', 'b666456e-d665-5d27-a7c8-aa5c8befbd78', 'c83e550c-2e9f-51fe-b503-4b38ed3e7e4c', '76fb6359-9af6-5c27-ad31-9fa88852219f', '18ff2c58-d8ab-5106-8449-f0735c956afe', '40588d0d-142d-5b9f-98a5-7e224f2b8dd0', '6e583035-5d62-5118-a1c3-3a504dda821b', 'cab1be57-3c93-5978-a0c9-b47872243d07', '162740ce-069d-5e75-92f7-cf88e786dece', '42f3249c-9a3e-55f0-9aa8-cf9e5f653a9d', 'ecb2d573-532e-516d-abf4-578e87b98e6d', 'e80a82ac-2dc7-5c71-b2ac-451b526476c4', 'e0f7e4e8-e932-5ca7-ac30-2dace570f727', '3b0602e2-61f1-54a5-8337-a00db08988d9', '4b2eda1c-9037-5fc4-8f52-49599b6071b1', 'de005c93-30cf-5752-8ee9-359def98be98', 'fe699aad-a854-5e39-92ef-054f6085abe0', '46dc0f3d-0082-56cc-8d4f-a1697e0a7c15', 'da7a0b59-ba1a-5190-a391-7ab2d7d29e79', '64f932c6-141d-5eda-b2e2-71bfb18e2947', '07481e47-c24a-5fce-a086-8055985659f0', 'a331886d-4108-50cb-9c5b-a780653a5605', '572d0c48-e8b0-5ce8-842b-2f95a7b1ca8b', '5064929c-6fa7-53d5-9efe-5711095846c3', '5338579c-5790-5b84-8fac-0bd4cdd26e34', '745ff14e-deef-549b-88fd-27d8bbb33b47', '6f74648d-35aa-5525-b903-c7d3219141eb', 'c324d727-b867-5fe6-b37d-c951bb3d68fb', '21848f35-d656-5496-933f-0a3ac9555c72', 'bd2d6103-848b-598d-ac2c-a2e75b84df60', '25db2331-adfc-542f-a459-fc18806055f1', '229b21c4-203d-5bb6-8736-1cbf8a833d9b', 'bee31a42-c70b-5243-a09c-7566bdc2ac5e', '5f3c7a84-d118-5585-a061-b90bb016dd16', '52ef4524-0046-5941-a2d8-cd118bda2389', 'fd2cca04-a0a9-56a7-9dff-91ede89be84c', '2756f8f3-ae2c-57ec-bd1f-dda40dd82830', 'bf87945c-9641-549d-89a1-48dcc9513037', 'ddce2379-26c0-5a82-bbf1-de7dff055819', '4ca0113a-6056-5e23-8f23-57c3f751ad9a', '4d952f1c-b96a-56f3-a4ff-ca5814c77b3e', 'f982d7eb-b91c-5cc4-b2a7-98baa6ac3329', '4a3f5f84-b311-5324-a7c4-907d71f2e64a', '741e6581-ba5c-5951-a1ea-5578dcb8b501', '1fa42683-2c9e-5798-9565-664345bc2e5a', '61596c8b-f3c3-55b8-9446-0df6f1c46752', '6681a13e-1891-5e0e-a54c-436a486366d2', '5976af41-44d5-5806-89e9-0b0be30bb8ba', '153ef198-1cf4-5661-be9f-cf777fcd8abb', '4f77e975-fc5e-523f-a023-126357e53633');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'eveil-scientifique-1ere' AND source = 'admin' AND id NOT IN ('63358af5-b4e0-5232-85b5-f5375a19c88c', 'd3946b3b-2d61-55be-b04f-1730eafcb2eb', 'decb6350-0bda-50da-9740-4aea324ee249', '57958dcd-8bce-5f61-970a-82691873646e', 'd2a351e1-f409-53e1-9cc4-4a7019b2420d', 'c033f8b7-41d0-5aee-b508-09ba0e817e7a', '064a503f-823e-5354-885f-c612030b3e9a', 'abdf9d0f-3a49-5996-b3eb-8a43fc80290f', 'be532418-c0dd-59f3-9513-777a85031251', 'eb33804a-4580-573e-8a60-9ec1d8c27c11', 'e177ab22-f2a0-5446-8b78-20d841d22b7d', 'bce05e32-58fc-5dab-bacd-6d5ba083ac97', 'a9b48932-215f-5a0b-b5c1-15d4dcfad64f', '1799e069-1e98-51ed-ba7f-60b12621b696', '1aef5159-7685-58dd-9647-0314fef6e1b3', '0a77dd49-9267-5c09-9bec-dae4d1a811ae', '259b8c6b-a8ed-59e7-8b1c-4b893ad77efe', '0f389ea8-0fc1-530d-83d8-9224dc2c4075', '2e01366e-2aec-543d-8000-ff4671663019', 'f52eefed-8393-51f2-91ef-426a2044d6ee', '0d3d4bc8-cf0d-545f-9f7f-c556b4608c46', '69d02e89-ef4d-5ba8-9db5-9db19d0c57ae', '865ef2ce-3a57-5486-8224-a3df98c18977', '353e12aa-c01b-54e5-97ef-89460f69e503', '935ff8fe-11dd-5ed5-96a2-740c537562b4', '8d2533ba-5d5f-5bef-9f0a-1de9b9374963', '4e927f1e-6860-5847-85d3-e9e055a56ad9', '668cf57a-4d55-58b1-a36c-8813ba28ef7c', 'b4c403fa-2916-5353-9416-a4857b78f2da', '9b588f1e-ce58-5955-bb3f-39bf23e2ec87', 'e34f1127-c0f3-5eef-b3ce-ac1e149c4f71', 'bdf093af-306b-58af-be2b-3a65eaabbd75', '87668b80-03d5-5f6a-a8cd-cf8b343c9ec1', '71ac7233-4a9a-5beb-a001-7ad513635da5', '43f26a88-2d2e-5f49-8e30-a779d207a003', '2168be20-0c5c-5854-b5d4-5e72ace64f44');
DELETE FROM public.questions WHERE exercise_id IN ('63358af5-b4e0-5232-85b5-f5375a19c88c', 'd3946b3b-2d61-55be-b04f-1730eafcb2eb', 'decb6350-0bda-50da-9740-4aea324ee249', '57958dcd-8bce-5f61-970a-82691873646e', 'd2a351e1-f409-53e1-9cc4-4a7019b2420d', 'c033f8b7-41d0-5aee-b508-09ba0e817e7a', '064a503f-823e-5354-885f-c612030b3e9a', 'abdf9d0f-3a49-5996-b3eb-8a43fc80290f', 'be532418-c0dd-59f3-9513-777a85031251', 'eb33804a-4580-573e-8a60-9ec1d8c27c11', 'e177ab22-f2a0-5446-8b78-20d841d22b7d', 'bce05e32-58fc-5dab-bacd-6d5ba083ac97', 'a9b48932-215f-5a0b-b5c1-15d4dcfad64f', '1799e069-1e98-51ed-ba7f-60b12621b696', '1aef5159-7685-58dd-9647-0314fef6e1b3', '0a77dd49-9267-5c09-9bec-dae4d1a811ae', '259b8c6b-a8ed-59e7-8b1c-4b893ad77efe', '0f389ea8-0fc1-530d-83d8-9224dc2c4075', '2e01366e-2aec-543d-8000-ff4671663019', 'f52eefed-8393-51f2-91ef-426a2044d6ee', '0d3d4bc8-cf0d-545f-9f7f-c556b4608c46', '69d02e89-ef4d-5ba8-9db5-9db19d0c57ae', '865ef2ce-3a57-5486-8224-a3df98c18977', '353e12aa-c01b-54e5-97ef-89460f69e503', '935ff8fe-11dd-5ed5-96a2-740c537562b4', '8d2533ba-5d5f-5bef-9f0a-1de9b9374963', '4e927f1e-6860-5847-85d3-e9e055a56ad9', '668cf57a-4d55-58b1-a36c-8813ba28ef7c', 'b4c403fa-2916-5353-9416-a4857b78f2da', '9b588f1e-ce58-5955-bb3f-39bf23e2ec87', 'e34f1127-c0f3-5eef-b3ce-ac1e149c4f71', 'bdf093af-306b-58af-be2b-3a65eaabbd75', '87668b80-03d5-5f6a-a8cd-cf8b343c9ec1', '71ac7233-4a9a-5beb-a001-7ad513635da5', '43f26a88-2d2e-5f49-8e30-a779d207a003', '2168be20-0c5c-5854-b5d4-5e72ace64f44') AND id NOT IN ('f413b18f-2145-58ac-86ff-86e0d45312d4', '13a3437d-9598-5d12-9da6-16262fcc7570', 'aebb6582-21b2-59a4-af84-7565db1d93f3', '371a912c-c0b8-5aaa-bbb6-c1d8c0ab5369', 'bb9c0e59-8f91-51e1-a0ae-5dcf5c75041a', '68896086-9f2e-5a1e-a8e6-12fb5fc46db9', 'b4ae0cf6-a688-5b14-96db-37611d96aa8d', '47017563-5075-5c51-a482-e398a39e2e4e', '985936da-d3e4-5aba-8786-8763c2dfd54e', 'a3884336-32f5-50df-b092-f8e5c5bfbd32', '9cd86e13-d8a4-5c25-a8fa-2e5b2971ccd2', '12d83787-32a4-5dda-8bd1-35db8e40deff', '3815ad35-313d-5322-8649-fd888b632dfe', '8074512e-3a15-5923-ab58-4c7661e66028', '410f42b9-9bda-56b3-a451-e3d5cb25187c', '8013ca9c-1db2-517e-89ac-433406672204', '5d741f24-57af-57cc-aa0e-d67b631bb9e0', 'b5794054-d04d-57b9-8e22-a50efe0b8d2c', 'a402028a-1ddc-595c-aaeb-38a1c4bf12d7', '06458902-9612-5a76-8ae7-3388b59b051b', 'd5b9c75c-864d-5d18-b415-931630735fbf', 'f1646e8a-0fce-5bae-a7b2-b36d0550f4b5', '4e2fecef-7727-54ab-bb6a-87128aaad904', '38c992f6-e1a3-50fc-901c-bbbec91b642a', 'f208823b-ae2a-5a2d-853a-709d8bd09873', '25c2ea08-a044-5d66-8ac0-f3efa124055d', '05cdeba4-f51f-5424-923c-844748539ca9', 'affce432-5f76-5dd4-9b73-5ceb96d10bfc', '92081640-0e4d-5770-a56a-b23895163dfe', 'd5c1308a-cff9-5005-ae16-756f41d19f24', '5295f07e-e5cc-5a55-a320-abd37c6a675f', 'a4e65455-a4e9-5e05-adad-25d355f5df3b', 'd53a5bf0-758e-54b9-b58d-3f6c0cdf5aa9', '40d68fa8-561a-538d-89e5-6f3a64701719', '38544506-b87c-5f58-93c6-1d5f87129295', '8aa60509-9d85-57e6-9330-372d006b5cad', '160096b0-649f-542e-82b5-48cd2e0aa89b', 'f19aa452-730c-536f-9f42-946552ae4aa6', '941de08f-7304-5a25-8473-e1988b7e8810', '83ca12bb-c0e1-50f7-8dee-76ad78501fcc', '7e9fc49d-83fa-5e6e-8987-ee2c14059ad7', '5fb926c2-f1be-5e82-99b4-750ae5a2b994', '49ae4b56-f99a-5d08-9cfb-b32e9adf7c1a', 'aaa1c6c8-77d2-55b1-88f1-d3f1a1fbd9dc', '6179b414-ec9c-5e37-abfa-e2fec95215dd', '3b11d26c-d49f-5bc8-bbac-93303e669e55', '78a6ed5e-5283-5b2e-8627-a0c2c13b1ff7', '690f651d-a432-5e82-9389-ec7857a16b77', 'efa0861c-748a-5219-8999-19a8a6b5cf37', '414094c6-3eb4-58fc-aeb3-f777513833f3', '0700838b-b802-5f4a-856d-a28a5f11810d', '17a977dd-e365-5b5f-a113-e169cda41ca6', '14129722-7659-52c3-8d3a-8d8ff23ac3de', '2a27cf14-2713-5271-ab14-c8010e6a7c7d', 'e900a87f-81b3-5747-b724-50611a008fa4', '7e78d0de-7a9d-55bc-9f78-57199deaf6b0', '7c85fd09-dfa5-55a5-997a-340a5bfdee48', '20927f2f-e7d2-51e0-9841-151c931ecb49', '2e24e50f-6f6c-5c67-b7ab-ec8709cf6f59', '6146ba6b-58e4-58da-b380-fe2b16bff227', '1dd19987-867f-5d1f-8df2-278b68a2c539', '7b83e220-97b2-5b09-adf0-070df19d568c', 'ffea6b78-826d-5fe7-aaf7-43ff7a3e17e2', '6da5dcb3-885a-5d5d-9ec4-d2339288fe26', 'b6c05609-6566-54d9-b911-86fc18fcb788', '74f3b64f-ddcc-5c19-a2de-a2a3fd100ec2', 'ead6aac3-c4f1-5735-81bc-b0d088fd5b25', 'e7be4a9c-5f12-5ce5-b147-f3dc60332cf6', 'e28ef9ab-7cea-575a-9e5d-d8f88133ed4e', 'f1412d85-b6e6-597d-b52e-8c7de35141cf', '09c2debc-7f79-5f2b-a738-570ee3bdeba6', '03450c8a-304e-5a07-809d-4c3832fa1426', '6a0047c3-525e-5c54-b371-75ad9aa9ac8f', '824b9e08-198c-5c7f-995d-e15b8d3b0b1f', 'bfe61f4c-acfa-56ca-9fe2-28524b740ea8', 'c683713a-1ec2-58ec-998f-b2fc53d818f3', 'e5811944-8830-5322-9de6-89d4ba498348', 'dbe39f54-6b90-5910-9448-5b0567edb374', 'bf5f0806-85cf-56e4-bf4f-5a7fb571b892', 'fefcf310-12e3-5f1f-97fe-4891ad2b22b4', '1097467e-b86d-57c0-ab95-4923f263aa78', '01ae65c7-0ebd-58aa-9e8b-711e5dae8cd4', '9897dd45-1219-5c32-871b-dec1a9d884ce', '3f3f5529-7552-5578-8bdc-6f06e7bebf2d', 'd425086a-24d2-5936-8a9e-26ca8b02ad6d', 'd1e06cc8-4c67-537b-88f8-adf3af4e846e', 'ce176db7-2870-558a-b735-57479f674490', '2c3f9c06-1aa9-5661-b932-541c2266cf9d', 'f2beb0cd-9cdf-5a44-aaa5-db6a4ad11c76', '5d3fcc3e-0e58-577e-afc5-60a726aa60d1', '87cfcefd-1217-5cd8-8a4a-1e62494a24ca', '6bf02dc4-c114-5d36-848c-9c4f4cd294c3', 'be89e03c-efd1-5945-8f63-03347cf940c1', '38dbd517-66f2-5f28-93eb-629176580f49', '6515830e-a7c4-5510-922a-fa7f48049b58', 'ee4050e2-0692-5f0d-9da2-f3f292f2cc11', 'd6652581-a2fc-53c5-b5e4-cd90de73a289', 'def62ca7-94a4-57f9-8175-b10ed2964cdb', '91c4636e-159f-5280-8c78-dbdc0d16667b', '6d6559f8-fa8c-581b-b2a1-f29655c5e9c3', '5622b1ef-9451-5ec1-b427-ad4e1f457a99', '11eb13da-e043-505e-83ba-270204a9259f', '42629960-53cd-52be-90b7-48adae414781', 'a20aab46-5e84-5685-877c-229d69d0083a', '1bdb134e-612f-5381-a1e3-04c3b5b4ec05', 'd09b3cfb-772f-5ada-a7d5-b2df71f58f97', '198750ac-138a-5434-b2c4-32f382ed126f', 'cd528d10-2134-5a73-b86c-c87e7ab8ca76', '183a7832-7a80-5f92-9e36-ebe6f009900e', 'dd0f7394-7678-53b8-979b-ddf0e61a1fdb', 'd591fd1c-5af6-5f46-8c95-7de0719af52e', 'b25564e2-96d5-5621-90b1-387cd9f2ad4e', 'a2eae94e-e3e6-550e-94da-53cbe4eb8b4b', '02781598-e0e1-520e-bf10-3037177db59b', '5577e2cd-67bf-5a69-a672-2031e82d5b6d', '7f72009b-d1c7-5aac-be38-21652c210dbf', '5849471a-6001-5564-875c-0c64348f885e', '83c59f29-cc44-579d-96a3-fa1242329f7f', '80ec6acf-2c36-532a-8050-cc3028e6a59c', '681295b3-d684-5034-b594-897bbb37b34a', 'c0987ef5-aa72-5659-a838-3624b333c8c1', '7377066b-22a8-504e-95df-cb33dcdddd85', '0c69c7bf-28e9-5bf5-b890-530f73846ed9', 'a79bd36c-57a1-5f1b-8421-904efa3d3ad4', 'c9bac5f2-5cb5-52d4-824c-a4b327f1baf8', '62b4b7da-6f76-5188-8733-602b5ddae12e', 'ed25ec8b-837f-5bdd-be9e-c4309945b137', 'd10d4907-e600-5a19-a7e7-3934c728915a', '7119c9e7-2a5d-514e-9630-f2703345baaf', 'ed8ee754-8f26-5fac-8ace-aa63e0a70e93', '74535e02-4f3a-568b-85f0-54aca140c4e3', '2e1c2825-23a4-53bb-a6f5-99f2d4f79c40', '618e0586-ab6e-57c9-9537-550baba3011e', 'cf10a527-4030-53ec-a8b2-980d9a62374d', 'e3ffb107-2969-5a12-a895-bb132bac09fd', 'b5b48c2a-f7f2-5004-aad4-d45b6cd236a9', '4ef1e289-926c-5f95-a3ee-1c676738c106', 'c2878cff-e378-50eb-a801-cf846ab5224f', 'f1e93022-4f4a-5084-b24b-9ea306f7a53e', '8ed22679-0091-54b2-a0c3-455084fedd21', 'ac766d9c-aed0-5540-b6db-68ed79f9709c', '2d8a4e03-722a-5c89-84d6-fbdaf4ce2f11', 'cc2313b2-e83f-5ac9-b1da-eb0e7d673236', '8700c4cd-c481-52b9-a4d5-6a0aa3402c23', 'e2148c54-c3e5-5640-bb4d-a2c217bc5b20', '13e6c945-ba5d-5634-9703-9b6d3bcf1d83', '5da38a90-8d09-5e9a-b5f7-d595cafd9a99', '0337352b-24be-54ab-ba6e-b5249e86a336', '1510fd45-2fe1-554d-8e05-ff9587769441', '42898e32-6de3-5671-b908-fccc40e90c15', '888ff244-04a5-58df-9022-1a15484560be', 'da542df7-7585-5415-81dd-f8132fb8f6f3', '1eba63fa-405a-5afa-948e-cbffb70ffa30', '1a70815b-b06b-5762-9deb-772388d413ab', '8e65d1cc-5ae7-548d-91eb-c561f1dfe8e5', 'e94718ea-855f-5115-a685-75aa9959e08e', '3cbe56eb-5650-5338-acb8-c3bc31fe29ab', '5e042e51-90d4-5b4f-9726-880576df4974', 'f4f0e588-601f-5108-9674-5d48d796ad4a', 'fd0de3d5-b629-588e-8d67-74908552ea7c', '0485b49a-8871-59bf-8597-c7ba23730b33', 'b666456e-d665-5d27-a7c8-aa5c8befbd78', 'c83e550c-2e9f-51fe-b503-4b38ed3e7e4c', '76fb6359-9af6-5c27-ad31-9fa88852219f', '18ff2c58-d8ab-5106-8449-f0735c956afe', '40588d0d-142d-5b9f-98a5-7e224f2b8dd0', '6e583035-5d62-5118-a1c3-3a504dda821b', 'cab1be57-3c93-5978-a0c9-b47872243d07', '162740ce-069d-5e75-92f7-cf88e786dece', '42f3249c-9a3e-55f0-9aa8-cf9e5f653a9d', 'ecb2d573-532e-516d-abf4-578e87b98e6d', 'e80a82ac-2dc7-5c71-b2ac-451b526476c4', 'e0f7e4e8-e932-5ca7-ac30-2dace570f727', '3b0602e2-61f1-54a5-8337-a00db08988d9', '4b2eda1c-9037-5fc4-8f52-49599b6071b1', 'de005c93-30cf-5752-8ee9-359def98be98', 'fe699aad-a854-5e39-92ef-054f6085abe0', '46dc0f3d-0082-56cc-8d4f-a1697e0a7c15', 'da7a0b59-ba1a-5190-a391-7ab2d7d29e79', '64f932c6-141d-5eda-b2e2-71bfb18e2947', '07481e47-c24a-5fce-a086-8055985659f0', 'a331886d-4108-50cb-9c5b-a780653a5605', '572d0c48-e8b0-5ce8-842b-2f95a7b1ca8b', '5064929c-6fa7-53d5-9efe-5711095846c3', '5338579c-5790-5b84-8fac-0bd4cdd26e34', '745ff14e-deef-549b-88fd-27d8bbb33b47', '6f74648d-35aa-5525-b903-c7d3219141eb', 'c324d727-b867-5fe6-b37d-c951bb3d68fb', '21848f35-d656-5496-933f-0a3ac9555c72', 'bd2d6103-848b-598d-ac2c-a2e75b84df60', '25db2331-adfc-542f-a459-fc18806055f1', '229b21c4-203d-5bb6-8736-1cbf8a833d9b', 'bee31a42-c70b-5243-a09c-7566bdc2ac5e', '5f3c7a84-d118-5585-a061-b90bb016dd16', '52ef4524-0046-5941-a2d8-cd118bda2389', 'fd2cca04-a0a9-56a7-9dff-91ede89be84c', '2756f8f3-ae2c-57ec-bd1f-dda40dd82830', 'bf87945c-9641-549d-89a1-48dcc9513037', 'ddce2379-26c0-5a82-bbf1-de7dff055819', '4ca0113a-6056-5e23-8f23-57c3f751ad9a', '4d952f1c-b96a-56f3-a4ff-ca5814c77b3e', 'f982d7eb-b91c-5cc4-b2a7-98baa6ac3329', '4a3f5f84-b311-5324-a7c4-907d71f2e64a', '741e6581-ba5c-5951-a1ea-5578dcb8b501', '1fa42683-2c9e-5798-9565-664345bc2e5a', '61596c8b-f3c3-55b8-9446-0df6f1c46752', '6681a13e-1891-5e0e-a54c-436a486366d2', '5976af41-44d5-5806-89e9-0b0be30bb8ba', '153ef198-1cf4-5661-be9f-cf777fcd8abb', '4f77e975-fc5e-523f-a023-126357e53633');
DELETE FROM public.chapters c WHERE c.subject_id = 'eveil-scientifique-1ere' AND c.id NOT IN ('b42373ba-809f-5fcd-bdae-797113780666', 'a44b8759-b158-516f-b967-00c22e55b652', 'fd429555-0a1a-5838-b63a-5a9379ae7a66', '7fa9f8f7-6f12-5605-acc4-e6896634f1f0', '627d3257-2d35-52be-ab2e-7e9ddc4e96f0', '0964dad9-9807-5c71-973a-94061d78875b') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('b42373ba-809f-5fcd-bdae-797113780666', 'eveil-scientifique-1ere', 'جسمي', 'أجزاء الجسم الرئيسية (الرأس والجذع والأطراف)، وبعض أعضاء الجسم ووظائفها البسيطة كالعينين والأذنين والقدمين واليدين', '# ⚔️ جسمي — أكتشفُ بطلي الصغير

> 💡 «جسمُك بطلُك الأوّل: تعرّفْ عليه لتعتني به جيّدًا.»

كلّ واحدٍ منّا له **جسمٌ** جميل. هيّا نكتشف أجزاءه معًا!

## 🧍 أجزاء جسمي الكبيرة

ينقسم جسمي إلى ثلاثة أجزاء كبيرة:

- **الرأس:** في الأعلى، وفيه الوجه والعينان والأنف والفم والأذنان.
- **الجذع:** وسط الجسم، وفيه الصدر والبطن والظهر.
- **الأطراف:** وهي **اليدان** (الذراعان) و**الرّجلان** (الساقان).

## 👀 أعضائي ووظائفها

كلّ عضوٍ في جسمي يقوم بعملٍ مهمّ:

- **العينان:** أرى بهما الألوان والأشياء.
- **الأذنان:** أسمع بهما الأصوات.
- **الأنف:** أشمّ به الروائح وأتنفّس.
- **الفم:** آكل وأتكلّم به.
- **اليدان:** أمسك وأكتب وألعب بهما.
- **الرّجلان (القدمان):** أمشي وأجري وأقفز بهما.

## 🤝 جسمي يعمل معًا

كلّ أجزاء جسمي تعمل معًا. مثلًا حين ألعب الكرة: **عيني** ترى الكرة، و**رجلي** تركلها، و**يدي** تمسكها.

> ⚠️ الفخّ الشائع: بعض الأطفال يظنّون أنّ اليد عضوٌ نسمع به؛ في الحقيقة نسمع **بالأذنين**، ونمسك **باليدين**.

> 🏆 أحسنت! الآن تعرف أجزاء جسمك وكيف تعتني بها.', '# 📜 ملخّص: جسمي

- **أجزاء الجسم الكبيرة:** الرأس، والجذع، والأطراف (اليدان والرّجلان).
- **الرأس:** فيه العينان والأذنان والأنف والفم.
- **العينان:** أرى بهما. **الأذنان:** أسمع بهما. **الأنف:** أشمّ به. **الفم:** آكل وأتكلّم به.
- **اليدان:** أمسك وأكتب بهما. **الرّجلان:** أمشي وأجري بهما.
- كلّ أجزاء جسمي تعمل معًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('a44b8759-b158-516f-b967-00c22e55b652', 'eveil-scientifique-1ere', 'حواسّي الخمس', 'الحواسّ الخمس وأعضاؤها: البصر (العينان)، السمع (الأذنان)، الشمّ (الأنف)، الذوق (اللسان)، اللمس (الجلد واليدان)، وما نتعرّف عليه بكلّ حاسّة', '# ⚔️ حواسّي الخمس — قُوايَ الخارقة

> 💡 «حواسّك الخمس نوافذُك على العالم: بها تكتشف كلّ شيءٍ من حولك.»

عندي **خمس حواسّ** تساعدني على معرفة الأشياء من حولي. هيّا نتعرّف عليها!

## 👁️ حاسّة البصر — العينان

**بالعينين** أرى الأشياء وألوانها وأحجامها: أرى الشمس، والكتاب، ولون الورود. عضو البصر هو **العين**.

## 👂 حاسّة السمع — الأذنان

**بالأذنين** أسمع الأصوات: صوت الطائر، ورنين الجرس، وكلام أمّي. عضو السمع هو **الأذن**.

## 👃 حاسّة الشمّ — الأنف

**بالأنف** أشمّ الروائح: رائحة الوردة، ورائحة الطعام، ورائحة الخبز. عضو الشمّ هو **الأنف**.

## 👅 حاسّة الذوق — اللسان

**باللسان** أتذوّق طعم الأكل: **الحلو** كالعسل، و**المالح** كالملح، و**الحامض** كالليمون. عضو الذوق هو **اللسان** الموجود في الفم.

## ✋ حاسّة اللمس — الجلد واليدان

**بالجلد** وخاصّةً **اليدين** ألمس الأشياء فأعرف هل هي **ناعمة** أم **خشنة**، **حارّة** أم **باردة**. عضو اللمس هو **الجلد**.

> ⚠️ الفخّ الشائع: بعض الأطفال يخلطون بين الشمّ والذوق؛ تذكّر: **نشمّ بالأنف** و**نتذوّق باللسان**.

> 🏆 رائع! الآن صرت تعرف حواسّك الخمس وكيف تكتشف بها العالم.', '# 📜 ملخّص: حواسّي الخمس

- لي **خمس حواسّ** أعرف بها الأشياء من حولي.
- **البصر:** أرى بالعينين.
- **السمع:** أسمع الأصوات بالأذنين.
- **الشمّ:** أشمّ الروائح بالأنف.
- **الذوق:** أتذوّق الطعم باللسان (الحلو والمالح والحامض).
- **اللمس:** ألمس بالجلد واليدين فأعرف الناعم والخشن والحارّ والبارد.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('fd429555-0a1a-5838-b63a-5a9379ae7a66', 'eveil-scientifique-1ere', 'النظافة', 'نظافة الجسم: غسل اليدين والوجه، تنظيف الأسنان، الاستحمام، نظافة الملابس، ومتى وكيف نحافظ على نظافتنا لنبقى أصحّاء', '# ⚔️ النظافة — دِرعي ضدّ المرض

> 💡 «النظافة درعُك الواقي: من نظّف جسمه حمى نفسه من الأمراض.»

النظافة تجعلني **جميلًا** و**صحيحًا**. الأوساخ تخفي **جراثيم** صغيرةً قد تسبّب المرض، لذلك أنظّف جسمي دائمًا.

## ✋ نظافة اليدين

أغسل **يديّ بالماء والصابون**:

- **قبل الأكل** و**بعده**.
- **بعد دخول المرحاض**.
- **بعد اللعب** وملامسة الأوساخ.

غسل اليدين يطرد الجراثيم ويحميني من المرض.

## 🦷 نظافة الأسنان

أنظّف **أسناني بالفرشاة والمعجون** مرّتين في اليوم: **في الصباح** و**قبل النوم**. هذا يحمي أسناني من **التسوّس** ويجعل نفسي منعشًا.

## 🚿 الاستحمام ونظافة الجسم

**أستحمّ بالماء والصابون** بانتظام لأنظّف كلّ جسمي. وأغسل **وجهي** كلّ صباح، وأقصّ **أظافري**، وأمشّط **شعري**.

## 👕 نظافة الملابس

ألبس **ملابس نظيفة**، وأغيّرها عندما تتّسخ. الملابس النظيفة تحميني وتجعلني مرتّبًا جميلًا.

> ⚠️ الفخّ الشائع: بعض الأطفال يغسلون اليدين بالماء وحده؛ الصحيح أن نستعمل **الماء والصابون معًا** لنطرد الجراثيم.

> 🏆 ممتاز! بنظافتك تحمي صحّتك وتبقى بطلًا قويًّا نشيطًا.', '# 📜 ملخّص: النظافة

- النظافة تحميني من **الجراثيم** والأمراض.
- **اليدان:** أغسلهما بالماء والصابون قبل الأكل وبعده وبعد المرحاض وبعد اللعب.
- **الأسنان:** أنظّفها بالفرشاة والمعجون في الصباح وقبل النوم لأحميها من التسوّس.
- **الجسم:** أستحمّ بانتظام، وأغسل وجهي، وأقصّ أظافري، وأمشّط شعري.
- **الملابس:** ألبس ملابس نظيفة وأغيّرها عندما تتّسخ.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('7fa9f8f7-6f12-5605-acc4-e6896634f1f0', 'eveil-scientifique-1ere', 'الحيوانات من حولي', 'الحيوانات الأليفة والبرّية، أين تعيش (في البيت والمزرعة والغابة)، وماذا تأكل (عشب أو لحم)، وبعض منافعها للإنسان بشكلٍ بسيط', '# ⚔️ الحيوانات من حولي — رفاقي في الطبيعة

> 💡 «حولنا حيواناتٌ كثيرة: منها ما يعيش معنا ومنها ما يعيش في الغابة، ولكلٍّ مأكلُه ومسكنُه.»

في الطبيعة **حيواناتٌ كثيرة**. هيّا نتعرّف عليها وعلى أين تعيش وماذا تأكل!

## 🐕 الحيوانات الأليفة

**الحيوانات الأليفة** تعيش قرب الإنسان ويعتني بها. منها:

- **في البيت:** القطّة والكلب والعصفور.
- **في المزرعة:** الدجاجة والبقرة والخروف والحصان.

هذه الحيوانات يطعمها الإنسان ويحميها.

## 🦁 الحيوانات البرّية

**الحيوانات البرّية** تعيش بعيدًا عن الإنسان، في **الغابة** أو **الصحراء**. منها: **الأسد** و**الذئب** و**الغزال** و**الفيل**. هذه الحيوانات تبحث عن طعامها بنفسها.

## 🍃 ماذا تأكل الحيوانات؟

- بعض الحيوانات تأكل **العشب والنباتات**، مثل **البقرة** و**الخروف** و**الأرنب**.
- وبعضها يأكل **اللحم**، مثل **الأسد** و**الذئب** و**القطّة**.

## 🏠 أين تعيش الحيوانات؟

لكلّ حيوانٍ مسكنه: **السمكة** تعيش في **الماء**، و**العصفور** يبني **عشًّا** في الشجرة، و**الأرنب** يحفر **جحرًا** في الأرض.

> ⚠️ الفخّ الشائع: ليست كلّ الحيوانات تأكل الشيء نفسه؛ فالبقرة تأكل العشب والأسد يأكل اللحم.

> 🏆 رائع! الآن تعرف الحيوانات من حولك، أين تعيش وماذا تأكل.', '# 📜 ملخّص: الحيوانات من حولي

- **الحيوانات الأليفة:** تعيش قرب الإنسان (القطّة، الكلب، الدجاجة، البقرة، الخروف).
- **الحيوانات البرّية:** تعيش بعيدًا في الغابة أو الصحراء (الأسد، الذئب، الغزال، الفيل).
- **بعض الحيوانات تأكل العشب** (البقرة، الخروف، الأرنب).
- **وبعضها يأكل اللحم** (الأسد، الذئب، القطّة).
- لكلّ حيوانٍ مسكنه: السمكة في الماء، والعصفور في عشٍّ بالشجرة، والأرنب في جحرٍ بالأرض.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('627d3257-2d35-52be-ab2e-7e9ddc4e96f0', 'eveil-scientifique-1ere', 'النباتات من حولي', 'أجزاء النبتة (الجذر والساق والأوراق والزهرة)، حاجة النبتة إلى الماء والضوء لتنمو، وبعض النباتات من حولنا كالأشجار والزهور', '# ⚔️ النباتات من حولي — كنوزٌ خضراء

> 💡 «النبتة كائنٌ حيٌّ ينمو: تشرب الماء وتحبّ الضوء، فتعطينا الثمار والظلّ والهواء.»

حولنا **نباتاتٌ كثيرة**: الأشجار والزهور والعشب. النبتة **كائنٌ حيّ** ينمو شيئًا فشيئًا. هيّا نكتشف أجزاءها وما تحتاجه!

## 🌱 أجزاء النبتة

للنبتة أربعة أجزاء رئيسية:

- **الجذر:** تحت الأرض، يثبّت النبتة ويمتصّ الماء.
- **الساق:** يحمل النبتة ويرفعها إلى الأعلى.
- **الأوراق:** خضراء، تصنع غذاء النبتة بمساعدة الضوء.
- **الزهرة:** الجزء الجميل الملوّن، ومنها يتكوّن الثمر والبذور.

## 💧☀️ ماذا تحتاج النبتة لتنمو؟

النبتة كائنٌ حيٌّ تحتاج إلى:

- **الماء:** نسقيها بانتظام.
- **الضوء:** ضوء الشمس يساعدها على الحياة.
- **الهواء** و**التربة** الجيّدة.

بدون ماءٍ أو ضوءٍ **تذبل النبتة وتموت**.

## 🌳 نباتاتٌ من حولي

من النباتات حولنا: **الأشجار** (كالزيتون والنخيل)، و**الزهور** (كالوردة والياسمين)، و**الخضر** (كالطماطم والجزر).

> ⚠️ الفخّ الشائع: بعض الأطفال يظنّون أنّ النبتة لا تحتاج إلى شيء؛ في الحقيقة هي كائنٌ حيٌّ يحتاج إلى **الماء والضوء** لينمو.

> 🏆 ممتاز! الآن تعرف أجزاء النبتة وما تحتاجه لتنمو.', '# 📜 ملخّص: النباتات من حولي

- النبتة **كائنٌ حيّ** ينمو.
- **أجزاء النبتة:** الجذر (تحت الأرض يمتصّ الماء)، الساق (يحملها)، الأوراق (خضراء تصنع الغذاء)، الزهرة (الجزء الملوّن ومنها الثمر).
- النبتة تحتاج إلى **الماء** و**الضوء** لتنمو، وكذلك الهواء والتربة.
- بدون ماءٍ أو ضوءٍ **تذبل النبتة وتموت**.
- من النباتات حولنا: الأشجار والزهور والخضر.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('0964dad9-9807-5c71-973a-94061d78875b', 'eveil-scientifique-1ere', 'النهار والليل', 'الفرق بين النهار والليل، الشمس في النهار والقمر والنجوم في الليل، أنشطة النهار (اللعب والدراسة) وأنشطة الليل (النوم والراحة)', '# ⚔️ النهار والليل — رحلة الضوء والظلام

> 💡 «في النهار تشرق الشمس فنعمل ونلعب، وفي الليل يظهر القمر فننام ونرتاح.»

يمرّ يومُنا بمرحلتين: **النهار** و**الليل**. هيّا نكتشف الفرق بينهما!

## ☀️ النهار

**النهار** هو وقت الضوء. فيه:

- تشرق **الشمس** فتنير الدنيا وتدفّئها.
- السماء **زرقاء** والجوّ **مضيء**.
- نقوم بأنشطةٍ كثيرة: نذهب إلى **المدرسة**، و**نلعب**، و**نأكل**، و**نعمل**.

## 🌙 الليل

**الليل** هو وقت الظلام. فيه:

- تغيب الشمس ويظهر **القمر** و**النجوم**.
- السماء **مظلمة** والجوّ **هادئ**.
- نقوم بأنشطةٍ مختلفة: **ننام** و**نرتاح** لنستعيد نشاطنا.

## 🔄 يتعاقب النهار والليل

يأتي النهار ثمّ يأتي الليل، ثمّ النهار من جديد... هكذا دائمًا. هذا التعاقب يساعدنا على تنظيم وقتنا: **نعمل في النهار** و**ننام في الليل**.

> ⚠️ الفخّ الشائع: بعض الأطفال يظنّون أنّ الشمس تظهر في الليل؛ في الحقيقة **الشمس في النهار** و**القمر والنجوم في الليل**.

> 🏆 رائع! الآن تعرف الفرق بين النهار والليل وماذا نفعل في كلٍّ منهما.', '# 📜 ملخّص: النهار والليل

- يمرّ اليوم بمرحلتين: **النهار** و**الليل**.
- **النهار:** وقت الضوء، فيه تشرق **الشمس** والسماء زرقاء، ونلعب وندرس ونعمل.
- **الليل:** وقت الظلام، فيه يظهر **القمر** و**النجوم** والسماء مظلمة، وننام ونرتاح.
- يتعاقب النهار والليل دائمًا: نعمل في النهار وننام في الليل.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('63358af5-b4e0-5232-85b5-f5375a19c88c', 'b42373ba-809f-5fcd-bdae-797113780666', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('f413b18f-2145-58ac-86ff-86e0d45312d4', '63358af5-b4e0-5232-85b5-f5375a19c88c', 'بأيّ عضوٍ أرى الأشياء؟', '[{"id":"a","text":"بالأذن"},{"id":"b","text":"بالعين"},{"id":"c","text":"بالفم"},{"id":"d","text":"بالرّجل"}]'::jsonb, 'b', 'أرى الألوان والأشياء بالعينين، فهما عضو النظر.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13a3437d-9598-5d12-9da6-16262fcc7570', '63358af5-b4e0-5232-85b5-f5375a19c88c', 'أين يوجد الفم والأنف والعينان؟', '[{"id":"a","text":"في الرأس"},{"id":"b","text":"في الرّجل"},{"id":"c","text":"في اليد"},{"id":"d","text":"في الظهر"}]'::jsonb, 'a', 'الفم والأنف والعينان والأذنان كلّها موجودة في الرأس.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aebb6582-21b2-59a4-af84-7565db1d93f3', '63358af5-b4e0-5232-85b5-f5375a19c88c', 'بأيّ عضوٍ أمشي وأجري؟', '[{"id":"a","text":"باليدين"},{"id":"b","text":"بالأذنين"},{"id":"c","text":"بالرّجلين"},{"id":"d","text":"بالأنف"}]'::jsonb, 'c', 'أمشي وأجري وأقفز بالرّجلين (القدمين).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('371a912c-c0b8-5aaa-bbb6-c1d8c0ab5369', '63358af5-b4e0-5232-85b5-f5375a19c88c', 'ما هي أطراف جسمي؟', '[{"id":"a","text":"الرأس والبطن"},{"id":"b","text":"اليدان والرّجلان"},{"id":"c","text":"الأنف والفم"},{"id":"d","text":"الصدر والظهر"}]'::jsonb, 'b', 'أطراف الجسم هي اليدان (الذراعان) والرّجلان (الساقان).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb9c0e59-8f91-51e1-a0ae-5dcf5c75041a', '63358af5-b4e0-5232-85b5-f5375a19c88c', 'بأيّ عضوٍ أمسك القلم وأكتب؟', '[{"id":"a","text":"بالأذن"},{"id":"b","text":"بالأنف"},{"id":"c","text":"بالرّجل"},{"id":"d","text":"باليد"}]'::jsonb, 'd', 'أمسك القلم وأكتب وألعب باليدين.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d3946b3b-2d61-55be-b04f-1730eafcb2eb', 'b42373ba-809f-5fcd-bdae-797113780666', 'eveil-scientifique-1ere', '⭐ تمرين: أتعرّفُ على جسمي', 1, 50, 10, 'practice', 'admin', 1)
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
  ('68896086-9f2e-5a1e-a8e6-12fb5fc46db9', 'd3946b3b-2d61-55be-b04f-1730eafcb2eb', 'بأيّ عضوٍ أسمع الأصوات؟', '[{"id":"a","text":"بالعين"},{"id":"b","text":"بالأذن"},{"id":"c","text":"بالرّجل"},{"id":"d","text":"بالبطن"}]'::jsonb, 'b', 'أسمع الأصوات بالأذنين، فهما عضو السمع.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4ae0cf6-a688-5b14-96db-37611d96aa8d', 'd3946b3b-2d61-55be-b04f-1730eafcb2eb', 'بأيّ عضوٍ آكل الطعام؟', '[{"id":"a","text":"بالفم"},{"id":"b","text":"بالأذن"},{"id":"c","text":"بالعين"},{"id":"d","text":"باليد"}]'::jsonb, 'a', 'آكل الطعام بالفم، وبه أتكلّم أيضًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('47017563-5075-5c51-a482-e398a39e2e4e', 'd3946b3b-2d61-55be-b04f-1730eafcb2eb', 'أين يوجد الرأس في جسمي؟', '[{"id":"a","text":"في الأسفل"},{"id":"b","text":"في وسط الجسم"},{"id":"c","text":"في الأعلى"},{"id":"d","text":"في الرّجل"}]'::jsonb, 'c', 'الرأس يوجد في أعلى الجسم، وفيه الوجه والعينان والأذنان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('985936da-d3e4-5aba-8786-8763c2dfd54e', 'd3946b3b-2d61-55be-b04f-1730eafcb2eb', 'بأيّ عضوٍ أشمّ رائحة الوردة؟', '[{"id":"a","text":"بالأذن"},{"id":"b","text":"بالأنف"},{"id":"c","text":"بالرّجل"},{"id":"d","text":"بالظهر"}]'::jsonb, 'b', 'أشمّ الروائح بالأنف، وبه أتنفّس أيضًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3884336-32f5-50df-b092-f8e5c5bfbd32', 'd3946b3b-2d61-55be-b04f-1730eafcb2eb', 'كم عدد العينين في وجهي؟', '[{"id":"a","text":"عينٌ واحدة"},{"id":"b","text":"ثلاث عيون"},{"id":"c","text":"عينان اثنتان"},{"id":"d","text":"أربع عيون"}]'::jsonb, 'c', 'لي عينان اثنتان أرى بهما الأشياء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9cd86e13-d8a4-5c25-a8fa-2e5b2971ccd2', 'd3946b3b-2d61-55be-b04f-1730eafcb2eb', 'بأيّ عضوٍ أقفز وألعب الكرة برجلي؟', '[{"id":"a","text":"بالأنف"},{"id":"b","text":"بالأذن"},{"id":"c","text":"بالفم"},{"id":"d","text":"بالرّجلين"}]'::jsonb, 'd', 'أقفز وأركل الكرة وأجري بالرّجلين.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('decb6350-0bda-50da-9740-4aea324ee249', 'b42373ba-809f-5fcd-bdae-797113780666', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الجسم', 3, 120, 30, 'boss', 'admin', 2)
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
  ('12d83787-32a4-5dda-8bd1-35db8e40deff', 'decb6350-0bda-50da-9740-4aea324ee249', 'أراد سامي أن يسمع نشيدًا جميلًا. أيّ عضوٍ يستعمل؟', '[{"id":"a","text":"الأذنين"},{"id":"b","text":"العينين"},{"id":"c","text":"الأنف"},{"id":"d","text":"الرّجلين"}]'::jsonb, 'a', 'نسمع الأصوات والأناشيد بالأذنين.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3815ad35-313d-5322-8649-fd888b632dfe', 'decb6350-0bda-50da-9740-4aea324ee249', 'وضعت ليلى الجذع في المكان الصحيح. أين يوجد الجذع؟', '[{"id":"a","text":"في أعلى الجسم فوق الرأس"},{"id":"b","text":"في وسط الجسم، وفيه الصدر والبطن والظهر"},{"id":"c","text":"في أسفل القدمين"},{"id":"d","text":"خارج الجسم"}]'::jsonb, 'b', 'الجذع هو وسط الجسم، وفيه الصدر والبطن والظهر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8074512e-3a15-5923-ab58-4c7661e66028', 'decb6350-0bda-50da-9740-4aea324ee249', 'يريد أحمد أن يكتب درسه. أيّ طرفٍ يستعمل؟', '[{"id":"a","text":"الرّجلين"},{"id":"b","text":"الأذنين"},{"id":"c","text":"اليدين"},{"id":"d","text":"الأنف"}]'::jsonb, 'c', 'نكتب ونمسك القلم باليدين، وهما من أطراف الجسم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('410f42b9-9bda-56b3-a451-e3d5cb25187c', 'decb6350-0bda-50da-9740-4aea324ee249', 'عضوٌ نتنفّس به ونشمّ به الروائح في الوقت نفسه. ما هو؟', '[{"id":"a","text":"الأنف"},{"id":"b","text":"العين"},{"id":"c","text":"اليد"},{"id":"d","text":"الأذن"}]'::jsonb, 'a', 'الأنف يقوم بعملين: نتنفّس به ونشمّ به الروائح.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8013ca9c-1db2-517e-89ac-433406672204', 'decb6350-0bda-50da-9740-4aea324ee249', 'لماذا نقول إنّ العين عضوٌ مهمّ؟', '[{"id":"a","text":"لأنّنا نمشي بها"},{"id":"b","text":"لأنّنا نأكل بها"},{"id":"c","text":"لأنّنا نرى بها الألوان والأشياء من حولنا"},{"id":"d","text":"لأنّنا نسمع بها"}]'::jsonb, 'c', 'العين مهمّة لأنّها عضو النظر، نرى بها الألوان والأشياء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5d741f24-57af-57cc-aa0e-d67b631bb9e0', 'decb6350-0bda-50da-9740-4aea324ee249', 'عند ركل الكرة، أيّ أعضاء يعمل بعضها مع بعض؟', '[{"id":"a","text":"الأنف والأذن فقط"},{"id":"b","text":"العين ترى الكرة والرّجل تركلها"},{"id":"c","text":"الفم والظهر"},{"id":"d","text":"الأذنان فقط"}]'::jsonb, 'b', 'أعضاء الجسم تعمل معًا: العين ترى الكرة والرّجل تركلها.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('57958dcd-8bce-5f61-970a-82691873646e', 'b42373ba-809f-5fcd-bdae-797113780666', 'eveil-scientifique-1ere', '🛡️ مراجعة ⭐⭐: أُرتّبُ جسمي', 2, 70, 15, 'practice', 'admin', 3)
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
  ('b5794054-d04d-57b9-8e22-a50efe0b8d2c', '57958dcd-8bce-5f61-970a-82691873646e', 'أيّ مجموعةٍ كلّها أجزاءٌ كبيرة في الجسم؟', '[{"id":"a","text":"الرأس والجذع والأطراف"},{"id":"b","text":"الوردة والشجرة والقطّة"},{"id":"c","text":"القلم والكتاب والكرّاس"},{"id":"d","text":"الشمس والقمر"}]'::jsonb, 'a', 'ينقسم الجسم إلى ثلاثة أجزاء كبيرة: الرأس والجذع والأطراف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a402028a-1ddc-595c-aaeb-38a1c4bf12d7', '57958dcd-8bce-5f61-970a-82691873646e', 'أيّ عضوٍ من أعضاء الرأس؟', '[{"id":"a","text":"القدم"},{"id":"b","text":"العين"},{"id":"c","text":"البطن"},{"id":"d","text":"اليد"}]'::jsonb, 'b', 'العين عضو من أعضاء الرأس، وكذلك الأذن والأنف والفم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('06458902-9612-5a76-8ae7-3388b59b051b', '57958dcd-8bce-5f61-970a-82691873646e', 'بماذا نمسك الأشياء؟', '[{"id":"a","text":"بالأذنين"},{"id":"b","text":"بالأنف"},{"id":"c","text":"باليدين"},{"id":"d","text":"بالعينين"}]'::jsonb, 'c', 'نمسك الأشياء باليدين، فهما من أطراف الجسم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d5b9c75c-864d-5d18-b415-931630735fbf', '57958dcd-8bce-5f61-970a-82691873646e', 'أيّ جملةٍ صحيحة؟', '[{"id":"a","text":"نسمع بالعين"},{"id":"b","text":"نرى بالأذن"},{"id":"c","text":"نشمّ بالأنف"},{"id":"d","text":"نمشي باليد"}]'::jsonb, 'c', 'الصحيح أنّنا نشمّ بالأنف، ونرى بالعين، ونسمع بالأذن، ونمشي بالرّجل.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1646e8a-0fce-5bae-a7b2-b36d0550f4b5', '57958dcd-8bce-5f61-970a-82691873646e', 'ماذا يوجد داخل الجذع؟', '[{"id":"a","text":"العينان"},{"id":"b","text":"الصدر والبطن والظهر"},{"id":"c","text":"الأنف"},{"id":"d","text":"الأذنان"}]'::jsonb, 'b', 'الجذع وسط الجسم، وفيه الصدر والبطن والظهر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e2fecef-7727-54ab-bb6a-87128aaad904', '57958dcd-8bce-5f61-970a-82691873646e', 'بماذا نتكلّم؟', '[{"id":"a","text":"بالرّجل"},{"id":"b","text":"بالأذن"},{"id":"c","text":"بالعين"},{"id":"d","text":"بالفم"}]'::jsonb, 'd', 'نتكلّم ونأكل بالفم، فهو من أعضاء الرأس المهمّة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d2a351e1-f409-53e1-9cc4-4a7019b2420d', 'b42373ba-809f-5fcd-bdae-797113780666', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: خبير الجسم', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('38c992f6-e1a3-50fc-901c-bbbec91b642a', 'd2a351e1-f409-53e1-9cc4-4a7019b2420d', 'أغمض طفلٌ عينيه فلم يعد يرى، لكنّه سمع صوت أمّه. أيّ عضوٍ ما زال يعمل؟', '[{"id":"a","text":"العينان"},{"id":"b","text":"الأذنان"},{"id":"c","text":"الرّجلان"},{"id":"d","text":"لا شيء"}]'::jsonb, 'b', 'حين نغمض العينين تتوقّف الرؤية، لكنّ الأذنين تبقيان تسمعان الأصوات.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f208823b-ae2a-5a2d-853a-709d8bd09873', 'd2a351e1-f409-53e1-9cc4-4a7019b2420d', 'لماذا نحتاج إلى الرّجلين واليدين معًا عند صعود السلّم؟', '[{"id":"a","text":"الرّجلان للمشي واليدان للإمساك بالدرابزين للأمان"},{"id":"b","text":"لأنّهما لا يفيدان في شيء"},{"id":"c","text":"لنسمع بهما"},{"id":"d","text":"لنشمّ بهما"}]'::jsonb, 'a', 'نصعد السلّم بالرّجلين ونمسك الدرابزين باليدين حتّى لا نقع.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25c2ea08-a044-5d66-8ac0-f3efa124055d', 'd2a351e1-f409-53e1-9cc4-4a7019b2420d', 'صنّفي: أيّ مجموعةٍ كلّها أعضاءٌ في الرأس؟', '[{"id":"a","text":"اليد والرّجل والبطن"},{"id":"b","text":"الصدر والظهر والقدم"},{"id":"c","text":"العين والأذن والأنف والفم"},{"id":"d","text":"الذراع والساق"}]'::jsonb, 'c', 'العين والأذن والأنف والفم كلّها أعضاء موجودة في الرأس.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('05cdeba4-f51f-5424-923c-844748539ca9', 'd2a351e1-f409-53e1-9cc4-4a7019b2420d', 'أرادت سلمى أن تشمّ زهرةً وتلمسها في الوقت نفسه. أيّ عضوين تستعمل؟', '[{"id":"a","text":"الأذن والعين"},{"id":"b","text":"الأنف للشمّ واليد للّمس"},{"id":"c","text":"الرّجل والفم"},{"id":"d","text":"العين والظهر"}]'::jsonb, 'b', 'تشمّ الزهرة بالأنف وتلمسها باليد، فلكلّ عضوٍ وظيفته.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('affce432-5f76-5dd4-9b73-5ceb96d10bfc', 'd2a351e1-f409-53e1-9cc4-4a7019b2420d', 'لماذا نقول إنّ أعضاء الجسم تتعاون؟', '[{"id":"a","text":"لأنّ كلّ عضوٍ يعمل وحده تمامًا"},{"id":"b","text":"لأنّها لا تفعل شيئًا"},{"id":"c","text":"لأنّ كلّ عضوٍ يقوم بعمله فتكتمل الحركة، كرؤية الكرة وركلها"},{"id":"d","text":"لأنّها كلّها في الرأس"}]'::jsonb, 'c', 'أعضاء الجسم تتعاون: كلّ عضوٍ يقوم بعمله فتكتمل الحركة، مثل رؤية الكرة بالعين وركلها بالرّجل.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92081640-0e4d-5770-a56a-b23895163dfe', 'd2a351e1-f409-53e1-9cc4-4a7019b2420d', 'ولدٌ يجري في الملعب ويصفّق بيديه فرحًا. ما الأطراف التي يحرّكها؟', '[{"id":"a","text":"الأنف والأذن"},{"id":"b","text":"الظهر فقط"},{"id":"c","text":"العين والفم"},{"id":"d","text":"الرّجلان للجري واليدان للتصفيق"}]'::jsonb, 'd', 'يجري بالرّجلين ويصفّق باليدين، وكلّها من أطراف الجسم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c033f8b7-41d0-5aee-b508-09ba0e817e7a', 'b42373ba-809f-5fcd-bdae-797113780666', 'eveil-scientifique-1ere', '⚔️ تدريب الأبطال ⭐⭐⭐: أتقنُ معرفة جسمي', 3, 120, 30, 'boss', 'admin', 5)
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
  ('d5c1308a-cff9-5005-ae16-756f41d19f24', 'c033f8b7-41d0-5aee-b508-09ba0e817e7a', 'بأيّ عضوٍ نرى قوس قزح الملوّن في السماء؟', '[{"id":"a","text":"بالأذن"},{"id":"b","text":"بالعين"},{"id":"c","text":"بالأنف"},{"id":"d","text":"باليد"}]'::jsonb, 'b', 'نرى الألوان وقوس قزح بالعين، فهي عضو النظر.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5295f07e-e5cc-5a55-a320-abd37c6a675f', 'c033f8b7-41d0-5aee-b508-09ba0e817e7a', 'أيّ هذه ليست من أطراف الجسم؟', '[{"id":"a","text":"اليد"},{"id":"b","text":"الرّجل"},{"id":"c","text":"الأنف"},{"id":"d","text":"الذراع"}]'::jsonb, 'c', 'الأنف عضوٌ في الرأس وليس من الأطراف؛ الأطراف هي اليدان والرّجلان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4e65455-a4e9-5e05-adad-25d355f5df3b', 'c033f8b7-41d0-5aee-b508-09ba0e817e7a', 'طفلٌ يأكل تفّاحةً ويتكلّم مع أخيه. أيّ عضوٍ يستعمل في الاثنين؟', '[{"id":"a","text":"العين"},{"id":"b","text":"الأذن"},{"id":"c","text":"الرّجل"},{"id":"d","text":"الفم"}]'::jsonb, 'd', 'الفم يقوم بعملين: نأكل به ونتكلّم به.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d53a5bf0-758e-54b9-b58d-3f6c0cdf5aa9', 'c033f8b7-41d0-5aee-b508-09ba0e817e7a', 'لماذا نحتاج إلى الرّجلين؟', '[{"id":"a","text":"للرؤية"},{"id":"b","text":"للأكل"},{"id":"c","text":"للمشي والجري والقفز"},{"id":"d","text":"للشمّ"}]'::jsonb, 'c', 'نحتاج إلى الرّجلين للمشي والجري والقفز والوقوف.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40d68fa8-561a-538d-89e5-6f3a64701719', 'c033f8b7-41d0-5aee-b508-09ba0e817e7a', 'أين توجد الأذنان؟', '[{"id":"a","text":"في الرأس على جانبيه"},{"id":"b","text":"في القدمين"},{"id":"c","text":"في البطن"},{"id":"d","text":"في اليدين"}]'::jsonb, 'a', 'الأذنان توجدان في الرأس على جانبيه، ونسمع بهما.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('38544506-b87c-5f58-93c6-1d5f87129295', 'c033f8b7-41d0-5aee-b508-09ba0e817e7a', 'ما القاعدة الصحيحة عن أعضاء الجسم؟', '[{"id":"a","text":"كلّ الأعضاء تقوم بالعمل نفسه"},{"id":"b","text":"لكلّ عضوٍ وظيفته الخاصّة"},{"id":"c","text":"الأعضاء لا فائدة منها"},{"id":"d","text":"العين تسمع والأذن ترى"}]'::jsonb, 'b', 'لكلّ عضوٍ في الجسم وظيفته الخاصّة: العين للرؤية والأذن للسمع وهكذا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('064a503f-823e-5354-885f-c612030b3e9a', 'a44b8759-b158-516f-b967-00c22e55b652', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('8aa60509-9d85-57e6-9330-372d006b5cad', '064a503f-823e-5354-885f-c612030b3e9a', 'كم عدد حواسّي؟', '[{"id":"a","text":"حاسّتان"},{"id":"b","text":"خمس حواسّ"},{"id":"c","text":"ثلاث حواسّ"},{"id":"d","text":"عشر حواسّ"}]'::jsonb, 'b', 'للإنسان خمس حواسّ: البصر والسمع والشمّ والذوق واللمس.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('160096b0-649f-542e-82b5-48cd2e0aa89b', '064a503f-823e-5354-885f-c612030b3e9a', 'بأيّ حاسّةٍ أتذوّق طعم العسل الحلو؟', '[{"id":"a","text":"البصر"},{"id":"b","text":"السمع"},{"id":"c","text":"الذوق"},{"id":"d","text":"اللمس"}]'::jsonb, 'c', 'أتذوّق الطعم الحلو والمالح والحامض بحاسّة الذوق، وعضوها اللسان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f19aa452-730c-536f-9f42-946552ae4aa6', '064a503f-823e-5354-885f-c612030b3e9a', 'ما هو عضو حاسّة الشمّ؟', '[{"id":"a","text":"الأنف"},{"id":"b","text":"الأذن"},{"id":"c","text":"العين"},{"id":"d","text":"اللسان"}]'::jsonb, 'a', 'عضو حاسّة الشمّ هو الأنف، نشمّ به الروائح.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('941de08f-7304-5a25-8473-e1988b7e8810', '064a503f-823e-5354-885f-c612030b3e9a', 'كيف أعرف أنّ الكأس حارّة دون أن أراها؟', '[{"id":"a","text":"بحاسّة السمع"},{"id":"b","text":"بحاسّة اللمس"},{"id":"c","text":"بحاسّة الشمّ"},{"id":"d","text":"بحاسّة الذوق"}]'::jsonb, 'b', 'بحاسّة اللمس (الجلد واليدين) أعرف الحارّ من البارد والناعم من الخشن.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83ca12bb-c0e1-50f7-8dee-76ad78501fcc', '064a503f-823e-5354-885f-c612030b3e9a', 'أيّ حاسّةٍ تساعدني على معرفة لون الورود؟', '[{"id":"a","text":"الذوق"},{"id":"b","text":"اللمس"},{"id":"c","text":"السمع"},{"id":"d","text":"البصر"}]'::jsonb, 'd', 'بحاسّة البصر (العينين) أرى الأشياء وألوانها.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('abdf9d0f-3a49-5996-b3eb-8a43fc80290f', 'a44b8759-b158-516f-b967-00c22e55b652', 'eveil-scientifique-1ere', '⭐ تمرين: أكتشفُ حواسّي', 1, 50, 10, 'practice', 'admin', 1)
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
  ('7e9fc49d-83fa-5e6e-8987-ee2c14059ad7', 'abdf9d0f-3a49-5996-b3eb-8a43fc80290f', 'بأيّ حاسّةٍ أسمع صوت العصفور؟', '[{"id":"a","text":"السمع"},{"id":"b","text":"البصر"},{"id":"c","text":"الذوق"},{"id":"d","text":"الشمّ"}]'::jsonb, 'a', 'أسمع الأصوات بحاسّة السمع، وعضوها الأذن.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5fb926c2-f1be-5e82-99b4-750ae5a2b994', 'abdf9d0f-3a49-5996-b3eb-8a43fc80290f', 'بأيّ حاسّةٍ أشمّ رائحة الخبز؟', '[{"id":"a","text":"البصر"},{"id":"b","text":"الشمّ"},{"id":"c","text":"السمع"},{"id":"d","text":"اللمس"}]'::jsonb, 'b', 'أشمّ الروائح بحاسّة الشمّ، وعضوها الأنف.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49ae4b56-f99a-5d08-9cfb-b32e9adf7c1a', 'abdf9d0f-3a49-5996-b3eb-8a43fc80290f', 'أيّ عضوٍ نتذوّق به الطعام؟', '[{"id":"a","text":"الأذن"},{"id":"b","text":"العين"},{"id":"c","text":"اللسان"},{"id":"d","text":"الأنف"}]'::jsonb, 'c', 'نتذوّق الطعام باللسان، وهو عضو حاسّة الذوق.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aaa1c6c8-77d2-55b1-88f1-d3f1a1fbd9dc', 'abdf9d0f-3a49-5996-b3eb-8a43fc80290f', 'بأيّ حاسّةٍ أعرف أنّ القطن ناعم؟', '[{"id":"a","text":"اللمس"},{"id":"b","text":"السمع"},{"id":"c","text":"الذوق"},{"id":"d","text":"الشمّ"}]'::jsonb, 'a', 'أعرف الناعم والخشن بحاسّة اللمس، وعضوها الجلد واليدان.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6179b414-ec9c-5e37-abfa-e2fec95215dd', 'abdf9d0f-3a49-5996-b3eb-8a43fc80290f', 'أيّ حاسّةٍ تساعدني على رؤية الشمس؟', '[{"id":"a","text":"الذوق"},{"id":"b","text":"البصر"},{"id":"c","text":"السمع"},{"id":"d","text":"اللمس"}]'::jsonb, 'b', 'أرى الأشياء بحاسّة البصر، وعضوها العين.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b11d26c-d49f-5bc8-bbac-93303e669e55', 'abdf9d0f-3a49-5996-b3eb-8a43fc80290f', 'طعم الليمون حامض. بأيّ حاسّةٍ عرفنا ذلك؟', '[{"id":"a","text":"البصر"},{"id":"b","text":"السمع"},{"id":"c","text":"اللمس"},{"id":"d","text":"الذوق"}]'::jsonb, 'd', 'نعرف الطعم الحامض والحلو والمالح بحاسّة الذوق (اللسان).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('be532418-c0dd-59f3-9513-777a85031251', 'a44b8759-b158-516f-b967-00c22e55b652', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الحواسّ', 3, 120, 30, 'boss', 'admin', 2)
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
  ('78a6ed5e-5283-5b2e-8627-a0c2c13b1ff7', 'be532418-c0dd-59f3-9513-777a85031251', 'دخلت ليلى المطبخ فشمّت رائحة الطبخ اللذيذة. أيّ حاسّةٍ استعملت؟', '[{"id":"a","text":"الشمّ"},{"id":"b","text":"السمع"},{"id":"c","text":"البصر"},{"id":"d","text":"الذوق"}]'::jsonb, 'a', 'شمّت الرائحة بحاسّة الشمّ، وعضوها الأنف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('690f651d-a432-5e82-9389-ec7857a16b77', 'be532418-c0dd-59f3-9513-777a85031251', 'أراد سامي أن يعرف هل الماء حارّ قبل أن يستحمّ. أيّ حاسّةٍ يستعمل؟', '[{"id":"a","text":"البصر"},{"id":"b","text":"اللمس"},{"id":"c","text":"السمع"},{"id":"d","text":"الذوق"}]'::jsonb, 'b', 'يعرف الحارّ من البارد بحاسّة اللمس (الجلد واليدين).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('efa0861c-748a-5219-8999-19a8a6b5cf37', 'be532418-c0dd-59f3-9513-777a85031251', 'أيّ حاسّةٍ نستعملها لمعرفة طعم العسل؟', '[{"id":"a","text":"السمع"},{"id":"b","text":"البصر"},{"id":"c","text":"الذوق"},{"id":"d","text":"الشمّ"}]'::jsonb, 'c', 'نعرف الطعم الحلو بحاسّة الذوق، وعضوها اللسان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('414094c6-3eb4-58fc-aeb3-f777513833f3', 'be532418-c0dd-59f3-9513-777a85031251', 'في الظلام لا نرى، لكن يمكننا سماع صوت الجرس. أيّ حاسّةٍ تعمل في الظلام؟', '[{"id":"a","text":"السمع"},{"id":"b","text":"البصر"},{"id":"c","text":"لا حاسّة تعمل"},{"id":"d","text":"البصر فقط"}]'::jsonb, 'a', 'في الظلام يتوقّف البصر لكنّ السمع يبقى يعمل، فنسمع الأصوات.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0700838b-b802-5f4a-856d-a28a5f11810d', 'be532418-c0dd-59f3-9513-777a85031251', 'لماذا تساعدنا الحواسّ الخمس؟', '[{"id":"a","text":"لتجعلنا ننام"},{"id":"b","text":"لنعرف بها الأشياء والعالم من حولنا"},{"id":"c","text":"لا فائدة منها"},{"id":"d","text":"لنطير بها"}]'::jsonb, 'b', 'الحواسّ الخمس تساعدنا على معرفة الأشياء والعالم من حولنا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17a977dd-e365-5b5f-a113-e169cda41ca6', 'be532418-c0dd-59f3-9513-777a85031251', 'تذوّق طفلٌ ملحًا فوجده مالحًا، ثمّ ليمونًا فوجده حامضًا. أيّ حاسّةٍ ميّزت الطعمين؟', '[{"id":"a","text":"الشمّ"},{"id":"b","text":"اللمس"},{"id":"c","text":"البصر"},{"id":"d","text":"الذوق"}]'::jsonb, 'd', 'حاسّة الذوق (اللسان) تميّز بين الطعوم: الحلو والمالح والحامض.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('eb33804a-4580-573e-8a60-9ec1d8c27c11', 'a44b8759-b158-516f-b967-00c22e55b652', 'eveil-scientifique-1ere', '🛡️ مراجعة ⭐⭐: أُطابقُ الحاسّة بعضوها', 2, 70, 15, 'practice', 'admin', 3)
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
  ('14129722-7659-52c3-8d3a-8d8ff23ac3de', 'eb33804a-4580-573e-8a60-9ec1d8c27c11', 'حاسّة البصر عضوها...', '[{"id":"a","text":"العين"},{"id":"b","text":"الأذن"},{"id":"c","text":"اللسان"},{"id":"d","text":"الأنف"}]'::jsonb, 'a', 'عضو حاسّة البصر هو العين، نرى بها الأشياء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a27cf14-2713-5271-ab14-c8010e6a7c7d', 'eb33804a-4580-573e-8a60-9ec1d8c27c11', 'حاسّة السمع عضوها...', '[{"id":"a","text":"اللسان"},{"id":"b","text":"الأذن"},{"id":"c","text":"العين"},{"id":"d","text":"الجلد"}]'::jsonb, 'b', 'عضو حاسّة السمع هو الأذن، نسمع بها الأصوات.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e900a87f-81b3-5747-b724-50611a008fa4', 'eb33804a-4580-573e-8a60-9ec1d8c27c11', 'حاسّة الذوق عضوها...', '[{"id":"a","text":"العين"},{"id":"b","text":"الأنف"},{"id":"c","text":"اللسان"},{"id":"d","text":"الأذن"}]'::jsonb, 'c', 'عضو حاسّة الذوق هو اللسان، نتذوّق به الطعام.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e78d0de-7a9d-55bc-9f78-57199deaf6b0', 'eb33804a-4580-573e-8a60-9ec1d8c27c11', 'أيّ جملةٍ صحيحة؟', '[{"id":"a","text":"نشمّ باللسان"},{"id":"b","text":"نسمع بالعين"},{"id":"c","text":"نرى بالأذن"},{"id":"d","text":"نلمس بالجلد"}]'::jsonb, 'd', 'الصحيح أنّنا نلمس بالجلد، ونشمّ بالأنف، ونسمع بالأذن، ونرى بالعين.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c85fd09-dfa5-55a5-997a-340a5bfdee48', 'eb33804a-4580-573e-8a60-9ec1d8c27c11', 'ما الذي نعرفه بحاسّة اللمس؟', '[{"id":"a","text":"اللون"},{"id":"b","text":"الصوت"},{"id":"c","text":"الناعم والخشن والحارّ والبارد"},{"id":"d","text":"الرائحة"}]'::jsonb, 'c', 'بحاسّة اللمس نعرف هل الشيء ناعمٌ أم خشن، حارٌّ أم بارد.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('20927f2f-e7d2-51e0-9841-151c931ecb49', 'eb33804a-4580-573e-8a60-9ec1d8c27c11', 'حاسّة الشمّ عضوها...', '[{"id":"a","text":"اللسان"},{"id":"b","text":"العين"},{"id":"c","text":"الأذن"},{"id":"d","text":"الأنف"}]'::jsonb, 'd', 'عضو حاسّة الشمّ هو الأنف، نشمّ به الروائح.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e177ab22-f2a0-5446-8b78-20d841d22b7d', 'a44b8759-b158-516f-b967-00c22e55b652', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: خبير الحواسّ', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('2e24e50f-6f6c-5c67-b7ab-ec8709cf6f59', 'e177ab22-f2a0-5446-8b78-20d841d22b7d', 'كيف نعرف أنّ الجرس يرنّ ونحن في غرفةٍ أخرى لا نراه؟', '[{"id":"a","text":"بحاسّة السمع، نسمع صوته بالأذن"},{"id":"b","text":"بحاسّة البصر"},{"id":"c","text":"بحاسّة الذوق"},{"id":"d","text":"بحاسّة الشمّ"}]'::jsonb, 'a', 'نسمع صوت الجرس بحاسّة السمع حتّى دون أن نراه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6146ba6b-58e4-58da-b380-fe2b16bff227', 'e177ab22-f2a0-5446-8b78-20d841d22b7d', 'أمسك طفلٌ تفّاحةً: رأى لونها الأحمر وشمّ رائحتها ثمّ تذوّقها. كم حاسّةً استعمل؟', '[{"id":"a","text":"حاسّة واحدة"},{"id":"b","text":"ثلاث حواسّ: البصر والشمّ والذوق"},{"id":"c","text":"حاسّتان فقط"},{"id":"d","text":"خمس حواسّ"}]'::jsonb, 'b', 'استعمل ثلاث حواسّ: البصر ليرى اللون، والشمّ ليشمّ الرائحة، والذوق ليتذوّق الطعم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1dd19987-867f-5d1f-8df2-278b68a2c539', 'e177ab22-f2a0-5446-8b78-20d841d22b7d', 'في غرفةٍ مظلمةٍ تمامًا، أيّ حاسّةٍ لا تستطيع أن تعمل؟', '[{"id":"a","text":"السمع"},{"id":"b","text":"اللمس"},{"id":"c","text":"البصر"},{"id":"d","text":"الشمّ"}]'::jsonb, 'c', 'البصر يحتاج إلى الضوء، ففي الظلام لا نرى، لكن باقي الحواسّ تعمل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b83e220-97b2-5b09-adf0-070df19d568c', 'e177ab22-f2a0-5446-8b78-20d841d22b7d', 'صنّفي: أيّ مجموعةٍ تربط كلّ حاسّةٍ بعضوها الصحيح؟', '[{"id":"a","text":"البصر بالأذن، السمع بالعين"},{"id":"b","text":"الشمّ باللسان، الذوق بالأنف"},{"id":"c","text":"البصر بالعين، السمع بالأذن، الذوق باللسان"},{"id":"d","text":"اللمس بالعين، البصر بالجلد"}]'::jsonb, 'c', 'الربط الصحيح: البصر بالعين، السمع بالأذن، الذوق باللسان، الشمّ بالأنف، اللمس بالجلد.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ffea6b78-826d-5fe7-aaf7-43ff7a3e17e2', 'e177ab22-f2a0-5446-8b78-20d841d22b7d', 'لماذا نستعمل أكثر من حاسّةٍ في الوقت نفسه أحيانًا؟', '[{"id":"a","text":"لأنّ حاسّةً واحدةً تكفي دائمًا"},{"id":"b","text":"لأنّ كلّ حاسّةٍ تعطينا معلومةً مختلفةً عن الشيء"},{"id":"c","text":"لأنّ الحواسّ لا تفيد"},{"id":"d","text":"لأنّها كلّها تعطي اللون"}]'::jsonb, 'b', 'نستعمل أكثر من حاسّةٍ لأنّ كلّ حاسّةٍ تعطينا معلومةً مختلفة: اللون والرائحة والطعم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6da5dcb3-885a-5d5d-9ec4-d2339288fe26', 'e177ab22-f2a0-5446-8b78-20d841d22b7d', 'أيّ حاسّةٍ تحمينا فنبتعد عن إناءٍ ساخنٍ بمجرّد لمسه؟', '[{"id":"a","text":"الشمّ"},{"id":"b","text":"البصر"},{"id":"c","text":"السمع"},{"id":"d","text":"اللمس"}]'::jsonb, 'd', 'حاسّة اللمس تنبّهنا إلى الحرارة فنبتعد عن الإناء الساخن بسرعةٍ لنحمي أنفسنا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bce05e32-58fc-5dab-bacd-6d5ba083ac97', 'a44b8759-b158-516f-b967-00c22e55b652', 'eveil-scientifique-1ere', '⚔️ تدريب الأبطال ⭐⭐⭐: أُتقنُ حواسّي', 3, 120, 30, 'boss', 'admin', 5)
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
  ('b6c05609-6566-54d9-b911-86fc18fcb788', 'bce05e32-58fc-5dab-bacd-6d5ba083ac97', 'سمع أحمد رنين الهاتف. أيّ حاسّةٍ استعمل؟', '[{"id":"a","text":"السمع"},{"id":"b","text":"الشمّ"},{"id":"c","text":"الذوق"},{"id":"d","text":"اللمس"}]'::jsonb, 'a', 'سمع الرنين بحاسّة السمع، وعضوها الأذن.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74f3b64f-ddcc-5c19-a2de-a2a3fd100ec2', 'bce05e32-58fc-5dab-bacd-6d5ba083ac97', 'أيّ حاسّةٍ نعرف بها أنّ الثلج بارد؟', '[{"id":"a","text":"البصر"},{"id":"b","text":"اللمس"},{"id":"c","text":"السمع"},{"id":"d","text":"الشمّ"}]'::jsonb, 'b', 'نعرف البارد والحارّ بحاسّة اللمس (الجلد واليدين).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ead6aac3-c4f1-5735-81bc-b0d088fd5b25', 'bce05e32-58fc-5dab-bacd-6d5ba083ac97', 'أيّ حاسّةٍ تساعد الطبّاخ على معرفة أنّ الطعام مالحٌ جدًّا؟', '[{"id":"a","text":"البصر"},{"id":"b","text":"السمع"},{"id":"c","text":"الذوق"},{"id":"d","text":"اللمس"}]'::jsonb, 'c', 'يعرف الطبّاخ الطعم المالح بحاسّة الذوق، وعضوها اللسان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7be4a9c-5f12-5ce5-b147-f3dc60332cf6', 'bce05e32-58fc-5dab-bacd-6d5ba083ac97', 'لماذا نحتاج إلى حاسّة الشمّ في الحياة؟', '[{"id":"a","text":"لنرى الألوان"},{"id":"b","text":"لنشمّ الروائح ونعرف الطعام الفاسد أو الدخان"},{"id":"c","text":"لنسمع الأصوات"},{"id":"d","text":"لنمشي"}]'::jsonb, 'b', 'حاسّة الشمّ تساعدنا على شمّ الروائح، وقد تنبّهنا إلى طعامٍ فاسدٍ أو دخانٍ خطر.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e28ef9ab-7cea-575a-9e5d-d8f88133ed4e', 'bce05e32-58fc-5dab-bacd-6d5ba083ac97', 'طفلٌ يقرأ كتابًا ملوّنًا في وضح النهار. أيّ حاسّةٍ الأساسية يستعمل؟', '[{"id":"a","text":"الذوق"},{"id":"b","text":"الشمّ"},{"id":"c","text":"البصر"},{"id":"d","text":"السمع"}]'::jsonb, 'c', 'يقرأ بحاسّة البصر، فالعين ترى الحروف والألوان.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1412d85-b6e6-597d-b52e-8c7de35141cf', 'bce05e32-58fc-5dab-bacd-6d5ba083ac97', 'ما القاعدة الصحيحة عن الحواسّ الخمس؟', '[{"id":"a","text":"كلّ الحواسّ لها العضو نفسه"},{"id":"b","text":"حاسّة واحدة تكفي لمعرفة كلّ شيء"},{"id":"c","text":"الحواسّ لا فائدة منها"},{"id":"d","text":"لكلّ حاسّةٍ عضوها ووظيفتها الخاصّة"}]'::jsonb, 'd', 'لكلّ حاسّةٍ من الحواسّ الخمس عضوها الخاصّ ووظيفتها الخاصّة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a9b48932-215f-5a0b-b5c1-15d4dcfad64f', 'fd429555-0a1a-5838-b63a-5a9379ae7a66', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('09c2debc-7f79-5f2b-a738-570ee3bdeba6', 'a9b48932-215f-5a0b-b5c1-15d4dcfad64f', 'بماذا أغسل يديّ لأطرد الجراثيم؟', '[{"id":"a","text":"بالماء والصابون"},{"id":"b","text":"بالتراب"},{"id":"c","text":"بالزيت"},{"id":"d","text":"لا أغسلهما"}]'::jsonb, 'a', 'أغسل يديّ بالماء والصابون معًا لأطرد الجراثيم وأحمي صحّتي.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03450c8a-304e-5a07-809d-4c3832fa1426', 'a9b48932-215f-5a0b-b5c1-15d4dcfad64f', 'متى يجب أن أغسل يديّ؟', '[{"id":"a","text":"مرّةً في الأسبوع"},{"id":"b","text":"قبل الأكل وبعد دخول المرحاض"},{"id":"c","text":"أبدًا"},{"id":"d","text":"عند النوم فقط"}]'::jsonb, 'b', 'أغسل يديّ قبل الأكل وبعده وبعد دخول المرحاض وبعد اللعب.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a0047c3-525e-5c54-b371-75ad9aa9ac8f', 'a9b48932-215f-5a0b-b5c1-15d4dcfad64f', 'بماذا أنظّف أسناني؟', '[{"id":"a","text":"بالمنديل"},{"id":"b","text":"بالماء وحده"},{"id":"c","text":"بالفرشاة والمعجون"},{"id":"d","text":"بالملعقة"}]'::jsonb, 'c', 'أنظّف أسناني بالفرشاة والمعجون لأحميها من التسوّس.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('824b9e08-198c-5c7f-995d-e15b8d3b0b1f', 'a9b48932-215f-5a0b-b5c1-15d4dcfad64f', 'كم مرّةً في اليوم أنظّف أسناني؟', '[{"id":"a","text":"مرّةً في الشهر"},{"id":"b","text":"أبدًا"},{"id":"c","text":"عشر مرّات"},{"id":"d","text":"مرّتين: في الصباح وقبل النوم"}]'::jsonb, 'd', 'أنظّف أسناني مرّتين في اليوم: في الصباح وقبل النوم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bfe61f4c-acfa-56ca-9fe2-28524b740ea8', 'a9b48932-215f-5a0b-b5c1-15d4dcfad64f', 'لماذا نلبس ملابس نظيفة؟', '[{"id":"a","text":"لتحمينا وتجعلنا مرتّبين أصحّاء"},{"id":"b","text":"لنتّسخ أكثر"},{"id":"c","text":"لا فائدة منها"},{"id":"d","text":"لنمرض"}]'::jsonb, 'a', 'الملابس النظيفة تحمينا وتجعلنا مرتّبين أصحّاء جميلين.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1799e069-1e98-51ed-ba7f-60b12621b696', 'fd429555-0a1a-5838-b63a-5a9379ae7a66', 'eveil-scientifique-1ere', '⭐ تمرين: عادات النظافة', 1, 50, 10, 'practice', 'admin', 1)
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
  ('c683713a-1ec2-58ec-998f-b2fc53d818f3', '1799e069-1e98-51ed-ba7f-60b12621b696', 'ماذا أستعمل لغسل يديّ جيّدًا؟', '[{"id":"a","text":"الماء والصابون"},{"id":"b","text":"الرمل"},{"id":"c","text":"الحليب"},{"id":"d","text":"العصير"}]'::jsonb, 'a', 'أغسل يديّ بالماء والصابون لأطرد الجراثيم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5811944-8830-5322-9de6-89d4ba498348', '1799e069-1e98-51ed-ba7f-60b12621b696', 'ماذا أفعل قبل الأكل؟', '[{"id":"a","text":"ألعب بالتراب"},{"id":"b","text":"أغسل يديّ"},{"id":"c","text":"أنام"},{"id":"d","text":"أرمي القمامة"}]'::jsonb, 'b', 'أغسل يديّ قبل الأكل حتّى لا تدخل الجراثيم إلى بطني.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dbe39f54-6b90-5910-9448-5b0567edb374', '1799e069-1e98-51ed-ba7f-60b12621b696', 'بماذا أنظّف أسناني؟', '[{"id":"a","text":"بالمشط"},{"id":"b","text":"بالمنشفة"},{"id":"c","text":"بالفرشاة والمعجون"},{"id":"d","text":"بالملعقة"}]'::jsonb, 'c', 'أنظّف أسناني بالفرشاة والمعجون.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bf5f0806-85cf-56e4-bf4f-5a7fb571b892', '1799e069-1e98-51ed-ba7f-60b12621b696', 'كيف أنظّف كلّ جسمي؟', '[{"id":"a","text":"ألبس ملابس متّسخة"},{"id":"b","text":"لا أفعل شيئًا"},{"id":"c","text":"آكل كثيرًا"},{"id":"d","text":"أستحمّ بالماء والصابون"}]'::jsonb, 'd', 'أنظّف كلّ جسمي بالاستحمام بالماء والصابون بانتظام.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fefcf310-12e3-5f1f-97fe-4891ad2b22b4', '1799e069-1e98-51ed-ba7f-60b12621b696', 'متى أغيّر ملابسي؟', '[{"id":"a","text":"عندما تتّسخ"},{"id":"b","text":"أبدًا"},{"id":"c","text":"مرّةً في السنة"},{"id":"d","text":"عندما تكون نظيفة"}]'::jsonb, 'a', 'أغيّر ملابسي عندما تتّسخ، وألبس دائمًا ملابس نظيفة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1097467e-b86d-57c0-ab95-4923f263aa78', '1799e069-1e98-51ed-ba7f-60b12621b696', 'أيّ هذه عادةٌ نظيفة؟', '[{"id":"a","text":"اللعب دون غسل اليدين"},{"id":"b","text":"قصّ الأظافر وتمشيط الشعر"},{"id":"c","text":"ترك الأسنان دون تنظيف"},{"id":"d","text":"لبس ملابس متّسخة"}]'::jsonb, 'b', 'قصّ الأظافر وتمشيط الشعر من عادات النظافة الجيّدة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1aef5159-7685-58dd-9647-0314fef6e1b3', 'fd429555-0a1a-5838-b63a-5a9379ae7a66', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: بطل النظافة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('01ae65c7-0ebd-58aa-9e8b-711e5dae8cd4', '1aef5159-7685-58dd-9647-0314fef6e1b3', 'رجع سامي من اللعب في الحديقة ويداه متّسختان. ماذا يفعل قبل الأكل؟', '[{"id":"a","text":"يغسل يديه بالماء والصابون"},{"id":"b","text":"يأكل مباشرةً"},{"id":"c","text":"ينام"},{"id":"d","text":"يمسحهما بالتراب"}]'::jsonb, 'a', 'يجب أن يغسل يديه بالماء والصابون قبل الأكل لطرد الجراثيم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9897dd45-1219-5c32-871b-dec1a9d884ce', '1aef5159-7685-58dd-9647-0314fef6e1b3', 'لماذا ننظّف أسناننا قبل النوم؟', '[{"id":"a","text":"لنبقى مستيقظين"},{"id":"b","text":"لنزيل بقايا الطعام ونحمي الأسنان من التسوّس"},{"id":"c","text":"لا فائدة من ذلك"},{"id":"d","text":"لنجوع"}]'::jsonb, 'b', 'ننظّف أسناننا قبل النوم لإزالة بقايا الطعام وحماية الأسنان من التسوّس.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f3f5529-7552-5578-8bdc-6f06e7bebf2d', '1aef5159-7685-58dd-9647-0314fef6e1b3', 'ما الذي تخفيه الأوساخ على اليدين؟', '[{"id":"a","text":"ألوانًا جميلة"},{"id":"b","text":"حلوى"},{"id":"c","text":"جراثيم قد تسبّب المرض"},{"id":"d","text":"ماءً نظيفًا"}]'::jsonb, 'c', 'الأوساخ تخفي جراثيم صغيرةً قد تسبّب المرض، لذلك نغسل أيدينا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d425086a-24d2-5936-8a9e-26ca8b02ad6d', '1aef5159-7685-58dd-9647-0314fef6e1b3', 'ليلى لبست ملابس نظيفة بعد الاستحمام. لماذا هذا سلوكٌ صحيح؟', '[{"id":"a","text":"لأنّ الملابس النظيفة على جسمٍ نظيفٍ تحافظ على الصحّة"},{"id":"b","text":"لأنّها تريد أن تتّسخ"},{"id":"c","text":"لأنّ النظافة مضرّة"},{"id":"d","text":"لا سبب لذلك"}]'::jsonb, 'a', 'لبس ملابس نظيفة بعد الاستحمام يحافظ على نظافة الجسم وصحّته.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1e06cc8-4c67-537b-88f8-adf3af4e846e', '1aef5159-7685-58dd-9647-0314fef6e1b3', 'لماذا نقول إنّ النظافة تحمي صحّتنا؟', '[{"id":"a","text":"لأنّها تجعلنا نمرض"},{"id":"b","text":"لأنّها تجلب الجراثيم"},{"id":"c","text":"لأنّها تبعد الجراثيم والأوساخ التي تسبّب الأمراض"},{"id":"d","text":"لا علاقة لها بالصحّة"}]'::jsonb, 'c', 'النظافة تبعد الجراثيم والأوساخ المسبّبة للأمراض، فتحمي صحّتنا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce176db7-2870-558a-b735-57479f674490', '1aef5159-7685-58dd-9647-0314fef6e1b3', 'أيّ ترتيبٍ صحيحٌ للعناية بالجسم في الصباح؟', '[{"id":"a","text":"ألعب بالوحل ثمّ آكل"},{"id":"b","text":"أغسل وجهي وأنظّف أسناني وألبس ملابس نظيفة"},{"id":"c","text":"أبقى دون غسل"},{"id":"d","text":"ألبس ملابس متّسخة"}]'::jsonb, 'b', 'في الصباح أغسل وجهي وأنظّف أسناني وألبس ملابس نظيفة لأبدأ يومي بنشاطٍ ونظافة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0a77dd49-9267-5c09-9bec-dae4d1a811ae', 'fd429555-0a1a-5838-b63a-5a9379ae7a66', 'eveil-scientifique-1ere', '🛡️ مراجعة ⭐⭐: عاداتي النظيفة', 2, 70, 15, 'practice', 'admin', 3)
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
  ('2c3f9c06-1aa9-5661-b932-541c2266cf9d', '0a77dd49-9267-5c09-9bec-dae4d1a811ae', 'أيّ هذه أداةٌ لتنظيف الأسنان؟', '[{"id":"a","text":"الفرشاة"},{"id":"b","text":"المشط"},{"id":"c","text":"الملعقة"},{"id":"d","text":"القلم"}]'::jsonb, 'a', 'ننظّف الأسنان بفرشاة الأسنان مع المعجون.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2beb0cd-9cdf-5a44-aaa5-db6a4ad11c76', '0a77dd49-9267-5c09-9bec-dae4d1a811ae', 'أغسل يديّ بعد...', '[{"id":"a","text":"النوم فقط"},{"id":"b","text":"دخول المرحاض"},{"id":"c","text":"النظر إلى التلفاز"},{"id":"d","text":"القراءة"}]'::jsonb, 'b', 'أغسل يديّ بعد دخول المرحاض وقبل الأكل وبعد اللعب.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5d3fcc3e-0e58-577e-afc5-60a726aa60d1', '0a77dd49-9267-5c09-9bec-dae4d1a811ae', 'ماذا أفعل لشعري للعناية به؟', '[{"id":"a","text":"أتركه دون تمشيط"},{"id":"b","text":"أرميه"},{"id":"c","text":"أمشّطه وأغسله"},{"id":"d","text":"ألوّنه بالتراب"}]'::jsonb, 'c', 'أعتني بشعري بتمشيطه وغسله ليبقى نظيفًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87cfcefd-1217-5cd8-8a4a-1e62494a24ca', '0a77dd49-9267-5c09-9bec-dae4d1a811ae', 'أيّ جملةٍ صحيحة عن النظافة؟', '[{"id":"a","text":"النظافة تجلب المرض"},{"id":"b","text":"النظافة لا فائدة منها"},{"id":"c","text":"النظافة تحمي صحّتي"},{"id":"d","text":"النظافة مرّةً في السنة"}]'::jsonb, 'c', 'النظافة تحمي صحّتي وتبعد عنّي الجراثيم والأمراض.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6bf02dc4-c114-5d36-848c-9c4f4cd294c3', '0a77dd49-9267-5c09-9bec-dae4d1a811ae', 'لماذا أقصّ أظافري؟', '[{"id":"a","text":"لتطول أكثر"},{"id":"b","text":"لأنّ الأوساخ والجراثيم تختبئ تحت الأظافر الطويلة"},{"id":"c","text":"لا سبب"},{"id":"d","text":"لأجرح بها"}]'::jsonb, 'b', 'أقصّ أظافري لأنّ الأوساخ والجراثيم تختبئ تحت الأظافر الطويلة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be89e03c-efd1-5945-8f63-03347cf940c1', '0a77dd49-9267-5c09-9bec-dae4d1a811ae', 'ماذا أستعمل مع الفرشاة لتنظيف الأسنان؟', '[{"id":"a","text":"الصابون"},{"id":"b","text":"الماء وحده"},{"id":"c","text":"الزيت"},{"id":"d","text":"المعجون"}]'::jsonb, 'd', 'نستعمل معجون الأسنان مع الفرشاة لتنظيف الأسنان جيّدًا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('259b8c6b-a8ed-59e7-8b1c-4b893ad77efe', 'fd429555-0a1a-5838-b63a-5a9379ae7a66', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: حارس الصحّة', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('38dbd517-66f2-5f28-93eb-629176580f49', '259b8c6b-a8ed-59e7-8b1c-4b893ad77efe', 'أرادت سلمى أن تحافظ على نظافتها طوال اليوم. أيّ خطّةٍ صحيحة؟', '[{"id":"a","text":"تستحمّ مرّةً في السنة"},{"id":"b","text":"لا تغسل يديها أبدًا"},{"id":"c","text":"تغسل يديها قبل الأكل، وتنظّف أسنانها صباحًا ومساءً، وتلبس ملابس نظيفة"},{"id":"d","text":"تلعب بالوحل دون استحمام"}]'::jsonb, 'c', 'الخطّة الصحيحة: غسل اليدين قبل الأكل، وتنظيف الأسنان صباحًا ومساءً، ولبس ملابس نظيفة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6515830e-a7c4-5510-922a-fa7f48049b58', '259b8c6b-a8ed-59e7-8b1c-4b893ad77efe', 'طفلٌ أكل دائمًا الحلوى ولم ينظّف أسنانه أبدًا. ماذا يحدث لأسنانه؟', '[{"id":"a","text":"تصبح أقوى"},{"id":"b","text":"تُصاب بالتسوّس وتؤلمه"},{"id":"c","text":"لا يحدث شيء"},{"id":"d","text":"تصير أنظف"}]'::jsonb, 'b', 'إهمال تنظيف الأسنان مع كثرة الحلوى يؤدّي إلى التسوّس والألم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee4050e2-0692-5f0d-9da2-f3f292f2cc11', '259b8c6b-a8ed-59e7-8b1c-4b893ad77efe', 'لماذا لا يكفي غسل اليدين بالماء وحده؟', '[{"id":"a","text":"لأنّ الماء مضرّ"},{"id":"b","text":"لأنّ الصابون يساعد على إزالة الجراثيم بشكلٍ أفضل"},{"id":"c","text":"لأنّ الماء يجلب الجراثيم"},{"id":"d","text":"لا فرق بينهما"}]'::jsonb, 'b', 'نستعمل الماء والصابون معًا لأنّ الصابون يساعد على إزالة الجراثيم أكثر من الماء وحده.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6652581-a2fc-53c5-b5e4-cd90de73a289', '259b8c6b-a8ed-59e7-8b1c-4b893ad77efe', 'صنّفي: أيّ مجموعةٍ كلّها عادات نظافة صحيحة؟', '[{"id":"a","text":"غسل اليدين، تنظيف الأسنان، الاستحمام"},{"id":"b","text":"اللعب بالوحل، عدم الاستحمام"},{"id":"c","text":"لبس ملابس متّسخة، ترك الأظافر طويلة"},{"id":"d","text":"عدم غسل اليدين، أكل الحلوى دون تنظيف الأسنان"}]'::jsonb, 'a', 'غسل اليدين وتنظيف الأسنان والاستحمام كلّها عادات نظافة صحيحة تحمي الصحّة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('def62ca7-94a4-57f9-8175-b10ed2964cdb', '259b8c6b-a8ed-59e7-8b1c-4b893ad77efe', 'لماذا تنتقل الأمراض بسهولةٍ بين من لا يغسلون أيديهم؟', '[{"id":"a","text":"لأنّ الجراثيم تنتقل عبر اليدين المتّسخة إلى الفم والطعام"},{"id":"b","text":"لأنّ الأمراض تحبّ النظافة"},{"id":"c","text":"لأنّ اليدين لا تحملان جراثيم"},{"id":"d","text":"لا تنتقل الأمراض أبدًا"}]'::jsonb, 'a', 'الجراثيم تنتقل عبر اليدين المتّسخة إلى الفم والطعام، فتنتشر الأمراض؛ لذلك نغسل أيدينا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('91c4636e-159f-5280-8c78-dbdc0d16667b', '259b8c6b-a8ed-59e7-8b1c-4b893ad77efe', 'ما القاعدة الذهبية للنظافة؟', '[{"id":"a","text":"النظافة مرّةً في الأسبوع تكفي"},{"id":"b","text":"النظافة للكبار فقط"},{"id":"c","text":"النظافة مضرّة"},{"id":"d","text":"النظافة عادةٌ يوميّةٌ تحمي صحّتنا وتجعلنا أصحّاء"}]'::jsonb, 'd', 'القاعدة الذهبية: النظافة عادةٌ يوميّةٌ تحمي صحّتنا وتجعلنا أصحّاء أقوياء.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0f389ea8-0fc1-530d-83d8-9224dc2c4075', 'fd429555-0a1a-5838-b63a-5a9379ae7a66', 'eveil-scientifique-1ere', '⚔️ تدريب الأبطال ⭐⭐⭐: أُتقنُ النظافة', 3, 120, 30, 'boss', 'admin', 5)
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
  ('6d6559f8-fa8c-581b-b2a1-f29655c5e9c3', '0f389ea8-0fc1-530d-83d8-9224dc2c4075', 'بعد دخول المرحاض، ماذا يجب أن أفعل؟', '[{"id":"a","text":"أغسل يديّ بالماء والصابون"},{"id":"b","text":"آكل مباشرةً"},{"id":"c","text":"ألعب"},{"id":"d","text":"لا شيء"}]'::jsonb, 'a', 'بعد دخول المرحاض أغسل يديّ بالماء والصابون لطرد الجراثيم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5622b1ef-9451-5ec1-b427-ad4e1f457a99', '0f389ea8-0fc1-530d-83d8-9224dc2c4075', 'ما الذي يحمي الأسنان من التسوّس؟', '[{"id":"a","text":"أكل الحلوى كثيرًا"},{"id":"b","text":"تنظيفها بالفرشاة والمعجون"},{"id":"c","text":"تركها دون تنظيف"},{"id":"d","text":"النوم فقط"}]'::jsonb, 'b', 'تنظيف الأسنان بالفرشاة والمعجون يحميها من التسوّس.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11eb13da-e043-505e-83ba-270204a9259f', '0f389ea8-0fc1-530d-83d8-9224dc2c4075', 'لماذا نستحمّ بانتظام؟', '[{"id":"a","text":"لننظّف كلّ جسمنا ونزيل الأوساخ والعرق"},{"id":"b","text":"لنتّسخ أكثر"},{"id":"c","text":"لنجلب الجراثيم"},{"id":"d","text":"لا فائدة"}]'::jsonb, 'a', 'نستحمّ بانتظام لتنظيف كلّ الجسم وإزالة الأوساخ والعرق.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42629960-53cd-52be-90b7-48adae414781', '0f389ea8-0fc1-530d-83d8-9224dc2c4075', 'أيّ سلوكٍ يدلّ على طفلٍ نظيف؟', '[{"id":"a","text":"ملابس متّسخة وأظافر طويلة"},{"id":"b","text":"لا يغسل يديه"},{"id":"c","text":"يدان نظيفتان وأسنان مغسولة وملابس نظيفة"},{"id":"d","text":"شعر غير ممشّط"}]'::jsonb, 'c', 'الطفل النظيف له يدان نظيفتان وأسنان مغسولة وملابس نظيفة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a20aab46-5e84-5685-877c-229d69d0083a', '0f389ea8-0fc1-530d-83d8-9224dc2c4075', 'لماذا نغيّر الملابس المتّسخة؟', '[{"id":"a","text":"لأنّها جميلة"},{"id":"b","text":"لأنّ الملابس المتّسخة تحمل أوساخًا وجراثيم"},{"id":"c","text":"لا سبب"},{"id":"d","text":"لنتّسخ أكثر"}]'::jsonb, 'b', 'نغيّر الملابس المتّسخة لأنّها تحمل أوساخًا وجراثيم قد تضرّ بصحّتنا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1bdb134e-612f-5381-a1e3-04c3b5b4ec05', '0f389ea8-0fc1-530d-83d8-9224dc2c4075', 'ما الفائدة الكبرى من كلّ عادات النظافة؟', '[{"id":"a","text":"أن نمرض"},{"id":"b","text":"لا فائدة"},{"id":"c","text":"أن نتعب"},{"id":"d","text":"أن نبقى أصحّاء ونحمي أنفسنا من الأمراض"}]'::jsonb, 'd', 'الفائدة الكبرى من عادات النظافة أن نبقى أصحّاء ونحمي أنفسنا من الأمراض.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2e01366e-2aec-543d-8000-ff4671663019', '7fa9f8f7-6f12-5605-acc4-e6896634f1f0', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d09b3cfb-772f-5ada-a7d5-b2df71f58f97', '2e01366e-2aec-543d-8000-ff4671663019', 'أيّ حيوانٍ من الحيوانات الأليفة التي تعيش في البيت؟', '[{"id":"a","text":"القطّة"},{"id":"b","text":"الأسد"},{"id":"c","text":"الذئب"},{"id":"d","text":"الفيل"}]'::jsonb, 'a', 'القطّة حيوانٌ أليفٌ يعيش في البيت قرب الإنسان.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('198750ac-138a-5434-b2c4-32f382ed126f', '2e01366e-2aec-543d-8000-ff4671663019', 'أين يعيش الأسد؟', '[{"id":"a","text":"في البيت"},{"id":"b","text":"في الغابة"},{"id":"c","text":"في القفص دائمًا"},{"id":"d","text":"في الماء"}]'::jsonb, 'b', 'الأسد حيوانٌ برّيٌّ يعيش في الغابة بعيدًا عن الإنسان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd528d10-2134-5a73-b86c-c87e7ab8ca76', '2e01366e-2aec-543d-8000-ff4671663019', 'ماذا تأكل البقرة؟', '[{"id":"a","text":"اللحم"},{"id":"b","text":"الحديد"},{"id":"c","text":"العشب والنباتات"},{"id":"d","text":"الحجارة"}]'::jsonb, 'c', 'البقرة تأكل العشب والنباتات.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('183a7832-7a80-5f92-9e36-ebe6f009900e', '2e01366e-2aec-543d-8000-ff4671663019', 'أين تعيش السمكة؟', '[{"id":"a","text":"في الشجرة"},{"id":"b","text":"في الجحر"},{"id":"c","text":"في الهواء"},{"id":"d","text":"في الماء"}]'::jsonb, 'd', 'السمكة تعيش في الماء، وجسمها مهيّأٌ للسباحة فيه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd0f7394-7678-53b8-979b-ddf0e61a1fdb', '2e01366e-2aec-543d-8000-ff4671663019', 'أيّ حيوانٍ يأكل اللحم؟', '[{"id":"a","text":"الأسد"},{"id":"b","text":"الخروف"},{"id":"c","text":"الأرنب"},{"id":"d","text":"البقرة"}]'::jsonb, 'a', 'الأسد حيوانٌ يأكل اللحم، أمّا الخروف والأرنب والبقرة فتأكل العشب.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f52eefed-8393-51f2-91ef-426a2044d6ee', '7fa9f8f7-6f12-5605-acc4-e6896634f1f0', 'eveil-scientifique-1ere', '⭐ تمرين: أتعرّفُ على الحيوانات', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d591fd1c-5af6-5f46-8c95-7de0719af52e', 'f52eefed-8393-51f2-91ef-426a2044d6ee', 'أيّ حيوانٍ يعيش في المزرعة؟', '[{"id":"a","text":"الدجاجة"},{"id":"b","text":"الأسد"},{"id":"c","text":"الذئب"},{"id":"d","text":"الفيل"}]'::jsonb, 'a', 'الدجاجة حيوانٌ أليفٌ يعيش في المزرعة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b25564e2-96d5-5621-90b1-387cd9f2ad4e', 'f52eefed-8393-51f2-91ef-426a2044d6ee', 'ماذا يأكل الأرنب؟', '[{"id":"a","text":"اللحم"},{"id":"b","text":"الجزر والعشب"},{"id":"c","text":"الحجارة"},{"id":"d","text":"الحديد"}]'::jsonb, 'b', 'الأرنب يأكل العشب والنباتات مثل الجزر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a2eae94e-e3e6-550e-94da-53cbe4eb8b4b', 'f52eefed-8393-51f2-91ef-426a2044d6ee', 'أين يبني العصفور بيته؟', '[{"id":"a","text":"في الماء"},{"id":"b","text":"تحت الأرض"},{"id":"c","text":"عشٌّ في الشجرة"},{"id":"d","text":"في الصحراء"}]'::jsonb, 'c', 'العصفور يبني عشًّا في الشجرة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02781598-e0e1-520e-bf10-3037177db59b', 'f52eefed-8393-51f2-91ef-426a2044d6ee', 'أيّ حيوانٍ أليفٍ يحرس البيت؟', '[{"id":"a","text":"الذئب"},{"id":"b","text":"الأسد"},{"id":"c","text":"الغزال"},{"id":"d","text":"الكلب"}]'::jsonb, 'd', 'الكلب حيوانٌ أليفٌ يحرس البيت ويعيش قرب الإنسان.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5577e2cd-67bf-5a69-a672-2031e82d5b6d', 'f52eefed-8393-51f2-91ef-426a2044d6ee', 'أين تعيش الحيوانات البرّية؟', '[{"id":"a","text":"في الغابة أو الصحراء بعيدًا عن الإنسان"},{"id":"b","text":"في البيت"},{"id":"c","text":"في المدرسة"},{"id":"d","text":"في السيّارة"}]'::jsonb, 'a', 'الحيوانات البرّية تعيش في الغابة أو الصحراء بعيدًا عن الإنسان.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f72009b-d1c7-5aac-be38-21652c210dbf', 'f52eefed-8393-51f2-91ef-426a2044d6ee', 'ماذا يعطينا الخروف؟', '[{"id":"a","text":"البيض"},{"id":"b","text":"الصوف"},{"id":"c","text":"العسل"},{"id":"d","text":"الحليب فقط بلا فائدة أخرى"}]'::jsonb, 'b', 'الخروف حيوانٌ أليفٌ يعطينا الصوف الذي نصنع منه الملابس.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0d3d4bc8-cf0d-545f-9f7f-c556b4608c46', '7fa9f8f7-6f12-5605-acc4-e6896634f1f0', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الحيوانات', 3, 120, 30, 'boss', 'admin', 2)
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
  ('5849471a-6001-5564-875c-0c64348f885e', '0d3d4bc8-cf0d-545f-9f7f-c556b4608c46', 'رأى أحمد بقرةً تأكل العشب في الحقل. ما نوع غذائها؟', '[{"id":"a","text":"تأكل النباتات والعشب"},{"id":"b","text":"تأكل اللحم"},{"id":"c","text":"تأكل الحديد"},{"id":"d","text":"لا تأكل شيئًا"}]'::jsonb, 'a', 'البقرة تأكل العشب والنباتات.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83c59f29-cc44-579d-96a3-fa1242329f7f', '0d3d4bc8-cf0d-545f-9f7f-c556b4608c46', 'أيّ هذه الحيوانات يعيش في الماء؟', '[{"id":"a","text":"الأسد"},{"id":"b","text":"السمكة"},{"id":"c","text":"الجمل"},{"id":"d","text":"القطّة"}]'::jsonb, 'b', 'السمكة تعيش في الماء، أمّا الأسد والجمل والقطّة فتعيش على اليابسة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80ec6acf-2c36-532a-8050-cc3028e6a59c', '0d3d4bc8-cf0d-545f-9f7f-c556b4608c46', 'لماذا نقول إنّ الكلب حيوانٌ أليف؟', '[{"id":"a","text":"لأنّه يعيش في الغابة"},{"id":"b","text":"لأنّه يبحث عن طعامه وحده دائمًا"},{"id":"c","text":"لأنّه يعيش قرب الإنسان ويعتني به الإنسان"},{"id":"d","text":"لأنّه خطر"}]'::jsonb, 'c', 'الكلب حيوانٌ أليفٌ لأنّه يعيش قرب الإنسان ويعتني به الإنسان ويطعمه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('681295b3-d684-5034-b594-897bbb37b34a', '0d3d4bc8-cf0d-545f-9f7f-c556b4608c46', 'حيوانٌ يعيش في الغابة ويأكل اللحم. أيّ هذه يناسبه؟', '[{"id":"a","text":"الخروف"},{"id":"b","text":"البقرة"},{"id":"c","text":"الأرنب"},{"id":"d","text":"الذئب"}]'::jsonb, 'd', 'الذئب حيوانٌ برّيٌّ يعيش في الغابة ويأكل اللحم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c0987ef5-aa72-5659-a838-3624b333c8c1', '0d3d4bc8-cf0d-545f-9f7f-c556b4608c46', 'لماذا تختلف مساكن الحيوانات؟', '[{"id":"a","text":"لأنّ لكلّ حيوانٍ مكانًا يناسب جسمه وحياته"},{"id":"b","text":"لأنّها كلّها تعيش في الماء"},{"id":"c","text":"لأنّها لا تحتاج إلى مسكن"},{"id":"d","text":"لأنّها كلّها تعيش في الشجرة"}]'::jsonb, 'a', 'تختلف المساكن لأنّ لكلّ حيوانٍ مكانًا يناسب جسمه وحياته: السمكة في الماء والعصفور في الشجرة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7377066b-22a8-504e-95df-cb33dcdddd85', '0d3d4bc8-cf0d-545f-9f7f-c556b4608c46', 'أيّ مجموعةٍ كلّها حيوانات تأكل العشب؟', '[{"id":"a","text":"الأسد والذئب والقطّة"},{"id":"b","text":"البقرة والخروف والأرنب"},{"id":"c","text":"الأسد والبقرة"},{"id":"d","text":"الذئب والأرنب"}]'::jsonb, 'b', 'البقرة والخروف والأرنب كلّها حيوانات تأكل العشب والنباتات.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('69d02e89-ef4d-5ba8-9db5-9db19d0c57ae', '7fa9f8f7-6f12-5605-acc4-e6896634f1f0', 'eveil-scientifique-1ere', '🛡️ مراجعة ⭐⭐: أُصنّفُ الحيوانات', 2, 70, 15, 'practice', 'admin', 3)
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
  ('0c69c7bf-28e9-5bf5-b890-530f73846ed9', '69d02e89-ef4d-5ba8-9db5-9db19d0c57ae', 'أيّ حيوانٍ أليف؟', '[{"id":"a","text":"البقرة"},{"id":"b","text":"الأسد"},{"id":"c","text":"الذئب"},{"id":"d","text":"الغزال"}]'::jsonb, 'a', 'البقرة حيوانٌ أليفٌ يعيش في المزرعة قرب الإنسان.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a79bd36c-57a1-5f1b-8421-904efa3d3ad4', '69d02e89-ef4d-5ba8-9db5-9db19d0c57ae', 'أيّ حيوانٍ برّيّ؟', '[{"id":"a","text":"الدجاجة"},{"id":"b","text":"الغزال"},{"id":"c","text":"الكلب"},{"id":"d","text":"القطّة"}]'::jsonb, 'b', 'الغزال حيوانٌ برّيٌّ يعيش في الطبيعة بعيدًا عن الإنسان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9bac5f2-5cb5-52d4-824c-a4b327f1baf8', '69d02e89-ef4d-5ba8-9db5-9db19d0c57ae', 'أين يعيش الأرنب؟', '[{"id":"a","text":"في الماء"},{"id":"b","text":"في الهواء"},{"id":"c","text":"في جحرٍ تحت الأرض"},{"id":"d","text":"في عشٍّ بالشجرة"}]'::jsonb, 'c', 'الأرنب يحفر جحرًا في الأرض ويعيش فيه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62b4b7da-6f76-5188-8733-602b5ddae12e', '69d02e89-ef4d-5ba8-9db5-9db19d0c57ae', 'أيّ جملةٍ صحيحة؟', '[{"id":"a","text":"الأسد يأكل العشب"},{"id":"b","text":"السمكة تعيش في الشجرة"},{"id":"c","text":"البقرة تأكل اللحم"},{"id":"d","text":"العصفور يطير ويبني عشًّا في الشجرة"}]'::jsonb, 'd', 'العصفور يطير ويبني عشًّا في الشجرة، أمّا الأسد فيأكل اللحم والسمكة تعيش في الماء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed25ec8b-837f-5bdd-be9e-c4309945b137', '69d02e89-ef4d-5ba8-9db5-9db19d0c57ae', 'ماذا تعطينا الدجاجة؟', '[{"id":"a","text":"البيض"},{"id":"b","text":"الصوف"},{"id":"c","text":"العسل"},{"id":"d","text":"الحرير"}]'::jsonb, 'a', 'الدجاجة حيوانٌ أليفٌ يعطينا البيض.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d10d4907-e600-5a19-a7e7-3934c728915a', '69d02e89-ef4d-5ba8-9db5-9db19d0c57ae', 'ماذا يأكل الذئب؟', '[{"id":"a","text":"العشب"},{"id":"b","text":"الجزر"},{"id":"c","text":"النباتات"},{"id":"d","text":"اللحم"}]'::jsonb, 'd', 'الذئب حيوانٌ برّيٌّ يأكل اللحم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('865ef2ce-3a57-5486-8224-a3df98c18977', '7fa9f8f7-6f12-5605-acc4-e6896634f1f0', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: خبير عالم الحيوان', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('7119c9e7-2a5d-514e-9630-f2703345baaf', '865ef2ce-3a57-5486-8224-a3df98c18977', 'حيوانٌ أليفٌ يعطينا الحليب ويأكل العشب. ما هو؟', '[{"id":"a","text":"الذئب"},{"id":"b","text":"الأسد"},{"id":"c","text":"البقرة"},{"id":"d","text":"العصفور"}]'::jsonb, 'c', 'البقرة حيوانٌ أليفٌ يأكل العشب ويعطينا الحليب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed8ee754-8f26-5fac-8ace-aa63e0a70e93', '865ef2ce-3a57-5486-8224-a3df98c18977', 'حيوانٌ يعيش قرب الإنسان، يأكل اللحم، ويصطاد الفئران. ما هو؟', '[{"id":"a","text":"القطّة"},{"id":"b","text":"البقرة"},{"id":"c","text":"الخروف"},{"id":"d","text":"الأرنب"}]'::jsonb, 'a', 'القطّة حيوانٌ أليفٌ يأكل اللحم ويصطاد الفئران.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74535e02-4f3a-568b-85f0-54aca140c4e3', '865ef2ce-3a57-5486-8224-a3df98c18977', 'لماذا تستطيع السمكة العيش في الماء بينما لا يستطيع الأسد؟', '[{"id":"a","text":"لأنّ جسم السمكة مهيّأٌ للعيش في الماء بينما الأسد يعيش على اليابسة"},{"id":"b","text":"لأنّ الأسد يحبّ الماء"},{"id":"c","text":"لأنّ السمكة لا تحتاج إلى الماء"},{"id":"d","text":"لا فرق بينهما"}]'::jsonb, 'a', 'جسم السمكة مهيّأٌ للعيش في الماء، أمّا الأسد فجسمه مهيّأٌ للعيش على اليابسة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e1c2825-23a4-53bb-a6f5-99f2d4f79c40', '865ef2ce-3a57-5486-8224-a3df98c18977', 'صنّفي: أيّ مجموعةٍ كلّها حيوانات برّية؟', '[{"id":"a","text":"القطّة والكلب والدجاجة"},{"id":"b","text":"الأسد والذئب والغزال"},{"id":"c","text":"البقرة والخروف والحصان"},{"id":"d","text":"الدجاجة والعصفور البيتيّ"}]'::jsonb, 'b', 'الأسد والذئب والغزال كلّها حيوانات برّية تعيش بعيدًا عن الإنسان.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('618e0586-ab6e-57c9-9537-550baba3011e', '865ef2ce-3a57-5486-8224-a3df98c18977', 'لماذا تحتاج الحيوانات كلّها إلى الطعام؟', '[{"id":"a","text":"لأنّها تريد اللعب"},{"id":"b","text":"لأنّ الطعام يعطيها الطاقة لتعيش وتنمو"},{"id":"c","text":"لأنّها لا تحتاج إلى الطعام"},{"id":"d","text":"لتنام فقط"}]'::jsonb, 'b', 'كلّ الحيوانات تحتاج إلى الطعام لأنّه يعطيها الطاقة لتعيش وتنمو.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf10a527-4030-53ec-a8b2-980d9a62374d', '865ef2ce-3a57-5486-8224-a3df98c18977', 'أيّ حيوانٍ يناسب الوصف: يطير، له ريش، ويبني عشًّا في الشجرة؟', '[{"id":"a","text":"السمكة"},{"id":"b","text":"الأرنب"},{"id":"c","text":"العصفور"},{"id":"d","text":"الحصان"}]'::jsonb, 'c', 'العصفور يطير وله ريش ويبني عشًّا في الشجرة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('353e12aa-c01b-54e5-97ef-89460f69e503', '7fa9f8f7-6f12-5605-acc4-e6896634f1f0', 'eveil-scientifique-1ere', '⚔️ تدريب الأبطال ⭐⭐⭐: أُتقنُ عالم الحيوان', 3, 120, 30, 'boss', 'admin', 5)
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
  ('e3ffb107-2969-5a12-a895-bb132bac09fd', '353e12aa-c01b-54e5-97ef-89460f69e503', 'أيّ حيوانٍ يعيش في البيت ويموء؟', '[{"id":"a","text":"القطّة"},{"id":"b","text":"الأسد"},{"id":"c","text":"البقرة"},{"id":"d","text":"الفيل"}]'::jsonb, 'a', 'القطّة حيوانٌ أليفٌ يعيش في البيت ويصدر صوت المواء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5b48c2a-f7f2-5004-aad4-d45b6cd236a9', '353e12aa-c01b-54e5-97ef-89460f69e503', 'أين يعيش الجمل؟', '[{"id":"a","text":"في الماء"},{"id":"b","text":"في الصحراء"},{"id":"c","text":"في الشجرة"},{"id":"d","text":"تحت الأرض"}]'::jsonb, 'b', 'الجمل يعيش في الصحراء ويتحمّل العطش والحرارة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ef1e289-926c-5f95-a3ee-1c676738c106', '353e12aa-c01b-54e5-97ef-89460f69e503', 'أيّ حيوانٍ يأكل العشب؟', '[{"id":"a","text":"الأسد"},{"id":"b","text":"الذئب"},{"id":"c","text":"الخروف"},{"id":"d","text":"القطّة"}]'::jsonb, 'c', 'الخروف حيوانٌ يأكل العشب والنباتات.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2878cff-e378-50eb-a801-cf846ab5224f', '353e12aa-c01b-54e5-97ef-89460f69e503', 'لماذا يعتني الإنسان بالحيوانات الأليفة؟', '[{"id":"a","text":"لأنّها تعيش معه وتنفعه، فيطعمها ويحميها"},{"id":"b","text":"لأنّها خطرة"},{"id":"c","text":"لأنّها تعيش في الغابة"},{"id":"d","text":"لا سبب"}]'::jsonb, 'a', 'يعتني الإنسان بالحيوانات الأليفة لأنّها تعيش معه وتنفعه، فيطعمها ويحميها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1e93022-4f4a-5084-b24b-9ea306f7a53e', '353e12aa-c01b-54e5-97ef-89460f69e503', 'حيوانٌ برّيٌّ ضخمٌ له خرطومٌ طويل. ما هو؟', '[{"id":"a","text":"الأرنب"},{"id":"b","text":"العصفور"},{"id":"c","text":"السمكة"},{"id":"d","text":"الفيل"}]'::jsonb, 'd', 'الفيل حيوانٌ برّيٌّ ضخمٌ له خرطومٌ طويل.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ed22679-0091-54b2-a0c3-455084fedd21', '353e12aa-c01b-54e5-97ef-89460f69e503', 'ما القاعدة الصحيحة عن الحيوانات؟', '[{"id":"a","text":"كلّ الحيوانات تعيش في الماء"},{"id":"b","text":"لكلّ حيوانٍ مسكنه وغذاؤه المناسب له"},{"id":"c","text":"كلّ الحيوانات تأكل اللحم"},{"id":"d","text":"كلّ الحيوانات أليفة"}]'::jsonb, 'b', 'القاعدة الصحيحة: لكلّ حيوانٍ مسكنه الخاصّ وغذاؤه المناسب له.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('935ff8fe-11dd-5ed5-96a2-740c537562b4', '627d3257-2d35-52be-ab2e-7e9ddc4e96f0', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('ac766d9c-aed0-5540-b6db-68ed79f9709c', '935ff8fe-11dd-5ed5-96a2-740c537562b4', 'أيّ جزءٍ من النبتة يوجد تحت الأرض ويمتصّ الماء؟', '[{"id":"a","text":"الجذر"},{"id":"b","text":"الزهرة"},{"id":"c","text":"الأوراق"},{"id":"d","text":"الساق"}]'::jsonb, 'a', 'الجذر يوجد تحت الأرض، يثبّت النبتة ويمتصّ الماء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d8a4e03-722a-5c89-84d6-fbdaf4ce2f11', '935ff8fe-11dd-5ed5-96a2-740c537562b4', 'ماذا تحتاج النبتة لتنمو؟', '[{"id":"a","text":"الظلام فقط"},{"id":"b","text":"الماء والضوء"},{"id":"c","text":"اللحم"},{"id":"d","text":"لا شيء"}]'::jsonb, 'b', 'النبتة تحتاج إلى الماء والضوء لتنمو وتعيش.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc2313b2-e83f-5ac9-b1da-eb0e7d673236', '935ff8fe-11dd-5ed5-96a2-740c537562b4', 'أيّ جزءٍ من النبتة جميلٌ وملوّنٌ ومنه يتكوّن الثمر؟', '[{"id":"a","text":"الجذر"},{"id":"b","text":"الساق"},{"id":"c","text":"الزهرة"},{"id":"d","text":"التربة"}]'::jsonb, 'c', 'الزهرة هي الجزء الجميل الملوّن، ومنها يتكوّن الثمر والبذور.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8700c4cd-c481-52b9-a4d5-6a0aa3402c23', '935ff8fe-11dd-5ed5-96a2-740c537562b4', 'ماذا يحدث للنبتة إذا لم نسقها بالماء أبدًا؟', '[{"id":"a","text":"تكبر بسرعة"},{"id":"b","text":"تصبح أقوى"},{"id":"c","text":"لا يتغيّر شيء"},{"id":"d","text":"تذبل وتموت"}]'::jsonb, 'd', 'بدون ماءٍ تذبل النبتة وتموت، لأنّها كائنٌ حيٌّ يحتاج إلى الماء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2148c54-c3e5-5640-bb4d-a2c217bc5b20', '935ff8fe-11dd-5ed5-96a2-740c537562b4', 'ما دور الأوراق الخضراء؟', '[{"id":"a","text":"تصنع غذاء النبتة بمساعدة الضوء"},{"id":"b","text":"تمتصّ الماء من تحت الأرض"},{"id":"c","text":"تثبّت النبتة"},{"id":"d","text":"لا دور لها"}]'::jsonb, 'a', 'الأوراق الخضراء تصنع غذاء النبتة بمساعدة ضوء الشمس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8d2533ba-5d5f-5bef-9f0a-1de9b9374963', '627d3257-2d35-52be-ab2e-7e9ddc4e96f0', 'eveil-scientifique-1ere', '⭐ تمرين: أكتشفُ النبتة', 1, 50, 10, 'practice', 'admin', 1)
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
  ('13e6c945-ba5d-5634-9703-9b6d3bcf1d83', '8d2533ba-5d5f-5bef-9f0a-1de9b9374963', 'بماذا نسقي النبتة؟', '[{"id":"a","text":"بالماء"},{"id":"b","text":"بالزيت"},{"id":"c","text":"بالعصير"},{"id":"d","text":"بالرمل"}]'::jsonb, 'a', 'نسقي النبتة بالماء لتنمو وتعيش.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5da38a90-8d09-5e9a-b5f7-d595cafd9a99', '8d2533ba-5d5f-5bef-9f0a-1de9b9374963', 'أيّ جزءٍ من النبتة يحملها ويرفعها إلى الأعلى؟', '[{"id":"a","text":"الزهرة"},{"id":"b","text":"الساق"},{"id":"c","text":"الجذر"},{"id":"d","text":"الثمرة"}]'::jsonb, 'b', 'الساق يحمل النبتة ويرفعها إلى الأعلى.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0337352b-24be-54ab-ba6e-b5249e86a336', '8d2533ba-5d5f-5bef-9f0a-1de9b9374963', 'ما لون أوراق النبتة عادةً؟', '[{"id":"a","text":"الأزرق"},{"id":"b","text":"الأسود"},{"id":"c","text":"الأخضر"},{"id":"d","text":"الأبيض"}]'::jsonb, 'c', 'أوراق النبتة عادةً خضراء، وهي تصنع غذاء النبتة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1510fd45-2fe1-554d-8e05-ff9587769441', '8d2533ba-5d5f-5bef-9f0a-1de9b9374963', 'ما الذي يساعد النبتة على النموّ مع الماء؟', '[{"id":"a","text":"الظلام"},{"id":"b","text":"البرد الشديد"},{"id":"c","text":"الدخان"},{"id":"d","text":"ضوء الشمس"}]'::jsonb, 'd', 'ضوء الشمس يساعد النبتة على النموّ مع الماء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42898e32-6de3-5671-b908-fccc40e90c15', '8d2533ba-5d5f-5bef-9f0a-1de9b9374963', 'أيّ هذه نبتة؟', '[{"id":"a","text":"الوردة"},{"id":"b","text":"القطّة"},{"id":"c","text":"الحجر"},{"id":"d","text":"السيّارة"}]'::jsonb, 'a', 'الوردة نبتةٌ جميلة، أمّا القطّة فحيوان والحجر جماد.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('888ff244-04a5-58df-9022-1a15484560be', '8d2533ba-5d5f-5bef-9f0a-1de9b9374963', 'أين يوجد جذر النبتة؟', '[{"id":"a","text":"في السماء"},{"id":"b","text":"تحت الأرض"},{"id":"c","text":"في أعلى الساق"},{"id":"d","text":"في الزهرة"}]'::jsonb, 'b', 'جذر النبتة يوجد تحت الأرض، يثبّتها ويمتصّ الماء.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4e927f1e-6860-5847-85d3-e9e055a56ad9', '627d3257-2d35-52be-ab2e-7e9ddc4e96f0', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد النباتات', 3, 120, 30, 'boss', 'admin', 2)
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
  ('da542df7-7585-5415-81dd-f8132fb8f6f3', '4e927f1e-6860-5847-85d3-e9e055a56ad9', 'وضعت ليلى نبتةً في غرفةٍ مظلمةٍ ولم تسقها. ماذا يحدث لها؟', '[{"id":"a","text":"تذبل وتموت"},{"id":"b","text":"تكبر بسرعة"},{"id":"c","text":"تتلوّن بالأحمر"},{"id":"d","text":"تطير"}]'::jsonb, 'a', 'بدون ماءٍ وضوءٍ تذبل النبتة وتموت، لأنّها تحتاج إليهما لتعيش.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1eba63fa-405a-5afa-948e-cbffb70ffa30', '4e927f1e-6860-5847-85d3-e9e055a56ad9', 'أيّ جزءٍ من النبتة يمتصّ الماء من التربة؟', '[{"id":"a","text":"الزهرة"},{"id":"b","text":"الجذر"},{"id":"c","text":"الأوراق"},{"id":"d","text":"الثمرة"}]'::jsonb, 'b', 'الجذر هو الذي يمتصّ الماء من التربة ويثبّت النبتة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a70815b-b06b-5762-9deb-772388d413ab', '4e927f1e-6860-5847-85d3-e9e055a56ad9', 'لماذا نقول إنّ النبتة كائنٌ حيّ؟', '[{"id":"a","text":"لأنّها لا تتغيّر أبدًا"},{"id":"b","text":"لأنّها مصنوعة من حجر"},{"id":"c","text":"لأنّها تنمو وتحتاج إلى الماء والضوء"},{"id":"d","text":"لأنّها تتكلّم"}]'::jsonb, 'c', 'النبتة كائنٌ حيٌّ لأنّها تنمو وتحتاج إلى الماء والضوء لتعيش.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8e65d1cc-5ae7-548d-91eb-c561f1dfe8e5', '4e927f1e-6860-5847-85d3-e9e055a56ad9', 'أيّ ترتيبٍ صحيحٌ لأجزاء النبتة من الأسفل إلى الأعلى؟', '[{"id":"a","text":"الزهرة ثمّ الجذر ثمّ الساق"},{"id":"b","text":"الجذر ثمّ الساق ثمّ الزهرة"},{"id":"c","text":"الأوراق ثمّ الجذر"},{"id":"d","text":"الزهرة ثمّ الساق ثمّ الجذر"}]'::jsonb, 'b', 'من الأسفل إلى الأعلى: الجذر تحت الأرض، ثمّ الساق، ثمّ الزهرة في الأعلى.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e94718ea-855f-5115-a685-75aa9959e08e', '4e927f1e-6860-5847-85d3-e9e055a56ad9', 'تلميذٌ يسقي نبتته كلّ يومٍ ويضعها قرب النافذة. لماذا هذا صحيح؟', '[{"id":"a","text":"لأنّه يعطيها الماء والضوء اللذين تحتاجهما"},{"id":"b","text":"لأنّ النبتة لا تحتاج إلى شيء"},{"id":"c","text":"لأنّ الضوء يضرّ النبتة"},{"id":"d","text":"لا سبب"}]'::jsonb, 'a', 'سقيها كلّ يومٍ ووضعها قرب النافذة يعطيها الماء والضوء اللذين تحتاجهما لتنمو.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3cbe56eb-5650-5338-acb8-c3bc31fe29ab', '4e927f1e-6860-5847-85d3-e9e055a56ad9', 'ما الذي يصنع غذاء النبتة بمساعدة الضوء؟', '[{"id":"a","text":"الجذر"},{"id":"b","text":"الساق"},{"id":"c","text":"التربة"},{"id":"d","text":"الأوراق الخضراء"}]'::jsonb, 'd', 'الأوراق الخضراء تصنع غذاء النبتة بمساعدة ضوء الشمس.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('668cf57a-4d55-58b1-a36c-8813ba28ef7c', '627d3257-2d35-52be-ab2e-7e9ddc4e96f0', 'eveil-scientifique-1ere', '🛡️ مراجعة ⭐⭐: أجزاء النبتة', 2, 70, 15, 'practice', 'admin', 3)
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
  ('5e042e51-90d4-5b4f-9726-880576df4974', '668cf57a-4d55-58b1-a36c-8813ba28ef7c', 'أيّ مجموعةٍ كلّها أجزاءٌ من النبتة؟', '[{"id":"a","text":"الجذر والساق والأوراق والزهرة"},{"id":"b","text":"اليد والرّجل"},{"id":"c","text":"العين والأذن"},{"id":"d","text":"القطّة والكلب"}]'::jsonb, 'a', 'أجزاء النبتة هي الجذر والساق والأوراق والزهرة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4f0e588-601f-5108-9674-5d48d796ad4a', '668cf57a-4d55-58b1-a36c-8813ba28ef7c', 'ماذا تعطينا شجرة الزيتون؟', '[{"id":"a","text":"اللحم"},{"id":"b","text":"الزيتون والزيت"},{"id":"c","text":"الحليب"},{"id":"d","text":"البيض"}]'::jsonb, 'b', 'شجرة الزيتون تعطينا الزيتون الذي نصنع منه الزيت.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd0de3d5-b629-588e-8d67-74908552ea7c', '668cf57a-4d55-58b1-a36c-8813ba28ef7c', 'ماذا يحدث للنبتة إذا حصلت على الماء والضوء؟', '[{"id":"a","text":"تذبل"},{"id":"b","text":"تموت"},{"id":"c","text":"تنمو وتعيش"},{"id":"d","text":"تختفي"}]'::jsonb, 'c', 'إذا حصلت النبتة على الماء والضوء فإنّها تنمو وتعيش جيّدًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0485b49a-8871-59bf-8597-c7ba23730b33', '668cf57a-4d55-58b1-a36c-8813ba28ef7c', 'أيّ جملةٍ صحيحة؟', '[{"id":"a","text":"الجذر فوق الأرض"},{"id":"b","text":"النبتة لا تحتاج إلى الماء"},{"id":"c","text":"الأوراق سوداء"},{"id":"d","text":"الزهرة جزءٌ ملوّنٌ من النبتة"}]'::jsonb, 'd', 'الزهرة جزءٌ ملوّنٌ جميلٌ من النبتة، والجذر تحت الأرض، والأوراق خضراء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b666456e-d665-5d27-a7c8-aa5c8befbd78', '668cf57a-4d55-58b1-a36c-8813ba28ef7c', 'أيّ هذه نبتةٌ من حولنا؟', '[{"id":"a","text":"شجرة النخيل"},{"id":"b","text":"السيّارة"},{"id":"c","text":"الهاتف"},{"id":"d","text":"الكرسيّ"}]'::jsonb, 'a', 'شجرة النخيل نبتةٌ من حولنا تعطينا التمر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c83e550c-2e9f-51fe-b503-4b38ed3e7e4c', '668cf57a-4d55-58b1-a36c-8813ba28ef7c', 'ما دور الجذر؟', '[{"id":"a","text":"يطير بالنبتة"},{"id":"b","text":"يثبّت النبتة ويمتصّ الماء"},{"id":"c","text":"يلوّن الزهرة"},{"id":"d","text":"لا دور له"}]'::jsonb, 'b', 'الجذر يثبّت النبتة في الأرض ويمتصّ الماء من التربة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b4c403fa-2916-5353-9416-a4857b78f2da', '627d3257-2d35-52be-ab2e-7e9ddc4e96f0', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: خبير عالم النبات', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('76fb6359-9af6-5c27-ad31-9fa88852219f', 'b4c403fa-2916-5353-9416-a4857b78f2da', 'نبتتان متشابهتان: واحدة قرب النافذة وتُسقى، وأخرى في الظلام دون ماء. أيّهما تنمو؟', '[{"id":"a","text":"النبتة التي قرب النافذة وتُسقى"},{"id":"b","text":"النبتة التي في الظلام"},{"id":"c","text":"كلتاهما تموتان"},{"id":"d","text":"كلتاهما تنموان بالقدر نفسه"}]'::jsonb, 'a', 'النبتة التي تحصل على الماء والضوء قرب النافذة تنمو، أمّا التي في الظلام دون ماءٍ فتذبل.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18ff2c58-d8ab-5106-8449-f0735c956afe', 'b4c403fa-2916-5353-9416-a4857b78f2da', 'لماذا يحتاج الجذر أن يكون تحت الأرض؟', '[{"id":"a","text":"ليرى الشمس"},{"id":"b","text":"ليثبّت النبتة ويمتصّ الماء من التربة"},{"id":"c","text":"ليطير"},{"id":"d","text":"ليتلوّن"}]'::jsonb, 'b', 'الجذر تحت الأرض ليثبّت النبتة في مكانها ويمتصّ الماء من التربة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40588d0d-142d-5b9f-98a5-7e224f2b8dd0', 'b4c403fa-2916-5353-9416-a4857b78f2da', 'صنّفي: أيّ مجموعةٍ كلّها نباتات؟', '[{"id":"a","text":"الحجر والسيّارة"},{"id":"b","text":"القطّة والكلب"},{"id":"c","text":"الوردة والشجرة والعشب"},{"id":"d","text":"الأسد والذئب"}]'::jsonb, 'c', 'الوردة والشجرة والعشب كلّها نباتات، أمّا القطّة والكلب فحيوانات.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6e583035-5d62-5118-a1c3-3a504dda821b', 'b4c403fa-2916-5353-9416-a4857b78f2da', 'لماذا تُعدّ الأشجار مفيدةً لنا؟', '[{"id":"a","text":"لأنّها تعطي الظلّ والثمار وتنقّي الهواء"},{"id":"b","text":"لأنّها تلوّث الهواء"},{"id":"c","text":"لأنّها لا فائدة منها"},{"id":"d","text":"لأنّها تأكل اللحم"}]'::jsonb, 'a', 'الأشجار مفيدةٌ لأنّها تعطينا الظلّ والثمار وتنقّي الهواء الذي نتنفّسه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cab1be57-3c93-5978-a0c9-b47872243d07', 'b4c403fa-2916-5353-9416-a4857b78f2da', 'بذرةٌ صغيرة وُضعت في تربةٍ جيّدة وسُقيت بالماء ووصلها الضوء. ماذا يحدث؟', '[{"id":"a","text":"تبقى بذرةً ولا تتغيّر"},{"id":"b","text":"تنبت وتصير نبتةً صغيرة"},{"id":"c","text":"تتحوّل إلى حيوان"},{"id":"d","text":"تختفي"}]'::jsonb, 'b', 'البذرة في تربةٍ جيّدةٍ مع الماء والضوء تنبت وتصير نبتةً صغيرةً تنمو شيئًا فشيئًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('162740ce-069d-5e75-92f7-cf88e786dece', 'b4c403fa-2916-5353-9416-a4857b78f2da', 'ما القاعدة الصحيحة عن النباتات؟', '[{"id":"a","text":"النباتات لا تنمو ولا تحتاج شيئًا"},{"id":"b","text":"النباتات تعيش دون تربة دائمًا"},{"id":"c","text":"النباتات تأكل اللحم"},{"id":"d","text":"النباتات كائنات حيّة تحتاج إلى الماء والضوء لتنمو"}]'::jsonb, 'd', 'القاعدة الصحيحة: النباتات كائنات حيّة تنمو وتحتاج إلى الماء والضوء لتعيش.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9b588f1e-ce58-5955-bb3f-39bf23e2ec87', '627d3257-2d35-52be-ab2e-7e9ddc4e96f0', 'eveil-scientifique-1ere', '⚔️ تدريب الأبطال ⭐⭐⭐: أُتقنُ عالم النبات', 3, 120, 30, 'boss', 'admin', 5)
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
  ('42f3249c-9a3e-55f0-9aa8-cf9e5f653a9d', '9b588f1e-ce58-5955-bb3f-39bf23e2ec87', 'ماذا تحتاج النبتة لتعيش، إضافةً إلى الماء؟', '[{"id":"a","text":"الضوء"},{"id":"b","text":"الظلام"},{"id":"c","text":"اللحم"},{"id":"d","text":"الدخان"}]'::jsonb, 'a', 'النبتة تحتاج إلى الضوء إضافةً إلى الماء لتعيش وتنمو.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ecb2d573-532e-516d-abf4-578e87b98e6d', '9b588f1e-ce58-5955-bb3f-39bf23e2ec87', 'أيّ جزءٍ من النبتة منه يتكوّن الثمر؟', '[{"id":"a","text":"الجذر"},{"id":"b","text":"الزهرة"},{"id":"c","text":"الساق"},{"id":"d","text":"التربة"}]'::jsonb, 'b', 'من الزهرة يتكوّن الثمر والبذور.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e80a82ac-2dc7-5c71-b2ac-451b526476c4', '9b588f1e-ce58-5955-bb3f-39bf23e2ec87', 'نبتةٌ اصفرّت أوراقها وذبلت. ما السبب الأرجح؟', '[{"id":"a","text":"أنّها سُقيت كثيرًا بالضوء"},{"id":"b","text":"أنّها لم تحصل على الماء أو الضوء الكافي"},{"id":"c","text":"أنّها أكلت لحمًا"},{"id":"d","text":"أنّها نامت"}]'::jsonb, 'b', 'ذبول النبتة واصفرار أوراقها سببه نقص الماء أو الضوء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e0f7e4e8-e932-5ca7-ac30-2dace570f727', '9b588f1e-ce58-5955-bb3f-39bf23e2ec87', 'ما الفرق بين النبتة والحجر؟', '[{"id":"a","text":"النبتة كائنٌ حيٌّ تنمو، والحجر جمادٌ لا ينمو"},{"id":"b","text":"لا فرق بينهما"},{"id":"c","text":"الحجر ينمو والنبتة لا"},{"id":"d","text":"كلاهما يأكل اللحم"}]'::jsonb, 'a', 'النبتة كائنٌ حيٌّ تنمو وتحتاج إلى الماء والضوء، أمّا الحجر فجمادٌ لا ينمو.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b0602e2-61f1-54a5-8337-a00db08988d9', '9b588f1e-ce58-5955-bb3f-39bf23e2ec87', 'أيّ جزءٍ من النبتة يحمل الأوراق والزهرة؟', '[{"id":"a","text":"الجذر"},{"id":"b","text":"التربة"},{"id":"c","text":"الساق"},{"id":"d","text":"الماء"}]'::jsonb, 'c', 'الساق يحمل الأوراق والزهرة ويرفع النبتة إلى الأعلى.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b2eda1c-9037-5fc4-8f52-49599b6071b1', '9b588f1e-ce58-5955-bb3f-39bf23e2ec87', 'لماذا نهتمّ بالنباتات ونعتني بها؟', '[{"id":"a","text":"لأنّها تضرّنا"},{"id":"b","text":"لأنّها تتكلّم"},{"id":"c","text":"لا فائدة منها"},{"id":"d","text":"لأنّها تعطينا الغذاء والظلّ وتنقّي الهواء"}]'::jsonb, 'd', 'نعتني بالنباتات لأنّها تعطينا الغذاء والظلّ وتنقّي الهواء الذي نتنفّسه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e34f1127-c0f3-5eef-b3ce-ac1e149c4f71', '0964dad9-9807-5c71-973a-94061d78875b', 'eveil-scientifique-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('de005c93-30cf-5752-8ee9-359def98be98', 'e34f1127-c0f3-5eef-b3ce-ac1e149c4f71', 'ما الذي يشرق في النهار وينير الدنيا؟', '[{"id":"a","text":"الشمس"},{"id":"b","text":"القمر"},{"id":"c","text":"النجوم"},{"id":"d","text":"المصباح فقط"}]'::jsonb, 'a', 'في النهار تشرق الشمس فتنير الدنيا وتدفّئها.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe699aad-a854-5e39-92ef-054f6085abe0', 'e34f1127-c0f3-5eef-b3ce-ac1e149c4f71', 'ما الذي نراه في السماء ليلًا؟', '[{"id":"a","text":"الشمس الساطعة"},{"id":"b","text":"القمر والنجوم"},{"id":"c","text":"قوس قزح"},{"id":"d","text":"لا شيء أبدًا"}]'::jsonb, 'b', 'في الليل تغيب الشمس ويظهر القمر والنجوم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('46dc0f3d-0082-56cc-8d4f-a1697e0a7c15', 'e34f1127-c0f3-5eef-b3ce-ac1e149c4f71', 'متى نذهب إلى المدرسة عادةً؟', '[{"id":"a","text":"في منتصف الليل"},{"id":"b","text":"أثناء النوم"},{"id":"c","text":"في النهار"},{"id":"d","text":"في الليل المظلم"}]'::jsonb, 'c', 'نذهب إلى المدرسة في النهار، فهو وقت الدراسة والعمل واللعب.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da7a0b59-ba1a-5190-a391-7ab2d7d29e79', 'e34f1127-c0f3-5eef-b3ce-ac1e149c4f71', 'كيف تكون السماء في الليل؟', '[{"id":"a","text":"مضيئة وزرقاء"},{"id":"b","text":"ساطعة بالشمس"},{"id":"c","text":"حمراء دائمًا"},{"id":"d","text":"مظلمة"}]'::jsonb, 'd', 'في الليل تكون السماء مظلمةً لأنّ الشمس قد غابت.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('64f932c6-141d-5eda-b2e2-71bfb18e2947', 'e34f1127-c0f3-5eef-b3ce-ac1e149c4f71', 'ما النشاط المناسب للّيل؟', '[{"id":"a","text":"النوم والراحة"},{"id":"b","text":"الذهاب إلى المدرسة"},{"id":"c","text":"اللعب في الملعب"},{"id":"d","text":"العمل في الحقل"}]'::jsonb, 'a', 'الليل وقت النوم والراحة لنستعيد نشاطنا للنهار التالي.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bdf093af-306b-58af-be2b-3a65eaabbd75', '0964dad9-9807-5c71-973a-94061d78875b', 'eveil-scientifique-1ere', '⭐ تمرين: النهار والليل', 1, 50, 10, 'practice', 'admin', 1)
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
  ('07481e47-c24a-5fce-a086-8055985659f0', 'bdf093af-306b-58af-be2b-3a65eaabbd75', 'متى نرى الشمس؟', '[{"id":"a","text":"في النهار"},{"id":"b","text":"في الليل"},{"id":"c","text":"أثناء النوم"},{"id":"d","text":"أبدًا"}]'::jsonb, 'a', 'نرى الشمس في النهار، فهي تنير الدنيا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a331886d-4108-50cb-9c5b-a780653a5605', 'bdf093af-306b-58af-be2b-3a65eaabbd75', 'متى نرى النجوم؟', '[{"id":"a","text":"في الصباح"},{"id":"b","text":"في الليل"},{"id":"c","text":"في الظهر"},{"id":"d","text":"أبدًا"}]'::jsonb, 'b', 'نرى النجوم في الليل عندما تكون السماء مظلمة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('572d0c48-e8b0-5ce8-842b-2f95a7b1ca8b', 'bdf093af-306b-58af-be2b-3a65eaabbd75', 'ماذا نفعل عادةً في النهار؟', '[{"id":"a","text":"ننام طوال الوقت"},{"id":"b","text":"نبقى في الظلام"},{"id":"c","text":"نلعب وندرس"},{"id":"d","text":"لا شيء"}]'::jsonb, 'c', 'في النهار نلعب وندرس ونعمل لأنّه وقت الضوء والنشاط.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5064929c-6fa7-53d5-9efe-5711095846c3', 'bdf093af-306b-58af-be2b-3a65eaabbd75', 'ماذا نفعل عادةً في الليل؟', '[{"id":"a","text":"نذهب إلى المدرسة"},{"id":"b","text":"نلعب في الملعب"},{"id":"c","text":"نعمل في الحقل"},{"id":"d","text":"ننام ونرتاح"}]'::jsonb, 'd', 'في الليل ننام ونرتاح لنستعيد نشاطنا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5338579c-5790-5b84-8fac-0bd4cdd26e34', 'bdf093af-306b-58af-be2b-3a65eaabbd75', 'كيف تكون السماء في النهار المشمس؟', '[{"id":"a","text":"زرقاء ومضيئة"},{"id":"b","text":"مظلمة"},{"id":"c","text":"سوداء"},{"id":"d","text":"فيها نجوم"}]'::jsonb, 'a', 'في النهار المشمس تكون السماء زرقاء ومضيئة بفضل الشمس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('745ff14e-deef-549b-88fd-27d8bbb33b47', 'bdf093af-306b-58af-be2b-3a65eaabbd75', 'ما الذي يضيء السماء في الليل؟', '[{"id":"a","text":"الشمس"},{"id":"b","text":"القمر والنجوم"},{"id":"c","text":"قوس قزح"},{"id":"d","text":"لا شيء"}]'::jsonb, 'b', 'في الليل يضيء القمر والنجوم السماء بنورٍ خافت.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('87668b80-03d5-5f6a-a8cd-cf8b343c9ec1', '0964dad9-9807-5c71-973a-94061d78875b', 'eveil-scientifique-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد النهار والليل', 3, 120, 30, 'boss', 'admin', 2)
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
  ('6f74648d-35aa-5525-b903-c7d3219141eb', '87668b80-03d5-5f6a-a8cd-cf8b343c9ec1', 'استيقظ سامي ورأى الشمس مشرقةً والأطفال ذاهبين إلى المدرسة. أيّ وقتٍ هذا؟', '[{"id":"a","text":"النهار"},{"id":"b","text":"منتصف الليل"},{"id":"c","text":"وقت النوم"},{"id":"d","text":"الليل المظلم"}]'::jsonb, 'a', 'إشراق الشمس وذهاب الأطفال إلى المدرسة علامةٌ على النهار.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c324d727-b867-5fe6-b37d-c951bb3d68fb', '87668b80-03d5-5f6a-a8cd-cf8b343c9ec1', 'لماذا ننام في الليل عادةً؟', '[{"id":"a","text":"لأنّ الليل وقت الراحة فنستعيد فيه نشاطنا"},{"id":"b","text":"لأنّ الليل وقت الدراسة"},{"id":"c","text":"لأنّ الشمس مشرقة"},{"id":"d","text":"لا سبب"}]'::jsonb, 'a', 'ننام في الليل لأنّه وقت الراحة، فنستعيد نشاطنا لنهارٍ جديد.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21848f35-d656-5496-933f-0a3ac9555c72', '87668b80-03d5-5f6a-a8cd-cf8b343c9ec1', 'نظرت ليلى إلى السماء فرأت قمرًا ونجومًا. أيّ وقتٍ هذا؟', '[{"id":"a","text":"الظهر"},{"id":"b","text":"الصباح"},{"id":"c","text":"الليل"},{"id":"d","text":"وقت المدرسة"}]'::jsonb, 'c', 'رؤية القمر والنجوم في السماء علامةٌ على الليل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bd2d6103-848b-598d-ac2c-a2e75b84df60', '87668b80-03d5-5f6a-a8cd-cf8b343c9ec1', 'لماذا يكون النهار مضيئًا؟', '[{"id":"a","text":"بسبب القمر"},{"id":"b","text":"بسبب النجوم"},{"id":"c","text":"بسبب الظلام"},{"id":"d","text":"بسبب ضوء الشمس"}]'::jsonb, 'd', 'النهار مضيءٌ بسبب ضوء الشمس التي تنير الدنيا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25db2331-adfc-542f-a459-fc18806055f1', '87668b80-03d5-5f6a-a8cd-cf8b343c9ec1', 'لماذا يتعاقب النهار والليل؟', '[{"id":"a","text":"لأنّ القمر يضيء النهار"},{"id":"b","text":"لأنّ الشمس لا تغيب أبدًا"},{"id":"c","text":"لينتظم وقتنا فنعمل في النهار وننام في الليل"},{"id":"d","text":"لا فائدة منه"}]'::jsonb, 'c', 'تعاقب النهار والليل ينظّم وقتنا: نعمل ونلعب في النهار وننام ونرتاح في الليل.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('229b21c4-203d-5bb6-8736-1cbf8a833d9b', '87668b80-03d5-5f6a-a8cd-cf8b343c9ec1', 'أيّ نشاطٍ يناسب النهار أكثر؟', '[{"id":"a","text":"النوم العميق"},{"id":"b","text":"اللعب في الحديقة والدراسة"},{"id":"c","text":"مشاهدة النجوم"},{"id":"d","text":"الراحة في السرير"}]'::jsonb, 'b', 'اللعب في الحديقة والدراسة من أنشطة النهار، وقت الضوء والنشاط.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('71ac7233-4a9a-5beb-a001-7ad513635da5', '0964dad9-9807-5c71-973a-94061d78875b', 'eveil-scientifique-1ere', '🛡️ مراجعة ⭐⭐: نهاري وليلي', 2, 70, 15, 'practice', 'admin', 3)
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
  ('bee31a42-c70b-5243-a09c-7566bdc2ac5e', '71ac7233-4a9a-5beb-a001-7ad513635da5', 'ما الذي نراه في السماء نهارًا؟', '[{"id":"a","text":"الشمس"},{"id":"b","text":"القمر"},{"id":"c","text":"النجوم"},{"id":"d","text":"الظلام"}]'::jsonb, 'a', 'في النهار نرى الشمس مشرقةً في السماء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f3c7a84-d118-5585-a061-b90bb016dd16', '71ac7233-4a9a-5beb-a001-7ad513635da5', 'أيّ هذه من أنشطة الليل؟', '[{"id":"a","text":"الذهاب إلى المدرسة"},{"id":"b","text":"النوم"},{"id":"c","text":"اللعب في الملعب"},{"id":"d","text":"العمل في الحقل"}]'::jsonb, 'b', 'النوم من أنشطة الليل، فهو وقت الراحة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('52ef4524-0046-5941-a2d8-cd118bda2389', '71ac7233-4a9a-5beb-a001-7ad513635da5', 'أيّ جملةٍ صحيحة؟', '[{"id":"a","text":"الشمس تظهر في الليل"},{"id":"b","text":"النجوم تظهر في النهار"},{"id":"c","text":"في النهار تشرق الشمس وفي الليل يظهر القمر"},{"id":"d","text":"النهار مظلم"}]'::jsonb, 'c', 'في النهار تشرق الشمس وفي الليل يظهر القمر والنجوم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd2cca04-a0a9-56a7-9dff-91ede89be84c', '71ac7233-4a9a-5beb-a001-7ad513635da5', 'كيف يكون الجوّ في الليل غالبًا؟', '[{"id":"a","text":"مضيءٌ جدًّا"},{"id":"b","text":"ساطعٌ بالشمس"},{"id":"c","text":"هادئٌ ومظلم"},{"id":"d","text":"حارٌّ كالنهار دائمًا"}]'::jsonb, 'c', 'في الليل يكون الجوّ هادئًا ومظلمًا لأنّ الشمس قد غابت.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2756f8f3-ae2c-57ec-bd1f-dda40dd82830', '71ac7233-4a9a-5beb-a001-7ad513635da5', 'متى نلعب في الحديقة عادةً؟', '[{"id":"a","text":"في منتصف الليل"},{"id":"b","text":"أثناء النوم"},{"id":"c","text":"في الظلام"},{"id":"d","text":"في النهار"}]'::jsonb, 'd', 'نلعب في الحديقة في النهار، فهو وقت الضوء والنشاط.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bf87945c-9641-549d-89a1-48dcc9513037', '71ac7233-4a9a-5beb-a001-7ad513635da5', 'ماذا يحدث للشمس في الليل؟', '[{"id":"a","text":"تغيب ويظهر القمر"},{"id":"b","text":"تصير أكبر"},{"id":"c","text":"تتلوّن بالأحمر وتبقى"},{"id":"d","text":"تشرق أكثر"}]'::jsonb, 'a', 'في الليل تغيب الشمس ويظهر القمر والنجوم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('43f26a88-2d2e-5f49-8e30-a779d207a003', '0964dad9-9807-5c71-973a-94061d78875b', 'eveil-scientifique-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: خبير الزمن', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('ddce2379-26c0-5a82-bbf1-de7dff055819', '43f26a88-2d2e-5f49-8e30-a779d207a003', 'بعد أن غابت الشمس وظهرت النجوم، ماذا حلّ؟', '[{"id":"a","text":"النهار"},{"id":"b","text":"وقت المدرسة"},{"id":"c","text":"الليل"},{"id":"d","text":"وقت اللعب في الشمس"}]'::jsonb, 'c', 'بعد غياب الشمس وظهور النجوم يحلّ الليل.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ca0113a-6056-5e23-8f23-57c3f751ad9a', '43f26a88-2d2e-5f49-8e30-a779d207a003', 'طفلٌ يلبس ملابس النوم ويرى القمر من النافذة. ماذا يجب أن يفعل؟', '[{"id":"a","text":"يذهب إلى المدرسة"},{"id":"b","text":"ينام لأنّه وقت الليل"},{"id":"c","text":"يلعب في الملعب"},{"id":"d","text":"يعمل في الحقل"}]'::jsonb, 'b', 'رؤية القمر وملابس النوم علامةٌ على الليل، فيجب أن ينام ليرتاح.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4d952f1c-b96a-56f3-a4ff-ca5814c77b3e', '43f26a88-2d2e-5f49-8e30-a779d207a003', 'لماذا لا نرى النجوم في وضح النهار؟', '[{"id":"a","text":"لأنّ النجوم تختفي تمامًا"},{"id":"b","text":"لأنّ ضوء الشمس القويّ يغطّي نورها الخافت"},{"id":"c","text":"لأنّ النجوم تنام نهارًا"},{"id":"d","text":"لأنّها تذهب بعيدًا"}]'::jsonb, 'b', 'لا نرى النجوم نهارًا لأنّ ضوء الشمس القويّ يغطّي نورها الخافت.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f982d7eb-b91c-5cc4-b2a7-98baa6ac3329', '43f26a88-2d2e-5f49-8e30-a779d207a003', 'صنّفي: أيّ مجموعةٍ كلّها من علامات النهار؟', '[{"id":"a","text":"الشمس، السماء الزرقاء، الذهاب إلى المدرسة"},{"id":"b","text":"القمر، النجوم، النوم"},{"id":"c","text":"الظلام، النجوم"},{"id":"d","text":"القمر، السماء المظلمة"}]'::jsonb, 'a', 'الشمس والسماء الزرقاء والذهاب إلى المدرسة كلّها من علامات النهار.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a3f5f84-b311-5324-a7c4-907d71f2e64a', '43f26a88-2d2e-5f49-8e30-a779d207a003', 'لماذا نحتاج إلى النهار والليل معًا؟', '[{"id":"a","text":"لأنّ النهار للعمل والنشاط والليل للراحة والنوم"},{"id":"b","text":"لأنّهما لا فائدة منهما"},{"id":"c","text":"لأنّنا ننام في النهار ونعمل في الليل دائمًا"},{"id":"d","text":"لا نحتاج إليهما"}]'::jsonb, 'a', 'نحتاج إلى النهار للعمل والنشاط وإلى الليل للراحة والنوم، فيتوازن يومنا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('741e6581-ba5c-5951-a1ea-5578dcb8b501', '43f26a88-2d2e-5f49-8e30-a779d207a003', 'ما القاعدة الصحيحة عن النهار والليل؟', '[{"id":"a","text":"النهار والليل لا يتغيّران أبدًا"},{"id":"b","text":"الشمس تظهر ليلًا والقمر نهارًا"},{"id":"c","text":"يتعاقب النهار والليل: شمسٌ ونشاطٌ نهارًا، قمرٌ وراحةٌ ليلًا"},{"id":"d","text":"النهار مظلمٌ والليل مضيء"}]'::jsonb, 'c', 'القاعدة الصحيحة: يتعاقب النهار والليل؛ في النهار شمسٌ ونشاط، وفي الليل قمرٌ وراحة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2168be20-0c5c-5854-b5d4-5e72ace64f44', '0964dad9-9807-5c71-973a-94061d78875b', 'eveil-scientifique-1ere', '⚔️ تدريب الأبطال ⭐⭐⭐: أُتقنُ النهار والليل', 3, 120, 30, 'boss', 'admin', 5)
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
  ('1fa42683-2c9e-5798-9565-664345bc2e5a', '2168be20-0c5c-5854-b5d4-5e72ace64f44', 'ما الذي يدفّئ الأرض في النهار؟', '[{"id":"a","text":"الشمس"},{"id":"b","text":"القمر"},{"id":"c","text":"النجوم"},{"id":"d","text":"الظلام"}]'::jsonb, 'a', 'الشمس تنير الأرض وتدفّئها في النهار.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('61596c8b-f3c3-55b8-9446-0df6f1c46752', '2168be20-0c5c-5854-b5d4-5e72ace64f44', 'أيّ نشاطٍ يناسب الليل؟', '[{"id":"a","text":"الدراسة في المدرسة"},{"id":"b","text":"النوم والراحة"},{"id":"c","text":"اللعب تحت الشمس"},{"id":"d","text":"العمل في الحقل"}]'::jsonb, 'b', 'النوم والراحة من أنشطة الليل، فهو وقت الهدوء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6681a13e-1891-5e0e-a54c-436a486366d2', '2168be20-0c5c-5854-b5d4-5e72ace64f44', 'ما الذي يميّز سماء الليل؟', '[{"id":"a","text":"أنّها زرقاء وساطعة"},{"id":"b","text":"أنّ فيها شمسًا قويّة"},{"id":"c","text":"أنّها مظلمة وفيها قمرٌ ونجوم"},{"id":"d","text":"أنّها حمراء طوال الليل"}]'::jsonb, 'c', 'سماء الليل مظلمةٌ وفيها قمرٌ ونجوم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5976af41-44d5-5806-89e9-0b0be30bb8ba', '2168be20-0c5c-5854-b5d4-5e72ace64f44', 'لماذا نشعر بالنعاس في الليل غالبًا؟', '[{"id":"a","text":"لأنّ الليل وقت الراحة وجسمنا يحتاج إلى النوم"},{"id":"b","text":"لأنّ الشمس مشرقة"},{"id":"c","text":"لأنّ الليل وقت اللعب"},{"id":"d","text":"لا سبب"}]'::jsonb, 'a', 'نشعر بالنعاس في الليل لأنّه وقت الراحة، وجسمنا يحتاج إلى النوم ليستعيد نشاطه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('153ef198-1cf4-5661-be9f-cf777fcd8abb', '2168be20-0c5c-5854-b5d4-5e72ace64f44', 'طفلٌ يرى الشمس تغيب شيئًا فشيئًا وتظلم السماء. ماذا يقترب؟', '[{"id":"a","text":"النهار"},{"id":"b","text":"وقت المدرسة"},{"id":"c","text":"الليل"},{"id":"d","text":"وقت اللعب في الشمس"}]'::jsonb, 'c', 'غياب الشمس وإظلام السماء علامةٌ على اقتراب الليل.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f77e975-fc5e-523f-a023-126357e53633', '2168be20-0c5c-5854-b5d4-5e72ace64f44', 'ما الفائدة من تعاقب النهار والليل؟', '[{"id":"a","text":"لا فائدة منه"},{"id":"b","text":"ينظّم وقتنا: نعمل ونلعب نهارًا ونرتاح وننام ليلًا"},{"id":"c","text":"ليجعلنا نتعب فقط"},{"id":"d","text":"ليبقى كلّ شيءٍ مظلمًا"}]'::jsonb, 'b', 'تعاقب النهار والليل ينظّم وقتنا: نعمل ونلعب نهارًا ونرتاح وننام ليلًا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

