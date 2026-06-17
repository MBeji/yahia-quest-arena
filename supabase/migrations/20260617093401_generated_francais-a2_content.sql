-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: francais-a2 (Français — Élémentaire (A2 · DELF A2))
-- Regenerate with: npm run content:build
-- Source of truth: content/francais-a2/
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
  ('francais-a2', 'Français — Élémentaire (A2 · DELF A2)', 'Passe au niveau élémentaire : raconte au passé (passé composé et imparfait), parle de l''avenir (futur proche et futur simple), décris ta routine avec les verbes pronominaux, compare, situe dans l''espace et le temps, enrichis ton vocabulaire de la ville et lis des textes courts. Niveau élémentaire (CECRL A2), aligné sur le DELF A2.', 'Agilité', 'subject-french', 'Languages', 2, 'fr', false, 'francais', NULL)
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
      AND e.subject_id = 'francais-a2'
      AND e.source = 'admin'
      AND q.id NOT IN ('2005a6e5-346f-54e2-8fcd-bd557cfe909b', 'f7ab6ad3-7d91-5803-96b5-a9a0ca3c5cb7', '0224679a-c540-5ea4-bc06-c9d18246251a', 'ed13538a-b5b3-5c97-9156-69a832054e7f', '602afa6a-21ab-5410-9b04-a24cde6a5ef2', '37481b93-7f88-5b0c-9889-b8b4f0533330', '6596693b-c009-5569-b435-f4902295f6cf', '2fe39c4f-2e32-5006-90f6-fea7e56be473', '7b2d6496-80d9-5451-bb0c-89ff9b42fb06', '417b165f-fe14-5151-812e-fbc9306d92a1', '29d88b46-daf0-57d3-9675-30a145ec8e80', 'f9d831e5-d008-58f0-8a41-2f77ceba2397', '40a82e20-0442-5eae-a9ee-c8d90d6c9f14', '60952eba-9cc9-55ea-b99c-7b639f253ec6', 'cc1d208b-340b-5bcb-a4b1-b2744619e4d4', 'd38e309b-ad75-5a22-9a98-70a41c3a0210', '1982efdf-6ad1-5d2c-8709-2f5981ec88e9', '93bd4d4a-6b38-5fdf-bc32-4ec27e7d34a3', 'c2416933-e664-5734-9c01-f937ef444063', '520e1404-84c9-55e3-bfdb-d20853bbf36e', '320af27b-11f3-5015-ae61-402d78b62459', 'd11d465b-082d-5d6a-ba47-ca6fad4e46af', '620e7d50-56d1-5ef9-bccf-fa52c4944574', 'e944b4cd-5a4b-5146-aa34-0c34baa00a63', 'c9556592-6474-5df7-b25c-07fbed875770', 'c4919146-cf60-5e26-baf9-cbed79ac898c', '3d1e8264-255e-55f0-94de-79c5e3eb0ca8', 'ddaa25ac-677c-5205-9c64-8920a36e6e4e', '4f5784f8-e8bf-58af-90a3-108eebf7418c', '57a44fcd-7c8a-5b3c-b14a-085fe8f98171', '1e08595a-3861-5372-a2c4-59385d0ab9c7', '08bde0aa-1a5f-5604-9fa5-669984c89d9b', '2df74076-99a8-5941-96d9-5ec67f14a03b', '962bc088-3f8a-5bb8-9cb0-45fc7d79fbab', 'b1a0aae4-5c2b-5d62-8157-7333f1589e19', '168f5560-fc15-52a0-94e3-7c5e2d8c7027', 'a3bd76f7-6507-5751-a880-5e39094f291b', '8b978f30-f08e-58fb-a044-3f7408f2a942', '67ec337f-dcdb-5244-9f9f-57ee7fb3c653', '63cee886-a092-5ced-ae64-de28509ed5b9', '915a8a81-4383-5205-bd19-fca75502e655', '0d53d402-15e5-5f11-a12a-d8d3f383985f', '96e64358-6bf5-5d8a-93b3-8107d94c5f70', '918f6817-1e41-5ffc-ae6e-748d17a6875c', 'd8cdddd3-15f3-5180-97cb-e35d31e76cd1', '9122d2ce-69a8-532d-b1c3-c83540c39c00', '6ca3a5cd-e731-55df-b8b2-c7fbe1303396', '834c59a1-160a-5086-8d12-ab210dad6291', '516ad169-a724-58b9-9757-37ffaf8a4955', '4919eac7-6990-54bd-941b-4dcf41b4504e', 'b6576a3f-4862-5d83-93f9-0e2ec985ccea', 'a5ff9761-1f18-5b91-819d-fc04da5e0dc8', '6bd53e1c-3f2e-57ed-bacc-4ea70ff4445b', 'fafe1803-d3d5-5c6b-8d17-91453a7b9e38', '749543af-0164-53d3-894d-532d4c4a5f00', '1eed5120-4613-55ac-9ca2-18bf22be7a54', '552c04bc-0120-56e3-b436-94965565d607', '05dcd64d-a9c2-5527-ad33-9fd63662ce3b', '804d5279-ff81-5bc7-991c-7f37747c1928', 'c2e2db70-d20b-596a-ac03-de97e1e1670e', 'a43ef917-1a42-500c-9cce-cd01b00dc13e', 'e8dcad47-b184-5f88-a304-f55dcbc8bbb0', 'c13f7d01-b441-5619-8a1b-d7d0d648bcb4', '24cc9b7b-d23e-5798-8c08-498e22776c7c', 'b269d687-4ae0-5c59-addf-ce3d34e085d2', '61981da2-e7f6-52e5-b311-d99dffa06100', '9a58942e-85ca-5aea-8607-b5a137f3ea34', '34858e86-a6f1-542c-ab01-f854c5e12f09', 'ed2ad108-0c44-5bff-9503-020275d20b11', '3fcba4d8-8dbc-5c53-857b-93133c77c939', '29e91369-37b3-52bf-bf90-52ddceda417b', 'af18154c-631a-51e0-ae3b-3b4be5b2c946', '90a65ae6-b2fe-5267-ba2a-cae04ee7b8c2', '1c2d26ca-5455-51fb-98cc-da410b3118b6', 'aa6491ff-2936-52f3-93d8-53e068c26990', '042ddedf-ac26-500b-94e4-b2d032a49ea2', 'ccf6b8bd-7b68-5e4a-b597-28df10cbe770', 'c2bfeb3c-d951-572f-adb6-5dfff7a27a40', '7d7ac80c-2528-5f07-898d-d8624a3598eb', 'cb7a0124-7262-5b23-ad81-0cdd7fbb1995', '8b8bb36b-ecd1-55de-9030-825a58237dd0', 'beec616f-671c-52ad-9c5b-f995d0f9bac4', '8e59f2ac-67ef-54c8-82a1-95943e9aa7f4', '5a9fa118-db5a-5459-959c-caad128784c3', 'dc558038-0cfa-5618-b6b8-8f38d3303263', '48708813-e053-56d5-a278-2fa44c639e69', '2c7ebe50-1950-5be1-9841-b1283ece77d7', '6e2ba244-01e5-5a8c-8b18-9ddb5c34d375', 'f5a0888b-c7a0-54c9-b5df-5734ab49d7d5', '313ab95b-6cf3-59ff-82f3-cf8fded5275b', '7868e60e-111f-5f31-9994-7438295f31c3', '207c8e07-3209-5e9a-94ff-87817cea8202', '12e14128-ff35-518e-83a3-6379b25ccb4b', 'db8d2846-35e8-58e7-ae32-da953d906be4', '465b3487-143f-5120-b114-44ab588cc366', '226ee550-734e-57ae-8ca9-e4acade70454', '781c1518-5a48-51ad-9db6-03b835b77e73', '3a65a7fa-b305-537d-beb7-b85054b61e20', 'edb49c48-89a6-5854-875e-ce3a9a609c2b', '689d7b32-67a5-54ca-94ab-64388d2d6ea8', '2656fe34-1a7e-5b34-b460-c7e1ef79b209', 'a4cb6aa9-6984-524a-afdd-3bf29732fb78', 'adf1ae50-5beb-57a3-910d-4aba27f31791', 'db757d34-c8ef-551d-b6df-3f6800072e11', 'c3d48b5a-ddf9-5fb9-a35f-e173eb75af66', 'd455099f-df30-573a-9beb-de02ea9fe393', '891c1d85-e42e-5955-942e-b27530ac5d94', '32f4d3a8-25a2-514f-9537-ca86fc77d4d2', '2803d635-b200-5095-9b67-07781e519519', 'a1f53d39-e1fd-5fa4-92d6-8a0ceb597fe9', 'b2c9f0db-2f23-55da-9309-23c05e0c1501', '369d9d8d-6a95-54db-8686-eb31e9f0005d', '157be412-8158-54aa-90a1-967f8504fe78', '5117b93d-25a2-5dae-8214-4ff515d1f739', 'ddff942b-5544-5547-b44a-8f53e9b51d86', 'd99a7fdd-a2ce-5a81-a83c-9f232b0fc16a', 'e89968d1-c277-5a0a-9822-04d646e9a029', '873ab387-21e4-54f2-8c28-d05d22080277', 'b134a227-458a-588d-b270-799e14a312db', '717fc826-cc27-54f9-8b8d-a6afd85ff366', '62a24bca-84e3-525d-8fa1-9e76f62ff646', 'aebd793a-8c0c-505c-805e-9f824f3d1d1b', '4b23022b-5077-5168-a78e-033eb3b0c9ba', '338a8c50-6126-55f7-8899-5d4d7af3582d', 'f1fff0c6-b2ea-51d9-8579-d989bd9b8ba5', '9bf1f6d7-908e-5bd7-a52b-3c4af8237538', '065f0540-daa7-5c5e-aaf3-61a951b02ef7', '3ba87b9d-f3c1-5d92-ad4c-7a7ea8462b9f', '7ef04cc1-c682-5aff-b990-24134e5cfcef', 'f0eada00-2e20-5dec-a5d1-75a7951a0ab9', '8df02d18-71d6-557a-b79d-d60b60ad9029', 'b0531c1f-c7a3-5e50-bb64-a2f9d8b854e7', '73218580-7fde-5c4a-88c9-7d552d7fc84c', 'abbcc5ed-8e97-5b55-b76e-83f76dbd71a6', '70001201-93ba-58ac-acb5-04122829a7ff', '258fefd1-8ee2-5fa7-8b6a-74ddf8a04dd8', '9c464a1b-b232-53af-8a98-4e6d4f0177c0', '9673b149-9de2-57d8-ae59-b8b191ac8b4d', 'e46a90a8-dacd-5176-8576-1aa9944e36e4', '96fa8acd-1bda-5213-ab3d-5e755bf3d1ff', '5d601974-fbb4-5f5b-93b2-4484063ed207', 'c123b5ef-92a8-5e08-b606-dd690458801d', '27a10274-00a4-5cb4-bc7a-2f9bebde4daf', 'c74fe1f7-ad92-5228-aa0c-1ba004c65b4d', '93acbbcf-981b-55f8-b31b-fe3d11a7ff86', '7a8d3829-ca21-55de-81bc-78aba7695191', '56cea120-2f30-569f-a5d8-983c3ac1cd37', '81a1110f-8eb7-5e0f-951a-6df4422d9f7b', '9e7c15a0-1fdf-5d38-9fa0-7a18cea0d4de', '597d45ac-c7ae-5081-8321-77fb0c5d02ee', 'c54cd258-b7aa-5321-bf01-7336a9ef3f38', '8d436275-ba32-5a2e-bab3-3f7bf1a6c4a1', 'd149e620-56bc-562d-b0e0-1d30b1c5d2f4', 'f9fd9d5d-8437-5c0d-894c-d8a898d661d3', 'f94fd050-9ecb-57e4-91bb-c46bda672d41', '9aa5d739-114b-5528-a464-e2155ed57d3f', '78b032e0-a898-5438-8f53-845b887c61fc', 'f8dfa9b9-dcaf-50aa-80dd-fd176fc080da', 'cefd0920-3153-5867-9da6-60f6c491bfd5', '5d509dbe-8f0c-5966-9a1d-03b2e3eb49c5', '7535a1dc-07f0-5d0e-8830-d67d34227111', '9fabb966-2535-5e0b-bd36-f39f0dbc9dfc', '9c51717e-a333-5d69-b586-7bab5e6ae06f', 'c907230d-c700-587e-baed-2ec96c9c4814', '31ee1abf-9c84-5e12-9d43-5b4488c5717f', '963596d0-05df-5197-96c0-f60c4e729d07', '696d9881-2902-5b0f-a728-7cb899f9bffd', 'daaa9758-d5cd-5b6e-89e9-d0310e6c36f0', '22581f3f-2185-59a6-89c4-4008d4c508a0', '652ca3ab-de82-5be8-8d06-fa7477a4b5bb', '094ccb96-1cc4-5ec1-8580-b4c7037508b6', '2b258f51-070e-5e52-b550-d070972e0f2d', '7869ed0e-3c20-5b5e-ae13-ae8881ad9f49', 'a26f9f06-87e2-5c1b-9bbc-1cd655493c41', '8d1a1b0f-c393-551a-b8b7-143f198960d3', 'e341f48c-94bf-5c69-926a-36fc18b5a1ad', 'aa38bff9-0571-50a4-b9d7-309ad0fde2e9', 'd49a679f-2c3e-5ab1-af7c-d2ce07075a2d', '2637230c-e82a-5db0-b757-a98277fbde07', 'd9b3952e-516a-500f-a52b-22935730f013', '95049d19-d751-5d5e-8dcc-d187e1ae08b1', '8fed06cd-e5b6-5c66-98ea-fc45d977a75d', '1a8900b8-8df6-526e-8eee-a4fb951ec2c7', '3ce33e7d-442e-5eb4-a68c-21e29c647b3a', 'e9340a33-2632-5787-8b01-a82f3379c69f', '7e943a2e-96ac-5a36-b9b0-e18c67a5227e', '6e249a74-356f-54ed-ab57-70d8243e9a79', '63e05cb4-169e-5a21-847b-b2cd50d93d88', '34ef428c-0ce3-5677-98b7-0c30deeab5ed', '8859d84d-0359-5a19-9fce-89463b75e37f', '6f443a56-ca80-54f1-aee7-3cde84b295cf', '77571e40-8d99-5c8e-85e4-e99bd86e31d0', 'def4af47-7408-5bec-87b9-c6e9a59a6b4b', '755436f1-cd18-5bd5-a286-f79848dfed0f', '9cc1bc40-891e-5e6d-8aac-8fcce7cdf1b5', 'd044df80-8faa-5111-bf09-3fdf1aa0b070', '61d2e80c-6970-59c3-8243-d27e25fd2ba8', '794066f0-487c-52e0-8f44-e49b74d7d85b', '83ff0932-86c5-5a03-9028-e790de66fec5', '92c5d7d2-af0e-5200-96f1-941549e89b9f', 'caf0c786-2919-5874-a4bd-ecdfb0ca53bf', '44028074-3c2e-5df0-a193-be6d97ef3108', 'cb9fa363-668d-59e5-94f7-c79b6802aaa1', '550155a1-9cff-5d3c-8b52-aef5a6ea931c', 'a4d50ec7-a6a7-50ed-9066-ffa03e8e2879', 'f733fd44-b885-519b-8a96-cdb7f6ea39c4', 'cf5287d9-c124-54bf-aef5-6e6b9460fa2e', '194641cf-1a91-53d0-95d4-3662cc51b002', '6b17412b-e2e6-5a5a-b7b8-d60735c970e9', '43c0a824-6d0e-55ff-9865-0d8ea9df6879', '9a8ee112-f606-52bb-ade5-e6b0063befa0', 'b9477bf5-9be2-53c1-8e71-0bb9c555eeae', '75e5ae9d-c178-5d28-a41b-64dbe35108f4', 'beda8e6c-7e6b-59a2-a264-442b98e4957a', '4014dd03-4642-5e8d-be8c-841c708b7d7a', '0224bb92-f8c9-5b67-a0a5-91fa805b819b', '3b7db18c-ad25-5cc9-abd4-bf84a2001c79', 'bf3c56cd-5e8d-56ba-899c-a3796e769a04', '84372228-eeb0-5b94-989f-092536843422', '19f8b1fd-7814-5d62-a83f-91c29525df67', 'aedc6648-47b6-55d6-8054-ab09bb0672e2', '8b97473f-1cd3-5346-aefd-d84c1037d769', '34667fb0-af57-5515-ad7f-ce58a55dcbba', '6ab317c9-a988-57c5-ad43-9c84dca4d9e0', '3c477d5a-6536-574d-a85a-b7806d78209a', '8bec889f-dac8-5396-8874-af91083f64e9', '164f0371-5299-553b-8d55-115c8fe8b646', '976524b7-916a-586c-821f-e941fb228ed4', '9564d2f5-bf46-52ec-9499-f4fbc3e5d738', '591030b8-3c27-5f39-bdd7-5446dca2c0a0', 'e1a09795-3e27-5e00-b206-dfc5990b6250', 'e11f0dfa-0f42-5840-a927-a1de4e7d8dee', '3e4355b6-96ce-5bbd-8858-c1e709e647de', '585a873d-01b1-59f8-85ab-2e2bba056b17', '1d5aec5e-7b92-554f-815e-1172750cb410', '6fec4c38-d2b7-5cd5-97d3-3f6d98eb1983', '8ed0d8fa-a6c0-5a3b-99fd-67c7933649a2', 'bfdf167d-ead8-59f1-8765-5e153d53ce04', '092f68cd-c5fb-5871-a9f4-8289297f2d25', 'ddc055af-0de6-55ba-9ab0-e5522b41693e', 'bd0a9000-5ac2-5cea-8a1b-b364dd2079ea', 'ea51fbdd-842b-582f-b415-047c6493b22a', '5f37f5b5-cec9-5215-a863-6cb041741e54', '2724ba12-345a-5252-9808-6e752b323e7d', 'fdca2a8b-6458-56c1-95a1-aad6ce5e0887', 'cdccd841-61cd-5510-a669-d9a1f65dd86a', '98e35fa0-b32e-5cd1-96ef-b5dd484860ff', '890dd7da-5b5d-5ce7-a764-d43c5edabb86', 'dc108721-4168-52c3-8180-4bf7113c386c', '1f8b2157-c3c6-5df6-97cd-79400625919e', '51ee5797-f336-5841-bc11-be8bbbde4639', 'e649e8bd-7cfd-582f-a98e-126ff83a9855', '9a9e5649-fb10-5002-8958-cf0cff5f43cd', '837fc01b-664a-50df-b1b2-29c2f996a557', '9dae6f2d-61f2-5429-82bd-b552fa0f570b', '9509386d-e6c5-5cd7-bd83-68d4cd9bcbb7', '99fe7445-81ed-547f-b4fa-1f75d6de7506', 'f9cf4b8d-2218-5f64-a474-58efa77078aa', '283ad7ec-a5a0-5b92-83cb-2fab8cf3ffcd', '43d62276-34b4-564d-9f32-2f4f11d287a7', '2bf3a1df-e0d5-5211-9eff-a84b027ef58f', 'dae35bdf-5a0a-539b-9142-42272fb105ec', 'ca70079d-29a4-55a6-b89b-d2ab64db85a0', '5a7666e2-58cd-5ac0-b485-f9eb43f9edf9', '8a8588d7-9d87-5119-bd73-52ebbb4a5939', '7c888859-3a45-503d-9a5d-a94e5633e4c8', '1540d611-eaca-5464-aceb-88a6920d1c48', 'd1a2d8c6-134b-5f60-a503-5082c5306a60', 'e4dd21af-2a1b-5f70-978d-72bc4f4125a2', 'eaac612b-a180-5f0d-9b20-727a9f05e8bb', 'b77989c1-876d-5699-bf4f-cb242fb87d19', '194a10a3-5a06-5d07-b3ce-40d0f1f2ee7d', '1ec4abc9-a818-506a-a1a3-5f6b5ace807d', '5bcfb9f5-9df7-5283-ad65-ab95213e1c54', 'd56629f3-10a9-5d12-871b-5d635cf68c03', 'd492c9ad-39f1-59c3-b758-2d8965f1acc5', '9601949a-6032-5c4b-b50b-f96ed0857c51', '6a5e1531-62b2-5d75-ad89-00a4ac41caa6', '49bde629-d2c7-55de-aea4-b5bcbcbed777', '3f8b29e8-30a2-5724-a7ca-f88c78e45745');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'francais-a2' AND source = 'admin' AND id NOT IN ('bd839674-16d1-5a2c-af43-cad59618eb71', '8a042748-f07e-5155-99cc-3a9d0c487a5a', 'e4221a6e-df40-59db-9cdc-f7b32c1cc1a7', '94f7671b-76a1-526a-b011-5e932afcf877', 'e1d9419c-4acc-5fb6-848b-fe81989f2472', 'cdbfe01a-d513-54cb-8141-cf47fef8be1f', 'a75f65e3-be64-57d2-9096-2bdd8810099c', '0fc2782b-5804-5297-8899-85c84d7aa10f', '0015e00d-b558-55c5-b7b7-98faa4ce4513', 'acbe0952-a6ff-5981-b1f6-094bfb2d418d', '0453ef21-0625-5629-a93d-489a37c3a597', 'c0fc7d48-9428-5456-b45b-28c206ea698a', '3d7d0d62-ae37-5ca7-9a4b-0a160ee18d42', '2978f60a-fea9-550a-8ed7-0b5c1f020662', 'f8f14423-6dbf-5dcf-b93f-37463a49cd53', '336cb417-149a-52b1-bfca-178f54f2adff', 'c4466f78-3969-53b8-81b3-0e5bf7cd760f', '53a405d9-9966-5e3c-80b0-a12210c841b5', 'ae674f67-12e4-5dc3-bd23-932d19e9b4ea', 'db8a292d-259f-58e3-9093-f463ffbc9dce', '9960a5f5-e58f-52f8-9567-c3c8ae17113d', '2f105ab6-15e4-5432-8809-0a55fec298ab', '21200971-06e3-5525-bbec-d5716d686dc6', '9bf3a6b5-e6e7-52ed-8c23-cf15f0356ef1', '215059d2-4e88-5b7b-ad00-6d16e78e01a4', '218a2e71-5684-58e4-882b-051f86393211', '469b75ba-60ef-5d55-ba38-5c6da7f90ad6', 'fcd7cf4a-baf0-570f-a708-772e4cdc6cdc', 'bfd67d1e-1307-5a61-99b4-7921894d58b2', 'ef7d9053-a028-5e9f-a21b-4391791ba960', '1ca775db-a583-5534-8c1c-879f5643e335', '69d10357-9c0a-5ad3-9c46-d9900b4a7b2d', '5c6cf71f-c031-5bf4-b43d-a802ffbba359', 'b45edbc8-aa8e-59d3-b0b8-8b8d0a057d56', '54109f37-fe41-51dd-9bf4-4153280f86cc', '28586578-8bab-5e9a-b373-bac2e5424d35', '1570485f-47a9-52af-a1d8-ac0712f76e7e', 'b2a65a22-02e2-5cbf-8e13-68d0302682a8', 'e4137aec-4530-5297-88a3-a9cd2022f472', '58a47bc3-50b8-5e6e-b76a-a672d09bf8b8', '11096117-bd07-56a8-98bc-d7122f2e3543', 'f164cc5b-f6a1-5106-9657-f557933a5051', 'e2ba8856-7c25-5a4d-be93-21a9729222ba', '43b4f33b-efda-521b-b0b6-5e658f5f4b92', 'f6f5fe2a-cd2b-5191-80b3-746143e7b20d', 'd7ad75f6-d1ea-58dc-b678-f188f694bbfe', 'a92abe5b-b0e4-5a3e-9af2-d2847d4e038c', '3b3dce45-d984-53ce-b23a-a88aff054231');
