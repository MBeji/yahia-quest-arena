-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: math-1ere (الرياضيات)
-- Regenerate with: npm run content:build
-- Source of truth: content/math-1ere/
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
  ('math-1ere', 'الرياضيات', 'الأنشطة العددية والهندسة والتموقع في الفضاء وفق برنامج الرياضيات للسنة الأولى من التعليم الأساسي', 'Force', 'subject-math', 'Calculator', 1, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '1ere-base'), '[{"code":"102105P01","label":"الجزء الأول"},{"code":"102105P02","label":"الجزء الثاني"}]'::jsonb)
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
      AND e.subject_id = 'math-1ere'
      AND e.source = 'admin'
      AND q.id NOT IN ('22bc1be9-2583-59f6-9313-9c6f101eec2f', 'e8b1ae2b-7b2f-5217-ac38-376fc22f5ad8', '1585e224-ecbf-5ced-9536-da6c29ec7fb3', 'd3066a32-5c2b-5c9b-b347-50a9b260df12', '64108a36-1a32-52bb-8ae8-a3ccb3652af8', 'a087aafb-c69d-585d-97c3-56271d8a48a6', 'ac0ceb82-56b2-5d4e-bf8d-602007ee5e55', 'b73ac76d-695b-5c14-9fa0-2f501eedc464', '1c9ffe8f-8129-545a-8669-735e33e24caa', '14d4b509-511f-5716-aba5-baad7bd31983', '71b39dd7-469b-5120-8e72-6e462db6f17f', 'd35b5636-94f9-5e7b-9bd6-b32414bd4d52', '92a41e6f-fdda-55a8-8ed3-a750d313b6c0', 'd662e1b7-0c5a-50a9-8a13-af31faf6623c', '377112bd-4ede-5b14-ad5a-158734dce1d4', '5d6dc786-aefd-5e06-8dbd-b3b3aba85100', 'b1a93572-5ad3-5eac-b608-5c44d40ff43c', '79165bf5-d403-5ee0-bb61-415501302204', 'fe4171ca-bcbf-5adf-9250-aa415e7d1ed8', '9e2e31e4-84ed-58cb-88c6-e308556fabbb', 'b9f9b894-3beb-5687-922d-0e1495bd812f', 'ea4bf596-c295-5095-afb5-a1b1a80b4629', 'e44d5b7b-66a4-5d13-ba12-00da4f0fde1c', '6b57bb64-57a9-5a41-b271-511dba252032', 'ffbc3aef-7acd-52c8-bade-17491d0b3f03', '495fd9c0-95fa-550e-9c47-2bb07e0c2abd', '6b32867e-d5d0-574a-8d2f-c25c803b56c3', '062d542a-f647-5025-9138-b3ef29b619f0', '906088ab-04a4-5cd2-9869-cf1057c25c8b', '20de4c9f-827c-5a14-9fd8-39e700372f9c', '65921bd0-bb97-5da8-8a53-e26dd3bff15c', '6359a174-80e5-56f8-bb27-41fe1bf486d0', 'dba1a28d-b391-59c0-9b3b-ba140bd04974', '61d31db6-a24b-5fde-89ad-96fe8009279d', '4e93f4b0-5cee-505a-b39b-a1129d3d78dc', '9c5b368b-1b91-5845-81f3-c9bfe7ae63b1', 'efb2f8b7-1b64-59aa-94c2-5ef8ee0d75a7', 'a15132a4-6ade-57f9-bd71-8dcffaff868a', '8e7b88bb-cd74-5780-b655-2ddd33a6fd94', '6817ab7b-4807-51cd-997a-54058567ce3c', 'af263e77-d14e-55c1-9fe9-7d6b41b7451d', 'dda0a4af-d061-5a87-8303-61d362260eaa', '2922137e-c2e3-58e7-8693-e6d803e77a99', '4a858ebd-eabb-50b4-8939-8fd36a6dec5f', 'eb0cbf45-dd30-50a1-a92d-6da781cefe87', 'fa7dbdf0-347b-548c-98a0-d9b7b230bd2c', '2ffdb7c6-d090-5c52-a887-57114178880a', '31c18015-043b-56f4-8668-ea467de9a8c4', 'd326095a-c43f-57fe-ac3b-7dd3a04417d4', '8540226d-914a-5bfe-ab00-2e72405f12e4', '73a2b0b6-8e5f-5995-ba97-cde9ea6c90aa', 'da2f2c56-a562-5df6-a3aa-0d8635b5bfc8', 'aa5e3851-8aa8-5854-beca-89ad71dda792', '001d9636-1cca-5405-8a5d-534e4e37d451', '8cc1bd67-7fea-5325-b0e3-0cb5d36313eb', 'bf9f07ce-b212-5212-ac03-29fab1bcbf81', 'a388d075-825c-5b3f-94f5-260e37a06f41', '459f2b38-a2fc-5dff-8350-14af044800e6', 'fac80caa-f1fb-57af-88bb-149e6617349d', 'e222f189-542b-5296-ae4c-fd5ca42446a8', '88d8dba7-d94a-5476-ad8d-a59dbc869e6c', '2c1c671c-e69d-5398-9b5b-31f134c7ee20', '783e5cc1-0909-5350-aeee-11e37109c50e', 'd46a2031-2e6c-5ac3-b3c0-58e2f6b8a617', '2c2732a5-ef61-52dc-bbc4-feb4728f559c', '3837c709-218f-5b07-8642-cc7a2623ba35', '297a18df-b730-5122-8416-3f2c6cf961b4', '90f97137-2f2c-55da-bbfa-3b6057f4b335', 'ac8c35c4-8620-525c-b02a-366bc1f5d691', '7aeb467a-2ff1-5378-98f7-f2cac24bdd0a', '82f55bbb-25d8-5863-8200-aa986a0534c3', 'f8428593-2179-5bba-af58-174df69839c4', '7cb42658-e019-5651-b74b-9a132464dfba', 'e4e05e71-e7b0-52f9-886d-08ac5ee1ebc0', '10f37e84-77f9-5e4c-9a3e-6633bbf8a2d2', '82fde5f3-362f-5acd-b512-6deb62ecdddd', '5e4a8793-eb42-5bd5-a913-cef3fba0d7f6', 'a15e23bf-c9e7-53b8-9d9b-6e9ba72a6a21', '5b090ea2-fc32-51bf-9fb4-d5b7b169b225', 'f78a1066-702e-5c6f-8a6e-79128959cf3b', 'd0cb6a14-200a-555b-a666-ec6c54b9bc50', '82594895-9ac1-5a9a-91f9-013db536a435', 'fbd4bb4e-d074-5049-b09b-8ad3d4f18a07', 'f9458b1d-6e21-5fdc-9169-62a2915a047e', 'b84b46ce-f1a7-5495-b6e0-5c59523cae95', 'bf299130-4e08-5f95-ac43-4814d35f8565', '51120502-1e21-57d9-99a7-b20f1044060d', 'b3c32f7f-fd1a-50a5-b14c-9ee5e2b526e0', 'bb37fdd4-767c-59ce-aa88-6bdaa4da3795', 'a7272737-c9ea-53c2-a162-d601aa55120e', 'b1023f58-22c6-5f7d-8b4b-d0065b4025aa', '4258f021-4230-5b31-9bda-af0a12c9686d', '20155c79-14e9-5204-a851-a397773420b7', '15b15ca9-de27-514e-866f-4dbe92db8551', 'aa5739ba-798d-5a5b-8753-e769b782af1d', '17c9e34e-1ccf-55e2-b1c7-17d723701c06', 'a6b46202-5216-58f7-aaee-06ab418899c6', '73d236c0-ec8a-56a5-a68c-385f7c3becde', 'b4e6f1a5-8e3e-50ad-93bc-7ff96a21d8da', '558d7fe4-4b6f-5c17-9845-28971f69844f', 'ee5c1c98-3ea0-57d9-9a12-cb45333de6ea', '32330e55-3c9f-55ed-b4c9-1dddb5b324e9', '30378330-c107-551b-bbed-de3b6a102ed4', '84f2065f-c2c0-5e63-8a44-0ba771a85daa', '3bb3f1e1-f549-52c9-b38b-67bb046df5f2', '71cfb666-ae83-50bf-a6b5-4a0a71524e85', 'c87a45b0-bfea-54e4-89ec-5ba81d64fc41', 'eb4e4eab-9f21-5091-b6f4-348868bc2b73', '25a16184-7c27-5dfe-b82e-fcb4d7ef0cde', '1a15eed5-8f6a-52fa-a745-dfe5b13ee93a', '49a52a15-0e77-5d0f-be4b-dbd11f39cb64', '9bd8e9d4-201e-5c10-97d9-c6fcb48a90d0', '585b34c2-575e-51f0-a108-d1cdb8222ee5', '1638861b-db67-5dfc-a946-9ef49daf4dfc', '79256cf2-ecbd-56b2-addb-2fbf64db9a04', '523582ee-9fcd-59f3-80f0-8caae92bfe83', 'f041760b-e838-5855-b11e-efe68a614bf3', 'b08af78c-5448-5fd4-b09a-f14fb4972bf9', 'd7a5be23-46e5-5bb2-950e-3b4cfd26201a', '65c7e7a1-6276-565b-bf75-0a10c0e331b4', '3b33511c-1bcd-532b-ba8b-0a217d54260f', '5a3d0ca7-a6bc-5d3a-b8b5-92e49376d8d4', '036b8c30-7ebf-59c5-a7d0-2938920233ea', '54dd9110-9e8f-52bb-9811-738f84d70e76', '24b16315-b429-556b-8bab-b6f108d7bce2', '2a501ec8-b0a9-5198-b56b-b9064f08e75c', '44456f5b-f0f7-54f3-9ee4-e68967233ae4', '3a27ac81-df7d-5485-969a-00929d5d1361', '214c2396-9825-5ea4-a155-4e4f6873c428', 'e11c09cc-f684-5507-b331-cf33829b4b0c', 'bcdae7ac-aedf-5f55-9cbf-92ce72bff640', '58e04c6d-bd69-5b60-8e80-0903eee2008e', 'b1cf10af-78e6-5d80-9894-26fbd0729d9b', '0298fab9-60e5-5b4f-80ac-5f82117802a7', 'ad7a24f6-aa42-57c3-830e-f32b1cfff937', '6b343783-6e05-527d-9ebf-ace568acaec8', '1d163f73-069b-52e5-b483-7b04cdc71d00', '236d31ad-9e59-55d6-ba71-4d5a48ef62ee', 'ad290fb8-1a41-5b8c-9994-1a19664ca7c2', 'baf24cba-a820-5220-88cc-d485b9335a9c', 'd5b375e8-c4b7-5e0f-b9b2-61272aa9cb97', '95c9839d-2a8f-52ac-9d17-1695964834f3', '29365060-83e3-59e0-81b9-378e9d61af99', 'e6127c6c-64ef-586b-b2fd-f09e4e6c6d12', '712d8311-7d86-5cf7-b085-d34c06711955', 'f9dbcf87-fa71-5038-8150-e81cff0c41f4', '50244701-7dc5-51b0-912a-893925bf227d', '0a9b3458-ae53-599a-965c-50349d34e597', 'c21d56e4-55a9-5657-aedf-39bdc20d3ceb', '8ad724e3-853d-5b80-a90a-3577acba26c5', 'e327d39c-d85c-5346-bbfa-bd83c5f0fee1', '42e88bd7-4298-5730-9ada-c7e81feb4adf', '8eb0056a-2f68-5659-ace5-52c3c1539389', '3469d23d-88b0-519b-a06c-577b84bc3fba', '16dd707b-b85b-5b4c-9a1f-b1865f47cf24', '0b30c329-dd4f-50eb-a58c-48b235420954', '2ddfb6aa-fe77-5138-ab94-cdba048833e0', '31516993-ac7d-5c36-b2a8-832d0f74dca0', '7c295116-6718-5a84-b050-94eec0aa3a0a', '73bcfe58-1630-513f-beee-478cf44f395f', '21dfd92c-41d5-5f3d-b078-ea3ee660602d', '94954b82-ff17-5040-88ea-26fb986959b1', '8c1028bf-3751-5191-ba05-1b761e865a00', '9c3747af-087a-5c4f-b21a-a76dc8aef922', '4d71db59-9f5a-577c-88eb-80ff438c4663', '47214a38-e287-5766-873a-ac45f4385942', '98f2bbdd-8345-565d-9f28-954ebe69cbbb', '107f4cf2-6dc2-54c0-82fb-e18dd522be77', '25b763c8-45fd-506e-a169-250527a6fc3a', '4f41d0cc-f870-53e4-96e5-b4793f4f1a0f', '7af74aa9-2a42-5d2a-971f-8eb9cba7a565', '780ba838-fda6-5e99-8f1f-184f663ada94', '0a930397-f8d4-589a-89f6-9716075e5eab', '3267f7ee-e587-5837-8635-7947c3c177f9', 'a3d2680d-e3b0-549a-987a-cb07b794a161', '6ea55610-d391-53be-9232-9eada63ddc4c', 'ca6cf9be-9579-55c5-8689-e58bcc0dc5aa', 'ff790735-270e-51f6-9edb-19d59cbedfe3', '33855e7c-a22e-5b0e-b8e8-303a41fab514', '8f008999-8932-5f65-a18f-76a37a1b932e', 'f05c1420-1910-5417-97e2-0dbe2115145e', 'a48c8c76-c8e5-541d-9c62-a58841e5d819', '85fecd91-1ca1-5861-a447-6c79af01d3cb', 'e1d002ed-36d9-55ab-bca2-4ea0cd62dc0a', 'a404a87b-ebde-55cd-a300-44ff03ae8091', 'acd19ce3-e01a-511b-8e45-0310729866f3', '81458cd3-26ba-56b6-9b66-e7b4fb4f4dc1', 'e81a6e90-c680-5f88-8b01-b09ccdb0bb5d', '0b8d987d-c39c-5618-ad43-1632322a40d2', '7b625a66-7035-5e4f-93e5-03d0f920a18c', '3e821524-94d3-5f9a-9769-18c2e2d89270', '4ec23861-02da-5501-a72c-e2cd756592e4', 'f17793c6-cc59-5f81-83ab-5368d3e4259b', '40d82f98-5706-52e0-9acc-53d0beacef72', 'f55e537c-688f-59c8-9756-a6356a7258bd', '938296c0-b318-5d24-8777-9ccf8877170f', '0a659fb4-d0f3-5cb6-8f72-fac3277bab51', 'a4340fb8-42d0-5fa7-a0fd-d245209ee1a3', '8031f090-3d59-56d9-bc6d-d62dec4b20f6', 'ae26e2e9-7ff5-5856-acda-d90e1f37d8ab', 'c8cbb611-2d0f-53ff-91da-10654a7d92ed', 'ad707bfe-a04c-54e4-ab53-bf631ffc148e', '0e613076-a519-5f55-bf80-28b2e61206a3', '1f7cd46f-b943-5030-a154-9b5b282861d4', 'd49afe62-31b1-5e08-a3fd-6b5645e68208', 'b6d53087-0db8-52f4-9726-4e47f8bdb808', '822bef85-9698-51ab-991f-544dba5097fb', 'e4e635b7-158b-5fe6-9a0c-49cf19401c9d', '761c5ce8-1dee-59f2-b273-2d8b51489fd5', '54780662-1c11-5af1-9245-8c0bc9e7029b', '57c1f07c-857a-538f-ab92-dfd8a6bace8e', 'eeaeaafd-4589-5374-909a-27f375ac998b', '317515c6-e897-5eb5-a00b-ca64085b1b81', '6610461e-5650-5cf7-b199-a8bb34408cc2', '10ea2e88-f7e7-596a-8178-46b2dcd6057d', 'd0528ac2-122b-5c70-bd24-b483f7bf93b3', '2e34135d-2a32-5fff-b178-e0b05c4690d0', '6921550d-4aec-5766-bdbc-b731b9f62a2f', 'bd8cb2ab-b6dc-53f9-9511-c5bef7a9afd4', '0a629f5e-a9e7-54fa-a817-f4b0df79653e', 'b4e94c9f-6351-5579-b04a-94eb1c60719d', 'b163e575-36dc-54c0-8277-ed79cccfc818', '25fc2c23-562d-5670-9003-2b59c84eecfa', '13d14a0a-be0f-5681-915a-5982fb7e0043', '196a7740-e602-5334-8d04-c1a35d50e9bb', 'cb6ad8ff-b716-5944-85b3-29e1dda0cc8f', '1271ca7e-d044-5832-8b2d-f5ebc4baf771', 'ab9d8eeb-d6bf-5c6b-bc75-a4ee1a4bd88b', '88f81ec7-a9e8-546d-a269-d1dbff37988b', 'a346e635-4a08-5fbe-977b-8e1eb7becf74', '7667fc44-0053-5465-b222-5e250dd6d151', '657c3cad-54f3-5b84-b47f-b5671ada015b', 'fe5018c7-1549-54da-b69d-75709bc701a0', '38973286-cfbb-5412-94ce-bcfa3beefc4f', '00aea2ff-f589-5546-aa82-9c520958e7bd', '0f79b8ae-d296-5598-be7a-2d036fbd409f', '828a7ef0-eec4-5e78-8dc9-9ec722bdf1ab', '5bbab080-cb30-5098-aa91-55c9ebbe190c', 'd21763cc-2b22-5328-8187-379282479f50', '48152f8d-0746-5301-9a00-023d6102be87', '52d2cfb0-2bbc-5ee2-8291-b59ea666195e', '68f60f29-037b-5f02-a008-f199b7681422', '3f6be308-ae5d-55b2-bec6-bf7ec01ca9cc', '60d28e3d-2db2-5040-a9d3-4b0441bcc280', 'b4f4f774-745c-5995-96db-95a149207b39', 'bbaaae38-2cb3-5908-8bfb-fbf1906e4f98', '1ced8c76-f97b-572b-9591-3fe269277028', 'bb954a72-de8c-5adc-842c-9791c95c7f84', 'c480088c-872b-5aea-98fe-d561153ea836', '09a51142-6ae5-5691-82a0-35fae3413d70', '0aa1c485-16a8-5cd6-88bd-40619c7645e1', 'dcf7d2a0-2a72-518d-a6e2-62176e3d4788', '91081dad-89b7-546e-a814-17914e20f367', 'd61d4f2e-6cc3-59f6-95e6-62489ea43801', '798001d9-de2f-5304-8dbf-af2c92051a2c', '02148af8-f7e8-5e5d-ae98-cfe38749084d', 'aa455f9a-a0ba-5bb6-82eb-4d83de3a3fe5', '4ad3dd38-a71a-57dd-8713-7b9e2be897ec', 'ef3a3a5c-c0eb-5614-b38e-188b9480e7b1', '9c5d925f-8ddb-5b8d-97dd-67ec37f8f98c', 'd5f07ccd-ba36-5b7b-8a93-a290e3a15e6a');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'math-1ere' AND source = 'admin' AND id NOT IN ('bd1513be-6b46-50e6-bbfa-42ef1f57c47a', '46564e58-c1b5-56df-855a-b32f4b324bc7', '91c98fc7-83c2-51a0-8352-96c67b690c09', '10c40ca5-a980-5a5e-95f6-dd0da35ab853', '2af79c57-9878-55a9-9916-ea1e684b5ff1', '66dfa3cb-7b84-592c-8e51-e0b101dc67d8', '568728ff-4918-53cf-af71-e2bcdeb98334', 'e1df16c6-599c-5fc7-91f7-71b3bd7b14ed', 'ff9292ef-e3eb-5d2e-9c61-420f62ce29d3', '000cd276-dc9f-5582-bc07-9e9c1d13e851', 'ae5fd623-2293-5fe6-bf04-652d96db8a41', 'cab07cea-63fb-5795-bed0-9dcf4ef73f31', '6c3869f6-747f-5dc1-ac15-e99fdfdaa856', '9dbae826-4596-52e8-9e45-add93ece7de8', '515ce564-1173-5862-9f2e-88f6cebf7b15', 'f826f2ff-5797-51f8-9da2-7205aff0d1a5', '2b3258b2-7ea5-5ee5-845b-7903f133d11d', '97764cde-425e-5582-b1d9-a3d72759f407', 'e77514a3-1ea0-5959-9951-7491f6f779ac', '56b6cfdc-dc3c-5d91-944b-6ca52dc75a74', 'e54b06ba-fd20-54f7-a355-ce0cbf9e87dc', '62948b29-9db3-5aed-a9e8-59b8a7dd4011', '03d69f2a-a081-5827-a170-a344f3cc4147', 'c5e0120d-c64f-59ef-93fc-74b0ba1ff405', 'c999ed86-5b5b-5177-8960-975d80bb1405', 'e46796c9-0d82-59e8-a63f-82ba4c47f3eb', 'b3648f68-a3d2-553b-9d9f-970daf1b1fa8', '9661a9ce-6702-5eb7-a8db-fe0ad99ba5b5', 'daff76fa-0f67-533b-9a2e-9428448951b9', 'c3897011-5423-5afd-84e5-852746f6e8c3', '6f702fab-2003-5646-8347-d2999e1a5d15', 'ff384391-e7c4-5cdb-9b75-29f14391b398', '30300a83-349e-5060-9aef-91b8cd0e95db', 'e9ba10e7-a3d0-547e-af09-64a43f572758', 'b6ca11fb-228d-5718-bece-28e7b27ec720', '483858ac-78e6-510a-9806-afc2e24ce2ea', '05710129-dbdf-5746-b9ba-14c9ace5e47b', '68b5e6f3-0aa3-5b93-95cf-4865ba2d2856', '233463aa-98a1-5cef-aa92-31fd749f8940', '114daf53-74f1-5f08-81ed-cda81f3f7859', '414b6e21-f57e-5c5e-8121-2e405a8363fb', 'fe3e5a21-40d3-5b50-bcde-153b19eab088', '319e37ed-ef8f-5cfe-984e-63bc6aa907ab', '05d02cff-e594-5686-87e3-5ffa51aa8847', '41110ff6-a42d-50ea-8f73-9eb52104c886');
