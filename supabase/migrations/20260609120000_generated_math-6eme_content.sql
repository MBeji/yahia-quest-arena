-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: math-6eme (Mathématiques)
-- Regenerate with: npm run content:build
-- Source of truth: content/math-6eme/
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
  ('math-6eme', 'Mathématiques', 'الأنشطة العددية والهندسية وفق برنامج السنة السادسة من التعليم الأساسي', 'Force', 'subject-math', 'Calculator', 1, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '6eme-base'))
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
      AND e.subject_id = 'math-6eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('00d19597-764d-52d9-a251-b593748864e5', 'f5f5f9ba-119e-5573-aa31-919b7d4096c9', '526022da-43ba-5351-ba7f-22c88e20e9d0', 'f4a93be4-a45e-51bb-b489-da4495be783c', 'c4eeac9c-c565-5372-9aee-3936c295ea57', 'ad0e9663-0007-5000-9794-25df8c84deba', '38cb57ce-5b76-59eb-ac86-848f51dcb206', '36458ae1-5720-57c3-ae10-7701ff5b033b', '926877d1-8237-5a1f-8721-491116245990', '127d99dc-4446-59de-bfbd-9b64faf60da6', 'fe8ec271-ad30-538a-83a5-ffe7d6af17fd', 'e52cb4de-b360-524e-8896-3d8b67143281', 'deb76850-b242-519d-809c-e9998c7f2770', 'fbdd0512-8ebd-5910-bb1a-58fa957d08a4', 'd105bead-e998-5ac0-b0d6-0ca32c89c527', '3d01f743-8203-5ebd-90f5-24242ba875d5', '743eab91-a3e3-5520-b302-cfc329defaed', '0bad960f-2dc0-5d4c-b838-15932cd66ea4', 'a95c3e05-4c70-5128-8b97-feb330d66b85', '31346851-9af1-5aa0-a155-ce3c8d695c06', 'ae3df9d3-e85a-5323-9016-50bb23cfac15', '49fe9df7-5caf-5b0e-b663-420fe36538e9', 'd7c2736d-bcb6-5fca-bbcc-aba8e3ef8b56', '4a2c69ad-81d9-58b0-8360-2d66b4059f1c', '1e0583ba-a078-5a68-9d41-d21e92695596', 'b5f96abc-7bc8-5080-8a07-7b5f2a4a66d9', '3ca33026-1c62-57af-8516-b812537d0890', 'eb9f4ee2-0390-5ee6-84e3-b308468242d5', 'cf561c79-89ef-5c68-a694-109fa8757ffe', 'd64e0895-226f-5946-9bdf-1a5043be059b', '8c2342bf-efa3-5c68-8bc5-193d8a151e8a', '3fc2ba1a-17ca-5bf7-8645-4f7215632ce6', '4f3cbe47-adf6-5785-a7d8-86290d23de6e', '1adfd6db-987b-5f3d-9f50-ce0f9617e616', 'd9283d1a-3333-521c-8f47-c45c7be98bc6', 'e76bc7bb-21a2-5224-95e6-fba8a4ee40ea', '71d12b76-cb55-5e95-b789-1ab7409bb5e5', '98e16949-9fa1-5142-a515-60609b29db22', '21f93031-9971-5d16-acc6-0aca031109c4', '2ac0e9fb-a3e6-5cfb-a2bd-a4b841953b7a', '8c975730-d176-5895-919b-8e6beca5349a', 'd7172df5-9cee-5b2c-84f5-f3b439a3ecbc', 'dd437d18-e094-527b-ac90-a895fcdafdbf', 'e6b8b779-1f3d-5082-b5ec-5451057b789b', 'c38f72be-d359-53c4-8887-09cde06a6f75', '9d6d0330-9acd-52fc-87e5-892b0126bf8f', '9fbb7e77-1260-541e-8bad-a163b5958f92', '5a7a9aa4-110c-52f3-b673-c5d00be318ca', '54739350-ffa2-5ba9-a65a-b60847c30da1', '3493d95b-62f5-5f12-a534-1db4cbcf0571', '9e8371b3-5149-586f-a707-23cf002d58ce', '0f69bf86-384b-5437-86a3-e705e3e3fecc', 'f5da61ea-240f-57ec-ba31-6f9dbdab8f44', 'b4e996c6-c44f-52c6-af52-84d8bd1b4b72', 'ee77ac92-8fcb-5d7c-936b-0ed234ff5825', 'dbc60349-b017-598d-807d-10b601dbdd39', '3d1a8275-ae4a-5b82-bc2a-a41b42919c29', 'e30fbd41-aad3-5906-8e86-090971c1c119', '1eadf3d5-726f-573d-86be-1e39f53ace11', 'fcc09621-0230-5e3a-a989-72ce5bfd2fe0', 'e9f6b3e6-fa62-5798-ae11-21d65b35c6e1', '21696cbe-46e3-5bc2-9ef3-1a6025a90eb7', '701b2ae9-4138-50d9-a674-307e8ca5b762', 'c88867d0-5689-5d77-9c23-87870bf9724e', 'b7fe90ef-9bfa-5e35-9716-fd2a08f48f93', 'abf9ecce-0b61-57bd-bc4f-716ac690da9d', 'e173d3f0-97ec-5b1a-9cde-b5a6c5b34354', '4cb712b2-6420-5273-92a8-636bd480e718', 'bac8dcf6-1ef7-532d-b2af-3615cd411571', '43e8de9b-7a6b-5c43-9003-c6cd624f4883', 'ebe3c4cf-8300-5afc-8091-f04257df50d0', '9d853d38-958d-5da7-b4ea-4285359d3ff1', 'f7703124-b2e4-58ea-a341-24537cddb38d', '8d8d8f76-7c6b-56c9-b46f-59e1e8aad48f', 'ba0ddd4f-fbbb-55f0-b63e-5524613bac7e', 'fb95195b-bc02-537f-8539-e08f6c54912d', '62e690fe-df51-578c-949c-0f9b5b0ec813', '8d10e742-f3e1-53eb-a312-4496149934a2', 'c566e9e2-a58e-59fd-b528-414cb0386bab', 'be819f90-2fb5-5437-a992-5cb557ba4ae9', 'c9400eac-f759-5f08-8786-c416b612d868', 'b8f4bdfa-f10c-5bf9-ab6e-0ac1d1f6e609', '750491f4-80c2-5133-b7d7-a65c2c4d1027', '8e9a7263-2f49-55c7-875e-fe916cce2f04', 'c986df9b-3cd9-5294-8a9f-6e65fa9b39df', 'a4347704-b9ad-56c6-8cfa-7a4165cccbc6', '6f6d1715-6a63-58f3-9f74-977996d509db', '05ca6a6c-4153-5542-a170-1bcc0771977f', '89c1f3f5-9e6e-50a1-b4ee-58dfb7b904e5', '7a4f72de-1002-5f3e-b74b-d88ff6c7d309', 'c9b0160e-2f7f-553c-b6af-e9dc7d4eb15d', 'e3b71df1-c4ce-5664-8078-c94f4ff55844', '0e751692-e5b8-5099-8bd0-2352b85bbe76', '26c8b66c-f729-56bc-966f-3df9fcbff9ff', '7dee8320-839f-5fe4-ad8f-470998da3c52', 'c9fa0100-a46c-5772-b37f-afac2e3b33ad', 'fec51fe1-7dcd-5824-a8df-17b5a0fb914e', '33f03489-a45f-57a2-afcd-a15a81b35bdc', 'ef266d1a-6161-547c-8204-03c3be1100a8', '0b412168-293a-5391-bf8c-b9833c4fd192', '0726e69a-7a56-51b2-a848-0661e057e5ca', '377fc039-0c3e-5b14-b784-091e8708dfa9', '53619adb-3619-59d5-b4d4-935988983931', 'aa874b1f-2fec-5a09-a5ff-973b401ffdc8', 'b5eecec4-158c-5cb1-93f0-29cfcbc5eea9', '4b71050d-3db5-5399-b889-18a6a2efc02c', '696b19c1-5508-5471-ad23-6fdff05d9d3a', '3959c1d4-3cd5-5e99-b354-852f068ebc8c', '4dbe40e3-2d2d-5df6-96c7-86ecff2ce348', '8cefde19-b8ed-5166-a9be-f411c673ff5a', '587e08ea-e4e4-5890-a038-cd213af0cef6', 'a0db2731-54fb-5698-88e1-a3964c4d6408', 'e5d980c8-bb36-52f8-b05e-ebfd74c33285', 'eb1bba88-a9e2-55b1-ab64-836e5a08d08e', '47cd180e-ccd9-529b-bc19-fd1fcb50e03b', 'fade13f8-48ef-5417-91c8-25de399dd92e', 'c5a9a2a8-0232-5eb6-b1f9-58afa0a13193', 'a56b66af-aa03-5dfa-9282-413bba823033', '0a19c59a-e7b2-59f5-bd48-f703c62b3dda', '9f49d10e-cdf0-580a-b856-4cb546e08dae', 'ba4b7bc0-3380-5acf-ad8c-00d7fe188fb7', '33794c7b-5756-51d6-bd29-ac562b5f524d', '2a4edece-63d3-5d43-9447-f39eb0f735e5', 'b1478cf7-e393-56ce-bc61-6ede1241e624', '1148cd5a-ff43-5543-ba87-37dab7ec7b10', '7eeba1f3-e268-574a-9a44-2f2bd7e7991c', '8278366d-19bd-57a5-913e-d327e5f246f1', 'd1cb1238-2857-5f3c-a54f-0f949169186c', '4d47c7e8-7d35-54c7-bb50-44a665dc0b49', '6dd056a1-40ce-5ea5-adab-3efc0276c046', 'b6016096-0d7e-5921-877e-4175c7dd73fc', 'ee24f024-33dd-51ec-a696-8aa5175d9379', '86f83bd5-40d2-5eb2-b626-cbe9554a6bc1', '5e4f542e-d4a7-5fb8-8c32-c3d204849e57', 'e00e5911-ebb7-5f98-8129-aeb1f92eb9e7', '8e16ce24-6152-58d5-83e7-0d74d573ebd2', 'e1cbbed0-0235-563a-a318-be48f3e27719', '1b040f70-98bb-5926-9a6c-dc0c0f2d1187', '5fc97db0-fce6-5ee0-8cf5-a6726593b10f', '8fa81e8e-6036-5db3-90bc-61e9933bc28b');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'math-6eme' AND source = 'admin' AND id NOT IN ('abf07a3b-2e3b-5b48-852f-88db3a74f5a3', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'd8796a14-723c-51d3-bffa-70c26cd05071', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', '18976b91-ff96-59d1-a3ce-a64c2a296941', '4db3938c-398e-57f1-882b-ff5738209293', '21a06d07-1051-5785-938c-9121379b506b', 'bff57037-e374-5ec1-9160-f01c540126a2', '83f29240-ec09-5f2e-acb7-a7fd24dc60e0', '4a4c8177-ef60-5749-8706-5939f4e501b0', 'cdc6e831-d84e-5649-bdab-c8b33cd56d48', '641e186f-24fd-5859-bfe4-18502c693f25', '28d9d688-de45-5fa4-8ffb-c2d974cb6dab', '0b2b3836-a5f1-51dd-b0ba-16c1b4aaa4e9', '220a9082-fd47-5d22-9ad6-3d6702260784', '470bdb5e-c10e-5473-a32a-a44e20af0213', 'a38b86bc-a302-5cbd-86db-bf51704d4015', 'be44ccc1-b8cf-53c4-be3e-de9ee5f962a6', '007979ed-95bd-5a8a-8e12-f36f45b25bec', '4b826140-6530-5adc-beb5-f821495d8429', 'b8ad17c5-86e1-590b-b27e-5c308de07b21', '0ef963f1-ebe2-57a2-9cdb-df1a1919e7e3');
