-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: francais-a1 (Français — Débutant (A1 · DELF A1))
-- Regenerate with: npm run content:build
-- Source of truth: content/francais-a1/
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
  ('francais-a1', 'Français — Débutant (A1 · DELF A1)', 'Construis des bases solides en français, des formes les plus simples vers le haut : être et avoir, le présent des verbes en -er, les articles et le genre des noms, le vocabulaire du quotidien, poser une question et lire un texte court. Niveau débutant (CECRL A1), aligné sur le DELF A1.', 'Agilité', 'subject-french', 'Languages', 1, 'fr', false, 'francais', NULL)
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
      AND e.subject_id = 'francais-a1'
      AND e.source = 'admin'
      AND q.id NOT IN ('5e8f1880-22ef-55e6-b8c2-ef2ebc6e10da', '33a7b25b-5a69-581d-9891-8a0e6deef2b6', 'b0264af0-1452-52d9-84e3-34b986fb8e3f', '05f29284-c77a-57e9-a202-3153aa17c90a', '0f69e7f6-7cdd-56a4-b3cf-b2d9500e75c8', '4e65cae6-6a61-5500-9ec5-6413e2ac04b3', '457ab7c4-e571-5435-9ffb-b49e759fbc64', '3a2d4f99-5f9f-5981-962c-be584ef2c94e', '571d5116-7b51-5bd0-9fc0-0382c13a81c6', '5b094771-9cbe-50fc-83c9-5f79eeb48f0b', '48bf23c3-809a-548e-a7f9-4b4a688ba406', '97f4da18-f1b9-58ea-acee-46fc8e50be23', '69d016ee-de97-50cc-995a-957a5f983bc6', '94e52d26-5b63-5225-a8ec-1d28c6e0ee4b', 'fe013efc-23ff-547d-a11b-c24afeccf27d', 'f074c5c8-01d8-531c-a639-bec5cb5536a2', 'a1f43a69-ed2a-5f4c-88de-c5e1fe721db8', '22d86b61-d8d3-5b6d-8d62-410e86a2ed80', '2059fcf2-b1d6-552a-b089-00c2ac8dacdf', 'd27528fb-716f-585f-af57-3bbea51dc073', 'b2363548-b6b2-55d3-bc68-4afab9fb682d', 'bdc5d2a2-141c-54b6-87b3-02e881fe22e6', '39a190a4-3fcd-5b7b-bcf3-268667f0712c', 'acd81700-0692-525e-8c7f-d276a95941da', '07417c36-375b-5211-9c57-b17d1aa7b751', 'd4182f6c-a2a7-512b-b907-c9f1a212e413', '13ad4ea8-4040-5c40-8acd-d285ec6ad89e', 'fd9ee791-3e7f-5cc6-ae9a-d9434112b6a9', '6f7d8e34-981f-575a-9f14-13c8ff3912cb', '82f05f72-9793-5121-9116-4c39e4b6292e', 'e4e1af62-799f-5e3e-931d-2fb35648f491', 'fdfde6ad-cc78-55a1-a6c9-378880a87688', 'af1a2b70-05cc-5dea-8bfd-84c92e48d143', '46354e55-2d4b-5d7a-904f-07fc73778f72', 'd54c0041-1d54-58f0-bd1a-fe866e69d346', '5fd5be01-0adf-56b2-9c23-2b2f0bbbe5e5', '48337208-1f6a-58d7-a640-b157931e8b88', 'e0710a1c-ddf5-5b3f-a62c-c57a582c4961', 'b335a520-ae98-5cc5-b3e8-72cecd15e48e', '5d43497a-fd11-57de-8cef-b0d8e8bcc58c', '0261a9a1-e91d-561c-bfcc-2ff6886bf35f', '18ef6151-895e-54eb-aa38-3e0f065becdc', '1f16218f-45c5-50dd-bc5e-8e00b2fd4415', '6069fd73-45d8-56f4-be8a-c58200f0fab2', '8326f8dc-dec5-5906-b317-b41f9001ceb0', '02510a10-71d5-5a85-bf62-04402ab4e0ab', '35e267be-21b7-5ef0-b3fb-a0bde4eda187', 'db6cb78d-2f01-59dd-817a-1dcdfd0c5183', '4c1ad37f-baae-559c-8965-8002fdc14c26', '61450b5e-beb1-51a0-a271-8a8cac6f6eeb', 'cd045067-ea89-5e69-838c-d2cfd88ae830', 'd02ad5bd-1b7b-5489-8690-27ea1e03d345', 'd7441ffe-0126-5497-b66c-3a540244401c', 'a290cf9f-926f-52f9-97d7-35ca87853b61', '59f7918b-6e62-564e-ab9c-4fb58ddf505e', '5f716770-0287-5c29-9191-b0211616c7cc', '274ab3b1-e467-5583-92f3-16535c1e85e5', 'cfac46b0-fe05-562e-b5b0-774a1ab556c9', 'aeeb770c-4c15-5e52-b0a1-25ac599bdb74', 'd2e67e33-ad71-5482-bbec-4270367778f4', 'fc67c61a-b0ee-5e05-a9cf-7375b72c6a5b', '46d1784a-db78-5783-9a8f-5bac317b82ed', 'b6c97919-bcdc-5886-9fc0-f4f0c8ff106f', 'ae7aa3ee-d043-54ac-bf01-5d341733a4d8', '6f7a4267-2070-58ea-8244-a2f7eba34e95', '3f21dcf0-0101-571e-a00c-cea13b0f7414', '3e2febb7-2b01-5eab-923f-80f2a0473b6d', '5bae49ca-130e-516b-8a8a-5ec98e481cf3', '290ff040-c24f-56eb-84ad-f962e8c43518', '5b53211f-ae68-57ea-a9e2-1703acc4a29d', '0ff29ce2-88e5-542a-ac01-a3d172cce948', 'a4003abb-85d3-5076-a5a7-5deac86ed008', 'f4149348-3e79-5a88-bbb2-3043a79adb89', 'e5b9bc1f-fae0-51b8-bf8f-1b3d7f22aded', 'baa379ae-2022-5979-9c8d-26976394b590', '88898e77-58ee-53a5-8258-a01c13d0090a', '1e11a713-0ad1-5700-b4bf-94290ceee570', '3c9e8ea7-7164-5670-a90d-05b690fac7b6', 'e48a70fb-cdd0-5b68-8f92-8ee94f60c7d3', '022c3853-fe0a-52f7-a5ac-baedc251d485', 'eddbb1b5-9b28-51e8-8d32-464d2b424b0b', '35111da4-c1f6-5c47-92d6-abf1da1e41f5', 'd80f4f95-bed5-5107-a0ef-e9fab6b5f1e6', 'bf569014-eeac-5a24-aa41-ffc47b1142e5', '32c6731b-9f94-5a65-ba3e-3d404b489211', '6c04a9d9-f88b-52e8-9a40-3d9a60541ee1', '4b758dba-e34c-5346-914b-0640115d7266', '9d62d265-c183-513d-aeab-61eb5d67294b', '9ab4202e-dc67-5397-a3dc-83c428a28fa9', '662e53f7-735c-514d-b9bb-a6f5d3f4dd97', '097397e3-f28e-59b5-8fce-7917f3684ef2', '1697a810-1ea0-59f3-bdb1-650f92337450', 'b6d48fd1-10d2-54c5-9c09-87c09445c80b', 'fcea970a-b2f2-532b-8eb6-2dd1517e1a68', 'e8cdc574-3e3a-5796-ad6a-d1f5629f577c', 'e947138c-d108-51d1-a9f1-9318971f56b6', '7b5e7f02-7556-51bd-b621-e77dc4f0998a', '63d8e141-c222-543d-bb24-8598e4c07738', '92e5d9c6-1146-5df5-9bb1-928c031448a2', '9fad2be6-430a-59c1-9a97-f640401685c0', '8c84a417-4281-5b0b-84de-f491a8f8c51e', 'cbdca000-2b53-5c00-b30c-850c88642ca3', 'b1460eaa-5d5c-5561-9cfc-f038fc4e3779', 'be9b2d2f-7d61-5e2b-b055-2470a808d9ff', '20e87c2b-4a20-5ccf-b3c3-1f28bcb3742c', '44da0cce-a632-5007-8136-73696505228b', '07c47d92-6981-5c97-b6ba-328f83c1d5ed', '04dc679f-e7a7-5327-a965-8ad3b5ef1076', '0e3b5132-0147-57d3-b834-7ad7edb5b080', 'b9dfc13c-ebb0-52a0-b065-947a6f7255a8', '6dc4d2d8-30e0-55c2-9cb3-c6506272e08f', 'ad1a35e7-77ad-5380-95c8-276c137ca4c2', '817df0f3-994d-593d-89f4-3fd3ffde9299', '584dc01f-979a-51c6-b547-50ccb4dc4434', '582028d4-27fe-52e4-ad20-072c93bd7aaa', '24311e07-fbb7-59aa-b343-3a402bc182f6', 'c8df1e1c-3f15-545e-bf0f-6ffa6c8670df', '298050a5-e505-5f04-b29b-0cb01c04f2df', '5429a45c-543d-5c30-87b4-7dbaacf105b2', '4eddcd6b-740a-5a55-aa5c-e382696b9d52', 'a58f847e-feba-5095-836d-b63052bb054d', '2218752f-657c-5fc1-b9c1-46ab5f99b056', '5637a5ff-fa93-52c1-8612-67707971a16a', 'd1fa6c14-bf9e-5140-b857-d7801333423a', 'c9f7df10-822d-5d8a-bcf3-fe962b09b8a8', 'caa1fbac-b20d-5408-978b-329f8654c175', '499dd3e8-1fc7-5016-932c-d0931d13a0a8', '99d9fded-e695-5134-a076-baef0f217966', 'd51e6849-b703-5786-bd44-9a0e3bd82fbd', '3268b362-e563-5ac2-bcd4-e99a57efb743', 'e79842a9-75be-5192-ba1e-51f48ddceb6e', '4aea4da9-c8f1-58e1-abf7-91d9c55d20ab', '250acf66-4ecd-5919-a740-a7a5fa8b1913', 'ab3551e6-d1e3-5863-a599-30c32f589cf2', 'c91bcd69-98e4-5552-bd28-6f41a865d209', '14f7576f-2b79-58bf-a2f1-fff7a3e74a23', '36ec7d61-9631-5b47-8d5b-8723d950145b', '0a2471c4-464c-522d-928a-f6cd3c9f53d7', 'c19cfe80-f61d-5a87-af8b-934c05afc683', '2076a795-b582-5247-bb30-0b3914a9dbe0', 'e40379d5-2265-5c86-84e6-b2c21bb53b59', 'fca87733-2061-5da1-b8c0-dad43a74dc0a', 'e74434d2-d686-5970-8257-014632eeba2e', 'f19414b0-88ac-52e8-a4e1-d4de032d8137', 'e9cb7eca-7c37-528f-8cf4-579374c15846', 'a034344a-d73c-53dc-89ed-5edae545ee8a', 'bcca2e39-3ae4-504d-9fa8-89535302e2e7', 'ce2d6d96-f954-5a03-8d1e-652d4cc44fc4', '6df67b64-ec9f-5016-b8a1-3fe6e4898014', 'bcac7bc7-7a80-5dfb-bb73-c00e8624cc75', '7e072082-2a4a-536d-a8f6-59d6e3be47d0', '7b16a2fa-63ba-54cf-8328-c540147a5bfc', 'a5169f77-e4b9-5ae9-bb2c-bef688ef9538', '92287f35-9cda-503e-89f9-f96f76f3873f', '523916c2-9df9-5704-af04-a8c2e45144d5', '9c63d490-08e8-5864-b738-e29191d6f681', 'e50f3f7b-0369-52fd-88c5-41f174a0695c', '7e96cda4-0dab-5337-9394-4b1b86cf4b70', '498027d9-c500-57a2-835b-1c28ce6aecea', '389a9d29-4c25-5fef-8890-961dec2969dc', '73dc8cab-995b-51ff-b86b-1c2e76798477', '212cb3b7-b1d1-5945-9c67-99f0247e770f', '14d7c5ae-5385-5998-acb3-791cd477ed42', 'b9e51165-8a6c-56e9-a8ab-ee3985961695', 'e9f3ad08-543c-5a92-a2da-28b4fd13f050', 'ccd9b02f-6ff3-5d56-824c-0fb279c0897f', '8391b212-b280-5b72-952d-d575e50b35ab', '8cb25dc2-5cdd-5233-b6ba-b0beb4dbc039', 'cf7ccfc9-9098-5e07-837f-809200fac0df', '0cc60143-9d10-5ab1-9ea4-b93674066783', '9fc06fe5-61b8-57d6-bcd9-ccdb4953a1ac', 'f711a596-febd-5d1c-87f3-912106770ebd', 'c7fa441b-becb-572d-90d3-a9993fa25509', '663e1c32-988a-50af-9ff4-943819c24a38', '2861ddac-114e-595c-b144-b2307ddbad9a', '7a6b6535-a66c-5d42-b13f-ed8fdd610111', '2e00c180-1a46-5f59-b857-f23c3c38a9dc', 'f138a932-d08e-54a9-ab59-9185225251a7', '291187d2-1d1d-5ecf-98f3-628e97882556', 'acbe89eb-2314-55dc-a88f-1246e020c522', '7d52261a-7d0a-59c0-9230-fc858d5dd057', '6ea4178b-f738-5e6a-ba3e-4753d9c1d64d', '97ba2e96-a6c9-5f2f-a2a8-ac8d41ae662c', '66bc69cc-3177-54bd-8c72-eb2ebbfa3055', '345d9217-887e-55ef-b9b5-a92992f2a27a', 'a5aef042-5730-5c52-a87d-471b2313de59', '462041d4-a011-5b7b-9915-6c8f61f5beb9', '1bfd35c4-0c1e-5643-9343-27eb4ebefe16', 'fc07256e-473b-5073-a6cf-5355e50e1f3d', '5dc6960b-97c3-54c3-9572-2471a439b62e', '2294716e-81e4-5ae1-8414-8e2f26e27ea1', '9c6ee216-7af4-57fa-a4ec-facbece3f8e7', 'e7a45a93-5f75-5663-b122-0999cb8677ab', 'bb836141-af4a-5272-b725-7121a8c6fcd3', 'ba3fb009-2cee-5867-b1f1-e3955a6151e7', 'a52559d2-2e99-5247-a541-fddf12b2adf9', 'efdf3643-9e05-5c38-9971-e56a38c990cf', '5e0aa51f-cd3f-5326-a618-d97a4ee8095f', '617293a1-3b82-5634-964d-f371ec0b8277', '85331ca4-987b-5914-bd7a-868b73d830f3', '5f3c7e26-fcd1-59e1-b99d-207086e21b55', 'df7d6e19-8c0e-5209-99bd-3849e1823141', '6aec1607-dc0d-512e-8319-105dcc4e2213', '87238d96-c79a-5488-b0dc-de8aebb4b70c', 'd1bb11e3-b139-52bb-816e-e0679ff41b51', '8d91ab71-aa7f-5308-86c0-221ac2103f52', '7e201495-8285-5b9a-aebf-9bee9f4c1e00', '9dac95aa-0222-568b-b161-1631cbfae7e9', 'df17eb68-be02-552b-8b85-3d1bbb38557e', 'a389181a-4689-57d4-a41f-53d11f70cd20');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'francais-a1' AND source = 'admin' AND id NOT IN ('de135706-12c1-5087-876e-2f7ca580d939', 'def6e6de-0a98-54fb-a1b4-6e9ed9f957d7', '79306525-2342-53c1-ad31-083c9a53ac8d', '11fdf60b-6571-589f-be91-0dd4d324bcdc', 'f3dd4dc6-9b35-544b-b30d-b5f35f1da030', 'ceb52d48-9052-5ba6-a112-8573f9499f62', '5f5a3e47-858b-5c82-8594-31e6785b6ee3', 'bfebe38a-2a0f-5255-ae03-ac78f4989707', '1eda4d00-6cf6-527d-9cca-ba59fbbc3b83', '2233e08c-559c-5869-a382-5eb596a4a281', '9fe1ca6b-46d9-5027-b010-b8afc186ca1e', '6a60b097-1e72-53a6-8cdd-a5037998844b', '880a0660-3e8d-5c3d-bc12-619d84d54545', 'b31c16f5-ffa2-5dfa-91a8-35b56699ded0', 'c02898af-a58e-5b2f-8c43-ae6986f9646d', 'b6dc861f-3417-59a0-a428-00b4864a23df', '65cdc111-8305-5cd6-92e2-be14376fcf92', 'e7e84386-cad2-55ed-b339-529f55a6beb0', '1bcff293-e5e6-5d46-83ee-6a0c0e94c0df', 'c59cd147-cdaa-5d3e-9949-24640ea62a74', 'e9c13bd1-56c5-5930-bd83-cbfccb41760e', '0f2721aa-166a-5d7c-97fd-e1a0c77384a7', 'f831a806-892f-5ce0-adff-bb7e0ae7720c', 'a1044b76-ad22-59fa-9317-fc8718ec63a1', '2bc590d3-fcf6-559e-aea1-8c3ecf6b5095', 'cd45e110-11a2-5757-bbb0-f560b76dabbc', 'd44ff6c1-9f43-5fc9-88e1-ee441810bc44', '5c41cb21-4d01-5bc2-9603-a56192caadf9', 'a4a9807d-c98a-502f-a98d-49ebfc2e326e', '979ee26f-0a4a-5f03-a6d9-849be4ba6186', '2e847056-9c2e-570e-bfb3-bada695a1780', '7c46ec33-964b-56a9-a5a2-519f5b61c048', '099d9bf0-800c-58ed-924b-87810c5f650f', 'c04eba2e-3966-58ec-8586-1263e85bf749', '3409d769-1abf-5e8b-a0fd-f96e0462fee1', 'f30e7361-cea4-5e6b-bde7-680197e34879');