DELETE FROM public.questions WHERE exercise_id IN ('bd1513be-6b46-50e6-bbfa-42ef1f57c47a', '46564e58-c1b5-56df-855a-b32f4b324bc7', '91c98fc7-83c2-51a0-8352-96c67b690c09', '10c40ca5-a980-5a5e-95f6-dd0da35ab853', '2af79c57-9878-55a9-9916-ea1e684b5ff1', '66dfa3cb-7b84-592c-8e51-e0b101dc67d8', '568728ff-4918-53cf-af71-e2bcdeb98334', 'e1df16c6-599c-5fc7-91f7-71b3bd7b14ed', 'ff9292ef-e3eb-5d2e-9c61-420f62ce29d3', '000cd276-dc9f-5582-bc07-9e9c1d13e851', 'ae5fd623-2293-5fe6-bf04-652d96db8a41', 'cab07cea-63fb-5795-bed0-9dcf4ef73f31', '6c3869f6-747f-5dc1-ac15-e99fdfdaa856', '9dbae826-4596-52e8-9e45-add93ece7de8', '515ce564-1173-5862-9f2e-88f6cebf7b15', 'f826f2ff-5797-51f8-9da2-7205aff0d1a5', '2b3258b2-7ea5-5ee5-845b-7903f133d11d', '97764cde-425e-5582-b1d9-a3d72759f407', 'e77514a3-1ea0-5959-9951-7491f6f779ac', '56b6cfdc-dc3c-5d91-944b-6ca52dc75a74', 'e54b06ba-fd20-54f7-a355-ce0cbf9e87dc', '62948b29-9db3-5aed-a9e8-59b8a7dd4011', '03d69f2a-a081-5827-a170-a344f3cc4147', 'c5e0120d-c64f-59ef-93fc-74b0ba1ff405', 'c999ed86-5b5b-5177-8960-975d80bb1405', 'e46796c9-0d82-59e8-a63f-82ba4c47f3eb', 'b3648f68-a3d2-553b-9d9f-970daf1b1fa8', '9661a9ce-6702-5eb7-a8db-fe0ad99ba5b5', 'daff76fa-0f67-533b-9a2e-9428448951b9', 'c3897011-5423-5afd-84e5-852746f6e8c3', '6f702fab-2003-5646-8347-d2999e1a5d15', 'ff384391-e7c4-5cdb-9b75-29f14391b398', '30300a83-349e-5060-9aef-91b8cd0e95db', 'e9ba10e7-a3d0-547e-af09-64a43f572758', 'b6ca11fb-228d-5718-bece-28e7b27ec720', '483858ac-78e6-510a-9806-afc2e24ce2ea', '05710129-dbdf-5746-b9ba-14c9ace5e47b', '68b5e6f3-0aa3-5b93-95cf-4865ba2d2856', '233463aa-98a1-5cef-aa92-31fd749f8940', '114daf53-74f1-5f08-81ed-cda81f3f7859', '414b6e21-f57e-5c5e-8121-2e405a8363fb', 'fe3e5a21-40d3-5b50-bcde-153b19eab088', '319e37ed-ef8f-5cfe-984e-63bc6aa907ab', '05d02cff-e594-5686-87e3-5ffa51aa8847', '41110ff6-a42d-50ea-8f73-9eb52104c886') AND id NOT IN ('22bc1be9-2583-59f6-9313-9c6f101eec2f', 'e8b1ae2b-7b2f-5217-ac38-376fc22f5ad8', '1585e224-ecbf-5ced-9536-da6c29ec7fb3', 'd3066a32-5c2b-5c9b-b347-50a9b260df12', '64108a36-1a32-52bb-8ae8-a3ccb3652af8', 'a087aafb-c69d-585d-97c3-56271d8a48a6', 'ac0ceb82-56b2-5d4e-bf8d-602007ee5e55', 'b73ac76d-695b-5c14-9fa0-2f501eedc464', '1c9ffe8f-8129-545a-8669-735e33e24caa', '14d4b509-511f-5716-aba5-baad7bd31983', '71b39dd7-469b-5120-8e72-6e462db6f17f', 'd35b5636-94f9-5e7b-9bd6-b32414bd4d52', '92a41e6f-fdda-55a8-8ed3-a750d313b6c0', 'd662e1b7-0c5a-50a9-8a13-af31faf6623c', '377112bd-4ede-5b14-ad5a-158734dce1d4', '5d6dc786-aefd-5e06-8dbd-b3b3aba85100', 'b1a93572-5ad3-5eac-b608-5c44d40ff43c', '79165bf5-d403-5ee0-bb61-415501302204', 'fe4171ca-bcbf-5adf-9250-aa415e7d1ed8', '9e2e31e4-84ed-58cb-88c6-e308556fabbb', 'b9f9b894-3beb-5687-922d-0e1495bd812f', 'ea4bf596-c295-5095-afb5-a1b1a80b4629', 'e44d5b7b-66a4-5d13-ba12-00da4f0fde1c', '6b57bb64-57a9-5a41-b271-511dba252032', 'ffbc3aef-7acd-52c8-bade-17491d0b3f03', '495fd9c0-95fa-550e-9c47-2bb07e0c2abd', '6b32867e-d5d0-574a-8d2f-c25c803b56c3', '062d542a-f647-5025-9138-b3ef29b619f0', '906088ab-04a4-5cd2-9869-cf1057c25c8b', '20de4c9f-827c-5a14-9fd8-39e700372f9c', '65921bd0-bb97-5da8-8a53-e26dd3bff15c', '6359a174-80e5-56f8-bb27-41fe1bf486d0', 'dba1a28d-b391-59c0-9b3b-ba140bd04974', '61d31db6-a24b-5fde-89ad-96fe8009279d', '4e93f4b0-5cee-505a-b39b-a1129d3d78dc', '9c5b368b-1b91-5845-81f3-c9bfe7ae63b1', 'efb2f8b7-1b64-59aa-94c2-5ef8ee0d75a7', 'a15132a4-6ade-57f9-bd71-8dcffaff868a', '8e7b88bb-cd74-5780-b655-2ddd33a6fd94', '6817ab7b-4807-51cd-997a-54058567ce3c', 'af263e77-d14e-55c1-9fe9-7d6b41b7451d', 'dda0a4af-d061-5a87-8303-61d362260eaa', '2922137e-c2e3-58e7-8693-e6d803e77a99', '4a858ebd-eabb-50b4-8939-8fd36a6dec5f', 'eb0cbf45-dd30-50a1-a92d-6da781cefe87', 'fa7dbdf0-347b-548c-98a0-d9b7b230bd2c', '2ffdb7c6-d090-5c52-a887-57114178880a', '31c18015-043b-56f4-8668-ea467de9a8c4', 'd326095a-c43f-57fe-ac3b-7dd3a04417d4', '8540226d-914a-5bfe-ab00-2e72405f12e4', '73a2b0b6-8e5f-5995-ba97-cde9ea6c90aa', 'da2f2c56-a562-5df6-a3aa-0d8635b5bfc8', 'aa5e3851-8aa8-5854-beca-89ad71dda792', '001d9636-1cca-5405-8a5d-534e4e37d451', '8cc1bd67-7fea-5325-b0e3-0cb5d36313eb', 'bf9f07ce-b212-5212-ac03-29fab1bcbf81', 'a388d075-825c-5b3f-94f5-260e37a06f41', '459f2b38-a2fc-5dff-8350-14af044800e6', 'fac80caa-f1fb-57af-88bb-149e6617349d', 'e222f189-542b-5296-ae4c-fd5ca42446a8', '88d8dba7-d94a-5476-ad8d-a59dbc869e6c', '2c1c671c-e69d-5398-9b5b-31f134c7ee20', '783e5cc1-0909-5350-aeee-11e37109c50e', 'd46a2031-2e6c-5ac3-b3c0-58e2f6b8a617', '2c2732a5-ef61-52dc-bbc4-feb4728f559c', '3837c709-218f-5b07-8642-cc7a2623ba35', '297a18df-b730-5122-8416-3f2c6cf961b4', '90f97137-2f2c-55da-bbfa-3b6057f4b335', 'ac8c35c4-8620-525c-b02a-366bc1f5d691', '7aeb467a-2ff1-5378-98f7-f2cac24bdd0a', '82f55bbb-25d8-5863-8200-aa986a0534c3', 'f8428593-2179-5bba-af58-174df69839c4', '7cb42658-e019-5651-b74b-9a132464dfba', 'e4e05e71-e7b0-52f9-886d-08ac5ee1ebc0', '10f37e84-77f9-5e4c-9a3e-6633bbf8a2d2', '82fde5f3-362f-5acd-b512-6deb62ecdddd', '5e4a8793-eb42-5bd5-a913-cef3fba0d7f6', 'a15e23bf-c9e7-53b8-9d9b-6e9ba72a6a21', '5b090ea2-fc32-51bf-9fb4-d5b7b169b225', 'f78a1066-702e-5c6f-8a6e-79128959cf3b', 'd0cb6a14-200a-555b-a666-ec6c54b9bc50', '82594895-9ac1-5a9a-91f9-013db536a435', 'fbd4bb4e-d074-5049-b09b-8ad3d4f18a07', 'f9458b1d-6e21-5fdc-9169-62a2915a047e', 'b84b46ce-f1a7-5495-b6e0-5c59523cae95', 'bf299130-4e08-5f95-ac43-4814d35f8565', '51120502-1e21-57d9-99a7-b20f1044060d', 'b3c32f7f-fd1a-50a5-b14c-9ee5e2b526e0', 'bb37fdd4-767c-59ce-aa88-6bdaa4da3795', 'a7272737-c9ea-53c2-a162-d601aa55120e', 'b1023f58-22c6-5f7d-8b4b-d0065b4025aa', '4258f021-4230-5b31-9bda-af0a12c9686d', '20155c79-14e9-5204-a851-a397773420b7', '15b15ca9-de27-514e-866f-4dbe92db8551', 'aa5739ba-798d-5a5b-8753-e769b782af1d', '17c9e34e-1ccf-55e2-b1c7-17d723701c06', 'a6b46202-5216-58f7-aaee-06ab418899c6', '73d236c0-ec8a-56a5-a68c-385f7c3becde', 'b4e6f1a5-8e3e-50ad-93bc-7ff96a21d8da', '558d7fe4-4b6f-5c17-9845-28971f69844f', 'ee5c1c98-3ea0-57d9-9a12-cb45333de6ea', '32330e55-3c9f-55ed-b4c9-1dddb5b324e9', '30378330-c107-551b-bbed-de3b6a102ed4', '84f2065f-c2c0-5e63-8a44-0ba771a85daa', '3bb3f1e1-f549-52c9-b38b-67bb046df5f2', '71cfb666-ae83-50bf-a6b5-4a0a71524e85', 'c87a45b0-bfea-54e4-89ec-5ba81d64fc41', 'eb4e4eab-9f21-5091-b6f4-348868bc2b73', '25a16184-7c27-5dfe-b82e-fcb4d7ef0cde', '1a15eed5-8f6a-52fa-a745-dfe5b13ee93a', '49a52a15-0e77-5d0f-be4b-dbd11f39cb64', '9bd8e9d4-201e-5c10-97d9-c6fcb48a90d0', '585b34c2-575e-51f0-a108-d1cdb8222ee5', '1638861b-db67-5dfc-a946-9ef49daf4dfc', '79256cf2-ecbd-56b2-addb-2fbf64db9a04', '523582ee-9fcd-59f3-80f0-8caae92bfe83', 'f041760b-e838-5855-b11e-efe68a614bf3', 'b08af78c-5448-5fd4-b09a-f14fb4972bf9', 'd7a5be23-46e5-5bb2-950e-3b4cfd26201a', '65c7e7a1-6276-565b-bf75-0a10c0e331b4', '3b33511c-1bcd-532b-ba8b-0a217d54260f', '5a3d0ca7-a6bc-5d3a-b8b5-92e49376d8d4', '036b8c30-7ebf-59c5-a7d0-2938920233ea', '54dd9110-9e8f-52bb-9811-738f84d70e76', '24b16315-b429-556b-8bab-b6f108d7bce2', '2a501ec8-b0a9-5198-b56b-b9064f08e75c', '44456f5b-f0f7-54f3-9ee4-e68967233ae4', '3a27ac81-df7d-5485-969a-00929d5d1361', '214c2396-9825-5ea4-a155-4e4f6873c428', 'e11c09cc-f684-5507-b331-cf33829b4b0c', 'bcdae7ac-aedf-5f55-9cbf-92ce72bff640', '58e04c6d-bd69-5b60-8e80-0903eee2008e', 'b1cf10af-78e6-5d80-9894-26fbd0729d9b', '0298fab9-60e5-5b4f-80ac-5f82117802a7', 'ad7a24f6-aa42-57c3-830e-f32b1cfff937', '6b343783-6e05-527d-9ebf-ace568acaec8', '1d163f73-069b-52e5-b483-7b04cdc71d00', '236d31ad-9e59-55d6-ba71-4d5a48ef62ee', 'ad290fb8-1a41-5b8c-9994-1a19664ca7c2', 'baf24cba-a820-5220-88cc-d485b9335a9c', 'd5b375e8-c4b7-5e0f-b9b2-61272aa9cb97', '95c9839d-2a8f-52ac-9d17-1695964834f3', '29365060-83e3-59e0-81b9-378e9d61af99', 'e6127c6c-64ef-586b-b2fd-f09e4e6c6d12', '712d8311-7d86-5cf7-b085-d34c06711955', 'f9dbcf87-fa71-5038-8150-e81cff0c41f4', '50244701-7dc5-51b0-912a-893925bf227d', '0a9b3458-ae53-599a-965c-50349d34e597', 'c21d56e4-55a9-5657-aedf-39bdc20d3ceb', '8ad724e3-853d-5b80-a90a-3577acba26c5', 'e327d39c-d85c-5346-bbfa-bd83c5f0fee1', '42e88bd7-4298-5730-9ada-c7e81feb4adf', '8eb0056a-2f68-5659-ace5-52c3c1539389', '3469d23d-88b0-519b-a06c-577b84bc3fba', '16dd707b-b85b-5b4c-9a1f-b1865f47cf24', '0b30c329-dd4f-50eb-a58c-48b235420954', '2ddfb6aa-fe77-5138-ab94-cdba048833e0', '31516993-ac7d-5c36-b2a8-832d0f74dca0', '7c295116-6718-5a84-b050-94eec0aa3a0a', '73bcfe58-1630-513f-beee-478cf44f395f', '21dfd92c-41d5-5f3d-b078-ea3ee660602d', '94954b82-ff17-5040-88ea-26fb986959b1', '8c1028bf-3751-5191-ba05-1b761e865a00', '9c3747af-087a-5c4f-b21a-a76dc8aef922', '4d71db59-9f5a-577c-88eb-80ff438c4663', '47214a38-e287-5766-873a-ac45f4385942', '98f2bbdd-8345-565d-9f28-954ebe69cbbb', '107f4cf2-6dc2-54c0-82fb-e18dd522be77', '25b763c8-45fd-506e-a169-250527a6fc3a', '4f41d0cc-f870-53e4-96e5-b4793f4f1a0f', '7af74aa9-2a42-5d2a-971f-8eb9cba7a565', '780ba838-fda6-5e99-8f1f-184f663ada94', '0a930397-f8d4-589a-89f6-9716075e5eab', '3267f7ee-e587-5837-8635-7947c3c177f9', 'a3d2680d-e3b0-549a-987a-cb07b794a161', '6ea55610-d391-53be-9232-9eada63ddc4c', 'ca6cf9be-9579-55c5-8689-e58bcc0dc5aa', 'ff790735-270e-51f6-9edb-19d59cbedfe3', '33855e7c-a22e-5b0e-b8e8-303a41fab514', '8f008999-8932-5f65-a18f-76a37a1b932e', 'f05c1420-1910-5417-97e2-0dbe2115145e', 'a48c8c76-c8e5-541d-9c62-a58841e5d819', '85fecd91-1ca1-5861-a447-6c79af01d3cb', 'e1d002ed-36d9-55ab-bca2-4ea0cd62dc0a', 'a404a87b-ebde-55cd-a300-44ff03ae8091', 'acd19ce3-e01a-511b-8e45-0310729866f3', '81458cd3-26ba-56b6-9b66-e7b4fb4f4dc1', 'e81a6e90-c680-5f88-8b01-b09ccdb0bb5d', '0b8d987d-c39c-5618-ad43-1632322a40d2', '7b625a66-7035-5e4f-93e5-03d0f920a18c', '3e821524-94d3-5f9a-9769-18c2e2d89270', '4ec23861-02da-5501-a72c-e2cd756592e4', 'f17793c6-cc59-5f81-83ab-5368d3e4259b', '40d82f98-5706-52e0-9acc-53d0beacef72', 'f55e537c-688f-59c8-9756-a6356a7258bd', '938296c0-b318-5d24-8777-9ccf8877170f', '0a659fb4-d0f3-5cb6-8f72-fac3277bab51', 'a4340fb8-42d0-5fa7-a0fd-d245209ee1a3', '8031f090-3d59-56d9-bc6d-d62dec4b20f6', 'ae26e2e9-7ff5-5856-acda-d90e1f37d8ab', 'c8cbb611-2d0f-53ff-91da-10654a7d92ed', 'ad707bfe-a04c-54e4-ab53-bf631ffc148e', '0e613076-a519-5f55-bf80-28b2e61206a3', '1f7cd46f-b943-5030-a154-9b5b282861d4', 'd49afe62-31b1-5e08-a3fd-6b5645e68208', 'b6d53087-0db8-52f4-9726-4e47f8bdb808', '822bef85-9698-51ab-991f-544dba5097fb', 'e4e635b7-158b-5fe6-9a0c-49cf19401c9d', '761c5ce8-1dee-59f2-b273-2d8b51489fd5', '54780662-1c11-5af1-9245-8c0bc9e7029b', '57c1f07c-857a-538f-ab92-dfd8a6bace8e', 'eeaeaafd-4589-5374-909a-27f375ac998b', '317515c6-e897-5eb5-a00b-ca64085b1b81', '6610461e-5650-5cf7-b199-a8bb34408cc2', '10ea2e88-f7e7-596a-8178-46b2dcd6057d', 'd0528ac2-122b-5c70-bd24-b483f7bf93b3', '2e34135d-2a32-5fff-b178-e0b05c4690d0', '6921550d-4aec-5766-bdbc-b731b9f62a2f', 'bd8cb2ab-b6dc-53f9-9511-c5bef7a9afd4', '0a629f5e-a9e7-54fa-a817-f4b0df79653e', 'b4e94c9f-6351-5579-b04a-94eb1c60719d', 'b163e575-36dc-54c0-8277-ed79cccfc818', '25fc2c23-562d-5670-9003-2b59c84eecfa', '13d14a0a-be0f-5681-915a-5982fb7e0043', '196a7740-e602-5334-8d04-c1a35d50e9bb', 'cb6ad8ff-b716-5944-85b3-29e1dda0cc8f', '1271ca7e-d044-5832-8b2d-f5ebc4baf771', 'ab9d8eeb-d6bf-5c6b-bc75-a4ee1a4bd88b', '88f81ec7-a9e8-546d-a269-d1dbff37988b', 'a346e635-4a08-5fbe-977b-8e1eb7becf74', '7667fc44-0053-5465-b222-5e250dd6d151', '657c3cad-54f3-5b84-b47f-b5671ada015b', 'fe5018c7-1549-54da-b69d-75709bc701a0', '38973286-cfbb-5412-94ce-bcfa3beefc4f', '00aea2ff-f589-5546-aa82-9c520958e7bd', '0f79b8ae-d296-5598-be7a-2d036fbd409f', '828a7ef0-eec4-5e78-8dc9-9ec722bdf1ab', '5bbab080-cb30-5098-aa91-55c9ebbe190c', 'd21763cc-2b22-5328-8187-379282479f50', '48152f8d-0746-5301-9a00-023d6102be87', '52d2cfb0-2bbc-5ee2-8291-b59ea666195e', '68f60f29-037b-5f02-a008-f199b7681422', '3f6be308-ae5d-55b2-bec6-bf7ec01ca9cc', '60d28e3d-2db2-5040-a9d3-4b0441bcc280', 'b4f4f774-745c-5995-96db-95a149207b39', 'bbaaae38-2cb3-5908-8bfb-fbf1906e4f98', '1ced8c76-f97b-572b-9591-3fe269277028', 'bb954a72-de8c-5adc-842c-9791c95c7f84', 'c480088c-872b-5aea-98fe-d561153ea836', '09a51142-6ae5-5691-82a0-35fae3413d70', '0aa1c485-16a8-5cd6-88bd-40619c7645e1', 'dcf7d2a0-2a72-518d-a6e2-62176e3d4788', '91081dad-89b7-546e-a814-17914e20f367', 'd61d4f2e-6cc3-59f6-95e6-62489ea43801', '798001d9-de2f-5304-8dbf-af2c92051a2c', '02148af8-f7e8-5e5d-ae98-cfe38749084d', 'aa455f9a-a0ba-5bb6-82eb-4d83de3a3fe5', '4ad3dd38-a71a-57dd-8713-7b9e2be897ec', 'ef3a3a5c-c0eb-5614-b38e-188b9480e7b1', '9c5d925f-8ddb-5b8d-97dd-67ec37f8f98c', 'd5f07ccd-ba36-5b7b-8a93-a290e3a15e6a');
DELETE FROM public.chapters c WHERE c.subject_id = 'math-1ere' AND c.id NOT IN ('9be0e6a9-f498-597f-9f20-fc8b09f0d0e8', 'c208be46-7f36-50f9-9459-4abf870c515e', 'c5963a75-8dce-5605-8fab-28148d2d5745', '9be4e72b-e0d9-5b6c-a6eb-4e70460d7b7f', '11fdddcd-6630-5b51-9ecd-b4bb22614bb1', 'c7ca9bbe-5553-5e50-b49c-51d09d3b52a0', '9387dc67-fc94-5be6-bc3b-fb8ba75c3b4c', '0dd45e0c-5ec2-52bc-b7ea-97b104cb98ee', 'd24bb485-faf9-5d35-b3f7-7067c0990995') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('9be0e6a9-f498-597f-9f20-fc8b09f0d0e8', 'math-1ere', 'الأعداد من 0 إلى 9', 'قراءة وكتابة الأعداد من 0 إلى 9، العدّ، التعبير عن الكمّيّات، العدد الذي يلي والعدد الذي يسبق', '# ⚔️ الأعداد من 0 إلى 9 — أوّل خطوة للبطل الصغير

> 💡 «من يعرف العدّ إلى 9 يفتح باب عالَم الأرقام كلّه.»

أهلًا بك أيّها البطل الصغير! في هذه البوّابة الأولى نتعلّم الأعداد من **0 إلى 9**. هذه الأعداد هي أدوات سحريّة نَعُدّ بها الأشياء من حولنا.

## 🍎 نَعُدّ الأشياء

عندما ننظر إلى مجموعة من الأشياء، نَعُدّ واحدًا واحدًا: **1، 2، 3، …**

- تفّاحة واحدة ⟸ العدد **1**.
- ثلاث نجمات ⟸ العدد **3**.
- خمسة كرات ⟸ العدد **5**.

::: figure نَعُدّ واحدًا واحدًا: تفّاحة واحدة، ثلاث نجمات، خمس كرات
<svg viewBox="0 0 340 150"><path d="M45 32 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M45 33 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M45 27 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><text x="45" y="92" text-anchor="middle" font-size="20" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">1</text><polygon points="120.0,24.0 124.2,34.2 135.2,35.1 126.8,42.2 129.4,52.9 120.0,47.2 110.6,52.9 113.2,42.2 104.8,35.1 115.8,34.2" fill="#fbbf24" stroke="#1f2937" stroke-width="2.2" stroke-linejoin="round"/><polygon points="155.0,24.0 159.2,34.2 170.2,35.1 161.8,42.2 164.4,52.9 155.0,47.2 145.6,52.9 148.2,42.2 139.8,35.1 150.8,34.2" fill="#fbbf24" stroke="#1f2937" stroke-width="2.2" stroke-linejoin="round"/><polygon points="190.0,24.0 194.2,34.2 205.2,35.1 196.8,42.2 199.4,52.9 190.0,47.2 180.6,52.9 183.2,42.2 174.8,35.1 185.8,34.2" fill="#fbbf24" stroke="#1f2937" stroke-width="2.2" stroke-linejoin="round"/><text x="155" y="92" text-anchor="middle" font-size="20" font-weight="700" fill="#a16207" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><circle cx="245" cy="40" r="13" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M235 36 q10 -7 20 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="275" cy="40" r="13" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M265 36 q10 -7 20 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="305" cy="40" r="13" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M295 36 q10 -7 20 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="260" cy="68" r="13" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M250 64 q10 -7 20 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="290" cy="68" r="13" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M280 64 q10 -7 20 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><text x="275" y="118" text-anchor="middle" font-size="20" font-weight="700" fill="#1d4ed8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text></svg>
:::

> 🗡️ نَعُدّ ببطء ونُشير إلى كلّ شيء مرّة واحدة فقط، حتّى لا نَعُدّ الشيء مرّتين.

## 🔢 نقرأ ونكتب الأعداد

لكلّ عدد شكلٌ نكتبه به واسمٌ نقرأه به:

| العدد | نقرأه  |
| ----- | ------ |
| 0     | صفر    |
| 1     | واحد   |
| 2     | اثنان  |
| 3     | ثلاثة  |
| 4     | أربعة  |
| 5     | خمسة   |
| 6     | ستّة   |
| 7     | سبعة   |
| 8     | ثمانية |
| 9     | تسعة   |

## 0️⃣ العدد صفر

العدد **0** يعني **لا شيء**.

- صحنٌ فارغٌ فيه **0** تفّاحة.
- صفر هو **أصغر** عدد نتعلّمه اليوم.

::: figure الصحن الأيمن فارغ: فيه 0 تفّاحة — الصفر يعني لا شيء
<svg viewBox="0 0 260 140"><path d="M62 33 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M62 34 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M62 28 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><path d="M96 33 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M96 34 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M96 28 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><path d="M79 61 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M79 62 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M79 56 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><ellipse cx="79" cy="104" rx="52" ry="13" fill="#e2e8f0" stroke="#1f2937" stroke-width="2.5"/><text x="79" y="133" text-anchor="middle" font-size="18" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><ellipse cx="196" cy="104" rx="52" ry="13" fill="#e2e8f0" stroke="#1f2937" stroke-width="2.5"/><text x="196" y="60" text-anchor="middle" font-size="13" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">لا شيء</text><text x="196" y="133" text-anchor="middle" font-size="18" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">0</text></svg>
:::

## ➡️ العدد الذي يلي والعدد الذي يسبق

الأعداد تأتي بترتيب: 0، 1، 2، 3، 4، 5، 6، 7، 8، 9.

- العدد الذي **يلي** عددًا هو العدد الذي يأتي بعده مباشرة: بعد 4 يأتي **5**.
- العدد الذي **يسبق** عددًا هو الذي يأتي قبله مباشرة: قبل 7 يأتي **6**.

::: figure بعد 4 يأتي 5 (يلي)، وقبل 7 يأتي 6 (يسبق)
<svg viewBox="0 0 360 120"><rect x="18" y="42" width="30" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="33.0" y="66" text-anchor="middle" font-size="15" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">0</text><rect x="51" y="42" width="30" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="66.0" y="66" text-anchor="middle" font-size="15" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">1</text><rect x="84" y="42" width="30" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="99.0" y="66" text-anchor="middle" font-size="15" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text><rect x="117" y="42" width="30" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="132.0" y="66" text-anchor="middle" font-size="15" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><rect x="150" y="42" width="30" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="165.0" y="66" text-anchor="middle" font-size="15" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4</text><rect x="183" y="42" width="30" height="34" rx="4" fill="#bbf7d0" stroke="#1f2937" stroke-width="2"/><text x="198.0" y="66" text-anchor="middle" font-size="15" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><rect x="216" y="42" width="30" height="34" rx="4" fill="#fed7aa" stroke="#1f2937" stroke-width="2"/><text x="231.0" y="66" text-anchor="middle" font-size="15" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">6</text><rect x="249" y="42" width="30" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="264.0" y="66" text-anchor="middle" font-size="15" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">7</text><rect x="282" y="42" width="30" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="297.0" y="66" text-anchor="middle" font-size="15" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">8</text><rect x="315" y="42" width="30" height="34" rx="4" fill="#ffffff" stroke="#1f2937" stroke-width="2"/><text x="330.0" y="66" text-anchor="middle" font-size="15" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">9</text><path d="M150 36 q16 -18 32 0" fill="none" stroke="#16a34a" stroke-width="2.5"/><path d="M182 36 l-7 -6 l9 -3 z" fill="#16a34a"/><text x="166" y="24" text-anchor="middle" font-size="13" font-weight="700" fill="#16a34a" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">يلي</text><path d="M248 82 q-16 18 -32 0" fill="none" stroke="#ea580c" stroke-width="2.5"/><path d="M216 82 l7 6 l-9 3 z" fill="#ea580c"/><text x="232" y="108" text-anchor="middle" font-size="13" font-weight="700" fill="#ea580c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">يسبق</text></svg>
:::

> ⚠️ احذر! العدد الذي يلي يكون **أكبر** بواحد، والعدد الذي يسبق يكون **أصغر** بواحد.

## 📊 الأكبر والأصغر

كلّما تقدّمنا في العدّ صار العدد **أكبر**:

- **9** هو أكبر عدد في هذه البوّابة.
- **0** هو أصغر عدد.

نقارن: 8 أكبر من 3، و 2 أصغر من 6.

> 🏆 رائع! صرت تعرف الأعداد من 0 إلى 9، تَعُدّ بها وتقرأها وتكتبها وتعرف ما يليها وما يسبقها. استعدّ للبوّابة الموالية حيث نَعُدّ إلى 99!', '# 📜 ملخّص: الأعداد من 0 إلى 9

- **نَعُدّ الأشياء** واحدًا واحدًا: 1، 2، 3، … ونُشير إلى كلّ شيء مرّة واحدة فقط.
- **الأعداد من 0 إلى 9** هي: 0، 1، 2، 3، 4، 5، 6، 7، 8، 9.
- **العدد 0** يعني لا شيء، وهو أصغر عدد.
- **نقرأ ونكتب** كلّ عدد: 1 واحد، 2 اثنان، 3 ثلاثة، … 9 تسعة.
- **العدد الذي يلي** يأتي بعده مباشرة وهو أكبر بواحد: بعد 4 يأتي 5.
- **العدد الذي يسبق** يأتي قبله مباشرة وهو أصغر بواحد: قبل 7 يأتي 6.
- **9 هو الأكبر** و **0 هو الأصغر** في هذه الأعداد.
- نقارن الأعداد: 8 أكبر من 3، و 2 أصغر من 6.', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('c208be46-7f36-50f9-9459-4abf870c515e', 'math-1ere', 'الأعداد إلى 99', 'العشرات والآحاد، قراءة وكتابة الأعداد إلى 99، تكوين العشرة، تفكيك عدد إلى عشرات وآحاد', '# ⚔️ الأعداد إلى 99 — عالَم العشرات

> 💡 «عشرُ آحادٍ تصنع عشرةً واحدة: هذا سرّ الأعداد الكبيرة!»

أحسنت أيّها البطل! تعلّمت العدّ إلى 9، واليوم نفتح بوّابة أكبر: الأعداد إلى **99**. السرّ هو **العشرة**.

## 🔟 ما هي العشرة؟

عندما نجمع **10 آحاد** معًا تصير **عشرة واحدة**.

- 10 أقلام = **عشرة** واحدة من الأقلام (حزمة واحدة).
- نَعُدّ بالعشرات: 10، 20، 30، 40، 50، 60، 70، 80، 90.

::: figure عشرة أقلام مربوطة معًا تصير حزمة واحدة: عشرة
<svg viewBox="0 0 350 120"><rect x="18" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M18 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M21.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="33" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M33 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M36.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="48" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M48 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M51.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="63" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M63 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M66.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="78" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M78 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M81.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="93" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M93 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M96.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="108" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M108 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M111.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="123" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M123 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M126.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="138" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M138 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M141.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="153" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M153 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M156.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><text x="90" y="108" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">10 آحاد</text><text x="185" y="62" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">=</text><rect x="228.0" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M228.0 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M231.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="233.5" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M233.5 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M237.0 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="239.0" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M239.0 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M242.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="244.5" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M244.5 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M248.0 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="250.0" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M250.0 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M253.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="255.5" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M255.5 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M259.0 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="261.0" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M261.0 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M264.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="266.5" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M266.5 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M270.0 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="272.0" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M272.0 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M275.5 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="277.5" y="24" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M277.5 68 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M281.0 73.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="222" y="38" width="66" height="16" rx="3" fill="#ef4444" opacity="0.85" stroke="#1f2937" stroke-width="2"/><text x="255" y="108" text-anchor="middle" font-size="13" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">عشرة واحدة (حزمة)</text></svg>
:::

> 🗡️ نَجمع الآحاد في حُزَمٍ من 10 لِيَسهُل العدّ، تمامًا كما نَجمع الأقلام في علبة.

## 🧮 العشرات والآحاد

كلّ عددٍ إلى 99 له **رقم العشرات** و **رقم الآحاد**.

| العدد | العشرات | الآحاد |
| ----- | ------- | ------ |
| 34    | 3       | 4      |
| 50    | 5       | 0      |
| 7     | 0       | 7      |

في العدد 34: الرقم 3 يعني **3 عشرات** (أي 30)، والرقم 4 يعني **4 آحاد**.

::: figure العدد 34: ثلاث حزم (3 عشرات) وأربعة أقلام مفردة (4 آحاد)
<svg viewBox="0 0 350 130"><rect x="24.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M24.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M27.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="29.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M29.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M33.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="35.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M35.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M38.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="40.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M40.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M44.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="46.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M46.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M49.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="51.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M51.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M55.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="57.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M57.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M60.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="62.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M62.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M66.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="68.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M68.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M71.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="73.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M73.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M77.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="18" y="42" width="66" height="16" rx="3" fill="#ef4444" opacity="0.85" stroke="#1f2937" stroke-width="2"/><rect x="86.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M86.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M89.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="91.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M91.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M95.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="97.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M97.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M100.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="102.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M102.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M106.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="108.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M108.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M111.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="113.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M113.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M117.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="119.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M119.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M122.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="124.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M124.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M128.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="130.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M130.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M133.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="135.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M135.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M139.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="80" y="42" width="66" height="16" rx="3" fill="#ef4444" opacity="0.85" stroke="#1f2937" stroke-width="2"/><rect x="148.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M148.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M151.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="153.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M153.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M157.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="159.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M159.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M162.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="164.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M164.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M168.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="170.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M170.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M173.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="175.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M175.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M179.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="181.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M181.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M184.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="186.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M186.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M190.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="192.0" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M192.0 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M195.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="197.5" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M197.5 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M201.0 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="142" y="42" width="66" height="16" rx="3" fill="#ef4444" opacity="0.85" stroke="#1f2937" stroke-width="2"/><text x="105" y="118" text-anchor="middle" font-size="13" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3 عشرات</text><rect x="228" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M228 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M231.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="243" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M243 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M246.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="258" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M258 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M261.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><rect x="273" y="28" width="11" height="44" rx="1.5" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M273 72 l5.5 9 l5.5 -9 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/><path d="M276.5 77.5 l2 3.5 l2 -3.5 z" fill="#1f2937"/><text x="258" y="118" text-anchor="middle" font-size="13" font-weight="700" fill="#a16207" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4 آحاد</text><text x="320" y="66" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">34</text></svg>
:::

## 🔮 نقرأ ونكتب الأعداد

نقرأ العشرات أوّلًا ثمّ الآحاد:

- 25 نقرأه «خمسة وعشرون».
- 40 نقرأه «أربعون».
- 63 نقرأه «ثلاثة وستّون».

> ⚠️ احذر الخلط! العدد 52 ليس 25. في 52 خمس عشرات، وفي 25 خمسة آحاد فقط.

## ⚡ تفكيك عدد

تفكيك العدد يعني فصل عشراته عن آحاده:

- 47 = **40 + 7** (أربع عشرات وسبع آحاد).
- 80 = **80 + 0** (ثماني عشرات ولا آحاد).

## 📊 الأكبر والأصغر

لمقارنة عددين إلى 99:

1. ننظر أوّلًا إلى **العشرات**: الأكثر عشراتٍ هو الأكبر.
2. إذا تساوت العشرات ننظر إلى **الآحاد**.

مثال: 38 أكبر من 25 (3 عشرات أكثر من 2). و 46 أكبر من 43 (تساوت العشرات، و 6 أكبر من 3).

> 🏆 ممتاز! صرت تعرف العشرات والآحاد، وتقرأ وتكتب وتفكّك وتقارن كلّ عددٍ إلى 99. استعدّ لبوّابة المقارنة والترتيب!', '# 📜 ملخّص: الأعداد إلى 99

- **العشرة** هي 10 آحاد مجموعة معًا: 10، 20، 30، … 90.
- **كلّ عدد إلى 99** له رقم عشرات ورقم آحاد.
- في العدد 34: الرقم 3 يعني 3 عشرات (30)، والرقم 4 يعني 4 آحاد.
- **نقرأ** العشرات ثمّ الآحاد: 25 «خمسة وعشرون»، 63 «ثلاثة وستّون».
- **نُفكّك** العدد إلى عشرات وآحاد: 47 = 40 + 7.
- **احذر الخلط**: 52 ليس 25؛ في 52 خمس عشرات.
- **للمقارنة**: ننظر إلى العشرات أوّلًا، فإن تساوت ننظر إلى الآحاد.
- مثال: 38 أكبر من 25، و 46 أكبر من 43.', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('c5963a75-8dce-5605-8fab-28148d2d5745', 'math-1ere', 'المقارنة والترتيب', 'مقارنة الأعداد إلى 99 باستعمال الرموز >، <، =، والترتيب التصاعدي والتنازلي', '# ⚔️ المقارنة والترتيب — معركة الأعداد

> 💡 «الرمز > كفمٍ جائعٍ يفتح فاه دائمًا نحو العدد الأكبر!»

أيّها البطل، تعلّمت العدّ إلى 99. الآن نتعلّم **مقارنة** الأعداد لنعرف أيُّها أكبر، ثمّ **نرتّبها**.

## ⚖️ الرموز الثلاثة

نستعمل ثلاثة رموز سحريّة للمقارنة:

| الرمز | معناه   |
| ----- | ------- |
| >     | أكبر من |
| <     | أصغر من |
| =     | يساوي   |

- 8 > 5 نقرأها «8 أكبر من 5».
- 3 < 7 نقرأها «3 أصغر من 7».
- 6 = 6 نقرأها «6 يساوي 6».

## 🐊 سرّ الفم الجائع

الرمز > أو < يشبه **فمًا جائعًا** يفتح فاه دائمًا نحو العدد **الأكبر** (الوجبة الأكبر!).

- في 9 > 4 الفم مفتوح نحو 9 (الأكبر).
- في 2 < 8 الفم مفتوح نحو 8 (الأكبر).

::: figure الفم الجائع يفتح فاه دائمًا نحو العدد الأكبر: 9 > 4
<svg viewBox="0 0 320 150"><text x="42" y="88" text-anchor="middle" font-size="34" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">9</text><text x="278" y="88" text-anchor="middle" font-size="34" font-weight="700" fill="#1d4ed8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4</text><path d="M108 34 L196 72 L108 62 Z" fill="#22c55e" stroke="#1f2937" stroke-width="2.5" stroke-linejoin="round"/><path d="M108 118 L196 80 L108 90 Z" fill="#16a34a" stroke="#1f2937" stroke-width="2.5" stroke-linejoin="round"/><circle cx="176" cy="66" r="4" fill="#1f2937"/><g fill="#ffffff" stroke="#1f2937" stroke-width="1.2"><path d="M120 42 l7 11 l7 -8 z"/><path d="M140 51 l7 10 l7 -7 z"/><path d="M120 110 l7 -11 l7 8 z"/><path d="M140 101 l7 -10 l7 7 z"/></g><text x="152" y="142" text-anchor="middle" font-size="13" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">الفم يفتح نحو الأكبر</text></svg>
:::

> 🗡️ تذكّر: الطرف المدبّب (الصغير) يشير دائمًا إلى العدد الأصغر.

## 🧮 كيف نقارن عددين إلى 99؟

ننظر أوّلًا إلى **العشرات**:

- الأكثر عشراتٍ هو الأكبر: 52 > 38 لأنّ 5 عشرات أكثر من 3 عشرات.
- إذا تساوت العشرات ننظر إلى **الآحاد**: 47 > 43 لأنّ الآحاد 7 أكبر من 3.

> ⚠️ الفخّ الشائع: الظنّ أنّ 19 أكبر من 21 لأنّ فيه الرقم 9. الصواب أنّنا نقارن العشرات أوّلًا: 2 عشرات أكثر من 1 عشرة، إذن 21 > 19.

## 📈 الترتيب التصاعدي

نرتّب **تصاعديًّا** من **الأصغر إلى الأكبر**:

- الأعداد 7، 3، 9 تصير: 3، 7، 9.

## 📉 الترتيب التنازلي

نرتّب **تنازليًّا** من **الأكبر إلى الأصغر**:

- الأعداد 4، 8، 2 تصير: 8، 4، 2.

::: figure تصاعديًّا نصعد من الأصغر إلى الأكبر، وتنازليًّا ننزل من الأكبر إلى الأصغر
<svg viewBox="0 0 340 140"><rect x="22" y="75" width="24" height="27" rx="3" fill="#22c55e" stroke="#1f2937" stroke-width="2"/><text x="34" y="118" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><rect x="52" y="39" width="24" height="63" rx="3" fill="#22c55e" stroke="#1f2937" stroke-width="2"/><text x="64" y="118" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">7</text><rect x="82" y="21" width="24" height="81" rx="3" fill="#22c55e" stroke="#1f2937" stroke-width="2"/><text x="94" y="118" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">9</text><path d="M18 128 L112 128" stroke="#16a34a" stroke-width="2.5"/><path d="M112 128 l-8 -4 l0 8 z" fill="#16a34a"/><text x="66" y="22" text-anchor="middle" font-size="14" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">تصاعدي</text><rect x="212" y="30" width="24" height="72" rx="3" fill="#fb923c" stroke="#1f2937" stroke-width="2"/><text x="224" y="118" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">8</text><rect x="242" y="66" width="24" height="36" rx="3" fill="#fb923c" stroke="#1f2937" stroke-width="2"/><text x="254" y="118" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">4</text><rect x="272" y="84" width="24" height="18" rx="3" fill="#fb923c" stroke="#1f2937" stroke-width="2"/><text x="284" y="118" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text><path d="M208 128 L302 128" stroke="#ea580c" stroke-width="2.5"/><path d="M302 128 l-8 -4 l0 8 z" fill="#ea580c"/><text x="256" y="22" text-anchor="middle" font-size="14" font-weight="700" fill="#c2410c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">تنازلي</text></svg>
:::

> 🏆 رائع! صرت تقارن الأعداد بالرموز >، <، =، وترتّبها تصاعديًّا وتنازليًّا. استعدّ الآن لبوّابة الجمع!', '# 📜 ملخّص: المقارنة والترتيب

- **الرموز الثلاثة**: > (أكبر من)، < (أصغر من)، = (يساوي).
- 8 > 5، و 3 < 7، و 6 = 6.
- **سرّ الفم الجائع**: الرمز > أو < يفتح فاه نحو العدد الأكبر، وطرفه المدبّب نحو الأصغر.
- **لمقارنة عددين**: ننظر إلى العشرات أوّلًا؛ الأكثر عشراتٍ هو الأكبر.
- إذا تساوت العشرات ننظر إلى الآحاد: 47 > 43.
- **احذر الفخّ**: 21 > 19 لأنّ العشرات تُقارَن أوّلًا.
- **الترتيب التصاعدي**: من الأصغر إلى الأكبر (3 ; 7 ; 9).
- **الترتيب التنازلي**: من الأكبر إلى الأصغر (8 ; 4 ; 2).', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('9be4e72b-e0d9-5b6c-a6eb-4e70460d7b7f', 'math-1ere', 'الجمع', 'الجمع في حدود 99 بدون احتفاظ، معنى الجمع وعلامة +، الجمع بالعدّ التصاعدي', '# ⚔️ الجمع — قوّة الزيادة

> 💡 «الجمع يكبّر العدد دائمًا: نضمّ مجموعتين فتصير مجموعة واحدة أكبر!»

أيّها البطل، تعلّمت العدّ والمقارنة. الآن نتعلّم **الجمع**: أن نضمّ الأشياء معًا ونعرف كم صارت.

## ➕ ما معنى الجمع؟

الجمع يعني **أن نضمّ** مجموعتين معًا ونَعُدّ الكلّ.

- عندي 3 تفّاحات وأخذت 2 أخرى: 3 + 2 = **5**.
- نقرأ 3 + 2 = 5 «ثلاثة زائد اثنين يساوي خمسة».

::: figure نضمّ 3 تفّاحات و2 تفّاحات فنَعُدّ 5
<svg viewBox="0 0 350 130"><path d="M30 27 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M30 28 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M30 22 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><path d="M64 27 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M64 28 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M64 22 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><path d="M47 57 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M47 58 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M47 52 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><text x="47" y="112" text-anchor="middle" font-size="18" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">3</text><text x="103" y="60" text-anchor="middle" font-size="26" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">+</text><path d="M140 27 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M140 28 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M140 22 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><path d="M174 27 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M174 28 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M174 22 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><text x="157" y="112" text-anchor="middle" font-size="18" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text><text x="213" y="60" text-anchor="middle" font-size="26" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">=</text><path d="M250 21 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M250 22 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M250 16 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><path d="M284 21 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M284 22 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M284 16 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><path d="M318 21 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M318 22 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M318 16 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><path d="M267 53 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M267 54 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M267 48 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><path d="M301 53 q-17 -3 -17 14 q0 17 17 17 q17 0 17 -17 q0 -14 -17 -14 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M301 54 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M301 48 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><text x="284" y="112" text-anchor="middle" font-size="20" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text></svg>
:::

علامة الجمع هي **+** (زائد)، ونتيجة الجمع تُسمّى **المجموع**.

## 🔢 الجمع بالعدّ التصاعدي

نبدأ من العدد الأوّل ونَعُدّ تصاعديًّا بعدد المضاف:

- 6 + 3: نبدأ من 6 ثمّ نَعُدّ 3: 7، 8، 9. إذن 6 + 3 = **9**.

> 🗡️ خدعة البطل: نبدأ دائمًا بالعدد **الأكبر** ونَعُدّ الأصغر، فالعدّ أسرع. 2 + 7 = 7 + 2.

## 🔄 ترتيب الجمع لا يغيّر النتيجة

يمكن قلب العددين دون أن تتغيّر النتيجة:

- 4 + 5 = 9، و 5 + 4 = 9 أيضًا.

::: figure نقلب العددين فلا تتغيّر النتيجة: 4 + 5 = 5 + 4
<svg viewBox="0 0 340 120"><circle cx="24" cy="34" r="11" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M16 30 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="50" cy="34" r="11" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M42 30 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="76" cy="34" r="11" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M68 30 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="102" cy="34" r="11" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M94 30 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><text x="124" y="40" text-anchor="middle" font-size="18" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">+</text><circle cx="146" cy="34" r="11" fill="#f472b6" stroke="#1f2937" stroke-width="2.5"/><path d="M138 30 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="172" cy="34" r="11" fill="#f472b6" stroke="#1f2937" stroke-width="2.5"/><path d="M164 30 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="198" cy="34" r="11" fill="#f472b6" stroke="#1f2937" stroke-width="2.5"/><path d="M190 30 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="224" cy="34" r="11" fill="#f472b6" stroke="#1f2937" stroke-width="2.5"/><path d="M216 30 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="250" cy="34" r="11" fill="#f472b6" stroke="#1f2937" stroke-width="2.5"/><path d="M242 30 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><text x="300" y="40" text-anchor="middle" font-size="19" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">= 9</text><circle cx="24" cy="84" r="11" fill="#f472b6" stroke="#1f2937" stroke-width="2.5"/><path d="M16 80 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="50" cy="84" r="11" fill="#f472b6" stroke="#1f2937" stroke-width="2.5"/><path d="M42 80 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="76" cy="84" r="11" fill="#f472b6" stroke="#1f2937" stroke-width="2.5"/><path d="M68 80 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="102" cy="84" r="11" fill="#f472b6" stroke="#1f2937" stroke-width="2.5"/><path d="M94 80 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="128" cy="84" r="11" fill="#f472b6" stroke="#1f2937" stroke-width="2.5"/><path d="M120 80 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><text x="152" y="90" text-anchor="middle" font-size="18" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">+</text><circle cx="174" cy="84" r="11" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M166 80 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="200" cy="84" r="11" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M192 80 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="226" cy="84" r="11" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M218 80 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="252" cy="84" r="11" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M244 80 q8 -7 16 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><text x="300" y="90" text-anchor="middle" font-size="19" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">= 9</text></svg>
:::

والعدد **0** لا يغيّر شيئًا في الجمع: 8 + 0 = 8.

## 🧮 الجمع بدون احتفاظ (العشرات والآحاد)

نجمع الآحاد مع الآحاد، والعشرات مع العشرات:

$$24 + 13 = 37$$

- الآحاد: 4 + 3 = 7.
- العشرات: 2 + 1 = 3.
- المجموع: 37.

> ⚠️ الفخّ الشائع: نجمع الآحاد مع الآحاد والعشرات مع العشرات، ولا نخلط بينها.

> 🏆 أحسنت أيّها البطل! صرتَ تجمع بالعدّ ودون احتفاظ في حدود 99. استعدّ للبوّابة التالية!', '# 📜 ملخّص: الجمع

- **الجمع** يعني ضمّ مجموعتين معًا وعدّ الكلّ، وعلامته + (زائد).
- 3 + 2 = 5 نقرأها «ثلاثة زائد اثنين يساوي خمسة»، والنتيجة تُسمّى المجموع.
- **الجمع بالعدّ**: نبدأ من العدد الأكبر ونَعُدّ تصاعديًّا: 6 + 3 ⟸ 7، 8، 9 = 9.
- **ترتيب الجمع لا يغيّر النتيجة**: 4 + 5 = 5 + 4 = 9.
- **العدد 0** لا يغيّر شيئًا: 8 + 0 = 8.
- **بدون احتفاظ**: نجمع الآحاد مع الآحاد والعشرات مع العشرات: 24 + 13 = 37.
- **مع احتفاظ**: إذا بلغت الآحاد 10 أو أكثر نكوّن عشرة جديدة ونحتفظ بها: 27 + 5 = 32.
- **احذر**: لا تنسَ العشرة المحتفظ بها عند جمع العشرات.', 7, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('11fdddcd-6630-5b51-9ecd-b4bb22614bb1', 'math-1ere', 'الأشكال الهندسية', 'التعرّف على المربّع والمستطيل والمثلّث والدائرة، عدد الأضلاع والزوايا، تمييز الأشكال في المحيط', '# ⚔️ الأشكال الهندسية — كنوز عالَم الأشكال

> 💡 «لكلّ شكلٍ سرّ: عدد أضلاعه وزواياه يكشف اسمه!»

أيّها البطل، نترك الأعداد قليلًا وندخل عالَم **الأشكال**. سنتعرّف على أربعة كنوز: المربّع، المستطيل، المثلّث، والدائرة.

## 🟦 المربّع

المربّع شكلٌ له:

- **4 أضلاع** متساوية في الطول.
- **4 زوايا** (أركان).

أمثلة من حولنا: وجه النرد، البلاطة، علبة المناديل المربّعة.

> 🗡️ سرّ المربّع: كلّ أضلاعه الأربعة لها نفس الطول تمامًا.

## 🟥 المستطيل

المستطيل شكلٌ له:

- **4 أضلاع** و **4 زوايا**.
- لكنّ ضلعيه الطويلين متساويين، وضلعيه القصيرين متساويين (ليس كلّ الأضلاع متساوية).

أمثلة: الباب، الكتاب، شاشة التلفاز.

> ⚠️ لا تخلط! المربّع كلّ أضلاعه متساوية، أمّا المستطيل فله ضلعان طويلان وضلعان قصيران.

## 🔺 المثلّث

المثلّث شكلٌ له:

- **3 أضلاع**.
- **3 زوايا**.

أمثلة: قطعة بيتزا، علامة الطريق، شراع المركب.

## ⚪ الدائرة

الدائرة شكلٌ **مستدير** تمامًا:

- **لا أضلاع لها ولا زوايا**.
- كلّ نقطة على حافّتها تبعد المسافة نفسها عن المركز.

أمثلة: العجلة، الساعة، القمر البدر.

<svg viewBox="0 0 300 172">
<title>المربّع والمستطيل والمثلّث والدائرة</title>
<rect x="24" y="34" width="48" height="48" fill="none" stroke="#0f172a" stroke-width="2.5"/><circle cx="24" cy="34" r="2.6" fill="#ef4444"/><circle cx="72" cy="34" r="2.6" fill="#ef4444"/><circle cx="72" cy="82" r="2.6" fill="#ef4444"/><circle cx="24" cy="82" r="2.6" fill="#ef4444"/><g stroke="#0f6e56" stroke-width="2"><path d="M44 34 l4 4 M52 34 l-4 4"/><path d="M44 82 l4 -4 M52 82 l-4 -4"/><path d="M24 54 l4 4 M24 62 l4 -4"/><path d="M72 54 l4 4 M72 62 l4 -4"/></g><rect x="96" y="40" width="70" height="40" fill="none" stroke="#0f172a" stroke-width="2.5"/><circle cx="96" cy="40" r="2.6" fill="#ef4444"/><circle cx="166" cy="40" r="2.6" fill="#ef4444"/><circle cx="166" cy="80" r="2.6" fill="#ef4444"/><circle cx="96" cy="80" r="2.6" fill="#ef4444"/><polygon points="210,82 246,30 282,82" fill="none" stroke="#0f172a" stroke-width="2.5"/><circle cx="210" cy="82" r="2.6" fill="#ef4444"/><circle cx="246" cy="30" r="2.6" fill="#ef4444"/><circle cx="282" cy="82" r="2.6" fill="#ef4444"/><circle cx="48" cy="128" r="22" fill="none" stroke="#0f172a" stroke-width="2.5"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="48" y="100" text-anchor="middle" fill="#0f172a" font-size="10">مربّع (4 أضلاع متساوية)</text><text x="131" y="100" text-anchor="middle" fill="#0f172a" font-size="11">مستطيل</text><text x="246" y="100" text-anchor="middle" fill="#0f172a" font-size="10">مثلّث (3 أضلاع)</text><text x="48" y="162" text-anchor="middle" fill="#2563eb" font-size="10">دائرة (بلا أضلاع)</text></g>
</svg>

## 🧩 نُميّز الأشكال

نعرف الشكل من **عدد أضلاعه**:

| الشكل    | عدد الأضلاع | عدد الزوايا |
| -------- | ----------- | ----------- |
| المثلّث  | 3           | 3           |
| المربّع  | 4           | 4           |
| المستطيل | 4           | 4           |
| الدائرة  | 0           | 0           |

> 🏆 رائع! صرت تعرف المربّع والمستطيل والمثلّث والدائرة وتُميّزها بعدد أضلاعها. استعدّ لآخر بوّابة: التموقع في الفضاء!', '# 📜 ملخّص: الأشكال الهندسية

- **المربّع**: 4 أضلاع متساوية و 4 زوايا (مثل وجه النرد).
- **المستطيل**: 4 أضلاع و 4 زوايا، لكن ضلعان طويلان وضلعان قصيران (مثل الباب).
- **الفرق**: المربّع كلّ أضلاعه متساوية، أمّا المستطيل فلا.
- **المثلّث**: 3 أضلاع و 3 زوايا (مثل قطعة البيتزا).
- **الدائرة**: شكل مستدير، لا أضلاع لها ولا زوايا (مثل العجلة).
- **نُميّز الشكل** بعدد أضلاعه: 3 مثلّث، 4 مربّع أو مستطيل، 0 دائرة.
- نبحث عن الأشكال من حولنا: الكتاب مستطيل، والساعة دائرة.', 9, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('c7ca9bbe-5553-5e50-b49c-51d09d3b52a0', 'math-1ere', 'التموقع في الفضاء', 'اليمين واليسار، فوق وتحت، أمام وخلف، داخل وخارج، الأكبر والأصغر، تحديد مواضع الأشياء', '# ⚔️ التموقع في الفضاء — بوصلة البطل

> 💡 «البطل الماهر يعرف دائمًا أين هو وأين كلّ شيءٍ حوله!»

أيّها البطل، في هذه البوّابة الأخيرة نتعلّم **مواضع الأشياء**: أين تقع؟ يمين أم يسار؟ فوق أم تحت؟ هذه كلماتٌ تساعدنا على وصف العالَم.

## ↔️ اليمين واليسار

::: figure اليدُ المرفوعةُ هي اليُمنى — وما في جهتها يمين، وما يقابله يسار (ننظر من جهتنا نحن)
<svg viewBox="0 0 300 200">
<circle cx="150" cy="58" r="27" fill="#fcd34d" stroke="#1f2937" stroke-width="3"/>
<path d="M120 92 Q150 82 180 92 L186 162 Q150 172 114 162 Z" fill="#60a5fa" stroke="#1f2937" stroke-width="3" stroke-linejoin="round"/>
<path d="M182 100 Q214 92 226 56" fill="none" stroke="#1f2937" stroke-width="7" stroke-linecap="round"/>
<circle cx="229" cy="50" r="9" fill="#fcd34d" stroke="#1f2937" stroke-width="3"/>
<path d="M118 100 Q98 128 96 158" fill="none" stroke="#1f2937" stroke-width="7" stroke-linecap="round"/>
<circle cx="95" cy="163" r="9" fill="#fcd34d" stroke="#1f2937" stroke-width="3"/>
<path d="M262 44 l6 12 13 1 -10 9 3 13 -12 -7 -12 7 3 -13 -10 -9 13 -1 z" fill="#22c55e" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/>
<path d="M40 150 l6 12 13 1 -10 9 3 13 -12 -7 -12 7 3 -13 -10 -9 13 -1 z" fill="#a78bfa" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/>
<g font-size="20" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="271" y="80" text-anchor="middle" fill="#15803d">يمين</text>
<text x="49" y="186" text-anchor="middle" fill="#6d28d9">يسار</text>
</g>
</svg>
:::

لكلّ بطلٍ **يدٌ يُمنى** و **يدٌ يُسرى**.

- ما كان جهة يدك اليُمنى فهو على **اليمين**.
- ما كان جهة يدك اليُسرى فهو على **اليسار**.

> 🗡️ خدعة البطل: غالبًا نأكل ونكتب باليد اليُمنى؛ هذه تساعدك على تذكّر اليمين.

## ↕️ فوق وتحت

::: figure العصفورُ فوق الشجرة، والقطُّ تحت الطاولة — «فوق» في الأعلى و«تحت» في الأسفل
<svg viewBox="0 0 330 215">
<rect x="78" y="120" width="13" height="72" fill="#92400e" stroke="#1f2937" stroke-width="2.5"/>
<circle cx="85" cy="112" r="36" fill="#4ade80" stroke="#1f2937" stroke-width="3"/>
<ellipse cx="80" cy="46" rx="19" ry="13" fill="#f87171" stroke="#1f2937" stroke-width="2.5"/>
<circle cx="98" cy="39" r="9" fill="#f87171" stroke="#1f2937" stroke-width="2.5"/>
<path d="M106 39 l11 -2 -9 7 z" fill="#f59e0b" stroke="#1f2937" stroke-width="1.5" stroke-linejoin="round"/>
<circle cx="100" cy="37" r="1.8" fill="#1f2937"/>
<path d="M74 44 q9 -9 17 0" fill="none" stroke="#1f2937" stroke-width="2.2"/>
<path d="M72 58 l-2 9 M84 59 l1 9" stroke="#1f2937" stroke-width="2.2" stroke-linecap="round"/>
<rect x="196" y="150" width="98" height="11" rx="3" fill="#b45309" stroke="#1f2937" stroke-width="2.5"/>
<rect x="202" y="161" width="9" height="36" fill="#b45309" stroke="#1f2937" stroke-width="2.5"/>
<rect x="279" y="161" width="9" height="36" fill="#b45309" stroke="#1f2937" stroke-width="2.5"/>
<ellipse cx="248" cy="180" rx="27" ry="15" fill="#fb923c" stroke="#1f2937" stroke-width="2.5"/>
<path d="M270 178 q14 -2 12 -16 q-8 6 -12 6" fill="#fb923c" stroke="#1f2937" stroke-width="2.5" stroke-linejoin="round"/>
<circle cx="226" cy="171" r="12" fill="#fb923c" stroke="#1f2937" stroke-width="2.5"/>
<path d="M217 163 l2 -10 7 6 z M235 163 l-2 -10 -7 6 z" fill="#fb923c" stroke="#1f2937" stroke-width="2" stroke-linejoin="round"/>
<circle cx="222" cy="170" r="1.7" fill="#1f2937"/><circle cx="230" cy="170" r="1.7" fill="#1f2937"/>
<path d="M226 174 l-6 2 M226 174 l6 2" stroke="#1f2937" stroke-width="1.4" stroke-linecap="round"/>
<g font-size="18" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="120" y="44" text-anchor="middle" fill="#b91c1c">فوق</text>
<text x="248" y="207" text-anchor="middle" fill="#c2410c">تحت</text>
</g>
</svg>
:::

- ما كان في الأعلى فهو **فوق**: الشمس فوق رأسك.
- ما كان في الأسفل فهو **تحت**: الأرض تحت قدميك.

مثال: الطائر يطير **فوق** الشجرة، والقطّ ينام **تحت** الكرسيّ.

## ⬅️➡️ أمام وخلف

::: figure التلميذُ ينظر إلى السبّورة: ما ينظر إليه أمامه، وما وراء ظهره خلفه
<svg viewBox="0 0 320 200">
<rect x="232" y="45" width="74" height="55" rx="4" fill="#16a34a" stroke="#1f2937" stroke-width="3"/>
<rect x="16" y="40" width="46" height="120" rx="3" fill="#b45309" stroke="#1f2937" stroke-width="3"/>
<circle cx="52" cy="94" r="4" fill="#fde68a" stroke="#1f2937" stroke-width="1.5"/>
<circle cx="150" cy="70" r="24" fill="#fcd34d" stroke="#1f2937" stroke-width="3"/>
<path d="M172 66 l12 4 -12 5 z" fill="#fcd34d" stroke="#1f2937" stroke-width="2"/>
<circle cx="162" cy="66" r="2.4" fill="#1f2937"/>
<path d="M126 100 Q150 92 174 100 L180 160 Q150 168 120 160 Z" fill="#f472b6" stroke="#1f2937" stroke-width="3" stroke-linejoin="round"/>
<path d="M174 108 Q205 104 224 96" fill="none" stroke="#1f2937" stroke-width="7" stroke-linecap="round"/>
<g font-size="18" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="269" y="118" text-anchor="middle" fill="#15803d">أمام</text>
<text x="39" y="176" text-anchor="middle" fill="#92400e">خلف</text>
</g>
</svg>
:::

- ما كان في اتّجاه نظرك فهو **أمامك**.
- ما كان وراء ظهرك فهو **خلفك**.

مثال: في الصفّ، السبّورة **أمام** التلميذ، والباب قد يكون **خلفه**.

## 📦 داخل وخارج

::: figure الكرةُ الحمراء داخل الصندوق، والكرةُ الزرقاء خارجه
<svg viewBox="0 0 320 200">
<path d="M70 90 L190 90 L190 170 L70 170 Z" fill="#fcd34d" stroke="#1f2937" stroke-width="3" stroke-linejoin="round"/>
<path d="M70 90 L95 68 L215 68 L190 90 Z" fill="#fde68a" stroke="#1f2937" stroke-width="3" stroke-linejoin="round"/>
<path d="M190 90 L215 68 L215 148 L190 170 Z" fill="#f59e0b" stroke="#1f2937" stroke-width="3" stroke-linejoin="round"/>
<circle cx="130" cy="140" r="22" fill="#ef4444" stroke="#1f2937" stroke-width="3"/>
<circle cx="270" cy="150" r="22" fill="#3b82f6" stroke="#1f2937" stroke-width="3"/>
<g font-size="18" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="130" y="120" text-anchor="middle" fill="#b91c1c">داخل</text>
<text x="270" y="122" text-anchor="middle" fill="#1d4ed8">خارج</text>
</g>
</svg>
:::

- ما كان في جوف الشيء فهو **داخله**: القلم **داخل** المقلمة.
- ما كان في ظاهره فهو **خارجه**: الحقيبة **خارج** الدُّرج.

## 📏 الأكبر والأصغر، الأطول والأقصر

::: figure الفيلُ أكبر، والفأرُ أصغر — نقارنُ الأحجام بالنظر
<svg viewBox="0 0 320 200">
<ellipse cx="110" cy="120" rx="70" ry="52" fill="#94a3b8" stroke="#1f2937" stroke-width="3"/>
<circle cx="55" cy="110" r="34" fill="#94a3b8" stroke="#1f2937" stroke-width="3"/>
<path d="M40 130 Q20 160 30 178" fill="none" stroke="#1f2937" stroke-width="9" stroke-linecap="round"/>
<path d="M60 138 Q52 168 60 172" fill="#94a3b8" stroke="#1f2937" stroke-width="2.5"/>
<circle cx="62" cy="100" r="3" fill="#1f2937"/>
<rect x="80" y="162" width="14" height="22" fill="#94a3b8" stroke="#1f2937" stroke-width="2.5"/>
<rect x="130" y="162" width="14" height="22" fill="#94a3b8" stroke="#1f2937" stroke-width="2.5"/>
<ellipse cx="256" cy="158" rx="30" ry="20" fill="#cbd5e1" stroke="#1f2937" stroke-width="2.5"/>
<circle cx="232" cy="150" r="13" fill="#cbd5e1" stroke="#1f2937" stroke-width="2.5"/>
<circle cx="226" cy="142" r="7" fill="#cbd5e1" stroke="#1f2937" stroke-width="2"/>
<circle cx="238" cy="140" r="7" fill="#cbd5e1" stroke="#1f2937" stroke-width="2"/>
<circle cx="229" cy="150" r="1.8" fill="#1f2937"/>
<path d="M284 160 q18 4 22 -8" fill="none" stroke="#1f2937" stroke-width="2.5" stroke-linecap="round"/>
<g font-size="18" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="95" y="58" text-anchor="middle" fill="#475569">أكبر</text>
<text x="256" y="128" text-anchor="middle" fill="#475569">أصغر</text>
</g>
</svg>
:::

نقارن أحجام الأشياء وأطوالها:

- الفيل **أكبر** من الفأر، والفأر **أصغر** من الفيل.
- العمود **أطول** من الكرسيّ، والكرسيّ **أقصر** من العمود.

> ⚠️ احذر! اليمين واليسار قد ينقلبان إذا واجهك شخصٌ آخر؛ انظر دائمًا من جهتك أنت.

> 🏆 مبروك أيّها البطل! أكملت كلّ بوّابات السنة الأولى: العدّ، المقارنة، الجمع، الطرح، الأشكال، والتموقع في الفضاء. صرت بطلًا حقيقيًّا في الرياضيات!', '# 📜 ملخّص: التموقع في الفضاء

- **اليمين واليسار**: ما كان جهة يدك اليُمنى يمين، وجهة يدك اليُسرى يسار.
- **فوق وتحت**: الشمس فوق رأسك، والأرض تحت قدميك.
- **أمام وخلف**: ما في اتّجاه نظرك أمامك، وما وراء ظهرك خلفك.
- **داخل وخارج**: القلم داخل المقلمة، والحقيبة خارج الدُّرج.
- **الأكبر والأصغر**: الفيل أكبر من الفأر، والفأر أصغر من الفيل.
- **الأطول والأقصر**: العمود أطول من الكرسيّ، والكرسيّ أقصر منه.
- **احذر**: اليمين واليسار قد ينقلبان مع شخصٍ يواجهك؛ انظر من جهتك أنت.', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('9387dc67-fc94-5be6-bc3b-fb8ba75c3b4c', 'math-1ere', 'المجموعات', 'تكوين مجموعة وتعيين عناصرها وتمثيلها، المجموعة الفارغة، التصنيف حسب خاصية، ومقارنة عناصر مجموعتين (أكثر/أقل/على قدر)', '# ⚔️ المجموعات — نُرتّب عالَمنا

> 💡 «قبل أن نَعُدّ، نتعلّم كيف نَجمع الأشياء معًا.»

أهلًا أيّها البطل الصغير! أحيانًا نجمع أشياءَ تشترك في صفةٍ واحدة: كلّ الكرات، كلّ الأشياء الحمراء، كلّ الأقلام. هذه التجمّعات تُسمّى **مجموعات**. تعلّمُ المجموعات يساعدك على الترتيب والمقارنة **قبل** أن نَعُدّ الأعداد.

## 🧺 ما هي المجموعة؟

**المجموعة** هي تجمّعٌ لأشياء نعرفها جيّدًا. كلّ شيءٍ داخل المجموعة يُسمّى **عنصرًا**.

- _مثال:_ مجموعة فواكه السلّة: تفّاحة، موزة، برتقالة. كلّ فاكهةٍ **عنصر**.

## ✏️ نُعيّن المجموعة ونُمثّلها

نُعيّن المجموعة بطريقتين:

- **بذكر عناصرها** بين قوسين معقوفين، نفصل بينها بفاصلة: **{تفّاحة، موزة، برتقالة}**.
- **برسمها**: نضع العناصر داخل خطٍّ مغلق (إطار).

::: figure نرسم المجموعة بخطٍّ مغلق حول عناصرها؛ وإذا لم يوجد أيُّ عنصر فهي فارغة { }
<svg viewBox="0 0 320 150"><path d="M40 78 q0 -52 78 -52 q78 0 78 52 q0 46 -78 46 q-78 0 -78 -46 z" fill="#dbeafe" stroke="#1f2937" stroke-width="2.5"/><path d="M78 55 q-15 -3 -15 12 q0 15 15 15 q15 0 15 -15 q0 -12 -15 -12 z" fill="#ef4444" stroke="#1f2937" stroke-width="2.5"/><path d="M78 56 l0 -7" stroke="#7c2d12" stroke-width="3" stroke-linecap="round"/><path d="M78 50 q9 -6 12 2 q-9 4 -12 -2 z" fill="#22c55e" stroke="#1f2937" stroke-width="1.5"/><path d="M106 64 q10 20 30 12 q-8 -18 -30 -12 z" fill="#fbbf24" stroke="#1f2937" stroke-width="2.2" stroke-linejoin="round"/><circle cx="163" cy="66" r="15" fill="#fb923c" stroke="#1f2937" stroke-width="2.5"/><path d="M163 51 l0 -5" stroke="#166534" stroke-width="2.5" stroke-linecap="round"/><text x="118" y="138" text-anchor="middle" font-size="13" font-weight="700" fill="#1d4ed8" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">مجموعة فيها 3 عناصر</text><path d="M232 78 q0 -46 44 -46 q44 0 44 46 q0 40 -44 40 q-44 0 -44 -40 z" fill="#f1f5f9" stroke="#1f2937" stroke-width="2.5" stroke-dasharray="6 4" transform="translate(-40,0)"/><text x="236" y="74" text-anchor="middle" font-size="22" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">{ }</text><text x="236" y="138" text-anchor="middle" font-size="13" font-weight="700" fill="#64748b" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">المجموعة الفارغة</text></svg>
:::

## 🫙 المجموعة الفارغة

أحيانًا لا يوجد أيُّ عنصر: هذه هي **المجموعة الفارغة**. نرمز إليها بقوسين فارغين **{ }**.

- _مثال:_ مجموعة الأفيال داخل القسم = **{ }** (لا يوجد أيُّ فيل).

## 🎨 نُصنّف حسب خاصية

نضع في المجموعة الواحدة الأشياءَ التي تشترك في **خاصية**: نفس **الشكل**، أو نفس **اللون**، أو نفس **الحجم**.

- _مثال:_ من بين أشكالٍ مختلفة، نُكوّن مجموعة **المربّعات** فقط.

> 🗡️ خاصيةٌ واحدة في كلّ مرّة: إمّا اللون، إمّا الشكل، إمّا الحجم.

## ⚖️ نقارن عناصر مجموعتين

لمعرفة أيّ مجموعةٍ فيها عناصر **أكثر**، نَصِل كلّ عنصرٍ من الأولى بعنصرٍ من الثانية (واحدًا بواحد):

- إذا بقيت عناصرُ بلا وصلٍ في الأولى ⟸ الأولى فيها **أكثر**، والثانية فيها **أقلّ**.
- إذا انتهت المجموعتان معًا ⟸ هما **على قدر** (نفس العدد).

::: figure نصل كلّ عنصر بعنصر: بقي عنصر بلا وصل، إذن المجموعة الأولى فيها أكثر
<svg viewBox="0 0 300 160"><circle cx="50" cy="28" r="12" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M41 24 q9 -7 18 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="50" cy="60" r="12" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M41 56 q9 -7 18 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="50" cy="92" r="12" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M41 88 q9 -7 18 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="50" cy="124" r="12" fill="#3b82f6" stroke="#1f2937" stroke-width="2.5"/><path d="M41 120 q9 -7 18 0" fill="none" stroke="#ffffff" stroke-width="2" opacity="0.75"/><circle cx="240" cy="28" r="15" fill="#fb923c" stroke="#1f2937" stroke-width="2.5"/><path d="M240 13 l0 -5" stroke="#166534" stroke-width="2.5" stroke-linecap="round"/><circle cx="240" cy="60" r="15" fill="#fb923c" stroke="#1f2937" stroke-width="2.5"/><path d="M240 45 l0 -5" stroke="#166534" stroke-width="2.5" stroke-linecap="round"/><circle cx="240" cy="92" r="15" fill="#fb923c" stroke="#1f2937" stroke-width="2.5"/><path d="M240 77 l0 -5" stroke="#166534" stroke-width="2.5" stroke-linecap="round"/><g stroke="#64748b" stroke-width="2" stroke-dasharray="5 3"><path d="M64 28 L224 28"/><path d="M64 60 L224 60"/><path d="M64 92 L224 92"/></g><circle cx="50" cy="124" r="20" fill="none" stroke="#dc2626" stroke-width="2.5" stroke-dasharray="4 3"/><text x="150" y="150" text-anchor="middle" font-size="13" font-weight="700" fill="#b91c1c" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">عنصر بلا وصل ⟸ الأولى فيها أكثر</text></svg>
:::

> ⚠️ الفخّ الشائع: لا ننظر إلى **حجم** الأشياء، بل إلى **عددها**. خمسُ كراتٍ صغيرة أكثرُ من ثلاث كراتٍ كبيرة.

> 🏆 أحسنت أيّها البطل! صرتَ تُكوّن المجموعات وتُمثّلها وتُصنّفها وتقارن عناصرها. هذا أساسٌ متينٌ قبل أن نَعُدّ الأعداد من 0 إلى 9!', '# 📜 ملخّص: المجموعات

- **المجموعة**: تجمّعٌ لأشياء معروفة ؛ كلّ شيءٍ فيها = **عنصر**.
- **التعيين**: بذكر العناصر بين قوسين معقوفين {…} مفصولةً بفاصلة، أو برسمها داخل إطارٍ مغلق.
- **المجموعة الفارغة**: لا تحتوي أيَّ عنصر، نرمز إليها **{ }**.
- **التصنيف**: نجمع حسب **خاصيةٍ واحدة** (الشكل أو اللون أو الحجم).
- **المقارنة**: نَصِل عناصر المجموعتين واحدًا بواحد لنعرف **أكثر / أقلّ / على قدر**.
- **انتبه**: المقارنة على **عدد** العناصر، لا على حجمها.', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('0dd45e0c-5ec2-52bc-b7ea-97b104cb98ee', 'math-1ere', 'النقود', 'التعرّف على القطع النقدية المتداولة (1، 2، 5، 10، 20، 50 مي)، تمثيل مبلغ بالقطع المناسبة أو بأقلّ عدد من القطع، ومقارنة المبالغ', '# ⚔️ النقود — كنزُ البطل

> 💡 «من يعرف قطعَ النقود يشتري ما يريد دون أن يُخدَع.»

أهلًا أيّها البطل! لِنشتريَ الأشياء نستعمل **النقود**. في تونس نَعُدّ المبالغ الصغيرة بالـ**مليم** (نكتبه: مي). تعلّمُ القطع النقدية يساعدك على الشراء والمقارنة.

## 🪙 القطع النقدية

نتعامل مع هذه القطع (قيمتها بالمليم):

| القطعة | 1 مي  | 2 مي  | 5 مي    | 10 مي   | 20 مي | 50 مي |
| ------ | ----- | ----- | ------- | ------- | ----- | ----- |
| الحجم  | صغيرة | صغيرة | متوسّطة | متوسّطة | كبيرة | كبيرة |

- لكلّ قطعةٍ **قيمة** مكتوبة عليها.
- القطعة 50 مي قيمتها أكبرُ من القطعة 5 مي.

::: figure قطعُ المليم: 1، 2، 5، 10، 20، 50 — قيمتها مكتوبة عليها
<svg viewBox="0 0 360 110"><circle cx="30" cy="58" r="15" fill="#cbd5e1" stroke="#1f2937" stroke-width="2.5"/><circle cx="30" cy="58" r="11" fill="none" stroke="#94a3b8" stroke-width="1.6"/><text x="30" y="63" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">1</text><circle cx="78" cy="58" r="17" fill="#cbd5e1" stroke="#1f2937" stroke-width="2.5"/><circle cx="78" cy="58" r="13" fill="none" stroke="#94a3b8" stroke-width="1.6"/><text x="78" y="63" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text><circle cx="132" cy="55" r="20" fill="#cbd5e1" stroke="#1f2937" stroke-width="2.5"/><circle cx="132" cy="55" r="16" fill="none" stroke="#94a3b8" stroke-width="1.6"/><text x="132" y="60" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">5</text><circle cx="192" cy="54" r="22" fill="#fbbf24" stroke="#1f2937" stroke-width="2.5"/><circle cx="192" cy="54" r="18" fill="none" stroke="#f59e0b" stroke-width="1.6"/><text x="192" y="59" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">10</text><circle cx="256" cy="52" r="25" fill="#fbbf24" stroke="#1f2937" stroke-width="2.5"/><circle cx="256" cy="52" r="21" fill="none" stroke="#f59e0b" stroke-width="1.6"/><text x="256" y="57" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">20</text><circle cx="326" cy="50" r="27" fill="#fbbf24" stroke="#1f2937" stroke-width="2.5"/><circle cx="326" cy="50" r="23" fill="none" stroke="#f59e0b" stroke-width="1.6"/><text x="326" y="55" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">50</text><text x="180" y="100" text-anchor="middle" font-size="13" font-weight="700" fill="#a16207" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">كلّما كبرت القيمة كبرت القطعة</text></svg>
:::

## 💰 نُمثّل مبلغًا

لِنُمثّل مبلغًا، نختار قطعًا مجموعُ قيمها يساوي المبلغ:

- _مثال:_ المبلغ 7 مي = قطعة 5 مي + قطعة 2 مي.

## 🔁 بأقلِّ عددٍ من القطع

نختار القطع **الكبيرة** أوّلًا لِنستعمل أقلَّ عددٍ ممكن:

- _مثال:_ المبلغ 12 مي بأقلّ القطع = 10 مي + 2 مي (قطعتان فقط)، لا اثنتا عشرة قطعةً من 1 مي!

::: figure المبلغ 12 مي بأقلّ عددٍ من القطع: 10 مي + 2 مي
<svg viewBox="0 0 340 120"><circle cx="52" cy="50" r="22" fill="#fbbf24" stroke="#1f2937" stroke-width="2.5"/><circle cx="52" cy="50" r="18" fill="none" stroke="#f59e0b" stroke-width="1.6"/><text x="52" y="55" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">10</text><text x="112" y="58" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">+</text><circle cx="160" cy="50" r="17" fill="#fbbf24" stroke="#1f2937" stroke-width="2.5"/><circle cx="160" cy="50" r="13" fill="none" stroke="#f59e0b" stroke-width="1.6"/><text x="160" y="55" text-anchor="middle" font-size="13" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">2</text><text x="215" y="58" text-anchor="middle" font-size="22" font-weight="700" fill="#1f2937" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">=</text><text x="272" y="60" text-anchor="middle" font-size="22" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">12 مي</text><text x="170" y="104" text-anchor="middle" font-size="13" font-weight="700" fill="#15803d" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">قطعتان فقط — نبدأ بالكبيرة</text></svg>
:::

## ⚖️ نقارن المبالغ

لمقارنة مبلغين، نقارن **قيمتيهما** (لا عددَ القطع):

- _مثال:_ 20 مي أكبرُ من 15 مي.

> ⚠️ الفخّ الشائع: عددُ القطع لا يدلّ على المبلغ. قطعةٌ واحدة من 50 مي أكبرُ قيمةً من خمس قطعٍ من 5 مي (لأنّ مجموعها 25 مي).

> 🏆 أحسنت أيّها البطل! صرتَ تعرف القطع النقدية، وتُمثّل المبالغ، وتقارنها. أنت الآن جاهزٌ للتسوّق!', '# 📜 ملخّص: النقود

- **الوحدة**: نَعُدّ المبالغ الصغيرة بالمليم (مي).
- **القطع المتداولة**: 1، 2، 5، 10، 20، 50 مي ؛ لكلّ قطعةٍ قيمة.
- **تمثيل مبلغ**: نختار قطعًا مجموعُ قيمها = المبلغ (مثال: 7 مي = 5 مي + 2 مي).
- **بأقلّ القطع**: نبدأ بالقطع الكبيرة (مثال: 12 مي = 10 مي + 2 مي).
- **المقارنة**: نقارن **قيمة** المبلغين، لا **عددَ** القطع.
- **انتبه**: قطعةٌ واحدة قد تكون أكبرَ قيمةً من عدّة قطعٍ صغيرة.', 8, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('d24bb485-faf9-5d35-b3f7-7067c0990995', 'math-1ere', 'الخطوط المفتوحة والمغلقة', 'التمييز بين الخطّ المفتوح والخطّ المغلق ورسمهما، وتعيين الداخل والخارج بالنسبة إلى خطّ مغلق', '# ⚔️ الخطوط المفتوحة والمغلقة — أسوارُ المملكة

> 💡 «الخطّ المغلق يحمي ما بداخله، والخطّ المفتوح طريقٌ بلا حدود.»

أيّها البطل، في عالَم الأشكال نوعان من الخطوط: **مفتوحة** و**مغلقة**. تعلّمُهما يساعدك على رسم الأشكال ومعرفة الداخل من الخارج.

## ➰ الخطّ المفتوح

**الخطّ المفتوح** له **طرفان** غير متّصلين، أي فيه **فتحة**، ولا يحيط بأيّ مكان.

- _مثال:_ خطٌّ مثل الطريق: نبدأ من طرفٍ وننتهي عند طرفٍ آخر.

## ⭕ الخطّ المغلق

**الخطّ المغلق** ليس له طرفان: يدور ويعود إلى نقطة انطلاقه دون فتحة، فيحيط بمكانٍ ما.

- _مثال:_ خطٌّ مثل السور حول الحديقة.

<svg viewBox="0 0 300 104">
<title>الخطّ المفتوح له طرفان، والمغلق يحيط بمنطقة</title>
<path d="M30 40 C60 10 90 70 130 40" fill="none" stroke="#0f172a" stroke-width="2.5"/><circle cx="30" cy="40" r="3.5" fill="#ef4444" stroke="#0f172a" stroke-width="1"/><circle cx="130" cy="40" r="3.5" fill="#ef4444" stroke="#0f172a" stroke-width="1"/><path d="M195 25 C240 15 260 55 240 65 C220 75 180 60 195 25 Z" fill="#dbeafe" stroke="#0f172a" stroke-width="2.5"/><g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="80" y="82" text-anchor="middle" fill="#0f172a" font-size="11">خطّ مفتوح (له طرفان)</text><text x="222" y="92" text-anchor="middle" fill="#2563eb" font-size="11">خطّ مغلق</text></g>
</svg>

## 🏠 داخل وخارج

الخطّ المغلق يفصل المكان إلى ثلاثة مواضع:

- ما هو **داخل** الخطّ.
- ما هو **خارج** الخطّ.
- ما هو **على** الخطّ نفسه.

> 🗡️ خدعة البطل: لمعرفة إن كان الخطّ مغلقًا، اتبعه بإصبعك ؛ إن عُدتَ إلى نقطة البداية دون أن تجد فتحةً فهو **مغلق**.

## ✏️ نرسم الخطوط

نرسم خطًّا **مفتوحًا** بترك طرفيه دون وصل، وخطًّا **مغلقًا** بوصل البداية بالنهاية.

> ⚠️ الفخّ الشائع: ليس كلُّ خطٍّ منحنٍ مغلقًا! المهمّ وجودُ فتحةٍ (مفتوح) أو عدمُها (مغلق)، لا شكلُ الخطّ.

> 🏆 أحسنت أيّها البطل! صرتَ تُميّز الخطّ المفتوح من المغلق، وتعرف الداخل من الخارج. هذا أساسُ رسم الأشكال!', '# 📜 ملخّص: الخطوط المفتوحة والمغلقة

- **الخطّ المفتوح**: له طرفان غير متّصلين (فيه فتحة)، ولا يحيط بمكان (مثل الطريق).
- **الخطّ المغلق**: يدور ويعود إلى بدايته دون فتحة، فيحيط بمكان (مثل السور).
- **داخل وخارج**: الخطّ المغلق يفصل بين ما هو **داخله**، وما هو **خارجه**، وما هو **على** الخطّ.
- **كيف نتعرّف**: نتبع الخطّ ؛ إن عُدنا إلى البداية دون فتحةٍ فهو مغلق.
- **انتبه**: العبرة بالفتحة لا بشكل الخطّ ؛ خطٌّ منحنٍ قد يكون مفتوحًا.', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bd1513be-6b46-50e6-bbfa-42ef1f57c47a', '9be0e6a9-f498-597f-9f20-fc8b09f0d0e8', 'math-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('22bc1be9-2583-59f6-9313-9c6f101eec2f', 'bd1513be-6b46-50e6-bbfa-42ef1f57c47a', 'كم نجمة هنا؟ ⭐⭐⭐', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'b', 'نَعُدّ النجمات واحدة واحدة: 1، 2، 3. عددها 3 نجمات.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e8b1ae2b-7b2f-5217-ac38-376fc22f5ad8', 'bd1513be-6b46-50e6-bbfa-42ef1f57c47a', 'كيف نقرأ العدد 7؟', '[{"id":"a","text":"خمسة"},{"id":"b","text":"ستّة"},{"id":"c","text":"سبعة"},{"id":"d","text":"ثمانية"}]'::jsonb, 'c', 'العدد 7 نقرأه «سبعة». يأتي بعد 6 وقبل 8.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1585e224-ecbf-5ced-9536-da6c29ec7fb3', 'bd1513be-6b46-50e6-bbfa-42ef1f57c47a', 'ما العدد الذي يعني «لا شيء»؟', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"9"},{"id":"d","text":"5"}]'::jsonb, 'a', 'العدد 0 (صفر) يعني لا شيء، مثل صحنٍ فارغ. وهو أصغر عدد.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d3066a32-5c2b-5c9b-b347-50a9b260df12', 'bd1513be-6b46-50e6-bbfa-42ef1f57c47a', 'ما العدد الذي يلي العدد 4؟', '[{"id":"a","text":"3"},{"id":"b","text":"5"},{"id":"c","text":"6"},{"id":"d","text":"8"}]'::jsonb, 'b', 'العدد الذي يلي 4 هو الذي يأتي بعده مباشرة، أي 5 (أكبر بواحد).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('64108a36-1a32-52bb-8ae8-a3ccb3652af8', 'bd1513be-6b46-50e6-bbfa-42ef1f57c47a', 'أيّ عدد هو الأكبر؟', '[{"id":"a","text":"2"},{"id":"b","text":"5"},{"id":"c","text":"8"},{"id":"d","text":"4"}]'::jsonb, 'c', 'كلّما تقدّمنا في العدّ صار العدد أكبر. من بين 2 و 5 و 8 و 4 الأكبر هو 8.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('46564e58-c1b5-56df-855a-b32f4b324bc7', '9be0e6a9-f498-597f-9f20-fc8b09f0d0e8', 'math-1ere', '⭐ تمرين: أوّل خطوات العدّ', 1, 50, 10, 'practice', 'admin', 1)
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
  ('a087aafb-c69d-585d-97c3-56271d8a48a6', '46564e58-c1b5-56df-855a-b32f4b324bc7', 'كم تفّاحة هنا؟ 🍎🍎', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'b', 'نَعُدّ التفّاحات: 1، 2. عددها 2 تفّاحتان.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ac0ceb82-56b2-5d4e-bf8d-602007ee5e55', '46564e58-c1b5-56df-855a-b32f4b324bc7', 'كيف نقرأ العدد 5؟', '[{"id":"a","text":"أربعة"},{"id":"b","text":"ثلاثة"},{"id":"c","text":"ستّة"},{"id":"d","text":"خمسة"}]'::jsonb, 'd', 'العدد 5 نقرأه «خمسة». يأتي بعد 4 وقبل 6.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b73ac76d-695b-5c14-9fa0-2f501eedc464', '46564e58-c1b5-56df-855a-b32f4b324bc7', 'كم كرة هنا؟ ⚽⚽⚽⚽', '[{"id":"a","text":"3"},{"id":"b","text":"5"},{"id":"c","text":"4"},{"id":"d","text":"6"}]'::jsonb, 'c', 'نَعُدّ الكرات: 1، 2، 3، 4. عددها 4 كرات.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1c9ffe8f-8129-545a-8669-735e33e24caa', '46564e58-c1b5-56df-855a-b32f4b324bc7', 'كم شيئًا في الصحن الفارغ؟', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"2"},{"id":"d","text":"9"}]'::jsonb, 'a', 'الصحن الفارغ لا شيء فيه، فعدد الأشياء هو 0 (صفر).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('14d4b509-511f-5716-aba5-baad7bd31983', '46564e58-c1b5-56df-855a-b32f4b324bc7', 'ما العدد الذي يلي العدد 6؟', '[{"id":"a","text":"5"},{"id":"b","text":"7"},{"id":"c","text":"8"},{"id":"d","text":"6"}]'::jsonb, 'b', 'العدد الذي يلي 6 يأتي بعده مباشرة، أي 7 (أكبر بواحد).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('71b39dd7-469b-5120-8e72-6e462db6f17f', '46564e58-c1b5-56df-855a-b32f4b324bc7', 'ما العدد الذي يسبق العدد 3؟', '[{"id":"a","text":"4"},{"id":"b","text":"1"},{"id":"c","text":"2"},{"id":"d","text":"0"}]'::jsonb, 'c', 'العدد الذي يسبق 3 يأتي قبله مباشرة، أي 2 (أصغر بواحد).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('91c98fc7-83c2-51a0-8352-96c67b690c09', '9be0e6a9-f498-597f-9f20-fc8b09f0d0e8', 'math-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الأعداد إلى 9', 3, 120, 30, 'boss', 'admin', 2)
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
  ('d35b5636-94f9-5e7b-9bd6-b32414bd4d52', '91c98fc7-83c2-51a0-8352-96c67b690c09', 'كم عددًا يقع بين 3 و 7 (دون أن نَعُدّهما)؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'b', 'الأعداد بين 3 و 7 هي 4 و 5 و 6، أي 3 أعداد. لا نَعُدّ 3 ولا 7.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('92a41e6f-fdda-55a8-8ed3-a750d313b6c0', '91c98fc7-83c2-51a0-8352-96c67b690c09', 'ما العدد الذي يلي العدد 8؟', '[{"id":"a","text":"7"},{"id":"b","text":"9"},{"id":"c","text":"10"},{"id":"d","text":"8"}]'::jsonb, 'b', 'العدد الذي يلي 8 يأتي بعده مباشرة، أي 9 (أكبر بواحد). و 9 هو آخر عدد في هذه البوّابة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d662e1b7-0c5a-50a9-8a13-af31faf6623c', '91c98fc7-83c2-51a0-8352-96c67b690c09', 'ما العدد الذي يسبق العدد 1؟', '[{"id":"a","text":"0"},{"id":"b","text":"2"},{"id":"c","text":"1"},{"id":"d","text":"9"}]'::jsonb, 'a', 'العدد الذي يسبق 1 يأتي قبله مباشرة، أي 0 (أصغر بواحد). و 0 هو أصغر عدد.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('377112bd-4ede-5b14-ad5a-158734dce1d4', '91c98fc7-83c2-51a0-8352-96c67b690c09', 'رتّب الأعداد 4 و 1 و 7 من الأصغر إلى الأكبر.', '[{"id":"a","text":"1، 4، 7"},{"id":"b","text":"7، 4، 1"},{"id":"c","text":"4، 1، 7"},{"id":"d","text":"1، 7، 4"}]'::jsonb, 'a', 'من الأصغر إلى الأكبر: 1 ثمّ 4 ثمّ 7. إذن الترتيب الصحيح هو 1، 4، 7.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('5d6dc786-aefd-5e06-8dbd-b3b3aba85100', '91c98fc7-83c2-51a0-8352-96c67b690c09', 'في يدي 5 أصابع، أخفيت 2. كم أصبعًا أراها؟', '[{"id":"a","text":"2"},{"id":"b","text":"4"},{"id":"c","text":"3"},{"id":"d","text":"5"}]'::jsonb, 'c', 'أبدأ بـ 5 أصابع وأخفي 2، فأَعُدّ ما بقي: 5 ثمّ 4 ثمّ 3. أرى 3 أصابع.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b1a93572-5ad3-5eac-b608-5c44d40ff43c', '91c98fc7-83c2-51a0-8352-96c67b690c09', 'أنا عددٌ أكبر من 6 وأصغر من 8. من أكون؟', '[{"id":"a","text":"6"},{"id":"b","text":"8"},{"id":"c","text":"9"},{"id":"d","text":"7"}]'::jsonb, 'd', 'العدد الأكبر من 6 والأصغر من 8 هو الوحيد بينهما، أي 7.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('10c40ca5-a980-5a5e-95f6-dd0da35ab853', '9be0e6a9-f498-597f-9f20-fc8b09f0d0e8', 'math-1ere', '⭐⭐ تمرين مراجعة (نمط امتحان): الأعداد إلى 9', 2, 70, 15, 'practice', 'admin', 3)
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
  ('79165bf5-d403-5ee0-bb61-415501302204', '10c40ca5-a980-5a5e-95f6-dd0da35ab853', 'كم قلبًا هنا؟ ❤️❤️❤️❤️❤️❤️', '[{"id":"a","text":"5"},{"id":"b","text":"6"},{"id":"c","text":"7"},{"id":"d","text":"4"}]'::jsonb, 'b', 'نَعُدّ القلوب واحدًا واحدًا: 1، 2، 3، 4، 5، 6. عددها 6 قلوب.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('fe4171ca-bcbf-5adf-9250-aa415e7d1ed8', '10c40ca5-a980-5a5e-95f6-dd0da35ab853', 'كيف نقرأ العدد 9؟', '[{"id":"a","text":"سبعة"},{"id":"b","text":"ثمانية"},{"id":"c","text":"تسعة"},{"id":"d","text":"ستّة"}]'::jsonb, 'c', 'العدد 9 نقرأه «تسعة». وهو أكبر عدد في هذه البوّابة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('9e2e31e4-84ed-58cb-88c6-e308556fabbb', '10c40ca5-a980-5a5e-95f6-dd0da35ab853', 'ما العدد الذي يلي العدد 2؟', '[{"id":"a","text":"3"},{"id":"b","text":"1"},{"id":"c","text":"4"},{"id":"d","text":"2"}]'::jsonb, 'a', 'العدد الذي يلي 2 يأتي بعده مباشرة، أي 3 (أكبر بواحد).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b9f9b894-3beb-5687-922d-0e1495bd812f', '10c40ca5-a980-5a5e-95f6-dd0da35ab853', 'أيّ عدد هو الأصغر؟', '[{"id":"a","text":"5"},{"id":"b","text":"9"},{"id":"c","text":"1"},{"id":"d","text":"7"}]'::jsonb, 'c', 'كلّما تأخّر العدد في العدّ صار أصغر. من بين 5 و 9 و 1 و 7 الأصغر هو 1.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ea4bf596-c295-5095-afb5-a1b1a80b4629', '10c40ca5-a980-5a5e-95f6-dd0da35ab853', 'ما العدد الذي يسبق العدد 8؟', '[{"id":"a","text":"9"},{"id":"b","text":"7"},{"id":"c","text":"6"},{"id":"d","text":"8"}]'::jsonb, 'b', 'العدد الذي يسبق 8 يأتي قبله مباشرة، أي 7 (أصغر بواحد).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e44d5b7b-66a4-5d13-ba12-00da4f0fde1c', '10c40ca5-a980-5a5e-95f6-dd0da35ab853', 'ما العدد المفقود؟ 3، 4، …، 6', '[{"id":"a","text":"7"},{"id":"b","text":"2"},{"id":"c","text":"8"},{"id":"d","text":"5"}]'::jsonb, 'd', 'نَعُدّ بالترتيب: 3، 4، 5، 6. العدد المفقود بين 4 و 6 هو 5.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('2af79c57-9878-55a9-9916-ea1e684b5ff1', '9be0e6a9-f498-597f-9f20-fc8b09f0d0e8', 'math-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز الأعداد إلى 9', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('6b57bb64-57a9-5a41-b271-511dba252032', '2af79c57-9878-55a9-9916-ea1e684b5ff1', 'أنا عددٌ أكبر من 4 وأصغر من 6. من أكون؟', '[{"id":"a","text":"4"},{"id":"b","text":"5"},{"id":"c","text":"6"},{"id":"d","text":"7"}]'::jsonb, 'b', 'العدد الوحيد الأكبر من 4 والأصغر من 6 هو 5.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ffbc3aef-7acd-52c8-bade-17491d0b3f03', '2af79c57-9878-55a9-9916-ea1e684b5ff1', 'عندي 3 حلوى، أعطتني أمّي 2 أخرى. كم صار لديّ؟', '[{"id":"a","text":"4"},{"id":"b","text":"6"},{"id":"c","text":"5"},{"id":"d","text":"3"}]'::jsonb, 'c', 'أبدأ بـ 3 ثمّ أَعُدّ 2 أخرى: 3 ثمّ 4 ثمّ 5. صار لديّ 5 حلوى.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('495fd9c0-95fa-550e-9c47-2bb07e0c2abd', '2af79c57-9878-55a9-9916-ea1e684b5ff1', 'ما العدد المفقود؟ 9، 8، …، 6', '[{"id":"a","text":"7"},{"id":"b","text":"5"},{"id":"c","text":"10"},{"id":"d","text":"4"}]'::jsonb, 'a', 'هنا نَعُدّ تنازليًّا: 9، 8، 7، 6. العدد المفقود بين 8 و 6 هو 7.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6b32867e-d5d0-574a-8d2f-c25c803b56c3', '2af79c57-9878-55a9-9916-ea1e684b5ff1', 'كان في القفص 6 عصافير، طار 3. كم بقي؟', '[{"id":"a","text":"2"},{"id":"b","text":"4"},{"id":"c","text":"9"},{"id":"d","text":"3"}]'::jsonb, 'd', 'أبدأ بـ 6 وأنقص 3 طارت: 6 ثمّ 5 ثمّ 4 ثمّ 3. بقي 3 عصافير.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('062d542a-f647-5025-9138-b3ef29b619f0', '2af79c57-9878-55a9-9916-ea1e684b5ff1', 'رتّب الأعداد 5 و 2 و 8 و 0 من الأكبر إلى الأصغر.', '[{"id":"a","text":"0، 2، 5، 8"},{"id":"b","text":"8، 5، 2، 0"},{"id":"c","text":"8، 2، 5، 0"},{"id":"d","text":"2، 0، 5، 8"}]'::jsonb, 'b', 'من الأكبر إلى الأصغر: 8 ثمّ 5 ثمّ 2 ثمّ 0. إذن الترتيب 8، 5، 2، 0.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('906088ab-04a4-5cd2-9869-cf1057c25c8b', '2af79c57-9878-55a9-9916-ea1e684b5ff1', 'عددٌ يأتي مباشرةً بعد 6 ومباشرةً قبل 8. ما هو؟', '[{"id":"a","text":"6"},{"id":"b","text":"8"},{"id":"c","text":"7"},{"id":"d","text":"9"}]'::jsonb, 'c', 'العدد الذي يأتي بعد 6 هو 7، وهو نفسه الذي يأتي قبل 8. إذن العدد هو 7.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('66dfa3cb-7b84-592c-8e51-e0b101dc67d8', '9be0e6a9-f498-597f-9f20-fc8b09f0d0e8', 'math-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للأعداد إلى 9', 3, 120, 30, 'boss', 'admin', 5)
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
  ('20de4c9f-827c-5a14-9fd8-39e700372f9c', '66dfa3cb-7b84-592c-8e51-e0b101dc67d8', 'كم مثلّثًا هنا؟ 🔺🔺🔺🔺🔺🔺🔺', '[{"id":"a","text":"6"},{"id":"b","text":"7"},{"id":"c","text":"8"},{"id":"d","text":"5"}]'::jsonb, 'b', 'نَعُدّ المثلّثات واحدًا واحدًا: 1، 2، 3، 4، 5، 6، 7. عددها 7 مثلّثات.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('65921bd0-bb97-5da8-8a53-e26dd3bff15c', '66dfa3cb-7b84-592c-8e51-e0b101dc67d8', 'ما العدد الذي يلي العدد 0؟', '[{"id":"a","text":"1"},{"id":"b","text":"0"},{"id":"c","text":"2"},{"id":"d","text":"9"}]'::jsonb, 'a', 'العدد الذي يلي 0 يأتي بعده مباشرة، أي 1 (أكبر بواحد).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6359a174-80e5-56f8-bb27-41fe1bf486d0', '66dfa3cb-7b84-592c-8e51-e0b101dc67d8', 'ما العدد المفقود؟ 5، …، 7، 8', '[{"id":"a","text":"4"},{"id":"b","text":"9"},{"id":"c","text":"6"},{"id":"d","text":"5"}]'::jsonb, 'c', 'نَعُدّ بالترتيب: 5، 6، 7، 8. العدد المفقود بين 5 و 7 هو 6.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('dba1a28d-b391-59c0-9b3b-ba140bd04974', '66dfa3cb-7b84-592c-8e51-e0b101dc67d8', 'أيّ عدد هو الأكبر؟', '[{"id":"a","text":"6"},{"id":"b","text":"3"},{"id":"c","text":"9"},{"id":"d","text":"8"}]'::jsonb, 'c', 'من بين 6 و 3 و 9 و 8 الأكبر هو 9 (آخر عدد في العدّ).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('61d31db6-a24b-5fde-89ad-96fe8009279d', '66dfa3cb-7b84-592c-8e51-e0b101dc67d8', 'عددٌ أكبر من 7 وأصغر من 9. ما هو؟', '[{"id":"a","text":"7"},{"id":"b","text":"8"},{"id":"c","text":"9"},{"id":"d","text":"6"}]'::jsonb, 'b', 'العدد الوحيد الأكبر من 7 والأصغر من 9 هو 8.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4e93f4b0-5cee-505a-b39b-a1129d3d78dc', '66dfa3cb-7b84-592c-8e51-e0b101dc67d8', 'رتّب الأعداد 3 و 9 و 0 من الأصغر إلى الأكبر.', '[{"id":"a","text":"9، 3، 0"},{"id":"b","text":"3، 0، 9"},{"id":"c","text":"0، 9، 3"},{"id":"d","text":"0، 3، 9"}]'::jsonb, 'd', 'من الأصغر إلى الأكبر: 0 ثمّ 3 ثمّ 9. إذن الترتيب 0، 3، 9.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('568728ff-4918-53cf-af71-e2bcdeb98334', 'c208be46-7f36-50f9-9459-4abf870c515e', 'math-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('9c5b368b-1b91-5845-81f3-c9bfe7ae63b1', '568728ff-4918-53cf-af71-e2bcdeb98334', 'كم عشرة في العدد 30؟', '[{"id":"a","text":"3"},{"id":"b","text":"1"},{"id":"c","text":"30"},{"id":"d","text":"0"}]'::jsonb, 'a', 'العدد 30 فيه 3 عشرات و 0 آحاد. إذن عدد العشرات هو 3.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('efb2f8b7-1b64-59aa-94c2-5ef8ee0d75a7', '568728ff-4918-53cf-af71-e2bcdeb98334', 'ما رقم الآحاد في العدد 47؟', '[{"id":"a","text":"4"},{"id":"b","text":"47"},{"id":"c","text":"7"},{"id":"d","text":"0"}]'::jsonb, 'c', 'في العدد 47 الرقم 4 عشرات والرقم 7 آحاد. إذن رقم الآحاد هو 7.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a15132a4-6ade-57f9-bd71-8dcffaff868a', '568728ff-4918-53cf-af71-e2bcdeb98334', 'كيف نقرأ العدد 52؟', '[{"id":"a","text":"خمسة وعشرون"},{"id":"b","text":"اثنان وخمسون"},{"id":"c","text":"خمسة وخمسون"},{"id":"d","text":"اثنان وعشرون"}]'::jsonb, 'b', 'العدد 52 فيه 5 عشرات و 2 آحاد، فنقرأه «اثنان وخمسون».', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8e7b88bb-cd74-5780-b655-2ddd33a6fd94', '568728ff-4918-53cf-af71-e2bcdeb98334', 'ما تفكيك العدد 68؟', '[{"id":"a","text":"6 + 8"},{"id":"b","text":"80 + 6"},{"id":"c","text":"60 + 8"},{"id":"d","text":"70 + 8"}]'::jsonb, 'c', 'العدد 68 فيه 6 عشرات (60) و 8 آحاد، فتفكيكه 60 + 8.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6817ab7b-4807-51cd-997a-54058567ce3c', '568728ff-4918-53cf-af71-e2bcdeb98334', 'أيّ عدد هو الأكبر؟', '[{"id":"a","text":"29"},{"id":"b","text":"30"},{"id":"c","text":"31"},{"id":"d","text":"32"}]'::jsonb, 'd', 'نقارن العشرات: في 29 عشرتان، وفي البقيّة 3 عشرات. ثمّ بين 30 و 31 و 32 الأكبر هو 32 (آحاده أكبر).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e1df16c6-599c-5fc7-91f7-71b3bd7b14ed', 'c208be46-7f36-50f9-9459-4abf870c515e', 'math-1ere', '⭐ تمرين: عشرات وآحاد', 1, 50, 10, 'practice', 'admin', 1)
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
  ('af263e77-d14e-55c1-9fe9-7d6b41b7451d', 'e1df16c6-599c-5fc7-91f7-71b3bd7b14ed', 'كم عشرة في العدد 20؟', '[{"id":"a","text":"2"},{"id":"b","text":"20"},{"id":"c","text":"1"},{"id":"d","text":"0"}]'::jsonb, 'a', 'العدد 20 فيه عشرتان (2 عشرات) و 0 آحاد. إذن عدد العشرات هو 2.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('dda0a4af-d061-5a87-8303-61d362260eaa', 'e1df16c6-599c-5fc7-91f7-71b3bd7b14ed', 'ما رقم العشرات في العدد 53؟', '[{"id":"a","text":"3"},{"id":"b","text":"5"},{"id":"c","text":"8"},{"id":"d","text":"0"}]'::jsonb, 'b', 'في العدد 53 الرقم 5 عشرات والرقم 3 آحاد. إذن رقم العشرات هو 5.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('2922137e-c2e3-58e7-8693-e6d803e77a99', 'e1df16c6-599c-5fc7-91f7-71b3bd7b14ed', 'كم عدد العشرات والآحاد في العدد 10؟', '[{"id":"a","text":"0 عشرة و 10 آحاد"},{"id":"b","text":"1 عشرة و 0 آحاد"},{"id":"c","text":"10 عشرات و 0 آحاد"},{"id":"d","text":"1 عشرة و 1 آحاد"}]'::jsonb, 'b', 'العدد 10 هو عشرة واحدة بلا آحاد، أي 1 عشرة و 0 آحاد.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4a858ebd-eabb-50b4-8939-8fd36a6dec5f', 'e1df16c6-599c-5fc7-91f7-71b3bd7b14ed', 'كيف نقرأ العدد 40؟', '[{"id":"a","text":"أربعة"},{"id":"b","text":"أربعة عشر"},{"id":"c","text":"أربعون"},{"id":"d","text":"أربعمئة"}]'::jsonb, 'c', 'العدد 40 فيه 4 عشرات و 0 آحاد، فنقرأه «أربعون».', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('eb0cbf45-dd30-50a1-a92d-6da781cefe87', 'e1df16c6-599c-5fc7-91f7-71b3bd7b14ed', 'ما تفكيك العدد 35؟', '[{"id":"a","text":"50 + 3"},{"id":"b","text":"3 + 5"},{"id":"c","text":"30 + 5"},{"id":"d","text":"35 + 5"}]'::jsonb, 'c', 'العدد 35 فيه 3 عشرات (30) و 5 آحاد، فتفكيكه 30 + 5.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('fa7dbdf0-347b-548c-98a0-d9b7b230bd2c', 'e1df16c6-599c-5fc7-91f7-71b3bd7b14ed', 'ما رقم الآحاد في العدد 90؟', '[{"id":"a","text":"9"},{"id":"b","text":"90"},{"id":"c","text":"1"},{"id":"d","text":"0"}]'::jsonb, 'd', 'العدد 90 فيه 9 عشرات و 0 آحاد. إذن رقم الآحاد هو 0.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ff9292ef-e3eb-5d2e-9c61-420f62ce29d3', 'c208be46-7f36-50f9-9459-4abf870c515e', 'math-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد العشرات', 3, 120, 30, 'boss', 'admin', 2)
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
  ('2ffdb7c6-d090-5c52-a887-57114178880a', 'ff9292ef-e3eb-5d2e-9c61-420f62ce29d3', 'عددٌ رقمُ عشراته 6 ورقمُ آحاده 2. ما هو؟', '[{"id":"a","text":"26"},{"id":"b","text":"62"},{"id":"c","text":"8"},{"id":"d","text":"620"}]'::jsonb, 'b', 'نضع رقم العشرات أوّلًا ثمّ رقم الآحاد: 6 عشرات و 2 آحاد يكوّنان العدد 62.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('31c18015-043b-56f4-8668-ea467de9a8c4', 'ff9292ef-e3eb-5d2e-9c61-420f62ce29d3', 'كيف نقرأ العدد 74؟', '[{"id":"a","text":"أربعة وسبعون"},{"id":"b","text":"سبعة وأربعون"},{"id":"c","text":"أربعة وعشرون"},{"id":"d","text":"سبعون"}]'::jsonb, 'a', 'العدد 74 فيه 7 عشرات و 4 آحاد، فنقرأه «أربعة وسبعون».', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d326095a-c43f-57fe-ac3b-7dd3a04417d4', 'ff9292ef-e3eb-5d2e-9c61-420f62ce29d3', 'عددٌ فيه 8 عشرات و 0 آحاد. ما هو؟', '[{"id":"a","text":"8"},{"id":"b","text":"18"},{"id":"c","text":"80"},{"id":"d","text":"88"}]'::jsonb, 'c', '8 عشرات تساوي 80، ولا آحاد، فالعدد هو 80.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8540226d-914a-5bfe-ab00-2e72405f12e4', 'ff9292ef-e3eb-5d2e-9c61-420f62ce29d3', 'ما تفكيك العدد 90؟', '[{"id":"a","text":"9 + 0"},{"id":"b","text":"90 + 9"},{"id":"c","text":"9 + 90"},{"id":"d","text":"90 + 0"}]'::jsonb, 'd', 'العدد 90 فيه 9 عشرات (90) و 0 آحاد، فتفكيكه 90 + 0.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('73a2b0b6-8e5f-5995-ba97-cde9ea6c90aa', 'ff9292ef-e3eb-5d2e-9c61-420f62ce29d3', 'العدد 30 + 7 يساوي:', '[{"id":"a","text":"10"},{"id":"b","text":"37"},{"id":"c","text":"73"},{"id":"d","text":"307"}]'::jsonb, 'b', '30 (ثلاث عشرات) مع 7 آحاد يكوّنان العدد 37.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('da2f2c56-a562-5df6-a3aa-0d8635b5bfc8', 'ff9292ef-e3eb-5d2e-9c61-420f62ce29d3', 'في العدد 58، ماذا يساوي رقم العشرات بالآحاد؟', '[{"id":"a","text":"5"},{"id":"b","text":"8"},{"id":"c","text":"50"},{"id":"d","text":"58"}]'::jsonb, 'c', 'رقم العشرات في 58 هو 5، و 5 عشرات تساوي 50 من الآحاد.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('000cd276-dc9f-5582-bc07-9e9c1d13e851', 'c208be46-7f36-50f9-9459-4abf870c515e', 'math-1ere', '⭐⭐ تمرين مراجعة (نمط امتحان): الأعداد إلى 99', 2, 70, 15, 'practice', 'admin', 3)
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
  ('aa5e3851-8aa8-5854-beca-89ad71dda792', '000cd276-dc9f-5582-bc07-9e9c1d13e851', 'ما رقم العشرات في العدد 81؟', '[{"id":"a","text":"8"},{"id":"b","text":"1"},{"id":"c","text":"9"},{"id":"d","text":"0"}]'::jsonb, 'a', 'في العدد 81 الرقم 8 عشرات والرقم 1 آحاد. إذن رقم العشرات هو 8.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('001d9636-1cca-5405-8a5d-534e4e37d451', '000cd276-dc9f-5582-bc07-9e9c1d13e851', 'كيف نقرأ العدد 66؟', '[{"id":"a","text":"ستّون"},{"id":"b","text":"ستّة وستّون"},{"id":"c","text":"ستّة عشر"},{"id":"d","text":"ستّة"}]'::jsonb, 'b', 'العدد 66 فيه 6 عشرات و 6 آحاد، فنقرأه «ستّة وستّون».', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8cc1bd67-7fea-5325-b0e3-0cb5d36313eb', '000cd276-dc9f-5582-bc07-9e9c1d13e851', 'ما تفكيك العدد 49؟', '[{"id":"a","text":"90 + 4"},{"id":"b","text":"4 + 9"},{"id":"c","text":"40 + 9"},{"id":"d","text":"50 + 9"}]'::jsonb, 'c', 'العدد 49 فيه 4 عشرات (40) و 9 آحاد، فتفكيكه 40 + 9.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bf9f07ce-b212-5212-ac03-29fab1bcbf81', '000cd276-dc9f-5582-bc07-9e9c1d13e851', 'عددٌ رقمُ عشراته 7 ورقمُ آحاده 0. ما هو؟', '[{"id":"a","text":"7"},{"id":"b","text":"17"},{"id":"c","text":"70"},{"id":"d","text":"77"}]'::jsonb, 'c', '7 عشرات و 0 آحاد يكوّنان العدد 70.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a388d075-825c-5b3f-94f5-260e37a06f41', '000cd276-dc9f-5582-bc07-9e9c1d13e851', 'العدد 50 + 6 يساوي:', '[{"id":"a","text":"56"},{"id":"b","text":"65"},{"id":"c","text":"11"},{"id":"d","text":"506"}]'::jsonb, 'a', '50 (خمس عشرات) مع 6 آحاد يكوّنان العدد 56.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('459f2b38-a2fc-5dff-8350-14af044800e6', '000cd276-dc9f-5582-bc07-9e9c1d13e851', 'كم آحادًا في العدد 25؟', '[{"id":"a","text":"2"},{"id":"b","text":"20"},{"id":"c","text":"7"},{"id":"d","text":"5"}]'::jsonb, 'd', 'في العدد 25 الرقم 2 عشرات والرقم 5 آحاد. إذن عدد الآحاد هو 5.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ae5fd623-2293-5fe6-bf04-652d96db8a41', 'c208be46-7f36-50f9-9459-4abf870c515e', 'math-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز العشرات والآحاد', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('fac80caa-f1fb-57af-88bb-149e6617349d', 'ae5fd623-2293-5fe6-bf04-652d96db8a41', 'أنا عددٌ رقمُ عشراتي 4 ورقمُ آحادي 7. من أكون؟', '[{"id":"a","text":"74"},{"id":"b","text":"47"},{"id":"c","text":"11"},{"id":"d","text":"407"}]'::jsonb, 'b', 'نضع رقم العشرات أوّلًا ثمّ الآحاد: 4 عشرات و 7 آحاد يكوّنان العدد 47.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e222f189-542b-5296-ae4c-fd5ca42446a8', 'ae5fd623-2293-5fe6-bf04-652d96db8a41', 'أنا عددٌ فيه 6 عشرات، ورقمُ آحادي هو نفسُه رقم عشراتي. من أكون؟', '[{"id":"a","text":"60"},{"id":"b","text":"16"},{"id":"c","text":"66"},{"id":"d","text":"6"}]'::jsonb, 'c', 'رقم العشرات 6، ورقم الآحاد مثله أي 6 أيضًا، فالعدد 66.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('88d8dba7-d94a-5476-ad8d-a59dbc869e6c', 'ae5fd623-2293-5fe6-bf04-652d96db8a41', 'أيّ عدد يساوي 8 عشرات و 3 آحاد؟', '[{"id":"a","text":"38"},{"id":"b","text":"11"},{"id":"c","text":"830"},{"id":"d","text":"83"}]'::jsonb, 'd', '8 عشرات تساوي 80، مع 3 آحاد، فالعدد 80 + 3 = 83.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('2c1c671c-e69d-5398-9b5b-31f134c7ee20', 'ae5fd623-2293-5fe6-bf04-652d96db8a41', 'أنا عددٌ أكبر من 50 وأصغر من 60، ورقمُ آحادي 0. من أكون؟', '[{"id":"a","text":"50"},{"id":"b","text":"60"},{"id":"c","text":"55"},{"id":"d","text":"5"}]'::jsonb, 'a', 'العدد بين 50 و 60 الذي رقمُ آحاده 0 لا يمكن أن يكون 60 (لأنّه ليس أصغر من 60)، فهو 50.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('783e5cc1-0909-5350-aeee-11e37109c50e', 'ae5fd623-2293-5fe6-bf04-652d96db8a41', 'أيّ عدد فيه عددُ العشرات يساوي عددَ الآحاد، وهو أكبر من 30 وأصغر من 40؟', '[{"id":"a","text":"30"},{"id":"b","text":"33"},{"id":"c","text":"44"},{"id":"d","text":"13"}]'::jsonb, 'b', 'العدد بين 30 و 40 رقمُ عشراته 3؛ ليتساوى مع الآحاد يكون رقمُ الآحاد 3 أيضًا، فالعدد 33.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d46a2031-2e6c-5ac3-b3c0-58e2f6b8a617', 'ae5fd623-2293-5fe6-bf04-652d96db8a41', 'إذا أخذنا العدد 25 وبدّلنا مكان رقم العشرات ورقم الآحاد، أيّ عدد نحصل؟', '[{"id":"a","text":"25"},{"id":"b","text":"55"},{"id":"c","text":"22"},{"id":"d","text":"52"}]'::jsonb, 'd', 'في 25 رقمُ العشرات 2 ورقمُ الآحاد 5. عند التبديل يصير 5 عشرات و 2 آحاد، أي 52.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('cab07cea-63fb-5795-bed0-9dcf4ef73f31', 'c208be46-7f36-50f9-9459-4abf870c515e', 'math-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للأعداد إلى 99', 3, 120, 30, 'boss', 'admin', 5)
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
  ('2c2732a5-ef61-52dc-bbc4-feb4728f559c', 'cab07cea-63fb-5795-bed0-9dcf4ef73f31', 'ما رقم العشرات في العدد 19؟', '[{"id":"a","text":"1"},{"id":"b","text":"9"},{"id":"c","text":"10"},{"id":"d","text":"0"}]'::jsonb, 'a', 'في العدد 19 الرقم 1 عشرات والرقم 9 آحاد. إذن رقم العشرات هو 1.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('3837c709-218f-5b07-8642-cc7a2623ba35', 'cab07cea-63fb-5795-bed0-9dcf4ef73f31', 'ما تفكيك العدد 27؟', '[{"id":"a","text":"70 + 2"},{"id":"b","text":"20 + 7"},{"id":"c","text":"2 + 7"},{"id":"d","text":"30 + 7"}]'::jsonb, 'b', 'العدد 27 فيه 2 عشرات (20) و 7 آحاد، فتفكيكه 20 + 7.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('297a18df-b730-5122-8416-3f2c6cf961b4', 'cab07cea-63fb-5795-bed0-9dcf4ef73f31', 'عددٌ رقمُ عشراته 3 ورقمُ آحاده 9. ما هو؟', '[{"id":"a","text":"93"},{"id":"b","text":"12"},{"id":"c","text":"39"},{"id":"d","text":"309"}]'::jsonb, 'c', '3 عشرات و 9 آحاد يكوّنان العدد 39.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('90f97137-2f2c-55da-bbfa-3b6057f4b335', 'cab07cea-63fb-5795-bed0-9dcf4ef73f31', 'العدد 60 + 4 يساوي:', '[{"id":"a","text":"46"},{"id":"b","text":"10"},{"id":"c","text":"604"},{"id":"d","text":"64"}]'::jsonb, 'd', '60 (ستّ عشرات) مع 4 آحاد يكوّنان العدد 64.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ac8c35c4-8620-525c-b02a-366bc1f5d691', 'cab07cea-63fb-5795-bed0-9dcf4ef73f31', 'كم عشرة وكم آحاد في العدد 99؟', '[{"id":"a","text":"9 عشرات و 9 آحاد"},{"id":"b","text":"99 عشرة و 0 آحاد"},{"id":"c","text":"0 عشرة و 99 آحاد"},{"id":"d","text":"9 عشرات و 0 آحاد"}]'::jsonb, 'a', 'العدد 99 هو أكبر عدد في هذه البوّابة، وفيه 9 عشرات و 9 آحاد.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('7aeb467a-2ff1-5378-98f7-f2cac24bdd0a', 'cab07cea-63fb-5795-bed0-9dcf4ef73f31', 'أنا عددٌ فيه 5 عشرات وآحادي أصغر بواحد من عشراتي. من أكون؟', '[{"id":"a","text":"55"},{"id":"b","text":"45"},{"id":"c","text":"50"},{"id":"d","text":"54"}]'::jsonb, 'd', 'رقم العشرات 5، والآحاد أصغر بواحد أي 5 − 1 = 4، فالعدد 54.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6c3869f6-747f-5dc1-ac15-e99fdfdaa856', 'c5963a75-8dce-5605-8fab-28148d2d5745', 'math-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('82f55bbb-25d8-5863-8200-aa986a0534c3', '6c3869f6-747f-5dc1-ac15-e99fdfdaa856', 'ما الرمز المناسب؟ 8 … 5', '[{"id":"a","text":">"},{"id":"b","text":"<"},{"id":"c","text":"="},{"id":"d","text":"+"}]'::jsonb, 'a', 'العدد 8 أكبر من 5، فالرمز المناسب هو >: نكتب 8 > 5.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f8428593-2179-5bba-af58-174df69839c4', '6c3869f6-747f-5dc1-ac15-e99fdfdaa856', 'ما الرمز المناسب؟ 3 … 7', '[{"id":"a","text":">"},{"id":"b","text":"<"},{"id":"c","text":"="},{"id":"d","text":"−"}]'::jsonb, 'b', 'العدد 3 أصغر من 7، فالرمز المناسب هو <: نكتب 3 < 7.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('7cb42658-e019-5651-b74b-9a132464dfba', '6c3869f6-747f-5dc1-ac15-e99fdfdaa856', 'ما الرمز المناسب؟ 6 … 6', '[{"id":"a","text":">"},{"id":"b","text":"<"},{"id":"c","text":"="},{"id":"d","text":"×"}]'::jsonb, 'c', 'العددان متساويان (6 و 6)، فالرمز المناسب هو =: نكتب 6 = 6.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e4e05e71-e7b0-52f9-886d-08ac5ee1ebc0', '6c3869f6-747f-5dc1-ac15-e99fdfdaa856', 'أيّ عدد هو الأكبر؟', '[{"id":"a","text":"19"},{"id":"b","text":"21"},{"id":"c","text":"18"},{"id":"d","text":"12"}]'::jsonb, 'b', 'نقارن العشرات: 21 فيه عشرتان، والبقيّة فيها عشرة واحدة. إذن الأكبر هو 21.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('10f37e84-77f9-5e4c-9a3e-6633bbf8a2d2', '6c3869f6-747f-5dc1-ac15-e99fdfdaa856', 'ما الترتيب التصاعدي للأعداد 5 و 2 و 9؟', '[{"id":"a","text":"9، 5، 2"},{"id":"b","text":"5، 2، 9"},{"id":"c","text":"2، 5، 9"},{"id":"d","text":"2، 9، 5"}]'::jsonb, 'c', 'تصاعديًّا من الأصغر إلى الأكبر: 2 ثمّ 5 ثمّ 9. إذن 2، 5، 9.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('9dbae826-4596-52e8-9e45-add93ece7de8', 'c5963a75-8dce-5605-8fab-28148d2d5745', 'math-1ere', '⭐ تمرين: أكبر، أصغر، يساوي', 1, 50, 10, 'practice', 'admin', 1)
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
  ('82fde5f3-362f-5acd-b512-6deb62ecdddd', '9dbae826-4596-52e8-9e45-add93ece7de8', 'ما الرمز المناسب؟ 9 … 4', '[{"id":"a","text":">"},{"id":"b","text":"<"},{"id":"c","text":"="},{"id":"d","text":"+"}]'::jsonb, 'a', 'العدد 9 أكبر من 4، فالرمز المناسب هو >: نكتب 9 > 4.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('5e4a8793-eb42-5bd5-a913-cef3fba0d7f6', '9dbae826-4596-52e8-9e45-add93ece7de8', 'ما الرمز المناسب؟ 2 … 6', '[{"id":"a","text":">"},{"id":"b","text":"<"},{"id":"c","text":"="},{"id":"d","text":"×"}]'::jsonb, 'b', 'العدد 2 أصغر من 6، فالرمز المناسب هو <: نكتب 2 < 6.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a15e23bf-c9e7-53b8-9d9b-6e9ba72a6a21', '9dbae826-4596-52e8-9e45-add93ece7de8', 'ما الرمز المناسب؟ 7 … 7', '[{"id":"a","text":">"},{"id":"b","text":"<"},{"id":"c","text":"="},{"id":"d","text":"−"}]'::jsonb, 'c', 'العددان متساويان (7 و 7)، فالرمز المناسب هو =: نكتب 7 = 7.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('5b090ea2-fc32-51bf-9fb4-d5b7b169b225', '9dbae826-4596-52e8-9e45-add93ece7de8', 'أيّ عدد هو الأصغر؟', '[{"id":"a","text":"3"},{"id":"b","text":"5"},{"id":"c","text":"8"},{"id":"d","text":"6"}]'::jsonb, 'a', 'من بين 3 و 5 و 8 و 6 الأصغر هو 3.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f78a1066-702e-5c6f-8a6e-79128959cf3b', '9dbae826-4596-52e8-9e45-add93ece7de8', 'ما الرمز المناسب؟ 40 … 30', '[{"id":"a","text":"<"},{"id":"b","text":">"},{"id":"c","text":"="},{"id":"d","text":"+"}]'::jsonb, 'b', 'العدد 40 فيه 4 عشرات، و 30 فيه 3 عشرات، فـ 40 أكبر: نكتب 40 > 30.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d0cb6a14-200a-555b-a666-ec6c54b9bc50', '9dbae826-4596-52e8-9e45-add93ece7de8', 'أيّ عدد هو الأكبر؟', '[{"id":"a","text":"12"},{"id":"b","text":"11"},{"id":"c","text":"20"},{"id":"d","text":"21"}]'::jsonb, 'd', 'نقارن العشرات: 21 و 20 فيهما عشرتان، و 21 آحاده أكبر. إذن الأكبر هو 21.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('515ce564-1173-5862-9f2e-88f6cebf7b15', 'c5963a75-8dce-5605-8fab-28148d2d5745', 'math-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد المقارنة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('82594895-9ac1-5a9a-91f9-013db536a435', '515ce564-1173-5862-9f2e-88f6cebf7b15', 'ما الرمز المناسب؟ 34 … 43', '[{"id":"a","text":">"},{"id":"b","text":"<"},{"id":"c","text":"="},{"id":"d","text":"+"}]'::jsonb, 'b', 'نقارن العشرات: 34 فيه 3 عشرات، و 43 فيه 4 عشرات، فـ 34 أصغر: نكتب 34 < 43.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('fbd4bb4e-d074-5049-b09b-8ad3d4f18a07', '515ce564-1173-5862-9f2e-88f6cebf7b15', 'ما الرمز المناسب؟ 58 … 52', '[{"id":"a","text":">"},{"id":"b","text":"<"},{"id":"c","text":"="},{"id":"d","text":"×"}]'::jsonb, 'a', 'تساوت العشرات (5 و 5)، فننظر إلى الآحاد: 8 أكبر من 2. إذن 58 > 52.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f9458b1d-6e21-5fdc-9169-62a2915a047e', '515ce564-1173-5862-9f2e-88f6cebf7b15', 'أيّ عدد يقع بين 30 و 40؟', '[{"id":"a","text":"29"},{"id":"b","text":"41"},{"id":"c","text":"35"},{"id":"d","text":"45"}]'::jsonb, 'c', 'العدد الواقع بين 30 و 40 يكون أكبر من 30 وأصغر من 40. من الخيارات 35 وحده يحقّق ذلك.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b84b46ce-f1a7-5495-b6e0-5c59523cae95', '515ce564-1173-5862-9f2e-88f6cebf7b15', 'ما الترتيب التصاعدي للأعداد 25 و 52 و 15؟', '[{"id":"a","text":"15، 52، 25"},{"id":"b","text":"52، 25، 15"},{"id":"c","text":"15، 25، 52"},{"id":"d","text":"25، 15، 52"}]'::jsonb, 'c', 'نقارن العشرات: 15 (عشرة)، ثمّ 25 (عشرتان)، ثمّ 52 (خمس عشرات). تصاعديًّا: 15، 25، 52.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bf299130-4e08-5f95-ac43-4814d35f8565', '515ce564-1173-5862-9f2e-88f6cebf7b15', 'ما الترتيب التنازلي للأعداد 40 و 34 و 43؟', '[{"id":"a","text":"34، 40، 43"},{"id":"b","text":"43، 40، 34"},{"id":"c","text":"40، 43، 34"},{"id":"d","text":"43، 34، 40"}]'::jsonb, 'b', 'تنازليًّا من الأكبر: 43 (4 عشرات و 3 آحاد)، ثمّ 40، ثمّ 34. إذن 43، 40، 34.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('51120502-1e21-57d9-99a7-b20f1044060d', '515ce564-1173-5862-9f2e-88f6cebf7b15', 'أيّ عدد هو الأكبر؟', '[{"id":"a","text":"67"},{"id":"b","text":"76"},{"id":"c","text":"66"},{"id":"d","text":"77"}]'::jsonb, 'd', 'نقارن العشرات: 77 و 76 فيهما 7 عشرات؛ ثمّ الآحاد: 77 آحاده 7 أكبر. إذن الأكبر هو 77.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f826f2ff-5797-51f8-9da2-7205aff0d1a5', 'c5963a75-8dce-5605-8fab-28148d2d5745', 'math-1ere', '⭐⭐ تمرين مراجعة (نمط امتحان): المقارنة والترتيب', 2, 70, 15, 'practice', 'admin', 3)
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
  ('b3c32f7f-fd1a-50a5-b14c-9ee5e2b526e0', 'f826f2ff-5797-51f8-9da2-7205aff0d1a5', 'ما الرمز المناسب؟ 5 … 9', '[{"id":"a","text":">"},{"id":"b","text":"<"},{"id":"c","text":"="},{"id":"d","text":"+"}]'::jsonb, 'b', 'العدد 5 أصغر من 9، فالرمز المناسب هو <: نكتب 5 < 9.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bb37fdd4-767c-59ce-aa88-6bdaa4da3795', 'f826f2ff-5797-51f8-9da2-7205aff0d1a5', 'ما الرمز المناسب؟ 8 … 8', '[{"id":"a","text":"="},{"id":"b","text":">"},{"id":"c","text":"<"},{"id":"d","text":"×"}]'::jsonb, 'a', 'العددان متساويان (8 و 8)، فالرمز المناسب هو =: نكتب 8 = 8.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a7272737-c9ea-53c2-a162-d601aa55120e', 'f826f2ff-5797-51f8-9da2-7205aff0d1a5', 'ما الرمز المناسب؟ 60 … 50', '[{"id":"a","text":"<"},{"id":"b","text":"="},{"id":"c","text":">"},{"id":"d","text":"−"}]'::jsonb, 'c', 'العدد 60 فيه 6 عشرات، و 50 فيه 5 عشرات، فـ 60 أكبر: نكتب 60 > 50.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b1023f58-22c6-5f7d-8b4b-d0065b4025aa', 'f826f2ff-5797-51f8-9da2-7205aff0d1a5', 'ما الترتيب التصاعدي للأعداد 17 و 7 و 71؟', '[{"id":"a","text":"71، 17، 7"},{"id":"b","text":"7، 17، 71"},{"id":"c","text":"7، 71، 17"},{"id":"d","text":"17، 7، 71"}]'::jsonb, 'b', 'تصاعديًّا من الأصغر: 7 (آحاد فقط)، ثمّ 17 (عشرة)، ثمّ 71 (سبع عشرات). إذن 7، 17، 71.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4258f021-4230-5b31-9bda-af0a12c9686d', 'f826f2ff-5797-51f8-9da2-7205aff0d1a5', 'ما الرمز المناسب؟ 28 … 24', '[{"id":"a","text":"<"},{"id":"b","text":"="},{"id":"c","text":">"},{"id":"d","text":"+"}]'::jsonb, 'c', 'تساوت العشرات (2 و 2)، فننظر إلى الآحاد: 8 أكبر من 4. إذن 28 > 24.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('20155c79-14e9-5204-a851-a397773420b7', 'f826f2ff-5797-51f8-9da2-7205aff0d1a5', 'أيّ عدد هو الأصغر؟', '[{"id":"a","text":"45"},{"id":"b","text":"54"},{"id":"c","text":"44"},{"id":"d","text":"40"}]'::jsonb, 'd', 'نقارن العشرات: 45 و 44 و 40 فيها 4 عشرات؛ ثمّ الآحاد: 0 أصغر من 4 و 5. إذن الأصغر هو 40.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('2b3258b2-7ea5-5ee5-845b-7903f133d11d', 'c5963a75-8dce-5605-8fab-28148d2d5745', 'math-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز المقارنة والترتيب', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('15b15ca9-de27-514e-866f-4dbe92db8551', '2b3258b2-7ea5-5ee5-845b-7903f133d11d', 'أنا عددٌ أكبر من 19 وأصغر من 21. من أكون؟', '[{"id":"a","text":"20"},{"id":"b","text":"18"},{"id":"c","text":"22"},{"id":"d","text":"19"}]'::jsonb, 'a', 'العدد الوحيد الأكبر من 19 والأصغر من 21 هو 20.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('aa5739ba-798d-5a5b-8753-e769b782af1d', '2b3258b2-7ea5-5ee5-845b-7903f133d11d', 'ما الترتيب التنازلي للأعداد 36 و 63 و 33؟', '[{"id":"a","text":"33، 36، 63"},{"id":"b","text":"63، 36، 33"},{"id":"c","text":"36، 63، 33"},{"id":"d","text":"63، 33، 36"}]'::jsonb, 'b', 'تنازليًّا من الأكبر: 63 (6 عشرات)، ثمّ بين 36 و 33 (3 عشرات) الأكبر آحادًا 36، ثمّ 33. إذن 63، 36، 33.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('17c9e34e-1ccf-55e2-b1c7-17d723701c06', '2b3258b2-7ea5-5ee5-845b-7903f133d11d', 'أنا أكبر عددٍ آحاده 0 وأصغر من 50. من أكون؟', '[{"id":"a","text":"50"},{"id":"b","text":"49"},{"id":"c","text":"40"},{"id":"d","text":"45"}]'::jsonb, 'c', 'الأعداد آحادها 0 وأصغر من 50 هي 40، 30، 20، 10. أكبرها 40 (و 50 ليس أصغر من 50، و 45 آحاده 5).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a6b46202-5216-58f7-aaee-06ab418899c6', '2b3258b2-7ea5-5ee5-845b-7903f133d11d', 'إذا كان عددٌ أكبر من 30 وأصغر من 32 وآحاده ليس 0، فما هو؟', '[{"id":"a","text":"30"},{"id":"b","text":"32"},{"id":"c","text":"33"},{"id":"d","text":"31"}]'::jsonb, 'd', 'العدد بين 30 و 32 هو 31 فقط، وآحاده 1 ليس 0. إذن العدد هو 31.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('73d236c0-ec8a-56a5-a68c-385f7c3becde', '2b3258b2-7ea5-5ee5-845b-7903f133d11d', 'رتّب تصاعديًّا: 9 و 90 و 19 و 91.', '[{"id":"a","text":"9، 90، 19، 91"},{"id":"b","text":"9، 19، 90، 91"},{"id":"c","text":"19، 9، 91، 90"},{"id":"d","text":"91، 90، 19، 9"}]'::jsonb, 'b', 'تصاعديًّا: 9 (آحاد)، ثمّ 19 (عشرة)، ثمّ 90 و 91 (تسع عشرات، و 90 < 91). إذن 9، 19، 90، 91.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b4e6f1a5-8e3e-50ad-93bc-7ff96a21d8da', '2b3258b2-7ea5-5ee5-845b-7903f133d11d', 'أيّ جملة صحيحة؟', '[{"id":"a","text":"27 > 72"},{"id":"b","text":"55 < 50"},{"id":"c","text":"48 > 46"},{"id":"d","text":"30 = 33"}]'::jsonb, 'c', 'في 48 و 46 تساوت العشرات (4)، والآحاد 8 أكبر من 6، فـ 48 > 46 صحيحة. أمّا 27 < 72 و 55 > 50 و 30 ≠ 33.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('97764cde-425e-5582-b1d9-a3d72759f407', 'c5963a75-8dce-5605-8fab-28148d2d5745', 'math-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للمقارنة والترتيب', 3, 120, 30, 'boss', 'admin', 5)
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
  ('558d7fe4-4b6f-5c17-9845-28971f69844f', '97764cde-425e-5582-b1d9-a3d72759f407', 'ما الرمز المناسب؟ 17 … 71', '[{"id":"a","text":"<"},{"id":"b","text":">"},{"id":"c","text":"="},{"id":"d","text":"+"}]'::jsonb, 'a', 'نقارن العشرات: 17 فيه عشرة واحدة، و 71 فيه 7 عشرات، فـ 17 أصغر: نكتب 17 < 71.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ee5c1c98-3ea0-57d9-9a12-cb45333de6ea', '97764cde-425e-5582-b1d9-a3d72759f407', 'ما الرمز المناسب؟ 39 … 39', '[{"id":"a","text":"<"},{"id":"b","text":"="},{"id":"c","text":">"},{"id":"d","text":"×"}]'::jsonb, 'b', 'العددان متساويان (39 و 39)، فالرمز المناسب هو =: نكتب 39 = 39.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('32330e55-3c9f-55ed-b4c9-1dddb5b324e9', '97764cde-425e-5582-b1d9-a3d72759f407', 'أيّ عدد يقع بين 60 و 70؟', '[{"id":"a","text":"59"},{"id":"b","text":"71"},{"id":"c","text":"72"},{"id":"d","text":"65"}]'::jsonb, 'd', 'العدد بين 60 و 70 يكون أكبر من 60 وأصغر من 70. من الخيارات 65 وحده يحقّق ذلك.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('30378330-c107-551b-bbed-de3b6a102ed4', '97764cde-425e-5582-b1d9-a3d72759f407', 'ما الترتيب التصاعدي للأعداد 80 و 8 و 88؟', '[{"id":"a","text":"88، 80، 8"},{"id":"b","text":"8، 88، 80"},{"id":"c","text":"8، 80، 88"},{"id":"d","text":"80، 8، 88"}]'::jsonb, 'c', 'تصاعديًّا من الأصغر: 8 (آحاد)، ثمّ 80 (8 عشرات و 0 آحاد)، ثمّ 88. إذن 8، 80، 88.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('84f2065f-c2c0-5e63-8a44-0ba771a85daa', '97764cde-425e-5582-b1d9-a3d72759f407', 'ما الترتيب التنازلي للأعداد 47 و 74 و 44؟', '[{"id":"a","text":"44، 47، 74"},{"id":"b","text":"74، 47، 44"},{"id":"c","text":"47، 74، 44"},{"id":"d","text":"74، 44، 47"}]'::jsonb, 'b', 'تنازليًّا من الأكبر: 74 (7 عشرات)، ثمّ بين 47 و 44 (4 عشرات) الأكبر آحادًا 47، ثمّ 44. إذن 74، 47، 44.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('3bb3f1e1-f549-52c9-b38b-67bb046df5f2', '97764cde-425e-5582-b1d9-a3d72759f407', 'أنا عددٌ أكبر من 88 وأصغر من 90. من أكون؟', '[{"id":"a","text":"87"},{"id":"b","text":"90"},{"id":"c","text":"89"},{"id":"d","text":"88"}]'::jsonb, 'c', 'العدد الوحيد الأكبر من 88 والأصغر من 90 هو 89.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e77514a3-1ea0-5959-9951-7491f6f779ac', '9be4e72b-e0d9-5b6c-a6eb-4e70460d7b7f', 'math-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('71cfb666-ae83-50bf-a6b5-4a0a71524e85', 'e77514a3-1ea0-5959-9951-7491f6f779ac', 'كم يساوي 3 + 4؟', '[{"id":"a","text":"6"},{"id":"b","text":"7"},{"id":"c","text":"8"},{"id":"d","text":"1"}]'::jsonb, 'b', 'نبدأ من 4 ونَعُدّ 3: 5، 6، 7. إذن 3 + 4 = 7.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c87a45b0-bfea-54e4-89ec-5ba81d64fc41', 'e77514a3-1ea0-5959-9951-7491f6f779ac', 'كم يساوي 5 + 0؟', '[{"id":"a","text":"0"},{"id":"b","text":"50"},{"id":"c","text":"5"},{"id":"d","text":"10"}]'::jsonb, 'c', 'العدد 0 لا يغيّر شيئًا في الجمع، فـ 5 + 0 = 5.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('eb4e4eab-9f21-5091-b6f4-348868bc2b73', 'e77514a3-1ea0-5959-9951-7491f6f779ac', 'كم يساوي 2 + 6؟', '[{"id":"a","text":"8"},{"id":"b","text":"4"},{"id":"c","text":"9"},{"id":"d","text":"7"}]'::jsonb, 'a', 'نبدأ من 6 ونَعُدّ 2: 7، 8. إذن 2 + 6 = 8.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('25a16184-7c27-5dfe-b82e-fcb4d7ef0cde', 'e77514a3-1ea0-5959-9951-7491f6f779ac', 'كم يساوي 21 + 14؟', '[{"id":"a","text":"25"},{"id":"b","text":"35"},{"id":"c","text":"34"},{"id":"d","text":"44"}]'::jsonb, 'b', 'نجمع الآحاد: 1 + 4 = 5، والعشرات: 2 + 1 = 3. إذن 21 + 14 = 35.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1a15eed5-8f6a-52fa-a745-dfe5b13ee93a', 'e77514a3-1ea0-5959-9951-7491f6f779ac', 'كم يساوي 45 + 4؟', '[{"id":"a","text":"49"},{"id":"b","text":"48"},{"id":"c","text":"85"},{"id":"d","text":"41"}]'::jsonb, 'a', 'نجمع الآحاد: 5 + 4 = 9، وتبقى العشرات 4. إذن 45 + 4 = 49.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('56b6cfdc-dc3c-5d91-944b-6ca52dc75a74', '9be4e72b-e0d9-5b6c-a6eb-4e70460d7b7f', 'math-1ere', '⭐ تمرين: أوّل خطوات الجمع', 1, 50, 10, 'practice', 'admin', 1)
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
  ('49a52a15-0e77-5d0f-be4b-dbd11f39cb64', '56b6cfdc-dc3c-5d91-944b-6ca52dc75a74', 'كم يساوي 2 + 3؟', '[{"id":"a","text":"4"},{"id":"b","text":"5"},{"id":"c","text":"6"},{"id":"d","text":"1"}]'::jsonb, 'b', 'نبدأ من 3 ونَعُدّ 2: 4، 5. إذن 2 + 3 = 5.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('9bd8e9d4-201e-5c10-97d9-c6fcb48a90d0', '56b6cfdc-dc3c-5d91-944b-6ca52dc75a74', 'كم يساوي 4 + 4؟', '[{"id":"a","text":"8"},{"id":"b","text":"6"},{"id":"c","text":"9"},{"id":"d","text":"0"}]'::jsonb, 'a', 'نبدأ من 4 ونَعُدّ 4: 5، 6، 7، 8. إذن 4 + 4 = 8.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('585b34c2-575e-51f0-a108-d1cdb8222ee5', '56b6cfdc-dc3c-5d91-944b-6ca52dc75a74', 'كم يساوي 7 + 0؟', '[{"id":"a","text":"0"},{"id":"b","text":"70"},{"id":"c","text":"7"},{"id":"d","text":"8"}]'::jsonb, 'c', 'العدد 0 لا يغيّر شيئًا في الجمع، فـ 7 + 0 = 7.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1638861b-db67-5dfc-a946-9ef49daf4dfc', '56b6cfdc-dc3c-5d91-944b-6ca52dc75a74', 'كم يساوي 5 + 4؟', '[{"id":"a","text":"8"},{"id":"b","text":"10"},{"id":"c","text":"9"},{"id":"d","text":"1"}]'::jsonb, 'c', 'نبدأ من 5 ونَعُدّ 4: 6، 7، 8، 9. إذن 5 + 4 = 9.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('79256cf2-ecbd-56b2-addb-2fbf64db9a04', '56b6cfdc-dc3c-5d91-944b-6ca52dc75a74', 'كم يساوي 6 + 2؟', '[{"id":"a","text":"8"},{"id":"b","text":"4"},{"id":"c","text":"9"},{"id":"d","text":"7"}]'::jsonb, 'a', 'نبدأ من 6 ونَعُدّ 2: 7، 8. إذن 6 + 2 = 8.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('523582ee-9fcd-59f3-80f0-8caae92bfe83', '56b6cfdc-dc3c-5d91-944b-6ca52dc75a74', 'عندي 3 كرات حمراء و 5 كرات زرقاء. كم كرة عندي؟', '[{"id":"a","text":"2"},{"id":"b","text":"7"},{"id":"c","text":"9"},{"id":"d","text":"8"}]'::jsonb, 'd', 'نضمّ المجموعتين: 3 + 5 = 8. عندي 8 كرات.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e54b06ba-fd20-54f7-a355-ce0cbf9e87dc', '9be4e72b-e0d9-5b6c-a6eb-4e70460d7b7f', 'math-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الجمع', 3, 120, 30, 'boss', 'admin', 2)
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
  ('f041760b-e838-5855-b11e-efe68a614bf3', 'e54b06ba-fd20-54f7-a355-ce0cbf9e87dc', 'كم يساوي 32 + 25؟', '[{"id":"a","text":"57"},{"id":"b","text":"47"},{"id":"c","text":"55"},{"id":"d","text":"67"}]'::jsonb, 'a', 'نجمع الآحاد: 2 + 5 = 7، والعشرات: 3 + 2 = 5. إذن 32 + 25 = 57.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b08af78c-5448-5fd4-b09a-f14fb4972bf9', 'e54b06ba-fd20-54f7-a355-ce0cbf9e87dc', 'كم يساوي 40 + 30؟', '[{"id":"a","text":"10"},{"id":"b","text":"70"},{"id":"c","text":"60"},{"id":"d","text":"43"}]'::jsonb, 'b', 'نجمع العشرات: 4 عشرات + 3 عشرات = 7 عشرات = 70. إذن 40 + 30 = 70.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d7a5be23-46e5-5bb2-950e-3b4cfd26201a', 'e54b06ba-fd20-54f7-a355-ce0cbf9e87dc', 'كم يساوي 28 + 6؟', '[{"id":"a","text":"22"},{"id":"b","text":"33"},{"id":"c","text":"34"},{"id":"d","text":"35"}]'::jsonb, 'c', 'الآحاد: 8 + 6 = 14، نكتب 4 ونحتفظ بعشرة. العشرات: 2 + 1 = 3. إذن 28 + 6 = 34.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('65c7e7a1-6276-565b-bf75-0a10c0e331b4', 'e54b06ba-fd20-54f7-a355-ce0cbf9e87dc', 'كم يساوي 45 + 17؟', '[{"id":"a","text":"52"},{"id":"b","text":"61"},{"id":"c","text":"63"},{"id":"d","text":"62"}]'::jsonb, 'd', 'الآحاد: 5 + 7 = 12، نكتب 2 ونحتفظ بعشرة. العشرات: 4 + 1 + 1 = 6. إذن 45 + 17 = 62.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('3b33511c-1bcd-532b-ba8b-0a217d54260f', 'e54b06ba-fd20-54f7-a355-ce0cbf9e87dc', 'عددٌ إذا أضفنا إليه 5 صار 13. ما هو؟', '[{"id":"a","text":"18"},{"id":"b","text":"8"},{"id":"c","text":"7"},{"id":"d","text":"9"}]'::jsonb, 'b', 'نبحث عن عددٍ مع 5 يعطي 13. نَعُدّ من 5 إلى 13 فنجد 8 خطوات: 8 + 5 = 13. إذن العدد 8.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('5a3d0ca7-a6bc-5d3a-b8b5-92e49376d8d4', 'e54b06ba-fd20-54f7-a355-ce0cbf9e87dc', 'كم يساوي 19 + 19؟', '[{"id":"a","text":"28"},{"id":"b","text":"39"},{"id":"c","text":"38"},{"id":"d","text":"29"}]'::jsonb, 'c', 'الآحاد: 9 + 9 = 18، نكتب 8 ونحتفظ بعشرة. العشرات: 1 + 1 + 1 = 3. إذن 19 + 19 = 38.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('62948b29-9db3-5aed-a9e8-59b8a7dd4011', '9be4e72b-e0d9-5b6c-a6eb-4e70460d7b7f', 'math-1ere', '⭐⭐ تمرين مراجعة (نمط امتحان): الجمع', 2, 70, 15, 'practice', 'admin', 3)
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
  ('036b8c30-7ebf-59c5-a7d0-2938920233ea', '62948b29-9db3-5aed-a9e8-59b8a7dd4011', 'كم يساوي 8 + 1؟', '[{"id":"a","text":"9"},{"id":"b","text":"7"},{"id":"c","text":"10"},{"id":"d","text":"8"}]'::jsonb, 'a', 'نبدأ من 8 ونَعُدّ 1: 9. إذن 8 + 1 = 9.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('54dd9110-9e8f-52bb-9811-738f84d70e76', '62948b29-9db3-5aed-a9e8-59b8a7dd4011', 'كم يساوي 14 + 5؟', '[{"id":"a","text":"9"},{"id":"b","text":"19"},{"id":"c","text":"20"},{"id":"d","text":"18"}]'::jsonb, 'b', 'نجمع الآحاد: 4 + 5 = 9، والعشرات تبقى 1. إذن 14 + 5 = 19.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('24b16315-b429-556b-8bab-b6f108d7bce2', '62948b29-9db3-5aed-a9e8-59b8a7dd4011', 'كم يساوي 23 + 24؟', '[{"id":"a","text":"57"},{"id":"b","text":"37"},{"id":"c","text":"47"},{"id":"d","text":"45"}]'::jsonb, 'c', 'نجمع الآحاد: 3 + 4 = 7، والعشرات: 2 + 2 = 4. إذن 23 + 24 = 47.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('2a501ec8-b0a9-5198-b56b-b9064f08e75c', '62948b29-9db3-5aed-a9e8-59b8a7dd4011', 'كم يساوي 50 + 9؟', '[{"id":"a","text":"14"},{"id":"b","text":"69"},{"id":"c","text":"59"},{"id":"d","text":"60"}]'::jsonb, 'c', 'العدد 50 فيه 5 عشرات و 0 آحاد، نضيف 9 آحاد: 50 + 9 = 59.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('44456f5b-f0f7-54f3-9ee4-e68967233ae4', '62948b29-9db3-5aed-a9e8-59b8a7dd4011', 'كم يساوي 16 + 7؟', '[{"id":"a","text":"13"},{"id":"b","text":"22"},{"id":"c","text":"24"},{"id":"d","text":"23"}]'::jsonb, 'd', 'الآحاد: 6 + 7 = 13، نكتب 3 ونحتفظ بعشرة. العشرات: 1 + 1 = 2. إذن 16 + 7 = 23.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('3a27ac81-df7d-5485-969a-00929d5d1361', '62948b29-9db3-5aed-a9e8-59b8a7dd4011', 'في السلّة 12 برتقالة، أضفنا 11. كم صار العدد؟', '[{"id":"a","text":"23"},{"id":"b","text":"13"},{"id":"c","text":"33"},{"id":"d","text":"21"}]'::jsonb, 'a', 'نجمع الآحاد: 2 + 1 = 3، والعشرات: 1 + 1 = 2. إذن 12 + 11 = 23 برتقالة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('03d69f2a-a081-5827-a170-a344f3cc4147', '9be4e72b-e0d9-5b6c-a6eb-4e70460d7b7f', 'math-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز الجمع', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('214c2396-9825-5ea4-a155-4e4f6873c428', '03d69f2a-a081-5827-a170-a344f3cc4147', 'عددٌ إذا أضفنا إليه 4 صار 11. ما هو؟', '[{"id":"a","text":"15"},{"id":"b","text":"7"},{"id":"c","text":"6"},{"id":"d","text":"8"}]'::jsonb, 'b', 'نبحث عن عددٍ مع 4 يعطي 11: 7 + 4 = 11. إذن العدد 7.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e11c09cc-f684-5507-b331-cf33829b4b0c', '03d69f2a-a081-5827-a170-a344f3cc4147', 'كم يساوي 25 + 25؟', '[{"id":"a","text":"40"},{"id":"b","text":"55"},{"id":"c","text":"50"},{"id":"d","text":"45"}]'::jsonb, 'c', 'الآحاد: 5 + 5 = 10، نكتب 0 ونحتفظ بعشرة. العشرات: 2 + 2 + 1 = 5. إذن 25 + 25 = 50.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bcdae7ac-aedf-5f55-9cbf-92ce72bff640', '03d69f2a-a081-5827-a170-a344f3cc4147', 'ربح بطلٌ 14 نقطة ثمّ 9 نقاط ثمّ 6 نقاط. كم نقطة جمع؟', '[{"id":"a","text":"20"},{"id":"b","text":"30"},{"id":"c","text":"23"},{"id":"d","text":"29"}]'::jsonb, 'd', 'نجمع خطوة خطوة: 14 + 9 = 23، ثمّ 23 + 6 = 29. جمع 29 نقطة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('58e04c6d-bd69-5b60-8e80-0903eee2008e', '03d69f2a-a081-5827-a170-a344f3cc4147', 'ما العدد المفقود؟ 30 + … = 47', '[{"id":"a","text":"27"},{"id":"b","text":"7"},{"id":"c","text":"77"},{"id":"d","text":"17"}]'::jsonb, 'd', 'نبحث عمّا نضيفه إلى 30 لنبلغ 47: الفرق 17، لأنّ 30 + 17 = 47.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b1cf10af-78e6-5d80-9894-26fbd0729d9b', '03d69f2a-a081-5827-a170-a344f3cc4147', 'كم يساوي 38 + 14؟', '[{"id":"a","text":"42"},{"id":"b","text":"52"},{"id":"c","text":"51"},{"id":"d","text":"62"}]'::jsonb, 'b', 'الآحاد: 8 + 4 = 12، نكتب 2 ونحتفظ بعشرة. العشرات: 3 + 1 + 1 = 5. إذن 38 + 14 = 52.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0298fab9-60e5-5b4f-80ac-5f82117802a7', '03d69f2a-a081-5827-a170-a344f3cc4147', 'جمعنا عددين متساويين فحصلنا على 16. ما هما؟', '[{"id":"a","text":"8 و 8"},{"id":"b","text":"6 و 6"},{"id":"c","text":"9 و 9"},{"id":"d","text":"7 و 7"}]'::jsonb, 'a', 'نبحث عن عددٍ مع نفسه يعطي 16: 8 + 8 = 16. إذن العددان 8 و 8.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c5e0120d-c64f-59ef-93fc-74b0ba1ff405', '9be4e72b-e0d9-5b6c-a6eb-4e70460d7b7f', 'math-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للجمع', 3, 120, 30, 'boss', 'admin', 5)
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
  ('ad7a24f6-aa42-57c3-830e-f32b1cfff937', 'c5e0120d-c64f-59ef-93fc-74b0ba1ff405', 'كم يساوي 9 + 6؟', '[{"id":"a","text":"15"},{"id":"b","text":"13"},{"id":"c","text":"16"},{"id":"d","text":"14"}]'::jsonb, 'a', 'نبدأ من 9 ونَعُدّ 6: 10، 11، 12، 13، 14، 15. إذن 9 + 6 = 15.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6b343783-6e05-527d-9ebf-ace568acaec8', 'c5e0120d-c64f-59ef-93fc-74b0ba1ff405', 'كم يساوي 33 + 33؟', '[{"id":"a","text":"63"},{"id":"b","text":"66"},{"id":"c","text":"60"},{"id":"d","text":"36"}]'::jsonb, 'b', 'نجمع الآحاد: 3 + 3 = 6، والعشرات: 3 + 3 = 6. إذن 33 + 33 = 66.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1d163f73-069b-52e5-b483-7b04cdc71d00', 'c5e0120d-c64f-59ef-93fc-74b0ba1ff405', 'كم يساوي 10 + 10 + 10؟', '[{"id":"a","text":"20"},{"id":"b","text":"40"},{"id":"c","text":"13"},{"id":"d","text":"30"}]'::jsonb, 'd', 'نجمع ثلاث عشرات: 10 + 10 = 20، ثمّ 20 + 10 = 30. إذن المجموع 30.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('236d31ad-9e59-55d6-ba71-4d5a48ef62ee', 'c5e0120d-c64f-59ef-93fc-74b0ba1ff405', 'كم يساوي 47 + 8؟', '[{"id":"a","text":"45"},{"id":"b","text":"54"},{"id":"c","text":"55"},{"id":"d","text":"56"}]'::jsonb, 'c', 'الآحاد: 7 + 8 = 15، نكتب 5 ونحتفظ بعشرة. العشرات: 4 + 1 = 5. إذن 47 + 8 = 55.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ad290fb8-1a41-5b8c-9994-1a19664ca7c2', 'c5e0120d-c64f-59ef-93fc-74b0ba1ff405', 'ما العدد المفقود؟ … + 20 = 35', '[{"id":"a","text":"55"},{"id":"b","text":"25"},{"id":"c","text":"5"},{"id":"d","text":"15"}]'::jsonb, 'd', 'نبحث عمّا نضيفه إلى 20 لنبلغ 35: الفرق 15، لأنّ 15 + 20 = 35.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('baf24cba-a820-5220-88cc-d485b9335a9c', 'c5e0120d-c64f-59ef-93fc-74b0ba1ff405', 'في الحديقة 26 وردة حمراء و 17 وردة صفراء. كم وردة في الحديقة؟', '[{"id":"a","text":"33"},{"id":"b","text":"44"},{"id":"c","text":"43"},{"id":"d","text":"53"}]'::jsonb, 'c', 'الآحاد: 6 + 7 = 13، نكتب 3 ونحتفظ بعشرة. العشرات: 2 + 1 + 1 = 4. إذن 26 + 17 = 43 وردة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c999ed86-5b5b-5177-8960-975d80bb1405', '11fdddcd-6630-5b51-9ecd-b4bb22614bb1', 'math-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d5b375e8-c4b7-5e0f-b9b2-61272aa9cb97', 'c999ed86-5b5b-5177-8960-975d80bb1405', 'كم ضلعًا للمثلّث؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"0"}]'::jsonb, 'b', 'المثلّث له 3 أضلاع و 3 زوايا. اسمه نفسه يدلّ على العدد 3 (مثلّث).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('95c9839d-2a8f-52ac-9d17-1695964834f3', 'c999ed86-5b5b-5177-8960-975d80bb1405', 'ما الشكل الذي لا أضلاع له ولا زوايا؟', '[{"id":"a","text":"المربّع"},{"id":"b","text":"المثلّث"},{"id":"c","text":"الدائرة"},{"id":"d","text":"المستطيل"}]'::jsonb, 'c', 'الدائرة شكل مستدير لا أضلاع لها ولا زوايا، مثل العجلة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('29365060-83e3-59e0-81b9-378e9d61af99', 'c999ed86-5b5b-5177-8960-975d80bb1405', 'ما اسم هذا الشكل؟ <svg viewBox="0 0 100 100"><polygon points="50,15 85,85 15,85" fill="none" stroke="currentColor" stroke-width="4"/></svg>', '[{"id":"a","text":"مربّع"},{"id":"b","text":"دائرة"},{"id":"c","text":"مستطيل"},{"id":"d","text":"مثلّث"}]'::jsonb, 'd', 'الشكل له 3 أضلاع و 3 زوايا، فهو مثلّث.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e6127c6c-64ef-586b-b2fd-f09e4e6c6d12', 'c999ed86-5b5b-5177-8960-975d80bb1405', 'كم ضلعًا للمربّع؟', '[{"id":"a","text":"4"},{"id":"b","text":"3"},{"id":"c","text":"5"},{"id":"d","text":"0"}]'::jsonb, 'a', 'المربّع له 4 أضلاع متساوية و 4 زوايا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('712d8311-7d86-5cf7-b085-d34c06711955', 'c999ed86-5b5b-5177-8960-975d80bb1405', 'أيّ شكلٍ كلّ أضلاعه متساوية في الطول؟', '[{"id":"a","text":"المستطيل"},{"id":"b","text":"المربّع"},{"id":"c","text":"الدائرة"},{"id":"d","text":"الباب"}]'::jsonb, 'b', 'المربّع كلّ أضلاعه الأربعة متساوية في الطول، بخلاف المستطيل الذي له ضلعان طويلان وضلعان قصيران.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e46796c9-0d82-59e8-a63f-82ba4c47f3eb', '11fdddcd-6630-5b51-9ecd-b4bb22614bb1', 'math-1ere', '⭐ تمرين: نتعرّف على الأشكال', 1, 50, 10, 'practice', 'admin', 1)
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
  ('f9dbcf87-fa71-5038-8150-e81cff0c41f4', 'e46796c9-0d82-59e8-a63f-82ba4c47f3eb', 'ما اسم هذا الشكل؟ <svg viewBox="0 0 100 100"><rect x="25" y="25" width="50" height="50" fill="none" stroke="currentColor" stroke-width="4"/></svg>', '[{"id":"a","text":"مثلّث"},{"id":"b","text":"مربّع"},{"id":"c","text":"دائرة"},{"id":"d","text":"خطّ"}]'::jsonb, 'b', 'الشكل له 4 أضلاع متساوية و 4 زوايا، فهو مربّع.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('50244701-7dc5-51b0-912a-893925bf227d', 'e46796c9-0d82-59e8-a63f-82ba4c47f3eb', 'ما اسم هذا الشكل؟ <svg viewBox="0 0 100 100"><circle cx="50" cy="50" r="32" fill="none" stroke="currentColor" stroke-width="4"/></svg>', '[{"id":"a","text":"مربّع"},{"id":"b","text":"مثلّث"},{"id":"c","text":"دائرة"},{"id":"d","text":"مستطيل"}]'::jsonb, 'c', 'الشكل مستدير لا أضلاع له ولا زوايا، فهو دائرة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0a9b3458-ae53-599a-965c-50349d34e597', 'e46796c9-0d82-59e8-a63f-82ba4c47f3eb', 'كم زاوية للمربّع؟', '[{"id":"a","text":"4"},{"id":"b","text":"3"},{"id":"c","text":"0"},{"id":"d","text":"2"}]'::jsonb, 'a', 'المربّع له 4 زوايا (أركان) و 4 أضلاع متساوية.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c21d56e4-55a9-5657-aedf-39bdc20d3ceb', 'e46796c9-0d82-59e8-a63f-82ba4c47f3eb', 'أيّ هذه الأشياء يشبه الدائرة؟', '[{"id":"a","text":"الباب"},{"id":"b","text":"الساعة"},{"id":"c","text":"الكتاب"},{"id":"d","text":"علامة الطريق المثلّثة"}]'::jsonb, 'b', 'الساعة شكلها مستدير مثل الدائرة، أمّا الباب والكتاب فمستطيلان.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8ad724e3-853d-5b80-a90a-3577acba26c5', 'e46796c9-0d82-59e8-a63f-82ba4c47f3eb', 'ما اسم هذا الشكل؟ <svg viewBox="0 0 100 100"><rect x="12" y="32" width="76" height="36" fill="none" stroke="currentColor" stroke-width="4"/></svg>', '[{"id":"a","text":"مربّع"},{"id":"b","text":"دائرة"},{"id":"c","text":"مستطيل"},{"id":"d","text":"مثلّث"}]'::jsonb, 'c', 'الشكل له 4 أضلاع، ضلعان طويلان وضلعان قصيران، فهو مستطيل.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e327d39c-d85c-5346-bbfa-bd83c5f0fee1', 'e46796c9-0d82-59e8-a63f-82ba4c47f3eb', 'كم ضلعًا للدائرة؟', '[{"id":"a","text":"4"},{"id":"b","text":"1"},{"id":"c","text":"3"},{"id":"d","text":"0"}]'::jsonb, 'd', 'الدائرة شكل مستدير لا أضلاع له، فعدد أضلاعها 0.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b3648f68-a3d2-553b-9d9f-970daf1b1fa8', '11fdddcd-6630-5b51-9ecd-b4bb22614bb1', 'math-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الأشكال', 3, 120, 30, 'boss', 'admin', 2)
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
  ('42e88bd7-4298-5730-9ada-c7e81feb4adf', 'b3648f68-a3d2-553b-9d9f-970daf1b1fa8', 'شكلٌ له 4 أضلاع متساوية و 4 زوايا. ما هو؟', '[{"id":"a","text":"مربّع"},{"id":"b","text":"مثلّث"},{"id":"c","text":"دائرة"},{"id":"d","text":"مستطيل"}]'::jsonb, 'a', 'الشكل الذي له 4 أضلاع متساوية و 4 زوايا هو المربّع.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8eb0056a-2f68-5659-ace5-52c3c1539389', 'b3648f68-a3d2-553b-9d9f-970daf1b1fa8', 'شكلٌ له 4 أضلاع، ضلعان طويلان وضلعان قصيران. ما هو؟', '[{"id":"a","text":"مربّع"},{"id":"b","text":"مستطيل"},{"id":"c","text":"مثلّث"},{"id":"d","text":"دائرة"}]'::jsonb, 'b', 'الشكل الذي له ضلعان طويلان وضلعان قصيران هو المستطيل (وليس المربّع لأنّ أضلاعه ليست كلّها متساوية).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('3469d23d-88b0-519b-a06c-577b84bc3fba', 'b3648f68-a3d2-553b-9d9f-970daf1b1fa8', 'ما اسم هذا الشكل؟ <svg viewBox="0 0 100 100"><polygon points="20,30 80,30 50,80" fill="none" stroke="currentColor" stroke-width="4"/></svg>', '[{"id":"a","text":"مربّع"},{"id":"b","text":"دائرة"},{"id":"c","text":"مستطيل"},{"id":"d","text":"مثلّث"}]'::jsonb, 'd', 'الشكل له 3 أضلاع و 3 زوايا، فهو مثلّث.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('16dd707b-b85b-5b4c-9a1f-b1865f47cf24', 'b3648f68-a3d2-553b-9d9f-970daf1b1fa8', 'كم زاوية في المثلّث والمربّع معًا؟', '[{"id":"a","text":"6"},{"id":"b","text":"8"},{"id":"c","text":"7"},{"id":"d","text":"5"}]'::jsonb, 'c', 'المثلّث له 3 زوايا والمربّع له 4 زوايا. مجموعهما 3 + 4 = 7 زوايا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0b30c329-dd4f-50eb-a58c-48b235420954', 'b3648f68-a3d2-553b-9d9f-970daf1b1fa8', 'كم ضلعًا في مثلّثين معًا؟', '[{"id":"a","text":"5"},{"id":"b","text":"6"},{"id":"c","text":"3"},{"id":"d","text":"9"}]'::jsonb, 'b', 'لكلّ مثلّث 3 أضلاع، فمثلّثان لهما 3 + 3 = 6 أضلاع.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('2ddfb6aa-fe77-5138-ab94-cdba048833e0', 'b3648f68-a3d2-553b-9d9f-970daf1b1fa8', 'أيّ شكلٍ لا يمكن أن نرسم له زاوية واحدة؟', '[{"id":"a","text":"المربّع"},{"id":"b","text":"المثلّث"},{"id":"c","text":"الدائرة"},{"id":"d","text":"المستطيل"}]'::jsonb, 'c', 'الدائرة مستديرة تمامًا ولا زوايا لها، بخلاف المربّع والمثلّث والمستطيل.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('9661a9ce-6702-5eb7-a8db-fe0ad99ba5b5', '11fdddcd-6630-5b51-9ecd-b4bb22614bb1', 'math-1ere', '⭐⭐ تمرين مراجعة (نمط امتحان): الأشكال الهندسية', 2, 70, 15, 'practice', 'admin', 3)
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
  ('31516993-ac7d-5c36-b2a8-832d0f74dca0', '9661a9ce-6702-5eb7-a8db-fe0ad99ba5b5', 'كم ضلعًا للمستطيل؟', '[{"id":"a","text":"4"},{"id":"b","text":"3"},{"id":"c","text":"0"},{"id":"d","text":"5"}]'::jsonb, 'a', 'المستطيل له 4 أضلاع و 4 زوايا، مثل المربّع، لكن أضلاعه ليست كلّها متساوية.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('7c295116-6718-5a84-b050-94eec0aa3a0a', '9661a9ce-6702-5eb7-a8db-fe0ad99ba5b5', 'ما اسم هذا الشكل؟ <svg viewBox="0 0 100 100"><circle cx="50" cy="50" r="30" fill="none" stroke="currentColor" stroke-width="4"/></svg>', '[{"id":"a","text":"مربّع"},{"id":"b","text":"دائرة"},{"id":"c","text":"مثلّث"},{"id":"d","text":"مستطيل"}]'::jsonb, 'b', 'الشكل مستدير لا أضلاع له ولا زوايا، فهو دائرة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('73bcfe58-1630-513f-beee-478cf44f395f', '9661a9ce-6702-5eb7-a8db-fe0ad99ba5b5', 'كم زاوية للمثلّث؟', '[{"id":"a","text":"4"},{"id":"b","text":"0"},{"id":"c","text":"2"},{"id":"d","text":"3"}]'::jsonb, 'd', 'المثلّث له 3 زوايا و 3 أضلاع.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('21dfd92c-41d5-5f3d-b078-ea3ee660602d', '9661a9ce-6702-5eb7-a8db-fe0ad99ba5b5', 'أيّ هذه الأشياء يشبه المثلّث؟', '[{"id":"a","text":"العجلة"},{"id":"b","text":"الكتاب"},{"id":"c","text":"قطعة البيتزا"},{"id":"d","text":"النافذة المربّعة"}]'::jsonb, 'c', 'قطعة البيتزا شكلها مثلّث (3 أضلاع)، أمّا العجلة فدائرة والكتاب مستطيل.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('94954b82-ff17-5040-88ea-26fb986959b1', '9661a9ce-6702-5eb7-a8db-fe0ad99ba5b5', 'ما الفرق بين المربّع والمستطيل؟', '[{"id":"a","text":"للمربّع أضلاع متساوية، أمّا المستطيل فلا"},{"id":"b","text":"المربّع له 3 أضلاع"},{"id":"c","text":"المستطيل مستدير"},{"id":"d","text":"لا فرق بينهما"}]'::jsonb, 'a', 'كلاهما له 4 أضلاع و 4 زوايا، لكن المربّع كلّ أضلاعه متساوية، أمّا المستطيل فله ضلعان طويلان وضلعان قصيران.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8c1028bf-3751-5191-ba05-1b761e865a00', '9661a9ce-6702-5eb7-a8db-fe0ad99ba5b5', 'أيّ شكلٍ له أكبر عدد من الأضلاع؟', '[{"id":"a","text":"الدائرة"},{"id":"b","text":"المثلّث"},{"id":"c","text":"المربّع"},{"id":"d","text":"النقطة"}]'::jsonb, 'c', 'الدائرة 0 ضلع، والمثلّث 3 أضلاع، والمربّع 4 أضلاع. إذن الأكثر أضلاعًا هو المربّع.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('daff76fa-0f67-533b-9a2e-9428448951b9', '11fdddcd-6630-5b51-9ecd-b4bb22614bb1', 'math-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز الأشكال', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('9c3747af-087a-5c4f-b21a-a76dc8aef922', 'daff76fa-0f67-533b-9a2e-9428448951b9', 'أنا شكلٌ لي عدد أضلاعٍ يساوي عدد أضلاع المربّع ناقص واحد. ما أنا؟', '[{"id":"a","text":"الدائرة"},{"id":"b","text":"المثلّث"},{"id":"c","text":"المستطيل"},{"id":"d","text":"المربّع"}]'::jsonb, 'b', 'المربّع له 4 أضلاع، و 4 − 1 = 3. الشكل ذو 3 أضلاع هو المثلّث.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4d71db59-9f5a-577c-88eb-80ff438c4663', 'daff76fa-0f67-533b-9a2e-9428448951b9', 'ما اسم هذا الشكل؟ <svg viewBox="0 0 100 100"><rect x="30" y="30" width="40" height="40" fill="none" stroke="currentColor" stroke-width="4"/></svg>', '[{"id":"a","text":"مستطيل"},{"id":"b","text":"مربّع"},{"id":"c","text":"دائرة"},{"id":"d","text":"مثلّث"}]'::jsonb, 'b', 'الشكل له 4 أضلاع متساوية في الطول و 4 زوايا، فهو مربّع.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('47214a38-e287-5766-873a-ac45f4385942', 'daff76fa-0f67-533b-9a2e-9428448951b9', 'كم ضلعًا في مربّع ومثلّث معًا؟', '[{"id":"a","text":"6"},{"id":"b","text":"8"},{"id":"c","text":"7"},{"id":"d","text":"4"}]'::jsonb, 'c', 'للمربّع 4 أضلاع وللمثلّث 3 أضلاع. مجموعهما 4 + 3 = 7 أضلاع.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('98f2bbdd-8345-565d-9f28-954ebe69cbbb', 'daff76fa-0f67-533b-9a2e-9428448951b9', 'كم زاوية في ثلاثة مثلّثات معًا؟', '[{"id":"a","text":"6"},{"id":"b","text":"12"},{"id":"c","text":"3"},{"id":"d","text":"9"}]'::jsonb, 'd', 'لكلّ مثلّث 3 زوايا، فثلاثة مثلّثات لها 3 + 3 + 3 = 9 زوايا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('107f4cf2-6dc2-54c0-82fb-e18dd522be77', 'daff76fa-0f67-533b-9a2e-9428448951b9', 'أنا شكلٌ ليس لي أضلاع، وأشبه القمر البدر والعجلة. ما أنا؟', '[{"id":"a","text":"المثلّث"},{"id":"b","text":"المربّع"},{"id":"c","text":"الدائرة"},{"id":"d","text":"المستطيل"}]'::jsonb, 'c', 'الشكل المستدير بلا أضلاع، الذي يشبه القمر والعجلة، هو الدائرة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('25b763c8-45fd-506e-a169-250527a6fc3a', 'daff76fa-0f67-533b-9a2e-9428448951b9', 'إذا جمعنا عدد أضلاع المربّع وعدد أضلاع الدائرة، كم نحصل؟', '[{"id":"a","text":"4"},{"id":"b","text":"8"},{"id":"c","text":"0"},{"id":"d","text":"5"}]'::jsonb, 'a', 'للمربّع 4 أضلاع وللدائرة 0 أضلاع. مجموعهما 4 + 0 = 4.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c3897011-5423-5afd-84e5-852746f6e8c3', '11fdddcd-6630-5b51-9ecd-b4bb22614bb1', 'math-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للأشكال', 3, 120, 30, 'boss', 'admin', 5)
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
  ('4f41d0cc-f870-53e4-96e5-b4793f4f1a0f', 'c3897011-5423-5afd-84e5-852746f6e8c3', 'ما اسم هذا الشكل؟ <svg viewBox="0 0 100 100"><polygon points="50,18 82,82 18,82" fill="none" stroke="currentColor" stroke-width="4"/></svg>', '[{"id":"a","text":"مثلّث"},{"id":"b","text":"مربّع"},{"id":"c","text":"دائرة"},{"id":"d","text":"مستطيل"}]'::jsonb, 'a', 'الشكل له 3 أضلاع و 3 زوايا، فهو مثلّث.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('7af74aa9-2a42-5d2a-971f-8eb9cba7a565', 'c3897011-5423-5afd-84e5-852746f6e8c3', 'كم زاوية للمستطيل؟', '[{"id":"a","text":"3"},{"id":"b","text":"4"},{"id":"c","text":"0"},{"id":"d","text":"2"}]'::jsonb, 'b', 'المستطيل له 4 زوايا و 4 أضلاع، مثل المربّع.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('780ba838-fda6-5e99-8f1f-184f663ada94', 'c3897011-5423-5afd-84e5-852746f6e8c3', 'شكلٌ له 3 أضلاع. ما هو؟', '[{"id":"a","text":"المربّع"},{"id":"b","text":"الدائرة"},{"id":"c","text":"المثلّث"},{"id":"d","text":"المستطيل"}]'::jsonb, 'c', 'الشكل ذو 3 أضلاع و 3 زوايا هو المثلّث.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0a930397-f8d4-589a-89f6-9716075e5eab', 'c3897011-5423-5afd-84e5-852746f6e8c3', 'أيّ هذه الأشياء يشبه المستطيل؟', '[{"id":"a","text":"الساعة المستديرة"},{"id":"b","text":"قطعة البيتزا"},{"id":"c","text":"كرة القدم"},{"id":"d","text":"الباب"}]'::jsonb, 'd', 'الباب شكله مستطيل (4 أضلاع، ضلعان طويلان وضلعان قصيران)، أمّا الساعة والكرة فمستديرتان.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('3267f7ee-e587-5837-8635-7947c3c177f9', 'c3897011-5423-5afd-84e5-852746f6e8c3', 'كم ضلعًا في مربّعين معًا؟', '[{"id":"a","text":"8"},{"id":"b","text":"6"},{"id":"c","text":"4"},{"id":"d","text":"16"}]'::jsonb, 'a', 'لكلّ مربّع 4 أضلاع، فمربّعان لهما 4 + 4 = 8 أضلاع.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a3d2680d-e3b0-549a-987a-cb07b794a161', 'c3897011-5423-5afd-84e5-852746f6e8c3', 'أنا شكلٌ لي 4 أضلاع لكنّها ليست كلّها متساوية. ما أنا؟', '[{"id":"a","text":"المثلّث"},{"id":"b","text":"الدائرة"},{"id":"c","text":"المستطيل"},{"id":"d","text":"المربّع"}]'::jsonb, 'c', 'الشكل ذو 4 أضلاع غير المتساوية كلّها (ضلعان طويلان وضلعان قصيران) هو المستطيل، لا المربّع.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6f702fab-2003-5646-8347-d2999e1a5d15', 'c7ca9bbe-5553-5e50-b49c-51d09d3b52a0', 'math-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('6ea55610-d391-53be-9232-9eada63ddc4c', '6f702fab-2003-5646-8347-d2999e1a5d15', 'الشمس تكون عادةً: <svg viewBox="0 0 120 120"><g stroke="#f59e0b" stroke-width="3" stroke-linecap="round"><path d="M60 8 v10 M60 52 v8 M28 30 l7 6 M92 30 l-7 6 M18 30 h10 M92 30 h10"/></g><circle cx="60" cy="32" r="15" fill="#fbbf24" stroke="#1f2937" stroke-width="2.5"/><circle cx="60" cy="92" r="20" fill="#fcd34d" stroke="#1f2937" stroke-width="2.5"/><circle cx="53" cy="90" r="2" fill="#1f2937"/><circle cx="67" cy="90" r="2" fill="#1f2937"/><path d="M52 99 q8 6 16 0" fill="none" stroke="#1f2937" stroke-width="2" stroke-linecap="round"/></svg>', '[{"id":"a","text":"فوق رأسنا"},{"id":"b","text":"تحت أقدامنا"},{"id":"c","text":"داخل الحقيبة"},{"id":"d","text":"خلف الباب"}]'::jsonb, 'a', 'الشمس في الأعلى في السماء، أي فوق رأسنا.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ca6cf9be-9579-55c5-8689-e58bcc0dc5aa', '6f702fab-2003-5646-8347-d2999e1a5d15', 'أيّ حيوانٍ أكبر؟', '[{"id":"a","text":"الفأر"},{"id":"b","text":"النملة"},{"id":"c","text":"الفيل"},{"id":"d","text":"العصفور"}]'::jsonb, 'c', 'الفيل أكبر من الفأر والنملة والعصفور بكثير. إذن الأكبر هو الفيل.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ff790735-270e-51f6-9edb-19d59cbedfe3', '6f702fab-2003-5646-8347-d2999e1a5d15', 'القلم موضوعٌ في جوف المقلمة. أين هو؟ <svg viewBox="0 0 140 100"><path d="M22 46 H118 V82 H22 Z" fill="#60a5fa" stroke="#1f2937" stroke-width="2.5" stroke-linejoin="round"/><path d="M22 46 q48 -14 96 0" fill="#93c5fd" stroke="#1f2937" stroke-width="2.5"/><rect x="40" y="52" width="60" height="10" rx="2" fill="#fbbf24" stroke="#1f2937" stroke-width="2"/><path d="M100 52 l12 5 -12 5 z" fill="#f472b6" stroke="#1f2937" stroke-width="1.5" stroke-linejoin="round"/><rect x="34" y="52" width="8" height="10" fill="#ef4444" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"خارج المقلمة"},{"id":"b","text":"داخل المقلمة"},{"id":"c","text":"فوق المقلمة"},{"id":"d","text":"خلف المقلمة"}]'::jsonb, 'b', 'ما كان في جوف الشيء فهو داخله، فالقلم داخل المقلمة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('33855e7c-a22e-5b0e-b8e8-303a41fab514', '6f702fab-2003-5646-8347-d2999e1a5d15', 'في الصفّ، السبّورة عادةً تكون: <svg viewBox="0 0 150 110"><rect x="104" y="24" width="40" height="34" rx="3" fill="#16a34a" stroke="#1f2937" stroke-width="2.5"/><circle cx="58" cy="40" r="16" fill="#fcd34d" stroke="#1f2937" stroke-width="2.5"/><path d="M73 37 l9 3 -9 4 z" fill="#fcd34d" stroke="#1f2937" stroke-width="1.5"/><circle cx="66" cy="37" r="1.8" fill="#1f2937"/><path d="M40 62 Q58 55 76 62 L80 100 Q58 106 36 100 Z" fill="#f472b6" stroke="#1f2937" stroke-width="2.5" stroke-linejoin="round"/><path d="M76 68 Q95 64 104 52" fill="none" stroke="#1f2937" stroke-width="5" stroke-linecap="round"/></svg>', '[{"id":"a","text":"خلف التلميذ"},{"id":"b","text":"تحت التلميذ"},{"id":"c","text":"أمام التلميذ"},{"id":"d","text":"داخل التلميذ"}]'::jsonb, 'c', 'التلميذ ينظر نحو السبّورة، فهي أمامه.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8f008999-8932-5f65-a18f-76a37a1b932e', '6f702fab-2003-5646-8347-d2999e1a5d15', 'أيّ شيءٍ أطول؟', '[{"id":"a","text":"القلم"},{"id":"b","text":"العمود الكهربائيّ"},{"id":"c","text":"الملعقة"},{"id":"d","text":"المفتاح"}]'::jsonb, 'b', 'العمود الكهربائيّ أطول بكثير من القلم والملعقة والمفتاح. إذن الأطول هو العمود.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ff384391-e7c4-5cdb-9b75-29f14391b398', 'c7ca9bbe-5553-5e50-b49c-51d09d3b52a0', 'math-1ere', '⭐ تمرين: أين الأشياء؟', 1, 50, 10, 'practice', 'admin', 1)
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
  ('f05c1420-1910-5417-97e2-0dbe2115145e', 'ff384391-e7c4-5cdb-9b75-29f14391b398', 'الطائر يطير في السماء فوق الشجرة. أين الطائر بالنسبة إلى الشجرة؟', '[{"id":"a","text":"تحتها"},{"id":"b","text":"فوقها"},{"id":"c","text":"داخلها"},{"id":"d","text":"خلفها"}]'::jsonb, 'b', 'الطائر في الأعلى، فهو فوق الشجرة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a48c8c76-c8e5-541d-9c62-a58841e5d819', 'ff384391-e7c4-5cdb-9b75-29f14391b398', 'أيّ حيوانٍ أصغر؟', '[{"id":"a","text":"النملة"},{"id":"b","text":"الكلب"},{"id":"c","text":"الحصان"},{"id":"d","text":"البقرة"}]'::jsonb, 'a', 'النملة أصغر بكثير من الكلب والحصان والبقرة. إذن الأصغر هي النملة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('85fecd91-1ca1-5861-a447-6c79af01d3cb', 'ff384391-e7c4-5cdb-9b75-29f14391b398', 'القطّ نائمٌ في الأسفل تحت الكرسيّ. أين القطّ؟', '[{"id":"a","text":"فوق الكرسيّ"},{"id":"b","text":"أمام الكرسيّ"},{"id":"c","text":"تحت الكرسيّ"},{"id":"d","text":"داخل الكرسيّ"}]'::jsonb, 'c', 'ما كان في الأسفل فهو تحت، فالقطّ تحت الكرسيّ.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e1d002ed-36d9-55ab-bca2-4ea0cd62dc0a', 'ff384391-e7c4-5cdb-9b75-29f14391b398', 'الكرة موضوعةٌ في جوف الصندوق. أين الكرة؟', '[{"id":"a","text":"خارج الصندوق"},{"id":"b","text":"داخل الصندوق"},{"id":"c","text":"فوق الصندوق"},{"id":"d","text":"تحت الصندوق"}]'::jsonb, 'b', 'ما كان في جوف الشيء فهو داخله، فالكرة داخل الصندوق.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a404a87b-ebde-55cd-a300-44ff03ae8091', 'ff384391-e7c4-5cdb-9b75-29f14391b398', 'نأكل ونكتب عادةً باليد:', '[{"id":"a","text":"اليُمنى (اليمين)"},{"id":"b","text":"اليُسرى (اليسار)"},{"id":"c","text":"كلتيهما معًا دائمًا"},{"id":"d","text":"لا يدَ نكتب بها"}]'::jsonb, 'a', 'غالبًا نأكل ونكتب باليد اليُمنى، وهي تساعدنا على تذكّر جهة اليمين.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('acd19ce3-e01a-511b-8e45-0310729866f3', 'ff384391-e7c4-5cdb-9b75-29f14391b398', 'أيّ شيءٍ أقصر؟', '[{"id":"a","text":"الشجرة الكبيرة"},{"id":"b","text":"العمود"},{"id":"c","text":"البيت"},{"id":"d","text":"القلم"}]'::jsonb, 'd', 'القلم أقصر بكثير من الشجرة والعمود والبيت. إذن الأقصر هو القلم.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('30300a83-349e-5060-9aef-91b8cd0e95db', 'c7ca9bbe-5553-5e50-b49c-51d09d3b52a0', 'math-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد المواضع', 3, 120, 30, 'boss', 'admin', 2)
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
  ('81458cd3-26ba-56b6-9b66-e7b4fb4f4dc1', '30300a83-349e-5060-9aef-91b8cd0e95db', 'إذا كان الكتاب فوق الطاولة، فأين الطاولة بالنسبة إلى الكتاب؟', '[{"id":"a","text":"تحت الكتاب"},{"id":"b","text":"فوق الكتاب"},{"id":"c","text":"داخل الكتاب"},{"id":"d","text":"خلف الكتاب"}]'::jsonb, 'a', 'إذا كان الكتاب فوق الطاولة، فالطاولة تكون في الأسفل، أي تحت الكتاب.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e81a6e90-c680-5f88-8b01-b09ccdb0bb5d', '30300a83-349e-5060-9aef-91b8cd0e95db', 'السمكة تسبح في جوف الحوض. أين السمكة؟', '[{"id":"a","text":"فوق الحوض"},{"id":"b","text":"داخل الحوض"},{"id":"c","text":"خارج الحوض"},{"id":"d","text":"خلف الحوض"}]'::jsonb, 'b', 'ما كان في جوف الشيء فهو داخله، فالسمكة داخل الحوض.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0b8d987d-c39c-5618-ad43-1632322a40d2', '30300a83-349e-5060-9aef-91b8cd0e95db', 'صفٌّ من الأطفال: أمامك طفلٌ، وخلفك طفلٌ. إذا التفتَّ لتنظر إلى من خلفك، صار:', '[{"id":"a","text":"تحتك"},{"id":"b","text":"أمامك"},{"id":"c","text":"داخلك"},{"id":"d","text":"فوقك"}]'::jsonb, 'b', 'أمام دائمًا في اتّجاه النظر. إذا التفتَّ نحو من كان خلفك صار في اتّجاه نظرك، أي أمامك.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('7b625a66-7035-5e4f-93e5-03d0f920a18c', '30300a83-349e-5060-9aef-91b8cd0e95db', 'ثلاثة أعمدة: قصيرٌ ومتوسّطٌ وطويلٌ. أيُّها ليس الأقصر ولا الأطول؟', '[{"id":"a","text":"القصير"},{"id":"b","text":"الطويل"},{"id":"c","text":"المتوسّط"},{"id":"d","text":"لا شيء منها"}]'::jsonb, 'c', 'الذي ليس الأقصر ولا الأطول هو المتوسّط؛ فهو في الوسط من حيث الطول.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('3e821524-94d3-5f9a-9769-18c2e2d89270', '30300a83-349e-5060-9aef-91b8cd0e95db', 'رتّب من الأكبر إلى الأصغر: نملة، كلب، فيل.', '[{"id":"a","text":"نملة، كلب، فيل"},{"id":"b","text":"كلب، فيل، نملة"},{"id":"c","text":"نملة، فيل، كلب"},{"id":"d","text":"فيل، كلب، نملة"}]'::jsonb, 'd', 'من الأكبر إلى الأصغر: الفيل أكبر، ثمّ الكلب، ثمّ النملة. إذن فيل، كلب، نملة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4ec23861-02da-5501-a72c-e2cd756592e4', '30300a83-349e-5060-9aef-91b8cd0e95db', 'إذا وقف صديقك ووجهُه مقابلٌ لوجهك، فيدُه اليُمنى تكون في جهة:', '[{"id":"a","text":"يمينك أنت"},{"id":"b","text":"فوق رأسك"},{"id":"c","text":"يسارك أنت"},{"id":"d","text":"تحت قدميك"}]'::jsonb, 'c', 'عندما يقابلك شخص ينقلب اليمين واليسار، فتكون يدُه اليُمنى في جهة يسارك أنت.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e9ba10e7-a3d0-547e-af09-64a43f572758', 'c7ca9bbe-5553-5e50-b49c-51d09d3b52a0', 'math-1ere', '⭐⭐ تمرين مراجعة (نمط امتحان): التموقع في الفضاء', 2, 70, 15, 'practice', 'admin', 3)
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
  ('f17793c6-cc59-5f81-83ab-5368d3e4259b', 'e9ba10e7-a3d0-547e-af09-64a43f572758', 'الأرض بالنسبة إلى قدميك تكون:', '[{"id":"a","text":"تحت قدميك"},{"id":"b","text":"فوق رأسك"},{"id":"c","text":"داخل جيبك"},{"id":"d","text":"خلف ظهرك"}]'::jsonb, 'a', 'نمشي على الأرض، فهي في الأسفل تحت قدمينا.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('40d82f98-5706-52e0-9acc-53d0beacef72', 'e9ba10e7-a3d0-547e-af09-64a43f572758', 'المعطف معلّقٌ خارج الخزانة. أين المعطف؟', '[{"id":"a","text":"داخل الخزانة"},{"id":"b","text":"خارج الخزانة"},{"id":"c","text":"تحت الخزانة"},{"id":"d","text":"أمام الخزانة فقط"}]'::jsonb, 'b', 'ما لم يكن في جوف الشيء فهو خارجه، فالمعطف خارج الخزانة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f55e537c-688f-59c8-9756-a6356a7258bd', 'e9ba10e7-a3d0-547e-af09-64a43f572758', 'أيّ شيءٍ أكبر؟', '[{"id":"a","text":"حبّة العنب"},{"id":"b","text":"البطّيخة"},{"id":"c","text":"حبّة الفول"},{"id":"d","text":"حبّة الأرز"}]'::jsonb, 'b', 'البطّيخة أكبر بكثير من حبّة العنب والفول والأرز. إذن الأكبر هي البطّيخة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('938296c0-b318-5d24-8777-9ccf8877170f', 'e9ba10e7-a3d0-547e-af09-64a43f572758', 'أنت تنظر إلى التلفاز. التلفاز يكون:', '[{"id":"a","text":"خلفك"},{"id":"b","text":"تحتك"},{"id":"c","text":"أمامك"},{"id":"d","text":"داخلك"}]'::jsonb, 'c', 'ما تنظر إليه يكون في اتّجاه نظرك، أي أمامك.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0a659fb4-d0f3-5cb6-8f72-fac3277bab51', 'e9ba10e7-a3d0-547e-af09-64a43f572758', 'أيّ شيءٍ أطول؟', '[{"id":"a","text":"الزرافة"},{"id":"b","text":"الأرنب"},{"id":"c","text":"القطّ"},{"id":"d","text":"الدجاجة"}]'::jsonb, 'a', 'الزرافة أطول بكثير من الأرنب والقطّ والدجاجة برقبتها الطويلة. إذن الأطول هي الزرافة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a4340fb8-42d0-5fa7-a0fd-d245209ee1a3', 'e9ba10e7-a3d0-547e-af09-64a43f572758', 'ترفع يدك اليُمنى. أيّ جهةٍ هي؟', '[{"id":"a","text":"اليسار"},{"id":"b","text":"فوق"},{"id":"c","text":"تحت"},{"id":"d","text":"اليمين"}]'::jsonb, 'd', 'اليد اليُمنى تدلّ على جهة اليمين.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b6ca11fb-228d-5718-bece-28e7b27ec720', 'c7ca9bbe-5553-5e50-b49c-51d09d3b52a0', 'math-1ere', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز التموقع', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('8031f090-3d59-56d9-bc6d-d62dec4b20f6', 'b6ca11fb-228d-5718-bece-28e7b27ec720', 'الكتاب فوق الطاولة، والقطّ تحت الطاولة. أيّهما في الأعلى؟', '[{"id":"a","text":"القطّ"},{"id":"b","text":"الكتاب"},{"id":"c","text":"هما في نفس المستوى"},{"id":"d","text":"لا أحد منهما"}]'::jsonb, 'b', 'الكتاب فوق الطاولة (في الأعلى)، والقطّ تحتها (في الأسفل). إذن الكتاب في الأعلى.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ae26e2e9-7ff5-5856-acda-d90e1f37d8ab', 'b6ca11fb-228d-5718-bece-28e7b27ec720', 'حلزونٌ بدأ تحت الورقة ثمّ صعد فوقها. أين هو الآن؟', '[{"id":"a","text":"تحت الورقة"},{"id":"b","text":"داخل الورقة"},{"id":"c","text":"فوق الورقة"},{"id":"d","text":"خلف الورقة"}]'::jsonb, 'c', 'الحلزون صعد إلى الأعلى، فصار الآن فوق الورقة بعد أن كان تحتها.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c8cbb611-2d0f-53ff-91da-10654a7d92ed', 'b6ca11fb-228d-5718-bece-28e7b27ec720', 'في صفٍّ: أمامي سامي، وأمام سامي ليلى. من في المقدّمة؟', '[{"id":"a","text":"أنا"},{"id":"b","text":"سامي"},{"id":"c","text":"ليلى"},{"id":"d","text":"لا أحد"}]'::jsonb, 'c', 'ليلى أمام سامي، وسامي أمامي، فليلى هي الأبعد إلى الأمام، أي في المقدّمة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ad707bfe-a04c-54e4-ab53-bf631ffc148e', 'b6ca11fb-228d-5718-bece-28e7b27ec720', 'رتّب من الأقصر إلى الأطول: عمود، قلم، شجرة.', '[{"id":"a","text":"شجرة، عمود، قلم"},{"id":"b","text":"قلم، شجرة، عمود"},{"id":"c","text":"عمود، قلم، شجرة"},{"id":"d","text":"قلم، عمود، شجرة"}]'::jsonb, 'd', 'من الأقصر إلى الأطول: القلم أقصر، ثمّ العمود، ثمّ الشجرة الكبيرة. إذن قلم، عمود، شجرة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0e613076-a519-5f55-bf80-28b2e61206a3', 'b6ca11fb-228d-5718-bece-28e7b27ec720', 'كرةٌ داخل صندوق، والصندوق داخل خزانة. أين الكرة بالنسبة إلى الخزانة؟', '[{"id":"a","text":"خارج الخزانة"},{"id":"b","text":"داخل الخزانة"},{"id":"c","text":"فوق الخزانة"},{"id":"d","text":"خلف الخزانة"}]'::jsonb, 'b', 'الكرة داخل الصندوق، والصندوق داخل الخزانة، فالكرة أيضًا داخل الخزانة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1f7cd46f-b943-5030-a154-9b5b282861d4', 'b6ca11fb-228d-5718-bece-28e7b27ec720', 'ثلاثة أطفال يقفون مقابلك. يدُك اليُمنى ترفعها، فأيّ يدٍ يرفعها من يقابلك ليكون في الجهة نفسها التي تراها؟', '[{"id":"a","text":"يدُه اليُسرى"},{"id":"b","text":"كلتا يديه"},{"id":"c","text":"يدُه اليُمنى"},{"id":"d","text":"لا يدَ يرفعها"}]'::jsonb, 'a', 'عندما يقابلك شخص ينقلب اليمين واليسار، فيرفع يدَه اليُسرى لتظهر في جهة يمينك أنت.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('483858ac-78e6-510a-9806-afc2e24ce2ea', 'c7ca9bbe-5553-5e50-b49c-51d09d3b52a0', 'math-1ere', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للتموقع في الفضاء', 3, 120, 30, 'boss', 'admin', 5)
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
  ('d49afe62-31b1-5e08-a3fd-6b5645e68208', '483858ac-78e6-510a-9806-afc2e24ce2ea', 'العصفور وقف فوق السلك. أين العصفور؟', '[{"id":"a","text":"فوق السلك"},{"id":"b","text":"تحت السلك"},{"id":"c","text":"داخل السلك"},{"id":"d","text":"خلف السلك"}]'::jsonb, 'a', 'العصفور في الأعلى على السلك، أي فوق السلك.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b6d53087-0db8-52f4-9726-4e47f8bdb808', '483858ac-78e6-510a-9806-afc2e24ce2ea', 'أيّ شيءٍ أصغر؟', '[{"id":"a","text":"السيّارة"},{"id":"b","text":"حبّة الكرز"},{"id":"c","text":"البيت"},{"id":"d","text":"الشاحنة"}]'::jsonb, 'b', 'حبّة الكرز أصغر بكثير من السيّارة والبيت والشاحنة. إذن الأصغر هي حبّة الكرز.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('822bef85-9698-51ab-991f-544dba5097fb', '483858ac-78e6-510a-9806-afc2e24ce2ea', 'النقود موضوعةٌ في جوف المحفظة. أين النقود؟', '[{"id":"a","text":"خارج المحفظة"},{"id":"b","text":"فوق المحفظة"},{"id":"c","text":"داخل المحفظة"},{"id":"d","text":"تحت المحفظة"}]'::jsonb, 'c', 'ما كان في جوف الشيء فهو داخله، فالنقود داخل المحفظة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e4e635b7-158b-5fe6-9a0c-49cf19401c9d', '483858ac-78e6-510a-9806-afc2e24ce2ea', 'تنظر نحو النافذة. النافذة أمامك. ماذا يكون وراء ظهرك؟', '[{"id":"a","text":"ما هو أمامك"},{"id":"b","text":"ما هو خلفك"},{"id":"c","text":"ما هو فوقك"},{"id":"d","text":"ما هو تحتك"}]'::jsonb, 'b', 'ما كان وراء ظهرك يكون خلفك، عكس ما هو أمامك (النافذة).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('761c5ce8-1dee-59f2-b273-2d8b51489fd5', '483858ac-78e6-510a-9806-afc2e24ce2ea', 'رتّب من الأطول إلى الأقصر: شجرة، عشب، شجيرة.', '[{"id":"a","text":"عشب، شجيرة، شجرة"},{"id":"b","text":"شجيرة، شجرة، عشب"},{"id":"c","text":"عشب، شجرة، شجيرة"},{"id":"d","text":"شجرة، شجيرة، عشب"}]'::jsonb, 'd', 'من الأطول إلى الأقصر: الشجرة أطول، ثمّ الشجيرة، ثمّ العشب القصير. إذن شجرة، شجيرة، عشب.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('54780662-1c11-5af1-9245-8c0bc9e7029b', '483858ac-78e6-510a-9806-afc2e24ce2ea', 'إذا كان عليّ على يمين سارة، فأين سارة بالنسبة إلى عليّ؟', '[{"id":"a","text":"فوقه"},{"id":"b","text":"تحته"},{"id":"c","text":"على يساره"},{"id":"d","text":"على يمينه"}]'::jsonb, 'c', 'إذا كان عليّ على يمين سارة، فإنّ سارة تكون على يسار عليّ (الجهتان متعاكستان).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('05710129-dbdf-5746-b9ba-14c9ace5e47b', '9387dc67-fc94-5be6-bc3b-fb8ba75c3b4c', 'math-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('57c1f07c-857a-538f-ab92-dfd8a6bace8e', '05710129-dbdf-5746-b9ba-14c9ace5e47b', 'ماذا نُسمّي كلَّ شيءٍ داخل المجموعة؟', '[{"id":"a","text":"عنصرًا"},{"id":"b","text":"إطارًا"},{"id":"c","text":"فاصلة"},{"id":"d","text":"خاصية"}]'::jsonb, 'a', 'كلُّ شيءٍ داخل المجموعة يُسمّى عنصرًا.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('eeaeaafd-4589-5374-909a-27f375ac998b', '05710129-dbdf-5746-b9ba-14c9ace5e47b', 'كم عنصرًا في هذه المجموعة؟ <svg viewBox="0 0 120 70"><rect x="5" y="5" width="110" height="60" rx="16" fill="none" stroke="currentColor" stroke-width="2.5"/><circle cx="33" cy="35" r="9" fill="currentColor"/><circle cx="60" cy="35" r="9" fill="currentColor"/><circle cx="87" cy="35" r="9" fill="currentColor"/></svg>', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'b', 'نَعُدّ العناصر داخل الإطار: 1، 2، 3. عددها 3.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('317515c6-e897-5eb5-a00b-ca64085b1b81', '05710129-dbdf-5746-b9ba-14c9ace5e47b', 'أيُّ رمزٍ يدلّ على المجموعة الفارغة (بلا أيِّ عنصر)؟', '[{"id":"a","text":"{1}"},{"id":"b","text":"{0}"},{"id":"c","text":"{ }"},{"id":"d","text":"{أ}"}]'::jsonb, 'c', 'المجموعة الفارغة لا تحتوي أيَّ عنصر، نرمز إليها بقوسين فارغين { }. أمّا {0} ففيها عنصرٌ هو 0.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6610461e-5650-5cf7-b199-a8bb34408cc2', '05710129-dbdf-5746-b9ba-14c9ace5e47b', 'أيُّ مجموعةٍ فيها عناصرُ أكثر؟ <svg viewBox="0 0 270 90"><text x="12" y="20" font-size="15" fill="currentColor">A</text><rect x="8" y="26" width="115" height="55" rx="14" fill="none" stroke="currentColor" stroke-width="2.5"/><circle cx="30" cy="53" r="8" fill="currentColor"/><circle cx="55" cy="53" r="8" fill="currentColor"/><circle cx="80" cy="53" r="8" fill="currentColor"/><circle cx="105" cy="53" r="8" fill="currentColor"/><text x="150" y="20" font-size="15" fill="currentColor">B</text><rect x="147" y="26" width="115" height="55" rx="14" fill="none" stroke="currentColor" stroke-width="2.5"/><circle cx="178" cy="53" r="8" fill="currentColor"/><circle cx="210" cy="53" r="8" fill="currentColor"/></svg>', '[{"id":"a","text":"المجموعة A"},{"id":"b","text":"المجموعة B"},{"id":"c","text":"هما على قدر"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'a', 'في A أربعةُ عناصر وفي B عنصران. بما أنّ 4 أكثرُ من 2، فالمجموعة A فيها عناصرُ أكثر.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('10ea2e88-f7e7-596a-8178-46b2dcd6057d', '05710129-dbdf-5746-b9ba-14c9ace5e47b', 'ما العلاقة بين المجموعتين من حيث عددُ العناصر؟ <svg viewBox="0 0 270 90"><text x="12" y="20" font-size="15" fill="currentColor">A</text><rect x="8" y="26" width="115" height="55" rx="14" fill="none" stroke="currentColor" stroke-width="2.5"/><circle cx="30" cy="53" r="8" fill="currentColor"/><circle cx="62" cy="53" r="8" fill="currentColor"/><circle cx="94" cy="53" r="8" fill="currentColor"/><text x="150" y="20" font-size="15" fill="currentColor">B</text><rect x="147" y="26" width="115" height="55" rx="14" fill="none" stroke="currentColor" stroke-width="2.5"/><circle cx="170" cy="53" r="8" fill="currentColor"/><circle cx="202" cy="53" r="8" fill="currentColor"/><circle cx="234" cy="53" r="8" fill="currentColor"/></svg>', '[{"id":"a","text":"A فيها أكثر"},{"id":"b","text":"B فيها أكثر"},{"id":"c","text":"لا يمكن المقارنة"},{"id":"d","text":"هما على قدر"}]'::jsonb, 'd', 'نَصِل عناصر A بعناصر B واحدًا بواحد فتنتهيان معًا (3 و3)، فالمجموعتان على قدر.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('68b5e6f3-0aa3-5b93-95cf-4865ba2d2856', '9387dc67-fc94-5be6-bc3b-fb8ba75c3b4c', 'math-1ere', '⭐ تمرين: نُكوّن المجموعات ونقارنها', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d0528ac2-122b-5c70-bd24-b483f7bf93b3', '68b5e6f3-0aa3-5b93-95cf-4865ba2d2856', 'كيف نُعيّن مجموعةً بذكر عناصرها؟', '[{"id":"a","text":"بين قوسين معقوفين { }"},{"id":"b","text":"بين قوسين عاديين ( )"},{"id":"c","text":"بدون أيِّ أقواس"},{"id":"d","text":"بين خطّين //"}]'::jsonb, 'a', 'نذكر العناصر بين قوسين معقوفين { } ونفصل بينها بفاصلة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('2e34135d-2a32-5fff-b178-e0b05c4690d0', '68b5e6f3-0aa3-5b93-95cf-4865ba2d2856', 'كم عنصرًا في هذه المجموعة؟ <svg viewBox="0 0 95 70"><rect x="5" y="5" width="85" height="60" rx="16" fill="none" stroke="currentColor" stroke-width="2.5"/><circle cx="33" cy="35" r="9" fill="currentColor"/><circle cx="62" cy="35" r="9" fill="currentColor"/></svg>', '[{"id":"a","text":"1"},{"id":"b","text":"2"},{"id":"c","text":"3"},{"id":"d","text":"4"}]'::jsonb, 'b', 'نَعُدّ العناصر داخل الإطار: 1، 2. عددها 2.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6921550d-4aec-5766-bdbc-b731b9f62a2f', '68b5e6f3-0aa3-5b93-95cf-4865ba2d2856', 'المجموعة الفارغة هي التي…', '[{"id":"a","text":"فيها عنصرٌ واحد"},{"id":"b","text":"فيها عنصران"},{"id":"c","text":"لا تحتوي أيَّ عنصر"},{"id":"d","text":"فيها كلُّ الأشياء"}]'::jsonb, 'c', 'المجموعة الفارغة لا تحتوي أيَّ عنصر، ونرمز إليها { }.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bd8cb2ab-b6dc-53f9-9511-c5bef7a9afd4', '68b5e6f3-0aa3-5b93-95cf-4865ba2d2856', 'نريد تكوين مجموعة الأشياء الحمراء. أيَّ شيءٍ نضع فيها؟', '[{"id":"a","text":"تفّاحة حمراء"},{"id":"b","text":"موزة صفراء"},{"id":"c","text":"ورقة خضراء"},{"id":"d","text":"قلم أزرق"}]'::jsonb, 'a', 'نضع فيها ما يحقّق الخاصية (اللون الأحمر): التفّاحة الحمراء.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0a629f5e-a9e7-54fa-a817-f4b0df79653e', '68b5e6f3-0aa3-5b93-95cf-4865ba2d2856', 'أيُّ مجموعةٍ فيها عناصرُ أكثر؟ <svg viewBox="0 0 270 90"><text x="12" y="20" font-size="15" fill="currentColor">A</text><rect x="8" y="26" width="115" height="55" rx="14" fill="none" stroke="currentColor" stroke-width="2.5"/><circle cx="40" cy="53" r="8" fill="currentColor"/><circle cx="80" cy="53" r="8" fill="currentColor"/><text x="150" y="20" font-size="15" fill="currentColor">B</text><rect x="147" y="26" width="115" height="55" rx="14" fill="none" stroke="currentColor" stroke-width="2.5"/><circle cx="170" cy="53" r="8" fill="currentColor"/><circle cx="200" cy="53" r="8" fill="currentColor"/><circle cx="230" cy="53" r="8" fill="currentColor"/><circle cx="185" cy="73" r="8" fill="currentColor"/></svg>', '[{"id":"a","text":"المجموعة A"},{"id":"b","text":"المجموعة B"},{"id":"c","text":"هما على قدر"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'b', 'في A عنصران وفي B أربعةُ عناصر. بما أنّ 4 أكثرُ من 2، فالمجموعة B فيها أكثر.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b4e94c9f-6351-5579-b04a-94eb1c60719d', '68b5e6f3-0aa3-5b93-95cf-4865ba2d2856', 'خمسُ كراتٍ صغيرة وثلاثُ كراتٍ كبيرة: أيُّهما أكثرُ عددًا؟', '[{"id":"a","text":"هما متساويتان"},{"id":"b","text":"الكرات الكبيرة"},{"id":"c","text":"لا يمكن المقارنة"},{"id":"d","text":"الكرات الصغيرة"}]'::jsonb, 'd', 'المقارنة على العدد لا على الحجم: 5 أكثرُ من 3، فالكرات الصغيرة أكثرُ عددًا.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('233463aa-98a1-5cef-aa92-31fd749f8940', '9387dc67-fc94-5be6-bc3b-fb8ba75c3b4c', 'math-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: تحدّي المجموعات', 3, 120, 30, 'boss', 'admin', 2)
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
  ('b163e575-36dc-54c0-8277-ed79cccfc818', '233463aa-98a1-5cef-aa92-31fd749f8940', 'ما هي المجموعة؟', '[{"id":"a","text":"تجمّعٌ لأشياء نعرفها جيّدًا"},{"id":"b","text":"عددٌ كبير"},{"id":"c","text":"رسمٌ ملوّن"},{"id":"d","text":"خطٌّ مغلق فقط"}]'::jsonb, 'a', 'المجموعة تجمّعٌ لأشياء معروفة، وكلُّ شيءٍ فيها عنصر.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('25fc2c23-562d-5670-9003-2b59c84eecfa', '233463aa-98a1-5cef-aa92-31fd749f8940', 'كم عنصرًا في هذه المجموعة؟ <svg viewBox="0 0 175 70"><rect x="5" y="5" width="165" height="60" rx="16" fill="none" stroke="currentColor" stroke-width="2.5"/><circle cx="28" cy="35" r="9" fill="currentColor"/><circle cx="55" cy="35" r="9" fill="currentColor"/><circle cx="82" cy="35" r="9" fill="currentColor"/><circle cx="109" cy="35" r="9" fill="currentColor"/><circle cx="136" cy="35" r="9" fill="currentColor"/></svg>', '[{"id":"a","text":"4"},{"id":"b","text":"5"},{"id":"c","text":"6"},{"id":"d","text":"3"}]'::jsonb, 'b', 'نَعُدّ العناصر داخل الإطار حتّى آخرها: عددها 5.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('13d14a0a-be0f-5681-915a-5982fb7e0043', '233463aa-98a1-5cef-aa92-31fd749f8940', 'أيٌّ من المجموعات التالية فارغةٌ؟', '[{"id":"a","text":"مجموعة أصابع اليد"},{"id":"b","text":"مجموعة أيّام الأسبوع"},{"id":"c","text":"مجموعة الأبقار الطائرة"},{"id":"d","text":"مجموعة ألوان قوس قزح"}]'::jsonb, 'c', 'الأبقار الطائرة لا وجودَ لها، فمجموعتها فارغة { }. أمّا الباقي ففيه عناصر.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('196a7740-e602-5334-8d04-c1a35d50e9bb', '233463aa-98a1-5cef-aa92-31fd749f8940', 'ما العلاقة بين المجموعتين A و B؟ <svg viewBox="0 0 270 90"><text x="12" y="20" font-size="15" fill="currentColor">A</text><rect x="8" y="26" width="115" height="55" rx="14" fill="none" stroke="currentColor" stroke-width="2.5"/><circle cx="30" cy="53" r="8" fill="currentColor"/><circle cx="62" cy="53" r="8" fill="currentColor"/><circle cx="94" cy="53" r="8" fill="currentColor"/><text x="150" y="20" font-size="15" fill="currentColor">B</text><rect x="147" y="26" width="115" height="55" rx="14" fill="none" stroke="currentColor" stroke-width="2.5"/><circle cx="170" cy="53" r="8" fill="currentColor"/><circle cx="202" cy="53" r="8" fill="currentColor"/><circle cx="234" cy="53" r="8" fill="currentColor"/></svg>', '[{"id":"a","text":"A فيها أكثر"},{"id":"b","text":"B فيها أكثر"},{"id":"c","text":"لا يمكن المقارنة"},{"id":"d","text":"هما على قدر"}]'::jsonb, 'd', 'نَصِل عناصر A بعناصر B واحدًا بواحد فتنتهيان معًا (3 و3)، فهما على قدر.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('cb6ad8ff-b716-5944-85b3-29e1dda0cc8f', '233463aa-98a1-5cef-aa92-31fd749f8940', 'نُكوّن مجموعة المثلّثات. أيُّ عنصرٍ **دخيلٌ** لا ينتمي إليها؟', '[{"id":"a","text":"مثلّثٌ أحمر"},{"id":"b","text":"مربّعٌ"},{"id":"c","text":"مثلّثٌ صغير"},{"id":"d","text":"مثلّثٌ كبير"}]'::jsonb, 'b', 'الخاصية هي الشكل: مثلّثاتٌ فقط. المربّعُ دخيلٌ لأنّه ليس مثلّثًا (لونه وحجمه لا يهمّان).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1271ca7e-d044-5832-8b2d-f5ebc4baf771', '233463aa-98a1-5cef-aa92-31fd749f8940', 'مجموعة A فيها 4 عناصر. نَصِل كلَّ عنصرٍ من B بعنصرٍ من A، فيبقى في A عنصرٌ واحدٌ بلا وصل. كم عنصرًا في B؟', '[{"id":"a","text":"3"},{"id":"b","text":"4"},{"id":"c","text":"5"},{"id":"d","text":"2"}]'::jsonb, 'a', 'بقي في A عنصرٌ واحد بلا وصل، فعناصر B أقلُّ من A بواحد: B فيها 3 عناصر (لأنّ 4 ناقص 1 يساوي 3).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('114daf53-74f1-5f08-81ed-cda81f3f7859', '0dd45e0c-5ec2-52bc-b7ea-97b104cb98ee', 'math-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('ab9d8eeb-d6bf-5c6b-bc75-a4ee1a4bd88b', '114daf53-74f1-5f08-81ed-cda81f3f7859', 'بِمَ نَعُدّ المبالغ الصغيرة من النقود في تونس؟', '[{"id":"a","text":"بالمليم (مي)"},{"id":"b","text":"بالمتر"},{"id":"c","text":"باللتر"},{"id":"d","text":"بالكيلوغرام"}]'::jsonb, 'a', 'نَعُدّ المبالغ الصغيرة بالمليم (مي) ؛ أمّا المتر واللتر والكيلوغرام فهي لقيس أشياء أخرى.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('88f81ec7-a9e8-546d-a269-d1dbff37988b', '114daf53-74f1-5f08-81ed-cda81f3f7859', 'أيُّ قطعةٍ نقدية قيمتها أكبر؟', '[{"id":"a","text":"5 مي"},{"id":"b","text":"50 مي"},{"id":"c","text":"10 مي"},{"id":"d","text":"20 مي"}]'::jsonb, 'b', 'نقارن القيم: 50 أكبرُ من 20 ومن 10 ومن 5. فالقطعة 50 مي قيمتها الأكبر.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a346e635-4a08-5fbe-977b-8e1eb7becf74', '114daf53-74f1-5f08-81ed-cda81f3f7859', 'بأيِّ قطعتين نُمثّل المبلغ 7 مي؟', '[{"id":"a","text":"قطعة 10 مي"},{"id":"b","text":"5 مي + 5 مي"},{"id":"c","text":"5 مي + 2 مي"},{"id":"d","text":"2 مي + 2 مي"}]'::jsonb, 'c', 'نبحث عن قطعٍ مجموعها 7: 5 مي + 2 مي = 7 مي. أمّا 5 + 5 = 10 و2 + 2 = 4.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('7667fc44-0053-5465-b222-5e250dd6d151', '114daf53-74f1-5f08-81ed-cda81f3f7859', 'كيف نُمثّل المبلغ 12 مي بأقلِّ عددٍ من القطع؟', '[{"id":"a","text":"10 مي + 2 مي"},{"id":"b","text":"5 مي + 5 مي + 2 مي"},{"id":"c","text":"10 مي + 1 مي + 1 مي"},{"id":"d","text":"2 مي ستّ مرّات"}]'::jsonb, 'a', 'نبدأ بالقطع الكبيرة: 10 مي + 2 مي = 12 مي بقطعتين فقط، وهو أقلُّ عددٍ ممكن.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('657c3cad-54f3-5b84-b47f-b5671ada015b', '114daf53-74f1-5f08-81ed-cda81f3f7859', 'أيُّ مبلغٍ أكبر: 20 مي أم 15 مي؟', '[{"id":"a","text":"هما متساويان"},{"id":"b","text":"15 مي"},{"id":"c","text":"لا يمكن المقارنة"},{"id":"d","text":"20 مي"}]'::jsonb, 'd', 'نقارن القيمتين: 20 أكبرُ من 15. فالمبلغ 20 مي أكبر.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('414b6e21-f57e-5c5e-8121-2e405a8363fb', '0dd45e0c-5ec2-52bc-b7ea-97b104cb98ee', 'math-1ere', '⭐ تمرين: نتعرّف على النقود ونُمثّل المبالغ', 1, 50, 10, 'practice', 'admin', 1)
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
  ('fe5018c7-1549-54da-b69d-75709bc701a0', '414b6e21-f57e-5c5e-8121-2e405a8363fb', 'قطعة 5 مي وقطعة 5 مي معًا: ما المبلغ؟', '[{"id":"a","text":"10 مي"},{"id":"b","text":"5 مي"},{"id":"c","text":"15 مي"},{"id":"d","text":"2 مي"}]'::jsonb, 'a', 'نجمع القيمتين: 5 مي + 5 مي = 10 مي.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('38973286-cfbb-5412-94ce-bcfa3beefc4f', '414b6e21-f57e-5c5e-8121-2e405a8363fb', 'أيُّ قطعةٍ قيمتها الأصغر؟', '[{"id":"a","text":"50 مي"},{"id":"b","text":"5 مي"},{"id":"c","text":"20 مي"},{"id":"d","text":"10 مي"}]'::jsonb, 'b', 'نقارن القيم: 5 أصغرُ من 10 ومن 20 ومن 50. فالقطعة 5 مي قيمتها الأصغر.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('00aea2ff-f589-5546-aa82-9c520958e7bd', '414b6e21-f57e-5c5e-8121-2e405a8363fb', 'أكمل: المبلغ 6 مي = 5 مي + ؟', '[{"id":"a","text":"2 مي"},{"id":"b","text":"1 مي"},{"id":"c","text":"5 مي"},{"id":"d","text":"10 مي"}]'::jsonb, 'b', 'نبحث عمّا نضيفه إلى 5 لنحصل على 6: بما أنّ 5 + 1 = 6، فالجواب قطعة 1 مي.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0f79b8ae-d296-5598-be7a-2d036fbd409f', '414b6e21-f57e-5c5e-8121-2e405a8363fb', 'كيف نُمثّل المبلغ 30 مي بأقلِّ عددٍ من القطع؟', '[{"id":"a","text":"20 مي + 10 مي"},{"id":"b","text":"10 مي + 10 مي + 10 مي"},{"id":"c","text":"20 مي + 5 مي + 5 مي"},{"id":"d","text":"5 مي ستّ مرّات"}]'::jsonb, 'a', 'نبدأ بالقطع الكبيرة: 20 مي + 10 مي = 30 مي بقطعتين، وهو أقلُّ عددٍ ممكن.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('828a7ef0-eec4-5e78-8dc9-9ec722bdf1ab', '414b6e21-f57e-5c5e-8121-2e405a8363fb', 'أيُّ مبلغٍ أكبر: 12 مي أم 21 مي؟', '[{"id":"a","text":"هما متساويان"},{"id":"b","text":"21 مي"},{"id":"c","text":"12 مي"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'b', 'نقارن القيمتين: 21 أكبرُ من 12. فالمبلغ 21 مي أكبر.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('5bbab080-cb30-5098-aa91-55c9ebbe190c', '414b6e21-f57e-5c5e-8121-2e405a8363fb', '10 مي + 2 مي + 2 مي = ؟', '[{"id":"a","text":"12 مي"},{"id":"b","text":"16 مي"},{"id":"c","text":"14 مي"},{"id":"d","text":"20 مي"}]'::jsonb, 'c', 'نجمع القيم خطوةً خطوة: 10 + 2 = 12، ثمّ 12 + 2 = 14. فالمبلغ 14 مي.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('fe3e5a21-40d3-5b50-bcde-153b19eab088', '0dd45e0c-5ec2-52bc-b7ea-97b104cb98ee', 'math-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: تحدّي النقود', 3, 120, 30, 'boss', 'admin', 2)
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
  ('d21763cc-2b22-5328-8187-379282479f50', 'fe3e5a21-40d3-5b50-bcde-153b19eab088', '20 مي + 20 مي + 10 مي = ؟', '[{"id":"a","text":"40 مي"},{"id":"b","text":"50 مي"},{"id":"c","text":"45 مي"},{"id":"d","text":"60 مي"}]'::jsonb, 'b', 'نجمع القيم خطوةً خطوة: 20 + 20 = 40، ثمّ 40 + 10 = 50. فالمبلغ 50 مي.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('48152f8d-0746-5301-9a00-023d6102be87', 'fe3e5a21-40d3-5b50-bcde-153b19eab088', 'أيُّ تمثيلٍ صحيحٌ للمبلغ 17 مي؟', '[{"id":"a","text":"10 مي + 5 مي + 2 مي"},{"id":"b","text":"10 مي + 5 مي + 5 مي"},{"id":"c","text":"10 مي + 2 مي + 2 مي"},{"id":"d","text":"5 مي + 5 مي + 5 مي"}]'::jsonb, 'a', 'نتحقّق: 10 + 5 + 2 = 17 ✓. أمّا 10 + 5 + 5 = 20، و 10 + 2 + 2 = 14، و 5 + 5 + 5 = 15.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('52d2cfb0-2bbc-5ee2-8291-b59ea666195e', 'fe3e5a21-40d3-5b50-bcde-153b19eab088', 'أيُّهما أكبرُ قيمةً: قطعةٌ واحدة من 50 مي، أم ستُّ قطعٍ من 5 مي؟', '[{"id":"a","text":"القطعة 50 مي"},{"id":"b","text":"الستُّ قطعٍ من 5 مي"},{"id":"c","text":"هما متساويتان"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'a', 'قيمة الستّ قطع: 6 مرّات 5 مي = 30 مي. وبما أنّ 50 أكبرُ من 30، فالقطعة 50 مي أكبرُ قيمة. الخطأ الشائع: الظنّ أنّ عددَ القطع الأكثر = القيمة الأكبر.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('68f60f29-037b-5f02-a008-f199b7681422', 'fe3e5a21-40d3-5b50-bcde-153b19eab088', 'نُمثّل المبلغ 35 مي بأقلِّ عددٍ من القطع. كم قطعةً نحتاج؟', '[{"id":"a","text":"قطعتان"},{"id":"b","text":"أربع قطع"},{"id":"c","text":"ثلاث قطع"},{"id":"d","text":"خمس قطع"}]'::jsonb, 'c', 'نبدأ بالكبيرة: 20 مي + 10 مي + 5 مي = 35 مي، أي ثلاث قطع، وهو أقلُّ عددٍ ممكن.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('3f6be308-ae5d-55b2-bec6-bf7ec01ca9cc', 'fe3e5a21-40d3-5b50-bcde-153b19eab088', 'أيُّ مجموعةٍ من القطع قيمتها 25 مي؟', '[{"id":"a","text":"20 مي + 10 مي"},{"id":"b","text":"10 مي + 10 مي"},{"id":"c","text":"5 مي + 5 مي + 5 مي"},{"id":"d","text":"20 مي + 5 مي"}]'::jsonb, 'd', 'نتحقّق: 20 + 5 = 25 ✓. أمّا 20 + 10 = 30، و 10 + 10 = 20، و 5 + 5 + 5 = 15.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('60d28e3d-2db2-5040-a9d3-4b0441bcc280', 'fe3e5a21-40d3-5b50-bcde-153b19eab088', 'المجموعة أ: 10 مي + 10 مي. المجموعة ب: 5 مي + 5 مي + 5 مي + 5 مي. أيُّهما أكبرُ قيمةً؟', '[{"id":"a","text":"المجموعة أ"},{"id":"b","text":"المجموعة ب"},{"id":"c","text":"هما متساويتان"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'c', 'قيمة أ: 10 + 10 = 20 مي. قيمة ب: 5 + 5 + 5 + 5 = 20 مي. القيمتان متساويتان (20 = 20).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('319e37ed-ef8f-5cfe-984e-63bc6aa907ab', 'd24bb485-faf9-5d35-b3f7-7067c0990995', 'math-1ere', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('b4f4f774-745c-5995-96db-95a149207b39', '319e37ed-ef8f-5cfe-984e-63bc6aa907ab', 'الخطّ الذي له طرفان غير متّصلين (فيه فتحة) يُسمّى…', '[{"id":"a","text":"خطًّا مفتوحًا"},{"id":"b","text":"خطًّا مغلقًا"},{"id":"c","text":"نقطة"},{"id":"d","text":"زاوية"}]'::jsonb, 'a', 'الخطّ المفتوح له طرفان غير متّصلين، أي فيه فتحة، ولا يحيط بمكان.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bbaaae38-2cb3-5908-8bfb-fbf1906e4f98', '319e37ed-ef8f-5cfe-984e-63bc6aa907ab', 'هل هذا الخطّ مفتوحٌ أم مغلق؟ <svg viewBox="0 0 130 80"><ellipse cx="65" cy="40" rx="50" ry="28" fill="none" stroke="currentColor" stroke-width="3"/></svg>', '[{"id":"a","text":"مفتوح"},{"id":"b","text":"مغلق"},{"id":"c","text":"ليس خطًّا"},{"id":"d","text":"نقطة"}]'::jsonb, 'b', 'الخطّ يدور ويعود إلى بدايته دون فتحة، فهو خطٌّ مغلق.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1ced8c76-f97b-572b-9591-3fe269277028', '319e37ed-ef8f-5cfe-984e-63bc6aa907ab', 'هل هذا الخطّ مفتوحٌ أم مغلق؟ <svg viewBox="0 0 140 60"><path d="M10,30 Q40,5 70,30 Q100,55 130,30" fill="none" stroke="currentColor" stroke-width="3"/></svg>', '[{"id":"a","text":"مفتوح"},{"id":"b","text":"مغلق"},{"id":"c","text":"دائرة"},{"id":"d","text":"مربّع"}]'::jsonb, 'a', 'للخطّ طرفان غير متّصلين وفيه فتحة، فهو خطٌّ مفتوح.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bb954a72-de8c-5adc-842c-9791c95c7f84', '319e37ed-ef8f-5cfe-984e-63bc6aa907ab', 'الخطّ المغلق يفصل المكان بين…', '[{"id":"a","text":"الكبير والصغير"},{"id":"b","text":"الطويل والقصير"},{"id":"c","text":"الداخل والخارج"},{"id":"d","text":"اليمين واليسار"}]'::jsonb, 'c', 'الخطّ المغلق يفصل بين ما هو داخله وما هو خارجه (وما هو على الخطّ نفسه).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c480088c-872b-5aea-98fe-d561153ea836', '319e37ed-ef8f-5cfe-984e-63bc6aa907ab', 'النقطة الموضّحة: هل هي داخل الخطّ المغلق أم خارجه؟ <svg viewBox="0 0 130 80"><ellipse cx="65" cy="40" rx="50" ry="28" fill="none" stroke="currentColor" stroke-width="3"/><circle cx="65" cy="40" r="5" fill="currentColor"/></svg>', '[{"id":"a","text":"خارج الخطّ"},{"id":"b","text":"داخل الخطّ"},{"id":"c","text":"على الخطّ"},{"id":"d","text":"لا يمكن أن نعرف"}]'::jsonb, 'b', 'النقطة محصورةٌ داخل الخطّ المغلق، فهي داخل الخطّ.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('05d02cff-e594-5686-87e3-5ffa51aa8847', 'd24bb485-faf9-5d35-b3f7-7067c0990995', 'math-1ere', '⭐ تمرين: الخطّ المفتوح والخطّ المغلق', 1, 50, 10, 'practice', 'admin', 1)
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
  ('09a51142-6ae5-5691-82a0-35fae3413d70', '05d02cff-e594-5686-87e3-5ffa51aa8847', 'ما هي صفةُ الخطّ المفتوح؟', '[{"id":"a","text":"له طرفان وفيه فتحة"},{"id":"b","text":"يدور ويعود إلى بدايته دون فتحة"},{"id":"c","text":"يحيط دائمًا بمكان"},{"id":"d","text":"هو نقطة واحدة"}]'::jsonb, 'a', 'الخطّ المفتوح له طرفان غير متّصلين، أي فيه فتحة، ولا يحيط بمكان.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0aa1c485-16a8-5cd6-88bd-40619c7645e1', '05d02cff-e594-5686-87e3-5ffa51aa8847', 'هذا الخطّ: مفتوحٌ أم مغلق؟ <svg viewBox="0 0 130 80"><ellipse cx="65" cy="40" rx="50" ry="28" fill="none" stroke="currentColor" stroke-width="3"/></svg>', '[{"id":"a","text":"مفتوح"},{"id":"b","text":"مغلق"},{"id":"c","text":"نقطة"},{"id":"d","text":"زاوية"}]'::jsonb, 'b', 'يدور الخطّ ويعود إلى بدايته دون فتحة، فهو خطٌّ مغلق.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('dcf7d2a0-2a72-518d-a6e2-62176e3d4788', '05d02cff-e594-5686-87e3-5ffa51aa8847', 'هذا الخطّ: مفتوحٌ أم مغلق؟ <svg viewBox="0 0 140 60"><path d="M10,30 Q40,5 70,30 Q100,55 130,30" fill="none" stroke="currentColor" stroke-width="3"/></svg>', '[{"id":"a","text":"مغلق"},{"id":"b","text":"مفتوح"},{"id":"c","text":"دائرة"},{"id":"d","text":"مربّع"}]'::jsonb, 'b', 'للخطّ طرفان غير متّصلين وفيه فتحة، فهو خطٌّ مفتوح.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('91081dad-89b7-546e-a814-17914e20f367', '05d02cff-e594-5686-87e3-5ffa51aa8847', 'السور حول الحديقة مثالٌ على خطّ…', '[{"id":"a","text":"مفتوح"},{"id":"b","text":"مستقيم"},{"id":"c","text":"مغلق"},{"id":"d","text":"قصير"}]'::jsonb, 'c', 'السور يدور حول الحديقة ويعود إلى بدايته فيحيط بها، فهو خطٌّ مغلق.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d61d4f2e-6cc3-59f6-95e6-62489ea43801', '05d02cff-e594-5686-87e3-5ffa51aa8847', 'الطريق المستقيم بين مدينتين مثالٌ على خطّ…', '[{"id":"a","text":"مغلق"},{"id":"b","text":"دائري"},{"id":"c","text":"محيط"},{"id":"d","text":"مفتوح"}]'::jsonb, 'd', 'للطريق طرفان (بداية ونهاية) ولا يحيط بمكان، فهو خطٌّ مفتوح.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('798001d9-de2f-5304-8dbf-af2c92051a2c', '05d02cff-e594-5686-87e3-5ffa51aa8847', 'أين تقع النقطة بالنسبة إلى الخطّ المغلق؟ <svg viewBox="0 0 150 80"><ellipse cx="80" cy="40" rx="45" ry="26" fill="none" stroke="currentColor" stroke-width="3"/><circle cx="18" cy="16" r="5" fill="currentColor"/></svg>', '[{"id":"a","text":"على الخطّ"},{"id":"b","text":"داخل الخطّ"},{"id":"c","text":"لا يمكن أن نعرف"},{"id":"d","text":"خارج الخطّ"}]'::jsonb, 'd', 'النقطة تقع بعيدًا عن داخل الخطّ المغلق، فهي خارج الخطّ.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('41110ff6-a42d-50ea-8f73-9eb52104c886', 'd24bb485-faf9-5d35-b3f7-7067c0990995', 'math-1ere', '⚔️ زعيم الفصل ⭐⭐⭐: تحدّي الخطوط', 3, 120, 30, 'boss', 'admin', 2)
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
  ('02148af8-f7e8-5e5d-ae98-cfe38749084d', '41110ff6-a42d-50ea-8f73-9eb52104c886', 'ما صفةُ الخطّ المغلق؟', '[{"id":"a","text":"له طرفان حرّان"},{"id":"b","text":"يدور ويعود إلى بدايته دون فتحة"},{"id":"c","text":"مستقيمٌ قصير"},{"id":"d","text":"نقطة واحدة"}]'::jsonb, 'b', 'الخطّ المغلق ليس له طرفان: يدور ويعود إلى نقطة انطلاقه دون فتحة، فيحيط بمكان.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('aa455f9a-a0ba-5bb6-82eb-4d83de3a3fe5', '41110ff6-a42d-50ea-8f73-9eb52104c886', 'هذا الخطّ: مفتوحٌ أم مغلق؟ <svg viewBox="0 0 130 60"><path d="M10,45 L35,15 L60,45 L85,15 L110,45" fill="none" stroke="currentColor" stroke-width="3"/></svg>', '[{"id":"a","text":"مفتوح"},{"id":"b","text":"مغلق"},{"id":"c","text":"دائرة"},{"id":"d","text":"مثلّث"}]'::jsonb, 'a', 'رغم انكساره، للخطّ طرفان غير متّصلين وفيه فتحة، فهو خطٌّ مفتوح.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4ad3dd38-a71a-57dd-8713-7b9e2be897ec', '41110ff6-a42d-50ea-8f73-9eb52104c886', 'لِنُحيط بحديقةٍ بسور، أيَّ نوعٍ من الخطوط نحتاج؟', '[{"id":"a","text":"خطًّا مفتوحًا"},{"id":"b","text":"خطًّا مستقيمًا"},{"id":"c","text":"خطًّا قصيرًا"},{"id":"d","text":"خطًّا مغلقًا"}]'::jsonb, 'd', 'لِنُحيط بمكانٍ ونفصل داخله عن خارجه نحتاج خطًّا مغلقًا (دون فتحة).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ef3a3a5c-c0eb-5614-b38e-188b9480e7b1', '41110ff6-a42d-50ea-8f73-9eb52104c886', 'أين تقع النقطة بالنسبة إلى الخطّ المغلق؟ <svg viewBox="0 0 160 80"><ellipse cx="80" cy="45" rx="45" ry="26" fill="none" stroke="currentColor" stroke-width="3"/><circle cx="80" cy="19" r="5" fill="currentColor"/></svg>', '[{"id":"a","text":"داخل الخطّ"},{"id":"b","text":"خارج الخطّ"},{"id":"c","text":"على الخطّ"},{"id":"d","text":"لا يمكن أن نعرف"}]'::jsonb, 'c', 'النقطة تقع فوق الخطّ نفسه (عند حافّته)، فهي على الخطّ، لا داخله ولا خارجه.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('9c5d925f-8ddb-5b8d-97dd-67ec37f8f98c', '41110ff6-a42d-50ea-8f73-9eb52104c886', 'خطٌّ منحنٍ لكنّ له طرفين وفيه فتحة. هل هو مفتوحٌ أم مغلق؟', '[{"id":"a","text":"مفتوح لأنّ له فتحة"},{"id":"b","text":"مغلق لأنّه منحنٍ"},{"id":"c","text":"ليس خطًّا"},{"id":"d","text":"نقطة"}]'::jsonb, 'a', 'العبرة بالفتحة لا بشكل الخطّ: ما دام فيه فتحةٌ وطرفان فهو مفتوح، حتّى لو كان منحنيًا. الخطأ الشائع: الظنّ أنّ كلَّ منحنٍ مغلق.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d5f07ccd-ba36-5b7b-8a93-a290e3a15e6a', '41110ff6-a42d-50ea-8f73-9eb52104c886', 'أيُّ عبارةٍ **خاطئة**؟', '[{"id":"a","text":"الخطّ المغلق يحيط بمكان"},{"id":"b","text":"كلُّ خطٍّ منحنٍ مغلق"},{"id":"c","text":"الخطّ المفتوح له طرفان"},{"id":"d","text":"الخطّ المغلق يفصل الداخل عن الخارج"}]'::jsonb, 'b', 'العبارة الخاطئة هي «كلُّ خطٍّ منحنٍ مغلق»: المنحنى قد يكون مفتوحًا إن كان فيه فتحة. أمّا بقيّة العبارات فصحيحة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
      AND e.subject_id = 'math-1ere'
      AND e.source = 'admin';
  END IF;
END $$;

