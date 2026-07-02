-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: anglais-c2 (English — Mastery (C2))
-- Regenerate with: npm run content:build
-- Source of truth: content/anglais-c2/
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
  ('anglais-c2', 'English — Mastery (C2)', 'Reach near-native mastery: the subjunctive and unreal past, idiomatic and figurative language, formal register and nominalisation, nuance and confusable words, and ellipsis with cohesive substitution. CEFR C2 — the pinnacle of English precision.', 'Agilité', 'subject-english', 'Globe', 6, 'en', false, 'anglais', NULL)
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
      AND e.subject_id = 'anglais-c2'
      AND e.source = 'admin'
      AND q.id NOT IN ('fe8e22c6-0b1a-5825-a215-8d950e8d4bb1', 'd2a4513b-690b-5b4f-a8c0-51b08868c6fe', '680a95b8-6440-5834-9187-57e73b786a53', '6650c2a7-fd06-52f4-afd6-08727dfa23c1', '5f2c994e-ba89-590a-886f-d428c3a9866c', '8fe292a6-48d2-55b8-bf0e-995c0f7ef8a6', '0e4c5d72-3948-55c1-a831-64c504b75756', 'd8b02cdc-f07d-5388-8a0d-97955955a9ef', 'cf1952b4-607e-5a18-82cc-9fb4a92f486a', '00d2afb4-d2dc-5a33-85ab-f3189c1c5e53', '29053b29-9aeb-5473-8906-8317a99ae4cc', 'a6d7e5f6-ee92-5eaa-a992-349024038808', 'ea964b7c-4c1c-5858-984b-02106f04b2c4', '482f3c52-40da-5f76-8500-57942fb0785a', '9a39d9a1-cb97-50d8-95a4-d9590c812a52', 'd2f68d8c-7be9-532c-ab19-72018f0a5a6e', '67e4cd98-3c2d-52dc-bfea-22fa62746d38', 'f0f8ff6e-b81a-5c93-82b5-bfb001238dba', '87bea223-fa9a-548b-9f57-f42af545212c', 'c9b3e3a1-62dd-5ab1-86bf-5cb92f69f838', 'd7571029-6fb7-5678-93e9-c5828664d2e3', 'b5b69a17-c40f-5d62-b6ee-96c2433f1fbd', 'd566febb-b341-5149-8cb0-8e6a8d44e3c0', '19dfe3d9-d087-5b5b-876c-cc18562b41e3', '81f4bb31-c53e-5583-bd29-d970bb0c9e77', 'e9ac13b2-ec8e-51f1-aebb-28244c323f7f', 'cee9dd38-eca4-555d-85cf-7d58c7a8c822', 'ba80a72b-182a-5726-a43f-4bcd105cc7e3', '248b1e79-a72b-5089-bbd9-754c9b3a5a48', 'd1a249b5-7e9c-56b6-acfd-819ef3c3e123', '6012c3c6-ffb1-5dfd-bbf9-e557f26f21a7', 'bd633468-25de-5d0e-9493-9d1624d27b68', '81cb6c1f-486a-518d-94f6-8b9b5b4237e1', '0a9833f0-be4f-5009-ade9-73c09eb5b936', '5ae976f0-4d56-5355-b7c2-b09d8591d95c', 'eb0ce85d-a5b5-5376-8b9b-71a2e06a775b', '13804d18-1dbf-580a-a4fd-b4bccb68ae6a', '371aadf7-ee82-5eb4-ac99-4436f6c31e39', '51ed5ed9-dbf6-5e43-9851-bbd3109a67ee', '343dbad2-ac63-5516-8e15-9413c60de40b', 'f03c20da-e89c-50bd-b2fe-a926e235a117', '1ae28c28-430c-5d65-82e1-94d07a815eb2', '0362bb33-5b16-5afc-b608-8ff2af518a88', '94a296fe-932c-5c3d-86f5-85e3bea5fdbb', '9feeb36d-255c-5f61-b4a5-1aec82befe87', '80502f3c-5f7e-5023-9ddb-77c6f0bf25f8', 'cfef25e1-9516-5a67-a557-c59815693359', '88ef3c36-6b27-5c6d-b9c4-fbd7d8692755', 'd27e62b8-1532-5823-a5c9-2fc1408c324f', 'bc73bcbc-cb4b-5aea-b5a3-af5d84258aa2', '10938362-4f8f-5857-94fe-ac8230d71682', '17c27c03-0384-5c61-b4fb-c9dd5dd5edad', '9ff3218c-fbf2-59b3-9659-c90b4558ed08', '6e62b2c1-f98a-5314-9476-3d683b0a2c2e', '370807f2-ab1d-5676-89a4-a64f22cab6f1', '5876c79b-ed26-594c-ba0f-91341c7950dd', '831b69e7-e817-513e-ae32-daddb5eb6706', 'dd7aecbf-9807-5656-a262-c0f2c30f0626', '6af83164-4e53-5a75-af9b-1d6bee671884', '89eb4adc-f710-5588-b49f-540bdd1d516e', '6439b7e0-2866-5f56-b21e-6174abf080cd', 'e3de5aed-6a62-5492-a23b-b65139c719c4', '76162ccc-0fdf-5c36-8497-0ee42acbb3a4', '5b99ee85-e583-5e34-a8d8-8f6cf06e568f', 'a68a5b50-d4a8-536f-9ddf-8917f4badb10', 'd7370c67-d990-5555-b7d5-85c74883ceb2', 'd0ffd553-a09f-5408-853b-a6e4e6d62340', 'f4ecad86-4579-5c84-afbd-be409e212cbd', '49535f59-f254-5d94-9110-8c1baf040d9a', '8cc4aa9e-8b78-5473-9b06-bf0a99dd1f15', '4afd0cc0-1dbd-5eed-a5f3-6c96db188e87', '94e51584-e60b-5e5c-a076-993cb64d9a40', 'a27457a2-ffb3-5394-88ac-60547ed48eac', '1ec57d83-cc7f-507d-9eaa-c3995257ee3a', '5f3cc008-7e38-58b0-914b-6e4522b0d899', 'dc9f1e2e-8c1d-5b23-8b24-11b8d184eae9', '80fdf985-ee6c-5785-b175-7fb5b7caa263', '069a31ce-e520-560c-8407-1c9a67c8bdad', 'e0b8875d-deda-506e-abd6-c136f5938792', '9298ed8c-dc6c-5b5a-9b31-d3b742433747', 'c2858220-6a2a-5ade-b7c2-2f5ad26b897b', 'd26d7b52-b5ff-581b-b308-2a33e26c2761', '264e22d8-cd0c-51e7-9857-f1e264b547fe', 'a60d6157-f9ed-58b0-b04b-cbac96489734', '9bd2eb0b-d929-5553-9e3a-00e0a2bf8b54', 'e1bd1c5b-00a3-53ec-a3fc-e893d9c17272', '4f4f46b7-2398-59f4-bef8-a76a323ced7f', '16c3df9f-baa5-5b3b-a8cf-ac4cc8f2d5fd', 'a48cb938-9423-5896-bbbd-1b78fe1cd771', 'bb7434c3-0278-50e5-8969-d2fd82d828f7', '4fdb4d20-e550-52df-98d2-29b4e709b67c', 'df1ca3d7-2078-535d-945a-eb5682dcef38', '3953ae02-18ee-5e31-a942-61d5fe8b1b83', '6aec6fac-7c21-5d8a-b50d-e7fd17189c41', '2ac5d9a0-0ea8-52f6-958a-c71fffdc2b5c', 'ee7547b0-c1d6-5dd7-acf2-b6b4a1e245e1', '62de42b6-faaf-592a-8879-b6849fb4c3b9', '8382d959-a78a-5448-bed6-0af18c99b06e', 'a989d97f-13ad-5654-900e-7c3bd78a584c', '293aaae9-411d-590d-aa48-5a8b576c6ab5', 'dcca13f8-c973-5f35-8c10-031950be20e1', '5ca71847-bc51-539f-b9a1-3e93b071a7c2', '46020b3e-6759-5b1e-ab19-648b462657bc', '5687c90e-fbb3-5d8d-aa3d-b325b84bdb5f', '633715de-2511-5d43-af00-f24f9900f34e', '920fac69-8575-58dd-b5d8-0284b66a3059', '99861f17-a7f2-5454-bb30-4a821f77efb5', '550495a8-a78c-5c11-9e67-44b2102c9cd1', 'c83d25dc-b65a-5795-9070-216fca32404b', 'faeb109b-3226-5ab8-9082-befd38169896', '956a4c0f-264a-5e04-9047-47eeed4f325b', '16172beb-834f-5207-979f-325c1f13fe77', '97b70d59-a9e7-5b0b-88fe-65bcb6ec9420', '58c78246-bb0a-5d05-aa99-caf4d7fe82e8', 'a20e2408-0f3b-5326-a036-93c4524e884e', 'f2c6c350-4944-565c-930a-2a303fcc3e11', '2d122806-9e40-5d8f-ad26-82e100ac6a17', 'e088883a-f3dd-5168-81c7-83ddcca3b094', 'b117e20c-8993-5a8f-891d-86f9677a149f', '7050af91-e097-5b32-9445-5448c62348e1', 'b3a0d3af-49e4-5485-a07c-58f88d35d9a4', '1c026365-c749-5087-a556-417c9cb94610', '56ae85f0-e307-5cd2-b535-f10c57a885f4', '98534318-f4a2-5695-8eb7-30dc2de19d63', 'a5eeb559-3ea1-585e-9470-b6f731b3f6d7', '4280a3ff-041a-55a3-b407-2237920168c0', 'bb2f5993-84dc-548e-b3d2-79c2d87daff4', '3f953c73-3888-5045-b1cd-655e22222973', '65b15669-28e6-5cd9-b3a1-1d60c910047a', '756d413c-6246-5d1c-93da-dca601a78f1b', 'c1e82944-6dcf-5829-9cfd-f6765e3174c9', 'c3e0d485-c44d-5c19-a101-206357fc0455', '02864476-9f47-51c7-8f4b-5126f25db9e1', '5040f31a-0513-54b5-b06f-97d96f36b82a', '25739a39-c45e-5012-a7a6-df7f6bf518c8', '895f513c-d27e-59ad-b493-cb2a2c4dceab', 'de093ced-c064-5285-a2cd-415ebf6ad206', 'a4606c41-a58d-50cb-898f-eb8f95198d6b', '80a0b797-fe73-575d-9ef8-3352fd6e5c3c', '5f8cec53-5d0f-56ec-8a7c-db82b29c53b0', '7c1e5ec9-d703-5d8a-8a54-852e05e90707', 'abc50f34-2fce-5e87-93a0-dfcfd20eeeef', '6413abb8-5794-5328-9bd3-939e2a0095fd', '3d4ab3e8-e942-590e-863f-1eb251e46fec', 'dc47af52-9b85-5d80-ac64-357d3b57e6b8', '8e279df7-7e62-5fd0-9644-ff4dd89f80b0', '2737b679-8a38-555a-b7c4-d573893e8179', '111f4d00-beb3-5ff2-8ff4-dbc0a74ab440', '6beee7fb-df0a-5d9e-9d13-d1f7b928e05a', '93afe125-7674-5860-9e54-931ac1aec9ad', '0490a7e6-fb91-59ab-8805-ec5d80ff4f8c', 'eb315260-c92f-5b45-b177-63773e04c22c', 'a17e1349-d783-59d4-a75b-535df3e42d97', '0c3b1cda-ccc7-5be9-b686-de84ee769347', 'bca3e1af-0da7-5221-afb8-44932d827d61', '57c7bb21-e58f-506b-8701-eb76e9fd7e56', 'a0b0ff5d-989a-5e5a-a4a1-fa2dc9a06ba5', 'b18779a5-9595-51e4-98a8-d72dae2605f7', '8ba98cb8-92dc-5343-930a-0de45e85d432', '830431a1-3f53-5447-979e-6e351a15e9c7', '8895a35e-6e01-51ac-82a8-37a87fcce468', 'c4547285-04e9-58af-b3da-c8642b8d37bf', 'e822b714-49e9-5e00-a509-17cd1e45418a', 'cb060e6d-4768-5197-bfef-0ffcec9655f6', '49a46efc-912c-5472-88b7-a0d5dbccf4f8', '7763dc36-96bf-503a-9000-c8eb167bedf3', 'a1c851ae-d0a9-5d16-8897-d3d6c561d382', '9ebb2d4b-9df1-55ba-949f-97eae8b9ed0f', '571cc8fa-481c-54cc-8d56-0bae0e39550c', 'c849bd2b-5b40-5a14-907a-ce2fbebf19e6', '280da4e5-02d7-56c8-8a19-c339471f2b77', 'fc6ab325-d2b5-5a85-907e-cb48c26729ae', '492a1f9d-d37f-53c9-9b97-8256f5fa964b', 'e1d86099-b85e-56f6-a2ff-13de9cc9125c', '355b15ee-35ec-50f5-92eb-644ac29c78bd', '88465e50-8ba6-52de-9a16-9c684427cb2c', 'f423e2be-9de5-5aa8-a892-22cf4b7245cf', 'b2e2d3db-d495-5050-aa76-8a070a12d1e8', 'd9b92754-dd5d-5ccf-af8b-776e5ba39d1a', '5c4f05bb-4a22-5e8f-a4c3-9f39c2d6ab84', '33daaf33-154f-515c-8c54-727203d519d9', '25767825-0bec-5cee-ba50-7936dacbb9af', '103b91ff-dc32-515b-ab12-dc564765197b', 'aa82c915-4bad-557b-a3e7-aaa5527f826d', 'b9c82bb2-aec1-5aef-a423-23e13c72e6bc', '4aaa849b-ff9f-5e69-b7e4-98a0bce5e3bf', '6c216c7b-b868-5ab1-b63d-2d889eb4b022', 'd83f2f3e-3b3e-54ee-a955-1a34b0c5f9a9', '332ad87b-cbe1-5dbb-ba72-05399baaf489', '26abf884-ff38-5a8b-85ce-c4ce2efaf880', 'baba29cf-f25a-58a8-84b8-27fa4d985ba4', '636112f2-34db-53e9-a454-317760638983', '2528bae6-77e3-549f-a0a5-be3130f4f60e', '9115c3a7-ddcc-5ada-8cd4-25f8ac34e0ce', '6ba22369-e718-5f67-8ca3-0497ec096b5f', 'bb14e498-e09f-5083-9088-73ebb396381a', 'ee020d2a-e8f9-536b-9ebf-04bc9c4a4f15', 'b9226a75-73cd-5f02-8e86-469399bc0427', 'a9ecd63b-c47e-571c-bf83-dbd501e99319', '465652d8-93bf-5b3f-b3bd-c75875548b79', 'aef02495-c994-524f-90e1-aa2cb314bc03', '9343a58a-7ccd-5256-b77f-4a8854856b49', '0321dc2f-24eb-525c-913b-ba6c7d67e4f8', '3a3262a9-a2b3-5615-8f9d-5b0d061ebf5e', '94265f0f-f867-5e8b-bf39-7a533184ea74', '23c7f29d-ba01-5ac7-ad7e-10f1a8b78de9', '14e674ef-9b8a-5122-9c33-148eeccb0823', '82e68ff2-4160-5483-9b7e-aa64d16bed01', 'd2b9693c-d6a4-5250-b650-3baf595686aa', '98440a10-5c79-59e5-ba86-35d1a9f58e0c', 'ee2d4d14-4c89-5aa0-b187-18cab9594859', '25bc0f55-d90f-5097-bd51-536413564bb5', '60edd15f-9272-5162-b4c3-fa1fb0c88df3', '63bc2f6c-4052-52ce-bdc0-315806a023bf', '46676238-f003-5909-bde3-6edac424a769', 'c2bbc210-58ac-5dee-aff9-75757f438921', '6836de75-c9e8-57cc-bf3e-8b7f4b7a62da', 'd90121fb-41d1-5a54-97fb-cba02cdd3887', 'e47ef585-fc79-5bd8-bd58-3a2e4f7b2b29', '74030c69-3d35-556b-a6ec-42ed96a9aa67', '5e1efb1d-8ab1-5eb4-b1df-382aa8cb985a', '420a8fea-0152-5d8e-b37b-4fedca5bb639', '6a4a5334-4c33-5fb2-ada4-f18d7d87bdec', 'e2582edf-8f7e-5ca4-9bdb-798fb10504ab', '84318cd4-abce-5579-b2c9-557a040ef12d', 'e1c1d8d8-8bef-50cd-a941-d00186e13434', '32dc311a-c979-551e-b0a6-14eac046b752', '4e755406-ebb7-5827-8f40-db52c2a9bf69', '2351c6cd-96c4-51d3-8004-352d4c8417fd', 'f6ff546c-ff7b-5484-a9a1-a39f4b517ede', '9397355a-2c4e-5c44-9a5b-3625c7fd3d8f', 'c8b96bc5-f670-5352-8207-19b89b9165be', '07add594-472c-5162-8c55-8af92f0341a2', 'fe3959ee-ff17-5603-afc3-e11c17a158b4', '1faf4cc4-dc84-5c0c-bd88-11d3378e8bba', '8909c67a-a3bb-5cd0-804d-716fd32a1204', 'e525b039-6daa-50d1-befd-e807f1e4ca0f', '55ce69a4-2667-520a-a17b-54c75d1ed11a', '8f54f953-8e86-5a74-bdc2-a18d7f7109b7', '79b6380d-5e88-5d89-b30c-c50b6cf1c636', '9f8f7fb4-6756-57da-a2aa-13f477570062', 'e4d43369-7987-50f6-b7dd-b2edbbdd2fdb', '1eecc468-154f-55b8-a2c5-a116625a03b6', '9c562906-5bdd-55bb-9540-5347f017bf14', '97b52bb6-bc06-58e4-92c5-b36a91ef1e03');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'anglais-c2' AND source = 'admin' AND id NOT IN ('8b31f7ef-cf72-55f6-aaac-8f4f312753f6', '64860b23-75c2-55af-8707-f446f545efa9', '4487a502-7e63-5ca0-858e-5b6960ce16be', 'a634825d-c3d6-58da-a20b-a3353d52ddb6', '866a4bf4-1304-5dab-be78-2044f054d2e1', '2adac661-005a-5adf-b7d6-eb8fa886e902', '7f794398-5176-5f36-bad3-70f1438aeaa2', '85b15adb-d3e0-571c-b7b7-08fb8257d0b6', 'd6645ab0-cae0-55d1-8710-5ace50e95c4e', '460d73ed-5900-5cb9-bbb3-cb6db0572f28', 'cc184b50-7750-5390-af80-914fa3c892d1', '5fe557ea-d222-5eda-97bf-58680f45d844', '202e92d0-7981-5931-96c7-79b941875cb5', '50e4da08-9786-5f37-b92c-4756f87f6167', 'f080ad19-5a66-5c15-a4e5-84d80afc70e8', 'e7c4a70b-a1d8-59c4-9849-6ea25d6176a5', '56ac58aa-2ca3-5e52-ad90-59ee85bb06de', '23ebfe42-0d8e-5f0c-858d-e0f4e4820710', 'b381c97a-dce4-5e24-905b-9032c809f7ed', 'fc509bb9-62e7-5a3a-a546-9647ea4cf14e', 'cd1e3de9-2467-5620-af89-7c184928e60f', '34ff5c62-acef-50de-8a22-7619b6befc4d', '2899f53e-4af9-5533-a830-b5b23e9c5ce8', 'f2db4908-bd00-5814-a9b4-6102af01415f', '867db683-8f35-5715-af86-1e84aee80f50', '4e098852-5532-548c-9d46-983637ca99b8', 'a44453e4-09ca-5936-b7e6-dbb4e2680c92', '3c63e2bc-23ae-578e-8ef1-90ceb8146c98', '0ec6d04f-1b91-5aa0-b104-73c3cf036d21', '5f99784e-5a92-591a-9b14-f0a56a373116', '8770de69-2e60-5713-8661-15a1dde1f72b', 'd0e4dcc1-f3a7-5a13-9ac7-04c64ffea951', '2e177783-fef5-5f52-874c-666ccf4dc83f', '3457cebf-f5d5-5d08-8b69-3aaf676d6e3e', '5a477296-ac0b-541b-9b2f-db1e540fa4d0', '29e63fd9-60da-5d42-8a29-aecc2d4263c4', 'f60dc877-5c7e-57df-b5ae-5e5684865293', 'e0f42567-7913-5631-9df8-f69d56eb8a00', '98b0a678-9435-5453-9117-a39f43e0ff14', '7d8fa76e-e8df-5115-82b8-c30dbacf7019', 'bcfc0582-f595-510f-b3b2-01e5f0d95de0', 'e62a72ce-6504-599b-aaaf-e88fa7a6e052');