DELETE FROM public.questions WHERE exercise_id IN ('de135706-12c1-5087-876e-2f7ca580d939', 'def6e6de-0a98-54fb-a1b4-6e9ed9f957d7', '79306525-2342-53c1-ad31-083c9a53ac8d', '11fdf60b-6571-589f-be91-0dd4d324bcdc', 'f3dd4dc6-9b35-544b-b30d-b5f35f1da030', 'ceb52d48-9052-5ba6-a112-8573f9499f62', '5f5a3e47-858b-5c82-8594-31e6785b6ee3', 'bfebe38a-2a0f-5255-ae03-ac78f4989707', '1eda4d00-6cf6-527d-9cca-ba59fbbc3b83', '2233e08c-559c-5869-a382-5eb596a4a281', '9fe1ca6b-46d9-5027-b010-b8afc186ca1e', '6a60b097-1e72-53a6-8cdd-a5037998844b', '880a0660-3e8d-5c3d-bc12-619d84d54545', 'b31c16f5-ffa2-5dfa-91a8-35b56699ded0', 'c02898af-a58e-5b2f-8c43-ae6986f9646d', 'b6dc861f-3417-59a0-a428-00b4864a23df', '65cdc111-8305-5cd6-92e2-be14376fcf92', 'e7e84386-cad2-55ed-b339-529f55a6beb0', '1bcff293-e5e6-5d46-83ee-6a0c0e94c0df', 'c59cd147-cdaa-5d3e-9949-24640ea62a74', 'e9c13bd1-56c5-5930-bd83-cbfccb41760e', '0f2721aa-166a-5d7c-97fd-e1a0c77384a7', 'f831a806-892f-5ce0-adff-bb7e0ae7720c', 'a1044b76-ad22-59fa-9317-fc8718ec63a1', '2bc590d3-fcf6-559e-aea1-8c3ecf6b5095', 'cd45e110-11a2-5757-bbb0-f560b76dabbc', 'd44ff6c1-9f43-5fc9-88e1-ee441810bc44', '5c41cb21-4d01-5bc2-9603-a56192caadf9', 'a4a9807d-c98a-502f-a98d-49ebfc2e326e', '979ee26f-0a4a-5f03-a6d9-849be4ba6186', '2e847056-9c2e-570e-bfb3-bada695a1780', '7c46ec33-964b-56a9-a5a2-519f5b61c048', '099d9bf0-800c-58ed-924b-87810c5f650f', 'c04eba2e-3966-58ec-8586-1263e85bf749', '3409d769-1abf-5e8b-a0fd-f96e0462fee1', 'f30e7361-cea4-5e6b-bde7-680197e34879') AND id NOT IN ('5e8f1880-22ef-55e6-b8c2-ef2ebc6e10da', '33a7b25b-5a69-581d-9891-8a0e6deef2b6', 'b0264af0-1452-52d9-84e3-34b986fb8e3f', '05f29284-c77a-57e9-a202-3153aa17c90a', '0f69e7f6-7cdd-56a4-b3cf-b2d9500e75c8', '4e65cae6-6a61-5500-9ec5-6413e2ac04b3', '457ab7c4-e571-5435-9ffb-b49e759fbc64', '3a2d4f99-5f9f-5981-962c-be584ef2c94e', '571d5116-7b51-5bd0-9fc0-0382c13a81c6', '5b094771-9cbe-50fc-83c9-5f79eeb48f0b', '48bf23c3-809a-548e-a7f9-4b4a688ba406', '97f4da18-f1b9-58ea-acee-46fc8e50be23', '69d016ee-de97-50cc-995a-957a5f983bc6', '94e52d26-5b63-5225-a8ec-1d28c6e0ee4b', 'fe013efc-23ff-547d-a11b-c24afeccf27d', 'f074c5c8-01d8-531c-a639-bec5cb5536a2', 'a1f43a69-ed2a-5f4c-88de-c5e1fe721db8', '22d86b61-d8d3-5b6d-8d62-410e86a2ed80', '2059fcf2-b1d6-552a-b089-00c2ac8dacdf', 'd27528fb-716f-585f-af57-3bbea51dc073', 'b2363548-b6b2-55d3-bc68-4afab9fb682d', 'bdc5d2a2-141c-54b6-87b3-02e881fe22e6', '39a190a4-3fcd-5b7b-bcf3-268667f0712c', 'acd81700-0692-525e-8c7f-d276a95941da', '07417c36-375b-5211-9c57-b17d1aa7b751', 'd4182f6c-a2a7-512b-b907-c9f1a212e413', '13ad4ea8-4040-5c40-8acd-d285ec6ad89e', 'fd9ee791-3e7f-5cc6-ae9a-d9434112b6a9', '6f7d8e34-981f-575a-9f14-13c8ff3912cb', '82f05f72-9793-5121-9116-4c39e4b6292e', 'e4e1af62-799f-5e3e-931d-2fb35648f491', 'fdfde6ad-cc78-55a1-a6c9-378880a87688', 'af1a2b70-05cc-5dea-8bfd-84c92e48d143', '46354e55-2d4b-5d7a-904f-07fc73778f72', 'd54c0041-1d54-58f0-bd1a-fe866e69d346', '5fd5be01-0adf-56b2-9c23-2b2f0bbbe5e5', '48337208-1f6a-58d7-a640-b157931e8b88', 'e0710a1c-ddf5-5b3f-a62c-c57a582c4961', 'b335a520-ae98-5cc5-b3e8-72cecd15e48e', '5d43497a-fd11-57de-8cef-b0d8e8bcc58c', '0261a9a1-e91d-561c-bfcc-2ff6886bf35f', '18ef6151-895e-54eb-aa38-3e0f065becdc', '1f16218f-45c5-50dd-bc5e-8e00b2fd4415', '6069fd73-45d8-56f4-be8a-c58200f0fab2', '8326f8dc-dec5-5906-b317-b41f9001ceb0', '02510a10-71d5-5a85-bf62-04402ab4e0ab', '35e267be-21b7-5ef0-b3fb-a0bde4eda187', 'db6cb78d-2f01-59dd-817a-1dcdfd0c5183', '4c1ad37f-baae-559c-8965-8002fdc14c26', '61450b5e-beb1-51a0-a271-8a8cac6f6eeb', 'cd045067-ea89-5e69-838c-d2cfd88ae830', 'd02ad5bd-1b7b-5489-8690-27ea1e03d345', 'd7441ffe-0126-5497-b66c-3a540244401c', 'a290cf9f-926f-52f9-97d7-35ca87853b61', '59f7918b-6e62-564e-ab9c-4fb58ddf505e', '5f716770-0287-5c29-9191-b0211616c7cc', '274ab3b1-e467-5583-92f3-16535c1e85e5', 'cfac46b0-fe05-562e-b5b0-774a1ab556c9', 'aeeb770c-4c15-5e52-b0a1-25ac599bdb74', 'd2e67e33-ad71-5482-bbec-4270367778f4', 'fc67c61a-b0ee-5e05-a9cf-7375b72c6a5b', '46d1784a-db78-5783-9a8f-5bac317b82ed', 'b6c97919-bcdc-5886-9fc0-f4f0c8ff106f', 'ae7aa3ee-d043-54ac-bf01-5d341733a4d8', '6f7a4267-2070-58ea-8244-a2f7eba34e95', '3f21dcf0-0101-571e-a00c-cea13b0f7414', '3e2febb7-2b01-5eab-923f-80f2a0473b6d', '5bae49ca-130e-516b-8a8a-5ec98e481cf3', '290ff040-c24f-56eb-84ad-f962e8c43518', '5b53211f-ae68-57ea-a9e2-1703acc4a29d', '0ff29ce2-88e5-542a-ac01-a3d172cce948', 'a4003abb-85d3-5076-a5a7-5deac86ed008', 'f4149348-3e79-5a88-bbb2-3043a79adb89', 'e5b9bc1f-fae0-51b8-bf8f-1b3d7f22aded', 'baa379ae-2022-5979-9c8d-26976394b590', '88898e77-58ee-53a5-8258-a01c13d0090a', '1e11a713-0ad1-5700-b4bf-94290ceee570', '3c9e8ea7-7164-5670-a90d-05b690fac7b6', 'e48a70fb-cdd0-5b68-8f92-8ee94f60c7d3', '022c3853-fe0a-52f7-a5ac-baedc251d485', 'eddbb1b5-9b28-51e8-8d32-464d2b424b0b', '35111da4-c1f6-5c47-92d6-abf1da1e41f5', 'd80f4f95-bed5-5107-a0ef-e9fab6b5f1e6', 'bf569014-eeac-5a24-aa41-ffc47b1142e5', '32c6731b-9f94-5a65-ba3e-3d404b489211', '6c04a9d9-f88b-52e8-9a40-3d9a60541ee1', '4b758dba-e34c-5346-914b-0640115d7266', '9d62d265-c183-513d-aeab-61eb5d67294b', '9ab4202e-dc67-5397-a3dc-83c428a28fa9', '662e53f7-735c-514d-b9bb-a6f5d3f4dd97', '097397e3-f28e-59b5-8fce-7917f3684ef2', '1697a810-1ea0-59f3-bdb1-650f92337450', 'b6d48fd1-10d2-54c5-9c09-87c09445c80b', 'fcea970a-b2f2-532b-8eb6-2dd1517e1a68', 'e8cdc574-3e3a-5796-ad6a-d1f5629f577c', 'e947138c-d108-51d1-a9f1-9318971f56b6', '7b5e7f02-7556-51bd-b621-e77dc4f0998a', '63d8e141-c222-543d-bb24-8598e4c07738', '92e5d9c6-1146-5df5-9bb1-928c031448a2', '9fad2be6-430a-59c1-9a97-f640401685c0', '8c84a417-4281-5b0b-84de-f491a8f8c51e', 'cbdca000-2b53-5c00-b30c-850c88642ca3', 'b1460eaa-5d5c-5561-9cfc-f038fc4e3779', 'be9b2d2f-7d61-5e2b-b055-2470a808d9ff', '20e87c2b-4a20-5ccf-b3c3-1f28bcb3742c', '44da0cce-a632-5007-8136-73696505228b', '07c47d92-6981-5c97-b6ba-328f83c1d5ed', '04dc679f-e7a7-5327-a965-8ad3b5ef1076', '0e3b5132-0147-57d3-b834-7ad7edb5b080', 'b9dfc13c-ebb0-52a0-b065-947a6f7255a8', '6dc4d2d8-30e0-55c2-9cb3-c6506272e08f', 'ad1a35e7-77ad-5380-95c8-276c137ca4c2', '817df0f3-994d-593d-89f4-3fd3ffde9299', '584dc01f-979a-51c6-b547-50ccb4dc4434', '582028d4-27fe-52e4-ad20-072c93bd7aaa', '24311e07-fbb7-59aa-b343-3a402bc182f6', 'c8df1e1c-3f15-545e-bf0f-6ffa6c8670df', '298050a5-e505-5f04-b29b-0cb01c04f2df', '5429a45c-543d-5c30-87b4-7dbaacf105b2', '4eddcd6b-740a-5a55-aa5c-e382696b9d52', 'a58f847e-feba-5095-836d-b63052bb054d', '2218752f-657c-5fc1-b9c1-46ab5f99b056', '5637a5ff-fa93-52c1-8612-67707971a16a', 'd1fa6c14-bf9e-5140-b857-d7801333423a', 'c9f7df10-822d-5d8a-bcf3-fe962b09b8a8', 'caa1fbac-b20d-5408-978b-329f8654c175', '499dd3e8-1fc7-5016-932c-d0931d13a0a8', '99d9fded-e695-5134-a076-baef0f217966', 'd51e6849-b703-5786-bd44-9a0e3bd82fbd', '3268b362-e563-5ac2-bcd4-e99a57efb743', 'e79842a9-75be-5192-ba1e-51f48ddceb6e', '4aea4da9-c8f1-58e1-abf7-91d9c55d20ab', '250acf66-4ecd-5919-a740-a7a5fa8b1913', 'ab3551e6-d1e3-5863-a599-30c32f589cf2', 'c91bcd69-98e4-5552-bd28-6f41a865d209', '14f7576f-2b79-58bf-a2f1-fff7a3e74a23', '36ec7d61-9631-5b47-8d5b-8723d950145b', '0a2471c4-464c-522d-928a-f6cd3c9f53d7', 'c19cfe80-f61d-5a87-af8b-934c05afc683', '2076a795-b582-5247-bb30-0b3914a9dbe0', 'e40379d5-2265-5c86-84e6-b2c21bb53b59', 'fca87733-2061-5da1-b8c0-dad43a74dc0a', 'e74434d2-d686-5970-8257-014632eeba2e', 'f19414b0-88ac-52e8-a4e1-d4de032d8137', 'e9cb7eca-7c37-528f-8cf4-579374c15846', 'a034344a-d73c-53dc-89ed-5edae545ee8a', 'bcca2e39-3ae4-504d-9fa8-89535302e2e7', 'ce2d6d96-f954-5a03-8d1e-652d4cc44fc4', '6df67b64-ec9f-5016-b8a1-3fe6e4898014', 'bcac7bc7-7a80-5dfb-bb73-c00e8624cc75', '7e072082-2a4a-536d-a8f6-59d6e3be47d0', '7b16a2fa-63ba-54cf-8328-c540147a5bfc', 'a5169f77-e4b9-5ae9-bb2c-bef688ef9538', '92287f35-9cda-503e-89f9-f96f76f3873f', '523916c2-9df9-5704-af04-a8c2e45144d5', '9c63d490-08e8-5864-b738-e29191d6f681', 'e50f3f7b-0369-52fd-88c5-41f174a0695c', '7e96cda4-0dab-5337-9394-4b1b86cf4b70', '498027d9-c500-57a2-835b-1c28ce6aecea', '389a9d29-4c25-5fef-8890-961dec2969dc', '73dc8cab-995b-51ff-b86b-1c2e76798477', '212cb3b7-b1d1-5945-9c67-99f0247e770f', '14d7c5ae-5385-5998-acb3-791cd477ed42', 'b9e51165-8a6c-56e9-a8ab-ee3985961695', 'e9f3ad08-543c-5a92-a2da-28b4fd13f050', 'ccd9b02f-6ff3-5d56-824c-0fb279c0897f', '8391b212-b280-5b72-952d-d575e50b35ab', '8cb25dc2-5cdd-5233-b6ba-b0beb4dbc039', 'cf7ccfc9-9098-5e07-837f-809200fac0df', '0cc60143-9d10-5ab1-9ea4-b93674066783', '9fc06fe5-61b8-57d6-bcd9-ccdb4953a1ac', 'f711a596-febd-5d1c-87f3-912106770ebd', 'c7fa441b-becb-572d-90d3-a9993fa25509', '663e1c32-988a-50af-9ff4-943819c24a38', '2861ddac-114e-595c-b144-b2307ddbad9a', '7a6b6535-a66c-5d42-b13f-ed8fdd610111', '2e00c180-1a46-5f59-b857-f23c3c38a9dc', 'f138a932-d08e-54a9-ab59-9185225251a7', '291187d2-1d1d-5ecf-98f3-628e97882556', 'acbe89eb-2314-55dc-a88f-1246e020c522', '7d52261a-7d0a-59c0-9230-fc858d5dd057', '6ea4178b-f738-5e6a-ba3e-4753d9c1d64d', '97ba2e96-a6c9-5f2f-a2a8-ac8d41ae662c', '66bc69cc-3177-54bd-8c72-eb2ebbfa3055', '345d9217-887e-55ef-b9b5-a92992f2a27a', 'a5aef042-5730-5c52-a87d-471b2313de59', '462041d4-a011-5b7b-9915-6c8f61f5beb9', '1bfd35c4-0c1e-5643-9343-27eb4ebefe16', 'fc07256e-473b-5073-a6cf-5355e50e1f3d', '5dc6960b-97c3-54c3-9572-2471a439b62e', '2294716e-81e4-5ae1-8414-8e2f26e27ea1', '9c6ee216-7af4-57fa-a4ec-facbece3f8e7', 'e7a45a93-5f75-5663-b122-0999cb8677ab', 'bb836141-af4a-5272-b725-7121a8c6fcd3', 'ba3fb009-2cee-5867-b1f1-e3955a6151e7', 'a52559d2-2e99-5247-a541-fddf12b2adf9', 'efdf3643-9e05-5c38-9971-e56a38c990cf', '5e0aa51f-cd3f-5326-a618-d97a4ee8095f', '617293a1-3b82-5634-964d-f371ec0b8277', '85331ca4-987b-5914-bd7a-868b73d830f3', '5f3c7e26-fcd1-59e1-b99d-207086e21b55', 'df7d6e19-8c0e-5209-99bd-3849e1823141', '6aec1607-dc0d-512e-8319-105dcc4e2213', '87238d96-c79a-5488-b0dc-de8aebb4b70c', 'd1bb11e3-b139-52bb-816e-e0679ff41b51', '8d91ab71-aa7f-5308-86c0-221ac2103f52', '7e201495-8285-5b9a-aebf-9bee9f4c1e00', '9dac95aa-0222-568b-b161-1631cbfae7e9', 'df17eb68-be02-552b-8b85-3d1bbb38557e', 'a389181a-4689-57d4-a41f-53d11f70cd20');
DELETE FROM public.chapters c WHERE c.subject_id = 'francais-a1' AND c.id NOT IN ('415318c7-e432-5045-bb45-268b28d6e377', 'f9f6566c-42f5-5eb6-ac69-4e7d00503ce2', 'e6d7c80a-52bd-5273-a275-3c8a18a54b01', '3505bbef-6146-594f-9991-1a08b85ac866', 'a686a8b9-c332-5edc-b561-909cc0ccb468', 'e9ff7be1-b5bf-5d73-b593-0f711048aef0') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('415318c7-e432-5045-bb45-268b28d6e377', 'francais-a1', 'Le présent : être et avoir', 'Maîtrise les deux verbes les plus utiles du français au présent — être et avoir — pour dire qui tu es, comment tu vas, ce que tu possèdes et quel âge tu as, avec la négation ne… pas et les pièges d''homophones (es/est/et, a/à, on/ont, son/sont).', '# ⚔️ Être et avoir au présent — Tes deux premières armes

> 💡 «Maîtrise être et avoir, et tu peux déjà te présenter, dire ton âge et parler de tout ce que tu possèdes.»

## 🏰 Pourquoi ces deux verbes ouvrent toutes les portes

**Être** et **avoir** sont les deux verbes les plus utilisés du français. Ils servent partout : à se présenter, à décrire, à dire son âge, à exprimer la possession. Ils sont aussi _irréguliers_ — on les apprend par cœur, et ensuite tout devient plus facile.

_Je **suis** élève. J''**ai** un cartable. Tu **es** mon ami._

## ⚡ Le verbe ÊTRE au présent

Apprends ce tableau par cœur : c''est la base de toutes tes phrases.

| Personne       | ÊTRE   | Exemple                       |
| -------------- | ------ | ----------------------------- |
| je             | suis   | _Je **suis** content._        |
| tu             | es     | _Tu **es** prêt._             |
| il / elle / on | est    | _Elle **est** médecin._       |
| nous           | sommes | _Nous **sommes** une équipe._ |
| vous           | êtes   | _Vous **êtes** gentils._      |
| ils / elles    | sont   | _Ils **sont** à l''école._     |

On utilise **être** pour l''**identité**, l''**état**, la **nationalité** et la **profession** :
_Je **suis** tunisien. Elle **est** fatiguée. Ils **sont** professeurs._

## 🔮 Le verbe AVOIR au présent

| Personne       | AVOIR | Exemple                       |
| -------------- | ----- | ----------------------------- |
| j''             | ai    | _J''**ai** un livre._          |
| tu             | as    | _Tu **as** raison._           |
| il / elle / on | a     | _Il **a** un chien._          |
| nous           | avons | _Nous **avons** faim._        |
| vous           | avez  | _Vous **avez** deux enfants._ |
| ils / elles    | ont   | _Elles **ont** des amis._     |

> 🗡️ Astuce : devant une voyelle, **je** devient **j''** → _j''ai_, jamais «je ai».

## 🎂 Le piège de l''âge : avoir … ans

C''est LE point clé du niveau A1 : en français, on **a** un âge, on ne l''**est** pas.

_J''**ai** 12 ans._ ✓
_~~Je suis 12 ans.~~_ ✗

On dit aussi **avoir** faim, soif, peur, chaud, froid, raison :
_Tu **as** soif ? Nous **avons** froid._

## 🛡️ La négation : ne … pas

Pour dire le contraire, on encadre le verbe avec **ne … pas**.

_Je **ne suis pas** prêt._
_Il **n''est pas** là._ (devant une voyelle, _ne_ → _n''_)
_Je **n''ai pas** de stylo._ (après une négation, _un / une / des_ → **de**)

> 🗡️ Astuce : _n''ai pas **un** stylo_ → _n''ai pas **de** stylo_.

## 🧪 Les homophones : le grand piège

Ces mots se prononcent pareil mais s''écrivent différemment. Choisis selon le sens.

| On entend | Formes possibles  | Exemple                                          |
| --------- | ----------------- | ------------------------------------------------ |
| [e]       | **es / est / et** | _Tu **es** là. Il **est** parti **et** content._ |
| [a]       | **a / à**         | _Il **a** faim. Il va **à** Tunis._              |
| [ɔ̃]       | **on / ont**      | _**On** part. Ils **ont** gagné._                |
| [sɔ̃]      | **son / sont**    | _**Son** sac. Ils **sont** prêts._               |

> ⚠️ Piège : **es / est** = verbe être ; **et** = «aussi». **a** = verbe avoir ; **à** = direction. **ont** = verbe avoir ; **on** = «nous». **sont** = verbe être ; **son** = «le sien».

> 🏆 Première porte franchie ! Avec **être**, **avoir**, l''âge et la négation, tu peux déjà te présenter et décrire ton monde. Prochaine étape : le présent des verbes en **-er** pour parler de tes habitudes.', '# 📜 Résumé : Être et avoir au présent

- **ÊTRE** — _je suis, tu es, il/elle/on est, nous sommes, vous êtes, ils/elles sont_. Sert à l''identité, l''état, la nationalité, la profession.
- **AVOIR** — _j''ai, tu as, il/elle/on a, nous avons, vous avez, ils/elles ont_. Sert à la possession.
- **L''âge** — on dit _avoir … ans_ : _J''ai 12 ans._ Jamais «je suis 12 ans».
- **Expressions avec avoir** — _avoir faim, soif, peur, chaud, froid, raison._
- **Négation** — on encadre le verbe : _ne … pas_ (_je ne suis pas_, _je n''ai pas_). Après la négation, _un/une/des_ → _de_.
- **Homophones [e]** — _es / est_ = être ; _et_ = «aussi».
- **Homophones [a]** — _a_ = avoir ; _à_ = direction.
- **Homophones** — _on_ (= nous) ≠ _ont_ (avoir) ; _son_ (le sien) ≠ _sont_ (être).', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('f9f6566c-42f5-5eb6-ac69-4e7d00503ce2', 'francais-a1', 'Le présent des verbes du 1er groupe (-ER)', 'Conjugue au présent les verbes du 1er groupe (parler, aimer, habiter, travailler) : les terminaisons -e, -es, -e, -ons, -ez, -ent, et surtout le grand piège de l''A1 — les terminaisons muettes -e, -es, -ent qui se prononcent pareil mais s''écrivent différemment. Pour parler de tes habitudes, de tes goûts et des vérités générales.', '# ⚔️ Le présent des verbes en -ER — La porte d''entrée de la conjugaison

> 💡 «Maîtrise une seule terminaison et tu ouvres la porte de neuf verbes français sur dix.»

## 🏰 Pourquoi ce chapitre est ta meilleure arme

Les verbes du **1er groupe** (ceux qui finissent par **-er** à l''infinitif : _parler_, _aimer_, _habiter_, _travailler_, _regarder_, _jouer_) forment la **plus grande famille** du français. Si tu sais conjuguer **un seul** de ces verbes, tu sais les conjuguer **presque tous** : ils suivent exactement le même modèle.

On les utilise pour parler de trois choses essentielles : tes **habitudes** (_Je travaille le matin_), tes **goûts** (_J''aime le café_) et les **vérités générales** (_La Terre tourne_).

## ⚡ Le modèle unique : -e, -es, -e, -ons, -ez, -ent

Pour conjuguer, on enlève le **-er** de l''infinitif (on garde le **radical**) et on ajoute la bonne terminaison.

| Pronom     | Terminaison | Exemple : _parler_ |
| ---------- | ----------- | ------------------ |
| je / j''    | **-e**      | je parl**e**       |
| tu         | **-es**     | tu parl**es**      |
| il/elle/on | **-e**      | elle parl**e**     |
| nous       | **-ons**    | nous parl**ons**   |
| vous       | **-ez**     | vous parl**ez**    |
| ils/elles  | **-ent**    | ils parl**ent**    |

_J''**aime** la musique. Tu **habites** à Tunis. Nous **travaillons** ensemble. Vous **jouez** bien._

> 🗡️ Astuce : seul le **radical** change d''un verbe à l''autre. Les six terminaisons, elles, ne changent **jamais** dans le 1er groupe.

## 🛡️ LE grand piège : les terminaisons muettes

Voici le cœur du chapitre. Trois terminaisons se **prononcent exactement pareil** mais s''**écrivent différemment** : **-e**, **-es** et **-ent**. À l''oreille, _je parle_, _tu parles_, _elle parle_ et _ils parlent_ sonnent **identiques** ! Mais à l''écrit, c''est le **pronom** qui décide de la terminaison.

| Tu entends… | Tu écris…       | Pourquoi                        |
| ----------- | --------------- | ------------------------------- |
| « parl »    | je parl**e**    | _je_ → toujours **-e**          |
| « parl »    | tu parl**es**   | _tu_ → toujours **-es**         |
| « parl »    | elle parl**e**  | _il/elle/on_ → toujours **-e**  |
| « parl »    | ils parl**ent** | _ils/elles_ → toujours **-ent** |

_Tu **parles** anglais_ (jamais ~~tu parle~~). _Ils **travaillent**_ (jamais ~~ils travaille~~). _Elle **aime**_ (jamais ~~elle aimes~~).

> ⚠️ Piège classique : ne te fie **jamais** à ce que tu entends. Le **-s** de _tu_ et le **-nt** de _ils/elles_ sont muets, mais ils sont **obligatoires** à l''écrit.

## 🔮 Reconnaître le bon pronom

La terminaison dépend du **sujet**. Repère d''abord qui fait l''action :

- **un seul** nom singulier = _il_ ou _elle_ → terminaison **-e** : _Le chat **dort**… non, Marie **chante**._
- **plusieurs** noms ou un pluriel = _ils_ ou _elles_ → terminaison **-ent** : _Les enfants **jouent**. Mes amis **travaillent**._

_Mon frère **regarde** la télé_ (= il → -e). _Mes frères **regardent** la télé_ (= ils → -ent).

> 🗡️ Le test infaillible : remplace le sujet par un pronom. Si c''est _ils_ ou _elles_, tu écris **-ent**, même si tu ne l''entends pas.

## 🔧 Deux petits ajustements d''orthographe

Quelques verbes gardent le bon **son** en adaptant le radical à la forme **nous** :

- Les verbes en **-ger** prennent un **e** : _nous **mangeons**_, _nous **voyageons**_ (pour garder le son « j »).
- Les verbes en **-cer** prennent une **cédille** : _nous **commençons**_, _nous **avançons**_ (pour garder le son « s »).

_Nous **mangeons** à midi. Nous **commençons** la leçon._ Le reste de la conjugaison ne change pas.

> ⚠️ Ces deux cas concernent **seulement** la personne _nous_. Partout ailleurs, le modèle normal s''applique.

## 🌟 À quoi ça sert vraiment

Avec ce seul temps, tu peux déjà te présenter et décrire ta vie :

_J''**habite** à Tunis. Je **travaille** dans un café. J''**aime** le sport. Le week-end, nous **regardons** un film. Mes parents **adorent** voyager._

> 🏆 Porte franchie ! Tu sais maintenant conjuguer la plus grande famille de verbes français et tu connais son piège n°1 : les terminaisons muettes. Prochaine étape : **les articles et le genre des noms** — _le_, _la_, _un_, _une_, et comment savoir si un mot est masculin ou féminin.', '# 📜 Résumé : Le présent des verbes en -ER

- **La famille** — les verbes en **-er** (parler, aimer, habiter, jouer) sont le 1er groupe : tous se conjuguent pareil.
- **Le modèle** — on enlève **-er** et on ajoute : je **-e**, tu **-es**, il/elle/on **-e**, nous **-ons**, vous **-ez**, ils/elles **-ent**.
- **Exemple** — _je parle, tu parles, elle parle, nous parlons, vous parlez, ils parlent_.
- **⚠️ Le grand piège** — **-e**, **-es** et **-ent** se prononcent **pareil** mais s''écrivent **différemment** : c''est le pronom qui décide.
- **À l''écrit** — _tu parles_ (pas ~~tu parle~~), _ils parlent_ (pas ~~ils parle~~), _elle aime_ (pas ~~elle aimes~~).
- **Le bon pronom** — un sujet singulier = il/elle → **-e** ; un sujet pluriel = ils/elles → **-ent** (même si c''est muet).
- **Ajustements** — _nous mangeons_ (-ger → e), _nous commençons_ (-cer → ç), seulement à la personne _nous_.
- **Usage** — habitudes, goûts et vérités générales : _J''habite à Tunis. Nous aimons le café._', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('e6d7c80a-52bd-5273-a275-3c8a18a54b01', 'francais-a1', 'Les articles, le genre et le nombre du nom', 'Choisis le bon article défini (le, la, l'', les) et indéfini (un, une, des), accorde l''article avec le genre du nom (masculin ou féminin), et forme le pluriel régulier en -s ainsi que les pluriels irréguliers en -eaux, -aux et -eux.', '# ⚔️ Les articles, le genre et le nombre — Nomme chaque trésor

> 💡 «Quand tu sais dire _un_ objet, _le_ bon objet, et _des_ objets, le monde entier devient nommable.»

## 🏰 Le petit mot devant chaque nom

En français, presque chaque nom porte un petit mot devant lui : un **article**. Il y a deux familles. Les articles **définis** — **le, la, l'', les** — désignent une chose précise, déjà connue. Les articles **indéfinis** — **un, une, des** — désignent une chose parmi d''autres, mentionnée pour la première fois.

_Je vois **un** chien. **Le** chien est gentil._ (d''abord **un**, puis **le** car on le connaît maintenant)

| Nombre / genre          | Défini                   | Indéfini       |
| ----------------------- | ------------------------ | -------------- |
| masculin singulier      | **le** livre             | **un** livre   |
| féminin singulier       | **la** table             | **une** table  |
| devant voyelle / h muet | **l''** ami, **l''** école | **un**/**une** |
| pluriel (m. et f.)      | **les** livres           | **des** livres |

## ⚡ Quand utiliser l'' (élision)

Devant un nom qui commence par une **voyelle** (a, e, i, o, u) ou un **h muet**, on ne dit pas _le_ ou _la_ : on les remplace par **l''**. C''est l''**élision**.

_**l''**ami_ (et non _~~le ami~~_), _**l''**école_ (et non _~~la école~~_), _**l''**homme_ (h muet).

> 🗡️ Astuce : l''élision concerne **le** et **la**, jamais l''article indéfini. On garde _**un** ami_, _**une** école_ — seuls _le_/_la_ deviennent _l''_.

## 🛡️ Le genre du nom : masculin ou féminin

Chaque nom français est soit **masculin**, soit **féminin** — et l''article doit **s''accorder** avec ce genre. On dit _**un** livre_, _**le** soleil_ (masculin) mais _**une** table_, _**la** lune_ (féminin).

| Genre    | Article indéfini | Article défini | Exemples                       |
| -------- | ---------------- | -------------- | ------------------------------ |
| masculin | **un**           | **le**         | un livre, le soleil, un garçon |
| féminin  | **une**          | **la**         | une table, la lune, une fille  |

> ⚠️ Piège : le genre n''est **pas prévisible** la plupart du temps. _Table_ et _lune_ sont féminins, _livre_ et _soleil_ masculins, sans logique évidente. Il faut **apprendre le genre avec le nom** : note toujours _une_ table, _un_ livre.

## 🔮 Le nombre : former le pluriel régulier

Pour parler de **plusieurs** choses, on met le nom au **pluriel**. La règle générale est simple : on **ajoute -s** au nom (le -s ne se prononce pas, mais il s''écrit). L''article aussi change : _le/la/l''_ deviennent **les**, _un/une_ deviennent **des**.

_un chat → **des** chats_ · _le livre → **les** livres_ · _la table → **les** tables_

## 🧮 Les pluriels irréguliers — le rulebook

Certains noms ne suivent pas la règle du -s. Apprends ces trois familles et tu ne te tromperas presque jamais.

| Terminaison au singulier | Règle       | Exemples                                           |
| ------------------------ | ----------- | -------------------------------------------------- |
| **-eau**                 | → **-eaux** | un gâteau → des gâteaux, un château → des châteaux |
| **-al**                  | → **-aux**  | un animal → des animaux, un journal → des journaux |
| **-eu**                  | → **-eux**  | un jeu → des jeux, un cheveu → des cheveux         |

> 🗡️ Repère la terminaison du **singulier** : un nom en _-eau_ prend _-eaux_ (jamais _~~gâteaus~~_), un nom en _-al_ prend _-aux_ (jamais _~~animals~~_), un nom en _-eu_ prend _-eux_ (jamais _~~jeus~~_).

## 🧪 Tout assembler — article + genre + nombre

Pour écrire un groupe nominal correct, tu combines les trois choix : l''**article** (défini ou indéfini), le **genre** du nom, et le **nombre** (singulier ou pluriel).

_J''achète **une** pomme._ (indéfini, féminin, singulier)
_**Les** animaux sont au zoo._ (défini, pluriel)
_**L''**école est fermée._ (élision devant voyelle, féminin, singulier)

> ⚠️ Piège : ne mélange pas le genre. On dit _**la** table_ (jamais _~~le table~~_) et _**un** ami_ (jamais _~~une ami~~_, sauf au féminin _une amie_). L''article trahit immédiatement une erreur de genre.

> 🏆 Porte franchie ! Tu sais maintenant nommer une chose, la chose, et plusieurs choses — et accorder l''article au genre et au nombre. Prochaine étape : le **vocabulaire du quotidien**, pour remplir ces structures de vrais mots.', '# 📜 Résumé : Les articles, le genre et le nombre du nom

- **Deux familles d''articles** — définis _le, la, l'', les_ (chose précise, connue) et indéfinis _un, une, des_ (chose parmi d''autres, première mention).
- **L''élision (l'')** — devant une voyelle ou un h muet, _le_ et _la_ deviennent _l''_ : _l''ami, l''école, l''homme_ (mais _un_ ami, _une_ école).
- **Le genre** — chaque nom est masculin (_un livre, le soleil_) ou féminin (_une table, la lune_), et l''article s''accorde avec lui.
- **Le genre n''est pas prévisible** — il faut l''apprendre avec le nom : note toujours _une_ table, _un_ livre.
- **Le pluriel régulier** — on ajoute _-s_ : _un chat → des chats_, _le livre → les livres_ ; _le/la/l''_ → _les_, _un/une_ → _des_.
- **Noms en -eau → -eaux** — _un gâteau → des gâteaux, un château → des châteaux_.
- **Noms en -al → -aux** — _un animal → des animaux, un journal → des journaux_.
- **Noms en -eu → -eux** — _un jeu → des jeux, un cheveu → des cheveux_.
- **Accord total** — un groupe nominal correct combine l''article, le genre et le nombre : _l''école, les animaux, une pomme_.', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('3505bbef-6146-594f-9991-1a08b85ac866', 'francais-a1', 'Vocabulaire du quotidien : se présenter', 'Acquiers les tout premiers mots du français : saluer et être poli, te présenter (nom, âge, ville, nationalité, profession), compter de 0 à 69, nommer les jours et les mois, parler de ta famille et reconnaître les couleurs de base. Niveau débutant (CECRL A1), aligné sur le DELF A1.', '# 🗺️ Vocabulaire du quotidien — Tes premiers mots de héros

> 💡 «La grammaire est la carte, mais les mots sont le trésor — collecte-les et tu peux déjà parler.»

## 👋 Saluer et être poli

Avant de combattre, un héros salue. Les **salutations** ouvrent toutes les portes.

On dit **bonjour** le matin et la journée, **bonsoir** le soir, et **salut** entre amis (familier). Pour partir, on dit **au revoir** (ou **salut**, familier).

La **politesse** est ta première armure : **merci** (pour remercier), **s''il vous plaît** (pour demander poliment), **pardon** et **excusez-moi** (pour s''excuser ou attirer l''attention).

| Situation             | Formule                  |
| --------------------- | ------------------------ |
| Le matin / la journée | **Bonjour**              |
| Le soir               | **Bonsoir**              |
| Entre amis (familier) | **Salut**                |
| Pour partir           | **Au revoir**            |
| Pour remercier        | **Merci**                |
| Pour demander         | **S''il vous plaît**      |
| Pour s''excuser        | **Pardon / Excusez-moi** |

> ⚠️ Piège classique : **bonsoir** se dit le soir, pas le matin. Et **salut** sert à la fois pour dire bonjour ET au revoir entre amis.

## 🪪 Se présenter

Pour te présenter, retiens ces formules de base :

_« Je **m''appelle** Yahia. » — pour donner ton nom._
_« J''**habite à** Tunis. » — pour dire ta ville._
_« J''**ai** douze **ans**. » — pour donner ton âge (toujours avec le verbe avoir + ans)._
_« Je **suis** tunisien. » / « Je **suis** élève. » — pour ta nationalité ou ta profession._

Pour demander à quelqu''un : **« Comment tu t''appelles ? »** (familier) ou **« Comment vous appelez-vous ? »** (poli).

> 🗡️ Astuce : en français, l''âge se dit avec **avoir**, pas avec être : on dit _j''ai dix ans_, jamais « je suis dix ans ».

## 🔢 Les nombres de 0 à 69

Compte avec les **nombres**. De 0 à 16, chaque mot est unique :

_**zéro, un, deux, trois, quatre, cinq, six, sept, huit, neuf, dix, onze, douze, treize, quatorze, quinze, seize**._

De 17 à 19 : **dix-sept, dix-huit, dix-neuf**. Ensuite, les **dizaines** :

| Dizaine | Mot           |
| ------- | ------------- |
| 20      | **vingt**     |
| 30      | **trente**    |
| 40      | **quarante**  |
| 50      | **cinquante** |
| 60      | **soixante**  |

On combine : _vingt et un (21), vingt-deux (22), trente-cinq (35), soixante-neuf (69)._

> ⚠️ Attention à l''orthographe : on écrit **quarante** (un seul r) et **cinquante** — pas « quarente » ni « cinquente ».

## 📅 Les jours et les mois

Les sept **jours** de la semaine : _**lundi, mardi, mercredi, jeudi, vendredi, samedi, dimanche**._

Les douze **mois** de l''année : _**janvier, février, mars, avril, mai, juin, juillet, août, septembre, octobre, novembre, décembre**._

> 🗡️ Règle utile : en français, les jours et les mois s''écrivent en **minuscule** — _lundi_, pas « Lundi » ; _janvier_, pas « Janvier ».

## 👪 La famille

Voici le premier cercle de tout héros, la **famille** :

| Femme          | Homme          | Ensemble       |
| -------------- | -------------- | -------------- |
| **mère**       | **père**       | **parents**    |
| **sœur**       | **frère**      | —              |
| **fille**      | **fils**       | enfants        |
| **grand-mère** | **grand-père** | grands-parents |

_Mon **père** et ma **mère** sont mes **parents**. J''ai une **sœur** et un **frère**._

> ⚠️ Ne confonds pas : la **fille** (femme) et le **fils** (homme) sont les enfants ; mais « une fille » veut aussi dire une jeune personne de sexe féminin.

## 🎨 Les couleurs de base

Les **couleurs** peignent ton monde : _**rouge, bleu, vert, jaune, noir, blanc, orange, gris, marron**_ (et **rose**).

_Le ciel est **bleu**. L''herbe est **verte**. La neige est **blanche**._

> 🏆 Premier trésor de mots collecté ! Avec les salutations, ta présentation, les nombres, les jours, la famille et les couleurs, tu peux déjà nommer le monde autour de toi. Prochaine étape : transformer ces mots en **questions** pour demander qui, quoi et où.', '# 📜 Résumé : Vocabulaire du quotidien

- **Saluer & politesse** — _bonjour_ (journée), _bonsoir_ (soir), _salut_ (familier, bonjour et au revoir), _au revoir_ ; _merci_, _s''il vous plaît_, _pardon / excusez-moi_.
- **Se présenter** — _Je m''appelle…_, _J''habite à…_, _J''ai … ans_ (avec **avoir**), _Je suis… (nationalité / profession)_ ; demander : _Comment tu t''appelles ? / Comment vous appelez-vous ?_
- **Nombres 0–69** — _zéro… seize_ uniques, puis _dix-sept… dix-neuf_ ; dizaines : **vingt, trente, quarante, cinquante, soixante** ; on combine : _vingt et un, trente-cinq, soixante-neuf_.
- **Jours** — _lundi, mardi, mercredi, jeudi, vendredi, samedi, dimanche_ (en minuscule).
- **Mois** — _janvier, février, mars… décembre_ (en minuscule).
- **Famille** — _père / mère → parents_, _frère / sœur_, _fils / fille_, _grand-père / grand-mère_.
- **Couleurs** — _rouge, bleu, vert, jaune, noir, blanc, orange, gris, marron, rose_.
- ⚠️ Pièges : l''âge se dit avec **avoir** (_j''ai dix ans_) ; jours et mois en **minuscule** ; on écrit **quarante** et **cinquante**.', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('a686a8b9-c332-5edc-b561-909cc0ccb468', 'francais-a1', 'Poser une question et la négation', 'Pose une question dans les trois registres (intonation, est-ce que, inversion), choisis le bon mot interrogatif (qui, où, quand, comment, combien, pourquoi, quel/quelle accordé) et maîtrise la négation ne … pas autour du verbe, avec le passage de l''article à « de ». Niveau débutant (CECRL A1), aligné sur le DELF A1.', '# ⚔️ Poser une question et la négation — La dernière porte de l''A1

> 💡 «Le héros qui sait poser la bonne question tient déjà la moitié de la réponse.»

## 🏰 Pourquoi questionner et nier sont tes armes décisives

Jusqu''ici, tu apprenais à **affirmer** des faits. Maintenant, tu apprends deux pouvoirs jumeaux : **demander** une information et **nier** une affirmation. Ce sont les outils qui ouvrent toutes les conversations : un nom, un lieu, une heure, une raison… et la capacité de dire non. C''est la dernière compétence avant le Donjon.

_**Où** habites-tu ? **Comment** vas-tu ? Je **ne** parle **pas** anglais._

## ⚡ Les trois registres de la question

En français, on pose la même question de trois manières, du plus familier au plus soutenu. Apprends à les reconnaître toutes les trois.

| Registre | Forme                         | Exemple                     |
| -------- | ----------------------------- | --------------------------- |
| familier | intonation (ordre normal)     | _**Tu viens ?**_            |
| courant  | **est-ce que** + ordre normal | _**Est-ce que** tu viens ?_ |
| soutenu  | **inversion** verbe-sujet     | _**Viens-tu ?**_            |

_**Tu habites** où ?_ (familier) · _**Où est-ce que** tu habites ?_ (courant) · _**Où habites-tu ?**_ (soutenu).

> 🗡️ Astuce : avec **est-ce que**, tu gardes l''ordre normal (sujet + verbe), tu ajoutes juste « est-ce que ». C''est la forme la plus sûre quand tu débutes.

## 🔮 L''inversion : verbe avant le sujet

Dans le registre soutenu, on **inverse** le verbe et le pronom sujet, reliés par un trait d''union : _**As-tu** un stylo ?_ · _**Êtes-vous** prêts ?_ · _**Comment allez-vous ?**_

> ⚠️ Piège classique : l''inversion met le **verbe avant le pronom** avec un trait d''union — _**Viens-tu ?**_, jamais « ~~Tu viens-tu ?~~ » ni « ~~Viens tu ?~~ » sans trait d''union. Et avec « est-ce que », pas d''inversion : on dit _Est-ce que tu viens ?_, jamais « ~~Est-ce que viens-tu ?~~ ».

## 🧭 Les mots interrogatifs (ta liste de sorts)

Chaque mot interrogatif demande un type de réponse précis. Apprends ce que chacun **attend**.

| Mot interrogatif    | Demande      | Exemple                                           |
| ------------------- | ------------ | ------------------------------------------------- |
| qui                 | une personne | _**Qui** est là ?_                                |
| que / qu''est-ce que | une chose    | _**Que** veux-tu ? / **Qu''est-ce que** tu veux ?_ |
| où                  | un lieu      | _**Où** habites-tu ?_                             |
| quand               | un moment    | _**Quand** arrives-tu ?_                          |
| comment             | une manière  | _**Comment** vas-tu ?_                            |
| combien             | une quantité | _**Combien** ça coûte ?_                          |
| pourquoi            | une raison   | _**Pourquoi** es-tu triste ?_                     |

## 🛡️ « quel » s''accorde avec le nom

L''adjectif interrogatif **quel** est spécial : il **s''accorde** en genre et en nombre avec le nom qui suit.

| Forme   | Genre / nombre     | Exemple                              |
| ------- | ------------------ | ------------------------------------ |
| quel    | masculin singulier | _**Quel** âge as-tu ?_               |
| quelle  | féminin singulier  | _**Quelle** heure est-il ?_          |
| quels   | masculin pluriel   | _**Quels** livres aimes-tu ?_        |
| quelles | féminin pluriel    | _**Quelles** couleurs préfères-tu ?_ |

> 🗡️ Astuce : « heure » est féminin → _**Quelle** heure_, jamais « ~~Quel heure~~ ». Regarde toujours le nom pour choisir la bonne terminaison.

## 🧪 La négation : ne … pas encadre le verbe

Pour dire non, on **encadre le verbe** par deux mots : **ne** avant, **pas** après.

_Je **ne** parle **pas**. · Elle **ne** vient **pas**. · Nous **ne** sommes **pas** prêts._

Devant une voyelle ou un h muet, **ne** devient **n''** : _Elle **n''**est **pas** là. · Je **n''**ai **pas** faim. · Il **n''**habite **pas** ici._

> ⚠️ Piège : « ne … pas » entoure **le verbe conjugué**. On dit _Je **ne** mange **pas** de pain_, jamais « ~~Je mange ne pas~~ » ni « ~~Je ne pas mange~~ ». Et n''oublie pas le **n''** devant une voyelle : _Il **n''**aime **pas**_, pas « ~~Il ne aime pas~~ ».

## 🔮 Après la négation : « de » remplace l''article

Après une phrase négative, l''article indéfini (un, une, des) devient souvent **de** (ou **d''** devant une voyelle).

_J''ai **une** voiture. → Je **n''**ai **pas de** voiture._
_Il mange **du** pain. → Il **ne** mange **pas de** pain._
_Elle a **des** amis ici. → Elle **n''**a **pas d''**amis ici._

> 🗡️ Astuce : à la forme négative, ne dis pas « pas une voiture » mais « **pas de** voiture ». C''est l''une des marques de fabrique du français.

> 🏆 Dernière porte A1 franchie ! Tu peux maintenant **demander** tout — un nom, un lieu, une heure, une raison — et **nier** correctement avec ne … pas. Ton entraînement A1 est complet. Le **Donjon** t''attend, héros : une longue épreuve qui mêle toutes les compétences gagnées. Entre.', '# 📜 Résumé : Poser une question et la négation

- **Trois registres de question** — intonation (_Tu viens ?_), est-ce que (_Est-ce que tu viens ?_), inversion (_Viens-tu ?_).
- **L''inversion** — verbe avant le pronom, avec trait d''union : _As-tu un stylo ? Comment allez-vous ?_ ; jamais d''inversion après « est-ce que ».
- **Mots interrogatifs** — _qui_ (personne), _que / qu''est-ce que_ (chose), _où_ (lieu), _quand_ (moment), _comment_ (manière), _combien_ (quantité), _pourquoi_ (raison).
- **« quel » s''accorde** avec le nom : _quel âge, quelle heure, quels livres, quelles couleurs_.
- **La négation ne … pas** encadre le verbe conjugué : _Je ne parle pas. Elle ne vient pas._
- **n'' devant voyelle ou h muet** : _Elle n''est pas là. Je n''ai pas faim._
- **Après la négation, « de »** remplace un/une/des : _Je n''ai pas de voiture. Il ne mange pas de pain._
- ⚠️ Pièges : ordre des mots dans l''inversion, oubli du trait d''union, « ne » mal placé, « ne » non élidé devant voyelle, « quel » mal accordé.', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('e9ff7be1-b5bf-5d73-b593-0f711048aef0', 'francais-a1', 'Compréhension écrite : lire un texte simple', 'Apprends à lire et à comprendre de courts textes du quotidien en français : cartes postales, SMS, courriels, petites annonces, menus, horaires et affichettes. Tu vas repérer l''idée principale, trouver un détail précis (un prix, une heure, un jour, un lieu, un nom) et deviner le sens d''un mot grâce au contexte. Niveau débutant (CECRL A1), aligné sur l''épreuve de compréhension écrite du DELF A1.', '# 📖 Compréhension écrite : lire un texte simple

> 💡 «Tu n''as pas besoin de comprendre tous les mots pour comprendre le message. Cherche les bons indices, et le texte te livre son secret.»

## 🏰 Quels textes vas-tu lire au niveau A1 ?

Au niveau A1, tu lis des textes courts et utiles de la vie de tous les jours :

| Type de texte           | Ce que c''est                   | Exemple                      |
| ----------------------- | ------------------------------ | ---------------------------- |
| **Une carte postale**   | un petit message de vacances   | « Bonjour de Paris ! »       |
| **Un SMS / courriel**   | un message court et rapide     | « Rendez-vous à 18 h. »      |
| **Une petite annonce**  | une offre ou une demande       | « Vélo à vendre, 50 euros. » |
| **Un menu / une carte** | la liste des plats et des prix | « Pizza : 9 euros »          |
| **Un horaire**          | les heures et les jours        | « Train à 8 h 15 »           |
| **Une affichette**      | une information publique       | « Fermé le lundi »           |

Ton but : **comprendre l''essentiel** et **trouver l''information utile**. Tu n''as pas besoin de tout lire mot à mot.

## ⚡ Stratégie 1 — Repère les mots-clés

Lis d''abord la question, puis cherche dans le texte **le mot important** de la question. Un texte court contient toujours quelques mots qui portent le sens : un nom, un objet, une action.

> 🗡️ Astuce : souligne dans ta tête le mot de la question (« à quelle heure ? », « combien ? », « où ? ») et cherche ce mot ou son idée dans le texte.

## 🔮 Stratégie 2 — Cherche les nombres, les heures et les prix

Beaucoup de questions A1 portent sur un **chiffre** : un prix (50 euros), une heure (18 h), un numéro de téléphone, une quantité.

- _« La pizza coûte 9 euros. »_ → le **prix** est 9 euros.
- _« Le film commence à 20 h 30. »_ → l''**heure** est 20 h 30.

> ⚠️ Piège : un texte donne souvent **deux nombres**. Lis bien lequel répond à la question. Si on demande l''heure du film, ne prends pas le numéro de la salle.

## 🛡️ Stratégie 3 — Repère les noms propres et les jours

Les **noms propres** (Marie, Paris, Tunis) commencent par une majuscule. Les **jours** (lundi, mardi…) et les **dates** sont aussi des indices précieux.

- _« Marie arrive lundi à Lyon. »_ → qui ? **Marie**. Quand ? **lundi**. Où ? **Lyon**.

> 🗡️ Astuce : pose-toi les trois questions « qui ? quand ? où ? ». Les réponses sont presque toujours des noms, des jours ou des lieux écrits dans le texte.

## 🧭 Stratégie 4 — Comprends l''essentiel sans tout comprendre

Tu ne connais pas un mot ? Ce n''est pas grave ! Demande-toi : _de quoi parle le texte en général ?_ Le titre, le premier mot et le sujet général suffisent souvent.

- _« SOLDES ! Tout à −50 %. Magasin ouvert samedi. »_ → l''idée principale : **des prix réduits dans un magasin**, même si tu ne connais pas chaque mot.

## 🔮 Stratégie 5 — Devine un mot grâce au contexte

Quand un mot est inconnu, regarde **les mots autour**. Ils donnent un indice sur le sens.

- _« J''ai très faim, je mange un sandwich. »_ → le mot « faim » est lié à « manger » : il veut dire **avoir besoin de nourriture**.

> 🗡️ Astuce : remplace le mot inconnu par chaque réponse possible et garde celle qui a un sens logique dans la phrase.

## 🧪 Exemple complet : on analyse un texte ensemble

Lis cette carte postale :

> « Bonjour Léa ! Je suis à Nice avec maman. Il fait beau et chaud. Nous mangeons une glace au chocolat tous les jours. Nous rentrons dimanche. Bisous, Tom. »

Analysons les indices :

- **Qui écrit ?** → Tom (le nom à la fin, après « Bisous »).
- **Où est Tom ?** → à **Nice** (un nom propre, avec une majuscule).
- **Quel temps fait-il ?** → il fait **beau et chaud**.
- **Quand rentre-t-il ?** → **dimanche** (un jour de la semaine).
- **Idée principale ?** → Tom est **en vacances** et il va bien.

Tu vois ? Avec quelques mots-clés (le nom, le lieu, le jour), tu comprends tout le message. C''est ça, lire au niveau A1.

> 🏆 Bravo, aventurier ! Tu as franchi la porte de la lecture. Avec ces stratégies — mots-clés, nombres, noms propres, contexte — aucun petit texte ne te résiste. En avant pour les missions !', '# 📜 Résumé : Compréhension écrite — lire un texte simple

- **Types de textes A1** : carte postale, SMS, courriel, petite annonce, menu, horaire, affichette, liste de courses.
- **Repère les mots-clés** : lis la question, puis cherche le mot important dans le texte.
- **Cherche les nombres** : prix, heure, jour, numéro, quantité — attention, il y a souvent deux nombres.
- **Repère les noms propres et les jours** : pose-toi « qui ? quand ? où ? » (Marie, lundi, Paris).
- **Comprends l''essentiel** : le titre et le sujet général suffisent, même si tu ne connais pas tous les mots.
- **Devine un mot grâce au contexte** : regarde les mots autour pour trouver le sens.
- ⚠️ **Piège** : la réponse doit venir du texte seul ; ne choisis pas un autre nombre ou un autre jour présent dans le texte.', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('de135706-12c1-5087-876e-2f7ca580d939', '415318c7-e432-5045-bb45-268b28d6e377', 'francais-a1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('5e8f1880-22ef-55e6-b8c2-ef2ebc6e10da', 'de135706-12c1-5087-876e-2f7ca580d939', 'Choisis la bonne forme : « Je ___ élève. »', '[{"id":"a","text":"suis"},{"id":"b","text":"es"},{"id":"c","text":"est"},{"id":"d","text":"ai"}]'::jsonb, 'a', 'Avec le sujet « je », le verbe être se conjugue « suis » : Je suis élève. « es » va avec tu, « est » avec il/elle/on, et « ai » est le verbe avoir, pas être.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33a7b25b-5a69-581d-9891-8a0e6deef2b6', 'de135706-12c1-5087-876e-2f7ca580d939', 'Choisis la bonne forme : « Nous ___ une grande famille. »', '[{"id":"a","text":"sont"},{"id":"b","text":"êtes"},{"id":"c","text":"sommes"},{"id":"d","text":"est"}]'::jsonb, 'c', 'Avec « nous », le verbe être devient « sommes » : Nous sommes une grande famille. « êtes » va avec vous, « sont » avec ils/elles, et « est » avec il/elle/on.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0264af0-1452-52d9-84e3-34b986fb8e3f', 'de135706-12c1-5087-876e-2f7ca580d939', 'Choisis la bonne forme : « J''___ un chien. »', '[{"id":"a","text":"suis"},{"id":"b","text":"ai"},{"id":"c","text":"es"},{"id":"d","text":"as"}]'::jsonb, 'b', 'La possession s''exprime avec avoir : J''ai un chien. « ai » est la forme de avoir avec « je » (devenu j'' devant la voyelle). « suis » et « es » sont des formes du verbe être, et « as » va avec tu.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('05f29284-c77a-57e9-a202-3153aa17c90a', 'de135706-12c1-5087-876e-2f7ca580d939', 'Comment dit-on son âge en français ? « ___ 12 ans. »', '[{"id":"a","text":"Je suis"},{"id":"b","text":"Je es"},{"id":"c","text":"J''es"},{"id":"d","text":"J''ai"}]'::jsonb, 'd', 'En français, on exprime l''âge avec avoir : J''ai 12 ans. On ne dit jamais « je suis 12 ans » (c''est une erreur fréquente). « Je es » et « J''es » sont en plus mal conjugués.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0f69e7f6-7cdd-56a4-b3cf-b2d9500e75c8', 'de135706-12c1-5087-876e-2f7ca580d939', 'Choisis la bonne forme : « Tu ___ mon ami. »', '[{"id":"a","text":"et"},{"id":"b","text":"ai"},{"id":"c","text":"es"},{"id":"d","text":"est"}]'::jsonb, 'c', 'Avec « tu », le verbe être s''écrit « es » : Tu es mon ami. Attention aux homophones : « et » signifie « aussi », « est » va avec il/elle/on, et « ai » est le verbe avoir avec je.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('def6e6de-0a98-54fb-a1b4-6e9ed9f957d7', '415318c7-e432-5045-bb45-268b28d6e377', 'francais-a1', '⭐ Entraînement : être et avoir au présent', 1, 50, 10, 'practice', 'admin', 1)
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
  ('4e65cae6-6a61-5500-9ec5-6413e2ac04b3', 'def6e6de-0a98-54fb-a1b4-6e9ed9f957d7', 'Choisis la bonne forme : « Il ___ content. »', '[{"id":"a","text":"es"},{"id":"b","text":"est"},{"id":"c","text":"suis"},{"id":"d","text":"et"}]'::jsonb, 'b', 'Avec « il », le verbe être se conjugue « est » : Il est content. « es » va avec tu, « suis » avec je, et « et » est une conjonction (= aussi), pas un verbe.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('457ab7c4-e571-5435-9ffb-b49e759fbc64', 'def6e6de-0a98-54fb-a1b4-6e9ed9f957d7', 'Choisis la bonne forme : « Vous ___ gentils. »', '[{"id":"a","text":"sont"},{"id":"b","text":"sommes"},{"id":"c","text":"est"},{"id":"d","text":"êtes"}]'::jsonb, 'd', 'Avec « vous », le verbe être devient « êtes » : Vous êtes gentils. « sommes » va avec nous, « sont » avec ils/elles, et « est » avec il/elle/on.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a2d4f99-5f9f-5981-962c-be584ef2c94e', 'def6e6de-0a98-54fb-a1b4-6e9ed9f957d7', 'Choisis la bonne forme : « Tu ___ un beau cartable. »', '[{"id":"a","text":"as"},{"id":"b","text":"es"},{"id":"c","text":"a"},{"id":"d","text":"ai"}]'::jsonb, 'a', 'La possession se dit avec avoir : Tu as un beau cartable. « as » est la forme de avoir avec tu. « es » est le verbe être, « a » va avec il/elle/on, et « ai » avec je.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('571d5116-7b51-5bd0-9fc0-0382c13a81c6', 'def6e6de-0a98-54fb-a1b4-6e9ed9f957d7', 'Choisis la bonne forme : « Elles ___ à la maison. »', '[{"id":"a","text":"est"},{"id":"b","text":"ont"},{"id":"c","text":"sont"},{"id":"d","text":"sommes"}]'::jsonb, 'c', 'Avec « elles », le verbe être se conjugue « sont » : Elles sont à la maison. « ont » est le verbe avoir avec ils/elles, « est » va avec il/elle/on, et « sommes » avec nous.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b094771-9cbe-50fc-83c9-5f79eeb48f0b', 'def6e6de-0a98-54fb-a1b4-6e9ed9f957d7', 'Choisis la bonne forme : « Nous ___ deux frères. »', '[{"id":"a","text":"sommes"},{"id":"b","text":"avons"},{"id":"c","text":"avez"},{"id":"d","text":"ont"}]'::jsonb, 'b', 'Posséder deux frères, c''est avoir : Nous avons deux frères. « avons » est la forme de avoir avec nous. « sommes » est le verbe être, « avez » va avec vous, et « ont » avec ils/elles.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48bf23c3-809a-548e-a7f9-4b4a688ba406', 'def6e6de-0a98-54fb-a1b4-6e9ed9f957d7', 'Choisis la bonne forme : « J''___ 10 ans. »', '[{"id":"a","text":"suis"},{"id":"b","text":"es"},{"id":"c","text":"est"},{"id":"d","text":"ai"}]'::jsonb, 'd', 'On exprime l''âge avec avoir : J''ai 10 ans. On ne dit jamais « je suis 10 ans » — c''est l''erreur la plus fréquente à ce niveau. « es » et « est » sont en plus mal conjugués avec je.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('79306525-2342-53c1-ad31-083c9a53ac8d', '415318c7-e432-5045-bb45-268b28d6e377', 'francais-a1', '⭐⭐ Révision : être et avoir au présent', 2, 75, 15, 'practice', 'admin', 2)
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
  ('97f4da18-f1b9-58ea-acee-46fc8e50be23', '79306525-2342-53c1-ad31-083c9a53ac8d', 'Choisis la bonne forme : « On ___ en retard. »', '[{"id":"a","text":"es"},{"id":"b","text":"sont"},{"id":"c","text":"est"},{"id":"d","text":"êtes"}]'::jsonb, 'c', '« on » se conjugue comme il/elle, donc être devient « est » : On est en retard. « es » va avec tu, « sont » avec ils/elles, et « êtes » avec vous.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('69d016ee-de97-50cc-995a-957a5f983bc6', '79306525-2342-53c1-ad31-083c9a53ac8d', 'Choisis la bonne forme : « Vous ___ raison. »', '[{"id":"a","text":"avez"},{"id":"b","text":"êtes"},{"id":"c","text":"avons"},{"id":"d","text":"ont"}]'::jsonb, 'a', '« avoir raison » est une expression avec avoir : Vous avez raison. « avez » est la forme de avoir avec vous. « êtes » est le verbe être, « avons » va avec nous, et « ont » avec ils/elles.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('94e52d26-5b63-5225-a8ec-1d28c6e0ee4b', '79306525-2342-53c1-ad31-083c9a53ac8d', 'Choisis l''homophone correct : « Il ___ faim. »', '[{"id":"a","text":"à"},{"id":"b","text":"est"},{"id":"c","text":"es"},{"id":"d","text":"a"}]'::jsonb, 'd', '« avoir faim » utilise le verbe avoir : Il a faim. « a » est le verbe avoir avec il/elle/on. « à » est une préposition de direction (aller à Tunis), tandis que « est » et « es » sont des formes du verbe être.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe013efc-23ff-547d-a11b-c24afeccf27d', '79306525-2342-53c1-ad31-083c9a53ac8d', 'Choisis l''homophone correct : « Ils ___ trois enfants. »', '[{"id":"a","text":"on"},{"id":"b","text":"ont"},{"id":"c","text":"sont"},{"id":"d","text":"son"}]'::jsonb, 'b', 'Posséder trois enfants, c''est avoir : Ils ont trois enfants. « ont » est le verbe avoir avec ils/elles. « on » signifie « nous », « sont » est le verbe être, et « son » est un possessif (le sien).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f074c5c8-01d8-531c-a639-bec5cb5536a2', '79306525-2342-53c1-ad31-083c9a53ac8d', 'Choisis l''homophone correct : « Tu ___ mon meilleur ami. »', '[{"id":"a","text":"et"},{"id":"b","text":"est"},{"id":"c","text":"es"},{"id":"d","text":"ai"}]'::jsonb, 'c', 'Avec « tu », le verbe être s''écrit « es » : Tu es mon meilleur ami. « et » signifie « aussi », « est » va avec il/elle/on, et « ai » est le verbe avoir avec je.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1f43a69-ed2a-5f4c-88de-c5e1fe721db8', '79306525-2342-53c1-ad31-083c9a53ac8d', 'Choisis l''homophone correct : « ___ a gagné le match. »', '[{"id":"a","text":"On"},{"id":"b","text":"Ont"},{"id":"c","text":"Son"},{"id":"d","text":"Sont"}]'::jsonb, 'a', 'Ici le sujet (= nous) s''écrit « On » : On a gagné le match. « Ont » est le verbe avoir (ils ont), « Son » est un possessif (son sac), et « Sont » est le verbe être (ils sont) — aucun n''est un sujet.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('11fdf60b-6571-589f-be91-0dd4d324bcdc', '415318c7-e432-5045-bb45-268b28d6e377', 'francais-a1', '⚔️ Boss du chapitre ⭐⭐⭐ : être et avoir au présent', 3, 120, 30, 'boss', 'admin', 3)
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
  ('22d86b61-d8d3-5b6d-8d62-410e86a2ed80', '11fdf60b-6571-589f-be91-0dd4d324bcdc', 'Choisis la bonne négation : « Je ___ prêt. »', '[{"id":"a","text":"suis pas"},{"id":"b","text":"ne suis pas"},{"id":"c","text":"n''ai pas"},{"id":"d","text":"ne pas suis"}]'::jsonb, 'b', 'La négation encadre le verbe : ne + suis + pas → Je ne suis pas prêt. « suis pas » oublie « ne », « ne pas suis » met les mots dans le mauvais ordre, et « n''ai pas » utilise avoir au lieu de être.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2059fcf2-b1d6-552a-b089-00c2ac8dacdf', '11fdf60b-6571-589f-be91-0dd4d324bcdc', 'Complète à la forme négative : « Je ___ de stylo. »', '[{"id":"a","text":"ne suis pas"},{"id":"b","text":"n''ai pas"},{"id":"c","text":"n''ai pas un"},{"id":"d","text":"ai pas"}]'::jsonb, 'b', 'Avec avoir à la négative, « un/une/des » devient « de » : Je n''ai pas de stylo. « n''ai pas un » garde l''article à tort, « ne suis pas » utilise être, et « ai pas » oublie le « n'' ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d27528fb-716f-585f-af57-3bbea51dc073', '11fdf60b-6571-589f-be91-0dd4d324bcdc', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Elle est médecin."},{"id":"b","text":"Nous avons faim."},{"id":"c","text":"Je suis 12 ans."},{"id":"d","text":"Ils ont un chien."}]'::jsonb, 'c', 'L''erreur est (c) : pour l''âge on emploie avoir, donc « J''ai 12 ans » et non « Je suis 12 ans ». Les phrases (a), (b) et (d) sont correctes : être pour la profession, avoir pour la faim et avoir pour la possession.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2363548-b6b2-55d3-bc68-4afab9fb682d', '11fdf60b-6571-589f-be91-0dd4d324bcdc', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Ils sont des amis et ils ont raison."},{"id":"b","text":"On est en classe."},{"id":"c","text":"Tu es tunisien."},{"id":"d","text":"Elle a froid."}]'::jsonb, 'a', 'L''erreur est (a) : « être ami » ne prend pas d''article, on dit « Ils sont amis » (et la suite « ils ont raison » est, elle, correcte). Les phrases (b), (c) et (d) sont justes : on/est, tu/es et elle/a sont bien conjugués.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bdc5d2a2-141c-54b6-87b3-02e881fe22e6', '11fdf60b-6571-589f-be91-0dd4d324bcdc', 'Choisis les bons homophones : « ___ père ___ professeur. »', '[{"id":"a","text":"Sont … es"},{"id":"b","text":"Son … es"},{"id":"c","text":"Sont … est"},{"id":"d","text":"Son … est"}]'::jsonb, 'd', 'Il faut le possessif « Son » (le sien) puis le verbe être « est » : Son père est professeur. « Sont » est le verbe être au pluriel (ils sont) et « es » va seulement avec tu — aucun ne convient ici.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('39a190a4-3fcd-5b7b-bcf3-268667f0712c', '11fdf60b-6571-589f-be91-0dd4d324bcdc', 'Choisis les bons homophones : « ___ part, mais ils ___ peur. »', '[{"id":"a","text":"Ont … on"},{"id":"b","text":"On … ont"},{"id":"c","text":"On … on"},{"id":"d","text":"Ont … ont"}]'::jsonb, 'b', 'Le sujet (= nous) est « On » et « avoir peur » utilise « ont » : On part, mais ils ont peur. « Ont » n''est pas un sujet (c''est le verbe avoir), et « on » ne peut pas exprimer la possession après « ils ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f3dd4dc6-9b35-544b-b30d-b5f35f1da030', '415318c7-e432-5045-bb45-268b28d6e377', 'francais-a1', '👑 Défi élite ⭐⭐⭐⭐ : être et avoir au présent', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('acd81700-0692-525e-8c7f-d276a95941da', 'f3dd4dc6-9b35-544b-b30d-b5f35f1da030', 'Complète avec les bonnes formes : « Nous ___ fatigués et vous ___ soif. »', '[{"id":"a","text":"avons … êtes"},{"id":"b","text":"sommes … avons"},{"id":"c","text":"sommes … avez"},{"id":"d","text":"êtes … avez"}]'::jsonb, 'c', '« être fatigué » est un état (être) et « avoir soif » une expression (avoir) : Nous sommes fatigués et vous avez soif. Il faut « sommes » avec nous et « avez » avec vous. « avons » mélangerait avoir avec le mauvais sujet.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07417c36-375b-5211-9c57-b17d1aa7b751', 'f3dd4dc6-9b35-544b-b30d-b5f35f1da030', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Mon frère est 15 ans."},{"id":"b","text":"Mes parents sont tunisiens."},{"id":"c","text":"On a un grand jardin."},{"id":"d","text":"Tu n''as pas de stylo."}]'::jsonb, 'a', 'L''erreur est (a) : l''âge se dit avec avoir, donc « Mon frère a 15 ans », jamais « est 15 ans ». Les phrases (b), (c) et (d) sont correctes : être pour la nationalité, avoir pour la possession, et la négation « n''as pas de ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d4182f6c-a2a7-512b-b907-c9f1a212e413', 'f3dd4dc6-9b35-544b-b30d-b5f35f1da030', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Elles ont deux chats."},{"id":"b","text":"Vous êtes en retard."},{"id":"c","text":"Je n''ai pas peur."},{"id":"d","text":"Il a content."}]'::jsonb, 'd', 'L''erreur est (d) : « content » est un état, donc on emploie être → « Il est content », pas « Il a content ». Les phrases (a), (b) et (c) sont justes : avoir pour la possession, être pour l''état « en retard », et « avoir peur » à la négative.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13ad4ea8-4040-5c40-8acd-d285ec6ad89e', 'f3dd4dc6-9b35-544b-b30d-b5f35f1da030', 'Choisis les bons homophones : « Il ___ un vélo ___ il va ___ l''école. »', '[{"id":"a","text":"à … et … a"},{"id":"b","text":"a … et … à"},{"id":"c","text":"a … est … à"},{"id":"d","text":"à … est … a"}]'::jsonb, 'b', 'Il faut le verbe avoir « a », la conjonction « et » (= aussi), puis la préposition « à » : Il a un vélo et il va à l''école. « à » (préposition) ne peut pas être le verbe, et « est » (être) ne relie pas deux idées comme « et ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd9ee791-3e7f-5cc6-ae9a-d9434112b6a9', 'f3dd4dc6-9b35-544b-b30d-b5f35f1da030', 'Choisis les bonnes formes : « ___ sœurs ___ médecins. »', '[{"id":"a","text":"Ses … sont"},{"id":"b","text":"Ses … ont"},{"id":"c","text":"Ce … sont"},{"id":"d","text":"Ses … son"}]'::jsonb, 'a', 'Il faut le possessif pluriel « Ses » (les siennes) puis le verbe être « sont » : Ses sœurs sont médecins. « ont » est le verbe avoir, « son » est singulier, et « Ce » est un démonstratif singulier, incorrect devant « sœurs » au pluriel (il faudrait « Ces »).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f7d8e34-981f-575a-9f14-13c8ff3912cb', 'f3dd4dc6-9b35-544b-b30d-b5f35f1da030', 'Mets à la forme négative : « Nous avons des amis ici. »', '[{"id":"a","text":"Nous n''avons pas des amis ici."},{"id":"b","text":"Nous avons pas d''amis ici."},{"id":"c","text":"Nous n''avons pas d''amis ici."},{"id":"d","text":"Nous ne sommes pas d''amis ici."}]'::jsonb, 'c', 'À la négative, avoir encadre « ne … pas » et « des » devient « d'' » devant une voyelle : Nous n''avons pas d''amis ici. La forme (a) garde « des » à tort, (b) oublie le « n'' », et (d) remplace avoir par être.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ceb52d48-9052-5ba6-a112-8573f9499f62', '415318c7-e432-5045-bb45-268b28d6e377', 'francais-a1', '⭐⭐ Drill : être et avoir au présent', 2, 75, 15, 'practice', 'admin', 5)
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
  ('82f05f72-9793-5121-9116-4c39e4b6292e', 'ceb52d48-9052-5ba6-a112-8573f9499f62', 'Choisis la bonne forme : « Elle ___ infirmière. »', '[{"id":"a","text":"es"},{"id":"b","text":"est"},{"id":"c","text":"ai"},{"id":"d","text":"as"}]'::jsonb, 'b', 'Avec « elle », le verbe être se conjugue « est » : Elle est infirmière. On utilise être pour la profession. « es » va avec tu, et « ai/as » sont des formes du verbe avoir.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e4e1af62-799f-5e3e-931d-2fb35648f491', 'ceb52d48-9052-5ba6-a112-8573f9499f62', 'Choisis la bonne forme : « Vous ___ un beau jardin. »', '[{"id":"a","text":"êtes"},{"id":"b","text":"ont"},{"id":"c","text":"avons"},{"id":"d","text":"avez"}]'::jsonb, 'd', 'Posséder un jardin, c''est avoir : Vous avez un beau jardin. « avez » est la forme de avoir avec vous. « êtes » est le verbe être, « avons » va avec nous, et « ont » avec ils/elles.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fdfde6ad-cc78-55a1-a6c9-378880a87688', 'ceb52d48-9052-5ba6-a112-8573f9499f62', 'Choisis l''homophone correct : « Karim ___ soif. »', '[{"id":"a","text":"a"},{"id":"b","text":"à"},{"id":"c","text":"est"},{"id":"d","text":"es"}]'::jsonb, 'a', '« avoir soif » est une expression avec avoir : Karim a soif. « a » est le verbe avoir avec il/elle. « à » est une préposition de direction, et « est/es » sont des formes du verbe être.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af1a2b70-05cc-5dea-8bfd-84c92e48d143', 'ceb52d48-9052-5ba6-a112-8573f9499f62', 'Choisis la bonne négation : « Tu ___ en retard. »', '[{"id":"a","text":"es pas"},{"id":"b","text":"ne es pas"},{"id":"c","text":"n''es pas"},{"id":"d","text":"n''as pas"}]'::jsonb, 'c', 'La négation encadre le verbe être : ne (n'' devant voyelle) + es + pas → Tu n''es pas en retard. « es pas » oublie le « n'' », « ne es pas » garde « ne » sans élision (faux devant voyelle), et « n''as pas » utilise le verbe avoir au lieu de être.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('46354e55-2d4b-5d7a-904f-07fc73778f72', 'ceb52d48-9052-5ba6-a112-8573f9499f62', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Nous sommes à l''école."},{"id":"b","text":"Ils ont peur du noir."},{"id":"c","text":"Elle a dix ans."},{"id":"d","text":"On ont gagné."}]'::jsonb, 'd', 'L''erreur est (d) : « on » se conjugue comme il/elle, donc « On a gagné », jamais « On ont ». Les phrases (a), (b) et (c) sont correctes : être pour le lieu, « avoir peur », et l''âge avec avoir.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d54c0041-1d54-58f0-bd1a-fe866e69d346', 'ceb52d48-9052-5ba6-a112-8573f9499f62', 'Choisis les bons homophones : « ___ amis ___ gentils. »', '[{"id":"a","text":"Ses … ont"},{"id":"b","text":"Ses … sont"},{"id":"c","text":"Ces … ont"},{"id":"d","text":"Ses … son"}]'::jsonb, 'b', 'Il faut le possessif pluriel « Ses » puis le verbe être « sont » : Ses amis sont gentils. « ont » est le verbe avoir (ils ont), « son » est singulier (le sien), et « Ces » est un démonstratif, pas le possessif attendu.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5f5a3e47-858b-5c82-8594-31e6785b6ee3', 'f9f6566c-42f5-5eb6-ac69-4e7d00503ce2', 'francais-a1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('5fd5be01-0adf-56b2-9c23-2b2f0bbbe5e5', '5f5a3e47-858b-5c82-8594-31e6785b6ee3', 'Complète : « Je ___ français à l''école. »', '[{"id":"a","text":"parle"},{"id":"b","text":"parles"},{"id":"c","text":"parlent"},{"id":"d","text":"parler"}]'::jsonb, 'a', 'Au présent du 1er groupe, le pronom « je » prend toujours la terminaison -e : je parle. « parles » est la forme de tu, « parlent » celle de ils/elles, et « parler » est l''infinitif (non conjugué).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48337208-1f6a-58d7-a640-b157931e8b88', '5f5a3e47-858b-5c82-8594-31e6785b6ee3', 'Complète : « Nous ___ à Tunis. »', '[{"id":"a","text":"habite"},{"id":"b","text":"habites"},{"id":"c","text":"habitons"},{"id":"d","text":"habitent"}]'::jsonb, 'c', 'Avec « nous », la terminaison du 1er groupe est -ons : nous habitons. « habite » est pour je/il/elle, « habites » pour tu, et « habitent » pour ils/elles.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e0710a1c-ddf5-5b3f-a62c-c57a582c4961', '5f5a3e47-858b-5c82-8594-31e6785b6ee3', 'Complète : « Tu ___ beaucoup. »', '[{"id":"a","text":"travaille"},{"id":"b","text":"travailles"},{"id":"c","text":"travaillent"},{"id":"d","text":"travaillez"}]'::jsonb, 'b', 'Avec « tu », on écrit toujours -es : tu travailles. Le -s est muet (on entend « travaille »), mais il est obligatoire à l''écrit. « travaille » est la forme de il/elle, « travaillent » celle de ils/elles, et « travaillez » celle de vous.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b335a520-ae98-5cc5-b3e8-72cecd15e48e', '5f5a3e47-858b-5c82-8594-31e6785b6ee3', 'Complète : « Les enfants ___ dans le jardin. »', '[{"id":"a","text":"joue"},{"id":"b","text":"joues"},{"id":"c","text":"jouons"},{"id":"d","text":"jouent"}]'::jsonb, 'd', '« Les enfants » = ils, donc la terminaison est -ent : les enfants jouent. Le -ent est muet (on entend « joue »), mais il faut l''écrire. « joue » serait pour il/elle (un seul enfant), « joues » pour tu, et « jouons » pour nous.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5d43497a-fd11-57de-8cef-b0d8e8bcc58c', '5f5a3e47-858b-5c82-8594-31e6785b6ee3', 'Complète : « Elle ___ le chocolat. »', '[{"id":"a","text":"aimes"},{"id":"b","text":"aiment"},{"id":"c","text":"aime"},{"id":"d","text":"aimons"}]'::jsonb, 'c', 'Avec « elle » (il/elle/on), la terminaison est -e : elle aime. « aimes » est la forme de tu, « aiment » celle de ils/elles, et « aimons » celle de nous.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bfebe38a-2a0f-5255-ae03-ac78f4989707', 'f9f6566c-42f5-5eb6-ac69-4e7d00503ce2', 'francais-a1', '⭐ Entraînement : les verbes en -er au présent', 1, 50, 10, 'practice', 'admin', 1)
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
  ('0261a9a1-e91d-561c-bfcc-2ff6886bf35f', 'bfebe38a-2a0f-5255-ae03-ac78f4989707', 'Complète : « Je ___ la télé le soir. »', '[{"id":"a","text":"regardes"},{"id":"b","text":"regarde"},{"id":"c","text":"regardent"},{"id":"d","text":"regarder"}]'::jsonb, 'b', 'Avec « je », le verbe du 1er groupe prend -e : je regarde. « regardes » est la forme de tu, « regardent » celle de ils/elles, et « regarder » est l''infinitif.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('18ef6151-895e-54eb-aa38-3e0f065becdc', 'bfebe38a-2a0f-5255-ae03-ac78f4989707', 'Complète : « Vous ___ très bien. »', '[{"id":"a","text":"chante"},{"id":"b","text":"chantes"},{"id":"c","text":"chantez"},{"id":"d","text":"chantent"}]'::jsonb, 'c', 'Avec « vous », la terminaison du 1er groupe est -ez : vous chantez. « chante » est pour je/il/elle, « chantes » pour tu, et « chantent » pour ils/elles.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f16218f-45c5-50dd-bc5e-8e00b2fd4415', 'bfebe38a-2a0f-5255-ae03-ac78f4989707', 'Complète : « Nous ___ le football. »', '[{"id":"a","text":"aime"},{"id":"b","text":"aimes"},{"id":"c","text":"aiment"},{"id":"d","text":"aimons"}]'::jsonb, 'd', 'Avec « nous », on ajoute -ons : nous aimons le football. « aime » est pour je/il/elle, « aimes » pour tu, et « aiment » pour ils/elles.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6069fd73-45d8-56f4-be8a-c58200f0fab2', 'bfebe38a-2a0f-5255-ae03-ac78f4989707', 'Complète : « Tu ___ à Paris. »', '[{"id":"a","text":"habites"},{"id":"b","text":"habite"},{"id":"c","text":"habitent"},{"id":"d","text":"habiter"}]'::jsonb, 'a', 'Avec « tu », on écrit -es : tu habites. Le -s est muet mais obligatoire à l''écrit. « habite » est la forme de il/elle, « habitent » celle de ils/elles, et « habiter » l''infinitif.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8326f8dc-dec5-5906-b317-b41f9001ceb0', 'bfebe38a-2a0f-5255-ae03-ac78f4989707', 'Complète : « Il ___ dans une école. »', '[{"id":"a","text":"travailles"},{"id":"b","text":"travaillent"},{"id":"c","text":"travaillons"},{"id":"d","text":"travaille"}]'::jsonb, 'd', 'Avec « il » (il/elle/on), la terminaison est -e : il travaille. « travailles » est pour tu, « travaillent » pour ils/elles, et « travaillons » pour nous.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02510a10-71d5-5a85-bf62-04402ab4e0ab', 'bfebe38a-2a0f-5255-ae03-ac78f4989707', 'Complète : « Ils ___ au parc. »', '[{"id":"a","text":"joue"},{"id":"b","text":"jouent"},{"id":"c","text":"joues"},{"id":"d","text":"jouez"}]'::jsonb, 'b', 'Avec « ils », la terminaison est -ent : ils jouent. Le -ent est muet (on entend « joue ») mais il faut l''écrire. « joue » est pour il/elle, « joues » pour tu, et « jouez » pour vous.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1eda4d00-6cf6-527d-9cca-ba59fbbc3b83', 'f9f6566c-42f5-5eb6-ac69-4e7d00503ce2', 'francais-a1', '⭐⭐ Révision : les verbes en -er au présent', 2, 75, 15, 'practice', 'admin', 2)
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
  ('35e267be-21b7-5ef0-b3fb-a0bde4eda187', '1eda4d00-6cf6-527d-9cca-ba59fbbc3b83', 'Complète : « Mon frère ___ la musique. »', '[{"id":"a","text":"adores"},{"id":"b","text":"adorent"},{"id":"c","text":"adore"},{"id":"d","text":"adorez"}]'::jsonb, 'c', '« Mon frère » = il (un seul nom singulier), donc la terminaison est -e : mon frère adore. « adores » est pour tu, « adorent » pour ils/elles, et « adorez » pour vous.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db6cb78d-2f01-59dd-817a-1dcdfd0c5183', '1eda4d00-6cf6-527d-9cca-ba59fbbc3b83', 'Complète : « Les élèves ___ leurs leçons. »', '[{"id":"a","text":"étudient"},{"id":"b","text":"étudie"},{"id":"c","text":"étudies"},{"id":"d","text":"étudiez"}]'::jsonb, 'a', '« Les élèves » = ils (sujet pluriel), donc -ent : les élèves étudient. Le -ent est muet mais obligatoire. « étudie » est pour il/elle, « étudies » pour tu, et « étudiez » pour vous.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c1ad37f-baae-559c-8965-8002fdc14c26', '1eda4d00-6cf6-527d-9cca-ba59fbbc3b83', 'Choisis la phrase correcte.', '[{"id":"a","text":"Tu mange une pomme."},{"id":"b","text":"Tu mangent une pomme."},{"id":"c","text":"Tu mangez une pomme."},{"id":"d","text":"Tu manges une pomme."}]'::jsonb, 'd', 'Avec « tu », on écrit toujours -es : tu manges. Le -s est muet mais obligatoire. « tu mange » oublie le -s, « tu mangent » met la terminaison de ils/elles, et « tu mangez » celle de vous.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('61450b5e-beb1-51a0-a271-8a8cac6f6eeb', '1eda4d00-6cf6-527d-9cca-ba59fbbc3b83', 'Complète : « ___ aimons le cinéma. »', '[{"id":"a","text":"Je"},{"id":"b","text":"Nous"},{"id":"c","text":"Tu"},{"id":"d","text":"Il"}]'::jsonb, 'b', 'La terminaison -ons correspond au pronom « nous » : nous aimons. « Je » donne -e (j''aime), « Tu » donne -es (tu aimes), et « Il » donne -e (il aime).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd045067-ea89-5e69-838c-d2cfd88ae830', '1eda4d00-6cf6-527d-9cca-ba59fbbc3b83', 'Choisis la phrase correcte.', '[{"id":"a","text":"Elle parles anglais."},{"id":"b","text":"Elle parlent anglais."},{"id":"c","text":"Elle parle anglais."},{"id":"d","text":"Elle parlez anglais."}]'::jsonb, 'c', 'Avec « elle » (il/elle/on), la terminaison est -e : elle parle. « elle parles » ajoute par erreur le -s de tu, « elle parlent » met la forme de ils/elles, et « elle parlez » celle de vous.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d02ad5bd-1b7b-5489-8690-27ea1e03d345', '1eda4d00-6cf6-527d-9cca-ba59fbbc3b83', 'Complète : « Vous ___ souvent au tennis. »', '[{"id":"a","text":"jouez"},{"id":"b","text":"jouons"},{"id":"c","text":"jouent"},{"id":"d","text":"joues"}]'::jsonb, 'a', 'Avec « vous », la terminaison est -ez : vous jouez. « jouons » est pour nous, « jouent » pour ils/elles, et « joues » pour tu.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2233e08c-559c-5869-a382-5eb596a4a281', 'f9f6566c-42f5-5eb6-ac69-4e7d00503ce2', 'francais-a1', '⚔️ Boss du chapitre ⭐⭐⭐ : les verbes en -er au présent', 3, 120, 30, 'boss', 'admin', 3)
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
  ('d7441ffe-0126-5497-b66c-3a540244401c', '2233e08c-559c-5869-a382-5eb596a4a281', 'Complète : « Mes amis et moi ___ ensemble. »', '[{"id":"a","text":"travaillons"},{"id":"b","text":"travaillent"},{"id":"c","text":"travaille"},{"id":"d","text":"travaillez"}]'::jsonb, 'a', '« Mes amis et moi » se remplace par « nous », donc la terminaison est -ons : nous travaillons. Le piège : un sujet pluriel qui inclut « moi » devient toujours « nous », pas « ils ». « travaillent » serait pour ils/elles, « travaille » pour il/elle, et « travaillez » pour vous.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a290cf9f-926f-52f9-97d7-35ca87853b61', '2233e08c-559c-5869-a382-5eb596a4a281', 'Choisis la phrase correcte.', '[{"id":"a","text":"Les chiens aboie dans la rue."},{"id":"b","text":"Les chiens aboies dans la rue."},{"id":"c","text":"Les chiens aboient dans la rue."},{"id":"d","text":"Les chiens aboiez dans la rue."}]'::jsonb, 'c', '« Les chiens » = ils (pluriel), donc -ent : les chiens aboient. Le -ent est muet (on entend « aboie »), ce qui rend le piège dangereux. « aboie » est la forme du singulier (il/elle), « aboies » celle de tu, et « aboiez » celle de vous.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59f7918b-6e62-564e-ab9c-4fb58ddf505e', '2233e08c-559c-5869-a382-5eb596a4a281', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Tu écoutes la radio."},{"id":"b","text":"Ils mange à midi."},{"id":"c","text":"Nous dansons bien."},{"id":"d","text":"Elle aime les fleurs."}]'::jsonb, 'b', 'L''erreur est (b) : « ils » exige la terminaison -ent, donc il faut écrire « Ils mangent à midi ». Le -ent est muet mais obligatoire. Les phrases (a) tu écoutes, (c) nous dansons et (d) elle aime sont toutes correctes.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f716770-0287-5c29-9191-b0211616c7cc', '2233e08c-559c-5869-a382-5eb596a4a281', 'Complète : « ___ habitez dans un grand appartement. »', '[{"id":"a","text":"Ils"},{"id":"b","text":"Nous"},{"id":"c","text":"Tu"},{"id":"d","text":"Vous"}]'::jsonb, 'd', 'La terminaison -ez correspond uniquement au pronom « vous » : vous habitez. « Ils » donnerait -ent (ils habitent), « Nous » donnerait -ons (nous habitons), et « Tu » donnerait -es (tu habites).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('274ab3b1-e467-5583-92f3-16535c1e85e5', '2233e08c-559c-5869-a382-5eb596a4a281', 'Choisis la phrase correcte.', '[{"id":"a","text":"Marie et Léa chante."},{"id":"b","text":"Marie et Léa chantes."},{"id":"c","text":"Marie et Léa chantent."},{"id":"d","text":"Marie et Léa chantez."}]'::jsonb, 'c', '« Marie et Léa » = elles (deux personnes), donc -ent : Marie et Léa chantent. Deux noms reliés par « et » forment un sujet pluriel. « chante » est le singulier (il/elle), « chantes » la forme de tu, et « chantez » celle de vous.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cfac46b0-fe05-562e-b5b0-774a1ab556c9', '2233e08c-559c-5869-a382-5eb596a4a281', 'Complète : « Nous ___ la leçon maintenant. »', '[{"id":"a","text":"commencons"},{"id":"b","text":"commençons"},{"id":"c","text":"commencent"},{"id":"d","text":"commences"}]'::jsonb, 'b', 'Les verbes en -cer prennent une cédille à la personne « nous » pour garder le son « s » : nous commençons. Sans cédille (« commencons »), on lirait le son « k ». « commencent » est la forme de ils/elles, et « commences » celle de tu.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9fe1ca6b-46d9-5027-b010-b8afc186ca1e', 'f9f6566c-42f5-5eb6-ac69-4e7d00503ce2', 'francais-a1', '👑 Défi élite ⭐⭐⭐⭐ : les verbes en -er au présent', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('aeeb770c-4c15-5e52-b0a1-25ac599bdb74', '9fe1ca6b-46d9-5027-b010-b8afc186ca1e', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Vous voyagez beaucoup."},{"id":"b","text":"On regarde un film."},{"id":"c","text":"Je cherche mes clés."},{"id":"d","text":"Tu travaille trop."}]'::jsonb, 'd', 'L''erreur est (d) : « tu » exige -es, donc il faut écrire « Tu travailles trop ». Le -s est muet, c''est pourquoi l''oubli est fréquent. Les phrases (a) vous voyagez, (b) on regarde (le pronom « on » se conjugue comme il/elle) et (c) je cherche sont correctes.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2e67e33-ad71-5482-bbec-4270367778f4', '9fe1ca6b-46d9-5027-b010-b8afc186ca1e', 'Complète : « Toi et ton frère ___ au basket. »', '[{"id":"a","text":"jouons"},{"id":"b","text":"jouez"},{"id":"c","text":"jouent"},{"id":"d","text":"joue"}]'::jsonb, 'b', '« Toi et ton frère » se remplace par « vous », donc la terminaison est -ez : vous jouez. Le piège : un sujet pluriel qui contient « toi » devient « vous », pas « ils ». « jouons » serait pour nous, « jouent » pour ils/elles, et « joue » pour il/elle.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc67c61a-b0ee-5e05-a9cf-7375b72c6a5b', '9fe1ca6b-46d9-5027-b010-b8afc186ca1e', 'Choisis la phrase entièrement correcte.', '[{"id":"a","text":"Les voisins parlent fort et écoutent la musique."},{"id":"b","text":"Les voisins parle fort et écoutent la musique."},{"id":"c","text":"Les voisins parlent fort et écoute la musique."},{"id":"d","text":"Les voisins parles fort et écoutes la musique."}]'::jsonb, 'a', '« Les voisins » = ils, donc les DEUX verbes prennent -ent : les voisins parlent et écoutent. Le piège est d''accorder un seul verbe et d''oublier l''autre. En (b) « parle » et en (c) « écoute » sont au singulier ; en (d) « parles/écoutes » sont les formes de tu.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('46d1784a-db78-5783-9a8f-5bac317b82ed', '9fe1ca6b-46d9-5027-b010-b8afc186ca1e', 'Complète : « Nous ___ vers la sortie. »', '[{"id":"a","text":"avancent"},{"id":"b","text":"avancons"},{"id":"c","text":"avançons"},{"id":"d","text":"avances"}]'::jsonb, 'c', 'Les verbes en -cer prennent une cédille à la personne « nous » pour garder le son « s » : nous avançons. Sans cédille (« avancons ») on lirait « k ». « avancent » est la forme de ils/elles, et « avances » celle de tu.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b6c97919-bcdc-5886-9fc0-f4f0c8ff106f', '9fe1ca6b-46d9-5027-b010-b8afc186ca1e', 'Choisis la phrase entièrement correcte.', '[{"id":"a","text":"Mon ami et moi mangons et voyagons souvent."},{"id":"b","text":"Mon ami et moi mangeons et voyageons souvent."},{"id":"c","text":"Mon ami et moi mangeons et voyagons souvent."},{"id":"d","text":"Mon ami et moi mangent et voyagent souvent."}]'::jsonb, 'b', '« Mon ami et moi » = nous. Les verbes en -ger gardent un « e » devant -ons pour conserver le son « j » : nous mangeons et voyageons. En (a) il manque les deux « e », en (c) il en manque un (« voyagons »), et en (d) « mangent/voyagent » sont les formes de ils/elles.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ae7aa3ee-d043-54ac-bf01-5d341733a4d8', '9fe1ca6b-46d9-5027-b010-b8afc186ca1e', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Elles dansent tous les soirs."},{"id":"b","text":"Tu cherches un travail."},{"id":"c","text":"Nous aimons le café."},{"id":"d","text":"Le chat et le chien joue."}]'::jsonb, 'd', 'L''erreur est (d) : « Le chat et le chien » = ils (deux sujets reliés par « et »), donc le verbe prend -ent : « Le chat et le chien jouent ». Le -ent est muet, ce qui rend l''oubli fréquent. Les phrases (a) elles dansent, (b) tu cherches et (c) nous aimons sont correctes.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6a60b097-1e72-53a6-8cdd-a5037998844b', 'f9f6566c-42f5-5eb6-ac69-4e7d00503ce2', 'francais-a1', '⭐⭐ Drill : les verbes en -er au présent', 2, 75, 15, 'practice', 'admin', 5)
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
  ('6f7a4267-2070-58ea-8244-a2f7eba34e95', '6a60b097-1e72-53a6-8cdd-a5037998844b', 'Complète : « J'' ___ une nouvelle voiture. »', '[{"id":"a","text":"achetes"},{"id":"b","text":"achetent"},{"id":"c","text":"achète"},{"id":"d","text":"achetez"}]'::jsonb, 'c', 'Avec « je » (j'' devant une voyelle), la terminaison est -e : j''achète. « achetes » est la forme de tu, « achetent » celle de ils/elles, et « achetez » celle de vous.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f21dcf0-0101-571e-a00c-cea13b0f7414', '6a60b097-1e72-53a6-8cdd-a5037998844b', 'Complète : « Vous ___ très vite. »', '[{"id":"a","text":"marchez"},{"id":"b","text":"marche"},{"id":"c","text":"marchent"},{"id":"d","text":"marches"}]'::jsonb, 'a', 'Avec « vous », la terminaison est -ez : vous marchez. « marche » est pour je/il/elle, « marchent » pour ils/elles, et « marches » pour tu.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e2febb7-2b01-5eab-923f-80f2a0473b6d', '6a60b097-1e72-53a6-8cdd-a5037998844b', 'Choisis la phrase correcte.', '[{"id":"a","text":"Les oiseaux chante."},{"id":"b","text":"Les oiseaux chantes."},{"id":"c","text":"Les oiseaux chantez."},{"id":"d","text":"Les oiseaux chantent."}]'::jsonb, 'd', '« Les oiseaux » = ils (pluriel), donc -ent : les oiseaux chantent. Le -ent est muet mais obligatoire à l''écrit. « chante » est le singulier (il/elle), « chantes » la forme de tu, et « chantez » celle de vous.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5bae49ca-130e-516b-8a8a-5ec98e481cf3', '6a60b097-1e72-53a6-8cdd-a5037998844b', 'Complète : « Nous ___ une part de gâteau. »', '[{"id":"a","text":"partagons"},{"id":"b","text":"partageons"},{"id":"c","text":"partagent"},{"id":"d","text":"partages"}]'::jsonb, 'b', 'Les verbes en -ger gardent un « e » devant -ons à la personne « nous » pour conserver le son « j » : nous partageons. Sans le « e » (« partagons »), on lirait le son « g » dur. « partagent » est la forme de ils/elles, et « partages » celle de tu.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('290ff040-c24f-56eb-84ad-f962e8c43518', '6a60b097-1e72-53a6-8cdd-a5037998844b', 'Choisis la phrase correcte.', '[{"id":"a","text":"Tu donne un cadeau."},{"id":"b","text":"Tu donnent un cadeau."},{"id":"c","text":"Tu donnes un cadeau."},{"id":"d","text":"Tu donnez un cadeau."}]'::jsonb, 'c', 'Avec « tu », on écrit -es : tu donnes. Le -s est muet (on entend « donne ») mais obligatoire. « tu donne » oublie le -s, « tu donnent » met la forme de ils/elles, et « tu donnez » celle de vous.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b53211f-ae68-57ea-a9e2-1703acc4a29d', '6a60b097-1e72-53a6-8cdd-a5037998844b', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Mes parents arrive demain."},{"id":"b","text":"Nous fermons la porte."},{"id":"c","text":"Elle ferme la fenêtre."},{"id":"d","text":"Vous trouvez la solution."}]'::jsonb, 'a', 'L''erreur est (a) : « Mes parents » = ils (pluriel), donc le verbe prend -ent : « Mes parents arrivent demain ». Le -ent est muet mais obligatoire. Les phrases (b) nous fermons, (c) elle ferme et (d) vous trouvez sont toutes correctes.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('880a0660-3e8d-5c3d-bc12-619d84d54545', 'e6d7c80a-52bd-5273-a275-3c8a18a54b01', 'francais-a1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('0ff29ce2-88e5-542a-ac01-a3d172cce948', '880a0660-3e8d-5c3d-bc12-619d84d54545', 'Choisis l''article correct : « J''ai ___ chien à la maison. »', '[{"id":"a","text":"une"},{"id":"b","text":"un"},{"id":"c","text":"la"},{"id":"d","text":"des"}]'::jsonb, 'b', '« Chien » est un nom masculin singulier, donc on emploie l''article indéfini « un » : un chien. La forme « une » est féminine, « la » est un article défini féminin, et « des » serait un pluriel.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4003abb-85d3-5076-a5a7-5deac86ed008', '880a0660-3e8d-5c3d-bc12-619d84d54545', 'Choisis l''article correct : « ___ table est dans la cuisine. »', '[{"id":"a","text":"Le"},{"id":"b","text":"L''"},{"id":"c","text":"La"},{"id":"d","text":"Un"}]'::jsonb, 'c', '« Table » est un nom féminin qui commence par une consonne, donc l''article défini est « la » : la table. « Le » est masculin, « l'' » ne s''emploie que devant une voyelle ou un h muet, et « un » est un article indéfini.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f4149348-3e79-5a88-bbb2-3043a79adb89', '880a0660-3e8d-5c3d-bc12-619d84d54545', 'Quel est le pluriel correct de « un chat » ?', '[{"id":"a","text":"un chats"},{"id":"b","text":"les chat"},{"id":"c","text":"le chats"},{"id":"d","text":"des chats"}]'::jsonb, 'd', 'Au pluriel, le nom prend un -s (chat → chats) et l''article indéfini « un » devient « des » : des chats. On ne garde pas « un » au pluriel, et l''article et le nom doivent porter la marque du pluriel ensemble.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5b9bc1f-fae0-51b8-bf8f-1b3d7f22aded', '880a0660-3e8d-5c3d-bc12-619d84d54545', 'Choisis la bonne forme : « ___ ami de Marie est gentil. »', '[{"id":"a","text":"L''"},{"id":"b","text":"Le"},{"id":"c","text":"La"},{"id":"d","text":"Les"}]'::jsonb, 'a', '« Ami » commence par la voyelle « a », donc « le » devient « l'' » par élision : l''ami. On n''écrit jamais « le ami », et « la » serait une erreur de genre car « ami » est masculin (le féminin est « amie »).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('baa379ae-2022-5979-9c8d-26976394b590', '880a0660-3e8d-5c3d-bc12-619d84d54545', 'Quel est le pluriel correct de « un gâteau » ?', '[{"id":"a","text":"des gâteaus"},{"id":"b","text":"des gâteaux"},{"id":"c","text":"des gâteau"},{"id":"d","text":"les gâteaus"}]'::jsonb, 'b', 'Les noms en -eau forment leur pluriel en -eaux : un gâteau → des gâteaux. La forme régulière « gâteaus » est fautive, car les noms en -eau ne prennent pas un simple -s.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b31c16f5-ffa2-5dfa-91a8-35b56699ded0', 'e6d7c80a-52bd-5273-a275-3c8a18a54b01', 'francais-a1', '⭐ Entraînement : articles, genre et pluriel', 1, 50, 10, 'practice', 'admin', 1)
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
  ('88898e77-58ee-53a5-8258-a01c13d0090a', 'b31c16f5-ffa2-5dfa-91a8-35b56699ded0', 'Choisis l''article correct : « J''achète ___ livre. »', '[{"id":"a","text":"une"},{"id":"b","text":"un"},{"id":"c","text":"la"},{"id":"d","text":"des"}]'::jsonb, 'b', '« Livre » est un nom masculin singulier, donc l''article indéfini est « un » : un livre. La forme « une » est réservée au féminin, et « la »/« des » ne conviennent pas ici (premier article indéfini, singulier masculin).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e11a713-0ad1-5700-b4bf-94290ceee570', 'b31c16f5-ffa2-5dfa-91a8-35b56699ded0', 'Choisis l''article correct : « ___ lune brille ce soir. »', '[{"id":"a","text":"Le"},{"id":"b","text":"Un"},{"id":"c","text":"La"},{"id":"d","text":"L''"}]'::jsonb, 'c', '« Lune » est un nom féminin commençant par une consonne, donc l''article défini est « la » : la lune. « Le » serait une erreur de genre, et « l'' » ne s''emploie que devant une voyelle ou un h muet.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c9e8ea7-7164-5670-a90d-05b690fac7b6', 'b31c16f5-ffa2-5dfa-91a8-35b56699ded0', 'Quel est le pluriel correct de « le livre » ?', '[{"id":"a","text":"le livres"},{"id":"b","text":"un livres"},{"id":"c","text":"des livre"},{"id":"d","text":"les livres"}]'::jsonb, 'd', 'Au pluriel, le nom prend un -s (livre → livres) et l''article défini « le » devient « les » : les livres. L''article et le nom doivent tous deux porter la marque du pluriel.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e48a70fb-cdd0-5b68-8f92-8ee94f60c7d3', 'b31c16f5-ffa2-5dfa-91a8-35b56699ded0', 'Choisis la bonne forme : « ___ école est grande. »', '[{"id":"a","text":"L''"},{"id":"b","text":"Le"},{"id":"c","text":"La"},{"id":"d","text":"Un"}]'::jsonb, 'a', '« École » commence par la voyelle « é », donc « la » devient « l'' » par élision : l''école. On n''écrit jamais « la école », et « le » serait une erreur de genre (école est féminin).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('022c3853-fe0a-52f7-a5ac-baedc251d485', 'b31c16f5-ffa2-5dfa-91a8-35b56699ded0', 'Choisis l''article correct : « Je vois ___ oiseaux dans le ciel. »', '[{"id":"a","text":"un"},{"id":"b","text":"une"},{"id":"c","text":"des"},{"id":"d","text":"le"}]'::jsonb, 'c', '« Oiseaux » est au pluriel (plusieurs oiseaux), donc l''article indéfini est « des » : des oiseaux. « Un »/« une » sont singuliers et « le » est un article défini singulier.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eddbb1b5-9b28-51e8-8d32-464d2b424b0b', 'b31c16f5-ffa2-5dfa-91a8-35b56699ded0', 'Quel est le pluriel correct de « une table » ?', '[{"id":"a","text":"une tables"},{"id":"b","text":"des tables"},{"id":"c","text":"des table"},{"id":"d","text":"les table"}]'::jsonb, 'b', 'Au pluriel, « table » prend un -s (tables) et l''article indéfini « une » devient « des » : des tables. On ne garde pas « une » au pluriel, et le nom doit aussi porter le -s.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c02898af-a58e-5b2f-8c43-ae6986f9646d', 'e6d7c80a-52bd-5273-a275-3c8a18a54b01', 'francais-a1', '⭐⭐ Révision : articles, genre et pluriel', 2, 75, 15, 'practice', 'admin', 2)
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
  ('35111da4-c1f6-5c47-92d6-abf1da1e41f5', 'c02898af-a58e-5b2f-8c43-ae6986f9646d', 'Choisis l''article correct : « ___ soleil se lève à l''est. »', '[{"id":"a","text":"Le"},{"id":"b","text":"La"},{"id":"c","text":"L''"},{"id":"d","text":"Une"}]'::jsonb, 'a', '« Soleil » est un nom masculin commençant par une consonne, donc l''article défini est « le » : le soleil. « La » serait une erreur de genre, et « l'' » ne s''emploie que devant une voyelle ou un h muet.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d80f4f95-bed5-5107-a0ef-e9fab6b5f1e6', 'c02898af-a58e-5b2f-8c43-ae6986f9646d', 'Choisis la bonne forme : « ___ homme attend devant la porte. »', '[{"id":"a","text":"Le"},{"id":"b","text":"La"},{"id":"c","text":"Les"},{"id":"d","text":"L''"}]'::jsonb, 'd', '« Homme » commence par un h muet, qui se comporte comme une voyelle, donc « le » devient « l'' » par élision : l''homme. On n''écrit jamais « le homme », et « la » serait une erreur de genre (homme est masculin).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bf569014-eeac-5a24-aa41-ffc47b1142e5', 'c02898af-a58e-5b2f-8c43-ae6986f9646d', 'Quel est le pluriel correct de « un animal » ?', '[{"id":"a","text":"des animals"},{"id":"b","text":"des animaux"},{"id":"c","text":"des animal"},{"id":"d","text":"les animals"}]'::jsonb, 'b', 'Les noms en -al forment leur pluriel en -aux : un animal → des animaux. La forme régulière « animals » est fautive, car ces noms ne prennent pas un simple -s.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('32c6731b-9f94-5a65-ba3e-3d404b489211', 'c02898af-a58e-5b2f-8c43-ae6986f9646d', 'Choisis l''article correct : « Marie a ___ amie très sympathique. »', '[{"id":"a","text":"un"},{"id":"b","text":"le"},{"id":"c","text":"une"},{"id":"d","text":"des"}]'::jsonb, 'c', '« Amie » est ici féminin (l''amie de Marie), donc l''article indéfini est « une » : une amie. La forme masculine « un ami » n''accorde pas le genre, et « le »/« des » ne conviennent pas (indéfini, féminin, singulier).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6c04a9d9-f88b-52e8-9a40-3d9a60541ee1', 'c02898af-a58e-5b2f-8c43-ae6986f9646d', 'Quel est le pluriel correct de « le jeu » ?', '[{"id":"a","text":"les jeux"},{"id":"b","text":"les jeus"},{"id":"c","text":"le jeux"},{"id":"d","text":"des jeu"}]'::jsonb, 'a', 'Les noms en -eu forment leur pluriel en -eux : un jeu → des jeux, et « le » devient « les » au pluriel : les jeux. La forme « jeus » avec un simple -s est fautive.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4b758dba-e34c-5346-914b-0640115d7266', 'c02898af-a58e-5b2f-8c43-ae6986f9646d', 'Choisis l''article correct : « Il y a ___ pommes dans le panier. »', '[{"id":"a","text":"une"},{"id":"b","text":"un"},{"id":"c","text":"la"},{"id":"d","text":"des"}]'::jsonb, 'd', '« Pommes » est au pluriel (plusieurs pommes), donc l''article indéfini est « des » : des pommes. « Une » est le singulier féminin, et « un »/« la » ne marquent pas le pluriel.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b6dc861f-3417-59a0-a428-00b4864a23df', 'e6d7c80a-52bd-5273-a275-3c8a18a54b01', 'francais-a1', '⚔️ Boss du chapitre ⭐⭐⭐ : articles, genre et pluriel', 3, 120, 30, 'boss', 'admin', 3)
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
  ('9d62d265-c183-513d-aeab-61eb5d67294b', 'b6dc861f-3417-59a0-a428-00b4864a23df', 'Choisis la bonne suite : « J''ai acheté ___ voiture hier. ___ voiture est rouge. »', '[{"id":"a","text":"la … Une"},{"id":"b","text":"une … Une"},{"id":"c","text":"une … La"},{"id":"d","text":"la … La"}]'::jsonb, 'c', 'La première mention d''une chose inconnue prend l''indéfini « une » : j''ai acheté une voiture. La seconde mention est maintenant connue des deux interlocuteurs, donc on passe au défini « la » : la voiture est rouge. Ce passage « une → la » est le cœur du système des articles.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9ab4202e-dc67-5397-a3dc-83c428a28fa9', 'b6dc861f-3417-59a0-a428-00b4864a23df', 'Quel est le pluriel correct de « un journal » ?', '[{"id":"a","text":"des journals"},{"id":"b","text":"des journaux"},{"id":"c","text":"des journal"},{"id":"d","text":"les journals"}]'::jsonb, 'b', 'Les noms en -al forment leur pluriel en -aux : un journal → des journaux (comme animal → animaux). La forme régulière « journals » applique à tort la règle du -s.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('662e53f7-735c-514d-b9bb-a6f5d3f4dd97', 'b6dc861f-3417-59a0-a428-00b4864a23df', 'Trouve le groupe nominal INCORRECT.', '[{"id":"a","text":"des châteaux"},{"id":"b","text":"les cheveux"},{"id":"c","text":"des oiseaux"},{"id":"d","text":"des chevals"}]'::jsonb, 'd', 'La forme fautive est « des chevals » : « cheval » est un nom en -al, son pluriel est « chevaux ». Les autres sont corrects — château → châteaux (-eau), cheveu → cheveux (-eu) et oiseau → oiseaux (-eau).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('097397e3-f28e-59b5-8fce-7917f3684ef2', 'b6dc861f-3417-59a0-a428-00b4864a23df', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Je regarde le table dans la salle."},{"id":"b","text":"Les enfants jouent dans le jardin."},{"id":"c","text":"L''école ouvre à huit heures."},{"id":"d","text":"J''ai un ami à Paris."}]'::jsonb, 'a', 'L''erreur est « le table » : « table » est féminin, donc on dit « la table », pas « le table ». Les autres phrases sont correctes — les enfants (pluriel), l''école (élision devant voyelle) et un ami (masculin singulier).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1697a810-1ea0-59f3-bdb1-650f92337450', 'b6dc861f-3417-59a0-a428-00b4864a23df', 'Choisis la phrase entièrement correcte.', '[{"id":"a","text":"Il y a trois animals dans le parc."},{"id":"b","text":"Il y a trois animaux dans le parc."},{"id":"c","text":"Il y a trois animal dans le parc."},{"id":"d","text":"Il y a trois animaux dans la parc."}]'::jsonb, 'b', '« Animal » est un nom en -al, donc son pluriel est « animaux » : trois animaux. La forme « animals » est fautive, « animal » reste au singulier après « trois », et « la parc » est une erreur de genre (parc est masculin : le parc).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b6d48fd1-10d2-54c5-9c09-87c09445c80b', 'b6dc861f-3417-59a0-a428-00b4864a23df', 'Choisis la bonne suite : « Je connais ___ homme. ___ homme est médecin. »', '[{"id":"a","text":"l'' … Un"},{"id":"b","text":"un … Un"},{"id":"c","text":"un … L''"},{"id":"d","text":"l'' … L''"}]'::jsonb, 'c', 'La première mention prend l''indéfini « un » (un homme parmi d''autres), puis la seconde, désormais connue, prend le défini, qui s''élide en « l'' » devant le h muet : l''homme est médecin. On ne dit jamais « le homme », d''où l''élision.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('65cdc111-8305-5cd6-92e2-be14376fcf92', 'e6d7c80a-52bd-5273-a275-3c8a18a54b01', 'francais-a1', '👑 Défi élite ⭐⭐⭐⭐ : articles, genre et pluriel', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('fcea970a-b2f2-532b-8eb6-2dd1517e1a68', '65cdc111-8305-5cd6-92e2-be14376fcf92', 'Complète : « ___ enfant joue avec ___ jeux dans ___ jardin. »', '[{"id":"a","text":"Le … les … le"},{"id":"b","text":"L'' … des … le"},{"id":"c","text":"Un … le … les"},{"id":"d","text":"L'' … les … le"}]'::jsonb, 'd', '« Enfant » commence par une voyelle, donc « le » s''élide en « l'' » : l''enfant. « Jeux » est un pluriel défini (les jeux) et « jardin » un masculin singulier défini (le jardin). La suite correcte est donc « L'' … les … le ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e8cdc574-3e3a-5796-ad6a-d1f5629f577c', '65cdc111-8305-5cd6-92e2-be14376fcf92', 'Trouve le groupe nominal INCORRECT.', '[{"id":"a","text":"des gâteaux"},{"id":"b","text":"les journaux"},{"id":"c","text":"des jeus"},{"id":"d","text":"les hôpitaux"}]'::jsonb, 'c', 'La forme fautive est « des jeus » : « jeu » est un nom en -eu, son pluriel est « jeux ». Les autres sont corrects — gâteau → gâteaux (-eau), journal → journaux (-al) et hôpital → hôpitaux (-al).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e947138c-d108-51d1-a9f1-9318971f56b6', '65cdc111-8305-5cd6-92e2-be14376fcf92', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Paul a deux beaux chevals."},{"id":"b","text":"Les animaux du zoo sont nombreux."},{"id":"c","text":"L''homme lit le journal le matin."},{"id":"d","text":"J''aime les gâteaux de ma grand-mère."}]'::jsonb, 'a', 'L''erreur est « deux beaux chevals » : « cheval » est un nom en -al, son pluriel est « chevaux ». Les autres phrases sont correctes — les animaux (-al → -aux), l''homme (élision devant h muet) et les gâteaux (-eau → -eaux).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b5e7f02-7556-51bd-b621-e77dc4f0998a', '65cdc111-8305-5cd6-92e2-be14376fcf92', 'Choisis la phrase entièrement correcte.', '[{"id":"a","text":"Le école a beaucoup des élèves."},{"id":"b","text":"L''école a beaucoup d''animaux savants."},{"id":"c","text":"La école a beaucoup de chevals."},{"id":"d","text":"L''école a beaucoup de animals."}]'::jsonb, 'b', 'La phrase correcte est (b) : « école » s''élide en « l''école » (voyelle) et « animal » fait son pluriel en « animaux ». (a) et (c) gardent « le/la » devant la voyelle au lieu de « l'' », et (c)/(d) écrivent « chevals/animals » au lieu de « chevaux/animaux ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63d8e141-c222-543d-bb24-8598e4c07738', '65cdc111-8305-5cd6-92e2-be14376fcf92', 'Complète : « Dans la ville, il y a ___ hôpital, ___ écoles et ___ château. »', '[{"id":"a","text":"des … un … une"},{"id":"b","text":"un … un … un"},{"id":"c","text":"une … des … un"},{"id":"d","text":"un … des … un"}]'::jsonb, 'd', '« Hôpital » est masculin singulier (un hôpital), « écoles » est un pluriel (des écoles) et « château » est masculin singulier (un château). La suite correcte est donc « un … des … un ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92e5d9c6-1146-5df5-9bb1-928c031448a2', '65cdc111-8305-5cd6-92e2-be14376fcf92', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Le table est dans la cuisine."},{"id":"b","text":"Les oiseaux chantent dans les arbres."},{"id":"c","text":"J''ai vu un homme et une femme."},{"id":"d","text":"L''amie de Léa habite ici."}]'::jsonb, 'a', 'L''erreur est « le table » : « table » est féminin, donc on dit « la table ». Les autres phrases sont correctes — les oiseaux/les arbres (pluriels), un homme et une femme (genres accordés) et l''amie (élision devant voyelle, féminin).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e7e84386-cad2-55ed-b339-529f55a6beb0', 'e6d7c80a-52bd-5273-a275-3c8a18a54b01', 'francais-a1', '⭐⭐ Drill : articles, genre et pluriel', 2, 75, 15, 'practice', 'admin', 5)
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
  ('9fad2be6-430a-59c1-9a97-f640401685c0', 'e7e84386-cad2-55ed-b339-529f55a6beb0', 'Choisis l''article correct : « Je mange ___ pomme. »', '[{"id":"a","text":"un"},{"id":"b","text":"le"},{"id":"c","text":"une"},{"id":"d","text":"des"}]'::jsonb, 'c', '« Pomme » est un nom féminin singulier, donc l''article indéfini est « une » : une pomme. La forme « un » est masculine, « le » est un défini masculin, et « des » serait un pluriel.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8c84a417-4281-5b0b-84de-f491a8f8c51e', 'e7e84386-cad2-55ed-b339-529f55a6beb0', 'Choisis la bonne forme : « ___ ami de Sophie arrive demain. »', '[{"id":"a","text":"Le"},{"id":"b","text":"L''"},{"id":"c","text":"La"},{"id":"d","text":"Un"}]'::jsonb, 'b', '« Ami » commence par la voyelle « a », donc « le » devient « l'' » par élision : l''ami. On n''écrit jamais « le ami », et « la » serait une erreur de genre (ami est masculin).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cbdca000-2b53-5c00-b30c-850c88642ca3', 'e7e84386-cad2-55ed-b339-529f55a6beb0', 'Quel est le pluriel correct de « un château » ?', '[{"id":"a","text":"des châteaux"},{"id":"b","text":"des châteaus"},{"id":"c","text":"des château"},{"id":"d","text":"les châteaus"}]'::jsonb, 'a', 'Les noms en -eau forment leur pluriel en -eaux : un château → des châteaux. La forme régulière « châteaus » avec un simple -s est fautive.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b1460eaa-5d5c-5561-9cfc-f038fc4e3779', 'e7e84386-cad2-55ed-b339-529f55a6beb0', 'Choisis l''article correct : « ___ cheveux de Léa sont longs. »', '[{"id":"a","text":"Le"},{"id":"b","text":"La"},{"id":"c","text":"Un"},{"id":"d","text":"Les"}]'::jsonb, 'd', '« Cheveux » est au pluriel (cheveu → cheveux, nom en -eu), donc l''article défini est « les » : les cheveux. « Le »/« la » sont des définis singuliers et « un » un indéfini singulier.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be9b2d2f-7d61-5e2b-b055-2470a808d9ff', 'e7e84386-cad2-55ed-b339-529f55a6beb0', 'Choisis la phrase entièrement correcte.', '[{"id":"a","text":"Il y a deux journals sur la table."},{"id":"b","text":"Il y a deux journaux sur la table."},{"id":"c","text":"Il y a deux journaux sur le table."},{"id":"d","text":"Il y a deux journal sur la table."}]'::jsonb, 'b', '« Journal » est un nom en -al, donc son pluriel est « journaux » : deux journaux. La forme « journals » est fautive, « journal » reste singulier après « deux », et « le table » est une erreur de genre (table est féminin : la table).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('20e87c2b-4a20-5ccf-b3c3-1f28bcb3742c', 'e7e84386-cad2-55ed-b339-529f55a6beb0', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"L''école est fermée le dimanche."},{"id":"b","text":"Les animaux dorment la nuit."},{"id":"c","text":"J''ai mangé un bon gâteaux."},{"id":"d","text":"La lune brille dans le ciel."}]'::jsonb, 'c', 'L''erreur est « un bon gâteaux » : après l''article singulier « un », le nom doit rester au singulier (« un gâteau »), le -eaux étant la marque du pluriel. Les autres phrases sont correctes — l''école (élision), les animaux (pluriel en -aux) et la lune (féminin singulier).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1bcff293-e5e6-5d46-83ee-6a0c0e94c0df', '3505bbef-6146-594f-9991-1a08b85ac866', 'francais-a1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('44da0cce-a632-5007-8136-73696505228b', '1bcff293-e5e6-5d46-83ee-6a0c0e94c0df', 'Le matin, pour saluer quelqu''un, on dit…', '[{"id":"a","text":"Bonjour"},{"id":"b","text":"Bonsoir"},{"id":"c","text":"Au revoir"},{"id":"d","text":"Merci"}]'::jsonb, 'a', 'On dit « Bonjour » le matin et pendant la journée. « Bonsoir » se réserve au soir, « Au revoir » sert à partir, et « Merci » sert à remercier. Entre amis, on peut aussi dire « Salut ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07c47d92-6981-5c97-b6ba-328f83c1d5ed', '1bcff293-e5e6-5d46-83ee-6a0c0e94c0df', 'Trouve l''intrus.', '[{"id":"a","text":"rouge"},{"id":"b","text":"bleu"},{"id":"c","text":"vert"},{"id":"d","text":"lundi"}]'::jsonb, 'd', 'Rouge, bleu et vert sont des couleurs ; lundi est un jour de la semaine, c''est donc l''intrus. Classer les mots par champ (couleurs, jours, famille) aide à les retenir.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('04dc679f-e7a7-5327-a965-8ad3b5ef1076', '1bcff293-e5e6-5d46-83ee-6a0c0e94c0df', 'Complète : « J''___ douze ans. »', '[{"id":"a","text":"suis"},{"id":"b","text":"ai"},{"id":"c","text":"habite"},{"id":"d","text":"appelle"}]'::jsonb, 'b', 'En français, l''âge se dit avec le verbe avoir : « J''ai douze ans. » On n''utilise jamais être pour l''âge (« je suis douze ans » est faux). « Habite » sert à dire la ville et « appelle » à donner le nom.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0e3b5132-0147-57d3-b834-7ad7edb5b080', '1bcff293-e5e6-5d46-83ee-6a0c0e94c0df', 'Le père de ton père est ton…', '[{"id":"a","text":"fils"},{"id":"b","text":"frère"},{"id":"c","text":"grand-père"},{"id":"d","text":"père"}]'::jsonb, 'c', 'Le père de ton père (ou de ta mère) est ton grand-père ; sa femme est ta grand-mère. Ton fils est ton propre enfant, ton frère est un garçon de la même génération que toi, et ton père est celui qui t''élève.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9dfc13c-ebb0-52a0-b065-947a6f7255a8', '1bcff293-e5e6-5d46-83ee-6a0c0e94c0df', 'Quel nombre s''écrit « quarante » ?', '[{"id":"a","text":"14"},{"id":"b","text":"40"},{"id":"c","text":"44"},{"id":"d","text":"50"}]'::jsonb, 'b', '« Quarante » est le nombre 40. À ne pas confondre avec « quatorze » (14) qui lui ressemble, ni avec « cinquante » (50). On écrit quarante avec un seul r.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c59cd147-cdaa-5d3e-9949-24640ea62a74', '3505bbef-6146-594f-9991-1a08b85ac866', 'francais-a1', '⭐ Entraînement : se présenter et mots courants', 1, 50, 10, 'practice', 'admin', 1)
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
  ('6dc4d2d8-30e0-55c2-9cb3-c6506272e08f', 'c59cd147-cdaa-5d3e-9949-24640ea62a74', 'Pour donner ton nom, tu dis : « Je ___ Yahia. »', '[{"id":"a","text":"habite"},{"id":"b","text":"m''appelle"},{"id":"c","text":"ai"},{"id":"d","text":"suis"}]'::jsonb, 'b', 'Pour donner son nom, on dit « Je m''appelle… ». « Habite » sert à dire la ville (J''habite à Tunis), « ai » sert à donner l''âge (J''ai dix ans), et « suis » sert à la nationalité ou la profession (Je suis élève).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad1a35e7-77ad-5380-95c8-276c137ca4c2', 'c59cd147-cdaa-5d3e-9949-24640ea62a74', 'Trouve l''intrus.', '[{"id":"a","text":"lundi"},{"id":"b","text":"mardi"},{"id":"c","text":"rouge"},{"id":"d","text":"vendredi"}]'::jsonb, 'c', 'Lundi, mardi et vendredi sont des jours de la semaine ; rouge est une couleur, c''est donc l''intrus. En français, les jours s''écrivent en minuscule.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('817df0f3-994d-593d-89f4-3fd3ffde9299', 'c59cd147-cdaa-5d3e-9949-24640ea62a74', 'Pour remercier quelqu''un, on dit…', '[{"id":"a","text":"Merci"},{"id":"b","text":"Pardon"},{"id":"c","text":"Bonsoir"},{"id":"d","text":"Au revoir"}]'::jsonb, 'a', 'On dit « Merci » pour remercier. « Pardon » sert à s''excuser, « Bonsoir » à saluer le soir, et « Au revoir » à partir. Pour demander poliment, on ajoute « s''il vous plaît ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('584dc01f-979a-51c6-b547-50ccb4dc4434', 'c59cd147-cdaa-5d3e-9949-24640ea62a74', 'Quel mot est une couleur ?', '[{"id":"a","text":"frère"},{"id":"b","text":"juin"},{"id":"c","text":"merci"},{"id":"d","text":"jaune"}]'::jsonb, 'd', 'Jaune est une couleur. Frère est un mot de la famille, juin est un mois de l''année, et merci est une formule de politesse, donc aucun des trois n''est une couleur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('582028d4-27fe-52e4-ad20-072c93bd7aaa', 'c59cd147-cdaa-5d3e-9949-24640ea62a74', 'Complète : « J''habite ___ Tunis. »', '[{"id":"a","text":"de"},{"id":"b","text":"en"},{"id":"c","text":"à"},{"id":"d","text":"ans"}]'::jsonb, 'c', 'Devant le nom d''une ville, on utilise « à » : J''habite à Tunis. « En » s''emploie plutôt devant un pays féminin (en France), « de » indique l''origine, et « ans » sert pour l''âge (j''ai dix ans).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24311e07-fbb7-59aa-b343-3a402bc182f6', 'c59cd147-cdaa-5d3e-9949-24640ea62a74', 'Trouve l''intrus (le mot qui n''est PAS un membre de la famille).', '[{"id":"a","text":"mère"},{"id":"b","text":"août"},{"id":"c","text":"fils"},{"id":"d","text":"sœur"}]'::jsonb, 'b', 'Mère, fils et sœur sont des membres de la famille. Août est un mois de l''année, c''est donc l''intrus. Ranger les mots par champ (famille, mois, couleurs) aide à mieux les mémoriser.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e9c13bd1-56c5-5930-bd83-cbfccb41760e', '3505bbef-6146-594f-9991-1a08b85ac866', 'francais-a1', '⭐⭐ Révision : se présenter et mots courants', 2, 75, 15, 'practice', 'admin', 2)
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
  ('c8df1e1c-3f15-545e-bf0f-6ffa6c8670df', 'e9c13bd1-56c5-5930-bd83-cbfccb41760e', 'Quelle question sert à demander le nom de quelqu''un ?', '[{"id":"a","text":"Quel âge as-tu ?"},{"id":"b","text":"Où habites-tu ?"},{"id":"c","text":"Quelle heure est-il ?"},{"id":"d","text":"Comment tu t''appelles ?"}]'::jsonb, 'd', '« Comment tu t''appelles ? » (ou la forme polie « Comment vous appelez-vous ? ») sert à demander le nom. « Quel âge as-tu ? » demande l''âge, et « Où habites-tu ? » demande la ville.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('298050a5-e505-5f04-b29b-0cb01c04f2df', 'e9c13bd1-56c5-5930-bd83-cbfccb41760e', 'Complète ce mini-dialogue. — Bonjour ! — ___, je voudrais un café, s''il vous plaît.', '[{"id":"a","text":"Au revoir"},{"id":"b","text":"Bonjour"},{"id":"c","text":"Merci"},{"id":"d","text":"Pardon"}]'::jsonb, 'b', 'Quand on te dit « Bonjour ! », tu réponds par « Bonjour » à ton tour. « Au revoir » sert à partir, « Merci » à remercier, et « Pardon » à s''excuser : aucun ne convient pour répondre à une salutation.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5429a45c-543d-5c30-87b4-7dbaacf105b2', 'e9c13bd1-56c5-5930-bd83-cbfccb41760e', 'Quel nombre s''écrit « cinquante » ?', '[{"id":"a","text":"15"},{"id":"b","text":"40"},{"id":"c","text":"50"},{"id":"d","text":"60"}]'::jsonb, 'c', '« Cinquante » est le nombre 50. Ne le confonds pas avec « quinze » (15) qui commence pareil, « quarante » (40) ou « soixante » (60). On l''écrit avec qu : cinquante.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4eddcd6b-740a-5a55-aa5c-e382696b9d52', 'e9c13bd1-56c5-5930-bd83-cbfccb41760e', 'Trouve l''intrus (le mot qui n''est PAS un mois).', '[{"id":"a","text":"mercredi"},{"id":"b","text":"mars"},{"id":"c","text":"avril"},{"id":"d","text":"octobre"}]'::jsonb, 'a', 'Mars, avril et octobre sont des mois de l''année. Mercredi est un jour de la semaine, c''est donc l''intrus. Le piège : mercredi et mars commencent par les mêmes lettres, mais l''un est un jour et l''autre un mois.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a58f847e-feba-5095-836d-b63052bb054d', 'e9c13bd1-56c5-5930-bd83-cbfccb41760e', 'Pour t''excuser ou attirer l''attention de quelqu''un poliment, tu dis…', '[{"id":"a","text":"Salut"},{"id":"b","text":"Excusez-moi"},{"id":"c","text":"Bonsoir"},{"id":"d","text":"Merci"}]'::jsonb, 'b', '« Excusez-moi » (comme « pardon ») sert à s''excuser ou à attirer poliment l''attention. « Salut » est une salutation familière, « Bonsoir » salue le soir, et « Merci » remercie.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2218752f-657c-5fc1-b9c1-46ab5f99b056', 'e9c13bd1-56c5-5930-bd83-cbfccb41760e', 'La fille de ton père et de ta mère est ta…', '[{"id":"a","text":"mère"},{"id":"b","text":"fille"},{"id":"c","text":"grand-mère"},{"id":"d","text":"sœur"}]'::jsonb, 'd', 'La fille de tes parents (la même que toi) est ta sœur. Ta mère est celle qui t''élève, ta fille serait ton propre enfant, et ta grand-mère est la mère de ton parent. Frère (garçon) et sœur (fille) forment une paire.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0f2721aa-166a-5d7c-97fd-e1a0c77384a7', '3505bbef-6146-594f-9991-1a08b85ac866', 'francais-a1', '⚔️ Boss du chapitre ⭐⭐⭐ : se présenter et mots courants', 3, 120, 30, 'boss', 'admin', 3)
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
  ('5637a5ff-fa93-52c1-8612-67707971a16a', '0f2721aa-166a-5d7c-97fd-e1a0c77384a7', 'La mère de ta mère est ta…', '[{"id":"a","text":"sœur"},{"id":"b","text":"fille"},{"id":"c","text":"grand-mère"},{"id":"d","text":"mère"}]'::jsonb, 'c', 'La mère de ta mère (ou de ton père) est ta grand-mère ; son mari est ton grand-père. Ta sœur est de ta génération, ta fille serait ton enfant, et ta mère est celle qui t''élève — toutes plus proches d''une génération qu''une grand-mère.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1fa6c14-bf9e-5140-b857-d7801333423a', '0f2721aa-166a-5d7c-97fd-e1a0c77384a7', 'Complète ce mini-dialogue. — Comment vous appelez-vous ? — ___ Léa Martin.', '[{"id":"a","text":"Je m''appelle"},{"id":"b","text":"J''ai"},{"id":"c","text":"J''habite"},{"id":"d","text":"Je suis de"}]'::jsonb, 'a', 'À la question « Comment vous appelez-vous ? » on répond « Je m''appelle Léa Martin ». « J''ai » sert à l''âge, « J''habite » à la ville, et « Je suis de » indique l''origine — aucun ne convient pour annoncer son nom.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9f7df10-822d-5d8a-bcf3-fe962b09b8a8', '0f2721aa-166a-5d7c-97fd-e1a0c77384a7', 'Quel nombre s''écrit « soixante-neuf » ?', '[{"id":"a","text":"59"},{"id":"b","text":"66"},{"id":"c","text":"70"},{"id":"d","text":"69"}]'::jsonb, 'd', '« Soixante-neuf » se décompose en soixante (60) + neuf (9) = 69. Ne le confonds pas avec cinquante-neuf (59) ni avec soixante (60) seul. C''est le dernier nombre formé sur soixante avant soixante-dix.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('caa1fbac-b20d-5408-978b-329f8654c175', '0f2721aa-166a-5d7c-97fd-e1a0c77384a7', 'Trouve l''intrus (le mot qui n''est PAS une formule de politesse).', '[{"id":"a","text":"merci"},{"id":"b","text":"marron"},{"id":"c","text":"pardon"},{"id":"d","text":"s''il vous plaît"}]'::jsonb, 'b', 'Merci, pardon et s''il vous plaît sont des formules de politesse. Marron est une couleur, c''est donc l''intrus. Le piège : marron et merci commencent par la lettre m, mais l''un est une couleur et l''autre un remerciement.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('499dd3e8-1fc7-5016-932c-d0931d13a0a8', '0f2721aa-166a-5d7c-97fd-e1a0c77384a7', 'Quelle phrase est correcte pour dire ton âge ?', '[{"id":"a","text":"Je suis treize ans."},{"id":"b","text":"J''ai treize."},{"id":"c","text":"J''ai treize ans."},{"id":"d","text":"Je m''appelle treize ans."}]'::jsonb, 'c', 'Pour l''âge, on emploie avoir + le nombre + ans : « J''ai treize ans. » « Je suis treize ans » est faux (on n''utilise pas être), « J''ai treize » oublie le mot ans, et « Je m''appelle » sert au nom. C''est le piège le plus courant en français pour les débutants.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('99d9fded-e695-5134-a076-baef0f217966', '0f2721aa-166a-5d7c-97fd-e1a0c77384a7', 'Dans la phrase « ___ ! À demain. », quelle salutation convient pour partir le soir ?', '[{"id":"a","text":"Bonsoir"},{"id":"b","text":"Bonjour"},{"id":"c","text":"Merci"},{"id":"d","text":"S''il vous plaît"}]'::jsonb, 'a', 'Le soir, pour saluer en partant, on peut dire « Bonsoir ! À demain » (ou « Au revoir »). « Bonjour » se dit le matin et la journée, « Merci » remercie, et « S''il vous plaît » sert à demander : aucun ne convient pour partir le soir.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f831a806-892f-5ce0-adff-bb7e0ae7720c', '3505bbef-6146-594f-9991-1a08b85ac866', 'francais-a1', '👑 Défi élite ⭐⭐⭐⭐ : se présenter et mots courants', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('d51e6849-b703-5786-bd44-9a0e3bd82fbd', 'f831a806-892f-5ce0-adff-bb7e0ae7720c', 'Lis : « Je m''appelle Sami, j''ai vingt et un ans et j''habite à Sfax. » Quel âge a Sami ?', '[{"id":"a","text":"12 ans"},{"id":"b","text":"21 ans"},{"id":"c","text":"20 ans"},{"id":"d","text":"31 ans"}]'::jsonb, 'b', '« Vingt et un » se décompose en vingt (20) + un (1) = 21. Sami a donc 21 ans. Ne confonds pas avec douze (12), vingt (20) seul, ou trente et un (31).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3268b362-e563-5ac2-bcd4-e99a57efb743', 'f831a806-892f-5ce0-adff-bb7e0ae7720c', 'Range ces nombres dans l''ordre croissant : trente, quinze, soixante, quarante. Lequel vient en dernier (le plus grand) ?', '[{"id":"a","text":"quinze"},{"id":"b","text":"trente"},{"id":"c","text":"quarante"},{"id":"d","text":"soixante"}]'::jsonb, 'd', 'Dans l''ordre croissant : quinze (15) < trente (30) < quarante (40) < soixante (60). Le plus grand est donc soixante (60). C''est le seul des quatre qui dépasse 50.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e79842a9-75be-5192-ba1e-51f48ddceb6e', 'f831a806-892f-5ce0-adff-bb7e0ae7720c', 'Associe la situation à la bonne formule : tu bouscules quelqu''un sans le vouloir. Tu dis…', '[{"id":"a","text":"Pardon !"},{"id":"b","text":"Bonjour !"},{"id":"c","text":"Merci !"},{"id":"d","text":"À demain !"}]'::jsonb, 'a', 'Quand on bouscule quelqu''un, on s''excuse en disant « Pardon ! » (ou « Excusez-moi ! »). « Bonjour » salue, « Merci » remercie, et « À demain » sert à partir : aucun ne convient pour s''excuser.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4aea4da9-c8f1-58e1-abf7-91d9c55d20ab', 'f831a806-892f-5ce0-adff-bb7e0ae7720c', 'Lis : « Mon père a une sœur. Cette sœur a un fils, Karim. » Karim et toi êtes…', '[{"id":"a","text":"frères"},{"id":"b","text":"père et fils"},{"id":"c","text":"cousins"},{"id":"d","text":"grand-père et petit-fils"}]'::jsonb, 'c', 'La sœur de ton père est ta tante, et le fils de ta tante est ton cousin : Karim et toi êtes donc cousins. Vous n''êtes pas frères (vous n''avez pas les mêmes parents), ni d''une génération différente comme père/fils ou grand-père/petit-fils.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('250acf66-4ecd-5919-a740-a7a5fa8b1913', 'f831a806-892f-5ce0-adff-bb7e0ae7720c', 'Complète le mini-dialogue. — Bonjour, ___ ? — Je m''appelle Inès.', '[{"id":"a","text":"quel âge as-tu"},{"id":"b","text":"où habites-tu"},{"id":"c","text":"quelle heure est-il"},{"id":"d","text":"comment tu t''appelles"}]'::jsonb, 'd', 'La réponse « Je m''appelle Inès » donne un nom : la question posée était donc « comment tu t''appelles ? ». « Quel âge as-tu » appelle un âge, « où habites-tu » une ville, et « quelle heure est-il » une heure — aucun ne s''accorde avec la réponse.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ab3551e6-d1e3-5863-a599-30c32f589cf2', 'f831a806-892f-5ce0-adff-bb7e0ae7720c', 'Trouve l''intrus (le mot qui n''appartient PAS au même champ que les autres).', '[{"id":"a","text":"lundi"},{"id":"b","text":"bleu"},{"id":"c","text":"jeudi"},{"id":"d","text":"dimanche"}]'::jsonb, 'b', 'Lundi, jeudi et dimanche sont des jours de la semaine ; bleu est une couleur, c''est donc l''intrus. Le piège : tous les mots sont courts et familiers, mais trois forment un même champ (les jours) et un seul en sort.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a1044b76-ad22-59fa-9317-fc8718ec63a1', '3505bbef-6146-594f-9991-1a08b85ac866', 'francais-a1', '⭐⭐ Drill : vocabulaire du quotidien', 2, 75, 15, 'practice', 'admin', 5)
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
  ('c91bcd69-98e4-5552-bd28-6f41a865d209', 'a1044b76-ad22-59fa-9317-fc8718ec63a1', 'Pour dire ta nationalité, tu dis : « Je ___ tunisien. »', '[{"id":"a","text":"ai"},{"id":"b","text":"m''appelle"},{"id":"c","text":"suis"},{"id":"d","text":"habite"}]'::jsonb, 'c', 'Pour la nationalité ou la profession, on utilise être : « Je suis tunisien. » « Ai » sert à l''âge, « m''appelle » au nom, et « habite » à la ville. Le verbe être relie ce que tu es.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14f7576f-2b79-58bf-a2f1-fff7a3e74a23', 'a1044b76-ad22-59fa-9317-fc8718ec63a1', 'Trouve l''intrus.', '[{"id":"a","text":"février"},{"id":"b","text":"samedi"},{"id":"c","text":"dimanche"},{"id":"d","text":"lundi"}]'::jsonb, 'a', 'Samedi, dimanche et lundi sont des jours de la semaine ; février est un mois de l''année, c''est donc l''intrus. Les jours et les mois s''écrivent en minuscule en français.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36ec7d61-9631-5b47-8d5b-8723d950145b', 'a1044b76-ad22-59fa-9317-fc8718ec63a1', 'Quel nombre s''écrit « trente-cinq » ?', '[{"id":"a","text":"25"},{"id":"b","text":"53"},{"id":"c","text":"30"},{"id":"d","text":"35"}]'::jsonb, 'd', '« Trente-cinq » se décompose en trente (30) + cinq (5) = 35. Ne le confonds pas avec vingt-cinq (25), trente (30) seul, ou les chiffres inversés (53).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0a2471c4-464c-522d-928a-f6cd3c9f53d7', 'a1044b76-ad22-59fa-9317-fc8718ec63a1', 'Quel mot est une couleur ?', '[{"id":"a","text":"mardi"},{"id":"b","text":"noir"},{"id":"c","text":"père"},{"id":"d","text":"merci"}]'::jsonb, 'b', 'Noir est une couleur. Mardi est un jour de la semaine, père est un mot de la famille, et merci est une formule de politesse, donc aucun des trois n''est une couleur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c19cfe80-f61d-5a87-af8b-934c05afc683', 'a1044b76-ad22-59fa-9317-fc8718ec63a1', 'Complète ce mini-dialogue. — Voici un cadeau pour toi ! — Oh, ___ beaucoup !', '[{"id":"a","text":"merci"},{"id":"b","text":"pardon"},{"id":"c","text":"bonsoir"},{"id":"d","text":"au revoir"}]'::jsonb, 'a', 'Quand on reçoit un cadeau, on remercie : « Merci beaucoup ! ». « Pardon » sert à s''excuser, « bonsoir » à saluer le soir, et « au revoir » à partir : aucun ne convient pour remercier.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2076a795-b582-5247-bb30-0b3914a9dbe0', 'a1044b76-ad22-59fa-9317-fc8718ec63a1', 'Lis : « Ma mère a un fils, Adam, et une fille, moi. » Qui est Adam pour moi ?', '[{"id":"a","text":"mon père"},{"id":"b","text":"mon grand-père"},{"id":"c","text":"mon frère"},{"id":"d","text":"mon fils"}]'::jsonb, 'c', 'Adam et moi avons la même mère : Adam, qui est un garçon (le fils de ma mère), est donc mon frère. Mon père et mon grand-père sont d''une génération au-dessus, et mon fils serait mon propre enfant — seul frère convient.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2bc590d3-fcf6-559e-aea1-8c3ecf6b5095', 'a686a8b9-c332-5edc-b561-909cc0ccb468', 'francais-a1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('e40379d5-2265-5c86-84e6-b2c21bb53b59', '2bc590d3-fcf6-559e-aea1-8c3ecf6b5095', 'Quel mot interrogatif demande un LIEU ?', '[{"id":"a","text":"Où"},{"id":"b","text":"Quand"},{"id":"c","text":"Comment"},{"id":"d","text":"Pourquoi"}]'::jsonb, 'a', '« Où » interroge sur un lieu (Où habites-tu ? — À Tunis). « Quand » demande un moment, « comment » une manière et « pourquoi » une raison. Chaque mot interrogatif attend un type de réponse différent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fca87733-2061-5da1-b8c0-dad43a74dc0a', '2bc590d3-fcf6-559e-aea1-8c3ecf6b5095', 'Choisis la question correcte au registre courant : « ___ tu viens ? »', '[{"id":"a","text":"Viens-tu"},{"id":"b","text":"Est-ce que"},{"id":"c","text":"Que est-ce que"},{"id":"d","text":"Est-ce-que tu viens-tu"}]'::jsonb, 'b', 'Au registre courant, on ajoute « est-ce que » devant l''ordre normal sujet + verbe : Est-ce que tu viens ? « Viens-tu » est l''inversion (registre soutenu), et on ne combine jamais « est-ce que » avec une inversion.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e74434d2-d686-5970-8257-014632eeba2e', '2bc590d3-fcf6-559e-aea1-8c3ecf6b5095', 'Quelle est la forme négative de « Je parle anglais. » ?', '[{"id":"a","text":"Je parle ne pas anglais."},{"id":"b","text":"Je ne pas parle anglais."},{"id":"c","text":"Je ne parle pas anglais."},{"id":"d","text":"Je parle pas ne anglais."}]'::jsonb, 'c', '« ne … pas » encadre le verbe conjugué : ne avant, pas après → Je ne parle pas anglais. Les autres formes placent mal « ne » ou « pas » autour du verbe.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f19414b0-88ac-52e8-a4e1-d4de032d8137', '2bc590d3-fcf6-559e-aea1-8c3ecf6b5095', 'Complète : « ___ heure est-il ? »', '[{"id":"a","text":"Quel"},{"id":"b","text":"Quelle"},{"id":"c","text":"Quels"},{"id":"d","text":"Quelles"}]'::jsonb, 'b', '« heure » est un nom féminin singulier, donc l''adjectif interrogatif s''accorde : Quelle heure est-il ? « Quel » est masculin, « quels » et « quelles » sont au pluriel, ce qui ne convient pas à « heure » singulier féminin.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9cb7eca-7c37-528f-8cf4-579374c15846', '2bc590d3-fcf6-559e-aea1-8c3ecf6b5095', 'Mets à la forme négative : « J''ai une voiture. »', '[{"id":"a","text":"Je n''ai pas une voiture."},{"id":"b","text":"Je ai pas de voiture."},{"id":"c","text":"Je n''ai pas de voiture."},{"id":"d","text":"Je n''ai de pas voiture."}]'::jsonb, 'c', 'Après la négation, l''article indéfini « une » devient « de », et « ne » s''élide en « n'' » devant la voyelle de « ai » : Je n''ai pas de voiture. Garder « pas une » (a) est une erreur fréquente, et (b) oublie le n'', (d) place mal « de ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cd45e110-11a2-5757-bbb0-f560b76dabbc', 'a686a8b9-c332-5edc-b561-909cc0ccb468', 'francais-a1', '⭐ Entraînement : questions et négation', 1, 50, 10, 'practice', 'admin', 1)
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
  ('a034344a-d73c-53dc-89ed-5edae545ee8a', 'cd45e110-11a2-5757-bbb0-f560b76dabbc', 'Quel mot interrogatif demande une PERSONNE ?', '[{"id":"a","text":"Qui"},{"id":"b","text":"Où"},{"id":"c","text":"Quand"},{"id":"d","text":"Combien"}]'::jsonb, 'a', '« Qui » interroge sur une personne (Qui est là ? — Mon frère). « Où » demande un lieu, « quand » un moment et « combien » une quantité. Chaque mot interrogatif attend un type de réponse précis.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bcca2e39-3ae4-504d-9fa8-89535302e2e7', 'cd45e110-11a2-5757-bbb0-f560b76dabbc', 'Complète : « ___ vas-tu ? » — « Je vais bien, merci. »', '[{"id":"a","text":"Où"},{"id":"b","text":"Quand"},{"id":"c","text":"Comment"},{"id":"d","text":"Pourquoi"}]'::jsonb, 'c', '« Comment » interroge sur la manière ou l''état, donc « Comment vas-tu ? » appelle la réponse « Je vais bien ». « Où » demande un lieu, « quand » un moment et « pourquoi » une raison — aucun ne convient à « Je vais bien ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce2d6d96-f954-5a03-8d1e-652d4cc44fc4', 'cd45e110-11a2-5757-bbb0-f560b76dabbc', 'Choisis la question correcte au registre courant.', '[{"id":"a","text":"Habites-tu est-ce que ici ?"},{"id":"b","text":"Est-ce que tu habites ici ?"},{"id":"c","text":"Tu habites-tu ici ?"},{"id":"d","text":"Est-ce que habites-tu ici ?"}]'::jsonb, 'b', 'Au registre courant, « est-ce que » se place devant l''ordre normal sujet + verbe : Est-ce que tu habites ici ? On ne combine jamais « est-ce que » avec une inversion (d), et « Tu habites-tu » (c) double le sujet.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6df67b64-ec9f-5016-b8a1-3fe6e4898014', 'cd45e110-11a2-5757-bbb0-f560b76dabbc', 'Quelle est la forme négative de « Elle vient. » ?', '[{"id":"a","text":"Elle vient ne pas."},{"id":"b","text":"Elle ne pas vient."},{"id":"c","text":"Elle pas ne vient."},{"id":"d","text":"Elle ne vient pas."}]'::jsonb, 'd', '« ne … pas » encadre le verbe conjugué : ne avant le verbe, pas après → Elle ne vient pas. Les autres options placent mal « ne » ou « pas » autour du verbe « vient ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bcac7bc7-7a80-5dfb-bb73-c00e8624cc75', 'cd45e110-11a2-5757-bbb0-f560b76dabbc', 'Complète : « ___ âge as-tu ? »', '[{"id":"a","text":"Quelle"},{"id":"b","text":"Quels"},{"id":"c","text":"Quel"},{"id":"d","text":"Quelles"}]'::jsonb, 'c', '« âge » est un nom masculin singulier, donc l''adjectif interrogatif est « quel » : Quel âge as-tu ? « Quelle » est féminin, « quels » et « quelles » sont au pluriel, ce qui ne convient pas à « âge ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e072082-2a4a-536d-a8f6-59d6e3be47d0', 'cd45e110-11a2-5757-bbb0-f560b76dabbc', 'Mets à la forme négative : « Il est là. »', '[{"id":"a","text":"Il ne est pas là."},{"id":"b","text":"Il n''est pas là."},{"id":"c","text":"Il est ne pas là."},{"id":"d","text":"Il n''est là pas."}]'::jsonb, 'b', 'Devant la voyelle de « est », « ne » s''élide en « n'' » : Il n''est pas là. « Il ne est pas » (a) oublie l''élision, et « ne pas » doit encadrer le verbe « est », pas se placer ailleurs (c, d).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d44ff6c1-9f43-5fc9-88e1-ee441810bc44', 'a686a8b9-c332-5edc-b561-909cc0ccb468', 'francais-a1', '⭐⭐ Révision : questions et négation', 2, 75, 15, 'practice', 'admin', 2)
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
  ('7b16a2fa-63ba-54cf-8328-c540147a5bfc', 'd44ff6c1-9f43-5fc9-88e1-ee441810bc44', 'Quel mot interrogatif demande une RAISON ?', '[{"id":"a","text":"Comment"},{"id":"b","text":"Quand"},{"id":"c","text":"Combien"},{"id":"d","text":"Pourquoi"}]'::jsonb, 'd', '« Pourquoi » interroge sur une raison (Pourquoi es-tu triste ? — Parce que je suis fatigué). « Comment » demande une manière, « quand » un moment et « combien » une quantité.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5169f77-e4b9-5ae9-bb2c-bef688ef9538', 'd44ff6c1-9f43-5fc9-88e1-ee441810bc44', 'Choisis l''inversion correcte (registre soutenu) pour « Tu as un stylo. »', '[{"id":"a","text":"As-tu un stylo ?"},{"id":"b","text":"Tu as-tu un stylo ?"},{"id":"c","text":"As tu un stylo ?"},{"id":"d","text":"Est-ce que as-tu un stylo ?"}]'::jsonb, 'a', 'L''inversion met le verbe avant le pronom, reliés par un trait d''union : As-tu un stylo ? « Tu as-tu » (b) double le sujet, (c) oublie le trait d''union, et (d) mélange « est-ce que » avec une inversion.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92287f35-9cda-503e-89f9-f96f76f3873f', 'd44ff6c1-9f43-5fc9-88e1-ee441810bc44', 'Complète : « ___ livres aimes-tu ? »', '[{"id":"a","text":"Quel"},{"id":"b","text":"Quels"},{"id":"c","text":"Quelle"},{"id":"d","text":"Quelles"}]'::jsonb, 'b', '« livres » est masculin pluriel, donc l''adjectif interrogatif est « quels » : Quels livres aimes-tu ? « Quel » est singulier, « quelle » et « quelles » sont féminins, ce qui ne s''accorde pas avec « livres ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('523916c2-9df9-5704-af04-a8c2e45144d5', 'd44ff6c1-9f43-5fc9-88e1-ee441810bc44', 'Mets à la forme négative : « Il mange du pain. »', '[{"id":"a","text":"Il ne mange pas du pain."},{"id":"b","text":"Il mange ne pas de pain."},{"id":"c","text":"Il ne mange pas de pain."},{"id":"d","text":"Il ne mange de pas pain."}]'::jsonb, 'c', 'Après la négation, l''article partitif « du » devient « de » : Il ne mange pas de pain. Garder « pas du pain » (a) est l''erreur fréquente, et (b) place mal « ne », (d) sépare « de » de « pain ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c63d490-08e8-5864-b738-e29191d6f681', 'd44ff6c1-9f43-5fc9-88e1-ee441810bc44', 'Quelle question correspond à la réponse « À huit heures. » ?', '[{"id":"a","text":"Où est le cours ?"},{"id":"b","text":"Qui vient au cours ?"},{"id":"c","text":"Combien coûte le cours ?"},{"id":"d","text":"Quand est le cours ?"}]'::jsonb, 'd', '« À huit heures » indique un moment, donc la question est « Quand est le cours ? ». « Où » demande un lieu, « qui » une personne et « combien » une quantité — aucun n''appelle une heure.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e50f3f7b-0369-52fd-88c5-41f174a0695c', 'd44ff6c1-9f43-5fc9-88e1-ee441810bc44', 'Mets à la forme négative : « Elle a des amis ici. »', '[{"id":"a","text":"Elle n''a pas d''amis ici."},{"id":"b","text":"Elle n''a pas des amis ici."},{"id":"c","text":"Elle a pas d''amis ici."},{"id":"d","text":"Elle ne a pas d''amis ici."}]'::jsonb, 'a', 'Après la négation, « des » devient « de », élidé en « d'' » devant la voyelle de « amis », et « ne » s''élide en « n'' » devant « a » : Elle n''a pas d''amis ici. « pas des amis » (b) garde l''article, (c) oublie « ne » et (d) n''élide pas « ne ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5c41cb21-4d01-5bc2-9603-a56192caadf9', 'a686a8b9-c332-5edc-b561-909cc0ccb468', 'francais-a1', '⚔️ Boss du chapitre ⭐⭐⭐ : questions et négation', 3, 120, 30, 'boss', 'admin', 3)
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
  ('7e96cda4-0dab-5337-9394-4b1b86cf4b70', '5c41cb21-4d01-5bc2-9603-a56192caadf9', 'Quelle question correspond à la réponse « Parce que je suis malade. » ?', '[{"id":"a","text":"Où es-tu ?"},{"id":"b","text":"Quand pars-tu ?"},{"id":"c","text":"Pourquoi ne viens-tu pas ?"},{"id":"d","text":"Comment vas-tu à l''école ?"}]'::jsonb, 'c', 'Une réponse qui commence par « Parce que… » donne une raison, donc le mot interrogatif est « pourquoi » : Pourquoi ne viens-tu pas ? « Où » demande un lieu, « quand » un moment et « comment » une manière — aucun n''appelle une raison.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('498027d9-c500-57a2-835b-1c28ce6aecea', '5c41cb21-4d01-5bc2-9603-a56192caadf9', 'Complète : « ___ coûtent ces livres ? »', '[{"id":"a","text":"Comment"},{"id":"b","text":"Qui"},{"id":"c","text":"Quand"},{"id":"d","text":"Combien"}]'::jsonb, 'd', '« Combien » interroge sur une quantité ou un prix : Combien coûtent ces livres ? « Comment » demande une manière, « qui » une personne et « quand » un moment — aucun ne convient à un prix.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('389a9d29-4c25-5fef-8890-961dec2969dc', '5c41cb21-4d01-5bc2-9603-a56192caadf9', 'Trouve la question INCORRECTE.', '[{"id":"a","text":"Est-ce que viens-tu demain ?"},{"id":"b","text":"Est-ce que tu viens demain ?"},{"id":"c","text":"Viens-tu demain ?"},{"id":"d","text":"Tu viens demain ?"}]'::jsonb, 'a', 'L''erreur est (a) : on ne combine jamais « est-ce que » avec une inversion. Il faut dire « Est-ce que tu viens demain ? » (ordre normal) ou « Viens-tu demain ? » (inversion seule). (b), (c) et (d) sont des registres corrects.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73dc8cab-995b-51ff-b86b-1c2e76798477', '5c41cb21-4d01-5bc2-9603-a56192caadf9', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Je ne parle pas espagnol."},{"id":"b","text":"Je ne mange pas une pomme."},{"id":"c","text":"Elle n''a pas de frère."},{"id":"d","text":"Nous ne sommes pas prêts."}]'::jsonb, 'b', 'L''erreur est (b) : après la négation, l''article « une » devient « de » → « Je ne mange pas de pomme ». (a) et (d) n''ont pas d''article à transformer, et (c) applique correctement le passage à « de ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('212cb3b7-b1d1-5945-9c67-99f0247e770f', '5c41cb21-4d01-5bc2-9603-a56192caadf9', 'Complète à l''inversion : « ___ allez-vous aujourd''hui ? » (on attend « Très bien »)', '[{"id":"a","text":"Où"},{"id":"b","text":"Quand"},{"id":"c","text":"Combien"},{"id":"d","text":"Comment"}]'::jsonb, 'd', '« Comment » interroge sur l''état : « Comment allez-vous ? » appelle la réponse « Très bien ». « Où » demande un lieu, « quand » un moment et « combien » une quantité, qui ne correspondent pas à « Très bien ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14d7c5ae-5385-5998-acb3-791cd477ed42', '5c41cb21-4d01-5bc2-9603-a56192caadf9', 'Quelle est la forme négative correcte de « Tu as un chien. » ?', '[{"id":"a","text":"Tu n''as pas un chien."},{"id":"b","text":"Tu as ne pas de chien."},{"id":"c","text":"Tu n''as pas de chien."},{"id":"d","text":"Tu ne as pas de chien."}]'::jsonb, 'c', 'Deux règles s''appliquent : « ne » s''élide en « n'' » devant « as », et l''article « un » devient « de » → Tu n''as pas de chien. « pas un chien » (a) garde l''article, (b) place mal « ne » et (d) n''élide pas « ne ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a4a9807d-c98a-502f-a98d-49ebfc2e326e', 'a686a8b9-c332-5edc-b561-909cc0ccb468', 'francais-a1', '👑 Défi élite ⭐⭐⭐⭐ : questions et négation', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('b9e51165-8a6c-56e9-a8ab-ee3985961695', 'a4a9807d-c98a-502f-a98d-49ebfc2e326e', 'Quelle question correspond à la réponse « C''est le sac de ma sœur. » ?', '[{"id":"a","text":"Où est ton sac ?"},{"id":"b","text":"Quel est ce sac ?"},{"id":"c","text":"Combien coûte ce sac ?"},{"id":"d","text":"Quand achètes-tu un sac ?"}]'::jsonb, 'b', '« C''est le sac de ma sœur » identifie un objet précis, donc « Quel est ce sac ? » convient (quel s''accorde avec « sac », masculin singulier). « Où » demande un lieu, « combien » un prix et « quand » un moment.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9f3ad08-543c-5a92-a2da-28b4fd13f050', 'a4a9807d-c98a-502f-a98d-49ebfc2e326e', 'Trouve la question INCORRECTE.', '[{"id":"a","text":"Quelle heure est-il ?"},{"id":"b","text":"Quels livres lis-tu ?"},{"id":"c","text":"Quel âge as-tu ?"},{"id":"d","text":"Quel couleur préfères-tu ?"}]'::jsonb, 'd', 'L''erreur est (d) : « couleur » est féminin singulier, donc il faut « Quelle couleur préfères-tu ? ». (a) accorde au féminin (heure), (b) au masculin pluriel (livres) et (c) au masculin singulier (âge) — toutes correctes.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ccd9b02f-6ff3-5d56-824c-0fb279c0897f', 'a4a9807d-c98a-502f-a98d-49ebfc2e326e', 'Trouve la phrase entièrement CORRECTE.', '[{"id":"a","text":"Je n''ai pas d''argent et je n''achète pas de café."},{"id":"b","text":"Je n''ai pas de argent et je n''achète pas du café."},{"id":"c","text":"Je ai pas d''argent et je n''achète pas de café."},{"id":"d","text":"Je n''ai pas d''argent et je achète ne pas de café."}]'::jsonb, 'a', 'Seule (a) est correcte : « ne » s''élide en « n'' » devant « ai » et « achète », « de » s''élide en « d'' » devant « argent », et les articles deviennent « de ». (b) garde « du » et n''élide pas « de argent », (c) oublie un « ne », (d) place mal « ne pas ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8391b212-b280-5b72-952d-d575e50b35ab', 'a4a9807d-c98a-502f-a98d-49ebfc2e326e', 'Lis : « Karim travaille dans un hôpital. Il porte une blouse blanche et il soigne les malades. »
Quelle question NE peux-tu PAS répondre avec ce texte ?', '[{"id":"a","text":"Où travaille Karim ?"},{"id":"b","text":"Que porte Karim ?"},{"id":"c","text":"Quel âge a Karim ?"},{"id":"d","text":"Que fait Karim au travail ?"}]'::jsonb, 'c', 'Le texte dit où il travaille (un hôpital), ce qu''il porte (une blouse) et ce qu''il fait (il soigne les malades), mais ne mentionne jamais son âge. On ne peut donc pas répondre à « Quel âge a Karim ? » : ne déduis jamais au-delà du texte.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8cb25dc2-5cdd-5233-b6ba-b0beb4dbc039', 'a4a9807d-c98a-502f-a98d-49ebfc2e326e', 'Choisis la paire question-réponse correctement assortie.', '[{"id":"a","text":"« Où travailles-tu ? » — « À neuf heures. »"},{"id":"b","text":"« Quand commences-tu ? » — « Dans un bureau. »"},{"id":"c","text":"« Qui est-elle ? » — « Dans la cuisine. »"},{"id":"d","text":"« Pourquoi es-tu en retard ? » — « Parce que le bus était plein. »"}]'::jsonb, 'd', 'Seule (d) est cohérente : « pourquoi » demande une raison, donnée par « Parce que le bus était plein ». (a) répond à « où » par une heure, (b) répond à « quand » par un lieu, et (c) répond à « qui » par un lieu au lieu d''une personne.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf7ccfc9-9098-5e07-837f-809200fac0df', 'a4a9807d-c98a-502f-a98d-49ebfc2e326e', 'Choisis la question entièrement CORRECTE.', '[{"id":"a","text":"Est-ce que où tu habites ?"},{"id":"b","text":"Où est-ce que tu habites ?"},{"id":"c","text":"Où est-ce que habites-tu ?"},{"id":"d","text":"Où tu habites-tu ?"}]'::jsonb, 'b', 'Avec « est-ce que », le mot interrogatif se place en tête, puis « est-ce que », puis l''ordre normal sujet + verbe : Où est-ce que tu habites ? (a) place « où » après « est-ce que », (c) ajoute une inversion interdite avec « est-ce que », et (d) double le sujet « tu ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('979ee26f-0a4a-5f03-a6d9-849be4ba6186', 'a686a8b9-c332-5edc-b561-909cc0ccb468', 'francais-a1', '⭐⭐ Drill : questions et négation', 2, 75, 15, 'practice', 'admin', 5)
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
  ('0cc60143-9d10-5ab1-9ea4-b93674066783', '979ee26f-0a4a-5f03-a6d9-849be4ba6186', 'Quel mot interrogatif demande un MOMENT ?', '[{"id":"a","text":"Où"},{"id":"b","text":"Comment"},{"id":"c","text":"Quand"},{"id":"d","text":"Qui"}]'::jsonb, 'c', '« Quand » interroge sur un moment (Quand arrives-tu ? — Demain). « Où » demande un lieu, « comment » une manière et « qui » une personne. Chaque mot interrogatif attend un type de réponse différent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fc06fe5-61b8-57d6-bcd9-ccdb4953a1ac', '979ee26f-0a4a-5f03-a6d9-849be4ba6186', 'Choisis la question correcte à l''inversion pour « Vous êtes prêts. »', '[{"id":"a","text":"Êtes-vous prêts ?"},{"id":"b","text":"Vous êtes-vous prêts ?"},{"id":"c","text":"Êtes vous prêts ?"},{"id":"d","text":"Est-ce que êtes-vous prêts ?"}]'::jsonb, 'a', 'L''inversion met le verbe avant le pronom avec un trait d''union : Êtes-vous prêts ? « Vous êtes-vous » (b) double le sujet, (c) oublie le trait d''union, et (d) combine « est-ce que » avec une inversion, ce qui est interdit.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f711a596-febd-5d1c-87f3-912106770ebd', '979ee26f-0a4a-5f03-a6d9-849be4ba6186', 'Complète : « ___ couleurs préfères-tu ? »', '[{"id":"a","text":"Quel"},{"id":"b","text":"Quelle"},{"id":"c","text":"Quels"},{"id":"d","text":"Quelles"}]'::jsonb, 'd', '« couleurs » est féminin pluriel, donc l''adjectif interrogatif est « quelles » : Quelles couleurs préfères-tu ? « Quel » et « quelle » sont singuliers, et « quels » est masculin, ce qui ne s''accorde pas avec « couleurs ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c7fa441b-becb-572d-90d3-a9993fa25509', '979ee26f-0a4a-5f03-a6d9-849be4ba6186', 'Mets à la forme négative : « Nous avons des questions. »', '[{"id":"a","text":"Nous n''avons pas des questions."},{"id":"b","text":"Nous n''avons pas de questions."},{"id":"c","text":"Nous avons pas de questions."},{"id":"d","text":"Nous ne avons pas de questions."}]'::jsonb, 'b', 'Après la négation, « des » devient « de », et « ne » s''élide en « n'' » devant « avons » : Nous n''avons pas de questions. « pas des questions » (a) garde l''article, (c) oublie « ne » et (d) n''élide pas « ne ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('663e1c32-988a-50af-9ff4-943819c24a38', '979ee26f-0a4a-5f03-a6d9-849be4ba6186', 'Quelle question correspond à la réponse « En bus. » ?', '[{"id":"a","text":"Où vas-tu ?"},{"id":"b","text":"Quand pars-tu ?"},{"id":"c","text":"Comment vas-tu à l''école ?"},{"id":"d","text":"Combien de bus prends-tu ?"}]'::jsonb, 'c', '« En bus » indique une manière de se déplacer, donc la question est « Comment vas-tu à l''école ? ». « Où » demande un lieu, « quand » un moment et « combien de bus » un nombre — aucun n''appelle « En bus » comme moyen.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2861ddac-114e-595c-b144-b2307ddbad9a', '979ee26f-0a4a-5f03-a6d9-849be4ba6186', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Il ne aime pas le café."},{"id":"b","text":"Il n''aime pas le café."},{"id":"c","text":"Elle ne mange pas de viande."},{"id":"d","text":"Tu ne viens pas avec nous."}]'::jsonb, 'a', 'L''erreur est (a) : devant la voyelle de « aime », « ne » doit s''élider en « n'' » → « Il n''aime pas le café » (b). (c) et (d) sont corrects car « mange » et « viens » commencent par une consonne, donc « ne » reste entier.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2e847056-9c2e-570e-bfb3-bada695a1780', 'e9ff7be1-b5bf-5d73-b593-0f711048aef0', 'francais-a1', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('7a6b6535-a66c-5d42-b13f-ed8fdd610111', '2e847056-9c2e-570e-bfb3-bada695a1780', 'Lis le SMS :
« Salut ! On se retrouve à 18 h devant le cinéma. À tout à l''heure ! »

À quelle heure est le rendez-vous ?', '[{"id":"a","text":"À 18 h"},{"id":"b","text":"À 8 h"},{"id":"c","text":"À 16 h"},{"id":"d","text":"À 19 h"}]'::jsonb, 'a', 'Le SMS dit « On se retrouve à 18 h » : le rendez-vous est donc à 18 h. Les autres heures (8 h, 16 h, 19 h) ne sont pas écrites dans le message.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2e00c180-1a46-5f59-b857-f23c3c38a9dc', '2e847056-9c2e-570e-bfb3-bada695a1780', 'Lis l''affichette :
« BOULANGERIE — Fermé le lundi. Ouvert du mardi au dimanche. »

Quel jour la boulangerie est-elle fermée ?', '[{"id":"a","text":"Le dimanche"},{"id":"b","text":"Le mardi"},{"id":"c","text":"Le lundi"},{"id":"d","text":"Le samedi"}]'::jsonb, 'c', 'L''affichette indique « Fermé le lundi » : la boulangerie est donc fermée le lundi. Le mardi, le samedi et le dimanche, elle est ouverte (« du mardi au dimanche »).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f138a932-d08e-54a9-ab59-9185225251a7', '2e847056-9c2e-570e-bfb3-bada695a1780', 'Lis la petite annonce :
« Vélo bleu à vendre. Bon état. Prix : 50 euros. Téléphone : 06 12 34 56 78. »

Combien coûte le vélo ?', '[{"id":"a","text":"6 euros"},{"id":"b","text":"50 euros"},{"id":"c","text":"15 euros"},{"id":"d","text":"56 euros"}]'::jsonb, 'b', 'L''annonce dit « Prix : 50 euros » : le vélo coûte donc 50 euros. Les nombres 6, 15 et 56 viennent du numéro de téléphone, pas du prix.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('291187d2-1d1d-5ecf-98f3-628e97882556', '2e847056-9c2e-570e-bfb3-bada695a1780', 'Lis le message :
« Bonjour, je m''appelle Sofia. Je suis espagnole et j''habite à Madrid. »

Où habite Sofia ?', '[{"id":"a","text":"En Espagne, mais on ne sait pas où"},{"id":"b","text":"À Barcelone"},{"id":"c","text":"À Paris"},{"id":"d","text":"À Madrid"}]'::jsonb, 'd', 'Sofia écrit « j''habite à Madrid » : elle habite donc à Madrid. Barcelone et Paris ne sont pas citées, et le texte donne bien la ville, donc l''option (a) est fausse.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('acbe89eb-2314-55dc-a88f-1246e020c522', '2e847056-9c2e-570e-bfb3-bada695a1780', 'Lis la phrase :
« J''ai très soif, je bois un grand verre d''eau. »

Que veut dire le mot « soif » ?', '[{"id":"a","text":"Avoir besoin de manger"},{"id":"b","text":"Avoir besoin de boire"},{"id":"c","text":"Avoir froid"},{"id":"d","text":"Être fatigué"}]'::jsonb, 'b', 'Le mot « soif » est lié à « je bois un verre d''eau » : il veut donc dire avoir besoin de boire. « Manger » correspondrait à la faim, et le froid ou la fatigue n''ont aucun lien avec boire de l''eau.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7c46ec33-964b-56a9-a5a2-519f5b61c048', 'e9ff7be1-b5bf-5d73-b593-0f711048aef0', 'francais-a1', '⭐ Entraînement : lire un texte simple', 1, 50, 10, 'practice', 'admin', 1)
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
  ('7d52261a-7d0a-59c0-9230-fc858d5dd057', '7c46ec33-964b-56a9-a5a2-519f5b61c048', 'Lis la carte postale :
« Bonjour de Tunis ! Il fait très beau. Je mange du couscous tous les jours. Je rentre samedi. Bisous, Karim. »

Qui écrit cette carte postale ?', '[{"id":"a","text":"Tunis"},{"id":"b","text":"Samedi"},{"id":"c","text":"Karim"},{"id":"d","text":"Bisous"}]'::jsonb, 'c', 'Le nom de l''auteur est écrit à la fin, après « Bisous » : c''est Karim. « Tunis » est la ville, « samedi » est le jour du retour, et « Bisous » est une formule, pas un nom.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ea4178b-f738-5e6a-ba3e-4753d9c1d64d', '7c46ec33-964b-56a9-a5a2-519f5b61c048', 'Lis le SMS :
« Le bus part à 9 h. Sois à l''arrêt à 8 h 50, s''il te plaît ! »

À quelle heure part le bus ?', '[{"id":"a","text":"À 8 h 50"},{"id":"b","text":"À 9 h"},{"id":"c","text":"À 8 h"},{"id":"d","text":"À 10 h"}]'::jsonb, 'b', 'Le SMS dit « Le bus part à 9 h » : le bus part donc à 9 h. 8 h 50 est l''heure pour être à l''arrêt, pas l''heure du départ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('97ba2e96-a6c9-5f2f-a2a8-ac8d41ae662c', '7c46ec33-964b-56a9-a5a2-519f5b61c048', 'Lis l''affichette :
« PISCINE — Ouverte de 10 h à 18 h. Entrée : 4 euros. »

Combien coûte l''entrée de la piscine ?', '[{"id":"a","text":"4 euros"},{"id":"b","text":"10 euros"},{"id":"c","text":"18 euros"},{"id":"d","text":"14 euros"}]'::jsonb, 'a', 'L''affichette indique « Entrée : 4 euros » : l''entrée coûte donc 4 euros. 10 et 18 sont les heures d''ouverture, pas le prix.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('66bc69cc-3177-54bd-8c72-eb2ebbfa3055', '7c46ec33-964b-56a9-a5a2-519f5b61c048', 'Lis le menu :
« MENU DU JOUR
Salade : 5 euros
Pizza : 9 euros
Glace : 3 euros »

Quel plat est le plus cher ?', '[{"id":"a","text":"La glace"},{"id":"b","text":"La salade"},{"id":"c","text":"Les trois ont le même prix"},{"id":"d","text":"La pizza"}]'::jsonb, 'd', 'La pizza coûte 9 euros, c''est le prix le plus élevé. La salade (5 euros) et la glace (3 euros) coûtent moins cher, donc la pizza est le plat le plus cher.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('345d9217-887e-55ef-b9b5-a92992f2a27a', '7c46ec33-964b-56a9-a5a2-519f5b61c048', 'Lis le courriel :
« Bonjour Madame,
Votre colis arrive jeudi à votre adresse.
Bonne journée. »

Quand le colis arrive-t-il ?', '[{"id":"a","text":"Lundi"},{"id":"b","text":"Jeudi"},{"id":"c","text":"Vendredi"},{"id":"d","text":"Le courriel ne le dit pas"}]'::jsonb, 'b', 'Le courriel dit « Votre colis arrive jeudi » : le colis arrive donc jeudi. Lundi et vendredi ne sont pas cités, et le jour est bien donné, donc l''option (d) est fausse.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5aef042-5730-5c52-a87d-471b2313de59', '7c46ec33-964b-56a9-a5a2-519f5b61c048', 'Lis la phrase :
« Il est tard, je suis fatigué, je vais dormir. »

Que veut dire le mot « fatigué » ?', '[{"id":"a","text":"Avoir faim"},{"id":"b","text":"Être content"},{"id":"c","text":"Avoir besoin de repos"},{"id":"d","text":"Avoir froid"}]'::jsonb, 'c', 'Le mot « fatigué » est lié à « il est tard » et « je vais dormir » : il veut donc dire avoir besoin de repos. La faim, la joie et le froid n''ont pas de lien avec aller dormir.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('099d9bf0-800c-58ed-924b-87810c5f650f', 'e9ff7be1-b5bf-5d73-b593-0f711048aef0', 'francais-a1', '⭐⭐ Révision : lire un texte simple', 2, 75, 15, 'practice', 'admin', 2)
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
  ('462041d4-a011-5b7b-9915-6c8f61f5beb9', '099d9bf0-800c-58ed-924b-87810c5f650f', 'Lis l''annonce :
« Cherche chambre à louer à Lyon. Pour étudiant. Maximum 400 euros par mois. Appeler Paul. »

Qui cherche une chambre ?', '[{"id":"a","text":"Un professeur"},{"id":"b","text":"Un étudiant"},{"id":"c","text":"Une famille"},{"id":"d","text":"Un touriste"}]'::jsonb, 'b', 'L''annonce dit « Pour étudiant » : c''est donc un étudiant qui cherche une chambre. Un professeur, une famille ou un touriste ne sont pas mentionnés dans le texte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1bfd35c4-0c1e-5643-9343-27eb4ebefe16', '099d9bf0-800c-58ed-924b-87810c5f650f', 'Lis l''horaire :
« Train pour Paris : départ 7 h 30, arrivée 9 h 45. Quai numéro 3. »

À quelle heure le train arrive-t-il ?', '[{"id":"a","text":"À 7 h 30"},{"id":"b","text":"À 3 h"},{"id":"c","text":"À 7 h 45"},{"id":"d","text":"À 9 h 45"}]'::jsonb, 'd', 'L''horaire indique « arrivée 9 h 45 » : le train arrive donc à 9 h 45. 7 h 30 est l''heure de départ et le 3 est le numéro du quai, pas une heure d''arrivée.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc07256e-473b-5073-a6cf-5355e50e1f3d', '099d9bf0-800c-58ed-924b-87810c5f650f', 'Lis le SMS :
« Coucou ! Je suis malade aujourd''hui, je ne viens pas à l''école. À demain ! Léa »

Pourquoi Léa ne vient-elle pas à l''école ?', '[{"id":"a","text":"Parce qu''elle est malade"},{"id":"b","text":"Parce qu''elle est en vacances"},{"id":"c","text":"Parce qu''elle voyage"},{"id":"d","text":"Parce qu''elle travaille"}]'::jsonb, 'a', 'Léa écrit « Je suis malade aujourd''hui, je ne viens pas à l''école » : elle est donc absente parce qu''elle est malade. Les vacances, un voyage ou le travail ne sont pas cités dans le message.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5dc6960b-97c3-54c3-9572-2471a439b62e', '099d9bf0-800c-58ed-924b-87810c5f650f', 'Lis la liste de courses :
« À acheter : 6 œufs, 2 litres de lait, 1 kilo de pommes, du pain. »

Combien d''œufs faut-il acheter ?', '[{"id":"a","text":"2 œufs"},{"id":"b","text":"1 œuf"},{"id":"c","text":"6 œufs"},{"id":"d","text":"12 œufs"}]'::jsonb, 'c', 'La liste dit « 6 œufs » : il faut donc acheter 6 œufs. Le 2 est pour le lait et le 1 pour les pommes, ce ne sont pas les nombres des œufs.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2294716e-81e4-5ae1-8414-8e2f26e27ea1', '099d9bf0-800c-58ed-924b-87810c5f650f', 'Lis l''affichette :
« CONCERT GRATUIT au parc, samedi soir à 20 h. Venez nombreux ! »

Que veut dire « gratuit » ?', '[{"id":"a","text":"Très cher"},{"id":"b","text":"Réservé aux adultes"},{"id":"c","text":"Annulé"},{"id":"d","text":"Sans payer"}]'::jsonb, 'd', 'Un concert « gratuit » est un concert où l''on entre sans payer. Le mot ne veut pas dire cher (c''est le contraire), ni réservé aux adultes, ni annulé.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c6ee216-7af4-57fa-a4ec-facbece3f8e7', '099d9bf0-800c-58ed-924b-87810c5f650f', 'Lis le courriel :
« Bonjour, le rendez-vous chez le docteur est mardi, pas lundi. Merci de noter. »

Quel jour est le rendez-vous ?', '[{"id":"a","text":"Mardi"},{"id":"b","text":"Lundi"},{"id":"c","text":"Mercredi"},{"id":"d","text":"Le courriel ne le dit pas"}]'::jsonb, 'a', 'Le courriel dit « le rendez-vous est mardi, pas lundi » : le bon jour est donc mardi. Lundi est justement le jour à ne pas confondre, et mercredi n''est pas cité.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c04eba2e-3966-58ec-8586-1263e85bf749', 'e9ff7be1-b5bf-5d73-b593-0f711048aef0', 'francais-a1', '⚔️ Boss du chapitre ⭐⭐⭐ : lire un texte simple', 3, 120, 30, 'boss', 'admin', 3)
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
  ('e7a45a93-5f75-5663-b122-0999cb8677ab', 'c04eba2e-3966-58ec-8586-1263e85bf749', 'Lis le menu :
« CAFÉ DU COIN
Café : 2 euros
Thé : 2 euros
Jus d''orange : 3 euros
Eau : 1 euro »

Quelle boisson est la moins chère ?', '[{"id":"a","text":"L''eau"},{"id":"b","text":"Le café"},{"id":"c","text":"Le jus d''orange"},{"id":"d","text":"Le thé"}]'::jsonb, 'a', 'L''eau coûte 1 euro, c''est le prix le plus bas du menu. Le café et le thé coûtent 2 euros, et le jus d''orange 3 euros : l''eau est donc la boisson la moins chère.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb836141-af4a-5272-b725-7121a8c6fcd3', 'c04eba2e-3966-58ec-8586-1263e85bf749', 'Lis la carte postale :
« Bonjour ! Nous sommes à la mer avec papa et mamie. Nous nageons chaque matin. Le soir, nous mangeons du poisson. Nous rentrons vendredi. Emma »

Avec qui Emma est-elle en vacances ?', '[{"id":"a","text":"Avec ses amis"},{"id":"b","text":"Avec maman et papi"},{"id":"c","text":"Avec papa et mamie"},{"id":"d","text":"Toute seule"}]'::jsonb, 'c', 'La carte dit « avec papa et mamie » : Emma est donc en vacances avec son papa et sa mamie. « maman » et « papi » ne sont pas cités ; il faut lire les deux noms avec attention.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba3fb009-2cee-5867-b1f1-e3955a6151e7', 'c04eba2e-3966-58ec-8586-1263e85bf749', 'Lis l''annonce :
« Cours de guitare. Le mercredi et le samedi. 15 euros la leçon. Débutants acceptés. Tél : Marc. »

Quels jours ont lieu les cours ?', '[{"id":"a","text":"Le lundi et le jeudi"},{"id":"b","text":"Le mercredi et le samedi"},{"id":"c","text":"Le mercredi seulement"},{"id":"d","text":"Tous les jours"}]'::jsonb, 'b', 'L''annonce indique « Le mercredi et le samedi » : les cours ont donc lieu ces deux jours. Le piège courant est de n''en lire qu''un seul (mercredi) ou de citer des jours absents comme lundi et jeudi.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a52559d2-2e99-5247-a541-fddf12b2adf9', 'c04eba2e-3966-58ec-8586-1263e85bf749', 'Lis le SMS :
« Désolé, je suis en retard ! Le bus est en panne. J''arrive à 17 h au lieu de 16 h. »

À quelle heure la personne devait-elle arriver d''abord ?', '[{"id":"a","text":"À 17 h"},{"id":"b","text":"À 18 h"},{"id":"c","text":"À 7 h"},{"id":"d","text":"À 16 h"}]'::jsonb, 'd', '« J''arrive à 17 h au lieu de 16 h » signifie que l''heure prévue d''abord était 16 h. Le piège courant est de prendre 17 h, qui est la nouvelle heure (en retard), pas l''heure prévue au départ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('efdf3643-9e05-5c38-9971-e56a38c990cf', 'c04eba2e-3966-58ec-8586-1263e85bf749', 'Lis l''affichette :
« MAGASIN — Ouvert du lundi au samedi, de 9 h à 19 h. Fermé le dimanche. »

Quel jour ne peux-tu PAS faire tes courses ici ?', '[{"id":"a","text":"Le dimanche"},{"id":"b","text":"Le lundi"},{"id":"c","text":"Le samedi"},{"id":"d","text":"Le mercredi"}]'::jsonb, 'a', 'L''affichette dit « Fermé le dimanche » : on ne peut donc pas faire ses courses le dimanche. Le lundi, le mercredi et le samedi, le magasin est ouvert (« du lundi au samedi »).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5e0aa51f-cd3f-5326-a618-d97a4ee8095f', 'c04eba2e-3966-58ec-8586-1263e85bf749', 'Lis le courriel :
« Bonjour Léo,
Merci pour ton invitation. Je ne peux pas venir samedi, mais je suis libre dimanche. On se voit dimanche ? Nadia »

Quel jour Nadia est-elle disponible ?', '[{"id":"a","text":"Samedi"},{"id":"b","text":"Vendredi"},{"id":"c","text":"Dimanche"},{"id":"d","text":"Aucun jour"}]'::jsonb, 'c', 'Nadia écrit « Je ne peux pas venir samedi, mais je suis libre dimanche » : elle est donc disponible dimanche. Le piège courant est de choisir samedi, qui est justement le jour où elle n''est pas libre.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3409d769-1abf-5e8b-a0fd-f96e0462fee1', 'e9ff7be1-b5bf-5d73-b593-0f711048aef0', 'francais-a1', '👑 Défi élite ⭐⭐⭐⭐ : lire un texte simple', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('617293a1-3b82-5634-964d-f371ec0b8277', '3409d769-1abf-5e8b-a0fd-f96e0462fee1', 'Lis l''horaire :
« Cinéma Étoile
Film : 14 h, 17 h et 20 h.
Prix : 8 euros. »

À combien d''heures différentes le film passe-t-il ?', '[{"id":"a","text":"Une fois"},{"id":"b","text":"Deux fois"},{"id":"c","text":"Quatre fois"},{"id":"d","text":"Trois fois"}]'::jsonb, 'd', 'L''horaire donne trois heures : 14 h, 17 h et 20 h. Le film passe donc trois fois. Le 8 est le prix en euros, ce n''est pas un nombre de séances.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85331ca4-987b-5914-bd7a-868b73d830f3', '3409d769-1abf-5e8b-a0fd-f96e0462fee1', 'Lis le courriel :
« Bonjour, votre table est réservée pour 4 personnes, samedi à 20 h, au restaurant Le Jardin. Merci ! »

Pour combien de personnes est la réservation ?', '[{"id":"a","text":"Pour 20 personnes"},{"id":"b","text":"Pour 4 personnes"},{"id":"c","text":"Pour 2 personnes"},{"id":"d","text":"Pour 8 personnes"}]'::jsonb, 'b', 'Le courriel dit « pour 4 personnes » : la réservation est donc pour 4 personnes. Le 20 est l''heure (20 h), pas le nombre de personnes ; 2 et 8 ne sont pas dans le texte.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f3c7e26-fcd1-59e1-b99d-207086e21b55', '3409d769-1abf-5e8b-a0fd-f96e0462fee1', 'Lis l''annonce :
« À vendre : table en bois, 60 euros. Deux chaises, 20 euros chaque. À retirer à Marseille. »

Combien coûtent les deux chaises ensemble ?', '[{"id":"a","text":"40 euros"},{"id":"b","text":"20 euros"},{"id":"c","text":"60 euros"},{"id":"d","text":"80 euros"}]'::jsonb, 'a', 'Chaque chaise coûte 20 euros, donc deux chaises coûtent 20 + 20 = 40 euros ✓. Le piège courant est de prendre 20 euros (une seule chaise) ou 60 euros (le prix de la table).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df7d6e19-8c0e-5209-99bd-3849e1823141', '3409d769-1abf-5e8b-a0fd-f96e0462fee1', 'Lis le SMS :
« Le match commence à 15 h. Arrive 30 minutes avant pour trouver une place. »

À quelle heure faut-il arriver ?', '[{"id":"a","text":"À 15 h"},{"id":"b","text":"À 15 h 30"},{"id":"c","text":"À 14 h 30"},{"id":"d","text":"À 13 h"}]'::jsonb, 'c', 'Le match est à 15 h et il faut arriver 30 minutes avant : 15 h moins 30 minutes = 14 h 30 ✓. Le piège courant est de prendre 15 h (l''heure du match) ou 15 h 30 (30 minutes après au lieu d''avant).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6aec1607-dc0d-512e-8319-105dcc4e2213', '3409d769-1abf-5e8b-a0fd-f96e0462fee1', 'Lis la carte postale :
« Coucou ! Je suis à la montagne. Il neige beaucoup et il fait froid. Je fais du ski tous les jours. C''est super ! Hugo »

Quel temps fait-il là où est Hugo ?', '[{"id":"a","text":"Il fait chaud"},{"id":"b","text":"Il pleut"},{"id":"c","text":"Il y a du soleil"},{"id":"d","text":"Il neige et il fait froid"}]'::jsonb, 'd', 'Hugo écrit « Il neige beaucoup et il fait froid » : le temps est donc à la neige et au froid. Le piège courant est de choisir « chaud », qui est le contraire de ce que dit le texte ; la pluie et le soleil ne sont pas cités.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87238d96-c79a-5488-b0dc-de8aebb4b70c', '3409d769-1abf-5e8b-a0fd-f96e0462fee1', 'Lis l''affichette :
« BIBLIOTHÈQUE
Ouverte : mardi, jeudi et vendredi.
Horaires : 10 h – 17 h. »

Lequel de ces jours la bibliothèque est-elle OUVERTE ?', '[{"id":"a","text":"Le lundi"},{"id":"b","text":"Le jeudi"},{"id":"c","text":"Le mercredi"},{"id":"d","text":"Le dimanche"}]'::jsonb, 'b', 'L''affichette liste « mardi, jeudi et vendredi » : la bibliothèque est donc ouverte le jeudi. Le lundi, le mercredi et le dimanche ne sont pas dans la liste des jours d''ouverture.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f30e7361-cea4-5e6b-bde7-680197e34879', 'e9ff7be1-b5bf-5d73-b593-0f711048aef0', 'francais-a1', '⭐⭐ Drill : lire un texte simple', 2, 75, 15, 'practice', 'admin', 5)
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
  ('d1bb11e3-b139-52bb-816e-e0679ff41b51', 'f30e7361-cea4-5e6b-bde7-680197e34879', 'Lis le SMS :
« Bonne nouvelle ! J''ai réussi mon examen. On fête ça chez moi dimanche à 19 h. Tu viens ? Yasmine »

Que fête Yasmine ?', '[{"id":"a","text":"Son anniversaire"},{"id":"b","text":"Un mariage"},{"id":"c","text":"Sa réussite à l''examen"},{"id":"d","text":"Un nouveau travail"}]'::jsonb, 'c', 'Yasmine écrit « J''ai réussi mon examen. On fête ça » : elle fête donc sa réussite à l''examen. Un anniversaire, un mariage ou un nouveau travail ne sont pas cités dans le SMS.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d91ab71-aa7f-5308-86c0-221ac2103f52', 'f30e7361-cea4-5e6b-bde7-680197e34879', 'Lis le menu :
« PETIT-DÉJEUNER
Croissant : 2 euros
Pain au chocolat : 2 euros
Jus de fruit : 3 euros »

Combien coûte un croissant ?', '[{"id":"a","text":"2 euros"},{"id":"b","text":"3 euros"},{"id":"c","text":"5 euros"},{"id":"d","text":"1 euro"}]'::jsonb, 'a', 'Le menu indique « Croissant : 2 euros » : un croissant coûte donc 2 euros. 3 euros est le prix du jus de fruit, et 5 ou 1 euro ne sont pas écrits dans le menu.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e201495-8285-5b9a-aebf-9bee9f4c1e00', 'f30e7361-cea4-5e6b-bde7-680197e34879', 'Lis l''annonce :
« Perdu : chat noir et blanc, près du parc. Il s''appelle Minou. Récompense. Appeler Sophie. »

Comment s''appelle le chat perdu ?', '[{"id":"a","text":"Sophie"},{"id":"b","text":"Le texte ne donne pas son nom"},{"id":"c","text":"Noir"},{"id":"d","text":"Minou"}]'::jsonb, 'd', 'L''annonce dit « Il s''appelle Minou » : le chat s''appelle donc Minou. Sophie est la personne à appeler, « noir » est sa couleur, et le nom est bien donné, donc l''option (b) est fausse.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9dac95aa-0222-568b-b161-1631cbfae7e9', 'f30e7361-cea4-5e6b-bde7-680197e34879', 'Lis le courriel :
« Bonjour, votre commande de 3 livres est prête. Vous pouvez la retirer à la librairie à partir de lundi. »

Combien de livres la personne a-t-elle commandés ?', '[{"id":"a","text":"1 livre"},{"id":"b","text":"3 livres"},{"id":"c","text":"13 livres"},{"id":"d","text":"30 livres"}]'::jsonb, 'b', 'Le courriel dit « votre commande de 3 livres » : la personne a donc commandé 3 livres. Les nombres 1, 13 et 30 ne sont pas écrits dans le texte.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('df17eb68-be02-552b-8b85-3d1bbb38557e', 'f30e7361-cea4-5e6b-bde7-680197e34879', 'Lis la phrase :
« Le café est ouvert tôt, dès 6 h du matin. »

Que veut dire le mot « tôt » ?', '[{"id":"a","text":"Tard dans la nuit"},{"id":"b","text":"À midi"},{"id":"c","text":"De bonne heure le matin"},{"id":"d","text":"Le soir"}]'::jsonb, 'c', 'Le mot « tôt » est lié à « dès 6 h du matin » : il veut donc dire de bonne heure le matin. C''est le contraire de « tard », et il ne signifie ni midi ni le soir.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a389181a-4689-57d4-a41f-53d11f70cd20', 'f30e7361-cea4-5e6b-bde7-680197e34879', 'Lis l''affichette :
« GYM CLUB
Ouvert tous les jours sauf le dimanche.
De 7 h à 22 h. »

Le samedi, le club est-il ouvert ?', '[{"id":"a","text":"Oui, il est ouvert"},{"id":"b","text":"Non, il est fermé"},{"id":"c","text":"L''affichette ne le dit pas"},{"id":"d","text":"Seulement le matin"}]'::jsonb, 'a', 'L''affichette dit « tous les jours sauf le dimanche » : seul le dimanche est fermé, donc le samedi le club est ouvert. Le club ferme uniquement le dimanche, et les horaires (7 h – 22 h) valent pour tous les autres jours.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

