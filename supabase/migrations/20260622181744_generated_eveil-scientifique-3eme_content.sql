-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: eveil-scientifique-3eme (الإيقاظ العلمي)
-- Regenerate with: npm run content:build
-- Source of truth: content/eveil-scientifique-3eme/
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
  ('eveil-scientifique-3eme', 'الإيقاظ العلمي', 'نكتشفُ معًا عالَم الأحياء والفيزياء: تنقّل الكائنات وتغذيتها وتكاثرها وتنفّسها، والوقاية من الأمراض وحماية المحيط، ثمّ المادّة وحالاتها، والظواهر الدوريّة والزمن، والقوّة والطاقة، وفق برنامج الإيقاظ العلمي للسنة الثالثة من التعليم الأساسي', 'Observation', 'subject-svt', 'Microscope', 2, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '3eme-base'))
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
      AND e.subject_id = 'eveil-scientifique-3eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('bb11410a-de24-5e88-b411-f5f49b5bf76b', '66bfa6f1-c0e6-5f24-b33b-2ed23ef7f23a', '8d4db2d6-2839-5f6a-ab8c-3092ff85f7bb', '8e6da8da-9fec-5df7-af33-dc5e11f1e311', 'b74da70a-cf60-5206-8c20-8111315e0f82', 'c1b65a0e-3f40-53ea-8ae6-79afce1149a4', 'cc9fa80a-9090-5d16-a6e7-c9434eb1c25c', '3fe26b90-6618-50ec-afc0-ce7358dca5bd', '1d16ead3-8d9d-55f7-af17-0484e2244474', '1f220f7c-a979-5e98-a9dd-dc14f01327eb', '59b89286-27d4-5683-bbd8-845b9fb5ff91', '2136cdfa-c17c-5bf6-b551-76dcc30f5830', 'b9751629-81a4-5c19-a72f-f23920479a34', '2fe854b2-9db0-5d69-8684-1fd64a57f211', '630ed88f-148c-5568-b7d8-e9455a5ee72a', '617f00a1-f91e-5081-a28d-4cf0f84c36bf', '267943f6-939a-51e7-a49f-4e3c620452c2', '6fd0a483-5025-5ed3-a9ff-8f96d75e9e8c', 'e5f25b8a-c7e4-5213-b6bc-bb8aaf85292c', 'bcae0d31-990f-524a-8add-327f1bda068e', '967a294b-2448-59eb-ac74-3fcb7e2016c6', '33ea7393-1e03-5984-ac5a-adfa5b504204', '79f0aead-5416-5266-afe9-416e5dfea1ed', 'c98a9f26-98cf-5471-af69-ce64b70139ed', '203be71e-23b8-5903-9342-bcf0e1e85143', '9a81e682-a162-5691-8db7-1fc0556d542e', '0363e0f6-a6d4-5829-b2c1-27ab8dc57e30', 'efb29fe4-3e16-5818-b214-c4047b744623', 'e956486b-3dfd-5ce7-98b4-a713a634c16a', '909eeb55-62c3-5a74-91ed-ba1278a197af', '3ce0d67b-b9db-567d-ab3c-ebfebf001015', 'a1c44fb7-f5a6-529c-bde4-b9b53092b7ba', '5e7c8194-2f7e-5db3-b1ba-883667d525dc', '3fd70238-b247-508c-8a7f-112541727cd1', 'f360ad9a-23aa-5688-8d0b-ac1db72e5bef', '201fb9c0-147c-5c86-88db-93a87952cdb2', '9a67ba1a-7685-5e5b-b9d9-0a3ff42dc4b3', '5e1768d6-0a40-53e2-9caf-7d91af4fa520', '29795088-25d2-597b-b3ce-40ebafa804da', '8f03591b-c3ce-55ec-8a15-64568f4aa6c5', 'c6ec705a-cb52-516d-a07a-856cb79d9ccb', 'd5bfe90d-7548-55cc-81f6-69a33a75527f', 'c2d4d78d-d757-5274-8799-2f76636ba017', '5b0098a7-771f-5de3-9257-d00d0ad6241d', 'a01296c6-a12b-5347-b327-e945fcfafd33', 'f537fc20-d8b3-52db-addb-779e4f9fc5a1', '64043114-6ae6-59f1-b791-3035f98386a8', '907b418c-754d-58d9-ada6-4639dec84327', '7eff0ff8-1f4d-5d41-a196-1a12ae7d175b', '1af403f6-dc4d-5890-8708-2bb2b4a526d8', '1361b202-b36d-549b-85d0-68583e2cb5c3', '29a4bb61-793e-51c9-9f42-5769071f1f81', '188edc0d-8821-57f6-8662-0d9050a4ec65', '52e58ea8-34e9-5d57-b08d-e5cd494ba129', 'df014cfa-8cf9-5394-b506-6169132eb9f9', 'b996a8be-152b-57bc-949e-170028ff1232', '6c6fc414-0e23-568e-a35d-b6819ac19e2c', '132bbfc8-1fa5-58ad-adc9-deadfc8a2c4b', 'd5531426-fd43-55f4-93db-f32b4b3c7ec3', 'aa30df1f-3ac6-525e-a992-b39eb3ae3734', 'c9bd5aad-5183-5b94-8f7c-34157a0acc0b', '90969539-3845-5984-82dc-6761da55b4ea', '086a3606-27c1-547b-b5c4-2c59d5d98523', '64ee1427-e7f5-5795-83a4-c55eb686e7dd', '7e03415f-b7f8-5e0e-af53-700e8dffc913', '5ab19484-50b4-5e4f-995c-c0a8522401ea', '928e72b6-df81-5fd3-99b0-ea166ca4b4a0', '2c75abaf-8e1a-58d9-b311-b7351523f419', 'b3f58ed2-f7c9-5df5-89bc-868362792da0', '40f02b2d-9e63-5ad0-b65e-3488bcb78c91', '6fff6cf6-1749-5712-8668-a26e214474bb', 'c6e4653d-19c1-54ff-a21f-eea4e14051de', 'c5e42aca-a630-5ee9-aa58-df57f4ce80ea', '24e6b9ea-7e4c-5cfa-8611-4132cc792c55', '0fcc6d41-5d2b-57e4-afe6-3a2e136604da', 'e2dcdc4b-c620-5d2e-afb3-6e4e4fc66d50', '2ac6de74-ce32-5faf-b683-de08413f23d1', 'fd5ae9d1-0eb3-55ad-ac44-66c91851b80a', '468f76cb-e65d-514e-a50e-c0902d3824ea', '14837f2d-5ade-5355-8137-4d2a5555b17c', 'c4dfc9d9-58db-5da7-a417-4c51bd0c0764', '1d084c95-5493-5376-897a-e532d63024f3', 'fb428f67-fe60-5f81-bb24-620a827935e9', '502274c6-7b13-5576-9a25-11bc19f011d1', 'ca62f54f-c1bb-5b96-8c26-e5c33147c116', '502aa0b5-2d9d-5c82-942a-4cf3dbc64f71', '5ca3fee0-12c1-597f-8834-595ebdfb1254', 'a13bf184-3324-592f-ad2c-4192e09e2f00', 'ce3f3f09-efff-5fec-be51-f2922f065d5c', '07097a64-81db-52fc-abd1-e47666a95150', 'a21237fd-75af-5b7b-a178-ec7a2eaf4a50', '6f51af09-e8df-5ec1-b2cf-ae8861921a0a', '7718e900-c461-5077-aeea-d97ad4c153f7', 'b4508a9d-6c7e-5c45-b829-460faf480112', 'c3c29088-e94c-52b5-aa75-6e867f3a76ac', 'db3bb2fa-9758-5d90-b909-eef4bfd82645', 'd0d29ec7-0a91-5f36-86eb-db0b4e37ad86', 'db861bbd-0e0d-59fb-b646-5ff668581393', 'c0c5d270-90ab-5d4d-a8d2-2ce4e0ed050b', 'b583f8ff-1124-57f7-8ac7-f3949d191512', '3e55ee53-2e0f-557c-9ee7-dff220632570', '2934d457-d2a8-549c-aaa9-f779a830fdf7', '2946db38-ad8d-5a80-bb7a-4ee936f8b53c', 'aa0a0a61-7940-5893-b99f-316d932518f3', 'ad361f13-6bc3-5b49-9495-bf4af30d626e', '838c0e55-17a2-54ee-9eb4-1a1c408708de', '4a38e340-c7cc-55ef-a80f-54e3c27453e6', 'e20eb246-e4ed-5938-8f3b-28417a820dcf', 'bb57eb28-694b-509e-8cbe-ecc26de17acf', '12382dd7-ec19-53d5-afd4-9b948f8f0bb5', 'c5ce09c3-3205-5fc6-bffd-94caf0aff2dd', '344a22ad-dfe7-5a62-a7dc-db16066ff1a8', 'bfe6a6b7-76df-535e-8ef0-545edbb30c5f', '4aca7167-c614-5e53-a276-2296e1a3fd64', 'ad2a3512-17ac-5615-b5d2-855e4d8059c4', '999910a1-261e-588c-9500-19714e7d294d', 'fec0283a-b4df-5b7e-af48-fb6bbf85380f', 'e954d5b8-a8d1-54f8-9bd7-8a76576cf732', '9e886ae1-baf1-5dff-84a7-6ee2f4779fc4', 'da390d18-1a12-578a-a5eb-bc5a15cf857a', '80a3c039-145f-53c9-995d-57b7c68375db', 'ce2896dc-62d0-5f0e-bb1b-6367c755ee6b', 'a3648561-4fad-5511-9f46-b5f1acb7e54a', '833a203b-626a-5676-a899-a8761d7c91f1', '02079798-ac16-5254-bb74-21656eb19402', '03caf658-e989-5d3e-8880-f0572f5bc223', '0d40cd0c-d3a0-56d7-9757-332d25403383', '8da02554-203e-5de5-8b01-c746c7f2d33d', '4e8fcffe-f544-5004-98f7-237df576d8f1', '4545dd08-0669-56fd-8186-2f83203284f5', 'b0692dac-77dd-5f90-8aff-d7800bf2292a', 'f9d74479-ed57-5a7b-918d-3e3387c176eb', '88f33ab8-3370-5192-9127-2420683b1cc4', '386c96c5-0b4c-59ee-b480-cc044b8a828f', '48e09b9a-fc9f-5311-a458-1caa9bd9345e', '9a1b99ff-4927-57af-8fdd-2a5adf210179', '24ec4f93-ff93-5830-8e6e-9f571251e9a1', 'f4f3b0f7-b4f0-5f28-bb1f-12bcdad637b5', '271b8bd8-8e90-5008-92c6-c938b3520372', 'f16c2187-af2b-5959-8302-ab044847b253', '1851fda8-34a1-5061-8d2e-66a02521e440', 'e224ed07-9a02-51bd-a7a3-eee4c3cd4336', '26fb1571-bdeb-5886-9e60-63abb853ec6c', '16368136-2790-5f5a-870c-640b3a7f5962', '9e000487-c731-5e30-aa63-eabf2b56f76d', 'e6c8fbe2-2f05-5982-975e-d6ed8f85de02', '031d92f2-c3e7-5137-bc50-ee5af8f316bd', '21434c59-10f2-5f33-b01c-979a778dde2a', '0a5f3645-6552-5daf-b0dd-0489b55c34e5', '3f9dd619-fa05-5fec-9c03-15bf27ac2b00', '88f685e6-4828-50ee-8706-58711e49d6d5', '7af3c241-97ea-559f-8e8e-69bfcb37dbdf', '0e856ea5-e194-5b57-b217-f592d4360eb8', '5bcc4e3d-98dc-50ea-b0d5-6d3dcbd4741c', 'a67f05c1-3345-5404-bc2c-745fbdc5033b', '7ecdc787-ea7d-5f92-bdc7-2cdc107bf66c', '9a8b70ee-9406-5e83-9ec8-5b5458866830', '9f15ea57-b19c-5ef6-9b49-0bb681769ed2', '71f51861-9486-5881-a48d-c6dc5f7d4f2f', '8f97d5fe-b72c-54e4-8d6a-6297c1495f85', 'aba0c17c-7ee1-5893-9c5d-bd9351f5ad45', 'f6de4e54-f5d1-5cfa-8e80-31f8a7bad51f', 'dd6025d0-8d2e-5beb-a5f6-314e3f2a176a', 'ed83df1d-d31c-50e6-9d25-b9fb843a0788', '7cc95120-e28b-51dd-b3d9-d362788e02a6', '3c9a5db9-2a32-5639-a365-0ff248632fee', '3b1ca731-db44-5de3-91fd-40d8e800f40c', '653142fc-77ee-5c59-9f5e-64a570ee1cbe', 'b81a46b7-d78d-5489-9824-909c276cf6db', '7ecca1d8-ddd4-54b4-9b40-191f4b207c8f', '42fc189f-c736-5b7e-a7e1-5f02d742b4de', 'df645712-bb94-5465-a277-6a819c587183', '241dfe96-1209-5602-b0d9-7bedfc4717bf', 'fa8b2876-1d44-59f2-a877-675566f432dc', 'ca22510f-f99c-5db7-bd44-b95be4da371d', 'dcdf41cb-4a8a-51ba-86e6-fbafad9cae34', '39981068-9103-5799-aea6-63e742d43deb', '3f968ea1-0f56-5886-80c2-baa15ffdc3b5', 'a9a51cf9-a1a4-5ca2-bb29-6af7ea3f6880', 'd4818fa5-3f7d-5a9b-aa05-9a3d640eca76', '5eb472e0-c7cb-51d6-8a8e-105dda610abf', '033b8ca2-ebb5-555e-89e3-1ea7c2852772', '76321773-a5c4-59b8-aabc-96e39b443ee5', 'ef5a6c3f-419f-5c62-bdea-4087d421fdc6', '21387613-e6bb-5453-b608-9f818d158725', 'd1659b0d-c9fd-5dde-8e32-0cd67747d368', 'ed930136-e8c3-5099-b5cb-ed512fdb3244', '155d80f8-4bf8-5817-b1bd-439b4644acaf', '7a7463c7-475a-58b7-bc52-c03108c944ab', 'c043924b-71d0-52e9-adf2-57332c4985a6', 'f4221cb8-128c-52f0-8515-a0efe08f6109', '49690b1b-9f6e-5b7b-8559-0ac5ecf33bba', '3aee44e2-fbb0-5a6b-9984-3ebaae47b977', 'f3055d53-791c-5cdd-9501-fcd35e05447e', '9e3901ef-7e74-5baf-a0b7-73e5e73509ae', '0ac5d529-cce5-5031-bf0d-c3b62422aa08', 'a72f509c-4aca-5800-be1c-603e4fa5b8fd', '273d68de-dcc7-5cd3-9432-dff5838a8434', '9225cdb1-062f-5689-b4e5-a7604e76a669', 'd7a00d17-ae24-5575-847c-674a45d8bb03', '246b3f02-5740-5b43-a5d6-4f3764ca4e63', '7f4f9c4f-4783-5502-aaac-67c664ac01fd', '9aceddaa-5d98-5cb1-91d0-8087414a2222', 'e7f9cf6b-b724-521f-a6cf-1e3f081ba0c5', '94a4b73d-b4cb-523e-8f7b-da6bf5fb7856', 'f5338537-24cc-54bb-96a7-9e444bebb6f0', 'fc4e714e-3842-593b-ac3d-071959e95656', '40371059-abbf-54c0-9c24-8b220a81416c', 'b8dfdd51-9f05-53a1-b2de-7a042d96a6ea', '3d02269a-eb67-5976-8ed3-d6833285b628', 'bebc2234-923f-52cd-82ae-957a6f74c1c7', '3b93f1ae-2bdd-5d91-809c-7bdbf2ba94d5', 'ef2949b2-e908-5ab9-9948-be33a245082c', 'fe06cc87-acd5-5e0c-a21e-8cc9b4c70c1e', 'f8a52ee6-d78b-5071-b38b-ca42b7c08c37', '1fbec75e-a704-5dd6-81e9-decf6ca491f9', 'd2df9b5d-7e25-5204-8ffc-eaeea21fe440', '62e50bdd-9bb2-5dee-8d30-7c449d7549ef', '117cf1e8-b045-5292-84cd-b2d016cda4bc', 'e80044f2-8b43-5ecf-9fd5-42e3f9a51f0d', '74bb58a1-d55c-5729-82a6-f2c1b568db1b', '1aeed83f-56bc-51ee-8c07-6f5881120cb7', '90622d31-50c9-5eee-976e-d678a3cb9193', 'a0d885a7-f1ba-5569-893b-55bab5414af8', '30ec4d72-c276-531d-b93a-93bc7a3e675f', 'afd3cfae-e1e5-5d30-8ddd-6596f27ac4ef', '3f008e1e-c1b7-5659-8264-fd12930dd29d', '03a726a2-c4e3-5184-9ac7-fe76a69d483c', '5e27d87c-ddd9-52b5-8dcb-fff30dd5ee1b', '382b739a-e765-5e69-8959-310ac135ac28', '3edf0156-9b50-5ac5-9d2e-12dfcc04bd3a', 'eb1e7a8b-0bf0-5c82-a9e0-6125e9a6af40', 'ac809e78-29e1-5773-b607-d6a014fbc303', '6fc0dd27-6cf5-5ce8-a688-bc77ffc01ddd', 'ce04f13a-dfb2-507c-960d-3fc727230621', 'ef200313-d428-5bfa-99d3-a2f003190f0e', '41f98aa7-91f2-59ea-aaa7-8fed3d451a79', 'bc373ef6-f681-5ce7-ae0c-b5765cffb74c', '73ea2e2f-f82a-5cb0-92f5-2da16b5a8ae1', '09f6cd2a-d2e0-50b8-9726-7f6c1dfc9c10', '04e2562e-fcfc-57e6-ac8e-2633c87145e3', '754c4f0a-32c2-5b30-8d80-0103f2fc7f1f', '1e457f10-79b4-5657-8255-8b111ca9285d', '7a88b66a-18e1-5fc9-ba19-2350e7d67438', 'cc7316a2-d777-5186-92a0-02a09fc5ff2a', '20def9d6-7643-5922-8595-2f13f55031fa', '704c050a-e2e0-56bf-9917-bc1d0300b31a', '2428a8a5-17e6-54c3-9db1-cdde1a4fc905', 'baaccfcf-0fac-5ff3-8938-fee0c55db6ab', '25ee326a-ade3-52de-96ba-c9d5cb250d7f', '03a1f1fc-3772-5860-acc9-4427618030e1', 'f74370e7-2274-5527-8507-8c75ed5de636', 'bd116a31-8c7c-5e61-bfab-338e64dd138c', 'f32bf57d-3187-5058-b565-a869d4a89e2c', 'bb6821f3-d87c-57ac-8874-cd72ecd48dd9', 'c64d8290-99af-590e-85af-abb126e01c26', '18d5e77b-586d-5f72-8289-9a6d8a2d9a56', '968ee3f1-779b-52fa-984b-1dc7f008e1d5', '6493c15a-5401-5189-baf8-413b7ea6d5ae', '8b27b3d7-8476-5e2c-a686-07f06335627c', 'a8e7c05c-e486-56d4-a4ef-e178b639ceee', '8a72e7e8-6222-55ee-ba00-523feecd09d9', 'ac1b3262-f41b-5319-9de4-42050f7ac52a', '2b363fcc-12e1-5b6a-baa8-d91d75fb1c11', '1ac9def8-da52-5786-81b6-d1780c6c5611', 'e8c0b191-8a83-5b98-8bfc-c5e15079c7ec', '78dc57aa-eb02-57d6-bf1e-04072f8129d1', '6fc2a669-7307-54fb-a6ec-9f866d779bb4', '7d994e1b-fc83-52dd-89c7-be275faa5ece', '5f087729-22c6-5b33-97a6-c3e74c557c37', '3722028e-0657-5485-9cff-bfc9315fcf50', '2b1cd3ee-f373-5bc8-afbe-589a44e5d19b', 'f571a191-cd4e-5c64-a66b-c28cb412351d', 'ff7ace32-4e00-5e86-a320-8b8806db79c7', '7972576e-cd59-5896-b828-f0f435929a5b', 'fce5859b-2b6b-5b37-b120-aa6c479ee844', 'a9248d9f-767b-5005-acd2-5e5145863319', 'e71cf5e5-b009-5f2e-852c-4a25ef2faca7', '487602bf-b08c-5e0f-a623-7206f9cd5f85', '9a7688b1-5b4a-5bbf-882f-4f421e20ae85');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'eveil-scientifique-3eme' AND source = 'admin' AND id NOT IN ('0771f6cd-8796-53f2-893b-f52bb597a77a', '6805acf9-51e1-55ed-90da-b484cfa3020e', 'e34620a9-4fee-50f3-b74f-a51c2b9a30d2', '781e8fe2-22e1-5abd-b5d0-b0fd31f03124', '058227b7-d12a-5f85-88db-af0827e8f1b6', '0abbee05-7ed5-563c-9140-0821db9fb4d0', 'c119104a-d854-5912-8869-c841c44588d6', '40686eb3-858d-57b7-aaf3-461b3ec644b3', 'ac839152-7e14-519b-89e5-4cbfc8866534', 'ed36dca3-31e6-5d31-9ec0-381335cf4938', 'f0505ce7-5626-5c03-86aa-0ed48290a70a', 'c3d9e955-5da2-5706-a3c9-d34791293307', 'b4e13aeb-1d88-5a7d-b66e-faa404fa35eb', '308926e6-b51d-5042-8f5f-84f088e093bf', '7cb680ff-de36-590d-b632-a17fe212c918', '814c8c8d-f22d-50cf-989d-9f414f4e0e59', 'cf9127ba-01a9-5b5b-baca-033b74f63e57', 'cdc4c5a3-bf77-58d5-a948-a2fdfafb5209', 'ba3b6477-bcad-5f38-a584-a2517217a506', '0265bdf5-50ff-5e90-a80f-254af46d2e03', '27b946d0-27e6-5f18-a24b-d563625cf214', 'bf374d4e-1234-5128-bedf-5a88eb8949ad', '7d2d4571-bb04-5301-9ba8-d13c3da0eb98', '8d8f051e-bde2-536b-9d82-b184f47b6d27', '3256ed2c-684d-5664-9d4c-b71a687b2f1e', '5fb03394-a84a-5bee-a13c-83e173230341', '06725754-8b07-5055-9d8d-652fdc509d6e', 'b13c0bb5-5c5c-566e-9786-e3f88aed12cf', '42f6f2d2-560d-5778-a779-cd9228b342b4', 'ce5a5c0a-6580-5552-9cb4-80b3d78503f4', '9345c122-e999-535a-9d64-5c27e3431794', 'f500c587-6396-5711-9307-9a90e03592e9', 'ee315ad6-50dd-56cd-b59a-3799db9563b7', '396b90f8-7ea9-575c-a69d-0a6d9bc49890', '686a98af-a9c0-5fc3-a21c-f9c215d9a5bf', '0099bc5b-c5d7-5600-94f3-a0100e6b62a0', '96bd545d-0cda-5a35-9471-6a39d0478849', '75a01912-e415-5960-82ee-a0a128618d2c', '68592c1d-a39c-5113-9346-c57e2163c2ca', '35216c88-3439-5041-ae7c-a62ef9b71ad8', '0a1b5544-5073-5076-b802-6585ec7f0656', '55970a5c-b424-5d01-bd3b-c128db47d5e4', '80ad0229-378a-50e9-abf8-f4bf60a4dcaa', '73db542a-f2bd-5dab-aa29-ec552ab04a61', 'd0004ce2-57dd-5314-bd0e-e57140250779', '856a0ddf-0b86-5dc0-8bdf-a058c10eba1e', '46d04808-9815-5548-9820-b5e574995a63', 'c898fcf9-4da5-5e2f-b2b6-d8de51a1a106');
DELETE FROM public.questions WHERE exercise_id IN ('0771f6cd-8796-53f2-893b-f52bb597a77a', '6805acf9-51e1-55ed-90da-b484cfa3020e', 'e34620a9-4fee-50f3-b74f-a51c2b9a30d2', '781e8fe2-22e1-5abd-b5d0-b0fd31f03124', '058227b7-d12a-5f85-88db-af0827e8f1b6', '0abbee05-7ed5-563c-9140-0821db9fb4d0', 'c119104a-d854-5912-8869-c841c44588d6', '40686eb3-858d-57b7-aaf3-461b3ec644b3', 'ac839152-7e14-519b-89e5-4cbfc8866534', 'ed36dca3-31e6-5d31-9ec0-381335cf4938', 'f0505ce7-5626-5c03-86aa-0ed48290a70a', 'c3d9e955-5da2-5706-a3c9-d34791293307', 'b4e13aeb-1d88-5a7d-b66e-faa404fa35eb', '308926e6-b51d-5042-8f5f-84f088e093bf', '7cb680ff-de36-590d-b632-a17fe212c918', '814c8c8d-f22d-50cf-989d-9f414f4e0e59', 'cf9127ba-01a9-5b5b-baca-033b74f63e57', 'cdc4c5a3-bf77-58d5-a948-a2fdfafb5209', 'ba3b6477-bcad-5f38-a584-a2517217a506', '0265bdf5-50ff-5e90-a80f-254af46d2e03', '27b946d0-27e6-5f18-a24b-d563625cf214', 'bf374d4e-1234-5128-bedf-5a88eb8949ad', '7d2d4571-bb04-5301-9ba8-d13c3da0eb98', '8d8f051e-bde2-536b-9d82-b184f47b6d27', '3256ed2c-684d-5664-9d4c-b71a687b2f1e', '5fb03394-a84a-5bee-a13c-83e173230341', '06725754-8b07-5055-9d8d-652fdc509d6e', 'b13c0bb5-5c5c-566e-9786-e3f88aed12cf', '42f6f2d2-560d-5778-a779-cd9228b342b4', 'ce5a5c0a-6580-5552-9cb4-80b3d78503f4', '9345c122-e999-535a-9d64-5c27e3431794', 'f500c587-6396-5711-9307-9a90e03592e9', 'ee315ad6-50dd-56cd-b59a-3799db9563b7', '396b90f8-7ea9-575c-a69d-0a6d9bc49890', '686a98af-a9c0-5fc3-a21c-f9c215d9a5bf', '0099bc5b-c5d7-5600-94f3-a0100e6b62a0', '96bd545d-0cda-5a35-9471-6a39d0478849', '75a01912-e415-5960-82ee-a0a128618d2c', '68592c1d-a39c-5113-9346-c57e2163c2ca', '35216c88-3439-5041-ae7c-a62ef9b71ad8', '0a1b5544-5073-5076-b802-6585ec7f0656', '55970a5c-b424-5d01-bd3b-c128db47d5e4', '80ad0229-378a-50e9-abf8-f4bf60a4dcaa', '73db542a-f2bd-5dab-aa29-ec552ab04a61', 'd0004ce2-57dd-5314-bd0e-e57140250779', '856a0ddf-0b86-5dc0-8bdf-a058c10eba1e', '46d04808-9815-5548-9820-b5e574995a63', 'c898fcf9-4da5-5e2f-b2b6-d8de51a1a106') AND id NOT IN ('bb11410a-de24-5e88-b411-f5f49b5bf76b', '66bfa6f1-c0e6-5f24-b33b-2ed23ef7f23a', '8d4db2d6-2839-5f6a-ab8c-3092ff85f7bb', '8e6da8da-9fec-5df7-af33-dc5e11f1e311', 'b74da70a-cf60-5206-8c20-8111315e0f82', 'c1b65a0e-3f40-53ea-8ae6-79afce1149a4', 'cc9fa80a-9090-5d16-a6e7-c9434eb1c25c', '3fe26b90-6618-50ec-afc0-ce7358dca5bd', '1d16ead3-8d9d-55f7-af17-0484e2244474', '1f220f7c-a979-5e98-a9dd-dc14f01327eb', '59b89286-27d4-5683-bbd8-845b9fb5ff91', '2136cdfa-c17c-5bf6-b551-76dcc30f5830', 'b9751629-81a4-5c19-a72f-f23920479a34', '2fe854b2-9db0-5d69-8684-1fd64a57f211', '630ed88f-148c-5568-b7d8-e9455a5ee72a', '617f00a1-f91e-5081-a28d-4cf0f84c36bf', '267943f6-939a-51e7-a49f-4e3c620452c2', '6fd0a483-5025-5ed3-a9ff-8f96d75e9e8c', 'e5f25b8a-c7e4-5213-b6bc-bb8aaf85292c', 'bcae0d31-990f-524a-8add-327f1bda068e', '967a294b-2448-59eb-ac74-3fcb7e2016c6', '33ea7393-1e03-5984-ac5a-adfa5b504204', '79f0aead-5416-5266-afe9-416e5dfea1ed', 'c98a9f26-98cf-5471-af69-ce64b70139ed', '203be71e-23b8-5903-9342-bcf0e1e85143', '9a81e682-a162-5691-8db7-1fc0556d542e', '0363e0f6-a6d4-5829-b2c1-27ab8dc57e30', 'efb29fe4-3e16-5818-b214-c4047b744623', 'e956486b-3dfd-5ce7-98b4-a713a634c16a', '909eeb55-62c3-5a74-91ed-ba1278a197af', '3ce0d67b-b9db-567d-ab3c-ebfebf001015', 'a1c44fb7-f5a6-529c-bde4-b9b53092b7ba', '5e7c8194-2f7e-5db3-b1ba-883667d525dc', '3fd70238-b247-508c-8a7f-112541727cd1', 'f360ad9a-23aa-5688-8d0b-ac1db72e5bef', '201fb9c0-147c-5c86-88db-93a87952cdb2', '9a67ba1a-7685-5e5b-b9d9-0a3ff42dc4b3', '5e1768d6-0a40-53e2-9caf-7d91af4fa520', '29795088-25d2-597b-b3ce-40ebafa804da', '8f03591b-c3ce-55ec-8a15-64568f4aa6c5', 'c6ec705a-cb52-516d-a07a-856cb79d9ccb', 'd5bfe90d-7548-55cc-81f6-69a33a75527f', 'c2d4d78d-d757-5274-8799-2f76636ba017', '5b0098a7-771f-5de3-9257-d00d0ad6241d', 'a01296c6-a12b-5347-b327-e945fcfafd33', 'f537fc20-d8b3-52db-addb-779e4f9fc5a1', '64043114-6ae6-59f1-b791-3035f98386a8', '907b418c-754d-58d9-ada6-4639dec84327', '7eff0ff8-1f4d-5d41-a196-1a12ae7d175b', '1af403f6-dc4d-5890-8708-2bb2b4a526d8', '1361b202-b36d-549b-85d0-68583e2cb5c3', '29a4bb61-793e-51c9-9f42-5769071f1f81', '188edc0d-8821-57f6-8662-0d9050a4ec65', '52e58ea8-34e9-5d57-b08d-e5cd494ba129', 'df014cfa-8cf9-5394-b506-6169132eb9f9', 'b996a8be-152b-57bc-949e-170028ff1232', '6c6fc414-0e23-568e-a35d-b6819ac19e2c', '132bbfc8-1fa5-58ad-adc9-deadfc8a2c4b', 'd5531426-fd43-55f4-93db-f32b4b3c7ec3', 'aa30df1f-3ac6-525e-a992-b39eb3ae3734', 'c9bd5aad-5183-5b94-8f7c-34157a0acc0b', '90969539-3845-5984-82dc-6761da55b4ea', '086a3606-27c1-547b-b5c4-2c59d5d98523', '64ee1427-e7f5-5795-83a4-c55eb686e7dd', '7e03415f-b7f8-5e0e-af53-700e8dffc913', '5ab19484-50b4-5e4f-995c-c0a8522401ea', '928e72b6-df81-5fd3-99b0-ea166ca4b4a0', '2c75abaf-8e1a-58d9-b311-b7351523f419', 'b3f58ed2-f7c9-5df5-89bc-868362792da0', '40f02b2d-9e63-5ad0-b65e-3488bcb78c91', '6fff6cf6-1749-5712-8668-a26e214474bb', 'c6e4653d-19c1-54ff-a21f-eea4e14051de', 'c5e42aca-a630-5ee9-aa58-df57f4ce80ea', '24e6b9ea-7e4c-5cfa-8611-4132cc792c55', '0fcc6d41-5d2b-57e4-afe6-3a2e136604da', 'e2dcdc4b-c620-5d2e-afb3-6e4e4fc66d50', '2ac6de74-ce32-5faf-b683-de08413f23d1', 'fd5ae9d1-0eb3-55ad-ac44-66c91851b80a', '468f76cb-e65d-514e-a50e-c0902d3824ea', '14837f2d-5ade-5355-8137-4d2a5555b17c', 'c4dfc9d9-58db-5da7-a417-4c51bd0c0764', '1d084c95-5493-5376-897a-e532d63024f3', 'fb428f67-fe60-5f81-bb24-620a827935e9', '502274c6-7b13-5576-9a25-11bc19f011d1', 'ca62f54f-c1bb-5b96-8c26-e5c33147c116', '502aa0b5-2d9d-5c82-942a-4cf3dbc64f71', '5ca3fee0-12c1-597f-8834-595ebdfb1254', 'a13bf184-3324-592f-ad2c-4192e09e2f00', 'ce3f3f09-efff-5fec-be51-f2922f065d5c', '07097a64-81db-52fc-abd1-e47666a95150', 'a21237fd-75af-5b7b-a178-ec7a2eaf4a50', '6f51af09-e8df-5ec1-b2cf-ae8861921a0a', '7718e900-c461-5077-aeea-d97ad4c153f7', 'b4508a9d-6c7e-5c45-b829-460faf480112', 'c3c29088-e94c-52b5-aa75-6e867f3a76ac', 'db3bb2fa-9758-5d90-b909-eef4bfd82645', 'd0d29ec7-0a91-5f36-86eb-db0b4e37ad86', 'db861bbd-0e0d-59fb-b646-5ff668581393', 'c0c5d270-90ab-5d4d-a8d2-2ce4e0ed050b', 'b583f8ff-1124-57f7-8ac7-f3949d191512', '3e55ee53-2e0f-557c-9ee7-dff220632570', '2934d457-d2a8-549c-aaa9-f779a830fdf7', '2946db38-ad8d-5a80-bb7a-4ee936f8b53c', 'aa0a0a61-7940-5893-b99f-316d932518f3', 'ad361f13-6bc3-5b49-9495-bf4af30d626e', '838c0e55-17a2-54ee-9eb4-1a1c408708de', '4a38e340-c7cc-55ef-a80f-54e3c27453e6', 'e20eb246-e4ed-5938-8f3b-28417a820dcf', 'bb57eb28-694b-509e-8cbe-ecc26de17acf', '12382dd7-ec19-53d5-afd4-9b948f8f0bb5', 'c5ce09c3-3205-5fc6-bffd-94caf0aff2dd', '344a22ad-dfe7-5a62-a7dc-db16066ff1a8', 'bfe6a6b7-76df-535e-8ef0-545edbb30c5f', '4aca7167-c614-5e53-a276-2296e1a3fd64', 'ad2a3512-17ac-5615-b5d2-855e4d8059c4', '999910a1-261e-588c-9500-19714e7d294d', 'fec0283a-b4df-5b7e-af48-fb6bbf85380f', 'e954d5b8-a8d1-54f8-9bd7-8a76576cf732', '9e886ae1-baf1-5dff-84a7-6ee2f4779fc4', 'da390d18-1a12-578a-a5eb-bc5a15cf857a', '80a3c039-145f-53c9-995d-57b7c68375db', 'ce2896dc-62d0-5f0e-bb1b-6367c755ee6b', 'a3648561-4fad-5511-9f46-b5f1acb7e54a', '833a203b-626a-5676-a899-a8761d7c91f1', '02079798-ac16-5254-bb74-21656eb19402', '03caf658-e989-5d3e-8880-f0572f5bc223', '0d40cd0c-d3a0-56d7-9757-332d25403383', '8da02554-203e-5de5-8b01-c746c7f2d33d', '4e8fcffe-f544-5004-98f7-237df576d8f1', '4545dd08-0669-56fd-8186-2f83203284f5', 'b0692dac-77dd-5f90-8aff-d7800bf2292a', 'f9d74479-ed57-5a7b-918d-3e3387c176eb', '88f33ab8-3370-5192-9127-2420683b1cc4', '386c96c5-0b4c-59ee-b480-cc044b8a828f', '48e09b9a-fc9f-5311-a458-1caa9bd9345e', '9a1b99ff-4927-57af-8fdd-2a5adf210179', '24ec4f93-ff93-5830-8e6e-9f571251e9a1', 'f4f3b0f7-b4f0-5f28-bb1f-12bcdad637b5', '271b8bd8-8e90-5008-92c6-c938b3520372', 'f16c2187-af2b-5959-8302-ab044847b253', '1851fda8-34a1-5061-8d2e-66a02521e440', 'e224ed07-9a02-51bd-a7a3-eee4c3cd4336', '26fb1571-bdeb-5886-9e60-63abb853ec6c', '16368136-2790-5f5a-870c-640b3a7f5962', '9e000487-c731-5e30-aa63-eabf2b56f76d', 'e6c8fbe2-2f05-5982-975e-d6ed8f85de02', '031d92f2-c3e7-5137-bc50-ee5af8f316bd', '21434c59-10f2-5f33-b01c-979a778dde2a', '0a5f3645-6552-5daf-b0dd-0489b55c34e5', '3f9dd619-fa05-5fec-9c03-15bf27ac2b00', '88f685e6-4828-50ee-8706-58711e49d6d5', '7af3c241-97ea-559f-8e8e-69bfcb37dbdf', '0e856ea5-e194-5b57-b217-f592d4360eb8', '5bcc4e3d-98dc-50ea-b0d5-6d3dcbd4741c', 'a67f05c1-3345-5404-bc2c-745fbdc5033b', '7ecdc787-ea7d-5f92-bdc7-2cdc107bf66c', '9a8b70ee-9406-5e83-9ec8-5b5458866830', '9f15ea57-b19c-5ef6-9b49-0bb681769ed2', '71f51861-9486-5881-a48d-c6dc5f7d4f2f', '8f97d5fe-b72c-54e4-8d6a-6297c1495f85', 'aba0c17c-7ee1-5893-9c5d-bd9351f5ad45', 'f6de4e54-f5d1-5cfa-8e80-31f8a7bad51f', 'dd6025d0-8d2e-5beb-a5f6-314e3f2a176a', 'ed83df1d-d31c-50e6-9d25-b9fb843a0788', '7cc95120-e28b-51dd-b3d9-d362788e02a6', '3c9a5db9-2a32-5639-a365-0ff248632fee', '3b1ca731-db44-5de3-91fd-40d8e800f40c', '653142fc-77ee-5c59-9f5e-64a570ee1cbe', 'b81a46b7-d78d-5489-9824-909c276cf6db', '7ecca1d8-ddd4-54b4-9b40-191f4b207c8f', '42fc189f-c736-5b7e-a7e1-5f02d742b4de', 'df645712-bb94-5465-a277-6a819c587183', '241dfe96-1209-5602-b0d9-7bedfc4717bf', 'fa8b2876-1d44-59f2-a877-675566f432dc', 'ca22510f-f99c-5db7-bd44-b95be4da371d', 'dcdf41cb-4a8a-51ba-86e6-fbafad9cae34', '39981068-9103-5799-aea6-63e742d43deb', '3f968ea1-0f56-5886-80c2-baa15ffdc3b5', 'a9a51cf9-a1a4-5ca2-bb29-6af7ea3f6880', 'd4818fa5-3f7d-5a9b-aa05-9a3d640eca76', '5eb472e0-c7cb-51d6-8a8e-105dda610abf', '033b8ca2-ebb5-555e-89e3-1ea7c2852772', '76321773-a5c4-59b8-aabc-96e39b443ee5', 'ef5a6c3f-419f-5c62-bdea-4087d421fdc6', '21387613-e6bb-5453-b608-9f818d158725', 'd1659b0d-c9fd-5dde-8e32-0cd67747d368', 'ed930136-e8c3-5099-b5cb-ed512fdb3244', '155d80f8-4bf8-5817-b1bd-439b4644acaf', '7a7463c7-475a-58b7-bc52-c03108c944ab', 'c043924b-71d0-52e9-adf2-57332c4985a6', 'f4221cb8-128c-52f0-8515-a0efe08f6109', '49690b1b-9f6e-5b7b-8559-0ac5ecf33bba', '3aee44e2-fbb0-5a6b-9984-3ebaae47b977', 'f3055d53-791c-5cdd-9501-fcd35e05447e', '9e3901ef-7e74-5baf-a0b7-73e5e73509ae', '0ac5d529-cce5-5031-bf0d-c3b62422aa08', 'a72f509c-4aca-5800-be1c-603e4fa5b8fd', '273d68de-dcc7-5cd3-9432-dff5838a8434', '9225cdb1-062f-5689-b4e5-a7604e76a669', 'd7a00d17-ae24-5575-847c-674a45d8bb03', '246b3f02-5740-5b43-a5d6-4f3764ca4e63', '7f4f9c4f-4783-5502-aaac-67c664ac01fd', '9aceddaa-5d98-5cb1-91d0-8087414a2222', 'e7f9cf6b-b724-521f-a6cf-1e3f081ba0c5', '94a4b73d-b4cb-523e-8f7b-da6bf5fb7856', 'f5338537-24cc-54bb-96a7-9e444bebb6f0', 'fc4e714e-3842-593b-ac3d-071959e95656', '40371059-abbf-54c0-9c24-8b220a81416c', 'b8dfdd51-9f05-53a1-b2de-7a042d96a6ea', '3d02269a-eb67-5976-8ed3-d6833285b628', 'bebc2234-923f-52cd-82ae-957a6f74c1c7', '3b93f1ae-2bdd-5d91-809c-7bdbf2ba94d5', 'ef2949b2-e908-5ab9-9948-be33a245082c', 'fe06cc87-acd5-5e0c-a21e-8cc9b4c70c1e', 'f8a52ee6-d78b-5071-b38b-ca42b7c08c37', '1fbec75e-a704-5dd6-81e9-decf6ca491f9', 'd2df9b5d-7e25-5204-8ffc-eaeea21fe440', '62e50bdd-9bb2-5dee-8d30-7c449d7549ef', '117cf1e8-b045-5292-84cd-b2d016cda4bc', 'e80044f2-8b43-5ecf-9fd5-42e3f9a51f0d', '74bb58a1-d55c-5729-82a6-f2c1b568db1b', '1aeed83f-56bc-51ee-8c07-6f5881120cb7', '90622d31-50c9-5eee-976e-d678a3cb9193', 'a0d885a7-f1ba-5569-893b-55bab5414af8', '30ec4d72-c276-531d-b93a-93bc7a3e675f', 'afd3cfae-e1e5-5d30-8ddd-6596f27ac4ef', '3f008e1e-c1b7-5659-8264-fd12930dd29d', '03a726a2-c4e3-5184-9ac7-fe76a69d483c', '5e27d87c-ddd9-52b5-8dcb-fff30dd5ee1b', '382b739a-e765-5e69-8959-310ac135ac28', '3edf0156-9b50-5ac5-9d2e-12dfcc04bd3a', 'eb1e7a8b-0bf0-5c82-a9e0-6125e9a6af40', 'ac809e78-29e1-5773-b607-d6a014fbc303', '6fc0dd27-6cf5-5ce8-a688-bc77ffc01ddd', 'ce04f13a-dfb2-507c-960d-3fc727230621', 'ef200313-d428-5bfa-99d3-a2f003190f0e', '41f98aa7-91f2-59ea-aaa7-8fed3d451a79', 'bc373ef6-f681-5ce7-ae0c-b5765cffb74c', '73ea2e2f-f82a-5cb0-92f5-2da16b5a8ae1', '09f6cd2a-d2e0-50b8-9726-7f6c1dfc9c10', '04e2562e-fcfc-57e6-ac8e-2633c87145e3', '754c4f0a-32c2-5b30-8d80-0103f2fc7f1f', '1e457f10-79b4-5657-8255-8b111ca9285d', '7a88b66a-18e1-5fc9-ba19-2350e7d67438', 'cc7316a2-d777-5186-92a0-02a09fc5ff2a', '20def9d6-7643-5922-8595-2f13f55031fa', '704c050a-e2e0-56bf-9917-bc1d0300b31a', '2428a8a5-17e6-54c3-9db1-cdde1a4fc905', 'baaccfcf-0fac-5ff3-8938-fee0c55db6ab', '25ee326a-ade3-52de-96ba-c9d5cb250d7f', '03a1f1fc-3772-5860-acc9-4427618030e1', 'f74370e7-2274-5527-8507-8c75ed5de636', 'bd116a31-8c7c-5e61-bfab-338e64dd138c', 'f32bf57d-3187-5058-b565-a869d4a89e2c', 'bb6821f3-d87c-57ac-8874-cd72ecd48dd9', 'c64d8290-99af-590e-85af-abb126e01c26', '18d5e77b-586d-5f72-8289-9a6d8a2d9a56', '968ee3f1-779b-52fa-984b-1dc7f008e1d5', '6493c15a-5401-5189-baf8-413b7ea6d5ae', '8b27b3d7-8476-5e2c-a686-07f06335627c', 'a8e7c05c-e486-56d4-a4ef-e178b639ceee', '8a72e7e8-6222-55ee-ba00-523feecd09d9', 'ac1b3262-f41b-5319-9de4-42050f7ac52a', '2b363fcc-12e1-5b6a-baa8-d91d75fb1c11', '1ac9def8-da52-5786-81b6-d1780c6c5611', 'e8c0b191-8a83-5b98-8bfc-c5e15079c7ec', '78dc57aa-eb02-57d6-bf1e-04072f8129d1', '6fc2a669-7307-54fb-a6ec-9f866d779bb4', '7d994e1b-fc83-52dd-89c7-be275faa5ece', '5f087729-22c6-5b33-97a6-c3e74c557c37', '3722028e-0657-5485-9cff-bfc9315fcf50', '2b1cd3ee-f373-5bc8-afbe-589a44e5d19b', 'f571a191-cd4e-5c64-a66b-c28cb412351d', 'ff7ace32-4e00-5e86-a320-8b8806db79c7', '7972576e-cd59-5896-b828-f0f435929a5b', 'fce5859b-2b6b-5b37-b120-aa6c479ee844', 'a9248d9f-767b-5005-acd2-5e5145863319', 'e71cf5e5-b009-5f2e-852c-4a25ef2faca7', '487602bf-b08c-5e0f-a623-7206f9cd5f85', '9a7688b1-5b4a-5bbf-882f-4f421e20ae85');
DELETE FROM public.chapters c WHERE c.subject_id = 'eveil-scientifique-3eme' AND c.id NOT IN ('33110808-20e9-5093-bd9a-5641bd0ef873', 'd28e5b7a-16ef-528f-9ca4-3da1a8763005', '06e7a563-9ae6-56c5-ace2-7f8233bd3080', 'dcbdca56-05f5-53b6-b86f-eae4775f02d1', '7dc97c37-3ead-596b-b689-baa026f5f3a1', '7fb3f737-9068-51ce-9269-6c07e3b3bee5', '8f032ef5-65c4-571f-b649-55e38b021307', 'e1dd5afc-6c37-5ac3-ada1-73410f1f5b54') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('33110808-20e9-5093-bd9a-5641bd0ef873', 'eveil-scientifique-3eme', 'التنقّل في البرّ والماء والهواء', 'لماذا تتنقّل الكائنات الحيّة؟ التنقّل في البرّ (المشي، الزحف، القفز)، والتنقّل في الماء (السباحة)، والتنقّل في الهواء (الطيران)، وأعضاء التنقّل عند الحيوان والإنسان', '# ⚔️ التنقّل في البرّ والماء والهواء — رحلة الكائنات الحيّة

> 💡 «كلّ كائنٍ حيٍّ يتنقّل: ليبحث عن غذائه، وعن مأواه، وليهرب من الخطر.»

أنت تعرف أنّ القطّة تمشي، والسمكة تسبح، والعصفور يطير. كلّها **تتنقّل**، أي تنتقل من مكانٍ إلى آخر. هيّا نكتشف كيف ولماذا.

## 🏃 لماذا تتنقّل الكائنات الحيّة؟

تتنقّل الكائنات الحيّة لأسبابٍ كثيرة:

- لتبحث عن **الغذاء** والماء.
- لتبحث عن **مأوى** آمن.
- لتهرب من **الخطر** ومن الأعداء.

*مثال: الغزال يجري بسرعةٍ ليهرب من الأسد.*

## 🐫 التنقّل في البرّ

في البرّ، تتنقّل الحيوانات بطرقٍ مختلفة:

| طريقة التنقّل | مثال |
| --- | --- |
| **المشي والجري** | الحصان، القطّة، الإنسان |
| **الزحف** | الأفعى، الحلزون |
| **القفز** | الأرنب، الضّفدع |

تستعمل حيوانات البرّ **الأرجل** غالبًا للمشي والجري والقفز.

<svg viewBox="0 0 240 130" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="105" width="240" height="25" fill="#86c34a" stroke="#2f6b12" stroke-width="2"/>
  <g stroke="#5a3210" stroke-width="2">
    <ellipse cx="70" cy="70" rx="42" ry="24" fill="#e69138"/>
    <circle cx="32" cy="58" r="16" fill="#e69138"/>
    <path d="M22 50 l-6 -12 l10 6 z" fill="#c97a1e"/>
    <line x1="55" y1="92" x2="55" y2="105"/>
    <line x1="78" y1="92" x2="78" y2="105"/>
    <line x1="95" y1="92" x2="95" y2="105"/>
    <path d="M112 66 q14 -2 22 8" fill="none"/>
  </g>
  <circle cx="26" cy="55" r="2.5" fill="#1f2937" stroke="none"/>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="150" y="62">حيوانٌ يمشي</text>
    <text x="150" y="78">على أرجله</text>
  </g>
</svg>

## 🐟 التنقّل في الماء

في الماء، تتنقّل الحيوانات بـ**السباحة**. السمكة تسبح بمساعدة **زعانفها** و**ذيلها**. تدفع الماء بذيلها فتتقدّم.

*مثال: السمكة، والسلحفاة البحريّة، والبطّة كلّها تسبح في الماء.*

<svg viewBox="0 0 240 120" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="240" height="120" fill="#bfe6f5" stroke="#1f6f8c" stroke-width="2"/>
  <g stroke="#0f4a5c" stroke-width="2">
    <path d="M60 60 q40 -30 90 0 q-40 30 -90 0 z" fill="#e69138"/>
    <path d="M60 60 l-22 -16 l0 32 z" fill="#d9881f"/>
    <path d="M110 38 l8 -12 l8 12 z" fill="#d9881f"/>
  </g>
  <circle cx="132" cy="56" r="3" fill="#1f2937" stroke="none"/>
  <g font-size="11" fill="#0f4a5c" stroke="none">
    <text x="95" y="100">سمكةٌ تسبح بالذّيل والزعانف</text>
  </g>
</svg>

## 🐦 التنقّل في الهواء

في الهواء، تتنقّل الحيوانات بـ**الطيران**. الطائر يطير بمساعدة **جناحيه**. يحرّك جناحيه فيرتفع في السماء.

*مثال: العصفور، والنحلة، والفراشة كلّها تطير في الهواء.*

<svg viewBox="0 0 240 120" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="240" height="120" fill="#cfeffd" stroke="#7fb8d6" stroke-width="2"/>
  <circle cx="205" cy="28" r="16" fill="#ffd23f" stroke="#e0a400" stroke-width="2"/>
  <g stroke="#5a3210" stroke-width="2">
    <ellipse cx="110" cy="66" rx="30" ry="18" fill="#e0533a"/>
    <circle cx="142" cy="58" r="11" fill="#e0533a"/>
    <path d="M132 54 l12 -2 l-8 8 z" fill="#f6b21b"/>
    <path d="M95 60 q-30 -26 -50 -6 q26 6 48 16 z" fill="#f2a93c"/>
    <path d="M118 60 q-20 -28 -38 -10 q22 4 38 12 z" fill="#f2a93c"/>
  </g>
  <circle cx="146" cy="55" r="2.5" fill="#1f2937" stroke="none"/>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="20" y="105">طائرٌ يطير بجناحيه</text>
  </g>
</svg>

## 🧍 الإنسان يتنقّل أيضًا

الإنسان يتنقّل **مشيًا** على رجليه. وقد يستعمل **وسائل النقل** ليتنقّل بعيدًا وبسرعة: الدرّاجة، والسيّارة، والقطار، والطائرة، والباخرة.

> 🗡️ تذكّر القاعدة: **عضو التنقّل يناسب الوسط.** الأرجل للبرّ، والزعانف للماء، والأجنحة للهواء.

> ⚠️ الفخّ الشائع: بعض الحيوانات تتنقّل في أكثر من وسط! البطّة **تمشي** في البرّ و**تسبح** في الماء و**تطير** في الهواء. فلا تظنّ أنّ كلّ حيوانٍ يتنقّل في وسطٍ واحد فقط.

> 🏆 أحسنت! عرفتَ لماذا تتنقّل الكائنات الحيّة، وكيف تتنقّل في البرّ والماء والهواء. في الفصل القادم نكتشف كيف تتغذّى هذه الكائنات.', '# 📜 ملخّص: التنقّل في البرّ والماء والهواء

- **التنقّل:** انتقال الكائن الحيّ من مكانٍ إلى آخر.
- **لماذا نتنقّل؟** للبحث عن الغذاء، وعن المأوى، وللهروب من الخطر.
- **في البرّ:** المشي والجري (الأرجل)، والزحف (الأفعى، الحلزون)، والقفز (الأرنب، الضّفدع).
- **في الماء:** السباحة بمساعدة الزعانف والذيل (السمكة).
- **في الهواء:** الطيران بمساعدة الجناحين (العصفور، الفراشة).
- **عضو التنقّل يناسب الوسط:** أرجلٌ للبرّ، زعانفُ للماء، أجنحةٌ للهواء.
- **الإنسان** يتنقّل مشيًا، ويستعمل وسائل النقل (السيّارة، القطار، الطائرة) ليتنقّل بعيدًا.
- **انتبه:** بعض الحيوانات تتنقّل في أكثر من وسط، مثل البطّة (تمشي وتسبح وتطير).', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('d28e5b7a-16ef-528f-9ca4-3da1a8763005', 'eveil-scientifique-3eme', 'التغذية: من أين يأتي الغذاء؟', 'مصادر الأغذية (من أصلٍ حيوانيّ ونباتيّ)، وتنوّع غذاء الإنسان وتوازنه، وتصنيف الحيوانات حسب غذائها (عاشبة، لاحمة، آكلة كلّ شيء)، وكيف تصنع النبتة الخضراء غذاءها بنفسها', '# ⚔️ التغذية: من أين يأتي الغذاء؟ — سرّ القوّة والصحّة

> 💡 «كلّ كائنٍ حيٍّ يحتاج إلى الغذاء ليعيش وينمو ويتحرّك. من أين يأتي هذا الغذاء؟»

أنت تأكل الخبز، والتفاحة، واللحم، وتشرب الحليب. كلّها **أغذية** تمنحك القوّة. هيّا نكتشف من أين تأتي، وكيف يتغذّى كلّ كائنٍ حيّ.

## 🍎 مصادر الأغذية: من الحيوان ومن النبات

الأغذية التي نأكلها نوعان حسب مصدرها:

- **أغذية من أصلٍ حيوانيّ:** نأخذها من الحيوان، مثل **اللحم** و**الحليب** و**البيض** و**السمك**.
- **أغذية من أصلٍ نباتيّ:** نأخذها من النبات، مثل **الخضر** و**الغلال** (الفواكه) و**الحبوب** و**الخبز**.

*مثال: البيضة من الدجاجة (أصل حيوانيّ)، والتفاحة من الشجرة (أصل نباتيّ).*

<svg viewBox="0 0 260 130" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="260" height="130" fill="#fff7e6" stroke="#e0a400" stroke-width="2"/>
  <g stroke="#1f2937" stroke-width="2">
    <circle cx="55" cy="58" r="26" fill="#e0533a"/>
    <path d="M55 32 q4 -10 14 -12" fill="none" stroke="#5a3210"/>
    <path d="M55 32 l5 -12 l6 6 z" fill="#3aae6a" stroke="#2c8a52"/>
  </g>
  <g stroke="#5a3210" stroke-width="2">
    <path d="M150 40 C150 28 178 28 178 40 C194 40 194 64 178 64 L150 64 C136 64 136 40 150 40 z" fill="#f3f3f3"/>
    <ellipse cx="164" cy="84" rx="22" ry="14" fill="#ffd23f"/>
  </g>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="34" y="104">تفاحة (نبات)</text>
    <text x="138" y="112">حليب وبيض (حيوان)</text>
  </g>
</svg>

## 🍽️ غذاء الإنسان: متنوّعٌ ومتوازن

الإنسان يأكل من **النبات والحيوان معًا**. لكي يبقى في صحّةٍ جيّدة، يجب أن تكون تغذيته:

- **متنوّعة:** من أصنافٍ مختلفة (خضر، غلال، لحم، حليب، خبز).
- **متوازنة:** لا كثيرًا من نوعٍ واحد، بل قليلًا من كلّ نوع.

*مثال: من يأكل الحلوى فقط يمرض؛ ومن ينوّع غذاءه يبقى قويًّا وسليمًا.*

## 🦁 تصنيف الحيوانات حسب غذائها

ليست كلّ الحيوانات تأكل الشيء نفسه. نصنّفها حسب غذائها إلى ثلاث مجموعات:

| المجموعة | ماذا تأكل؟ | أمثلة |
| --- | --- | --- |
| **عاشبة** (آكلة العشب) | النبات فقط | الأرنب، البقرة، الخروف، الحصان |
| **لاحمة** (آكلة اللحم) | لحوم حيواناتٍ أخرى | الأسد، الذئب، القطّة، النمر |
| **آكلة كلّ شيء** | النبات واللحم معًا | الدجاجة، الدبّ، الإنسان |

<svg viewBox="0 0 280 130" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="280" height="130" fill="#eaf7e0" stroke="#3aae6a" stroke-width="2"/>
  <g stroke="#1f2937" stroke-width="2">
    <ellipse cx="58" cy="70" rx="30" ry="20" fill="#e6c8a0"/>
    <circle cx="30" cy="60" r="14" fill="#e6c8a0"/>
    <path d="M24 48 l-3 -14 l8 8 z" fill="#d8b48a"/>
    <path d="M34 49 l3 -14 l5 10 z" fill="#d8b48a"/>
  </g>
  <circle cx="24" cy="59" r="2.5" fill="#1f2937" stroke="none"/>
  <g stroke="#2c8a52" stroke-width="2">
    <line x1="74" y1="92" x2="74" y2="78"/>
    <line x1="82" y1="92" x2="82" y2="76"/>
    <line x1="90" y1="92" x2="90" y2="78"/>
    <path d="M74 78 l-5 -5 M82 76 l0 -6 M90 78 l5 -5" fill="none"/>
  </g>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="20" y="112">أرنبٌ يأكل العشب = عاشب</text>
    <text x="170" y="40">عاشبة: نبات</text>
    <text x="170" y="60">لاحمة: لحم</text>
    <text x="170" y="80">آكلة كلّ شيء:</text>
    <text x="170" y="96">نبات + لحم</text>
  </g>
</svg>

## 🌱 كيف تتغذّى النبتة الخضراء؟

النبتة الخضراء مميّزة: لا تأكل مثلنا، بل **تصنع غذاءها بنفسها**! تحتاج لذلك إلى أربعة أشياء:

- **ضوء الشمس** ☀️
- **الماء** 💧
- **الهواء** 🌬️
- **التربة** 🟤

من التربة تأخذ الماء، ومن الشمس تأخذ الضوء، فتصنع غذاءها بأوراقها الخضراء.

<svg viewBox="0 0 260 150" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="260" height="150" fill="#cfeffd" stroke="#7fb8d6" stroke-width="2"/>
  <rect x="0" y="110" width="260" height="40" fill="#8a5a2b" stroke="#5a3210" stroke-width="2"/>
  <circle cx="220" cy="32" r="18" fill="#ffd23f" stroke="#e0a400" stroke-width="2"/>
  <g stroke="#e0a400" stroke-width="2">
    <line x1="220" y1="6" x2="220" y2="0"/>
    <line x1="246" y1="32" x2="254" y2="32"/>
    <line x1="240" y1="14" x2="246" y2="9"/>
  </g>
  <g stroke="#2c8a52" stroke-width="3">
    <line x1="120" y1="110" x2="120" y2="56"/>
    <path d="M120 80 q-26 -8 -34 -28 q26 0 34 20 z" fill="#3aae6a"/>
    <path d="M120 70 q26 -8 34 -28 q-26 0 -34 20 z" fill="#3aae6a"/>
    <path d="M120 56 q-12 -10 0 -22 q12 12 0 22 z" fill="#86c34a"/>
  </g>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="10" y="134">التربة والماء</text>
    <text x="150" y="60">شمس + ماء + هواء + تربة</text>
  </g>
</svg>

> 🗡️ تذكّر القاعدة: **الإنسان والحيوان يأكلان غذاءً جاهزًا، أمّا النبتة الخضراء فتصنع غذاءها بنفسها** بفضل الشمس والماء والهواء والتربة.

> ⚠️ الفخّ الشائع: لا تظنّ أنّ كلّ الحيوانات تأكل اللحم! الأرنب والبقرة **عاشبة** تأكل النبات فقط. ولا تظنّ أنّ النبتة «تأكل» التربة؛ فهي **تصنع** غذاءها بنفسها بمساعدة الضوء والماء.

> 🏆 أحسنت! عرفتَ مصادر الأغذية، ولماذا يتنوّع غذاء الإنسان، وكيف نصنّف الحيوانات حسب غذائها، وكيف تصنع النبتة غذاءها. في الفصل القادم نكتشف كيف تتكاثر الكائنات الحيّة وتنمو.', '# 📜 ملخّص: التغذية: من أين يأتي الغذاء؟

- **الغذاء:** كلّ كائنٍ حيٍّ يحتاج إليه ليعيش وينمو ويتحرّك.
- **أغذية من أصلٍ حيوانيّ:** نأخذها من الحيوان، مثل اللحم والحليب والبيض والسمك.
- **أغذية من أصلٍ نباتيّ:** نأخذها من النبات، مثل الخضر والغلال والحبوب والخبز.
- **غذاء الإنسان:** يأكل من النبات والحيوان معًا، ويجب أن يكون **متنوّعًا ومتوازنًا** ليبقى في صحّةٍ جيّدة.
- **الحيوانات العاشبة:** تأكل النبات فقط، مثل الأرنب والبقرة والخروف والحصان.
- **الحيوانات اللاحمة:** تأكل لحوم حيواناتٍ أخرى، مثل الأسد والذئب والقطّة والنمر.
- **آكلة كلّ شيء:** تأكل النبات واللحم معًا، مثل الدجاجة والدبّ والإنسان.
- **النبتة الخضراء:** تصنع غذاءها بنفسها بفضل ضوء الشمس والماء والهواء والتربة.
- **انتبه:** الإنسان والحيوان يأكلان غذاءً جاهزًا، أمّا النبتة فتصنعه بنفسها.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('06e7a563-9ae6-56c5-ace2-7f8233bd3080', 'eveil-scientifique-3eme', 'التكاثر والنموّ', 'كيف تتكاثر الكائنات الحيّة وتنمو؟ التكاثر الزهري عند النبات (زهرة ← ثمرة ← بذرة ← نبتة)، والتكاثر عند الحيوانات البيوضة التي تضع البيض، والتكاثر عند الحيوانات الولودة التي تلد صغارها، ثمّ نموّ الصغير حتّى يصبح بالغًا', '# ⚔️ التكاثر والنموّ — كيف تأتي كائناتٌ جديدة؟

> 💡 «كلّ كائنٍ حيٍّ يولد، ثمّ ينمو، ثمّ يتكاثر فيعطي كائناتٍ جديدةً مثله.»

أنت تعرف أنّ الدجاجة تعطي كتاكيت، والبقرة تلد عجلًا، والبذرة تنبت نبتةً جديدة. كلّ هذا اسمه **التكاثر**: أن يعطي الكائن الحيّ كائنًا جديدًا من نوعه. هيّا نكتشف كيف.

## 🌸 التكاثر الزهري عند النبات

عند كثيرٍ من النباتات، **الزهرة** هي عضو التكاثر. من الزهرة تتكوّن **الثمرة**، وداخل الثمرة توجد **البذور** (الحبوب). إذا زرعنا البذرة في التربة، فإنّها **تنبت** وتعطي نبتةً جديدة.

الدورة بسيطة: **زهرة ← ثمرة ← بذرة ← نبتة جديدة**، ثمّ تكبر النبتة وتُزهر من جديد.

<svg viewBox="0 0 300 130" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="300" height="130" fill="#eaf7ef" stroke="#3aae6a" stroke-width="2"/>
  <g stroke="#2c6e3f" stroke-width="2">
    <line x1="40" y1="105" x2="40" y2="60"/>
    <circle cx="40" cy="45" r="15" fill="#e0533a"/>
    <circle cx="40" cy="45" r="5" fill="#ffd23f" stroke="none"/>
    <path d="M30 38 l-9 -6 l10 -2 z" fill="#e0533a"/>
    <path d="M50 38 l9 -6 l-10 -2 z" fill="#e0533a"/>
  </g>
  <g stroke="#2c6e3f" stroke-width="2">
    <line x1="135" y1="105" x2="135" y2="70"/>
    <circle cx="135" cy="55" r="17" fill="#e0533a"/>
    <path d="M135 38 q6 -8 0 -12" fill="none"/>
  </g>
  <g stroke="#5a3210" stroke-width="2">
    <ellipse cx="215" cy="70" rx="10" ry="14" fill="#7a4a18"/>
  </g>
  <g stroke="#2c6e3f" stroke-width="2">
    <line x1="285" y1="105" x2="285" y2="75"/>
    <path d="M285 80 q-14 -6 -18 -20 q14 2 18 14" fill="#3aae6a"/>
    <path d="M285 80 q14 -6 18 -20 q-14 2 -18 14" fill="#3aae6a"/>
  </g>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="22" y="122">زهرة</text>
    <text x="118" y="122">ثمرة</text>
    <text x="200" y="122">بذرة</text>
    <text x="265" y="122">نبتة</text>
  </g>
  <g font-size="14" fill="#2c6e3f" stroke="none">
    <text x="70" y="68">←</text>
    <text x="170" y="68">←</text>
    <text x="240" y="68">←</text>
  </g>
</svg>

> 🗡️ تذكّر: حبوب اللقاح تساعد على تكوين الثمرة، ثمّ تحمل الثمرة البذور التي تصير نباتاتٍ جديدة.

## 🥚 الحيوانات البيوضة — تضع البيض

بعض الحيوانات **تضع بيضًا**، ومن البيضة يخرج الصغير بعد مدّةٍ من **الحضانة**. هذه الحيوانات اسمها **البيوضة** (الولود البيضيّ): الطيور (الدجاجة، العصفور)، والزواحف، والسمك، والضّفدع.

مثال: تضع الدجاجة بيضًا وترقد عليه، وبعد مدّةٍ يكسر **الكتكوت** القشرة ويخرج من البيضة.

<svg viewBox="0 0 300 130" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="300" height="130" fill="#fff8e6" stroke="#e0a400" stroke-width="2"/>
  <g stroke="#5a3210" stroke-width="2">
    <ellipse cx="60" cy="70" rx="28" ry="36" fill="#fdf3d6"/>
  </g>
  <g stroke="#5a3210" stroke-width="2">
    <path d="M150 50 l8 -8 l6 8 l8 -8 l6 8 l8 -8 l4 8 z" fill="#fdf3d6"/>
    <path d="M150 90 l8 8 l6 -8 l8 8 l6 -8 l8 8 l4 -8 z" fill="#fdf3d6"/>
    <circle cx="180" cy="70" r="20" fill="#ffd23f"/>
    <path d="M198 68 l10 -3 l-9 8 z" fill="#e0533a"/>
  </g>
  <circle cx="186" cy="64" r="3" fill="#1f2937" stroke="none"/>
  <g stroke="#5a3210" stroke-width="2">
    <ellipse cx="262" cy="72" rx="22" ry="26" fill="#ffd23f"/>
    <circle cx="262" cy="40" r="14" fill="#ffd23f"/>
    <path d="M276 38 l10 -2 l-9 7 z" fill="#e0533a"/>
    <path d="M255 90 l0 12" />
    <path d="M269 90 l0 12" />
  </g>
  <circle cx="266" cy="37" r="2.5" fill="#1f2937" stroke="none"/>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="38" y="124">بيضة</text>
    <text x="150" y="124">يخرج الكتكوت</text>
    <text x="248" y="124">دجاجة</text>
  </g>
</svg>

## 🐄 الحيوانات الولودة — تلد صغارها

حيواناتٌ أخرى **تلد صغارًا حيّة** ثمّ **تُرضعها الحليب**. هذه الحيوانات اسمها **الولودة**، وهي **الثدييّات**: البقرة، والقطّة، والكلب، والإنسان.

مثال: تلد البقرة **عِجلًا** صغيرًا حيًّا، فيشرب حليب أمّه ثمّ يكبر.

<svg viewBox="0 0 300 130" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="105" width="300" height="25" fill="#86c34a" stroke="#2f6b12" stroke-width="2"/>
  <g stroke="#5a3210" stroke-width="2">
    <ellipse cx="95" cy="62" rx="50" ry="30" fill="#b87333"/>
    <circle cx="42" cy="52" r="18" fill="#b87333"/>
    <path d="M30 40 l-6 -10 l9 5 z" fill="#8a5424"/>
    <path d="M52 40 l6 -10 l-9 5 z" fill="#8a5424"/>
    <line x1="72" y1="90" x2="72" y2="105"/>
    <line x1="118" y1="90" x2="118" y2="105"/>
    <path d="M145 60 q12 0 16 10" fill="none"/>
  </g>
  <circle cx="36" cy="50" r="2.8" fill="#1f2937" stroke="none"/>
  <g stroke="#5a3210" stroke-width="2">
    <ellipse cx="225" cy="78" rx="30" ry="18" fill="#d49a6a"/>
    <circle cx="195" cy="70" r="11" fill="#d49a6a"/>
    <line x1="210" y1="92" x2="210" y2="105"/>
    <line x1="240" y1="92" x2="240" y2="105"/>
  </g>
  <circle cx="190" cy="68" r="2.5" fill="#1f2937" stroke="none"/>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="70" y="24">البقرة (الأمّ)</text>
    <text x="200" y="40">العِجل</text>
  </g>
</svg>

## 🔁 البيوضة أم الولودة؟

نميّز بين مجموعتين من الحيوانات حسب طريقة تكاثرها:

| المجموعة | كيف تتكاثر؟ | أمثلة |
| --- | --- | --- |
| **البيوضة** | تضع **بيضًا** يخرج منه الصغير | الدجاجة، العصفور، السمك، الضّفدع، الزواحف |
| **الولودة** | **تلد** صغارًا حيّة وتُرضعها الحليب | البقرة، القطّة، الكلب، الإنسان |

> ⚠️ الفخّ الشائع: لا تظنّ أنّ **كلّ** الحيوانات تضع بيضًا! البقرة والقطّة والكلب **تلد** صغارها ولا تضع بيضًا. كما أنّ السمك والضّفدع **يبيضان** وإن كانا يعيشان قرب الماء.

## 🌱 النموّ — من صغيرٍ إلى بالغ

بعد التكاثر، يبدأ الصغير صغيرًا ثمّ **ينمو** ويكبر حتّى يصبح **بالغًا** مثل والديه: الكتكوت يصير دجاجة، والعِجل يصير بقرة، والبذرة تصير نبتةً كبيرة.

هكذا تدور حياة كلّ كائنٍ حيّ: **يولد، ثمّ ينمو، ثمّ يتكاثر** فيعطي كائناتٍ جديدة، وتستمرّ الحياة.

> 🏆 أحسنت! عرفتَ كيف تتكاثر النباتات بالزهرة والبذرة، وكيف تتكاثر الحيوانات البيوضة والولودة، وكيف ينمو الصغير حتّى يصبح بالغًا. في الفصل القادم نكتشف كيف تتنفّس الكائنات الحيّة.', '# 📜 ملخّص: التكاثر والنموّ

- **التكاثر:** أن يعطي الكائن الحيّ كائنًا جديدًا من نوعه.
- **التكاثر الزهري عند النبات:** الزهرة عضو التكاثر؛ منها تتكوّن الثمرة، وفي الثمرة بذور.
- **الدورة عند النبات:** زهرة ← ثمرة ← بذرة ← نبتة جديدة (تُزرع البذرة فتُنبت نبتة).
- **الحيوانات البيوضة:** تضع بيضًا يخرج منه الصغير، مثل الدجاجة والعصفور والسمك والضّفدع.
- **الحيوانات الولودة:** تلد صغارًا حيّة وتُرضعها الحليب، مثل البقرة والقطّة والكلب والإنسان.
- **البيوضة تضع البيض، والولودة تلد:** لا كلّ الحيوانات تبيض، والثدييّات تلد.
- **النموّ:** الصغير ينمو ويكبر حتّى يصبح بالغًا مثل والديه (الكتكوت ← دجاجة، العِجل ← بقرة).
- **دورة الحياة:** كلّ كائنٍ حيٍّ يولد، ثمّ ينمو، ثمّ يتكاثر بدوره فتستمرّ الحياة.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('dcbdca56-05f5-53b6-b86f-eae4775f02d1', 'eveil-scientifique-3eme', 'التنفّس: الشهيق والزفير وقواعد الصحّة', 'كيف نتنفّس؟ حركتا التنفّس (الشهيق والزفير)، وارتفاع القفص الصدري وانخفاضه، وانتظام التنفّس وازدياد سرعته بعد المجهود، والهواء النقيّ والهواء الملوّث، والقواعد الصحّية للتنفّس', '# ⚔️ التنفّس: الشهيق والزفير — نَفَسُ الحياة

> 💡 «أتنفّس في كلّ لحظةٍ دون أن أتوقّف: أُدخِل هواءً نقيًّا، وأُخرِج هواءً مستعملًا.»

ضع يدك على صدرك. هل تشعر به يرتفع ثمّ ينخفض؟ هذا هو **التنفّس**. نتنفّس ليلًا ونهارًا، ونحن نلعب وننام، دون أن نتوقّف. هيّا نكتشف كيف نتنفّس وكيف نحافظ على رئتينا.

## 🫁 جهازي التنفّسي

عندما أتنفّس يدخل الهواء من **الأنف**، ثمّ يمرّ في **القصبة الهوائية**، فيصل إلى **الرئتين** داخل صدري. الرئتان عضوان مهمّان للتنفّس، واحدةٌ على اليمين وواحدةٌ على اليسار.

<svg viewBox="0 0 240 180" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="240" height="180" fill="#ffffff" stroke="#7fb8d6" stroke-width="2"/>
  <g stroke="#1f2937" stroke-width="2">
    <circle cx="120" cy="28" r="18" fill="#f6c9a0"/>
    <line x1="120" y1="46" x2="120" y2="78"/>
    <line x1="108" y1="78" x2="132" y2="78"/>
    <path d="M104 80 q-26 18 -22 56 q2 26 22 30 q14 -30 14 -86 z" fill="#e0533a"/>
    <path d="M136 80 q26 18 22 56 q-2 26 -22 30 q-14 -30 -14 -86 z" fill="#e0533a"/>
  </g>
  <circle cx="116" cy="24" r="2.5" fill="#1f2937" stroke="none"/>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="150" y="40">الأنف</text>
    <text x="150" y="74">القصبة</text>
    <text x="150" y="120">الرئتان</text>
  </g>
</svg>

## 🌬️ حركتا التنفّس: الشهيق والزفير

التنفّس حركتان تتكرّران دائمًا:

- في **الشهيق**: أُدخِل الهواء إلى رئتيّ، فيرتفع **القفص الصدري** ويتمدّد.
- في **الزفير**: أُخرِج الهواء من رئتيّ، فينخفض القفص الصدري ويعود صغيرًا.

| المقارنة | الشهيق 🔼 | الزفير 🔽 |
| --- | --- | --- |
| **الهواء** | يدخل إلى الرئتين | يخرج من الرئتين |
| **القفص الصدري** | يرتفع ويتمدّد | ينخفض ويصغر |
| **نوع الهواء** | هواءٌ نقيّ | هواءٌ مستعمل |

<svg viewBox="0 0 260 160" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="260" height="160" fill="#ffffff" stroke="#7fb8d6" stroke-width="2"/>
  <g stroke="#1f2937" stroke-width="2">
    <ellipse cx="70" cy="90" rx="42" ry="50" fill="#cdeafd"/>
    <path d="M50 95 q20 -16 40 0 q-20 16 -40 0 z" fill="#e0533a"/>
    <path d="M62 36 l8 -16 l8 16 z" fill="#3aae6a"/>
    <ellipse cx="190" cy="96" rx="34" ry="40" fill="#cdeafd"/>
    <path d="M174 100 q16 -12 32 0 q-16 12 -32 0 z" fill="#e0533a"/>
    <path d="M182 150 l8 14 l8 -14 z" fill="#9aa3ad"/>
  </g>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="42" y="150">شهيق: الصدر يرتفع</text>
    <text x="150" y="36">زفير: الصدر ينخفض</text>
  </g>
</svg>

## ⏱️ أتنفّس بانتظام

أتنفّس **بانتظام**: شهيقٌ ثمّ زفير، ثمّ شهيقٌ ثمّ زفير، دون توقّف. ولا أستطيع أن أتوقّف عن التنفّس بإرادتي مدّةً طويلة.

لكنّ سرعة التنفّس تتغيّر: بعد **الجري** أو بذل **مجهود**، أتنفّس **أسرع** لأنّ جسمي يحتاج إلى هواءٍ أكثر. وعندما أستريح يعود تنفّسي هادئًا.

*مثال: بعد لعب كرة القدم ألهث ويعلو صدري بسرعة.*

## 🍃 الهواء النقيّ والهواء الملوّث

نأخذ من الهواء ما نحتاجه للتنفّس. ولكنّ الهواء ليس كلّه نافعًا:

- **الهواء النقيّ** هواءٌ نظيف، مفيدٌ لرئتيّ ولصحّتي.
- **الهواء الملوّث** فيه دخانٌ وغبار، وهو **مضرٌّ** بجهازي التنفّسي.

تساعد **الأشجار** على تنقية الهواء، أمّا دخان **المصانع** والسيّارات فيلوّثه.

<svg viewBox="0 0 260 160" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="260" height="160" fill="#ffffff" stroke="#7fb8d6" stroke-width="2"/>
  <rect x="0" y="135" width="260" height="25" fill="#86c34a" stroke="#2f6b12" stroke-width="2"/>
  <circle cx="34" cy="30" r="15" fill="#ffd23f" stroke="#e0a400" stroke-width="2"/>
  <g stroke="#2f6b12" stroke-width="2">
    <rect x="62" y="95" width="9" height="40" fill="#8a5a2b" stroke="#5a3210"/>
    <circle cx="66" cy="80" r="30" fill="#3aae6a"/>
  </g>
  <g stroke="#1f2937" stroke-width="2">
    <rect x="150" y="95" width="55" height="40" fill="#b0563a"/>
    <rect x="186" y="70" width="14" height="28" fill="#7a3f2a"/>
    <path d="M193 70 q-18 -14 -4 -28 q-14 -2 -2 -16" fill="none" stroke="#555b61" stroke-width="6"/>
  </g>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="40" y="128">شجرةٌ تنقّي</text>
    <text x="150" y="152">مصنعٌ يلوّث</text>
  </g>
</svg>

## 🛡️ قواعد التنفّس الصحّية

كي يبقى جهازي التنفّسي سليمًا، أتّبع هذه القواعد:

- أتنفّس من **الأنف** لا من الفم، لأنّ الأنف ينقّي الهواء ويدفّئه.
- أستنشق هواءً **نقيًّا** وأتجنّب الأماكن الملوّثة.
- **أهوّي** غرفتي بفتح النوافذ كلّ يوم.
- أتجنّب **الدخان** ولا أقترب من المدخّنين.
- أغرس **الأشجار** وأعتني بها لأنّها تنقّي الهواء.

> 🗡️ تذكّر القاعدة: **شهيقٌ = هواءٌ يدخل والصدر يرتفع، وزفيرٌ = هواءٌ يخرج والصدر ينخفض.** والأفضل دائمًا التنفّس من الأنف بهواءٍ نقيّ.

> ⚠️ الفخّ الشائع: لا تظنّ أنّك تستطيع التوقّف عن التنفّس متى شئت — التنفّس مستمرٌّ لا يتوقّف. ولا تخلط بين الشهيق والزفير: في الشهيق يدخل الهواء، وفي الزفير يخرج. والهواء الملوّث ليس عاديًّا بل مضرٌّ برئتيك.

> 🏆 أحسنت! عرفتَ حركتي التنفّس، وكيف تتنفّس بانتظام، وكيف تحافظ على رئتيك بهواءٍ نقيّ. في الفصل القادم نكتشف الوقاية من الأمراض وحماية محيطنا.', '# 📜 ملخّص: التنفّس: الشهيق والزفير

- **جهازي التنفّسي:** الأنف، ثمّ القصبة الهوائية، ثمّ الرئتان داخل الصدر.
- **الشهيق:** يدخل الهواء إلى الرئتين فيرتفع القفص الصدري ويتمدّد.
- **الزفير:** يخرج الهواء من الرئتين فينخفض القفص الصدري ويصغر.
- **التنفّس مستمرّ:** نتنفّس بانتظام ليلًا ونهارًا ولا نتوقّف عنه بإرادتنا.
- **بعد المجهود:** نتنفّس أسرع بعد الجري لأنّ الجسم يحتاج هواءً أكثر.
- **الهواء النقيّ** نظيفٌ ومفيد، و**الهواء الملوّث** فيه دخانٌ وغبارٌ ومضرٌّ بالتنفّس.
- **قواعد صحّية:** أتنفّس من الأنف، وأستنشق هواءً نقيًّا، وأهوّي الغرف.
- **أتجنّب الدخان** والأماكن الملوّثة، و**أغرس الأشجار** لأنّها تنقّي الهواء.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('7dc97c37-3ead-596b-b689-baa026f5f3a1', 'eveil-scientifique-3eme', 'الوقاية من الأمراض وحماية المحيط', 'بعض الأمراض التي تصيب الإنسان والحيوان وكيف نقي أنفسنا منها بالنظافة والتغذية المتوازنة والتلقيح، ودور الإنسان في المحافظة على البيئة ومقاومة التلوّث، وأهمية الشجرة وحماية الحيوانات والنباتات من الصيد العشوائي والحرائق', '# ⚔️ الوقاية من الأمراض وحماية المحيط — حارس الصحّة والبيئة

> 💡 «الوقاية خيرٌ من العلاج: أنظّف يديّ، وأحمي شجرتي، فأحمي صحّتي وكوكبي.»

أحيانًا نمرض: نُصاب بالرشح، أو بألمٍ في الأسنان. لكنّنا نستطيع أن **نقي** أنفسنا من كثيرٍ من الأمراض. وكما نحمي أجسامنا، نحمي أيضًا **محيطنا**: الهواء والماء والشجر والحيوان. هيّا نتعلّم كيف نكون حرّاسًا للصحّة والبيئة.

## 🤧 بعض الأمراض التي تصيب الإنسان

تصيب الإنسان أمراضٌ شائعة، منها:

- **الرشح (الزكام):** نعطس ونسعل ويسيل أنفنا.
- **الإسهال:** يأتي غالبًا من ماءٍ أو طعامٍ غير نظيف.
- **تسوّس الأسنان:** يأتي من الحلوى وقلّة تنظيف الأسنان.

المرض ليس عقابًا، لكنّه إشارةٌ إلى أنّ علينا الاعتناء بأجسامنا أكثر.

## 🛡️ كيف أقي نفسي من الأمراض؟

الوقاية تعني أن نمنع المرض **قبل** أن يصيبنا. وأهمّ وسائل الوقاية:

- **النظافة:** أغسل يديّ بالماء والصابون قبل الأكل وبعد الخلاء.
- **التغذية المتوازنة:** آكل الخضر والغلال لا الحلوى فقط.
- **التلقيح (التطعيم):** يحمي جسمي من أمراضٍ خطيرة.
- **النوم الكافي** و**الرياضة** يقوّيان الجسم.
- **زيارة الطبيب** عند المرض، وتنظيف الأسنان كلّ يوم.

<svg viewBox="0 0 240 120" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="240" height="120" fill="#eaf6ff" stroke="#7fb8d6" stroke-width="2"/>
  <g stroke="#1f2937" stroke-width="2">
    <path d="M70 95 q-30 -8 -30 -32 q0 -22 30 -22 q14 -18 38 -8 q22 -8 30 14 q18 4 14 26 q-4 16 -24 14 z" fill="#bfe6f5"/>
    <line x1="60" y1="78" x2="118" y2="78"/>
    <line x1="60" y1="86" x2="110" y2="86"/>
  </g>
  <g stroke="#5a3210" stroke-width="2">
    <ellipse cx="170" cy="80" rx="20" ry="13" fill="#f1c27d"/>
    <rect x="158" y="78" width="24" height="22" rx="3" fill="#f1c27d"/>
  </g>
  <g font-size="10" fill="#1f2937" stroke="none">
    <text x="50" y="112">أغسل يديّ بالماء والصابون</text>
  </g>
</svg>

## 🐮 الحيوانات تمرض أيضًا

ليس الإنسان وحده من يمرض؛ **الحيوانات تمرض كذلك**. لذلك نعتني بحيواناتنا:

- ننظّف مأواها ونوفّر لها **غذاءً** نظيفًا وماءً عذبًا.
- نعرضها على **الطبيب البيطريّ** عند المرض ونلقّحها.

الحيوان المعتنى به حيوانٌ سليمٌ ونشيط.

## 🏭 المحيط والتلوّث

**التلوّث** هو إفساد المحيط بما يضرّ الكائنات الحيّة. وله ثلاثة أنواع:

| نوع التلوّث | مثاله |
| --- | --- |
| **تلوّث الهواء** | دخان المصانع والسيّارات |
| **تلوّث الماء** | رمي الفضلات في الوادي والبحر |
| **تلوّث التربة** | ترك النفايات في الأرض |

التلوّث يمرض الإنسان والحيوان والنبات، فعلينا مقاومته.

<svg viewBox="0 0 260 120" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <rect x="0" y="0" width="130" height="120" fill="#bfe6f5"/>
    <rect x="130" y="0" width="130" height="120" fill="#cbb78f"/>
  </g>
  <g stroke="#1f2937" stroke-width="2">
    <circle cx="40" cy="55" r="7" fill="#86c34a"/>
    <circle cx="70" cy="80" r="6" fill="#86c34a"/>
    <circle cx="95" cy="45" r="6" fill="#86c34a"/>
  </g>
  <g stroke="#1f2937" stroke-width="2">
    <rect x="150" y="60" width="14" height="14" fill="#e0533a"/>
    <rect x="185" y="80" width="16" height="12" fill="#ffd23f"/>
    <rect x="215" y="55" width="13" height="16" fill="#9b59b6"/>
  </g>
  <g font-size="11" fill="#0f4a5c" stroke="none">
    <text x="18" y="105">ماءٌ نظيف</text>
  </g>
  <g font-size="11" fill="#7a3b12" stroke="none">
    <text x="150" y="105">ماءٌ ملوّثٌ بالفضلات</text>
  </g>
</svg>

## ♻️ سلوكاتٌ تحمي المحيط

بسلوكاتٍ بسيطةٍ كلّ يومٍ نحمي محيطنا:

| سلوكٌ يحمي المحيط 🌳 | سلوكٌ يضرّ المحيط 🚫 |
| --- | --- |
| أرمي الفضلات في الحاوية | أرمي الفضلات في الوادي |
| أعيد التدوير (الرسكلة) | أحرق النفايات |
| أقتصد في الماء والكهرباء | أترك الماء يجري بلا فائدة |
| أغرس شجرةً وأسقيها | أقطع الأشجار |

<svg viewBox="0 0 220 130" xmlns="http://www.w3.org/2000/svg">
  <g stroke="#1f2937" stroke-width="2">
    <path d="M55 120 l8 -55 l54 0 l8 55 z" fill="#3aae6a"/>
    <rect x="60" y="50" width="60" height="16" rx="3" fill="#86c34a"/>
    <line x1="90" y1="50" x2="90" y2="120"/>
  </g>
  <g fill="none" stroke="#ffffff" stroke-width="3">
    <path d="M84 78 l-7 12 l8 0"/>
    <path d="M96 102 l7 -12 l-8 0"/>
    <polyline points="78,92 73,90 76,84"/>
    <polyline points="102,88 107,90 104,96"/>
  </g>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="135" y="80">حاوية</text>
    <text x="135" y="96">الرسكلة</text>
  </g>
</svg>

## 🌳 أهمية الشجرة وحماية الكائنات

الشجرة كنزٌ كبير:

- **تنقّي الهواء** وتعطينا **الأكسجين** الذي نتنفّسه.
- تعطينا **الظلّ** و**الثمار** وتمنع جفاف التربة.

لذلك نغرس الأشجار ولا نقطعها. ونحمي كذلك **الحيوانات والنباتات** النادرة من **الانقراض**، فلكلّ كائنٍ دورٌ في الطبيعة.

## 🔥 الصيد العشوائيّ والحرائق

**الصيد العشوائيّ** يقتل حيواناتٍ كثيرةً حتّى تكاد تنقرض. و**الحرائق** تلتهم الغابة والأشجار والحيوان في ساعاتٍ قليلة. لذلك:

- لا نشعل النار في الغابة، ونطفئ أيّ شرارة.
- نمنع الصيد العشوائيّ ونحمي الغابة.

> 🗡️ تذكّر القاعدة: **الوقاية خيرٌ من العلاج.** غسل اليدين والتغذية المتوازنة والتلقيح تمنع المرض قبل حدوثه.

> ⚠️ الفخّ الشائع: لا تظنّ أنّ رمي فضلةٍ صغيرةٍ في الوادي «لا يضرّ»، ولا أنّ قطع شجرةٍ واحدةٍ «لا أثر له». كلّ فضلةٍ تلوّث الماء، وكلّ شجرةٍ مقطوعةٍ تنقص الهواء النقيّ. السلوك الصغير له أثرٌ كبير.

> 🏆 أحسنت أيّها الحارس! عرفتَ كيف تقي نفسك من الأمراض وتحمي محيطك وشجرك وحيوانك. في الفصل القادم ندخل عالم **المادّة** ونكتشف حالاتها العجيبة.', '# 📜 ملخّص: الوقاية من الأمراض وحماية المحيط

- **بعض أمراض الإنسان:** الرشح (الزكام)، والإسهال، وتسوّس الأسنان من الأمراض الشائعة.
- **الوقاية من الأمراض:** النظافة وغسل اليدين، والتغذية المتوازنة، والتلقيح، والنوم الكافي، والرياضة، وزيارة الطبيب.
- **الوقاية خيرٌ من العلاج:** نمنع المرض قبل أن يصيبنا، ولا ننتظر حتّى نمرض.
- **الحيوانات تمرض أيضًا:** نعتني بها بالنظافة والغذاء الجيّد ونعرضها على الطبيب البيطريّ.
- **التلوّث ثلاثة أنواع:** تلوّث الهواء (الدخان)، وتلوّث الماء (رمي الفضلات)، وتلوّث التربة (النفايات).
- **سلوكاتٌ تحمي المحيط:** لا نرمي الفضلات، ونعيد التدوير (الرسكلة)، ونقتصد في الماء والكهرباء.
- **الشجرة كنزٌ:** تنقّي الهواء، وتعطي الأكسجين والظلّ والثمار، فنحميها ولا نقطعها.
- **نحمي الحيوانات والنباتات** من الانقراض، ونمنع الصيد العشوائيّ.
- **الصيد العشوائيّ والحرائق** يهدّدان الحيوانات والغابة، فيجب منعهما والمحافظة على الغابة.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('7fb3f737-9068-51ce-9269-6c07e3b3bee5', 'eveil-scientifique-3eme', 'المادّة وحالاتها وتحوّلاتها', 'حالات المادّة في الطبيعة (صلب، سائل، غاز)، والتبخّر والغليان، والإسالة (التكثيف)، والانصهار والتجمّد، وانحلال المواد في السوائل، ودورة الماء في الطبيعة', '# ⚔️ المادّة وحالاتها وتحوّلاتها — رحلةٌ في عالم المادّة

> 💡 «كلّ ما حولك مادّة: الحجر، والماء، والهواء. وقد تتغيّر حالة المادّة فتصير صلبةً أو سائلةً أو غازًا.»

الكوب من زجاج، والماء داخله سائل، والهواء فوقه غاز. كلّها **مادّة**. هيّا نكتشف حالات المادّة في الطبيعة، وكيف تتحوّل من حالةٍ إلى أخرى.

## 🧊 حالات المادّة في الطبيعة

توجد المادّة في الطبيعة في ثلاث حالات:

| الحالة | صفتها | أمثلة |
| --- | --- | --- |
| **صلب** | له شكلٌ ثابت لا يتغيّر | الحجر، الجليد، الخشب |
| **سائل** | يأخذ شكل الإناء الذي نضعه فيه | الماء، الزيت، الحليب |
| **غاز** | ينتشر في كلّ مكان ولا نراه غالبًا | الهواء، بخار الماء |

<svg viewBox="0 0 320 150" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="320" height="150" fill="#fdfdfd" stroke="#cccccc" stroke-width="1"/>
  <g stroke="#1f2937" stroke-width="2">
    <rect x="22" y="58" width="46" height="46" fill="#a9b3bf"/>
    <path d="M30 64 l30 30 M40 60 l28 28" stroke="#6b7480" stroke-width="2"/>
    <path d="M130 50 l0 54 l44 0 l0 -54" fill="none"/>
    <rect x="130" y="74" width="44" height="30" fill="#3a8fd6"/>
    <ellipse cx="152" cy="74" rx="22" ry="5" fill="#bfe6f5"/>
    <path d="M244 50 l0 54 l44 0 l0 -54" fill="none"/>
    <circle cx="256" cy="68" r="5" fill="#cfe9b0"/>
    <circle cx="274" cy="82" r="5" fill="#cfe9b0"/>
    <circle cx="262" cy="92" r="5" fill="#cfe9b0"/>
  </g>
  <g font-size="13" fill="#1f2937" stroke="none" text-anchor="middle">
    <text x="45" y="124">صلب</text>
    <text x="152" y="124">سائل</text>
    <text x="266" y="124">غاز</text>
  </g>
</svg>

تذكّر: **الصلب** يحافظ على شكله، و**السائل** يأخذ شكل إنائه، و**الغاز** ينتشر ويملأ كلّ الفراغ.

## 🔥 التبخّر والغليان

عندما نسخّن الماء السائل، يتحوّل شيئًا فشيئًا إلى **بخار**، والبخار **غاز**. هذا التحوّل اسمه **التبخّر**.

- **التبخّر** بطيء: الملابس المبلّلة تجفّ في الشمس، وماء البِركة ينقص بمرور الأيّام.
- **الغليان** سريع: إذا سخّنّا الماء تسخينًا قويًّا، يغلي وتتصاعد فقاعاتٌ كثيرة (الماء يغلي عند 100 °C).

> 🗡️ تذكّر: التبخّر والغليان كلاهما يحوّل الماء السائل إلى بخار (غاز) بمفعول **الحرارة**؛ الفرق أنّ الغليان أسرع لأنّ التسخين أقوى.

## 💧 الإسالة (التكثيف)

عكس التبخّر هو **الإسالة**: البخار (غاز) يبرد فيتحوّل إلى ماءٍ سائل. نراها كثيرًا في الطبيعة:

- **الندى (الطلّ):** قطراتٌ صغيرة فوق العشب في الصباح البارد.
- **السحاب والضباب:** بخار ماءٍ بَرَدَ في الجوّ فصار قطراتٍ صغيرة.

> ⚠️ الخطأ الشائع: بخار الماء **غازٌ شفّافٌ لا نراه**. أمّا «الدخان» الأبيض الذي نراه فوق الإناء المغلي فهو **قطراتٌ صغيرة من الماء** (بداية إسالة)، وليس البخار نفسه.

## ❄️ الانصهار والتجمّد

المادّة الصلبة قد تتحوّل إلى سائل، والسائل قد يتحوّل إلى صلب:

| التحوّل | الاتّجاه | سببه |
| --- | --- | --- |
| **الانصهار** | صلب ← سائل | ارتفاع الحرارة (تسخين) |
| **التجمّد** | سائل ← صلب | انخفاض الحرارة (تبريد) |

مثالٌ يوميّ: المثلّجة (الجلاتي) **تنصهر** بين يديك فتصير سائلةً لأنّها سخنت. والماء في الثلّاجة **يتجمّد** فيصير جليدًا لأنّه برد (الماء يتجمّد عند 0 °C). والشمع والزبدة ينصهران بالحرارة كذلك.

<svg viewBox="0 0 300 150" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="300" height="150" fill="#fdfdfd" stroke="#cccccc" stroke-width="1"/>
  <circle cx="42" cy="34" r="20" fill="#ffd23f" stroke="#e0a400" stroke-width="2"/>
  <g stroke="#e0a400" stroke-width="2">
    <line x1="42" y1="6" x2="42" y2="0"/>
    <line x1="14" y1="34" x2="6" y2="34"/>
    <line x1="22" y1="14" x2="16" y2="8"/>
  </g>
  <rect x="92" y="54" width="38" height="38" rx="3" fill="#a9e0f5" stroke="#1f6f8c" stroke-width="3"/>
  <g stroke="#1f2937" stroke-width="2" fill="none">
    <path d="M150 74 l28 0 M170 68 l10 6 l-10 6"/>
  </g>
  <path d="M206 92 q4 -18 22 -18 q18 0 22 18 z" fill="#3a8fd6" stroke="#1f6f8c" stroke-width="2"/>
  <ellipse cx="228" cy="92" rx="22" ry="5" fill="#bfe6f5" stroke="#1f6f8c" stroke-width="2"/>
  <g font-size="12" fill="#1f2937" stroke="none" text-anchor="middle">
    <text x="111" y="112">جليد صلب</text>
    <text x="228" y="116">ماء سائل</text>
    <text x="150" y="132">الانصهار بمفعول الحرارة</text>
  </g>
</svg>

## 🧂 انحلال المادّة في السوائل

إذا وضعنا **السكر** أو **الملح** في كأس ماءٍ وحرّكنا، يختفيان! لم يبقَ لهما أثرٌ نراه، لكنّهما **موجودان**: نتذوّق حلاوة السكر وملوحة الملح. هذا التحوّل اسمه **الانحلال**: المادّة الصلبة **تنحلّ** في الماء فتختفي بين دقائقه الصغيرة.

> ⚠️ انتبه إلى الخطأ الشائع: **الانحلال ليس انصهارًا**. السكر في الماء **انحلّ** (اختفى في الماء لكنّه باقٍ، ولم يسخن). أمّا الانصهار فهو ذوبان الصلب بمفعول الحرارة وحدها (مثل الجليد يصير ماءً عند التسخين).

## 🌧️ دورة الماء في الطبيعة

الماء في الطبيعة في رحلةٍ دائمة لا تتوقّف:

1. تُسخّن **الشمس** ماء البحر، فيتبخّر ويرتفع بخارٌ إلى الأعلى (**تبخّر**).
2. في الأعلى يبرد البخار فيتكوّن **السحاب** (**إسالة**).
3. ينزل الماء من السحاب **مطرًا** أو ثلجًا.
4. يعود الماء إلى البحر والأنهار، فتبدأ الرحلة من جديد.

هذه الرحلة المتواصلة اسمها **دورة الماء**.

<svg viewBox="0 0 320 170" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="320" height="170" fill="#fdfdfd" stroke="#cccccc" stroke-width="1"/>
  <circle cx="44" cy="36" r="18" fill="#ffd23f" stroke="#e0a400" stroke-width="2"/>
  <path d="M150 44 q-22 -22 -44 0 q-22 4 -8 24 l84 0 q14 -22 -10 -26 q-8 -8 -22 2 z" fill="#eef3f7" stroke="#7f8c99" stroke-width="2"/>
  <g stroke="#3a8fd6" stroke-width="2">
    <line x1="108" y1="78" x2="104" y2="92"/>
    <line x1="128" y1="78" x2="124" y2="94"/>
    <line x1="148" y1="78" x2="144" y2="92"/>
  </g>
  <rect x="0" y="120" width="320" height="50" fill="#3a8fd6" stroke="#1f6f8c" stroke-width="2"/>
  <ellipse cx="160" cy="120" rx="160" ry="6" fill="#bfe6f5" stroke="none"/>
  <g stroke="#1f6f8c" stroke-width="2" fill="none">
    <path d="M64 60 q10 -20 36 -28" stroke-dasharray="5 4"/>
    <path d="M96 56 l-6 -2 M96 56 l-2 -6"/>
    <path d="M200 70 q26 18 40 44" stroke-dasharray="5 4"/>
    <path d="M240 114 l2 -6 M240 114 l-6 0"/>
  </g>
  <g font-size="11" fill="#1f2937" stroke="none" text-anchor="middle">
    <text x="44" y="62">الشمس</text>
    <text x="128" y="56">سحاب</text>
    <text x="270" y="100">مطر</text>
    <text x="40" y="150" fill="#ffffff">بحر</text>
  </g>
</svg>

> 🏆 أحسنت! عرفتَ حالات المادّة الثلاث، وكيف تتحوّل بالتسخين والتبريد، وكيف تدور المياه في الطبيعة. في الفصل القادم نكتشف الظواهر الدوريّة والزمن: تعاقب الليل والنهار والفصول.', '# 📜 ملخّص: المادّة وحالاتها وتحوّلاتها

- **حالات المادّة الثلاث:** صلب (له شكلٌ ثابت: الحجر، الجليد)، سائل (يأخذ شكل الإناء: الماء، الزيت)، غاز (ينتشر ولا نراه غالبًا: الهواء، بخار الماء).
- **التبخّر:** الماء السائل يتحوّل إلى بخار (غاز) بمفعول الحرارة؛ وهو تحوّلٌ بطيء (جفاف الملابس).
- **الغليان:** تبخّرٌ سريعٌ عند تسخينٍ قويّ (الماء يغلي عند 100 °C).
- **الإسالة (التكثيف):** عكس التبخّر؛ البخار يبرد فيصير ماءً سائلًا، مثل الندى والسحاب والضباب.
- **بخار الماء غازٌ شفّافٌ لا نراه؛** أمّا «الدخان» الأبيض فوق الإناء المغلي فقطراتُ ماءٍ صغيرة (بداية إسالة).
- **الانصهار:** صلب ← سائل بمفعول ارتفاع الحرارة (الجليد، الشمع، المثلّجة).
- **التجمّد:** سائل ← صلب بمفعول انخفاض الحرارة (الماء يتجمّد عند 0 °C فيصير جليدًا).
- **الانحلال:** السكر والملح ينحلّان في الماء فيختفيان لكنّهما باقيان (نتذوّقهما)، والانحلال ليس انصهارًا.
- **دورة الماء:** الشمس تُبخّر ماء البحر ← بخار يرتفع ويبرد فيتكوّن السحاب (إسالة) ← مطرٌ أو ثلجٌ يعود إلى البحر، دورةٌ متواصلة.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('8f032ef5-65c4-571f-b649-55e38b021307', 'eveil-scientifique-3eme', 'الظواهر الدوريّة والزمن', 'الأحداث الدوريّة وغير الدوريّة (تعاقب الليل والنهار، الفصول، نزول المطر)، وقيس الزمن ووحداته (الثانية، الدقيقة، الساعة، اليوم)، وأدوات قيس الزمن (الساعة الرمليّة والمائيّة وذات العقارب والرقميّة)، والنواس', '# ⚔️ الظواهر الدوريّة والزمن — سيّد الوقت

> 💡 «بعض الأحداث تتكرّر بانتظامٍ كساعةٍ دقيقة: ليلٌ ثمّ نهار، ثمّ ليلٌ ثمّ نهار...»

كلّ يومٍ تشرق الشمس فيأتي النهار، ثمّ تغرب فيأتي الليل. هذا يتكرّر دائمًا بالترتيب نفسه. هيّا نكتشف الأحداث التي تتكرّر، وكيف نقيس الزمن.

## 🔁 الحدث الدوريّ والحدث غير الدوريّ

**الحدث الدوريّ** هو حدثٌ **يتكرّر بانتظامٍ** كلّ مدّةٍ ثابتة. **الحدث غير الدوريّ** هو حدثٌ **لا يتكرّر بانتظام**، قد يحدث في أيّ وقتٍ أو لا يحدث.

| نوع الحدث | يتكرّر بانتظام؟ | أمثلة |
| --- | --- | --- |
| **دوريّ** | نعم، كلّ مدّةٍ ثابتة | تعاقب الليل والنهار، الفصول الأربعة، أيّام الأسبوع، نبضات القلب |
| **غير دوريّ** | لا، في أيّ وقت | نزول المطر، انقطاع التيّار الكهربائي، وقوع حادث |

*مثال: شروق الشمس وغروبها حدثٌ دوريّ. أمّا نزول المطر فحدثٌ غير دوريّ؛ قد يمطر اليوم ولا يمطر غدًا.*

<svg viewBox="0 0 260 120" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="130" height="120" fill="#cfeffd" stroke="#7fb8d6" stroke-width="2"/>
  <rect x="130" y="0" width="130" height="120" fill="#2c3e7a" stroke="#1c2a55" stroke-width="2"/>
  <circle cx="60" cy="48" r="22" fill="#ffd23f" stroke="#e0a400" stroke-width="2"/>
  <g stroke="#e0a400" stroke-width="3">
    <line x1="60" y1="14" x2="60" y2="4"/>
    <line x1="60" y1="82" x2="60" y2="92"/>
    <line x1="26" y1="48" x2="16" y2="48"/>
    <line x1="94" y1="48" x2="104" y2="48"/>
  </g>
  <path d="M210 38 a20 20 0 1 0 6 40 a16 16 0 0 1 -6 -40 z" fill="#f4f1c0" stroke="#d9d27a" stroke-width="2"/>
  <circle cx="170" cy="30" r="2" fill="#ffffff" stroke="none"/>
  <circle cx="240" cy="60" r="2" fill="#ffffff" stroke="none"/>
  <circle cx="195" cy="92" r="2" fill="#ffffff" stroke="none"/>
  <g font-size="12" fill="#1f2937" stroke="none">
    <text x="40" y="110">النهار</text>
  </g>
  <g font-size="12" fill="#ffffff" stroke="none">
    <text x="170" y="110">الليل</text>
  </g>
</svg>

## ⏳ لماذا نقيس الزمن؟

نحتاج إلى **قيس الزمن** لنعرف كم مرّ من الوقت: متى نستيقظ، ومتى ندخل المدرسة، وكم بقي على العطلة. لكي نقيس الزمن نستعمل **أدوات قيس الزمن**.

## 📏 وحدات الزمن

نقيس الزمن بوحداتٍ بسيطة، من الأصغر إلى الأكبر:

| الوحدة | ملاحظة |
| --- | --- |
| **الثانية** | أصغر وحدةٍ نستعملها كثيرًا |
| **الدقيقة** | الدقيقة فيها 60 ثانية |
| **الساعة** | الساعة فيها 60 دقيقة |
| **اليوم** | اليوم فيه 24 ساعة |

## 🛠️ أدوات قيس الزمن

استعمل الإنسان أدواتٍ كثيرةً ليقيس الزمن:

| الأداة | كيف تعمل؟ |
| --- | --- |
| **الساعة الرمليّة** | يسيل فيها الرمل من خانةٍ علويّةٍ إلى خانةٍ سفليّةٍ في مدّةٍ معلومة |
| **الساعة المائيّة** | تعتمد سيلان الماء من إناءٍ إلى آخر لقيس مرور الوقت |
| **الساعة ذات العقارب** | فيها عقاربُ تدور بانتظامٍ فوق وجهٍ مرقّمٍ لتدلّ على الوقت |
| **الساعة الرقميّة** | تعرض الوقت بأرقامٍ في خانات، وليست لها عقارب |

<svg viewBox="0 0 260 130" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="0" width="260" height="130" fill="#fff7e6" stroke="#e0a93c" stroke-width="2"/>
  <g stroke="#7a4b12" stroke-width="3" fill="none">
    <line x1="55" y1="16" x2="135" y2="16"/>
    <line x1="55" y1="114" x2="135" y2="114"/>
    <path d="M62 18 L62 40 Q62 62 95 65 Q128 68 128 40 L128 18" fill="#dff1fb"/>
    <path d="M62 112 L62 92 Q62 70 95 67 Q128 64 128 92 L128 112" fill="#dff1fb"/>
  </g>
  <path d="M70 22 L120 22 Q120 38 95 56 Q70 38 70 22 z" fill="#e0a93c" stroke="none"/>
  <path d="M73 108 Q73 86 95 78 Q117 86 117 108 z" fill="#e0a93c" stroke="none"/>
  <line x1="95" y1="58" x2="95" y2="78" stroke="#e0a93c" stroke-width="3"/>
  <g font-size="12" fill="#7a4b12" stroke="none">
    <text x="150" y="55">الرمل يسيل</text>
    <text x="150" y="74">من الأعلى</text>
    <text x="150" y="93">إلى الأسفل</text>
  </g>
</svg>

## 🕰️ الساعة ذات العقارب

في الساعة ذات العقارب **عقربان**: عقربٌ قصيرٌ للساعات وعقربٌ طويلٌ للدقائق. **يدوران بانتظام** فوق وجهٍ عليه الأرقام من 12 إلى 11. هذا الدوران المنتظم هو الذي يجعلها تقيس الزمن.

<svg viewBox="0 0 150 150" xmlns="http://www.w3.org/2000/svg">
  <circle cx="75" cy="75" r="62" fill="#ffffff" stroke="#1f2937" stroke-width="4"/>
  <circle cx="75" cy="75" r="62" fill="none" stroke="#1f6f8c" stroke-width="2"/>
  <g font-size="13" fill="#1f2937" stroke="none" font-weight="bold">
    <text x="70" y="28">12</text>
    <text x="118" y="80">3</text>
    <text x="72" y="130">6</text>
    <text x="26" y="80">9</text>
  </g>
  <line x1="75" y1="75" x2="75" y2="40" stroke="#e0533a" stroke-width="5"/>
  <line x1="75" y1="75" x2="105" y2="75" stroke="#1f6f8c" stroke-width="4"/>
  <circle cx="75" cy="75" r="5" fill="#1f2937" stroke="none"/>
</svg>

## 🪀 النواس

**النواس** جسمٌ معلّقٌ بخيطٍ يتأرجح يمينًا ويسارًا **بانتظام**. حركته دوريّة، لذلك يُستعمل في بعض الساعات لقيس الزمن. المرجوحة في الحديقة تشبه النواس.

> 🗡️ تذكّر: **مدّة نوسة النواس تتعلّق بطول الخيط.** كلّما طال الخيط طالت مدّة النوسة، وكلّما قصر الخيط قصرت المدّة.

> ⚠️ الفخّ الشائع: لا تظنّ أنّ نزول المطر حدثٌ دوريّ؛ فهو غير دوريّ لأنّه لا يتكرّر بانتظام. ولا تظنّ أنّ مدّة النوسة تتعلّق بكتلة الثقل؛ فهي تتعلّق بطول الخيط فقط، لا بثقل الجسم المعلّق.

> 🏆 أحسنت! عرفتَ الأحداث الدوريّة وغير الدوريّة، وكيف نقيس الزمن بالساعة الرمليّة والمائيّة وذات العقارب والرقميّة، وعرفتَ النواس. في الفصل القادم نكتشف القوّة والطاقة.', '# 📜 ملخّص: الظواهر الدوريّة والزمن

- **الحدث الدوريّ:** حدثٌ يتكرّر بانتظامٍ كلّ مدّةٍ ثابتة، مثل تعاقب الليل والنهار والفصول الأربعة.
- **الحدث غير الدوريّ:** حدثٌ لا يتكرّر بانتظام، مثل نزول المطر وانقطاع التيّار الكهربائي والحادث.
- **أمثلة دوريّة:** شروق الشمس وغروبها، أيّام الأسبوع، نبضات القلب، الاحتفال بالمولد كلّ سنة.
- **قيس الزمن:** نحتاج إلى أدواتٍ لنعرف كم مرّ من الوقت.
- **وحدات الزمن البسيطة:** الثانية، ثمّ الدقيقة، ثمّ الساعة، ثمّ اليوم.
- **الساعة الرمليّة:** يسيل فيها الرمل من خانةٍ إلى أخرى في مدّةٍ معلومة.
- **الساعة المائيّة:** تعتمد سيلان الماء لقيس مرور الزمن.
- **الساعة ذات العقارب:** فيها عقاربُ تدور بانتظامٍ لتدلّ على الوقت.
- **الساعة الرقميّة:** تعرض الوقت بأرقامٍ في خاناتٍ، وليست لها عقارب.
- **النواس:** جسمٌ معلّقٌ بخيطٍ يتأرجح بانتظام؛ كلّما طال الخيط طالت مدّة النوسة، ولا تتعلّق المدّة بكتلة الثقل.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('e1dd5afc-6c37-5ac3-ada1-73410f1f5b54', 'eveil-scientifique-3eme', 'القوّة والطاقة', 'ما القوّة؟ القوّة دفعٌ أو جذب، وتأثيرها يظهر في تحريك جسمٍ ساكن أو إيقاف جسمٍ متحرّك أو تغيير اتجاهه أو تغيير شكله. سقوط الأجسام نحو الأسفل بفعل جاذبيّة الأرض، والعمل، والطاقة وأنواعها (الشمسيّة والكهربائيّة وطاقة الرياح والغذاء والماء الجاري)', '# ⚔️ القوّة والطاقة — أسرار الحركة من حولي

> 💡 «أدفعُ أو أجذب فأُحرّك الأشياء؛ والطاقة هي ما يمنحني القدرة على ذلك.»

كلّ يومٍ أدفع البابَ، وأجذب العربةَ، وأرى التفاحة تسقط من الشجرة. وراء كلّ هذا **قوّةٌ** و**طاقة**. هيّا نكتشف أسرارهما.

## 💪 ما القوّة؟

**القوّة** هي **دفعٌ** (أُبعد الشيء عنّي) أو **جذبٌ** (أقرّب الشيء إليّ).

- حين أضغط على الباب لأفتحه، أقوم بـ**دفع**.
- حين أشدّ الحبل نحوي، أقوم بـ**جذب**.

فالقوّة ليست الدفع وحده؛ هي **دفعٌ أو جذب**.

<svg viewBox="0 0 260 130" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="105" width="260" height="25" fill="#86c34a" stroke="#2f6b12" stroke-width="2"/>
  <circle cx="180" cy="86" r="20" fill="#e0533a" stroke="#7a2718" stroke-width="2"/>
  <g stroke="#5a3210" stroke-width="2" fill="#f2c094">
    <ellipse cx="70" cy="86" rx="16" ry="22"/>
    <rect x="84" y="80" width="36" height="12" rx="6"/>
  </g>
  <g stroke="#1f4e9c" stroke-width="4" fill="none">
    <line x1="120" y1="86" x2="150" y2="86"/>
  </g>
  <polygon points="150,80 162,86 150,92" fill="#1f4e9c" stroke="none"/>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="30" y="40">يدٌ تدفع الكرة</text>
    <text x="124" y="74">دفع ←</text>
  </g>
</svg>

## 🎯 تأثير القوّة الظاهر

القوّة لا نراها، لكنّنا نرى **أثرها** في الأجسام. للقوّة أربعة آثارٍ ظاهرة:

| أثر القوّة | مثال |
| --- | --- |
| **تحريك جسمٍ ساكن** | أدفع كرةً ساكنةً فتتحرّك |
| **إيقاف جسمٍ متحرّك** | أمسك الكرة الجارية فتتوقّف |
| **تغيير اتجاه الحركة** | أضرب الكرة فتغيّر طريقها |
| **تغيير شكل جسم** | أضغط على الإسفنجة فيتغيّر شكلها |

*مثال: أضغط على عجينةٍ بيدي فيتغيّر شكلها؛ هذا أثرٌ من آثار القوّة.*

## 🍎 الأجسام تسقط نحو الأسفل

إذا تركتُ التفاحة من يدي، تسقط نحو **الأسفل**، نحو الأرض، لا نحو الأعلى. السبب أنّ **الأرض تجذب الأجسام** إليها بقوّةٍ نسمّيها **جاذبيّة الأرض** (الثقالة).

كلّ جسمٍ نتركه يسقط نحو الأرض: الحجر، والقلم، وقطرة المطر.

<svg viewBox="0 0 240 150" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="128" width="240" height="22" fill="#9b6a3c" stroke="#5a3210" stroke-width="2"/>
  <g stroke="#3d6b1e" stroke-width="3">
    <line x1="55" y1="128" x2="55" y2="60"/>
  </g>
  <ellipse cx="70" cy="48" rx="36" ry="26" fill="#3aae6a" stroke="#1f6b34" stroke-width="2"/>
  <circle cx="150" cy="58" r="15" fill="#e0533a" stroke="#7a2718" stroke-width="2"/>
  <path d="M150 43 q4 -8 9 -6" fill="none" stroke="#3d6b1e" stroke-width="2"/>
  <g stroke="#1f4e9c" stroke-width="4" fill="none">
    <line x1="150" y1="78" x2="150" y2="108"/>
  </g>
  <polygon points="144,108 150,120 156,108" fill="#1f4e9c" stroke="none"/>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="168" y="92">تسقط</text>
    <text x="168" y="106">↓ نحو الأسفل</text>
  </g>
</svg>

## 🏋️ العمل

يحصل **عملٌ** عندما تُحرّك قوّةٌ جسمًا.

- أرفع حقيبةً عن الأرض ← أقوم بعمل.
- أدفع عربةً فتتقدّم ← أقوم بعمل.

أمّا إذا دفعتُ جدارًا ولم يتحرّك، فلا يحصل عملٌ بهذا المعنى، لأنّ الجسم لم يتحرّك.

## ⚡ الطاقة وأنواعها

**الطاقة** هي القدرة على إنجاز عملٍ أو إحداث تغيير. من دون طاقةٍ لا حركةَ ولا عمل. وللطاقة أنواعٌ كثيرة:

| نوع الطاقة | من أين؟ | فيمَ نستعملها |
| --- | --- | --- |
| **شمسيّة** | الشمس | تدفئة الماء، إنارة |
| **كهربائيّة** | الكهرباء | تشغيل المصباح والتلفاز |
| **طاقة الرياح** | الرياح | تدوير المراوح (الطواحين) |
| **طاقة الغذاء** | الأكل | تمنحنا القوّة للحركة |
| **طاقة الماء الجاري** | الماء المتدفّق | تدوير السواقي والآلات |

الطاقة **لا تختفي**؛ هي **تتحوّل** من شكلٍ إلى آخر وتُستعمل لإنجاز عملٍ مفيد.

<svg viewBox="0 0 260 140" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="118" width="260" height="22" fill="#86c34a" stroke="#2f6b12" stroke-width="2"/>
  <circle cx="44" cy="40" r="20" fill="#ffd23f" stroke="#e0a400" stroke-width="2"/>
  <g stroke="#e0a400" stroke-width="3">
    <line x1="44" y1="8" x2="44" y2="0"/>
    <line x1="14" y1="40" x2="6" y2="40"/>
    <line x1="22" y1="18" x2="16" y2="12"/>
    <line x1="66" y1="18" x2="72" y2="12"/>
  </g>
  <line x1="170" y1="118" x2="170" y2="60" stroke="#5a3210" stroke-width="4"/>
  <g stroke="#1f4e9c" stroke-width="2" fill="#bfe6f5">
    <polygon points="170,55 150,40 175,48"/>
    <polygon points="170,55 190,40 165,48"/>
    <polygon points="170,55 185,78 162,62"/>
  </g>
  <circle cx="170" cy="55" r="4" fill="#1f4e9c" stroke="#143a73" stroke-width="1"/>
  <g font-size="11" fill="#1f2937" stroke="none">
    <text x="20" y="78">طاقة شمسيّة</text>
    <text x="150" y="134">طاحونةٌ تدور بالرياح</text>
  </g>
</svg>

> 🗡️ تذكّر القاعدة: **القوّة = دفعٌ أو جذب**، ونعرفها من **أثرها** (حركة، توقّف، تغيير اتجاه، تغيير شكل). و**الطاقة** هي ما يمنح القدرة على هذا العمل.

> ⚠️ الفخّ الشائع: لا تظنّ أنّ القوّة دفعٌ فقط؛ الجذب قوّةٌ أيضًا. ولا تقل إنّ التفاحة تسقط «لأنّها ثقيلةٌ فقط»؛ هي تسقط لأنّ **الأرض تجذبها** نحوها. والطاقة لا «تنتهي وتختفي»، بل **تتحوّل** وتُستعمل.

> 🏆 أحسنت أيّها البطل! بهذا الفصل أكملتَ كلّ محاور الإيقاظ العلمي للسنة الثالثة: عرفتَ القوّة وآثارها، وسقوط الأجسام بجاذبيّة الأرض، والعمل، وأنواع الطاقة. لقد صرتَ عالِمًا صغيرًا يفهم أسرار الحركة والطاقة من حوله. مبروك إتمام الرحلة كاملةً!', '# 📜 ملخّص: القوّة والطاقة

- **القوّة:** دفعٌ (أُبعد الشيء) أو جذبٌ (أقرّب الشيء)، وليست الدفع وحده.
- **آثار القوّة الظاهرة:** تحريك جسمٍ ساكن، إيقاف جسمٍ متحرّك، تغيير اتجاه الحركة، تغيير شكل جسم.
- **مثال على تغيير الشكل:** أضغط على الإسفنجة أو العجينة فيتغيّر شكلها.
- **سقوط الأجسام:** إذا تركنا جسمًا يسقط نحو **الأسفل** نحو الأرض.
- **السبب:** **جاذبيّة الأرض** (الثقالة)؛ الأرض تجذب الأجسام إليها، لا لأنّها ثقيلةٌ فقط.
- **العمل:** يحصل عندما تُحرّك قوّةٌ جسمًا (أرفع حقيبة، أدفع عربة)؛ وإن لم يتحرّك الجسم فلا عمل.
- **الطاقة:** القدرة على إنجاز عملٍ أو إحداث تغيير.
- **أنواع الطاقة:** شمسيّة (الشمس)، كهربائيّة (الكهرباء)، طاقة الرياح، طاقة الغذاء، طاقة الماء الجاري.
- **الطاقة لا تختفي:** بل تتحوّل من شكلٍ إلى آخر وتُستعمل لإنجاز عملٍ مفيد.', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0771f6cd-8796-53f2-893b-f52bb597a77a', '33110808-20e9-5093-bd9a-5641bd0ef873', 'eveil-scientifique-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('bb11410a-de24-5e88-b411-f5f49b5bf76b', '0771f6cd-8796-53f2-893b-f52bb597a77a', 'ماذا نعني بأنّ الكائن الحيّ يتنقّل؟', '[{"id":"a","text":"يأكل ويشرب"},{"id":"b","text":"ينتقل من مكانٍ إلى آخر"},{"id":"c","text":"ينام ويستريح"},{"id":"d","text":"يكبر وينمو"}]'::jsonb, 'b', 'التنقّل هو انتقال الكائن الحيّ من مكانٍ إلى آخر.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('66bfa6f1-c0e6-5f24-b33b-2ed23ef7f23a', '0771f6cd-8796-53f2-893b-f52bb597a77a', 'لماذا يجري الغزال بسرعة؟', '[{"id":"a","text":"ليلعب فقط"},{"id":"b","text":"لينام"},{"id":"c","text":"ليهرب من الخطر"},{"id":"d","text":"ليشرب الماء"}]'::jsonb, 'c', 'من أسباب التنقّل الهروب من الخطر؛ فالغزال يجري ليهرب من الأعداء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d4db2d6-2839-5f6a-ab8c-3092ff85f7bb', '0771f6cd-8796-53f2-893b-f52bb597a77a', 'بأيّ عضوٍ تسبح السمكة في الماء؟', '[{"id":"a","text":"الزعانف والذيل"},{"id":"b","text":"الأجنحة"},{"id":"c","text":"الأرجل"},{"id":"d","text":"الأذنان"}]'::jsonb, 'a', 'تسبح السمكة في الماء بمساعدة زعانفها وذيلها.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8e6da8da-9fec-5df7-af33-dc5e11f1e311', '0771f6cd-8796-53f2-893b-f52bb597a77a', 'كيف يتنقّل العصفور في الهواء؟', '[{"id":"a","text":"بالزحف"},{"id":"b","text":"بالسباحة"},{"id":"c","text":"بالمشي"},{"id":"d","text":"بالطيران باستعمال جناحيه"}]'::jsonb, 'd', 'يطير العصفور في الهواء بمساعدة جناحيه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b74da70a-cf60-5206-8c20-8111315e0f82', '0771f6cd-8796-53f2-893b-f52bb597a77a', 'أيّ حيوانٍ يتنقّل بالقفز؟', '[{"id":"a","text":"الحلزون"},{"id":"b","text":"السمكة"},{"id":"c","text":"الأرنب"},{"id":"d","text":"الحصان"}]'::jsonb, 'c', 'الأرنب يتنقّل في البرّ بالقفز، أمّا الحصان فيجري والحلزون يزحف.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6805acf9-51e1-55ed-90da-b484cfa3020e', '33110808-20e9-5093-bd9a-5641bd0ef873', 'eveil-scientifique-3eme', '⭐ تمرين: أتعرّف على طرق التنقّل', 1, 50, 10, 'practice', 'admin', 1)
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
  ('c1b65a0e-3f40-53ea-8ae6-79afce1149a4', '6805acf9-51e1-55ed-90da-b484cfa3020e', 'أين تتنقّل السمكة؟', '[{"id":"a","text":"في الهواء"},{"id":"b","text":"في الماء"},{"id":"c","text":"تحت الأرض"},{"id":"d","text":"على الأشجار"}]'::jsonb, 'b', 'تتنقّل السمكة في الماء بالسباحة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc9fa80a-9090-5d16-a6e7-c9434eb1c25c', '6805acf9-51e1-55ed-90da-b484cfa3020e', 'كيف تتنقّل الأفعى؟', '[{"id":"a","text":"بالطيران"},{"id":"b","text":"بالقفز"},{"id":"c","text":"بالزحف"},{"id":"d","text":"بالسباحة فقط"}]'::jsonb, 'c', 'تتنقّل الأفعى في البرّ بالزحف لأنّها بلا أرجل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3fe26b90-6618-50ec-afc0-ce7358dca5bd', '6805acf9-51e1-55ed-90da-b484cfa3020e', 'ما عضو التنقّل عند العصفور؟', '[{"id":"a","text":"الجناحان"},{"id":"b","text":"الزعانف"},{"id":"c","text":"الذيل وحده"},{"id":"d","text":"الأذنان"}]'::jsonb, 'a', 'يطير العصفور في الهواء بمساعدة جناحيه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1d16ead3-8d9d-55f7-af17-0484e2244474', '6805acf9-51e1-55ed-90da-b484cfa3020e', 'أيّ حيوانٍ يتنقّل بالمشي والجري على أرجله؟', '[{"id":"a","text":"السمكة"},{"id":"b","text":"الفراشة"},{"id":"c","text":"الحلزون"},{"id":"d","text":"الحصان"}]'::jsonb, 'd', 'يتنقّل الحصان في البرّ بالمشي والجري على أرجله الأربع.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f220f7c-a979-5e98-a9dd-dc14f01327eb', '6805acf9-51e1-55ed-90da-b484cfa3020e', 'لماذا تتنقّل الحيوانات بحثًا عن الطعام؟', '[{"id":"a","text":"لأنّها تحبّ اللعب"},{"id":"b","text":"لأنّها تحتاج إلى الغذاء لتعيش"},{"id":"c","text":"لأنّها تريد النوم"},{"id":"d","text":"لأنّها تكره الماء"}]'::jsonb, 'b', 'تحتاج كلّ الكائنات الحيّة إلى الغذاء لتعيش، فتتنقّل لتبحث عنه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59b89286-27d4-5683-bbd8-845b9fb5ff91', '6805acf9-51e1-55ed-90da-b484cfa3020e', 'في الصورة، في أيّ وسطٍ يتنقّل هذا الكائن؟ <svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="110" fill="#bfe6f5" stroke="#1f6f8c" stroke-width="2"/><g stroke="#0f4a5c" stroke-width="2"><path d="M55 55 q35 -26 80 0 q-35 26 -80 0 z" fill="#e69138"/><path d="M55 55 l-20 -14 l0 28 z" fill="#d9881f"/></g><circle cx="118" cy="51" r="3" fill="#1f2937" stroke="none"/></svg>', '[{"id":"a","text":"في الماء (السباحة)"},{"id":"b","text":"في الهواء (الطيران)"},{"id":"c","text":"في البرّ (المشي)"},{"id":"d","text":"تحت الأرض (الحفر)"}]'::jsonb, 'a', 'الصورة سمكةٌ داخل الماء الأزرق، فهي تتنقّل في الماء بالسباحة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e34620a9-4fee-50f3-b74f-a51c2b9a30d2', '33110808-20e9-5093-bd9a-5641bd0ef873', 'eveil-scientifique-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد التنقّل', 3, 120, 30, 'boss', 'admin', 2)
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
  ('2136cdfa-c17c-5bf6-b551-76dcc30f5830', 'e34620a9-4fee-50f3-b74f-a51c2b9a30d2', 'تمشي البطّة في البرّ، وتسبح في الماء، وتطير في الهواء. ماذا نستنتج؟', '[{"id":"a","text":"البطّة لا تتنقّل"},{"id":"b","text":"البطّة تتنقّل في الماء فقط"},{"id":"c","text":"بعض الحيوانات تتنقّل في أكثر من وسط"},{"id":"d","text":"كلّ الحيوانات تطير"}]'::jsonb, 'c', 'البطّة تتنقّل في الأوساط الثلاثة، فبعض الحيوانات تتنقّل في أكثر من وسط. الخطأ الشائع هو الظنّ أنّ كلّ حيوانٍ يتنقّل في وسطٍ واحد فقط.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9751629-81a4-5c19-a72f-f23920479a34', 'e34620a9-4fee-50f3-b74f-a51c2b9a30d2', 'الحلزون يتنقّل ببطءٍ شديد. أيّ طريقةٍ يستعملها؟', '[{"id":"a","text":"الطيران"},{"id":"b","text":"الزحف"},{"id":"c","text":"القفز"},{"id":"d","text":"الجري"}]'::jsonb, 'b', 'يتنقّل الحلزون بالزحف على بطنه، وهو من أبطأ طرق التنقّل في البرّ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2fe854b2-9db0-5d69-8684-1fd64a57f211', 'e34620a9-4fee-50f3-b74f-a51c2b9a30d2', 'أيّ زوجٍ صحيحٌ بين عضو التنقّل والوسط؟', '[{"id":"a","text":"الزعانف ← الهواء"},{"id":"b","text":"الأجنحة ← الماء"},{"id":"c","text":"الأرجل ← الماء"},{"id":"d","text":"الأجنحة ← الهواء"}]'::jsonb, 'd', 'الأجنحة عضو التنقّل في الهواء (الطيران). الخطأ الشائع هو الخلط، فالزعانف للماء والأرجل للبرّ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('630ed88f-148c-5568-b7d8-e9455a5ee72a', 'e34620a9-4fee-50f3-b74f-a51c2b9a30d2', 'سمكةٌ فقدت ذيلها. ما الذي سيصعب عليها؟', '[{"id":"a","text":"الدفع في الماء والتقدّم"},{"id":"b","text":"الطيران في الهواء"},{"id":"c","text":"المشي على الأرجل"},{"id":"d","text":"النوم"}]'::jsonb, 'a', 'تدفع السمكة الماء بذيلها لتتقدّم، ففقدان الذيل يصعّب عليها الدفع والتنقّل. الخطأ الشائع هو الظنّ أنّ السمكة تمشي أو تطير.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('617f00a1-f91e-5081-a28d-4cf0f84c36bf', 'e34620a9-4fee-50f3-b74f-a51c2b9a30d2', 'أيّ مجموعةٍ كلّها حيواناتٌ تطير في الهواء؟', '[{"id":"a","text":"العصفور، السمكة، الأرنب"},{"id":"b","text":"الحصان، الأفعى، الحلزون"},{"id":"c","text":"السلحفاة، الضّفدع، القطّة"},{"id":"d","text":"العصفور، الفراشة، النحلة"}]'::jsonb, 'd', 'العصفور والفراشة والنحلة كلّها تطير في الهواء بأجنحتها. أمّا السمكة فتسبح والأرنب يقفز في البرّ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('267943f6-939a-51e7-a49f-4e3c620452c2', 'e34620a9-4fee-50f3-b74f-a51c2b9a30d2', 'لماذا يحتاج الإنسان إلى وسائل النقل مثل السيّارة والطائرة؟', '[{"id":"a","text":"لأنّه لا يستطيع المشي أبدًا"},{"id":"b","text":"ليأكل أكثر"},{"id":"c","text":"ليتنقّل بعيدًا وبسرعةٍ أكبر"},{"id":"d","text":"لأنّه يطير بجناحين"}]'::jsonb, 'c', 'يمشي الإنسان على رجليه، لكنّه يستعمل وسائل النقل ليتنقّل إلى أماكن بعيدةٍ وبسرعةٍ أكبر.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('781e8fe2-22e1-5abd-b5d0-b0fd31f03124', '33110808-20e9-5093-bd9a-5641bd0ef873', 'eveil-scientifique-3eme', '⭐⭐ تمرين مراجعة: التنقّل في الأوساط الثلاثة', 2, 75, 15, 'practice', 'admin', 3)
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
  ('6fd0a483-5025-5ed3-a9ff-8f96d75e9e8c', '781e8fe2-22e1-5abd-b5d0-b0fd31f03124', 'التنقّل في الماء يكون بـ:', '[{"id":"a","text":"السباحة"},{"id":"b","text":"الطيران"},{"id":"c","text":"القفز"},{"id":"d","text":"الزحف على الأرض"}]'::jsonb, 'a', 'التنقّل في الماء يكون بالسباحة بمساعدة الزعانف والذيل.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5f25b8a-c7e4-5213-b6bc-bb8aaf85292c', '781e8fe2-22e1-5abd-b5d0-b0fd31f03124', 'عضو التنقّل في الماء هو:', '[{"id":"a","text":"الجناح"},{"id":"b","text":"الزعنفة"},{"id":"c","text":"الأذن"},{"id":"d","text":"الأنف"}]'::jsonb, 'b', 'الزعنفة عضو التنقّل في الماء، بها وبالذيل تسبح السمكة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bcae0d31-990f-524a-8add-327f1bda068e', '781e8fe2-22e1-5abd-b5d0-b0fd31f03124', 'أيّ هذه ليس سببًا للتنقّل؟', '[{"id":"a","text":"البحث عن الغذاء"},{"id":"b","text":"البحث عن مأوى"},{"id":"c","text":"الهروب من الخطر"},{"id":"d","text":"البقاء بلا حركةٍ طوال اليوم"}]'::jsonb, 'd', 'البقاء بلا حركة ليس تنقّلًا؛ فالكائن يتنقّل ليبحث عن الغذاء والمأوى ويهرب من الخطر.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('967a294b-2448-59eb-ac74-3fcb7e2016c6', '781e8fe2-22e1-5abd-b5d0-b0fd31f03124', 'الأرنب والضّفدع يتنقّلان غالبًا بـ:', '[{"id":"a","text":"الطيران"},{"id":"b","text":"السباحة"},{"id":"c","text":"القفز"},{"id":"d","text":"الزحف"}]'::jsonb, 'c', 'يتنقّل الأرنب والضّفدع في البرّ بالقفز بأرجلهما الخلفيّة القويّة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33ea7393-1e03-5984-ac5a-adfa5b504204', '781e8fe2-22e1-5abd-b5d0-b0fd31f03124', 'في الصورة، كيف يتنقّل هذا الكائن في وسطه؟ <svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="110" fill="#cfeffd" stroke="#7fb8d6" stroke-width="2"/><circle cx="170" cy="24" r="13" fill="#ffd23f" stroke="#e0a400" stroke-width="2"/><g stroke="#5a3210" stroke-width="2"><ellipse cx="95" cy="58" rx="26" ry="15" fill="#e0533a"/><circle cx="122" cy="52" r="9" fill="#e0533a"/><path d="M82 54 q-26 -22 -42 -4 q22 4 40 12 z" fill="#f2a93c"/></g><circle cx="125" cy="50" r="2.5" fill="#1f2937" stroke="none"/></svg>', '[{"id":"a","text":"بالطيران في الهواء"},{"id":"b","text":"بالسباحة في الماء"},{"id":"c","text":"بالزحف تحت الأرض"},{"id":"d","text":"بالقفز فوق الأشجار"}]'::jsonb, 'a', 'الصورة طائرٌ بجناحٍ في السماء الزرقاء قرب الشمس، فهو يتنقّل بالطيران في الهواء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79f0aead-5416-5266-afe9-416e5dfea1ed', '781e8fe2-22e1-5abd-b5d0-b0fd31f03124', 'أيّ عبارةٍ صحيحة؟', '[{"id":"a","text":"كلّ الحيوانات تتنقّل بالطريقة نفسها"},{"id":"b","text":"السمكة تطير في الهواء"},{"id":"c","text":"الأفعى تمشي على أربع أرجل"},{"id":"d","text":"لكلّ وسطٍ طريقة تنقّلٍ تناسبه"}]'::jsonb, 'd', 'لكلّ وسطٍ طريقة تنقّلٍ تناسبه: المشي للبرّ، والسباحة للماء، والطيران للهواء.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('058227b7-d12a-5f85-88db-af0827e8f1b6', '33110808-20e9-5093-bd9a-5641bd0ef873', 'eveil-scientifique-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل التنقّل', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('c98a9f26-98cf-5471-af69-ce64b70139ed', '058227b7-d12a-5f85-88db-af0827e8f1b6', 'حيوانٌ له زعانف وذيلٌ قويّ وليس له أرجل. أين يعيش ويتنقّل غالبًا؟', '[{"id":"a","text":"في الهواء"},{"id":"b","text":"على قمم الأشجار"},{"id":"c","text":"تحت الأرض"},{"id":"d","text":"في الماء"}]'::jsonb, 'd', 'الزعانف والذيل أعضاء سباحةٍ في الماء، فهذا الحيوان (كالسمكة) يعيش ويتنقّل في الماء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('203be71e-23b8-5903-9342-bcf0e1e85143', '058227b7-d12a-5f85-88db-af0827e8f1b6', 'لماذا يصعب على الأفعى أن تتنقّل مثل الحصان؟', '[{"id":"a","text":"لأنّها بلا أرجلٍ فلا تستطيع المشي والجري"},{"id":"b","text":"لأنّها أكبر من الحصان"},{"id":"c","text":"لأنّها تطير دائمًا"},{"id":"d","text":"لأنّها تعيش في الماء فقط"}]'::jsonb, 'a', 'الحصان يجري على أرجله، أمّا الأفعى فبلا أرجل، لذلك تتنقّل بالزحف لا بالجري.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a81e682-a162-5691-8db7-1fc0556d542e', '058227b7-d12a-5f85-88db-af0827e8f1b6', 'البطّة لها أرجلٌ وجناحان. أيّ جملةٍ تصف تنقّلها بدقّة؟', '[{"id":"a","text":"تطير فقط ولا تمشي"},{"id":"b","text":"تزحف على بطنها مثل الأفعى"},{"id":"c","text":"تمشي في البرّ وتسبح في الماء وتطير في الهواء"},{"id":"d","text":"تعيش تحت الأرض"}]'::jsonb, 'c', 'البطّة تستعمل أرجلها للمشي والسباحة، وجناحيها للطيران، فهي تتنقّل في الأوساط الثلاثة. الخطأ الشائع هو حصرها في وسطٍ واحد.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0363e0f6-a6d4-5829-b2c1-27ab8dc57e30', '058227b7-d12a-5f85-88db-af0827e8f1b6', 'أيّ استنتاجٍ صحيحٍ من ملاحظة طرق تنقّل الحيوانات؟', '[{"id":"a","text":"كلّ الحيوانات لها أجنحة"},{"id":"b","text":"عضو التنقّل يناسب الوسط الذي يعيش فيه الحيوان"},{"id":"c","text":"الحيوانات لا تحتاج إلى التنقّل"},{"id":"d","text":"السمكة والعصفور يتنقّلان بالطريقة نفسها"}]'::jsonb, 'b', 'نلاحظ أنّ لكلّ حيوانٍ عضوًا يناسب وسطه: أرجلٌ للبرّ، زعانفُ للماء، أجنحةٌ للهواء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('efb29fe4-3e16-5818-b214-c4047b744623', '058227b7-d12a-5f85-88db-af0827e8f1b6', 'أرادت عائلةٌ السفر من تونس إلى بلدٍ بعيدٍ عبر البحر بسرعة. أيّ وسيلةٍ تناسبها أكثر؟', '[{"id":"a","text":"الدرّاجة"},{"id":"b","text":"المشي على الأقدام"},{"id":"c","text":"الزحف"},{"id":"d","text":"الطائرة"}]'::jsonb, 'd', 'للسفر بعيدًا وبسرعةٍ كبيرةٍ تناسب الطائرة أكثر من الدرّاجة أو المشي. الخطأ الشائع اختيار وسيلةٍ بطيئةٍ للمسافات البعيدة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e956486b-3dfd-5ce7-98b4-a713a634c16a', '058227b7-d12a-5f85-88db-af0827e8f1b6', 'في الصورة كائنٌ في وسطه. ما عضو التنقّل الذي يستعمله؟ <svg viewBox="0 0 210 110" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="210" height="110" fill="#bfe6f5" stroke="#1f6f8c" stroke-width="2"/><g stroke="#0f4a5c" stroke-width="2"><path d="M60 58 q36 -26 82 0 q-36 26 -82 0 z" fill="#3aae6a"/><path d="M60 58 l-20 -14 l0 28 z" fill="#2c8a52"/><path d="M104 38 l8 -11 l8 11 z" fill="#2c8a52"/></g><circle cx="126" cy="54" r="3" fill="#1f2937" stroke="none"/></svg>', '[{"id":"a","text":"الأجنحة للطيران"},{"id":"b","text":"الزعانف والذيل للسباحة"},{"id":"c","text":"الأرجل للجري"},{"id":"d","text":"لا يتنقّل"}]'::jsonb, 'b', 'الصورة سمكةٌ خضراء داخل الماء الأزرق، لها زعانف وذيل، فتتنقّل بالسباحة. الخطأ الشائع هو اختيار الأجنحة، لكنّها في الماء لا في الهواء.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0abbee05-7ed5-563c-9140-0821db9fb4d0', '33110808-20e9-5093-bd9a-5641bd0ef873', 'eveil-scientifique-3eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للتنقّل', 3, 120, 30, 'boss', 'admin', 5)
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
  ('909eeb55-62c3-5a74-91ed-ba1278a197af', '0abbee05-7ed5-563c-9140-0821db9fb4d0', 'الزحف طريقة تنقّلٍ في:', '[{"id":"a","text":"الهواء"},{"id":"b","text":"البرّ"},{"id":"c","text":"السماء"},{"id":"d","text":"النار"}]'::jsonb, 'b', 'الزحف طريقة تنقّلٍ في البرّ، تستعملها الأفعى والحلزون.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ce0d67b-b9db-567d-ab3c-ebfebf001015', '0abbee05-7ed5-563c-9140-0821db9fb4d0', 'النحلة كائنٌ يتنقّل في:', '[{"id":"a","text":"الماء"},{"id":"b","text":"تحت الأرض"},{"id":"c","text":"البحر"},{"id":"d","text":"الهواء"}]'::jsonb, 'd', 'تتنقّل النحلة في الهواء بالطيران بأجنحتها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1c44fb7-f5a6-529c-bde4-b9b53092b7ba', '0abbee05-7ed5-563c-9140-0821db9fb4d0', 'أيّ زوجٍ صحيحٌ بين الطريقة والحيوان؟', '[{"id":"a","text":"القفز ← الأرنب"},{"id":"b","text":"السباحة ← العصفور"},{"id":"c","text":"الطيران ← السمكة"},{"id":"d","text":"الزحف ← الحصان"}]'::jsonb, 'a', 'الأرنب يتنقّل بالقفز. أمّا العصفور فيطير، والسمكة تسبح، والحصان يجري لا يزحف.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e7c8194-2f7e-5db3-b1ba-883667d525dc', '0abbee05-7ed5-563c-9140-0821db9fb4d0', 'حيوانٌ يطير بجناحين ويعيش في الهواء غالبًا. ما هو من هؤلاء؟', '[{"id":"a","text":"الحلزون"},{"id":"b","text":"السلحفاة"},{"id":"c","text":"الفراشة"},{"id":"d","text":"السمكة"}]'::jsonb, 'c', 'الفراشة لها جناحان وتطير في الهواء، أمّا الحلزون فيزحف والسمكة تسبح.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3fd70238-b247-508c-8a7f-112541727cd1', '0abbee05-7ed5-563c-9140-0821db9fb4d0', 'وضعنا سمكةً خارج الماء على الأرض. لماذا لا تستطيع التنقّل جيّدًا؟', '[{"id":"a","text":"لأنّها مصمّمةٌ للسباحة في الماء لا للمشي على الأرض"},{"id":"b","text":"لأنّها نائمة"},{"id":"c","text":"لأنّها تطير"},{"id":"d","text":"لأنّها كبيرة جدًّا"}]'::jsonb, 'a', 'للسمكة زعانف وذيلٌ للسباحة في الماء، وليست لها أرجلٌ للمشي، فلا تتنقّل جيّدًا خارج الماء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f360ad9a-23aa-5688-8d0b-ac1db72e5bef', '0abbee05-7ed5-563c-9140-0821db9fb4d0', 'أيّ عبارةٍ **خاطئة**؟', '[{"id":"a","text":"العصفور يتنقّل بالطيران"},{"id":"b","text":"السمكة تتنقّل بالسباحة"},{"id":"c","text":"الأفعى تتنقّل بالطيران بجناحين"},{"id":"d","text":"الحصان يتنقّل بالجري"}]'::jsonb, 'c', 'العبارة الخاطئة أنّ الأفعى تطير بجناحين؛ فالأفعى بلا أجنحةٍ وتتنقّل بالزحف في البرّ.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c119104a-d854-5912-8869-c841c44588d6', 'd28e5b7a-16ef-528f-9ca4-3da1a8763005', 'eveil-scientifique-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('201fb9c0-147c-5c86-88db-93a87952cdb2', 'c119104a-d854-5912-8869-c841c44588d6', 'من أين نأخذ الحليب والبيض واللحم؟', '[{"id":"a","text":"من النبات"},{"id":"b","text":"من الحيوان"},{"id":"c","text":"من التربة"},{"id":"d","text":"من الماء فقط"}]'::jsonb, 'b', 'الحليب والبيض واللحم أغذية من أصلٍ حيوانيّ، أي نأخذها من الحيوان.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a67ba1a-7685-5e5b-b9d9-0a3ff42dc4b3', 'c119104a-d854-5912-8869-c841c44588d6', 'أيّ هذه الأغذية من أصلٍ نباتيّ؟', '[{"id":"a","text":"التفاحة والخبز"},{"id":"b","text":"اللحم والسمك"},{"id":"c","text":"البيض والحليب"},{"id":"d","text":"الدجاج فقط"}]'::jsonb, 'a', 'التفاحة والخبز أغذية من أصلٍ نباتيّ، أمّا اللحم والسمك والبيض فمن أصلٍ حيوانيّ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e1768d6-0a40-53e2-9caf-7d91af4fa520', 'c119104a-d854-5912-8869-c841c44588d6', 'الأرنب يأكل النبات فقط، فهو حيوانٌ:', '[{"id":"a","text":"لاحم"},{"id":"b","text":"يأكل كلّ شيء"},{"id":"c","text":"عاشب"},{"id":"d","text":"لا يأكل"}]'::jsonb, 'c', 'الحيوان الذي يأكل النبات فقط يسمّى عاشبًا، مثل الأرنب.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29795088-25d2-597b-b3ce-40ebafa804da', 'c119104a-d854-5912-8869-c841c44588d6', 'كيف تحصل النبتة الخضراء على غذائها؟', '[{"id":"a","text":"تأكل الحشرات"},{"id":"b","text":"يطعمها الفلّاح كلّ يوم"},{"id":"c","text":"تأخذه جاهزًا من الأرض"},{"id":"d","text":"تصنعه بنفسها بمساعدة الضوء والماء"}]'::jsonb, 'd', 'النبتة الخضراء تصنع غذاءها بنفسها بفضل ضوء الشمس والماء والهواء والتربة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8f03591b-c3ce-55ec-8a15-64568f4aa6c5', 'c119104a-d854-5912-8869-c841c44588d6', 'لماذا يجب أن يكون غذاء الإنسان متنوّعًا ومتوازنًا؟', '[{"id":"a","text":"لأنّ الطعام المتنوّع لذيذ فقط"},{"id":"b","text":"ليبقى الإنسان في صحّةٍ جيّدة"},{"id":"c","text":"لأنّ الإنسان لا يأكل النبات"},{"id":"d","text":"ليأكل نوعًا واحدًا فقط"}]'::jsonb, 'b', 'التغذية المتنوّعة والمتوازنة تحافظ على صحّة الإنسان وتمنحه القوّة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('40686eb3-858d-57b7-aaf3-461b3ec644b3', 'd28e5b7a-16ef-528f-9ca4-3da1a8763005', 'eveil-scientifique-3eme', '⭐ تمرين: أتعرّف على مصادر الأغذية', 1, 50, 10, 'practice', 'admin', 1)
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
  ('c6ec705a-cb52-516d-a07a-856cb79d9ccb', '40686eb3-858d-57b7-aaf3-461b3ec644b3', 'من أين نأخذ اللحم؟', '[{"id":"a","text":"من الحيوان"},{"id":"b","text":"من النبات"},{"id":"c","text":"من الحجر"},{"id":"d","text":"من الماء فقط"}]'::jsonb, 'a', 'اللحم غذاءٌ من أصلٍ حيوانيّ، أي نأخذه من الحيوان.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d5bfe90d-7548-55cc-81f6-69a33a75527f', '40686eb3-858d-57b7-aaf3-461b3ec644b3', 'الخبز والحبوب أغذية من أصلٍ:', '[{"id":"a","text":"حيوانيّ"},{"id":"b","text":"نباتيّ"},{"id":"c","text":"حجريّ"},{"id":"d","text":"معدنيّ"}]'::jsonb, 'b', 'الخبز والحبوب نأخذها من النبات، فهي أغذية من أصلٍ نباتيّ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2d4d78d-d757-5274-8799-2f76636ba017', '40686eb3-858d-57b7-aaf3-461b3ec644b3', 'ما الحيوان الذي نأخذ منه البيض؟', '[{"id":"a","text":"الأرنب"},{"id":"b","text":"البقرة"},{"id":"c","text":"الدجاجة"},{"id":"d","text":"الحصان"}]'::jsonb, 'c', 'نأخذ البيض من الدجاجة، وهو غذاءٌ من أصلٍ حيوانيّ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b0098a7-771f-5de3-9257-d00d0ad6241d', '40686eb3-858d-57b7-aaf3-461b3ec644b3', 'أيّ هذه غذاءٌ من أصلٍ نباتيّ؟', '[{"id":"a","text":"السمك"},{"id":"b","text":"الحليب"},{"id":"c","text":"البيض"},{"id":"d","text":"الجزر"}]'::jsonb, 'd', 'الجزر خضرةٌ من النبات، فهو غذاءٌ من أصلٍ نباتيّ، أمّا السمك والحليب والبيض فمن أصلٍ حيوانيّ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a01296c6-a12b-5347-b327-e945fcfafd33', '40686eb3-858d-57b7-aaf3-461b3ec644b3', 'لكي يبقى الإنسان في صحّةٍ جيّدة، يجب أن يكون غذاؤه:', '[{"id":"a","text":"حلوى فقط"},{"id":"b","text":"متنوّعًا ومتوازنًا"},{"id":"c","text":"نوعًا واحدًا كلّ يوم"},{"id":"d","text":"قليلًا جدًّا دائمًا"}]'::jsonb, 'b', 'التغذية المتنوّعة والمتوازنة تحافظ على صحّة الإنسان وتمنحه القوّة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f537fc20-d8b3-52db-addb-779e4f9fc5a1', '40686eb3-858d-57b7-aaf3-461b3ec644b3', 'ما الذي تحتاجه النبتة الخضراء لتصنع غذاءها؟', '[{"id":"a","text":"اللحم والحلوى"},{"id":"b","text":"الظلام التامّ"},{"id":"c","text":"الضوء والماء والهواء والتربة"},{"id":"d","text":"البيض والحليب"}]'::jsonb, 'c', 'تصنع النبتة الخضراء غذاءها بنفسها بفضل ضوء الشمس والماء والهواء والتربة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ac839152-7e14-519b-89e5-4cbfc8866534', 'd28e5b7a-16ef-528f-9ca4-3da1a8763005', 'eveil-scientifique-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد التغذية', 3, 120, 30, 'boss', 'admin', 2)
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
  ('64043114-6ae6-59f1-b791-3035f98386a8', 'ac839152-7e14-519b-89e5-4cbfc8866534', 'البقرة تأكل العشب والتبن فقط. إلى أيّ مجموعةٍ تنتمي؟', '[{"id":"a","text":"اللاحمة"},{"id":"b","text":"العاشبة"},{"id":"c","text":"آكلة كلّ شيء"},{"id":"d","text":"لا تأكل شيئًا"}]'::jsonb, 'b', 'البقرة تأكل النبات فقط، فهي حيوانٌ عاشب. الخطأ الشائع هو ظنّ كلّ الحيوانات الكبيرة لاحمة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('907b418c-754d-58d9-ada6-4639dec84327', 'ac839152-7e14-519b-89e5-4cbfc8866534', 'الإنسان يأكل الخبز والخضر واللحم والسمك. فهو حيوانٌ:', '[{"id":"a","text":"عاشب فقط"},{"id":"b","text":"لاحم فقط"},{"id":"c","text":"لا يتغذّى"},{"id":"d","text":"آكل كلّ شيء"}]'::jsonb, 'd', 'الإنسان يأكل النبات واللحم معًا، فهو من آكلة كلّ شيء. الخطأ الشائع حصره في نوعٍ واحد من الغذاء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7eff0ff8-1f4d-5d41-a196-1a12ae7d175b', 'ac839152-7e14-519b-89e5-4cbfc8866534', 'في الصورة حيوانٌ يأكل لحم فريسته. إلى أيّ مجموعةٍ ينتمي؟ <svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="110" fill="#fde7c8" stroke="#e0a400" stroke-width="2"/><g stroke="#5a3210" stroke-width="2"><circle cx="70" cy="55" r="30" fill="#e69138"/><circle cx="70" cy="55" r="20" fill="#f2b25c"/><path d="M70 36 l-5 10 l10 0 z" fill="#5a3210"/><line x1="70" y1="60" x2="70" y2="68"/><path d="M62 70 q8 6 16 0" fill="none"/></g><circle cx="61" cy="52" r="2.5" fill="#1f2937" stroke="none"/><circle cx="79" cy="52" r="2.5" fill="#1f2937" stroke="none"/><path d="M120 50 l24 -8 l-6 12 l10 8 l-22 4 z" fill="#e0533a" stroke="#1f2937" stroke-width="2"/></svg>', '[{"id":"a","text":"اللاحمة (آكلة اللحم)"},{"id":"b","text":"العاشبة (آكلة النبات)"},{"id":"c","text":"لا يأكل"},{"id":"d","text":"النبات الأخضر"}]'::jsonb, 'a', 'الصورة أسدٌ يأكل قطعة لحمٍ حمراء، فهو حيوانٌ لاحم. الخطأ الشائع هو الخلط بينه وبين العاشبة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1af403f6-dc4d-5890-8708-2bb2b4a526d8', 'ac839152-7e14-519b-89e5-4cbfc8866534', 'أيّ مجموعةٍ كلّها حيواناتٌ لاحمة؟', '[{"id":"a","text":"الأرنب، البقرة، الخروف"},{"id":"b","text":"الحصان، الغزال، الأرنب"},{"id":"c","text":"الأسد، الذئب، النمر"},{"id":"d","text":"البقرة، الدجاجة، الإنسان"}]'::jsonb, 'c', 'الأسد والذئب والنمر تأكل اللحم، فهي لاحمة. الخطأ الشائع هو إدراج الأرنب أو البقرة العاشبة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1361b202-b36d-549b-85d0-68583e2cb5c3', 'ac839152-7e14-519b-89e5-4cbfc8866534', 'وضع فلّاحٌ نبتةً خضراء في غرفةٍ مظلمةٍ تمامًا. ماذا سيحدث لها غالبًا؟', '[{"id":"a","text":"تكبر أسرع"},{"id":"b","text":"تصير حيوانًا"},{"id":"c","text":"تأكل اللحم"},{"id":"d","text":"تضعف لأنّها بلا ضوءٍ لا تصنع غذاءها جيّدًا"}]'::jsonb, 'd', 'النبتة الخضراء تحتاج إلى الضوء لتصنع غذاءها، فبلا ضوءٍ تضعف. الخطأ الشائع ظنّ أنّ النبتة تستغني عن الشمس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29a4bb61-793e-51c9-9f42-5769071f1f81', 'ac839152-7e14-519b-89e5-4cbfc8866534', 'لماذا تختلف أغذية الحيوانات من حيوانٍ إلى آخر؟', '[{"id":"a","text":"لأنّ كلّ الحيوانات تأكل الشيء نفسه"},{"id":"b","text":"لأنّ لكلّ مجموعةٍ نوع غذاءٍ يناسبها (عاشبة، لاحمة، آكلة كلّ شيء)"},{"id":"c","text":"لأنّ الحيوانات لا تأكل أبدًا"},{"id":"d","text":"لأنّ كلّ الحيوانات تأكل النبات فقط"}]'::jsonb, 'b', 'نصنّف الحيوانات حسب غذائها: عاشبة تأكل النبات، ولاحمة تأكل اللحم، وآكلة كلّ شيء تأكلهما معًا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ed36dca3-31e6-5d31-9ec0-381335cf4938', 'd28e5b7a-16ef-528f-9ca4-3da1a8763005', 'eveil-scientifique-3eme', '⭐⭐ تمرين مراجعة: مصادر الأغذية وأنواع التغذية', 2, 75, 15, 'practice', 'admin', 3)
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
  ('188edc0d-8821-57f6-8662-0d9050a4ec65', 'ed36dca3-31e6-5d31-9ec0-381335cf4938', 'السمك غذاءٌ من أصلٍ:', '[{"id":"a","text":"نباتيّ"},{"id":"b","text":"حجريّ"},{"id":"c","text":"حيوانيّ"},{"id":"d","text":"معدنيّ"}]'::jsonb, 'c', 'السمك نأخذه من حيوانٍ يعيش في الماء، فهو غذاءٌ من أصلٍ حيوانيّ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('52e58ea8-34e9-5d57-b08d-e5cd494ba129', 'ed36dca3-31e6-5d31-9ec0-381335cf4938', 'الحيوان الذي يأكل لحوم حيواناتٍ أخرى يسمّى:', '[{"id":"a","text":"لاحمًا"},{"id":"b","text":"عاشبًا"},{"id":"c","text":"نباتًا"},{"id":"d","text":"ثابتًا"}]'::jsonb, 'a', 'الحيوان الذي يأكل اللحم يسمّى لاحمًا، مثل الأسد والذئب.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df014cfa-8cf9-5394-b506-6169132eb9f9', 'ed36dca3-31e6-5d31-9ec0-381335cf4938', 'في الصورة حيوانٌ يأكل العشب الأخضر. ما هو؟ <svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="110" fill="#eaf7e0" stroke="#3aae6a" stroke-width="2"/><g stroke="#1f2937" stroke-width="2"><ellipse cx="95" cy="58" rx="30" ry="20" fill="#e6c8a0"/><circle cx="66" cy="50" r="14" fill="#e6c8a0"/><path d="M60 38 l-3 -16 l8 9 z" fill="#d8b48a"/><path d="M70 39 l3 -16 l5 11 z" fill="#d8b48a"/></g><circle cx="60" cy="49" r="2.5" fill="#1f2937" stroke="none"/><g stroke="#2c8a52" stroke-width="2"><line x1="52" y1="86" x2="52" y2="72"/><line x1="60" y1="86" x2="60" y2="70"/><line x1="68" y1="86" x2="68" y2="72"/></g></svg>', '[{"id":"a","text":"أسدٌ لاحم"},{"id":"b","text":"سمكةٌ تسبح"},{"id":"c","text":"نملةٌ صغيرة"},{"id":"d","text":"أرنبٌ عاشب"}]'::jsonb, 'd', 'الصورة أرنبٌ يأكل العشب الأخضر، فهو حيوانٌ عاشب يأكل النبات فقط.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b996a8be-152b-57bc-949e-170028ff1232', 'ed36dca3-31e6-5d31-9ec0-381335cf4938', 'أيّ هذه ليس من حاجات النبتة الخضراء لتصنع غذاءها؟', '[{"id":"a","text":"ضوء الشمس"},{"id":"b","text":"قطعة لحم"},{"id":"c","text":"الماء"},{"id":"d","text":"التربة"}]'::jsonb, 'b', 'النبتة الخضراء تحتاج إلى الضوء والماء والهواء والتربة، ولا تأكل اللحم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6c6fc414-0e23-568e-a35d-b6819ac19e2c', 'ed36dca3-31e6-5d31-9ec0-381335cf4938', 'أيّ مجموعةٍ كلّها أغذية من أصلٍ نباتيّ؟', '[{"id":"a","text":"الخضر، الغلال، الخبز"},{"id":"b","text":"اللحم، الحليب، البيض"},{"id":"c","text":"السمك، البيض، الخبز"},{"id":"d","text":"الحليب، الجزر، اللحم"}]'::jsonb, 'a', 'الخضر والغلال والخبز كلّها من النبات، فهي أغذية من أصلٍ نباتيّ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('132bbfc8-1fa5-58ad-adc9-deadfc8a2c4b', 'ed36dca3-31e6-5d31-9ec0-381335cf4938', 'طفلٌ يأكل الحلوى فقط ويرفض الخضر واللحم. ماذا ننصحه؟', '[{"id":"a","text":"أن يأكل حلوى أكثر"},{"id":"b","text":"أن يتوقّف عن الأكل"},{"id":"c","text":"أن ينوّع غذاءه ليبقى في صحّةٍ جيّدة"},{"id":"d","text":"أن يأكل نوعًا واحدًا فقط"}]'::jsonb, 'c', 'الغذاء المتنوّع والمتوازن يحافظ على الصحّة، فننصح الطفل بأن ينوّع غذاءه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f0505ce7-5626-5c03-86aa-0ed48290a70a', 'd28e5b7a-16ef-528f-9ca4-3da1a8763005', 'eveil-scientifique-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل التغذية', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('d5531426-fd43-55f4-93db-f32b4b3c7ec3', 'f0505ce7-5626-5c03-86aa-0ed48290a70a', 'حيوانٌ له أنيابٌ حادّة ويصطاد حيواناتٍ أخرى ليأكل لحمها. إلى أيّ مجموعةٍ ينتمي؟', '[{"id":"a","text":"العاشبة"},{"id":"b","text":"النباتات"},{"id":"c","text":"آكلة العشب فقط"},{"id":"d","text":"اللاحمة"}]'::jsonb, 'd', 'الحيوان الذي يصطاد ويأكل اللحم هو لاحم، مثل الأسد والذئب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa30df1f-3ac6-525e-a992-b39eb3ae3734', 'f0505ce7-5626-5c03-86aa-0ed48290a70a', 'لماذا لا نضع لحمًا في إناء نبتةٍ خضراء لنغذّيها؟', '[{"id":"a","text":"لأنّ اللحم غالي الثمن"},{"id":"b","text":"لأنّ النبتة تصنع غذاءها بنفسها ولا تأكل اللحم"},{"id":"c","text":"لأنّ النبتة تفضّل الحلوى"},{"id":"d","text":"لأنّ النبتة تأكل في الليل فقط"}]'::jsonb, 'b', 'النبتة الخضراء لا تأكل مثل الحيوان؛ بل تصنع غذاءها بنفسها بالضوء والماء والهواء والتربة. الخطأ الشائع هو معاملتها كحيوان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9bd5aad-5183-5b94-8f7c-34157a0acc0b', 'f0505ce7-5626-5c03-86aa-0ed48290a70a', 'البيضة من الدجاجة، والتفاحة من الشجرة، والحليب من البقرة. أيّ ترتيبٍ صحيحٌ للمصادر؟', '[{"id":"a","text":"البيضة والحليب حيوانيّ، والتفاحة نباتيّ"},{"id":"b","text":"الثلاثة من أصلٍ نباتيّ"},{"id":"c","text":"الثلاثة من أصلٍ حيوانيّ"},{"id":"d","text":"التفاحة والحليب حيوانيّ، والبيضة نباتيّ"}]'::jsonb, 'a', 'البيضة والحليب من الحيوان (أصل حيوانيّ)، والتفاحة من النبات (أصل نباتيّ). الخطأ الشائع هو الخلط بين المصدرين.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90969539-3845-5984-82dc-6761da55b4ea', 'f0505ce7-5626-5c03-86aa-0ed48290a70a', 'تأكل الدجاجة الحبوب وأيضًا الديدان والحشرات الصغيرة. كيف نصنّفها؟', '[{"id":"a","text":"عاشبة فقط"},{"id":"b","text":"لا تأكل شيئًا"},{"id":"c","text":"آكلة كلّ شيء (نبات ولحم)"},{"id":"d","text":"نبات أخضر"}]'::jsonb, 'c', 'الدجاجة تأكل النبات (الحبوب) واللحم (الديدان) معًا، فهي من آكلة كلّ شيء. الخطأ الشائع حصرها في العاشبة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('086a3606-27c1-547b-b5c4-2c59d5d98523', 'f0505ce7-5626-5c03-86aa-0ed48290a70a', 'في الصورة نبتةٌ خضراء في التربة تحت الشمس. ما الذي يساعدها على صنع غذائها؟ <svg viewBox="0 0 210 120" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="210" height="120" fill="#cfeffd" stroke="#7fb8d6" stroke-width="2"/><rect x="0" y="88" width="210" height="32" fill="#8a5a2b" stroke="#5a3210" stroke-width="2"/><circle cx="175" cy="28" r="15" fill="#ffd23f" stroke="#e0a400" stroke-width="2"/><g stroke="#2c8a52" stroke-width="3"><line x1="95" y1="88" x2="95" y2="46"/><path d="M95 66 q-22 -6 -28 -22 q22 0 28 16 z" fill="#3aae6a"/><path d="M95 58 q22 -6 28 -22 q-22 0 -28 16 z" fill="#3aae6a"/></g></svg>', '[{"id":"a","text":"اللحم والحليب"},{"id":"b","text":"الظلام والبرد"},{"id":"c","text":"الحلوى والسكّر"},{"id":"d","text":"ضوء الشمس والماء والهواء والتربة"}]'::jsonb, 'd', 'الصورة نبتةٌ خضراء في التربة تحت الشمس، فتصنع غذاءها بفضل الضوء والماء والهواء والتربة. الخطأ الشائع ظنّها تأكل غذاءً حيوانيًّا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('64ee1427-e7f5-5795-83a4-c55eb686e7dd', 'f0505ce7-5626-5c03-86aa-0ed48290a70a', 'أيّ استنتاجٍ صحيحٍ بعد دراسة تغذية الكائنات الحيّة؟', '[{"id":"a","text":"الإنسان والحيوان يأكلان غذاءً جاهزًا، أمّا النبتة الخضراء فتصنع غذاءها بنفسها"},{"id":"b","text":"كلّ الحيوانات تأكل اللحم فقط"},{"id":"c","text":"النبتة تأكل مثل الأسد تمامًا"},{"id":"d","text":"الإنسان لا يحتاج إلى غذاءٍ متنوّع"}]'::jsonb, 'a', 'الإنسان والحيوان يأخذان غذاءهما جاهزًا من النبات أو الحيوان، أمّا النبتة الخضراء فتصنعه بنفسها. الخطأ الشائع تعميم نوعٍ واحد من التغذية على الجميع.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c3d9e955-5da2-5706-a3c9-d34791293307', 'd28e5b7a-16ef-528f-9ca4-3da1a8763005', 'eveil-scientifique-3eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للتغذية', 3, 120, 30, 'boss', 'admin', 5)
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
  ('7e03415f-b7f8-5e0e-af53-700e8dffc913', 'c3d9e955-5da2-5706-a3c9-d34791293307', 'الخروف يأكل العشب فقط، فهو حيوانٌ:', '[{"id":"a","text":"عاشب"},{"id":"b","text":"لاحم"},{"id":"c","text":"آكل كلّ شيء"},{"id":"d","text":"لا يأكل"}]'::jsonb, 'a', 'الخروف يأكل النبات فقط، فهو حيوانٌ عاشب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ab19484-50b4-5e4f-995c-c0a8522401ea', 'c3d9e955-5da2-5706-a3c9-d34791293307', 'الحليب نأخذه من:', '[{"id":"a","text":"الشجرة"},{"id":"b","text":"التربة"},{"id":"c","text":"البقرة"},{"id":"d","text":"الحجر"}]'::jsonb, 'c', 'نأخذ الحليب من البقرة، فهو غذاءٌ من أصلٍ حيوانيّ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('928e72b6-df81-5fd3-99b0-ea166ca4b4a0', 'c3d9e955-5da2-5706-a3c9-d34791293307', 'أيّ زوجٍ صحيحٌ بين الحيوان وغذائه؟', '[{"id":"a","text":"الأسد ← العشب"},{"id":"b","text":"البقرة ← العشب"},{"id":"c","text":"الذئب ← النبات فقط"},{"id":"d","text":"الأرنب ← اللحم"}]'::jsonb, 'b', 'البقرة عاشبةٌ تأكل العشب. أمّا الأسد والذئب فلاحمان يأكلان اللحم، والأرنب عاشبٌ لا يأكل اللحم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2c75abaf-8e1a-58d9-b311-b7351523f419', 'c3d9e955-5da2-5706-a3c9-d34791293307', 'أيّ عبارةٍ صحيحةٌ عن النبتة الخضراء؟', '[{"id":"a","text":"تأكل اللحم مثل الأسد"},{"id":"b","text":"تعيش بلا ماءٍ ولا ضوء"},{"id":"c","text":"يطعمها الفلّاح بالحليب"},{"id":"d","text":"تصنع غذاءها بنفسها بفضل الضوء والماء"}]'::jsonb, 'd', 'النبتة الخضراء تصنع غذاءها بنفسها بفضل ضوء الشمس والماء والهواء والتربة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3f58ed2-f7c9-5df5-89bc-868362792da0', 'c3d9e955-5da2-5706-a3c9-d34791293307', 'لماذا نقول إنّ الإنسان من آكلة كلّ شيء؟', '[{"id":"a","text":"لأنّه يأكل النبات فقط"},{"id":"b","text":"لأنّه يأكل اللحم فقط"},{"id":"c","text":"لأنّه يأكل النبات واللحم معًا"},{"id":"d","text":"لأنّه لا يأكل أبدًا"}]'::jsonb, 'c', 'الإنسان يأكل أغذية نباتيّة وحيوانيّة معًا، فهو من آكلة كلّ شيء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40f02b2d-9e63-5ad0-b65e-3488bcb78c91', 'c3d9e955-5da2-5706-a3c9-d34791293307', 'أيّ عبارةٍ **خاطئة**؟', '[{"id":"a","text":"البقرة حيوانٌ عاشب"},{"id":"b","text":"النبتة الخضراء تأكل اللحم مثل الأسد"},{"id":"c","text":"الأسد حيوانٌ لاحم"},{"id":"d","text":"البيض غذاءٌ من أصلٍ حيوانيّ"}]'::jsonb, 'b', 'العبارة الخاطئة أنّ النبتة تأكل اللحم؛ فالنبتة الخضراء تصنع غذاءها بنفسها ولا تأكل اللحم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b4e13aeb-1d88-5a7d-b66e-faa404fa35eb', '06e7a563-9ae6-56c5-ace2-7f8233bd3080', 'eveil-scientifique-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('6fff6cf6-1749-5712-8668-a26e214474bb', 'b4e13aeb-1d88-5a7d-b66e-faa404fa35eb', 'ماذا نعني بأنّ الكائن الحيّ يتكاثر؟', '[{"id":"a","text":"يعطي كائنًا جديدًا من نوعه"},{"id":"b","text":"يأكل ويشرب"},{"id":"c","text":"ينام ويستريح"},{"id":"d","text":"يتنقّل من مكانٍ إلى آخر"}]'::jsonb, 'a', 'التكاثر هو أن يعطي الكائن الحيّ كائنًا جديدًا من نوعه، مثل الدجاجة والكتكوت.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c6e4653d-19c1-54ff-a21f-eea4e14051de', 'b4e13aeb-1d88-5a7d-b66e-faa404fa35eb', 'ما عضو التكاثر عند النبات الزهري؟', '[{"id":"a","text":"الجذر"},{"id":"b","text":"الورقة"},{"id":"c","text":"الزهرة"},{"id":"d","text":"الساق"}]'::jsonb, 'c', 'الزهرة هي عضو التكاثر عند النبات؛ منها تتكوّن الثمرة وفيها البذور.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5e42aca-a630-5ee9-aa58-df57f4ce80ea', 'b4e13aeb-1d88-5a7d-b66e-faa404fa35eb', 'البقرة تلد عِجلًا حيًّا وتُرضعه الحليب. فهي حيوانٌ:', '[{"id":"a","text":"بيوضٌ يضع البيض"},{"id":"b","text":"ولودٌ يلد صغاره"},{"id":"c","text":"نباتٌ يُزهر"},{"id":"d","text":"لا يتكاثر"}]'::jsonb, 'b', 'البقرة تلد صغارها حيّة وتُرضعها الحليب، فهي حيوانٌ ولودٌ من الثدييّات.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24e6b9ea-7e4c-5cfa-8611-4132cc792c55', 'b4e13aeb-1d88-5a7d-b66e-faa404fa35eb', 'الدجاجة تتكاثر بأن:', '[{"id":"a","text":"تلد كتكوتًا حيًّا"},{"id":"b","text":"تُزهر ثمّ تُثمر"},{"id":"c","text":"تنقسم إلى دجاجتين"},{"id":"d","text":"تضع بيضًا يخرج منه الكتكوت"}]'::jsonb, 'd', 'الدجاجة حيوانٌ بيوضٌ تضع بيضًا، وبعد الحضانة يخرج الكتكوت من البيضة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0fcc6d41-5d2b-57e4-afe6-3a2e136604da', 'b4e13aeb-1d88-5a7d-b66e-faa404fa35eb', 'الكتكوت الصغير عندما ينمو ويكبر يصبح:', '[{"id":"a","text":"بقرةً"},{"id":"b","text":"بذرةً"},{"id":"c","text":"دجاجةً"},{"id":"d","text":"سمكةً"}]'::jsonb, 'c', 'الصغير ينمو حتّى يصبح بالغًا مثل والديه، فالكتكوت يصير دجاجة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('308926e6-b51d-5042-8f5f-84f088e093bf', '06e7a563-9ae6-56c5-ace2-7f8233bd3080', 'eveil-scientifique-3eme', '⭐ تمرين: أتعرّف على التكاثر والنموّ', 1, 50, 10, 'practice', 'admin', 1)
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
  ('e2dcdc4b-c620-5d2e-afb3-6e4e4fc66d50', '308926e6-b51d-5042-8f5f-84f088e093bf', 'من أيّ جزءٍ من النبات تتكوّن الثمرة؟', '[{"id":"a","text":"من الجذر"},{"id":"b","text":"من الزهرة"},{"id":"c","text":"من الورقة"},{"id":"d","text":"من الساق"}]'::jsonb, 'b', 'من الزهرة تتكوّن الثمرة، وفي الثمرة توجد البذور.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ac6de74-ce32-5faf-b683-de08413f23d1', '308926e6-b51d-5042-8f5f-84f088e093bf', 'ماذا يوجد داخل الثمرة؟', '[{"id":"a","text":"بذورٌ (حبوب)"},{"id":"b","text":"ريش"},{"id":"c","text":"حليب"},{"id":"d","text":"رمل"}]'::jsonb, 'a', 'داخل الثمرة توجد البذور (الحبوب)، ومنها تنبت نباتاتٌ جديدة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd5ae9d1-0eb3-55ad-ac44-66c91851b80a', '308926e6-b51d-5042-8f5f-84f088e093bf', 'ماذا نزرع في التربة لتنبت نبتةٌ جديدة؟', '[{"id":"a","text":"ورقةً"},{"id":"b","text":"حجرًا"},{"id":"c","text":"بذرةً"},{"id":"d","text":"ريشةً"}]'::jsonb, 'c', 'نزرع البذرة في التربة فتنبت وتعطي نبتةً جديدة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('468f76cb-e65d-514e-a50e-c0902d3824ea', '308926e6-b51d-5042-8f5f-84f088e093bf', 'كيف تحصل الدجاجة على كتاكيت؟', '[{"id":"a","text":"تلد كتكوتًا حيًّا"},{"id":"b","text":"تُزهر"},{"id":"c","text":"تشرب الحليب"},{"id":"d","text":"تضع بيضًا يخرج منه الكتكوت"}]'::jsonb, 'd', 'الدجاجة حيوانٌ بيوضٌ تضع بيضًا، وبعد الحضانة يخرج منه الكتكوت.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14837f2d-5ade-5355-8137-4d2a5555b17c', '308926e6-b51d-5042-8f5f-84f088e093bf', 'من أين يخرج الكتكوت؟ <svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="110" fill="#fff8e6" stroke="#e0a400" stroke-width="2"/><g stroke="#5a3210" stroke-width="2"><path d="M70 38 l8 -8 l6 8 l8 -8 l6 8 l8 -8 l4 8 z" fill="#fdf3d6"/><path d="M70 84 l8 8 l6 -8 l8 8 l6 -8 l8 8 l4 -8 z" fill="#fdf3d6"/><circle cx="100" cy="61" r="20" fill="#ffd23f"/><path d="M118 59 l10 -3 l-9 8 z" fill="#e0533a"/></g><circle cx="106" cy="55" r="3" fill="#1f2937" stroke="none"/></svg>', '[{"id":"a","text":"من البيضة"},{"id":"b","text":"من الزهرة"},{"id":"c","text":"من البذرة"},{"id":"d","text":"من الماء"}]'::jsonb, 'a', 'الصورة كتكوتٌ أصفر يخرج من قشرة البيضة المكسورة، فالكتكوت يخرج من البيضة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4dfc9d9-58db-5da7-a417-4c51bd0c0764', '308926e6-b51d-5042-8f5f-84f088e093bf', 'الكتكوت عندما يكبر يصبح:', '[{"id":"a","text":"بقرةً"},{"id":"b","text":"بذرةً"},{"id":"c","text":"دجاجةً"},{"id":"d","text":"سمكةً"}]'::jsonb, 'c', 'ينمو الكتكوت ويكبر حتّى يصبح دجاجةً مثل أمّه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7cb680ff-de36-590d-b632-a17fe212c918', '06e7a563-9ae6-56c5-ace2-7f8233bd3080', 'eveil-scientifique-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد التكاثر', 3, 120, 30, 'boss', 'admin', 2)
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
  ('1d084c95-5493-5376-897a-e532d63024f3', '7cb680ff-de36-590d-b632-a17fe212c918', 'ما الترتيب الصحيح لدورة التكاثر عند النبات الزهري؟', '[{"id":"a","text":"بذرة ← زهرة ← ثمرة ← نبتة"},{"id":"b","text":"ثمرة ← زهرة ← بذرة ← نبتة"},{"id":"c","text":"زهرة ← ثمرة ← بذرة ← نبتة جديدة"},{"id":"d","text":"نبتة ← بذرة ← زهرة ← ثمرة"}]'::jsonb, 'c', 'الترتيب الصحيح: زهرة ← ثمرة ← بذرة ← نبتة جديدة. الخطأ الشائع هو تقديم البذرة على الزهرة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb428f67-fe60-5f81-bb24-620a827935e9', '7cb680ff-de36-590d-b632-a17fe212c918', 'القطّة تلد صغارها وتُرضعها الحليب، والدجاجة تضع بيضًا. ماذا نستنتج؟', '[{"id":"a","text":"كلّ الحيوانات تضع بيضًا"},{"id":"b","text":"بعض الحيوانات ولودة وبعضها بيوضة"},{"id":"c","text":"كلّ الحيوانات تلد صغارها"},{"id":"d","text":"القطّة والدجاجة لا تتكاثران"}]'::jsonb, 'b', 'القطّة ولودة والدجاجة بيوضة، فبعض الحيوانات ولودة وبعضها بيوضة. الخطأ الشائع هو الظنّ أنّ كلّ الحيوانات تتكاثر بالطريقة نفسها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('502274c6-7b13-5576-9a25-11bc19f011d1', '7cb680ff-de36-590d-b632-a17fe212c918', 'أيّ مجموعةٍ كلّها حيواناتٌ بيوضةٌ تضع البيض؟', '[{"id":"a","text":"البقرة، القطّة، الكلب"},{"id":"b","text":"البقرة، العصفور، الكلب"},{"id":"c","text":"الإنسان، القطّة، البقرة"},{"id":"d","text":"الدجاجة، العصفور، السمك"}]'::jsonb, 'd', 'الدجاجة والعصفور والسمك كلّها بيوضةٌ تضع البيض. الخطأ الشائع هو إدراج البقرة أو القطّة وهي ولودة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca62f54f-c1bb-5b96-8c26-e5c33147c116', '7cb680ff-de36-590d-b632-a17fe212c918', 'لماذا تُعدّ البقرة حيوانًا ولودًا لا بيوضًا؟', '[{"id":"a","text":"لأنّها تلد عِجلًا حيًّا وتُرضعه الحليب"},{"id":"b","text":"لأنّها تضع بيضًا كبيرًا"},{"id":"c","text":"لأنّها تُزهر في الربيع"},{"id":"d","text":"لأنّها تعيش في الماء"}]'::jsonb, 'a', 'البقرة تلد عِجلًا حيًّا وتُرضعه الحليب، وهذا تكاثرٌ ولودٌ لا بيضيّ. الخطأ الشائع هو الظنّ أنّها تضع بيضًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('502aa0b5-2d9d-5c82-942a-4cf3dbc64f71', '7cb680ff-de36-590d-b632-a17fe212c918', 'زرعنا بذرةً في التربة. ماذا يحدث لها مع الوقت؟', '[{"id":"a","text":"تبقى بذرةً ولا تتغيّر أبدًا"},{"id":"b","text":"تنبت وتعطي نبتةً جديدةً تكبر"},{"id":"c","text":"تتحوّل إلى بيضة"},{"id":"d","text":"تصبح حيوانًا"}]'::jsonb, 'b', 'تنبت البذرة في التربة وتعطي نبتةً جديدةً تنمو وتكبر. الخطأ الشائع هو الظنّ أنّ البذرة تبقى بلا تغيّر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ca3fee0-12c1-597f-8834-595ebdfb1254', '7cb680ff-de36-590d-b632-a17fe212c918', 'ما القاسم المشترك بين الكتكوت والعِجل والنبتة الصغيرة؟', '[{"id":"a","text":"كلّها تخرج من بيض"},{"id":"b","text":"كلّها تطير"},{"id":"c","text":"كلّها نباتات"},{"id":"d","text":"كلّها تنمو حتّى تصبح بالغةً مثل والديها"}]'::jsonb, 'd', 'الكتكوت والعِجل والنبتة كلّها صغيرةٌ تنمو حتّى تصبح بالغةً مثل والديها. الخطأ الشائع هو الظنّ أنّ كلّها تخرج من بيض.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('814c8c8d-f22d-50cf-989d-9f414f4e0e59', '06e7a563-9ae6-56c5-ace2-7f8233bd3080', 'eveil-scientifique-3eme', '⭐⭐ تمرين مراجعة: التكاثر عند النبات والحيوان', 2, 75, 15, 'practice', 'admin', 3)
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
  ('a13bf184-3324-592f-ad2c-4192e09e2f00', '814c8c8d-f22d-50cf-989d-9f414f4e0e59', 'عضو التكاثر عند النبات هو:', '[{"id":"a","text":"الزهرة"},{"id":"b","text":"الجذر"},{"id":"c","text":"الورقة"},{"id":"d","text":"الساق"}]'::jsonb, 'a', 'الزهرة هي عضو التكاثر عند النبات؛ منها تتكوّن الثمرة والبذور.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce3f3f09-efff-5fec-be51-f2922f065d5c', '814c8c8d-f22d-50cf-989d-9f414f4e0e59', 'أيّ هذه حيوانٌ ولودٌ يلد صغاره؟', '[{"id":"a","text":"الدجاجة"},{"id":"b","text":"العصفور"},{"id":"c","text":"السمكة"},{"id":"d","text":"القطّة"}]'::jsonb, 'd', 'القطّة حيوانٌ ولودٌ تلد صغارها وتُرضعها الحليب، أمّا الدجاجة والعصفور والسمكة فبيوضة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07097a64-81db-52fc-abd1-e47666a95150', '814c8c8d-f22d-50cf-989d-9f414f4e0e59', 'ماذا يخرج من بيضة الدجاجة بعد الحضانة؟', '[{"id":"a","text":"عِجلٌ"},{"id":"b","text":"كتكوتٌ"},{"id":"c","text":"بذرةٌ"},{"id":"d","text":"زهرةٌ"}]'::jsonb, 'b', 'من بيضة الدجاجة يخرج الكتكوت بعد مدّة الحضانة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a21237fd-75af-5b7b-a178-ec7a2eaf4a50', '814c8c8d-f22d-50cf-989d-9f414f4e0e59', 'العِجل عندما ينمو ويكبر يصبح:', '[{"id":"a","text":"دجاجةً"},{"id":"b","text":"كتكوتًا"},{"id":"c","text":"بقرةً"},{"id":"d","text":"نبتةً"}]'::jsonb, 'c', 'ينمو العِجل ويكبر حتّى يصبح بقرةً مثل أمّه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f51af09-e8df-5ec1-b2cf-ae8861921a0a', '814c8c8d-f22d-50cf-989d-9f414f4e0e59', 'ماذا يوجد داخل هذه الثمرة الحمراء؟ <svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="110" fill="#eaf7ef" stroke="#3aae6a" stroke-width="2"/><g stroke="#a0331f" stroke-width="2"><circle cx="100" cy="58" r="34" fill="#e0533a"/></g><g stroke="#5a3210" stroke-width="2"><ellipse cx="90" cy="55" rx="6" ry="9" fill="#7a4a18"/><ellipse cx="110" cy="55" rx="6" ry="9" fill="#7a4a18"/><ellipse cx="100" cy="70" rx="6" ry="9" fill="#7a4a18"/></g><g stroke="#2c6e3f" stroke-width="2"><path d="M100 24 q6 -8 0 -12" fill="none"/></g></svg>', '[{"id":"a","text":"ريشٌ"},{"id":"b","text":"حليبٌ"},{"id":"c","text":"ماءٌ مالح"},{"id":"d","text":"بذورٌ"}]'::jsonb, 'd', 'الصورة ثمرةٌ حمراء داخلها بذورٌ بنّيّة، ففي الثمرة توجد البذور.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7718e900-c461-5077-aeea-d97ad4c153f7', '814c8c8d-f22d-50cf-989d-9f414f4e0e59', 'أيّ عبارةٍ صحيحة؟', '[{"id":"a","text":"الكائن الحيّ يولد ثمّ ينمو ثمّ يتكاثر"},{"id":"b","text":"كلّ الحيوانات تضع بيضًا"},{"id":"c","text":"البقرة تخرج من بيضة"},{"id":"d","text":"البذرة لا تنبت أبدًا"}]'::jsonb, 'a', 'دورة الحياة: الكائن الحيّ يولد ثمّ ينمو ثمّ يتكاثر بدوره.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cf9127ba-01a9-5b5b-baca-033b74f63e57', '06e7a563-9ae6-56c5-ace2-7f8233bd3080', 'eveil-scientifique-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل التكاثر والنموّ', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('b4508a9d-6c7e-5c45-b829-460faf480112', 'cf9127ba-01a9-5b5b-baca-033b74f63e57', 'وجد طفلٌ ثمرةً وفتحها فرأى بداخلها حبوبًا صغيرة. ماذا تكون هذه الحبوب؟', '[{"id":"a","text":"زهورٌ صغيرة"},{"id":"b","text":"بيضٌ صغير"},{"id":"c","text":"قطراتُ حليب"},{"id":"d","text":"بذورٌ تنبت منها نباتاتٌ جديدة"}]'::jsonb, 'd', 'الحبوب داخل الثمرة هي البذور، وإذا زُرعت نبتت منها نباتاتٌ جديدة. الخطأ الشائع هو الخلط بين البذرة والبيضة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3c29088-e94c-52b5-aa75-6e867f3a76ac', 'cf9127ba-01a9-5b5b-baca-033b74f63e57', 'حيوانٌ يضع بيضًا ويعيش قرب الماء، ويخرج من بيضه صغارٌ ثمّ تكبر. ما هو من هؤلاء؟', '[{"id":"a","text":"البقرة"},{"id":"b","text":"القطّة"},{"id":"c","text":"الضّفدع"},{"id":"d","text":"الكلب"}]'::jsonb, 'c', 'الضّفدع حيوانٌ بيوضٌ يضع بيضه قرب الماء. الخطأ الشائع هو اختيار البقرة أو القطّة أو الكلب وهي ولودة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db3bb2fa-9758-5d90-b909-eef4bfd82645', 'cf9127ba-01a9-5b5b-baca-033b74f63e57', 'لماذا نقول إنّ الإنسان حيوانٌ ولودٌ وليس بيوضًا؟', '[{"id":"a","text":"لأنّ الأمّ تلد طفلًا حيًّا وتُرضعه الحليب"},{"id":"b","text":"لأنّ الإنسان يضع بيضًا في عشّ"},{"id":"c","text":"لأنّ الإنسان يُزهر ويُثمر"},{"id":"d","text":"لأنّ الإنسان ينبت من بذرة"}]'::jsonb, 'a', 'الأمّ تلد طفلًا حيًّا وتُرضعه الحليب، فالإنسان من الثدييّات الولودة. الخطأ الشائع هو الظنّ أنّه يضع بيضًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d0d29ec7-0a91-5f36-86eb-db0b4e37ad86', 'cf9127ba-01a9-5b5b-baca-033b74f63e57', 'رتّب مراحل حياة الدجاجة من البداية: (1) دجاجة بالغة (2) بيضة (3) كتكوت صغير.', '[{"id":"a","text":"كتكوت ← بيضة ← دجاجة"},{"id":"b","text":"بيضة ← كتكوت ← دجاجة"},{"id":"c","text":"دجاجة ← كتكوت ← بيضة"},{"id":"d","text":"كتكوت ← دجاجة ← بيضة"}]'::jsonb, 'b', 'الترتيب الصحيح: بيضة ← كتكوت ← دجاجة، فالصغير ينمو حتّى يصبح بالغًا. الخطأ الشائع هو البدء بالكتكوت قبل البيضة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db861bbd-0e0d-59fb-b646-5ff668581393', 'cf9127ba-01a9-5b5b-baca-033b74f63e57', 'في الصورة أمٌّ وصغيرها. كيف يتكاثر هذا الحيوان؟ <svg viewBox="0 0 220 110" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="88" width="220" height="22" fill="#86c34a" stroke="#2f6b12" stroke-width="2"/><g stroke="#5a3210" stroke-width="2"><ellipse cx="70" cy="52" rx="40" ry="24" fill="#b87333"/><circle cx="30" cy="44" r="14" fill="#b87333"/><path d="M21 34 l-5 -8 l8 4 z" fill="#8a5424"/><line x1="54" y1="74" x2="54" y2="88"/><line x1="90" y1="74" x2="90" y2="88"/></g><circle cx="25" cy="42" r="2.5" fill="#1f2937" stroke="none"/><g stroke="#5a3210" stroke-width="2"><ellipse cx="165" cy="68" rx="24" ry="14" fill="#d49a6a"/><circle cx="141" cy="62" r="9" fill="#d49a6a"/><line x1="155" y1="80" x2="155" y2="88"/><line x1="178" y1="80" x2="178" y2="88"/></g><circle cx="137" cy="60" r="2.2" fill="#1f2937" stroke="none"/></svg>', '[{"id":"a","text":"يضع بيضًا يخرج منه صغير"},{"id":"b","text":"يُزهر ثمّ يُثمر"},{"id":"c","text":"يلد صغارًا حيّة ويُرضعها الحليب"},{"id":"d","text":"ينبت من بذرة"}]'::jsonb, 'c', 'الصورة بقرةٌ مع عِجلها، وهي حيوانٌ ولودٌ تلد صغارها وتُرضعها الحليب. الخطأ الشائع هو الظنّ أنّها تضع بيضًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c0c5d270-90ab-5d4d-a8d2-2ce4e0ed050b', 'cf9127ba-01a9-5b5b-baca-033b74f63e57', 'أيّ استنتاجٍ صحيحٍ عن الكائنات الحيّة؟', '[{"id":"a","text":"الكائنات الحيّة لا تتكاثر"},{"id":"b","text":"كلّ كائنٍ حيٍّ يولد وينمو ثمّ يتكاثر فيعطي كائناتٍ جديدة"},{"id":"c","text":"كلّ الحيوانات تضع بيضًا"},{"id":"d","text":"النبات لا يعطي بذورًا"}]'::jsonb, 'b', 'كلّ كائنٍ حيٍّ يولد وينمو ثمّ يتكاثر فيعطي كائناتٍ جديدةً مثله. الخطأ الشائع هو تعميم وضع البيض على كلّ الحيوانات.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cdc4c5a3-bf77-58d5-a948-a2fdfafb5209', '06e7a563-9ae6-56c5-ace2-7f8233bd3080', 'eveil-scientifique-3eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للتكاثر والنموّ', 3, 120, 30, 'boss', 'admin', 5)
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
  ('b583f8ff-1124-57f7-8ac7-f3949d191512', 'cdc4c5a3-bf77-58d5-a948-a2fdfafb5209', 'الحيوان الذي يضع بيضًا اسمه حيوانٌ:', '[{"id":"a","text":"ولودٌ"},{"id":"b","text":"بيوضٌ"},{"id":"c","text":"نباتيٌّ"},{"id":"d","text":"مائيٌّ فقط"}]'::jsonb, 'b', 'الحيوان الذي يضع بيضًا اسمه بيوضٌ، مثل الدجاجة والعصفور.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e55ee53-2e0f-557c-9ee7-dff220632570', 'cdc4c5a3-bf77-58d5-a948-a2fdfafb5209', 'البقرة والقطّة والكلب تتكاثر بأن:', '[{"id":"a","text":"تلد صغارًا حيّة"},{"id":"b","text":"تضع بيضًا"},{"id":"c","text":"تُزهر"},{"id":"d","text":"تنبت من بذور"}]'::jsonb, 'a', 'البقرة والقطّة والكلب حيواناتٌ ولودةٌ تلد صغارها حيّة وتُرضعها الحليب.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2934d457-d2a8-549c-aaa9-f779a830fdf7', 'cdc4c5a3-bf77-58d5-a948-a2fdfafb5209', 'أيّ زوجٍ صحيحٌ بين الصغير والبالغ؟', '[{"id":"a","text":"الكتكوت ← بقرة"},{"id":"b","text":"العِجل ← دجاجة"},{"id":"c","text":"البذرة ← بيضة"},{"id":"d","text":"العِجل ← بقرة"}]'::jsonb, 'd', 'العِجل ينمو فيصبح بقرة. أمّا الكتكوت فيصبح دجاجةً والبذرة تصبح نبتة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2946db38-ad8d-5a80-bb7a-4ee936f8b53c', 'cdc4c5a3-bf77-58d5-a948-a2fdfafb5209', 'أيّ هذه ليس من مراحل دورة التكاثر عند النبات؟', '[{"id":"a","text":"الزهرة"},{"id":"b","text":"الثمرة"},{"id":"c","text":"البيضة"},{"id":"d","text":"البذرة"}]'::jsonb, 'c', 'دورة النبات هي زهرة ← ثمرة ← بذرة ← نبتة؛ والبيضة تخصّ الحيوانات البيوضة لا النبات.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa0a0a61-7940-5893-b99f-316d932518f3', 'cdc4c5a3-bf77-58d5-a948-a2fdfafb5209', 'وضعنا بيضةً دافئةً في حضّانة. ما الذي قد يخرج منها بعد مدّة؟', '[{"id":"a","text":"كتكوتٌ صغير"},{"id":"b","text":"نبتةٌ خضراء"},{"id":"c","text":"عِجلٌ"},{"id":"d","text":"زهرةٌ"}]'::jsonb, 'a', 'البيضة الدافئة في الحضانة يخرج منها كتكوتٌ صغير. الخطأ الشائع هو الظنّ أنّ النبتة أو العِجل يخرج من البيضة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad361f13-6bc3-5b49-9495-bf4af30d626e', 'cdc4c5a3-bf77-58d5-a948-a2fdfafb5209', 'أيّ عبارةٍ **خاطئة**؟', '[{"id":"a","text":"الدجاجة تضع بيضًا"},{"id":"b","text":"البقرة تلد عِجلًا حيًّا"},{"id":"c","text":"من الزهرة تتكوّن الثمرة"},{"id":"d","text":"القطّة تضع بيضًا في عشّ"}]'::jsonb, 'd', 'العبارة الخاطئة أنّ القطّة تضع بيضًا؛ فالقطّة ولودةٌ تلد صغارها. الخطأ الشائع هو تعميم وضع البيض على الثدييّات.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ba3b6477-bcad-5f38-a584-a2517217a506', 'dcbdca56-05f5-53b6-b86f-eae4775f02d1', 'eveil-scientifique-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('838c0e55-17a2-54ee-9eb4-1a1c408708de', 'ba3b6477-bcad-5f38-a584-a2517217a506', 'ماذا يحدث في الشهيق؟', '[{"id":"a","text":"يخرج الهواء وينخفض الصدر"},{"id":"b","text":"نتوقّف عن التنفّس"},{"id":"c","text":"يدخل الهواء إلى الرئتين ويرتفع الصدر"},{"id":"d","text":"لا يتحرّك الصدر أبدًا"}]'::jsonb, 'c', 'في الشهيق يدخل الهواء إلى الرئتين فيرتفع القفص الصدري ويتمدّد.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a38e340-c7cc-55ef-a80f-54e3c27453e6', 'ba3b6477-bcad-5f38-a584-a2517217a506', 'ماذا يحدث للقفص الصدري في الزفير؟', '[{"id":"a","text":"يرتفع ويتمدّد"},{"id":"b","text":"ينخفض ويصغر"},{"id":"c","text":"يمتلئ بالماء"},{"id":"d","text":"يبقى ثابتًا لا يتغيّر"}]'::jsonb, 'b', 'في الزفير يخرج الهواء من الرئتين فينخفض القفص الصدري ويعود صغيرًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e20eb246-e4ed-5938-8f3b-28417a820dcf', 'ba3b6477-bcad-5f38-a584-a2517217a506', 'من أين الأفضل أن نتنفّس للمحافظة على صحّتنا؟', '[{"id":"a","text":"من الفم دائمًا"},{"id":"b","text":"من الأذنين"},{"id":"c","text":"من العينين"},{"id":"d","text":"من الأنف"}]'::jsonb, 'd', 'الأفضل التنفّس من الأنف لأنّه ينقّي الهواء ويدفّئه قبل وصوله إلى الرئتين.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb57eb28-694b-509e-8cbe-ecc26de17acf', 'ba3b6477-bcad-5f38-a584-a2517217a506', 'متى يصبح تنفّسنا أسرع؟', '[{"id":"a","text":"بعد الجري وبذل المجهود"},{"id":"b","text":"أثناء النوم العميق"},{"id":"c","text":"عندما نجلس بهدوء"},{"id":"d","text":"عندما نقرأ كتابًا"}]'::jsonb, 'a', 'بعد الجري والمجهود نتنفّس أسرع لأنّ الجسم يحتاج إلى هواءٍ أكثر.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12382dd7-ec19-53d5-afd4-9b948f8f0bb5', 'ba3b6477-bcad-5f38-a584-a2517217a506', 'أيّ هواءٍ مفيدٌ لرئتينا؟', '[{"id":"a","text":"الهواء المملوء بالدخان"},{"id":"b","text":"الهواء النقيّ النظيف"},{"id":"c","text":"هواء الأماكن الملوّثة"},{"id":"d","text":"الهواء المملوء بالغبار"}]'::jsonb, 'b', 'الهواء النقيّ النظيف مفيدٌ لرئتينا، أمّا الهواء الملوّث بالدخان فمضرٌّ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0265bdf5-50ff-5e90-a80f-254af46d2e03', 'dcbdca56-05f5-53b6-b86f-eae4775f02d1', 'eveil-scientifique-3eme', '⭐ تمرين: أتعرّف على التنفّس', 1, 50, 10, 'practice', 'admin', 1)
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
  ('c5ce09c3-3205-5fc6-bffd-94caf0aff2dd', '0265bdf5-50ff-5e90-a80f-254af46d2e03', 'إلى أين يصل الهواء عندما نتنفّس؟', '[{"id":"a","text":"إلى الرئتين"},{"id":"b","text":"إلى المعدة"},{"id":"c","text":"إلى القلب وحده"},{"id":"d","text":"إلى العينين"}]'::jsonb, 'a', 'يدخل الهواء من الأنف إلى القصبة الهوائية ثمّ يصل إلى الرئتين.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('344a22ad-dfe7-5a62-a7dc-db16066ff1a8', '0265bdf5-50ff-5e90-a80f-254af46d2e03', 'في الشهيق، الهواء:', '[{"id":"a","text":"يخرج من الرئتين"},{"id":"b","text":"يبقى خارج الجسم"},{"id":"c","text":"يدخل إلى الرئتين"},{"id":"d","text":"يتحوّل إلى ماء"}]'::jsonb, 'c', 'في الشهيق يدخل الهواء إلى الرئتين فيرتفع القفص الصدري.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bfe6a6b7-76df-535e-8ef0-545edbb30c5f', '0265bdf5-50ff-5e90-a80f-254af46d2e03', 'في الزفير، القفص الصدري:', '[{"id":"a","text":"يرتفع ويتمدّد"},{"id":"b","text":"ينخفض ويصغر"},{"id":"c","text":"يختفي"},{"id":"d","text":"يمتلئ بالطعام"}]'::jsonb, 'b', 'في الزفير يخرج الهواء فينخفض القفص الصدري ويعود صغيرًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4aca7167-c614-5e53-a276-2296e1a3fd64', '0265bdf5-50ff-5e90-a80f-254af46d2e03', 'من أين الأفضل أن نتنفّس؟', '[{"id":"a","text":"من الفم"},{"id":"b","text":"من الأذن"},{"id":"c","text":"من العين"},{"id":"d","text":"من الأنف"}]'::jsonb, 'd', 'الأفضل التنفّس من الأنف لأنّه ينقّي الهواء قبل وصوله إلى الرئتين.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad2a3512-17ac-5615-b5d2-855e4d8059c4', '0265bdf5-50ff-5e90-a80f-254af46d2e03', 'ماذا نفعل لكي يصبح هواء الغرفة نقيًّا؟', '[{"id":"a","text":"نُشعل النار فيها"},{"id":"b","text":"نغلق كلّ النوافذ دائمًا"},{"id":"c","text":"نفتح النوافذ ونهوّيها"},{"id":"d","text":"نملؤها بالدخان"}]'::jsonb, 'c', 'تهوية الغرفة بفتح النوافذ تجدّد هواءها وتجعله نقيًّا ومفيدًا للتنفّس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('999910a1-261e-588c-9500-19714e7d294d', '0265bdf5-50ff-5e90-a80f-254af46d2e03', 'في الصورة، ما الحركة التي يقوم بها الصدر؟ <svg viewBox="0 0 200 120" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="120" fill="#ffffff" stroke="#7fb8d6" stroke-width="2"/><g stroke="#1f2937" stroke-width="2"><ellipse cx="90" cy="65" rx="46" ry="40" fill="#cdeafd"/><path d="M68 68 q22 -16 44 0 q-22 16 -44 0 z" fill="#e0533a"/><path d="M150 80 l0 -44 l-10 14 m10 -14 l10 14" fill="none" stroke="#3aae6a" stroke-width="4"/></g></svg>', '[{"id":"a","text":"شهيق: الهواء يدخل والصدر يرتفع"},{"id":"b","text":"زفير: الهواء يخرج والصدر ينخفض"},{"id":"c","text":"الصدر يمتلئ بالماء"},{"id":"d","text":"الصدر لا يتحرّك"}]'::jsonb, 'a', 'السهم الأخضر يشير إلى الأعلى والصدر منتفخ، فهذه حركة الشهيق: الهواء يدخل والصدر يرتفع.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('27b946d0-27e6-5f18-a24b-d563625cf214', 'dcbdca56-05f5-53b6-b86f-eae4775f02d1', 'eveil-scientifique-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد التنفّس', 3, 120, 30, 'boss', 'admin', 2)
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
  ('fec0283a-b4df-5b7e-af48-fb6bbf85380f', '27b946d0-27e6-5f18-a24b-d563625cf214', 'بعد سباق الجري نلهث ويتسارع تنفّسنا. ماذا نستنتج؟', '[{"id":"a","text":"نتوقّف عن التنفّس بعد الجري"},{"id":"b","text":"سرعة التنفّس لا تتغيّر أبدًا"},{"id":"c","text":"نتنفّس أبطأ بعد المجهود"},{"id":"d","text":"نتنفّس أسرع بعد المجهود لأنّ الجسم يحتاج هواءً أكثر"}]'::jsonb, 'd', 'بعد المجهود يحتاج الجسم هواءً أكثر فيتسارع التنفّس. الخطأ الشائع هو الظنّ أنّ سرعة التنفّس ثابتة دائمًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e954d5b8-a8d1-54f8-9bd7-8a76576cf732', '27b946d0-27e6-5f18-a24b-d563625cf214', 'أيّ زوجٍ صحيحٌ بين الحركة وما يحدث للصدر؟', '[{"id":"a","text":"الشهيق ← الصدر يرتفع"},{"id":"b","text":"الشهيق ← الصدر ينخفض"},{"id":"c","text":"الزفير ← الصدر يرتفع"},{"id":"d","text":"الزفير ← الصدر يمتلئ بالماء"}]'::jsonb, 'a', 'في الشهيق يدخل الهواء فيرتفع الصدر. الخطأ الشائع هو الخلط بين الحركتين: الزفير ينخفض فيه الصدر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e886ae1-baf1-5dff-84a7-6ee2f4779fc4', '27b946d0-27e6-5f18-a24b-d563625cf214', 'طفلٌ يلعب في مكانٍ مليءٍ بالغبار ويتنفّس من فمه. ما النصيحة الأفضل له؟', '[{"id":"a","text":"أن يبقى ويتنفّس من فمه"},{"id":"b","text":"أن يستنشق الدخان أكثر"},{"id":"c","text":"أن يبتعد ويتنفّس من أنفه في هواءٍ نقيّ"},{"id":"d","text":"أن يتوقّف عن التنفّس"}]'::jsonb, 'c', 'الأفضل الابتعاد عن الغبار والتنفّس من الأنف في هواءٍ نقيّ. الخطأ الشائع هو ظنّ أنّ الهواء المغبرّ عاديّ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da390d18-1a12-578a-a5eb-bc5a15cf857a', '27b946d0-27e6-5f18-a24b-d563625cf214', 'لماذا ننصح بغرس الأشجار قرب البيوت والمدارس؟', '[{"id":"a","text":"لأنّها تلوّث الهواء"},{"id":"b","text":"لأنّها تنقّي الهواء وتجعله أفضل للتنفّس"},{"id":"c","text":"لأنّها تُخرج الدخان"},{"id":"d","text":"لأنّها تمنع التنفّس"}]'::jsonb, 'b', 'الأشجار تنقّي الهواء فتجعله نقيًّا ومفيدًا للتنفّس. الخطأ الشائع هو الظنّ أنّها تلوّث الهواء مثل المصانع.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80a3c039-145f-53c9-995d-57b7c68375db', '27b946d0-27e6-5f18-a24b-d563625cf214', 'أيّ عبارةٍ صحيحةٌ عن التنفّس؟', '[{"id":"a","text":"التنفّس مستمرٌّ ولا نتوقّف عنه بإرادتنا مدّةً طويلة"},{"id":"b","text":"يمكننا أن نتوقّف عن التنفّس طوال اليوم"},{"id":"c","text":"نتنفّس فقط عندما نأكل"},{"id":"d","text":"نتنفّس بالعينين"}]'::jsonb, 'a', 'التنفّس حركةٌ مستمرّةٌ منتظمة لا نتوقّف عنها بإرادتنا. الخطأ الشائع هو الظنّ أنّنا نستطيع التوقّف عن التنفّس متى شئنا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce2896dc-62d0-5f0e-bb1b-6367c755ee6b', '27b946d0-27e6-5f18-a24b-d563625cf214', 'تأمّل الصورة: شجرةٌ على اليسار ومصنعٌ يُخرج دخانًا على اليمين. أيّ استنتاجٍ صحيح؟ <svg viewBox="0 0 240 130" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="240" height="130" fill="#ffffff" stroke="#7fb8d6" stroke-width="2"/><rect x="0" y="108" width="240" height="22" fill="#86c34a" stroke="#2f6b12" stroke-width="2"/><g stroke="#2f6b12" stroke-width="2"><rect x="44" y="72" width="8" height="36" fill="#8a5a2b" stroke="#5a3210"/><circle cx="48" cy="58" r="26" fill="#3aae6a"/></g><g stroke="#1f2937" stroke-width="2"><rect x="150" y="74" width="50" height="34" fill="#b0563a"/><rect x="182" y="52" width="12" height="24" fill="#7a3f2a"/><path d="M188 52 q-16 -12 -4 -24 q-12 -2 -2 -14" fill="none" stroke="#555b61" stroke-width="6"/></g></svg>', '[{"id":"a","text":"هواء الشجرة ملوّث وهواء المصنع نقيّ"},{"id":"b","text":"الهواء حول الاثنين متشابه"},{"id":"c","text":"كلاهما يلوّث الهواء"},{"id":"d","text":"هواء الشجرة نقيٌّ وهواء المصنع ملوّثٌ بالدخان"}]'::jsonb, 'd', 'الشجرة تنقّي الهواء فيكون نقيًّا، أمّا دخان المصنع فيلوّثه. الخطأ الشائع هو الخلط بينهما أو ظنّ هواء المصنع نقيًّا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bf374d4e-1234-5128-bedf-5a88eb8949ad', 'dcbdca56-05f5-53b6-b86f-eae4775f02d1', 'eveil-scientifique-3eme', '⭐⭐ تمرين مراجعة: حركتا التنفّس والهواء النقيّ', 2, 75, 15, 'practice', 'admin', 3)
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
  ('a3648561-4fad-5511-9f46-b5f1acb7e54a', 'bf374d4e-1234-5128-bedf-5a88eb8949ad', 'في الشهيق، القفص الصدري:', '[{"id":"a","text":"ينخفض"},{"id":"b","text":"يرتفع"},{"id":"c","text":"يختفي"},{"id":"d","text":"يمتلئ بالماء"}]'::jsonb, 'b', 'في الشهيق يدخل الهواء إلى الرئتين فيرتفع القفص الصدري ويتمدّد.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('833a203b-626a-5676-a899-a8761d7c91f1', 'bf374d4e-1234-5128-bedf-5a88eb8949ad', 'الهواء الملوّث الذي فيه دخانٌ وغبار:', '[{"id":"a","text":"مفيدٌ للرئتين"},{"id":"b","text":"ليس له أيّ تأثير"},{"id":"c","text":"أفضل من الهواء النقيّ"},{"id":"d","text":"مضرٌّ بجهازنا التنفّسي"}]'::jsonb, 'd', 'الهواء الملوّث فيه دخانٌ وغبارٌ وهو مضرٌّ بجهازنا التنفّسي وبصحّتنا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02079798-ac16-5254-bb74-21656eb19402', 'bf374d4e-1234-5128-bedf-5a88eb8949ad', 'كيف نتنفّس؟', '[{"id":"a","text":"بانتظام ليلًا ونهارًا دون توقّف"},{"id":"b","text":"مرّةً واحدةً في اليوم"},{"id":"c","text":"فقط عندما نجري"},{"id":"d","text":"فقط عندما نأكل"}]'::jsonb, 'a', 'نتنفّس بانتظام ليلًا ونهارًا، ونحن نلعب وننام، دون أن نتوقّف.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03caf658-e989-5d3e-8880-f0572f5bc223', 'bf374d4e-1234-5128-bedf-5a88eb8949ad', 'أيّ هذه ليس من قواعد التنفّس الصحّية؟', '[{"id":"a","text":"التنفّس من الأنف"},{"id":"b","text":"تهوية الغرف"},{"id":"c","text":"استنشاق الدخان"},{"id":"d","text":"غرس الأشجار"}]'::jsonb, 'c', 'استنشاق الدخان مضرٌّ وليس قاعدةً صحّية؛ بل نتجنّب الدخان ونتنفّس من الأنف هواءً نقيًّا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d40cd0c-d3a0-56d7-9757-332d25403383', 'bf374d4e-1234-5128-bedf-5a88eb8949ad', 'في الصورة طريق الهواء عند التنفّس. ما ترتيبه الصحيح من الأعلى؟ <svg viewBox="0 0 200 150" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="150" fill="#ffffff" stroke="#7fb8d6" stroke-width="2"/><g stroke="#1f2937" stroke-width="2"><circle cx="100" cy="26" r="16" fill="#f6c9a0"/><line x1="100" y1="42" x2="100" y2="74"/><path d="M84 78 q-22 16 -18 48 q2 22 18 24 q12 -26 12 -72 z" fill="#e0533a"/><path d="M116 78 q22 16 18 48 q-2 22 -18 24 q-12 -26 -12 -72 z" fill="#e0533a"/></g><g font-size="10" fill="#1f2937" stroke="none"><text x="118" y="30">الأنف</text><text x="104" y="64">القصبة</text><text x="58" y="120">الرئتان</text></g></svg>', '[{"id":"a","text":"الرئتان ← القصبة ← الأنف"},{"id":"b","text":"القصبة ← الأنف ← الرئتان"},{"id":"c","text":"الرئتان ← الأنف ← القصبة"},{"id":"d","text":"الأنف ← القصبة ← الرئتان"}]'::jsonb, 'd', 'يدخل الهواء من الأنف في الأعلى، ثمّ القصبة الهوائية، ثمّ يصل إلى الرئتين كما في الصورة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8da02554-203e-5de5-8b01-c746c7f2d33d', 'bf374d4e-1234-5128-bedf-5a88eb8949ad', 'أيّ عبارةٍ صحيحة؟', '[{"id":"a","text":"في الشهيق يخرج الهواء وينخفض الصدر"},{"id":"b","text":"في الزفير يخرج الهواء وينخفض الصدر"},{"id":"c","text":"التنفّس يكون من العينين"},{"id":"d","text":"الهواء الملوّث مفيدٌ للرئتين"}]'::jsonb, 'b', 'العبارة الصحيحة أنّ في الزفير يخرج الهواء من الرئتين فينخفض القفص الصدري.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7d2d4571-bb04-5301-9ba8-d13c3da0eb98', 'dcbdca56-05f5-53b6-b86f-eae4775f02d1', 'eveil-scientifique-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل التنفّس', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('4e8fcffe-f544-5004-98f7-237df576d8f1', '7d2d4571-bb04-5301-9ba8-d13c3da0eb98', 'أراد طفلٌ أن يحبس نفسه طوال الحصّة ليفوز بمسابقة. لماذا لن يستطيع؟', '[{"id":"a","text":"لأنّه يتنفّس من العينين"},{"id":"b","text":"لأنّ التنفّس يحدث مرّةً في اليوم فقط"},{"id":"c","text":"لأنّ التنفّس مستمرٌّ ولا نتوقّف عنه بإرادتنا مدّةً طويلة"},{"id":"d","text":"لأنّه يحتاج إلى الأكل أوّلًا"}]'::jsonb, 'c', 'التنفّس حركةٌ مستمرّةٌ لا نتوقّف عنها بإرادتنا طويلًا. الخطأ الشائع هو الظنّ أنّنا نستطيع التوقّف عن التنفّس متى شئنا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4545dd08-0669-56fd-8186-2f83203284f5', '7d2d4571-bb04-5301-9ba8-d13c3da0eb98', 'عدّاءٌ وصل خطّ النهاية. كيف يكون تنفّسه مقارنةً بما قبل السباق؟', '[{"id":"a","text":"أسرع، لأنّ جسمه يحتاج إلى هواءٍ أكثر بعد المجهود"},{"id":"b","text":"أبطأ من المعتاد"},{"id":"c","text":"متوقّفٌ تمامًا"},{"id":"d","text":"لا يتغيّر إطلاقًا"}]'::jsonb, 'a', 'بعد المجهود يتسارع التنفّس لأنّ الجسم يحتاج هواءً أكثر. الخطأ الشائع هو الظنّ أنّ سرعة التنفّس لا تتغيّر بعد الجري.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0692dac-77dd-5f90-8aff-d7800bf2292a', '7d2d4571-bb04-5301-9ba8-d13c3da0eb98', 'لماذا يُنصح بالتنفّس من الأنف لا من الفم؟', '[{"id":"a","text":"لأنّ الفم لا يصلح للأكل"},{"id":"b","text":"لأنّ الأنف يُخرج الدخان"},{"id":"c","text":"لأنّ التنفّس من الأنف يوقف القلب"},{"id":"d","text":"لأنّ الأنف ينقّي الهواء ويدفّئه قبل وصوله إلى الرئتين"}]'::jsonb, 'd', 'الأنف ينقّي الهواء ويدفّئه فيحمي الرئتين. الخطأ الشائع هو الظنّ أنّ التنفّس من الفم مثل التنفّس من الأنف.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9d74479-ed57-5a7b-918d-3e3387c176eb', '7d2d4571-bb04-5301-9ba8-d13c3da0eb98', 'مدينةٌ كثيرة المصانع وهواؤها مليءٌ بالدخان. ما الحلّ المناسب لتحسين هوائها؟', '[{"id":"a","text":"إغلاق كلّ النوافذ في البيوت"},{"id":"b","text":"غرس الأشجار وتقليل الدخان"},{"id":"c","text":"إشعال نارٍ أكثر"},{"id":"d","text":"التوقّف عن التنفّس في الخارج"}]'::jsonb, 'b', 'الأشجار تنقّي الهواء، وتقليل الدخان يحدّ من التلوّث. الخطأ الشائع هو ظنّ أنّ إغلاق النوافذ وحده ينقّي هواء المدينة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('88f33ab8-3370-5192-9127-2420683b1cc4', '7d2d4571-bb04-5301-9ba8-d13c3da0eb98', 'لاحظنا صدرًا يرتفع ثمّ ينخفض بانتظام. أيّ استنتاجٍ صحيح؟', '[{"id":"a","text":"الشهيق يرفع الصدر، والزفير يخفضه"},{"id":"b","text":"الشهيق يخفض الصدر، والزفير يرفعه"},{"id":"c","text":"الصدر لا علاقة له بالتنفّس"},{"id":"d","text":"الصدر يرتفع فقط ولا ينخفض أبدًا"}]'::jsonb, 'a', 'عند الشهيق يدخل الهواء فيرتفع الصدر، وعند الزفير يخرج الهواء فينخفض. الخطأ الشائع هو عكس الحركتين.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('386c96c5-0b4c-59ee-b480-cc044b8a828f', '7d2d4571-bb04-5301-9ba8-d13c3da0eb98', 'في الصورة صدرٌ صغيرٌ والسهم يتّجه إلى الأسفل. ما هذه الحركة؟ <svg viewBox="0 0 200 120" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="120" fill="#ffffff" stroke="#7fb8d6" stroke-width="2"/><g stroke="#1f2937" stroke-width="2"><ellipse cx="90" cy="66" rx="34" ry="42" fill="#cdeafd"/><path d="M74 70 q16 -12 32 0 q-16 12 -32 0 z" fill="#e0533a"/><path d="M150 40 l0 44 l-10 -14 m10 14 l10 -14" fill="none" stroke="#9aa3ad" stroke-width="4"/></g></svg>', '[{"id":"a","text":"شهيق: الهواء يدخل والصدر يرتفع"},{"id":"b","text":"الصدر يمتلئ بالماء"},{"id":"c","text":"زفير: الهواء يخرج والصدر ينخفض"},{"id":"d","text":"الصدر متوقّفٌ لا يتنفّس"}]'::jsonb, 'c', 'الصدر صغيرٌ والسهم إلى الأسفل، فهذه حركة الزفير: الهواء يخرج والصدر ينخفض. الخطأ الشائع هو الخلط بينها وبين الشهيق.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8d8f051e-bde2-536b-9d82-b184f47b6d27', 'dcbdca56-05f5-53b6-b86f-eae4775f02d1', 'eveil-scientifique-3eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للتنفّس', 3, 120, 30, 'boss', 'admin', 5)
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
  ('48e09b9a-fc9f-5311-a458-1caa9bd9345e', '8d8f051e-bde2-536b-9d82-b184f47b6d27', 'الزفير حركةٌ:', '[{"id":"a","text":"يدخل فيها الهواء إلى الرئتين"},{"id":"b","text":"يرتفع فيها القفص الصدري"},{"id":"c","text":"نتوقّف فيها عن التنفّس"},{"id":"d","text":"يخرج فيها الهواء من الرئتين"}]'::jsonb, 'd', 'الزفير حركةٌ يخرج فيها الهواء من الرئتين فينخفض القفص الصدري.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a1b99ff-4927-57af-8fdd-2a5adf210179', '8d8f051e-bde2-536b-9d82-b184f47b6d27', 'أيّ هذه من قواعد التنفّس الصحّية؟', '[{"id":"a","text":"استنشاق دخان السيّارات"},{"id":"b","text":"تهوية الغرف بفتح النوافذ"},{"id":"c","text":"التنفّس من الفم في الغبار"},{"id":"d","text":"الجلوس قرب المدخّنين"}]'::jsonb, 'b', 'تهوية الغرف بفتح النوافذ تجدّد الهواء وتجعله نقيًّا، وهي من قواعد التنفّس الصحّية.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24ec4f93-ff93-5830-8e6e-9f571251e9a1', '8d8f051e-bde2-536b-9d82-b184f47b6d27', 'أيّ زوجٍ صحيحٌ بين نوع الهواء وتأثيره؟', '[{"id":"a","text":"هواءٌ نقيّ ← مفيدٌ للرئتين"},{"id":"b","text":"هواءٌ ملوّث ← مفيدٌ للرئتين"},{"id":"c","text":"هواءٌ نقيّ ← مضرٌّ بالرئتين"},{"id":"d","text":"دخان ← ينقّي الرئتين"}]'::jsonb, 'a', 'الهواء النقيّ مفيدٌ للرئتين، أمّا الهواء الملوّث والدخان فمضرّان. الخطأ الشائع هو الظنّ أنّ الهواء الملوّث مفيد.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4f3b0f7-b4f0-5f28-bb1f-12bcdad637b5', '8d8f051e-bde2-536b-9d82-b184f47b6d27', 'جلس ولدٌ بجانب شخصٍ يدخّن. ما التصرّف الصحّي السليم؟', '[{"id":"a","text":"أن يستنشق الدخان بعمق"},{"id":"b","text":"أن يبقى مكانه قرب الدخان"},{"id":"c","text":"أن يبتعد عن الدخان ويتنفّس هواءً نقيًّا"},{"id":"d","text":"أن يتوقّف عن التنفّس"}]'::jsonb, 'c', 'الدخان مضرٌّ بالجهاز التنفّسي، فالأفضل الابتعاد عنه واستنشاق هواءٍ نقيّ. الخطأ الشائع هو الظنّ أنّ الدخان لا يضرّ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('271b8bd8-8e90-5008-92c6-c938b3520372', '8d8f051e-bde2-536b-9d82-b184f47b6d27', 'أيّ عبارةٍ **خاطئة**؟', '[{"id":"a","text":"في الزفير يخرج الهواء وينخفض الصدر"},{"id":"b","text":"في الشهيق يخرج الهواء وينخفض الصدر"},{"id":"c","text":"نتنفّس أسرع بعد الجري"},{"id":"d","text":"الأشجار تنقّي الهواء"}]'::jsonb, 'b', 'العبارة الخاطئة أنّ الشهيق يخرج فيه الهواء؛ بل في الشهيق يدخل الهواء ويرتفع الصدر. الخطأ الشائع هو الخلط بين الشهيق والزفير.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f16c2187-af2b-5959-8302-ab044847b253', '8d8f051e-bde2-536b-9d82-b184f47b6d27', 'بعد صعود الدرج بسرعة، علا صدر سعاد وتسارع تنفّسها. ما السبب؟', '[{"id":"a","text":"بذلت مجهودًا فاحتاج جسمها إلى هواءٍ أكثر"},{"id":"b","text":"لأنّها توقّفت عن التنفّس"},{"id":"c","text":"لأنّها تتنفّس من أذنيها"},{"id":"d","text":"لأنّ سرعة التنفّس لا تتغيّر"}]'::jsonb, 'a', 'صعود الدرج مجهودٌ يجعل الجسم يحتاج هواءً أكثر فيتسارع التنفّس. الخطأ الشائع هو الظنّ أنّ المجهود لا يؤثّر في سرعة التنفّس.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3256ed2c-684d-5664-9d4c-b71a687b2f1e', '7dc97c37-3ead-596b-b689-baa026f5f3a1', 'eveil-scientifique-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('1851fda8-34a1-5061-8d2e-66a02521e440', '3256ed2c-684d-5664-9d4c-b71a687b2f1e', 'ما أفضل سلوكٍ يقي من الأمراض قبل الأكل؟', '[{"id":"a","text":"أكل الكثير من الحلوى"},{"id":"b","text":"النوم مباشرة"},{"id":"c","text":"اللعب في التراب"},{"id":"d","text":"غسل اليدين بالماء والصابون"}]'::jsonb, 'd', 'غسل اليدين بالماء والصابون قبل الأكل يقي من الجراثيم والأمراض، وهو من أهمّ سلوكات النظافة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e224ed07-9a02-51bd-a7a3-eee4c3cd4336', '3256ed2c-684d-5664-9d4c-b71a687b2f1e', 'ماذا نعني بكلمة «الوقاية»؟', '[{"id":"a","text":"أن ننتظر حتّى نمرض ثمّ نأخذ الدواء"},{"id":"b","text":"أن نتجاهل المرض تمامًا"},{"id":"c","text":"أن نمنع المرض قبل أن يصيبنا"},{"id":"d","text":"أن نأكل الحلوى كلّ يوم"}]'::jsonb, 'c', 'الوقاية هي منع المرض قبل أن يصيبنا، فالوقاية خيرٌ من العلاج ولا ننتظر حتّى نمرض.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26fb1571-bdeb-5886-9e60-63abb853ec6c', '3256ed2c-684d-5664-9d4c-b71a687b2f1e', 'أين نرمي الفضلات للمحافظة على المحيط؟', '[{"id":"a","text":"في الحاوية المخصّصة"},{"id":"b","text":"في الوادي"},{"id":"c","text":"في الغابة"},{"id":"d","text":"في الشارع"}]'::jsonb, 'a', 'نرمي الفضلات في الحاوية المخصّصة، فرميها في الوادي أو الغابة أو الشارع يلوّث المحيط.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16368136-2790-5f5a-870c-640b3a7f5962', '3256ed2c-684d-5664-9d4c-b71a687b2f1e', 'ما الذي تعطينا إيّاه الشجرة لنتنفّسه؟', '[{"id":"a","text":"الدخان"},{"id":"b","text":"الأكسجين"},{"id":"c","text":"الغبار"},{"id":"d","text":"الفضلات"}]'::jsonb, 'b', 'الشجرة تنقّي الهواء وتعطينا الأكسجين الذي نتنفّسه، لذلك نحميها ولا نقطعها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e000487-c731-5e30-aa63-eabf2b56f76d', '3256ed2c-684d-5664-9d4c-b71a687b2f1e', 'ماذا نفعل إذا مرض حيوانٌ نربّيه في البيت؟', '[{"id":"a","text":"نتركه وحده لأنّ الحيوانات لا تمرض"},{"id":"b","text":"نبعده ولا نعتني به"},{"id":"c","text":"نعرضه على الطبيب البيطريّ"},{"id":"d","text":"نطعمه الحلوى فقط"}]'::jsonb, 'c', 'الحيوانات تمرض أيضًا، فنعرض الحيوان المريض على الطبيب البيطريّ ونعتني بنظافته وغذائه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5fb03394-a84a-5bee-a13c-83e173230341', '7dc97c37-3ead-596b-b689-baa026f5f3a1', 'eveil-scientifique-3eme', '⭐ تمرين: أقي نفسي وأحمي محيطي', 1, 50, 10, 'practice', 'admin', 1)
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
  ('e6c8fbe2-2f05-5982-975e-d6ed8f85de02', '5fb03394-a84a-5bee-a13c-83e173230341', 'متى أغسل يديّ لأقي نفسي من الأمراض؟', '[{"id":"a","text":"مرّةً في الأسبوع فقط"},{"id":"b","text":"لا أغسلهما أبدًا"},{"id":"c","text":"قبل الأكل وبعد الخلاء"},{"id":"d","text":"بعد النوم فقط"}]'::jsonb, 'c', 'أغسل يديّ قبل الأكل وبعد الخلاء لأقي نفسي من الجراثيم والأمراض.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('031d92f2-c3e7-5137-bc50-ee5af8f316bd', '5fb03394-a84a-5bee-a13c-83e173230341', 'أين أرمي علبة العصير الفارغة؟', '[{"id":"a","text":"في الحاوية المخصّصة"},{"id":"b","text":"في الوادي"},{"id":"c","text":"على الأرض في الحديقة"},{"id":"d","text":"في البحر"}]'::jsonb, 'a', 'أرمي الفضلات في الحاوية المخصّصة، فرميها في الطبيعة يلوّث المحيط.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21434c59-10f2-5f33-b01c-979a778dde2a', '5fb03394-a84a-5bee-a13c-83e173230341', 'ما الذي تعطينا إيّاه الشجرة؟', '[{"id":"a","text":"الدخان والغبار"},{"id":"b","text":"الفضلات"},{"id":"c","text":"التلوّث"},{"id":"d","text":"الظلّ والثمار والأكسجين"}]'::jsonb, 'd', 'الشجرة تعطينا الظلّ والثمار والأكسجين، وتنقّي الهواء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a5f3645-6552-5daf-b0dd-0489b55c34e5', '5fb03394-a84a-5bee-a13c-83e173230341', 'ماذا أفعل إذا مرضت قطّتي في البيت؟', '[{"id":"a","text":"أتركها لأنّ الحيوانات لا تمرض"},{"id":"b","text":"أعرضها على الطبيب البيطريّ"},{"id":"c","text":"أبعدها ولا أعتني بها"},{"id":"d","text":"أطعمها الحلوى"}]'::jsonb, 'b', 'الحيوانات تمرض أيضًا، فأعرض قطّتي المريضة على الطبيب البيطريّ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f9dd619-fa05-5fec-9c03-15bf27ac2b00', '5fb03394-a84a-5bee-a13c-83e173230341', 'أيّ هذه غذاءٌ متوازنٌ يقوّي جسمي ويقيه؟', '[{"id":"a","text":"الخضر والغلال"},{"id":"b","text":"الحلوى فقط"},{"id":"c","text":"الحلوى والمشروبات الغازيّة"},{"id":"d","text":"الشيبس فقط"}]'::jsonb, 'a', 'التغذية المتوازنة بالخضر والغلال تقوّي الجسم وتقيه من الأمراض، أمّا الحلوى وحدها فتضرّ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('88f685e6-4828-50ee-8706-58711e49d6d5', '5fb03394-a84a-5bee-a13c-83e173230341', 'في الصورة شجرةٌ خضراء سليمة. ماذا تفعل من أجل الهواء؟ <svg viewBox="0 0 200 120" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="120" fill="#eaf6ff" stroke="#7fb8d6" stroke-width="2"/><rect x="0" y="104" width="200" height="16" fill="#86c34a" stroke="#2f6b12" stroke-width="2"/><g stroke="#1f2937" stroke-width="2"><rect x="92" y="66" width="14" height="40" fill="#5a3210"/><circle cx="99" cy="50" r="30" fill="#3aae6a"/><circle cx="76" cy="58" r="18" fill="#86c34a"/><circle cx="122" cy="58" r="18" fill="#86c34a"/></g></svg>', '[{"id":"a","text":"تملأ الهواء بالدخان"},{"id":"b","text":"تلوّث الماء"},{"id":"c","text":"ترمي الفضلات"},{"id":"d","text":"تنقّي الهواء وتعطي الأكسجين"}]'::jsonb, 'd', 'الصورة شجرةٌ خضراء سليمة، والشجرة تنقّي الهواء وتعطي الأكسجين، لذلك نحميها.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('06725754-8b07-5055-9d8d-652fdc509d6e', '7dc97c37-3ead-596b-b689-baa026f5f3a1', 'eveil-scientifique-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: حارس الصحّة والبيئة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('7af3c241-97ea-559f-8e8e-69bfcb37dbdf', '06725754-8b07-5055-9d8d-652fdc509d6e', 'قال طفلٌ: «سأرمي هذه الفضلة الصغيرة في الوادي، فهي صغيرةٌ لا تضرّ». ما الصواب؟', '[{"id":"a","text":"كلّ فضلةٍ تلوّث الماء، فأرميها في الحاوية"},{"id":"b","text":"الفضلة الصغيرة لا تضرّ الماء أبدًا"},{"id":"c","text":"الوادي مكانٌ مناسبٌ للفضلات"},{"id":"d","text":"الماء ينظّف نفسه من كلّ شيء"}]'::jsonb, 'a', 'الخطأ الشائع هو الظنّ أنّ رمي فضلةٍ صغيرةٍ في الوادي لا يضرّ؛ بل كلّ فضلةٍ تلوّث الماء، فأرميها في الحاوية.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e856ea5-e194-5b57-b217-f592d4360eb8', '06725754-8b07-5055-9d8d-652fdc509d6e', 'لماذا نلقّح الأطفال (التطعيم)؟', '[{"id":"a","text":"ليكبروا أسرع"},{"id":"b","text":"ليأكلوا أكثر"},{"id":"c","text":"لوقايتهم من أمراضٍ خطيرة"},{"id":"d","text":"ليناموا طوال اليوم"}]'::jsonb, 'c', 'التلقيح وسيلة وقايةٍ تحمي الجسم من أمراضٍ خطيرة قبل أن تصيبه. الخطأ الشائع هو الظنّ أنّ التلقيح للنموّ أو الأكل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5bcc4e3d-98dc-50ea-b0d5-6d3dcbd4741c', '06725754-8b07-5055-9d8d-652fdc509d6e', 'أيّ زوجٍ صحيحٌ بين نوع التلوّث ومثاله؟', '[{"id":"a","text":"تلوّث الماء ← دخان السيّارات"},{"id":"b","text":"تلوّث الهواء ← دخان المصانع"},{"id":"c","text":"تلوّث الهواء ← رمي الفضلات في البحر"},{"id":"d","text":"تلوّث التربة ← دخان المداخن"}]'::jsonb, 'b', 'دخان المصانع يلوّث الهواء. الخطأ الشائع هو الخلط: رمي الفضلات في البحر يلوّث الماء، والنفايات تلوّث التربة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a67f05c1-3345-5404-bc2c-745fbdc5033b', '06725754-8b07-5055-9d8d-652fdc509d6e', 'حديقةٌ كثيرة الأشجار وأخرى قُطعت أشجارها. أيّهما هواؤها أنقى ولماذا؟', '[{"id":"a","text":"الحديقة بلا أشجار، لأنّ الأشجار تلوّث"},{"id":"b","text":"هما متساويتان، فالأشجار لا أثر لها"},{"id":"c","text":"الحديقة بلا أشجار، لأنّها أوسع"},{"id":"d","text":"الحديقة كثيرة الأشجار، لأنّ الأشجار تنقّي الهواء"}]'::jsonb, 'd', 'الأشجار تنقّي الهواء وتعطي الأكسجين، فالحديقة كثيرة الأشجار هواؤها أنقى. الخطأ الشائع هو الظنّ أنّ قطع الأشجار لا أثر له.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ecdc787-ea7d-5f92-bdc7-2cdc107bf66c', '06725754-8b07-5055-9d8d-652fdc509d6e', 'طفلٌ يشعر بألمٍ في أسنانه بعد أكل الكثير من الحلوى. ما السبب والوقاية؟', '[{"id":"a","text":"السبب الماء، والوقاية ترك شرب الماء"},{"id":"b","text":"السبب الخضر، والوقاية ترك الخضر"},{"id":"c","text":"السبب الحلوى وقلّة التنظيف، والوقاية تنظيف الأسنان وتقليل الحلوى"},{"id":"d","text":"لا سبب له، والأسنان تؤلم دائمًا"}]'::jsonb, 'c', 'تسوّس الأسنان يأتي من الحلوى وقلّة تنظيف الأسنان، فالوقاية تنظيفها كلّ يومٍ وتقليل الحلوى. الخطأ الشائع اتّهام الماء أو الخضر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a8b70ee-9406-5e83-9ec8-5b5458866830', '06725754-8b07-5055-9d8d-652fdc509d6e', 'ما السلوك الذي يحمي الغابة من الحرائق؟', '[{"id":"a","text":"إشعال النار قرب الأشجار"},{"id":"b","text":"عدم إشعال النار وإطفاء أيّ شرارة"},{"id":"c","text":"ترك أعواد الثقاب مشتعلة"},{"id":"d","text":"رمي السجائر في الأعشاب"}]'::jsonb, 'b', 'الحرائق تلتهم الغابة بسرعة، فنحميها بعدم إشعال النار وإطفاء أيّ شرارة. الخطأ الشائع هو الاستهانة بشرارةٍ صغيرة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b13c0bb5-5c5c-566e-9786-e3f88aed12cf', '7dc97c37-3ead-596b-b689-baa026f5f3a1', 'eveil-scientifique-3eme', '⭐⭐ تمرين مراجعة: الصحّة والمحيط', 2, 75, 15, 'practice', 'admin', 3)
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
  ('9f15ea57-b19c-5ef6-9b49-0bb681769ed2', 'b13c0bb5-5c5c-566e-9786-e3f88aed12cf', 'الرشح (الزكام) مرضٌ يصيب:', '[{"id":"a","text":"الأشجار"},{"id":"b","text":"الحجر"},{"id":"c","text":"الماء"},{"id":"d","text":"الإنسان"}]'::jsonb, 'd', 'الرشح من الأمراض الشائعة التي تصيب الإنسان، فيعطس ويسعل ويسيل أنفه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('71f51861-9486-5881-a48d-c6dc5f7d4f2f', 'b13c0bb5-5c5c-566e-9786-e3f88aed12cf', 'إعادة التدوير (الرسكلة) سلوكٌ:', '[{"id":"a","text":"يضرّ المحيط"},{"id":"b","text":"يحمي المحيط"},{"id":"c","text":"يلوّث الهواء"},{"id":"d","text":"يسبّب المرض"}]'::jsonb, 'b', 'إعادة التدوير (الرسكلة) سلوكٌ يحمي المحيط لأنّه يقلّل النفايات.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8f97d5fe-b72c-54e4-8d6a-6297c1495f85', 'b13c0bb5-5c5c-566e-9786-e3f88aed12cf', 'أيّ هذه يقي من الأمراض؟', '[{"id":"a","text":"النوم الكافي والرياضة"},{"id":"b","text":"السهر طوال الليل"},{"id":"c","text":"أكل الحلوى فقط"},{"id":"d","text":"ترك غسل اليدين"}]'::jsonb, 'a', 'النوم الكافي والرياضة يقوّيان الجسم ويقيانه من الأمراض.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aba0c17c-7ee1-5893-9c5d-bd9351f5ad45', 'b13c0bb5-5c5c-566e-9786-e3f88aed12cf', 'للاقتصاد في الماء، ماذا أفعل عند تنظيف أسناني؟', '[{"id":"a","text":"أترك الماء يجري طوال الوقت"},{"id":"b","text":"أفتح كلّ الحنفيّات في البيت"},{"id":"c","text":"أغلق الحنفيّة أثناء التنظيف"},{"id":"d","text":"أسكب الماء على الأرض"}]'::jsonb, 'c', 'أغلق الحنفيّة أثناء تنظيف أسناني لأقتصد في الماء وأحمي المحيط.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f6de4e54-f5d1-5cfa-8e80-31f8a7bad51f', 'b13c0bb5-5c5c-566e-9786-e3f88aed12cf', 'في الصورة وادٍ رُميت فيه الفضلات. ما حالة هذا الماء؟ <svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="110" fill="#9fb3a0" stroke="#5a6b58" stroke-width="2"/><g stroke="#1f2937" stroke-width="2"><rect x="30" y="40" width="16" height="14" fill="#e0533a"/><rect x="95" y="68" width="18" height="12" fill="#ffd23f"/><rect x="140" y="30" width="14" height="16" fill="#9b59b6"/><rect x="60" y="80" width="15" height="13" fill="#5a3210"/></g></svg>', '[{"id":"a","text":"ماءٌ نظيفٌ صالحٌ للشرب"},{"id":"b","text":"ماءٌ ملوّثٌ بالفضلات"},{"id":"c","text":"هواءٌ نقيّ"},{"id":"d","text":"شجرةٌ خضراء"}]'::jsonb, 'b', 'الصورة وادٍ مليءٌ بالفضلات الملوّنة، فهذا ماءٌ ملوّثٌ بالفضلات لا يصلح للشرب.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd6025d0-8d2e-5beb-a5f6-314e3f2a176a', 'b13c0bb5-5c5c-566e-9786-e3f88aed12cf', 'الطبيب البيطريّ هو الذي يعالج:', '[{"id":"a","text":"الحيوانات"},{"id":"b","text":"السيّارات"},{"id":"c","text":"الأشجار فقط"},{"id":"d","text":"الحجارة"}]'::jsonb, 'a', 'الطبيب البيطريّ يعالج الحيوانات المريضة، لأنّ الحيوانات تمرض أيضًا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('42f6f2d2-560d-5778-a779-cd9228b342b4', '7dc97c37-3ead-596b-b689-baa026f5f3a1', 'eveil-scientifique-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل الصحّة والبيئة', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('ed83df1d-d31c-50e6-9d25-b9fb843a0788', '42f6f2d2-560d-5778-a779-cd9228b342b4', 'أصيب طفلٌ بالإسهال بعد أن شرب ماءً غير نظيف. ما الوقاية المناسبة؟', '[{"id":"a","text":"شرب المزيد من الماء غير النظيف"},{"id":"b","text":"شرب الماء النظيف وغسل اليدين وغسل الغلال"},{"id":"c","text":"ترك الأكل والشرب نهائيًّا"},{"id":"d","text":"أكل الحلوى بدل الماء"}]'::jsonb, 'b', 'الإسهال يأتي من ماءٍ أو طعامٍ غير نظيف، فالوقاية شرب الماء النظيف وغسل اليدين والغلال. الخطأ الشائع تجاهل نظافة الماء والطعام.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7cc95120-e28b-51dd-b3d9-d362788e02a6', '42f6f2d2-560d-5778-a779-cd9228b342b4', 'قال أحدهم: «الحيوانات لا تمرض مثل الإنسان». لماذا هذا خطأ؟', '[{"id":"a","text":"لأنّ الحيوانات لا تأكل"},{"id":"b","text":"لأنّ الحيوانات حجارة"},{"id":"c","text":"لأنّ الحيوانات تطير فقط"},{"id":"d","text":"لأنّ الحيوانات تمرض أيضًا وتحتاج إلى عنايةٍ وطبيبٍ بيطريّ"}]'::jsonb, 'd', 'الحيوانات كائناتٌ حيّةٌ تمرض أيضًا وتحتاج إلى نظافةٍ وغذاءٍ وطبيبٍ بيطريّ. الخطأ الشائع هو الظنّ أنّ الحيوانات لا تمرض.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c9a5db9-2a32-5639-a365-0ff248632fee', '42f6f2d2-560d-5778-a779-cd9228b342b4', 'أرادت مدرسةٌ أن تحسّن هواء حيّها. أيّ مشروعٍ هو الأنسب؟', '[{"id":"a","text":"قطع كلّ الأشجار حول المدرسة"},{"id":"b","text":"إشعال النفايات في الساحة"},{"id":"c","text":"غرس أشجارٍ كثيرةٍ والاعتناء بها"},{"id":"d","text":"ركن سيّاراتٍ كثيرةٍ وتشغيلها"}]'::jsonb, 'c', 'الأشجار تنقّي الهواء وتعطي الأكسجين، فغرسها يحسّن هواء الحيّ. الخطأ الشائع هو الظنّ أنّ قطع الأشجار أو حرق النفايات يفيد.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b1ca731-db44-5de3-91fd-40d8e800f40c', '42f6f2d2-560d-5778-a779-cd9228b342b4', 'أيّ استنتاجٍ صحيحٍ بعد دراسة الوقاية وحماية المحيط؟', '[{"id":"a","text":"الوقاية والسلوك السليم يحميان صحّتي ومحيطي معًا"},{"id":"b","text":"المرض لا يمكن الوقاية منه أبدًا"},{"id":"c","text":"رمي الفضلات لا يضرّ المحيط"},{"id":"d","text":"الأشجار لا فائدة منها"}]'::jsonb, 'a', 'نستنتج أنّ الوقاية (النظافة والتغذية والتلقيح) والسلوك السليم (عدم التلويث وحماية الشجر) يحميان الصحّة والمحيط معًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('653142fc-77ee-5c59-9f5e-64a570ee1cbe', '42f6f2d2-560d-5778-a779-cd9228b342b4', 'حيوانٌ نادرٌ يكاد ينقرض بسبب الصيد العشوائيّ. ما السلوك الذي يحميه؟', '[{"id":"a","text":"اصطياده أكثر"},{"id":"b","text":"حرق غابته"},{"id":"c","text":"تلويث مائه"},{"id":"d","text":"منع الصيد العشوائيّ وحماية بيئته"}]'::jsonb, 'd', 'الصيد العشوائيّ يهدّد الحيوانات بالانقراض، فنحميها بمنع الصيد العشوائيّ وحماية بيئتها. الخطأ الشائع هو الاستهانة بأثر الصيد.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b81a46b7-d78d-5489-9824-909c276cf6db', '42f6f2d2-560d-5778-a779-cd9228b342b4', 'في الصورة شجرةٌ مشتعلةٌ في الغابة. ما الذي يجب أن نفعله؟ <svg viewBox="0 0 200 120" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="120" fill="#3a3a3a" stroke="#1f2937" stroke-width="2"/><rect x="0" y="104" width="200" height="16" fill="#7a5a2a" stroke="#4a3010" stroke-width="2"/><g stroke="#1f2937" stroke-width="2"><rect x="92" y="66" width="14" height="40" fill="#5a3210"/><circle cx="99" cy="50" r="28" fill="#7a3b12"/></g><g stroke="#e0a400" stroke-width="2"><path d="M88 40 q6 -16 12 -2 q6 -14 10 2 q4 12 -8 16 q-12 2 -14 -16 z" fill="#e0533a"/><path d="M96 28 q3 -10 7 0 q3 -6 5 4 q2 8 -5 9 q-7 1 -7 -13 z" fill="#ffd23f"/></g></svg>', '[{"id":"a","text":"نتركها تحترق ونشعل المزيد"},{"id":"b","text":"نقطع باقي الأشجار"},{"id":"c","text":"نطفئ النار ونمنع الحرائق لحماية الغابة"},{"id":"d","text":"نرمي الفضلات عليها"}]'::jsonb, 'c', 'الصورة شجرةٌ تحترق في غابةٍ سوداء، والحرائق تتلف الغابة، فنطفئ النار ونمنع الحرائق. الخطأ الشائع هو الاستهانة بالحريق.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ce5a5c0a-6580-5552-9cb4-80b3d78503f4', '7dc97c37-3ead-596b-b689-baa026f5f3a1', 'eveil-scientifique-3eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للوقاية وحماية المحيط', 3, 120, 30, 'boss', 'admin', 5)
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
  ('7ecca1d8-ddd4-54b4-9b40-191f4b207c8f', 'ce5a5c0a-6580-5552-9cb4-80b3d78503f4', 'تسوّس الأسنان مرضٌ سببه:', '[{"id":"a","text":"شرب الماء"},{"id":"b","text":"أكل الخضر"},{"id":"c","text":"الحلوى وقلّة تنظيف الأسنان"},{"id":"d","text":"النوم الكافي"}]'::jsonb, 'c', 'تسوّس الأسنان سببه الحلوى وقلّة تنظيف الأسنان، فنقي أنفسنا بتنظيفها وتقليل الحلوى.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('42fc189f-c736-5b7e-a7e1-5f02d742b4de', 'ce5a5c0a-6580-5552-9cb4-80b3d78503f4', 'دخان المصانع والسيّارات يسبّب:', '[{"id":"a","text":"تلوّث الهواء"},{"id":"b","text":"تنقية الهواء"},{"id":"c","text":"نموّ الأشجار"},{"id":"d","text":"ماءً نظيفًا"}]'::jsonb, 'a', 'دخان المصانع والسيّارات يسبّب تلوّث الهواء الذي يضرّ صحّتنا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df645712-bb94-5465-a277-6a819c587183', 'ce5a5c0a-6580-5552-9cb4-80b3d78503f4', 'أيّ مجموعةٍ كلّها وسائل وقايةٍ من الأمراض؟', '[{"id":"a","text":"الحلوى، السهر، التراب"},{"id":"b","text":"غسل اليدين، التلقيح، التغذية المتوازنة"},{"id":"c","text":"الدخان، الفضلات، الإسهال"},{"id":"d","text":"قطع الأشجار، الحرائق، الصيد"}]'::jsonb, 'b', 'غسل اليدين والتلقيح والتغذية المتوازنة كلّها وسائل وقايةٍ تمنع الأمراض.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('241dfe96-1209-5602-b0d9-7bedfc4717bf', 'ce5a5c0a-6580-5552-9cb4-80b3d78503f4', 'أيّ عبارةٍ **صحيحة**؟', '[{"id":"a","text":"رمي الفضلات في البحر ينظّفه"},{"id":"b","text":"قطع الأشجار يزيد الأكسجين"},{"id":"c","text":"الحيوانات لا تمرض أبدًا"},{"id":"d","text":"إعادة التدوير تقلّل النفايات وتحمي المحيط"}]'::jsonb, 'd', 'العبارة الصحيحة أنّ إعادة التدوير تقلّل النفايات وتحمي المحيط، أمّا الباقي فخطأ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa8b2876-1d44-59f2-a877-675566f432dc', 'ce5a5c0a-6580-5552-9cb4-80b3d78503f4', 'أيّ عبارةٍ **خاطئة**؟', '[{"id":"a","text":"الشجرة لا تنفع البيئة في شيء"},{"id":"b","text":"الشجرة تنقّي الهواء"},{"id":"c","text":"غسل اليدين يقي من الأمراض"},{"id":"d","text":"التلقيح يحمي من أمراضٍ خطيرة"}]'::jsonb, 'a', 'العبارة الخاطئة أنّ الشجرة لا تنفع البيئة؛ بل الشجرة تنقّي الهواء وتعطي الأكسجين والظلّ والثمار.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca22510f-f99c-5db7-bd44-b95be4da371d', 'ce5a5c0a-6580-5552-9cb4-80b3d78503f4', 'أرادت عائلةٌ قضاء يومٍ في الغابة. أيّ سلوكٍ يحمي الغابة والحيوان؟', '[{"id":"a","text":"إشعال نارٍ كبيرةٍ وتركها"},{"id":"b","text":"جمع الفضلات وإطفاء النار وعدم الصيد العشوائيّ"},{"id":"c","text":"اصطياد الطيور النادرة"},{"id":"d","text":"ترك الفضلات بين الأشجار"}]'::jsonb, 'b', 'نحمي الغابة والحيوان بجمع الفضلات وإطفاء النار وعدم الصيد العشوائيّ، فالحرائق والصيد يهدّدانهما.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9345c122-e999-535a-9d64-5c27e3431794', '7fb3f737-9068-51ce-9269-6c07e3b3bee5', 'eveil-scientifique-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('dcdf41cb-4a8a-51ba-86e6-fbafad9cae34', '9345c122-e999-535a-9d64-5c27e3431794', 'أيّ هذه الأجسام في الحالة الصلبة؟', '[{"id":"a","text":"الحجر"},{"id":"b","text":"الماء"},{"id":"c","text":"الزيت"},{"id":"d","text":"الهواء"}]'::jsonb, 'a', 'الحجر جسمٌ صلب له شكلٌ ثابت، أمّا الماء والزيت فسائلان والهواء غاز.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('39981068-9103-5799-aea6-63e742d43deb', '9345c122-e999-535a-9d64-5c27e3431794', 'ماذا يتحوّل الماء السائل بمفعول الحرارة عند الغليان؟', '[{"id":"a","text":"إلى جليدٍ صلب"},{"id":"b","text":"إلى حجر"},{"id":"c","text":"إلى بخارٍ (غاز)"},{"id":"d","text":"إلى زيت"}]'::jsonb, 'c', 'بمفعول الحرارة يتبخّر الماء السائل ويتحوّل إلى بخار، والبخار غاز.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f968ea1-0f56-5886-80c2-baa15ffdc3b5', '9345c122-e999-535a-9d64-5c27e3431794', 'ما اسم تحوّل الجليد الصلب إلى ماءٍ سائل بسبب ارتفاع الحرارة؟', '[{"id":"a","text":"التجمّد"},{"id":"b","text":"الانصهار"},{"id":"c","text":"التبخّر"},{"id":"d","text":"الإسالة"}]'::jsonb, 'b', 'تحوّل الصلب إلى سائل بمفعول ارتفاع الحرارة اسمه الانصهار، مثل الجليد يصير ماءً.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9a51cf9-a1a4-5ca2-bb29-6af7ea3f6880', '9345c122-e999-535a-9d64-5c27e3431794', 'نضع ملعقة سكرٍ في كأس ماءٍ ونحرّك فيختفي السكر. ماذا حدث له؟', '[{"id":"a","text":"احترق واختفى تمامًا"},{"id":"b","text":"تبخّر وصار غازًا"},{"id":"c","text":"تجمّد في الماء"},{"id":"d","text":"انحلّ في الماء وبقي موجودًا (نتذوّقه)"}]'::jsonb, 'd', 'السكر انحلّ في الماء فاختفى من نظرنا، لكنّه باقٍ لأنّنا نتذوّق حلاوته.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4818fa5-3f7d-5a9b-aa05-9a3d640eca76', '9345c122-e999-535a-9d64-5c27e3431794', 'في دورة الماء، كيف يتكوّن السحاب في الأعلى؟', '[{"id":"a","text":"السكر ينحلّ في البحر"},{"id":"b","text":"الماء يتجمّد على الأرض"},{"id":"c","text":"البخار يبرد في الأعلى فيتكوّن السحاب (إسالة)"},{"id":"d","text":"الحجر يصير غازًا"}]'::jsonb, 'c', 'يرتفع بخار الماء ثمّ يبرد في الأعلى فيتحوّل إلى قطراتٍ تكوّن السحاب، وهذه إسالة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f500c587-6396-5711-9307-9a90e03592e9', '7fb3f737-9068-51ce-9269-6c07e3b3bee5', 'eveil-scientifique-3eme', '⭐ تمرين: أتعرّف على حالات المادّة', 1, 50, 10, 'practice', 'admin', 1)
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
  ('5eb472e0-c7cb-51d6-8a8e-105dda610abf', 'f500c587-6396-5711-9307-9a90e03592e9', 'أيّ هذه المواد سائلة؟', '[{"id":"a","text":"الماء"},{"id":"b","text":"الحجر"},{"id":"c","text":"الخشب"},{"id":"d","text":"الجليد"}]'::jsonb, 'a', 'الماء مادّةٌ سائلة تأخذ شكل الإناء، أمّا الحجر والخشب والجليد فصلبة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('033b8ca2-ebb5-555e-89e3-1ea7c2852772', 'f500c587-6396-5711-9307-9a90e03592e9', 'الجسم الصلب يمتاز بأنّه:', '[{"id":"a","text":"يأخذ شكل الإناء"},{"id":"b","text":"ينتشر في الهواء"},{"id":"c","text":"له شكلٌ ثابت"},{"id":"d","text":"لا نراه أبدًا"}]'::jsonb, 'c', 'الجسم الصلب له شكلٌ ثابتٌ لا يتغيّر، مثل الحجر والخشب.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76321773-a5c4-59b8-aabc-96e39b443ee5', 'f500c587-6396-5711-9307-9a90e03592e9', 'عندما يبرد الماء كثيرًا في الثلّاجة، ماذا يصير؟', '[{"id":"a","text":"بخارًا"},{"id":"b","text":"جليدًا صلبًا"},{"id":"c","text":"زيتًا"},{"id":"d","text":"هواءً"}]'::jsonb, 'b', 'عند انخفاض الحرارة يتجمّد الماء السائل ويصير جليدًا صلبًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef5a6c3f-419f-5c62-bdea-4087d421fdc6', 'f500c587-6396-5711-9307-9a90e03592e9', 'ما الذي يجعل المثلّجة (الجلاتي) تنصهر فتصير سائلة؟', '[{"id":"a","text":"البرودة الشديدة"},{"id":"b","text":"وضعها في الثلّاجة"},{"id":"c","text":"الظلام"},{"id":"d","text":"ارتفاع الحرارة"}]'::jsonb, 'd', 'الانصهار يحدث بمفعول ارتفاع الحرارة، فتنصهر المثلّجة وتصير سائلة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21387613-e6bb-5453-b608-9f818d158725', 'f500c587-6396-5711-9307-9a90e03592e9', 'في الصورة كأسٌ بداخله مادّة. ما حالة هذه المادّة؟ <svg viewBox="0 0 200 120" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="120" fill="#fdfdfd" stroke="#cccccc" stroke-width="1"/><path d="M70 24 l0 78 l60 0 l0 -78" fill="none" stroke="#1f2937" stroke-width="2"/><rect x="70" y="58" width="60" height="44" fill="#3a8fd6" stroke="none"/><ellipse cx="100" cy="58" rx="30" ry="6" fill="#bfe6f5" stroke="none"/></svg>', '[{"id":"a","text":"صلبة"},{"id":"b","text":"غازيّة"},{"id":"c","text":"سائلة (تأخذ شكل الكأس)"},{"id":"d","text":"لا مادّة في الكأس"}]'::jsonb, 'c', 'المادّة الزرقاء ملأت قعر الكأس وأخذت شكله بسطحٍ مستوٍ، فهي سائلة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1659b0d-c9fd-5dde-8e32-0cd67747d368', 'f500c587-6396-5711-9307-9a90e03592e9', 'أيّ هذه أمثلةٌ على الغاز؟', '[{"id":"a","text":"الهواء"},{"id":"b","text":"الحليب"},{"id":"c","text":"الحجر"},{"id":"d","text":"الخشب"}]'::jsonb, 'a', 'الهواء غازٌ ينتشر حولنا ولا نراه، أمّا الحليب فسائلٌ والحجر والخشب صلبان.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ee315ad6-50dd-56cd-b59a-3799db9563b7', '7fb3f737-9068-51ce-9269-6c07e3b3bee5', 'eveil-scientifique-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد المادّة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('ed930136-e8c3-5099-b5cb-ed512fdb3244', 'ee315ad6-50dd-56cd-b59a-3799db9563b7', 'وضعنا قطعة سكرٍ في كأس ماءٍ ساخنٍ فاختفت. ما التحوّل الصحيح؟', '[{"id":"a","text":"انصهرت لأنّها سخنت"},{"id":"b","text":"تبخّرت وصارت غازًا"},{"id":"c","text":"انحلّت في الماء وبقيت موجودة"},{"id":"d","text":"تجمّدت"}]'::jsonb, 'c', 'السكر انحلّ في الماء فاختفى لكنّه باقٍ (نتذوّقه). الخطأ الشائع هو الظنّ أنّه انصهر؛ الانحلال غير الانصهار.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('155d80f8-4bf8-5817-b1bd-439b4644acaf', 'ee315ad6-50dd-56cd-b59a-3799db9563b7', 'نرى «دخانًا» أبيض يتصاعد فوق إناء الماء المغلي. ما هو في الحقيقة؟', '[{"id":"a","text":"قطراتٌ صغيرة من الماء (بداية إسالة)"},{"id":"b","text":"بخار ماءٍ نراه بوضوح"},{"id":"c","text":"هواءٌ يحترق"},{"id":"d","text":"ملحٌ متطاير"}]'::jsonb, 'a', 'بخار الماء غازٌ شفّافٌ لا نراه؛ الذي نراه قطراتٌ صغيرة تكوّنت ببرودة البخار. الخطأ الشائع هو ظنّ هذا الدخان بخارًا مرئيًّا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a7463c7-475a-58b7-bc52-c03108c944ab', 'ee315ad6-50dd-56cd-b59a-3799db9563b7', 'أيّ زوجٍ صحيحٌ بين التحوّل واتّجاهه؟', '[{"id":"a","text":"الانصهار: سائل ← صلب"},{"id":"b","text":"التجمّد: صلب ← سائل"},{"id":"c","text":"التبخّر: غاز ← سائل"},{"id":"d","text":"التجمّد: سائل ← صلب"}]'::jsonb, 'd', 'التجمّد تحوّل السائل إلى صلب بالتبريد. الخطأ الشائع هو عكس الاتّجاه؛ فالانصهار صلب ← سائل والتبخّر سائل ← غاز.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c043924b-71d0-52e9-adf2-57332c4985a6', 'ee315ad6-50dd-56cd-b59a-3799db9563b7', 'تركنا صحنًا فيه ماءٌ قليلٌ في الشمس أيّامًا، فاختفى الماء. لماذا؟', '[{"id":"a","text":"تجمّد وصار جليدًا"},{"id":"b","text":"تبخّر بمفعول حرارة الشمس"},{"id":"c","text":"انحلّ في الصحن"},{"id":"d","text":"صار صلبًا"}]'::jsonb, 'b', 'حرارة الشمس بخّرت الماء ببطءٍ فتحوّل إلى بخار وارتفع. الخطأ الشائع هو الظنّ أنّ الماء تجمّد، والتجمّد يحتاج برودةً لا حرارة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4221cb8-128c-52f0-8515-a0efe08f6109', 'ee315ad6-50dd-56cd-b59a-3799db9563b7', 'أيّ مجموعةٍ كلّها أجسامٌ صلبة؟', '[{"id":"a","text":"الحجر، الخشب، الجليد"},{"id":"b","text":"الماء، الزيت، الحليب"},{"id":"c","text":"الهواء، البخار، الماء"},{"id":"d","text":"الزيت، الحجر، الهواء"}]'::jsonb, 'a', 'الحجر والخشب والجليد كلّها صلبةٌ لها شكلٌ ثابت. الخطأ الشائع هو الخلط، فالماء والزيت سائلان والهواء غاز.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49690b1b-9f6e-5b7b-8559-0ac5ecf33bba', 'ee315ad6-50dd-56cd-b59a-3799db9563b7', 'ما الفرق الصحيح بين انحلال السكر وانصهار الجليد؟', '[{"id":"a","text":"لا فرق بينهما، كلاهما الشيء نفسه"},{"id":"b","text":"الانحلال يحتاج حرارةً فقط مثل الانصهار"},{"id":"c","text":"الانصهار اختفاء السكر في الماء"},{"id":"d","text":"الانحلال اختفاء السكر في الماء، والانصهار ذوبان الصلب بالحرارة"}]'::jsonb, 'd', 'الانحلال اختفاء مادّةٍ في سائلٍ مع بقائها، والانصهار تحوّل الصلب إلى سائلٍ بالحرارة. الخطأ الشائع هو الخلط بينهما.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('396b90f8-7ea9-575c-a69d-0a6d9bc49890', '7fb3f737-9068-51ce-9269-6c07e3b3bee5', 'eveil-scientifique-3eme', '⭐⭐ تمرين مراجعة: تحوّلات المادّة', 2, 75, 15, 'practice', 'admin', 3)
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
  ('3aee44e2-fbb0-5a6b-9984-3ebaae47b977', '396b90f8-7ea9-575c-a69d-0a6d9bc49890', 'تحوّل الماء السائل إلى بخارٍ بمفعول الحرارة اسمه:', '[{"id":"a","text":"التجمّد"},{"id":"b","text":"التبخّر"},{"id":"c","text":"الانصهار"},{"id":"d","text":"الإسالة"}]'::jsonb, 'b', 'تحوّل السائل إلى بخار (غاز) بمفعول الحرارة اسمه التبخّر.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3055d53-791c-5cdd-9501-fcd35e05447e', '396b90f8-7ea9-575c-a69d-0a6d9bc49890', 'السائل يمتاز بأنّه:', '[{"id":"a","text":"له شكلٌ ثابتٌ دائمًا"},{"id":"b","text":"لا نراه أبدًا"},{"id":"c","text":"يحترق بسرعة"},{"id":"d","text":"يأخذ شكل الإناء الذي نضعه فيه"}]'::jsonb, 'd', 'السائل ليس له شكلٌ ثابت، بل يأخذ شكل الإناء الذي نضعه فيه، مثل الماء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e3901ef-7e74-5baf-a0b7-73e5e73509ae', '396b90f8-7ea9-575c-a69d-0a6d9bc49890', 'قطرات الندى فوق العشب في الصباح البارد سببها:', '[{"id":"a","text":"تجمّد العشب"},{"id":"b","text":"انحلال الماء"},{"id":"c","text":"إسالة بخار الماء عند البرودة"},{"id":"d","text":"احتراق الهواء"}]'::jsonb, 'c', 'بخار الماء في الجوّ يبرد ليلًا فيتحوّل إلى قطراتٍ صغيرة (إسالة) هي الندى.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ac5d529-cce5-5031-bf0d-c3b62422aa08', '396b90f8-7ea9-575c-a69d-0a6d9bc49890', 'أيّ تحوّلٍ يحتاج إلى تبريدٍ (انخفاض الحرارة)؟', '[{"id":"a","text":"التجمّد"},{"id":"b","text":"الانصهار"},{"id":"c","text":"الغليان"},{"id":"d","text":"التبخّر"}]'::jsonb, 'a', 'التجمّد تحوّل السائل إلى صلبٍ، ويحتاج إلى تبريد. أمّا الانصهار والغليان والتبخّر فتحتاج إلى حرارة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a72f509c-4aca-5800-be1c-603e4fa5b8fd', '396b90f8-7ea9-575c-a69d-0a6d9bc49890', 'في الصورة قطعة جليدٍ تحت الشمس بدأت تسيل. ما اسم هذا التحوّل؟ <svg viewBox="0 0 210 120" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="210" height="120" fill="#fdfdfd" stroke="#cccccc" stroke-width="1"/><circle cx="40" cy="30" r="16" fill="#ffd23f" stroke="#e0a400" stroke-width="2"/><g stroke="#e0a400" stroke-width="2"><line x1="40" y1="8" x2="40" y2="2"/><line x1="18" y1="30" x2="12" y2="30"/></g><rect x="110" y="40" width="40" height="34" rx="3" fill="#a9e0f5" stroke="#1f6f8c" stroke-width="3"/><path d="M108 88 q22 -10 44 0 l0 6 l-44 0 z" fill="#3a8fd6" stroke="#1f6f8c" stroke-width="2"/></svg>', '[{"id":"a","text":"التجمّد"},{"id":"b","text":"الانحلال"},{"id":"c","text":"التبخّر"},{"id":"d","text":"الانصهار"}]'::jsonb, 'd', 'الجليد الصلب سخن بالشمس وتحوّل إلى ماءٍ سائلٍ تحته، وهذا هو الانصهار.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('273d68de-dcc7-5cd3-9432-dff5838a8434', '396b90f8-7ea9-575c-a69d-0a6d9bc49890', 'أيّ عبارةٍ صحيحة؟', '[{"id":"a","text":"الانحلال هو نفسه الانصهار"},{"id":"b","text":"السكر ينحلّ في الماء فيختفي لكنّه باقٍ"},{"id":"c","text":"بخار الماء جسمٌ صلب"},{"id":"d","text":"الزيت جسمٌ غازيّ"}]'::jsonb, 'b', 'السكر ينحلّ في الماء فلا نراه، لكنّه باقٍ لأنّنا نتذوّقه؛ والانحلال غير الانصهار.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('686a98af-a9c0-5fc3-a21c-f9c215d9a5bf', '7fb3f737-9068-51ce-9269-6c07e3b3bee5', 'eveil-scientifique-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل المادّة', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('9225cdb1-062f-5689-b4e5-a7604e76a669', '686a98af-a9c0-5fc3-a21c-f9c215d9a5bf', 'وضعنا ملحًا في حساءٍ فاختفى، لكنّ الحساء صار مالحًا. ماذا حدث للملح؟', '[{"id":"a","text":"انحلّ في الماء وبقي موجودًا فنتذوّقه"},{"id":"b","text":"احترق واختفى تمامًا"},{"id":"c","text":"تبخّر وصار غازًا"},{"id":"d","text":"تجمّد في قعر الإناء"}]'::jsonb, 'a', 'الملح انحلّ في ماء الحساء فاختفى من نظرنا، لكنّه باقٍ لأنّنا نتذوّق ملوحته. الخطأ الشائع هو الظنّ أنّه احترق أو تبخّر.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7a00d17-ae24-5575-847c-674a45d8bb03', '686a98af-a9c0-5fc3-a21c-f9c215d9a5bf', 'لماذا نقول إنّ بخار الماء غازٌ مع أنّنا نرى «بخارًا» أبيض فوق القدر؟', '[{"id":"a","text":"لأنّ البخار الأبيض هو الغاز نفسه"},{"id":"b","text":"لأنّ بخار الماء له لونٌ أبيض دائمًا"},{"id":"c","text":"لأنّ بخار الماء غازٌ شفّافٌ لا نراه، والأبيض قطراتُ ماءٍ صغيرة"},{"id":"d","text":"لأنّ الماء لا يتبخّر أبدًا"}]'::jsonb, 'c', 'بخار الماء غازٌ شفّافٌ لا نراه؛ ما نراه أبيض هو قطراتٌ صغيرة تكوّنت ببرودة البخار. الخطأ الشائع هو الخلط بين البخار الغازيّ وهذه القطرات.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('246b3f02-5740-5b43-a5d6-4f3764ca4e63', '686a98af-a9c0-5fc3-a21c-f9c215d9a5bf', 'تركنا كأس ماءٍ في غرفةٍ باردةٍ جدًّا طوال الليل. أيّ تحوّلٍ قد يحدث للماء؟', '[{"id":"a","text":"يتبخّر بسرعةٍ كبيرة"},{"id":"b","text":"ينحلّ في الكأس"},{"id":"c","text":"ينصهر"},{"id":"d","text":"يتجمّد ويصير جليدًا"}]'::jsonb, 'd', 'بانخفاض الحرارة الشديد يتجمّد الماء السائل ويصير جليدًا صلبًا. الخطأ الشائع هو ذكر الانصهار، وهو عكس التجمّد ويحتاج حرارة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f4f9c4f-4783-5502-aaac-67c664ac01fd', '686a98af-a9c0-5fc3-a21c-f9c215d9a5bf', 'في دورة الماء، ما الدور الذي تقوم به الشمس؟', '[{"id":"a","text":"تجمّد ماء البحر فيصير جليدًا"},{"id":"b","text":"تُسخّن ماء البحر فيتبخّر ويرتفع"},{"id":"c","text":"تُنزل المطر مباشرةً"},{"id":"d","text":"تحلّ السكر في البحر"}]'::jsonb, 'b', 'حرارة الشمس تبخّر ماء البحر فيرتفع البخار، وهذه أوّل خطوةٍ في دورة الماء. الخطأ الشائع هو نسبة التجمّد أو المطر مباشرةً إلى الشمس.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9aceddaa-5d98-5cb1-91d0-8087414a2222', '686a98af-a9c0-5fc3-a21c-f9c215d9a5bf', 'في الصورة دورة الماء: الشمس فوق البحر وسحابةٌ ومطر. ما التحوّل الذي يكوّن السحابة في الأعلى؟ <svg viewBox="0 0 230 140" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="230" height="140" fill="#fdfdfd" stroke="#cccccc" stroke-width="1"/><circle cx="34" cy="28" r="14" fill="#ffd23f" stroke="#e0a400" stroke-width="2"/><path d="M150 40 q-18 -18 -36 0 q-18 4 -6 20 l70 0 q12 -18 -8 -22 q-8 -6 -20 2 z" fill="#eef3f7" stroke="#7f8c99" stroke-width="2"/><g stroke="#3a8fd6" stroke-width="2"><line x1="118" y1="66" x2="114" y2="80"/><line x1="140" y1="66" x2="136" y2="82"/></g><rect x="0" y="104" width="230" height="36" fill="#3a8fd6" stroke="#1f6f8c" stroke-width="2"/><path d="M52 52 q8 -16 28 -22" fill="none" stroke="#1f6f8c" stroke-width="2" stroke-dasharray="5 4"/></svg>', '[{"id":"a","text":"تجمّد الماء على الأرض"},{"id":"b","text":"انحلال السكر في البحر"},{"id":"c","text":"برودة البخار في الأعلى فيتكوّن السحاب (إسالة)"},{"id":"d","text":"احتراق الهواء قرب الشمس"}]'::jsonb, 'c', 'البخار المتصاعد من البحر يبرد في الأعلى فيتحوّل إلى قطراتٍ تكوّن السحاب، وهذه إسالة. الخطأ الشائع هو نسبة تكوّن السحاب إلى التجمّد أو الانحلال.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7f9cf6b-b724-521f-a6cf-1e3f081ba0c5', '686a98af-a9c0-5fc3-a21c-f9c215d9a5bf', 'أيّ استنتاجٍ صحيحٍ عن تحوّلات المادّة؟', '[{"id":"a","text":"المادّة لا تتغيّر حالتها أبدًا"},{"id":"b","text":"الحرارة تنصهر وتبخّر، والبرودة تجمّد وتُسيل البخار"},{"id":"c","text":"كلّ التحوّلات تحتاج إلى تبريد"},{"id":"d","text":"الغاز يصير صلبًا بالتسخين"}]'::jsonb, 'b', 'ارتفاع الحرارة يسبّب الانصهار والتبخّر، وانخفاضها يسبّب التجمّد وإسالة البخار. الخطأ الشائع هو ظنّ أنّ كلّ التحوّلات تحتاج إلى التبريد أو الحرارة وحدها.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0099bc5b-c5d7-5600-94f3-a0100e6b62a0', '7fb3f737-9068-51ce-9269-6c07e3b3bee5', 'eveil-scientifique-3eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للمادّة', 3, 120, 30, 'boss', 'admin', 5)
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
  ('94a4b73d-b4cb-523e-8f7b-da6bf5fb7856', '0099bc5b-c5d7-5600-94f3-a0100e6b62a0', 'الهواء وبخار الماء هما مثالان على الحالة:', '[{"id":"a","text":"الصلبة"},{"id":"b","text":"السائلة"},{"id":"c","text":"المتجمّدة"},{"id":"d","text":"الغازيّة"}]'::jsonb, 'd', 'الهواء وبخار الماء غازان، فهما في الحالة الغازيّة التي تنتشر ولا نراها غالبًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5338537-24cc-54bb-96a7-9e444bebb6f0', '0099bc5b-c5d7-5600-94f3-a0100e6b62a0', 'تحوّل البخار (غاز) إلى ماءٍ سائلٍ عند البرودة اسمه:', '[{"id":"a","text":"التبخّر"},{"id":"b","text":"الإسالة"},{"id":"c","text":"الانصهار"},{"id":"d","text":"الانحلال"}]'::jsonb, 'b', 'تحوّل البخار إلى ماءٍ سائلٍ عند البرودة اسمه الإسالة (التكثيف)، مثل تكوّن السحاب.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc4e714e-3842-593b-ac3d-071959e95656', '0099bc5b-c5d7-5600-94f3-a0100e6b62a0', 'أيّ زوجٍ صحيحٌ بين الجسم وحالته؟', '[{"id":"a","text":"الخشب ← صلب"},{"id":"b","text":"الماء ← غاز"},{"id":"c","text":"الهواء ← سائل"},{"id":"d","text":"الحجر ← سائل"}]'::jsonb, 'a', 'الخشب جسمٌ صلب له شكلٌ ثابت. الخطأ الشائع هو الخلط، فالماء سائلٌ والهواء غازٌ والحجر صلب.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40371059-abbf-54c0-9c24-8b220a81416c', '0099bc5b-c5d7-5600-94f3-a0100e6b62a0', 'سخّنّا قطعة شمعٍ صلبةً فسالت وصارت سائلة. ما اسم هذا التحوّل؟', '[{"id":"a","text":"التجمّد"},{"id":"b","text":"الإسالة"},{"id":"c","text":"الانصهار"},{"id":"d","text":"التبخّر"}]'::jsonb, 'c', 'تحوّل الشمع الصلب إلى سائلٍ بمفعول الحرارة هو الانصهار، مثل الجليد والزبدة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b8dfdd51-9f05-53a1-b2de-7a042d96a6ea', '0099bc5b-c5d7-5600-94f3-a0100e6b62a0', 'أيّ عبارةٍ **خاطئة**؟', '[{"id":"a","text":"الماء يغلي عند تسخينٍ قويّ"},{"id":"b","text":"السكر ينصهر في الماء البارد بمفعول الحرارة"},{"id":"c","text":"الجليد ينصهر فيصير ماءً"},{"id":"d","text":"الماء يتجمّد فيصير جليدًا"}]'::jsonb, 'b', 'العبارة الخاطئة أنّ السكر ينصهر في الماء البارد؛ فالسكر ينحلّ لا ينصهر، والانصهار يحتاج حرارة. الخطأ الشائع هو الخلط بين الانحلال والانصهار.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d02269a-eb67-5976-8ed3-d6833285b628', '0099bc5b-c5d7-5600-94f3-a0100e6b62a0', 'في دورة الماء المتواصلة، بعد نزول المطر، ماذا يحدث للماء؟', '[{"id":"a","text":"يعود إلى البحر والأنهار فتبدأ الدورة من جديد"},{"id":"b","text":"يختفي تمامًا ولا يعود"},{"id":"c","text":"يتحوّل إلى حجر"},{"id":"d","text":"يصير هواءً للأبد"}]'::jsonb, 'a', 'بعد المطر يعود الماء إلى البحر والأنهار، ثمّ يتبخّر من جديد، فدورة الماء متواصلة لا تتوقّف.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('96bd545d-0cda-5a35-9471-6a39d0478849', '8f032ef5-65c4-571f-b649-55e38b021307', 'eveil-scientifique-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('bebc2234-923f-52cd-82ae-957a6f74c1c7', '96bd545d-0cda-5a35-9471-6a39d0478849', 'ما هو الحدث الدوريّ؟', '[{"id":"a","text":"حدثٌ يقع مرّةً واحدةً فقط"},{"id":"b","text":"حدثٌ يتكرّر بانتظامٍ كلّ مدّةٍ ثابتة"},{"id":"c","text":"حدثٌ لا يقع أبدًا"},{"id":"d","text":"حدثٌ يقع في أيّ وقتٍ بلا نظام"}]'::jsonb, 'b', 'الحدث الدوريّ هو حدثٌ يتكرّر بانتظامٍ كلّ مدّةٍ ثابتة، مثل تعاقب الليل والنهار.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b93f1ae-2bdd-5d91-809c-7bdbf2ba94d5', '96bd545d-0cda-5a35-9471-6a39d0478849', 'أيّ هذه حدثٌ غير دوريّ؟', '[{"id":"a","text":"تعاقب الليل والنهار"},{"id":"b","text":"الفصول الأربعة"},{"id":"c","text":"شروق الشمس كلّ صباح"},{"id":"d","text":"نزول المطر"}]'::jsonb, 'd', 'نزول المطر حدثٌ غير دوريّ لأنّه لا يتكرّر بانتظام، أمّا الباقي فيتكرّر بانتظام.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef2949b2-e908-5ab9-9948-be33a245082c', '96bd545d-0cda-5a35-9471-6a39d0478849', 'في الساعة الرمليّة، ماذا يسيل لقيس الزمن؟', '[{"id":"a","text":"الرمل"},{"id":"b","text":"الهواء"},{"id":"c","text":"النار"},{"id":"d","text":"الضوء"}]'::jsonb, 'a', 'في الساعة الرمليّة يسيل الرمل من خانةٍ إلى أخرى في مدّةٍ معلومة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe06cc87-acd5-5e0c-a21e-8cc9b4c70c1e', '96bd545d-0cda-5a35-9471-6a39d0478849', 'الساعة التي فيها عقاربُ تدور لتدلّ على الوقت هي:', '[{"id":"a","text":"الساعة الرمليّة"},{"id":"b","text":"الساعة المائيّة"},{"id":"c","text":"الساعة ذات العقارب"},{"id":"d","text":"الساعة الرقميّة"}]'::jsonb, 'c', 'الساعة ذات العقارب فيها عقاربُ تدور بانتظامٍ فوق وجهٍ مرقّمٍ لتدلّ على الوقت.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8a52ee6-d78b-5071-b38b-ca42b7c08c37', '96bd545d-0cda-5a35-9471-6a39d0478849', 'على ماذا تتعلّق مدّة نوسة النواس؟', '[{"id":"a","text":"على طول الخيط"},{"id":"b","text":"على كتلة الثقل المعلّق"},{"id":"c","text":"على لون الخيط"},{"id":"d","text":"على حجم الحديقة"}]'::jsonb, 'a', 'مدّة نوسة النواس تتعلّق بطول الخيط؛ كلّما طال الخيط طالت المدّة، ولا تتعلّق بكتلة الثقل.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('75a01912-e415-5960-82ee-a0a128618d2c', '8f032ef5-65c4-571f-b649-55e38b021307', 'eveil-scientifique-3eme', '⭐ تمرين: أتعرّف على الأحداث الدوريّة وأدوات الزمن', 1, 50, 10, 'practice', 'admin', 1)
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
  ('1fbec75e-a704-5dd6-81e9-decf6ca491f9', '75a01912-e415-5960-82ee-a0a128618d2c', 'أيّ هذه حدثٌ دوريّ يتكرّر بانتظام؟', '[{"id":"a","text":"انقطاع التيّار الكهربائي"},{"id":"b","text":"تعاقب الليل والنهار"},{"id":"c","text":"وقوع حادث"},{"id":"d","text":"سقوط كأسٍ على الأرض"}]'::jsonb, 'b', 'تعاقب الليل والنهار حدثٌ دوريّ لأنّه يتكرّر بانتظامٍ كلّ يوم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2df9b5d-7e25-5204-8ffc-eaeea21fe440', '75a01912-e415-5960-82ee-a0a128618d2c', 'في الساعة الرمليّة، يسيل الرمل من الخانة:', '[{"id":"a","text":"العلويّة إلى السفليّة"},{"id":"b","text":"السفليّة إلى العلويّة"},{"id":"c","text":"اليمنى إلى الأمام"},{"id":"d","text":"لا يسيل الرمل أبدًا"}]'::jsonb, 'a', 'في الساعة الرمليّة يسيل الرمل من الخانة العلويّة إلى الخانة السفليّة في مدّةٍ معلومة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62e50bdd-9bb2-5dee-8d30-7c449d7549ef', '75a01912-e415-5960-82ee-a0a128618d2c', 'كم دقيقةً في الساعة الواحدة؟', '[{"id":"a","text":"10 دقائق"},{"id":"b","text":"24 دقيقة"},{"id":"c","text":"60 دقيقة"},{"id":"d","text":"100 دقيقة"}]'::jsonb, 'c', 'في الساعة الواحدة 60 دقيقة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('117cf1e8-b045-5292-84cd-b2d016cda4bc', '75a01912-e415-5960-82ee-a0a128618d2c', 'الساعة التي تعرض الوقت بأرقامٍ في خانات بلا عقارب هي:', '[{"id":"a","text":"الساعة الرمليّة"},{"id":"b","text":"الساعة المائيّة"},{"id":"c","text":"الساعة ذات العقارب"},{"id":"d","text":"الساعة الرقميّة"}]'::jsonb, 'd', 'الساعة الرقميّة تعرض الوقت بأرقامٍ في خانات، وليست لها عقارب.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e80044f2-8b43-5ecf-9fd5-42e3f9a51f0d', '75a01912-e415-5960-82ee-a0a128618d2c', 'النواس هو جسمٌ معلّقٌ بخيطٍ:', '[{"id":"a","text":"يتأرجح بانتظام"},{"id":"b","text":"لا يتحرّك أبدًا"},{"id":"c","text":"يطير في الهواء"},{"id":"d","text":"يذوب في الماء"}]'::jsonb, 'a', 'النواس جسمٌ معلّقٌ بخيطٍ يتأرجح بانتظام، وحركته دوريّة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('74bb58a1-d55c-5729-82a6-f2c1b568db1b', '75a01912-e415-5960-82ee-a0a128618d2c', 'في هذه الساعة، أيّ عقربٍ يدلّ على الساعات؟ <svg viewBox="0 0 150 150" xmlns="http://www.w3.org/2000/svg"><circle cx="75" cy="75" r="62" fill="#ffffff" stroke="#1f2937" stroke-width="4"/><g font-size="13" fill="#1f2937" stroke="none"><text x="70" y="28">12</text><text x="118" y="80">3</text><text x="72" y="130">6</text><text x="26" y="80">9</text></g><line x1="75" y1="75" x2="75" y2="46" stroke="#e0533a" stroke-width="6"/><line x1="75" y1="75" x2="110" y2="75" stroke="#1f6f8c" stroke-width="3"/><circle cx="75" cy="75" r="5" fill="#1f2937" stroke="none"/></svg>', '[{"id":"a","text":"العقرب الطويل الأزرق"},{"id":"b","text":"لا يوجد عقربٌ للساعات"},{"id":"c","text":"العقرب القصير الأحمر"},{"id":"d","text":"الأرقام فقط"}]'::jsonb, 'c', 'العقرب القصير الأحمر يدلّ على الساعات، والعقرب الطويل يدلّ على الدقائق.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('68592c1d-a39c-5113-9346-c57e2163c2ca', '8f032ef5-65c4-571f-b649-55e38b021307', 'eveil-scientifique-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الزمن', 3, 120, 30, 'boss', 'admin', 2)
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
  ('1aeed83f-56bc-51ee-8c07-6f5881120cb7', '68592c1d-a39c-5113-9346-c57e2163c2ca', 'قال تلميذٌ: «نزول المطر حدثٌ دوريّ.» هل هو محقّ؟', '[{"id":"a","text":"نعم، لأنّه يقع كلّ يومٍ في الوقت نفسه"},{"id":"b","text":"نعم، لأنّ المطر يشبه الشمس"},{"id":"c","text":"لا نعرف أبدًا"},{"id":"d","text":"لا، لأنّ المطر لا يتكرّر بانتظام"}]'::jsonb, 'd', 'نزول المطر حدثٌ غير دوريّ لأنّه لا يتكرّر بانتظام. الخطأ الشائع هو عدّ كلّ حدثٍ يقع أحيانًا حدثًا دوريًّا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90622d31-50c9-5eee-976e-d678a3cb9193', '68592c1d-a39c-5113-9346-c57e2163c2ca', 'زادت أمل طول خيط النواس. ماذا يحدث لمدّة النوسة؟', '[{"id":"a","text":"تقصر المدّة"},{"id":"b","text":"تطول المدّة"},{"id":"c","text":"تتوقّف النوسة تمامًا"},{"id":"d","text":"لا يتغيّر شيءٌ أبدًا"}]'::jsonb, 'b', 'كلّما طال خيط النواس طالت مدّة النوسة. الخطأ الشائع هو الظنّ أنّ الطول لا يؤثّر.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a0d885a7-f1ba-5569-893b-55bab5414af8', '68592c1d-a39c-5113-9346-c57e2163c2ca', 'أيّ زوجٍ صحيحٌ بين الأداة وما يسيل فيها؟', '[{"id":"a","text":"الساعة المائيّة ← الماء"},{"id":"b","text":"الساعة الرمليّة ← الماء"},{"id":"c","text":"الساعة المائيّة ← الرمل"},{"id":"d","text":"الساعة الرقميّة ← الرمل"}]'::jsonb, 'a', 'الساعة المائيّة تعتمد سيلان الماء. الخطأ الشائع هو الخلط بينها وبين الساعة الرمليّة التي يسيل فيها الرمل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30ec4d72-c276-531d-b93a-93bc7a3e675f', '68592c1d-a39c-5113-9346-c57e2163c2ca', 'ضاعفت سلمى كتلة الثقل المعلّق بالنواس دون تغيير طول الخيط. ماذا يحدث لمدّة النوسة؟', '[{"id":"a","text":"تطول كثيرًا"},{"id":"b","text":"تقصر كثيرًا"},{"id":"c","text":"لا تتغيّر؛ المدّة تتعلّق بالطول لا بالكتلة"},{"id":"d","text":"يتوقّف النواس عن الحركة"}]'::jsonb, 'c', 'مدّة النوسة تتعلّق بطول الخيط لا بكتلة الثقل، فلا تتغيّر. الخطأ الشائع هو ربط المدّة بثقل الجسم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('afd3cfae-e1e5-5d30-8ddd-6596f27ac4ef', '68592c1d-a39c-5113-9346-c57e2163c2ca', 'أيّ مجموعةٍ كلّها أحداثٌ دوريّة؟', '[{"id":"a","text":"حادث سيّارة، نزول المطر، انقطاع الكهرباء"},{"id":"b","text":"الفصول الأربعة، أيّام الأسبوع، نبضات القلب"},{"id":"c","text":"نزول المطر، الفصول، الحادث"},{"id":"d","text":"انقطاع الكهرباء، الليل، الحادث"}]'::jsonb, 'b', 'الفصول الأربعة وأيّام الأسبوع ونبضات القلب كلّها تتكرّر بانتظام، فهي دوريّة. الخطأ الشائع هو إقحام حدثٍ غير دوريّ كنزول المطر أو الحادث.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f008e1e-c1b7-5659-8264-fd12930dd29d', '68592c1d-a39c-5113-9346-c57e2163c2ca', 'ساعةٌ تعرض «3:00» بأرقامٍ مضيئةٍ بلا أيّ عقرب. ما نوعها؟', '[{"id":"a","text":"ساعةٌ رقميّة"},{"id":"b","text":"ساعةٌ ذات عقارب"},{"id":"c","text":"ساعةٌ رمليّة"},{"id":"d","text":"ساعةٌ مائيّة"}]'::jsonb, 'a', 'الساعة الرقميّة تعرض الوقت بأرقامٍ بلا عقارب. الخطأ الشائع هو ظنّ أنّ كلّ ساعةٍ لها عقارب.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('35216c88-3439-5041-ae7c-a62ef9b71ad8', '8f032ef5-65c4-571f-b649-55e38b021307', 'eveil-scientifique-3eme', '⭐⭐ تمرين مراجعة: الزمن وأدوات قيسه', 2, 75, 15, 'practice', 'admin', 3)
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
  ('03a726a2-c4e3-5184-9ac7-fe76a69d483c', '35216c88-3439-5041-ae7c-a62ef9b71ad8', 'الفصول الأربعة (الخريف، الشتاء، الربيع، الصيف) حدثٌ:', '[{"id":"a","text":"غير دوريّ"},{"id":"b","text":"لا يتكرّر"},{"id":"c","text":"دوريّ يتكرّر كلّ سنة"},{"id":"d","text":"يقع مرّةً واحدةً فقط"}]'::jsonb, 'c', 'الفصول الأربعة حدثٌ دوريّ يتكرّر بالترتيب نفسه كلّ سنة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e27d87c-ddd9-52b5-8dcb-fff30dd5ee1b', '35216c88-3439-5041-ae7c-a62ef9b71ad8', 'ما أصغر وحدةٍ من هذه الوحدات لقيس الزمن؟', '[{"id":"a","text":"الثانية"},{"id":"b","text":"الساعة"},{"id":"c","text":"اليوم"},{"id":"d","text":"الدقيقة"}]'::jsonb, 'a', 'الثانية أصغر هذه الوحدات؛ الدقيقة فيها 60 ثانية والساعة فيها 60 دقيقة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('382b739a-e765-5e69-8959-310ac135ac28', '35216c88-3439-5041-ae7c-a62ef9b71ad8', 'الساعة المائيّة تقيس الزمن بـ:', '[{"id":"a","text":"دوران العقارب"},{"id":"b","text":"أرقامٍ مضيئة"},{"id":"c","text":"سيلان الرمل"},{"id":"d","text":"سيلان الماء"}]'::jsonb, 'd', 'الساعة المائيّة تعتمد سيلان الماء من إناءٍ إلى آخر لقيس مرور الزمن.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3edf0156-9b50-5ac5-9d2e-12dfcc04bd3a', '35216c88-3439-5041-ae7c-a62ef9b71ad8', 'ما الذي يجعل عقارب الساعة تقيس الزمن بشكلٍ صحيح؟', '[{"id":"a","text":"أنّها ملوّنة"},{"id":"b","text":"أنّها تدور بانتظام"},{"id":"c","text":"أنّها كبيرة الحجم"},{"id":"d","text":"أنّها تتوقّف كثيرًا"}]'::jsonb, 'b', 'عقارب الساعة تدور بانتظام، وهذا الانتظام هو ما يجعلها تقيس الزمن بشكلٍ صحيح.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eb1e7a8b-0bf0-5c82-a9e0-6125e9a6af40', '35216c88-3439-5041-ae7c-a62ef9b71ad8', 'تظهر الشمس في السماء والأرض مضيئة في هذه الصورة. أيّ وقتٍ تمثّل؟ <svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="0" width="200" height="110" fill="#cfeffd" stroke="#7fb8d6" stroke-width="2"/><circle cx="100" cy="45" r="24" fill="#ffd23f" stroke="#e0a400" stroke-width="2"/><g stroke="#e0a400" stroke-width="3"><line x1="100" y1="8" x2="100" y2="0"/><line x1="64" y1="45" x2="56" y2="45"/><line x1="136" y1="45" x2="144" y2="45"/></g><rect x="0" y="92" width="200" height="18" fill="#86c34a" stroke="#2f6b12" stroke-width="2"/></svg>', '[{"id":"a","text":"النهار"},{"id":"b","text":"منتصف الليل"},{"id":"c","text":"لا وقت"},{"id":"d","text":"الليل المظلم"}]'::jsonb, 'a', 'الشمس مشرقةٌ في سماءٍ زرقاءَ والأرض مضيئة، فهذا هو النهار.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac809e78-29e1-5773-b607-d6a014fbc303', '35216c88-3439-5041-ae7c-a62ef9b71ad8', 'أيّ عبارةٍ صحيحة؟', '[{"id":"a","text":"الساعة الرقميّة لها عقاربٌ تدور"},{"id":"b","text":"الرمل يسيل في الساعة المائيّة"},{"id":"c","text":"نزول المطر حدثٌ دوريّ"},{"id":"d","text":"تعاقب الليل والنهار حدثٌ دوريّ"}]'::jsonb, 'd', 'تعاقب الليل والنهار حدثٌ دوريّ يتكرّر بانتظام؛ أمّا الساعة الرقميّة فبلا عقارب، والماء يسيل في المائيّة، والمطر غير دوريّ.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0a1b5544-5073-5076-b802-6585ec7f0656', '8f032ef5-65c4-571f-b649-55e38b021307', 'eveil-scientifique-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل الزمن', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('6fc0dd27-6cf5-5ce8-a688-bc77ffc01ddd', '0a1b5544-5073-5076-b802-6585ec7f0656', 'لماذا نعدّ تعاقب الليل والنهار حدثًا دوريًّا؟', '[{"id":"a","text":"لأنّه يقع مرّةً واحدةً في العمر"},{"id":"b","text":"لأنّه يتكرّر بانتظامٍ كلّ يومٍ بالترتيب نفسه"},{"id":"c","text":"لأنّ الليل أطول من النهار دائمًا"},{"id":"d","text":"لأنّه لا يتكرّر أبدًا"}]'::jsonb, 'b', 'الحدث الدوريّ يتكرّر بانتظام، وتعاقب الليل والنهار يتكرّر كلّ يومٍ بالترتيب نفسه. الخطأ الشائع هو الخلط بين الدوريّ وغير الدوريّ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce04f13a-dfb2-507c-960d-3fc727230621', '0a1b5544-5073-5076-b802-6585ec7f0656', 'أراد فريقٌ قيس مدّة لعبةٍ قصيرةٍ بأداةٍ بسيطةٍ بلا كهرباء. أيّ أداةٍ تناسب؟', '[{"id":"a","text":"الساعة الرقميّة"},{"id":"b","text":"الهاتف المطفأ"},{"id":"c","text":"المصباح"},{"id":"d","text":"الساعة الرمليّة"}]'::jsonb, 'd', 'الساعة الرمليّة أداةٌ بسيطةٌ تعمل بسيلان الرمل بلا كهرباء، فتناسب قيس مدّةٍ قصيرة. الخطأ الشائع هو اختيار أداةٍ تحتاج إلى كهرباء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef200313-d428-5bfa-99d3-a2f003190f0e', '0a1b5544-5073-5076-b802-6585ec7f0656', 'نواسان: الأوّل خيطه طويل والثاني خيطه قصير، والثقل نفسه. أيّهما نوسته أطول مدّة؟', '[{"id":"a","text":"النواس ذو الخيط الطويل"},{"id":"b","text":"النواس ذو الخيط القصير"},{"id":"c","text":"هما متساويان دائمًا"},{"id":"d","text":"لا يتأرجح أيٌّ منهما"}]'::jsonb, 'a', 'كلّما طال الخيط طالت مدّة النوسة، فالنواس ذو الخيط الطويل نوسته أطول. الخطأ الشائع هو ربط المدّة بالثقل بدل الطول.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('41f98aa7-91f2-59ea-aaa7-8fed3d451a79', '0a1b5544-5073-5076-b802-6585ec7f0656', 'لماذا لا نعدّ انقطاع التيّار الكهربائي حدثًا دوريًّا؟', '[{"id":"a","text":"لأنّه يقع كلّ ساعةٍ بالضبط"},{"id":"b","text":"لأنّه يشبه شروق الشمس"},{"id":"c","text":"لأنّه يقع في أيّ وقتٍ ولا يتكرّر بانتظام"},{"id":"d","text":"لأنّه يقع كلّ سنةٍ مرّة"}]'::jsonb, 'c', 'انقطاع التيّار حدثٌ غير دوريّ لأنّه يقع في أيّ وقتٍ ولا يتكرّر بانتظام. الخطأ الشائع هو افتراض انتظامٍ غير موجود.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc373ef6-f681-5ce7-ae0c-b5765cffb74c', '0a1b5544-5073-5076-b802-6585ec7f0656', 'في الساعة الرمليّة في الصورة، أين معظم الرمل الآن؟ <svg viewBox="0 0 130 150" xmlns="http://www.w3.org/2000/svg"><g stroke="#7a4b12" stroke-width="3" fill="none"><line x1="25" y1="14" x2="105" y2="14"/><line x1="25" y1="136" x2="105" y2="136"/><path d="M32 16 L32 44 Q32 66 65 70 Q98 74 98 44 L98 16" fill="#dff1fb"/><path d="M32 134 L32 102 Q32 80 65 70 Q98 60 98 102 L98 134" fill="#dff1fb"/></g><path d="M40 110 Q40 86 65 78 Q90 86 90 110 z" fill="#e0a93c" stroke="none"/></svg>', '[{"id":"a","text":"في الخانة العلويّة"},{"id":"b","text":"في منتصف الخيط"},{"id":"c","text":"لا يوجد رمل"},{"id":"d","text":"في الخانة السفليّة"}]'::jsonb, 'd', 'الرمل الذهبيّ ظاهرٌ في الخانة السفليّة، فمعظمه نزل إلى الأسفل. الخطأ الشائع هو النظر إلى الخانة العلويّة الفارغة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73ea2e2f-f82a-5cb0-92f5-2da16b5a8ae1', '0a1b5544-5073-5076-b802-6585ec7f0656', 'أيّ استنتاجٍ صحيحٍ من درس الزمن؟', '[{"id":"a","text":"كلّ الأحداث دوريّة"},{"id":"b","text":"كلّ الساعات لها عقارب"},{"id":"c","text":"لكلّ ساعةٍ طريقتها في قيس مرور الزمن"},{"id":"d","text":"مدّة النوسة تتعلّق بثقل الجسم"}]'::jsonb, 'c', 'لكلّ أداةٍ طريقتها: الرمل، الماء، العقارب، الأرقام. الخطأ الشائع هو تعميمٌ خاطئٌ كأنّ كلّ الأحداث دوريّة أو كلّ الساعات لها عقارب.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('55970a5c-b424-5d01-bd3b-c128db47d5e4', '8f032ef5-65c4-571f-b649-55e38b021307', 'eveil-scientifique-3eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للزمن', 3, 120, 30, 'boss', 'admin', 5)
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
  ('09f6cd2a-d2e0-50b8-9726-7f6c1dfc9c10', '55970a5c-b424-5d01-bd3b-c128db47d5e4', 'نبضات القلب حدثٌ:', '[{"id":"a","text":"دوريّ يتكرّر بانتظام"},{"id":"b","text":"غير دوريّ"},{"id":"c","text":"يقع مرّةً واحدة"},{"id":"d","text":"لا يحدث أبدًا"}]'::jsonb, 'a', 'نبضات القلب تتكرّر بانتظام، فهي حدثٌ دوريّ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('04e2562e-fcfc-57e6-ac8e-2633c87145e3', '55970a5c-b424-5d01-bd3b-c128db47d5e4', 'كم ساعةً في اليوم الواحد؟', '[{"id":"a","text":"10 ساعات"},{"id":"b","text":"12 ساعة"},{"id":"c","text":"24 ساعة"},{"id":"d","text":"60 ساعة"}]'::jsonb, 'c', 'في اليوم الواحد 24 ساعة، تنقسم إلى ليلٍ ونهار.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('754c4f0a-32c2-5b30-8d80-0103f2fc7f1f', '55970a5c-b424-5d01-bd3b-c128db47d5e4', 'أيّ زوجٍ صحيحٌ بين الأداة وكيف تعمل؟', '[{"id":"a","text":"الساعة الرمليّة ← دوران العقارب"},{"id":"b","text":"الساعة ذات العقارب ← دوران العقارب بانتظام"},{"id":"c","text":"الساعة الرقميّة ← سيلان الماء"},{"id":"d","text":"الساعة المائيّة ← أرقامٌ مضيئة"}]'::jsonb, 'b', 'الساعة ذات العقارب تعمل بدوران عقاربها بانتظام؛ أمّا الرمليّة فبالرمل، والمائيّة بالماء، والرقميّة بالأرقام.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e457f10-79b4-5657-8255-8b111ca9285d', '55970a5c-b424-5d01-bd3b-c128db47d5e4', 'النواس يُستعمل لقيس الزمن لأنّ حركته:', '[{"id":"a","text":"عشوائيّةٌ بلا نظام"},{"id":"b","text":"تتوقّف فورًا"},{"id":"c","text":"سريعةٌ مرّةً وبطيئةٌ مرّة"},{"id":"d","text":"دوريّةٌ منتظمة"}]'::jsonb, 'd', 'حركة النواس دوريّةٌ منتظمة، لذلك يُستعمل لقيس الزمن في بعض الساعات.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a88b66a-18e1-5fc9-ba19-2350e7d67438', '55970a5c-b424-5d01-bd3b-c128db47d5e4', 'أيّ عبارةٍ **خاطئة**؟', '[{"id":"a","text":"الفصول الأربعة حدثٌ دوريّ"},{"id":"b","text":"الساعة الرمليّة يسيل فيها الرمل"},{"id":"c","text":"نزول المطر حدثٌ دوريّ منتظم"},{"id":"d","text":"الساعة ذات العقارب فيها عقاربُ تدور"}]'::jsonb, 'c', 'العبارة الخاطئة أنّ نزول المطر دوريّ منتظم؛ فهو حدثٌ غير دوريّ لا يتكرّر بانتظام.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc7316a2-d777-5186-92a0-02a09fc5ff2a', '55970a5c-b424-5d01-bd3b-c128db47d5e4', 'أردنا قيس مدّة سباقٍ بدقّةٍ بالثواني. أيّ أداةٍ أنسب؟', '[{"id":"a","text":"تقويم السنة"},{"id":"b","text":"ساعةٌ تعرض الثواني"},{"id":"c","text":"خريطة المدينة"},{"id":"d","text":"ميزان الحرارة"}]'::jsonb, 'b', 'لقيس مدّةٍ قصيرةٍ بالثواني تناسب ساعةٌ تعرض الثواني؛ أمّا التقويم فللأيّام وميزان الحرارة للحرارة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('80ad0229-378a-50e9-abf8-f4bf60a4dcaa', 'e1dd5afc-6c37-5ac3-ada1-73410f1f5b54', 'eveil-scientifique-3eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('20def9d6-7643-5922-8595-2f13f55031fa', '80ad0229-378a-50e9-abf8-f4bf60a4dcaa', 'ما القوّة؟', '[{"id":"a","text":"لونٌ من الألوان"},{"id":"b","text":"صوتٌ نسمعه"},{"id":"c","text":"دفعٌ أو جذب"},{"id":"d","text":"نوعٌ من الطعام"}]'::jsonb, 'c', 'القوّة هي دفعٌ (نُبعد الشيء) أو جذبٌ (نقرّب الشيء)، وليست الدفع وحده.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('704c050a-e2e0-56bf-9917-bc1d0300b31a', '80ad0229-378a-50e9-abf8-f4bf60a4dcaa', 'أضغط على إسفنجةٍ بيدي فيتغيّر شكلها. هذا أثرٌ من آثار:', '[{"id":"a","text":"القوّة"},{"id":"b","text":"اللون"},{"id":"c","text":"الصوت"},{"id":"d","text":"الرائحة"}]'::jsonb, 'a', 'تغيير شكل جسمٍ مثل الإسفنجة هو أحد آثار القوّة الظاهرة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2428a8a5-17e6-54c3-9db1-cdde1a4fc905', '80ad0229-378a-50e9-abf8-f4bf60a4dcaa', 'إذا تركتُ تفاحةً من يدي، إلى أين تسقط؟', '[{"id":"a","text":"نحو الأعلى"},{"id":"b","text":"تبقى معلّقةً في الهواء"},{"id":"c","text":"نحو اليمين"},{"id":"d","text":"نحو الأسفل، نحو الأرض"}]'::jsonb, 'd', 'تسقط الأجسام نحو الأسفل لأنّ جاذبيّة الأرض تجذبها إليها.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('baaccfcf-0fac-5ff3-8938-fee0c55db6ab', '80ad0229-378a-50e9-abf8-f4bf60a4dcaa', 'متى يحصل عملٌ بهذا المعنى؟', '[{"id":"a","text":"عندما ننام"},{"id":"b","text":"عندما تُحرّك قوّةٌ جسمًا، مثل رفع حقيبة"},{"id":"c","text":"عندما ننظر إلى جدارٍ ساكن"},{"id":"d","text":"عندما نسمع صوتًا"}]'::jsonb, 'b', 'يحصل عملٌ عندما تُحرّك قوّةٌ جسمًا، مثل رفع الحقيبة أو دفع العربة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25ee326a-ade3-52de-96ba-c9d5cb250d7f', '80ad0229-378a-50e9-abf8-f4bf60a4dcaa', 'أيّ هذه طاقةٌ نأخذها من الشمس؟', '[{"id":"a","text":"الطاقة الشمسيّة"},{"id":"b","text":"الطاقة الكهربائيّة"},{"id":"c","text":"طاقة الرياح"},{"id":"d","text":"طاقة الماء الجاري"}]'::jsonb, 'a', 'الطاقة الشمسيّة هي الطاقة التي نأخذها من الشمس، نستعملها للتدفئة والإنارة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('73db542a-f2bd-5dab-aa29-ec552ab04a61', 'e1dd5afc-6c37-5ac3-ada1-73410f1f5b54', 'eveil-scientifique-3eme', '⭐ تمرين: أتعرّف على القوّة والطاقة', 1, 50, 10, 'practice', 'admin', 1)
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
  ('03a1f1fc-3772-5860-acc9-4427618030e1', '73db542a-f2bd-5dab-aa29-ec552ab04a61', 'حين أشدّ الحبل نحوي، أقوم بـ:', '[{"id":"a","text":"دفع"},{"id":"b","text":"أكلٍ"},{"id":"c","text":"جذب"},{"id":"d","text":"نومٍ"}]'::jsonb, 'c', 'شدّ الشيء نحوي جذبٌ، وهو نوعٌ من القوّة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f74370e7-2274-5527-8507-8c75ed5de636', '73db542a-f2bd-5dab-aa29-ec552ab04a61', 'أدفع كرةً ساكنةً فتتحرّك. هذا أثرٌ من آثار القوّة هو:', '[{"id":"a","text":"تغيير لونها"},{"id":"b","text":"تحريك جسمٍ ساكن"},{"id":"c","text":"إصدار صوتٍ"},{"id":"d","text":"تغيير رائحتها"}]'::jsonb, 'b', 'تحريك جسمٍ ساكن مثل الكرة هو أحد آثار القوّة الظاهرة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bd116a31-8c7c-5e61-bfab-338e64dd138c', '73db542a-f2bd-5dab-aa29-ec552ab04a61', 'إذا تركتُ حجرًا من يدي، يسقط نحو:', '[{"id":"a","text":"الأسفل"},{"id":"b","text":"الأعلى"},{"id":"c","text":"اليمين"},{"id":"d","text":"اليسار"}]'::jsonb, 'a', 'تسقط الأجسام نحو الأسفل نحو الأرض بفعل جاذبيّة الأرض.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f32bf57d-3187-5058-b565-a869d4a89e2c', '73db542a-f2bd-5dab-aa29-ec552ab04a61', 'أيّ هذه طاقةٌ نأخذها من الكهرباء؟', '[{"id":"a","text":"طاقة الرياح"},{"id":"b","text":"الطاقة الشمسيّة"},{"id":"c","text":"طاقة الماء الجاري"},{"id":"d","text":"الطاقة الكهربائيّة"}]'::jsonb, 'd', 'الطاقة الكهربائيّة نأخذها من الكهرباء، بها يعمل المصباح والتلفاز.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb6821f3-d87c-57ac-8874-cd72ecd48dd9', '73db542a-f2bd-5dab-aa29-ec552ab04a61', 'أرفع حقيبةً عن الأرض. ماذا أنجزتُ؟', '[{"id":"a","text":"لونًا"},{"id":"b","text":"عملًا"},{"id":"c","text":"صوتًا"},{"id":"d","text":"رائحةً"}]'::jsonb, 'b', 'حين تُحرّك قوّتي الحقيبة وأرفعها، أكون قد أنجزتُ عملًا.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c64d8290-99af-590e-85af-abb126e01c26', '73db542a-f2bd-5dab-aa29-ec552ab04a61', 'في الصورة، ما القوّة التي تؤثّر في الكرة؟ <svg viewBox="0 0 220 120" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="96" width="220" height="24" fill="#86c34a" stroke="#2f6b12" stroke-width="2"/><circle cx="160" cy="78" r="18" fill="#e0533a" stroke="#7a2718" stroke-width="2"/><g stroke="#5a3210" stroke-width="2" fill="#f2c094"><ellipse cx="55" cy="78" rx="14" ry="20"/><rect x="68" y="73" width="34" height="11" rx="5"/></g><line x1="102" y1="78" x2="132" y2="78" stroke="#1f4e9c" stroke-width="4"/><polygon points="132,72 144,78 132,84" fill="#1f4e9c" stroke="none"/></svg>', '[{"id":"a","text":"دفعٌ يحرّك الكرة نحو الأمام"},{"id":"b","text":"جذبٌ يقرّب الكرة نحو اليد"},{"id":"c","text":"لا قوّة، الكرة ساكنة"},{"id":"d","text":"صوتٌ يخرج من الكرة"}]'::jsonb, 'a', 'السهم الأزرق يتّجه من اليد نحو الكرة بعيدًا، فهذه قوّة دفعٍ تحرّك الكرة نحو الأمام.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d0004ce2-57dd-5314-bd0e-e57140250779', 'e1dd5afc-6c37-5ac3-ada1-73410f1f5b54', 'eveil-scientifique-3eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد القوّة والطاقة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('18d5e77b-586d-5f72-8289-9a6d8a2d9a56', 'd0004ce2-57dd-5314-bd0e-e57140250779', 'قال طفلٌ: «القوّة هي الدفع فقط». ما الصواب؟', '[{"id":"a","text":"القوّة دفعٌ أو جذب"},{"id":"b","text":"القوّة هي الدفع فقط فعلًا"},{"id":"c","text":"القوّة هي الجذب فقط"},{"id":"d","text":"القوّة لونٌ"}]'::jsonb, 'a', 'الخطأ الشائع حصر القوّة في الدفع؛ القوّة دفعٌ أو جذب، فالجذب قوّةٌ أيضًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('968ee3f1-779b-52fa-984b-1dc7f008e1d5', 'd0004ce2-57dd-5314-bd0e-e57140250779', 'أضرب كرةً متحرّكةً فتغيّر طريقها نحو جهةٍ أخرى. أيّ أثرٍ للقوّة هذا؟', '[{"id":"a","text":"تغيير شكلها"},{"id":"b","text":"إيقافها تمامًا"},{"id":"c","text":"تغيير لونها"},{"id":"d","text":"تغيير اتجاه حركتها"}]'::jsonb, 'd', 'تغيير جهة الحركة هو أثر «تغيير اتجاه الحركة». الخطأ الشائع الخلط بينه وبين تغيير الشكل.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6493c15a-5401-5189-baf8-413b7ea6d5ae', 'd0004ce2-57dd-5314-bd0e-e57140250779', 'لماذا تسقط التفاحة نحو الأرض ولا تصعد نحو السماء؟', '[{"id":"a","text":"لأنّها خفيفة"},{"id":"b","text":"لأنّ الأرض تجذبها إليها بجاذبيّتها"},{"id":"c","text":"لأنّ الهواء يدفعها للأسفل"},{"id":"d","text":"لأنّها تحبّ الأرض"}]'::jsonb, 'b', 'الأجسام تسقط لأنّ جاذبيّة الأرض تجذبها. الخطأ الشائع قول إنّها تسقط «لأنّها ثقيلةٌ فقط».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b27b3d7-8476-5e2c-a686-07f06335627c', 'd0004ce2-57dd-5314-bd0e-e57140250779', 'دفعتُ جدارًا بكلّ قوّتي ولم يتحرّك. هل أنجزتُ عملًا بهذا المعنى؟', '[{"id":"a","text":"نعم، لأنّي تعبت"},{"id":"b","text":"نعم دائمًا"},{"id":"c","text":"لا، لأنّ الجدار لم يتحرّك"},{"id":"d","text":"لا أحد يعرف"}]'::jsonb, 'c', 'لا يحصل عملٌ بهذا المعنى إلّا إذا تحرّك الجسم. الخطأ الشائع الخلط بين التعب وبين العمل الفيزيائي.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a8e7c05c-e486-56d4-a4ef-e178b639ceee', 'd0004ce2-57dd-5314-bd0e-e57140250779', 'تدور مراوح الطاحونة الكبيرة من تلقاء نفسها في يومٍ عاصف. أيّ طاقةٍ حرّكتها؟', '[{"id":"a","text":"طاقة الغذاء"},{"id":"b","text":"الطاقة الشمسيّة"},{"id":"c","text":"طاقة الماء الجاري"},{"id":"d","text":"طاقة الرياح"}]'::jsonb, 'd', 'الرياح تدفع مراوح الطاحونة فتدور؛ هذه طاقة الرياح. الخطأ الشائع نسبتها للشمس مباشرة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8a72e7e8-6222-55ee-ba00-523feecd09d9', 'd0004ce2-57dd-5314-bd0e-e57140250779', 'قال طفلٌ: «الطاقة تُستعمل ثمّ تختفي تمامًا». ما الصواب؟', '[{"id":"a","text":"نعم، تختفي ولا تعود"},{"id":"b","text":"الطاقة لا تختفي بل تتحوّل من شكلٍ إلى آخر"},{"id":"c","text":"الطاقة لونٌ يزول"},{"id":"d","text":"الطاقة لا وجود لها"}]'::jsonb, 'b', 'الخطأ الشائع ظنّ أنّ الطاقة «تختفي»؛ هي تتحوّل من شكلٍ إلى آخر وتُستعمل لإنجاز عمل.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('856a0ddf-0b86-5dc0-8bdf-a058c10eba1e', 'e1dd5afc-6c37-5ac3-ada1-73410f1f5b54', 'eveil-scientifique-3eme', '⭐⭐ تمرين مراجعة: القوّة وآثارها والطاقة', 2, 75, 15, 'practice', 'admin', 3)
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
  ('ac1b3262-f41b-5319-9de4-42050f7ac52a', '856a0ddf-0b86-5dc0-8bdf-a058c10eba1e', 'حين أضغط على عجينةٍ فيتغيّر شكلها، فهذا أثرٌ للقوّة اسمه:', '[{"id":"a","text":"إيقاف جسمٍ متحرّك"},{"id":"b","text":"تحريك جسمٍ ساكن"},{"id":"c","text":"تغيير اتجاه الحركة"},{"id":"d","text":"تغيير شكل جسم"}]'::jsonb, 'd', 'تغيّر شكل العجينة عند الضغط هو أثر «تغيير شكل جسم».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b363fcc-12e1-5b6a-baa8-d91d75fb1c11', '856a0ddf-0b86-5dc0-8bdf-a058c10eba1e', 'أمسك كرةً جاريةً نحوي فتتوقّف. أيّ أثرٍ للقوّة هذا؟', '[{"id":"a","text":"إيقاف جسمٍ متحرّك"},{"id":"b","text":"تغيير لونه"},{"id":"c","text":"تكبيره"},{"id":"d","text":"إصدار صوتٍ"}]'::jsonb, 'a', 'إيقاف الكرة الجارية هو أثر «إيقاف جسمٍ متحرّك» من آثار القوّة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ac9def8-da52-5786-81b6-d1780c6c5611', '856a0ddf-0b86-5dc0-8bdf-a058c10eba1e', 'الطاقة هي:', '[{"id":"a","text":"لونٌ جميل"},{"id":"b","text":"صوتٌ عالٍ"},{"id":"c","text":"القدرة على إنجاز عملٍ أو إحداث تغيير"},{"id":"d","text":"نوعٌ من الحجر"}]'::jsonb, 'c', 'الطاقة هي القدرة على إنجاز عملٍ أو إحداث تغيير؛ بها تحصل الحركة والعمل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e8c0b191-8a83-5b98-8bfc-c5e15079c7ec', '856a0ddf-0b86-5dc0-8bdf-a058c10eba1e', 'الغذاء الذي نأكله يعطينا:', '[{"id":"a","text":"لونًا جديدًا"},{"id":"b","text":"طاقةً وقوّةً للحركة"},{"id":"c","text":"صوتًا"},{"id":"d","text":"جاذبيّةً"}]'::jsonb, 'b', 'في الغذاء طاقةٌ تعطينا القوّة لنتحرّك ونعمل.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78dc57aa-eb02-57d6-bf1e-04072f8129d1', '856a0ddf-0b86-5dc0-8bdf-a058c10eba1e', 'في الصورة، إلى أين تتحرّك التفاحة، ولماذا؟ <svg viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="110" width="200" height="20" fill="#9b6a3c" stroke="#5a3210" stroke-width="2"/><circle cx="100" cy="40" r="16" fill="#e0533a" stroke="#7a2718" stroke-width="2"/><path d="M100 25 q4 -8 9 -6" fill="none" stroke="#3d6b1e" stroke-width="2"/><line x1="100" y1="60" x2="100" y2="92" stroke="#1f4e9c" stroke-width="4"/><polygon points="94,92 100,104 106,92" fill="#1f4e9c" stroke="none"/></svg>', '[{"id":"a","text":"نحو الأسفل، لأنّ الأرض تجذبها بجاذبيّتها"},{"id":"b","text":"نحو الأعلى، لأنّها خفيفة"},{"id":"c","text":"تبقى ثابتةً في الهواء"},{"id":"d","text":"نحو اليمين، لأنّ الهواء يدفعها"}]'::jsonb, 'a', 'السهم الأزرق يتّجه نحو الأسفل، فالتفاحة تسقط نحو الأرض بفعل جاذبيّة الأرض.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6fc2a669-7307-54fb-a6ec-9f866d779bb4', '856a0ddf-0b86-5dc0-8bdf-a058c10eba1e', 'أيّ عبارةٍ صحيحة؟', '[{"id":"a","text":"القوّة هي الدفع فقط"},{"id":"b","text":"الأجسام تسقط نحو الأعلى"},{"id":"c","text":"للطاقة أنواعٌ مثل الشمسيّة والكهربائيّة وطاقة الرياح"},{"id":"d","text":"الطاقة تختفي ولا تعود أبدًا"}]'::jsonb, 'c', 'للطاقة أنواعٌ كثيرة منها الشمسيّة والكهربائيّة وطاقة الرياح؛ أمّا بقيّة العبارات فخاطئة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('46d04808-9815-5548-9820-b5e574995a63', 'e1dd5afc-6c37-5ac3-ada1-73410f1f5b54', 'eveil-scientifique-3eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: بطل القوّة والطاقة', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('7d994e1b-fc83-52dd-89c7-be275faa5ece', '46d04808-9815-5548-9820-b5e574995a63', 'لاعبٌ يركل كرةً ساكنةً فتنطلق بعيدًا. أيّ أثرين للقوّة ظهرا معًا؟', '[{"id":"a","text":"تغيير اللون وإصدار الصوت"},{"id":"b","text":"النوم والأكل"},{"id":"c","text":"تحريك جسمٍ ساكن وإعطاؤه اتجاهًا"},{"id":"d","text":"تغيير الرائحة وحدها"}]'::jsonb, 'c', 'الركل حرّك الكرة الساكنة وأعطاها اتجاهًا، وهذان أثران للقوّة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f087729-22c6-5b33-97a6-c3e74c557c37', '46d04808-9815-5548-9820-b5e574995a63', 'رائد فضاءٍ ترك قلمًا فوق سطح الأرض. لماذا سقط القلم نحو الأرض؟', '[{"id":"a","text":"لأنّ القلم خفيفٌ"},{"id":"b","text":"لأنّ جاذبيّة الأرض تجذبه نحوها"},{"id":"c","text":"لأنّ الهواء سحبه للأعلى"},{"id":"d","text":"لأنّ القلم يطير"}]'::jsonb, 'b', 'كلّ جسمٍ نتركه فوق الأرض تجذبه جاذبيّة الأرض نحوها. الخطأ الشائع ربط السقوط بالوزن وحده.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3722028e-0657-5485-9cff-bfc9315fcf50', '46d04808-9815-5548-9820-b5e574995a63', 'طفلان: الأوّل رفع صندوقًا ونقله، والثاني دفع جدارًا ثابتًا دون أن يتحرّك. من أنجز عملًا بهذا المعنى؟', '[{"id":"a","text":"الاثنان معًا"},{"id":"b","text":"لا أحد منهما"},{"id":"c","text":"الثاني فقط"},{"id":"d","text":"الأوّل فقط، لأنّ الصندوق تحرّك"}]'::jsonb, 'd', 'العمل يحصل عندما يتحرّك الجسم؛ الأوّل حرّك الصندوق فأنجز عملًا، والثاني لم يحرّك الجدار. الخطأ الشائع عدّ كلّ مجهودٍ عملًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b1cd3ee-f373-5bc8-afbe-589a44e5d19b', '46d04808-9815-5548-9820-b5e574995a63', 'نريد تشغيل مصباحٍ كهربائيٍّ في البيت. أيّ طاقةٍ نحتاج إليها مباشرةً؟', '[{"id":"a","text":"الطاقة الكهربائيّة"},{"id":"b","text":"طاقة الغذاء"},{"id":"c","text":"طاقة الرياح"},{"id":"d","text":"لا نحتاج إلى أيّ طاقة"}]'::jsonb, 'a', 'المصباح يضيء بالطاقة الكهربائيّة. الخطأ الشائع الخلط بين أنواع الطاقة وحاجة كلّ جهازٍ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f571a191-cd4e-5c64-a66b-c28cb412351d', '46d04808-9815-5548-9820-b5e574995a63', 'ساقيةٌ قديمةٌ تدور بفعل ماء النهر المتدفّق تحتها. أيّ طاقةٍ تحرّكها؟', '[{"id":"a","text":"الطاقة الشمسيّة"},{"id":"b","text":"طاقة الماء الجاري"},{"id":"c","text":"الطاقة الكهربائيّة"},{"id":"d","text":"طاقة الغذاء"}]'::jsonb, 'b', 'الماء الجاري يدفع الساقية فتدور؛ هذه طاقة الماء الجاري. الخطأ الشائع نسبتها للكهرباء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff7ace32-4e00-5e86-a320-8b8806db79c7', '46d04808-9815-5548-9820-b5e574995a63', 'أيّ استنتاجٍ صحيحٍ عن القوّة والطاقة؟', '[{"id":"a","text":"القوّة دفعٌ فقط، والطاقة تختفي بعد الاستعمال"},{"id":"b","text":"الأجسام تسقط نحو الأعلى، ولا قيمة للطاقة"},{"id":"c","text":"كلّ مجهودٍ عملٌ حتّى لو لم يتحرّك الجسم"},{"id":"d","text":"القوّة دفعٌ أو جذب، والطاقة تتحوّل لتُنجز عملًا"}]'::jsonb, 'd', 'القوّة دفعٌ أو جذب، والطاقة لا تختفي بل تتحوّل وتُستعمل لإنجاز عمل. الخطأ الشائع في بقيّة العبارات.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c898fcf9-4da5-5e2f-b2b6-d8de51a1a106', 'e1dd5afc-6c37-5ac3-ada1-73410f1f5b54', 'eveil-scientifique-3eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للقوّة والطاقة', 3, 120, 30, 'boss', 'admin', 5)
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
  ('7972576e-cd59-5896-b828-f0f435929a5b', 'c898fcf9-4da5-5e2f-b2b6-d8de51a1a106', 'الدفع والجذب نوعان من:', '[{"id":"a","text":"القوّة"},{"id":"b","text":"اللون"},{"id":"c","text":"الصوت"},{"id":"d","text":"الرائحة"}]'::jsonb, 'a', 'الدفع والجذب نوعان من القوّة؛ بهما نحرّك الأشياء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fce5859b-2b6b-5b37-b120-aa6c479ee844', 'c898fcf9-4da5-5e2f-b2b6-d8de51a1a106', 'الجسم الذي نتركه من أيدينا يسقط نحو:', '[{"id":"a","text":"الأعلى"},{"id":"b","text":"اليسار"},{"id":"c","text":"الأسفل نحو الأرض"},{"id":"d","text":"السماء"}]'::jsonb, 'c', 'الأجسام تسقط نحو الأسفل نحو الأرض بفعل جاذبيّة الأرض.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9248d9f-767b-5005-acd2-5e5145863319', 'c898fcf9-4da5-5e2f-b2b6-d8de51a1a106', 'أيّ زوجٍ صحيحٌ بين الطاقة ومصدرها؟', '[{"id":"a","text":"الطاقة الشمسيّة ← الكهرباء"},{"id":"b","text":"طاقة الرياح ← الغذاء"},{"id":"c","text":"طاقة الماء الجاري ← الشمس"},{"id":"d","text":"الطاقة الشمسيّة ← الشمس"}]'::jsonb, 'd', 'الطاقة الشمسيّة مصدرها الشمس؛ أمّا بقيّة الأزواج فمصادرها مخلوطة وخاطئة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e71cf5e5-b009-5f2e-852c-4a25ef2faca7', 'c898fcf9-4da5-5e2f-b2b6-d8de51a1a106', 'أيّ هذه أثرٌ من آثار القوّة؟', '[{"id":"a","text":"أن يتغيّر لون السماء وحده"},{"id":"b","text":"تغيير شكل الإسفنجة بالضغط عليها"},{"id":"c","text":"أن نسمع صوت العصفور"},{"id":"d","text":"أن نشمّ رائحة الوردة"}]'::jsonb, 'b', 'تغيير شكل الإسفنجة بالضغط أثرٌ من آثار القوّة، لا اللون ولا الصوت ولا الرائحة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('487602bf-b08c-5e0f-a623-7206f9cd5f85', 'c898fcf9-4da5-5e2f-b2b6-d8de51a1a106', 'في الصورة، أيّ طاقةٍ يعطينا إيّاها هذا المصدر؟ <svg viewBox="0 0 200 120" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="100" width="200" height="20" fill="#86c34a" stroke="#2f6b12" stroke-width="2"/><circle cx="100" cy="48" r="26" fill="#ffd23f" stroke="#e0a400" stroke-width="2"/><g stroke="#e0a400" stroke-width="4"><line x1="100" y1="10" x2="100" y2="0"/><line x1="100" y1="86" x2="100" y2="96"/><line x1="62" y1="48" x2="52" y2="48"/><line x1="138" y1="48" x2="148" y2="48"/><line x1="73" y1="21" x2="66" y2="14"/><line x1="127" y1="21" x2="134" y2="14"/></g></svg>', '[{"id":"a","text":"طاقة الماء الجاري"},{"id":"b","text":"طاقة الرياح"},{"id":"c","text":"الطاقة الشمسيّة"},{"id":"d","text":"طاقة الغذاء"}]'::jsonb, 'c', 'الصورة شمسٌ صفراء تشعّ، فالمصدر هو الشمس والطاقة طاقةٌ شمسيّة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a7688b1-5b4a-5bbf-882f-4f421e20ae85', 'c898fcf9-4da5-5e2f-b2b6-d8de51a1a106', 'أيّ عبارةٍ **خاطئة**؟', '[{"id":"a","text":"القوّة دفعٌ أو جذب"},{"id":"b","text":"الأجسام تسقط نحو الأرض بجاذبيّتها"},{"id":"c","text":"في الغذاء طاقةٌ تعطينا القوّة للحركة"},{"id":"d","text":"الطاقة تختفي تمامًا بعد استعمالها ولا تتحوّل"}]'::jsonb, 'd', 'العبارة الخاطئة أنّ الطاقة تختفي؛ فالطاقة لا تختفي بل تتحوّل من شكلٍ إلى آخر وتُستعمل.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