DELETE FROM public.questions WHERE exercise_id IN ('abf07a3b-2e3b-5b48-852f-88db3a74f5a3', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'd8796a14-723c-51d3-bffa-70c26cd05071', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', '18976b91-ff96-59d1-a3ce-a64c2a296941', '4db3938c-398e-57f1-882b-ff5738209293', '21a06d07-1051-5785-938c-9121379b506b', 'bff57037-e374-5ec1-9160-f01c540126a2', '83f29240-ec09-5f2e-acb7-a7fd24dc60e0', '4a4c8177-ef60-5749-8706-5939f4e501b0', 'cdc6e831-d84e-5649-bdab-c8b33cd56d48', '641e186f-24fd-5859-bfe4-18502c693f25', '28d9d688-de45-5fa4-8ffb-c2d974cb6dab', '0b2b3836-a5f1-51dd-b0ba-16c1b4aaa4e9', '220a9082-fd47-5d22-9ad6-3d6702260784', '470bdb5e-c10e-5473-a32a-a44e20af0213', 'a38b86bc-a302-5cbd-86db-bf51704d4015', 'be44ccc1-b8cf-53c4-be3e-de9ee5f962a6', '007979ed-95bd-5a8a-8e12-f36f45b25bec', '4b826140-6530-5adc-beb5-f821495d8429', 'b8ad17c5-86e1-590b-b27e-5c308de07b21', '0ef963f1-ebe2-57a2-9cdb-df1a1919e7e3') AND id NOT IN ('00d19597-764d-52d9-a251-b593748864e5', 'f5f5f9ba-119e-5573-aa31-919b7d4096c9', '526022da-43ba-5351-ba7f-22c88e20e9d0', 'f4a93be4-a45e-51bb-b489-da4495be783c', 'c4eeac9c-c565-5372-9aee-3936c295ea57', 'ad0e9663-0007-5000-9794-25df8c84deba', '38cb57ce-5b76-59eb-ac86-848f51dcb206', '36458ae1-5720-57c3-ae10-7701ff5b033b', '926877d1-8237-5a1f-8721-491116245990', '127d99dc-4446-59de-bfbd-9b64faf60da6', 'fe8ec271-ad30-538a-83a5-ffe7d6af17fd', 'e52cb4de-b360-524e-8896-3d8b67143281', 'deb76850-b242-519d-809c-e9998c7f2770', 'fbdd0512-8ebd-5910-bb1a-58fa957d08a4', 'd105bead-e998-5ac0-b0d6-0ca32c89c527', '3d01f743-8203-5ebd-90f5-24242ba875d5', '743eab91-a3e3-5520-b302-cfc329defaed', '0bad960f-2dc0-5d4c-b838-15932cd66ea4', 'a95c3e05-4c70-5128-8b97-feb330d66b85', '31346851-9af1-5aa0-a155-ce3c8d695c06', 'ae3df9d3-e85a-5323-9016-50bb23cfac15', '49fe9df7-5caf-5b0e-b663-420fe36538e9', 'd7c2736d-bcb6-5fca-bbcc-aba8e3ef8b56', '4a2c69ad-81d9-58b0-8360-2d66b4059f1c', '1e0583ba-a078-5a68-9d41-d21e92695596', 'b5f96abc-7bc8-5080-8a07-7b5f2a4a66d9', '3ca33026-1c62-57af-8516-b812537d0890', 'eb9f4ee2-0390-5ee6-84e3-b308468242d5', 'cf561c79-89ef-5c68-a694-109fa8757ffe', 'd64e0895-226f-5946-9bdf-1a5043be059b', '8c2342bf-efa3-5c68-8bc5-193d8a151e8a', '3fc2ba1a-17ca-5bf7-8645-4f7215632ce6', '4f3cbe47-adf6-5785-a7d8-86290d23de6e', '1adfd6db-987b-5f3d-9f50-ce0f9617e616', 'd9283d1a-3333-521c-8f47-c45c7be98bc6', 'e76bc7bb-21a2-5224-95e6-fba8a4ee40ea', '71d12b76-cb55-5e95-b789-1ab7409bb5e5', '98e16949-9fa1-5142-a515-60609b29db22', '21f93031-9971-5d16-acc6-0aca031109c4', '2ac0e9fb-a3e6-5cfb-a2bd-a4b841953b7a', '8c975730-d176-5895-919b-8e6beca5349a', 'd7172df5-9cee-5b2c-84f5-f3b439a3ecbc', 'dd437d18-e094-527b-ac90-a895fcdafdbf', 'e6b8b779-1f3d-5082-b5ec-5451057b789b', 'c38f72be-d359-53c4-8887-09cde06a6f75', '9d6d0330-9acd-52fc-87e5-892b0126bf8f', '9fbb7e77-1260-541e-8bad-a163b5958f92', '5a7a9aa4-110c-52f3-b673-c5d00be318ca', '54739350-ffa2-5ba9-a65a-b60847c30da1', '3493d95b-62f5-5f12-a534-1db4cbcf0571', '9e8371b3-5149-586f-a707-23cf002d58ce', '0f69bf86-384b-5437-86a3-e705e3e3fecc', 'f5da61ea-240f-57ec-ba31-6f9dbdab8f44', 'b4e996c6-c44f-52c6-af52-84d8bd1b4b72', 'ee77ac92-8fcb-5d7c-936b-0ed234ff5825', 'dbc60349-b017-598d-807d-10b601dbdd39', '3d1a8275-ae4a-5b82-bc2a-a41b42919c29', 'e30fbd41-aad3-5906-8e86-090971c1c119', '1eadf3d5-726f-573d-86be-1e39f53ace11', 'fcc09621-0230-5e3a-a989-72ce5bfd2fe0', 'e9f6b3e6-fa62-5798-ae11-21d65b35c6e1', '21696cbe-46e3-5bc2-9ef3-1a6025a90eb7', '701b2ae9-4138-50d9-a674-307e8ca5b762', 'c88867d0-5689-5d77-9c23-87870bf9724e', 'b7fe90ef-9bfa-5e35-9716-fd2a08f48f93', 'abf9ecce-0b61-57bd-bc4f-716ac690da9d', 'e173d3f0-97ec-5b1a-9cde-b5a6c5b34354', '4cb712b2-6420-5273-92a8-636bd480e718', 'bac8dcf6-1ef7-532d-b2af-3615cd411571', '43e8de9b-7a6b-5c43-9003-c6cd624f4883', 'ebe3c4cf-8300-5afc-8091-f04257df50d0', '9d853d38-958d-5da7-b4ea-4285359d3ff1', 'f7703124-b2e4-58ea-a341-24537cddb38d', '8d8d8f76-7c6b-56c9-b46f-59e1e8aad48f', 'ba0ddd4f-fbbb-55f0-b63e-5524613bac7e', 'fb95195b-bc02-537f-8539-e08f6c54912d', '62e690fe-df51-578c-949c-0f9b5b0ec813', '8d10e742-f3e1-53eb-a312-4496149934a2', 'c566e9e2-a58e-59fd-b528-414cb0386bab', 'be819f90-2fb5-5437-a992-5cb557ba4ae9', 'c9400eac-f759-5f08-8786-c416b612d868', 'b8f4bdfa-f10c-5bf9-ab6e-0ac1d1f6e609', '750491f4-80c2-5133-b7d7-a65c2c4d1027', '8e9a7263-2f49-55c7-875e-fe916cce2f04', 'c986df9b-3cd9-5294-8a9f-6e65fa9b39df', 'a4347704-b9ad-56c6-8cfa-7a4165cccbc6', '6f6d1715-6a63-58f3-9f74-977996d509db', '05ca6a6c-4153-5542-a170-1bcc0771977f', '89c1f3f5-9e6e-50a1-b4ee-58dfb7b904e5', '7a4f72de-1002-5f3e-b74b-d88ff6c7d309', 'c9b0160e-2f7f-553c-b6af-e9dc7d4eb15d', 'e3b71df1-c4ce-5664-8078-c94f4ff55844', '0e751692-e5b8-5099-8bd0-2352b85bbe76', '26c8b66c-f729-56bc-966f-3df9fcbff9ff', '7dee8320-839f-5fe4-ad8f-470998da3c52', 'c9fa0100-a46c-5772-b37f-afac2e3b33ad', 'fec51fe1-7dcd-5824-a8df-17b5a0fb914e', '33f03489-a45f-57a2-afcd-a15a81b35bdc', 'ef266d1a-6161-547c-8204-03c3be1100a8', '0b412168-293a-5391-bf8c-b9833c4fd192', '0726e69a-7a56-51b2-a848-0661e057e5ca', '377fc039-0c3e-5b14-b784-091e8708dfa9', '53619adb-3619-59d5-b4d4-935988983931', 'aa874b1f-2fec-5a09-a5ff-973b401ffdc8', 'b5eecec4-158c-5cb1-93f0-29cfcbc5eea9', '4b71050d-3db5-5399-b889-18a6a2efc02c', '696b19c1-5508-5471-ad23-6fdff05d9d3a', '3959c1d4-3cd5-5e99-b354-852f068ebc8c', '4dbe40e3-2d2d-5df6-96c7-86ecff2ce348', '8cefde19-b8ed-5166-a9be-f411c673ff5a', '587e08ea-e4e4-5890-a038-cd213af0cef6', 'a0db2731-54fb-5698-88e1-a3964c4d6408', 'e5d980c8-bb36-52f8-b05e-ebfd74c33285', 'eb1bba88-a9e2-55b1-ab64-836e5a08d08e', '47cd180e-ccd9-529b-bc19-fd1fcb50e03b', 'fade13f8-48ef-5417-91c8-25de399dd92e', 'c5a9a2a8-0232-5eb6-b1f9-58afa0a13193', 'a56b66af-aa03-5dfa-9282-413bba823033', '0a19c59a-e7b2-59f5-bd48-f703c62b3dda', '9f49d10e-cdf0-580a-b856-4cb546e08dae', 'ba4b7bc0-3380-5acf-ad8c-00d7fe188fb7', '33794c7b-5756-51d6-bd29-ac562b5f524d', '2a4edece-63d3-5d43-9447-f39eb0f735e5', 'b1478cf7-e393-56ce-bc61-6ede1241e624', '1148cd5a-ff43-5543-ba87-37dab7ec7b10', '7eeba1f3-e268-574a-9a44-2f2bd7e7991c', '8278366d-19bd-57a5-913e-d327e5f246f1', 'd1cb1238-2857-5f3c-a54f-0f949169186c', '4d47c7e8-7d35-54c7-bb50-44a665dc0b49', '6dd056a1-40ce-5ea5-adab-3efc0276c046', 'b6016096-0d7e-5921-877e-4175c7dd73fc', 'ee24f024-33dd-51ec-a696-8aa5175d9379', '86f83bd5-40d2-5eb2-b626-cbe9554a6bc1', '5e4f542e-d4a7-5fb8-8c32-c3d204849e57', 'e00e5911-ebb7-5f98-8129-aeb1f92eb9e7', '8e16ce24-6152-58d5-83e7-0d74d573ebd2', 'e1cbbed0-0235-563a-a318-be48f3e27719', '1b040f70-98bb-5926-9a6c-dc0c0f2d1187', '5fc97db0-fce6-5ee0-8cf5-a6726593b10f', '8fa81e8e-6036-5db3-90bc-61e9933bc28b');
DELETE FROM public.chapters c WHERE c.subject_id = 'math-6eme' AND c.id NOT IN ('249c14a0-d837-5f73-a270-c9c1d16631a6', '9310fb78-4283-53ee-ba45-09d485c01ea7', '624b6711-ca18-5fe5-a97d-b61c69704e94', '5e4665db-9840-50b3-b4f6-d96a1c110a07') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', 'الأعداد الطبيعية', 'نظام العدّ العشري، قراءة وكتابة الأعداد الكبيرة، التفكيك، المقارنة والترتيب، والتدوير', '# ⚔️ الأعداد الطبيعية — بوّابة عالَم الأعداد

> 💡 «من يُتقن الأعداد الكبيرة يُمسك بأوّل مفاتيح الرياضيات.»

أهلًا بك أيّها البطل في أوّل بوّابة من مغامرة السنة السادسة. هنا تتعلّم كيف **تقرأ** و**تكتب** و**تُفكّك** و**تقارن** و**تُدوّر** الأعداد الطبيعية مهما كَبُرت — هذا سلاحك الأوّل قبل خوض بقيّة المعارك.

## 🏰 ما هي الأعداد الطبيعية؟

الأعداد الطبيعية هي الأعداد التي نَعُدّ بها: **0، 1، 2، 3، 4، …** وتستمرّ بلا نهاية. نرمز إلى مجموعتها بالرمز **ℕ**.

- لكلّ عدد طبيعي _عددٌ يليه_ (تالٍ): بعد 9 يأتي 10، وبعد 999 يأتي 1000.
- أصغر عدد طبيعي هو **0**، ولا يوجد **أكبر** عدد طبيعي.

## 🧮 نظام العدّ العشري: الأصناف والرتب

نكتب كلّ الأعداد باستعمال عشرة رموز فقط (من 0 إلى 9)، وتتعلّق قيمة الرقم بـ**موضعه** (رتبته). كلّ عشر وحدات من رتبةٍ تُكوّن وحدةً واحدة من الرتبة الأعلى.

| الرتبة | آحاد | عشرات | مئات | آلاف  | عشرات الآلاف | مئات الآلاف | ملايين    |
| ------ | ---- | ----- | ---- | ----- | ------------ | ----------- | --------- |
| قيمتها | 1    | 10    | 100  | 1 000 | 10 000       | 100 000     | 1 000 000 |

نُجمّع الأرقام في **أصناف** (ثلاثيّات) انطلاقًا من اليمين: صنف **الوحدات البسيطة**، ثمّ **الآلاف**، ثمّ **الملايين**، ثمّ **المليارات**.

## 🔮 قراءة وكتابة الأعداد الكبيرة

لقراءة عددٍ كبير: نُجمّع أرقامه ثلاثةً ثلاثةً انطلاقًا من اليمين، ثمّ نقرأ كلّ صنفٍ متبوعًا باسمه (مليار، مليون، ألف).

- _مثال:_ العدد 45 207 089 يُقرأ: «خمسة وأربعون مليونًا، ومئتان وسبعة آلاف، وتسعة وثمانون».

> 🗡️ عند الكتابة بالأرقام نترك **فراغًا صغيرًا** بين الأصناف (لا فاصلة): 1 250 000، حتّى تَسهُل القراءة.

## ⚡ تفكيك عدد

تفكيك عددٍ يعني كتابته **مجموعَ حاصلات ضربٍ** حسب رتب أرقامه:

$$45\ 207 = 4\times10\,000 + 5\times1\,000 + 2\times100 + 0\times10 + 7\times1$$

- الرقم **0** في رتبةٍ يعني _لا شيء في تلك الرتبة_، لكنّه ضروريّ ليحفظ مواضع بقيّة الأرقام.

## 🛡️ المقارنة والترتيب

لمقارنة عددين طبيعيّين:

1. العدد ذو **عددِ الأرقام الأكبر** هو الأكبر (بعد إهمال الأصفار غير المفيدة على اليسار).
2. إذا تساوى عددُ الأرقام، نقارن **رقمًا رقمًا** من اليسار إلى اليمين عند أوّل اختلاف.

ثمّ نرتّب الأعداد **تصاعديًّا** (من الأصغر إلى الأكبر) أو **تنازليًّا** (العكس)، مستعملين الرموز < و > و =.

> ⚠️ الفخّ الشائع: الظنّ أنّ العدد ذا الأرقام الأكثر أكبرُ دائمًا دون الانتباه إلى الأصفار على اليسار، أو الخلط بين اتّجاهَي الرمزَين < و >.

## 📐 تدوير عدد (القيمة المقرّبة)

لتدوير عددٍ إلى رتبةٍ معيّنة (أقرب عشرة، مئة، ألف…):

- ننظر إلى الرقم الذي **يلي** الرتبة المطلوبة مباشرةً.
- إذا كان **5 أو أكثر** نُدوّر إلى الأعلى؛ وإذا كان **أقلّ من 5** نُبقي الرتبة كما هي، ثمّ نُعوّض كلّ ما بعدها أصفارًا.
- _مثال:_ تدوير 4 729 إلى أقرب **مئة**: الرقم بعد المئات هو 2 (أقلّ من 5) ⟸ النتيجة 4 700. وتدويره إلى أقرب **ألف**: الرقم بعد الآلاف هو 7 (≥ 5) ⟸ النتيجة 5 000.

> 🏆 لقد عبرت البوّابة الأولى! صرت تتحكّم في الأعداد الطبيعية الكبيرة قراءةً وكتابةً وتفكيكًا ومقارنةً وتدويرًا. استعدّ الآن لبوّابة العمليّات على هذه الأعداد.', '# 📜 ملخّص: الأعداد الطبيعية

- **الأعداد الطبيعية (ℕ):** 0، 1، 2، 3، … بلا نهاية؛ أصغرها 0 ولا أكبر لها، ولكلّ عددٍ تالٍ.
- **نظام العدّ العشري:** عشرة رموز (0–9)، وقيمة الرقم حسب رتبته؛ كلّ 10 وحداتٍ من رتبةٍ = وحدةٌ من الرتبة الأعلى.
- **الأصناف:** نُجمّع الأرقام ثلاثيّاتٍ من اليمين: الوحدات، الآلاف، الملايين، المليارات.
- **القراءة والكتابة:** نقرأ كلّ صنفٍ متبوعًا باسمه؛ ونكتب بفراغٍ صغير بين الأصناف (1 250 000).
- **التفكيك:** كتابة العدد مجموعَ حاصلات ضربٍ حسب الرتب، مثل 45 207 = 4×10000 + 5×1000 + 2×100 + 7.
- **المقارنة:** الأكثر أرقامًا أكبر (بعد إهمال أصفار اليسار)، وعند التساوي نقارن رقمًا رقمًا من اليسار.
- **الترتيب:** تصاعديًّا (الأصغر ← الأكبر) أو تنازليًّا، بالرموز < و > و =.
- **التدوير:** ننظر إلى الرقم التالي للرتبة: إن كان ≥ 5 نُدوّر إلى الأعلى وإلّا نُبقيها، ونعوّض ما بعدها أصفارًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('9310fb78-4283-53ee-ba45-09d485c01ea7', 'math-6eme', 'العمليّات على الأعداد الطبيعية', 'الجمع والطرح والضرب والقسمة الإقليدية: المصطلحات والخاصّيات وترتيب إجراء العمليّات', '# ⚔️ العمليّات على الأعداد الطبيعية — أسلحةُ الحساب الأربعة

> 💡 «الجمعُ والطرحُ والضربُ والقسمةُ: أربعةُ أسلحةٍ بها تُحَلُّ كلُّ المسائل.»

في البوّابة الأولى تعلّمتَ قراءةَ الأعداد الطبيعية وكتابتها. الآن تتعلّم كيف **تحسبُ** بها: تجمع، وتطرح، وتضرب، وتقسم — مع إتقان مصطلحاتِ كلِّ عمليّةٍ وخاصّياتها وترتيبِ إجرائها.

## ➕ الجمع

في الجمع نسمّي الأعدادَ المجموعةَ **الحدودَ**، ونسمّي نتيجتَها **المجموعَ**.

- _مثال:_ في 2 458 + 367 = 2 825، العددان 2 458 و 367 حَدّان، و 2 825 هو المجموع.
- **خاصّيات الجمع:** تبديليّ (a + b = b + a)، وتجميعيّ، و **0** عنصرٌ محايد (a + 0 = a).
- **تقنية:** نرصُّ الأرقامَ حسب رتبها (الآحاد تحت الآحاد…) ونجمع من اليمين إلى اليسار مع **الاحتفاظ** كلّما تجاوز مجموعُ رتبةٍ العددَ 9.

## ➖ الطرح

في الطرح نطرح **المطروحَ** من **المطروح منه** فنحصل على **الفرق**.

- _مثال:_ 5 030 − 1 476 = 3 554.
- الطرح **ليس تبديليًّا**: عمومًا a − b ≠ b − a.
- الطرح عمليّةٌ عكسيّةٌ للجمع: إذا كان a − b = c فإنّ c + b = a (نتحقّق: 3 554 + 1 476 = 5 030).
- **تقنية:** نرصُّ حسب الرتب ونطرح من اليمين مع **الاستلاف** عند الحاجة.

> ⚠️ الفخّ الشائع: طرحُ الرقم الأصغر من الأكبر في كلّ رتبةٍ مهما كان موضعُهما، بدل **الاستلاف** من الرتبة الأعلى.

## ✖️ الضرب

في الضرب نسمّي العددين **عاملين**، ونسمّي نتيجتَهما **الجداءَ**.

- _مثال:_ 234 × 6 = 1 404.
- **خاصّيات الضرب:** تبديليّ، وتجميعيّ، و **1** عنصرٌ محايد (a × 1 = a)، و **0** ماحٍ (a × 0 = 0).
- **التوزيعيّة على الجمع:** a × (b + c) = a × b + a × c؛ مثال: 7 × 13 = 7 × 10 + 7 × 3 = 70 + 21 = 91.
- **الضربُ في 10 و 100 و 1000:** نضيف صفرًا أو صفرين أو ثلاثةً على يمين العدد: 25 × 100 = 2 500.

## ➗ القسمة الإقليدية

قِسمةُ عددٍ طبيعيّ a (المقسوم) على عددٍ طبيعيّ b غيرِ معدوم (المقسوم عليه) تُعطي **خارجًا** q و**باقيًا** r، حيث:

$$a = (b \times q) + r \quad\text{مع}\quad r < b$$

- _مثال:_ 47 ÷ 5: لدينا 47 = 5 × 9 + 2، فالخارجُ 9 والباقي 2 (لاحظ أنّ 2 < 5).
- إذا كان الباقي **0** كانت القسمةُ **تامّةً (ضبطًا)**: 72 ÷ 8 = 9 لأنّ 8 × 9 = 72.

> 🗡️ في القسمة الإقليدية يكون الباقي **دائمًا أصغرَ** من المقسوم عليه؛ فإن وجدتَ باقيًا أكبرَ من المقسوم عليه أو يساويه فالخارجُ غيرُ مكتمل.

## 🧭 ترتيبُ إجراء العمليّات

عند غياب الأقواس، نُجري **الضربَ والقسمةَ قبل** الجمعِ والطرح.

- _مثال:_ 3 + 4 × 2 = 3 + 8 = 11 (وليس 14).
- الأقواسُ تُغيّر الأولويّة: (3 + 4) × 2 = 7 × 2 = 14.

> 🏆 أتقنتَ الأسلحةَ الأربعة! صرتَ تحسب وتتحقّق وتحترم أولويّةَ العمليّات. استعدّ الآن لعالَم الأعداد العشرية.', '# 📜 ملخّص: العمليّات على الأعداد الطبيعية

- **الجمع:** حدودٌ → مجموع. تبديليّ وتجميعيّ، و 0 عنصرٌ محايد. نجمع حسب الرتب مع الاحتفاظ.
- **الطرح:** (مطروحٌ منه) − (مطروح) = الفرق. غيرُ تبديليّ، وهو عكسُ الجمع: a − b = c ⟺ c + b = a. نطرح مع الاستلاف.
- **الضرب:** عاملان → جداء. تبديليّ وتجميعيّ، 1 محايد و 0 ماحٍ، وتوزيعيّ على الجمع: a × (b + c) = a × b + a × c. الضربُ في 10 و 100 و 1000 يضيف الأصفار.
- **القسمة الإقليدية:** a = (b × q) + r مع r < b. الباقي 0 ⟺ قسمةٌ تامّة.
- **ترتيب العمليّات:** الضربُ والقسمةُ قبل الجمعِ والطرح؛ والأقواسُ أوّلًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('624b6711-ca18-5fe5-a97d-b61c69704e94', 'math-6eme', 'الأعداد العشرية', 'تركيب العدد العشريّ ورتبه (الأعشار، الأجزاء من المئة، الأجزاء من الألف)، القراءة والكتابة، التفكيك، المقارنة والترتيب، والتدوير', '# 🔢 الأعداد العشرية — أعدادٌ بين الأعداد الطبيعية

> 💡 «حين لا تكفي الأعدادُ الطبيعية، تأتي الأعدادُ العشرية لتملأَ ما بينها.»

العددُ العشريّ يتكوّن من **جزءٍ صحيحٍ** و**جزءٍ عشريّ** تفصل بينهما **الفاصلةُ**. ففي العدد 12,375: الجزءُ الصحيح هو 12، والجزءُ العشريّ هو 375.

## 🪜 رتبُ الجزء العشري

على يسار الفاصلة نجد رتبَ الأعداد الطبيعية (آحاد، عشرات…)، وعلى يمينها تتوالى الرتبُ العشرية:

| الرتبة | الأعشار | الأجزاء من المئة | الأجزاء من الألف |
| ------ | ------- | ---------------- | ---------------- |
| قيمتها | 0,1     | 0,01             | 0,001            |

- _مثال:_ في 4,286 الرقمُ 2 في رتبة **الأعشار**، و 8 في رتبة **الأجزاء من المئة**، و 6 في رتبة **الأجزاء من الألف**.

## 🔮 القراءة والكتابة

نقرأ الجزءَ الصحيح، ثمّ نقول «فاصل»، ثمّ نقرأ الجزءَ العشريّ متبوعًا باسم أصغرِ رتبةٍ فيه.

- _مثال:_ 7,5 يُقرأ «سبعة فاصل خمسة أعشار»، و 0,04 يُقرأ «أربعة أجزاء من المئة».

> 🗡️ إضافةُ أصفارٍ على **يمين** الجزء العشريّ لا تُغيّر قيمةَ العدد: 3,5 = 3,50 = 3,500. لكنّ إقحامَ صفرٍ بين الفاصلة والأرقام يُغيّره: 3,5 ≠ 3,05.

## ⚖️ تفكيكُ عددٍ عشريّ

$$12,375 = 12 + \frac{3}{10} + \frac{7}{100} + \frac{5}{1000}$$

أي 12,375 = 12 + 0,3 + 0,07 + 0,005.

## 🛡️ المقارنة والترتيب

لمقارنة عددين عشريّين:

1. نقارن **الجزأين الصحيحين** أوّلًا؛ الأكبرُ صحيحًا هو الأكبر.
2. عند تساوي الجزأين الصحيحين نقارن **الأعشار**، ثمّ **الأجزاء من المئة**، وهكذا رتبةً برتبة.

- _مثال:_ 6,7 > 6,68 لأنّ الجزأين الصحيحين متساويان (6 = 6) ثمّ الأعشار: 7 > 6.

> ⚠️ الفخّ الشائع: الظنُّ أنّ 6,68 > 6,7 «لأنّ فيه أرقامًا أكثر». عددُ الأرقام بعد الفاصلة لا يدلّ على الأكبر؛ نقارن رتبةً برتبة (ويُفيد مساواةُ الطول بإضافة الأصفار: 6,70 و 6,68).

## 📐 تدويرُ عددٍ عشريّ

لتدوير عددٍ عشريّ إلى رتبةٍ معيّنة ننظر إلى الرقم الذي **يليها** مباشرةً: إن كان 5 أو أكثر دوّرنا إلى الأعلى، وإلّا أبقينا الرتبةَ كما هي.

- _مثال:_ تدوير 3,47 إلى أقرب **عُشر**: الرقمُ بعد الأعشار هو 7 (≥ 5) ⟸ النتيجة 3,5.
- تدوير 12,83 إلى أقرب **وحدة**: الرقمُ بعد الوحدات هو 8 (≥ 5) ⟸ النتيجة 13.

> 🏆 صرتَ تقرأ الأعدادَ العشرية وتكتبها وتقارنها وتدوّرها. السلاحُ التالي: الجمعُ والطرحُ في مجموعة الأعداد العشرية.', '# 📜 ملخّص: الأعداد العشرية

- **التركيب:** جزءٌ صحيحٌ + فاصلة + جزءٌ عشريّ. رتبُ الجزء العشريّ: الأعشار (0,1)، الأجزاء من المئة (0,01)، الأجزاء من الألف (0,001).
- **الأصفار:** على يمين الجزء العشريّ لا تُغيّر القيمة (3,5 = 3,50)؛ بين الفاصلة والأرقام تُغيّرها (3,5 ≠ 3,05).
- **التفكيك:** 12,375 = 12 + 0,3 + 0,07 + 0,005.
- **المقارنة:** الجزءُ الصحيح أوّلًا، ثمّ رتبةً برتبة في الجزء العشريّ (نساوي الطولَ بأصفار). عددُ الأرقام بعد الفاصلة لا يدلّ على الأكبر.
- **التدوير:** ننظر إلى الرقم الذي يلي الرتبةَ المطلوبة: ≥ 5 نُدوّر صعودًا، وإلّا نُبقي.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('5e4665db-9840-50b3-b4f6-d96a1c110a07', 'math-6eme', 'الجمع والطرح في مجموعة الأعداد العشرية', 'تقنيةُ الجمع والطرح (الفاصلةُ تحت الفاصلة)، الإكمالُ بالأصفار، التقديرُ بالتدوير، الخاصّيات، وحلُّ المسائل', '# ➕➖ الجمع والطرح في مجموعة الأعداد العشرية

> 💡 «سرُّ الحساب العشريّ كلُّه في قاعدةٍ واحدة: الفاصلةُ تحت الفاصلة.»

تعلّمتَ قراءةَ الأعداد العشرية ومقارنتها. الآن تجمعها وتطرحها بالاعتماد على قاعدةٍ ذهبية: **نرصُّ الأعدادَ بحيث تكون الفاصلةُ تحت الفاصلة** (أي كلُّ رتبةٍ تحت نظيرتها).

## ➕ الجمع

1. نرصُّ الأعدادَ، الفاصلةُ تحت الفاصلة.
2. نُكمل بالأصفار على يمين الجزء العشريّ حتّى يتساوى عددُ الأرقام (لا يُغيّر ذلك القيم).
3. نجمع كالأعداد الطبيعية من اليمين مع الاحتفاظ، ونُنزل الفاصلةَ في مكانها.

- _مثال:_ 12,4 + 3,75 ⟸ نكتب 12,40 + 3,75 = 16,15.

## ➖ الطرح

نفس المبدأ: الفاصلةُ تحت الفاصلة، ونُكمل بالأصفار، ثمّ نطرح مع الاستلاف.

- _مثال:_ 9,2 − 4,65 ⟸ نكتب 9,20 − 4,65 = 4,55.

> ⚠️ الفخّ الشائع: محاذاةُ الأرقام إلى اليمين (آخرُ رقمٍ تحت آخرِ رقم) بدل محاذاة **الفاصلة**؛ فينتج جمعُ الأعشار مع الأجزاء من المئة وهو خطأ.

## 🧮 التقديرُ قبل الحساب

قبل الحساب الدقيق، نُقدّر النتيجةَ بتدوير الأعداد إلى أقرب وحدة؛ فإن ابتعد جوابُنا كثيرًا عن التقدير عرفنا أنّنا أخطأنا.

- _مثال:_ 12,4 + 3,75 ≈ 12 + 4 = 16، وهو قريبٌ من النتيجة الدقيقة 16,15. ✔

## 🛡️ خاصّياتٌ تنفعك

- الجمعُ في الأعداد العشرية **تبديليّ** و**تجميعيّ** تمامًا كالأعداد الطبيعية: يمكن تغييرُ ترتيب الحدود لتسهيل الحساب.
- _مثال:_ 2,5 + 6,8 + 7,5 = (2,5 + 7,5) + 6,8 = 10 + 6,8 = 16,8.

## 🗺️ حلُّ المسائل

في المسائل انتبه إلى وحدة القيس (دينار، متر، كيلوغرام…): اجمع أو اطرح الأعدادَ العشرية ثمّ اكتب الوحدةَ في الجواب.

- _مثال:_ اشترى دفترًا بـ 3,250 دينارًا وقلمًا بـ 1,80 دينارًا، ودفع بورقة 10 دنانير. الباقي = 10 − (3,250 + 1,80) = 10 − 5,05 = 4,95 دينارًا.

> 🏆 صرتَ تجمع وتطرح الأعدادَ العشرية بثقةٍ وتتحقّق بالتقدير. السلاحُ التالي في انتظارك: الضربُ والقسمةُ في مجموعة الأعداد العشرية.', '# 📜 ملخّص: الجمع والطرح في الأعداد العشرية

- **القاعدةُ الذهبية:** الفاصلةُ تحت الفاصلة (كلُّ رتبةٍ تحت نظيرتها)، ونُكمل بالأصفار على يمين الجزء العشريّ ليتساوى الطول.
- **الجمع:** نجمع من اليمين مع الاحتفاظ ونُنزل الفاصلة. مثال: 12,40 + 3,75 = 16,15.
- **الطرح:** نطرح مع الاستلاف، الفاصلةُ تحت الفاصلة. مثال: 9,20 − 4,65 = 4,55.
- **الخاصّيات:** الجمعُ تبديليّ وتجميعيّ — نُعيد ترتيب الحدود لتسهيل الحساب.
- **التقدير:** نُقدّر بالتدوير إلى أقرب وحدة للتحقّق من معقوليّة النتيجة.
- **المسائل:** احرص على كتابة وحدة القيس في الجواب.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('abf07a3b-2e3b-5b48-852f-88db3a74f5a3', '249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00d19597-764d-52d9-a251-b593748864e5', 'abf07a3b-2e3b-5b48-852f-88db3a74f5a3', 'ما أصغر عددٍ طبيعيّ؟', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"−1"},{"id":"d","text":"لا يوجد أصغر عددٍ طبيعيّ"}]'::jsonb, 'a', 'أصغر عددٍ طبيعيّ هو 0، ثمّ تتوالى الأعداد 1، 2، 3… بلا نهاية. أمّا −1 فليس عددًا طبيعيًّا لأنّه سالب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5f5f9ba-119e-5573-aa31-919b7d4096c9', 'abf07a3b-2e3b-5b48-852f-88db3a74f5a3', 'كيف نكتب بالأرقام العددَ «اثنا عشر ألفًا وخمسة»؟', '[{"id":"a","text":"12 050"},{"id":"b","text":"12 005"},{"id":"c","text":"1 205"},{"id":"d","text":"12 500"}]'::jsonb, 'b', 'اثنا عشر ألفًا = 12 000، وخمسة آحاد = 5، فيكون العدد 12 005 (مع صفرٍ في المئات وصفرٍ في العشرات للحفاظ على المواضع).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('526022da-43ba-5351-ba7f-22c88e20e9d0', 'abf07a3b-2e3b-5b48-852f-88db3a74f5a3', 'في العدد 38 461، ما رتبة الرقم 8؟', '[{"id":"a","text":"العشرات"},{"id":"b","text":"المئات"},{"id":"c","text":"الآلاف"},{"id":"d","text":"عشرات الآلاف"}]'::jsonb, 'c', 'ابتداءً من اليمين في 38 461: الرقم 1 آحاد، 6 عشرات، 4 مئات، 8 آلاف، 3 عشرات الآلاف. إذن الرقم 8 في رتبة الآلاف.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4a93be4-a45e-51bb-b489-da4495be783c', 'abf07a3b-2e3b-5b48-852f-88db3a74f5a3', 'ما العلاقة الصحيحة بين العددين 7 080 و 7 800؟', '[{"id":"a","text":"7 080 = 7 800"},{"id":"b","text":"7 080 > 7 800"},{"id":"c","text":"لا يمكن المقارنة"},{"id":"d","text":"7 080 < 7 800"}]'::jsonb, 'd', 'للعددين 4 أرقام؛ نقارن من اليسار: الآلاف متساوية (7 = 7)، ثمّ المئات: 0 < 8. إذن 7 080 < 7 800.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4eeac9c-c565-5372-9aee-3936c295ea57', 'abf07a3b-2e3b-5b48-852f-88db3a74f5a3', 'ما القيمة المقرّبة للعدد 3 472 إلى أقرب مئة؟', '[{"id":"a","text":"3 400"},{"id":"b","text":"3 500"},{"id":"c","text":"3 470"},{"id":"d","text":"3 000"}]'::jsonb, 'b', 'للتدوير إلى أقرب مئة ننظر إلى رقم العشرات: هو 7 (أكبر من أو يساوي 5)، فنُدوّر إلى الأعلى. إذن 3 472 يصبح 3 500.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('93a4884b-00bf-590a-8bb8-f45f9b7384e4', '249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', '⭐ تمرين: أوّل خطوات في عالَم الأعداد', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad0e9663-0007-5000-9794-25df8c84deba', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'في العدد 5 327، ما رتبة الرقم 3؟', '[{"id":"a","text":"الآحاد"},{"id":"b","text":"العشرات"},{"id":"c","text":"المئات"},{"id":"d","text":"الآلاف"}]'::jsonb, 'c', 'ابتداءً من اليمين في 5 327: الرقم 7 آحاد، 2 عشرات، 3 مئات، 5 آلاف. إذن الرقم 3 في رتبة المئات.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('38cb57ce-5b76-59eb-ac86-848f51dcb206', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'كيف يُقرأ العدد 4 060؟', '[{"id":"a","text":"أربعمئة وستّون"},{"id":"b","text":"أربعة آلاف وستّون"},{"id":"c","text":"أربعة آلاف وستّمئة"},{"id":"d","text":"أربعون ألفًا وستّون"}]'::jsonb, 'b', 'العدد 4 060 = 4 آلاف + 0 مئات + 6 عشرات + 0 آحاد، فيُقرأ «أربعة آلاف وستّون».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36458ae1-5720-57c3-ae10-7701ff5b033b', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'كيف نكتب بالأرقام العددَ «ثلاثمئة وسبعة»؟', '[{"id":"a","text":"307"},{"id":"b","text":"370"},{"id":"c","text":"3 007"},{"id":"d","text":"3 070"}]'::jsonb, 'a', 'ثلاثمئة = 300 وسبعة آحاد = 7، مع صفرٍ في رتبة العشرات، فيكون العدد 307.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('926877d1-8237-5a1f-8721-491116245990', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'أيّ تفكيكٍ يوافق العدد 2 503؟', '[{"id":"a","text":"2×100 + 5×10 + 3"},{"id":"b","text":"25×100 + 3"},{"id":"c","text":"2×1000 + 5×10 + 3"},{"id":"d","text":"2×1000 + 5×100 + 3"}]'::jsonb, 'd', 'العدد 2 503 = 2 آلاف + 5 مئات + 0 عشرات + 3 آحاد، أي 2×1000 + 5×100 + 3.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('127d99dc-4446-59de-bfbd-9b64faf60da6', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'أيّ الأعداد التالية هو الأكبر؟', '[{"id":"a","text":"9 100"},{"id":"b","text":"8 910"},{"id":"c","text":"8 099"},{"id":"d","text":"9 010"}]'::jsonb, 'a', 'نقارن رتبة الآلاف أوّلًا: 9 > 8 فيبقى المرشّحان 9 100 و 9 010؛ ثمّ المئات: 1 > 0، إذن الأكبر هو 9 100.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe8ec271-ad30-538a-83a5-ffe7d6af17fd', '93a4884b-00bf-590a-8bb8-f45f9b7384e4', 'ما العدد الطبيعيّ الذي يلي مباشرةً العددَ 6 999؟', '[{"id":"a","text":"6 998"},{"id":"b","text":"6 990"},{"id":"c","text":"7 000"},{"id":"d","text":"60 000"}]'::jsonb, 'c', 'العدد التالي مباشرةً يساوي العددَ زائد 1: 6 999 + 1 = 7 000.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d8796a14-723c-51d3-bffa-70c26cd05071', '249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', '⚔️ زعيم الفصل ⭐⭐⭐: تحدّي الأعداد الكبيرة', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e52cb4de-b360-524e-8896-3d8b67143281', 'd8796a14-723c-51d3-bffa-70c26cd05071', 'في العدد 7 254 130، ما رتبة الرقم 5؟', '[{"id":"a","text":"الآلاف"},{"id":"b","text":"عشرات الآلاف"},{"id":"c","text":"مئات الآلاف"},{"id":"d","text":"الملايين"}]'::jsonb, 'b', 'من اليمين في 7 254 130: 0 آحاد، 3 عشرات، 1 مئات، 4 آلاف، 5 عشرات الآلاف، 2 مئات الآلاف، 7 ملايين. إذن الرقم 5 في رتبة عشرات الآلاف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('deb76850-b242-519d-809c-e9998c7f2770', 'd8796a14-723c-51d3-bffa-70c26cd05071', 'كيف يُقرأ العدد 1 005 200؟', '[{"id":"a","text":"مليون وخمسمئة ألفٍ ومئتان"},{"id":"b","text":"مئة ألفٍ وخمسة آلاف ومئتان"},{"id":"c","text":"مليون وخمسة آلاف ومئتان"},{"id":"d","text":"مليون وخمسون ألفًا ومئتان"}]'::jsonb, 'c', 'نُجمّع الأرقام ثلاثيّاتٍ من اليمين: 1 (مليون) | 005 (خمسة آلاف) | 200 (مئتان). فيُقرأ «مليون وخمسة آلاف ومئتان».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fbdd0512-8ebd-5910-bb1a-58fa957d08a4', 'd8796a14-723c-51d3-bffa-70c26cd05071', 'ما الترتيب التصاعدي للأعداد: 4 050 ؛ 4 500 ؛ 4 005 ؛ 4 055؟', '[{"id":"a","text":"4 500 < 4 055 < 4 050 < 4 005"},{"id":"b","text":"4 005 < 4 050 < 4 055 < 4 500"},{"id":"c","text":"4 005 < 4 055 < 4 050 < 4 500"},{"id":"d","text":"4 050 < 4 005 < 4 055 < 4 500"}]'::jsonb, 'b', 'الآلاف متساوية (4)؛ نقارن المئات ثمّ العشرات: 4 005 ثمّ 4 050 ثمّ 4 055 ثمّ 4 500. الترتيب التصاعدي: 4 005 < 4 050 < 4 055 < 4 500.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d105bead-e998-5ac0-b0d6-0ca32c89c527', 'd8796a14-723c-51d3-bffa-70c26cd05071', 'ما القيمة المقرّبة للعدد 28 617 إلى أقرب ألف؟', '[{"id":"a","text":"28 000"},{"id":"b","text":"30 000"},{"id":"c","text":"29 000"},{"id":"d","text":"28 600"}]'::jsonb, 'c', 'للتدوير إلى أقرب ألف ننظر إلى رقم المئات: 6 (أكبر من أو يساوي 5)، فنُدوّر الآلاف إلى الأعلى: 28 617 يصبح 29 000.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d01f743-8203-5ebd-90f5-24242ba875d5', 'd8796a14-723c-51d3-bffa-70c26cd05071', 'حضر مباراةً 38 920 متفرّجًا. ما هذا العدد مقرّبًا إلى أقرب ألف؟', '[{"id":"a","text":"39 000"},{"id":"b","text":"38 000"},{"id":"c","text":"38 900"},{"id":"d","text":"40 000"}]'::jsonb, 'a', 'رقم المئات هو 9 (أكبر من أو يساوي 5) فنُدوّر الآلاف إلى الأعلى: 38 920 يصبح 39 000. الخطأ الشائع تدويرها نزولًا إلى 38 000.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('743eab91-a3e3-5520-b302-cfc329defaed', 'd8796a14-723c-51d3-bffa-70c26cd05071', 'ما أكبر عددٍ من أربعة أرقامٍ مختلفة نُكوّنه بالأرقام 7 و 0 و 5 و 2 (دون تكرار)؟', '[{"id":"a","text":"7 250"},{"id":"b","text":"2 750"},{"id":"c","text":"5 720"},{"id":"d","text":"7 520"}]'::jsonb, 'd', 'لأكبر قيمةٍ نضع الأرقام تنازليًّا من اليسار: 7 ثمّ 5 ثمّ 2 ثمّ 0، فيكون العدد 7 520.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('71e406d6-2a21-5b53-a2cc-fd4445e86f6e', '249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الأعداد الطبيعية', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0bad960f-2dc0-5d4c-b838-15932cd66ea4', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'في العدد 902 340، ما رتبة الرقم 9؟', '[{"id":"a","text":"الملايين"},{"id":"b","text":"مئات الآلاف"},{"id":"c","text":"عشرات الآلاف"},{"id":"d","text":"الآلاف"}]'::jsonb, 'b', 'في 902 340 الرقم 9 في أقصى اليسار، وهو في رتبة مئات الآلاف (قيمته 900 000).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a95c3e05-4c70-5128-8b97-feb330d66b85', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'كيف نكتب بالأرقام العددَ «مئتا ألفٍ وثلاثة»؟', '[{"id":"a","text":"200 300"},{"id":"b","text":"200 030"},{"id":"c","text":"200 003"},{"id":"d","text":"23 000"}]'::jsonb, 'c', 'مئتا ألفٍ = 200 000 وثلاثة آحاد = 3، مع أصفارٍ في بقيّة الرتب، فيكون العدد 200 003.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31346851-9af1-5aa0-a155-ce3c8d695c06', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'أيّ الأعداد التالية محصورٌ بين 5 000 و 6 000؟', '[{"id":"a","text":"4 950"},{"id":"b","text":"6 050"},{"id":"c","text":"5 500"},{"id":"d","text":"6 500"}]'::jsonb, 'c', 'العدد المحصور بين 5 000 و 6 000 يبدأ بالرقم 5 في رتبة الآلاف؛ من بين الخيارات هو 5 500.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae3df9d3-e85a-5323-9016-50bb23cfac15', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'ما الترتيب التنازلي للأعداد: 1 200 ؛ 1 020 ؛ 1 002 ؛ 1 220؟', '[{"id":"a","text":"1 002 > 1 020 > 1 200 > 1 220"},{"id":"b","text":"1 220 > 1 020 > 1 200 > 1 002"},{"id":"c","text":"1 200 > 1 220 > 1 020 > 1 002"},{"id":"d","text":"1 220 > 1 200 > 1 020 > 1 002"}]'::jsonb, 'd', 'الآلاف متساوية (1)؛ نقارن المئات ثمّ العشرات: الترتيب التنازلي هو 1 220 > 1 200 > 1 020 > 1 002.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49fe9df7-5caf-5b0e-b663-420fe36538e9', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'ما القيمة المقرّبة للعدد 7 486 إلى أقرب عشرة؟', '[{"id":"a","text":"7 490"},{"id":"b","text":"7 480"},{"id":"c","text":"7 500"},{"id":"d","text":"7 400"}]'::jsonb, 'a', 'للتدوير إلى أقرب عشرة ننظر إلى رقم الآحاد: 6 (أكبر من أو يساوي 5) فنُدوّر العشرات إلى الأعلى: 7 486 يصبح 7 490.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7c2736d-bcb6-5fca-bbcc-aba8e3ef8b56', '71e406d6-2a21-5b53-a2cc-fd4445e86f6e', 'قطع عدّاءٌ مسافة 8 750 مترًا. ما هذه المسافة مقرّبةً إلى أقرب مئة متر؟', '[{"id":"a","text":"8 700"},{"id":"b","text":"8 800"},{"id":"c","text":"8 750"},{"id":"d","text":"9 000"}]'::jsonb, 'b', 'رقم العشرات هو 5 (أكبر من أو يساوي 5) فنُدوّر المئات إلى الأعلى: 8 750 يصبح 8 800.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b386e00e-ef4e-56a2-be56-41de1a2a68db', '249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سادة الأعداد', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4a2c69ad-81d9-58b0-8360-2d66b4059f1c', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'ما القيمة التي يمثّلها الرقم 3 في العدد 6 308 152؟', '[{"id":"a","text":"3 000"},{"id":"b","text":"30 000"},{"id":"c","text":"300 000"},{"id":"d","text":"3 000 000"}]'::jsonb, 'c', 'الرقم 3 في 6 308 152 يقع في رتبة مئات الآلاف، فقيمته 3 × 100 000 = 300 000.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e0583ba-a078-5a68-9d41-d21e92695596', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'كيف يُقرأ العدد 40 007 030؟', '[{"id":"a","text":"أربعمئة مليونٍ وسبعة آلاف وثلاثون"},{"id":"b","text":"أربعون مليونًا وسبعة آلاف وثلاثون"},{"id":"c","text":"أربعون مليونًا وسبعون ألفًا وثلاثون"},{"id":"d","text":"أربعة ملايين وسبعة آلاف وثلاثون"}]'::jsonb, 'b', 'نُجمّع الأرقام ثلاثيّاتٍ من اليمين: 40 (أربعون مليونًا) | 007 (سبعة آلاف) | 030 (ثلاثون). إذن «أربعون مليونًا وسبعة آلاف وثلاثون».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5f96abc-7bc8-5080-8a07-7b5f2a4a66d9', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'ما أصغر عددٍ من خمسة أرقامٍ مختلفة (لا يبدأ بالصفر)؟', '[{"id":"a","text":"10 234"},{"id":"b","text":"01 234"},{"id":"c","text":"12 340"},{"id":"d","text":"10 000"}]'::jsonb, 'a', 'لا نبدأ بالصفر وإلّا صار العدد من 4 أرقام؛ نبدأ بأصغر رقمٍ غير الصفر (1) ثمّ نرتّب الباقي تصاعديًّا 0، 2، 3، 4، فنحصل على 10 234. أمّا 10 000 فأرقامه غير مختلفة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ca33026-1c62-57af-8516-b812537d0890', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'ما القيمة المقرّبة للعدد 6 970 إلى أقرب مئة؟', '[{"id":"a","text":"6 900"},{"id":"b","text":"6 970"},{"id":"c","text":"7 100"},{"id":"d","text":"7 000"}]'::jsonb, 'd', 'رقم العشرات 7 (أكبر من أو يساوي 5) فنُدوّر المئات إلى الأعلى؛ والمئات 9 تصبح 10 فيُحمل 1 إلى الآلاف: 6 970 يصبح 7 000. الخطأ الشائع كتابة 7 100 أو 6 900.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eb9f4ee2-0390-5ee6-84e3-b308468242d5', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'عند مقارنة عددٍ مكوّنٍ من 6 أرقام بعددٍ مكوّنٍ من 5 أرقام (كلاهما طبيعيّ بلا أصفارٍ على اليسار)، فالعدد ذو الـ6 أرقام:', '[{"id":"a","text":"أكبر دائمًا"},{"id":"b","text":"قد يكون أصغر"},{"id":"c","text":"قد يتساوى معه"},{"id":"d","text":"لا يمكن الجزم"}]'::jsonb, 'a', 'أصغر عددٍ من 6 أرقام هو 100 000، وأكبر عددٍ من 5 أرقام هو 99 999. وبما أنّ 100 000 > 99 999 فإنّ كلّ عددٍ من 6 أرقام أكبر من أيّ عددٍ من 5 أرقام.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf561c79-89ef-5c68-a694-109fa8757ffe', 'b386e00e-ef4e-56a2-be56-41de1a2a68db', 'كم عددًا طبيعيًّا محصورًا تمامًا بين 997 و 1 002؟', '[{"id":"a","text":"3"},{"id":"b","text":"5"},{"id":"c","text":"4"},{"id":"d","text":"6"}]'::jsonb, 'c', 'الأعداد المحصورة تمامًا بين 997 و 1 002 هي: 998، 999، 1 000، 1 001، أي 4 أعداد.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d6e81f7f-72d3-5c58-a1e5-9a5313f70749', '249c14a0-d837-5f73-a270-c9c1d16631a6', 'math-6eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للأعداد الطبيعية', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d64e0895-226f-5946-9bdf-1a5043be059b', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', 'ما العدد الطبيعيّ الذي يسبق مباشرةً العددَ 10 000؟', '[{"id":"a","text":"9 999"},{"id":"b","text":"10 001"},{"id":"c","text":"9 000"},{"id":"d","text":"1 000"}]'::jsonb, 'a', 'العدد السابق مباشرةً يساوي العددَ ناقص 1: 10 000 − 1 = 9 999.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c2342bf-efa3-5c68-8bc5-193d8a151e8a', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', 'كيف يُقرأ العدد 305 040؟', '[{"id":"a","text":"ثلاثمئة ألفٍ وخمسة آلاف وأربعون"},{"id":"b","text":"ثلاثة آلاف وخمسمئة وأربعون"},{"id":"c","text":"ثلاثمئة وخمسة آلاف وأربعون"},{"id":"d","text":"ثلاثمئة وخمسون ألفًا وأربعون"}]'::jsonb, 'c', 'نُجمّع الأرقام ثلاثيّاتٍ من اليمين: 305 آلاف | 040. والصنف 305 يُقرأ «ثلاثمئة وخمسة»، فيكون العدد «ثلاثمئة وخمسة آلاف وأربعون».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3fc2ba1a-17ca-5bf7-8645-4f7215632ce6', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', 'ما العدد الذي يساوي 3×100000 + 7×1000 + 4×10؟', '[{"id":"a","text":"370 040"},{"id":"b","text":"307 040"},{"id":"c","text":"307 400"},{"id":"d","text":"30 740"}]'::jsonb, 'b', '3×100000 = 300 000، و7×1000 = 7 000، و4×10 = 40. وبجمع القيم حسب الرتب نحصل على 307 040.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f3cbe47-adf6-5785-a7d8-86290d23de6e', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', 'ما الترتيب التنازلي للأعداد: 60 100 ؛ 6 100 ؛ 60 010 ؛ 16 000؟', '[{"id":"a","text":"6 100 > 16 000 > 60 010 > 60 100"},{"id":"b","text":"60 100 > 60 010 > 16 000 > 6 100"},{"id":"c","text":"60 010 > 60 100 > 16 000 > 6 100"},{"id":"d","text":"60 100 > 16 000 > 60 010 > 6 100"}]'::jsonb, 'b', 'العدد 6 100 وحده من 4 أرقام فهو الأصغر؛ وبين أعداد الـ5 أرقام: 60 100 > 60 010 (المئات 1 > 0) وكلاهما > 16 000 (يبدأ بـ1). الترتيب التنازلي: 60 100 > 60 010 > 16 000 > 6 100.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1adfd6db-987b-5f3d-9f50-ce0f9617e616', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', 'ما القيمة المقرّبة للعدد 149 500 إلى أقرب ألف؟', '[{"id":"a","text":"149 000"},{"id":"b","text":"149 500"},{"id":"c","text":"200 000"},{"id":"d","text":"150 000"}]'::jsonb, 'd', 'رقم المئات هو 5 (أكبر من أو يساوي 5) فنُدوّر الآلاف إلى الأعلى: 149 500 يصبح 150 000.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9283d1a-3333-521c-8f47-c45c7be98bc6', 'd6e81f7f-72d3-5c58-a1e5-9a5313f70749', 'ما أكبر عددٍ طبيعيّ تكون قيمتُه المقرّبة إلى أقرب مئة مساويةً لـ 500؟', '[{"id":"a","text":"599"},{"id":"b","text":"550"},{"id":"c","text":"549"},{"id":"d","text":"500"}]'::jsonb, 'c', 'الأعداد التي تُدوّر إلى 500 (أقرب مئة) محصورة من 450 إلى 549؛ أكبرها 549، لأنّ 550 تُدوّر صعودًا إلى 600.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('18976b91-ff96-59d1-a3ce-a64c2a296941', '9310fb78-4283-53ee-ba45-09d485c01ea7', 'math-6eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e76bc7bb-21a2-5224-95e6-fba8a4ee40ea', '18976b91-ff96-59d1-a3ce-a64c2a296941', 'ماذا نسمّي نتيجةَ عمليّة الضرب؟', '[{"id":"a","text":"المجموع"},{"id":"b","text":"الفرق"},{"id":"c","text":"الجداء"},{"id":"d","text":"الخارج"}]'::jsonb, 'c', 'نتيجةُ الضرب تُسمّى الجداء؛ أمّا المجموع فلِلجمع، والفرق للطرح، والخارج للقسمة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('71d12b76-cb55-5e95-b789-1ab7409bb5e5', '18976b91-ff96-59d1-a3ce-a64c2a296941', 'ما ناتجُ 348 + 256؟', '[{"id":"a","text":"604"},{"id":"b","text":"594"},{"id":"c","text":"504"},{"id":"d","text":"614"}]'::jsonb, 'a', 'نجمع حسب الرتب: 8 + 6 = 14 (نكتب 4 ونحتفظ بـ1)، ثمّ 4 + 5 + 1 = 10 (نكتب 0 ونحتفظ بـ1)، ثمّ 3 + 2 + 1 = 6. فالمجموع 604.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98e16949-9fa1-5142-a515-60609b29db22', '18976b91-ff96-59d1-a3ce-a64c2a296941', 'عند القسمة الإقليدية للعدد 38 على 7، ما الباقي؟', '[{"id":"a","text":"2"},{"id":"b","text":"4"},{"id":"c","text":"5"},{"id":"d","text":"3"}]'::jsonb, 'd', 'لدينا 7 × 5 = 35 و 38 = 35 + 3، فالخارجُ 5 والباقي 3 (3 < 7).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21f93031-9971-5d16-acc6-0aca031109c4', '18976b91-ff96-59d1-a3ce-a64c2a296941', 'ما قيمةُ 5 + 6 × 2؟', '[{"id":"a","text":"22"},{"id":"b","text":"17"},{"id":"c","text":"16"},{"id":"d","text":"13"}]'::jsonb, 'b', 'نُجري الضربَ أوّلًا: 6 × 2 = 12، ثمّ 5 + 12 = 17 (وليس 22).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ac0e9fb-a3e6-5cfb-a2bd-a4b841953b7a', '18976b91-ff96-59d1-a3ce-a64c2a296941', 'أيُّ مساواةٍ تُترجم خاصّيّةَ التوزيعيّة على الجمع؟', '[{"id":"a","text":"8 × (10 + 3) = 8 × 10 + 3"},{"id":"b","text":"8 × (10 + 3) = 8 × 10 + 8 × 3"},{"id":"c","text":"8 × (10 + 3) = 8 + 10 + 3"},{"id":"d","text":"8 × (10 + 3) = 8 × 13 + 8"}]'::jsonb, 'b', 'التوزيعيّة: a × (b + c) = a × b + a × c، إذن 8 × (10 + 3) = 8 × 10 + 8 × 3 = 80 + 24 = 104.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4db3938c-398e-57f1-882b-ff5738209293', '9310fb78-4283-53ee-ba45-09d485c01ea7', 'math-6eme', '⭐ تمرين: تدرّب على العمليّات الأربع', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c975730-d176-5895-919b-8e6beca5349a', '4db3938c-398e-57f1-882b-ff5738209293', 'ما ناتجُ 1 250 + 340؟', '[{"id":"a","text":"1 690"},{"id":"b","text":"1 590"},{"id":"c","text":"1 500"},{"id":"d","text":"1 290"}]'::jsonb, 'b', '1 250 + 340 = 1 590 (نجمع: 250 + 340 = 590 ثمّ نضيف الألف).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7172df5-9cee-5b2c-84f5-f3b439a3ecbc', '4db3938c-398e-57f1-882b-ff5738209293', 'ما ناتجُ 900 − 250؟', '[{"id":"a","text":"750"},{"id":"b","text":"550"},{"id":"c","text":"650"},{"id":"d","text":"1 150"}]'::jsonb, 'c', 'نطرح: 900 − 250 = 650 (نتحقّق بالجمع العكسيّ: 650 + 250 = 900).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dd437d18-e094-527b-ac90-a895fcdafdbf', '4db3938c-398e-57f1-882b-ff5738209293', 'ما ناتجُ 12 × 5؟', '[{"id":"a","text":"60"},{"id":"b","text":"65"},{"id":"c","text":"70"},{"id":"d","text":"17"}]'::jsonb, 'a', 'نضرب: 12 × 5 = 60، أي خمسُ مرّاتٍ العددَ 12 (12 + 12 + 12 + 12 + 12).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e6b8b779-1f3d-5082-b5ec-5451057b789b', '4db3938c-398e-57f1-882b-ff5738209293', 'ما خارجُ القسمة التامّة 64 ÷ 8؟', '[{"id":"a","text":"6"},{"id":"b","text":"7"},{"id":"c","text":"9"},{"id":"d","text":"8"}]'::jsonb, 'd', '8 × 8 = 64، إذن 64 ÷ 8 = 8 والباقي 0.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c38f72be-d359-53c4-8887-09cde06a6f75', '4db3938c-398e-57f1-882b-ff5738209293', 'ماذا نسمّي العددين اللذين نجمعهما؟', '[{"id":"a","text":"العاملان"},{"id":"b","text":"الحدّان"},{"id":"c","text":"المطروح والمطروح منه"},{"id":"d","text":"المقسوم والمقسوم عليه"}]'::jsonb, 'b', 'العددان المجموعان يُسمّيان الحدّين، ونتيجتُهما المجموع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d6d0330-9acd-52fc-87e5-892b0126bf8f', '4db3938c-398e-57f1-882b-ff5738209293', 'ما ناتجُ 25 × 4؟', '[{"id":"a","text":"90"},{"id":"b","text":"29"},{"id":"c","text":"100"},{"id":"d","text":"200"}]'::jsonb, 'c', 'نضرب: 25 × 4 = 100، أي أربعُ مرّاتٍ العددَ 25 (25 + 25 + 25 + 25).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('21a06d07-1051-5785-938c-9121379b506b', '9310fb78-4283-53ee-ba45-09d485c01ea7', 'math-6eme', '⚔️ زعيم الفصل ⭐⭐⭐: معركةُ العمليّات', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fbb7e77-1260-541e-8bad-a163b5958f92', '21a06d07-1051-5785-938c-9121379b506b', 'ما ناتجُ 305 + 198؟', '[{"id":"a","text":"493"},{"id":"b","text":"513"},{"id":"c","text":"503"},{"id":"d","text":"403"}]'::jsonb, 'c', '305 + 198 = 503 (يمكن حسابُه بسهولة: 305 + 200 = 505 ثمّ ننقص 2).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a7a9aa4-110c-52f3-b673-c5d00be318ca', '21a06d07-1051-5785-938c-9121379b506b', 'ما ناتجُ 1 000 − 376؟', '[{"id":"a","text":"624"},{"id":"b","text":"634"},{"id":"c","text":"724"},{"id":"d","text":"716"}]'::jsonb, 'a', 'نطرح مع الاستلاف: 1 000 − 376 = 624 (نتحقّق: 624 + 376 = 1 000).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('54739350-ffa2-5ba9-a65a-b60847c30da1', '21a06d07-1051-5785-938c-9121379b506b', 'ما ناتجُ 23 × 11؟', '[{"id":"a","text":"233"},{"id":"b","text":"243"},{"id":"c","text":"263"},{"id":"d","text":"253"}]'::jsonb, 'd', '23 × 11 = 23 × 10 + 23 = 230 + 23 = 253.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3493d95b-62f5-5f12-a534-1db4cbcf0571', '21a06d07-1051-5785-938c-9121379b506b', 'عند قسمة 100 على 7 قسمةً إقليدية، ما الخارجُ والباقي؟', '[{"id":"a","text":"الخارجُ 13 والباقي 9"},{"id":"b","text":"الخارجُ 14 والباقي 2"},{"id":"c","text":"الخارجُ 14 والباقي 3"},{"id":"d","text":"الخارجُ 15 والباقي 5"}]'::jsonb, 'b', '7 × 14 = 98 و 100 = 98 + 2، فالخارجُ 14 والباقي 2 (2 < 7). الاختيار «الباقي 9» مرفوضٌ لأنّ الباقي يجب أن يكون أصغرَ من 7.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e8371b3-5149-586f-a707-23cf002d58ce', '21a06d07-1051-5785-938c-9121379b506b', 'ما قيمةُ 20 − 3 × 4؟', '[{"id":"a","text":"68"},{"id":"b","text":"17"},{"id":"c","text":"8"},{"id":"d","text":"12"}]'::jsonb, 'c', 'نُجري الضربَ أوّلًا: 3 × 4 = 12، ثمّ 20 − 12 = 8.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f69bf86-384b-5437-86a3-e705e3e3fecc', '21a06d07-1051-5785-938c-9121379b506b', 'احسب 6 × 102 باستعمال التوزيعيّة.', '[{"id":"a","text":"612"},{"id":"b","text":"6 012"},{"id":"c","text":"620"},{"id":"d","text":"162"}]'::jsonb, 'a', '6 × 102 = 6 × 100 + 6 × 2 = 600 + 12 = 612.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bff57037-e374-5ec1-9160-f01c540126a2', '9310fb78-4283-53ee-ba45-09d485c01ea7', 'math-6eme', '⭐⭐ تمرين مراجعة (نمط امتحان): العمليّات', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5da61ea-240f-57ec-ba31-6f9dbdab8f44', 'bff57037-e374-5ec1-9160-f01c540126a2', 'ماذا نسمّي نتيجةَ عمليّة الطرح؟', '[{"id":"a","text":"المجموع"},{"id":"b","text":"الفرق"},{"id":"c","text":"الجداء"},{"id":"d","text":"الخارج"}]'::jsonb, 'b', 'نتيجةُ الطرح تُسمّى الفرق.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b4e996c6-c44f-52c6-af52-84d8bd1b4b72', 'bff57037-e374-5ec1-9160-f01c540126a2', 'ما ناتجُ 4 500 + 2 750؟', '[{"id":"a","text":"7 350"},{"id":"b","text":"6 250"},{"id":"c","text":"7 250"},{"id":"d","text":"7 150"}]'::jsonb, 'c', 'نجمع حسب الرتب من اليمين إلى اليسار: 4 500 + 2 750 = 7 250.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee77ac92-8fcb-5d7c-936b-0ed234ff5825', 'bff57037-e374-5ec1-9160-f01c540126a2', 'ما ناتجُ 6 003 − 2 815؟', '[{"id":"a","text":"3 288"},{"id":"b","text":"3 188"},{"id":"c","text":"4 188"},{"id":"d","text":"3 198"}]'::jsonb, 'b', '6 003 − 2 815 = 3 188 (نتحقّق: 2 815 + 3 188 = 6 003).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dbc60349-b017-598d-807d-10b601dbdd39', 'bff57037-e374-5ec1-9160-f01c540126a2', 'ما ناتجُ 125 × 8؟', '[{"id":"a","text":"100"},{"id":"b","text":"1 025"},{"id":"c","text":"960"},{"id":"d","text":"1 000"}]'::jsonb, 'd', 'نضرب: 125 × 8 = 1 000 (نتحقّق بالقسمة العكسيّة: 1 000 ÷ 8 = 125).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d1a8275-ae4a-5b82-bc2a-a41b42919c29', 'bff57037-e374-5ec1-9160-f01c540126a2', 'ما باقي القسمة الإقليدية 59 ÷ 6؟', '[{"id":"a","text":"5"},{"id":"b","text":"4"},{"id":"c","text":"6"},{"id":"d","text":"3"}]'::jsonb, 'a', '6 × 9 = 54 و 59 = 54 + 5، فالخارجُ 9 والباقي 5 (5 < 6).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e30fbd41-aad3-5906-8e86-090971c1c119', 'bff57037-e374-5ec1-9160-f01c540126a2', 'اشترى تاجرٌ 6 صناديقَ في كلٍّ منها 48 قارورة. كم قارورةً اشترى؟', '[{"id":"a","text":"282"},{"id":"b","text":"248"},{"id":"c","text":"288"},{"id":"d","text":"300"}]'::jsonb, 'c', 'عددُ القوارير = 6 × 48 = 288.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('83f29240-ec09-5f2e-acb7-a7fd24dc60e0', '9310fb78-4283-53ee-ba45-09d485c01ea7', 'math-6eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّدُ الحساب', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1eadf3d5-726f-573d-86be-1e39f53ace11', '83f29240-ec09-5f2e-acb7-a7fd24dc60e0', 'في عمليّة طرحٍ، المطروحُ منه 8 000 والفرقُ 3 250. ما المطروح؟', '[{"id":"a","text":"4 850"},{"id":"b","text":"4 750"},{"id":"c","text":"11 250"},{"id":"d","text":"5 250"}]'::jsonb, 'b', 'المطروح = المطروح منه − الفرق = 8 000 − 3 250 = 4 750 (نتحقّق: 4 750 + 3 250 = 8 000).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fcc09621-0230-5e3a-a989-72ce5bfd2fe0', '83f29240-ec09-5f2e-acb7-a7fd24dc60e0', 'ما العددُ الذي إذا ضربناه في 9 كان الجداءُ 405؟', '[{"id":"a","text":"45"},{"id":"b","text":"36"},{"id":"c","text":"44"},{"id":"d","text":"46"}]'::jsonb, 'a', 'العددُ المطلوب = 405 ÷ 9 = 45 (نتحقّق: 9 × 45 = 405).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9f6b3e6-fa62-5798-ae11-21d65b35c6e1', '83f29240-ec09-5f2e-acb7-a7fd24dc60e0', 'في قاعةٍ 24 صفًّا، في كلِّ صفٍّ 15 مقعدًا. جلس 280 متفرّجًا. كم مقعدًا بقي فارغًا؟', '[{"id":"a","text":"90"},{"id":"b","text":"70"},{"id":"c","text":"80"},{"id":"d","text":"360"}]'::jsonb, 'c', 'عددُ المقاعد = 24 × 15 = 360، والفارغُ = 360 − 280 = 80.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('21696cbe-46e3-5bc2-9ef3-1a6025a90eb7', '83f29240-ec09-5f2e-acb7-a7fd24dc60e0', 'وزّعنا 250 كتابًا بالتساوي على 8 رفوفٍ، ووضعنا الباقي في صندوق. كم كتابًا في كلّ رفٍّ وكم في الصندوق؟', '[{"id":"a","text":"كلّ رفٍّ 30 والصندوق 10"},{"id":"b","text":"كلّ رفٍّ 31 والصندوق 4"},{"id":"c","text":"كلّ رفٍّ 32 والصندوق 6"},{"id":"d","text":"كلّ رفٍّ 31 والصندوق 2"}]'::jsonb, 'd', '250 = 8 × 31 + 2، فكلُّ رفٍّ 31 كتابًا والباقي في الصندوق 2 (2 < 8). الاختيار «الصندوق 10» مرفوضٌ لأنّ الباقي يجب أن يكون أصغرَ من 8.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('701b2ae9-4138-50d9-a674-307e8ca5b762', '83f29240-ec09-5f2e-acb7-a7fd24dc60e0', 'ما قيمةُ (15 + 25) × 3 − 20؟', '[{"id":"a","text":"80"},{"id":"b","text":"100"},{"id":"c","text":"90"},{"id":"d","text":"120"}]'::jsonb, 'b', 'الأقواسُ أوّلًا: 15 + 25 = 40، ثمّ 40 × 3 = 120، ثمّ 120 − 20 = 100.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c88867d0-5689-5d77-9c23-87870bf9724e', '83f29240-ec09-5f2e-acb7-a7fd24dc60e0', 'احسب بذكاءٍ 4 × 25 × 7 باستعمال التجميعيّة.', '[{"id":"a","text":"700"},{"id":"b","text":"70"},{"id":"c","text":"175"},{"id":"d","text":"7 000"}]'::jsonb, 'a', 'نُجمّع 4 × 25 = 100 أوّلًا، ثمّ 100 × 7 = 700.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4a4c8177-ef60-5749-8706-5939f4e501b0', '9310fb78-4283-53ee-ba45-09d485c01ea7', 'math-6eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للعمليّات', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7fe90ef-9bfa-5e35-9716-fd2a08f48f93', '4a4c8177-ef60-5749-8706-5939f4e501b0', 'ما العنصرُ المحايدُ لعمليّة الجمع؟', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"10"},{"id":"d","text":"لا يوجد"}]'::jsonb, 'a', '0 عنصرٌ محايدٌ للجمع لأنّ a + 0 = a؛ أمّا 1 فهو المحايدُ للضرب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('abf9ecce-0b61-57bd-bc4f-716ac690da9d', '4a4c8177-ef60-5749-8706-5939f4e501b0', 'ما ناتجُ 7 200 + 899؟', '[{"id":"a","text":"8 199"},{"id":"b","text":"8 089"},{"id":"c","text":"8 099"},{"id":"d","text":"7 999"}]'::jsonb, 'c', '7 200 + 899 = 8 099 (يمكن: 7 200 + 900 = 8 100 ثمّ ننقص 1).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e173d3f0-97ec-5b1a-9cde-b5a6c5b34354', '4a4c8177-ef60-5749-8706-5939f4e501b0', 'ما ناتجُ 50 × 60؟', '[{"id":"a","text":"300"},{"id":"b","text":"3 000"},{"id":"c","text":"110"},{"id":"d","text":"30 000"}]'::jsonb, 'b', '50 × 60 = (5 × 6) × 100 = 30 × 100 = 3 000.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4cb712b2-6420-5273-92a8-636bd480e718', '4a4c8177-ef60-5749-8706-5939f4e501b0', 'كم يساوي 480 ÷ 6؟', '[{"id":"a","text":"8"},{"id":"b","text":"78"},{"id":"c","text":"90"},{"id":"d","text":"80"}]'::jsonb, 'd', '6 × 80 = 480، إذن 480 ÷ 6 = 80.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bac8dcf6-1ef7-532d-b2af-3615cd411571', '4a4c8177-ef60-5749-8706-5939f4e501b0', 'ما قيمةُ 100 − 4 × 9 + 6؟', '[{"id":"a","text":"70"},{"id":"b","text":"58"},{"id":"c","text":"870"},{"id":"d","text":"64"}]'::jsonb, 'a', 'الضربُ أوّلًا: 4 × 9 = 36، ثمّ من اليسار إلى اليمين: 100 − 36 = 64 ثمّ 64 + 6 = 70.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43e8de9b-7a6b-5c43-9003-c6cd624f4883', '4a4c8177-ef60-5749-8706-5939f4e501b0', 'كتابٌ ثمنُه 18 دينارًا. كم يتبقّى من 250 دينارًا بعد شراء 12 كتابًا؟', '[{"id":"a","text":"24"},{"id":"b","text":"34"},{"id":"c","text":"216"},{"id":"d","text":"44"}]'::jsonb, 'b', 'ثمنُ 12 كتابًا = 12 × 18 = 216 دينارًا، والباقي = 250 − 216 = 34 دينارًا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cdc6e831-d84e-5649-bdab-c8b33cd56d48', '624b6711-ca18-5fe5-a97d-b61c69704e94', 'math-6eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ebe3c4cf-8300-5afc-8091-f04257df50d0', 'cdc6e831-d84e-5649-bdab-c8b33cd56d48', 'في العدد 25,84 ما الجزءُ الصحيح؟', '[{"id":"a","text":"25"},{"id":"b","text":"84"},{"id":"c","text":"2 584"},{"id":"d","text":"0,84"}]'::jsonb, 'a', 'الجزءُ الصحيح هو ما يسبق الفاصلة: 25؛ أمّا 84 فهو الجزءُ العشريّ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9d853d38-958d-5da7-b4ea-4285359d3ff1', 'cdc6e831-d84e-5649-bdab-c8b33cd56d48', 'ما الرقمُ في رتبة الأعشار في العدد 7,309؟', '[{"id":"a","text":"3"},{"id":"b","text":"0"},{"id":"c","text":"9"},{"id":"d","text":"7"}]'::jsonb, 'a', 'الرقمُ الأوّلُ بعد الفاصلة هو رتبةُ الأعشار: إنّه 3.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7703124-b2e4-58ea-a341-24537cddb38d', 'cdc6e831-d84e-5649-bdab-c8b33cd56d48', 'أيُّ عددٍ يساوي 4,5؟', '[{"id":"a","text":"4,05"},{"id":"b","text":"4,50"},{"id":"c","text":"45"},{"id":"d","text":"0,45"}]'::jsonb, 'b', 'إضافةُ صفرٍ على يمين الجزء العشريّ لا تُغيّر القيمة: 4,5 = 4,50.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d8d8f76-7c6b-56c9-b46f-59e1e8aad48f', 'cdc6e831-d84e-5649-bdab-c8b33cd56d48', 'أيُّ مقارنةٍ صحيحة؟', '[{"id":"a","text":"3,7 < 3,65"},{"id":"b","text":"3,7 = 3,07"},{"id":"c","text":"3,7 > 3,65"},{"id":"d","text":"3,65 > 3,7"}]'::jsonb, 'c', 'الجزءان الصحيحان متساويان (3)، ثمّ نقارن الأعشار: 7 > 6، إذن 3,7 > 3,65.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba0ddd4f-fbbb-55f0-b63e-5524613bac7e', 'cdc6e831-d84e-5649-bdab-c8b33cd56d48', 'ما تدويرُ 8,46 إلى أقرب عُشر؟', '[{"id":"a","text":"8,4"},{"id":"b","text":"8,5"},{"id":"c","text":"8,46"},{"id":"d","text":"9"}]'::jsonb, 'b', 'الرقمُ بعد الأعشار هو 6 (≥ 5) فنُدوّر الأعشارَ صعودًا: 8,46 ≈ 8,5.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('641e186f-24fd-5859-bfe4-18502c693f25', '624b6711-ca18-5fe5-a97d-b61c69704e94', 'math-6eme', '⭐ تمرين: أوّلُ خطوات مع الأعداد العشرية', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb95195b-bc02-537f-8539-e08f6c54912d', '641e186f-24fd-5859-bfe4-18502c693f25', 'في العدد 13,6 ما الجزءُ العشريّ؟', '[{"id":"a","text":"6"},{"id":"b","text":"13"},{"id":"c","text":"136"},{"id":"d","text":"0"}]'::jsonb, 'a', 'الجزءُ العشريّ هو ما يقع بعد الفاصلة: 6.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62e690fe-df51-578c-949c-0f9b5b0ec813', '641e186f-24fd-5859-bfe4-18502c693f25', 'كيف نقرأ العدد 0,7؟', '[{"id":"a","text":"سبعون"},{"id":"b","text":"سبعة أعشار"},{"id":"c","text":"سبعة أجزاء من المئة"},{"id":"d","text":"سبعة"}]'::jsonb, 'b', 'الرقمُ 7 في رتبة الأعشار، فيُقرأ العددُ «سبعة أعشار» (0,7 = 7 ÷ 10).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d10e742-f3e1-53eb-a312-4496149934a2', '641e186f-24fd-5859-bfe4-18502c693f25', 'ما الرقمُ في رتبة الأجزاء من المئة في العدد 5,38؟', '[{"id":"a","text":"3"},{"id":"b","text":"5"},{"id":"c","text":"8"},{"id":"d","text":"0"}]'::jsonb, 'c', 'في 5,38: الرقمُ 3 في رتبة الأعشار، والرقمُ 8 في رتبة الأجزاء من المئة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c566e9e2-a58e-59fd-b528-414cb0386bab', '641e186f-24fd-5859-bfe4-18502c693f25', 'أيُّ ما يلي يساوي 2,3؟', '[{"id":"a","text":"2,30"},{"id":"b","text":"2,03"},{"id":"c","text":"23"},{"id":"d","text":"0,23"}]'::jsonb, 'a', 'صفرٌ على يمين الجزء العشريّ لا يُغيّر القيمة: 2,3 = 2,30.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be819f90-2fb5-5437-a992-5cb557ba4ae9', '641e186f-24fd-5859-bfe4-18502c693f25', 'ما تفكيكُ العدد 0,46؟', '[{"id":"a","text":"0,04 + 0,6"},{"id":"b","text":"4 + 0,6"},{"id":"c","text":"0,4 + 0,6"},{"id":"d","text":"0,4 + 0,06"}]'::jsonb, 'd', '0,46 فيه 4 أعشار و 6 أجزاء من المئة، أي 0,4 + 0,06.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9400eac-f759-5f08-8786-c416b612d868', '641e186f-24fd-5859-bfe4-18502c693f25', 'رتّب تصاعديًّا: 0,5 ؛ 0,45 ؛ 0,54.', '[{"id":"a","text":"0,5 < 0,45 < 0,54"},{"id":"b","text":"0,45 < 0,5 < 0,54"},{"id":"c","text":"0,45 < 0,54 < 0,5"},{"id":"d","text":"0,54 < 0,5 < 0,45"}]'::jsonb, 'b', 'نساوي الطول (0,50) ثمّ نقارن رتبةً برتبة، فالترتيب التصاعدي: 0,45 < 0,5 < 0,54.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('28d9d688-de45-5fa4-8ffb-c2d974cb6dab', '624b6711-ca18-5fe5-a97d-b61c69704e94', 'math-6eme', '⚔️ زعيم الفصل ⭐⭐⭐: تحدّي الفاصلة', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b8f4bdfa-f10c-5bf9-ab6e-0ac1d1f6e609', '28d9d688-de45-5fa4-8ffb-c2d974cb6dab', 'ما الجزءُ الصحيح في العدد 100,25؟', '[{"id":"a","text":"100"},{"id":"b","text":"25"},{"id":"c","text":"0"},{"id":"d","text":"10 025"}]'::jsonb, 'a', 'الجزءُ الصحيح هو ما يسبق الفاصلة: 100.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('750491f4-80c2-5133-b7d7-a65c2c4d1027', '28d9d688-de45-5fa4-8ffb-c2d974cb6dab', 'ما العددُ المساوي لـ 0,7 + 0,05؟', '[{"id":"a","text":"0,57"},{"id":"b","text":"7,5"},{"id":"c","text":"0,75"},{"id":"d","text":"0,705"}]'::jsonb, 'c', '7 أعشار و 5 أجزاء من المئة تُكوّن 0,75 (نساوي الطول: 0,70 + 0,05 = 0,75).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8e9a7263-2f49-55c7-875e-fe916cce2f04', '28d9d688-de45-5fa4-8ffb-c2d974cb6dab', 'قارن بين 12,4 و 12,40.', '[{"id":"a","text":"12,4 < 12,40"},{"id":"b","text":"12,4 = 12,40"},{"id":"c","text":"12,4 > 12,40"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'b', 'الصفرُ على يمين الجزء العشريّ لا يُغيّر القيمة، إذن 12,4 = 12,40.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c986df9b-3cd9-5294-8a9f-6e65fa9b39df', '28d9d688-de45-5fa4-8ffb-c2d974cb6dab', 'رتّب تنازليًّا: 5,6 ؛ 5,56 ؛ 5,65 ؛ 5,605.', '[{"id":"a","text":"5,65 > 5,6 > 5,605 > 5,56"},{"id":"b","text":"5,6 > 5,65 > 5,605 > 5,56"},{"id":"c","text":"5,56 > 5,6 > 5,605 > 5,65"},{"id":"d","text":"5,65 > 5,605 > 5,6 > 5,56"}]'::jsonb, 'd', 'نساوي الطول: 5,650 ؛ 5,560 ؛ 5,600 ؛ 5,605، فالترتيب التنازلي: 5,65 > 5,605 > 5,6 > 5,56.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4347704-b9ad-56c6-8cfa-7a4165cccbc6', '28d9d688-de45-5fa4-8ffb-c2d974cb6dab', 'ما تدويرُ 9,96 إلى أقرب عُشر؟', '[{"id":"a","text":"10,0"},{"id":"b","text":"9,9"},{"id":"c","text":"9,96"},{"id":"d","text":"10,1"}]'::jsonb, 'a', 'الرقمُ بعد الأعشار هو 6 (≥ 5) فنُدوّر صعودًا؛ والأعشار 9 تصبح 10 فيُحمل 1 إلى الوحدات: 9,96 ≈ 10,0.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f6d1715-6a63-58f3-9f74-977996d509db', '28d9d688-de45-5fa4-8ffb-c2d974cb6dab', 'أيُّ عددٍ محصورٌ بين 4,2 و 4,3؟', '[{"id":"a","text":"4,15"},{"id":"b","text":"4,35"},{"id":"c","text":"4,25"},{"id":"d","text":"4,02"}]'::jsonb, 'c', '4,25 محصورٌ بين 4,20 و 4,30؛ أمّا 4,15 و 4,02 فأصغرُ من 4,2 و 4,35 فأكبرُ من 4,3.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0b2b3836-a5f1-51dd-b0ba-16c1b4aaa4e9', '624b6711-ca18-5fe5-a97d-b61c69704e94', 'math-6eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الأعداد العشرية', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('05ca6a6c-4153-5542-a170-1bcc0771977f', '0b2b3836-a5f1-51dd-b0ba-16c1b4aaa4e9', 'كيف نكتب بالأرقام «ثلاثة فاصل سبعة»؟', '[{"id":"a","text":"3,7"},{"id":"b","text":"37"},{"id":"c","text":"0,37"},{"id":"d","text":"3,07"}]'::jsonb, 'a', '«ثلاثة» جزءٌ صحيح و«سبعة أعشار» جزءٌ عشريّ، فالعددُ 3,7.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('89c1f3f5-9e6e-50a1-b4ee-58dfb7b904e5', '0b2b3836-a5f1-51dd-b0ba-16c1b4aaa4e9', 'ما الرقمُ في رتبة الأجزاء من الألف في العدد 6,374؟', '[{"id":"a","text":"7"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"6"}]'::jsonb, 'c', 'في 6,374: 3 أعشار، 7 أجزاء من المئة، 4 أجزاء من الألف. إذن الرقمُ المطلوب 4.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a4f72de-1002-5f3e-b74b-d88ff6c7d309', '0b2b3836-a5f1-51dd-b0ba-16c1b4aaa4e9', 'أيُّ عددٍ أكبر: 0,8 أم 0,79؟', '[{"id":"a","text":"0,79"},{"id":"b","text":"0,8"},{"id":"c","text":"متساويان"},{"id":"d","text":"0,079"}]'::jsonb, 'b', 'نساوي الطول: 0,80 و 0,79. وبما أنّ 80 جزءًا من المئة > 79، فإنّ 0,8 > 0,79.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9b0160e-2f7f-553c-b6af-e9dc7d4eb15d', '0b2b3836-a5f1-51dd-b0ba-16c1b4aaa4e9', 'ما تفكيكُ العدد 5,07؟', '[{"id":"a","text":"5 + 0,7"},{"id":"b","text":"5 + 0,007"},{"id":"c","text":"50 + 7"},{"id":"d","text":"5 + 0,07"}]'::jsonb, 'd', '5,07 فيه 0 أعشار و 7 أجزاء من المئة، أي 5 + 0,07.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3b71df1-c4ce-5664-8078-c94f4ff55844', '0b2b3836-a5f1-51dd-b0ba-16c1b4aaa4e9', 'ما تدويرُ 14,62 إلى أقرب وحدة؟', '[{"id":"a","text":"15"},{"id":"b","text":"14"},{"id":"c","text":"14,6"},{"id":"d","text":"14,7"}]'::jsonb, 'a', 'الرقمُ بعد الوحدات هو 6 (≥ 5) فنُدوّر الوحداتِ صعودًا: 14,62 ≈ 15.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e751692-e5b8-5099-8bd0-2352b85bbe76', '0b2b3836-a5f1-51dd-b0ba-16c1b4aaa4e9', 'كم جزءًا من المئة في العدد 0,3؟', '[{"id":"a","text":"3"},{"id":"b","text":"300"},{"id":"c","text":"30"},{"id":"d","text":"0,03"}]'::jsonb, 'c', '0,3 = 0,30 = 30 جزءًا من المئة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('220a9082-fd47-5d22-9ad6-3d6702260784', '624b6711-ca18-5fe5-a97d-b61c69704e94', 'math-6eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سادةُ الفاصلة', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26c8b66c-f729-56bc-966f-3df9fcbff9ff', '220a9082-fd47-5d22-9ad6-3d6702260784', 'ما أصغرُ عددٍ عشريّ أكبرَ من 7 وله رقمٌ واحدٌ فقط بعد الفاصلة؟', '[{"id":"a","text":"7,1"},{"id":"b","text":"7,01"},{"id":"c","text":"7,9"},{"id":"d","text":"6,9"}]'::jsonb, 'a', 'برقمٍ واحدٍ بعد الفاصلة، أصغرُ عددٍ أكبرَ من 7 هو 7,1 (لأنّ 7,01 له رقمان بعد الفاصلة).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7dee8320-839f-5fe4-ad8f-470998da3c52', '220a9082-fd47-5d22-9ad6-3d6702260784', 'كم عددًا عشريًّا له رقمان بعد الفاصلة محصورٌ تمامًا بين 2,3 و 2,4؟', '[{"id":"a","text":"8"},{"id":"b","text":"10"},{"id":"c","text":"9"},{"id":"d","text":"11"}]'::jsonb, 'c', 'الأعدادُ هي 2,31 ؛ 2,32 ؛ … ؛ 2,39، أي 9 أعداد (لا نَعُدّ 2,30 و 2,40 لأنّ الحصرَ تامّ).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9fa0100-a46c-5772-b37f-afac2e3b33ad', '220a9082-fd47-5d22-9ad6-3d6702260784', 'رتّب تصاعديًّا: 0,9 ؛ 1,1 ؛ 0,99 ؛ 1,01.', '[{"id":"a","text":"0,9 < 1,01 < 0,99 < 1,1"},{"id":"b","text":"0,9 < 0,99 < 1,01 < 1,1"},{"id":"c","text":"0,99 < 0,9 < 1,1 < 1,01"},{"id":"d","text":"0,9 < 0,99 < 1,1 < 1,01"}]'::jsonb, 'b', 'نقارن الجزءَ الصحيح أوّلًا: 0,9 و 0,99 جزؤهما الصحيح 0 (وهما أصغر)، و 1,01 و 1,1 جزؤهما الصحيح 1. إذن 0,9 < 0,99 < 1,01 < 1,1.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fec51fe1-7dcd-5824-a8df-17b5a0fb914e', '220a9082-fd47-5d22-9ad6-3d6702260784', 'عددٌ عشريّ تدويرُه إلى أقرب وحدةٍ يساوي 5. ما أكبرُ قيمةٍ ممكنةٍ له برقمٍ واحدٍ بعد الفاصلة؟', '[{"id":"a","text":"5,5"},{"id":"b","text":"5,9"},{"id":"c","text":"4,9"},{"id":"d","text":"5,4"}]'::jsonb, 'd', 'يُدوَّر إلى 5 كلُّ عددٍ من 4,5 إلى أقلَّ من 5,5. وبرقمٍ واحدٍ بعد الفاصلة أكبرُها 5,4 (لأنّ 5,5 يُدوَّر إلى 6).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33f03489-a45f-57a2-afcd-a15a81b35bdc', '220a9082-fd47-5d22-9ad6-3d6702260784', 'ما العددُ العشريّ الذي جزؤه الصحيح 8، وفيه 3 أعشار و 0 أجزاء من المئة و 5 أجزاء من الألف؟', '[{"id":"a","text":"8,305"},{"id":"b","text":"8,35"},{"id":"c","text":"8,035"},{"id":"d","text":"8,350"}]'::jsonb, 'a', '8 + 0,3 + 0 + 0,005 = 8,305 (الصفرُ في رتبة الأجزاء من المئة ضروريٌّ ليحفظ المواضع).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef266d1a-6161-547c-8204-03c3be1100a8', '220a9082-fd47-5d22-9ad6-3d6702260784', 'أيُّ سلسلةٍ مرتّبةٌ تصاعديًّا ترتيبًا صحيحًا؟', '[{"id":"a","text":"3,4 < 3,04 < 3,44 < 4,3"},{"id":"b","text":"4,3 < 3,44 < 3,4 < 3,04"},{"id":"c","text":"3,04 < 3,4 < 3,44 < 4,3"},{"id":"d","text":"3,04 < 3,44 < 3,4 < 4,3"}]'::jsonb, 'c', 'نقارن الجزءَ الصحيح ثمّ الأعشار: 3,04 < 3,4 < 3,44 (كلُّها جزؤها الصحيح 3) < 4,3 (جزؤها الصحيح 4).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('470bdb5e-c10e-5473-a32a-a44e20af0213', '624b6711-ca18-5fe5-a97d-b61c69704e94', 'math-6eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للأعداد العشرية', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b412168-293a-5391-bf8c-b9833c4fd192', '470bdb5e-c10e-5473-a32a-a44e20af0213', 'العددُ 0,01 هو:', '[{"id":"a","text":"جزءٌ من المئة"},{"id":"b","text":"عُشرٌ"},{"id":"c","text":"جزءٌ من الألف"},{"id":"d","text":"وحدة"}]'::jsonb, 'a', '0,01 = 1 ÷ 100، أي جزءٌ واحدٌ من المئة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0726e69a-7a56-51b2-a848-0661e057e5ca', '470bdb5e-c10e-5473-a32a-a44e20af0213', 'ما تفكيكُ العدد 9,4؟', '[{"id":"a","text":"9 + 0,04"},{"id":"b","text":"90 + 4"},{"id":"c","text":"9 + 4"},{"id":"d","text":"9 + 0,4"}]'::jsonb, 'd', '9,4 فيه 9 وحدات و 4 أعشار، أي 9 + 0,4.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('377fc039-0c3e-5b14-b784-091e8708dfa9', '470bdb5e-c10e-5473-a32a-a44e20af0213', 'أيُّ عددٍ يساوي 6,30؟', '[{"id":"a","text":"6,03"},{"id":"b","text":"6,3"},{"id":"c","text":"63"},{"id":"d","text":"0,63"}]'::jsonb, 'b', 'الصفرُ على يمين الجزء العشريّ لا يُغيّر القيمة: 6,30 = 6,3.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53619adb-3619-59d5-b4d4-935988983931', '470bdb5e-c10e-5473-a32a-a44e20af0213', 'ما تدويرُ 7,251 إلى أقرب جزءٍ من المئة؟', '[{"id":"a","text":"7,25"},{"id":"b","text":"7,26"},{"id":"c","text":"7,2"},{"id":"d","text":"7,3"}]'::jsonb, 'a', 'ننظر إلى الرقم بعد رتبة الأجزاء من المئة: إنّه 1 (< 5) فنُبقي الرتبةَ كما هي: 7,251 ≈ 7,25.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa874b1f-2fec-5a09-a5ff-973b401ffdc8', '470bdb5e-c10e-5473-a32a-a44e20af0213', 'قارن بين 0,408 و 0,41.', '[{"id":"a","text":"0,408 > 0,41"},{"id":"b","text":"متساويان"},{"id":"c","text":"0,408 < 0,41"},{"id":"d","text":"0,408 = 0,41"}]'::jsonb, 'c', 'نساوي الطول: 0,408 و 0,410. وبما أنّ 408 جزءًا من الألف < 410، فإنّ 0,408 < 0,41.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5eecec4-158c-5cb1-93f0-29cfcbc5eea9', '470bdb5e-c10e-5473-a32a-a44e20af0213', 'أيُّ عددٍ محصورٌ بين 1,5 و 1,6 وهو الأقربُ إلى 1,6؟', '[{"id":"a","text":"1,55"},{"id":"b","text":"1,59"},{"id":"c","text":"1,52"},{"id":"d","text":"1,61"}]'::jsonb, 'b', '1,61 خارجُ المجال (أكبرُ من 1,6). ومن الأعداد المحصورة بين 1,5 و 1,6 فإنّ 1,59 هو الأقربُ إلى 1,6.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a38b86bc-a302-5cbd-86db-bf51704d4015', '5e4665db-9840-50b3-b4f6-d96a1c110a07', 'math-6eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b71050d-3db5-5399-b889-18a6a2efc02c', 'a38b86bc-a302-5cbd-86db-bf51704d4015', 'ما القاعدةُ الأساسيّة لجمع أو طرح عددين عشريّين كتابيًّا؟', '[{"id":"a","text":"نرصُّ الفاصلةَ تحت الفاصلة"},{"id":"b","text":"نرصُّ الأرقامَ إلى اليمين"},{"id":"c","text":"نحذف الفاصلة ثمّ نجمع"},{"id":"d","text":"نجمع الجزأين الصحيحين فقط"}]'::jsonb, 'a', 'نرصُّ الأعدادَ بحيث تكون الفاصلةُ تحت الفاصلة، فتقع كلُّ رتبةٍ تحت نظيرتها.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('696b19c1-5508-5471-ad23-6fdff05d9d3a', 'a38b86bc-a302-5cbd-86db-bf51704d4015', 'ما ناتجُ 1,5 + 2,3؟', '[{"id":"a","text":"3,5"},{"id":"b","text":"4,8"},{"id":"c","text":"3,8"},{"id":"d","text":"38"}]'::jsonb, 'c', '1,5 + 2,3 = 3,8 (5 أعشار + 3 أعشار = 8 أعشار).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3959c1d4-3cd5-5e99-b354-852f068ebc8c', 'a38b86bc-a302-5cbd-86db-bf51704d4015', 'ما ناتجُ 5,6 − 2,4؟', '[{"id":"a","text":"3,4"},{"id":"b","text":"3,2"},{"id":"c","text":"2,2"},{"id":"d","text":"8,0"}]'::jsonb, 'b', 'نطرح الأعشارَ من الأعشار والوحداتِ من الوحدات: 5,6 − 2,4 = 3,2.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4dbe40e3-2d2d-5df6-96c7-86ecff2ce348', 'a38b86bc-a302-5cbd-86db-bf51704d4015', 'ما ناتجُ 4,25 + 1,8؟', '[{"id":"a","text":"6,05"},{"id":"b","text":"6,5"},{"id":"c","text":"4,43"},{"id":"d","text":"5,05"}]'::jsonb, 'a', 'نُكمل: 4,25 + 1,80 = 6,05 (الفاصلةُ تحت الفاصلة).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8cefde19-b8ed-5166-a9be-f411c673ff5a', 'a38b86bc-a302-5cbd-86db-bf51704d4015', 'ما ناتجُ 7 − 2,75؟', '[{"id":"a","text":"5,25"},{"id":"b","text":"4,75"},{"id":"c","text":"5,75"},{"id":"d","text":"4,25"}]'::jsonb, 'd', 'نكتب 7 في صورة 7,00 ثمّ نطرح: 7,00 − 2,75 = 4,25.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('be44ccc1-b8cf-53c4-be3e-de9ee5f962a6', '5e4665db-9840-50b3-b4f6-d96a1c110a07', 'math-6eme', '⭐ تمرين: أوّلُ جمعٍ وطرحٍ عشريّ', 1, 50, 10, 'practice', 'admin', 1)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('587e08ea-e4e4-5890-a038-cd213af0cef6', 'be44ccc1-b8cf-53c4-be3e-de9ee5f962a6', 'ما ناتجُ 2,1 + 3,4؟', '[{"id":"a","text":"5,5"},{"id":"b","text":"5,4"},{"id":"c","text":"6,5"},{"id":"d","text":"55"}]'::jsonb, 'a', 'نجمع الوحداتِ مع الوحدات والأعشارَ مع الأعشار: 2,1 + 3,4 = 5,5.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a0db2731-54fb-5698-88e1-a3964c4d6408', 'be44ccc1-b8cf-53c4-be3e-de9ee5f962a6', 'ما ناتجُ 6,8 − 1,5؟', '[{"id":"a","text":"5,5"},{"id":"b","text":"4,3"},{"id":"c","text":"5,3"},{"id":"d","text":"7,3"}]'::jsonb, 'c', 'نطرح الوحداتِ من الوحدات والأعشارَ من الأعشار: 6,8 − 1,5 = 5,3.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5d980c8-bb36-52f8-b05e-ebfd74c33285', 'be44ccc1-b8cf-53c4-be3e-de9ee5f962a6', 'ما ناتجُ 0,5 + 0,5؟', '[{"id":"a","text":"0,10"},{"id":"b","text":"1"},{"id":"c","text":"0,55"},{"id":"d","text":"10"}]'::jsonb, 'b', '5 أعشار + 5 أعشار = 10 أعشار = وحدةٌ كاملة، أي 0,5 + 0,5 = 1.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eb1bba88-a9e2-55b1-ab64-836e5a08d08e', 'be44ccc1-b8cf-53c4-be3e-de9ee5f962a6', 'لجمع 3,2 و 1,45 كتابيًّا، نكتب 3,2 في صورة:', '[{"id":"a","text":"3,20"},{"id":"b","text":"3,02"},{"id":"c","text":"32"},{"id":"d","text":"3,002"}]'::jsonb, 'a', 'نُكمل بصفرٍ على يمين الجزء العشريّ ليتساوى الطول: 3,2 = 3,20 (دون تغيير القيمة).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('47cd180e-ccd9-529b-bc19-fd1fcb50e03b', 'be44ccc1-b8cf-53c4-be3e-de9ee5f962a6', 'ما ناتجُ 4,7 + 2,35؟', '[{"id":"a","text":"7,5"},{"id":"b","text":"6,05"},{"id":"c","text":"7,15"},{"id":"d","text":"7,05"}]'::jsonb, 'd', 'نُكمل: 4,70 + 2,35 = 7,05.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fade13f8-48ef-5417-91c8-25de399dd92e', 'be44ccc1-b8cf-53c4-be3e-de9ee5f962a6', 'ما ناتجُ 8,5 − 3,75؟', '[{"id":"a","text":"5,75"},{"id":"b","text":"4,25"},{"id":"c","text":"4,75"},{"id":"d","text":"5,25"}]'::jsonb, 'c', 'نُكمل: 8,50 − 3,75 = 4,75.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('007979ed-95bd-5a8a-8e12-f36f45b25bec', '5e4665db-9840-50b3-b4f6-d96a1c110a07', 'math-6eme', '⚔️ زعيم الفصل ⭐⭐⭐: معركةُ الجمع والطرح', 3, 120, 30, 'boss', 'admin', 2)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c5a9a2a8-0232-5eb6-b1f9-58afa0a13193', '007979ed-95bd-5a8a-8e12-f36f45b25bec', 'ما ناتجُ 10,2 + 5,3؟', '[{"id":"a","text":"15,5"},{"id":"b","text":"15,3"},{"id":"c","text":"16,5"},{"id":"d","text":"153"}]'::jsonb, 'a', 'نجمع والفاصلةُ تحت الفاصلة: 10,2 + 5,3 = 15,5.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a56b66af-aa03-5dfa-9282-413bba823033', '007979ed-95bd-5a8a-8e12-f36f45b25bec', 'ما ناتجُ 12,4 + 7,68؟', '[{"id":"a","text":"20,8"},{"id":"b","text":"19,08"},{"id":"c","text":"20,08"},{"id":"d","text":"20,18"}]'::jsonb, 'c', 'نُكمل: 12,40 + 7,68 = 20,08.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a19c59a-e7b2-59f5-bd48-f703c62b3dda', '007979ed-95bd-5a8a-8e12-f36f45b25bec', 'ما ناتجُ 15 − 6,4؟', '[{"id":"a","text":"9,6"},{"id":"b","text":"8,6"},{"id":"c","text":"8,4"},{"id":"d","text":"9,4"}]'::jsonb, 'b', 'نكتب 15 في صورة 15,0 ثمّ نطرح: 15,0 − 6,4 = 8,6.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f49d10e-cdf0-580a-b856-4cb546e08dae', '007979ed-95bd-5a8a-8e12-f36f45b25bec', 'ما ناتجُ 9,05 − 3,7؟', '[{"id":"a","text":"5,25"},{"id":"b","text":"6,35"},{"id":"c","text":"5,45"},{"id":"d","text":"5,35"}]'::jsonb, 'd', 'نُكمل: 9,05 − 3,70 = 5,35.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba4b7bc0-3380-5acf-ad8c-00d7fe188fb7', '007979ed-95bd-5a8a-8e12-f36f45b25bec', 'ما ناتجُ 2,75 + 3,5 + 1,25؟', '[{"id":"a","text":"7,5"},{"id":"b","text":"7,05"},{"id":"c","text":"6,5"},{"id":"d","text":"8,5"}]'::jsonb, 'a', 'نُجمّع بذكاء: (2,75 + 1,25) + 3,5 = 4 + 3,5 = 7,5.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33794c7b-5756-51d6-bd29-ac562b5f524d', '007979ed-95bd-5a8a-8e12-f36f45b25bec', 'عدّاءٌ قطع 3,5 km ثمّ 2,75 km ثمّ 4,2 km. كم قطع إجمالًا؟', '[{"id":"a","text":"10,35 km"},{"id":"b","text":"9,45 km"},{"id":"c","text":"10,45 km"},{"id":"d","text":"11,45 km"}]'::jsonb, 'c', '3,5 + 2,75 + 4,2 = 6,25 + 4,2 = 10,45 km.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('4b826140-6530-5adc-beb5-f821495d8429', '5e4665db-9840-50b3-b4f6-d96a1c110a07', 'math-6eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الجمع والطرح العشريّ', 2, 70, 15, 'practice', 'admin', 3)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a4edece-63d3-5d43-9447-f39eb0f735e5', '4b826140-6530-5adc-beb5-f821495d8429', 'ما ناتجُ 7,2 + 2,7؟', '[{"id":"a","text":"9,9"},{"id":"b","text":"9,09"},{"id":"c","text":"10,9"},{"id":"d","text":"99"}]'::jsonb, 'a', 'نجمع الأعشارَ مع الأعشار ثمّ الوحداتِ مع الوحدات: 7,2 + 2,7 = 9,9.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b1478cf7-e393-56ce-bc61-6ede1241e624', '4b826140-6530-5adc-beb5-f821495d8429', 'ما ناتجُ 20,5 − 12,35؟', '[{"id":"a","text":"8,25"},{"id":"b","text":"8,15"},{"id":"c","text":"7,15"},{"id":"d","text":"8,05"}]'::jsonb, 'b', 'نُكمل: 20,50 − 12,35 = 8,15.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1148cd5a-ff43-5543-ba87-37dab7ec7b10', '4b826140-6530-5adc-beb5-f821495d8429', 'ما ناتجُ 0,75 + 0,25؟', '[{"id":"a","text":"0,90"},{"id":"b","text":"1,1"},{"id":"c","text":"1"},{"id":"d","text":"0,1"}]'::jsonb, 'c', 'نجمع: 0,75 + 0,25 = 1,00 = 1، أي وحدةٌ كاملة (75 + 25 = 100 جزءًا من المئة).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7eeba1f3-e268-574a-9a44-2f2bd7e7991c', '4b826140-6530-5adc-beb5-f821495d8429', 'ما ناتجُ 6,3 + 0,07؟', '[{"id":"a","text":"6,1"},{"id":"b","text":"7,0"},{"id":"c","text":"6,307"},{"id":"d","text":"6,37"}]'::jsonb, 'd', 'نُكمل: 6,30 + 0,07 = 6,37 (3 أعشار + 7 أجزاء من المئة).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8278366d-19bd-57a5-913e-d327e5f246f1', '4b826140-6530-5adc-beb5-f821495d8429', 'ما ناتجُ 100 − 0,5؟', '[{"id":"a","text":"99,5"},{"id":"b","text":"95"},{"id":"c","text":"99,95"},{"id":"d","text":"100,5"}]'::jsonb, 'a', 'نكتب 100 في صورة 100,0 ثمّ نطرح: 100,0 − 0,5 = 99,5.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1cb1238-2857-5f3c-a54f-0f949169186c', '4b826140-6530-5adc-beb5-f821495d8429', 'ثمنُ سلعةٍ 24,90 دينارًا، دفع الزبونُ ورقةَ 50 دينارًا. كم الباقي؟', '[{"id":"a","text":"26,10 دينارًا"},{"id":"b","text":"25,10 دينارًا"},{"id":"c","text":"25,90 دينارًا"},{"id":"d","text":"24,10 دينارًا"}]'::jsonb, 'b', 'الباقي = 50 − 24,90 = 25,10 دينارًا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b8ad17c5-86e1-590b-b27e-5c308de07b21', '5e4665db-9840-50b3-b4f6-d96a1c110a07', 'math-6eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: أبطالُ الحساب العشريّ', 4, 300, 60, 'challenge', 'admin', 4)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4d47c7e8-7d35-54c7-bb50-44a665dc0b49', 'b8ad17c5-86e1-590b-b27e-5c308de07b21', 'ما العددُ الذي نضيفه إلى 6,5 لنحصل على 10؟', '[{"id":"a","text":"3,5"},{"id":"b","text":"4,5"},{"id":"c","text":"3,95"},{"id":"d","text":"16,5"}]'::jsonb, 'a', 'العددُ المطلوب = 10 − 6,5 = 3,5 (نتحقّق: 6,5 + 3,5 = 10).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6dd056a1-40ce-5ea5-adab-3efc0276c046', 'b8ad17c5-86e1-590b-b27e-5c308de07b21', 'في عمليّة طرحٍ، المطروحُ منه 15,2 والفرقُ 9,75. ما المطروح؟', '[{"id":"a","text":"5,55"},{"id":"b","text":"5,45"},{"id":"c","text":"6,45"},{"id":"d","text":"24,95"}]'::jsonb, 'b', 'المطروح = المطروح منه − الفرق = 15,20 − 9,75 = 5,45 (نتحقّق: 9,75 + 5,45 = 15,2).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b6016096-0d7e-5921-877e-4175c7dd73fc', 'b8ad17c5-86e1-590b-b27e-5c308de07b21', 'احسب بذكاءٍ: 1,8 + 4,6 + 3,2 + 5,4.', '[{"id":"a","text":"14"},{"id":"b","text":"15,1"},{"id":"c","text":"15"},{"id":"d","text":"14,9"}]'::jsonb, 'c', 'نُجمّع الحدودَ المناسبة: (1,8 + 3,2) + (4,6 + 5,4) = 5 + 10 = 15.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee24f024-33dd-51ec-a696-8aa5175d9379', 'b8ad17c5-86e1-590b-b27e-5c308de07b21', 'اشترى 2,5 kg تفّاحًا و 1,75 kg موزًا و 3 kg برتقالًا. ما الكتلةُ الإجماليّة؟', '[{"id":"a","text":"7,5 kg"},{"id":"b","text":"6,25 kg"},{"id":"c","text":"8,25 kg"},{"id":"d","text":"7,25 kg"}]'::jsonb, 'd', '2,5 + 1,75 + 3 = 7,25 kg.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86f83bd5-40d2-5eb2-b626-cbe9554a6bc1', 'b8ad17c5-86e1-590b-b27e-5c308de07b21', 'خزّانٌ فيه 50 لترًا، سُحب منه 12,5 L ثمّ أُضيف إليه 8,75 L. كم أصبح فيه؟', '[{"id":"a","text":"46,25 L"},{"id":"b","text":"46,75 L"},{"id":"c","text":"29,25 L"},{"id":"d","text":"45,25 L"}]'::jsonb, 'a', '50 − 12,5 = 37,5 ثمّ 37,5 + 8,75 = 46,25 L.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e4f542e-d4a7-5fb8-8c32-c3d204849e57', 'b8ad17c5-86e1-590b-b27e-5c308de07b21', 'أيُّ مجموعٍ يساوي 10 تمامًا؟', '[{"id":"a","text":"3,6 + 6,3"},{"id":"b","text":"3,6 + 6,4"},{"id":"c","text":"4,5 + 5,4"},{"id":"d","text":"7,2 + 2,9"}]'::jsonb, 'b', '3,6 + 6,4 = 10 تمامًا؛ أمّا البقيّةُ فتُعطي 9,9 و 9,9 و 10,1.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0ef963f1-ebe2-57a2-9cdb-df1a1919e7e3', '5e4665db-9840-50b3-b4f6-d96a1c110a07', 'math-6eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للجمع والطرح العشريّ', 3, 120, 30, 'boss', 'admin', 5)
ON CONFLICT (id) DO UPDATE SET
  chapter_id = EXCLUDED.chapter_id,
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  difficulty = EXCLUDED.difficulty,
  xp_reward = EXCLUDED.xp_reward,
  reward_coins = EXCLUDED.reward_coins,
  mode = EXCLUDED.mode,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e00e5911-ebb7-5f98-8129-aeb1f92eb9e7', '0ef963f1-ebe2-57a2-9cdb-df1a1919e7e3', 'ما ناتجُ 4,4 + 4,4؟', '[{"id":"a","text":"8,8"},{"id":"b","text":"8,4"},{"id":"c","text":"16"},{"id":"d","text":"88"}]'::jsonb, 'a', 'نجمع: 4,4 + 4,4 = 8,8، أي ضِعفُ العددِ 4,4.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8e16ce24-6152-58d5-83e7-0d74d573ebd2', '0ef963f1-ebe2-57a2-9cdb-df1a1919e7e3', 'ما ناتجُ 11,25 + 6,75؟', '[{"id":"a","text":"17"},{"id":"b","text":"18,5"},{"id":"c","text":"18"},{"id":"d","text":"17,90"}]'::jsonb, 'c', '11,25 + 6,75 = 18,00 = 18.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1cbbed0-0235-563a-a318-be48f3e27719', '0ef963f1-ebe2-57a2-9cdb-df1a1919e7e3', 'ما ناتجُ 30,4 − 15,65؟', '[{"id":"a","text":"15,75"},{"id":"b","text":"14,75"},{"id":"c","text":"14,85"},{"id":"d","text":"15,25"}]'::jsonb, 'b', 'نُكمل: 30,40 − 15,65 = 14,75.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1b040f70-98bb-5926-9a6c-dc0c0f2d1187', '0ef963f1-ebe2-57a2-9cdb-df1a1919e7e3', 'ما ناتجُ 0,9 + 0,09 + 0,009؟', '[{"id":"a","text":"0,27"},{"id":"b","text":"0,099"},{"id":"c","text":"1,08"},{"id":"d","text":"0,999"}]'::jsonb, 'd', 'نُكمل الطول: 0,900 + 0,090 + 0,009 = 0,999.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5fc97db0-fce6-5ee0-8cf5-a6726593b10f', '0ef963f1-ebe2-57a2-9cdb-df1a1919e7e3', 'كم نضيف إلى 13,6 لنبلغ 20؟', '[{"id":"a","text":"6,4"},{"id":"b","text":"7,4"},{"id":"c","text":"6,6"},{"id":"d","text":"7,6"}]'::jsonb, 'a', 'العددُ المطلوب = 20 − 13,6 = 6,4 (نتحقّق: 13,6 + 6,4 = 20).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8fa81e8e-6036-5db3-90bc-61e9933bc28b', '0ef963f1-ebe2-57a2-9cdb-df1a1919e7e3', 'ثلاثُ قطعِ قماشٍ أطوالُها 2,4 m و 3,75 m و 1,85 m. قُصَّ منها 1,5 m. كم بقي؟', '[{"id":"a","text":"6,15 m"},{"id":"b","text":"9,5 m"},{"id":"c","text":"6,5 m"},{"id":"d","text":"6,85 m"}]'::jsonb, 'c', 'مجموعُ الأطوال = 2,4 + 3,75 + 1,85 = 8 m، والباقي = 8 − 1,5 = 6,5 m.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

