-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: iq-training-en (Muscle ton cerveau — Entraînement QI (EN))
-- Regenerate with: npm run content:build
-- Source of truth: content/iq-training-en/
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
  ('iq-training-en', 'Muscle ton cerveau — Entraînement QI (EN)', 'Pure logic visual challenges: study the figure, deduce the hidden rule, pick the right answer — no memory required, just reasoning.', 'Logique', 'subject-math', 'Brain', 61, 'en', false, 'muscle-cerveau', NULL)
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
      AND e.subject_id = 'iq-training-en'
      AND e.source = 'admin'
      AND q.id NOT IN ('60e0097f-a827-54ca-98f8-c25b7646c324', '27716316-2040-5e5e-bdf9-c54fc593049d', 'a274135c-f5be-580b-9bae-0a6e1ea48fd0', '80ec3685-1a19-58db-9992-9a1332e02369', 'a3d8e4bc-44ba-5731-b174-1806064a9ee6', '89a8fb5d-47c7-5a27-848a-27236fd966fd', 'a1a10d69-723c-5c2d-afc7-c90d678c1f8b', 'ed796a36-7a1b-5750-9854-d81c5ae65cf4', '7720263e-42e3-5b91-ac42-c3224d5bb1a7', '94f42900-ae91-57a0-a070-192e5d21de60', '38fc645d-1706-548f-bffa-753ab0a5ba02', '1f0d3bd1-525d-580b-9c1f-33665ff7d4c9', '2be56469-d9ff-500c-9333-cfbf3395a9da', '36638c85-2eaa-53e1-9410-5399b64698b3', '76c6b95a-aa80-5a84-b34e-c70faa9e5a2b', '30676a37-6ac0-5e84-a03a-a8c7ae30c692', '170dee6f-9a12-5cdf-8d42-765487fb6521', 'c5706efe-9630-5f64-96c2-0180c05815ff', '9253b4b1-3906-562b-bfac-7a090ff13bb2', 'd586bdb5-5ba6-56a1-87c9-54457e7506fc', '462a8b6a-2503-5e24-928a-b5e687d98b64', 'd1a2b8f6-6873-5e5b-ba82-e7fbe9d79531', 'ce63cc53-033b-51c5-8fee-cc8c6e98ece2', 'cba831b6-53ba-5ef1-9cd7-f83c140ae0e4', 'f5b1b58f-3ae0-55b9-973e-419a6136908a', 'b6605926-f8c2-518b-9bc7-0d9038032f0e', '7785616f-d23a-5205-b511-4f0749344a4a', '890dddf9-c139-52d8-ac51-ecc91251d728', 'eedb2ad8-a389-57d2-900f-0ec30c232b7f', '99c669a0-028c-5e70-bac8-4bc254aef8d9', 'ae060409-d887-50cc-9d24-383480387446', 'f7264774-f41c-542f-907b-6231d5d2094c', '68e98f17-7d5b-57bd-aef4-bd68b3942047', '646005a3-9735-5a52-afc9-da44a988778e', '7acd16de-a6d4-5e29-bf5e-f9af17059164', '58d24dc7-833e-5b68-a583-57c6ad536f01', 'a131a889-f405-5f95-b470-5dc58e3003d6', '5720d1a3-b6ae-5b97-b2bb-04ba7d770c6e', '342023d7-1a0a-5993-9477-b63917a61dbd', '9e08002b-407c-5994-9cc1-ec2f68d12bc8', 'a3a2d82f-5c91-549b-966d-6de1f970a0f8', '574fe6c0-baf1-52cd-b485-eda624bee5fd', 'fc4968de-b5be-53e3-a01b-317f6e1c7b36', 'd32b50be-a4d1-5ad1-990c-9a40bef48785', 'b057b408-8e39-509a-b3e9-edc2976fc177', '5daf7517-dc06-5880-8672-6576b1723bb7', 'c7acf680-2963-5ff7-a9c0-857a4e2fac72', 'e0b9f1e4-40d8-5b2e-a872-1df54ca44908', '2a80a236-1b3d-5cd5-9016-8b09f9319806', '10668bc9-c6ca-5507-9835-81c6f9a6468b', 'd6fd2f0e-40b4-5432-bab3-4c200fb648e5', 'ec59bb07-440b-5917-945d-789568f909d1', '2e4e1e2b-de40-5e2e-af46-4bff1183fe33', 'c416bc25-368a-541d-93aa-0220328e1bab', '903e2aa2-b0de-5e6f-98cf-b23c93b0da29', 'c8128da2-22b8-576a-a60a-eaf287deb214', 'da298d98-dc7b-5f31-b346-7c3d56a45260', '2b429e76-e8ce-5215-8555-fc26060f06c8', '1aef79c5-a89d-52de-b91c-d3372b8b6d4d', 'ae07ccc3-a102-5d81-91e9-1f288a0421fa', '014178ad-7ab2-594b-b73c-da764171c196', '29682f91-ac06-5c3a-9b08-fc1617a8ea55', '076f87da-4ecf-534a-b7ff-50f5f356e342', '9bf5632b-4aad-549b-80d6-e7f31dcdb017', '3294d6c6-b239-5685-9209-cafa32ba80a2', '34d75a7d-c24d-5052-a933-712a1c89998b', '6efadc7d-c83d-5c69-be20-40c289168371', 'b11302e0-2939-5b38-a29f-7c2d1ed38705', '0cce32a0-d076-5bb8-9e9b-513b0603cbef', 'bccd5786-405b-51d6-ac4b-816f13dc3219', '7bd6bb4f-3399-5b94-9a9b-e3c72723fc4e', 'ec5c7302-4606-54ef-85e2-e52d6f3aab56', '2428aa0b-63bb-5b02-adda-d93b9f5f7e93', '078d8810-4aaa-5515-8491-edfab9b4a34d', 'f300b72b-85ad-5e7c-aa4c-fa0b85252688', '7d64b123-b606-5758-90f7-09272b9e651f', '9009771f-0f4f-552d-85b8-1a62d64e1f89', '608950bb-aa4a-52a4-9b3e-99f392d0749f', 'a4d687f5-413f-5381-bb4c-d3b41fae0ef2', '83dd431e-f606-599d-badd-0da161f06ec5', '65d61b15-55cb-5a90-87a3-ed327d3324ed', '124375bd-9245-55ad-b9b6-1a13ae118f39', '2b9a306e-aabb-5266-b40d-f5cc54688c92', '0298a5ce-7e75-5a06-aea5-43c5e3a14230', 'c9915537-abe5-536a-a440-0c0762862698', 'c4d12c09-ba09-5c7b-aafb-48a6d978ee77', '17fb3f32-7853-5fbf-b7ee-2c8c5c9f5abe', '6c13fefb-1f60-55dc-8c09-3bb70590571d', '097e8287-73a6-5e98-9311-cfc0185e2c7f', '3c02b731-962b-5fd9-85eb-81e154adfbff', 'd1085c93-c5a0-5a29-b5db-37013439b6f3', 'b385a869-350c-5106-b96e-968ecf5e4638', 'df6e6925-d3d6-54c0-a986-0e1d0f2680a6', '006c9193-b3ee-54f5-80fb-ebdc7c87b3b1', '8e34b788-1c77-5935-8b75-e806d1002658', '440a6606-f1fa-50ef-a833-6cc0962715fb', '9fd4ba37-1ee3-5237-9f35-d55593bdee58', '3b5da457-44b8-5f04-90cc-4d8c205803cd', 'cbd0f7f0-6b22-53ea-a174-d395cc418a58', 'e4baeb15-b2e6-5a37-91c3-a26521dcdaec', 'a6224e0c-1586-5af9-8104-0170ef6fd37f', '7a681bb1-c4ac-5974-8819-79108bca99f2', '3f9ec5c9-52b1-5577-832d-612b9b3ac3cb', 'c08479dd-81ae-539d-875b-3f09d4eeb632', 'd0c19b70-0e6f-5269-8c9b-623132637b0a', 'a16ba1f0-85ba-5d15-8b0a-2f9b7661ce87', '8209e1e0-eef8-5492-9de0-7b721a87d969', '36b51b2d-a988-5d10-842f-b7d4c1c99ba8', 'fcfac15b-55db-5f5b-8a6f-62195a2e5db9', 'e8fae595-3e71-514b-b448-e6437b6901ac', '901fa4f8-bfd9-5b63-82ca-c88374103f48', '77f26d0b-6bb3-5ade-b17e-658e077953d1', '31d26bdd-de43-58de-97ba-84129f881e8c', '23b72ea2-f7a7-5160-9616-28e916d1d57b', '6823e8af-4184-5799-a5e9-8da06cb6527b');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'iq-training-en' AND source = 'admin' AND id NOT IN ('d4049ce4-1dc7-5c74-b4bc-4a5332e32aa5', 'e7cedea3-a965-5844-8f7e-3afc3977ce78', 'f0d74904-26ba-5524-a24f-5e2623a2e36e', '99fb5800-ca71-5740-954b-f2670fef97ab', 'a6b0ba25-8e64-5d4e-b198-f6f0cd4a33da', 'cde25f80-7194-5355-93e4-161a69223d28', '661d5164-6f02-5ef0-b676-cf1083ec6a98', '001ec5da-e35f-5604-b687-d91df3de8f37', '914c2043-32fe-5bfa-8a7d-ee2a1192f5e6', '70ba8162-4ecf-57ef-8f32-f6e5f0896d11', 'e0d03861-160e-583e-8835-efa297fd5c14', 'c6f3790b-15a6-5738-85c2-ed250ab40df2', '9e8580b3-7937-5964-a676-ea57ff9882f2', 'd749dba2-ccf5-543b-8338-ae70d12bb246', 'df58fdd5-2325-512c-9b87-bd7cdb9f163f', 'f1d58351-8996-50f4-bd20-a7ac1d8d4989', 'b068f3db-2f8d-554e-86c5-d88b634c7066', '8cf858c9-d154-5719-8163-dbbe09b43a12', '23067a4a-b07d-57db-9f44-204d5164995d', 'b65aaeff-d522-52c0-a8be-3473d5da6b34');
