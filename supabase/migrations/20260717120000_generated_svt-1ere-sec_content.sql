-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: svt-1ere-sec (Sciences de la Vie et de la Terre)
-- Regenerate with: npm run content:build
-- Source of truth: content/svt-1ere-sec/
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
  ('svt-1ere-sec', 'Sciences de la Vie et de la Terre', 'Amélioration de la production végétale (nutrition minérale, nutrition carbonée, multiplication végétative), microbes et santé (diversité du monde microbien, agents pathogènes et maladies infectieuses, défense de l''organisme) et découverte et gestion de notre environnement géologique selon le programme officiel de la 1ère année de l''enseignement secondaire (tronc commun)', 'Vitalite', 'subject-svt', 'Leaf', 3, 'fr', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '1ere-sec'), NULL)
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
      AND e.subject_id = 'svt-1ere-sec'
      AND e.source = 'admin'
      AND q.id NOT IN ('e33a077b-ba10-5f6c-a4ad-5ed1a8083cca', 'ddb8f6f7-d20f-505d-b47e-e1bdd1190ab1', '89c9d68e-0825-5c8a-b227-53823dcebcce', 'b7800c09-23f7-5dd5-ae2d-a6b474a67475', 'dc95078f-4b07-5369-9d4e-20e7da51cfa6', '8370514e-445c-591a-92da-e4099e253999', '8e59a821-f39b-5ba3-ab73-5b234b3b6253', 'de8815b1-b69c-553b-b863-e04b9254f688', '027d4c81-285a-5dc1-9a33-4fa045cf121b', '3616a836-0f14-5737-b34c-8954e0492386', '24b390fb-9b31-5195-920e-32e25236b520', '7cd3036d-fd37-5e99-9ee9-18604e3d22f7', 'f55785f1-1488-598f-836d-6d962733d85c', '91a21c54-f5eb-5636-905d-ca036d1fbe7f', '9e6ec3b7-1a4a-5324-b693-4befe7421343', '96569c1c-2c6f-58ac-be1c-1e9c63f8544b', '2af41e79-44d7-54cc-87a8-f7e8fb554818', '52da7bdf-16c8-5b63-bad0-9a5ccf9e0eaf', 'e395ec07-d9a5-58de-8a71-7edaeef8becd', '650c89f2-ae8d-5657-ab66-78b9a5b5ac82', '99012c23-8348-5018-bbd4-4c21a5b1a8a8', 'e42de770-7ccd-57ae-9d50-7b8e1b9ad950', 'a19b2ff8-2759-5da5-bc6e-38b3629751f0', 'b090ddd8-59be-59ba-bb90-a5878b110d4f', '78b78f9b-886e-59b5-926c-f9edf845f4d7', '7c000b2d-a785-5dd1-957b-e13aa54f37fd', 'f850f95b-136b-5c31-bb57-875cc4a1461a', 'fe53f4af-f844-5250-b629-d6bb89028ce2', '09dce64e-c683-5928-a806-eb08a471da9b', '1627a75b-f528-5ca9-9be0-57f70af79631', '90414dcf-d539-5199-99be-a07837dbe49a', '928b07f4-9368-5470-86e9-e0e86a536a0f', '4fa20252-4e33-5378-adb2-98783f658dbb', 'ca3e8723-6581-5fa1-9b6a-988b944557e7', 'be73d5e3-1039-5dfb-82da-19796687e6ef', 'd0cb9d1b-054c-5c92-b59e-849adaab9a71', '95a19fac-1d90-527f-a28c-c57942c6bc24', 'be512e27-4044-5f2f-940a-b523152a8bda', '60c2aa9d-4ad7-562c-a6c9-51cc56144f19', '5ef56731-c4c9-5f6f-b1c8-c6bef53cfe5d', 'e9f3d64e-29c6-5e34-964b-43c05f5a88bd', '3364383e-d368-5784-86f2-de778373c561', '45559784-8b76-5964-8436-c523028c5c23', '8ae48a12-409a-5862-8d8b-fd5717b60f6b', '1112df0f-2cc9-57eb-8626-75a1f48d6489', 'd89a6f15-c64b-5dfa-b278-ec3148730ddd', '2b4dbb2c-1146-5029-8f9d-11c0f0067ec4', 'ada3ea63-8e05-59da-b2e8-d839fa08f014', '01e92174-0fd1-5e71-a5f9-ba16e036f152', 'b51d95dc-789a-52c6-bcf8-039d9a13dca2', '3bccf06b-e7b6-5bf7-b3cc-3aa369a65ea1', '93db0bf6-4904-59ee-8216-d62070775e36', 'bbecd10e-a6e6-5a5d-bb10-5a2ef046d067', '9cbf896b-6c63-553c-88c3-fba80035bffd', 'd67fe435-439d-5cdd-b681-1444debbd583', '86b52802-4f18-5911-b9c3-8708c3435d2f', '7a9274b5-d2b7-5f8c-8564-d7acc37e018a', '90d6ba8c-fca4-5f7d-9674-138b16f9463f', '24fecb22-d64c-5d54-a8bf-9306088600b2', 'ab63dbd7-8a4d-5dba-af67-419ec79cb5a6', 'dbb47327-f7c2-56bf-a720-d139236eb74c', '89651317-3ca1-5eb4-8fb2-fdc64e1b0b06', '49aa94ef-d027-5918-940e-187e21d1fb75', 'c6be8323-1727-5529-b909-6c6305de34d1', '8b73e34e-fb2e-50d1-a37f-d3abdbdcce6c', '83349456-85cd-5aac-998d-1ec9a6898925', 'f9ba1111-a24f-52a8-a6a3-8486dbc3e6eb', '38db394b-2177-5753-a9ab-d53a32e524ce', 'dbac647d-0d5e-580f-907a-5e57eeeb771f', 'e384258b-3d20-54a9-ae6f-19fe186e9878', '43a9dbcc-901b-5f32-83d3-5f6118d0f5c8', '93b872c2-093b-5433-a3b7-a5a903d75ef4', '02e3f652-c295-5d6c-ac2f-bfa87366f85a', '4d10e083-a407-5b92-a498-85dff46298cc', '26cfdbaf-ecf0-533f-8140-f917971c9f49', 'b53ab9da-3ff4-5339-bfc2-9d2bc5f1e4f9', '6b18a34a-3c9b-5028-8000-30eee51eb17e', 'a23c4160-2c2f-52ce-989b-88a04a5f3610', '5c55547f-e81a-5057-b685-23b9f9112636', '4805b54f-e480-5d4e-b718-67907ac46d15', '58e2372b-0887-591d-a88b-5ad0afd60f94', '18d2dbb8-e892-5570-8817-11aa0c3364cf', '079e6d0f-aae4-5bfe-a36d-529b57a6745c', '3ed9aabb-4be8-5a76-a1d2-7a59ab2b10cf', '2ee431fb-6d6e-52f2-b6de-c3a98721fa32', '0b570cd4-1967-52ba-a4f8-46cb8cb6ff6f', '8dec84d3-4361-5a2a-bab1-56e2efc6d1fd', '1325ba23-9c6b-534f-b08c-824d0727b657', 'f7a55277-f904-5dac-ab74-8b45bde673fd', '6e03b92d-bd46-56c7-b12a-4fc8decff5e8', '1b27a2fe-7908-5ca9-8d2f-8dfb1d87ed27', '58c92df4-f4b9-578d-91d4-b3bd404d2178', '855faa74-716d-53a9-88f7-34392574088d', '85b92d6e-f284-5183-ab50-9932c672fda6', 'e17c8cee-f9f6-5a1e-bd52-3df48e592677', 'b7ccbead-2ed7-52c5-aa81-7d3f63d9b62b', 'cd36905c-da35-5f18-b87b-eebfde30a477', 'a2061720-1c12-5241-8fb5-c5025f27247a', '26eeaf34-3224-58f5-bd9c-ef55a30bc297', 'a4f8266a-1bb2-5cea-8d27-c2360edc06c5', 'feb7e743-7450-5c4f-a514-49f62eef5d1c', '2d930ecb-33f7-5f7c-993b-8058926cc158', '653c1704-6c35-5847-97fa-1b32a6dfdd4f', 'f8667917-cb10-52f7-8a17-5bf73e70b803', 'cfdf2737-585a-527d-8599-dcd72feb9720', 'fca75037-b85a-5f66-8345-a427d9daea7c', '46e58148-8eab-527b-95b9-00295d715b1a', 'ef86ae65-2116-5477-8d4e-0ab3ec805ba2', 'a6a4a998-6434-5fe2-946d-90159d33cc1b', '5baf0c74-bedc-5ae6-bdf5-1bb35259bd41', '442eedd3-72c6-54f1-a5cd-c080ed17bac2', '8761db1b-e387-537c-850e-9cf67cf88b38', '61a384d3-05a2-5545-b134-31071d7a68fe', '2bdcfc97-b186-5b88-a16a-47f784473bb6', 'ecd9da59-79c5-52e3-bedd-3a007223118d', 'bb2362db-bb79-550d-a722-c849c6bc7ee7', '7a3593fb-27c6-5bed-a678-7678f16dc694', 'e3c7962c-b124-5de0-9e91-a2382d58a39d', 'd66d27df-8593-5f14-a7c4-0bc352eab269', 'a34cf3d8-841e-5277-8ef9-66a9d8659bd1', 'beb27003-b53b-5be9-bc7d-79c337997e67', '287249d7-d73c-5479-aeab-bd1208bcb4e9', '8323eadf-2d9b-5bf2-865a-a19f703bdbe3', '52f775a5-9f6d-5706-aedd-2befca9277e8', 'b4ba1f0b-7add-5613-9bc9-7f81653da047', '1b2ede3a-b847-51d2-b4c9-f18bde8c9963', 'cb6b615c-d0af-532b-b20c-08cdda3e006e', '0dc6d5d3-da53-5635-aeda-e3e54a400284', '9da0ea1c-2c1c-5f78-aea2-96469dadf6de', '590e9170-cd34-5e7d-a6f4-35f4dd273530', '93e8c005-e9fa-5a47-87ed-e7c721aed29f', '693ca151-0290-57e7-b386-b274d69d99c9', '5f978f50-9045-51ce-9bf0-02cc73eda6d3', 'c6b49bae-d828-56ae-8686-8381968589a8', 'cf1bc10c-e044-54fe-a838-8355476b7eb5', '99bbd436-528d-56ae-b3a6-f82c07506c58');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'svt-1ere-sec' AND source = 'admin' AND id NOT IN ('c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', '194de524-a981-5046-97c2-b5fd75a83615', 'c36f186f-3063-51cd-993c-dc9cec99830e', '9b5b7c6a-148c-5478-93da-b16535b99a16', '7f91558c-7618-5982-baef-81925e952f79', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'fbb8b06e-5283-56bb-972b-345b39829387', 'bc4dc18c-ab71-558f-b433-660d14f30960', '6642bf10-24ef-5328-a3c5-04d817695cfe', '4d10426c-9477-5321-8749-0ae925f7c072', '0d92bdbd-1381-56d7-a973-cad664304fd9', '236d1716-b860-5177-abe0-262196a23c6c', 'f5143bba-92a1-5776-b556-40312da896bc', '788bccf3-2e72-572a-aca1-e7f601538cca', '4ac06f80-a0bb-5634-bb6f-c848e8565c06', 'cc47fc9b-4f12-5d75-8f32-2f5510fdcac2', '2651bb3a-b0a3-55d5-9092-7ed4c993d3f1', '0eff20ca-a60b-58b0-98ec-6ba17513be7e', 'a4ad16ab-645a-5874-b779-e924880746ea', 'ee91b1db-e0c4-5eeb-9b2f-d1f8141aefe3', '6dccdf2a-b99f-5888-9622-c0201d5daec5', 'd1c3f92e-0177-5e9c-b448-bff50031a451');
DELETE FROM public.questions WHERE exercise_id IN ('c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', '194de524-a981-5046-97c2-b5fd75a83615', 'c36f186f-3063-51cd-993c-dc9cec99830e', '9b5b7c6a-148c-5478-93da-b16535b99a16', '7f91558c-7618-5982-baef-81925e952f79', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'fbb8b06e-5283-56bb-972b-345b39829387', 'bc4dc18c-ab71-558f-b433-660d14f30960', '6642bf10-24ef-5328-a3c5-04d817695cfe', '4d10426c-9477-5321-8749-0ae925f7c072', '0d92bdbd-1381-56d7-a973-cad664304fd9', '236d1716-b860-5177-abe0-262196a23c6c', 'f5143bba-92a1-5776-b556-40312da896bc', '788bccf3-2e72-572a-aca1-e7f601538cca', '4ac06f80-a0bb-5634-bb6f-c848e8565c06', 'cc47fc9b-4f12-5d75-8f32-2f5510fdcac2', '2651bb3a-b0a3-55d5-9092-7ed4c993d3f1', '0eff20ca-a60b-58b0-98ec-6ba17513be7e', 'a4ad16ab-645a-5874-b779-e924880746ea', 'ee91b1db-e0c4-5eeb-9b2f-d1f8141aefe3', '6dccdf2a-b99f-5888-9622-c0201d5daec5', 'd1c3f92e-0177-5e9c-b448-bff50031a451') AND id NOT IN ('e33a077b-ba10-5f6c-a4ad-5ed1a8083cca', 'ddb8f6f7-d20f-505d-b47e-e1bdd1190ab1', '89c9d68e-0825-5c8a-b227-53823dcebcce', 'b7800c09-23f7-5dd5-ae2d-a6b474a67475', 'dc95078f-4b07-5369-9d4e-20e7da51cfa6', '8370514e-445c-591a-92da-e4099e253999', '8e59a821-f39b-5ba3-ab73-5b234b3b6253', 'de8815b1-b69c-553b-b863-e04b9254f688', '027d4c81-285a-5dc1-9a33-4fa045cf121b', '3616a836-0f14-5737-b34c-8954e0492386', '24b390fb-9b31-5195-920e-32e25236b520', '7cd3036d-fd37-5e99-9ee9-18604e3d22f7', 'f55785f1-1488-598f-836d-6d962733d85c', '91a21c54-f5eb-5636-905d-ca036d1fbe7f', '9e6ec3b7-1a4a-5324-b693-4befe7421343', '96569c1c-2c6f-58ac-be1c-1e9c63f8544b', '2af41e79-44d7-54cc-87a8-f7e8fb554818', '52da7bdf-16c8-5b63-bad0-9a5ccf9e0eaf', 'e395ec07-d9a5-58de-8a71-7edaeef8becd', '650c89f2-ae8d-5657-ab66-78b9a5b5ac82', '99012c23-8348-5018-bbd4-4c21a5b1a8a8', 'e42de770-7ccd-57ae-9d50-7b8e1b9ad950', 'a19b2ff8-2759-5da5-bc6e-38b3629751f0', 'b090ddd8-59be-59ba-bb90-a5878b110d4f', '78b78f9b-886e-59b5-926c-f9edf845f4d7', '7c000b2d-a785-5dd1-957b-e13aa54f37fd', 'f850f95b-136b-5c31-bb57-875cc4a1461a', 'fe53f4af-f844-5250-b629-d6bb89028ce2', '09dce64e-c683-5928-a806-eb08a471da9b', '1627a75b-f528-5ca9-9be0-57f70af79631', '90414dcf-d539-5199-99be-a07837dbe49a', '928b07f4-9368-5470-86e9-e0e86a536a0f', '4fa20252-4e33-5378-adb2-98783f658dbb', 'ca3e8723-6581-5fa1-9b6a-988b944557e7', 'be73d5e3-1039-5dfb-82da-19796687e6ef', 'd0cb9d1b-054c-5c92-b59e-849adaab9a71', '95a19fac-1d90-527f-a28c-c57942c6bc24', 'be512e27-4044-5f2f-940a-b523152a8bda', '60c2aa9d-4ad7-562c-a6c9-51cc56144f19', '5ef56731-c4c9-5f6f-b1c8-c6bef53cfe5d', 'e9f3d64e-29c6-5e34-964b-43c05f5a88bd', '3364383e-d368-5784-86f2-de778373c561', '45559784-8b76-5964-8436-c523028c5c23', '8ae48a12-409a-5862-8d8b-fd5717b60f6b', '1112df0f-2cc9-57eb-8626-75a1f48d6489', 'd89a6f15-c64b-5dfa-b278-ec3148730ddd', '2b4dbb2c-1146-5029-8f9d-11c0f0067ec4', 'ada3ea63-8e05-59da-b2e8-d839fa08f014', '01e92174-0fd1-5e71-a5f9-ba16e036f152', 'b51d95dc-789a-52c6-bcf8-039d9a13dca2', '3bccf06b-e7b6-5bf7-b3cc-3aa369a65ea1', '93db0bf6-4904-59ee-8216-d62070775e36', 'bbecd10e-a6e6-5a5d-bb10-5a2ef046d067', '9cbf896b-6c63-553c-88c3-fba80035bffd', 'd67fe435-439d-5cdd-b681-1444debbd583', '86b52802-4f18-5911-b9c3-8708c3435d2f', '7a9274b5-d2b7-5f8c-8564-d7acc37e018a', '90d6ba8c-fca4-5f7d-9674-138b16f9463f', '24fecb22-d64c-5d54-a8bf-9306088600b2', 'ab63dbd7-8a4d-5dba-af67-419ec79cb5a6', 'dbb47327-f7c2-56bf-a720-d139236eb74c', '89651317-3ca1-5eb4-8fb2-fdc64e1b0b06', '49aa94ef-d027-5918-940e-187e21d1fb75', 'c6be8323-1727-5529-b909-6c6305de34d1', '8b73e34e-fb2e-50d1-a37f-d3abdbdcce6c', '83349456-85cd-5aac-998d-1ec9a6898925', 'f9ba1111-a24f-52a8-a6a3-8486dbc3e6eb', '38db394b-2177-5753-a9ab-d53a32e524ce', 'dbac647d-0d5e-580f-907a-5e57eeeb771f', 'e384258b-3d20-54a9-ae6f-19fe186e9878', '43a9dbcc-901b-5f32-83d3-5f6118d0f5c8', '93b872c2-093b-5433-a3b7-a5a903d75ef4', '02e3f652-c295-5d6c-ac2f-bfa87366f85a', '4d10e083-a407-5b92-a498-85dff46298cc', '26cfdbaf-ecf0-533f-8140-f917971c9f49', 'b53ab9da-3ff4-5339-bfc2-9d2bc5f1e4f9', '6b18a34a-3c9b-5028-8000-30eee51eb17e', 'a23c4160-2c2f-52ce-989b-88a04a5f3610', '5c55547f-e81a-5057-b685-23b9f9112636', '4805b54f-e480-5d4e-b718-67907ac46d15', '58e2372b-0887-591d-a88b-5ad0afd60f94', '18d2dbb8-e892-5570-8817-11aa0c3364cf', '079e6d0f-aae4-5bfe-a36d-529b57a6745c', '3ed9aabb-4be8-5a76-a1d2-7a59ab2b10cf', '2ee431fb-6d6e-52f2-b6de-c3a98721fa32', '0b570cd4-1967-52ba-a4f8-46cb8cb6ff6f', '8dec84d3-4361-5a2a-bab1-56e2efc6d1fd', '1325ba23-9c6b-534f-b08c-824d0727b657', 'f7a55277-f904-5dac-ab74-8b45bde673fd', '6e03b92d-bd46-56c7-b12a-4fc8decff5e8', '1b27a2fe-7908-5ca9-8d2f-8dfb1d87ed27', '58c92df4-f4b9-578d-91d4-b3bd404d2178', '855faa74-716d-53a9-88f7-34392574088d', '85b92d6e-f284-5183-ab50-9932c672fda6', 'e17c8cee-f9f6-5a1e-bd52-3df48e592677', 'b7ccbead-2ed7-52c5-aa81-7d3f63d9b62b', 'cd36905c-da35-5f18-b87b-eebfde30a477', 'a2061720-1c12-5241-8fb5-c5025f27247a', '26eeaf34-3224-58f5-bd9c-ef55a30bc297', 'a4f8266a-1bb2-5cea-8d27-c2360edc06c5', 'feb7e743-7450-5c4f-a514-49f62eef5d1c', '2d930ecb-33f7-5f7c-993b-8058926cc158', '653c1704-6c35-5847-97fa-1b32a6dfdd4f', 'f8667917-cb10-52f7-8a17-5bf73e70b803', 'cfdf2737-585a-527d-8599-dcd72feb9720', 'fca75037-b85a-5f66-8345-a427d9daea7c', '46e58148-8eab-527b-95b9-00295d715b1a', 'ef86ae65-2116-5477-8d4e-0ab3ec805ba2', 'a6a4a998-6434-5fe2-946d-90159d33cc1b', '5baf0c74-bedc-5ae6-bdf5-1bb35259bd41', '442eedd3-72c6-54f1-a5cd-c080ed17bac2', '8761db1b-e387-537c-850e-9cf67cf88b38', '61a384d3-05a2-5545-b134-31071d7a68fe', '2bdcfc97-b186-5b88-a16a-47f784473bb6', 'ecd9da59-79c5-52e3-bedd-3a007223118d', 'bb2362db-bb79-550d-a722-c849c6bc7ee7', '7a3593fb-27c6-5bed-a678-7678f16dc694', 'e3c7962c-b124-5de0-9e91-a2382d58a39d', 'd66d27df-8593-5f14-a7c4-0bc352eab269', 'a34cf3d8-841e-5277-8ef9-66a9d8659bd1', 'beb27003-b53b-5be9-bc7d-79c337997e67', '287249d7-d73c-5479-aeab-bd1208bcb4e9', '8323eadf-2d9b-5bf2-865a-a19f703bdbe3', '52f775a5-9f6d-5706-aedd-2befca9277e8', 'b4ba1f0b-7add-5613-9bc9-7f81653da047', '1b2ede3a-b847-51d2-b4c9-f18bde8c9963', 'cb6b615c-d0af-532b-b20c-08cdda3e006e', '0dc6d5d3-da53-5635-aeda-e3e54a400284', '9da0ea1c-2c1c-5f78-aea2-96469dadf6de', '590e9170-cd34-5e7d-a6f4-35f4dd273530', '93e8c005-e9fa-5a47-87ed-e7c721aed29f', '693ca151-0290-57e7-b386-b274d69d99c9', '5f978f50-9045-51ce-9bf0-02cc73eda6d3', 'c6b49bae-d828-56ae-8686-8381968589a8', 'cf1bc10c-e044-54fe-a838-8355476b7eb5', '99bbd436-528d-56ae-b3a6-f82c07506c58');
DELETE FROM public.chapters c WHERE c.subject_id = 'svt-1ere-sec' AND c.id NOT IN ('eb484ddb-29b8-522a-a8bd-be1247b74660', 'da09b891-f755-5773-8d01-3100b3d94215', 'c5edaf1a-f734-50f8-bea2-064b335edbcf', 'd0a86148-bdad-5274-8564-f6d944ce6b13', '972beaaf-ae6a-517d-8ab0-f127666f7061', 'a15437ac-fbc7-54e7-ad0d-892a7377dec1', 'e5983da0-45a8-5f71-b0e8-06496a06800b', 'ce4eb157-d67d-5937-b357-93ffb1c7ecd3') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('eb484ddb-29b8-522a-a8bd-be1247b74660', 'svt-1ere-sec', 'La nutrition minérale — de l''eau du sol à la feuille', 'Mise en évidence, localisation et mesure de l''absorption d''eau (zone pilifère, poil absorbant, potomètre) ; mécanisme osmotique de l''absorption (turgescence, plasmolyse, osmose, pression osmotique, milieux hypotonique et hypertonique, isotonie, conduction latérale) ; transpiration foliaire et stomates, facteurs internes et externes ; couplage absorption-transpiration (aspiration foliaire, poussée radiculaire, bilan hydrique) ; besoins en sels minéraux (méthode analytique, méthode synthétique, liquide de Knop, milieux carencés et symptômes, macroéléments et oligoéléments, déficience-optimum-toxicité) ; conduction verticale de la sève brute par le xylème ; amélioration de la production végétale par une irrigation et une fertilisation rationnelles, le choix des semences et la culture sous serre', '# ⚔️ La nutrition minérale — de l''eau du sol à la feuille

> 💡 «Une plante ne boit pas : elle aspire. Comprends la force qui fait entrer l''eau dans une racine, et tu sauras pourquoi un champ trop arrosé rend moins qu''un champ bien arrosé.»

Bienvenue en 1ère année secondaire, héros. Au collège tu as appris que la plante verte prélève dans le sol de l''eau et des sels minéraux par ses racines, et que la **sève brute** monte vers tous les organes. Cette quête ouvre la boîte noire : **par où** l''eau entre, **quelle force** l''y pousse, **comment** elle monte et **de quoi** la plante a réellement besoin. C''est le savoir sur lequel repose toute l''amélioration de la production végétale.

## 🌱 L''absorption d''eau : par où, et combien ?

Place une plante dans un tube d''eau et repère le niveau : 24 heures plus tard, le niveau a baissé. **L''absorption d''eau** est l''entrée d''eau dans la plante **par le système racinaire**.

Une jeune racine observée à la loupe binoculaire montre trois zones : la **coiffe** (à l''extrémité), la **zone pilifère** (couverte de fins prolongements) et la **zone subéreuse** (plus haut). C''est la **zone pilifère** qui absorbe : ses **poils absorbants** sont les cellules par lesquelles l''eau et les sels minéraux entrent.

::: figure Les poils absorbants sont tous rassemblés sur une seule zone de la racine — la zone pilifère : c''est là, et nulle part ailleurs, que l''eau entre
<svg viewBox="0 0 340 260">
<path d="M120 25 L120 122 L156 122 L156 25 Z" fill="#94a3b8" opacity="0.22"/>
<path d="M120 122 L120 198 L156 198 L156 122 Z" fill="#0f6e56" opacity="0.16"/>
<path d="M120 198 Q120 230 138 234 Q156 230 156 198 Z" fill="#0f172a" opacity="0.15"/>
<g fill="none" stroke="#0f172a" stroke-width="2" stroke-linecap="round">
<path d="M120 25 L120 198 Q120 230 138 234 Q156 230 156 198 L156 25"/>
</g>
<g fill="none" stroke="#0f172a" stroke-width="1.5">
<path d="M120 122 H156"/>
<path d="M120 198 H156"/>
</g>
<g fill="none" stroke="#0f6e56" stroke-width="1.8" stroke-linecap="round">
<path d="M120 132 L96 125"/><path d="M120 145 L94 141"/><path d="M120 158 L96 158"/><path d="M120 171 L94 175"/><path d="M120 184 L96 191"/>
<path d="M156 132 L180 125"/><path d="M156 145 L182 141"/><path d="M156 158 L180 158"/><path d="M156 171 L182 175"/><path d="M156 184 L180 191"/>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M156 70 H205"/><path d="M182 158 H208"/><path d="M150 226 H205"/><path d="M94 190 L66 206"/>
</g>
<g font-size="12" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="208" y="74" fill="#0f172a">zone subéreuse</text>
<text x="211" y="162" fill="#0f6e56">zone pilifère</text>
<text x="208" y="230" fill="#0f172a">coiffe</text>
<text x="55" y="219" text-anchor="middle" fill="#0f6e56">poil absorbant</text>
</g>
</svg>
:::

Un **poil absorbant** est minuscule mais innombrable : 12 à 15 μm de diamètre, 1 à plusieurs mm de long, jusqu''à 2000 par cm² chez les graminées — soit 14 milliards chez un seul plant de seigle, offrant environ **400 m² de surface de contact** avec la solution du sol.

_Exemple détaillé_ : on mesure l''absorption avec un **potomètre** (potos = boisson, mètre = mesure). L''index se déplace dans un tube capillaire de 2 mm de diamètre, donc de rayon R = 1 mm = 0,1 cm. Le volume absorbé pour 1 mm de déplacement vaut V = R × R × π × h = 0,1 × 0,1 × 3,14 × 0,1 = **0,00314 cm³**. Si l''index avance de 8 mm en 5 minutes, V = 0,00314 × 8 = **0,025 cm³**, soit une vitesse de 0,025 / 5 = 0,005 cm³/mn = **0,3 cm³/heure** ✓.

> 🗡️ Dans l''expérience de Rosène, cinq plants ont leurs racines plongées dans cinq tubes ; un seul, le tube A, a **toute** la racine dans l''eau, sans huile. Ce tube est le **témoin** : c''est lui qui prouve que ce n''est pas le dispositif qui empêche l''absorption dans les autres tubes.

## 💧 Le mécanisme : l''osmose

Une graine de pois chiche dans l''eau du robinet **gonfle** ; une olive dans l''eau fortement salée devient **crénelée**. Ces deux constatations sont l''affaire de cellules.

Plonge des fragments d''épiderme d''oignon violet dans du chlorure de sodium (NaCl) à trois concentrations : à **2 g/l** les cellules sont **turgescentes** (l''eau est entrée, la vacuole est gonflée) ; à **9 g/l** elles restent **normales** ; à **20 g/l** elles sont **plasmolysées** (l''eau est sortie, le cytoplasme se décolle de la paroi).

::: figure À gauche l''eau est entrée et plaque la membrane contre la paroi ; à droite elle est sortie et la membrane se décolle — c''est le même passage d''eau, dans les deux sens
<svg viewBox="0 0 340 200">
<rect x="30" y="45" width="112" height="112" fill="none" stroke="#0f172a" stroke-width="2.5"/>
<rect x="34" y="49" width="104" height="104" fill="none" stroke="#0f6e56" stroke-width="2"/>
<rect x="42" y="57" width="88" height="88" rx="8" fill="#7c3aed" opacity="0.35"/>
<circle cx="112" cy="128" r="8" fill="#0f172a" opacity="0.75"/>
<rect x="198" y="45" width="112" height="112" fill="none" stroke="#0f172a" stroke-width="2.5"/>
<rect x="218" y="65" width="72" height="72" rx="14" fill="none" stroke="#0f6e56" stroke-width="2"/>
<rect x="226" y="73" width="56" height="56" rx="10" fill="#7c3aed" opacity="0.35"/>
<circle cx="272" cy="122" r="7" fill="#0f172a" opacity="0.75"/>
<g font-size="12" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="86" y="36" text-anchor="middle" fill="#0f172a">NaCl 2 g/l</text>
<text x="254" y="36" text-anchor="middle" fill="#0f172a">NaCl 20 g/l</text>
<text x="86" y="180" text-anchor="middle" fill="#0f6e56">turgescente</text>
<text x="254" y="180" text-anchor="middle" fill="#0f6e56">plasmolysée</text>
</g>
</svg>
:::

L''**osmomètre** (un tube fermé par une membrane semi-perméable, rempli de sulfate de cuivre et plongé dans l''eau pure) montre la loi générale : le niveau de la solution **monte**. L''**osmose** est le passage d''eau à travers une membrane semi-perméable, du milieu **le moins concentré** vers le milieu **le plus concentré**, jusqu''à l''égalité des concentrations, ou **isotonie**.

La force en jeu est la **pression osmotique** : la force exercée par les particules dissoutes sur le solvant.

$$ π = n.R.T $$

avec n = nombre de moles de soluté par litre, R = 0,082 et T = température en degré Kelvin = T°C + 273. Un milieu de **faible** pression osmotique est dit **hypotonique** par rapport à un second ; un milieu de **forte** pression osmotique est dit **hypertonique**.

_Exemple détaillé_ : la solution du sol est à 0,5 atm ; le poil absorbant est à 0,7 atm. Le poil est donc **hypertonique** par rapport au sol : l''eau y entre par osmose. Et de cellule en cellule la pression **augmente** — 0,7 puis 1,4 ; 1,8 ; 2,1 ; 2,8 ; 3 atm en allant vers le cylindre central : l''eau traverse horizontalement la racine, toujours du moins concentré vers le plus concentré. C''est la **conduction latérale**.

> ⚠️ Piège classique : l''osmose ne fait pas passer l''eau « du plus vers le moins ». C''est l''inverse — l''eau va **vers** le milieu le plus concentré. C''est pour cela que l''olive dans la saumure se ratatine au lieu de gonfler.

## 🌬️ La transpiration et les stomates

La plante perd une bonne partie de l''eau absorbée sous forme de **vapeur**, surtout par les feuilles : c''est la **transpiration**. Une lamelle de verre posée sur chaque face d''une feuille se couvre de buée : **les deux faces transpirent**, mais la face inférieure transpire davantage.

La structure responsable est le **stomate** : deux **cellules stomatiques** bordant un orifice, l''**ostiole**, par où sort la vapeur d''eau. L''ostiole change de diamètre selon les conditions du milieu.

::: figure Ce n''est pas la feuille qui s''ouvre, ce sont deux cellules : en s''écartant, elles ménagent entre elles l''ostiole par où la vapeur s''échappe
<svg viewBox="0 0 340 220">
<g fill="none" stroke="#94a3b8" stroke-width="1.5">
<path d="M30 40 L110 45 L120 100 L100 165 L34 172 Z"/>
<path d="M230 45 L308 40 L312 172 L240 165 L220 100 Z"/>
</g>
<path d="M170 45 C 118 58, 118 142, 170 155 C 146 132, 146 68, 170 45 Z" fill="#0f6e56" opacity="0.32" stroke="#0f172a" stroke-width="2" stroke-linejoin="round"/>
<path d="M170 45 C 222 58, 222 142, 170 155 C 194 132, 194 68, 170 45 Z" fill="#0f6e56" opacity="0.32" stroke="#0f172a" stroke-width="2" stroke-linejoin="round"/>
<path d="M170 45 C 146 68, 146 132, 170 155 C 194 132, 194 68, 170 45 Z" fill="#ffffff" stroke="#0f172a" stroke-width="1.5"/>
<circle cx="142" cy="100" r="5" fill="#0f172a" opacity="0.75"/>
<circle cx="198" cy="100" r="5" fill="#0f172a" opacity="0.75"/>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M175 78 L246 44"/><path d="M136 140 L104 190"/>
</g>
<g font-size="12" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="249" y="40" fill="#0f6e56">ostiole</text>
<text x="86" y="206" text-anchor="middle" fill="#0f172a">cellule stomatique</text>
<text x="286" y="206" text-anchor="middle" fill="#94a3b8">épiderme</text>
</g>
</svg>
:::

L''intensité de la transpiration dépend de deux familles de facteurs :

| Facteurs                          | Ils augmentent la transpiration quand…                                                                   |
| --------------------------------- | -------------------------------------------------------------------------------------------------------- |
| **Internes** (propres au végétal) | la surface foliaire est grande ; la densité des stomates (nombre par unité de surface) est élevée        |
| **Externes** (environnement)      | il y a de la lumière ; la température s''élève (jusqu''à 25 à 30 °C) ; l''air se dessèche ; l''air est agité |

Les facteurs externes agissent tous de la même façon : ils **favorisent l''ouverture des ostioles**.

> 🗡️ La feuille de tilleul n''a **aucun** stomate sur sa face supérieure et transpire pourtant 200 mg par 24 h : sa **cuticule** est mince et laisse passer la vapeur. La cuticule est une voie accessoire de transpiration.

## ⚖️ Absorption et transpiration sont couplées

Deux potomètres, deux plantes de même taille et de même âge : la plante entière (A) et la même **privée de quelques feuilles** (B). En 20 minutes l''index avance de 48 mm en A contre 21 mm en B. Moins de feuilles ⇒ moins de transpiration ⇒ **moins d''absorption**.

La perte d''eau par les feuilles crée un appel d''eau : c''est l''**aspiration foliaire**. Mais un rameau de vigne coupé au printemps « pleure » alors qu''il n''a pas de feuilles : la sève est aussi **poussée** par la racine — c''est la **poussée radiculaire**, que l''expérience de Hales met en évidence avec un manomètre à mercure. Dans la plante, **l''eau est à la fois poussée et aspirée**.

Le **bilan hydrique** est la différence entre l''eau absorbée et l''eau perdue. S''il devient **négatif** durablement — l''eau manque dans le sol — la plante se fane et peut mourir : il faut irriguer.

> ⚠️ Ne confonds pas les deux moteurs : l''aspiration foliaire vient **du haut** (les feuilles) et s''arrête si la plante est effeuillée ; la poussée radiculaire vient **du bas** (les racines) et continue sans feuilles.

## 🧪 Les besoins en sels minéraux

Deux méthodes complémentaires répondent à la question « de quoi la plante a-t-elle besoin ? ».

- La **méthode analytique** : on brûle le végétal et on analyse les gaz et les cendres ; on obtient sa **composition élémentaire**. La luzerne est ainsi faite, en % de matière fraîche, de C 11,34 · H 8,72 · O 77,90 · N 0,82 · P 0,71 · S 0,10 — à eux six, **99,59 %** — le reste (Ca, Na, K, Mg, Al, Si, Fe) ne pesant que des fractions de pour cent.
- La **méthode synthétique** : on fabrique une solution nutritive à partir de cette composition. En 1860, **Knop** compose un **milieu synthétique complet** (nitrate de calcium 1 g, nitrate de potassium 0,25 g, sulfate de magnésium 0,25 g, phosphate monopotassique 0,25 g, chlorure ferrique 0,001 g, eau qsp 1000 ml) : les plantes s''y développent, fleurissent et donnent des graines fertiles. Un **milieu synthétique incomplet**, ou **carencé**, est privé d''un élément.

_Exemple détaillé_ : six lots de maïs, un sur milieu de Knop (le **témoin**) et cinq sur milieux carencés. Au bout de 3 semaines, chaque carence laisse **sa** signature :

| Milieu de culture | État des feuilles                        | Masse sèche (g / 100 pieds) |
| ----------------- | ---------------------------------------- | --------------------------: |
| Knop (complet)    | normales                                 |                         162 |
| sans azote        | chlorose                                 |                          68 |
| sans phosphore    | jaunissement à l''extrémité des feuilles  |                         116 |
| sans potassium    | nécrose                                  |                          44 |
| sans magnésium    | jaunissement du limbe entre les nervures |                         120 |
| sans fer          | chlorose                                 |                         130 |

Tous ces éléments sont donc nécessaires — mais pas aux mêmes doses. Les **macroéléments** (azote, phosphore, soufre, potassium) sont nécessaires à des doses de l''ordre du **gramme au milligramme** ; ils entrent dans la composition des organes et dans le fonctionnement des cellules. Les **oligoéléments** (calcium, magnésium, zinc, fer, chlore) sont nécessaires à des doses de l''ordre du **microgramme** ; ils interviennent dans le fonctionnement de la plante.

Et pour un même élément, la dose fait tout. On cultive 13 lots sur des milieux ne différant que par leur teneur en potassium, et on mesure leur vitesse de croissance :

::: figure Trois domaines sur une seule courbe : la croissance grimpe, plafonne, puis s''effondre — trop de potassium est aussi nuisible que pas assez
<svg viewBox="0 0 340 260">
<path d="M50 226 V220 H328" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M322 214 L331 220 L322 226 Z M44 59 L50 48 L56 59 Z" fill="#0f172a"/>
<path d="M182.5 220 V56 M235.5 220 V56" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="5 4"/>
<path d="M50 220 V50" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M76.5 196.9 L89.8 187 L103 173.8 L129.5 154 L156 121 L182.5 67.1 L195.8 63.8 L209 62.7 L222.3 64.9 L235.5 66 L262 110 L288.5 165 L315 209" fill="none" stroke="#0f6e56" stroke-width="2.5" stroke-linejoin="round" stroke-linecap="round"/>
<g fill="#0f6e56">
<circle cx="76.5" cy="196.9" r="2.4"/><circle cx="89.8" cy="187" r="2.4"/><circle cx="103" cy="173.8" r="2.4"/><circle cx="129.5" cy="154" r="2.4"/><circle cx="156" cy="121" r="2.4"/><circle cx="182.5" cy="67.1" r="2.4"/><circle cx="195.8" cy="63.8" r="2.4"/><circle cx="209" cy="62.7" r="3.6"/><circle cx="222.3" cy="64.9" r="2.4"/><circle cx="235.5" cy="66" r="2.4"/><circle cx="262" cy="110" r="2.4"/><circle cx="288.5" cy="165" r="2.4"/><circle cx="315" cy="209" r="2.4"/>
</g>
<g fill="none" stroke="#0f172a" stroke-width="1.5">
<path d="M46 165 H50"/><path d="M46 110 H50"/><path d="M46 55 H50"/>
<path d="M182.5 220 V224"/><path d="M235.5 220 V224"/><path d="M315 220 V224"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="42" y="169" text-anchor="end" fill="#0f172a">50</text>
<text x="42" y="114" text-anchor="end" fill="#0f172a">100</text>
<text x="42" y="59" text-anchor="end" fill="#0f172a">150</text>
<text x="182.5" y="236" text-anchor="middle" fill="#0f172a">500</text>
<text x="235.5" y="236" text-anchor="middle" fill="#0f172a">700</text>
<text x="315" y="236" text-anchor="middle" fill="#0f172a">1000</text>
<text x="316" y="252" text-anchor="middle" fill="#0f172a">mg/l</text>
<text x="116" y="40" text-anchor="middle" fill="#0f172a">déficience</text>
<text x="209" y="40" text-anchor="middle" fill="#0f6e56">optimum</text>
<text x="276" y="40" text-anchor="middle" fill="#0f172a">toxicité</text>
</g>
</svg>
:::

En dessous de 500 mg/l, la croissance est limitée par le manque : c''est la **déficience**. Entre 500 et 700 mg/l, elle est maximale (143 à 600 mg/l) : c''est la **concentration optimale**. Au-delà de 700 mg/l, elle s''effondre (10 seulement à 1000 mg/l) : la **concentration toxique** empoisonne la plante.

## 🚰 La conduction verticale : le xylème

Plonge une tige de marguerite dans de l''éosine à 2 % : le colorant se retrouve en haut, dans les pétales. Une racine de carotte dans du bleu de méthylène à 1 % pendant 24 heures montre, en coupe, les canaux empruntés. Ce sont les **vaisseaux du bois**.

Le **carmino-vert** les révèle : il colore en **vert** les parois riches en **lignine** (le bois) et en **rose foncé** celles riches en **cellulose**. Un **vaisseau du bois** est une file de **cellules mortes**, réduites à leur paroi lignifiée ; l''ensemble des vaisseaux du bois forme le **xylème**. Selon l''épaississement de leur paroi on distingue les vaisseaux **annelés**, **spiralés** et **réticulés**.

La **sève brute** — le mélange d''eau et de sels minéraux — y monte des racines vers les feuilles, poussée par la racine et aspirée par les feuilles.

## 🚜 Améliorer la production végétale

Tout ce qui précède sert ici : on améliore le rendement en agissant sur les facteurs de la nutrition minérale.

- **Une irrigation rationnelle**, ni excès ni déficit. Trop d''eau coûte cher, assèche les nappes et provoque une **asphyxie des racines**, qui réduit l''absorption. Un déficit fait chuter le rendement, surtout pendant la **reproduction**, période la plus sensible ; le tournesol supporte bien un déficit modéré, le maïs beaucoup moins. Il faut choisir la technique, le moment et le volume.
- **Une fertilisation du sol**, pour restituer les éléments consommés. La **fertilisation minérale** épand des engrais chimiques (azote, phosphore, potassium) : **simples** s''ils apportent un seul élément, **composés** s''ils en apportent plusieurs. La **fertilisation organique** apporte fumier, déchets ou **engrais vert** (on sème du trèfle ou de la luzerne puis on l''enfouit) : les micro-organismes le minéralisent progressivement et libèrent des nitrates.
- **La lutte contre les mauvaises herbes**, qui concurrencent la culture pour l''eau et les sels minéraux.
- **Des semences sélectionnées** sur leur productivité et leur résistance aux maladies. En 1943, les agronomes mexicains ont trouvé une variété de blé résistante à la **rouille de la tige** ; le Mexique est devenu autosuffisant en blé.
- **La culture sous serre**, où les conditions climatiques, hydriques et thermiques sont contrôlées, et la **culture hors-sol**, où la plante pousse sur une solution nutritive dosée — le milieu synthétique de Knop devenu technique agricole.

> 🏆 Première quête franchie, héros : tu sais par où l''eau entre, quelle force l''y pousse, ce qui la fait monter et pourquoi une dose d''engrais peut tuer une plante. Il te reste une énigme : la plante ne mange pas que des minéraux — d''où vient son carbone ? C''est le prochain chapitre.', '# 📜 Résumé : La nutrition minérale

- **Absorption d''eau** : entrée d''eau par le système racinaire, au niveau des **poils absorbants** de la **zone pilifère** (12 à 15 μm de diamètre, jusqu''à 2000/cm², environ 400 m² de surface chez un plant de seigle) ; on la mesure au **potomètre** et on en tire une vitesse en cm³/heure.
- **Osmose** : passage d''eau à travers une membrane semi-perméable, du milieu **le moins concentré (hypotonique)** vers **le plus concentré (hypertonique)**, jusqu''à l''**isotonie** ; d''où la **turgescence** (NaCl 2 g/l) et la **plasmolyse** (NaCl 20 g/l). La force est la **pression osmotique** π = n.R.T (R = 0,082 ; T en degré Kelvin = T°C + 273).
- **Conduction latérale** : la pression osmotique croît du poil absorbant vers le cylindre central, donc l''eau traverse la racine de cellule en cellule, toujours par osmose.

::: figure La pression osmotique monte à chaque cellule : c''est ce seul escalier de valeurs qui tire l''eau du sol jusqu''au cylindre central
<svg viewBox="0 0 340 130">
<path d="M20 26 H304" fill="none" stroke="#0f6e56" stroke-width="2"/>
<path d="M300 20 L310 26 L300 32 Z" fill="#0f6e56"/>
<rect x="14" y="40" width="42" height="60" fill="#38bdf8" opacity="0.25" stroke="#0f172a" stroke-width="1.5"/>
<g stroke="#0f172a" stroke-width="1.5">
<rect x="60" y="40" width="40" height="60" fill="#0f6e56" opacity="0.10"/>
<rect x="102" y="40" width="40" height="60" fill="#0f6e56" opacity="0.16"/>
<rect x="144" y="40" width="40" height="60" fill="#0f6e56" opacity="0.22"/>
<rect x="186" y="40" width="40" height="60" fill="#0f6e56" opacity="0.28"/>
<rect x="228" y="40" width="40" height="60" fill="#0f6e56" opacity="0.34"/>
<rect x="270" y="40" width="40" height="60" fill="#0f6e56" opacity="0.40"/>
</g>
<g font-size="12" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="162" y="19" text-anchor="middle" fill="#0f6e56">H₂O</text>
<text x="35" y="75" text-anchor="middle" fill="#0f172a">0,5</text>
<text x="80" y="75" text-anchor="middle" fill="#0f172a">0,7</text>
<text x="122" y="75" text-anchor="middle" fill="#0f172a">1,4</text>
<text x="164" y="75" text-anchor="middle" fill="#0f172a">1,8</text>
<text x="206" y="75" text-anchor="middle" fill="#0f172a">2,1</text>
<text x="248" y="75" text-anchor="middle" fill="#0f172a">2,8</text>
<text x="290" y="75" text-anchor="middle" fill="#0f172a">3</text>
<text x="35" y="118" text-anchor="middle" fill="#0f172a">sol</text>
<text x="102" y="118" text-anchor="middle" fill="#0f6e56">poil absorbant</text>
<text x="272" y="118" text-anchor="middle" fill="#0f172a">cylindre central</text>
</g>
</svg>
:::

- **Transpiration** : perte d''eau sous forme de vapeur, par les **deux faces** de la feuille (davantage par l''inférieure), à travers les **stomates** (deux cellules stomatiques bordant un **ostiole**) ; la **cuticule** est une voie accessoire. Elle augmente avec la surface foliaire et la densité stomatique (facteurs internes), et avec la lumière, la température (jusqu''à 25 à 30 °C), le dessèchement et l''agitation de l''air (facteurs externes).
- **Couplage absorption ↔ transpiration** : la transpiration crée l''**aspiration foliaire** ; la racine exerce la **poussée radiculaire** (pleurs de la vigne, expérience de Hales). L''eau est à la fois poussée et aspirée. Le **bilan hydrique** = eau absorbée − eau perdue ; négatif, la plante se fane.
- **Besoins en sels minéraux** : établis par la **méthode analytique** (composition élémentaire) et la **méthode synthétique** (milieu de Knop, milieux carencés → chlorose, nécrose, jaunissements). **Macroéléments** N, P, S, K (du g au mg) ; **oligoéléments** Ca, Mg, Zn, Fe, Cl (de l''ordre du μg). Trois domaines de dose : **déficience / optimum / toxicité**.
- **Conduction verticale** : la **sève brute** (eau + sels minéraux) monte des racines aux feuilles dans les **vaisseaux du bois** — files de cellules mortes à paroi lignifiée (annelés, spiralés, réticulés) — dont l''ensemble forme le **xylème** ; le **carmino-vert** colore la lignine en vert et la cellulose en rose foncé.
- **Amélioration de la production** : irrigation rationnelle (excès → asphyxie racinaire ; déficit → chute du rendement, la reproduction étant le stade le plus sensible), fertilisation minérale (engrais simples ou composés) et organique (fumier, engrais vert), lutte contre les mauvaises herbes, semences sélectionnées, culture sous serre et hors-sol.', 1, '{"code":"225104P00","pages":"8-43","pageNumbers":[8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('da09b891-f755-5773-8d01-3100b3d94215', 'svt-1ere-sec', 'La nutrition carbonée — l''usine à matière organique', 'Mise en évidence des substances organiques (glucides, protides, lipides) dans les organes de réserve et dans la feuille ; les trois conditions de la photosynthèse démontrées expérimentalement (lumière, chlorophylle, dioxyde de carbone) ; la cellule chlorophyllienne et le chloroplaste comme siège, spectre d''absorption et spectre d''action ; l''origine du carbone et de l''oxygène établie par marquage radioactif et la photolyse de l''eau ; les deux phases de la photosynthèse (expérience de Gaffron) et l''équation globale ; le transport de la sève élaborée par le phloème (tubes criblés, annélation, sens de circulation) et la mise en réserve ; l''intensité photosynthétique, la relation IPN = IPB − IR, le point de compensation et les facteurs limitants ; les risques sanitaires des nitrates et des pesticides, les engrais naturels et la lutte biologique', '# ⚔️ La nutrition carbonée — l''usine à matière organique

> 💡 «Une plante ne mange que du minéral, et pourtant elle fabrique du sucre, de l''huile et des protéines. Découvre l''usine qui réalise ce tour de force — et la source d''énergie qui la fait tourner.»

Au chapitre précédent, héros, tu as suivi l''eau et les sels minéraux du sol jusqu''à la feuille. Mais la production végétale n''est pas faite que d''eau et de minéraux : elle est faite de **substances carbonées** — glucides, lipides, protides. La plante se nourrit **uniquement** de matière minérale et fabrique pourtant toute cette matière organique. Comment ? À quelles conditions ? Et à quel prix pour notre santé quand on veut en produire toujours plus ?

## 🍞 La matière organique dans la plante verte

La matière vivante comporte trois groupes de substances organiques : les **glucides**, les **protides** et les **lipides**. Chacun se révèle par un test simple.

| Substance recherchée                     | Manipulation                                       | Résultat                                                |
| ---------------------------------------- | -------------------------------------------------- | ------------------------------------------------------- |
| **Amidon** (tubercule de pomme de terre) | ajouter quelques gouttes d''**eau iodée**           | coloration **bleue foncée**                             |
| **Glucose** (jus de raisin)              | ajouter de la **liqueur de Fehling** et chauffer   | **précipité rouge brique**                              |
| **Gluten** (graines de fève, de haricot) | recouvrir de **CuSO₄**, vider, ajouter de la soude | coloration **violette**                                 |
| **Huile** (olive)                        | frotter l''échantillon sur un papier                | **tache translucide** qui ne disparaît pas à la chaleur |

L''**amidon** est une grosse molécule glucidique, association de nombreuses molécules de **glucose** ; un **protide** est formé de plusieurs acides aminés ; un **lipide** est une matière grasse.

_Exemple détaillé_ : les feuilles d''un plant de pomme de terre contiennent de l''amidon **à la fin de la journée**, et n''en contiennent plus **au début de la journée suivante**. Deux indices en un : la feuille en fabrique le jour, et ce qu''elle fabrique **ne reste pas sur place**.

## ☀️ Les trois conditions de la photosynthèse

La formation de matière organique à partir de matière minérale, avec de l''énergie lumineuse, s''appelle la **photosynthèse**. Trois expériences, trois conditions — chacune obtenue en supprimant **un seul** facteur.

| Ce qu''on supprime         | Le montage                                                                                        | Ce qu''on démontre               |
| ------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------- |
| La **lumière**            | un **cache opaque** sur une partie d''une feuille de pélargonium                                   | sans lumière, pas d''amidon      |
| La **chlorophylle**       | une feuille **panachée** (des zones vertes, des zones blanches) exposée à la lumière              | sans chlorophylle, pas d''amidon |
| Le **dioxyde de carbone** | l''air du sac n° 2 barbote dans la **potasse**, qui absorbe le CO₂ ; le sac n° 1 est le **témoin** | sans CO₂, pas d''amidon          |

Dans chaque cas, on révèle l''amidon de la même façon : eau bouillante (pour tuer les cellules), alcool bouillant (pour décolorer), puis eau iodée.

> 🗡️ Dans le montage du CO₂, l''air traverse **deux** flacons : le premier (potasse) absorbe le dioxyde de carbone ; le second (eau de chaux) **contrôle** qu''il a bien été totalement absorbé. Un montage sérieux ne se contente pas d''agir : il vérifie qu''il a agi.

La **chlorophylle** est le pigment responsable de la coloration verte des végétaux ; elle est nécessaire à la photosynthèse.

## 🔬 Le siège : le chloroplaste — et le rôle de la chlorophylle

Une petite feuille d''élodée montée entre lame et lamelle révèle l''organisation de la **cellule chlorophyllienne** : une **paroi pectocellulosique**, un **cytoplasme**, et — c''est ce qui la distingue de toute autre cellule végétale — des **chloroplastes**.

::: figure Ce qui distingue une cellule chlorophyllienne d''une autre cellule végétale, ce sont ces petits corps verts : les chloroplastes
<svg viewBox="0 0 340 220">
<rect x="90" y="60" width="170" height="110" rx="5" fill="none" stroke="#0f172a" stroke-width="3"/>
<rect x="95" y="65" width="160" height="100" rx="3" fill="#0f6e56" opacity="0.07"/>
<g fill="#0f6e56" opacity="0.7" stroke="#0f172a" stroke-width="1.2">
<ellipse cx="125" cy="86" rx="17" ry="9" transform="rotate(-20 125 86)"/>
<ellipse cx="175" cy="74" rx="17" ry="9" transform="rotate(10 175 74)"/>
<ellipse cx="222" cy="90" rx="17" ry="9" transform="rotate(-15 222 90)"/>
<ellipse cx="152" cy="118" rx="17" ry="9" transform="rotate(15 152 118)"/>
<ellipse cx="205" cy="140" rx="17" ry="9" transform="rotate(-10 205 140)"/>
<ellipse cx="238" cy="118" rx="17" ry="9" transform="rotate(25 238 118)"/>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M170 38 V58"/><path d="M232 84 L280 66"/><path d="M108 148 L62 178"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="170" y="30" text-anchor="middle" fill="#0f172a">paroi pectocellulosique</text>
<text x="300" y="62" text-anchor="middle" fill="#0f6e56">chloroplaste</text>
<text x="42" y="192" text-anchor="middle" fill="#0f172a">cytoplasme</text>
</g>
</svg>
:::

Le **chloroplaste** est l''organite de la cellule végétale **où se déroule la photosynthèse** — c''est là que l''eau iodée révèle l''amidon, chez les plantes éclairées et seulement chez elles.

Que fait exactement la chlorophylle ? On l''extrait en broyant des feuilles vertes avec du sable et de l''alcool à 90°, puis en filtrant : on obtient une **solution de chlorophylle brute**. Un prisme placé devant une source lumineuse décompose la lumière blanche sur un écran : c''est le **spectre de la lumière blanche**, l''ensemble des radiations élémentaires qui la composent. Intercale la solution de chlorophylle : des **bandes d''absorption** apparaissent — certaines radiations ont été retenues.

- Le **spectre d''absorption** est la variation de l''absorption de la lumière en fonction de la longueur d''onde. Chaque molécule a le sien.
- Le **spectre d''action** est la variation de l''**intensité photosynthétique** en fonction de la longueur d''onde des radiations éclairantes.

Les deux se superposent : **les radiations les plus absorbées sont celles qui font le plus travailler la photosynthèse**. La chlorophylle ne subit pas la lumière : elle en **capte** l''énergie.

## 💨 D''où viennent le carbone et l''oxygène ? La photolyse de l''eau

Pour savoir d''où vient un atome, on le **marque** : on le rend radioactif et on le suit. Trois expériences sur des chlorelles (des algues unicellulaires) suffisent à tout trancher.

| Expérience                                               | Résultat                                                         |
| -------------------------------------------------------- | ---------------------------------------------------------------- |
| CO₂ dont le **carbone** est radioactif                   | les **glucides** fabriqués sont radioactifs                      |
| CO₂ dont l''**oxygène** est radioactif                    | l''O₂ dégagé n''est **pas** radioactif ; les **glucides** le sont  |
| **Eau** dont l''**oxygène** est radioactif, forte lumière | l''O₂ dégagé **est** radioactif ; les glucides ne le sont **pas** |
| La même, mais **à l''obscurité**                          | **aucun** dégagement d''oxygène                                   |

Conclusion sans échappatoire : le **carbone** de la matière organique vient du **dioxyde de carbone**, tandis que l''**oxygène dégagé** vient de l''**eau** — et son dégagement exige la lumière.

Le mécanisme porte un nom. Sous l''action de la lumière et en présence de chlorophylle, la molécule d''eau se décompose :

$$ 2 H₂O → O₂ + 4 H⁺ + 4 e⁻ $$

C''est la **photolyse de l''eau**, une réaction photochimique. L''oxygène est dégagé ; les protons, eux, serviront avec le CO₂ à fabriquer la matière organique.

> ⚠️ Piège classique : l''oxygène rejeté par la plante ne vient **pas** du CO₂, malgré son nom. Il vient de l''eau — la troisième expérience le prouve, et c''est exactement ce que les deux premières interdisaient de croire.

## ⚗️ Le déroulement : deux phases, une équation

En 1951, **Gaffron** apporte à des algues fortement éclairées du CO₂ radioactif, puis les passe à l''obscurité. Le carbone continue d''être incorporé pendant **15 à 20 secondes** — mais seulement si les algues ont reçu au préalable une forte illumination d''**au moins 10 minutes**. Sans cette illumination préalable, l''incorporation cesse dès le passage à l''obscurité.

Autrement dit : l''incorporation du CO₂ ne dépend **pas directement** de la lumière — elle dépend de quelque chose que la lumière a **mis en réserve**. La photosynthèse comprend donc deux ensembles de réactions :

1. La **phase photochimique**, à la lumière : la photolyse de l''eau et le **stockage d''énergie chimique**.
2. La **phase sombre**, dont le déroulement n''exige pas directement la lumière : l''**incorporation du CO₂** et la synthèse des substances organiques, avec l''énergie chimique stockée pendant la phase précédente.

D''où l''équation globale de la photosynthèse :

$$ 6 CO₂ + 6 H₂O → C₆H₁₂O₆ + 6 O₂ $$

(la lumière et la chlorophylle sont les conditions de la réaction ; C₆H₁₂O₆ est le glucose). Les premières substances fabriquées sont des **glucides simples** ; c''est à partir d''eux que la plante élabore les autres glucides (glucose, amidon), puis les lipides et les protides.

> 🗡️ Retiens le sens de la phrase « phase sombre » : elle ne se déroule pas **dans le noir**, elle se déroule **sans avoir besoin de la lumière**. En plein jour, les deux phases tournent en même temps.

## 🚚 La sève élaborée et le phloème

Les racines grandissent sans pouvoir fabriquer leur propre matière ; le tubercule de pomme de terre est bourré d''amidon sans pouvoir en synthétiser. Ce que la feuille fabrique **voyage**.

Une coupe transversale de pétiole colorée au carmin aluné vert d''iode montre **deux** sortes de vaisseaux : ceux de la sève brute (parois lignifiées, vertes) et ceux de la **sève élaborée** (parois cellulosiques, roses). La **cellulose** se colore en rose, la **lignine** en vert.

Les vaisseaux de la sève élaborée forment le **phloème** : ce sont des **tubes criblés**, chacun formé d''une file de **cellules vivantes** dont les **parois transversales sont percées de pores**.

::: figure La cellule d''un tube criblé a perdu son noyau et sa vacuole, et sa paroi transversale est criblée de pores — c''est par là que passe la sève élaborée
<svg viewBox="0 0 340 210">
<rect x="25" y="30" width="110" height="150" fill="none" stroke="#0f172a" stroke-width="2.5"/>
<rect x="29" y="34" width="102" height="142" fill="#0f6e56" opacity="0.10"/>
<rect x="42" y="52" width="76" height="90" rx="10" fill="#7c3aed" opacity="0.30"/>
<circle cx="105" cy="158" r="10" fill="#0f172a" opacity="0.75"/>
<rect x="205" y="30" width="110" height="150" fill="none" stroke="#0f172a" stroke-width="2.5"/>
<rect x="209" y="34" width="102" height="142" fill="#0f6e56" opacity="0.10"/>
<g stroke="#0f172a" stroke-width="3" fill="none">
<path d="M205 105 H222 M232 105 H247 M257 105 H272 M282 105 H297 M307 105 H315"/>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M114 160 L150 172"/><path d="M186 103 L228 105"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="80" y="101" text-anchor="middle" fill="#0f172a">vacuole</text>
<text x="170" y="180" text-anchor="middle" fill="#0f172a">noyau</text>
<text x="170" y="100" text-anchor="middle" fill="#0f6e56">pores</text>
<text x="80" y="200" text-anchor="middle" fill="#0f172a">cellule normale</text>
<text x="260" y="200" text-anchor="middle" fill="#0f6e56">tube criblé</text>
</g>
</svg>
:::

Dans quel sens circule cette sève ? Découpe **en anneau** l''écorce d''une tige : la plante reste alimentée en sève brute et la photosynthèse continue. Quelques heures plus tard, les substances organiques sont **anormalement abondantes au-dessus** de la zone décortiquée ; plusieurs semaines plus tard, un **bourrelet de cicatrisation** s''y est formé, **au-dessus** lui aussi. La sève élaborée était donc en train de **descendre** et l''anneau l''a bloquée.

La **sève élaborée** est la solution contenant les produits de la photosynthèse. Elle est distribuée à **tous les organes** — notamment vers le bas, vers les racines et les organes de réserve — à l''inverse de la sève brute, qui ne fait que monter. Une partie des molécules est dégradée pour produire l''énergie des fonctions vitales ; une autre est stockée : dans le tubercule de pomme de terre, l''eau iodée révèle des **amyloplastes**, ces cellules où l''amidon est mis en réserve.

## 📈 Les conditions optimales de la photosynthèse

L''**intensité photosynthétique (IP)** est la quantité de CO₂ absorbé ou d''O₂ rejeté **par unité de masse du végétal et par unité de temps**. Elle dépend de trois facteurs.

**1. L''intensité lumineuse.** Attention : la plante **respire aussi**, 24 heures sur 24, et la respiration consomme de l''oxygène. Ce que l''on mesure est donc un bilan, l''intensité photosynthétique **nette** :

$$ IPN = IPB − IR $$

où IPB est l''intensité photosynthétique brute et IR l''intensité respiratoire. À l''obscurité, seule la respiration est mesurée : l''IPN est négative. Pour un éclairement précis, IPB = IR — tout l''oxygène produit est consommé, le bilan est nul : c''est le **point de compensation**. Au-delà, l''IPN devient positive et croît, puis atteint un **palier**. Cet optimum n''est pas le même pour toutes les plantes : les **plantes de soleil** (épinard, pomme de terre) l''atteignent sous fort éclairement, les **plantes d''ombre** (fougère) sous un éclairement beaucoup plus faible.

**2. Le taux de CO₂.** L''IP augmente avec la teneur de l''air en dioxyde de carbone, puis cesse d''augmenter à partir de 0,3 % ; au-delà, elle peut même baisser — le CO₂ devient **toxique** pour le végétal.

::: figure Au-delà de 0,15 % de CO₂ la courbe se couche : ajouter du dioxyde de carbone ne change plus rien, car c''est un autre facteur qui limite désormais la photosynthèse
<svg viewBox="0 0 340 250">
<path d="M55 216 V210 H325" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M319 204 L328 210 L319 216 Z M49 56 L55 45 L61 56 Z" fill="#0f172a"/>
<path d="M55 210 V47" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M237.1 63.3 H312 M237.1 210 V70" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="5 4"/>
<path d="M55 196.7 L91.4 163.3 L127.9 130 L164.3 103.3 L200.7 76.7 L237.1 63.3 L273.6 63.3 L310 63.3" fill="none" stroke="#0f6e56" stroke-width="2.5" stroke-linejoin="round" stroke-linecap="round"/>
<g fill="#0f6e56">
<circle cx="55" cy="196.7" r="2.6"/><circle cx="91.4" cy="163.3" r="2.6"/><circle cx="127.9" cy="130" r="2.6"/><circle cx="164.3" cy="103.3" r="2.6"/><circle cx="200.7" cy="76.7" r="2.6"/><circle cx="237.1" cy="63.3" r="2.6"/><circle cx="273.6" cy="63.3" r="2.6"/><circle cx="310" cy="63.3" r="2.6"/>
</g>
<g fill="none" stroke="#0f172a" stroke-width="1.5">
<path d="M51 143.3 H55"/><path d="M51 76.7 H55"/>
<path d="M91.4 210 V214"/><path d="M164.3 210 V214"/><path d="M237.1 210 V214"/><path d="M310 210 V214"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="47" y="147" text-anchor="end" fill="#0f172a">5</text>
<text x="47" y="81" text-anchor="end" fill="#0f172a">10</text>
<text x="55" y="38" text-anchor="middle" fill="#0f172a">IP</text>
<text x="91.4" y="226" text-anchor="middle" fill="#0f172a">0,03</text>
<text x="164.3" y="226" text-anchor="middle" fill="#0f172a">0,09</text>
<text x="237.1" y="226" text-anchor="middle" fill="#0f172a">0,15</text>
<text x="310" y="226" text-anchor="middle" fill="#0f172a">0,21</text>
<text x="312" y="242" text-anchor="middle" fill="#0f172a">% CO₂</text>
<text x="276" y="55" text-anchor="middle" fill="#0f6e56">palier</text>
</g>
</svg>
:::

**3. La température.** L''IP augmente jusqu''à un optimum voisin de **30 à 40 °C**, puis diminue.

> ⚠️ Ne confonds pas les deux seuils du CO₂ — et lis bien ce qu''est un palier. **0,3 %** est le plafond du gaz lui-même : au-delà, il devient toxique. Mais la courbe de la figure se couche dès **0,15 %**, bien avant ce plafond. C''est que le **palier** ne dit jamais « la plante est au maximum de ses possibilités » : il dit qu''**un autre facteur** que celui qu''on étudie limite désormais le phénomène. C''est le **facteur limitant** — ici la température ou l''éclairement de cette plante-là, qui l''ont arrêtée avant que le CO₂ n''ait donné tout ce qu''il pouvait.

## ⚠️ Engrais, pesticides et santé

Produire plus a un coût. L''emploi d''engrais chimiques et de pesticides augmente le rendement, mais présente des effets néfastes sur la santé humaine.

- **Les nitrates.** Absorbés à forte dose, ils transforment l''hémoglobine en **méthémoglobine**, incapable de fixer l''oxygène de l''air et de le céder aux tissus : difficultés respiratoires, vertiges. Comly l''établit en 1945. La maladie atteint surtout les **nourrissons** et peut être mortelle. Les seuils : une eau destinée à la consommation humaine doit être **≤ 50 mg/l** ; entre **50 et 100 mg/l** elle reste utilisable **sauf** pour les femmes enceintes et les nourrissons de moins de 6 mois ; **au-delà de 100 mg/l** elle ne doit pas être consommée.
- **Les pesticides** — insecticides, herbicides, fongicides — sont nocifs à des degrés divers. Les enfants y sont plus vulnérables que les adultes : ils en absorbent davantage par kilogramme de poids corporel et portent tout à la bouche (45 % des intoxications aiguës rapportées au centre anti-poison de Québec concernent les 0 à 15 ans). La **rémanence** est la durée pendant laquelle le produit reste actif : si on ne la respecte pas, les fraises traitées contre le champignon Botrytis gardent des résidus de fongicide et provoquent des diarrhées.

Que faire ? Quatre leviers, tous dans le programme :

- **Les engrais naturels.** Le **compostage** est une fermentation de débris animaux et végétaux qui aboutit au **compost** ; avec la **fumure organique**, il remplace les engrais chimiques. Dans le sol, l''azote organique se **minéralise** d''abord en **ammoniaque**, puis en nitrates ; or l''ammoniaque est directement utilisable par la plante — d''où **moins de nitrates** et moins de risque.
- **L''usage rationnel des engrais chimiques**, en respectant les doses et en évitant l''épandage excessif d''engrais azotés.
- **Des pesticides à courte durée d''activité**, et le respect de la rémanence.
- **La lutte biologique**, qui remplace le produit chimique par un être vivant :
  - les **prédateurs naturels** — une coccinelle adulte mange **300 pucerons par jour**, sa larve plusieurs fois par jour sa propre masse ;
  - les **phéromones**, ces substances chimiques émises par les femelles pour attirer le partenaire sexuel. La **stérilisation des mâles** les piège avec des phéromones de synthèse, les stérilise par irradiation et les relâche : comme les ravageurs ne s''accouplent généralement qu''une fois, les femelles n''ont pas de descendance. La **confusion des mâles** dissémine des diffuseurs de phéromone synthétique dans la culture : le mâle, incapable de localiser une source plutôt qu''une autre, ne retrouve plus la femelle.
  - le **désherbage manuel**, contre les mauvaises herbes.

> 🏆 Deuxième quête franchie, héros : tu sais fabriquer du sucre avec de l''air, de l''eau et du soleil, lire un palier et reconnaître un facteur limitant. La plante sait se nourrir — reste à savoir se multiplier. C''est le prochain chapitre.', '# 📜 Résumé : La nutrition carbonée

- **Les substances organiques** : glucides, protides, lipides. Tests — amidon + eau iodée → bleu foncé ; glucose + liqueur de Fehling + chauffage → précipité rouge brique ; gluten + CuSO₄ + soude → violet ; huile → tache translucide résistant à la chaleur. La feuille contient de l''amidon le soir, plus le lendemain matin : elle en fabrique, et il s''en va.
- **Les trois conditions de la photosynthèse**, démontrées en supprimant un seul facteur à la fois : la **lumière** (cache opaque), la **chlorophylle** (feuille panachée), le **dioxyde de carbone** (air barbotant dans la potasse, sac témoin à côté). La **photosynthèse** est la formation de matière organique qui nécessite de l''énergie lumineuse.
- **Le siège** : la **cellule chlorophyllienne** (paroi pectocellulosique, cytoplasme, **chloroplastes**) ; le **chloroplaste** est l''organite où se déroule la photosynthèse. La chlorophylle **capte** la lumière : les radiations les plus absorbées (**spectre d''absorption**) sont celles qui font le plus travailler la photosynthèse (**spectre d''action**).
- **L''origine des atomes**, par marquage radioactif sur des chlorelles : le **carbone** de la matière organique vient du **CO₂** ; l''**oxygène dégagé** vient de l''**eau**, jamais du CO₂. Mécanisme : la **photolyse de l''eau**, 2 H₂O → O₂ + 4 H⁺ + 4 e⁻, sous l''action de la lumière et en présence de chlorophylle.
- **Deux phases** (expérience de Gaffron, 1951 : le CO₂ continue d''être incorporé 15 à 20 s à l''obscurité, après 10 min de forte lumière) : la **phase photochimique** (à la lumière : photolyse et stockage d''énergie chimique) et la **phase sombre** (incorporation du CO₂, sans besoin direct de lumière). Équation globale : **6 CO₂ + 6 H₂O → C₆H₁₂O₆ + 6 O₂**.
- **La sève élaborée** (les produits de la photosynthèse) circule dans le **phloème** : des **tubes criblés**, files de cellules **vivantes** sans noyau ni vacuole, à **parois transversales percées de pores**. Le carmin aluné vert d''iode colore la **cellulose** en rose et la **lignine** en vert. Elle est distribuée à tous les organes, dont les organes de réserve (**amyloplastes** du tubercule).

::: figure L''anneau d''écorce enlevé bloque la sève élaborée : les substances organiques s''accumulent au-dessus, et c''est au-dessus que se forme le bourrelet de cicatrisation — elle descendait donc
<svg viewBox="0 0 340 220">
<rect x="145" y="25" width="40" height="93" fill="#0f6e56" opacity="0.10"/>
<rect x="145" y="134" width="40" height="71" fill="#0f6e56" opacity="0.10"/>
<rect x="155" y="118" width="20" height="16" fill="#94a3b8" opacity="0.30"/>
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M145 25 V118 M185 25 V118"/>
<path d="M145 134 V205 M185 134 V205"/>
<path d="M155 118 V134 M175 118 V134"/>
<path d="M145 118 H155 M175 118 H185 M145 134 H155 M175 134 H185"/>
</g>
<path d="M145 118 C 130 110, 132 94, 150 92 L180 92 C 198 94, 200 110, 185 118 Z" fill="#0f6e56" opacity="0.40" stroke="#0f172a" stroke-width="2"/>
<g fill="none" stroke="#0f6e56" stroke-width="2.5">
<path d="M152 36 V80"/><path d="M178 36 V80"/>
</g>
<g fill="#0f6e56">
<path d="M147 78 L152 88 L157 78 Z"/><path d="M173 78 L178 88 L183 78 Z"/>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M114 58 L146 60"/><path d="M198 100 L222 88"/><path d="M188 128 L214 146"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="72" y="58" text-anchor="middle" fill="#0f6e56">sève élaborée</text>
<text x="250" y="84" text-anchor="middle" fill="#0f172a">bourrelet</text>
<text x="252" y="152" text-anchor="middle" fill="#0f172a">écorce enlevée</text>
</g>
</svg>
:::

- **L''intensité photosynthétique (IP)** = quantité de CO₂ absorbé ou d''O₂ rejeté par unité de masse et de temps. La plante respirant 24 h sur 24, on mesure **IPN = IPB − IR** ; quand IPB = IR le bilan est nul : c''est le **point de compensation**. Un **palier** signale un **facteur limitant** (température, taux de CO₂). Facteurs : lumière (**plantes de soleil** épinard, pomme de terre / **plantes d''ombre** fougère), taux de CO₂ (l''augmentation cesse à 0,3 %, au-delà le CO₂ devient toxique), température (optimum voisin de 30 à 40 °C).
- **Engrais, pesticides et santé** : les **nitrates** transforment l''hémoglobine en **méthémoglobine** (eau de consommation ≤ 50 mg/l ; 50 à 100 mg/l interdite aux femmes enceintes et aux nourrissons de moins de 6 mois ; > 100 mg/l non consommable) ; les **pesticides** (insecticides, herbicides, fongicides) exigent le respect de la **rémanence**. Parades : **engrais naturels** (compost, fumure organique — minéralisation en ammoniaque puis en nitrates), usage rationnel des engrais chimiques, pesticides à courte durée d''activité, **lutte biologique** (prédateurs — 300 pucerons par jour pour une coccinelle adulte ; **phéromones** — stérilisation ou confusion des mâles ; désherbage manuel).', 2, '{"code":"225104P00","pages":"44-73","pageNumbers":[44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('c5edaf1a-f734-50f8-bea2-064b335edbcf', 'svt-1ere-sec', 'La multiplication végétative — cloner une plante performante', 'Les techniques traditionnelles de multiplication végétative : le bouturage (pomme de terre et son cycle végétatif, pélargonium et racines adventives, olivier en bouturage semi-ligneux avec formation d''un cal, et par éclat de souche), le marcottage, et le greffage (greffon, porte greffe, végétal franc, greffe en fente, greffe en écusson, raccordement des vaisseaux conducteurs, possibilités de greffage) ; l''importance et les avantages de la multiplication végétative ; la multiplication végétative par culture in vitro (microbouturage de l''olivier, conditions d''asepsie, vitro pousses, acclimatation) et la culture in vitro des cellules méristématiques ; totipotence et clone ; l''intérêt de la culture in vitro (clones sains, sauvegarde des espèces en voie de disparition, économie de temps et d''espace)', '# ⚔️ La multiplication végétative — cloner une plante performante

> 💡 «Tu as trouvé l''olivier parfait. Une graine te donnera un descendant qui ne lui ressemblera pas forcément. Un fragment de rameau, lui, te donnera exactement le même — et par milliers.»

Tu sais désormais, héros, comment la plante se nourrit d''eau, de sels minéraux et de carbone. Mais un agriculteur qui a repéré une plante **performante** — bon rendement, beau fruit, résistante aux maladies — veut la **multiplier telle quelle**. Chez le bananier, le grenadier, le figuier, la vigne, la pomme de terre ou le jasmin, la multiplication végétative est même le seul moyen d''obtenir facilement et rapidement une production importante. Voici ses techniques, de la plus vieille à la plus moderne.

## 🌿 Deux façons de faire une plante

Au collège tu as appris que les végétaux ont **deux modes de reproduction** :

- la **reproduction sexuée**, assurée par la **graine** ;
- la **reproduction asexuée**, ou **multiplication végétative**, à partir d''organes végétatifs variés : tige, rhizome, tubercule, bulbe.

Ses trois modes traditionnels sont le **bouturage**, le **marcottage** et le **greffage**. Tous partagent une propriété capitale : ils **conservent les caractères de la plante mère**.

_Exemple détaillé_ : un fragment de tubercule de pomme de terre planté en **automne** donne un pied qui produit **15 à 30 tubercules**, récoltés au **printemps**. Une **graine** de pomme de terre, elle, ne donne un plant à tubercules normaux qu''au bout de **quatre ans**. Même plante, deux chemins — et un rapport de 1 à 8 sur les délais.

## ✂️ Le bouturage

**Principe** : mis à terre, un fragment d''organe de l''appareil végétatif de certaines plantes s''enracine et développe une nouvelle plante. Ce fragment est la **bouture**.

- **Chez la pomme de terre.** Le tubercule est une portion de **tige souterraine** qui porte des **bourgeons**. Planté, il fournit un plant complet ; et **un seul bourgeon isolé** suffit à donner un plant normal producteur de tubercules normaux. Son cycle végétatif enchaîne quatre phases : **croissance** de la plante feuillée, **tubérisation**, **repos** du tubercule (plusieurs mois), puis **germination**.
- **Chez le pélargonium.** Un rameau feuillé isolé, enfoncé dans de la terre humide, développe des **racines adventives** près de la section ; la partie aérienne s''accroît, se ramifie et engendre des feuilles.
- **Chez l''olivier**, deux techniques. Le **bouturage semi-ligneux** : on prépare une bouture de **15 à 17 cm** sur un rameau âgé d''**au moins un an**, on garde **deux paires de feuilles** au sommet, on enracine à **23 à 25 °C** sous une humidité **supérieure à 80 %** ; un **cal** se développe au bout de quelques semaines, les racines apparaissent vers **8 semaines**. Le **bouturage par éclat de souche** : la protubérance de la base du tronc est fragmentée en tronçons de **15 à 20 cm** pesant de **500 g à 5 kg**, les **éclats de souche** ou **souchets** ; enterré et irrigué, le souchet s''enracine et donne une plante identique à la plante mère.

## 🪢 Le marcottage

**Principe** : on enterre à quelques centimètres, ou dans un pot, une tige aérienne — **sans la détacher de la plante**. Quelques semaines plus tard, des **racines adventives** se sont formées. On isole alors la tige enracinée : on obtient une nouvelle plante identique à la plante mère.

::: figure La bouture est un fragment détaché qui s''enracine tout seul ; la marcotte, elle, reste attachée à la plante mère pendant qu''elle s''enracine — on ne la sépare qu''après
<svg viewBox="0 0 340 200">
<rect x="10" y="140" width="320" height="45" fill="#a16207" opacity="0.20"/>
<path d="M10 140 H330" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M70 138 V60" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<g fill="#0f6e56" opacity="0.6" stroke="#0f172a" stroke-width="1.2">
<ellipse cx="55" cy="78" rx="14" ry="7" transform="rotate(-25 55 78)"/>
<ellipse cx="86" cy="66" rx="14" ry="7" transform="rotate(20 86 66)"/>
</g>
<g fill="none" stroke="#0f172a" stroke-width="1.8" stroke-linecap="round">
<path d="M70 142 L58 166"/><path d="M70 142 V172"/><path d="M70 142 L83 166"/>
</g>
<path d="M215 140 V52" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<g fill="#0f6e56" opacity="0.6" stroke="#0f172a" stroke-width="1.2">
<ellipse cx="199" cy="72" rx="14" ry="7" transform="rotate(-25 199 72)"/>
<ellipse cx="231" cy="60" rx="14" ry="7" transform="rotate(20 231 60)"/>
<ellipse cx="309" cy="106" rx="13" ry="7" transform="rotate(25 309 106)"/>
</g>
<path d="M215 105 C 250 95, 276 116, 286 142" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<path d="M286 145 L302 116" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
<g fill="none" stroke="#0f172a" stroke-width="1.8" stroke-linecap="round">
<path d="M286 145 L275 168"/><path d="M286 145 V174"/><path d="M286 145 L298 168"/>
</g>
<g font-size="12" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="70" y="194" text-anchor="middle" fill="#0f6e56">bouture</text>
<text x="200" y="194" text-anchor="middle" fill="#0f172a">plante mère</text>
<text x="292" y="194" text-anchor="middle" fill="#0f6e56">marcotte</text>
</g>
</svg>
:::

> ⚠️ Piège classique : bouture et marcotte se ressemblent une fois enracinées. La différence tient à **un seul détail de chronologie** — la bouture est **détachée d''abord**, la marcotte **détachée après**. Le marcottage laisse donc la plante mère nourrir la tige tant qu''elle n''a pas ses racines.

## 🔗 Le greffage

Le **greffage** met en jeu deux plantes. Le **greffon** est un fragment de tige — un bourgeon ou un jeune rameau — prélevé sur un végétal **sélectionné pour la qualité de ses fruits ou de ses fleurs**. Le **porte greffe** est la plante sur laquelle on le fixe. Tous deux appartiennent à la **même espèce ou à des espèces voisines**.

**Principe** : le greffon est fixé sur le porte greffe de telle sorte que **les vaisseaux conducteurs des deux se raccordent**. Sans ce raccordement, la sève ne passe pas et la greffe échoue.

::: figure Le greffon, taillé en biseau, est glissé dans la fente du porte greffe puis ligaturé et masticé — tout l''enjeu est que les vaisseaux conducteurs des deux se raccordent
<svg viewBox="0 0 340 230">
<rect x="10" y="195" width="320" height="32" fill="#a16207" opacity="0.20"/>
<path d="M10 195 H330" fill="none" stroke="#0f172a" stroke-width="2"/>
<rect x="145" y="110" width="44" height="85" fill="#a16207" opacity="0.35" stroke="#0f172a" stroke-width="2.5"/>
<path d="M167 110 V142" fill="none" stroke="#0f172a" stroke-width="2"/>
<g fill="none" stroke="#0f172a" stroke-width="1.8" stroke-linecap="round">
<path d="M167 197 L148 220"/><path d="M167 197 V224"/><path d="M167 197 L186 220"/>
</g>
<path d="M167 120 V45" fill="none" stroke="#0f6e56" stroke-width="3"/>
<g fill="#0f6e56" opacity="0.6" stroke="#0f172a" stroke-width="1.2">
<ellipse cx="151" cy="62" rx="14" ry="7" transform="rotate(-25 151 62)"/>
<ellipse cx="184" cy="50" rx="14" ry="7" transform="rotate(20 184 50)"/>
</g>
<rect x="141" y="108" width="52" height="20" fill="none" stroke="#0f172a" stroke-width="1.5"/>
<g stroke="#0f172a" stroke-width="1.2">
<path d="M147 128 L157 108 M159 128 L169 108 M171 128 L181 108 M183 128 L193 108"/>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M172 70 L214 66"/><path d="M191 165 L216 168"/><path d="M139 118 L112 118"/>
</g>
<g font-size="12" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="243" y="70" text-anchor="middle" fill="#0f6e56">greffon</text>
<text x="256" y="172" text-anchor="middle" fill="#0f172a">porte greffe</text>
<text x="80" y="122" text-anchor="middle" fill="#0f172a">ligature</text>
</g>
</svg>
:::

Deux modalités sont au programme.

| Modalité              | Le greffon                                                                                                    | Le porte greffe                                                                                     | La finition                                    |
| --------------------- | ------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| **Greffe en fente**   | un **rameau taillé en biseau**                                                                                | **au moins 3 cm** de diamètre, **rabattu 10 à 20 cm** au-dessus du sol, **fendu** longitudinalement | ligature + **mastic** ; écorces au même niveau |
| **Greffe en écusson** | un **bourgeon** accompagné d''une bande d''écorce, prélevé sur un rameau d''un arbre âgé d''**au moins deux ans** | écorce **incisée en T**, greffon inséré entre les deux lèvres, en contact avec le bois              | ligature                                       |

**Le résultat**, et c''est tout l''intérêt : le porte greffe conserve son **appareil absorbant** complet (les racines) et une partie du tronc ; le greffon développe un **appareil assimilateur et de fructification** (rameaux, tige, feuilles, fruits) **à l''exclusion de toute racine**. La nouvelle plante porte les **caractères de la plante qui a fourni le greffon**.

Un **végétal franc** est un végétal provenant des semis. C''est souvent lui qu''on utilise comme porte greffe :

| Modalité          | Greffon    | Porte greffe                     | Période |
| ----------------- | ---------- | -------------------------------- | ------- |
| Greffe en fente   | pommier    | pommier franc                    | hiver   |
| Greffe en fente   | poirier    | poirier franc, cognassier        | —       |
| Greffe en écusson | abricotier | abricotier franc, amandier franc | mai     |
| Greffe en écusson | pêcher     | pêcher franc, amandier franc     | juin    |

> 🗡️ Retiens la répartition des rôles : **les racines viennent du porte greffe, les fruits viennent du greffon**. C''est pour cela qu''on peut greffer un abricotier sur un **amandier** franc — l''amandier fournit les racines, l''abricotier les abricots.

## 🧫 La culture in vitro

Les techniques traditionnelles multiplient vite, mais le **nombre** de plantes obtenues reste faible. La **culture in vitro** change d''échelle.

**Le microbouturage.** On prélève sur une plante performante une **microbouture** renfermant un **bourgeon**. Ce bourgeon renferme des cellules embryonnaires, les **cellules totipotentes**, capables de se développer pour donner **n''importe quelle partie** de la plante : tige, racine, feuille. La technique exige des conditions d''**asepsie**. Chez l''olivier, elle suit neuf étapes :

1. **fragmentation** d''un rameau prélevé sur une plante, en microboutures ;
2. **mise en culture** sur un milieu nutritif, en conditions stériles ;
3. développement des **vitro pousses** — trois mois en moyenne ;
4. **fragmentation** d''une vitro pousse, en conditions stériles ;
5. **remise** sur milieu nutritif ;
6. **développement** ;
7. **enracinement** ;
8. **mise en pot** pour la phase d''**acclimatation** ;
9. **plantation** dans un champ.

Les étapes 4, 5 et 6 se **répètent plusieurs fois** — et c''est là que tout se joue. En un an, on obtient **400 000 oliviers** identiques à la plante d''origine, là où le bouturage traditionnel n''en donnerait dans le même temps qu''**une vingtaine**.

**La culture des cellules méristématiques.** À l''extrémité d''un **bourgeon terminal** se trouvent des **cellules méristématiques**, celles qui permettent la croissance et l''édification des organes du végétal. Isolées et cultivées in vitro sur un milieu convenable, elles forment un massif cellulaire qu''on fragmente ; quelques mois plus tard, on dispose d''un très grand nombre de plantes performantes toutes identiques.

::: figure Tout en haut du bourgeon, sous les jeunes feuilles, une poignée de cellules seulement : ce sont elles qui édifient tous les organes — et elles seules qu''on prélève pour la culture in vitro
<svg viewBox="0 0 340 220">
<rect x="155" y="94" width="30" height="112" fill="#0f6e56" opacity="0.12" stroke="#0f172a" stroke-width="2"/>
<g fill="#0f6e56" opacity="0.30" stroke="#0f172a" stroke-width="1.8" stroke-linejoin="round">
<path d="M156 116 C 130 112, 112 142, 122 176 C 138 152, 152 138, 158 122 Z"/>
<path d="M184 116 C 210 112, 228 142, 218 176 C 202 152, 188 138, 182 122 Z"/>
<path d="M158 104 C 138 98, 128 122, 134 148 C 146 130, 155 118, 160 108 Z"/>
<path d="M182 104 C 202 98, 212 122, 206 148 C 194 130, 185 118, 180 108 Z"/>
</g>
<path d="M155 96 A 15 15 0 0 1 185 96 Z" fill="#0f6e56" opacity="0.85" stroke="#0f172a" stroke-width="1.8"/>
<g fill="#ffffff" opacity="0.9">
<circle cx="163" cy="90" r="2.6"/><circle cx="170" cy="86" r="2.6"/><circle cx="177" cy="90" r="2.6"/><circle cx="166" cy="94" r="2.6"/><circle cx="174" cy="94" r="2.6"/>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M183 88 L216 58"/><path d="M120 172 L98 178"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="250" y="52" text-anchor="middle" fill="#0f6e56">cellules méristématiques</text>
<text x="62" y="182" text-anchor="middle" fill="#0f172a">jeune feuille</text>
</g>
</svg>
:::

## 🏆 Pourquoi multiplier ainsi ?

Toutes les plantes issues de la multiplication végétative d''une même plante mère forment un **clone** : un ensemble d''individus possédant les mêmes caractères et provenant de la multiplication végétative d''un individu unique. Ce qui rend le clonage possible, c''est la **totipotence** des cellules des végétaux chlorophylliens : leur capacité à se développer et à donner **n''importe quel organe** de la plante à partir d''une seule cellule.

Les avantages, traditionnels d''abord :

- **conserver les caractères** appréciés du consommateur : rendement élevé, qualité alimentaire, industrielle ou ornementale, résistance aux maladies ;
- **gagner du temps** : quelques mois au lieu de quatre ans chez la pomme de terre.

Puis ceux, décisifs, de la culture in vitro :

- **des clones sains** : les maladies à virus ravagent les cultures de pomme de terre ; la culture des méristèmes a permis de reconstituer des clones indemnes ;
- **la sauvegarde d''espèces en voie de disparition**, parce qu''elles se reproduisent difficilement — pommier ancien, rosier ancien ;
- **une économie d''espace et de temps** : un local de culture in vitro climatisé de **9 m²** remplace **25 500 m²** de serres chauffées ou refroidies selon la saison. Un grand producteur d''œillets obtient en **deux ans** ce qu''il produisait en **quatre ans** par la culture traditionnelle — deux ans de chauffage de plusieurs hectares de serres économisés.

> ⚠️ Un clone n''est pas « une plante meilleure » : c''est **la même** plante, en très grand nombre. Il n''améliore rien par lui-même — il **conserve** et **multiplie** ce que la plante mère avait déjà. C''est le choix de la plante mère qui décide de tout.

> 🏆 Troisième quête franchie, héros : tu sais faire une plante à partir d''un fragment, marier deux végétaux et en cloner 400 000 en un an. La partie « production végétale » est bouclée. Une autre t''attend, invisible à l''œil nu : le monde microbien.', '# 📜 Résumé : La multiplication végétative

- **Deux modes de reproduction** : la **reproduction sexuée**, assurée par la graine, et la **reproduction asexuée** ou **multiplication végétative**, à partir d''organes végétatifs (tige, rhizome, tubercule, bulbe). Ses trois modes traditionnels — bouturage, marcottage, greffage — **conservent les caractères de la plante mère**. Repère : un fragment de tubercule planté en automne donne 15 à 30 tubercules au printemps ; une graine met **quatre ans** à donner un plant à tubercules normaux.
- **Bouturage** : un fragment d''organe végétatif mis à terre s''enracine et développe une nouvelle plante ; ce fragment est la **bouture**, qui émet des **racines adventives**. Chez l''olivier : **bouturage semi-ligneux** (bouture de 15 à 17 cm sur un rameau d''au moins un an, deux paires de feuilles, 23 à 25 °C, humidité > 80 % ; **cal** après quelques semaines, racines vers 8 semaines) et **éclat de souche** ou **souchet** (tronçon de 15 à 20 cm, de 500 g à 5 kg). Cycle végétatif de la pomme de terre : croissance, tubérisation, repos, germination.
- **Marcottage** : on enterre une tige aérienne **sans la détacher** de la plante ; elle forme des racines adventives, et on l''isole **ensuite**. C''est la seule différence avec le bouturage — mais elle est décisive : la plante mère nourrit la marcotte jusqu''à son enracinement.
- **Greffage** : le **greffon** (bourgeon ou jeune rameau prélevé sur un végétal sélectionné pour ses fruits ou ses fleurs) est fixé sur un **porte greffe** (même espèce ou espèce voisine) de façon que les **vaisseaux conducteurs se raccordent**. **Greffe en fente** (porte greffe ≥ 3 cm de diamètre, rabattu 10 à 20 cm au-dessus du sol, greffon taillé en biseau, ligature + mastic) ; **greffe en écusson** (bourgeon + bande d''écorce d''un arbre d''au moins deux ans, incision en T, ligature). **Résultat** : racines et partie du tronc au porte greffe, rameaux-feuilles-fruits au greffon, **sans aucune racine** — la nouvelle plante porte les caractères du **greffon**. Un **végétal franc** provient des semis.
- **Culture in vitro** : multiplication des cellules d''un tissu végétal sur un milieu nutritif adapté, en **asepsie**, pour obtenir des plantes identiques au végétal de départ. Par **microbouturage** (microbouture portant un bourgeon → **vitro pousses** en trois mois → fragmentations répétées → enracinement → **acclimatation** en pot → plantation) : **400 000 oliviers en un an**, contre une vingtaine par bouturage traditionnel. Par **cellules méristématiques**, prélevées à l''extrémité d''un bourgeon terminal.

::: figure Un seul bourgeon, quelques cycles de fragmentation, et l''on obtient 200 000 à 400 000 rosiers rigoureusement identiques : c''est le clone
<svg viewBox="0 0 340 155">
<path d="M45 58 C 30 68, 32 88, 45 92 C 58 88, 60 68, 45 58 Z" fill="#0f6e56" opacity="0.55" stroke="#0f172a" stroke-width="1.8"/>
<path d="M72 75 H104" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M102 69 L112 75 L102 81 Z" fill="#0f172a"/>
<path d="M132 78 V86 A 14 14 0 0 0 160 86 V78 Z" fill="#0f6e56" opacity="0.20"/>
<path d="M132 42 V86 A 14 14 0 0 0 160 86 V42" fill="none" stroke="#0f172a" stroke-width="2.2"/>
<path d="M146 82 V56" fill="none" stroke="#0f6e56" stroke-width="2.2"/>
<ellipse cx="154" cy="60" rx="8" ry="4" transform="rotate(20 154 60)" fill="#0f6e56" opacity="0.6" stroke="#0f172a" stroke-width="1"/>
<path d="M130 32 A 16 16 0 1 1 160 26" fill="none" stroke="#0f6e56" stroke-width="2"/>
<path d="M153 21 L164 24 L157 33 Z" fill="#0f6e56"/>
<path d="M176 75 H208" fill="none" stroke="#0f172a" stroke-width="2"/>
<path d="M206 69 L216 75 L206 81 Z" fill="#0f172a"/>
<g fill="none" stroke="#0f6e56" stroke-width="2.2">
<path d="M250 98 V62"/><path d="M275 98 V58"/><path d="M300 98 V62"/>
</g>
<g fill="#0f6e56" opacity="0.6" stroke="#0f172a" stroke-width="1">
<ellipse cx="242" cy="70" rx="8" ry="4" transform="rotate(-25 242 70)"/>
<ellipse cx="258" cy="66" rx="8" ry="4" transform="rotate(25 258 66)"/>
<ellipse cx="267" cy="66" rx="8" ry="4" transform="rotate(-25 267 66)"/>
<ellipse cx="283" cy="62" rx="8" ry="4" transform="rotate(25 283 62)"/>
<ellipse cx="292" cy="70" rx="8" ry="4" transform="rotate(-25 292 70)"/>
<ellipse cx="308" cy="66" rx="8" ry="4" transform="rotate(25 308 66)"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="145" y="14" text-anchor="middle" fill="#0f6e56">×N</text>
<text x="45" y="125" text-anchor="middle" fill="#0f172a">1 bourgeon</text>
<text x="146" y="125" text-anchor="middle" fill="#0f172a">milieu nutritif</text>
<text x="275" y="125" text-anchor="middle" fill="#0f6e56">200 000 à 400 000</text>
</g>
</svg>
:::

- **Clone et totipotence** : toutes les plantes issues de la multiplication végétative d''une même plante mère forment un **clone**. Ce qui le rend possible est la **totipotence** — la capacité d''une seule cellule à donner n''importe quel organe de la plante. Avantages : conserver les caractères recherchés (rendement, qualité, résistance aux maladies), gagner du temps, obtenir des **clones sains** (assainissement viral par culture de méristèmes), **sauver des espèces en voie de disparition** (pommier ancien, rosier ancien) et **économiser espace et temps** (un local de 9 m² remplace 25 500 m² de serres ; deux ans in vitro valent quatre ans de culture traditionnelle chez l''œillet).', 3, '{"code":"225104P00","pages":"74-88","pageNumbers":[74,75,76,77,78,79,80,81,82,83,84,85,86,87,88]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('d0a86148-bdad-5274-8564-f6d944ce6b13', 'svt-1ere-sec', 'La diversité du monde microbien — quatre groupes sous l''objectif', 'Les quatre groupes de micro-organismes et leurs caractéristiques : les protozoaires (paramécie, amibe dysentérique, pseudopode, enkystement) ; les bactéries (bacille subtil, bactéries lactiques, diplocoques, streptocoques et staphylocoques, Eschérishia Coli, structure procaryote, bipartition toutes les 20 mn, minéralisation par les bactéries du sol) ; les champignons microscopiques (levure de bière et bourgeonnement, moisissure de pain, Pénicillium notatum et pénicilline, trichophyton et teigne, Phytophtora et mildiou) ; les virus (capsule et matériel génétique, absence d''organisation cellulaire, cellule hôte, parasite intracellulaire obligatoire, ordres de grandeur en nm et en angström) ; procaryote et eucaryote ; microbes utiles et microbes pathogènes avec le tableau microbe-maladie ; les techniques d''observation microscopique (montage entre lame et lamelle, frottis coloré, grossissement, taille réelle, microscope optique et microscope électronique)', '# ⚔️ La diversité du monde microbien — quatre groupes sous l''objectif

> 💡 «Ils sont dans l''eau, dans l''air, dans le sol, sur ta peau et dans ton intestin. Certains font ton yaourt, d''autres te tuent. Apprends d''abord à les distinguer — le reste en découle.»

Nouvelle partie, héros : **microbes et santé**. Le monde microbien est constitué d''organismes qu''on ne peut observer qu''au microscope — des **micro-organismes**. Il se caractérise par une **grande diversité** : ils diffèrent par leur taille, leur forme et leur mode d''action sur l''organisme. Tu sais déjà qu''ils sont microscopiques, que certains sont pathogènes et d''autres utiles. Ce chapitre pose la carte du territoire : **quatre groupes**, et ce qui distingue chacun.

## 🐛 Les protozoaires

Un **protozoaire** est un **animal unicellulaire**. Comme toute cellule animale, il possède un **noyau entouré d''une membrane**.

- **La paramécie.** Mets de l''eau et du foin dans un cristallisoir, place-le à l''abri du soleil à 25 à 30 °C : une semaine plus tard, une goutte du liquide observée au faible grossissement (G = × 200) grouille de paramécies. La paramécie est un animal unicellulaire des **eaux stagnantes** ; c''est un micro-organisme **inoffensif**. Elle porte des **cils vibratiles**, une **bouche**, une **vacuole digestive**, une **vacuole pulsatile**, un **noyau** et un **cytoplasme**.
- **L''amibe dysentérique.** Son cytoplasme forme des prolongements, les **pseudopodes**, qui assurent le **déplacement** et la **nutrition**. Lorsque les conditions sont défavorables, elle **s''enkyste**. Ses **kystes** peuvent être ingérés par l''homme avec l''eau ou les aliments **souillés** ; ils se transforment dans le tube digestif en amibes, qui se multiplient dans le gros intestin et causent la **dysentérie amibienne** (diarrhées, vomissements).

> 🗡️ Deux protozoaires, deux destins : la paramécie est inoffensive, l''amibe dysentérique est **pathogène** — c''est-à-dire qu''elle cause une maladie. Appartenir à un groupe ne dit donc rien de la dangerosité.

## 🧫 Les bactéries

Une **bactérie** est un être vivant **unicellulaire** microscopique, qui se multiplie par **bipartition**, et dont le **matériel génétique n''est pas délimité par une membrane** : c''est un organisme **procaryote**.

::: figure Le matériel génétique baigne directement dans le cytoplasme : aucune membrane ne l''entoure — c''est exactement ce qui fait de la bactérie une cellule procaryote
<svg viewBox="0 0 340 200">
<path d="M80 70 H260 A 35 35 0 0 1 260 140 H80 A 35 35 0 0 1 80 70 Z" fill="#0f6e56" opacity="0.10"/>
<path d="M80 70 H260 A 35 35 0 0 1 260 140 H80 A 35 35 0 0 1 80 70 Z" fill="none" stroke="#0f172a" stroke-width="3"/>
<path d="M86 76 H254 A 29 29 0 0 1 254 134 H86 A 29 29 0 0 1 86 76 Z" fill="none" stroke="#0f6e56" stroke-width="2"/>
<path d="M140 118 C 120 108, 135 88, 160 92 C 185 96, 200 84, 215 96 C 228 106, 210 122, 185 116 C 165 111, 155 126, 140 118 Z" fill="#7c3aed" opacity="0.45" stroke="#0f172a" stroke-width="1.8"/>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M82 92 L58 70"/><path d="M160 76 L172 40"/><path d="M250 104 L272 102"/><path d="M170 116 L170 166"/>
</g>
<g font-size="10" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="48" y="62" text-anchor="middle" fill="#0f172a">paroi</text>
<text x="176" y="32" text-anchor="middle" fill="#0f6e56">membrane cytoplasmique</text>
<text x="300" y="106" text-anchor="middle" fill="#0f172a">cytoplasme</text>
<text x="170" y="180" text-anchor="middle" fill="#0f172a">matériel génétique</text>
</g>
</svg>
:::

**Les formes.** Le **bacille** est une bactérie en forme de **bâtonnet** ; les **coques** sont des bactéries en forme de **granules**, isolées ou associées ; d''autres bactéries sont **spiralées**.

_Exemple détaillé_ : fais bouillir de l''eau et du foin, filtre, attends 48 heures — un **voile** se forme à la surface du filtrat. Observé au microscope (× 900), il révèle le **bacille subtil**, une bactérie en bâtonnet. Autre exemple : dépose une goutte du liquide qui surnage un yaourt sur une lame, étale, sèche à l''air libre, fixe à l''**alcool**, colore au **bleu de méthylène** pendant 10 minutes, rince et sèche : ce **frottis** observé à × 1000 montre les **bactéries lactiques**, de deux types — les **lactobacilles** en bâtonnets et les **streptocoques** en grains arrondis groupés en chaînettes. Ce sont elles qui transforment le lait en yaourt.

Les coques, elles, se classent sur un critère qui n''est pas leur forme individuelle :

::: figure Le critère de classement des coques n''est pas leur forme — elles sont toutes rondes — mais leur groupement : par deux, en chaîne ou en grappe
<svg viewBox="0 0 340 180">
<g fill="#0f6e56" opacity="0.55" stroke="#0f172a" stroke-width="1.8">
<circle cx="48" cy="80" r="12"/><circle cx="72" cy="80" r="12"/>
<circle cx="130" cy="80" r="11"/><circle cx="150" cy="78" r="11"/><circle cx="170" cy="80" r="11"/><circle cx="190" cy="78" r="11"/><circle cx="210" cy="80" r="11"/>
<circle cx="265" cy="68" r="10"/><circle cx="285" cy="63" r="10"/><circle cx="303" cy="72" r="10"/><circle cx="272" cy="86" r="10"/><circle cx="292" cy="86" r="10"/><circle cx="308" cy="90" r="10"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="60" y="130" text-anchor="middle" fill="#0f172a">diplocoque</text>
<text x="170" y="130" text-anchor="middle" fill="#0f172a">streptocoque</text>
<text x="285" y="130" text-anchor="middle" fill="#0f172a">staphylocoque</text>
<text x="60" y="152" text-anchor="middle" fill="#0f6e56">2 coques</text>
<text x="170" y="152" text-anchor="middle" fill="#0f6e56">1 chaîne</text>
<text x="285" y="152" text-anchor="middle" fill="#0f6e56">une grappe</text>
</g>
</svg>
:::

| Groupement                     | Ce qu''ils provoquent                                                                                                                           |
| ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **Diplocoque** (2 coques)      | **méningocoques** → méningite ; **pneumocoques** → pneumonie                                                                                   |
| **Streptocoque** (une chaîne)  | abcès ; broncho-pneumonie ; angine, dont la complication en l''absence de traitement est le rhumatisme articulaire aigu et l''atteinte cardiaque |
| **Staphylocoque** (une grappe) | abondants partout — peau, nez, gorge, intestin ; infectent l''organisme à la faveur d''une plaie → furoncle ou abcès                             |

**La multiplication.** Placée dans des conditions favorables, **Eschérishia Coli** — un bacille qui vit normalement dans l''intestin de l''homme et fait partie de la **flore intestinale** — s''allonge et se divise en deux : c''est la **bipartition**. **Deux bactéries se forment à partir d''une bactérie initiale toutes les 20 minutes.** Les bactéries ont donc une grande capacité de multiplication dès que le milieu est favorable.

**Et les utiles ?** Les **bactéries du sol** décomposent la matière organique des cadavres et des déchets animaux et végétaux, et les transforment en **sels minéraux** et en dioxyde de carbone : c''est la **minéralisation**, qui restitue au sol les sels minéraux puisés par les plantes. Tu reconnais la fertilisation organique du chapitre 1 — voici les ouvriers.

## 🍄 Les champignons microscopiques

Les **champignons** sont des organismes **eucaryotes** apparentés aux végétaux, mais s''en distinguant par leur **mode de nutrition** : ce sont des êtres **hétérotrophes**, qui se nourrissent d''eau, de sels minéraux et de **substances carbonées** — le bilan les décrit comme des végétaux microscopiques **non chlorophylliens**. Une **moisissure** est un champignon microscopique. On les classe en deux catégories.

| Catégorie                     | Exemples et signes                                                                                                                                  |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Unicellulaires**            | la **levure de bière** : cellules sphériques ou ovoïdes de **6 à 10 μm**, qui se multiplient par **bourgeonnement** ; elle sert à fabriquer le pain |
| **Filamenteux** (moisissures) | la **moisissure de pain** (**mycélium** + **sporanges**, ces boîtes à spores) ; le **Pénicille** ; le **trichophyton** ; le **Phytophtora**         |

_Exemple détaillé_ : dilue 1 gramme de levure du commerce dans 10 ml d''une solution de saccharose à 10 % à 37 °C, laisse reposer quelques heures, observe à × 1500 : tu vois des cellules **en bourgeonnement**. Autre exemple : place un morceau de pain humide dans un cristallisoir couvert, à 25 à 30 °C ; au bout de **deux jours**, le pain se recouvre d''un **duvet blanc** — la moisissure, observable à × 400.

Trois champignons à connaître par leur effet :

- **Pénicillium notatum** — une moisissure **verte** à partir de laquelle est fabriquée la **pénicilline**, un **antibiotique**. Utile.
- **Le trichophyton** — un champignon filamenteux qui infecte la **peau** et les **cheveux** ; il est l''agent de la **teigne**, caractérisée par une chute des cheveux. **Parasite.**
- **Le Phytophtora** — un champignon filamenteux, agent du **mildiou**, maladie qui attaque la tomate, la pomme de terre et la vigne. **Parasite.**

## ☣️ Les virus

Un **virus** est une **particule organisée incapable de se développer en dehors d''une cellule vivante**. C''est une particule **très petite**, observable seulement au **microscope électronique**, dont la taille va de quelques **angströms** (1 A° = 10⁻¹⁰ m) à quelques **micromètres** (1 μm = 10⁻⁶ m).

::: figure Une capsule, du matériel génétique, et rien d''autre : ni cytoplasme, ni membrane cytoplasmique, ni noyau — le virus n''a pas l''organisation d''une cellule
<svg viewBox="0 0 340 200">
<circle cx="150" cy="100" r="55" fill="#0f6e56" opacity="0.10"/>
<circle cx="150" cy="100" r="55" fill="none" stroke="#0f172a" stroke-width="3"/>
<path d="M124 118 C 110 100, 128 80, 150 88 C 170 95, 182 112, 162 120 C 146 126, 136 130, 124 118 Z" fill="#7c3aed" opacity="0.45" stroke="#0f172a" stroke-width="1.8"/>
<g fill="none" stroke="#94a3b8" stroke-width="1.2">
<path d="M189 68 L240 54"/><path d="M148 116 L162 172"/>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="273" y="50" text-anchor="middle" fill="#0f172a">capsule</text>
<text x="176" y="186" text-anchor="middle" fill="#0f172a">matériel génétique</text>
</g>
</svg>
:::

Le virus est **inerte** dans le milieu extérieur : **il ne respire pas et ne se reproduit pas**. Il ne peut se multiplier qu''à l''intérieur d''une cellule vivante, appelée **cellule hôte** — animale, végétale ou bactérienne. D''où son nom : **parasite intracellulaire obligatoire**.

| Virus                   | Taille | Ce qu''il fait                                                                                                                      |
| ----------------------- | -----: | ---------------------------------------------------------------------------------------------------------------------------------- |
| **V.I.H.**              | 100 nm | virus du S.I.D.A. ; se transmet par le sperme, les sécrétions vaginales et le sang ; s''attaque aux cellules du système immunitaire |
| **Virus de la grippe**  | 150 nm | responsable des inflammations respiratoires                                                                                        |
| **Bactériophages**      | 200 nm | des virus qui infectent les **bactéries**                                                                                          |
| **Virus de la variole** | 240 nm | provoque une infection de la peau avec formation de pustules                                                                       |

> ⚠️ Piège classique : « le virus est le plus petit des microbes, donc c''est une toute petite cellule ». Non — ce n''est **pas** une cellule du tout. Compare les deux figures : la bactérie a une paroi, une membrane, un cytoplasme et son matériel génétique ; le virus n''a **qu''**une capsule et du matériel génétique. Un virus est un **assemblage de molécules**, pas un être unicellulaire.

## ⚖️ Utiles ou pathogènes ?

Est **pathogène** un microbe qui **cause une maladie**. Mais une autre catégorie de microbes nous sert.

**Les utiles.** La capacité de **fermentation** de différentes espèces bactériennes est utilisée pour produire fromages, yaourts et vinaigres ; d''autres bactéries servent à produire fibres textiles, enzymes, polysaccharides, détergents, médicaments, antibiotiques, vaccins et hormones. Côté champignons : le **Pénicille** est cultivé pour produire la **pénicilline** ; la **levure de bière** sert à fabriquer le pain, le vin, la bière et le cidre ; des **moisissures** entrent dans la fabrication de quelques types de fromage.

**Les pathogènes.** Chaque groupe a les siens :

| Groupe           | Microbe                  | Maladie                                       |
| ---------------- | ------------------------ | --------------------------------------------- |
| **Protozoaires** | hématozoaire             | paludisme                                     |
|                  | amibe dysentérique       | amibiase                                      |
|                  | trypanosome              | maladie du sommeil                            |
| **Bactéries**    | bacille de Koch          | tuberculose                                   |
|                  | vibrion du choléra       | choléra                                       |
|                  | bacille diphtérique      | diphtérie                                     |
|                  | bacille tétanique        | tétanos                                       |
|                  | streptocoque             | infection d''une plaie, rhumatisme articulaire |
|                  | staphylocoque            | infection d''une plaie                         |
|                  | tréponème                | syphilis                                      |
| **Moisissures**  | trichophyton             | teigne                                        |
|                  | candida albicans         | candidose                                     |
| **Virus**        | virus de la rougeole     | rougeole                                      |
|                  | virus de la rage         | rage                                          |
|                  | virus de la variole      | variole                                       |
|                  | virus de la poliomyélite | poliomyélite                                  |
|                  | virus de la grippe       | grippe                                        |
|                  | V.I.H.                   | S.I.D.A.                                      |

## 🔍 Voir l''invisible : les techniques

Rien de ce qui précède n''existerait sans l''instrument. Retiens les gestes et les deux calculs.

- **Le montage entre lame et lamelle** : une goutte du liquide, une lamelle, puis l''observation au faible, au moyen, puis au fort grossissement.
- **Le frottis coloré** : étaler, sécher à l''air libre, **fixer** à l''alcool, **colorer** (bleu de méthylène), rincer, sécher.
- **Le grossissement du microscope** est le produit de celui de l''oculaire par celui de l''objectif :

$$ grossissement = oculaire × objectif $$

_Exemple détaillé_ : un oculaire × 15 et un objectif × 40 donnent un grossissement de 15 × 40 = **600** ✓.

- **La taille réelle** se déduit de la taille mesurée sur l''image et du grossissement :

$$ taille réelle = taille mesurée ÷ grossissement $$

- **Le microscope électronique** prend le relais quand l''objet est trop petit pour le microscope optique : c''est lui qui révèle la structure de E. Coli (au MEB, × 27 000) et celle des virus. Repère utile : **1 μm = 1 millième de mm**.

> 🏆 Quatrième quête franchie, héros : tu sais nommer les quatre groupes, reconnaître un procaryote, distinguer un virus d''une cellule et calculer un grossissement. Tu tiens la carte. Reste à savoir ce que ces microbes font vraiment à un organisme — c''est le prochain chapitre.', '# 📜 Résumé : La diversité du monde microbien

- **Quatre groupes.** Les **micro-organismes** ne s''observent qu''au microscope et diffèrent par leur taille, leur forme et leur mode d''action : on les classe en **protozoaires**, **bactéries**, **champignons microscopiques** et **virus**.
- **Protozoaires** = **animaux unicellulaires**, à noyau entouré d''une membrane. La **paramécie** (eaux stagnantes, cils vibratiles, vacuole pulsatile, vacuole digestive, bouche) est **inoffensive** ; l''**amibe dysentérique** se déplace et se nourrit par ses **pseudopodes**, **s''enkyste** en conditions défavorables, et ses kystes ingérés avec de l''eau ou des aliments souillés causent la **dysentérie amibienne**.
- **Bactéries** = êtres unicellulaires **procaryotes** : le **matériel génétique baigne dans le cytoplasme, sans membrane pour l''entourer** (paroi + membrane cytoplasmique + cytoplasme + matériel génétique). Formes : **bacille** (bâtonnet), **coques** (granules), **spiralées**. Les coques se classent sur leur **groupement** : **diplocoque** (2 coques : méningocoque, pneumocoque), **streptocoque** (une chaîne), **staphylocoque** (une grappe). Multiplication par **bipartition** — 2 bactéries à partir d''une seule **toutes les 20 mn**. Les **bactéries du sol** assurent la **minéralisation**.

::: figure Chaque bactérie se divise en deux toutes les 20 minutes : au bout d''une heure il y a eu 3 divisions, et une seule bactérie en est devenue 2³ = 8
<svg viewBox="0 0 340 190">
<g fill="none" stroke="#0f172a" stroke-width="2">
<path d="M62 80 H106"/><path d="M144 80 H190"/><path d="M226 80 H275"/>
</g>
<g fill="#0f172a">
<path d="M104 74 L114 80 L104 86 Z"/><path d="M188 74 L198 80 L188 86 Z"/><path d="M273 74 L283 80 L273 86 Z"/>
</g>
<g fill="#0f6e56" opacity="0.55" stroke="#0f172a" stroke-width="1.6">
<circle cx="50" cy="80" r="7"/>
<circle cx="130" cy="66" r="7"/><circle cx="130" cy="94" r="7"/>
<circle cx="210" cy="44" r="7"/><circle cx="210" cy="68" r="7"/><circle cx="210" cy="92" r="7"/><circle cx="210" cy="116" r="7"/>
<circle cx="300" cy="24" r="6"/><circle cx="300" cy="40" r="6"/><circle cx="300" cy="56" r="6"/><circle cx="300" cy="72" r="6"/><circle cx="300" cy="88" r="6"/><circle cx="300" cy="104" r="6"/><circle cx="300" cy="120" r="6"/><circle cx="300" cy="136" r="6"/>
</g>
<g font-size="13" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="50" y="162" text-anchor="middle" fill="#0f6e56">1</text>
<text x="130" y="162" text-anchor="middle" fill="#0f6e56">2</text>
<text x="210" y="162" text-anchor="middle" fill="#0f6e56">4</text>
<text x="300" y="162" text-anchor="middle" fill="#0f6e56">8</text>
</g>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="50" y="180" text-anchor="middle" fill="#0f172a">0</text>
<text x="130" y="180" text-anchor="middle" fill="#0f172a">20</text>
<text x="210" y="180" text-anchor="middle" fill="#0f172a">40</text>
<text x="300" y="180" text-anchor="middle" fill="#0f172a">60 mn</text>
</g>
</svg>
:::

- **Champignons microscopiques** = organismes **eucaryotes** apparentés aux végétaux mais **hétérotrophes** (végétaux microscopiques **non chlorophylliens**). **Unicellulaires** : la **levure de bière** (6 à 10 μm, multiplication par **bourgeonnement**). **Filamenteux** (**moisissures**) : moisissure de pain (**mycélium**, **sporange** = boîte à spores), **Pénicillium notatum** → **pénicilline**, **trichophyton** → **teigne**, **Phytophtora** → **mildiou**.
- **Virus** = particule organisée **incapable de se développer en dehors d''une cellule vivante** : une **capsule** + du **matériel génétique**, sans organisation cellulaire. Inerte dehors (il ne respire pas, ne se reproduit pas), il ne se multiplie que dans une **cellule hôte** — animale, végétale ou bactérienne : c''est un **parasite intracellulaire obligatoire**. Tailles : V.I.H. 100 nm, grippe 150 nm, bactériophages 200 nm, variole 240 nm. Repères : 1 A° = 10⁻¹⁰ m ; 1 μm = 10⁻⁶ m.
- **Utiles ou pathogènes** — la ligne de partage traverse les quatre groupes. **Utiles** : fermentation bactérienne (fromages, yaourts, vinaigres), production d''enzymes, de médicaments, d''antibiotiques, de vaccins, d''hormones ; Pénicille → pénicilline ; levure → pain, vin, bière, cidre. **Pathogènes** : hématozoaire → paludisme, amibe dysentérique → amibiase, trypanosome → maladie du sommeil ; bacille de Koch → tuberculose, vibrion du choléra → choléra, bacille tétanique → tétanos, tréponème → syphilis ; trichophyton → teigne, candida albicans → candidose ; virus de la rougeole, de la rage, de la variole, de la poliomyélite, de la grippe, V.I.H. → S.I.D.A.
- **Voir l''invisible** : montage entre lame et lamelle ; **frottis** (étaler, sécher, **fixer** à l''alcool, **colorer** au bleu de méthylène) ; **grossissement = oculaire × objectif** (× 15 et × 40 → × 600) ; **taille réelle = taille mesurée ÷ grossissement** (1 μm = 1 millième de mm) ; le **microscope électronique** prend le relais pour E. Coli (MEB, × 27 000) et pour les virus.', 4, '{"code":"225104P00","pages":"92-106","pageNumbers":[92,93,94,95,96,97,98,99,100,101,102,103,104,105,106]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('972beaaf-ae6a-517d-8ab0-f127666f7061', 'svt-1ere-sec', 'Les agents pathogènes et les maladies infectieuses — quatre fiches, deux modes d''attaque', 'Les maladies infectieuses et leurs agents pathogènes : le vocabulaire officiel (infection, contagion, symptômes, phase d''incubation, épidémie) ; quatre fiches de maladies suivant le gabarit officiel symptômes / agent pathogène / mode de contagion / effet sur l''organisme / mesures de prévention — la grippe (virus de la grippe, voie aérienne, lésions cellulaires locales, surinfection bactérienne), la tuberculose pulmonaire (bacille de Koch, contagion directe et indirecte, personnes à risque, BCG), la rougeole (virus de la rougeole, chronologie incubation-éruption-desquamation, tissus lymphoïdes, complications dues à d''autres microbes) et le tétanos (bacille tétanique, bactérie anaérobie, spore, blessure par objet rouillé, toxine tétanique) ; les deux modes d''action des bactéries pathogènes (par leur présence : bacille de Koch ; par leurs toxines : bacille tétanique, bacille diphtérique) et le mode d''action des virus (parasitisme cellulaire et destruction de la cellule) ; les quatre voies de contamination (respiratoire, digestive, sexuelle, sanguine) ; les animaux vecteurs ; les mesures de prévention (hygiène corporelle et alimentaire, propreté de l''environnement, vaccination, conduite en cas de blessure, de piqûre ou de morsure)', '# ⚔️ Les agents pathogènes et les maladies infectieuses — quatre fiches, deux modes d''attaque

> 💡 «Tu sais maintenant nommer les quatre groupes de microbes. Mais que font-ils, exactement, à un organisme ? Quatre maladies vont te l''apprendre — et tu découvriras qu''une bactérie a deux façons très différentes de te rendre malade.»

Certains microbes sont utiles à l''homme : ils sont utilisés dans les industries alimentaire et pharmaceutique. À côté de cela, il existe des microbes **pathogènes**, responsables de **maladies infectieuses** telles que la tuberculose, la grippe, la rougeole, le tétanos… Tu sais déjà du collège que les microbes pathogènes sont à l''origine de maladies infectieuses, que beaucoup de ces maladies sont **contagieuses**, et que le SIDA et la blennorragie sont deux maladies infectieuses sexuellement transmissibles.

Trois questions guident ce chapitre : **quels sont les agents pathogènes qui causent ces maladies ? quels sont les signes de ces maladies ? comment peut-on les éviter ?**

## 📖 Deux mots à poser d''abord

Tout le chapitre repose sur ces deux définitions — apprends-les mot à mot.

- **Infection** : pénétration et développement dans un organisme de micro-organismes pathogènes (dits **agents infectieux**), produisant des troubles d''intensité et de gravités variables.
- **Contagion** : transmission d''une maladie d''un individu atteint à un individu non porteur de cette maladie.

> 🗡️ Ne confonds pas les deux : l''**infection**, c''est ce qui se passe **dans un organisme** ; la **contagion**, c''est le passage **d''un organisme à un autre**. Une maladie peut être infectieuse sans être contagieuse — le tétanos, tu le verras, en est l''exemple parfait.

Les **symptômes** sont les signes de la maladie. La **phase d''incubation** est la période, après la contamination, pendant laquelle aucun signe n''apparaît encore.

## 🤧 Fiche 1 — La grippe

| Rubrique                  | Ce que dit le manuel                                                                                                                                                                                                                                              |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Symptômes**             | fièvre, courbatures, **asthénie**, écoulement du nez, éternuement, mal à la gorge                                                                                                                                                                                 |
| **Agent pathogène**       | le **virus de la grippe**                                                                                                                                                                                                                                         |
| **Mode de contagion**     | par **voie aérienne** : le malade libère, en toussant, de fines gouttelettes de salive contenant le virus, capable de s''introduire dans les voies respiratoires d''un autre sujet                                                                                  |
| **Effet sur l''organisme** | les virus se fixent au niveau des **muqueuses du nez, de la gorge et des bronches** ; ils entraînent des **lésions cellulaires locales**, ce qui favorise la **surinfection bactérienne** (angines et bronchites), surtout chez les personnes affaiblies ou âgées |
| **Mesures de prévention** | contacts limités avec les malades ; **vaccination**. Tout malade doit être traité par des médicaments l''aidant à surmonter la maladie, et par des **antibiotiques en cas de surinfections bactériennes**                                                          |

Le manuel retient de la grippe : « **maladie virale** qui se transmet par les **contacts humains**. Les **épidémies** sont **saisonnières** (pendant la saison **froide et humide**). » Une **épidémie**, c''est la propagation rapide d''une maladie contagieuse dans une population — et tu verras plus loin qu''il suffit d''un malade dans un espace clos et mal ventilé pour en déclencher une en miniature.

> ⚠️ Piège classique : « on soigne la grippe avec des antibiotiques ». Non — la grippe est **virale**, et les antibiotiques ne servent ici qu''en cas de **surinfection bactérienne**, c''est-à-dire quand des bactéries profitent des lésions laissées par le virus. C''est bien la raison pour laquelle la vaccination antigrippale est conseillée aux personnes âgées : chez elles, ce sont ces surinfections qui sont redoutables.

## 🫁 Fiche 2 — La tuberculose pulmonaire

| Rubrique                  | Ce que dit le manuel                                                                                                                                                                                                                                                                                                         |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Symptômes**             | toux souvent accompagnée de **crachats parfois mêlés de sang**, fièvre, sueurs nocturnes, maux à la poitrine, amaigrissement et perte d''appétit                                                                                                                                                                              |
| **Agent pathogène**       | le **bacille tuberculeux**, ou **bacille de Koch (BK)** — très répandu dans la nature, surtout dans les endroits **humides, mal aérés et mal ensoleillés** ; il est **tué par le soleil en quelques heures** et ne résiste pas aux températures élevées                                                                      |
| **Mode de contagion**     | **directe** : le BK est véhiculé par les gouttelettes que le malade projette en toussant, en éternuant et même en parlant, et qui parviennent par **inhalation** aux voies respiratoires ou digestives d''une personne saine. **Indirecte** : par les **crachats, les mouchoirs et les couverts** utilisés par un tuberculeux |
| **Effet sur l''organisme** | les bacilles de Koch **se multiplient dans les poumons jusqu''à les détruire**                                                                                                                                                                                                                                                |
| **Prévention**            | **découverte précoce** des cas par l''examen des personnes présentant les signes, de celles vivant au contact des malades et de celles présentant des facteurs de risque ; **traitement régulier et contrôlé jusqu''à guérison** par des médicaments **antituberculeux** ; **vaccination par le BCG** des enfants              |

**Les personnes à risque**, telles que les nomme le manuel : diabétiques · insuffisants rénaux chroniques · alcooliques · personnes âgées (surtout en institution) · détenus · malades présentant une faiblesse des défenses immunitaires. Plus largement, les personnes affaiblies, mal nourries, alcooliques, droguées, surmenées physiquement ou intellectuellement sont plus exposées à la contamination par le bacille de Koch.

## 🔴 Fiche 3 — La rougeole

La rougeole est la seule des quatre maladies dont le manuel détaille la **chronologie** — et c''est ce qui la rend redoutable : pendant dix jours, le malade ne présente aucun signe.

::: figure Les 10 premiers jours de la rougeole sont silencieux : c''est la phase d''incubation. Les signes ne commencent qu''ensuite, et l''éruption n''arrive qu''au 4ème jour de symptômes
<svg viewBox="0 0 360 150">
<line x1="26" y1="70" x2="336" y2="70" stroke="#0f172a" stroke-width="2.5"/>
<path d="M330 64 L342 70 L330 76 Z" fill="#0f172a"/>
<g stroke="#0f172a" stroke-width="1.6">
<line x1="26" y1="62" x2="26" y2="78"/><line x1="176" y1="62" x2="176" y2="78"/><line x1="221" y1="62" x2="221" y2="78"/><line x1="266" y1="62" x2="266" y2="78"/><line x1="311" y1="62" x2="311" y2="78"/>
</g>
<rect x="26" y="46" width="150" height="16" fill="#94a3b8" opacity="0.45" stroke="#0f172a" stroke-width="1.4"/>
<rect x="176" y="46" width="45" height="16" fill="#0f6e56" opacity="0.5" stroke="#0f172a" stroke-width="1.4"/>
<rect x="221" y="46" width="45" height="16" fill="#dc2626" opacity="0.5" stroke="#0f172a" stroke-width="1.4"/>
<rect x="266" y="46" width="45" height="16" fill="#7c3aed" opacity="0.4" stroke="#0f172a" stroke-width="1.4"/>
<g font-size="9" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="101" y="38" text-anchor="middle" fill="#0f172a">incubation silencieuse</text>
<text x="198" y="98" text-anchor="middle" fill="#0f6e56">fièvre, nez,</text>
<text x="198" y="110" text-anchor="middle" fill="#0f6e56">yeux, diarrhée</text>
<text x="243" y="98" text-anchor="middle" fill="#dc2626">éruption</text>
<text x="243" y="110" text-anchor="middle" fill="#dc2626">taches rouges</text>
<text x="288" y="98" text-anchor="middle" fill="#7c3aed">desquamation</text>
</g>
<g font-size="10" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="26" y="136" text-anchor="middle" fill="#0f172a">0</text>
<text x="176" y="136" text-anchor="middle" fill="#0f172a">10</text>
<text x="221" y="136" text-anchor="middle" fill="#0f172a">13</text>
<text x="266" y="136" text-anchor="middle" fill="#0f172a">16</text>
<text x="314" y="136" text-anchor="middle" fill="#0f172a">19 jours</text>
</g>
</svg>
:::

- **L''agent pathogène** : le **virus de la rougeole**. — **Le mode de contagion** : elle se fait **par l''air**.
- **L''effet sur l''organisme** : les virus pénètrent par les **voies respiratoires**, passent dans le **sang** et envahissent les **tissus lymphoïdes**. Ils agissent sur le **système nerveux central, la peau, les poumons, les yeux et les reins**, et provoquent les symptômes de la maladie.
- **Les complications** : elles peuvent arriver — et voici le point à retenir : **elles ne sont pas dues au virus de la rougeole**, mais à des **infections par d''autres microbes** (complications respiratoires, digestives, nerveuses et sensorielles).
- **Prévention** : vacciner contre la rougeole **dès le jeune âge**. En cas d''infection : veiller à la propreté du corps et du linge du malade, désinfecter le nez, les oreilles et les yeux avec des médicaments appropriés, le protéger contre le refroidissement, lui donner **l''eau du riz** s''il a une diarrhée. En cas de complication : amener le malade à l''hôpital.

Le manuel retient de la rougeole : « maladie virale des **yeux** et du **nez** puis de la **peau**. Elle attaque surtout les **enfants**. »

## 🦴 Fiche 4 — Le tétanos

Le tétanos est le cas à part — et c''est pour cela qu''il est le plus interrogé.

- **Symptômes** : les premiers signes apparaissent **de 2 à 15 jours** après la blessure qui a occasionné l''introduction du microbe : **contraction d''abord limitée aux muscles des mâchoires, puis généralisée**. La mort survient en **1 ou 2 jours**, à cause d''une **asphyxie due à la paralysie des muscles respiratoires**.
- **Agent pathogène** : le **bacille tétanique**, une **bactérie anaérobie**. Ce microbe se transforme en **spore** dans un milieu oxygéné ; les spores sont fréquentes dans la **terre** et la **poussière**.
- **Mode de contamination** : à l''occasion d''une **blessure par un objet rouillé**, les spores pénètrent dans l''organisme et se transforment en bacille tétanique actif, qui se multiplie rapidement.
- **Effet sur l''organisme** : le bacille se multiplie **au niveau de la plaie**, mais **il reste localisé à cet endroit — il n''envahit pas l''organisme**. Par contre, il fabrique un **poison**, la **toxine tétanique**, qui **se répand dans l''organisme** et **se fixe irréversiblement** au niveau du **tissu nerveux**.
- **Prévention** : à titre préventif, la **vaccination** contre le tétanos avec un **rappel tous les 5 ans**. En cas de blessure avec un objet suspect : désinfection soigneuse de la blessure et administration de **sérum antitétanique**. En cas d''apparition de symptômes (difficultés respiratoires, difficulté d''ouvrir la bouche…), amener le malade au centre hospitalier le plus proche.

Le manuel retient : « **Tétanos** : maladie grave souvent mortelle dont l''agent responsable est le bacille tétanique. Cette maladie peut survenir à l''occasion d''une blessure **même bénigne**. »

## ⚔️ Le cœur du chapitre : deux modes d''attaque pour les bactéries

Compare la tuberculose et le tétanos, et tu tiens la notion la plus importante du chapitre. Le BK se multiplie **dans les poumons jusqu''à les détruire** : il agit **là où il est**, par sa **présence**. Le bacille tétanique, lui, **ne bouge pas de la plaie** — et pourtant il tue le malade à distance, parce qu''il **sécrète une toxine** qui voyage.

::: figure Deux bactéries, deux stratégies : le bacille de Koch détruit par sa présence là où il se multiplie ; le bacille tétanique reste dans la plaie et envoie sa toxine à distance
<svg viewBox="0 0 360 180">
<rect x="14" y="26" width="156" height="130" rx="8" fill="#0f6e56" opacity="0.07" stroke="#0f172a" stroke-width="1.6"/>
<rect x="190" y="26" width="156" height="130" rx="8" fill="#7c3aed" opacity="0.07" stroke="#0f172a" stroke-width="1.6"/>
<g fill="#0f6e56" opacity="0.75" stroke="#0f172a" stroke-width="1.2">
<rect x="72" y="86" width="14" height="6" rx="3"/><rect x="92" y="96" width="14" height="6" rx="3"/><rect x="78" y="106" width="14" height="6" rx="3"/><rect x="98" y="80" width="14" height="6" rx="3"/><rect x="62" y="98" width="14" height="6" rx="3"/>
</g>
<path d="M52 74 Q92 58 132 74 Q140 104 92 124 Q44 104 52 74 Z" fill="none" stroke="#dc2626" stroke-width="2" stroke-dasharray="5 3"/>
<rect x="252" y="120" width="16" height="7" rx="3.5" fill="#7c3aed" opacity="0.85" stroke="#0f172a" stroke-width="1.2"/>
<path d="M240 116 Q260 106 280 116" fill="none" stroke="#0f172a" stroke-width="1.6"/>
<g fill="none" stroke="#dc2626" stroke-width="1.8">
<path d="M262 112 L262 84"/><path d="M258 96 L240 76"/><path d="M266 96 L288 76"/>
</g>
<g fill="#dc2626">
<path d="M258 84 L262 76 L266 84 Z"/><path d="M244 82 L238 74 L248 76 Z"/><path d="M280 82 L290 74 L284 76 Z"/>
</g>
<g font-size="10" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="92" y="44" text-anchor="middle" fill="#0f6e56">par sa PRÉSENCE</text>
<text x="268" y="44" text-anchor="middle" fill="#7c3aed">par sa TOXINE</text>
<text x="92" y="146" text-anchor="middle" fill="#0f172a">bacille de Koch</text>
<text x="268" y="146" text-anchor="middle" fill="#0f172a">bacille tétanique</text>
</g>
<g font-size="8.5" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">
<text x="92" y="62" text-anchor="middle" fill="#dc2626">poumon détruit</text>
<text x="268" y="138" text-anchor="middle" fill="#0f172a">reste dans la plaie</text>
</g>
</svg>
:::

Le **Bilan** l''énonce ainsi : les maladies infectieuses sont causées essentiellement par les **bactéries** et les **virus**.

- **Les bactéries pathogènes** agissent sur l''organisme **soit par leur présence**, comme le **bacille de Koch**, **soit par les toxines qu''elles sécrètent**, comme le **bacille tétanique** et le **bacille diphtérique**.
- **Les virus** parasitent les cellules vivantes en **utilisant leur matériel pour se multiplier**. Ils finissent généralement par **les détruire**.

> 🗡️ C''est aussi ce qui explique que le tétanos ne soit **pas contagieux** : le bacille ne quitte jamais la plaie, il n''y a donc rien à transmettre d''un malade à un autre. On l''attrape de la **terre**, pas d''un tuberculeux. La plupart des maladies infectieuses sont contagieuses — le tétanos est l''exception qui te fait comprendre la règle.

## 🚪 Les quatre voies de contamination

La plupart des maladies infectieuses sont **contagieuses**, c''est-à-dire qu''elles se transmettent des individus malades aux individus sains. La contamination peut se faire par quatre voies :

| Voie                                          | Exemples donnés par le manuel                                    |
| --------------------------------------------- | ---------------------------------------------------------------- |
| **Respiratoire**                              | la grippe, la tuberculose, le SRAS                               |
| **Digestive**                                 | les infections intestinales liées aux intoxications alimentaires |
| **Sexuelle** (sperme et sécrétions vaginales) | le SIDA, la blennorragie, la syphilis                            |
| **Sanguine**                                  | le SIDA                                                          |

Retiens que le **SIDA** figure sur **deux** lignes : il se transmet par voie sexuelle **et** par voie sanguine. Par ailleurs, certains **animaux** — le chien, le chat, le rat, les mouches et les moustiques — peuvent transmettre des agents pathogènes à l''homme.

## 🛡️ Comment les éviter

Pour prévenir les maladies infectieuses, il faut :

- suivre les **règles simples d''hygiène** corporelle et alimentaire ;
- contribuer à la **propreté de l''environnement** ;
- pratiquer la **vaccination** contre certaines maladies : la tuberculose, la rougeole, la poliomyélite.

Et **en cas de blessures, de piqûres ou de morsures**, il faut aller au centre hospitalier le plus proche pour recevoir les soins nécessaires.

> 🏆 Cinquième quête franchie, héros : tu sais remplir les quatre fiches, tu distingues une bactérie qui tue par sa présence d''une bactérie qui tue par sa toxine, et tu connais les quatre portes d''entrée. Mais une question reste entière : quand un microbe franchit la porte, **qui le combat** ? La vaccination et le sérum, cités ici comme de simples mesures, cachent un mécanisme — c''est tout le chapitre suivant.', '# 📜 Résumé : Les agents pathogènes et les maladies infectieuses

- **Les deux définitions.** **Infection** : pénétration et développement dans un organisme de micro-organismes pathogènes (agents infectieux), produisant des troubles d''intensité et de gravités variables. **Contagion** : transmission d''une maladie d''un individu atteint à un individu non porteur de cette maladie. Les **symptômes** sont les signes de la maladie ; la **phase d''incubation** est la période sans signe qui suit la contamination.
- **La grippe** — maladie **virale** qui se transmet par les contacts humains, épidémies saisonnières (saison froide et humide). Symptômes : fièvre, courbatures, asthénie, écoulement du nez, éternuement, mal à la gorge. Agent : le **virus de la grippe**. Contagion : **voie aérienne** (gouttelettes de salive projetées en toussant). Effets : fixation sur les **muqueuses du nez, de la gorge et des bronches**, **lésions cellulaires locales** favorisant la **surinfection bactérienne** (angines, bronchites), surtout chez les personnes affaiblies ou âgées. Prévention : contacts limités, **vaccination** ; antibiotiques **seulement** en cas de surinfection bactérienne.
- **La tuberculose** — maladie causée par le **bacille de Koch (BK)**. Symptômes : toux avec crachats parfois mêlés de sang, fièvre, sueurs nocturnes, maux à la poitrine, amaigrissement, perte d''appétit. Le BK est répandu dans les endroits **humides, mal aérés et mal ensoleillés**, mais **tué par le soleil en quelques heures**. Contagion **directe** (gouttelettes inhalées) et **indirecte** (crachats, mouchoirs, couverts). Effet : les BK **se multiplient dans les poumons jusqu''à les détruire**. Prévention : découverte précoce, traitement **antituberculeux** régulier jusqu''à guérison, **vaccination par le BCG** des enfants. Personnes à risque : diabétiques, insuffisants rénaux chroniques, alcooliques, personnes âgées, détenus, malades à défenses immunitaires faibles.
- **La rougeole** — maladie **virale** des **yeux** et du **nez** puis de la **peau**, qui attaque surtout les **enfants**. Chronologie : **10 premiers jours** sans aucun signe (**incubation silencieuse**) → **3 jours** de fièvre, écoulement du nez, yeux larmoyants, visage gonflé, diarrhée, perte d''appétit → **3 jours** d''**éruption** (taches rouges sur tout le corps) → **3 jours** de **desquamation**. Agent : le **virus de la rougeole** ; contagion **par l''air**. Effets : pénétration par les voies respiratoires, passage dans le **sang**, envahissement des **tissus lymphoïdes**, action sur le système nerveux central, la peau, les poumons, les yeux et les reins. ⚠️ Les **complications ne sont pas dues au virus de la rougeole**, mais à des infections **par d''autres microbes**. Prévention : vacciner **dès le jeune âge**.
- **Le tétanos** — maladie grave souvent mortelle, qui peut survenir à l''occasion d''une blessure **même bénigne**. Symptômes **2 à 15 jours** après la blessure : contraction d''abord limitée aux **muscles des mâchoires**, puis généralisée ; mort en **1 ou 2 jours** par **asphyxie** due à la paralysie des muscles respiratoires. Agent : le **bacille tétanique**, **bactérie anaérobie** qui se transforme en **spore** en milieu oxygéné (spores fréquentes dans la terre et la poussière) ; contamination par **blessure avec un objet rouillé**. Effet : le bacille **reste localisé dans la plaie, il n''envahit pas l''organisme**, mais fabrique un poison, la **toxine tétanique**, qui se répand et se fixe **irréversiblement** sur le **tissu nerveux**. Prévention : **vaccination avec rappel tous les 5 ans** ; en cas de blessure suspecte, désinfection soigneuse + **sérum antitétanique**.
- **Les deux modes d''action — le cœur du chapitre.** Les maladies infectieuses sont causées essentiellement par les **bactéries** et les **virus**. Les bactéries pathogènes agissent **soit par leur présence** (bacille de Koch, qui détruit les poumons où il se multiplie), **soit par les toxines qu''elles sécrètent** (bacille tétanique, bacille diphtérique — le microbe reste localisé, c''est son poison qui voyage). Les **virus** parasitent les cellules vivantes en **utilisant leur matériel pour se multiplier** et finissent généralement par **les détruire**.
- **Les quatre voies de contamination.** **Respiratoire** (grippe, tuberculose, SRAS) · **digestive** (infections intestinales liées aux intoxications alimentaires) · **sexuelle**, par le sperme et les sécrétions vaginales (SIDA, blennorragie, syphilis) · **sanguine** (SIDA). Certains **animaux** — chien, chat, rat, mouches, moustiques — peuvent transmettre des agents pathogènes à l''homme.
- **La prévention.** Suivre les règles simples d''**hygiène corporelle et alimentaire** ; contribuer à la **propreté de l''environnement** ; pratiquer la **vaccination** contre certaines maladies (tuberculose, rougeole, poliomyélite). En cas de **blessure, de piqûre ou de morsure** : aller au centre hospitalier le plus proche pour recevoir les soins nécessaires.', 5, '{"code":"225104P00","pages":"107-116","pageNumbers":[107,108,109,110,111,112,113,114,115,116]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('a15437ac-fbc7-54e7-ad0d-892a7377dec1', 'svt-1ere-sec', 'La défense de l''organisme — deux lignes, puis une arme sur mesure', 'Les deux modalités de défense face aux agents pathogènes. L''immunité non spécifique : les barrières naturelles mécaniques et chimiques (couche cornée, mucus, acidité des sécrétions lacrymales et sudoripares, acidité du tube digestif) ; la réaction inflammatoire et ses signes (rougeur, chaleur, gonflement, douleur) ; le pus ; la diapédèse ; la phagocytose et ses trois étapes (adhésion, absorption = ingestion, digestion), le phagosome et les vésicules digestives ; l''échec de la phagocytose et la septicémie ; les phagocytes (polynucléaires, monocytes, macrophages). L''immunité spécifique acquise et ses trois propriétés (mémoire, spécificité, diversité) mises en évidence expérimentalement sur les souris A à F et le témoin T ; réponse primaire et réponse secondaire (délai, quantité d''anticorps, durée) ; antigène, anticorps, toxine et anatoxine ; la découverte et le principe de la vaccination (Jenner 1798 et la vaccine, Pasteur 1879 et la culture vieillie, Ramon 1923 et l''anatoxine) ; le transfert de l''immunité par le sérum et la sérothérapie (Von Behring 1890, Roux 1894, cheval hyper-immunisé) ; la comparaison vaccination / sérothérapie (préventive vs curative, immunité active vs passive, délai et durée d''action) ; la démarche expérimentale et le rôle du témoin', '# ⚔️ La défense de l''organisme — deux lignes, puis une arme sur mesure

> 💡 «Tu viens de voir quatre microbes attaquer. Il est temps de voir l''organisme riposter. Il a deux façons de le faire : la brute, qui frappe tout ce qui passe — et le spécialiste, qui n''a qu''une cible mais ne l''oublie jamais.»

Face aux agressions des agents pathogènes de l''environnement, l''organisme réagit selon **deux modalités de défense** : l''**immunité non spécifique** et l''**immunité spécifique**. L''**immunité**, c''est la **résistance (naturelle ou acquise) d''un organisme à un agent infectieux** — microbes ou toxines.

Deux questions mènent le chapitre : **quels sont les moyens de l''immunité non spécifique ? quels sont les moyens de l''immunité spécifique ?**

Du collège, tu sais déjà que la peau joue le rôle de barrière contre l''introduction des microbes, que le sang est composé de globules rouges, de globules blancs et de plasma, que les **globules blancs** (ou **leucocytes**) participent à la défense, que parmi eux les **polynucléaires** et les **monocytes** ont la capacité de **phagocyter** les microbes, que la réaction inflammatoire se manifeste par la rougeur, le gonflement et la douleur, et que le **sérum** est la partie liquide libérée du sang lors de sa coagulation.

# 🛡️ Partie A — L''immunité non spécifique

L''organisme dispose d''une défense lui permettant **en permanence** de s''opposer à la pénétration des microbes et à leur invasion : c''est l''immunité non spécifique, c''est-à-dire qu''elle **s''oppose à toute sorte de microbe sans distinction**. Elle compte **deux lignes de défense**.

## 🧱 Première ligne — les barrières naturelles

Les surfaces de protection du corps — **peau** et **muqueuses** — constituent des barrières efficaces s''opposant à la pénétration des microbes et autres agents étrangers. Très peu de micro-organismes sont capables de traverser la peau **lorsqu''elle est intacte**. Le manuel en compte cinq : les **larmes**, les **muqueuses buccales, nasales…**, la **sueur**, le **suc gastrique**, la **peau**.

Le point à comprendre, c''est qu''elles ne travaillent pas toutes de la même façon : on les classe en **barrières mécaniques** et **barrières chimiques**.

| Type          | Ce qui protège                                                               | Comment                                                                                       |
| ------------- | ---------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| **Mécanique** | la **couche cornée** de la peau                                              | une barrière physique efficace : le microbe ne passe pas                                      |
| **Mécanique** | le **mucus** des muqueuses nasale, intestinale et pulmonaire                 | sécrété en abondance, il **entraîne une grande partie des micro-organismes vers l''extérieur** |
| **Chimique**  | les sécrétions des glandes **lacrymales** et **sudoripares** (larmes, sueur) | leur **acidité ralentit le développement** de nombreuses bactéries                            |
| **Chimique**  | l''**acidité du tube digestif** (suc gastrique)                               | elle **empêche la multiplication bactérienne**                                                |

> 🗡️ Retiens le critère : une barrière **mécanique** _bloque ou évacue_ ; une barrière **chimique** _tue ou empêche de se multiplier_. Le mucus est le piège de ce classement : c''est une sécrétion, et pourtant il agit **mécaniquement** — il balaie le microbe dehors, il ne l''empoisonne pas.

## 🔥 Deuxième ligne — la réaction inflammatoire

Un enfant se pique le doigt accidentellement et néglige de le soigner. Quelques jours plus tard, les alentours de la plaie deviennent **rouges, chauds, gonflés et plus ou moins douloureux** : c''est l''**inflammation**. Du **pus** se forme autour de la plaie.

**Inflammation** : réaction de l''organisme aux **lésions des tissus** ou aux **infections**, se manifestant localement par la **chaleur**, le **gonflement** et la **rougeur**. Le bilan y ajoute la **douleur** : retiens les **quatre signes** — rougeur, chaleur, gonflement, douleur.

Que s''est-il passé ? À l''occasion d''une blessure, d''une piqûre ou d''une brûlure, les microbes **franchissent la peau** (ou la muqueuse) — la première ligne est tombée — et pénètrent dans les tissus où ils **se multiplient**, provoquant une infection. L''organisme répond alors par des réactions **locales** et **non spécifiques** : l''inflammation et la phagocytose.

Des leucocytes — **polynucléaires, monocytes et macrophages**, appelés **phagocytes** — sont **attirés par des substances chimiques fabriquées par le tissu infecté** et arrivent **en grand nombre** dans la zone enflammée. Pour y parvenir, ils doivent sortir des vaisseaux sanguins : c''est la **diapédèse** — la **migration, vers le foyer d''infection, des leucocytes à travers la paroi des vaisseaux sanguins**.

Et le pus ? Observé au microscope, il révèle des **bactéries** et des **globules blancs polynucléaires** : le pus est fait des combattants et de leurs adversaires.

## 🍽️ La phagocytose, en trois étapes

Au foyer de l''infection, et **quelle que soit la nature de l''agent pathogène**, il se produit entre les polynucléaires et les micro-organismes une véritable lutte pour la survie. Le polynucléaire **englobe et ingère** le microbe : c''est la **phagocytose**.

**Phagocytose** : mécanisme par lequel certaines cellules de l''organisme, notamment les globules blancs, **englobent et digèrent** des particules étrangères. **Phagocyte** : polynucléaire capable d''**ingérer un élément étranger dans le but de l''éliminer**.

::: figure Les trois étapes dans l''ordre : le phagocyte adhère au microbe, l''englobe dans un phagosome, puis le digère grâce aux vésicules digestives qui y déversent leur contenu
<svg viewBox="0 0 360 170">
<g fill="#0f6e56" opacity="0.12" stroke="#0f172a" stroke-width="2">
<circle cx="60" cy="80" r="34"/><circle cx="180" cy="80" r="34"/><circle cx="300" cy="80" r="34"/>
</g>
<g fill="#0f172a" opacity="0.55">
<circle cx="48" cy="68" r="7"/><circle cx="168" cy="66" r="7"/><circle cx="288" cy="66" r="7"/>
</g>
<path d="M84 96 Q94 106 84 112" fill="none" stroke="#0f172a" stroke-width="1.6"/>
<rect x="92" y="92" width="15" height="7" rx="3.5" fill="#dc2626" opacity="0.8" stroke="#0f172a" stroke-width="1.2"/>
<rect x="176" y="90" width="15" height="7" rx="3.5" fill="#dc2626" opacity="0.8" stroke="#0f172a" stroke-width="1.2"/>
<circle cx="183" cy="93" r="14" fill="none" stroke="#7c3aed" stroke-width="2"/>
<circle cx="303" cy="93" r="14" fill="none" stroke="#7c3aed" stroke-width="2"/>
<g fill="#dc2626" opacity="0.45">
<circle cx="299" cy="90" r="2"/><circle cx="306" cy="95" r="2"/><circle cx="302" cy="98" r="2"/><circle cx="308" cy="89" r="2"/>
</g>
<g fill="#7c3aed" opacity="0.55" stroke="#0f172a" stroke-width="1">
<circle cx="320" cy="72" r="5"/><circle cx="288" cy="106" r="5"/>
</g>
<g fill="none" stroke="#0f172a" stroke-width="1.4">
<path d="M317 77 L308 86"/><path d="M292 102 L299 96"/>
</g>
<g font-size="10" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="60" y="32" text-anchor="middle" fill="#0f6e56">1. Adhésion</text>
<text x="180" y="32" text-anchor="middle" fill="#0f6e56">2. Absorption</text>
<text x="300" y="32" text-anchor="middle" fill="#0f6e56">3. Digestion</text>
</g>
<g font-size="8" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">
<text x="180" y="44" text-anchor="middle" fill="#0f172a">= ingestion</text>
<text x="112" y="142" text-anchor="middle" fill="#dc2626">microbe</text>
<text x="196" y="142" text-anchor="middle" fill="#7c3aed">phagosome</text>
<text x="322" y="142" text-anchor="middle" fill="#7c3aed">vésicules digestives</text>
<text x="40" y="142" text-anchor="middle" fill="#0f172a">noyau</text>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.1">
<path d="M100 100 L108 134"/><path d="M188 106 L194 134"/><path d="M318 78 L322 134"/><path d="M46 76 L42 134"/>
</g>
</svg>
:::

La **propriété** qui permet au polynucléaire de réaliser l''adhésion et l''ingestion, c''est sa capacité à **déformer sa membrane** pour englober ce qu''il touche.

**La phagocytose réussit-elle toujours ?** Non — et c''est capital.

- **Cas de réussite** : les bactéries deviennent rapidement **méconnaissables** ; elles subissent une **digestion à l''intérieur du phagocyte**.
- **Cas d''échec** : il peut arriver que les bactéries, qui se multiplient très rapidement, **résistent** à la phagocytose des polynucléaires, pourtant très nombreux au niveau de la plaie. Les bactéries vont alors tendre à **envahir l''organisme** : c''est l''**infection généralisée**, appelée **septicémie**.

> 🗡️ Pourquoi dit-on que la phagocytose est une défense **non spécifique** ? Relis la première phrase de la section : « **quelle que soit la nature de l''agent pathogène** ». Le phagocyte ne demande pas son nom au microbe — il englobe tout élément étranger. Il n''a **pas de cible privilégiée** : voilà le sens du mot.

**L''immunité naturelle** est la **défense non spécifique de l''organisme, contre les microbes, assurée par la peau, les muqueuses, l''inflammation et la phagocytose** — les deux lignes réunies en une définition.

# 🎯 Partie B — L''immunité spécifique

Les défenses naturelles ne suffisent pas toujours pour vaincre une infection microbienne. **Si l''immunité non spécifique est inefficace pour éliminer le germe pathogène**, l''organisme a recours à d''autres moyens, **dirigés spécifiquement contre le microbe introduit** : c''est l''immunité spécifique.

## 👀 Le fait qui intrigue

Certaines maladies **ne récidivent pas** : un enfant qui a eu la **rougeole** ne contractera plus cette maladie, car il a **acquis une immunité** contre la rougeole. Il en est de même pour la **varicelle**. Comment expliquer cela ? Toute la partie B répond à cette question.

## 💉 La vaccination — deux découvertes

**Jenner, 1798.** La **variole**, maladie virale contagieuse et **mortelle dans 50 % des cas**, était la maladie épidémique la plus redoutée : pustules sur tout le corps, traces indélébiles chez les survivants. Jenner, médecin anglais, apprend que les fermières ayant contracté la **vaccine** (variole bovine **bénigne**) **échappaient** aux épidémies de variole. Il formule l''hypothèse qu''**une maladie bénigne peut protéger contre une maladie mortelle**. Il inocule à un enfant du pus prélevé sur une pustule de vache malade : le **7ème jour**, l''enfant se plaint d''une petite douleur, ressent quelques frissons, perd l''appétit ; **le lendemain**, il est parfaitement bien portant. **L''année suivante**, Jenner lui inocule du pus d''une personne atteinte de variole : il **ne contracte pas la maladie** et ne fait **aucune réaction locale**. Cette pratique fut appelée **vaccination**.

**Pasteur, 1879.** Pasteur démontre que le **choléra des poules**, maladie mortelle, est dû à un **bacille**. Il apprend que l''injection à des poules d''une culture du microbe **abandonnée depuis quelques semaines à l''étuve** ne les tue pas. Il pense que ces microbes vieillis jouent **le même rôle que le virus de la vaccine**. Pour mettre son idée à l''épreuve, il injecte une **culture fraîche** du microbe à deux lots de poules :

| Lot                        | Traitement préalable                 | Résultat après la culture fraîche |
| -------------------------- | ------------------------------------ | --------------------------------- |
| **Lot A** (**lot témoin**) | aucun traitement                     | **toutes mortes**                 |
| **Lot B**                  | injection de la **culture vieillie** | **vivantes**                      |

Les microbes de la culture vieillie sont **atténués** : ils ont perdu leur pouvoir pathogène, mais ils ont **conservé leur capacité à faire réagir l''organisme**. Le lot A est là pour prouver que la culture fraîche est bien mortelle : **sans témoin, l''expérience ne démontre rien**.

Le bilan en tire le principe : un germe pathogène possède **deux caractères indépendants** — il est **pathogène**, puisqu''il provoque une maladie, et il est **capable d''induire une réponse immunitaire**. Un **vaccin** est une préparation de microbe ou de toxine **atténués**, capable d''induire une réponse immunitaire spécifique qui protège l''individu traité contre le microbe pathogène. **La vaccination est une application de la mémoire immunitaire.**

- **Vaccination** : traitement **préventif** destiné à protéger l''organisme contre un agent infectieux donné, par **injection d''une forme non pathogène**.
- **Vaccin** : germe ou toxine **atténué(e)** qui, injecté(e) à un organisme, lui permet d''**acquérir une immunité** contre l''agent pathogène.

**Ramon, 1923.** Une deuxième victoire sur la **diphtérie** est due au professeur **Ramon**. Jenner et Pasteur avaient atténué un **microbe** ; Ramon, lui, s''attaque à une **toxine**. Il prépare une **anatoxine** en additionnant **un peu de formol** à la **toxine diphtérique**, puis en portant le tout à **40 °C pendant un mois**. L''anatoxine obtenue est injectée à une **personne saine** — **trois injections séparées de 15 jours**, puis **une injection un an après** — et lui confère une immunité de **plus de 5 ans**. Retiens le principe : on peut donc vacciner **aussi bien contre un microbe que contre son poison**, et il suffit pour cela de le rendre inoffensif sans le rendre méconnaissable. Retiens aussi la conséquence : cette immunité **ne dure pas toute la vie** — d''où les **rappels**.

## 🐭 Les expériences qui prouvent — souris A à F

Deux mots d''abord, car tout repose sur eux. La **toxine tétanique** est la toxine sécrétée par le bacille tétanique ; l''**anatoxine tétanique** est cette même **toxine rendue inactive par la chaleur et le formol** — inoffensive, donc, mais toujours reconnaissable.

**Expérience 1 — l''acquisition d''une immunité.**

| Souris       | Traitement                             | Résultat 3 semaines plus tard |
| ------------ | -------------------------------------- | ----------------------------- |
| **Souris A** | injection de **toxine** tétanique      | **mort** de la souris A       |
| **Souris B** | injection d''**anatoxine** tétanique    | **survie** de la souris B     |
| **Souris B** | puis injection de **toxine** tétanique | **survie** de la souris B     |

L''injection à la souris A prouve que **la toxine tétanique est bien mortelle** : c''est le témoin. La souris B survit à l''anatoxine (normal : elle est inactivée) — mais surtout elle survit **ensuite à la toxine active**, celle-là même qui a tué A. L''anatoxine a donc joué le rôle d''un **vaccin** : elle a **immunisé** la souris.

**Expérience 2 — la spécificité.**

| Souris       | Traitement                               | Résultat                  |
| ------------ | ---------------------------------------- | ------------------------- |
| **Souris C** | injection d''**anatoxine tétanique**      | **survie** de la souris C |
| **Souris C** | puis injection de **toxine diphtérique** | **mort** de la souris C   |

La souris C était protégée contre le tétanos… et elle meurt de la **diphtérie**. La protection acquise ne vaut donc **que contre l''agent qui l''a provoquée** : c''est la **spécificité**.

**Expérience 3 — le transfert de l''immunité.**

| Souris                                   | Traitement                                     | Résultat                  |
| ---------------------------------------- | ---------------------------------------------- | ------------------------- |
| **Souris D**                             | anatoxine tétanique → on prélève son **sérum** | **survie** de la souris D |
| **Souris E** (reçoit le sérum de D)      | injection de **toxine** tétanique              | **survie** de la souris E |
| **Souris T** (**témoin**, non immunisée) | on prélève son **sérum**                       | —                         |
| **Souris F** (reçoit le sérum de T)      | injection de **toxine** tétanique              | **mort** de la souris F   |

La souris E n''a **jamais** reçu d''anatoxine : elle n''a reçu que le **sérum** de D. Et elle survit. L''immunité est donc **transférable par le sérum**. Pourquoi la souris F ? Parce que sans elle, on pourrait croire que **n''importe quel sérum** protège : F reçoit le sérum d''une souris **non immunisée** et meurt — ce qui prouve que c''est bien l''**immunisation de D**, et non le sérum en tant que liquide, qui protège E.

Les **substances contenues dans le sérum et responsables de l''immunité acquise** sont appelées des **anticorps** — substances dirigées contre un **antigène**. Un **antigène** est un **corps étranger capable d''induire une réponse immunitaire**. Le sérum d''un animal immunisé contre un antigène protège un autre animal, non immunisé, contre le même antigène : ce sérum contient des anticorps qui **neutralisent** cet antigène.

## 🧠 Les trois propriétés de l''immunité acquise

L''**immunité spécifique acquise** est la **capacité de l''organisme de se défendre contre un micro-organisme bien déterminé**. Elle a trois propriétés — apprends-les comme un trio.

::: figure Face au même agent, la 2ème réponse n''est pas une répétition de la 1ère : elle démarre plus tôt, monte plus haut et dure plus longtemps. C''est la mémoire immunitaire
<svg viewBox="0 0 360 190">
<line x1="40" y1="150" x2="345" y2="150" stroke="#0f172a" stroke-width="2"/>
<line x1="40" y1="150" x2="40" y2="22" stroke="#0f172a" stroke-width="2"/>
<path d="M339 144 L351 150 L339 156 Z" fill="#0f172a"/>
<path d="M34 28 L40 16 L46 28 Z" fill="#0f172a"/>
<path d="M70 150 Q92 140 106 122 Q120 106 134 118 Q150 132 178 148" fill="none" stroke="#0f6e56" stroke-width="2.4"/>
<path d="M196 150 Q206 128 214 66 Q222 40 238 44 Q262 50 300 96 Q322 122 340 142" fill="none" stroke="#7c3aed" stroke-width="2.4"/>
<g stroke="#dc2626" stroke-width="1.8" stroke-dasharray="4 3">
<line x1="64" y1="150" x2="64" y2="128"/><line x1="192" y1="150" x2="192" y2="52"/>
</g>
<g fill="#dc2626">
<path d="M60 132 L64 124 L68 132 Z"/><path d="M188 56 L192 48 L196 56 Z"/>
</g>
<g font-size="9" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="64" y="170" text-anchor="middle" fill="#dc2626">1ère injection</text>
<text x="192" y="170" text-anchor="middle" fill="#dc2626">2ème injection</text>
<text x="120" y="96" text-anchor="middle" fill="#0f6e56">réponse primaire</text>
<text x="120" y="107" text-anchor="middle" fill="#0f6e56">lente, faible, courte</text>
<text x="268" y="36" text-anchor="middle" fill="#7c3aed">réponse secondaire</text>
<text x="268" y="47" text-anchor="middle" fill="#7c3aed">rapide, forte, durable</text>
</g>
<g font-size="9" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="46" y="14" text-anchor="start" fill="#0f172a">Quantité d''anticorps</text>
<text x="344" y="168" text-anchor="end" fill="#0f172a">Temps</text>
</g>
</svg>
:::

- **La mémoire.** Lors d''une **1ère infection** par un agent pathogène, le système immunitaire développe une **réponse immunitaire primaire** : **lente, de faible intensité et de courte durée**. À la suite d''une **2ème infection par le même agent pathogène**, il développe une **réponse immunitaire secondaire** : **rapide, forte et durable**.
- **La spécificité.** Le système immunitaire est capable de **reconnaître un microbe déterminé** et de développer une réponse dirigée contre lui. Cette réponse est **inefficace contre un autre microbe** (souris C).
- **La diversité.** Le système immunitaire est capable de développer une réponse immunitaire spécifique **contre chaque microbe** introduit dans l''organisme.

> 🗡️ Ne confonds pas **spécificité** et **diversité** — c''est l''erreur la plus coûteuse du chapitre. La **spécificité** dit : « une réponse **ne sert que contre son** microbe » (une clé n''ouvre qu''une serrure). La **diversité** dit : « il y a **une réponse pour chaque** microbe » (le trousseau a une clé par serrure). L''une limite, l''autre rassure.

## 🐴 La sérothérapie

**Von Behring, 1890**, cherchait un médicament capable d''aider l''organisme à lutter contre le **bacille diphtérique**. Il eut l''idée de l''existence de **substances anti-diphtériques dans le sang des animaux guéris** de la diphtérie.

**Le docteur Roux, 1894**, disciple de Pasteur, s''aperçoit qu''on peut **vacciner un cheval** en lui injectant des **doses croissantes et répétées** de toxine diphtérique à **virulence de plus en plus forte**. Cette immunisation répétée fait apparaître **de grandes quantités d''anticorps** anti-diphtériques dans le sang de l''animal. Roux eut l''idée de **transférer le sérum de ce cheval hyper-immunisé** à des malades atteints de diphtérie : ces malades sont **guéris**. La sérothérapie était née.

- **Sérothérapie** : méthode **curative** fondée sur l''injection de **sérums contenant des anticorps** destinés à **neutraliser un agent pathogène donné**.
- **Sérum** : partie liquide, **contenant des anticorps**, libérée lors de la **coagulation du sang**.

La sérothérapie est le **transfert de l''immunité par le sérum** (souris D → E). Elle consiste à injecter à un organisme malade — ou risquant d''être exposé à la maladie — des **anticorps spécifiques** dirigés contre un antigène bien déterminé, notamment le **venin du scorpion**, la **toxine tétanique**… Le sérum utilisé est généralement préparé à partir du **sang d''un cheval hyper-immunisé** par des doses croissantes de l''agent atténué.

## ⚖️ Vaccination ou sérothérapie ? Le tableau qui tombe à l''examen

|                             | **La vaccination**                                                   | **La sérothérapie**                                                                  |
| --------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| **But d''utilisation**       | **préventive** — elle s''effectue sur des personnes **saines**        | **curative** — elle s''effectue sur des organismes **atteints** ou risquant de l''être |
| **Immunité de l''organisme** | **active** — les anticorps sont **élaborés par l''organisme vacciné** | **passive** — les anticorps sont **élaborés par un autre organisme** immunisé        |
| **Durée d''action**          | action **tardive** et de **longue durée**                            | action **immédiate** et de **courte durée**                                          |

> ⚠️ Le raisonnement derrière le tableau, à comprendre plutôt qu''à réciter : le vacciné **fabrique lui-même** ses anticorps — il lui faut donc du **temps** (action tardive), mais comme il a la **mémoire** de l''antigène, la protection **dure**. Celui qui reçoit un sérum reçoit des anticorps **tout faits** — ils agissent **tout de suite**, mais son organisme n''a **rien appris** : quand ces anticorps disparaissent, la protection s''en va avec eux. C''est pour cela qu''on **vaccine** une personne saine contre le tétanos, mais qu''on lui injecte un **sérum antitétanique** quand elle vient de se blesser : il n''y a plus le temps d''attendre.

Et c''est pour cela aussi que l''immunité conférée par un vaccin **ne dure pas toute la vie** : il faut la **renouveler par des rappels** — comme le rappel antitétanique **tous les 5 ans** vu au chapitre précédent.

> 🏆 Sixième quête franchie, héros : tu sais nommer les deux lignes non spécifiques, décrire les trois étapes de la phagocytose, prouver les trois propriétés de l''immunité acquise avec des souris, et distinguer un vaccin d''un sérum. La partie « Microbes et santé » est bouclée. Direction le sous-sol : la Terre aussi a une histoire à raconter.', '# 📜 Résumé : La défense de l''organisme

- **Deux modalités.** L''**immunité** est la **résistance (naturelle ou acquise) d''un organisme à un agent infectieux** — microbes ou toxines. Face aux agents pathogènes, l''organisme réagit selon deux modalités : l''**immunité non spécifique** (contre toute sorte de microbe, sans distinction) et l''**immunité spécifique** (dirigée contre le microbe introduit). La seconde n''entre en jeu que **si la première est inefficace** pour éliminer le germe.
- **Immunité non spécifique — 1ère ligne : les barrières naturelles.** Peau et muqueuses s''opposent à la pénétration des microbes ; très peu en traversent la peau **intacte**. Barrières **mécaniques** : la **couche cornée** de la peau ; le **mucus** des muqueuses nasale, intestinale et pulmonaire, dont la sécrétion abondante **entraîne les micro-organismes vers l''extérieur**. Barrières **chimiques** : l''**acidité** des sécrétions des glandes **lacrymales** et **sudoripares**, qui **ralentit le développement** de nombreuses bactéries ; l''**acidité du tube digestif**, qui **empêche la multiplication bactérienne**. Les cinq barrières nommées : larmes, muqueuses buccales et nasales, sueur, suc gastrique, peau.
- **Immunité non spécifique — 2ème ligne : inflammation et phagocytose.** À l''occasion d''une blessure, d''une piqûre ou d''une brûlure, les microbes franchissent la peau et se multiplient dans les tissus. **Inflammation** : réaction de l''organisme aux lésions des tissus ou aux infections, se manifestant localement par la **rougeur, la chaleur, le gonflement et la douleur** ; c''est le **premier signe de l''infection**. Les **phagocytes** (**polynucléaires, monocytes, macrophages**) sont **attirés par des substances chimiques fabriquées par le tissu infecté** et arrivent en grand nombre ; ils sortent des vaisseaux par la **diapédèse** — migration des leucocytes à travers la paroi des vaisseaux sanguins. Le **pus**, au microscope, contient des **bactéries** et des **globules blancs polynucléaires**.
- **La phagocytose** : mécanisme par lequel certaines cellules, notamment les globules blancs, **englobent et digèrent** des particules étrangères. Trois étapes : **adhésion → absorption (= ingestion) → digestion** (microbe enfermé dans un **phagosome**, digéré par les **vésicules digestives**). Elle est **non spécifique** car elle s''exerce **quelle que soit la nature de l''agent pathogène**. **Réussite** : les bactéries deviennent méconnaissables, digérées dans le phagocyte. **Échec** : des bactéries à multiplication très rapide résistent et tendent à envahir l''organisme — c''est l''infection généralisée ou **septicémie**. **L''immunité naturelle** = défense non spécifique assurée par la **peau, les muqueuses, l''inflammation et la phagocytose**.
- **Immunité spécifique — le fait de départ.** Certaines maladies **ne récidivent pas** : un enfant qui a eu la **rougeole** (ou la **varicelle**) ne la contractera plus — il a **acquis une immunité**.
- **La vaccination — les découvertes.** **Jenner, 1798** : la **variole** est mortelle dans **50 %** des cas ; les fermières ayant eu la **vaccine** (variole bovine **bénigne**) y échappent → hypothèse qu''**une maladie bénigne peut protéger contre une maladie mortelle** ; l''enfant inoculé résiste, l''**année suivante**, au pus de varioleux. **Pasteur, 1879** : le **choléra des poules** est dû à un **bacille** ; le **lot A** (**témoin**, sans traitement) meurt de la culture fraîche, le **lot B** (pré-injecté avec la **culture vieillie**) survit → les microbes vieillis sont **atténués**. **Ramon, 1923** : l''**anatoxine** diphtérique. **Principe** : un germe pathogène a **deux caractères indépendants** — il est pathogène **et** capable d''induire une réponse immunitaire. Un **vaccin** est un germe ou une toxine **atténué(e)** qui permet d''acquérir une immunité ; la **vaccination** est un traitement **préventif** par injection d''une **forme non pathogène** — une **application de la mémoire immunitaire**.
- **Les expériences des souris.** **Toxine tétanique** = toxine sécrétée par le bacille tétanique ; **anatoxine tétanique** = la même toxine **rendue inactive par la chaleur et le formol**. **A** (toxine) → **mort** : la toxine est bien mortelle (témoin). **B** (anatoxine, puis toxine) → **survie** deux fois : l''anatoxine **immunise**. **C** (anatoxine, puis **toxine diphtérique**) → **mort** : la protection ne vaut que contre son agent → **spécificité**. **D** (anatoxine) → survie ; son **sérum** injecté à **E** protège E contre la toxine → l''immunité est **transférable par le sérum**. **F**, qui reçoit le sérum de la souris **témoin T** non immunisée, **meurt** → c''est bien l''immunisation de D, et non le sérum en tant que liquide, qui protège.
- **Antigène et anticorps.** **Antigène** : corps étranger capable d''**induire une réponse immunitaire**. **Anticorps** : substances contenues dans le **sérum** et responsables de l''**immunité acquise**, dirigées contre un antigène, qu''elles **neutralisent**. **Immunité acquise** : immunité acquise à la suite d''un contact naturel avec un antigène grâce à la fabrication d''**anticorps spécifiques** dirigés contre cet antigène.
- **Les trois propriétés de l''immunité acquise.** **Mémoire** : la **réponse primaire** (1ère infection) est **lente, de faible intensité et de courte durée** ; la **réponse secondaire** (2ème infection par le **même** agent) est **rapide, forte et durable**. **Spécificité** : le système reconnaît un microbe déterminé et développe une réponse dirigée contre lui, **inefficace contre un autre microbe**. **Diversité** : il développe une réponse spécifique **contre chaque microbe** introduit.
- **La sérothérapie.** **Von Behring, 1890** : des substances anti-diphtériques existent dans le sang des animaux **guéris**. **Roux, 1894** : on **vaccine un cheval** par des **doses croissantes et répétées** de toxine diphtérique de virulence croissante → **grandes quantités d''anticorps** dans son sang → le **sérum** de ce cheval **hyper-immunisé**, transféré à des malades, les **guérit**. **Sérothérapie** : méthode **curative** fondée sur l''injection de sérums contenant des **anticorps** destinés à **neutraliser** un agent pathogène donné (venin du scorpion, toxine tétanique…). **Sérum** : partie liquide, contenant des anticorps, libérée lors de la **coagulation du sang**.
- **Vaccination vs sérothérapie — le tableau.** **But** : préventive, sur personnes **saines** / curative, sur organismes **atteints** ou risquant de l''être. **Immunité** : **active**, anticorps **élaborés par l''organisme vacciné** / **passive**, anticorps **élaborés par un autre organisme** immunisé. **Durée d''action** : **tardive et de longue durée** / **immédiate et de courte durée**. La logique : le vacciné fabrique lui-même ses anticorps (donc lent, mais durable grâce à la mémoire) ; celui qui reçoit un sérum reçoit des anticorps tout faits (donc immédiat, mais sans mémoire — la protection part avec eux). D''où les **rappels** (tétanos : tous les **5 ans**).', 6, '{"code":"225104P00","pages":"117-134","pageNumbers":[117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('e5983da0-45a8-5f71-b0e8-06496a06800b', 'svt-1ere-sec', 'Étude d''un site géologique — lire l''histoire de la Terre dans une falaise', 'La sortie géologique comme méthode (localisation, relief, nature des roches, récolte d''échantillons, identification des fossiles, carnet d''observations) et deux sites de terrain : la falaise de Sidi Mhareb à Monastir (deux séries non parallèles, pendage de 40°, environ 20 m) et la falaise de Ras Amer à Kerkenah (trois strates, 2 m). Le vocabulaire officiel : strate, affleurement, roche, minéral, cristal, fossiles, falaise, pendage, oolithe, roche poreuse, quartz, ciment, faciès, bassin sédimentaire, lagune, silt. L''étude physico-chimique complète du calcaire oolithique : oolithes de 0,5 à 2 mm et ciment, dureté, porosité et perméabilité (échelle de l''échantillon vs échelle du terrain), action de la chaleur (dégagement de CO2 et chaux vive CaO), action de l''acide chlorhydrique (effervescence, test de reconnaissance du calcaire), solubilité, réactions de dissolution et de précipitation entre carbonate de calcium CaCO3 et bicarbonate de calcium Ca(HCO3)2, lapiez, grottes, stalactites et stalagmites ; l''histoire de sa formation (mers chaudes de 22 à 31 °C, golfe de Gabès, cimentation). Les autres roches calcaires : quartzeux (croûte, villafranchien), coquiller ou fossilifère et lumachelle, à nummulites (éocène moyen), à globigérines. Les principes de reconstitution : principe des causes actuelles, principe de superposition, granoclassement des côtes vers le large, faciès et sa variation, transgression, régression, cycle sédimentaire. Les déformations tectoniques : faille (déformation cassante) et pli (déformation souple, anticlinal, synclinal). L''échelle des temps géologiques (ères, systèmes, étages, âges absolus) et l''aperçu de l''histoire géologique de la Tunisie du primaire au quaternaire ; l''érosion différentielle et le modelé ; la reconstitution de l''histoire géologique des deux sites et la notion de séries discordantes', '# ⚔️ Étude d''un site géologique — lire l''histoire de la Terre dans une falaise

> 💡 «Une falaise de 20 mètres à Monastir. Pour un touriste, c''est un mur. Pour toi, à partir d''aujourd''hui, c''est un livre — et tu vas apprendre à le lire de bas en haut.»

La Terre a une histoire : les événements géologiques, la genèse des roches, la formation des chaînes de montagne, le plissement des strates, la **transgression**, la **régression**… se déroulent dans des intervalles de temps qui se mesurent en **millions d''années**. Cette histoire se lit dans les **sites géologiques** tels une carrière, une tranchée, une mine, une falaise, le lit d''un oued… En observant les roches, leur disposition, leur succession, en étudiant leur composition et les **fossiles** qu''elles renferment, on peut en déduire plusieurs informations qui permettent de **reconstituer l''histoire géologique** du site étudié, et souvent celle de la région où il se trouve.

## 🎒 La sortie géologique

La sortie géologique a pour but d''**observer des roches du sous-sol d''un site** et de **chercher des informations permettant de retracer l''histoire géologique de sa formation**. Sur le terrain, le géologue : localise le site sur une carte et trace son itinéraire · décrit le **relief** · vérifie la **nature des roches** et ramasse quelques échantillons · cherche des **fossiles** et tente de les identifier · prend des photos des affleurements · note sur son **carnet** les observations utiles.

Le vocabulaire de base, à connaître mot à mot :

- **Strate** : couche de terrain sédimentaire.
- **Affleurement** : strate qui devient **visible en surface**, soit naturellement sous l''action des agents d''érosion, soit sous l''action de l''homme.
- **Roche** : assemblage de **minéraux** formés naturellement. Les roches forment les terrains de l''écorce terrestre.
- **Minéral** : espèce chimique naturelle composant une roche, caractérisée par ses propriétés physico-chimiques et cristallographiques.
- **Cristal d''une roche** : matière naturelle solide caractérisée par une **forme géométrique**. La plupart des cristaux naturels sont en fait des **polycristaux**, c''est-à-dire un assemblage de cristaux de tailles et de formes différentes.
- **Fossiles** : restes ou empreintes d''organismes, ou organismes entiers, **conservés dans des dépôts sédimentaires**, ayant vécu à une époque du temps géologique.
- **Falaise** : relief en pente abrupte situé sur la côte.
- **Pendage** : **inclinaison** d''une couche plissée par rapport à l''horizontale.

## 🏖️ Site 1 — la falaise de Sidi Mhareb à Monastir

La région de Monastir est située à une vingtaine de km au S.SE de Sousse : une presqu''île triangulaire, bordée par la mer au Nord et à l''Est, limitée à l''Ouest par une vaste **sebkha**. Son littoral Nord montre, sur **5 km**, une falaise abrupte haute de **quelques mètres à une vingtaine de mètres**.

La falaise, de surface plate et d''environ **20 m** de haut, montre un sous-sol formé de **deux séries non parallèles**, surmonté d''un **sol de faible épaisseur** portant des plantes. Dans chaque série, les roches sont disposées en couches parallèles : les **strates**.

| Série                | Roches                                                                                                                                                      | Fossiles                                 | Géométrie                    |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- | ---------------------------- |
| **Série supérieure** | une couche de **calcaire oolithique**, riche en fossiles                                                                                                    | **strombes**, **cardiums**               | **horizontale**              |
| **Série inférieure** | couches d''**argiles vertes et rouges**, bancs de **grès brun et dur**, couches fines de **lignite** (charbon fossile), plaques de **gypse** dans les fentes | **ostréas**, **pectens**, **turitelles** | **inclinée, pendage de 40°** |

**La morphologie différentielle** — retiens cette observation, elle reviendra : dans la série supérieure, le calcaire est **fissuré**, avec des parties **saillantes** et d''autres creusées ; dans la série inférieure, les bancs de **grès sont saillants** alors que les **argiles sont creusées** par des rigoles.

## 🏝️ Site 2 — la falaise de Ras Amer à Kerkenah

Les îles Kerkenah sont situées au Nord-Est du golfe de Gabès, à environ **20 km** de Sfax : deux grandes îles, six petites et une dizaine d''îlots, **161 km** de côtes, **15700 ha** dont **37 %** de sebkhas, un relief très plat — **90 %** des terres à moins de **5 m** d''altitude.

C''est une petite falaise de **2 m** de haut, montrant trois strates de roches sédimentaires, **du haut vers le bas** :

| Strate       | Roche                                                                              | Épaisseur      | Morphologie   |
| ------------ | ---------------------------------------------------------------------------------- | -------------- | ------------- |
| **Strate 1** | **calcaire coquiller** à lamellibranches et gastéropodes                           | **50 cm** env. | **saillante** |
| **Strate 2** | **argile silteuse** non cimentée à **Hélix**                                       | **80 cm** env. | **creusée**   |
| **Strate 3** | **calcaire oolithique** consolidé très conglomératique, lumachellique vers le haut | **80 cm** env. | **saillante** |

En suivant les strates le long de la falaise, leur **épaisseur reste constante** mais leur **altitude diminue progressivement** : elles ne sont pas parfaitement horizontales, elles sont **légèrement inclinées**.

# 🪨 Le calcaire oolithique, sous toutes les coutures

## 👁️ L''aspect

Le calcaire oolithique est une roche **compacte** de couleur **blanchâtre**, formée de **grains sphériques de 0,5 à 2 mm** : les **oolithes**, réunis par un **ciment**. L''observation microscopique d''une lame mince montre que chaque oolithe est formée d''**enveloppes successives de nature calcaire** entourant un **noyau** — un **grain de sable** ou un **fragment de coquille**. C''est la présence du ciment reliant les oolithes qui est responsable de l''aspect compact de la roche, d''où son utilisation dans la **construction**.

- **Oolithe** : petite sphère de la taille du **mm**, formée d''enveloppes successives de calcaire autour d''un **noyau** qui peut être un grain de **quartz** ou un grain de calcaire.
- **Quartz** : minéral, constituant principal du **sable**. — **Ciment** : matière qui **soude, entre eux, les éléments d''une roche**.
- **Roche poreuse** : roche contenant des **pores** (= des vides entre les éléments composant la roche).

## 🔬 Les propriétés physiques

- **Dureté** : le calcaire oolithique **n''est pas rayé par l''ongle** et **ne raye pas le verre** : c''est une roche **dure**. Cette propriété lui offre une **résistance aux agents de l''érosion**, ce qui explique que, dans la nature, les affleurements calcaires ont une forme **saillante**.
- **Porosité et perméabilité** : verse quelques gouttes d''eau dans un creux ménagé dans un échantillon. L''eau **pénètre** dans la roche mais **ne suinte pas de l''autre côté** : le calcaire oolithique **emmagasine** de l''eau mais **ne se laisse pas traverser**. C''est une roche **poreuse et imperméable**.

> ⚠️ La nuance la plus piégeuse du chapitre : le calcaire oolithique, **imperméable à l''échelle de l''échantillon**, est **perméable dans la nature** à cause des **fissures** qu''il présente. Une même roche, deux réponses — tout dépend de l''échelle à laquelle on l''observe. Retiens le couple : _poreux ≠ perméable_. Poreux, c''est **contenir des vides** ; perméable, c''est **se laisser traverser**.

## 🧪 Les propriétés chimiques

**Action de la chaleur.** Porté à haute température, le calcaire oolithique dégage un gaz qui **trouble l''eau de chaux** : c''est le **dioxyde de carbone (CO2)**. Le calcaire se transforme en une substance friable et blanchâtre, la **chaux vive** (ou **oxyde de calcium : CaO**). On en déduit que le calcaire oolithique est essentiellement constitué de **carbonate de calcium (CaCO3)**. Cette réaction est employée à grande échelle dans les **fours à chaux** (fabrication d''eau de chaux, de ciment…).

**Action de l''acide chlorhydrique.** Une goutte d''acide chlorhydrique déposée sur un échantillon produit une **effervescence** due à un dégagement de **CO2**. L''effervescence, qui signale la réaction de l''acide avec le carbonate de calcium, est **couramment employée pour déceler la présence de calcaire dans une roche** — c''est **le** test de reconnaissance.

**Solubilité.** Dans de l''**eau distillée** : aucun changement — le calcaire oolithique est **insoluble dans l''eau pure**. Dans de l''**eau chargée en dioxyde de carbone** : le volume de l''échantillon **diminue** — il est **soluble dans l''eau chargée en CO2**.

::: figure Une seule réaction, lue dans les deux sens : le CO2 en plus dissout le calcaire, le CO2 en moins le fait précipiter. Tout le modelé calcaire tient dans ce va-et-vient
<svg viewBox="0 0 360 180">
<rect x="88" y="18" width="184" height="30" rx="6" fill="#0f6e56" opacity="0.14" stroke="#0f172a" stroke-width="1.6"/>
<rect x="88" y="132" width="184" height="30" rx="6" fill="#7c3aed" opacity="0.14" stroke="#0f172a" stroke-width="1.6"/>
<path d="M120 50 Q76 90 120 130" fill="none" stroke="#0f172a" stroke-width="2.2"/>
<path d="M114 122 L121 133 L124 120 Z" fill="#0f172a"/>
<path d="M240 130 Q284 90 240 50" fill="none" stroke="#0f172a" stroke-width="2.2"/>
<path d="M246 60 L239 49 L236 62 Z" fill="#0f172a"/>
<g font-size="11" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="180" y="30" text-anchor="middle" fill="#0f172a">Calcaire insoluble</text>
<text x="180" y="43" text-anchor="middle" fill="#0f6e56">CaCO3</text>
<text x="180" y="144" text-anchor="middle" fill="#0f172a">Bicarbonate de calcium</text>
<text x="180" y="157" text-anchor="middle" fill="#7c3aed">Ca(HCO3)2</text>
</g>
<g font-size="10" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="60" y="86" text-anchor="middle" fill="#0f6e56">dissolution</text>
<text x="60" y="99" text-anchor="middle" fill="#0f172a">+ CO2 + H2O</text>
<text x="302" y="86" text-anchor="middle" fill="#7c3aed">précipitation</text>
<text x="302" y="99" text-anchor="middle" fill="#0f172a">− CO2</text>
</g>
<g font-size="8.5" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">
<text x="60" y="114" text-anchor="middle" fill="#94a3b8">lapiez, grottes</text>
<text x="302" y="114" text-anchor="middle" fill="#94a3b8">stalactites</text>
</g>
</svg>
:::

Les deux réactions, telles que le manuel les écrit :

$$ CaCO3 + CO2 + H2O → Ca(HCO3)2 $$

$$ Ca(HCO3)2 → CaCO3 + CO2 + H2O $$

**La dissolution, dans la nature.** Les eaux chargées en dioxyde de carbone — donc **légèrement acides** — dissolvent le calcaire qui affleure et l''emportent sous forme de **bicarbonate de calcium soluble**. Ce phénomène est à l''origine de l''**élargissement des fissures** observées dans les strates calcaires : en surface se forment des saillies séparées par des sillons, un **lapiez** ; en profondeur, les fissures élargies donnent des cavités — **avens**, **grottes**.

**La précipitation.** Chauffe la solution de bicarbonate de calcium : le liquide se trouble, des particules de carbonate de calcium se sont formées. Dans une solution de bicarbonate de calcium, du calcaire se forme par **précipitation dès que le milieu s''appauvrit en dioxyde de carbone** — la réaction **inverse** de la dissolution. C''est aussi ce qui dépose la croûte calcaire dans une bouilloire. Dans la nature, le calcaire se dépose ainsi : dans les **sources à eau riche en calcaire** ; au **plafond des grottes** sous forme d''aiguilles tombantes, les **stalactites** ; au **plancher des grottes** sous forme d''aiguilles montantes, les **stalagmites**.

## 🐚 Ce que les fossiles racontent

Les fossiles retrouvés dans le calcaire oolithique correspondent à des **mollusques marins** : lamellibranches et gastéropodes (strombe). Ce sont des **coquilles souvent brisées** et des **moules externes et internes**. Parmi eux, des formes évoquant des mollusques actuels : les **cérithes** et les **strombes**, qui vivent dans les **mers peu profondes** (zones littorales). Les strombes sont caractéristiques des **mers chaudes** ; ils existent depuis le **début de l''ère quaternaire**.

Et les oolithes elles-mêmes ? Il s''en forme **actuellement** dans le **golfe de Gabès** et d''autres mers peu profondes et chaudes (**22 à 31 °C**), très riches en bicarbonate de calcium venu de l''altération chimique des roches calcaires. Quand la teneur en CO2 de ces eaux **diminue** — par **absorption du CO2 par les végétaux marins verts** ou par **évaporation** —, il y a **précipitation de carbonate de calcium autour de grains de sable ou de fragments de coquilles** que l''**agitation de l''eau** met en suspension. Enfin, les oolithes sont fortement liées par un **ciment carbonaté**, ce qui témoigne d''une **cimentation postérieure à leur dépôt**.

Le **faciès d''une roche** est l''ensemble de ses **caractères paléontologiques** (ses fossiles) et **pétrographiques** (caractères en relation avec sa nature), qui renseignent sur les **conditions et le milieu de sa formation**. Le calcaire oolithique a donc un **faciès marin peu profond** : mer peu profonde (**13 m au maximum**), chaude, **agitée** — les coquilles brisées le prouvent — et fortement chargée en bicarbonate de calcium. Et l''amphithéâtre d''**El Jem** est construit de calcaire oolithique.

## 🧱 Les autres roches calcaires

| Roche                                                 | Où / âge                                                                                                   | Caractères                                                                                                                                   | Faciès                 |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| **Calcaire quartzeux** (ou calcaire de la **croûte**) | le long de la **côte Est**, d''âge **villafranchien**, où la côte Est était presque entièrement **émergée** | rose saumon, **dure**, renferme **quartz et gypse** → **hétérogène** ; imperméable en échantillon, perméable en grand ; **origine chimique** | —                      |
| **Calcaire coquiller** (ou fossilifère)               | **Jebel Abderrahman** (Menzel Bouzelfa) : calcaire à **pecten**, déposé au **miocène moyen**               | coquilles entières de lamellibranches et gastéropodes marins, sections, moules ; quand les fossiles sont **très nombreux** → **lumachelle**  | **marin peu profond**  |
| **Calcaire à nummulites**                             | **ouest et centre** (Kef, Makthar…), **éocène moyen**                                                      | **tests calcaires de nummulites** — coquilles de **protozoaires géants** du groupe des **foraminifères**                                     | **mer assez profonde** |

> 📖 Deux formulations pour un même faciès — ne les prends pas pour une contradiction. Le manuel décrit le calcaire à nummulites comme un faciès de **« mer assez profonde »** (p.150), tandis que son tableau des faciès (p.152, plus bas) le range dans la colonne **« marin peu profond »**. Les deux disent la même chose, à condition de voir que le tableau compte **trois** colonnes marines : **profond** (globigérines) · **peu profond** (nummulites) · **côtier** (calcaire coquiller). Les nummulites se déposent donc **plus au large que le calcaire coquiller, mais moins que les globigérines** : « assez profonde » se lit **par rapport à la côte**, « peu profond » **par rapport au large**. Retiens la **position dans la série**, pas l''adjectif.

# 📖 Reconstituer l''histoire d''un site

## 🔑 Les deux principes

**Le principe des causes actuelles** : pour reconstituer l''histoire d''un terrain sédimentaire, on suppose que **les phénomènes géologiques anciens sont analogues à ceux qui se passent actuellement**. C''est ce principe qui autorise tout le reste — si les oolithes se forment aujourd''hui dans le golfe de Gabès à 22–31 °C, alors celles de Kerkenah se sont formées dans les mêmes conditions.

**Le principe de superposition** : une strate est **plus récente que celle qu''elle recouvre** et **plus ancienne que celle qui la recouvre**. C''est la datation **relative** : on classe les événements sans mettre de chiffre dessus.

## 🌊 La sédimentation

Sous l''action de l''érosion, des matériaux de taille différente se détachent des roches : les **matériaux détritiques**. Ils sont **transportés** par l''eau ou le vent, puis se **déposent** dans des **bassins sédimentaires** — continentaux (sur terre, au fond d''une rivière ou d''un lac), **lagunaires** ou **marins**. La sédimentation aboutit à une couche **horizontale** de sédiments renfermant souvent des cadavres d''organismes. Si elle se poursuit pendant des millions d''années, elle donne des couches superposées, parallèles et horizontales, qui deviendront après **consolidation** des **strates** contenant des fossiles.

- **Bassin sédimentaire** : endroit dans lequel se déposent des matériaux appelés alors **sédiments**.
- **Lagune** : bassin côtier peu profond rempli d''eau de mer et **séparé de la mer par un haut fond**. — **Silt** : mélange de **sable et d''argile**.

Les matériaux qui parviennent à la mer se déposent **selon leur taille** — c''est le classement à connaître :

::: figure Des côtes vers le large, les dépôts vont du plus grossier au plus fin : c''est la taille du grain qui trahit la distance à la côte, et donc le milieu
<svg viewBox="0 0 360 150">
<path d="M14 40 L58 40 L58 62 L110 74 L200 88 L300 100 L346 106 L346 132 L14 132 Z" fill="#94a3b8" opacity="0.3" stroke="#0f172a" stroke-width="1.6"/>
<path d="M58 62 L110 74 L200 88 L300 100 L346 106 L346 44 L58 44 Z" fill="#0f6e56" opacity="0.16" stroke="none"/>
<line x1="58" y1="44" x2="346" y2="44" stroke="#0f6e56" stroke-width="2"/>
<g fill="#0f172a">
<circle cx="72" cy="58" r="5"/><circle cx="86" cy="61" r="4.4"/>
<circle cx="128" cy="72" r="3.2"/><circle cx="142" cy="75" r="3"/><circle cx="156" cy="73" r="2.8"/>
<circle cx="206" cy="86" r="1.8"/><circle cx="218" cy="88" r="1.6"/><circle cx="230" cy="87" r="1.7"/><circle cx="242" cy="89" r="1.5"/>
<circle cx="292" cy="98" r="0.9"/><circle cx="304" cy="99" r="0.9"/><circle cx="316" cy="100" r="0.9"/><circle cx="328" cy="101" r="0.9"/><circle cx="340" cy="102" r="0.9"/>
</g>
<g font-size="9" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="30" y="30" text-anchor="middle" fill="#0f172a">continent</text>
<text x="310" y="34" text-anchor="middle" fill="#0f6e56">mer — le large</text>
<text x="78" y="122" text-anchor="middle" fill="#0f172a">blocs, galets</text>
<text x="142" y="122" text-anchor="middle" fill="#0f172a">graviers</text>
<text x="224" y="122" text-anchor="middle" fill="#0f172a">sables</text>
<text x="314" y="122" text-anchor="middle" fill="#0f172a">vases</text>
</g>
</svg>
:::

De la côte vers le large : **blocs, galets, graviers, sables grossiers puis fins, et enfin des vases** (boues de très fines particules). Par ailleurs, la mer abrite une faune et une flore qui **changent avec la profondeur**. On comprend donc que le **faciès** d''une roche — ses composants et le type de fossiles qu''elle contient — est en **étroite relation avec la nature du milieu de sédimentation**.

Voici le tableau des faciès, l''outil qui te servira à chaque exercice :

|              | **Marin profond**       | **Marin peu profond**                                  | **Marin côtier ou néritique**                                | **Lagunaire**                              | **Continental — terre émergée**                                    | **Continental — eau douce**                       |
| ------------ | ----------------------- | ------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------ | ------------------------------------------------------------------ | ------------------------------------------------- |
| **Roches**   | calcaire à globigérines | calcaire à nummulites ; argiles bleues, rouges, vertes | roches conglomératiques ; grès et sable ; calcaire coquiller | **gypse**, **sel gemme**                   | sables, silts                                                      | sables, argile, calcaires                         |
| **Fossiles** | tests de globigérines   | tests de nummulites                                    | coquilles de mollusques                                      | coquilles de mollusques, exemple : cardium | coquilles d''**escargots**, bois silicifiés, empreintes de feuilles | coquilles de mollusques d''**eau douce** (limnées) |

## 🌊 Transgression, régression, cycle

Dans un site géologique, les strates superposées **n''ont pas le même faciès**. Une couche de **faciès marin** indique que **la mer recouvrait la région** au moment de sa sédimentation ; une couche de **faciès continental** montre que la région **n''était pas couverte** par la mer au moment de son dépôt.

- Quand la mer **envahit** une région, on dit qu''il y a **transgression**.
- Quand elle **se retire**, on dit qu''il y a **régression**.
- Un **cycle sédimentaire** est la période qui s''écoule **entre une transgression et une régression**.

La transgression et la régression **modifient profondément les conditions de la sédimentation** : elles expliquent le **changement de faciès des strates** dans un site. Autrement dit — et c''est le raisonnement clé du chapitre — **un changement de faciès entre deux strates superposées est la trace d''un mouvement de la mer**.

## 💥 Les déformations tectoniques

Après un grand tremblement de terre, on observe des **cassures** au niveau des strates : au cours des temps géologiques, des déformations ont affecté les couches sédimentaires **après leur dépôt**. On en distingue **deux sortes**.

::: figure Deux façons pour une couche de réagir : elle casse et un compartiment s''abaisse — c''est la faille ; ou elle ondule sans rompre — c''est le pli, avec ses bosses (anticlinaux) et ses creux (synclinaux)
<svg viewBox="0 0 360 170">
<g stroke="#0f172a" stroke-width="1.4">
<rect x="16" y="52" width="60" height="14" fill="#0f6e56" opacity="0.3"/>
<rect x="16" y="66" width="60" height="14" fill="#94a3b8" opacity="0.4"/>
<rect x="16" y="80" width="60" height="14" fill="#7c3aed" opacity="0.25"/>
<rect x="94" y="72" width="60" height="14" fill="#0f6e56" opacity="0.3"/>
<rect x="94" y="86" width="60" height="14" fill="#94a3b8" opacity="0.4"/>
<rect x="94" y="100" width="60" height="14" fill="#7c3aed" opacity="0.25"/>
</g>
<line x1="76" y1="46" x2="94" y2="120" stroke="#dc2626" stroke-width="2.4"/>
<path d="M100 66 L100 78" stroke="#dc2626" stroke-width="2"/>
<path d="M96 76 L100 84 L104 76 Z" fill="#dc2626"/>
<g stroke="#0f172a" stroke-width="1.4" fill="none">
<path d="M200 92 Q236 52 272 92 Q308 132 344 92" stroke="#0f6e56" stroke-width="3"/>
<path d="M200 106 Q236 66 272 106 Q308 146 344 106" stroke="#94a3b8" stroke-width="3"/>
<path d="M200 120 Q236 80 272 120 Q308 160 344 120" stroke="#7c3aed" stroke-width="3"/>
</g>
<g fill="none" stroke="#dc2626" stroke-width="1.4">
<path d="M236 52 L236 40"/><path d="M308 132 L308 146"/>
</g>
<g font-size="10" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
<text x="85" y="24" text-anchor="middle" fill="#dc2626">FAILLE</text>
<text x="272" y="24" text-anchor="middle" fill="#0f172a">PLI</text>
</g>
<g font-size="8.5" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">
<text x="85" y="36" text-anchor="middle" fill="#0f172a">déformation cassante</text>
<text x="272" y="36" text-anchor="middle" fill="#0f172a">déformation souple</text>
<text x="124" y="132" text-anchor="middle" fill="#dc2626">compartiment abaissé</text>
<text x="236" y="34" text-anchor="middle" fill="#dc2626">anticlinal</text>
<text x="308" y="158" text-anchor="middle" fill="#dc2626">synclinal</text>
</g>
</svg>
:::

- Une **faille** est une **cassure** plus ou moins profonde des couches d''un terrain, **accompagnée d''un déplacement des compartiments** séparés par la cassure. C''est une **déformation cassante**. On s''aperçoit de son existence parce que les couches, à l''origine continues, sont **décalées** de part et d''autre de la cassure : un compartiment est **abaissé**.
- Les **plis** sont des **ondulations** des couches de terrain, avec une alternance de parties **creuses**, les **synclinaux**, et de parties **bombées**, les **anticlinaux**. Ce sont des **déformations souples**, qui affectent les couches **profondes** de l''écorce terrestre et **expliquent la formation des chaînes de montagne**.

> 🗡️ Le lien à retenir absolument : lorsque le plissement affecte des couches sédimentaires se trouvant dans un **bassin marin**, le **soulèvement** qu''il provoque est **accompagné d''une régression**. Plissement → soulèvement → la mer se retire. C''est la chaîne de causes qui revient dans toutes les reconstitutions.

## ⏳ Les temps géologiques

Pour dater les événements géologiques, le géologue a effectué un découpage dans l''histoire géologique. Les grandes divisions sont les **ères** ; chaque ère est subdivisée en **systèmes**, eux-mêmes subdivisés en **étages**.

| Ère             | Période / époque                                                                                | Âge absolu (millions d''années) |
| --------------- | ----------------------------------------------------------------------------------------------- | ------------------------------ |
| **Quaternaire** | Holocène (Flandrien)                                                                            | 0 : actuel                     |
| **Quaternaire** | Pléistocène (Néotyrrhénien, Tyrrhénien, Eutyrrhénien, Sicilien, Calabrien = **Villafranchien**) | de **2** à 0                   |
| **Tertiaire**   | Pliocène                                                                                        | de **5** à 2                   |
| **Tertiaire**   | Miocène (Pontien, Vindobonien)                                                                  | de **23** à 5                  |
| **Tertiaire**   | Oligocène                                                                                       | de **35** à 23                 |
| **Tertiaire**   | **éocène**                                                                                      | de **55** à **35**             |
| **Secondaire**  | Crétacé                                                                                         | de **135** à **66**            |
| **Secondaire**  | Jurassique                                                                                      | de **205** à 135               |
| **Secondaire**  | Trias                                                                                           | de **245** à 205               |
| **Primaire**    | Permien · Carbonifère · Dévonien · Silurien · Ordovicien · Cambrien                             | de **540** à 245               |
|                 | Précambrien                                                                                     | jusqu''à **4500**               |

Chiffres à mémoriser dans l''ordre : **0 · 2 · 5 · 23 · 35 · 55 · 135 · 205 · 245 · 290 · 380 · 410 · 435 · 500 · 540 · 4500**.

> 📖 **Une note de vocabulaire, pour ne pas être surpris.** Dans le tableau du manuel, la colonne « Période » porte le mot **« Paléocène »** en face de l''oligocène et de l''éocène. L''échelle internationale, elle, nomme cette période le **Paléogène**, et réserve le nom de **Paléocène** à une **époque** bien précise : celle qui **précède immédiatement l''éocène**, d''environ **66 à 56 millions d''années**. Retiens donc les deux sens du mot : dans le tableau p.154, « Paléocène » désigne une **période** ; ailleurs — et au chapitre suivant — le **Paléocène** est l''**époque juste avant l''éocène**.
>
> **Et c''est là qu''il faut ouvrir l''œil** : cette époque **ne figure pas** dans le tableau du manuel, qui passe directement du crétacé à l''éocène. Le tableau donne donc l''impression que le crétacé s''arrête à 55 Ma — alors qu''il se termine en réalité à **66 Ma**, et que les **10 millions d''années manquantes (66 à 56 Ma), c''est justement le Paléocène**. Ce n''est pas un détail d''érudition : tu verras au chapitre suivant que la **base de la série phosphatée tunisienne s''est déposée précisément dans ce trou du tableau**. La borne qui compte pour l''examen reste celle du tableau, et elle est juste : **l''éocène va de 55 à 35 millions d''années**.

## 🇹🇳 La Tunisie, ère par ère

- **Ère primaire.** Les affleurements primaires datent du **permien** et se rencontrent au **Jebel Tebaga** (région de Mednine) : des strates riches en **fossiles marins** (mollusques, trilobites, fusilines…) — donc à cette époque, le **Nord de la plate-forme saharienne était couvert par la mer**.
- **Ère secondaire.** **Trias** : terrains au Sud (séries horizontales, essentiellement de **gypse**) et dans l''Atlas (gypse et argile au cœur de structures particulières, les **diapirs**) ; le gypse indique une **sédimentation lagunaire**. À la fin du trias, des **plissements** affectent les séries primaires et triasiques → naissance de la chaîne de **Tébaga de Mednine**. **Jurassique** : **grande transgression** recouvrant la Tunisie jusqu''au domaine de Tebaga — dépôts marins au Nord et au centre, lagunaires au Sud. **Crétacé** : au milieu, une zone continentale **émerge** au centre suite à une **régression** ; à la fin, une **nouvelle transgression** atteint le Sud tunisien.
- **Ère tertiaire.** **Éocène** : la mer s''est retirée ; la Tunisie comporte **deux domaines** — un domaine **continental** (plate-forme saharienne au Sud, **île de Kasserine** au centre) et un grand domaine **marin** où se déposent les **roches phosphatées et carbonatées** en bordure de l''île de Kasserine (sédimentation lagunaire), et les **calcaires à nummulites puis à globigérines** dans les mers relativement profondes. **Oligocène** : **régression importante**, liée à la reprise des mouvements tectoniques. **Miocène** : au début, une **transgression à l''Est**, en particulier dans le Sahel, dépose des grès calcaires et des argiles sableuses ; au miocène moyen, le Nord-Ouest est affecté par des mouvements tectoniques. **Pliocène** : la mer **régresse** et se localise près du littoral ; dépôts d''argile puis de sables et de grès très riches en fossiles. À la fin du pliocène, début quaternaire (**villafranchien**), la mer régresse et une **croûte calcaire** se dépose le long du littoral.
- **Ère quaternaire.** Au début (**Eutyrrhénien**), certaines régions — Cap Bon, **Monastir**, Sfax, les **îles Kerkenah**, Jerba — sont **recouvertes par la mer**. Cette **transgression** s''accompagne d''un dépôt de sédiments à **strombes** dans une mer **chaude et peu profonde**.

## 🧩 Les deux sites, racontés

**Sidi Mhareb** — l''histoire commence au **miocène** par la formation des strates de la **série inférieure**, de faciès **marin** : la région était donc couverte par la mer. À la **fin du miocène**, un **plissement** affecte les couches — d''où leur inclinaison à 40°. Conséquences : **soulèvement** de la série inférieure et **régression marine**, prolongée durant le pliocène et le villafranchien. L''**érosion** altère le sommet du pli, d''où son **aplanissement** — et c''est pourquoi la surface qui sépare les deux séries est horizontale alors qu''elle devrait présenter le sommet d''un **anticlinal**. Puis, au **tyrrhénien**, se forme la strate de **calcaire oolithique** de la série supérieure, de faciès marin : il y a donc eu **transgression**. La strate horizontale de cette série est en **contact anormal** avec les couches inclinées de la série inférieure : on dit que les deux séries sont **discordantes**. À la fin du tyrrhénien, la mer s''est retirée.

**Ras Amer** — l''histoire commence à l''**eutyrrhénien** par la strate 3 (calcaire oolithique et lumachellique), de faciès **marin** : la mer couvrait la région. Au **tyrrhénien**, la strate 2 (argile silteuse à **Hélix**, gastéropodes **terrestres**) se forme : faciès **continental de terre ferme** → **régression**. Au **néotyrrhénien**, la strate 1 (calcaire fossilifère), de faciès **marin peu profond** → **transgression**. On peut conclure qu''au quaternaire, **deux cycles sédimentaires** se sont produits sur ce site. À la fin du néotyrrhénien, des **déformations souples de faible intensité** ont affecté l''ensemble des strates, d''où leur **léger plissement**.

> 🗡️ Le petit escargot qui change tout : l''**Hélix** de la strate 2 est un gastéropode **terrestre**. Un seul fossile, et tout le milieu bascule du marin au continental — donc la mer s''était retirée. C''est exactement ce que veut dire « les fossiles sont des indices ».

## ⛰️ Pourquoi la falaise a cette forme

Reste une question restée en suspens depuis la première page : pourquoi le calcaire fait-il **saillie** et l''argile un **creux** ? Parce que les roches **ne résistent pas également** à l''érosion. Le calcaire, **compact et dur**, résiste à l''altération et à l''action des vagues : il forme des **saillies**. Le **silt**, fait d''argile et de sable, est **tendre et friable** : il s''altère plus facilement et se **creuse**. C''est l''**érosion différentielle** — le relief est un révélateur de la dureté des roches.

> 🏆 Septième quête franchie, héros : tu sais faire parler une falaise — lire ses strates de bas en haut, dater par superposition, reconnaître un faciès, repérer une discordance et remonter jusqu''au plissement. Reste une roche que la Tunisie exploite depuis 1885, et qui vaut de l''or : le phosphate.', '# 📜 Résumé : Étude d''un site géologique

- **Le vocabulaire de terrain.** **Strate** : couche de terrain sédimentaire. **Affleurement** : strate devenue visible en surface, naturellement par érosion ou sous l''action de l''homme. **Roche** : assemblage de minéraux formés naturellement. **Minéral** : espèce chimique naturelle composant une roche. **Cristal** : matière naturelle solide à forme géométrique (la plupart des cristaux naturels sont des **polycristaux**). **Fossiles** : restes ou empreintes d''organismes conservés dans des dépôts sédimentaires. **Falaise** : relief en pente abrupte situé sur la côte. **Pendage** : inclinaison d''une couche par rapport à l''horizontale. **Bassin sédimentaire** : endroit où se déposent les sédiments. **Lagune** : bassin côtier peu profond séparé de la mer par un haut fond. **Silt** : mélange de sable et d''argile.
- **Sidi Mhareb (Monastir)** — falaise d''environ **20 m**, **deux séries non parallèles**. **Série supérieure** : calcaire oolithique, **horizontale**, à **strombes** et **cardiums**. **Série inférieure** : argiles vertes et rouges, bancs de grès, lignite, plaques de gypse, **inclinée avec un pendage de 40°**, à **ostréas**, **pectens**, **turitelles**.
- **Ras Amer (Kerkenah)** — petite falaise de **2 m**, **trois strates** de haut en bas : **1** calcaire coquiller (**50 cm**, saillante) · **2** argile silteuse à **Hélix** (**80 cm**, creusée) · **3** calcaire oolithique lumachellique vers le haut (**80 cm**, saillante). Épaisseur constante, altitude décroissante, strates **légèrement inclinées**.
- **Le calcaire oolithique.** Roche **compacte**, blanchâtre, faite de grains sphériques de **0,5 à 2 mm** — les **oolithes** (enveloppes successives de calcaire autour d''un **noyau** : grain de sable/quartz ou fragment de coquille) — réunis par un **ciment**, d''où son usage en **construction** (l''amphithéâtre d''**El Jem**). **Dure** (non rayée par l''ongle, ne raye pas le verre) → résiste à l''érosion → **saillies**. **Poreuse et imperméable** à l''échelle de l''échantillon, mais **perméable dans la nature** à cause des **fissures**. ⚠️ **Poreux ≠ perméable** : poreux = contenir des vides ; perméable = se laisser traverser.
- **Chimie du calcaire.** **Chaleur** → dégagement de **CO2** (trouble l''eau de chaux) + **chaux vive** (oxyde de calcium, **CaO**) → la roche est essentiellement du **carbonate de calcium (CaCO3)** ; usage industriel : les **fours à chaux**. **Acide chlorhydrique** → **effervescence** (CO2) : c''est **le test de reconnaissance du calcaire**. **Solubilité** : **insoluble dans l''eau pure**, **soluble dans l''eau chargée en CO2**. Les deux réactions inverses : **CaCO3 + CO2 + H2O → Ca(HCO3)2** (**dissolution**) et **Ca(HCO3)2 → CaCO3 + CO2 + H2O** (**précipitation**, dès que le milieu **s''appauvrit en CO2**). Dissolution → élargissement des fissures → **lapiez** en surface, **avens** et **grottes** en profondeur. Précipitation → **stalactites** (aiguilles tombantes, au plafond) et **stalagmites** (aiguilles montantes, au plancher), sources à eau riche en calcaire.
- **Le faciès.** **Faciès d''une roche** : ensemble de ses caractères **paléontologiques** (fossiles) et **pétrographiques**, qui renseignent sur les **conditions et le milieu de sa formation**. Le calcaire oolithique a un faciès **marin peu profond** : strombes et cérithes vivent en mer peu profonde et chaude ; les **coquilles brisées** prouvent une mer **agitée** ; les oolithes se forment **actuellement** dans le **golfe de Gabès**, en mer peu profonde (**13 m au maximum**) et chaude (**22 à 31 °C**), riche en bicarbonate de calcium, quand la teneur en CO2 baisse (**absorption par les végétaux marins verts** ou **évaporation**) ; la **cimentation** est **postérieure au dépôt**.
- **Les autres calcaires.** **Quartzeux** (calcaire de la **croûte**) : côte Est, **villafranchien**, rose saumon, dur, quartz + gypse → **hétérogène**, **origine chimique**. **Coquiller / fossilifère** : coquilles de mollusques marins ; très nombreuses → **lumachelle** ; à **pecten** au Jebel Abderrahman, déposé au **miocène moyen** ; faciès **marin peu profond**. **À nummulites** : Kef, Makthar, **éocène moyen** ; les nummulites sont des **protozoaires géants** du groupe des **foraminifères** ; faciès de **mer assez profonde**.
- **Les deux principes.** **Principe des causes actuelles** : les phénomènes géologiques anciens sont **analogues à ceux qui se passent actuellement**. **Principe de superposition** : une strate est **plus récente que celle qu''elle recouvre**, plus ancienne que celle qui la recouvre.
- **La sédimentation.** Érosion → **matériaux détritiques** → transport par l''eau ou le vent → dépôt dans des bassins **continentaux, lagunaires ou marins** → couches horizontales → **consolidation** → strates. **Granoclassement**, des côtes vers le large : **blocs, galets, graviers, sables grossiers puis fins, vases**. **Tableau des faciès** : **marin profond** = calcaire à **globigérines** · **marin peu profond** = calcaire à **nummulites**, argiles bleues/rouges/vertes · **côtier ou néritique** = roches conglomératiques, grès et sable, calcaire coquiller · **lagunaire** = **gypse, sel gemme** (cardium) · **continental terre émergée** = sables, silts (coquilles d''**escargots**, bois silicifiés, empreintes de feuilles) · **continental eau douce** = sables, argile, calcaires (**limnées**).
- **Mouvements de la mer.** Faciès **marin** = la mer recouvrait la région ; faciès **continental** = elle ne la couvrait pas. **Transgression** = la mer envahit ; **régression** = la mer se retire ; **cycle sédimentaire** = la période entre une transgression et une régression. Un **changement de faciès** entre deux strates superposées est la trace d''un **mouvement de la mer**.
- **Les déformations tectoniques.** **Faille** : **cassure** accompagnée d''un **déplacement des compartiments** (déformation **cassante**) — on la repère aux couches **décalées**, un compartiment étant **abaissé**. **Pli** : **ondulation** des couches (déformation **souple**), avec les parties bombées = **anticlinaux** et les parties creuses = **synclinaux** ; les plissements affectent les couches profondes et **expliquent la formation des chaînes de montagne**. ⚠️ Plissement d''un bassin marin → **soulèvement** → **régression**.
- **Les temps géologiques.** **Ères** → **systèmes** → **étages**. Âges absolus, en millions d''années : **0 · 2 · 5 · 23 · 35 · 55 · 135 · 205 · 245 · 290 · 380 · 410 · 435 · 500 · 540 · 4500**. Quaternaire de **2** à 0 (Holocène ; Pléistocène : Néotyrrhénien, Tyrrhénien, Eutyrrhénien, Sicilien, Calabrien = **Villafranchien**) · Pliocène **5–2** · Miocène **23–5** · Oligocène **35–23** · **éocène 55–35** · Crétacé **135–66** · Jurassique **205–135** · Trias **245–205** · Primaire jusqu''à **540** · Précambrien jusqu''à **4500**. 📖 Note de vocabulaire : la colonne « Période » du tableau porte « **Paléocène** » ; l''échelle internationale nomme cette période le **Paléogène** et réserve **Paléocène** à l''**époque qui précède l''éocène**, d''environ **66 à 56 Ma**. ⚠️ Cette époque **ne figure pas** dans le tableau du manuel, qui passe du crétacé à l''éocène : le tableau laisse croire que le crétacé s''arrête à 55 Ma, alors qu''il finit à **66 Ma** — les **10 millions d''années manquantes (66 à 56 Ma), c''est le Paléocène**, et c''est là que s''est déposée la **base de la série phosphatée** (chapitre 8). La borne à retenir pour l''examen reste celle du tableau, et elle est juste : **éocène = 55 à 35 Ma**.
- **La Tunisie, ère par ère.** **Primaire** : permien au **Jebel Tebaga**, fossiles marins → mer sur le Nord de la plate-forme saharienne. **Trias** : gypse → sédimentation **lagunaire** ; **diapirs** dans l''Atlas ; plissement à la fin → chaîne de **Tébaga de Mednine**. **Jurassique** : **grande transgression**. **Crétacé** : régression au milieu (zone continentale au centre), transgression à la fin au Sud. **Éocène** : mer retirée, deux domaines — continental (plate-forme saharienne, **île de Kasserine**) et marin (roches **phosphatées** en bordure de l''île, calcaires à nummulites puis à globigérines au large). **Oligocène** : **régression importante**. **Miocène** : transgression à l''Est (Sahel). **Pliocène** : régression ; à la fin (**villafranchien**), **croûte calcaire** le long du littoral. **Quaternaire** (**Eutyrrhénien**) : transgression sur le Cap Bon, Monastir, Sfax, Kerkenah, Jerba, avec dépôt de sédiments à **strombes** en mer chaude et peu profonde.
- **Les deux reconstitutions.** **Sidi Mhareb** : série inférieure marine au **miocène** → **plissement** à la fin du miocène (pendage 40°) → **soulèvement** + **régression** (pliocène, villafranchien) → **érosion** qui **aplanit** le sommet du pli → **transgression** au **tyrrhénien** et dépôt du calcaire oolithique **horizontal** → les deux séries sont **discordantes** (contact anormal) → régression à la fin du tyrrhénien. **Ras Amer** : strate 3 marine à l''**eutyrrhénien** → strate 2 **continentale** à Hélix au **tyrrhénien** (**régression**) → strate 1 marine au **néotyrrhénien** (**transgression**) → **deux cycles sédimentaires** au quaternaire → léger plissement à la fin.
- **L''érosion différentielle.** Le calcaire, compact et **dur**, résiste aux vagues → **saillies** ; le **silt**, tendre et **friable**, s''altère → **creux**. Le relief révèle la dureté des roches.', 7, '{"code":"225104P00","pages":"139-163","pageNumbers":[139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('ce4eb157-d67d-5937-b357-93ffb1c7ecd3', 'svt-1ere-sec', 'Exploitation et gestion d''une roche à intérêt économique : le phosphate', 'Le phosphate comme ressource géologique à grand intérêt économique pour la Tunisie : production de plus de 8 millions de tonnes en 2000, premier exportateur mondial de triple superphosphate, second en acide phosphorique, troisième en diammonium phosphate, plus de 4500 familles vivant du secteur, bassins de Gafsa et du Kef. La découverte des phosphates tunisiens (Philippe Thomas, avril 1885, versant Nord de Jebel Thelja, Metlaoui) ; les gisements en mines souterraines et en carrières à ciel ouvert ; les critères de rentabilité (teneur en P2O5 supérieure ou égale à 25 %, BPL équivalent en phosphate tricalcique Ca3(PO4)2, teneurs de Metlaoui et de Kalaa Khasba, puissance des couches, accessibilité). L''étude physico-chimique de la roche phosphatée : aspect et friabilité selon le gisement, odeur fétide, observation à la loupe binoculaire (pellets, coprolithes, fossiles divers, grains de quartz), insolubilité, porosité et imperméabilité, action de l''acide, action de la chaleur. Les fossiles du phosphate (dents de requins, os de vertébrés marins, coquilles de mollusques, tests de microorganismes) comme indices de milieu et d''âge. L''origine double des phosphates, chimique (courants ascendants, HPO4-- combiné à Ca++, précipitation du phosphate de calcium) et organique (plancton concentrateur de phosphore, cadavres, milieu pauvre en oxygène, décomposition partielle par les bactéries), et la paléogéographie de l''époque (île de Kasserine, bassins fermés par des hauts-fonds, climat chaud et sec, évaporation) ; la datation de la série phosphatée et l''incohérence interne du manuel sur ce point. La chaîne industrielle : extraction, concassage, broyage, lavage à l''eau ou ventilation à l''air, minerai riche en P2O5, fabrication de l''acide sulfurique, acide phosphorique à 28 puis 54 % de P2O5, triple superphosphate à 47 % de P2O5, engrais NP, NPK et DAP. Les déchets et la pollution : phosphogypse (composition, stockage, effets sur la nappe phréatique, turbidité et asphyxie de la flore marine), gaz fluorés et soufrés (effets sur les végétaux, les animaux et l''Homme) ; les mesures de gestion rationnelle', '# ⚔️ Exploitation et gestion d''une roche à intérêt économique : le phosphate

> 💡 «Tu sais lire une falaise. Voici maintenant une roche qui a fondé des villes, nourri des champs sur trois continents, fait vivre des milliers de familles — et empoisonné des nappes d''eau. La dernière quête est celle du choix.»

Le phosphate constitue une ressource géologique d''un **grand intérêt économique** pour la Tunisie. La production s''élève à plus de **8 millions de tonnes** en l''année **2000**. La Tunisie est le **premier exportateur de triple superphosphate (T.S.P)** dans le monde, le **second en acide phosphorique** et le **3ème en diammonium phosphate (D.A.P)**. De ce secteur vivent plus de **4500 familles**. Les principaux gisements sont situés dans **deux bassins sédimentaires** : le **bassin de Gafsa** et celui du **Kef**. Mais l''exploitation du phosphate génère des **déchets solides et gazeux** qui causent des nuisances à la santé de l''Homme et à l''environnement.

Quatre questions ouvrent le chapitre : **où trouve-t-on des phosphates ? comment se présentent les gisements ? quelles sont les propriétés des roches phosphatées ? quelle est l''origine des phosphates ?**

## 🔍 Une découverte, en 1885

C''était en **avril 1885**, lors d''une prospection dans la région de **Metlaoui**, partie occidentale du sud du pays, que **Philippe THOMAS**, géologue **amateur** français, a découvert des couches puissantes de **phosphates de calcium** sur le **versant Nord de Jebel Thelja**.

## ⛏️ Où, et comment on l''extrait

| Type d''exploitation         | Sites nommés par le manuel                                                                             |
| --------------------------- | ------------------------------------------------------------------------------------------------------ |
| **Mines souterraines**      | Redeyef · Shib et M''rata · Moulares · **Kalaa Khasba** (région du Kef) · Jebel M''dhilla · Oum Lakhcheb |
| **Carrières à ciel ouvert** | Kef Shfaier · Kef Eddour · Jellabia · Redeyef · Moulares                                               |

**Autrefois**, l''exploitation se déroulait dans des **mines souterraines** : une extraction à la fois **dangereuse, coûteuse et peu rentable**. **À présent**, elle se déroule dans des **carrières à ciel ouvert**, pour **réduire les dangers** liés à l''extraction et les **coûts**, tout en **augmentant la capacité de production**. Le résultat se lit dans les chiffres : la production est passée de **6 millions de tonnes** à la fin des années **1980** à plus de **8 millions de tonnes en 2000**.

## 💰 Quand un gisement est-il exploitable ?

Les gisements de phosphate ne sont exploitables que lorsque la **teneur en P2O5 est ≥ à 25 %**. La teneur s''exprime aussi par l''équivalent en **phosphate tricalcique Ca3(PO4)2**, appelé **BPL**. La teneur du phosphate naturel tunisien exprimée en BPL est de **56 % à 59 % à Metlaoui** et de **60 à 68 % à Kalaa Khasba**.

> 🗡️ Mais la teneur ne fait pas tout. Quand on demande pourquoi telle couche est exploitée et telle autre non, il faut **trois critères**, pas un : sa **teneur** en P2O5 (rentabilité), sa **puissance** — c''est-à-dire son épaisseur —, et sa **situation proche de la surface**, qui la rend facilement **accessible**. Une couche très riche mais mince et profonde ne vaut rien.

## 🪨 La roche phosphatée, sous toutes les coutures

**L''aspect.** La roche est **compacte**. Mais tout dépend du gisement : un échantillon de **Kef Shfaier** est **friable**, un échantillon de **Kalaa Khasba** est **non friable** — ses éléments phosphatés sont liés par un **ciment** qui retient les grains.

**L''odeur.** Les roches phosphatées sont caractérisées par leur **odeur fétide**. Retiens-la : c''est un indice, pas un détail.

**À la loupe binoculaire**, un échantillon pulvérisé montre des grains d''aspect différents :

- des **pellets** : grains phosphatés de forme **sphérique ou ovoïde** ;
- des **coprolithes** : grains **cylindriques** de **quelques millimètres à 2 cm** environ — ils correspondent à des **restes d''excréments d''organismes** ;
- des **fossiles divers** (fragments de coquilles, dents de requins…) ;
- des **grains de quartz**.

**Les tests**, à connaître avec leur conclusion :

| Test                     | Manipulation                                                   | Observation                                           | Conclusion                             |
| ------------------------ | -------------------------------------------------------------- | ----------------------------------------------------- | -------------------------------------- |
| **Solubilité**           | un échantillon de **1 cm3** dans **10 cm3 d''eau pure**, agiter | aucune modification                                   | la roche est **insoluble**             |
| **Porosité**             | verser un peu d''eau dans un creux ménagé dans la roche         | elle est **rapidement absorbée**                      | la roche est **poreuse**               |
| **Perméabilité**         | verser encore de l''eau                                         | l''eau **ne traverse pas** la roche                    | la roche est **imperméable**           |
| **Action de l''acide**    | déposer une goutte d''acide                                     | **certaines** roches font effervescence, d''autres non | la roche **peut contenir du calcaire** |
| **Action de la chaleur** | chauffer un échantillon dans un tube à essai                   | dégagement de **vapeur d''eau** et **odeur fétide**    | —                                      |

> ⚠️ Le test de l''acide est le plus subtil du chapitre. Sur un calcaire, l''effervescence prouve **qu''il y a du calcaire**. Sur une roche phosphatée, **certaines** font effervescence et d''autres non : on en déduit seulement que la roche **peut** contenir du calcaire — l''effervescence ne prouve **jamais** la présence de phosphate. Une conclusion ne vaut que ce que vaut le protocole qui la produit.

**Les fossiles.** Le phosphate en renferme souvent : les **dents de requin** sont les plus fréquentes. On rencontre parfois un **squelette entier ou des os de divers vertébrés marins**, et des **coquilles de mollusques**. L''observation microscopique de lames minces révèle de nombreux **tests de microorganismes**. Tous ces fossiles appartiennent à des animaux qui vivaient dans une **mer peu profonde**.

## ⏳ Quel âge, exactement ?

Le manuel écrit, dans son bilan : « ces fossiles sont d''âge éocène, ceci montre que le phosphate s''est formé pendant cette époque, **c''est-à-dire il y a 60 millions d''années** ». Arrête-toi sur cette phrase : elle contient une **incohérence**, et la repérer est un excellent exercice de rigueur scientifique.

Reprends le tableau des temps géologiques du chapitre précédent. L''**éocène** y va de **55 à 35 millions d''années**. Or **60 millions d''années, c''est avant 55** — ce n''est donc pas l''éocène, mais l''époque qui le précède, le **Paléocène**. **Le tableau du manuel et son bilan ne disent pas la même chose.**

Alors, lequel des deux se trompe ? La réponse est plus intéressante qu''un simple « l''un ou l''autre » :

- **L''échelle du tableau est juste.** L''éocène va bien de 55 à 35 Ma — l''échelle stratigraphique internationale le date d''environ 56 à 34 Ma. Rien à corriger de ce côté.
- **Le chiffre de 60 Ma est juste, lui aussi — mais pour la roche, pas pour l''époque.** Les datations de la **série phosphatée du bassin de Gafsa-Métlaoui** la placent entre environ **62 et 48 millions d''années** : elle **commence à la fin du Paléocène** et se poursuit dans l''**éocène inférieur**. Ses couches les plus profondes, donc les plus anciennes, sont bien autour de 60 Ma.

**Ce qu''il faut retenir**, et c''est la nuance qui compte : la série phosphatée n''appartient pas à une seule époque — elle est **à cheval sur la limite entre le Paléocène et l''éocène**. Dire « le phosphate est d''âge éocène » est donc un **raccourci** : c''est vrai de la partie haute de la série, pas de sa base. Et si l''on te demande de dater les phosphates tunisiens en millions d''années, **60 Ma** reste la bonne réponse pour la **base** de la série. Ce qui est faux, c''est de mettre un **signe égal** entre « éocène » et « 60 Ma », comme le fait le bilan p.175 : ces deux affirmations sont exactes séparément, elles deviennent contradictoires dès qu''on les colle l''une à l''autre.

> 📖 Un mot sur le mot. Tu te souviens de la note du chapitre précédent : dans le tableau p.154, « Paléocène » désigne une **période** (celle que l''échelle internationale nomme le **Paléogène**). Ici, le **Paléocène** est l''**époque** qui précède immédiatement l''éocène, d''environ **66 à 56 Ma** — celle-là même que le tableau du manuel ne fait pas figurer. C''est précisément parce qu''elle manque au tableau que l''erreur du bilan est facile à commettre.

## 🌊 Comment le phosphate s''est formé

À cette époque, la Tunisie était **totalement immergée sauf quelques régions**. Autour de l''**île de Kasserine**, la mer était **peu profonde**, formant des **bassins sédimentaires presque fermés** par des **hauts-fonds**. Ces bassins étaient alimentés par des **courants ascendants** riches en éléments chimiques, notamment le **phosphore**. Dans ces bassins vivaient de nombreux organismes (plancton, mollusques, poissons…), qui **concentraient le phosphore** dans leurs organismes. Le **climat** qui régnait dans la région était **chaud et sec**.

On pense actuellement que le phosphate a **deux origines : l''une chimique, l''autre organique**.

::: figure Un même bassin, deux fabriques de phosphate : les ions phosphate montés par les courants rencontrent le calcium des eaux chaudes de surface et précipitent ; et le plancton, qui concentre le phosphore, tombe en cadavres dans un fond sans oxygène
<svg viewBox="0 0 360 200">
<path d="M50 60 L300 60 L300 176 L50 176 Z" fill="#0f6e56" opacity="0.10" stroke="none"/>
<line x1="50" y1="60" x2="300" y2="60" stroke="#0f6e56" stroke-width="2"/>
<path d="M300 60 L312 38 L346 34 L346 176 L300 176 Z" fill="#94a3b8" opacity="0.5" stroke="#0f172a" stroke-width="1.4"/>
<path d="M14 176 L14 42 L46 46 L60 100 L40 150 L60 176 Z" fill="#94a3b8" opacity="0.5" stroke="#0f172a" stroke-width="1.4"/>
<path d="M262 176 L280 90 L298 176 Z" fill="#94a3b8" opacity="0.5" stroke="#0f172a" stroke-width="1.4"/>
<path d="M56 168 Q160 156 298 168 L298 176 L56 176 Z" fill="#7c3aed" opacity="0.4" stroke="#0f172a" stroke-width="1.4"/>
<g fill="none" stroke="#dc2626" stroke-width="1.8">
<path d="M78 158 L78 120"/><path d="M96 162 L96 124"/>
</g>
<g fill="#dc2626">
<path d="M74 126 L78 116 L82 126 Z"/><path d="M92 130 L96 120 L100 130 Z"/>
</g>
<g fill="#0f6e56" opacity="0.75" stroke="#0f172a" stroke-width="0.8">
<circle cx="150" cy="76" r="3.4"/><circle cx="176" cy="82" r="3.4"/><circle cx="204" cy="74" r="3.4"/><circle cx="230" cy="82" r="3.4"/><circle cx="258" cy="77" r="3.4"/>
</g>
<g fill="#94a3b8" opacity="0.9" stroke="#0f172a" stroke-width="0.7">
<circle cx="162" cy="116" r="2.6"/><circle cx="212" cy="128" r="2.6"/><circle cx="248" cy="112" r="2.6"/><circle cx="190" cy="146" r="2.6"/>
</g>
<g fill="none" stroke="#94a3b8" stroke-width="1.1" stroke-dasharray="3 3">
<path d="M162 120 L166 158"/><path d="M212 132 L208 158"/><path d="M248 116 L252 156"/>
</g>
<g fill="none" stroke="#0f6e56" stroke-width="1.4">
<path d="M198 52 L198 40"/><path d="M212 52 L212 40"/><path d="M226 52 L226 40"/>
</g>
<g font-size="8.5" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round">
<text x="212" y="32" text-anchor="middle" fill="#0f6e56">évaporation</text>
<text x="204" y="64" text-anchor="middle" fill="#0f172a">Ca++ — biomasse importante</text>
<text x="72" y="92" text-anchor="middle" fill="#dc2626">courants</text>
<text x="72" y="102" text-anchor="middle" fill="#dc2626">ascendants</text>
<text x="72" y="112" text-anchor="middle" fill="#dc2626">HPO4--</text>
<text x="252" y="140" text-anchor="middle" fill="#94a3b8">cadavres</text>
<text x="38" y="34" text-anchor="middle" fill="#0f172a">terre émergée</text>
<text x="326" y="48" text-anchor="middle" fill="#0f172a">île de</text>
<text x="326" y="58" text-anchor="middle" fill="#0f172a">Kasserine</text>
<text x="280" y="82" text-anchor="middle" fill="#0f172a">haut fond</text>
<text x="186" y="192" text-anchor="middle" fill="#7c3aed">sédiment phosphaté — milieu pauvre en oxygène</text>
</g>
</svg>
:::

- **Origine chimique.** Dans ces bassins, les **courants ascendants** font monter les **eaux froides riches en ions phosphate (HPO4--)**. Ces eaux se mélangent avec les **eaux superficielles chaudes riches en ion calcium (Ca++)**. Dans ces conditions, **HPO4-- se combine avec Ca++** pour donner du **phosphate de calcium qui précipite**.
- **Origine organique.** À la surface des bassins vivaient un grand nombre de **microorganismes planctoniques**, qui **concentraient dans leur corps du phosphore**. Après leur mort, leurs **cadavres s''accumulaient au fond** des bassins, milieux **très pauvres en oxygène**. Sous l''effet des **bactéries**, la matière organique se **décomposait partiellement** et donnait des **sédiments phosphatés**.

> 🗡️ Les indices de l''origine **organique** sont sous ton nez depuis le début du chapitre : la présence de **coprolithes** — des excréments fossilisés — et l''**odeur fétide** montrent que le phosphate contient de la **matière organique**. Voilà pourquoi l''odeur n''était pas un détail. Et le **gypse** qu''on trouve parfois en alternance avec les couches phosphatées confirme le décor : le gypse se forme par précipitation à la suite d''une **intense évaporation**, donc dans un **bassin lagunaire peu profond** sous un **climat chaud et sec** — exactement les conditions de genèse du phosphate.

## 🏭 De la roche à l''engrais

**1. L''enrichissement du minerai.** La préparation se fait généralement à proximité des mines. Elle consiste à séparer le minerai de phosphate de ses **impuretés solides** : l''**argile**, le **carbonate de calcium**, l''**oxyde de magnésium**, le **fluorure de calcium**. La séparation se fait soit par **lavage à l''eau**, soit par **ventilation à l''air**.

Phosphate naturel → **extraction / concassage / broyage** (rejet : **poussière**) → minerai de phosphate → **lavage à l''eau** (rejet : **boue** riche en argile, calcaire, fluorine, magnésium) → **minerai riche en P2O5** → exportation par train vers les usines d''engrais ou vers les halls de stockage à **Sfax**.

- **Minerai de phosphate** : phosphate naturel **débarrassé de ses impuretés solides**.

**2. L''acide sulfurique.** Il est obtenu à partir du **soufre** en trois étapes : **combustion du soufre** → **oxydation catalytique** → **absorption**. Rejet : **traces de SO2 et SO3**.

**3. L''acide phosphorique.** Minerai de phosphate **+ acide sulfurique** → acide phosphorique à **28 % de P2O5** → acide phosphorique à **54 % de P2O5**. Rejets : **gaz fluorés** et **phosphogypse** (déchet solide stocké à proximité de l''usine).

**4. Le T.S.P.** Minerai de phosphate **+ acide phosphorique à 28 %** → **triple superphosphate, T.S.P à 47 % de P2O5**. Rejet : **gaz fluorés**. Le T.S.P est utilisé comme **engrais**, produit sous forme de **granulés** ; il contient une forte proportion de **P2O5** et quelques **oligoéléments (Ca, Mg, Fe, S)** nécessaires aux besoins de la plante verte.

**5. Les engrais chimiques.** Acide phosphorique à **54 %** + **potasse et nitrate** → **engrais NP, NPK, DAP**. Rejets : **gaz ammoniacal** et vapeur d''eau. L''acide phosphorique est utilisé en majeure partie comme **produit intermédiaire** pour la fabrication d''engrais chimiques solides et liquides.

- **NP** : engrais constitué de **nitrate (N)** et de **phosphate (P)**. — **NPK** : nitrate, phosphate et **potassium (K)**. — **DAP** : diammonium phosphate, engrais constitué essentiellement de phosphates.

## ☠️ Le prix à payer

### Le phosphogypse

**Phosphogypse** : déchet **solide** provenant de l''action de l''**acide sulfurique** sur le **minerai de phosphate**. Il est constitué de **sulfate de calcium**, de **divers acides**, de nombreux **sels de métaux lourds** et d''**éléments radioactifs**. Il est stocké sur **3 sites** : **SIAPE A (Sfax)**, **NPK (Sfax)** et la **Skhira**.

**Son effet sur la nappe phréatique** — l''analyse chimique de 1999 est sans appel :

| Teneurs (en ppm)                          | PH      | F     | PO4   | Cd     | Hg     | Fe    | Zn    |
| ----------------------------------------- | ------- | ----- | ----- | ------ | ------ | ----- | ----- |
| **Nappe à proximité du site de stockage** | **3,4** | 87,25 | 10100 | traces | 0,0022 | 18,22 | 15,71 |
| **Nappe non contaminée**                  | 6,5 à 9 | 5     | 0,1   | 0,005  | 0,001  | 1     | 10    |

Lis ce tableau, il parle de lui-même : le **PH tombe de 6,5–9 à 3,4** — l''eau est devenue **acide** (rappel : un PH entre 1 et 6 est acide, un PH de 7 est neutre, un PH entre 8 et 14 est basique). Le **fluor** est **plus de 17 fois** plus concentré, le **fer** plus de 18 fois — et le **PO4** passe de 0,1 à **10100**, un rapport de **plus de 100 000**.

**Son effet sur la faune et la flore marine.** Le phosphogypse est parfois rejeté dans la mer. Les risques : **dispersion de toute la masse du gypse** et **solubilisation partielle des impuretés** dangereuses ; et la **turbidité** de l''eau — l''eau devient **moins transparente**, donc l''**assimilation chlorophyllienne ne se fait pas correctement**, ce qui produit une **asphyxie de la flore** et une **désertification progressive de la mer**, et par voie de conséquence un **déséquilibre écologique** important.

> 🗡️ Tu reconnais la chaîne ? Moins de lumière → moins de photosynthèse → la flore meurt. C''est la nutrition carbonée du chapitre 2, retournée contre la mer. Rien de ce que tu apprends ici n''est isolé.

### Les gaz fluorés et soufrés

**Sur les végétaux.** La végétation au voisinage de la source d''émission apparaît **pâle et rabougrie**. Des espèces très sensibles comme l''**abricotier** et le **mûrier** ont **disparu complètement dans un rayon de 1 km** de l''usine. D''autres, comme le **figuier** et l''**amandier**, ne sont représentées que par quelques individus **non productifs et à feuilles nécrosées**. L''agression des polluants **disparaît de manière significative au-delà de 10 km** de la source.

| Espèce                  | Fluor — zone polluée (ppm) | Fluor — zone témoin | Soufre — zone polluée (%) | Soufre — zone témoin |
| ----------------------- | -------------------------: | ------------------: | ------------------------: | -------------------: |
| **Figuier de barbarie** |                       1425 |                 3,5 |                      0,42 |                 0,08 |
| **Olivier**             |                       1027 |                15,3 |                      0,53 |                 0,18 |
| **Palmier dattier**     |                        899 |                10,8 |                      0,37 |                 0,35 |
| **Amandier**            |                        405 |                  16 |                      0,80 |                 0,24 |
| **Grenadier**           |                        242 |                 7,2 |                      0,91 |                 0,16 |
| **Vigne**               |                        204 |                   6 |                      0,61 |                 0,15 |
| **Abricotier**          |                         93 |                 6,7 |                      0,30 |                 0,14 |

**Sur les animaux.** Chez les animaux vivant à proximité des usines, les chercheurs ont observé : les **moutons** et les **chèvres** présentent une **dégradation désordonnée des dents**, des **troubles du squelette** et une **diminution de la production du lait**. Ils l''expliquent par l''introduction du **fluor** avec le **fourrage** dans l''organisme de ces animaux.

**Sur l''Homme.** L''Homme non plus ne semble pas échapper aux effets de la pollution fluorée et soufrée : des cas de **lésions dentaires** et d''**affections respiratoires** ont été signalés.

## 🧭 Que faire ?

**Faute de solution immédiate pour le recyclage du phosphogypse** en quantité importante, il semble nécessaire de prendre des mesures pour **limiter** la pollution. Ces mesures consistent à :

- **protéger les sites actuels** ;
- **aménager des sites étudiés pour le stockage futur** du phosphogypse.

> ⚠️ Certains chercheurs proposent d''installer de **longues cheminées équipées de filtres** pour limiter la pollution par les gaz rejetés. Sais-tu la critiquer ? Une cheminée plus haute ne **supprime** rien : elle **disperse** le polluant plus loin — le problème est déplacé, pas résolu, et l''agression des polluants s''étend jusqu''à 10 km. Quant aux filtres, ils ne font que **transformer un déchet gazeux en déchet solide**, qu''il faudra bien stocker à son tour. Et surtout, ni l''un ni l''autre n''agit sur le **phosphogypse**, qui est le déchet le plus encombrant. Une solution technique ne vaut que si elle traite la **cause**, pas le trajet du symptôme.

Le bilan résume l''enjeu : le phosphogypse est une **source de pollution par sa composition** et **encombrant par les grandes quantités produites** chaque année. La **solubilité des éléments toxiques** qu''il contient, et son **contact avec le sol et l''air libre**, accentuent le **risque de propagation** de la pollution aux nappes phréatiques, au sol, aux eaux superficielles et à la mer.

> 🏆 Dernière quête franchie, héros — la matière est complète. Tu as suivi l''eau dans une racine, la lumière dans une feuille, un microbe dans une plaie, et l''histoire de la Terre dans une falaise. Tu finis sur la question qui les résume toutes : une ressource nourrit un pays, et son exploitation l''abîme. Savoir, c''est pouvoir choisir en connaissance de cause. C''est exactement ce que huit chapitres t''ont donné.', '# 📜 Résumé : Exploitation et gestion d''une roche à intérêt économique : le phosphate

- **L''enjeu économique.** Production de plus de **8 millions de tonnes** en **2000** (contre **6 millions** à la fin des années **1980**). La Tunisie est **1ère exportatrice mondiale de T.S.P**, **2ème en acide phosphorique**, **3ème en D.A.P** ; plus de **4500 familles** vivent du secteur. Deux bassins sédimentaires : **Gafsa** et le **Kef**. Mais l''exploitation génère des **déchets solides et gazeux** nuisibles à la santé et à l''environnement.
- **La découverte.** **Avril 1885**, région de **Metlaoui** : **Philippe Thomas**, géologue **amateur** français, découvre des couches puissantes de phosphates de calcium sur le **versant Nord de Jebel Thelja**.
- **L''extraction.** **Mines souterraines** (Redeyef, Shib et M''rata, Moulares, **Kalaa Khasba**, Jebel M''dhilla, Oum Lakhcheb) : autrefois — **dangereuse, coûteuse et peu rentable**. **Carrières à ciel ouvert** (Kef Shfaier, Kef Eddour, Jellabia, Redeyef, Moulares) : à présent — **moins de dangers**, **moins de coûts**, **plus de production**.
- **Rentabilité — trois critères, pas un.** La **teneur en P2O5 doit être ≥ 25 %** ; la teneur s''exprime aussi en **BPL**, équivalent en **phosphate tricalcique Ca3(PO4)2** (**56 à 59 % à Metlaoui**, **60 à 68 % à Kalaa Khasba**). S''y ajoutent la **puissance** (épaisseur) de la couche et sa **situation proche de la surface** (accessibilité, coût d''extraction).
- **La roche phosphatée.** **Compacte** ; **friable** à Kef Shfaier, **non friable** à Kalaa Khasba (les grains y sont retenus par un **ciment**). **Odeur fétide** caractéristique. À la **loupe binoculaire** : des **pellets** (grains phosphatés **sphériques ou ovoïdes**), des **coprolithes** (grains **cylindriques** de quelques mm à **2 cm**, **restes d''excréments** d''organismes), des **fossiles divers**, des **grains de quartz**. **Tests** : **insoluble** dans l''eau pure (1 cm3 de roche dans 10 cm3 d''eau, aucune modification) · **poreuse** (l''eau versée dans un creux est rapidement absorbée) · **imperméable** (l''eau ne traverse pas) · à l''**acide**, **certaines** roches font effervescence et d''autres non → la roche **peut contenir du calcaire** (l''effervescence ne prouve jamais la présence de phosphate) · à la **chaleur**, dégagement de **vapeur d''eau** et **odeur fétide**.
- **Les fossiles du phosphate.** **Dents de requins** (les plus fréquentes), **os de vertébrés marins** (parfois un squelette entier), **coquilles de mollusques**, **tests de microorganismes** (au microscope, sur lames minces). Ils appartiennent à des animaux d''une **mer peu profonde**.
- **⏳ L''âge — attention à l''incohérence du manuel.** Le bilan p.175 écrit : « ces fossiles sont d''âge éocène, c''est-à-dire **il y a 60 millions d''années** ». Or le tableau des temps géologiques p.154 place l''**éocène de 55 à 35 Ma** : **60 Ma est donc avant l''éocène**, dans l''époque qui le précède, le **Paléocène**. Le manuel se contredit lui-même. Ce qu''il faut retenir : **l''échelle du tableau est juste** (l''échelle internationale date l''éocène d''environ 56 à 34 Ma) **et le chiffre de 60 Ma est juste pour la roche** — la **série phosphatée du bassin de Gafsa-Métlaoui** s''est déposée entre environ **62 et 48 Ma**, c''est-à-dire de la **fin du Paléocène** à l''**éocène inférieur**. Elle est donc **à cheval sur la limite Paléocène-éocène** : « le phosphate est d''âge éocène » est un **raccourci**, vrai de sa partie haute, faux de sa base. Pour dater les phosphates tunisiens en millions d''années, **60 Ma** reste la bonne réponse pour la **base** de la série ; ce qui est faux, c''est l''**équivalence « éocène = 60 Ma »**.
- **La paléogéographie.** La Tunisie était **totalement immergée sauf quelques régions**. Autour de l''**île de Kasserine**, la mer était **peu profonde**, formant des **bassins presque fermés** par des **hauts-fonds**, alimentés par des **courants ascendants** riches en **phosphore**. De nombreux organismes y vivaient (plancton, mollusques, poissons). Le climat était **chaud et sec** (intense évaporation).
- **Les deux origines du phosphate.** **Chimique** : les **courants ascendants** font monter les eaux **froides riches en ions phosphate (HPO4--)**, qui se mélangent aux eaux **superficielles chaudes riches en ion calcium (Ca++)** ; **HPO4-- se combine à Ca++** → **phosphate de calcium qui précipite**. **Organique** : les **microorganismes planctoniques** de surface **concentrent le phosphore** dans leur corps ; après leur mort, leurs **cadavres s''accumulent au fond**, milieu **très pauvre en oxygène** ; sous l''effet des **bactéries**, la matière organique se **décompose partiellement** → **sédiments phosphatés**. Les indices de l''origine organique : les **coprolithes** et l''**odeur fétide** montrent que le phosphate contient de la **matière organique**. Le **gypse** en alternance avec les couches phosphatées confirme le décor : il précipite par **intense évaporation**, donc en **bassin lagunaire peu profond** sous climat **chaud et sec**.
- **La chaîne industrielle.** **Enrichissement** : phosphate naturel → extraction / **concassage** / **broyage** (rejet : **poussière**) → minerai → **lavage à l''eau** ou **ventilation à l''air** pour ôter les **impuretés solides** — **argile, carbonate de calcium, oxyde de magnésium, fluorure de calcium** — (rejet : **boue**) → **minerai riche en P2O5**. **Minerai de phosphate** = phosphate naturel débarrassé de ses impuretés solides. **Acide sulfurique** : à partir du **soufre**, par **combustion → oxydation catalytique → absorption** (rejet : traces de SO2 et SO3). **Acide phosphorique** : minerai + acide sulfurique → **28 % de P2O5** → **54 % de P2O5** (rejets : **gaz fluorés** et **phosphogypse**). **T.S.P** : minerai + acide phosphorique 28 % → **T.S.P à 47 % de P2O5**, engrais en **granulés**, riche en P2O5 et en **oligoéléments (Ca, Mg, Fe, S)** (rejet : gaz fluorés). **Engrais** : acide phosphorique 54 % + **potasse et nitrate** → **NP / NPK / DAP** (rejets : **gaz ammoniacal**, vapeur d''eau). **NP** = nitrate + phosphate · **NPK** = + potassium · **DAP** = diammonium phosphate.
- **Le phosphogypse.** Déchet **solide** provenant de l''action de l''**acide sulfurique** sur le **minerai de phosphate** ; il contient du **sulfate de calcium**, **divers acides**, des **sels de métaux lourds** et des **éléments radioactifs**. Stocké sur **3 sites** : **SIAPE A (Sfax)**, **NPK (Sfax)**, la **Skhira**. **Nappe phréatique (1999)** : à proximité du site, le **PH tombe à 3,4** (contre **6,5 à 9** dans une nappe saine — l''eau devient **acide**), le **fluor** monte à **87,25 ppm** (contre 5), le **PO4** à **10100** (contre 0,1), le **fer** à **18,22** (contre 1), le **zinc** à **15,71** (contre 10). **Rejeté en mer** : dispersion de la masse de gypse, **solubilisation partielle des impuretés**, et **turbidité** → l''eau devient moins transparente → l''**assimilation chlorophyllienne** ne se fait pas correctement → **asphyxie de la flore** → **désertification progressive de la mer** → **déséquilibre écologique**. **PH** : Potentiel d''Hydrogène, valeur de 1 à 14 — **1 à 6 acide**, **7 neutre**, **8 à 14 basique**.
- **Les gaz fluorés et soufrés.** **Végétaux** : végétation **pâle et rabougrie** ; l''**abricotier** et le **mûrier** ont **disparu dans un rayon de 1 km** ; le **figuier** et l''**amandier** ne subsistent qu''en individus **non productifs à feuilles nécrosées** ; l''agression disparaît significativement **au-delà de 10 km**. Teneurs en fluor, zone polluée vs témoin : figuier de barbarie **1425** contre 3,5 ppm ; olivier **1027** contre 15,3 ; palmier dattier **899** contre 10,8 ; amandier **405** contre 16. **Animaux** : chez les **moutons** et les **chèvres**, **dégradation désordonnée des dents**, **troubles du squelette**, **diminution de la production du lait** — expliqués par le **fluor** apporté par le **fourrage**. **Homme** : cas de **lésions dentaires** et d''**affections respiratoires**.
- **La gestion.** Faute de solution immédiate pour le **recyclage** du phosphogypse en quantité importante : **protéger les sites actuels** et **aménager des sites étudiés pour le stockage futur**. Critique des **cheminées à filtres** : une cheminée plus haute **disperse** le polluant au lieu de le supprimer, un filtre **transforme un déchet gazeux en déchet solide** à stocker, et aucun des deux n''agit sur le **phosphogypse**. Le phosphogypse est une source de pollution **par sa composition** et **encombrant par les quantités produites** ; la **solubilité de ses éléments toxiques** et son **contact avec le sol et l''air libre** accentuent le risque de propagation aux **nappes phréatiques**, au **sol**, aux **eaux superficielles** et à la **mer**.', 8, '{"code":"225104P00","pages":"164-180","pageNumbers":[164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', 'eb484ddb-29b8-522a-a8bd-be1247b74660', 'svt-1ere-sec', 'Test de compréhension ⭐ : La nutrition minérale', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('e33a077b-ba10-5f6c-a4ad-5ed1a8083cca', 'c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', 'Dans une jeune racine, quelle zone assure l''absorption de l''eau et des sels minéraux ?', '[{"id":"a","text":"La coiffe"},{"id":"b","text":"La zone subéreuse"},{"id":"c","text":"La zone pilifère"},{"id":"d","text":"Le cylindre central"}]'::jsonb, 'c', 'L''absorption se fait au niveau des poils absorbants, et ceux-ci sont tous rassemblés sur la zone pilifère ✓. Ni la coiffe, à l''extrémité de la racine, ni la zone subéreuse, plus haut, ne portent de poils absorbants. Quant au cylindre central, l''eau ne l''atteint qu''après avoir traversé horizontalement la racine : c''est un point d''arrivée, pas la porte d''entrée.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ddb8f6f7-d20f-505d-b47e-e1bdd1190ab1', 'c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', 'L''osmose est le passage d''eau à travers une membrane semi-perméable. Dans quel sens se fait-il ?', '[{"id":"a","text":"Du milieu le plus concentré vers le milieu le moins concentré"},{"id":"b","text":"Du milieu le moins concentré vers le milieu le plus concentré"},{"id":"c","text":"De la cellule vers le milieu extérieur, quelles que soient les concentrations"},{"id":"d","text":"Du milieu le plus chaud vers le milieu le plus froid"}]'::jsonb, 'b', 'L''osmose fait passer l''eau du milieu le moins concentré, dit hypotonique, vers le milieu le plus concentré, dit hypertonique, jusqu''à l''égalité des concentrations ou isotonie ✓. Inverser ce sens est le piège le plus courant : il rendrait incompréhensible l''olive qui se ratatine dans une saumure. Et le sens ne dépend ni de la position par rapport à la cellule, ni de la température, mais seulement de la différence de concentration.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('89c9d68e-0825-5c8a-b227-53823dcebcce', 'c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', 'Un fragment d''épiderme d''oignon violet est plongé dans une solution de chlorure de sodium à 20 g/l. Dans quel état seront ses cellules ?', '[{"id":"a","text":"Turgescentes"},{"id":"b","text":"Inchangées, comme dans une solution à 9 g/l"},{"id":"c","text":"Éclatées, leur paroi ayant cédé"},{"id":"d","text":"Plasmolysées"}]'::jsonb, 'd', 'À 20 g/l, la solution est hypertonique par rapport au contenu de la cellule : l''eau sort par osmose, la vacuole se rétracte et le cytoplasme se décolle de la paroi — les cellules sont plasmolysées ✓. La turgescence est l''état inverse, observé à 2 g/l lorsque l''eau entre ; c''est à 9 g/l que les cellules restent normales, pas à 20 g/l. Et la paroi ne cède pas : c''est justement elle qui reste en place pendant que la membrane s''en détache.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b7800c09-23f7-5dd5-ae2d-a6b474a67475', 'c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', 'Qu''est-ce que la sève brute, et où circule-t-elle ?', '[{"id":"a","text":"Un mélange d''eau et de sels minéraux, qui circule dans les vaisseaux du bois"},{"id":"b","text":"Un mélange d''eau et de sels minéraux, qui circule dans les poils absorbants"},{"id":"c","text":"Un mélange d''eau et de sucres, qui circule dans les vaisseaux du bois"},{"id":"d","text":"Un mélange d''eau et de sucres, qui circule dans les poils absorbants"}]'::jsonb, 'a', 'La sève brute est le mélange d''eau et de sels minéraux absorbé par les racines ; elle monte vers les feuilles dans les vaisseaux du bois, ces files de cellules mortes à paroi lignifiée dont l''ensemble forme le xylème ✓. Elle ne contient pas de sucres : la plante ne prélève dans le sol que de l''eau et des sels minéraux. Et le poil absorbant est la porte d''entrée de l''eau, pas la voie de sa montée.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('dc95078f-4b07-5369-9d4e-20e7da51cfa6', 'c02e4f34-494e-53a4-b7e9-2c74bd81c8c1', 'Un agriculteur apporte systématiquement beaucoup plus d''eau que nécessaire à sa culture. Quelle conséquence subit la plante elle-même ?', '[{"id":"a","text":"Ses racines s''allongent plus vite pour aller chercher l''eau"},{"id":"b","text":"Ses racines s''asphyxient, ce qui réduit la quantité d''eau absorbée"},{"id":"c","text":"Sa transpiration s''arrête complètement"},{"id":"d","text":"Ses stomates se ferment définitivement"}]'::jsonb, 'b', 'Trop d''eau conduit à une asphyxie des racines, qui réduit la quantité d''eau absorbée par la plante ✓ — c''est pourquoi une irrigation rationnelle ne dépasse pas les quantités optimales, l''excès étant en outre coûteux et contribuant à l''assèchement des nappes. L''excès d''eau n''allonge pas les racines : il les asphyxie. Quant à la transpiration et à l''ouverture des ostioles, elles dépendent de la surface foliaire, de la densité stomatique, de la lumière, de la température et de l''état de l''air — pas d''un excès d''eau dans le sol.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('835aa112-c237-5b31-8d09-feae7b25a7b7', 'eb484ddb-29b8-522a-a8bd-be1247b74660', 'svt-1ere-sec', '⭐ Exercice : Sur les traces de l''eau dans la plante', 1, 50, 10, 'practice', 'admin', 1)
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
  ('8370514e-445c-591a-92da-e4099e253999', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'À quoi sert un potomètre ?', '[{"id":"a","text":"À mesurer la quantité d''eau absorbée par une plante"},{"id":"b","text":"À mesurer la masse sèche d''un végétal"},{"id":"c","text":"À mettre en évidence les échanges d''eau à travers une membrane semi-perméable"},{"id":"d","text":"À colorer les vaisseaux conducteurs d''une tige"}]'::jsonb, 'a', 'Le potomètre (potos = boisson, mètre = mesure) mesure la quantité d''eau absorbée par une plante : on suit le déplacement de l''index dans son tube capillaire ✓. La masse sèche, elle, s''obtient par pesée après déshydratation. L''appareil qui met en évidence les échanges d''eau à travers une membrane semi-perméable est l''osmomètre, pas le potomètre : ne les confonds pas. Et la coloration des vaisseaux se fait à l''éosine ou au bleu de méthylène, sans appareil de mesure.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8e59a821-f39b-5ba3-ab73-5b234b3b6253', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'Les poils absorbants d''un plant de seigle offrent environ 400 m² de surface de contact avec la solution du sol. Quel est l''intérêt d''une telle surface ?', '[{"id":"a","text":"Elle rend la racine plus résistante à l''arrachement"},{"id":"b","text":"Elle permet à la racine de réaliser la photosynthèse"},{"id":"c","text":"Elle permet d''absorber une grande quantité d''eau et de sels minéraux"},{"id":"d","text":"Elle protège la coiffe contre le dessèchement"}]'::jsonb, 'c', 'Chaque poil absorbant est minuscule (12 à 15 μm de diamètre), mais on en compte jusqu''à 2000 par cm² chez les graminées, soit 14 milliards chez un plant de seigle : ensemble, ils représentent une surface d''échange considérable entre la plante et le sol, et plus cette surface est grande, plus la plante peut absorber d''eau et de sels minéraux ✓. La résistance mécanique et la protection de la coiffe ne sont pas la fonction du poil absorbant. Quant à la photosynthèse, elle exige de la lumière : elle n''a pas lieu dans le sol.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('de8815b1-b69c-553b-b863-e04b9254f688', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'De quoi un stomate est-il formé ?', '[{"id":"a","text":"D''une cellule unique percée d''un pore central"},{"id":"b","text":"D''une file de cellules mortes à paroi lignifiée"},{"id":"c","text":"De deux poils absorbants accolés"},{"id":"d","text":"De deux cellules stomatiques bordant un ostiole"}]'::jsonb, 'd', 'Un stomate est une structure épidermique formée de deux cellules stomatiques qui bordent un orifice, l''ostiole, par où sort la vapeur d''eau ✓. Ce n''est ni une cellule unique, ni deux poils absorbants accolés — le poil absorbant est une cellule de la racine, pas de la feuille. Et la file de cellules mortes à paroi lignifiée décrit le vaisseau du bois : il conduit la sève brute, il ne transpire pas.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('027d4c81-285a-5dc1-9a33-4fa045cf121b', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'Par quelle(s) face(s) d''une feuille se fait la transpiration ?', '[{"id":"a","text":"Par la face supérieure uniquement"},{"id":"b","text":"Par la face inférieure uniquement"},{"id":"c","text":"Par les deux faces, davantage par l''inférieure"},{"id":"d","text":"Par les deux faces, davantage par la supérieure"}]'::jsonb, 'c', 'Une lamelle de verre fixée sur chaque face se couvre de buée au bout de 30 minutes : les deux faces transpirent. Mais la transpiration foliaire est plus importante au niveau de la face inférieure ✓, où les stomates sont plus nombreux. Ne retenir qu''une seule des deux faces serait donc déjà faux ; et prétendre que la face supérieure transpire davantage inverse le rapport entre elles.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3616a836-0f14-5737-b34c-8954e0492386', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'Que reste-t-il d''un vaisseau du bois une fois qu''il est formé ?', '[{"id":"a","text":"Une file de cellules mortes réduites à leur paroi lignifiée"},{"id":"b","text":"Une file de cellules mortes réduites à leur paroi cellulosique"},{"id":"c","text":"Une file de cellules vivantes à paroi lignifiée"},{"id":"d","text":"Une file de cellules vivantes à paroi cellulosique"}]'::jsonb, 'a', 'Un vaisseau du bois est une file de cellules mortes réduites à leur paroi, riche en lignine ✓ ; l''ensemble des vaisseaux du bois forme le xylème. Deux erreurs sont possibles, et chacune se glisse dans les autres propositions. D''abord croire les cellules vivantes : le vaisseau est un tube inerte. Ensuite croire la paroi cellulosique : c''est la lignine qui la rend dure — le carmino-vert la colore d''ailleurs en vert, alors qu''il colore la cellulose en rose foncé.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('24b390fb-9b31-5195-920e-32e25236b520', '835aa112-c237-5b31-8d09-feae7b25a7b7', 'Qu''est-ce qu''un milieu synthétique carencé ?', '[{"id":"a","text":"Un milieu qui contient tous les éléments minéraux nécessaires"},{"id":"b","text":"Un milieu auquel il manque un élément minéral indispensable"},{"id":"c","text":"Un milieu dont un élément minéral atteint la concentration toxique"},{"id":"d","text":"Un milieu qui ne contient que de l''eau distillée, sans aucun sel"}]'::jsonb, 'b', 'Un milieu synthétique incomplet, ou carencé, est un milieu nutritif artificiel auquel il manque un ou plusieurs éléments indispensables à la nutrition de la plante ✓ : on l''obtient en retirant au milieu complet le seul élément dont on veut tester le rôle. Un milieu qui contient tous les éléments nécessaires est au contraire le milieu synthétique complet, comme le liquide de Knop. Une concentration toxique est un excès, pas un manque. Et l''eau distillée seule n''est pas un milieu de culture : c''est sur elle que Knop fait germer ses grains de maïs avant de les placer sur la solution nutritive.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'eb484ddb-29b8-522a-a8bd-be1247b74660', 'svt-1ere-sec', '⭐⭐ Révision (type examen) : Absorption, transpiration et sels minéraux', 2, 75, 15, 'practice', 'admin', 3)
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
  ('7cd3036d-fd37-5e99-9ee9-18604e3d22f7', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'Dans l''expérience de Rosène, cinq jeunes plants ont leurs racines plongées dans cinq tubes A, B, C, D et E. Le tube A est le seul où toute la racine baigne dans l''eau, sans huile. Quel est son rôle ?', '[{"id":"a","text":"Il sert de témoin, aucune zone n''y étant isolée par l''huile"},{"id":"b","text":"Il sert à mesurer la vitesse d''absorption en cm³/heure"},{"id":"c","text":"Il sert à empêcher l''évaporation de l''eau des autres tubes"},{"id":"d","text":"Il sert à comparer deux espèces végétales différentes"}]'::jsonb, 'a', 'Le tube A est le témoin : il montre ce que donne le montage quand aucune zone de la racine n''est isolée de l''eau par l''huile. C''est lui qui permet d''attribuer les différences observées dans les tubes B, C, D et E à la seule zone laissée au contact de l''eau ✓. La vitesse d''absorption, elle, se mesure au potomètre, pas ici. C''est l''huile — justement absente du tube A — qui isole une zone de l''eau, et non le tube témoin qui protégerait les autres de l''évaporation. Enfin, le protocole ne compare pas des espèces : d''un tube à l''autre, seule la zone en contact avec l''eau change.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f55785f1-1488-598f-836d-6d962733d85c', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'Un rameau de vigne coupé au printemps laisse s''écouler de la sève au niveau de la section de la tige : on dit que la vigne pleure. Que prouve ce phénomène ?', '[{"id":"a","text":"Que la transpiration foliaire aspire la sève vers le haut"},{"id":"b","text":"Que la sève est poussée par une pression venue des racines"},{"id":"c","text":"Que la sève brute descend des feuilles vers les racines"},{"id":"d","text":"Que le bilan hydrique de la plante est devenu négatif"}]'::jsonb, 'b', 'Un rameau coupé n''a plus de partie aérienne feuillée, donc plus d''aspiration foliaire — et pourtant la sève monte et s''écoule. C''est la preuve qu''elle circule sous pression dans les vaisseaux du bois, poussée depuis les racines : c''est la poussée radiculaire ✓, que l''expérience de Hales mesure au manomètre à mercure. L''aspiration foliaire est bien l''autre moteur de la montée de sève, mais elle ne peut pas agir ici, faute de feuilles : c''est tout l''intérêt de l''observation. La sève brute monte des racines vers les feuilles, elle ne descend pas. Et un bilan hydrique négatif signifie que la plante perd plus d''eau qu''elle n''en absorbe : elle se fane, elle ne rejette pas de sève.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('91a21c54-f5eb-5636-905d-ca036d1fbe7f', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'On cultive six lots de maïs sur six milieux synthétiques pendant trois semaines. Sur l''un d''eux, les feuilles présentent une nécrose et la masse sèche tombe à 44 g pour 100 pieds, contre 162 g sur le milieu de Knop. De quel milieu s''agit-il ?', '[{"id":"a","text":"Le milieu sans azote"},{"id":"b","text":"Le milieu sans phosphore"},{"id":"c","text":"Le milieu sans potassium"},{"id":"d","text":"Le milieu sans fer"}]'::jsonb, 'c', 'Chaque carence laisse sa signature sur les feuilles et sur la masse sèche. La nécrose, accompagnée de la plus forte chute de masse sèche (44 g contre 162 g pour le témoin), est celle du milieu sans potassium ✓. La carence en azote donne une chlorose et 68 g ; celle en phosphore un jaunissement à l''extrémité des feuilles et 116 g ; celle en fer une chlorose et 130 g. Seule la lecture conjointe du symptôme et du chiffre permet de trancher, puisque l''azote et le fer donnent le même symptôme.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9e6ec3b7-1a4a-5324-b693-4befe7421343', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'Garreau mesure, chez le tilleul, le nombre de stomates et l''eau transpirée par chaque face d''une feuille. La face inférieure porte 300 stomates par mm² et transpire 490 mg d''eau en 24 heures ; la face supérieure n''en porte aucun et transpire pourtant 200 mg en 24 heures. Comment expliquer cette transpiration sans stomate ?', '[{"id":"a","text":"Les stomates de la face inférieure transpirent aussi pour la face supérieure"},{"id":"b","text":"Le tilleul possède des stomates invisibles au microscope"},{"id":"c","text":"La mesure est fausse : sans stomate, aucune transpiration n''est possible"},{"id":"d","text":"La cuticule, mince chez le tilleul, laisse passer la vapeur d''eau"}]'::jsonb, 'd', 'Puisque la face supérieure du tilleul transpire 200 mg par 24 heures sans porter un seul stomate, la vapeur emprunte forcément une autre voie. La comparaison des coupes des deux feuilles la désigne : chez le Dahlia, la face supérieure a des stomates et une cuticule épaisse ; chez le tilleul, elle n''a pas de stomate et sa cuticule est mince — c''est donc la cuticule qui est responsable de cette transpiration accessoire ✓. Les stomates d''une face ne transpirent pas pour l''autre : chacun débouche sur sa propre face. Postuler des stomates invisibles contredit l''observation microscopique, qui n''en montre aucun. Et le piège courant est de rejeter la mesure : c''est elle, au contraire, qui oblige à chercher une seconde voie de transpiration.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('96569c1c-2c6f-58ac-be1c-1e9c63f8544b', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'Dans un potomètre dont le tube capillaire a un diamètre de 2 mm, l''index se déplace de 8 mm en 5 minutes. Le volume du cylindre d''eau vaut V = R × R × π × h, avec π = 3,14. Quelle est la vitesse d''absorption ?', '[{"id":"a","text":"0,005 cm³/heure"},{"id":"b","text":"0,025 cm³/heure"},{"id":"c","text":"0,3 cm³/heure"},{"id":"d","text":"1,2 cm³/heure"}]'::jsonb, 'c', 'Le tube capillaire est assimilé à un cylindre. Son diamètre vaut 2 mm, donc son rayon R = 1 mm = 0,1 cm ; le déplacement de l''index donne la hauteur h = 8 mm = 0,8 cm. Le volume absorbé vaut V = 0,1 × 0,1 × 3,14 × 0,8 = 0,025 cm³ en 5 minutes. La vitesse est donc 0,025 / 5 = 0,005 cm³/mn, soit 0,005 × 60 = 0,3 cm³/heure ✓. Le piège courant est de prendre le diamètre pour le rayon : le volume est alors multiplié par 4 et l''on trouve 1,2. Trouver 0,025 revient à confondre le volume absorbé en 5 minutes avec une vitesse ; trouver 0,005 revient à s''arrêter à la vitesse par minute, qu''il restait à multiplier par 60.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2af41e79-44d7-54cc-87a8-f7e8fb554818', 'eb1e3cf3-2b35-5c54-9256-79789e1dfefd', 'On mesure la vitesse de croissance de plantes cultivées sur des solutions ne différant que par leur teneur en potassium : 21 à 100 mg/l, 139 à 500 mg/l, 143 à 600 mg/l, 140 à 700 mg/l, 50 à 900 mg/l et 10 à 1000 mg/l. Un agriculteur dont la solution est à 500 mg/l décide de doubler la dose. Que prévoient ces résultats ?', '[{"id":"a","text":"Une chute de la croissance : à 1000 mg/l, le potassium est toxique"},{"id":"b","text":"Un doublement de la croissance, puisque la dose est doublée"},{"id":"c","text":"Une croissance inchangée : la courbe forme un palier après 500 mg/l"},{"id":"d","text":"Une croissance maximale : 1000 mg/l est la concentration optimale"}]'::jsonb, 'a', 'La croissance ne suit pas la dose : elle traverse trois domaines. En dessous de 500 mg/l, le manque la limite — c''est la déficience. Entre 500 et 700 mg/l elle est maximale (143 à 600 mg/l) — c''est la concentration optimale. Au-delà de 700 mg/l elle s''effondre. En doublant 500 mg/l, l''agriculteur atteint 1000 mg/l, où la vitesse retombe à 10, soit moins que les 21 obtenus à 100 mg/l ✓ : la concentration est devenue toxique et empoisonne la plante. Le piège courant est de raisonner en proportion : à 500 mg/l on est déjà à 139, tout près du maximum de 143 — il n''y a plus rien à gagner. Le palier existe bien, mais il s''arrête à 700 mg/l. Et l''optimum se situe entre 500 et 700 mg/l, pas à 1000.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('194de524-a981-5046-97c2-b5fd75a83615', 'da09b891-f755-5773-8d01-3100b3d94215', 'svt-1ere-sec', 'Test de compréhension ⭐ : La nutrition carbonée', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('52da7bdf-16c8-5b63-bad0-9a5ccf9e0eaf', '194de524-a981-5046-97c2-b5fd75a83615', 'Quel réactif révèle l''amidon d''un tubercule de pomme de terre, et quelle coloration obtient-on ?', '[{"id":"a","text":"L''eau iodée ; coloration bleue foncée"},{"id":"b","text":"La liqueur de Fehling ; précipité rouge brique"},{"id":"c","text":"Le sulfate de cuivre puis la soude ; coloration violette"},{"id":"d","text":"L''alcool à 90° ; coloration verte"}]'::jsonb, 'a', 'L''amidon se révèle par quelques gouttes d''eau iodée, qui donnent une coloration bleue foncée ✓. La liqueur de Fehling chauffée donne bien un précipité rouge brique, mais elle révèle le glucose. Le sulfate de cuivre suivi de la soude donne une coloration violette et révèle le gluten. Quant à l''alcool à 90°, ce n''est pas un révélateur : il sert à extraire la chlorophylle et à décolorer la feuille avant le test à l''eau iodée.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e395ec07-d9a5-58de-8a71-7edaeef8becd', '194de524-a981-5046-97c2-b5fd75a83615', 'Où se déroule la photosynthèse dans la cellule chlorophyllienne ?', '[{"id":"a","text":"Dans le cytoplasme"},{"id":"b","text":"Dans la paroi pectocellulosique"},{"id":"c","text":"Dans le chloroplaste"},{"id":"d","text":"Dans la vacuole"}]'::jsonb, 'c', 'Le chloroplaste est l''organite de la cellule végétale où se déroule la photosynthèse ✓ : c''est lui qui porte la chlorophylle. Le cytoplasme et la paroi pectocellulosique sont bien des constituants de la cellule chlorophyllienne, mais on les trouve dans toute cellule végétale — ce qui distingue la cellule chlorophyllienne des autres, ce sont précisément ses chloroplastes. La vacuole, elle, n''intervient pas dans la photosynthèse.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('650c89f2-ae8d-5657-ab66-78b9a5b5ac82', '194de524-a981-5046-97c2-b5fd75a83615', 'On place des chlorelles, sous fort éclairement, dans de l''eau additionnée de dioxyde de carbone. L''oxygène de cette eau est radioactif. Résultat : l''oxygène dégagé est radioactif, mais pas les glucides fabriqués. Que peut-on en conclure ?', '[{"id":"a","text":"L''oxygène dégagé provient du dioxyde de carbone"},{"id":"b","text":"L''oxygène des glucides fabriqués provient de l''eau"},{"id":"c","text":"L''oxygène dégagé provient de l''air ambiant"},{"id":"d","text":"L''oxygène dégagé provient de l''eau"}]'::jsonb, 'd', 'Le marquage suit l''atome : l''oxygène radioactif était dans l''eau et se retrouve dans l''oxygène dégagé — l''O₂ rejeté par la plante vient donc de l''eau ✓. Il ne vient pas du dioxyde de carbone : dans l''expérience symétrique, où c''est l''oxygène du CO₂ qui est radioactif, l''O₂ dégagé n''est pas radioactif. Il ne vient pas non plus de l''air ambiant : la plante en rejette ici, elle n''en prélève pas. Quant à l''oxygène des glucides, il ne vient pas de l''eau — les glucides ne sont justement pas radioactifs dans cette expérience, alors qu''ils le sont dans celle où le CO₂ porte l''oxygène marqué.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('99012c23-8348-5018-bbd4-4c21a5b1a8a8', '194de524-a981-5046-97c2-b5fd75a83615', 'Une feuille panachée porte des zones vertes et des zones blanches. Exposée à la lumière puis traitée à l''eau iodée, quelle condition de la photosynthèse permet-elle de démontrer ?', '[{"id":"a","text":"Le rôle du dioxyde de carbone"},{"id":"b","text":"Le rôle de la chlorophylle"},{"id":"c","text":"Le rôle de la lumière"},{"id":"d","text":"Le rôle de la température"}]'::jsonb, 'b', 'La feuille panachée est éclairée en entier et baigne tout entière dans le même air : la lumière et le dioxyde de carbone sont donc identiques partout. La seule chose qui change d''une zone à l''autre est la présence de chlorophylle — c''est elle, et elle seule, que l''expérience teste ✓. Le rôle du CO₂ se démontre en faisant barboter l''air dans la potasse ; celui de la lumière, avec un cache opaque posé sur une partie de la feuille. La température, elle, n''est pas l''une des trois conditions établies par ces expériences.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e42de770-7ccd-57ae-9d50-7b8e1b9ad950', '194de524-a981-5046-97c2-b5fd75a83615', 'Un dispositif mesure le taux d''oxygène du milieu autour d''une plante éclairée. Pour un certain éclairement, ce taux reste constant. Que cela signifie-t-il ?', '[{"id":"a","text":"Photosynthèse et respiration se compensent exactement"},{"id":"b","text":"La plante a cessé toute activité biologique"},{"id":"c","text":"La plante ne respire plus : seule la photosynthèse fonctionne"},{"id":"d","text":"La photosynthèse a atteint son intensité maximale"}]'::jsonb, 'a', 'Un taux d''oxygène constant signifie que la quantité d''O₂ rejetée par la photosynthèse est exactement égale à celle absorbée par la respiration : IPB = IR, donc IPN = 0. C''est le point de compensation ✓. La plante n''a pas cessé toute activité : les deux phénomènes tournent, mais ils s''annulent — c''est très différent. Elle ne cesse jamais non plus de respirer : la respiration se déroule 24 heures sur 24, et c''est justement pour cela qu''on ne mesure jamais qu''une intensité photosynthétique nette. Enfin le maximum de la photosynthèse correspond au palier de la courbe, atteint pour un éclairement bien supérieur.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c36f186f-3063-51cd-993c-dc9cec99830e', 'da09b891-f755-5773-8d01-3100b3d94215', 'svt-1ere-sec', '⭐ Exercice : L''usine à sucre de la feuille', 1, 50, 10, 'practice', 'admin', 1)
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
  ('a19b2ff8-2759-5da5-bc6e-38b3629751f0', 'c36f186f-3063-51cd-993c-dc9cec99830e', 'Qu''est-ce que la photosynthèse ?', '[{"id":"a","text":"La formation de matière organique qui nécessite de l''énergie lumineuse"},{"id":"b","text":"L''absorption d''eau et de sels minéraux par les racines"},{"id":"c","text":"La dégradation de matière organique pour produire de l''énergie utilisable"},{"id":"d","text":"La perte d''eau par les feuilles sous forme de vapeur"}]'::jsonb, 'a', 'La photosynthèse est la formation de matière organique, qui nécessite de l''énergie lumineuse ✓ ; seuls les organismes chlorophylliens la réalisent. L''absorption d''eau et de sels minéraux par les racines est la nutrition minérale, étudiée au chapitre précédent. La dégradation de matière organique pour produire de l''énergie est la respiration : la plante la pratique aussi, 24 heures sur 24, mais c''est le phénomène inverse. Et la perte d''eau sous forme de vapeur est la transpiration.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b090ddd8-59be-59ba-bb90-a5878b110d4f', 'c36f186f-3063-51cd-993c-dc9cec99830e', 'Dans le montage qui prive des feuilles de dioxyde de carbone, l''air du sac n° 2 barbote d''abord dans la potasse, puis dans l''eau de chaux. À quoi sert le second flacon ?', '[{"id":"a","text":"À absorber le dioxyde de carbone restant"},{"id":"b","text":"À contrôler que le dioxyde de carbone a bien été totalement absorbé"},{"id":"c","text":"À enrichir l''air en oxygène avant qu''il n''atteigne les feuilles du sac"},{"id":"d","text":"À humidifier l''air avant qu''il n''entre dans le sac"}]'::jsonb, 'b', 'C''est le premier flacon, celui de potasse, qui absorbe le dioxyde de carbone ; le second, à l''eau de chaux, sert à contrôler que le CO₂ a bien été totalement absorbé ✓. Sans lui, on ignorerait si le montage a réellement fait ce qu''on attend de lui — et toute la conclusion s''écroulerait. Il n''a donc pas pour rôle d''absorber à son tour, et il ne modifie ni l''oxygène ni l''humidité de l''air. Rappelle-toi aussi le rôle du sac n° 1, qui reçoit un air normal : c''est le témoin.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('78b78f9b-886e-59b5-926c-f9edf845f4d7', 'c36f186f-3063-51cd-993c-dc9cec99830e', 'Comment est faite une cellule d''un tube criblé, dans le phloème ?', '[{"id":"a","text":"C''est une cellule morte, réduite à sa paroi lignifiée"},{"id":"b","text":"C''est une cellule déjà morte, dont la paroi transversale est percée de pores"},{"id":"c","text":"C''est une cellule vivante, dont la paroi transversale est percée de pores"},{"id":"d","text":"C''est une cellule vivante, entièrement close, sans communication"}]'::jsonb, 'c', 'Les vaisseaux conducteurs de la sève élaborée forment le phloème : ce sont des tubes criblés, chacun formé d''une file de cellules vivantes dont les parois transversales sont percées de pores ✓. Comparées à une cellule normale, elles ont perdu leur noyau et leur vacuole, mais gardé leur cytoplasme et leur paroi cellulosique. La cellule morte réduite à sa paroi lignifiée décrit le vaisseau du bois, qui conduit la sève brute — et lui prêter des pores mélange les deux organes. Enfin, une cellule entièrement close ne laisserait rien circuler : ce sont justement les pores qui font le crible du tube criblé.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7c000b2d-a785-5dd1-957b-e13aa54f37fd', 'c36f186f-3063-51cd-993c-dc9cec99830e', 'L''intensité photosynthétique peut se mesurer par :', '[{"id":"a","text":"la quantité de lumière reçue par unité de surface de feuille"},{"id":"b","text":"la quantité d''O₂ rejeté par unité de masse et par unité de temps"},{"id":"c","text":"la masse sèche produite par la plante au bout d''un mois de culture"},{"id":"d","text":"le nombre de chloroplastes contenus dans une cellule"}]'::jsonb, 'b', 'L''intensité photosynthétique est la quantité de dioxyde de carbone absorbé, ou d''oxygène rejeté, par unité de masse du végétal et par unité de temps ✓ : ce sont les deux manifestations gazeuses de la photosynthèse, et l''une ou l''autre suffit à la mesurer. L''éclairement est un facteur qui la fait varier, pas sa mesure. La masse sèche produite en un mois mesure la production végétale : il y manque la masse du végétal, donc ce n''est pas une intensité. Et le nombre de chloroplastes ne dit rien de leur activité.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f850f95b-136b-5c31-bb57-875cc4a1461a', 'c36f186f-3063-51cd-993c-dc9cec99830e', 'Quelle est l''équation globale de la photosynthèse ?', '[{"id":"a","text":"C₆H₁₂O₆ + 6 O₂ → 6 CO₂ + 6 H₂O"},{"id":"b","text":"6 CO₂ + 6 O₂ → C₆H₁₂O₆ + 6 H₂O"},{"id":"c","text":"2 H₂O → O₂ + 4 H⁺ + 4 e⁻"},{"id":"d","text":"6 CO₂ + 6 H₂O → C₆H₁₂O₆ + 6 O₂"}]'::jsonb, 'd', 'La photosynthèse part de matières premières minérales — le dioxyde de carbone et l''eau — pour fabriquer du glucose en rejetant de l''oxygène : 6 CO₂ + 6 H₂O → C₆H₁₂O₆ + 6 O₂ ✓, sous les conditions de lumière et de chlorophylle. L''équation qui consomme le glucose et l''oxygène pour rendre du CO₂ et de l''eau est la même, écrite à l''envers. Celle qui fait entrer l''oxygène comme matière première se trompe de camp : l''oxygène est un produit. Quant à 2 H₂O → O₂ + 4 H⁺ + 4 e⁻, elle est exacte, mais c''est la photolyse de l''eau : une seule réaction de la phase photochimique, pas le bilan global.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fe53f4af-f844-5250-b629-d6bb89028ce2', 'c36f186f-3063-51cd-993c-dc9cec99830e', 'À partir de quelle teneur en nitrates une eau ne doit-elle plus être consommée du tout ?', '[{"id":"a","text":"6 mg/l"},{"id":"b","text":"50 mg/l"},{"id":"c","text":"100 mg/l"},{"id":"d","text":"300 mg/l"}]'::jsonb, 'c', 'Une eau contenant plus de 100 mg/l de nitrates ne doit pas être consommée ✓. En dessous, le texte fixe deux autres paliers : une eau destinée à la consommation humaine doit avoir une teneur inférieure ou égale à 50 mg/l — c''est le seuil au-delà duquel la maladie peut apparaître — et, entre 50 et 100 mg/l, l''eau reste utilisable sauf pour les femmes enceintes et les nourrissons de moins de 6 mois. Le nombre 6 est précisément cet âge en mois, pas une teneur ; et 300 mg/l ne correspond à aucun seuil.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('9b5b7c6a-148c-5478-93da-b16535b99a16', 'da09b891-f755-5773-8d01-3100b3d94215', 'svt-1ere-sec', '⭐⭐ Révision (type examen) : Photosynthèse, sève élaborée et facteurs limitants', 2, 75, 15, 'practice', 'admin', 3)
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
  ('09dce64e-c683-5928-a806-eb08a471da9b', '9b5b7c6a-148c-5478-93da-b16535b99a16', 'En 1951, Gaffron apporte du dioxyde de carbone radioactif à des algues fortement éclairées, puis les place à l''obscurité. Le carbone continue d''être incorporé pendant 15 à 20 secondes, à condition que les algues aient reçu au préalable au moins 10 minutes de forte lumière ; sans cette illumination, l''incorporation cesse aussitôt. Que conclut-on ?', '[{"id":"a","text":"Que l''incorporation du CO₂ utilise l''énergie stockée à la lumière"},{"id":"b","text":"Que l''incorporation du CO₂ ne se produit qu''en pleine lumière"},{"id":"c","text":"Que la lumière ne joue aucun rôle dans la photosynthèse"},{"id":"d","text":"Que le CO₂ radioactif éclaire les algues pendant 15 à 20 secondes"}]'::jsonb, 'a', 'Si l''incorporation du carbone se poursuit 15 à 20 secondes après l''extinction, c''est qu''elle ne réclame pas la lumière à l''instant même. Et si elle exige quand même 10 minutes de forte lumière préalable, c''est que cette lumière a laissé quelque chose derrière elle : de l''énergie chimique stockée ✓. C''est exactement ce qui sépare la phase photochimique, qui se déroule à la lumière et stocke l''énergie, de la phase sombre, qui incorpore le CO₂ sans besoin direct de lumière. Soutenir que tout exige la pleine lumière est contredit par les 15 à 20 secondes d''incorporation à l''obscurité ; soutenir que la lumière ne joue aucun rôle est contredit par l''autre moitié de l''expérience, puisque sans les 10 minutes préalables tout s''arrête. Quant à faire du traceur radioactif une source lumineuse, cela n''a aucun sens.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1627a75b-f528-5ca9-9be0-57f70af79631', '9b5b7c6a-148c-5478-93da-b16535b99a16', 'On découpe en anneau l''écorce d''une tige. La plante reste alimentée en sève brute et la photosynthèse se poursuit normalement. Quelques heures plus tard, les substances organiques sont anormalement abondantes au-dessus de la zone décortiquée. Qu''en déduit-on ?', '[{"id":"a","text":"La sève brute circulait vers le bas et l''anneau l''a bloquée"},{"id":"b","text":"La sève élaborée circulait vers le haut et l''anneau l''a bloquée"},{"id":"c","text":"La sève élaborée circulait vers le bas et l''anneau l''a bloquée"},{"id":"d","text":"L''écorce fabrique elle-même les substances organiques"}]'::jsonb, 'c', 'Les substances organiques s''accumulent juste au-dessus de la coupure : elles arrivaient donc d''en haut, des feuilles, et n''ont pas pu passer. La sève élaborée descendait, et l''anneau d''écorce l''a bloquée ✓ — le bourrelet de cicatrisation se forme d''ailleurs au-dessus lui aussi, plusieurs semaines plus tard. La sève brute n''est pas concernée : l''énoncé précise que la plante reste alimentée, car elle circule dans le bois, à l''intérieur, et non dans l''écorce ; de toute façon, elle monte. Si la sève élaborée montait, l''accumulation se ferait en dessous de l''anneau — c''est le piège courant, qui consiste à ne pas regarder de quel côté du blocage la matière s''entasse. Enfin, l''écorce ne fabrique pas de matière organique : c''est la feuille qui la fabrique, à la lumière et grâce à la chlorophylle.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('90414dcf-d539-5199-99be-a07837dbe49a', '9b5b7c6a-148c-5478-93da-b16535b99a16', 'Six lots de jeunes plantes sont cultivés dans des conditions identiques, sauf l''éclairement. Après un mois, la masse sèche récoltée est de 2,5 g à 1000 lux, 5 g à 2000 lux, 12,5 g à 4000 lux, 17,5 g à 6000 lux, 20 g à 8000 lux et 20,5 g à 10 000 lux. Que montrent ces résultats ?', '[{"id":"a","text":"La production est proportionnelle à l''éclairement sur tout l''intervalle"},{"id":"b","text":"La production augmente avec l''éclairement, puis plafonne au-delà de 8000 lux"},{"id":"c","text":"La production diminue dès que l''éclairement dépasse 8000 lux"},{"id":"d","text":"L''éclairement n''a pas d''influence sur la production de matière sèche"}]'::jsonb, 'b', 'La masse sèche grimpe de 2,5 g à 20 g quand l''éclairement passe de 1000 à 8000 lux, puis ne gagne plus que 0,5 g entre 8000 et 10 000 lux : la production augmente d''abord fortement, puis plafonne ✓ — un autre facteur est devenu limitant. Elle n''est pas proportionnelle : en passant de 2000 à 4000 lux l''éclairement double, mais la production passe de 5 g à 12,5 g, soit un facteur 2,5 et non 2. Elle ne diminue pas non plus au-delà de 8000 lux : 20,5 g est supérieur à 20 g, l''augmentation est simplement devenue négligeable. Et prétendre que l''éclairement n''a pas d''influence est intenable : c''est le seul paramètre qui change entre les six lots, et la production est multipliée par 8.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('928b07f4-9368-5470-86e9-e0e86a536a0f', '9b5b7c6a-148c-5478-93da-b16535b99a16', 'L''épinard, la pomme de terre et la fougère n''atteignent pas leur intensité photosynthétique maximale au même éclairement : l''optimum de la fougère est obtenu pour un éclairement beaucoup plus faible. Comment nomme-t-on ces deux catégories de plantes ?', '[{"id":"a","text":"Plantes de soleil (fougère) et plantes d''ombre (épinard, pomme de terre)"},{"id":"b","text":"Plantes de jour et plantes de nuit"},{"id":"c","text":"Plantes chlorophylliennes et plantes non chlorophylliennes"},{"id":"d","text":"Plantes de soleil (épinard, pomme de terre) et plantes d''ombre (fougère)"}]'::jsonb, 'd', 'Certaines plantes n''atteignent leur optimum que sous un fort éclairement : ce sont les plantes de soleil, comme l''épinard et la pomme de terre. D''autres l''atteignent sous un éclairement beaucoup plus faible : ce sont les plantes d''ombre, comme la fougère ✓. Ranger la fougère parmi les plantes de soleil inverse les deux listes — c''est bien elle qui se contente de peu de lumière. Le partage chlorophyllien / non chlorophyllien n''a pas de sens ici : les trois espèces citées sont chlorophylliennes, sans quoi il n''y aurait aucune photosynthèse à mesurer. Et « plantes de nuit » n''existe pas : aucune plante ne photosynthétise sans lumière.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4fa20252-4e33-5378-adb2-98783f658dbb', '9b5b7c6a-148c-5478-93da-b16535b99a16', 'On mesure l''intensité photosynthétique d''une plante en fonction de la teneur de l''air en dioxyde de carbone : 1 à 0 %, 6 à 0,06 %, 10 à 0,12 %, 11 à 0,15 %, 11 à 0,18 % et 11 à 0,21 %. Un serriste décide d''enrichir l''atmosphère de sa serre de 0,15 % à 0,21 % de CO₂. Qu''obtiendra-t-il ?', '[{"id":"a","text":"Une intensité inchangée : un autre facteur est devenu limitant"},{"id":"b","text":"Une intensité multipliée par 1,4, comme la teneur en CO₂"},{"id":"c","text":"Une chute de l''intensité : à 0,21 %, le CO₂ est devenu toxique"},{"id":"d","text":"Une intensité nulle : à cette teneur, la plante ne respire plus"}]'::jsonb, 'a', 'À partir de 0,15 % la courbe forme un palier : l''intensité reste à 11, que l''air contienne 0,15 %, 0,18 % ou 0,21 % de CO₂. L''enrichissement ne changera donc rien ✓, et pour une raison précise : le CO₂ n''est plus le facteur qui limite le phénomène — un autre l''a remplacé, généralement la température ou l''éclairement. Le raisonnement proportionnel est le piège courant : la relation n''est à peu près linéaire qu''au début, entre 0 et 0,12 %. Le CO₂ devient bien toxique un jour, mais seulement au-delà de 0,3 % : on en est loin. Et la respiration ne s''arrête jamais, elle se déroule 24 heures sur 24.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ca3e8723-6581-5fa1-9b6a-988b944557e7', '9b5b7c6a-148c-5478-93da-b16535b99a16', 'Un arboriculteur place dans son verger de multiples diffuseurs de phéromone de synthèse. Par quel mécanisme cette technique fait-elle baisser la population de ravageurs ?', '[{"id":"a","text":"Les diffuseurs empoisonnent les mâles qui s''en approchent"},{"id":"b","text":"Les phéromones tuent les larves avant leur éclosion"},{"id":"c","text":"Le mâle ne distingue plus la piste de la femelle et ne la retrouve pas"},{"id":"d","text":"Les mâles, attirés dans des pièges, y sont capturés puis stérilisés par irradiation"}]'::jsonb, 'c', 'Dans les conditions normales, le mâle rejoint la femelle en suivant le flux d''air chargé de phéromones. En multipliant les diffuseurs de phéromone synthétique, on brouille cette piste : incapable de localiser une source plutôt qu''une autre, le mâle se trouve « confondu » et ne retrouve pas la femelle — les chances d''accouplement chutent et les effectifs baissent ✓. C''est la confusion des mâles. Les phéromones ne sont ni un poison ni un larvicide : ce sont des substances chimiques émises par les femelles pour attirer le partenaire sexuel, et la lutte biologique se sert de ce signal, jamais d''une toxicité. Le piège courant est de décrire l''autre technique fondée sur les phéromones — la stérilisation des mâles, où les diffuseurs sont placés dans des pièges et les mâles capturés puis irradiés avant d''être relâchés. Ici, il n''y a aucun piège : les diffuseurs sont en plein verger.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('7f91558c-7618-5982-baef-81925e952f79', 'c5edaf1a-f734-50f8-bea2-064b335edbcf', 'svt-1ere-sec', 'Test de compréhension ⭐ : La multiplication végétative', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('be73d5e3-1039-5dfb-82da-19796687e6ef', '7f91558c-7618-5982-baef-81925e952f79', 'Qu''est-ce qu''une bouture ?', '[{"id":"a","text":"Une graine sélectionnée pour son fort pouvoir germinatif"},{"id":"b","text":"Une portion de plante capable de régénérer les parties manquantes"},{"id":"c","text":"Un bourgeon prélevé pour être fixé sur une autre plante"},{"id":"d","text":"Une jeune plante issue de la reproduction sexuée"}]'::jsonb, 'b', 'Une bouture est une portion plus ou moins importante d''une plante — feuille, tige, rhizome — capable de régénérer les parties manquantes et de se développer totalement ✓ : mise à terre, elle s''enracine et donne une nouvelle plante. Une graine, comme une jeune plante issue d''un semis, relève de la reproduction sexuée, pas de la multiplication végétative. Et le bourgeon prélevé pour être fixé sur une autre plante est un greffon : il ne s''enracine pas, il se raccorde aux vaisseaux du porte greffe.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d0cb9d1b-054c-5c92-b59e-849adaab9a71', '7f91558c-7618-5982-baef-81925e952f79', 'Qu''est-ce qui distingue le marcottage du bouturage ?', '[{"id":"a","text":"Le marcottage n''emploie que des racines, le bouturage que des tiges"},{"id":"b","text":"La plante obtenue par marcottage diffère de la plante mère"},{"id":"c","text":"Le marcottage se pratique in vitro, le bouturage en pleine terre"},{"id":"d","text":"La tige n''est détachée de la plante mère qu''après son enracinement"}]'::jsonb, 'd', 'Dans le marcottage, on enterre une tige aérienne sans la détacher de la plante ; ce n''est qu''une fois les racines adventives formées qu''on isole la tige enracinée ✓. Dans le bouturage, au contraire, le fragment est détaché d''abord et s''enracine seul : c''est toute la différence, et elle tient à la chronologie. Les deux techniques emploient bien des tiges aériennes, et non des racines. Toutes deux conservent les caractères de la plante mère — c''est justement leur intérêt. Et aucune des deux ne se pratique in vitro : ce sont les techniques traditionnelles.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('95a19fac-1d90-527f-a28c-c57942c6bc24', '7f91558c-7618-5982-baef-81925e952f79', 'Après une greffe réussie, d''où viennent les racines de la nouvelle plante, et d''où viennent ses fruits ?', '[{"id":"a","text":"Les racines viennent du porte greffe, les fruits viennent du greffon"},{"id":"b","text":"Les racines viennent du greffon, les fruits viennent du porte greffe"},{"id":"c","text":"Les racines et les fruits viennent tous deux du greffon"},{"id":"d","text":"Les racines et les fruits viennent tous deux du porte greffe"}]'::jsonb, 'a', 'Le porte greffe conserve son appareil absorbant complet — ses racines — et une partie du tronc ; le greffon développe l''appareil assimilateur et de fructification (rameaux, tige, feuilles, fruits), à l''exclusion de toute racine ✓. La nouvelle plante porte donc les caractères de la plante qui a fourni le greffon, et c''est bien pour cela qu''on prélève ce dernier sur un végétal sélectionné pour la qualité de ses fruits ou de ses fleurs. Toute autre répartition se trompe sur au moins un des deux rôles.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('be512e27-4044-5f2f-940a-b523152a8bda', '7f91558c-7618-5982-baef-81925e952f79', 'Qu''est-ce qu''un clone ?', '[{"id":"a","text":"Une plante obtenue en croisant deux variétés différentes"},{"id":"b","text":"Un ensemble de graines produites par une même plante mère"},{"id":"c","text":"Un ensemble d''individus identiques issus d''un individu unique"},{"id":"d","text":"Une plante dont les caractères ont été améliorés au laboratoire"}]'::jsonb, 'c', 'Un clone est un ensemble d''individus possédant les mêmes caractères et provenant de la multiplication végétative d''un individu unique ✓ : toutes les plantes issues d''une même plante mère par bouturage, marcottage, greffage ou culture in vitro en forment un. Un croisement relève de la reproduction sexuée, et ses descendants ne sont justement pas identiques ; des graines non plus. Et la multiplication végétative n''améliore rien : elle conserve et multiplie ce que la plante mère avait déjà — c''est le choix de cette plante mère qui décide de tout.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('60c2aa9d-4ad7-562c-a6c9-51cc56144f19', '7f91558c-7618-5982-baef-81925e952f79', 'Quel est l''avantage décisif de la culture in vitro par rapport au bouturage traditionnel ?', '[{"id":"a","text":"Elle produit des plantes différentes de la plante mère, donc plus variées"},{"id":"b","text":"Elle produit un nombre bien plus grand de plantes dans le même temps"},{"id":"c","text":"Elle se pratique en pleine terre, sans matériel de laboratoire"},{"id":"d","text":"Elle permet de se passer de tout milieu nutritif"}]'::jsonb, 'b', 'En un an, le microbouturage in vitro donne 400 000 oliviers identiques à la plante d''origine, là où le bouturage traditionnel n''en donnerait dans le même temps qu''une vingtaine ✓ : c''est un changement d''échelle. Les plantes obtenues ne sont pas plus variées — elles forment justement un clone, toutes identiques à la plante de départ. Et la technique ne se pratique ni en pleine terre ni sans milieu nutritif : elle exige des conditions d''asepsie, et c''est bien sur un milieu nutritif que chaque microbouture est mise en culture.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('227a9291-489c-5ecf-acd2-9c5c64e2961f', 'c5edaf1a-f734-50f8-bea2-064b335edbcf', 'svt-1ere-sec', '⭐ Exercice : Boutures, greffes et éprouvettes', 1, 50, 10, 'practice', 'admin', 1)
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
  ('5ef56731-c4c9-5f6f-b1c8-c6bef53cfe5d', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'Le tubercule de pomme de terre permet la multiplication végétative. De quel organe s''agit-il exactement ?', '[{"id":"a","text":"D''une racine gonflée de réserves"},{"id":"b","text":"D''une portion de tige souterraine portant des bourgeons"},{"id":"c","text":"D''un bulbe formé de feuilles serrées les unes contre les autres"},{"id":"d","text":"D''un fruit souterrain contenant des graines"}]'::jsonb, 'b', 'Le tubercule de pomme de terre est une partie d''une tige souterraine qui porte des bourgeons ✓ — et c''est précisément pour cela qu''il multiplie la plante : un seul bourgeon isolé suffit à fournir un plant normal producteur de tubercules normaux. Ce n''est ni une racine ni un bulbe : le tubercule est une tige, reconnaissable à ses bourgeons. Et ce n''est pas un fruit : un fruit contiendrait des graines et relèverait donc de la reproduction sexuée, alors que planter un tubercule est bien une multiplication végétative.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e9f3d64e-29c6-5e34-964b-43c05f5a88bd', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'Un rameau feuillé de pélargonium est enfoncé dans de la terre humide. Qu''apparaît-il dans la partie enterrée, au voisinage de la section ?', '[{"id":"a","text":"Des bourgeons floraux"},{"id":"b","text":"Un cal, et rien d''autre ensuite"},{"id":"c","text":"Des racines adventives"},{"id":"d","text":"Des tubercules"}]'::jsonb, 'c', 'Des racines adventives apparaissent dans la partie enterrée, au voisinage de la section ✓ ; la partie aérienne s''accroît alors, se ramifie et engendre des feuilles — le rameau isolé est ainsi à l''origine d''une nouvelle plante. Des bourgeons floraux ne sont pas ce que produit la section. Le cal existe bien, mais il est décrit chez l''olivier en bouturage semi-ligneux, et il précède justement l''émission des racines : la bouture ne s''arrête pas là. Quant aux tubercules, ce sont des tiges souterraines de réserve produites par le plant de pomme de terre.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3364383e-d368-5784-86f2-de778373c561', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'Dans une greffe, comment appelle-t-on la plante sur laquelle on fixe le fragment prélevé ?', '[{"id":"a","text":"Le porte greffe"},{"id":"b","text":"Le greffon"},{"id":"c","text":"La marcotte"},{"id":"d","text":"Le végétal franc"}]'::jsonb, 'a', 'Le porte greffe est la plante sur laquelle on fixe le greffon ✓. Le greffon, lui, est le fragment prélevé — un bourgeon ou un jeune rameau — sur un végétal sélectionné pour la qualité de ses fruits ou de ses fleurs : c''est l''inverse du rôle demandé. La marcotte appartient à une autre technique, le marcottage. Quant au végétal franc, c''est un végétal provenant des semis : il sert souvent de porte greffe (pommier franc, amandier franc), mais le terme désigne son origine, pas son rôle dans la greffe.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('45559784-8b76-5964-8436-c523028c5c23', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'En un an, le microbouturage in vitro permet d''obtenir combien d''oliviers identiques à la plante d''origine, là où le bouturage traditionnel n''en donne qu''une vingtaine ?', '[{"id":"a","text":"400"},{"id":"b","text":"4000"},{"id":"c","text":"40 000"},{"id":"d","text":"400 000"}]'::jsonb, 'd', 'En un an, la culture in vitro par microbouturage donne 400 000 oliviers identiques à la plante d''origine ✓, contre une vingtaine seulement par bouturage traditionnel dans le même temps. Aucun des ordres de grandeur plus modestes ne rend justice à ce que permet la technique : ce n''est pas un gain marginal mais un changement d''échelle, rendu possible par la répétition des étapes de fragmentation, de remise sur milieu nutritif et de développement — chaque cycle multipliant à nouveau le nombre de microboutures.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8ae48a12-409a-5862-8d8b-fd5717b60f6b', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'Le bouturage semi-ligneux de l''olivier réclame une température et une humidité ambiante précises. Lesquelles ?', '[{"id":"a","text":"5 à 10 °C, et une humidité inférieure à 20 %"},{"id":"b","text":"23 à 25 °C, et une humidité supérieure à 80 %"},{"id":"c","text":"23 à 25 °C, et une humidité inférieure à 20 %"},{"id":"d","text":"5 à 10 °C, et une humidité supérieure à 80 %"}]'::jsonb, 'b', 'On enracine la bouture d''olivier à une température de 23 à 25 °C et sous une humidité ambiante supérieure à 80 % ✓ ; un cal se développe alors au bout de quelques semaines, et les racines apparaissent vers 8 semaines. Ni une température de 5 à 10 °C ni une atmosphère sèche ne figurent au protocole. Et la forte humidité n''est pas un détail : tant que la bouture n''a pas de racines, elle ne peut pas remplacer l''eau qu''elle perd.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1112df0f-2cc9-57eb-8626-75a1f48d6489', '227a9291-489c-5ecf-acd2-9c5c64e2961f', 'Pourquoi qualifie-t-on de « totipotentes » les cellules du bourgeon prélevé pour le microbouturage ?', '[{"id":"a","text":"Parce qu''elles se divisent indéfiniment sans jamais mourir"},{"id":"b","text":"Parce qu''elles résistent à toutes les maladies de la plante"},{"id":"c","text":"Parce qu''elles peuvent donner n''importe quelle partie de la plante"},{"id":"d","text":"Parce qu''elles contiennent toutes les substances nutritives utiles"}]'::jsonb, 'c', 'Le bourgeon d''une microbouture renferme des cellules embryonnaires dites totipotentes : elles sont capables de se développer pour donner n''importe quelle partie de la plante — tige, racine, feuille ✓. C''est cette propriété, la totipotence, qui rend la reproduction végétative possible : une seule cellule peut donner n''importe quel organe. Ni une division illimitée, ni une résistance aux maladies, ni une réserve de nutriments ne sont ce que le mot désigne — ce sont d''ailleurs bien des maladies à virus que la culture des méristèmes cherche à éliminer, et le milieu nutritif est apporté de l''extérieur, pas contenu dans la cellule.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('fbb8b06e-5283-56bb-972b-345b39829387', 'c5edaf1a-f734-50f8-bea2-064b335edbcf', 'svt-1ere-sec', '⭐⭐ Révision (type examen) : Du greffon au clone', 2, 75, 15, 'practice', 'admin', 3)
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
  ('d89a6f15-c64b-5dfa-b278-ec3148730ddd', 'fbb8b06e-5283-56bb-972b-345b39829387', 'Un fragment de tubercule de pomme de terre planté en automne donne un pied qui produit 15 à 30 tubercules, récoltés au printemps. Une graine de pomme de terre, elle, ne donne un plant à tubercules normaux qu''au bout de quatre ans. Que montre cette comparaison ?', '[{"id":"a","text":"La multiplication végétative donne un meilleur rendement, plus vite"},{"id":"b","text":"La reproduction sexuée est plus rapide que la multiplication végétative"},{"id":"c","text":"Les deux modes donnent le même résultat dans le même temps"},{"id":"d","text":"La graine de pomme de terre est incapable de germer"}]'::jsonb, 'a', 'Quatre ans par la graine, contre une seule saison — de l''automne au printemps — par le fragment de tubercule, et 15 à 30 tubercules à la clé : la multiplication végétative permet un rendement meilleur et dans un délai court ✓. Soutenir que la reproduction sexuée est plus rapide inverse exactement la comparaison, et prétendre que les deux modes se valent revient à ignorer l''écart de quatre ans. Enfin, la graine germe bel et bien et donne un plant : il lui faut simplement quatre ans pour produire des tubercules normaux.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2b4dbb2c-1146-5029-8f9d-11c0f0067ec4', 'fbb8b06e-5283-56bb-972b-345b39829387', 'On greffe en écusson un greffon d''abricotier sur un porte greffe d''amandier franc. Quels fruits portera la nouvelle plante ?', '[{"id":"a","text":"Des amandes, puisque les racines sont celles de l''amandier"},{"id":"b","text":"Des abricots, puisque le greffon vient de l''abricotier"},{"id":"c","text":"Un mélange d''abricots et d''amandes"},{"id":"d","text":"Aucun fruit : greffer deux espèces différentes rend la plante stérile"}]'::jsonb, 'b', 'Le greffon développe l''appareil assimilateur et de fructification — rameaux, tige, feuilles, fruits — et la nouvelle plante porte les caractères de la plante qui a fourni le greffon : elle donnera donc des abricots ✓. Le porte greffe, lui, ne fournit que l''appareil absorbant (les racines) et une partie du tronc. Le piège courant est de croire que la racine décide du fruit, et d''attendre des amandes. Il n''y a pas non plus de mélange : chaque partie garde son identité. Et la greffe n''est pas stérile : greffon et porte greffe appartiennent à la même espèce ou à des espèces voisines, et le tableau des possibilités de greffage donne justement ce couple abricotier / amandier franc, en écusson, au mois de mai.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ada3ea63-8e05-59da-b2e8-d839fa08f014', 'fbb8b06e-5283-56bb-972b-345b39829387', 'Le clonage in vitro d''un rosier part d''un explant — un bourgeon — mis en culture en conditions aseptiques sur un milieu nutritif, et aboutit à 200 000 à 400 000 rosiers. Quelle étape, entre les deux, explique ce nombre ?', '[{"id":"a","text":"L''enracinement des plantules avant leur mise en pot"},{"id":"b","text":"La mise en pot sous serre des plantules enracinées"},{"id":"c","text":"La fragmentation répétée de la bouture en de nombreuses microboutures"},{"id":"d","text":"L''acclimatation progressive des plants aux conditions extérieures"}]'::jsonb, 'c', 'Entre l''explant unique et les centaines de milliers de plants, une seule étape multiplie : la fragmentation de la bouture obtenue en de nombreuses microboutures, chacune remise en culture — et l''opération se répète plusieurs fois ✓. C''est ce cycle qui fait passer de 1 bourgeon à « nombreuses boutures », puis à 200 000 à 400 000 plantules. L''enracinement, la mise en pot et l''acclimatation sont des étapes indispensables, mais elles ne font que mener à terme des plants déjà obtenus : aucune ne crée un individu de plus.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('01e92174-0fd1-5e71-a5f9-ba16e036f152', 'fbb8b06e-5283-56bb-972b-345b39829387', 'Un local de culture in vitro climatisé de 9 m² remplace 25 500 m² de serres chauffées ou refroidies selon la saison. Par combien la surface nécessaire est-elle approximativement divisée ?', '[{"id":"a","text":"Par 30 environ"},{"id":"b","text":"Par 300 environ"},{"id":"c","text":"Par 2800 environ"},{"id":"d","text":"Par 28 000 environ"}]'::jsonb, 'c', '25 500 / 9 ≈ 2833 : la surface nécessaire est divisée par 2800 environ ✓. Les rapports de 30 et de 300 sous-estiment d''un facteur 100 et 10 ; celui de 28 000 surestime d''un facteur 10. Retiens surtout ce que ce chiffre signifie : au-delà de l''espace, c''est le chauffage et la climatisation de plusieurs hectares de serres qui sont économisés — un grand producteur d''œillets obtient d''ailleurs en deux ans, par la culture in vitro, ce qu''il produisait en quatre ans par la culture traditionnelle.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b51d95dc-789a-52c6-bcf8-039d9a13dca2', 'fbb8b06e-5283-56bb-972b-345b39829387', 'Une culture de pomme de terre est ravagée par des maladies à virus. Un agronome veut en obtenir des plants sains, sans perdre la variété qu''il cultive. Que doit-il faire ?', '[{"id":"a","text":"Replanter les tubercules de la culture atteinte, après les avoir triés"},{"id":"b","text":"Croiser cette variété avec une autre et semer les graines obtenues"},{"id":"c","text":"Bouturer des fragments de tiges prélevés sur la culture atteinte"},{"id":"d","text":"Prélever des cellules méristématiques et les cultiver in vitro"}]'::jsonb, 'd', 'Des clones sains ont pu être reconstitués grâce à la culture des cellules méristématiques : c''est l''un des trois grands intérêts de la culture in vitro ✓, et le seul moyen qui réponde ici aux deux exigences à la fois — éliminer la maladie et garder la variété. Replanter les tubercules ou bouturer des fragments de la culture atteinte, c''est repartir de la plante malade elle-même : rien, dans ces techniques, n''est présenté comme éliminant la maladie — la multiplication végétative conserve les caractères de la plante mère, c''est son principe même. Quant au croisement, il relève de la reproduction sexuée : les descendants issus de graines ne sont justement pas identiques entre eux, et l''agronome perdrait la variété qu''il cherche à sauver.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3bccf06b-e7b6-5bf7-b3cc-3aa369a65ea1', 'fbb8b06e-5283-56bb-972b-345b39829387', 'Un agriculteur clone in vitro un plant de vigne médiocre, en espérant que la technique améliore sa production. Qu''obtiendra-t-il ?', '[{"id":"a","text":"Des milliers de plants aussi médiocres que le plant de départ"},{"id":"b","text":"Des plants améliorés : la culture in vitro sélectionne les meilleures cellules"},{"id":"c","text":"Des plants tous différents les uns des autres"},{"id":"d","text":"Des plants améliorés : le milieu nutritif enrichit les caractères de la plante"}]'::jsonb, 'a', 'La culture in vitro produit un clone : un ensemble d''individus possédant les mêmes caractères que l''individu unique dont ils proviennent. Elle conserve donc à l''identique la médiocrité du plant de départ — et la multiplie par des milliers ✓. C''est le piège le plus courant du chapitre : croire que la technique améliore, que ce soit par une prétendue sélection des meilleures cellules ou par la vertu du milieu nutritif. Elle ne fait que conserver et multiplier, et c''est bien pour cela qu''on prélève toujours la microbouture sur une plante performante, sélectionnée pour son rendement, sa qualité ou sa résistance aux maladies. Enfin les plants ne seront pas différents entre eux : ils sont tous identiques, c''est la définition même du clone.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bc4dc18c-ab71-558f-b433-660d14f30960', 'd0a86148-bdad-5274-8564-f6d944ce6b13', 'svt-1ere-sec', 'Test de compréhension ⭐ : La diversité du monde microbien', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('93db0bf6-4904-59ee-8216-d62070775e36', 'bc4dc18c-ab71-558f-b433-660d14f30960', 'En combien de groupes classe-t-on les micro-organismes, et lesquels ?', '[{"id":"a","text":"2 groupes : les microbes utiles et les microbes pathogènes"},{"id":"b","text":"3 groupes : les bactéries, les champignons et les virus"},{"id":"c","text":"4 groupes : les protozoaires, les bactéries, les champignons et les virus"},{"id":"d","text":"4 groupes : les bacilles, les coques, les moisissures et les bactériophages"}]'::jsonb, 'c', 'On classe les micro-organismes en quatre groupes : les protozoaires, les bactéries, les champignons microscopiques et les virus ✓, qui diffèrent par leur taille, leur forme et leur mode d''action sur l''organisme. La distinction utiles / pathogènes est réelle, mais elle traverse les quatre groupes au lieu de les remplacer. S''en tenir aux bactéries, aux champignons et aux virus oublie les protozoaires. Et la liste bacilles / coques / moisissures / bactériophages mélange les niveaux : bacilles et coques sont des formes de bactéries, les moisissures une catégorie de champignons, les bactériophages une sorte de virus — ce sont des subdivisions, pas les groupes eux-mêmes.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bbecd10e-a6e6-5a5d-bb10-5a2ef046d067', 'bc4dc18c-ab71-558f-b433-660d14f30960', 'Que signifie « procaryote » ?', '[{"id":"a","text":"Un être vivant dont la cellule ne contient pas un véritable noyau"},{"id":"b","text":"Un être vivant constitué d''une seule cellule"},{"id":"c","text":"Un être vivant qui cause une maladie"},{"id":"d","text":"Un être vivant dont la cellule est entièrement dépourvue de cytoplasme"}]'::jsonb, 'a', 'Procaryote signifie : un être vivant constitué d''une cellule ne contenant pas un véritable noyau ✓ — son matériel génétique baigne directement dans le cytoplasme, sans membrane pour l''entourer. Exemples : les bactéries, les algues bleues. Être formé d''une seule cellule, c''est être unicellulaire : la paramécie l''est aussi, et pourtant elle possède un vrai noyau — c''est une eucaryote. Causer une maladie, c''est être pathogène. Et un procaryote a bien un cytoplasme : c''est justement là que baigne son matériel génétique.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9cbf896b-6c63-553c-88c3-fba80035bffd', 'bc4dc18c-ab71-558f-b433-660d14f30960', 'Pourquoi dit-on du virus que c''est un « parasite intracellulaire obligatoire » ?', '[{"id":"a","text":"Parce qu''il vit collé à la surface des cellules"},{"id":"b","text":"Parce qu''il ne peut se multiplier qu''à l''intérieur d''une cellule vivante"},{"id":"c","text":"Parce qu''il détruit obligatoirement la cellule vivante dans laquelle il pénètre"},{"id":"d","text":"Parce qu''il ne parasite que les cellules humaines"}]'::jsonb, 'b', 'Un virus est inerte dans le milieu extérieur : il ne respire pas et ne se reproduit pas. Il ne peut se multiplier qu''à l''intérieur d''une cellule vivante, la cellule hôte ✓ — d''où « intracellulaire » et « obligatoire ». Il ne vit pas collé à la surface : il doit pénétrer dans la cellule pour manifester la moindre activité. La destruction de la cellule n''est pas ce que le terme désigne. Et il ne parasite pas que les cellules humaines : la cellule hôte peut être animale, végétale ou bactérienne — les bactériophages sont précisément des virus qui infectent les bactéries.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d67fe435-439d-5cdd-b681-1444debbd583', 'bc4dc18c-ab71-558f-b433-660d14f30960', 'Pourquoi la levure de bière est-elle qualifiée de champignon « unicellulaire » ?', '[{"id":"a","text":"Parce qu''elle vit isolée, jamais en groupe"},{"id":"b","text":"Parce qu''elle ne possède qu''un seul type de cellule, toujours le même"},{"id":"c","text":"Parce qu''elle mesure moins de 10 μm"},{"id":"d","text":"Parce que chaque individu est formé d''une seule cellule"}]'::jsonb, 'd', 'La levure de bière est constituée de cellules sphériques ou ovoïdes de 6 à 10 μm, et chaque individu est une cellule unique ✓ : voilà pourquoi on la dit unicellulaire. C''est ce qui l''oppose aux champignons filamenteux — moisissures, trichophyton, Phytophtora — dont le corps est un mycélium fait de filaments. Vivre isolée n''est pas la question : le bourgeonnement produit justement des cellules groupées. Le nombre de types de cellules ne définit pas non plus le mot, pas plus que la taille : une bactérie mesure elle aussi moins de 10 μm sans être un champignon.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('86b52802-4f18-5911-b9c3-8708c3435d2f', 'bc4dc18c-ab71-558f-b433-660d14f30960', 'Diplocoques, streptocoques et staphylocoques sont trois sortes de coques. Sur quel critère les classe-t-on ?', '[{"id":"a","text":"Sur leur mode de groupement : par deux, en chaîne ou en grappe"},{"id":"b","text":"Sur la forme de chaque coque prise isolément : ronde, allongée ou spiralée"},{"id":"c","text":"Sur leur taille : petite, moyenne ou grande"},{"id":"d","text":"Sur la maladie qu''elles provoquent"}]'::jsonb, 'a', 'Les coques sont toutes des bactéries en forme de granules : c''est leur groupement qui les distingue — un diplocoque est fait de 2 coques, un streptocoque d''une chaîne de coques, un staphylocoque d''un ensemble de coques en grappe ✓. Leur forme individuelle ne varie pas : elles sont rondes dans les trois cas, et une bactérie en bâtonnet serait un bacille, pas une coque. La taille n''est pas le critère retenu. Quant à la maladie, c''est une conséquence du classement et non son critère : ce sont deux diplocoques différents, le méningocoque et le pneumocoque, qui donnent la méningite et la pneumonie.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6642bf10-24ef-5328-a3c5-04d817695cfe', 'd0a86148-bdad-5274-8564-f6d944ce6b13', 'svt-1ere-sec', '⭐ Exercice : Reconnaître un microbe', 1, 50, 10, 'practice', 'admin', 1)
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
  ('7a9274b5-d2b7-5f8c-8564-d7acc37e018a', '6642bf10-24ef-5328-a3c5-04d817695cfe', 'Où vit la paramécie, et est-elle dangereuse pour l''homme ?', '[{"id":"a","text":"Dans les eaux stagnantes ; c''est un micro-organisme inoffensif"},{"id":"b","text":"Dans le gros intestin ; elle cause la dysentérie amibienne"},{"id":"c","text":"Dans le sol ; elle décompose la matière organique des déchets"},{"id":"d","text":"Sur la peau ; elle provoque des furoncles et des abcès"}]'::jsonb, 'a', 'La paramécie est un animal unicellulaire des eaux stagnantes, et c''est un micro-organisme inoffensif ✓ — on l''obtient en laissant une semaine de l''eau et du foin dans un cristallisoir, à l''abri du soleil et à 25 à 30 °C. Le gros intestin et la dysentérie amibienne sont l''affaire de l''amibe dysentérique, l''autre protozoaire du chapitre : elle, elle est pathogène. La décomposition de la matière organique est le travail des bactéries du sol. Et les furoncles sont l''œuvre des staphylocoques.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('90d6ba8c-fca4-5f7d-9674-138b16f9463f', '6642bf10-24ef-5328-a3c5-04d817695cfe', 'À quoi servent les pseudopodes de l''amibe ?', '[{"id":"a","text":"À la respiration et à l''excrétion"},{"id":"b","text":"À la reproduction et à l''enkystement"},{"id":"c","text":"Au déplacement et à la nutrition"},{"id":"d","text":"À la fixation sur la paroi de l''intestin"}]'::jsonb, 'c', 'Le cytoplasme de l''amibe forme des prolongements, les pseudopodes, qui assurent le déplacement et la nutrition ✓. La respiration et l''excrétion ne leur sont pas attribuées. L''enkystement est un phénomène distinct : lorsque les conditions sont défavorables, l''amibe s''enkyste — et ce sont ces kystes, ingérés avec de l''eau ou des aliments souillés, qui se transforment en amibes dans le tube digestif. Enfin les pseudopodes ne servent pas à se fixer : ils sont au contraire l''organe du mouvement.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('24fecb22-d64c-5d54-a8bf-9306088600b2', '6642bf10-24ef-5328-a3c5-04d817695cfe', 'Placée dans des conditions favorables, Eschérishia Coli s''allonge et se divise en deux. À quel rythme ?', '[{"id":"a","text":"Toutes les 20 secondes"},{"id":"b","text":"Toutes les 20 minutes"},{"id":"c","text":"Toutes les 20 heures"},{"id":"d","text":"Tous les 20 jours"}]'::jsonb, 'b', 'Deux nouvelles bactéries se forment à partir d''une bactérie initiale toutes les 20 minutes ✓ : ce mode de division est la bipartition, et c''est lui qui donne aux bactéries leur grande capacité de multiplication dès que le milieu leur est favorable. En une heure, cela fait 3 divisions — une bactérie en devient 8. Ni les 20 secondes, ni les 20 heures, ni les 20 jours ne correspondent à ce que l''on observe en culture.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ab63dbd7-8a4d-5dba-af67-419ec79cb5a6', '6642bf10-24ef-5328-a3c5-04d817695cfe', 'De quel micro-organisme la pénicilline est-elle tirée ?', '[{"id":"a","text":"De la levure de bière"},{"id":"b","text":"D''une bactérie lactique"},{"id":"c","text":"De l''amibe dysentérique"},{"id":"d","text":"Du Pénicillium notatum"}]'::jsonb, 'd', 'Le Pénicillium notatum, ou Pénicille, est une moisissure verte à partir de laquelle est fabriquée la pénicilline, un antibiotique ✓ : c''est l''exemple type du microbe utile, cultivé par l''homme pour un usage médical. La levure de bière sert, elle, à fabriquer le pain, le vin, la bière et le cidre. Les bactéries lactiques transforment le lait en yaourt. Quant à l''amibe dysentérique, c''est un protozoaire pathogène, agent de l''amibiase.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('dbb47327-f7c2-56bf-a720-d139236eb74c', '6642bf10-24ef-5328-a3c5-04d817695cfe', 'Sur un microscope, l''oculaire porte l''indication × 15 et l''objectif × 40. Quel est le grossissement de l''observation ?', '[{"id":"a","text":"× 2,7"},{"id":"b","text":"× 40"},{"id":"c","text":"× 55"},{"id":"d","text":"× 600"}]'::jsonb, 'd', 'Le grossissement du microscope est le produit de celui de l''oculaire par celui de l''objectif : 15 × 40 = 600 ✓. Trouver 55 revient à additionner au lieu de multiplier (15 + 40) — c''est le piège courant. Trouver 40 revient à ne retenir que l''objectif et à oublier l''oculaire. Et trouver 2,7 revient à diviser (40 / 15), ce qui n''aurait aucun sens : un microscope grossit, il ne réduit pas.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('89651317-3ca1-5eb4-8fb2-fdc64e1b0b06', '6642bf10-24ef-5328-a3c5-04d817695cfe', 'Les bactéries du sol décomposent la matière organique des cadavres et des déchets animaux et végétaux. En quoi la transforment-elles, et comment nomme-t-on ce processus ?', '[{"id":"a","text":"En humus et en eau ; c''est la fermentation"},{"id":"b","text":"En sels minéraux et en dioxyde de carbone ; c''est la minéralisation"},{"id":"c","text":"En matière organique nouvelle ; c''est la photosynthèse"},{"id":"d","text":"En nitrates et en oxygène ; c''est la respiration"}]'::jsonb, 'b', 'Les bactéries du sol transforment la matière organique des cadavres et des déchets en sels minéraux et en dioxyde de carbone, qui se dégage dans l''air : ce processus est la minéralisation ✓, et il restitue au sol les sels minéraux puisés par les plantes — c''est exactement ce qui fait fonctionner la fertilisation organique vue au chapitre 1. La fermentation est une autre capacité bactérienne, employée pour produire fromages, yaourts et vinaigres. La photosynthèse fabrique de la matière organique au lieu de la décomposer, et elle est l''œuvre des végétaux chlorophylliens. Quant aux nitrates, ils apparaissent bien dans le sol, mais au terme de la minéralisation de l''azote organique — et ce processus ne s''appelle pas la respiration.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4d10426c-9477-5321-8749-0ae925f7c072', 'd0a86148-bdad-5274-8564-f6d944ce6b13', 'svt-1ere-sec', '⭐⭐ Révision (type examen) : Procaryotes, virus et calculs au microscope', 2, 75, 15, 'practice', 'admin', 3)
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
  ('49aa94ef-d027-5918-940e-187e21d1fb75', '4d10426c-9477-5321-8749-0ae925f7c072', '« La levure de bière est une bactérie. » Pourquoi cette phrase est-elle fausse ?', '[{"id":"a","text":"La levure de bière est un champignon unicellulaire, pas une bactérie"},{"id":"b","text":"La levure de bière est un protozoaire, pas une bactérie"},{"id":"c","text":"La levure de bière est un virus, pas une bactérie"},{"id":"d","text":"La phrase est en réalité exacte"}]'::jsonb, 'a', 'La levure de bière est un champignon unicellulaire, formé de cellules sphériques ou ovoïdes de 6 à 10 μm qui se multiplient par bourgeonnement ✓. Une bactérie, elle, est un procaryote qui se multiplie par bipartition : ni le groupe, ni la structure, ni le mode de multiplication ne coïncident. Ce n''est pas non plus un protozoaire, qui serait un animal unicellulaire, ni un virus, qui n''aurait aucune organisation cellulaire. Et la phrase n''est pas exacte : les quatre groupes de micro-organismes sont bien distincts.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c6be8323-1727-5529-b909-6c6305de34d1', '4d10426c-9477-5321-8749-0ae925f7c072', 'Deux micro-organismes sont schématisés au microscope électronique. Le premier montre une capsule et du matériel génétique, sans cytoplasme. Le second montre un cytoplasme entouré d''une membrane cytoplasmique, dans lequel baigne un matériel génétique non délimité par une membrane, le tout entouré d''une paroi. Que sont-ils ?', '[{"id":"a","text":"Le premier est une bactérie, le second un virus"},{"id":"b","text":"Le premier est un virus, le second une bactérie"},{"id":"c","text":"Les deux sont des bactéries"},{"id":"d","text":"Les deux sont des protozoaires"}]'::jsonb, 'b', 'Le premier est formé d''un matériel génétique et d''une capsule, et ne renferme pas de cytoplasme : il n''a donc pas l''organisation d''une cellule — c''est un virus. Le second est constitué d''un cytoplasme entouré d''une membrane cytoplasmique, dans lequel baigne un matériel génétique non limité par une membrane, et d''une paroi : c''est une bactérie, et cette description est celle même d''une cellule procaryote ✓. Le piège courant est d''intervertir les deux, en croyant que le plus simple des schémas doit être la bactérie. Aucun des deux n''est un protozoaire : un protozoaire est un animal unicellulaire, à noyau entouré d''une membrane. Et les deux schémas ne peuvent pas représenter deux bactéries : le premier n''a même pas de cytoplasme.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8b73e34e-fb2e-50d1-a37f-d3abdbdcce6c', '4d10426c-9477-5321-8749-0ae925f7c072', 'La paramécie et la bactérie sont toutes deux des micro-organismes unicellulaires. Qu''est-ce qui les sépare fondamentalement ?', '[{"id":"a","text":"La bactérie a un véritable noyau, la paramécie non"},{"id":"b","text":"La bactérie a un cytoplasme, la paramécie non"},{"id":"c","text":"La paramécie a un véritable noyau, la bactérie non"},{"id":"d","text":"La paramécie est visible à l''œil nu, la bactérie non"}]'::jsonb, 'c', 'La paramécie est un protozoaire, un animal unicellulaire dont le noyau est entouré d''une membrane : c''est une eucaryote. La bactérie, elle, n''a pas de véritable noyau — son matériel génétique baigne directement dans le cytoplasme : c''est une procaryote ✓. Être unicellulaire ne suffit donc pas à classer un microbe : c''est la présence ou l''absence d''un vrai noyau qui tranche. Attribuer le noyau à la bactérie inverse exactement les deux. Toutes deux ont un cytoplasme : c''est un constituant fondamental de toute cellule. Et aucune n''est visible à l''œil nu : ce sont des micro-organismes, observables seulement au microscope.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('83349456-85cd-5aac-998d-1ec9a6898925', '4d10426c-9477-5321-8749-0ae925f7c072', 'Le paludisme, la tuberculose, la teigne et la rage sont quatre maladies. À quels groupes de microbes appartiennent respectivement leurs agents ?', '[{"id":"a","text":"Protozoaire, bactérie, moisissure, virus"},{"id":"b","text":"Bactérie, protozoaire, virus, moisissure"},{"id":"c","text":"Virus, bactérie, protozoaire, moisissure"},{"id":"d","text":"Moisissure, virus, bactérie, protozoaire"}]'::jsonb, 'a', 'Le paludisme est dû à l''hématozoaire, un protozoaire ; la tuberculose au bacille de Koch, une bactérie ; la teigne au trichophyton, une moisissure ; et la rage au virus de la rage ✓. Chacun des quatre groupes a donc ses pathogènes — c''est ce qui rend le tableau microbe-maladie indispensable à mémoriser. Le nom du microbe est souvent le meilleur indice : « bacille » annonce une bactérie, la terminaison « -zoaire » un animal unicellulaire. Toutes les autres combinaisons proposées permutent au moins deux de ces quatre affectations.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f9ba1111-a24f-52a8-a6a3-8486dbc3e6eb', '4d10426c-9477-5321-8749-0ae925f7c072', 'Une culture contient une seule bactérie au temps 0. Le milieu étant favorable, une division se produit toutes les 20 minutes. Combien y aura-t-il de bactéries deux heures après le temps 0 ?', '[{"id":"a","text":"6"},{"id":"b","text":"12"},{"id":"c","text":"32"},{"id":"d","text":"64"}]'::jsonb, 'd', 'Deux heures font 120 minutes, soit 6 × 20 minutes : il se produit donc 6 divisions. Or n divisions produisent 2ⁿ bactéries à partir d''une seule — d''où 2⁶ = 64 ✓. Répondre 6, c''est confondre le nombre de divisions avec le nombre de bactéries. Répondre 12, c''est doubler ce nombre de divisions, comme si chaque division n''ajoutait que deux bactéries au total : c''est croire la croissance proportionnelle au temps, alors qu''elle double à chaque étape. Et répondre 32, soit 2⁵, correspond à 5 divisions — le piège courant, qui consiste à en oublier une.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('38db394b-2177-5753-a9ab-d53a32e524ce', '4d10426c-9477-5321-8749-0ae925f7c072', 'Sur une observation microscopique réalisée au grossissement × 1000, une cellule de levure de bière mesure 8 mm. Quelle est sa taille réelle, et le résultat est-il cohérent avec les données du chapitre ?', '[{"id":"a","text":"0,8 μm — dix fois plus petit que l''intervalle annoncé"},{"id":"b","text":"8 μm — bien dans l''intervalle de 6 à 10 μm annoncé"},{"id":"c","text":"80 μm — dix fois plus grand que l''intervalle annoncé"},{"id":"d","text":"8 mm — soit la taille mesurée sur l''image elle-même"}]'::jsonb, 'b', 'La taille réelle est la taille mesurée divisée par le grossissement : 8 / 1000 = 0,008 mm. Or 1 μm vaut 1 millième de mm, donc 0,008 mm = 8 μm ✓ — et 8 μm tombe bien dans l''intervalle de 6 à 10 μm annoncé pour une cellule de levure : le calcul se vérifie lui-même. Répondre 8 mm, c''est oublier purement et simplement de diviser et rendre la taille mesurée sur l''image, ce qui ferait une levure visible à l''œil nu. Quant à 0,8 μm et 80 μm, ce sont les deux erreurs de conversion symétriques, d''un facteur 10 dans un sens ou dans l''autre — et c''est précisément l''intervalle 6 à 10 μm qui permet de les écarter sans hésiter.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0d92bdbd-1381-56d7-a973-cad664304fd9', '972beaaf-ae6a-517d-8ab0-f127666f7061', 'svt-1ere-sec', 'Test de compréhension ⭐ : Les agents pathogènes et les maladies infectieuses', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('dbac647d-0d5e-580f-907a-5e57eeeb771f', '0d92bdbd-1381-56d7-a973-cad664304fd9', 'Qu''est-ce que la contagion ?', '[{"id":"a","text":"La transmission d''une maladie d''un individu atteint à un individu non porteur de cette maladie"},{"id":"b","text":"La pénétration et le développement de micro-organismes pathogènes dans un organisme"},{"id":"c","text":"L''ensemble des signes qui révèlent une maladie"},{"id":"d","text":"La période pendant laquelle une maladie n''a encore produit aucun signe"}]'::jsonb, 'a', 'La contagion est la transmission d''une maladie d''un individu atteint à un individu non porteur de cette maladie ✓ : elle décrit le passage d''un organisme à un autre. La pénétration et le développement de micro-organismes pathogènes dans un organisme, avec les troubles d''intensité et de gravités variables qu''ils produisent, c''est l''infection — ce qui se passe à l''intérieur d''un seul organisme. Les signes qui révèlent la maladie sont les symptômes. Et la période sans signe qui suit la contamination est la phase d''incubation, longue de 10 jours dans la rougeole.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e384258b-3d20-54a9-ae6f-19fe186e9878', '0d92bdbd-1381-56d7-a973-cad664304fd9', 'Quel est l''agent pathogène de la tuberculose pulmonaire ?', '[{"id":"a","text":"Le virus de la tuberculose"},{"id":"b","text":"Le bacille de Koch"},{"id":"c","text":"Le bacille tétanique"},{"id":"d","text":"Le BCG"}]'::jsonb, 'b', 'La tuberculose est causée par le bacille tuberculeux, aussi appelé bacille de Koch, en abrégé BK ✓ : c''est une bactérie, pas un virus — la tuberculose n''est donc pas une maladie virale. Le bacille tétanique est l''agent du tétanos, une tout autre maladie. Quant au BCG, c''est le piège de l''item : il ne s''agit pas d''un microbe mais du vaccin qui protège les enfants contre la tuberculose — ne confonds pas l''agent de la maladie avec le moyen de la prévenir.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('43a9dbcc-901b-5f32-83d3-5f6118d0f5c8', '0d92bdbd-1381-56d7-a973-cad664304fd9', 'Selon le bilan du chapitre, de quelles deux façons les bactéries pathogènes agissent-elles sur l''organisme ?', '[{"id":"a","text":"Par voie respiratoire ou par voie digestive"},{"id":"b","text":"Par leur présence ou par les toxines qu''elles sécrètent"},{"id":"c","text":"En utilisant le matériel des cellules vivantes pour se multiplier, puis en les détruisant"},{"id":"d","text":"De façon directe ou de façon indirecte"}]'::jsonb, 'b', 'Les bactéries pathogènes agissent sur l''organisme soit par leur présence, comme le bacille de Koch qui se multiplie dans les poumons jusqu''à les détruire, soit par les toxines qu''elles sécrètent, comme le bacille tétanique et le bacille diphtérique ✓. Les voies respiratoire et digestive sont des voies de contamination : elles disent par où le microbe entre, pas comment il agit une fois entré. Utiliser le matériel des cellules vivantes pour se multiplier avant de les détruire, c''est le mode d''action des virus, et non celui des bactéries. Enfin, direct et indirect qualifient les deux formes de la contagion de la tuberculose — encore une question de transmission, pas d''action.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('93b872c2-093b-5433-a3b7-a5a903d75ef4', '0d92bdbd-1381-56d7-a973-cad664304fd9', 'Le bacille tétanique reste localisé au niveau de la plaie et n''envahit jamais l''organisme. Comment le tétanos parvient-il alors à provoquer une contraction généralisée des muscles ?', '[{"id":"a","text":"Les spores du bacille se détachent de la plaie et gagnent les muscles par le sang"},{"id":"b","text":"La plaie s''infecte si profondément que les muscles voisins finissent par se contracter de proche en proche"},{"id":"c","text":"Le bacille fabrique un poison, la toxine tétanique, qui se répand dans l''organisme et se fixe sur le tissu nerveux"},{"id":"d","text":"Le bacille se multiplie dans les muscles des mâchoires, puis dans les muscles respiratoires"}]'::jsonb, 'c', 'Le bacille se multiplie au niveau de la plaie mais reste localisé à cet endroit ; ce qui voyage, c''est le poison qu''il fabrique — la toxine tétanique, qui se répand dans l''organisme et se fixe irréversiblement au niveau du tissu nerveux ✓. C''est bien ce qui explique la contraction d''abord limitée aux mâchoires puis généralisée. Faire circuler les spores dans le sang contredit l''énoncé : les spores sont la forme de résistance prise en milieu oxygéné, présente dans la terre et la poussière, et c''est par elles qu''on est contaminé, pas par elles que la maladie se propage à l''intérieur. Une contagion de proche en proche entre muscles, comme une multiplication du bacille dans les muscles eux-mêmes, reviendrait à faire quitter la plaie au microbe — précisément ce qu''il ne fait pas.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('02e3f652-c295-5d6c-ac2f-bfa87366f85a', '0d92bdbd-1381-56d7-a973-cad664304fd9', 'Par quelles voies le SIDA se transmet-il, d''après le bilan du chapitre ?', '[{"id":"a","text":"Par la voie respiratoire uniquement"},{"id":"b","text":"Par la voie digestive uniquement"},{"id":"c","text":"Par la voie sexuelle uniquement"},{"id":"d","text":"Par la voie sexuelle et par la voie sanguine"}]'::jsonb, 'd', 'Le SIDA est le seul exemple que le bilan cite sur deux lignes : à la voie sexuelle, par le sperme et les sécrétions vaginales, aux côtés de la blennorragie et de la syphilis, et à la voie sanguine ✓. Répondre « sexuelle uniquement » est donc la moitié de la réponse : c''est l''erreur la plus fréquente, car on oublie la ligne de la voie sanguine. La voie respiratoire est celle de la grippe, de la tuberculose et du SRAS ; la voie digestive celle des infections intestinales liées aux intoxications alimentaires. Ni l''une ni l''autre ne transmet le SIDA.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('236d1716-b860-5177-abe0-262196a23c6c', '972beaaf-ae6a-517d-8ab0-f127666f7061', 'svt-1ere-sec', '⭐ Exercice : Quatre maladies, quatre fiches', 1, 50, 10, 'practice', 'admin', 1)
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
  ('4d10e083-a407-5b92-a498-85dff46298cc', '236d1716-b860-5177-abe0-262196a23c6c', 'Complète la fiche : « Rougeole — agent pathogène : … »', '[{"id":"a","text":"Le trichophyton"},{"id":"b","text":"Le bacille de Koch"},{"id":"c","text":"Une toxine sécrétée par une bactérie"},{"id":"d","text":"Le virus de la rougeole"}]'::jsonb, 'd', 'L''agent pathogène de la rougeole est le virus de la rougeole ✓ : le manuel la définit comme une maladie virale des yeux et du nez puis de la peau, qui attaque surtout les enfants. Le bacille de Koch cause la tuberculose. Une toxine n''est jamais un agent pathogène : c''est le poison fabriqué par un agent — le bacille tétanique, par exemple. Et le trichophyton est un champignon filamenteux, agent de la teigne, vu au chapitre précédent.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('26cfdbaf-ecf0-533f-8140-f917971c9f49', '236d1716-b860-5177-abe0-262196a23c6c', 'Le manuel indique que le bacille de Koch est répandu dans la nature « surtout dans les endroits humides, mal aérés et mal ensoleillés ». Quelle propriété du microbe explique cette localisation ?', '[{"id":"a","text":"Il ne se multiplie qu''en présence de poussière"},{"id":"b","text":"Il est tué par le soleil en quelques heures et ne résiste pas aux températures élevées"},{"id":"c","text":"Il se transforme en spore dès qu''il est exposé à l''oxygène"},{"id":"d","text":"Il ne survit que dans les poumons d''un malade"}]'::jsonb, 'b', 'Le manuel le dit dans la même phrase : le BK est tué par le soleil en quelques heures et ne résiste pas à des températures élevées ✓ — d''où sa présence dans les endroits humides, mal aérés et mal ensoleillés, les seuls où il tient. La poussière est le refuge des spores du bacille tétanique, pas du BK. Se transformer en spore au contact de l''oxygène est justement le propre du bacille tétanique, une bactérie anaérobie. Et prétendre que le BK ne survit que dans les poumons d''un malade contredirait la contagion indirecte, qui se fait par les crachats, les mouchoirs et les couverts.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b53ab9da-3ff4-5339-bfc2-9d2bc5f1e4f9', '236d1716-b860-5177-abe0-262196a23c6c', 'Quelle est la durée de la phase d''incubation silencieuse de la rougeole ?', '[{"id":"a","text":"3 jours"},{"id":"b","text":"48 heures"},{"id":"c","text":"10 jours"},{"id":"d","text":"De 2 à 15 jours"}]'::jsonb, 'c', 'Dans les 10 premiers jours de l''infection, il n''y a pas de signes : c''est une phase d''incubation silencieuse ✓. Ce n''est qu''ensuite que viennent 3 jours de fièvre, d''écoulement du nez, d''yeux larmoyants, de visage gonflé, de diarrhée et de perte d''appétit, puis 3 jours d''éruption et 3 jours de desquamation. Répondre 3 jours, c''est nommer la durée de chacune de ces trois phases de signes, pas celle du silence qui les précède. Et l''intervalle de 2 à 15 jours est le délai d''apparition des premiers symptômes du tétanos après la blessure — une autre maladie.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6b18a34a-3c9b-5028-8000-30eee51eb17e', '236d1716-b860-5177-abe0-262196a23c6c', 'Par quelle voie la tuberculose se transmet-elle de façon indirecte ?', '[{"id":"a","text":"Par les gouttelettes que le malade projette en toussant, en éternuant ou en parlant"},{"id":"b","text":"Par les crachats, les mouchoirs et les couverts utilisés par un tuberculeux"},{"id":"c","text":"Par la piqûre d''un moustique"},{"id":"d","text":"Par une blessure avec un objet rouillé"}]'::jsonb, 'b', 'La contagion indirecte de la tuberculose se fait par les crachats, les mouchoirs et les couverts utilisés par un tuberculeux ✓ : le microbe passe par un objet intermédiaire, d''où le mot « indirecte ». Les gouttelettes projetées en toussant, en éternuant ou même en parlant, et qui parviennent par inhalation aux voies respiratoires d''une personne saine, sont au contraire la contagion directe — c''est précisément le couple que l''item te demande de distinguer. La piqûre de moustique renvoie aux animaux vecteurs, et la blessure avec un objet rouillé est le mode de contamination du tétanos.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a23c4160-2c2f-52ce-989b-88a04a5f3610', '236d1716-b860-5177-abe0-262196a23c6c', 'Un élève affirme : « Les complications de la rougeole sont dues au virus de la rougeole, qui devient plus agressif avec le temps. » Que répondre ?', '[{"id":"a","text":"C''est exact : le virus détruit progressivement les tissus lymphoïdes"},{"id":"b","text":"C''est exact, mais seulement chez les personnes âgées"},{"id":"c","text":"C''est faux : les complications ne sont pas dues au virus de la rougeole, mais à des infections par d''autres microbes"},{"id":"d","text":"C''est faux : la rougeole ne provoque jamais de complications"}]'::jsonb, 'c', 'Le manuel est catégorique : des complications peuvent arriver, elles ne sont pas dues au virus de la rougeole, mais à des infections par d''autres microbes — complications respiratoires, digestives, nerveuses et sensorielles ✓. Le virus envahit bien les tissus lymphoïdes et agit sur le système nerveux central, la peau, les poumons, les yeux et les reins, mais c''est ce qui produit les symptômes de la maladie, pas ses complications. Restreindre l''affirmation aux personnes âgées ne la sauve pas et vise de toute façon la mauvaise maladie : la rougeole attaque surtout les enfants. Enfin, nier toute complication contredit le manuel, qui demande d''amener le malade à l''hôpital en cas de complication.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5c55547f-e81a-5057-b685-23b9f9112636', '236d1716-b860-5177-abe0-262196a23c6c', 'Pourquoi le manuel recommande-t-il des antibiotiques à un grippé uniquement « en cas de surinfections bactériennes » ?', '[{"id":"a","text":"Parce que l''agent de la grippe est un virus, et que la surinfection seule est due à des bactéries"},{"id":"b","text":"Parce que les antibiotiques sont réservés aux personnes âgées et affaiblies"},{"id":"c","text":"Parce que les antibiotiques ne sont efficaces qu''après la phase d''incubation"},{"id":"d","text":"Parce que les antibiotiques empêcheraient le vaccin antigrippal d''agir"}]'::jsonb, 'a', 'La grippe a pour agent pathogène le virus de la grippe : un antibiotique n''a donc rien à y faire. Mais le virus entraîne des lésions cellulaires locales au niveau des muqueuses du nez, de la gorge et des bronches, et ces lésions favorisent la surinfection bactérienne — angines et bronchites. Ce sont ces bactéries-là, et elles seules, que les antibiotiques visent ✓. Les personnes affaiblies ou âgées sont mentionnées parce que la surinfection les menace davantage, ce qui justifie qu''on leur conseille la vaccination : c''est une question de risque, pas une règle de prescription. Ni la phase d''incubation ni le vaccin n''entrent en jeu ici.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f5143bba-92a1-5776-b556-40312da896bc', '972beaaf-ae6a-517d-8ab0-f127666f7061', 'svt-1ere-sec', '⭐⭐ Révision (type examen) : Agents, voies de contamination et prévention', 2, 75, 15, 'practice', 'admin', 3)
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
  ('4805b54f-e480-5d4e-b718-67907ac46d15', 'f5143bba-92a1-5776-b556-40312da896bc', 'En 1977, un avion resta immobilisé au sol pendant trois heures, ses 54 passagers à bord. Une passagère présenta, un quart d''heure après l''embarquement, une crise fébrile avec frissons et toux, qui dura pendant l''attente et le voyage. Dans les 48 heures qui suivirent l''arrivée, 38 passagers tombèrent malades, victimes de la grippe. Pourquoi dit-on que la grippe est une maladie infectieuse ?', '[{"id":"a","text":"Parce qu''elle a débuté par une fièvre accompagnée de frissons et de toux"},{"id":"b","text":"Parce qu''elle s''est transmise d''un individu malade à des individus sains"},{"id":"c","text":"Parce qu''elle a touché une proportion importante du groupe en 48 heures"},{"id":"d","text":"Parce qu''elle est provoquée par un microbe pathogène, le virus grippal"}]'::jsonb, 'd', 'La grippe est une maladie infectieuse car elle est provoquée par un microbe pathogène ; il s''agit du virus grippal ✓ — c''est la définition même de l''infection : la pénétration et le développement d''un micro-organisme pathogène dans un organisme. Le piège est réel : la transmission d''un individu malade à des individus sains est parfaitement exacte, mais elle définit la contagion, pas l''infection. C''est le distracteur qui coûte le plus de points, car les deux notions se ressemblent. L''ampleur de l''atteinte en 48 heures décrit une épidémie ; et la fièvre, les frissons et la toux sont les symptômes — ils décrivent la maladie sans dire ce qui la cause.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('58e2372b-0887-591d-a88b-5ad0afd60f94', 'f5143bba-92a1-5776-b556-40312da896bc', 'Toujours dans l''avion de 1977 : pourquoi cette mini-épidémie s''est-elle déclenchée aussi facilement, et comment la contamination s''est-elle faite ?', '[{"id":"a","text":"L''atmosphère non renouvelée a favorisé la contagion ; le virus est passé par voie aérienne"},{"id":"b","text":"Les passagers ont partagé des couverts pendant l''attente ; le virus est passé par voie digestive"},{"id":"c","text":"L''immobilisation a affaibli les passagers, dont l''organisme a fabriqué le virus de la grippe"},{"id":"d","text":"La passagère a transmis des spores du virus, très fréquentes dans la poussière de la cabine"}]'::jsonb, 'a', 'Dans l''avion, l''atmosphère non renouvelée a favorisé la contagion, ce qui explique que la plupart des passagers soient tombés malades ; et quand la passagère malade tousse, les gouttes de salive qu''elle projette dans l''air contiennent le virus, qui s''introduit dans les voies respiratoires des individus sains ✓ — la grippe se transmet par voie aérienne. Le partage de couverts est le mode de contagion indirecte de la tuberculose, et la voie digestive concerne les infections intestinales liées aux intoxications alimentaires. Dire que l''organisme fabrique le virus est un contresens : un microbe pathogène vient du dehors, il ne naît pas de la fatigue. Quant aux spores, ce sont les bactéries qui en forment — le bacille tétanique en milieu oxygéné —, jamais les virus.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('18d2dbb8-e892-5570-8817-11aa0c3364cf', 'f5143bba-92a1-5776-b556-40312da896bc', 'La poliomyélite est une maladie infectieuse qui détruit certaines cellules nerveuses commandant les mouvements de l''organisme. Son agent, un virus, peut demeurer virulent plusieurs mois dans les eaux contaminées et pénètre dans l''organisme par les muqueuses respiratoires et digestives. Comment risque-t-on de contracter cette maladie, et comment l''éviter ?', '[{"id":"a","text":"En s''exposant au soleil dans une région où sévit l''épidémie ; on l''évite en restant à l''ombre"},{"id":"b","text":"Uniquement par une blessure souillée de terre ; on l''évite par un sérum après la blessure"},{"id":"c","text":"Uniquement par voie sexuelle ; on l''évite par des mesures d''hygiène sexuelle"},{"id":"d","text":"En buvant de l''eau contaminée ou en respirant l''agent ; on l''évite par la vaccination et l''hygiène"}]'::jsonb, 'd', 'L''énoncé donne les deux portes d''entrée : les muqueuses respiratoires et digestives — on se contamine donc en respirant l''agent ou en avalant de l''eau contaminée, où le virus reste virulent plusieurs mois ✓. Et la poliomyélite figure justement parmi les trois maladies contre lesquelles le bilan recommande de pratiquer la vaccination, avec la tuberculose et la rougeole ; s''y ajoutent les règles d''hygiène et la propreté de l''environnement. La blessure souillée de terre suivie d''un sérum décrit le tétanos. La voie sexuelle concerne le SIDA, la blennorragie et la syphilis. Quant au soleil, il tue le bacille de Koch en quelques heures : il protège, il ne contamine pas.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('079e6d0f-aae4-5bfe-a36d-529b57a6745c', 'f5143bba-92a1-5776-b556-40312da896bc', 'Parmi ces affirmations sur le tétanos, laquelle est FAUSSE ?', '[{"id":"a","text":"Il se manifeste par une contracture des muscles"},{"id":"b","text":"Il est dû à une toxine"},{"id":"c","text":"C''est une maladie virale"},{"id":"d","text":"Il peut survenir à l''occasion d''une blessure même bénigne"}]'::jsonb, 'c', 'Le tétanos n''est pas une maladie virale ✓ : son agent est le bacille tétanique, c''est-à-dire une bactérie — et même une bactérie anaérobie, qui se transforme en spore en milieu oxygéné. C''est donc l''affirmation fausse. Les trois autres sont exactes : la maladie se manifeste bien par une contraction d''abord limitée aux muscles des mâchoires puis généralisée ; elle est bien due à une toxine, puisque le bacille reste localisé dans la plaie et n''agit qu''à travers le poison qu''il sécrète ; et le manuel précise qu''elle peut survenir à l''occasion d''une blessure même bénigne.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3ed9aabb-4be8-5a76-a1d2-7a59ab2b10cf', 'f5143bba-92a1-5776-b556-40312da896bc', 'Deux malades : chez l''un, le microbe se multiplie dans les poumons jusqu''à les détruire ; chez l''autre, le microbe ne quitte pas la plaie, mais le malade meurt d''une asphyxie par paralysie des muscles respiratoires. Qu''illustre cette comparaison ?', '[{"id":"a","text":"Les deux voies de contamination : respiratoire et sanguine"},{"id":"b","text":"Les deux modes d''action des bactéries pathogènes : par leur présence et par leurs toxines"},{"id":"c","text":"Les deux formes de la contagion : directe et indirecte"},{"id":"d","text":"La différence entre une maladie infectieuse et une maladie contagieuse"}]'::jsonb, 'b', 'Le premier cas est la tuberculose : les bacilles de Koch se multiplient dans les poumons jusqu''à les détruire — la bactérie agit par sa présence, là où elle est. Le second est le tétanos : le bacille reste localisé à la plaie et n''envahit pas l''organisme, mais sa toxine se répand et se fixe irréversiblement sur le tissu nerveux, d''où la paralysie des muscles respiratoires. La comparaison illustre donc exactement les deux modes d''action des bactéries pathogènes ✓, tels que les énonce le bilan. Les voies de contamination diraient par où le microbe est entré, ce dont l''énoncé ne parle pas. La contagion directe ou indirecte concerne le passage d''un malade à l''autre. Quant au couple infectieux/contagieux, il est ici bien présent en filigrane — le tétanos est infectieux sans être contagieux — mais ce n''est pas ce que les deux descriptions comparent : elles décrivent l''action du microbe dans l''organisme.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2ee431fb-6d6e-52f2-b6de-c3a98721fa32', 'f5143bba-92a1-5776-b556-40312da896bc', 'Un élève range la grippe, la tuberculose, le tétanos et la poliomyélite dans le tableau « maladie / agent / voie de contamination ». Quelle ligne est correcte ?', '[{"id":"a","text":"Tétanos — bacille tétanique — voie respiratoire"},{"id":"b","text":"Grippe — bactérie — voie aérienne"},{"id":"c","text":"Tuberculose — bacille de Koch — voie respiratoire"},{"id":"d","text":"Poliomyélite — bactérie — voie sanguine"}]'::jsonb, 'c', 'Seule la ligne « Tuberculose — bacille de Koch — voie respiratoire » est juste ✓ : le bilan cite d''ailleurs la tuberculose, avec la grippe et le SRAS, comme exemple de contamination par la voie respiratoire, et le BK parvient bien aux voies respiratoires par inhalation des gouttelettes. La ligne du tétanos se trompe de voie : on ne l''attrape pas en respirant, mais par une blessure, quand les spores présentes dans la terre et la poussière pénètrent dans l''organisme. Les deux dernières lignes se trompent d''agent : la grippe et la poliomyélite sont dues à des virus, non à des bactéries — leur voie est d''ailleurs correcte pour la grippe, ce qui rend le piège efficace.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('788bccf3-2e72-572a-aca1-e7f601538cca', 'a15437ac-fbc7-54e7-ad0d-892a7377dec1', 'svt-1ere-sec', 'Test de compréhension ⭐ : La défense de l''organisme', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('0b570cd4-1967-52ba-a4f8-46cb8cb6ff6f', '788bccf3-2e72-572a-aca1-e7f601538cca', 'Qu''est-ce que la diapédèse ?', '[{"id":"a","text":"L''invasion de tout l''organisme par des bactéries qui ont résisté aux phagocytes"},{"id":"b","text":"Le mécanisme par lequel un globule blanc englobe et digère une particule étrangère"},{"id":"c","text":"La réaction de l''organisme aux lésions des tissus, marquée par la rougeur et le gonflement"},{"id":"d","text":"La migration, vers le foyer d''infection, des leucocytes à travers la paroi des vaisseaux sanguins"}]'::jsonb, 'd', 'La diapédèse est la migration, vers le foyer d''infection, des leucocytes à travers la paroi des vaisseaux sanguins ✓ : c''est le trajet qu''ils empruntent pour sortir du sang et rejoindre la zone enflammée, où ils sont attirés par des substances chimiques fabriquées par le tissu infecté. Englober et digérer une particule étrangère, c''est la phagocytose — l''étape d''après, une fois le phagocyte arrivé. La réaction marquée par la rougeur et le gonflement est l''inflammation. Et l''invasion générale par des bactéries qui ont résisté est la septicémie, c''est-à-dire l''échec de tout ce dispositif.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8dec84d3-4361-5a2a-bab1-56e2efc6d1fd', '788bccf3-2e72-572a-aca1-e7f601538cca', 'Quels sont les quatre signes de la réaction inflammatoire ?', '[{"id":"a","text":"Fièvre, courbatures, asthénie et perte d''appétit"},{"id":"b","text":"Rougeur, chaleur, gonflement et douleur"},{"id":"c","text":"Adhésion, absorption, digestion et exocytose"},{"id":"d","text":"Mémoire, spécificité, diversité et durée"}]'::jsonb, 'b', 'L''inflammation est la réaction de l''organisme aux lésions des tissus ou aux infections, se manifestant localement par la rougeur, la chaleur, le gonflement et la douleur ✓ — c''est le premier signe de l''infection, et il est local. La fièvre, les courbatures, l''asthénie et la perte d''appétit sont des symptômes généraux, ceux de la grippe du chapitre précédent : ils touchent tout le corps, pas la zone piquée. L''adhésion, l''absorption et la digestion sont les étapes de la phagocytose. Et la mémoire, la spécificité et la diversité sont les trois propriétés de l''immunité acquise — la partie B du chapitre.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1325ba23-9c6b-534f-b08c-824d0727b657', '788bccf3-2e72-572a-aca1-e7f601538cca', 'Dans quel ordre se déroulent les trois étapes de la phagocytose ?', '[{"id":"a","text":"Digestion, puis adhésion, puis absorption"},{"id":"b","text":"Absorption, puis adhésion, puis digestion"},{"id":"c","text":"Adhésion, puis absorption (= ingestion), puis digestion"},{"id":"d","text":"Adhésion, puis digestion, puis absorption (= ingestion)"}]'::jsonb, 'c', 'Les trois étapes sont, dans l''ordre : l''adhésion, l''absorption — que le manuel note « absorption = ingestion » — puis la digestion ✓. La logique est imparable : le phagocyte doit d''abord toucher le microbe, ensuite l''englober dans un phagosome, et seulement alors le digérer grâce aux vésicules digestives. Chacune des trois autres propositions casse cette chaîne : on ne peut pas digérer un microbe qu''on n''a pas encore touché, ni l''englober avant d''avoir adhéré à lui, ni le digérer avant de l''avoir fait entrer dans la cellule.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f7a55277-f904-5dac-ab74-8b45bde673fd', '788bccf3-2e72-572a-aca1-e7f601538cca', 'Pourquoi la phagocytose est-elle qualifiée de défense « non spécifique » ?', '[{"id":"a","text":"Parce qu''elle se produit quelle que soit la nature de l''agent pathogène"},{"id":"b","text":"Parce qu''elle ne réussit pas toujours à éliminer les microbes"},{"id":"c","text":"Parce qu''elle n''est assurée que par les polynucléaires"},{"id":"d","text":"Parce qu''elle se déclenche avant même que le microbe n''ait franchi la peau"}]'::jsonb, 'a', 'Au foyer de l''infection, et quelle que soit la nature de l''agent pathogène, il se produit entre les polynucléaires et les micro-organismes une lutte pour la survie ✓ : le phagocyte englobe tout élément étranger, sans distinction — voilà exactement ce que « non spécifique » veut dire. Qu''elle échoue parfois est vrai, puisque des bactéries à multiplication rapide peuvent y résister et causer une septicémie, mais l''efficacité n''est pas ce que le mot désigne. Elle n''est pas non plus réservée aux polynucléaires : les monocytes et les macrophages sont eux aussi des phagocytes. Enfin, elle intervient au contraire une fois la peau franchie : c''est la deuxième ligne, pas la première.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6e03b92d-bd46-56c7-b12a-4fc8decff5e8', '788bccf3-2e72-572a-aca1-e7f601538cca', 'Une souris reçoit de l''anatoxine tétanique et survit ; trois semaines plus tard, on lui injecte de la toxine diphtérique et elle meurt. Quelle propriété de l''immunité acquise cette expérience met-elle en évidence ?', '[{"id":"a","text":"La mémoire"},{"id":"b","text":"La diversité"},{"id":"c","text":"La spécificité"},{"id":"d","text":"Le transfert de l''immunité par le sérum"}]'::jsonb, 'c', 'La souris était protégée contre le tétanos et meurt de la diphtérie : la protection acquise ne vaut donc que contre l''agent qui l''a provoquée, et reste inefficace contre un autre microbe — c''est la spécificité ✓. La mémoire serait démontrée par deux contacts avec le même agent, la réponse secondaire étant alors plus rapide, plus forte et plus durable ; ici les deux agents sont différents. La diversité est le distracteur qui piège : elle affirme que l''organisme peut développer une réponse contre chaque microbe — c''est presque le contraire de ce que montre cette souris, qui n''en a développé qu''une seule, contre le tétanos. Quant au transfert par le sérum, il se démontre en prélevant le sérum d''une souris immunisée pour l''injecter à une autre.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4ac06f80-a0bb-5634-bb6f-c848e8565c06', 'a15437ac-fbc7-54e7-ad0d-892a7377dec1', 'svt-1ere-sec', '⭐ Exercice : Les deux lignes de la défense non spécifique', 1, 50, 10, 'practice', 'admin', 1)
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
  ('1b27a2fe-7908-5ca9-8d2f-8dfb1d87ed27', '4ac06f80-a0bb-5634-bb6f-c848e8565c06', 'Le mucus des muqueuses nasale, intestinale et pulmonaire est sécrété en abondance et entraîne une grande partie des micro-organismes vers l''extérieur. S''agit-il d''une barrière mécanique ou chimique ?', '[{"id":"a","text":"Mécanique : il évacue les microbes vers l''extérieur sans les tuer"},{"id":"b","text":"Chimique : c''est une sécrétion des muqueuses"},{"id":"c","text":"Chimique : son acidité empêche la multiplication bactérienne"},{"id":"d","text":"Ni l''une ni l''autre : le mucus n''est pas une barrière naturelle"}]'::jsonb, 'a', 'Le mucus agit mécaniquement ✓ : sa sécrétion abondante entraîne une grande partie des micro-organismes vers l''extérieur — il balaie, il n''empoisonne pas. C''est précisément le piège du classement : être une sécrétion ne suffit pas à faire une barrière chimique, sinon la question n''aurait aucun intérêt ; ce qui compte est la façon d''agir, pas la nature du produit. L''acidité qui empêche la multiplication bactérienne existe bien, mais c''est celle du tube digestif, et celle des sécrétions lacrymales et sudoripares ralentit le développement des bactéries : ce sont elles, les barrières chimiques. Et le mucus est bel et bien l''un des moyens de protection efficaces des muqueuses.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('58c92df4-f4b9-578d-91d4-b3bd404d2178', '4ac06f80-a0bb-5634-bb6f-c848e8565c06', 'Quels sont les leucocytes que le bilan nomme comme phagocytes ?', '[{"id":"a","text":"Les polynucléaires, les monocytes et les macrophages"},{"id":"b","text":"Les globules rouges et les plaquettes"},{"id":"c","text":"Les polynucléaires uniquement"},{"id":"d","text":"Les anticorps et les antigènes"}]'::jsonb, 'a', 'Le bilan cite trois leucocytes appelés phagocytes : les polynucléaires, les monocytes et les macrophages ✓ ; attirés par des substances chimiques fabriquées par le tissu infecté, ils arrivent en grand nombre dans la zone enflammée. Les globules rouges ne participent pas à la défense, et les plaquettes ne sont pas des leucocytes. Réduire la liste aux seuls polynucléaires est l''erreur la plus tentante, car ce sont eux qui arrivent en grand nombre dans le pus — mais ils ne sont pas les seuls phagocytes. Enfin, les anticorps et les antigènes ne sont pas des cellules du tout : ce sont des substances.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('855faa74-716d-53a9-88f7-34392574088d', '4ac06f80-a0bb-5634-bb6f-c848e8565c06', 'Que devient un microbe lors d''une phagocytose réussie ?', '[{"id":"a","text":"Il est neutralisé par des anticorps venus du sérum"},{"id":"b","text":"Il est rejeté intact vers l''extérieur de l''organisme"},{"id":"c","text":"Il se multiplie dans le phagocyte, qui le transporte vers les autres organes"},{"id":"d","text":"Il devient rapidement méconnaissable : il est digéré à l''intérieur du phagocyte"}]'::jsonb, 'd', 'Dans le cas d''une phagocytose réussie, les bactéries deviennent rapidement méconnaissables : elles subissent une digestion à l''intérieur du phagocyte ✓ — c''est la troisième et dernière étape, assurée par les vésicules digestives qui déversent leur contenu dans le phagosome. Un rejet intact ne serait pas une réussite, puisque le but du phagocyte est justement d''éliminer l''élément étranger. Une multiplication à l''intérieur de la cellule décrirait plutôt l''échec de la phagocytose, qui aboutit à l''invasion de l''organisme, la septicémie. Quant aux anticorps, ils relèvent de l''immunité spécifique : la phagocytose, elle, est non spécifique et n''en utilise aucun.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('85b92d6e-f284-5183-ab50-9932c672fda6', '4ac06f80-a0bb-5634-bb6f-c848e8565c06', 'Comment se nomme l''infection généralisée qui survient lorsque des bactéries à multiplication très rapide résistent à la phagocytose et envahissent l''organisme ?', '[{"id":"a","text":"L''inflammation"},{"id":"b","text":"La diapédèse"},{"id":"c","text":"La septicémie"},{"id":"d","text":"L''exocytose"}]'::jsonb, 'c', 'Quand les bactéries, qui se multiplient très rapidement, résistent à la phagocytose des polynucléaires pourtant très nombreux au niveau de la plaie, elles tendent à envahir l''organisme : c''est l''infection généralisée appelée septicémie ✓. Le mot « généralisée » est la clé — il s''oppose au caractère local de l''inflammation, qui reste confinée à la zone piquée et se manifeste par la rougeur, la chaleur, le gonflement et la douleur. La diapédèse est le passage des leucocytes à travers la paroi des vaisseaux, un mouvement de la défense et non de l''infection. L''exocytose est le rejet hors de la cellule, l''inverse de l''ingestion.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e17c8cee-f9f6-5a1e-bd52-3df48e592677', '4ac06f80-a0bb-5634-bb6f-c848e8565c06', 'Une agression de l''organisme par des pneumocoques est suivie de guérison. Remets ces cinq événements dans l''ordre où ils se produisent.', '[{"id":"a","text":"Les pneumocoques se multiplient rapidement"},{"id":"b","text":"Les polynucléaires sortent des capillaires au niveau du foyer de l''infection"},{"id":"c","text":"Les pneumocoques sont phagocytés"},{"id":"d","text":"L''organisme fabrique des anticorps"},{"id":"e","text":"L''état de santé de l''organisme s''améliore"}]'::jsonb, NULL, 'Tout commence par l''infection elle-même : les pneumocoques se multiplient rapidement dans les tissus. L''organisme répond d''abord de façon non spécifique — les polynucléaires sortent des capillaires par la diapédèse pour gagner le foyer, puis phagocytent les pneumocoques. Cet ordre-là est imposé par la logique : un phagocyte doit être arrivé sur place avant de pouvoir manger quoi que ce soit. La fabrication d''anticorps vient ensuite, car l''immunité spécifique n''est mise en jeu que si l''immunité non spécifique est inefficace pour éliminer le germe. L''amélioration de l''état de santé ne peut évidemment venir qu''en dernier ✓.', 5, 'ordering', '{"order":["a","b","c","d","e"]}'::jsonb, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b7ccbead-2ed7-52c5-aa81-7d3f63d9b62b', '4ac06f80-a0bb-5634-bb6f-c848e8565c06', 'Un élève écrit : « La peau est une barrière si efficace qu''aucun microbe ne peut jamais la traverser. » Que faut-il corriger ?', '[{"id":"a","text":"Rien : la peau intacte est infranchissable pour tous les micro-organismes"},{"id":"b","text":"« Très peu » de micro-organismes traversent la peau lorsqu''elle est intacte — et une blessure, une piqûre ou une brûlure ouvre le passage"},{"id":"c","text":"La peau n''est pas une barrière : seul le mucus des muqueuses protège l''organisme"},{"id":"d","text":"La peau ne protège que par son acidité, et son rôle est donc purement chimique"}]'::jsonb, 'b', 'Le manuel pèse ses mots : très peu de micro-organismes sont capables de traverser la peau lorsqu''elle est intacte ✓. Deux nuances y sont cachées — « très peu » n''est pas « aucun », et « intacte » est une condition. C''est bien pourquoi le chapitre enchaîne sur la deuxième ligne de défense : à l''occasion d''une blessure, d''une piqûre ou d''une brûlure, les microbes franchissent la peau et pénètrent dans les tissus. Nier tout rôle à la peau contredirait la définition même de l''immunité naturelle, qui l''énumère avec les muqueuses, l''inflammation et la phagocytose. Et son rôle n''est pas purement chimique : sa couche cornée constitue une barrière mécanique efficace.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('cc47fc9b-4f12-5d75-8f32-2f5510fdcac2', 'a15437ac-fbc7-54e7-ad0d-892a7377dec1', 'svt-1ere-sec', '⭐⭐ Révision (type examen) : Immunité acquise, vaccination et sérothérapie', 2, 75, 15, 'practice', 'admin', 3)
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
  ('cd36905c-da35-5f18-b87b-eebfde30a477', 'cc47fc9b-4f12-5d75-8f32-2f5510fdcac2', 'Pasteur injecte une culture fraîche du bacille du choléra des poules à deux lots : le lot A n''a subi aucun traitement préalable, le lot B a reçu une injection de culture vieillie. Le lot A meurt, le lot B survit. À quoi sert le lot A ?', '[{"id":"a","text":"C''est le lot témoin : il prouve que la culture fraîche est bien mortelle, sans quoi la survie du lot B ne démontrerait rien"},{"id":"b","text":"Il sert à produire les anticorps que l''on transférera ensuite au lot B"},{"id":"c","text":"Il sert à vérifier que la culture vieillie n''est pas dangereuse"},{"id":"d","text":"Il sert à mesurer le délai d''apparition de la réponse secondaire"}]'::jsonb, 'a', 'Le lot A est le lot témoin : formé de poules n''ayant subi aucun traitement préalable, il reçoit la même culture fraîche que le lot B ✓. Sa mort établit que cette culture tue réellement — sans quoi la survie du lot B pourrait s''expliquer par une culture devenue inoffensive, et non par une protection acquise. C''est là toute la fonction d''un témoin : ne faire varier qu''une seule chose, le traitement préalable. Le transfert d''anticorps d''un organisme à un autre est le principe de la sérothérapie, découvert bien plus tard, et rien de tel n''a lieu ici. L''innocuité de la culture vieillie est déjà connue avant l''expérience — c''est elle qui a donné à Pasteur son idée. Et aucune mesure de délai n''est faite : on constate le résultat le lendemain.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a2061720-1c12-5241-8fb5-c5025f27247a', 'cc47fc9b-4f12-5d75-8f32-2f5510fdcac2', 'Une personne se blesse profondément avec un objet rouillé. Elle n''est pas vaccinée contre le tétanos. Pourquoi lui injecte-t-on un sérum antitétanique plutôt que le vaccin ?', '[{"id":"a","text":"Parce que le vaccin ne peut jamais être administré à une personne blessée"},{"id":"b","text":"Parce que le sérum confère une immunité active, plus solide que celle du vaccin"},{"id":"c","text":"Parce que le sérum protège pour toute la vie, contrairement au vaccin"},{"id":"d","text":"Parce que le sérum a une action immédiate, alors que le vaccin agit trop tard"}]'::jsonb, 'd', 'Tout est dans le tableau de comparaison : la vaccination a une action tardive et de longue durée, la sérothérapie une action immédiate et de courte durée ✓. Le vacciné fabrique lui-même ses anticorps, ce qui prend du temps ; le blessé, lui, a déjà les spores dans sa plaie — on lui donne donc des anticorps tout faits, qui agissent tout de suite. C''est aussi pourquoi la sérothérapie est curative et s''effectue sur des organismes atteints ou risquant de l''être. Le sérum confère précisément l''inverse d''une immunité active : une immunité passive, puisque les anticorps sont élaborés par un autre organisme immunisé. Et il ne protège pas pour la vie — sa durée est courte, sans mémoire ; c''est la vaccination qui protège longtemps, à condition d''un rappel tous les 5 ans.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('26eeaf34-3224-58f5-bd9c-ef55a30bc297', 'cc47fc9b-4f12-5d75-8f32-2f5510fdcac2', 'On injecte à un animal une forme atténuée d''un microbe A, puis, plus tard, la forme virulente du même microbe. Comment se comparent les deux réponses ?', '[{"id":"a","text":"La première est rapide, forte et durable ; la seconde est lente, faible et de courte durée"},{"id":"b","text":"Les deux réponses sont identiques, car le microbe est le même"},{"id":"c","text":"La première est une réponse primaire lente, de faible intensité et de courte durée ; la seconde est une réponse secondaire rapide, forte et durable"},{"id":"d","text":"La première produit des anticorps anti-A, la seconde n''en produit aucun car l''animal est déjà protégé"}]'::jsonb, 'c', 'À la suite de chaque injection, il y a bien développement d''une réponse immunitaire, avec apparition d''anticorps anti-A dans le sang. Mais l''injection du microbe atténué induit une réponse primaire lente, de courte durée et de faible production d''anticorps, tandis que l''injection ultérieure du microbe virulent induit une réponse secondaire plus rapide, plus durable et bien plus abondante ✓ : lors du premier contact le système immunitaire est sensibilisé, lors du second il réagit plus efficacement grâce à la mémoire immunitaire. La proposition qui inverse les deux est le piège classique. Dire que les réponses sont identiques nierait la mémoire, la propriété même que l''expérience démontre. Et prétendre que la seconde injection ne produit aucun anticorps est le contraire de ce qu''on observe : c''est elle qui en produit le plus.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a4f8266a-1bb2-5cea-8d27-c2360edc06c5', 'cc47fc9b-4f12-5d75-8f32-2f5510fdcac2', 'Associe chaque savant à sa découverte.', '[{"id":"l1","text":"Jenner (1798)"},{"id":"l2","text":"Pasteur (1879)"},{"id":"l3","text":"Roux (1894)"},{"id":"l4","text":"Ramon (1923)"},{"id":"r1","text":"Inocule à un enfant du pus de vache atteinte de la vaccine ; l''enfant résiste ensuite à la variole"},{"id":"r2","text":"Injecte à des poules une culture vieillie du bacille du choléra : elles survivent ensuite à la culture fraîche"},{"id":"r3","text":"Transfère le sérum d''un cheval hyper-immunisé à des malades atteints de diphtérie, qui guérissent"},{"id":"r4","text":"Prépare une anatoxine en additionnant du formol à la toxine diphtérique portée à 40 °C pendant un mois"}]'::jsonb, NULL, 'Jenner, en 1798, part de l''observation que les fermières ayant contracté la vaccine — variole bovine bénigne — échappaient aux épidémies de variole, et inocule à un enfant du pus prélevé sur une pustule de vache ; l''année suivante, l''enfant résiste au pus de varioleux. Pasteur, en 1879, montre avec ses deux lots de poules que la culture vieillie du bacille du choléra protège contre la culture fraîche. Roux, en 1894, disciple de Pasteur, immunise un cheval par des doses croissantes et répétées de toxine diphtérique, puis transfère son sérum à des malades qui guérissent : c''est la naissance de la sérothérapie. Ramon, en 1923, prépare l''anatoxine diphtérique avec du formol et de la chaleur ✓. Le fil à suivre : Jenner et Pasteur atténuent un microbe pour prévenir, Roux transfère des anticorps pour guérir, Ramon inactive une toxine.', 4, 'matching', '{"pairs":[["l1","r1"],["l2","r2"],["l3","r3"],["l4","r4"]]}'::jsonb, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('feb7e743-7450-5c4f-a514-49f62eef5d1c', 'cc47fc9b-4f12-5d75-8f32-2f5510fdcac2', 'La souris D reçoit de l''anatoxine tétanique et survit ; on lui prélève son sérum, qu''on injecte à la souris E, laquelle résiste ensuite à la toxine tétanique. La souris F, qui a reçu le sérum de la souris témoin T non immunisée, meurt de cette même toxine. Pourquoi l''expérience sur F était-elle indispensable ?', '[{"id":"a","text":"Pour vérifier que la toxine tétanique reste mortelle chez une souris en bonne santé"},{"id":"b","text":"Pour prouver que c''est bien l''immunisation de D, et non le sérum en tant que liquide, qui protège E"},{"id":"c","text":"Pour montrer que l''anatoxine tétanique est inoffensive"},{"id":"d","text":"Pour comparer la réponse primaire et la réponse secondaire de la souris E"}]'::jsonb, 'b', 'Sans la souris F, un doute demeurerait : peut-être qu''injecter du sérum, n''importe quel sérum, suffit à protéger. F reçoit le sérum d''une souris non immunisée et meurt — donc ce n''est pas le sérum en tant que liquide qui sauve E, mais bien ce que l''immunisation de D y a mis : des anticorps ✓. C''est exactement le rôle d''une expérience témoin. Vérifier que la toxine est mortelle chez une souris saine était le rôle de la souris A, dans la première expérience. L''innocuité de l''anatoxine se lit déjà dans la survie de D et de B. Et aucune réponse primaire ou secondaire n''est comparée ici : E ne fabrique rien, elle reçoit des anticorps tout faits.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2d930ecb-33f7-5f7c-993b-8058926cc158', 'cc47fc9b-4f12-5d75-8f32-2f5510fdcac2', 'Ramon prépare une anatoxine diphtérique et l''injecte à une personne saine : trois injections séparées de 15 jours, puis une injection un an après. Elle lui confère une immunité de plus de 5 ans. S''agit-il d''une méthode préventive ou curative, et quelle immunité confère-t-elle ?', '[{"id":"a","text":"Curative, immunité passive"},{"id":"b","text":"Préventive, immunité active"},{"id":"c","text":"Curative, immunité active"},{"id":"d","text":"Préventive, immunité passive"}]'::jsonb, 'b', 'Deux indices se recoupent. D''abord, l''injection est faite à une personne saine, et vise à la protéger avant toute maladie : c''est donc préventive — le but même de la vaccination, tandis que la sérothérapie est curative et s''adresse à des organismes atteints ou risquant de l''être. Ensuite, ce qu''on injecte est une anatoxine, c''est-à-dire une toxine rendue inactive : ce n''est pas un anticorps, mais un antigène que l''organisme devra reconnaître pour élaborer lui-même ses anticorps — l''immunité est donc active ✓. Le procédé de Ramon est bien une vaccination. Les rappels le confirment : l''immunité dure plus de 5 ans mais pas toute la vie, ce qui est la signature d''une action tardive et de longue durée, à l''opposé de l''action immédiate et brève d''un sérum.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('2651bb3a-b0a3-55d5-9092-7ed4c993d3f1', 'e5983da0-45a8-5f71-b0e8-06496a06800b', 'svt-1ere-sec', 'Test de compréhension ⭐ : Étude d''un site géologique', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('653c1704-6c35-5847-97fa-1b32a6dfdd4f', '2651bb3a-b0a3-55d5-9092-7ed4c993d3f1', 'Qu''est-ce qu''un affleurement ?', '[{"id":"a","text":"Une couche de terrain sédimentaire"},{"id":"b","text":"Une strate qui devient visible en surface, naturellement par érosion ou sous l''action de l''homme"},{"id":"c","text":"L''inclinaison d''une couche par rapport à l''horizontale"},{"id":"d","text":"Un relief en pente abrupte situé sur la côte"}]'::jsonb, 'b', 'Un affleurement est une strate qui devient visible en surface, soit naturellement sous l''action des agents d''érosion, soit sous l''action de l''homme ✓ — c''est ce qui rend un site géologique lisible : sans affleurement, les couches resteraient cachées sous le sol. Une couche de terrain sédimentaire, c''est la définition de la strate elle-même : toutes les strates ne sont pas des affleurements, seules celles qui apparaissent en surface le sont. L''inclinaison d''une couche par rapport à l''horizontale est le pendage. Et le relief en pente abrupte situé sur la côte est la falaise.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f8667917-cb10-52f7-8a17-5bf73e70b803', '2651bb3a-b0a3-55d5-9092-7ed4c993d3f1', 'Quel test emploie-t-on couramment pour déceler la présence de calcaire dans une roche ?', '[{"id":"a","text":"On dépose une goutte d''acide chlorhydrique : une effervescence se produit"},{"id":"b","text":"On plonge la roche dans l''eau pure : elle se dissout"},{"id":"c","text":"On la raye avec l''ongle : elle se raye facilement"},{"id":"d","text":"On verse de l''eau dans un creux : l''eau la traverse aussitôt"}]'::jsonb, 'a', 'Une goutte d''acide chlorhydrique déposée sur un calcaire produit une effervescence due à un dégagement de dioxyde de carbone ✓ : cette effervescence signale la réaction de l''acide avec le carbonate de calcium, et c''est pour cela qu''elle est couramment employée pour déceler la présence de calcaire dans une roche. Le calcaire est au contraire insoluble dans l''eau pure — il ne devient soluble que dans une eau chargée en CO2. Il n''est pas rayé par l''ongle : c''est une roche dure, et l''argile, elle, se raye. Enfin, l''eau ne le traverse pas : il est poreux mais imperméable à l''échelle de l''échantillon.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cfdf2737-585a-527d-8599-dcd72feb9720', '2651bb3a-b0a3-55d5-9092-7ed4c993d3f1', 'Dans une falaise, une strate A repose sur une strate B, qui repose elle-même sur une strate C. Que dit le principe de superposition ?', '[{"id":"a","text":"A est la plus ancienne, C la plus récente"},{"id":"b","text":"Les trois strates ont le même âge, puisqu''elles se touchent"},{"id":"c","text":"C est la plus ancienne, A la plus récente"},{"id":"d","text":"On ne peut rien dire sans connaître l''âge absolu de chaque strate"}]'::jsonb, 'c', 'Une strate est plus récente que celle qu''elle recouvre et plus ancienne que celle qui la recouvre : la plus basse, C, est donc la plus ancienne, et la plus haute, A, la plus récente ✓. La logique est celle du dépôt : la sédimentation empile les couches, et pour être recouverte il faut avoir été déposée avant. Inverser l''ordre est l''erreur classique, celle de qui lit la falaise de haut en bas comme une page. Leur contact ne les rend pas contemporaines : ce sont des dépôts successifs. Et il n''est justement pas besoin d''âges absolus — c''est tout l''intérêt de ce principe, qui fonde la datation relative.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fca75037-b85a-5f66-8345-a427d9daea7c', '2651bb3a-b0a3-55d5-9092-7ed4c993d3f1', 'Dans un site, une strate de faciès marin est surmontée d''une strate de faciès continental. Qu''en déduit-on ?', '[{"id":"a","text":"Les deux strates se sont déposées en même temps, dans deux bassins différents"},{"id":"b","text":"Il y a eu une transgression : la mer a envahi la région"},{"id":"c","text":"Il y a eu une faille, qui a décalé les compartiments"},{"id":"d","text":"Il y a eu une régression : la mer s''est retirée"}]'::jsonb, 'd', 'La strate du bas, marine, montre que la mer recouvrait la région lors de sa sédimentation ; celle du dessus, continentale, donc plus récente d''après le principe de superposition, montre que la région n''était plus couverte par la mer. Entre les deux, la mer s''est donc retirée : c''est une régression ✓. La transgression est le mouvement inverse — elle se lirait dans un faciès continental surmonté d''un faciès marin, comme à Ras Amer entre les strates 2 et 1. Une faille est une cassure avec déplacement des compartiments : elle n''explique aucun changement de faciès. Et deux strates superposées ne peuvent pas être contemporaines, ni appartenir à deux bassins.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('46e58148-8eab-527b-95b9-00295d715b1a', '2651bb3a-b0a3-55d5-9092-7ed4c993d3f1', 'Quelle est la différence entre une faille et un pli ?', '[{"id":"a","text":"La faille affecte les roches calcaires, le pli affecte les roches argileuses"},{"id":"b","text":"La faille est une cassure avec déplacement des compartiments (déformation cassante) ; le pli est une ondulation des couches (déformation souple)"},{"id":"c","text":"La faille se produit avant le dépôt des couches, le pli après"},{"id":"d","text":"La faille est une déformation souple, le pli une déformation cassante"}]'::jsonb, 'b', 'Une faille est une cassure plus ou moins profonde des couches d''un terrain, accompagnée d''un déplacement des compartiments séparés par la cassure : c''est une déformation cassante. Les plis sont des ondulations des couches, avec des parties bombées, les anticlinaux, et des parties creuses, les synclinaux : ce sont des déformations souples ✓. La proposition qui échange les deux adjectifs est le piège symétrique — retiens que la roche qui casse fait une faille, celle qui plie fait un pli. La nature de la roche ne fait pas la différence, et les deux sont des déformations qui affectent les couches sédimentaires après leur dépôt.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0eff20ca-a60b-58b0-98ec-6ba17513be7e', 'e5983da0-45a8-5f71-b0e8-06496a06800b', 'svt-1ere-sec', '⭐ Exercice : Le calcaire oolithique sur le terrain', 1, 50, 10, 'practice', 'admin', 1)
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
  ('ef86ae65-2116-5477-8d4e-0ab3ec805ba2', '0eff20ca-a60b-58b0-98ec-6ba17513be7e', 'De quoi une oolithe est-elle formée ?', '[{"id":"a","text":"D''enveloppes successives de calcaire déposées autour d''un noyau"},{"id":"b","text":"D''un seul cristal de carbonate de calcium, de forme géométrique parfaite"},{"id":"c","text":"D''un mélange homogène d''argile et de sable, sans noyau ni enveloppe"},{"id":"d","text":"Du ciment carbonaté qui soude entre eux les éléments de la roche"}]'::jsonb, 'a', 'Une oolithe est une petite sphère de la taille du millimètre — 0,5 à 2 mm — formée d''enveloppes successives de calcaire autour d''un noyau, qui peut être un grain de quartz ou un fragment de coquille ✓. C''est cette structure en pelure d''oignon qui raconte sa formation : chaque passage en suspension dans l''eau agitée dépose une couche de plus. Un cristal unique de forme géométrique parfaite décrirait un cristal, pas une oolithe. Un mélange d''argile et de sable est un silt. Et le ciment est ce qui soude les oolithes entre elles — il les entoure, il ne les constitue pas : sans lui la roche ne serait pas compacte.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a6a4a998-6434-5fe2-946d-90159d33cc1b', '0eff20ca-a60b-58b0-98ec-6ba17513be7e', 'On porte du calcaire oolithique à haute température. Un gaz se dégage et trouble l''eau de chaux ; la roche se transforme en une substance friable et blanchâtre. Qu''obtient-on, et qu''en déduit-on ?', '[{"id":"a","text":"Du quartz et du sable : la roche est essentiellement siliceuse"},{"id":"b","text":"De la vapeur d''eau et du gypse : la roche est du sulfate de calcium"},{"id":"c","text":"Du CO2 et du bicarbonate de calcium : la roche s''est simplement dissoute"},{"id":"d","text":"Du CO2 et de la chaux vive (CaO) : la roche est du carbonate de calcium"}]'::jsonb, 'd', 'Le gaz qui trouble l''eau de chaux est le dioxyde de carbone (CO2), et la substance friable et blanchâtre obtenue est la chaux vive, ou oxyde de calcium (CaO) ; on en déduit que le calcaire oolithique est essentiellement constitué de carbonate de calcium (CaCO3) ✓ — c''est d''ailleurs cette réaction qu''exploitent les fours à chaux. La vapeur d''eau et l''odeur fétide seraient le résultat du chauffage d''une roche phosphatée, pas d''un calcaire. Le bicarbonate de calcium ne se forme pas par la chaleur mais par dissolution dans une eau chargée en CO2 — et il se produit en solution, pas dans un tube chauffé. Quant au quartz, il constitue le sable et n''apparaît jamais par chauffage.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5baf0c74-bedc-5ae6-bdf5-1bb35259bd41', '0eff20ca-a60b-58b0-98ec-6ba17513be7e', 'Le manuel affirme que le calcaire oolithique est « imperméable à l''échelle de l''échantillon » mais « perméable dans la nature ». Pourquoi cette différence ?', '[{"id":"a","text":"Parce que la roche devient soluble une fois exposée à la pluie et au vent"},{"id":"b","text":"Parce que, dans la nature, la roche est parcourue de fissures"},{"id":"c","text":"Parce que la roche est poreuse, et la porosité suffit à la rendre perméable"},{"id":"d","text":"Parce que la chaleur du soleil dilate la roche et ouvre peu à peu ses pores"}]'::jsonb, 'b', 'Le calcaire oolithique, imperméable à l''échelle de l''échantillon, est perméable dans la nature à cause des fissures qu''il présente ✓ : l''eau ne traverse pas la roche elle-même, elle passe par les cassures qui la parcourent — la propriété change parce que l''échelle d''observation change. La solubilité n''est pas en cause ici : elle exige une eau chargée en CO2 et provoque un tout autre phénomène, l''élargissement des fissures. La porosité est le distracteur essentiel : la roche est bel et bien poreuse, mais poreux et perméable ne sont pas synonymes — poreux signifie contenir des vides, perméable se laisser traverser, et le test montre justement que l''eau pénètre sans ressortir de l''autre côté.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('442eedd3-72c6-54f1-a5cd-c080ed17bac2', '0eff20ca-a60b-58b0-98ec-6ba17513be7e', 'Comment se forment les stalactites au plafond d''une grotte ?', '[{"id":"a","text":"Le calcaire du plafond fond sous l''effet de la chaleur puis se fige en aiguilles"},{"id":"b","text":"L''eau chargée en CO2 dissout le plafond et y creuse des aiguilles calcaires"},{"id":"c","text":"Des grains de quartz s''accumulent au plafond et se cimentent entre eux"},{"id":"d","text":"L''eau riche en bicarbonate de calcium suinte, perd son CO2 et dépose du calcaire"}]'::jsonb, 'd', 'Au plafond des grottes, l''eau suinte sans cesse ; elle est très riche en bicarbonate de calcium. Chaque goutte s''évapore en perdant son dioxyde de carbone et abandonne une mince pellicule de calcaire : ainsi se forment les colonnes descendantes, les stalactites ✓. C''est la réaction de précipitation, qui se déclenche dès que le milieu s''appauvrit en CO2. La dissolution fait exactement le contraire : elle enlève de la matière, elle creuse les cavités — c''est elle qui a formé la grotte, pas ses aiguilles. Le quartz n''intervient pas, et aucune fusion n''a lieu : la chaleur d''une grotte ne fait rien fondre du tout.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8761db1b-e387-537c-850e-9cf67cf88b38', '0eff20ca-a60b-58b0-98ec-6ba17513be7e', 'Dans la falaise de Ras Amer, les strates 1 et 3 (calcaires) sont saillantes tandis que la strate 2 (argile silteuse) est creusée. Comment l''expliquer ?', '[{"id":"a","text":"Les calcaires sont plus récents, ils ont donc eu moins de temps pour s''éroder"},{"id":"b","text":"Les calcaires sont plus épais que la strate d''argile silteuse creusée"},{"id":"c","text":"Le calcaire est dur et résiste ; le silt est tendre et s''altère"},{"id":"d","text":"L''argile silteuse s''est déposée dans un creux préexistant de la falaise"}]'::jsonb, 'c', 'Le calcaire, relativement dur, résiste à l''altération et à l''action des agents d''érosion ; le silt, relativement tendre et friable, s''altère plus facilement ✓ : c''est l''érosion différentielle, et c''est pourquoi le relief révèle la dureté des roches. L''âge n''y est pour rien, et l''argument se retourne : la strate 3, la plus ancienne des trois, est pourtant saillante. L''épaisseur non plus — les strates 2 et 3 font toutes deux environ 80 cm, et l''une est creusée quand l''autre est saillante : voilà qui règle la question. Enfin, un dépôt dans un creux préexistant contredirait la sédimentation, qui aboutit à des couches horizontales superposées.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('61a384d3-05a2-5545-b134-31071d7a68fe', '0eff20ca-a60b-58b0-98ec-6ba17513be7e', 'Où et dans quelles conditions des oolithes se forment-elles actuellement ?', '[{"id":"a","text":"Dans le golfe de Gabès, en mer peu profonde, chaude et agitée"},{"id":"b","text":"Au fond des mers profondes et froides, à l''abri de toute agitation"},{"id":"c","text":"Dans les lagunes sursalées, par évaporation du sel gemme"},{"id":"d","text":"Dans les eaux douces des rivières, riches en quartz"}]'::jsonb, 'a', 'Des oolithes se forment actuellement dans le golfe de Gabès et d''autres mers peu profondes et chaudes, de 22 à 31 °C, très riches en bicarbonate de calcium provenant de l''altération chimique des roches calcaires ✓. La suite du mécanisme demande l''agitation : quand la teneur en CO2 baisse — par absorption du CO2 par les végétaux marins verts ou par évaporation — le carbonate de calcium précipite autour des grains de sable ou des fragments de coquilles que l''agitation de l''eau met en suspension. Une mer profonde, froide et calme est donc exclue sur les trois critères à la fois ; c''est là que se déposent les calcaires à globigérines. Le sel gemme et le gypse signent un faciès lagunaire, et l''eau douce un faciès continental — ni l''un ni l''autre ne fabrique d''oolithes.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a4ad16ab-645a-5874-b779-e924880746ea', 'e5983da0-45a8-5f71-b0e8-06496a06800b', 'svt-1ere-sec', '⭐⭐ Révision (type examen) : Reconstituer une histoire géologique', 2, 75, 15, 'practice', 'admin', 3)
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
  ('2bdcfc97-b186-5b88-a16a-47f784473bb6', 'a4ad16ab-645a-5874-b779-e924880746ea', 'D''après l''échelle des temps géologiques du manuel, entre quels âges se situe l''éocène ?', '[{"id":"a","text":"Entre 23 et 5 millions d''années"},{"id":"b","text":"Entre 35 et 23 millions d''années"},{"id":"c","text":"Entre 55 et 35 millions d''années"},{"id":"d","text":"Entre 135 et 66 millions d''années"}]'::jsonb, 'c', 'Dans le tableau des temps géologiques, la ligne de l''éocène est encadrée par 35 au-dessus et 55 au-dessous : l''éocène s''étend donc de 55 à 35 millions d''années ✓. C''est une borne fiable — elle s''accorde avec l''échelle stratigraphique internationale, qui date l''éocène d''environ 56 à 34 millions d''années. Les trois autres intervalles sont ceux d''époques voisines, et c''est ce qui les rend tentants : 23 à 5 est le miocène, 35 à 23 l''oligocène — l''époque juste au-dessus de l''éocène —, et 135 à 66 le crétacé. Attention au piège du tableau sur ce dernier : comme il omet le Paléocène (66 à 56 Ma), il laisse croire que le crétacé rejoint directement l''éocène à 55 Ma. Repère-toi toujours sur les deux nombres qui bordent la ligne, jamais sur un seul.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ecd9da59-79c5-52e3-bedd-3a007223118d', 'a4ad16ab-645a-5874-b779-e924880746ea', 'Une strate renferme des coquilles d''Hélix, un gastéropode terrestre. Quel est son faciès, et qu''en déduit-on sur la mer ?', '[{"id":"a","text":"Faciès marin peu profond : la mer recouvrait la région"},{"id":"b","text":"Faciès lagunaire : la région était un bassin côtier séparé de la mer par un haut fond"},{"id":"c","text":"Faciès continental de terre ferme : la région n''était pas couverte par la mer, il y a eu régression"},{"id":"d","text":"Faciès marin profond : la strate s''est déposée au large"}]'::jsonb, 'c', 'L''Hélix est un gastéropode terrestre : un escargot ne vit pas dans la mer. La strate 2 de Ras Amer, qui en renferme, a donc un faciès continental de terre ferme — la région n''était pas couverte par la mer au moment de son dépôt, ce qui témoigne d''une régression ✓. Or elle est encadrée par deux strates calcaires de faciès marin : c''est ce petit escargot, à lui seul, qui fait basculer le milieu et permet de compter deux cycles sédimentaires au quaternaire sur ce site. Un faciès marin peu profond se lirait dans des coquilles de mollusques marins, comme les strombes de la strate 3. Le faciès lagunaire se reconnaît au gypse et au sel gemme. Et le faciès marin profond correspond au calcaire à globigérines.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bb2362db-bb79-550d-a722-c849c6bc7ee7', 'a4ad16ab-645a-5874-b779-e924880746ea', 'Une roche calcaire contient des tests calcaires de nummulites, coquilles de protozoaires géants du groupe des foraminifères. On la trouve au Kef et à Makthar. De quelle roche s''agit-il, et quel est son faciès ?', '[{"id":"a","text":"Le calcaire à nummulites, de faciès marin assez profond"},{"id":"b","text":"Le calcaire coquiller, de faciès marin peu profond"},{"id":"c","text":"Le calcaire quartzeux, d''origine chimique"},{"id":"d","text":"Le calcaire à globigérines, de faciès marin profond"}]'::jsonb, 'a', 'C''est le calcaire à nummulites, qu''on trouve à l''ouest et au centre de la Tunisie — Kef, Makthar… — et qui correspond à un faciès de mer assez profonde ✓ ; ses nummulites sont d''âge éocène moyen. Le calcaire coquiller se reconnaît à ses coquilles de lamellibranches et de gastéropodes marins, et son faciès est marin peu profond : le tableau des faciès les range d''ailleurs dans deux colonnes voisines, ce qui rend la confusion facile. Le calcaire quartzeux est le calcaire de la croûte, rose saumon, de la côte Est, d''âge villafranchien. Quant au calcaire à globigérines, il est le marqueur du faciès marin profond, un cran plus au large encore.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7a3593fb-27c6-5bed-a678-7678f16dc694', 'a4ad16ab-645a-5874-b779-e924880746ea', 'Reconstitue l''histoire géologique de la falaise de Sidi Mhareb : remets les six événements dans l''ordre chronologique.', '[{"id":"a","text":"Au miocène, sédimentation des couches de la série inférieure dans une mer peu profonde"},{"id":"b","text":"À la fin du miocène, un plissement affecte ces couches, qui prennent un pendage de 40°"},{"id":"c","text":"Le plissement provoque un soulèvement, accompagné d''une régression marine"},{"id":"d","text":"L''érosion altère le sommet du pli et l''aplanit"},{"id":"e","text":"Au tyrrhénien, une transgression dépose la couche horizontale de calcaire oolithique"},{"id":"f","text":"À la fin du tyrrhénien, la mer se retire"}]'::jsonb, NULL, 'L''histoire débute au miocène par la formation de la série inférieure, de faciès marin : la région était couverte par la mer. À la fin du miocène, un plissement affecte ces couches, d''où leur pendage de 40° — la déformation vient forcément après le dépôt, puisqu''on ne plie que ce qui existe déjà. Le plissement entraîne le soulèvement de la série et la régression marine. L''érosion aplanit ensuite le sommet du pli : c''est ce qui explique que la surface séparant les deux séries soit horizontale, alors qu''elle devrait présenter le sommet d''un anticlinal — et l''aplanissement suppose évidemment que le pli ait déjà émergé. Puis, au tyrrhénien, une transgression dépose le calcaire oolithique horizontal, en contact anormal avec les couches inclinées : les deux séries sont discordantes. La mer se retire enfin à la fin du tyrrhénien ✓.', 4, 'ordering', '{"order":["a","b","c","d","e","f"]}'::jsonb, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e3c7962c-b124-5de0-9e91-a2382d58a39d', 'a4ad16ab-645a-5874-b779-e924880746ea', 'Que signifie l''affirmation « les deux séries de la falaise de Sidi Mhareb sont discordantes » ?', '[{"id":"a","text":"Elles renferment des fossiles de milieux différents, l''un marin, l''autre continental"},{"id":"b","text":"La série supérieure est en contact anormal avec les couches inclinées du dessous"},{"id":"c","text":"Elles ont été séparées par une faille, qui a abaissé un compartiment entier"},{"id":"d","text":"Elles ont exactement le même âge, mais sont faites de roches différentes"}]'::jsonb, 'b', 'La série supérieure est horizontale, la série inférieure inclinée à 40° : elles ne sont pas parallèles, ce qui constitue une superposition anormale et montre qu''il n''y a pas eu continuité de sédimentation entre les deux ✓. C''est cela, la discordance — et c''est un renseignement précieux : entre les deux dépôts se sont glissés un plissement, un soulèvement, une régression et une érosion. Un changement de faciès marin/continental signalerait une transgression ou une régression, mais la discordance est affaire de géométrie, pas de fossiles : les deux séries de Sidi Mhareb ont d''ailleurs toutes deux un faciès marin peu profond. Aucune faille n''intervient ici : la déformation constatée est un pli, pas une cassure. Et deux séries discordantes ont forcément des âges différents — miocène et tyrrhénien.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d66d27df-8593-5f14-a7c4-0bc352eab269', 'a4ad16ab-645a-5874-b779-e924880746ea', 'Sur une berge, les dépôts vont, en s''éloignant de la côte, des blocs et galets aux graviers, puis aux sables et enfin aux vases. Quel principe permet d''utiliser cette observation pour interpréter une roche ancienne ?', '[{"id":"a","text":"Le principe de superposition"},{"id":"b","text":"Le principe des causes actuelles : les phénomènes géologiques anciens sont analogues à ceux qui se passent actuellement"},{"id":"c","text":"Le principe de la datation absolue par les âges en millions d''années"},{"id":"d","text":"Le principe de l''érosion différentielle"}]'::jsonb, 'b', 'C''est le principe des causes actuelles : pour reconstituer l''histoire d''un terrain sédimentaire, on suppose que les phénomènes géologiques anciens sont analogues à ceux qui se passent actuellement ✓. C''est lui qui autorise tout le reste du chapitre — observer le granoclassement d''aujourd''hui pour lire un dépôt vieux de millions d''années, ou déduire des oolithes actuelles du golfe de Gabès les conditions de formation de celles de Kerkenah. Le principe de superposition sert à ordonner des strates dans le temps, pas à identifier un milieu. La datation absolue n''est pas un principe du chapitre : le tableau fournit les âges tels quels, et la datation pratiquée ici est relative. L''érosion différentielle explique le modelé du relief — pourquoi le calcaire fait saillie et le silt un creux —, pas le classement des dépôts par taille.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ee91b1db-e0c4-5eeb-9b2f-d1f8141aefe3', 'ce4eb157-d67d-5937-b357-93ffb1c7ecd3', 'svt-1ere-sec', 'Test de compréhension ⭐ : Le phosphate', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('a34cf3d8-841e-5277-8ef9-66a9d8659bd1', 'ee91b1db-e0c4-5eeb-9b2f-d1f8141aefe3', 'À partir de quelle teneur en P2O5 un gisement de phosphate est-il exploitable ?', '[{"id":"a","text":"À partir de 25 %"},{"id":"b","text":"À partir de 47 %"},{"id":"c","text":"À partir de 56 %"},{"id":"d","text":"Quelle que soit la teneur, si la couche est épaisse"}]'::jsonb, 'a', 'Les gisements de phosphate ne sont exploitables que lorsque la teneur en P2O5 est supérieure ou égale à 25 % ✓. Les autres pourcentages existent bien dans le chapitre, mais désignent tout autre chose : 47 % de P2O5 est la teneur du triple superphosphate, un produit fabriqué en usine, et non celle d''un gisement ; et 56 % est le bas de la fourchette du phosphate de Metlaoui exprimée en BPL, une autre façon d''exprimer la teneur, par l''équivalent en phosphate tricalcique Ca3(PO4)2. Enfin, l''épaisseur ne remplace pas la teneur : la puissance de la couche est un critère de rentabilité, mais il s''ajoute au seuil de teneur, il ne le supprime pas.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('beb27003-b53b-5be9-bc7d-79c337997e67', 'ee91b1db-e0c4-5eeb-9b2f-d1f8141aefe3', 'Qui a découvert les phosphates tunisiens, et où ?', '[{"id":"a","text":"Philippe Thomas, en 1885, aux îles Kerkenah, au large de Sfax"},{"id":"b","text":"Philippe Thomas, en 1885, dans le bassin du Kef, au nord"},{"id":"c","text":"Le docteur Roux, en 1894, à Kalaa Khasba, dans le Kef"},{"id":"d","text":"Philippe Thomas, en 1885, à Jebel Thelja près de Metlaoui"}]'::jsonb, 'd', 'C''était en avril 1885, lors d''une prospection dans la région de Metlaoui, que Philippe Thomas, géologue amateur français, a découvert des couches puissantes de phosphates de calcium sur le versant Nord de Jebel Thelja ✓. Le bassin du Kef est bien l''un des deux bassins phosphatés avec celui de Gafsa, mais ce n''est pas le lieu de la découverte. Le docteur Roux n''a rien à voir avec la géologie : c''est le disciple de Pasteur qui, en 1894, mit au point la sérothérapie — un nom du chapitre 6, glissé ici pour vérifier que tu ne réponds pas au hasard. Quant aux îles Kerkenah, elles sont le site géologique du chapitre 7, sans phosphate.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('287249d7-d73c-5479-aeab-bd1208bcb4e9', 'ee91b1db-e0c4-5eeb-9b2f-d1f8141aefe3', 'Qu''est-ce qu''un coprolithe, dans une roche phosphatée ?', '[{"id":"a","text":"Un grain phosphaté de forme sphérique ou ovoïde"},{"id":"b","text":"Un grain cylindrique de quelques millimètres à 2 cm, correspondant à des restes d''excréments d''organismes"},{"id":"c","text":"Une petite sphère formée d''enveloppes successives de calcaire autour d''un noyau"},{"id":"d","text":"Un déchet solide provenant de l''action de l''acide sulfurique sur le minerai"}]'::jsonb, 'b', 'Les coprolithes sont des grains cylindriques de quelques millimètres à 2 cm environ, qui correspondent à des restes d''excréments d''organismes ✓ — et c''est pour cela qu''ils comptent parmi les meilleurs arguments en faveur de l''origine organique du phosphate. Le grain phosphaté sphérique ou ovoïde est le pellet : les deux se voient à la loupe binoculaire dans le même échantillon, ce qui rend la confusion facile — retiens que le pellet est rond et le coprolithe cylindrique. La sphère faite d''enveloppes successives de calcaire autour d''un noyau est l''oolithe, du chapitre précédent. Et le déchet de l''acide sulfurique est le phosphogypse, qui n''est pas dans la roche mais sort de l''usine.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8323eadf-2d9b-5bf2-865a-a19f703bdbe3', 'ee91b1db-e0c4-5eeb-9b2f-d1f8141aefe3', 'Selon le bilan, quelles sont les deux origines du phosphate ?', '[{"id":"a","text":"Une origine marine et une origine lagunaire"},{"id":"b","text":"Une origine chimique et une origine organique"},{"id":"c","text":"Une origine détritique et une origine volcanique"},{"id":"d","text":"Une origine chimique uniquement"}]'::jsonb, 'b', 'On pense actuellement que le phosphate a deux origines : l''une chimique, l''autre organique ✓. La chimique : les courants ascendants font monter des eaux froides riches en ions phosphate HPO4--, qui se combinent avec les ions calcium Ca++ des eaux chaudes de surface pour donner du phosphate de calcium qui précipite. L''organique : le plancton concentre le phosphore, ses cadavres s''accumulent dans un fond pauvre en oxygène, et les bactéries décomposent partiellement la matière organique. Marin et lagunaire sont des faciès, c''est-à-dire des milieux de dépôt, non des origines. Aucune origine volcanique n''est évoquée. Et retenir la seule origine chimique reviendrait à oublier les coprolithes et l''odeur fétide, qui sont les preuves de l''autre.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('52f775a5-9f6d-5706-aedd-2befca9277e8', 'ee91b1db-e0c4-5eeb-9b2f-d1f8141aefe3', 'Qu''est-ce que le phosphogypse ?', '[{"id":"a","text":"Un déchet gazeux rejeté lors de la fabrication des engrais"},{"id":"b","text":"Le minerai de phosphate débarrassé de ses impuretés solides"},{"id":"c","text":"Un déchet solide provenant de l''action de l''acide sulfurique sur le minerai de phosphate"},{"id":"d","text":"Un engrais chimique constitué essentiellement de phosphates"}]'::jsonb, 'c', 'Le phosphogypse est un déchet solide provenant de l''action de l''acide sulfurique sur le minerai de phosphate ✓ : il apparaît à l''étape de fabrication de l''acide phosphorique, et il est stocké à proximité de l''usine, sur trois sites — SIAPE A et NPK à Sfax, et la Skhira. Il n''est pas gazeux : les déchets gazeux de la filière sont les gaz fluorés, les gaz soufrés et le gaz ammoniacal — la distinction solide/gazeux est justement ce que l''item vérifie. Le minerai débarrassé de ses impuretés solides est le minerai de phosphate lui-même, c''est-à-dire le produit recherché et non un déchet. Et l''engrais constitué essentiellement de phosphates est le DAP, le diammonium phosphate.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6dccdf2a-b99f-5888-9622-c0201d5daec5', 'ce4eb157-d67d-5937-b357-93ffb1c7ecd3', 'svt-1ere-sec', '⭐ Exercice : Reconnaître et exploiter une roche phosphatée', 1, 50, 10, 'practice', 'admin', 1)
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
  ('b4ba1f0b-7add-5613-9bc9-7f81653da047', '6dccdf2a-b99f-5888-9622-c0201d5daec5', 'Quels fossiles trouve-t-on le plus fréquemment dans la roche phosphatée ?', '[{"id":"a","text":"Des strombes"},{"id":"b","text":"Des hélix"},{"id":"c","text":"Des dents de requins"},{"id":"d","text":"Des os de mammifères terrestres"}]'::jsonb, 'c', 'Le phosphate renferme souvent des fossiles, et les dents de requin sont les plus fréquents ✓ ; on rencontre aussi parfois un squelette entier ou des os de divers vertébrés marins, des coquilles de mollusques, et de nombreux tests de microorganismes visibles sur lames minces. Les strombes appartiennent au chapitre précédent : ce sont les gastéropodes du calcaire oolithique de Monastir et de Kerkenah, d''âge quaternaire. Les hélix sont les escargots terrestres de la strate 2 de Ras Amer. Quant aux os de mammifères terrestres, ils contrediraient toute la genèse du phosphate : les fossiles qu''il contient appartiennent à des animaux qui vivaient dans une mer peu profonde.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1b2ede3a-b847-51d2-b4c9-f18bde8c9963', '6dccdf2a-b99f-5888-9622-c0201d5daec5', 'Quels sont les avantages de l''exploitation du phosphate à ciel ouvert par rapport aux mines souterraines ?', '[{"id":"a","text":"Elle augmente la teneur en P2O5 du minerai extrait"},{"id":"b","text":"Elle permet d''atteindre les couches les plus profondes du gisement"},{"id":"c","text":"Elle supprime les déchets solides et gazeux de la filière"},{"id":"d","text":"Elle réduit les dangers liés à l''extraction et les coûts, tout en augmentant la capacité de production"}]'::jsonb, 'd', 'Autrefois, l''exploitation se déroulait dans des mines souterraines : une extraction à la fois dangereuse, coûteuse et peu rentable. À présent, elle se déroule dans des carrières à ciel ouvert pour réduire les dangers liés à l''extraction et les coûts, tout en augmentant la capacité de production ✓ — les chiffres le confirment : de 6 millions de tonnes à la fin des années 1980 à plus de 8 millions en 2000. Atteindre les couches profondes est au contraire ce que permettaient les mines souterraines. Les déchets ne disparaissent pas : le phosphogypse et les gaz fluorés viennent de la transformation chimique, une étape ultérieure que le mode d''extraction ne change pas. Et la teneur en P2O5 est une propriété du gisement : on ne la modifie pas en changeant d''outil — c''est le lavage qui enrichit le minerai.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cb6b615c-d0af-532b-b20c-08cdda3e006e', '6dccdf2a-b99f-5888-9622-c0201d5daec5', 'On met un échantillon de phosphate de 1 cm3 dans un tube à essai contenant 10 cm3 d''eau pure. Après agitation, on ne constate aucun changement. Qu''en déduit-on ?', '[{"id":"a","text":"La roche est insoluble dans l''eau"},{"id":"b","text":"La roche est non poreuse"},{"id":"c","text":"La roche est imperméable à l''eau"},{"id":"d","text":"La roche est compacte et résistante"}]'::jsonb, 'a', 'L''expérience ne teste qu''une chose : la roche ne se dissout pas, elle est donc insoluble ✓. Tout le piège de l''item est là — aucune des trois autres propositions ne se déduit de CETTE expérience. Deux d''entre elles sont pourtant vraies de la roche phosphatée, mais elles se démontrent autrement : l''imperméabilité en versant encore de l''eau, qui ne traverse pas ; l''aspect compact et résistant, en observant l''échantillon. La troisième, « non poreuse », est carrément fausse : verse de l''eau dans un creux ménagé dans la roche, elle est rapidement absorbée — la roche est bel et bien poreuse. Retiens la règle : une conclusion ne vaut que ce que vaut le protocole qui la produit.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0dc6d5d3-da53-5635-aeda-e3e54a400284', '6dccdf2a-b99f-5888-9622-c0201d5daec5', 'Une goutte d''eau déposée à la surface d''un échantillon de phosphate prélevé du gisement de Metlaoui est rapidement absorbée. Qu''est-ce que cela indique ?', '[{"id":"a","text":"La roche est perméable"},{"id":"b","text":"La roche est poreuse"},{"id":"c","text":"La roche est soluble"},{"id":"d","text":"La roche est friable"}]'::jsonb, 'b', 'L''eau est rapidement absorbée : la roche contient donc des vides capables de l''emmagasiner — elle est poreuse ✓. Perméable est le distracteur redoutable, et c''est exactement le couple que le manuel te fait distinguer depuis le chapitre du calcaire oolithique : être poreux, c''est contenir des vides ; être perméable, c''est se laisser traverser. Or la suite de l''expérience montre que l''eau ne traverse pas la roche : elle est poreuse ET imperméable. Soluble serait le contraire de ce qu''on observe, puisque l''échantillon dans l''eau pure ne subit aucune modification. Et la friabilité dépend du gisement — friable à Kef Shfaier, non friable à Kalaa Khasba — mais elle ne se teste pas avec une goutte d''eau.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9da0ea1c-2c1c-5f78-aea2-96469dadf6de', '6dccdf2a-b99f-5888-9622-c0201d5daec5', 'L''odeur fétide dégagée par une roche phosphatée indique qu''elle contient :', '[{"id":"a","text":"Des coprolithes"},{"id":"b","text":"Du phosphogypse"},{"id":"c","text":"De la matière organique"},{"id":"d","text":"Du pétrole"}]'::jsonb, 'c', 'La présence de coprolithes et l''odeur fétide dégagée par la roche phosphatée montrent que le phosphate contient de la matière organique ✓ — c''est l''un des deux arguments qui plaident pour son origine organique. Les coprolithes sont le distracteur le plus fin : ils sont bien présents dans la roche, et ils pointent eux aussi vers la matière organique, mais ils se voient à la loupe binoculaire, ils ne se sentent pas — l''odeur ne les révèle pas. Le phosphogypse n''est pas dans la roche : c''est un déchet produit en usine par l''action de l''acide sulfurique sur le minerai. Et le pétrole n''est cité par le manuel que comme exemple de gisement, jamais comme constituant du phosphate.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('590e9170-cd34-5e7d-a6f4-35f4dd273530', '6dccdf2a-b99f-5888-9622-c0201d5daec5', 'Le lavage à l''eau du minerai sert à le débarrasser de ses impuretés solides. Lesquelles ?', '[{"id":"a","text":"Le nitrate, le phosphate et le potassium"},{"id":"b","text":"Le phosphogypse, les gaz fluorés et le gaz ammoniacal"},{"id":"c","text":"Les pellets, les coprolithes et les dents de requins"},{"id":"d","text":"L''argile, le carbonate de calcium, l''oxyde de magnésium et le fluorure de calcium"}]'::jsonb, 'd', 'La préparation du minerai consiste à séparer le phosphate de ses impuretés solides — l''argile, le carbonate de calcium, l''oxyde de magnésium et le fluorure de calcium — par lavage à l''eau ou par ventilation à l''air ✓ ; la boue rejetée en est d''ailleurs riche. Le phosphogypse et les gaz apparaissent bien plus loin dans la chaîne, lors de la transformation chimique, et ce sont des déchets produits, non des impuretés retirées. Les pellets sont les grains phosphatés eux-mêmes, c''est-à-dire précisément ce qu''on cherche à garder ; les éliminer n''aurait aucun sens. Et le nitrate, le phosphate et le potassium sont les composants des engrais NPK, tout au bout de la filière.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d1c3f92e-0177-5e9c-b448-bff50031a451', 'ce4eb157-d67d-5937-b357-93ffb1c7ecd3', 'svt-1ere-sec', '⭐⭐ Révision (type examen) : Genèse, exploitation et pollution', 2, 75, 15, 'practice', 'admin', 3)
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
  ('93e8c005-e9fa-5a47-87ed-e7c721aed29f', 'd1c3f92e-0177-5e9c-b448-bff50031a451', 'Pourquoi dit-on que le phosphate a une origine chimique ?', '[{"id":"a","text":"Parce que les ions phosphate HPO4-- se combinent avec les ions calcium Ca++ pour donner du phosphate de calcium qui précipite"},{"id":"b","text":"Parce que le phosphore concentré dans les os est libéré sous l''action des bactéries"},{"id":"c","text":"Parce qu''il provient de sédiments formés par l''accumulation de cadavres qui ont concentré le phosphore"},{"id":"d","text":"Parce que l''acide sulfurique le transforme en acide phosphorique"}]'::jsonb, 'a', 'L''origine chimique tient tout entière dans une réaction de précipitation : les courants ascendants font monter les eaux froides riches en ions phosphate (HPO4--), qui se mélangent aux eaux superficielles chaudes riches en ion calcium (Ca++) ; dans ces conditions, HPO4-- se combine avec Ca++ pour donner du phosphate de calcium qui précipite ✓. Les deux propositions suivantes décrivent au contraire l''origine organique — le rôle des bactéries, l''accumulation des cadavres de plancton concentrateur de phosphore : ce sont de vraies explications, mais de l''autre origine, et c''est ce qui les rend tentantes. Quant à l''acide sulfurique, il agit dans une usine, aujourd''hui : la question porte sur la genèse de la roche dans un bassin sédimentaire, il y a des dizaines de millions d''années.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('693ca151-0290-57e7-b386-b274d69d99c9', 'd1c3f92e-0177-5e9c-b448-bff50031a451', 'Dans un gisement de Metlaoui, huit couches phosphatées sont décrites, mais deux seulement sont en cours d''exploitation. Quels critères justifient ce choix ?', '[{"id":"a","text":"Uniquement leur teneur en P2O5 exprimée en BPL"},{"id":"b","text":"Leur situation proche de la surface, leur puissance relativement importante et leur teneur importante en P2O5"},{"id":"c","text":"Uniquement leur épaisseur, car le lavage corrige ensuite la teneur"},{"id":"d","text":"Leur position sous une couche de gypse, qui protège le minerai"}]'::jsonb, 'b', 'Trois critères, et il faut les trois ✓ : leur situation proche de la surface, qui les rend facilement accessibles ; leur puissance — leur épaisseur — relativement importante ; et leur teneur importante en P2O5, exprimée en BPL, qui les rend très rentables. Retenir la seule teneur est l''erreur la plus courante : une couche très riche mais mince ou profonde ne serait pas rentable, même au-dessus du seuil de 25 %. L''épaisseur seule ne suffit pas davantage, et le lavage ne corrige rien de ce genre : il retire des impuretés solides, il ne crée pas du phosphate là où il n''y en a pas. Enfin, le gypse ne protège rien : quand il alterne avec les couches phosphatées, il renseigne sur les conditions de genèse — bassin lagunaire peu profond, climat chaud et sec.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5f978f50-9045-51ce-9bf0-02cc73eda6d3', 'd1c3f92e-0177-5e9c-b448-bff50031a451', 'L''analyse d''une nappe phréatique proche d''un site de stockage de phosphogypse donne un PH de 3,4, contre 6,5 à 9 dans une nappe non contaminée. Qu''en conclure ?', '[{"id":"a","text":"L''eau de la nappe polluée est devenue nettement basique"},{"id":"b","text":"L''eau de la nappe polluée est restée à peu près neutre"},{"id":"c","text":"L''eau de la nappe polluée est devenue acide"},{"id":"d","text":"Le PH n''a pas changé de manière significative"}]'::jsonb, 'c', 'Un PH compris entre 1 et 6 est acide, un PH de 7 est neutre, un PH entre 8 et 14 est basique. Avec 3,4, l''eau de la nappe proche du site est donc franchement acide ✓, alors qu''une nappe saine se tient entre 6,5 et 9. L''explication est dans la composition même du phosphogypse : sulfate de calcium, divers acides, sels de métaux lourds et éléments radioactifs — et sa solubilité, jointe à son contact avec le sol et l''air libre, accentue le risque de propagation aux nappes phréatiques. Basique serait la lecture inverse de l''échelle, l''erreur la plus fréquente. Neutre reviendrait à confondre 3,4 avec 7. Et parler d''un changement non significatif ne résiste pas au reste du tableau : le PO4 y passe de 0,1 à 10100.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c6b49bae-d828-56ae-8686-8381968589a8', 'd1c3f92e-0177-5e9c-b448-bff50031a451', 'Les phosphates tunisiens datent de :', '[{"id":"a","text":"− 40 MA"},{"id":"b","text":"− 60 MA"},{"id":"c","text":"− 80 MA"},{"id":"d","text":"− 100 MA"}]'::jsonb, 'b', 'La série phosphatée du bassin de Gafsa-Métlaoui s''est déposée entre environ 62 et 48 millions d''années, c''est-à-dire de la fin du Paléocène à l''éocène inférieur : parmi les quatre âges proposés, − 60 MA est donc le seul qui tombe dans cet intervalle ✓, et il correspond à la base de la série, ses couches les plus profondes et les plus anciennes. Les trois autres sont hors de portée : − 40 MA tomberait dans l''éocène moyen, bien après la fin du dépôt de la série ; − 80 MA et − 100 MA renverraient au crétacé, bien avant. ⚠️ Attention à un piège du manuel lui-même : son bilan p.175 écrit « ces fossiles sont d''âge éocène, c''est-à-dire il y a 60 millions d''années ». Or son propre tableau des temps géologiques p.154 place l''éocène entre 55 et 35 MA — et 60 MA est donc AVANT l''éocène, dans l''époque qui le précède, le Paléocène. Le tableau a raison sur l''échelle, et 60 MA a raison sur la roche ; ce qui est faux, c''est l''équivalence « éocène = 60 MA », parce que la série phosphatée est justement à cheval sur la limite entre les deux époques.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cf1bc10c-e044-54fe-a838-8355476b7eb5', 'd1c3f92e-0177-5e9c-b448-bff50031a451', 'On trouve parfois, en alternance avec les couches phosphatées, des couches de gypse. Quel renseignement en tire-t-on sur les conditions de genèse du phosphate ?', '[{"id":"a","text":"Le gypse précipite par intense évaporation : même bassin, mêmes conditions"},{"id":"b","text":"Le gypse est une roche détritique : le phosphate provient donc de matériaux transportés par le vent"},{"id":"c","text":"Le gypse indique une mer profonde et froide, donc le phosphate s''est déposé au large"},{"id":"d","text":"Le gypse est un déchet de l''exploitation : il ne renseigne pas sur la genèse"}]'::jsonb, 'a', 'Le gypse est une roche d''origine chimique : elle se forme par précipitation à la suite d''une intense évaporation, condition qui se réalise dans un bassin lagunaire peu profond et sous un climat chaud et sec. Comme le phosphate s''est formé dans le même bassin que le gypse, on en déduit que sa genèse s''est réalisée dans les mêmes conditions ✓ — ce qui recoupe exactement le décor décrit par le bilan : île de Kasserine, bassins peu profonds fermés par des hauts-fonds, climat chaud et sec. Le gypse n''est pas détritique mais chimique. Il ne signale jamais une mer profonde : le tableau des faciès le classe au contraire dans le faciès lagunaire, avec le sel gemme. Et il ne faut pas le confondre avec le phosphogypse, qui, lui, est bien un déchet d''usine.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('99bbd436-528d-56ae-b3a6-f82c07506c58', 'd1c3f92e-0177-5e9c-b448-bff50031a451', 'Certains chercheurs proposent d''installer de longues cheminées équipées de filtres pour limiter la pollution par les gaz rejetés. Quelle critique peut-on faire de cette solution ?', '[{"id":"a","text":"Elle est inutile : les gaz fluorés et soufrés n''ont aucun effet sur l''environnement"},{"id":"b","text":"Elle coûterait plus cher que le recyclage du phosphogypse, déjà pratiqué à grande échelle"},{"id":"c","text":"Une cheminée disperse le polluant plus loin sans jamais le supprimer"},{"id":"d","text":"Elle est superflue, puisque l''agression des polluants disparaît déjà au-delà de 1 km de l''usine"}]'::jsonb, 'c', 'La critique tient en trois temps ✓ : une cheminée plus haute ne supprime pas le polluant, elle le disperse plus loin — le problème est déplacé, pas résolu ; un filtre ne fait que transformer un déchet gazeux en déchet solide, qu''il faudra stocker à son tour ; et surtout, ni l''un ni l''autre ne touche au phosphogypse, le déchet le plus encombrant, dont les mesures retenues par le manuel sont justement de protéger les sites actuels et d''aménager des sites étudiés pour le stockage futur. Nier tout effet des gaz contredirait les données : abricotier et mûrier disparus dans un rayon de 1 km, dents et squelette atteints chez les moutons et les chèvres, lésions dentaires et affections respiratoires chez l''Homme. Le recyclage du phosphogypse n''est pas pratiqué à grande échelle — le manuel dit exactement l''inverse : « faute de solution immédiate pour le recyclage ». Et c''est au-delà de 10 km, non de 1 km, que l''agression disparaît de manière significative.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
      AND e.subject_id = 'svt-1ere-sec'
      AND e.source = 'admin';
  END IF;
END $$;

