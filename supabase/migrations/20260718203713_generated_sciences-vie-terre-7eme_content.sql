-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: sciences-vie-terre-7eme (علوم الحياة والأرض)
-- Regenerate with: npm run content:build
-- Source of truth: content/sciences-vie-terre-7eme/
-- =========================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'exercises_mode_check') THEN
    ALTER TABLE public.exercises DROP CONSTRAINT exercises_mode_check;
  END IF;
  ALTER TABLE public.exercises
    ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss', 'quiz', 'challenge'));
END $$;

INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order, content_language, is_premium, theme_id, grade_id, manuel_refs) VALUES
  ('sciences-vie-terre-7eme', 'علوم الحياة والأرض', 'الوسط البيئي والتنفّس والتغذية والتربة والماء وفق برنامج السنة السابعة من التعليم الأساسي', 'Vitalite', 'subject-svt', 'Leaf', 7, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '7eme-base'), NULL)
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
  grade_id = EXCLUDED.grade_id,
  manuel_refs = EXCLUDED.manuel_refs;

-- Prune admin-authored content that is no longer in the source tree.
DO $$
BEGIN
  IF to_regclass('public.dungeon_run_questions') IS NOT NULL THEN
    DELETE FROM public.dungeon_run_questions d
    USING public.questions q, public.exercises e
    WHERE d.question_id = q.id
      AND q.exercise_id = e.id
      AND e.subject_id = 'sciences-vie-terre-7eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('6b7b8cc9-ad5a-5e66-99c7-ffa43976b72d', '39ecdda8-d626-5c49-87ba-063f531d34be', '0b0c30b9-c7cc-5241-9f82-c481767a11b6', 'bdd6f95a-2f32-56b3-a31a-649c445e400d', 'a5272b2f-8b38-5b98-9494-ee96095f4f62', '6fd0a15f-9449-527e-9ceb-502221d4ee0c', '773f0e01-81b3-5c0b-a09b-e2ffbb3fb82e', '368addf7-9758-5639-907f-9d31c399e59f', '7067eb2b-ad41-5dca-aec1-9f4d734de1e0', '5aa22137-79ad-55c3-89be-7022a0de11d4', 'f986a840-791d-574a-8186-b23f5f3ee62e', '67d1feb5-b39b-56ad-91d5-38c52887a785', '182981c6-d125-57c1-9da3-85d1a9445c19', 'b699408d-8259-532e-b1a0-f93c8f18ecc4', '6f09772d-cc25-5b54-9362-dd070884ad75', 'c6db57f2-c344-51eb-8c80-ba17ee94ee01', '790dd7f1-b610-5983-b006-fccde71c7709', '2d0a642a-d010-5b9b-a368-966ee0ca20da', 'c332a0a8-755e-5f90-8094-d8883f11ad54', '52c5aa04-2498-5b61-b501-6ef124ab1fcc', '24376e6d-0b1b-570b-991b-daa35cafef4d', 'f7206aa8-a327-5354-be76-f714f7fbae3f', '93bad6a3-4dc5-5212-88b0-722cd2968f95', '0f64b1e6-d727-5245-9720-4bf97a56ec9b', 'cf2f9c50-84ec-5f62-a4d7-696dc88dba55', '9670f50f-76c2-58ba-ac13-c6be87b47f2f', 'f948e127-4f85-55d5-8310-877d22e758f5', '7b61513a-3984-548a-987a-36642f9cd8ad', 'a707e4b0-88ef-5440-8ead-56b1001cab49', 'ded91366-befd-565c-9e8b-de1887f335ca', '5e728c61-0cd8-5dd1-a3a5-211ecc35300f', 'd8858ada-51ef-5a0e-a34d-9a1cf694bd1f', 'e8a9980b-a277-5bdd-9b52-8256052f48b9', '49da1540-0406-5dca-8076-512a30cabef3', 'ca35affc-8d5a-569a-a033-975e9bfdfb6f', '8b50beaa-ca60-5d54-9c91-f892c6387949', 'c5586041-2e7a-5935-94b4-ac149fb9d662', '300eea73-b293-50ae-9194-aea0112b3562', 'c1f2d6b4-e2c8-50fe-9f9f-27cde73a01b4', '218bfdae-81ca-5ac9-a58d-7706f03330b7', 'a91a73de-6243-5c39-b9ff-c5222f4996ac', 'b84acd11-802a-508d-9521-bce330353cdf', '6663fd19-3a28-5ad0-8fa0-030624c5819b', '841a7c72-e85e-51ec-be94-814b9f951065', '6fc89fe3-b37b-5831-9436-96d587a26e2d', '35358fff-8f68-52e2-8d18-0006c142751c', '6c824b26-9508-57a4-8472-61e78f82f0d9', '84edca86-55e0-5ddb-9acd-b6606f488c9d', '7cb1a2e2-4050-5df6-87d0-485f398b3992', '869a5926-cc7c-575a-9e87-8eb6b8c795ad', '729adbb7-da23-5a98-b865-84eded971ead', '847d8d78-e4f7-59fe-b34c-6d9786aa8450', 'fd79766c-7fb4-5179-b97b-b09ac8abd538', '485d5190-6be2-5cbd-a32a-124d8946a059', '781d9610-631e-5367-9ba9-a26756adcd78', '0a50a529-b923-562d-89ec-69c6b2fdfb57', '08018eff-0ebf-5170-ad3e-0c20593a23a7', '7e9a0266-a9dc-5dc4-b42c-f1347fd3b464', 'db551780-ab3d-5290-9b62-9248a47d7fa4', '76602dc6-6f63-519d-83f9-31709317b2da', 'f2ab30fd-7884-55e5-802c-189ece5de0b1', 'b2286f6c-a94d-59fa-ba01-ae15795549e3', '87836661-3b3d-595e-a60f-3c8bedde6638', '449a2399-61c4-5d25-8df5-7eea9dc40e99', 'ab6a8b42-43a0-5c6f-a020-20704c2cbf7f', '92159343-9a3b-5fe1-8af5-1c43daa5b373', 'c6e1a974-bd58-52c2-a071-de920fab5bd0', '10d716ac-62f7-5f9d-942c-e08046e08ed7', '9b7f8fb4-57b5-5c59-bed0-69fecf00fd43', 'e1039267-3a10-589b-85fc-0db065a7daa3', '21d1e16b-0878-5f8e-afce-43dec6798b08', 'fd6e3caa-e537-5c3f-adda-5a1556c57a6d', 'a64a48b5-b26d-516f-a7f2-6cbeecbe8cc4', 'cb286e5a-dfa3-5a90-afb9-a847bd73b0ea', '891ddddc-5536-5b3e-89e9-4286ace846e4', '1662ae59-73c7-549d-aebe-a4ef3208eab8', '16f4ee00-1594-5486-bae0-6bb6d8081528', '0c5a0a1b-2e65-528f-ad31-3ade387daedb', 'a902c6cc-661e-5ea9-93a9-487d906c26dc', '3eb792ae-cab3-5902-bd3c-9bf513851c9e', 'f9bf0443-0254-5053-a79c-17872c0d11c6', '0d184507-c71e-5de5-bc81-bf165c534654', '8702da84-3821-5640-b849-5c61ba247526', 'e085b399-6414-5256-a382-0e7d930f419b', '397c675d-381d-59a5-a33d-65045d365905', '39c74960-73e4-5888-ba63-ae194d1653ec', '26b4cc51-dfbd-5642-905a-34d5608b355c', 'b7969031-bfe3-5514-b973-eb93e980acc5', 'badc93c3-6abb-5111-8cd4-3f85e455b989', '6f136bbf-bc61-54b4-bc1e-95506ca04bec', '0fc6fca8-b341-5bc3-a242-2d137644f685', '85e718b8-0bc5-58d6-a5b1-41bdf648fd5b', '89ca3898-1f4a-5b09-a41b-984ba2bb41cc', '2e2992bc-55da-56b1-b0a2-df18bdd5189b', '1d2bc7b1-a458-5155-bc4b-b08a8d3a35a7', '822a8d2a-618a-5771-87ac-e53e1333a223', 'a14121ca-678a-5c8e-987a-1b8a11bd9e04', '62b133da-50ff-5d77-b558-6a1b4478a25f', 'e9e0aa94-f4e1-5b7e-a46c-4d6b5845b406', 'a757866d-2fdf-56c7-8878-d3ded93532f4', 'fa4f8462-43a6-5d6e-b292-eaaf225505dc', '98c38e01-f748-5e49-8402-d9d88af108a5', 'a2152692-16c5-5608-ae0b-3663cc73d744', '576b40ef-b5ee-5779-aa48-159131520bdf', '8a5af90d-ada0-5ada-b498-44c6d59dde61', 'f6401c6f-5b5c-5183-bb97-a0b90eb32fd8', '7d0fc865-4e44-5b69-a80d-02842b811ef8', '3c479068-4341-549e-9b45-5d8a5effe0b1', 'faa4c7c8-c7e8-5aac-b2ec-3909b2818e42', 'e1dd7018-e184-53ba-a34f-256150047652', 'b89db3fa-412a-5aa4-8fd4-6fb15e9c2dc5', 'e0c06f68-a7bb-546a-870e-08d83f4ab03e', '3485198b-3a6e-5ad5-adfc-f49282718221', 'da181e56-c4a9-5fac-9af7-95969927a244', 'b32fd641-d599-5434-b5cf-6f798452b5c6', '80939fe0-3d5f-573b-a492-5b6cc9d48c4e', '75afd756-ba8c-555f-8d41-1ec3065aabc7', 'fbd9d38c-1b72-5f35-a0cb-aeb78de190d6', '5c8f7306-2071-5e43-a829-26df27f445ca', '5abdc061-9f62-5de3-8da7-ead62b4fa4d2', 'c1868f24-46fd-5e83-829c-c03f8244cac3', 'a0928b68-13eb-5dcc-86d7-54d26b748e33', '01916016-3d9d-5896-9bf3-50a96719eac7', 'a5196351-3dfa-5164-837a-e02d1f281f4b', '6174ea99-e79b-559c-a482-de8a6e4ced8a', '50c8452c-c117-5f4d-9fc6-ec1633417038', 'b03b4fbe-21b9-5979-bba5-34bcbe06455a', 'b2b38070-27ea-55f0-9844-748122631320', '81c7cd7a-74cf-598f-b9af-db733136ec07', '12a099a0-d83e-5744-8241-510f556b2286', 'ac4c82f9-116c-5a86-b301-4a055c662085', '2b146a81-6889-55b7-8811-a9fa04898993', 'fe89620a-a6dd-502d-b35d-7ac1ed4983c9', '60275106-ec17-5139-bbde-a167f1d6f683', '7c9f4fdd-09a4-5288-b107-ebdd609a9c3d', 'ee4c5f13-e5c2-5ba5-9753-37c8bbe73eac', 'a9548deb-86f4-5119-8549-c92e6be71d95', '18143cd1-5bec-5bc0-bc9b-5d436689b2ca', 'd5ea00af-4184-5544-bfb9-a211f832a557', '211e4808-3e69-59d0-873d-84bda8a40bb2', '3d7feed7-d8bb-56c3-9005-25099a7e3d4d', 'db58c264-1702-50f6-811f-74911b0eed5b', 'bc95538d-76fd-5a2b-bf54-4702be1bb642', 'cadc66a2-1268-5ca1-b534-2691a2e1290e', '22284673-f9af-5094-b405-8f874483c3c5', '59e49d4d-f664-5988-bd9f-c5c9cd70ee5e', 'f88857b3-3015-540b-a6b0-1d2cb35cc5ec', '5d08fa20-d2d7-5b3c-a00e-b052dfdc7c77', 'ceb17ac8-586d-59da-a98e-4e94041b9163', '36c222bd-ea6c-57df-96e3-da22fb3a974a', 'ad4abfec-80fc-52a3-acfa-a71252e0b6a1', 'd519d233-2936-53c9-8b6b-88ea8861fde8', '1b3a6a37-7f8a-5eee-8b45-56bc8875ee7d', '5db28140-4989-5b42-8e20-9f307c9199b5', '51a590a6-a028-59c0-b2ad-15058a720efc', 'bc8ed3cf-f419-5ef7-9dd9-fc79bc642c63', '497cbd34-a4a9-5879-9f58-e4ba1d58c740', '51719a9e-2fe1-5637-afef-0a589725ff36', '3f73b590-9936-53e6-aa80-ac1f11c8de22', '9ff64570-8d12-5c0b-9df7-b1acac27f9b9', 'f831c24a-7751-50a2-bb48-56ac23e737a8', 'd5e31ca7-0792-57d4-b32b-fbabb21c40bc', 'b645543a-88c1-5e11-8ded-f1954d894295', '4e3e2ad5-fcad-54af-ab86-27dbf37af687', 'e2a35f1a-b2ea-5020-abe0-e0e4328def25', 'b9735751-6bac-50d2-abe0-65c56fdf1ecd', 'fa3de516-cc3e-5c6f-a2e0-2184a97dab92', '359df85c-4a0b-533d-b8e3-c7c248effe5b', '97d11cfc-4ce5-5fea-8e7f-b498e5aede5d', 'a13a15ce-f508-5727-84c6-10a906b8e7f5', '8596801d-3e01-506a-ba05-87205008983c', 'f752f717-3858-5672-b008-e5715cfc7749', 'f3e3c555-76cc-5f39-a356-d885fb247998', '496e1016-e5d7-578f-874b-1feb326ebe0e', '9dd1810e-9d57-58be-a42f-9a36cf726f30', 'fd4ddb54-9879-53c6-95ce-9f92ea7fee38', '0683a981-34db-52f9-a048-5bc9e6c5590f', 'e320b774-b712-5cb5-acc8-66a9962fad3e', 'e944f329-9a0f-5d61-b4f7-3e41d620b4eb', 'a5864d00-d1bb-51d0-9b43-eaa47c0717fc', '84f90dbf-8c18-5f2e-a2d3-eae7cbe9e9db', '8dec583a-e65c-57f7-bf42-f1f53d115296', 'bc5d79a6-270a-5d43-b157-c03acfcf3e15', '9ed9c258-92e9-55cf-bbba-d4d3e38aa722', 'f340c2ca-02df-5855-87cd-2c126efe457c', '31cdf54a-964f-5342-b50f-af0804b9d8a1', '06836d57-88af-56ff-96a9-0fd5b5cd735a', '9e4a41a4-7dfb-52f4-baef-f7ecd5a79706', '279ed419-928a-5674-8bb0-514779655a25', 'bcc98ec6-7879-5e8c-bf0d-b71c6c33da31', 'd8aa21ad-48d2-5ffe-8d28-5ce68cb49aee', '060f2f5f-20e4-5448-9298-2d1405b3de2a', 'd84b209a-6be7-5c12-88ff-5ccf23b8276a', 'b219dd71-2a07-58bd-8a10-69b7210bae41', '14fe9ecd-fa80-53fd-929c-271d4cc51cc2', '00755552-c112-5956-a515-0917e4cad61a', 'ed1f201b-b7da-5764-9b62-15af565a43f1', '615eef54-4185-549d-a99e-25a128065ff5', 'ec5f10dd-c4cb-5023-938e-c10ad9718358', '21b51f5f-34c1-554a-b773-8f8f8570cb93', 'dbdb483b-3b9e-5254-900a-85ac3edbceb5', '9491a138-caca-5378-921c-8dceb9e07119', 'd8b9e795-e6bd-5ec5-a0e0-1e8bb7ed9562', '4deeb9d4-b102-5aba-b8e5-70493bcd19b2', 'cc4a4f21-0379-5da9-b3eb-9bad5c63739f', '1687c79c-8930-5fb0-910b-bef4ed34d3a8', 'd0b9810e-c5a6-5684-bbd7-fe3b8102ef02', 'd36e2fcb-ef6b-5007-9aa8-0a3a5b332eef', 'e1504b14-6644-5931-808b-97ea5d9bf4dd', '65356c97-96d9-5bdc-9cf0-2e188f15204d', '77cedae4-c5f0-5068-857d-8fd96f6bd3a0', '2e264f50-ff08-5855-b9cf-55dda660e9db', 'ddfce6cd-24e1-5ff5-8465-de9fa5bf6106', '31136d20-537c-578b-84ae-fa9600458e75', '6022c05a-d7b8-598a-a8f2-b190a17ad989', '378c85be-48e1-55db-b21d-e44a92ba4547', '49b663e7-1e6b-58aa-ae17-531e1ce44e8a', 'd3f2f9fc-4652-520e-bc3d-b0a1956dfd34', '4baab743-c1b1-59fa-8beb-a02bca286ce0', 'f646ceb2-51d5-567b-9f19-abe386ec1fa3', 'ee8d75c4-8d0b-507e-9415-4d19d71728d1', 'a73b00a5-82d3-59fb-8309-c95df4ee5f93', '0d4b06a5-af6e-5a76-9eaf-fbe38d602e31', '116f475b-dc7f-5c34-ba20-efdaf9f9e30d', '7c0f3750-4798-5429-96ac-60c9b018ba2a', '3e29e2a8-9ed2-5683-b344-f973724369c5', 'e3c5a540-2903-57d5-a004-15e79acf40d7', 'b7938454-a22d-5c16-b242-430b5a1164e4', '76f05ca8-1957-59e9-a559-3c031a0401b8', '2f37ab81-ea26-5d1c-9eff-08e159ac91f1', 'c27f6db0-008e-52ab-ab4d-f853de1deac5', 'bfa4071e-1b65-58a3-b363-75131bdd7670', '8d2dfef5-21b8-5db2-92ea-e80fa480d97e', 'c48d7448-fd90-5e80-aab8-b46196ede091', 'c015d7fd-4c32-5645-b724-b7d35950e14c', '91cee77e-bedc-57d4-b8b4-92603c66352e', '5957ee3f-41fa-5e2a-9f12-bacad6c96ff3', '7d4f010c-41e3-551e-8270-b6a6a39280f9', '67973c24-51e6-5526-ae26-f5980d0284c4', '2453d295-b1ec-570b-a033-bb8eb937fad0', '9132585d-e74c-5649-997b-1ad17dec9d6d', '1cc266b1-133e-5e13-b912-18cc07002638', '676ddf59-8b5a-5069-bd95-41e01a71d841', '924f8d6e-54a3-5e11-897c-df269e1fbd32', '318b656e-bf40-5469-a98b-00a6f13c11eb', 'a8805b91-069c-585e-8a81-4d8f6a700956', '964151d5-2cbf-5738-99a2-fcb839e844bd', '4082448d-d9d6-5652-9941-807f5a84fcc4', 'd8f17327-cbda-585b-920b-ab22fb84538d', '95705cc2-7072-5396-87a5-2eaff4b5e63e', 'bffc97ac-160e-5635-af6c-a9420bf3803a', '11a5b779-872f-5ca7-81d5-9d0c22034c19', '2dd1e87f-f351-5559-a771-f79a4313ec99', '564e2b40-88bd-5442-8480-c444da4a7c4f', '8c3b817d-d00a-5929-ad46-03614d61a82a', '9d03fac9-faa4-53ed-8711-bb89c03313cd', '423f097a-4a17-590c-80f1-f1c838922488', '845ca028-247c-5006-b278-c6d5666db089', '0dcd134b-5565-59cc-871e-58a9d9bc87d1', '2f62da3d-6a2b-5c07-b7ef-2914b7be1753', 'eefbe079-463b-5e32-b707-4c1a4e5abce6', '14adeb4f-5449-5275-9535-8c69e778926e', 'ed171ab6-bcc7-5f86-b98a-cde03fc66400', '993dbeb8-fece-5738-863b-0829deac1d02', '320d778d-3e13-583c-8510-57eec36784cf', 'cad81b72-d40c-56a0-982b-9575ed26bef0', 'cbb6f500-20b1-5a05-a9b1-aed670509738', '846dde04-8b18-54d8-a340-28da03ff46d1', '1ebd9d2b-887b-509a-913f-ce089968dbc2', '12934e6c-a55d-5f96-b916-44f8a1254f79', '3c38c768-02a6-512e-b8af-641fb32de24c', 'ab645903-0ffa-50ec-aa32-4b21c65a2d7c', '1b3f3621-3983-57d8-9f96-4fa6c333eacb', '6dd75cd6-264c-5c9f-a873-a3bfe00b5256', 'c4597cfa-cf18-5780-abf8-181bc25b3f53', 'd9f10875-b71d-5134-bbd1-b3c13c47b67b', '7e3c4329-bc42-5f08-8a34-a586588b6d63', 'c1dc1f6c-df4a-561f-8879-d63a8ab1bd36', '859b48cc-64ac-560f-8b6f-22edad7a23e0', 'bb0c62ee-12cd-568b-9d68-0c5b331b1bee', '69f866c1-c541-51f4-9d7c-29ce8dc1d250', 'c40f40c6-9ada-5597-b1c3-1fea246cb5cd', '824b1ee2-b146-5089-968c-56494a747ba8', '025a54a5-1b47-5d3e-9918-1d3471d7ae58', '7af01fc5-3fe0-5a7c-b1b3-b270ff59e6df', '4e5e3da5-8f7d-5a19-97a2-090059271a96', 'd09e8ae9-5028-5e8f-b987-76c77d712ba5');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'sciences-vie-terre-7eme' AND source = 'admin' AND id NOT IN ('276c0a98-498b-55ac-b3f9-ce5fb01a86d4', '7d22a79c-1b15-5f58-8bcb-75385962fdf1', '28867db7-98c1-59c4-a956-cc2fd7ad4756', '07c28a0d-f813-5b1f-951b-46d66b0db549', 'd6b323a7-a8c3-55be-92e4-d965fd79d316', 'c236d912-19a9-58e4-8078-a8d4cb0e75e3', '60173e6c-17ba-57b7-b5ed-d281f07ca6c1', 'f10285e8-add4-5166-8f40-19215d69d44b', '6f9752f7-ff29-5e27-bc51-078e7d629980', '5927e75d-44cf-5855-b1eb-b733a74351d2', 'fd03878f-9e42-584d-aee1-dfeded694cd2', 'ff415b48-29cb-5f61-8d81-bb1efc9ae39e', '01faf188-3d5e-5053-bfb6-5636fbddfbba', '1c6d2f00-312b-57e7-9265-9fcdd7b89c53', '99803c95-c8e1-584b-940d-626890ca579e', '945fd01d-4434-5705-90de-be5a343ce3ae', 'ad84b448-69ee-5c38-90cb-9f66aab0d58f', 'e6614d03-220a-5837-9e94-ba5cdeb7c233', '3f1fd5e5-d1fb-5d89-8291-38da0c61ad67', '81537fef-e72e-5582-b5d7-45146b6c6228', 'c66f59cd-e890-5984-a018-bf675af9d287', '45004e0a-8273-58ed-bf66-4831555f75a8', '4dccf20e-13f9-5dab-be0c-6dd4def067c1', 'c7db6f68-62de-5fdc-bac9-bb2dde729f41', 'f18769c1-fe35-53bb-b6d3-ecf66d9f0078', '911eb879-9600-50eb-adaa-8f8a6699adf2', 'f0daec27-e71d-53c1-965a-0a40272be898', 'd18c26f3-58ee-5148-a216-98e3c9bb4724', 'dd78be23-ea58-5b8e-8f38-07a1a6615ea8', 'c2af133d-6d36-5780-ab3e-786ec84f5e7f', 'b0c15d35-4771-54be-b9d8-7b8fef99bd31', '9e7170b4-4429-536f-bd07-4955e4d39a2e', '111a2ec7-0edb-5981-a8f0-5fb499de5cd8', 'ec8bc23b-d478-5a5b-808d-1713ec1a4e23', 'fe0fb41e-470d-52f9-a73e-e48139308397', '88be354f-3405-5e62-95e5-322f21f3543c', '1298ff44-f09c-5682-a9de-18e9f125e9b5', 'b3eb9062-32b6-527e-9af9-c38d0fcb214a', '7721d4e1-e1c5-5bf2-b327-2f4807807845', 'e09adc5b-1aaa-55d4-a93f-322b3a09ab6b', '61a47596-63ef-5041-a451-7cfd57c077f9', '476a213a-a5c4-54b9-a771-2a4303671c7d', '316f482a-cd80-52fa-86b1-6c4e0cb1ffad', 'ec86af8f-217e-58e8-81bb-ed9913b10de7', '6a307483-1a11-5d1c-8a2f-f3139e499b91', 'cd576536-2543-58bc-a3f5-9ddf40bbb0e7', '39a5721d-06e2-5f56-910b-e5e22264e371', '05252fc0-9e36-51a3-973a-24323671b645', '1e6f49bc-7bbc-58cc-aebd-9146ab60d900');
DELETE FROM public.questions WHERE exercise_id IN ('276c0a98-498b-55ac-b3f9-ce5fb01a86d4', '7d22a79c-1b15-5f58-8bcb-75385962fdf1', '28867db7-98c1-59c4-a956-cc2fd7ad4756', '07c28a0d-f813-5b1f-951b-46d66b0db549', 'd6b323a7-a8c3-55be-92e4-d965fd79d316', 'c236d912-19a9-58e4-8078-a8d4cb0e75e3', '60173e6c-17ba-57b7-b5ed-d281f07ca6c1', 'f10285e8-add4-5166-8f40-19215d69d44b', '6f9752f7-ff29-5e27-bc51-078e7d629980', '5927e75d-44cf-5855-b1eb-b733a74351d2', 'fd03878f-9e42-584d-aee1-dfeded694cd2', 'ff415b48-29cb-5f61-8d81-bb1efc9ae39e', '01faf188-3d5e-5053-bfb6-5636fbddfbba', '1c6d2f00-312b-57e7-9265-9fcdd7b89c53', '99803c95-c8e1-584b-940d-626890ca579e', '945fd01d-4434-5705-90de-be5a343ce3ae', 'ad84b448-69ee-5c38-90cb-9f66aab0d58f', 'e6614d03-220a-5837-9e94-ba5cdeb7c233', '3f1fd5e5-d1fb-5d89-8291-38da0c61ad67', '81537fef-e72e-5582-b5d7-45146b6c6228', 'c66f59cd-e890-5984-a018-bf675af9d287', '45004e0a-8273-58ed-bf66-4831555f75a8', '4dccf20e-13f9-5dab-be0c-6dd4def067c1', 'c7db6f68-62de-5fdc-bac9-bb2dde729f41', 'f18769c1-fe35-53bb-b6d3-ecf66d9f0078', '911eb879-9600-50eb-adaa-8f8a6699adf2', 'f0daec27-e71d-53c1-965a-0a40272be898', 'd18c26f3-58ee-5148-a216-98e3c9bb4724', 'dd78be23-ea58-5b8e-8f38-07a1a6615ea8', 'c2af133d-6d36-5780-ab3e-786ec84f5e7f', 'b0c15d35-4771-54be-b9d8-7b8fef99bd31', '9e7170b4-4429-536f-bd07-4955e4d39a2e', '111a2ec7-0edb-5981-a8f0-5fb499de5cd8', 'ec8bc23b-d478-5a5b-808d-1713ec1a4e23', 'fe0fb41e-470d-52f9-a73e-e48139308397', '88be354f-3405-5e62-95e5-322f21f3543c', '1298ff44-f09c-5682-a9de-18e9f125e9b5', 'b3eb9062-32b6-527e-9af9-c38d0fcb214a', '7721d4e1-e1c5-5bf2-b327-2f4807807845', 'e09adc5b-1aaa-55d4-a93f-322b3a09ab6b', '61a47596-63ef-5041-a451-7cfd57c077f9', '476a213a-a5c4-54b9-a771-2a4303671c7d', '316f482a-cd80-52fa-86b1-6c4e0cb1ffad', 'ec86af8f-217e-58e8-81bb-ed9913b10de7', '6a307483-1a11-5d1c-8a2f-f3139e499b91', 'cd576536-2543-58bc-a3f5-9ddf40bbb0e7', '39a5721d-06e2-5f56-910b-e5e22264e371', '05252fc0-9e36-51a3-973a-24323671b645', '1e6f49bc-7bbc-58cc-aebd-9146ab60d900') AND id NOT IN ('6b7b8cc9-ad5a-5e66-99c7-ffa43976b72d', '39ecdda8-d626-5c49-87ba-063f531d34be', '0b0c30b9-c7cc-5241-9f82-c481767a11b6', 'bdd6f95a-2f32-56b3-a31a-649c445e400d', 'a5272b2f-8b38-5b98-9494-ee96095f4f62', '6fd0a15f-9449-527e-9ceb-502221d4ee0c', '773f0e01-81b3-5c0b-a09b-e2ffbb3fb82e', '368addf7-9758-5639-907f-9d31c399e59f', '7067eb2b-ad41-5dca-aec1-9f4d734de1e0', '5aa22137-79ad-55c3-89be-7022a0de11d4', 'f986a840-791d-574a-8186-b23f5f3ee62e', '67d1feb5-b39b-56ad-91d5-38c52887a785', '182981c6-d125-57c1-9da3-85d1a9445c19', 'b699408d-8259-532e-b1a0-f93c8f18ecc4', '6f09772d-cc25-5b54-9362-dd070884ad75', 'c6db57f2-c344-51eb-8c80-ba17ee94ee01', '790dd7f1-b610-5983-b006-fccde71c7709', '2d0a642a-d010-5b9b-a368-966ee0ca20da', 'c332a0a8-755e-5f90-8094-d8883f11ad54', '52c5aa04-2498-5b61-b501-6ef124ab1fcc', '24376e6d-0b1b-570b-991b-daa35cafef4d', 'f7206aa8-a327-5354-be76-f714f7fbae3f', '93bad6a3-4dc5-5212-88b0-722cd2968f95', '0f64b1e6-d727-5245-9720-4bf97a56ec9b', 'cf2f9c50-84ec-5f62-a4d7-696dc88dba55', '9670f50f-76c2-58ba-ac13-c6be87b47f2f', 'f948e127-4f85-55d5-8310-877d22e758f5', '7b61513a-3984-548a-987a-36642f9cd8ad', 'a707e4b0-88ef-5440-8ead-56b1001cab49', 'ded91366-befd-565c-9e8b-de1887f335ca', '5e728c61-0cd8-5dd1-a3a5-211ecc35300f', 'd8858ada-51ef-5a0e-a34d-9a1cf694bd1f', 'e8a9980b-a277-5bdd-9b52-8256052f48b9', '49da1540-0406-5dca-8076-512a30cabef3', 'ca35affc-8d5a-569a-a033-975e9bfdfb6f', '8b50beaa-ca60-5d54-9c91-f892c6387949', 'c5586041-2e7a-5935-94b4-ac149fb9d662', '300eea73-b293-50ae-9194-aea0112b3562', 'c1f2d6b4-e2c8-50fe-9f9f-27cde73a01b4', '218bfdae-81ca-5ac9-a58d-7706f03330b7', 'a91a73de-6243-5c39-b9ff-c5222f4996ac', 'b84acd11-802a-508d-9521-bce330353cdf', '6663fd19-3a28-5ad0-8fa0-030624c5819b', '841a7c72-e85e-51ec-be94-814b9f951065', '6fc89fe3-b37b-5831-9436-96d587a26e2d', '35358fff-8f68-52e2-8d18-0006c142751c', '6c824b26-9508-57a4-8472-61e78f82f0d9', '84edca86-55e0-5ddb-9acd-b6606f488c9d', '7cb1a2e2-4050-5df6-87d0-485f398b3992', '869a5926-cc7c-575a-9e87-8eb6b8c795ad', '729adbb7-da23-5a98-b865-84eded971ead', '847d8d78-e4f7-59fe-b34c-6d9786aa8450', 'fd79766c-7fb4-5179-b97b-b09ac8abd538', '485d5190-6be2-5cbd-a32a-124d8946a059', '781d9610-631e-5367-9ba9-a26756adcd78', '0a50a529-b923-562d-89ec-69c6b2fdfb57', '08018eff-0ebf-5170-ad3e-0c20593a23a7', '7e9a0266-a9dc-5dc4-b42c-f1347fd3b464', 'db551780-ab3d-5290-9b62-9248a47d7fa4', '76602dc6-6f63-519d-83f9-31709317b2da', 'f2ab30fd-7884-55e5-802c-189ece5de0b1', 'b2286f6c-a94d-59fa-ba01-ae15795549e3', '87836661-3b3d-595e-a60f-3c8bedde6638', '449a2399-61c4-5d25-8df5-7eea9dc40e99', 'ab6a8b42-43a0-5c6f-a020-20704c2cbf7f', '92159343-9a3b-5fe1-8af5-1c43daa5b373', 'c6e1a974-bd58-52c2-a071-de920fab5bd0', '10d716ac-62f7-5f9d-942c-e08046e08ed7', '9b7f8fb4-57b5-5c59-bed0-69fecf00fd43', 'e1039267-3a10-589b-85fc-0db065a7daa3', '21d1e16b-0878-5f8e-afce-43dec6798b08', 'fd6e3caa-e537-5c3f-adda-5a1556c57a6d', 'a64a48b5-b26d-516f-a7f2-6cbeecbe8cc4', 'cb286e5a-dfa3-5a90-afb9-a847bd73b0ea', '891ddddc-5536-5b3e-89e9-4286ace846e4', '1662ae59-73c7-549d-aebe-a4ef3208eab8', '16f4ee00-1594-5486-bae0-6bb6d8081528', '0c5a0a1b-2e65-528f-ad31-3ade387daedb', 'a902c6cc-661e-5ea9-93a9-487d906c26dc', '3eb792ae-cab3-5902-bd3c-9bf513851c9e', 'f9bf0443-0254-5053-a79c-17872c0d11c6', '0d184507-c71e-5de5-bc81-bf165c534654', '8702da84-3821-5640-b849-5c61ba247526', 'e085b399-6414-5256-a382-0e7d930f419b', '397c675d-381d-59a5-a33d-65045d365905', '39c74960-73e4-5888-ba63-ae194d1653ec', '26b4cc51-dfbd-5642-905a-34d5608b355c', 'b7969031-bfe3-5514-b973-eb93e980acc5', 'badc93c3-6abb-5111-8cd4-3f85e455b989', '6f136bbf-bc61-54b4-bc1e-95506ca04bec', '0fc6fca8-b341-5bc3-a242-2d137644f685', '85e718b8-0bc5-58d6-a5b1-41bdf648fd5b', '89ca3898-1f4a-5b09-a41b-984ba2bb41cc', '2e2992bc-55da-56b1-b0a2-df18bdd5189b', '1d2bc7b1-a458-5155-bc4b-b08a8d3a35a7', '822a8d2a-618a-5771-87ac-e53e1333a223', 'a14121ca-678a-5c8e-987a-1b8a11bd9e04', '62b133da-50ff-5d77-b558-6a1b4478a25f', 'e9e0aa94-f4e1-5b7e-a46c-4d6b5845b406', 'a757866d-2fdf-56c7-8878-d3ded93532f4', 'fa4f8462-43a6-5d6e-b292-eaaf225505dc', '98c38e01-f748-5e49-8402-d9d88af108a5', 'a2152692-16c5-5608-ae0b-3663cc73d744', '576b40ef-b5ee-5779-aa48-159131520bdf', '8a5af90d-ada0-5ada-b498-44c6d59dde61', 'f6401c6f-5b5c-5183-bb97-a0b90eb32fd8', '7d0fc865-4e44-5b69-a80d-02842b811ef8', '3c479068-4341-549e-9b45-5d8a5effe0b1', 'faa4c7c8-c7e8-5aac-b2ec-3909b2818e42', 'e1dd7018-e184-53ba-a34f-256150047652', 'b89db3fa-412a-5aa4-8fd4-6fb15e9c2dc5', 'e0c06f68-a7bb-546a-870e-08d83f4ab03e', '3485198b-3a6e-5ad5-adfc-f49282718221', 'da181e56-c4a9-5fac-9af7-95969927a244', 'b32fd641-d599-5434-b5cf-6f798452b5c6', '80939fe0-3d5f-573b-a492-5b6cc9d48c4e', '75afd756-ba8c-555f-8d41-1ec3065aabc7', 'fbd9d38c-1b72-5f35-a0cb-aeb78de190d6', '5c8f7306-2071-5e43-a829-26df27f445ca', '5abdc061-9f62-5de3-8da7-ead62b4fa4d2', 'c1868f24-46fd-5e83-829c-c03f8244cac3', 'a0928b68-13eb-5dcc-86d7-54d26b748e33', '01916016-3d9d-5896-9bf3-50a96719eac7', 'a5196351-3dfa-5164-837a-e02d1f281f4b', '6174ea99-e79b-559c-a482-de8a6e4ced8a', '50c8452c-c117-5f4d-9fc6-ec1633417038', 'b03b4fbe-21b9-5979-bba5-34bcbe06455a', 'b2b38070-27ea-55f0-9844-748122631320', '81c7cd7a-74cf-598f-b9af-db733136ec07', '12a099a0-d83e-5744-8241-510f556b2286', 'ac4c82f9-116c-5a86-b301-4a055c662085', '2b146a81-6889-55b7-8811-a9fa04898993', 'fe89620a-a6dd-502d-b35d-7ac1ed4983c9', '60275106-ec17-5139-bbde-a167f1d6f683', '7c9f4fdd-09a4-5288-b107-ebdd609a9c3d', 'ee4c5f13-e5c2-5ba5-9753-37c8bbe73eac', 'a9548deb-86f4-5119-8549-c92e6be71d95', '18143cd1-5bec-5bc0-bc9b-5d436689b2ca', 'd5ea00af-4184-5544-bfb9-a211f832a557', '211e4808-3e69-59d0-873d-84bda8a40bb2', '3d7feed7-d8bb-56c3-9005-25099a7e3d4d', 'db58c264-1702-50f6-811f-74911b0eed5b', 'bc95538d-76fd-5a2b-bf54-4702be1bb642', 'cadc66a2-1268-5ca1-b534-2691a2e1290e', '22284673-f9af-5094-b405-8f874483c3c5', '59e49d4d-f664-5988-bd9f-c5c9cd70ee5e', 'f88857b3-3015-540b-a6b0-1d2cb35cc5ec', '5d08fa20-d2d7-5b3c-a00e-b052dfdc7c77', 'ceb17ac8-586d-59da-a98e-4e94041b9163', '36c222bd-ea6c-57df-96e3-da22fb3a974a', 'ad4abfec-80fc-52a3-acfa-a71252e0b6a1', 'd519d233-2936-53c9-8b6b-88ea8861fde8', '1b3a6a37-7f8a-5eee-8b45-56bc8875ee7d', '5db28140-4989-5b42-8e20-9f307c9199b5', '51a590a6-a028-59c0-b2ad-15058a720efc', 'bc8ed3cf-f419-5ef7-9dd9-fc79bc642c63', '497cbd34-a4a9-5879-9f58-e4ba1d58c740', '51719a9e-2fe1-5637-afef-0a589725ff36', '3f73b590-9936-53e6-aa80-ac1f11c8de22', '9ff64570-8d12-5c0b-9df7-b1acac27f9b9', 'f831c24a-7751-50a2-bb48-56ac23e737a8', 'd5e31ca7-0792-57d4-b32b-fbabb21c40bc', 'b645543a-88c1-5e11-8ded-f1954d894295', '4e3e2ad5-fcad-54af-ab86-27dbf37af687', 'e2a35f1a-b2ea-5020-abe0-e0e4328def25', 'b9735751-6bac-50d2-abe0-65c56fdf1ecd', 'fa3de516-cc3e-5c6f-a2e0-2184a97dab92', '359df85c-4a0b-533d-b8e3-c7c248effe5b', '97d11cfc-4ce5-5fea-8e7f-b498e5aede5d', 'a13a15ce-f508-5727-84c6-10a906b8e7f5', '8596801d-3e01-506a-ba05-87205008983c', 'f752f717-3858-5672-b008-e5715cfc7749', 'f3e3c555-76cc-5f39-a356-d885fb247998', '496e1016-e5d7-578f-874b-1feb326ebe0e', '9dd1810e-9d57-58be-a42f-9a36cf726f30', 'fd4ddb54-9879-53c6-95ce-9f92ea7fee38', '0683a981-34db-52f9-a048-5bc9e6c5590f', 'e320b774-b712-5cb5-acc8-66a9962fad3e', 'e944f329-9a0f-5d61-b4f7-3e41d620b4eb', 'a5864d00-d1bb-51d0-9b43-eaa47c0717fc', '84f90dbf-8c18-5f2e-a2d3-eae7cbe9e9db', '8dec583a-e65c-57f7-bf42-f1f53d115296', 'bc5d79a6-270a-5d43-b157-c03acfcf3e15', '9ed9c258-92e9-55cf-bbba-d4d3e38aa722', 'f340c2ca-02df-5855-87cd-2c126efe457c', '31cdf54a-964f-5342-b50f-af0804b9d8a1', '06836d57-88af-56ff-96a9-0fd5b5cd735a', '9e4a41a4-7dfb-52f4-baef-f7ecd5a79706', '279ed419-928a-5674-8bb0-514779655a25', 'bcc98ec6-7879-5e8c-bf0d-b71c6c33da31', 'd8aa21ad-48d2-5ffe-8d28-5ce68cb49aee', '060f2f5f-20e4-5448-9298-2d1405b3de2a', 'd84b209a-6be7-5c12-88ff-5ccf23b8276a', 'b219dd71-2a07-58bd-8a10-69b7210bae41', '14fe9ecd-fa80-53fd-929c-271d4cc51cc2', '00755552-c112-5956-a515-0917e4cad61a', 'ed1f201b-b7da-5764-9b62-15af565a43f1', '615eef54-4185-549d-a99e-25a128065ff5', 'ec5f10dd-c4cb-5023-938e-c10ad9718358', '21b51f5f-34c1-554a-b773-8f8f8570cb93', 'dbdb483b-3b9e-5254-900a-85ac3edbceb5', '9491a138-caca-5378-921c-8dceb9e07119', 'd8b9e795-e6bd-5ec5-a0e0-1e8bb7ed9562', '4deeb9d4-b102-5aba-b8e5-70493bcd19b2', 'cc4a4f21-0379-5da9-b3eb-9bad5c63739f', '1687c79c-8930-5fb0-910b-bef4ed34d3a8', 'd0b9810e-c5a6-5684-bbd7-fe3b8102ef02', 'd36e2fcb-ef6b-5007-9aa8-0a3a5b332eef', 'e1504b14-6644-5931-808b-97ea5d9bf4dd', '65356c97-96d9-5bdc-9cf0-2e188f15204d', '77cedae4-c5f0-5068-857d-8fd96f6bd3a0', '2e264f50-ff08-5855-b9cf-55dda660e9db', 'ddfce6cd-24e1-5ff5-8465-de9fa5bf6106', '31136d20-537c-578b-84ae-fa9600458e75', '6022c05a-d7b8-598a-a8f2-b190a17ad989', '378c85be-48e1-55db-b21d-e44a92ba4547', '49b663e7-1e6b-58aa-ae17-531e1ce44e8a', 'd3f2f9fc-4652-520e-bc3d-b0a1956dfd34', '4baab743-c1b1-59fa-8beb-a02bca286ce0', 'f646ceb2-51d5-567b-9f19-abe386ec1fa3', 'ee8d75c4-8d0b-507e-9415-4d19d71728d1', 'a73b00a5-82d3-59fb-8309-c95df4ee5f93', '0d4b06a5-af6e-5a76-9eaf-fbe38d602e31', '116f475b-dc7f-5c34-ba20-efdaf9f9e30d', '7c0f3750-4798-5429-96ac-60c9b018ba2a', '3e29e2a8-9ed2-5683-b344-f973724369c5', 'e3c5a540-2903-57d5-a004-15e79acf40d7', 'b7938454-a22d-5c16-b242-430b5a1164e4', '76f05ca8-1957-59e9-a559-3c031a0401b8', '2f37ab81-ea26-5d1c-9eff-08e159ac91f1', 'c27f6db0-008e-52ab-ab4d-f853de1deac5', 'bfa4071e-1b65-58a3-b363-75131bdd7670', '8d2dfef5-21b8-5db2-92ea-e80fa480d97e', 'c48d7448-fd90-5e80-aab8-b46196ede091', 'c015d7fd-4c32-5645-b724-b7d35950e14c', '91cee77e-bedc-57d4-b8b4-92603c66352e', '5957ee3f-41fa-5e2a-9f12-bacad6c96ff3', '7d4f010c-41e3-551e-8270-b6a6a39280f9', '67973c24-51e6-5526-ae26-f5980d0284c4', '2453d295-b1ec-570b-a033-bb8eb937fad0', '9132585d-e74c-5649-997b-1ad17dec9d6d', '1cc266b1-133e-5e13-b912-18cc07002638', '676ddf59-8b5a-5069-bd95-41e01a71d841', '924f8d6e-54a3-5e11-897c-df269e1fbd32', '318b656e-bf40-5469-a98b-00a6f13c11eb', 'a8805b91-069c-585e-8a81-4d8f6a700956', '964151d5-2cbf-5738-99a2-fcb839e844bd', '4082448d-d9d6-5652-9941-807f5a84fcc4', 'd8f17327-cbda-585b-920b-ab22fb84538d', '95705cc2-7072-5396-87a5-2eaff4b5e63e', 'bffc97ac-160e-5635-af6c-a9420bf3803a', '11a5b779-872f-5ca7-81d5-9d0c22034c19', '2dd1e87f-f351-5559-a771-f79a4313ec99', '564e2b40-88bd-5442-8480-c444da4a7c4f', '8c3b817d-d00a-5929-ad46-03614d61a82a', '9d03fac9-faa4-53ed-8711-bb89c03313cd', '423f097a-4a17-590c-80f1-f1c838922488', '845ca028-247c-5006-b278-c6d5666db089', '0dcd134b-5565-59cc-871e-58a9d9bc87d1', '2f62da3d-6a2b-5c07-b7ef-2914b7be1753', 'eefbe079-463b-5e32-b707-4c1a4e5abce6', '14adeb4f-5449-5275-9535-8c69e778926e', 'ed171ab6-bcc7-5f86-b98a-cde03fc66400', '993dbeb8-fece-5738-863b-0829deac1d02', '320d778d-3e13-583c-8510-57eec36784cf', 'cad81b72-d40c-56a0-982b-9575ed26bef0', 'cbb6f500-20b1-5a05-a9b1-aed670509738', '846dde04-8b18-54d8-a340-28da03ff46d1', '1ebd9d2b-887b-509a-913f-ce089968dbc2', '12934e6c-a55d-5f96-b916-44f8a1254f79', '3c38c768-02a6-512e-b8af-641fb32de24c', 'ab645903-0ffa-50ec-aa32-4b21c65a2d7c', '1b3f3621-3983-57d8-9f96-4fa6c333eacb', '6dd75cd6-264c-5c9f-a873-a3bfe00b5256', 'c4597cfa-cf18-5780-abf8-181bc25b3f53', 'd9f10875-b71d-5134-bbd1-b3c13c47b67b', '7e3c4329-bc42-5f08-8a34-a586588b6d63', 'c1dc1f6c-df4a-561f-8879-d63a8ab1bd36', '859b48cc-64ac-560f-8b6f-22edad7a23e0', 'bb0c62ee-12cd-568b-9d68-0c5b331b1bee', '69f866c1-c541-51f4-9d7c-29ce8dc1d250', 'c40f40c6-9ada-5597-b1c3-1fea246cb5cd', '824b1ee2-b146-5089-968c-56494a747ba8', '025a54a5-1b47-5d3e-9918-1d3471d7ae58', '7af01fc5-3fe0-5a7c-b1b3-b270ff59e6df', '4e5e3da5-8f7d-5a19-97a2-090059271a96', 'd09e8ae9-5028-5e8f-b987-76c77d712ba5');
DELETE FROM public.chapters c WHERE c.subject_id = 'sciences-vie-terre-7eme' AND c.id NOT IN ('b996e1b4-c072-5d2d-81ed-0e4e73b03188', 'daaff8ab-c8e6-5332-bace-bd5469068bae', 'b9317620-40d6-5ef6-bc46-2b15221977ae', '0b434af5-07f7-5b82-956d-9e708a6aeac8', 'cfc76b85-e661-5d71-8c1f-a21e37b1203a', '35d2091c-3f14-51af-a0d7-25db354cc4f2', 'c3418051-d92b-590b-8e89-ae540df41bcc') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('b996e1b4-c072-5d2d-81ed-0e4e73b03188', 'sciences-vie-terre-7eme', 'مكوّنات الوسط البيئي', 'التمييز بين الكائنات الحيّة وغير الحيّة، تعريف الوسط البيئي (العناصر غير الحية ومجموع الكائنات الحية)، تصنيف النباتات حسب الحجم (أعشاب، شجيرات، أشجار)، الحيوانات والكائنات الدقيقة، العوامل المناخية غير الحيّة (الحرارة، الأمطار، الرياح، الرطوبة)، وتوزّع الكائنات الحيّة حسب عوامل الوسط', '# 🌍 مكوّنات الوسط البيئي

> 💡 «كلّ كائن يعيش في مكانٍ يمنحه ما يحتاجه: هذا المكان هو وسطه البيئي.»

حولك في القسم، في الحديقة، أو في الغابة، تجد أشياء متنوّعة: نباتات، حيوانات، حجارة، ماء، هواء… بعضها **حيّ** وبعضها **غير حيّ**. معرفة الفرق بينها هي أوّل خطوة لفهم أيّ وسط بيئي.

## 🌱 الكائنات الحيّة والكائنات غير الحيّة

**الكائن الحيّ** جسمٌ يقوم بوظائف حيوية معيّنة في آنٍ واحد: يتنفّس، ويتغذّى، وينمو، وقادر على التكاثر، ويتفاعل مع محيطه. مثال: _شجرة الزيتون تتنفّس عبر أوراقها، وتتغذّى من التربة والضوء، وتنمو سنةً بعد أخرى_.

**الجسم غير الحيّ** لا يقوم بهذه الوظائف مجتمعةً: الصخرة، الماء، الهواء، التربة أجسامٌ غير حيّة رغم وجودها في نفس المكان.

> ⚠️ لا يكفي أن يتحرّك جسمٌ أو أن يتغيّر حجمه ليكون حيًّا: **النار** تتحرّك وتنتشر، و**البلّورة** تكبر شيئًا فشيئًا، لكن لا واحدة منهما تتنفّس أو تتغذّى أو تتكاثر — فهما غير حيّتين.

## 🏞️ تعريف الوسط البيئي

**الوسط البيئي** هو المكان الذي تعيش فيه الكائنات الحيّة، ويتكوّن من عنصرين متكاملين:

- **العناصر غير الحية للوسط**: التربة، الماء، الهواء، الضوء، والمناخ. وهذا ما يُسمّى علميًّا **الوسط الفيزيائي (biotope)**.
- **مجموع الكائنات الحيّة**: كلّ النباتات والحيوانات والكائنات الدقيقة التي تعيش في هذا المكان معًا. وهذا ما يُسمّى علميًّا **مجموعة الكائنات الحيّة (biocénose)**.

> 🗡️ لا وجود لوسط بيئي بدون العنصرين معًا: عناصر غير حية بلا كائنات حيّة تبقى مكانًا فارغًا، وكائنات حيّة بلا عناصر غير حية (ماء، هواء، تربة) لا يمكن أن تعيش.

## 🌿 النباتات: تصنيف حسب الحجم

::: figure تُصنَّفُ النباتاتُ حسب الحجم ونوع الساق: عشبٌ طريّ، شجيرةٌ ذاتُ سيقانٍ خشبيّة، وشجرةٌ ذاتُ جذعٍ واحد
<svg viewBox="0 0 340 175"><path d="M20 132 H320" stroke="#a16207" stroke-width="2.5"/><path d="M56 132 q-2.4000000000000004 -18 -1.7999999999999998 -30" fill="none" stroke="#22c55e" stroke-width="2.4"/><path d="M62 132 q0.0 -18 0.0 -30" fill="none" stroke="#22c55e" stroke-width="2.4"/><path d="M68 132 q2.4000000000000004 -18 1.7999999999999998 -30" fill="none" stroke="#22c55e" stroke-width="2.4"/><ellipse cx="54" cy="102" rx="6" ry="3" fill="#16a34a"/><ellipse cx="70" cy="106" rx="6" ry="3" fill="#16a34a"/><text x="62.0" y="150.0" text-anchor="middle" font-size="13" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">عُشب</text><text x="62.0" y="166.0" text-anchor="middle" font-size="9" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">طريّ، قصير</text><path d="M168 132 Q159.6 102 154 74" fill="none" stroke="#92400e" stroke-width="3"/><circle cx="154" cy="72" r="12" fill="#34d399" stroke="#15803d" stroke-width="1.5"/><path d="M168 132 Q168.0 102 168 74" fill="none" stroke="#92400e" stroke-width="3"/><circle cx="168" cy="72" r="12" fill="#34d399" stroke="#15803d" stroke-width="1.5"/><path d="M168 132 Q176.4 102 182 74" fill="none" stroke="#92400e" stroke-width="3"/><circle cx="182" cy="72" r="12" fill="#34d399" stroke="#15803d" stroke-width="1.5"/><text x="168.0" y="150.0" text-anchor="middle" font-size="13" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">شُجيرة</text><text x="168.0" y="166.0" text-anchor="middle" font-size="9" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">خشبيّة، عدّة سيقان</text><path d="M280 132 V76" stroke="#92400e" stroke-width="7"/><circle cx="280" cy="54" r="26" fill="#16a34a" stroke="#15803d" stroke-width="2"/><text x="280.0" y="150.0" text-anchor="middle" font-size="13" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">شَجرة</text><text x="280.0" y="166.0" text-anchor="middle" font-size="9" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">جذعٌ واحدٌ بارز</text><text x="170.0" y="20.0" text-anchor="middle" font-size="12" font-weight="700" fill="#334155" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">تُصنَّفُ النباتاتُ حسب حجمها ونوع ساقها</text></svg>
:::

لا تُصنَّف النباتات حسب لونها أو مكان وجودها، بل حسب **حجمها ونوع ساقها**:

| الصنف        | الساق                               | الحجم                       | مثال تونسي               |
| ------------ | ----------------------------------- | --------------------------- | ------------------------ |
| **الأعشاب**  | طريّة (غضّة)، غير خشبية             | قصيرة (أقلّ من متر عادةً)   | القمح، البرسيم           |
| **الشجيرات** | خشبية، عدّة سيقان تتفرّع من القاعدة | متوسّطة الحجم               | الدفلة، إكليل الجبل      |
| **الأشجار**  | خشبية، ساق رئيسية واحدة (جذع) بارزة | كبيرة، قد تتجاوز عدّة أمتار | الصنوبر، البلّوط الفليني |

> ⚠️ الفرق بين الشجيرة والشجرة ليس الطول فقط، بل عدد السيقان: للشجيرة عدّة سيقان خشبية تنطلق من الأرض مباشرةً، بينما للشجرة جذعٌ رئيسيّ واحد تتفرّع منه الأغصان في الأعلى.

## 🐾 الحيوانات والكائنات الدقيقة

يضمّ الوسط البيئي أيضًا صنفين من الكائنات الحيوانية:

- **حيوانات ظاهرة**: تُرى بالعين المجرّدة دون أداة، مثل الطيور، والحشرات، والثدييات، والزواحف.
- **كائنات دقيقة**: لا تُرى إلّا باستعمال **المجهر**، مثل البكتيريا وبعض الفطريات المجهرية. توجد بأعداد هائلة في التربة والماء والهواء رغم أنّها غير مرئية.

> 🔮 صغر حجم الكائن لا يعني أنّه أقلّ أهمّية: الكائنات الدقيقة تلعب أدوارًا أساسية في الوسط البيئي رغم عدم رؤيتها.

## 🌡️ العوامل غير الحيّة: المناخ

من أهمّ العناصر غير الحية للوسط البيئي **العوامل المناخية**، وهي أربعة:

- **الحرارة**: تتغيّر حسب الفصل والموقع الجغرافي، وتؤثّر في نشاط الكائنات.
- **الأمطار (التساقطات)**: كمّية الماء المتساقطة سنويًّا؛ تحدّد وفرة النباتات وكثافتها.
- **الرياح**: تنقل الرطوبة أو الجفاف، وتؤثّر في تبخّر الماء من التربة والنباتات.
- **الرطوبة**: نسبة بخار الماء في الهواء أو في التربة.

هذه العوامل الأربعة تتغيّر من منطقة إلى أخرى، فتُنتج أوساطًا بيئية مختلفة تمامًا.

## 🗺️ توزّع الكائنات الحيّة حسب عوامل الوسط

لا تعيش كلّ الكائنات في كلّ مكان: كلّ كائن يحتاج مزيجًا معيّنًا من الحرارة والماء والرطوبة ليعيش فيه. قارن بين ثلاثة أوساط تونسية:

| الوسط              | الحرارة والأمطار                        | كائنات ملائمة له                        |
| ------------------ | --------------------------------------- | --------------------------------------- |
| **غابة عين دراهم** | حرارة معتدلة، أمطار غزيرة، رطوبة عالية  | البلّوط الفليني، السرخس، الخنزير البرّي |
| **الواحة**         | حرارة مرتفعة، أمطار نادرة جدًّا، جفاف   | نخيل التمر، الجمل، نباتات تتحمّل الجفاف |
| **الساحل**         | حرارة معتدلة، رياح بحرية، رطوبة متوسّطة | نباتات تتحمّل الملوحة، طيور بحرية       |

> 🗡️ إذا تغيّرت عوامل الوسط (قلّت الأمطار مثلًا)، يتغيّر توزّع الكائنات الحيّة فيه: تختفي الكائنات غير الملائمة وتستقرّ كائنات أخرى أكثر تحمّلًا.

> 🏆 تعرّفت الآن على مكوّنات أيّ وسط بيئي: عناصره غير الحية وكائناته الحيّة، وكيف تتوزّع هذه الكائنات حسب عوامل المناخ. في الفصل القادم ستكتشف كيف تتفاعل هذه الكائنات فيما بينها!', '# 📜 ملخّص: مكوّنات الوسط البيئي

- **الكائن الحيّ**: يتنفّس، يتغذّى، ينمو، يتكاثر (النار والبلّورة تتحرّك/تكبر لكنّها **غير حيّة**).
- **الوسط البيئي** = **العناصر غير الحية (biotope)**: تربة، ماء، هواء، مناخ + **مجموع الكائنات الحيّة (biocénose)**: كلّ النباتات والحيوانات معًا.
- **النباتات حسب الحجم**: **أعشاب** (ساق طريّة، قصيرة) / **شجيرات** (ساق خشبية، عدّة سيقان من القاعدة) / **أشجار** (جذع رئيسيّ واحد، كبيرة).
- **الحيوانات**: **ظاهرة** (تُرى بالعين المجرّدة) و**كائنات دقيقة** (تُرى بالمجهر فقط: بكتيريا، فطريات مجهرية).
- **العوامل المناخية غير الحية**: الحرارة، الأمطار (التساقطات)، الرياح، الرطوبة.
- **توزّع الكائنات**: كلّ كائن يلائم عوامل وسطه؛ مثال: غابة عين دراهم (رطبة) ≠ الواحة (جافة) ≠ الساحل (رطوبة معتدلة ورياح بحرية).', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('daaff8ab-c8e6-5332-bace-bd5469068bae', 'sciences-vie-terre-7eme', 'التنفّس عند الكائنات الحية', 'التبادلات الغازية التنفّسية (امتصاص الأكسجين وطرح ثاني أكسيد الكربون) بين الكائن الحيّ ووسطه، التنفّس في الوسط الهوائي بالرئتين عند الفقاريات وبالقصبات الهوائية عند الحشرات، التنفّس في الوسط المائي بالخياشيم، وتجربة بسيطة تبيّن التبادلات الغازية التنفّسية', '# 🫁 التنفّس عند الكائنات الحية

> 💡 «في كلّ لحظة، من قلب الغابة إلى قاع البحر، يتبادل كلّ كائن حيّ الهواء أو الماء مع وسطه ليبقى حيًّا.»

تعرّفت في الفصل السابق على الوسط البيئي وعلى أنّ **التنفّس** إحدى الوظائف الحيوية التي تميّز الكائن الحيّ عن الجسم غير الحيّ، إلى جانب التغذية والنموّ والتكاثر. في هذا الفصل ستكتشف كيف يتنفّس كلّ كائن حسب الوسط الذي يعيش فيه: هوائيًّا كان أم مائيًّا.

## 💨 التبادلات الغازية التنفّسية

**التنفّس** عملية مستمرّة ودائمة يقوم بها كلّ كائن حيّ، نباتًا كان أو حيوانًا، طوال حياته. تتمثّل هذه العملية في **تبادل غازي** بين الكائن الحيّ ووسطه، وله اتّجاهان ثابتان لا يتغيّران:

- **امتصاص الأكسجين (O₂)** من الوسط (الهواء أو الماء) إلى داخل جسم الكائن الحيّ.
- **طرح ثاني أكسيد الكربون (CO₂)** من جسم الكائن الحيّ إلى الوسط.

> ⚠️ الخطأ الشائع هو عكس الاتّجاهين: الكائن الحيّ **يمتصّ** الأكسجين و**يطرح** ثاني أكسيد الكربون، وليس العكس أبدًا، مهما كان الوسط أو العضو التنفّسي المستعمل.

يختلف **العضو التنفّسي** المسؤول عن هذا التبادل من كائن إلى آخر حسب وسط عيشه: رئتان أو قصبات هوائية في الوسط الهوائي، وخياشيم في الوسط المائي.

## 🏔️ التنفّس في الوسط الهوائي عند الفقاريات: الرئتان

الحيوانات الفقارية التي تعيش على اليابسة (كالثدييات والطيور والزواحف)، مثل **الأرنب** و**الحمامة** و**الأفعى**، تتنفّس بواسطة **رئتين**. يسلك الهواء المسار التالي: يدخل عبر الأنف أو الفم، فالقصبة الهوائية، فالأنابيب الشعبية، وصولًا إلى الرئتين.

<svg viewBox="0 0 300 275">
<title>مسار الهواء في رئتَي الفقاري: الأنف/الفم ← القصبة الهوائية ← الأنابيب الشعبية ← الرئتان</title>
<ellipse cx="96" cy="195" rx="34" ry="46" fill="#fde2e4" stroke="#0f172a" stroke-width="2"/><ellipse cx="204" cy="195" rx="34" ry="46" fill="#fde2e4" stroke="#0f172a" stroke-width="2"/><line x1="144" y1="62" x2="144" y2="128" stroke="#0f172a" stroke-width="2"/><line x1="156" y1="62" x2="156" y2="128" stroke="#0f172a" stroke-width="2"/><line x1="146" y1="126" x2="100" y2="168" stroke="#0f172a" stroke-width="2.5"/><line x1="154" y1="126" x2="200" y2="168" stroke="#0f172a" stroke-width="2.5"/><polygon points="128,40 172,40 166,62 134,62" fill="#fef3c7" stroke="#0f172a" stroke-width="2"/><line x1="112" y1="20" x2="132" y2="48" stroke="#2563eb" stroke-width="2.5"/>
<polygon points="132,48 123.11,43.29 130.43,38.06" fill="#2563eb"/><line x1="168" y1="48" x2="188" y2="20" stroke="#ef4444" stroke-width="2.5"/>
<polygon points="188,20 186.43,29.94 179.11,24.71" fill="#ef4444"/><line x1="160" y1="95" x2="176" y2="92" stroke="#64748b" stroke-width="1.2"/><line x1="178" y1="150" x2="190" y2="152" stroke="#64748b" stroke-width="1.2"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="150" y="34" text-anchor="middle" fill="#0f172a" font-size="12">الأنف / الفم</text><text x="222" y="92" text-anchor="middle" fill="#0f172a" font-size="11">القصبة الهوائية</text><text x="232" y="150" text-anchor="middle" fill="#0f172a" font-size="11">الأنابيب الشعبية</text><text x="96" y="258" text-anchor="middle" fill="#0f172a" font-size="12">الرئتان</text><text x="204" y="258" text-anchor="middle" fill="#0f172a" font-size="12">الرئتان</text><text x="95" y="16" text-anchor="middle" fill="#2563eb" font-size="13">O₂</text><text x="95" y="30" text-anchor="middle" fill="#2563eb" font-size="10">دخول</text><text x="205" y="16" text-anchor="middle" fill="#ef4444" font-size="13">CO₂</text><text x="205" y="30" text-anchor="middle" fill="#ef4444" font-size="10">خروج</text></g>
</svg>

داخل الرئتين يحدث التبادل الغازي: يمتصّ الدمّ الأكسجين من الهواء الداخل، ويطرح ثاني أكسيد الكربون فيه ليخرج مع الزفير. تتكرّر هذه الدورة في حركتين متعاقبتين:

- **الشهيق**: دخول هواء غنيّ بالأكسجين إلى الرئتين.
- **الزفير**: خروج هواء غنيّ بثاني أكسيد الكربون من الرئتين.

> 🗡️ لا يفرغ الزفير الرئتين من كلّ الأكسجين: يبقى فيه أكسجين، لكنّ نسبة ثاني أكسيد الكربون فيه أعلى ممّا في هواء الشهيق.

## 🐝 التنفّس في الوسط الهوائي عند الحشرات: القصبات الهوائية

الحشرات، مثل **النحلة** و**الجرادة** و**النملة**، تعيش أيضًا في الوسط الهوائي، لكنّها **لا تملك رئتين**. تتنفّس بواسطة جهاز مختلف تمامًا يُسمّى **القصبات الهوائية**: شبكة من الأنابيب الدقيقة المتفرّعة داخل جسم الحشرة.

يدخل الهواء إلى هذه القصبات عبر فتحات صغيرة موجودة على جانبي جسم الحشرة تُسمّى **الثغور التنفّسية**، ثمّ يتوزّع مباشرة داخل القصبات المتفرّعة حتّى يصل إلى مختلف أعضاء الجسم، حيث يحدث التبادل الغازي: امتصاص الأكسجين وطرح ثاني أكسيد الكربون الذي يخرج بدوره عبر الثغور التنفّسية نفسها.

| العضو التنفّسي       | الكائن                      | كيف يدخل الهواء؟                              |
| -------------------- | --------------------------- | --------------------------------------------- |
| **الرئتان**          | فقاريات (أرنب، حمامة، أفعى) | أنف/فم ← قصبة هوائية ← رئتان                  |
| **القصبات الهوائية** | حشرات (نحلة، جرادة)         | ثغور تنفّسية على جانبَي الجسم ← قصبات متفرّعة |

> ⚠️ لا تخلط بين **القصبة الهوائية** (أنبوب واحد يصل الفم بالرئتين عند الفقاريات) و**القصبات الهوائية** (شبكة أنابيب متفرّعة داخل جسم الحشرة كلّه، بلا رئتين إطلاقًا).

## 🐟 التنفّس في الوسط المائي: الخياشيم

الحيوانات التي تعيش في الوسط المائي، كالأسماك، لا تستطيع استعمال رئتين لأنّ الأكسجين هناك **مذاب في الماء** لا في الهواء. لذلك تتنفّس بواسطة **الخياشيم**: عضو تنفّسي رقيق مكوّن من صفائح كثيرة الأوعية الدموية، يوجد على جانبَي رأس السمكة تحت **الغطاء الخيشومي**.

يدخل الماء عبر فم السمكة، يمرّ فوق الخياشيم حيث يُمتصّ الأكسجين المذاب فيه إلى الدم ويُطرح ثاني أكسيد الكربون منه إلى الماء، ثمّ يخرج الماء عبر فتحات الخياشيم. تعتمد هذه الآلية على تجدّد الماء باستمرار فوق الخياشيم.

من الأسماك التي تعيش في مياه البحر الأبيض المتوسّط قبالة السواحل التونسية وتتنفّس بالخياشيم: **القاروس** (البلامي)، **الدنيس**، **السردين**، **التونة**.

> 🔮 خلال نموّها، يتغيّر العضو التنفّسي عند بعض البرمائيات مع تغيّر وسطها: شرغوف الضفدع يعيش في الماء ويتنفّس بخياشيم، أمّا الضفدع البالغ فيغادر الماء ويتنفّس برئتين. العضو التنفّسي إذن يلائم الوسط، لا نوع الكائن وحده.

## 🧪 تجربة بسيطة تبيّن التبادلات الغازية التنفّسية

للتحقّق عمليًّا من أنّ كائنًا حيًّا يطرح فعلًا ثاني أكسيد الكربون، يمكن إنجاز تجربة بسيطة:

1. نضع عدّة حشرات حيّة (مثلًا جرادات) داخل وعاء مغلق يحتوي على أنبوب فيه **ماء الجير الرائق** (سائل شفّاف).
2. نُعِدّ وعاءً ثانيًا مماثلًا تمامًا لكن **بدون** حشرات، يُسمّى **الشاهد**، لمقارنة النتيجتين.
3. بعد مدّة قصيرة، نلاحظ أنّ ماء الجير في الوعاء الذي يحوي الحشرات **يتكدّر** (يصبح أبيض عكرًا)، بينما يبقى ماء الجير في وعاء الشاهد **رائقًا** كما هو.

> ✓ تكدّر ماء الجير دليل قاطع على وجود ثاني أكسيد الكربون؛ إذ يتفاعل معه فيفقد شفافيته. بقاء ماء الجير رائقًا في وعاء الشاهد يثبت أنّ التكدّر في الوعاء الأوّل سببه الحشرات وحدها، وهذا يؤكّد أنّ الكائن الحيّ يطرح ثاني أكسيد الكربون أثناء تنفّسه.

> 🏆 أتقنت الآن التبادلات الغازية التنفّسية وكيف يتكيّف العضو التنفّسي مع الوسط: رئتان أو قصبات هوائية في الهواء، خياشيم في الماء. في الفصل القادم ستكتشف وظيفة حيوية أخرى: التغذية عند الكائنات الحيّة!', '# 📜 ملخّص: التنفّس عند الكائنات الحية

- **التبادلات الغازية التنفّسية**: كلّ كائن حيّ **يمتصّ الأكسجين (O₂)** من وسطه و**يطرح ثاني أكسيد الكربون (CO₂)** فيه، والاتّجاهان ثابتان دائمًا.
- **التنفّس بالرئتين**: الفقاريات البرّية (أرنب، حمامة، أفعى) تتنفّس برئتين؛ الهواء: أنف/فم ← قصبة هوائية ← رئتان، بحركتَي الشهيق (دخول أكسجين) والزفير (خروج ثاني أكسيد الكربون).
- **التنفّس بالقصبات الهوائية**: الحشرات (نحلة، جرادة، نملة) لا رئة لها؛ يدخل الهواء من الثغور التنفّسية إلى شبكة قصبات متفرّعة توصله مباشرة إلى أعضاء الجسم.
- **التنفّس بالخياشيم**: الأسماك (القاروس، الدنيس، السردين، التونة) تمتصّ الأكسجين المذاب في الماء عبر الخياشيم الموجودة تحت الغطاء الخيشومي؛ العضو يلائم الوسط لا نوع الكائن وحده (شرغوف مائي بخياشيم ← ضفدع بالغ برّي برئتين).
- **تجربة الكشف بماء الجير**: تكدّر ماء الجير الرائق حول كائن حيّ (مقارنةً بوعاء شاهد يبقى رائقًا) دليل على أنّه يطرح ثاني أكسيد الكربون.', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('b9317620-40d6-5ef6-bc46-2b15221977ae', 'sciences-vie-terre-7eme', 'التّغذية عند النّبات الأخضر', 'الحاجيات الغذائية للنّبات الأخضر (الماء، الأملاح المعدنية، ثاني أكسيد الكربون، الضّوء)، الامتصاص الجذريّ للماء والأملاح المعدنية، تركيب المادّة العضويّة بالتركيب الضّوئيّ بفضل الضّوء والكلوروفيل، والنّبات الأخضر كائن منتج', '# 🌿 التّغذية عند النّبات الأخضر — كيف يصنع النّبات غذاءه بنفسه؟

> 💡 «لا يبحث النّبات الأخضر عن غذائه جاهزًا كما يفعل الحيوان، بل يصنعه بنفسه من موادّ بسيطة يأخذها من التّربة والهواء والضّوء.»

اكتشفت في الفصل السّابق كيف تتنفّس الكائنات الحيّة. في هذا الفصل ستكتشف وظيفة حيويّة أخرى: **التّغذية عند النّبات الأخضر**، وهي مختلفة تمامًا عن تغذية الحيوان أو الإنسان، لأنّ النّبات الأخضر يصنع مادّته العضويّة بنفسه انطلاقًا من موادّ بسيطة غير عضويّة.

## 🌍 الحاجيات الغذائية للنّبات الأخضر

لكي ينمو النّبات الأخضر ويعيش، يحتاج إلى أربع حاجيات أساسيّة يأخذها من وسطه:

- **الماء**: يمتصّه النّبات من التّربة.
- **الأملاح المعدنية**: موادّ ذائبة في ماء التّربة، ضروريّة لنموّ النّبات.
- **ثاني أكسيد الكربون (CO₂)**: غاز يأخذه النّبات من الهواء المحيط به.
- **الضّوء**: طاقة ضروريّة، غالبًا ضوء الشّمس.

> ⚠️ الخطأ الشّائع هو الاكتفاء بذكر الماء والضّوء فقط، ونسيان الأملاح المعدنية أو ثاني أكسيد الكربون. الحاجيات الأربع كلّها ضروريّة معًا، ولا يمكن الاستغناء عن واحدة منها.

## 🌱 الامتصاص الجذريّ: الماء والأملاح المعدنية

يمتصّ النّبات الماء والأملاح المعدنية الذائبة فيه من التّربة بواسطة **جذوره**، في عمليّة تُسمّى **الامتصاص الجذريّ**. فمثلًا، تمتدّ جذور **شجرة الزّيتون** عميقًا في التّربة لتمتصّ منها الماء والأملاح المعدنية اللّازمة لنموّها، حتّى في فصول الجفاف.

يصعد الماء والأملاح المعدنية الممتصّة من الجذور إلى بقيّة أعضاء النّبات (السّاق ثمّ الأوراق) عبر مسار داخليّ في النّبات.

> 🗡️ في **الواحات** التّونسية، تمتصّ جذور **نخيل التّمر** الماء من طبقات عميقة في التّربة قريبة من الماء الجوفيّ، وهذا ما يفسّر قدرة النّخيل على العيش رغم قلّة الأمطار.

## 🍃 امتصاص ثاني أكسيد الكربون من الهواء

بالإضافة إلى الماء والأملاح المعدنية، يحتاج النّبات إلى **ثاني أكسيد الكربون (CO₂)**، وهو غاز موجود في الهواء المحيط بالنّبات. تمتصّ **أوراق** النّبات هذا الغاز من الهواء مباشرة، على عكس الماء والأملاح المعدنية اللّذين يُمتصّان من التّربة بواسطة الجذور.

> ⚠️ لا تخلط بين الامتصاص الجذريّ (ماء وأملاح معدنية، من التّربة، بواسطة الجذور) وامتصاص ثاني أكسيد الكربون (من الهواء، بواسطة الأوراق): مصدران مختلفان وعضوان مختلفان.

## ☀️ الضّوء والكلوروفيل: صانعا المادّة العضويّة

يحتوي النّبات الأخضر في أوراقه على صبغة خضراء تُسمّى **الكلوروفيل**، وهي الّتي تمنح الأوراق لونها الأخضر. يلتقط الكلوروفيل طاقة الضّوء ويستعملها لتركيب **مادّة عضويّة** انطلاقًا من الماء والأملاح المعدنية (الممتصّة من التّربة) وثاني أكسيد الكربون (الممتصّ من الهواء). تُسمّى هذه العمليّة **التركيب الضّوئيّ**، وتحدث في الأوراق الخضراء نهارًا فقط، إذ تتوقّف بغياب الضّوء. ينتج عن التركيب الضّوئيّ أيضًا **الأكسجين (O₂)**، وهو غاز يطرحه النّبات نحو الهواء المحيط به.

<svg viewBox="0 0 300 300">
<title>التركيب الضوئي: الجذور تمتصّ الماء والأملاح المعدنية، الأوراق تمتصّ CO₂ تحت الضوء وتطرح O₂ وتنتج مادّة عضويّة</title>
<rect x="0" y="205" width="300" height="95" fill="#f1e3d3" stroke="none" stroke-width="2"/><line x1="0" y1="205" x2="300" y2="205" stroke="#0f172a" stroke-width="2"/><path d="M6 205 L-2 213 M22 205 L14 213 M38 205 L30 213 M54 205 L46 213 M70 205 L62 213 M86 205 L78 213 M102 205 L94 213 M118 205 L110 213 M134 205 L126 213 M150 205 L142 213 M166 205 L158 213 M182 205 L174 213 M198 205 L190 213 M214 205 L206 213 M230 205 L222 213 M246 205 L238 213 M262 205 L254 213 M278 205 L270 213 M294 205 L286 213" stroke="#b08968" stroke-width="1.4"/><circle cx="46" cy="46" r="20" fill="#fde68a" stroke="#d97706" stroke-width="2"/><line x1="68" y1="46" x2="77" y2="46" stroke="#d97706" stroke-width="2"/><line x1="61.56" y1="61.56" x2="67.92" y2="67.92" stroke="#d97706" stroke-width="2"/><line x1="46" y1="68" x2="46" y2="77" stroke="#d97706" stroke-width="2"/><line x1="30.44" y1="61.56" x2="24.08" y2="67.92" stroke="#d97706" stroke-width="2"/><line x1="24" y1="46" x2="15" y2="46" stroke="#d97706" stroke-width="2"/><line x1="30.44" y1="30.44" x2="24.08" y2="24.08" stroke="#d97706" stroke-width="2"/><line x1="46" y1="24" x2="46" y2="15" stroke="#d97706" stroke-width="2"/><line x1="61.56" y1="30.44" x2="67.92" y2="24.08" stroke="#d97706" stroke-width="2"/><line x1="72" y1="66" x2="126" y2="118" stroke="#d97706" stroke-width="2.5"/>
<polygon points="126,118 116.4,115 122.64,108.52" fill="#d97706"/><line x1="150" y1="205" x2="150" y2="92" stroke="#0f6e56" stroke-width="3"/><polygon points="150,130 110,118 150,106" fill="#bbf7d0" stroke="#0f6e56" stroke-width="2"/><polygon points="150,116 196,104 150,92" fill="#bbf7d0" stroke="#0f6e56" stroke-width="2"/><polyline points="150,205 132,240" fill="none" stroke="#7c5a3a" stroke-width="2.5"/><polyline points="150,205 150,250" fill="none" stroke="#7c5a3a" stroke-width="2.5"/><polyline points="150,205 172,238" fill="none" stroke="#7c5a3a" stroke-width="2.5"/><line x1="96" y1="260" x2="132" y2="224" stroke="#2563eb" stroke-width="2.3"/>
<polygon points="132,224 129.17,232.49 123.51,226.83" fill="#2563eb"/><line x1="210" y1="258" x2="176" y2="224" stroke="#2563eb" stroke-width="2.3"/>
<polygon points="176,224 184.49,226.83 178.83,232.49" fill="#2563eb"/><line x1="250" y1="104" x2="202" y2="100" stroke="#64748b" stroke-width="2.3"/>
<polygon points="202,100 210.3,96.68 209.64,104.65" fill="#64748b"/><line x1="132" y1="96" x2="108" y2="66" stroke="#0f6e56" stroke-width="2.3"/>
<polygon points="108,66 116.12,69.75 109.87,74.75" fill="#0f6e56"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="44" y="84" text-anchor="middle" fill="#d97706" font-size="12">الضوء</text><text x="255" y="96" text-anchor="middle" fill="#64748b" font-size="13">CO₂</text><text x="98" y="58" text-anchor="middle" fill="#0f6e56" font-size="13">O₂</text><text x="150" y="156" text-anchor="middle" fill="#0f6e56" font-size="12">مادّة عضويّة</text><text x="150" y="200" text-anchor="middle" fill="#5c3d1e" font-size="11">الجذور</text><text x="150" y="285" text-anchor="middle" fill="#2563eb" font-size="11">الماء + أملاح معدنية</text><text x="252" y="220" text-anchor="middle" fill="#7c5a3a" font-size="11">التربة</text></g>
</svg>

> 🔮 أشجار **الحمضيّات** (البرتقال، اللّيمون) في جهة نابل مثلًا، تحتاج ضوءًا كافيًا طوال النّهار لتركّب موادّها العضويّة، ولهذا تُزرع في أراضٍ مكشوفة للشّمس لا في الظّلّ الكثيف.

## 🌾 النّبات الأخضر: كائن مُنْتِج

بفضل التركيب الضّوئيّ، يصنع النّبات الأخضر مادّته العضويّة بنفسه انطلاقًا من موادّ غير عضويّة (ماء، أملاح معدنية، ثاني أكسيد الكربون)، ولا يحتاج إلى أكل كائنات أخرى. لهذا يُسمّى النّبات الأخضر **كائنًا منتجًا**.

أمّا الحيوان، فلا يستطيع تركيب مادّته العضويّة بنفسه، بل يحصل عليها جاهزة بأكل النّباتات أو حيوانات أخرى، لهذا يُسمّى **كائنًا مستهلكًا**.

| الكائن         | كيف يحصل على مادّته العضويّة؟                      | التّسمية |
| -------------- | -------------------------------------------------- | -------- |
| النّبات الأخضر | يصنعها بنفسه بالتركيب الضّوئيّ من موادّ غير عضويّة | منتج     |
| الحيوان        | يحصل عليها جاهزة بأكل النّباتات أو حيوانات أخرى    | مستهلك   |

## 🧪 تجربة بسيطة: هل الضّوء ضروريّ فعلًا؟

للتّحقّق من أنّ الضّوء ضروريّ لنموّ النّبات الأخضر بشكل سليم، يمكن إنجاز ملاحظة بسيطة:

1. نضع **نبتتين** متماثلتين من نفس الصّنف (مثلًا شتلة فلفل) في إناءين بهما نفس كمّية التّربة، ونسقيهما بانتظام بنفس كمّية الماء.
2. نترك النّبتة الأولى في مكان **مضاء** طوال النّهار، ونضع النّبتة الثّانية في مكان **مظلم** تمامًا (خزانة مغلقة مثلًا)، طيلة أيّام عديدة.
3. بعد مدّة، نلاحظ أنّ النّبتة الّتي بقيت في الضّوء تنمو بشكل سليم وأوراقها خضراء نضرة، بينما النّبتة الّتي بقيت في الظّلام تصفرّ أوراقها ويضعف نموّها رغم توفّر الماء والتّربة لها بنفس الكمّية.

> ✓ توفّر الماء والتّربة وحدهما لا يكفي: غياب الضّوء وحده كفيل بإضعاف نموّ النّبتة وتغيير لون أوراقها، ما يثبت أنّ الضّوء ضروريّ لتركيب المادّة العضويّة عند النّبات الأخضر.

> 🏆 أتقنت الآن الحاجيات الغذائية للنّبات الأخضر، وكيف يمتصّ الماء والأملاح المعدنية من جذوره وثاني أكسيد الكربون من أوراقه، ليصنع بفضل الضّوء والكلوروفيل مادّته العضويّة الخاصّة به، فيكون بذلك كائنًا منتجًا. في الفصل القادم ستكتشف وظيفة حيويّة أخرى!', '# 📜 ملخّص: التّغذية عند النّبات الأخضر

- **الحاجيات الغذائية**: يحتاج النّبات الأخضر معًا إلى الماء والأملاح المعدنية وثاني أكسيد الكربون (CO₂) والضّوء، ولا غنى عن أيّ منها.
- **الامتصاص الجذريّ**: تمتصّ جذور النّبات الماء والأملاح المعدنية الذائبة فيه من التّربة.
- **امتصاص ثاني أكسيد الكربون**: تمتصّ أوراق النّبات غاز CO₂ مباشرة من الهواء المحيط بها، لا من التّربة.
- **الضّوء والكلوروفيل**: الكلوروفيل صبغة خضراء في الأوراق تلتقط طاقة الضّوء لتركيب المادّة العضويّة من الماء والأملاح المعدنية وCO₂، في عمليّة تُسمّى التركيب الضّوئيّ، ويُطرح الأكسجين (O₂) نتيجةً لها.
- **النّبات الأخضر منتج**: يصنع مادّته العضويّة بنفسه فيُسمّى منتجًا، بخلاف الحيوان المستهلك الذي يحصل عليها جاهزة من كائنات أخرى.
- **تجربة الضّوء**: نبتة محرومة من الضّوء تصفرّ أوراقها ويضعف نموّها رغم توفّر الماء والتّربة، ما يثبت ضرورة الضّوء لتركيب المادّة العضويّة.', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('0b434af5-07f7-5b82-956d-9e708a6aeac8', 'sciences-vie-terre-7eme', 'التّغذية عند الحيوان', 'أنظمة التّغذية عند الحيوان (عاشب، لاحم، قارت)، تكيّف الأسنان عند الثدييات حسب النظام الغذائي، تكيّف المنقار عند الطيور حسب نظامها الغذائي، مقدّمة وصفية إلى تحوّل الأغذية داخل جسم الحيوان، والحيوان بوصفه مستهلكًا لا يصنع غذاءه بنفسه', '# 🍽️ التّغذية عند الحيوان

> 💡 «النبتة تصنع غذاءها من الشمس والماء والتراب، أمّا الحيوان فعليه أن يبحث عن غذائه الجاهز… وفمه هو أوّل سلاحه في هذا البحث.»

تعرّفت في الفصول السابقة على الوسط البيئي وعلى التنفّس بوصفه وظيفة حيوية يقوم بها كلّ كائن حيّ. في هذا الفصل ستكتشف وظيفة حيوية أخرى: **التّغذية عند الحيوان**، وكيف يتكيّف كلّ حيوان — أسنانًا كانت أم منقارًا — مع نوع الغذاء الذي يعتمد عليه.

## 🐾 الحيوان مستهلك: لماذا يبحث عن غذائه؟

خلافًا للنبتة التي تصنع موادّها الغذائية بنفسها، **لا يستطيع الحيوان تصنيع غذائه**. لذلك يُوصف الحيوان بأنّه **مستهلك**: كائن حيّ يحصل على غذائه الجاهز من كائنات حيّة أخرى، نباتات كانت أم حيوانات.

حسب طبيعة هذا الغذاء، تُصنَّف الحيوانات ضمن ثلاثة **أنظمة تغذية**:

| النظام الغذائي | نوع الغذاء                | مثال تونسي          |
| -------------- | ------------------------- | ------------------- |
| **عاشب**       | نباتات فقط (أعشاب، أوراق) | الخروف، الماعز      |
| **لاحم**       | لحوم حيوانات أخرى فقط     | القطّ البرّي، النمس |
| **قارت**       | نباتات وحيوانات معًا      | الخنزير البرّي      |

> 🗡️ الحيوان مستهلك دائمًا، مهما كان نظامه الغذائي: العاشب يستهلك النبات، واللاحم يستهلك حيوانًا آخر، والقارت يستهلك الاثنين معًا.

## 🐐 النظام العاشب وتكيّف الأسنان

**العاشب** حيوان يقتات على النباتات حصرًا: الأعشاب، الأوراق، السنابل. فالخروف والماعز، وهما من أكثر الحيوانات رعيًا في الأرياف التونسية، يقضيان معظم نهارهما في قطف العشب وطحنه.

تتكيّف أسنان العاشب مع هذا الغذاء النباتي القاسي:

- **قواطع حادّة** في مقدّمة الفم، تُستعمل لقطف العشب وقصّه.
- **أضراس واسعة ومسطّحة** في مؤخّرة الفم، تُستعمل لطحن النبات طحنًا جيّدًا قبل بلعه.
- **أنياب ضعيفة جدًّا أو منعدمة**، لأنّ العاشب لا يحتاج إلى صيد فريسة أو تمزيق لحم.

> ⚠️ الخطأ الشائع هو تصوّر أنّ كلّ حيوان يملك أنيابًا بارزة وحادّة. العاشب كالخروف يملك أضراسًا مسطّحة عريضة، لا أنيابًا مدبّبة.

## 🐆 النظام اللاحم وتكيّف الأسنان

**اللاحم** حيوان يقتات على لحوم حيوانات أخرى يصطادها. من أمثلته في تونس **القطّ البرّي الإفريقي** الذي يعيش في السهوب والمناطق شبه الصحراوية ويصطاد القوارض والطيور الصغيرة، و**النمس** الذي يصطاد الزواحف والقوارض في الأرياف.

تتكيّف أسنان اللاحم مع الصيد وتقطيع اللحم:

- **أنياب طويلة وحادّة**، تُستعمل للإمساك بالفريسة وقتلها وتثبيتها.
- **أضراس حادّة مسنّنة**، تُستعمل لتقطيع اللحم وتمزيقه لا لطحنه.
- **قواطع صغيرة نسبيًّا**، تُستعمل لتنظيف اللحم عن العظم.

| نوع السنّ   | عند العاشب (الخروف)   | عند اللاحم (القطّ البرّي)    |
| ----------- | --------------------- | ---------------------------- |
| **القواطع** | حادّة، لقطف العشب     | صغيرة، لتنظيف اللحم عن العظم |
| **الأنياب** | منعدمة أو ضعيفة جدًّا | طويلة وحادّة، للصيد          |
| **الأضراس** | واسعة ومسطّحة، للطحن  | حادّة مسنّنة، للتقطيع        |

<svg viewBox="0 0 300 300">
<title>مقارنة الأسنان: العاشب (قواطع وأضراس مسطّحة بلا أنياب) واللاحم (أنياب طويلة وأضراس حادّة)</title>
<line x1="46" y1="78" x2="254" y2="78" stroke="#0f172a" stroke-width="3"/><g transform="translate(0 78)"><rect x="59.5" y="0" width="9" height="18" fill="#e2e8f0" stroke="#0f172a" stroke-width="1.8"/></g><g transform="translate(0 78)"><rect x="71.5" y="0" width="9" height="18" fill="#e2e8f0" stroke="#0f172a" stroke-width="1.8"/></g><g transform="translate(0 78)"><rect x="83.5" y="0" width="9" height="18" fill="#e2e8f0" stroke="#0f172a" stroke-width="1.8"/></g><g transform="translate(0 78)"><line x1="112" y1="6" x2="124" y2="18" stroke="#ef4444" stroke-width="2"/><line x1="124" y1="6" x2="112" y2="18" stroke="#ef4444" stroke-width="2"/></g><g transform="translate(0 78)"><rect x="158" y="0" width="20" height="22" fill="#e2e8f0" stroke="#0f172a" stroke-width="1.8"/></g><g transform="translate(0 78)"><rect x="184" y="0" width="20" height="22" fill="#e2e8f0" stroke="#0f172a" stroke-width="1.8"/></g><g transform="translate(0 78)"><rect x="210" y="0" width="20" height="22" fill="#e2e8f0" stroke="#0f172a" stroke-width="1.8"/></g><line x1="46" y1="208" x2="254" y2="208" stroke="#0f172a" stroke-width="3"/><g transform="translate(0 208)"><rect x="60.5" y="0" width="7" height="12" fill="#e2e8f0" stroke="#0f172a" stroke-width="1.8"/></g><g transform="translate(0 208)"><rect x="70.5" y="0" width="7" height="12" fill="#e2e8f0" stroke="#0f172a" stroke-width="1.8"/></g><g transform="translate(0 208)"><rect x="80.5" y="0" width="7" height="12" fill="#e2e8f0" stroke="#0f172a" stroke-width="1.8"/></g><g transform="translate(0 208)"><polygon points="109,0 123,0 116,42" fill="#fecaca" stroke="#0f172a" stroke-width="1.8"/></g><g transform="translate(0 208)"><polygon points="154,0 170,0 162,26" fill="#e2e8f0" stroke="#0f172a" stroke-width="1.8"/></g><g transform="translate(0 208)"><polygon points="178,0 194,0 186,26" fill="#e2e8f0" stroke="#0f172a" stroke-width="1.8"/></g><g transform="translate(0 208)"><polygon points="202,0 218,0 210,26" fill="#e2e8f0" stroke="#0f172a" stroke-width="1.8"/></g><g transform="translate(0 208)"><polygon points="224,0 240,0 232,26" fill="#e2e8f0" stroke="#0f172a" stroke-width="1.8"/></g><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="150" y="22" text-anchor="middle" fill="#0f6e56" font-size="14">عاشب</text><text x="76" y="130" text-anchor="middle" fill="#0f172a" font-size="11">قواطع</text><text x="118" y="128" text-anchor="middle" fill="#ef4444" font-size="11">لا أنياب</text><text x="194" y="130" text-anchor="middle" fill="#0f172a" font-size="11">أضراس مسطّحة</text><text x="150" y="160" text-anchor="middle" fill="#ef4444" font-size="14">لاحم</text><text x="74" y="268" text-anchor="middle" fill="#0f172a" font-size="11">قواطع</text><text x="116" y="272" text-anchor="middle" fill="#ef4444" font-size="11">أنياب طويلة</text><text x="205" y="262" text-anchor="middle" fill="#0f172a" font-size="11">أضراس حادّة</text></g>
</svg>

## 🐗 النظام القارت

**القارت** حيوان يقتات على النباتات وعلى الحيوانات معًا. مثاله في تونس **الخنزير البرّي**، الذي يعيش في غابات الشمال الغربي (كعين دراهم)، ويأكل الجذور والثمار وكذلك الحشرات الصغيرة والديدان.

بما أنّ القارت يتغذّى على نوعَي الغذاء، تجمع أسنانه بين خصائص النظامين معًا: **قواطع** لقطع الغذاء المتنوّع، **أنياب متوسّطة** غير بارزة كثيرًا، و**أضراس** يمزج شكلها بين المسطّح والحادّ لتتلاءم مع طحن النبات وتقطيع اللحم معًا.

> 🔮 من أمثلة القارت أيضًا **الدجاج**: يلتقط الحبوب مثل العاشب، لكنّه يلتقط أيضًا حشرات صغيرة ودودًا يجدها في التراب.

## 🦅 تكيّف المنقار عند الطيور حسب نظامها الغذائي

الطيور **لا تملك أسنانًا إطلاقًا**، فتتكيّف مع نظامها الغذائي بشكل **منقارها**:

- **منقار معقوف وحادّ**: عند الطيور اللاحمة الصائدة، مثل **الصقر الحرّ** الذي يصطاد الطيور الصغيرة والقوارض، أو **البوم** الذي يصطاد ليلًا. يُستعمل هذا المنقار لتمزيق اللحم بقوّة.
- **منقار قصير ومخروطي وقويّ**: عند الطيور العاشبة الحبوبيّة، مثل **العصفور الدوري**، الذي يستعمله لكسر قشرة الحبوب الصغيرة.
- **منقار متوسّط الشكل غير معقوف**: عند بعض الطيور القارتة، مثل **الدجاج**، الذي يستعمله لالتقاط الحبوب والحشرات معًا.

> ⚠️ لا تخلط بين شكلَي المنقار: **المنقار المعقوف** علامة على نظام لاحم (تمزيق اللحم)، بينما **المنقار المخروطي القصير** علامة على نظام عاشب أو قارت (كسر الحبوب والتقاط الغذاء)، لا العكس.

## 🧪 مقدّمة إلى تحوّل الأغذية داخل جسم الحيوان

بعد أن يمسك الحيوان بغذائه بأسنانه أو منقاره، لا ينتهي الأمر عند البلع. يمرّ الغذاء بمرحلتين متتاليتين:

1. **التّفتيت الميكانيكي**: تقطيع الغذاء وطحنه بالأسنان أو المنقار قبل بلعه، ليصبح أسهل تناولًا.
2. **تحوّل الغذاء داخل الجسم**: بعد البلع، يتحوّل الغذاء تدريجيًّا (وصفيًّا، دون الدخول في تفصيل الأعضاء الداخلية) إلى موادّ بسيطة يمتصّها جسم الحيوان ويستعملها للنموّ والحركة والنشاط، بينما تُطرح الأجزاء غير المهضومة خارج الجسم كفضلات.

> ✓ إذن التّغذية عملية متكاملة: إمساك بالغذاء ← تفتيته ← تحوّله داخل الجسم إلى موادّ مفيدة ← طرح الفضلات غير المستعملة.

> 🏆 أتقنت الآن أنظمة التّغذية الثلاثة عند الحيوان وكيف تتكيّف الأسنان والمناقير معها، وأنّ الحيوان مستهلك يحوّل غذاءه إلى موادّ مفيدة لجسمه. في الفصول القادمة ستكتشف وظائف حيوية أخرى!', '# 📜 ملخّص: التّغذية عند الحيوان

- **الحيوان مستهلك**: لا يصنع غذاءه بنفسه كالنبتة، بل يحصل عليه جاهزًا من كائنات حيّة أخرى؛ يُصنَّف حسب غذائه إلى عاشب أو لاحم أو قارت.
- **النظام العاشب**: يقتات على النباتات فقط (الخروف، الماعز)؛ أسنانه قواطع حادّة لقطف العشب وأضراس واسعة مسطّحة لطحنه، مع أنياب منعدمة أو ضعيفة جدًّا.
- **النظام اللاحم**: يقتات على لحوم حيوانات أخرى (القطّ البرّي، النمس)؛ أسنانه أنياب طويلة حادّة للصيد وأضراس حادّة مسنّنة لتقطيع اللحم.
- **النظام القارت**: يقتات على النباتات والحيوانات معًا (الخنزير البرّي، الدجاج)؛ أسنانه تجمع بين شكلَي العاشب واللاحم معًا.
- **تكيّف المنقار عند الطيور**: منقار معقوف حادّ عند اللاحمة الصائدة (الصقر الحرّ، البوم)، ومنقار قصير مخروطي قويّ عند العاشبة الحبوبيّة (العصفور الدوري)، ومنقار متوسّط غير معقوف عند القارتة (الدجاج).
- **تحوّل الأغذية داخل الجسم**: بعد تفتيت الغذاء بالأسنان أو المنقار، يتحوّل داخل الجسم (وصفيًّا) إلى موادّ بسيطة يمتصّها الحيوان ويستعملها، بينما تُطرح الفضلات غير المهضومة.', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('cfc76b85-e661-5d71-8c1f-a21e37b1203a', 'sciences-vie-terre-7eme', 'العلاقات والسّلاسل الغذائية', 'العلاقات الغذائية بين الكائنات الحيّة في الوسط الواحد، السلسلة الغذائية من المنتج إلى المستهلكات بترتيب سهم «يُؤكل من طرف»، دور المفكّكات (جراثيم وفطريات التربة) في تحويل المادّة العضوية إلى أملاح معدنية، والتوازن الطبيعي للوسط، وفق برنامج السنة السابعة من التعليم الأساسي', '# 🔗 العلاقات والسّلاسل الغذائية — مَن يأكل مَن في الوسط الواحد؟

> 💡 «لا يعيش أيّ كائن حيّ وحده في وسطه؛ فكلّ نبتة وكلّ حيوان حلقة في سلسلة طويلة، إن غابت واحدة منها اختلّ التوازن كلّه.»

تعرّفت في الفصول السابقة على التّغذية عند النبتة الخضراء (منتج يصنع غذاءه بنفسه) وعلى التّغذية عند الحيوان (مستهلك يبحث عن غذائه الجاهز). في هذا الفصل ستكتشف كيف تترابط هذه الكائنات فيما بينها ضمن **سلاسل غذائية**، ومَن يتكفّل بإعادة تدوير بقاياها.

## 🌍 العلاقات الغذائية بين الكائنات الحيّة في الوسط الواحد

يضمّ كلّ وسط بيئي (واحة، غربة، شاطئ...) عددًا كبيرًا من الكائنات الحيّة التي تتفاعل فيما بينها. من أهمّ هذه التفاعلات **العلاقة الغذائية**: كائن حيّ يتغذّى على كائن حيّ آخر. فالحشرة تأكل ورق النبتة، والعصفور يأكل الحشرة، وهكذا تتشابك حياة الكائنات في الوسط الواحد حول موضوع واحد: **مَن يتغذّى على مَن**.

> 🗡️ كلّ علاقة غذائية تربط كائنَين: كائن **مأكول** وكائن **آكل**. وهذا الترابط هو أساس السلسلة الغذائية التي سنكتشفها الآن.

## 🌿 المنتج: نقطة انطلاق كلّ سلسلة

تعلّمت أنّ **النبتة الخضراء منتج**: تصنع غذاءها العضوي بنفسها انطلاقًا من الماء والأملاح المعدنية وغاز الفحم، بفضل الضوء. لهذا يبدأ **كلّ** سلسلة غذائية دائمًا بمنتج (نبتة خضراء)، لأنّه الكائن الوحيد القادر على صنع مادّة عضوية من مادّة معدنية.

## 🦗 المستهلكات: من مستهلك أوّل إلى مستهلك ثالث

خلافًا للمنتج، **المستهلك** حيوان لا يصنع غذاءه، بل يحصل عليه من كائن حيّ آخر:

| الحلقة          | تعريفها                           | مثال                 |
| --------------- | --------------------------------- | -------------------- |
| **مستهلك أوّل** | يتغذّى مباشرة على المنتج (النبتة) | حشرة تأكل ورق النخلة |
| **مستهلك ثانٍ** | يتغذّى على مستهلك أوّل            | عصفور يأكل الحشرة    |
| **مستهلك ثالث** | يتغذّى على مستهلك ثانٍ            | ثعلب يأكل العصفور    |

> ⚠️ الخطأ الشائع هو الخلط بين المنتج والمستهلك الأوّل: المنتج نبتة تصنع غذاءها بنفسها، أمّا المستهلك الأوّل فحيوان يأكل هذه النبتة، ولا يصنع شيئًا بنفسه.

## 🔗 السلسلة الغذائية وسهم «يُؤكل من طرف»

**السلسلة الغذائية** ترتيب لعدّة حلقات (كائنات حيّة)، يربط بينها سهم (→) معناه الثابت: **«يُؤكل من طرف»**. الكائن الذي يبدأ منه السهم يُؤكل من طرف الكائن الذي ينتهي عنده السهم، والسلسلة تبدأ دائمًا بمنتج:

$$ نخلة → حشرة → عصفور → ثعلب $$

نقرأ هذه السلسلة هكذا: النخلة (منتج) تُؤكل من طرف الحشرة (مستهلك أوّل)، والحشرة تُؤكل من طرف العصفور (مستهلك ثانٍ)، والعصفور يُؤكل من طرف الثعلب (مستهلك ثالث).

<svg viewBox="0 0 300 150">
<title>سلسلة غذائية: نبات ← عاشب ← لاحم، والسهم معناه «يُؤكل من طرف»</title>
<rect x="19" y="41" width="74" height="42" rx="8" fill="#bbf7d0" stroke="#0f172a" stroke-width="2"/><text x="56" y="67" text-anchor="middle" fill="#0f172a" font-size="14" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">نبات</text><text x="56" y="103" text-anchor="middle" fill="#64748b" font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">مُنتِج</text><rect x="113" y="41" width="74" height="42" rx="8" fill="#fde68a" stroke="#0f172a" stroke-width="2"/><text x="150" y="67" text-anchor="middle" fill="#0f172a" font-size="14" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">عاشب</text><text x="150" y="103" text-anchor="middle" fill="#64748b" font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">مستهلك أوّل</text><rect x="207" y="41" width="74" height="42" rx="8" fill="#fecaca" stroke="#0f172a" stroke-width="2"/><text x="244" y="67" text-anchor="middle" fill="#0f172a" font-size="14" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">لاحم</text><text x="244" y="103" text-anchor="middle" fill="#64748b" font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">مستهلك ثانٍ</text><line x1="95" y1="62" x2="111" y2="62" stroke="#0f172a" stroke-width="2.5"/>
<polygon points="111,62 101,67 101,57" fill="#0f172a"/><line x1="189" y1="62" x2="205" y2="62" stroke="#0f172a" stroke-width="2.5"/>
<polygon points="205,62 195,67 195,57" fill="#0f172a"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="103" y="46" text-anchor="middle" fill="#0f172a" font-size="10">يُؤكل من طرف</text><text x="197" y="46" text-anchor="middle" fill="#0f172a" font-size="10">يُؤكل من طرف</text></g>
</svg>

> ⚠️ الخطأ الشائع هو قلب اتّجاه السهم. السهم لا يعني «يأكل» بل **«يُؤكل من طرف»**: نخلة → حشرة تعني أنّ النخلة هي المأكولة، لا الآكلة.

## 🏜️🌊 أمثلة تونسية: من الواحة إلى الشاطئ

تختلف الكائنات من وسط إلى آخر، لكنّ مبدأ السلسلة الغذائية واحد:

- **في الواحة**: نخلة → يرقة حشرة → عصفور دوري → صقر حرّ.
- **في الغربة**: نبتة حلفاء → جرادة → سحلية → أفعى.
- **على الشاطئ**: عوالق نباتية → سمكة صغيرة → سمكة كبيرة → طائر النورس.

## 🍂 المفكّكات: مَن يعيد المادّة العضوية إلى التراب؟

عندما يموت كائن حيّ (نبتة أو حيوان)، أو يُطرح فضلات، لا تبقى هذه المادّة العضوية دون تحوّل. تتكفّل بها كائنات مجهرية تعيش في التراب، أهمّها **الجراثيم** و**الفطريات**، وتُسمّى **المفكّكات**. تحوّل المفكّكات المادّة العضوية الميّتة إلى **أملاح معدنية** تعود إلى التراب، فتمتصّها جذور النباتات (المنتجات) من جديد.

> 🔮 بفضل المفكّكات، لا تضيع المادّة أبدًا: بقايا كلّ حلقة في السلسلة الغذائية تعود غذاءً معدنيًّا للمنتجات، فتُغلق الدورة.

## ⚖️ التوازن الطبيعي للوسط

يحافظ الوسط البيئي على **توازنه الطبيعي** ما دامت كلّ حلقة تلعب دورها: المنتج يصنع الغذاء، المستهلكات تتغذّى وتتناسل ضمن حدود معقولة، والمفكّكات تعيد المادّة العضوية أملاحًا معدنية. إن اختفت حلقة (كصيد مفرط لحيوان مفترس مثلًا)، تتكاثر فريسته دون رادع وتستنزف المنتج، فيختلّ التوازن الطبيعي للوسط بأكمله.

> 🏆 أتقنت الآن العلاقات الغذائية بين الكائنات الحيّة، والسلسلة الغذائية بسهمها «يُؤكل من طرف»، ودور المفكّكات في إعادة المادّة العضوية أملاحًا معدنية، وأهمّية كلّ حلقة في توازن الوسط الطبيعي. في الفصول القادمة ستكتشف وظائف حيوية أخرى!', '# 📜 ملخّص: العلاقات والسّلاسل الغذائية

- **العلاقات الغذائية**: كلّ كائن حيّ في الوسط الواحد يتفاعل مع غيره حول موضوع «مَن يتغذّى على مَن».
- **المنتج**: نقطة انطلاق كلّ سلسلة غذائية؛ النبتة الخضراء التي تصنع غذاءها بنفسها.
- **المستهلكات**: مستهلك أوّل يأكل المنتج، مستهلك ثانٍ يأكل مستهلك أوّل، مستهلك ثالث يأكل مستهلك ثانٍ.
- **السلسلة الغذائية**: ترتيب حلقات مرتبطة بسهم (→) معناه الثابت «يُؤكل من طرف»؛ تبدأ دائمًا بمنتج.
- **أمثلة تونسية**: سلاسل من الواحة (نخلة → يرقة حشرة → عصفور دوري → صقر حرّ)، الغربة (حلفاء → جرادة → سحلية → أفعى)، والشاطئ (عوالق نباتية → سمكة صغيرة → سمكة كبيرة → نورس).
- **المفكّكات**: جراثيم وفطريات التربة تحوّل المادّة العضوية الميّتة إلى أملاح معدنية تعود غذاءً للمنتجات.
- **التوازن الطبيعي**: كلّ حلقة (منتج، مستهلكات، مفكّكات) تلعب دورها؛ اختفاء حلقة واحدة يختلّ به توازن الوسط بأكمله.', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('35d2091c-3f14-51af-a0d7-25db354cc4f2', 'sciences-vie-terre-7eme', 'التّربة وعلاقتها بالكائنات الحيّة', 'تعريف التّربة بوصفها الطّبقة السّطحية الحاملة للغطاء النّباتيّ، مكوّناتها المعدنيّة (رمل، طين، حصى) والعضويّة (بقايا متحلّلة) إضافة إلى الهواء والماء والكائنات المجهريّة، خصائصها (النّفاذيّة والقوام) وأنواعها، العلاقة التّبادليّة بين التّربة والكائنات الحيّة (التّغذية والإيواء، وتثبيت الجذور للتّربة)، وحماية التّربة من التّعرية', '# 🌱 التّربة وعلاقتها بالكائنات الحيّة

> 💡 «تحت أقدامنا عالم كامل من الحياة: حفنة تراب واحدة تحمل ملايين الكائنات المجهريّة الّتي تصنع خصوبة الأرض.»

اكتشفت في الفصول السّابقة الوسط البيئيّ والتّنفّس والتّغذية عند النّبات والحيوان. في هذا الفصل ستكتشف عنصرًا أساسيًّا من عناصر الوسط البيئيّ غير الحيّة، لكنّه يحمل الحياة كلّها فوقه: **التّربة**.

## 🌍 ما هي التّربة؟

::: figure التّربةُ في مقطع: طبقةٌ عضويّةٌ داكنةٌ فوق طبقةٍ معدنيّة، وفيها هواءٌ وماءٌ وجذورٌ وكائناتٌ حيّة
<svg viewBox="0 0 400 190"><rect x="40" y="34" width="210" height="30" rx="0" fill="#78350f" stroke="#451a03" stroke-width="1.5"/><path d="M60 34 q6 -8 14 0 M110 34 q6 -8 14 0 M170 34 q6 -8 14 0" fill="#65a30d" stroke="#3f6212" stroke-width="1.2"/><rect x="40" y="64" width="210" height="118" rx="0" fill="#b45309" stroke="#78350f" stroke-width="1.5"/><circle cx="70" cy="96" r="4" fill="#d97706" stroke="#92400e" stroke-width="1"/><circle cx="110" cy="130" r="5" fill="#d97706" stroke="#92400e" stroke-width="1"/><circle cx="150" cy="100" r="3" fill="#d97706" stroke="#92400e" stroke-width="1"/><circle cx="190" cy="140" r="4" fill="#d97706" stroke="#92400e" stroke-width="1"/><circle cx="95" cy="118" r="3" fill="#d97706" stroke="#92400e" stroke-width="1"/><circle cx="170" cy="128" r="4" fill="#d97706" stroke="#92400e" stroke-width="1"/><circle cx="130" cy="90" r="3" fill="#d97706" stroke="#92400e" stroke-width="1"/><path d="M150 34 V150 M150 80 q-16 8 -22 26 M150 110 q16 8 22 24" fill="none" stroke="#eab308" stroke-width="2.4"/><path d="M80 150 q10 -14 24 -6 q12 8 22 -2" fill="none" stroke="#f472b6" stroke-width="5" stroke-linecap="round"/><path d="M200 96 q-4 6 0 9 q4 -3 0 -9 z" fill="#3b82f6"/><path d="M120 150 q-4 6 0 9 q4 -3 0 -9 z" fill="#3b82f6"/><path d="M268.0 48.0 L254.0 48.0" stroke="#1f2937" stroke-width="1.6" stroke-linecap="round"/><path d="M254.0 48.0 L263.0 43.0 L263.0 53.0 Z" fill="#1f2937"/><text x="336.0" y="51.0" text-anchor="middle" font-size="11" font-weight="700" fill="#451a03" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">موادّ عضويّة</text><path d="M268.0 114.0 L254.0 114.0" stroke="#1f2937" stroke-width="1.6" stroke-linecap="round"/><path d="M254.0 114.0 L263.0 109.0 L263.0 119.0 Z" fill="#1f2937"/><text x="336.0" y="108.0" text-anchor="middle" font-size="11" font-weight="700" fill="#78350f" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">موادّ معدنيّة</text><text x="336.0" y="125.0" text-anchor="middle" font-size="9" font-weight="700" fill="#92400e" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">(رمل، طين، حصى)</text><text x="104.0" y="176.0" text-anchor="middle" font-size="9" font-weight="700" fill="#be185d" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">دودة</text><text x="150.0" y="176.0" text-anchor="middle" font-size="9" font-weight="700" fill="#a16207" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">جذر</text><text x="160.0" y="22.0" text-anchor="middle" font-size="11" font-weight="700" fill="#334155" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">التّربةُ في مقطع: طبقةٌ عضويّةٌ فوق طبقةٍ معدنيّة</text></svg>
:::

**التّربة** هي **الطّبقة السّطحيّة** من سطح الأرض، الحاملة **للغطاء النّباتيّ** الّذي يغطّي الحقول والغابات والبساتين. فبساتين الزّيتون المنتشرة في السّاحل التّونسيّ وصفاقس، مثلًا، تنمو فوق طبقة من التّربة توفّر لأشجارها كلّ ما تحتاجه.

لا تُعتبر التّربة كتلة صمّاء واحدة، بل هي **مزيج** من موادّ مختلفة متجاورة، بعضها معدنيّ صلب وبعضها عضويّ متحلّل، إضافة إلى الهواء والماء والكائنات الحيّة الدّقيقة. هذا المزيج هو ما يجعل التّربة قادرة على حمل الحياة.

## 🪨 المكوّنات المعدنيّة للتّربة

تحتوي كلّ تربة على **موادّ معدنيّة** ناتجة عن تفتّت الأرض عبر الزّمن، تختلف في حجم حبيباتها:

| المكوّن المعدنيّ | حجم الحبيبات         | مثال في الميدان                 |
| ---------------- | -------------------- | ------------------------------- |
| **الرّمل**       | حبيبات دقيقة نسبيًّا | تربة الجنوب التّونسيّ الرّمليّة |
| **الطّين**       | حبيبات دقيقة جدًّا   | تربة السّهول الفيضيّة الطّينيّة |
| **الحصى**        | حبيبات كبيرة نسبيًّا | حصى منتشر في تربة سفوح الجبال   |

> 🗡️ لا تخلط بين الرّمل والطّين: حبيبات الرّمل يمكن تمييزها بالعين المجرّدة تقريبًا، بينما حبيبات الطّين دقيقة جدًّا لدرجة أنّها تتماسك وتصبح لزجة عند بلّها بالماء.

## 🍂 المكوّنات العضويّة، الهواء، الماء، والكائنات المجهريّة

إلى جانب الموادّ المعدنيّة، تحتوي التّربة على مكوّنات أخرى لا تقلّ أهمّية:

- **الموادّ العضويّة**: بقايا نباتات وحيوانات متحلّلة (أوراق ساقطة، جذور ميتة، فضلات حيوانات)، تتراكم في الطّبقة السّطحيّة وتُغني التّربة.
- **الهواء**: يملأ الفراغات الصّغيرة بين حبيبات التّربة، وهو ضروريّ لتنفّس جذور النّباتات والكائنات الحيّة الموجودة داخل التّربة.
- **الماء**: يتسرّب بين الحبيبات ويُحتفظ به بنسب متفاوتة حسب نوع التّربة.
- **الكائنات المجهريّة**: بكتيريا وفطريات وديدان تعيش داخل التّربة، وتُحلّل الموادّ العضويّة تدريجيًّا إلى موادّ بسيطة يستفيد منها النّبات.

> ⚠️ الخطأ الشّائع هو الاعتقاد أنّ التّربة موادّ صلبة فقط. التّربة الحيّة تحتوي دائمًا على هواء وماء وكائنات مجهريّة، لا موادّ معدنيّة وعضويّة فحسب.

## 💧 خصائص التّربة: النّفاذيّة والقوام

يختلف **قوام** التّربة (نسب موادّها المعدنيّة والعضويّة) من منطقة إلى أخرى، وهذا يحدّد خاصّية أساسيّة هي **النّفاذيّة**: قدرة التّربة على تسريب الماء عبر حبيباتها.

| نوع التّربة | القوام الغالب                     | النّفاذيّة          | الاحتفاظ بالماء               |
| ----------- | --------------------------------- | ------------------- | ----------------------------- |
| **رمليّة**  | حبيبات رمل كبيرة نسبيًّا          | نفاذيّة عالية جدًّا | ضعيف؛ يتسرّب الماء بسرعة      |
| **طينيّة**  | حبيبات طين دقيقة جدًّا            | نفاذيّة ضعيفة جدًّا | قويّ؛ يتجمّع الماء فوق السّطح |
| **دباليّة** | مزيج متوازن مع موادّ عضويّة كثيرة | نفاذيّة متوسّطة     | جيّد؛ الأنسب للزّراعة         |

> 🔮 لهذا السّبب تُفضَّل التّربة الدّباليّة المتوازنة لزراعة أشجار الزّيتون والحبوب في تونس: فهي لا تُغرق الجذور بالماء كالطّينيّة، ولا تُهدره سريعًا كالرّمليّة.

## 🌿 التّربة والكائنات الحيّة: علاقة تبادل

العلاقة بين التّربة والكائنات الحيّة **متبادلة**:

- **التّربة تُغذّي وتُؤوي**: توفّر للنّبات الماء والأملاح المعدنيّة الضّروريّة لتغذيته (كما رأيت في فصل التّغذية عند النّبات الأخضر)، وتُؤوي داخلها كائنات حيّة كديدان الأرض والحشرات والكائنات المجهريّة.
- **الكائنات الحيّة تُحافظ على التّربة**: **جذور النّباتات** تنغرس داخل التّربة وتتشابك مع حبيباتها، فتُثبّتها وتمنع تفتّتها وانجرافها، خاصّة في المناطق المُنحدرة كسفوح الجبال.

> ✓ إذن دون غطاء نباتيّ، تفقد التّربة ما يُثبّتها، ودون تربة خصبة، لا يجد النّبات ما يُغذّيه: علاقة تكامل لا يمكن فصلها.

## 🛡️ حماية التّربة من التّعرية

**التّعرية** هي فقدان التّربة لطبقتها السّطحيّة الخصبة بفعل عوامل طبيعيّة، أهمّها:

- **الرّياح القويّة**، الّتي تكسح حبيبات التّربة الرّمليّة الجافّة، خاصّة في المناطق القليلة الغطاء النّباتيّ.
- **الأمطار الغزيرة**، الّتي تجرف التّربة على السّفوح المُنحدرة إذا لم تُثبّتها جذور النّباتات.
- **إزالة الغطاء النّباتيّ** (قطع الأشجار، الرّعي الجائر)، الّذي يترك التّربة مكشوفة أمام الرّياح والأمطار.

لحماية التّربة، يعتمد الفلّاحون في المناطق الجبليّة التّونسيّة (كعين دراهم والكاف) وسائل مثل: **الحفاظ على الغطاء النّباتيّ**، **زراعة الأشجار على المصاطب** (مدرّجات تُبطئ جريان الماء)، وتجنّب الرّعي الجائر وقطع الأشجار العشوائيّ.

> 🏆 أتقنت الآن مكوّنات التّربة وخصائصها وعلاقتها التّبادليّة بالكائنات الحيّة، وكيف نحميها من التّعرية. في الفصول القادمة ستكتشف عناصر أخرى من الوسط البيئيّ!', '# 📜 ملخّص: التّربة وعلاقتها بالكائنات الحيّة

- **تعريف التّربة**: الطّبقة السّطحيّة من الأرض الحاملة للغطاء النّباتيّ، مزيج من موادّ معدنيّة وعضويّة وهواء وماء وكائنات حيّة.
- **المكوّنات المعدنيّة**: الرّمل (حبيبات دقيقة نسبيًّا)، الطّين (حبيبات دقيقة جدًّا تصبح لزجة عند بلّها)، الحصى (حبيبات كبيرة نسبيًّا).
- **المكوّنات العضويّة والحيّة**: بقايا نباتات وحيوانات متحلّلة، هواء وماء بين الحبيبات، وكائنات مجهريّة (بكتيريا، فطريات، ديدان) تُحلّل الموادّ العضويّة.
- **النّفاذيّة والقوام**: التّربة الرّمليّة نفاذيّة عالية جدًّا واحتفاظ ضعيف بالماء، الطّينيّة نفاذيّة ضعيفة جدًّا واحتفاظ قويّ، الدّباليّة متوازنة وهي الأنسب للزّراعة.
- **علاقة التّربة بالكائنات الحيّة**: التّربة تُغذّي النّبات وتُؤوي الكائنات الحيّة، وجذور النّباتات تُثبّت التّربة وتحميها من التّفتّت والانجراف.
- **حماية التّربة من التّعرية**: الرّياح القويّة والأمطار الغزيرة وإزالة الغطاء النّباتيّ تُسبّب التّعرية؛ الحماية تكون بالحفاظ على الغطاء النّباتيّ وزراعة الأشجار على المصاطب.', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('c3418051-d92b-590b-8e89-ae540df41bcc', 'sciences-vie-terre-7eme', 'الماء ودوره في حياة الكائنات الحيّة', 'أهمّية الماء الحيوية عند الإنسان والنّبات والحيوان، وجود الماء في التّربة وفي مختلف عناصر الوسط البيئي، جودة الماء وطرق المحافظة عليه من التّلوّث، وخاتمة تربط الماء بالوظائف الحيوية الأخرى المدروسة في الوسط البيئي', '# 💧 الماء ودوره في حياة الكائنات الحيّة — سرّ الحياة السّائل

> 💡 «لا حياة بلا ماء: فكلّ كائن حيّ، مهما كان نوعه أو حجمه، لا يستطيع الاستغناء عنه ولو ليوم واحد.»

اكتشفت في الفصول السّابقة الوسط البيئي بمكوّناته، والتّنفّس، والتّغذية عند النّبات الأخضر وعند الحيوان. في كلّ مرّة، كان الماء حاضرًا دون أن تلاحظه بوضوح: الأكسجين الّذي تمتصّه الأسماك ذائبٌ في الماء، والنّبات الأخضر يمتصّ الماء بجذوره لتركيب مادّته العضويّة. في هذا الفصل الأخير ستكتشف دور الماء بوصفه حاجة حيوية مشتركة بين كلّ الكائنات الحيّة.

## 🌊 الماء: حاجة مشتركة بين كلّ الكائنات الحيّة

::: figure الماءُ حاجةٌ مشتركة: يشربُه الإنسانُ والحيوان، ويمتصُّه النباتُ الأخضرُ بجذوره من التّربة
<svg viewBox="0 0 340 180"><path d="M170 48 q22 26 22 40 a22 22 0 1 1 -44 0 q0 -14 22 -40 z" fill="#60a5fa" stroke="#2563eb" stroke-width="2.5"/><text x="170.0" y="94.0" text-anchor="middle" font-size="13" font-weight="700" fill="#ffffff" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">الماء</text><circle cx="52" cy="60" r="11" fill="#fde68a" stroke="#a16207" stroke-width="2"/><path d="M52 71 V96 M52 78 H38 M52 78 H66 M52 96 L44 116 M52 96 L60 116" stroke="#a16207" stroke-width="2.4" stroke-linecap="round"/><text x="52.0" y="134.0" text-anchor="middle" font-size="11" font-weight="700" fill="#a16207" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">إنسان</text><text x="52.0" y="150.0" text-anchor="middle" font-size="9" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">يشرب</text><path d="M288 116 V78" stroke="#15803d" stroke-width="3"/><circle cx="288" cy="70" r="12" fill="#16a34a" stroke="#15803d" stroke-width="1.5"/><path d="M288 116 q-12 8 -16 22 M288 116 q12 8 16 22" fill="none" stroke="#a16207" stroke-width="2"/><text x="288.0" y="150.0" text-anchor="middle" font-size="11" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">نبات</text><text x="288.0" y="166.0" text-anchor="middle" font-size="9" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">يمتصّ بالجذور</text><ellipse cx="170" cy="150" rx="24" ry="13" fill="#d6d3d1" stroke="#57534e" stroke-width="1.6"/><circle cx="192" cy="144" r="8" fill="#d6d3d1" stroke="#57534e" stroke-width="1.6"/><path d="M152 160 V172 M188 160 V172" stroke="#57534e" stroke-width="2.4"/><text x="120.0" y="154.0" text-anchor="end" font-size="11" font-weight="700" fill="#57534e" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">حيوان</text><text x="120.0" y="168.0" text-anchor="end" font-size="9" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">يشرب</text><path d="M144.0 78.0 L74.0 66.0" stroke="#2563eb" stroke-width="2" stroke-linecap="round"/><path d="M74.0 66.0 L83.7 62.6 L82.0 72.4 Z" fill="#2563eb"/><path d="M196.0 78.0 L268.0 72.0" stroke="#2563eb" stroke-width="2" stroke-linecap="round"/><path d="M268.0 72.0 L259.4 77.7 L258.6 67.8 Z" fill="#2563eb"/><path d="M170.0 112.0 L170.0 132.0" stroke="#2563eb" stroke-width="2" stroke-linecap="round"/><path d="M170.0 132.0 L165.0 123.0 L175.0 123.0 Z" fill="#2563eb"/><text x="170.0" y="24.0" text-anchor="middle" font-size="12" font-weight="700" fill="#334155" paint-order="stroke" stroke="#ffffff" stroke-width="3" stroke-linejoin="round">الماءُ حاجةٌ مشتركةٌ بين كلّ الكائنات الحيّة</text></svg>
:::

يدخل الماء في تركيب جسم كلّ كائن حيّ ويشكّل فيه نسبة كبيرة من وزنه، ويتدخّل في جميع وظائفه الحيوية: التّغذية، والتّنفّس، والنّموّ. مهما اختلفت الكائنات الحيّة (إنسانًا كانت أم نباتًا أم حيوانًا)، فإنّها تشترك جميعًا في هذه الحاجة الأساسية إلى الماء.

> ⚠️ الخطأ الشّائع هو الاعتقاد أنّ الماء عنصر غير حيّ منفصل عن الكائنات الحيّة فحسب. صحيحٌ أنّ الماء عنصر غير حيّ في الوسط البيئي، لكنّه في الوقت نفسه جزء أساسيّ من تركيب جسم كلّ كائن حيّ ومن نشاطه اليوميّ.

## 👤 الماء عند الإنسان

يحتاج جسم الإنسان إلى الماء للقيام بوظائف حيوية عديدة: نقل المواد الغذائية عبر الدّم إلى مختلف أعضاء الجسم، والمساعدة على الهضم، وتنظيم حرارة الجسم عبر التّعرّق. يفقد الجسم الماء باستمرار (بالتّعرّق والتّنفّس والتّبوّل)، ولهذا يحتاج إلى تعويضه بانتظام.

> 🗡️ لا يجب انتظار الشّعور بعطش شديد لشرب الماء، بل يُنصح بشربه بكمّيات منتظمة على مدار اليوم، خاصّة في الجوّ الحارّ أو أثناء النّشاط البدنيّ.

## 🌱 الماء عند النّبات الأخضر

تعرّفت في الفصل السّابق على **الامتصاص الجذريّ**: يمتصّ النّبات الأخضر الماء والأملاح المعدنية بجذوره من التّربة. الماء هنا له دوران أساسيّان: ينقل الأملاح المعدنية الممتصّة إلى بقيّة أعضاء النّبات، وهو أيضًا مادّة أوّلية ضرورية للتّركيب الضّوئيّ إلى جانب ثاني أكسيد الكربون والضّوء.

> ⚠️ نقص الماء وحده كفيل بإضعاف النّبات، حتّى لو توفّرت له الأملاح المعدنية والضّوء بكمّية كافية: تذبل أوراقه تدريجيًّا وتفقد نضارتها، لأنّ الماء لا يعوّضه أيّ عنصر آخر.

## 🐾 الماء عند الحيوان

تشرب معظم الحيوانات الماء مباشرة، لكنّ بعضها يحصل على جزء من حاجته للماء بصفة غير مباشرة من النّباتات الطّازجة الغنيّة بالماء الّتي يأكلها. يستعمل الماء أيضًا لتبريد الجسم: فالكلب مثلًا يلهث مخرجًا لسانه في الجوّ الحارّ، وهذا يبرّد جسمه عبر تبخّر الماء من لسانه وفمه.

> 🔮 يعتقد كثيرون خطأً أنّ الجمل يخزّن الماء في سنامه. في الحقيقة، يخزّن سنامه **دهنًا**، تستعمله الجمل كمخزون طاقة يساعده على تحمّل أيّام طويلة دون شرب مباشر، لا كخزّان ماء حقيقيّ.

## 🏞️ الماء في التّربة وفي الوسط البيئي

تحتفظ **التّربة** بالماء بين حبيباتها، وهذا الماء هو الّذي تمتصّه جذور النّباتات. لا تحتفظ كلّ أنواع التّرب بالماء بالقدر نفسه:

| نوع التّربة          | قدرة الاحتفاظ بالماء                          |
| -------------------- | --------------------------------------------- |
| **التّربة الطّينية** | تحتفظ بالماء مدّة طويلة بين حبيباتها الدّقيقة |
| **التّربة الرّملية** | يتسرّب الماء منها بسرعة بين حبيباتها الكبيرة  |

إلى جانب التّربة، يوجد الماء في مختلف عناصر الوسط البيئي: في الأودية (كوادي مجردة، أكبر واد في تونس)، وفي البحيرات (كبحيرة إشكل بجهة بنزرت)، وفي المياه الجوفية تحت سطح الأرض، وفي البحر. تجدر الإشارة إلى أنّ **ماء البحر مالح** ولا يصلح للشّرب مباشرة، بخلاف مياه الأودية والبحيرات والمياه الجوفية العذبة الّتي تُستعمل للشّرب والسّقي.

## 🧪 جودة الماء والمحافظة عليه من التّلوّث

تتعرّض مصادر الماء في الوسط البيئي للتّلوّث بسبب عوامل عدّة: إلقاء النّفايات المنزلية مباشرة في الأودية والبحيرات، وتسرّب الموادّ الكيميائية الزراعية (كالمبيدات والأسمدة) من الحقول إلى المياه الجوفية والأودية، وتصريف نفايات معملية دون معالجة. يضرّ الماء الملوّث بجودته بالكائنات الحيّة الّتي تعيش فيه أو تعتمد عليه: فهو يقلّل مثلًا كمّية الأكسجين المذاب في الماء الّذي تحتاجه الأسماك لتتنفّس بخياشيمها، ويجعل الماء غير صالح للشّرب أو للسّقي.

> ⚠️ للمحافظة على جودة الماء، يجب ترشيد استهلاكه وعدم الإفراط فيه، وعدم إلقاء أيّ نفايات في الأودية أو البحيرات أو الآبار، والمحافظة على الغطاء النّباتي الّذي يساعد التّربة على الاحتفاظ بماء نظيف، واحترام المناطق الطّبيعية المحمية كبحيرة إشكل.

## 🏆 خاتمة الوحدة: نظرة شاملة على الوسط البيئي

اكتشفت في الفصل الأوّل مكوّنات الوسط البيئي، وفي الفصل الثّاني التّنفّس، وفي الفصلين الثّالث والرّابع التّغذية عند النّبات الأخضر وعند الحيوان. يربط الماء كلّ هذه الوظائف الحيوية معًا: فبدونه لا تنفّس ممكن عند الأسماك، ولا تغذية ممكنة عند النّبات أو الحيوان، ولا حتّى وسط بيئي متكامل، لأنّه أحد أهمّ عناصره غير الحية.

> 🏆 أتممت الآن رحلتك في اكتشاف الوسط البيئي بجميع أبعاده: مكوّناته، وتنفّس كائناته، وتغذيتها، ودور الماء الحيويّ فيها جميعًا. أنت الآن بطل حقيقيّ في علوم الحياة والأرض!', '# 📜 ملخّص: الماء ودوره في حياة الكائنات الحيّة

- **الماء حاجة مشتركة**: يدخل في تركيب جسم كلّ كائن حيّ ويشكّل فيه نسبة كبيرة من وزنه، ويتدخّل في كلّ وظائفه الحيوية (تغذية، تنفّس، نموّ).
- **الماء عند الإنسان**: ينقل المواد الغذائية عبر الدّم، يساعد على الهضم، وينظّم حرارة الجسم عبر التّعرّق؛ يجب تعويض ما يفقده الجسم منه بانتظام دون انتظار العطش الشّديد.
- **الماء عند النّبات الأخضر**: يُمتصّ بالجذور مع الأملاح المعدنية (الامتصاص الجذريّ) وهو مادّة أوّلية للتّركيب الضّوئيّ؛ نقصه وحده يُذبل النّبات حتّى مع توفّر الضّوء والأملاح المعدنية.
- **الماء عند الحيوان**: تشربه معظم الحيوانات مباشرة، وبعضها يحصل على جزء منه من النّباتات الطّازجة الّتي تأكلها؛ يُستعمل أيضًا لتبريد الجسم (لهاث الكلب)؛ سنام الجمل يخزّن دهنًا لا ماءً.
- **الماء في التّربة والوسط البيئي**: تحتفظ التّربة الطّينية بالماء أطول من التّربة الرّملية؛ يوجد الماء أيضًا في الأودية والبحيرات والمياه الجوفية والبحر، وماء البحر مالح لا يصلح للشّرب مباشرة.
- **جودة الماء والمحافظة عليه**: تلوّثه النّفايات المنزلية والموادّ الكيميائية الزراعية والنّفايات المعملية، فيضرّ بالكائنات الحيّة (كتقليل الأكسجين الّذي تحتاجه الأسماك)؛ نحافظ عليه بترشيد الاستهلاك وعدم التّلويث وحماية الغطاء النّباتي.
- **خاتمة الوحدة**: الماء يربط كلّ الوظائف الحيوية المدروسة (مكوّنات الوسط، التّنفّس، تغذية النّبات والحيوان) في نظرة شاملة على الوسط البيئي.', 7, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('276c0a98-498b-55ac-b3f9-ce5fb01a86d4', 'b996e1b4-c072-5d2d-81ed-0e4e73b03188', 'sciences-vie-terre-7eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6b7b8cc9-ad5a-5e66-99c7-ffa43976b72d', '276c0a98-498b-55ac-b3f9-ce5fb01a86d4', 'ما الذي يميّز الكائن الحيّ عن الجسم غير الحيّ؟', '[{"id":"a","text":"يتحرّك فقط"},{"id":"b","text":"يتنفّس ويتغذّى وينمو ويتكاثر"},{"id":"c","text":"له لون معيّن"},{"id":"d","text":"يوجد في الطبيعة"}]'::jsonb, 'b', 'الكائن الحيّ يقوم بوظائف حيوية مجتمعة: التنفّس والتغذية والنموّ والقدرة على التكاثر. مجرّد الحركة أو اللون أو الوجود في الطبيعة لا يكفي، فالنار تتحرّك والحجارة توجد في الطبيعة دون أن تكون حيّة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('39ecdda8-d626-5c49-87ba-063f531d34be', '276c0a98-498b-55ac-b3f9-ce5fb01a86d4', 'مم يتكوّن الوسط البيئي؟', '[{"id":"a","text":"من الكائنات الحيّة فقط"},{"id":"b","text":"من العناصر غير الحية فقط"},{"id":"c","text":"من الحيوانات فقط"},{"id":"d","text":"من العناصر غير الحية ومجموع الكائنات الحيّة معًا"}]'::jsonb, 'd', 'الوسط البيئي يجمع بين عنصرين متكاملين: العناصر غير الحية (التربة، الماء، الهواء، المناخ) ومجموع الكائنات الحيّة. أحد العنصرين وحده لا يكفي لتعريف وسط بيئي.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0b0c30b9-c7cc-5241-9f82-c481767a11b6', '276c0a98-498b-55ac-b3f9-ce5fb01a86d4', 'ما الذي يميّز الشجرة عن الشجيرة؟', '[{"id":"a","text":"للشجرة جذع رئيسي واحد، بينما للشجيرة عدّة سيقان من القاعدة"},{"id":"b","text":"الشجرة أقصر من الشجيرة دائمًا"},{"id":"c","text":"الشجيرة وحدها لها ساق خشبية"},{"id":"d","text":"لا فرق بينهما إطلاقًا"}]'::jsonb, 'a', 'الشجرة لها ساق خشبية رئيسية واحدة (جذع) تتفرّع منه الأغصان في الأعلى، بينما للشجيرة عدّة سيقان خشبية تنطلق من القاعدة مباشرةً. كلتاهما لهما ساق خشبية، والشجرة عادةً أكبر لا أقصر.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bdd6f95a-2f32-56b3-a31a-649c445e400d', '276c0a98-498b-55ac-b3f9-ce5fb01a86d4', 'كيف تُرى الكائنات الدقيقة مثل البكتيريا؟', '[{"id":"a","text":"بالعين المجرّدة مباشرة"},{"id":"b","text":"بالمنظار المقرّب"},{"id":"c","text":"باستعمال المجهر فقط"},{"id":"d","text":"لا يمكن رؤيتها بأيّ وسيلة"}]'::jsonb, 'c', 'الكائنات الدقيقة مثل البكتيريا صغيرة جدًّا، فلا تُرى إلّا باستعمال المجهر. المنظار المقرّب يُستعمل لرؤية أجسام بعيدة لا دقيقة، وهي كائنات حقيقية موجودة رغم عدم رؤيتها بالعين المجرّدة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a5272b2f-8b38-5b98-9494-ee96095f4f62', '276c0a98-498b-55ac-b3f9-ce5fb01a86d4', 'لماذا تختلف الكائنات الحيّة التي تعيش في غابة عين دراهم عن تلك التي تعيش في الواحة؟', '[{"id":"a","text":"لأنّ عوامل المناخ (الحرارة، الأمطار، الرطوبة) تختلف بين الوسطين"},{"id":"b","text":"لأنّ الحيوانات تختار عشوائيًّا أين تعيش"},{"id":"c","text":"لأنّ النباتات تتكاثر بشكل مختلف في كلّ مكان"},{"id":"d","text":"لا يوجد فرق حقيقي بين الوسطين"}]'::jsonb, 'a', 'غابة عين دراهم رطبة غزيرة الأمطار بينما الواحة جافة قليلة الأمطار وحارّة؛ فتلائم كلّ منطقة كائنات تتحمّل عواملها المناخية، لا اختيارًا عشوائيًّا ولا فرقًا وهميًّا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7d22a79c-1b15-5f58-8bcb-75385962fdf1', 'b996e1b4-c072-5d2d-81ed-0e4e73b03188', 'sciences-vie-terre-7eme', '⭐ تمرين: الكائنات الحيّة ومكوّنات الوسط', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6fd0a15f-9449-527e-9ceb-502221d4ee0c', '7d22a79c-1b15-5f58-8bcb-75385962fdf1', 'أيّ ممّا يلي يُعدّ كائنًا حيًّا؟', '[{"id":"a","text":"شجرة الزيتون"},{"id":"b","text":"صخرة"},{"id":"c","text":"سحابة"},{"id":"d","text":"الماء"}]'::jsonb, 'a', 'شجرة الزيتون كائن حيّ لأنّها تتنفّس وتتغذّى وتنمو وتتكاثر. أمّا الصخرة والسحابة والماء فأجسام غير حيّة لا تقوم بهذه الوظائف مجتمعةً.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('773f0e01-81b3-5c0b-a09b-e2ffbb3fb82e', '7d22a79c-1b15-5f58-8bcb-75385962fdf1', 'ماذا نسمّي العناصر غير الحية للوسط البيئي (التربة، الماء، المناخ) بالمصطلح العلمي؟', '[{"id":"a","text":"مجموعة الكائنات الحيّة (biocénose)"},{"id":"b","text":"الوسط الفيزيائي (biotope)"},{"id":"c","text":"الأعشاب"},{"id":"d","text":"الكائنات الدقيقة"}]'::jsonb, 'b', 'العناصر غير الحية للوسط (تربة، ماء، مناخ) تُسمّى الوسط الفيزيائي (biotope). أمّا مجموعة الكائنات الحيّة (biocénose) فهي الكائنات نفسها لا العناصر غير الحية، والأعشاب والكائنات الدقيقة مجرّد أمثلة من الكائنات الحيّة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('368addf7-9758-5639-907f-9d31c399e59f', '7d22a79c-1b15-5f58-8bcb-75385962fdf1', 'القمح ساقه طريّة وقصيرة الحجم. إلى أيّ صنف من النباتات ينتمي؟', '[{"id":"a","text":"شجرة"},{"id":"b","text":"شجيرة"},{"id":"c","text":"عشب"},{"id":"d","text":"كائن دقيق"}]'::jsonb, 'c', 'القمح عشب لأنّ ساقه طريّة (غضّة) غير خشبية وحجمه قصير. الشجرة والشجيرة لهما ساق خشبية، والكائن الدقيق ليس نباتًا أصلًا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7067eb2b-ad41-5dca-aec1-9f4d734de1e0', '7d22a79c-1b15-5f58-8bcb-75385962fdf1', 'أيّ ممّا يلي كائن دقيق لا يُرى إلّا بالمجهر؟', '[{"id":"a","text":"الطائر"},{"id":"b","text":"الحشرة"},{"id":"c","text":"الثديي"},{"id":"d","text":"البكتيريا"}]'::jsonb, 'd', 'البكتيريا كائن دقيق لا يُرى إلّا باستعمال المجهر. أمّا الطائر والحشرة والثديي فحيوانات ظاهرة تُرى بالعين المجرّدة مباشرةً.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5aa22137-79ad-55c3-89be-7022a0de11d4', '7d22a79c-1b15-5f58-8bcb-75385962fdf1', 'أيّ ممّا يلي يُعدّ من العوامل المناخية غير الحيّة؟', '[{"id":"a","text":"الأمطار"},{"id":"b","text":"الأشجار"},{"id":"c","text":"الحيوانات"},{"id":"d","text":"البكتيريا"}]'::jsonb, 'a', 'الأمطار عامل مناخيّ غير حيّ يؤثّر في وفرة الكائنات ونموّها. أمّا الأشجار والحيوانات والبكتيريا فهي كائنات حيّة، لا عوامل مناخية.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f986a840-791d-574a-8186-b23f5f3ee62e', '7d22a79c-1b15-5f58-8bcb-75385962fdf1', 'لماذا يعيش نخيل التمر في الواحة بكثرة؟', '[{"id":"a","text":"لأنّ الواحة باردة جدًّا"},{"id":"b","text":"لأنّه يتحمّل الجفاف والحرارة المرتفعة"},{"id":"c","text":"لأنّ الأمطار غزيرة في الواحة"},{"id":"d","text":"لأنّه كائن دقيق"}]'::jsonb, 'b', 'نخيل التمر نبات يتحمّل الجفاف والحرارة المرتفعة، وهما عاملان مناسبان لمناخ الواحة. عكس ذلك، فالواحة حارّة لا باردة، وأمطارها نادرة جدًّا لا غزيرة، والنخيل نبات لا كائن دقيق.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('28867db7-98c1-59c4-a956-cc2fd7ad4756', 'b996e1b4-c072-5d2d-81ed-0e4e73b03188', 'sciences-vie-terre-7eme', '⚔️ زعيم الفصل ⭐⭐⭐: مكوّنات الوسط البيئي', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('67d1feb5-b39b-56ad-91d5-38c52887a785', '28867db7-98c1-59c4-a956-cc2fd7ad4756', 'لماذا لا تُعدّ النار كائنًا حيًّا رغم أنّها تتحرّك وتنتشر؟', '[{"id":"a","text":"لأنّها لا تتحرّك بسرعة"},{"id":"b","text":"لأنّها ساخنة جدًّا"},{"id":"c","text":"لأنّها لا تتنفّس ولا تتغذّى ولا تتكاثر"},{"id":"d","text":"لأنّها لا تُرى بالعين المجرّدة"}]'::jsonb, 'c', 'الحركة وحدها لا تكفي لتصنيف جسم كائنًا حيًّا؛ النار لا تتنفّس ولا تتغذّى ولا تتكاثر فهي غير حيّة رغم انتشارها. سرعتها ودرجة حرارتها ورؤيتها بالعين لا علاقة لها بمعيار الحياة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('182981c6-d125-57c1-9da3-85d1a9445c19', '28867db7-98c1-59c4-a956-cc2fd7ad4756', 'في غابة، نجد تربة ورطوبة وأشجارًا وحيوانات. ماذا يمثّل مجموع الأشجار والحيوانات فيها؟', '[{"id":"a","text":"الوسط الفيزيائي (biotope)"},{"id":"b","text":"العامل المناخي"},{"id":"c","text":"الكائن الدقيق"},{"id":"d","text":"مجموعة الكائنات الحيّة (biocénose)"}]'::jsonb, 'd', 'مجموع الأشجار والحيوانات التي تعيش معًا في الغابة يمثّل مجموعة الكائنات الحيّة (biocénose). أمّا التربة والرطوبة فهما جزء من الوسط الفيزيائي (biotope)، وهو غير الأشجار والحيوانات.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b699408d-8259-532e-b1a0-f93c8f18ecc4', '28867db7-98c1-59c4-a956-cc2fd7ad4756', 'نبتة ارتفاعها متر ونصف، لها عدّة سيقان خشبية تنطلق من قاعدتها مباشرةً. إلى أيّ صنف تنتمي رغم طولها؟', '[{"id":"a","text":"شجيرة، لأنّ لها عدّة سيقان خشبية تنطلق من القاعدة مباشرةً"},{"id":"b","text":"شجرة، لأنّها طويلة"},{"id":"c","text":"عشب، لأنّها خضراء"},{"id":"d","text":"كائن دقيق"}]'::jsonb, 'a', 'المعيار الفاصل بين الشجيرة والشجرة هو عدد السيقان لا الطول: عدّة سيقان خشبية من القاعدة = شجيرة. الطول وحده لا يكفي (بعض الشجيرات طويلة نسبيًّا)، وساقها خشبية فليست عشبًا، وهي نبات لا كائن دقيق.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6f09772d-cc25-5b54-9362-dd070884ad75', '28867db7-98c1-59c4-a956-cc2fd7ad4756', 'لماذا لا يصحّ القول إنّ الكائنات الدقيقة أقلّ أهمّية من الحيوانات الظاهرة؟', '[{"id":"a","text":"لأنّها في الحقيقة أكبر حجمًا من الحيوانات الظاهرة"},{"id":"b","text":"لأنّها موجودة بأعداد هائلة ولها أدوار أساسية في الوسط رغم صغر حجمها"},{"id":"c","text":"لأنّها غير حيّة أصلًا"},{"id":"d","text":"لأنّها توجد فقط في المخابر"}]'::jsonb, 'b', 'رغم صغر حجمها، توجد الكائنات الدقيقة بأعداد هائلة في التربة والماء والهواء ولها أدوار أساسية في الوسط البيئي. الخطأ الشائع هو الحكم على أهمّية الكائن بحجمه فقط؛ وهي كائنات حيّة حقيقية موجودة في الطبيعة لا في المخابر فقط.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c6db57f2-c344-51eb-8c80-ba17ee94ee01', '28867db7-98c1-59c4-a956-cc2fd7ad4756', 'في منطقة ترتفع فيها الحرارة وتقلّ فيها الأمطار طوال السنة، ماذا نتوقّع بخصوص الرطوبة والنباتات؟', '[{"id":"a","text":"رطوبة مرتفعة ونباتات مائية"},{"id":"b","text":"لا علاقة بين الحرارة والرطوبة"},{"id":"c","text":"تكاثر نباتات الغابة الرطبة"},{"id":"d","text":"رطوبة منخفضة ونباتات تتحمّل الجفاف"}]'::jsonb, 'd', 'ارتفاع الحرارة وندرة الأمطار يؤدّيان معًا إلى رطوبة منخفضة، فتستقرّ في هذه المنطقة نباتات تتحمّل الجفاف. عوامل المناخ مترابطة لا منفصلة، ونباتات الغابة الرطبة والنباتات المائية لا تلائم مثل هذا المناخ الجافّ.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('790dd7f1-b610-5983-b006-fccde71c7709', '28867db7-98c1-59c4-a956-cc2fd7ad4756', 'قورنت غابة عين دراهم بالواحة، فوُجد أنّ نباتات الغابة تحتاج رطوبة عالية بينما نباتات الواحة تتحمّل الجفاف. ما التفسير العلمي لهذا الاختلاف؟', '[{"id":"a","text":"الصدفة وحدها"},{"id":"b","text":"اختلاف عوامل المناخ (الأمطار والرطوبة) بين الوسطين يفرض تكيّف كائنات مختلفة"},{"id":"c","text":"النباتات تختار مكانها بإرادتها"},{"id":"d","text":"لا يوجد اختلاف حقيقي بين الوسطين"}]'::jsonb, 'b', 'غابة عين دراهم غزيرة الأمطار عالية الرطوبة، بينما الواحة نادرة الأمطار جافّة؛ فتتوزّع الكائنات الحيّة تبعًا لهذا الاختلاف في عوامل المناخ لا صدفةً ولا باختيار إرادي من النباتات.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('07c28a0d-f813-5b1f-951b-46d66b0db549', 'b996e1b4-c072-5d2d-81ed-0e4e73b03188', 'sciences-vie-terre-7eme', '⭐⭐ تمرين مراجعة (نمط امتحان): مكوّنات الوسط البيئي', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2d0a642a-d010-5b9b-a368-966ee0ca20da', '07c28a0d-f813-5b1f-951b-46d66b0db549', 'ما هي الوظائف التي يقوم بها الكائن الحيّ؟', '[{"id":"a","text":"التنفّس والتغذية والنموّ والتكاثر"},{"id":"b","text":"التنفّس فقط"},{"id":"c","text":"التكاثر فقط"},{"id":"d","text":"الحركة فقط"}]'::jsonb, 'a', 'الكائن الحيّ يقوم بمجموعة وظائف مجتمعة: التنفّس والتغذية والنموّ والقدرة على التكاثر. القيام بوظيفة واحدة فقط (تنفّس، تكاثر، أو حركة) لا يكفي وحده لتصنيف جسم كائنًا حيًّا.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c332a0a8-755e-5f90-8094-d8883f11ad54', '07c28a0d-f813-5b1f-951b-46d66b0db549', 'البلّورة تكبر حجمها بمرور الوقت. هل هي كائن حيّ؟', '[{"id":"a","text":"نعم، لأنّها تكبر"},{"id":"b","text":"لا، لأنّها لا تتنفّس ولا تتغذّى ولا تتكاثر"},{"id":"c","text":"نعم، لأنّها صلبة"},{"id":"d","text":"لا يمكن الجزم"}]'::jsonb, 'b', 'نموّ الحجم وحده لا يعني أنّ الجسم حيّ؛ فالبلّورة تكبر دون أن تتنفّس أو تتغذّى أو تتكاثر، فهي غير حيّة. كونها صلبة لا علاقة له بمعيار الحياة، والجزم ممكن بتطبيق معايير الكائن الحيّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('52c5aa04-2498-5b61-b501-6ef124ab1fcc', '07c28a0d-f813-5b1f-951b-46d66b0db549', 'أيّ صنف من النباتات يتميّز بساق خشبية واحدة رئيسية (جذع)؟', '[{"id":"a","text":"الأعشاب"},{"id":"b","text":"الشجيرات"},{"id":"c","text":"الفطريات"},{"id":"d","text":"الأشجار"}]'::jsonb, 'd', 'الأشجار وحدها تتميّز بساق خشبية رئيسية واحدة (جذع) تتفرّع منه الأغصان في الأعلى. الأعشاب ساقها طريّة غير خشبية، والشجيرات لها عدّة سيقان خشبية من القاعدة، والفطريات ليست من النباتات المصنّفة حسب الساق.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('24376e6d-0b1b-570b-991b-daa35cafef4d', '07c28a0d-f813-5b1f-951b-46d66b0db549', 'ما الفرق الأساسي بين الحيوانات الظاهرة والكائنات الدقيقة؟', '[{"id":"a","text":"الكائنات الدقيقة أكبر حجمًا"},{"id":"b","text":"لا فرق بينهما"},{"id":"c","text":"الكائنات الدقيقة لا تُرى إلّا بالمجهر بينما الحيوانات الظاهرة تُرى بالعين المجرّدة"},{"id":"d","text":"الحيوانات الظاهرة غير حيّة"}]'::jsonb, 'c', 'الفرق الأساسي هو الحجم وطريقة الرؤية: الكائنات الدقيقة صغيرة جدًّا فلا تُرى إلّا بالمجهر، بينما الحيوانات الظاهرة تُرى مباشرةً بالعين المجرّدة. كلاهما كائنات حيّة، والكائنات الدقيقة أصغر لا أكبر.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f7206aa8-a327-5354-be76-f714f7fbae3f', '07c28a0d-f813-5b1f-951b-46d66b0db549', 'أيّ عامل من العوامل التالية ليس عاملًا مناخيًّا؟', '[{"id":"a","text":"نوع الحيوانات الموجودة"},{"id":"b","text":"الحرارة"},{"id":"c","text":"الرياح"},{"id":"d","text":"الأمطار"}]'::jsonb, 'a', 'نوع الحيوانات الموجودة جزء من مجموعة الكائنات الحيّة (biocénose)، لا عاملًا مناخيًّا غير حيّ. أمّا الحرارة والرياح والأمطار فهي من العوامل المناخية الأربعة غير الحية للوسط.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('93bad6a3-4dc5-5212-88b0-722cd2968f95', '07c28a0d-f813-5b1f-951b-46d66b0db549', 'لماذا تختلف الكائنات الحيّة الموجودة في الساحل عن تلك الموجودة في الواحة؟', '[{"id":"a","text":"لأنّ الساحل أقرب إلى المدينة"},{"id":"b","text":"لاختلاف عوامل المناخ (الرطوبة والرياح والأمطار) بين الوسطين"},{"id":"c","text":"لأنّ الواحة أجمل"},{"id":"d","text":"لا يوجد اختلاف"}]'::jsonb, 'b', 'الساحل رطوبته متوسّطة وتهبّ عليه رياح بحرية، بينما الواحة حارّة جافّة نادرة الأمطار؛ فيختلف توزّع الكائنات الحيّة تبعًا لاختلاف هذه العوامل المناخية، لا لبعد المسافة أو معايير جمالية.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d6b323a7-a8c3-55be-92e4-d965fd79d316', 'b996e1b4-c072-5d2d-81ed-0e4e73b03188', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: تحليل ومقارنة الأوساط البيئية', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0f64b1e6-d727-5245-9720-4bf97a56ec9b', 'd6b323a7-a8c3-55be-92e4-d965fd79d316', 'لاحظ تلميذ في حديقة المدرسة: صخرة، نملة، ماء، شجرة صنوبر، سحابة. كم عنصرًا من هذه العناصر الخمسة يُعدّ كائنًا حيًّا؟', '[{"id":"a","text":"ثلاثة عناصر"},{"id":"b","text":"عنصر واحد فقط"},{"id":"c","text":"عنصران (النملة وشجرة الصنوبر)"},{"id":"d","text":"كلّ العناصر الخمسة"}]'::jsonb, 'c', 'من بين العناصر الخمسة، تتنفّس النملة وشجرة الصنوبر وتتغذّيان وتنموان وتتكاثران فهما كائنان حيّان، بينما الصخرة والماء والسحابة أجسام غير حيّة. العدد الصحيح إذن هو عنصران لا ثلاثة ولا واحد ولا خمسة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cf2f9c50-84ec-5f62-a4d7-696dc88dba55', 'd6b323a7-a8c3-55be-92e4-d965fd79d316', 'في وسط بيئي معيّن، سُجّلت درجة حرارة مرتفعة، أمطار نادرة، تربة رملية، نخيل، وجمال. ما الذي يمثّل التربة ودرجة الحرارة في هذا الوسط؟', '[{"id":"a","text":"الوسط الفيزيائي (biotope)"},{"id":"b","text":"مجموعة الكائنات الحيّة (biocénose)"},{"id":"c","text":"النخيل والجمال"},{"id":"d","text":"الأمطار فقط"}]'::jsonb, 'a', 'التربة ودرجة الحرارة عنصران غير حيّين، فهما يمثّلان الوسط الفيزيائي (biotope). أمّا النخيل والجمال فهما جزء من مجموعة الكائنات الحيّة (biocénose)، لا من الوسط الفيزيائي.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9670f50f-76c2-58ba-ac13-c6be87b47f2f', 'd6b323a7-a8c3-55be-92e4-d965fd79d316', 'أيّ العبارات التالية صحيحة؟', '[{"id":"a","text":"كلّ جسم يتحرّك أو يتغيّر حجمه هو كائن حيّ"},{"id":"b","text":"الشجيرة والشجرة كلتاهما لهما ساق خشبية، لكنّ الشجرة لها جذع واحد بينما للشجيرة عدّة سيقان"},{"id":"c","text":"الكائنات الدقيقة غير موجودة في الأوساط البيئية العادية"},{"id":"d","text":"عوامل المناخ لا تؤثّر في توزّع الكائنات الحيّة"}]'::jsonb, 'b', 'العبارة الصحيحة الوحيدة هي أنّ الشجيرة والشجرة كلتاهما خشبيّتا الساق، لكنّ الشجرة لها جذع رئيسي واحد بينما للشجيرة عدّة سيقان. الحركة/النموّ وحدهما لا يعنيان الحياة، والكائنات الدقيقة موجودة بكثرة في كلّ وسط عادي، وعوامل المناخ تؤثّر فعليًّا في توزّع الكائنات.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f948e127-4f85-55d5-8310-877d22e758f5', 'd6b323a7-a8c3-55be-92e4-d965fd79d316', 'لوحظ أنّ منطقة ما تعيش فيها نباتات تتحمّل الملوحة وطيور بحرية، وتهبّ عليها رياح بحرية بانتظام. أيّ وسط تونسي يُرجَّح أن يكون هذا؟', '[{"id":"a","text":"الواحة"},{"id":"b","text":"غابة عين دراهم"},{"id":"c","text":"لا يمكن تحديد الوسط من هذه المعطيات"},{"id":"d","text":"الساحل"}]'::jsonb, 'd', 'الملوحة والطيور البحرية والرياح البحرية المنتظمة سمات مميّزة للساحل. الواحة جافّة بعيدة عن البحر، وغابة عين دراهم رطبة داخلية، فالمعطيات تحدّد الوسط بوضوح: الساحل.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7b61513a-3984-548a-987a-36642f9cd8ad', 'd6b323a7-a8c3-55be-92e4-d965fd79d316', 'قال تلميذ: «المجهر يُستعمل لأنّ الكائنات الدقيقة كائنات غير حيّة صغيرة الحجم فقط.» أين الخطأ في هذه العبارة؟', '[{"id":"a","text":"لا يوجد خطأ في العبارة"},{"id":"b","text":"الخطأ أنّ الكائنات الدقيقة كائنات حيّة فعلًا، وتحتاج المجهر بسبب صغر حجمها فقط لا لأنّها غير حيّة"},{"id":"c","text":"الخطأ أنّ المجهر لا يُستعمل لرؤيتها"},{"id":"d","text":"الخطأ أنّها كبيرة الحجم لا صغيرة"}]'::jsonb, 'b', 'الكائنات الدقيقة (كالبكتيريا) كائنات حيّة حقيقية تقوم بوظائف الحياة، والمجهر ضروري بسبب صغر حجمها فقط، لا لأنّها غير حيّة. هذا سؤال «اكتشاف الخطأ»: الجملة الأصلية للتلميذ خاطئة، والخيار الصحيح هو الذي يحدّد موضع الخطأ بدقّة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a707e4b0-88ef-5440-8ead-56b1001cab49', 'd6b323a7-a8c3-55be-92e4-d965fd79d316', 'في غابة عين دراهم تعيش السرخس (نبات يحتاج رطوبة عالية باستمرار)، بينما لا يمكنه العيش في الواحة. فسّر ذلك بربط عاملين مناخيّين اثنين بمكوّنات الوسط.', '[{"id":"a","text":"الأمطار الغزيرة والرطوبة العالية في الغابة توفّران له حاجته، بينما ندرة الأمطار وجفاف الواحة لا يوفّرانها"},{"id":"b","text":"درجة الحرارة فقط هي السبب، والأمطار لا علاقة لها"},{"id":"c","text":"لأنّ السرخس عشب لا يحتاج ماء إطلاقًا"},{"id":"d","text":"لأنّ الواحة بها كائنات دقيقة تمنعه"}]'::jsonb, 'a', 'السرخس يحتاج رطوبة عالية باستمرار؛ وتوفّرها غابة عين دراهم بأمطارها الغزيرة، بينما تفتقدها الواحة لندرة أمطارها وجفافها. الحرارة وحدها لا تكفي تفسيرًا (لا بدّ من ربطها بالأمطار)، والسرخس يحتاج ماء فعلًا، والكائنات الدقيقة لا تمنع نموّ النباتات.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c236d912-19a9-58e4-8078-a8d4cb0e75e3', 'b996e1b4-c072-5d2d-81ed-0e4e73b03188', 'sciences-vie-terre-7eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): مكوّنات الوسط البيئي', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ded91366-befd-565c-9e8b-de1887f335ca', 'c236d912-19a9-58e4-8078-a8d4cb0e75e3', 'أيّ من العناصر التالية يُعدّ جسمًا غير حيّ رغم وجوده في وسط بيئي؟', '[{"id":"a","text":"الحشرة"},{"id":"b","text":"الماء"},{"id":"c","text":"شجرة الزيتون"},{"id":"d","text":"البكتيريا"}]'::jsonb, 'b', 'الماء جسم غير حيّ من العناصر غير الحية للوسط البيئي، رغم أنّه ضروري لحياة الكائنات. الحشرة وشجرة الزيتون والبكتيريا كائنات حيّة تتنفّس وتتغذّى وتتكاثر.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5e728c61-0cd8-5dd1-a3a5-211ecc35300f', 'c236d912-19a9-58e4-8078-a8d4cb0e75e3', 'ما اسم مجموع الكائنات الحيّة التي تعيش معًا في وسط بيئي واحد؟', '[{"id":"a","text":"الوسط الفيزيائي (biotope)"},{"id":"b","text":"العامل المناخي"},{"id":"c","text":"مجموعة الكائنات الحيّة (biocénose)"},{"id":"d","text":"التربة"}]'::jsonb, 'c', 'مجموع الكائنات الحيّة التي تعيش معًا في وسط بيئي واحد يُسمّى مجموعة الكائنات الحيّة (biocénose). أمّا الوسط الفيزيائي والعامل المناخي والتربة فعناصر غير حية، لا كائنات.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d8858ada-51ef-5a0e-a34d-9a1cf694bd1f', 'c236d912-19a9-58e4-8078-a8d4cb0e75e3', 'شجيرة الدفلة لها عدّة سيقان خشبية من القاعدة وارتفاعها متران. لماذا لا تُصنَّف شجرة رغم ارتفاعها؟', '[{"id":"a","text":"لأنّها غير خشبية"},{"id":"b","text":"لأنّها عشب صغير"},{"id":"c","text":"لأنّها كائن دقيق"},{"id":"d","text":"لأنّ التصنيف يعتمد على عدد السيقان لا الارتفاع فقط، ولها عدّة سيقان لا جذع واحد"}]'::jsonb, 'd', 'معيار التصنيف بين الشجيرة والشجرة هو عدد السيقان الخشبية لا الطول: الدفلة لها عدّة سيقان من القاعدة، فتبقى شجيرة مهما زاد ارتفاعها. وهي خشبية الساق فعلًا، وليست عشبًا ولا كائنًا دقيقًا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e8a9980b-a277-5bdd-9b52-8256052f48b9', 'c236d912-19a9-58e4-8078-a8d4cb0e75e3', 'لماذا تُعتبر الفطريات المجهرية والبكتيريا جزءًا من مجموعة الكائنات الحيّة في الوسط البيئي رغم عدم رؤيتها بالعين المجرّدة؟', '[{"id":"a","text":"لأنّها تقوم بوظائف الكائن الحيّ (تتغذّى وتنمو وتتكاثر) رغم صغر حجمها"},{"id":"b","text":"لأنّها مصنوعة من مواد معدنية"},{"id":"c","text":"لأنّها جزء من التربة فقط لا كائنات حقيقية"},{"id":"d","text":"لأنّ المجهر يخترعها"}]'::jsonb, 'a', 'معيار الانتماء إلى الكائنات الحيّة هو القيام بوظائف الحياة (تغذية، نموّ، تكاثر)، وهذا ما تفعله الفطريات المجهرية والبكتيريا رغم صغر حجمها، لا حجمها أو مكان وجودها. المجهر أداة رؤية فقط، لا يخترع الكائنات.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('49da1540-0406-5dca-8076-512a30cabef3', 'c236d912-19a9-58e4-8078-a8d4cb0e75e3', 'ما العلاقة بين قلّة الأمطار وارتفاع الحرارة في منطقة ما، وتوزّع النباتات فيها؟', '[{"id":"a","text":"لا علاقة بينهما"},{"id":"b","text":"تؤدّي إلى استقرار نباتات تتحمّل الجفاف كنخيل التمر بدل نباتات تحتاج رطوبة عالية"},{"id":"c","text":"تزيد كثافة الغابات الرطبة"},{"id":"d","text":"تمنع وجود أيّ كائن حيّ في المنطقة"}]'::jsonb, 'b', 'قلّة الأمطار وارتفاع الحرارة يخلقان مناخًا جافًّا، فتستقرّ فيه نباتات تتحمّل الجفاف كنخيل التمر بدل نباتات الغابة الرطبة. المناخ الجافّ لا يمنع الحياة كلّها، بل يفرز كائنات ملائمة له.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ca35affc-8d5a-569a-a033-975e9bfdfb6f', 'c236d912-19a9-58e4-8078-a8d4cb0e75e3', 'قارن بين وسطين: الأوّل حرارته معتدلة وأمطاره غزيرة، والثاني حرارته مرتفعة وأمطاره نادرة جدًّا. أيّ عبارة صحيحة؟', '[{"id":"a","text":"الوسط الأوّل يلائم كائنات تحبّ الرطوبة كالسرخس، والثاني يلائم كائنات تتحمّل الجفاف كالجمل"},{"id":"b","text":"كلا الوسطين يلائمان نفس الكائنات تمامًا"},{"id":"c","text":"الوسط الثاني وحده يحوي كائنات حيّة"},{"id":"d","text":"عوامل المناخ لا تحدّد نوع الكائنات"}]'::jsonb, 'a', 'اختلاف الحرارة والأمطار بين الوسطين يفرز كائنات مختلفة: الوسط الرطب المعتدل يلائم كائنات محبّة للرطوبة كالسرخس، والوسط الحارّ الجافّ يلائم كائنات متحمّلة للجفاف كالجمل. كلا الوسطين يحويان كائنات حيّة، لكن مختلفة لا متشابهة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('60173e6c-17ba-57b7-b5ed-d281f07ca6c1', 'b996e1b4-c072-5d2d-81ed-0e4e73b03188', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐ (القمّة): مكوّنات الوسط البيئي', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8b50beaa-ca60-5d54-9c91-f892c6387949', '60173e6c-17ba-57b7-b5ed-d281f07ca6c1', 'دُوّنت في جدول ملاحظات وسط بيئي: حرارة مرتفعة (حوالي 35 °C)، أمطار سنوية ضعيفة جدًّا، رطوبة منخفضة، نباتات: نخيل التمر. أيّ وسط تونسي يطابق هذه المعطيات؟', '[{"id":"a","text":"غابة عين دراهم"},{"id":"b","text":"الساحل"},{"id":"c","text":"الواحة"},{"id":"d","text":"لا يمكن التحديد"}]'::jsonb, 'c', 'الحرارة المرتفعة (حوالي 35 °C)، ضعف الأمطار، الرطوبة المنخفضة، ووجود نخيل التمر كلّها سمات مطابقة للواحة. غابة عين دراهم رطبة معتدلة الحرارة، والساحل ذو رطوبة متوسّطة ورياح بحرية، فلا يطابقان هذه المعطيات.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c5586041-2e7a-5935-94b4-ac149fb9d662', '60173e6c-17ba-57b7-b5ed-d281f07ca6c1', 'في دراسة حديقة مدرسية، وُجد: تربة، ضوء الشمس، فراشات، نمل، وردة، وحجر. اعتمادًا على تعريف الوسط البيئي، ما الذي يمثّل «الوسط الفيزيائي (biotope)» من هذه القائمة؟', '[{"id":"a","text":"الفراشات والنمل والوردة"},{"id":"b","text":"التربة وضوء الشمس والحجر"},{"id":"c","text":"كلّ العناصر بلا استثناء"},{"id":"d","text":"الوردة فقط"}]'::jsonb, 'b', 'الوسط الفيزيائي (biotope) يضمّ العناصر غير الحية فقط: التربة وضوء الشمس والحجر. أمّا الفراشات والنمل والوردة فكائنات حيّة تنتمي إلى مجموعة الكائنات الحيّة (biocénose)، لا إلى الوسط الفيزيائي.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('300eea73-b293-50ae-9194-aea0112b3562', '60173e6c-17ba-57b7-b5ed-d281f07ca6c1', 'هل يمكن اعتبار مجموعة أسماك في بركة ماء دون أن نذكر الماء والتربة والحرارة «وسطًا بيئيًّا» كاملًا؟', '[{"id":"a","text":"نعم، الكائنات الحيّة وحدها تكفي لتكوين وسط بيئي"},{"id":"b","text":"نعم، لأنّ الأسماك تكوّن وسطها بنفسها"},{"id":"c","text":"لا علاقة بين الماء والوسط البيئي"},{"id":"d","text":"لا، لأنّ الوسط البيئي يستلزم وجود العناصر غير الحية مع الكائنات الحيّة معًا"}]'::jsonb, 'd', 'تعريف الوسط البيئي يستلزم العنصرين معًا: العناصر غير الحية (كالماء والتربة والحرارة) ومجموعة الكائنات الحيّة. ذكر الأسماك وحدها دون عناصرها غير الحية يجعل الوصف ناقصًا، فالماء عنصر أساسي لا يمكن الاستغناء عنه.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c1f2d6b4-e2c8-50fe-9f9f-27cde73a01b4', '60173e6c-17ba-57b7-b5ed-d281f07ca6c1', 'أيّ العبارات الأربع التالية **خاطئة**؟', '[{"id":"a","text":"الأمطار والحرارة والرياح والرطوبة عوامل مناخية غير حيّة"},{"id":"b","text":"الشجرة تتميّز بجذع رئيسي واحد"},{"id":"c","text":"كلّ الكائنات الدقيقة غير حيّة لأنّها لا تُرى بالعين المجرّدة"},{"id":"d","text":"الوسط البيئي يضمّ عناصر غير حية وكائنات حيّة معًا"}]'::jsonb, 'c', 'العبارة الخاطئة هي أنّ الكائنات الدقيقة غير حيّة: فهي كائنات حيّة حقيقية تقوم بوظائف الحياة، وعدم رؤيتها بالعين المجرّدة سببه صغر حجمها فقط لا انعدام حياتها. العبارات الثلاث الأخرى صحيحة تمامًا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('218bfdae-81ca-5ac9-a58d-7706f03330b7', '60173e6c-17ba-57b7-b5ed-d281f07ca6c1', 'عُلم أنّ منطقة ما يعيش فيها الخنزير البرّي والسرخس، وأنّ هذين الكائنين يحتاجان رطوبة عالية باستمرار. إذا انخفضت الأمطار في هذه المنطقة بشكل كبير ودائم، فما الأثر المتوقّع؟', '[{"id":"a","text":"اختفاء تدريجي للكائنات التي تحتاج رطوبة عالية واستقرار كائنات أكثر تحمّلًا للجفاف"},{"id":"b","text":"بقاء نفس الكائنات دون أيّ تغيير"},{"id":"c","text":"زيادة أعداد السرخس"},{"id":"d","text":"تحوّل الخنزير البرّي إلى كائن دقيق"}]'::jsonb, 'a', 'انخفاض الأمطار بشكل كبير ودائم يقلّل الرطوبة، فتضعف الكائنات التي تحتاجها بشدّة كالسرخس والخنزير البرّي وقد تختفي تدريجيًّا، بينما تستقرّ محلّها كائنات أكثر تحمّلًا للجفاف. الكائنات لا تبقى دون تأثّر، ولا يزيد السرخس في الجفاف، ولا يتحوّل حيوان إلى كائن دقيق.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a91a73de-6243-5c39-b9ff-c5222f4996ac', '60173e6c-17ba-57b7-b5ed-d281f07ca6c1', 'لوحظ في وسط بيئي جافّ وحارّ نموّ نباتات قصيرة ذات سيقان طريّة فقط، بينما غابت الأشجار الكبيرة ذات الجذوع الخشبية. ما التفسير الأرجح لغياب الأشجار الكبيرة في هذا الوسط؟', '[{"id":"a","text":"الأشجار لا تحتاج ماء إطلاقًا فلا علاقة للأمر بالجفاف"},{"id":"b","text":"الأشجار الكبيرة تحتاج غالبًا كمّيات ماء أكبر لا تتوفّر في وسط جافّ وحارّ كهذا"},{"id":"c","text":"الأعشاب أكبر حجمًا من الأشجار فتفضّل هذا الوسط"},{"id":"d","text":"الحرارة المرتفعة تحوّل الأشجار إلى أعشاب"}]'::jsonb, 'b', 'حجم الشجرة الكبير يستلزم عادةً كمّيات ماء أكبر لنموّها، وهذا غير متوفّر في وسط جافّ حارّ قليل الأمطار؛ فتستقرّ فيه أعشاب أقلّ حاجةً للماء. الأشجار تحتاج ماء فعلًا، والأعشاب أصغر حجمًا لا أكبر، ولا يتحوّل نوع نباتي إلى آخر بفعل الحرارة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f10285e8-add4-5166-8f40-19215d69d44b', 'daaff8ab-c8e6-5332-bace-bd5469068bae', 'sciences-vie-terre-7eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b84acd11-802a-508d-9521-bce330353cdf', 'f10285e8-add4-5166-8f40-19215d69d44b', 'أثناء التبادلات الغازية التنفّسية، ماذا يفعل الكائن الحيّ؟', '[{"id":"a","text":"يمتصّ ثاني أكسيد الكربون ويطرح الأكسجين"},{"id":"b","text":"يمتصّ الأكسجين ويطرح ثاني أكسيد الكربون"},{"id":"c","text":"يمتصّ الأكسجين وثاني أكسيد الكربون معًا دون طرح شيء"},{"id":"d","text":"يطرح الأكسجين وثاني أكسيد الكربون معًا دون امتصاص شيء"}]'::jsonb, 'b', 'التنفّس تبادل غازي ثابت الاتّجاه عند كلّ الكائنات الحيّة: امتصاص الأكسجين (O₂) من الوسط وطرح ثاني أكسيد الكربون (CO₂) فيه، مهما كان الوسط أو العضو التنفّسي المستعمل.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6663fd19-3a28-5ad0-8fa0-030624c5819b', 'f10285e8-add4-5166-8f40-19215d69d44b', 'بأيّ عضو يتنفّس الأرنب، وهو حيوان فقاري يعيش في الوسط الهوائي؟', '[{"id":"a","text":"بالخياشيم"},{"id":"b","text":"بالقصبات الهوائية"},{"id":"c","text":"بالرئتين"},{"id":"d","text":"بجلده فقط"}]'::jsonb, 'c', 'الأرنب فقاريّ يعيش على اليابسة، فيتنفّس برئتين: يدخل الهواء عبر الأنف فالقصبة الهوائية وصولًا إلى الرئتين حيث يحدث التبادل الغازي.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('841a7c72-e85e-51ec-be94-814b9f951065', 'f10285e8-add4-5166-8f40-19215d69d44b', 'الجرادة حشرة تعيش في الوسط الهوائي لكن بلا رئتين. بأيّ عضو تتنفّس؟', '[{"id":"a","text":"بالخياشيم"},{"id":"b","text":"بالرئتين مثل الأرنب"},{"id":"c","text":"لا تتنفّس إطلاقًا"},{"id":"d","text":"بالقصبات الهوائية"}]'::jsonb, 'd', 'الحشرات مثل الجرادة تتنفّس بشبكة من القصبات الهوائية: يدخل الهواء من ثغور تنفّسية على جانبَي الجسم ويتوزّع مباشرة داخل القصبات المتفرّعة إلى مختلف الأعضاء.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6fc89fe3-b37b-5831-9436-96d587a26e2d', 'f10285e8-add4-5166-8f40-19215d69d44b', 'أين توجد خياشيم السمكة، وماذا تمتصّ منها؟', '[{"id":"a","text":"في الرأس تحت الغطاء الخيشومي، وتمتصّ الأكسجين المذاب في الماء"},{"id":"b","text":"في الذيل، وتمتصّ ثاني أكسيد الكربون من الماء"},{"id":"c","text":"في الرأس تحت الغطاء الخيشومي، وتمتصّ الهواء مباشرة من فوق سطح الماء"},{"id":"d","text":"لا توجد للسمكة خياشيم بل رئتان صغيرتان"}]'::jsonb, 'a', 'خياشيم السمكة توجد على جانبَي رأسها تحت الغطاء الخيشومي، ويمرّ الماء فوقها فتمتصّ الأكسجين المذاب فيه إلى الدم وتطرح ثاني أكسيد الكربون منه إلى الماء.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('35358fff-8f68-52e2-8d18-0006c142751c', 'f10285e8-add4-5166-8f40-19215d69d44b', 'في تجربة وُضعت فيها حشرات حيّة داخل وعاء متّصل بأنبوب ماء جير رائق، وبعد مدّة تكدّر ماء الجير. بماذا يفسَّر هذا التكدّر؟', '[{"id":"a","text":"بامتصاص الحشرات للماء الموجود في الأنبوب"},{"id":"b","text":"بطرح الحشرات لثاني أكسيد الكربون الذي يتفاعل مع ماء الجير"},{"id":"c","text":"بارتفاع حرارة الوعاء المغلق"},{"id":"d","text":"بامتصاص الحشرات لثاني أكسيد الكربون من ماء الجير"}]'::jsonb, 'b', 'تكدّر ماء الجير الرائق دليل على وجود ثاني أكسيد الكربون: تطرحه الحشرات أثناء تنفّسها فيتفاعل مع ماء الجير ويفقده شفافيته، بعكس وعاء الشاهد الذي يبقى رائقًا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6f9752f7-ff29-5e27-bc51-078e7d629980', 'daaff8ab-c8e6-5332-bace-bd5469068bae', 'sciences-vie-terre-7eme', '⭐ تمرين: التنفّس عند الكائنات الحية', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6c824b26-9508-57a4-8472-61e78f82f0d9', '6f9752f7-ff29-5e27-bc51-078e7d629980', 'أثناء تنفّس أيّ كائن حيّ، أيّ غاز يمتصّه من وسطه؟', '[{"id":"a","text":"ثاني أكسيد الكربون"},{"id":"b","text":"الأكسجين"},{"id":"c","text":"بخار الماء"},{"id":"d","text":"النتروجين"}]'::jsonb, 'b', 'كلّ كائن حيّ يمتصّ الأكسجين (O₂) من وسطه أثناء التنفّس، ويطرح ثاني أكسيد الكربون (CO₂) فيه، مهما كان العضو التنفّسي المستعمل.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('84edca86-55e0-5ddb-9acd-b6606f488c9d', '6f9752f7-ff29-5e27-bc51-078e7d629980', 'الحمامة طائر فقاريّ يعيش في الوسط الهوائي. بأيّ عضو تتنفّس؟', '[{"id":"a","text":"بالقصبات الهوائية"},{"id":"b","text":"بالخياشيم"},{"id":"c","text":"برئتين"},{"id":"d","text":"بجلدها فقط"}]'::jsonb, 'c', 'الحمامة حيوان فقاريّ يعيش على اليابسة، فهي تتنفّس برئتين، مثل بقية الفقاريات البرّية.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7cb1a2e2-4050-5df6-87d0-485f398b3992', '6f9752f7-ff29-5e27-bc51-078e7d629980', 'النملة حشرة تعيش في الوسط الهوائي لكن بلا رئتين. بأيّ عضو تتنفّس؟', '[{"id":"a","text":"برئتين صغيرتين"},{"id":"b","text":"بالقصبات الهوائية"},{"id":"c","text":"بالخياشيم"},{"id":"d","text":"بقصبة هوائية واحدة فقط"}]'::jsonb, 'b', 'النملة، مثل كلّ الحشرات، تتنفّس بشبكة من القصبات الهوائية المتفرّعة داخل جسمها، لا برئتين.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('869a5926-cc7c-575a-9e87-8eb6b8c795ad', '6f9752f7-ff29-5e27-bc51-078e7d629980', 'السردين سمكة تعيش في ماء البحر. بأيّ عضو تتنفّس؟', '[{"id":"a","text":"بالخياشيم"},{"id":"b","text":"برئتين"},{"id":"c","text":"بالقصبات الهوائية"},{"id":"d","text":"بفمها فقط دون عضو خاصّ"}]'::jsonb, 'a', 'السردين، مثل بقية الأسماك، يتنفّس بالخياشيم التي تمتصّ الأكسجين المذاب في الماء.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('729adbb7-da23-5a98-b865-84eded971ead', '6f9752f7-ff29-5e27-bc51-078e7d629980', 'ما الترتيب الصحيح لمسار الهواء عند فقاريّ بريّ مثل الأرنب؟', '[{"id":"a","text":"رئتان ← قصبة هوائية ← أنف"},{"id":"b","text":"أنف ← رئتان ← قصبة هوائية"},{"id":"c","text":"قصبة هوائية ← أنف ← رئتان"},{"id":"d","text":"أنف ← قصبة هوائية ← رئتان"}]'::jsonb, 'd', 'يدخل الهواء عند الفقاريات البرّية عبر الأنف، ثمّ يمرّ بالقصبة الهوائية، ليصل أخيرًا إلى الرئتين حيث يحدث التبادل الغازي.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('847d8d78-e4f7-59fe-b34c-6d9786aa8450', '6f9752f7-ff29-5e27-bc51-078e7d629980', 'ما اسم الفتحات الصغيرة الموجودة على جانبَي جسم الحشرة، والتي يدخل منها الهواء إلى القصبات الهوائية؟', '[{"id":"a","text":"الغطاء الخيشومي"},{"id":"b","text":"الحويصلات الهوائية"},{"id":"c","text":"الثغور التنفّسية"},{"id":"d","text":"الأنابيب الشعبية"}]'::jsonb, 'c', 'الهواء يدخل جسم الحشرة عبر فتحات صغيرة على جانبَي جسمها تُسمّى الثغور التنفّسية، ومنها يتوزّع داخل شبكة القصبات الهوائية.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5927e75d-44cf-5855-b1eb-b733a74351d2', 'daaff8ab-c8e6-5332-bace-bd5469068bae', 'sciences-vie-terre-7eme', '⚔️ زعيم الفصل ⭐⭐⭐: التنفّس عند الكائنات الحية', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fd79766c-7fb4-5179-b97b-b09ac8abd538', '5927e75d-44cf-5855-b1eb-b733a74351d2', 'الأفعى حيوان فقاريّ يعيش على اليابسة. بأيّ عضو تتنفّس؟', '[{"id":"a","text":"بالخياشيم"},{"id":"b","text":"برئتين"},{"id":"c","text":"بالقصبات الهوائية"},{"id":"d","text":"بجلدها فقط"}]'::jsonb, 'b', 'الأفعى فقاريّ بريّ، فتتنفّس برئتين مثل بقية الفقاريات التي تعيش في الوسط الهوائي.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('485d5190-6be2-5cbd-a32a-124d8946a059', '5927e75d-44cf-5855-b1eb-b733a74351d2', 'ما الفرق الدقيق بين القصبة الهوائية عند الأرنب والقصبات الهوائية عند النحلة؟', '[{"id":"a","text":"لا فرق، فكلاهما يسمّى بنفس الاسم ويؤدّي نفس الدور تمامًا"},{"id":"b","text":"قصبة الأرنب أنبوب واحد يوصل الفم بالرئتين، بينما قصبات النحلة شبكة متفرّعة توزّع الهواء مباشرة داخل الجسم كلّه"},{"id":"c","text":"قصبة الأرنب توجد عند النحلة أيضًا، لكنّ العكس غير صحيح"},{"id":"d","text":"قصبات النحلة أكبر حجمًا من قصبة الأرنب"}]'::jsonb, 'b', 'قصبة الأرنب أنبوب واحد يصل الفم بالرئتين حيث يحدث التبادل الغازي، أمّا قصبات النحلة فشبكة أنابيب متفرّعة توزّع الهواء مباشرة إلى كلّ أعضاء الجسم دون رئتين.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('781d9610-631e-5367-9ba9-a26756adcd78', '5927e75d-44cf-5855-b1eb-b733a74351d2', 'ما مسار الماء الصحيح أثناء تنفّس القاروس (سمكة بحرية)؟', '[{"id":"a","text":"يدخل من فتحات الخياشيم ويخرج من الفم"},{"id":"b","text":"يدخل ويخرج من الفم فقط دون المرور فوق الخياشيم"},{"id":"c","text":"يدخل من الفم، يمرّ فوق الخياشيم، ثمّ يخرج من فتحات الخياشيم"},{"id":"d","text":"لا يحتاج الماء إلى الدخول للجسم إطلاقًا"}]'::jsonb, 'c', 'يدخل الماء عبر فم القاروس، يمرّ فوق الخياشيم حيث يُمتصّ الأكسجين المذاب فيه، ثمّ يخرج عبر فتحات الخياشيم.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0a50a529-b923-562d-89ec-69c6b2fdfb57', '5927e75d-44cf-5855-b1eb-b733a74351d2', 'لماذا يتنفّس شرغوف الضفدع بالخياشيم بينما يتنفّس الضفدع البالغ بالرئتين؟', '[{"id":"a","text":"لأنّ وسط عيشه يتغيّر من الماء إلى اليابسة مع نموّه"},{"id":"b","text":"لأنّ الشرغوف كائن غير حيّ خلافًا للضفدع البالغ"},{"id":"c","text":"الأمر عشوائيّ ولا علاقة له بوسط العيش"},{"id":"d","text":"لأنّ الضفدع البالغ يعيش دائمًا داخل الماء"}]'::jsonb, 'a', 'الشرغوف يعيش في الماء فيتنفّس بخياشيم تلائم هذا الوسط، وعندما يتحوّل إلى ضفدع بالغ يغادر الماء إلى اليابسة فيتنفّس برئتين؛ العضو التنفّسي يتكيّف مع تغيّر الوسط.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('08018eff-0ebf-5170-ad3e-0c20593a23a7', '5927e75d-44cf-5855-b1eb-b733a74351d2', 'في تجربة تنفّس، وُضعت حشرات حيّة في وعاء متّصل بماء الجير، وحُضّر إلى جانبه وعاء مماثل تمامًا لكن بدون حشرات (الشاهد). ما فائدة وعاء الشاهد؟', '[{"id":"a","text":"زيادة كمّية الحشرات المستعملة في التجربة"},{"id":"b","text":"تسريع تكدّر ماء الجير في الوعاء الأوّل"},{"id":"c","text":"التأكّد بالمقارنة أنّ تكدّر ماء الجير سببه الحشرات وحدها لا عامل آخر"},{"id":"d","text":"استبدال ماء الجير الرائق بماء جير متكدّر"}]'::jsonb, 'c', 'وعاء الشاهد يبقى بدون كائنات حيّة، فإن بقي ماء جيره رائقًا بينما تكدّر ماء الوعاء الآخر، نتأكّد أنّ التكدّر ناتج فعلًا عن طرح الحشرات لثاني أكسيد الكربون، لا عن عامل خارجيّ آخر.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7e9a0266-a9dc-5dc4-b42c-f1347fd3b464', '5927e75d-44cf-5855-b1eb-b733a74351d2', 'وُصف حيوان بأنّ عضوه التنفّسي مكوّن من صفائح رقيقة كثيرة الأوعية الدموية، محميّة بغطاء على جانبَي رأسه، ويمرّ الماء فوقها باستمرار ليجدّد الأكسجين. في أيّ وسط يعيش هذا الحيوان على الأرجح؟', '[{"id":"a","text":"في الوسط الهوائي، وهو فقاريّ بريّ"},{"id":"b","text":"في الوسط الهوائي، وهو حشرة"},{"id":"c","text":"في وسط لا يمكن تحديده من هذا الوصف"},{"id":"d","text":"في الوسط المائي"}]'::jsonb, 'd', 'الوصف يطابق الخياشيم تمامًا: صفائح رقيقة كثيرة الأوعية الدموية تحت غطاء خيشومي، يمرّ الماء فوقها باستمرار — وهذا عضو تنفّسي خاصّ بحيوانات الوسط المائي.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fd03878f-9e42-584d-aee1-dfeded694cd2', 'daaff8ab-c8e6-5332-bace-bd5469068bae', 'sciences-vie-terre-7eme', '⭐⭐ تمرين مراجعة (نمط امتحان): التنفّس عند الكائنات الحية', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('db551780-ab3d-5290-9b62-9248a47d7fa4', 'fd03878f-9e42-584d-aee1-dfeded694cd2', 'القطّ حيوان فقاريّ أليف يعيش على اليابسة. بأيّ عضو يتنفّس؟', '[{"id":"a","text":"برئتين"},{"id":"b","text":"بالقصبات الهوائية"},{"id":"c","text":"بالخياشيم"},{"id":"d","text":"بجناحيه"}]'::jsonb, 'a', 'القطّ فقاريّ بريّ، فيتنفّس برئتين، مثل كلّ الثدييات التي تعيش في الوسط الهوائي.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('76602dc6-6f63-519d-83f9-31709317b2da', 'fd03878f-9e42-584d-aee1-dfeded694cd2', 'الفراشة حشرة ملوّنة تحلّق في الحدائق. بأيّ عضو تتنفّس؟', '[{"id":"a","text":"بالخياشيم"},{"id":"b","text":"برئتين صغيرتين"},{"id":"c","text":"بالقصبات الهوائية"},{"id":"d","text":"بأجنحتها"}]'::jsonb, 'c', 'الفراشة، مثل كلّ الحشرات، تتنفّس بشبكة القصبات الهوائية التي يدخل إليها الهواء عبر الثغور التنفّسية.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f2ab30fd-7884-55e5-802c-189ece5de0b1', 'fd03878f-9e42-584d-aee1-dfeded694cd2', 'أين توجد خياشيم سمكة الدنيس بالضبط؟', '[{"id":"a","text":"داخل معدتها"},{"id":"b","text":"على جانبَي رأسها، تحت الغطاء الخيشومي"},{"id":"c","text":"في ذيلها"},{"id":"d","text":"على سطح جلدها بالكامل"}]'::jsonb, 'b', 'توجد خياشيم السمكة على جانبَي رأسها، محميّة بالغطاء الخيشومي، ويمرّ الماء فوقها لتمتصّ الأكسجين المذاب فيه.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b2286f6c-a94d-59fa-ba01-ae15795549e3', 'fd03878f-9e42-584d-aee1-dfeded694cd2', 'الحمامة تتنفّس برئتين. أيّ ممّا يلي يصف بدقّة ما يحدث داخل رئتيها؟', '[{"id":"a","text":"يطرح الدمّ الأكسجين إلى الهواء ويمتصّ ثاني أكسيد الكربون منه"},{"id":"b","text":"لا يحدث أيّ تبادل غازي داخل الرئتين"},{"id":"c","text":"يمتصّ الدمّ الأكسجين من الهواء ويطرح ثاني أكسيد الكربون فيه"},{"id":"d","text":"يمتصّ الدمّ ثاني أكسيد الكربون والأكسجين معًا دون طرح شيء"}]'::jsonb, 'c', 'داخل الرئتين، يمتصّ الدمّ الأكسجين من الهواء الداخل ويطرح ثاني أكسيد الكربون فيه ليخرج مع الزفير؛ الاتّجاه ثابت ولا يُعكس أبدًا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('87836661-3b3d-595e-a60f-3c8bedde6638', 'fd03878f-9e42-584d-aee1-dfeded694cd2', 'أيّ العبارات التالية صحيحة بخصوص العضو التنفّسي عند الكائنات الحية؟', '[{"id":"a","text":"العضو التنفّسي واحد وثابت عند جميع الكائنات الحيّة"},{"id":"b","text":"يختلف العضو التنفّسي حسب الوسط الذي يعيش فيه الكائن الحيّ"},{"id":"c","text":"الكائنات المائية لا تحتاج إلى عضو تنفّسي خاصّ"},{"id":"d","text":"الحشرات تتنفّس بنفس عضو الفقاريات البرّية"}]'::jsonb, 'b', 'العضو التنفّسي يختلف حسب وسط عيش الكائن: رئتان أو قصبات هوائية في الوسط الهوائي، وخياشيم في الوسط المائي — فهو ليس واحدًا ولا ثابتًا عند الجميع.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('449a2399-61c4-5d25-8df5-7eea9dc40e99', 'fd03878f-9e42-584d-aee1-dfeded694cd2', 'لماذا نستعمل ماء الجير الرائق في تجربة الكشف عن التبادلات الغازية التنفّسية؟', '[{"id":"a","text":"لأنّه يتبخّر بسرعة في الوعاء المغلق"},{"id":"b","text":"لأنّه يمتصّ الأكسجين من الوعاء"},{"id":"c","text":"لأنّه يغيّر لونه عند تعرّضه للضوء"},{"id":"d","text":"لأنّه يتكدّر عند وجود ثاني أكسيد الكربون، فيكشف عن طرحه من الكائن الحيّ"}]'::jsonb, 'd', 'يتفاعل ماء الجير الرائق مع ثاني أكسيد الكربون فيفقد شفافيته ويصبح عكرًا، ما يجعله كاشفًا موثوقًا عن طرح الكائنات الحيّة لهذا الغاز أثناء تنفّسها.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ff415b48-29cb-5f61-8d81-bb1efc9ae39e', 'daaff8ab-c8e6-5332-bace-bd5469068bae', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: التنفّس عند الكائنات الحية', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ab6a8b42-43a0-5c6f-a020-20704c2cbf7f', 'ff415b48-29cb-5f61-8d81-bb1efc9ae39e', 'الثعلب حيوان فقاريّ بريّ. ماذا يحدث بالضبط أثناء حركة الشهيق عنده؟', '[{"id":"a","text":"دخول هواء غنيّ بثاني أكسيد الكربون إلى رئتيه"},{"id":"b","text":"دخول هواء غنيّ بالأكسجين إلى رئتيه"},{"id":"c","text":"خروج هواء غنيّ بالأكسجين من رئتيه"},{"id":"d","text":"توقّف كامل لحركة الرئتين"}]'::jsonb, 'b', 'الشهيق هو دخول هواء غنيّ بالأكسجين إلى الرئتين؛ أمّا الزفير فهو خروج هواء أصبح غنيًّا بثاني أكسيد الكربون بعد التبادل الغازي.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('92159343-9a3b-5fe1-8af5-1c43daa5b373', 'ff415b48-29cb-5f61-8d81-bb1efc9ae39e', 'الخنفساء حشرة صغيرة تعيش في تربة رطبة. إذا التصق طين رطب بجانبَي جسمها فسدّ ثغورها التنفّسية بالكامل، فما الأثر المباشر المتوقّع؟', '[{"id":"a","text":"لا يتأثّر تنفّسها لأنّها تملك رئتين احتياطيّتين"},{"id":"b","text":"تتحوّل قصباتها الهوائية فورًا إلى خياشيم"},{"id":"c","text":"يزداد امتصاصها للأكسجين عبر جلدها بدل قصباتها"},{"id":"d","text":"يتوقّف دخول الهواء إلى قصباتها الهوائية، فيتعطّل تبادلها الغازي"}]'::jsonb, 'd', 'الحشرات لا تملك رئتين؛ يدخل هواؤها حصرًا عبر الثغور التنفّسية إلى القصبات الهوائية. سدّ هذه الثغور يمنع دخول الهواء فيتعطّل التبادل الغازي، ولا يمكن لعضو تنفّسي أن يتحوّل فجأة إلى آخر.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c6e1a974-bd58-52c2-a071-de920fab5bd0', 'ff415b48-29cb-5f61-8d81-bb1efc9ae39e', 'لوحظ أنّ سمكة توقّفت طويلًا عن تحريك فمها وغطائها الخيشومي رغم بقائها داخل الماء. ما الأثر المتوقّع على تنفّسها؟', '[{"id":"a","text":"لا يتأثّر تنفّسها لأنّها لا تزال داخل الماء"},{"id":"b","text":"يتحسّن تنفّسها لأنّ الماء الراكد أغنى بالأكسجين"},{"id":"c","text":"يتوقّف تجدّد الماء فوق خياشيمها، فيقلّ امتصاصها للأكسجين المذاب"},{"id":"d","text":"تتحوّل خياشيمها إلى رئتين للتكيّف مع الوضع"}]'::jsonb, 'c', 'تحتاج الخياشيم إلى تجدّد مستمرّ للماء فوقها لتمتصّ الأكسجين المذاب فيه. توقّف حركة الفم والغطاء الخيشومي يمنع هذا التجدّد، فيقلّ الأكسجين المتاح رغم بقاء السمكة في الماء.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('10d716ac-62f7-5f9d-942c-e08046e08ed7', 'ff415b48-29cb-5f61-8d81-bb1efc9ae39e', 'أيّ العبارات الأربع التالية عن التنفّس عند الكائنات الحية **خاطئة**؟', '[{"id":"a","text":"تمتصّ الحشرات الأكسجين عبر رئتين صغيرتين مثل الفقاريات البرّية"},{"id":"b","text":"تمتصّ الأسماك الأكسجين المذاب في الماء عبر الخياشيم"},{"id":"c","text":"تطرح كلّ الكائنات الحيّة ثاني أكسيد الكربون أثناء تنفّسها"},{"id":"d","text":"يختلف العضو التنفّسي المستعمل حسب وسط عيش الكائن الحيّ"}]'::jsonb, 'a', 'العبارة الخاطئة هي أنّ الحشرات تمتصّ الأكسجين برئتين: فالحشرات لا تملك رئتين إطلاقًا، بل تتنفّس بشبكة القصبات الهوائية. العبارات الثلاث الأخرى صحيحة تمامًا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9b7f8fb4-57b5-5c59-bed0-69fecf00fd43', 'ff415b48-29cb-5f61-8d81-bb1efc9ae39e', 'شرغوف ضفدع لا يزال يملك خياشيم فقط (لم يكتمل تحوّله بعد) وقع خطأً خارج الماء على تربة جافّة. ما المتوقّع لتنفّسه؟', '[{"id":"a","text":"يتنفّس بسهولة لأنّ رئتيه جاهزتان منذ ولادته مثل الضفدع البالغ"},{"id":"b","text":"تتحوّل خياشيمه فورًا إلى قصبات هوائية مثل الحشرات"},{"id":"c","text":"يجد صعوبة في التنفّس لأنّ خياشيمه لا تعمل جيّدًا خارج الماء، وهو لا يملك رئتين بعد"},{"id":"d","text":"لا فرق في تنفّسه سواء كان داخل الماء أو خارجه"}]'::jsonb, 'c', 'خياشيم الشرغوف مصمّمة لامتصاص الأكسجين المذاب في الماء عبر تجدّده فوقها، وهو لم يكتسب رئتين بعد لأنّ تحوّله لم يكتمل؛ لذا يواجه صعوبة حقيقية في التنفّس خارج الماء.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e1039267-3a10-589b-85fc-0db065a7daa3', 'ff415b48-29cb-5f61-8d81-bb1efc9ae39e', 'لاحظ تلميذ أنّ هواء الزفير الذي يخرج من رئتَي أرنب يجعل ماء الجير الرائق يتكدّر أسرع بكثير من هواء الشهيق الذي يستنشقه الأرنب. ما التفسير الأدقّ لهذا الفرق؟', '[{"id":"a","text":"هواء الزفير أكثر رطوبة فقط، ولا علاقة للأمر بثاني أكسيد الكربون"},{"id":"b","text":"ماء الجير يتفاعل مع الأكسجين لا مع ثاني أكسيد الكربون"},{"id":"c","text":"هواء الشهيق وهواء الزفير متطابقان تمامًا في التركيب"},{"id":"d","text":"هواء الزفير أغنى بثاني أكسيد الكربون الذي طرحته الرئتان بعد التبادل الغازي، بعكس هواء الشهيق"}]'::jsonb, 'd', 'خلال مروره بالرئتين، يمتصّ الدمّ الأكسجين ويطرح ثاني أكسيد الكربون في الهواء؛ فيخرج هواء الزفير أغنى بثاني أكسيد الكربون من هواء الشهيق، وهذا ما يجعله يكدّر ماء الجير أسرع.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('01faf188-3d5e-5053-bfb6-5636fbddfbba', 'daaff8ab-c8e6-5332-bace-bd5469068bae', 'sciences-vie-terre-7eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): التنفّس عند الكائنات الحية', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('21d1e16b-0878-5f8e-afce-43dec6798b08', '01faf188-3d5e-5053-bfb6-5636fbddfbba', 'الماعز حيوان فقاريّ يعيش على اليابسة. بأيّ عضو يتنفّس؟', '[{"id":"a","text":"بالقصبات الهوائية"},{"id":"b","text":"بالخياشيم"},{"id":"c","text":"برئتين"},{"id":"d","text":"بجلده فقط"}]'::jsonb, 'c', 'الماعز فقاريّ بريّ، فيتنفّس برئتين مثل بقيّة الفقاريات التي تعيش في الوسط الهوائي.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fd6e3caa-e537-5c3f-adda-5a1556c57a6d', '01faf188-3d5e-5053-bfb6-5636fbddfbba', 'النحلة تتنفّس بالقصبات الهوائية. من أين يدخل الهواء إلى هذه القصبات؟', '[{"id":"a","text":"من الثغور التنفّسية على جانبَي جسمها"},{"id":"b","text":"من فمها فقط"},{"id":"c","text":"من غطاء خيشومي صغير"},{"id":"d","text":"من رئتين صغيرتين في رأسها"}]'::jsonb, 'a', 'يدخل الهواء إلى قصبات النحلة الهوائية عبر ثغور تنفّسية صغيرة على جانبَي جسمها، لا عبر فمها ولا عبر أيّ رئة أو غطاء خيشومي.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a64a48b5-b26d-516f-a7f2-6cbeecbe8cc4', '01faf188-3d5e-5053-bfb6-5636fbddfbba', 'التونة سمكة تعيش في أعماق البحر الأبيض المتوسّط. من أين تحصل على الأكسجين الذي تحتاجه؟', '[{"id":"a","text":"من الهواء الجوّي مباشرة عند صعودها إلى السطح"},{"id":"b","text":"من الأكسجين المذاب في الماء عبر خياشيمها"},{"id":"c","text":"من رئتين تستعملهما تحت الماء"},{"id":"d","text":"لا تحتاج إلى أكسجين لأنّها تعيش في الأعماق"}]'::jsonb, 'b', 'التونة، مثل بقيّة الأسماك، تحصل على الأكسجين المذاب في الماء عبر خياشيمها، ولا تحتاج للصعود إلى السطح لاستنشاق هواء ولا تملك رئتين.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cb286e5a-dfa3-5a90-afb9-a847bd73b0ea', '01faf188-3d5e-5053-bfb6-5636fbddfbba', 'أيّ مقارنة من التالي تصف بدقّة الفرق بين الرئتين والقصبات الهوائية والخياشيم؟', '[{"id":"a","text":"الرئتان تستقبلان الهواء وتُبادلانه مع الدمّ، القصبات الهوائية توزّع الهواء مباشرة داخل جسم الحشرة، والخياشيم تستخلص الأكسجين المذاب في الماء"},{"id":"b","text":"الرئتان والقصبات الهوائية والخياشيم أعضاء متطابقة تمامًا في تركيبها وعملها"},{"id":"c","text":"الخياشيم توجد عند الفقاريات البرّية فقط، والرئتان عند الأسماك فقط"},{"id":"d","text":"القصبات الهوائية هي نفسها القصبة الهوائية الموجودة عند الأرنب"}]'::jsonb, 'a', 'كلّ عضو تنفّسي يعمل بآلية مختلفة تلائم وسطه: الرئتان تبادل مع الدمّ داخل الجسم، القصبات الهوائية توزيع مباشر للهواء عند الحشرات، والخياشيم استخلاص للأكسجين المذاب في الماء.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('891ddddc-5536-5b3e-89e9-4286ace846e4', '01faf188-3d5e-5053-bfb6-5636fbddfbba', 'لو نسي تلميذ تحضير وعاء الشاهد في تجربة الكشف عن ثاني أكسيد الكربون بماء الجير، ماذا يخسر من تجربته؟', '[{"id":"a","text":"لا يخسر شيئًا، فوعاء الشاهد غير ضروري إطلاقًا"},{"id":"b","text":"يخسر إمكانية التأكّد أنّ تكدّر ماء الجير سببه الكائن الحيّ وحده لا عامل آخر"},{"id":"c","text":"يخسر فقط سرعة تكدّر ماء الجير في وعائه الأصلي"},{"id":"d","text":"يصبح ماء الجير في وعائه الأصلي رائقًا بدل أن يتكدّر"}]'::jsonb, 'b', 'وعاء الشاهد (بدون كائن حيّ) هو ما يسمح بالمقارنة: دون هذه المقارنة، لا يمكن الجزم بأنّ تكدّر ماء الجير في الوعاء الآخر سببه فعلًا الكائن الحيّ لا عامل خارجيّ.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1662ae59-73c7-549d-aebe-a4ef3208eab8', '01faf188-3d5e-5053-bfb6-5636fbddfbba', 'ضفدع بالغ يعيش قرب بركة ماء ويستعمل رئتيه للتنفّس معظم وقته. ماذا نتوقّع بخصوص التنفّس عند صغاره (الشراغيف) بعد فقس بيضه داخل البركة؟', '[{"id":"a","text":"تتنفّس الشراغيف برئتين منذ الفقس مثل الضفدع البالغ تمامًا"},{"id":"b","text":"لا تتنفّس الشراغيف إطلاقًا في أوّل أيّامها"},{"id":"c","text":"تتنفّس الشراغيف بالقصبات الهوائية لأنّها في الماء"},{"id":"d","text":"تتنفّس الشراغيف بخياشيم لأنّها تعيش في الماء، خلافًا للضفدع البالغ"}]'::jsonb, 'd', 'طالما تعيش الشراغيف داخل الماء، فهي تتنفّس بخياشيم تلائم هذا الوسط المائي، وتكتسب رئتين لاحقًا عندما تتحوّل إلى ضفادع بالغة تغادر الماء.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1c6d2f00-312b-57e7-9265-9fcdd7b89c53', 'daaff8ab-c8e6-5332-bace-bd5469068bae', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐ (القمّة): التنفّس عند الكائنات الحية', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('16f4ee00-1594-5486-bae0-6bb6d8081528', '1c6d2f00-312b-57e7-9265-9fcdd7b89c53', 'قال تلميذ في إجابته: «الحشرات تتنفّس بواسطة رئتين صغيرتين موجودتين في رأسها.» أين الخطأ في هذه الإجابة؟', '[{"id":"a","text":"لا خطأ، فالإجابة صحيحة تمامًا"},{"id":"b","text":"الخطأ في مكان الرئتين فقط؛ فهما في بطن الحشرة لا في رأسها"},{"id":"c","text":"الحشرات لا تملك رئتين إطلاقًا، بل تتنفّس بشبكة قصبات هوائية تدخلها الهواء من ثغور تنفّسية"},{"id":"d","text":"الخطأ في حجم الرئتين فقط؛ فهما كبيرتان لا صغيرتان"}]'::jsonb, 'c', 'الخطأ جوهريّ لا في التفاصيل: الحشرات لا تملك رئتين على الإطلاق، فعضوها التنفّسي هو شبكة القصبات الهوائية التي يدخلها الهواء عبر الثغور التنفّسية على جانبَي الجسم.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0c5a0a1b-2e65-528f-ad31-3ade387daedb', '1c6d2f00-312b-57e7-9265-9fcdd7b89c53', 'في غابة عين دراهم الرطبة (التي درستها في الفصل السابق)، تعيش أسماك المياه العذبة داخل جداولها. بأيّ عضو تتنفّس هذه الأسماك؟', '[{"id":"a","text":"برئتين، لأنّ الغابة وسط رطب يشبه اليابسة"},{"id":"b","text":"بالخياشيم، لأنّها تعيش داخل الماء مهما كان موقعه"},{"id":"c","text":"بالقصبات الهوائية، لأنّها كائنات صغيرة الحجم"},{"id":"d","text":"لا تحتاج عضوًا تنفّسيًا لأنّ الماء عذب لا مالح"}]'::jsonb, 'b', 'العضو التنفّسي يتحدّد حسب الوسط الفعليّ الذي يعيش فيه الكائن، لا حسب المنطقة العامّة: هذه الأسماك تعيش داخل الماء (سواء في غابة رطبة أو غيرها)، فتتنفّس بالخياشيم كبقيّة الأسماك.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a902c6cc-661e-5ea9-93a9-487d906c26dc', '1c6d2f00-312b-57e7-9265-9fcdd7b89c53', 'التصق طين رطب بجانبَي جسم حشرة فسدّ ثغورها التنفّسية بالكامل. ما الذي يتوقّف أوّلًا، وما الأثر النهائي على الحشرة؟', '[{"id":"a","text":"يتوقّف أوّلًا دخول الهواء إلى القصبات الهوائية، فيتعطّل التبادل الغازي في كلّ الجسم تدريجيًّا وقد تختنق الحشرة"},{"id":"b","text":"يتوقّف أوّلًا هضم الحشرة لطعامها، ولا علاقة للأمر بتنفّسها"},{"id":"c","text":"يزداد أوّلًا نموّ الحشرة بسرعة قبل أن يتوقّف لاحقًا"},{"id":"d","text":"لا يتوقّف شيء لأنّ الحشرة تتنفّس بجلدها أيضًا كاحتياط"}]'::jsonb, 'a', 'سدّ الثغور التنفّسية يمنع أوّلًا دخول الهواء إلى شبكة القصبات الهوائية، وبما أنّ هذه القصبات هي المسؤولة الوحيدة عن توصيل الأكسجين لكلّ أعضاء الحشرة، يتعطّل التبادل الغازي تدريجيًّا في الجسم كلّه، وقد تختنق الحشرة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3eb792ae-cab3-5902-bd3c-9bf513851c9e', '1c6d2f00-312b-57e7-9265-9fcdd7b89c53', 'هل يمكن لسمكة أن تتنفّس بشكل طبيعيّ إذا أُخرجت من الماء ووُضعت في الهواء لفترة طويلة، رغم أنّ الهواء يحتوي على الأكسجين أيضًا؟', '[{"id":"a","text":"نعم، لأنّ الهواء أغنى بالأكسجين من الماء فتتنفّس بسهولة أكبر"},{"id":"b","text":"لا، لأنّ خياشيمها تحتاج تجدّد الماء فوقها لتعمل، وتفشل في استخلاص الأكسجين من الهواء مباشرة"},{"id":"c","text":"نعم، لأنّ خياشيمها تعمل بنفس الطريقة سواء في الماء أو في الهواء"},{"id":"d","text":"لا، لأنّ السمكة تتوقّف كليًّا عن الحاجة إلى الأكسجين خارج الماء"}]'::jsonb, 'b', 'الخياشيم عضو مصمّم لاستخلاص الأكسجين المذاب في الماء عبر تجدّده باستمرار فوق صفائحها؛ خارج الماء تفشل هذه الآلية رغم وجود الأكسجين في الهواء، بخلاف الرئتين المصمّمة خصّيصًا للهواء.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f9bf0443-0254-5053-a79c-17872c0d11c6', '1c6d2f00-312b-57e7-9265-9fcdd7b89c53', 'في تجربة، تكدّر تدريجيًّا ماء الجير المتّصل بوعاء يحوي بذورًا نابتة (حيّة) خلال ساعتين، بينما بقي ماء الجير المتّصل بوعاء آخر يحوي بذورًا مغليّة (ميتة) رائقًا طوال المدّة نفسها. ما الاستنتاج الأدقّ؟', '[{"id":"a","text":"البذور المغليّة أكثر نشاطًا في التنفّس من البذور النابتة"},{"id":"b","text":"نوع البذور (نابتة أو مغليّة) لا علاقة له بنتيجة التجربة"},{"id":"c","text":"ماء الجير يتكدّر تلقائيًّا بعد ساعتين مهما كان محتوى الوعاء"},{"id":"d","text":"طرح ثاني أكسيد الكربون مرتبط بكون الكائن حيًّا فعلًا: البذور النابتة الحيّة تتنفّس وتطرحه، أمّا البذور المغليّة الميتة فلا تتنفّس"}]'::jsonb, 'd', 'الغلي يقتل البذور فتتوقّف عن أداء وظائفها الحيوية، ومنها التنفّس، فلا تطرح ثاني أكسيد الكربون؛ أمّا البذور النابتة فحيّة وتتنفّس فعلًا، وهذا ما يفسّر تكدّر ماء الجير عندها دون الأخرى — التنفّس دليل على الحياة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0d184507-c71e-5de5-bc81-bf165c534654', '1c6d2f00-312b-57e7-9265-9fcdd7b89c53', 'أيّ العبارات الأربع التالية بخصوص التنفّس عند الكائنات الحية **خاطئة**؟', '[{"id":"a","text":"يعتمد اختيار العضو التنفّسي المناسب على الوسط الذي يعيش فيه الكائن الحيّ"},{"id":"b","text":"تمتلك الفقاريات البرّية التي درستها رئتين للتنفّس"},{"id":"c","text":"تسمح خياشيم السمكة بامتصاص الأكسجين الموجود في الهواء مباشرة دون حاجة إلى الماء"},{"id":"d","text":"الثغور التنفّسية عند الحشرات منافذ دخول الهواء إلى القصبات الهوائية"}]'::jsonb, 'c', 'العبارة الخاطئة هي أنّ الخياشيم تمتصّ الأكسجين من الهواء مباشرة: فالخياشيم مصمّمة لاستخلاص الأكسجين المذاب في الماء فقط، ولا تعمل بكفاءة خارجه. العبارات الثلاث الأخرى صحيحة تمامًا.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('99803c95-c8e1-584b-940d-626890ca579e', 'b9317620-40d6-5ef6-bc46-2b15221977ae', 'sciences-vie-terre-7eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8702da84-3821-5640-b849-5c61ba247526', '99803c95-c8e1-584b-940d-626890ca579e', 'ما هي الحاجيات الغذائية الأساسية للنّبات الأخضر؟', '[{"id":"a","text":"ثاني أكسيد الكربون والأكسجين فقط"},{"id":"b","text":"الأملاح المعدنية والضّوء فقط"},{"id":"c","text":"الماء والأملاح المعدنية وثاني أكسيد الكربون والضّوء"},{"id":"d","text":"الماء والضّوء فقط"}]'::jsonb, 'c', 'يحتاج النّبات الأخضر معًا إلى الماء والأملاح المعدنية وثاني أكسيد الكربون (CO₂) والضّوء، وهذه الحاجيات الأربع ضروريّة كلّها ولا يمكن الاستغناء عن واحدة منها.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e085b399-6414-5256-a382-0e7d930f419b', '99803c95-c8e1-584b-940d-626890ca579e', 'بأيّ عضو يمتصّ النّبات الأخضر الماء والأملاح المعدنية من التّربة؟', '[{"id":"a","text":"بالأوراق"},{"id":"b","text":"بالجذور"},{"id":"c","text":"بالسّاق"},{"id":"d","text":"بالأزهار"}]'::jsonb, 'b', 'تمتصّ جذور النّبات الماء والأملاح المعدنية الذائبة فيه من التّربة، في عمليّة تُسمّى الامتصاص الجذريّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('397c675d-381d-59a5-a33d-65045d365905', '99803c95-c8e1-584b-940d-626890ca579e', 'من أين تحصل أوراق النّبات الأخضر على غاز ثاني أكسيد الكربون؟', '[{"id":"a","text":"من التّربة عبر الجذور"},{"id":"b","text":"من الماء الذي تشربه"},{"id":"c","text":"لا تحتاج إليه إطلاقًا"},{"id":"d","text":"من الهواء المحيط مباشرة"}]'::jsonb, 'd', 'تمتصّ أوراق النّبات غاز ثاني أكسيد الكربون (CO₂) مباشرة من الهواء المحيط بها، بخلاف الماء والأملاح المعدنية اللّذين تمتصّهما الجذور من التّربة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('39c74960-73e4-5888-ba63-ae194d1653ec', '99803c95-c8e1-584b-940d-626890ca579e', 'ما دور الكلوروفيل الموجود في أوراق النّبات الأخضر؟', '[{"id":"a","text":"التقاط طاقة الضّوء لتركيب المادّة العضويّة"},{"id":"b","text":"امتصاص الماء من التّربة مباشرة"},{"id":"c","text":"طرح الأملاح المعدنية الزّائدة عن حاجة النّبات"},{"id":"d","text":"امتصاص ثاني أكسيد الكربون من التّربة"}]'::jsonb, 'a', 'الكلوروفيل صبغة خضراء في الأوراق تلتقط طاقة الضّوء وتستعملها لتركيب المادّة العضويّة، ومنها يأتي اللّون الأخضر للأوراق.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('26b4cc51-dfbd-5642-905a-34d5608b355c', '99803c95-c8e1-584b-940d-626890ca579e', 'لماذا يُعتبر النّبات الأخضر كائنًا منتجًا؟', '[{"id":"a","text":"لأنّه يستهلك نباتات أخرى ليعيش"},{"id":"b","text":"لأنّه ينمو فقط في فصل الرّبيع"},{"id":"c","text":"لأنّه يصنع مادّته العضويّة بنفسه من موادّ غير عضويّة"},{"id":"d","text":"لأنّه يتغذّى بأكل حيوانات صغيرة"}]'::jsonb, 'c', 'يُسمّى النّبات الأخضر كائنًا منتجًا لأنّه يصنع مادّته العضويّة بنفسه انطلاقًا من موادّ غير عضويّة (ماء، أملاح معدنية، CO₂)، بخلاف الحيوان المستهلك الذي يحصل عليها جاهزة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('945fd01d-4434-5705-90de-be5a343ce3ae', 'b9317620-40d6-5ef6-bc46-2b15221977ae', 'sciences-vie-terre-7eme', '⭐ تمرين: التّغذية عند النّبات الأخضر', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b7969031-bfe3-5514-b973-eb93e980acc5', '945fd01d-4434-5705-90de-be5a343ce3ae', 'تحتاج شجرة الزّيتون، مثل كلّ نبات أخضر، إلى أربع حاجيات أساسيّة لتنمو بشكل سليم. ما هي؟', '[{"id":"a","text":"الماء وثاني أكسيد الكربون فقط"},{"id":"b","text":"الأملاح المعدنية والأكسجين فقط"},{"id":"c","text":"الماء والأملاح المعدنية وثاني أكسيد الكربون والضّوء"},{"id":"d","text":"الضّوء والأكسجين فقط"}]'::jsonb, 'c', 'كأيّ نبات أخضر، تحتاج شجرة الزّيتون معًا إلى الماء والأملاح المعدنية وثاني أكسيد الكربون (CO₂) والضّوء؛ هذه الحاجيات الأربع لا غنى عن أيّ منها.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('badc93c3-6abb-5111-8cd4-3f85e455b989', '945fd01d-4434-5705-90de-be5a343ce3ae', 'بأيّ عضو تمتصّ نخلة التّمر في واحة تونسية الماء والأملاح المعدنية من تربة الواحة؟', '[{"id":"a","text":"بأوراقها"},{"id":"b","text":"بأزهارها"},{"id":"c","text":"بجذورها"},{"id":"d","text":"بساقها"}]'::jsonb, 'c', 'تمتصّ الجذور الماء والأملاح المعدنية الذائبة فيه من التّربة، في عمليّة الامتصاص الجذريّ، كما تفعل نخلة التّمر في تربة الواحة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6f136bbf-bc61-54b4-bc1e-95506ca04bec', '945fd01d-4434-5705-90de-be5a343ce3ae', 'من أين تحصل شجرة البرتقال في جهة نابل على غاز ثاني أكسيد الكربون الذي تحتاجه؟', '[{"id":"a","text":"من التّربة عبر جذورها"},{"id":"b","text":"من الهواء عبر أوراقها"},{"id":"c","text":"من الماء الذي تشربه"},{"id":"d","text":"من الأملاح المعدنية الموجودة في التّربة"}]'::jsonb, 'b', 'تمتصّ أوراق شجرة البرتقال ثاني أكسيد الكربون مباشرة من الهواء المحيط بها، بخلاف الماء والأملاح المعدنية اللّذين تمتصّهما الجذور من التّربة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0fc6fca8-b341-5bc3-a242-2d137644f685', '945fd01d-4434-5705-90de-be5a343ce3ae', 'ما اسم الصّبغة الخضراء الموجودة في أوراق النّبات، والّتي تلتقط طاقة الضّوء؟', '[{"id":"a","text":"الكلوروفيل"},{"id":"b","text":"الأكسجين"},{"id":"c","text":"الأملاح المعدنية"},{"id":"d","text":"ثاني أكسيد الكربون"}]'::jsonb, 'a', 'الكلوروفيل صبغة خضراء توجد في أوراق النّبات الأخضر، تلتقط طاقة الضّوء وتستعملها لتركيب المادّة العضويّة، ومنها يأتي اللّون الأخضر للأوراق.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('85e718b8-0bc5-58d6-a5b1-41bdf648fd5b', '945fd01d-4434-5705-90de-be5a343ce3ae', 'شجرة تين لا تأكل كائنات أخرى، بل تصنع مادّتها العضويّة بنفسها انطلاقًا من الماء والأملاح المعدنية وثاني أكسيد الكربون والضّوء. أيّ صفة بيولوجية تنطبق عليها؟', '[{"id":"a","text":"كائن منتج"},{"id":"b","text":"كائن مستهلك"},{"id":"c","text":"كائن لا يحتاج إلى تغذية"},{"id":"d","text":"كائن غير حيّ"}]'::jsonb, 'a', 'شجرة التّين، مثل كلّ نبات أخضر، تصنع مادّتها العضويّة بنفسها انطلاقًا من موادّ غير عضويّة، فتُصنَّف كائنًا منتجًا، بخلاف الحيوان المستهلك الذي يحصل عليها جاهزة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('89ca3898-1f4a-5b09-a41b-984ba2bb41cc', '945fd01d-4434-5705-90de-be5a343ce3ae', 'متى يستطيع النّبات الأخضر تركيب مادّته العضويّة بالتركيب الضّوئيّ؟', '[{"id":"a","text":"في اللّيل فقط"},{"id":"b","text":"نهارًا فقط، في وجود الضّوء"},{"id":"c","text":"طوال اليوم واللّيل بانتظام"},{"id":"d","text":"لا علاقة للوقت بذلك"}]'::jsonb, 'b', 'يتوقّف التركيب الضّوئيّ بغياب الضّوء، لذلك لا يحدث إلّا نهارًا حين يتوفّر ضوء كافٍ للنّبات.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ad84b448-69ee-5c38-90cb-9f66aab0d58f', 'b9317620-40d6-5ef6-bc46-2b15221977ae', 'sciences-vie-terre-7eme', '⚔️ زعيم الفصل ⭐⭐⭐: التّغذية عند النّبات الأخضر', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2e2992bc-55da-56b1-b0a2-df18bdd5189b', 'ad84b448-69ee-5c38-90cb-9f66aab0d58f', 'شجرة زيتون تمتصّ الماء والأملاح المعدنية بجذورها من التّربة. ماذا تمتصّ بأوراقها من الهواء؟', '[{"id":"a","text":"بخار الماء فقط"},{"id":"b","text":"الأملاح المعدنية أيضًا"},{"id":"c","text":"الأكسجين فقط"},{"id":"d","text":"ثاني أكسيد الكربون"}]'::jsonb, 'd', 'تمتصّ الأوراق ثاني أكسيد الكربون (CO₂) من الهواء المحيط بها؛ أمّا الماء والأملاح المعدنية فتمتصّهما الجذور من التّربة، لا الأوراق.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1d2bc7b1-a458-5155-bc4b-b08a8d3a35a7', 'ad84b448-69ee-5c38-90cb-9f66aab0d58f', 'ما الفرق الدّقيق بين الامتصاص الجذريّ وامتصاص ثاني أكسيد الكربون عند النّبات الأخضر؟', '[{"id":"a","text":"الامتصاص الجذريّ يأخذ الماء والأملاح المعدنية من التّربة بواسطة الجذور، وامتصاص CO₂ يتمّ من الهواء بواسطة الأوراق"},{"id":"b","text":"لا فرق بينهما، فكلاهما يحدث في نفس العضو وبنفس الطّريقة"},{"id":"c","text":"الامتصاص الجذريّ يحدث في الأوراق فقط"},{"id":"d","text":"امتصاص ثاني أكسيد الكربون يتمّ أيضًا بواسطة الجذور من التّربة"}]'::jsonb, 'a', 'الامتصاص الجذريّ يخصّ الماء والأملاح المعدنية المأخوذة من التّربة بواسطة الجذور، بينما ثاني أكسيد الكربون يُمتصّ من الهواء بواسطة الأوراق؛ مصدران وعضوان مختلفان تمامًا.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('822a8d2a-618a-5771-87ac-e53e1333a223', 'ad84b448-69ee-5c38-90cb-9f66aab0d58f', 'أيّ ممّا يلي يصف بدقّة دور الكلوروفيل عند النّبات الأخضر؟', '[{"id":"a","text":"يمتصّ الماء من التّربة مباشرة بدل الجذور"},{"id":"b","text":"يلتقط طاقة الضّوء ويستعملها لتركيب المادّة العضويّة من الماء والأملاح المعدنية وCO₂"},{"id":"c","text":"يطرح الأملاح المعدنية الزّائدة إلى الهواء"},{"id":"d","text":"يحوّل ثاني أكسيد الكربون إلى ماء داخل الأوراق"}]'::jsonb, 'b', 'الكلوروفيل صبغة تلتقط طاقة الضّوء وتستعملها، مع الماء والأملاح المعدنية وثاني أكسيد الكربون، لتركيب المادّة العضويّة عند النّبات الأخضر — وهذا هو التركيب الضّوئيّ.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a14121ca-678a-5c8e-987a-1b8a11bd9e04', 'ad84b448-69ee-5c38-90cb-9f66aab0d58f', 'خلال تركيبه الضّوئيّ نهارًا، أيّ غاز يطرحه النّبات الأخضر إلى الهواء المحيط به؟', '[{"id":"a","text":"ثاني أكسيد الكربون"},{"id":"b","text":"بخار الماء فقط"},{"id":"c","text":"الأكسجين، النّاتج عن التركيب الضّوئيّ"},{"id":"d","text":"لا يطرح النّبات أيّ غاز أثناء التركيب الضّوئيّ"}]'::jsonb, 'c', 'ينتج عن التركيب الضّوئيّ طرح غاز الأكسجين (O₂) إلى الهواء المحيط. الخطأ الشّائع هو الخلط بين هذا وبين التنفّس الذي يطرح فيه الكائن الحيّ ثاني أكسيد الكربون (فصل سابق) — فالتركيب الضّوئيّ عمليّة مختلفة تمامًا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('62b133da-50ff-5d77-b558-6a1b4478a25f', 'ad84b448-69ee-5c38-90cb-9f66aab0d58f', 'لاحظ فلّاح أنّ نبتة طماطم زُرعت في تربة خصبة وسُقيت بانتظام، لكنّها وُضعت داخل كوخ مظلم تمامًا طوال نموّها. ماذا يُتوقّع لهذه النّبتة رغم توفّر الماء والأملاح المعدنية لها؟', '[{"id":"a","text":"تنمو بشكل طبيعيّ تمامًا لأنّ الماء والأملاح المعدنية كافيان وحدهما"},{"id":"b","text":"تنمو بشكل أفضل من نبتة مماثلة زُرعت في الضّوء"},{"id":"c","text":"تتحوّل إلى كائن مستهلك بدل منتج"},{"id":"d","text":"يضعف نموّها وتصفرّ أوراقها لأنّها لا تستطيع تركيب مادّتها العضويّة بغياب الضّوء"}]'::jsonb, 'd', 'الخطأ الشّائع هو الاعتقاد أنّ الماء والأملاح المعدنية وحدهما يكفيان: النّبات يحتاج إلى الضّوء أيضًا ليركّب مادّته العضويّة بواسطة الكلوروفيل؛ غياب الضّوء طويلًا يضعف النّموّ ويُصفّر الأوراق، كما في تجربة الفصل.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e9e0aa94-f4e1-5b7e-a46c-4d6b5845b406', 'ad84b448-69ee-5c38-90cb-9f66aab0d58f', 'أيّ العبارات التالية عن النّبات الأخضر والحيوان صحيحة؟', '[{"id":"a","text":"النّبات الأخضر منتج لأنّه يصنع مادّته العضويّة بنفسه، والحيوان مستهلك لأنّه يحصل عليها جاهزة"},{"id":"b","text":"كلاهما ينتج مادّته العضويّة بنفسه"},{"id":"c","text":"الحيوان منتج والنّبات الأخضر مستهلك"},{"id":"d","text":"لا فرق بينهما في طريقة الحصول على المادّة العضويّة"}]'::jsonb, 'a', 'النّبات الأخضر منتج لأنّه يصنع مادّته العضويّة بنفسه بالتركيب الضّوئيّ، أمّا الحيوان فمستهلك لأنّه يحصل على مادّته العضويّة جاهزة بأكل النّباتات أو حيوانات أخرى.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e6614d03-220a-5837-9e94-ba5cdeb7c233', 'b9317620-40d6-5ef6-bc46-2b15221977ae', 'sciences-vie-terre-7eme', '⭐⭐ تمرين مراجعة (نمط امتحان): التّغذية عند النّبات الأخضر', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a757866d-2fdf-56c7-8878-d3ded93532f4', 'e6614d03-220a-5837-9e94-ba5cdeb7c233', 'زيتونة صغيرة غُرست حديثًا في بستان بمنطقة صفاقس. بأيّ عضو ستمتصّ الماء والأملاح المعدنية من التّربة لتنمو؟', '[{"id":"a","text":"بأوراقها"},{"id":"b","text":"بجذورها"},{"id":"c","text":"بأزهارها"},{"id":"d","text":"بثمارها"}]'::jsonb, 'b', 'تمتصّ الزّيتونة الصّغيرة الماء والأملاح المعدنية من التّربة بواسطة جذورها، في عمليّة الامتصاص الجذريّ الضّرورية لنموّها.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fa4f8462-43a6-5d6e-b292-eaaf225505dc', 'e6614d03-220a-5837-9e94-ba5cdeb7c233', 'أيّ غاز من التالي يمتصّه النّبات الأخضر من الهواء المحيط به، لا من التّربة؟', '[{"id":"a","text":"الأملاح المعدنية"},{"id":"b","text":"الماء"},{"id":"c","text":"ثاني أكسيد الكربون"},{"id":"d","text":"الحديد"}]'::jsonb, 'c', 'ثاني أكسيد الكربون (CO₂) هو الغاز الذي يمتصّه النّبات الأخضر من الهواء المحيط به بواسطة أوراقه، بخلاف الماء والأملاح المعدنية الآتيين من التّربة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('98c38e01-f748-5e49-8402-d9d88af108a5', 'e6614d03-220a-5837-9e94-ba5cdeb7c233', 'لماذا تحتاج نبتة الفلفل المزروعة في أصيص إلى تربة تحتوي على أملاح معدنية، لا إلى ماء نقيّ فقط؟', '[{"id":"a","text":"لأنّ الأملاح المعدنية تحلّ محلّ الضّوء تمامًا"},{"id":"b","text":"لأنّ النّبات لا يحتاج فعليًّا إلى ماء إن توفّرت الأملاح المعدنية"},{"id":"c","text":"لأنّ الأملاح المعدنية ضروريّة لنموّها ولا يمكن للماء وحده تعويضها"},{"id":"d","text":"لأنّ الأملاح المعدنية تُستعمل بدل ثاني أكسيد الكربون"}]'::jsonb, 'c', 'الأملاح المعدنية حاجة غذائية مستقلّة وضروريّة لنموّ النّبات، ولا يعوّضها توفّر الماء وحده مهما كانت كمّيته.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a2152692-16c5-5608-ae0b-3663cc73d744', 'e6614d03-220a-5837-9e94-ba5cdeb7c233', 'خلال التركيب الضّوئيّ، ما العلاقة بين الضّوء والكلوروفيل؟', '[{"id":"a","text":"الضّوء يذيب الكلوروفيل في الماء"},{"id":"b","text":"الكلوروفيل يمنع الضّوء من الوصول إلى الأوراق"},{"id":"c","text":"لا علاقة بينهما إطلاقًا"},{"id":"d","text":"الكلوروفيل يلتقط طاقة الضّوء ويستعملها لتركيب المادّة العضويّة"}]'::jsonb, 'd', 'الكلوروفيل صبغة خضراء تلتقط طاقة الضّوء بالذّات وتستعمل هذه الطّاقة لتركيب المادّة العضويّة عند النّبات الأخضر.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('576b40ef-b5ee-5779-aa48-159131520bdf', 'e6614d03-220a-5837-9e94-ba5cdeb7c233', 'بستان حمضيّات في جهة نابل، أوراقه خضراء نضرة ومعرّضة للشّمس طوال النّهار. ماذا يحدث داخل هذه الأوراق بفضل الضّوء؟', '[{"id":"a","text":"طرح الأملاح المعدنية الزّائدة فقط"},{"id":"b","text":"تركيب مادّة عضويّة من الماء والأملاح المعدنية وثاني أكسيد الكربون"},{"id":"c","text":"امتصاص الماء مباشرة من الهواء"},{"id":"d","text":"تحويل الأكسجين إلى ثاني أكسيد الكربون"}]'::jsonb, 'b', 'بفضل الضّوء الوفير والكلوروفيل، تركّب أوراق أشجار الحمضيّات مادّة عضويّة انطلاقًا من الماء والأملاح المعدنية وثاني أكسيد الكربون.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8a5af90d-ada0-5ada-b498-44c6d59dde61', 'e6614d03-220a-5837-9e94-ba5cdeb7c233', 'أيّ ممّا يلي يميّز النّبات الأخضر (كائن منتج) عن الحيوان (كائن مستهلك)؟', '[{"id":"a","text":"النّبات الأخضر يصنع مادّته العضويّة بنفسه، والحيوان يحصل عليها جاهزة"},{"id":"b","text":"النّبات الأخضر لا يحتاج إلى ماء إطلاقًا"},{"id":"c","text":"الحيوان وحده يحتاج إلى الضّوء"},{"id":"d","text":"النّبات الأخضر والحيوان يصنعان مادّتهما العضويّة بنفس الطّريقة"}]'::jsonb, 'a', 'الفرق الجوهريّ هو أنّ النّبات الأخضر منتج يصنع مادّته العضويّة بنفسه بالتركيب الضّوئيّ، بينما الحيوان مستهلك يحصل عليها جاهزة بأكل نباتات أو حيوانات أخرى.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3f1fd5e5-d1fb-5d89-8291-38da0c61ad67', 'b9317620-40d6-5ef6-bc46-2b15221977ae', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: التّغذية عند النّبات الأخضر', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f6401c6f-5b5c-5183-bb97-a0b90eb32fd8', '3f1fd5e5-d1fb-5d89-8291-38da0c61ad67', 'زرع تلميذ بذرة فول في إناءين متطابقين، سقاهما بنفس كمّية الماء ووضع كليهما في تربة خصبة بها أملاح معدنية كافية، لكنّه ترك الإناء الأوّل في الضّوء والثّاني في خزانة مظلمة. بعد أسبوعين، ماذا يتوقّع أن يلاحظ؟', '[{"id":"a","text":"نموّ متماثل تمامًا في الإناءين لأنّ الماء والأملاح المعدنية متوفّران في كليهما"},{"id":"b","text":"نموّ أفضل في الإناء المظلم لأنّ الظّلام يحمي النّبتة"},{"id":"c","text":"نموّ سليم وأوراق خضراء في إناء الضّوء، ونموّ ضعيف وأوراق مصفرّة في الإناء المظلم"},{"id":"d","text":"موت فوريّ للنّبتتين معًا رغم توفّر الماء والتّربة"}]'::jsonb, 'c', 'توفّر الماء والأملاح المعدنية لا يكفي وحده: النّبتة المحرومة من الضّوء لا تستطيع تركيب مادّتها العضويّة بكفاءة، فيضعف نموّها وتصفرّ أوراقها، بعكس النّبتة المعرّضة للضّوء التي تنمو بشكل سليم.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7d0fc865-4e44-5b69-a80d-02842b811ef8', '3f1fd5e5-d1fb-5d89-8291-38da0c61ad67', 'أخطأ تلميذ في إجابته: قال إنّ النّبات الأخضر يمتصّ ثاني أكسيد الكربون بجذوره من التّربة تمامًا مثل الماء والأملاح المعدنية. أين يكمن الخطأ بالضّبط؟', '[{"id":"a","text":"لا خطأ، فالإجابة صحيحة تمامًا"},{"id":"b","text":"الخطأ في نوع الغاز فقط؛ فالنّبات يمتصّ الأكسجين لا ثاني أكسيد الكربون بجذوره"},{"id":"c","text":"الخطأ أنّ ثاني أكسيد الكربون يُمتصّ من الهواء بواسطة الأوراق، لا من التّربة بواسطة الجذور"},{"id":"d","text":"الخطأ في العضو فقط؛ فالامتصاص يتمّ بالسّاق لا بالجذور"}]'::jsonb, 'c', 'الجذور تمتصّ من التّربة الماء والأملاح المعدنية فقط، أمّا ثاني أكسيد الكربون فتمتصّه الأوراق من الهواء المحيط بها؛ الخطأ في مصدر الغاز والعضو الممتصّ معًا، لا في تفصيل ثانويّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3c479068-4341-549e-9b45-5d8a5effe0b1', '3f1fd5e5-d1fb-5d89-8291-38da0c61ad67', 'أيّ العبارات الأربع التالية عن التّغذية عند النّبات الأخضر **خاطئة**؟', '[{"id":"a","text":"يمتصّ النّبات الأخضر الماء والأملاح المعدنية بجذوره من التّربة"},{"id":"b","text":"يمتصّ النّبات الأخضر ثاني أكسيد الكربون بأوراقه من الهواء"},{"id":"c","text":"يحتاج النّبات الأخضر إلى الضّوء ليركّب مادّته العضويّة بفضل الكلوروفيل"},{"id":"d","text":"يحصل النّبات الأخضر على مادّته العضويّة جاهزة من التّربة دون تركيبها بنفسه"}]'::jsonb, 'd', 'العبارة الخاطئة هي أنّ النّبات يحصل على مادّته العضويّة جاهزة من التّربة: النّبات الأخضر يصنع مادّته العضويّة بنفسه بالتركيب الضّوئيّ، فهو منتج لا مستهلك. العبارات الثّلاث الأخرى صحيحة تمامًا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('faa4c7c8-c7e8-5aac-b2ec-3909b2818e42', '3f1fd5e5-d1fb-5d89-8291-38da0c61ad67', 'في واحة نفطة، تنمو أشجار النّخيل رغم قلّة الأمطار على مدار السّنة. أيّ تفسير من التالي يجمع بين حاجيات النّبات الأخضر وصفته ككائن منتج؟', '[{"id":"a","text":"تمتصّ جذور النّخيل الماء والأملاح المعدنية من طبقات التّربة العميقة القريبة من الماء الجوفيّ، وبفضل الضّوء الوفير وثاني أكسيد الكربون من الهواء، تركّب أوراقها مادّتها العضويّة بنفسها"},{"id":"b","text":"تحصل أشجار النّخيل على مادّتها العضويّة جاهزة من التّربة دون الحاجة إلى ضوء"},{"id":"c","text":"لا تحتاج أشجار النّخيل إلى أملاح معدنية لأنّها تعيش في مناخ جافّ"},{"id":"d","text":"تتغذّى أشجار النّخيل على حيوانات صغيرة تعيش في التّربة"}]'::jsonb, 'a', 'نخيل الواحة يجمع كلّ الحاجيات: جذور عميقة تمتصّ الماء والأملاح المعدنية من التّربة، وأوراق تمتصّ ثاني أكسيد الكربون وتستفيد من الضّوء الوفير لتركّب مادّتها العضويّة بنفسها — وهذا ما يجعلها كائنًا منتجًا رغم قلّة الأمطار.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e1dd7018-e184-53ba-a34f-256150047652', '3f1fd5e5-d1fb-5d89-8291-38da0c61ad67', 'نبتة زُرعت في تربة فقيرة جدًّا من الأملاح المعدنية، لكنّها سُقيت بانتظام ووُضعت في ضوء وفير طوال اليوم. ماذا يُتوقّع لنموّها رغم توفّر الماء والضّوء؟', '[{"id":"a","text":"تنمو بشكل طبيعيّ تمامًا لأنّ الماء والضّوء يكفيان وحدهما"},{"id":"b","text":"يتأثّر نموّها سلبًا رغم توفّر الماء والضّوء، لأنّ الأملاح المعدنية حاجة ضروريّة أيضًا ولا يعوّضها عنصر آخر"},{"id":"c","text":"تتحوّل إلى كائن مستهلك بسبب نقص الأملاح المعدنية"},{"id":"d","text":"يتوقّف التركيب الضّوئيّ كليًّا فور نقص الأملاح المعدنية فقط"}]'::jsonb, 'b', 'الحاجيات الأربع مستقلّة ولا تعوّض إحداها الأخرى: مهما توفّر الماء والضّوء، فإنّ نقص الأملاح المعدنية يبقى يؤثّر سلبًا على نموّ النّبتة، لأنّها حاجة غذائية ضروريّة بذاتها.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b89db3fa-412a-5aa4-8fd4-6fb15e9c2dc5', '3f1fd5e5-d1fb-5d89-8291-38da0c61ad67', 'لوحظ أنّ نبتة توقّفت عن تركيب مادّتها العضويّة بالتركيب الضّوئيّ بشكل كامل طوال اليوم، رغم توفّر الماء والأملاح المعدنية وثاني أكسيد الكربون بكمّيات كافية. ما التّفسير الأرجح؟', '[{"id":"a","text":"نقص حادّ في الضّوء طوال اليوم"},{"id":"b","text":"زيادة كبيرة في كمّية الماء الممتصّة"},{"id":"c","text":"وفرة زائدة في الأملاح المعدنية"},{"id":"d","text":"ارتفاع نسبة ثاني أكسيد الكربون في الهواء"}]'::jsonb, 'a', 'بما أنّ الماء والأملاح المعدنية وثاني أكسيد الكربون متوفّرة بكمّيات كافية، فالحاجة الوحيدة الغائبة الّتي تفسّر توقّف التركيب الضّوئيّ كليًّا هي الضّوء، إذ تتوقّف هذه العمليّة تمامًا بغيابه.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('81537fef-e72e-5582-b5d7-45146b6c6228', 'b9317620-40d6-5ef6-bc46-2b15221977ae', 'sciences-vie-terre-7eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): التّغذية عند النّبات الأخضر', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e0c06f68-a7bb-546a-870e-08d83f4ab03e', '81537fef-e72e-5582-b5d7-45146b6c6228', 'حديقة مدرسيّة بها نبتة نعناع صغيرة. من أين تمتصّ هذه النّبتة الماء والأملاح المعدنية اللّازمة لها؟', '[{"id":"a","text":"من الهواء المحيط بأوراقها"},{"id":"b","text":"من التّربة بواسطة جذورها"},{"id":"c","text":"من ضوء الشّمس مباشرة"},{"id":"d","text":"من ثمارها"}]'::jsonb, 'b', 'تمتصّ نبتة النّعناع الماء والأملاح المعدنية الذائبة فيه من التّربة بواسطة جذورها، مثل كلّ نبات أخضر.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3485198b-3a6e-5ad5-adfc-f49282718221', '81537fef-e72e-5582-b5d7-45146b6c6228', 'دفيئة (بيت بلاستيكي) بها نبتات طماطم، هواؤها الدّاخليّ غنيّ بثاني أكسيد الكربون. بأيّ عضو تمتصّ نبتات الطّماطم هذا الغاز؟', '[{"id":"a","text":"بجذورها من تربة الدّفيئة"},{"id":"b","text":"بأزهارها"},{"id":"c","text":"بأوراقها من الهواء الدّاخليّ"},{"id":"d","text":"بساقها فقط"}]'::jsonb, 'c', 'تمتصّ أوراق نبتات الطّماطم ثاني أكسيد الكربون مباشرة من الهواء المحيط بها، حتّى داخل الدّفيئة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('da181e56-c4a9-5fac-9af7-95969927a244', '81537fef-e72e-5582-b5d7-45146b6c6228', 'أيّ ممّا يلي يفسّر سبب اخضرار أوراق النّبات؟', '[{"id":"a","text":"وجود الكلوروفيل، الصّبغة الّتي تلتقط طاقة الضّوء"},{"id":"b","text":"امتصاص الأملاح المعدنية الزّائدة"},{"id":"c","text":"طرح ثاني أكسيد الكربون بكثافة"},{"id":"d","text":"نقص الماء في التّربة"}]'::jsonb, 'a', 'لون الأوراق الأخضر مصدره الكلوروفيل، الصّبغة الّتي تلتقط طاقة الضّوء وتستعملها لتركيب المادّة العضويّة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b32fd641-d599-5434-b5cf-6f798452b5c6', '81537fef-e72e-5582-b5d7-45146b6c6228', 'بستان زيتون بمنطقة سيدي بوزيد سُقي بانتظام وتربته غنيّة بالأملاح المعدنية، لكنّ أشجاره زُرعت متلاصقة جدًّا فحجبت الأشجار الكبيرة الضّوء عن الأشجار الصّغيرة تحتها. ماذا يُتوقّع لنموّ الأشجار الصّغيرة المحجوب عنها الضّوء؟', '[{"id":"a","text":"تنمو بنفس معدّل الأشجار الكبيرة المعرّضة للشّمس تمامًا"},{"id":"b","text":"تتحوّل إلى كائنات مستهلكة بدل منتجة"},{"id":"c","text":"تتوقّف عن امتصاص الماء والأملاح المعدنية كليًّا"},{"id":"d","text":"يضعف نموّها لأنّها لا تستطيع تركيب مادّتها العضويّة بكفاءة دون ضوء كافٍ"}]'::jsonb, 'd', 'توفّر الماء والأملاح المعدنية لا يعوّض غياب الضّوء: الأشجار الصّغيرة المحجوب عنها الضّوء لا تستطيع تركيب مادّتها العضويّة بكفاءة، فيضعف نموّها مقارنة بالأشجار المعرّضة للشّمس.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('80939fe0-3d5f-573b-a492-5b6cc9d48c4e', '81537fef-e72e-5582-b5d7-45146b6c6228', 'أيّ مقارنة من التالي تصف بدقّة الفرق بين الامتصاص الجذريّ وتركيب المادّة العضويّة (التركيب الضّوئيّ) عند النّبات الأخضر؟', '[{"id":"a","text":"الامتصاص الجذريّ يأخذ الماء والأملاح المعدنية من التّربة، والتركيب الضّوئيّ يستعملها مع CO₂ والضّوء في الأوراق لصنع مادّة عضويّة"},{"id":"b","text":"كلاهما يحدث في الجذور فقط وبنفس الآلية"},{"id":"c","text":"التركيب الضّوئيّ يحدث في الجذور لا في الأوراق"},{"id":"d","text":"الامتصاص الجذريّ هو نفسه التركيب الضّوئيّ باسم مختلف"}]'::jsonb, 'a', 'الامتصاص الجذريّ خطوة تزوّد النّبات بالماء والأملاح المعدنية من التّربة، بينما التركيب الضّوئيّ خطوة لاحقة تحدث في الأوراق وتستعمل هذه الموادّ مع ثاني أكسيد الكربون والضّوء لصنع المادّة العضويّة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('75afd756-ba8c-555f-8d41-1ec3065aabc7', '81537fef-e72e-5582-b5d7-45146b6c6228', 'لماذا لا يمكن اعتبار نبات فقد كلّ أوراقه الخضراء بسبب مرض قادرًا على تركيب مادّته العضويّة بشكل طبيعيّ، حتّى لو بقيت جذوره سليمة وتربته خصبة؟', '[{"id":"a","text":"لأنّ الجذور وحدها كافية لتركيب المادّة العضويّة بغياب الأوراق"},{"id":"b","text":"لأنّ فقدان الأوراق الخضراء يعني فقدان الكلوروفيل اللّازم لالتقاط الضّوء وامتصاص ثاني أكسيد الكربون، وهما ضروريّان للتركيب الضّوئيّ"},{"id":"c","text":"لأنّ النّبات يتحوّل تلقائيًّا إلى كائن مستهلك بفقدان أوراقه"},{"id":"d","text":"لأنّ الجذور تحتاج أوراقًا لتمتصّ الماء"}]'::jsonb, 'b', 'التركيب الضّوئيّ يحدث في الأوراق الخضراء بفضل الكلوروفيل، وهي أيضًا العضو الذي يمتصّ ثاني أكسيد الكربون من الهواء؛ فقدان الأوراق يعطّل هاتين الوظيفتين معًا رغم سلامة الجذور والتّربة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c66f59cd-e890-5984-a018-bf675af9d287', 'b9317620-40d6-5ef6-bc46-2b15221977ae', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐ (القمّة): التّغذية عند النّبات الأخضر', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fbd9d38c-1b72-5f35-a0cb-aeb78de190d6', 'c66f59cd-e890-5984-a018-bf675af9d287', 'قال تلميذ: «يمتصّ النّبات الأخضر ثاني أكسيد الكربون وأملاحًا معدنية بجذوره معًا من التّربة، ثمّ يستعملهما في التركيب الضّوئيّ.» أين الخطأ بالضّبط في هذه الإجابة؟', '[{"id":"a","text":"لا خطأ، فالإجابة صحيحة بالكامل"},{"id":"b","text":"الخطأ أنّ ثاني أكسيد الكربون يُمتصّ من الهواء بواسطة الأوراق، لا من التّربة بواسطة الجذور مع الأملاح المعدنية"},{"id":"c","text":"الخطأ أنّ الأملاح المعدنية تُمتصّ من الهواء لا من التّربة"},{"id":"d","text":"الخطأ أنّ النّبات لا يستعمل التركيب الضّوئيّ إطلاقًا"}]'::jsonb, 'b', 'الأملاح المعدنية وحدها تُمتصّ من التّربة بواسطة الجذور مع الماء (الامتصاص الجذريّ)، أمّا ثاني أكسيد الكربون فيُمتصّ من الهواء بواسطة الأوراق؛ الخطأ هو الخلط بين مصدرَي العنصرين وعضوَي امتصاصهما.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5c8f7306-2071-5e43-a829-26df27f445ca', 'c66f59cd-e890-5984-a018-bf675af9d287', 'أيّ العبارات الأربع التالية عن الامتصاص الجذريّ والتركيب الضّوئيّ **خاطئة**؟', '[{"id":"a","text":"الامتصاص الجذريّ يزوّد النّبات بالماء والأملاح المعدنية من التّربة"},{"id":"b","text":"التركيب الضّوئيّ يحتاج إلى الضّوء والكلوروفيل ليحدث"},{"id":"c","text":"الأوراق هي الّتي تمتصّ ثاني أكسيد الكربون من الهواء غالبًا"},{"id":"d","text":"الجذور هي الّتي تركّب المادّة العضويّة مباشرة دون حاجة إلى الأوراق أو الضّوء"}]'::jsonb, 'd', 'العبارة الخاطئة هي أنّ الجذور تركّب المادّة العضويّة: التركيب الضّوئيّ يحدث في الأوراق الخضراء بفضل الكلوروفيل والضّوء، لا في الجذور. العبارات الثّلاث الأخرى صحيحة تمامًا.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5abdc061-9f62-5de3-8da7-ead62b4fa4d2', 'c66f59cd-e890-5984-a018-bf675af9d287', 'زُرعت نبتتان متماثلتان (أ) و(ب) في نفس التّربة الخصبة وسُقيتا بنفس كمّية الماء. وُضعت النّبتة (أ) في الضّوء طوال النّهار، ووُضعت النّبتة (ب) في مكان مظلم تمامًا. بعد عشرة أيّام، كانت النّبتة (أ) خضراء قويّة والنّبتة (ب) صفراء ضعيفة. أيّ استنتاج تفرضه هذه الملاحظة؟', '[{"id":"a","text":"الضّوء هو العامل الّذي اختلف بين النّبتتين، وهو المسؤول عن الفرق في تركيب المادّة العضويّة"},{"id":"b","text":"الماء هو المسؤول عن الفرق، رغم تساوي الكمّية المقدَّمة للنّبتتين"},{"id":"c","text":"نوع التّربة هو المسؤول عن الفرق بين النّبتتين"},{"id":"d","text":"لا يمكن استخلاص أيّ استنتاج من هذه الملاحظة"}]'::jsonb, 'a', 'بما أنّ التّربة والماء متساويان بين النّبتتين، فالعامل الوحيد الّذي اختلف هو الضّوء؛ وهذا يثبت أنّ الضّوء هو المسؤول عن قدرة النّبتة (أ) على تركيب مادّتها العضويّة بشكل سليم، بعكس النّبتة (ب).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c1868f24-46fd-5e83-829c-c03f8244cac3', 'c66f59cd-e890-5984-a018-bf675af9d287', 'بستان حمضيّات بجهة بنزرت مزوّد بنظام سقي بالتّنقيط يوصل الماء مباشرة إلى جذور الأشجار، وتربته غنيّة بالأملاح المعدنية. أيّ العناصر التالية تبقى ضروريّة رغم هذا النّظام لتتمكّن الأشجار من تركيب موادّها العضويّة والبقاء كائنات منتجة؟', '[{"id":"a","text":"الماء والأملاح المعدنية فقط، فهما وحدهما ضروريّان"},{"id":"b","text":"نظام السّقي بالتّنقيط وحده، فهو يغني عن كلّ حاجة أخرى"},{"id":"c","text":"ثاني أكسيد الكربون من الهواء والضّوء، إلى جانب الماء والأملاح المعدنية الموفَّرين"},{"id":"d","text":"لا حاجة لأيّ عنصر إضافيّ ما دام السّقي منتظمًا"}]'::jsonb, 'c', 'نظام السّقي يوفّر الماء فقط، والتّربة الخصبة توفّر الأملاح المعدنية؛ لكنّ الأشجار تبقى محتاجة أيضًا إلى ثاني أكسيد الكربون من الهواء والضّوء لتركّب مادّتها العضويّة، فالحاجيات الأربع مستقلّة ولا يغني توفّر بعضها عن البعض الآخر.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a0928b68-13eb-5dcc-86d7-54d26b748e33', 'c66f59cd-e890-5984-a018-bf675af9d287', 'لوحظ أنّ نبتة داخلية موضوعة في غرفة مضاءة بمصباح كهربائي فقط (بلا ضوء شمس) لا تزال تركّب مادّتها العضويّة بشكل طفيف، بينما نبتة أخرى مماثلة وُضعت في غرفة مظلمة تمامًا توقّفت كليًّا عن التركيب الضّوئيّ، رغم توفّر الماء والأملاح المعدنية وثاني أكسيد الكربون لكلتيهما. ما الاستنتاج الأدقّ؟', '[{"id":"a","text":"المصباح الكهربائي لا يمكن أن يوفّر أيّ ضوء مفيد للنّبات إطلاقًا"},{"id":"b","text":"وجود ضوء ولو صناعيّ يسمح باستمرار تركيب المادّة العضويّة، بينما غيابه التّامّ يوقفه كليًّا؛ فالعامل الحاسم هنا هو الضّوء لا مصدره"},{"id":"c","text":"الماء هو العامل الحاسم في الفرق بين النّبتتين"},{"id":"d","text":"الفرق ناتج عن اختلاف نوع الأملاح المعدنية بين الغرفتين"}]'::jsonb, 'b', 'بما أنّ الماء والأملاح المعدنية وثاني أكسيد الكربون متوفّرة لكلتا النّبتتين، فالفرق الوحيد هو نوع/غياب الضّوء؛ النّتيجة تثبت أنّ التركيب الضّوئيّ يحتاج ضوءًا (ولو ضعيفًا وصناعيًّا) ليستمرّ، ويتوقّف كليًّا بغيابه التّامّ.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('01916016-3d9d-5896-9bf3-50a96719eac7', 'c66f59cd-e890-5984-a018-bf675af9d287', 'بذرة زيتون نبتت حديثًا ولم تُطوّر بعد أوراقًا خضراء ظاهرة، لكنّ جذيرها الصّغير بدأ يمتصّ الماء من التّربة. هل تستطيع هذه النّبيتة الفتيّة تركيب موادّها العضويّة بالتركيب الضّوئيّ في هذه المرحلة المبكّرة؟', '[{"id":"a","text":"نعم، فامتصاص الماء وحده يكفي لتركيب المادّة العضويّة"},{"id":"b","text":"لا، لأنّها لا تحتاج إلى تركيب أيّ مادّة عضويّة في بداية نموّها"},{"id":"c","text":"لا بشكل كامل بعد، لأنّها تفتقر إلى أوراق خضراء بها كلوروفيل كافٍ لالتقاط الضّوء وإتمام التركيب الضّوئيّ"},{"id":"d","text":"نعم، لأنّ الجذور تركّب المادّة العضويّة بمفردها دون حاجة إلى أوراق"}]'::jsonb, 'c', 'التركيب الضّوئيّ يتطلّب أوراقًا خضراء تحتوي على الكلوروفيل لالتقاط الضّوء؛ نبيتة بلا أوراق ظاهرة بعد لا تستطيع إتمام هذه العمليّة بشكل كامل، مهما كان امتصاص جذيرها للماء نشيطًا.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('45004e0a-8273-58ed-bf66-4831555f75a8', '0b434af5-07f7-5b82-956d-9e708a6aeac8', 'sciences-vie-terre-7eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a5196351-3dfa-5164-837a-e02d1f281f4b', '45004e0a-8273-58ed-bf66-4831555f75a8', 'لماذا يُوصف الحيوان بأنّه مستهلك، خلافًا للنبتة؟', '[{"id":"a","text":"لأنّه لا يستطيع صنع غذائه، فيحصل عليه جاهزًا من كائنات حيّة أخرى"},{"id":"b","text":"لأنّه يصنع غذاءه بنفسه من الشمس والماء"},{"id":"c","text":"لأنّه لا يتغذّى إطلاقًا"},{"id":"d","text":"لأنّه يعيش في الماء دائمًا"}]'::jsonb, 'a', 'الحيوان، خلافًا للنبتة، لا يصنع غذاءه بنفسه؛ فهو يحصل عليه جاهزًا من نباتات أو حيوانات أخرى، ولهذا يُوصف بأنّه مستهلك.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6174ea99-e79b-559c-a482-de8a6e4ced8a', '45004e0a-8273-58ed-bf66-4831555f75a8', 'الماعز حيوان عاشب يقتات على الأعشاب والأوراق. أيّ وصف يناسب أسنانه؟', '[{"id":"a","text":"أنياب طويلة حادّة للصيد، بلا أضراس"},{"id":"b","text":"قواطع حادّة لقطف العشب وأضراس واسعة مسطّحة لطحنه"},{"id":"c","text":"منقار قصير مخروطي بلا أسنان إطلاقًا"},{"id":"d","text":"أضراس حادّة مسنّنة فقط لتقطيع اللحم"}]'::jsonb, 'b', 'الماعز عاشب، فأسنانه تتكيّف مع النبات: قواطع حادّة تقطف العشب، وأضراس واسعة مسطّحة تطحنه جيّدًا، مع أنياب ضعيفة جدًّا أو منعدمة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('50c8452c-c117-5f4d-9fc6-ec1633417038', '45004e0a-8273-58ed-bf66-4831555f75a8', 'القطّ البرّي حيوان لاحم يصطاد فريسته. أيّ وصف يناسب أنيابه؟', '[{"id":"a","text":"منعدمة تمامًا لأنّه لا يحتاج إليها"},{"id":"b","text":"قصيرة وواسعة لطحن النبات"},{"id":"c","text":"طويلة وحادّة للإمساك بالفريسة وقتلها وتثبيتها"},{"id":"d","text":"معقوفة مثل منقار الصقر"}]'::jsonb, 'c', 'القطّ البرّي لاحم، فأنيابه طويلة وحادّة تُستعمل للإمساك بالفريسة وقتلها وتثبيتها، بخلاف العاشب الذي تضعف أنيابه أو تنعدم.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b03b4fbe-21b9-5979-bba5-34bcbe06455a', '45004e0a-8273-58ed-bf66-4831555f75a8', 'يأكل الخنزير البرّي الجذور والثمار، ويأكل أيضًا الحشرات الصغيرة والديدان. إلى أيّ نظام غذائي ينتمي؟', '[{"id":"a","text":"عاشب"},{"id":"b","text":"لاحم"},{"id":"c","text":"لا ينتمي إلى أيّ نظام معروف"},{"id":"d","text":"قارت"}]'::jsonb, 'd', 'الخنزير البرّي يقتات على النباتات (الجذور والثمار) وعلى الحيوانات الصغيرة (الحشرات والديدان) معًا، وهذا يجعله قارتًا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b2b38070-27ea-55f0-9844-748122631320', '45004e0a-8273-58ed-bf66-4831555f75a8', 'الصقر الحرّ طائر لاحم يصطاد طيورًا صغيرة وقوارض. ما الشكل المناسب لمنقاره؟', '[{"id":"a","text":"منقار قصير مخروطي لكسر الحبوب"},{"id":"b","text":"منقار معقوف وحادّ لتمزيق اللحم"},{"id":"c","text":"أسنان حادّة بدل المنقار"},{"id":"d","text":"منقار مسطّح واسع بلا حدّة"}]'::jsonb, 'b', 'الطيور اللاحمة الصائدة مثل الصقر الحرّ تملك منقارًا معقوفًا وحادًّا، يُستعمل لتمزيق لحم الفريسة؛ فالطيور أصلًا لا تملك أسنانًا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4dccf20e-13f9-5dab-be0c-6dd4def067c1', '0b434af5-07f7-5b82-956d-9e708a6aeac8', 'sciences-vie-terre-7eme', '⭐ تمرين: التّغذية عند الحيوان', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('81c7cd7a-74cf-598f-b9af-db733136ec07', '4dccf20e-13f9-5dab-be0c-6dd4def067c1', 'الخروف يقتات على الأعشاب فقط، ولا يأكل أيّ حيوان آخر. إلى أيّ نظام غذائي ينتمي؟', '[{"id":"a","text":"لاحم"},{"id":"b","text":"عاشب"},{"id":"c","text":"قارت"},{"id":"d","text":"لا ينتمي إلى نظام معروف"}]'::jsonb, 'b', 'الخروف يقتات على النباتات فقط (الأعشاب)، وهذا هو تعريف النظام العاشب بالضبط.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('12a099a0-d83e-5744-8241-510f556b2286', '4dccf20e-13f9-5dab-be0c-6dd4def067c1', 'النمس يصطاد الزواحف والقوارض، ولا يأكل أيّ نبات إطلاقًا. إلى أيّ نظام غذائي ينتمي؟', '[{"id":"a","text":"عاشب"},{"id":"b","text":"قارت"},{"id":"c","text":"لا يتغذّى إطلاقًا"},{"id":"d","text":"لاحم"}]'::jsonb, 'd', 'النمس يقتات على لحوم حيوانات أخرى فقط (زواحف وقوارض) دون أيّ نبات، وهذا هو النظام اللاحم.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ac4c82f9-116c-5a86-b301-4a055c662085', '4dccf20e-13f9-5dab-be0c-6dd4def067c1', 'الدجاج يلتقط حبوبًا مثل عاشب، لكنّه يلتقط أيضًا حشرات صغيرة وديدانًا. إلى أيّ نظام غذائي ينتمي؟', '[{"id":"a","text":"قارت"},{"id":"b","text":"عاشب فقط"},{"id":"c","text":"لاحم فقط"},{"id":"d","text":"لا ينتمي إلى نظام معروف"}]'::jsonb, 'a', 'الدجاج يأكل النبات (الحبوب) والحيوان (الحشرات والديدان) معًا، وهذا يجعله قارتًا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2b146a81-6889-55b7-8811-a9fa04898993', '4dccf20e-13f9-5dab-be0c-6dd4def067c1', 'أيّ نوع أسنان يستعمله العاشب لطحن الغذاء النباتي بعد قطفه؟', '[{"id":"a","text":"أنياب طويلة حادّة"},{"id":"b","text":"قواطع صغيرة فقط"},{"id":"c","text":"أضراس واسعة ومسطّحة"},{"id":"d","text":"منقار قصير مخروطي"}]'::jsonb, 'c', 'العاشب يطحن غذاءه النباتي بأضراس واسعة ومسطّحة، بعد أن يقطفه بقواطعه الحادّة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fe89620a-a6dd-502d-b35d-7ac1ed4983c9', '4dccf20e-13f9-5dab-be0c-6dd4def067c1', 'البوم طائر لاحم يصطاد فريسته ليلًا. أيّ شكل منقار يناسبه؟', '[{"id":"a","text":"منقار معقوف وحادّ"},{"id":"b","text":"منقار قصير مخروطي"},{"id":"c","text":"أسنان حادّة بدل المنقار"},{"id":"d","text":"منقار مسطّح عريض"}]'::jsonb, 'a', 'الطيور اللاحمة الصائدة مثل البوم تملك منقارًا معقوفًا وحادًّا لتمزيق لحم فريستها.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('60275106-ec17-5139-bbde-a167f1d6f683', '4dccf20e-13f9-5dab-be0c-6dd4def067c1', 'هل تملك الطيور أسنانًا كالثدييات لتتكيّف مع غذائها؟', '[{"id":"a","text":"نعم، تملك نفس أسنان الثدييات تمامًا"},{"id":"b","text":"نعم لكنّها أصغر حجمًا فقط"},{"id":"c","text":"تملك أسنانًا فقط وهي صغيرة"},{"id":"d","text":"لا، لا تملك أسنانًا إطلاقًا، بل تتكيّف بشكل منقارها"}]'::jsonb, 'd', 'الطيور لا تملك أسنانًا إطلاقًا؛ فهي تتكيّف مع نظامها الغذائي بشكل منقارها بدل الأسنان.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c7db6f68-62de-5fdc-bac9-bb2dde729f41', '0b434af5-07f7-5b82-956d-9e708a6aeac8', 'sciences-vie-terre-7eme', '⚔️ زعيم الفصل ⭐⭐⭐: التّغذية عند الحيوان', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7c9f4fdd-09a4-5288-b107-ebdd609a9c3d', 'c7db6f68-62de-5fdc-bac9-bb2dde729f41', 'الأرنب البرّي حيوان عاشب يقتات على الأعشاب والجذور اللينة، ولا يصطاد أيّ فريسة. أيّ نوع سنّ يكون غالبًا ضعيفًا جدًّا أو منعدمًا عنده؟', '[{"id":"a","text":"الأنياب"},{"id":"b","text":"الأضراس"},{"id":"c","text":"القواطع"},{"id":"d","text":"كلّ أنواع الأسنان معًا"}]'::jsonb, 'a', 'العاشب مثل الأرنب البرّي لا يحتاج إلى صيد فريسة أو تمزيق لحم، فأنيابه ضعيفة جدًّا أو منعدمة، بخلاف قواطعه وأضراسه الفعّالتين في قطف النبات وطحنه.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ee4c5f13-e5c2-5ba5-9753-37c8bbe73eac', 'c7db6f68-62de-5fdc-bac9-bb2dde729f41', 'ما الفرق الدقيق بين أضراس العاشب كالخروف وأضراس اللاحم كالقطّ البرّي؟', '[{"id":"a","text":"لا فرق بينهما، فكلاهما يستعمل نفس شكل الأضراس"},{"id":"b","text":"أضراس اللاحم أكبر حجمًا فقط دون فرق في الشكل"},{"id":"c","text":"أضراس العاشب واسعة مسطّحة لطحن النبات، وأضراس اللاحم حادّة مسنّنة لتقطيع اللحم"},{"id":"d","text":"أضراس العاشب حادّة مسنّنة، وأضراس اللاحم واسعة مسطّحة"}]'::jsonb, 'c', 'تتكيّف الأضراس مع طبيعة الغذاء: واسعة مسطّحة عند العاشب لطحن النبات، وحادّة مسنّنة عند اللاحم لتقطيع اللحم لا لطحنه.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a9548deb-86f4-5119-8549-c92e6be71d95', 'c7db6f68-62de-5fdc-bac9-bb2dde729f41', 'الغراب طائر قارت يأكل الحبوب والحشرات وأحيانًا بقايا حيوانات. أيّ شكل منقار يناسبه على الأرجح؟', '[{"id":"a","text":"منقار معقوف حادّ مثل الصقر تمامًا"},{"id":"b","text":"منقار قصير مخروطي مثل العصفور الدوري تمامًا"},{"id":"c","text":"لا يملك منقارًا بل أسنانًا صغيرة"},{"id":"d","text":"منقار متوسّط الشكل غير معقوف يصلح لالتقاط أغذية متنوّعة"}]'::jsonb, 'd', 'الغراب قارت يأكل غذاءً متنوّعًا (حبوبًا وحشرات وبقايا)، فمنقاره متوسّط الشكل وغير معقوف بشدّة، يصلح لالتقاط أنواع مختلفة من الغذاء، لا منقارًا متخصّصًا كالصقر أو العصفور.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('18143cd1-5bec-5bc0-bc9b-5d436689b2ca', 'c7db6f68-62de-5fdc-bac9-bb2dde729f41', 'لماذا لا يحتاج القطّ البرّي إلى أضراس واسعة مسطّحة مثل الماعز؟', '[{"id":"a","text":"لأنّه لا يملك أضراسًا إطلاقًا"},{"id":"b","text":"لأنّه لا يطحن نباتًا، بل يقطع لحمًا بأضراس حادّة مسنّنة"},{"id":"c","text":"لأنّه يبلع غذاءه دون مضغه إطلاقًا"},{"id":"d","text":"لأنّه قارت وليس لاحمًا"}]'::jsonb, 'b', 'الأضراس الواسعة المسطّحة وظيفتها طحن النبات، وهذا لا يحتاجه القطّ البرّي لأنّه لاحم يقطع اللحم بأضراس حادّة مسنّنة لا يطحنه.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d5ea00af-4184-5544-bfb9-a211f832a557', 'c7db6f68-62de-5fdc-bac9-bb2dde729f41', 'وُصف حيوان غير مُسمّى بأنّ له قواطع لقطع الغذاء، أنيابًا متوسّطة غير بارزة كثيرًا، وأضراسًا يمزج شكلها بين المسطّح والحادّ. إلى أيّ نظام غذائي ينتمي على الأرجح؟', '[{"id":"a","text":"قارت"},{"id":"b","text":"عاشب"},{"id":"c","text":"لاحم"},{"id":"d","text":"لا يمكن تصنيفه من هذا الوصف"}]'::jsonb, 'a', 'مزج شكلَي الأسنان معًا (مسطّحة وحادّة) مع أنياب متوسّطة هو بالضبط توصيف أسنان القارت، الذي يتغذّى على النبات والحيوان معًا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('211e4808-3e69-59d0-873d-84bda8a40bb2', 'c7db6f68-62de-5fdc-bac9-bb2dde729f41', 'لماذا لا يمكن أن يكون العصفور الدوري لاحمًا رغم أنّه طائر مثل الصقر؟', '[{"id":"a","text":"لأنّ العصفور لا يملك منقارًا إطلاقًا"},{"id":"b","text":"لأنّ العصفور أكبر حجمًا من الصقر"},{"id":"c","text":"لأنّ الصقر لا يصطاد فريسة إطلاقًا"},{"id":"d","text":"لأنّ منقاره قصير مخروطي مخصّص لكسر الحبوب، لا لتمزيق اللحم كمنقار الصقر المعقوف"}]'::jsonb, 'd', 'شكل المنقار يكشف النظام الغذائي: منقار العصفور الدوري قصير ومخروطي، مخصّص لكسر قشرة الحبوب، لا لتمزيق اللحم كالمنقار المعقوف الحادّ عند الصقر اللاحم.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f18769c1-fe35-53bb-b6d3-ecf66d9f0078', '0b434af5-07f7-5b82-956d-9e708a6aeac8', 'sciences-vie-terre-7eme', '⭐⭐ تمرين مراجعة (نمط امتحان): التّغذية عند الحيوان', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3d7feed7-d8bb-56c3-9005-25099a7e3d4d', 'f18769c1-fe35-53bb-b6d3-ecf66d9f0078', 'الجمل يعيش في الصحراء ويقتات على النباتات الصحراوية القاسية فقط، ولا يصطاد أيّ حيوان. إلى أيّ نظام غذائي ينتمي؟', '[{"id":"a","text":"لاحم"},{"id":"b","text":"قارت"},{"id":"c","text":"عاشب"},{"id":"d","text":"لا ينتمي إلى نظام معروف"}]'::jsonb, 'c', 'الجمل يقتات على النباتات فقط، مهما كانت قاسية، دون أن يصطاد أيّ حيوان، وهذا هو النظام العاشب.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('db58c264-1702-50f6-811f-74911b0eed5b', 'f18769c1-fe35-53bb-b6d3-ecf66d9f0078', 'أيّ نوع أسنان يستعمله اللاحم للإمساك بفريسته وقتلها؟', '[{"id":"a","text":"أنياب طويلة حادّة"},{"id":"b","text":"أضراس واسعة مسطّحة"},{"id":"c","text":"قواطع صغيرة فقط"},{"id":"d","text":"منقار معقوف"}]'::jsonb, 'a', 'اللاحم يستعمل أنيابه الطويلة الحادّة للإمساك بفريسته وقتلها وتثبيتها؛ الأنياب هي أداته الأساسية في الصيد.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bc95538d-76fd-5a2b-bf54-4702be1bb642', 'f18769c1-fe35-53bb-b6d3-ecf66d9f0078', 'لماذا تكون قواطع اللاحم كالقطّ البرّي صغيرة نسبيًّا، خلافًا لقواطع العاشب الحادّة الكبيرة؟', '[{"id":"a","text":"لأنّ اللاحم لا يملك قواطع إطلاقًا"},{"id":"b","text":"لأنّ قواطع اللاحم تستعمل لطحن النبات"},{"id":"c","text":"لأنّ اللاحم يستعملها للصيد بدل الأنياب"},{"id":"d","text":"لأنّ اللاحم يستعملها فقط لتنظيف اللحم عن العظم، لا لقطف كمّيات كبيرة من النبات"}]'::jsonb, 'd', 'وظيفة القواطع تختلف بحسب النظام: عند العاشب تقطف كمّيات كبيرة من العشب، بينما عند اللاحم تبقى صغيرة نسبيًّا لأنّها تُستعمل فقط لتنظيف اللحم عن العظم بعد أن تمسك الأنياب بالفريسة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cadc66a2-1268-5ca1-b534-2691a2e1290e', 'f18769c1-fe35-53bb-b6d3-ecf66d9f0078', 'الحسون طائر صغير يتغذّى على الحبوب والبذور فقط. أيّ شكل منقار يناسبه؟', '[{"id":"a","text":"منقار معقوف حادّ"},{"id":"b","text":"منقار قصير مخروطي قويّ"},{"id":"c","text":"أسنان صغيرة حادّة"},{"id":"d","text":"منقار مسطّح واسع جدًّا"}]'::jsonb, 'b', 'الحسون طائر حبوبيّ يتغذّى على البذور، فمنقاره قصير ومخروطي وقويّ، مصمّم لكسر قشرة الحبوب الصغيرة، لا لتمزيق اللحم.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('22284673-f9af-5094-b405-8f874483c3c5', 'f18769c1-fe35-53bb-b6d3-ecf66d9f0078', 'بعد أن يمسك الحيوان بغذائه، ما الترتيب الصحيح لما يحدث؟', '[{"id":"a","text":"تفتيت الغذاء ميكانيكيًّا بالأسنان أو المنقار، ثمّ تحوّله داخل الجسم إلى موادّ بسيطة"},{"id":"b","text":"تحوّل الغذاء داخل الجسم أوّلًا، ثمّ تفتيته بالأسنان لاحقًا"},{"id":"c","text":"طرح الفضلات أوّلًا، ثمّ تفتيت الغذاء"},{"id":"d","text":"لا ترتيب محدّدًا؛ تحدث كلّ المراحل في اللحظة نفسها"}]'::jsonb, 'a', 'يمرّ الغذاء بمرحلتين متتاليتين: أوّلًا التفتيت الميكانيكي بالأسنان أو المنقار قبل البلع، ثمّ تحوّله داخل الجسم إلى موادّ بسيطة يمتصّها الحيوان.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('59e49d4d-f664-5988-bd9f-c5c9cd70ee5e', 'f18769c1-fe35-53bb-b6d3-ecf66d9f0078', 'ماذا يحدث للأجزاء غير المهضومة من الغذاء بعد تحوّله داخل جسم الحيوان؟', '[{"id":"a","text":"تبقى داخل الجسم إلى الأبد"},{"id":"b","text":"تتحوّل إلى أكسجين"},{"id":"c","text":"تمتصّها الأسنان مباشرة"},{"id":"d","text":"تُطرح خارج الجسم كفضلات"}]'::jsonb, 'd', 'بعد تحوّل الغذاء داخل الجسم، تُمتصّ الموادّ البسيطة المفيدة، بينما تُطرح الأجزاء غير المهضومة خارج الجسم على شكل فضلات.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('911eb879-9600-50eb-adaa-8f8a6699adf2', '0b434af5-07f7-5b82-956d-9e708a6aeac8', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: التّغذية عند الحيوان', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f88857b3-3015-540b-a6b0-1d2cb35cc5ec', '911eb879-9600-50eb-adaa-8f8a6699adf2', 'البقرة عاشب يقتات على العشب طوال النهار، دون أن تصطاد أيّ فريسة. ماذا نتوقّع بخصوص أنيابها؟', '[{"id":"a","text":"أنياب طويلة وحادّة مثل اللاحم"},{"id":"b","text":"أنياب ضعيفة جدًّا أو منعدمة"},{"id":"c","text":"أنياب متوسّطة تجمع بين العاشب واللاحم"},{"id":"d","text":"لا تملك البقرة أيّ أسنان إطلاقًا"}]'::jsonb, 'b', 'البقرة عاشب يقتات على النبات فقط، فأنيابها ضعيفة جدًّا أو منعدمة، مثل بقيّة الحيوانات العاشبة التي لا تحتاج إلى صيد فريسة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5d08fa20-d2d7-5b3c-a00e-b052dfdc7c77', '911eb879-9600-50eb-adaa-8f8a6699adf2', 'قال تلميذ: «الخنزير البرّي عاشب، لأنّه يأكل الجذور والثمار.» أين الخطأ في هذا الاستنتاج؟', '[{"id":"a","text":"لا خطأ، فالاستنتاج صحيح تمامًا"},{"id":"b","text":"الخطأ أنّ الخنزير البرّي لا يأكل جذورًا ولا ثمارًا إطلاقًا"},{"id":"c","text":"الخطأ أنّ الخنزير البرّي لاحم لا عاشب"},{"id":"d","text":"التلميذ اعتمد على جزء واحد فقط من غذائه؛ فالخنزير البرّي يأكل أيضًا حشرات وديدانًا، ما يجعله قارتًا لا عاشبًا"}]'::jsonb, 'd', 'الخطأ أنّ التلميذ اكتفى بذكر الغذاء النباتي (الجذور والثمار) وأغفل أنّ الخنزير البرّي يأكل أيضًا حشرات صغيرة وديدانًا؛ الجمع بين النوعين يجعله قارتًا لا عاشبًا.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ceb17ac8-586d-59da-a98e-4e94041b9163', '911eb879-9600-50eb-adaa-8f8a6699adf2', 'لماذا لا نستطيع تصنيف الدجاج بأنّه عاشب فقط رغم أنّه يلتقط الحبوب النباتية بكثرة؟', '[{"id":"a","text":"لأنّه يأكل أيضًا حشرات وديدانًا، فيجمع بين غذاء النبات والحيوان، ما يجعله قارتًا"},{"id":"b","text":"لأنّه لا يأكل حبوبًا إطلاقًا"},{"id":"c","text":"لأنّه يصطاد فرائس كبيرة كالقطّ البرّي"},{"id":"d","text":"لأنّ تصنيف الطيور يختلف كلّيًّا عن تصنيف الثدييات"}]'::jsonb, 'a', 'رغم أنّ الدجاج يلتقط كمّية كبيرة من الحبوب، فإنّه يأكل أيضًا حشرات صغيرة وديدانًا؛ وجود النوعين معًا في غذائه يمنع تصنيفه عاشبًا فقط، ويجعله قارتًا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('36c222bd-ea6c-57df-96e3-da22fb3a974a', '911eb879-9600-50eb-adaa-8f8a6699adf2', 'ما وجه الشبه بين المنقار المعقوف عند الصقر الحرّ والأنياب الطويلة الحادّة عند القطّ البرّي؟', '[{"id":"a","text":"كلاهما يُستعمل لطحن النبات"},{"id":"b","text":"لا وجه شبه بينهما إطلاقًا"},{"id":"c","text":"كلاهما أداة تكيّفت لخدمة نظام غذائي لاحم، رغم اختلاف بنيتهما (منقار عند الطائر، أسنان عند الثدييّ)"},{"id":"d","text":"كلاهما يوجد عند الحيوانات العاشبة فقط"}]'::jsonb, 'c', 'رغم أنّ أحدهما منقار والآخر أسنان، فإنّ كليهما تكيّف مع نظام غذائي لاحم يحتاج الصيد وتمزيق اللحم: منقار الصقر المعقوف عند الطيور، وأنياب القطّ البرّي الحادّة عند الثدييات.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ad4abfec-80fc-52a3-acfa-a71252e0b6a1', '911eb879-9600-50eb-adaa-8f8a6699adf2', 'شوهد طائر يمتلك منقارًا قصيرًا مخروطيًّا قويًّا فقط، دون أيّ انحناء أو تعقّف. بأيّ نظام غذائي نُرجّح انتماءه على الأرجح؟', '[{"id":"a","text":"لاحم صائد للفرائس"},{"id":"b","text":"عاشب أو قارت يعتمد على الحبوب"},{"id":"c","text":"لا يمكن ترجيح أيّ نظام من شكل المنقار"},{"id":"d","text":"لاحم يقتات على اللحم فقط دون أيّ نبات"}]'::jsonb, 'b', 'المنقار القصير المخروطي القويّ بلا انحناء هو منقار مخصّص لكسر الحبوب، وهو سمة الطيور العاشبة الحبوبيّة أو القارتة التي تعتمد جزئيًّا على الحبوب، لا الطيور اللاحمة الصائدة التي تحتاج منقارًا معقوفًا حادًّا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d519d233-2936-53c9-8b6b-88ea8861fde8', '911eb879-9600-50eb-adaa-8f8a6699adf2', 'لاحظ تلميذ حيوانًا له قواطع حادّة، أنياب متوسّطة غير بارزة كثيرًا، وأضراس بعضها مسطّح وبعضها حادّ. أيّ استنتاج يناسب هذه الملاحظة؟', '[{"id":"a","text":"الحيوان عاشب خالص لأنّ له أضراسًا مسطّحة"},{"id":"b","text":"الحيوان لاحم خالص لأنّ له أنيابًا"},{"id":"c","text":"الملاحظة غير كافية لأيّ استنتاج"},{"id":"d","text":"الحيوان قارت على الأرجح، لأنّ مزيج شكلَي الأضراس مع أنياب متوسّطة يوافق تكيّف النظامين معًا"}]'::jsonb, 'd', 'مزج شكلَي الأضراس (مسطّحة وحادّة) مع أنياب متوسّطة غير بارزة هو بالضبط ما يميّز أسنان القارت، المتكيّفة مع النبات والحيوان معًا، لا أسنان عاشب خالص أو لاحم خالص.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f0daec27-e71d-53c1-965a-0a40272be898', '0b434af5-07f7-5b82-956d-9e708a6aeac8', 'sciences-vie-terre-7eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): التّغذية عند الحيوان', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1b3a6a37-7f8a-5eee-8b45-56bc8875ee7d', 'f0daec27-e71d-53c1-965a-0a40272be898', 'الغزال يقتات على الأعشاب والأوراق فقط، ولا يصطاد أيّ حيوان. إلى أيّ نظام غذائي ينتمي؟', '[{"id":"a","text":"عاشب"},{"id":"b","text":"لاحم"},{"id":"c","text":"قارت"},{"id":"d","text":"لا ينتمي إلى نظام معروف"}]'::jsonb, 'a', 'الغزال يقتات على النبات فقط (أعشاب وأوراق) دون صيد أيّ حيوان، وهذا هو النظام العاشب.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5db28140-4989-5b42-8e20-9f307c9199b5', 'f0daec27-e71d-53c1-965a-0a40272be898', 'القنفذ يأكل الحشرات والديدان بشكل رئيسيّ، ويأكل أيضًا بعض الثمار الساقطة. إلى أيّ نظام غذائي ينتمي؟', '[{"id":"a","text":"عاشب"},{"id":"b","text":"لاحم"},{"id":"c","text":"قارت"},{"id":"d","text":"لا يتغذّى إطلاقًا"}]'::jsonb, 'c', 'القنفذ يجمع في غذائه بين الحيوان (الحشرات والديدان) والنبات (الثمار)، وهذا يجعله قارتًا.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('51a590a6-a028-59c0-b2ad-15058a720efc', 'f0daec27-e71d-53c1-965a-0a40272be898', 'الدرّاج طائر بريّ يتغذّى على الحبوب والبذور. أيّ شكل منقار يناسبه؟', '[{"id":"a","text":"منقار معقوف حادّ"},{"id":"b","text":"منقار قصير مخروطي قويّ"},{"id":"c","text":"أسنان صغيرة حادّة"},{"id":"d","text":"منقار مسطّح واسع"}]'::jsonb, 'b', 'الدرّاج طائر حبوبيّ، فمنقاره قصير مخروطي قويّ مخصّص لكسر الحبوب والبذور، لا منقار مصمّم لتمزيق اللحم.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bc8ed3cf-f419-5ef7-9dd9-fc79bc642c63', 'f0daec27-e71d-53c1-965a-0a40272be898', 'أيّ مقارنة من التالي تصف بدقّة الفرق بين أسنان العاشب واللاحم والقارت؟', '[{"id":"a","text":"العاشب واللاحم والقارت يملكون نفس شكل الأسنان تمامًا"},{"id":"b","text":"العاشب فقط يملك أنيابًا بارزة، أمّا اللاحم والقارت فلا يملكانها إطلاقًا"},{"id":"c","text":"اللاحم فقط يملك أضراسًا، أمّا العاشب والقارت فلا يملكان أضراسًا"},{"id":"d","text":"العاشب يملك أضراسًا مسطّحة وأنيابًا ضعيفة، اللاحم يملك أنيابًا وأضراسًا حادّة، والقارت يجمع بين الشكلين معًا"}]'::jsonb, 'd', 'كلّ نظام غذائي يترك بصمته على شكل الأسنان: العاشب أضراس مسطّحة وأنياب ضعيفة، اللاحم أنياب وأضراس حادّة، والقارت مزيج من الشكلين معًا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('497cbd34-a4a9-5879-9f58-e4ba1d58c740', 'f0daec27-e71d-53c1-965a-0a40272be898', 'لو فقد حيوان لاحم أنيابه بحادث، فما الأثر المباشر المتوقّع على تغذيته؟', '[{"id":"a","text":"يصعب عليه الإمساك بفريسته وقتلها، فيتأثّر حصوله على غذائه مباشرة"},{"id":"b","text":"لا يتأثّر تغذيته إطلاقًا لأنّ الأضراس تكفي وحدها"},{"id":"c","text":"يتحوّل تلقائيًّا إلى نظام عاشب"},{"id":"d","text":"تنمو له أضراس إضافية لتعويض الأنياب المفقودة فورًا"}]'::jsonb, 'a', 'الأنياب هي الأداة الأساسية للاحم في الإمساك بالفريسة وقتلها؛ فقدانها يصعّب هذه المهمّة مباشرة ويؤثّر على حصوله على غذائه، ولا يمكن أن يغيّر نظامه الغذائي تلقائيًّا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('51719a9e-2fe1-5637-afef-0a589725ff36', 'f0daec27-e71d-53c1-965a-0a40272be898', 'ما العلاقة بين مرحلتَي «التفتيت الميكانيكي» و«تحوّل الغذاء داخل الجسم»؟', '[{"id":"a","text":"لا علاقة بين المرحلتين إطلاقًا"},{"id":"b","text":"يحدث التحوّل داخل الجسم قبل التفتيت الميكانيكي دائمًا"},{"id":"c","text":"التفتيت الميكانيكي خطوة أولى تُسهّل حدوث التحوّل الفعّال للغذاء داخل الجسم لاحقًا"},{"id":"d","text":"التفتيت الميكانيكي يُغني تمامًا عن أيّ تحوّل داخل الجسم"}]'::jsonb, 'c', 'التفتيت الميكانيكي بالأسنان أو المنقار خطوة تحضيرية تسبق البلع، وهي تُسهّل حدوث تحوّل الغذاء لاحقًا داخل الجسم إلى موادّ بسيطة قابلة للامتصاص.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d18c26f3-58ee-5148-a216-98e3c9bb4724', '0b434af5-07f7-5b82-956d-9e708a6aeac8', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐ (القمّة): التّغذية عند الحيوان', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3f73b590-9936-53e6-aa80-ac1f11c8de22', 'd18c26f3-58ee-5148-a216-98e3c9bb4724', 'أيّ الأوصاف التالية للحيوان يحوي تناقضًا واضحًا بين نظامه الغذائي وشكل أسنانه؟', '[{"id":"a","text":"حيوان يقتات على النبات فقط، وله أضراس واسعة مسطّحة وأنياب ضعيفة"},{"id":"b","text":"حيوان يقتات على النبات فقط، لكنّ له أنيابًا طويلة وحادّة بارزة جدًّا تُستعمل للصيد"},{"id":"c","text":"حيوان يقتات على اللحم فقط، وله أنياب طويلة حادّة وأضراس مسنّنة"},{"id":"d","text":"حيوان يقتات على النبات والحيوان معًا، وله أسنان تجمع بين الشكلين"}]'::jsonb, 'b', 'الوصف (ب) متناقض: لا معنى لوجود أنياب حادّة بارزة تُستعمل للصيد عند حيوان يقتات على النبات فقط دون أن يصطاد أيّ فريسة؛ الأنياب الصيّادة سمة اللاحم أو القارت لا العاشب الخالص.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9ff64570-8d12-5c0b-9df7-b1acac27f9b9', 'd18c26f3-58ee-5148-a216-98e3c9bb4724', 'قال تلميذ في تقريره: «كلّ الطيور اللاحمة تملك منقارًا قصيرًا مخروطيًّا لأنّ ذلك يسهّل عليها الطيران السريع أثناء الصيد.» أين الخطأ في هذا التقرير؟', '[{"id":"a","text":"لا خطأ، فالتقرير دقيق تمامًا"},{"id":"b","text":"الخطأ أنّ الطيور اللاحمة لا تطير إطلاقًا"},{"id":"c","text":"الخطأ أنّ سرعة الطيران لا علاقة لها بالصيد إطلاقًا"},{"id":"d","text":"الخطأ أنّ المنقار القصير المخروطي مخصّص لكسر الحبوب لا لتمزيق اللحم؛ الطيور اللاحمة تملك منقارًا معقوفًا وحادًّا"}]'::jsonb, 'd', 'الخطأ جوهريّ: المنقار القصير المخروطي القويّ مخصّص لكسر الحبوب عند الطيور العاشبة أو القارتة، لا لتمزيق اللحم. الطيور اللاحمة الصائدة كالصقر والبوم تملك بالمقابل منقارًا معقوفًا وحادًّا.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f831c24a-7751-50a2-bb48-56ac23e737a8', 'd18c26f3-58ee-5148-a216-98e3c9bb4724', 'قارِن الملاحظتين التاليتين: الحيوان (1) له أنياب طويلة حادّة، أضراس مسنّنة، وقواطع صغيرة. الحيوان (2) له قواطع حادّة، أضراس واسعة مسطّحة، وأنياب منعدمة. أيّ استنتاج صحيح؟', '[{"id":"a","text":"الحيوان (1) عاشب والحيوان (2) لاحم"},{"id":"b","text":"الحيوان (1) لاحم والحيوان (2) عاشب"},{"id":"c","text":"كلا الحيوانين قارت"},{"id":"d","text":"لا يمكن الاستنتاج من شكل الأسنان وحده"}]'::jsonb, 'b', 'أسنان الحيوان (1) — أنياب طويلة حادّة وأضراس مسنّنة — توصيف مطابق للاحم؛ وأسنان الحيوان (2) — قواطع حادّة وأضراس واسعة مسطّحة بلا أنياب — توصيف مطابق للعاشب.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d5e31ca7-0792-57d4-b32b-fbabb21c40bc', 'd18c26f3-58ee-5148-a216-98e3c9bb4724', 'أيّ العبارات الأربع التالية بخصوص التّغذية عند الحيوان **خاطئة**؟', '[{"id":"a","text":"الحيوان مستهلك لأنّه لا يصنع غذاءه بنفسه"},{"id":"b","text":"تختلف أسنان الحيوان حسب نظامه الغذائي"},{"id":"c","text":"تملك جميع الطيور أسنانًا حادّة تساعدها على تمزيق غذائها"},{"id":"d","text":"يتحوّل الغذاء داخل جسم الحيوان إلى موادّ بسيطة يمتصّها الجسم"}]'::jsonb, 'c', 'العبارة الخاطئة هي أنّ جميع الطيور تملك أسنانًا: فالطيور لا تملك أسنانًا إطلاقًا، بل تتكيّف مع نظامها الغذائي بشكل منقارها. العبارات الثلاث الأخرى صحيحة تمامًا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b645543a-88c1-5e11-8ded-f1954d894295', 'd18c26f3-58ee-5148-a216-98e3c9bb4724', 'وُجد حيوان يقتات على غذاء متنوّع: أعشاب، ثمار، وأحيانًا حشرات صغيرة يمسك بها بسهولة. عند فحص أسنانه، وُجد أنّ أضراسه تجمع بين الشكل المسطّح والشكل الحادّ. أيّ استنتاج صحيح؟', '[{"id":"a","text":"نظامه قارت، وشكل أضراسه المختلط يتّسق مع هذا التصنيف"},{"id":"b","text":"نظامه عاشب، وأسنانه تؤكّد ذلك"},{"id":"c","text":"نظامه لاحم، وأسنانه تؤكّد ذلك"},{"id":"d","text":"نظامه قارت، لكنّ أسنانه تناقض هذا التصنيف"}]'::jsonb, 'a', 'غذاؤه المتنوّع (نبات وحيوان معًا) يصنّفه قارتًا، وشكل أضراسه المختلط بين المسطّح والحادّ يتّسق تمامًا مع هذا التصنيف، لا يناقضه.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4e3e2ad5-fcad-54af-ab86-27dbf37af687', 'd18c26f3-58ee-5148-a216-98e3c9bb4724', 'لوحظ طائر A بمنقار معقوف حادّ، وطائر B بمنقار قصير مخروطيّ. لوحظ أيضًا ثدييّ C بأنياب طويلة حادّة وأضراس مسنّنة، وثدييّ D بأضراس واسعة مسطّحة بلا أنياب بارزة. أيّ تجميع صحيح لأنظمتها الغذائية الأربعة معًا؟', '[{"id":"a","text":"A لاحم، B عاشب أو قارت حبوبيّ، C لاحم، D عاشب"},{"id":"b","text":"A عاشب، B لاحم، C عاشب، D لاحم"},{"id":"c","text":"A لاحم، B لاحم، C عاشب، D لاحم"},{"id":"d","text":"لا يمكن تصنيف أيّ منها من هذه الأوصاف"}]'::jsonb, 'a', 'كلّ وصف يطابق نظامًا محدّدًا: منقار A المعقوف الحادّ سمة لاحم، منقار B القصير المخروطي سمة عاشب أو قارت حبوبيّ، أنياب C الحادّة وأضراسه المسنّنة سمة لاحم، وأضراس D المسطّحة بلا أنياب سمة عاشب.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('dd78be23-ea58-5b8e-8f38-07a1a6615ea8', 'cfc76b85-e661-5d71-8c1f-a21e37b1203a', 'sciences-vie-terre-7eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e2a35f1a-b2ea-5020-abe0-e0e4328def25', 'dd78be23-ea58-5b8e-8f38-07a1a6615ea8', 'ما الكائن الحيّ الذي يشكّل دائمًا نقطة الانطلاق في أيّ سلسلة غذائية؟', '[{"id":"a","text":"مستهلك أوّل"},{"id":"b","text":"مستهلك ثانٍ"},{"id":"c","text":"منتج"},{"id":"d","text":"مفكّك"}]'::jsonb, 'c', 'تبدأ كلّ سلسلة غذائية دائمًا بمنتج (نبتة خضراء)، لأنّه الكائن الوحيد القادر على صنع مادّة عضوية من مادّة معدنية بنفسه.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b9735751-6bac-50d2-abe0-65c56fdf1ecd', 'dd78be23-ea58-5b8e-8f38-07a1a6615ea8', 'في سلسلة نخلة → حشرة، ماذا يعني السهم بين الكائنَين؟', '[{"id":"a","text":"النخلة تأكل الحشرة"},{"id":"b","text":"النخلة تُؤكل من طرف الحشرة"},{"id":"c","text":"الحشرة تُؤكل من طرف النخلة"},{"id":"d","text":"لا علاقة غذائية بين الكائنَين"}]'::jsonb, 'b', 'السهم في السلسلة الغذائية معناه الثابت «يُؤكل من طرف»: نخلة → حشرة تعني أنّ النخلة تُؤكل من طرف الحشرة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fa3de516-cc3e-5c6f-a2e0-2184a97dab92', 'dd78be23-ea58-5b8e-8f38-07a1a6615ea8', 'في الواحة، تأكل يرقة حشرة أوراق النخلة، ويأكل عصفور دوري هذه اليرقة. إلى أيّ حلقة ينتمي العصفور الدوري؟', '[{"id":"a","text":"منتج"},{"id":"b","text":"مستهلك أوّل"},{"id":"c","text":"مفكّك"},{"id":"d","text":"مستهلك ثانٍ"}]'::jsonb, 'd', 'العصفور الدوري يتغذّى على اليرقة (وهي مستهلك أوّل)، فهو يمثّل مستهلكًا ثانيًا في هذه السلسلة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('359df85c-4a0b-533d-b8e3-c7c248effe5b', 'dd78be23-ea58-5b8e-8f38-07a1a6615ea8', 'ما الدور الذي تقوم به المفكّكات (كالجراثيم والفطريات) في التراب؟', '[{"id":"a","text":"صنع المادّة العضوية من الأملاح المعدنية"},{"id":"b","text":"افتراس المستهلكات وهي حيّة مباشرة"},{"id":"c","text":"تحويل المادّة العضوية الميّتة إلى أملاح معدنية"},{"id":"d","text":"صنع الغذاء بالتركيب الضوئي"}]'::jsonb, 'c', 'المفكّكات كائنات مجهرية في التراب (جراثيم وفطريات) تحوّل المادّة العضوية الميّتة إلى أملاح معدنية تعود إلى التراب.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('97d11cfc-4ce5-5fea-8e7f-b498e5aede5d', 'dd78be23-ea58-5b8e-8f38-07a1a6615ea8', 'لو اختفى فجأة الحيوان اللاحم الذي يأكل الأرانب في وسط ما، ماذا يُتوقّع أن يحدث للتوازن الطبيعي؟', '[{"id":"a","text":"تتكاثر الأرانب بشكل غير منضبط وتستنزف النبات"},{"id":"b","text":"يبقى التوازن كما هو دون أيّ تغيير"},{"id":"c","text":"تختفي الأرانب فورًا"},{"id":"d","text":"تتحوّل الأرانب إلى مفكّكات"}]'::jsonb, 'a', 'باختفاء مفترسها، تتكاثر الأرانب دون رادع طبيعي، فتلتهم النبات بشراهة وتستنزفه، ما يختلّ به التوازن الطبيعي للوسط.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c2af133d-6d36-5780-ab3e-786ec84f5e7f', 'cfc76b85-e661-5d71-8c1f-a21e37b1203a', 'sciences-vie-terre-7eme', '⭐ تمرين: العلاقات والسّلاسل الغذائية', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a13a15ce-f508-5727-84c6-10a906b8e7f5', 'c2af133d-6d36-5780-ab3e-786ec84f5e7f', 'في سلسلة الواحة نخلة → يرقة حشرة → عصفور دوري، أيّ كائن من الثلاثة يمثّل المنتج؟', '[{"id":"a","text":"النخلة"},{"id":"b","text":"يرقة الحشرة"},{"id":"c","text":"العصفور الدوري"},{"id":"d","text":"لا يوجد منتج في هذه السلسلة"}]'::jsonb, 'a', 'النخلة نبتة خضراء تصنع غذاءها بنفسها، فهي المنتج الذي تبدأ به هذه السلسلة الغذائية.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8596801d-3e01-506a-ba05-87205008983c', 'c2af133d-6d36-5780-ab3e-786ec84f5e7f', 'في الغربة، تأكل جرادة أوراق نبتة الحلفاء. إلى أيّ حلقة تنتمي الجرادة؟', '[{"id":"a","text":"منتج"},{"id":"b","text":"مستهلك أوّل"},{"id":"c","text":"مستهلك ثانٍ"},{"id":"d","text":"مفكّك"}]'::jsonb, 'b', 'الجرادة تتغذّى مباشرة على نبتة الحلفاء (المنتج)، فهي مستهلك أوّل في هذه السلسلة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f752f717-3858-5672-b008-e5715cfc7749', 'c2af133d-6d36-5780-ab3e-786ec84f5e7f', 'على الشاطئ، تأكل سمكة صغيرة عوالق نباتية، ثمّ تأكل سمكة كبيرة السمكة الصغيرة. إلى أيّ حلقة تنتمي السمكة الكبيرة؟', '[{"id":"a","text":"منتج"},{"id":"b","text":"مستهلك أوّل"},{"id":"c","text":"مستهلك ثانٍ"},{"id":"d","text":"مفكّك"}]'::jsonb, 'c', 'السمكة الكبيرة تتغذّى على السمكة الصغيرة (وهي مستهلك أوّل)، فتصبح بذلك مستهلكًا ثانيًا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f3e3c555-76cc-5f39-a356-d885fb247998', 'c2af133d-6d36-5780-ab3e-786ec84f5e7f', 'في سلسلة حلفاء → جرادة، ماذا يعني السهم (→) بين الكائنَين؟', '[{"id":"a","text":"الحلفاء تأكل الجرادة"},{"id":"b","text":"الجرادة تُؤكل من طرف الحلفاء"},{"id":"c","text":"لا علاقة غذائية بين الكائنَين"},{"id":"d","text":"الحلفاء تُؤكل من طرف الجرادة"}]'::jsonb, 'd', 'السهم معناه الثابت «يُؤكل من طرف»: حلفاء → جرادة تعني أنّ نبتة الحلفاء تُؤكل من طرف الجرادة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('496e1016-e5d7-578f-874b-1feb326ebe0e', 'c2af133d-6d36-5780-ab3e-786ec84f5e7f', 'أيّ كائنات حيّة تُسمّى مفكّكات؟', '[{"id":"a","text":"جراثيم وفطريات التربة"},{"id":"b","text":"النباتات الخضراء فقط"},{"id":"c","text":"الحيوانات اللاحمة الكبيرة"},{"id":"d","text":"الأسماك في البحر"}]'::jsonb, 'a', 'المفكّكات كائنات مجهرية تعيش في التراب، أهمّها الجراثيم والفطريات، وهي التي تحوّل المادّة العضوية الميّتة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9dd1810e-9d57-58be-a42f-9a36cf726f30', 'c2af133d-6d36-5780-ab3e-786ec84f5e7f', 'ماذا تنتج المفكّكات من تحويل المادّة العضوية الميّتة؟', '[{"id":"a","text":"أكسجين"},{"id":"b","text":"أملاح معدنية"},{"id":"c","text":"ماء فقط"},{"id":"d","text":"مادّة عضوية جديدة مباشرة"}]'::jsonb, 'b', 'تحوّل المفكّكات المادّة العضوية الميّتة إلى أملاح معدنية تعود إلى التراب، فتمتصّها جذور النباتات من جديد.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b0c15d35-4771-54be-b9d8-7b8fef99bd31', 'cfc76b85-e661-5d71-8c1f-a21e37b1203a', 'sciences-vie-terre-7eme', '⚔️ زعيم الفصل ⭐⭐⭐: العلاقات والسّلاسل الغذائية', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fd4ddb54-9879-53c6-95ce-9f92ea7fee38', 'b0c15d35-4771-54be-b9d8-7b8fef99bd31', 'في سلسلة الواحة نخلة → يرقة حشرة → عصفور دوري → صقر حرّ، ماذا يمثّل الصقر الحرّ؟', '[{"id":"a","text":"مستهلك ثانٍ"},{"id":"b","text":"منتج"},{"id":"c","text":"مستهلك ثالث"},{"id":"d","text":"مفكّك"}]'::jsonb, 'c', 'الصقر الحرّ يتغذّى على العصفور الدوري (وهو مستهلك ثانٍ)، فهو بذلك مستهلك ثالث في هذه السلسلة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0683a981-34db-52f9-a048-5bc9e6c5590f', 'b0c15d35-4771-54be-b9d8-7b8fef99bd31', 'لماذا يجب أن تبدأ كلّ سلسلة غذائية بمنتج لا بمستهلك؟', '[{"id":"a","text":"لأنّ المنتج وحده يصنع مادّة عضوية من مادّة معدنية بواسطة الضوء"},{"id":"b","text":"لأنّ المنتج أكبر حجمًا من المستهلكات"},{"id":"c","text":"لأنّ المستهلكات لا تتغذّى إطلاقًا"},{"id":"d","text":"لا سبب علميّ، مجرّد اصطلاح"}]'::jsonb, 'a', 'المنتج هو الكائن الوحيد القادر على صنع مادّة عضوية من مادّة معدنية بفضل الضوء؛ لذلك يجب أن تبدأ كلّ سلسلة به.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e320b774-b712-5cb5-acc8-66a9962fad3e', 'b0c15d35-4771-54be-b9d8-7b8fef99bd31', 'كتب تلميذ السلسلة التالية: صقر حرّ → عصفور دوري → يرقة حشرة → نخلة. أين الخطأ في هذه الكتابة؟', '[{"id":"a","text":"لا خطأ، فالسلسلة صحيحة"},{"id":"b","text":"الخطأ أنّ اتّجاه الأسهم معكوس؛ السلسلة الصحيحة تبدأ بالنخلة (المنتج) وتنتهي بالصقر"},{"id":"c","text":"الخطأ أنّ الصقر لا يأكل العصفور إطلاقًا"},{"id":"d","text":"الخطأ أنّ اليرقة مفكّك لا مستهلك"}]'::jsonb, 'b', 'اتّجاه الأسهم في هذه الكتابة معكوس: السلسلة الصحيحة تبدأ دائمًا بالمنتج (النخلة) وتنتهي بأعلى مستهلك (الصقر)، لا العكس.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e944f329-9a0f-5d61-b4f7-3e41d620b4eb', 'b0c15d35-4771-54be-b9d8-7b8fef99bd31', 'بعد أن يموت الصقر الحرّ في نهاية هذه السلسلة، ماذا يحدث لجثّته في التراب؟', '[{"id":"a","text":"تبقى دون أيّ تحوّل"},{"id":"b","text":"تتحوّل مباشرة إلى نخلة جديدة"},{"id":"c","text":"تحوّلها المفكّكات (جراثيم وفطريات) إلى أملاح معدنية تمتصّها جذور النخلة"},{"id":"d","text":"تتحوّل تلقائيًّا إلى مستهلك أوّل جديد"}]'::jsonb, 'c', 'تتكفّل المفكّكات (جراثيم وفطريات التربة) بتحويل جثّة الصقر الميّتة إلى أملاح معدنية، تمتصّها جذور النخلة من جديد.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a5864d00-d1bb-51d0-9b43-eaa47c0717fc', 'b0c15d35-4771-54be-b9d8-7b8fef99bd31', 'إذا اصطاد الإنسان أعدادًا كبيرة من الصقور الحرّة في الواحة، فماذا يُتوقّع أن يحدث لأعداد العصافير الدورية؟', '[{"id":"a","text":"تتناقص أيضًا فورًا"},{"id":"b","text":"تتكاثر بشكل غير منضبط لغياب مفترسها الطبيعي"},{"id":"c","text":"لا تتأثّر إطلاقًا"},{"id":"d","text":"تتحوّل إلى مفكّكات"}]'::jsonb, 'b', 'باختفاء الصقور (مفترسها الطبيعي)، تتكاثر العصافير الدورية دون رادع، ما يختلّ به التوازن الطبيعي للواحة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('84f90dbf-8c18-5f2e-a2d3-eae7cbe9e9db', 'b0c15d35-4771-54be-b9d8-7b8fef99bd31', 'هل يمكن أن تبدأ سلسلة غذائية بمفكّك بدل المنتج؟', '[{"id":"a","text":"نعم، لأنّ المفكّك يصنع غذاء المنتج"},{"id":"b","text":"نعم، لأنّ المفكّك أوّل من يظهر في الوسط"},{"id":"c","text":"لا فرق بين المفكّك والمنتج"},{"id":"d","text":"لا، لأنّ المفكّك يتغذّى على بقايا ميّتة لا على مادّة معدنية مباشرة، والسلسلة تبدأ دائمًا بمنتج حيّ"}]'::jsonb, 'd', 'المفكّك لا يصنع مادّة عضوية من مادّة معدنية كالمنتج، بل يتغذّى على بقايا ميّتة؛ لذلك لا يمكن أن يكون الحلقة الأولى في السلسلة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9e7170b4-4429-536f-bd07-4955e4d39a2e', 'cfc76b85-e661-5d71-8c1f-a21e37b1203a', 'sciences-vie-terre-7eme', '⭐⭐ تمرين مراجعة (نمط امتحان): العلاقات والسّلاسل الغذائية', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8dec583a-e65c-57f7-bf42-f1f53d115296', '9e7170b4-4429-536f-bd07-4955e4d39a2e', 'في سلسلة عوالق نباتية → سمكة صغيرة → سمكة كبيرة → نورس، إلى أيّ حلقة تنتمي العوالق النباتية؟', '[{"id":"a","text":"منتج"},{"id":"b","text":"مستهلك أوّل"},{"id":"c","text":"مستهلك ثانٍ"},{"id":"d","text":"مفكّك"}]'::jsonb, 'a', 'العوالق النباتية كائنات خضراء تصنع غذاءها بنفسها، فهي المنتج الذي تبدأ به هذه السلسلة البحرية.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bc5d79a6-270a-5d43-b157-c03acfcf3e15', '9e7170b4-4429-536f-bd07-4955e4d39a2e', 'أيّ كائن في السلسلة السابقة يمثّل المستهلك الثالث؟', '[{"id":"a","text":"سمكة كبيرة"},{"id":"b","text":"النورس"},{"id":"c","text":"سمكة صغيرة"},{"id":"d","text":"عوالق نباتية"}]'::jsonb, 'b', 'النورس يتغذّى على السمكة الكبيرة (وهي مستهلك ثانٍ)، فهو بذلك مستهلك ثالث في هذه السلسلة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9ed9c258-92e9-55cf-bbba-d4d3e38aa722', '9e7170b4-4429-536f-bd07-4955e4d39a2e', 'في سلسلة حلفاء → جرادة → سحلية → أفعى، ماذا يعني السهم بين الجرادة والسحلية؟', '[{"id":"a","text":"السحلية تُؤكل من طرف الجرادة"},{"id":"b","text":"الجرادة تأكل السحلية"},{"id":"c","text":"الجرادة تُؤكل من طرف السحلية"},{"id":"d","text":"لا علاقة غذائية بينهما"}]'::jsonb, 'c', 'السهم معناه الثابت «يُؤكل من طرف»: جرادة → سحلية تعني أنّ الجرادة تُؤكل من طرف السحلية.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f340c2ca-02df-5855-87cd-2c126efe457c', '9e7170b4-4429-536f-bd07-4955e4d39a2e', 'ما وظيفة المفكّكات بالضبط تجاه بقايا هذه السلسلة (أفعى ميّتة مثلًا)؟', '[{"id":"a","text":"افتراسها وهي حيّة"},{"id":"b","text":"نقلها إلى وسط آخر"},{"id":"c","text":"لا علاقة للمفكّكات ببقايا الحيوانات"},{"id":"d","text":"تحويلها إلى أملاح معدنية تعود إلى التراب"}]'::jsonb, 'd', 'تتكفّل المفكّكات (جراثيم وفطريات التربة) بتحويل جثّة الأفعى الميّتة إلى أملاح معدنية تعود إلى التراب.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('31cdf54a-964f-5342-b50f-af0804b9d8a1', '9e7170b4-4429-536f-bd07-4955e4d39a2e', 'لو غابت السحلية من سلسلة حلفاء → جرادة → سحلية → أفعى، فما الأثر المباشر المتوقّع على أعداد الجراد؟', '[{"id":"a","text":"تتكاثر الجرادة لغياب مفترسها المباشر"},{"id":"b","text":"تنقرض الجرادة فورًا"},{"id":"c","text":"لا يتأثّر عدد الجراد إطلاقًا"},{"id":"d","text":"تتحوّل الجرادة إلى مفكّك"}]'::jsonb, 'a', 'السحلية هي مفترس الجرادة المباشر؛ باختفائها تتكاثر الجرادة دون رادع طبيعي، ما يختلّ به التوازن.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('06836d57-88af-56ff-96a9-0fd5b5cd735a', '9e7170b4-4429-536f-bd07-4955e4d39a2e', 'أيّ عبارة صحيحة بخصوص التوازن الطبيعي للوسط؟', '[{"id":"a","text":"لا علاقة بين اختفاء حلقة واختلال التوازن"},{"id":"b","text":"التوازن يتحقّق عندما تلعب كلّ حلقة (منتج، مستهلكات، مفكّكات) دورها"},{"id":"c","text":"التوازن لا يتأثّر أبدًا مهما تغيّرت الحلقات"},{"id":"d","text":"المفكّكات وحدها تكفي لضمان التوازن"}]'::jsonb, 'b', 'يتحقّق التوازن الطبيعي عندما تؤدّي كلّ حلقة دورها: المنتج يصنع الغذاء، المستهلكات تتغذّى ضمن حدود معقولة، والمفكّكات تعيد المادّة العضوية أملاحًا.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('111a2ec7-0edb-5981-a8f0-5fb499de5cd8', 'cfc76b85-e661-5d71-8c1f-a21e37b1203a', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: العلاقات والسّلاسل الغذائية', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9e4a41a4-7dfb-52f4-baef-f7ecd5a79706', '111a2ec7-0edb-5981-a8f0-5fb499de5cd8', 'لاحظ تلميذ سلسلة الواحة نخلة → يرقة حشرة → عصفور دوري → صقر حرّ. إذا افترسَ الإنسان أعدادًا كبيرة من العصافير الدورية لبيعها، فما الأثر المتوقّع أوّلًا على أعداد اليرقات، ثمّ على النخيل؟', '[{"id":"a","text":"تتكاثر اليرقات لغياب مفترسها العصفور، فتلتهم أوراق النخيل بشراهة وتضرّ بها"},{"id":"b","text":"تتناقص اليرقات، فتزدهر النخيل أكثر"},{"id":"c","text":"لا يتأثّر أيّ منهما إطلاقًا"},{"id":"d","text":"تتحوّل اليرقات إلى مفكّكات فتحمي النخيل"}]'::jsonb, 'a', 'بغياب العصفور (مفترس اليرقات)، تتكاثر اليرقات دون رادع فتلتهم أوراق النخيل بشراهة، وهو أثر غير مباشر متسلسل عبر حلقتَين.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('279ed419-928a-5674-8bb0-514779655a25', '111a2ec7-0edb-5981-a8f0-5fb499de5cd8', 'في الغربة، ماتت أفعى في نهاية سلسلة حلفاء → جرادة → سحلية → أفعى. أيّ مسار صحيح لمصير موادّها العضوية إلى أن تصبح جزءًا من نبتة حلفاء جديدة؟', '[{"id":"a","text":"الأفعى ← تُؤكل من طرف مفترس أعلى ← يعود مباشرة نباتًا"},{"id":"b","text":"الأفعى الميّتة تتحوّل تلقائيًّا دون وسيط إلى نبتة حلفاء"},{"id":"c","text":"الأفعى الميّتة ← تفكّكها الجراثيم والفطريات ← أملاح معدنية في التراب ← تمتصّها جذور نبتة حلفاء"},{"id":"d","text":"الأفعى الميّتة تبقى كما هي إلى الأبد دون أيّ دور للمفكّكات"}]'::jsonb, 'c', 'المفكّكات وحدها القادرة على تحويل جثّة الأفعى الميّتة إلى أملاح معدنية في التراب، تمتصّها جذور نبتة الحلفاء من جديد لتصنع مادّة عضوية.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bcc98ec6-7879-5e8c-bf0d-b71c6c33da31', '111a2ec7-0edb-5981-a8f0-5fb499de5cd8', 'كتب تلميذ في تقريره: «في سلسلة عوالق نباتية → سمكة صغيرة → سمكة كبيرة → نورس، يمكن أن تبدأ السلسلة بالنورس لأنّه أكبر الكائنات حجمًا.» أين الخطأ في هذا الاستنتاج؟', '[{"id":"a","text":"لا خطأ، فحجم الكائن يحدّد بداية السلسلة"},{"id":"b","text":"الخطأ أنّ النورس لا يتغذّى على الأسماك إطلاقًا"},{"id":"c","text":"الخطأ أنّ العوالق النباتية مفكّكات لا منتج"},{"id":"d","text":"الخطأ أنّ السلسلة تبدأ دائمًا بمنتج يصنع غذاءه بنفسه (كالعوالق النباتية هنا)، لا بأكبر كائن حجمًا"}]'::jsonb, 'd', 'معيار بداية السلسلة الغذائية ليس الحجم، بل القدرة على صنع الغذاء بنفسه؛ العوالق النباتية هي المنتج، مهما كان النورس أكبر حجمًا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d8aa21ad-48d2-5ffe-8d28-5ce68cb49aee', '111a2ec7-0edb-5981-a8f0-5fb499de5cd8', 'أيّ العبارات التالية بخصوص السلاسل الغذائية والمفكّكات **خاطئة**؟', '[{"id":"a","text":"كلّ سلسلة غذائية تبدأ بمنتج ينتج مادّة عضوية بنفسه"},{"id":"b","text":"المفكّكات هي التي تفترس المستهلك الثالث وهو حيّ لتنهي به السلسلة"},{"id":"c","text":"المفكّكات تحوّل المادّة العضوية الميّتة إلى أملاح معدنية"},{"id":"d","text":"سهم السلسلة الغذائية معناه الثابت هو «يُؤكل من طرف»"}]'::jsonb, 'b', 'العبارة الخاطئة هي (ب): المفكّكات لا تفترس أيّ مستهلك وهو حيّ، بل تتغذّى فقط على المادّة العضوية الميّتة بعد موت الكائن.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('060f2f5f-20e4-5448-9298-2d1405b3de2a', '111a2ec7-0edb-5981-a8f0-5fb499de5cd8', 'هل يمكن أن تتغذّى المفكّكات مباشرة على نبتة حلفاء خضراء حيّة تقوم بعملية التركيب الضوئي؟', '[{"id":"a","text":"لا، لأنّ المفكّكات تتغذّى على المادّة العضوية الميّتة (بقايا وفضلات)، لا على كائن حيّ ينمو"},{"id":"b","text":"نعم، لأنّ كلّ نبات مصدر غذاء للمفكّكات دائمًا"},{"id":"c","text":"نعم، لأنّ المفكّكات أقوى من المنتج"},{"id":"d","text":"لا فرق بين نبتة حيّة وبقايا ميّتة عند المفكّكات"}]'::jsonb, 'a', 'المفكّكات مختصّة بالمادّة العضوية الميّتة (بقايا وفضلات)، ولا تتغذّى على نبتة حيّة تقوم بالتركيب الضوئي.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d84b209a-6be7-5c12-88ff-5ccf23b8276a', '111a2ec7-0edb-5981-a8f0-5fb499de5cd8', 'وصف باحث وسطًا بيئيًّا يضمّ كائنًا ينتج غذاءه من الضوء والماء والأملاح المعدنية، وكائنًا يتغذّى عليه مباشرة، وكائنًا ثالثًا يفترس الثاني، وكائنات مجهرية في التراب تحوّل بقايا الثلاثة إلى أملاح من جديد. كم عدد المستهلكات في هذا الوصف؟', '[{"id":"a","text":"مستهلك واحد فقط"},{"id":"b","text":"لا يوجد أيّ مستهلك"},{"id":"c","text":"مستهلكان اثنان"},{"id":"d","text":"ثلاثة مستهلكين"}]'::jsonb, 'c', 'الوصف يضمّ منتجًا واحدًا، ومستهلكًا أوّل (يتغذّى على المنتج)، ومستهلكًا ثانيًا (يفترس الأوّل)؛ أمّا الكائنات المجهرية فمفكّكات لا تُحسب مستهلكات.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ec8bc23b-d478-5a5b-808d-1713ec1a4e23', 'cfc76b85-e661-5d71-8c1f-a21e37b1203a', 'sciences-vie-terre-7eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): العلاقات والسّلاسل الغذائية', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b219dd71-2a07-58bd-8a10-69b7210bae41', 'ec8bc23b-d478-5a5b-808d-1713ec1a4e23', 'أيّ تعريف صحيح للمنتج في السلسلة الغذائية؟', '[{"id":"a","text":"كائن يتغذّى على المستهلكات فقط"},{"id":"b","text":"كائن حيّ يصنع غذاءه العضوي بنفسه انطلاقًا من مادّة معدنية"},{"id":"c","text":"كائن يحوّل المادّة العضوية إلى أملاح معدنية"},{"id":"d","text":"كائن يعيش في التراب فقط"}]'::jsonb, 'b', 'المنتج كائن حيّ (نبتة خضراء) يصنع غذاءه العضوي بنفسه انطلاقًا من الماء والأملاح المعدنية بفضل الضوء.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('14fe9ecd-fa80-53fd-929c-271d4cc51cc2', 'ec8bc23b-d478-5a5b-808d-1713ec1a4e23', 'في سلسلة عوالق نباتية → سمكة صغيرة → سمكة كبيرة → نورس، أيّ حلقة هي المستهلك الأوّل؟', '[{"id":"a","text":"عوالق نباتية"},{"id":"b","text":"سمكة كبيرة"},{"id":"c","text":"سمكة صغيرة"},{"id":"d","text":"النورس"}]'::jsonb, 'c', 'السمكة الصغيرة تتغذّى مباشرة على العوالق النباتية (المنتج)، فهي المستهلك الأوّل في هذه السلسلة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('00755552-c112-5956-a515-0917e4cad61a', 'ec8bc23b-d478-5a5b-808d-1713ec1a4e23', 'ما الفرق الجوهري بين المستهلك والمفكّك في تعاملهما مع المادّة العضوية؟', '[{"id":"a","text":"المستهلك يتغذّى على كائنات حيّة ضمن السلسلة، بينما المفكّك يحوّل المادّة العضوية الميّتة إلى أملاح معدنية"},{"id":"b","text":"لا فرق بينهما إطلاقًا"},{"id":"c","text":"المفكّك يفترس المستهلكات وهي حيّة"},{"id":"d","text":"المستهلك هو الذي يحوّل المادّة العضوية إلى أملاح معدنية"}]'::jsonb, 'a', 'المستهلك يتغذّى على كائنات حيّة ضمن حلقات السلسلة، أمّا المفكّك فيتدخّل بعد الموت ليحوّل المادّة العضوية الميّتة إلى أملاح معدنية.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ed1f201b-b7da-5764-9b62-15af565a43f1', 'ec8bc23b-d478-5a5b-808d-1713ec1a4e23', 'في سلسلة نخلة → يرقة حشرة → عصفور دوري → صقر حرّ، ماذا يعني اتّجاه السهم بين اليرقة والعصفور؟', '[{"id":"a","text":"العصفور يأكل النخلة مباشرة"},{"id":"b","text":"اليرقة تأكل العصفور"},{"id":"c","text":"لا علاقة غذائية بين اليرقة والعصفور"},{"id":"d","text":"اليرقة تُؤكل من طرف العصفور"}]'::jsonb, 'd', 'السهم معناه الثابت «يُؤكل من طرف»: يرقة حشرة → عصفور دوري تعني أنّ اليرقة تُؤكل من طرف العصفور.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('615eef54-4185-549d-a99e-25a128065ff5', 'ec8bc23b-d478-5a5b-808d-1713ec1a4e23', 'لماذا يُعدّ اختفاء المفكّكات من وسط بيئي خطرًا على توازنه الطبيعي رغم أنّها كائنات مجهرية صغيرة؟', '[{"id":"a","text":"لأنّ المفكّكات تقتل المستهلكات مباشرة"},{"id":"b","text":"لأنّ بقايا الكائنات الميّتة تتراكم دون أن تتحوّل إلى أملاح معدنية، فتحرم المنتجات من غذائها المعدنيّ"},{"id":"c","text":"لأنّ اختفاء المفكّكات يحوّل المنتج إلى مستهلك"},{"id":"d","text":"لا خطر إطلاقًا لأنّها كائنات صغيرة جدًّا"}]'::jsonb, 'b', 'بدون المفكّكات، تتراكم بقايا الكائنات الميّتة دون أن تتحوّل إلى أملاح معدنية، فتُحرم المنتجات من غذائها المعدنيّ ويختلّ التوازن.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ec5f10dd-c4cb-5023-938e-c10ad9718358', 'ec8bc23b-d478-5a5b-808d-1713ec1a4e23', 'قارِن بين دور المنتج ودور المفكّك في السلسلة الغذائية: أيّ عبارة صحيحة؟', '[{"id":"a","text":"المنتج والمفكّك يؤدّيان نفس الدور تمامًا بلا أيّ فرق"},{"id":"b","text":"المفكّك وحده يغلق الدورة الغذائية دون أيّ حاجة إلى المنتج"},{"id":"c","text":"المنتج يصنع المادّة العضوية من المعدنية، والمفكّك يعيد تحويل المادّة العضوية الميّتة إلى معدنية؛ فكلاهما يغلقان الدورة الغذائية معًا"},{"id":"d","text":"المنتج يحوّل المادّة العضوية إلى أملاح معدنية مثل المفكّك تمامًا"}]'::jsonb, 'c', 'المنتج يصنع مادّة عضوية من مادّة معدنية، والمفكّك يعيد المادّة العضوية الميّتة إلى الحالة المعدنية؛ الدورَان متكاملان لا متطابقان.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fe0fb41e-470d-52f9-a73e-e48139308397', 'cfc76b85-e661-5d71-8c1f-a21e37b1203a', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐ (القمّة): العلاقات والسّلاسل الغذائية', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('21b51f5f-34c1-554a-b773-8f8f8570cb93', 'fe0fb41e-470d-52f9-a73e-e48139308397', 'توجد في التراب كائنات مجهرية (جراثيم وفطريات) تعيش على بقايا نباتية وحيوانية ميّتة. هل يصحّ اعتبارها الحلقة الأولى في السلسلة الغذائية بدل المنتج؟', '[{"id":"a","text":"نعم، لأنّها أوّل ما يظهر في التراب"},{"id":"b","text":"لا، لأنّها لا تصنع مادّة عضوية من مادّة معدنية، ولا تُعدّ حلقة أولى في السلسلة، بل تتدخّل بعد موت الكائنات"},{"id":"c","text":"نعم، لأنّها أصغر حجمًا من المنتج"},{"id":"d","text":"لا فرق بين المفكّك والمنتج في بداية السلسلة"}]'::jsonb, 'b', 'المفكّكات لا تصنع مادّة عضوية من مادّة معدنية كالمنتج، ولا تُدرَج ضمن حلقات السلسلة، بل تتدخّل لاحقًا على بقايا الكائنات الميّتة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('dbdb483b-3b9e-5254-900a-85ac3edbceb5', 'fe0fb41e-470d-52f9-a73e-e48139308397', 'كتب تلميذ: «في سلسلة نخلة → يرقة حشرة → عصفور دوري → صقر حرّ، إذا اختفى الصقر الحرّ، فسيختلّ التوازن مباشرة عند مستوى النخلة، فتموت النخلة فورًا.» أين الخطأ الدقيق في هذا الاستنتاج؟', '[{"id":"a","text":"لا خطأ، فالاستنتاج دقيق تمامًا"},{"id":"b","text":"الخطأ أنّ الصقر لا يفترس العصفور الدوري إطلاقًا"},{"id":"c","text":"الخطأ أنّ اختفاء الصقر يزيد أوّلًا أعداد العصافير، ثمّ يزيد افتراسها لليرقات، وهذا أثر غير مباشر وتدريجي على النخلة لا موت فوريّ"},{"id":"d","text":"الخطأ أنّ النخلة هي التي تفترس الصقر لا العكس"}]'::jsonb, 'c', 'الأثر يمرّ بخطوتَين متتاليتين: غياب الصقر يزيد أعداد العصافير أوّلًا، ثمّ تزيد العصافير افتراسها لليرقات؛ فالأثر على النخلة غير مباشر وتدريجي، لا موت فوريّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9491a138-caca-5378-921c-8dceb9e07119', 'fe0fb41e-470d-52f9-a73e-e48139308397', 'في وسط متوازن، أيّ ترتيب زمنيّ صحيح لِما يحدث لبقايا يرقة حشرة ماتت في الواحة؟', '[{"id":"a","text":"تُفترس اليرقة الميّتة مباشرة من طرف عصفور دوري ثمّ تتحوّل إلى نخلة"},{"id":"b","text":"تتحوّل اليرقة الميّتة فورًا إلى مستهلك ثانٍ جديد"},{"id":"c","text":"تتفكّك بقاياها بفعل جراثيم وفطريات التربة إلى أملاح معدنية، تمتصّها جذور النخلة لاحقًا فتُستعمل في صنع مادّة عضوية جديدة"},{"id":"d","text":"تبقى بقاياها في التراب دون أيّ تحوّل إلى الأبد"}]'::jsonb, 'c', 'المسار الصحيح: تفكيك بقايا اليرقة الميّتة بفعل المفكّكات إلى أملاح معدنية في التراب، تمتصّها جذور النخلة لاحقًا لصنع مادّة عضوية جديدة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d8b9e795-e6bd-5ec5-a0e0-1e8bb7ed9562', 'fe0fb41e-470d-52f9-a73e-e48139308397', 'أيّ العبارات التالية بخصوص العلاقات والسلاسل الغذائية **خاطئة**؟', '[{"id":"a","text":"يمكن لسلسلة غذائية واحدة أن تضمّ منتجًا وثلاثة مستهلكات على الأقلّ"},{"id":"b","text":"تلعب المفكّكات دورًا أساسيًّا في إعادة المادّة العضوية أملاحًا معدنية"},{"id":"c","text":"اختفاء حلقة واحدة من السلسلة قد يختلّ به التوازن الطبيعي للوسط"},{"id":"d","text":"يمكن أن تبدأ سلسلة غذائية بمستهلك ثانٍ دون الحاجة إلى منتج أو مستهلك أوّل قبله"}]'::jsonb, 'd', 'العبارة الخاطئة هي (د): لا يمكن أن تبدأ أيّ سلسلة غذائية بمستهلك ثانٍ، فالسلسلة تبدأ دائمًا بمنتج، يليه مستهلك أوّل، ثمّ مستهلك ثانٍ.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4deeb9d4-b102-5aba-b8e5-70493bcd19b2', 'fe0fb41e-470d-52f9-a73e-e48139308397', 'لوحظ في وسط بيئي أنّ أعداد كائن معيّن (لنسمّه X) تزايدت بشكل كبير وغير معتاد، بينما تناقصت أعداد النبتة التي يتغذّى عليها X مباشرة. أيّ تفسير الأكثر ترجيحًا لهذا التغيّر؟', '[{"id":"a","text":"X مفكّك جديد ظهر في الوسط"},{"id":"b","text":"اختفى أو تناقص عدد الحيوان الذي يفترس X عادةً، فتكاثر X دون رادع والتهم النبتة بشراهة"},{"id":"c","text":"النبتة توقّفت عن التركيب الضوئي فجأة دون أيّ سبب"},{"id":"d","text":"X تحوّل إلى منتج جديد"}]'::jsonb, 'b', 'التزايد غير المعتاد لأعداد X مع تناقص النبتة التي يفترسها يُرجّح غياب مفترس X الطبيعي، ما سمح له بالتكاثر دون رادع واستنزاف النبتة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cc4a4f21-0379-5da9-b3eb-9bad5c63739f', 'fe0fb41e-470d-52f9-a73e-e48139308397', 'وُصفت في دراسة ميدانية أربعة كائنات: (1) كائن أخضر يصنع غذاءه من الضوء والماء والأملاح المعدنية. (2) كائن يتغذّى مباشرة على الكائن (1). (3) كائن مجهريّ في التراب يحوّل بقايا الكائنات الميّتة إلى أملاح معدنية. (4) كائن يفترس الكائن (2) مباشرة. أيّ تصنيف صحيح لهذه الكائنات الأربعة؟', '[{"id":"a","text":"(1) منتج، (2) مستهلك أوّل، (3) مفكّك، (4) مستهلك ثانٍ"},{"id":"b","text":"(1) مستهلك أوّل، (2) منتج، (3) مستهلك ثانٍ، (4) مفكّك"},{"id":"c","text":"(1) منتج، (2) مفكّك، (3) مستهلك أوّل، (4) مستهلك ثانٍ"},{"id":"d","text":"جميع الكائنات الأربعة مستهلكات بدرجات مختلفة"}]'::jsonb, 'a', 'الكائن (1) منتج (يصنع غذاءه بنفسه)، الكائن (2) مستهلك أوّل (يأكل المنتج)، الكائن (3) مفكّك (يحوّل بقايا ميّتة)، والكائن (4) مستهلك ثانٍ (يفترس المستهلك الأوّل).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('88be354f-3405-5e62-95e5-322f21f3543c', '35d2091c-3f14-51af-a0d7-25db354cc4f2', 'sciences-vie-terre-7eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1687c79c-8930-5fb0-910b-bef4ed34d3a8', '88be354f-3405-5e62-95e5-322f21f3543c', 'ما تعريف التّربة؟', '[{"id":"a","text":"الغلاف الغازيّ المحيط بالأرض"},{"id":"b","text":"الطّبقة السّطحيّة من الأرض الحاملة للغطاء النّباتيّ"},{"id":"c","text":"طبقة صخريّة عميقة تحت سطح الأرض"},{"id":"d","text":"مسطّح مائيّ كبير تحت الأرض"}]'::jsonb, 'b', 'التّربة هي الطّبقة السّطحيّة من سطح الأرض التي تحمل الغطاء النّباتيّ، وهي مزيج من موادّ معدنيّة وعضويّة وهواء وماء وكائنات حيّة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d0b9810e-c5a6-5684-bbd7-fe3b8102ef02', '88be354f-3405-5e62-95e5-322f21f3543c', 'أيّ مكوّن معدنيّ في التّربة يتميّز بحبيبات دقيقة جدًّا تصبح لزجة عند بلّها بالماء؟', '[{"id":"a","text":"الحصى"},{"id":"b","text":"الرّمل"},{"id":"c","text":"الدّبال (الموادّ العضويّة)"},{"id":"d","text":"الطّين"}]'::jsonb, 'd', 'الطّين حبيباته دقيقة جدًّا، تتماسك وتصبح لزجة عند بلّها بالماء، بخلاف الرّمل الأكثر خشونة والحصى الأكبر حجمًا. الدّبال ليس مكوّنًا معدنيًّا بل عضويًّا.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d36e2fcb-ef6b-5007-9aa8-0a3a5b332eef', '88be354f-3405-5e62-95e5-322f21f3543c', 'ما دور الكائنات المجهريّة الموجودة داخل التّربة؟', '[{"id":"a","text":"تُحلّل الموادّ العضويّة المتحلّلة تدريجيًّا إلى موادّ بسيطة يستفيد منها النّبات"},{"id":"b","text":"تُصلّب حبيبات التّربة المعدنيّة"},{"id":"c","text":"تمنع الماء من التّسرّب داخل التّربة"},{"id":"d","text":"تُحوّل الرّمل إلى طين"}]'::jsonb, 'a', 'الكائنات المجهريّة كالبكتيريا والفطريات تُحلّل بقايا النّباتات والحيوانات المتحلّلة تدريجيًّا إلى موادّ بسيطة يستفيد منها النّبات في تغذيته.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e1504b14-6644-5931-808b-97ea5d9bf4dd', '88be354f-3405-5e62-95e5-322f21f3543c', 'أيّ تربة تتميّز بنفاذيّة عالية جدًّا واحتفاظ ضعيف بالماء؟', '[{"id":"a","text":"التّربة الطّينيّة"},{"id":"b","text":"التّربة الدّباليّة"},{"id":"c","text":"التّربة الرّمليّة"},{"id":"d","text":"لا فرق بين أنواع التّربة"}]'::jsonb, 'c', 'التّربة الرّمليّة حبيباتها كبيرة نسبيًّا فتتخلّلها فراغات واسعة، فنفاذيّتها عالية جدًّا ويتسرّب الماء عبرها بسرعة دون أن تحتفظ به.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('65356c97-96d9-5bdc-9cf0-2e188f15204d', '88be354f-3405-5e62-95e5-322f21f3543c', 'لماذا تُثبّت جذور النّباتات التّربة وتحميها من التّعرية؟', '[{"id":"a","text":"لأنّها تنغرس داخل التّربة وتتشابك مع حبيباتها فتمنع تفتّتها وانجرافها"},{"id":"b","text":"لأنّها تمتصّ كلّ الماء الموجود في التّربة فتُجفّفها"},{"id":"c","text":"لأنّها تحوّل التّربة الرّمليّة إلى تربة طينيّة"},{"id":"d","text":"لأنّها تطرد الكائنات المجهريّة من التّربة"}]'::jsonb, 'a', 'تنغرس جذور النّبات داخل التّربة وتتشابك مع حبيباتها، فتربط أجزاءها وتمنع تفتّتها وانجرافها بفعل الرّياح والأمطار، خاصّة على السّفوح المُنحدرة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1298ff44-f09c-5682-a9de-18e9f125e9b5', '35d2091c-3f14-51af-a0d7-25db354cc4f2', 'sciences-vie-terre-7eme', '⭐ تمرين: التّربة وعلاقتها بالكائنات الحيّة', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('77cedae4-c5f0-5068-857d-8fd96f6bd3a0', '1298ff44-f09c-5682-a9de-18e9f125e9b5', 'تتراكم في بستان زيتون بالسّاحل التّونسيّ أوراق ساقطة وجذور ميتة تتحلّل تدريجيًّا فوق سطح التّربة. إلى أيّ مكوّن من مكوّنات التّربة تنتمي هذه البقايا؟', '[{"id":"a","text":"مكوّن معدنيّ كالرّمل"},{"id":"b","text":"مكوّن معدنيّ كالحصى"},{"id":"c","text":"مكوّن عضويّ"},{"id":"d","text":"هواء محبوس بين الحبيبات"}]'::jsonb, 'c', 'الأوراق السّاقطة والجذور الميتة المتحلّلة هي بقايا نباتات وحيوانات، أي موادّ عضويّة، لا موادّ معدنيّة كالرّمل أو الحصى.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2e264f50-ff08-5855-b9cf-55dda660e9db', '1298ff44-f09c-5682-a9de-18e9f125e9b5', 'لوحظ في تربة سفوح الجبال بعين دراهم وجود حبيبات كبيرة نسبيًّا مقارنة ببقيّة حبيبات التّربة. ما اسم هذا المكوّن المعدنيّ؟', '[{"id":"a","text":"الحصى"},{"id":"b","text":"الطّين"},{"id":"c","text":"الدّبال (الموادّ العضويّة)"},{"id":"d","text":"الهواء"}]'::jsonb, 'a', 'الحصى هو المكوّن المعدنيّ ذو الحبيبات الكبيرة نسبيًّا، بخلاف الرّمل والطّين اللذين تكون حبيباتهما أدقّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ddfce6cd-24e1-5ff5-8465-de9fa5bf6106', '1298ff44-f09c-5682-a9de-18e9f125e9b5', 'لماذا يُعتبر وجود الهواء داخل التّربة ضروريًّا لجذور النّباتات وللكائنات الحيّة الّتي تعيش فيها؟', '[{"id":"a","text":"لأنّه يُصلّب حبيبات التّربة"},{"id":"b","text":"لأنّه ضروريّ لتنفّس الجذور والكائنات الحيّة داخل التّربة"},{"id":"c","text":"لأنّه يمنع تسرّب الماء"},{"id":"d","text":"لأنّه يُحلّل الموادّ العضويّة"}]'::jsonb, 'b', 'يملأ الهواء الفراغات الصّغيرة بين حبيبات التّربة، وهو ضروريّ لتنفّس جذور النّباتات والكائنات الحيّة الموجودة داخل التّربة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('31136d20-537c-578b-84ae-fa9600458e75', '1298ff44-f09c-5682-a9de-18e9f125e9b5', 'في حقل قمح بولاية باجة، تعيش ديدان وبكتيريا داخل التّربة وتُحوّل بقايا النّباتات المتحلّلة تدريجيًّا. ماذا تُنجز هذه الكائنات؟', '[{"id":"a","text":"تُصلّب حبيبات الرّمل"},{"id":"b","text":"تمنع نموّ جذور القمح"},{"id":"c","text":"تُحوّل الحصى إلى طين"},{"id":"d","text":"تُحلّل الموادّ العضويّة إلى موادّ بسيطة يستفيد منها النّبات"}]'::jsonb, 'd', 'الكائنات المجهريّة كالدّيدان والبكتيريا تُحلّل الموادّ العضويّة المتحلّلة تدريجيًّا إلى موادّ بسيطة يستفيد منها النّبات في تغذيته.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6022c05a-d7b8-598a-a8f2-b190a17ad989', '1298ff44-f09c-5682-a9de-18e9f125e9b5', 'تربة الجنوب التّونسيّ غالبًا رمليّة، بحبيبات كبيرة نسبيًّا تترك فراغات واسعة بينها. ماذا نتوقّع بخصوص احتفاظها بالماء بعد سقوط المطر؟', '[{"id":"a","text":"تحتفظ بالماء بقوّة ولفترة طويلة"},{"id":"b","text":"احتفاظ ضعيف؛ يتسرّب الماء بسرعة عبرها"},{"id":"c","text":"لا يتسرّب الماء فيها إطلاقًا"},{"id":"d","text":"تتحوّل تلقائيًّا إلى تربة طينيّة"}]'::jsonb, 'b', 'التّربة الرّمليّة حبيباتها كبيرة نسبيًّا، فنفاذيّتها عالية جدًّا، ويتسرّب الماء عبرها بسرعة دون أن تحتفظ به لفترة طويلة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('378c85be-48e1-55db-b21d-e44a92ba4547', '1298ff44-f09c-5682-a9de-18e9f125e9b5', 'جذور شجرة زيتون تنغرس عميقًا في التّربة وتتشابك مع حبيباتها. ما الأثر المباشر لهذا التّشابك على التّربة؟', '[{"id":"a","text":"يُضعف تماسك التّربة"},{"id":"b","text":"يُحوّل التّربة إلى تربة رمليّة"},{"id":"c","text":"يُثبّت التّربة ويمنع تفتّتها وانجرافها"},{"id":"d","text":"يمنع الهواء من الوصول إلى التّربة"}]'::jsonb, 'c', 'تشابك جذور شجرة الزّيتون مع حبيبات التّربة يُثبّتها ويمنع تفتّتها وانجرافها، خاصّة أمام الرّياح والأمطار.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b3eb9062-32b6-527e-9af9-c38d0fcb214a', '35d2091c-3f14-51af-a0d7-25db354cc4f2', 'sciences-vie-terre-7eme', '⚔️ زعيم الفصل ⭐⭐⭐: التّربة وعلاقتها بالكائنات الحيّة', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('49b663e7-1e6b-58aa-ae17-531e1ce44e8a', 'b3eb9062-32b6-527e-9af9-c38d0fcb214a', 'لاحظ فلاّح قرب سبخة بصفاقس أنّ حبيبات جزء من تربته دقيقة جدًّا، وتتماسك وتتحوّل إلى مادّة لزجة عند سقوط المطر عليها. أيّ مكوّن معدنيّ يغلب على هذا الجزء من التّربة؟', '[{"id":"a","text":"الحصى"},{"id":"b","text":"الطّين"},{"id":"c","text":"الهواء"},{"id":"d","text":"الدّبال (الموادّ العضويّة)"}]'::jsonb, 'b', 'تماسك الحبيبات الدّقيقة جدًّا وتحوّلها إلى مادّة لزجة عند البلّ بالماء هو الوصف الدّقيق للطّين، بخلاف الحصى ذي الحبيبات الكبيرة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d3f2f9fc-4652-520e-bc3d-b0a1956dfd34', 'b3eb9062-32b6-527e-9af9-c38d0fcb214a', 'تربة إحدى السّهول التّونسيّة طينيّة غالبًا. بعد سقوط أمطار غزيرة، يتجمّع الماء فوق سطحها لساعات طويلة دون أن يتسرّب. ما تفسير ذلك؟', '[{"id":"a","text":"لأنّ التّربة الطّينيّة لا تحتوي على أيّ فراغات بين حبيباتها"},{"id":"b","text":"لأنّ التّربة الطّينيّة رمليّة في الحقيقة"},{"id":"c","text":"لأنّ التّربة الطّينيّة نفاذيّتها ضعيفة جدًّا فيصعب على الماء التّسرّب عبر حبيباتها الدّقيقة"},{"id":"d","text":"لأنّ الأمطار الغزيرة تمنع أيّ نفاذيّة في كلّ أنواع التّربة"}]'::jsonb, 'c', 'التّربة الطّينيّة حبيباتها دقيقة جدًّا ومتماسكة، فنفاذيّتها ضعيفة جدًّا، ويصعب على الماء التّسرّب عبرها بسرعة فيتجمّع فوق السّطح.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4baab743-c1b1-59fa-8beb-a02bca286ce0', 'b3eb9062-32b6-527e-9af9-c38d0fcb214a', 'لماذا نقول إنّ العلاقة بين التّربة والكائنات الحيّة علاقة متبادلة لا في اتّجاه واحد؟', '[{"id":"a","text":"لأنّ الكائنات الحيّة تصنع التّربة من العدم"},{"id":"b","text":"لأنّ التّربة لا تحتاج إلى أيّ كائن حيّ لتبقى ثابتة"},{"id":"c","text":"لأنّ الكائنات الحيّة تعيش بمعزل تامّ عن التّربة"},{"id":"d","text":"لأنّ التّربة تُغذّي وتُؤوي الكائنات الحيّة، وهذه الكائنات (كالجذور) تُثبّت التّربة بدورها"}]'::jsonb, 'd', 'التّربة تُغذّي النّبات وتُؤوي الكائنات الحيّة، وفي المقابل تُثبّت جذور النّباتات التّربة وتحميها؛ فكلّ طرف يُفيد الآخر، وهذا معنى العلاقة المتبادلة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f646ceb2-51d5-567b-9f19-abe386ec1fa3', 'b3eb9062-32b6-527e-9af9-c38d0fcb214a', 'على سفح جبل خالٍ من الأشجار قرب الكاف، سقطت أمطار غزيرة فجرفت جزءًا كبيرًا من التّربة السّطحيّة. ما السّبب الرّئيسيّ لهذا الانجراف؟', '[{"id":"a","text":"غياب الغطاء النّباتيّ الّذي كان سيُثبّت التّربة بجذوره أمام قوّة الأمطار على السّفح المُنحدر"},{"id":"b","text":"وجود كمّية كبيرة من الحصى في التّربة"},{"id":"c","text":"ارتفاع نسبة الهواء داخل التّربة"},{"id":"d","text":"نشاط الكائنات المجهريّة داخل التّربة"}]'::jsonb, 'a', 'على السّفوح المُنحدرة، غياب الغطاء النّباتيّ يترك التّربة بلا جذور تُثبّتها، فتجرفها الأمطار الغزيرة بسهولة أكبر.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ee8d75c4-8d0b-507e-9415-4d19d71728d1', 'b3eb9062-32b6-527e-9af9-c38d0fcb214a', 'كتب تلميذ في تقريره: «تتكوّن التّربة من موادّ معدنيّة فقط، وهي الرّمل والطّين والحصى والدّبال (الموادّ العضويّة).» أين الخطأ في هذا التّصنيف؟', '[{"id":"a","text":"لا خطأ، فالتّصنيف دقيق تمامًا"},{"id":"b","text":"الخطأ أنّ الرّمل ليس مكوّنًا معدنيًّا"},{"id":"c","text":"الخطأ أنّ الدّبال وُضع خطأً ضمن الموادّ المعدنيّة، فهو بقايا متحلّلة من نباتات وحيوانات لا موادّ معدنيّة"},{"id":"d","text":"الخطأ أنّ الحصى ليس موجودًا في التّربة إطلاقًا"}]'::jsonb, 'c', 'الرّمل والطّين والحصى موادّ معدنيّة فعلًا، لكنّ الدّبال (الموادّ العضويّة) بقايا متحلّلة من نباتات وحيوانات، فهو مكوّن عضويّ لا معدنيّ، فوضعه ضمن المعدنيّ خطأ.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a73b00a5-82d3-59fb-8309-c95df4ee5f93', 'b3eb9062-32b6-527e-9af9-c38d0fcb214a', 'لماذا تُفضَّل التّربة الدّباليّة المتوازنة على التّربة الرّمليّة الخالصة وعلى التّربة الطّينيّة الخالصة لزراعة أشجار الزّيتون؟', '[{"id":"a","text":"لأنّها الوحيدة الّتي تحتوي على هواء بين حبيباتها"},{"id":"b","text":"لأنّها تجمع بين نفاذيّة متوسّطة واحتفاظ جيّد بالماء، فلا تُهدره كالرّمليّة ولا تُغرق الجذور كالطّينيّة"},{"id":"c","text":"لأنّها الوحيدة الخالية من الكائنات المجهريّة الضّارّة"},{"id":"d","text":"لأنّها لا تحتاج إلى أيّ جذور لتثبيتها"}]'::jsonb, 'b', 'التّربة الدّباليّة المتوازنة تجمع بين نفاذيّة متوسّطة واحتفاظ جيّد بالماء، فهي لا تُهدر الماء بسرعة كالرّمليّة ولا تُغرق الجذور بالماء كالطّينيّة، ما يجعلها الأنسب للزّراعة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7721d4e1-e1c5-5bf2-b327-2f4807807845', '35d2091c-3f14-51af-a0d7-25db354cc4f2', 'sciences-vie-terre-7eme', '⭐⭐ تمرين مراجعة (نمط امتحان): التّربة وعلاقتها بالكائنات الحيّة', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0d4b06a5-af6e-5a76-9eaf-fbe38d602e31', '7721d4e1-e1c5-5bf2-b327-2f4807807845', 'لاحظ تلاميذ في حديقة مدرسة بالقيروان أنّ حبيبات جزء من التّربة دقيقة نسبيًّا، لكنّها أخشن من الطّين ولا تلتصق ببعضها عند بلّها بالماء. أيّ مكوّن معدنيّ هذا؟', '[{"id":"a","text":"الرّمل"},{"id":"b","text":"الحصى"},{"id":"c","text":"الطّين"},{"id":"d","text":"الدّبال (الموادّ العضويّة)"}]'::jsonb, 'a', 'هذا وصف الرّمل: حبيباته دقيقة نسبيًّا لكنّه أخشن من الطّين ولا يلتصق ببعضه عند بلّه بالماء، بخلاف الطّين اللزج.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('116f475b-dc7f-5c34-ba20-efdaf9f9e30d', '7721d4e1-e1c5-5bf2-b327-2f4807807845', 'ما اسم الظّاهرة الّتي تفقد فيها التّربة طبقتها السّطحيّة الخصبة بفعل الرّياح القويّة أو الأمطار الغزيرة؟', '[{"id":"a","text":"النّفاذيّة"},{"id":"b","text":"التّعرية"},{"id":"c","text":"التّحلّل"},{"id":"d","text":"التّركيب الضّوئيّ"}]'::jsonb, 'b', 'التّعرية هي فقدان التّربة لطبقتها السّطحيّة الخصبة بفعل عوامل طبيعيّة كالرّياح القويّة والأمطار الغزيرة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7c0f3750-4798-5429-96ac-60c9b018ba2a', '7721d4e1-e1c5-5bf2-b327-2f4807807845', 'في منطقة رعي مكثّف اختفى فيها الغطاء النّباتيّ تدريجيًّا بسبب الرّعي الجائر، أصبحت تربتها أكثر عرضة لأيّ ظاهرة؟', '[{"id":"a","text":"التّعرية، لغياب الجذور الّتي كانت تُثبّت التّربة"},{"id":"b","text":"النّفاذيّة العالية فقط دون أيّ أثر آخر"},{"id":"c","text":"زيادة الموادّ العضويّة فيها"},{"id":"d","text":"تحوّلها تلقائيًّا إلى تربة دباليّة"}]'::jsonb, 'a', 'اختفاء الغطاء النّباتيّ بسبب الرّعي الجائر يترك التّربة بلا جذور تُثبّتها، فتصبح أكثر عرضة للتّعرية بفعل الرّياح والأمطار.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3e29e2a8-9ed2-5683-b344-f973724369c5', '7721d4e1-e1c5-5bf2-b327-2f4807807845', 'في منطقة جبليّة قرب الكاف، يزرع الفلّاحون الأشجار على مدرّجات (مصاطب) بدل السّفح المستقيم. ما الهدف من هذا الأسلوب؟', '[{"id":"a","text":"زيادة كمّية الحصى في التّربة"},{"id":"b","text":"تحويل التّربة الطّينيّة إلى تربة رمليّة"},{"id":"c","text":"إبطاء جريان الماء على السّفح وحماية التّربة من التّعرية"},{"id":"d","text":"تقليل نشاط الكائنات المجهريّة"}]'::jsonb, 'c', 'المصاطب (المدرّجات) تُبطئ جريان الماء على السّفوح المُنحدرة، فتُقلّل قوّة جرفه للتّربة وتحميها من التّعرية.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e3c5a540-2903-57d5-a004-15e79acf40d7', '7721d4e1-e1c5-5bf2-b327-2f4807807845', 'أيّ نوع تربة يحتفظ بالماء بقوّة لدرجة قد يتجمّع فوق سطحها بعد المطر ويُهدّد بإغراق جذور النّبات؟', '[{"id":"a","text":"التّربة الرّمليّة"},{"id":"b","text":"التّربة الطّينيّة"},{"id":"c","text":"التّربة الدّباليّة"},{"id":"d","text":"كلّ أنواع التّربة بالتّساوي"}]'::jsonb, 'b', 'التّربة الطّينيّة نفاذيّتها ضعيفة جدًّا واحتفاظها بالماء قويّ، فقد يتجمّع الماء فوق سطحها بعد المطر ويُهدّد بإغراق الجذور.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b7938454-a22d-5c16-b242-430b5a1164e4', '7721d4e1-e1c5-5bf2-b327-2f4807807845', 'لو اختفى الغطاء النّباتيّ تمامًا من منطقة ما، فما الأثر المتوقّع على تربتها على المدى الطّويل؟', '[{"id":"a","text":"تصبح التّربة أكثر خصوبة تلقائيًّا"},{"id":"b","text":"لا يتغيّر شيء لأنّ الجذور لا علاقة لها بثبات التّربة"},{"id":"c","text":"تتحوّل التّربة إلى صخور صلبة"},{"id":"d","text":"تفقد التّربة ما كان يُثبّتها فتصبح أكثر عرضة للانجراف والتّعرية"}]'::jsonb, 'd', 'بدون غطاء نباتيّ، تفقد التّربة الجذور الّتي كانت تُثبّتها، فتصبح حبيباتها أكثر عرضة للانجراف بفعل الرّياح والأمطار، أي أكثر عرضة للتّعرية.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e09adc5b-1aaa-55d4-a93f-322b3a09ab6b', '35d2091c-3f14-51af-a0d7-25db354cc4f2', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: التّربة وعلاقتها بالكائنات الحيّة', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('76f05ca8-1957-59e9-a559-3c031a0401b8', 'e09adc5b-1aaa-55d4-a93f-322b3a09ab6b', 'أخذ تلميذ عيّنة تربة من بستان حمضيّات بنابل، فوجد أنّ معظم حبيباتها كبيرة نسبيًّا ومتباعدة، تترك بينها فراغات واسعة. بأيّ نفاذيّة نُرجّح أن تتميّز هذه التّربة؟', '[{"id":"a","text":"نفاذيّة ضعيفة جدًّا، لأنّ الحبيبات الكبيرة تسدّ الفراغات بينها"},{"id":"b","text":"نفاذيّة متوسّطة، لأنّها تربة دباليّة بالضّرورة"},{"id":"c","text":"نفاذيّة عالية جدًّا، لأنّ الفراغات الواسعة بين الحبيبات الكبيرة تُسهّل تسرّب الماء"},{"id":"d","text":"لا علاقة بين حجم حبيبات التّربة ونفاذيّتها"}]'::jsonb, 'c', 'الحبيبات الكبيرة المتباعدة تترك فراغات واسعة يتسرّب عبرها الماء بسهولة، فنفاذيّة هذه التّربة عالية جدًّا، تمامًا كالتّربة الرّمليّة. الخطأ الشّائع هو تصوّر أنّ الحبيبات الكبيرة تسدّ الفراغات، والعكس هو الصّحيح.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2f37ab81-ea26-5d1c-9eff-08e159ac91f1', 'e09adc5b-1aaa-55d4-a93f-322b3a09ab6b', 'كتب تلميذ في تقريره: «كلّ الكائنات المجهريّة الموجودة في التّربة ضارّة بالنّبات، لأنّها تُحلّل بقايا الأوراق والجذور الميتة.» أين الخطأ في هذا التّقرير؟', '[{"id":"a","text":"لا خطأ، فالتّقرير دقيق تمامًا"},{"id":"b","text":"الخطأ أنّ التّحليل الّذي تقوم به هذه الكائنات مفيد للنّبات لا ضارّ به، إذ يُحوّل الموادّ العضويّة إلى موادّ بسيطة يستفيد منها"},{"id":"c","text":"الخطأ أنّ الكائنات المجهريّة لا تعيش داخل التّربة إطلاقًا"},{"id":"d","text":"الخطأ أنّ الكائنات المجهريّة تُحلّل الموادّ المعدنيّة لا العضويّة"}]'::jsonb, 'b', 'الخطأ جوهريّ: تحليل الكائنات المجهريّة لبقايا النّباتات والحيوانات المتحلّلة عملية مفيدة للنّبات لا ضارّة به، لأنّها تُحوّل هذه البقايا تدريجيًّا إلى موادّ بسيطة يمتصّها النّبات ويستفيد منها في تغذيته.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c27f6db0-008e-52ab-ab4d-f853de1deac5', 'e09adc5b-1aaa-55d4-a93f-322b3a09ab6b', 'أيّ العبارات الأربع التّالية بخصوص التّربة **خاطئة**؟', '[{"id":"a","text":"تحتوي التّربة على موادّ معدنيّة وعضويّة وهواء وماء وكائنات مجهريّة معًا"},{"id":"b","text":"جذور النّباتات تُثبّت التّربة وتحميها من الانجراف"},{"id":"c","text":"الكائنات المجهريّة تُحلّل الموادّ العضويّة إلى موادّ بسيطة يستفيد منها النّبات"},{"id":"d","text":"كلّ أنواع التّربة الرّمليّة تحتفظ بالماء بقوّة ولفترة طويلة"}]'::jsonb, 'd', 'العبارة الخاطئة هي أنّ التّربة الرّمليّة تحتفظ بالماء بقوّة: العكس هو الصّحيح، فنفاذيّتها عالية جدًّا واحتفاظها بالماء ضعيف؛ العبارات الثّلاث الأخرى صحيحة تمامًا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bfa4071e-1b65-58a3-b363-75131bdd7670', 'e09adc5b-1aaa-55d4-a93f-322b3a09ab6b', 'بعد أمطار غزيرة سقطت على حقل مُنحدر خالٍ من الأشجار قرب زغوان، اختفى معظم الطّبقة السّطحيّة من تربته خلال موسم واحد فقط. أيّ تفسير يجمع العوامل الحقيقيّة لهذا الاختفاء السّريع؟', '[{"id":"a","text":"الأمطار الغزيرة وحدها كافية لتفسير الاختفاء، بصرف النّظر عن وجود الأشجار أو انحدار الأرض"},{"id":"b","text":"غياب الحصى في تربة الحقل هو السّبب الوحيد"},{"id":"c","text":"زيادة نشاط الكائنات المجهريّة هي السّبب الرّئيسيّ"},{"id":"d","text":"اجتماع انحدار الأرض وغياب جذور تُثبّت التّربة جعل الأمطار الغزيرة تجرف الطّبقة السّطحيّة بسرعة أكبر"}]'::jsonb, 'd', 'التّعرية السّريعة هنا نتيجة اجتماع عاملين معًا: انحدار الأرض الّذي يُسرّع جريان الماء، وغياب الغطاء النّباتيّ الّذي كانت جذوره ستُثبّت التّربة. الخطأ الشّائع هو الاكتفاء بذكر الأمطار وحدها، بينما هي لا تكفي وحدها لو وُجدت جذور تُثبّت التّربة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8d2dfef5-21b8-5db2-92ea-e80fa480d97e', 'e09adc5b-1aaa-55d4-a93f-322b3a09ab6b', 'تحتوي عيّنة تربة على مزيج متوازن من الرّمل والطّين وكمّية كبيرة من الموادّ العضويّة المتحلّلة. بالمقارنة مع التّربة الرّمليّة الخالصة والتّربة الطّينيّة الخالصة، أيّ استنتاج صحيح بخصوص نفاذيّتها واحتفاظها بالماء؟', '[{"id":"a","text":"نفاذيّة عالية جدًّا كالرّمليّة، واحتفاظ ضعيف كالرّمليّة أيضًا"},{"id":"b","text":"نفاذيّة ضعيفة جدًّا كالطّينيّة، واحتفاظ قويّ جدًّا كالطّينيّة أيضًا"},{"id":"c","text":"نفاذيّة متوسّطة واحتفاظ جيّد بالماء، توازن بين حالتَي التّربة الخالصتين"},{"id":"d","text":"لا نفاذيّة ولا احتفاظ بالماء إطلاقًا"}]'::jsonb, 'c', 'المزيج المتوازن بين الرّمل والطّين مع موادّ عضويّة كثيرة هو تعريف التّربة الدّباليّة، الّتي تجمع بين نفاذيّة متوسّطة واحتفاظ جيّد بالماء، فلا تُهدره كالرّمليّة الخالصة ولا تُغرق الجذور كالطّينيّة الخالصة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c48d7448-fd90-5e80-aab8-b46196ede091', 'e09adc5b-1aaa-55d4-a93f-322b3a09ab6b', 'قارِن الملاحظتين التّاليتين في منطقتَين متجاورتَين بعد نفس كمّية الأمطار: الحقل (1) محافظ على غطائه النّباتيّ وتربته السّطحيّة سليمة. الحقل (2) أُزيلت أشجاره قبل موسم الأمطار وفقد جزءًا كبيرًا من تربته السّطحيّة. أيّ استنتاج يفسّر الفرق بينهما؟', '[{"id":"a","text":"غياب جذور الأشجار في الحقل (2) بعد إزالتها ترك تربته بلا تثبيت، فتعرّضت للانجراف أمام نفس الأمطار الّتي لم تؤثّر في الحقل (1) المحميّ بجذوره"},{"id":"b","text":"الحقل (2) تعرّض لكمّية أمطار أكبر من الحقل (1)"},{"id":"c","text":"تربة الحقل (2) كانت رمليّة والحقل (1) كانت طينيّة"},{"id":"d","text":"لا فرق حقيقيّ بين الحقلين، والاختلاف عشوائيّ فقط"}]'::jsonb, 'a', 'الحقلان تعرّضا لنفس كمّية الأمطار، فالفارق الحقيقيّ هو وجود جذور الأشجار الّتي تُثبّت التّربة في الحقل (1)، وغيابها بعد إزالة الأشجار في الحقل (2)، ما جعله عرضة للانجراف أمام نفس المطر.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('61a47596-63ef-5041-a451-7cfd57c077f9', '35d2091c-3f14-51af-a0d7-25db354cc4f2', 'sciences-vie-terre-7eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): التّربة وعلاقتها بالكائنات الحيّة', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c015d7fd-4c32-5645-b724-b7d35950e14c', '61a47596-63ef-5041-a451-7cfd57c077f9', 'في غابة بجندوبة، تتراكم فوق سطح التّربة أوراق صنوبر ساقطة وأغصان صغيرة متحلّلة. إلى أيّ مكوّن من مكوّنات التّربة تنتمي هذه البقايا؟', '[{"id":"a","text":"مكوّن معدنيّ كالطّين"},{"id":"b","text":"مكوّن عضويّ"},{"id":"c","text":"هواء محبوس بين الحبيبات"},{"id":"d","text":"ماء متسرّب بين الحبيبات"}]'::jsonb, 'b', 'أوراق الصّنوبر السّاقطة والأغصان المتحلّلة بقايا نباتات، أي موادّ عضويّة، لا موادّ معدنيّة ولا هواء ولا ماء.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('91cee77e-bedc-57d4-b8b4-92603c66352e', '61a47596-63ef-5041-a451-7cfd57c077f9', 'ما المقصود بـ«قوام» التّربة؟', '[{"id":"a","text":"نسبة موادّها المعدنيّة والعضويّة الغالبة عليها"},{"id":"b","text":"لون التّربة فقط"},{"id":"c","text":"كمّية الماء الموجودة فيها في لحظة معيّنة فقط"},{"id":"d","text":"عمق التّربة تحت سطح الأرض"}]'::jsonb, 'a', 'قوام التّربة هو نسب موادّها المعدنيّة والعضويّة الغالبة عليها، وهو ما يحدّد نوعها (رمليّة، طينيّة، دباليّة) ونفاذيّتها.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5957ee3f-41fa-5e2a-9f12-bacad6c96ff3', '61a47596-63ef-5041-a451-7cfd57c077f9', 'في حديقة منزليّة بالمهديّة، وُجدت ديدان أرض وحشرات صغيرة تعيش داخل التّربة طوال السّنة. أيّ دور تُقدّمه التّربة لهذه الكائنات هنا؟', '[{"id":"a","text":"التّربة تطردها دائمًا خارجها"},{"id":"b","text":"التّربة تمنع تكاثرها"},{"id":"c","text":"الإيواء، إضافة إلى التّغذية"},{"id":"d","text":"لا علاقة بين التّربة وهذه الكائنات"}]'::jsonb, 'c', 'التّربة تُؤوي داخلها كائنات حيّة كديدان الأرض والحشرات الصّغيرة، إضافة إلى دورها في تغذية النّبات؛ فهذه علاقة تبادل بين التّربة والكائنات الحيّة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7d4f010c-41e3-551e-8270-b6a6a39280f9', '61a47596-63ef-5041-a451-7cfd57c077f9', 'لماذا تُعدّ نسبة الماء المتسرّبة بين حبيبات التّربة عنصرًا ضروريًّا لحياة النّبات، لا مجرّد وجود عابر؟', '[{"id":"a","text":"لأنّها تُصلّب حبيبات التّربة"},{"id":"b","text":"لأنّها تمنع نموّ الكائنات المجهريّة داخل التّربة"},{"id":"c","text":"لأنّ النّبات يمتصّ الماء والأملاح المعدنيّة الذّائبة فيه عبر جذوره"},{"id":"d","text":"لأنّها تُحوّل حبيبات الرّمل إلى طين"}]'::jsonb, 'c', 'الماء المتسرّب بين حبيبات التّربة يحمل الأملاح المعدنيّة الذّائبة، وهذا المزيج هو ما تمتصّه جذور النّبات لتغذيته؛ لذلك تُعدّ التّربة مصدر غذاء النّبات لا مجرّد حاضنة له.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('67973c24-51e6-5526-ae26-f5980d0284c4', '61a47596-63ef-5041-a451-7cfd57c077f9', 'في منطقة قليلة الغطاء النّباتيّ قرب قفصة، تهبّ رياح قويّة بانتظام فتكسح حبيبات التّربة الرّمليّة الجافّة وتنقلها لمسافات بعيدة. أيّ عامل تعرية يظهر في هذا الوصف بوضوح؟', '[{"id":"a","text":"الأمطار الغزيرة"},{"id":"b","text":"الرّيّ المفرط"},{"id":"c","text":"نشاط الكائنات المجهريّة"},{"id":"d","text":"الرّياح القويّة"}]'::jsonb, 'd', 'الرّياح القويّة الّتي تكسح حبيبات التّربة الرّمليّة الجافّة وتنقلها لمسافات بعيدة هي أحد عاملَي التّعرية الرّئيسيَّين، إلى جانب الأمطار الغزيرة على السّفوح المُنحدرة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2453d295-b1ec-570b-a033-bb8eb937fad0', '61a47596-63ef-5041-a451-7cfd57c077f9', 'يعتمد فلاّحو المناطق الجبليّة وسائل متعدّدة لحماية تربتهم من التّعرية معًا. أيّ مجموعة من الوسائل التّالية تُعدّ الأنسب لهذا الهدف؟', '[{"id":"a","text":"قطع الأشجار وزيادة الرّعي لتوفير مساحة أكبر للزّراعة"},{"id":"b","text":"الحفاظ على الغطاء النّباتيّ، وزراعة الأشجار على المصاطب، وتجنّب الرّعي الجائر"},{"id":"c","text":"إزالة كلّ الحصى من التّربة فقط"},{"id":"d","text":"الاكتفاء بزيادة كمّية الرّيّ الاصطناعيّ فقط"}]'::jsonb, 'b', 'حماية التّربة من التّعرية تتطلّب الجمع بين وسائل متعدّدة: الحفاظ على الغطاء النّباتيّ، زراعة الأشجار على المصاطب لإبطاء جريان الماء، وتجنّب الرّعي الجائر وقطع الأشجار العشوائيّ؛ لا وسيلة واحدة معزولة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('476a213a-a5c4-54b9-a771-2a4303671c7d', '35d2091c-3f14-51af-a0d7-25db354cc4f2', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐ (القمّة): التّربة وعلاقتها بالكائنات الحيّة', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9132585d-e74c-5649-997b-1ad17dec9d6d', '476a213a-a5c4-54b9-a771-2a4303671c7d', 'أيّ الأوصاف الأربعة التّالية للتّربة يحوي تناقضًا واضحًا بين نوع حبيباتها ونفاذيّتها؟', '[{"id":"a","text":"تربة حبيباتها دقيقة جدًّا (طينيّة)، ونفاذيّتها ضعيفة جدًّا"},{"id":"b","text":"تربة دباليّة متوازنة، نفاذيّتها متوسّطة واحتفاظها بالماء جيّد"},{"id":"c","text":"تربة طينيّة، تتجمّع المياه فوق سطحها بعد المطر"},{"id":"d","text":"تربة حبيباتها كبيرة نسبيًّا (رمليّة)، لكنّ نفاذيّتها ضعيفة جدًّا واحتفاظها بالماء قويّ جدًّا"}]'::jsonb, 'd', 'الوصف (د) متناقض: الحبيبات الكبيرة نسبيًّا (كالرّمل) تترك فراغات واسعة تجعل النّفاذيّة عالية جدًّا والاحتفاظ بالماء ضعيفًا، لا العكس؛ نفاذيّة ضعيفة واحتفاظ قويّ سمة التّربة الطّينيّة الدّقيقة الحبيبات لا الرّمليّة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1cc266b1-133e-5e13-b912-18cc07002638', '476a213a-a5c4-54b9-a771-2a4303671c7d', 'كتب تلميذ: «كلّ أنواع التّربة تحتفظ بالماء بنفس القدر، لأنّ الماء يتسرّب بالتّساوي عبر كلّ أنواع الحبيبات.» أين الخطأ في هذا الاستنتاج؟', '[{"id":"a","text":"لا خطأ، فالاستنتاج دقيق تمامًا"},{"id":"b","text":"الخطأ أنّ الماء لا يتسرّب إطلاقًا في أيّ نوع من التّربة"},{"id":"c","text":"الخطأ أنّ نفاذيّة التّربة واحتفاظها بالماء يختلفان باختلاف حجم حبيباتها: الرّمليّة نفاذيّتها عالية واحتفاظها ضعيف، والطّينيّة عكس ذلك تمامًا"},{"id":"d","text":"الخطأ أنّ التّربة لا تحتوي على ماء إطلاقًا"}]'::jsonb, 'c', 'الخطأ الشّائع هو تصوّر أنّ كلّ أنواع التّربة تتصرّف بنفس الطّريقة أمام الماء؛ في الحقيقة تختلف نفاذيّة التّربة واحتفاظها بالماء اختلافًا كبيرًا حسب حجم حبيباتها وقوامها.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('676ddf59-8b5a-5069-bd95-41e01a71d841', '476a213a-a5c4-54b9-a771-2a4303671c7d', 'لوحظ في الحقل (1) أنّ الماء يختفي بسرعة بعد المطر وتظهر على النّباتات علامات عطش. ولوحظ في الحقل (2) أنّ الماء يتجمّع فوق السّطح أيّامًا، وبدأت جذور بعض النّباتات تتعفّن. أيّ تصنيف صحيح لتربة الحقلين؟', '[{"id":"a","text":"الحقل (1) رمليّة والحقل (2) طينيّة"},{"id":"b","text":"الحقل (1) طينيّة والحقل (2) رمليّة"},{"id":"c","text":"كلا الحقلين دباليّان"},{"id":"d","text":"لا يمكن تصنيف نوع التّربة من هذه الملاحظات"}]'::jsonb, 'a', 'اختفاء الماء السّريع مع ظهور علامات العطش سمة نفاذيّة عالية جدًّا واحتفاظ ضعيف، أي تربة رمليّة (الحقل 1)؛ وتجمّع الماء أيّامًا مع خطر تعفّن الجذور سمة نفاذيّة ضعيفة جدًّا واحتفاظ قويّ، أي تربة طينيّة (الحقل 2).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('924f8d6e-54a3-5e11-897c-df269e1fbd32', '476a213a-a5c4-54b9-a771-2a4303671c7d', 'قرأ تلميذ في مجلّة مدرسيّة أربع عبارات حول التّربة، إحداها **خاطئة**. أيّ عبارة من الأربع خاطئة؟', '[{"id":"a","text":"الحصى مكوّن معدنيّ حبيباته كبيرة نسبيًّا"},{"id":"b","text":"الهواء بين حبيبات التّربة ضروريّ لتنفّس الجذور والكائنات الحيّة"},{"id":"c","text":"التّعرية تزيد خصوبة التّربة وتُحسّن قدرتها على حمل النّباتات"},{"id":"d","text":"جذور النّباتات تُثبّت التّربة وتحميها من الانجراف"}]'::jsonb, 'c', 'العبارة الخاطئة هي أنّ التّعرية تزيد خصوبة التّربة: العكس هو الصّحيح، فالتّعرية فقدان للطّبقة السّطحيّة الخصبة من التّربة، ما يُضعف قدرتها على حمل الغطاء النّباتيّ لا يُحسّنها.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('318b656e-bf40-5469-a98b-00a6f13c11eb', '476a213a-a5c4-54b9-a771-2a4303671c7d', 'رُصدت أربع عيّنات تربة: (A) حبيباتها كبيرة نسبيًّا وتُصرّف الماء بسرعة كبيرة جدًّا. (B) حبيباتها دقيقة جدًّا وتحتفظ بالماء لفترة طويلة فوق السّطح. (C) مزيج متوازن مع موادّ عضويّة كثيرة ونفاذيّة متوسّطة. (D) حبيباتها كبيرة جدًّا وواضحة بالعين المجرّدة، أكبر من بقيّة العيّنات. أيّ تصنيف صحيح؟', '[{"id":"a","text":"A رمليّة، B طينيّة، C دباليّة، D فيها نسبة عالية من الحصى"},{"id":"b","text":"A طينيّة، B رمليّة، C دباليّة، D فيها نسبة عالية من الحصى"},{"id":"c","text":"A رمليّة، B رمليّة، C طينيّة، D دباليّة"},{"id":"d","text":"لا يمكن تصنيف أيّ عيّنة من هذه الأوصاف"}]'::jsonb, 'a', 'كلّ وصف يطابق مكوّنًا محدّدًا: A (حبيبات كبيرة، تصريف سريع جدًّا) سمة الرّمل، B (حبيبات دقيقة جدًّا، احتفاظ طويل) سمة الطّين، C (مزيج متوازن، نفاذيّة متوسّطة) سمة التّربة الدّباليّة، وD (حبيبات كبيرة جدًّا واضحة بالعين المجرّدة) سمة الحصى.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a8805b91-069c-585e-8a81-4d8f6a700956', '476a213a-a5c4-54b9-a771-2a4303671c7d', 'أزال فلاّح (1) أشجار قطعة أرضه مؤقّتًا لأشغال بناء، لكنّه أعاد غرسها فورًا بعد أسبوعين قبل موسم الأمطار. أمّا فلاّح (2) فأزال أشجار قطعة أرضه نهائيًّا لتوسيع الرّعي دون أن يُعيد الغرس. أيّ الحقلين أكثر عرضة للتّعرية على المدى الطّويل، ولماذا؟', '[{"id":"a","text":"حقل الفلاّح (1)، لأنّ أيّ إزالة مؤقّتة للأشجار خطر دائم لا يُصلحه إعادة الغرس"},{"id":"b","text":"حقل الفلاّح (2)، لأنّ غياب الجذور المُثبّتة يستمرّ طويلًا دون غطاء نباتيّ يحميه من الرّياح والأمطار"},{"id":"c","text":"كلا الحقلين بنفس درجة الخطر تمامًا"},{"id":"d","text":"لا فرق بينهما لأنّ التّعرية لا علاقة لها بمدّة غياب الأشجار"}]'::jsonb, 'b', 'حقل الفلاّح (1) استعاد جذورًا مُثبّتة بسرعة قبل موسم الأمطار، بينما حقل الفلاّح (2) يبقى بلا غطاء نباتيّ نهائيًّا، فتستمرّ تربته مكشوفة أمام الرّياح والأمطار مدّة أطول بكثير، ما يجعله أكثر عرضة للتّعرية على المدى الطّويل.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('316f482a-cd80-52fa-86b1-6c4e0cb1ffad', 'c3418051-d92b-590b-8e89-ae540df41bcc', 'sciences-vie-terre-7eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('964151d5-2cbf-5738-99a2-fcb839e844bd', '316f482a-cd80-52fa-86b1-6c4e0cb1ffad', 'لماذا يُعدّ الماء ضروريًّا لكلّ الكائنات الحيّة دون استثناء؟', '[{"id":"a","text":"لأنّه يدخل في تركيب جسمها ويتدخّل في كلّ وظائفها الحيوية (تغذية، تنفّس، نموّ)"},{"id":"b","text":"لأنّه الغذاء الوحيد الّذي تحتاجه أيّ كائنات حيّة"},{"id":"c","text":"لأنّ كلّ الكائنات الحيّة تعيش داخل الماء دائمًا"},{"id":"d","text":"لأنّه العنصر الوحيد غير الحيّ في الوسط البيئي"}]'::jsonb, 'a', 'الماء يدخل في تركيب جسم كلّ كائن حيّ ويتدخّل في جميع وظائفه الحيوية، ولهذا لا يستطيع أيّ كائن حيّ الاستغناء عنه، ولو ليوم واحد.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4082448d-d9d6-5652-9941-807f5a84fcc4', '316f482a-cd80-52fa-86b1-6c4e0cb1ffad', 'ما دور الماء عند الإنسان؟', '[{"id":"a","text":"يُستعمل فقط للشّرب دون أيّ دور آخر"},{"id":"b","text":"يصنع به الجسم غذاءه بنفسه كالنّبات الأخضر"},{"id":"c","text":"ينقل المواد الغذائية عبر الدّم وينظّم حرارة الجسم عبر التّعرّق"},{"id":"d","text":"لا علاقة له بحرارة الجسم إطلاقًا"}]'::jsonb, 'c', 'الماء عند الإنسان ينقل المواد الغذائية عبر الدّم إلى مختلف أعضاء الجسم، ويساعد على الهضم، وينظّم حرارة الجسم عبر التّعرّق.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d8f17327-cbda-585b-920b-ab22fb84538d', '316f482a-cd80-52fa-86b1-6c4e0cb1ffad', 'كيف يمتصّ النّبات الأخضر الماء الّذي يحتاجه؟', '[{"id":"a","text":"بأوراقه من الهواء مباشرة"},{"id":"b","text":"بجذوره من التّربة، وهو ضروريّ أيضًا للتّركيب الضّوئيّ"},{"id":"c","text":"لا يحتاج النّبات الأخضر إلى الماء لأنّه يصنع غذاءه من الضّوء فقط"},{"id":"d","text":"يمتصّه من الهواء ثمّ يخزّنه في أزهاره فقط"}]'::jsonb, 'b', 'يمتصّ النّبات الأخضر الماء بجذوره من التّربة (الامتصاص الجذريّ)، والماء ضروريّ أيضًا كمادّة أوّلية للتّركيب الضّوئيّ.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('95705cc2-7072-5396-87a5-2eaff4b5e63e', '316f482a-cd80-52fa-86b1-6c4e0cb1ffad', 'أين يوجد الماء الّذي تمتصّه جذور النّباتات؟', '[{"id":"a","text":"لا وجود لماء في التّربة إطلاقًا، فهو موجود في الهواء فقط"},{"id":"b","text":"يوجد في التّربة لكن لا تستطيع جذور النّباتات امتصاصه"},{"id":"c","text":"توجد الكمّية نفسها من الماء في كلّ أنواع التّرب دون أيّ فرق"},{"id":"d","text":"تحتفظ به التّربة بين حبيباتها، فتمتصّه جذور النّباتات"}]'::jsonb, 'd', 'تحتفظ التّربة بالماء بين حبيباتها، وهذا الماء هو الّذي تمتصّه جذور النّباتات؛ وتحتفظ التّربة الطّينية بالماء أطول من التّربة الرّملية.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bffc97ac-160e-5635-af6c-a9420bf3803a', '316f482a-cd80-52fa-86b1-6c4e0cb1ffad', 'ما أحد الأسباب الرّئيسية لتلوّث الماء في الوسط البيئي؟', '[{"id":"a","text":"إلقاء النّفايات المنزلية والموادّ الكيميائية الزراعية في الأودية والبحيرات دون معالجة"},{"id":"b","text":"شرب الحيوانات للماء بانتظام"},{"id":"c","text":"امتصاص جذور النّباتات للماء من التّربة"},{"id":"d","text":"تنفّس الأسماك داخل الماء بواسطة خياشيمها"}]'::jsonb, 'a', 'من أهمّ أسباب تلوّث الماء إلقاء النّفايات المنزلية وتسرّب الموادّ الكيميائية الزراعية والنّفايات المعملية في الأودية والبحيرات دون معالجة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ec86af8f-217e-58e8-81bb-ed9913b10de7', 'c3418051-d92b-590b-8e89-ae540df41bcc', 'sciences-vie-terre-7eme', '⭐ تمرين: الماء ودوره في حياة الكائنات الحيّة', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('11a5b779-872f-5ca7-81d5-9d0c22034c19', 'ec86af8f-217e-58e8-81bb-ed9913b10de7', 'ماذا يحدث لجسم الإنسان إذا لم يشرب كمّية كافية من الماء لمدّة طويلة؟', '[{"id":"a","text":"يشعر بالعطش والتّعب ويختلّ توازنه المائي"},{"id":"b","text":"لا يتأثّر إطلاقًا لأنّ جسمه يخزّن ماءً كافيًا إلى الأبد"},{"id":"c","text":"يزداد نشاطه ويشعر بمزيد من الحيوية"},{"id":"d","text":"يفرز مزيدًا من العرق دون أن يشعر بأيّ تعب"}]'::jsonb, 'a', 'إذا لم يشرب الإنسان كمّية كافية من الماء لمدّة طويلة، يشعر بالعطش والتّعب ويختلّ توازنه المائي، لأنّ جسمه يفقد الماء باستمرار ويحتاج إلى تعويضه.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2dd1e87f-f351-5559-a771-f79a4313ec99', 'ec86af8f-217e-58e8-81bb-ed9913b10de7', 'لماذا تذبل أوراق نبتة إذا انقطع سقيها لعدّة أيّام رغم بقائها في الضّوء وفي تربة غنيّة بالأملاح المعدنية؟', '[{"id":"a","text":"لأنّ الضّوء وحده لا يكفي أبدًا لأيّ نبتة"},{"id":"b","text":"لأنّ الماء ضروريّ لحياة النّبات ونقص توفّره يعطّل وظائفه الحيوية"},{"id":"c","text":"لأنّ الأملاح المعدنية تصبح سامّة بدون ماء"},{"id":"d","text":"لأنّ النّبتة تتحوّل إلى كائن مستهلك بسبب نقص الماء"}]'::jsonb, 'b', 'الماء ضروريّ لحياة النّبات الأخضر ولنقل الأملاح المعدنية داخله وللتّركيب الضّوئيّ؛ نقصه وحده يعطّل وظائفه الحيوية ويُذبل أوراقه، حتّى مع توفّر الضّوء والأملاح المعدنية.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('564e2b40-88bd-5442-8480-c444da4a7c4f', 'ec86af8f-217e-58e8-81bb-ed9913b10de7', 'ما الجزء الّذي يخزّن فيه جسم الجمل الدّهن الّذي يمنحه طاقة تساعده على تحمّل أيّام طويلة دون شرب مباشر؟', '[{"id":"a","text":"أذناه"},{"id":"b","text":"أرجله"},{"id":"c","text":"سنامه"},{"id":"d","text":"رئتاه"}]'::jsonb, 'c', 'يخزّن سنام الجمل دهنًا لا ماءً، وهذا الدّهن يمنحه مخزون طاقة يساعده على تحمّل أيّام طويلة دون شرب مباشر.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8c3b817d-d00a-5929-ad46-03614d61a82a', 'ec86af8f-217e-58e8-81bb-ed9913b10de7', 'أيّ نوع من التّربة يحتفظ بالماء مدّة أطول بين حبيباته؟', '[{"id":"a","text":"التّربة الرّملية"},{"id":"b","text":"الصّخور المفتّتة فقط"},{"id":"c","text":"لا فرق بين أنواع التّرب"},{"id":"d","text":"التّربة الطّينية"}]'::jsonb, 'd', 'تحتفظ التّربة الطّينية بالماء مدّة طويلة بين حبيباتها الدّقيقة، بخلاف التّربة الرّملية الّتي يتسرّب منها الماء بسرعة بين حبيباتها الكبيرة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9d03fac9-faa4-53ed-8711-bb89c03313cd', 'ec86af8f-217e-58e8-81bb-ed9913b10de7', 'أيّ ممّا يلي يُعدّ مصدرًا لتلوّث الماء في الوسط البيئي؟', '[{"id":"a","text":"إلقاء نفايات منزلية في واد أو بحيرة"},{"id":"b","text":"امتصاص جذور الأشجار للماء من التّربة"},{"id":"c","text":"تساقط الأمطار على الغابة"},{"id":"d","text":"شرب الحيوانات العاشبة للماء بانتظام"}]'::jsonb, 'a', 'إلقاء النّفايات المنزلية مباشرة في واد أو بحيرة من أهمّ أسباب تلوّث الماء وإضراره بالكائنات الحيّة الّتي تعتمد عليه.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('423f097a-4a17-590c-80f1-f1c838922488', 'ec86af8f-217e-58e8-81bb-ed9913b10de7', 'أيّ ممّا يلي مثال على وجود الماء في الوسط البيئي بعيدًا عن التّربة؟', '[{"id":"a","text":"رمال الواحة الجافّة"},{"id":"b","text":"صخرة جافّة في الصّحراء"},{"id":"c","text":"بحيرة إشكل بجهة بنزرت"},{"id":"d","text":"ورقة شجرة يابسة سقطت"}]'::jsonb, 'c', 'بحيرة إشكل بجهة بنزرت مثال حقيقيّ على وجود الماء في الوسط البيئي بعيدًا عن التّربة، إلى جانب الأودية والمياه الجوفية والبحر.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6a307483-1a11-5d1c-8a2f-f3139e499b91', 'c3418051-d92b-590b-8e89-ae540df41bcc', 'sciences-vie-terre-7eme', '⚔️ زعيم الفصل ⭐⭐⭐: الماء ودوره في حياة الكائنات الحيّة', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('845ca028-247c-5006-b278-c6d5666db089', '6a307483-1a11-5d1c-8a2f-f3139e499b91', 'لماذا يحتاج الإنسان إلى شرب الماء بانتظام كلّ يوم، حتّى في الأيّام الّتي لا يبذل فيها مجهودًا كبيرًا؟', '[{"id":"a","text":"لأنّ جسمه يفقد الماء باستمرار عبر التّعرّق والتّنفّس والتّبوّل"},{"id":"b","text":"لأنّ الجسم لا يفقد أيّ ماء إلّا أثناء المجهود البدنيّ فقط"},{"id":"c","text":"لأنّ الماء يتحوّل داخل الجسم إلى غذاء جاهز"},{"id":"d","text":"لأنّ شرب الماء يمنع الجسم من التّنفّس بشكل طبيعيّ"}]'::jsonb, 'a', 'يفقد جسم الإنسان الماء باستمرار عبر التّعرّق والتّنفّس والتّبوّل، حتّى دون مجهود بدنيّ كبير، ولهذا يحتاج إلى تعويضه بانتظام كلّ يوم.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0dcd134b-5565-59cc-871e-58a9d9bc87d1', '6a307483-1a11-5d1c-8a2f-f3139e499b91', 'نسي أحدهم سقي نبتة الرّيحان الموضوعة في شرفته لمدّة أسبوع، رغم بقائها معرّضة للضّوء وتربتها تحتوي على أملاح معدنية كافية. ماذا نتوقّع أن يحدث لهذه النّبتة؟', '[{"id":"a","text":"تبقى سليمة تمامًا لأنّ الضّوء والأملاح المعدنية كافيان وحدهما"},{"id":"b","text":"تذبل تدريجيًّا لأنّ الماء ضروريّ لحياتها ولا يعوّضه الضّوء أو الأملاح المعدنية"},{"id":"c","text":"تتوقّف عن امتصاص الأملاح المعدنية فقط دون أن تتأثّر بصفة عامّة"},{"id":"d","text":"تنمو بشكل أسرع من المعتاد بفضل الجفاف"}]'::jsonb, 'b', 'الماء ضروريّ لحياة النّبات ولا يعوّضه توفّر الضّوء أو الأملاح المعدنية وحدهما؛ فبدون سقي منتظم، تذبل أوراق نبتة الرّيحان تدريجيًّا وتفقد نضارتها.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2f62da3d-6a2b-5c07-b7ef-2914b7be1753', '6a307483-1a11-5d1c-8a2f-f3139e499b91', 'لماذا يلهث الكلب مخرجًا لسانه في الأيّام الحارّة؟', '[{"id":"a","text":"لأنّه يشعر بالجوع الشّديد"},{"id":"b","text":"لأنّه يريد استنشاق الهواء بدل شرب الماء"},{"id":"c","text":"لأنّه يفقد الأملاح المعدنية فقط دون أيّ ماء"},{"id":"d","text":"لتبريد جسمه عبر تبخّر الماء من لسانه وفمه"}]'::jsonb, 'd', 'يلهث الكلب مخرجًا لسانه في الجوّ الحارّ لتبريد جسمه عبر تبخّر الماء من لسانه وفمه، بدل التّعرّق الّذي يعتمده الإنسان.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('eefbe079-463b-5e32-b707-4c1a4e5abce6', '6a307483-1a11-5d1c-8a2f-f3139e499b91', 'لماذا يفضّل الفلّاحون في المناطق ذات التّربة الرّملية سقي نباتاتهم بكمّيات أصغر وبتكرار أكبر، بدل كمّية كبيرة دفعة واحدة؟', '[{"id":"a","text":"لأنّ التّربة الرّملية تحتفظ بالماء أكثر من اللّازم"},{"id":"b","text":"لأنّ كمّية الماء اللّازمة لا علاقة لها بنوع التّربة"},{"id":"c","text":"لأنّ التّربة الرّملية لا تحتفظ بالماء طويلًا، فيتسرّب بسرعة إذا سُقيت دفعة واحدة"},{"id":"d","text":"لأنّ النّباتات في هذه المناطق لا تحتاج ماءً إطلاقًا"}]'::jsonb, 'c', 'تحتفظ التّربة الرّملية بالماء مدّة قصيرة فقط بين حبيباتها الكبيرة، فيتسرّب الماء بسرعة إذا سُقيت دفعة واحدة؛ لذلك يُفضَّل سقيها بكمّيات أصغر وبتكرار أكبر.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('14adeb4f-5449-5275-9535-8c69e778926e', '6a307483-1a11-5d1c-8a2f-f3139e499b91', 'يُلقي فلّاح بقايا مبيدات كيميائية زراعية بانتظام في واد قريب من حقله. بعد مدّة، بدأت أعداد الأسماك في الوادي تتناقص بشكل واضح. ما التّفسير الأقرب لهذه الملاحظة؟', '[{"id":"a","text":"هاجرت الأسماك بسبب البرودة فقط دون أيّ سبب آخر"},{"id":"b","text":"تلوّث ماء الوادي بالمبيدات أضرّ بجودته وأثّر سلبًا على الأسماك الّتي تعيش فيه"},{"id":"c","text":"نقص الأمطار هو السّبب الوحيد المحتمل لهذه الملاحظة"},{"id":"d","text":"المبيدات الكيميائية لا تذوب في الماء إطلاقًا فلا تأثير لها"}]'::jsonb, 'b', 'تسرّب المبيدات الكيميائية إلى ماء الوادي يلوّث جودته، ويقلّل مثلًا الأكسجين المذاب فيه الّذي تحتاجه الأسماك لتتنفّس بخياشيمها، ما يفسّر تناقص أعدادها.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ed171ab6-bcc7-5f86-b98a-cde03fc66400', '6a307483-1a11-5d1c-8a2f-f3139e499b91', 'أيّ العبارات الأربع التّالية بخصوص الماء ودوره في حياة الكائنات الحيّة **خاطئة**؟', '[{"id":"a","text":"الماء ضروريّ لكلّ الوظائف الحيوية عند الإنسان والنّبات والحيوان"},{"id":"b","text":"تحتفظ التّربة الطّينية بالماء مدّة أطول من التّربة الرّملية"},{"id":"c","text":"إلقاء النّفايات المنزلية في الأودية لا يؤثّر على جودة الماء إطلاقًا"},{"id":"d","text":"يمكن لبعض الحيوانات الحصول على جزء من حاجتها للماء من النّباتات الطّازجة الّتي تأكلها"}]'::jsonb, 'c', 'العبارة الخاطئة هي أنّ إلقاء النّفايات المنزلية لا يؤثّر على جودة الماء: فهذا الإلقاء من أهمّ أسباب تلوّث الماء وإضراره بالكائنات الحيّة. العبارات الثّلاث الأخرى صحيحة تمامًا.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cd576536-2543-58bc-a3f5-9ddf40bbb0e7', 'c3418051-d92b-590b-8e89-ae540df41bcc', 'sciences-vie-terre-7eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الماء ودوره في حياة الكائنات الحيّة', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('993dbeb8-fece-5738-863b-0829deac1d02', 'cd576536-2543-58bc-a3f5-9ddf40bbb0e7', 'أيّ مصدر من مصادر الماء التّالية لا يصلح للشّرب مباشرة بسبب ملوحته؟', '[{"id":"a","text":"مياه جوفية عذبة"},{"id":"b","text":"وادي مجردة"},{"id":"c","text":"بحيرة إشكل"},{"id":"d","text":"ماء البحر"}]'::jsonb, 'd', 'ماء البحر مالح ولا يصلح للشّرب مباشرة، بخلاف مياه الأودية والبحيرات والمياه الجوفية العذبة الّتي تُستعمل للشّرب والسّقي.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('320d778d-3e13-583c-8510-57eec36784cf', 'cd576536-2543-58bc-a3f5-9ddf40bbb0e7', 'كيف يحصل بعض الحيوانات على جزء من حاجتها للماء دون أن تشرب منه مباشرة؟', '[{"id":"a","text":"من النّباتات الطّازجة الغنيّة بالماء الّتي تأكلها"},{"id":"b","text":"عبر التّنفّس فقط"},{"id":"c","text":"من أشعّة الشّمس مباشرة"},{"id":"d","text":"لا تحتاج هذه الحيوانات إلى ماء إطلاقًا"}]'::jsonb, 'a', 'بعض الحيوانات تحصل على جزء من حاجتها للماء بصفة غير مباشرة من النّباتات الطّازجة الغنيّة بالماء الّتي تأكلها، إلى جانب شربها المباشر.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cad81b72-d40c-56a0-982b-9575ed26bef0', 'cd576536-2543-58bc-a3f5-9ddf40bbb0e7', 'أيّ ممّا يلي إجراء صحيح للمحافظة على جودة الماء في الوسط البيئي؟', '[{"id":"a","text":"إلقاء الفائض من المبيدات في الوادي القريب"},{"id":"b","text":"ترشيد استهلاك الماء وعدم الإفراط فيه"},{"id":"c","text":"إزالة الغطاء النّباتي لتوسيع الأراضي الزراعية"},{"id":"d","text":"عدم احترام المناطق الطّبيعية المحمية"}]'::jsonb, 'b', 'من إجراءات المحافظة على جودة الماء ترشيد استهلاكه وعدم الإفراط فيه، إلى جانب عدم التّلويث والمحافظة على الغطاء النّباتي واحترام المناطق المحمية.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cbb6f500-20b1-5a05-a9b1-aed670509738', 'cd576536-2543-58bc-a3f5-9ddf40bbb0e7', 'هل الماء عنصر حيّ أم غير حيّ في الوسط البيئي، وما علاقته بالكائنات الحيّة؟', '[{"id":"a","text":"عنصر حيّ لأنّه يتحرّك"},{"id":"b","text":"عنصر حيّ لأنّه يتبخّر وينمو"},{"id":"c","text":"عنصر غير حيّ، لكنّه يدخل في تركيب جسم كلّ كائن حيّ ويتدخّل في وظائفه الحيوية"},{"id":"d","text":"عنصر غير حيّ ولا علاقة له بالكائنات الحيّة"}]'::jsonb, 'c', 'الماء عنصر غير حيّ في الوسط البيئي، لكنّه في الوقت نفسه جزء أساسيّ من تركيب جسم كلّ كائن حيّ ومن نشاطه الحيويّ اليوميّ.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('846dde04-8b18-54d8-a340-28da03ff46d1', 'cd576536-2543-58bc-a3f5-9ddf40bbb0e7', 'لماذا يُعدّ الأكسجين المذاب في الماء أمرًا حيويًّا بالنّسبة إلى الأسماك؟', '[{"id":"a","text":"لأنّها تشربه فقط دون تنفّس"},{"id":"b","text":"لأنّها تتنفّس به عبر خياشيمها"},{"id":"c","text":"لأنّه يصنع غذاءها مباشرة"},{"id":"d","text":"لا علاقة للأكسجين المذاب بحياة الأسماك"}]'::jsonb, 'b', 'تمتصّ الأسماك الأكسجين المذاب في الماء عبر خياشيمها لتتنفّس، ولهذا يضرّ تلوّث الماء بها حين يقلّل هذا الأكسجين المذاب.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1ebd9d2b-887b-509a-913f-ce089968dbc2', 'cd576536-2543-58bc-a3f5-9ddf40bbb0e7', 'لاحظ فلّاح أنّ بركة ماء صغيرة قرب حقله جفّت خلال أيّام قليلة رغم أنّها محاطة بتربة رملية، بينما بركة أخرى مشابهة محاطة بتربة طينية بقيت رطبة مدّة أطول. ما التّفسير؟', '[{"id":"a","text":"لا علاقة لنوع التّربة بجفاف الماء"},{"id":"b","text":"التّربة الطّينية تطرد الماء أمّا الرّملية فتحتفظ به"},{"id":"c","text":"التّربة الرّملية حبيباتها كبيرة فيتسرّب الماء منها بسرعة، عكس التّربة الطّينية ذات الحبيبات الدّقيقة"},{"id":"d","text":"الجفاف عشوائيّ ولا يُفسَّر علميًّا"}]'::jsonb, 'c', 'التّربة الرّملية حبيباتها كبيرة فيتسرّب الماء منها بسرعة، بينما تحتفظ التّربة الطّينية ذات الحبيبات الدّقيقة بالماء مدّة أطول؛ هذا يفسّر جفاف البركة الأولى وبقاء الثّانية رطبة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('39a5721d-06e2-5f56-910b-e5e22264e371', 'c3418051-d92b-590b-8e89-ae540df41bcc', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: الماء ودوره في حياة الكائنات الحيّة', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('12934e6c-a55d-5f96-b916-44f8a1254f79', '39a5721d-06e2-5f56-910b-e5e22264e371', 'زرع فلّاح نباتات تحتاج كمّية ثابتة من الماء يوميًّا لتقوم بالتّركيب الضّوئيّ، في أرض ذات تربة رملية، وسقاها صباحًا بكمّية كافية. لاحظ أنّ أوراق نباتاته تذبل ظهرًا رغم ذلك. ما التّفسير الأرجح؟', '[{"id":"a","text":"التّربة الرّملية تحبس الماء طويلًا فيختنق النّبات"},{"id":"b","text":"النّبات لا يحتاج الماء للتّركيب الضّوئيّ أصلًا"},{"id":"c","text":"التّربة الرّملية لا تحتفظ بالماء طويلًا فيتسرّب سريعًا، فيصبح غير متوفّر لجذور النّبات ظهرًا رغم سقي الصّباح"},{"id":"d","text":"الظّهر يعطّل التّركيب الضّوئيّ بغضّ النّظر عن الماء"}]'::jsonb, 'c', 'التّربة الرّملية ذات الحبيبات الكبيرة لا تحتفظ بالماء طويلًا، فيتسرّب سريعًا بعد سقي الصّباح، ويصبح غير متوفّر لجذور النّبات بحلول الظّهر رغم توفّره صباحًا؛ من هنا الذّبول الظّهريّ رغم السّقي.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3c38c768-02a6-512e-b8af-641fb32de24c', '39a5721d-06e2-5f56-910b-e5e22264e371', 'يعيش أرنب برّيّ في منطقة جافّة، يقتات على أعشاب طازجة صباحًا ويلجأ إلى الظّلّ ظهرًا، ونادرًا ما يشرب ماءً مباشرة. من أين يحصل هذا الأرنب على معظم حاجته للماء؟', '[{"id":"a","text":"من تبخّر الماء عبر جلده فقط"},{"id":"b","text":"لا يحتاج الأرنب البرّيّ إلى ماء إطلاقًا"},{"id":"c","text":"يخزّن الماء في جسمه كالجمل حصريًّا"},{"id":"d","text":"من الأعشاب الطّازجة الغنيّة بالماء الّتي يأكلها"}]'::jsonb, 'd', 'بما أنّ الأرنب نادرًا ما يشرب مباشرة، فهو يحصل على معظم حاجته للماء بصفة غير مباشرة من الأعشاب الطّازجة الّتي يأكلها. أمّا الخيار (ج) فخاطئ: الجمل نفسه لا يخزّن الماء في سنامه بل دهنًا يمنحه الطّاقة، فلا وجود لحيوان «يخزّن الماء» بهذا المعنى.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ab645903-0ffa-50ec-aa32-4b21c65a2d7c', '39a5721d-06e2-5f56-910b-e5e22264e371', 'بعد تسرّب نفايات معملية غير معالجة إلى بحيرة، لوحظ نفوق أعداد كبيرة من الأسماك خلال أيّام قليلة، بينما بقيت النّباتات المائية حيّة نسبيًّا. ما التّفسير الأكثر انسجامًا مع دور الماء في تنفّس الأسماك؟', '[{"id":"a","text":"الأسماك توقّفت عن الشّرب فقط"},{"id":"b","text":"انخفاض الأكسجين المذاب في الماء بسبب التّلوّث أثّر مباشرة على تنفّس الأسماك بخياشيمها أكثر من تأثيره على النّباتات"},{"id":"c","text":"النّفايات المعملية لا تذوب في الماء إطلاقًا فلا تأثير لها"},{"id":"d","text":"النّباتات المائية تحتاج أكسجينًا أكثر من الأسماك"}]'::jsonb, 'b', 'تتنفّس الأسماك بخياشيمها الأكسجين المذاب في الماء، وتلوّث الماء بالنّفايات المعملية يقلّل هذا الأكسجين، فتتأثّر الأسماك مباشرة بنفوقها؛ النّباتات المائية أقلّ تأثّرًا بنقص الأكسجين المذاب لأنّها لا تعتمد عليه للتّنفّس بالطّريقة نفسها.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1b3f3621-3983-57d8-9f96-4fa6c333eacb', '39a5721d-06e2-5f56-910b-e5e22264e371', 'لوحظ أنّ مياه واد معيّن أصبحت غير صالحة للسّقي فجأة، رغم عدم وجود أيّ مصنع قريب منه. أيّ مصدر تلوّث زراعيّ هو الأرجح تفسيرًا لهذا التّغيّر؟', '[{"id":"a","text":"تساقط الأمطار الغزيرة على الوادي"},{"id":"b","text":"امتصاص جذور الأشجار للماء من الوادي"},{"id":"c","text":"تسرّب المبيدات والأسمدة الكيميائية من الحقول المجاورة إلى الوادي"},{"id":"d","text":"شرب القطعان للماء من الوادي بانتظام"}]'::jsonb, 'c', 'دون وجود مصنع قريب، يبقى المصدر الأرجح للتّلوّث هو تسرّب المبيدات والأسمدة الكيميائية الزراعية من الحقول المجاورة إلى الوادي، وهي من أهمّ أسباب تلوّث الماء المذكورة في الدّرس.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6dd75cd6-264c-5c9f-a873-a3bfe00b5256', '39a5721d-06e2-5f56-910b-e5e22264e371', 'هل صحيح أنّ كلّ مصادر الماء في الوسط البيئي صالحة للشّرب مباشرة؟ علّل إجابتك.', '[{"id":"a","text":"نعم، لأنّ كلّ الماء في الطّبيعة صالح للشّرب دون استثناء"},{"id":"b","text":"لا، فماء البحر مالح ولا يصلح للشّرب مباشرة، خلافًا لمياه الأودية والبحيرات والمياه الجوفية العذبة"},{"id":"c","text":"لا، لأنّ كلّ مياه الأودية والبحيرات مالحة أيضًا"},{"id":"d","text":"نعم، بشرط أن يكون لونه صافيًا فقط"}]'::jsonb, 'b', 'غير صحيح: ماء البحر مالح ولا يصلح للشّرب مباشرة، بخلاف مياه الأودية والبحيرات والمياه الجوفية العذبة الّتي تُستعمل للشّرب والسّقي؛ صفاء اللّون وحده لا يدلّ على صلاحية الماء للشّرب.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c4597cfa-cf18-5780-abf8-181bc25b3f53', '39a5721d-06e2-5f56-910b-e5e22264e371', 'لخّص تلميذ العلاقة بين نقص الماء ونشاط الكائنات الحيّة بجملة واحدة: «نقص الماء يعطّل نموّ النّبات فقط، ولا يؤثّر على الإنسان أو الحيوان بنفس الدّرجة.» أين الخطأ في هذا التّلخيص؟', '[{"id":"a","text":"الخطأ أنّ نقص الماء يؤثّر بنفس الأهمّية على الإنسان والحيوان كذلك، لا على النّبات فقط، لأنّه حاجة حيوية مشتركة بين كلّ الكائنات الحيّة"},{"id":"b","text":"لا خطأ، فالتّلخيص دقيق تمامًا"},{"id":"c","text":"الخطأ أنّ نقص الماء لا يؤثّر على النّبات إطلاقًا"},{"id":"d","text":"الخطأ أنّ الحيوان وحده يتأثّر بنقص الماء لا النّبات ولا الإنسان"}]'::jsonb, 'a', 'الخطأ في التّلخيص هو حصر أثر نقص الماء بالنّبات وحده: الماء حاجة حيوية مشتركة بين الإنسان والنّبات والحيوان جميعًا، فنقصه يختلّ به توازن كلّ واحد منها بنفس الأهمّية، لا النّبات فقط.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('05252fc0-9e36-51a3-973a-24323671b645', 'c3418051-d92b-590b-8e89-ae540df41bcc', 'sciences-vie-terre-7eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): الماء ودوره في حياة الكائنات الحيّة', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d9f10875-b71d-5134-bbd1-b3c13c47b67b', '05252fc0-9e36-51a3-973a-24323671b645', 'يُصنَّف الماء ضمن أيّ مكوّن من مكوّنات الوسط البيئي الّذي درسته سابقًا؟', '[{"id":"a","text":"عنصر غير حيّ ضمن الوسط غير الحيّ (biotope)"},{"id":"b","text":"مجموع الكائنات الحيّة (biocénose)"},{"id":"c","text":"لا يُصنَّف الماء ضمن أيّ من المكوّنين"},{"id":"d","text":"الماء نفسه كائن حيّ مستقلّ"}]'::jsonb, 'a', 'الوسط البيئي يتكوّن من الوسط غير الحيّ (biotope: تربة، ماء، هواء، مناخ) ومجموع الكائنات الحيّة (biocénose)؛ الماء عنصر غير حيّ ضمن الوسط غير الحيّ.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7e3c4329-bc42-5f08-8a34-a586588b6d63', '05252fc0-9e36-51a3-973a-24323671b645', 'ما العلاقة بين نوعية الماء وتنفّس الأسماك الّتي درستها في فصل التّنفّس؟', '[{"id":"a","text":"الأسماك تتنفّس هواء الجوّ مباشرة فلا علاقة للماء بتنفّسها"},{"id":"b","text":"الماء يمنع الأسماك من التّنفّس نهائيًّا"},{"id":"c","text":"الأسماك تمتصّ الأكسجين المذاب في الماء عبر خياشيمها، فتلوّث الماء يقلّل الأكسجين المتاح لها ويهدّد تنفّسها"},{"id":"d","text":"لا علاقة بين تلوّث الماء وتنفّس الأسماك"}]'::jsonb, 'c', 'الأسماك تتنفّس بخياشيمها الأكسجين المذاب في الماء؛ ولهذا فإنّ تلوّث الماء وما يخفضه من أكسجين مذاب يهدّد مباشرة قدرتها على التّنفّس.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c1dc1f6c-df4a-561f-8879-d63a8ab1bd36', '05252fc0-9e36-51a3-973a-24323671b645', 'ما الفرق بين دور الماء ودور ثاني أكسيد الكربون (CO2) في تغذية النّبات الأخضر الّتي درستها سابقًا؟', '[{"id":"a","text":"كلاهما يُمتصّ بالجذور من التّربة فقط"},{"id":"b","text":"الماء يُمتصّ بالجذور من التّربة، وCO2 يُمتصّ بالأوراق من الهواء، وكلاهما ضروريّ للتّركيب الضّوئيّ"},{"id":"c","text":"لا علاقة لـ CO2 بالتّركيب الضّوئيّ، فقط الماء ضروريّ"},{"id":"d","text":"الماء يُمتصّ بالأوراق وCO2 بالجذور"}]'::jsonb, 'b', 'يمتصّ النّبات الماء بجذوره من التّربة، بينما يمتصّ CO2 بأوراقه من الهواء المحيط؛ وكلاهما مادّة أوّلية ضرورية للتّركيب الضّوئيّ إلى جانب الضّوء.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('859b48cc-64ac-560f-8b6f-22edad7a23e0', '05252fc0-9e36-51a3-973a-24323671b645', 'أيّ نمط تغذية عند الحيوان (عاشب، لاحم، قارت) يُرجَّح أن يحصل صاحبه على أكبر كمّية من الماء بصفة غير مباشرة عبر غذائه النّباتي الطّازج؟', '[{"id":"a","text":"اللاحم الّذي يقتات على اللّحم فقط"},{"id":"b","text":"لا علاقة لنمط التّغذية بكمّية الماء غير المباشر"},{"id":"c","text":"القارت فقط دون العاشب"},{"id":"d","text":"العاشب الّذي يقتات على النّباتات الطّازجة"}]'::jsonb, 'd', 'بما أنّ بعض الحيوانات تحصل على جزء من حاجتها للماء من النّباتات الطّازجة الغنيّة بالماء الّتي تأكلها، فإنّ العاشب الّذي يقتات حصرًا على هذه النّباتات هو الأكثر استفادة من هذا المصدر غير المباشر.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bb0c62ee-12cd-568b-9d68-0c5b331b1bee', '05252fc0-9e36-51a3-973a-24323671b645', 'كيف يمكن لتلوّث الماء في واد أن يؤثّر على سلسلة غذائية كاملة تبدأ بعوالق نباتية مائية، كما درست في فصل العلاقات الغذائية؟', '[{"id":"a","text":"لا تأثير لتلوّث الماء على السّلسلة الغذائية لأنّها تخصّ اليابسة فقط"},{"id":"b","text":"تلوّث الماء قد يضرّ بالعوالق النّباتية (المنتج) في بداية السّلسلة، فتتأثّر تباعًا كلّ الحلقات الّتي تعتمد عليها"},{"id":"c","text":"تلوّث الماء يقوّي العوالق النّباتية فقط دون بقيّة الحلقات"},{"id":"d","text":"السّلسلة الغذائية المائية لا تحتوي منتجًا أصلًا"}]'::jsonb, 'b', 'العوالق النّباتية منتج تبدأ به السّلسلة الغذائية المائية؛ إذا أضرّ تلوّث الماء بها، تتأثّر تباعًا كلّ الحلقات اللاحقة الّتي تعتمد عليها في غذائها، لأنّ اختفاء حلقة يختلّ به توازن السّلسلة كاملة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('69f866c1-c541-51f4-9d7c-29ce8dc1d250', '05252fc0-9e36-51a3-973a-24323671b645', 'لماذا تُعدّ قدرة التّربة على الاحتفاظ بالماء، الّتي درستها في فصل التّربة، عاملًا مهمًّا في تغذية النّبات الأخضر بالماء؟', '[{"id":"a","text":"لأنّ التّربة تصنع الماء بنفسها"},{"id":"b","text":"لا علاقة بين نوع التّربة وتغذية النّبات بالماء"},{"id":"c","text":"لأنّ جذور النّبات تمتصّ الماء المحتفَظ به بين حبيبات التّربة، فكلّما احتفظت التّربة بالماء مدّة أطول (كالتّربة الطّينية) وفّرت للنّبات ماءً أكثر انتظامًا"},{"id":"d","text":"النّبات يمتصّ الماء من الهواء فقط بغضّ النّظر عن التّربة"}]'::jsonb, 'c', 'تحتفظ التّربة بالماء بين حبيباتها، وهو ما تمتصّه جذور النّباتات؛ فكلّما طالت مدّة احتفاظ التّربة بالماء (كالتّربة الطّينية مقارنة بالرّملية)، توفّر للنّبات إمدادًا مائيًّا أكثر انتظامًا.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1e6f49bc-7bbc-58cc-aebd-9146ab60d900', 'c3418051-d92b-590b-8e89-ae540df41bcc', 'sciences-vie-terre-7eme', '👑 تحدّي النخبة ⭐⭐⭐⭐ (القمّة): الماء ودوره في حياة الكائنات الحيّة', 4, 300, 60, 'challenge', 'admin', 6)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c40f40c6-9ada-5597-b1c3-1fea246cb5cd', '1e6f49bc-7bbc-58cc-aebd-9146ab60d900', 'سمكة تعيش في بحيرة تلقّت مؤخّرًا كمّية كبيرة من مياه صرف صناعيّ غير معالجة. رغم بقاء درجة حرارة الماء ثابتة، بدأت السّمكة تطفو قرب السّطح وتتنفّس بصعوبة واضحة. ما التّفسير الأقرب اعتمادًا على دور الماء في التّنفّس؟', '[{"id":"a","text":"السّمكة تحوّلت فجأة إلى التّنفّس الرّئويّ"},{"id":"b","text":"نقص الأكسجين المذاب في الماء بسبب التّلوّث دفع السّمكة للاقتراب من السّطح حيث الأكسجين أوفر نسبيًّا"},{"id":"c","text":"ثبات درجة الحرارة هو السّبب المباشر لصعوبة التّنفّس"},{"id":"d","text":"الصّرف الصّناعيّ يزيد الأكسجين المذاب في الماء"}]'::jsonb, 'b', 'الصّرف الصّناعيّ غير المعالج يلوّث الماء ويخفّض الأكسجين المذاب فيه؛ تلجأ الأسماك حينها إلى الاقتراب من سطح الماء حيث تبادل الأكسجين مع الهواء أوفر نسبيًّا، في محاولة لتعويض هذا النّقص.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('824b1ee2-b146-5089-968c-56494a747ba8', '1e6f49bc-7bbc-58cc-aebd-9146ab60d900', 'تربة منطقة زراعية طينية القوام تحتفظ بالماء جيّدًا، لكن أهمل الفلّاحون سقيها لأسابيع طويلة خلال الصّيف. صف السّلسلة المتوقّعة من الآثار بدءًا من النّبات وصولًا إلى المستهلكات الّتي تعتمد عليه.', '[{"id":"a","text":"لا يتأثّر النّبات إطلاقًا لأنّ التّربة الطّينية تخزّن ماءً كافيًا إلى الأبد"},{"id":"b","text":"المستهلكات تتأثّر مباشرة دون أن يتأثّر النّبات أصلًا"},{"id":"c","text":"نقص تجدّد الماء يوقف امتصاص الجذور تدريجيًّا رغم احتفاظ التّربة الطّينية بالماء فترة، فيضعف التّركيب الضّوئيّ، فيقلّ إنتاج النّبات (المنتج)، فتتأثّر المستهلكات الّتي تعتمد عليه في السّلسلة الغذائية"},{"id":"d","text":"نقص الرّي يزيد إنتاج النّبات لأنّه يقلّل المنافسة على الماء"}]'::jsonb, 'c', 'الأثر يتسلسل عبر خطوات مترابطة: احتفاظ التّربة الطّينية بالماء يؤخّر الأثر لكن لا يمنعه؛ فمع استمرار انقطاع الرّي، يضعف امتصاص الجذور، فيضعف التّركيب الضّوئيّ، فيقلّ إنتاج النّبات المنتج، فتتأثّر تباعًا المستهلكات الّتي تعتمد عليه في السّلسلة الغذائية.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('025a54a5-1b47-5d3e-9918-1d3471d7ae58', '1e6f49bc-7bbc-58cc-aebd-9146ab60d900', 'لوحظ أنّ مياه بئر جوفيّ أصبحت غير صالحة للشّرب فجأة رغم عدم وجود أيّ مصدر تلوّث مباشر فوق سطح الأرض بالقرب منه. أيّ تفسير الأكثر انسجامًا مع ما درسته عن التّربة والماء الجوفيّ؟', '[{"id":"a","text":"المياه الجوفية معزولة تمامًا عن أيّ تأثير خارجيّ دائمًا"},{"id":"b","text":"البئر جفّ بالكامل فأصبح فارغًا من الماء"},{"id":"c","text":"التّربة الطّينية القريبة تنقّي كلّ المياه الجوفية تلقائيًّا"},{"id":"d","text":"تسرّبت موادّ كيميائية زراعية من حقول بعيدة عبر التّربة إلى المياه الجوفية تدريجيًّا"}]'::jsonb, 'd', 'المياه الجوفية ليست معزولة تمامًا: يمكن للموادّ الكيميائية الزراعية (كالمبيدات والأسمدة) أن تتسرّب عبر التّربة من حقول بعيدة نسبيًّا لتصل تدريجيًّا إلى المياه الجوفية وتلوّثها، حتّى دون وجود مصنع قريب من البئر نفسه.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7af01fc5-3fe0-5a7c-b1b3-b270ff59e6df', '1e6f49bc-7bbc-58cc-aebd-9146ab60d900', 'قِيست كمّية الأكسجين المذاب في نقطتين من نفس الوادي: النّقطة (أ) قرب مصبّ مصنع، والنّقطة (ب) بعيدة عنه بمسافة كبيرة. كانت كمّية الأكسجين عند (أ) أقلّ بكثير من (ب). أيّ استنتاج الأنسب لهاتين الملاحظتين معًا؟', '[{"id":"a","text":"لا علاقة بين موقع المصنع وكمّية الأكسجين المذاب"},{"id":"b","text":"تصريف المصنع القريب من (أ) خفّض جودة الماء وقلّل الأكسجين المذاب فيه مقارنة بالنّقطة (ب) الأبعد والأقلّ تأثّرًا"},{"id":"c","text":"النّقطة (ب) أقرب إلى المصنع من النّقطة (أ)"},{"id":"d","text":"كمّية الأكسجين المذاب لا تتغيّر أبدًا داخل نفس الوادي"}]'::jsonb, 'b', 'الفارق الواضح في الأكسجين المذاب بين النّقطتين (أقلّ قرب المصنع) ينسجم مع أثر تصريف المصنع على جودة الماء: كلّما اقترب موقع القياس من مصدر التّلوّث، انخفض الأكسجين المذاب أكثر.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4e5e3da5-8f7d-5a19-97a2-090059271a96', '1e6f49bc-7bbc-58cc-aebd-9146ab60d900', 'أيّ العبارات الأربع التّالية الرّابطة بين الماء ووظائف حيوية أخرى درستها **خاطئة**؟', '[{"id":"a","text":"الماء ضروريّ لتنفّس الأسماك لأنّه يحمل الأكسجين المذاب الّذي تمتصّه بخياشيمها"},{"id":"b","text":"الماء ضروريّ لتغذية النّبات الأخضر لأنّه مادّة أوّلية للتّركيب الضّوئيّ إلى جانب CO2 والضّوء"},{"id":"c","text":"الماء لا علاقة له بالسّلاسل الغذائية المائية لأنّ العوالق النّباتية لا تحتاج ماءً إطلاقًا"},{"id":"d","text":"تلوّث الماء يمكن أن يفكّك سلسلة غذائية كاملة بدءًا من منتجها الأوّل"}]'::jsonb, 'c', 'العبارة الخاطئة هي (ج): العوالق النّباتية كائنات حيّة تحتاج الماء ككلّ نبات، وهي منتج أساسيّ في السّلاسل الغذائية المائية؛ العبارات الثّلاث الأخرى صحيحة تمامًا وتلخّص روابط الماء بالتّنفّس والتّغذية والسّلاسل الغذائية.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d09e8ae9-5028-5e8f-b987-76c77d712ba5', '1e6f49bc-7bbc-58cc-aebd-9146ab60d900', 'في منطقة أُزيل غطاؤها النّباتيّ بالكامل لتوسيع أرض زراعية، لوحظ لاحقًا: تعرية سريعة للتّربة السّطحية، انخفاض قدرة التّربة على الاحتفاظ بالماء، وجفاف الآبار القريبة تدريجيًّا خلال سنوات قليلة. ما الرّابط المنطقيّ الأكثر انسجامًا بين هذه الملاحظات الثّلاث؟', '[{"id":"a","text":"الغطاء النّباتيّ كان يثبّت التّربة ويساعدها على الاحتفاظ بماء الأمطار الّذي يغذّي المياه الجوفية تدريجيًّا؛ إزالته سرّعت التّعرية وقلّلت تسرّب الماء المنتظم إلى الآبار"},{"id":"b","text":"الملاحظات الثّلاث غير مرتبطة إطلاقًا وحدثت صدفة"},{"id":"c","text":"إزالة الغطاء النّباتيّ تزيد قدرة التّربة على الاحتفاظ بالماء دائمًا"},{"id":"d","text":"جفاف الآبار سبّب تعرية التّربة لا العكس"}]'::jsonb, 'a', 'سلسلة السّبب والنّتيجة هنا مترابطة على ثلاث خطوات: الغطاء النّباتيّ يثبّت التّربة ويساعدها على الاحتفاظ بماء الأمطار؛ إزالته تُسرّع تعرية التّربة السّطحية وتُضعف احتفاظها بالماء؛ وهذا بدوره يقلّل تسرّب الماء المنتظم إلى المياه الجوفية، فتجفّ الآبار القريبة تدريجيًّا خلال سنوات قليلة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

-- Converge question → competency mappings for this subject (étude 07 D-2).
DO $$
BEGIN
  IF to_regclass('public.question_competencies') IS NOT NULL THEN
    DELETE FROM public.question_competencies qc
    USING public.questions q, public.exercises e
    WHERE qc.question_id = q.id
      AND q.exercise_id = e.id
      AND e.subject_id = 'sciences-vie-terre-7eme'
      AND e.source = 'admin';
  END IF;
END $$;