DELETE FROM public.questions WHERE exercise_id IN ('d4049ce4-1dc7-5c74-b4bc-4a5332e32aa5', 'e7cedea3-a965-5844-8f7e-3afc3977ce78', 'f0d74904-26ba-5524-a24f-5e2623a2e36e', '99fb5800-ca71-5740-954b-f2670fef97ab', 'a6b0ba25-8e64-5d4e-b198-f6f0cd4a33da', 'cde25f80-7194-5355-93e4-161a69223d28', '661d5164-6f02-5ef0-b676-cf1083ec6a98', '001ec5da-e35f-5604-b687-d91df3de8f37', '914c2043-32fe-5bfa-8a7d-ee2a1192f5e6', '70ba8162-4ecf-57ef-8f32-f6e5f0896d11', 'e0d03861-160e-583e-8835-efa297fd5c14', 'c6f3790b-15a6-5738-85c2-ed250ab40df2', '9e8580b3-7937-5964-a676-ea57ff9882f2', 'd749dba2-ccf5-543b-8338-ae70d12bb246', 'df58fdd5-2325-512c-9b87-bd7cdb9f163f', 'f1d58351-8996-50f4-bd20-a7ac1d8d4989', 'b068f3db-2f8d-554e-86c5-d88b634c7066', '8cf858c9-d154-5719-8163-dbbe09b43a12', '23067a4a-b07d-57db-9f44-204d5164995d', 'b65aaeff-d522-52c0-a8be-3473d5da6b34') AND id NOT IN ('60e0097f-a827-54ca-98f8-c25b7646c324', '27716316-2040-5e5e-bdf9-c54fc593049d', 'a274135c-f5be-580b-9bae-0a6e1ea48fd0', '80ec3685-1a19-58db-9992-9a1332e02369', 'a3d8e4bc-44ba-5731-b174-1806064a9ee6', '89a8fb5d-47c7-5a27-848a-27236fd966fd', 'a1a10d69-723c-5c2d-afc7-c90d678c1f8b', 'ed796a36-7a1b-5750-9854-d81c5ae65cf4', '7720263e-42e3-5b91-ac42-c3224d5bb1a7', '94f42900-ae91-57a0-a070-192e5d21de60', '38fc645d-1706-548f-bffa-753ab0a5ba02', '1f0d3bd1-525d-580b-9c1f-33665ff7d4c9', '2be56469-d9ff-500c-9333-cfbf3395a9da', '36638c85-2eaa-53e1-9410-5399b64698b3', '76c6b95a-aa80-5a84-b34e-c70faa9e5a2b', '30676a37-6ac0-5e84-a03a-a8c7ae30c692', '170dee6f-9a12-5cdf-8d42-765487fb6521', 'c5706efe-9630-5f64-96c2-0180c05815ff', '9253b4b1-3906-562b-bfac-7a090ff13bb2', 'd586bdb5-5ba6-56a1-87c9-54457e7506fc', '462a8b6a-2503-5e24-928a-b5e687d98b64', 'd1a2b8f6-6873-5e5b-ba82-e7fbe9d79531', 'ce63cc53-033b-51c5-8fee-cc8c6e98ece2', 'cba831b6-53ba-5ef1-9cd7-f83c140ae0e4', 'f5b1b58f-3ae0-55b9-973e-419a6136908a', 'b6605926-f8c2-518b-9bc7-0d9038032f0e', '7785616f-d23a-5205-b511-4f0749344a4a', '890dddf9-c139-52d8-ac51-ecc91251d728', 'eedb2ad8-a389-57d2-900f-0ec30c232b7f', '99c669a0-028c-5e70-bac8-4bc254aef8d9', 'ae060409-d887-50cc-9d24-383480387446', 'f7264774-f41c-542f-907b-6231d5d2094c', '68e98f17-7d5b-57bd-aef4-bd68b3942047', '646005a3-9735-5a52-afc9-da44a988778e', '7acd16de-a6d4-5e29-bf5e-f9af17059164', '58d24dc7-833e-5b68-a583-57c6ad536f01', 'a131a889-f405-5f95-b470-5dc58e3003d6', '5720d1a3-b6ae-5b97-b2bb-04ba7d770c6e', '342023d7-1a0a-5993-9477-b63917a61dbd', '9e08002b-407c-5994-9cc1-ec2f68d12bc8', 'a3a2d82f-5c91-549b-966d-6de1f970a0f8', '574fe6c0-baf1-52cd-b485-eda624bee5fd', 'fc4968de-b5be-53e3-a01b-317f6e1c7b36', 'd32b50be-a4d1-5ad1-990c-9a40bef48785', 'b057b408-8e39-509a-b3e9-edc2976fc177', '5daf7517-dc06-5880-8672-6576b1723bb7', 'c7acf680-2963-5ff7-a9c0-857a4e2fac72', 'e0b9f1e4-40d8-5b2e-a872-1df54ca44908', '2a80a236-1b3d-5cd5-9016-8b09f9319806', '10668bc9-c6ca-5507-9835-81c6f9a6468b', 'd6fd2f0e-40b4-5432-bab3-4c200fb648e5', 'ec59bb07-440b-5917-945d-789568f909d1', '2e4e1e2b-de40-5e2e-af46-4bff1183fe33', 'c416bc25-368a-541d-93aa-0220328e1bab', '903e2aa2-b0de-5e6f-98cf-b23c93b0da29', 'c8128da2-22b8-576a-a60a-eaf287deb214', 'da298d98-dc7b-5f31-b346-7c3d56a45260', '2b429e76-e8ce-5215-8555-fc26060f06c8', '1aef79c5-a89d-52de-b91c-d3372b8b6d4d', 'ae07ccc3-a102-5d81-91e9-1f288a0421fa', '014178ad-7ab2-594b-b73c-da764171c196', '29682f91-ac06-5c3a-9b08-fc1617a8ea55', '076f87da-4ecf-534a-b7ff-50f5f356e342', '9bf5632b-4aad-549b-80d6-e7f31dcdb017', '3294d6c6-b239-5685-9209-cafa32ba80a2', '34d75a7d-c24d-5052-a933-712a1c89998b', '6efadc7d-c83d-5c69-be20-40c289168371', 'b11302e0-2939-5b38-a29f-7c2d1ed38705', '0cce32a0-d076-5bb8-9e9b-513b0603cbef', 'bccd5786-405b-51d6-ac4b-816f13dc3219', '7bd6bb4f-3399-5b94-9a9b-e3c72723fc4e', 'ec5c7302-4606-54ef-85e2-e52d6f3aab56', '2428aa0b-63bb-5b02-adda-d93b9f5f7e93', '078d8810-4aaa-5515-8491-edfab9b4a34d', 'f300b72b-85ad-5e7c-aa4c-fa0b85252688', '7d64b123-b606-5758-90f7-09272b9e651f', '9009771f-0f4f-552d-85b8-1a62d64e1f89', '608950bb-aa4a-52a4-9b3e-99f392d0749f', 'a4d687f5-413f-5381-bb4c-d3b41fae0ef2', '83dd431e-f606-599d-badd-0da161f06ec5', '65d61b15-55cb-5a90-87a3-ed327d3324ed', '124375bd-9245-55ad-b9b6-1a13ae118f39', '2b9a306e-aabb-5266-b40d-f5cc54688c92', '0298a5ce-7e75-5a06-aea5-43c5e3a14230', 'c9915537-abe5-536a-a440-0c0762862698', 'c4d12c09-ba09-5c7b-aafb-48a6d978ee77', '17fb3f32-7853-5fbf-b7ee-2c8c5c9f5abe', '6c13fefb-1f60-55dc-8c09-3bb70590571d', '097e8287-73a6-5e98-9311-cfc0185e2c7f', '3c02b731-962b-5fd9-85eb-81e154adfbff', 'd1085c93-c5a0-5a29-b5db-37013439b6f3', 'b385a869-350c-5106-b96e-968ecf5e4638', 'df6e6925-d3d6-54c0-a986-0e1d0f2680a6', '006c9193-b3ee-54f5-80fb-ebdc7c87b3b1', '8e34b788-1c77-5935-8b75-e806d1002658', '440a6606-f1fa-50ef-a833-6cc0962715fb', '9fd4ba37-1ee3-5237-9f35-d55593bdee58', '3b5da457-44b8-5f04-90cc-4d8c205803cd', 'cbd0f7f0-6b22-53ea-a174-d395cc418a58', 'e4baeb15-b2e6-5a37-91c3-a26521dcdaec', 'a6224e0c-1586-5af9-8104-0170ef6fd37f', '7a681bb1-c4ac-5974-8819-79108bca99f2', '3f9ec5c9-52b1-5577-832d-612b9b3ac3cb', 'c08479dd-81ae-539d-875b-3f09d4eeb632', 'd0c19b70-0e6f-5269-8c9b-623132637b0a', 'a16ba1f0-85ba-5d15-8b0a-2f9b7661ce87', '8209e1e0-eef8-5492-9de0-7b721a87d969', '36b51b2d-a988-5d10-842f-b7d4c1c99ba8', 'fcfac15b-55db-5f5b-8a6f-62195a2e5db9', 'e8fae595-3e71-514b-b448-e6437b6901ac', '901fa4f8-bfd9-5b63-82ca-c88374103f48', '77f26d0b-6bb3-5ade-b17e-658e077953d1', '31d26bdd-de43-58de-97ba-84129f881e8c', '23b72ea2-f7a7-5160-9616-28e916d1d57b', '6823e8af-4184-5799-a5e9-8da06cb6527b');
DELETE FROM public.chapters c WHERE c.subject_id = 'iq-training-en' AND c.id NOT IN ('cf452fe8-c715-59e3-85d9-4d16b506943e', '8f816f7e-6684-527f-a6ae-9c1b3f03a4a5', '5b56de20-a91e-5db0-876f-b6ec0ed4d85d', '85a8263d-abfc-5448-87a8-89fb39112787', '4d7142b4-902b-5fe9-b636-878d9aab2555') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('cf452fe8-c715-59e3-85d9-4d16b506943e', 'iq-training-en', 'Visual reasoning', 'Matrices, shape sequences, rotations, symmetries and odd-ones-out: find the hidden rule in each figure and apply it.', '# 🧠 Training — no lesson. Observe each figure, deduce the rule, apply it.

Here we revise nothing: every mission is a puzzle to solve through pure deduction. Trust your eye and your logic. 💪', '📜 Solve by deduction, never by memory.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('8f816f7e-6684-527f-a6ae-9c1b3f03a4a5', 'iq-training-en', 'Logic', 'Sequences, analogies, syllogisms and conditional deductions: spot the hidden rule and apply it without memorizing anything.', '# 🧠 Logic — no lesson. Observe, deduce the rule, apply it.', '📜 A single rule governs each puzzle: find it, then apply it.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('5b56de20-a91e-5db0-876f-b6ec0ed4d85d', 'iq-training-en', 'Math Reasoning', 'Number sequences, numerical analogies, arithmetic grids and proportions: find the hidden rule by deduction, never by a memorized formula.', '# 🧠 Math Reasoning — no lesson. Observe the numbers, deduce the rule, apply it.', '📜 The rule is in the numbers: deduce it, don''t recite it.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('85a8263d-abfc-5448-87a8-89fb39112787', 'iq-training-en', 'Fluid intelligence', 'Brand-new problems with no learned method: induce the pattern, discover the transformation rule, and apply it — pure reasoning ability.', '# 🧠 Fluid intelligence — no lesson. Observe, deduce the rule, apply it.', '📜 Facing the unfamiliar: induce the pattern, find the rule, apply it — never from memory.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('4d7142b4-902b-5fe9-b636-878d9aab2555', 'iq-training-en', 'Geometry & spatial reasoning', 'Rotations, symmetries, counting hidden cubes and nets to fold: picture the figure in space and work out the transformation.', '# 🧠 Geometry & spatial reasoning — no lesson. Observe the figure, work out the rule, apply it.', '📐 Turn the figure in your head: work out the transformation, don''t memorize it.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d4049ce4-1dc7-5c74-b4bc-4a5332e32aa5', 'cf452fe8-c715-59e3-85d9-4d16b506943e', 'iq-training-en', 'Visual warm-up ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('60e0097f-a827-54ca-98f8-c25b7646c324', 'd4049ce4-1dc7-5c74-b4bc-4a5332e32aa5', 'Look at the sequence of circles. Which circle continues the series? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="15" cy="50" r="6" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="38" cy="50" r="11" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="68" cy="50" r="16" fill="none" stroke="#1d4ed8" stroke-width="2"/><text x="92" y="56" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"21\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"16\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"6\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"21\" fill=\"#1d4ed8\" stroke=\"#1d4ed8\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'The hidden rule: the radius grows by 5 at each step (6, 11, 16…). ✓ The next one is therefore 21, which is option a. Option b (16) repeats the last circle instead of growing. Option c (6) goes back to the very first. Option d has the right size but becomes filled: the colour never changed in the series, so we must not invent a new rule.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27716316-2040-5e5e-bdf9-c54fc593049d', 'd4049ce4-1dc7-5c74-b4bc-4a5332e32aa5', 'Three figures follow the same rule, only one is the odd one out. Which one? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="40" width="18" height="18" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/><rect x="32" y="40" width="18" height="18" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/><rect x="56" y="40" width="18" height="18" fill="none" stroke="#7c3aed" stroke-width="2"/><rect x="80" y="40" width="18" height="18" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">1</text></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">2</text></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">3</text></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">4</text></svg>"}]'::jsonb, 'c', 'The common rule: all the squares are filled. ✓ Square #3 is the only empty one (just an outline), so it is the odd one out, option c. Options a, b and d show filled squares, identical to the others: they follow the rule and cannot be the odd one out.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a274135c-f5be-580b-9bae-0a6e1ea48fd0', 'd4049ce4-1dc7-5c74-b4bc-4a5332e32aa5', 'On the left, a model arrow. Choose its image in a vertical mirror (left-right). <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><line x1="30" y1="50" x2="70" y2="50" stroke="#0f766e" stroke-width="4"/><polyline points="56,38 70,50 56,62" fill="none" stroke="#0f766e" stroke-width="4"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"56,38 70,50 56,62\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"70\" y1=\"50\" x2=\"30\" y2=\"50\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"44,38 30,50 44,62\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"70\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"38,56 50,70 62,56\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"70\" x2=\"50\" y2=\"30\" stroke=\"#0f766e\" stroke-width=\"4\"/><polyline points=\"38,44 50,30 62,44\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'b', 'A vertical mirror swaps left and right: an arrow pointing right then points left. ✓ This is option b. Option a is identical to the model (no reflection). Options c and d point down and up: that would be a rotation, not a left-right mirror.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80ec3685-1a19-58db-9992-9a1332e02369', 'd4049ce4-1dc7-5c74-b4bc-4a5332e32aa5', 'A single arrow turns a quarter-turn clockwise at each step. What comes next? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><g><line x1="12" y1="58" x2="12" y2="30" stroke="#b45309" stroke-width="4"/><polyline points="5,38 12,30 19,38" fill="none" stroke="#b45309" stroke-width="4"/></g><g><line x1="40" y1="44" x2="68" y2="44" stroke="#b45309" stroke-width="4"/><polyline points="60,37 68,44 60,51" fill="none" stroke="#b45309" stroke-width="4"/></g><text x="88" y="50" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"32\" x2=\"50\" y2=\"68\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"42,60 50,68 58,60\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"68\" y1=\"50\" x2=\"32\" y2=\"50\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"40,42 32,50 40,58\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"50\" y1=\"68\" x2=\"50\" y2=\"32\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"42,40 50,32 58,40\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"32\" y1=\"50\" x2=\"68\" y2=\"50\" stroke=\"#b45309\" stroke-width=\"4\"/><polyline points=\"60,42 68,50 60,58\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'a', 'The arrow first points up, then right: that is a clockwise quarter-turn. ✓ The next step gives an arrow pointing down, which is option a. Option d (pointing right) repeats the previous step. Option b (pointing left) turns the wrong way. Option c (pointing up) goes back to the starting point.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3d8e4bc-44ba-5731-b174-1806064a9ee6', 'd4049ce4-1dc7-5c74-b4bc-4a5332e32aa5', 'Look at the number of sides of the polygons. Which figure completes the sequence? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="18,58 8,42 28,42" fill="none" stroke="#be123c" stroke-width="2"/><rect x="40" y="40" width="18" height="18" fill="none" stroke="#be123c" stroke-width="2"/><polygon points="78,38 88,46 84,58 72,58 68,46" fill="none" stroke="#be123c" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,32 64,42 59,58 41,58 36,42\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,32 62,39 62,53 50,60 38,53 38,39\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"41\" y=\"41\" width=\"18\" height=\"18\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,33 58,58 38,42 62,42 42,58\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'The rule: the number of sides increases by 1 at each step — triangle (3), square (4), pentagon (5). ✓ The next one must have 6 sides, so the hexagon of option b. Option a is a pentagon (5 sides), it repeats the previous figure. Option c is a square (4 sides), already seen. Option d is a five-pointed star: we counted the points instead of the polygon''s sides.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e7cedea3-a965-5844-8f7e-3afc3977ce78', 'cf452fe8-c715-59e3-85d9-4d16b506943e', 'iq-training-en', '⭐ Warm-up', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89a8fb5d-47c7-5a27-848a-27236fd966fd', 'e7cedea3-a965-5844-8f7e-3afc3977ce78', 'Look at the sequence: the number of dots increases by 1 at each step. Which figure comes next? <svg viewBox="0 0 100 100"><rect x="2" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2"/><circle cx="13" cy="50" r="4" fill="#222"/><rect x="27" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2"/><circle cx="33" cy="50" r="4" fill="#222"/><circle cx="43" cy="50" r="4" fill="#222"/><rect x="52" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2"/><circle cx="57" cy="50" r="4" fill="#222"/><circle cx="63" cy="50" r="4" fill="#222"/><circle cx="69" cy="50" r="4" fill="#222"/><rect x="77" y="35" width="22" height="30" fill="none" stroke="#222" stroke-width="2" stroke-dasharray="3 3"/><text x="88" y="55" font-size="16" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"38\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"62\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"38\" r=\"5\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"38\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"62\" cy=\"50\" r=\"5\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"34\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"45\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"56\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"67\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"50\" cy=\"38\" r=\"5\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"30\" width=\"50\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"42\" cy=\"50\" r=\"5\" fill=\"#222\"/><circle cx=\"58\" cy=\"50\" r=\"5\" fill=\"#222\"/></svg>"}]'::jsonb, 'a', 'The rule is: +1 dot per box (1, then 2, then 3). The next box must therefore contain 4 dots → option a ✓. The trap: b repeats 3 dots (we forgot to add one), d goes back to 2 dots (we read the sequence backwards) and c puts 5 (we skipped a step). We add ONE single dot per step, so 3 + 1 = 4.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1a10d69-723c-5c2d-afc7-c90d678c1f8b', 'e7cedea3-a965-5844-8f7e-3afc3977ce78', 'The arrow turns a quarter-turn (90°) clockwise at each step: up, right, down… What is the next step? <svg viewBox="0 0 100 100"><g stroke="#222" stroke-width="3" fill="#222"><line x1="15" y1="62" x2="15" y2="38"/><polygon points="15,30 10,40 20,40"/></g><g stroke="#222" stroke-width="3" fill="#222"><line x1="38" y1="50" x2="62" y2="50"/><polygon points="70,50 60,45 60,55"/></g><g stroke="#222" stroke-width="3" fill="#222"><line x1="85" y1="38" x2="85" y2="62"/><polygon points="85,70 80,60 90,60"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"62\" x2=\"50\" y2=\"38\"/><polygon points=\"50,30 44,40 56,40\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\"/><polygon points=\"70,50 60,44 60,56\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"62\" y1=\"50\" x2=\"38\" y2=\"50\"/><polygon points=\"30,50 40,44 40,56\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"38\" x2=\"50\" y2=\"62\"/><polygon points=\"50,70 44,60 56,60\"/></g></svg>"}]'::jsonb, 'c', 'At each step the arrow turns 90° clockwise: up → right → down → left. After "down" therefore comes "left" → option c ✓. The trap: a (up) and b (right) go backwards in the sequence, and d (down) repeats the previous step. You must continue the rotation, not stop it or reverse it.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed796a36-7a1b-5750-9854-d81c5ae65cf4', 'e7cedea3-a965-5844-8f7e-3afc3977ce78', 'Three of these figures follow the same rule, only one is different. Which is the odd one out? <svg viewBox="0 0 100 100"><text x="50" y="55" font-size="12" text-anchor="middle" fill="#222">3 triangles + 1 carré</text><polygon points="50,15 40,30 60,30" fill="none" stroke="#222" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,25 30,70 70,70\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"25,70 50,25 75,70\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,30 70,40 45,72\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'The rule is: each figure is a triangle (3 sides). The odd one out is option c ✓, which is a square (4 sides). Count the sides: a, b and d have 3, only c has 4. The trap is to look at the size or the orientation instead of the number of sides; here it is indeed the square that breaks the "3 sides" rule.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7720263e-42e3-5b91-ac42-c3224d5bb1a7', 'e7cedea3-a965-5844-8f7e-3afc3977ce78', 'The small black square moves by one corner at each step, clockwise. Where will it be next? <svg viewBox="0 0 100 100"><rect x="4" y="38" width="24" height="24" fill="none" stroke="#222" stroke-width="2"/><rect x="6" y="40" width="7" height="7" fill="#222"/><rect x="38" y="38" width="24" height="24" fill="none" stroke="#222" stroke-width="2"/><rect x="53" y="40" width="7" height="7" fill="#222"/><rect x="72" y="38" width="24" height="24" fill="none" stroke="#222" stroke-width="2"/><rect x="87" y="53" width="7" height="7" fill="#222"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"32\" y=\"32\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"58\" y=\"32\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"58\" y=\"58\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"32\" y=\"58\" width=\"10\" height=\"10\" fill=\"#222\"/></svg>"}]'::jsonb, 'd', 'The black square turns clockwise: top-left → top-right → bottom-right → bottom-left. After the bottom-right corner therefore comes the bottom-left corner → option d ✓. The trap: c repeats the bottom-right (previous step), b (top-right) and a (top-left) go backwards. Keep following the rotation to the next corner.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94f42900-ae91-57a0-a070-192e5d21de60', 'e7cedea3-a965-5844-8f7e-3afc3977ce78', 'Three circles follow the same rule, only one is different. Which is the odd one out? <svg viewBox="0 0 100 100"><text x="50" y="45" font-size="11" text-anchor="middle" fill="#222">3 ronds pleins</text><text x="50" y="60" font-size="11" text-anchor="middle" fill="#222">+ 1 rond vide</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"48\" cy=\"50\" r=\"24\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"24\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"24\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"52\" cy=\"50\" r=\"24\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'The rule is: each circle is filled (filled with black). The odd one out is option b ✓, the only empty circle (just an outline). a, c and d are identical and filled; b breaks the filling rule. The trap is to look for a difference in size or position: here all the sizes are equal, it is the filling that sets b apart.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('38fc645d-1706-548f-bffa-753ab0a5ba02', 'e7cedea3-a965-5844-8f7e-3afc3977ce78', 'Look at the sequence of polygons: the number of sides increases by 1 at each step (3, then 4, then 5…). Which figure comes next? <svg viewBox="0 0 100 100"><polygon points="15,68 5,82 25,82" fill="none" stroke="#222" stroke-width="2"/><polygon points="33,30 51,30 51,48 33,48" fill="none" stroke="#222" stroke-width="2"/><polygon points="70,28 82,37 78,51 62,51 58,37" fill="none" stroke="#222" stroke-width="2"/><text x="50" y="92" font-size="10" text-anchor="middle" fill="#888">3 côtés, 4 côtés, 5 côtés, ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"32,32 68,32 68,68 32,68\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,20 73,33 73,60 50,73 27,60 27,33\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,22 71,37 63,62 37,62 29,37\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,20 70,30 75,52 62,70 38,70 25,52 30,30\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'b', 'The rule is: +1 side at each step (triangle 3, square 4, pentagon 5…). The next polygon must have 6 sides → the hexagon, option b ✓. The trap: c is a pentagon (5 sides, we forgot to add one), a a square (4, going backwards) and d a heptagon (7, we jumped by two). We add ONE single side, so 5 + 1 = 6.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f0d74904-26ba-5524-a24f-5e2623a2e36e', 'cf452fe8-c715-59e3-85d9-4d16b506943e', 'iq-training-en', '⚔️ Logic challenge ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f0d3bd1-525d-580b-9c1f-33665ff7d4c9', 'f0d74904-26ba-5524-a24f-5e2623a2e36e', 'The arrow turns a quarter-turn (90°) clockwise at each step. Which arrow comes next? <svg viewBox="0 0 100 100"><line x1="15" y1="75" x2="15" y2="30" stroke="#1f2937" stroke-width="4"/><polygon points="8,38 22,38 15,24" fill="#1f2937"/><line x1="40" y1="50" x2="85" y2="50" stroke="#1f2937" stroke-width="4"/><polygon points="77,43 77,57 91,50" fill="#1f2937"/><line x1="60" y1="25" x2="60" y2="70" stroke="#1f2937" stroke-width="4"/><polygon points="53,62 67,62 60,76" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"75\" y1=\"50\" x2=\"30\" y2=\"50\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"38,42 38,58 22,50\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"25\" y1=\"50\" x2=\"70\" y2=\"50\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"62,42 62,58 78,50\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"75\" x2=\"50\" y2=\"30\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"42,38 58,38 50,22\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"5\"/><polygon points=\"42,62 58,62 50,78\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'The hidden rule: +90° clockwise at each step. Up → right → down → left. ✓ Option a points left: it is the correct continuation. Option d (pointing down) repeats the previous step without turning. Option c (pointing up) goes backwards (reverse rotation). Option b (pointing right) skips a step. Tip: always follow the same direction of rotation, without skipping or going back.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2be56469-d9ff-500c-9333-cfbf3395a9da', 'f0d74904-26ba-5524-a24f-5e2623a2e36e', 'A is to B as C is to ? — observe the transformation between the first two figures, then apply it. <svg viewBox="0 0 100 100"><rect x="8" y="38" width="16" height="16" fill="none" stroke="#1f2937" stroke-width="3"/><text x="32" y="52" font-size="12" fill="#1f2937">:</text><rect x="40" y="26" width="40" height="40" fill="none" stroke="#1f2937" stroke-width="3"/><text x="86" y="52" font-size="12" fill="#1f2937">::</text><circle cx="96" cy="46" r="3" fill="none" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"8\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"30\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"30\" fill=\"#1f2937\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'The hidden rule: the figure grows a lot, while the shape and the outline stay the same (a small empty square becomes a large empty square). We apply the same enlargement to the small empty circle. ✓ Option c is a large empty circle: it is the right analogy. Option b keeps the small size (no transformation). Option a changes the shape (square instead of circle). Option d changes the colour attribute (filled circle), which the A→B transformation did not do. Keep a single transformation: the size.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36638c85-2eaa-53e1-9410-5399b64698b3', 'f0d74904-26ba-5524-a24f-5e2623a2e36e', 'The sequence of dots grows according to a simple rule. How many dots should the next figure contain? <svg viewBox="0 0 100 100"><rect x="4" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><circle cx="13" cy="49" r="3" fill="#1f2937"/><rect x="30" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><circle cx="37" cy="49" r="3" fill="#1f2937"/><circle cx="44" cy="49" r="3" fill="#1f2937"/><rect x="56" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><circle cx="61" cy="49" r="3" fill="#1f2937"/><circle cx="68" cy="49" r="3" fill="#1f2937"/><circle cx="65" cy="43" r="3" fill="#1f2937"/><rect x="82" y="40" width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="1.5"/><text x="88" y="54" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"35\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"35\" cy=\"62\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"62\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"20\" y=\"20\" width=\"60\" height=\"60\" fill=\"none\" stroke=\"#9ca3af\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'b', 'The hidden rule: we add one dot at each step (1, then 2, then 3…), the constant gap being +1. The next figure must therefore contain 4 dots. ✓ Option b shows exactly 4 dots: it is the right one. Option a (3 dots) repeats the previous step without progressing. Option c (5 dots) adds two dots at once (wrong gap). Option d (6 dots) doubles the jump. Count precisely: you must go from 3 to 4, i.e. +1.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76c6b95a-aa80-5a84-b34e-c70faa9e5a2b', 'f0d74904-26ba-5524-a24f-5e2623a2e36e', 'A is to B as C is to ? — the transformation is a left-right symmetry (mirror effect). Which figure completes the analogy? <svg viewBox="0 0 100 100"><polygon points="6,30 6,66 26,48" fill="#1f2937"/><text x="30" y="52" font-size="11" fill="#1f2937">:</text><polygon points="58,30 58,66 38,48" fill="#1f2937"/><text x="62" y="52" font-size="11" fill="#1f2937">::</text><polyline points="78,30 96,40 78,50" fill="none" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"38,30 62,50 38,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,38 50,62 70,38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,62 50,38 70,62\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"62,30 38,50 62,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"}]'::jsonb, 'd', 'The hidden rule: left-right mirror symmetry (the figure is flipped horizontally, as in a vertical mirror). A chevron pointing right ( > ) becomes a chevron pointing left ( < ). ✓ Option d is the exact horizontal mirror: it is the right one. Option a is identical to C (no transformation applied). Options b and c apply a 90° rotation (chevron pointing down or up) instead of a left-right mirror. Distinguish carefully between mirror and rotation.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30676a37-6ac0-5e84-a03a-a8c7ae30c692', 'f0d74904-26ba-5524-a24f-5e2623a2e36e', '3×3 matrix: in each row, the number of dots increases by 1 going to the right (1, 2, 3). Which figure fills the missing cell (bottom right)? <svg viewBox="0 0 100 100"><line x1="34" y1="4" x2="34" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="34" x2="96" y2="34" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#9ca3af" stroke-width="1"/><circle cx="19" cy="19" r="3" fill="#1f2937"/><circle cx="45" cy="19" r="3" fill="#1f2937"/><circle cx="55" cy="19" r="3" fill="#1f2937"/><circle cx="78" cy="19" r="3" fill="#1f2937"/><circle cx="84" cy="19" r="3" fill="#1f2937"/><circle cx="81" cy="13" r="3" fill="#1f2937"/><circle cx="19" cy="51" r="3" fill="#1f2937"/><circle cx="45" cy="51" r="3" fill="#1f2937"/><circle cx="55" cy="51" r="3" fill="#1f2937"/><circle cx="78" cy="51" r="3" fill="#1f2937"/><circle cx="84" cy="51" r="3" fill="#1f2937"/><circle cx="81" cy="45" r="3" fill="#1f2937"/><circle cx="19" cy="83" r="3" fill="#1f2937"/><circle cx="45" cy="83" r="3" fill="#1f2937"/><circle cx="55" cy="83" r="3" fill="#1f2937"/><text x="77" y="88" font-size="16" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"38\" cy=\"50\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"50\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"38\" cy=\"58\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"58\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"36\" r=\"7\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"70\" cy=\"40\" r=\"7\" fill=\"#1f2937\"/><circle cx=\"40\" cy=\"64\" r=\"7\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'c', 'The hidden rule: on each row, the 1st cell has 1 dot, the 2nd has 2, the 3rd has 3. The missing cell is the 3rd of the last row: it must therefore contain 3 dots. ✓ Option c shows 3 dots: it is the right one. Option b (2 dots) repeats the middle column. Option a (1 dot) repeats the first column. Option d (4 dots) overshoots the rule (+1 too many). Read the matrix row by row to lock the constant gap: +1 per column.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('170dee6f-9a12-5cdf-8d42-765487fb6521', 'f0d74904-26ba-5524-a24f-5e2623a2e36e', 'The needle always turns 45° clockwise, around its centre point. Which figure continues the sequence? <svg viewBox="0 0 100 100"><circle cx="17" cy="50" r="2.5" fill="#1f2937"/><line x1="17" y1="50" x2="17" y2="28" stroke="#1f2937" stroke-width="3"/><polygon points="17,24 12,33 22,33" fill="#1f2937"/><circle cx="50" cy="50" r="2.5" fill="#1f2937"/><line x1="50" y1="50" x2="66" y2="34" stroke="#1f2937" stroke-width="3"/><polygon points="69,31 58,34 65,41" fill="#1f2937"/><circle cx="83" cy="50" r="2.5" fill="#1f2937"/><line x1="83" y1="50" x2="95" y2="50" stroke="#1f2937" stroke-width="3"/><polygon points="99,50 90,45 90,55" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"70\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"75,75 62,72 72,62\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"50\" y2=\"75\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"50,80 44,68 56,68\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"70\" y2=\"30\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"75,25 62,28 72,38\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1f2937\"/><line x1=\"50\" y1=\"50\" x2=\"30\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"25,75 28,62 38,72\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'The hidden rule: +45° clockwise at each step. The needle points up (90°), then up-right (45°), then right (0°)… the next step must point down-right. ✓ Option a points down-right: it is the correct continuation. Option c (up-right) goes back one notch (reverse rotation). Option b (pointing down) skips a 45° notch. Option d (down-left) goes the wrong way (anticlockwise). Keep a constant step of 45°, always in the same clockwise direction.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('99fb5800-ca71-5740-954b-f2670fef97ab', 'cf452fe8-c715-59e3-85d9-4d16b506943e', 'iq-training-en', '👑 IQ Elite ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5706efe-9630-5f64-96c2-0180c05815ff', '99fb5800-ca71-5740-954b-f2670fef97ab', 'Here is a figure and the dashed vertical axis to its right. Which option is its image by REFLECTION in this vertical mirror (left-right)? <svg viewBox="0 0 100 100"><polyline points="30,20 30,80 70,80" fill="none" stroke="#1e293b" stroke-width="6"/><circle cx="30" cy="20" r="7" fill="#ef4444" stroke="#1e293b" stroke-width="2"/><line x1="88" y1="10" x2="88" y2="90" stroke="#64748b" stroke-width="2" stroke-dasharray="4 4"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,20 30,80 70,80\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"20\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,20 70,80 30,80\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"70\" cy=\"20\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,80 30,20 70,20\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"80\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,80 70,20 30,20\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"70\" cy=\"80\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'Hidden rule: a vertical reflection (left-right mirror) flips the horizontal axis and keeps the vertical axis. The L-shaped figure has its corner at the bottom left and the red ball at the top left; after the mirror, the corner moves to the bottom right and the ball stays AT THE TOP, on the right. ✓ option b. Trap a: it is the starting figure unchanged (no mirror). Trap c: it is a top-bottom flip, not left-right (the ball would go down). Trap d: it is a 180° rotation, which flips BOTH axes at once.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9253b4b1-3906-562b-bfac-7a090ff13bb2', '99fb5800-ca71-5740-954b-f2670fef97ab', 'This staircase is built with identical cubes. Counting also the cubes hidden behind, how many cubes in total make it up? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="1.5" fill="#cbd5e1"><rect x="20" y="70" width="18" height="18"/><rect x="38" y="70" width="18" height="18"/><rect x="56" y="70" width="18" height="18"/><rect x="20" y="52" width="18" height="18"/><rect x="38" y="52" width="18" height="18"/><rect x="20" y="34" width="18" height="18"/></g><text x="50" y="24" font-size="10" text-anchor="middle" fill="#1e293b">profondeur 1</text></svg>', '[{"id":"a","text":"5"},{"id":"b","text":"9"},{"id":"c","text":"6"},{"id":"d","text":"10"}]'::jsonb, 'c', 'Rule: we add up the cubes column by column, depth 1 (nothing hidden behind, as indicated). Left column = 3 stacked cubes, middle column = 2, right column = 1. Total = 3 + 2 + 1 = 6. ✓ option c. Trap a (5): we forgot a cube of one column. Trap b (9): we assumed a full 3×3 square when it is a staircase. Trap d (10): we added a hidden layer behind, but the depth is 1.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d586bdb5-5ba6-56a1-87c9-54457e7506fc', '99fb5800-ca71-5740-954b-f2670fef97ab', 'Only one of these (unfolded) nets can fold into a closed CUBE, with no missing face and no overlapping face. Which one? <svg viewBox="0 0 100 100"><text x="50" y="50" font-size="11" text-anchor="middle" fill="#1e293b">6 carrés = patron du cube</text><text x="50" y="66" font-size="11" text-anchor="middle" fill="#1e293b">Lequel se replie ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"40\" y=\"10\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"30\" width=\"20\" height=\"20\"/><rect x=\"20\" y=\"50\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"50\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"50\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"70\" width=\"20\" height=\"20\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"20\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"20\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"60\" width=\"20\" height=\"20\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"15\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"35\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"55\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"75\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"15\" y=\"60\" width=\"20\" height=\"20\"/><rect x=\"35\" y=\"60\" width=\"20\" height=\"20\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#93c5fd\"><rect x=\"20\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"20\" width=\"20\" height=\"20\"/><rect x=\"20\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\"/><rect x=\"60\" y=\"40\" width=\"20\" height=\"20\"/></g></svg>"}]'::jsonb, 'a', 'Rule: a valid cube net has 6 squares arranged so that none overlap when folded; the great classic is the cross (a central square with one square on each side + one extending it). Option a is this elongated T-cross: a column of 4 squares with two squares on the sides of the 3rd one — it folds perfectly. ✓ option a. Trap b: it forms a 2×2 block plus two squares in a staircase; when folded, two faces overlap and one is missing. Trap d: it is a full 3×2 rectangle, which folds into an open box (two faces overlap, no closed cube). Trap c: a 4+2 configuration where the two bottom squares are misplaced, so two faces land in the same spot.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('462a8b6a-2503-5e24-928a-b5e687d98b64', '99fb5800-ca71-5740-954b-f2670fef97ab', 'We overlay the two left-hand figures EXACTLY (same centre), black lines over black lines. Which option shows the result of this overlay? <svg viewBox="0 0 100 100"><g fill="none" stroke="#1e293b" stroke-width="4"><rect x="12" y="30" width="34" height="34"/></g><text x="55" y="50" font-size="16" text-anchor="middle" fill="#1e293b">+</text><g fill="none" stroke="#1e293b" stroke-width="4"><line x1="66" y1="30" x2="94" y2="58"/><line x1="94" y1="30" x2="66" y2="58"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"22\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"34\" y1=\"34\" x2=\"66\" y2=\"66\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"66\" y1=\"34\" x2=\"34\" y2=\"66\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"70\" y1=\"30\" x2=\"30\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'd', 'Rule: the overlay keeps ALL the lines of both figures, without adding or removing anything. We have a square AND an X cross (two diagonals); the result is therefore the square crossed by its two diagonals forming an X. ✓ option d. Trap a: it is the square alone, we forgot the cross. Trap c: a single diagonal, we lost half of the X. Trap b: we replaced the square with a circle, whereas the overlay never turns one shape into another.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1a2b8f6-6873-5e5b-ba82-e7fbe9d79531', '99fb5800-ca71-5740-954b-f2670fef97ab', 'Transformation A → B, apply the SAME one to C to find the result. A→B: the arrow turns 90° clockwise AND a black dot appears. <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="10" y1="50" x2="34" y2="50"/><polyline points="28,44 34,50 28,56"/></g><text x="42" y="54" font-size="12" fill="#1e293b">→</text><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="58" y1="34" x2="58" y2="58"/><polyline points="52,52 58,58 64,52"/></g><circle cx="78" cy="40" r="4" fill="#1e293b"/><text x="50" y="82" font-size="11" text-anchor="middle" fill="#1e293b">C : flèche vers le bas, sans point</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><polyline points=\"62,42 70,50 62,58\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><polyline points=\"38,42 30,50 38,58\"/></g><circle cx=\"78\" cy=\"24\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"70\"/><polyline points=\"42,38 50,30 58,38\"/></g><circle cx=\"78\" cy=\"24\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><polyline points=\"62,42 70,50 62,58\"/></g><circle cx=\"78\" cy=\"24\" r=\"5\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'b', 'Rule: 90° clockwise rotation + adding a dot. C points DOWN; after a clockwise quarter-turn, down goes to the LEFT, so the arrow points left, and we add the dot. ✓ option b (arrow pointing left + dot). Trap c: we forgot to turn (arrow still vertical) while adding the dot. Trap d: clockwise rotation but arrow pointing RIGHT — that is the direction error (down turning clockwise does not go right). Trap a: arrow pointing right AND dot forgotten, two errors combined.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce63cc53-033b-51c5-8fee-cc8c6e98ece2', '99fb5800-ca71-5740-954b-f2670fef97ab', 'The pattern turns a quarter-turn (90°) at each cell, always in the same direction. Observing the progression, which figure occupies the cell with the « ? »? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="3" fill="none"><rect x="4" y="35" width="28" height="28"/><line x1="18" y1="49" x2="30" y2="49"/><rect x="36" y="35" width="28" height="28"/><line x1="50" y1="49" x2="50" y2="61"/><rect x="68" y="35" width="28" height="28"/><line x1="82" y1="49" x2="70" y2="49"/></g><text x="82" y="82" font-size="14" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"70\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"30\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"50\" y2=\"30\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><line x1=\"50\" y1=\"50\" x2=\"50\" y2=\"70\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'c', 'Rule: the needle starting from the centre turns 90° clockwise at each cell. Cell 1: needle to the RIGHT. Cell 2: a clockwise quarter-turn → DOWN. Cell 3: another quarter-turn → LEFT. Cell 4 (the ?): a final quarter-turn → UP. ✓ option c (needle pointing up). Trap a: back to the right, as if returning to the start instead of continuing. Trap d: needle pointing down, we skipped a rotation step. Trap b: needle pointing left, we repeated cell 3 without turning.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a6b0ba25-8e64-5d4e-b198-f6f0cd4a33da', '8f816f7e-6684-527f-a6ae-9c1b3f03a4a5', 'iq-training-en', 'Logic Warm-up ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cba831b6-53ba-5ef1-9cd7-f83c140ae0e4', 'a6b0ba25-8e64-5d4e-b198-f6f0cd4a33da', '3×3 matrix: on each row, the number of dots increases by 1 as you move to the right. Which figure replaces the « ? »? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><line x1="35" y1="4" x2="35" y2="96" stroke="#94a3b8" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#94a3b8" stroke-width="1"/><line x1="4" y1="35" x2="96" y2="35" stroke="#94a3b8" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#94a3b8" stroke-width="1"/><circle cx="19" cy="19" r="3" fill="#1d4ed8"/><circle cx="44" cy="19" r="3" fill="#1d4ed8"/><circle cx="56" cy="19" r="3" fill="#1d4ed8"/><circle cx="75" cy="19" r="3" fill="#1d4ed8"/><circle cx="81" cy="19" r="3" fill="#1d4ed8"/><circle cx="87" cy="19" r="3" fill="#1d4ed8"/><circle cx="19" cy="50" r="3" fill="#1d4ed8"/><circle cx="44" cy="50" r="3" fill="#1d4ed8"/><circle cx="56" cy="50" r="3" fill="#1d4ed8"/><circle cx="75" cy="50" r="3" fill="#1d4ed8"/><circle cx="81" cy="50" r="3" fill="#1d4ed8"/><circle cx="87" cy="50" r="3" fill="#1d4ed8"/><circle cx="19" cy="81" r="3" fill="#1d4ed8"/><circle cx="44" cy="81" r="3" fill="#1d4ed8"/><circle cx="56" cy="81" r="3" fill="#1d4ed8"/><text x="81" y="86" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"32\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"68\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"41\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"59\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"26\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"42\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"58\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/><circle cx=\"74\" cy=\"50\" r=\"5\" fill=\"#1d4ed8\"/></svg>"}]'::jsonb, 'a', 'The hidden rule: on each row the number of dots goes 1, then 2, then 3 (left column = 1, middle column = 2, right column = 3). ✓ The missing cell is at the bottom right, so it must contain 3 dots: that is option a. Option b (2 dots) copies the middle column. Option c (1 dot) copies the left column. Option d (4 dots) extends the sequence one step too far: the row stops at 3.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5b1b58f-3ae0-55b9-973e-419a6136908a', 'a6b0ba25-8e64-5d4e-b198-f6f0cd4a33da', 'Look at the sequence of squares: their size changes according to a regular rule. Which square comes next? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="8" y="44" width="12" height="12" fill="none" stroke="#7c3aed" stroke-width="2"/><rect x="30" y="40" width="20" height="20" fill="none" stroke="#7c3aed" stroke-width="2"/><rect x="58" y="36" width="28" height="28" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="94" y="55" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"32\" y=\"32\" width=\"36\" height=\"36\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"36\" y=\"36\" width=\"28\" height=\"28\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"44\" y=\"44\" width=\"12\" height=\"12\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"32\" y=\"32\" width=\"36\" height=\"36\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'The rule: the side of the square grows by 8 at each step (12, 20, 28…). ✓ The next square therefore measures 36 on each side, empty like the others: that is option a. Option b (28) copies the last square instead of enlarging it. Option c (12) goes back to the very first one. Option d has the right size but becomes filled: the color never changed in the sequence, so do not invent a new rule.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b6605926-f8c2-518b-9bc7-0d9038032f0e', 'a6b0ba25-8e64-5d4e-b198-f6f0cd4a33da', 'Analogy: circle is to triangle as square is to … ? On the left is the model (circle → triangle): you replace the figure with the one that has one more side. Apply the same transformation to the square. <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="16" cy="30" r="10" fill="none" stroke="#0f766e" stroke-width="2"/><text x="34" y="35" font-size="12" fill="#64748b" text-anchor="middle">→</text><polygon points="52,22 44,38 60,38" fill="none" stroke="#0f766e" stroke-width="2"/><rect x="8" y="66" width="18" height="18" fill="none" stroke="#0f766e" stroke-width="2"/><text x="40" y="79" font-size="12" fill="#64748b" text-anchor="middle">→</text><text x="66" y="80" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,28 64,40 58,58 42,58 36,40\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,30 60,42 50,54 40,42\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,30 42,46 58,46\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,28 60,34 60,46 50,52 40,46 40,34\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'The model''s transformation: you go from a figure to the one that has one more side. The circle (seen as 0 straight sides) becomes a triangle (3 sides)… but the readable rule is « +1 side » applied to the square. The square has 4 sides, so it must become a pentagon, 5 sides. ✓ That is option a. Option b is a diamond (4 sides): the same number of sides as the square, no transformation. Option c is a triangle (3 sides): one side fewer. Option d is a hexagon (6 sides): two sides more, you added 2 instead of 1.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7785616f-d23a-5205-b511-4f0749344a4a', 'a6b0ba25-8e64-5d4e-b198-f6f0cd4a33da', 'Three figures share the same rule, only one is the odd one out. Which one? (Hint: count the number of sides.) <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="18,58 8,42 28,42" fill="none" stroke="#be123c" stroke-width="2"/><rect x="40" y="40" width="18" height="18" fill="none" stroke="#be123c" stroke-width="2"/><polygon points="78,40 88,48 84,60 72,60 68,48" fill="none" stroke="#be123c" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,28 42,44 58,44\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">1</text></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"40\" y=\"30\" width=\"20\" height=\"20\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">2</text></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"40\" r=\"11\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">3</text></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,28 60,36 56,48 44,48 40,36\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><text x=\"50\" y=\"82\" font-size=\"14\" fill=\"#64748b\" text-anchor=\"middle\">4</text></svg>"}]'::jsonb, 'c', 'The shared rule: all these figures are polygons, that is, made of straight sides (triangle, square, pentagon). ✓ The circle in option c has no straight side: it is the only one that is not a polygon, so it is the odd one out. Option a (triangle, 3 sides), option b (square, 4 sides) and option d (pentagon, 5 sides) all obey the « drawn with straight sides » rule and cannot be the odd one out.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('890dddf9-c139-52d8-ac51-ecc91251d728', 'a6b0ba25-8e64-5d4e-b198-f6f0cd4a33da', 'Deduction: RULE — all blue figures are circles. On the card you see a blue figure, but its shape is hidden under a gray veil. Which of these statements is necessarily true? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="4" y="4" width="92" height="92" rx="6" fill="none" stroke="#94a3b8" stroke-width="2"/><rect x="32" y="32" width="36" height="36" rx="4" fill="#9ca3af" stroke="#6b7280" stroke-width="2"/><text x="50" y="55" font-size="22" fill="#374151" text-anchor="middle">?</text><text x="50" y="88" font-size="10" fill="#2563eb" text-anchor="middle">figure bleue</text></svg>', '[{"id":"a","text":"It is necessarily a circle."},{"id":"b","text":"It is necessarily a square."},{"id":"c","text":"It can be any shape, nothing can be said."},{"id":"d","text":"It is necessarily a triangle."}]'::jsonb, 'a', 'The rule says: « every blue figure is a circle. » The hidden figure is blue, so it falls under the rule: it is necessarily a circle. ✓ That is option a. Option c forgets that we already know its color: the rule applies and lets us conclude. Options b and d invent a shape that the rule forbids for a blue figure. Tip: « if blue then circle » + « it is blue » ⇒ « it is a circle » (direct deduction).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cde25f80-7194-5355-93e4-161a69223d28', '8f816f7e-6684-527f-a6ae-9c1b3f03a4a5', 'iq-training-en', '⭐ Warm-up', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eedb2ad8-a389-57d2-900f-0ec30c232b7f', 'cde25f80-7194-5355-93e4-161a69223d28', 'In this 3×3 grid, the number of dots in each cell equals its row number (row 1 = 1 dot, row 2 = 2 dots, row 3 = 3 dots). Which figure completes the cell marked « ? »? <svg viewBox="0 0 100 100"><g fill="none" stroke="#222" stroke-width="1.5"><rect x="6" y="6" width="88" height="88"/><line x1="35" y1="6" x2="35" y2="94"/><line x1="65" y1="6" x2="65" y2="94"/><line x1="6" y1="35" x2="94" y2="35"/><line x1="6" y1="65" x2="94" y2="65"/></g><g fill="#222"><circle cx="20" cy="20" r="3.5"/><circle cx="50" cy="20" r="3.5"/><circle cx="80" cy="20" r="3.5"/><circle cx="15" cy="50" r="3.5"/><circle cx="25" cy="50" r="3.5"/><circle cx="45" cy="50" r="3.5"/><circle cx="55" cy="50" r="3.5"/><circle cx="75" cy="50" r="3.5"/><circle cx="85" cy="50" r="3.5"/><circle cx="14" cy="80" r="3.5"/><circle cx="20" cy="80" r="3.5"/><circle cx="26" cy="80" r="3.5"/><circle cx="44" cy="80" r="3.5"/><circle cx="50" cy="80" r="3.5"/><circle cx="56" cy="80" r="3.5"/></g><text x="80" y="85" font-size="16" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"15\" y=\"15\" width=\"70\" height=\"70\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"50\" cy=\"50\" r=\"6\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"15\" y=\"15\" width=\"70\" height=\"70\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"38\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"62\" cy=\"50\" r=\"6\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"15\" y=\"15\" width=\"70\" height=\"70\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"32\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"50\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"68\" cy=\"50\" r=\"6\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"15\" y=\"15\" width=\"70\" height=\"70\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"28\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"43\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"58\" cy=\"50\" r=\"6\" fill=\"#222\"/><circle cx=\"73\" cy=\"50\" r=\"6\" fill=\"#222\"/></svg>"}]'::jsonb, 'c', 'The grid''s rule is: number of dots = row number. The « ? » cell is on the 3rd row (where there are already cells with 3 dots), so it must contain 3 dots → option c ✓. The trap: b puts 2 (reading the column number instead of the row), a puts 1 (mistaking it for the 1st row) and d puts 4 (adding one dot too many). Apply the ROW rule: 3rd row = 3 dots.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('99c669a0-028c-5e70-bac8-4bc254aef8d9', 'cde25f80-7194-5355-93e4-161a69223d28', 'Look at the number sequence: 2, 5, 8, 11, ? — each term always increases by the same step. Which number comes next?', '[{"id":"a","text":"12"},{"id":"b","text":"13"},{"id":"c","text":"14"},{"id":"d","text":"15"}]'::jsonb, 'c', 'The rule is: add 3 at each step (2 → 5 → 8 → 11). After 11 comes 11 + 3 = 14 → option c ✓. The trap: 12 adds only 1 (forgetting the real step), 13 adds 2 (wrong step) and 15 adds 4 (one step too many). Measure the gap between two neighboring terms (always +3) and reproduce it: 11 + 3 = 14.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae060409-d887-50cc-9d24-383480387446', 'cde25f80-7194-5355-93e4-161a69223d28', 'Analogy: the left figure turns into the right one through a half-turn (180° rotation). Apply the SAME transformation to the 3rd figure to find the answer. <svg viewBox="0 0 100 100"><polygon points="15,15 15,40 35,27" fill="#222"/><text x="45" y="30" font-size="12" fill="#222">→</text><polygon points="85,15 85,40 65,27" fill="#222"/><text x="30" y="72" font-size="12" fill="#222">L''Éclair monte ↑, puis ?</text><polygon points="50,55 70,55 60,40" fill="#c33"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,45 60,45 50,60\" fill=\"#c33\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,60 60,60 50,45\" fill=\"#c33\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,40 55,50 40,60\" fill=\"#c33\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"60,40 60,60 40,50\" fill=\"#c33\"/></svg>"}]'::jsonb, 'a', 'The transformation is a half-turn (180°): the solid arrow pointing right becomes an arrow pointing left. The red triangle points UP; after a half-turn it must point DOWN → option a ✓. The trap: b still points up (no rotation), c points right and d points left (a 90° rotation instead of 180°). A half-turn completely reverses the direction: up → down.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7264774-f41c-542f-907b-6231d5d2094c', 'cde25f80-7194-5355-93e4-161a69223d28', 'Three of these arrows point in the same direction, only one is different. Which is the odd one out? <svg viewBox="0 0 100 100"><text x="50" y="45" font-size="11" text-anchor="middle" fill="#222">Même direction</text><text x="50" y="60" font-size="11" text-anchor="middle" fill="#222">pour 3 flèches sur 4</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"70\" x2=\"50\" y2=\"38\"/><polygon points=\"50,28 42,42 58,42\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"62\"/><polygon points=\"50,72 42,58 58,58\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"72\" x2=\"50\" y2=\"40\"/><polygon points=\"50,30 42,44 58,44\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#222\" stroke-width=\"4\" fill=\"#222\"><line x1=\"50\" y1=\"68\" x2=\"50\" y2=\"36\"/><polygon points=\"50,26 42,40 58,40\"/></g></svg>"}]'::jsonb, 'b', 'The rule is: each arrow points UP. The odd one out is option b ✓, the only one pointing down (its tip is at the bottom). Look only at where the tip is: a, c and d have their tip at the top, only b has it at the bottom. The trap is comparing the length or position of the lines; here only the DIRECTION of the tip matters.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('68e98f17-7d5b-57bd-aef4-bd68b3942047', 'cde25f80-7194-5355-93e4-161a69223d28', 'Deduction: « All Zogs wear a hat. » We observe a creature that does NOT wear a hat. What can we conclude with certainty?', '[{"id":"a","text":"This creature is a Zog."},{"id":"b","text":"This creature is not a Zog."},{"id":"c","text":"All hat-wearers are Zogs."},{"id":"d","text":"No creature wears a hat."}]'::jsonb, 'b', 'The rule says that EVERY Zog wears a hat. So a creature without a hat cannot be a Zog (otherwise it would wear one) → option b ✓. The trap: a directly contradicts the observation; c reverses the rule (« every Zog has a hat » does not mean « every hat belongs to a Zog »); d invents a claim that is unrelated. Apply the rule by contrapositive: no hat ⇒ not a Zog.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('646005a3-9735-5a52-afc9-da44a988778e', 'cde25f80-7194-5355-93e4-161a69223d28', 'Analogy: the left figure turns into the right one by FILLING with black. Apply the same rule to the 3rd figure. <svg viewBox="0 0 100 100"><circle cx="22" cy="28" r="14" fill="none" stroke="#222" stroke-width="3"/><text x="42" y="32" font-size="12" fill="#222">→</text><circle cx="78" cy="28" r="14" fill="#222" stroke="#222" stroke-width="2"/><rect x="36" y="60" width="28" height="28" fill="none" stroke="#222" stroke-width="3"/><text x="50" y="98" font-size="9" text-anchor="middle" fill="#888">carré vide → ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"32\" y=\"32\" width=\"36\" height=\"36\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"32\" y=\"32\" width=\"36\" height=\"36\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'The transformation does NOT change the shape: it only fills the inside with black (the empty circle becomes a solid circle). The empty square must therefore become a solid square → option c ✓. The trap: a keeps the square empty (forgetting to fill it), d shrinks it (changing the size, not the fill) and b changes the shape to a circle (the rule acts on the fill, not the shape). Apply only « fill with black » while keeping the square.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('661d5164-6f02-5ef0-b676-cf1083ec6a98', '8f816f7e-6684-527f-a6ae-9c1b3f03a4a5', 'iq-training-en', '⚔️ Logic Challenge ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7acd16de-a6d4-5e29-bf5e-f9af17059164', '661d5164-6f02-5ef0-b676-cf1083ec6a98', 'Number sequence: each term is obtained by always adding the same gap to the previous one. Which number replaces the ?? <svg viewBox="0 0 100 100"><line x1="4" y1="60" x2="96" y2="60" stroke="#9ca3af" stroke-width="1.5"/><circle cx="14" cy="60" r="2" fill="#1f2937"/><circle cx="34" cy="60" r="2" fill="#1f2937"/><circle cx="54" cy="60" r="2" fill="#1f2937"/><circle cx="74" cy="60" r="2" fill="#1f2937"/><circle cx="90" cy="60" r="2" fill="#1f2937"/><text x="11" y="50" font-size="11" fill="#1f2937">2</text><text x="31" y="50" font-size="11" fill="#1f2937">5</text><text x="51" y="50" font-size="11" fill="#1f2937">8</text><text x="69" y="50" font-size="11" fill="#1f2937">11</text><text x="87" y="50" font-size="13" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"13"},{"id":"b","text":"14"},{"id":"c","text":"15"},{"id":"d","text":"16"}]'::jsonb, 'b', 'The hidden rule: the gap is constant, +3 at each step (2 → 5 → 8 → 11). After 11, add 3 again: 11 + 3 = 14. ✓ Option b (14) respects the +3 gap: it is the right one. Option a (13) adds only +2 (wrong gap). Option c (15) adds +4 (one too many). Option d (16) skips two steps (+5). First spot the gap between two neighboring terms, then apply it as is.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('58d24dc7-833e-5b68-a583-57c6ad536f01', '661d5164-6f02-5ef0-b676-cf1083ec6a98', 'Three of these figures share the same property, only one breaks it: which is the odd one out? Look at whether the outline is closed or open. <svg viewBox="0 0 100 100"><text x="6" y="80" font-size="9" fill="#6b7280">Contour : fermé = boucle complète ; ouvert = ligne brisée non refermée.</text><line x1="6" y1="30" x2="94" y2="30" stroke="#9ca3af" stroke-width="1"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,72 50,30 70,72\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,30 30,70 70,70 70,30\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"22\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'c', 'The hidden rule: is the outline closed (the line returns to its starting point) or open? The triangle (a), the square (b) and the circle (d) are closed outlines: the loop is complete. Option c draws three sides of a square but leaves the top open: the line does not close back. ✓ The odd one out is c: it is the only figure with an open outline. The trap: mistaking c for a square like b — they look alike, but b is closed while c has an opening at the top. Trace the path with your finger: if it returns to the start, the outline is closed.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a131a889-f405-5f95-b470-5dc58e3003d6', '661d5164-6f02-5ef0-b676-cf1083ec6a98', 'A is to B as C is to ? — observe the transformation between the first two figures (a rotation), then apply it to C. <svg viewBox="0 0 100 100"><polygon points="6,30 6,60 24,45" fill="#1f2937"/><text x="28" y="50" font-size="11" fill="#1f2937">:</text><polygon points="38,30 68,30 53,48" fill="#1f2937"/><text x="72" y="50" font-size="11" fill="#1f2937">::</text><polyline points="82,32 96,40 82,48" fill="none" stroke="#1f2937" stroke-width="3"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"38,30 62,50 38,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,38 50,62 70,38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,62 50,38 70,62\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"62,30 38,50 62,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"}]'::jsonb, 'b', 'The hidden rule: a 90° clockwise rotation. The solid triangle pointing right (A) becomes a triangle pointing down (B): that is indeed a quarter turn clockwise. Apply the same clockwise quarter turn to the chevron of C, which points right ( > ): it must point down ( v ). ✓ Option b is the chevron pointing down: it is the right one. Option d points left (a 180° rotation, two notches). Option c points up (counter-clockwise rotation, wrong direction). Option a is identical to C (no rotation). Check both the direction AND the amount: a single clockwise quarter turn.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5720d1a3-b6ae-5b97-b2bb-04ba7d770c6e', '661d5164-6f02-5ef0-b676-cf1083ec6a98', 'Logical deduction. We know: « All Gloms are Vrouks » and « No Vrouk is blue ». Knowing that Pim is a Glom, what can we conclude with certainty? <svg viewBox="0 0 100 100"><circle cx="50" cy="52" r="40" fill="none" stroke="#9ca3af" stroke-width="2"/><text x="36" y="22" font-size="9" fill="#6b7280">Vrouks</text><circle cx="50" cy="58" r="20" fill="none" stroke="#1f2937" stroke-width="2"/><text x="38" y="50" font-size="9" fill="#1f2937">Gloms</text><circle cx="50" cy="60" r="3" fill="#1f2937"/><text x="54" y="63" font-size="9" fill="#1f2937">Pim</text></svg>', '[{"id":"a","text":"Pim is not blue."},{"id":"b","text":"Pim is blue."},{"id":"c","text":"Pim is not a Vrouk."},{"id":"d","text":"All Vrouks are Gloms."}]'::jsonb, 'a', 'The hidden rule: chain the inclusions. Pim is a Glom, and all Gloms are Vrouks: so Pim is a Vrouk. But no Vrouk is blue: so Pim is not blue. ✓ Option a is the only certain conclusion. Option b (« Pim is blue ») states the exact opposite of the rule. Option c (« Pim is not a Vrouk ») contradicts the Glom → Vrouk chain. Option d reverses the inclusion: « all Gloms are Vrouks » says nothing about the reverse (there may be Vrouks that are not Gloms). Follow the inclusion arrows in the right direction, without flipping them.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('342023d7-1a0a-5993-9477-b63917a61dbd', '661d5164-6f02-5ef0-b676-cf1083ec6a98', '3×3 matrix: on each row, the shape stays the same and the number of dots inside increases by 1 to the right (1, 2, 3). Which figure fills the missing cell (bottom right)? <svg viewBox="0 0 100 100"><line x1="34" y1="4" x2="34" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="34" x2="96" y2="34" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#9ca3af" stroke-width="1"/><circle cx="19" cy="19" r="11" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="19" cy="19" r="2.5" fill="#1f2937"/><circle cx="50" cy="19" r="11" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="45" cy="19" r="2.5" fill="#1f2937"/><circle cx="55" cy="19" r="2.5" fill="#1f2937"/><circle cx="82" cy="19" r="11" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="77" cy="19" r="2.5" fill="#1f2937"/><circle cx="82" cy="19" r="2.5" fill="#1f2937"/><circle cx="87" cy="19" r="2.5" fill="#1f2937"/><rect x="9" y="41" width="20" height="18" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="19" cy="50" r="2.5" fill="#1f2937"/><rect x="40" y="41" width="20" height="18" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="45" cy="50" r="2.5" fill="#1f2937"/><circle cx="55" cy="50" r="2.5" fill="#1f2937"/><rect x="72" y="41" width="20" height="18" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="77" cy="50" r="2.5" fill="#1f2937"/><circle cx="82" cy="50" r="2.5" fill="#1f2937"/><circle cx="87" cy="50" r="2.5" fill="#1f2937"/><polygon points="19,74 28,90 10,90" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="19" cy="85" r="2.5" fill="#1f2937"/><polygon points="50,74 59,90 41,90" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="45" cy="85" r="2.5" fill="#1f2937"/><circle cx="55" cy="85" r="2.5" fill="#1f2937"/><text x="78" y="90" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 78,76 22,76\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"60\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 78,76 22,76\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"40\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"46\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"24\" y=\"30\" width=\"52\" height=\"46\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"38\" cy=\"53\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"53\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"53\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 78,76 22,76\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"40\" cy=\"66\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"66\" r=\"5\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'b', 'The hidden rule has two parts: (1) the shape is fixed per row — the last row is made of triangles; (2) the number of dots increases by 1 to the right, so the 3rd column contains 3 of them. The missing cell must be a triangle containing 3 dots. ✓ Option b is a triangle with 3 dots: it is the right one. Option d is a triangle but with only 2 dots (repeating the middle column). Option c does have 3 dots but changes the shape (square instead of triangle, wrong row). Option a is a triangle with only 1 dot (repeating the first column). Check both rules at once: the right shape AND the right count.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e08002b-407c-5994-9cc1-ec2f68d12bc8', '661d5164-6f02-5ef0-b676-cf1083ec6a98', '3×3 matrix: on each row, the third cell is the OVERLAY (the two figures drawn together) of the first two. Which figure completes the missing cell (bottom right)? <svg viewBox="0 0 100 100"><line x1="34" y1="4" x2="34" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="34" x2="96" y2="34" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#9ca3af" stroke-width="1"/><line x1="19" y1="10" x2="19" y2="28" stroke="#1f2937" stroke-width="2"/><line x1="42" y1="19" x2="58" y2="19" stroke="#1f2937" stroke-width="2"/><line x1="73" y1="10" x2="73" y2="28" stroke="#1f2937" stroke-width="2"/><line x1="73" y1="19" x2="89" y2="19" stroke="#1f2937" stroke-width="2"/><circle cx="19" cy="50" r="9" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="42" y1="50" x2="58" y2="50" stroke="#1f2937" stroke-width="2"/><circle cx="82" cy="50" r="9" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="74" y1="50" x2="90" y2="50" stroke="#1f2937" stroke-width="2"/><rect x="11" y="75" width="16" height="16" fill="none" stroke="#1f2937" stroke-width="2"/><circle cx="50" cy="83" r="8" fill="none" stroke="#1f2937" stroke-width="2"/><text x="78" y="88" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,26 74,72 26,72\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"56\" r=\"16\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'a', 'The hidden rule: on each row, the 3rd cell shows the first two figures overlaid. Row 1: vertical line + horizontal line = a cross. Row 2: circle + horizontal line = a crossed-out circle. Row 3: a square (cell 1) and a circle (cell 2), so the missing cell must show the square AND the circle overlaid. ✓ Option a combines the square and the circle: it is the right one. Option b keeps only the square (forgetting the 2nd figure). Option c keeps only the circle (forgetting the 1st figure). Option d adds a triangle that appears nowhere on the row (invented figure). The overlay adds exactly the two given figures together, without removing or inventing any.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('001ec5da-e35f-5604-b687-d91df3de8f37', '8f816f7e-6684-527f-a6ae-9c1b3f03a4a5', 'iq-training-en', '👑 Logic Elite ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3a2d82f-5c91-549b-966d-6de1f970a0f8', '001ec5da-e35f-5604-b687-d91df3de8f37', '3×3 matrix: look at the number of black dots in each cell. Which figure completes the cell marked « ? » (bottom right)? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="1.5" fill="none"><rect x="4" y="4" width="92" height="92"/><line x1="34.7" y1="4" x2="34.7" y2="96"/><line x1="65.3" y1="4" x2="65.3" y2="96"/><line x1="4" y1="34.7" x2="96" y2="34.7"/><line x1="4" y1="65.3" x2="96" y2="65.3"/></g><g fill="#1e293b"><circle cx="19" cy="19" r="3.5"/><circle cx="45" cy="15" r="3.5"/><circle cx="55" cy="23" r="3.5"/><circle cx="73" cy="14" r="3.5"/><circle cx="81" cy="19" r="3.5"/><circle cx="88" cy="24" r="3.5"/><circle cx="19" cy="50" r="3.5"/><circle cx="45" cy="46" r="3.5"/><circle cx="55" cy="54" r="3.5"/><circle cx="73" cy="45" r="3.5"/><circle cx="81" cy="50" r="3.5"/><circle cx="88" cy="55" r="3.5"/><circle cx="19" cy="81" r="3.5"/><circle cx="45" cy="77" r="3.5"/><circle cx="55" cy="85" r="3.5"/></g><text x="81" y="86" font-size="14" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#1e293b\"><circle cx=\"38\" cy=\"50\" r=\"6\"/><circle cx=\"62\" cy=\"50\" r=\"6\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#1e293b\"><circle cx=\"30\" cy=\"50\" r=\"6\"/><circle cx=\"50\" cy=\"50\" r=\"6\"/><circle cx=\"70\" cy=\"50\" r=\"6\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#1e293b\"><circle cx=\"25\" cy=\"50\" r=\"6\"/><circle cx=\"42\" cy=\"50\" r=\"6\"/><circle cx=\"58\" cy=\"50\" r=\"6\"/><circle cx=\"75\" cy=\"50\" r=\"6\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#1e293b\"><circle cx=\"50\" cy=\"50\" r=\"6\"/></g></svg>"}]'::jsonb, 'b', 'Hidden rule: the number of dots depends ONLY on the column — column 1 = 1 dot, column 2 = 2 dots, column 3 = 3 dots, the same on every row. The « ? » cell is in column 3, so 3 dots are needed. ✓ option b. Trap a (2 dots): copying the middle column. Trap c (4 dots): continuing at +1 instead of stopping at column 3. Trap d (1 dot): confusing it with the left column.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('574fe6c0-baf1-52cd-b485-eda624bee5fd', '001ec5da-e35f-5604-b687-d91df3de8f37', 'Sequence of figures: observe how each shape changes to become the next one. Which figure replaces the « ? »? <svg viewBox="0 0 100 100"><g fill="none" stroke="#1e293b" stroke-width="3"><polygon points="15,38 25,22 35,38"/><polygon points="42,22 58,22 58,38 42,38"/><polygon points="75,21 84,28 80,38 70,38 66,28"/></g><text x="25" y="52" font-size="9" text-anchor="middle" fill="#64748b">3 côtés</text><text x="50" y="52" font-size="9" text-anchor="middle" fill="#64748b">4 côtés</text><text x="75" y="52" font-size="9" text-anchor="middle" fill="#64748b">5 côtés</text><text x="50" y="78" font-size="14" text-anchor="middle" fill="#ef4444">? = forme suivante</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"35,30 65,30 65,60 35,60\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 70,38 66,60 34,60 30,38\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,28 60,28 72,45 60,62 40,62 28,45\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,26 62,34 68,48 62,62 50,70 38,62 32,48 38,34\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'c', 'Rule: at each step the shape gains exactly ONE side — triangle (3), square (4), pentagon (5). The next figure must therefore have 6 sides: a hexagon. ✓ option c. Trap b (pentagon, 5 sides): copying the last shape without adding a side. Trap d (octagon, 8 sides): jumping past 6. Trap a (square, 4 sides): going backward in the sequence instead of forward.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc4968de-b5be-53e3-a01b-317f6e1c7b36', '001ec5da-e35f-5604-b687-d91df3de8f37', 'Analogy: A is to B as C is to ? — discover the transformation that leads from A to B, then apply it to C. <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="12" y1="42" x2="12" y2="18"/><polyline points="7,25 12,18 17,25"/></g><text x="24" y="34" font-size="12" fill="#1e293b">→</text><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="34" y1="30" x2="58" y2="30"/><polyline points="51,25 58,30 51,35"/></g><text x="68" y="34" font-size="11" fill="#64748b">::</text><g stroke="#1e293b" stroke-width="4" fill="none"><line x1="86" y1="30" x2="62" y2="30"/><polyline points="69,25 62,30 69,35"/></g><text x="50" y="78" font-size="13" text-anchor="middle" fill="#ef4444">C → ?</text><text x="50" y="92" font-size="9" text-anchor="middle" fill="#64748b">A: vers le haut, B: vers la droite, C: vers la gauche</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"50\" y1=\"68\" x2=\"50\" y2=\"32\"/><polyline points=\"42,42 50,32 58,42\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"50\" y1=\"32\" x2=\"50\" y2=\"68\"/><polyline points=\"42,58 50,68 58,58\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"32\" y1=\"50\" x2=\"68\" y2=\"50\"/><polyline points=\"58,42 68,50 58,58\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"4\" fill=\"none\"><line x1=\"68\" y1=\"50\" x2=\"32\" y2=\"50\"/><polyline points=\"42,42 32,50 42,58\"/></g></svg>"}]'::jsonb, 'a', 'Rule: from A to B the arrow turns a quarter turn (90°) clockwise — up becomes right. Apply the same clockwise rotation to C, which points LEFT: left turned a clockwise quarter turn becomes UP. ✓ option a (arrow pointing up). Trap b (pointing down): that is a counter-clockwise rotation, wrong direction. Trap d (pointing left): copying C without turning it. Trap c (pointing right): that is a 180° rotation, two quarter turns instead of one.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d32b50be-a4d1-5ad1-990c-9a40bef48785', '001ec5da-e35f-5604-b687-d91df3de8f37', 'Odd one out: three of these figures obey the same rule, only one breaks it. Which is the odd one out? <svg viewBox="0 0 100 100"><text x="50" y="44" font-size="11" text-anchor="middle" fill="#1e293b">Un point et un contour par figure.</text><text x="50" y="60" font-size="11" text-anchor="middle" fill="#1e293b">Trouve celle qui sort du lot.</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"26\" y=\"26\" width=\"48\" height=\"48\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,22 76,68 24,68\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"54\" r=\"5\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"44\" cy=\"50\" r=\"22\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"82\" cy=\"50\" r=\"5\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'd', 'Rule: in each figure the black dot must lie INSIDE the outline. Circle+dot inside (a), square+dot inside (b), triangle+dot inside (c) obey the rule. In (d) the dot is placed OUTSIDE the circle: that is the odd one out. ✓ option d. Trap a, b, c: these are different shapes (circle, square, triangle), but the shape of the outline is not the rule — all that matters is that the dot be inside, which makes them all compliant.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b057b408-8e39-509a-b3e9-edc2976fc177', '001ec5da-e35f-5604-b687-d91df3de8f37', 'Logical deduction. We know that: (1) All Glips are Bromes. (2) No Brome is a Zarn. (3) Milo is a Glip. Which conclusion is NECESSARILY true?', '[{"id":"a","text":"Milo is a Zarn."},{"id":"b","text":"Milo is not a Zarn."},{"id":"c","text":"Some Bromes are Zarns."},{"id":"d","text":"Milo is not a Brome."}]'::jsonb, 'b', 'Rule: chain the implications. Milo is a Glip (3), and all Glips are Bromes (1), so Milo is a Brome. And no Brome is a Zarn (2), so Milo is NOT a Zarn. ✓ option b. Trap a: opposite conclusion, it contradicts (2). Trap d: false, we just deduced that Milo IS a Brome via (1). Trap c: directly contradicts (2), which says that NO Brome is a Zarn.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5daf7517-dc06-5880-8672-6576b1723bb7', '001ec5da-e35f-5604-b687-d91df3de8f37', 'Number sequence: 2, 6, 12, 20, 30, ? — find the hidden rule that links each term to the next, then give the missing number.', '[{"id":"a","text":"40"},{"id":"b","text":"42"},{"id":"c","text":"36"},{"id":"d","text":"56"}]'::jsonb, 'b', 'Rule: the gaps between terms increase by 2 each time — +4, +6, +8, +10, so the next gap is +12. 30 + 12 = 42. ✓ (another reading: each term equals n×(n+1): 1×2, 2×3, 3×4, 4×5, 5×6, then 6×7 = 42). Trap a (40): reusing the last gap +10 instead of +12. Trap c (36): taking a gap of +6, repeating an earlier jump. Trap d (56): that is 7×8, skipping a term of the sequence.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('914c2043-32fe-5bfa-8a7d-ee2a1192f5e6', '5b56de20-a91e-5db0-876f-b6ec0ed4d85d', 'iq-training-en', 'Math Reasoning Warm-up ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c7acf680-2963-5ff7-a9c0-857a4e2fac72', '914c2043-32fe-5bfa-8a7d-ee2a1192f5e6', 'Observe the number sequence and find the hidden rule: 3, 6, 9, 12, ? — which number comes next?', '[{"id":"a","text":"15"},{"id":"b","text":"13"},{"id":"c","text":"16"},{"id":"d","text":"24"}]'::jsonb, 'a', 'The hidden rule: you add 3 at each step (3, 6, 9, 12…). ✓ So the next term is 12 + 3 = 15, which is option a. Option b (13) adds only 1, as if you were just counting on. Option c (16) adds 4: that''s the right type of operation but the wrong step. Option d (24) doubles the last term instead of continuing the steady addition.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e0b9f1e4-40d8-5b2e-a872-1df54ca44908', '914c2043-32fe-5bfa-8a7d-ee2a1192f5e6', 'Complete the analogy by keeping the same relation: 3 is to 6 as 5 is to ? (Hint: by what must you multiply 3 to get 6?)', '[{"id":"a","text":"11"},{"id":"b","text":"15"},{"id":"c","text":"10"},{"id":"d","text":"25"}]'::jsonb, 'c', 'The hidden relation: you multiply by 2 (3 × 2 = 6). ✓ Apply the same rule to 5: 5 × 2 = 10, which is option c. Option a (11) adds 5 + 6, that is, it adds the result of the first pair instead of reusing its rule. Option b (15) multiplies by 3 (5 × 3), taking the first number of the model as the factor instead of the “×2”. Option d (25) squares 5: you switch operations midway.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a80a236-1b3d-5cd5-9016-8b09f9319806', '914c2043-32fe-5bfa-8a7d-ee2a1192f5e6', 'In this grid, the two rows have the same sum. Which number is missing where the “?” is? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="15" y="15" width="70" height="70" fill="none" stroke="#1d4ed8" stroke-width="2"/><line x1="38" y1="15" x2="38" y2="85" stroke="#1d4ed8" stroke-width="1.5"/><line x1="62" y1="15" x2="62" y2="85" stroke="#1d4ed8" stroke-width="1.5"/><line x1="15" y1="50" x2="85" y2="50" stroke="#1d4ed8" stroke-width="1.5"/><text x="26" y="37" font-size="13" fill="#0f172a" text-anchor="middle">2</text><text x="50" y="37" font-size="13" fill="#0f172a" text-anchor="middle">4</text><text x="74" y="37" font-size="13" fill="#0f172a" text-anchor="middle">3</text><text x="26" y="73" font-size="13" fill="#0f172a" text-anchor="middle">5</text><text x="50" y="73" font-size="13" fill="#0f172a" text-anchor="middle">?</text><text x="74" y="73" font-size="13" fill="#be123c" text-anchor="middle">2</text></svg>', '[{"id":"a","text":"4"},{"id":"b","text":"2"},{"id":"c","text":"9"},{"id":"d","text":"5"}]'::jsonb, 'b', 'The rule: the two rows have the same sum. The top row is 2 + 4 + 3 = 9. ✓ The bottom row must also be 9: 5 + ? + 2 = 9, so ? = 9 − 7 = 2, which is option b. Option a (4) just copies a neighbor without computing. Option c (9) gives the total sum of a row instead of the missing cell. Option d (5) repeats the first number of the row instead of completing the sum.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('10668bc9-c6ca-5507-9835-81c6f9a6468b', '914c2043-32fe-5bfa-8a7d-ee2a1192f5e6', 'A recipe uses 2 eggs for 6 pancakes. Keeping the same proportion, how many eggs are needed for 12 pancakes?', '[{"id":"a","text":"8"},{"id":"b","text":"6"},{"id":"c","text":"4"},{"id":"d","text":"3"}]'::jsonb, 'c', 'The rule: the number of pancakes doubles (6 → 12), so everything doubles to keep the same proportion. ✓ You need 2 × 2 = 4 eggs, which is option c. Option a (8) adds 6 to the eggs just as 6 was added to the pancakes: it adds instead of keeping the ratio. Option b (6) copies the starting number of pancakes. Option d (3) adds only 1, ignoring the doubling.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6fd2f0e-40b4-5432-bab3-4c200fb648e5', '914c2043-32fe-5bfa-8a7d-ee2a1192f5e6', 'Each shape contains a number. The rule is the same from one shape to the next. Which number must replace the “?” in the last shape? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="15" cy="50" r="11" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="15" y="55" font-size="13" fill="#0f172a" text-anchor="middle">1</text><circle cx="39" cy="50" r="11" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="39" y="55" font-size="13" fill="#0f172a" text-anchor="middle">2</text><circle cx="63" cy="50" r="11" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="63" y="55" font-size="13" fill="#0f172a" text-anchor="middle">4</text><circle cx="87" cy="50" r="11" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="87" y="55" font-size="13" fill="#be123c" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"5"},{"id":"b","text":"6"},{"id":"c","text":"8"},{"id":"d","text":"16"}]'::jsonb, 'c', 'The hidden rule: each number is double the previous one (1, then 2, then 4…). ✓ The next one is 4 × 2 = 8, which is option c. With three given terms (1, 2, 4), only the “×2” rule fits: addition is ruled out because the gap changes (from 1 to 2, then from 2 to 4). Option a (5) adds 1 to the last term. Option b (6) adds the last gap (4 + 2) instead of doubling. Option d (16) doubles twice (skips a step).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('70ba8162-4ecf-57ef-8f32-f6e5f0896d11', '5b56de20-a91e-5db0-876f-b6ec0ed4d85d', 'iq-training-en', '⭐ Warm-up', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ec59bb07-440b-5917-945d-789568f909d1', '70ba8162-4ecf-57ef-8f32-f6e5f0896d11', 'Observe the sequence and find the hidden rule: 4, 7, 10, 13, ? Which number comes next?', '[{"id":"a","text":"16"},{"id":"b","text":"15"},{"id":"c","text":"17"},{"id":"d","text":"26"}]'::jsonb, 'a', 'The rule is: +3 at each step (7−4 = 3, 10−7 = 3, 13−10 = 3). So the next number is 13 + 3 = 16 → option a ✓. The trap: b (15) adds only 2, c (17) adds 4, and d (26) doubles the last number. The gap between two terms stays constant and equals 3.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e4e1e2b-de40-5e2e-af46-4bff1183fe33', '70ba8162-4ecf-57ef-8f32-f6e5f0896d11', 'Find the rule common to both examples, then apply it: 2 → 4, 3 → 6, so 5 → ?', '[{"id":"a","text":"8"},{"id":"b","text":"10"},{"id":"c","text":"9"},{"id":"d","text":"11"}]'::jsonb, 'b', 'With two examples, only one rule works for BOTH: you multiply by 2. Check: 2 × 2 = 4 and 3 × 2 = 6 ✓. Apply it to 5: 5 × 2 = 10 → option b ✓. The trap: a (8) assumes “add 3” (3 + 3 = 6), but that rule fails on the first example (2 + 3 = 5 ≠ 4), so it is eliminated; c (9) does 5 + 4 and d (11) does 5 + 6, neither of which fits either example. Only multiplying by 2 reproduces 4 and 6, so 5 gives 10.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c416bc25-368a-541d-93aa-0220328e1bab', '70ba8162-4ecf-57ef-8f32-f6e5f0896d11', 'In this grid, each row follows the same rule: the first two cells add up to give the third. Which number replaces the “?” ? <svg viewBox="0 0 100 100"><rect x="10" y="15" width="80" height="70" fill="none" stroke="#222" stroke-width="2"/><line x1="36" y1="15" x2="36" y2="85" stroke="#222" stroke-width="2"/><line x1="63" y1="15" x2="63" y2="85" stroke="#222" stroke-width="2"/><line x1="10" y1="38" x2="90" y2="38" stroke="#222" stroke-width="2"/><line x1="10" y1="61" x2="90" y2="61" stroke="#222" stroke-width="2"/><text x="23" y="31" font-size="13" text-anchor="middle" fill="#222">2</text><text x="49" y="31" font-size="13" text-anchor="middle" fill="#222">3</text><text x="76" y="31" font-size="13" text-anchor="middle" fill="#222">5</text><text x="23" y="54" font-size="13" text-anchor="middle" fill="#222">4</text><text x="49" y="54" font-size="13" text-anchor="middle" fill="#222">1</text><text x="76" y="54" font-size="13" text-anchor="middle" fill="#222">5</text><text x="23" y="77" font-size="13" text-anchor="middle" fill="#222">3</text><text x="49" y="77" font-size="13" text-anchor="middle" fill="#222">4</text><text x="76" y="77" font-size="15" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"5"},{"id":"b","text":"12"},{"id":"c","text":"7"},{"id":"d","text":"1"}]'::jsonb, 'c', 'The rule, readable on the first two rows: cell3 = cell1 + cell2 (2 + 3 = 5, then 4 + 1 = 5). For the last row: 3 + 4 = 7 → option c ✓. The trap: a (5) copies the result of the other rows instead of computing, b (12) multiplies 3 × 4, and d (1) subtracts 4 − 3. The right operation is adding the first two cells.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('903e2aa2-b0de-5e6f-98cf-b23c93b0da29', '70ba8162-4ecf-57ef-8f32-f6e5f0896d11', 'Observe the sequence and find the hidden rule: 2, 4, 6, 8, ? Which number comes next?', '[{"id":"a","text":"9"},{"id":"b","text":"16"},{"id":"c","text":"12"},{"id":"d","text":"10"}]'::jsonb, 'd', 'The rule is: +2 at each step, these are the even numbers (2, 4, 6, 8…). The next one is 8 + 2 = 10 → option d ✓. The trap: a (9) adds 1 and gives an odd number, b (16) doubles the last term, and c (12) skips a step (+4). You move steadily by 2, so after 8 comes 10.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8128da2-22b8-576a-a60a-eaf287deb214', '70ba8162-4ecf-57ef-8f32-f6e5f0896d11', '2 identical marbles cost 6 gold coins. At the same price per marble, how much do 5 marbles cost?', '[{"id":"a","text":"9"},{"id":"b","text":"15"},{"id":"c","text":"12"},{"id":"d","text":"30"}]'::jsonb, 'b', 'First find the price of one marble: 6 ÷ 2 = 3 coins. For 5 marbles: 5 × 3 = 15 → option b ✓. The trap: a (9) just adds 3 to 6 (as if going from 2 to 3 marbles), c (12) doubles the price of 2 marbles, and d (30) multiplies 6 by 5 without reducing to the unit price. You must find the price of ONE marble, then multiply by 5.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da298d98-dc7b-5f31-b346-7c3d56a45260', '70ba8162-4ecf-57ef-8f32-f6e5f0896d11', 'In this pyramid, each number is the sum of the two numbers just below it. Which number goes at the very top? <svg viewBox="0 0 100 100"><rect x="38" y="10" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="50" y="26" font-size="15" text-anchor="middle" fill="#888">?</text><rect x="24" y="39" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="36" y="55" font-size="13" text-anchor="middle" fill="#222">5</text><rect x="52" y="39" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="64" y="55" font-size="13" text-anchor="middle" fill="#222">8</text><rect x="10" y="68" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="22" y="84" font-size="13" text-anchor="middle" fill="#222">2</text><rect x="38" y="68" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="50" y="84" font-size="13" text-anchor="middle" fill="#222">3</text><rect x="66" y="68" width="24" height="22" fill="none" stroke="#222" stroke-width="2"/><text x="78" y="84" font-size="13" text-anchor="middle" fill="#222">5</text></svg>', '[{"id":"a","text":"10"},{"id":"b","text":"23"},{"id":"c","text":"13"},{"id":"d","text":"15"}]'::jsonb, 'c', 'The rule checks out on the base: 2 + 3 = 5 and 3 + 5 = 8, which are indeed the two middle cells. So the top equals 5 + 8 = 13 → option c ✓. The trap: a (10) adds the ends of the base (2 + 3 + 5 = 10), b (23) adds all the displayed numbers, and d (15) adds 2 to the top. The top is the sum of the TWO cells just below it, that is 5 + 8 = 13.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e0d03861-160e-583e-8835-efa297fd5c14', '5b56de20-a91e-5db0-876f-b6ec0ed4d85d', 'iq-training-en', '⚔️ Math Reasoning Challenge ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b429e76-e8ce-5215-8555-fc26060f06c8', 'e0d03861-160e-583e-8835-efa297fd5c14', 'Observe the sequence and find the hidden rule. Which number comes next? 2, 5, 4, 7, 6, ?', '[{"id":"a","text":"9"},{"id":"b","text":"8"},{"id":"c","text":"5"},{"id":"d","text":"10"}]'::jsonb, 'a', 'The hidden rule alternates two operations: +3 then −1, and so on. 2 (+3)→5 (−1)→4 (+3)→7 (−1)→6 (+3)→9. ✓ After the last 6, it''s a +3 turn, so 9. Option b (8) applies +2 as if the gap were constant. Option c (5) applies −1 when it''s the +3 turn. Option d (10) applies +4 (one notch too far). Tip: when a sequence goes up then down, look for two operations that alternate.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1aef79c5-a89d-52de-b91c-d3372b8b6d4d', 'e0d03861-160e-583e-8835-efa297fd5c14', 'Find the hidden relation between the first number and the second, then apply it. 2 → 4, 3 → 9, so 5 → ?', '[{"id":"a","text":"15"},{"id":"b","text":"10"},{"id":"c","text":"25"},{"id":"d","text":"11"}]'::jsonb, 'c', 'The hidden rule: you square the number (n × n). 2 → 2×2 = 4 ✓ and 3 → 3×3 = 9 ✓, so 5 → 5×5 = 25. ✓ The correct answer is 25. The two examples rule out the false leads: option a (15) assumes ×3, but ×3 would give 2→6 (≠4), so that rule doesn''t hold. Option b (10) applies ×2, which would give 3→6 (≠9). Option d (11) adds 6, which would give 2→8 (≠4). Only squaring works for BOTH starting pairs. Always check that one and the same rule works for ALL known pairs before applying it to the new one.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae07ccc3-a102-5d81-91e9-1f288a0421fa', 'e0d03861-160e-583e-8835-efa297fd5c14', 'In this grid, each row follows the same calculation rule linking its three numbers. Which number replaces the “?” ? <svg viewBox="0 0 100 100"><line x1="4" y1="36" x2="96" y2="36" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="64" x2="96" y2="64" stroke="#9ca3af" stroke-width="1"/><line x1="35" y1="6" x2="35" y2="94" stroke="#9ca3af" stroke-width="1"/><line x1="65" y1="6" x2="65" y2="94" stroke="#9ca3af" stroke-width="1"/><text x="15" y="26" font-size="13" fill="#1f2937">4</text><text x="45" y="26" font-size="13" fill="#1f2937">3</text><text x="75" y="26" font-size="13" fill="#1f2937">7</text><text x="15" y="55" font-size="13" fill="#1f2937">6</text><text x="45" y="55" font-size="13" fill="#1f2937">2</text><text x="75" y="55" font-size="13" fill="#1f2937">8</text><text x="15" y="84" font-size="13" fill="#1f2937">5</text><text x="45" y="84" font-size="13" fill="#1f2937">3</text><text x="74" y="84" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"2"},{"id":"b","text":"8"},{"id":"c","text":"15"},{"id":"d","text":"7"}]'::jsonb, 'b', 'The hidden rule: on each row, the 3rd column is the sum of the first two. Row 1: 4+3 = 7 ✓. Row 2: 6+2 = 8 ✓. Row 3: 5+3 = 8, so “?” = 8. ✓ The correct answer is 8. Option a (2) takes the difference (5−3) instead of the sum. Option c (15) multiplies (5×3). Option d (7) copies the result of row 1 without recomputing. Test your rule on ALL known rows before applying it to the unknown row.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('014178ad-7ab2-594b-b73c-da764171c196', 'e0d03861-160e-583e-8835-efa297fd5c14', 'A recipe always keeps the same ratio: 2 measures of flour make 6 cakes. Keeping this ratio, how many cakes do 5 measures make? <svg viewBox="0 0 100 100"><rect x="6" y="30" width="40" height="40" fill="none" stroke="#9ca3af" stroke-width="1.5"/><text x="14" y="45" font-size="9" fill="#1f2937">2 mes.</text><text x="13" y="62" font-size="9" fill="#1f2937">6 gal.</text><text x="50" y="54" font-size="14" fill="#1f2937">→</text><rect x="60" y="30" width="40" height="40" fill="none" stroke="#9ca3af" stroke-width="1.5"/><text x="68" y="45" font-size="9" fill="#1f2937">5 mes.</text><text x="73" y="63" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"9"},{"id":"b","text":"12"},{"id":"c","text":"30"},{"id":"d","text":"15"}]'::jsonb, 'd', 'The hidden rule: the cakes/measure ratio is constant. 6 cakes for 2 measures = 3 cakes per measure. So 5 measures → 5 × 3 = 15 cakes. ✓ The correct answer is 15. Option a (9) adds 3 (6+3) instead of keeping the proportion. Option b (12) simply doubles the 6 without accounting for going from 2 to 5 measures. Option c (30) multiplies 6 by 5, forgetting that 6 corresponds to 2 measures, not 1. With a proportion, first reduce to a single unit (here 1 measure).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29682f91-ac06-5c3a-9b08-fc1617a8ea55', 'e0d03861-160e-583e-8835-efa297fd5c14', 'Magic square: each row, each column and each diagonal have the SAME sum. Which number must occupy the cell marked “?” ? <svg viewBox="0 0 100 100"><rect x="6" y="6" width="88" height="88" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="35" y1="6" x2="35" y2="94" stroke="#1f2937" stroke-width="1"/><line x1="65" y1="6" x2="65" y2="94" stroke="#1f2937" stroke-width="1"/><line x1="6" y1="35" x2="94" y2="35" stroke="#1f2937" stroke-width="1"/><line x1="6" y1="65" x2="94" y2="65" stroke="#1f2937" stroke-width="1"/><text x="16" y="26" font-size="13" fill="#1f2937">8</text><text x="46" y="26" font-size="13" fill="#1f2937">1</text><text x="76" y="26" font-size="13" fill="#1f2937">6</text><text x="16" y="55" font-size="13" fill="#1f2937">3</text><text x="46" y="55" font-size="13" fill="#1f2937">5</text><text x="75" y="55" font-size="14" fill="#1f2937">?</text><text x="16" y="85" font-size="13" fill="#1f2937">4</text><text x="46" y="85" font-size="13" fill="#1f2937">9</text><text x="76" y="85" font-size="13" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"7"},{"id":"b","text":"6"},{"id":"c","text":"8"},{"id":"d","text":"5"}]'::jsonb, 'a', 'The hidden rule: all rows, columns and diagonals have the same sum. The 1st row gives 8+1+6 = 15: the magic sum is 15. The middle row is 3+5+?, so ? = 15−3−5 = 7. ✓ Check with the right column: 6+7+2 = 15. The correct answer is 7. Option b (6) repeats the value of the top-right corner. Option d (5) copies the center. Option c (8) would give 3+5+8 = 16, which exceeds 15. First find the magic sum on a complete row, then deduce the missing cell by subtraction.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('076f87da-4ecf-534a-b7ff-50f5f356e342', 'e0d03861-160e-583e-8835-efa297fd5c14', 'This sequence hides a rule about the gaps between the numbers. Which number completes it? 2, 6, 12, 20, 30, ?', '[{"id":"a","text":"40"},{"id":"b","text":"44"},{"id":"c","text":"42"},{"id":"d","text":"36"}]'::jsonb, 'c', 'The hidden rule is read on the gaps: 6−2=4, 12−6=6, 20−12=8, 30−20=10. The gaps grow by 2 each time (4, 6, 8, 10), so the next gap is 12: 30+12 = 42. ✓ The correct answer is 42. Option a (40) keeps a gap of +10 as if it were constant. Option b (44) jumps to a gap of +14 (two notches too far). Option d (36) takes a gap of +6, going backwards. When the gap isn''t constant, look at the gap between the gaps: here it grows steadily by 2.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c6f3790b-15a6-5738-85c2-ed250ab40df2', '5b56de20-a91e-5db0-876f-b6ec0ed4d85d', 'iq-training-en', '👑 Math Reasoning Elite ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bf5632b-4aad-549b-80d6-e7f31dcdb017', 'c6f3790b-15a6-5738-85c2-ed250ab40df2', 'Observe the sequence and find the number that replaces the “?”: 2, 6, 12, 20, 30, ?', '[{"id":"a","text":"42"},{"id":"b","text":"40"},{"id":"c","text":"36"},{"id":"d","text":"38"}]'::jsonb, 'a', 'Hidden rule: the gap between two terms grows steadily by 2. The differences are 4, 6, 8, 10 (6−2=4, 12−6=6, 20−12=8, 30−20=10), so the next one is 12. 30 + 12 = 42. ✓ option a. (Another view: each term is n×(n+1): 1×2, 2×3, 3×4, 4×5, 5×6, then 6×7 = 42.) Trap b (40): you kept the last gap 10 instead of raising it to 12. Trap d (38): you added 8 instead of 12, repeating an older gap. Trap c (36): you assumed a constant gap of 6, which the sequence contradicts from the start.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3294d6c6-b239-5685-9209-cafa32ba80a2', 'c6f3790b-15a6-5738-85c2-ed250ab40df2', 'One same rule links the left number to the right one. 3 → 10 and 5 → 16. So 7 → ?', '[{"id":"a","text":"24"},{"id":"b","text":"21"},{"id":"c","text":"22"},{"id":"d","text":"20"}]'::jsonb, 'c', 'Hidden rule: you multiply by 3 then add 1. Check with BOTH given pairs: 3×3+1 = 10 ✓ and 5×3+1 = 16 ✓. Only one refined rule fits both examples, so 7×3+1 = 22. ✓ option c. Trap b (21): you multiplied by 3 but forgot the “+1” (7×3 = 21). Trap d (20): you saw “+7” (3+7=10) and applied +13, or added at random; that rule doesn''t work on 5 → 16. Trap a (24): you did ×3+3, which would give 12 for 3, so it''s wrong.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34d75a7d-c24d-5052-a933-712a1c89998b', 'c6f3790b-15a6-5738-85c2-ed250ab40df2', 'In this magic square, each row, each column and each diagonal has the SAME sum. Which number goes in the “?” cell? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="2" fill="none"><rect x="5" y="5" width="30" height="30"/><rect x="35" y="5" width="30" height="30"/><rect x="65" y="5" width="30" height="30"/><rect x="5" y="35" width="30" height="30"/><rect x="35" y="35" width="30" height="30"/><rect x="65" y="35" width="30" height="30"/><rect x="5" y="65" width="30" height="30"/><rect x="35" y="65" width="30" height="30"/><rect x="65" y="65" width="30" height="30"/></g><g font-size="15" text-anchor="middle" fill="#1e293b"><text x="20" y="25">8</text><text x="50" y="25">1</text><text x="80" y="25">6</text><text x="20" y="55">3</text><text x="50" y="55" fill="#ef4444">?</text><text x="80" y="55">7</text><text x="20" y="85">4</text><text x="50" y="85">9</text><text x="80" y="85">2</text></g></svg>', '[{"id":"a","text":"6"},{"id":"b","text":"5"},{"id":"c","text":"4"},{"id":"d","text":"7"}]'::jsonb, 'b', 'Rule: all rows/columns/diagonals share the same sum. One complete row gives it: 8 + 1 + 6 = 15, so the common sum is 15. The “?” cell is in the center; its row 3 + ? + 7 = 15 forces ? = 5. ✓ option b. You can verify: the column 1 + ? + 9 = 15 also gives 5, and the diagonal 8 + ? + 2 = 15 too. Three checks agree. Trap a (6): you took the sum 16 instead of 15, getting a reference row wrong. Trap c (4): you added only 3 + 7 + 1 without setting the right target sum. Trap d (7): you copied a neighboring value from the grid instead of computing.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6efadc7d-c83d-5c69-be20-40c289168371', 'c6f3790b-15a6-5738-85c2-ed250ab40df2', 'One same rule links the two top numbers to the bottom number in each triangle. Find the bottom number of the last triangle (the “?”). <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="1.5"><line x1="10" y1="22" x2="18" y2="55"/><line x1="26" y1="22" x2="18" y2="55"/><line x1="42" y1="22" x2="50" y2="55"/><line x1="58" y1="22" x2="50" y2="55"/><line x1="74" y1="22" x2="82" y2="55"/><line x1="90" y1="22" x2="82" y2="55"/></g><g stroke="#1e293b" stroke-width="1.5" fill="#e2e8f0"><circle cx="10" cy="22" r="9"/><circle cx="26" cy="22" r="9"/><circle cx="18" cy="60" r="9"/><circle cx="42" cy="22" r="9"/><circle cx="58" cy="22" r="9"/><circle cx="50" cy="60" r="9"/><circle cx="74" cy="22" r="9"/><circle cx="90" cy="22" r="9"/><circle cx="82" cy="60" r="9" fill="#fee2e2"/></g><g font-size="11" text-anchor="middle" fill="#1e293b"><text x="10" y="26">3</text><text x="26" y="26">4</text><text x="18" y="64">11</text><text x="42" y="26">2</text><text x="58" y="26">5</text><text x="50" y="64">9</text><text x="74" y="26">4</text><text x="90" y="26">6</text><text x="82" y="64" fill="#ef4444">?</text></g></svg>', '[{"id":"a","text":"22"},{"id":"b","text":"24"},{"id":"c","text":"10"},{"id":"d","text":"23"}]'::jsonb, 'd', 'Rule: bottom number = (product of the two top ones) − 1. You deduce it from the two complete triangles: 3×4 − 1 = 11 ✓ and 2×5 − 1 = 9 ✓. It''s the only rule that works for both. Apply it: 4×6 − 1 = 24 − 1 = 23. ✓ option d. Trap b (24): you took the product 4×6 but forgot to remove 1. Trap c (10): you added 4 + 6 then adjusted, confusing sum and product. Trap a (22): you removed 2 instead of 1, getting the constant wrong.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b11302e0-2939-5b38-a29f-7c2d1ed38705', 'c6f3790b-15a6-5738-85c2-ed250ab40df2', 'To make a syrup with the same taste, you need 12 glasses of water for 3 glasses of concentrate. How many glasses of water for 5 glasses of concentrate? <svg viewBox="0 0 100 100"><g font-size="9" fill="#1e293b"><text x="4" y="20">3 concentré</text><text x="4" y="58">5 concentré</text></g><g stroke="#1e293b" stroke-width="1"><rect x="4" y="24" width="12" height="10" fill="#fca5a5"/><rect x="16" y="24" width="12" height="10" fill="#fca5a5"/><rect x="28" y="24" width="12" height="10" fill="#fca5a5"/><rect x="4" y="62" width="12" height="10" fill="#fca5a5"/><rect x="16" y="62" width="12" height="10" fill="#fca5a5"/><rect x="28" y="62" width="12" height="10" fill="#fca5a5"/><rect x="40" y="62" width="12" height="10" fill="#fca5a5"/><rect x="52" y="62" width="12" height="10" fill="#fca5a5"/></g><g font-size="9" fill="#1e293b"><text x="50" y="32">+ 12 eau</text><text x="70" y="70" fill="#ef4444">+ ? eau</text></g></svg>', '[{"id":"a","text":"20"},{"id":"b","text":"14"},{"id":"c","text":"60"},{"id":"d","text":"36"}]'::jsonb, 'a', 'Rule: to keep the same taste, the water/concentrate ratio stays constant. Here 12 ÷ 3 = 4, so you need 4 glasses of water per glass of concentrate. For 5 concentrate: 5 × 4 = 20 glasses of water. ✓ option a. Trap b (14): additive reasoning — you added the difference in concentrate (5−3 = 2) to 12 instead of using the ratio. Trap c (60): you multiplied 12 by 5 (the total number of concentrates) instead of multiplying by the ratio. Trap d (36): you multiplied 12 by 3, reusing the old number of concentrates. A proportion is preserved by multiplying the ratio, not by adding.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0cce32a0-d076-5bb8-9e9b-513b0603cbef', 'c6f3790b-15a6-5738-85c2-ed250ab40df2', 'Observe the sequence and find the number that replaces the “?”: 1, 2, 6, 24, 120, ?', '[{"id":"a","text":"600"},{"id":"b","text":"720"},{"id":"c","text":"144"},{"id":"d","text":"840"}]'::jsonb, 'b', 'Hidden rule: you multiply by a factor that grows by 1 at each step. 1×2 = 2, 2×3 = 6, 6×4 = 24, 24×5 = 120, so the next step is ×6: 120 × 6 = 720. ✓ option b. Trap a (600): you kept the same factor (×5) instead of raising it to ×6. Trap c (144): you added the two last terms (120 + 24), a Fibonacci-style reflex that doesn''t fit the sequence. Trap d (840): you skipped a factor by multiplying by 7 instead of 6. The factor grows by exactly 1 at each step.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9e8580b3-7937-5964-a676-ea57ff9882f2', '85a8263d-abfc-5448-87a8-89fb39112787', 'iq-training-en', 'Fluid intelligence warm-up ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bccd5786-405b-51d6-ac4b-816f13dc3219', '9e8580b3-7937-5964-a676-ea57ff9882f2', 'Each box adds one dot compared to the previous one. How many dots go in the missing box? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="38" width="20" height="24" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="16" cy="50" r="3" fill="#1d4ed8"/><rect x="30" y="38" width="20" height="24" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="37" cy="50" r="3" fill="#1d4ed8"/><circle cx="45" cy="50" r="3" fill="#1d4ed8"/><rect x="54" y="38" width="20" height="24" fill="none" stroke="#1d4ed8" stroke-width="2"/><circle cx="60" cy="50" r="3" fill="#1d4ed8"/><circle cx="68" cy="50" r="3" fill="#1d4ed8"/><circle cx="64" cy="43" r="3" fill="#1d4ed8"/><rect x="78" y="38" width="20" height="24" fill="none" stroke="#1d4ed8" stroke-width="2"/><text x="88" y="55" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/><circle cx=\"46\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"54\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/><circle cx=\"46\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"54\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"46\" cy=\"54\" r=\"3\" fill=\"#1d4ed8\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/><circle cx=\"46\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"54\" cy=\"46\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"46\" cy=\"54\" r=\"3\" fill=\"#1d4ed8\"/><circle cx=\"54\" cy=\"54\" r=\"3\" fill=\"#1d4ed8\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#1d4ed8\" stroke-width=\"2\"/><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1d4ed8\"/></svg>"}]'::jsonb, 'c', 'The hidden rule: the number of dots increases by 1 in each box — 1, 2, 3… ✓ So the missing box must contain 4, which is option c. Option b (3 dots) repeats the previous box instead of increasing. Option a (2 dots) steps back one. Option d (1 dot) returns to the very start of the sequence.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7bd6bb4f-3399-5b94-9a9b-e3c72723fc4e', '9e8580b3-7937-5964-a676-ea57ff9882f2', 'A single rule acts on the triangle at each step. Which figure comes next? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="18,60 6,40 30,40" fill="none" stroke="#7c3aed" stroke-width="2"/><polygon points="45,60 33,40 57,40" fill="#7c3aed" stroke="#7c3aed" stroke-width="2"/><polygon points="72,60 60,40 84,40" fill="none" stroke="#7c3aed" stroke-width="2"/><text x="94" y="54" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,62 36,40 64,40\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,62 36,40 64,40\" fill=\"none\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"50,40 36,62 64,62\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\" fill=\"#7c3aed\" stroke=\"#7c3aed\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'The hidden rule: the fill alternates — empty, filled, empty… ✓ After the empty triangle, the next one must be filled, which is option a. Option b is empty: it repeats the previous step instead of alternating. Option c is indeed filled but flipped downward: the shape and orientation never changed in the sequence. Option d replaces the triangle with a square: only the colour changes, never the shape.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ec5c7302-4606-54ef-85e2-e52d6f3aab56', '9e8580b3-7937-5964-a676-ea57ff9882f2', 'In each box, the dot always moves one corner to the right (clockwise). Where will it be in the missing box? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="38" width="22" height="22" fill="none" stroke="#0f766e" stroke-width="2"/><circle cx="11" cy="43" r="3.5" fill="#0f766e"/><rect x="32" y="38" width="22" height="22" fill="none" stroke="#0f766e" stroke-width="2"/><circle cx="49" cy="43" r="3.5" fill="#0f766e"/><rect x="58" y="38" width="22" height="22" fill="none" stroke="#0f766e" stroke-width="2"/><circle cx="75" cy="55" r="3.5" fill="#0f766e"/><rect x="84" y="38" width="22" height="22" fill="none" stroke="#0f766e" stroke-width="2"/><text x="95" y="55" font-size="15" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/><circle cx=\"56\" cy=\"44\" r=\"3.5\" fill=\"#0f766e\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/><circle cx=\"44\" cy=\"56\" r=\"3.5\" fill=\"#0f766e\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/><circle cx=\"56\" cy=\"56\" r=\"3.5\" fill=\"#0f766e\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"38\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#0f766e\" stroke-width=\"2\"/><circle cx=\"44\" cy=\"44\" r=\"3.5\" fill=\"#0f766e\"/></svg>"}]'::jsonb, 'b', 'The hidden rule: the dot advances one corner clockwise in each box — top-left, top-right, bottom-right… ✓ The next corner clockwise is bottom-left, which is option b. Option c (bottom-right) repeats the previous box. Option a (top-right) steps back one. Option d (top-left) returns to the starting point, as if the loop were already complete.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2428aa0b-63bb-5b02-adda-d93b9f5f7e93', '9e8580b3-7937-5964-a676-ea57ff9882f2', 'We overlay the left box and the middle box: a corner is coloured in the result only if it is coloured in exactly one of the two boxes (never in both). What is the result? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="35" width="26" height="26" fill="none" stroke="#be123c" stroke-width="2"/><line x1="19" y1="35" x2="19" y2="61" stroke="#be123c" stroke-width="1"/><line x1="6" y1="48" x2="32" y2="48" stroke="#be123c" stroke-width="1"/><rect x="6" y="35" width="13" height="13" fill="#be123c"/><rect x="19" y="48" width="13" height="13" fill="#be123c"/><text x="42" y="52" font-size="16" fill="#64748b" text-anchor="middle">+</text><rect x="52" y="35" width="26" height="26" fill="none" stroke="#be123c" stroke-width="2"/><line x1="65" y1="35" x2="65" y2="61" stroke="#be123c" stroke-width="1"/><line x1="52" y1="48" x2="78" y2="48" stroke="#be123c" stroke-width="1"/><rect x="52" y="35" width="13" height="13" fill="#be123c"/><rect x="65" y="35" width="13" height="13" fill="#be123c"/><text x="88" y="52" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"37\" y=\"37\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><line x1=\"50\" y1=\"37\" x2=\"50\" y2=\"63\" stroke=\"#be123c\" stroke-width=\"1\"/><line x1=\"37\" y1=\"50\" x2=\"63\" y2=\"50\" stroke=\"#be123c\" stroke-width=\"1\"/><rect x=\"50\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"50\" y=\"50\" width=\"13\" height=\"13\" fill=\"#be123c\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"37\" y=\"37\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><line x1=\"50\" y1=\"37\" x2=\"50\" y2=\"63\" stroke=\"#be123c\" stroke-width=\"1\"/><line x1=\"37\" y1=\"50\" x2=\"63\" y2=\"50\" stroke=\"#be123c\" stroke-width=\"1\"/><rect x=\"37\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"37\" y=\"37\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><line x1=\"50\" y1=\"37\" x2=\"50\" y2=\"63\" stroke=\"#be123c\" stroke-width=\"1\"/><line x1=\"37\" y1=\"50\" x2=\"63\" y2=\"50\" stroke=\"#be123c\" stroke-width=\"1\"/><rect x=\"50\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"37\" y=\"50\" width=\"13\" height=\"13\" fill=\"#be123c\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"37\" y=\"37\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#be123c\" stroke-width=\"2\"/><line x1=\"50\" y1=\"37\" x2=\"50\" y2=\"63\" stroke=\"#be123c\" stroke-width=\"1\"/><line x1=\"37\" y1=\"50\" x2=\"63\" y2=\"50\" stroke=\"#be123c\" stroke-width=\"1\"/><rect x=\"37\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"50\" y=\"37\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"37\" y=\"50\" width=\"13\" height=\"13\" fill=\"#be123c\"/><rect x=\"50\" y=\"50\" width=\"13\" height=\"13\" fill=\"#be123c\"/></svg>"}]'::jsonb, 'a', 'The hidden rule: a corner is coloured only if it is coloured in exactly one of the two boxes. On the left, top-left and bottom-right are coloured; in the middle, top-left and top-right. The top-left is coloured in both: it switches off. ✓ Top-right and bottom-right remain, which is option a. Option d adds up all the coloured corners without switching any off. Option c keeps the shared top-left, which should have disappeared. Option b keeps only one corner and forgets one.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('078d8810-4aaa-5515-8491-edfab9b4a34d', '9e8580b3-7937-5964-a676-ea57ff9882f2', 'A single rule connects the first three boxes. Which figure completes the last box? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="15" cy="50" r="5" fill="none" stroke="#b45309" stroke-width="2"/><g stroke="#b45309" stroke-width="2" fill="none"><circle cx="38" cy="50" r="5"/><circle cx="38" cy="50" r="9"/></g><g stroke="#b45309" stroke-width="2" fill="none"><circle cx="63" cy="50" r="5"/><circle cx="63" cy="50" r="9"/><circle cx="63" cy="50" r="13"/></g><text x="88" y="55" font-size="16" fill="#64748b" text-anchor="middle">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g stroke=\"#b45309\" stroke-width=\"2\" fill=\"none\"><circle cx=\"50\" cy=\"50\" r=\"5\"/><circle cx=\"50\" cy=\"50\" r=\"9\"/><circle cx=\"50\" cy=\"50\" r=\"13\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g stroke=\"#b45309\" stroke-width=\"2\" fill=\"none\"><circle cx=\"50\" cy=\"50\" r=\"5\"/><circle cx=\"50\" cy=\"50\" r=\"9\"/><circle cx=\"50\" cy=\"50\" r=\"13\"/><circle cx=\"50\" cy=\"50\" r=\"17\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g stroke=\"#b45309\" stroke-width=\"2\" fill=\"none\"><circle cx=\"50\" cy=\"50\" r=\"5\"/><circle cx=\"50\" cy=\"50\" r=\"9\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"50\" cy=\"50\" r=\"5\" fill=\"none\" stroke=\"#b45309\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'The hidden rule: the number of concentric circles increases by 1 in each box — 1, 2, 3… ✓ The last box must contain 4, which is option b. Option a (3 circles) repeats the previous box instead of adding a circle. Option c (2 circles) steps back one. Option d (1 circle) returns to the very first box.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d749dba2-ccf5-543b-8338-ae70d12bb246', '85a8263d-abfc-5448-87a8-89fb39112787', 'iq-training-en', '⭐ Warm-up', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f300b72b-85ad-5e7c-aa4c-fa0b85252688', 'd749dba2-ccf5-543b-8338-ae70d12bb246', 'A hidden rule transforms the figure at each step: ONE more horizontal line is added inside the square (0, then 1, then 2…). What is the next step? <svg viewBox="0 0 100 100"><rect x="3" y="35" width="24" height="30" fill="none" stroke="#222" stroke-width="2"/><rect x="30" y="35" width="24" height="30" fill="none" stroke="#222" stroke-width="2"/><line x1="33" y1="50" x2="51" y2="50" stroke="#222" stroke-width="2"/><rect x="57" y="35" width="24" height="30" fill="none" stroke="#222" stroke-width="2"/><line x1="60" y1="45" x2="78" y2="45" stroke="#222" stroke-width="2"/><line x1="60" y1="55" x2="78" y2="55" stroke="#222" stroke-width="2"/><rect x="84" y="35" width="24" height="30" fill="none" stroke="#222" stroke-width="2" stroke-dasharray="3 3"/><text x="96" y="54" font-size="14" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"42\" x2=\"65\" y2=\"42\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"50\" x2=\"65\" y2=\"50\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"58\" x2=\"65\" y2=\"58\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"45\" x2=\"65\" y2=\"45\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"55\" x2=\"65\" y2=\"55\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"50\" y1=\"35\" x2=\"50\" y2=\"65\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"40\" y1=\"35\" x2=\"40\" y2=\"65\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"60\" y1=\"35\" x2=\"60\" y2=\"65\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><line x1=\"35\" y1=\"50\" x2=\"65\" y2=\"50\" stroke=\"#222\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'The hidden rule is: +1 horizontal line at each step (0, 1, 2, so next is 3). The next box must contain 3 horizontal lines → option a ✓. The trap: b repeats 2 lines (we forgot to add), d returns to 1 line (we read the sequence backwards) and c does put 3 lines but VERTICAL ones (wrong direction). Induce the rule, then apply it: 2 + 1 = 3 horizontal lines.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7d64b123-b606-5758-90f7-09272b9e651f', 'd749dba2-ccf5-543b-8338-ae70d12bb246', 'Group rule: a figure goes into the box only if it is FILLED (filled with black) AND carries a white cross at its centre. Which figure satisfies BOTH conditions? <svg viewBox="0 0 100 100"><circle cx="30" cy="32" r="14" fill="#222"/><line x1="24" y1="32" x2="36" y2="32" stroke="#fff" stroke-width="3"/><line x1="30" y1="26" x2="30" y2="38" stroke="#fff" stroke-width="3"/><rect x="58" y="18" width="28" height="28" fill="#222"/><line x1="64" y1="32" x2="80" y2="32" stroke="#fff" stroke-width="3"/><line x1="72" y1="24" x2="72" y2="40" stroke="#fff" stroke-width="3"/><text x="50" y="72" font-size="10" text-anchor="middle" fill="#222">PLEIN + croix = dans la boîte</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\" stroke=\"#222\" stroke-width=\"3\"/><line x1=\"50\" y1=\"38\" x2=\"50\" y2=\"62\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"#222\"/><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\" stroke=\"#fff\" stroke-width=\"4\"/><line x1=\"50\" y1=\"38\" x2=\"50\" y2=\"62\" stroke=\"#fff\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"24\" y=\"24\" width=\"52\" height=\"52\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\" stroke=\"#222\" stroke-width=\"3\"/><line x1=\"50\" y1=\"38\" x2=\"50\" y2=\"62\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'b', 'Both conditions must hold at once: the figure must be filled AND have a white cross at its centre. Only option b is black and filled WITH a white cross → b ✓. The trap: c is filled but has no cross (one condition is missing), a and d carry a cross but are empty (not filled). When a rule has two conditions, both must be true — one alone is not enough.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9009771f-0f4f-552d-85b8-1a62d64e1f89', 'd749dba2-ccf5-543b-8338-ae70d12bb246', 'A hidden rule governs size: the circle changes size by alternating big, small, big, small… Which circle comes next? <svg viewBox="0 0 100 100"><circle cx="16" cy="50" r="13" fill="none" stroke="#222" stroke-width="2"/><circle cx="42" cy="50" r="6" fill="none" stroke="#222" stroke-width="2"/><circle cx="68" cy="50" r="13" fill="none" stroke="#222" stroke-width="2"/><circle cx="90" cy="50" r="9" fill="none" stroke="#888" stroke-width="2" stroke-dasharray="3 3"/><text x="90" y="54" font-size="11" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"40\" y=\"40\" width=\"20\" height=\"20\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"26\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"10\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'd', 'The hidden rule alternates the size: big, small, big, so next is SMALL. The next circle is small → option d ✓. The trap: b brings back a big circle (we forgot the alternation), c is big AND filled (we change the fill on top of the size) and a is a square (we change the shape). Only one thing varies here: the size, which alternates.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('608950bb-aa4a-52a4-9b3e-99f392d0749f', 'd749dba2-ccf5-543b-8338-ae70d12bb246', 'Chain of transformations: watch how the triangle is transformed in the example on top, then apply EXACTLY the same transformation to the triangle at the bottom. What does it become? <svg viewBox="0 0 100 100"><polygon points="18,8 8,26 28,26" fill="#222"/><text x="36" y="22" font-size="14" fill="#222">→</text><polygon points="68,8 50,18 68,28" fill="#222"/><text x="50" y="45" font-size="9" text-anchor="middle" fill="#888">exemple : pointe en haut devient pointe à gauche</text><polygon points="50,58 40,76 60,76" fill="#222"/><text x="68" y="71" font-size="14" fill="#222">→</text><text x="88" y="71" font-size="16" fill="#888">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"38,30 38,70 62,50\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"62,30 62,70 38,50\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,40 70,40 50,68\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,38 70,38 50,18\" fill=\"#222\"/></svg>"}]'::jsonb, 'b', 'In the example, the triangle pointing UP turns into a triangle pointing LEFT (a quarter turn). The bottom triangle also points up, so it must point left → option b ✓. The trap: a points right (we turned the wrong way), c points down (a half turn, two quarter turns instead of one) and d points up (we transformed nothing). Reproduce exactly the transformation shown: up → left.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4d687f5-413f-5381-bb4c-d3b41fae0ef2', 'd749dba2-ccf5-543b-8338-ae70d12bb246', 'Visual analogy: the figure on the left transforms into the one on the right by a rule. Apply THE SAME rule to the new figure. The light square is to "a dark square OF THE SAME SIZE" as the light circle is to…? <svg viewBox="0 0 100 100"><rect x="6" y="30" width="20" height="20" fill="none" stroke="#222" stroke-width="2"/><text x="33" y="45" font-size="13" fill="#222">→</text><rect x="46" y="30" width="20" height="20" fill="#222"/><text x="78" y="45" font-size="13" fill="#222">| ?</text><circle cx="22" cy="78" r="20" fill="none" stroke="#222" stroke-width="2"/><text x="54" y="82" font-size="13" fill="#222">→</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"8\" fill=\"#222\"/></svg>"}]'::jsonb, 'a', 'The rule that transforms the first pair is: "keep the shape AND the size, but fill it with black" (the empty square becomes a filled square of the same side; neither shape nor size changes). Applied to the empty circle (radius 20), it gives a filled circle of the SAME radius 20 → option a ✓. The trap: b keeps the right size but stays empty (we did not apply the fill), c is filled but changes the shape to a square (we copy the model''s shape instead of the rule) and d is indeed filled but shrunk (radius 8 instead of 20: we added a size change that is not in the rule). Only a is a filled circle of the same size as the model.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83dd431e-f606-599d-badd-0da161f06ec5', 'd749dba2-ccf5-543b-8338-ae70d12bb246', 'Discover the hidden relationship: in each example figure, the number of dots inside is EQUAL to the number of sides of the polygon. The triangle (3 sides) contains 3 dots, the square (4 sides) contains 4 dots. How many dots must the pentagon (5 sides) contain? <svg viewBox="0 0 100 100"><polygon points="18,18 6,42 30,42" fill="none" stroke="#222" stroke-width="2"/><circle cx="18" cy="28" r="2" fill="#222"/><circle cx="14" cy="36" r="2" fill="#222"/><circle cx="22" cy="36" r="2" fill="#222"/><rect x="55" y="16" width="28" height="28" fill="none" stroke="#222" stroke-width="2"/><circle cx="63" cy="24" r="2" fill="#222"/><circle cx="75" cy="24" r="2" fill="#222"/><circle cx="63" cy="36" r="2" fill="#222"/><circle cx="75" cy="36" r="2" fill="#222"/><polygon points="50,58 68,71 61,90 39,90 32,71" fill="none" stroke="#222" stroke-width="2"/><text x="50" y="80" font-size="11" text-anchor="middle" fill="#888">?</text></svg>', '[{"id":"a","text":"3 dots"},{"id":"b","text":"4 dots"},{"id":"c","text":"5 dots"},{"id":"d","text":"6 dots"}]'::jsonb, 'c', 'The hidden relationship is: number of dots = number of sides. The triangle (3 sides) has 3 dots, the square (4 sides) has 4 dots; the pentagon has 5 sides, so 5 dots → option c ✓. The trap: b (4) copies the square''s total without recounting the sides, a (3) copies the triangle''s, and d (6) adds one dot too many (confusion with the hexagon). Deduce the rule, then count the pentagon''s sides: 5.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('df58fdd5-2325-512c-9b87-bd7cdb9f163f', '85a8263d-abfc-5448-87a8-89fb39112787', 'iq-training-en', '⚔️ Fluid intelligence challenge ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('65d61b15-55cb-5a90-87a3-ed327d3324ed', 'df58fdd5-2325-512c-9b87-bd7cdb9f163f', 'Brand-new rule: we overlay the first two grids. A dot stays in the result only if it appears in just ONE of the two grids (never in both). Which grid is the result? <svg viewBox="0 0 100 100"><rect x="4" y="34" width="28" height="28" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="18" y1="34" x2="18" y2="62" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="48" x2="32" y2="48" stroke="#9ca3af" stroke-width="1"/><circle cx="11" cy="41" r="3" fill="#1f2937"/><circle cx="25" cy="55" r="3" fill="#1f2937"/><text x="36" y="53" font-size="14" fill="#1f2937">+</text><rect x="48" y="34" width="28" height="28" fill="none" stroke="#1f2937" stroke-width="2"/><line x1="62" y1="34" x2="62" y2="62" stroke="#9ca3af" stroke-width="1"/><line x1="48" y1="48" x2="76" y2="48" stroke="#9ca3af" stroke-width="1"/><circle cx="55" cy="41" r="3" fill="#1f2937"/><circle cx="69" cy="41" r="3" fill="#1f2937"/><text x="80" y="53" font-size="14" fill="#1f2937">=</text><text x="90" y="53" font-size="14" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"75\" stroke=\"#9ca3af\" stroke-width=\"1\"/><line x1=\"25\" y1=\"50\" x2=\"75\" y2=\"50\" stroke=\"#9ca3af\" stroke-width=\"1\"/><circle cx=\"62\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"75\" stroke=\"#9ca3af\" stroke-width=\"1\"/><line x1=\"25\" y1=\"50\" x2=\"75\" y2=\"50\" stroke=\"#9ca3af\" stroke-width=\"1\"/><circle cx=\"37\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"75\" stroke=\"#9ca3af\" stroke-width=\"1\"/><line x1=\"25\" y1=\"50\" x2=\"75\" y2=\"50\" stroke=\"#9ca3af\" stroke-width=\"1\"/><circle cx=\"37\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"50\" y1=\"25\" x2=\"50\" y2=\"75\" stroke=\"#9ca3af\" stroke-width=\"1\"/><line x1=\"25\" y1=\"50\" x2=\"75\" y2=\"50\" stroke=\"#9ca3af\" stroke-width=\"1\"/><circle cx=\"37\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"37\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"37\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"62\" r=\"5\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'The hidden rule is an exclusive OR: we keep a filled cell only if it is marked in exactly one of the two grids. Grid 1 = top-left + bottom-right; grid 2 = top-left + top-right. The top-left cell is in both → it cancels out. Top-right (grid 2 only) and bottom-right (grid 1 only) remain. ✓ Option a shows exactly these two dots (top-right and bottom-right). Option b is the union (it keeps the shared top-left dot, the classic "add everything up" mistake). Option d is also the union, even more crowded. Option c keeps only the shared dot, the exact opposite of the rule (intersection). Mark a dot only when it appears in a single grid.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('124375bd-9245-55ad-b9b6-1a13ae118f39', 'df58fdd5-2325-512c-9b87-bd7cdb9f163f', 'Chain of transformation: watch how the polygon''s number of sides changes from one figure to the next, then continue the sequence. Which figure comes next? <svg viewBox="0 0 100 100"><polygon points="14,62 6,46 22,46" fill="none" stroke="#1f2937" stroke-width="2"/><rect x="30" y="42" width="18" height="18" fill="none" stroke="#1f2937" stroke-width="2"/><polygon points="64,40 73,47 70,58 58,58 55,47" fill="none" stroke="#1f2937" stroke-width="2"/><text x="84" y="56" font-size="16" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,22 68,34 74,54 62,72 38,72 26,54 32,34\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,24 70,38 62,62 38,62 30,38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,22 72,35 72,61 50,74 28,61 28,35\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'd', 'The hidden rule: the number of sides increases by 1 at each step. Triangle (3) → square (4) → pentagon (5) → ?. So the next figure must have 6 sides: a hexagon. ✓ Option d is a hexagon (6 sides): it is the right one. Option b is a pentagon (5 sides) and repeats the previous step without advancing. Option c is a square (4 sides); it steps back two notches. Option a is a heptagon (7 sides); it skips a notch (+2 instead of +1). Count the sides and keep the constant gap of +1.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b9a306e-aabb-5266-b40d-f5cc54688c92', 'df58fdd5-2325-512c-9b87-bd7cdb9f163f', 'Two attributes vary independently along the sequence: the SHAPE (circle / square, alternating) and the FILL (empty / filled, alternating). Which figure occupies the "?" box? <svg viewBox="0 0 100 100"><circle cx="14" cy="50" r="9" fill="none" stroke="#1f2937" stroke-width="2"/><rect x="30" y="41" width="18" height="18" fill="#1f2937" stroke="#1f2937" stroke-width="2"/><circle cx="66" cy="50" r="9" fill="none" stroke="#1f2937" stroke-width="2"/><text x="84" y="56" font-size="16" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"#1f2937\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"20\" fill=\"#1f2937\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'b', 'The hidden rule: two independent cycles to track separately. The shape alternates circle, square, circle, … so the 4th box is a SQUARE. The fill alternates empty, filled, empty, … so the 4th box is FILLED. The answer combines both: a filled square. ✓ Option b (filled square) respects shape = square AND fill = filled. Option a (empty square) has the right shape but reverses the fill. Option d (filled circle) has the right fill but keeps the previous shape (forgetting the shape alternation). Option c (empty circle) gets both attributes wrong at once. The common trap: tracking only one attribute; here you must advance the shape AND the fill, each in its own cycle.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0298a5ce-7e75-5a06-aea5-43c5e3a14230', 'df58fdd5-2325-512c-9b87-bd7cdb9f163f', 'Chain of transformation with TWO combined effects at each step: the arrow rotates 90° clockwise AND one extra dot appears (1, then 2, then 3…). Which figure continues the sequence? <svg viewBox="0 0 100 100"><line x1="14" y1="62" x2="14" y2="40" stroke="#1f2937" stroke-width="3"/><polygon points="14,34 9,44 19,44" fill="#1f2937"/><circle cx="14" cy="72" r="2.5" fill="#1f2937"/><line x1="40" y1="50" x2="62" y2="50" stroke="#1f2937" stroke-width="3"/><polygon points="68,50 58,45 58,55" fill="#1f2937"/><circle cx="46" cy="68" r="2.5" fill="#1f2937"/><circle cx="56" cy="68" r="2.5" fill="#1f2937"/><line x1="86" y1="40" x2="86" y2="62" stroke="#1f2937" stroke-width="3"/><polygon points="86,68 81,58 91,58" fill="#1f2937"/><circle cx="78" cy="34" r="2.5" fill="#1f2937"/><circle cx="86" cy="34" r="2.5" fill="#1f2937"/><circle cx="94" cy="34" r="2.5" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"60\" y1=\"40\" x2=\"38\" y2=\"40\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"32,40 42,34 42,46\" fill=\"#1f2937\"/><circle cx=\"38\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"50\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"62\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"40\" y1=\"40\" x2=\"62\" y2=\"40\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"68,40 58,34 58,46\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"44\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"56\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"60\" y1=\"40\" x2=\"38\" y2=\"40\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"32,40 42,34 42,46\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"44\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"56\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"66\" r=\"4\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"60\" x2=\"50\" y2=\"38\" stroke=\"#1f2937\" stroke-width=\"4\"/><polygon points=\"50,32 44,42 56,42\" fill=\"#1f2937\"/><circle cx=\"32\" cy=\"70\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"44\" cy=\"70\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"56\" cy=\"70\" r=\"4\" fill=\"#1f2937\"/><circle cx=\"68\" cy=\"70\" r=\"4\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'c', 'The hidden rule combines two simultaneous effects. Direction: up → right → down → ?, that is +90° clockwise at each step, so the next one points LEFT. Dots: 1, 2, 3, … so the next step has 4. ✓ Option c brings both together: arrow pointing left AND 4 dots. Option b does have 4 dots but the arrow points right (wrong rotation, a step backwards). Option a has the right direction (left) but only 3 dots (forgetting the +1). Option d keeps 4 dots but an arrow pointing up (skipping a quarter turn). ALWAYS apply both transformations together, never just one.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9915537-abe5-536a-a440-0c0762862698', 'df58fdd5-2325-512c-9b87-bd7cdb9f163f', '3×3 matrix, brand-new rule per row: the 3rd box is obtained by REMOVING from the 1st box the positions that are also occupied in the 2nd box (box 1 minus box 2). Which figure fills the missing box (bottom right)? <svg viewBox="0 0 100 100"><line x1="34" y1="4" x2="34" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="66" y1="4" x2="66" y2="96" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="34" x2="96" y2="34" stroke="#9ca3af" stroke-width="1"/><line x1="4" y1="66" x2="96" y2="66" stroke="#9ca3af" stroke-width="1"/><circle cx="12" cy="12" r="3" fill="#1f2937"/><circle cx="24" cy="12" r="3" fill="#1f2937"/><circle cx="12" cy="24" r="3" fill="#1f2937"/><circle cx="44" cy="12" r="3" fill="#1f2937"/><circle cx="56" cy="24" r="3" fill="#1f2937"/><circle cx="88" cy="12" r="3" fill="#1f2937"/><circle cx="76" cy="24" r="3" fill="#1f2937"/><circle cx="12" cy="44" r="3" fill="#1f2937"/><circle cx="24" cy="44" r="3" fill="#1f2937"/><circle cx="24" cy="56" r="3" fill="#1f2937"/><circle cx="56" cy="44" r="3" fill="#1f2937"/><circle cx="76" cy="44" r="3" fill="#1f2937"/><circle cx="88" cy="56" r="3" fill="#1f2937"/><circle cx="12" cy="76" r="3" fill="#1f2937"/><circle cx="24" cy="76" r="3" fill="#1f2937"/><circle cx="12" cy="88" r="3" fill="#1f2937"/><circle cx="24" cy="88" r="3" fill="#1f2937"/><circle cx="56" cy="76" r="3" fill="#1f2937"/><circle cx="44" cy="88" r="3" fill="#1f2937"/><circle cx="56" cy="88" r="3" fill="#1f2937"/><text x="76" y="86" font-size="16" fill="#1f2937">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"40\" cy=\"40\" r=\"6\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"60\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"40\" cy=\"40\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"40\" cy=\"60\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"40\" cy=\"40\" r=\"6\" fill=\"#1f2937\"/><circle cx=\"60\" cy=\"40\" r=\"6\" fill=\"#1f2937\"/><circle cx=\"40\" cy=\"60\" r=\"6\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'b', 'The hidden rule: box 3 = box 1, with every position already occupied in box 2 removed. Check it on the 1st row: box 1 occupies top-left, top-right, bottom-left; box 2 occupies top-left and bottom-right; remove the shared position (top-left) → top-right and bottom-left remain, that is 2 dots, exactly box 3. The 2nd row confirms it: {top-left, top-right, bottom-right} minus {top-right} = {top-left, bottom-right}, 2 dots. Last row: box 1 is full (top-left, top-right, bottom-left, bottom-right), box 2 occupies top-right, bottom-left, bottom-right; remove these three → ONLY top-left remains. ✓ Option b is a single dot at top-left: it is the right one. Option a keeps 2 dots (it removed only part of the shared positions). Option d keeps 3 dots (it adds up or forgets the subtraction). Option c does put 1 dot but at bottom-left, precisely a position cancelled by box 2. Subtract position by position: keep only what box 2 does not touch.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4d12c09-ba09-5c7b-aafb-48a6d978ee77', 'df58fdd5-2325-512c-9b87-bd7cdb9f163f', 'Brand-new rule to discover: a black token rotates around the corners of a square clockwise; at each step, the side of the square that CARRIES the token thickens (becomes a bold stroke). Which figure continues the sequence? <svg viewBox="0 0 100 100"><rect x="6" y="38" width="22" height="22" fill="none" stroke="#1f2937" stroke-width="1.5"/><line x1="6" y1="38" x2="28" y2="38" stroke="#1f2937" stroke-width="4"/><circle cx="6" cy="38" r="3.5" fill="#1f2937"/><rect x="40" y="38" width="22" height="22" fill="none" stroke="#1f2937" stroke-width="1.5"/><line x1="62" y1="38" x2="62" y2="60" stroke="#1f2937" stroke-width="4"/><circle cx="62" cy="38" r="3.5" fill="#1f2937"/><rect x="74" y="38" width="22" height="22" fill="none" stroke="#1f2937" stroke-width="1.5"/><line x1="74" y1="60" x2="96" y2="60" stroke="#1f2937" stroke-width="4"/><circle cx="96" cy="60" r="3.5" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"30\" y1=\"30\" x2=\"30\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"30\" y1=\"30\" x2=\"30\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"30\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"30\" y1=\"70\" x2=\"70\" y2=\"70\" stroke=\"#1f2937\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"30\" stroke=\"#1f2937\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'The hidden rule combines two linked movements. The token occupies the corners clockwise: top-left corner → top-right corner → bottom-right corner → next is the bottom-LEFT corner. And the thickened side is always the one that follows the token in this direction: top, then right, then bottom, so next is the LEFT side. ✓ Option a places the token at bottom-left AND thickens the left side: both movements agree. Option b does thicken the left side but puts the token back at top-left (a step backwards). Option c leaves the token at bottom-left but thickens the bottom (the previous side, not the next). Option d mixes them up: token at bottom-left but the top side thickened (two notches apart). Advance the token AND the bold side together, one notch clockwise.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f1d58351-8996-50f4-bd20-a7ac1d8d4989', '85a8263d-abfc-5448-87a8-89fb39112787', 'iq-training-en', '👑 Fluid intelligence elite ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17fb3f32-7853-5fbf-b7ee-2c8c5c9f5abe', 'f1d58351-8996-50f4-bd20-a7ac1d8d4989', 'Discover the rule of this sequence: at EACH box, the shape changes (square → circle → triangle → square…) AND its fill inverts (empty ↔ filled). Which figure occupies the "?" box? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="3"><rect x="6" y="42" width="16" height="16" fill="#1e293b"/><circle cx="36" cy="50" r="8" fill="none"/><polygon points="58,42 66,58 50,58" fill="#1e293b"/></g><rect x="76" y="40" width="20" height="20" fill="none" stroke="#cbd5e1" stroke-width="2"/><text x="86" y="56" font-size="14" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"18\" fill=\"#1e293b\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"34\" y=\"34\" width=\"32\" height=\"32\" fill=\"#1e293b\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,32 68,68 32,68\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"34\" y=\"34\" width=\"32\" height=\"32\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'd', 'Hidden rule: two things change together at each step — the SHAPE follows the cycle square → circle → triangle → square, and the FILL alternates empty/filled. Box 1 filled square, box 2 empty circle, box 3 filled triangle. So box 4 returns to the square shape (the cycle loops back) and inverts filled to EMPTY: an empty square. ✓ option d. Trap b: right square but we kept it filled instead of inverting. Trap c: empty triangle — we forgot that the shape loops back to the square. Trap a: filled circle — wrong shape AND wrong fill.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6c13fefb-1f60-55dc-8c09-3bb70590571d', 'f1d58351-8996-50f4-bd20-a7ac1d8d4989', 'Three circles overlap. Observed rule: the symbol placed in a zone depends on the NUMBER of circles overlapping there — 1 circle → line, 2 circles → cross, 3 circles → star. Which symbol must occupy the central zone marked "?", shared by ALL THREE circles? <svg viewBox="0 0 100 100"><g fill="none" stroke="#1e293b" stroke-width="2"><circle cx="40" cy="42" r="26"/><circle cx="60" cy="42" r="26"/><circle cx="50" cy="60" r="26"/></g><line x1="22" y1="30" x2="30" y2="30" stroke="#1e293b" stroke-width="3"/><g stroke="#1e293b" stroke-width="2"><line x1="67" y1="26" x2="73" y2="32"/><line x1="73" y1="26" x2="67" y2="32"/></g><text x="50" y="50" font-size="12" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"38\" y1=\"50\" x2=\"62\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"5\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"38\" y1=\"38\" x2=\"62\" y2=\"62\" stroke=\"#1e293b\" stroke-width=\"5\"/><line x1=\"62\" y1=\"38\" x2=\"38\" y2=\"62\" stroke=\"#1e293b\" stroke-width=\"5\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,28 56,44 72,44 59,54 64,70 50,60 36,70 41,54 28,44 44,44\" fill=\"#1e293b\" stroke=\"#1e293b\" stroke-width=\"1\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"50\" cy=\"50\" r=\"6\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'c', 'Hidden rule: the symbol encodes the number of circles overlapping at that spot. The legend confirms it — a 1-circle zone carries a line, a 2-circle zone carries a cross. The central zone belongs to ALL THREE circles at once, so it carries the star. ✓ option c (the star). Trap a: the line is for 1 circle only. Trap b: the cross is for 2 circles, not 3. Trap d: the dot is not in the rule''s code (an invented symbol).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('097e8287-73a6-5e98-9311-cfc0185e2c7f', 'f1d58351-8996-50f4-bd20-a7ac1d8d4989', 'Brand-new rule to induce: we overlay the left grid and the middle one, but a dot SURVIVES only if it appears in JUST ONE of the two grids (if it is in both, they cancel out; if in neither, the cell stays empty). Which grid is the result? <svg viewBox="0 0 100 100"><g stroke="#94a3b8" stroke-width="1" fill="none"><rect x="4" y="36" width="30" height="30"/><line x1="14" y1="36" x2="14" y2="66"/><line x1="24" y1="36" x2="24" y2="66"/><line x1="4" y1="46" x2="34" y2="46"/><line x1="4" y1="56" x2="34" y2="56"/></g><circle cx="9" cy="41" r="3" fill="#1e293b"/><circle cx="29" cy="41" r="3" fill="#1e293b"/><circle cx="19" cy="61" r="3" fill="#1e293b"/><text x="42" y="55" font-size="12" fill="#1e293b">+</text><g stroke="#94a3b8" stroke-width="1" fill="none"><rect x="52" y="36" width="30" height="30"/><line x1="62" y1="36" x2="62" y2="66"/><line x1="72" y1="36" x2="72" y2="66"/><line x1="52" y1="46" x2="82" y2="46"/><line x1="52" y1="56" x2="82" y2="56"/></g><circle cx="57" cy="41" r="3" fill="#1e293b"/><circle cx="77" cy="61" r="3" fill="#1e293b"/><circle cx="67" cy="61" r="3" fill="#1e293b"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#94a3b8\" stroke-width=\"1.5\" fill=\"none\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\"/><line x1=\"41.7\" y1=\"25\" x2=\"41.7\" y2=\"75\"/><line x1=\"58.3\" y1=\"25\" x2=\"58.3\" y2=\"75\"/><line x1=\"25\" y1=\"41.7\" x2=\"75\" y2=\"41.7\"/><line x1=\"25\" y1=\"58.3\" x2=\"75\" y2=\"58.3\"/></g><circle cx=\"67\" cy=\"33\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"67\" cy=\"67\" r=\"4\" fill=\"#1e293b\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#94a3b8\" stroke-width=\"1.5\" fill=\"none\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\"/><line x1=\"41.7\" y1=\"25\" x2=\"41.7\" y2=\"75\"/><line x1=\"58.3\" y1=\"25\" x2=\"58.3\" y2=\"75\"/><line x1=\"25\" y1=\"41.7\" x2=\"75\" y2=\"41.7\"/><line x1=\"25\" y1=\"58.3\" x2=\"75\" y2=\"58.3\"/></g><circle cx=\"33\" cy=\"33\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"50\" cy=\"67\" r=\"4\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#94a3b8\" stroke-width=\"1.5\" fill=\"none\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\"/><line x1=\"41.7\" y1=\"25\" x2=\"41.7\" y2=\"75\"/><line x1=\"58.3\" y1=\"25\" x2=\"58.3\" y2=\"75\"/><line x1=\"25\" y1=\"41.7\" x2=\"75\" y2=\"41.7\"/><line x1=\"25\" y1=\"58.3\" x2=\"75\" y2=\"58.3\"/></g><circle cx=\"33\" cy=\"33\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"67\" cy=\"33\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"50\" cy=\"67\" r=\"4\" fill=\"#1e293b\"/><circle cx=\"67\" cy=\"67\" r=\"4\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#94a3b8\" stroke-width=\"1.5\" fill=\"none\"><rect x=\"25\" y=\"25\" width=\"50\" height=\"50\"/><line x1=\"41.7\" y1=\"25\" x2=\"41.7\" y2=\"75\"/><line x1=\"58.3\" y1=\"25\" x2=\"58.3\" y2=\"75\"/><line x1=\"25\" y1=\"41.7\" x2=\"75\" y2=\"41.7\"/><line x1=\"25\" y1=\"58.3\" x2=\"75\" y2=\"58.3\"/></g><circle cx=\"50\" cy=\"50\" r=\"4\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'a', 'Hidden rule: it is an "exclusive or" (XOR). A cell survives only if it has a dot in exactly ONE of the two grids. Grid 1 = top-left corner, top-right corner, bottom-centre. Grid 2 = top-left corner, bottom-centre, bottom-right corner. The top-left corner is in BOTH → it cancels. The bottom-centre is in BOTH → it cancels. What remains: the top-right corner (grid 1 only) and the bottom-right corner (grid 2 only). Result = exactly two dots: top-right and bottom-right, and nothing else. ✓ option a (top-right + bottom-right). Trap b: we kept the INTERSECTION (top-left + bottom-centre), i.e. the opposite of the rule — we kept the shared cells instead of cancelling them. Trap c: we took the UNION of the two grids (top-left, top-right, bottom-centre, bottom-right), cancelling nothing. Trap d: a single dot in the centre, an invented position outside both grids.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c02b731-962b-5fd9-85eb-81e154adfbff', 'f1d58351-8996-50f4-bd20-a7ac1d8d4989', 'A number sequence hidden in the figures: each square contains a certain number of dots. Find the rule that links one term to the next, then give the number of dots in the "?" figure. The counts are 2, 3, 5, 8, then ?. <svg viewBox="0 0 100 100"><g stroke="#94a3b8" stroke-width="1" fill="none"><rect x="3" y="40" width="15" height="15"/><rect x="22" y="40" width="15" height="15"/><rect x="41" y="40" width="15" height="15"/><rect x="60" y="40" width="15" height="15"/><rect x="79" y="40" width="15" height="15"/></g><g fill="#1e293b"><circle cx="8" cy="45" r="2"/><circle cx="13" cy="50" r="2"/><circle cx="27" cy="44" r="2"/><circle cx="32" cy="44" r="2"/><circle cx="29" cy="51" r="2"/><circle cx="45" cy="44" r="2"/><circle cx="51" cy="44" r="2"/><circle cx="45" cy="51" r="2"/><circle cx="51" cy="51" r="2"/><circle cx="48" cy="47" r="2"/><circle cx="63" cy="43" r="2"/><circle cx="68" cy="43" r="2"/><circle cx="72" cy="43" r="2"/><circle cx="63" cy="48" r="2"/><circle cx="68" cy="48" r="2"/><circle cx="72" cy="48" r="2"/><circle cx="65" cy="52" r="2"/><circle cx="70" cy="52" r="2"/></g><text x="86" y="52" font-size="12" text-anchor="middle" fill="#ef4444">?</text></svg>', '[{"id":"a","text":"11"},{"id":"b","text":"13"},{"id":"c","text":"16"},{"id":"d","text":"10"}]'::jsonb, 'b', 'Hidden rule: each term is the SUM of the two preceding ones (a Fibonacci-type sequence), not a constant gap. 2 ; 3 ; 2+3=5 ; 3+5=8 ; so the next = 5+8 = 13. ✓ option b (13). Trap a (11): we added a constant gap of +3 (8+3), mistaking it for an arithmetic sequence. Trap d (10): we did 8+2 (the wrong pair of terms). Trap c (16): we doubled the last term (8×2), an invented rule.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1085c93-c5a0-5a29-b5db-37013439b6f3', 'f1d58351-8996-50f4-bd20-a7ac1d8d4989', 'Matrix analogy: "A is to B as C is to ?". From A to B, TWO things happen at once — the bar rotates a quarter turn clockwise AND the number of dots is halved. Apply exactly the same double transformation to C. <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="3"><line x1="6" y1="30" x2="30" y2="30"/></g><g fill="#1e293b"><circle cx="10" cy="40" r="2.5"/><circle cx="17" cy="40" r="2.5"/><circle cx="24" cy="40" r="2.5"/><circle cx="13" cy="46" r="2.5"/></g><text x="36" y="40" font-size="10" fill="#1e293b">:</text><g stroke="#1e293b" stroke-width="3"><line x1="48" y1="26" x2="48" y2="50"/></g><g fill="#1e293b"><circle cx="56" cy="34" r="2.5"/><circle cx="56" cy="42" r="2.5"/></g><text x="66" y="40" font-size="10" fill="#1e293b">::</text><g stroke="#1e293b" stroke-width="3"><line x1="74" y1="70" x2="98" y2="70"/></g><g fill="#1e293b"><circle cx="78" cy="80" r="2.5"/><circle cx="84" cy="80" r="2.5"/><circle cx="90" cy="80" r="2.5"/><circle cx="96" cy="80" r="2.5"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"26\" x2=\"50\" y2=\"54\" stroke=\"#1e293b\" stroke-width=\"4\"/><circle cx=\"62\" cy=\"34\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"62\" cy=\"46\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"32\" y1=\"50\" x2=\"68\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/><circle cx=\"40\" cy=\"62\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"52\" cy=\"62\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"50\" y1=\"26\" x2=\"50\" y2=\"54\" stroke=\"#1e293b\" stroke-width=\"4\"/><circle cx=\"62\" cy=\"32\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"62\" cy=\"42\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"62\" cy=\"52\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"62\" cy=\"62\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"32\" y1=\"50\" x2=\"68\" y2=\"50\" stroke=\"#1e293b\" stroke-width=\"4\"/><circle cx=\"44\" cy=\"62\" r=\"3\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'a', 'Hidden rule: two simultaneous transformations. (1) Rotation: the bar turns a quarter turn clockwise. (2) Quantity: the number of dots is halved. For C, the bar is HORIZONTAL; a quarter turn clockwise makes it VERTICAL. The dots go from 4 to 4÷2 = 2. ✓ option a: vertical bar + 2 dots. Trap b: we forgot to turn the bar (still horizontal) while halving the dots correctly. Trap d: bar not turned AND we reduced too far (1 dot instead of 2). Trap c: bar turned correctly but we kept 4 dots (forgetting the halving).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b385a869-350c-5106-b96e-968ecf5e4638', 'f1d58351-8996-50f4-bd20-a7ac1d8d4989', 'Brand-new rule to discover: in each figure, the number of SIDES of the outer shape is always equal to the number of small dots it contains PLUS one. Only one option respects this hidden rule. Which one? <svg viewBox="0 0 100 100"><polygon points="20,80 50,20 80,80" fill="none" stroke="#1e293b" stroke-width="3"/><circle cx="42" cy="62" r="3" fill="#1e293b"/><circle cx="58" cy="62" r="3" fill="#1e293b"/><text x="50" y="96" font-size="9" text-anchor="middle" fill="#64748b">exemple : 3 côtés, 2 points</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,24 72,40 64,68 36,68 28,40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"44\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"56\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,24 72,40 64,68 36,68 28,40\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"42\" cy=\"52\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"50\" cy=\"52\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"58\" cy=\"52\" r=\"3\" fill=\"#1e293b\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"28\" y=\"28\" width=\"44\" height=\"44\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"3\"/><circle cx=\"42\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/><circle cx=\"58\" cy=\"50\" r=\"3\" fill=\"#1e293b\"/></svg>"}]'::jsonb, 'd', 'Hidden rule: sides = dots + 1 (the example shows it: a triangle has 3 sides and contains 2 dots, and 3 = 2 + 1). Test each option. Option d: square = 4 sides, 3 dots → 4 = 3 + 1 ✓. Option d respects the rule. Trap b: square (4 sides) with 2 dots → it would need 3 dots (4 = 2+1 is false). Trap c: pentagon (5 sides) with 3 dots → it would need 4 dots. Trap a: pentagon (5 sides) with 1 dot → it would need 4 dots. The key is to link two attributes (sides and dots) by a single formula, not to judge them separately.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b068f3db-2f8d-554e-86c5-d88b634c7066', '4d7142b4-902b-5fe9-b636-878d9aab2555', 'iq-training-en', 'Geometry & spatial reasoning warm-up ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df6e6925-d3d6-54c0-a986-0e1d0f2680a6', 'b068f3db-2f8d-554e-86c5-d88b634c7066', 'The model figure turns a quarter turn (90°) clockwise. Which drawing do you get? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><line x1="30" y1="25" x2="30" y2="70" stroke="#1d4ed8" stroke-width="5"/><line x1="30" y1="70" x2="65" y2="70" stroke="#1d4ed8" stroke-width="5"/><circle cx="30" cy="25" r="6" fill="#1d4ed8"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"75\" y1=\"30\" x2=\"30\" y2=\"30\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><line x1=\"30\" y1=\"30\" x2=\"30\" y2=\"65\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><circle cx=\"75\" cy=\"30\" r=\"6\" fill=\"#1d4ed8\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"30\" y1=\"25\" x2=\"30\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><line x1=\"30\" y1=\"70\" x2=\"65\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><circle cx=\"30\" cy=\"25\" r=\"6\" fill=\"#1d4ed8\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"25\" y1=\"70\" x2=\"70\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><line x1=\"70\" y1=\"70\" x2=\"70\" y2=\"30\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><circle cx=\"25\" cy=\"70\" r=\"6\" fill=\"#1d4ed8\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"70\" y1=\"25\" x2=\"70\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><line x1=\"70\" y1=\"70\" x2=\"35\" y2=\"70\" stroke=\"#1d4ed8\" stroke-width=\"5\"/><circle cx=\"70\" cy=\"25\" r=\"6\" fill=\"#1d4ed8\"/></svg>"}]'::jsonb, 'a', 'Follow the reference dot. In the model it is at the top, at the end of the vertical bar. A quarter turn clockwise sends the top toward the right: so the dot moves to the top right and the bar becomes horizontal, with the elbow then going down. ✓ That is option a. Option b is identical to the model (no rotation). Option c turned the other way (counterclockwise). Option d has the right shape but the reference dot is in the wrong place: the figure was flipped like a mirror image instead of being rotated.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('006c9193-b3ee-54f5-80fb-ebdc7c87b3b1', 'b068f3db-2f8d-554e-86c5-d88b634c7066', 'Here is a model flag. Choose its reflection in a vertical mirror (left-right). <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><line x1="30" y1="20" x2="30" y2="80" stroke="#0f766e" stroke-width="4"/><polygon points="30,22 62,34 30,46" fill="#0f766e" stroke="#0f766e" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"30\" y1=\"20\" x2=\"30\" y2=\"80\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"30,22 62,34 30,46\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"70\" y1=\"20\" x2=\"70\" y2=\"80\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"70,22 38,34 70,46\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"30\" y1=\"20\" x2=\"30\" y2=\"80\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"30,54 62,66 30,78\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><line x1=\"20\" y1=\"30\" x2=\"80\" y2=\"30\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"22,30 34,62 46,30\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'b', 'A vertical mirror swaps left and right: the pole stays vertical but moves to the right, and the pennant that was pointing right now points left. ✓ That is option b. Option a is identical to the model (no reflection). Option c slid the pennant down the pole: a left-right mirror does not change the height. Option d rotated the whole flag a quarter turn: that is a rotation, not a reflection.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8e34b788-1c77-5935-8b75-e806d1002658', 'b068f3db-2f8d-554e-86c5-d88b634c7066', 'This stack is made of identical cubes (no cube hidden behind, the back is solid where needed to hold things up). How many cubes does it have in total? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><g fill="#fde68a" stroke="#b45309" stroke-width="2"><rect x="20" y="66" width="20" height="20"/><rect x="40" y="66" width="20" height="20"/><rect x="60" y="66" width="20" height="20"/><rect x="20" y="46" width="20" height="20"/><rect x="40" y="46" width="20" height="20"/><rect x="20" y="26" width="20" height="20"/></g></svg>', '[{"id":"a","text":"5 cubes"},{"id":"b","text":"7 cubes"},{"id":"c","text":"6 cubes"},{"id":"d","text":"9 cubes"}]'::jsonb, 'c', 'Count layer by layer. Bottom: 3 cubes. Middle: 2 cubes. Top: 1 cube. Total 3 + 2 + 1 = 6 cubes. ✓ That is option c. Option a (5) forgets a cube, often the one at the top. Option b (7) adds one too many. Option d (9) assumes each layer is complete (3 × 3) whereas the figure shows a stepped pyramid.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('440a6606-f1fa-50ef-a833-6cc0962715fb', 'b068f3db-2f8d-554e-86c5-d88b634c7066', 'Only one of these nets (unfolded drawings) can be folded into a closed cube with 6 faces. Which one? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><g fill="#ddd6fe" stroke="#6d28d9" stroke-width="2"><rect x="42" y="10" width="16" height="16"/><rect x="42" y="26" width="16" height="16"/><rect x="26" y="42" width="16" height="16"/><rect x="42" y="42" width="16" height="16"/><rect x="58" y="42" width="16" height="16"/><rect x="42" y="58" width="16" height="16"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#ddd6fe\" stroke=\"#6d28d9\" stroke-width=\"2\"><rect x=\"18\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"50\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"66\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"58\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#ddd6fe\" stroke=\"#6d28d9\" stroke-width=\"2\"><rect x=\"26\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"58\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#ddd6fe\" stroke=\"#6d28d9\" stroke-width=\"2\"><rect x=\"26\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"26\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"42\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"42\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#ddd6fe\" stroke=\"#6d28d9\" stroke-width=\"2\"><rect x=\"42\" y=\"12\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"60\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"60\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"76\" width=\"16\" height=\"16\"/></g></svg>"}]'::jsonb, 'a', 'To make a cube you need 6 squares that fold up without any of them overlapping. Option a is the classic cross: a line of four squares (the sides) with one square above and one below (the top and the bottom) — it closes up perfectly. ✓ Option c is a full 3 × 2 rectangle: when folded, faces overlap and the lid is missing. Option b and option d, once folded, produce two squares that land in the same spot: the cube is left with a hole on one side and a doubled face on the other.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fd4ba37-1ee3-5237-9f35-d55593bdee58', 'b068f3db-2f8d-554e-86c5-d88b634c7066', 'We want to join two pieces, flat edge against flat edge, to rebuild a complete rectangle. The first piece is shown below. Which piece completes it exactly? <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><polygon points="25,30 75,30 25,70" fill="#fca5a5" stroke="#b91c1c" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"25,30 75,30 75,70\" fill=\"#fca5a5\" stroke=\"#b91c1c\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"25,40 75,40 50,70\" fill=\"#fca5a5\" stroke=\"#b91c1c\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"30\" y=\"35\" width=\"40\" height=\"30\" fill=\"#fca5a5\" stroke=\"#b91c1c\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><polygon points=\"75,30 75,70 25,70\" fill=\"#fca5a5\" stroke=\"#b91c1c\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'd', 'The starting piece is the top-left half of a rectangle: its hypotenuse (the slanted edge) runs from the top-right corner to the bottom-left corner. To rebuild the rectangle, you need the missing triangle, the bottom-right half, whose hypotenuse has exactly the same slope and fits against it. ✓ That is option d. Option a is a triangle whose slant goes the other way: placed against the model, it leaves a gap and sticks out. Option b is an isosceles triangle (point at the bottom), its shape does not complete the rectangle. Option c is already a full rectangle: added on, it would stick out well beyond the rectangle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8cf858c9-d154-5719-8163-dbbe09b43a12', '4d7142b4-902b-5fe9-b636-878d9aab2555', 'iq-training-en', '⭐ Warm-up', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b5da457-44b8-5f04-90cc-4d8c205803cd', '8cf858c9-d154-5719-8163-dbbe09b43a12', 'Here is a figure: a flag attached to the top of a pole, pointing to the RIGHT. Which of the options is its image in a vertical mirror (left-right swapped)? <svg viewBox="0 0 100 100"><line x1="35" y1="15" x2="35" y2="85" stroke="#222" stroke-width="3"/><polygon points="35,18 70,30 35,42" fill="#222" stroke="#222" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"35\" y1=\"15\" x2=\"35\" y2=\"85\" stroke=\"#222\" stroke-width=\"3\"/><polygon points=\"35,58 70,70 35,82\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"35\" y1=\"15\" x2=\"35\" y2=\"85\" stroke=\"#222\" stroke-width=\"3\"/><polygon points=\"35,18 70,30 35,42\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"65\" y1=\"15\" x2=\"65\" y2=\"85\" stroke=\"#222\" stroke-width=\"3\"/><polygon points=\"65,18 30,30 65,42\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"65\" y1=\"15\" x2=\"65\" y2=\"85\" stroke=\"#222\" stroke-width=\"3\"/><polygon points=\"65,58 30,70 65,82\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'c', 'A vertical mirror swaps left and right but keeps the top at the top. So the pole moves to the right and the flag, which was pointing right, must now point LEFT → option c ✓. The trap: b is the original figure unchanged (no reflection), a keeps the pole on the left and just lowers the flag (vertical and horizontal mirrors were confused), and d flips the figure top-to-bottom on top of the side swap (double transformation, that is not a simple left-right mirror).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbd0f7f0-6b22-53ea-a174-d395cc418a58', '8cf858c9-d154-5719-8163-dbbe09b43a12', 'The same "L" piece (4 squares) turns a quarter turn (90°) clockwise at each step. Here are orientations 1, 2 and 3. Which figure is orientation 4? <svg viewBox="0 0 100 100"><g fill="#222" stroke="#fff" stroke-width="1"><rect x="8" y="24" width="9" height="9"/><rect x="8" y="33" width="9" height="9"/><rect x="8" y="42" width="9" height="9"/><rect x="17" y="42" width="9" height="9"/><rect x="40" y="33" width="9" height="9"/><rect x="40" y="42" width="9" height="9"/><rect x="49" y="33" width="9" height="9"/><rect x="58" y="33" width="9" height="9"/><rect x="76" y="24" width="9" height="9"/><rect x="85" y="24" width="9" height="9"/><rect x="85" y="33" width="9" height="9"/><rect x="85" y="42" width="9" height="9"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#222\" stroke=\"#fff\" stroke-width=\"1\"><rect x=\"23\" y=\"32\" width=\"18\" height=\"18\"/><rect x=\"23\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"41\" y=\"32\" width=\"18\" height=\"18\"/><rect x=\"59\" y=\"32\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#222\" stroke=\"#fff\" stroke-width=\"1\"><rect x=\"32\" y=\"23\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"23\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"41\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"59\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#222\" stroke=\"#fff\" stroke-width=\"1\"><rect x=\"23\" y=\"32\" width=\"18\" height=\"18\"/><rect x=\"23\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"41\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"59\" y=\"50\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#222\" stroke=\"#fff\" stroke-width=\"1\"><rect x=\"23\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"41\" y=\"50\" width=\"18\" height=\"18\"/><rect x=\"59\" y=\"32\" width=\"18\" height=\"18\"/><rect x=\"59\" y=\"50\" width=\"18\" height=\"18\"/></g></svg>"}]'::jsonb, 'd', 'The piece is always the same "L" of 4 squares; we turn it a quarter turn clockwise. Orientation 3 has the vertical bar on the right with the foot at the top left; one more quarter turn clockwise brings the bar horizontal at the bottom with the foot coming back up on the right → option d ✓. The trap: a is orientation 2 (a quarter turn backward), b repeats orientation 3 (we forgot to turn), and c is the "L" flipped like a mirror (wrong direction / piece reversed), which never happens by simple rotation. Keep the 4 squares and turn just one quarter turn clockwise.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4baeb15-b2e6-5a37-91c3-a26521dcdaec', '8cf858c9-d154-5719-8163-dbbe09b43a12', 'This stack of identical cubes is arranged in steps. How many cubes does it have in total (no cube hidden behind)? <svg viewBox="0 0 100 100"><g fill="none" stroke="#222" stroke-width="2"><rect x="20" y="60" width="20" height="20"/><rect x="40" y="60" width="20" height="20"/><rect x="60" y="60" width="20" height="20"/><rect x="40" y="40" width="20" height="20"/><rect x="60" y="40" width="20" height="20"/><rect x="60" y="20" width="20" height="20"/></g></svg>', '[{"id":"a","text":"5 cubes"},{"id":"b","text":"6 cubes"},{"id":"c","text":"7 cubes"},{"id":"d","text":"9 cubes"}]'::jsonb, 'b', 'Count the visible squares, which are all cubes (nothing is hidden): the bottom row has 3, the middle row 2 and the top row 1, that is 3 + 2 + 1 = 6 cubes → option b ✓. The trap: a (5) forgets a cube in a row, c (7) counts one too many, and d (9) assumes a complete 3×3 square whereas the steps leave gaps. Add up only the cubes actually drawn.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6224e0c-1586-5af9-8104-0170ef6fd37f', '8cf858c9-d154-5719-8163-dbbe09b43a12', 'We fold this cube net (Latin cross, 6 squares) to form a cube. The net has a BLACK disk on the LEFT arm and a WHITE (empty) disk on the RIGHT arm. Which pair of patterns ends up on two OPPOSITE faces of the cube once folded? <svg viewBox="0 0 100 100"><g fill="none" stroke="#222" stroke-width="2"><rect x="40" y="10" width="20" height="20"/><rect x="20" y="30" width="20" height="20"/><rect x="40" y="30" width="20" height="20"/><rect x="60" y="30" width="20" height="20"/><rect x="40" y="50" width="20" height="20"/><rect x="40" y="70" width="20" height="20"/></g><circle cx="30" cy="40" r="6" fill="#222"/><circle cx="70" cy="40" r="6" fill="none" stroke="#222" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"50\" r=\"12\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"70\" cy=\"50\" r=\"12\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"50\" r=\"12\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"70\" cy=\"50\" r=\"12\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"50\" r=\"12\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/><circle cx=\"70\" cy=\"50\" r=\"12\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><circle cx=\"30\" cy=\"50\" r=\"12\" fill=\"#222\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"58\" y=\"38\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"#222\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'a', 'In a Latin cross, the two side arms (left and right) are the two opposite flaps: once folded, they become two OPPOSITE faces of the cube. So the black disk (left arm) ends up opposite the white disk (right arm) → option a ✓. The trap: b shows two black disks and c two white disks (but the two patterns are different: one solid and one empty), and d replaces the white disk with a square, a pattern that appears nowhere on the net. The two opposite arms of a cross always land on opposite faces.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a681bb1-c4ac-5974-8819-79108bca99f2', '8cf858c9-d154-5719-8163-dbbe09b43a12', 'We stack these two transparent shapes keeping their exact position (a large triangle and a small square). Which figure do you get when you pile one on the other? <svg viewBox="0 0 100 100"><polygon points="20,20 45,20 32,42" fill="none" stroke="#222" stroke-width="2"/><rect x="60" y="60" width="22" height="22" fill="none" stroke="#222" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"20,20 45,20 32,42\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"20,20 45,20 32,42\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><circle cx=\"71\" cy=\"71\" r=\"12\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"20,20 45,20 32,42\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"60\" y=\"60\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"60,60 85,60 72,82\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/><rect x=\"20\" y=\"20\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"#222\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'c', 'Stacking while keeping the exact position means each shape stays where it was: the triangle stays at the top left and the square stays at the bottom right, and both appear together → option c ✓. The trap: b turns the square into a circle (you are not allowed to change a shape), a makes the square disappear (a shape was forgotten), and d swaps the positions of the two shapes (but stacking keeps the locations). Keep both shapes, in their place.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f9ec5c9-52b1-5577-832d-612b9b3ac3cb', '8cf858c9-d154-5719-8163-dbbe09b43a12', 'The capital letter "F" is the right way up. Which of the options is its reflection in a vertical mirror (left-right swapped)? <svg viewBox="0 0 100 100"><polygon points="40,15 70,15 70,25 50,25 50,45 65,45 65,55 50,55 50,85 40,85" fill="#222"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,15 70,15 70,25 50,25 50,45 65,45 65,55 30,55 30,85 40,85 40,55 30,55\" fill=\"#222\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,15 70,15 70,25 50,25 50,45 65,45 65,55 50,55 50,85 40,85\" fill=\"#222\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"40,85 70,85 70,75 50,75 50,55 65,55 65,45 50,45 50,15 40,15\" fill=\"#222\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"60,15 30,15 30,25 50,25 50,45 35,45 35,55 50,55 50,85 60,85\" fill=\"#222\"/></svg>"}]'::jsonb, 'd', 'A vertical mirror swaps left and right without touching top/bottom: the vertical bar of the "F" moves to the right and its two arms now point to the left → option d ✓. The trap: b is the original "F" unchanged (no reflection), c flips the letter top-to-bottom (the arms come off the bottom, that is a horizontal mirror and not a vertical one), and a is a distorted shape that is not a mirror "F". In a vertical mirror, only left and right are swapped.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('23067a4a-b07d-57db-9f44-204d5164995d', '4d7142b4-902b-5fe9-b636-878d9aab2555', 'iq-training-en', '⚔️ Geometry & spatial reasoning challenge ⭐⭐⭐', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c08479dd-81ae-539d-875b-3f09d4eeb632', '23067a4a-b07d-57db-9f44-204d5164995d', 'This set square has a small black reference dot at the end of its horizontal arm. The figure turns a quarter turn (90°) clockwise. Which drawing do you get? <svg viewBox="0 0 100 100"><polyline points="30,30 30,70 70,70" fill="none" stroke="#1f2937" stroke-width="5"/><circle cx="70" cy="70" r="6" fill="#1f2937"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,30 30,30 30,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,30 30,70 70,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><circle cx=\"70\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"70,30 30,30 30,70\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><circle cx=\"70\" cy=\"30\" r=\"6\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,70 70,70 70,30\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><circle cx=\"30\" cy=\"70\" r=\"6\" fill=\"#1f2937\"/></svg>"}]'::jsonb, 'a', 'Rule: +90° clockwise. Follow the reference dot, placed at the end of the horizontal arm, at the bottom right. A quarter turn clockwise sends the bottom toward the left: so the dot moves to the bottom left, the right angle goes up to the top left and the arm straightens upward → option a ✓. The trap: b is the model unchanged (no rotation), c has the right set-square shape but puts the dot at the top right — that is a mirror reflection, not a rotation —, and d turned the other way (counterclockwise). Turn just one quarter turn in the right direction and follow the marker.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d0c19b70-0e6f-5269-8c9b-623132637b0a', '23067a4a-b07d-57db-9f44-204d5164995d', 'The capital letter "R" is the right way up. Which of the options is its reflection in a vertical mirror (left and right swapped, the top stays at the top)? <svg viewBox="0 0 100 100"><polyline points="38,15 38,85" fill="none" stroke="#1f2937" stroke-width="5"/><path d="M38,15 H62 Q72,15 72,30 Q72,45 62,45 H38" fill="none" stroke="#1f2937" stroke-width="5"/><polyline points="50,45 70,85" fill="none" stroke="#1f2937" stroke-width="5"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"62,15 62,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><path d=\"M62,15 H38 Q28,15 28,30 Q28,45 38,45 H62\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><polyline points=\"50,45 30,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"38,15 38,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><path d=\"M38,15 H62 Q72,15 72,30 Q72,45 62,45 H38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><polyline points=\"50,45 70,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"38,15 38,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><path d=\"M38,85 H62 Q72,85 72,70 Q72,55 62,55 H38\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><polyline points=\"50,55 70,15\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"62,15 62,85\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><path d=\"M62,85 H38 Q28,85 28,70 Q28,55 38,55 H62\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/><polyline points=\"50,55 30,15\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"5\"/></svg>"}]'::jsonb, 'a', 'A vertical mirror swaps left and right without touching top/bottom. The vertical bar of the "R" moves to the right, the loop opens toward the left and the slanted leg goes down to the bottom left → option a ✓. The trap: b is the original "R" unchanged (no reflection), c flips the letter top-to-bottom (loop at the bottom, leg pointing up: that is a horizontal mirror, not a vertical one), and d combines both flips (left-right AND top-bottom), which amounts to a 180° rotation and not a simple vertical mirror. Only left and right are swapped.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a16ba1f0-85ba-5d15-8b0a-2f9b7661ce87', '23067a4a-b07d-57db-9f44-204d5164995d', 'This stack is made of identical cubes. Each visible cube rests on the floor or on another cube, and nothing is hidden behind the stack. How many cubes does it have in total? <svg viewBox="0 0 100 100"><g fill="none" stroke="#1f2937" stroke-width="2"><rect x="15" y="65" width="18" height="18"/><rect x="33" y="65" width="18" height="18"/><rect x="51" y="65" width="18" height="18"/><rect x="69" y="65" width="18" height="18"/><rect x="15" y="47" width="18" height="18"/><rect x="33" y="47" width="18" height="18"/><rect x="51" y="47" width="18" height="18"/><rect x="15" y="29" width="18" height="18"/><rect x="33" y="29" width="18" height="18"/><rect x="15" y="11" width="18" height="18"/></g></svg>', '[{"id":"a","text":"9 cubes"},{"id":"b","text":"10 cubes"},{"id":"c","text":"12 cubes"},{"id":"d","text":"16 cubes"}]'::jsonb, 'b', 'Add up the cubes layer by layer, counting only the ones drawn. Bottom: 4 cubes. Above: 3. Then: 2. At the top: 1. Total 4 + 3 + 2 + 1 = 10 cubes → option b ✓. The trap: a (9) forgets a cube in one layer, c (12) counts 4 + 4 + 2 + 2 by assuming fuller layers than there are, and d (16) assumes a complete 4×4 square whereas the figure is a stepped, gapped shape. Count exactly the squares present.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8209e1e0-eef8-5492-9de0-7b721a87d969', '23067a4a-b07d-57db-9f44-204d5164995d', 'Only one of these four figures has a VERTICAL axis of symmetry: you could fold it along a vertical line and the two halves would line up exactly. Which one?', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"50,15 20,80 80,80\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><line x1=\"50\" y1=\"15\" x2=\"50\" y2=\"80\" stroke=\"#1f2937\" stroke-width=\"2\" stroke-dasharray=\"3 3\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"25,20 75,20 60,80 40,80\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><polygon points=\"55,30 75,45 60,60\" fill=\"#1f2937\" stroke=\"#1f2937\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"22\" y=\"35\" width=\"56\" height=\"30\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/><circle cx=\"38\" cy=\"50\" r=\"8\" fill=\"#1f2937\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"30,25 55,25 70,50 55,75 30,75 45,50\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"3\"/></svg>"}]'::jsonb, 'a', 'A vertical axis of symmetry means the left half is the exact mirror image of the right half. The isosceles triangle in a has its apex right above the middle of its base: the vertical line through the apex splits the figure into two identical halves → option a ✓. The trap: b is almost symmetric but the small solid arrow is drawn only on the right, which breaks the left-right balance; c has its disk offset to the left, so the right half is empty; d would fold correctly along a HORIZONTAL line (top = bottom) but not along a vertical one (the points are on the left and right in an offset way). Always check that it really is the axis being asked about.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36b51b2d-a988-5d10-842f-b7d4c1c99ba8', '23067a4a-b07d-57db-9f44-204d5164995d', 'Only one of these unfolded nets (6 squares) can be folded into a closed cube with 6 faces, without any square overlapping or any face missing. Which one?', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#e5e7eb\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"42\" y=\"12\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"60\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#e5e7eb\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"26\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"26\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"58\" y=\"44\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#e5e7eb\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"34\" y=\"12\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"28\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"44\" width=\"16\" height=\"16\"/><rect x=\"34\" y=\"60\" width=\"16\" height=\"16\"/><rect x=\"50\" y=\"60\" width=\"16\" height=\"16\"/><rect x=\"50\" y=\"76\" width=\"16\" height=\"16\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"#e5e7eb\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"42\" y=\"4\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"20\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"36\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"52\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"68\" width=\"16\" height=\"16\"/><rect x=\"42\" y=\"84\" width=\"16\" height=\"16\"/></g></svg>"}]'::jsonb, 'a', 'You need 6 squares that, folded, give the 6 faces without overlap. Option a is the classic cross: a column of four squares (the four sides) with one square added to the left and one to the right of the second square (the top and the bottom); it closes up perfectly → option a ✓. The trap: b is a full 3×2 block — when folded, squares overlap and one face is missing; c, after folding, produces two squares that land on the same face, leaving the cube with a hole; d is a column of six squares (1×6): rolled up, it forms a ring of faces and the top and bottom are missing. Only a "cross/T" arrangement without stacking works.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fcfac15b-55db-5f5b-8a6f-62195a2e5db9', '23067a4a-b07d-57db-9f44-204d5164995d', 'We stack these two transparent overlays keeping their exact positions: on the left an overlay with ONLY the "\" diagonal of one square, on the right an overlay with ONLY the "/" diagonal of the same square. Which figure do you get by piling the two overlays? <svg viewBox="0 0 100 100"><g fill="none" stroke="#1f2937" stroke-width="2"><rect x="8" y="35" width="30" height="30"/><line x1="8" y1="35" x2="38" y2="65"/><rect x="58" y="35" width="30" height="30"/><line x1="88" y1="35" x2="58" y2="65"/></g></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\"/><line x1=\"70\" y1=\"30\" x2=\"30\" y2=\"70\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\"/><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/><line x1=\"50\" y1=\"30\" x2=\"50\" y2=\"70\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g fill=\"none\" stroke=\"#1f2937\" stroke-width=\"2\"><rect x=\"30\" y=\"30\" width=\"40\" height=\"40\"/><line x1=\"30\" y1=\"30\" x2=\"70\" y2=\"70\"/><line x1=\"70\" y1=\"30\" x2=\"30\" y2=\"70\"/><line x1=\"30\" y1=\"50\" x2=\"70\" y2=\"50\"/></g></svg>"}]'::jsonb, 'a', 'Stacking keeps everything each overlay carries and adds nothing else. So you keep the outline of the square, plus the two diagonals "\" and "/", which cross at the center and form an X → option a ✓. The trap: b kept only one diagonal (one overlay was forgotten), c replaced the diagonals with a straight horizontal + vertical cross (wrong lines: stacking does not rotate the strokes), and d adds a horizontal line that exists on neither overlay (you never invent a stroke when stacking). Combine exactly the strokes of the two overlays, nothing more.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b65aaeff-d522-52c0-a8be-3473d5da6b34', '4d7142b4-902b-5fe9-b636-878d9aab2555', 'iq-training-en', '👑 Geometry & spatial reasoning elite ⭐⭐⭐⭐', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e8fae595-3e71-514b-b448-e6437b6901ac', 'b65aaeff-d522-52c0-a8be-3473d5da6b34', 'The model figure (an "L" with a red ball at the end of the vertical bar) turns a quarter turn (90°) COUNTERCLOCKWISE. Which option shows the result? <svg viewBox="0 0 100 100"><polyline points="30,20 30,75 75,75" fill="none" stroke="#1e293b" stroke-width="6"/><circle cx="30" cy="20" r="7" fill="#ef4444" stroke="#1e293b" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"20,70 75,70 75,25\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"20\" cy=\"70\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"80,30 25,30 25,75\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"80\" cy=\"30\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"30,20 30,75 75,75\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"30\" cy=\"20\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polyline points=\"20,30 75,30 75,75\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"6\"/><circle cx=\"20\" cy=\"30\" r=\"7\" fill=\"#ef4444\" stroke=\"#1e293b\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'Hidden rule: a quarter turn counterclockwise sends the TOP to the LEFT and the BOTTOM to the right. In the model, the ball is at the very top and the corner of the "L" is at the bottom left; after the counterclockwise rotation, the ball moves down to the LEFT (bottom left, at the end of a horizontal bar) and the corner comes back up on the right. ✓ option a (ball at the bottom left, horizontal bar toward a corner on the right, then going up). Trap b: this is the CLOCKWISE rotation — the ball went to the RIGHT (top right), so the wrong direction. Trap c: this is the starting figure, no rotation. Trap d: the shape is turned correctly but the ball is on the wrong side — that is a mirror reflection, not a rotation.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('901fa4f8-bfd9-5b63-82ca-c88374103f48', 'b65aaeff-d522-52c0-a8be-3473d5da6b34', 'Here is a model flag: a pole on the left, with a pennant pointing to the right in the UPPER half of the pole. Which option is its image by REFLECTION in a HORIZONTAL mirror (horizontal axis, top and bottom swapped)? <svg viewBox="0 0 100 100"><line x1="25" y1="15" x2="25" y2="85" stroke="#0f766e" stroke-width="4"/><polygon points="25,20 60,30 25,40" fill="#0f766e" stroke="#0f766e" stroke-width="2"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"25\" y1=\"15\" x2=\"25\" y2=\"85\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"25,60 60,70 25,80\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"25\" y1=\"15\" x2=\"25\" y2=\"85\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"25,20 60,30 25,40\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"75\" y1=\"15\" x2=\"75\" y2=\"85\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"75,60 40,70 75,80\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><line x1=\"75\" y1=\"15\" x2=\"75\" y2=\"85\" stroke=\"#0f766e\" stroke-width=\"4\"/><polygon points=\"75,20 40,30 75,40\" fill=\"#0f766e\" stroke=\"#0f766e\" stroke-width=\"2\"/></svg>"}]'::jsonb, 'a', 'Hidden rule: a horizontal mirror swaps the TOP and the BOTTOM but leaves left and right unchanged. So the pole stays on the left, and the pennant that was at the top moves down into the LOWER half while still pointing to the right. ✓ option a. Trap b: this is the model unchanged (no reflection). Trap d: the pole moved to the right and the pennant points left — that is a VERTICAL mirror (left-right), not horizontal. Trap c: both mirrors were applied at once (equivalent to a 180° rotation), the pole on the right AND the pennant at the bottom.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('77f26d0b-6bb3-5ade-b17e-658e077953d1', 'b65aaeff-d522-52c0-a8be-3473d5da6b34', 'This staircase is drawn in full: all the identical cubes are visible, none is hidden. How many cubes are there in total? <svg viewBox="0 0 100 100"><g stroke="#1e293b" stroke-width="1.5" fill="#cbd5e1"><rect x="20" y="66" width="18" height="18"/><rect x="38" y="66" width="18" height="18"/><rect x="56" y="66" width="18" height="18"/><rect x="20" y="48" width="18" height="18"/><rect x="38" y="48" width="18" height="18"/><rect x="20" y="30" width="18" height="18"/></g></svg>', '[{"id":"a","text":"4"},{"id":"b","text":"5"},{"id":"c","text":"6"},{"id":"d","text":"7"}]'::jsonb, 'c', 'Rule: all the cubes are visible, just count them row by row, assuming nothing is hidden. Bottom row: 3 cubes. Middle row: 2 cubes. Top: 1 cube. 3 + 2 + 1 = 6. ✓ option c. Trap a (4): a whole row was forgotten. Trap b (5): a middle row was counted as one cube instead of two. Trap d (7): a hidden cube was added, even though the prompt states that no cube is hidden.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31d26bdd-de43-58de-97ba-84129f881e8c', 'b65aaeff-d522-52c0-a8be-3473d5da6b34', 'Only one of these nets (unfolded) folds into a closed CUBE, with no missing face and no overlapping face. Which one? <svg viewBox="0 0 100 100"><text x="50" y="46" font-size="11" text-anchor="middle" fill="#1e293b">6 carrés = patron du cube.</text><text x="50" y="62" font-size="11" text-anchor="middle" fill="#1e293b">Lequel se replie sans faute ?</text></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#a7f3d0\"><rect x=\"20\" y=\"20\" width=\"18\" height=\"18\"/><rect x=\"38\" y=\"20\" width=\"18\" height=\"18\"/><rect x=\"38\" y=\"38\" width=\"18\" height=\"18\"/><rect x=\"56\" y=\"38\" width=\"18\" height=\"18\"/><rect x=\"56\" y=\"56\" width=\"18\" height=\"18\"/><rect x=\"74\" y=\"56\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#a7f3d0\"><rect x=\"20\" y=\"46\" width=\"18\" height=\"18\"/><rect x=\"38\" y=\"46\" width=\"18\" height=\"18\"/><rect x=\"56\" y=\"46\" width=\"18\" height=\"18\"/><rect x=\"74\" y=\"46\" width=\"18\" height=\"18\"/><rect x=\"20\" y=\"28\" width=\"18\" height=\"18\"/><rect x=\"38\" y=\"28\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#a7f3d0\"><rect x=\"32\" y=\"24\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"24\" width=\"18\" height=\"18\"/><rect x=\"32\" y=\"42\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"42\" width=\"18\" height=\"18\"/><rect x=\"32\" y=\"60\" width=\"18\" height=\"18\"/><rect x=\"50\" y=\"60\" width=\"18\" height=\"18\"/></g></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><g stroke=\"#1e293b\" stroke-width=\"1.5\" fill=\"#a7f3d0\"><rect x=\"24\" y=\"34\" width=\"18\" height=\"18\"/><rect x=\"42\" y=\"34\" width=\"18\" height=\"18\"/><rect x=\"24\" y=\"52\" width=\"18\" height=\"18\"/><rect x=\"42\" y=\"52\" width=\"18\" height=\"18\"/><rect x=\"60\" y=\"34\" width=\"18\" height=\"18\"/><rect x=\"78\" y=\"34\" width=\"18\" height=\"18\"/></g></svg>"}]'::jsonb, 'a', 'Rule: a valid cube net has 6 squares such that on folding none overlaps and each face is unique. Option a is the classic "zigzag" staircase (a stepped shape of offset 2-2-2): it is one of the eleven valid cube nets, and it closes up perfectly. ✓ option a. Trap b: this is a line of FOUR squares with two squares added on the SAME side (above the first two); on folding those two land on the same face and one face is left missing. Trap c: this is a full 2×3 rectangle; folded, two faces overlap and a lid is missing. Trap d: this is a 2×2 square block extended by an arm of two squares; the 2×2 block already makes several faces meet at the same place, so the squares overlap.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('23b72ea2-f7a7-5160-9616-28e916d1d57b', 'b65aaeff-d522-52c0-a8be-3473d5da6b34', 'We overlay the two figures on the left EXACTLY (same center), all strokes are kept. Which option shows the result? On the left: a triangle pointing up; on the right: a triangle pointing down (same size). <svg viewBox="0 0 100 100"><polygon points="22,58 46,58 34,30" fill="none" stroke="#1e293b" stroke-width="4"/><text x="55" y="50" font-size="16" text-anchor="middle" fill="#1e293b">+</text><polygon points="66,30 90,30 78,58" fill="none" stroke="#1e293b" stroke-width="4"/></svg>', '[{"id":"a","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"28,66 72,66 50,28\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><polygon points=\"28,38 72,38 50,76\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"b","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"28,66 72,66 50,28\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"c","text":"<svg viewBox=\"0 0 100 100\"><rect x=\"30\" y=\"34\" width=\"40\" height=\"36\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"},{"id":"d","text":"<svg viewBox=\"0 0 100 100\"><polygon points=\"28,66 72,66 50,28\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/><polygon points=\"36,52 64,52 50,72\" fill=\"none\" stroke=\"#1e293b\" stroke-width=\"4\"/></svg>"}]'::jsonb, 'a', 'Rule: overlaying keeps ALL the strokes of both figures, without transforming or erasing anything. A triangle pointing up stacked on a triangle pointing down of the same size and same center gives the six-pointed star (the "Star of David" symbol), where the two triangles cross. ✓ option a. Trap b: this is the upward triangle alone, the second one was lost. Trap c: the two triangles were replaced by a square — overlaying never creates a new shape. Trap d: the second triangle is too small and nested inside; but the two triangles have the SAME size and must overlap into a star.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6823e8af-4184-5799-a5e9-8da06cb6527b', 'b65aaeff-d522-52c0-a8be-3473d5da6b34', 'How many AXES of symmetry does this figure have? (An axis of symmetry is a line such that the figure maps onto itself by folding along that line.) <svg viewBox="0 0 100 100"><rect x="28" y="28" width="44" height="44" fill="none" stroke="#1e293b" stroke-width="4"/></svg>', '[{"id":"a","text":"1 axis"},{"id":"b","text":"2 axes"},{"id":"c","text":"4 axes"},{"id":"d","text":"Infinitely many axes"}]'::jsonb, 'c', 'Rule: we look for all the fold lines that leave the figure unchanged. The square has exactly 4: the vertical axis (midpoints of the left/right sides), the horizontal axis (midpoints of the top/bottom sides) and the 2 diagonals. ✓ option c (4 axes). Trap a (1): that is the number of axes of an almost-symmetric figure like a heart or an isosceles trapezoid, not a square. Trap b (2): that is the case of a non-square rectangle (only the midlines, not the diagonals) — it forgets that in a square the diagonals are axes too. Trap d (infinitely many): that is the property of the CIRCLE, where every line through the center is an axis; a square has only 4.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