DELETE FROM public.questions WHERE exercise_id IN ('bd839674-16d1-5a2c-af43-cad59618eb71', '8a042748-f07e-5155-99cc-3a9d0c487a5a', 'e4221a6e-df40-59db-9cdc-f7b32c1cc1a7', '94f7671b-76a1-526a-b011-5e932afcf877', 'e1d9419c-4acc-5fb6-848b-fe81989f2472', 'cdbfe01a-d513-54cb-8141-cf47fef8be1f', 'a75f65e3-be64-57d2-9096-2bdd8810099c', '0fc2782b-5804-5297-8899-85c84d7aa10f', '0015e00d-b558-55c5-b7b7-98faa4ce4513', 'acbe0952-a6ff-5981-b1f6-094bfb2d418d', '0453ef21-0625-5629-a93d-489a37c3a597', 'c0fc7d48-9428-5456-b45b-28c206ea698a', '3d7d0d62-ae37-5ca7-9a4b-0a160ee18d42', '2978f60a-fea9-550a-8ed7-0b5c1f020662', 'f8f14423-6dbf-5dcf-b93f-37463a49cd53', '336cb417-149a-52b1-bfca-178f54f2adff', 'c4466f78-3969-53b8-81b3-0e5bf7cd760f', '53a405d9-9966-5e3c-80b0-a12210c841b5', 'ae674f67-12e4-5dc3-bd23-932d19e9b4ea', 'db8a292d-259f-58e3-9093-f463ffbc9dce', '9960a5f5-e58f-52f8-9567-c3c8ae17113d', '2f105ab6-15e4-5432-8809-0a55fec298ab', '21200971-06e3-5525-bbec-d5716d686dc6', '9bf3a6b5-e6e7-52ed-8c23-cf15f0356ef1', '215059d2-4e88-5b7b-ad00-6d16e78e01a4', '218a2e71-5684-58e4-882b-051f86393211', '469b75ba-60ef-5d55-ba38-5c6da7f90ad6', 'fcd7cf4a-baf0-570f-a708-772e4cdc6cdc', 'bfd67d1e-1307-5a61-99b4-7921894d58b2', 'ef7d9053-a028-5e9f-a21b-4391791ba960', '1ca775db-a583-5534-8c1c-879f5643e335', '69d10357-9c0a-5ad3-9c46-d9900b4a7b2d', '5c6cf71f-c031-5bf4-b43d-a802ffbba359', 'b45edbc8-aa8e-59d3-b0b8-8b8d0a057d56', '54109f37-fe41-51dd-9bf4-4153280f86cc', '28586578-8bab-5e9a-b373-bac2e5424d35', '1570485f-47a9-52af-a1d8-ac0712f76e7e', 'b2a65a22-02e2-5cbf-8e13-68d0302682a8', 'e4137aec-4530-5297-88a3-a9cd2022f472', '58a47bc3-50b8-5e6e-b76a-a672d09bf8b8', '11096117-bd07-56a8-98bc-d7122f2e3543', 'f164cc5b-f6a1-5106-9657-f557933a5051', 'e2ba8856-7c25-5a4d-be93-21a9729222ba', '43b4f33b-efda-521b-b0b6-5e658f5f4b92', 'f6f5fe2a-cd2b-5191-80b3-746143e7b20d', 'd7ad75f6-d1ea-58dc-b678-f188f694bbfe', 'a92abe5b-b0e4-5a3e-9af2-d2847d4e038c', '3b3dce45-d984-53ce-b23a-a88aff054231') AND id NOT IN ('2005a6e5-346f-54e2-8fcd-bd557cfe909b', 'f7ab6ad3-7d91-5803-96b5-a9a0ca3c5cb7', '0224679a-c540-5ea4-bc06-c9d18246251a', 'ed13538a-b5b3-5c97-9156-69a832054e7f', '602afa6a-21ab-5410-9b04-a24cde6a5ef2', '37481b93-7f88-5b0c-9889-b8b4f0533330', '6596693b-c009-5569-b435-f4902295f6cf', '2fe39c4f-2e32-5006-90f6-fea7e56be473', '7b2d6496-80d9-5451-bb0c-89ff9b42fb06', '417b165f-fe14-5151-812e-fbc9306d92a1', '29d88b46-daf0-57d3-9675-30a145ec8e80', 'f9d831e5-d008-58f0-8a41-2f77ceba2397', '40a82e20-0442-5eae-a9ee-c8d90d6c9f14', '60952eba-9cc9-55ea-b99c-7b639f253ec6', 'cc1d208b-340b-5bcb-a4b1-b2744619e4d4', 'd38e309b-ad75-5a22-9a98-70a41c3a0210', '1982efdf-6ad1-5d2c-8709-2f5981ec88e9', '93bd4d4a-6b38-5fdf-bc32-4ec27e7d34a3', 'c2416933-e664-5734-9c01-f937ef444063', '520e1404-84c9-55e3-bfdb-d20853bbf36e', '320af27b-11f3-5015-ae61-402d78b62459', 'd11d465b-082d-5d6a-ba47-ca6fad4e46af', '620e7d50-56d1-5ef9-bccf-fa52c4944574', 'e944b4cd-5a4b-5146-aa34-0c34baa00a63', 'c9556592-6474-5df7-b25c-07fbed875770', 'c4919146-cf60-5e26-baf9-cbed79ac898c', '3d1e8264-255e-55f0-94de-79c5e3eb0ca8', 'ddaa25ac-677c-5205-9c64-8920a36e6e4e', '4f5784f8-e8bf-58af-90a3-108eebf7418c', '57a44fcd-7c8a-5b3c-b14a-085fe8f98171', '1e08595a-3861-5372-a2c4-59385d0ab9c7', '08bde0aa-1a5f-5604-9fa5-669984c89d9b', '2df74076-99a8-5941-96d9-5ec67f14a03b', '962bc088-3f8a-5bb8-9cb0-45fc7d79fbab', 'b1a0aae4-5c2b-5d62-8157-7333f1589e19', '168f5560-fc15-52a0-94e3-7c5e2d8c7027', 'a3bd76f7-6507-5751-a880-5e39094f291b', '8b978f30-f08e-58fb-a044-3f7408f2a942', '67ec337f-dcdb-5244-9f9f-57ee7fb3c653', '63cee886-a092-5ced-ae64-de28509ed5b9', '915a8a81-4383-5205-bd19-fca75502e655', '0d53d402-15e5-5f11-a12a-d8d3f383985f', '96e64358-6bf5-5d8a-93b3-8107d94c5f70', '918f6817-1e41-5ffc-ae6e-748d17a6875c', 'd8cdddd3-15f3-5180-97cb-e35d31e76cd1', '9122d2ce-69a8-532d-b1c3-c83540c39c00', '6ca3a5cd-e731-55df-b8b2-c7fbe1303396', '834c59a1-160a-5086-8d12-ab210dad6291', '516ad169-a724-58b9-9757-37ffaf8a4955', '4919eac7-6990-54bd-941b-4dcf41b4504e', 'b6576a3f-4862-5d83-93f9-0e2ec985ccea', 'a5ff9761-1f18-5b91-819d-fc04da5e0dc8', '6bd53e1c-3f2e-57ed-bacc-4ea70ff4445b', 'fafe1803-d3d5-5c6b-8d17-91453a7b9e38', '749543af-0164-53d3-894d-532d4c4a5f00', '1eed5120-4613-55ac-9ca2-18bf22be7a54', '552c04bc-0120-56e3-b436-94965565d607', '05dcd64d-a9c2-5527-ad33-9fd63662ce3b', '804d5279-ff81-5bc7-991c-7f37747c1928', 'c2e2db70-d20b-596a-ac03-de97e1e1670e', 'a43ef917-1a42-500c-9cce-cd01b00dc13e', 'e8dcad47-b184-5f88-a304-f55dcbc8bbb0', 'c13f7d01-b441-5619-8a1b-d7d0d648bcb4', '24cc9b7b-d23e-5798-8c08-498e22776c7c', 'b269d687-4ae0-5c59-addf-ce3d34e085d2', '61981da2-e7f6-52e5-b311-d99dffa06100', '9a58942e-85ca-5aea-8607-b5a137f3ea34', '34858e86-a6f1-542c-ab01-f854c5e12f09', 'ed2ad108-0c44-5bff-9503-020275d20b11', '3fcba4d8-8dbc-5c53-857b-93133c77c939', '29e91369-37b3-52bf-bf90-52ddceda417b', 'af18154c-631a-51e0-ae3b-3b4be5b2c946', '90a65ae6-b2fe-5267-ba2a-cae04ee7b8c2', '1c2d26ca-5455-51fb-98cc-da410b3118b6', 'aa6491ff-2936-52f3-93d8-53e068c26990', '042ddedf-ac26-500b-94e4-b2d032a49ea2', 'ccf6b8bd-7b68-5e4a-b597-28df10cbe770', 'c2bfeb3c-d951-572f-adb6-5dfff7a27a40', '7d7ac80c-2528-5f07-898d-d8624a3598eb', 'cb7a0124-7262-5b23-ad81-0cdd7fbb1995', '8b8bb36b-ecd1-55de-9030-825a58237dd0', 'beec616f-671c-52ad-9c5b-f995d0f9bac4', '8e59f2ac-67ef-54c8-82a1-95943e9aa7f4', '5a9fa118-db5a-5459-959c-caad128784c3', 'dc558038-0cfa-5618-b6b8-8f38d3303263', '48708813-e053-56d5-a278-2fa44c639e69', '2c7ebe50-1950-5be1-9841-b1283ece77d7', '6e2ba244-01e5-5a8c-8b18-9ddb5c34d375', 'f5a0888b-c7a0-54c9-b5df-5734ab49d7d5', '313ab95b-6cf3-59ff-82f3-cf8fded5275b', '7868e60e-111f-5f31-9994-7438295f31c3', '207c8e07-3209-5e9a-94ff-87817cea8202', '12e14128-ff35-518e-83a3-6379b25ccb4b', 'db8d2846-35e8-58e7-ae32-da953d906be4', '465b3487-143f-5120-b114-44ab588cc366', '226ee550-734e-57ae-8ca9-e4acade70454', '781c1518-5a48-51ad-9db6-03b835b77e73', '3a65a7fa-b305-537d-beb7-b85054b61e20', 'edb49c48-89a6-5854-875e-ce3a9a609c2b', '689d7b32-67a5-54ca-94ab-64388d2d6ea8', '2656fe34-1a7e-5b34-b460-c7e1ef79b209', 'a4cb6aa9-6984-524a-afdd-3bf29732fb78', 'adf1ae50-5beb-57a3-910d-4aba27f31791', 'db757d34-c8ef-551d-b6df-3f6800072e11', 'c3d48b5a-ddf9-5fb9-a35f-e173eb75af66', 'd455099f-df30-573a-9beb-de02ea9fe393', '891c1d85-e42e-5955-942e-b27530ac5d94', '32f4d3a8-25a2-514f-9537-ca86fc77d4d2', '2803d635-b200-5095-9b67-07781e519519', 'a1f53d39-e1fd-5fa4-92d6-8a0ceb597fe9', 'b2c9f0db-2f23-55da-9309-23c05e0c1501', '369d9d8d-6a95-54db-8686-eb31e9f0005d', '157be412-8158-54aa-90a1-967f8504fe78', '5117b93d-25a2-5dae-8214-4ff515d1f739', 'ddff942b-5544-5547-b44a-8f53e9b51d86', 'd99a7fdd-a2ce-5a81-a83c-9f232b0fc16a', 'e89968d1-c277-5a0a-9822-04d646e9a029', '873ab387-21e4-54f2-8c28-d05d22080277', 'b134a227-458a-588d-b270-799e14a312db', '717fc826-cc27-54f9-8b8d-a6afd85ff366', '62a24bca-84e3-525d-8fa1-9e76f62ff646', 'aebd793a-8c0c-505c-805e-9f824f3d1d1b', '4b23022b-5077-5168-a78e-033eb3b0c9ba', '338a8c50-6126-55f7-8899-5d4d7af3582d', 'f1fff0c6-b2ea-51d9-8579-d989bd9b8ba5', '9bf1f6d7-908e-5bd7-a52b-3c4af8237538', '065f0540-daa7-5c5e-aaf3-61a951b02ef7', '3ba87b9d-f3c1-5d92-ad4c-7a7ea8462b9f', '7ef04cc1-c682-5aff-b990-24134e5cfcef', 'f0eada00-2e20-5dec-a5d1-75a7951a0ab9', '8df02d18-71d6-557a-b79d-d60b60ad9029', 'b0531c1f-c7a3-5e50-bb64-a2f9d8b854e7', '73218580-7fde-5c4a-88c9-7d552d7fc84c', 'abbcc5ed-8e97-5b55-b76e-83f76dbd71a6', '70001201-93ba-58ac-acb5-04122829a7ff', '258fefd1-8ee2-5fa7-8b6a-74ddf8a04dd8', '9c464a1b-b232-53af-8a98-4e6d4f0177c0', '9673b149-9de2-57d8-ae59-b8b191ac8b4d', 'e46a90a8-dacd-5176-8576-1aa9944e36e4', '96fa8acd-1bda-5213-ab3d-5e755bf3d1ff', '5d601974-fbb4-5f5b-93b2-4484063ed207', 'c123b5ef-92a8-5e08-b606-dd690458801d', '27a10274-00a4-5cb4-bc7a-2f9bebde4daf', 'c74fe1f7-ad92-5228-aa0c-1ba004c65b4d', '93acbbcf-981b-55f8-b31b-fe3d11a7ff86', '7a8d3829-ca21-55de-81bc-78aba7695191', '56cea120-2f30-569f-a5d8-983c3ac1cd37', '81a1110f-8eb7-5e0f-951a-6df4422d9f7b', '9e7c15a0-1fdf-5d38-9fa0-7a18cea0d4de', '597d45ac-c7ae-5081-8321-77fb0c5d02ee', 'c54cd258-b7aa-5321-bf01-7336a9ef3f38', '8d436275-ba32-5a2e-bab3-3f7bf1a6c4a1', 'd149e620-56bc-562d-b0e0-1d30b1c5d2f4', 'f9fd9d5d-8437-5c0d-894c-d8a898d661d3', 'f94fd050-9ecb-57e4-91bb-c46bda672d41', '9aa5d739-114b-5528-a464-e2155ed57d3f', '78b032e0-a898-5438-8f53-845b887c61fc', 'f8dfa9b9-dcaf-50aa-80dd-fd176fc080da', 'cefd0920-3153-5867-9da6-60f6c491bfd5', '5d509dbe-8f0c-5966-9a1d-03b2e3eb49c5', '7535a1dc-07f0-5d0e-8830-d67d34227111', '9fabb966-2535-5e0b-bd36-f39f0dbc9dfc', '9c51717e-a333-5d69-b586-7bab5e6ae06f', 'c907230d-c700-587e-baed-2ec96c9c4814', '31ee1abf-9c84-5e12-9d43-5b4488c5717f', '963596d0-05df-5197-96c0-f60c4e729d07', '696d9881-2902-5b0f-a728-7cb899f9bffd', 'daaa9758-d5cd-5b6e-89e9-d0310e6c36f0', '22581f3f-2185-59a6-89c4-4008d4c508a0', '652ca3ab-de82-5be8-8d06-fa7477a4b5bb', '094ccb96-1cc4-5ec1-8580-b4c7037508b6', '2b258f51-070e-5e52-b550-d070972e0f2d', '7869ed0e-3c20-5b5e-ae13-ae8881ad9f49', 'a26f9f06-87e2-5c1b-9bbc-1cd655493c41', '8d1a1b0f-c393-551a-b8b7-143f198960d3', 'e341f48c-94bf-5c69-926a-36fc18b5a1ad', 'aa38bff9-0571-50a4-b9d7-309ad0fde2e9', 'd49a679f-2c3e-5ab1-af7c-d2ce07075a2d', '2637230c-e82a-5db0-b757-a98277fbde07', 'd9b3952e-516a-500f-a52b-22935730f013', '95049d19-d751-5d5e-8dcc-d187e1ae08b1', '8fed06cd-e5b6-5c66-98ea-fc45d977a75d', '1a8900b8-8df6-526e-8eee-a4fb951ec2c7', '3ce33e7d-442e-5eb4-a68c-21e29c647b3a', 'e9340a33-2632-5787-8b01-a82f3379c69f', '7e943a2e-96ac-5a36-b9b0-e18c67a5227e', '6e249a74-356f-54ed-ab57-70d8243e9a79', '63e05cb4-169e-5a21-847b-b2cd50d93d88', '34ef428c-0ce3-5677-98b7-0c30deeab5ed', '8859d84d-0359-5a19-9fce-89463b75e37f', '6f443a56-ca80-54f1-aee7-3cde84b295cf', '77571e40-8d99-5c8e-85e4-e99bd86e31d0', 'def4af47-7408-5bec-87b9-c6e9a59a6b4b', '755436f1-cd18-5bd5-a286-f79848dfed0f', '9cc1bc40-891e-5e6d-8aac-8fcce7cdf1b5', 'd044df80-8faa-5111-bf09-3fdf1aa0b070', '61d2e80c-6970-59c3-8243-d27e25fd2ba8', '794066f0-487c-52e0-8f44-e49b74d7d85b', '83ff0932-86c5-5a03-9028-e790de66fec5', '92c5d7d2-af0e-5200-96f1-941549e89b9f', 'caf0c786-2919-5874-a4bd-ecdfb0ca53bf', '44028074-3c2e-5df0-a193-be6d97ef3108', 'cb9fa363-668d-59e5-94f7-c79b6802aaa1', '550155a1-9cff-5d3c-8b52-aef5a6ea931c', 'a4d50ec7-a6a7-50ed-9066-ffa03e8e2879', 'f733fd44-b885-519b-8a96-cdb7f6ea39c4', 'cf5287d9-c124-54bf-aef5-6e6b9460fa2e', '194641cf-1a91-53d0-95d4-3662cc51b002', '6b17412b-e2e6-5a5a-b7b8-d60735c970e9', '43c0a824-6d0e-55ff-9865-0d8ea9df6879', '9a8ee112-f606-52bb-ade5-e6b0063befa0', 'b9477bf5-9be2-53c1-8e71-0bb9c555eeae', '75e5ae9d-c178-5d28-a41b-64dbe35108f4', 'beda8e6c-7e6b-59a2-a264-442b98e4957a', '4014dd03-4642-5e8d-be8c-841c708b7d7a', '0224bb92-f8c9-5b67-a0a5-91fa805b819b', '3b7db18c-ad25-5cc9-abd4-bf84a2001c79', 'bf3c56cd-5e8d-56ba-899c-a3796e769a04', '84372228-eeb0-5b94-989f-092536843422', '19f8b1fd-7814-5d62-a83f-91c29525df67', 'aedc6648-47b6-55d6-8054-ab09bb0672e2', '8b97473f-1cd3-5346-aefd-d84c1037d769', '34667fb0-af57-5515-ad7f-ce58a55dcbba', '6ab317c9-a988-57c5-ad43-9c84dca4d9e0', '3c477d5a-6536-574d-a85a-b7806d78209a', '8bec889f-dac8-5396-8874-af91083f64e9', '164f0371-5299-553b-8d55-115c8fe8b646', '976524b7-916a-586c-821f-e941fb228ed4', '9564d2f5-bf46-52ec-9499-f4fbc3e5d738', '591030b8-3c27-5f39-bdd7-5446dca2c0a0', 'e1a09795-3e27-5e00-b206-dfc5990b6250', 'e11f0dfa-0f42-5840-a927-a1de4e7d8dee', '3e4355b6-96ce-5bbd-8858-c1e709e647de', '585a873d-01b1-59f8-85ab-2e2bba056b17', '1d5aec5e-7b92-554f-815e-1172750cb410', '6fec4c38-d2b7-5cd5-97d3-3f6d98eb1983', '8ed0d8fa-a6c0-5a3b-99fd-67c7933649a2', 'bfdf167d-ead8-59f1-8765-5e153d53ce04', '092f68cd-c5fb-5871-a9f4-8289297f2d25', 'ddc055af-0de6-55ba-9ab0-e5522b41693e', 'bd0a9000-5ac2-5cea-8a1b-b364dd2079ea', 'ea51fbdd-842b-582f-b415-047c6493b22a', '5f37f5b5-cec9-5215-a863-6cb041741e54', '2724ba12-345a-5252-9808-6e752b323e7d', 'fdca2a8b-6458-56c1-95a1-aad6ce5e0887', 'cdccd841-61cd-5510-a669-d9a1f65dd86a', '98e35fa0-b32e-5cd1-96ef-b5dd484860ff', '890dd7da-5b5d-5ce7-a764-d43c5edabb86', 'dc108721-4168-52c3-8180-4bf7113c386c', '1f8b2157-c3c6-5df6-97cd-79400625919e', '51ee5797-f336-5841-bc11-be8bbbde4639', 'e649e8bd-7cfd-582f-a98e-126ff83a9855', '9a9e5649-fb10-5002-8958-cf0cff5f43cd', '837fc01b-664a-50df-b1b2-29c2f996a557', '9dae6f2d-61f2-5429-82bd-b552fa0f570b', '9509386d-e6c5-5cd7-bd83-68d4cd9bcbb7', '99fe7445-81ed-547f-b4fa-1f75d6de7506', 'f9cf4b8d-2218-5f64-a474-58efa77078aa', '283ad7ec-a5a0-5b92-83cb-2fab8cf3ffcd', '43d62276-34b4-564d-9f32-2f4f11d287a7', '2bf3a1df-e0d5-5211-9eff-a84b027ef58f', 'dae35bdf-5a0a-539b-9142-42272fb105ec', 'ca70079d-29a4-55a6-b89b-d2ab64db85a0', '5a7666e2-58cd-5ac0-b485-f9eb43f9edf9', '8a8588d7-9d87-5119-bd73-52ebbb4a5939', '7c888859-3a45-503d-9a5d-a94e5633e4c8', '1540d611-eaca-5464-aceb-88a6920d1c48', 'd1a2d8c6-134b-5f60-a503-5082c5306a60', 'e4dd21af-2a1b-5f70-978d-72bc4f4125a2', 'eaac612b-a180-5f0d-9b20-727a9f05e8bb', 'b77989c1-876d-5699-bf4f-cb242fb87d19', '194a10a3-5a06-5d07-b3ce-40d0f1f2ee7d', '1ec4abc9-a818-506a-a1a3-5f6b5ace807d', '5bcfb9f5-9df7-5283-ad65-ab95213e1c54', 'd56629f3-10a9-5d12-871b-5d635cf68c03', 'd492c9ad-39f1-59c3-b758-2d8965f1acc5', '9601949a-6032-5c4b-b50b-f96ed0857c51', '6a5e1531-62b2-5d75-ad89-00a4ac41caa6', '49bde629-d2c7-55de-aea4-b5bcbcbed777', '3f8b29e8-30a2-5724-a7ca-f88c78e45745');
DELETE FROM public.chapters c WHERE c.subject_id = 'francais-a2' AND c.id NOT IN ('ed25655b-24e2-5474-8154-276b57332fd5', 'cf8cd70e-d021-5c57-a8a3-47956ffed3ed', 'de301347-ce07-5492-a3d5-072b4fde36ce', '147e3a6d-3d6e-5a25-8592-1d951f2df95e', 'ec5ed2f8-770d-57f7-aab4-8c1d66902308', '33a75aa3-935a-5d73-98e8-9184127c935a', 'aaee51e0-fcfc-5a5a-b971-e3dd7c6c3ae9', '1a10a5c0-adba-527c-8b7e-2464f0ee9f67') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('ed25655b-24e2-5474-8154-276b57332fd5', 'francais-a2', 'Le passé composé', 'Raconte des actions passées et terminées : la formation (auxiliaire avoir ou être au présent + participe passé), les participes passés réguliers et les irréguliers fréquents, le choix de l''auxiliaire (verbes de mouvement et verbes pronominaux avec être) et l''accord du participe passé avec le sujet quand on emploie être.', '# ⚔️ Le passé composé — Raconte tes batailles d''hier

> 💡 «Chaque héros a une histoire. Le passé composé est l''arme qui te permet de la raconter : ce qui s''est passé, et qui est terminé.»

## 🏰 À quoi sert le passé composé

Le **passé composé** raconte une **action ponctuelle et terminée** dans le passé. L''événement est fini, fermé : _hier, la semaine dernière, en 2015, il y a deux jours._

_Hier, j''**ai mangé** une pizza. Elle **est allée** au cinéma._

Tu connais déjà _être_ et _avoir_ au présent (niveau A1) : ils deviennent ici tes deux **auxiliaires**.

## ⚡ La formation : auxiliaire + participe passé

Le passé composé se construit toujours en **deux morceaux** :

$$ auxiliaire (avoir ou être au présent) + participe passé $$

_J''**ai** parlé. · Nous **avons** fini. · Il **est** parti._

## 🔮 Le participe passé : trois familles

| Infinitif         | Terminaison du participe | Exemple                            |
| ----------------- | ------------------------ | ---------------------------------- |
| verbes en **-er** | **-é**                   | parler → _parlé_, manger → _mangé_ |
| verbes en **-ir** | **-i**                   | finir → _fini_, choisir → _choisi_ |
| **irréguliers**   | à apprendre par cœur     | voir → _vu_, prendre → _pris_      |

Les irréguliers les plus fréquents à mémoriser :

| Infinitif | Participe | Infinitif | Participe |
| --------- | --------- | --------- | --------- |
| avoir     | eu        | être      | été       |
| faire     | fait      | prendre   | pris      |
| voir      | vu        | mettre    | mis       |
| venir     | venu      | vouloir   | voulu     |
| pouvoir   | pu        | devoir    | dû        |

> 🗡️ Astuce : il n''y a pas de règle pour les irréguliers — fais une liste et entraîne-toi sur les 15 plus courants. Ils couvrent presque tout ce que tu diras.

## 🛡️ Avoir ou être ? Le choix de l''auxiliaire

La **plupart** des verbes se conjuguent avec **avoir** : _j''ai mangé, tu as vu, nous avons pris._

Mais deux familles utilisent **être** :

- Les **verbes de mouvement ou d''état** : _aller, venir, partir, arriver, entrer, sortir, monter, descendre, naître, mourir, rester, tomber, retourner, devenir._
- **Tous les verbes pronominaux** : _se laver, se lever, se promener._

_Elle **est** sortie. Ils **sont** arrivés. Je **me suis** levé tôt._

> 🗡️ Moyen mnémotechnique : la « maison de être » regroupe ces verbes d''aller-venir, monter-descendre, naître-mourir.

## 🧮 L''accord du participe passé

C''est LE point clé du chapitre — et le grand piège.

| Auxiliaire | Accord du participe            | Exemple                                    |
| ---------- | ------------------------------ | ------------------------------------------ |
| **être**   | s''accorde avec le **sujet**    | _Elle est all**ée**. Ils sont part**is**._ |
| **avoir**  | **pas** d''accord avec le sujet | _Elle a mang**é**. Ils ont fin**i**._      |

Avec **être**, on ajoute **-e** au féminin, **-s** au pluriel : _Elle est venu**e**. Elles sont venu**es**._

> ⚠️ Piège : on n''accorde **jamais** le participe avec le sujet quand l''auxiliaire est _avoir_ → _Elle a mang**é**_, jamais _~~Elle a mangée~~_.

> 🏆 Porte franchie ! Tu sais maintenant raconter tout événement passé : choisir l''auxiliaire, former le participe et l''accorder. Prochaine étape : l''**imparfait**, pour décrire le décor de tes histoires.', '# 📜 Résumé : Le passé composé

- **Usage** — une action passée, ponctuelle et terminée (_hier, la semaine dernière, en 2015, il y a deux jours_).
- **Formation** — auxiliaire (_avoir_ ou _être_ au présent) + participe passé : _j''ai parlé, elle est partie_.
- **Participe passé** — -er → **-é** (_mangé_), -ir → **-i** (_fini_), irréguliers à apprendre (_eu, été, fait, pris, vu, mis, venu, voulu, pu, dû_).
- **Auxiliaire avoir** — la plupart des verbes : _j''ai vu, nous avons pris_.
- **Auxiliaire être** — verbes de mouvement/d''état (_aller, venir, partir…_) et tous les pronominaux (_je me suis levé_).
- **Accord avec être** — le participe s''accorde avec le **sujet** : _elle est allée, ils sont partis, elles sont venues_.
- **Accord avec avoir** — **pas** d''accord avec le sujet : _elle a mangé_, jamais _elle a mangée_.
- ⚠️ Pièges fréquents : mauvais auxiliaire (_j''ai allé_), accord oublié (_elle est allé_), participe faux (_j''ai prendu, il a faisé_).', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('cf8cd70e-d021-5c57-a8a3-47956ffed3ed', 'francais-a2', 'L''imparfait : décrire et raconter le passé', 'Forme l''imparfait à partir du radical de « nous » au présent (nous parlons → parl-) plus les terminaisons -ais, -ais, -ait, -ions, -iez, -aient, avec la seule exception du radical être → ét-. Sers-toi de l''imparfait pour décrire le décor d''une histoire et exprimer les habitudes du passé, et apprends à le distinguer du passé composé (description vs action ponctuelle).', '# ⚔️ L''imparfait — la magie du décor passé

> 💡 «Le passé composé fait avancer l''histoire ; l''imparfait pose le décor. Maîtrise les deux et tu deviens conteur.»

## 🏰 À quoi sert l''imparfait

Tu sais déjà raconter une action terminée avec le **passé composé** (_j''ai mangé, je suis parti_). Mais une histoire n''est pas qu''une suite d''actions : il faut aussi **planter le décor**. C''est le rôle de l''**imparfait**.

L''imparfait sert à :

- **décrire** le passé — le temps, le lieu, les personnes, les sentiments : _Il **faisait** beau, le ciel **était** bleu, j''**avais** dix ans._
- raconter une **habitude**, une action **répétée** : _Quand j''**étais** petit, je **jouais** au foot tous les jours._
- présenter une action **en cours** quand une autre survient : _Je **dormais** quand le téléphone a sonné._

## ⚡ La formation : un seul moule pour presque tous les verbes

La recette est régulière et puissante. Prends le verbe au présent à la personne **« nous »**, enlève la terminaison **-ons** pour garder le **radical**, puis ajoute les terminaisons de l''imparfait.

$$ radical de « nous » (présent) + ais / ais / ait / ions / iez / aient $$

_nous parl**ons** → radical **parl-** · nous finiss**ons** → **finiss-** · nous pren**ons** → **pren-**_

| Personne  | parler        | finir           | prendre       |
| --------- | ------------- | --------------- | ------------- |
| je / j''   | parl**ais**   | finiss**ais**   | pren**ais**   |
| tu        | parl**ais**   | finiss**ais**   | pren**ais**   |
| il / elle | parl**ait**   | finiss**ait**   | pren**ait**   |
| nous      | parl**ions**  | finiss**ions**  | pren**ions**  |
| vous      | parl**iez**   | finiss**iez**   | pren**iez**   |
| ils/elles | parl**aient** | finiss**aient** | pren**aient** |

> 🗡️ Astuce : **je**, **tu** et **il/elle** se prononcent pareil (_parlais = parlait_), mais s''écrivent différemment. Et **-aient** (ils) est muet : on entend « parlait », on écrit _parlaient_.

## 🛡️ La seule vraie exception : être → ét-

Tous les verbes suivent la règle du radical de « nous »… **sauf être**. Comme « nous sommes » ne donne pas de radical utilisable, l''imparfait d''être se forme sur **ét-** :

| Personne  | être        |
| --------- | ----------- |
| j''        | **étais**   |
| tu        | **étais**   |
| il / elle | **était**   |
| nous      | **étions**  |
| vous      | **étiez**   |
| ils/elles | **étaient** |

_J''**étais** fatigué. Nous **étions** en vacances. Ils **étaient** contents._

> 🗡️ Trois formes très fréquentes à mémoriser : _il y **avait**_ (il y a → passé), _il **fallait**_ (il faut), _il **faisait**_ beau (faire).

## 🔮 Imparfait ou passé composé ?

C''est le grand duel du niveau A2. Les deux parlent du passé, mais pas du même angle :

| Imparfait                         | Passé composé                          |
| --------------------------------- | -------------------------------------- |
| description, décor, contexte      | action **ponctuelle**, événement       |
| habitude, action **répétée**      | action **unique**, faite une fois      |
| action **en cours** (le fond)     | action **soudaine** (le premier plan)  |
| _Il **pleuvait**, je **lisais**._ | _Soudain, la lampe **s''est éteinte**._ |

La phrase type combine les deux : le **décor à l''imparfait**, l''**événement au passé composé**.

_Je **regardais** la télé quand le téléphone **a sonné**._ (je regardais = le fond ; a sonné = l''événement)

> ⚠️ Piège : ne confonds pas l''habitude (imparfait) et le fait unique (passé composé). _Tous les étés, nous **allions** à la mer_ (habitude) ≠ _L''été dernier, nous **sommes allés** à la mer_ (une fois).

## 🧭 Les mots qui appellent l''imparfait

Certains marqueurs annoncent une description ou une habitude, donc l''imparfait :

_**autrefois** · **avant** · **quand j''étais petit** · **tous les jours / chaque matin** · **d''habitude** · **souvent** · **pendant que** · **en ce temps-là**._

> 🏆 Porte franchie ! Tu sais maintenant poser le décor d''une histoire et raconter tes souvenirs. Prochaine étape : marier imparfait et passé composé dans un vrai récit, puis te projeter dans le **futur**.', '# 📜 Résumé : l''imparfait

- **Usage** : l''imparfait décrit le passé (décor, temps, personnes), exprime une habitude ou une action répétée, et présente une action en cours.
- **Formation** : radical de « nous » au présent (nous parlons → parl-, nous finissons → finiss-, nous prenons → pren-) + terminaisons -ais, -ais, -ait, -ions, -iez, -aient.
- **Exception unique** : être se conjugue sur le radical ét- (j''étais, tu étais, il était, nous étions, vous étiez, ils étaient).
- **À mémoriser** : il y avait, il fallait, il faisait (beau).
- **Pièges d''orthographe** : je/tu/il se prononcent pareil mais s''écrivent -ais/-ais/-ait ; la terminaison -aient (ils) est muette.
- **Imparfait vs passé composé** : imparfait = description, habitude, action en cours ; passé composé = action ponctuelle et terminée.
- **Phrase type** : décor à l''imparfait + événement au passé composé — « Je regardais la télé quand le téléphone a sonné ».
- **Marqueurs** : autrefois, avant, quand j''étais petit, tous les jours, d''habitude, souvent, pendant que.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('de301347-ce07-5492-a3d5-072b4fde36ce', 'francais-a2', 'Le futur : futur proche et futur simple', 'Parle de l''avenir de deux façons : le futur proche (aller au présent + infinitif) pour un projet sûr et proche, et le futur simple (infinitif + -ai, -as, -a, -ons, -ez, -ont) pour une prévision, une promesse ou un avenir plus lointain — avec les radicaux irréguliers fréquents et la négation.', '# ⚔️ Le futur — futur proche et futur simple

> 💡 «L''avenir a deux routes : celle du projet déjà tracé, et celle de la promesse lointaine. Le français te donne une arme pour chacune.»

## 🏰 Deux routes vers l''avenir

Pour parler de ce qui n''est pas encore arrivé, le français possède deux temps principaux : le **futur proche** et le **futur simple**. Ils ne sont pas interchangeables au hasard — chacun porte un message différent. Apprends _quand_ dégainer chacun et ton avenir en français sonnera naturel.

_Je **vais manger** dans cinq minutes. — Un jour, je **mangerai** à Paris._

Le premier parle d''un projet tout proche et certain. Le second d''une prévision plus lointaine. C''est tout le combat.

## ⚡ Le futur proche : aller + infinitif

On forme le **futur proche** avec le verbe **aller au présent** suivi de l''**infinitif** du verbe. On l''utilise pour un **projet sûr, proche**, et il est très fréquent **à l''oral**.

| Pronom     | aller (présent) | Exemple : _partir_     |
| ---------- | --------------- | ---------------------- |
| je         | **vais**        | je **vais** partir     |
| tu         | **vas**         | tu **vas** partir      |
| il/elle/on | **va**          | elle **va** partir     |
| nous       | **allons**      | nous **allons** partir |
| vous       | **allez**       | vous **allez** partir  |
| ils/elles  | **vont**        | ils **vont** partir    |

_Je **vais manger** une pizza ce soir. Nous **allons partir** demain._

Négation : on encadre **aller** par **ne … pas**. _Je **ne vais pas** manger. Ils **ne vont pas** venir._

> 🗡️ Astuce : après _aller_, le deuxième verbe reste toujours à l''**infinitif** — _je vais **partir**_, jamais ~~je vais pars~~.

## 🛡️ Le futur simple : un seul jeu de terminaisons

Le **futur simple** se forme sur l''**infinitif** + les terminaisons **-ai, -as, -a, -ons, -ez, -ont**. Ces six terminaisons ne changent **jamais**.

| Pronom     | Terminaison | _parler_           | _finir_           |
| ---------- | ----------- | ------------------ | ----------------- |
| je         | **-ai**     | je parler**ai**    | je finir**ai**    |
| tu         | **-as**     | tu parler**as**    | tu finir**as**    |
| il/elle/on | **-a**      | il parler**a**     | il finir**a**     |
| nous       | **-ons**    | nous parler**ons** | nous finir**ons** |
| vous       | **-ez**     | vous parler**ez**  | vous finir**ez**  |
| ils/elles  | **-ont**    | ils parler**ont**  | ils finir**ont**  |

Pour les verbes en **-re**, on **enlève le e** final avant d''ajouter la terminaison : _prendre → je **prendrai**_ ; _écrire → j''**écrirai**_.

> ⚠️ Piège classique : les terminaisons du futur simple commencent toujours par **r** + voyelle. On entend ce **r** : _je parle**r**ai_ ≠ _je parle_ (présent).

## 🔮 Les radicaux irréguliers à connaître

Certains verbes très fréquents ne gardent pas leur infinitif : ils ont un **radical spécial**, mais prennent les **mêmes terminaisons**.

| Verbe       | Radical futur | Exemple         |
| ----------- | ------------- | --------------- |
| **être**    | **ser-**      | je **serai**    |
| **avoir**   | **aur-**      | j''**aurai**     |
| **aller**   | **ir-**       | j''**irai**      |
| **faire**   | **fer-**      | je **ferai**    |
| **venir**   | **viendr-**   | je **viendrai** |
| **voir**    | **verr-**     | je **verrai**   |
| **pouvoir** | **pourr-**    | je **pourrai**  |
| **devoir**  | **devr-**     | je **devrai**   |
| **vouloir** | **voudr-**    | je **voudrai**  |
| **savoir**  | **saur-**     | je **saurai**   |

> 🗡️ Attention au piège des radicaux : on dit _j''**irai**_ (et non ~~j''allerai~~) et _je **ferai**_ (et non ~~je fairai~~). Apprends ces radicaux par cœur, ce sont les plus utilisés.

## 🧭 Proche ou simple ? Le bon choix

Pose-toi une question : **est-ce proche et sûr, ou lointain et prévu ?**

| Situation                        | Temps            | Exemple                                |
| -------------------------------- | ---------------- | -------------------------------------- |
| projet proche, certain, à l''oral | **futur proche** | _Je **vais appeler** le médecin._      |
| prévision, projet lointain       | **futur simple** | _En 2050, les voitures **voleront**._  |
| promesse                         | **futur simple** | _Je te **promets** : je **viendrai**._ |
| ton plus formel, écrit           | **futur simple** | _Le train **partira** à 8 h._          |

_« Qu''est-ce que tu fais ce soir ? » — « Je **vais regarder** un film. »_ (proche)
_Plus tard, je **deviendrai** médecin._ (projet lointain, plus formel)

> 🏆 Porte franchie ! Tu sais maintenant parler de l''avenir sur les deux routes : le futur proche pour le projet d''aujourd''hui, le futur simple pour la promesse de demain. Prochaine étape : **les verbes pronominaux** pour décrire ta routine (_je me lève, tu te laves_).', '# 📜 Résumé : Le futur — proche et simple

- **Deux futurs** — le futur proche et le futur simple expriment l''avenir différemment ; choisis selon le sens, pas au hasard.
- **Futur proche** — _aller_ au présent (vais, vas, va, allons, allez, vont) + **infinitif** : un projet sûr et proche (_Je vais manger_).
- **Négation du proche** — on encadre _aller_ : _Je **ne vais pas** manger ; ils **ne vont pas** venir._
- **Futur simple** — **infinitif + -ai, -as, -a, -ons, -ez, -ont** (_je parlerai_, _je finirai_) ; pour les verbes en **-re** on enlève le e (_prendre → je prendrai_).
- **Radicaux irréguliers** — être→**ser-**, avoir→**aur-**, aller→**ir-**, faire→**fer-**, venir→**viendr-**, voir→**verr-**, pouvoir→**pourr-**, devoir→**devr-**, vouloir→**voudr-**, savoir→**saur-**.
- **Emploi** — futur proche = proche, sûr, oral ; futur simple = prévision, projet lointain, promesse, ton plus formel.
- ⚠️ **Pièges** — dis _j''**irai**_ (pas ~~j''allerai~~), _je **ferai**_ (pas ~~je fairai~~) ; après _aller_ garde l''**infinitif** (_je vais **partir**_, pas ~~je vais pars~~).', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('147e3a6d-3d6e-5a25-8592-1d951f2df95e', 'francais-a2', 'Les verbes pronominaux', 'Décris ta routine quotidienne avec les verbes pronominaux : le pronom réfléchi (me, te, se, nous, vous, se) + le verbe, la conjugaison de se laver au présent, l''élision (je m''appelle, tu t''habilles), la négation (je ne me lave pas) et un aperçu du passé composé avec être et l''accord.', '# ⚔️ Les verbes pronominaux — L''action qui revient sur le héros

> 💡 «Quand le héros agit sur lui-même, le verbe a besoin d''un miroir : le pronom réfléchi. Maîtrise-le et tu racontes toute ta journée.»

## 🏰 Qu''est-ce qu''un verbe pronominal ?

Un **verbe pronominal** est un verbe accompagné d''un **pronom réfléchi** qui renvoie au sujet : l''action que fait le sujet **retombe sur lui-même**. À l''infinitif, on le reconnaît au petit **se** devant le verbe : _**se** laver, **se** lever, **s''**habiller_.

_Je **me** lave._ → c''est **moi** qui lave **moi**.
_Elle **se** réveille._ → c''est **elle** qui réveille **elle-même**.

C''est l''outil parfait pour décrire ta **routine quotidienne** : le matin tu te lèves, tu te laves, tu t''habilles ; le soir tu te couches.

## ⚡ La structure : pronom réfléchi + verbe

Chaque personne a **son** pronom réfléchi. Il se place **juste devant** le verbe.

| Personne  | Pronom réfléchi | _se laver_ au présent   |
| --------- | --------------- | ----------------------- |
| je        | me              | je **me** lave          |
| tu        | te              | tu **te** laves         |
| il / elle | se              | il/elle **se** lave     |
| nous      | nous            | nous **nous** lavons    |
| vous      | vous            | vous **vous** lavez     |
| ils/elles | se              | ils/elles **se** lavent |

> 🗡️ Astuce : le verbe garde ses terminaisons normales du présent (**-e, -es, -e, -ons, -ez, -ent**). Tu ajoutes seulement le bon pronom devant : _tu **te** lave**s**_, jamais _~~tu te lave~~_.

## 🔮 L''élision : devant une voyelle ou un h muet

Quand le verbe commence par une **voyelle** (a, e, i, o, u) ou un **h muet**, les pronoms **me, te, se** perdent leur **e** et prennent une **apostrophe** : **m'', t'', s''**.

| Sans élision    | Avec élision (voyelle / h muet) |
| --------------- | ------------------------------- |
| je **me** lave  | je **m''**appelle                |
| tu **te** laves | tu **t''**habilles               |
| il **se** lave  | il **s''**amuse                  |

_Je **m''**appelle Yahia. Tu **t''**habilles vite. Elle **s''**amuse bien._

> ⚠️ Piège classique : on n''écrit jamais _~~je me appelle~~_ ni _~~il se habille~~_. Devant une voyelle ou un h muet, l''élision est **obligatoire** : **je m''appelle**, **il s''habille**.

## 🛡️ La négation : ne + pronom + verbe + pas

Pour dire **non**, on encadre le **pronom réfléchi ET le verbe** : **ne … pas**. Le pronom réfléchi reste **collé** au verbe, à l''intérieur de la négation.

$$ ne + pronom réfléchi + verbe + pas $$

_Je **ne me** lave **pas**. Il **ne se** couche **pas** tôt. Nous **ne nous** dépêchons **pas**._

Avec élision : _Je **ne m''**amuse **pas**. Tu **ne t''**habilles **pas**._

> ⚠️ Piège : ne sépare pas le pronom du verbe. On dit _Je **ne me lave pas**_, jamais _~~Je me ne lave pas~~_ ni _~~Je ne lave me pas~~_.

## 🧮 Les verbes de la routine à connaître

Voici les pronominaux les plus utiles pour parler de ta journée :

**se lever** (sortir du lit), **se réveiller**, **se laver**, **se brosser** (les dents), **s''habiller**, **se dépêcher**, **se promener**, **se reposer**, **se coucher**, **s''appeler**.

_Le matin, je **me réveille** à 7 h, je **me lève**, je **me brosse** les dents, puis je **m''habille**. Le soir, je **me repose** et je **me couche** tôt._

## 🧪 Coup d''œil sur le passé composé (avec être)

Au **passé composé**, les verbes pronominaux se construisent toujours avec l''auxiliaire **être**, et le participe passé **s''accorde** avec le sujet (comme un adjectif) :

_Je **me suis levé**_ (garçon) / _Je **me suis levée**_ (fille).
_Elle **s''est habillée**. Ils **se sont couchés**._

> 🗡️ Le cœur de ce chapitre reste le **présent** ; garde simplement en tête que le pronominal aime l''auxiliaire **être** et l''accord au passé.

> 🏆 Porte franchie ! Tu sais maintenant conjuguer un pronominal au présent, gérer l''élision et la négation. Prochaine étape : raconter ta journée d''hier au **passé composé** et à l''**imparfait**.', '# 📜 Résumé : Les verbes pronominaux

- **Définition** — un verbe pronominal a un **pronom réfléchi** : l''action du sujet retombe sur lui-même (_se laver_).
- **Structure** — pronom réfléchi (**me, te, se, nous, vous, se**) + verbe, avec les terminaisons normales du présent.
- **Conjugaison de se laver** — je me lave, tu te laves, il/elle se lave, nous nous lavons, vous vous lavez, ils/elles se lavent.
- **Élision** — devant une voyelle ou un h muet, _me/te/se_ → **m''/t''/s''** : _je m''appelle, tu t''habilles, il s''amuse_.
- **Négation** — **ne + pronom + verbe + pas** : _Je ne me lave pas. Il ne se couche pas tôt._
- **Verbes de la routine** — se lever, se réveiller, se laver, se brosser, s''habiller, se dépêcher, se promener, se reposer, se coucher, s''appeler.
- **Passé composé** — auxiliaire **être** + accord du participe : _je me suis levé(e), elle s''est habillée_.
- ⚠️ Ne jamais oublier le pronom (_~~je lave~~_ → je me lave), ni l''élision (_~~je me appelle~~_ → je m''appelle).', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('ec5ed2f8-770d-57f7-aab4-8c1d66902308', 'francais-a2', 'Le comparatif et le superlatif', 'Compare et classe : le comparatif des adjectifs et des adverbes (plus / moins / aussi … que), le comparatif des noms (plus de / moins de / autant de … que), le superlatif (le / la / les plus … de) et les irréguliers indispensables meilleur et mieux.', '# ⚔️ Le comparatif et le superlatif — Classe tous les héros

> 💡 «Dès qu''il y a deux combattants, il te faut les mots pour dire qui est le plus fort, le plus rapide… et qui est le meilleur de tous.»

## 🏰 Deux outils, deux missions

Quand tu mets des choses côte à côte, le français te donne deux armes. Le **comparatif** mesure **deux** éléments l''un par rapport à l''autre — il voyage presque toujours avec le mot **que**. Le **superlatif** couronne le **sommet de tout un groupe** — il voyage avec un **article défini** (le, la, les) et souvent avec **de**.

_Paul est **plus grand que** Marie._ (deux personnes)
_C''est **le plus grand** élève de la classe._ (un champion parmi tous)

## ⚡ Le comparatif des adjectifs et des adverbes

Pour comparer une qualité, encadre l''adjectif (ou l''adverbe) avec **plus / moins / aussi … que**. Tu choisis selon le sens.

| Degré       | Forme           | Exemple                              |
| ----------- | --------------- | ------------------------------------ |
| supériorité | **plus … que**  | Il est **plus rapide que** son frère |
| infériorité | **moins … que** | Elle est **moins âgée que** moi      |
| égalité     | **aussi … que** | Tu cours **aussi vite que** moi      |

_Cette épée est **plus tranchante que** l''autre. Le donjon est **moins long que** prévu._

> 🗡️ Astuce : l''**adjectif s''accorde** toujours avec le nom qu''il décrit. On dit _une héroïne **plus grande que**_ toi (féminin), _des armes **moins chères que**_ ça (pluriel). L''adverbe, lui, ne change jamais : _aussi **vite**_.

## 🛡️ Le comparatif des noms : la quantité

Pour comparer une **quantité** (un nom, pas une qualité), on utilise **plus de / moins de / autant de** + nom … **que**. Attention : devant un **nom**, c''est **de**, pas seulement _plus … que_.

| Degré       | Forme               | Exemple                           |
| ----------- | ------------------- | --------------------------------- |
| supériorité | **plus de … que**   | J''ai **plus de livres que** toi   |
| infériorité | **moins de … que**  | Il a **moins d''or que** le roi    |
| égalité     | **autant de … que** | Elle a **autant de vies que** moi |

> ⚠️ Piège : ne confonds pas l''adjectif et le nom. On compare une qualité avec _plus … que_ (_plus **fort** que_), mais une quantité avec _plus **de** … que_ (_plus **de** force que_). Le _de_ annonce un nom.

## 🔮 Le superlatif : couronner le champion

Le superlatif désigne l''extrême d''un groupe. On place l''**article défini** devant **plus** ou **moins** : **le / la / les plus …** et **le / la / les moins …**. Le complément du groupe s''introduit avec **de**.

| Forme           | Exemple                                        |
| --------------- | ---------------------------------------------- |
| **le plus …**   | C''est **le plus** courageux **du** royaume     |
| **la plus …**   | C''est **la plus** grande ville **du** pays     |
| **les moins …** | Ce sont **les moins** chers **de** la boutique |

_Voici **le moins cher** des boucliers._ L''article **s''accorde** avec le nom : **la** plus grande tour, **les** plus braves guerriers.

## 🧭 Les champions irréguliers : meilleur et mieux

Deux mots refusent le _plus_. **Bon(ne)** (un adjectif) devient **meilleur(e)** — jamais _~~plus bon~~_. **Bien** (un adverbe) devient **mieux** — jamais _~~plus bien~~_.

| Base               | Comparatif         | Superlatif      |
| ------------------ | ------------------ | --------------- |
| **bon** (adjectif) | **meilleur** (que) | **le meilleur** |
| **bien** (adverbe) | **mieux** (que)    | **le mieux**    |

_Cette potion est **meilleure que** l''autre. Aujourd''hui je combats **mieux qu''**hier. C''est **le meilleur** chevalier ; c''est lui qui se bat **le mieux**._

> ⚠️ Piège : ne dis jamais _~~plus bon~~_, _~~plus bien~~_, ni surtout _~~plus mieux~~_ — c''est doubler la marque. Choisis **meilleur** pour la qualité (adjectif) et **mieux** pour la manière (adverbe).

> 🏆 Porte franchie ! Tu sais comparer deux héros, mesurer leurs réserves, couronner le champion d''une guilde, et manier _meilleur_ et _mieux_ sans faute. Prochaine étape : situer dans l''espace et le temps.', '# 📜 Résumé : Le comparatif et le superlatif

- **Deux outils** — le _comparatif_ compare **deux** éléments (avec _que_) ; le _superlatif_ couronne le sommet d''un **groupe** (avec _le/la/les_, souvent + _de_).
- **Comparatif (adjectif/adverbe)** — **plus / moins / aussi … que** : _plus grand que_, _moins âgée que_, _aussi vite que_. L''adjectif **s''accorde** (_plus grande que_) ; l''adverbe non.
- **Comparatif (nom = quantité)** — **plus de / moins de / autant de** + nom … **que** : _plus de livres que toi_. Devant un nom, on met **de**.
- **Superlatif** — **le / la / les plus …** et **le / la / les moins …** (+ **de**) : _la plus grande ville du pays_, _le moins cher_. L''article **s''accorde** avec le nom.
- **Irréguliers** — _bon → meilleur → le meilleur_ (adjectif) ; _bien → mieux → le mieux_ (adverbe).
- ⚠️ Jamais _plus bon_ (→ **meilleur**), jamais _plus bien_ ni _plus mieux_ (→ **mieux**).
- ⚠️ Ne confonds pas _plus … que_ (qualité, adjectif) et _plus **de** … que_ (quantité, nom).', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('33a75aa3-935a-5d73-98e8-9184127c935a', 'francais-a2', 'Les prépositions de lieu et de temps', 'Maîtrise les prépositions de lieu (à, chez, dans, sur, sous, devant, derrière, entre, à côté de, en face de, près de, loin de), les prépositions devant les pays et les villes (à / en / au / aux) et les prépositions de temps (depuis, pendant, il y a, dans, en, à) pour éviter les erreurs les plus fréquentes.', '# 🗺️ Les prépositions de lieu et de temps — La carte du voyageur

> 💡 « Une seule préposition change toute la phrase : on habite **à** Tunis mais **en** Tunisie, **au** Maroc et **aux** États-Unis. Connais la carte, et tu ne te perdras plus. »

## 📍 Les prépositions de lieu

Ces petits mots disent **où** se trouve une personne ou une chose.

| Préposition               | Emploi                             | Exemples                                      |
| ------------------------- | ---------------------------------- | --------------------------------------------- |
| **à**                     | un lieu précis, une ville          | _à la maison, à l''école, à Tunis_             |
| **chez**                  | au domicile / dans le local de qqn | _chez moi, chez le médecin, chez mes amis_    |
| **dans**                  | à l''intérieur d''un espace fermé    | _dans la boîte, dans la chambre, dans le sac_ |
| **sur** / **sous**        | sur une surface / en dessous       | _sur la table_, _sous le lit_                 |
| **devant** / **derrière** | en face de / à l''arrière           | _devant la porte_, _derrière l''arbre_         |
| **entre**                 | au milieu de deux éléments         | _entre la banque et la poste_                 |
| **à côté de**             | tout près, juste à côté            | _à côté de l''hôpital_                         |
| **en face de**            | vis-à-vis, de l''autre côté         | _en face de la gare_                          |
| **près de** / **loin de** | à faible / grande distance         | _près du parc_, _loin du centre_              |

_Le chat dort **sous** la table. — J''habite **à côté de** la pharmacie. — On se retrouve **devant** le cinéma._

> 🗡️ Astuce : **chez** s''emploie seulement avec une **personne** ou un **métier** (_chez le coiffeur_), jamais avec un lieu : on dit _à la boulangerie_, pas _~~chez la boulangerie~~_.

## 🌍 Devant les pays et les villes : à / en / au / aux

Le choix dépend du **genre** et du **nombre** du pays.

| Préposition | Quand l''utiliser                 | Exemples                                    |
| ----------- | -------------------------------- | ------------------------------------------- |
| **à**       | une **ville**                    | _à Paris, à Tunis, à Rome_                  |
| **en**      | un pays **féminin** ou à voyelle | _en France, en Italie, en Iran, en Algérie_ |
| **au**      | un pays **masculin**             | _au Maroc, au Canada, au Japon_             |
| **aux**     | un pays **pluriel**              | _aux États-Unis, aux Pays-Bas_              |

_Je vais **à** Madrid, **en** Espagne. — Il travaille **au** Portugal. — Elle voyage **aux** Pays-Bas._

> ⚠️ Piège : jamais _~~à la France~~_ ni _~~dans la France~~_ → on dit **en France**. Et jamais _~~en Maroc~~_ → **au Maroc** (pays masculin).

## 🚗 Les moyens de transport

| Préposition | Emploi                                  | Exemples                                 |
| ----------- | --------------------------------------- | ---------------------------------------- |
| **en**      | un véhicule où l''on monte               | _en voiture, en train, en avion, en bus_ |
| **à**       | sans habitacle (on est dessus / à pied) | _à pied, à vélo, à cheval_               |

_Je vais au travail **en** métro, puis je rentre **à** pied._

## 🕐 Les prépositions de temps

| Préposition | Emploi                                        | Exemples                               |
| ----------- | --------------------------------------------- | -------------------------------------- |
| **depuis**  | une durée qui **continue** jusqu''à maintenant | _J''habite ici **depuis** 2020._        |
| **pendant** | une durée **complète, terminée ou prévue**    | _J''ai dormi **pendant** deux heures._  |
| **il y a**  | un **point** dans le passé                    | _Il est parti **il y a** trois ans._   |
| **dans**    | un moment **futur**                           | _Le train arrive **dans** une heure._  |
| **en**      | une année, un mois, une saison                | _**en** 2024, **en** mars, **en** été_ |
| **à**       | une heure précise                             | _**à** 8 h, **à** midi, **à** minuit_  |

_Elle apprend le français **depuis** un an. — On part **dans** dix minutes. — Le cours commence **à** 9 h._

> 🗡️ Astuce : **depuis** = le point de départ d''une action toujours en cours ; **il y a** = un repère fini dans le passé. _J''habite ici depuis 2020_ (toujours) ≠ _je suis arrivé il y a quatre ans_ (action finie).

> ⚠️ Piège : ne confonds pas **pendant** (durée totale) et **dans** (moment futur) : _J''ai travaillé **pendant** deux heures_ (déjà fait) ≠ _Je reviens **dans** deux heures_ (futur).

## 🔴 Les erreurs à éviter

- _~~Je vais à la France.~~_ → **Je vais en France.**
- _~~Je vis en Maroc.~~_ → **Je vis au Maroc.**
- _~~J''habite ici pendant 2020.~~_ → **J''habite ici depuis 2020.**
- _~~Je pars dans une heure il y a peu.~~_ → **Je suis parti il y a une heure.** (passé) / **Je pars dans une heure.** (futur)
- _~~Je vais chez la pharmacie.~~_ → **Je vais à la pharmacie.** (lieu, pas personne)

> 🏆 Porte franchie ! Tu tiens maintenant la carte complète : à/chez/dans pour le lieu, à/en/au/aux pour les pays, depuis/pendant/il y a/dans/en/à pour le temps. Avec elle, tu situes tout, partout et à tout moment.', '# 📜 Résumé : Les prépositions de lieu et de temps

- **Lieu** : **à** (lieu précis, ville), **chez** (chez une personne / un métier), **dans** (espace fermé), **sur/sous**, **devant/derrière**, **entre**, **à côté de**, **en face de**, **près de/loin de**.
- **chez** s''emploie seulement avec une personne ou un métier — _chez le médecin_, mais _à la pharmacie_.
- **Pays et villes** : **à** + ville (_à Paris_), **en** + pays féminin ou à voyelle (_en France, en Iran_), **au** + pays masculin (_au Maroc_), **aux** + pays pluriel (_aux États-Unis_).
- ⚠️ Jamais _~~à la France~~_ → **en France** ; jamais _~~en Maroc~~_ → **au Maroc**.
- **Transports** : **en** + véhicule fermé (_en voiture, en train_), **à** sans habitacle (_à pied, à vélo_).
- **Temps — depuis** : durée qui continue jusqu''à maintenant — _depuis 2020_.
- **Temps — pendant** : durée complète — _pendant deux heures_.
- **Temps — il y a** : point dans le passé — _il y a trois ans_.
- **Temps — dans** : moment futur — _dans une heure_.
- **Temps — en / à** : _en 2024, en été_ / _à 8 h, à midi_.
- ⚠️ Ne confonds pas **pendant** (durée) et **dans** (futur), ni **depuis** (en cours) et **il y a** (passé fini).', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('aaee51e0-fcfc-5a5a-b971-e3dd7c6c3ae9', 'francais-a2', 'Vocabulaire A2 : la ville et la vie quotidienne', 'Enrichis ton vocabulaire pour vivre en ville : les lieux publics (la gare, la poste, la banque, la mairie, l''hôpital), demander et indiquer le chemin (tournez à droite, allez tout droit, en face de, au coin de), les commerces et les achats (la boulangerie, la boucherie, le prix, la monnaie, payer), la santé (le corps, avoir mal à, l''ordonnance, les médicaments) et les loisirs et la routine (faire les courses, prendre rendez-vous, sortir). Lexique concret et utile du niveau élémentaire.', '# 🏰 Vocabulaire A2 : la ville et la vie quotidienne — Explore la cité du héros

> 💡 «Une ville ne se conquiert pas avec une épée, mais avec les bons mots — sache nommer chaque lieu et chaque chemin.»

## 🏙️ Les lieux de la ville

Ta nouvelle quête se déroule en ville. Apprends à **nommer les lieux publics** : c''est la carte de ton aventure.

| Lieu                | À quoi il sert                            |
| ------------------- | ----------------------------------------- |
| **la gare**         | prendre le train                          |
| **la poste**        | envoyer une lettre, un colis              |
| **la banque**       | retirer ou déposer de l''argent            |
| **la mairie**       | les papiers officiels (l''hôtel de ville)  |
| **l''hôpital**       | se faire soigner quand on est très malade |
| **la pharmacie**    | acheter des médicaments                   |
| **la bibliothèque** | emprunter des livres                      |
| **le musée**        | voir des œuvres d''art, des expositions    |
| **le commissariat** | la police                                 |
| **le marché**       | acheter des fruits et des légumes frais   |

_« Je vais à **la poste** pour envoyer un colis. » — « Il y a une **pharmacie** en face de la gare. »_

> ⚠️ Piège classique : la **mairie** sert aux papiers officiels, pas aux médicaments. Pour les médicaments, va à la **pharmacie** ; pour les livres, à la **bibliothèque** (≠ librairie, où l''on _achète_ des livres).

## 🧭 Demander et indiquer le chemin

Perdu dans la cité ? Demande poliment : _« **Pardon**, où est la gare, s''il vous plaît ? »_ Voici les **indications** que l''on te donnera :

| Indication            | Sens                          |
| --------------------- | ----------------------------- |
| **Allez tout droit**  | continuer sans tourner        |
| **Tournez à droite**  | prendre à droite              |
| **Tournez à gauche**  | prendre à gauche              |
| **Traversez la rue**  | passer de l''autre côté        |
| **en face de**        | juste devant, de l''autre côté |
| **à côté de**         | tout près, juste à côté       |
| **au coin de la rue** | à l''angle de la rue           |
| **jusqu''au feu**      | continuer jusqu''à ce point    |

_« **Tournez à gauche**, puis **allez tout droit jusqu''au** feu. La banque est **en face de** la poste. »_

> 🗡️ Astuce : **à droite** / **à gauche** ne changent jamais d''orthographe. Et _traverser_ veut dire passer de l''autre côté de la rue, pas tourner.

## 🛒 Les commerces et les achats

Pour ravitailler ton héros, connais les **commerces** et le vocabulaire de l''**argent**.

| Commerce           | On y achète…                   |
| ------------------ | ------------------------------ |
| **la boulangerie** | le pain, les croissants        |
| **la boucherie**   | la viande                      |
| **l''épicerie**     | un peu de tout (petit magasin) |
| **le supermarché** | tout, en grande quantité       |

À la **caisse**, on **paie** (verbe _payer_). Les mots de l''argent : _le **prix** (combien ça coûte), **l''argent**, la **monnaie** (les pièces qu''on te rend)._

_« — **Combien ça coûte** ? — Cinq euros. — Voici dix euros. — Je vous rends la **monnaie**. »_

> ⚠️ Ne confonds pas **l''argent** (l''ensemble, ce qu''on paie) et la **monnaie** (les pièces, ou ce que le marchand te _rend_).

## 🩺 La santé et le corps

Même un héros tombe parfois **malade**. Apprends à dire où tu as mal. Le **corps** :

| Partie du corps | Partie du corps |
| --------------- | --------------- |
| **la tête**     | **le bras**     |
| **la jambe**    | **le ventre**   |
| **la gorge**    | **le dos**      |

Pour dire que ça fait mal, on utilise **avoir mal à** : _« J''ai **mal à la tête**. » « J''ai **mal au ventre**. »_ (à + le = **au**, à + la = **à la**).

Chez le **médecin** : il t''examine, puis te donne une **ordonnance** (le papier) pour acheter des **médicaments** à la pharmacie.

> 🗡️ Règle : _avoir mal à_ + partie du corps. On dit _j''ai mal **à la** gorge_, _j''ai mal **au** dos_, _j''ai mal **aux** dents_.

## 🎯 Les loisirs et la routine

Quand la quête est finie, le héros se repose et s''organise. Le vocabulaire de la **routine** et des **loisirs** :

- **faire les courses** = aller acheter à manger (au supermarché, au marché).
- **faire du sport** = courir, nager, jouer au foot…
- **aller au cinéma** = voir un film.
- **sortir** = quitter la maison pour s''amuser (≠ rester).
- **prendre rendez-vous** = fixer un horaire (chez le médecin, le coiffeur).

_« Le samedi, je **fais les courses** le matin, puis je **sors** avec mes amis. Lundi, je dois **prendre rendez-vous** chez le médecin. »_

> ⚠️ Piège : **faire les courses** (acheter à manger) ≠ **faire une course / une course à pied** (courir, le sport). Le contexte fait la différence.

> 🏆 Cité conquise ! Tu sais maintenant nommer les lieux, demander ton chemin, faire tes achats, parler de ta santé et organiser ta semaine. Avec ce trésor de mots, tu peux **vivre** en français, pas seulement le réciter. Prochaine étape : lire un texte court et tout comprendre.', '# 📜 Résumé : la ville et la vie quotidienne

- **Les lieux** : la gare (train), la poste (lettres/colis), la banque (argent), la mairie (papiers), l''hôpital et la pharmacie (santé), la bibliothèque (livres), le musée, le commissariat (police), le marché.
- **Demander le chemin** : _allez tout droit_, _tournez à droite / à gauche_, _traversez_ ; situer avec **en face de**, **à côté de**, **au coin de la rue**, **jusqu''à**.
- **Les commerces** : la boulangerie (pain), la boucherie (viande), l''épicerie, le supermarché ; à la **caisse** on **paie**.
- **L''argent** : le **prix** (combien ça coûte), **l''argent**, la **monnaie** (les pièces qu''on rend).
- **La santé** : le corps (tête, bras, jambe, ventre, gorge, dos) ; **avoir mal à** (au / à la / aux) ; le médecin donne une **ordonnance** pour acheter des **médicaments**.
- **La routine et les loisirs** : **faire les courses**, **faire du sport**, **aller au cinéma**, **sortir**, **prendre rendez-vous**.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('1a10a5c0-adba-527c-8b7e-2464f0ee9f67', 'francais-a2', 'Compréhension écrite : lire des textes du quotidien', 'Lis des textes courts du quotidien — courriels, annonces, articles, programmes, messages de forum, recettes, règlements, publicités — et réponds à des questions de compréhension. Repère qui, quand, où et pourquoi, suis les connecteurs logiques et temporels, identifie le temps des verbes, devine un mot grâce au contexte et comprends l''intention de l''auteur. Niveau A2 (CECRL), épreuve de compréhension écrite du DELF A2.', '# ⚔️ Compréhension écrite — décode les parchemins du quotidien

> 💡 « Un bon lecteur ne lit pas tous les mots : il chasse l''information. »

Bienvenue, héros, à la **Porte des Parchemins**. Au niveau A2, tu n''as plus besoin de tout comprendre mot à mot. Ton pouvoir, c''est de **lire vite et bien** : trouver l''essentiel, repérer un détail, deviner un mot inconnu et comprendre _pourquoi_ le texte a été écrit. Voici tes cinq sorts de lecture.

## 🏰 Sort 1 — Repérer qui, quand, où, pourquoi

Avant de répondre, pose-toi les bonnes questions sur le texte.

| Question       | Tu cherches…                | Indices typiques                                             |
| -------------- | --------------------------- | ------------------------------------------------------------ |
| **Qui ?**      | l''auteur, le destinataire   | _Bonjour Léa_, signature à la fin, _Cher client_             |
| **Quand ?**    | le moment, la date, l''heure | _jeudi_, _à 18 h_, _demain_, _en mai_                        |
| **Où ?**       | le lieu                     | _à la médiathèque_, _salle 3_, _au stade_                    |
| **Pourquoi ?** | le but du message           | _pour t''inviter_, _afin de prévenir_, _je voudrais réserver_ |

> 🗡️ Le **destinataire** se trouve souvent au début (« Bonjour Madame »), et l''**auteur** à la fin (la signature). Ne les confonds pas !

## ⚡ Sort 2 — Suivre les connecteurs logiques et temporels

Les **connecteurs** sont les ponts entre les idées. Ils te disent la relation entre deux informations.

- **Temps (l''ordre) :** _d''abord, ensuite, puis, après, enfin, avant, pendant_.
- **Cause :** _parce que, car, comme_ → le _pourquoi_.
- **Conséquence :** _donc, alors, c''est pourquoi_ → le _résultat_.
- **Opposition :** _mais, pourtant, cependant_ → une _idée contraire_.
- **Addition :** _et, aussi, de plus_ → une _information en plus_.

_« Le musée est fermé le lundi, **mais** il ouvre le dimanche. »_ → le _mais_ annonce le contraire : ouvert un jour, fermé un autre.

## 🛡️ Sort 3 — Lire le temps des verbes

Le temps du verbe te dit **quand** se passe l''action. C''est essentiel pour ne pas se tromper d''époque.

| Temps                     | Quand ?                      | Exemple                                         |
| ------------------------- | ---------------------------- | ----------------------------------------------- |
| **Présent**               | maintenant, habitude         | _Je travaille à Lyon._                          |
| **Passé composé**         | action finie                 | _Hier, j''**ai visité** le musée._               |
| **Imparfait**             | description, habitude passée | _Quand j''étais petit, je **jouais** au foot._   |
| **Futur (proche/simple)** | plus tard                    | _Demain, je **vais partir** / je **partirai**._ |

> ⚠️ Piège classique : un texte au **futur** parle d''un projet, pas d''un fait déjà arrivé. _« Le club **ouvrira** en juin »_ → il n''est **pas encore** ouvert !

## 🔮 Sort 4 — Comprendre l''intention de l''auteur

Demande-toi : **pourquoi** l''auteur écrit-il ? Le but change selon le type de texte.

- **Une publicité** veut te _faire acheter_ ou _attirer_.
- **Une annonce / un règlement** veut _informer_ ou _interdire_.
- **Un courriel amical** veut _inviter, remercier, raconter_.
- **Une recette** veut _expliquer comment faire_.
- **Un message de forum** veut _demander un conseil_ ou _donner un avis_.

Cherche les **verbes clés** : _je voudrais_, _n''oubliez pas_, _venez vite_, _est-ce que quelqu''un peut…_ — ils trahissent l''intention.

## 🧪 Sort 5 — Deviner un mot grâce au contexte

Tu ne connais pas un mot ? Pas de panique : les mots autour t''aident.

_« Il est tard, je suis **épuisé**, je vais dormir. »_ → _tard_ + _dormir_ = **épuisé** veut dire « très fatigué ».

> 🗡️ Regarde le **voisinage** du mot (avant/après) et le **thème** général du texte. Le contexte est ta lanterne dans le donjon.

## 📜 Combat d''entraînement — un exemple complet

Lis ce courriel, puis suis le raisonnement :

> **Objet : Sortie de samedi**
> _Salut Nour,_
> _Je t''écris pour t''inviter à la fête de Sami samedi soir. On se retrouve d''abord chez moi à 19 h, puis on ira ensemble. N''oublie pas d''apporter un dessert ! Je sais que tu détestes arriver en retard, alors sois à l''heure. À samedi ! — Yassine_

**Question : Pourquoi Yassine écrit-il ce courriel ?**

1. _Qui / qui ?_ → Yassine (signature) écrit à Nour (« Salut Nour »).
2. _Quand ?_ → _samedi soir_, rendez-vous à _19 h_ (présent/futur : c''est un **projet**).
3. _Connecteurs_ → _d''abord… puis_ = l''ordre des étapes.
4. _Intention_ → le verbe clé est **« je t''écris pour t''inviter »** → le but est **une invitation**.

✓ Réponse : **inviter Nour à une fête**. Un distracteur comme _« annuler la fête »_ est faux : rien n''est annulé, au contraire on s''organise.

> 🏆 Première porte franchie ! Tu sais maintenant chasser l''information, suivre les connecteurs et lire l''intention. Affûte ces sorts dans les missions — le **Boss du chapitre** t''attend derrière la porte suivante.', '# 📜 Résumé : Compréhension écrite (A2)

- **Qui, quand, où, pourquoi** : repère l''auteur (souvent la signature à la fin) et le destinataire (souvent au début), le moment, le lieu et le but du texte.
- **Connecteurs** : _d''abord/ensuite/puis/enfin_ = l''ordre ; _parce que/car_ = la cause ; _donc/alors_ = la conséquence ; _mais/pourtant_ = l''opposition.
- **Temps des verbes** : présent = maintenant/habitude ; passé composé = action finie ; imparfait = description passée ; futur = projet pas encore réalisé.
- **Intention de l''auteur** : une pub veut faire acheter, une annonce informer, un courriel amical inviter/raconter, une recette expliquer, un forum demander un avis.
- **Mot inconnu** : devine son sens grâce aux mots autour et au thème du texte.
- **Méthode** : lis d''abord la question, puis cherche (« scanne ») l''information précise dans le texte ; la réponse est toujours justifiée par une phrase du texte.
- **Piège** : ne confonds pas l''heure du rendez-vous et l''heure de l''événement, ni un projet futur avec un fait déjà arrivé.', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bd839674-16d1-5a2c-af43-cad59618eb71', 'ed25655b-24e2-5474-8154-276b57332fd5', 'francais-a2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('2005a6e5-346f-54e2-8fcd-bd557cfe909b', 'bd839674-16d1-5a2c-af43-cad59618eb71', 'Complète : « Hier, j''___ une lettre à mon ami. »', '[{"id":"a","text":"écris"},{"id":"b","text":"suis écrit"},{"id":"c","text":"ai écrit"},{"id":"d","text":"ai écris"}]'::jsonb, 'c', 'Le passé composé se forme avec l''auxiliaire avoir au présent + le participe passé : j''ai écrit. Le verbe écrire prend l''auxiliaire avoir (et non être), et son participe passé est « écrit », pas « écris ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f7ab6ad3-7d91-5803-96b5-a9a0ca3c5cb7', 'bd839674-16d1-5a2c-af43-cad59618eb71', 'Quel est le participe passé du verbe « finir » ?', '[{"id":"a","text":"fini"},{"id":"b","text":"finit"},{"id":"c","text":"finé"},{"id":"d","text":"finu"}]'::jsonb, 'a', 'Les verbes en -ir font leur participe passé en -i : finir → fini. « finit » est la forme du présent (il finit), « finé » applique à tort la règle des verbes en -er, et « finu » n''existe pas.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0224679a-c540-5ea4-bc06-c9d18246251a', 'bd839674-16d1-5a2c-af43-cad59618eb71', 'Complète : « Elle ___ au marché ce matin. »', '[{"id":"a","text":"a allé"},{"id":"b","text":"est allée"},{"id":"c","text":"est allé"},{"id":"d","text":"a allée"}]'::jsonb, 'b', 'Le verbe aller se conjugue avec être, et le participe s''accorde avec le sujet : « elle » est féminin singulier, donc « est allée ». « a allé » utilise le mauvais auxiliaire, et « est allé » oublie l''accord au féminin.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed13538a-b5b3-5c97-9156-69a832054e7f', 'bd839674-16d1-5a2c-af43-cad59618eb71', 'Complète : « Nous ___ un beau film hier soir. »', '[{"id":"a","text":"sommes vu"},{"id":"b","text":"avons voir"},{"id":"c","text":"avons vus"},{"id":"d","text":"avons vu"}]'::jsonb, 'd', 'Voir se conjugue avec avoir et son participe passé irrégulier est « vu » : nous avons vu. Avec l''auxiliaire avoir, on n''accorde pas le participe avec le sujet, donc pas de -s (« vus »). « sommes vu » utilise le mauvais auxiliaire.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('602afa6a-21ab-5410-9b04-a24cde6a5ef2', 'bd839674-16d1-5a2c-af43-cad59618eb71', 'Complète : « Ils ___ très tard à la maison. »', '[{"id":"a","text":"ont rentré"},{"id":"b","text":"sont rentrés"},{"id":"c","text":"sont rentré"},{"id":"d","text":"sont rentrées"}]'::jsonb, 'b', 'Rentrer est un verbe de mouvement : il se conjugue avec être, et le participe s''accorde avec le sujet. « Ils » est masculin pluriel, donc « sont rentrés » avec -s. « sont rentré » oublie l''accord et « sont rentrées » met un féminin pluriel.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8a042748-f07e-5155-99cc-3a9d0c487a5a', 'ed25655b-24e2-5474-8154-276b57332fd5', 'francais-a2', '⭐ Entraînement : le passé composé', 1, 50, 10, 'practice', 'admin', 1)
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
  ('37481b93-7f88-5b0c-9889-b8b4f0533330', '8a042748-f07e-5155-99cc-3a9d0c487a5a', 'Complète : « Hier soir, j''___ une pizza au restaurant. »', '[{"id":"a","text":"mange"},{"id":"b","text":"suis mangé"},{"id":"c","text":"ai mangé"},{"id":"d","text":"ai mangée"}]'::jsonb, 'c', 'Manger se conjugue avec avoir et son participe passé est « mangé » (verbe en -er → -é) : j''ai mangé. On n''accorde pas avec le sujet quand l''auxiliaire est avoir, donc pas de « mangée ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6596693b-c009-5569-b435-f4902295f6cf', '8a042748-f07e-5155-99cc-3a9d0c487a5a', 'Quel est le participe passé du verbe « parler » ?', '[{"id":"a","text":"parlé"},{"id":"b","text":"parler"},{"id":"c","text":"parlu"},{"id":"d","text":"parli"}]'::jsonb, 'a', 'Les verbes en -er forment leur participe passé en -é : parler → parlé. « parler » est l''infinitif, « parlu » et « parli » appliquent à tort des terminaisons d''autres groupes.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2fe39c4f-2e32-5006-90f6-fea7e56be473', '8a042748-f07e-5155-99cc-3a9d0c487a5a', 'Complète : « Tu ___ tes devoirs avant de jouer. »', '[{"id":"a","text":"es fini"},{"id":"b","text":"as fini"},{"id":"c","text":"as finit"},{"id":"d","text":"as finis"}]'::jsonb, 'b', 'Finir se conjugue avec avoir et son participe passé est « fini » (verbe en -ir → -i) : tu as fini. « es fini » utilise le mauvais auxiliaire, « finit » est le présent et « finis » ajoute un accord inutile (pas d''accord avec le sujet avec avoir).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b2d6496-80d9-5451-bb0c-89ff9b42fb06', '8a042748-f07e-5155-99cc-3a9d0c487a5a', 'Complète : « Elle ___ chez le médecin ce matin. »', '[{"id":"a","text":"a allé"},{"id":"b","text":"a allée"},{"id":"c","text":"est allé"},{"id":"d","text":"est allée"}]'::jsonb, 'd', 'Aller se conjugue avec être et le participe s''accorde avec le sujet. « Elle » est féminin singulier, donc « est allée ». « a allé » et « a allée » utilisent le mauvais auxiliaire ; « est allé » oublie l''accord féminin.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('417b165f-fe14-5151-812e-fbc9306d92a1', '8a042748-f07e-5155-99cc-3a9d0c487a5a', 'Complète : « Nous ___ le bus à huit heures. »', '[{"id":"a","text":"avons prendu"},{"id":"b","text":"sommes pris"},{"id":"c","text":"avons pris"},{"id":"d","text":"avons prit"}]'::jsonb, 'c', 'Prendre se conjugue avec avoir et son participe passé irrégulier est « pris » : nous avons pris. « prendu » applique à tort la règle régulière, « prit » est le passé simple écrit, et « sommes pris » utilise le mauvais auxiliaire.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29d88b46-daf0-57d3-9675-30a145ec8e80', '8a042748-f07e-5155-99cc-3a9d0c487a5a', 'Complète : « Mes amis ___ à la fête samedi dernier. »', '[{"id":"a","text":"ont venu"},{"id":"b","text":"sont venus"},{"id":"c","text":"sont venu"},{"id":"d","text":"sont venues"}]'::jsonb, 'b', 'Venir se conjugue avec être et le participe s''accorde avec le sujet. « Mes amis » est masculin pluriel, donc « sont venus » avec -s. « ont venu » utilise le mauvais auxiliaire, « sont venu » oublie le pluriel et « sont venues » met un féminin.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e4221a6e-df40-59db-9cdc-f7b32c1cc1a7', 'ed25655b-24e2-5474-8154-276b57332fd5', 'francais-a2', '⭐⭐ Révision : le passé composé', 2, 75, 15, 'practice', 'admin', 2)
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
  ('f9d831e5-d008-58f0-8a41-2f77ceba2397', 'e4221a6e-df40-59db-9cdc-f7b32c1cc1a7', 'Complète : « Vous ___ vos clés sur la table. »', '[{"id":"a","text":"avez mis"},{"id":"b","text":"avez mit"},{"id":"c","text":"êtes mis"},{"id":"d","text":"avez mettu"}]'::jsonb, 'a', 'Mettre se conjugue avec avoir et son participe passé irrégulier est « mis » : vous avez mis. « mit » et « mettu » sont des formes fautives, et « êtes mis » utilise le mauvais auxiliaire.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('40a82e20-0442-5eae-a9ee-c8d90d6c9f14', 'e4221a6e-df40-59db-9cdc-f7b32c1cc1a7', 'Complète : « Je ___ très content de te revoir. »', '[{"id":"a","text":"ai été"},{"id":"b","text":"suis eu"},{"id":"c","text":"ai étai"},{"id":"d","text":"ai eu"}]'::jsonb, 'a', 'Le verbe être au passé composé se forme avec l''auxiliaire avoir + le participe « été » : j''ai été. Attention à ne pas confondre : « eu » est le participe d''avoir, pas d''être, et « étai » n''existe pas.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('60952eba-9cc9-55ea-b99c-7b639f253ec6', 'e4221a6e-df40-59db-9cdc-f7b32c1cc1a7', 'Complète : « Marie ___ tôt ce matin. »', '[{"id":"a","text":"a partie"},{"id":"b","text":"est partie"},{"id":"c","text":"est parti"},{"id":"d","text":"a parti"}]'::jsonb, 'b', 'Partir se conjugue avec être et le participe s''accorde avec le sujet. « Marie » est féminin singulier, donc « est partie ». « a parti » et « a partie » utilisent le mauvais auxiliaire ; « est parti » oublie l''accord féminin.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc1d208b-340b-5bcb-a4b1-b2744619e4d4', 'e4221a6e-df40-59db-9cdc-f7b32c1cc1a7', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Nous avons fini nos exercices."},{"id":"b","text":"Elle est restée à la maison."},{"id":"c","text":"J''ai allé au cinéma hier."},{"id":"d","text":"Ils ont pris le train."}]'::jsonb, 'c', 'L''erreur est « J''ai allé » : le verbe aller se conjugue avec être, pas avec avoir → il faut « je suis allé(e) ». Les autres phrases sont correctes : finir et prendre avec avoir, et rester avec être et l''accord au féminin (restée).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d38e309b-ad75-5a22-9a98-70a41c3a0210', 'e4221a6e-df40-59db-9cdc-f7b32c1cc1a7', 'Complète : « Les enfants ___ dans le jardin. »', '[{"id":"a","text":"sont joués"},{"id":"b","text":"ont joués"},{"id":"c","text":"sont joué"},{"id":"d","text":"ont joué"}]'::jsonb, 'd', 'Jouer se conjugue avec avoir et son participe est « joué » : les enfants ont joué. Avec avoir, on n''accorde pas avec le sujet, donc pas de -s (« joués »). « sont joué » utilise à tort l''auxiliaire être.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1982efdf-6ad1-5d2c-8709-2f5981ec88e9', 'e4221a6e-df40-59db-9cdc-f7b32c1cc1a7', 'Complète : « Hier, elle ___ tôt pour aller travailler. »', '[{"id":"a","text":"a levé"},{"id":"b","text":"s''est levé"},{"id":"c","text":"a se levé"},{"id":"d","text":"s''est levée"}]'::jsonb, 'd', 'Se lever est un verbe pronominal : il se conjugue avec être, et le participe s''accorde avec le sujet. « Elle » est féminin singulier, donc « s''est levée ». Les verbes pronominaux n''utilisent jamais avoir (« a levé », « a se levé » sont faux).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('94f7671b-76a1-526a-b011-5e932afcf877', 'ed25655b-24e2-5474-8154-276b57332fd5', 'francais-a2', '⚔️ Boss du chapitre ⭐⭐⭐ : le passé composé', 3, 120, 30, 'boss', 'admin', 3)
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
  ('93bd4d4a-6b38-5fdf-bc32-4ec27e7d34a3', '94f7671b-76a1-526a-b011-5e932afcf877', 'Complète : « Tu ___ ton cadeau hier ? »', '[{"id":"a","text":"as voir"},{"id":"b","text":"as vu"},{"id":"c","text":"es vu"},{"id":"d","text":"as vue"}]'::jsonb, 'b', 'Voir se conjugue avec avoir et son participe irrégulier est « vu » : tu as vu. « as voir » garde l''infinitif, « es vu » utilise le mauvais auxiliaire, et « vue » ajoute un accord interdit avec l''auxiliaire avoir.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2416933-e664-5734-9c01-f937ef444063', '94f7671b-76a1-526a-b011-5e932afcf877', 'Complète : « Elles ___ par la grande porte. »', '[{"id":"a","text":"ont entrées"},{"id":"b","text":"sont entré"},{"id":"c","text":"sont entrées"},{"id":"d","text":"sont entrés"}]'::jsonb, 'c', 'Entrer se conjugue avec être et le participe s''accorde avec le sujet. « Elles » est féminin pluriel, donc « sont entrées » (-es). « ont entrées » utilise le mauvais auxiliaire, « entré » oublie l''accord et « entrés » met un masculin.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('520e1404-84c9-55e3-bfdb-d20853bbf36e', '94f7671b-76a1-526a-b011-5e932afcf877', 'Complète : « Nous ___ rester à la maison à cause de la pluie. »', '[{"id":"a","text":"avons dû"},{"id":"b","text":"sommes dû"},{"id":"c","text":"avons devu"},{"id":"d","text":"avons dus"}]'::jsonb, 'a', 'Devoir se conjugue avec avoir et son participe irrégulier est « dû » (avec accent circonflexe) : nous avons dû. « devu » applique à tort la règle régulière, « dus » ajoute un accord interdit avec avoir, et « sommes dû » utilise le mauvais auxiliaire.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('320af27b-11f3-5015-ae61-402d78b62459', '94f7671b-76a1-526a-b011-5e932afcf877', 'Trouve la phrase CORRECTE.', '[{"id":"a","text":"Elle a venue me voir hier."},{"id":"b","text":"Ils sont fait leurs devoirs."},{"id":"c","text":"J''ai prendu une bonne décision."},{"id":"d","text":"Nous sommes restés à la plage."}]'::jsonb, 'd', 'Seule « Nous sommes restés à la plage » est correcte : rester se conjugue avec être et le participe s''accorde avec le sujet pluriel. « a venue » utilise le mauvais auxiliaire, « sont fait » aussi (faire prend avoir), et « prendu » est un participe inventé (il faut « pris »).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d11d465b-082d-5d6a-ba47-ca6fad4e46af', '94f7671b-76a1-526a-b011-5e932afcf877', 'Complète : « Ma sœur et moi, nous ___ au sommet de la montagne. »', '[{"id":"a","text":"avons monté"},{"id":"b","text":"sommes montés"},{"id":"c","text":"sommes monté"},{"id":"d","text":"sommes montées"}]'::jsonb, 'b', 'Monter (verbe de mouvement, sans complément d''objet ici) se conjugue avec être, et le participe s''accorde avec le sujet « nous », masculin pluriel par défaut (un groupe mixte) : sommes montés. « avons monté » utilise le mauvais auxiliaire, « monté » oublie le pluriel et « montées » impose un féminin.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('620e7d50-56d1-5ef9-bccf-fa52c4944574', '94f7671b-76a1-526a-b011-5e932afcf877', 'Complète : « Hier matin, les filles ___ avant de partir à l''école. »', '[{"id":"a","text":"ont lavées"},{"id":"b","text":"se sont lavés"},{"id":"c","text":"se sont lavées"},{"id":"d","text":"ont se lavé"}]'::jsonb, 'c', 'Se laver est un verbe pronominal : il se conjugue avec être et le participe s''accorde avec le sujet. « Les filles » est féminin pluriel, donc « se sont lavées ». Les pronominaux n''utilisent jamais avoir (« ont lavées », « ont se lavé » sont faux), et « lavés » met un masculin.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e1d9419c-4acc-5fb6-848b-fe81989f2472', 'ed25655b-24e2-5474-8154-276b57332fd5', 'francais-a2', '👑 Défi élite ⭐⭐⭐⭐ : le passé composé', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('e944b4cd-5a4b-5146-aa34-0c34baa00a63', 'e1d9419c-4acc-5fb6-848b-fe81989f2472', 'Complète : « Vous ___ un grand effort pour réussir. »', '[{"id":"a","text":"êtes fait"},{"id":"b","text":"avez faisé"},{"id":"c","text":"avez faite"},{"id":"d","text":"avez fait"}]'::jsonb, 'd', 'Faire se conjugue avec avoir et son participe irrégulier est « fait » : vous avez fait. « faisé » applique à tort la règle régulière, « faite » ajoute un accord interdit avec avoir, et « êtes fait » utilise le mauvais auxiliaire.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c9556592-6474-5df7-b25c-07fbed875770', 'e1d9419c-4acc-5fb6-848b-fe81989f2472', 'Complète : « Elle ___ rentrer parce qu''elle était fatiguée. »', '[{"id":"a","text":"a voulu"},{"id":"b","text":"est voulu"},{"id":"c","text":"a voulue"},{"id":"d","text":"a voulé"}]'::jsonb, 'a', 'Vouloir se conjugue avec avoir et son participe irrégulier est « voulu » : elle a voulu. « voulé » applique à tort la règle régulière, « voulue » ajoute un accord interdit avec avoir, et « est voulu » utilise le mauvais auxiliaire.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c4919146-cf60-5e26-baf9-cbed79ac898c', 'e1d9419c-4acc-5fb6-848b-fe81989f2472', 'Complète : « Ce matin, je ___ tôt et je me suis préparé vite. »', '[{"id":"a","text":"ai réveillé"},{"id":"b","text":"suis réveillé tard"},{"id":"c","text":"me suis réveillé"},{"id":"d","text":"ai me réveillé"}]'::jsonb, 'c', 'Se réveiller est un verbe pronominal : il se conjugue avec être et garde son pronom réfléchi : je me suis réveillé. « ai réveillé » oublie le pronom et l''auxiliaire correct, « ai me réveillé » mélange tout, et l''option « tard » contredit le sens de la phrase (« tôt »).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d1e8264-255e-55f0-94de-79c5e3eb0ca8', 'e1d9419c-4acc-5fb6-848b-fe81989f2472', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Les feuilles sont tombées en automne."},{"id":"b","text":"Il a descendu les escaliers en courant."},{"id":"c","text":"Nous avons eu beaucoup de chance."},{"id":"d","text":"Elles ont arrivées en retard."}]'::jsonb, 'd', 'L''erreur est « Elles ont arrivées » : arriver est un verbe de mouvement, il se conjugue avec être → « Elles sont arrivées ». Les autres sont correctes : tomber avec être et accord (tombées), descendre ici avec un complément d''objet prend avoir, et avoir → eu.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ddaa25ac-677c-5205-9c64-8920a36e6e4e', 'e1d9419c-4acc-5fb6-848b-fe81989f2472', 'Complète : « Mes grands-parents ___ dans cette maison il y a cinquante ans. »', '[{"id":"a","text":"ont nés"},{"id":"b","text":"sont nés"},{"id":"c","text":"ont naissé"},{"id":"d","text":"sont né"}]'::jsonb, 'b', 'Naître se conjugue avec être et son participe irrégulier est « né » ; il s''accorde avec le sujet masculin pluriel : sont nés. « ont nés » et « ont naissé » utilisent le mauvais auxiliaire et une forme inventée, et « sont né » oublie le pluriel.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f5784f8-e8bf-58af-90a3-108eebf7418c', 'e1d9419c-4acc-5fb6-848b-fe81989f2472', 'Complète : « Nous ___ une heure, puis le train est enfin parti. »', '[{"id":"a","text":"avons attendu"},{"id":"b","text":"sommes attendus"},{"id":"c","text":"avons attendi"},{"id":"d","text":"avons attendus"}]'::jsonb, 'a', 'Attendre se conjugue avec avoir et son participe est « attendu » : nous avons attendu. « attendi » est une terminaison fautive, « attendus » ajoute un accord interdit avec avoir, et « sommes attendus » utilise le mauvais auxiliaire.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cdbfe01a-d513-54cb-8141-cf47fef8be1f', 'ed25655b-24e2-5474-8154-276b57332fd5', 'francais-a2', '⭐⭐ Drill : le passé composé', 2, 75, 15, 'practice', 'admin', 5)
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
  ('57a44fcd-7c8a-5b3c-b14a-085fe8f98171', 'cdbfe01a-d513-54cb-8141-cf47fef8be1f', 'Complète : « Ils ___ leurs valises avant le départ. »', '[{"id":"a","text":"ont préparés"},{"id":"b","text":"ont préparé"},{"id":"c","text":"sont préparé"},{"id":"d","text":"ont préparer"}]'::jsonb, 'b', 'Préparer se conjugue avec avoir et son participe est « préparé » : ils ont préparé. Avec l''auxiliaire avoir, on n''accorde pas avec le sujet, donc pas de -s (« préparés »). « préparer » garde l''infinitif et « sont » est le mauvais auxiliaire.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e08595a-3861-5372-a2c4-59385d0ab9c7', 'cdbfe01a-d513-54cb-8141-cf47fef8be1f', 'Quel est le participe passé du verbe « pouvoir » ?', '[{"id":"a","text":"pouvé"},{"id":"b","text":"pouvu"},{"id":"c","text":"peu"},{"id":"d","text":"pu"}]'::jsonb, 'd', 'Pouvoir est un verbe irrégulier dont le participe passé est « pu » : j''ai pu. « pouvé » et « pouvu » sont des formes inventées, et « peu » est un adverbe de quantité, pas un participe.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08bde0aa-1a5f-5604-9fa5-669984c89d9b', 'cdbfe01a-d513-54cb-8141-cf47fef8be1f', 'Complète : « Sophie ___ chez ses parents le week-end dernier. »', '[{"id":"a","text":"est retournée"},{"id":"b","text":"a retourné"},{"id":"c","text":"est retourné"},{"id":"d","text":"a retournée"}]'::jsonb, 'a', 'Retourner (verbe de mouvement) se conjugue avec être et le participe s''accorde avec le sujet. « Sophie » est féminin singulier, donc « est retournée ». « a retourné » utilise le mauvais auxiliaire et « est retourné » oublie l''accord féminin.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2df74076-99a8-5941-96d9-5ec67f14a03b', 'cdbfe01a-d513-54cb-8141-cf47fef8be1f', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Tu as choisi un bon livre."},{"id":"b","text":"Elle est tombée dans l''escalier."},{"id":"c","text":"Nous sommes mangé au restaurant."},{"id":"d","text":"Ils ont mis leurs manteaux."}]'::jsonb, 'c', 'L''erreur est « Nous sommes mangé » : manger se conjugue avec avoir → « nous avons mangé ». Les autres sont correctes : choisir avec avoir (choisi), tomber avec être et accord (tombée), et mettre avec avoir (mis).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('962bc088-3f8a-5bb8-9cb0-45fc7d79fbab', 'cdbfe01a-d513-54cb-8141-cf47fef8be1f', 'Complète : « Le vieux chat ___ la nuit dernière. »', '[{"id":"a","text":"a mouru"},{"id":"b","text":"est mort"},{"id":"c","text":"a mort"},{"id":"d","text":"est mouru"}]'::jsonb, 'b', 'Mourir se conjugue avec être et son participe irrégulier est « mort » : il est mort. « mouru » est une forme inventée, et « a mort » utilise le mauvais auxiliaire (mourir prend toujours être).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b1a0aae4-5c2b-5d62-8157-7333f1589e19', 'cdbfe01a-d513-54cb-8141-cf47fef8be1f', 'Complète : « Après le match, les joueuses ___ pour fêter la victoire. »', '[{"id":"a","text":"ont promenées"},{"id":"b","text":"se sont promené"},{"id":"c","text":"se sont promenés"},{"id":"d","text":"se sont promenées"}]'::jsonb, 'd', 'Se promener est un verbe pronominal : il se conjugue avec être et le participe s''accorde avec le sujet. « Les joueuses » est féminin pluriel, donc « se sont promenées ». Les pronominaux n''utilisent jamais avoir (« ont promenées »), et « promené »/« promenés » oublient l''accord féminin pluriel.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a75f65e3-be64-57d2-9096-2bdd8810099c', 'cf8cd70e-d021-5c57-a8a3-47956ffed3ed', 'francais-a2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('168f5560-fc15-52a0-94e3-7c5e2d8c7027', 'a75f65e3-be64-57d2-9096-2bdd8810099c', 'Complète : « Quand j''étais petit, je ___ au parc tous les jours. »', '[{"id":"a","text":"joue"},{"id":"b","text":"jouais"},{"id":"c","text":"ai joué"},{"id":"d","text":"jouerai"}]'::jsonb, 'b', '« Tous les jours » indique une habitude passée : on emploie l''imparfait, je jouais. « joue » est le présent, « ai joué » le passé composé (action unique), et « jouerai » le futur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3bd76f7-6507-5751-a880-5e39094f291b', 'a75f65e3-be64-57d2-9096-2bdd8810099c', 'Pour former l''imparfait, sur quelle forme prend-on le radical ?', '[{"id":"a","text":"Sur l''infinitif du verbe"},{"id":"b","text":"Sur la forme « je » du présent"},{"id":"c","text":"Sur la forme « nous » du présent"},{"id":"d","text":"Sur le participe passé"}]'::jsonb, 'c', 'Le radical de l''imparfait vient de la forme « nous » au présent, sans -ons : nous parlons → parl-. On ajoute ensuite -ais, -ais, -ait, -ions, -iez, -aient.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b978f30-f08e-58fb-a044-3f7408f2a942', 'a75f65e3-be64-57d2-9096-2bdd8810099c', 'Quelle est la terminaison de l''imparfait avec « ils / elles » ?', '[{"id":"a","text":"-aient"},{"id":"b","text":"-ait"},{"id":"c","text":"-ais"},{"id":"d","text":"-ent"}]'::jsonb, 'a', 'Avec ils/elles, l''imparfait prend -aient : ils parlaient. La terminaison est muette (on entend « parlait »). « -ait » est pour il/elle et « -ais » pour je/tu.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('67ec337f-dcdb-5244-9f9f-57ee7fb3c653', 'a75f65e3-be64-57d2-9096-2bdd8810099c', 'Complète : « Il ___ beau et nous ___ contents. »', '[{"id":"a","text":"faisait / étions"},{"id":"b","text":"a fait / avons été"},{"id":"c","text":"faisait / étaient"},{"id":"d","text":"faisais / étions"}]'::jsonb, 'a', 'Description du passé → imparfait : il faisait beau, nous étions contents. « a fait / avons été » est le passé composé, « étaient » est pour ils, et « faisais » est pour je/tu.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63cee886-a092-5ced-ae64-de28509ed5b9', 'a75f65e3-be64-57d2-9096-2bdd8810099c', 'Dans « Je lisais quand tu es arrivé », pourquoi « lisais » est-il à l''imparfait ?', '[{"id":"a","text":"C''est l''action soudaine et ponctuelle"},{"id":"b","text":"C''est l''action en cours, le décor de la scène"},{"id":"c","text":"C''est une action future"},{"id":"d","text":"C''est une action terminée et unique"}]'::jsonb, 'b', '« Je lisais » est l''action en cours qui sert de décor ; « tu es arrivé » (passé composé) est l''événement ponctuel qui interrompt. L''imparfait pose le fond, le passé composé marque l''action soudaine.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0fc2782b-5804-5297-8899-85c84d7aa10f', 'cf8cd70e-d021-5c57-a8a3-47956ffed3ed', 'francais-a2', '⭐ Entraînement : l''imparfait', 1, 50, 10, 'practice', 'admin', 1)
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
  ('915a8a81-4383-5205-bd19-fca75502e655', '0fc2782b-5804-5297-8899-85c84d7aa10f', 'Complète : « Je ___ souvent à mes amis. »', '[{"id":"a","text":"parlais"},{"id":"b","text":"parlait"},{"id":"c","text":"parle"},{"id":"d","text":"parlerai"}]'::jsonb, 'a', 'Avec « je », l''imparfait prend -ais : je parlais. « parlait » est la forme de il/elle, « parle » est le présent, et « parlerai » est le futur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d53d402-15e5-5f11-a12a-d8d3f383985f', '0fc2782b-5804-5297-8899-85c84d7aa10f', 'Complète : « Tu ___ très bien quand tu étais jeune. »', '[{"id":"a","text":"chantait"},{"id":"b","text":"chantais"},{"id":"c","text":"chantes"},{"id":"d","text":"chantaient"}]'::jsonb, 'b', 'Avec « tu », l''imparfait prend -ais : tu chantais. « chantait » est pour il/elle, « chantes » est le présent, et « chantaient » est pour ils/elles.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('96e64358-6bf5-5d8a-93b3-8107d94c5f70', '0fc2782b-5804-5297-8899-85c84d7aa10f', 'Complète : « Elle ___ la radio chaque matin. »', '[{"id":"a","text":"écoutais"},{"id":"b","text":"écoutaient"},{"id":"c","text":"écoutait"},{"id":"d","text":"écoute"}]'::jsonb, 'c', 'Avec « elle » (il/elle/on), l''imparfait prend -ait : elle écoutait. « écoutais » est pour je/tu, « écoutaient » pour ils/elles, et « écoute » est le présent.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('918f6817-1e41-5ffc-ae6e-748d17a6875c', '0fc2782b-5804-5297-8899-85c84d7aa10f', 'Quel est le radical de l''imparfait du verbe « finir » (nous finissons) ?', '[{"id":"a","text":"fini-"},{"id":"b","text":"finir-"},{"id":"c","text":"finiss-"},{"id":"d","text":"finh-"}]'::jsonb, 'c', 'On prend la forme « nous » du présent sans -ons : nous finissons → finiss-. On obtient je finissais, tu finissais… « fini- » et « finir- » oublient le -ss- du présent.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8cdddd3-15f3-5180-97cb-e35d31e76cd1', '0fc2782b-5804-5297-8899-85c84d7aa10f', 'Complète : « Nous ___ dans une petite maison. »', '[{"id":"a","text":"habitons"},{"id":"b","text":"habitions"},{"id":"c","text":"habitaient"},{"id":"d","text":"habitais"}]'::jsonb, 'b', 'Avec « nous », l''imparfait prend -ions : nous habitions. « habitons » est le présent, « habitaient » est pour ils/elles, et « habitais » pour je/tu.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9122d2ce-69a8-532d-b1c3-c83540c39c00', '0fc2782b-5804-5297-8899-85c84d7aa10f', 'Complète : « Vous ___ beaucoup de livres. »', '[{"id":"a","text":"lisez"},{"id":"b","text":"lisaient"},{"id":"c","text":"lisait"},{"id":"d","text":"lisiez"}]'::jsonb, 'd', 'Avec « vous », l''imparfait prend -iez : vous lisiez (radical de nous lisons → lis-). « lisez » est le présent, « lisaient » est pour ils/elles, et « lisait » pour il/elle.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0015e00d-b558-55c5-b7b7-98faa4ce4513', 'cf8cd70e-d021-5c57-a8a3-47956ffed3ed', 'francais-a2', '⭐⭐ Révision : l''imparfait', 2, 75, 15, 'practice', 'admin', 2)
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
  ('6ca3a5cd-e731-55df-b8b2-c7fbe1303396', '0015e00d-b558-55c5-b7b7-98faa4ce4513', 'Complète : « Quand j''___ enfant, j''avais peur du noir. »', '[{"id":"a","text":"étais"},{"id":"b","text":"étaient"},{"id":"c","text":"ai été"},{"id":"d","text":"serais"}]'::jsonb, 'a', 'Être est la seule exception : son imparfait se forme sur ét-, et avec « je » → j''étais. « étaient » est pour ils/elles, « ai été » est le passé composé (action terminée), et « serais » est le conditionnel.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('834c59a1-160a-5086-8d12-ab210dad6291', '0015e00d-b558-55c5-b7b7-98faa4ce4513', 'Complète : « Ils ___ au café tous les dimanches. »', '[{"id":"a","text":"allait"},{"id":"b","text":"allais"},{"id":"c","text":"allaient"},{"id":"d","text":"vont"}]'::jsonb, 'c', '« Tous les dimanches » = habitude passée, donc imparfait, et avec « ils » la terminaison est -aient : ils allaient (nous allons → all-). « allait » est pour il, « allais » pour je/tu, « vont » le présent.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('516ad169-a724-58b9-9757-37ffaf8a4955', '0015e00d-b558-55c5-b7b7-98faa4ce4513', 'Complète : « Il ___ froid et le vent soufflait fort. »', '[{"id":"a","text":"fait"},{"id":"b","text":"faisait"},{"id":"c","text":"faisais"},{"id":"d","text":"a fait"}]'::jsonb, 'b', 'Description de la météo dans le passé → imparfait : il faisait froid (forme à mémoriser). « fait » est le présent, « faisais » est pour je/tu, et « a fait » le passé composé.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4919eac7-6990-54bd-941b-4dcf41b4504e', '0015e00d-b558-55c5-b7b7-98faa4ce4513', 'Trouve la forme MAL orthographiée de l''imparfait.', '[{"id":"a","text":"nous mangions"},{"id":"b","text":"vous chantiez"},{"id":"c","text":"tu travaillais"},{"id":"d","text":"ils regardait"}]'::jsonb, 'd', 'Avec « ils », il faut -aient : ils regardaient, pas « regardait » (qui est la forme de il/elle). Les trois autres sont correctes : nous mangions, vous chantiez, tu travaillais.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b6576a3f-4862-5d83-93f9-0e2ec985ccea', '0015e00d-b558-55c5-b7b7-98faa4ce4513', 'Complète : « Nous ___ nos devoirs avant le dîner. »', '[{"id":"a","text":"faisions"},{"id":"b","text":"faisons"},{"id":"c","text":"faisaient"},{"id":"d","text":"faisiez"}]'::jsonb, 'a', 'Avec « nous », l''imparfait prend -ions, sur le radical de nous faisons → fais- : nous faisions. « faisons » est le présent, « faisaient » est pour ils, et « faisiez » pour vous.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a5ff9761-1f18-5b91-819d-fc04da5e0dc8', '0015e00d-b558-55c5-b7b7-98faa4ce4513', 'Complète : « Vous ___ toujours en retard à l''école. »', '[{"id":"a","text":"étiez"},{"id":"b","text":"étaient"},{"id":"c","text":"étais"},{"id":"d","text":"êtes"}]'::jsonb, 'a', 'Imparfait d''être avec « vous » : vous étiez (radical ét-). « étaient » est pour ils/elles, « étais » pour je/tu, et « êtes » est le présent.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('acbe0952-a6ff-5981-b1f6-094bfb2d418d', 'cf8cd70e-d021-5c57-a8a3-47956ffed3ed', 'francais-a2', '⚔️ Boss du chapitre ⭐⭐⭐ : l''imparfait', 3, 120, 30, 'boss', 'admin', 3)
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
  ('6bd53e1c-3f2e-57ed-bacc-4ea70ff4445b', 'acbe0952-a6ff-5981-b1f6-094bfb2d418d', 'Complète : « Je ___ la télé quand le téléphone a sonné. »', '[{"id":"a","text":"ai regardé"},{"id":"b","text":"regardais"},{"id":"c","text":"regarderai"},{"id":"d","text":"regarde"}]'::jsonb, 'b', '« Je regardais » est l''action en cours (le décor) interrompue par « a sonné » (action ponctuelle au passé composé) → imparfait : je regardais. Le piège courant est d''utiliser « ai regardé », mais ce serait une action terminée, pas le fond de la scène.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fafe1803-d3d5-5c6b-8d17-91453a7b9e38', 'acbe0952-a6ff-5981-b1f6-094bfb2d418d', 'Choisis la phrase correcte pour exprimer une habitude passée.', '[{"id":"a","text":"Hier, je suis allé à la piscine."},{"id":"b","text":"Tous les étés, nous allions à la mer."},{"id":"c","text":"Tous les étés, nous sommes allés à la mer."},{"id":"d","text":"Demain, nous irons à la mer."}]'::jsonb, 'b', 'Une habitude répétée dans le passé s''exprime à l''imparfait : tous les étés, nous allions à la mer. La phrase (c) au passé composé décrirait une seule fois, (a) est une action unique passée, et (d) est au futur.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('749543af-0164-53d3-894d-532d4c4a5f00', 'acbe0952-a6ff-5981-b1f6-094bfb2d418d', 'Complète : « Pendant que tu ___ , j''ai préparé le repas. »', '[{"id":"a","text":"as dormi"},{"id":"b","text":"dormiras"},{"id":"c","text":"dormais"},{"id":"d","text":"dors"}]'::jsonb, 'c', '« Pendant que » introduit une action en cours servant de fond → imparfait : pendant que tu dormais (nous dormons → dorm-). Le piège est « as dormi » : le passé composé marquerait une action achevée, pas une durée parallèle.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1eed5120-4613-55ac-9ca2-18bf22be7a54', 'acbe0952-a6ff-5981-b1f6-094bfb2d418d', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Quand elle est entrée, je lisais."},{"id":"b","text":"Il y avait beaucoup de monde."},{"id":"c","text":"Nous prenions le bus chaque jour."},{"id":"d","text":"Soudain, le chien aboyait et a couru."}]'::jsonb, 'd', 'L''erreur est (d) : « soudain » marque une action ponctuelle, qui demande le passé composé (le chien a aboyé et a couru), pas l''imparfait « aboyait ». Les phrases (a), (b) et (c) sont correctes.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('552c04bc-0120-56e3-b436-94965565d607', 'acbe0952-a6ff-5981-b1f6-094bfb2d418d', 'Complète : « Il y ___ une vieille horloge dans le salon. »', '[{"id":"a","text":"avait"},{"id":"b","text":"avais"},{"id":"c","text":"a eu"},{"id":"d","text":"aurait"}]'::jsonb, 'a', 'Pour décrire le décor passé, « il y a » devient « il y avait » à l''imparfait (forme à mémoriser). « avais » est pour je/tu, « a eu » est le passé composé d''une action ponctuelle, et « aurait » le conditionnel.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('05dcd64d-a9c2-5527-ad33-9fd63662ce3b', 'acbe0952-a6ff-5981-b1f6-094bfb2d418d', 'Complète : « Quand nous ___ jeunes, nous ___ souvent au cinéma. »', '[{"id":"a","text":"étions / sommes allés"},{"id":"b","text":"avons été / allions"},{"id":"c","text":"étions / allions"},{"id":"d","text":"étions / allaient"}]'::jsonb, 'c', 'Description (« quand nous étions jeunes ») et habitude (« souvent ») sont toutes deux à l''imparfait : nous étions / nous allions. Le piège (a) mélange un passé composé d''action unique, et (d) met « allaient » (ils) au lieu de « allions » (nous).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0453ef21-0625-5629-a93d-489a37c3a597', 'cf8cd70e-d021-5c57-a8a3-47956ffed3ed', 'francais-a2', '👑 Défi élite ⭐⭐⭐⭐ : l''imparfait', 3, 300, 60, 'challenge', 'admin', 4)
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
  ('804d5279-ff81-5bc7-991c-7f37747c1928', '0453ef21-0625-5629-a93d-489a37c3a597', 'Choisis la suite correcte : « Hier soir, je dormais profondément quand... »', '[{"id":"a","text":"...un bruit me réveillait."},{"id":"b","text":"...un bruit me réveillera."},{"id":"c","text":"...un bruit m''a réveillé."},{"id":"d","text":"...un bruit me réveille."}]'::jsonb, 'c', '« Je dormais » est le fond (imparfait) ; l''événement soudain qui l''interrompt va au passé composé : un bruit m''a réveillé. Le piège (a) met l''imparfait, mais « réveiller » est ici une action ponctuelle, pas une description.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2e2db70-d20b-596a-ac03-de97e1e1670e', '0453ef21-0625-5629-a93d-489a37c3a597', 'Complète : « Autrefois, les gens ___ moins vite et ils ___ plus de temps libre. »', '[{"id":"a","text":"vivaient / avaient"},{"id":"b","text":"vivait / avait"},{"id":"c","text":"ont vécu / ont eu"},{"id":"d","text":"vivaient / avait"}]'::jsonb, 'a', '« Autrefois » appelle une description du passé à l''imparfait, et avec « ils » la terminaison est -aient : ils vivaient, ils avaient. Le piège (d) accorde mal « avait » (il) avec « ils », et (c) emploie le passé composé d''actions uniques.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a43ef917-1a42-500c-9cce-cd01b00dc13e', '0453ef21-0625-5629-a93d-489a37c3a597', 'Trouve la phrase où l''imparfait est MAL employé.', '[{"id":"a","text":"Le soleil brillait ce matin-là."},{"id":"b","text":"L''an dernier, il déménageait à Lyon."},{"id":"c","text":"Elle portait une robe rouge."},{"id":"d","text":"Nous regardions les étoiles."}]'::jsonb, 'b', '« L''an dernier, il a déménagé à Lyon » est une action unique et achevée → passé composé, pas l''imparfait « déménageait ». Les phrases (a), (c) et (d) décrivent un décor ou un état, donc l''imparfait y est correct.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e8dcad47-b184-5f88-a304-f55dcbc8bbb0', '0453ef21-0625-5629-a93d-489a37c3a597', 'Complète : « Nous ___ le dîner pendant que vous ___ la table. »', '[{"id":"a","text":"préparions / mettaient"},{"id":"b","text":"préparions / mettez"},{"id":"c","text":"préparons / mettiez"},{"id":"d","text":"préparions / mettiez"}]'::jsonb, 'd', 'Deux actions en cours et parallèles dans le passé → imparfait pour les deux : nous préparions (-ions) / vous mettiez (-iez). Le piège (a) met « mettaient » (ils) au lieu de « mettiez » (vous), et (b)/(c) glissent un présent.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c13f7d01-b441-5619-8a1b-d7d0d648bcb4', '0453ef21-0625-5629-a93d-489a37c3a597', 'Quelle phrase combine correctement décor (imparfait) et événement (passé composé) ?', '[{"id":"a","text":"Il pleuvait quand nous sommes sortis."},{"id":"b","text":"Il a plu quand nous sortions."},{"id":"c","text":"Il pleuvait quand nous sortions."},{"id":"d","text":"Il a plu quand nous sommes sortis."}]'::jsonb, 'a', 'Le décor (la pluie en cours) va à l''imparfait, l''événement (la sortie) au passé composé : il pleuvait quand nous sommes sortis. (c) met tout à l''imparfait (pas d''événement), (d) tout au passé composé, et (b) inverse les rôles.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24cc9b7b-d23e-5798-8c08-498e22776c7c', '0453ef21-0625-5629-a93d-489a37c3a597', 'Complète : « Chaque hiver, vous ___ du ski, mais cette année-là vous ___ malades. »', '[{"id":"a","text":"faisiez / avez été"},{"id":"b","text":"faisiez / étiez"},{"id":"c","text":"faisaient / étiez"},{"id":"d","text":"avez fait / étiez"}]'::jsonb, 'b', '« Chaque hiver » = habitude → imparfait (vous faisiez), et un état décrit dans le passé reste à l''imparfait (vous étiez malades). Le piège (a) met « avez été » (action ponctuelle) alors qu''il s''agit d''un état, et (c) accorde mal « faisaient » (ils) avec « vous ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c0fc7d48-9428-5456-b45b-28c206ea698a', 'cf8cd70e-d021-5c57-a8a3-47956ffed3ed', 'francais-a2', '⭐⭐ Drill : l''imparfait', 2, 75, 15, 'practice', 'admin', 5)
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
  ('b269d687-4ae0-5c59-addf-ce3d34e085d2', 'c0fc7d48-9428-5456-b45b-28c206ea698a', 'Complète : « D''habitude, tu ___ tôt le matin. »', '[{"id":"a","text":"te levait"},{"id":"b","text":"te lèves"},{"id":"c","text":"te levaient"},{"id":"d","text":"te levais"}]'::jsonb, 'd', '« D''habitude » = habitude passée → imparfait, et avec « tu » la terminaison est -ais : tu te levais. « te levait » est pour il/elle, « te lèves » est le présent, et « te levaient » pour ils/elles.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('61981da2-e7f6-52e5-b311-d99dffa06100', 'c0fc7d48-9428-5456-b45b-28c206ea698a', 'Complète : « Le village ___ calme et les rues ___ vides. »', '[{"id":"a","text":"était / étaient"},{"id":"b","text":"était / était"},{"id":"c","text":"étaient / étaient"},{"id":"d","text":"a été / ont été"}]'::jsonb, 'a', 'Description du passé à l''imparfait : « le village » (singulier) → était, « les rues » (pluriel) → étaient. Le piège (b) oublie l''accord au pluriel, et (d) emploie le passé composé d''une action ponctuelle.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a58942e-85ca-5aea-8607-b5a137f3ea34', 'c0fc7d48-9428-5456-b45b-28c206ea698a', 'Trouve la forme INCORRECTE de l''imparfait.', '[{"id":"a","text":"nous buvions"},{"id":"b","text":"vous écriviez"},{"id":"c","text":"je prennais"},{"id":"d","text":"elle voyait"}]'::jsonb, 'c', 'Le radical vient de « nous prenons » → pren-, donc je prenais (un seul n), pas « prennais ». Les autres sont correctes : nous buvions (nous buvons), vous écriviez (nous écrivons), elle voyait (nous voyons).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34858e86-a6f1-542c-ab01-f854c5e12f09', 'c0fc7d48-9428-5456-b45b-28c206ea698a', 'Complète : « À cette époque, il ___ marcher une heure pour aller à l''école. »', '[{"id":"a","text":"faut"},{"id":"b","text":"fallait"},{"id":"c","text":"fallais"},{"id":"d","text":"a fallu"}]'::jsonb, 'b', '« Il faut » devient « il fallait » à l''imparfait (forme à mémoriser), employée ici pour décrire une nécessité habituelle dans le passé. « faut » est le présent, « fallais » n''existe pas, et « a fallu » serait une nécessité ponctuelle.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed2ad108-0c44-5bff-9503-020275d20b11', 'c0fc7d48-9428-5456-b45b-28c206ea698a', 'Complète : « Ils ___ de la musique pendant qu''elle ___ . »', '[{"id":"a","text":"écoutaient / dansait"},{"id":"b","text":"écoutait / dansait"},{"id":"c","text":"écoutaient / dansaient"},{"id":"d","text":"ont écouté / a dansé"}]'::jsonb, 'a', 'Deux actions en cours et parallèles dans le passé → imparfait : « ils » écoutaient (-aient) et « elle » dansait (-ait). Le piège (c) met « dansaient » (ils) au lieu de « dansait » (elle), et (d) emploie le passé composé.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3fcba4d8-8dbc-5c53-857b-93133c77c939', 'c0fc7d48-9428-5456-b45b-28c206ea698a', 'Complète : « Quand nous ___ à la campagne, nous ___ les oiseaux. »', '[{"id":"a","text":"étions / écoutait"},{"id":"b","text":"étions / écoutions"},{"id":"c","text":"étaient / écoutions"},{"id":"d","text":"avons été / écoutions"}]'::jsonb, 'b', 'Description et habitude au passé → imparfait, et avec « nous » la terminaison est -ions : nous étions / nous écoutions. Le piège (a) met « écoutait » (il), (c) met « étaient » (ils), et (d) glisse un passé composé.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3d7d0d62-ae37-5ca7-9a4b-0a160ee18d42', 'de301347-ce07-5492-a3d5-072b4fde36ce', 'francais-a2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('29e91369-37b3-52bf-bf90-52ddceda417b', '3d7d0d62-ae37-5ca7-9a4b-0a160ee18d42', 'Complète au futur proche : « Ce soir, je ___ un film. »', '[{"id":"a","text":"vais regarder"},{"id":"b","text":"vais regarde"},{"id":"c","text":"va regarder"},{"id":"d","text":"allerai regarder"}]'::jsonb, 'a', 'Le futur proche se forme avec aller au présent + infinitif : je vais regarder. « vais regarde » garde un verbe conjugué au lieu de l''infinitif, « va regarder » utilise la forme de il/elle, et « allerai » n''existe pas (le futur de aller est j''irai).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af18154c-631a-51e0-ae3b-3b4be5b2c946', '3d7d0d62-ae37-5ca7-9a4b-0a160ee18d42', 'Quelle est la forme du futur simple de « parler » à la première personne (je) ?', '[{"id":"a","text":"je parlrai"},{"id":"b","text":"je parlerai"},{"id":"c","text":"je parlais"},{"id":"d","text":"je parlera"}]'::jsonb, 'b', 'Le futur simple = infinitif + terminaison : parler + -ai → je parlerai. « parlrai » oublie le e de l''infinitif, « parlais » est l''imparfait, et « parlera » est la forme de il/elle.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90a65ae6-b2fe-5267-ba2a-cae04ee7b8c2', '3d7d0d62-ae37-5ca7-9a4b-0a160ee18d42', 'Mets cette phrase au futur proche à la forme négative : « Je ___ manger maintenant. »', '[{"id":"a","text":"vais ne pas"},{"id":"b","text":"ne mange pas vais"},{"id":"c","text":"ne vais pas"},{"id":"d","text":"vais pas ne"}]'::jsonb, 'c', 'À la négation, on encadre le verbe aller par ne … pas : je ne vais pas manger. Les autres placent mal ne et pas ; au futur proche, la négation entoure aller, pas l''infinitif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c2d26ca-5455-51fb-98cc-da410b3118b6', '3d7d0d62-ae37-5ca7-9a4b-0a160ee18d42', 'Quel est le futur simple correct du verbe « être » à la première personne (je) ?', '[{"id":"a","text":"j''êtrai"},{"id":"b","text":"j''aurai"},{"id":"c","text":"j''étais"},{"id":"d","text":"je serai"}]'::jsonb, 'd', 'Le verbe être a un radical irrégulier au futur : ser-, donc je serai. « j''êtrai » applique à tort l''infinitif, « j''aurai » est le futur de avoir, et « j''étais » est l''imparfait de être.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa6491ff-2936-52f3-93d8-53e068c26990', '3d7d0d62-ae37-5ca7-9a4b-0a160ee18d42', 'Quelle phrase exprime un projet proche et sûr (futur proche) ?', '[{"id":"a","text":"Nous partirons un jour à l''étranger."},{"id":"b","text":"Nous allons partir dans dix minutes."},{"id":"c","text":"Nous partons souvent le matin."},{"id":"d","text":"Nous partions chaque été."}]'::jsonb, 'b', 'Le futur proche (aller + infinitif) marque un projet proche et certain : nous allons partir dans dix minutes. La phrase (a) est au futur simple (avenir lointain), (c) est au présent (habitude), et (d) à l''imparfait (passé).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2978f60a-fea9-550a-8ed7-0b5c1f020662', 'de301347-ce07-5492-a3d5-072b4fde36ce', 'francais-a2', '⭐ Entraînement : le futur', 1, 50, 10, 'practice', 'admin', 1)
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
  ('042ddedf-ac26-500b-94e4-b2d032a49ea2', '2978f60a-fea9-550a-8ed7-0b5c1f020662', 'Complète au futur proche : « Tu ___ tes devoirs maintenant. » (faire)', '[{"id":"a","text":"va faire"},{"id":"b","text":"vas faire"},{"id":"c","text":"vas fais"},{"id":"d","text":"feras"}]'::jsonb, 'b', 'Le futur proche = aller au présent + infinitif ; avec tu, aller donne vas : tu vas faire. « va faire » est la forme de il/elle, « vas fais » garde un verbe conjugué au lieu de l''infinitif, et « feras » est du futur simple.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ccf6b8bd-7b68-5e4a-b597-28df10cbe770', '2978f60a-fea9-550a-8ed7-0b5c1f020662', 'Complète au futur simple : « Demain, il ___ ses amis. » (inviter)', '[{"id":"a","text":"invitera"},{"id":"b","text":"inviteras"},{"id":"c","text":"invitra"},{"id":"d","text":"va inviter"}]'::jsonb, 'a', 'Au futur simple, il prend la terminaison -a : inviter + -a → il invitera. « inviteras » est la forme de tu, « invitra » oublie le e de l''infinitif, et « va inviter » est du futur proche (pas demandé ici).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2bfeb3c-d951-572f-adb6-5dfff7a27a40', '2978f60a-fea9-550a-8ed7-0b5c1f020662', 'Complète au futur proche : « Nous ___ au cinéma ce soir. » (aller)', '[{"id":"a","text":"vont aller"},{"id":"b","text":"irons"},{"id":"c","text":"allons aller"},{"id":"d","text":"allons allons"}]'::jsonb, 'c', 'Le futur proche du verbe aller = aller au présent + l''infinitif aller : nous allons aller. « vont aller » est la forme de ils, « irons » est du futur simple, et « allons allons » répète une forme conjuguée.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7d7ac80c-2528-5f07-898d-d8624a3598eb', '2978f60a-fea9-550a-8ed7-0b5c1f020662', 'Complète au futur simple : « Vous ___ la maison l''an prochain. » (vendre)', '[{"id":"a","text":"venderez"},{"id":"b","text":"vendez"},{"id":"c","text":"vendrons"},{"id":"d","text":"vendrez"}]'::jsonb, 'd', 'Pour les verbes en -re, on enlève le e avant la terminaison : vendre → vendr- + -ez → vous vendrez. « venderez » garde le e à tort, « vendez » est le présent, et « vendrons » est la forme de nous.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb7a0124-7262-5b23-ad81-0cdd7fbb1995', '2978f60a-fea9-550a-8ed7-0b5c1f020662', 'Mets au futur proche négatif : « Je ___ ce soir. » (sortir)', '[{"id":"a","text":"vais ne pas sortir"},{"id":"b","text":"ne sortirai pas"},{"id":"c","text":"ne vais pas sortir"},{"id":"d","text":"ne vais sortir pas"}]'::jsonb, 'c', 'Au futur proche, on encadre aller par ne … pas, puis l''infinitif : je ne vais pas sortir. « ne sortirai pas » est du futur simple, « vais ne pas » et « ne vais sortir pas » placent mal ne et pas autour du verbe aller.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b8bb36b-ecd1-55de-9030-825a58237dd0', '2978f60a-fea9-550a-8ed7-0b5c1f020662', 'Complète au futur simple : « En 2030, on ___ sur Mars. » (voyager)', '[{"id":"a","text":"voyageras"},{"id":"b","text":"va voyager"},{"id":"c","text":"voyagerons"},{"id":"d","text":"voyagera"}]'::jsonb, 'd', 'Une prévision lointaine se met au futur simple ; avec on (= il), la terminaison est -a : on voyagera. « voyageras » est pour tu, « va voyager » est du futur proche, et « voyagerons » est la forme de nous.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f8f14423-6dbf-5dcf-b93f-37463a49cd53', 'de301347-ce07-5492-a3d5-072b4fde36ce', 'francais-a2', '⭐⭐ Révision : le futur', 2, 75, 15, 'practice', 'admin', 2)
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
  ('beec616f-671c-52ad-9c5b-f995d0f9bac4', 'f8f14423-6dbf-5dcf-b93f-37463a49cd53', 'Complète au futur simple : « Quand tu seras grand, tu ___ ce que tu veux. » (faire)', '[{"id":"a","text":"fairas"},{"id":"b","text":"feras"},{"id":"c","text":"faireras"},{"id":"d","text":"vas faire"}]'::jsonb, 'b', 'Le verbe faire a un radical irrégulier au futur : fer-, donc tu feras. « fairas » et « faireras » appliquent à tort l''infinitif, et « vas faire » est du futur proche alors qu''on demande le futur simple.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8e59f2ac-67ef-54c8-82a1-95943e9aa7f4', 'f8f14423-6dbf-5dcf-b93f-37463a49cd53', 'Complète au futur simple : « L''été prochain, nous ___ à la mer. » (aller)', '[{"id":"a","text":"allerons"},{"id":"b","text":"allons"},{"id":"c","text":"irons"},{"id":"d","text":"irerons"}]'::jsonb, 'c', 'Le futur simple du verbe aller utilise le radical irrégulier ir- : nous irons. « allerons » applique à tort l''infinitif, « allons » est le présent, et « irerons » double les terminaisons.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a9fa118-db5a-5459-959c-caad128784c3', 'f8f14423-6dbf-5dcf-b93f-37463a49cd53', 'Quelle phrase est correcte au futur proche ?', '[{"id":"a","text":"Elle va prendre le bus."},{"id":"b","text":"Elle va prend le bus."},{"id":"c","text":"Elle vont prendre le bus."},{"id":"d","text":"Elle va prendra le bus."}]'::jsonb, 'a', 'Le futur proche = aller au présent + infinitif : elle va prendre. « va prend » et « va prendra » mettent un verbe conjugué au lieu de l''infinitif, et « vont » est la forme de ils/elles, pas de elle.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dc558038-0cfa-5618-b6b8-8f38d3303263', 'f8f14423-6dbf-5dcf-b93f-37463a49cd53', 'Complète au futur simple : « Demain, j''___ le temps de t''aider. » (avoir)', '[{"id":"a","text":"avrai"},{"id":"b","text":"aurai"},{"id":"c","text":"aurais"},{"id":"d","text":"avoirai"}]'::jsonb, 'b', 'Le verbe avoir a le radical irrégulier aur- au futur : j''aurai. « aurais » est le conditionnel, « avrai » et « avoirai » ne sont pas des formes existantes du futur de avoir.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('48708813-e053-56d5-a278-2fa44c639e69', 'f8f14423-6dbf-5dcf-b93f-37463a49cd53', 'Complète au futur simple : « Plus tard, ils ___ médecins. » (être)', '[{"id":"a","text":"seraient"},{"id":"b","text":"êtront"},{"id":"c","text":"vont être"},{"id":"d","text":"seront"}]'::jsonb, 'd', 'Le verbe être prend le radical ser- au futur ; avec ils, la terminaison est -ont : ils seront. « seraient » est le conditionnel, « êtront » applique à tort l''infinitif, et « vont être » est du futur proche.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2c7ebe50-1950-5be1-9841-b1283ece77d7', 'f8f14423-6dbf-5dcf-b93f-37463a49cd53', 'Quelle phrase exprime correctement une prévision lointaine ?', '[{"id":"a","text":"Dans cent ans, les robots font tout le travail."},{"id":"b","text":"Dans cent ans, les robots vont faire tout le travail tout à l''heure."},{"id":"c","text":"Dans cent ans, les robots feront tout le travail."},{"id":"d","text":"Dans cent ans, les robots faisaient tout le travail."}]'::jsonb, 'c', 'Une prévision lointaine se met au futur simple : les robots feront (radical fer- de faire). Le présent (a) ne situe pas dans l''avenir, (b) mélange futur proche et « tout à l''heure » (proche), incohérent avec « dans cent ans », et (d) est à l''imparfait (passé).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('336cb417-149a-52b1-bfca-178f54f2adff', 'de301347-ce07-5492-a3d5-072b4fde36ce', 'francais-a2', '⚔️ Boss du chapitre ⭐⭐⭐ : le futur', 3, 120, 30, 'boss', 'admin', 3)
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
  ('6e2ba244-01e5-5a8c-8b18-9ddb5c34d375', '336cb417-149a-52b1-bfca-178f54f2adff', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Je vais partir tout de suite."},{"id":"b","text":"Nous ne vont pas venir."},{"id":"c","text":"Tu prendras le train demain."},{"id":"d","text":"Ils seront prêts à midi."}]'::jsonb, 'b', 'L''erreur est en (b) : avec nous, aller donne allons, donc « nous n''allons pas venir ». « vont » est la forme de ils/elles. Les autres phrases sont correctes : (a) futur proche, (c) et (d) futur simple bien formés.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5a0888b-c7a0-54c9-b5df-5734ab49d7d5', '336cb417-149a-52b1-bfca-178f54f2adff', 'Complète au futur simple : « Si tu travailles, tu ___ réussir. » (pouvoir)', '[{"id":"a","text":"pouvras"},{"id":"b","text":"pourras"},{"id":"c","text":"pourais"},{"id":"d","text":"vas pouvoir"}]'::jsonb, 'b', 'Le verbe pouvoir a le radical irrégulier pourr- au futur ; avec tu : tu pourras. « pouvras » applique à tort l''infinitif, « pourais » oublie un r et ressemble au conditionnel, et « vas pouvoir » est du futur proche.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('313ab95b-6cf3-59ff-82f3-cf8fded5275b', '336cb417-149a-52b1-bfca-178f54f2adff', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Demain je ferai mes courses."},{"id":"b","text":"Elle va venir ce soir."},{"id":"c","text":"L''année prochaine, j''allerai à Paris."},{"id":"d","text":"Nous verrons le résultat bientôt."}]'::jsonb, 'c', 'L''erreur est en (c) : le futur simple de aller est j''irai (radical ir-), jamais « j''allerai ». Les autres sont correctes : (a) j''aurai… (radical fer- de faire), (b) futur proche, et (d) verr- de voir.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7868e60e-111f-5f31-9994-7438295f31c3', '336cb417-149a-52b1-bfca-178f54f2adff', 'Complète au futur simple : « Quand ils arriveront, nous ___ déjà partis. » Choisis le bon verbe au futur. (être)', '[{"id":"a","text":"serons"},{"id":"b","text":"aurons"},{"id":"c","text":"serions"},{"id":"d","text":"seront"}]'::jsonb, 'a', 'Avec nous, le futur de être (radical ser-) est nous serons. « seront » est la forme de ils, « aurons » est le futur de avoir, et « serions » est le conditionnel, pas le futur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('207c8e07-3209-5e9a-94ff-87817cea8202', '336cb417-149a-52b1-bfca-178f54f2adff', 'Quelle phrase emploie correctement le futur proche pour un projet sûr et immédiat ?', '[{"id":"a","text":"Attention, le verre tombera."},{"id":"b","text":"Attention, le verre va tombera."},{"id":"c","text":"Attention, le verre allera tomber."},{"id":"d","text":"Attention, le verre va tomber !"}]'::jsonb, 'd', 'Pour un événement proche et certain (on le voit arriver), on choisit le futur proche : le verre va tomber. (a) au futur simple est moins naturel pour un fait imminent, (b) met un verbe conjugué après aller, et (c) déforme aller (la forme est va).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12e14128-ff35-518e-83a3-6379b25ccb4b', '336cb417-149a-52b1-bfca-178f54f2adff', 'Choisis la phrase entièrement correcte.', '[{"id":"a","text":"Demain je vais réviser, puis je passrai l''examen."},{"id":"b","text":"Demain je vais réviser, puis je passerai l''examen."},{"id":"c","text":"Demain je vais réviserai, puis je passerai l''examen."},{"id":"d","text":"Demain je vais réviser, puis je vais passerai l''examen."}]'::jsonb, 'b', 'Seule (b) est correcte : futur proche (vais réviser, infinitif) puis futur simple (passerai, infinitif + -ai). (a) oublie le e de passer, (c) met un verbe conjugué après vais, et (d) ajoute une forme conjuguée après vais. Le piège courant est de cumuler les deux constructions.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c4466f78-3969-53b8-81b3-0e5bf7cd760f', 'de301347-ce07-5492-a3d5-072b4fde36ce', 'francais-a2', '👑 Défi élite ⭐⭐⭐⭐ : le futur', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('db8d2846-35e8-58e7-ae32-da953d906be4', 'c4466f78-3969-53b8-81b3-0e5bf7cd760f', 'Lis : « Mes valises sont faites, mon billet est réservé : je pars dans une heure. » Quelle phrase décrit le mieux la situation ?', '[{"id":"a","text":"Je prenais l''avion dans une heure."},{"id":"b","text":"Je prends souvent l''avion."},{"id":"c","text":"Un jour, je prendrai peut-être l''avion."},{"id":"d","text":"Je vais prendre l''avion dans une heure."}]'::jsonb, 'd', 'Le projet est sûr et tout proche (valises faites, billet réservé, départ dans une heure), donc le futur proche convient : je vais prendre l''avion. (a) est l''imparfait (passé), (b) le présent d''habitude, et (c) un futur simple vague qui contredit la certitude du texte.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('465b3487-143f-5120-b114-44ab588cc366', 'c4466f78-3969-53b8-81b3-0e5bf7cd760f', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Nous viendrons te voir samedi."},{"id":"b","text":"Tu sauras la vérité bientôt."},{"id":"c","text":"Elle va devra travailler ce week-end."},{"id":"d","text":"Je voudrai un café après le repas."}]'::jsonb, 'c', 'L''erreur est en (c) : on ne cumule pas futur proche et futur simple ; il faut « elle va devoir » (proche) ou « elle devra » (simple). Les autres sont correctes : viendr- (venir), saur- (savoir), voudr- (vouloir).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('226ee550-734e-57ae-8ca9-e4acade70454', 'c4466f78-3969-53b8-81b3-0e5bf7cd760f', 'Complète au futur simple avec le bon radical : « Le mois prochain, vous ___ vos résultats et vous ___ choisir une école. » (voir / devoir)', '[{"id":"a","text":"verrez / devrez"},{"id":"b","text":"voirez / devrez"},{"id":"c","text":"voyez / devez"},{"id":"d","text":"verrez / devoirez"}]'::jsonb, 'a', 'Voir prend le radical verr- et devoir le radical devr- ; avec vous : vous verrez, vous devrez. « voirez » et « devoirez » appliquent à tort l''infinitif, et « voyez / devez » est le présent, pas le futur.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('781c1518-5a48-51ad-9db6-03b835b77e73', 'c4466f78-3969-53b8-81b3-0e5bf7cd760f', 'Lis : « Karim a fini ses études et a accepté un poste à Tunis ; il commence lundi. » Quelle affirmation est VRAIE ?', '[{"id":"a","text":"Il ne travaillera jamais à Tunis."},{"id":"b","text":"Il va commencer son travail à Tunis lundi."},{"id":"c","text":"Il va reprendre ses études."},{"id":"d","text":"Il travaillait déjà à Tunis l''an dernier."}]'::jsonb, 'b', 'Karim a accepté un poste et commence lundi : le projet proche et sûr se dit au futur proche, il va commencer. (a) et (c) contredisent le texte (il a fini ses études et accepté le poste), et (d) est à l''imparfait (passé), ce que le texte ne dit pas.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a65a7fa-b305-537d-beb7-b85054b61e20', 'c4466f78-3969-53b8-81b3-0e5bf7cd760f', 'Choisis la phrase entièrement correcte.', '[{"id":"a","text":"Quand j''aurai fini, je viendrai et je fairai le ménage."},{"id":"b","text":"Quand j''aurais fini, je viendrai et je ferai le ménage."},{"id":"c","text":"Quand j''aurai fini, je viendrai et je ferai le ménage."},{"id":"d","text":"Quand j''aurai fini, je venirai et je ferai le ménage."}]'::jsonb, 'c', 'Seule (c) enchaîne trois futurs corrects : aurai (aur-), viendrai (viendr-), ferai (fer-). (a) écrit « fairai » au lieu de ferai, (b) met « aurais » (conditionnel), et (d) écrit « venirai » au lieu de viendrai. Le piège courant est d''oublier ces radicaux irréguliers.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('edb49c48-89a6-5854-875e-ce3a9a609c2b', 'c4466f78-3969-53b8-81b3-0e5bf7cd760f', 'Lis : « Le ciel est tout noir et le vent se lève. » Quelle suite est la plus naturelle ?', '[{"id":"a","text":"Il pleuvra peut-être dans plusieurs années."},{"id":"b","text":"Il va pleuvoir d''un instant à l''autre."},{"id":"c","text":"Il pleuvait d''un instant à l''autre."},{"id":"d","text":"Il pleut chaque jour à cette heure."}]'::jsonb, 'b', 'On observe un signe immédiat (ciel noir, vent), donc on prévoit un événement tout proche au futur proche : il va pleuvoir. (a) au futur simple parle d''un avenir lointain incohérent, (c) est l''imparfait (passé), et (d) le présent d''habitude — aucun ne traduit l''imminence.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('53a405d9-9966-5e3c-80b0-a12210c841b5', 'de301347-ce07-5492-a3d5-072b4fde36ce', 'francais-a2', '⭐⭐ Drill : le futur', 2, 75, 15, 'practice', 'admin', 5)
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
  ('689d7b32-67a5-54ca-94ab-64388d2d6ea8', '53a405d9-9966-5e3c-80b0-a12210c841b5', 'Complète au futur proche : « Les enfants ___ bientôt. » (dormir)', '[{"id":"a","text":"vont dormir"},{"id":"b","text":"va dormir"},{"id":"c","text":"vont dorment"},{"id":"d","text":"dormiront"}]'::jsonb, 'a', 'Avec ils/elles, aller donne vont au présent, suivi de l''infinitif : les enfants vont dormir. « va dormir » est la forme du singulier, « vont dorment » garde un verbe conjugué, et « dormiront » est du futur simple.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2656fe34-1a7e-5b34-b460-c7e1ef79b209', '53a405d9-9966-5e3c-80b0-a12210c841b5', 'Complète au futur simple : « Bientôt, tu ___ conduire. » (savoir)', '[{"id":"a","text":"savras"},{"id":"b","text":"sauras"},{"id":"c","text":"saveras"},{"id":"d","text":"vas savoir"}]'::jsonb, 'b', 'Le verbe savoir a le radical irrégulier saur- au futur ; avec tu : tu sauras. « savras » et « saveras » appliquent à tort l''infinitif, et « vas savoir » est du futur proche alors qu''on demande le futur simple.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a4cb6aa9-6984-524a-afdd-3bf29732fb78', '53a405d9-9966-5e3c-80b0-a12210c841b5', 'Mets au futur proche négatif : « Vous ___ ce film. » (regarder)', '[{"id":"a","text":"n''allez pas regarder"},{"id":"b","text":"allez ne pas regarder"},{"id":"c","text":"ne regarderez pas"},{"id":"d","text":"n''allez regarder pas"}]'::jsonb, 'a', 'Au futur proche, on encadre aller par ne … pas, puis l''infinitif : vous n''allez pas regarder. « ne regarderez pas » est du futur simple, et les deux autres placent mal ne et pas autour de aller.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('adf1ae50-5beb-57a3-910d-4aba27f31791', '53a405d9-9966-5e3c-80b0-a12210c841b5', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Je viendrai te chercher à la gare."},{"id":"b","text":"Nous allons manger dans dix minutes."},{"id":"c","text":"Elle fairas un gâteau pour la fête."},{"id":"d","text":"Ils auront besoin de toi demain."}]'::jsonb, 'c', 'L''erreur est en (c) : le futur de faire est elle fera (radical fer-), jamais « fairas » (qui mélange l''infinitif et une terminaison de tu). Les autres sont correctes : viendr- (venir), futur proche, aur- (avoir).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db757d34-c8ef-551d-b6df-3f6800072e11', '53a405d9-9966-5e3c-80b0-a12210c841b5', 'Complète selon le sens : « Calme-toi, je te promets que je ___ à l''heure. » (arriver)', '[{"id":"a","text":"arrivais"},{"id":"b","text":"arrive"},{"id":"c","text":"arriverai"},{"id":"d","text":"vais arrivé"}]'::jsonb, 'c', 'Une promesse s''exprime au futur simple : je te promets que j''arriverai à l''heure. « arrivais » est l''imparfait (passé), « arrive » le présent, et « vais arrivé » est incorrect (après aller il faut l''infinitif arriver, pas le participe).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c3d48b5a-ddf9-5fb9-a35f-e173eb75af66', '53a405d9-9966-5e3c-80b0-a12210c841b5', 'Choisis la phrase entièrement correcte.', '[{"id":"a","text":"L''an prochain, nous irons en France et nous prendrons l''avion."},{"id":"b","text":"L''an prochain, nous allerons en France et nous prendrons l''avion."},{"id":"c","text":"L''an prochain, nous irons en France et nous prendons l''avion."},{"id":"d","text":"L''an prochain, nous allons irons en France et nous prendrons l''avion."}]'::jsonb, 'a', 'Seule (a) est correcte : irons (radical ir- de aller) et prendrons (prendre → prendr- + -ons). (b) écrit « allerons » au lieu de irons, (c) écrit « prendons » sans le r du futur, et (d) cumule « allons irons », deux formes du même verbe.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ae674f67-12e4-5dc3-bd23-932d19e9b4ea', '147e3a6d-3d6e-5a25-8592-1d951f2df95e', 'francais-a2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d455099f-df30-573a-9beb-de02ea9fe393', 'ae674f67-12e4-5dc3-bd23-932d19e9b4ea', 'Complète : « Le matin, je ___ à sept heures. »', '[{"id":"a","text":"me lève"},{"id":"b","text":"se lève"},{"id":"c","text":"lève"},{"id":"d","text":"te lève"}]'::jsonb, 'a', 'Avec « je », le pronom réfléchi est « me » : je me lève. « se lève » est pour il/elle, « te lève » est pour tu, et « lève » oublie le pronom réfléchi obligatoire.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('891c1d85-e42e-5955-942e-b27530ac5d94', 'ae674f67-12e4-5dc3-bd23-932d19e9b4ea', 'Complète : « Tu ___ les dents après le repas. »', '[{"id":"a","text":"se brosses"},{"id":"b","text":"te brosses"},{"id":"c","text":"me brosses"},{"id":"d","text":"te brosse"}]'::jsonb, 'b', 'Avec « tu », le pronom est « te » et le verbe prend -es : tu te brosses. « se brosses » utilise le mauvais pronom, « me brosses » est pour je, et « te brosse » oublie le -s de la deuxième personne.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('32f4d3a8-25a2-514f-9537-ca86fc77d4d2', 'ae674f67-12e4-5dc3-bd23-932d19e9b4ea', 'Choisis la phrase correcte.', '[{"id":"a","text":"Je me appelle Sami."},{"id":"b","text":"Je m''appelle Sami."},{"id":"c","text":"Je se appelle Sami."},{"id":"d","text":"Je appelle Sami."}]'::jsonb, 'b', '« appelle » commence par une voyelle, donc « me » s''élide en « m'' » : je m''appelle. « je me appelle » oublie l''élision obligatoire, « je se appelle » prend le mauvais pronom, et « je appelle » oublie le pronom réfléchi.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2803d635-b200-5095-9b67-07781e519519', 'ae674f67-12e4-5dc3-bd23-932d19e9b4ea', 'Complète : « Nous ___ dans le parc le dimanche. »', '[{"id":"a","text":"se promenons"},{"id":"b","text":"nous promenez"},{"id":"c","text":"nous promenons"},{"id":"d","text":"vous promenons"}]'::jsonb, 'c', 'Avec « nous », le pronom réfléchi est aussi « nous » et le verbe prend -ons : nous nous promenons. « se promenons » utilise le mauvais pronom, « nous promenez » et « vous promenons » mélangent les terminaisons de nous et vous.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a1f53d39-e1fd-5fa4-92d6-8a0ceb597fe9', 'ae674f67-12e4-5dc3-bd23-932d19e9b4ea', 'Mets à la forme négative : « Il se couche tôt. »', '[{"id":"a","text":"Il se ne couche pas tôt."},{"id":"b","text":"Il ne couche se pas tôt."},{"id":"c","text":"Il ne se couche pas tôt."},{"id":"d","text":"Il ne se couche tôt pas."}]'::jsonb, 'c', 'La négation encadre le pronom et le verbe ensemble : ne + se couche + pas → Il ne se couche pas tôt. Les autres séparent le pronom du verbe ou placent « pas » au mauvais endroit.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('db8a292d-259f-58e3-9093-f463ffbc9dce', '147e3a6d-3d6e-5a25-8592-1d951f2df95e', 'francais-a2', '⭐ Entraînement : les verbes pronominaux', 1, 50, 10, 'practice', 'admin', 1)
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
  ('b2c9f0db-2f23-55da-9309-23c05e0c1501', 'db8a292d-259f-58e3-9093-f463ffbc9dce', 'Complète : « Je ___ à six heures du matin. » (se réveiller)', '[{"id":"a","text":"me réveille"},{"id":"b","text":"se réveille"},{"id":"c","text":"te réveille"},{"id":"d","text":"réveille"}]'::jsonb, 'a', 'Avec « je », le pronom réfléchi est « me » : je me réveille. « se réveille » est pour il/elle, « te réveille » est pour tu, et « réveille » oublie le pronom obligatoire.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('369d9d8d-6a95-54db-8686-eb31e9f0005d', 'db8a292d-259f-58e3-9093-f463ffbc9dce', 'Complète : « Elle ___ vite le matin. » (se laver)', '[{"id":"a","text":"me lave"},{"id":"b","text":"te lave"},{"id":"c","text":"se lave"},{"id":"d","text":"se lavent"}]'::jsonb, 'c', 'Avec « elle », le pronom est « se » et le verbe prend -e : elle se lave. « me lave »/« te lave » sont pour je et tu, et « se lavent » est la forme du pluriel (ils/elles).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('157be412-8158-54aa-90a1-967f8504fe78', 'db8a292d-259f-58e3-9093-f463ffbc9dce', 'Quel est l''infinitif du verbe dans « tu te couches » ?', '[{"id":"a","text":"coucher"},{"id":"b","text":"se coucher"},{"id":"c","text":"te coucher"},{"id":"d","text":"couche"}]'::jsonb, 'b', 'À l''infinitif, le verbe pronominal garde le pronom « se » : se coucher. « coucher » oublie le pronom réfléchi, « te coucher » garde le pronom conjugué de tu, et « couche » est une forme conjuguée.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5117b93d-25a2-5dae-8214-4ff515d1f739', 'db8a292d-259f-58e3-9093-f463ffbc9dce', 'Complète : « Tu ___ avec tes amis. » (s''amuser)', '[{"id":"a","text":"te amuses"},{"id":"b","text":"s''amuses"},{"id":"c","text":"t''amuse"},{"id":"d","text":"t''amuses"}]'::jsonb, 'd', '« amuser » commence par une voyelle, donc « te » s''élide en « t'' », et le verbe prend -es : tu t''amuses. « te amuses » oublie l''élision, « s''amuses » prend le mauvais pronom, et « t''amuse » oublie le -s de tu.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ddff942b-5544-5547-b44a-8f53e9b51d86', 'db8a292d-259f-58e3-9093-f463ffbc9dce', 'Complète : « Vous ___ pour ne pas être en retard. » (se dépêcher)', '[{"id":"a","text":"vous dépêchez"},{"id":"b","text":"se dépêchez"},{"id":"c","text":"nous dépêchez"},{"id":"d","text":"vous dépêchons"}]'::jsonb, 'a', 'Avec « vous », le pronom réfléchi est aussi « vous » et le verbe prend -ez : vous vous dépêchez. « se dépêchez » prend le mauvais pronom, et les autres mélangent les terminaisons de nous et vous.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d99a7fdd-a2ce-5a81-a83c-9f232b0fc16a', 'db8a292d-259f-58e3-9093-f463ffbc9dce', 'Complète : « Il ___ devant le miroir. » (s''habiller)', '[{"id":"a","text":"se habille"},{"id":"b","text":"s''habille"},{"id":"c","text":"t''habille"},{"id":"d","text":"se habillent"}]'::jsonb, 'b', '« habiller » commence par un h muet, donc « se » s''élide en « s'' » : il s''habille. « se habille » oublie l''élision obligatoire, « t''habille » est pour tu, et « se habillent » est au pluriel et sans élision.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9960a5f5-e58f-52f8-9567-c3c8ae17113d', '147e3a6d-3d6e-5a25-8592-1d951f2df95e', 'francais-a2', '⭐⭐ Révision : les verbes pronominaux', 2, 75, 15, 'practice', 'admin', 2)
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
  ('e89968d1-c277-5a0a-9822-04d646e9a029', '9960a5f5-e58f-52f8-9567-c3c8ae17113d', 'Complète : « Nous ___ avant de manger. » (se laver les mains)', '[{"id":"a","text":"se lavons"},{"id":"b","text":"nous lavons"},{"id":"c","text":"vous lavons"},{"id":"d","text":"nous lavez"}]'::jsonb, 'b', 'Avec « nous », le pronom réfléchi est « nous » et le verbe prend -ons : nous nous lavons. « se lavons » prend le mauvais pronom, et les autres mélangent les formes de nous et vous.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('873ab387-21e4-54f2-8c28-d05d22080277', '9960a5f5-e58f-52f8-9567-c3c8ae17113d', 'Choisis la phrase correcte.', '[{"id":"a","text":"Ils se reposent le week-end."},{"id":"b","text":"Ils se repose le week-end."},{"id":"c","text":"Ils me reposent le week-end."},{"id":"d","text":"Ils reposent le week-end."}]'::jsonb, 'a', 'Avec « ils », le pronom est « se » et le verbe prend -ent : ils se reposent. « se repose » oublie le -ent du pluriel, « me reposent » prend le mauvais pronom, et « reposent » oublie le pronom réfléchi.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b134a227-458a-588d-b270-799e14a312db', '9960a5f5-e58f-52f8-9567-c3c8ae17113d', 'Mets à la forme négative : « Je me dépêche. »', '[{"id":"a","text":"Je me ne dépêche pas."},{"id":"b","text":"Je ne dépêche me pas."},{"id":"c","text":"Je ne me dépêche pas."},{"id":"d","text":"Je me dépêche ne pas."}]'::jsonb, 'c', 'La négation encadre le pronom et le verbe : ne + me dépêche + pas → Je ne me dépêche pas. Les autres séparent le pronom du verbe ou placent « pas » au mauvais endroit.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('717fc826-cc27-54f9-8b8d-a6afd85ff366', '9960a5f5-e58f-52f8-9567-c3c8ae17113d', 'Complète : « Comment est-ce que tu ___ ? » (s''appeler)', '[{"id":"a","text":"te appelles"},{"id":"b","text":"s''appelles"},{"id":"c","text":"t''appelle"},{"id":"d","text":"t''appelles"}]'::jsonb, 'd', '« appeler » commence par une voyelle, donc « te » s''élide en « t'' », et avec tu le verbe prend -es : tu t''appelles. « te appelles » oublie l''élision, « s''appelles » prend le mauvais pronom, et « t''appelle » oublie le -s de tu.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('62a24bca-84e3-525d-8fa1-9e76f62ff646', '9960a5f5-e58f-52f8-9567-c3c8ae17113d', 'Complète : « Le soir, vous ___ tard. » (se coucher)', '[{"id":"a","text":"vous couchez"},{"id":"b","text":"se couchez"},{"id":"c","text":"vous couchons"},{"id":"d","text":"vous couche"}]'::jsonb, 'a', 'Avec « vous », le pronom est « vous » et le verbe prend -ez : vous vous couchez. « se couchez » prend le mauvais pronom, « vous couchons » utilise la terminaison de nous, et « vous couche » oublie le -ez.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aebd793a-8c0c-505c-805e-9f824f3d1d1b', '9960a5f5-e58f-52f8-9567-c3c8ae17113d', 'Quelle phrase a une élision correcte ?', '[{"id":"a","text":"Tu se habilles vite."},{"id":"b","text":"Elle s''habille vite."},{"id":"c","text":"Elle se habille vite."},{"id":"d","text":"Je se amuse beaucoup."}]'::jsonb, 'b', 'Devant le h muet de « habiller », « se » s''élide en « s'' » : elle s''habille. « se habille » oublie l''élision, « tu se habilles » prend en plus le mauvais pronom, et « je se amuse » cumule mauvais pronom et oubli d''élision.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2f105ab6-15e4-5432-8809-0a55fec298ab', '147e3a6d-3d6e-5a25-8592-1d951f2df95e', 'francais-a2', '⚔️ Boss du chapitre ⭐⭐⭐ : les verbes pronominaux', 3, 120, 30, 'boss', 'admin', 3)
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
  ('4b23022b-5077-5168-a78e-033eb3b0c9ba', '2f105ab6-15e4-5432-8809-0a55fec298ab', 'Remets les mots dans l''ordre : (te / tu / habilles / t'' ) → choisis la phrase correcte.', '[{"id":"a","text":"Tu t''habilles."},{"id":"b","text":"Tu te habilles."},{"id":"c","text":"Tu s''habilles."},{"id":"d","text":"Te tu habilles."}]'::jsonb, 'a', 'Devant le h muet, « te » s''élide en « t'' » et le pronom reste devant le verbe : tu t''habilles. « te habilles » oublie l''élision, « s''habilles » prend le mauvais pronom, et « te tu habilles » inverse l''ordre.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('338a8c50-6126-55f7-8899-5d4d7af3582d', '2f105ab6-15e4-5432-8809-0a55fec298ab', 'Quelle phrase a un sens RÉFLÉCHI correct (le sujet agit sur lui-même) ?', '[{"id":"a","text":"Il me lave."},{"id":"b","text":"Il te lave."},{"id":"c","text":"Il se lave."},{"id":"d","text":"Il lave."}]'::jsonb, 'c', '« Il se lave » est réfléchi : il lave lui-même. « Il me lave » veut dire qu''il lave moi, « il te lave » qu''il lave toi (sens différent), et « il lave » n''a pas de pronom donc n''est pas pronominal.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1fff0c6-b2ea-51d9-8579-d989bd9b8ba5', '2f105ab6-15e4-5432-8809-0a55fec298ab', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Je me lève à sept heures."},{"id":"b","text":"Nous nous promenons le soir."},{"id":"c","text":"Vous se reposez après l''école."},{"id":"d","text":"Elles se brossent les dents."}]'::jsonb, 'c', 'L''erreur est (c) : avec « vous » le pronom réfléchi est « vous », donc on dit vous vous reposez, pas « vous se reposez ». Les phrases (a), (b) et (d) utilisent le bon pronom et la bonne terminaison.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bf1f6d7-908e-5bd7-a52b-3c4af8237538', '2f105ab6-15e4-5432-8809-0a55fec298ab', 'Mets à la forme négative : « Nous nous amusons. »', '[{"id":"a","text":"Nous nous amusons ne pas."},{"id":"b","text":"Nous nous ne amusons pas."},{"id":"c","text":"Nous ne nous amusons pas pas."},{"id":"d","text":"Nous ne nous amusons pas."}]'::jsonb, 'd', 'La négation encadre le pronom et le verbe : ne + nous amusons + pas → Nous ne nous amusons pas. Le piège courant est de placer « ne » après le pronom ou de mal poser « pas » ; ici « ne » vient avant le pronom réfléchi.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('065f0540-daa7-5c5e-aaf3-61a951b02ef7', '2f105ab6-15e4-5432-8809-0a55fec298ab', 'Choisis la phrase entièrement correcte.', '[{"id":"a","text":"Je me appelle Lina et je se lève tôt."},{"id":"b","text":"Tu t''habilles et tu te dépêches."},{"id":"c","text":"Il s''amuse mais il ne se couche pas tôt pas."},{"id":"d","text":"Nous se promenons et nous reposons."}]'::jsonb, 'b', 'Seule (b) est correcte : tu t''habilles (élision) et tu te dépêches (bon pronom + -es). (a) oublie l''élision (m''appelle) et met le mauvais pronom (je me lève), (c) double « pas », et (d) prend le mauvais pronom (nous nous) et oublie le pronom au second verbe.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ba87b9d-f3c1-5d92-ad4c-7a7ea8462b9f', '2f105ab6-15e4-5432-8809-0a55fec298ab', 'Complète : « Ils ___ très tôt parce qu''ils travaillent. » (se lever)', '[{"id":"a","text":"se lèvent"},{"id":"b","text":"se lève"},{"id":"c","text":"me lèvent"},{"id":"d","text":"se lèves"}]'::jsonb, 'a', 'Avec « ils », le pronom est « se » et le verbe prend -ent : ils se lèvent. « se lève » oublie le -ent du pluriel, « me lèvent » prend le mauvais pronom, et « se lèves » utilise la terminaison de tu.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('21200971-06e3-5525-bbec-d5716d686dc6', '147e3a6d-3d6e-5a25-8592-1d951f2df95e', 'francais-a2', '👑 Défi élite ⭐⭐⭐⭐ : les verbes pronominaux', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('7ef04cc1-c682-5aff-b990-24134e5cfcef', '21200971-06e3-5525-bbec-d5716d686dc6', 'Complète : « ___ -vous tôt le dimanche ? » (se lever, forme interrogative)', '[{"id":"a","text":"Vous levez"},{"id":"b","text":"Se levez"},{"id":"c","text":"Vous vous levez"},{"id":"d","text":"Levez-vous"}]'::jsonb, 'c', 'Avec l''intonation, on garde l''ordre du présent : Vous vous levez tôt le dimanche ? Le pronom réfléchi « vous » reste devant le verbe. « Vous levez » oublie le pronom, « Se levez » prend le mauvais pronom, et « Levez-vous » serait un ordre (impératif), pas une question.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0eada00-2e20-5dec-a5d1-75a7951a0ab9', '21200971-06e3-5525-bbec-d5716d686dc6', 'Mets à la forme négative avec élision : « Je m''amuse à la fête. »', '[{"id":"a","text":"Je ne m''amuse pas à la fête."},{"id":"b","text":"Je m''amuse ne pas à la fête."},{"id":"c","text":"Je ne me amuse pas à la fête."},{"id":"d","text":"Je n''m''amuse pas à la fête."}]'::jsonb, 'a', 'On garde l''élision « m'' » et on encadre par ne … pas : Je ne m''amuse pas. Le piège : devant « m'' » (consonne), « ne » ne s''élide pas, donc on écrit « ne m'' », pas « n''m'' » (d). (b) place mal « pas » et (c) oublie l''élision du pronom.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8df02d18-71d6-557a-b79d-d60b60ad9029', '21200971-06e3-5525-bbec-d5716d686dc6', 'Passé composé : « Hier, elle ___ rapidement. » (s''habiller)', '[{"id":"a","text":"s''est habillé"},{"id":"b","text":"a habillé"},{"id":"c","text":"est habillée"},{"id":"d","text":"s''est habillée"}]'::jsonb, 'd', 'Les pronominaux se conjuguent avec l''auxiliaire être, et le participe s''accorde avec le sujet féminin : elle s''est habillée (-e). « s''est habillé » oublie l''accord, « a habillé » prend le mauvais auxiliaire (avoir), et « est habillée » oublie le pronom réfléchi.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0531c1f-c7a3-5e50-bb64-a2f9d8b854e7', '21200971-06e3-5525-bbec-d5716d686dc6', 'Passé composé : « Ce matin, les enfants ___ très tôt. » (se réveiller)', '[{"id":"a","text":"ont réveillé"},{"id":"b","text":"se sont réveillés"},{"id":"c","text":"se sont réveillé"},{"id":"d","text":"sont réveillés"}]'::jsonb, 'b', 'Auxiliaire être + accord avec le sujet masculin pluriel : les enfants se sont réveillés (-s). « ont réveillé » prend avoir, « se sont réveillé » oublie l''accord pluriel, et « sont réveillés » oublie le pronom réfléchi « se ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('73218580-7fde-5c4a-88c9-7d552d7fc84c', '21200971-06e3-5525-bbec-d5716d686dc6', 'Choisis la phrase entièrement correcte (présent et passé mêlés).', '[{"id":"a","text":"Je me lève tôt, mais hier je me suis levé tard."},{"id":"b","text":"Je lève tôt, mais hier je me suis levé tard."},{"id":"c","text":"Je me lève tôt, mais hier j''ai levé tard."},{"id":"d","text":"Je me lève tôt, mais hier je se suis levé tard."}]'::jsonb, 'a', 'Au présent : je me lève ; au passé composé pronominal : je me suis levé (auxiliaire être). (b) oublie le pronom au présent, (c) utilise avoir et oublie le pronom au passé, et (d) met le mauvais pronom (« je se suis »).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('abbcc5ed-8e97-5b55-b76e-83f76dbd71a6', '21200971-06e3-5525-bbec-d5716d686dc6', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Nous nous sommes promenés au parc."},{"id":"b","text":"Tu t''es couché trop tard hier."},{"id":"c","text":"Ils se sont dépêchés pour le bus."},{"id":"d","text":"Elle s''est reposé tout l''après-midi."}]'::jsonb, 'd', 'L''erreur est (c) : avec un sujet féminin, le participe s''accorde, donc elle s''est reposée (-e). Les autres sont corrects : nous nous sommes promenés, tu t''es couché, ils se sont dépêchés — tous avec être et l''accord juste.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9bf3a6b5-e6e7-52ed-8c23-cf15f0356ef1', '147e3a6d-3d6e-5a25-8592-1d951f2df95e', 'francais-a2', '⭐⭐ Drill : les verbes pronominaux', 2, 75, 15, 'practice', 'admin', 5)
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
  ('70001201-93ba-58ac-acb5-04122829a7ff', '9bf3a6b5-e6e7-52ed-8c23-cf15f0356ef1', 'Complète : « Je ___ après une longue journée. » (se reposer)', '[{"id":"a","text":"se repose"},{"id":"b","text":"me repose"},{"id":"c","text":"te repose"},{"id":"d","text":"me reposes"}]'::jsonb, 'b', 'Avec « je », le pronom est « me » et le verbe prend -e : je me repose. « se repose » est pour il/elle, « te repose » est pour tu, et « me reposes » ajoute un -s qui n''existe pas à la première personne.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('258fefd1-8ee2-5fa7-8b6a-74ddf8a04dd8', '9bf3a6b5-e6e7-52ed-8c23-cf15f0356ef1', 'Choisis la phrase correcte.', '[{"id":"a","text":"Elles se promènent au bord de la mer."},{"id":"b","text":"Elles se promène au bord de la mer."},{"id":"c","text":"Elles te promènent au bord de la mer."},{"id":"d","text":"Elles promènent au bord de la mer."}]'::jsonb, 'a', 'Avec « elles », le pronom est « se » et le verbe prend -ent : elles se promènent. « se promène » oublie le pluriel, « te promènent » prend le mauvais pronom, et « promènent » oublie le pronom réfléchi.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c464a1b-b232-53af-8a98-4e6d4f0177c0', '9bf3a6b5-e6e7-52ed-8c23-cf15f0356ef1', 'Complète avec élision : « Mon frère ___ Karim. » (s''appeler)', '[{"id":"a","text":"se appelle"},{"id":"b","text":"s''appellent"},{"id":"c","text":"s''appelle"},{"id":"d","text":"t''appelle"}]'::jsonb, 'c', '« mon frère » = il, donc « se » s''élide en « s'' » devant la voyelle : il s''appelle. « se appelle » oublie l''élision, « s''appellent » est au pluriel, et « t''appelle » est pour tu.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9673b149-9de2-57d8-ae59-b8b191ac8b4d', '9bf3a6b5-e6e7-52ed-8c23-cf15f0356ef1', 'Mets à la forme négative : « Vous vous couchez tard. »', '[{"id":"a","text":"Vous vous ne couchez pas tard."},{"id":"b","text":"Vous ne vous couchez pas tard."},{"id":"c","text":"Vous ne couchez vous pas tard."},{"id":"d","text":"Vous vous couchez ne pas tard."}]'::jsonb, 'b', 'La négation encadre le pronom et le verbe : ne + vous couchez + pas → Vous ne vous couchez pas tard. « ne » se place avant le pronom réfléchi ; les autres séparent mal le pronom ou placent « pas » au mauvais endroit.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e46a90a8-dacd-5176-8576-1aa9944e36e4', '9bf3a6b5-e6e7-52ed-8c23-cf15f0356ef1', 'Complète : « Le matin, nous ___ les dents ensemble. » (se brosser)', '[{"id":"a","text":"se brossons"},{"id":"b","text":"nous brossez"},{"id":"c","text":"vous brossons"},{"id":"d","text":"nous brossons"}]'::jsonb, 'd', 'Avec « nous », le pronom réfléchi est « nous » et le verbe prend -ons : nous nous brossons. « se brossons » prend le mauvais pronom, et les autres mélangent les terminaisons de nous et vous.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('96fa8acd-1bda-5213-ab3d-5e755bf3d1ff', '9bf3a6b5-e6e7-52ed-8c23-cf15f0356ef1', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Tu te dépêches le matin."},{"id":"b","text":"Il s''habille avant de partir."},{"id":"c","text":"Je me amuse pendant les vacances."},{"id":"d","text":"Elles se reposent le dimanche."}]'::jsonb, 'c', 'L''erreur est (c) : devant la voyelle de « amuse », « me » doit s''élider en « m'' » → je m''amuse. Les autres sont correctes : tu te dépêches, il s''habille (h muet), elles se reposent.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('215059d2-4e88-5b7b-ad00-6d16e78e01a4', 'ec5ed2f8-770d-57f7-aab4-8c1d66902308', 'francais-a2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('5d601974-fbb4-5f5b-93b2-4484063ed207', '215059d2-4e88-5b7b-ad00-6d16e78e01a4', 'Complète : « Paul est ___ Marie ; il mesure dix centimètres de plus. »', '[{"id":"a","text":"plus grand que"},{"id":"b","text":"plus grand de"},{"id":"c","text":"le plus grand"},{"id":"d","text":"plus de grand que"}]'::jsonb, 'a', 'Le comparatif de supériorité d''un adjectif se construit avec « plus … que » : plus grand que Marie. « de » au lieu de « que » est incorrect dans une comparaison, « le plus grand » est le superlatif (tout un groupe), et « plus de » sert à comparer une quantité (un nom), pas une qualité.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c123b5ef-92a8-5e08-b606-dd690458801d', '215059d2-4e88-5b7b-ad00-6d16e78e01a4', 'Complète : « Elle court ___ toi : vous arrivez en même temps. »', '[{"id":"a","text":"plus vite que"},{"id":"b","text":"aussi vite que"},{"id":"c","text":"aussi vite de"},{"id":"d","text":"autant vite que"}]'::jsonb, 'b', 'Pour exprimer l''égalité avec un adverbe, on emploie « aussi … que » : aussi vite que toi. « plus vite que » marque la supériorité (ici on dit qu''ils sont égaux), « de » ne s''emploie pas dans la comparaison, et « autant » s''utilise avec un nom (autant de), pas avec un adverbe.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27a10274-00a4-5cb4-bc7a-2f9bebde4daf', '215059d2-4e88-5b7b-ad00-6d16e78e01a4', 'Complète : « J''ai ___ toi : regarde, ma bibliothèque est plus remplie. »', '[{"id":"a","text":"plus livres que"},{"id":"b","text":"plus que livres de"},{"id":"c","text":"plus de livres que"},{"id":"d","text":"plus grand de livres"}]'::jsonb, 'c', 'Pour comparer une quantité (un nom), on utilise « plus de + nom … que » : plus de livres que toi. « plus livres que » oublie le « de » obligatoire devant le nom, et les autres formes mélangent l''ordre des mots ou un adjectif là où il faut un nom.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c74fe1f7-ad92-5228-aa0c-1ba004c65b4d', '215059d2-4e88-5b7b-ad00-6d16e78e01a4', 'Complète : « C''est ___ ville du pays : huit millions d''habitants. »', '[{"id":"a","text":"plus grande"},{"id":"b","text":"la plus grande"},{"id":"c","text":"le plus grand"},{"id":"d","text":"la plus grande que"}]'::jsonb, 'b', 'Le superlatif désigne le sommet d''un groupe avec un article défini accordé : la plus grande ville (ville est féminin). « plus grande » sans article n''est qu''un comparatif incomplet, « le plus grand » ne s''accorde pas au féminin, et le superlatif n''emploie pas « que » mais « de » (du pays).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('93acbbcf-981b-55f8-b31b-fe3d11a7ff86', '215059d2-4e88-5b7b-ad00-6d16e78e01a4', 'Complète : « Cette potion est ___ l''autre : elle soigne mieux. »', '[{"id":"a","text":"plus bonne que"},{"id":"b","text":"plus bien que"},{"id":"c","text":"mieux que"},{"id":"d","text":"meilleure que"}]'::jsonb, 'd', '« Bon » est irrégulier : son comparatif est « meilleur », accordé au féminin meilleure que l''autre (potion est féminin). « plus bonne » est interdit (on ne dit jamais « plus bon »), « plus bien » n''existe pas, et « mieux » est le comparatif de l''adverbe « bien », pas de l''adjectif « bon ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('218a2e71-5684-58e4-882b-051f86393211', 'ec5ed2f8-770d-57f7-aab4-8c1d66902308', 'francais-a2', '⭐ Entraînement : comparatif et superlatif', 1, 50, 10, 'practice', 'admin', 1)
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
  ('7a8d3829-ca21-55de-81bc-78aba7695191', '218a2e71-5684-58e4-882b-051f86393211', 'Complète : « Le guépard est ___ le lion à la course. »', '[{"id":"a","text":"plus rapide que"},{"id":"b","text":"plus rapide de"},{"id":"c","text":"le plus rapide"},{"id":"d","text":"plus de rapide que"}]'::jsonb, 'a', 'Le comparatif de supériorité d''un adjectif se forme avec « plus … que » : plus rapide que le lion. « de » ne s''emploie pas dans la comparaison, « le plus rapide » est le superlatif (tout un groupe), et « plus de » sert à comparer une quantité (un nom).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('56cea120-2f30-569f-a5d8-983c3ac1cd37', '218a2e71-5684-58e4-882b-051f86393211', 'Complète : « Mon sac est ___ le tien : le tien pèse vraiment plus lourd. »', '[{"id":"a","text":"plus lourd que"},{"id":"b","text":"aussi lourd que"},{"id":"c","text":"moins lourd de"},{"id":"d","text":"moins lourd que"}]'::jsonb, 'd', 'Comme le tien pèse plus, mon sac pèse moins : on utilise le comparatif d''infériorité « moins … que » : moins lourd que le tien. « plus lourd » et « aussi lourd » contredisent le sens, et « de » ne remplace pas « que » dans une comparaison.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('81a1110f-8eb7-5e0f-951a-6df4422d9f7b', '218a2e71-5684-58e4-882b-051f86393211', 'Complète : « Léa et Sara ont le même âge : Léa est ___ Sara. »', '[{"id":"a","text":"plus âgée que"},{"id":"b","text":"aussi âgée que"},{"id":"c","text":"aussi âgée de"},{"id":"d","text":"autant âgée que"}]'::jsonb, 'b', 'Pour l''égalité d''une qualité, on emploie « aussi … que » : aussi âgée que Sara. « plus âgée » marquerait la supériorité, « de » ne s''utilise pas dans la comparaison, et « autant » se réserve aux quantités (autant de), pas aux adjectifs.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e7c15a0-1fdf-5d38-9fa0-7a18cea0d4de', '218a2e71-5684-58e4-882b-051f86393211', 'Complète : « C''est ___ élève de la classe : il a la meilleure moyenne. »', '[{"id":"a","text":"plus fort"},{"id":"b","text":"le plus fort que"},{"id":"c","text":"plus de fort"},{"id":"d","text":"le plus fort"}]'::jsonb, 'd', 'Le superlatif marque le sommet d''un groupe avec l''article défini : le plus fort élève de la classe. « plus fort » sans article n''est qu''un comparatif incomplet, le superlatif n''emploie pas « que » (mais « de »), et « plus de » sert pour une quantité.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('597d45ac-c7ae-5081-8321-77fb0c5d02ee', '218a2e71-5684-58e4-882b-051f86393211', 'Complète : « Aujourd''hui je me sens ___ qu''hier : je suis en pleine forme. »', '[{"id":"a","text":"plus bien"},{"id":"b","text":"plus bon"},{"id":"c","text":"mieux"},{"id":"d","text":"meilleur"}]'::jsonb, 'c', '« Bien » est irrégulier : son comparatif est « mieux » : je me sens mieux qu''hier. On ne dit jamais « plus bien » ni « plus bon », et « meilleur » est le comparatif de l''adjectif « bon », pas celui de l''adverbe « bien ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c54cd258-b7aa-5321-bf01-7336a9ef3f38', '218a2e71-5684-58e4-882b-051f86393211', 'Complète : « J''ai ___ pièces d''or ___ toi : on en a exactement dix chacun. »', '[{"id":"a","text":"plus de … que"},{"id":"b","text":"autant de … que"},{"id":"c","text":"autant … que"},{"id":"d","text":"aussi de … que"}]'::jsonb, 'b', 'On compare ici une quantité égale (un nom), donc « autant de + nom … que » : autant de pièces que toi. « plus de » marquerait la supériorité, « autant … que » sans « de » oublie le mot obligatoire devant le nom, et « aussi de » n''existe pas.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('469b75ba-60ef-5d55-ba38-5c6da7f90ad6', 'ec5ed2f8-770d-57f7-aab4-8c1d66902308', 'francais-a2', '⭐⭐ Révision : comparatif et superlatif', 2, 75, 15, 'practice', 'admin', 2)
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
  ('8d436275-ba32-5a2e-bab3-3f7bf1a6c4a1', '469b75ba-60ef-5d55-ba38-5c6da7f90ad6', 'Complète : « Cette tour est ___ château : elle est la plus haute de la région. »', '[{"id":"a","text":"la plus haute du"},{"id":"b","text":"plus haute que le"},{"id":"c","text":"le plus haut du"},{"id":"d","text":"la plus haute que le"}]'::jsonb, 'a', 'Le superlatif s''accorde avec le nom (tour, féminin) et se complète par « de » : la plus haute du château. « le plus haut » ne s''accorde pas au féminin, et le superlatif n''emploie pas « que » mais « de ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d149e620-56bc-562d-b0e0-1d30b1c5d2f4', '469b75ba-60ef-5d55-ba38-5c6da7f90ad6', 'Trouve la phrase CORRECTE.', '[{"id":"a","text":"Cette épée est plus bonne que l''autre."},{"id":"b","text":"Cette épée est meilleure que l''autre."},{"id":"c","text":"Cette épée est plus meilleure que l''autre."},{"id":"d","text":"Cette épée est mieux que l''autre."}]'::jsonb, 'b', '« Bon » étant irrégulier, son comparatif est « meilleur », accordé au féminin : meilleure que l''autre. « plus bonne » et « plus meilleure » doublent ou inventent une marque interdite, et « mieux » est le comparatif de l''adverbe « bien », pas de l''adjectif « bon ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9fd9d5d-8437-5c0d-894c-d8a898d661d3', '469b75ba-60ef-5d55-ba38-5c6da7f90ad6', 'Complète : « Il y a ___ joueurs ___ dans l''autre équipe : nous sommes onze, eux aussi. »', '[{"id":"a","text":"plus de … que"},{"id":"b","text":"autant … que"},{"id":"c","text":"aussi de … que"},{"id":"d","text":"autant de … que"}]'::jsonb, 'd', 'Comparer une quantité égale de joueurs (un nom) demande « autant de … que » : autant de joueurs que dans l''autre équipe. « plus de » marque la supériorité, « autant … que » oublie le « de » devant le nom, et « aussi de » n''existe pas.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f94fd050-9ecb-57e4-91bb-c46bda672d41', '469b75ba-60ef-5d55-ba38-5c6da7f90ad6', 'Complète : « De tous les boucliers, c''est ___ : il ne coûte presque rien. »', '[{"id":"a","text":"moins cher"},{"id":"b","text":"le moins cher que"},{"id":"c","text":"moins de cher"},{"id":"d","text":"le moins cher"}]'::jsonb, 'd', 'Le superlatif d''infériorité prend l''article défini : le moins cher de tous. « moins cher » seul n''est qu''un comparatif, le superlatif n''emploie pas « que », et « moins de » s''utilise devant un nom pour une quantité, pas devant un adjectif.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9aa5d739-114b-5528-a464-e2155ed57d3f', '469b75ba-60ef-5d55-ba38-5c6da7f90ad6', 'Complète : « Mon frère dessine ___ moi : ses dessins sont superbes. »', '[{"id":"a","text":"plus bien que"},{"id":"b","text":"meilleur que"},{"id":"c","text":"mieux que"},{"id":"d","text":"plus mieux que"}]'::jsonb, 'c', '« Dessiner » est modifié par un adverbe ; le comparatif de « bien » est « mieux » : il dessine mieux que moi. « plus bien » et « plus mieux » sont interdits, et « meilleur » est l''adjectif (il qualifie un nom, pas un verbe).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78b032e0-a898-5438-8f53-845b887c61fc', '469b75ba-60ef-5d55-ba38-5c6da7f90ad6', 'Complète : « Le nouveau cinéma n''est pas ___ grand ___ l''ancien : l''ancien avait plus de places. »', '[{"id":"a","text":"plus … que"},{"id":"b","text":"aussi … que"},{"id":"c","text":"aussi … de"},{"id":"d","text":"autant … que"}]'::jsonb, 'b', 'Pour dire que deux choses ne sont pas égales, on emploie « pas aussi … que » : pas aussi grand que l''ancien. « plus … que » ne suit pas naturellement la négation ici, « de » ne remplace pas « que », et « autant » se réserve aux quantités (un nom).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fcd7cf4a-baf0-570f-a708-772e4cdc6cdc', 'ec5ed2f8-770d-57f7-aab4-8c1d66902308', 'francais-a2', '⚔️ Boss du chapitre ⭐⭐⭐ : comparatif et superlatif', 3, 120, 30, 'boss', 'admin', 3)
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
  ('f8dfa9b9-dcaf-50aa-80dd-fd176fc080da', 'fcd7cf4a-baf0-570f-a708-772e4cdc6cdc', 'Complète : « C''est ___ joueuse ___ tournoi : personne ne la bat. »', '[{"id":"a","text":"la meilleure … du"},{"id":"b","text":"le meilleur … du"},{"id":"c","text":"la plus bonne … du"},{"id":"d","text":"la meilleure … que le"}]'::jsonb, 'a', 'Le superlatif de « bon » est « le/la meilleur(e) », accordé au féminin et complété par « de » : la meilleure joueuse du tournoi. « le meilleur » ne s''accorde pas au féminin, « la plus bonne » est interdit (jamais « plus bon »), et le superlatif n''emploie pas « que » mais « de ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cefd0920-3153-5867-9da6-60f6c491bfd5', 'fcd7cf4a-baf0-570f-a708-772e4cdc6cdc', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Elle a plus de courage que son frère."},{"id":"b","text":"Ce livre est moins cher que l''autre."},{"id":"c","text":"Il chante mieux que toi."},{"id":"d","text":"Cette route est plus longue de l''autre."}]'::jsonb, 'd', 'L''erreur est en (d) : le comparatif se construit avec « que », pas « de » ; il faut plus longue que l''autre. (a) compare une quantité avec « plus de … que », (b) utilise « moins … que », et (c) emploie correctement « mieux » (comparatif de « bien ») : ces trois phrases sont justes.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5d509dbe-8f0c-5966-9a1d-03b2e3eb49c5', 'fcd7cf4a-baf0-570f-a708-772e4cdc6cdc', 'Remets les mots dans l''ordre : (la / ville / du / c''est / plus / pays / animée)', '[{"id":"a","text":"C''est la ville plus animée du pays."},{"id":"b","text":"C''est la plus animée ville du pays."},{"id":"c","text":"C''est la ville la plus animée du pays."},{"id":"d","text":"C''est la plus ville animée du pays."}]'::jsonb, 'c', 'Quand l''adjectif suit le nom, le superlatif répète l''article : la ville la plus animée du pays. « la ville plus animée » oublie le second article, et placer « plus animée » avant le nom est ici incorrect avec cet adjectif qui se met après le nom.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7535a1dc-07f0-5d0e-8830-d67d34227111', 'fcd7cf4a-baf0-570f-a708-772e4cdc6cdc', 'Complète : « J''ai ___ devoirs ___ ma sœur, mais je travaille ___ elle, donc je finis avant. »', '[{"id":"a","text":"autant de … que … plus vite que"},{"id":"b","text":"autant … que … plus vite que"},{"id":"c","text":"aussi de … que … plus vite de"},{"id":"d","text":"autant de … que … aussi vite que"}]'::jsonb, 'a', 'Quantité égale de devoirs (nom) : « autant de … que » ; rapidité supérieure (adverbe) : « plus vite que ». Donc autant de devoirs que ma sœur … plus vite qu''elle. « autant … que » oublie le « de » devant le nom, « aussi vite que » marquerait l''égalité (or je finis avant), et « de » ne remplace pas « que ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9fabb966-2535-5e0b-bd36-f39f0dbc9dfc', 'fcd7cf4a-baf0-570f-a708-772e4cdc6cdc', 'Trouve la phrase CORRECTE.', '[{"id":"a","text":"C''est la plus bonne idée de la journée."},{"id":"b","text":"C''est la meilleure idée de la journée."},{"id":"c","text":"C''est la plus meilleure idée de la journée."},{"id":"d","text":"C''est le meilleur idée de la journée."}]'::jsonb, 'b', 'Le superlatif de « bon » est « le/la meilleur(e) », accordé au féminin : la meilleure idée. « la plus bonne » et « la plus meilleure » sont interdits (jamais « plus bon » ni « plus meilleur »), et « le meilleur » ne s''accorde pas avec « idée », qui est féminin.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c51717e-a333-5d69-b586-7bab5e6ae06f', 'fcd7cf4a-baf0-570f-a708-772e4cdc6cdc', 'Complète : « Cette équipe joue ___ que la nôtre, mais elle marque ___ buts ___ nous. »', '[{"id":"a","text":"meilleur … moins de … que"},{"id":"b","text":"mieux … moins … que"},{"id":"c","text":"mieux … moins de … que"},{"id":"d","text":"plus bien … moins de … de"}]'::jsonb, 'c', '« Jouer » prend l''adverbe « mieux » (comparatif de « bien ») ; pour la quantité de buts (nom), c''est « moins de … que » : joue mieux … moins de buts que nous. « meilleur » est l''adjectif, « moins … que » oublie le « de » devant le nom, et « plus bien » est interdit comme « de » à la place de « que ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bfd67d1e-1307-5a61-99b4-7921894d58b2', 'ec5ed2f8-770d-57f7-aab4-8c1d66902308', 'francais-a2', '👑 Défi élite ⭐⭐⭐⭐ : comparatif et superlatif', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('c907230d-c700-587e-baed-2ec96c9c4814', 'bfd67d1e-1307-5a61-99b4-7921894d58b2', 'Trouve la phrase entièrement CORRECTE.', '[{"id":"a","text":"C''est la plus bonne élève, et c''est elle qui travaille le plus bien."},{"id":"b","text":"C''est la mieux élève, et c''est elle qui travaille la meilleure."},{"id":"c","text":"C''est la meilleure élève, et c''est elle qui travaille le mieux de la classe."},{"id":"d","text":"C''est la meilleure élève, et c''est elle qui travaille le meilleur."}]'::jsonb, 'c', 'Pour l''adjectif (élève), le superlatif de « bon » est « la meilleure » ; pour le verbe travailler (adverbe), le superlatif de « bien » est « le mieux ». Seule (c) respecte les deux. (a) emploie « plus bonne / plus bien » (interdits), (b) et (d) confondent « mieux » (adverbe) et « meilleur » (adjectif).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31ee1abf-9c84-5e12-9d43-5b4488c5717f', 'bfd67d1e-1307-5a61-99b4-7921894d58b2', 'Complète : « Plus on monte, ___ il fait froid ; c''est le sommet ___ froid ___ massif. »', '[{"id":"a","text":"plus … le plus … du"},{"id":"b","text":"plus … plus … que le"},{"id":"c","text":"le plus … le plus … de le"},{"id":"d","text":"plus … le plus … que le"}]'::jsonb, 'a', 'La structure « plus … plus … » exprime une progression parallèle (plus on monte, plus il fait froid) ; ensuite le superlatif prend l''article et « de » : le sommet le plus froid du massif. « que » est faux après un superlatif, et « de le » se contracte obligatoirement en « du ».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('963596d0-05df-5197-96c0-f60c4e729d07', 'bfd67d1e-1307-5a61-99b4-7921894d58b2', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Elle a autant de patience que de talent."},{"id":"b","text":"Il a plus de force que moi, mais moins d''agilité."},{"id":"c","text":"Ce vin est meilleur que celui d''hier."},{"id":"d","text":"Ce gâteau est plus bon que le précédent."}]'::jsonb, 'd', 'L''erreur est en (d) : « bon » ne se compare jamais avec « plus » ; il faut meilleur que le précédent. (a) et (b) comparent des quantités avec « autant de / plus de / moins de … que », et (c) emploie correctement « meilleur » : ces phrases sont justes.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('696d9881-2902-5b0f-a728-7cb899f9bffd', 'bfd67d1e-1307-5a61-99b4-7921894d58b2', 'Complète : « De toutes les épreuves, ce donjon est ___ ; mais la salle finale est ___ partie ___ tout le jeu. »', '[{"id":"a","text":"le plus difficile … le plus dur … de"},{"id":"b","text":"le plus difficile … la plus dure … de"},{"id":"c","text":"le plus difficile … la plus dure … que"},{"id":"d","text":"plus difficile … plus dure … de"}]'::jsonb, 'b', 'Deux superlatifs : « le plus difficile » (donjon, masculin) et « la plus dure » (partie, féminin), tous deux complétés par « de » : la plus dure partie de tout le jeu. (c) emploie « que » (faux après un superlatif), (d) oublie l''article du superlatif, et (a) n''accorde pas « le plus dur » au féminin.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('daaa9758-d5cd-5b6e-89e9-d0310e6c36f0', 'bfd67d1e-1307-5a61-99b4-7921894d58b2', 'Remets les mots dans l''ordre : (de / élèves / la / a / classe / elle / le / moins / d''absences)', '[{"id":"a","text":"Elle a moins le d''absences de la classe."},{"id":"b","text":"Elle a le moins absences de la classe."},{"id":"c","text":"Elle a la moins d''absences de la classe."},{"id":"d","text":"Elle a le moins d''absences de la classe."}]'::jsonb, 'd', 'Le superlatif d''une quantité (un nom) se forme avec « le moins de + nom » + « de » : le moins d''absences de la classe. « le » reste invariable devant « moins de » (pas « la moins »), « le moins absences » oublie le « de » obligatoire, et « moins le » inverse l''ordre.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('22581f3f-2185-59a6-89c4-4008d4c508a0', 'bfd67d1e-1307-5a61-99b4-7921894d58b2', 'Complète : « Ce héros est ___ courageux ___ son maître, mais il combat ___ : il a encore beaucoup à apprendre. »', '[{"id":"a","text":"aussi … que … plus mal"},{"id":"b","text":"autant … que … moins bien"},{"id":"c","text":"aussi … que … moins bien"},{"id":"d","text":"aussi … de … pire"}]'::jsonb, 'c', 'Égalité d''une qualité : « aussi courageux que son maître » ; infériorité de la manière (adverbe « bien ») : « moins bien ». « autant » se réserve aux quantités (nom), « plus mal » change le sens attendu, « de » ne remplace pas « que », et « pire » est le comparatif de l''adjectif « mauvais », pas de l''adverbe « bien ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ef7d9053-a028-5e9f-a21b-4391791ba960', 'ec5ed2f8-770d-57f7-aab4-8c1d66902308', 'francais-a2', '⭐⭐ Drill : comparatif et superlatif', 2, 75, 15, 'practice', 'admin', 5)
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
  ('652ca3ab-de82-5be8-8d06-fa7477a4b5bb', 'ef7d9053-a028-5e9f-a21b-4391791ba960', 'Complète : « En hiver, les jours sont ___ qu''en été : il fait nuit très tôt. »', '[{"id":"a","text":"plus court"},{"id":"b","text":"plus courts"},{"id":"c","text":"les plus courts"},{"id":"d","text":"plus de courts"}]'::jsonb, 'b', 'Le comparatif d''un adjectif s''accorde avec le nom : « les jours » est masculin pluriel, donc plus courts qu''en été. « plus court » ne s''accorde pas, « les plus courts » est le superlatif, et « plus de » s''emploie pour une quantité (un nom).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('094ccb96-1cc4-5ec1-8580-b4c7037508b6', 'ef7d9053-a028-5e9f-a21b-4391791ba960', 'Complète : « Cette région reçoit ___ pluie ___ le désert : il y pleut sans cesse. »', '[{"id":"a","text":"plus de … que"},{"id":"b","text":"plus … que"},{"id":"c","text":"plus que … de"},{"id":"d","text":"autant de … que"}]'::jsonb, 'a', 'On compare une quantité (pluie, un nom) avec « plus de … que » : plus de pluie que le désert. « plus … que » conviendrait à un adjectif, pas à un nom ; « autant de » marquerait l''égalité (or il y pleut plus) ; et « plus que … de » inverse l''ordre.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2b258f51-070e-5e52-b550-d070972e0f2d', 'ef7d9053-a028-5e9f-a21b-4391791ba960', 'Trouve la phrase CORRECTE.', '[{"id":"a","text":"Le métro est plus rapide de le bus."},{"id":"b","text":"Le métro est plus rapide que le bus."},{"id":"c","text":"Le métro est le plus rapide que le bus."},{"id":"d","text":"Le métro est plus de rapide que le bus."}]'::jsonb, 'b', 'Le comparatif de supériorité se construit « plus … que » : plus rapide que le bus. « de » ne remplace pas « que », « le plus rapide » est un superlatif (qui n''emploie pas « que »), et « plus de » se met devant un nom, pas devant un adjectif.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7869ed0e-3c20-5b5e-ae13-ae8881ad9f49', 'ef7d9053-a028-5e9f-a21b-4391791ba960', 'Complète : « De toute la boutique, ce sont ___ articles : ils valent une fortune. »', '[{"id":"a","text":"le plus cher"},{"id":"b","text":"plus chers"},{"id":"c","text":"les plus chers que"},{"id":"d","text":"les plus chers"}]'::jsonb, 'd', 'Le superlatif s''accorde avec le nom : « articles » est masculin pluriel, donc les plus chers. « le plus cher » est au singulier, « plus chers » sans article n''est qu''un comparatif, et le superlatif n''emploie pas « que » mais « de ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a26f9f06-87e2-5c1b-9bbc-1cd655493c41', 'ef7d9053-a028-5e9f-a21b-4391791ba960', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Ma cuisine est meilleure que celle du restaurant."},{"id":"b","text":"Tu cuisines mieux que moi."},{"id":"c","text":"Ce plat est plus bon que l''autre."},{"id":"d","text":"Elle a autant de recettes que sa grand-mère."}]'::jsonb, 'c', 'L''erreur est en (c) : « bon » ne se compare jamais avec « plus » ; il faut meilleur que l''autre. (a) emploie « meilleure » (adjectif), (b) « mieux » (adverbe), et (d) « autant de … que » (quantité) : ces phrases sont correctes.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8d1a1b0f-c393-551a-b8b7-143f198960d3', 'ef7d9053-a028-5e9f-a21b-4391791ba960', 'Complète : « Le second tome m''a plu, mais le premier reste ___ : c''est mon préféré de la saga. »', '[{"id":"a","text":"le meilleur"},{"id":"b","text":"le plus bon"},{"id":"c","text":"le mieux"},{"id":"d","text":"meilleur"}]'::jsonb, 'a', 'Le superlatif de l''adjectif « bon » est « le meilleur » : le premier reste le meilleur de la saga. « le plus bon » est interdit, « le mieux » est le superlatif de l''adverbe « bien » (pour un verbe), et « meilleur » sans article n''est qu''un comparatif.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1ca775db-a583-5534-8c1c-879f5643e335', '33a75aa3-935a-5d73-98e8-9184127c935a', 'francais-a2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('e341f48c-94bf-5c69-926a-36fc18b5a1ad', '1ca775db-a583-5534-8c1c-879f5643e335', 'Complète : « Les clés sont ___ le tiroir. »', '[{"id":"a","text":"sur"},{"id":"b","text":"à"},{"id":"c","text":"dans"},{"id":"d","text":"chez"}]'::jsonb, 'c', 'On emploie « dans » pour un espace fermé : les clés sont dans le tiroir. « sur » indiquerait une surface (sur le tiroir), « à » marque un lieu précis sans idée d''intérieur, et « chez » s''emploie uniquement avec une personne.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa38bff9-0571-50a4-b9d7-309ad0fde2e9', '1ca775db-a583-5534-8c1c-879f5643e335', 'Complète : « Cet été, je voyage ___ Italie. »', '[{"id":"a","text":"à"},{"id":"b","text":"en"},{"id":"c","text":"au"},{"id":"d","text":"à la"}]'::jsonb, 'b', 'Devant un pays féminin, on utilise « en » : en Italie. « à » s''emploie pour les villes (à Rome), « au » pour les pays masculins (au Maroc), et « à la » ne s''emploie jamais devant un nom de pays.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d49a679f-2c3e-5ab1-af7c-d2ce07075a2d', '1ca775db-a583-5534-8c1c-879f5643e335', 'Complète : « Le film commence ___ 20 h. »', '[{"id":"a","text":"à"},{"id":"b","text":"en"},{"id":"c","text":"dans"},{"id":"d","text":"depuis"}]'::jsonb, 'a', 'On indique une heure précise avec « à » : à 20 h. « en » s''emploie pour une année ou une saison (en 2024, en été), « dans » pour un moment futur (dans une heure), et « depuis » pour une durée encore en cours.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2637230c-e82a-5db0-b757-a98277fbde07', '1ca775db-a583-5534-8c1c-879f5643e335', 'Complète : « J''attends le bus ___ dix minutes. »', '[{"id":"a","text":"dans"},{"id":"b","text":"il y a"},{"id":"c","text":"en"},{"id":"d","text":"depuis"}]'::jsonb, 'd', 'L''action continue jusqu''à maintenant, donc on emploie « depuis » : j''attends depuis dix minutes (et j''attends encore). « dans » annonce un moment futur, « il y a » désigne un point fini dans le passé, et « en » indique une année ou une saison.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d9b3952e-516a-500f-a52b-22935730f013', '1ca775db-a583-5534-8c1c-879f5643e335', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Je vais chez le dentiste demain."},{"id":"b","text":"Il habite au Canada depuis 2019."},{"id":"c","text":"Nous allons à la France cet hiver."},{"id":"d","text":"Le chat est sous la chaise."}]'::jsonb, 'c', 'L''erreur est en (c) : devant un pays féminin, on dit « en France », jamais « à la France ». Les autres phrases sont correctes : « chez » + personne, « au » + pays masculin (Canada), et « sous » pour la position en dessous.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('69d10357-9c0a-5ad3-9c46-d9900b4a7b2d', '33a75aa3-935a-5d73-98e8-9184127c935a', 'francais-a2', '⭐ Entraînement : prépositions de lieu et de temps', 1, 50, 10, 'practice', 'admin', 1)
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
  ('95049d19-d751-5d5e-8dcc-d187e1ae08b1', '69d10357-9c0a-5ad3-9c46-d9900b4a7b2d', 'Complète : « Le livre est ___ la table. »', '[{"id":"a","text":"dans"},{"id":"b","text":"à"},{"id":"c","text":"sur"},{"id":"d","text":"chez"}]'::jsonb, 'c', 'On emploie « sur » pour une surface : le livre est sur la table. « dans » signifierait à l''intérieur, « à » marque un lieu précis sans idée de surface, et « chez » ne s''emploie qu''avec une personne.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8fed06cd-e5b6-5c66-98ea-fc45d977a75d', '69d10357-9c0a-5ad3-9c46-d9900b4a7b2d', 'Complète : « Ce week-end, je vais ___ Tunis. »', '[{"id":"a","text":"en"},{"id":"b","text":"à"},{"id":"c","text":"au"},{"id":"d","text":"dans"}]'::jsonb, 'b', 'Devant un nom de ville, on utilise « à » : à Tunis. « en » s''emploie pour les pays féminins (en France), « au » pour les pays masculins (au Maroc), et « dans » indique un espace fermé, pas une ville.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1a8900b8-8df6-526e-8eee-a4fb951ec2c7', '69d10357-9c0a-5ad3-9c46-d9900b4a7b2d', 'Complète : « Le train part ___ midi. »', '[{"id":"a","text":"à"},{"id":"b","text":"en"},{"id":"c","text":"dans"},{"id":"d","text":"sur"}]'::jsonb, 'a', 'On indique une heure précise avec « à » : à midi. « en » s''emploie pour une année ou une saison, « dans » pour un moment futur (dans une heure), et « sur » est une préposition de lieu, pas de temps.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ce33e7d-442e-5eb4-a68c-21e29c647b3a', '69d10357-9c0a-5ad3-9c46-d9900b4a7b2d', 'Complète : « Mon frère habite ___ Maroc. »', '[{"id":"a","text":"en"},{"id":"b","text":"à"},{"id":"c","text":"aux"},{"id":"d","text":"au"}]'::jsonb, 'd', 'Le Maroc est un pays masculin, donc on emploie « au » : au Maroc. « en » s''utilise pour les pays féminins, « à » pour les villes, et « aux » seulement pour les pays au pluriel (aux États-Unis).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9340a33-2632-5787-8b01-a82f3379c69f', '69d10357-9c0a-5ad3-9c46-d9900b4a7b2d', 'Complète : « Le chien dort ___ le canapé. »', '[{"id":"a","text":"chez"},{"id":"b","text":"sous"},{"id":"c","text":"en"},{"id":"d","text":"à"}]'::jsonb, 'b', '« sous » indique la position en dessous : le chien dort sous le canapé. « chez » s''emploie avec une personne, « en » devant un pays ou une saison, et « à » marque un lieu précis, sans idée de « en dessous ».', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e943a2e-96ac-5a36-b9b0-e18c67a5227e', '69d10357-9c0a-5ad3-9c46-d9900b4a7b2d', 'Complète : « J''ai rendez-vous ___ le coiffeur cet après-midi. »', '[{"id":"a","text":"chez"},{"id":"b","text":"à"},{"id":"c","text":"dans"},{"id":"d","text":"en"}]'::jsonb, 'a', 'On emploie « chez » devant une personne ou un métier : chez le coiffeur. « à » s''emploierait devant un lieu (à la pharmacie), « dans » devant un espace fermé, et « en » devant un pays ou une saison.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5c6cf71f-c031-5bf4-b43d-a802ffbba359', '33a75aa3-935a-5d73-98e8-9184127c935a', 'francais-a2', '⭐⭐ Révision : prépositions de lieu et de temps', 2, 75, 15, 'practice', 'admin', 2)
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
  ('6e249a74-356f-54ed-ab57-70d8243e9a79', '5c6cf71f-c031-5bf4-b43d-a802ffbba359', 'Complète : « La pharmacie est ___ la banque et la poste. »', '[{"id":"a","text":"sur"},{"id":"b","text":"chez"},{"id":"c","text":"sous"},{"id":"d","text":"entre"}]'::jsonb, 'd', 'On emploie « entre » pour situer au milieu de deux éléments : entre la banque et la poste. « sur » et « sous » indiquent une surface ou le dessous, et « chez » s''emploie uniquement avec une personne.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('63e05cb4-169e-5a21-847b-b2cd50d93d88', '5c6cf71f-c031-5bf4-b43d-a802ffbba359', 'Complète : « Elle apprend l''arabe ___ trois ans. »', '[{"id":"a","text":"il y a"},{"id":"b","text":"dans"},{"id":"c","text":"depuis"},{"id":"d","text":"pendant"}]'::jsonb, 'c', 'L''action continue jusqu''à maintenant, donc on emploie « depuis » : depuis trois ans (et elle apprend encore). « il y a » désigne un point fini dans le passé, « dans » un moment futur, et « pendant » une durée totale et terminée.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34ef428c-0ce3-5677-98b7-0c30deeab5ed', '5c6cf71f-c031-5bf4-b43d-a802ffbba359', 'Complète : « Mes cousins vivent ___ États-Unis. »', '[{"id":"a","text":"en"},{"id":"b","text":"aux"},{"id":"c","text":"au"},{"id":"d","text":"à"}]'::jsonb, 'b', 'Les États-Unis est un pays au pluriel, donc on emploie « aux » : aux États-Unis. « en » s''utilise pour les pays féminins, « au » pour les pays masculins singuliers, et « à » devant les villes.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8859d84d-0359-5a19-9fce-89463b75e37f', '5c6cf71f-c031-5bf4-b43d-a802ffbba359', 'Complète : « Je vais à l''école ___ vélo. »', '[{"id":"a","text":"à"},{"id":"b","text":"en"},{"id":"c","text":"dans"},{"id":"d","text":"sur"}]'::jsonb, 'a', 'Pour un moyen de transport sans habitacle, on emploie « à » : à vélo, à pied, à cheval. « en » s''utilise pour les véhicules où l''on monte (en voiture, en train), tandis que « dans » et « sur » ne conviennent pas ici.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6f443a56-ca80-54f1-aee7-3cde84b295cf', '5c6cf71f-c031-5bf4-b43d-a802ffbba359', 'Complète : « Nous avons attendu ___ une heure devant la gare. »', '[{"id":"a","text":"depuis"},{"id":"b","text":"dans"},{"id":"c","text":"pendant"},{"id":"d","text":"il y a"}]'::jsonb, 'c', 'Il s''agit d''une durée complète et terminée, donc on emploie « pendant » : pendant une heure. « depuis » indiquerait une action encore en cours, « dans » un moment futur, et « il y a » un point précis dans le passé.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('77571e40-8d99-5c8e-85e4-e99bd86e31d0', '5c6cf71f-c031-5bf4-b43d-a802ffbba359', 'Complète : « La voiture est garée ___ la maison. »', '[{"id":"a","text":"chez"},{"id":"b","text":"en"},{"id":"c","text":"entre"},{"id":"d","text":"devant"}]'::jsonb, 'd', '« devant » indique la position à l''avant d''un lieu : devant la maison. « chez » s''emploie avec une personne, « en » devant un pays ou une saison, et « entre » exige deux éléments (entre A et B).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b45edbc8-aa8e-59d3-b0b8-8b8d0a057d56', '33a75aa3-935a-5d73-98e8-9184127c935a', 'francais-a2', '⚔️ Boss du chapitre ⭐⭐⭐ : prépositions de lieu et de temps', 3, 120, 30, 'boss', 'admin', 3)
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
  ('def4af47-7408-5bec-87b9-c6e9a59a6b4b', 'b45edbc8-aa8e-59d3-b0b8-8b8d0a057d56', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Je suis allé à la Tunisie l''an dernier."},{"id":"b","text":"Le chat est sous la table."},{"id":"c","text":"Elle habite chez ses parents."},{"id":"d","text":"Nous partons en France demain."}]'::jsonb, 'a', 'L''erreur est en (a) : devant un pays féminin, on dit « en Tunisie », jamais « à la Tunisie ». Les autres sont correctes : « sous » pour le dessous, « chez » + personne, et « en » + pays féminin (France).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('755436f1-cd18-5bd5-a286-f79848dfed0f', 'b45edbc8-aa8e-59d3-b0b8-8b8d0a057d56', 'Complète : « Il a quitté le pays ___ cinq ans et il n''est jamais revenu. »', '[{"id":"a","text":"depuis"},{"id":"b","text":"pendant"},{"id":"c","text":"dans"},{"id":"d","text":"il y a"}]'::jsonb, 'd', '« il y a » situe une action ponctuelle dans le passé : il a quitté le pays il y a cinq ans. « depuis » servirait à une action encore en cours, « pendant » à une durée totale, et « dans » à un moment futur. Le piège courant : confondre « il y a » (passé fini) et « depuis » (encore actuel).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9cc1bc40-891e-5e6d-8aac-8fcce7cdf1b5', 'b45edbc8-aa8e-59d3-b0b8-8b8d0a057d56', 'Complète : « Le musée se trouve ___ la place, juste ___ face ___ la cathédrale. »', '[{"id":"a","text":"dans / en / de"},{"id":"b","text":"à / sur / de"},{"id":"c","text":"sur / en / de"},{"id":"d","text":"en / à / du"}]'::jsonb, 'c', 'On dit « sur la place » pour un lieu public ouvert, puis la locution complète « en face de » : en face de la cathédrale. « dans la place » et « à sur » sont fautifs, et « en face du » exigerait un nom masculin (la cathédrale est féminin → de la).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d044df80-8faa-5111-bf09-3fdf1aa0b070', 'b45edbc8-aa8e-59d3-b0b8-8b8d0a057d56', 'Complète : « Je voyage ___ États-Unis et je reviens ___ trois semaines. »', '[{"id":"a","text":"au / depuis"},{"id":"b","text":"aux / dans"},{"id":"c","text":"en / pendant"},{"id":"d","text":"à / il y a"}]'::jsonb, 'b', 'Les États-Unis est un pays pluriel, donc « aux » : aux États-Unis. « dans trois semaines » exprime un moment futur. La combinaison « aux / dans » est correcte. « au » est réservé au masculin singulier, « en » au féminin, et « depuis / il y a » concernent le passé, pas le futur.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('61d2e80c-6970-59c3-8243-d27e25fd2ba8', 'b45edbc8-aa8e-59d3-b0b8-8b8d0a057d56', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"On se voit à 18 h devant le cinéma."},{"id":"b","text":"Elle travaille ici depuis 2021."},{"id":"c","text":"Je rentre dans une demi-heure."},{"id":"d","text":"Il a vécu au Espagne pendant deux ans."}]'::jsonb, 'd', 'L''erreur est en (d) : l''Espagne est un pays féminin, on dit « en Espagne », pas « au Espagne » (« au » est réservé aux pays masculins). Les autres sont correctes : « à 18 h » + « devant », « depuis 2021 », et « dans une demi-heure » (futur).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('794066f0-487c-52e0-8f44-e49b74d7d85b', 'b45edbc8-aa8e-59d3-b0b8-8b8d0a057d56', 'Complète : « ___ 2024, elle a vécu ___ Canada, puis elle est rentrée ___ Tunis. »', '[{"id":"a","text":"À / en / à"},{"id":"b","text":"En / à / en"},{"id":"c","text":"En / au / à"},{"id":"d","text":"Dans / au / en"}]'::jsonb, 'c', 'On dit « en 2024 » (année), « au Canada » (pays masculin) et « à Tunis » (ville). La combinaison « En / au / à » respecte les trois règles. « au Tunis » et « en Tunis » sont fautifs car Tunis est une ville (→ à), et « Dans 2024 » est incorrect pour une année.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('54109f37-fe41-51dd-9bf4-4153280f86cc', '33a75aa3-935a-5d73-98e8-9184127c935a', 'francais-a2', '👑 Défi élite ⭐⭐⭐⭐ : prépositions de lieu et de temps', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('83ff0932-86c5-5a03-9028-e790de66fec5', '54109f37-fe41-51dd-9bf4-4153280f86cc', 'Lis : « Karim habite à Lyon, en France, depuis 2019. Il travaille dans une banque, en face de la gare. Le matin, il y va à pied. »
Quelle phrase est VRAIE ?', '[{"id":"a","text":"Karim habite en Lyon depuis trois mois."},{"id":"b","text":"Il travaille sur une banque, derrière la gare."},{"id":"c","text":"Sa banque se trouve en face de la gare."},{"id":"d","text":"Il va au travail en voiture le matin."}]'::jsonb, 'c', 'Le texte dit « dans une banque, en face de la gare » : (c) reprend exactement « en face de la gare ». (a) est faux (« à Lyon », ville, et depuis 2019), (b) confond « dans » avec « sur » et « en face » avec « derrière », et (d) contredit « à pied ».', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('92c5d7d2-af0e-5200-96f1-941549e89b9f', '54109f37-fe41-51dd-9bf4-4153280f86cc', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Il étudie le français depuis pendant deux ans."},{"id":"b","text":"Nous sommes arrivés à Tunis à minuit."},{"id":"c","text":"Le livre est à côté de la lampe."},{"id":"d","text":"Elle part au Japon dans une semaine."}]'::jsonb, 'a', 'L''erreur est en (a) : on ne cumule pas « depuis » et « pendant ». Il faut « depuis deux ans » (action en cours) ou « pendant deux ans » (durée finie), jamais les deux. Les autres sont correctes : « à Tunis » + « à minuit », « à côté de », et « au Japon » + « dans une semaine » (futur).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('caf0c786-2919-5874-a4bd-ecdfb0ca53bf', '54109f37-fe41-51dd-9bf4-4153280f86cc', 'Complète : « Mets les documents ___ le tiroir, ___ le dossier rouge, ___ gauche. »', '[{"id":"a","text":"sur / sous / en"},{"id":"b","text":"à / dans / sur"},{"id":"c","text":"chez / dans / sur"},{"id":"d","text":"dans / dans / à"}]'::jsonb, 'd', 'On range les documents « dans le tiroir » (espace fermé), « dans le dossier » (à l''intérieur) et « à gauche » (locution fixe). La combinaison « dans / dans / à » est correcte. « sur le tiroir » et « chez » (réservé aux personnes) sont fautifs, et « à gauche » ne prend ni « en » ni « sur ».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44028074-3c2e-5df0-a193-be6d97ef3108', '54109f37-fe41-51dd-9bf4-4153280f86cc', 'Complète : « Le festival a lieu ___ été, ___ Italie, et il dure ___ une semaine. »', '[{"id":"a","text":"à / en / depuis"},{"id":"b","text":"en / en / pendant"},{"id":"c","text":"en / au / dans"},{"id":"d","text":"dans / à la / pendant"}]'::jsonb, 'b', 'On dit « en été » (saison), « en Italie » (pays féminin) et « pendant une semaine » (durée complète). La combinaison « en / en / pendant » respecte les trois règles. « à été » et « à la Italie » sont fautifs, et « depuis / dans » n''expriment pas une durée totale.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb9fa363-668d-59e5-94f7-c79b6802aaa1', '54109f37-fe41-51dd-9bf4-4153280f86cc', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Je suis allé chez la boulangerie à 7 h."},{"id":"b","text":"Ils vivent au Portugal depuis dix ans."},{"id":"c","text":"Le chat se cache derrière le rideau."},{"id":"d","text":"On se retrouve devant le musée dans une heure."}]'::jsonb, 'a', 'L''erreur est en (a) : « chez » s''emploie seulement avec une personne ou un métier, pas avec un lieu. Il faut « à la boulangerie ». Les autres sont correctes : « au Portugal » (masculin) + « depuis », « derrière le rideau », et « devant » + « dans une heure » (futur).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('550155a1-9cff-5d3c-8b52-aef5a6ea931c', '54109f37-fe41-51dd-9bf4-4153280f86cc', 'Complète : « Elle est née ___ 2005 ___ Maroc, mais elle vit ___ Pays-Bas ___ 2018. »', '[{"id":"a","text":"à / en / au / depuis"},{"id":"b","text":"en / au / aux / depuis"},{"id":"c","text":"en / au / aux / pendant"},{"id":"d","text":"dans / au / en / il y a"}]'::jsonb, 'b', 'On dit « en 2005 » (année), « au Maroc » (pays masculin), « aux Pays-Bas » (pays pluriel) et « depuis 2018 » (action encore en cours). Seule « en / au / aux / depuis » est juste. « pendant 2018 » et « il y a 2018 » sont fautifs, et « à 2005 » est incorrect pour une année.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('28586578-8bab-5e9a-b373-bac2e5424d35', '33a75aa3-935a-5d73-98e8-9184127c935a', 'francais-a2', '⭐⭐ Drill : prépositions de lieu et de temps', 2, 75, 15, 'practice', 'admin', 5)
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
  ('a4d50ec7-a6a7-50ed-9066-ffa03e8e2879', '28586578-8bab-5e9a-b373-bac2e5424d35', 'Complète : « Le parc est ___ du centre-ville, à dix minutes seulement. »', '[{"id":"a","text":"loin"},{"id":"b","text":"près"},{"id":"c","text":"sous"},{"id":"d","text":"entre"}]'::jsonb, 'b', '« à dix minutes seulement » indique une faible distance, donc « près de » : près du centre-ville. « loin de » signifierait le contraire, « sous » indique le dessous, et « entre » exige deux éléments.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f733fd44-b885-519b-8a96-cdb7f6ea39c4', '28586578-8bab-5e9a-b373-bac2e5424d35', 'Complète : « Mon avion atterrit ___ Rome ___ trois heures. »', '[{"id":"a","text":"en / depuis"},{"id":"b","text":"au / pendant"},{"id":"c","text":"à / dans"},{"id":"d","text":"à / il y a"}]'::jsonb, 'c', 'Rome est une ville, donc « à Rome » ; « dans trois heures » exprime un moment futur. La combinaison « à / dans » est correcte. « en » et « au » sont réservés aux pays, et « depuis / il y a / pendant » ne conviennent pas pour un futur.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cf5287d9-c124-54bf-aef5-6e6b9460fa2e', '28586578-8bab-5e9a-b373-bac2e5424d35', 'Complète : « Le tableau est accroché ___ le mur, ___ la fenêtre et la porte. »', '[{"id":"a","text":"dans / sous"},{"id":"b","text":"à / chez"},{"id":"c","text":"en / devant"},{"id":"d","text":"sur / entre"}]'::jsonb, 'd', 'On accroche un tableau « sur le mur » (surface verticale) et il se trouve « entre la fenêtre et la porte » (au milieu de deux éléments). « dans le mur » et « en le mur » sont fautifs, et « chez » s''emploie avec une personne.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('194641cf-1a91-53d0-95d4-3662cc51b002', '28586578-8bab-5e9a-b373-bac2e5424d35', 'Complète : « Nous avons habité ___ Algérie ___ cinq ans avant de déménager. »', '[{"id":"a","text":"en / pendant"},{"id":"b","text":"au / depuis"},{"id":"c","text":"à la / dans"},{"id":"d","text":"à / pendant"}]'::jsonb, 'a', 'L''Algérie est un pays féminin, donc « en Algérie » ; « pendant cinq ans » indique une durée complète et terminée. « en / pendant » est correct. « au » et « à la » sont fautifs devant ce pays, et « depuis / dans » n''expriment pas une durée achevée.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6b17412b-e2e6-5a5a-b7b8-d60735c970e9', '28586578-8bab-5e9a-b373-bac2e5424d35', 'Trouve la phrase INCORRECTE.', '[{"id":"a","text":"Je travaille à la maison aujourd''hui."},{"id":"b","text":"Le cours commence à 9 h."},{"id":"c","text":"Il habite dans le Canada depuis un an."},{"id":"d","text":"On se voit chez Sophie ce soir."}]'::jsonb, 'c', 'L''erreur est en (c) : devant un pays masculin, on dit « au Canada », jamais « dans le Canada ». Les autres sont correctes : « à la maison », « à 9 h » (heure précise), et « chez Sophie » (+ personne).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43c0a824-6d0e-55ff-9865-0d8ea9df6879', '28586578-8bab-5e9a-b373-bac2e5424d35', 'Complète : « Le bus passe ___ l''arrêt ___ vingt minutes ; il est déjà passé ___ cinq minutes. »', '[{"id":"a","text":"à / dans / il y a"},{"id":"b","text":"en / depuis / dans"},{"id":"c","text":"sur / pendant / depuis"},{"id":"d","text":"à / depuis / pendant"}]'::jsonb, 'a', 'On attend le bus « à l''arrêt » (lieu précis), il passera « dans vingt minutes » (futur) et il est passé « il y a cinq minutes » (point fini dans le passé). « à / dans / il y a » est correct. « depuis » et « pendant » ne conviennent ni au futur ni à un point passé.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1570485f-47a9-52af-a1d8-ac0712f76e7e', 'aaee51e0-fcfc-5a5a-b971-e3dd7c6c3ae9', 'francais-a2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('9a8ee112-f606-52bb-ade5-e6b0063befa0', '1570485f-47a9-52af-a1d8-ac0712f76e7e', 'Où vas-tu pour envoyer une lettre ou un colis ?', '[{"id":"a","text":"à la banque"},{"id":"b","text":"à la poste"},{"id":"c","text":"à la gare"},{"id":"d","text":"au musée"}]'::jsonb, 'b', 'On envoie une lettre ou un colis à la poste. La banque sert à l''argent, la gare à prendre le train, et le musée à voir des œuvres d''art.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b9477bf5-9be2-53c1-8e71-0bb9c555eeae', '1570485f-47a9-52af-a1d8-ac0712f76e7e', 'Complète l''indication : « Continuez sans tourner, ___. »', '[{"id":"a","text":"tournez à droite"},{"id":"b","text":"traversez la rue"},{"id":"c","text":"allez tout droit"},{"id":"d","text":"tournez à gauche"}]'::jsonb, 'c', '« Aller tout droit » signifie continuer sans tourner. Tourner à droite ou à gauche, c''est justement changer de direction ; traverser, c''est passer de l''autre côté de la rue.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75e5ae9d-c178-5d28-a41b-64dbe35108f4', '1570485f-47a9-52af-a1d8-ac0712f76e7e', 'Dans quel commerce achète-t-on du pain ?', '[{"id":"a","text":"à la boucherie"},{"id":"b","text":"à la pharmacie"},{"id":"c","text":"à la boulangerie"},{"id":"d","text":"à la banque"}]'::jsonb, 'c', 'On achète le pain à la boulangerie. La boucherie vend de la viande, la pharmacie des médicaments, et la banque s''occupe de l''argent.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('beda8e6c-7e6b-59a2-a264-442b98e4957a', '1570485f-47a9-52af-a1d8-ac0712f76e7e', 'Tu as mal à la tête. Quelle phrase est correcte ?', '[{"id":"a","text":"J''ai mal à la tête."},{"id":"b","text":"Je suis mal la tête."},{"id":"c","text":"J''ai mal le tête."},{"id":"d","text":"Je fais mal à tête."}]'::jsonb, 'a', 'On dit « avoir mal à » + la partie du corps : j''ai mal à la tête. On utilise le verbe avoir (pas être ni faire), et « tête » est féminin, donc « à la tête ».', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4014dd03-4642-5e8d-be8c-841c708b7d7a', '1570485f-47a9-52af-a1d8-ac0712f76e7e', 'Le médecin te donne un papier pour acheter des médicaments à la pharmacie. Ce papier, c''est…', '[{"id":"a","text":"la monnaie"},{"id":"b","text":"le prix"},{"id":"c","text":"l''ordonnance"},{"id":"d","text":"la caisse"}]'::jsonb, 'c', 'L''ordonnance est le papier écrit par le médecin pour acheter des médicaments. La monnaie, ce sont les pièces ; le prix, c''est combien ça coûte ; la caisse, c''est l''endroit où l''on paie.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b2a65a22-02e2-5cbf-8e13-68d0302682a8', 'aaee51e0-fcfc-5a5a-b971-e3dd7c6c3ae9', 'francais-a2', '⭐ Entraînement : la ville et la vie quotidienne', 1, 50, 10, 'practice', 'admin', 1)
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
  ('0224bb92-f8c9-5b67-a0a5-91fa805b819b', 'b2a65a22-02e2-5cbf-8e13-68d0302682a8', 'Où vas-tu pour prendre le train ?', '[{"id":"a","text":"à la gare"},{"id":"b","text":"à la mairie"},{"id":"c","text":"à la poste"},{"id":"d","text":"à la banque"}]'::jsonb, 'a', 'On prend le train à la gare. La mairie sert aux papiers officiels, la poste à envoyer du courrier, et la banque à gérer son argent.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b7db18c-ad25-5cc9-abd4-bf84a2001c79', 'b2a65a22-02e2-5cbf-8e13-68d0302682a8', 'Pour acheter des médicaments, tu vas…', '[{"id":"a","text":"à la boucherie"},{"id":"b","text":"au commissariat"},{"id":"c","text":"à la bibliothèque"},{"id":"d","text":"à la pharmacie"}]'::jsonb, 'd', 'On achète les médicaments à la pharmacie. La boucherie vend de la viande, la bibliothèque prête des livres, et le commissariat, c''est la police.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bf3c56cd-5e8d-56ba-899c-a3796e769a04', 'b2a65a22-02e2-5cbf-8e13-68d0302682a8', 'Complète : « Pour aller à droite, vous ___ à droite. »', '[{"id":"a","text":"traversez"},{"id":"b","text":"allez tout droit"},{"id":"c","text":"tournez"},{"id":"d","text":"payez"}]'::jsonb, 'c', 'On dit « tourner à droite » ou « tourner à gauche » pour changer de direction. Traverser, c''est passer de l''autre côté de la rue ; aller tout droit, c''est ne pas tourner.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84372228-eeb0-5b94-989f-092536843422', 'b2a65a22-02e2-5cbf-8e13-68d0302682a8', 'Trouve l''intrus.', '[{"id":"a","text":"la tête"},{"id":"b","text":"le bras"},{"id":"c","text":"la jambe"},{"id":"d","text":"le marché"}]'::jsonb, 'd', 'La tête, le bras et la jambe sont des parties du corps ; le marché est un lieu de la ville où l''on achète des fruits et des légumes. C''est donc l''intrus.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('19f8b1fd-7814-5d62-a83f-91c29525df67', 'b2a65a22-02e2-5cbf-8e13-68d0302682a8', 'À la caisse du supermarché, qu''est-ce qu''on fait ?', '[{"id":"a","text":"on dort"},{"id":"b","text":"on lit"},{"id":"c","text":"on nage"},{"id":"d","text":"on paie"}]'::jsonb, 'd', 'À la caisse, on paie ses achats (verbe payer). Le marchand rend ensuite la monnaie si nécessaire. Les autres actions n''ont rien à voir avec un magasin.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aedc6648-47b6-55d6-8054-ab09bb0672e2', 'b2a65a22-02e2-5cbf-8e13-68d0302682a8', '« J''ai mal ___ ventre. » Quel mot complète la phrase ?', '[{"id":"a","text":"à la"},{"id":"b","text":"à le"},{"id":"c","text":"le"},{"id":"d","text":"au"}]'::jsonb, 'd', '« Ventre » est masculin, donc à + le = au : j''ai mal au ventre. On dit « à la » devant un mot féminin (à la tête) et jamais « à le », qui se contracte toujours en « au ».', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e4137aec-4530-5297-88a3-a9cd2022f472', 'aaee51e0-fcfc-5a5a-b971-e3dd7c6c3ae9', 'francais-a2', '⭐⭐ Révision : la ville et la vie quotidienne', 2, 75, 15, 'practice', 'admin', 2)
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
  ('8b97473f-1cd3-5346-aefd-d84c1037d769', 'e4137aec-4530-5297-88a3-a9cd2022f472', 'Associe le lieu à l''action : où emprunte-t-on des livres ?', '[{"id":"a","text":"à la bibliothèque"},{"id":"b","text":"à la banque"},{"id":"c","text":"à la boulangerie"},{"id":"d","text":"au musée"}]'::jsonb, 'a', 'On emprunte des livres à la bibliothèque. À la banque on gère son argent, à la boulangerie on achète du pain, et au musée on regarde des œuvres d''art.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('34667fb0-af57-5515-ad7f-ce58a55dcbba', 'e4137aec-4530-5297-88a3-a9cd2022f472', 'Le marchand te rend 3 euros après ton achat. Ces pièces, c''est…', '[{"id":"a","text":"le prix"},{"id":"b","text":"la caisse"},{"id":"c","text":"la monnaie"},{"id":"d","text":"l''ordonnance"}]'::jsonb, 'c', 'L''argent que le marchand te rend s''appelle la monnaie. Le prix, c''est combien coûte l''objet ; la caisse, c''est l''endroit où l''on paie ; l''ordonnance vient du médecin.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ab317c9-a988-57c5-ad43-9c84dca4d9e0', 'e4137aec-4530-5297-88a3-a9cd2022f472', 'Complète le mini-dialogue : « — Pardon, où est la pharmacie ? — Elle est ___ de la poste, juste à côté. »', '[{"id":"a","text":"tout droit"},{"id":"b","text":"à côté"},{"id":"c","text":"jusqu''à"},{"id":"d","text":"traversez"}]'::jsonb, 'b', '« À côté de » signifie tout près, juste à côté. « Tout droit » indique une direction, « jusqu''à » marque une limite à atteindre, et « traversez » est un ordre (passer de l''autre côté).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c477d5a-6536-574d-a85a-b7806d78209a', 'e4137aec-4530-5297-88a3-a9cd2022f472', 'Trouve l''intrus.', '[{"id":"a","text":"la boulangerie"},{"id":"b","text":"la boucherie"},{"id":"c","text":"l''épicerie"},{"id":"d","text":"l''hôpital"}]'::jsonb, 'd', 'La boulangerie, la boucherie et l''épicerie sont des commerces où l''on achète à manger. L''hôpital est un lieu de santé où l''on se fait soigner : c''est l''intrus.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8bec889f-dac8-5396-8874-af91083f64e9', 'e4137aec-4530-5297-88a3-a9cd2022f472', 'Que veut dire l''expression « faire les courses » ?', '[{"id":"a","text":"courir vite"},{"id":"b","text":"aller acheter à manger"},{"id":"c","text":"faire du sport"},{"id":"d","text":"prendre rendez-vous"}]'::jsonb, 'b', '« Faire les courses », c''est aller acheter de la nourriture (au marché ou au supermarché). Attention à ne pas confondre avec « faire une course à pied », qui veut dire courir.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('164f0371-5299-553b-8d55-115c8fe8b646', 'e4137aec-4530-5297-88a3-a9cd2022f472', 'Tu es très malade et tu dois te faire soigner d''urgence. Où vas-tu ?', '[{"id":"a","text":"à la mairie"},{"id":"b","text":"au commissariat"},{"id":"c","text":"à l''hôpital"},{"id":"d","text":"à la gare"}]'::jsonb, 'c', 'Quand on est très malade, on va à l''hôpital pour se faire soigner. La mairie gère les papiers, le commissariat est la police, et la gare sert aux trains.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('58a47bc3-50b8-5e6e-b76a-a672d09bf8b8', 'aaee51e0-fcfc-5a5a-b971-e3dd7c6c3ae9', 'francais-a2', '⚔️ Boss du chapitre ⭐⭐⭐ : la ville et la vie quotidienne', 3, 120, 30, 'boss', 'admin', 3)
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
  ('976524b7-916a-586c-821f-e941fb228ed4', '58a47bc3-50b8-5e6e-b76a-a672d09bf8b8', 'Mini-dialogue : « — Combien ___ ce livre ? — Douze euros. » Quel mot manque ?', '[{"id":"a","text":"ça coûte"},{"id":"b","text":"ça paie"},{"id":"c","text":"ça rend"},{"id":"d","text":"ça vend"}]'::jsonb, 'a', 'Pour demander le prix, on dit « Combien ça coûte ? ». « Payer », c''est donner l''argent ; « rendre la monnaie », c''est ce que fait le marchand ; « vendre » se dit du commerçant, pas du client.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9564d2f5-bf46-52ec-9499-f4fbc3e5d738', '58a47bc3-50b8-5e6e-b76a-a672d09bf8b8', '« Allez tout droit, puis ___ la rue au feu et la banque sera en face. » Quel verbe complète l''indication ?', '[{"id":"a","text":"payez"},{"id":"b","text":"traversez"},{"id":"c","text":"habitez"},{"id":"d","text":"sortez"}]'::jsonb, 'b', '« Traverser la rue » signifie passer de l''autre côté. Le piège courant est de choisir « tourner », mais tourner ne mentionne pas la rue à franchir ; payer, habiter et sortir n''ont rien à voir avec une indication de chemin.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('591030b8-3c27-5f39-bdd7-5446dca2c0a0', '58a47bc3-50b8-5e6e-b76a-a672d09bf8b8', 'Quelle phrase emploie correctement « avoir mal à » ?', '[{"id":"a","text":"J''ai mal aux gorge."},{"id":"b","text":"Je suis mal à la gorge."},{"id":"c","text":"J''ai mal à la gorge."},{"id":"d","text":"J''ai mal à le dos."}]'::jsonb, 'c', 'On dit « avoir mal à » + partie du corps : j''ai mal à la gorge (féminin singulier). « Aux » est un pluriel (aux dents), « être mal » n''existe pas dans ce sens, et « à le » se contracte toujours en « au » (j''ai mal au dos).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1a09795-3e27-5e00-b206-dfc5990b6250', '58a47bc3-50b8-5e6e-b76a-a672d09bf8b8', 'Trouve l''intrus parmi ces actions de la routine et des loisirs.', '[{"id":"a","text":"faire les courses"},{"id":"b","text":"aller au cinéma"},{"id":"c","text":"prendre rendez-vous"},{"id":"d","text":"rendre la monnaie"}]'::jsonb, 'd', 'Faire les courses, aller au cinéma et prendre rendez-vous sont des activités de la vie quotidienne. « Rendre la monnaie » est une action du commerçant à la caisse : c''est l''intrus.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e11f0dfa-0f42-5840-a927-a1de4e7d8dee', '58a47bc3-50b8-5e6e-b76a-a672d09bf8b8', 'Au guichet : « Je voudrais déposer de l''argent sur mon compte. » Où es-tu ?', '[{"id":"a","text":"à la banque"},{"id":"b","text":"à la poste"},{"id":"c","text":"à la pharmacie"},{"id":"d","text":"au musée"}]'::jsonb, 'a', 'On dépose ou retire de l''argent sur un compte à la banque. La poste envoie le courrier, la pharmacie vend des médicaments, et le musée présente des œuvres ; aucun ne gère un compte bancaire.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3e4355b6-96ce-5bbd-8858-c1e709e647de', '58a47bc3-50b8-5e6e-b76a-a672d09bf8b8', '« Je dois ___ chez le médecin pour mardi prochain. » Quelle expression convient ?', '[{"id":"a","text":"faire les courses"},{"id":"b","text":"prendre rendez-vous"},{"id":"c","text":"rendre la monnaie"},{"id":"d","text":"traverser la rue"}]'::jsonb, 'b', '« Prendre rendez-vous » signifie fixer un horaire pour voir le médecin. Le piège courant est « faire les courses » (acheter à manger), mais on ne fait pas de courses chez un médecin ; rendre la monnaie et traverser la rue n''ont aucun rapport.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('11096117-bd07-56a8-98bc-d7122f2e3543', 'aaee51e0-fcfc-5a5a-b971-e3dd7c6c3ae9', 'francais-a2', '👑 Défi élite ⭐⭐⭐⭐ : la ville et la vie quotidienne', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('585a873d-01b1-59f8-85ab-2e2bba056b17', '11096117-bd07-56a8-98bc-d7122f2e3543', '« La librairie est ___ de la mairie : juste à l''angle, là où les deux rues se croisent. » Quelle expression de lieu convient ?', '[{"id":"a","text":"en face"},{"id":"b","text":"au coin"},{"id":"c","text":"jusqu''à"},{"id":"d","text":"tout droit"}]'::jsonb, 'b', '« Au coin de » désigne l''angle, là où deux rues se croisent, ce que confirme la phrase. « En face de » veut dire de l''autre côté ; « jusqu''à » marque une limite à atteindre ; « tout droit » est une direction, pas un emplacement.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1d5aec5e-7b92-554f-815e-1172750cb410', '11096117-bd07-56a8-98bc-d7122f2e3543', 'Choisis la phrase entièrement correcte.', '[{"id":"a","text":"Je vais à la pharmacie acheter une ordonnance."},{"id":"b","text":"Le médecin me donne une ordonnance pour acheter des médicaments."},{"id":"c","text":"Le médecin me vend des médicaments à la banque."},{"id":"d","text":"J''achète mes médicaments à la poste avec une caisse."}]'::jsonb, 'b', 'Le médecin écrit l''ordonnance (le papier) ; on l''apporte ensuite à la pharmacie pour acheter les médicaments. On n''« achète » pas une ordonnance (a), le médecin ne vend pas à la banque (c), et on n''achète pas de médicaments à la poste (d).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6fec4c38-d2b7-5cd5-97d3-3f6d98eb1983', '11096117-bd07-56a8-98bc-d7122f2e3543', 'Quel mot n''appartient PAS au champ lexical de l''argent et des achats ?', '[{"id":"a","text":"le prix"},{"id":"b","text":"la monnaie"},{"id":"c","text":"la caisse"},{"id":"d","text":"l''ordonnance"}]'::jsonb, 'd', 'Le prix, la monnaie et la caisse appartiennent au monde des achats et de l''argent. L''ordonnance est le papier du médecin (champ de la santé) : c''est elle qui ne va pas avec les autres.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ed0d8fa-a6c0-5a3b-99fd-67c7933649a2', '11096117-bd07-56a8-98bc-d7122f2e3543', 'Mini-dialogue : « — Pardon, pour aller à la gare ? — ___, puis tournez à gauche ; elle est en face du musée. » Quelle réponse est cohérente ?', '[{"id":"a","text":"Allez tout droit jusqu''au feu"},{"id":"b","text":"Payez à la caisse"},{"id":"c","text":"Prenez rendez-vous"},{"id":"d","text":"Faites les courses"}]'::jsonb, 'a', 'Pour indiquer un chemin, on combine des directions : « allez tout droit jusqu''au feu, puis tournez à gauche ». Payer, prendre rendez-vous et faire les courses ne donnent aucune direction et n''ont pas leur place ici.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bfdf167d-ead8-59f1-8765-5e153d53ce04', '11096117-bd07-56a8-98bc-d7122f2e3543', '« Après le travail, je ___ avec mes amis : on va au cinéma. » Quel verbe exprime le mieux quitter la maison pour s''amuser ?', '[{"id":"a","text":"traverse"},{"id":"b","text":"paie"},{"id":"c","text":"sors"},{"id":"d","text":"soigne"}]'::jsonb, 'c', '« Sortir » (je sors) veut dire quitter la maison pour s''amuser, ce que confirme « on va au cinéma ». Traverser concerne une rue, payer concerne l''argent, et soigner concerne la santé : aucun ne décrit une soirée entre amis.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('092f68cd-c5fb-5871-a9f4-8289297f2d25', '11096117-bd07-56a8-98bc-d7122f2e3543', 'Quelle association lieu ↔ action est FAUSSE ?', '[{"id":"a","text":"la boucherie → acheter de la viande"},{"id":"b","text":"la bibliothèque → emprunter des livres"},{"id":"c","text":"le commissariat → acheter des fruits"},{"id":"d","text":"la gare → prendre le train"}]'::jsonb, 'c', 'Le commissariat, c''est la police : on n''y achète pas de fruits (ça, c''est le marché). Les trois autres associations sont justes : viande à la boucherie, livres à la bibliothèque, train à la gare.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f164cc5b-f6a1-5106-9657-f557933a5051', 'aaee51e0-fcfc-5a5a-b971-e3dd7c6c3ae9', 'francais-a2', '⭐⭐ Drill : la ville et la vie quotidienne', 2, 75, 15, 'practice', 'admin', 5)
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
  ('ddc055af-0de6-55ba-9ab0-e5522b41693e', 'f164cc5b-f6a1-5106-9657-f557933a5051', 'Où achètes-tu des fruits et des légumes frais en plein air ?', '[{"id":"a","text":"au marché"},{"id":"b","text":"à la poste"},{"id":"c","text":"au musée"},{"id":"d","text":"à la mairie"}]'::jsonb, 'a', 'On achète des fruits et légumes frais au marché. La poste sert au courrier, le musée à l''art, et la mairie aux papiers officiels.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bd0a9000-5ac2-5cea-8a1b-b364dd2079ea', 'f164cc5b-f6a1-5106-9657-f557933a5051', 'Complète : « La banque est ___ de la poste : elle est juste de l''autre côté de la rue. »', '[{"id":"a","text":"au coin"},{"id":"b","text":"en face"},{"id":"c","text":"jusqu''à"},{"id":"d","text":"tout droit"}]'::jsonb, 'b', '« En face de » signifie juste de l''autre côté, ce que précise la phrase. « Au coin » désigne l''angle de la rue, « jusqu''à » une limite à atteindre, et « tout droit » une direction.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea51fbdd-842b-582f-b415-047c6493b22a', 'f164cc5b-f6a1-5106-9657-f557933a5051', 'Trouve l''intrus.', '[{"id":"a","text":"la gare"},{"id":"b","text":"la banque"},{"id":"c","text":"la jambe"},{"id":"d","text":"la poste"}]'::jsonb, 'c', 'La gare, la banque et la poste sont des lieux de la ville. La jambe est une partie du corps : c''est l''intrus.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f37f5b5-cec9-5215-a863-6cb041741e54', 'f164cc5b-f6a1-5106-9657-f557933a5051', '« J''ai mal ___ dents depuis hier. » Quel mot complète la phrase ?', '[{"id":"a","text":"au"},{"id":"b","text":"à la"},{"id":"c","text":"aux"},{"id":"d","text":"à le"}]'::jsonb, 'c', '« Dents » est au pluriel, donc à + les = aux : j''ai mal aux dents. On emploie « au » devant un masculin singulier (au dos) et « à la » devant un féminin singulier (à la tête).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2724ba12-345a-5252-9808-6e752b323e7d', 'f164cc5b-f6a1-5106-9657-f557933a5051', 'Associe l''action au lieu : où vas-tu pour faire tes papiers officiels (carte d''identité, mariage) ?', '[{"id":"a","text":"à la bibliothèque"},{"id":"b","text":"à la boulangerie"},{"id":"c","text":"à la mairie"},{"id":"d","text":"à la pharmacie"}]'::jsonb, 'c', 'On fait ses papiers officiels à la mairie (l''hôtel de ville). La bibliothèque prête des livres, la boulangerie vend du pain, et la pharmacie des médicaments.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fdca2a8b-6458-56c1-95a1-aad6ce5e0887', 'f164cc5b-f6a1-5106-9657-f557933a5051', 'Quel verbe va le mieux avec « du sport » ?', '[{"id":"a","text":"payer"},{"id":"b","text":"faire"},{"id":"c","text":"traverser"},{"id":"d","text":"emprunter"}]'::jsonb, 'b', 'On dit « faire du sport » (faire du foot, de la natation…). Payer concerne l''argent, traverser une rue, et emprunter se dit pour des livres à la bibliothèque ou de l''argent.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e2ba8856-7c25-5a4d-be93-21a9729222ba', '1a10a5c0-adba-527c-8b7e-2464f0ee9f67', 'francais-a2', 'Test de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('cdccd841-61cd-5510-a669-d9a1f65dd86a', 'e2ba8856-7c25-5a4d-be93-21a9729222ba', 'Lis le message :
« Salut Inès,
Je ne peux pas venir au cinéma ce soir, je suis malade. On se voit demain ? Bisous, Léa »

Pourquoi Léa écrit-elle ce message ?', '[{"id":"a","text":"Pour inviter Inès au cinéma."},{"id":"b","text":"Pour dire qu''elle ne peut pas venir."},{"id":"c","text":"Pour demander de l''argent."},{"id":"d","text":"Pour raconter un film."}]'::jsonb, 'b', 'Léa écrit « Je ne peux pas venir au cinéma ce soir » : son but est de prévenir qu''elle ne viendra pas. Ce n''est pas une invitation, et il n''est question ni d''argent ni d''un film raconté.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98e35fa0-b32e-5cd1-96ef-b5dd484860ff', 'e2ba8856-7c25-5a4d-be93-21a9729222ba', 'Lis l''annonce :
« MÉDIATHÈQUE — Ouverte du mardi au samedi, de 10 h à 19 h. Fermée le dimanche et le lundi. »

Quel jour la médiathèque est-elle ouverte ?', '[{"id":"a","text":"Le dimanche."},{"id":"b","text":"Le lundi."},{"id":"c","text":"Le mercredi."},{"id":"d","text":"Tous les jours."}]'::jsonb, 'c', 'L''annonce dit « ouverte du mardi au samedi » : le mercredi est compris dans cette période. Le dimanche et le lundi sont explicitement fermés, et elle n''est donc pas ouverte tous les jours.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('890dd7da-5b5d-5ce7-a764-d43c5edabb86', 'e2ba8856-7c25-5a4d-be93-21a9729222ba', 'Lis le courriel :
« Bonjour Monsieur Roux,
Votre commande sera livrée vendredi entre 14 h et 16 h. Merci de votre confiance. »

Quand la commande sera-t-elle livrée ?', '[{"id":"a","text":"Jeudi matin."},{"id":"b","text":"Vendredi après-midi."},{"id":"c","text":"Samedi soir."},{"id":"d","text":"Le courriel ne le précise pas."}]'::jsonb, 'b', 'Le courriel précise « livrée vendredi entre 14 h et 16 h » : c''est donc vendredi après-midi. Jeudi et samedi ne sont pas cités, et l''heure est bien donnée, donc l''option (d) est fausse.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dc108721-4168-52c3-8180-4bf7113c386c', 'e2ba8856-7c25-5a4d-be93-21a9729222ba', 'Lis la phrase :
« Le chemin était glissant à cause de la pluie, alors j''ai marché lentement. »

Que veut dire le mot « glissant » ?', '[{"id":"a","text":"Où l''on peut tomber facilement."},{"id":"b","text":"Très propre."},{"id":"c","text":"Très long."},{"id":"d","text":"Plein de monde."}]'::jsonb, 'a', '« Glissant » est lié à « la pluie » et à « j''ai marché lentement » : un sol glissant est un sol où l''on peut tomber facilement. La propreté, la longueur ou la foule n''expliquent pas la marche prudente.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1f8b2157-c3c6-5df6-97cd-79400625919e', 'e2ba8856-7c25-5a4d-be93-21a9729222ba', 'Lis le message de forum :
« Bonjour, je cherche un bon livre facile à lire en français pour débutant. Quelqu''un a une idée ? Merci ! »

Que demande l''auteur du message ?', '[{"id":"a","text":"Un conseil de lecture pour débutant."},{"id":"b","text":"L''adresse d''une librairie."},{"id":"c","text":"Le prix d''un livre."},{"id":"d","text":"Une correction de texte."}]'::jsonb, 'a', 'L''auteur écrit « je cherche un bon livre facile à lire… Quelqu''un a une idée ? » : il demande un conseil de lecture. Il ne parle ni d''adresse, ni de prix, ni de correction de texte.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('43b4f33b-efda-521b-b0b6-5e658f5f4b92', '1a10a5c0-adba-527c-8b7e-2464f0ee9f67', 'francais-a2', '⭐ Entraînement : lire des textes du quotidien', 1, 50, 10, 'practice', 'admin', 1)
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
  ('51ee5797-f336-5841-bc11-be8bbbde4639', '43b4f33b-efda-521b-b0b6-5e658f5f4b92', 'Lis le courriel :
« Bonjour Sami,
Je t''écris pour t''inviter à mon anniversaire samedi à 18 h, chez moi. Apporte juste ta bonne humeur ! Réponds-moi vite. À bientôt, Maya »

Qui organise l''anniversaire ?', '[{"id":"a","text":"Le courriel ne le dit pas."},{"id":"b","text":"Sami."},{"id":"c","text":"Un ami de Sami."},{"id":"d","text":"Maya."}]'::jsonb, 'd', 'Maya écrit « mon anniversaire » et signe à la fin : c''est donc elle qui l''organise. Sami est le destinataire (« Bonjour Sami »), pas l''auteur.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e649e8bd-7cfd-582f-a98e-126ff83a9855', '43b4f33b-efda-521b-b0b6-5e658f5f4b92', 'Lis l''annonce :
« PISCINE MUNICIPALE
Ouverte tous les jours de 9 h à 20 h.
Tarif adulte : 5 euros. Enfant : 3 euros. »

Combien paie un enfant pour entrer ?', '[{"id":"a","text":"5 euros."},{"id":"b","text":"9 euros."},{"id":"c","text":"8 euros."},{"id":"d","text":"3 euros."}]'::jsonb, 'd', 'L''annonce indique « Enfant : 3 euros » : un enfant paie donc 3 euros. 5 euros est le tarif adulte, et 9 correspond à l''heure d''ouverture, pas au prix.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9a9e5649-fb10-5002-8958-cf0cff5f43cd', '43b4f33b-efda-521b-b0b6-5e658f5f4b92', 'Lis le SMS :
« Coucou ! Je suis déjà au café. Je t''ai gardé une place près de la fenêtre. Viens quand tu veux ! — Théo »

Où se trouve Théo ?', '[{"id":"a","text":"À la maison."},{"id":"b","text":"Au cinéma."},{"id":"c","text":"Au café."},{"id":"d","text":"Au travail."}]'::jsonb, 'c', 'Théo écrit « Je suis déjà au café » : il se trouve donc au café. La maison, le cinéma et le travail ne sont pas mentionnés dans le message.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('837fc01b-664a-50df-b1b2-29c2f996a557', '43b4f33b-efda-521b-b0b6-5e658f5f4b92', 'Lis le programme :
« JOURNÉE DU SPORT
9 h : course à pied
11 h : match de football
14 h : tournoi de natation
16 h : remise des prix »

Quelle activité a lieu l''après-midi à 14 h ?', '[{"id":"a","text":"La course à pied."},{"id":"b","text":"Le match de football."},{"id":"c","text":"Le tournoi de natation."},{"id":"d","text":"La remise des prix."}]'::jsonb, 'c', 'Le programme indique « 14 h : tournoi de natation » : c''est l''activité de 14 h. La course (9 h) et le football (11 h) ont lieu le matin, et la remise des prix est à 16 h.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9dae6f2d-61f2-5429-82bd-b552fa0f570b', '43b4f33b-efda-521b-b0b6-5e658f5f4b92', 'Lis la publicité :
« NOUVEAU ! Boulangerie Le Bon Pain. Pains frais tous les matins. Venez goûter nos croissants ! Ouverture à 7 h. »

Pourquoi cette publicité a-t-elle été écrite ?', '[{"id":"a","text":"Pour annoncer une fermeture."},{"id":"b","text":"Pour chercher un employé."},{"id":"c","text":"Pour donner une recette de pain."},{"id":"d","text":"Pour attirer des clients dans la boulangerie."}]'::jsonb, 'd', 'La publicité invite « Venez goûter nos croissants ! » : son but est d''attirer des clients. Elle n''annonce pas de fermeture, ne donne pas de recette et ne cherche pas d''employé.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9509386d-e6c5-5cd7-bd83-68d4cd9bcbb7', '43b4f33b-efda-521b-b0b6-5e658f5f4b92', 'Lis la phrase :
« Le restaurant était bondé : il n''y avait plus une seule table libre. »

Que veut dire le mot « bondé » ?', '[{"id":"a","text":"Très cher."},{"id":"b","text":"Très grand."},{"id":"c","text":"Fermé."},{"id":"d","text":"Plein de monde."}]'::jsonb, 'd', '« Bondé » est expliqué par « plus une seule table libre » : cela veut dire plein de monde. La taille, l''ouverture ou le prix ne sont pas en cause ici.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f6f5fe2a-cd2b-5191-80b3-746143e7b20d', '1a10a5c0-adba-527c-8b7e-2464f0ee9f67', 'francais-a2', '⭐⭐ Révision : comprendre l''essentiel et les détails', 2, 75, 15, 'practice', 'admin', 2)
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
  ('99fe7445-81ed-547f-b4fa-1f75d6de7506', 'f6f5fe2a-cd2b-5191-80b3-746143e7b20d', 'Lis le courriel :
« Bonjour,
Notre magasin sera exceptionnellement fermé mardi prochain pour travaux. Nous rouvrirons mercredi à 9 h. Merci de votre compréhension. »

Quel est le sujet principal de ce courriel ?', '[{"id":"a","text":"Une fermeture du magasin et sa réouverture."},{"id":"b","text":"Une nouvelle collection de produits."},{"id":"c","text":"Une augmentation des prix."},{"id":"d","text":"Un changement d''adresse."}]'::jsonb, 'a', 'Le courriel annonce que le magasin « sera fermé mardi » et « rouvrira mercredi » : le sujet est la fermeture et la réouverture. Il ne parle ni de produits, ni de prix, ni d''adresse.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9cf4b8d-2218-5f64-a474-58efa77078aa', 'f6f5fe2a-cd2b-5191-80b3-746143e7b20d', 'Lis l''annonce :
« COURS DE GUITARE
Le lundi et le jeudi, de 17 h à 18 h 30.
Débutants acceptés. Premier cours gratuit ! »

À quelle heure finit le cours de guitare ?', '[{"id":"a","text":"À 17 h."},{"id":"b","text":"À 18 h."},{"id":"c","text":"À 18 h 30."},{"id":"d","text":"À 19 h."}]'::jsonb, 'c', 'L''annonce dit « de 17 h à 18 h 30 » : le cours finit donc à 18 h 30. 17 h est l''heure du début, et 18 h ou 19 h ne correspondent pas à la fin indiquée.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('283ad7ec-a5a0-5b92-83cb-2fab8cf3ffcd', 'f6f5fe2a-cd2b-5191-80b3-746143e7b20d', 'Lis le message :
« Salut Karim,
Je pars en vacances la semaine prochaine. Peux-tu arroser mes plantes et nourrir mon chat pendant mon absence ? Merci beaucoup ! Lina »

Que demande Lina à Karim ?', '[{"id":"a","text":"De venir en vacances avec elle."},{"id":"b","text":"De s''occuper de ses plantes et de son chat."},{"id":"c","text":"De lui prêter de l''argent."},{"id":"d","text":"De garder ses enfants."}]'::jsonb, 'b', 'Lina demande « Peux-tu arroser mes plantes et nourrir mon chat ? » : elle veut qu''il s''occupe de ses plantes et de son chat. Elle ne l''invite pas en vacances et ne parle ni d''argent ni d''enfants.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43d62276-34b4-564d-9f32-2f4f11d287a7', 'f6f5fe2a-cd2b-5191-80b3-746143e7b20d', 'Lis le court article :
« Hier, un grand concert a eu lieu au parc de la ville. Plus de mille personnes sont venues écouter les chanteurs. Le public était ravi malgré la pluie. »

Quand le concert a-t-il eu lieu ?', '[{"id":"a","text":"Demain."},{"id":"b","text":"La semaine prochaine."},{"id":"c","text":"Hier."},{"id":"d","text":"Dans un mois."}]'::jsonb, 'c', 'L''article commence par « Hier, un grand concert a eu lieu » : le verbe au passé composé « a eu lieu » montre que c''était hier. Les autres options annoncent le futur, ce qui contredit le texte.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2bf3a1df-e0d5-5211-9eff-a84b027ef58f', 'f6f5fe2a-cd2b-5191-80b3-746143e7b20d', 'Lis la recette :
« GÂTEAU AU YAOURT
1. Mélangez le yaourt, le sucre et les œufs.
2. Ajoutez la farine.
3. Versez dans un moule.
4. Faites cuire 30 minutes. »

Que faut-il faire en premier ?', '[{"id":"a","text":"Ajouter la farine."},{"id":"b","text":"Mélanger le yaourt, le sucre et les œufs."},{"id":"c","text":"Verser dans un moule."},{"id":"d","text":"Faire cuire 30 minutes."}]'::jsonb, 'b', 'L''étape 1 dit « Mélangez le yaourt, le sucre et les œufs » : c''est la première chose à faire. Ajouter la farine est l''étape 2, verser est l''étape 3 et la cuisson est la dernière.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dae35bdf-5a0a-539b-9142-42272fb105ec', 'f6f5fe2a-cd2b-5191-80b3-746143e7b20d', 'Lis la phrase :
« Sois prudent : la route est verglacée ce matin à cause du froid. »

Que veut dire le mot « verglacée » ?', '[{"id":"a","text":"Couverte de glace."},{"id":"b","text":"Très ensoleillée."},{"id":"c","text":"En travaux."},{"id":"d","text":"Toute neuve."}]'::jsonb, 'a', '« Verglacée » est lié à « sois prudent » et « à cause du froid » : la route est couverte de glace. Le soleil, les travaux ou la nouveauté ne justifient pas l''avertissement de prudence.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d7ad75f6-d1ea-58dc-b678-f188f694bbfe', '1a10a5c0-adba-527c-8b7e-2464f0ee9f67', 'francais-a2', '⚔️ Boss du chapitre ⭐⭐⭐ : la Porte des Parchemins', 3, 120, 30, 'boss', 'admin', 3)
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
  ('ca70079d-29a4-55a6-b89b-d2ab64db85a0', 'd7ad75f6-d1ea-58dc-b678-f188f694bbfe', 'Lis le courriel :
« Bonjour Madame Petit,
Nous vous confirmons votre réservation pour deux nuits, du vendredi 12 au dimanche 14 juin. La chambre sera prête dès 15 h le vendredi. Le petit-déjeuner est servi de 7 h à 10 h. N''oubliez pas votre pièce d''identité à l''arrivée.
Cordialement, L''Hôtel du Lac »

Combien de nuits Madame Petit va-t-elle passer à l''hôtel ?', '[{"id":"a","text":"Une nuit."},{"id":"b","text":"Trois nuits."},{"id":"c","text":"Deux nuits."},{"id":"d","text":"Le courriel ne le dit pas."}]'::jsonb, 'c', 'Le courriel précise « votre réservation pour deux nuits, du vendredi 12 au dimanche 14 » : du vendredi au dimanche, cela fait deux nuits (vendredi et samedi). « Trois » serait l''erreur de compter aussi le dimanche, jour du départ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a7666e2-58cd-5ac0-b485-f9eb43f9edf9', 'd7ad75f6-d1ea-58dc-b678-f188f694bbfe', 'Lis le même courriel :
« … La chambre sera prête dès 15 h le vendredi. Le petit-déjeuner est servi de 7 h à 10 h. N''oubliez pas votre pièce d''identité à l''arrivée. »

Que doit absolument apporter Madame Petit à l''arrivée ?', '[{"id":"a","text":"Son petit-déjeuner."},{"id":"b","text":"Une pièce d''identité."},{"id":"c","text":"Une réservation papier."},{"id":"d","text":"De la nourriture."}]'::jsonb, 'b', 'Le texte dit « N''oubliez pas votre pièce d''identité à l''arrivée » : c''est l''objet à apporter. Le petit-déjeuner est servi par l''hôtel, et ni la réservation papier ni la nourriture ne sont demandées.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8a8588d7-9d87-5119-bd73-52ebbb4a5939', 'd7ad75f6-d1ea-58dc-b678-f188f694bbfe', 'Lis le message de forum :
« Bonjour à tous ! Je viens d''arriver à Lyon pour mes études et je ne connais personne. J''aimerais rencontrer des gens et pratiquer mon français. Est-ce qu''il existe des clubs ou des activités pour étudiants étrangers ? Merci d''avance ! »

Quelle est l''intention principale de l''auteur ?', '[{"id":"a","text":"Se plaindre de la ville de Lyon."},{"id":"b","text":"Vendre des cours de français."},{"id":"c","text":"Trouver des activités pour rencontrer des gens."},{"id":"d","text":"Chercher un logement."}]'::jsonb, 'c', 'L''auteur écrit « J''aimerais rencontrer des gens » et demande « des clubs ou des activités » : son but est de trouver des activités pour faire des rencontres. Il ne se plaint pas, ne vend rien et ne cherche pas de logement.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c888859-3a45-503d-9a5d-a94e5633e4c8', 'd7ad75f6-d1ea-58dc-b678-f188f694bbfe', 'Lis le court article :
« La nouvelle ligne de bus n° 12 ouvrira le mois prochain. Elle reliera la gare au nouveau quartier en seulement vingt minutes. Les habitants attendaient ce service depuis longtemps, car le trajet était auparavant très long. »

La ligne de bus n° 12 fonctionne-t-elle déjà aujourd''hui ?', '[{"id":"a","text":"Oui, depuis longtemps."},{"id":"b","text":"Non, elle ouvrira le mois prochain."},{"id":"c","text":"Oui, depuis ce matin."},{"id":"d","text":"L''article ne le dit pas."}]'::jsonb, 'b', 'Le verbe au futur « ouvrira le mois prochain » montre que la ligne n''existe pas encore : elle fonctionnera plus tard. Le piège courant est de confondre le projet futur avec un fait déjà réalisé : « depuis longtemps » décrit l''attente, pas le service.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1540d611-eaca-5464-aceb-88a6920d1c48', 'd7ad75f6-d1ea-58dc-b678-f188f694bbfe', 'Lis le règlement :
« RÈGLEMENT DE LA BIBLIOTHÈQUE
- Le silence est obligatoire dans la salle de lecture.
- Les livres se gardent au maximum trois semaines.
- Il est interdit de manger.
- Les téléphones doivent être en mode silencieux. »

Un lecteur garde un livre pendant un mois. D''après le règlement, c''est :', '[{"id":"a","text":"Non autorisé, car la limite est de trois semaines."},{"id":"b","text":"Autorisé, car il n''y a pas de limite."},{"id":"c","text":"Autorisé seulement le week-end."},{"id":"d","text":"Le règlement ne parle pas de durée."}]'::jsonb, 'a', 'Le règlement dit « au maximum trois semaines » : un mois (environ quatre semaines) dépasse cette limite, donc ce n''est pas autorisé. Le piège est de croire qu''il n''y a pas de limite, alors qu''elle est clairement écrite.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1a2d8c6-134b-5f60-a503-5082c5306a60', 'd7ad75f6-d1ea-58dc-b678-f188f694bbfe', 'Lis le courriel :
« Salut Omar,
Merci encore pour ton aide hier ! Sans toi, je n''aurais jamais fini de déménager à temps. Je te dois bien un repas. Dis-moi quel jour tu es libre la semaine prochaine. Amitiés, Rachid »

Pourquoi Rachid écrit-il ce courriel ?', '[{"id":"a","text":"Pour demander de l''aide pour déménager."},{"id":"b","text":"Pour annuler un repas prévu."},{"id":"c","text":"Pour se plaindre du déménagement."},{"id":"d","text":"Pour remercier Omar et l''inviter à un repas."}]'::jsonb, 'd', 'Rachid écrit « Merci encore pour ton aide » et « Je te dois bien un repas » : il remercie Omar et propose de l''inviter. L''aide est déjà passée (« hier »), donc il ne la demande pas, et il n''annule rien ni ne se plaint.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a92abe5b-b0e4-5a3e-9af2-d2847d4e038c', '1a10a5c0-adba-527c-8b7e-2464f0ee9f67', 'francais-a2', '👑 Défi élite ⭐⭐⭐⭐ : maître des parchemins', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('e4dd21af-2a1b-5f70-978d-72bc4f4125a2', 'a92abe5b-b0e4-5a3e-9af2-d2847d4e038c', 'Lis le courriel :
« Bonjour à toute l''équipe,
La réunion de jeudi est reportée à vendredi, même heure, en salle 4 au lieu de la salle 2. Merci de prévenir les personnes absentes aujourd''hui. Bonne journée, La direction »

Qu''est-ce qui change par rapport à la réunion prévue au départ ?', '[{"id":"a","text":"Le jour et la salle."},{"id":"b","text":"Seulement l''heure."},{"id":"c","text":"Le sujet de la réunion."},{"id":"d","text":"Rien du tout."}]'::jsonb, 'a', 'Le courriel dit « reportée à vendredi » (le jour) et « en salle 4 au lieu de la salle 2 » (la salle) : deux choses changent. L''heure reste « la même », donc l''option (b) est fausse, et le sujet n''est pas évoqué.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eaac612b-a180-5f0d-9b20-727a9f05e8bb', 'a92abe5b-b0e4-5a3e-9af2-d2847d4e038c', 'Lis l''annonce :
« VIDE-GRENIER DU QUARTIER
Dimanche 9 h – 17 h, place du Marché.
En cas de pluie, l''événement est reporté au dimanche suivant.
Entrée gratuite pour tous. »

Que se passe-t-il s''il pleut dimanche ?', '[{"id":"a","text":"L''événement est annulé pour toujours."},{"id":"b","text":"L''événement a lieu à l''intérieur."},{"id":"c","text":"L''événement est reporté au dimanche suivant."},{"id":"d","text":"L''entrée devient payante."}]'::jsonb, 'c', 'L''annonce précise « En cas de pluie, l''événement est reporté au dimanche suivant » : il n''est pas annulé mais déplacé d''une semaine. Rien ne dit qu''il se tient à l''intérieur, et l''entrée reste gratuite.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b77989c1-876d-5699-bf4f-cb242fb87d19', 'a92abe5b-b0e4-5a3e-9af2-d2847d4e038c', 'Lis le court article :
« Lucie adore voyager. L''an dernier, elle est allée au Maroc, puis cette année elle a découvert l''Italie. L''été prochain, elle aimerait visiter le Japon. Pour elle, chaque voyage est une nouvelle aventure. »

Quel pays Lucie n''a-t-elle pas encore visité ?', '[{"id":"a","text":"Le Maroc."},{"id":"b","text":"L''Italie."},{"id":"c","text":"Tous ces pays sont déjà visités."},{"id":"d","text":"Le Japon."}]'::jsonb, 'd', 'Le Japon est annoncé au conditionnel/futur : « L''été prochain, elle aimerait visiter le Japon » : ce n''est donc pas encore fait. Le Maroc (« l''an dernier ») et l''Italie (« cette année ») sont au passé, donc déjà visités.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('194a10a3-5a06-5d07-b3ce-40d0f1f2ee7d', 'a92abe5b-b0e4-5a3e-9af2-d2847d4e038c', 'Lis le message de forum :
« Bonjour ! J''ai acheté un téléphone sur ce site il y a deux semaines, mais il ne s''allume plus depuis hier. J''ai déjà essayé de le recharger, sans succès. Quelqu''un sait-il comment contacter le service après-vente ? Merci ! »

Qu''a déjà essayé l''auteur avant d''écrire ?', '[{"id":"a","text":"De rapporter le téléphone au magasin."},{"id":"b","text":"De recharger le téléphone."},{"id":"c","text":"D''acheter un nouveau téléphone."},{"id":"d","text":"De contacter le service après-vente."}]'::jsonb, 'b', 'L''auteur écrit « J''ai déjà essayé de le recharger, sans succès » : c''est l''action déjà tentée. Il cherche justement comment contacter le service après-vente, donc il ne l''a pas encore fait, et il ne parle ni de magasin ni d''un nouvel achat.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ec4abc9-a818-506a-a1a3-5f6b5ace807d', 'a92abe5b-b0e4-5a3e-9af2-d2847d4e038c', 'Lis la publicité :
« CLUB DE SPORT FORME+
Premier mois à moitié prix !
Ouvert 7 jours sur 7. Coachs disponibles tous les soirs.
Offre valable jusqu''au 30 du mois. »

Que veut dire « Offre valable jusqu''au 30 du mois » ?', '[{"id":"a","text":"L''offre se termine le 30 du mois."},{"id":"b","text":"L''offre commence le 30 du mois."},{"id":"c","text":"On ne peut profiter de l''offre qu''après le 30."},{"id":"d","text":"L''offre dure toute l''année."}]'::jsonb, 'a', '« Valable jusqu''au 30 » signifie que l''on peut profiter de l''offre seulement avant cette date : elle se termine le 30. « Jusqu''au » marque une limite de fin, pas un début ni une durée illimitée.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5bcfb9f5-9df7-5283-ad65-ab95213e1c54', 'a92abe5b-b0e4-5a3e-9af2-d2847d4e038c', 'Lis le courriel :
« Chère Madame Dubois,
Nous avons bien reçu votre lettre. Malheureusement, nous ne pouvons pas vous rembourser, car le produit a été utilisé. En revanche, nous vous proposons un avoir de 20 euros à dépenser en magasin. Cordialement, Le service client »

Que propose le service client à Madame Dubois ?', '[{"id":"a","text":"Un remboursement complet."},{"id":"b","text":"Un avoir de 20 euros à dépenser en magasin."},{"id":"c","text":"Un nouveau produit gratuit."},{"id":"d","text":"De reprendre le produit utilisé."}]'::jsonb, 'b', 'Le courriel refuse le remboursement (« nous ne pouvons pas vous rembourser ») mais ajoute « nous vous proposons un avoir de 20 euros » : c''est l''offre faite. Le piège est de choisir le remboursement, justement refusé ; aucun produit gratuit ni reprise n''est proposé.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3b3dce45-d984-53ce-b23a-a88aff054231', '1a10a5c0-adba-527c-8b7e-2464f0ee9f67', 'francais-a2', '⭐⭐ Drill : lecture rapide tous textes', 2, 75, 15, 'practice', 'admin', 5)
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
  ('d56629f3-10a9-5d12-871b-5d635cf68c03', '3b3dce45-d984-53ce-b23a-a88aff054231', 'Lis le SMS :
« Salut ! Le film commence à 20 h 30, mais arrive vers 20 h pour qu''on ait de bonnes places. À tout à l''heure ! »

À quelle heure faut-il arriver au cinéma ?', '[{"id":"a","text":"À 20 h."},{"id":"b","text":"À 20 h 30."},{"id":"c","text":"À 21 h."},{"id":"d","text":"À 19 h 30."}]'::jsonb, 'a', 'Le SMS demande « arrive vers 20 h » : il faut donc arriver à 20 h. 20 h 30 est l''heure du début du film, pas de l''arrivée conseillée.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d492c9ad-39f1-59c3-b758-2d8965f1acc5', '3b3dce45-d984-53ce-b23a-a88aff054231', 'Lis l''annonce :
« MARCHÉ DE NOËL
Du 1er au 24 décembre, place de la Mairie.
Artisanat, gourmandises et animations pour enfants. »

Qu''est-ce qu''on trouve à ce marché ?', '[{"id":"a","text":"Des voitures d''occasion."},{"id":"b","text":"De l''artisanat et des gourmandises."},{"id":"c","text":"Des cours de langue."},{"id":"d","text":"Des animaux à adopter."}]'::jsonb, 'b', 'L''annonce cite « Artisanat, gourmandises et animations pour enfants » : on y trouve de l''artisanat et des gourmandises. Les voitures, les cours et les animaux ne sont pas mentionnés.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9601949a-6032-5c4b-b50b-f96ed0857c51', '3b3dce45-d984-53ce-b23a-a88aff054231', 'Lis le courriel :
« Bonjour,
À partir du mois prochain, notre boulangerie ouvrira aussi le dimanche matin. Nous espérons vous y accueillir nombreux ! »

La boulangerie ouvre-t-elle déjà le dimanche aujourd''hui ?', '[{"id":"a","text":"Oui, depuis toujours."},{"id":"b","text":"Oui, mais seulement l''après-midi."},{"id":"c","text":"Le courriel ne le dit pas."},{"id":"d","text":"Non, seulement à partir du mois prochain."}]'::jsonb, 'd', 'Le futur « ouvrira aussi le dimanche » et « à partir du mois prochain » montrent que ce n''est pas encore le cas : cela commencera plus tard. C''est un projet, pas un fait déjà réalisé.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6a5e1531-62b2-5d75-ad89-00a4ac41caa6', '3b3dce45-d984-53ce-b23a-a88aff054231', 'Lis le message de forum :
« Bonjour, je voudrais offrir un cadeau à ma sœur qui aime beaucoup cuisiner. Avez-vous des idées de cadeaux utiles et pas trop chers ? Merci ! »

Quel type de cadeau cherche l''auteur ?', '[{"id":"a","text":"Un cadeau pour quelqu''un qui aime cuisiner."},{"id":"b","text":"Un cadeau pour un enfant."},{"id":"c","text":"Un cadeau de sport."},{"id":"d","text":"Un cadeau très cher et de luxe."}]'::jsonb, 'a', 'L''auteur précise que sa sœur « aime beaucoup cuisiner » : il cherche donc un cadeau lié à la cuisine. Il veut quelque chose « pas trop cher », ce qui exclut le cadeau de luxe ; l''enfant et le sport ne sont pas évoqués.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49bde629-d2c7-55de-aea4-b5bcbcbed777', '3b3dce45-d984-53ce-b23a-a88aff054231', 'Lis le règlement :
« PISCINE — CONSIGNES
- Le bonnet de bain est obligatoire.
- Il est interdit de courir au bord du bassin.
- Les enfants doivent être accompagnés d''un adulte. »

Un enfant peut-il aller seul à la piscine d''après ces consignes ?', '[{"id":"a","text":"Oui, sans condition."},{"id":"b","text":"Oui, s''il sait nager."},{"id":"c","text":"Non, il doit être accompagné d''un adulte."},{"id":"d","text":"Le règlement ne parle pas des enfants."}]'::jsonb, 'c', 'La consigne dit « Les enfants doivent être accompagnés d''un adulte » : un enfant ne peut donc pas venir seul. Le fait de savoir nager n''est pas mentionné comme condition, et le règlement parle bien des enfants.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f8b29e8-30a2-5724-a7ca-f88c78e45745', '3b3dce45-d984-53ce-b23a-a88aff054231', 'Lis la phrase :
« Après cette longue marche en montagne, nous étions affamés et nous avons tout mangé. »

Que veut dire le mot « affamés » ?', '[{"id":"a","text":"Très fatigués."},{"id":"b","text":"Avoir très faim."},{"id":"c","text":"Très contents."},{"id":"d","text":"Perdus."}]'::jsonb, 'b', '« Affamés » est lié à « nous avons tout mangé » : le mot veut dire avoir très faim. La fatigue, la joie ou le fait d''être perdu n''expliquent pas le fait de tout manger.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

