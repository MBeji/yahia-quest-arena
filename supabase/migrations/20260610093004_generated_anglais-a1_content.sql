-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: anglais-a1 (Anglais — Débutant (A1))
-- Regenerate with: npm run content:build
-- Source of truth: content/anglais-a1/
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
  ('anglais-a1', 'Anglais — Débutant (A1)', 'Build a rock-solid English foundation, from the simplest forms upward: the verb to be, the present simple, articles and plurals, everyday vocabulary, and asking questions. Beginner level (CEFR A1).', 'Agilité', 'subject-english', 'Globe', 1, 'en', false, 'anglais', NULL)
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
      AND e.subject_id = 'anglais-a1'
      AND e.source = 'admin'
      AND q.id NOT IN ('fe4699e3-c3ea-5853-b101-1a008821acb0', '1619cd55-9702-594c-a93b-a3a4198af2df', '8950244f-7b43-5798-8c44-2ca8743b5be2', 'aca51462-9715-5382-a016-03fd8ffd2c36', '706f3f90-133a-5121-9d68-88cdeea03e95', '091ff6c6-85f1-57f5-b92e-8a8c44ca1154', '457b0f25-b5cf-5c39-bfdf-b4d785980bfa', 'a50c2dcb-451d-5d9b-b711-98db3ce99a27', '15023bce-c1ca-50b7-a82c-f86371c2c45f', '60b13d75-daf3-583d-8aa1-89daa7acbe14', 'f18ee8b3-db44-5a39-a067-bc3b0092a92f', '183d6d10-68ea-5d0f-91b5-712dffe56a66', '4bbc0a49-7a63-5750-9758-b3f9654b9d3e', 'a38e60b5-b18e-57f6-a221-335ec947b83f', '971bad98-c42d-5b0b-b6ab-80f31bfbba98', '6193ef82-4d27-5444-934d-e9bcb5161d7f', '45e5de92-d3e1-5dfe-b2be-e33cbc5f0a13', '81c57232-c062-5a1b-91b1-3550f4de9636', 'e40b11fc-6367-5518-b659-8eab9888fd28', '0c22bb0b-4afc-5462-9e79-33f639986ef5', '8b9c82bb-f6b7-56b2-831e-baf2d28248f0', 'c657698d-3480-5384-a3a3-4b3616e9245f', 'f3a6d832-f4d9-5c07-bd00-d8f70b7fea65', '1d2f2bbc-5db4-5fa5-9caf-7d7a05dbc279', '53f7b82f-d642-5368-be66-fb3301ee98d8', '3ce1ede7-822f-50c4-82e1-d30ccf14e309', 'f1228173-f4be-5046-ab08-7d2b5230d327', '4760283b-4992-5e58-b8b6-3b1f2a2da70c', 'de526bf6-3d4f-513c-8198-4ab62e02d815', 'b073a67a-c149-5e09-821b-108f3aa2a219', 'a6657ae1-7f38-5151-a397-6a2d61981120', '8b6cd876-701b-53d6-85bc-ccb102f77e79', '1f5fb57d-9957-51b5-b5f5-f93f4b942ce4', 'db55597d-8b58-5e89-97e2-c9ef3c285510', '1e9a1e47-bc0e-50cc-879c-0962b068aff8', '2681050e-555f-5ef8-9f46-48f542a82c6e', 'e64003f2-c755-5d7b-8434-7c2789558335', 'd6a7f8be-3a99-514f-b885-0d536b10b712', '6d50a018-0eae-5b73-8dc8-28e12051e061', 'b7825e12-8e8f-5088-a207-8fdd37ceba25', '72259d00-0a1f-586d-826d-029652dfa778', '25d372a1-964f-5dca-9548-2d7264b95e8b', 'c2c6b06e-d311-5288-b86d-67fe1f7b68e2', '830dd8e0-79e5-5d6a-93ca-863f35839c9a', 'bc8b022d-0c40-5bbf-8653-fd0123180ce3', 'c3963605-3d2f-553d-ae17-ad3e041bd344', '569412b6-61f2-517d-87de-5a65c694ce6a', '509d5be7-ba32-5dac-bf4d-46e323c2be19', '5a7352e0-1bbd-56ef-b0c0-99b3266c3aad', 'ee3ba4a1-6b77-5ddb-bda0-20d9c6aa51dd', '4294f02e-aa68-54e1-90d0-badab2f7b83f', 'ae18a2ad-9ecc-52b1-a549-f6a9a256a8a3', 'b1a7b127-d682-55ee-939c-3eb638829182', '13a2287c-1145-5a90-ab36-085db0683dd2', '869d6fe5-c672-5c19-964d-9aa52b1953e2', '71bb0366-ec6a-5297-a644-ed40a2e728d6', '7dced33e-471a-523e-ac27-31945a9a5c08', '24febc89-64b4-5bcc-b7e8-f65287d9fb1c', '7029f9f4-f8ab-5398-8fdc-ec7323bb21c8', 'e4e78a5a-b3f4-5ac9-b7e8-8da350fe7a01', 'ae59c583-504e-528f-b6d5-ec86394e92a3', '5e97df05-9bc2-59fe-ad56-ff9c7db381e6', '0e57404a-4af2-5f92-953b-9274c8117a78', 'b10d151a-6ef2-51b2-85ef-87864cee61fb', '06c41759-d6e1-5882-a15e-1c7d1e16339f', '384c9aba-2abb-5362-a6e5-aaad42dc9e94', '266a58db-315c-5cbe-a7e6-afddee112bfa', '18123a68-0da4-5ba6-9906-63dd1fb27d98', '5e3bfe44-d8ff-5888-a469-69c98929df50', '6429ad3d-d835-5341-a9bf-fc4fd803c830', '531aa9c1-7391-544a-bf28-98eb0175b2f3', '156408d1-a003-52df-8fa4-d3080831a4e1', 'a33fb8fc-1b4c-59d9-b17e-8ef1442f3a72', '7b06c133-5ef6-5ba8-98da-ca5fbc314603', '76035e9d-7fdf-5c95-a325-a4ba02f0c1ed', '148b4ebf-ffc0-59ca-8cb8-ac581aef50f5', 'b550c982-b3f4-52f3-bcde-d7223cea8737', '702739aa-c0aa-5053-b6e5-bc2ae666857c', 'ae239e7d-9e7d-5432-97f3-512706447e68', '83de3154-d3a5-5ff2-93b9-c61706107b45', '59704327-ec10-562a-b7e4-f2496f255934', 'd8d2f8fa-63b8-5f03-81ab-d5df5eebd601', '92ce5ae2-162b-5743-8e24-62dd65826f63', '372d4938-d90e-5b2f-80fe-748fd9e0165a', 'f10d0d2f-ae45-5e9e-b160-f6e82ad80834', 'acf28a2a-194b-555b-a246-452e41534cfb', 'a066d288-6333-5ac2-b898-3354552916f4', '13eb3135-e044-570a-8b97-903812961b55', '5ec6b27d-7832-508d-98fa-bce31daf979e', 'ff8eba4b-ee4e-5e37-bd43-6452b430ff7e', '221ebe12-2177-55de-b4f0-6e9f6e59f08f', '392f5a74-8da3-5859-a829-623c7a6268fa', 'a4587eca-d506-5b78-a225-9efae3fc266c', '08efe4db-4555-53e3-ae13-880254acb5ca', '80dd2770-449a-5732-bec3-54c6aa65c3a4', '6bf5e7db-111d-56dd-bdea-6f6da6748864', '6d723e15-398c-5dea-a066-1bca6b216f24', 'ca3f58bc-14f7-52d3-9732-e29b5dc62927', '8745a26b-b690-5013-92a4-1a05451a01fb', '6bb99919-7568-5977-adda-4c8fa824da4a', '8063fc05-8dc8-5398-bb04-7e64abf3abeb', '4ad0f688-b675-537a-8011-0915b32e6245', '3d1e0bae-e7b9-54d9-b264-5fd04e0a993a', '7be098c1-1f15-5eb8-bf34-d42e8e911943', '42a7c8e7-1eeb-53a0-b25a-e1ec71a7cae8', '37606d8d-d4f0-5ba4-ba81-3d6bfc7e1325', 'e652893f-706a-57a2-831d-23ada4e230e5', 'c4553e00-df33-5575-8492-f617529c1076', '483d8b4d-6d44-5ff8-8f37-24bf9dfce15d', 'df2e8782-df88-5ac6-953f-0865b97814cf', '43fad7ff-f4a5-5aeb-8884-a4b68434898b', '688aa952-dae9-5587-b93e-776591d7252b', '23548b3e-3f66-5a12-9e65-87b318e463ea', '43597329-4a82-5161-b031-c63e18b57f94', 'e30c9d41-ce13-552e-aa79-68880ef16cc0', '28e20ebf-274c-5733-9e74-7a82aeb79375', 'e902bbb7-bdea-59e9-b4a3-c6e6705bd254', '173a5a03-c02d-5187-a05b-e42443cf8450', 'e124370e-46ee-5a92-a48c-b620d6d98937', 'd07882ea-5945-52df-a447-0dcfce491c6b', '456a9857-93e9-522f-ae55-075d5583e4e5', '4fad0a5e-b283-5d86-bc4e-dd654e1816c9', '7b1a01df-051e-5c43-90da-a24c3a58112f', 'dbe3cf4f-127c-588d-8980-a356fc492380', '079bd38b-f44f-5dda-9bc5-0a533066c261', 'd927e93b-9657-5dc2-89c5-2e844e7832a8', '0c32eda4-ecf4-5d0f-9a62-3126df54f75c', 'c969dd44-e2a9-51b5-b81e-e101863b9cc0', '1d244fe6-d1c3-5f30-a59d-f6d712d85e68', 'e6654964-99c8-5771-94ae-82b794d909c0', '0c1c94bf-fea7-5b4e-b6cf-1cfa248fae82', 'da41b10a-55dc-5f5d-a3fb-6093a20de504', '24337e38-ca1f-5d72-bdcd-a511baf08559', '26b7248b-5b68-57b0-86eb-a572778e1492', '87cecf68-6eb1-52cc-b20f-0b3b725f9360', '02b7d2ed-1255-514a-9fd1-33b653d4b912', 'a4bb39dc-24d7-5933-8f0a-ac50f799e480', 'f6877d05-08de-52d0-a838-cfa2205af978', '00467c90-2f80-593e-a7ff-fb4dab9b7ce1', '50544641-ac20-5882-a00d-59cf033a1f35', '69cb30b1-48d3-5d3a-b593-2c5b574a27fd', '7db59d48-6616-5e9a-9b9c-5900893d758d', '8c148db8-d6c1-5b2a-9ed9-a7912adf0dbc', '6ea6a154-1c20-50ce-8311-f6c13429e7ff', '05cf392e-777c-5c48-ac31-f802b94a4700');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'anglais-a1' AND source = 'admin' AND id NOT IN ('b7b185cb-0d9f-55bf-9ac4-81fd01fc1836', '8d69552a-faf3-5f8e-b73e-66ad45e9ca03', '9bf2a39b-3058-52d3-9115-76ede71cbbf0', '9860732e-e955-5d66-ba01-4c84d2062b46', '272651b1-0cc8-5e5d-b7fc-d5bccd9df48f', 'b8b5d5de-6541-5a88-8374-156a189c693f', 'a7a8d1ac-34a4-537f-ab0d-e2ba1d2a83d7', '3ad8a3f9-5ac3-54eb-97d7-42da8484cd84', '20c1e986-8207-5a28-a3df-b172c4d25e26', 'd565f83b-fd9b-521c-b491-fed48fac2430', '8de56c53-db69-5599-bbce-249faaf336d7', '9ffcc5e4-c155-5f06-b6f1-69b01f100447', '0a4d76db-5c96-5d2c-917e-a4dabdb32b86', '167fbb60-d79f-5b42-98f4-c4e0ce5c8853', '77b95119-56fa-54ff-9be9-37ac4236bdbd', 'e1072fcc-506d-5230-ac88-bf45d655f06f', '1f2dc15f-42d1-53be-8ce2-aa2a737933af', '7f4ce371-1e6c-56bb-97df-254cf6f95e5d', '2e3c5811-d0bf-5232-a2ea-c59741945936', '7f2abee2-eb27-5c45-aff9-08df89c5fba1', 'a9bcdd7e-8453-540f-8c64-0f7c6b449dc7', '177729d8-9816-5129-86ea-b7e98e738979', '7f3cc6f2-61bf-5e73-ba2b-708a3dfeace4', 'e8380938-5f4a-5925-ab89-1b28604c029f', '99efb0dc-be51-5a2d-9c11-073853507af9');