DELETE FROM public.questions WHERE exercise_id IN ('8b31f7ef-cf72-55f6-aaac-8f4f312753f6', '64860b23-75c2-55af-8707-f446f545efa9', '4487a502-7e63-5ca0-858e-5b6960ce16be', 'a634825d-c3d6-58da-a20b-a3353d52ddb6', '866a4bf4-1304-5dab-be78-2044f054d2e1', '2adac661-005a-5adf-b7d6-eb8fa886e902', '7f794398-5176-5f36-bad3-70f1438aeaa2', '85b15adb-d3e0-571c-b7b7-08fb8257d0b6', 'd6645ab0-cae0-55d1-8710-5ace50e95c4e', '460d73ed-5900-5cb9-bbb3-cb6db0572f28', 'cc184b50-7750-5390-af80-914fa3c892d1', '5fe557ea-d222-5eda-97bf-58680f45d844', '202e92d0-7981-5931-96c7-79b941875cb5', '50e4da08-9786-5f37-b92c-4756f87f6167', 'f080ad19-5a66-5c15-a4e5-84d80afc70e8', 'e7c4a70b-a1d8-59c4-9849-6ea25d6176a5', '56ac58aa-2ca3-5e52-ad90-59ee85bb06de', '23ebfe42-0d8e-5f0c-858d-e0f4e4820710', 'b381c97a-dce4-5e24-905b-9032c809f7ed', 'fc509bb9-62e7-5a3a-a546-9647ea4cf14e', 'cd1e3de9-2467-5620-af89-7c184928e60f', '34ff5c62-acef-50de-8a22-7619b6befc4d', '2899f53e-4af9-5533-a830-b5b23e9c5ce8', 'f2db4908-bd00-5814-a9b4-6102af01415f', '867db683-8f35-5715-af86-1e84aee80f50', '4e098852-5532-548c-9d46-983637ca99b8', 'a44453e4-09ca-5936-b7e6-dbb4e2680c92', '3c63e2bc-23ae-578e-8ef1-90ceb8146c98', '0ec6d04f-1b91-5aa0-b104-73c3cf036d21', '5f99784e-5a92-591a-9b14-f0a56a373116', '8770de69-2e60-5713-8661-15a1dde1f72b', 'd0e4dcc1-f3a7-5a13-9ac7-04c64ffea951', '2e177783-fef5-5f52-874c-666ccf4dc83f', '3457cebf-f5d5-5d08-8b69-3aaf676d6e3e', '5a477296-ac0b-541b-9b2f-db1e540fa4d0', '29e63fd9-60da-5d42-8a29-aecc2d4263c4', 'f60dc877-5c7e-57df-b5ae-5e5684865293', 'e0f42567-7913-5631-9df8-f69d56eb8a00', '98b0a678-9435-5453-9117-a39f43e0ff14', '7d8fa76e-e8df-5115-82b8-c30dbacf7019', 'bcfc0582-f595-510f-b3b2-01e5f0d95de0', 'e62a72ce-6504-599b-aaaf-e88fa7a6e052') AND id NOT IN ('fe8e22c6-0b1a-5825-a215-8d950e8d4bb1', 'd2a4513b-690b-5b4f-a8c0-51b08868c6fe', '680a95b8-6440-5834-9187-57e73b786a53', '6650c2a7-fd06-52f4-afd6-08727dfa23c1', '5f2c994e-ba89-590a-886f-d428c3a9866c', '8fe292a6-48d2-55b8-bf0e-995c0f7ef8a6', '0e4c5d72-3948-55c1-a831-64c504b75756', 'd8b02cdc-f07d-5388-8a0d-97955955a9ef', 'cf1952b4-607e-5a18-82cc-9fb4a92f486a', '00d2afb4-d2dc-5a33-85ab-f3189c1c5e53', '29053b29-9aeb-5473-8906-8317a99ae4cc', 'a6d7e5f6-ee92-5eaa-a992-349024038808', 'ea964b7c-4c1c-5858-984b-02106f04b2c4', '482f3c52-40da-5f76-8500-57942fb0785a', '9a39d9a1-cb97-50d8-95a4-d9590c812a52', 'd2f68d8c-7be9-532c-ab19-72018f0a5a6e', '67e4cd98-3c2d-52dc-bfea-22fa62746d38', 'f0f8ff6e-b81a-5c93-82b5-bfb001238dba', '87bea223-fa9a-548b-9f57-f42af545212c', 'c9b3e3a1-62dd-5ab1-86bf-5cb92f69f838', 'd7571029-6fb7-5678-93e9-c5828664d2e3', 'b5b69a17-c40f-5d62-b6ee-96c2433f1fbd', 'd566febb-b341-5149-8cb0-8e6a8d44e3c0', '19dfe3d9-d087-5b5b-876c-cc18562b41e3', '81f4bb31-c53e-5583-bd29-d970bb0c9e77', 'e9ac13b2-ec8e-51f1-aebb-28244c323f7f', 'cee9dd38-eca4-555d-85cf-7d58c7a8c822', 'ba80a72b-182a-5726-a43f-4bcd105cc7e3', '248b1e79-a72b-5089-bbd9-754c9b3a5a48', 'd1a249b5-7e9c-56b6-acfd-819ef3c3e123', '6012c3c6-ffb1-5dfd-bbf9-e557f26f21a7', 'bd633468-25de-5d0e-9493-9d1624d27b68', '81cb6c1f-486a-518d-94f6-8b9b5b4237e1', '0a9833f0-be4f-5009-ade9-73c09eb5b936', '5ae976f0-4d56-5355-b7c2-b09d8591d95c', 'eb0ce85d-a5b5-5376-8b9b-71a2e06a775b', '13804d18-1dbf-580a-a4fd-b4bccb68ae6a', '371aadf7-ee82-5eb4-ac99-4436f6c31e39', '51ed5ed9-dbf6-5e43-9851-bbd3109a67ee', '343dbad2-ac63-5516-8e15-9413c60de40b', 'f03c20da-e89c-50bd-b2fe-a926e235a117', '1ae28c28-430c-5d65-82e1-94d07a815eb2', '0362bb33-5b16-5afc-b608-8ff2af518a88', '94a296fe-932c-5c3d-86f5-85e3bea5fdbb', '9feeb36d-255c-5f61-b4a5-1aec82befe87', '80502f3c-5f7e-5023-9ddb-77c6f0bf25f8', 'cfef25e1-9516-5a67-a557-c59815693359', '88ef3c36-6b27-5c6d-b9c4-fbd7d8692755', 'd27e62b8-1532-5823-a5c9-2fc1408c324f', 'bc73bcbc-cb4b-5aea-b5a3-af5d84258aa2', '10938362-4f8f-5857-94fe-ac8230d71682', '17c27c03-0384-5c61-b4fb-c9dd5dd5edad', '9ff3218c-fbf2-59b3-9659-c90b4558ed08', '6e62b2c1-f98a-5314-9476-3d683b0a2c2e', '370807f2-ab1d-5676-89a4-a64f22cab6f1', '5876c79b-ed26-594c-ba0f-91341c7950dd', '831b69e7-e817-513e-ae32-daddb5eb6706', 'dd7aecbf-9807-5656-a262-c0f2c30f0626', '6af83164-4e53-5a75-af9b-1d6bee671884', '89eb4adc-f710-5588-b49f-540bdd1d516e', '6439b7e0-2866-5f56-b21e-6174abf080cd', 'e3de5aed-6a62-5492-a23b-b65139c719c4', '76162ccc-0fdf-5c36-8497-0ee42acbb3a4', '5b99ee85-e583-5e34-a8d8-8f6cf06e568f', 'a68a5b50-d4a8-536f-9ddf-8917f4badb10', 'd7370c67-d990-5555-b7d5-85c74883ceb2', 'd0ffd553-a09f-5408-853b-a6e4e6d62340', 'f4ecad86-4579-5c84-afbd-be409e212cbd', '49535f59-f254-5d94-9110-8c1baf040d9a', '8cc4aa9e-8b78-5473-9b06-bf0a99dd1f15', '4afd0cc0-1dbd-5eed-a5f3-6c96db188e87', '94e51584-e60b-5e5c-a076-993cb64d9a40', 'a27457a2-ffb3-5394-88ac-60547ed48eac', '1ec57d83-cc7f-507d-9eaa-c3995257ee3a', '5f3cc008-7e38-58b0-914b-6e4522b0d899', 'dc9f1e2e-8c1d-5b23-8b24-11b8d184eae9', '80fdf985-ee6c-5785-b175-7fb5b7caa263', '069a31ce-e520-560c-8407-1c9a67c8bdad', 'e0b8875d-deda-506e-abd6-c136f5938792', '9298ed8c-dc6c-5b5a-9b31-d3b742433747', 'c2858220-6a2a-5ade-b7c2-2f5ad26b897b', 'd26d7b52-b5ff-581b-b308-2a33e26c2761', '264e22d8-cd0c-51e7-9857-f1e264b547fe', 'a60d6157-f9ed-58b0-b04b-cbac96489734', '9bd2eb0b-d929-5553-9e3a-00e0a2bf8b54', 'e1bd1c5b-00a3-53ec-a3fc-e893d9c17272', '4f4f46b7-2398-59f4-bef8-a76a323ced7f', '16c3df9f-baa5-5b3b-a8cf-ac4cc8f2d5fd', 'a48cb938-9423-5896-bbbd-1b78fe1cd771', 'bb7434c3-0278-50e5-8969-d2fd82d828f7', '4fdb4d20-e550-52df-98d2-29b4e709b67c', 'df1ca3d7-2078-535d-945a-eb5682dcef38', '3953ae02-18ee-5e31-a942-61d5fe8b1b83', '6aec6fac-7c21-5d8a-b50d-e7fd17189c41', '2ac5d9a0-0ea8-52f6-958a-c71fffdc2b5c', 'ee7547b0-c1d6-5dd7-acf2-b6b4a1e245e1', '62de42b6-faaf-592a-8879-b6849fb4c3b9', '8382d959-a78a-5448-bed6-0af18c99b06e', 'a989d97f-13ad-5654-900e-7c3bd78a584c', '293aaae9-411d-590d-aa48-5a8b576c6ab5', 'dcca13f8-c973-5f35-8c10-031950be20e1', '5ca71847-bc51-539f-b9a1-3e93b071a7c2', '46020b3e-6759-5b1e-ab19-648b462657bc', '5687c90e-fbb3-5d8d-aa3d-b325b84bdb5f', '633715de-2511-5d43-af00-f24f9900f34e', '920fac69-8575-58dd-b5d8-0284b66a3059', '99861f17-a7f2-5454-bb30-4a821f77efb5', '550495a8-a78c-5c11-9e67-44b2102c9cd1', 'c83d25dc-b65a-5795-9070-216fca32404b', 'faeb109b-3226-5ab8-9082-befd38169896', '956a4c0f-264a-5e04-9047-47eeed4f325b', '16172beb-834f-5207-979f-325c1f13fe77', '97b70d59-a9e7-5b0b-88fe-65bcb6ec9420', '58c78246-bb0a-5d05-aa99-caf4d7fe82e8', 'a20e2408-0f3b-5326-a036-93c4524e884e', 'f2c6c350-4944-565c-930a-2a303fcc3e11', '2d122806-9e40-5d8f-ad26-82e100ac6a17', 'e088883a-f3dd-5168-81c7-83ddcca3b094', 'b117e20c-8993-5a8f-891d-86f9677a149f', '7050af91-e097-5b32-9445-5448c62348e1', 'b3a0d3af-49e4-5485-a07c-58f88d35d9a4', '1c026365-c749-5087-a556-417c9cb94610', '56ae85f0-e307-5cd2-b535-f10c57a885f4', '98534318-f4a2-5695-8eb7-30dc2de19d63', 'a5eeb559-3ea1-585e-9470-b6f731b3f6d7', '4280a3ff-041a-55a3-b407-2237920168c0', 'bb2f5993-84dc-548e-b3d2-79c2d87daff4', '3f953c73-3888-5045-b1cd-655e22222973', '65b15669-28e6-5cd9-b3a1-1d60c910047a', '756d413c-6246-5d1c-93da-dca601a78f1b', 'c1e82944-6dcf-5829-9cfd-f6765e3174c9', 'c3e0d485-c44d-5c19-a101-206357fc0455', '02864476-9f47-51c7-8f4b-5126f25db9e1', '5040f31a-0513-54b5-b06f-97d96f36b82a', '25739a39-c45e-5012-a7a6-df7f6bf518c8', '895f513c-d27e-59ad-b493-cb2a2c4dceab', 'de093ced-c064-5285-a2cd-415ebf6ad206', 'a4606c41-a58d-50cb-898f-eb8f95198d6b', '80a0b797-fe73-575d-9ef8-3352fd6e5c3c', '5f8cec53-5d0f-56ec-8a7c-db82b29c53b0', '7c1e5ec9-d703-5d8a-8a54-852e05e90707', 'abc50f34-2fce-5e87-93a0-dfcfd20eeeef', '6413abb8-5794-5328-9bd3-939e2a0095fd', '3d4ab3e8-e942-590e-863f-1eb251e46fec', 'dc47af52-9b85-5d80-ac64-357d3b57e6b8', '8e279df7-7e62-5fd0-9644-ff4dd89f80b0', '2737b679-8a38-555a-b7c4-d573893e8179', '111f4d00-beb3-5ff2-8ff4-dbc0a74ab440', '6beee7fb-df0a-5d9e-9d13-d1f7b928e05a', '93afe125-7674-5860-9e54-931ac1aec9ad', '0490a7e6-fb91-59ab-8805-ec5d80ff4f8c', 'eb315260-c92f-5b45-b177-63773e04c22c', 'a17e1349-d783-59d4-a75b-535df3e42d97', '0c3b1cda-ccc7-5be9-b686-de84ee769347', 'bca3e1af-0da7-5221-afb8-44932d827d61', '57c7bb21-e58f-506b-8701-eb76e9fd7e56', 'a0b0ff5d-989a-5e5a-a4a1-fa2dc9a06ba5', 'b18779a5-9595-51e4-98a8-d72dae2605f7', '8ba98cb8-92dc-5343-930a-0de45e85d432', '830431a1-3f53-5447-979e-6e351a15e9c7', '8895a35e-6e01-51ac-82a8-37a87fcce468', 'c4547285-04e9-58af-b3da-c8642b8d37bf', 'e822b714-49e9-5e00-a509-17cd1e45418a', 'cb060e6d-4768-5197-bfef-0ffcec9655f6', '49a46efc-912c-5472-88b7-a0d5dbccf4f8', '7763dc36-96bf-503a-9000-c8eb167bedf3', 'a1c851ae-d0a9-5d16-8897-d3d6c561d382', '9ebb2d4b-9df1-55ba-949f-97eae8b9ed0f', '571cc8fa-481c-54cc-8d56-0bae0e39550c', 'c849bd2b-5b40-5a14-907a-ce2fbebf19e6', '280da4e5-02d7-56c8-8a19-c339471f2b77', 'fc6ab325-d2b5-5a85-907e-cb48c26729ae', '492a1f9d-d37f-53c9-9b97-8256f5fa964b', 'e1d86099-b85e-56f6-a2ff-13de9cc9125c', '355b15ee-35ec-50f5-92eb-644ac29c78bd', '88465e50-8ba6-52de-9a16-9c684427cb2c', 'f423e2be-9de5-5aa8-a892-22cf4b7245cf', 'b2e2d3db-d495-5050-aa76-8a070a12d1e8', 'd9b92754-dd5d-5ccf-af8b-776e5ba39d1a', '5c4f05bb-4a22-5e8f-a4c3-9f39c2d6ab84', '33daaf33-154f-515c-8c54-727203d519d9', '25767825-0bec-5cee-ba50-7936dacbb9af', '103b91ff-dc32-515b-ab12-dc564765197b', 'aa82c915-4bad-557b-a3e7-aaa5527f826d', 'b9c82bb2-aec1-5aef-a423-23e13c72e6bc', '4aaa849b-ff9f-5e69-b7e4-98a0bce5e3bf', '6c216c7b-b868-5ab1-b63d-2d889eb4b022', 'd83f2f3e-3b3e-54ee-a955-1a34b0c5f9a9', '332ad87b-cbe1-5dbb-ba72-05399baaf489', '26abf884-ff38-5a8b-85ce-c4ce2efaf880', 'baba29cf-f25a-58a8-84b8-27fa4d985ba4', '636112f2-34db-53e9-a454-317760638983', '2528bae6-77e3-549f-a0a5-be3130f4f60e', '9115c3a7-ddcc-5ada-8cd4-25f8ac34e0ce', '6ba22369-e718-5f67-8ca3-0497ec096b5f', 'bb14e498-e09f-5083-9088-73ebb396381a', 'ee020d2a-e8f9-536b-9ebf-04bc9c4a4f15', 'b9226a75-73cd-5f02-8e86-469399bc0427', 'a9ecd63b-c47e-571c-bf83-dbd501e99319', '465652d8-93bf-5b3f-b3bd-c75875548b79', 'aef02495-c994-524f-90e1-aa2cb314bc03', '9343a58a-7ccd-5256-b77f-4a8854856b49', '0321dc2f-24eb-525c-913b-ba6c7d67e4f8', '3a3262a9-a2b3-5615-8f9d-5b0d061ebf5e', '94265f0f-f867-5e8b-bf39-7a533184ea74', '23c7f29d-ba01-5ac7-ad7e-10f1a8b78de9', '14e674ef-9b8a-5122-9c33-148eeccb0823', '82e68ff2-4160-5483-9b7e-aa64d16bed01', 'd2b9693c-d6a4-5250-b650-3baf595686aa', '98440a10-5c79-59e5-ba86-35d1a9f58e0c', 'ee2d4d14-4c89-5aa0-b187-18cab9594859', '25bc0f55-d90f-5097-bd51-536413564bb5', '60edd15f-9272-5162-b4c3-fa1fb0c88df3', '63bc2f6c-4052-52ce-bdc0-315806a023bf', '46676238-f003-5909-bde3-6edac424a769', 'c2bbc210-58ac-5dee-aff9-75757f438921', '6836de75-c9e8-57cc-bf3e-8b7f4b7a62da', 'd90121fb-41d1-5a54-97fb-cba02cdd3887', 'e47ef585-fc79-5bd8-bd58-3a2e4f7b2b29', '74030c69-3d35-556b-a6ec-42ed96a9aa67', '5e1efb1d-8ab1-5eb4-b1df-382aa8cb985a', '420a8fea-0152-5d8e-b37b-4fedca5bb639', '6a4a5334-4c33-5fb2-ada4-f18d7d87bdec', 'e2582edf-8f7e-5ca4-9bdb-798fb10504ab', '84318cd4-abce-5579-b2c9-557a040ef12d', 'e1c1d8d8-8bef-50cd-a941-d00186e13434', '32dc311a-c979-551e-b0a6-14eac046b752', '4e755406-ebb7-5827-8f40-db52c2a9bf69', '2351c6cd-96c4-51d3-8004-352d4c8417fd', 'f6ff546c-ff7b-5484-a9a1-a39f4b517ede', '9397355a-2c4e-5c44-9a5b-3625c7fd3d8f', 'c8b96bc5-f670-5352-8207-19b89b9165be', '07add594-472c-5162-8c55-8af92f0341a2', 'fe3959ee-ff17-5603-afc3-e11c17a158b4', '1faf4cc4-dc84-5c0c-bd88-11d3378e8bba', '8909c67a-a3bb-5cd0-804d-716fd32a1204', 'e525b039-6daa-50d1-befd-e807f1e4ca0f', '55ce69a4-2667-520a-a17b-54c75d1ed11a', '8f54f953-8e86-5a74-bdc2-a18d7f7109b7', '79b6380d-5e88-5d89-b30c-c50b6cf1c636', '9f8f7fb4-6756-57da-a2aa-13f477570062', 'e4d43369-7987-50f6-b7dd-b2edbbdd2fdb', '1eecc468-154f-55b8-a2c5-a116625a03b6', '9c562906-5bdd-55bb-9540-5347f017bf14', '97b52bb6-bc06-58e4-92c5-b36a91ef1e03');
DELETE FROM public.chapters c WHERE c.subject_id = 'anglais-c2' AND c.id NOT IN ('0c302304-ca15-59f6-9e00-67b6f95caf87', 'e309b05b-3990-599d-bdfb-4988302f698c', '6e02f8d0-b12f-5308-9946-a98f4ab38838', '67f513ed-06bc-55e4-b8e6-a0c91c612378', 'e45a5f31-4d6d-536e-b129-ddec5e7376ff', 'b354d6c0-ead3-55f6-9f68-bb5b3e951352', 'c78f470c-a153-5f88-ac60-8e5face49d02') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('0c302304-ca15-59f6-9e00-67b6f95caf87', 'anglais-c2', 'The Subjunctive and Unreal Past', 'Master the mandative subjunctive (I suggest he be…), formal unreal conditions (were I to…, had I known…, should you need…), and fixed expressions with unreal past meaning (It''s high time, I''d rather, as if).', '# ⚔️ The Subjunctive and Unreal Past — The Grammar of the Impossible

> 💡 «At C2 level, a single verb form can signal that you are speaking of a world that is not real — a possibility, a wish, a command wrapped in elegance. That form is the subjunctive.»

## 🏰 What the subjunctive is

The **subjunctive** is a verb mood — not a tense — that signals a hypothetical, wished-for, or formally demanded state. Modern English has two subjunctive forms:

| Name                    | Form               | Example                              |
| ----------------------- | ------------------ | ------------------------------------ |
| **Present subjunctive** | base form (no -s)  | _I suggest he **be** present._       |
| **Past subjunctive**    | were (all persons) | _If I **were** you, I''d reconsider._ |

The present subjunctive is identical to the infinitive and differs visibly only in **third-person singular**, where ordinary present simple adds -s: _he goes_ → \*it is vital that he **go\***.

## ⚡ The mandative subjunctive

The mandative (or "that-clause") subjunctive follows **verbs of demanding/requesting/recommending** and impersonal expressions:

**Verbs:** _suggest, recommend, propose, insist, demand, require, request, ask, urge, move (formal)_
**Adjectives:** _it is essential / vital / important / necessary / imperative / advisable that …_

| Trigger                  | + that + subject + **base form**          |
| ------------------------ | ----------------------------------------- |
| _The committee insists_  | _that every member **be** present._       |
| _The doctor recommended_ | _that he **take** three weeks'' rest._     |
| _It is vital_            | _that she **submit** her thesis on time._ |
| _We propose_             | _that the motion **be** deferred._        |

> 🗡️ Tip: the subjunctive never adds -s, never uses _is/was_, and never uses modal auxiliaries (_should/must_) — those produce a **different** (less formal) alternative: \*it is vital that she **should submit\*** vs the purer \*it is vital that she **submit\***.

> ⚠️ Trap: \*I suggest that he **goes\*** is a common error — drop the -s: _I suggest that he **go**._

## 🛡️ The past subjunctive: _were_ (unreal present/future)

Use **were** for all persons in conditional and wish structures expressing **unreal** or **hypothetical** present/future meaning:

_If I **were** a native speaker, I would sound different. — I wish I **were** taller. — She acts as if she **were** the boss._

> 🗡️ Tip: _was_ is heard in informal speech (_If I was you…_), but at C2 and in formal/written English **were** is the correct and expected form for all persons.

## 🔮 Inverted (formal) conditionals — dropping _if_

At C2, you can replace _if_ with inversion — formal, literary, and impressive:

| Standard                       | Inverted (formal)             |
| ------------------------------ | ----------------------------- |
| _If I **were** to resign…_     | **\*Were** I to resign…\*     |
| _If she **had** known…_        | **\*Had** she known…\*        |
| _If you **should** need help…_ | **\*Should** you need help…\* |

These inversions are common in **formal letters, legal language, and sophisticated essays**.

_**Had** we arrived earlier, we would have caught the train._
_**Should** you require further information, please contact us._
_**Were** this plan to fail, the consequences would be severe._

> ⚠️ Trap: you cannot invert with _would_ — _~~Would he come, we''d be pleased~~_ is wrong. Use inversion only with _were / had / should_.

## 🌍 Fixed expressions with unreal past meaning

These phrases take a **past tense** to signal that the situation is **not currently true** (not because we are in the past):

| Expression                        | Meaning                                | Example                                       |
| --------------------------------- | -------------------------------------- | --------------------------------------------- |
| **It''s high time** + past         | overdue; should already be done        | _It''s high time you **started** saving._      |
| **I''d rather** + past             | preference about someone else''s action | _I''d rather she **told** me the truth._       |
| **I''d sooner** + past             | same as _I''d rather_                   | _I''d sooner he **didn''t** mention it._        |
| **as if / as though** + past/were | unreal comparison                      | _He talks as if he **were** an expert._       |
| **suppose / supposing** + past    | hypothetical prompt                    | **\*Supposing** she **refused**, what then?\* |
| **If only** + past/past perfect   | strong wish                            | _If only I **had** studied harder!_           |

> 🗡️ Tip: \*It''s high time I **go\*** is a common slip — the past form is required: _It''s high time I **went**._

> 🏆 Gate cleared! You now command the subjunctive, formal inversions, and unreal past expressions — the hallmarks of C2 written and spoken precision. Next: the hidden meanings behind everyday idioms.', '# 📜 Résumé: The Subjunctive and Unreal Past

- **Present subjunctive** — base form (no -s) after _suggest/insist/recommend/it is vital_ that: _I suggest he **be** present; it is essential she **submit** the form._
- **Past subjunctive** — **were** for all persons in unreal/hypothetical contexts: _If I **were** you…; I wish he **were** here; She acts as if she **were** the boss._
- **Mandative triggers** — verbs: _suggest, demand, insist, require, recommend, propose_; adjectives: _it is essential/vital/necessary/important/imperative that …_
- ⚠️ Never add -s to the subjunctive verb: \*I suggest that he **go\*** (NOT _goes_); never use _is/was_ inside the that-clause.
- **Formal inverted conditionals** (drop _if_, invert subject-auxiliary): _Were I to resign… / Had she known… / Should you need help…_ — only _were/had/should_ invert, never _would_.
- **It''s high time** + past: _It''s high time you **started**._ (present tense after _high time_ is wrong.)
- **I''d rather / I''d sooner** + past (about someone else): _I''d rather she **told** me._ (+ base form only when the subject is the same: \*I''d rather **go\***.)
- **As if / as though** + past/were for unreal comparisons; **If only** + past/past perfect for strong wishes.', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('e309b05b-3990-599d-bdfb-4988302f698c', 'anglais-c2', 'Idioms and Figurative Language', 'Decode and deploy the fixed idioms, metaphors, and figurative expressions that make English come alive: meaning vs literal reading, common topic clusters, and how to recognise the context clues that unlock idiomatic sense.', '# 🗡️ Idioms and Figurative Language — The Secret Vocabulary of Native Speakers

> 💡 «An idiom is a phrase whose meaning cannot be deduced from its individual words. Miss it and you miss the conversation. Master it and you sound effortlessly native.»

## 🏰 What is an idiom?

An **idiom** is a fixed or semi-fixed expression whose **meaning is not literal** — it cannot be worked out word by word. Native speakers use idioms constantly in informal conversation, journalism, and everyday writing.

_"She **let the cat out of the bag**."_ — Literal reading: she released a cat. **Idiomatic meaning**: she accidentally revealed a secret.

**Figurative language** is the broader category: it includes idioms, metaphors, similes, and hyperbole. At C2, you need to recognise and use all of these naturally.

## ⚡ Core idiom clusters

| Topic                 | Idiom                   | Meaning                               |
| --------------------- | ----------------------- | ------------------------------------- |
| Secrets & revelations | _spill the beans_       | reveal a secret                       |
| Difficulty            | _bite the bullet_       | endure something unpleasant bravely   |
| Effort                | _go the extra mile_     | make more effort than required        |
| Understanding         | _see eye to eye_        | agree / share the same view           |
| Time                  | _once in a blue moon_   | very rarely                           |
| Starting              | _kick off_              | begin something                       |
| Problems              | _hit a brick wall_      | reach an obstacle that stops progress |
| Change                | _turn over a new leaf_  | start behaving better                 |
| Money                 | _cost an arm and a leg_ | be very expensive                     |
| Honesty               | _call a spade a spade_  | speak plainly without euphemism       |
| Anger                 | _blow a fuse_           | lose one''s temper suddenly            |
| Similarity            | _the spitting image of_ | look exactly like                     |

## 🛡️ Metaphor in everyday English

A **metaphor** describes one thing _as if_ it were another without using _like_ or _as_:

_Life is a journey._ — _He''s a real rock in a crisis._ — _She devoured the book._ — _They flooded us with complaints._

Notice how verbs (_devoured, flooded_) and nouns (_rock_) take on transferred meaning. This is called **lexical metaphor** and is everywhere in English.

> 🗡️ Tip: a **simile** uses _like_ or _as_: _She ran **like** the wind. He was **as** cool **as** a cucumber._ Similes are explicit comparisons; metaphors are implicit.

## 🔮 Common figurative expressions to know

| Expression                        | Meaning                                       | Example                                              |
| --------------------------------- | --------------------------------------------- | ---------------------------------------------------- |
| _the tip of the iceberg_          | a small visible part of a larger problem      | _Those delays are just the tip of the iceberg._      |
| _burn your bridges_               | destroy relationships irreparably             | _Don''t burn your bridges — you may need them later._ |
| _break the ice_                   | make people feel comfortable at the start     | _A short game helped break the ice._                 |
| _under the weather_               | feeling slightly ill                          | _I''m a bit under the weather today._                 |
| _on the fence_                    | undecided                                     | _She''s still on the fence about the offer._          |
| _bite off more than you can chew_ | take on more than you can manage              | _He bit off more than he could chew._                |
| _a blessing in disguise_          | something that seems bad but is actually good | _Losing that job was a blessing in disguise._        |
| _at the drop of a hat_            | immediately, without hesitation               | _She''ll change her mind at the drop of a hat._       |

## 🧭 How to interpret idioms in context

When you encounter an unknown idiom, use context clues:

1. **Topic/situation** — if someone says _"The deal fell through at the last minute"_, the idiom _fell through_ fits the idea of failure.
2. **Tone** — idiomatic language often signals informality; formal writing rarely uses fixed idioms.
3. **Surrounding words** — _"We''ve hit a brick wall with the negotiations"_ → the word _negotiations_ tells you this is about a problem in a process, not a literal wall.

> ⚠️ Trap: do NOT translate idioms literally. _"He kicked the bucket"_ does NOT mean he kicked a bucket — it means he died (informal). Literal translation will produce nonsense or embarrassment.

> ⚠️ Trap: some idioms are fixed and cannot be modified — _~~"spill the beans out"~~_, _~~"let the cats out of the bag"~~_ are wrong. Learn the exact form.

## 🌍 Simile patterns: as … as / like

| Simile                     | Meaning                                   |
| -------------------------- | ----------------------------------------- |
| _as bold as brass_         | very confident, even cheeky               |
| _as blind as a bat_        | having very poor vision                   |
| _like a fish out of water_ | in an unfamiliar, uncomfortable situation |
| _sell like hot cakes_      | sell very quickly and in large numbers    |
| _work like a dream_        | function perfectly                        |

> 🏆 Gate cleared! Idioms and figurative language are the texture of native English — learn clusters, trust context, and never translate word by word. Next: register and how to shift between formal and informal with precision.', '# 📜 Résumé: Idioms and Figurative Language

- **Idiom** — fixed expression whose meaning is NOT literal: _let the cat out of the bag_ = reveal a secret; _bite the bullet_ = endure bravely; _cost an arm and a leg_ = be very expensive.
- **Metaphor** — describes one thing as another without _like/as_: _She devoured the book; they flooded us with complaints; he''s a rock in a crisis._
- **Simile** — explicit comparison using _like_ or _as_: _as cool as a cucumber; sell like hot cakes; like a fish out of water._
- **Key idiom clusters** — secrets (_spill the beans_), effort (_go the extra mile_), obstacles (_hit a brick wall_), change (_turn over a new leaf_), disagreement → agreement (_see eye to eye_), rarity (_once in a blue moon_).
- **Figurative set phrases** — _the tip of the iceberg_ (small visible sign of a larger problem); _burn your bridges_ (destroy relationships); _break the ice_ (ease tension at the start); _a blessing in disguise_ (hidden benefit); _on the fence_ (undecided); _at the drop of a hat_ (instantly).
- **Context strategy** — use topic, tone, and surrounding words to decode unknown idioms; formal writing avoids fixed idioms.
- ⚠️ Never translate idioms literally — _he kicked the bucket_ = he died, not a physical action. Learn the exact fixed form; idioms cannot be freely modified.', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('6e02f8d0-b12f-5308-9946-a98f4ab38838', 'anglais-c2', 'Register, Formality and Nominalisation', 'Command the full spectrum of English register: formal vs informal/colloquial lexical choices, the power of nominalisation (turning verbs and adjectives into nouns), Latinate vocabulary vs phrasal verbs, and the features of academic tone.', '# 🎭 Register, Formality and Nominalisation — Speaking to the Room

> 💡 «A C2 speaker does not just know the right words — they know which words belong where. Register is the art of calibrating your language to its social context.»

## 🏰 What is register?

**Register** is the variety of language suited to a particular situation, relationship, or purpose. The same idea can be expressed at wildly different levels of formality:

| Informal/Colloquial | Neutral       | Formal/Written                           |
| ------------------- | ------------- | ---------------------------------------- |
| _find out_          | _discover_    | _ascertain_                              |
| _need_              | _require_     | _necessitate_                            |
| _get_               | _obtain_      | _procure_                                |
| _show_              | _demonstrate_ | _illustrate_                             |
| _end_               | _finish_      | _conclude / terminate_                   |
| _use_               | _use_         | _utilise_                                |
| _ask_               | _request_     | _petition / solicit_                     |
| _sorry_             | _I apologise_ | _I wish to express my sincere apologies_ |

> 🗡️ Tip: formal register is NOT just about long words — it is about **precision**, **distance**, **objectivity**, and avoiding contractions, slang, and colloquial phrasal verbs.

## ⚡ Phrasal verbs vs Latinate equivalents

A key marker of **informal** register is the use of **phrasal verbs** (verb + particle); formal register prefers **single Latinate verbs**:

| Informal (phrasal verb) | Formal (Latinate)        |
| ----------------------- | ------------------------ |
| _look into_             | _investigate_            |
| _put off_               | _postpone / defer_       |
| _bring about_           | _cause / precipitate_    |
| _give up_               | _abandon / relinquish_   |
| _deal with_             | _address / handle_       |
| _set up_                | _establish / constitute_ |
| _carry out_             | _conduct / execute_      |
| _come up with_          | _devise / formulate_     |
| _back up_               | _support / corroborate_  |
| _go over_               | _review / examine_       |

> ⚠️ Trap: using phrasal verbs in academic essays or formal business letters immediately lowers the register. Write _the committee will investigate_ rather than _the committee will look into it_.

## 🛡️ Nominalisation: the grammar of formal writing

**Nominalisation** is the process of converting **verbs and adjectives into nouns** (or noun phrases). It is a defining feature of academic, legal, and formal writing.

| Verb/Adjective | Nominalised form   |
| -------------- | ------------------ |
| _decide_       | **decision**       |
| _analyse_      | **analysis**       |
| _significant_  | **significance**   |
| _implement_    | **implementation** |
| _fail_         | **failure**        |
| _require_      | **requirement**    |
| _investigate_  | **investigation**  |
| _develop_      | **development**    |

**Compare:**

_We **decided** to **implement** the plan because the **results** were **significant**._
(informal — verb-heavy, personal)

_The **decision** was taken to proceed with **implementation** of the plan in light of the **significance** of the **results**._
(formal — nominalised, impersonal, no named subject)

> 🗡️ Tip: nominalisation also allows **impersonal**, passive constructions — notice how the second sentence removes the actor (_we_) entirely. This is deliberate in academic and bureaucratic writing.

## 🔮 Features of formal/academic tone

1. **No contractions** — write _it is_, not _it''s_; _do not_, not _don''t_.
2. **No first-person where possible** — prefer _it has been argued_ over _I think_.
3. **Hedging language** — _it appears that; it could be suggested; evidence suggests that…_
4. **Complex noun phrases** — _the implementation of the revised regulatory framework_.
5. **Latin/Greek vocabulary** — _subsequent_ (not _next_), _initial_ (not _first_), _prior to_ (not _before_).
6. **Passive voice** — _the report was compiled; the findings were presented_.

> ⚠️ Trap: over-nominalising produces **pompous, unreadable prose**. Good formal writing uses nominalisation strategically — not in every clause. Even academic writing needs active verbs for clarity.

## 🌍 Colloquial features to AVOID in formal writing

| Avoid                        | Prefer                                  |
| ---------------------------- | --------------------------------------- |
| _a lot of_                   | _a significant number of; considerable_ |
| _kind of / sort of_          | _somewhat; to some extent_              |
| _thing_                      | _factor; element; aspect_               |
| _get_ (= become)             | _become; prove; render_                 |
| Contractions (_it''s, don''t_) | Full forms                              |
| Starting with _And / But_    | _Furthermore; However; Nevertheless_    |

> 🏆 Gate cleared! Register mastery means knowing that every word choice is also a social signal. Formal, academic, and informal registers each have their grammar, vocabulary, and stance — and a C2 writer commands all three. Next: the subtle art of word choice and confusable pairs.', '# 📜 Résumé: Register, Formality and Nominalisation

- **Register** — the variety of language suited to the situation. Informal uses colloquial vocabulary, contractions, and phrasal verbs; formal uses precise Latinate vocabulary, full forms, and single-word verbs.
- **Phrasal verbs vs Latinate equivalents** — informal: _look into, put off, carry out, give up_; formal: _investigate, postpone/defer, conduct/execute, abandon/relinquish_. Avoid phrasal verbs in academic writing.
- **Nominalisation** — converting verbs/adjectives into nouns: _decide → decision; analyse → analysis; significant → significance; implement → implementation_. Nominalisation makes writing more formal, impersonal, and abstract.
- **Effect of nominalisation** — removes named actors (_we decided_ → _the decision was taken_), enables passive constructions, and signals academic/bureaucratic distance.
- **Formal tone markers** — no contractions; avoid first-person where possible; use hedging (_it has been suggested; evidence indicates_); prefer complex noun phrases and passive voice; use Latin/Greek vocabulary (_subsequent, initial, prior to_).
- ⚠️ Over-nominalising makes prose pompous and unreadable — use it strategically, not in every clause.
- **Colloquial words to replace in formal writing** — _a lot of → a significant number of; kind of → to some extent; thing → factor/aspect; get → become/prove; and/but → Furthermore/However_.', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('67f513ed-06bc-55e4-b8e6-a0c91c612378', 'anglais-c2', 'Nuance and Confusable Words', 'Achieve near-native precision by mastering the pairs and collocations that confuse even advanced learners: affect/effect, imply/infer, comprise/compose, sensible/sensitive, and many more — plus the art of connotation and collocation.', '# 🔮 Nuance and Confusable Words — The Art of the Right Word

> 💡 «Near-native English is not about knowing more words — it is about choosing the exact right one. Confusables are where even C1 speakers stumble. At C2, you command the difference.»

## 🏰 Why confusables matter

English has many pairs (and triplets) of words that look, sound, or feel similar but carry different meanings or grammatical roles. Using the wrong one — _imply_ instead of _infer_, _affect_ instead of _effect_ — signals that a speaker has not yet achieved mastery. At C2, you are expected to use these pairs correctly every time.

## ⚡ The essential confusable pairs

| Pair                                  | Rule                                                                                                  | Examples                                                                            |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| **affect** (verb) / **effect** (noun) | _affect_ = to have an impact on; _effect_ = the result/outcome                                        | _The cold **affected** her voice. The **effect** was noticeable._                   |
| **imply** (verb) / **infer** (verb)   | _imply_ = to suggest indirectly (speaker/writer); _infer_ = to deduce from evidence (listener/reader) | _She **implied** he was wrong. He **inferred** from her tone that she disagreed._   |
| **comprise** / **compose**            | _comprise_ = to consist of / be made up of; _compose_ = to make up                                    | _The committee **comprises** five members. Five members **compose** the committee._ |
| **sensible** / **sensitive**          | _sensible_ = having good judgement; _sensitive_ = easily affected emotionally / highly perceptive     | _That''s a **sensible** plan. He''s very **sensitive** to criticism._                 |
| **disinterested** / **uninterested**  | _disinterested_ = impartial, with no personal stake; _uninterested_ = not interested, bored           | _A **disinterested** judge. She seemed completely **uninterested** in the topic._   |
| **fewer** / **less**                  | _fewer_ = countable nouns; _less_ = uncountable nouns                                                 | **\*Fewer** mistakes; **less** time.\*                                              |
| **historic** / **historical**         | _historic_ = significant, landmark event; _historical_ = relating to history in general               | _A **historic** agreement. A **historical** novel._                                 |
| **continual** / **continuous**        | _continual_ = repeated frequently but with breaks; _continuous_ = without any interruption            | **\*Continual** interruptions. A **continuous** stream of data.\*                   |
| **principle** / **principal**         | _principle_ = a rule or belief; _principal_ = main / head of a school                                 | _The **principle** of fairness. The **principal** cause. The school **principal**._ |
| **complement** / **compliment**       | _complement_ = something that completes/goes well with; _compliment_ = expression of praise           | _The wine **complements** the dish. She paid me a **compliment**._                  |

> 🗡️ Tip: for _imply/infer_, a useful memory trick: **writers imply; readers infer**. The speaker/author puts the meaning _in_; the audience takes it _out_.

## 🛡️ Connotation: the invisible meaning

Two words can denote the same thing but carry different **connotations** (emotional associations):

| Word         | Denotation                    | Connotation                         |
| ------------ | ----------------------------- | ----------------------------------- |
| _slender_    | thin                          | positive: elegant, graceful         |
| _skinny_     | thin                          | slightly negative: unhealthily thin |
| _thrifty_    | careful with money            | positive: sensible                  |
| _miserly_    | careful with money            | negative: mean, selfish             |
| _assertive_  | confident in expressing views | positive: self-assured              |
| _aggressive_ | confident in expressing views | negative: hostile, confrontational  |

> ⚠️ Trap: _notorious_ means famous — but ONLY for something BAD. _Famous_ is neutral. _Renowned_ is positive. Never write _a notorious scientist_ to mean a great one.

## 🔮 Collocation: the right word''s right neighbour

A **collocation** is a pair of words that naturally go together. Using the wrong collocation sounds unnatural even if it is grammatically correct:

| Correct collocation  | Wrong (but grammatically fine)             |
| -------------------- | ------------------------------------------ |
| _make a decision_    | ~~_do a decision_~~                        |
| _have a shower_      | ~~_make a shower_~~                        |
| _do research_        | ~~_make research_~~                        |
| _raise awareness_    | ~~_rise awareness_~~                       |
| _a strong argument_  | ~~_a powerful argument_~~ (less idiomatic) |
| _deeply concerned_   | ~~_strongly concerned_~~                   |
| _commit a crime_     | ~~_make a crime_~~                         |
| _reach a conclusion_ | ~~_arrive a conclusion_~~                  |

> ⚠️ Trap: _raise_ vs _rise_. _Raise_ is transitive (needs an object): _raise prices, raise awareness_. _Rise_ is intransitive: _prices rise, the sun rises_. Never say _~~rise awareness~~_.

## 🌍 Effect as a verb?

Occasionally _effect_ IS used as a verb, meaning "to bring about, to make happen": _The new management **effected** significant changes._ This is rare and highly formal. The everyday rule holds: **affect = verb, effect = noun**.

> 🏆 Gate cleared! Every word choice is a message about your command of English. At C2, the right collocation, the correct connotation, and the precise confusable separate you from the near-native from the truly native-sounding writer. One chapter remains.', '# 📜 Résumé: Nuance and Confusable Words

- **affect/effect** — _affect_ (verb) = to have an impact on; _effect_ (noun) = the result. _(The cold affected her voice. The effect was noticeable.)_ Rare: _effect_ as a verb = to bring about (_effected great change_).
- **imply/infer** — _imply_ = to suggest indirectly (speaker/writer puts it in); _infer_ = to deduce (listener/reader takes it out). Memory: writers imply; readers infer.
- **comprise/compose** — _comprise_ = consist of (_The team comprises six members_); _compose_ = make up (_Six members compose the team_). Do NOT write _~~is comprised of~~_ in formal writing.
- **sensible/sensitive** — _sensible_ = showing good judgement; _sensitive_ = easily affected emotionally or highly perceptive.
- **disinterested/uninterested** — _disinterested_ = impartial (no personal stake); _uninterested_ = not interested, bored.
- **fewer/less** — _fewer_ for countable nouns (_fewer mistakes_); _less_ for uncountable nouns (_less time_).
- **continual/continuous** — _continual_ = repeated with breaks; _continuous_ = without any break.
- **complement/compliment** — _complement_ = completes or pairs well; _compliment_ = praise.
- **Connotation** — words can share a denotation but differ in tone: _slender_ (positive) vs _skinny_ (slightly negative); _thrifty_ vs _miserly_; _assertive_ vs _aggressive_. ⚠️ _Notorious_ = famous only for bad things.
- **Collocation** — words that naturally go together: _make a decision_ (not do); _do research_ (not make); _raise awareness_ (not rise); _commit a crime_ (not make); _deeply concerned_ (not strongly).', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('e45a5f31-4d6d-536e-b129-ddec5e7376ff', 'anglais-c2', 'Ellipsis, Substitution and Cohesion', 'Achieve native-level concision: understand when and how to omit predictable words (ellipsis), replace repeated elements with one/so/do so/neither/such (substitution), and use cohesive devices to link ideas smoothly across sentences.', '# 🌀 Ellipsis, Substitution and Cohesion — Writing Like a Native

> 💡 «Native speakers are masters of saying less while meaning more. Ellipsis and substitution remove the redundant; cohesive devices guide the reader effortlessly. Together, they make prose flow like water.»

## 🏰 What is ellipsis?

**Ellipsis** is the omission of words that are predictable from context — words that would be understood even without being stated. It makes language more natural, fluent, and concise.

_"Can you come?" — "I think [**I can come**]."_ → _"I think so."_ (substitution)
_"She can swim and [**she can**] dive."_ → _"She can swim and dive."_ (ellipsis)

There are three types:

| Type                 | What is omitted                 | Example                                                                                |
| -------------------- | ------------------------------- | -------------------------------------------------------------------------------------- |
| **Nominal ellipsis** | a noun that was just mentioned  | _"Take a biscuit if you want [**a biscuit**]."_ → _"…if you want one."_                |
| **Verbal ellipsis**  | a verb/predicate already stated | _"She finished the report before he [**finished the report**]."_ → _"…before he did."_ |
| **Clausal ellipsis** | an entire clause                | _"Are you coming?" "If I can [**come**]."_                                             |

> 🗡️ Tip: ellipsis is not grammatical carelessness — it is a deliberate, skilled choice. Repeating words unnecessarily is what sounds unnatural.

## ⚡ Substitution: one / ones, so / not, do so

**Substitution** replaces a repeated element with a pro-form:

| Substitute              | Replaces                         | Example                                                                 |
| ----------------------- | -------------------------------- | ----------------------------------------------------------------------- |
| **one / ones**          | a singular/plural noun           | _I need a pen — do you have [**a pen**]?_ → _do you have **one**?_      |
| **so**                  | an affirmative clause            | _"Is she coming?" "I think **so**."_ (= I think she is coming)          |
| **not**                 | a negative clause                | _"Will it rain?" "I hope **not**."_ (= I hope it will not rain)         |
| **do so / do the same** | an entire verb phrase            | _She submitted early; I intend to **do so** too._                       |
| **such**                | a noun phrase in formal contexts | _Errors of this kind are common. **Such** mistakes should be reported._ |
| **neither / nor**       | negative agreement               | _She didn''t complain, and **neither did I**._                           |

> 🗡️ Tip: _so_ follows think, believe, hope, expect, suppose, imagine, and say in this substitution pattern. _"I suppose so."_ — _"I expect so."_ — _"He said so."_

> ⚠️ Trap: _"She doesn''t like coffee." "I don''t, too."_ is wrong — use **neither/nor**: _"Neither do I."_ or _"Nor do I."_ Equally, _"She likes coffee." "So do I."_ — not _"So I do."_ (inversion is required after _so_ and _neither_).

## 🛡️ Clausal substitution: so and not

_"Is the project on track?" — "I believe **so**."_ (= I believe it is)
_"Did he pass?" — "I''m afraid **not**."_ (= I''m afraid he did not pass)

These replace the entire content of a yes/no question with a single word. This is very common in formal and informal spoken and written English.

## 🔮 Cohesion: linking ideas across sentences

**Cohesive devices** create logical and textual connections between sentences and paragraphs:

| Function               | Cohesive devices                                            |
| ---------------------- | ----------------------------------------------------------- |
| **Addition**           | _Furthermore, Moreover, In addition, Also_                  |
| **Contrast**           | _However, Nevertheless, On the other hand, Conversely, Yet_ |
| **Cause/result**       | _Therefore, Consequently, As a result, Hence, Thus_         |
| **Concession**         | _Although, Even though, Despite this, Admittedly_           |
| **Exemplification**    | _For instance, For example, Such as, Namely_                |
| **Summary/conclusion** | _In conclusion, To sum up, Overall, In short_               |

> ⚠️ Trap: _however_ is a **conjunctive adverb**, not a conjunction — it needs a semicolon or a new sentence before it: _The plan was approved; **however**, it was never implemented._ NOT _~~The plan was approved however it was never implemented.~~_

## 🌍 Reference chains: maintaining cohesion

Pronouns, demonstratives, and the definite article maintain **reference chains** — linking repeated concepts without repeating words:

_A new policy was introduced. **The policy** [definite article] aimed to reduce costs. **It** [pronoun] was well received._

| Device           | Example                                                              |
| ---------------- | -------------------------------------------------------------------- |
| Pronoun          | _Maria arrived late. **She** apologised immediately._                |
| Demonstrative    | _New findings were published. **These** challenged existing theory._ |
| Definite article | _A committee was formed. **The committee** met weekly._              |
| Synonym/hyponym  | _The company released a smartphone. **The device** sold quickly._    |

> 🗡️ Tip: vary your reference devices — using the pronoun _it_ or _they_ too many times in a row can create ambiguity. Mix in demonstratives (_this, these_), synonyms, and the definite article noun phrase.

> 🏆 Legendary status unlocked! You have completed the full C2 mastery track — subjunctive, idioms, register, nuance, and cohesion. You now command the structures, vocabulary, and texture that define near-native English. The quest for mastery never ends, but you are already there. 🏆', '# 📜 Résumé: Ellipsis, Substitution and Cohesion

- **Ellipsis** — omitting predictable words for concision. Three types: nominal (_take one if you want_), verbal (_she finished before he did_), clausal (_"Coming?" "If I can."_).
- **Substitution with one/ones** — replaces a repeated noun: _I need a pen — do you have **one**?_
- **Substitution with so/not** — replaces a full clause after think/believe/hope/expect/suppose/say: _"I think **so**" (= I think it''s true); "I hope **not**" (= I hope it won''t happen)._
- **Do so / do the same** — replaces a repeated verb phrase: _She submitted early; I intend to **do so** too._
- **Such** — formal substitution for a noun phrase: _Errors of this kind occur. **Such** mistakes should be reported._
- **Neither / nor** — negative agreement with inversion: _She didn''t come. **Neither did I**._ (NOT: _I don''t, too._)
- ⚠️ After _so_ (positive agreement) and _neither/nor_ (negative agreement), the subject and auxiliary are INVERTED: _So **do** I; Neither **did** she._ Never _"So I do."_
- **Cohesive devices** — Addition: _Furthermore, Moreover_; Contrast: _However, Nevertheless_; Result: _Therefore, Consequently, Hence_; Concession: _Despite this, Admittedly_; Exemplification: _For instance_; Conclusion: _In conclusion, To sum up_.
- ⚠️ _However_ is a conjunctive adverb, not a conjunction — use a semicolon or new sentence before it: _The plan was approved; **however**, it stalled._
- **Reference chains** — use pronouns, demonstratives (_this/these_), definite article + noun, and synonyms to maintain cohesion without repetition.', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('b354d6c0-ead3-55f6-9f68-bb5b3e951352', 'anglais-c2', 'Advanced Phrasal and Prepositional Verbs', 'Command the multi-word verbs that define near-native fluency: idiomatic two-part and three-part phrasal verbs (put up with, look down on, get away with, do away with), separability rules, precise meaning versus near-synonyms, and register — from slang to formal equivalents.', '# ⚔️ Advanced Phrasal and Prepositional Verbs — The Grammar of Native Fluency

> 💡 «A learner says "tolerate". A native speaker says "put up with". The vocabulary is the same — the register, the idiom, and the feel are entirely different.»

## 🏰 What multi-word verbs are

A **multi-word verb** is a verb combined with one or more particles (prepositions or adverbs) that together carry a single, often idiomatic, meaning. At C2 level you must not only recognise them but deploy them with precision: right meaning, right register, right particle order.

Three types exist at advanced level:

| Type                            | Structure                            | Example                               |
| ------------------------------- | ------------------------------------ | ------------------------------------- |
| **Phrasal verb** (intransitive) | verb + adverb                        | _The talks broke **down**._           |
| **Phrasal verb** (transitive)   | verb + adverb + object               | _She **put off** the meeting._        |
| **Three-part phrasal verb**     | verb + adverb + preposition + object | _He can''t **put up with** the noise._ |

Three-part phrasal verbs are always **inseparable** — the particles stay together.

## ⚡ Separability: the critical rule

**Separable** phrasal verbs allow (or require) the object to move between the particles:

_She **turned the offer down**._ = _She **turned down** the offer._ (both correct)

> 🗡️ Tip: when the object is a **pronoun**, it MUST go between the verb and particle: \*Turn it **down\***, NEVER _~~Turn down it~~_.

**Inseparable** verbs — including all three-part phrasal verbs — never split:

_I can **put up with** a lot of noise._ — NEVER _~~put a lot of noise up with~~_.

Prepositional verbs (verb + preposition, no adverb) are also **always inseparable**: _She **looks after** the children._ → _She looks after **them**._

## 🛡️ High-frequency C2 multi-word verbs by meaning cluster

| Verb              | Meaning                                  | Register         | Example                                                       |
| ----------------- | ---------------------------------------- | ---------------- | ------------------------------------------------------------- |
| _put up with_     | tolerate, endure                         | neutral–informal | _I can''t **put up with** this noise any longer._              |
| _look down on_    | regard as inferior                       | neutral          | _She **looks down on** anyone who hasn''t been to university._ |
| _get away with_   | escape without punishment                | neutral          | _He **got away with** cheating in the exam._                  |
| _do away with_    | abolish, eliminate                       | slightly formal  | _They voted to **do away with** the old rule._                |
| _come up against_ | encounter (a problem/obstacle)           | neutral          | _We **came up against** unexpected resistance._               |
| _look up to_      | admire and respect                       | neutral          | _Children **look up to** their teachers._                     |
| _go along with_   | agree with/accept                        | neutral          | _I can''t **go along with** that proposal._                    |
| _run out of_      | exhaust the supply of                    | neutral          | _We''ve **run out of** time._                                  |
| _face up to_      | accept and deal with honestly            | neutral          | _You need to **face up to** your responsibilities._           |
| _get on with_     | continue; also: have a good relationship | neutral          | _Just **get on with** your work._                             |

## 🔮 Nuance: near-synonyms and precise meaning

Multi-word verbs are rarely interchangeable with their single-word near-synonyms — register and connotation shift.

_put off_ → postpone (but "put off" also implies reluctance: _I was **put off** by his attitude._)
_bring about_ → cause (more formal, implies deliberate agency: _The reforms **brought about** significant change._)
_look into_ → investigate (neutral; _The police **looked into** the case._)
_account for_ → explain the existence or reason of (_That accounts for the delay._)

> ⚠️ Trap: _call off_ (cancel) ≠ _call out_ (challenge/expose) ≠ _call for_ (demand/require). The particle changes everything — never guess.

## 🧭 Register: when to choose the phrasal verb, when to avoid it

In **formal writing** (academic essays, legal documents), single-word Latinate verbs are preferred:

| Informal/neutral | Formal equivalent  |
| ---------------- | ------------------ |
| _put off_        | postpone           |
| _do away with_   | abolish, eliminate |
| _come up with_   | devise, propose    |
| _look into_      | investigate        |
| _set up_         | establish          |

In **spoken English, journalism, and narrative prose**, multi-word verbs are natural and expected. Using only Latinate verbs in speech sounds stiff and unnatural. A C2 speaker switches confidently between registers.

> 🗡️ Tip: three-part phrasal verbs (_put up with_, _look forward to_, _come up against_) tend to be **neutral to slightly informal** — they appear comfortably in journalism and educated speech but rarely in academic prose.

## 🌍 Common errors at C2

| Error                           | Correct form                | Why                                                   |
| ------------------------------- | --------------------------- | ----------------------------------------------------- |
| _~~He put up the noise with.~~_ | _He put up with the noise._ | Three-part verbs are inseparable.                     |
| _~~She looks down at them.~~_   | _She looks down on them._   | Particle _on_ carries the meaning "feel superior to". |
| _~~Turn down it.~~_             | _Turn it down._             | Pronoun objects go between verb and particle.         |
| _~~I got away from cheating.~~_ | _I got away with cheating._ | The collocated preposition is _with_, not _from_.     |

> ⚠️ Trap: _look after_ (care for) vs _look for_ (search for) vs _look into_ (investigate) vs _look up_ (find in a reference; also improve) — four distinct verbs sharing one base. Context and the exact particle are everything.

> 🏆 Gate cleared! You now control the multi-word verb system that separates proficient learners from near-native speakers. Master these clusters, respect the particles, and switch register with confidence. The C2 summit is within reach — one chapter remains.', '# 📜 Résumé: Advanced Phrasal and Prepositional Verbs

- **Three types** — intransitive phrasal verb (_break down_), transitive phrasal verb (_put off the meeting_), three-part phrasal verb (_put up with the noise_). Three-part verbs are always inseparable.
- **Separability rule** — separable verbs allow the object to move (_turn the offer down / turn down the offer_); pronoun objects MUST go between verb and particle (_turn it down_, never _~~turn down it~~_).
- **Inseparable verbs** — all three-part phrasal verbs and all prepositional verbs never split (_look after them_, never _~~look after it down~~_).
- **Key C2 clusters** — _put up with_ (tolerate), _look down on_ (regard as inferior), _get away with_ (escape punishment), _do away with_ (abolish), _come up against_ (encounter an obstacle), _look up to_ (admire), _go along with_ (agree), _face up to_ (accept honestly).
- **Near-synonyms differ** — _put off_ ≠ merely "postpone" (also implies reluctance/repulsion); _bring about_ implies deliberate agency; _call off / call out / call for_ are three different verbs sharing one base.
- **Register** — formal writing prefers Latinate equivalents (_postpone, abolish, establish, investigate_); multi-word verbs are natural in speech, journalism, and narrative prose. Three-part verbs sit at neutral-to-informal.
- ⚠️ The particle carries the meaning — _look after / look for / look into / look up_ are four distinct verbs. Never guess a particle; learn the collocation.
- ⚠️ _get away with_, not _get away from_ — the preposition is fixed and not interchangeable.', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('c78f470c-a153-5f88-ac60-8e5face49d02', 'anglais-c2', 'Reading: Critical Inference and Tone', 'Navigate sophisticated essays, literary prose, and journalism at near-native level: detect irony, implication, and authorial stance; analyse subtle tone shifts and rhetorical purpose; decode vocabulary-in-context; apply critical-reading strategies that unlock meaning beyond the literal.', '# 🔮 Reading: Critical Inference and Tone — Decoding What the Text Really Says

> 💡 «A competent reader understands what the writer says. A C2 reader understands what the writer means — including what they chose not to say.»

## 🏰 Beyond literal comprehension

At CEFR C2, a text is not just a string of propositions to decode. Sophisticated essays, literary prose, and journalism communicate **through tone, implication, and rhetorical choice** as much as through explicit statement. Critical reading means asking:

- **What is the author''s stance?** (positive, sceptical, ironic, ambivalent)
- **What is the rhetorical purpose?** (to inform, persuade, challenge, satirise, lament)
- **What is implied but not stated?** (inference)
- **How does word choice construct tone?** (connotation and register)

## ⚡ Reading for tone: the key signals

**Tone** is the writer''s attitude toward the subject or reader. It is rarely labelled — you infer it from:

| Signal                     | What to look for                                                                          | Example                                                                                |
| -------------------------- | ----------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| **Diction / word choice**  | Latinate formality vs Anglo-Saxon directness; evaluative adjectives                       | _"a catastrophic miscalculation"_ (critical) vs _"an unexpected outcome"_ (neutral)    |
| **Sentence rhythm**        | Short punchy sentences = urgency/irony; long subordinated clauses = deliberation or irony | _"They promised reform. They delivered chaos."_ (ironic deflation)                     |
| **Irony / understatement** | Saying less than is meant; the opposite of what is meant                                  | _"Not the most inspired policy the government has ever produced."_ = a damning verdict |
| **Hedging language**       | _perhaps, might, arguably, one could suggest_ = cautious or sceptical stance              |                                                                                        |
| **Rhetorical questions**   | Questions not expecting an answer — imply the answer is obvious                           | _"Can we really trust a system that has failed us so many times?"_                     |

## 🛡️ Types of inference

| Inference type              | Description                                                                   | Clue strategy                                                          |
| --------------------------- | ----------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| **Logical / propositional** | What must be true given the information stated                                | Eliminate options contradicted by the text                             |
| **Pragmatic**               | What the speaker implies (implicature) — Grice''s maxims                       | Ask: why would a rational writer say _this_?                           |
| **Connotative**             | What the word choice implies beyond its denotation                            | Check whether the writer chose a positive, negative, or loaded synonym |
| **Structural**              | What the order and emphasis reveal (what comes first / last = most important) | Note topic sentences, the final sentence of each paragraph             |

> 🗡️ Tip: the **last sentence** of a paragraph almost always carries the writer''s evaluative conclusion on that point. If you are hunting for the author''s opinion, read endings.

## 🔮 Vocabulary in context: C2 strategy

Never stop at a word''s base meaning. Ask three questions:

1. **Denotation** — what does it literally mean here?
2. **Connotation** — is it positive, negative, neutral, ironic?
3. **Register** — is this formal, colloquial, archaic, technical? What does the choice reveal about the writer''s stance?

_"The minister **unveiled** the policy."_ (neutral, slightly ceremonial)
_"The minister **unleashed** the policy."_ (alarming, implies the policy is dangerous or aggressive)

Both share a base meaning of "revealed publicly" but the connotation is entirely different.

> ⚠️ Trap: at C2 you will not be tricked by obviously wrong answers — distractors are crafted from **plausible misreadings**: words that appear in the text but are used in a different sense, or inferences that go _slightly too far_ beyond what the text actually supports. Stay tethered to the text.

## 🧭 Authorial stance and rhetorical purpose

| Stance / purpose               | Linguistic markers                                                                               |
| ------------------------------ | ------------------------------------------------------------------------------------------------ |
| **Argumentative / persuasive** | modal certainty (_must, clearly, undoubtedly_), rhetorical questions, direct address (_we, you_) |
| **Satirical / ironic**         | hyperbole, understatement, incongruity, mock-formal register applied to trivial matters          |
| **Analytical / detached**      | passive constructions, hedging (_it could be argued_), absence of first person                   |
| **Elegiac / lamenting**        | emotive vocabulary, past perfect for lost states, nostalgic tone                                 |
| **Polemical**                  | adversarial framing, strong negatives, polarising contrasts                                      |

## 🌍 Critical-reading strategies in practice

**Step 1 — Skim for gist and structure.** Identify what kind of text this is and roughly what it is about before reading any questions.

**Step 2 — Read the questions before re-reading the text.** At C2, every question targets a specific inferential move. Know what you are hunting for.

**Step 3 — Locate, don''t lift.** Find the relevant passage; do not simply match keywords. C2 distractors deliberately reuse surface words with changed meaning.

**Step 4 — Test inferences against the text.** A valid inference must be _supportable_ from the text — not just consistent with general knowledge or common sense.

**Step 5 — Check tone against the whole passage.** A single sentence may be ironic while the rest of the passage is sincere. Tone operates at the level of the **whole text**.

> ⚠️ Trap: "the author implies" ≠ "the author states". An _implied_ meaning is suggested without being stated outright; a _stated_ meaning is explicit. Examination questions distinguish these carefully. Don''t confuse them.

> 🏆 Gate cleared — and the C2 journey is complete! You now read at near-native level: decoding not just what a text says, but how it says it, why it was written, and what it deliberately leaves unsaid. Carry these skills into every essay, article, and novel you encounter. The summit belongs to you.', '# 📜 Résumé: Reading: Critical Inference and Tone

- **Beyond literal reading** — C2 reading asks: what is the author''s _stance_, _rhetorical purpose_, and what is _implied but not stated_?
- **Tone signals** — diction/word choice (evaluative adjectives, Latinate vs Anglo-Saxon register), sentence rhythm, irony/understatement (_"not the most inspired policy"_ = damning), hedging (_perhaps, arguably_), rhetorical questions (imply an obvious answer).
- **Four inference types** — logical/propositional (must be true), pragmatic (implicature — why would the writer say _this_?), connotative (positive/negative loading of word choice), structural (order and emphasis — last sentence of a paragraph = evaluative conclusion).
- **Vocabulary in context** — ask denotation + connotation + register for every key word; _"unveiled"_ (neutral) vs _"unleashed"_ (alarming) share a base meaning but signal opposite stances.
- **Authorial stance markers** — persuasive: modal certainty + rhetorical questions; satirical: hyperbole + incongruity + mock-formal register; analytical: passives + hedging + no first person; polemical: adversarial framing + strong negatives.
- **Five-step strategy** — (1) skim for gist/structure; (2) read questions before re-reading; (3) locate, don''t lift (surface keywords are traps); (4) test inferences against the text; (5) check tone across the whole passage, not just one sentence.
- ⚠️ C2 distractors reuse surface words with changed meaning, or make inferences that go _slightly too far_ beyond what the text supports — stay tethered to the text.
- ⚠️ "The author implies" ≠ "the author states" — implied meaning is suggested without being stated; examination questions distinguish these deliberately.', 7, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8b31f7ef-cf72-55f6-aaac-8f4f312753f6', '0c302304-ca15-59f6-9e00-67b6f95caf87', 'anglais-c2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('fe8e22c6-0b1a-5825-a215-8d950e8d4bb1', '8b31f7ef-cf72-55f6-aaac-8f4f312753f6', 'Complete: "The committee insists that every delegate ___ present at the vote."', '[{"id":"a","text":"is"},{"id":"b","text":"be"},{"id":"c","text":"was"},{"id":"d","text":"should be"}]'::jsonb, 'b', 'After a mandative verb like insist, the that-clause takes the present subjunctive — the bare base form with no -s and no auxiliary: every delegate be. "is" is ordinary indicative, "was" is past indicative, and "should be" is a less formal alternative but not the subjunctive itself.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2a4513b-690b-5b4f-a8c0-51b08868c6fe', '8b31f7ef-cf72-55f6-aaac-8f4f312753f6', 'Which sentence uses the subjunctive CORRECTLY?', '[{"id":"a","text":"I suggest that he goes home immediately."},{"id":"b","text":"It is vital that she submits the form today."},{"id":"c","text":"The judge ordered that the prisoner be released."},{"id":"d","text":"They demand that he is paid at once."}]'::jsonb, 'c', 'Option (c) correctly uses the present subjunctive be released (base form). (a) has the error goes — should be go; (b) has submits — should be submit; (d) has is paid — should be be paid. Only (c) uses the bare base form throughout.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('680a95b8-6440-5834-9187-57e73b786a53', '8b31f7ef-cf72-55f6-aaac-8f4f312753f6', 'Complete with the correct formal inverted conditional: "___ I to discover any irregularities, I would report them immediately."', '[{"id":"a","text":"Were"},{"id":"b","text":"Would"},{"id":"c","text":"Should"},{"id":"d","text":"Had"}]'::jsonb, 'a', 'The inverted equivalent of "If I were to discover…" is "Were I to discover…" — using were + subject + to-infinitive. "Would" cannot begin an inverted conditional. "Should" inverts "if + should" and would work with "Should I discover…", but the to-infinitive slot here signals were. "Had" inverts a past perfect (Had I discovered…).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6650c2a7-fd06-52f4-afd6-08727dfa23c1', '8b31f7ef-cf72-55f6-aaac-8f4f312753f6', 'Complete: "It''s high time you ___ your driving test — you keep putting it off."', '[{"id":"a","text":"take"},{"id":"b","text":"taking"},{"id":"c","text":"took"},{"id":"d","text":"to take"}]'::jsonb, 'c', '"It''s high time" is followed by a past-tense form (the unreal past) to signal that something is overdue: It''s high time you took your test. The present tense take, the -ing form, and the to-infinitive are all incorrect in this structure.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f2c994e-ba89-590a-886f-d428c3a9866c', '8b31f7ef-cf72-55f6-aaac-8f4f312753f6', 'Complete: "I''d rather you ___ me the truth straight away."', '[{"id":"a","text":"tell"},{"id":"b","text":"told"},{"id":"c","text":"to tell"},{"id":"d","text":"telling"}]'::jsonb, 'b', 'When I''d rather refers to someone else''s action, the following clause takes the past tense (unreal past): I''d rather you told me. The present tense tell, the to-infinitive, and -ing are all wrong here. (With the same subject — I''d rather go — you use the bare infinitive, but here the subjects differ.)', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('64860b23-75c2-55af-8707-f446f545efa9', '0c302304-ca15-59f6-9e00-67b6f95caf87', 'anglais-c2', '⭐ Practice: Mandative Subjunctive', 1, 50, 10, 'practice', 'admin', 1)
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
  ('8fe292a6-48d2-55b8-bf0e-995c0f7ef8a6', '64860b23-75c2-55af-8707-f446f545efa9', 'Complete: "The director recommended that the report ___ revised before publication."', '[{"id":"a","text":"is"},{"id":"b","text":"was"},{"id":"c","text":"be"},{"id":"d","text":"should be"}]'::jsonb, 'c', 'After recommend + that, the present subjunctive requires the bare base form: be revised. "is" is indicative, "was" is past, and "should be" is a less formal substitute, not the subjunctive itself.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e4c5d72-3948-55c1-a831-64c504b75756', '64860b23-75c2-55af-8707-f446f545efa9', 'Which sentence correctly uses the mandative subjunctive?', '[{"id":"a","text":"She insists that he works harder."},{"id":"b","text":"It is essential that everyone sign the register."},{"id":"c","text":"They proposed that the meeting is cancelled."},{"id":"d","text":"We demand that she pays immediately."}]'::jsonb, 'b', 'Only (b) is correct: essential that everyone sign uses the subjunctive base form sign. (a) has works — should be work; (c) has is — should be be; (d) has pays — should be pay. The subjunctive base form never takes -s.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8b02cdc-f07d-5388-8a0d-97955955a9ef', '64860b23-75c2-55af-8707-f446f545efa9', 'Complete: "The regulations require that all staff ___ a security badge at all times."', '[{"id":"a","text":"wear"},{"id":"b","text":"wears"},{"id":"c","text":"wore"},{"id":"d","text":"are wearing"}]'::jsonb, 'a', 'Require triggers the mandative subjunctive: the base form wear is used for all subjects, including third-person plural. "wears" adds -s incorrectly, "wore" is past, and "are wearing" is continuous.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf1952b4-607e-5a18-82cc-9fb4a92f486a', '64860b23-75c2-55af-8707-f446f545efa9', 'Find the INCORRECT sentence.', '[{"id":"a","text":"I suggest that we meet tomorrow morning."},{"id":"b","text":"It is vital that she be informed at once."},{"id":"c","text":"The court ordered that he appears in person."},{"id":"d","text":"They urged that the proposal be withdrawn."}]'::jsonb, 'c', 'The error is (c): after the court ordered that, the subjunctive base form is required — he appear, not he appears. (a), (b), and (d) all correctly use the bare base form (meet, be, be withdrawn).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00d2afb4-d2dc-5a33-85ab-f3189c1c5e53', '64860b23-75c2-55af-8707-f446f545efa9', 'Complete: "It is imperative that the vaccine ___ stored below 8°C."', '[{"id":"a","text":"is"},{"id":"b","text":"be"},{"id":"c","text":"being"},{"id":"d","text":"to be"}]'::jsonb, 'b', 'The adjective imperative triggers the subjunctive: it is imperative that [subject] + base form. The correct passive subjunctive is be stored. "is stored" is indicative, "being stored" is a participle, and "to be stored" is an infinitive — none of these are the subjunctive.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29053b29-9aeb-5473-8906-8317a99ae4cc', '64860b23-75c2-55af-8707-f446f545efa9', 'Complete: "The consultant proposed that the contract ___ renegotiated before the end of the quarter."', '[{"id":"a","text":"was"},{"id":"b","text":"is"},{"id":"c","text":"has been"},{"id":"d","text":"be"}]'::jsonb, 'd', 'Propose triggers the mandative subjunctive: the contract be renegotiated. The base form of to be is be — not was, is, or has been. Even in a past-tense sentence (proposed), the subjunctive verb in the that-clause stays in the base form.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4487a502-7e63-5ca0-858e-5b6960ce16be', '0c302304-ca15-59f6-9e00-67b6f95caf87', 'anglais-c2', '⭐⭐ Review: Unreal Past and Formal Inversions', 2, 75, 15, 'practice', 'admin', 2)
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
  ('a6d7e5f6-ee92-5eaa-a992-349024038808', '4487a502-7e63-5ca0-858e-5b6960ce16be', 'Complete: "It''s high time the government ___ action on climate change."', '[{"id":"a","text":"took"},{"id":"b","text":"take"},{"id":"c","text":"takes"},{"id":"d","text":"has taken"}]'::jsonb, 'a', '"It''s high time" is always followed by the past tense (unreal past) to express that something is overdue: took. The present tense takes or take and the present perfect has taken are all incorrect after this fixed expression.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea964b7c-4c1c-5858-984b-02106f04b2c4', '4487a502-7e63-5ca0-858e-5b6960ce16be', 'Choose the correct formal inverted conditional.', '[{"id":"a","text":"Would you need further assistance, call us."},{"id":"b","text":"Should you need further assistance, please call us."},{"id":"c","text":"If should you need further assistance, please call us."},{"id":"d","text":"Did you need further assistance, please call us."}]'::jsonb, 'b', 'The inverted conditional of "If you should need…" is "Should you need…" — invert the subject and should, then drop if. (a) wrongly starts with Would; (c) keeps if and adds should, which is a double error; (d) uses Did, which cannot begin this structure.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('482f3c52-40da-5f76-8500-57942fb0785a', '4487a502-7e63-5ca0-858e-5b6960ce16be', 'Complete: "I''d rather you ___ your phone during the meeting."', '[{"id":"a","text":"don''t use"},{"id":"b","text":"didn''t use"},{"id":"c","text":"not use"},{"id":"d","text":"wouldn''t use"}]'::jsonb, 'b', '"I''d rather" with a different subject takes the past tense in the following clause: didn''t use. "Don''t use" is present tense, "not use" is a bare negative infinitive, and "wouldn''t use" mixes conditionals incorrectly.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a39d9a1-cb97-50d8-95a4-d9590c812a52', '4487a502-7e63-5ca0-858e-5b6960ce16be', 'Complete: "___ she have listened to our advice, none of this would have happened."', '[{"id":"a","text":"Were"},{"id":"b","text":"Should"},{"id":"c","text":"Had"},{"id":"d","text":"Would"}]'::jsonb, 'c', 'The past perfect inverted conditional uses Had: "Had she listened…" is the formal equivalent of "If she had listened…". "Were" inverts were to + infinitive (present/future). "Should" inverts a present/future possibility. "Would" can never begin an inverted conditional.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2f68d8c-7be9-532c-ab19-72018f0a5a6e', '4487a502-7e63-5ca0-858e-5b6960ce16be', 'Complete: "He talks as if he ___ the only expert in the room."', '[{"id":"a","text":"is"},{"id":"b","text":"be"},{"id":"c","text":"was"},{"id":"d","text":"were"}]'::jsonb, 'd', '"As if" introducing an unreal comparison takes the past subjunctive were for all persons in formal/written English: as if he were. "Is" treats it as real (indicative). "Was" is acceptable colloquially but were is the correct formal/C2 form. "Be" is the present subjunctive, not used here.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67e4cd98-3c2d-52dc-bfea-22fa62746d38', '4487a502-7e63-5ca0-858e-5b6960ce16be', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Were I to accept, I would need more time."},{"id":"b","text":"Had we known earlier, we could have helped."},{"id":"c","text":"It''s high time they updated their systems."},{"id":"d","text":"Should she arrives late, ask her to wait."}]'::jsonb, 'd', 'The error is (d): after "Should" in an inverted conditional, the verb stays in the base form — "Should she arrive late…", not arrives. (a), (b), and (c) are all correct: were I to accept, had we known, and it''s high time + past tense are all standard C2 structures.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a634825d-c3d6-58da-a20b-a3353d52ddb6', '0c302304-ca15-59f6-9e00-67b6f95caf87', 'anglais-c2', '⚔️ Chapter Boss ⭐⭐⭐: The Subjunctive and Unreal Past', 3, 120, 30, 'boss', 'admin', 3)
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
  ('f0f8ff6e-b81a-5c93-82b5-bfb001238dba', 'a634825d-c3d6-58da-a20b-a3353d52ddb6', 'Find the INCORRECT sentence.', '[{"id":"a","text":"I suggest that he take a different approach."},{"id":"b","text":"It is necessary that all documents be signed."},{"id":"c","text":"The manager demanded that she works overtime."},{"id":"d","text":"We recommend that the policy be reviewed annually."}]'::jsonb, 'c', 'The error is (c): after demand + that, the subjunctive base form is required — she work, not she works. (a) take, (b) be signed, and (d) be reviewed are all correct subjunctive forms (bare base, no -s, no auxiliary).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87bea223-fa9a-548b-9f57-f42af545212c', 'a634825d-c3d6-58da-a20b-a3353d52ddb6', 'Complete: "___ this information to reach the press, the consequences would be catastrophic."', '[{"id":"a","text":"Should"},{"id":"b","text":"Were"},{"id":"c","text":"Had"},{"id":"d","text":"Would"}]'::jsonb, 'b', 'The full non-inverted version is "If this information were to reach the press…" — an unreal future condition using were to. The inverted form drops if and puts Were first: Were this information to reach… "Should" inverts "If…should"; "Had" inverts past perfect; "Would" cannot invert.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9b3e3a1-62dd-5ab1-86bf-5cb92f69f838', 'a634825d-c3d6-58da-a20b-a3353d52ddb6', 'Read: "If only I had revised more thoroughly, I would have passed the exam."
Choose the EQUIVALENT sentence.', '[{"id":"a","text":"Had I revised more thoroughly, I would have passed the exam."},{"id":"b","text":"Should I revise more thoroughly, I will pass the exam."},{"id":"c","text":"Were I to revise more thoroughly, I would pass the exam."},{"id":"d","text":"I''d rather I revised more thoroughly to pass the exam."}]'::jsonb, 'a', '"If only I had revised" is a past-perfect unreal condition; the inverted equivalent is "Had I revised more thoroughly…" with the same result clause. (b) is a future possibility (wrong tense relationship). (c) is an unreal future, not past. (d) misuses I''d rather.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7571029-6fb7-5678-93e9-c5828664d2e3', 'a634825d-c3d6-58da-a20b-a3353d52ddb6', 'Complete: "I''d sooner we ___ the meeting until next week."', '[{"id":"a","text":"postpone"},{"id":"b","text":"will postpone"},{"id":"c","text":"postponed"},{"id":"d","text":"had postponed"}]'::jsonb, 'c', '"I''d sooner" (= I''d rather) followed by a different subject takes the past tense: I''d sooner we postponed. The present tense postpone, the future will postpone, and the past perfect had postponed are all incorrect in this fixed structure.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5b69a17-c40f-5d62-b6ee-96c2433f1fbd', 'a634825d-c3d6-58da-a20b-a3353d52ddb6', 'Which option correctly transforms the sentence into a formal inverted conditional?
"If there should be any questions, please contact our helpdesk."', '[{"id":"a","text":"Were there any questions, please contact our helpdesk."},{"id":"b","text":"Had there been any questions, please contact our helpdesk."},{"id":"c","text":"Would there be any questions, please contact our helpdesk."},{"id":"d","text":"Should there be any questions, please contact our helpdesk."}]'::jsonb, 'd', '"If there should be" inverts to "Should there be" — keeping the present/future meaning. (a) Were there inverts a were-conditional (unreal present); (b) Had there been inverts a past perfect (past unreal); (c) Would cannot invert. Only (d) is the correct transformation.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d566febb-b341-5149-8cb0-8e6a8d44e3c0', 'a634825d-c3d6-58da-a20b-a3353d52ddb6', 'Complete with the most formal and grammatically precise option: "It is crucial that the witness ___ the truth and nothing but the truth."', '[{"id":"a","text":"will tell"},{"id":"b","text":"tell"},{"id":"c","text":"tells"},{"id":"d","text":"should tell"}]'::jsonb, 'b', 'The adjective crucial triggers the mandative subjunctive: the witness tell (bare base form). "Will tell" is a future indicative, "tells" is third-person present indicative (adds -s, which is wrong in the subjunctive), and "should tell" is an informal alternative — grammatically acceptable but not the purest subjunctive form expected at C2.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('866a4bf4-1304-5dab-be78-2044f054d2e1', '0c302304-ca15-59f6-9e00-67b6f95caf87', 'anglais-c2', '👑 Elite Challenge ⭐⭐⭐⭐: The Subjunctive and Unreal Past', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('19dfe3d9-d087-5b5b-876c-cc18562b41e3', '866a4bf4-1304-5dab-be78-2044f054d2e1', 'Read: "The board of directors insists that the CEO present a revised strategy. Were the plan to fail, the entire leadership team would be held accountable. It is imperative that no detail be overlooked."
Which statement about the subjunctives in this extract is TRUE?', '[{"id":"a","text":"\"Present\" and \"be overlooked\" are both examples of the mandative subjunctive."},{"id":"b","text":"\"Were the plan to fail\" uses the same subjunctive form as \"insists that he present\"."},{"id":"c","text":"\"Be overlooked\" is the only subjunctive form in the text."},{"id":"d","text":"\"Present\" is the present continuous, not the subjunctive."}]'::jsonb, 'a', 'Both present (after insists that the CEO) and be overlooked (after it is imperative that) are mandative subjunctives — bare base forms in that-clauses after a demanding/imperative trigger. "Were the plan to fail" is the past subjunctive in an inverted conditional, a different though related form. (b) is false because they use different subjunctive forms. (c) is false — present is also subjunctive. (d) is false — present here is subjunctive, not continuous.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('81f4bb31-c53e-5583-bd29-d970bb0c9e77', '866a4bf4-1304-5dab-be78-2044f054d2e1', 'Find the sentence that contains an error in the use of the unreal past or subjunctive.', '[{"id":"a","text":"Had the scientist published her findings sooner, the treatment might have been approved."},{"id":"b","text":"It''s high time the authorities took these complaints seriously."},{"id":"c","text":"Were I in your position, I would seek legal advice immediately."},{"id":"d","text":"I''d rather you don''t mention this to anyone outside the team."}]'::jsonb, 'd', 'The error is (d): "I''d rather you" with a different subject requires the past tense — I''d rather you didn''t mention. Using the present tense don''t is incorrect. (a) Had the scientist published is a correct past-perfect inversion; (b) it''s high time + past (took) is correct; (c) were I in your position is correct past subjunctive.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9ac13b2-ec8e-51f1-aebb-28244c323f7f', '866a4bf4-1304-5dab-be78-2044f054d2e1', 'Complete with the most natural and formally correct option: "___ anyone ask about the merger, our official position is that no decision has been reached."', '[{"id":"a","text":"Were"},{"id":"b","text":"Had"},{"id":"c","text":"Should"},{"id":"d","text":"Would"}]'::jsonb, 'c', '"Should anyone ask" is the inverted form of "If anyone should ask" — a present/future possibility expressed formally. "Were" would need to + infinitive (Were anyone to ask). "Had" would require a past participle (Had anyone asked). "Would" cannot invert. Only Should fits a present/future open condition.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cee9dd38-eca4-555d-85cf-7d58c7a8c822', '866a4bf4-1304-5dab-be78-2044f054d2e1', 'Choose the sentence in which the subjunctive or unreal past is used with the most precise and formal register.', '[{"id":"a","text":"The manager suggested that he should apologise to the client."},{"id":"b","text":"The manager suggested that he apologise to the client."},{"id":"c","text":"The manager suggested that he apologises to the client."},{"id":"d","text":"The manager suggested that he will apologise to the client."}]'::jsonb, 'b', 'The purest, most formal subjunctive is the bare base form: he apologise (no -s, no auxiliary). (a) he should apologise is a grammatically acceptable less formal alternative but not the subjunctive itself. (c) he apologises incorrectly adds -s. (d) he will apologise uses the future indicative, which is ungrammatical in this structure.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba80a72b-182a-5726-a43f-4bcd105cc7e3', '866a4bf4-1304-5dab-be78-2044f054d2e1', 'Find the sentence with an error in a subjunctive or unreal-past structure.', '[{"id":"a","text":"Supposing she were to refuse, what would our next move be?"},{"id":"b","text":"It is essential that every candidate submits a portfolio by Friday."},{"id":"c","text":"Had I been warned, I wouldn''t have signed the contract."},{"id":"d","text":"I''d sooner we started the meeting without him."}]'::jsonb, 'b', 'The error is (b): after "it is essential that", the mandative subjunctive requires the bare base form — every candidate submit (not submits). Adding -s is the classic subjunctive error. (a) uses supposing + were to correctly (unreal future); (c) uses had + past participle correctly (past-perfect inversion); (d) uses I''d sooner + past tense correctly (unreal past with a different subject).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('248b1e79-a72b-5089-bbd9-754c9b3a5a48', '866a4bf4-1304-5dab-be78-2044f054d2e1', 'Read: "It''s high time somebody spoke up about these working conditions. Were an employee to raise concerns formally, they would be entitled to full legal protection. I''d rather the union took the lead on this."
What do the three highlighted structures have in common?', '[{"id":"a","text":"They all use the mandative subjunctive."},{"id":"b","text":"They all require the same verb form — the past simple."},{"id":"c","text":"They all express a hypothetical or unreal situation through a past or subjunctive form."},{"id":"d","text":"They all invert subject and auxiliary."}]'::jsonb, 'c', '"It''s high time somebody spoke" (unreal past), "Were an employee to raise" (past subjunctive inversion), and "I''d rather the union took" (unreal past) all use a non-present verb form to signal that the situation is hypothetical or not yet real. (a) is wrong — none uses the mandative subjunctive (those appear after demand/insist/etc.). (b) is partly right but imprecise — "were" is past subjunctive, not past simple. (d) is wrong — only the second structure inverts.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2adac661-005a-5adf-b7d6-eb8fa886e902', '0c302304-ca15-59f6-9e00-67b6f95caf87', 'anglais-c2', '⭐⭐ Drill: The Subjunctive and Unreal Past', 2, 75, 15, 'practice', 'admin', 5)
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
  ('d1a249b5-7e9c-56b6-acfd-819ef3c3e123', '2adac661-005a-5adf-b7d6-eb8fa886e902', 'Complete: "The board demands that every director ___ a conflict-of-interest declaration before voting."', '[{"id":"a","text":"signs"},{"id":"b","text":"sign"},{"id":"c","text":"signed"},{"id":"d","text":"will sign"}]'::jsonb, 'b', 'After a mandative verb like demand, the that-clause requires the present subjunctive — the bare base form with no -s and no auxiliary: every director sign. Adding -s (signs) is the classic subjunctive error; signed is past indicative; will sign introduces a future auxiliary that is never used in the subjunctive.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6012c3c6-ffb1-5dfd-bbf9-e557f26f21a7', '2adac661-005a-5adf-b7d6-eb8fa886e902', 'Complete: "It''s about time the council ___ something about the potholes — the roads have been dangerous for months."', '[{"id":"a","text":"does"},{"id":"b","text":"do"},{"id":"c","text":"did"},{"id":"d","text":"will do"}]'::jsonb, 'c', '"It''s about time" (like "it''s high time") signals that something is overdue and takes the past tense — the unreal past — in the following clause: the council did something. The present tense does or do and the future will do are all incorrect after this fixed expression.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bd633468-25de-5d0e-9493-9d1624d27b68', '2adac661-005a-5adf-b7d6-eb8fa886e902', 'Complete: "___ they to withdraw their bid, the entire procurement process would need to be restarted."', '[{"id":"a","text":"Should"},{"id":"b","text":"Had"},{"id":"c","text":"Were"},{"id":"d","text":"Would"}]'::jsonb, 'c', 'The inverted form of "If they were to withdraw" is "Were they to withdraw" — using were + subject + to-infinitive. Should inverts "if + should" and works with a bare infinitive (Should they withdraw), but the to-infinitive slot here signals were. Had inverts a past perfect. Would can never begin an inverted conditional.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('81cb6c1f-486a-518d-94f6-8b9b5b4237e1', '2adac661-005a-5adf-b7d6-eb8fa886e902', 'Which sentence correctly uses the mandative subjunctive?', '[{"id":"a","text":"She urged that he should apologises at once."},{"id":"b","text":"It is essential that the submission be received by noon."},{"id":"c","text":"We propose that the committee is restructured."},{"id":"d","text":"The rules stipulate that each candidate submits a portfolio."}]'::jsonb, 'b', 'Only the second option is correct: essential that the submission be received uses the passive present subjunctive (base form of be). The first option combines two errors: should and the third-person -s on apologises. The third has is instead of be. The fourth has submits — the subjunctive requires submit (no -s).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a9833f0-be4f-5009-ade9-73c09eb5b936', '2adac661-005a-5adf-b7d6-eb8fa886e902', 'Complete: "He speaks as though he ___ the sole authority on the matter — yet he has published nothing."', '[{"id":"a","text":"is"},{"id":"b","text":"be"},{"id":"c","text":"was"},{"id":"d","text":"were"}]'::jsonb, 'd', '"As though" introducing an unreal comparison takes the past subjunctive were (for all persons) in formal written English: as though he were. Is treats the claim as real fact. Was is colloquially acceptable but were is the correct C2 formal form. Be is the present subjunctive, not used in this as-though structure.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ae976f0-4d56-5355-b7c2-b09d8591d95c', '2adac661-005a-5adf-b7d6-eb8fa886e902', 'Find the sentence that contains an error in a subjunctive or unreal-past structure.', '[{"id":"a","text":"Had the pilot been warned, the incident could have been avoided."},{"id":"b","text":"I''d rather the children didn''t hear this conversation."},{"id":"c","text":"It is vital that the witness be interviewed before the hearing."},{"id":"d","text":"Should she arrives early, ask her to wait in the lobby."}]'::jsonb, 'd', 'The error is in the last option: after Should in an inverted conditional, the verb must be in the base form — Should she arrive early. Adding -s (arrives) is ungrammatical. The first option correctly uses the past-perfect inversion Had the pilot been. The second correctly uses I''d rather + different subject + past tense (didn''t). The third correctly uses the mandative subjunctive be interviewed.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7f794398-5176-5f36-bad3-70f1438aeaa2', 'e309b05b-3990-599d-bdfb-4988302f698c', 'anglais-c2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('eb0ce85d-a5b5-5376-8b9b-71a2e06a775b', '7f794398-5176-5f36-bad3-70f1438aeaa2', 'What does the idiom "spill the beans" mean?', '[{"id":"a","text":"Make a mess in the kitchen."},{"id":"b","text":"Reveal a secret."},{"id":"c","text":"Cook something too quickly."},{"id":"d","text":"Become very angry."}]'::jsonb, 'b', '"Spill the beans" is an idiom meaning to accidentally or deliberately reveal a secret. It has nothing to do with cooking, making a mess, or anger — those are literal or wrong figurative associations.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13804d18-1dbf-580a-a4fd-b4bccb68ae6a', '7f794398-5176-5f36-bad3-70f1438aeaa2', 'What is the KEY difference between a metaphor and a simile?', '[{"id":"a","text":"A metaphor uses like or as; a simile does not."},{"id":"b","text":"A simile uses like or as; a metaphor does not."},{"id":"c","text":"Both always use like or as."},{"id":"d","text":"A metaphor is always about the weather."}]'::jsonb, 'b', 'A simile makes an explicit comparison using like or as (as cool as a cucumber; he ran like the wind). A metaphor makes an implicit comparison without these words (she devoured the book; life is a journey). Options (a) reverses the definition; (c) and (d) are simply wrong.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('371aadf7-ee82-5eb4-ac99-4436f6c31e39', '7f794398-5176-5f36-bad3-70f1438aeaa2', 'Complete: "The manager always calls ___ — he says exactly what he thinks without softening it."', '[{"id":"a","text":"a spade a spade"},{"id":"b","text":"the cats out"},{"id":"c","text":"a ball a ball"},{"id":"d","text":"the bucket"}]'::jsonb, 'a', '"Call a spade a spade" means to speak plainly and directly without euphemism. "Let the cats out" is a distortion of "let the cat out of the bag". "Call a ball a ball" does not exist. "Kick the bucket" means to die — entirely different.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('51ed5ed9-dbf6-5e43-9851-bbd3109a67ee', '7f794398-5176-5f36-bad3-70f1438aeaa2', 'What does "the tip of the iceberg" mean in context?', '[{"id":"a","text":"The most important and visible part of a problem."},{"id":"b","text":"A cold, unwelcoming atmosphere."},{"id":"c","text":"A dangerous situation with no solution."},{"id":"d","text":"A small, visible sign of a much larger hidden problem."}]'::jsonb, 'd', '"The tip of the iceberg" refers to the small visible portion of an iceberg above water — used figuratively to mean the visible sign of a much larger hidden problem. (a) is almost the opposite; (b) and (c) invent meanings not supported by the course.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('343dbad2-ac63-5516-8e15-9413c60de40b', '7f794398-5176-5f36-bad3-70f1438aeaa2', '"She was like a fish out of water at the formal dinner."
What does this SIMILE mean?', '[{"id":"a","text":"She ate a great deal of fish."},{"id":"b","text":"She felt ill and could not eat."},{"id":"c","text":"She was uncomfortable in an unfamiliar environment."},{"id":"d","text":"She left the dinner early."}]'::jsonb, 'c', '"Like a fish out of water" is a simile for someone who feels out of place or uncomfortable in an unfamiliar situation. It has nothing to do with eating, illness, or leaving — those are literal or invented misreadings.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('85b15adb-d3e0-571c-b7b7-08fb8257d0b6', 'e309b05b-3990-599d-bdfb-4988302f698c', 'anglais-c2', '⭐ Practice: Idiom Meanings', 1, 50, 10, 'practice', 'admin', 1)
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
  ('f03c20da-e89c-50bd-b2fe-a926e235a117', '85b15adb-d3e0-571c-b7b7-08fb8257d0b6', 'What does "bite the bullet" mean?', '[{"id":"a","text":"Endure a painful or difficult situation bravely."},{"id":"b","text":"Make a reckless decision."},{"id":"c","text":"Eat something unpleasant."},{"id":"d","text":"Start an argument."}]'::jsonb, 'a', '"Bite the bullet" means to accept and endure an unpleasant situation with courage rather than trying to avoid it. It comes from old surgical practice and has nothing to do with eating, decisions, or arguments.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ae28c28-430c-5d65-82e1-94d07a815eb2', '85b15adb-d3e0-571c-b7b7-08fb8257d0b6', 'What does "turn over a new leaf" mean?', '[{"id":"a","text":"Find a new job."},{"id":"b","text":"Move to the countryside."},{"id":"c","text":"Begin reading a book."},{"id":"d","text":"Start behaving in a better or more responsible way."}]'::jsonb, 'd', '"Turn over a new leaf" means to change your behaviour for the better — to make a fresh start. "Leaf" here refers to a page (a historical meaning), not a plant leaf. It has nothing to do with jobs, the countryside, or reading.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0362bb33-5b16-5afc-b608-8ff2af518a88', '85b15adb-d3e0-571c-b7b7-08fb8257d0b6', 'Complete: "We only see them ___ — maybe once a year at Christmas."', '[{"id":"a","text":"at the drop of a hat"},{"id":"b","text":"once in a blue moon"},{"id":"c","text":"on the fence"},{"id":"d","text":"under the weather"}]'::jsonb, 'b', '"Once in a blue moon" means very rarely — fitting perfectly with "maybe once a year". "At the drop of a hat" means immediately; "on the fence" means undecided; "under the weather" means feeling slightly ill. None of these express rarity.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94a296fe-932c-5c3d-86f5-85e3bea5fdbb', '85b15adb-d3e0-571c-b7b7-08fb8257d0b6', 'Identify which sentence uses an idiom CORRECTLY.', '[{"id":"a","text":"She let the cats out of the bags by mentioning the surprise."},{"id":"b","text":"He let the cat out of the bag when he mentioned the surprise."},{"id":"c","text":"They let the cat out of the bags before the party."},{"id":"d","text":"I let out the cat from the bag accidentally."}]'::jsonb, 'b', 'The fixed form of this idiom is "let the cat out of the bag" — always singular (the cat, the bag). (a) uses wrong plurals (cats, bags); (c) has the wrong plural (bags); (d) rearranges the fixed structure incorrectly. Only (b) uses the exact form.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9feeb36d-255c-5f61-b4a5-1aec82befe87', '85b15adb-d3e0-571c-b7b7-08fb8257d0b6', 'What does "break the ice" mean?', '[{"id":"a","text":"Destroy something valuable."},{"id":"b","text":"End a friendship."},{"id":"c","text":"Make people feel relaxed and comfortable at the start of a social situation."},{"id":"d","text":"Begin an argument aggressively."}]'::jsonb, 'c', '"Break the ice" means to do or say something that reduces awkwardness and helps people feel at ease when meeting for the first time or starting an event. The other options are invented negative meanings that do not match this idiom.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80502f3c-5f7e-5023-9ddb-77c6f0bf25f8', '85b15adb-d3e0-571c-b7b7-08fb8257d0b6', 'Choose the figurative meaning of: "They flooded us with complaints after the announcement."', '[{"id":"a","text":"Water entered their offices."},{"id":"b","text":"Customers came to their offices in person."},{"id":"c","text":"They received a very large number of complaints."},{"id":"d","text":"They were unprepared for the announcement."}]'::jsonb, 'c', '"Flooded" is used metaphorically here: just as a flood overwhelms a space with water, the company was overwhelmed with a very large number of complaints. This is lexical metaphor — the verb takes on a transferred, figurative sense. The other options are literal or unrelated readings.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d6645ab0-cae0-55d1-8710-5ace50e95c4e', 'e309b05b-3990-599d-bdfb-4988302f698c', 'anglais-c2', '⭐⭐ Review: Figurative Language in Context', 2, 75, 15, 'practice', 'admin', 2)
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
  ('cfef25e1-9516-5a67-a557-c59815693359', 'd6645ab0-cae0-55d1-8710-5ace50e95c4e', 'Read: "He quit without giving notice, burned all his bridges with the company, and now can''t get a reference."
What does "burned all his bridges" mean here?', '[{"id":"a","text":"He travelled a long distance."},{"id":"b","text":"He destroyed his relationships irreparably, leaving no way back."},{"id":"c","text":"He worked very hard before leaving."},{"id":"d","text":"He was fired for damaging property."}]'::jsonb, 'b', '"Burn your bridges" means to take an action that permanently destroys a relationship or opportunity, leaving no possibility of return. The context (no reference, quitting without notice) confirms the irreparable damage reading. The other options are literal or invented.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('88ef3c36-6b27-5c6d-b9c4-fbd7d8692755', 'd6645ab0-cae0-55d1-8710-5ace50e95c4e', 'Complete: "I''m a bit ___ today — I think I''m coming down with a cold."', '[{"id":"a","text":"on the fence"},{"id":"b","text":"at the drop of a hat"},{"id":"c","text":"under the weather"},{"id":"d","text":"over the moon"}]'::jsonb, 'c', '"Under the weather" means feeling slightly unwell — perfect for the context of coming down with a cold. "On the fence" = undecided; "at the drop of a hat" = immediately; "over the moon" = extremely happy. None of these fit illness.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d27e62b8-1532-5823-a5c9-2fc1408c324f', 'd6645ab0-cae0-55d1-8710-5ace50e95c4e', 'Which sentence uses a SIMILE (not a metaphor)?', '[{"id":"a","text":"The exam was like climbing a mountain."},{"id":"b","text":"She has a heart of stone."},{"id":"c","text":"The city never sleeps."},{"id":"d","text":"The news was a bombshell."}]'::jsonb, 'a', 'A simile makes an explicit comparison using like or as: "like climbing a mountain". (b) a heart of stone, (c) never sleeps, and (d) a bombshell are all metaphors — they describe one thing as another without using like or as.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc73bcbc-cb4b-5aea-b5a3-af5d84258aa2', 'd6645ab0-cae0-55d1-8710-5ace50e95c4e', 'What does "a blessing in disguise" mean?', '[{"id":"a","text":"Something that appears to be lucky but is actually harmful."},{"id":"b","text":"A religious ceremony in an unusual location."},{"id":"c","text":"Something that seems bad at first but turns out to have a positive effect."},{"id":"d","text":"Help that comes at the wrong moment."}]'::jsonb, 'c', '"A blessing in disguise" refers to something that initially seems unfortunate or bad but ultimately turns out to be beneficial. (a) reverses the meaning; (b) is a literal/religious misreading; (d) describes unhelpful help, which is different.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('10938362-4f8f-5857-94fe-ac8230d71682', 'd6645ab0-cae0-55d1-8710-5ace50e95c4e', 'Find the sentence where the figurative language is used INCORRECTLY.', '[{"id":"a","text":"Those redundancies are just the tip of the iceberg — layoffs are coming."},{"id":"b","text":"She went the extra mile to make the event a success."},{"id":"c","text":"He''s been hitting a brick wall trying to get planning permission."},{"id":"d","text":"They sell like hot cakes, so be careful not to eat too many."}]'::jsonb, 'd', 'The error is (d): "sell like hot cakes" is an idiom meaning to sell very quickly in large quantities — it has nothing to do with eating. Adding "be careful not to eat too many" treats the idiom literally, which is precisely the error the lesson warns against. (a), (b), and (c) all use their figurative expressions correctly.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17c27c03-0384-5c61-b4fb-c9dd5dd5edad', 'd6645ab0-cae0-55d1-8710-5ace50e95c4e', 'Complete: "___ — he made the decision before anyone had even finished explaining the problem."', '[{"id":"a","text":"He hit a brick wall"},{"id":"b","text":"He bit off more than he could chew"},{"id":"c","text":"He was at the drop of a hat"},{"id":"d","text":"He acted at the drop of a hat"}]'::jsonb, 'd', '"At the drop of a hat" means immediately, without hesitation — which perfectly matches deciding before anyone finished explaining. The idiom needs a verb: "acted at the drop of a hat" or similar. (a) hit a brick wall = encounter an obstacle; (b) bit off more than he could chew = took on too much; (c) was at the drop of a hat is grammatically incomplete (the idiom needs an action verb before it).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('460d73ed-5900-5cb9-bbb3-cb6db0572f28', 'e309b05b-3990-599d-bdfb-4988302f698c', 'anglais-c2', '⚔️ Chapter Boss ⭐⭐⭐: Idioms and Figurative Language', 3, 120, 30, 'boss', 'admin', 3)
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
  ('9ff3218c-fbf2-59b3-9659-c90b4558ed08', '460d73ed-5900-5cb9-bbb3-cb6db0572f28', 'Read: "After months of delays, the project team hit a brick wall when the supplier went bankrupt."
What does "hit a brick wall" mean in this context?', '[{"id":"a","text":"The team made rapid progress."},{"id":"b","text":"The team reached an obstacle that stopped their progress."},{"id":"c","text":"The team decided to change their supplier."},{"id":"d","text":"The team demolished the project''s physical barriers."}]'::jsonb, 'b', '"Hit a brick wall" means to encounter an obstacle so significant that progress becomes impossible. The supplier going bankrupt is exactly that kind of obstacle. (a) is the opposite meaning; (c) is a possible next action but not what the idiom means; (d) is a literal misreading.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6e62b2c1-f98a-5314-9476-3d683b0a2c2e', '460d73ed-5900-5cb9-bbb3-cb6db0572f28', 'Identify the METAPHOR in the following group of sentences.', '[{"id":"a","text":"The stock market crashed like a falling house of cards."},{"id":"b","text":"She was as bold as brass when she walked into the interview."},{"id":"c","text":"The office was as quiet as a library during the exam."},{"id":"d","text":"The negotiations were a battlefield from start to finish."}]'::jsonb, 'd', '"The negotiations were a battlefield" is a metaphor — it says one thing (negotiations) IS another (battlefield) without using like or as. (a) and (c) use as…as or like, making them similes. (b) as bold as brass is also a simile. Only (d) makes the implicit identification that defines a metaphor.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('370807f2-ab1d-5676-89a4-a64f22cab6f1', '460d73ed-5900-5cb9-bbb3-cb6db0572f28', 'Complete: "I''m still ___ about whether to accept the promotion — it means relocating my whole family."', '[{"id":"a","text":"blowing a fuse"},{"id":"b","text":"spilling the beans"},{"id":"c","text":"on the fence"},{"id":"d","text":"turning over a new leaf"}]'::jsonb, 'c', '"On the fence" means undecided — exactly the feeling described. "Blowing a fuse" = losing one''s temper; "spilling the beans" = revealing a secret; "turning over a new leaf" = starting to behave better. None of these fit the meaning of being undecided about a job offer.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5876c79b-ed26-594c-ba0f-91341c7950dd', '460d73ed-5900-5cb9-bbb3-cb6db0572f28', 'Read: "The job losses we''ve announced are only the tip of the iceberg. We''ve bitten the bullet on these cuts, but there is more to come."
Which interpretation is CORRECT?', '[{"id":"a","text":"The company made small cuts and is now eating better."},{"id":"b","text":"The visible job losses are small compared to what is coming, and the decision was painful but necessary."},{"id":"c","text":"The managers found the cuts enjoyable and easy to make."},{"id":"d","text":"The company decided not to make any more cuts after this announcement."}]'::jsonb, 'b', '"Tip of the iceberg" = the visible cuts are a small sign of something much larger to come. "Bitten the bullet" = endured the difficult decision bravely. Together they indicate the cuts were painful but necessary and more will follow. (a) and (c) are literal or inverted misreadings; (d) contradicts "there is more to come".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('831b69e7-e817-513e-ae32-daddb5eb6706', '460d73ed-5900-5cb9-bbb3-cb6db0572f28', 'Which sentence uses an idiom INCORRECTLY (wrong form or wrong meaning in context)?', '[{"id":"a","text":"He''s the spitting image of his father — they look identical."},{"id":"b","text":"She blew a fuse when she found out about the mistake."},{"id":"c","text":"We need to go the extra mile to satisfy this client."},{"id":"d","text":"They burned the bridge to save costs on the project."}]'::jsonb, 'd', 'The error is (d): "burn bridges" (or "burn your bridges") means to irreparably destroy a relationship or opportunity — it cannot be used to describe saving costs on a project. The context is wrong and the form "burned the bridge" (singular) is also non-standard. (a), (b), and (c) all use their idioms correctly in context and in the right form.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd7aecbf-9807-5656-a262-c0f2c30f0626', '460d73ed-5900-5cb9-bbb3-cb6db0572f28', 'Read: "After years of bad habits, he turned over a new leaf. He arrived at work on time at the drop of a hat when his boss asked."
Find the INCORRECTLY used idiom.', '[{"id":"a","text":"\"turned over a new leaf\" is used incorrectly."},{"id":"b","text":"Both idioms are used incorrectly."},{"id":"c","text":"\"at the drop of a hat\" is used incorrectly."},{"id":"d","text":"Both idioms are used correctly."}]'::jsonb, 'c', '"At the drop of a hat" means to do something immediately and without hesitation — it refers to spontaneous, unprompted action. But here, arriving on time because the boss asked is a prompted, expected response, not a spontaneous one; more importantly, the idiom awkwardly implies he only arrives on time when asked, contradicting the idea of genuine reform. "Turned over a new leaf" (b) is used correctly for changing habits. So (c) — the second idiom — is misapplied in context.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cc184b50-7750-5390-af80-914fa3c892d1', 'e309b05b-3990-599d-bdfb-4988302f698c', 'anglais-c2', '👑 Elite Challenge ⭐⭐⭐⭐: Idioms and Figurative Language', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('6af83164-4e53-5a75-af9b-1d6bee671884', 'cc184b50-7750-5390-af80-914fa3c892d1', 'Read: "The audit revealed that the accounting irregularities were merely the tip of the iceberg. Senior staff had been turning a blind eye to the problem for years."
"Turning a blind eye" (not in the cours) most likely means:', '[{"id":"a","text":"Deliberately ignoring something they knew about."},{"id":"b","text":"Working in poor lighting conditions."},{"id":"c","text":"Making a careful examination of the problem."},{"id":"d","text":"Reporting the irregularities to management."}]'::jsonb, 'a', 'Using context: the irregularities were the tip of the iceberg (small sign of something bigger), and senior staff had been doing something with them "for years" — a negative, passive response. "Turning a blind eye" (a deliberate choice to not look/notice) perfectly fits: ignoring a known problem. (b) is literal; (c) is the opposite; (d) contradicts the idea of hiding the issue.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89eb4adc-f710-5588-b49f-540bdd1d516e', 'cc184b50-7750-5390-af80-914fa3c892d1', 'Choose the response that correctly explains the figurative device in the sentence: "Time is a thief that steals our youth."', '[{"id":"a","text":"It is a simile comparing time to a thief using ''like''."},{"id":"b","text":"It is a metaphor: time is implicitly identified as a thief, attributing theft (stealing youth) to a non-human concept."},{"id":"c","text":"It is an idiom because ''thief'' is a fixed expression in English."},{"id":"d","text":"It is a literal description of how time can be stolen."}]'::jsonb, 'b', '"Time is a thief" is a classic metaphor: it equates time (abstract) with a thief (concrete) without using like or as, and extends the comparison by attributing the theft of youth. It is not a simile (no like/as), not a fixed idiom, and certainly not literal.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6439b7e0-2866-5f56-b21e-6174abf080cd', 'cc184b50-7750-5390-af80-914fa3c892d1', 'Read this paragraph: "The new CEO hit the ground running, immediately going the extra mile to win over sceptical investors. Within months, she had turned the company''s fortunes around."
Which idiom is NOT used in this paragraph?', '[{"id":"a","text":"hit the ground running"},{"id":"b","text":"going the extra mile"},{"id":"c","text":"turned the company''s fortunes around"},{"id":"d","text":"hit a brick wall"}]'::jsonb, 'd', '"Hit a brick wall" (reach an obstacle that stops progress) does not appear in the paragraph. The paragraph contains: hit the ground running (start with immediate energy), going the extra mile (making extra effort), and turned [something] around (reversed a bad situation). "Hit a brick wall" would contradict the overall positive story.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3de5aed-6a62-5492-a23b-b65139c719c4', 'cc184b50-7750-5390-af80-914fa3c892d1', 'Find the sentence where a figurative expression is MISUSED because the form is broken.', '[{"id":"a","text":"She sees eye to eye with her colleague on most issues."},{"id":"b","text":"He let the cat out of the bag before the surprise was ready."},{"id":"c","text":"They spilled all of the beans about the new product launch."},{"id":"d","text":"It costs an arm and a leg to park in the city centre."}]'::jsonb, 'c', 'The error in (c) is "all of the beans" — the fixed form of this idiom is simply "spill the beans" without any modification. Adding "all of" breaks the fixed phrase and is non-native. (a) see eye to eye, (b) let the cat out of the bag, and (d) cost an arm and a leg are all in their correct, unmodified forms.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76162ccc-0fdf-5c36-8497-0ee42acbb3a4', 'cc184b50-7750-5390-af80-914fa3c892d1', 'Which sentence correctly uses TWO different figurative devices (one idiom and one metaphor or simile)?', '[{"id":"a","text":"The proposal hit a brick wall, and the silence in the room was deafening."},{"id":"b","text":"He bit the bullet and he also bit the bullet again."},{"id":"c","text":"They see eye to eye and they see eye to eye."},{"id":"d","text":"She went the extra mile, going the extra mile every single day."}]'::jsonb, 'a', '"Hit a brick wall" is an idiom (reach an obstacle); "the silence was deafening" is a paradoxical metaphor attributing a loud quality to silence. These are two distinct figurative devices used correctly in one sentence. (b), (c), and (d) repeat the same idiom rather than combining two different devices.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b99ee85-e583-5e34-a8d8-8f6cf06e568f', 'cc184b50-7750-5390-af80-914fa3c892d1', 'Read: "The ambassador''s speech was a tightrope walk — one wrong word and the entire alliance could collapse."
Which analysis is MOST accurate?', '[{"id":"a","text":"\"Tightrope walk\" is a simile comparing the speech to a physical act."},{"id":"b","text":"\"Tightrope walk\" is a metaphor: the speech is described as a tightrope walk to convey extreme delicacy and the risk of catastrophic failure."},{"id":"c","text":"\"Tightrope walk\" is a fixed idiom with the meaning ''speak slowly and clearly''."},{"id":"d","text":"\"Collapse\" is used literally to describe the alliance''s headquarters."}]'::jsonb, 'b', '"A tightrope walk" is used here as a metaphor — the speech (abstract) is identified with the precarious physical act of walking a tightrope to convey the extreme risk and delicacy of the situation. There is no like or as, so it is not a simile (a). It is not a fixed idiom with a single set meaning (c). "Collapse" refers to the breakdown of the alliance, not a literal building (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5fe557ea-d222-5eda-97bf-58680f45d844', 'e309b05b-3990-599d-bdfb-4988302f698c', 'anglais-c2', '⭐⭐ Drill: Idioms and Figurative Language', 2, 75, 15, 'practice', 'admin', 5)
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
  ('a68a5b50-d4a8-536f-9ddf-8917f4badb10', '5fe557ea-d222-5eda-97bf-58680f45d844', 'What does "go the extra mile" mean?', '[{"id":"a","text":"To make more effort than is required or expected."},{"id":"b","text":"To travel a longer route than necessary."},{"id":"c","text":"To finish a task before the deadline."},{"id":"d","text":"To win a competition by a large margin."}]'::jsonb, 'a', '"Go the extra mile" means to put in more effort than is required — to exceed what is expected. It has nothing to do with literal travel, beating deadlines, or winning by margins. Those options exploit the word mile to create plausible but wrong literal readings.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7370c67-d990-5555-b7d5-85c74883ceb2', '5fe557ea-d222-5eda-97bf-58680f45d844', 'Identify the SIMILE in the following group.', '[{"id":"a","text":"The news was a bombshell."},{"id":"b","text":"Her voice was honey."},{"id":"c","text":"The deadline crept up on them like a thief."},{"id":"d","text":"The office never sleeps."}]'::jsonb, 'c', 'A simile makes an explicit comparison using like or as: "like a thief" is the marker. The other three are metaphors — they describe one thing as another without using like or as (bombshell, honey, never sleeps). Only the third option has the explicit comparative signal that defines a simile.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d0ffd553-a09f-5408-853b-a6e4e6d62340', '5fe557ea-d222-5eda-97bf-58680f45d844', 'Complete: "After the scandal, the CEO tried to ___ by meeting community leaders and donating to local charities."', '[{"id":"a","text":"hit a brick wall"},{"id":"b","text":"turn over a new leaf"},{"id":"c","text":"spill the beans"},{"id":"d","text":"burn his bridges"}]'::jsonb, 'b', '"Turn over a new leaf" means to begin behaving better — fitting the context of repairing a damaged reputation through positive actions. Hitting a brick wall means encountering an obstacle. Spilling the beans means revealing a secret. Burning bridges means irreparably damaging relationships — the opposite of what the CEO is trying to do.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4ecad86-4579-5c84-afbd-be409e212cbd', '5fe557ea-d222-5eda-97bf-58680f45d844', 'Find the sentence where figurative language is used CORRECTLY.', '[{"id":"a","text":"She was over the moon when she heard the bad news."},{"id":"b","text":"Sales are selling like hot cakes — they keep stacking up in the warehouse."},{"id":"c","text":"He hits the ground running every Monday, arriving at 7 a.m. with a full action plan."},{"id":"d","text":"They spilled the bean when they revealed the secret."}]'::jsonb, 'c', '"Hit the ground running" means to begin something with immediate energy and effectiveness — which fits arriving early with a prepared plan. The first option contradicts itself (over the moon = very happy, not appropriate for bad news). The second adds a literal warehouse detail that treats the idiom concretely. The fourth uses the wrong singular form — the fixed idiom is spill the beans, not the bean.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49535f59-f254-5d94-9110-8c1baf040d9a', '5fe557ea-d222-5eda-97bf-58680f45d844', 'Read: "His argument was a house of cards — elegant, intricate, and utterly dependent on assumptions that simply weren''t true."
What does the METAPHOR "house of cards" suggest about the argument?', '[{"id":"a","text":"It was built on a solid, well-researched foundation."},{"id":"b","text":"It relied on playing cards as evidence."},{"id":"c","text":"It was delivered in an entertaining, game-like manner."},{"id":"d","text":"It was visually impressive but dangerously fragile."}]'::jsonb, 'd', 'A house of cards is a structure that looks impressive but collapses if any element is disturbed — a perfect metaphor for an argument that appears convincing but rests on false assumptions. The sentence reinforces this with "elegant, intricate" (impressive-looking) followed by "utterly dependent on assumptions that weren''t true" (the fragile base). The literal card-playing and entertainment readings are surface distractors.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8cc4aa9e-8b78-5473-9b06-bf0a99dd1f15', '5fe557ea-d222-5eda-97bf-58680f45d844', 'Read: "The merger was the tip of the iceberg. Behind the scenes, the entire sector was burning its bridges with regulators, flooding the market with untested products, and running out of goodwill faster than anyone had anticipated."
Which of the following BEST describes the use of figurative language in this passage?', '[{"id":"a","text":"Three metaphors and one simile are mixed inconsistently."},{"id":"b","text":"All the figurative expressions are used incorrectly, creating confusion."},{"id":"c","text":"Multiple idiomatic and figurative expressions are stacked coherently to convey rapid, compounding decline."},{"id":"d","text":"The passage uses only one figurative device: the tip of the iceberg."}]'::jsonb, 'c', 'The passage layers four figurative expressions — tip of the iceberg (small visible sign of something larger), burning bridges (irreparably damaging relationships), flooding the market (overwhelming with product), running out of goodwill (exhausting trust) — each adding to a picture of accelerating collapse. They are all used correctly in context and build coherently toward the theme of decline. There is no simile and no inconsistency.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('202e92d0-7981-5931-96c7-79b941875cb5', '6e02f8d0-b12f-5308-9946-a98f4ab38838', 'anglais-c2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('4afd0cc0-1dbd-5eed-a5f3-6c96db188e87', '202e92d0-7981-5931-96c7-79b941875cb5', 'Which word is the MOST formal equivalent of the phrasal verb "find out"?', '[{"id":"a","text":"discover"},{"id":"b","text":"get"},{"id":"c","text":"ascertain"},{"id":"d","text":"look up"}]'::jsonb, 'c', '"Ascertain" is the most formal equivalent — a Latinate word used in legal and official writing. "Discover" is neutral but not the most formal choice. "Get" is informal; "look up" is another phrasal verb, equally informal.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94e51584-e60b-5e5c-a076-993cb64d9a40', '202e92d0-7981-5931-96c7-79b941875cb5', 'What is nominalisation?', '[{"id":"a","text":"Replacing nouns with pronouns to avoid repetition."},{"id":"b","text":"Converting verbs or adjectives into nouns to create a more formal, impersonal style."},{"id":"c","text":"Adding -ing to a verb to make it continuous."},{"id":"d","text":"Giving objects proper names in academic writing."}]'::jsonb, 'b', 'Nominalisation is the conversion of verbs or adjectives into nouns (decide → decision; significant → significance) to achieve a more formal, impersonal, and abstract style typical of academic and bureaucratic writing. The other options describe unrelated grammar processes.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a27457a2-ffb3-5394-88ac-60547ed48eac', '202e92d0-7981-5931-96c7-79b941875cb5', 'Which sentence is written in the MOST formal register?', '[{"id":"a","text":"We looked into the problem and found out what went wrong."},{"id":"b","text":"The investigation led to the identification of the root cause."},{"id":"c","text":"They kind of checked the issue and sort of figured it out."},{"id":"d","text":"We looked at the problem and saw what happened."}]'::jsonb, 'b', 'Option (b) uses nominalisation (investigation, identification), Latinate vocabulary, and impersonal passive constructions — the hallmarks of formal register. (a) uses phrasal verbs (looked into, found out); (c) is informal with hedges (kind of, sort of); (d) is neutral but verb-heavy and personal.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ec57d83-cc7f-507d-9eaa-c3995257ee3a', '202e92d0-7981-5931-96c7-79b941875cb5', 'Which of these is a feature of INFORMAL register?', '[{"id":"a","text":"Passive voice constructions"},{"id":"b","text":"Complex noun phrases"},{"id":"c","text":"Hedging language (it has been suggested that…)"},{"id":"d","text":"Contractions and phrasal verbs"}]'::jsonb, 'd', 'Contractions (it''s, don''t) and phrasal verbs (look into, give up) are markers of informal/colloquial register. Passive voice, hedging, and complex noun phrases are all features of formal/academic writing, not informal speech.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f3cc008-7e38-58b0-914b-6e4522b0d899', '202e92d0-7981-5931-96c7-79b941875cb5', 'Rewrite to increase formality: "We need to look into why sales have gone down."
Choose the BEST formal version.', '[{"id":"a","text":"An investigation into the decline in sales is required."},{"id":"b","text":"We should check why sales got worse."},{"id":"c","text":"We kind of need to find out about the sales going down."},{"id":"d","text":"It''s important to look at the drop in sales."}]'::jsonb, 'a', 'Option (a) uses nominalisation (investigation, decline) and an impersonal passive construction (is required) — fully formal. (b) replaces one phrasal verb with another informal one (got worse); (c) is informal with hedges; (d) still uses a phrasal verb (look at) and contraction (it''s), which lower the register.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('50e4da08-9786-5f37-b92c-4756f87f6167', '6e02f8d0-b12f-5308-9946-a98f4ab38838', 'anglais-c2', '⭐ Practice: Formal vs Informal Vocabulary', 1, 50, 10, 'practice', 'admin', 1)
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
  ('dc9f1e2e-8c1d-5b23-8b24-11b8d184eae9', '50e4da08-9786-5f37-b92c-4756f87f6167', 'Choose the MOST formal equivalent of "put off" (to delay).', '[{"id":"a","text":"push back"},{"id":"b","text":"postpone"},{"id":"c","text":"hold off"},{"id":"d","text":"wait on"}]'::jsonb, 'b', '"Postpone" is the single Latinate verb used in formal writing. "Push back" and "hold off" are phrasal verbs — informal. "Wait on" is also informal and has a different primary meaning (to serve someone). In a formal letter or report, always prefer postpone.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80fdf985-ee6c-5785-b175-7fb5b7caa263', '50e4da08-9786-5f37-b92c-4756f87f6167', 'Which word is the MOST colloquial (informal) substitute for "require"?', '[{"id":"a","text":"necessitate"},{"id":"b","text":"demand"},{"id":"c","text":"need"},{"id":"d","text":"mandate"}]'::jsonb, 'c', '"Need" is the most colloquial and everyday option. "Necessitate" and "mandate" are more formal than "require". "Demand" is formal too and implies a stronger requirement. Only "need" clearly belongs to informal/everyday register.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('069a31ce-e520-560c-8407-1c9a67c8bdad', '50e4da08-9786-5f37-b92c-4756f87f6167', 'Choose the FORMAL replacement for the phrasal verb in: "The committee set up a new working group."', '[{"id":"a","text":"The committee started up a new working group."},{"id":"b","text":"The committee put together a new working group."},{"id":"c","text":"The committee established a new working group."},{"id":"d","text":"The committee got going a new working group."}]'::jsonb, 'c', '"Establish" is the formal Latinate equivalent of "set up". (a) "started up" is still a phrasal verb; (b) "put together" is an informal phrasal verb; (d) "got going" is colloquial and grammatically weak. Only (c) raises the register correctly.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e0b8875d-deda-506e-abd6-c136f5938792', '50e4da08-9786-5f37-b92c-4756f87f6167', 'Which sentence is MOST appropriate for a formal business email?', '[{"id":"a","text":"I''m writing to find out about your prices."},{"id":"b","text":"I am writing to enquire about your pricing structure."},{"id":"c","text":"Just checking what you charge for this stuff."},{"id":"d","text":"Could you tell me what things cost?"}]'::jsonb, 'b', 'Option (b) avoids contractions ("I am"), uses a formal verb ("enquire"), and includes a precise noun phrase ("pricing structure"). (a) uses a contraction (I''m) and a phrasal verb (find out); (c) is very colloquial (stuff, just checking); (d) uses vague language (things, cost).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9298ed8c-dc6c-5b5a-9b31-d3b742433747', '50e4da08-9786-5f37-b92c-4756f87f6167', 'Which word correctly replaces "a lot of" in formal writing?', '[{"id":"a","text":"loads of"},{"id":"b","text":"tons of"},{"id":"c","text":"heaps of"},{"id":"d","text":"a considerable number of"}]'::jsonb, 'd', '"A considerable number of" (or "a significant number of") is the formal replacement. "Loads of", "tons of", and "heaps of" are all highly colloquial and inappropriate in academic or formal writing.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2858220-6a2a-5ade-b7c2-2f5ad26b897b', '50e4da08-9786-5f37-b92c-4756f87f6167', 'Find the INCORRECT formal-to-informal pairing.', '[{"id":"a","text":"investigate → look into"},{"id":"b","text":"conclude → wind up"},{"id":"c","text":"postpone → put off"},{"id":"d","text":"require → give up"}]'::jsonb, 'd', '"Require" → "give up" is wrong: "give up" means to abandon or stop, not to need or require. The correct informal equivalent of require is "need". The other pairings are all accurate: investigate/look into, conclude/wind up, and postpone/put off are correct formal-informal pairs.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f080ad19-5a66-5c15-a4e5-84d80afc70e8', '6e02f8d0-b12f-5308-9946-a98f4ab38838', 'anglais-c2', '⭐⭐ Review: Nominalisation and Tone', 2, 75, 15, 'practice', 'admin', 2)
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
  ('d26d7b52-b5ff-581b-b308-2a33e26c2761', 'f080ad19-5a66-5c15-a4e5-84d80afc70e8', 'Which sentence uses nominalisation CORRECTLY to increase formality?', '[{"id":"a","text":"They failed to implement the plan quickly."},{"id":"b","text":"The failure to implement the plan resulted in significant delays."},{"id":"c","text":"They didn''t do the plan and it took forever."},{"id":"d","text":"The plan was not implemented in a quick way."}]'::jsonb, 'b', 'Option (b) nominalises "failed" → "the failure" and uses impersonal construction (no named subject They). "Resulted in" is also a formal verb. (a) is verb-heavy and personal; (c) is informal; (d) avoids contractions but "in a quick way" is informal where "promptly" or "in a timely manner" would be formal.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('264e22d8-cd0c-51e7-9857-f1e264b547fe', 'f080ad19-5a66-5c15-a4e5-84d80afc70e8', 'Nominalise the verb in brackets to complete the sentence formally: "The [decide] to restructure the department surprised many employees."', '[{"id":"a","text":"deciding"},{"id":"b","text":"decided"},{"id":"c","text":"decision"},{"id":"d","text":"decide"}]'::jsonb, 'c', 'The nominalisation of "decide" is "decision" — a noun that can head the subject noun phrase: "The decision to restructure…". "Deciding" is a gerund (acceptable but less formal than the full nominalisation). "Decided" is the past tense and "decide" is the base form — neither can be a noun here.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a60d6157-f9ed-58b0-b04b-cbac96489734', 'f080ad19-5a66-5c15-a4e5-84d80afc70e8', 'Which of the following is a formal academic sentence that uses hedging language?', '[{"id":"a","text":"Evidence suggests that the intervention may have contributed to improved outcomes."},{"id":"b","text":"The data is definitely proof that the theory is right."},{"id":"c","text":"I think the results show the theory is probably right."},{"id":"d","text":"It''s pretty clear the data backs up the theory."}]'::jsonb, 'a', 'Option (a) uses hedging language (suggests, may have contributed) and impersonal construction (Evidence suggests…), with formal vocabulary (intervention, outcomes). (b) is overconfident and lacks hedging; (c) uses first person (I think); (d) uses informal vocabulary (pretty clear, backs up).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bd2eb0b-d929-5553-9e3a-00e0a2bf8b54', 'f080ad19-5a66-5c15-a4e5-84d80afc70e8', 'Which feature makes this sentence LESS formal: "We think it''s important to carry out more research."', '[{"id":"a","text":"The use of a complete sentence."},{"id":"b","text":"The word \"research\"."},{"id":"c","text":"The use of the verb \"think\"."},{"id":"d","text":"The use of first person (\"We\"), the contraction (\"it''s\"), and the phrasal verb (\"carry out\")."}]'::jsonb, 'd', 'Three informal features combine: first-person We, the contraction it''s (formal = it is), and the phrasal verb carry out (formal = conduct). "Research" is perfectly formal; having a complete sentence is not informal. Option (d) correctly identifies all three informal markers together.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1bd1c5b-00a3-53ec-a3fc-e893d9c17272', 'f080ad19-5a66-5c15-a4e5-84d80afc70e8', 'Find the MOST formal version of: "The manager got angry when he found out about the delay."', '[{"id":"a","text":"The manager got angry after finding out the delay."},{"id":"b","text":"The manager blew a fuse on discovering the delay."},{"id":"c","text":"The manager expressed considerable displeasure upon learning of the delay."},{"id":"d","text":"The manager was pretty mad when he found out about the delay."}]'::jsonb, 'c', 'Option (c) nominalises the emotion (displeasure), uses formal vocabulary (considerable, upon learning of), and eliminates contractions and informal phrasal verbs. (a) still uses "got angry" and "finding out"; (b) uses the idiom "blew a fuse" which is informal; (d) adds the informal hedge "pretty mad".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f4f46b7-2398-59f4-bef8-a76a323ced7f', 'f080ad19-5a66-5c15-a4e5-84d80afc70e8', 'Read: "The implementation of sustainable energy policies has been identified as a priority at the national level."
Which word in this sentence is an example of nominalisation?', '[{"id":"a","text":"sustainable"},{"id":"b","text":"national"},{"id":"c","text":"identified"},{"id":"d","text":"implementation"}]'::jsonb, 'd', '"Implementation" is the nominalisation of the verb "implement" — a noun formed from a verb by adding the suffix -ation. "Sustainable" is an adjective (derived from a verb but functioning adjectivally here); "identified" is a past participle verb; "national" is an adjective derived from a noun.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e7c4a70b-a1d8-59c4-9849-6ea25d6176a5', '6e02f8d0-b12f-5308-9946-a98f4ab38838', 'anglais-c2', '⚔️ Chapter Boss ⭐⭐⭐: Register, Formality and Nominalisation', 3, 120, 30, 'boss', 'admin', 3)
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
  ('16c3df9f-baa5-5b3b-a8cf-ac4cc8f2d5fd', 'e7c4a70b-a1d8-59c4-9849-6ea25d6176a5', 'Find the sentence that CLASHES in register — mixing formal and informal elements inappropriately.', '[{"id":"a","text":"The board has resolved to defer the vote pending further consultation."},{"id":"b","text":"We are pleased to inform you that your application has been successful."},{"id":"c","text":"The investigation found loads of problems with the procurement process."},{"id":"d","text":"Further analysis of the data is required before a conclusion can be reached."}]'::jsonb, 'c', '"Loads of problems" is colloquial and clashes with the formal context of an "investigation" and a "procurement process". A formal sentence would say "a significant number of issues" or "numerous irregularities". (a), (b), and (d) maintain consistent formal register throughout.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a48cb938-9423-5896-bbbd-1b78fe1cd771', 'e7c4a70b-a1d8-59c4-9849-6ea25d6176a5', 'Which is the BEST formal transformation of: "They came up with a plan to deal with the crisis."?', '[{"id":"a","text":"They devised a strategy to address the crisis."},{"id":"b","text":"They came up with a strategy to address the crisis."},{"id":"c","text":"They devised a plan to deal with the crisis."},{"id":"d","text":"A plan was come up with to deal with the crisis."}]'::jsonb, 'a', 'Option (a) replaces both informal elements: "came up with" → "devised" (Latinate) and "deal with" → "address" (formal). (b) still uses "came up with"; (c) still uses "deal with"; (d) is grammatically broken — phrasal verbs generally cannot be passivised in this way.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb7434c3-0278-50e5-8969-d2fd82d828f7', 'e7c4a70b-a1d8-59c4-9849-6ea25d6176a5', 'Which sentence demonstrates the MOST effective use of nominalisation for academic writing?', '[{"id":"a","text":"Researchers discovered that the drug significantly reduced inflammation."},{"id":"b","text":"The discovery that the drug significantly reduces inflammation has important implications."},{"id":"c","text":"The researchers'' discovery of a significant reduction in inflammation has implications."},{"id":"d","text":"It has been discovered that inflammation is significantly reduced by the drug."}]'::jsonb, 'c', 'Option (c) shows the most complete nominalisation: "discovered" → "discovery" and "reduced" → "reduction", creating a dense noun phrase typical of high-level academic prose. (b) nominalises "discovered" but leaves "reduces" as a verb; (a) uses no nominalisation; (d) uses passive voice but no nominalisation.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4fdb4d20-e550-52df-98d2-29b4e709b67c', 'e7c4a70b-a1d8-59c4-9849-6ea25d6176a5', 'Read this formal letter extract: "We regret to inform you that your request has been declined. Should you wish to appeal this decision, you are invited to do so in writing within 30 days."
Which feature is NOT present in this extract?', '[{"id":"a","text":"A phrasal verb"},{"id":"b","text":"Passive voice"},{"id":"c","text":"Inverted conditional (Should you wish)"},{"id":"d","text":"A nominalisation (decision)"}]'::jsonb, 'a', 'There is no phrasal verb in this extract. It contains: a passive (has been declined, are invited), an inverted conditional (Should you wish), and a nominalisation (decision). The extract is consistently formal throughout and avoids phrasal verbs entirely.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df1ca3d7-2078-535d-945a-eb5682dcef38', 'e7c4a70b-a1d8-59c4-9849-6ea25d6176a5', 'Select the word that BEST fills the gap to maintain formal academic register: "The study ___ that further investment in renewable energy is warranted."', '[{"id":"a","text":"proves"},{"id":"b","text":"makes clear"},{"id":"c","text":"shows"},{"id":"d","text":"indicates"}]'::jsonb, 'd', '"Indicates" is the most precisely academic and formally appropriate verb here — it hedges slightly (suggesting evidence points in a direction) rather than making an overconfident claim. "Proves" is too strong (science rarely proves definitively). "Shows" is neutral but less formal. "Makes clear" is a phrasal-verb-like construction that lowers the register.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3953ae02-18ee-5e31-a942-61d5fe8b1b83', 'e7c4a70b-a1d8-59c4-9849-6ea25d6176a5', 'Find the INCORRECTLY nominalised sentence.', '[{"id":"a","text":"The development of the project took two years."},{"id":"b","text":"The analyse of the results showed clear trends."},{"id":"c","text":"Further investigation is required."},{"id":"d","text":"The implementation of the policy was delayed."}]'::jsonb, 'b', '"The analyse" is incorrect — the nominalisation of "analyse" (verb) is "analysis" (noun), not "analyse". So the sentence should read: "The analysis of the results showed clear trends." (a), (c), and (d) all use correct nominalisations: development, investigation, implementation.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('56ac58aa-2ca3-5e52-ad90-59ee85bb06de', '6e02f8d0-b12f-5308-9946-a98f4ab38838', 'anglais-c2', '👑 Elite Challenge ⭐⭐⭐⭐: Register, Formality and Nominalisation', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('6aec6fac-7c21-5d8a-b50d-e7fd17189c41', '56ac58aa-2ca3-5e52-ad90-59ee85bb06de', 'Read this paragraph: "The government needs to look into why the economy got worse. They should come up with a plan to deal with rising prices and find out what caused the problem."
Which is the BEST fully formal rewrite?', '[{"id":"a","text":"An investigation into the causes of economic deterioration is required. The government must devise a strategy to address inflation and ascertain its root causes."},{"id":"b","text":"The government requires to look into the economic deterioration, devise a plan to deal with inflation, and ascertain the cause."},{"id":"c","text":"The government should investigate the economy getting worse and come up with solutions for rising prices."},{"id":"d","text":"It is necessary for the government to look into economic problems and find out about prices."}]'::jsonb, 'a', 'Option (a) achieves the most complete transformation: nominalisation (investigation, deterioration, causes), formal impersonal passive (is required), Latinate verbs (devise, address, ascertain), and formal noun phrase (root causes). (b) incorrectly writes "requires to" (should be "is required") and mixes levels; (c) still uses "come up with" and "getting worse"; (d) still uses phrasal verb "look into" and "find out about".', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ac5d9a0-0ea8-52f6-958a-c71fffdc2b5c', '56ac58aa-2ca3-5e52-ad90-59ee85bb06de', 'Find the sentence where register is INCONSISTENT within the same sentence.', '[{"id":"a","text":"The Board of Directors has resolved to commence proceedings forthwith."},{"id":"b","text":"Further analysis of the data is required prior to the formulation of recommendations."},{"id":"c","text":"The implementation of the new framework has been kind of slow."},{"id":"d","text":"I would be grateful if you could provide clarification at your earliest convenience."}]'::jsonb, 'c', '"The implementation of the new framework" is highly formal (nominalisation, Latinate), but "has been kind of slow" is very colloquial (kind of, slow rather than "gradual" or "delayed"). This register clash within one sentence is the error. (a), (b), and (d) are consistently formal throughout.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee7547b0-c1d6-5dd7-acf2-b6b4a1e245e1', '56ac58aa-2ca3-5e52-ad90-59ee85bb06de', 'Which transformation of "We decided to give up the project" is the MOST complete and formally accurate?', '[{"id":"a","text":"We made a decision to give up the project."},{"id":"b","text":"The decision for project abandonment was made by us."},{"id":"c","text":"It was decided by the team to give up the project."},{"id":"d","text":"A decision was made to abandon the project."}]'::jsonb, 'd', 'Option (d) achieves the optimal transformation: nominalisation (decision), impersonal passive (was made), and Latinate single-word verb (abandon, replacing the phrasal "give up"). The actor (we) is removed entirely — perfect for formal writing. (a) nominalises but keeps "give up"; (b) is awkward ("for project abandonment") and unnecessarily names the actor; (c) keeps the phrasal "give up" and names the actor.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62de42b6-faaf-592a-8879-b6849fb4c3b9', '56ac58aa-2ca3-5e52-ad90-59ee85bb06de', 'Read: "The analysis of patient outcomes following the implementation of the revised protocol indicates a statistically significant improvement in recovery rates."
How many nominalisations does this sentence contain?', '[{"id":"a","text":"Two (analysis, improvement)"},{"id":"b","text":"Three (analysis, implementation, improvement)"},{"id":"c","text":"Four (analysis, outcomes, implementation, improvement)"},{"id":"d","text":"Five (analysis, outcomes, implementation, improvement, recovery)"}]'::jsonb, 'c', 'Four nominalisations: "analysis" (from "analyse"), "outcomes" (from "occur" / "come out"), "implementation" (from "implement"), and "improvement" (from "improve"). "Recovery" derives from "recover" (also a nominalisation) — making it five if included — but "recovery" in medical contexts is a conventional noun, not always counted as a functional nominalisation. "Rates" is not a nominalisation. The intended answer is (c) for the four clear process nominalisations.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8382d959-a78a-5448-bed6-0af18c99b06e', '56ac58aa-2ca3-5e52-ad90-59ee85bb06de', 'Which sentence INCORRECTLY attempts to replace a phrasal verb with a formal equivalent?', '[{"id":"a","text":"The proposal was relinquished by the majority of board members."},{"id":"b","text":"The audit revealed that costs had been significantly understated."},{"id":"c","text":"The committee resolved to defer the matter to the next session."},{"id":"d","text":"The report was examined and all findings were corroborated by independent reviewers."}]'::jsonb, 'a', '"Relinquished" means to voluntarily give up control or possession of something — it replaces "give up" in the sense of releasing something held. But "the proposal was relinquished" is semantically odd: proposals are rejected, withdrawn, or abandoned — not relinquished. The formal word is used incorrectly in context. (b), (c), and (d) all use formal vocabulary accurately and appropriately.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a989d97f-13ad-5654-900e-7c3bd78a584c', '56ac58aa-2ca3-5e52-ad90-59ee85bb06de', 'Read two versions of the same content:
Version A: "Scientists found out that the drug can make inflammation go down."
Version B: "The discovery that the drug facilitates a reduction in inflammation has significant implications for treatment."
Which statement BEST explains what makes Version B more formal?', '[{"id":"a","text":"Version B is longer, which always makes writing more formal."},{"id":"b","text":"Version B uses nominalisations (discovery, reduction), Latinate verbs (facilitates), removes the actor (scientists), and eliminates informal phrasal constructions (find out, go down)."},{"id":"c","text":"Version B avoids the word ''drug'', which is informal."},{"id":"d","text":"Version B uses the passive voice in every clause, which is the main marker of formality."}]'::jsonb, 'b', 'Option (b) gives the complete and accurate explanation: nominalisation (discovery, reduction), Latinate/formal verbs (facilitates), removal of the personal agent (Scientists → implied via discovery), and elimination of informal phrasal constructions (find out → discovery; go down → reduction). Length alone does not determine formality (a); "drug" is standard in medical writing (c); not every clause is passive in Version B (d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('23ebfe42-0d8e-5f0c-858d-e0f4e4820710', '6e02f8d0-b12f-5308-9946-a98f4ab38838', 'anglais-c2', '⭐⭐ Drill: Register, Formality and Nominalisation', 2, 75, 15, 'practice', 'admin', 5)
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
  ('293aaae9-411d-590d-aa48-5a8b576c6ab5', '23ebfe42-0d8e-5f0c-858d-e0f4e4820710', 'Choose the MOST formal equivalent of the phrase "get rid of" in an official report.', '[{"id":"a","text":"throw away"},{"id":"b","text":"do away with"},{"id":"c","text":"eliminate"},{"id":"d","text":"chuck out"}]'::jsonb, 'c', '"Eliminate" is the Latinate single-word verb appropriate for an official report. "Do away with" is a slightly formal phrasal verb but still a multi-word construction. "Throw away" is an informal phrasal verb, and "chuck out" is highly colloquial. In formal academic or official writing, a single Latinate verb always outranks a multi-word equivalent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dcca13f8-c973-5f35-8c10-031950be20e1', '23ebfe42-0d8e-5f0c-858d-e0f4e4820710', 'Which sentence contains a NOMINALISATION?', '[{"id":"a","text":"They decided to restructure the department."},{"id":"b","text":"The restructuring of the department was authorised."},{"id":"c","text":"They will restructure the department soon."},{"id":"d","text":"Restructuring is what they are going to do."}]'::jsonb, 'b', 'In the second sentence, the verb "restructure" has been converted into the noun phrase "the restructuring" — this is nominalisation. The sentence also uses an impersonal passive (was authorised), compounding the formal effect. The other options use restructure as a verb or gerund in a more personal, active construction — not full nominalisation.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ca71847-bc51-539f-b9a1-3e93b071a7c2', '23ebfe42-0d8e-5f0c-858d-e0f4e4820710', 'Which sentence is written in the MOST formal register?', '[{"id":"a","text":"It''s crucial that we look into this ASAP."},{"id":"b","text":"The matter requires urgent investigation."},{"id":"c","text":"We really need to check this out quickly."},{"id":"d","text":"Someone should look at this pretty fast."}]'::jsonb, 'b', 'The second option uses nominalisation (investigation), Latinate vocabulary (requires, urgent), and avoids contractions, phrasal verbs, and filler adverbs — all hallmarks of formal register. The first uses a contraction (it''s) and an abbreviation (ASAP). The third uses emphatic adverbs and a phrasal verb (check out). The fourth is vague and informal (someone, pretty fast).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('46020b3e-6759-5b1e-ab19-648b462657bc', '23ebfe42-0d8e-5f0c-858d-e0f4e4820710', 'Find the sentence with a REGISTER CLASH — an inappropriate mix of formal and informal.', '[{"id":"a","text":"We regret to inform you that your application was unsuccessful."},{"id":"b","text":"The committee resolved to defer the matter pending further analysis."},{"id":"c","text":"An investigation has been launched into the alleged irregularities."},{"id":"d","text":"The tribunal''s findings are pretty damning for the management team."}]'::jsonb, 'd', '"Pretty damning" uses an informal intensifier (pretty) in what is otherwise a formal legal context (tribunal''s findings). A consistent formal register would say "deeply damaging" or "severely critical". The other three sentences maintain consistent formal register throughout — no contractions, no informal adverbs, no colloquial vocabulary.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5687c90e-fbb3-5d8d-aa3d-b325b84bdb5f', '23ebfe42-0d8e-5f0c-858d-e0f4e4820710', 'Transform this sentence into fully formal academic writing: "Researchers found that the drug makes pain go down a lot."
Choose the BEST version.', '[{"id":"a","text":"Researchers found that the drug makes pain decrease considerably."},{"id":"b","text":"Research findings indicate a significant reduction in pain associated with the drug."},{"id":"c","text":"The drug was found to reduce pain by a lot, according to researchers."},{"id":"d","text":"It was found by researchers that pain goes down a lot from the drug."}]'::jsonb, 'b', 'The second option achieves the most complete transformation: nominalisation (findings, reduction), Latinate vocabulary (indicate, associated), impersonal passive construction (is implied through the noun phrase structure), and no informal quantifier (a lot → significant). The first replaces only the phrasal verb and a lot. The third keeps "a lot". The fourth uses the passive but retains "goes down a lot" and "a lot".', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('633715de-2511-5d43-af00-f24f9900f34e', '23ebfe42-0d8e-5f0c-858d-e0f4e4820710', 'Read this extract from a formal letter: "We write to acknowledge receipt of your complaint dated 12 May and to inform you that a full ___ has been initiated."
Which nominalisation BEST completes the sentence?', '[{"id":"a","text":"look-into"},{"id":"b","text":"checking-out"},{"id":"c","text":"investigation"},{"id":"d","text":"find-out"}]'::jsonb, 'c', '"Investigation" is the Latinate nominalisation of "investigate" — the standard formal noun for an official enquiry. "Look-into" and "checking-out" are informal phrasal verb nominalisations (hyphenated) that belong to colloquial register and never appear in formal correspondence. "Find-out" is not a standard nominalisation at all — it is simply a hyphenated informal expression.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b381c97a-dce4-5e24-905b-9032c809f7ed', '67f513ed-06bc-55e4-b8e6-a0c91c612378', 'anglais-c2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('920fac69-8575-58dd-b5d8-0284b66a3059', 'b381c97a-dce4-5e24-905b-9032c809f7ed', 'Complete: "The new policy will greatly ___ the number of available jobs."', '[{"id":"a","text":"effect"},{"id":"b","text":"affect"},{"id":"c","text":"infer"},{"id":"d","text":"imply"}]'::jsonb, 'b', '"Affect" is the verb meaning to have an impact on: the policy will affect jobs. "Effect" is normally a noun (the effect of the policy); it can be a rare formal verb meaning to bring about, but "affect" is the standard verb here. "Infer" and "imply" are about communication, not impact on a situation.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('99861f17-a7f2-5454-bb30-4a821f77efb5', 'b381c97a-dce4-5e24-905b-9032c809f7ed', 'Who IMPLIES and who INFERS?
"She never said the meeting was cancelled, but I could tell from her tone."
She ___ it; he ___ it from her tone.', '[{"id":"a","text":"inferred / implied"},{"id":"b","text":"implied / inferred"},{"id":"c","text":"implied / implied"},{"id":"d","text":"inferred / inferred"}]'::jsonb, 'b', 'The speaker/writer implies (puts the meaning in indirectly); the listener/reader infers (takes the meaning out from evidence). She implied it; he inferred it from her tone. Mnemonic: writers imply; readers infer.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('550495a8-a78c-5c11-9e67-44b2102c9cd1', 'b381c97a-dce4-5e24-905b-9032c809f7ed', 'Which sentence uses ''comprise'' or ''compose'' CORRECTLY?', '[{"id":"a","text":"The research team is composed of twelve scientists."},{"id":"b","text":"The research team is comprised of twelve scientists."},{"id":"c","text":"The research team is composed by twelve scientists."},{"id":"d","text":"The research team composes twelve scientists."}]'::jsonb, 'a', '"Is composed of" is the correct passive form — using the preposition of. (b) "is comprised of" reverses the logic and is widely criticised in formal writing — the active "comprises" is preferred. (c) "is composed by" uses the wrong preposition (by indicates agent in passive, not composition). (d) "composes twelve scientists" reverses the direction incorrectly.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c83d25dc-b65a-5795-9070-216fca32404b', 'b381c97a-dce4-5e24-905b-9032c809f7ed', 'Complete: "She has ___ interruptions from her neighbour all week — it keeps stopping and starting."', '[{"id":"a","text":"continuous"},{"id":"b","text":"historical"},{"id":"c","text":"continual"},{"id":"d","text":"principal"}]'::jsonb, 'c', '"Continual" means recurring frequently but with breaks — which fits "keeps stopping and starting". "Continuous" means without any interruption at all. "Historical" and "principal" are entirely unrelated to the meaning required here.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('faeb109b-3226-5ab8-9082-befd38169896', 'b381c97a-dce4-5e24-905b-9032c809f7ed', 'Complete: "You should ___ more research before reaching a conclusion."', '[{"id":"a","text":"make"},{"id":"b","text":"have"},{"id":"c","text":"take"},{"id":"d","text":"do"}]'::jsonb, 'd', 'The correct collocation is "do research" — not make, have, or take. "Make research" is a very common non-native error. "Do" is the fixed collocate for research, homework, and similar intellectual activities.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fc509bb9-62e7-5a3a-a546-9647ea4cf14e', '67f513ed-06bc-55e4-b8e6-a0c91c612378', 'anglais-c2', '⭐ Practice: Core Confusable Pairs', 1, 50, 10, 'practice', 'admin', 1)
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
  ('956a4c0f-264a-5e04-9047-47eeed4f325b', 'fc509bb9-62e7-5a3a-a546-9647ea4cf14e', 'Complete: "The noise from the construction site is starting to ___ my concentration."', '[{"id":"a","text":"effect"},{"id":"b","text":"affect"},{"id":"c","text":"infer"},{"id":"d","text":"compose"}]'::jsonb, 'b', '"Affect" is the verb meaning to have an impact on something: the noise affects my concentration. "Effect" is a noun (the effect of the noise). "Infer" is about deduction; "compose" is about making up a whole. Neither fits here.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16172beb-834f-5207-979f-325c1f13fe77', 'fc509bb9-62e7-5a3a-a546-9647ea4cf14e', 'Which sentence uses "fewer" and "less" CORRECTLY?', '[{"id":"a","text":"There are less students in the class this year."},{"id":"b","text":"We have fewer time than we thought."},{"id":"c","text":"Fewer people came to the event; there was also less noise."},{"id":"d","text":"There are less choices and fewer water available."}]'::jsonb, 'c', '"Fewer" goes with countable nouns (people), and "less" goes with uncountable nouns (noise). Only (c) uses both correctly. (a) uses "less students" — students is countable, so fewer is required. (b) uses "fewer time" — time is uncountable, so less is required. (d) reverses both: choices is countable (fewer choices), water is uncountable (less water).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('97b70d59-a9e7-5b0b-88fe-65bcb6ec9420', 'fc509bb9-62e7-5a3a-a546-9647ea4cf14e', 'Complete: "That was a very ___ decision — you weighed up all the risks carefully."', '[{"id":"a","text":"sensible"},{"id":"b","text":"sensitive"},{"id":"c","text":"disinterested"},{"id":"d","text":"continual"}]'::jsonb, 'a', '"Sensible" means showing good judgement and practical reasoning — exactly what "weighing up all the risks" demonstrates. "Sensitive" means emotionally reactive or perceptive — the wrong word here. "Disinterested" means impartial; "continual" means recurring — both unrelated to the context.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('58c78246-bb0a-5d05-aa99-caf4d7fe82e8', 'fc509bb9-62e7-5a3a-a546-9647ea4cf14e', 'Complete: "We need a ___ referee — someone with no stake in the outcome."', '[{"id":"a","text":"uninterested"},{"id":"b","text":"sensitive"},{"id":"c","text":"continual"},{"id":"d","text":"disinterested"}]'::jsonb, 'd', '"Disinterested" means impartial — having no personal stake or bias in the outcome, which is exactly what a good referee needs. "Uninterested" means simply not interested or bored — the opposite of what you want in a referee. "Sensitive" and "continual" are unrelated to the idea of impartiality.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a20e2408-0f3b-5326-a036-93c4524e884e', 'fc509bb9-62e7-5a3a-a546-9647ea4cf14e', 'Choose the CORRECT collocation.', '[{"id":"a","text":"She made a thorough research into the causes."},{"id":"b","text":"She did a thorough research into the causes."},{"id":"c","text":"She carried out thorough research into the causes."},{"id":"d","text":"She took a thorough research into the causes."}]'::jsonb, 'c', 'The correct collocations are "do research" or "carry out research". However, "research" here is an uncountable noun (you cannot say "a thorough research" with an article unless it is countable, which is rare and refers to a specific study). Option (c) correctly uses "carry out thorough research" without an article. (a), (b), and (d) all use the article "a" before "research", which is non-standard in this context.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2c6c350-4944-565c-930a-2a303fcc3e11', 'fc509bb9-62e7-5a3a-a546-9647ea4cf14e', 'Complete: "She paid me a wonderful ___; she said my presentation was the best she''d heard all year."', '[{"id":"a","text":"complement"},{"id":"b","text":"compliment"},{"id":"c","text":"principle"},{"id":"d","text":"principal"}]'::jsonb, 'b', '"Compliment" is an expression of praise or admiration — she said something kind about the presentation. "Complement" means something that completes or goes well with something else. "Principle" is a rule or belief; "principal" means main or head of a school. Only (b) fits the meaning of a verbal expression of praise.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cd1e3de9-2467-5620-af89-7c184928e60f', '67f513ed-06bc-55e4-b8e6-a0c91c612378', 'anglais-c2', '⭐⭐ Review: Connotation and Collocation', 2, 75, 15, 'practice', 'admin', 2)
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
  ('2d122806-9e40-5d8f-ad26-82e100ac6a17', 'cd1e3de9-2467-5620-af89-7c184928e60f', 'Choose the word with a POSITIVE connotation to fill the gap: "She was ___ about money, always making sure nothing was wasted."', '[{"id":"a","text":"miserly"},{"id":"b","text":"stingy"},{"id":"c","text":"thrifty"},{"id":"d","text":"tight-fisted"}]'::jsonb, 'c', '"Thrifty" means careful and economical with money — a positive quality. "Miserly" and "stingy" imply an unpleasant reluctance to spend. "Tight-fisted" is informal and also negative. Only "thrifty" carries a positive connotation for the same behaviour.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e088883a-f3dd-5168-81c7-83ddcca3b094', 'cd1e3de9-2467-5620-af89-7c184928e60f', 'Find the INCORRECT collocation.', '[{"id":"a","text":"commit a crime"},{"id":"b","text":"reach a conclusion"},{"id":"c","text":"raise awareness"},{"id":"d","text":"make a research"}]'::jsonb, 'd', '"Make a research" is incorrect — the correct collocation is "do research" or "carry out research". You cannot say "make research". The other collocations are all standard: commit a crime, reach a conclusion, and raise awareness are all fixed and correct.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b117e20c-8993-5a8f-891d-86f9677a149f', 'cd1e3de9-2467-5620-af89-7c184928e60f', 'Complete: "The new dessert perfectly ___ the flavour of the main course — it was a brilliant pairing."', '[{"id":"a","text":"complimented"},{"id":"b","text":"complemented"},{"id":"c","text":"implied"},{"id":"d","text":"composed"}]'::jsonb, 'b', '"Complement" (verb) means to complete or go well together with — a perfect description of a food pairing. "Compliment" (verb) means to express praise; you can compliment a person but not a flavour. "Implied" and "composed" make no sense in this context.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7050af91-e097-5b32-9445-5448c62348e1', 'cd1e3de9-2467-5620-af89-7c184928e60f', 'Which sentence uses the word "notorious" INCORRECTLY?', '[{"id":"a","text":"The area is notorious for its high crime rate."},{"id":"b","text":"She is notorious for arriving late to every meeting."},{"id":"c","text":"He is notorious for his groundbreaking contributions to medicine."},{"id":"d","text":"The company is notorious for its poor customer service."}]'::jsonb, 'c', '"Notorious" means famous specifically for something negative or bad. Being famous for "groundbreaking contributions to medicine" is a positive achievement — the correct word is "renowned" or "celebrated". (a), (b), and (d) all use "notorious" correctly for negative associations (crime, lateness, poor service).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3a0d3af-49e4-5485-a07c-58f88d35d9a4', 'cd1e3de9-2467-5620-af89-7c184928e60f', 'Complete: "The ___ cause of the delay was a technical fault in the signalling system."', '[{"id":"a","text":"principle"},{"id":"b","text":"principal"},{"id":"c","text":"continual"},{"id":"d","text":"historic"}]'::jsonb, 'b', '"Principal" (adjective) means main or most important: the principal cause. "Principle" is a noun meaning a rule or belief (a principle of fairness) — it cannot function as an adjective meaning main. "Continual" means recurring; "historic" means significant/landmark — neither fits the meaning of ''main cause''.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c026365-c749-5087-a556-417c9cb94610', 'cd1e3de9-2467-5620-af89-7c184928e60f', 'Choose the option that corrects the collocation error: "The government is trying to rise awareness about mental health."', '[{"id":"a","text":"The government is trying to raise awareness about mental health."},{"id":"b","text":"The government is trying to arise awareness about mental health."},{"id":"c","text":"The government is trying to rise the awareness about mental health."},{"id":"d","text":"The government is trying to make awareness about mental health."}]'::jsonb, 'a', 'The correct collocation is "raise awareness" — raise is transitive (takes an object). "Rise" is intransitive (prices rise, the sun rises) and cannot take an object like "awareness". "Arise" has a different meaning (to come up/occur). "Make awareness" is not a collocation in English.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('34ff5c62-acef-50de-8a22-7619b6befc4d', '67f513ed-06bc-55e4-b8e6-a0c91c612378', 'anglais-c2', '⚔️ Chapter Boss ⭐⭐⭐: Nuance and Confusable Words', 3, 120, 30, 'boss', 'admin', 3)
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
  ('56ae85f0-e307-5cd2-b535-f10c57a885f4', '34ff5c62-acef-50de-8a22-7619b6befc4d', 'Find the INCORRECT sentence.', '[{"id":"a","text":"The report implied that further redundancies were likely."},{"id":"b","text":"She inferred from the report that further redundancies were likely."},{"id":"c","text":"The manager implied from her expression that she was worried."},{"id":"d","text":"We inferred that the project was in difficulty from the silence on the issue."}]'::jsonb, 'c', 'The error is (c): "implied from her expression" is wrong. It is the observer (reader/listener) who infers from evidence — the manager inferred from her expression. Imply means to suggest indirectly (as a speaker/writer puts a meaning in); you cannot imply from observing someone else''s expression. (a), (b), and (d) use imply and infer correctly.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98534318-f4a2-5695-8eb7-30dc2de19d63', '34ff5c62-acef-50de-8a22-7619b6befc4d', 'Complete with the most precise word: "The committee, which ___ three senior managers and two independent advisors, met yesterday."', '[{"id":"a","text":"comprises"},{"id":"b","text":"is comprised of"},{"id":"c","text":"composes"},{"id":"d","text":"is composed by"}]'::jsonb, 'a', '"Comprises" is the formally correct active verb: the committee comprises [its members]. "Is comprised of" is widely used but criticised in formal writing — the preferred form avoids the passive. "Composes" reverses the logic (members compose the committee, not the other way round here). "Is composed by" uses the wrong preposition (by instead of of).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5eeb559-3ea1-585e-9470-b6f731b3f6d7', '34ff5c62-acef-50de-8a22-7619b6befc4d', 'Choose the sentence with the CORRECT connotation for the context: a job advertisement seeking a confident leader.', '[{"id":"a","text":"We seek an aggressive manager who will push through results at any cost."},{"id":"b","text":"We seek an assertive manager who will lead the team with confidence."},{"id":"c","text":"We seek a notorious manager with a track record of results."},{"id":"d","text":"We seek a miserly manager who will keep costs down."}]'::jsonb, 'b', '"Assertive" has a positive connotation — confident and direct without being hostile. "Aggressive" carries a negative connotation of hostility. "Notorious" means famous for something bad — disqualifying in a job ad. "Miserly" means meanly reluctant to spend money — negative connotation entirely wrong for leadership.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4280a3ff-041a-55a3-b407-2237920168c0', '34ff5c62-acef-50de-8a22-7619b6befc4d', 'Read: "The director of the film is notorious for his precise attention to detail, often shooting each scene dozens of times."
What is WRONG with this sentence?', '[{"id":"a","text":"\"Notorious\" should be \"renowned\" or \"famous\" — the quality described is positive, not negative."},{"id":"b","text":"\"Precise attention to detail\" is an incorrect collocation."},{"id":"c","text":"\"Shooting each scene\" uses the wrong verb form."},{"id":"d","text":"Nothing is wrong — the sentence is correct."}]'::jsonb, 'a', '"Notorious" implies fame for something bad. Precise attention to detail — especially in filmmaking — is a positive trait; the correct words are "renowned" or "famous". The sentence is grammatically well-formed but semantically wrong due to the negative connotation of notorious. Collocations and verb forms are fine.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb2f5993-84dc-548e-b3d2-79c2d87daff4', '34ff5c62-acef-50de-8a22-7619b6befc4d', 'Find the INCORRECT collocation.', '[{"id":"a","text":"She was deeply concerned about the results."},{"id":"b","text":"They committed a serious crime."},{"id":"c","text":"He made a strong decision under pressure."},{"id":"d","text":"We reached a unanimous conclusion."}]'::jsonb, 'c', '"Made a strong decision" is not the natural collocation. Decisions are "made" (correct), but the adjective that collocates with "decision" is not "strong". You make a decision — but you describe it as "difficult", "bold", "informed", or "well-considered", not "strong". "Strong" collocates with "argument", "evidence", or "opinion" — not "decision". (a) deeply concerned, (b) committed a crime, and (d) reached a conclusion are all standard collocations.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f953c73-3888-5045-b1cd-655e22222973', '34ff5c62-acef-50de-8a22-7619b6befc4d', 'Read: "Her ___ approach to the problem impressed everyone: she listened to all sides, had no personal agenda, and gave a balanced judgement."
Which word BEST completes the sentence?', '[{"id":"a","text":"uninterested"},{"id":"b","text":"disinterested"},{"id":"c","text":"sensible"},{"id":"d","text":"sensitive"}]'::jsonb, 'b', '"Disinterested" means impartial — having no personal stake in the outcome. This perfectly describes someone who listens to all sides, has no personal agenda, and gives a balanced judgement. "Uninterested" means simply bored or indifferent — the opposite of someone actively giving a balanced judgement. "Sensible" means practical; "sensitive" means emotionally perceptive — neither captures the idea of impartiality.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2899f53e-4af9-5533-a830-b5b23e9c5ce8', '67f513ed-06bc-55e4-b8e6-a0c91c612378', 'anglais-c2', '👑 Elite Challenge ⭐⭐⭐⭐: Nuance and Confusable Words', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('65b15669-28e6-5cd9-b3a1-1d60c910047a', '2899f53e-4af9-5533-a830-b5b23e9c5ce8', 'Read: "The policy change effected a significant reduction in carbon emissions."
Which statement about the use of "effected" is CORRECT?', '[{"id":"a","text":"It is wrong — it should be \"affected\"."},{"id":"b","text":"It is wrong — it should be \"had an effect on\"."},{"id":"c","text":"It is correct — \"effect\" can be used as a formal verb meaning to bring about or cause."},{"id":"d","text":"It is wrong — \"effected\" is not a real English word."}]'::jsonb, 'c', '"Effect" can function as a rare, formal verb meaning to bring about or cause: "to effect a change" = to make a change happen. The sentence correctly uses "effected a significant reduction" to mean brought about a reduction. "Affected" would mean had an impact on (a different meaning). This is a genuine C2-level distinction taught in the cours.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('756d413c-6246-5d1c-93da-dca601a78f1b', '2899f53e-4af9-5533-a830-b5b23e9c5ce8', 'Find the sentence with the SUBTLEST collocation error.', '[{"id":"a","text":"The study provides strong evidence for the link between diet and health."},{"id":"b","text":"She gave a deep speech about her experiences."},{"id":"c","text":"The committee reached a unanimous decision."},{"id":"d","text":"He raised a valid concern about the budget."}]'::jsonb, 'b', '"Gave a deep speech" is the error. The adjective that collocates with speech in this context is "profound", "moving", "powerful", or "heartfelt" — not "deep". "Deep" collocates with thought, sleep, breath, or concern, but not speech in this way. (a) strong evidence, (c) unanimous decision, and (d) raised a concern are all standard collocations.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c1e82944-6dcf-5829-9cfd-f6765e3174c9', '2899f53e-4af9-5533-a830-b5b23e9c5ce8', 'Read: "The historical victory of 1966 is still celebrated today. It was a historic moment for the nation."
Are these two uses of "historic" and "historical" correct?', '[{"id":"a","text":"Yes, both are correct — they mean the same thing."},{"id":"b","text":"No — \"historical\" in the first sentence is wrong; \"the historic victory\" is correct. \"Historic\" in the second sentence is also correct."},{"id":"c","text":"No — \"historic\" in the second sentence is wrong; it should be \"historical\"."},{"id":"d","text":"No — both should be \"historic\"."}]'::jsonb, 'b', '"Historical" means relating to or belonging to history in general (a historical novel, historical records). "Historic" means significant or landmark — something that makes history. A victory in 1966 that is still celebrated is a landmark event: the correct adjective is "historic". The second use (a historic moment for the nation) is correct. So the first sentence uses "historical" incorrectly — it should be "historic".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3e0d485-c44d-5c19-a101-206357fc0455', '2899f53e-4af9-5533-a830-b5b23e9c5ce8', 'Read: "The committee ___ seven members: three from the legal sector, two economists, and two scientists."
Choose the MOST formally precise option.', '[{"id":"a","text":"is comprised of"},{"id":"b","text":"is made up of"},{"id":"c","text":"is composed by"},{"id":"d","text":"comprises"}]'::jsonb, 'd', '"Comprises" is the formally preferred active form: the whole (committee) comprises its parts (the members). "Is comprised of" reverses the passive incorrectly in prescriptive formal usage — many style guides reject it. "Is made up of" is informal. "Is composed by" uses the wrong preposition; the correct passive is "is composed of".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02864476-9f47-51c7-8f4b-5126f25db9e1', '2899f53e-4af9-5533-a830-b5b23e9c5ce8', 'Which sentence contains a CONNOTATION error — a word whose implied feeling contradicts the intended positive meaning?', '[{"id":"a","text":"She is renowned for her compassionate approach to patient care."},{"id":"b","text":"He is celebrated for his innovative research methods."},{"id":"c","text":"The architect is admired for her minimalist design philosophy."},{"id":"d","text":"The professor is notorious for inspiring generations of students."}]'::jsonb, 'd', '"Notorious" implies fame for something bad or disreputable. Inspiring students is a positive quality — the correct words would be "renowned", "celebrated", or "admired". The other three sentences use words with positive or neutral connotations that correctly match the positive qualities described.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5040f31a-0513-54b5-b06f-97d96f36b82a', '2899f53e-4af9-5533-a830-b5b23e9c5ce8', 'Read: "Despite her outwardly ___ demeanour, she was deeply ___ to the suffering around her — often moved to tears by small acts of injustice."
Choose the BEST pair.', '[{"id":"a","text":"sensitive / sensible"},{"id":"b","text":"notorious / sensible"},{"id":"c","text":"sensible / sensitive"},{"id":"d","text":"disinterested / continuous"}]'::jsonb, 'c', 'The contrast "outwardly [calm/practical] demeanour" vs "deeply [emotionally reactive] to suffering" requires: sensible (showing good, practical judgement — the outward appearance) and sensitive (easily and deeply affected emotionally — the inner reality). This contrast is exactly what the confusable pair teaches. The other options are semantically incoherent in context.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f2db4908-bd00-5814-a9b4-6102af01415f', '67f513ed-06bc-55e4-b8e6-a0c91c612378', 'anglais-c2', '⭐⭐ Drill: Nuance and Confusable Words', 2, 75, 15, 'practice', 'admin', 5)
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
  ('25739a39-c45e-5012-a7a6-df7f6bf518c8', 'f2db4908-bd00-5814-a9b4-6102af01415f', 'Complete: "The editorial ___ that the minister had misled parliament, without stating it directly."', '[{"id":"a","text":"inferred"},{"id":"b","text":"implied"},{"id":"c","text":"affected"},{"id":"d","text":"effected"}]'::jsonb, 'b', 'The editorial (as writer/speaker) implies — it puts meaning in indirectly without stating it. The reader infers — takes meaning out from what they read. Inferred is therefore the wrong direction. Affected means to have an impact on; effected (as a verb) means to bring about — neither fits the meaning of suggesting something indirectly.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('895f513c-d27e-59ad-b493-cb2a2c4dceab', 'f2db4908-bd00-5814-a9b4-6102af01415f', 'Complete: "We need ___ volunteers for this project — not a constant stream, just someone willing to help now and again."', '[{"id":"a","text":"continual"},{"id":"b","text":"continuous"},{"id":"c","text":"historic"},{"id":"d","text":"principal"}]'::jsonb, 'a', '"Continual" means recurring at intervals with breaks — fitting the context of helping "now and again". "Continuous" means without any interruption at all, which contradicts "not a constant stream". Historic means significant or landmark; principal means main — neither relates to frequency of volunteering.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de093ced-c064-5285-a2cd-415ebf6ad206', 'f2db4908-bd00-5814-a9b4-6102af01415f', 'Which sentence uses "fewer" and "less" INCORRECTLY?', '[{"id":"a","text":"There are fewer options than we expected."},{"id":"b","text":"We have less time to prepare than last year."},{"id":"c","text":"Less volunteers turned up than were promised."},{"id":"d","text":"Fewer errors were found in the second draft."}]'::jsonb, 'c', '"Volunteers" is a countable noun, so fewer is required: fewer volunteers. Less is correct only with uncountable nouns (less time, less water). The other three sentences all apply the rule correctly: fewer options (countable), less time (uncountable), fewer errors (countable).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4606c41-a58d-50cb-898f-eb8f95198d6b', 'f2db4908-bd00-5814-a9b4-6102af01415f', 'Complete: "The wine''s subtle oak notes perfectly ___ the richness of the aged cheese."', '[{"id":"a","text":"complimented"},{"id":"b","text":"implied"},{"id":"c","text":"complemented"},{"id":"d","text":"composed"}]'::jsonb, 'c', '"Complemented" (verb from complement) means to go well with or complete — exactly the relationship between wine notes and cheese. "Complimented" means to pay verbal praise, which cannot apply to flavours. "Implied" is about indirect suggestion; "composed" is about making up a whole. The spelling difference (compliMENT vs compLEMENT) is the classic trap here.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80a0b797-fe73-575d-9ef8-3352fd6e5c3c', 'f2db4908-bd00-5814-a9b4-6102af01415f', 'Read: "She was ___ about the outcome — she had no stake in either side and simply wanted a fair process."
Which word BEST completes the sentence?', '[{"id":"a","text":"uninterested"},{"id":"b","text":"sensible"},{"id":"c","text":"notorious"},{"id":"d","text":"disinterested"}]'::jsonb, 'd', '"Disinterested" means impartial — having no personal stake in the outcome, which fits someone who simply wants fairness. "Uninterested" means bored or indifferent, which contradicts the active desire for a fair process. "Sensible" means showing good judgement but does not convey impartiality. "Notorious" means famous for something negative — entirely wrong here.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f8cec53-5d0f-56ec-8a7c-db82b29c53b0', 'f2db4908-bd00-5814-a9b4-6102af01415f', 'Find the sentence with a COLLOCATION error.', '[{"id":"a","text":"The government pledged to raise awareness of the health risks."},{"id":"b","text":"She reached a decision after weighing all the evidence."},{"id":"c","text":"They did a historic mistake by ignoring the warning signs."},{"id":"d","text":"The team committed a serious foul in the closing minutes."}]'::jsonb, 'c', '"Did a historic mistake" contains two errors: the correct collocation is make a mistake (not do), and the correct adjective is historical (relating to the past) or simply a serious mistake. "Historic" means landmark or significant and does not collocate naturally with mistake. Raise awareness, reach a decision, and commit a foul are all standard collocations.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('867db683-8f35-5715-af86-1e84aee80f50', 'e45a5f31-4d6d-536e-b129-ddec5e7376ff', 'anglais-c2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('7c1e5ec9-d703-5d8a-8a54-852e05e90707', '867db683-8f35-5715-af86-1e84aee80f50', 'What is ellipsis in grammar?', '[{"id":"a","text":"Adding extra words to make a sentence more emphatic."},{"id":"b","text":"Replacing a noun with a pronoun."},{"id":"c","text":"Using connectors such as however and furthermore."},{"id":"d","text":"Omitting words that are predictable from context to make language more concise."}]'::jsonb, 'd', 'Ellipsis is the deliberate omission of words that are understood from context — making language more natural and concise without loss of meaning. Replacing a noun with a pronoun (b) is substitution or reference; adding words (a) is the opposite of ellipsis; connectors (c) describe cohesive devices.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('abc50f34-2fce-5e87-93a0-dfcfd20eeeef', '867db683-8f35-5715-af86-1e84aee80f50', 'Complete: "She submitted her essay on time, but I didn''t manage to do ___."', '[{"id":"a","text":"so"},{"id":"b","text":"it"},{"id":"c","text":"one"},{"id":"d","text":"such"}]'::jsonb, 'a', '"Do so" replaces the entire verb phrase "submit my essay on time" — the standard substitution for a repeated verb phrase. "It" would need a clear noun referent, not a whole verb phrase. "One" replaces a countable noun. "Such" is a formal demonstrative, not used in this structure.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6413abb8-5794-5328-9bd3-939e2a0095fd', '867db683-8f35-5715-af86-1e84aee80f50', 'Complete: "I''m not sure if the meeting has been rescheduled — I believe ___."', '[{"id":"a","text":"not"},{"id":"b","text":"one"},{"id":"c","text":"so"},{"id":"d","text":"neither"}]'::jsonb, 'c', 'When you believe or think something is true (affirmative), use "so": I believe so = I believe it has been rescheduled. "Not" would mean I believe it has NOT been rescheduled, which contradicts the uncertainty (I''m not sure). "One" replaces nouns; "neither" expresses negative agreement — neither fits here.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d4ab3e8-e942-590e-863f-1eb251e46fec', '867db683-8f35-5715-af86-1e84aee80f50', 'Find the INCORRECT use of cohesive device.', '[{"id":"a","text":"The proposal was accepted; however, implementation was delayed."},{"id":"b","text":"The results were positive. Furthermore, they exceeded all expectations."},{"id":"c","text":"The plan was approved, however it was never carried out."},{"id":"d","text":"Costs rose sharply. As a result, the project was cancelled."}]'::jsonb, 'c', '"However" is a conjunctive adverb, not a conjunction — it cannot join two independent clauses with just a comma. This is called a comma splice. The correct form is a semicolon before it (as in option a) or a full stop before it (starting a new sentence). (a), (b), and (d) all use cohesive devices correctly.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dc47af52-9b85-5d80-ac64-357d3b57e6b8', '867db683-8f35-5715-af86-1e84aee80f50', 'Complete: "She hasn''t seen the film yet. ___ have I." — Which word CORRECTLY expresses negative agreement here?', '[{"id":"a","text":"So"},{"id":"b","text":"Neither"},{"id":"c","text":"Too"},{"id":"d","text":"Also"}]'::jsonb, 'b', '"Neither have I" expresses negative agreement — both subjects have not seen the film. Note: "Nor have I" is equally correct and interchangeable with "Neither have I". "So have I" would express positive agreement (wrong here). "Too" and "Also" are used after positive statements, not negative ones, and they do not trigger subject-auxiliary inversion.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4e098852-5532-548c-9d46-983637ca99b8', 'e45a5f31-4d6d-536e-b129-ddec5e7376ff', 'anglais-c2', '⭐ Practice: Substitution with one/so/not', 1, 50, 10, 'practice', 'admin', 1)
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
  ('8e279df7-7e62-5fd0-9644-ff4dd89f80b0', '4e098852-5532-548c-9d46-983637ca99b8', 'Complete: ''Would you like a coffee?'' — ''Yes, I''d love ___.''', '[{"id":"a","text":"one"},{"id":"b","text":"so"},{"id":"c","text":"it"},{"id":"d","text":"such"}]'::jsonb, 'a', '"One" is the nominal substitute for a countable noun (a coffee → one). "So" substitutes a whole clause (I think so). "It" would refer to a specific previously mentioned coffee, not an offer of one. "Such" is a formal demonstrative that replaces a noun phrase in a different way.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2737b679-8a38-555a-b7c4-d573893e8179', '4e098852-5532-548c-9d46-983637ca99b8', 'Complete: ''Will the report be ready by Friday?'' — ''I certainly hope ___.''', '[{"id":"a","text":"not"},{"id":"b","text":"one"},{"id":"c","text":"so"},{"id":"d","text":"such"}]'::jsonb, 'c', '"I hope so" = I hope the report will be ready by Friday (affirmative clause substitution). "Hope not" would mean I hope it will NOT be ready — the opposite of the expected meaning. "One" replaces a noun; "such" is a formal demonstrative — neither fits here.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('111f4d00-beb3-5ff2-8ff4-dbc0a74ab440', '4e098852-5532-548c-9d46-983637ca99b8', 'Complete: ''Did she get the promotion?'' — ''I''m afraid ___.''', '[{"id":"a","text":"so"},{"id":"b","text":"not"},{"id":"c","text":"one"},{"id":"d","text":"neither"}]'::jsonb, 'b', '"I''m afraid not" = I''m afraid she did not get the promotion (negative clause substitution). "I''m afraid so" would mean I''m afraid she DID get the promotion — the opposite. "One" substitutes a noun; "neither" is for negative agreement between two people''s situations.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6beee7fb-df0a-5d9e-9d13-d1f7b928e05a', '4e098852-5532-548c-9d46-983637ca99b8', 'Which sentence correctly uses nominal substitution with ''ones''?', '[{"id":"a","text":"I prefer the red shoes to the blue shoes."},{"id":"b","text":"I prefer the red shoes to the blue ones."},{"id":"c","text":"I prefer the red to the blue shoe."},{"id":"d","text":"I prefer red shoes to blue."}]'::jsonb, 'b', '"The blue ones" uses the nominal substitute "ones" to replace the repeated noun "shoes" — this is the natural, native-sounding form. (a) repeats "shoes" unnecessarily. (c) uses "shoe" in the singular, which is wrong. (d) drops the noun entirely without a substitute, which loses clarity.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('93afe125-7674-5860-9e54-931ac1aec9ad', '4e098852-5532-548c-9d46-983637ca99b8', 'Complete: "She didn''t enjoy the lecture, and ___ did her classmates — they all found it dull."', '[{"id":"a","text":"so"},{"id":"b","text":"yet"},{"id":"c","text":"neither"},{"id":"d","text":"too"}]'::jsonb, 'c', '"Neither did her classmates" expresses negative agreement — they also did not enjoy the lecture. Note that "Nor did her classmates" is equally correct. "So did" would signal positive agreement (she enjoyed it, and so did they) — the opposite of the meaning. "Yet" is a contrast marker; "too" follows positive statements only.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0490a7e6-fb91-59ab-8805-ec5d80ff4f8c', '4e098852-5532-548c-9d46-983637ca99b8', 'Complete: "They announced the new policy. ___ announcements always cause anxiety among staff."', '[{"id":"a","text":"One"},{"id":"b","text":"So"},{"id":"c","text":"Neither"},{"id":"d","text":"Such"}]'::jsonb, 'd', '"Such" is the formal substitution that replaces a previously mentioned noun phrase: "Such announcements" = announcements of that kind. "One" replaces a singular noun (not a category). "So" replaces a clause, not a noun. "Neither" signals negative agreement between two parties.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a44453e4-09ca-5936-b7e6-dbb4e2680c92', 'e45a5f31-4d6d-536e-b129-ddec5e7376ff', 'anglais-c2', '⭐⭐ Review: Cohesive Devices and Reference Chains', 2, 75, 15, 'practice', 'admin', 2)
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
  ('eb315260-c92f-5b45-b177-63773e04c22c', 'a44453e4-09ca-5936-b7e6-dbb4e2680c92', 'Choose the CORRECT cohesive device to join these two sentences: "The results were disappointing. ___, the team remained optimistic."', '[{"id":"a","text":"Furthermore"},{"id":"b","text":"Therefore"},{"id":"c","text":"In addition"},{"id":"d","text":"Nevertheless"}]'::jsonb, 'd', 'A contrast is needed: disappointing results vs remaining optimistic. "Nevertheless" (= despite this) signals the contrast perfectly. "Furthermore" and "In addition" add information (wrong relationship). "Therefore" signals a result (wrong direction — the optimism is not caused by the disappointment).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a17e1349-d783-59d4-a75b-535df3e42d97', 'a44453e4-09ca-5936-b7e6-dbb4e2680c92', 'Find the sentence that INCORRECTLY uses a cohesive device.', '[{"id":"a","text":"The deadline passed; consequently, the penalty clause was triggered."},{"id":"b","text":"Sales increased in Q1. Moreover, they rose further in Q2."},{"id":"c","text":"The policy was a success, however it was soon abandoned."},{"id":"d","text":"The project ran over budget. As a result, funding was cut."}]'::jsonb, 'c', '"However" is a conjunctive adverb — it cannot join two independent clauses with only a comma (comma splice). It needs either a semicolon before it ("…budget; however, it…") or a new sentence. (a) correctly uses a semicolon before consequently; (b) uses a new sentence before Moreover; (d) uses a new sentence before As a result.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c3b1cda-ccc7-5be9-b686-de84ee769347', 'a44453e4-09ca-5936-b7e6-dbb4e2680c92', 'Choose the BEST cohesive device for this gap: "Many students struggle with time management. ___, they often perform well in individual tasks."', '[{"id":"a","text":"Admittedly"},{"id":"b","text":"In conclusion"},{"id":"c","text":"Consequently"},{"id":"d","text":"In addition"}]'::jsonb, 'a', '"Admittedly" signals a concession — acknowledging a true weakness (time management struggles) while pointing out a contrasting strength (good individual performance). It fits the concessive relationship. "Consequently" signals a result (wrong direction); "In conclusion" would only come at the end of an argument; "In addition" adds information without the needed contrast.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bca3e1af-0da7-5221-afb8-44932d827d61', 'a44453e4-09ca-5936-b7e6-dbb4e2680c92', 'Read: "A new regulation was introduced last month. ___ regulation requires all firms to disclose their environmental impact."
Which word creates the STRONGEST cohesive link back to the regulation just mentioned?', '[{"id":"a","text":"A"},{"id":"b","text":"Any"},{"id":"c","text":"This"},{"id":"d","text":"Some"}]'::jsonb, 'c', '"This" (demonstrative determiner) creates the strongest cohesive link, explicitly pointing back to the just-mentioned regulation. The definite article "The" also creates a valid reference chain by signalling a previously known entity. "A" reintroduces the noun as if unrelated, breaking the chain. "Any" and "Some" are indefinite and introduce new instances rather than referring back.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('57c7bb21-e58f-506b-8701-eb76e9fd7e56', 'a44453e4-09ca-5936-b7e6-dbb4e2680c92', 'Identify the function of the cohesive device: "The proposal was well-researched. Furthermore, it was supported by compelling data."', '[{"id":"a","text":"Contrast"},{"id":"b","text":"Addition"},{"id":"c","text":"Cause and result"},{"id":"d","text":"Concession"}]'::jsonb, 'b', '"Furthermore" signals addition — it introduces an extra point that reinforces or adds to what came before. Both sentences present positive qualities of the proposal; the second adds to the first. There is no contrast, cause-effect relationship, or concession here.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a0b0ff5d-989a-5e5a-a4a1-fa2dc9a06ba5', 'a44453e4-09ca-5936-b7e6-dbb4e2680c92', 'Read: "She had intended to apply for the post, but in the end decided not to."
What is omitted after "decided not to" (what does the ellipsis stand for)?', '[{"id":"a","text":"to apply for the post"},{"id":"b","text":"to do it"},{"id":"c","text":"applying"},{"id":"d","text":"the post"}]'::jsonb, 'a', 'The full version would be: "…decided not to [apply for the post]". The ellipsis omits the entire infinitive phrase that has already been stated. "Decided not to" is verbal ellipsis — the omitted material (apply for the post) is recoverable from the earlier clause. This is a classic clausal/verbal ellipsis pattern.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3c63e2bc-23ae-578e-8ef1-90ceb8146c98', 'e45a5f31-4d6d-536e-b129-ddec5e7376ff', 'anglais-c2', '⚔️ Chapter Boss ⭐⭐⭐: Ellipsis, Substitution and Cohesion', 3, 120, 30, 'boss', 'admin', 3)
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
  ('b18779a5-9595-51e4-98a8-d72dae2605f7', '3c63e2bc-23ae-578e-8ef1-90ceb8146c98', 'Which sentence uses verbal ellipsis CORRECTLY?', '[{"id":"a","text":"He writes faster than she writes."},{"id":"b","text":"He writes faster than she does."},{"id":"c","text":"He writes faster than she write."},{"id":"d","text":"He writes faster than she."}]'::jsonb, 'b', '"Than she does" correctly uses verbal ellipsis — "does" stands in for the omitted "writes". This is a natural, standard form. (a) repeats "writes" unnecessarily. (c) uses the base form incorrectly. (d) drops the verb entirely without a substitute, creating an ambiguous form that is grammatically incomplete in formal written English.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ba98cb8-92dc-5343-930a-0de45e85d432', '3c63e2bc-23ae-578e-8ef1-90ceb8146c98', 'Find the sentence with an INCORRECT substitution.', '[{"id":"a","text":"\"Are you going to the meeting?\" \"I expect so.\""},{"id":"b","text":"She loves hiking and so does her partner."},{"id":"c","text":"\"Did they win?\" \"I believe not.\""},{"id":"d","text":"They didn''t finish on time, and I didn''t too."}]'::jsonb, 'd', 'The error is (d): for negative agreement, you need "Neither did I" or "Nor did I" — not "I didn''t too". "Too" is used for positive agreement only ("She came, and I did too"). (a), (b), and (c) all use substitution correctly: so after expect (clausal), so does after positive statement, not after believe (negative clausal).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('830431a1-3f53-5447-979e-6e351a15e9c7', '3c63e2bc-23ae-578e-8ef1-90ceb8146c98', 'Read: "Several anomalies were found in the data. ___ anomalies had been present since the original dataset was compiled."
Which word creates a FORMAL substitution meaning ''anomalies of that kind'' — as opposed to pointing to the specific ones just mentioned?', '[{"id":"a","text":"These"},{"id":"b","text":"Such"},{"id":"c","text":"Some"},{"id":"d","text":"Those"}]'::jsonb, 'b', '"Such" is the formal substitution that generalises: ''Such anomalies'' = anomalies of that kind, a category. "These" is also cohesive but points to the specific anomalies already mentioned (demonstrative reference, not formal substitution). "Some" implies only a subset. "Those" refers back to distant or previously mentioned specifics, similar to ''these'' but more distanced.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8895a35e-6e01-51ac-82a8-37a87fcce468', '3c63e2bc-23ae-578e-8ef1-90ceb8146c98', 'Which sentence uses an appropriate cohesive device to introduce an EXAMPLE?', '[{"id":"a","text":"Many animals migrate seasonally. Consequently, the Arctic tern travels from pole to pole."},{"id":"b","text":"Many animals migrate seasonally. Nevertheless, the Arctic tern travels from pole to pole."},{"id":"c","text":"Many animals migrate seasonally. However, the Arctic tern travels from pole to pole."},{"id":"d","text":"Many animals migrate seasonally. For instance, the Arctic tern travels from pole to pole."}]'::jsonb, 'd', '"For instance" introduces a specific example — perfect for illustrating the general claim about seasonal migration. "Consequently" signals a result (wrong); "Nevertheless" signals contrast (wrong — the tern''s migration is not a contrasting exception); "However" also signals contrast (also wrong).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4547285-04e9-58af-b3da-c8642b8d37bf', '3c63e2bc-23ae-578e-8ef1-90ceb8146c98', 'Read: "The CEO announced a restructuring plan. The plan involved redundancies. The redundancies were unexpected. The unexpected redundancies shocked employees."
Which rewrite is the MOST concise while correctly using BOTH a demonstrative reference AND a participial clause?', '[{"id":"a","text":"The CEO announced a restructuring plan. The plan involved redundancies, and these were unexpected, shocking employees."},{"id":"b","text":"The CEO announced a restructuring plan. This involved redundancies, which, being unexpected, shocked employees."},{"id":"c","text":"The CEO announced a restructuring plan involving redundancies. These proved unexpected and shocked employees."},{"id":"d","text":"The CEO announced a restructuring plan. Redundancies were announced. They were unexpected. Employees were shocked."}]'::jsonb, 'c', 'Option (c) is the most concise rewrite: a participial clause ("involving redundancies") is embedded in the first sentence, then "These" provides demonstrative reference back to the redundancies without repetition. (a) is cohesive but uses three clauses where two suffice; (b) uses a relative clause (which is good) but keeps the structure in two sentences; (d) fails entirely — it breaks the sentences into even shorter clauses without reducing repetition. (c) achieves the highest density of cohesion in the fewest words.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e822b714-49e9-5e00-a509-17cd1e45418a', '3c63e2bc-23ae-578e-8ef1-90ceb8146c98', 'Identify the TYPE of ellipsis in: "She can play the violin and [play] the cello."', '[{"id":"a","text":"Nominal ellipsis — a noun has been omitted."},{"id":"b","text":"Clausal ellipsis — an entire clause has been omitted."},{"id":"c","text":"Verbal ellipsis — a verb phrase has been omitted."},{"id":"d","text":"This is not ellipsis — it is a substitution."}]'::jsonb, 'c', 'The omitted element is the verb "play" — a verb/predicate element. This is verbal ellipsis: the auxiliary "can" and the verb "play" are omitted from the second conjunct because they have already appeared in the first. The noun (the cello) remains. No substitution pro-form is used — the element is simply left out.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0ec6d04f-1b91-5aa0-b104-73c3cf036d21', 'e45a5f31-4d6d-536e-b129-ddec5e7376ff', 'anglais-c2', '👑 Elite Challenge ⭐⭐⭐⭐: Ellipsis, Substitution and Cohesion', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('cb060e6d-4768-5197-bfef-0ffcec9655f6', '0ec6d04f-1b91-5aa0-b104-73c3cf036d21', 'Read this passage: "Three candidates were shortlisted. The first was highly experienced but lacked communication skills. The second had strong interpersonal skills but insufficient technical knowledge. The third possessed both qualities."
Which cohesive technique is used to structure the second and third sentences?', '[{"id":"a","text":"Lexical repetition of the word \"candidate\"."},{"id":"b","text":"Ordinal reference (The first / The second / The third) creating a parallel structure."},{"id":"c","text":"Substitution with \"one\" and \"ones\" throughout."},{"id":"d","text":"Ellipsis — each candidate''s name is omitted."}]'::jsonb, 'b', 'The passage uses ordinal demonstrative reference (The first, The second, The third) to create a neat parallel structure that links back to the three shortlisted candidates without repeating "candidate" each time. This is a sophisticated cohesion strategy. There is no "one/ones" substitution (c); the candidates have no names to omit (d); and "candidate" is deliberately not repeated (a).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49a46efc-912c-5472-88b7-a0d5dbccf4f8', '0ec6d04f-1b91-5aa0-b104-73c3cf036d21', 'Find the version that uses ellipsis MOST effectively (most natural, native-sounding).', '[{"id":"a","text":"I thought the presentation was excellent, and so did she."},{"id":"b","text":"I thought the presentation was excellent, and she thought the presentation was excellent too."},{"id":"c","text":"I thought the presentation was excellent, and she did think it was excellent too."},{"id":"d","text":"I thought the presentation was excellent, as did she think."}]'::jsonb, 'a', '"So did she" is the most economical and natural form: it replaces the entire clause (thought the presentation was excellent) with a two-word substitution + inversion. (b) repeats everything unnecessarily. (c) is acceptable but redundant ("did think" is unnecessarily emphatic and "it was excellent" is extra). (d) is ungrammatical — "so did she think" breaks the inversion rule.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7763dc36-96bf-503a-9000-c8eb167bedf3', '0ec6d04f-1b91-5aa0-b104-73c3cf036d21', 'Read: "The report recommended three measures. ___, it stressed the need for ongoing monitoring."
Which cohesive device BEST fills the gap?', '[{"id":"a","text":"Therefore"},{"id":"b","text":"Conversely"},{"id":"c","text":"In addition"},{"id":"d","text":"As a result"}]'::jsonb, 'c', '"In addition" signals that an extra recommendation is being layered onto the three already mentioned — this is additive cohesion. "Therefore" and "As a result" both signal a consequence, but the stress on monitoring is not a consequence of the three measures — it is a fourth recommendation alongside them. "Conversely" signals contrast, which is wrong here.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1c851ae-d0a9-5d16-8897-d3d6c561d382', '0ec6d04f-1b91-5aa0-b104-73c3cf036d21', 'Read: "Is the new infrastructure plan likely to succeed?" — "I very much doubt ___."', '[{"id":"a","text":"so"},{"id":"b","text":"it"},{"id":"c","text":"not"},{"id":"d","text":"one"}]'::jsonb, 'b', 'After "doubt", the fixed pro-form is "it" (or "that"): I doubt it. "so" follows verbs of thinking/believing/hoping — I think so, I believe so, I hope so — but NOT "doubt": "I doubt so" is non-standard (a classic over-generalisation). "not" pairs with hope/believe/suppose (I hope not); "one" replaces a countable noun, not a clause.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9ebb2d4b-9df1-55ba-949f-97eae8b9ed0f', '0ec6d04f-1b91-5aa0-b104-73c3cf036d21', 'Read this paragraph and identify the COHESION PROBLEM:
"The committee submitted its final report in March. However, the committee made several additional recommendations. The additional recommendations were not included in the final report. The final report was distributed to all stakeholders."
What is the main cohesion weakness?', '[{"id":"a","text":"The cohesive device However is used incorrectly."},{"id":"b","text":"Key nouns (the committee, the final report, the additional recommendations) are repeated excessively instead of using reference chains, substitution, or ellipsis."},{"id":"c","text":"The paragraph is too short and needs more detail."},{"id":"d","text":"The passive voice is missing and this reduces cohesion."}]'::jsonb, 'b', 'The main problem is excessive, clunky repetition of the same noun phrases (the committee, the final report, the additional recommendations) without using reference chains (it, they, these), substitution (such recommendations, these), or ellipsis. A native writer would replace repeated nouns with pronouns and demonstratives. "However" is used correctly to introduce contrast; length and passive voice are not cohesion issues.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('571cc8fa-481c-54cc-8d56-0bae0e39550c', '0ec6d04f-1b91-5aa0-b104-73c3cf036d21', 'Read: "Many economists predicted a recession, but others didn''t."
What is the FULL form of the ellipsis in "but others didn''t"?', '[{"id":"a","text":"but others didn''t believe in economics"},{"id":"b","text":"but others didn''t have a prediction"},{"id":"c","text":"but others didn''t say so"},{"id":"d","text":"but others didn''t predict a recession"}]'::jsonb, 'd', 'The ellipsis omits the verb phrase "predict a recession" — recoverable from the first clause. The full form is: "many economists predicted a recession, but others didn''t [predict a recession]". This is verbal ellipsis after an auxiliary (didn''t), the most common pattern. The other options introduce content not present in the original sentence.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5f99784e-5a92-591a-9b14-f0a56a373116', 'e45a5f31-4d6d-536e-b129-ddec5e7376ff', 'anglais-c2', '⭐⭐ Drill: Ellipsis, Substitution and Cohesion', 2, 75, 15, 'practice', 'admin', 5)
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
  ('c849bd2b-5b40-5a14-907a-ce2fbebf19e6', '5f99784e-5a92-591a-9b14-f0a56a373116', 'Complete: "''Has the budget been approved yet?'' — ''I believe ___ — we should hear by Friday.''"', '[{"id":"a","text":"so"},{"id":"b","text":"not"},{"id":"c","text":"one"},{"id":"d","text":"such"}]'::jsonb, 'a', '"I believe so" uses so to substitute for the affirmative clause "the budget has been approved" — the speaker believes it has. "I believe not" would mean the speaker believes it has not been approved, which contradicts the positive expectation implied by "we should hear by Friday". "One" and "such" replace nouns, not clauses.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('280da4e5-02d7-56c8-8a19-c339471f2b77', '5f99784e-5a92-591a-9b14-f0a56a373116', 'Which sentence uses nominal substitution with "ones" CORRECTLY?', '[{"id":"a","text":"These results are better than the old results."},{"id":"b","text":"These results are better than the old ones."},{"id":"c","text":"These results are better than old."},{"id":"d","text":"These results are better than one."}]'::jsonb, 'b', '"The old ones" correctly substitutes the repeated countable noun "results" with the plural substitute "ones". The first option repeats "results" unnecessarily. The third drops the noun without a substitute, producing an incomplete comparison. The fourth uses singular "one" where the plural "ones" is required to match "results".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc6ab325-d2b5-5a85-907e-cb48c26729ae', '5f99784e-5a92-591a-9b14-f0a56a373116', 'Choose the CORRECT cohesive device: "The project was completed on time. ___, it came in under budget."', '[{"id":"a","text":"Nevertheless"},{"id":"b","text":"However"},{"id":"c","text":"Moreover"},{"id":"d","text":"Therefore"}]'::jsonb, 'c', '"Moreover" signals addition — it introduces a second positive achievement that adds to the first. Both sentences present good news; the second layers another success on top of the first. "Nevertheless" and "However" signal contrast (wrong here — no contrast exists). "Therefore" signals a result or consequence (wrong — coming in under budget did not result from finishing on time).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('492a1f9d-d37f-53c9-9b97-8256f5fa964b', '5f99784e-5a92-591a-9b14-f0a56a373116', 'Find the INCORRECT use of a cohesive device.', '[{"id":"a","text":"The talks collapsed. As a result, sanctions were reimposed."},{"id":"b","text":"The evidence was compelling, however the jury was not convinced."},{"id":"c","text":"Many factors contributed; in particular, the lack of funding was critical."},{"id":"d","text":"She had prepared thoroughly. Nevertheless, she felt nervous."}]'::jsonb, 'b', '"However" is a conjunctive adverb that cannot join two independent clauses with only a comma — this is a comma splice. A semicolon (the evidence was compelling; however, the jury…) or a full stop is required before it. The other three sentences all punctuate their cohesive devices correctly: full stop before As a result, semicolon before in particular, full stop before Nevertheless.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1d86099-b85e-56f6-a2ff-13de9cc9125c', '5f99784e-5a92-591a-9b14-f0a56a373116', 'Read: "Many researchers had predicted the findings. Others, however, had not."
What is omitted after "had not" (what does the ellipsis stand for)?', '[{"id":"a","text":"not predicted the findings"},{"id":"b","text":"had any predictions"},{"id":"c","text":"predicted the findings"},{"id":"d","text":"been researchers"}]'::jsonb, 'c', 'The full form is: "Others had not [predicted the findings]". This is verbal ellipsis: the entire verb phrase from the first clause is omitted after the auxiliary had not, because it is fully recoverable from context. The omitted material is always the repeated verb phrase itself — predicted the findings — not a negated version or a different phrase.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('355b15ee-35ec-50f5-92eb-644ac29c78bd', '5f99784e-5a92-591a-9b14-f0a56a373116', 'Read: "A senior diplomat resigned unexpectedly on Thursday. ___ resignation sent shockwaves through the ministry and prompted an emergency cabinet session."
Which word creates the STRONGEST and most formal cohesive link back to the event?', '[{"id":"a","text":"A"},{"id":"b","text":"This"},{"id":"c","text":"Such a"},{"id":"d","text":"Any"}]'::jsonb, 'b', '"This resignation" uses the demonstrative determiner this to point directly back to the specific resignation just mentioned, creating a strong, tight cohesive link. "A resignation" reintroduces the event as if unrelated, breaking the chain. "Such a resignation" generalises to resignations of that kind rather than the specific one. "Any resignation" is indefinite and introduces no reference to the preceding sentence.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8770de69-2e60-5713-8661-15a1dde1f72b', 'b354d6c0-ead3-55f6-9f68-bb5b3e951352', 'anglais-c2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('88465e50-8ba6-52de-9a16-9c684427cb2c', '8770de69-2e60-5713-8661-15a1dde1f72b', 'Which sentence uses a three-part phrasal verb correctly?', '[{"id":"a","text":"I can''t put the noise up with."},{"id":"b","text":"I can''t put up with the noise."},{"id":"c","text":"I can''t put up the noise with."},{"id":"d","text":"I can''t with put up the noise."}]'::jsonb, 'b', 'Three-part phrasal verbs are always inseparable — the particles stay together immediately after the verb: put up with + object. Splitting the particles, as in the other options, is never grammatical.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f423e2be-9de5-5aa8-a892-22cf4b7245cf', '8770de69-2e60-5713-8661-15a1dde1f72b', 'Complete: "She ___ anyone who didn''t go to university." (= regards as inferior)', '[{"id":"a","text":"looks up to"},{"id":"b","text":"looks after"},{"id":"c","text":"looks into"},{"id":"d","text":"looks down on"}]'::jsonb, 'd', 'Look down on means to regard someone as inferior or less important. Look up to means to admire, look after means to care for, and look into means to investigate — three entirely different meanings carried by the particle.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2e2d3db-d495-5050-aa76-8a070a12d1e8', '8770de69-2e60-5713-8661-15a1dde1f72b', 'The phrasal verb in "Turn it down" is separable. Why must the pronoun go between the verb and particle?', '[{"id":"a","text":"Because the verb is irregular."},{"id":"b","text":"Because pronoun objects must go between the verb and particle in separable phrasal verbs."},{"id":"c","text":"Because \"it\" is a reflexive pronoun."},{"id":"d","text":"Because \"turn down\" is an inseparable verb."}]'::jsonb, 'b', 'When the object of a separable phrasal verb is a pronoun, it must sit between the verb and its particle: turn it down, pick it up, hand it in. Saying "Turn down it" is ungrammatical. This rule does not apply to noun objects, which can go either position.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9b92754-dd5d-5ccf-af8b-776e5ba39d1a', '8770de69-2e60-5713-8661-15a1dde1f72b', 'Which single-word formal equivalent matches the phrasal verb "do away with"?', '[{"id":"a","text":"postpone"},{"id":"b","text":"investigate"},{"id":"c","text":"abolish"},{"id":"d","text":"establish"}]'::jsonb, 'c', 'Do away with means to abolish or eliminate something. Postpone matches put off, investigate matches look into, and establish matches set up — each multi-word verb has its own formal Latinate equivalent.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5c4f05bb-4a22-5e8f-a4c3-9f39c2d6ab84', '8770de69-2e60-5713-8661-15a1dde1f72b', 'Complete: "Despite the pressure, he ___ cheating and was never punished." (= escaped without punishment)', '[{"id":"a","text":"got away from"},{"id":"b","text":"got away of"},{"id":"c","text":"got away with"},{"id":"d","text":"got away on"}]'::jsonb, 'c', 'Get away with means to do something wrong and escape punishment. The preposition is fixed: with, not from, of, or on. Choosing the wrong particle produces a different verb or nonsense — the particle is not interchangeable.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d0e4dcc1-f3a7-5a13-9ac7-04c64ffea951', 'b354d6c0-ead3-55f6-9f68-bb5b3e951352', 'anglais-c2', '⭐ Practice: Meaning and Form', 1, 50, 10, 'practice', 'admin', 1)
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
  ('33daaf33-154f-515c-8c54-727203d519d9', 'd0e4dcc1-f3a7-5a13-9ac7-04c64ffea951', 'Complete: "I simply cannot ___ his constant interruptions any longer." (= tolerate)', '[{"id":"a","text":"put up with"},{"id":"b","text":"put up on"},{"id":"c","text":"put out with"},{"id":"d","text":"put off with"}]'::jsonb, 'a', 'Put up with means to tolerate or endure something unpleasant. The three particles are fixed: put + up + with. Changing any particle — on, out, or off — produces either a different verb or a non-existent one.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25767825-0bec-5cee-ba50-7936dacbb9af', 'd0e4dcc1-f3a7-5a13-9ac7-04c64ffea951', 'Complete: "Many activists are calling for the death penalty to be ___." (= abolished)', '[{"id":"a","text":"done out with"},{"id":"b","text":"done away from"},{"id":"c","text":"done away with"},{"id":"d","text":"done up with"}]'::jsonb, 'c', 'Do away with means to abolish or eliminate. It is a fixed three-part verb: done away with in the passive here. The preposition is always with — from, out, or up produce non-existent forms.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('103b91ff-dc32-515b-ab12-dc564765197b', 'd0e4dcc1-f3a7-5a13-9ac7-04c64ffea951', 'Choose the correct word order: the object is a pronoun.', '[{"id":"a","text":"She turned down it."},{"id":"b","text":"She turned it down."},{"id":"c","text":"She it turned down."},{"id":"d","text":"She down turned it."}]'::jsonb, 'b', 'With a separable phrasal verb, a pronoun object must go between the verb and the particle: turned it down. Placing the pronoun after the particle (turned down it) is ungrammatical for pronouns, even though noun objects can go either side.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa82c915-4bad-557b-a3e7-aaa5527f826d', 'd0e4dcc1-f3a7-5a13-9ac7-04c64ffea951', 'Complete: "Young athletes often ___ the champions they watched as children." (= admire and respect)', '[{"id":"a","text":"look down on"},{"id":"b","text":"look up to"},{"id":"c","text":"look after"},{"id":"d","text":"look into"}]'::jsonb, 'b', 'Look up to means to admire and respect someone. Look down on is the opposite — to regard as inferior. Look after means to care for, and look into means to investigate — entirely distinct verbs sharing only the base look.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9c82bb2-aec1-5aef-a423-23e13c72e6bc', 'd0e4dcc1-f3a7-5a13-9ac7-04c64ffea951', 'Which sentence is grammatically correct?', '[{"id":"a","text":"She looked after them carefully."},{"id":"b","text":"She looked them after carefully."},{"id":"c","text":"She looked carefully after them."},{"id":"d","text":"She after looked them carefully."}]'::jsonb, 'a', 'Look after is a prepositional verb and is always inseparable — the object follows the full verb phrase: looked after them. Inserting the object or an adverb between look and after breaks the verb, which is ungrammatical.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4aaa849b-ff9f-5e69-b7e4-98a0bce5e3bf', 'd0e4dcc1-f3a7-5a13-9ac7-04c64ffea951', 'Complete: "We ___ a series of bureaucratic obstacles when trying to register." (= encountered)', '[{"id":"a","text":"came down against"},{"id":"b","text":"came up with"},{"id":"c","text":"came out against"},{"id":"d","text":"came up against"}]'::jsonb, 'd', 'Come up against means to encounter a problem or obstacle. Come up with means to devise or produce an idea — a very different meaning. Come out against means to publicly oppose, and come down against is not a standard verb.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2e177783-fef5-5f52-874c-666ccf4dc83f', 'b354d6c0-ead3-55f6-9f68-bb5b3e951352', 'anglais-c2', '⭐⭐ Review: Register, Nuance, and Near-Synonyms', 2, 75, 15, 'practice', 'admin', 2)
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
  ('6c216c7b-b868-5ab1-b63d-2d889eb4b022', '2e177783-fef5-5f52-874c-666ccf4dc83f', 'Which option is the most appropriate formal written equivalent of "come up with a solution"?', '[{"id":"a","text":"devise a solution"},{"id":"b","text":"look into a solution"},{"id":"c","text":"face up to a solution"},{"id":"d","text":"run out of a solution"}]'::jsonb, 'a', 'Come up with means to produce or devise an idea or plan — its formal equivalent is devise. Look into means to investigate, face up to means to confront honestly, and run out of means to exhaust a supply — none of these match the meaning of come up with.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d83f2f3e-3b3e-54ee-a955-1a34b0c5f9a9', '2e177783-fef5-5f52-874c-666ccf4dc83f', 'Complete: "She has always ___ her older sister, who she considers a role model."', '[{"id":"a","text":"looked down on"},{"id":"b","text":"looked up to"},{"id":"c","text":"looked out for"},{"id":"d","text":"looked back on"}]'::jsonb, 'b', 'Look up to means to admire and respect someone, which fits the context of a role model. Look down on means to regard as inferior (the opposite), look out for means to watch out for or protect, and look back on means to reflect on a past experience.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('332ad87b-cbe1-5dbb-ba72-05399baaf489', '2e177783-fef5-5f52-874c-666ccf4dc83f', 'Complete: "The manager called ___ the meeting because half the team was ill." (= cancelled)', '[{"id":"a","text":"off"},{"id":"b","text":"out"},{"id":"c","text":"for"},{"id":"d","text":"up"}]'::jsonb, 'a', 'Call off means to cancel an event or activity. Call out means to challenge or expose someone. Call for means to demand or require something. Call up means to telephone someone or summon (troops). The particle alone changes the meaning completely.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26abf884-ff38-5a8b-85ce-c4ce2efaf880', '2e177783-fef5-5f52-874c-666ccf4dc83f', 'Find the sentence in which a multi-word verb is used INCORRECTLY.', '[{"id":"a","text":"We ran out of time before we could finish."},{"id":"b","text":"He got away with the fraud for years."},{"id":"c","text":"They came up against significant resistance."},{"id":"d","text":"She faced up the criticism honestly."}]'::jsonb, 'd', 'Face up to is a three-part verb and must include all three particles: faced up to the criticism. Omitting "to" breaks the verb. The other three sentences all use their respective multi-word verbs correctly with the right particles and objects.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('baba29cf-f25a-58a8-84b8-27fa4d985ba4', '2e177783-fef5-5f52-874c-666ccf4dc83f', 'Complete: "It is time the authorities ___ these outdated regulations." (= abolished them, formal context)', '[{"id":"a","text":"put up with"},{"id":"b","text":"got away with"},{"id":"c","text":"did away with"},{"id":"d","text":"went along with"}]'::jsonb, 'c', 'Do away with means to abolish or eliminate, and it sits at the slightly formal end of the register scale — appropriate here. Put up with means to tolerate, get away with means to escape punishment for, and go along with means to agree with or accept — none carry the meaning of abolition.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('636112f2-34db-53e9-a454-317760638983', '2e177783-fef5-5f52-874c-666ccf4dc83f', 'Read: "The new CEO has brought about a remarkable turnaround in the company''s fortunes."
What does "brought about" mean here, and what does the choice of this verb suggest about the change?', '[{"id":"a","text":"It means \"discovered\" and suggests the change was accidental."},{"id":"b","text":"It means \"caused\" and implies the CEO deliberately drove the change."},{"id":"c","text":"It means \"survived\" and implies the change was difficult."},{"id":"d","text":"It means \"delayed\" and suggests the turnaround took longer than expected."}]'::jsonb, 'b', 'Bring about means to cause something to happen, and unlike neutral verbs such as cause, it carries the connotation of deliberate agency — the CEO actively drove the turnaround. This makes the description both factual and complimentary. None of the other readings — discovered, survived, or delayed — match the verb''s meaning.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3457cebf-f5d5-5d08-8b69-3aaf676d6e3e', 'b354d6c0-ead3-55f6-9f68-bb5b3e951352', 'anglais-c2', '⚔️ Chapter Boss ⭐⭐⭐: Advanced Phrasal and Prepositional Verbs', 3, 120, 30, 'boss', 'admin', 3)
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
  ('2528bae6-77e3-549f-a0a5-be3130f4f60e', '3457cebf-f5d5-5d08-8b69-3aaf676d6e3e', 'Find the sentence that contains an error in particle use.', '[{"id":"a","text":"We came up against fierce opposition from local residents."},{"id":"b","text":"She has always looked up to her mentor."},{"id":"c","text":"I cannot go along on their proposal — it makes no sense."},{"id":"d","text":"They ran out of funding halfway through the project."}]'::jsonb, 'c', 'The error is in the third option: the correct verb is go along with (agree/accept), not go along on. The particle is always with. The remaining three sentences all use came up against, looked up to, and ran out of correctly.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9115c3a7-ddcc-5ada-8cd4-25f8ac34e0ce', '3457cebf-f5d5-5d08-8b69-3aaf676d6e3e', 'Complete: "The board voted to ___ the outdated dress code that had been in place for decades."', '[{"id":"a","text":"put up with"},{"id":"b","text":"come up against"},{"id":"c","text":"do away with"},{"id":"d","text":"get on with"}]'::jsonb, 'c', 'Do away with means to abolish or eliminate, which fits voting to remove an outdated rule. Put up with means to tolerate (the opposite intention), come up against means to encounter an obstacle, and get on with means to continue doing something or have a good relationship — none carry the meaning of abolition.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ba22369-e718-5f67-8ca3-0497ec096b5f', '3457cebf-f5d5-5d08-8b69-3aaf676d6e3e', 'Complete: "After years of denial, she finally ___ the fact that she needed help."', '[{"id":"a","text":"faced up to"},{"id":"b","text":"faced up on"},{"id":"c","text":"faced out with"},{"id":"d","text":"faced away from"}]'::jsonb, 'a', 'Face up to means to accept and deal honestly with something difficult. It is a fixed three-part verb: face + up + to + object. Face up on, face out with, and face away from are not real verbs. The particle to is inseparable from the combination.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb14e498-e09f-5083-9088-73ebb396381a', '3457cebf-f5d5-5d08-8b69-3aaf676d6e3e', 'Read: "The contractor had been overcharging clients for years and, remarkably, had ___ it until a whistleblower came forward."
Choose the correct multi-word verb.', '[{"id":"a","text":"put up with"},{"id":"b","text":"got away with"},{"id":"c","text":"gone along with"},{"id":"d","text":"looked down on"}]'::jsonb, 'b', 'Get away with means to do something wrong and escape punishment — exactly what the contractor did until exposure. Put up with means to tolerate (the clients'' perspective, not the contractor''s). Gone along with means agreed to, and looked down on means regarded as inferior — neither fits the idea of escaping undetected.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee020d2a-e8f9-536b-9ebf-04bc9c4a4f15', '3457cebf-f5d5-5d08-8b69-3aaf676d6e3e', 'Which sentence correctly uses a separable phrasal verb with a noun object and moves the object between verb and particle?', '[{"id":"a","text":"She looked the new proposal into."},{"id":"b","text":"They put the meeting off until next week."},{"id":"c","text":"He put up the noise with stoically."},{"id":"d","text":"We came the problem against up."}]'::jsonb, 'b', 'Put off is a separable phrasal verb, and a noun object may go between verb and particle or after the particle: put the meeting off or put off the meeting — both are correct. Look into and put up with are inseparable, so their objects cannot be inserted mid-verb. The fourth option scrambles the particles entirely.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9226a75-73cd-5f02-8e86-469399bc0427', '3457cebf-f5d5-5d08-8b69-3aaf676d6e3e', 'Complete the formal sentence: "The new legislation is designed to ___ the tax loopholes that large corporations have exploited for decades."', '[{"id":"a","text":"run out of"},{"id":"b","text":"get away with"},{"id":"c","text":"do away with"},{"id":"d","text":"put up with"}]'::jsonb, 'c', 'Do away with (abolish/eliminate) is the correct choice — the legislation is designed to eliminate tax loopholes. Run out of means to exhaust a supply, get away with means to escape punishment, and put up with means to tolerate. The slightly formal register of do away with also suits this legal/political context.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5a477296-ac0b-541b-9b2f-db1e540fa4d0', 'b354d6c0-ead3-55f6-9f68-bb5b3e951352', 'anglais-c2', '👑 Elite Challenge ⭐⭐⭐⭐: Advanced Phrasal and Prepositional Verbs', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('a9ecd63b-c47e-571c-bf83-dbd501e99319', '5a477296-ac0b-541b-9b2f-db1e540fa4d0', 'Read: "The committee has spent three years looking ___ the alleged irregularities, yet no conclusions have been published."
Which particle completes the verb, and what does the full phrase mean?', '[{"id":"a","text":"up — to search for the irregularities in a reference source"},{"id":"b","text":"after — to take care of the irregularities"},{"id":"c","text":"into — to investigate the irregularities"},{"id":"d","text":"down on — to regard the irregularities as trivial"}]'::jsonb, 'c', 'Look into means to investigate — the correct particle here is into. Look up means to find something in a reference or to improve. Look after means to care for. Look down on means to regard as inferior. The context (alleged irregularities, no conclusions published) confirms investigation is the intended meaning.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('465652d8-93bf-5b3f-b3bd-c75875548b79', '5a477296-ac0b-541b-9b2f-db1e540fa4d0', 'Complete: "Despite pressure to conform, the artist refused to ___ the critics'' narrow definition of acceptable work."', '[{"id":"a","text":"go along with"},{"id":"b","text":"get away with"},{"id":"c","text":"do away with"},{"id":"d","text":"run out of"}]'::jsonb, 'a', 'Go along with means to agree with or accept something, which fits refusing to conform to critics'' definitions. Get away with means to escape punishment for wrongdoing. Do away with means to abolish. Run out of means to exhaust a supply. The context of refusing to conform to others'' expectations is precisely what go along with captures.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aef02495-c994-524f-90e1-aa2cb314bc03', '5a477296-ac0b-541b-9b2f-db1e540fa4d0', 'Read: "The reforms that were meant to simplify the tax system have, in practice, created a labyrinth that even specialists struggle to navigate. The government has yet to face ___ this inconvenient reality."
Choose the correct particle to complete the three-part verb.', '[{"id":"a","text":"face away from"},{"id":"b","text":"face up to"},{"id":"c","text":"face up on"},{"id":"d","text":"face out with"}]'::jsonb, 'b', 'Face up to means to acknowledge and deal honestly with something difficult — fitting exactly here, where the government avoids confronting the failure of its own reforms. It is a fixed three-part verb: face + up + to. The other options are not real verbs in English.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9343a58a-7ccd-5256-b77f-4a8854856b49', '5a477296-ac0b-541b-9b2f-db1e540fa4d0', 'Which sentence most precisely uses a multi-word verb to convey that an idea was proposed or invented?', '[{"id":"a","text":"The team came up against a new strategy."},{"id":"b","text":"The team came up with a new strategy."},{"id":"c","text":"The team came down with a new strategy."},{"id":"d","text":"The team came out against a new strategy."}]'::jsonb, 'b', 'Come up with means to produce or devise an idea or plan — the only option that means the team invented/proposed the strategy. Come up against means to encounter an obstacle. Come down with means to become ill. Come out against means to publicly oppose something. Single particle changes produce entirely different meanings.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0321dc2f-24eb-525c-913b-ba6c7d67e4f8', '5a477296-ac0b-541b-9b2f-db1e540fa4d0', 'Read: "The young prosecutor had put her reputation on the line to expose the fraud. When the verdict came in, every risk she had taken had paid ___."
Which particle completes the phrasal verb meaning "to yield a return on effort"?', '[{"id":"a","text":"off"},{"id":"b","text":"out"},{"id":"c","text":"up"},{"id":"d","text":"in"}]'::jsonb, 'a', 'Pay off means to yield a positive result after effort or risk — precisely the meaning needed here. Pay out means to disburse money. Pay up means to pay what is owed (often reluctantly). Pay in means to deposit money into an account. The context of risk eventually rewarded confirms that off is the correct particle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a3262a9-a2b3-5615-8f9d-5b0d061ebf5e', '5a477296-ac0b-541b-9b2f-db1e540fa4d0', 'Read: "The opposition has been calling ___ the resignation of the minister for weeks, while the government continues to ___ the mounting criticism."
Choose the pair that completes both gaps correctly.', '[{"id":"a","text":"for … put up with"},{"id":"b","text":"out … get away with"},{"id":"c","text":"off … do away with"},{"id":"d","text":"up … look down on"}]'::jsonb, 'a', 'Call for means to demand or require — the opposition is demanding the resignation. Put up with means to tolerate or endure — the government is enduring the criticism rather than addressing it. Call out means to challenge or expose; call off means to cancel; call up means to telephone or summon. Only the first pairing produces two grammatically and semantically correct sentences.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('29e63fd9-60da-5d42-8a29-aecc2d4263c4', 'b354d6c0-ead3-55f6-9f68-bb5b3e951352', 'anglais-c2', '⭐⭐ Drill: Phrasal and Prepositional Verbs', 2, 75, 15, 'practice', 'admin', 5)
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
  ('94265f0f-f867-5e8b-bf39-7a533184ea74', '29e63fd9-60da-5d42-8a29-aecc2d4263c4', 'Complete: "The launch was a huge success — all 500 tickets sold ___ within an hour."', '[{"id":"a","text":"off"},{"id":"b","text":"out"},{"id":"c","text":"up"},{"id":"d","text":"away"}]'::jsonb, 'b', '"Sell out" means to sell all available stock — the tickets are gone. "Sell off" means to sell something cheaply to get rid of it (a different verb with a different meaning). "Sell up" means to sell an entire business or property. "Sell away" is not a standard phrasal verb. The particle alone determines which of these distinct meanings is expressed.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('23c7f29d-ba01-5ac7-ad7e-10f1a8b78de9', '29e63fd9-60da-5d42-8a29-aecc2d4263c4', 'Complete: "She has always ___ her mentor, a professor who changed the direction of her career."', '[{"id":"a","text":"looked into"},{"id":"b","text":"looked down on"},{"id":"c","text":"looked up to"},{"id":"d","text":"looked back on"}]'::jsonb, 'c', '"Look up to" means to admire and respect someone — which fits the relationship with a mentor who shaped her career. "Look down on" is the opposite (to regard as inferior). "Look into" means to investigate. "Look back on" means to reflect on a past experience. These four verbs share the base look but have entirely different meanings determined by their particles.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14e674ef-9b8a-5122-9c33-148eeccb0823', '29e63fd9-60da-5d42-8a29-aecc2d4263c4', 'Which sentence correctly places a PRONOUN object in a separable phrasal verb?', '[{"id":"a","text":"They called off it at the last minute."},{"id":"b","text":"They called it off at the last minute."},{"id":"c","text":"They it called off at the last minute."},{"id":"d","text":"They called at the last minute it off."}]'::jsonb, 'b', 'When the object of a separable phrasal verb is a pronoun, it must go between the verb and the particle: called it off. Placing the pronoun after the particle (called off it) is ungrammatical for pronouns — unlike noun objects, which can appear either side. The other options scramble the word order incorrectly.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82e68ff2-4160-5483-9b7e-aa64d16bed01', '29e63fd9-60da-5d42-8a29-aecc2d4263c4', 'Find the sentence where the PARTICLE is wrong.', '[{"id":"a","text":"We ran out of supplies before the end of the expedition."},{"id":"b","text":"He came up against strong resistance from the board."},{"id":"c","text":"She faced up to her responsibilities with great maturity."},{"id":"d","text":"They went along on the proposal without reading it carefully."}]'::jsonb, 'd', 'The correct verb is "go along with" (to agree with or accept something) — the preposition is always with, not on. "Went along on" is not a standard multi-word verb. The other three sentences all use their particles correctly: run out of, come up against, and face up to are all fixed combinations.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2b9693c-d6a4-5250-b650-3baf595686aa', '29e63fd9-60da-5d42-8a29-aecc2d4263c4', 'Complete: "The documentary ___ some uncomfortable truths about the industry that executives had long preferred to ignore."', '[{"id":"a","text":"got away with"},{"id":"b","text":"ran out of"},{"id":"c","text":"brought out"},{"id":"d","text":"put up with"}]'::jsonb, 'c', '"Bring out" means to reveal or make visible something that was not obvious before — exactly what a documentary does when it surfaces uncomfortable truths. "Get away with" means to escape punishment. "Run out of" means to exhaust a supply. "Put up with" means to tolerate. Only bring out fits the meaning of surfacing or revealing information.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98440a10-5c79-59e5-ba86-35d1a9f58e0c', '29e63fd9-60da-5d42-8a29-aecc2d4263c4', 'Read: "The inquiry has spent two years looking ___ the alleged irregularities in the procurement process. Despite pressure to close the case, the lead investigator refused to ___ — insisting the full picture had not yet emerged."
Choose the pair that correctly completes both gaps.', '[{"id":"a","text":"after … put up"},{"id":"b","text":"into … back down"},{"id":"c","text":"up … give away"},{"id":"d","text":"down on … call off"}]'::jsonb, 'b', '"Look into" means to investigate — the correct verb for examining alleged irregularities. "Back down" means to withdraw from a position under pressure — exactly what the investigator refused to do. "Look after" means to care for; look up means to search a reference or improve; look down on means to regard as inferior — none match the context of an official inquiry. "Put up" without with is incomplete; "give away" means to reveal or donate; "call off" means to cancel.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f60dc877-5c7e-57df-b5ae-5e5684865293', 'c78f470c-a153-5f88-ac60-8e5face49d02', 'anglais-c2', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('ee2d4d14-4c89-5aa0-b187-18cab9594859', 'f60dc877-5c7e-57df-b5ae-5e5684865293', 'According to the lesson, what does a C2 reader do that goes beyond literal comprehension?', '[{"id":"a","text":"Reads faster than a B2 learner."},{"id":"b","text":"Understands what the writer means, including what was left unsaid."},{"id":"c","text":"Translates difficult vocabulary into their first language."},{"id":"d","text":"Memorises topic sentences from each paragraph."}]'::jsonb, 'b', 'The lesson opens by defining C2 reading as understanding not just what the text says but what the writer means — including implication and deliberate omission. Speed, translation, and memorisation are not what the lesson describes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25bc0f55-d90f-5097-bd51-536413564bb5', 'f60dc877-5c7e-57df-b5ae-5e5684865293', 'The lesson gives the example: "Not the most inspired policy the government has ever produced." What tone technique does this illustrate?', '[{"id":"a","text":"Hyperbole"},{"id":"b","text":"Rhetorical question"},{"id":"c","text":"Understatement / irony"},{"id":"d","text":"Hedging language"}]'::jsonb, 'c', 'Saying something is "not the most inspired" when you mean it is a damning failure is a classic understatement — saying less than is meant. The lesson explicitly labels this ironic deflation. Hyperbole would exaggerate upward, a rhetorical question asks without expecting an answer, and hedging uses words like perhaps or arguably.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('60edd15f-9272-5162-b4c3-fa1fb0c88df3', 'f60dc877-5c7e-57df-b5ae-5e5684865293', 'According to the lesson, where should you look first if you want to find the author''s evaluative conclusion on a point?', '[{"id":"a","text":"The opening sentence of the text."},{"id":"b","text":"Any sentence containing a rhetorical question."},{"id":"c","text":"The last sentence of each paragraph."},{"id":"d","text":"The longest sentence in the passage."}]'::jsonb, 'c', 'The lesson''s Tip states that the last sentence of a paragraph almost always carries the writer''s evaluative conclusion on that point. The opening sentence typically introduces the topic; rhetorical questions signal persuasion but are not always evaluative conclusions; sentence length is irrelevant.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63bc2f6c-4052-52ce-bdc0-315806a023bf', 'f60dc877-5c7e-57df-b5ae-5e5684865293', 'The lesson contrasts "unveiled" and "unleashed" applied to a policy. What is the key difference?', '[{"id":"a","text":"Unveiled is past tense; unleashed is present tense."},{"id":"b","text":"They share a base meaning (revealed publicly) but carry opposite connotations."},{"id":"c","text":"Unveiled is informal; unleashed is formal."},{"id":"d","text":"Unleashed is only used for animals, not policies."}]'::jsonb, 'b', 'The lesson explicitly states both words share a base meaning of "revealed publicly" but unleashed implies the policy is dangerous or aggressive while unveiled is neutral to ceremonial. The distinction is connotative, not grammatical or purely register-based.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('46676238-f003-5909-bde3-6edac424a769', 'f60dc877-5c7e-57df-b5ae-5e5684865293', 'Which of the following is a linguistic marker of a satirical / ironic stance, as listed in the lesson?', '[{"id":"a","text":"Passive constructions and hedging."},{"id":"b","text":"Modal certainty and direct address."},{"id":"c","text":"Hyperbole, incongruity, and mock-formal register."},{"id":"d","text":"Emotive vocabulary and past perfect for lost states."}]'::jsonb, 'c', 'The lesson lists hyperbole, understatement, incongruity, and mock-formal register applied to trivial matters as markers of satirical/ironic writing. Passives and hedging mark an analytical stance, modal certainty and direct address mark persuasive writing, and emotive vocabulary with past perfect marks an elegiac tone.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e0f42567-7913-5631-9df8-f69d56eb8a00', 'c78f470c-a153-5f88-ac60-8e5face49d02', 'anglais-c2', '⭐ Practice: Tone and Vocabulary in Context', 1, 50, 10, 'practice', 'admin', 1)
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
  ('c2bbc210-58ac-5dee-aff9-75757f438921', 'e0f42567-7913-5631-9df8-f69d56eb8a00', 'Read: "The committee''s report was, to put it charitably, uninspired."
What is the writer''s tone?', '[{"id":"a","text":"Critical through understatement"},{"id":"b","text":"Admiring and respectful"},{"id":"c","text":"Neutral and factual"},{"id":"d","text":"Uncertain and hedging"}]'::jsonb, 'a', '"To put it charitably" signals the writer is holding back a harsher verdict, and "uninspired" is a dismissive understatement. The overall effect is critical through deliberate understatement — the writer implies the report is far worse than merely uninspired. The tone is neither neutral, admiring, nor genuinely uncertain.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6836de75-c9e8-57cc-bf3e-8b7f4b7a62da', 'e0f42567-7913-5631-9df8-f69d56eb8a00', 'Read: "Can we truly expect those who created the problem to solve it?"
What is the rhetorical function of this sentence?', '[{"id":"a","text":"It asks for more information."},{"id":"b","text":"It implies the answer is obviously no, to persuade the reader."},{"id":"c","text":"It expresses the writer''s genuine uncertainty."},{"id":"d","text":"It introduces a new topic."}]'::jsonb, 'b', 'This is a rhetorical question — it does not expect an answer. The implied answer (obviously not) is designed to persuade the reader to share the writer''s scepticism. Genuine uncertainty would be expressed through hedging language, not a challenge framed as a question.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d90121fb-41d1-5a54-97fb-cba02cdd3887', 'e0f42567-7913-5631-9df8-f69d56eb8a00', 'Read: "The reforms were quietly shelved."
What does "shelved" imply about the reforms?', '[{"id":"a","text":"They were publicly celebrated."},{"id":"b","text":"They were filed on a bookshelf for future use."},{"id":"c","text":"They were postponed or abandoned without announcement."},{"id":"d","text":"They were implemented ahead of schedule."}]'::jsonb, 'c', '"Shelved" metaphorically means set aside and effectively abandoned — like a book put on a shelf and forgotten. The adverb "quietly" reinforces the idea that this was done without publicity or announcement. The literal meaning (filed on a shelf) is a distractor using the word''s surface form.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e47ef585-fc79-5bd8-bd58-3a2e4f7b2b29', 'e0f42567-7913-5631-9df8-f69d56eb8a00', 'Read: "It could be argued that the policy had unforeseen consequences."
What stance does this sentence signal?', '[{"id":"a","text":"The writer is certain the policy failed."},{"id":"b","text":"The writer is cautious and analytical, not committing fully."},{"id":"c","text":"The writer is enthusiastically supporting the policy."},{"id":"d","text":"The writer is writing satirically."}]'::jsonb, 'b', '"It could be argued" is hedging language — a distancing device that signals a cautious, analytical stance. The writer presents the idea as a possibility, not a certainty. This is characteristic of academic or analytical writing, not satire or enthusiasm.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74030c69-3d35-556b-a6ec-42ed96a9aa67', 'e0f42567-7913-5631-9df8-f69d56eb8a00', 'Read: "The government''s bold new initiative was, within six months, a distant memory."
What does the contrast between "bold new initiative" and "distant memory" achieve?', '[{"id":"a","text":"It shows the government improved over time."},{"id":"b","text":"It creates irony by placing inflated praise next to evidence of rapid failure."},{"id":"c","text":"It is a neutral description of political events."},{"id":"d","text":"It praises the government''s decisiveness."}]'::jsonb, 'b', 'The phrase "bold new initiative" uses the kind of language governments use to announce policies; "distant memory within six months" deflates that claim immediately. The juxtaposition is ironic — the grandiose launch versus the rapid disappearance. This is not neutral description or praise.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e1efb1d-8ab1-5eb4-b1df-382aa8cb985a', 'e0f42567-7913-5631-9df8-f69d56eb8a00', 'Read: "Few issues have generated more heat and less light than this one."
What does the writer mean by "heat" and "light"?', '[{"id":"a","text":"The issue is too complicated to understand."},{"id":"b","text":"The issue is discussed in warm rooms and without electricity."},{"id":"c","text":"The issue is rarely discussed in public."},{"id":"d","text":"The issue provokes strong emotion but produces little genuine understanding."}]'::jsonb, 'd', '"Heat" is a metaphor for passion and angry emotion; "light" is a metaphor for clarity and understanding. The expression "more heat than light" is an established idiom meaning a debate generates strong feelings but no insight. The literal reading (warm rooms, electricity) is a deliberate distractor.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('98b0a678-9435-5453-9117-a39f43e0ff14', 'c78f470c-a153-5f88-ac60-8e5face49d02', 'anglais-c2', '⭐⭐ Review: Inference and Authorial Stance', 2, 75, 15, 'practice', 'admin', 2)
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
  ('420a8fea-0152-5d8e-b37b-4fedca5bb639', '98b0a678-9435-5453-9117-a39f43e0ff14', 'Read: "The novelist does not tell us that the narrator is unreliable. She merely has him contradict himself three times in two pages."
What can we infer about the narrator?', '[{"id":"a","text":"The narrator is honest but forgetful."},{"id":"b","text":"The narrator cannot be fully trusted."},{"id":"c","text":"The novelist made an error in the text."},{"id":"d","text":"The narrator is a reliable guide to events."}]'::jsonb, 'b', 'The passage states that the novelist does not tell us directly — she shows through contradiction. Three self-contradictions in two pages is a classic literary device for establishing an unreliable narrator. The word "merely" signals the novelist''s deliberate craft. Forgetfulness (a), authorial error (c), and reliability (d) are all contradicted by the structural signal of repeated contradiction.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a4a5334-4c33-5fb2-ada4-f18d7d87bdec', '98b0a678-9435-5453-9117-a39f43e0ff14', 'Read: "The study suggests that sleep deprivation may impair cognitive function."
Which of the following is a valid inference from this sentence?', '[{"id":"a","text":"Sleep deprivation definitely causes cognitive impairment."},{"id":"b","text":"The study proves that sleep deprivation has no effect."},{"id":"c","text":"Cognitive function is unaffected by sleep."},{"id":"d","text":"The evidence points towards a possible link, but the writer is not certain."}]'::jsonb, 'd', 'The hedging words "suggests" and "may" signal that the writer presents this as a possibility, not a proven fact. Option (a) removes the hedge and overstates the claim. Options (b) and (c) reverse the meaning entirely. A valid inference must respect the epistemic weight of the language — here, cautious and qualified.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e2582edf-8f7e-5ca4-9bdb-798fb10504ab', '98b0a678-9435-5453-9117-a39f43e0ff14', 'Read: "The architecture of the new civic centre has been described as ''bold''. One might equally call it bewildering."
What is the writer''s attitude toward the building?', '[{"id":"a","text":"Enthusiastic admiration"},{"id":"b","text":"Sceptical and mildly critical, expressed through irony"},{"id":"c","text":"Complete indifference"},{"id":"d","text":"Uncertain — the writer cannot decide"}]'::jsonb, 'b', 'The writer puts "bold" in quotation marks — a signal of distance or scepticism about the label — and immediately counters it with "bewildering", a word with clearly negative connotations. The phrase "one might equally call it" is an ironic understatement. The writer is not indifferent or genuinely undecided; the irony reveals a quietly critical stance.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84318cd4-abce-5579-b2c9-557a040ef12d', '98b0a678-9435-5453-9117-a39f43e0ff14', 'Read: "No sooner had the ink dried on the peace agreement than hostilities resumed."
What does this sentence imply?', '[{"id":"a","text":"The peace agreement was signed very slowly."},{"id":"b","text":"The peace agreement lasted a long time before breaking down."},{"id":"c","text":"The peace agreement failed almost immediately after being signed."},{"id":"d","text":"The hostilities were caused by the ink on the agreement."}]'::jsonb, 'c', '"No sooner … than" is a near-simultaneous sequence structure: the second event follows the first almost instantly. "The ink dried" is a metonym for the agreement being finalised. Together they imply the peace lasted almost no time at all before hostilities resumed — immediate failure. Options (a), (b), and (d) misread the idiom or take it literally.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1c1d8d8-8bef-50cd-a941-d00186e13434', '98b0a678-9435-5453-9117-a39f43e0ff14', 'Read: "The exhibition received rave reviews from critics who had, one suspects, been invited to the opening night."
What is the writer implying about the critics?', '[{"id":"a","text":"The critics are very well-connected in the art world."},{"id":"b","text":"The critics'' positive reviews may be biased because they were wined and dined."},{"id":"c","text":"The opening night was a spectacular event."},{"id":"d","text":"The writer attended the opening night and enjoyed it."}]'::jsonb, 'b', 'The phrase "one suspects" injects the writer''s scepticism through an impersonal construction. The implication is that critics invited to an opening night receive hospitality that may colour their judgment — their "rave reviews" are therefore unreliable. The writer is not celebrating the event (c) or admitting personal attendance (d); rather, they are subtly impugning the critics'' independence.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('32dc311a-c979-551e-b0a6-14eac046b752', '98b0a678-9435-5453-9117-a39f43e0ff14', 'Read: "The minister spoke at length about the importance of transparency. He did not, however, release the figures."
What is the primary rhetorical effect of the second sentence?', '[{"id":"a","text":"It contradicts the minister''s stated values, exposing hypocrisy through juxtaposition."},{"id":"b","text":"It provides additional context about the minister''s speech."},{"id":"c","text":"It praises the minister''s commitment to transparency."},{"id":"d","text":"It explains why the figures were not available."}]'::jsonb, 'a', 'The short second sentence creates a stark contrast — talking about transparency while withholding information is a contradiction. The adversative "however" foregrounds the gap between word and deed. The effect is to expose hypocrisy without stating it explicitly. This is a structural inference: the meaning emerges from the juxtaposition, not from any single word.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7d8fa76e-e8df-5115-82b8-c30dbacf7019', 'c78f470c-a153-5f88-ac60-8e5face49d02', 'anglais-c2', '⚔️ Chapter Boss ⭐⭐⭐: Reading: Critical Inference and Tone', 3, 120, 30, 'boss', 'admin', 3)
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
  ('4e755406-ebb7-5827-8f40-db52c2a9bf69', '7d8fa76e-e8df-5115-82b8-c30dbacf7019', 'Read: "The report runs to four hundred pages. It is thorough, detailed, and — in the estimation of most who will read it — entirely unreadable."
What is the writer''s primary point?', '[{"id":"a","text":"The report''s thoroughness makes it practically useless because almost no one will read it."},{"id":"b","text":"Long reports are better than short ones."},{"id":"c","text":"The writer has read and enjoyed the report."},{"id":"d","text":"Reports should be four hundred pages long."}]'::jsonb, 'a', 'The writer lists apparent virtues (thorough, detailed) only to undercut them with "entirely unreadable" — a classic ironic structure. The phrase "most who will read it" ironically implies very few people will read it at all. The writer''s point is that length and thoroughness can be self-defeating. Options (a), (c), and (d) misread the ironic tone.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2351c6cd-96c4-51d3-8004-352d4c8417fd', '7d8fa76e-e8df-5115-82b8-c30dbacf7019', 'Read: "It is a truth universally acknowledged that a powerful institution in possession of a scandal must be in want of a cover-up."
This sentence echoes the opening of Jane Austen''s Pride and Prejudice. What rhetorical effect does this create?', '[{"id":"a","text":"It pays homage to Austen and is entirely serious."},{"id":"b","text":"It uses ironic allusion to mock the predictable behaviour of powerful institutions."},{"id":"c","text":"It argues that powerful institutions are honest."},{"id":"d","text":"It is a direct quotation from Austen with no modification."}]'::jsonb, 'b', 'Austen''s original sentence mocks a social truth through irony. Here, the writer adapts the structure to suggest that cover-ups by powerful institutions are equally predictable and absurd — using literary allusion to add satirical weight. The sentence is clearly a modification, not a direct quote, and the tone is ironic, not earnest admiration.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f6ff546c-ff7b-5484-a9a1-a39f4b517ede', '7d8fa76e-e8df-5115-82b8-c30dbacf7019', 'Read: "The villagers had lived through three floods, two droughts, and a decade of broken promises from officials who arrived in suits, made speeches, and left in helicopters."
What does the detail about suits and helicopters contribute?', '[{"id":"a","text":"It shows the officials were wealthy and efficient."},{"id":"b","text":"It emphasises the physical distance between officials and the community, reinforcing the theme of broken promises."},{"id":"c","text":"It is an irrelevant descriptive detail."},{"id":"d","text":"It suggests the officials were honest but busy."}]'::jsonb, 'b', 'The suits and helicopters are not decorative — they are carefully chosen details that signal class, power, and literal physical separation from the villagers'' reality. They reinforce the irony that officials who promise help depart by the most distancing means possible. In skilled prose, no detail is irrelevant; the concrete image carries the thematic point.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9397355a-2c4e-5c44-9a5b-3625c7fd3d8f', '7d8fa76e-e8df-5115-82b8-c30dbacf7019', 'Read: "One hesitates to call the policy a failure. One hesitates, but only briefly."
What is the effect of the second sentence?', '[{"id":"a","text":"It shows the writer is genuinely uncertain."},{"id":"b","text":"It softens the writer''s verdict on the policy."},{"id":"c","text":"It introduces a new argument about the policy."},{"id":"d","text":"It withdraws the hesitation and confirms the verdict is failure, with comic timing."}]'::jsonb, 'd', 'The first sentence performs false hesitation; the second collapses it in three words ("but only briefly"). The structure is a comic rhetorical delay — the writer pretends to hold back, then delivers the damning verdict anyway. The effect is both humorous and emphatic. Genuine uncertainty would not be resolved so decisively.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8b96bc5-f670-5352-8207-19b89b9165be', '7d8fa76e-e8df-5115-82b8-c30dbacf7019', 'Read: "Her prose is luminous. Each sentence arrives like a small gift — unexpected, precisely weighted, and gone too soon."
What is the writer''s attitude toward the author being discussed?', '[{"id":"a","text":"Critical — the writer finds the prose superficial."},{"id":"b","text":"Ambivalent — the writer cannot decide whether to praise or criticise."},{"id":"c","text":"Warmly admiring, using carefully chosen imagery to convey the reading experience."},{"id":"d","text":"Ironic — the praise is actually a disguised attack."}]'::jsonb, 'c', '"Luminous", "small gift", "precisely weighted" are all unambiguously positive. The simile of sentences as gifts conveys delight and surprise. There is no ironic signal — no understatement, no incongruity, no mock-formal register. This is sincere, controlled praise. The writing is lyrical, not detached or ironic.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07add594-472c-5162-8c55-8af92f0341a2', '7d8fa76e-e8df-5115-82b8-c30dbacf7019', 'Read: "For decades the industry insisted that the evidence was inconclusive. It was not inconclusive. It was damning."
Which technique gives the final sentence its force?', '[{"id":"a","text":"A long subordinate clause building to a climax"},{"id":"b","text":"Hedging language to soften the accusation"},{"id":"c","text":"Deliberate repetition of \"inconclusive\" immediately followed by a short, blunt contradiction"},{"id":"d","text":"A rhetorical question implying the evidence was weak"}]'::jsonb, 'c', 'The writer repeats the industry''s own word ("inconclusive") then immediately negates it and replaces it with a single devastating adjective ("damning") in a very short sentence. The brevity after the longer denial creates a punching rhythm. There is no hedging, no subordination, and no rhetorical question — the force comes from blunt, short contradiction.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bcfc0582-f595-510f-b3b2-01e5f0d95de0', 'c78f470c-a153-5f88-ac60-8e5face49d02', 'anglais-c2', '👑 Elite Challenge ⭐⭐⭐⭐: Reading: Critical Inference and Tone', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('fe3959ee-ff17-5603-afc3-e11c17a158b4', 'bcfc0582-f595-510f-b3b2-01e5f0d95de0', 'Read: "The historian''s account is meticulous, exhaustively sourced, and almost entirely wrong."
What is the primary rhetorical effect of this sentence?', '[{"id":"a","text":"It praises the historian''s diligence and accuracy."},{"id":"b","text":"It offers a balanced view of the historian''s strengths and weaknesses."},{"id":"c","text":"It uses a delayed reversal to make a damning critical verdict more emphatic."},{"id":"d","text":"It hedges the writer''s opinion to avoid controversy."}]'::jsonb, 'c', 'The sentence accumulates praise (meticulous, exhaustively sourced) then destroys it in four words ("almost entirely wrong"). This delayed reversal is a rhetorical device that makes the final verdict more emphatic by contrast — the higher the praise, the harder the fall. It is not balanced (balance would qualify rather than negate) and it does not hedge (the verdict is blunt).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1faf4cc4-dc84-5c0c-bd88-11d3378e8bba', 'bcfc0582-f595-510f-b3b2-01e5f0d95de0', 'Read: "Successive governments have promised investment in infrastructure. Successive governments have broken that promise. The roads speak for themselves."
What does "the roads speak for themselves" imply?', '[{"id":"a","text":"The roads are in excellent condition and prove the promises were kept."},{"id":"b","text":"The physical state of the roads provides visible evidence that the promises were broken."},{"id":"c","text":"The writer does not know the condition of the roads."},{"id":"d","text":"The roads have been the subject of speeches by politicians."}]'::jsonb, 'b', '"Speak for themselves" means the evidence is so obvious it needs no further comment. Given the preceding pattern of broken promises, the implication is that the roads are in poor condition — visible proof of repeated failure. This is a pragmatic inference: the writer invites the reader to draw the conclusion rather than stating it. Options (a) and (c) misread the ironic structure; (d) takes the metaphor literally.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8909c67a-a3bb-5cd0-804d-716fd32a1204', 'bcfc0582-f595-510f-b3b2-01e5f0d95de0', 'Read: "Dr Laine writes with the authority of someone who has spent forty years in the field and the clarity of someone who has spent forty years explaining it to people who have not."
What quality of Dr Laine''s writing does this sentence praise?', '[{"id":"a","text":"The rare combination of deep expertise and genuine accessibility"},{"id":"b","text":"Speed and productivity"},{"id":"c","text":"A tendency to oversimplify complex ideas"},{"id":"d","text":"An academic style that only specialists can appreciate"}]'::jsonb, 'a', 'The parallel structure ("authority of someone who… clarity of someone who…") explicitly links two qualities that are often in tension: expert authority and the ability to explain clearly to non-experts. The sentence praises the combination of both. Oversimplification (c) would be a criticism; inaccessibility (d) is the opposite of what is stated; speed (a) is not mentioned.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e525b039-6daa-50d1-befd-e807f1e4ca0f', 'bcfc0582-f595-510f-b3b2-01e5f0d95de0', 'Read: "The charity''s annual report opens with a photograph of smiling children and closes with a page of financial disclaimers printed in a font size that rewards only the most determined reader."
What is the writer implying about the charity?', '[{"id":"a","text":"The charity is transparent and well-run."},{"id":"b","text":"The charity uses emotional imagery to distract from financial information it does not want scrutinised."},{"id":"c","text":"The charity''s designers chose a small font for aesthetic reasons."},{"id":"d","text":"The charity''s financial position is excellent and requires no scrutiny."}]'::jsonb, 'b', 'The contrast between the emotive opening (smiling children) and the near-invisible financial disclaimers is not neutral description — the phrase "rewards only the most determined reader" is ironic, implying the small print is deliberately discouraging. The implication is that the emotional imagery is a distraction from financial information the charity prefers not to be read. Options (a), (c), and (d) all ignore the critical irony.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55ce69a4-2667-520a-a17b-54c75d1ed11a', 'bcfc0582-f595-510f-b3b2-01e5f0d95de0', 'Read: "The novel''s ending has been called ambiguous. It is, rather, perfectly clear — to anyone willing to sit with discomfort long enough to accept what the author is actually saying."
What does the writer imply about readers who find the ending ambiguous?', '[{"id":"a","text":"They are correct — the ending is genuinely unclear."},{"id":"b","text":"The writer agrees that the author''s meaning is impossible to determine."},{"id":"c","text":"They are more sophisticated readers than those who find it clear."},{"id":"d","text":"They are unwilling to confront the difficult truth the ending contains."}]'::jsonb, 'd', 'The phrase "to anyone willing to sit with discomfort" implies that those who call the ending ambiguous are avoiding discomfort — they resist accepting the author''s meaning because it is unsettling. The writer is politely but firmly accusing such readers of motivated misreading. This is a pragmatic inference: the writer does not state this directly but makes it clear through the conditional phrasing.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8f54f953-8e86-5a74-bdc2-a18d7f7109b7', 'bcfc0582-f595-510f-b3b2-01e5f0d95de0', 'Read: "In the third act, the playwright gives the antagonist the most eloquent speech in the play. Every argument he makes is compelling. Every argument he makes is wrong."
What is the playwright''s likely purpose in giving the antagonist such an eloquent speech?', '[{"id":"a","text":"To suggest the antagonist is the true hero of the play."},{"id":"b","text":"To confuse the audience about the play''s moral position."},{"id":"c","text":"To dramatise how dangerous and persuasive wrong ideas can be when well-argued."},{"id":"d","text":"To demonstrate that the playwright agrees with the antagonist."}]'::jsonb, 'c', 'The juxtaposition of "compelling" and "wrong" in identical sentence structures is the key. The playwright is not endorsing the antagonist or creating confusion for its own sake — the structural repetition forces the audience to hold both truths simultaneously: the argument is persuasive AND it is wrong. This is a sophisticated dramatic technique for exploring how ideas seduce even when they are false. Options (a) and (d) misread the critical framing; (b) mistakes deliberate complexity for confusion.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e62a72ce-6504-599b-aaaf-e88fa7a6e052', 'c78f470c-a153-5f88-ac60-8e5face49d02', 'anglais-c2', '⭐⭐ Drill: Reading: Critical Inference and Tone', 2, 75, 15, 'practice', 'admin', 5)
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
  ('79b6380d-5e88-5d89-b30c-c50b6cf1c636', 'e62a72ce-6504-599b-aaaf-e88fa7a6e052', 'Read: "The review panel''s conclusions were, to say the least, unexpected."
What is the writer''s tone?', '[{"id":"a","text":"Critical through understatement"},{"id":"b","text":"Neutral and factual"},{"id":"c","text":"Enthusiastic and admiring"},{"id":"d","text":"Genuinely uncertain"}]'::jsonb, 'a', '"To say the least" is a classic understatement marker — it signals the writer is holding back a stronger reaction. Calling conclusions "unexpected" with this qualifier implies they were, in the writer''s view, far more than merely surprising — possibly shocking or unacceptable. The tone is quietly critical, not neutral, admiring, or uncertain.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f8f7fb4-6756-57da-a2aa-13f477570062', 'e62a72ce-6504-599b-aaaf-e88fa7a6e052', 'Read: "The data suggests that early intervention may reduce long-term costs."
Which of the following is the most accurate inference from this sentence?', '[{"id":"a","text":"Early intervention definitely reduces long-term costs."},{"id":"b","text":"The evidence points to a possible link, but the claim is presented cautiously."},{"id":"c","text":"The writer believes early intervention has no effect."},{"id":"d","text":"Long-term costs are guaranteed to fall if intervention happens early."}]'::jsonb, 'b', '"Suggests" and "may" are both hedging signals — the writer presents this as a possibility indicated by evidence, not a certainty. Removing the hedge (as in the first and last options) overstates the claim. The third option reverses the meaning. A valid inference must preserve the epistemic weight of the language — here, cautious and qualified.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4d43369-7987-50f6-b7dd-b2edbbdd2fdb', 'e62a72ce-6504-599b-aaaf-e88fa7a6e052', 'Read: "The government unveiled its long-awaited housing strategy on Monday. By Wednesday, three of its key architects had resigned."
What does the juxtaposition of these two sentences imply?', '[{"id":"a","text":"The housing strategy was very popular among its designers."},{"id":"b","text":"The resignations were unrelated to the housing strategy."},{"id":"c","text":"The writer is providing neutral background information."},{"id":"d","text":"The resignations suggest serious internal disagreement with the strategy shortly after its launch."}]'::jsonb, 'd', 'Placing the two sentences in immediate sequence is not neutral — the tight timeline (Monday to Wednesday) invites the inference that the resignations were a response to the strategy. No causal link is stated, but the juxtaposition strongly implies it. Good critical readers recognise that what is not said explicitly can be the most important signal of all.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1eecc468-154f-55b8-a2c5-a116625a03b6', 'e62a72ce-6504-599b-aaaf-e88fa7a6e052', 'Read: "The charity''s founder described the audit findings as ''a few minor accounting questions''. The regulator described them as evidence of systematic fraud."
What rhetorical effect does this contrast achieve?', '[{"id":"a","text":"It shows both parties agree on the basic facts but use different terminology."},{"id":"b","text":"It uses direct quotation to expose the gap between the founder''s self-serving framing and the regulator''s formal verdict."},{"id":"c","text":"It praises the founder for acknowledging the problem."},{"id":"d","text":"It suggests the regulator was being unfair."}]'::jsonb, 'b', 'By placing the two descriptions side by side with no editorial comment, the writer allows the contrast to speak for itself. "A few minor accounting questions" (minimising, vague) versus "systematic fraud" (precise, damning) exposes the founder''s framing as evasive. The use of direct quotation for both creates irony through structural juxtaposition rather than overt criticism.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c562906-5bdd-55bb-9540-5347f017bf14', 'e62a72ce-6504-599b-aaaf-e88fa7a6e052', 'Read: "The minister spoke passionately about the need for accountability in public life.
He declined, however, to answer any questions about his own expenses.
His chief of staff described the session as ''very productive''."', '[{"id":"a","text":"The session was genuinely productive and the minister engaged fully."},{"id":"b","text":"The writer admires the minister''s passion on the issue of accountability."},{"id":"c","text":"The passage uses irony and juxtaposition to expose hypocrisy, with the chief of staff''s quotation as the final ironic twist."},{"id":"d","text":"The passage presents these three facts without any implied judgment."}]'::jsonb, 'c', 'The structure is a three-step ironic build: speaking about accountability, refusing to be accountable, then having the session called "productive". Each detail undermines the previous claim. The final quotation from the chief of staff is a mock-endorsement — placing it last gives it maximum ironic weight. No single word is explicitly critical, yet the passage is devastating. This is the hallmark of sophisticated ironic writing.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('97b52bb6-bc06-58e4-92c5-b36a91ef1e03', 'e62a72ce-6504-599b-aaaf-e88fa7a6e052', 'Read: "For thirty years, critics called the architect''s vision impractical. The building has now stood for a decade, drawing architects from across the world who come to study what they once dismissed."
What does the final clause imply about the critics?', '[{"id":"a","text":"The critics were right — the building is still controversial."},{"id":"b","text":"The critics have been vindicated by the building''s eventual demolition."},{"id":"c","text":"The architects who once dismissed the vision now recognise it as exemplary, implying the original criticism was wrong."},{"id":"d","text":"The writer provides no judgment on whether the critics were right or wrong."}]'::jsonb, 'c', 'The phrase "what they once dismissed" is the key: the same architects who called the vision impractical now travel to study it. The implication is that their dismissal was an error of judgment, not presented directly but made unmistakable through the contrast between past dismissal and present pilgrimage. This is an inferential reading — the writer never states "the critics were wrong" but structures the passage so the conclusion is inescapable.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