DELETE FROM public.questions WHERE exercise_id IN ('b7b185cb-0d9f-55bf-9ac4-81fd01fc1836', '8d69552a-faf3-5f8e-b73e-66ad45e9ca03', '9bf2a39b-3058-52d3-9115-76ede71cbbf0', '9860732e-e955-5d66-ba01-4c84d2062b46', '272651b1-0cc8-5e5d-b7fc-d5bccd9df48f', 'b8b5d5de-6541-5a88-8374-156a189c693f', 'a7a8d1ac-34a4-537f-ab0d-e2ba1d2a83d7', '3ad8a3f9-5ac3-54eb-97d7-42da8484cd84', '20c1e986-8207-5a28-a3df-b172c4d25e26', 'd565f83b-fd9b-521c-b491-fed48fac2430', '8de56c53-db69-5599-bbce-249faaf336d7', '9ffcc5e4-c155-5f06-b6f1-69b01f100447', '0a4d76db-5c96-5d2c-917e-a4dabdb32b86', '167fbb60-d79f-5b42-98f4-c4e0ce5c8853', '77b95119-56fa-54ff-9be9-37ac4236bdbd', 'e1072fcc-506d-5230-ac88-bf45d655f06f', '1f2dc15f-42d1-53be-8ce2-aa2a737933af', '7f4ce371-1e6c-56bb-97df-254cf6f95e5d', '2e3c5811-d0bf-5232-a2ea-c59741945936', '7f2abee2-eb27-5c45-aff9-08df89c5fba1', 'a9bcdd7e-8453-540f-8c64-0f7c6b449dc7', '177729d8-9816-5129-86ea-b7e98e738979', '7f3cc6f2-61bf-5e73-ba2b-708a3dfeace4', 'e8380938-5f4a-5925-ab89-1b28604c029f', '99efb0dc-be51-5a2d-9c11-073853507af9') AND id NOT IN ('fe4699e3-c3ea-5853-b101-1a008821acb0', '1619cd55-9702-594c-a93b-a3a4198af2df', '8950244f-7b43-5798-8c44-2ca8743b5be2', 'aca51462-9715-5382-a016-03fd8ffd2c36', '706f3f90-133a-5121-9d68-88cdeea03e95', '091ff6c6-85f1-57f5-b92e-8a8c44ca1154', '457b0f25-b5cf-5c39-bfdf-b4d785980bfa', 'a50c2dcb-451d-5d9b-b711-98db3ce99a27', '15023bce-c1ca-50b7-a82c-f86371c2c45f', '60b13d75-daf3-583d-8aa1-89daa7acbe14', 'f18ee8b3-db44-5a39-a067-bc3b0092a92f', '183d6d10-68ea-5d0f-91b5-712dffe56a66', '4bbc0a49-7a63-5750-9758-b3f9654b9d3e', 'a38e60b5-b18e-57f6-a221-335ec947b83f', '971bad98-c42d-5b0b-b6ab-80f31bfbba98', '6193ef82-4d27-5444-934d-e9bcb5161d7f', '45e5de92-d3e1-5dfe-b2be-e33cbc5f0a13', '81c57232-c062-5a1b-91b1-3550f4de9636', 'e40b11fc-6367-5518-b659-8eab9888fd28', '0c22bb0b-4afc-5462-9e79-33f639986ef5', '8b9c82bb-f6b7-56b2-831e-baf2d28248f0', 'c657698d-3480-5384-a3a3-4b3616e9245f', 'f3a6d832-f4d9-5c07-bd00-d8f70b7fea65', '1d2f2bbc-5db4-5fa5-9caf-7d7a05dbc279', '53f7b82f-d642-5368-be66-fb3301ee98d8', '3ce1ede7-822f-50c4-82e1-d30ccf14e309', 'f1228173-f4be-5046-ab08-7d2b5230d327', '4760283b-4992-5e58-b8b6-3b1f2a2da70c', 'de526bf6-3d4f-513c-8198-4ab62e02d815', 'b073a67a-c149-5e09-821b-108f3aa2a219', 'a6657ae1-7f38-5151-a397-6a2d61981120', '8b6cd876-701b-53d6-85bc-ccb102f77e79', '1f5fb57d-9957-51b5-b5f5-f93f4b942ce4', 'db55597d-8b58-5e89-97e2-c9ef3c285510', '1e9a1e47-bc0e-50cc-879c-0962b068aff8', '2681050e-555f-5ef8-9f46-48f542a82c6e', 'e64003f2-c755-5d7b-8434-7c2789558335', 'd6a7f8be-3a99-514f-b885-0d536b10b712', '6d50a018-0eae-5b73-8dc8-28e12051e061', 'b7825e12-8e8f-5088-a207-8fdd37ceba25', '72259d00-0a1f-586d-826d-029652dfa778', '25d372a1-964f-5dca-9548-2d7264b95e8b', 'c2c6b06e-d311-5288-b86d-67fe1f7b68e2', '830dd8e0-79e5-5d6a-93ca-863f35839c9a', 'bc8b022d-0c40-5bbf-8653-fd0123180ce3', 'c3963605-3d2f-553d-ae17-ad3e041bd344', '569412b6-61f2-517d-87de-5a65c694ce6a', '509d5be7-ba32-5dac-bf4d-46e323c2be19', '5a7352e0-1bbd-56ef-b0c0-99b3266c3aad', 'ee3ba4a1-6b77-5ddb-bda0-20d9c6aa51dd', '4294f02e-aa68-54e1-90d0-badab2f7b83f', 'ae18a2ad-9ecc-52b1-a549-f6a9a256a8a3', 'b1a7b127-d682-55ee-939c-3eb638829182', '13a2287c-1145-5a90-ab36-085db0683dd2', '869d6fe5-c672-5c19-964d-9aa52b1953e2', '71bb0366-ec6a-5297-a644-ed40a2e728d6', '7dced33e-471a-523e-ac27-31945a9a5c08', '24febc89-64b4-5bcc-b7e8-f65287d9fb1c', '7029f9f4-f8ab-5398-8fdc-ec7323bb21c8', 'e4e78a5a-b3f4-5ac9-b7e8-8da350fe7a01', 'ae59c583-504e-528f-b6d5-ec86394e92a3', '5e97df05-9bc2-59fe-ad56-ff9c7db381e6', '0e57404a-4af2-5f92-953b-9274c8117a78', 'b10d151a-6ef2-51b2-85ef-87864cee61fb', '06c41759-d6e1-5882-a15e-1c7d1e16339f', '384c9aba-2abb-5362-a6e5-aaad42dc9e94', '266a58db-315c-5cbe-a7e6-afddee112bfa', '18123a68-0da4-5ba6-9906-63dd1fb27d98', '5e3bfe44-d8ff-5888-a469-69c98929df50', '6429ad3d-d835-5341-a9bf-fc4fd803c830', '531aa9c1-7391-544a-bf28-98eb0175b2f3', '156408d1-a003-52df-8fa4-d3080831a4e1', 'a33fb8fc-1b4c-59d9-b17e-8ef1442f3a72', '7b06c133-5ef6-5ba8-98da-ca5fbc314603', '76035e9d-7fdf-5c95-a325-a4ba02f0c1ed', '148b4ebf-ffc0-59ca-8cb8-ac581aef50f5', 'b550c982-b3f4-52f3-bcde-d7223cea8737', '702739aa-c0aa-5053-b6e5-bc2ae666857c', 'ae239e7d-9e7d-5432-97f3-512706447e68', '83de3154-d3a5-5ff2-93b9-c61706107b45', '59704327-ec10-562a-b7e4-f2496f255934', 'd8d2f8fa-63b8-5f03-81ab-d5df5eebd601', '92ce5ae2-162b-5743-8e24-62dd65826f63', '372d4938-d90e-5b2f-80fe-748fd9e0165a', 'f10d0d2f-ae45-5e9e-b160-f6e82ad80834', 'acf28a2a-194b-555b-a246-452e41534cfb', 'a066d288-6333-5ac2-b898-3354552916f4', '13eb3135-e044-570a-8b97-903812961b55', '5ec6b27d-7832-508d-98fa-bce31daf979e', 'ff8eba4b-ee4e-5e37-bd43-6452b430ff7e', '221ebe12-2177-55de-b4f0-6e9f6e59f08f', '392f5a74-8da3-5859-a829-623c7a6268fa', 'a4587eca-d506-5b78-a225-9efae3fc266c', '08efe4db-4555-53e3-ae13-880254acb5ca', '80dd2770-449a-5732-bec3-54c6aa65c3a4', '6bf5e7db-111d-56dd-bdea-6f6da6748864', '6d723e15-398c-5dea-a066-1bca6b216f24', 'ca3f58bc-14f7-52d3-9732-e29b5dc62927', '8745a26b-b690-5013-92a4-1a05451a01fb', '6bb99919-7568-5977-adda-4c8fa824da4a', '8063fc05-8dc8-5398-bb04-7e64abf3abeb', '4ad0f688-b675-537a-8011-0915b32e6245', '3d1e0bae-e7b9-54d9-b264-5fd04e0a993a', '7be098c1-1f15-5eb8-bf34-d42e8e911943', '42a7c8e7-1eeb-53a0-b25a-e1ec71a7cae8', '37606d8d-d4f0-5ba4-ba81-3d6bfc7e1325', 'e652893f-706a-57a2-831d-23ada4e230e5', 'c4553e00-df33-5575-8492-f617529c1076', '483d8b4d-6d44-5ff8-8f37-24bf9dfce15d', 'df2e8782-df88-5ac6-953f-0865b97814cf', '43fad7ff-f4a5-5aeb-8884-a4b68434898b', '688aa952-dae9-5587-b93e-776591d7252b', '23548b3e-3f66-5a12-9e65-87b318e463ea', '43597329-4a82-5161-b031-c63e18b57f94', 'e30c9d41-ce13-552e-aa79-68880ef16cc0', '28e20ebf-274c-5733-9e74-7a82aeb79375', 'e902bbb7-bdea-59e9-b4a3-c6e6705bd254', '173a5a03-c02d-5187-a05b-e42443cf8450', 'e124370e-46ee-5a92-a48c-b620d6d98937', 'd07882ea-5945-52df-a447-0dcfce491c6b', '456a9857-93e9-522f-ae55-075d5583e4e5', '4fad0a5e-b283-5d86-bc4e-dd654e1816c9', '7b1a01df-051e-5c43-90da-a24c3a58112f', 'dbe3cf4f-127c-588d-8980-a356fc492380', '079bd38b-f44f-5dda-9bc5-0a533066c261', 'd927e93b-9657-5dc2-89c5-2e844e7832a8', '0c32eda4-ecf4-5d0f-9a62-3126df54f75c', 'c969dd44-e2a9-51b5-b81e-e101863b9cc0', '1d244fe6-d1c3-5f30-a59d-f6d712d85e68', 'e6654964-99c8-5771-94ae-82b794d909c0', '0c1c94bf-fea7-5b4e-b6cf-1cfa248fae82', 'da41b10a-55dc-5f5d-a3fb-6093a20de504', '24337e38-ca1f-5d72-bdcd-a511baf08559', '26b7248b-5b68-57b0-86eb-a572778e1492', '87cecf68-6eb1-52cc-b20f-0b3b725f9360', '02b7d2ed-1255-514a-9fd1-33b653d4b912', 'a4bb39dc-24d7-5933-8f0a-ac50f799e480', 'f6877d05-08de-52d0-a838-cfa2205af978', '00467c90-2f80-593e-a7ff-fb4dab9b7ce1', '50544641-ac20-5882-a00d-59cf033a1f35', '69cb30b1-48d3-5d3a-b593-2c5b574a27fd', '7db59d48-6616-5e9a-9b9c-5900893d758d', '8c148db8-d6c1-5b2a-9ed9-a7912adf0dbc', '6ea6a154-1c20-50ce-8311-f6c13429e7ff', '05cf392e-777c-5c48-ac31-f802b94a4700');
DELETE FROM public.chapters c WHERE c.subject_id = 'anglais-a1' AND c.id NOT IN ('a9babe02-35db-5739-b219-57a666359ba6', 'e702c00c-86b8-5423-b0e2-5cb024ce78a3', '23ae9a2a-83b4-5566-9f6a-6a72af1cc3a5', '4637b3e6-610c-5b41-b0f9-dba49d698d90', '492783bf-3de9-5c90-81ff-7ead506d6381') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('a9babe02-35db-5739-b219-57a666359ba6', 'anglais-a1', 'The Verb "To Be"', 'Master am, is and are — the most important verb in English — in affirmative, negative and question forms, with contractions, short answers and there is / there are.', '# ⚔️ The Verb "To Be" — Your First Power-Up

> 💡 «Learn one verb well and you can already say who you are, where you are, and how you feel.»

## 🏰 Why "to be" opens every gate

**To be** is the most used verb in English. It links a subject to what it *is*, *where* it is, or *how* it feels. Master its three present forms — **am**, **is**, **are** — and you can build hundreds of true sentences from day one.

_I **am** a student. She **is** happy. They **are** at school._

## ⚡ The three forms (present simple)

Every subject pronoun takes exactly one form. Learn this table by heart — it is the foundation of everything that follows.

| Subject         | Form | Example                 |
| --------------- | ---- | ----------------------- |
| I               | am   | _I **am** ready._       |
| he / she / it   | is   | _She **is** my friend._ |
| you / we / they | are  | _We **are** a team._    |

> 🗡️ Quick rule: **I → am**, **he / she / it → is**, everything plural (and *you*) → **are**.

## 🛡️ Contractions — how natural English sounds

In speech and informal writing we shorten *subject + verb*. The meaning is identical.

| Full form | Contraction |
| --------- | ----------- |
| I am      | I''m         |
| you are   | you''re      |
| he is     | he''s        |
| she is    | she''s       |
| it is     | it''s        |
| we are    | we''re       |
| they are  | they''re     |

_**I''m** tired. **She''s** at home. **They''re** my cousins._

> ⚠️ Classic trap: **it''s** (= *it is*) is not the same as **its** (possessive). _**It''s** cold today_ vs _The dog wags **its** tail._

## 🔮 The negative — just add "not"

To make a sentence negative, put **not** after the verb. Two contractions are common.

_I am **not** late. → **I''m not** late._
_He is **not** here. → He **isn''t** here. / He**''s not** here._
_They are **not** ready. → They **aren''t** ready._

> 🗡️ Note: there is **no** "amn''t" — for *I* always use **I''m not**.

## 🧭 Questions — flip the order

For a yes/no question, put the verb **before** the subject (this swap is called *inversion*).

_You are happy. → **Are** you happy?_
_She is a doctor. → **Is** she a doctor?_

Short answers reuse the verb — never the main word:
_**Are** you a student? — **Yes, I am.** / **No, I''m not.**_
_**Is** it Monday? — **Yes, it is.** / **No, it isn''t.**_

With a question word (*what, where, who, how old*), that word comes first:
_**Where is** she? **How are** you? **What is** your name?_

> ⚠️ Trap: do **not** add *do/does* with *to be*. Say _Are you ready?_, never _~~Do you are ready?~~_

## 🌍 "There is" / "There are"

Use **there is** for one thing and **there are** for several, to say that something *exists* somewhere.

_**There is** a book on the table. **There are** two cats in the garden._

> 🏆 First gate cleared! With **am / is / are**, their negatives, questions and short answers, you can already describe people, places and feelings. Next stop: the **present simple**, to talk about habits and routines.', '# 📜 Résumé: The Verb "To Be"

- **Three present forms** — *I am*, *he / she / it is*, *you / we / they are*. The base of every simple sentence.
- **Contractions** — *I''m, you''re, he''s, she''s, it''s, we''re, they''re*; same meaning, more natural.
- **Negative** — add *not* after the verb: *isn''t, aren''t*, and *I''m not* (there is no "amn''t").
- **Yes/no questions** — invert subject and verb: *Are you…? Is she…?* — never add *do/does*.
- **Short answers** — reuse the verb: *Yes, I am. / No, it isn''t.*
- **Question words** — *Where is…? How are…? What is your name?*
- **There is / there are** — say that something exists (one thing / several things).
- ⚠️ *It''s* (= *it is*) ≠ *its* (possessive); *they''re* ≠ *their* ≠ *there*.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('e702c00c-86b8-5423-b0e2-5cb024ce78a3', 'anglais-a1', 'The Present Simple', 'Use the present simple to talk about habits, routines and general truths — the third-person -s/-es rule, spelling changes, negatives and questions with do/does, and adverbs of frequency.', '# ⚔️ The Present Simple — The Tense of Everyday Life

> 💡 «Tell me what you do every day, and I''ll tell you who you are.»

## 🏰 What the present simple is for

The **present simple** is your everyday tense. You use it for three big things: **habits and routines** (what you do regularly), **general truths** (facts that are always true), and **timetables** (fixed schedules). It is the most common tense in spoken English — master it and you can describe your whole life.

_I **live** in Tunis. She **works** in a hospital. Water **boils** at 100 degrees._

## ⚡ The basic form — and the third-person -s

With most subjects you simply use the **base verb** (the dictionary form). But with **he**, **she** and **it** you must add **-s**. This little **-s** is the heart of the whole chapter.

| Subject         | Form        | Example                          |
| --------------- | ----------- | -------------------------------- |
| I / you / we / they | base verb   | _They **play** football._        |
| he / she / it   | base + **-s** | _He **plays** football._         |

_I **work**. You **work**. We **work**. They **work**. → But: He **works**. She **works**. It **works**.

> 🗡️ One golden cue: **he / she / it = one extra -s**. Everything else keeps the plain base verb.

## 🛡️ Spelling the -s ending

The third-person ending is usually just **-s**, but some verbs change their spelling.

| Verb ends in…              | Rule              | Example                  |
| -------------------------- | ----------------- | ------------------------ |
| most verbs                 | add **-s**        | _work → **works**_       |
| -ch, -sh, -ss, -x, -o      | add **-es**       | _watch → **watches**, go → **goes**_ |
| consonant + **-y**         | **-y → -ies**     | _study → **studies**, fly → **flies**_ |
| vowel + -y                 | just add **-s**   | _play → **plays**_       |

_She **studies** English. He **goes** to school. The bird **flies** away._

> ⚠️ Classic trap: never write _~~studys~~_, _~~watchs~~_ or _~~gos~~_. The spelling is **studies**, **watches**, **goes**.

## 🔮 The negative — don''t / doesn''t + base verb

To make a negative, add **do not (don''t)** or, for he/she/it, **does not (doesn''t)** before the **base verb**. Here is the key: once you use **doesn''t**, the **-s** is already inside it, so the main verb goes back to its **base form**.

_I **don''t** like coffee. We **don''t** work on Sunday._
_She **doesn''t** like coffee. He **doesn''t** work on Sunday._

> ⚠️ The number-one mistake: double marking. Say _She **doesn''t work**_, never _~~She doesn''t works~~_. The **-s** lives on *does*, not on the main verb.

## 🧭 Questions — do / does + base verb

For yes/no questions, start with **do** or **does**, then the subject, then the **base verb**. Again: with **does**, the main verb stays in its **base form**.

_**Do** you live here? **Do** they speak French?_
_**Does** she live here? **Does** he speak French?_

Short answers reuse the auxiliary:
_**Do** you like tea? — **Yes, I do. / No, I don''t.**_
_**Does** he work here? — **Yes, he does. / No, he doesn''t.**_

With a question word (*what, where, when, how often*), that word comes first:
_**Where do** you live? **What does** she do? **How often do** they train?_

> 🗡️ Two traps in one rule: use _**Does** he…?_ (not _~~Do he…?~~_), and keep the base verb — _**Does** she **go**…?_, never _~~Does she goes…?~~_

## 🌟 Adverbs of frequency

To say *how often* something happens, use **always, usually, often, sometimes, never**. They go **before the main verb** — but **after** the verb *be*.

_She **always** gets up early. They **often** play outside. I **never** eat fast food._
_He **is usually** late._ (after *be*) vs _He **usually** finishes at six._ (before a normal verb)

> ⚠️ Word-order trap: say _He **always goes** to school_, never _~~He goes always to school~~_. The frequency adverb comes **before** the main verb.

> 🏆 Gate cleared! You can now describe routines, state facts, deny them with don''t/doesn''t, ask about them with do/does, and time them with frequency adverbs. Next stop: **articles and plurals** — *a*, *an*, *the*, and how to make nouns plural.', '# 📜 Résumé: The Present Simple

- **Uses** — habits and routines, general truths, and fixed timetables: *I live in Tunis. Water boils at 100°.*
- **Basic form** — use the base verb for *I / you / we / they*: *They play football.*
- **Third-person -s** — add **-s** for *he / she / it*: *He plays. She works. It rains.*
- **Spelling** — *-ch/-sh/-ss/-x/-o → -es* (*watch → watches*, *go → goes*); *consonant + y → -ies* (*study → studies*, *fly → flies*); *play → plays*.
- **Negative** — *don''t* / *doesn''t* + **base verb**: *She doesn''t work* — never *doesn''t works*.
- **Questions** — *do* / *does* + subject + **base verb**: *Does she go…?* — never *Do she…?* or *Does she goes…?*
- **Short answers** — reuse the auxiliary: *Yes, I do. / No, he doesn''t.*
- **Wh- questions** — question word first: *Where do you live? What does she do?*
- **Frequency adverbs** — *always, usually, often, sometimes, never* go **before the main verb**, but **after** *be*: *He always goes / He is usually late*.
- ⚠️ Golden rule: *does/doesn''t* already carries the *-s*, so the main verb stays in its **base form**.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('23ae9a2a-83b4-5566-9f6a-6a72af1cc3a5', 'anglais-a1', 'Articles & Plural Nouns', 'Choose a or an by sound, use the for what is specific and zero article for general plurals and uncountables, and build regular and irregular plurals correctly.', '# ⚔️ Articles & Plural Nouns — Naming Your Loot

> 💡 «Once you can name *a* thing, *the* thing, and *many* things, the whole world becomes describable.»

## 🏰 The three tiny words that open every door

English puts a small word in front of most nouns. **a** and **an** are the *indefinite* articles — one thing, mentioned for the first time. **the** is the *definite* article — a specific thing we both already know. Sometimes we use **no article at all** (the *zero* article). Master this trio and your sentences instantly sound natural.

_I have **a** dog. **The** dog is friendly. **Dogs** are loyal._

## ⚡ a or an? Trust your EARS, not the letter

The rule is about **sound**, not spelling. Use **an** before a **vowel sound**, and **a** before a **consonant sound**.

| Use   | Before a…        | Examples                                         |
| ----- | ---------------- | ------------------------------------------------ |
| **a** | consonant sound  | _a book, a university, a one-euro coin_          |
| **an**| vowel sound      | _an apple, an hour, an honest man, an MP_        |

Watch the tricky ones: _**a** university_ begins with a /j/ "yoo" sound; _**a** one-euro coin_ starts with a /w/ sound — both take **a** even though the letters are vowels. Meanwhile _**an** hour_ and _**an** honest man_ have a **silent h**, so they sound like vowels and take **an**.

> 🗡️ Quick test: say the word out loud. _An MP_ sounds like "**em**-pee" (vowel sound), so it takes **an** — never trust the letter alone.

## 🛡️ the vs a vs nothing

**the** = we both know *which one*. **a/an** = one of many, first mention. **No article** = something general or uncountable.

_I saw **a** film last night. **The** film was great._ (first **a**, then **the** because now it is known)
_**The** sun is hot today._ (there is only one — it is unique, so **the**)

> ⚠️ Trap: do **not** put **a/an** in front of a plural or an uncountable noun. Say _I like **music**_, never _~~a music~~_; say _**Cats** are nice_, never _~~A cats are nice~~_.

## 🔮 Zero article — general truths and uncountables

When you talk about things **in general**, use a **plural with no article**. Uncountable nouns (water, music, advice) also take **no article** when general — and they are never plural.

_**Cats** are independent. **Water** is essential. I love **coffee**._

If you mean specific ones, add **the**: _**The** cats next door are noisy._

## 🧮 Regular plurals — the spelling rulebook

Most nouns just add **-s**. But the spelling shifts in four predictable cases — learn the table and you will rarely guess wrong.

| Ending of the noun            | Rule                | Examples                                  |
| ----------------------------- | ------------------- | ----------------------------------------- |
| most nouns                    | add **-s**          | _book → books, boy → boys_                |
| -s, -x, -z, -ch, -sh          | add **-es**         | _bus → buses, box → boxes, watch → watches_ |
| consonant + **y**             | **y → -ies**        | _city → cities, baby → babies_            |
| vowel + **y**                 | just add **-s**     | _boy → boys, day → days, key → keys_      |
| some -f / -fe                 | **f → -ves**        | _knife → knives, leaf → leaves, wife → wives_ |

> 🗡️ The **-y** rule depends on the letter *before* y: a **consonant + y** flips to **-ies** (_baby → babies_), but a **vowel + y** simply adds **-s** (_boy → boys_, never _~~boies~~_).

## 🧪 Irregular plurals — the boss-level exceptions

Some of the most common nouns change in their own way. There is no spelling trick — these must be memorized.

| Singular | Plural   | Singular | Plural   |
| -------- | -------- | -------- | -------- |
| man      | men      | foot     | feet     |
| woman    | women    | tooth    | teeth    |
| child    | children | mouse    | mice     |
| person   | people   | fish     | fish     |
| sheep    | sheep    |          |          |

Note that **fish** and **sheep** do not change at all, and the plural of **person** is usually **people**.

> ⚠️ Trap: do not add **-s** to an irregular plural. It is _two **children**_ (never _~~childs~~_), _ten **men**_ (never _~~mans~~_), _three **mice**_ (never _~~mouses~~_), and _two **fish**_ (never _~~two fishes~~_).

> 🏆 Gate cleared! You can now name one thing, the thing, and many things — and spell the plurals like a native. Next stop: **everyday vocabulary**, where you will arm yourself with the words to fill these patterns.', '# 📜 Résumé: Articles & Plural Nouns

- **Three articles** — *a/an* (one thing, first mention), *the* (a specific, known thing), and *no article* (general or uncountable).
- **a vs an = sound, not letter** — *an* before a vowel **sound**, *a* before a consonant **sound**.
- **Tricky a** — *a university* (/j/ "yoo"), *a one-euro coin* (/w/): vowel letters, but consonant sounds.
- **Tricky an** — *an hour, an honest man, an MP*: silent h or a vowel-sound start, so *an*.
- **the** — use it when both speakers know which one, or for unique things (*the sun, the moon*).
- **Zero article** — general plurals and uncountables take **no** article: *Cats are nice. Water is essential.*
- **Regular plurals** — add *-s*; *-es* after s/x/z/ch/sh (*boxes, watches, buses*).
- **The -y rule** — consonant + y → *-ies* (*city → cities*); vowel + y → *-s* (*boy → boys*).
- **-f / -fe → -ves** — *knife → knives, leaf → leaves, wife → wives*.
- **Irregular plurals** — *man → men, woman → women, child → children, foot → feet, tooth → teeth, mouse → mice, person → people*; *fish* and *sheep* stay the same.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('4637b3e6-610c-5b41-b0f9-dba49d698d90', 'anglais-a1', 'Everyday Vocabulary', 'Build a starter word bank of the most common A1 fields — family, numbers, days and months, colours, objects at home and school, jobs, food and drink, and basic adjectives with their opposites.', '# 🗺️ Everyday Vocabulary — Stock Your Word Bank

> 💡 «Grammar is the map, but words are the treasure — collect enough and you can already speak.»

## 👪 The family circle

Your **family** is the first set of words every hero needs. Learn the core people and how they pair up by gender.

_My **mother** and **father** are my **parents**. My **sister** is older; my **brother** is younger._

| Female        | Male          | Both / plural |
| ------------- | ------------- | ------------- |
| mother        | father        | parents       |
| sister        | brother       | siblings      |
| daughter      | son           | children      |
| aunt          | uncle         | —             |
| niece         | nephew        | —             |
| grandmother   | grandfather   | grandparents  |

A **cousin** is the child of your aunt or uncle — the word is the same for a boy or a girl.

> ⚠️ Classic trap: **aunt** and **uncle** are a pair. Your **aunt** is the sister of your mother or father (or your uncle''s wife); your **uncle** is the brother of a parent. Likewise a **niece** is a girl and a **nephew** is a boy. Don''t mix the pairs up.

## 🔢 Numbers, days and months

Count with **cardinal** numbers — _one, two, three, four, five, ten, twenty, a hundred_ — and put things in order with **ordinals** — _**first**, **second**, **third**_.

The seven **days** are _Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday_. The twelve **months** run _January, February, March …_ to _December_.

> 🗡️ Quick rule: days and months are always **capitalized** in English — _Monday_, not _monday_; _July_, not _july_.

## 🎨 Colours

The basic **colours** paint your whole world: _**red**, **blue**, **green**, **yellow**, **black**, **white**, **orange**, **purple**, **brown**, **grey**_ (and **pink**).

_The sky is **blue**. Grass is **green**. Snow is **white**._

## 🏠 Objects at home and school

Name the **objects** around you. At home you see a _**table**, a **chair**, a **door**, a **window**, a **key**, a **phone**_. At school you use a _**book**, a **pen**, a **pencil**, a **bag**, a **desk**_.

_The **book** is on the **desk**. Open the **door** and the **window**._

> ⚠️ Pair to watch: a **pen** uses ink and a **pencil** uses lead (you can erase it). They look alike but they are not the same tool.

## 👷 Jobs

People do **jobs**: a _**teacher**_ teaches, a _**doctor**_ and a _**nurse**_ help sick people, a _**driver**_ drives, a _**cook**_ (or **chef**) makes food, a _**farmer**_ grows crops, an _**engineer**_ designs and builds.

_My mother is a **doctor**. My uncle is a **farmer**._

## 🍞 Food and drink

You eat **food** and drink **drinks**. Common food: _**bread**, **rice**, an **apple**, an **egg**_. Common drinks: _**water**, **milk**, **coffee**, **tea**_.

English groups things you cannot count with special words: _a **glass** of **water**, a **cup** of **tea**, a **slice** (or **piece**) of **bread**._

> 🗡️ Tip: use a **glass of water**, not a "piece of water" — pick the container word that fits the drink or food.

## ⚖️ Basic adjectives and opposites

**Adjectives** describe things, and most come in **opposite** pairs:

_**big** ↔ **small**, **hot** ↔ **cold**, **happy** ↔ **sad**, **old** ↔ **new**, **cheap** ↔ **expensive**, **fast** ↔ **slow**, **easy** ↔ **difficult**._

_This bag is **cheap**, but that phone is **expensive**. The first quest was **easy**; the boss is **difficult**._

> 🏆 Word bank stocked! With family, numbers, days, colours, objects, jobs, food and adjectives, you can already name the world around you. Next stop: putting these words into **questions** to ask who, what and where.', '# 📜 Résumé: Everyday Vocabulary

- **Family** — *mother / father → parents*, *sister / brother*, *son / daughter*, *aunt / uncle*, *niece / nephew*, *grandmother / grandfather*; a *cousin* is the child of an aunt or uncle.
- **Numbers** — cardinals count (*one, two, three…*); ordinals order (*first, second, third*).
- **Days & months** — seven days (*Monday … Sunday*), twelve months (*January … December*), always **capitalized**.
- **Colours** — *red, blue, green, yellow, black, white, orange, purple, brown, grey, pink*.
- **Home & school objects** — *table, chair, door, window, key, phone*; *book, pen, pencil, bag, desk*.
- **Jobs** — *teacher, doctor, nurse, driver, cook/chef, farmer, engineer*.
- **Food & drink** — *bread, rice, apple, egg*; *water, milk, coffee, tea*; *a glass of water*, *a cup of tea*.
- **Basic adjectives & opposites** — *big ↔ small, hot ↔ cold, happy ↔ sad, old ↔ new, cheap ↔ expensive, fast ↔ slow, easy ↔ difficult*.
- ⚠️ Don''t mix the pairs: *aunt* (female) ≠ *uncle* (male); *niece* (girl) ≠ *nephew* (boy); a *pen* (ink) ≠ a *pencil* (lead).', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('492783bf-3de9-5c90-81ff-7ead506d6381', 'anglais-a1', 'Asking Questions & Short Reading', 'Ask questions with the right question word and correct word order — using both the verb to be and do/does — match questions to their answers, and read short A1 texts to find details and make simple inferences.', '# ⚔️ Asking Questions & Short Reading — The Final A1 Gate

> 💡 «The hero who asks the right question already holds half the answer.»

## 🏰 Why questions are your sharpest weapon

In your first battles you learned to **state** facts. Now you learn to **ask** for them. A good question opens every door: it gets you a name, a place, a time, a reason. This is the last skill before the Donjon, and it fuses two powers you already own — the verb **to be** and the present simple with **do / does**.

_**What** is your name? **Where** do you live? **When** does the bus arrive?_

## ⚡ The question words (your spell list)

Each question word asks for a different kind of answer. Learn what each one *expects*, and you will never confuse a place with a time again.

| Question word | Asks about    | Example                          |
| ------------- | ------------- | -------------------------------- |
| what          | a thing       | _**What** is this?_              |
| where         | a place       | _**Where** is the school?_       |
| when          | a time        | _**When** do you start work?_    |
| who           | a person      | _**Who** is your teacher?_       |
| why           | a reason      | _**Why** are you happy?_         |
| how           | a manner      | _**How** do you go to school?_   |
| how many      | a number (countable) | _**How many** brothers do you have?_ |
| how much      | a quantity (uncountable) | _**How much** water do you drink?_ |
| whose         | a possession  | _**Whose** bag is this?_         |

## 🛡️ The golden word order

Every English question follows one fixed pattern. Burn it into memory:

**(Question word) + auxiliary / be + subject + …?**

_**Where** **is** **she**?_ · _**Who** **are** **they**?_ · _**What** **do** **you** **want**?_ · _**Where** **does** **he** **live**?_

> 🗡️ Quick rule: with **to be**, flip the order (_Where **is** she?_). With ordinary verbs, add **do** (I/you/we/they) or **does** (he/she/it) and keep the verb in its base form (_Where **does** he **live**?_, never _~~lives~~_).

## 🔮 Forming questions with BE vs. with DO/DOES

These are the two engines behind every question. Pick the right one.

- **With be** — just invert subject and verb, no helper: _She **is** a nurse. → **Is** she a nurse?_ · _**Where is** she a nurse?_
- **With ordinary verbs** — add **do/does** and use the **base** verb: _He **lives** in Tunis. → **Does** he **live** in Tunis?_ · _**Where does** he **live**?_

> ⚠️ Classic trap: never **double-mark** the verb. Say _Where **does** she **live**?_, never _~~Where does she lives?~~_ The **-s** lives on *does*, not on the main verb. And never drop the helper: _~~Where she lives?~~_ is wrong.

## 🧭 Short answers — match the question to its answer

The question word tells you the *shape* of the answer. A **Where** question wants a place; a **When** question wants a time; **Whose** wants an owner.

_**Where** is the cat? — **Under the table.**_
_**When** is the lesson? — **At nine o''clock.**_
_**Whose** pen is this? — **It''s Sara''s.**_

> 🗡️ Tip: if someone asks **Where** and you answer with a time (_at six_), the answer does not fit. Always check that the answer matches the question word.

## 📖 Short reading — find the detail, then think

Real English means *reading* short texts and pulling out facts. Read slowly, then answer in two ways:

- **Find a detail** — the answer is written in the text. _"Sara is a doctor. She works in a hospital."_ → **What is Sara''s job?** → *a doctor.*
- **Make an inference** — the text does not say it directly, but you can work it out. _"Sara works in a hospital. She helps sick people."_ → **Does Sara have a job?** → *Yes* (a hospital + helping people = work).

> ⚠️ Trap: an inference must be **supported by the text**. If the text never mentions Sara''s age, you cannot say "Sara is old." Stick to what the words allow.

> 🏆 Final A1 gate cleared! You can now ask for anything — names, places, times, reasons, amounts — and read a short text to find or infer the answer. Your A1 training is complete. The **Donjon** awaits, hero: one long gauntlet that mixes every skill you have earned. Step in.', '# 📜 Résumé: Asking Questions & Short Reading

- **Question words** — *what* (thing), *where* (place), *when* (time), *who* (person), *why* (reason), *how* (manner), *whose* (possession).
- **How many vs how much** — *how many* + countable (*how many books*), *how much* + uncountable (*how much water*).
- **Golden word order** — (question word) + auxiliary/be + subject + …: *Where is she? Who are they? What do you want?*
- **Questions with be** — just invert subject and verb, no helper: *Is she a nurse? Where is she?*
- **Questions with ordinary verbs** — add *do* (I/you/we/they) or *does* (he/she/it) + the **base** verb: *Where does he live?*
- ⚠️ Never **double-mark**: *Where does she live?* (not *does she lives*); never drop the helper: not *Where she lives?*
- **Match question to answer** — a *Where* question wants a place, a *When* question a time, *Whose* an owner.
- **Reading: find a detail** — the answer is written in the text; read it directly.
- **Reading: make an inference** — work out what the text implies, but only what the words **support**.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b7b185cb-0d9f-55bf-9ac4-81fd01fc1836', 'a9babe02-35db-5739-b219-57a666359ba6', 'anglais-a1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('fe4699e3-c3ea-5853-b101-1a008821acb0', 'b7b185cb-0d9f-55bf-9ac4-81fd01fc1836', 'Choose the correct form: "I ___ a student."', '[{"id":"a","text":"am"},{"id":"b","text":"is"},{"id":"c","text":"are"},{"id":"d","text":"be"}]'::jsonb, 'a', 'With the subject I, the verb to be is am: I am a student. He/she/it takes is, and you/we/they take are. Be is the base form (used after to or a modal), not a present-tense form here.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1619cd55-9702-594c-a93b-a3a4198af2df', 'b7b185cb-0d9f-55bf-9ac4-81fd01fc1836', 'Choose the correct form: "She ___ my friend."', '[{"id":"a","text":"am"},{"id":"b","text":"are"},{"id":"c","text":"is"},{"id":"d","text":"been"}]'::jsonb, 'c', 'He, she and it take is: She is my friend. Am goes only with I, and are with you/we/they. Been is the past participle (used with have/has), not a present form.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8950244f-7b43-5798-8c44-2ca8743b5be2', 'b7b185cb-0d9f-55bf-9ac4-81fd01fc1836', 'Which is the correct contraction of "they are"?', '[{"id":"a","text":"their"},{"id":"b","text":"they''re"},{"id":"c","text":"there"},{"id":"d","text":"theyre"}]'::jsonb, 'b', 'They are contracts to they''re, with an apostrophe. Watch the homophones: their is possessive (their car) and there shows place or existence (there is a car). "theyre" without an apostrophe is not a word.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aca51462-9715-5382-a016-03fd8ffd2c36', 'b7b185cb-0d9f-55bf-9ac4-81fd01fc1836', 'Which sentence is the correct negative of "He is here."?', '[{"id":"a","text":"He not is here."},{"id":"b","text":"He aren''t here."},{"id":"c","text":"He don''t here."},{"id":"d","text":"He isn''t here."}]'::jsonb, 'd', 'The negative of to be adds not after the verb: He is not here → He isn''t here. Aren''t is for you/we/they; don''t belongs to the present simple of ordinary verbs, not to be; and "not is" has the wrong word order.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('706f3f90-133a-5121-9d68-88cdeea03e95', 'b7b185cb-0d9f-55bf-9ac4-81fd01fc1836', 'How do you turn "You are ready." into a yes/no question?', '[{"id":"a","text":"Are you ready?"},{"id":"b","text":"You are ready?"},{"id":"c","text":"Do you are ready?"},{"id":"d","text":"Are ready you?"}]'::jsonb, 'a', 'With to be, make a question by inverting subject and verb: You are ready → Are you ready? You don''t add do with to be (that is for ordinary verbs), and the subject must come straight after the verb, so "Are ready you?" has the wrong order.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8d69552a-faf3-5f8e-b73e-66ad45e9ca03', 'a9babe02-35db-5739-b219-57a666359ba6', 'anglais-a1', '⭐ Practice: Am, Is, Are', 1, 50, 10, 'practice', 'admin', 1)
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
  ('091ff6c6-85f1-57f5-b92e-8a8c44ca1154', '8d69552a-faf3-5f8e-b73e-66ad45e9ca03', 'Complete: "My name ___ Sara."', '[{"id":"a","text":"am"},{"id":"b","text":"is"},{"id":"c","text":"are"},{"id":"d","text":"be"}]'::jsonb, 'b', '"My name" is a single thing (like it), so it takes is: My name is Sara. Use am only with I, and are with you/we/they.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('457b0f25-b5cf-5c39-bfdf-b4d785980bfa', '8d69552a-faf3-5f8e-b73e-66ad45e9ca03', 'Complete: "We ___ from Tunisia."', '[{"id":"a","text":"is"},{"id":"b","text":"am"},{"id":"c","text":"are"},{"id":"d","text":"be"}]'::jsonb, 'c', 'We always takes are: We are from Tunisia. Am is only for I, and is is only for he/she/it.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a50c2dcb-451d-5d9b-b711-98db3ce99a27', '8d69552a-faf3-5f8e-b73e-66ad45e9ca03', 'Complete: "I ___ twelve years old."', '[{"id":"a","text":"am"},{"id":"b","text":"is"},{"id":"c","text":"are"},{"id":"d","text":"have"}]'::jsonb, 'a', 'The subject I always takes am: I am twelve years old. Note that English uses to be for age (not have): say I am twelve, not "I have twelve".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('15023bce-c1ca-50b7-a82c-f86371c2c45f', '8d69552a-faf3-5f8e-b73e-66ad45e9ca03', 'Which is the correct way to contract "He is my brother"?', '[{"id":"a","text":"He''s my brother."},{"id":"b","text":"Hes my brother."},{"id":"c","text":"His my brother."},{"id":"d","text":"He''re my brother."}]'::jsonb, 'a', 'He is contracts to he''s: an apostrophe replaces the i of is. "Hes" is missing the apostrophe, "His" is the possessive adjective (his car), and the ''re contraction only works with are.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('60b13d75-daf3-583d-8aa1-89daa7acbe14', '8d69552a-faf3-5f8e-b73e-66ad45e9ca03', 'Complete: "The books ___ on the desk."', '[{"id":"a","text":"is"},{"id":"b","text":"am"},{"id":"c","text":"be"},{"id":"d","text":"are"}]'::jsonb, 'd', 'Books is plural (more than one), so it takes are: The books are on the desk. Use is only for a single thing (the book is on the desk).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f18ee8b3-db44-5a39-a067-bc3b0092a92f', '8d69552a-faf3-5f8e-b73e-66ad45e9ca03', 'Complete: "Tom and I ___ good friends."', '[{"id":"a","text":"is"},{"id":"b","text":"am"},{"id":"c","text":"are"},{"id":"d","text":"be"}]'::jsonb, 'c', '"Tom and I" means two people = we, so the verb is are: Tom and I are good friends. A subject joined by and is plural, even when one part is I.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9bf2a39b-3058-52d3-9115-76ede71cbbf0', 'a9babe02-35db-5739-b219-57a666359ba6', 'anglais-a1', '⭐⭐ Review: Negatives, Questions & There Is/Are', 2, 75, 15, 'practice', 'admin', 2)
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
  ('183d6d10-68ea-5d0f-91b5-712dffe56a66', '9bf2a39b-3058-52d3-9115-76ede71cbbf0', 'Choose the correct negative of "They are at home."', '[{"id":"a","text":"They aren''t at home."},{"id":"b","text":"They not are at home."},{"id":"c","text":"They isn''t at home."},{"id":"d","text":"They don''t at home."}]'::jsonb, 'a', 'The negative of are not contracts to aren''t: They aren''t at home. "not are" has the wrong order, isn''t is singular (he/she/it), and don''t belongs to ordinary verbs, not to be.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4bbc0a49-7a63-5750-9758-b3f9654b9d3e', '9bf2a39b-3058-52d3-9115-76ede71cbbf0', 'Make a yes/no question from "She is a teacher."', '[{"id":"a","text":"She is a teacher?"},{"id":"b","text":"Is she a teacher?"},{"id":"c","text":"Does she be a teacher?"},{"id":"d","text":"Is a teacher she?"}]'::jsonb, 'b', 'Invert subject and verb: She is → Is she a teacher? With to be you never add do/does (so "Does she be" is wrong), and the subject she must follow the verb directly.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a38e60b5-b18e-57f6-a221-335ec947b83f', '9bf2a39b-3058-52d3-9115-76ede71cbbf0', 'You ARE tired. Choose the correct short answer to "Are you tired?"', '[{"id":"a","text":"Yes, I''m."},{"id":"b","text":"Yes, you are."},{"id":"c","text":"Yes, I am."},{"id":"d","text":"Yes, am I."}]'::jsonb, 'c', 'A positive short answer is not contracted, so "Yes, I''m" is wrong — say Yes, I am. The person answering is I (not you), and the order is subject + verb, not "am I".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('971bad98-c42d-5b0b-b6ab-80f31bfbba98', '9bf2a39b-3058-52d3-9115-76ede71cbbf0', 'Complete: "___ three apples in the basket."', '[{"id":"a","text":"There is"},{"id":"b","text":"It is"},{"id":"c","text":"There be"},{"id":"d","text":"There are"}]'::jsonb, 'd', 'Three apples is plural, so use there are: There are three apples in the basket. There is is for one thing, "there be" is not a finite form, and it is cannot introduce a plural like this.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6193ef82-4d27-5444-934d-e9bcb5161d7f', '9bf2a39b-3058-52d3-9115-76ede71cbbf0', 'Complete: "The cat is licking ___ paws."', '[{"id":"a","text":"it''s"},{"id":"b","text":"its"},{"id":"c","text":"its''"},{"id":"d","text":"it is"}]'::jsonb, 'b', 'The paws belong to the cat, so use the possessive its (no apostrophe): its paws. The trap it''s always means it is; "its''" does not exist; and "it is paws" is ungrammatical.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('45e5de92-d3e1-5dfe-b2be-e33cbc5f0a13', '9bf2a39b-3058-52d3-9115-76ede71cbbf0', 'Complete the pair: "___ your parents teachers?" — "No, they ___."', '[{"id":"a","text":"Is / isn''t"},{"id":"b","text":"Do / don''t"},{"id":"c","text":"Are / aren''t"},{"id":"d","text":"Are / isn''t"}]'::jsonb, 'c', 'Parents is plural, so the question is Are…? and the short answer is they aren''t: "Are your parents teachers? — No, they aren''t." Is/isn''t is singular, and do/don''t is for ordinary verbs, not to be.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9860732e-e955-5d66-ba01-4c84d2062b46', 'a9babe02-35db-5739-b219-57a666359ba6', 'anglais-a1', '⚔️ Chapter Boss ⭐⭐⭐: The Verb To Be', 3, 120, 30, 'boss', 'admin', 3)
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
  ('81c57232-c062-5a1b-91b1-3550f4de9636', '9860732e-e955-5d66-ba01-4c84d2062b46', 'Complete: "___ a lot of water in the bottle."', '[{"id":"a","text":"There are"},{"id":"b","text":"Their is"},{"id":"c","text":"There is"},{"id":"d","text":"There be"}]'::jsonb, 'c', 'Water is uncountable (it has no plural), so use there is: There is a lot of water. There are needs a plural countable noun, "Their is" confuses the possessive their with there, and "there be" is not a finite form.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e40b11fc-6367-5518-b659-8eab9888fd28', '9860732e-e955-5d66-ba01-4c84d2062b46', 'Complete: "___ there any chairs in the room?"', '[{"id":"a","text":"Are"},{"id":"b","text":"Is"},{"id":"c","text":"Do"},{"id":"d","text":"Be"}]'::jsonb, 'a', 'Chairs is plural, so the existence question is Are there…?: Are there any chairs in the room? Is there is for one thing (Is there a chair?), and we never use do with to be.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c22bb0b-4afc-5462-9e79-33f639986ef5', '9860732e-e955-5d66-ba01-4c84d2062b46', 'Find the INCORRECT sentence.', '[{"id":"a","text":"She isn''t from Spain."},{"id":"b","text":"We are not late."},{"id":"c","text":"They aren''t ready."},{"id":"d","text":"I amn''t hungry."}]'::jsonb, 'd', 'The error is (d): there is no contraction "amn''t" in standard English — with I the negative is I''m not (I''m not hungry). The common trap is to copy isn''t/aren''t onto I. Sentences (a), (b) and (c) are all correct.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b9c82bb-f6b7-56b2-831e-baf2d28248f0', '9860732e-e955-5d66-ba01-4c84d2062b46', 'Put the words in the correct order: (old / how / you / are)', '[{"id":"a","text":"How old are you?"},{"id":"b","text":"How are you old?"},{"id":"c","text":"Are you how old?"},{"id":"d","text":"How old you are?"}]'::jsonb, 'a', 'Question words go first, then the verb, then the subject: How old + are + you? = How old are you? "How old you are?" keeps statement order (no inversion), and the others split the question phrase "how old".', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c657698d-3480-5384-a3a3-4b3616e9245f', '9860732e-e955-5d66-ba01-4c84d2062b46', 'Your sister is NOT a doctor. Choose the best short answer to "Is your sister a doctor?"', '[{"id":"a","text":"No, she not."},{"id":"b","text":"No, she isn''t."},{"id":"c","text":"No, she doesn''t."},{"id":"d","text":"No, isn''t she."}]'::jsonb, 'b', 'A short negative answer reuses to be: No, she isn''t. "she not" has no verb, doesn''t is for ordinary verbs (not to be), and "isn''t she" is tag/question order, not an answer.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3a6d832-f4d9-5c07-bd00-d8f70b7fea65', '9860732e-e955-5d66-ba01-4c84d2062b46', 'Complete: "The price of these books ___ very high."', '[{"id":"a","text":"are"},{"id":"b","text":"is"},{"id":"c","text":"am"},{"id":"d","text":"be"}]'::jsonb, 'b', 'The subject is the price (singular), not books, so the verb is is: The price of these books is very high. The plural noun books sits next to the verb as a trap — find the real subject before choosing.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('272651b1-0cc8-5e5d-b7fc-d5bccd9df48f', 'a9babe02-35db-5739-b219-57a666359ba6', 'anglais-a1', '👑 Elite Challenge ⭐⭐⭐⭐: The Verb To Be', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('1d2f2bbc-5db4-5fa5-9caf-7d7a05dbc279', '272651b1-0cc8-5e5d-b7fc-d5bccd9df48f', 'Read: "Lina and Omar are in the same class. Lina is from Sfax. Omar is from Tunis." Which sentence is TRUE?', '[{"id":"a","text":"Lina and Omar are classmates."},{"id":"b","text":"Lina is from Tunis."},{"id":"c","text":"Omar isn''t a student."},{"id":"d","text":"They are in different classes."}]'::jsonb, 'a', '"In the same class" means they are classmates (are, because Lina and Omar = they). (b) swaps the cities — Lina is from Sfax. (c) contradicts the text — being in a class, Omar is a student. (d) contradicts "the same class".', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('53f7b82f-d642-5368-be66-fb3301ee98d8', '272651b1-0cc8-5e5d-b7fc-d5bccd9df48f', 'Find the INCORRECT sentence.', '[{"id":"a","text":"There is a museum near the school."},{"id":"b","text":"There are two museums near the school."},{"id":"c","text":"Is there a museum near the school?"},{"id":"d","text":"There are a museum near the school."}]'::jsonb, 'd', 'The error is (d): with a singular noun (a museum) you must use there is, not there are. The word a signals one thing. (a), (b) and (c) all match the verb to the number correctly.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ce1ede7-822f-50c4-82e1-d30ccf14e309', '272651b1-0cc8-5e5d-b7fc-d5bccd9df48f', '"Where are your keys?" Choose the most natural reply.', '[{"id":"a","text":"They''re on the table."},{"id":"b","text":"Their on the table."},{"id":"c","text":"There on the table."},{"id":"d","text":"It''s on the table."}]'::jsonb, 'a', 'Keys is plural = they, so the reply is They''re (they are) on the table. "Their" is possessive and "There" shows place — neither can mean they are. "It''s" is singular and cannot stand for plural keys.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1228173-f4be-5046-ab08-7d2b5230d327', '272651b1-0cc8-5e5d-b7fc-d5bccd9df48f', 'Complete: "Everyone in the two teams ___ ready to play."', '[{"id":"a","text":"are"},{"id":"b","text":"is"},{"id":"c","text":"am"},{"id":"d","text":"be"}]'::jsonb, 'b', 'Everyone is grammatically singular and takes is, even though it refers to many people and "teams" is plural: Everyone ... is ready. The nearby plural teams is a deliberate trap.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4760283b-4992-5e58-b8b6-3b1f2a2da70c', '272651b1-0cc8-5e5d-b7fc-d5bccd9df48f', 'Choose the fully correct sentence.', '[{"id":"a","text":"I amn''t your teacher."},{"id":"b","text":"I aren''t your teacher."},{"id":"c","text":"I''m not your teacher."},{"id":"d","text":"I not am your teacher."}]'::jsonb, 'c', 'With I, the only negative form is I''m not (I''m not your teacher): there is no "amn''t", and aren''t is for you/we/they. "I not am" has the wrong word order — not goes after the verb.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de526bf6-3d4f-513c-8198-4ab62e02d815', '272651b1-0cc8-5e5d-b7fc-d5bccd9df48f', 'Which question-and-answer pair is completely correct?', '[{"id":"a","text":"\"Are you a doctor?\" — \"Yes, I''m.\""},{"id":"b","text":"\"Is he French?\" — \"No, he isn''t.\""},{"id":"c","text":"\"Are they here?\" — \"Yes, they is.\""},{"id":"d","text":"\"Am I late?\" — \"No, you not.\""}]'::jsonb, 'b', 'Only (b) is correct: Is he…? — No, he isn''t. (a) wrongly contracts a positive short answer (it must be "Yes, I am"). (c) uses singular is with they (should be "they are"). (d) has no verb (should be "No, you aren''t / you''re not").', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b8b5d5de-6541-5a88-8374-156a189c693f', 'e702c00c-86b8-5423-b0e2-5cb024ce78a3', 'anglais-a1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('b073a67a-c149-5e09-821b-108f3aa2a219', 'b8b5d5de-6541-5a88-8374-156a189c693f', 'Complete: "She ___ in a bank."', '[{"id":"a","text":"works"},{"id":"b","text":"work"},{"id":"c","text":"working"},{"id":"d","text":"is work"}]'::jsonb, 'a', 'In the present simple, he/she/it adds -s to the base verb: She works in a bank. "work" is the base form used with I/you/we/they, "working" is the -ing form (used after be), and "is work" mixes two verbs.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6657ae1-7f38-5151-a397-6a2d61981120', 'b8b5d5de-6541-5a88-8374-156a189c693f', 'Complete: "They ___ in Tunis."', '[{"id":"a","text":"lives"},{"id":"b","text":"is living"},{"id":"c","text":"live"},{"id":"d","text":"living"}]'::jsonb, 'c', 'With they (a plural subject), use the base verb with no -s: They live in Tunis. The -s ending ("lives") is only for he/she/it, and "living"/"is living" are not the simple present form.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b6cd876-701b-53d6-85bc-ccb102f77e79', 'b8b5d5de-6541-5a88-8374-156a189c693f', 'What is the correct third-person form of the verb "study"?', '[{"id":"a","text":"studys"},{"id":"b","text":"studies"},{"id":"c","text":"studyes"},{"id":"d","text":"studis"}]'::jsonb, 'b', 'When a verb ends in a consonant + y, change the y to i and add -es: study → studies. So "He studies hard." "studys" keeps the y wrongly, and the other spellings are not real words.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f5fb57d-9957-51b5-b5f5-f93f4b942ce4', 'b8b5d5de-6541-5a88-8374-156a189c693f', 'Choose the correct negative: "He ___ meat."', '[{"id":"a","text":"don''t eat"},{"id":"b","text":"doesn''t eats"},{"id":"c","text":"not eat"},{"id":"d","text":"doesn''t eat"}]'::jsonb, 'd', 'For he/she/it the negative is doesn''t + base verb: He doesn''t eat meat. "don''t" is for I/you/we/they, "doesn''t eats" double-marks the -s (it already sits on does), and "not eat" has no auxiliary.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db55597d-8b58-5e89-97e2-c9ef3c285510', 'b8b5d5de-6541-5a88-8374-156a189c693f', 'Which question is correct?', '[{"id":"a","text":"Do she play tennis?"},{"id":"b","text":"Does she plays tennis?"},{"id":"c","text":"Does she play tennis?"},{"id":"d","text":"She does play tennis?"}]'::jsonb, 'c', 'A yes/no question with she uses Does + subject + base verb: Does she play tennis? "Do she" uses the wrong auxiliary, "Does she plays" double-marks the -s, and "She does play?" keeps statement word order.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a7a8d1ac-34a4-537f-ab0d-e2ba1d2a83d7', 'e702c00c-86b8-5423-b0e2-5cb024ce78a3', 'anglais-a1', '⭐ Practice: Present Simple', 1, 50, 10, 'practice', 'admin', 1)
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
  ('1e9a1e47-bc0e-50cc-879c-0962b068aff8', 'a7a8d1ac-34a4-537f-ab0d-e2ba1d2a83d7', 'Complete: "I ___ football every weekend."', '[{"id":"a","text":"plays"},{"id":"b","text":"play"},{"id":"c","text":"playing"},{"id":"d","text":"to play"}]'::jsonb, 'b', 'With the subject I, the present simple uses the base verb with no -s: I play football. The -s ending ("plays") is only for he/she/it; "playing" and "to play" are not present-simple forms.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2681050e-555f-5ef8-9f46-48f542a82c6e', 'a7a8d1ac-34a4-537f-ab0d-e2ba1d2a83d7', 'Complete: "My brother ___ to school by bus."', '[{"id":"a","text":"go"},{"id":"b","text":"going"},{"id":"c","text":"goes"},{"id":"d","text":"gos"}]'::jsonb, 'c', '"My brother" = he, so add the third-person ending. The verb go ends in -o, so we add -es: He goes to school. "go" forgets the -s, "gos" is misspelled, and "going" is the -ing form.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e64003f2-c755-5d7b-8434-7c2789558335', 'a7a8d1ac-34a4-537f-ab0d-e2ba1d2a83d7', 'Complete: "We ___ English at school."', '[{"id":"a","text":"study"},{"id":"b","text":"studies"},{"id":"c","text":"studys"},{"id":"d","text":"stud/ying"}]'::jsonb, 'a', 'With we (plural), use the base verb: We study English. The -ies spelling ("studies") belongs only to he/she/it, "studys" is never correct, and the last option is not a word.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d6a7f8be-3a99-514f-b885-0d536b10b712', 'a7a8d1ac-34a4-537f-ab0d-e2ba1d2a83d7', 'Complete: "She ___ TV in the evening."', '[{"id":"a","text":"watch"},{"id":"b","text":"watchs"},{"id":"c","text":"watching"},{"id":"d","text":"watches"}]'::jsonb, 'd', 'She takes the third-person ending, and verbs ending in -ch add -es: She watches TV. "watch" forgets the ending, "watchs" is the wrong spelling (it must be -es after -ch), and "watching" is the -ing form.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d50a018-0eae-5b73-8dc8-28e12051e061', 'a7a8d1ac-34a4-537f-ab0d-e2ba1d2a83d7', 'Complete: "They ___ in a small flat."', '[{"id":"a","text":"lives"},{"id":"b","text":"live"},{"id":"c","text":"living"},{"id":"d","text":"lifes"}]'::jsonb, 'b', 'They is plural, so use the base verb with no -s: They live in a small flat. "lives" is the he/she/it form, "living" is the -ing form, and "lifes" confuses the noun with the verb.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7825e12-8e8f-5088-a207-8fdd37ceba25', 'a7a8d1ac-34a4-537f-ab0d-e2ba1d2a83d7', 'Complete: "The baby ___ a lot at night."', '[{"id":"a","text":"cry"},{"id":"b","text":"crys"},{"id":"c","text":"cries"},{"id":"d","text":"crying"}]'::jsonb, 'c', '"The baby" = it, and cry ends in consonant + y, so y → i + es: The baby cries. "cry" forgets the ending, "crys" keeps the y wrongly, and "crying" is the -ing form.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3ad8a3f9-5ac3-54eb-97d7-42da8484cd84', 'e702c00c-86b8-5423-b0e2-5cb024ce78a3', 'anglais-a1', '⭐⭐ Review: Present Simple', 2, 75, 15, 'practice', 'admin', 2)
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
  ('72259d00-0a1f-586d-826d-029652dfa778', '3ad8a3f9-5ac3-54eb-97d7-42da8484cd84', 'Complete the negative: "I ___ coffee in the morning."', '[{"id":"a","text":"doesn''t like"},{"id":"b","text":"not like"},{"id":"c","text":"don''t like"},{"id":"d","text":"don''t likes"}]'::jsonb, 'c', 'With I, the negative is don''t + base verb: I don''t like coffee. "doesn''t" is only for he/she/it, "not like" has no auxiliary, and "don''t likes" wrongly adds -s after don''t.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('25d372a1-964f-5dca-9548-2d7264b95e8b', '3ad8a3f9-5ac3-54eb-97d7-42da8484cd84', 'Complete the negative: "He ___ on Sundays."', '[{"id":"a","text":"don''t work"},{"id":"b","text":"doesn''t work"},{"id":"c","text":"doesn''t works"},{"id":"d","text":"not works"}]'::jsonb, 'b', 'For he, the negative is doesn''t + base verb: He doesn''t work on Sundays. The -s already lives on does, so the main verb has no -s — "doesn''t works" is the classic double-marking error; "don''t" is for I/you/we/they.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2c6b06e-d311-5288-b86d-67fe1f7b68e2', '3ad8a3f9-5ac3-54eb-97d7-42da8484cd84', 'Make a question: "___ you live near the beach?"', '[{"id":"a","text":"Does"},{"id":"b","text":"Are"},{"id":"c","text":"Is"},{"id":"d","text":"Do"}]'::jsonb, 'd', 'A present-simple question with you uses Do: Do you live near the beach? "Does" is for he/she/it, and "Are/Is" belong to the verb be, not to ordinary verbs like live.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('830dd8e0-79e5-5d6a-93ca-863f35839c9a', '3ad8a3f9-5ac3-54eb-97d7-42da8484cd84', 'Choose the correct question: "___ your sister speak English?"', '[{"id":"a","text":"Does"},{"id":"b","text":"Do"},{"id":"c","text":"Is"},{"id":"d","text":"Doing"}]'::jsonb, 'a', '"Your sister" = she, so the question starts with Does: Does your sister speak English? "Do" is for plural/you subjects, "Is" belongs to the verb be, and "Doing" is not an auxiliary.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc8b022d-0c40-5bbf-8653-fd0123180ce3', '3ad8a3f9-5ac3-54eb-97d7-42da8484cd84', 'Complete: "My dad ___ the dishes after dinner."', '[{"id":"a","text":"wash"},{"id":"b","text":"washs"},{"id":"c","text":"washes"},{"id":"d","text":"washing"}]'::jsonb, 'c', '"My dad" = he, and wash ends in -sh, so add -es: My dad washes the dishes. "wash" forgets the ending, "washs" uses -s where -es is required after -sh, and "washing" is the -ing form.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3963605-3d2f-553d-ae17-ad3e041bd344', '3ad8a3f9-5ac3-54eb-97d7-42da8484cd84', 'Complete the short answer: "Does she like music?" — "Yes, she ___."', '[{"id":"a","text":"likes"},{"id":"b","text":"is"},{"id":"c","text":"do"},{"id":"d","text":"does"}]'::jsonb, 'd', 'A short answer reuses the auxiliary, not the main verb: Yes, she does. "likes" repeats the verb (wrong for a short answer), "is" belongs to the verb be, and "do" is for I/you/we/they, not she.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('20c1e986-8207-5a28-a3df-b172c4d25e26', 'e702c00c-86b8-5423-b0e2-5cb024ce78a3', 'anglais-a1', '⚔️ Chapter Boss ⭐⭐⭐: Present Simple', 3, 120, 30, 'boss', 'admin', 3)
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
  ('569412b6-61f2-517d-87de-5a65c694ce6a', '20c1e986-8207-5a28-a3df-b172c4d25e26', 'Complete: "___ he finish work at five?"', '[{"id":"a","text":"Do"},{"id":"b","text":"Is"},{"id":"c","text":"Does"},{"id":"d","text":"Doing"}]'::jsonb, 'c', 'A question with he uses Does + base verb: Does he finish work at five? "Do he" uses the wrong auxiliary, "Is" belongs to the verb be (not to finish), and "Doing" is not an auxiliary.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('509d5be7-ba32-5dac-bf4d-46e323c2be19', '20c1e986-8207-5a28-a3df-b172c4d25e26', 'Choose the correct word order: "___ early on school days."', '[{"id":"a","text":"She gets up always"},{"id":"b","text":"She up gets always"},{"id":"c","text":"Always she gets up"},{"id":"d","text":"She always gets up"}]'::jsonb, 'd', 'Adverbs of frequency go before the main verb: She always gets up early. "gets up always" puts the adverb after the verb, and the other orders break the phrasal verb "get up" or front the adverb unnaturally.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a7352e0-1bbd-56ef-b0c0-99b3266c3aad', '20c1e986-8207-5a28-a3df-b172c4d25e26', 'Find the INCORRECT sentence.', '[{"id":"a","text":"She doesn''t goes to the gym."},{"id":"b","text":"He doesn''t play the guitar."},{"id":"c","text":"They don''t watch TV."},{"id":"d","text":"I don''t eat breakfast."}]'::jsonb, 'a', 'The error is (a): after doesn''t the main verb must be the base form, so it should be "She doesn''t go to the gym." The -s already sits on does — double-marking it ("doesn''t goes") is wrong. (b), (c) and (d) all keep the base verb correctly.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee3ba4a1-6b77-5ddb-bda0-20d9c6aa51dd', '20c1e986-8207-5a28-a3df-b172c4d25e26', 'Complete the wh- question: "Where ___ your parents work?"', '[{"id":"a","text":"does"},{"id":"b","text":"do"},{"id":"c","text":"are"},{"id":"d","text":"is"}]'::jsonb, 'b', '"Your parents" is plural (= they), so the auxiliary is do: Where do your parents work? "does" is singular (he/she/it), and "are/is" belong to the verb be, not to work.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4294f02e-aa68-54e1-90d0-badab2f7b83f', '20c1e986-8207-5a28-a3df-b172c4d25e26', 'Choose the fully correct sentence.', '[{"id":"a","text":"My sister study every evening."},{"id":"b","text":"My sister studys every evening."},{"id":"c","text":"My sister studies every evening."},{"id":"d","text":"My sister is study every evening."}]'::jsonb, 'c', '"My sister" = she, and study (consonant + y) becomes studies: My sister studies every evening. "study" forgets the -s ending, "studys" is the wrong spelling, and "is study" wrongly mixes two verbs.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae18a2ad-9ecc-52b1-a549-f6a9a256a8a3', '20c1e986-8207-5a28-a3df-b172c4d25e26', 'Complete: "My friends never ___ late to class."', '[{"id":"a","text":"comes"},{"id":"b","text":"come"},{"id":"c","text":"to come"},{"id":"d","text":"coming"}]'::jsonb, 'b', '"My friends" is plural (= they), so use the base verb even with a frequency adverb: My friends never come late. The adverb never doesn''t change the verb form, so "comes" (third-person -s) is wrong here; "to come" and "coming" are not present-simple forms.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d565f83b-fd9b-521c-b491-fed48fac2430', 'e702c00c-86b8-5423-b0e2-5cb024ce78a3', 'anglais-a1', '👑 Elite Challenge ⭐⭐⭐⭐: Present Simple', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('b1a7b127-d682-55ee-939c-3eb638829182', 'd565f83b-fd9b-521c-b491-fed48fac2430', 'Read: "Nadia is a nurse. She works at night and sleeps during the day. She never drinks coffee." Which sentence is TRUE?', '[{"id":"a","text":"Nadia works at night."},{"id":"b","text":"Nadia sleeps at night."},{"id":"c","text":"Nadia drinks coffee every morning."},{"id":"d","text":"Nadia works during the day."}]'::jsonb, 'a', 'The text says "She works at night", so (a) is true (note the third-person -s: works, sleeps, drinks). (b) and (d) reverse her schedule — she sleeps during the day and works at night — and (c) contradicts "She never drinks coffee."', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13a2287c-1145-5a90-ab36-085db0683dd2', 'd565f83b-fd9b-521c-b491-fed48fac2430', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Does she get up early?"},{"id":"b","text":"He doesn''t watch TV."},{"id":"c","text":"They study every day."},{"id":"d","text":"Does your brother plays tennis?"}]'::jsonb, 'd', 'The error is (d): after the auxiliary does, the main verb stays in its base form, so it must be "Does your brother play tennis?" The -s belongs on does, not on the main verb. (a), (b) and (c) are all correct.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('869d6fe5-c672-5c19-964d-9aa52b1953e2', 'd565f83b-fd9b-521c-b491-fed48fac2430', 'Complete: "He is ___ tired after his night shift."', '[{"id":"a","text":"tired usually"},{"id":"b","text":"usually being"},{"id":"c","text":"usually"},{"id":"d","text":"use to"}]'::jsonb, 'c', 'With the verb be, the frequency adverb goes AFTER the verb: He is usually tired. This is the one exception — with ordinary verbs the adverb goes before (He usually finishes late), but after be it follows it. "being" and "use to" are not present-simple forms here.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('71bb0366-ec6a-5297-a644-ed40a2e728d6', 'd565f83b-fd9b-521c-b491-fed48fac2430', 'Choose the fully correct sentence.', '[{"id":"a","text":"My mother go to the market on Fridays."},{"id":"b","text":"My mother goes to the market on Fridays."},{"id":"c","text":"My mother goes always to the market on Fridays."},{"id":"d","text":"My mother does goes to the market on Fridays."}]'::jsonb, 'b', '"My mother" = she, and go takes -es: My mother goes to the market. (a) forgets the -s, (c) misplaces "always" (it must come before the verb: always goes), and (d) wrongly adds does to an affirmative sentence and keeps the -s.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7dced33e-471a-523e-ac27-31945a9a5c08', 'd565f83b-fd9b-521c-b491-fed48fac2430', 'Complete: "Either Sami or his brothers ___ the shop in the morning."', '[{"id":"a","text":"opens"},{"id":"b","text":"is opening"},{"id":"c","text":"to open"},{"id":"d","text":"open"}]'::jsonb, 'd', 'With "either … or …", the verb agrees with the nearest subject — here "his brothers" (plural), so use the base verb: open. "opens" would agree with a singular subject (the trap is the nearby "Sami"), and "is opening"/"to open" are not present-simple forms.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24febc89-64b4-5bcc-b7e8-f65287d9fb1c', 'd565f83b-fd9b-521c-b491-fed48fac2430', 'Which question-and-answer pair is completely correct?', '[{"id":"a","text":"\"Does he live here?\" — \"Yes, he do.\""},{"id":"b","text":"\"Do they work here?\" — \"Yes, they does.\""},{"id":"c","text":"\"Does she study French?\" — \"No, she doesn''t.\""},{"id":"d","text":"\"Do you like tea?\" — \"Yes, I likes.\""}]'::jsonb, 'c', 'Only (c) is correct: a question with Does is answered with does/doesn''t — No, she doesn''t. (a) mismatches the auxiliary (he → does, so "Yes, he does"), (b) uses does with they (should be "they do"), and (d) repeats the main verb instead of the auxiliary (should be "Yes, I do").', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8de56c53-db69-5599-bbce-249faaf336d7', '23ae9a2a-83b4-5566-9f6a-6a72af1cc3a5', 'anglais-a1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('7029f9f4-f8ab-5398-8fdc-ec7323bb21c8', '8de56c53-db69-5599-bbce-249faaf336d7', 'Choose the correct article: "I ate ___ apple for breakfast."', '[{"id":"a","text":"a"},{"id":"b","text":"an"},{"id":"c","text":"the"},{"id":"d","text":"(no article)"}]'::jsonb, 'b', 'Apple begins with a vowel sound /æ/, so it takes an: an apple. We use a before a consonant sound, and the would mean a specific apple already known, which a first mention is not.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4e78a5a-b3f4-5ac9-b7e8-8da350fe7a01', '8de56c53-db69-5599-bbce-249faaf336d7', 'What is the correct plural of "city"?', '[{"id":"a","text":"citys"},{"id":"b","text":"cityes"},{"id":"c","text":"cities"},{"id":"d","text":"cityies"}]'::jsonb, 'c', 'When a noun ends in a consonant + y, the y changes to -ies: city → cities. "citys" forgets the spelling change, and the other forms double up the ending wrongly.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae59c583-504e-528f-b6d5-ec86394e92a3', '8de56c53-db69-5599-bbce-249faaf336d7', 'Choose the correct article: "She is ___ university student."', '[{"id":"a","text":"an"},{"id":"b","text":"the"},{"id":"c","text":"a"},{"id":"d","text":"(no article)"}]'::jsonb, 'c', 'Use a or an by SOUND, not letter: university starts with a /j/ "yoo" sound, which is a consonant sound, so it takes a (a university). The vowel letter u tricks many learners into writing "an university".', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e97df05-9bc2-59fe-ad56-ff9c7db381e6', '8de56c53-db69-5599-bbce-249faaf336d7', 'What is the correct plural of "child"?', '[{"id":"a","text":"childs"},{"id":"b","text":"childes"},{"id":"c","text":"childer"},{"id":"d","text":"children"}]'::jsonb, 'd', 'Child has an irregular plural: child → children. It does not follow the -s rule, so "childs" is wrong, and the other forms are invented endings.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e57404a-4af2-5f92-953b-9274c8117a78', '8de56c53-db69-5599-bbce-249faaf336d7', 'Choose the correct sentence about cats in general.', '[{"id":"a","text":"A cats are independent."},{"id":"b","text":"Cats are independent."},{"id":"c","text":"The cats are independent."},{"id":"d","text":"An cats are independent."}]'::jsonb, 'b', 'For a general truth about a whole group, use a plural with no article (zero article): Cats are independent. You cannot put a/an before a plural, and the would point to specific, known cats, not cats in general.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9ffcc5e4-c155-5f06-b6f1-69b01f100447', '23ae9a2a-83b4-5566-9f6a-6a72af1cc3a5', 'anglais-a1', '⭐ Practice: Articles & Plurals', 1, 50, 10, 'practice', 'admin', 1)
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
  ('b10d151a-6ef2-51b2-85ef-87864cee61fb', '9ffcc5e4-c155-5f06-b6f1-69b01f100447', 'Choose the correct article: "I need ___ pen to write."', '[{"id":"a","text":"an"},{"id":"b","text":"a"},{"id":"c","text":"the"},{"id":"d","text":"(no article)"}]'::jsonb, 'b', 'Pen starts with a consonant sound /p/, so it takes a: a pen. We use an only before a vowel sound, and there is no specific pen in mind, so the does not fit.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('06c41759-d6e1-5882-a15e-1c7d1e16339f', '9ffcc5e4-c155-5f06-b6f1-69b01f100447', 'Choose the correct article: "There is ___ orange on the table."', '[{"id":"a","text":"a"},{"id":"b","text":"the"},{"id":"c","text":"an"},{"id":"d","text":"(no article)"}]'::jsonb, 'c', 'Orange begins with a vowel sound /ɒ/, so it takes an: an orange. The form "a orange" is a very common error — remember an goes before vowel sounds.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('384c9aba-2abb-5362-a6e5-aaad42dc9e94', '9ffcc5e4-c155-5f06-b6f1-69b01f100447', 'What is the correct plural of "book"?', '[{"id":"a","text":"bookes"},{"id":"b","text":"book"},{"id":"c","text":"bookies"},{"id":"d","text":"books"}]'::jsonb, 'd', 'Most nouns form the plural by simply adding -s: book → books. We add -es only after s, x, z, ch or sh, and the -ies rule is for nouns ending in consonant + y.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('266a58db-315c-5cbe-a7e6-afddee112bfa', '9ffcc5e4-c155-5f06-b6f1-69b01f100447', 'What is the correct plural of "box"?', '[{"id":"a","text":"boxs"},{"id":"b","text":"boxes"},{"id":"c","text":"boxies"},{"id":"d","text":"boxen"}]'::jsonb, 'b', 'Nouns ending in -x take -es in the plural: box → boxes (it makes the word easier to pronounce). "boxs" forgets the -es, and the other forms use endings that do not exist here.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18123a68-0da4-5ba6-9906-63dd1fb27d98', '9ffcc5e4-c155-5f06-b6f1-69b01f100447', 'Complete with the correct article: "___ Earth goes around the sun."', '[{"id":"a","text":"The"},{"id":"b","text":"A"},{"id":"c","text":"An"},{"id":"d","text":"(no article)"}]'::jsonb, 'a', 'There is only one Earth, so we use the for this unique thing: The Earth goes around the sun. We use a/an for one of many, but here there is just one Earth.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e3bfe44-d8ff-5888-a469-69c98929df50', '9ffcc5e4-c155-5f06-b6f1-69b01f100447', 'What is the correct plural of "baby"?', '[{"id":"a","text":"babys"},{"id":"b","text":"babyes"},{"id":"c","text":"babies"},{"id":"d","text":"babi"}]'::jsonb, 'c', 'Baby ends in a consonant + y, so the y changes to -ies: baby → babies. "babys" ignores the spelling change that applies after a consonant.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0a4d76db-5c96-5d2c-917e-a4dabdb32b86', '23ae9a2a-83b4-5566-9f6a-6a72af1cc3a5', 'anglais-a1', '⭐⭐ Review: Articles & Plurals', 2, 75, 15, 'practice', 'admin', 2)
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
  ('6429ad3d-d835-5341-a9bf-fc4fd803c830', '0a4d76db-5c96-5d2c-917e-a4dabdb32b86', 'Choose the correct article: "We waited for ___ hour."', '[{"id":"a","text":"an"},{"id":"b","text":"a"},{"id":"c","text":"the"},{"id":"d","text":"(no article)"}]'::jsonb, 'a', 'Use an before a VOWEL SOUND, not just a vowel letter: an hour, because the h is silent and the word starts with the vowel sound /aʊ/. "a hour" is therefore wrong.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('531aa9c1-7391-544a-bf28-98eb0175b2f3', '0a4d76db-5c96-5d2c-917e-a4dabdb32b86', 'What is the correct plural of "watch"?', '[{"id":"a","text":"watchs"},{"id":"b","text":"watchies"},{"id":"c","text":"watches"},{"id":"d","text":"watch"}]'::jsonb, 'c', 'Nouns ending in -ch take -es: watch → watches. "watchs" forgets the -es needed after ch, and the -ies rule applies only to a consonant + y ending, not to ch.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('156408d1-a003-52df-8fa4-d3080831a4e1', '0a4d76db-5c96-5d2c-917e-a4dabdb32b86', 'Fill the gap: "___ is essential for all living things."', '[{"id":"a","text":"A water"},{"id":"b","text":"Water"},{"id":"c","text":"An water"},{"id":"d","text":"The waters"}]'::jsonb, 'b', 'Water is an uncountable noun used here in a general sense, so it takes no article and no plural: Water is essential. You cannot say "a water" or "an water", and "the waters" would mean specific bodies of water.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a33fb8fc-1b4c-59d9-b17e-8ef1442f3a72', '0a4d76db-5c96-5d2c-917e-a4dabdb32b86', 'What is the correct plural of "knife"?', '[{"id":"a","text":"knifes"},{"id":"b","text":"knifies"},{"id":"c","text":"knife"},{"id":"d","text":"knives"}]'::jsonb, 'd', 'Some nouns ending in -fe change f to v and add -s: knife → knives (like life → lives, wife → wives). "knifes" keeps the f, which is the typical mistake here.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b06c133-5ef6-5ba8-98da-ca5fbc314603', '0a4d76db-5c96-5d2c-917e-a4dabdb32b86', 'Find the INCORRECT plural.', '[{"id":"a","text":"buses"},{"id":"b","text":"mans"},{"id":"c","text":"leaves"},{"id":"d","text":"cities"}]'::jsonb, 'b', 'The wrong one is "mans": man has an irregular plural, man → men. The others are correct — bus → buses (-es after s), leaf → leaves (-f → -ves), and city → cities (consonant + y → -ies).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76035e9d-7fdf-5c95-a325-a4ba02f0c1ed', '0a4d76db-5c96-5d2c-917e-a4dabdb32b86', 'Choose the correct article: "He is ___ honest man, everyone trusts him."', '[{"id":"a","text":"a"},{"id":"b","text":"the"},{"id":"c","text":"an"},{"id":"d","text":"(no article)"}]'::jsonb, 'c', 'In honest the h is silent, so the word begins with the vowel sound /ɒ/ and takes an: an honest man. Compare "a house", where the h is pronounced — the sound, not the letter, decides.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('167fbb60-d79f-5b42-98f4-c4e0ce5c8853', '23ae9a2a-83b4-5566-9f6a-6a72af1cc3a5', 'anglais-a1', '⚔️ Chapter Boss ⭐⭐⭐: Articles & Plurals', 3, 120, 30, 'boss', 'admin', 3)
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
  ('148b4ebf-ffc0-59ca-8cb8-ac581aef50f5', '167fbb60-d79f-5b42-98f4-c4e0ce5c8853', 'Choose the correct article: "I found ___ one-euro coin on the floor."', '[{"id":"a","text":"a"},{"id":"b","text":"an"},{"id":"c","text":"the"},{"id":"d","text":"(no article)"}]'::jsonb, 'a', 'One starts with a /w/ "wuh" sound, which is a consonant sound, so it takes a: a one-euro coin. The letter o tempts learners toward "an", but the SOUND is what matters.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b550c982-b3f4-52f3-bcde-d7223cea8737', '167fbb60-d79f-5b42-98f4-c4e0ce5c8853', 'What is the correct plural of "tooth"?', '[{"id":"a","text":"tooths"},{"id":"b","text":"toothes"},{"id":"c","text":"teeth"},{"id":"d","text":"teeths"}]'::jsonb, 'c', 'Tooth is irregular: tooth → teeth (the oo becomes ee, like foot → feet). "tooths" applies the regular -s wrongly, and "teeths" adds -s to a form that is already plural.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('702739aa-c0aa-5053-b6e5-bc2ae666857c', '167fbb60-d79f-5b42-98f4-c4e0ce5c8853', 'Find the INCORRECT plural.', '[{"id":"a","text":"mice"},{"id":"b","text":"feet"},{"id":"c","text":"people"},{"id":"d","text":"mans"}]'::jsonb, 'd', 'The wrong one is mans: man is irregular and its plural is men, never mans. The others are correct irregulars — mouse → mice, foot → feet, and person → people.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae239e7d-9e7d-5432-97f3-512706447e68', '167fbb60-d79f-5b42-98f4-c4e0ce5c8853', 'Fill the gap with the right article: "I bought ___ car yesterday. ___ car is red."', '[{"id":"a","text":"the … A"},{"id":"b","text":"a … The"},{"id":"c","text":"a … A"},{"id":"d","text":"the … The"}]'::jsonb, 'b', 'First mention uses a (one of many): I bought a car. The second mention is now known to both speakers, so it switches to the: The car is red. Going "a → the" as a thing becomes specific is the core article pattern.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83de3154-d3a5-5ff2-93b9-c61706107b45', '167fbb60-d79f-5b42-98f4-c4e0ce5c8853', 'Choose the fully correct sentence.', '[{"id":"a","text":"There are three childs in the garden."},{"id":"b","text":"There are three children in the garden."},{"id":"c","text":"There are three child in the garden."},{"id":"d","text":"There are three childrens in the garden."}]'::jsonb, 'b', 'Child is irregular: its plural is children, with no extra -s. "childs" uses the regular rule wrongly, "child" stays singular after three, and "childrens" double-marks an already-plural word.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59704327-ec10-562a-b7e4-f2496f255934', '167fbb60-d79f-5b42-98f4-c4e0ce5c8853', 'Find the INCORRECT sentence.', '[{"id":"a","text":"Dogs are loyal animals."},{"id":"b","text":"The moon is bright tonight."},{"id":"c","text":"She gave me a good advice."},{"id":"d","text":"I like music."}]'::jsonb, 'c', 'The error is (c): advice is uncountable, so it takes no a/an — say she gave me good advice (or a piece of advice). The others are right: a general plural (Dogs…), a unique the (The moon), and an uncountable with zero article (music).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('77b95119-56fa-54ff-9be9-37ac4236bdbd', '23ae9a2a-83b4-5566-9f6a-6a72af1cc3a5', 'anglais-a1', '👑 Elite Challenge ⭐⭐⭐⭐: Articles & Plurals', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('d8d2f8fa-63b8-5f03-81ab-d5df5eebd601', '77b95119-56fa-54ff-9be9-37ac4236bdbd', 'Choose the correct pair of articles: "My uncle is ___ MP and also ___ university lecturer."', '[{"id":"a","text":"a … an"},{"id":"b","text":"a … a"},{"id":"c","text":"an … a"},{"id":"d","text":"an … an"}]'::jsonb, 'c', 'Sound decides each one. MP is said "em-pee", starting with the vowel sound /e/, so an MP. University starts with the /j/ "yoo" consonant sound, so a university. The vowel/consonant letters point the opposite way — a classic double trap.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92ce5ae2-162b-5743-8e24-62dd65826f63', '77b95119-56fa-54ff-9be9-37ac4236bdbd', 'Read: "Sara has two cats and a dog. The dog is small, but the cats are big." Which sentence is TRUE?', '[{"id":"a","text":"Sara has more cats than dogs."},{"id":"b","text":"Sara has two dogs."},{"id":"c","text":"The dog is bigger than the cats."},{"id":"d","text":"Sara has a cat and two dogs."}]'::jsonb, 'a', 'Two cats vs one dog means more cats than dogs, so (a) is true. The plural cats and singular a dog set the numbers; (b) and (d) miscount, and (c) reverses the text, which says the dog is small and the cats are big.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('372d4938-d90e-5b2f-80fe-748fd9e0165a', '77b95119-56fa-54ff-9be9-37ac4236bdbd', 'Find the INCORRECT plural.', '[{"id":"a","text":"sheep"},{"id":"b","text":"wives"},{"id":"c","text":"keys"},{"id":"d","text":"mouses"}]'::jsonb, 'd', 'The wrong one is "mouses": the (animal) plural of mouse is mice. The others are correct — sheep is unchanged in the plural, wife → wives (-fe → -ves), and key → keys (vowel + y just adds -s).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f10d0d2f-ae45-5e9e-b160-f6e82ad80834', '77b95119-56fa-54ff-9be9-37ac4236bdbd', 'Choose the fully correct sentence.', '[{"id":"a","text":"There are two woman and three childs here."},{"id":"b","text":"There are two women and three children here."},{"id":"c","text":"There are two womans and three childrens here."},{"id":"d","text":"There are two womens and three child here."}]'::jsonb, 'b', 'Both nouns are irregular: woman → women and child → children, each with no extra -s. (a) leaves woman singular and misuses "childs"; (c) and (d) add -s to forms that are already plural or keep child singular after a number.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('acf28a2a-194b-555b-a246-452e41534cfb', '77b95119-56fa-54ff-9be9-37ac4236bdbd', 'Fill the gaps: "___ lions live in Africa, but ___ lion at our zoo is from India."', '[{"id":"a","text":"The … the"},{"id":"b","text":"The … a"},{"id":"c","text":"(no article) … the"},{"id":"d","text":"A … the"}]'::jsonb, 'c', 'The first clause is a general truth about all lions, so it takes a plural with no article: Lions live in Africa. The second names one specific, known animal, so it takes the: the lion at our zoo. This contrasts the zero article (general) with the (specific).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a066d288-6333-5ac2-b898-3354552916f4', '77b95119-56fa-54ff-9be9-37ac4236bdbd', 'Find the INCORRECT sentence.', '[{"id":"a","text":"An honest person never lies."},{"id":"b","text":"He plays a guitar every day."},{"id":"c","text":"The sun rises in the east."},{"id":"d","text":"Buses are slower than trains."}]'::jsonb, 'b', 'The error is (b): with musical instruments English uses the, so it should be he plays the guitar. The others are right — an honest (silent h → vowel sound), the sun (unique thing), and a general plural with zero article (Buses…, plus bus → buses).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e1072fcc-506d-5230-ac88-bf45d655f06f', '4637b3e6-610c-5b41-b0f9-dba49d698d90', 'anglais-a1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('13eb3135-e044-570a-8b97-903812961b55', 'e1072fcc-506d-5230-ac88-bf45d655f06f', 'Which word means the sister of your mother or father?', '[{"id":"a","text":"aunt"},{"id":"b","text":"uncle"},{"id":"c","text":"niece"},{"id":"d","text":"cousin"}]'::jsonb, 'a', 'Your aunt is the sister of your mother or father (or your uncle''s wife). An uncle is the brother of a parent (male), a niece is your brother''s or sister''s daughter, and a cousin is the child of an aunt or uncle. Aunt and uncle are a gender pair, so don''t mix them up.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5ec6b27d-7832-508d-98fa-bce31daf979e', 'e1072fcc-506d-5230-ac88-bf45d655f06f', 'Find the odd one out.', '[{"id":"a","text":"red"},{"id":"b","text":"blue"},{"id":"c","text":"green"},{"id":"d","text":"table"}]'::jsonb, 'd', 'Red, blue and green are colours; table is a piece of furniture (an object), so it is the odd one out. Grouping words by their field — colours, objects, jobs — helps you learn and remember them.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ff8eba4b-ee4e-5e37-bd43-6452b430ff7e', 'e1072fcc-506d-5230-ac88-bf45d655f06f', 'Complete the common phrase: "a ___ of water".', '[{"id":"a","text":"slice"},{"id":"b","text":"glass"},{"id":"c","text":"loaf"},{"id":"d","text":"piece"}]'::jsonb, 'b', 'Water is a drink, so you measure it with a container: a glass of water. A slice or a loaf goes with bread, and "a piece of water" is not natural English. Pick the word that matches the food or drink.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('221ebe12-2177-55de-b4f0-6e9f6e59f08f', 'e1072fcc-506d-5230-ac88-bf45d655f06f', 'The opposite of "big" is …', '[{"id":"a","text":"tall"},{"id":"b","text":"long"},{"id":"c","text":"small"},{"id":"d","text":"old"}]'::jsonb, 'c', 'The opposite of big is small. Tall and long describe size in one direction (height or length) but are not the true opposite of big, and old is the opposite of new, not big.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('392f5a74-8da3-5859-a829-623c7a6268fa', 'e1072fcc-506d-5230-ac88-bf45d655f06f', 'Which word is a job (a person''s work)?', '[{"id":"a","text":"bread"},{"id":"b","text":"window"},{"id":"c","text":"Tuesday"},{"id":"d","text":"nurse"}]'::jsonb, 'd', 'A nurse is a job — a person who helps sick people, like a doctor. Bread is food, a window is an object at home, and Tuesday is a day of the week, so none of those is a job.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1f2dc15f-42d1-53be-8ce2-aa2a737933af', '4637b3e6-610c-5b41-b0f9-dba49d698d90', 'anglais-a1', '⭐ Practice: Everyday Words', 1, 50, 10, 'practice', 'admin', 1)
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
  ('a4587eca-d506-5b78-a225-9efae3fc266c', '1f2dc15f-42d1-53be-8ce2-aa2a737933af', 'Which word means a brother of your mother or father?', '[{"id":"a","text":"cousin"},{"id":"b","text":"uncle"},{"id":"c","text":"nephew"},{"id":"d","text":"grandfather"}]'::jsonb, 'b', 'Your uncle is the brother of your mother or father. A cousin is the child of an aunt or uncle, a nephew is your brother''s or sister''s son, and a grandfather is your parent''s father. Remember that aunt (female) and uncle (male) are a pair.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08efe4db-4555-53e3-ae13-880254acb5ca', '1f2dc15f-42d1-53be-8ce2-aa2a737933af', 'Find the odd one out.', '[{"id":"a","text":"Monday"},{"id":"b","text":"Friday"},{"id":"c","text":"apple"},{"id":"d","text":"Sunday"}]'::jsonb, 'c', 'Monday, Friday and Sunday are days of the week; apple is a food, so it is the odd one out. Days of the week are always written with a capital letter in English.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80dd2770-449a-5732-bec3-54c6aa65c3a4', '1f2dc15f-42d1-53be-8ce2-aa2a737933af', 'Complete the common phrase: "a ___ of tea".', '[{"id":"a","text":"cup"},{"id":"b","text":"slice"},{"id":"c","text":"key"},{"id":"d","text":"loaf"}]'::jsonb, 'a', 'We drink tea from a cup, so we say a cup of tea. A slice and a loaf go with bread, and a key is an object that opens a door — none of those fits a hot drink.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6bf5e7db-111d-56dd-bdea-6f6da6748864', '1f2dc15f-42d1-53be-8ce2-aa2a737933af', 'Which word is a colour?', '[{"id":"a","text":"chair"},{"id":"b","text":"doctor"},{"id":"c","text":"Tuesday"},{"id":"d","text":"purple"}]'::jsonb, 'd', 'Purple is a colour. A chair is an object you sit on, a doctor is a job, and Tuesday is a day of the week, so none of those is a colour.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d723e15-398c-5dea-a066-1bca6b216f24', '1f2dc15f-42d1-53be-8ce2-aa2a737933af', 'Find the intruder (the word that is NOT a job).', '[{"id":"a","text":"teacher"},{"id":"b","text":"farmer"},{"id":"c","text":"bread"},{"id":"d","text":"nurse"}]'::jsonb, 'c', 'A teacher, a farmer and a nurse are all jobs — work that people do. Bread is a food, so it is the intruder here. Sorting words into fields like jobs and food makes them easier to remember.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca3f58bc-14f7-52d3-9732-e29b5dc62927', '1f2dc15f-42d1-53be-8ce2-aa2a737933af', 'The opposite of "hot" is …', '[{"id":"a","text":"warm"},{"id":"b","text":"cold"},{"id":"c","text":"fast"},{"id":"d","text":"small"}]'::jsonb, 'b', 'The opposite of hot is cold. Warm means a little hot (it is close, but not the opposite), fast is the opposite of slow, and small is the opposite of big.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7f4ce371-1e6c-56bb-97df-254cf6f95e5d', '4637b3e6-610c-5b41-b0f9-dba49d698d90', 'anglais-a1', '⭐⭐ Review: Everyday Words', 2, 75, 15, 'practice', 'admin', 2)
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
  ('8745a26b-b690-5013-92a4-1a05451a01fb', '7f4ce371-1e6c-56bb-97df-254cf6f95e5d', 'Which word means the daughter of your brother or sister?', '[{"id":"a","text":"aunt"},{"id":"b","text":"cousin"},{"id":"c","text":"niece"},{"id":"d","text":"nephew"}]'::jsonb, 'c', 'Your niece is the daughter of your brother or sister; the son would be your nephew. An aunt is your parent''s sister, and a cousin is the child of your aunt or uncle. Niece (girl) and nephew (boy) are a gender pair — don''t swap them.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6bb99919-7568-5977-adda-4c8fa824da4a', '7f4ce371-1e6c-56bb-97df-254cf6f95e5d', 'Find the intruder (the word that is NOT a colour).', '[{"id":"a","text":"window"},{"id":"b","text":"yellow"},{"id":"c","text":"brown"},{"id":"d","text":"grey"}]'::jsonb, 'a', 'Yellow, brown and grey are all colours. A window is an object in a house, so it is the intruder. Note that grey is the British spelling; American English writes it gray.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8063fc05-8dc8-5398-bb04-7e64abf3abeb', '7f4ce371-1e6c-56bb-97df-254cf6f95e5d', 'Complete the common phrase: "a ___ of bread".', '[{"id":"a","text":"glass"},{"id":"b","text":"cup"},{"id":"c","text":"bottle"},{"id":"d","text":"slice"}]'::jsonb, 'd', 'We cut bread into pieces, so we say a slice of bread (or a piece of bread). A glass and a bottle hold drinks like water, and a cup holds tea or coffee — none of those goes with bread.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ad0f688-b675-537a-8011-0915b32e6245', '7f4ce371-1e6c-56bb-97df-254cf6f95e5d', 'Which word is a synonym of "cook" (a person who makes food)?', '[{"id":"a","text":"farmer"},{"id":"b","text":"chef"},{"id":"c","text":"driver"},{"id":"d","text":"nurse"}]'::jsonb, 'b', 'A chef is another word for a cook — a person whose job is to make food. A farmer grows crops, a driver drives, and a nurse helps sick people, so those are different jobs.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d1e0bae-e7b9-54d9-b264-5fd04e0a993a', '7f4ce371-1e6c-56bb-97df-254cf6f95e5d', 'The opposite of "expensive" is …', '[{"id":"a","text":"old"},{"id":"b","text":"difficult"},{"id":"c","text":"cheap"},{"id":"d","text":"small"}]'::jsonb, 'c', 'The opposite of expensive (costs a lot of money) is cheap (costs little money). Old is the opposite of new, difficult is the opposite of easy, and small is the opposite of big.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7be098c1-1f15-5eb8-bf34-d42e8e911943', '7f4ce371-1e6c-56bb-97df-254cf6f95e5d', 'Which word belongs to the field "school objects"?', '[{"id":"a","text":"milk"},{"id":"b","text":"engineer"},{"id":"c","text":"Monday"},{"id":"d","text":"pencil"}]'::jsonb, 'd', 'A pencil is a school object you write with. Milk is a drink, an engineer is a job, and Monday is a day of the week, so none of those belongs to school objects.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2e3c5811-d0bf-5232-a2ea-c59741945936', '4637b3e6-610c-5b41-b0f9-dba49d698d90', 'anglais-a1', '⚔️ Chapter Boss ⭐⭐⭐: Everyday Words', 3, 120, 30, 'boss', 'admin', 3)
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
  ('42a7c8e7-1eeb-53a0-b25a-e1ec71a7cae8', '2e3c5811-d0bf-5232-a2ea-c59741945936', 'Your mother''s mother is your …', '[{"id":"a","text":"aunt"},{"id":"b","text":"niece"},{"id":"c","text":"cousin"},{"id":"d","text":"grandmother"}]'::jsonb, 'd', 'Your mother''s mother (or your father''s mother) is your grandmother; her husband is your grandfather. An aunt is your parent''s sister, a niece is your sibling''s daughter, and a cousin is your aunt''s or uncle''s child — all one generation closer than a grandparent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('37606d8d-d4f0-5ba4-ba81-3d6bfc7e1325', '2e3c5811-d0bf-5232-a2ea-c59741945936', 'Find the intruder (the word that is NOT a member of the family).', '[{"id":"a","text":"daughter"},{"id":"b","text":"doctor"},{"id":"c","text":"son"},{"id":"d","text":"cousin"}]'::jsonb, 'b', 'Daughter, son and cousin are all members of a family. Doctor is a job, so it is the intruder. The trap is that doctor sounds a little like daughter, but they belong to different fields — family versus jobs.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e652893f-706a-57a2-831d-23ada4e230e5', '2e3c5811-d0bf-5232-a2ea-c59741945936', 'Complete the common phrase: "a ___ of milk".', '[{"id":"a","text":"slice"},{"id":"b","text":"loaf"},{"id":"c","text":"glass"},{"id":"d","text":"piece"}]'::jsonb, 'c', 'Milk is a drink you pour, so we say a glass of milk. A slice, a loaf and a piece go with solid food like bread — you can never say "a piece of milk". Match the measure word to whether the thing is a drink or a solid.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4553e00-df33-5575-8492-f617529c1076', '2e3c5811-d0bf-5232-a2ea-c59741945936', 'Which word is a synonym of "difficult"?', '[{"id":"a","text":"hard"},{"id":"b","text":"easy"},{"id":"c","text":"fast"},{"id":"d","text":"cheap"}]'::jsonb, 'a', 'Hard is a synonym of difficult (not easy to do): a hard quest is a difficult quest. Easy is its opposite, fast is the opposite of slow, and cheap is the opposite of expensive — so only hard means the same as difficult.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('483d8b4d-6d44-5ff8-8f37-24bf9dfce15d', '2e3c5811-d0bf-5232-a2ea-c59741945936', 'Put these in counting order. Which number is the ordinal "third"?', '[{"id":"a","text":"one"},{"id":"b","text":"two"},{"id":"c","text":"free"},{"id":"d","text":"three"}]'::jsonb, 'd', 'The ordinal third refers to position number three: first (1), second (2), third (3). One and two are the cardinal numbers before it, and "free" is a different word (it means costing no money), not a number — a common spelling and sound trap.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df2e8782-df88-5ac6-953f-0865b97814cf', '2e3c5811-d0bf-5232-a2ea-c59741945936', 'Find the intruder (the word that is NOT a drink).', '[{"id":"a","text":"water"},{"id":"b","text":"rice"},{"id":"c","text":"coffee"},{"id":"d","text":"tea"}]'::jsonb, 'b', 'Water, coffee and tea are all drinks. Rice is a food you eat, so it is the intruder. The trap is that all four are things you have at meals, but only rice is eaten, not drunk.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7f2abee2-eb27-5c45-aff9-08df89c5fba1', '4637b3e6-610c-5b41-b0f9-dba49d698d90', 'anglais-a1', '👑 Elite Challenge ⭐⭐⭐⭐: Everyday Words', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('43fad7ff-f4a5-5aeb-8884-a4b68434898b', '7f2abee2-eb27-5c45-aff9-08df89c5fba1', 'Read: "Sara is the daughter of my uncle." What is Sara to me?', '[{"id":"a","text":"my niece"},{"id":"b","text":"my cousin"},{"id":"c","text":"my aunt"},{"id":"d","text":"my sister"}]'::jsonb, 'b', 'The child of your uncle (or aunt) is your cousin, for a girl or a boy. A niece would be your own brother''s or sister''s daughter, an aunt is your parent''s sister, and a sister shares your parents — so only cousin fits the daughter of an uncle.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('688aa952-dae9-5587-b93e-776591d7252b', '7f2abee2-eb27-5c45-aff9-08df89c5fba1', 'Find the intruder: which of these colour words is also the name of a fruit?', '[{"id":"a","text":"red"},{"id":"b","text":"green"},{"id":"c","text":"pink"},{"id":"d","text":"orange"}]'::jsonb, 'd', 'All four words are colours, but only orange is also the name of a fruit, so it is the intruder. Red, green and pink name colours only. Some English words name both a colour and an everyday object.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('23548b3e-3f66-5a12-9e65-87b318e463ea', '7f2abee2-eb27-5c45-aff9-08df89c5fba1', 'Choose the sentence with the correct measure word.', '[{"id":"a","text":"I drank a piece of water."},{"id":"b","text":"She ate a glass of bread."},{"id":"c","text":"He drank a glass of water."},{"id":"d","text":"We ate a cup of rice."}]'::jsonb, 'c', 'You drink water from a glass, so a glass of water is correct. "A piece of water" is wrong because water is not solid; a glass holds drinks, not bread; and rice is served on a plate or in a bowl, not in a cup. Match the measure word to the food or drink.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43597329-4a82-5161-b031-c63e18b57f94', '7f2abee2-eb27-5c45-aff9-08df89c5fba1', 'Which pair are opposites?', '[{"id":"a","text":"old — new"},{"id":"b","text":"happy — fast"},{"id":"c","text":"big — tall"},{"id":"d","text":"hot — slow"}]'::jsonb, 'a', 'Old and new are true opposites (an old phone vs a new phone). The others mix unrelated pairs: happy goes with sad, big goes with small, and hot goes with cold — so fast, tall and slow are not their opposites.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e30c9d41-ce13-552e-aa79-68880ef16cc0', '7f2abee2-eb27-5c45-aff9-08df89c5fba1', 'Read: "My father''s brother fixes sick people in a hospital." What is his job, and what is he to me?', '[{"id":"a","text":"a teacher, and my uncle"},{"id":"b","text":"a doctor, and my cousin"},{"id":"c","text":"a farmer, and my uncle"},{"id":"d","text":"a doctor, and my uncle"}]'::jsonb, 'd', 'Someone who helps sick people in a hospital is a doctor (or a nurse), not a teacher or a farmer. Your father''s brother is your uncle, not your cousin (a cousin is the uncle''s child). So he is a doctor and my uncle.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('28e20ebf-274c-5733-9e74-7a82aeb79375', '7f2abee2-eb27-5c45-aff9-08df89c5fba1', 'Find the intruder (the word that is NOT an ordinal number).', '[{"id":"a","text":"first"},{"id":"b","text":"ten"},{"id":"c","text":"second"},{"id":"d","text":"third"}]'::jsonb, 'b', 'First, second and third are ordinal numbers — they show position in order. Ten is a cardinal number that shows how many, so it is the intruder. Cardinals count (one, two, ten); ordinals rank (first, second, third).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a9bcdd7e-8453-540f-8c64-0f7c6b449dc7', '492783bf-3de9-5c90-81ff-7ead506d6381', 'anglais-a1', 'Comprehension Check ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('e902bbb7-bdea-59e9-b4a3-c6e6705bd254', 'a9bcdd7e-8453-540f-8c64-0f7c6b449dc7', 'Which question word asks about a PLACE?', '[{"id":"a","text":"When"},{"id":"b","text":"Where"},{"id":"c","text":"Who"},{"id":"d","text":"Why"}]'::jsonb, 'b', 'Where asks about a place (Where is the school? — At the corner). When asks about a time, who about a person, and why about a reason. Match the question word to the kind of answer you want.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('173a5a03-c02d-5187-a05b-e42443cf8450', 'a9bcdd7e-8453-540f-8c64-0f7c6b449dc7', 'Complete: "___ is your name?"', '[{"id":"a","text":"What"},{"id":"b","text":"Where"},{"id":"c","text":"When"},{"id":"d","text":"How many"}]'::jsonb, 'a', 'A name is a thing, so we ask What is your name? Where asks for a place and when for a time, neither of which fits a name. How many asks for a number with a countable noun.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e124370e-46ee-5a92-a48c-b620d6d98937', 'a9bcdd7e-8453-540f-8c64-0f7c6b449dc7', 'Choose the correct question: "___ he live?"', '[{"id":"a","text":"Where lives"},{"id":"b","text":"Where is"},{"id":"c","text":"Where does"},{"id":"d","text":"Where do"}]'::jsonb, 'c', 'Live is an ordinary verb, so we need do/does. With he we use does + the base verb: Where does he live? Do is for I/you/we/they, and Where is would need an adjective or noun (Where is he?), not the verb live.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d07882ea-5945-52df-a447-0dcfce491c6b', 'a9bcdd7e-8453-540f-8c64-0f7c6b449dc7', 'Which question correctly uses "how much"?', '[{"id":"a","text":"How much books do you have?"},{"id":"b","text":"How much brothers do you have?"},{"id":"c","text":"How much water do you drink?"},{"id":"d","text":"How much apples do you eat?"}]'::jsonb, 'c', 'Use how much with uncountable nouns like water: How much water do you drink? Books, brothers and apples are countable, so they need how many (How many books…?). This is the key countable / uncountable split.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('456a9857-93e9-522f-ae55-075d5583e4e5', 'a9bcdd7e-8453-540f-8c64-0f7c6b449dc7', 'Match the question to its answer: "Where is the bank?"', '[{"id":"a","text":"At nine o''clock."},{"id":"b","text":"Next to the post office."},{"id":"c","text":"Because it is closed."},{"id":"d","text":"It is Sara''s."}]'::jsonb, 'b', 'A Where question asks for a place, so the answer is a location: Next to the post office. "At nine o''clock" answers When, "Because…" answers Why, and "It is Sara''s" answers Whose. Always match the answer to the question word.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('177729d8-9816-5129-86ea-b7e98e738979', '492783bf-3de9-5c90-81ff-7ead506d6381', 'anglais-a1', '⭐ Practice: Questions & Reading', 1, 50, 10, 'practice', 'admin', 1)
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
  ('4fad0a5e-b283-5d86-bc4e-dd654e1816c9', '177729d8-9816-5129-86ea-b7e98e738979', 'Which question word asks about a TIME?', '[{"id":"a","text":"Where"},{"id":"b","text":"Who"},{"id":"c","text":"When"},{"id":"d","text":"What"}]'::jsonb, 'c', 'When asks about a time (When is the lesson? — At nine). Where asks about a place, who about a person, and what about a thing. Each question word expects a different kind of answer.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b1a01df-051e-5c43-90da-a24c3a58112f', '177729d8-9816-5129-86ea-b7e98e738979', 'Complete: "___ are you?" — "I''m fine, thank you."', '[{"id":"a","text":"How"},{"id":"b","text":"What"},{"id":"c","text":"Where"},{"id":"d","text":"Whose"}]'::jsonb, 'a', 'How asks about manner or condition, so How are you? gets the reply I''m fine. What asks for a thing, where for a place, and whose for an owner — none of which fits "I''m fine".', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dbe3cf4f-127c-588d-8980-a356fc492380', '177729d8-9816-5129-86ea-b7e98e738979', 'Complete: "___ is your teacher?" — "Mr Ben Ali."', '[{"id":"a","text":"What"},{"id":"b","text":"Who"},{"id":"c","text":"Where"},{"id":"d","text":"When"}]'::jsonb, 'b', 'Who asks about a person, so Who is your teacher? is answered with a name: Mr Ben Ali. What asks for a thing, where for a place, and when for a time.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('079bd38b-f44f-5dda-9bc5-0a533066c261', '177729d8-9816-5129-86ea-b7e98e738979', 'Complete: "___ do you have?" — "Two brothers."', '[{"id":"a","text":"How much"},{"id":"b","text":"How many"},{"id":"c","text":"Whose"},{"id":"d","text":"Why"}]'::jsonb, 'b', 'Brothers is countable, so we ask how many: How many brothers do you have? — Two. How much is for uncountable nouns (how much water), whose asks for an owner, and why asks for a reason.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d927e93b-9657-5dc2-89c5-2e844e7832a8', '177729d8-9816-5129-86ea-b7e98e738979', 'Read: "Tom is from London. He is a student."
Where is Tom from?', '[{"id":"a","text":"He is a student."},{"id":"b","text":"From Tunis."},{"id":"c","text":"From London."},{"id":"d","text":"He is a teacher."}]'::jsonb, 'c', 'The text says "Tom is from London", so the answer is From London. "He is a student" answers a different question (his job), Tunis is not in the text, and the text never calls him a teacher.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c32eda4-ecf4-5d0f-9a62-3126df54f75c', '177729d8-9816-5129-86ea-b7e98e738979', 'Match the question to its answer: "Whose book is this?"', '[{"id":"a","text":"It''s on the desk."},{"id":"b","text":"It''s Sara''s."},{"id":"c","text":"At eight o''clock."},{"id":"d","text":"Because it is good."}]'::jsonb, 'b', 'Whose asks who owns something, so the answer names an owner: It''s Sara''s. "It''s on the desk" answers Where, "At eight o''clock" answers When, and "Because…" answers Why.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7f3cc6f2-61bf-5e73-ba2b-708a3dfeace4', '492783bf-3de9-5c90-81ff-7ead506d6381', 'anglais-a1', '⭐⭐ Review: Questions & Reading', 2, 75, 15, 'practice', 'admin', 2)
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
  ('c969dd44-e2a9-51b5-b81e-e101863b9cc0', '7f3cc6f2-61bf-5e73-ba2b-708a3dfeace4', 'Complete: "___ does the film start?" — "At eight."', '[{"id":"a","text":"Where"},{"id":"b","text":"Who"},{"id":"c","text":"When"},{"id":"d","text":"Whose"}]'::jsonb, 'c', '"At eight" is a time, so the question word is when: When does the film start? Where asks for a place, who for a person, and whose for an owner — none matches a time.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1d244fe6-d1c3-5f30-a59d-f6d712d85e68', '7f3cc6f2-61bf-5e73-ba2b-708a3dfeace4', 'Choose the correct question: "Where ___ she work?"', '[{"id":"a","text":"do"},{"id":"b","text":"does"},{"id":"c","text":"is"},{"id":"d","text":"are"}]'::jsonb, 'b', 'Work is an ordinary verb and she is third person, so we use does: Where does she work? Do is for I/you/we/they, and is/are (to be) would need an adjective or noun, not the verb work.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e6654964-99c8-5771-94ae-82b794d909c0', '7f3cc6f2-61bf-5e73-ba2b-708a3dfeace4', 'Complete: "___ water do you drink every day?"', '[{"id":"a","text":"How many"},{"id":"b","text":"How much"},{"id":"c","text":"How"},{"id":"d","text":"What"}]'::jsonb, 'b', 'Water is uncountable (no plural), so use how much: How much water do you drink? How many is for countable nouns (how many glasses), how alone asks about manner, and what asks for a thing.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c1c94bf-fea7-5b4e-b6cf-1cfa248fae82', '7f3cc6f2-61bf-5e73-ba2b-708a3dfeace4', 'Read: "Mona is a nurse. She works in a hospital in Sfax."
What is Mona''s job?', '[{"id":"a","text":"A teacher."},{"id":"b","text":"A nurse."},{"id":"c","text":"A doctor."},{"id":"d","text":"A student."}]'::jsonb, 'b', 'The text says "Mona is a nurse", so her job is a nurse. A doctor also works in a hospital, but the text names her a nurse, not a doctor — read the exact word. Teacher and student are not mentioned.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('da41b10a-55dc-5f5d-a3fb-6093a20de504', '7f3cc6f2-61bf-5e73-ba2b-708a3dfeace4', 'Find the INCORRECT question.', '[{"id":"a","text":"Where is your school?"},{"id":"b","text":"What do you want?"},{"id":"c","text":"Where she lives?"},{"id":"d","text":"Who are your friends?"}]'::jsonb, 'c', 'The error is (c): an ordinary-verb question needs the helper do/does — it should be Where does she live? Dropping the auxiliary ("Where she lives?") keeps statement order. (a) and (d) use to be correctly, and (b) uses do correctly.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24337e38-ca1f-5d72-bdcd-a511baf08559', '7f3cc6f2-61bf-5e73-ba2b-708a3dfeace4', 'Read: "Mona is a nurse. She works in a hospital in Sfax."
Where does Mona work?', '[{"id":"a","text":"In a school."},{"id":"b","text":"In a shop."},{"id":"c","text":"At home."},{"id":"d","text":"In a hospital."}]'::jsonb, 'd', 'A Where question asks for a place, and the text says "She works in a hospital", so the answer is In a hospital. School, shop and home are all places, but none of them appears in the text.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e8380938-5f4a-5925-ab89-1b28604c029f', '492783bf-3de9-5c90-81ff-7ead506d6381', 'anglais-a1', '⚔️ Chapter Boss ⭐⭐⭐: Questions & Reading', 3, 120, 30, 'boss', 'admin', 3)
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
  ('26b7248b-5b68-57b0-86eb-a572778e1492', 'e8380938-5f4a-5925-ab89-1b28604c029f', 'Choose the correct question for the answer "Because I am tired."', '[{"id":"a","text":"Why do you sleep early?"},{"id":"b","text":"Where are you?"},{"id":"c","text":"When do you sleep?"},{"id":"d","text":"How many hours do you sleep?"}]'::jsonb, 'a', 'An answer starting with "Because…" gives a reason, so the question word is why: Why do you sleep early? When asks for a time, where for a place, and how many for a number — none is answered with a reason.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87cecf68-6eb1-52cc-b20f-0b3b725f9360', 'e8380938-5f4a-5925-ab89-1b28604c029f', 'Complete: "___ apples are there in the bag?"', '[{"id":"a","text":"How much"},{"id":"b","text":"Whose"},{"id":"c","text":"What"},{"id":"d","text":"How many"}]'::jsonb, 'd', 'Apples is countable, so use how many: How many apples are there? How much is only for uncountable nouns (how much sugar), whose asks for an owner, and what asks for a thing, not a number.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02b7d2ed-1255-514a-9fd1-33b653d4b912', 'e8380938-5f4a-5925-ab89-1b28604c029f', 'Find the INCORRECT question.', '[{"id":"a","text":"Where does she live?"},{"id":"b","text":"Where does she lives?"},{"id":"c","text":"What does he eat?"},{"id":"d","text":"When do they arrive?"}]'::jsonb, 'b', 'The error is (b): the verb is double-marked. With does, the main verb stays in its base form — Where does she live?, never "does she lives". The -s belongs to does, not to the main verb. (a), (c) and (d) are all correct.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4bb39dc-24d7-5933-8f0a-ac50f799e480', 'e8380938-5f4a-5925-ab89-1b28604c029f', 'Read: "David is a cook. He works in a restaurant. He starts work at four o''clock."
When does David start work?', '[{"id":"a","text":"In a restaurant."},{"id":"b","text":"He is a cook."},{"id":"c","text":"At four o''clock."},{"id":"d","text":"At eight o''clock."}]'::jsonb, 'c', 'A When question asks for a time, and the text says "He starts work at four o''clock", so the answer is At four o''clock. "In a restaurant" answers Where, "He is a cook" answers his job, and eight o''clock is not in the text.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f6877d05-08de-52d0-a838-cfa2205af978', 'e8380938-5f4a-5925-ab89-1b28604c029f', 'Read: "David is a cook. He works in a restaurant. He cooks food for the customers."
Does David make food?', '[{"id":"a","text":"No, he is a driver."},{"id":"b","text":"No, he cleans cars."},{"id":"c","text":"We don''t know his job."},{"id":"d","text":"Yes, he cooks food."}]'::jsonb, 'd', 'A cook who "cooks food for the customers" does make food, so the answer is Yes, he cooks food (d). (c) is wrong because the text clearly names his job — cook — so we do know it; (a) and (b) invent driving or cleaning cars the text never mentions.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00467c90-2f80-593e-a7ff-fb4dab9b7ce1', 'e8380938-5f4a-5925-ab89-1b28604c029f', 'Choose the question that matches the answer "It''s my sister''s."', '[{"id":"a","text":"Where is your bag?"},{"id":"b","text":"Whose bag is this?"},{"id":"c","text":"What is in your bag?"},{"id":"d","text":"When is the class?"}]'::jsonb, 'b', '"It''s my sister''s" names an owner, so the question is Whose bag is this? Where asks for a place, what asks for a thing, and when asks for a time — none of those is answered by naming an owner.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('99efb0dc-be51-5a2d-9c11-073853507af9', '492783bf-3de9-5c90-81ff-7ead506d6381', 'anglais-a1', '👑 Elite Challenge ⭐⭐⭐⭐: Questions & Reading', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('50544641-ac20-5882-a00d-59cf033a1f35', '99efb0dc-be51-5a2d-9c11-073853507af9', 'Read: "Sara is a teacher. She lives in Tunis. She has two children."
Where does Sara live?', '[{"id":"a","text":"In Tunis."},{"id":"b","text":"She is a teacher."},{"id":"c","text":"She has two children."},{"id":"d","text":"In Sfax."}]'::jsonb, 'a', 'A Where question asks for a place, and the text says "She lives in Tunis", so the answer is In Tunis. "She is a teacher" gives her job and "She has two children" her family — neither is a place — and Sfax is not in the text.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('69cb30b1-48d3-5d3a-b593-2c5b574a27fd', '99efb0dc-be51-5a2d-9c11-073853507af9', 'Find the INCORRECT question.', '[{"id":"a","text":"How many books do you read?"},{"id":"b","text":"How much money do you have?"},{"id":"c","text":"How much books do you read?"},{"id":"d","text":"How many friends do you have?"}]'::jsonb, 'c', 'The error is (c): books is countable, so it needs how many, not how much — How many books do you read? How much is reserved for uncountable nouns like money (b). (a) and (d) use how many with countable nouns correctly.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7db59d48-6616-5e9a-9b9c-5900893d758d', '99efb0dc-be51-5a2d-9c11-073853507af9', 'Read: "Karim works in a big hospital. He wears a white coat. He helps sick people every day."
What is Karim''s job, most probably?', '[{"id":"a","text":"He is a farmer."},{"id":"b","text":"He is a doctor."},{"id":"c","text":"He is a driver."},{"id":"d","text":"He is a cook."}]'::jsonb, 'b', 'This is an inference: working in a hospital, wearing a white coat and helping sick people all point to a doctor. The text does not say "doctor" directly, but the clues support it. A farmer, driver or cook would not match all three details.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c148db8-d6c1-5b2a-9ed9-a7912adf0dbc', '99efb0dc-be51-5a2d-9c11-073853507af9', 'Read: "Lina gets up at six. She goes to school at seven. She comes home at four."
Which question can you NOT answer from the text?', '[{"id":"a","text":"When does Lina get up?"},{"id":"b","text":"When does Lina go to school?"},{"id":"c","text":"How does Lina go to school?"},{"id":"d","text":"When does Lina come home?"}]'::jsonb, 'c', 'The text gives three times (six, seven, four) but never says HOW Lina travels, so "How does Lina go to school?" cannot be answered. The other three questions each match a time stated in the text. Never infer beyond what the words support.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ea6a154-1c20-50ce-8311-f6c13429e7ff', '99efb0dc-be51-5a2d-9c11-073853507af9', 'Choose the question-and-answer pair that matches correctly.', '[{"id":"a","text":"\"Where do you work?\" — \"At nine o''clock.\""},{"id":"b","text":"\"When do you start?\" — \"In an office.\""},{"id":"c","text":"\"Why are you late?\" — \"Because the bus was full.\""},{"id":"d","text":"\"Who is she?\" — \"In the kitchen.\""}]'::jsonb, 'c', 'Only (c) matches: Why asks for a reason, answered by "Because the bus was full". (a) answers Where with a time, (b) answers When with a place, and (d) answers Who with a place instead of a person.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('05cf392e-777c-5c48-ac31-f802b94a4700', '99efb0dc-be51-5a2d-9c11-073853507af9', 'Choose the fully correct question.', '[{"id":"a","text":"Where does your father works?"},{"id":"b","text":"Where your father works?"},{"id":"c","text":"What does your father does?"},{"id":"d","text":"What time does your father go to work?"}]'::jsonb, 'd', 'Only (d) is correct: question word + does + subject + base verb gives What time does your father go to work? (a) double-marks the verb (does ... works); (b) drops the helper does; (c) repeats does instead of the base form do — it should be What does your father do?', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

