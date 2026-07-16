-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: sciences-vie-terre-8eme (علوم الحياة والأرض)
-- Regenerate with: npm run content:build
-- Source of truth: content/sciences-vie-terre-8eme/
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
  ('sciences-vie-terre-8eme', 'علوم الحياة والأرض', 'التكاثر عند النبات والحيوان وتحسين الإنتاج والنظم البيئية وعلوم الأرض وفق برنامج السنة الثامنة من التعليم الأساسي', 'Vitalite', 'subject-svt', 'Leaf', 7, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '8eme-base'))
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
      AND e.subject_id = 'sciences-vie-terre-8eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('037b2e85-6130-5718-b164-5ab940649234', '11c47cac-5992-5223-b711-6503c9c42afa', '8848618c-8585-52b7-858f-d54f3c290b9b', '73907a87-342a-5af2-9f81-07bff2fabb4d', '746f174e-accb-54dc-9b02-eb7984dbc1b7', 'b50e5c82-f069-5c59-9f14-a517feeb37a4', '85a77b01-7d9d-5013-8d7b-38b9d984edb5', '20743489-0031-5ccb-9ac8-b1c76fcc34a5', 'ed696e50-7d38-5818-8d22-52b5da5ee047', 'edff8b61-4832-55c8-9177-bb10e50d8c8b', '2a03a1c7-f8c8-57bd-92f1-2156bd0bf8de', '077df22e-6ad6-5cf9-8ddd-fda5ac0f3024', '61e4e128-193e-5367-9eba-27ebbd2803a2', '2d931d2e-69b1-53ea-827d-9e2997a4e155', '275a2293-acef-591b-b2dd-5e62e9d386fc', '0d8a963e-04e4-524f-8f44-0276a3411f06', '6330ad06-c030-5c57-9ba7-1a9b19339b72', '6864b523-f443-56b2-9e9f-e193ae83b734', '9a791d06-520e-5f85-a85f-8f88d44da349', 'a85ff69e-ea17-5c53-a498-f44e13fdc12b', 'fa595ac6-c8ec-5b02-8fa8-6c99d6bfd70d', 'e60f1b9c-891a-5b6c-b821-a8af4bb74ce1', '6f2f202a-b3de-523f-bb09-ffa98338ede6', 'a6e25046-af44-5262-99da-5e2c655ae559', '52a1fe86-24c5-52b4-9aff-ee3259306b82', 'bcaeec67-1e37-5d61-9e87-607f3719db2a', '6eb1b6c7-b7b7-5702-a85b-c8692cab46f5', '49ef8acd-9569-56d9-8c85-90b86a4fd924', '80f8f48a-e72c-5422-8db8-4bfd9342ffd1', '5df8db17-11ba-533c-9ad1-216c345a45b1', 'f1c52d35-364c-5c33-be10-3cf34c9eeabc', '67d16759-289b-5815-b14d-c59b22a691c9', '96b44086-4e9c-53f8-b27f-c7f97b7f200e', 'f423630a-0355-5d72-a22c-a48c3950e172', '60c3f038-6456-50b9-9a2d-29ed23a898aa', 'dc216fa7-d29e-50fe-8a05-a3af40233ec0', '1816efba-4963-591c-9462-a117dc6cac82', '68cf55d2-c580-59ea-954a-a5d11cebda92', 'd6781f64-0718-5f33-a2e9-0ce7cfd82711', 'eccaa9b1-7224-5689-9229-bf0acc226c8e', '3b008d19-5338-5572-8717-205208dcfd3f', 'fe155b96-c66a-5f6c-9116-f3c636a38c7c', '177f2a3d-0100-51f7-af49-88ff4a2f3a98', '1da9f5db-9a81-5209-bcc2-958904d29777', '9026f41e-82cf-5c94-b397-e286f011d665', 'd58ace6d-cae5-5586-a830-aa1e4187adba', '86ea5a06-0eae-5a7e-a0c1-729e131f338b', '870b81c3-630e-50cf-b1b9-49bb3ead76c8', '84369274-206b-5f62-8539-431bc9dec9ac', 'd338630e-0afb-5c06-9d65-5db173059e21', '9db46745-6cb9-5a0d-9abd-fc4066dd19c0', '2fb3c545-31d5-567a-b5b7-baee7d4fe7be', 'ec0949c5-ec4f-5bd2-a58c-076def1c35be', '18471247-1365-5c1d-b46e-6812ab797757', '8b231eea-3e9e-5b5c-81d1-c3c10b3b09a5', 'c8b19a22-1271-5457-a4f7-6bbc7711d586', '3e3aecec-cc23-5af3-acef-34455ee6a042', '5e2f16ed-d474-5c8f-a4db-32c814ed4d6e', 'a030bd5b-51e7-55fe-ae39-6c9a49406327', '0f1b9755-5aeb-50ae-a07a-51b17457f042', '48a5e5d6-e0a6-5756-9524-9003624353ae', '3b84b82e-00d8-5788-976d-7d3e508f7eac', '6676f415-e027-536a-94fa-8f8a791d2aa1', '6602e5ee-da34-5f6d-9a80-9ed950cec77c', '0a1acc7f-2349-595d-9047-c21c6a3ca6b9', 'a05fb75d-9e4a-5999-bd34-1c797de2f8e4', '77298bc6-4489-56d5-a152-00c3aaa56b52', 'aa2e3f48-dee2-5d87-812e-8c3b533df27d', '57054bad-0452-59b3-8e09-7cfe2d90b70e', 'a1abc7c5-0da3-5c68-8baf-ba432b5455fc', 'e92d1c2c-ef08-59cb-8754-e8424175a7f2', 'b58b7f29-e0f4-5549-9597-02051a4214c8', 'b77f4784-3cbc-5b91-8508-e512017a111c', '2fda47d6-28af-5cea-ab16-a1114a672bed', '7e409bcd-0d6c-5c8f-ba8a-3c99f7a4e37f', '78f3ff70-e62c-5f5a-b5f4-3099cd15e33b', '7154b752-12b7-5575-81e5-21c60f68fe2e', 'c3ff0f7e-c41e-5031-aab4-cfe685a21d0d', 'b7ab9c4d-d0ba-5ff2-a9df-94b1d0abe0f9', 'a0a85109-299f-5175-902a-6aebcb449c05', 'dd93b15b-3954-5de9-80fb-158b72460430', 'd9714829-cd7a-58c0-a11b-b6fe71a420b9', '92da7082-38af-58ee-a6c9-d76178959f72', '89796a87-2328-5e79-af9c-cd83c1cdbe54', '9ec99fdd-60e0-532f-8faf-5d04e9030b12', '71b7cb72-d1db-5400-86c7-7ffb76d56ded', '610d4354-936f-5677-bc76-e4487ca6d660', 'e612c77f-cdf8-5f9a-ae85-f89ae1f83439', 'd5239925-72a5-59b7-a6ad-4829444edbbc', 'e572a945-cfa2-5ba7-a965-f628931db574', 'f8039c2a-7b33-5307-8071-574912e5d151', '17ea2ebf-0c6d-55ed-b16d-c06d18d669d2', 'c695ce74-0819-5c52-8607-f78297a9ffd0', '75965531-1917-53ee-b110-60c3e1ac784d', '103aff4b-3f21-5b23-ac14-f379ca906356', '3c15df48-e966-58f1-a226-b31fbc54d604', 'bfa4cb86-b1da-570c-a353-f1620ff416d0', '08611089-5e42-58db-828b-0ac1749de058', '60619f59-c5c6-5848-bd2d-89e866ec641a', '940b5dd3-d786-592c-bf16-072a6218e184', '758aa002-b787-58be-8bee-455c84d15398', 'ba377ddf-8d79-5219-adab-4d265a90c592', 'e9986fd2-0e59-5a24-b073-5124e08084a2', 'e5414e10-be3a-50c6-a30e-0fd619e71265', 'ba33abe4-50c0-5341-bf32-8c64649fc8ad', '2abf4a5a-cd0d-56d3-9c84-b73203e78d64', '51dcefb8-a7f9-5127-ae83-f916c2be53ce', 'afa5c35d-d790-5faa-9108-8e1050a79df0', '0ddc0640-d1d5-5a09-877f-0c9dc6d3a023', '58a5a4e8-55d7-5508-963b-21a9194151e5', 'a7b0d4f7-4357-525b-b0cb-0f83fdb4ab10', '18859b3d-ef88-541b-aef9-ec5244986ea1', 'd2fe60de-f50e-5002-865e-0233b1221974', '96c24100-5b37-518c-bd99-1ed1db3f29be', 'e7f76acf-7e6c-5915-a849-fe7991ff6824', '4725e5e4-34d9-54a7-be0b-dd7c6a3b2873', '3aaa8a8b-77f4-5ac1-b506-3701d54cf384', 'dbaf125d-4729-5a97-bd2c-765dc0b836f7', 'd1bbd852-a313-56ab-ac7b-55e19ae13075', 'a9419c58-e6b9-5d21-8f16-883b169d5763', 'e9d4d2bf-ec7d-50aa-b19d-85f10674628a', 'fb5c342b-1b8f-5147-93d3-9cbdaa2c9324', '069a8a32-d858-5088-b7db-74a437bd0bee', '118d531d-df3b-5816-b247-bb1ffdbd0a75', 'c70afc50-729a-57d8-abe7-7900b408f7c6', 'aed79e1d-3efb-548f-9151-ea48d73f46bc', 'd023be47-b4fc-558d-afc2-4274d0e7d40d', '932e8444-f715-5fcf-a2fc-338cb4bccca0', '3a352a02-57e9-5bad-908f-5a4ac82d478a', 'e3868f80-393c-5812-ae99-8317901b1874', '7c6eb913-6a7e-5194-83fa-b36eafce94a8', 'b8b43bc3-8b57-561e-a15f-cb14ab028e43', '349cd98a-e65e-5846-9f86-69d5e438167a', 'a7ed7228-ddfa-561c-8340-49372d028fe1', '71e6f7b2-ff10-5326-863a-d7402e7cf519', '265d643c-c84f-595d-b67e-7829da5bf08c', '19712673-db7d-5a55-912f-a0f5fc0f83fd', 'e6d18789-2a76-53bd-a5c1-4e5d1947976f', 'bf1853cc-52a1-5c7c-b927-00bf6c0df684', '37cf1301-dedd-5c2a-a931-c031642a9071', '6b7ec60a-cfba-5961-8587-c989f7f2e5b3', 'b60b9169-4fa6-5fa8-bda0-d38c54fe4dbe', '5a2d26d5-9e7f-54b8-b87c-f0724594993c', '669fc01d-38a8-5d36-a464-7c233e9e2a91', '0c3f7a07-3daa-5534-b3c2-05d51290067c', 'f08c510b-2db3-55c4-a23a-df5a301941fb', 'b8b01ea0-4608-583f-8f8d-02c29a03cdb1', 'ed181bc7-a947-5e98-abb7-4361e3de2096', 'c0f6a9d4-bdd5-528d-a786-3cbe03a366a2', '2e7e5c00-1ee1-56a7-8334-ebc960ed7979', '8b781607-4da9-5b49-aaf4-ece53ed14c64', '943538f3-4be5-5b31-b2c8-e648eed63a4c', '5842f0dd-729f-5578-9398-8d7add43e037', '8f578208-c3e8-5ecf-aba9-fcf40e6eda8f', '1f4a48a2-2626-546e-a207-b352cb650337', 'fc3136e2-cf3a-5008-a390-362d223827ee', '11a6116d-0726-5eaf-9cdd-a6239d9f1ad2', 'e305a914-2fd0-5a7a-b7fb-73edd34e99ac', '7153712d-cfa4-5ddb-958c-93931fe72726', '634f7443-0fcd-5cf0-bfaa-0ffc2b4ba9e4', '2c122595-499f-526e-a284-64b45fc0ad33', '357dac91-0182-55ac-8619-15e19e4af2e9', '2a2be6ba-5d4b-5035-8ac0-4d0af5ccead5', '8f45bd69-d56c-5f10-92f7-b334bcb19ce2', 'cb54cb1e-f1bd-5afe-a894-27eff63e4517', 'c0096a38-f8ef-573e-81e0-32ed310cd862', '8c726669-9951-5dd1-bd7b-82dc34584902', '55554351-47e3-5a44-917e-79fe4e5c061a', '861e15aa-eb53-5ca8-9436-d4b5a65a4202', '42d0067b-def0-584b-9092-3ff29278ea36', '4234efe4-a907-5de6-b2a3-fa0a14e2bae0', 'ee51b6d9-7172-5e7e-88bb-952b5bc3f59a', 'e1f91378-8b55-535b-8dd8-038d505ad155', '7950ce89-5fc5-568c-b180-e654ae97c9d1', '2599d5c9-1c2a-5f9c-a974-818b3a0ca78d', '8fce9765-d7c7-5eff-a343-d7f6c0ffa974', '7b2f760f-bd0d-505c-b719-3816551b9756', '304869d7-6632-56c2-bd18-f2ce22fa7d59', 'bc57802b-d0d6-5f93-98f5-2d8b0ef99e9b', '1bee5515-e499-556c-918d-cc2fb981f883', 'b1aa4ab9-9e75-5def-adf3-3c0deeb5096e', 'df459ef2-b872-56c1-9e7d-e7d88446242e', 'f831e819-32a1-5cf5-a0de-209a6742c785', '0b15bd21-2b5d-5e10-86c7-13ee305177f1', 'aa4fc70b-19b1-5d12-83fc-40c5484067e1', '6215aa19-fd85-5c0b-b781-8dbb65ab2eea', '8b82111c-4161-5975-a99a-2002d1708700', 'e347394c-8f6d-5367-9127-0f3e8c4d35e3', 'c8aeec27-8249-5cb7-b932-5f92a25444f8', 'c50ab1b8-eeb2-5577-a7dc-9ca621d8557c', '897d2fba-84a7-5a19-8cc6-fcbbb819f504', 'bee77870-5dcb-52a6-8273-ca478f4a340a', '260547f4-ff60-57f7-832d-d3309ea75412', 'e2967043-858d-58f5-bdd2-3d433f3f8173', '1aef321f-436f-5889-933a-aec275ddae6b', '56003f6e-ddf8-5ae4-b217-4dd00721d566', '00312414-5a2b-5c3f-b7ee-3d6a1cdbc139', '1999efdb-1ef9-5ef7-968b-e0cacc58dd1c', 'a6d4f385-0a64-5e79-97e2-e1cc1e443616', '3a0a0cf1-f5d4-59ed-95ed-67b4b73c9120', '85e2f90e-f732-5f47-a411-9139b4da0920', '2b0674cb-0469-5905-a340-1fda461920bb', '0178672c-e3b9-5586-b918-93eaf64bfac4', 'f773c1c3-b41f-5b26-8846-1cbdb7d45781', 'afdb280e-5438-5a19-8b87-e6807c4d342c', 'affaebbc-91c5-5548-9280-22bf2de964b8', '9ff03a8a-8813-5327-a8b8-76759e27a367', 'd64d25c1-d3e7-56e5-a9e2-ea76eedc90f2', '5912c721-2670-5584-80f0-e7f902b3a834', '1937bc57-9bc1-5101-967d-cddb93668959', 'ec811fe5-31b0-5674-a446-c05e75bf99e1', '4bff6b03-ee5c-5c23-9c59-f6aac9ef3f7b', 'e1458d9f-5952-575b-8138-5e5aa4ec0ae4', '9d2ce771-a035-5021-a44d-32925b0b01ea', '41da8dd1-f941-5071-b1a5-0e85c8d7d433', '6084aa67-3e9b-5af9-b7e8-bacdef624407', '71e8364a-0b06-535e-904a-b4513d139cf9', 'b5701cfa-43c1-575b-ab6c-03b8189e0755', '21d5c623-da1a-528d-9bdc-3e44c6b3e10c', '500052be-c418-5802-ba9a-2bf0ff78f5ec', 'b50efb35-d4f0-57f1-a7ad-db9fa68b0582', '77f3e415-3508-5341-a681-95fada53e170', '23525484-d92e-5e95-ad04-6691bbd49853', '9acf1d3c-8d72-5ff9-86cb-5b9aeaefadc3', '083b375f-d3b5-5863-aa13-911f75e90e6d', 'a7c504e0-6930-52e1-8f60-07880778379a', '47435d3f-e093-5dc8-9131-c8aac5154cee', '89eeca08-f7c7-5069-baae-fff4f8477e08', 'c5f2823f-df2a-5b5f-9a44-6ef2d8c3ad38', 'e095f648-bd65-5ad0-926a-defccfe3b04f', 'e034d6aa-232d-53dc-92ce-d43c4cc32c8b', 'cf0b1837-3380-5bc5-bef7-647ef17f1fe3', '19f311cf-bb34-5c64-8cf0-fee2f9866a6f', 'f1f6e72e-4489-5a22-852c-36737c380956', 'faa3b10e-c515-506d-a0a4-87f39d57c7e8', '37a0a0d1-3302-53bf-88bf-2610fa3897fa', '1c0a75e0-fd0d-5018-a8e0-48b7cf4393fb', '0a1febed-2191-5249-a28d-edc1baf7f2a5', '91cde1fa-56ec-5344-9194-b2a68e2f4629', '588b1bb2-b2e9-5d73-9c1f-a56271f1fd4f', 'a938aeb2-9f45-5427-83e1-bab1d79d1f98', '673fdb2a-da4f-5f58-aca5-d32abcb074f8', '386b1948-b165-5be3-9331-d85abfe42da2', '0db3dcfc-f0e3-5982-91cf-29dd98b03950', 'a877a821-e8e0-5736-9b56-6a682b687802', '6fd9a41e-d644-5e13-bdc8-d58aef2f20e1', '61e25641-0ff7-511e-865b-7784755e3020', '75f59b1a-5541-5e08-9bac-499a79a27fbe', '274f1e8b-705f-51af-bbf0-7c4b6935318c', '0407ef72-f9c1-5dda-927a-b4fc57e17258', '95262b1a-9973-54cb-a516-775331001b4a', 'e34e3e5c-994b-5b05-9171-cf0d86a9bc8f', 'c35b02cb-027a-5539-9593-8436b0039fa2', '3350d665-b4c2-5108-a1a4-1d6fe99bf40a', '1a1e770c-8537-544e-a1ad-791222b2abbf', '66bcd214-16d9-5f44-b4e8-5e0ec1c0bbff', '18716d4b-5ea9-562f-a95a-8049f8a29d31', '8d5be853-92c2-5e3b-9041-09737262db48', '4a2ccd4f-f2db-5faf-b947-52698d274985', '398f5a78-8df1-59bd-b26d-b59b11508ce3', '216425d8-e003-513e-af78-6523b0e2685e', 'c50a9da0-6c51-5cc1-a8d6-ffe74d554e8e', '5b6dae6e-e2fc-5253-9ce2-1b0bb22d21ed', 'c0136bbe-2e52-52b4-956c-476b4cf9575a', '01631cb6-4814-53d0-8dbd-ff7797f5b633', '6955da91-1107-55bc-a4b1-081740eb48d7', 'c98b64af-883b-5e8d-88b4-473d338183e3', '3a2ff8ca-6190-59a4-970a-d2a8ce559644', 'c509a04c-365c-5666-85c8-5d4fa59012b5', 'dfe6f248-95ec-5882-ad64-c3c427c2ce30', 'd6d87631-f17f-5241-a851-ea0b4827c70b', 'fe728fec-4022-5020-95f2-504ca63def42', 'f2108937-b37f-5510-b0ad-37cc9b57b440', '53910d10-dca1-5f9a-b1e4-7a6de392a010', '392a1227-1f52-562d-95cb-8deb35ee34a0', '10d490ed-3395-5d12-9dc1-b47d69d8e1f7', '4889149c-1535-5112-a7e8-c9596e1c648a', 'e31e2d49-2e47-5072-aa49-56aabe05846c', 'ca1c65b3-47d7-50e9-9cf7-28617a911bc4', '49d8f6a1-bde7-5608-9836-4d00d46bbf19', '24a7db6c-2406-52f0-9895-579ada6a3f10', 'b7bf674f-4963-5bc1-bbc3-b0006acd4522', '3f9aa920-be69-5b34-9039-639eb77a4ed3', 'cc856f38-c9c6-574a-a78e-70871811d90b', 'c8d1d453-d101-5f3b-92ef-7eec62679352', '7d465653-7e4d-5035-bfae-91dc90c02042', 'e44bda26-949d-5796-928c-db3da41d0265', '27ca696f-e24e-5db2-81ea-ae13ccc299d9', '86e1f500-2e88-56c1-b88d-78ab5ed9e3dd', 'b452a9a0-a0b6-59be-86d4-566f6f4ef946', '0a5f9e3b-e5bb-566c-a63f-4b23652d52af', 'fd63dcf8-8a29-54ff-b7a1-c006e8d1d7be', '9ea0e9f0-2998-5b24-aba7-64755b200d5c', '81019d7c-47ea-5ea7-9b62-5aa5481f65e4', '07ccbd12-28ca-564f-94b0-3e3cfd8d56d0', 'a5e102f3-c9bd-5c11-ac3a-ecdc66a1fdce', '6b7a8e25-0b5a-59bb-b7b0-414c74058d05', '0609b3a4-7734-5128-87ec-29e16ce11464', '8561a29c-632a-58bf-9610-567f18a29058', 'c1b35865-2bfa-54da-95df-fd31c753349b', 'c3c4df8b-54a3-5bab-b8ee-1a81087cc33b', '89ee34bb-8a4e-5bc7-a538-f0b94c635e2f', 'c9dc5040-a907-5187-b603-3eed11972adb', '65d849e9-28eb-52ab-8ae9-a11d57716e74', 'b6bfda33-c846-5021-a67a-5726ba5a00b1', 'f8c552d5-9487-576c-afde-7ea2e53d21ab', '76f2eeb9-99a3-5e86-9ecd-e25668921c18', '65077a49-8016-576a-b497-55e666cf2092', 'b1ffc666-c64a-5cb6-b65b-3343c8d22912', '40a177b9-b107-598b-a01c-ffbc4b2c5dec', '7deba26f-bf5a-5b03-9780-b6a581c014f6', 'a13f9675-b4dd-54b4-8429-55359923f8de', 'd170f475-fd36-5ed6-9d2b-fd52e4fa5b5b', '661f54df-8f14-52d5-8339-4e0b75712894', 'b0b019b0-0899-5bcd-86f9-993436977fb4', 'e48ee862-8fee-55ae-ba48-4f2a4b34db9d', '352fb790-1625-5b3b-ae8c-95db3f8cf1eb', 'c0bca24e-2b42-5375-b6cc-756da615d8c1', 'b6def6c8-bafb-5015-b2d0-9da871a3fb28', '17a7c13e-41ad-51b5-9aee-7331fbcff65f', '7266d865-f741-57c7-8ce7-62f53de384a2', '845e66b2-7bd4-557e-9ec3-1f94398f516a', 'dc8e65fb-4444-56d0-bd46-793445f1c005', 'e17780d8-a076-5766-8bba-6a49513acf41', '3d687e3d-010d-5d25-a777-70a62fa44b0c', 'a54a901f-5d9e-5112-8fd1-77d14c5d18e8', '1bf93965-be03-521e-94b5-e241baf0d800', '8c397320-b29b-5b3f-a2da-350cd063bb66');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'sciences-vie-terre-8eme' AND source = 'admin' AND id NOT IN ('48065d0a-33cd-5ee5-b533-2802a227a3cb', '32565d66-3cf6-5143-8708-ccd52cb9c5ef', '18788a03-a302-5110-9255-8db6881b174a', '58aa5e5c-8633-5c0d-ad49-e7edb4c733d1', 'c31f20c8-26e6-5065-9299-1944741f24c5', 'ab075f92-8aaa-51b7-bf2a-5b2a3924c767', '1f17cdcd-ce30-54e8-b937-041e308b84d8', 'b661058f-3f46-5d94-9ff7-bdef7386045c', '9959a780-c054-587c-a688-6f55875b4190', '8b0f237b-7d43-5a7f-876b-9a685096322c', 'e24ffbee-4222-58e7-981a-15561c53e42f', 'af76941e-c47c-534e-af10-4909c0cdb600', 'a338554a-cd0a-5ec5-a2f5-5eed2ced2141', '9c18ee77-7ff8-5b44-b92d-0410f157dbb3', '5b6d2a1c-c67d-58f4-8356-1d6e081e58c2', '769d57ea-fc3e-56b7-890e-5a034366d2b3', 'bc1d884b-979a-5f87-8903-a48674c6c13f', '8117b5dd-8e46-5f51-bf30-21683a2558d8', '45e01563-eb45-5b27-a493-99b644705361', '9ba61fcc-3cdb-5744-ad92-27d56bb27fa9', 'bd471611-27d2-5c0b-bf0b-89e05ffac5a8', '6aadf254-16b2-5987-a152-d84537cf1d25', 'dda4e91e-da70-56ad-8819-c91169b35611', '40f9b65e-d3dd-5383-ab67-9a0d792a8201', '95303c2e-c807-5bf5-9eb7-56e70eea638e', 'a17f73b5-d6e9-50f9-9d59-5c5d42fc49f1', '5daef3fb-d24a-57b1-a996-8759e50d2373', 'f02fbabe-605d-5c0b-a041-929421cf4ce4', '4b462b22-ec8f-5352-89bc-9080ea9fd40d', 'b7845e62-06f5-5884-b797-aff68bae0906', '0335245d-3a3c-5b24-a8ac-f185b490c603', '6585500e-bbed-54e4-acb9-35af02eaa808', '485e4050-9e5f-5568-aa7f-ffeb54c8195f', '614a69d9-18ef-50a5-9084-ea865afcbd26', '1b7bd92a-132a-51cd-b333-61a6c6363921', 'f00b7066-a233-5fb2-b1f6-64165b830c3e', '63baf174-368c-5650-85e3-f333aacfcea0', 'c650da8f-9831-56a7-95d5-0987d02dca32', 'e618ef9a-ce64-5db9-8ba4-080994161307', 'c68138e2-b488-5d1f-b004-75ce7e53f1d1', 'f0b8dfb1-d3bc-591f-a378-e8fb3d818b52', '5953f81c-ea4c-5752-ba12-36bfc5b11dbc', '606b9a57-725a-5478-8854-c312b034852e', '7c8c8ef4-b5f5-5b83-8f5a-013f79ca457d', 'b382a4a0-d0f1-539d-8469-514794b31ab0', '939cc2c6-e045-586b-85e4-da9c19749089', 'eee4ccc8-3933-535f-8ac8-cc400d9b08d8', '306e1117-d2cd-50f8-831c-1021c09e407c', 'b71e574c-cbc7-52ce-96c6-17506fad2e2e', '3dd505bc-5674-5aa8-8c9a-4723ef0c7b1d', 'a21ae9db-0ea7-523b-96b6-e4a6d391d1ce', '8ac69b4a-9d35-5e3f-a112-c8db0520945b', '17d15e9f-d5cb-53e0-a41a-642dc835edd1', 'cd918789-bf7f-5538-886a-668d0b256493', '8b56d09c-ff32-5fa3-a581-fb3fbc49e087', 'fa5ea997-8419-5f7a-818c-d267940bc71b');
DELETE FROM public.questions WHERE exercise_id IN ('48065d0a-33cd-5ee5-b533-2802a227a3cb', '32565d66-3cf6-5143-8708-ccd52cb9c5ef', '18788a03-a302-5110-9255-8db6881b174a', '58aa5e5c-8633-5c0d-ad49-e7edb4c733d1', 'c31f20c8-26e6-5065-9299-1944741f24c5', 'ab075f92-8aaa-51b7-bf2a-5b2a3924c767', '1f17cdcd-ce30-54e8-b937-041e308b84d8', 'b661058f-3f46-5d94-9ff7-bdef7386045c', '9959a780-c054-587c-a688-6f55875b4190', '8b0f237b-7d43-5a7f-876b-9a685096322c', 'e24ffbee-4222-58e7-981a-15561c53e42f', 'af76941e-c47c-534e-af10-4909c0cdb600', 'a338554a-cd0a-5ec5-a2f5-5eed2ced2141', '9c18ee77-7ff8-5b44-b92d-0410f157dbb3', '5b6d2a1c-c67d-58f4-8356-1d6e081e58c2', '769d57ea-fc3e-56b7-890e-5a034366d2b3', 'bc1d884b-979a-5f87-8903-a48674c6c13f', '8117b5dd-8e46-5f51-bf30-21683a2558d8', '45e01563-eb45-5b27-a493-99b644705361', '9ba61fcc-3cdb-5744-ad92-27d56bb27fa9', 'bd471611-27d2-5c0b-bf0b-89e05ffac5a8', '6aadf254-16b2-5987-a152-d84537cf1d25', 'dda4e91e-da70-56ad-8819-c91169b35611', '40f9b65e-d3dd-5383-ab67-9a0d792a8201', '95303c2e-c807-5bf5-9eb7-56e70eea638e', 'a17f73b5-d6e9-50f9-9d59-5c5d42fc49f1', '5daef3fb-d24a-57b1-a996-8759e50d2373', 'f02fbabe-605d-5c0b-a041-929421cf4ce4', '4b462b22-ec8f-5352-89bc-9080ea9fd40d', 'b7845e62-06f5-5884-b797-aff68bae0906', '0335245d-3a3c-5b24-a8ac-f185b490c603', '6585500e-bbed-54e4-acb9-35af02eaa808', '485e4050-9e5f-5568-aa7f-ffeb54c8195f', '614a69d9-18ef-50a5-9084-ea865afcbd26', '1b7bd92a-132a-51cd-b333-61a6c6363921', 'f00b7066-a233-5fb2-b1f6-64165b830c3e', '63baf174-368c-5650-85e3-f333aacfcea0', 'c650da8f-9831-56a7-95d5-0987d02dca32', 'e618ef9a-ce64-5db9-8ba4-080994161307', 'c68138e2-b488-5d1f-b004-75ce7e53f1d1', 'f0b8dfb1-d3bc-591f-a378-e8fb3d818b52', '5953f81c-ea4c-5752-ba12-36bfc5b11dbc', '606b9a57-725a-5478-8854-c312b034852e', '7c8c8ef4-b5f5-5b83-8f5a-013f79ca457d', 'b382a4a0-d0f1-539d-8469-514794b31ab0', '939cc2c6-e045-586b-85e4-da9c19749089', 'eee4ccc8-3933-535f-8ac8-cc400d9b08d8', '306e1117-d2cd-50f8-831c-1021c09e407c', 'b71e574c-cbc7-52ce-96c6-17506fad2e2e', '3dd505bc-5674-5aa8-8c9a-4723ef0c7b1d', 'a21ae9db-0ea7-523b-96b6-e4a6d391d1ce', '8ac69b4a-9d35-5e3f-a112-c8db0520945b', '17d15e9f-d5cb-53e0-a41a-642dc835edd1', 'cd918789-bf7f-5538-886a-668d0b256493', '8b56d09c-ff32-5fa3-a581-fb3fbc49e087', 'fa5ea997-8419-5f7a-818c-d267940bc71b') AND id NOT IN ('037b2e85-6130-5718-b164-5ab940649234', '11c47cac-5992-5223-b711-6503c9c42afa', '8848618c-8585-52b7-858f-d54f3c290b9b', '73907a87-342a-5af2-9f81-07bff2fabb4d', '746f174e-accb-54dc-9b02-eb7984dbc1b7', 'b50e5c82-f069-5c59-9f14-a517feeb37a4', '85a77b01-7d9d-5013-8d7b-38b9d984edb5', '20743489-0031-5ccb-9ac8-b1c76fcc34a5', 'ed696e50-7d38-5818-8d22-52b5da5ee047', 'edff8b61-4832-55c8-9177-bb10e50d8c8b', '2a03a1c7-f8c8-57bd-92f1-2156bd0bf8de', '077df22e-6ad6-5cf9-8ddd-fda5ac0f3024', '61e4e128-193e-5367-9eba-27ebbd2803a2', '2d931d2e-69b1-53ea-827d-9e2997a4e155', '275a2293-acef-591b-b2dd-5e62e9d386fc', '0d8a963e-04e4-524f-8f44-0276a3411f06', '6330ad06-c030-5c57-9ba7-1a9b19339b72', '6864b523-f443-56b2-9e9f-e193ae83b734', '9a791d06-520e-5f85-a85f-8f88d44da349', 'a85ff69e-ea17-5c53-a498-f44e13fdc12b', 'fa595ac6-c8ec-5b02-8fa8-6c99d6bfd70d', 'e60f1b9c-891a-5b6c-b821-a8af4bb74ce1', '6f2f202a-b3de-523f-bb09-ffa98338ede6', 'a6e25046-af44-5262-99da-5e2c655ae559', '52a1fe86-24c5-52b4-9aff-ee3259306b82', 'bcaeec67-1e37-5d61-9e87-607f3719db2a', '6eb1b6c7-b7b7-5702-a85b-c8692cab46f5', '49ef8acd-9569-56d9-8c85-90b86a4fd924', '80f8f48a-e72c-5422-8db8-4bfd9342ffd1', '5df8db17-11ba-533c-9ad1-216c345a45b1', 'f1c52d35-364c-5c33-be10-3cf34c9eeabc', '67d16759-289b-5815-b14d-c59b22a691c9', '96b44086-4e9c-53f8-b27f-c7f97b7f200e', 'f423630a-0355-5d72-a22c-a48c3950e172', '60c3f038-6456-50b9-9a2d-29ed23a898aa', 'dc216fa7-d29e-50fe-8a05-a3af40233ec0', '1816efba-4963-591c-9462-a117dc6cac82', '68cf55d2-c580-59ea-954a-a5d11cebda92', 'd6781f64-0718-5f33-a2e9-0ce7cfd82711', 'eccaa9b1-7224-5689-9229-bf0acc226c8e', '3b008d19-5338-5572-8717-205208dcfd3f', 'fe155b96-c66a-5f6c-9116-f3c636a38c7c', '177f2a3d-0100-51f7-af49-88ff4a2f3a98', '1da9f5db-9a81-5209-bcc2-958904d29777', '9026f41e-82cf-5c94-b397-e286f011d665', 'd58ace6d-cae5-5586-a830-aa1e4187adba', '86ea5a06-0eae-5a7e-a0c1-729e131f338b', '870b81c3-630e-50cf-b1b9-49bb3ead76c8', '84369274-206b-5f62-8539-431bc9dec9ac', 'd338630e-0afb-5c06-9d65-5db173059e21', '9db46745-6cb9-5a0d-9abd-fc4066dd19c0', '2fb3c545-31d5-567a-b5b7-baee7d4fe7be', 'ec0949c5-ec4f-5bd2-a58c-076def1c35be', '18471247-1365-5c1d-b46e-6812ab797757', '8b231eea-3e9e-5b5c-81d1-c3c10b3b09a5', 'c8b19a22-1271-5457-a4f7-6bbc7711d586', '3e3aecec-cc23-5af3-acef-34455ee6a042', '5e2f16ed-d474-5c8f-a4db-32c814ed4d6e', 'a030bd5b-51e7-55fe-ae39-6c9a49406327', '0f1b9755-5aeb-50ae-a07a-51b17457f042', '48a5e5d6-e0a6-5756-9524-9003624353ae', '3b84b82e-00d8-5788-976d-7d3e508f7eac', '6676f415-e027-536a-94fa-8f8a791d2aa1', '6602e5ee-da34-5f6d-9a80-9ed950cec77c', '0a1acc7f-2349-595d-9047-c21c6a3ca6b9', 'a05fb75d-9e4a-5999-bd34-1c797de2f8e4', '77298bc6-4489-56d5-a152-00c3aaa56b52', 'aa2e3f48-dee2-5d87-812e-8c3b533df27d', '57054bad-0452-59b3-8e09-7cfe2d90b70e', 'a1abc7c5-0da3-5c68-8baf-ba432b5455fc', 'e92d1c2c-ef08-59cb-8754-e8424175a7f2', 'b58b7f29-e0f4-5549-9597-02051a4214c8', 'b77f4784-3cbc-5b91-8508-e512017a111c', '2fda47d6-28af-5cea-ab16-a1114a672bed', '7e409bcd-0d6c-5c8f-ba8a-3c99f7a4e37f', '78f3ff70-e62c-5f5a-b5f4-3099cd15e33b', '7154b752-12b7-5575-81e5-21c60f68fe2e', 'c3ff0f7e-c41e-5031-aab4-cfe685a21d0d', 'b7ab9c4d-d0ba-5ff2-a9df-94b1d0abe0f9', 'a0a85109-299f-5175-902a-6aebcb449c05', 'dd93b15b-3954-5de9-80fb-158b72460430', 'd9714829-cd7a-58c0-a11b-b6fe71a420b9', '92da7082-38af-58ee-a6c9-d76178959f72', '89796a87-2328-5e79-af9c-cd83c1cdbe54', '9ec99fdd-60e0-532f-8faf-5d04e9030b12', '71b7cb72-d1db-5400-86c7-7ffb76d56ded', '610d4354-936f-5677-bc76-e4487ca6d660', 'e612c77f-cdf8-5f9a-ae85-f89ae1f83439', 'd5239925-72a5-59b7-a6ad-4829444edbbc', 'e572a945-cfa2-5ba7-a965-f628931db574', 'f8039c2a-7b33-5307-8071-574912e5d151', '17ea2ebf-0c6d-55ed-b16d-c06d18d669d2', 'c695ce74-0819-5c52-8607-f78297a9ffd0', '75965531-1917-53ee-b110-60c3e1ac784d', '103aff4b-3f21-5b23-ac14-f379ca906356', '3c15df48-e966-58f1-a226-b31fbc54d604', 'bfa4cb86-b1da-570c-a353-f1620ff416d0', '08611089-5e42-58db-828b-0ac1749de058', '60619f59-c5c6-5848-bd2d-89e866ec641a', '940b5dd3-d786-592c-bf16-072a6218e184', '758aa002-b787-58be-8bee-455c84d15398', 'ba377ddf-8d79-5219-adab-4d265a90c592', 'e9986fd2-0e59-5a24-b073-5124e08084a2', 'e5414e10-be3a-50c6-a30e-0fd619e71265', 'ba33abe4-50c0-5341-bf32-8c64649fc8ad', '2abf4a5a-cd0d-56d3-9c84-b73203e78d64', '51dcefb8-a7f9-5127-ae83-f916c2be53ce', 'afa5c35d-d790-5faa-9108-8e1050a79df0', '0ddc0640-d1d5-5a09-877f-0c9dc6d3a023', '58a5a4e8-55d7-5508-963b-21a9194151e5', 'a7b0d4f7-4357-525b-b0cb-0f83fdb4ab10', '18859b3d-ef88-541b-aef9-ec5244986ea1', 'd2fe60de-f50e-5002-865e-0233b1221974', '96c24100-5b37-518c-bd99-1ed1db3f29be', 'e7f76acf-7e6c-5915-a849-fe7991ff6824', '4725e5e4-34d9-54a7-be0b-dd7c6a3b2873', '3aaa8a8b-77f4-5ac1-b506-3701d54cf384', 'dbaf125d-4729-5a97-bd2c-765dc0b836f7', 'd1bbd852-a313-56ab-ac7b-55e19ae13075', 'a9419c58-e6b9-5d21-8f16-883b169d5763', 'e9d4d2bf-ec7d-50aa-b19d-85f10674628a', 'fb5c342b-1b8f-5147-93d3-9cbdaa2c9324', '069a8a32-d858-5088-b7db-74a437bd0bee', '118d531d-df3b-5816-b247-bb1ffdbd0a75', 'c70afc50-729a-57d8-abe7-7900b408f7c6', 'aed79e1d-3efb-548f-9151-ea48d73f46bc', 'd023be47-b4fc-558d-afc2-4274d0e7d40d', '932e8444-f715-5fcf-a2fc-338cb4bccca0', '3a352a02-57e9-5bad-908f-5a4ac82d478a', 'e3868f80-393c-5812-ae99-8317901b1874', '7c6eb913-6a7e-5194-83fa-b36eafce94a8', 'b8b43bc3-8b57-561e-a15f-cb14ab028e43', '349cd98a-e65e-5846-9f86-69d5e438167a', 'a7ed7228-ddfa-561c-8340-49372d028fe1', '71e6f7b2-ff10-5326-863a-d7402e7cf519', '265d643c-c84f-595d-b67e-7829da5bf08c', '19712673-db7d-5a55-912f-a0f5fc0f83fd', 'e6d18789-2a76-53bd-a5c1-4e5d1947976f', 'bf1853cc-52a1-5c7c-b927-00bf6c0df684', '37cf1301-dedd-5c2a-a931-c031642a9071', '6b7ec60a-cfba-5961-8587-c989f7f2e5b3', 'b60b9169-4fa6-5fa8-bda0-d38c54fe4dbe', '5a2d26d5-9e7f-54b8-b87c-f0724594993c', '669fc01d-38a8-5d36-a464-7c233e9e2a91', '0c3f7a07-3daa-5534-b3c2-05d51290067c', 'f08c510b-2db3-55c4-a23a-df5a301941fb', 'b8b01ea0-4608-583f-8f8d-02c29a03cdb1', 'ed181bc7-a947-5e98-abb7-4361e3de2096', 'c0f6a9d4-bdd5-528d-a786-3cbe03a366a2', '2e7e5c00-1ee1-56a7-8334-ebc960ed7979', '8b781607-4da9-5b49-aaf4-ece53ed14c64', '943538f3-4be5-5b31-b2c8-e648eed63a4c', '5842f0dd-729f-5578-9398-8d7add43e037', '8f578208-c3e8-5ecf-aba9-fcf40e6eda8f', '1f4a48a2-2626-546e-a207-b352cb650337', 'fc3136e2-cf3a-5008-a390-362d223827ee', '11a6116d-0726-5eaf-9cdd-a6239d9f1ad2', 'e305a914-2fd0-5a7a-b7fb-73edd34e99ac', '7153712d-cfa4-5ddb-958c-93931fe72726', '634f7443-0fcd-5cf0-bfaa-0ffc2b4ba9e4', '2c122595-499f-526e-a284-64b45fc0ad33', '357dac91-0182-55ac-8619-15e19e4af2e9', '2a2be6ba-5d4b-5035-8ac0-4d0af5ccead5', '8f45bd69-d56c-5f10-92f7-b334bcb19ce2', 'cb54cb1e-f1bd-5afe-a894-27eff63e4517', 'c0096a38-f8ef-573e-81e0-32ed310cd862', '8c726669-9951-5dd1-bd7b-82dc34584902', '55554351-47e3-5a44-917e-79fe4e5c061a', '861e15aa-eb53-5ca8-9436-d4b5a65a4202', '42d0067b-def0-584b-9092-3ff29278ea36', '4234efe4-a907-5de6-b2a3-fa0a14e2bae0', 'ee51b6d9-7172-5e7e-88bb-952b5bc3f59a', 'e1f91378-8b55-535b-8dd8-038d505ad155', '7950ce89-5fc5-568c-b180-e654ae97c9d1', '2599d5c9-1c2a-5f9c-a974-818b3a0ca78d', '8fce9765-d7c7-5eff-a343-d7f6c0ffa974', '7b2f760f-bd0d-505c-b719-3816551b9756', '304869d7-6632-56c2-bd18-f2ce22fa7d59', 'bc57802b-d0d6-5f93-98f5-2d8b0ef99e9b', '1bee5515-e499-556c-918d-cc2fb981f883', 'b1aa4ab9-9e75-5def-adf3-3c0deeb5096e', 'df459ef2-b872-56c1-9e7d-e7d88446242e', 'f831e819-32a1-5cf5-a0de-209a6742c785', '0b15bd21-2b5d-5e10-86c7-13ee305177f1', 'aa4fc70b-19b1-5d12-83fc-40c5484067e1', '6215aa19-fd85-5c0b-b781-8dbb65ab2eea', '8b82111c-4161-5975-a99a-2002d1708700', 'e347394c-8f6d-5367-9127-0f3e8c4d35e3', 'c8aeec27-8249-5cb7-b932-5f92a25444f8', 'c50ab1b8-eeb2-5577-a7dc-9ca621d8557c', '897d2fba-84a7-5a19-8cc6-fcbbb819f504', 'bee77870-5dcb-52a6-8273-ca478f4a340a', '260547f4-ff60-57f7-832d-d3309ea75412', 'e2967043-858d-58f5-bdd2-3d433f3f8173', '1aef321f-436f-5889-933a-aec275ddae6b', '56003f6e-ddf8-5ae4-b217-4dd00721d566', '00312414-5a2b-5c3f-b7ee-3d6a1cdbc139', '1999efdb-1ef9-5ef7-968b-e0cacc58dd1c', 'a6d4f385-0a64-5e79-97e2-e1cc1e443616', '3a0a0cf1-f5d4-59ed-95ed-67b4b73c9120', '85e2f90e-f732-5f47-a411-9139b4da0920', '2b0674cb-0469-5905-a340-1fda461920bb', '0178672c-e3b9-5586-b918-93eaf64bfac4', 'f773c1c3-b41f-5b26-8846-1cbdb7d45781', 'afdb280e-5438-5a19-8b87-e6807c4d342c', 'affaebbc-91c5-5548-9280-22bf2de964b8', '9ff03a8a-8813-5327-a8b8-76759e27a367', 'd64d25c1-d3e7-56e5-a9e2-ea76eedc90f2', '5912c721-2670-5584-80f0-e7f902b3a834', '1937bc57-9bc1-5101-967d-cddb93668959', 'ec811fe5-31b0-5674-a446-c05e75bf99e1', '4bff6b03-ee5c-5c23-9c59-f6aac9ef3f7b', 'e1458d9f-5952-575b-8138-5e5aa4ec0ae4', '9d2ce771-a035-5021-a44d-32925b0b01ea', '41da8dd1-f941-5071-b1a5-0e85c8d7d433', '6084aa67-3e9b-5af9-b7e8-bacdef624407', '71e8364a-0b06-535e-904a-b4513d139cf9', 'b5701cfa-43c1-575b-ab6c-03b8189e0755', '21d5c623-da1a-528d-9bdc-3e44c6b3e10c', '500052be-c418-5802-ba9a-2bf0ff78f5ec', 'b50efb35-d4f0-57f1-a7ad-db9fa68b0582', '77f3e415-3508-5341-a681-95fada53e170', '23525484-d92e-5e95-ad04-6691bbd49853', '9acf1d3c-8d72-5ff9-86cb-5b9aeaefadc3', '083b375f-d3b5-5863-aa13-911f75e90e6d', 'a7c504e0-6930-52e1-8f60-07880778379a', '47435d3f-e093-5dc8-9131-c8aac5154cee', '89eeca08-f7c7-5069-baae-fff4f8477e08', 'c5f2823f-df2a-5b5f-9a44-6ef2d8c3ad38', 'e095f648-bd65-5ad0-926a-defccfe3b04f', 'e034d6aa-232d-53dc-92ce-d43c4cc32c8b', 'cf0b1837-3380-5bc5-bef7-647ef17f1fe3', '19f311cf-bb34-5c64-8cf0-fee2f9866a6f', 'f1f6e72e-4489-5a22-852c-36737c380956', 'faa3b10e-c515-506d-a0a4-87f39d57c7e8', '37a0a0d1-3302-53bf-88bf-2610fa3897fa', '1c0a75e0-fd0d-5018-a8e0-48b7cf4393fb', '0a1febed-2191-5249-a28d-edc1baf7f2a5', '91cde1fa-56ec-5344-9194-b2a68e2f4629', '588b1bb2-b2e9-5d73-9c1f-a56271f1fd4f', 'a938aeb2-9f45-5427-83e1-bab1d79d1f98', '673fdb2a-da4f-5f58-aca5-d32abcb074f8', '386b1948-b165-5be3-9331-d85abfe42da2', '0db3dcfc-f0e3-5982-91cf-29dd98b03950', 'a877a821-e8e0-5736-9b56-6a682b687802', '6fd9a41e-d644-5e13-bdc8-d58aef2f20e1', '61e25641-0ff7-511e-865b-7784755e3020', '75f59b1a-5541-5e08-9bac-499a79a27fbe', '274f1e8b-705f-51af-bbf0-7c4b6935318c', '0407ef72-f9c1-5dda-927a-b4fc57e17258', '95262b1a-9973-54cb-a516-775331001b4a', 'e34e3e5c-994b-5b05-9171-cf0d86a9bc8f', 'c35b02cb-027a-5539-9593-8436b0039fa2', '3350d665-b4c2-5108-a1a4-1d6fe99bf40a', '1a1e770c-8537-544e-a1ad-791222b2abbf', '66bcd214-16d9-5f44-b4e8-5e0ec1c0bbff', '18716d4b-5ea9-562f-a95a-8049f8a29d31', '8d5be853-92c2-5e3b-9041-09737262db48', '4a2ccd4f-f2db-5faf-b947-52698d274985', '398f5a78-8df1-59bd-b26d-b59b11508ce3', '216425d8-e003-513e-af78-6523b0e2685e', 'c50a9da0-6c51-5cc1-a8d6-ffe74d554e8e', '5b6dae6e-e2fc-5253-9ce2-1b0bb22d21ed', 'c0136bbe-2e52-52b4-956c-476b4cf9575a', '01631cb6-4814-53d0-8dbd-ff7797f5b633', '6955da91-1107-55bc-a4b1-081740eb48d7', 'c98b64af-883b-5e8d-88b4-473d338183e3', '3a2ff8ca-6190-59a4-970a-d2a8ce559644', 'c509a04c-365c-5666-85c8-5d4fa59012b5', 'dfe6f248-95ec-5882-ad64-c3c427c2ce30', 'd6d87631-f17f-5241-a851-ea0b4827c70b', 'fe728fec-4022-5020-95f2-504ca63def42', 'f2108937-b37f-5510-b0ad-37cc9b57b440', '53910d10-dca1-5f9a-b1e4-7a6de392a010', '392a1227-1f52-562d-95cb-8deb35ee34a0', '10d490ed-3395-5d12-9dc1-b47d69d8e1f7', '4889149c-1535-5112-a7e8-c9596e1c648a', 'e31e2d49-2e47-5072-aa49-56aabe05846c', 'ca1c65b3-47d7-50e9-9cf7-28617a911bc4', '49d8f6a1-bde7-5608-9836-4d00d46bbf19', '24a7db6c-2406-52f0-9895-579ada6a3f10', 'b7bf674f-4963-5bc1-bbc3-b0006acd4522', '3f9aa920-be69-5b34-9039-639eb77a4ed3', 'cc856f38-c9c6-574a-a78e-70871811d90b', 'c8d1d453-d101-5f3b-92ef-7eec62679352', '7d465653-7e4d-5035-bfae-91dc90c02042', 'e44bda26-949d-5796-928c-db3da41d0265', '27ca696f-e24e-5db2-81ea-ae13ccc299d9', '86e1f500-2e88-56c1-b88d-78ab5ed9e3dd', 'b452a9a0-a0b6-59be-86d4-566f6f4ef946', '0a5f9e3b-e5bb-566c-a63f-4b23652d52af', 'fd63dcf8-8a29-54ff-b7a1-c006e8d1d7be', '9ea0e9f0-2998-5b24-aba7-64755b200d5c', '81019d7c-47ea-5ea7-9b62-5aa5481f65e4', '07ccbd12-28ca-564f-94b0-3e3cfd8d56d0', 'a5e102f3-c9bd-5c11-ac3a-ecdc66a1fdce', '6b7a8e25-0b5a-59bb-b7b0-414c74058d05', '0609b3a4-7734-5128-87ec-29e16ce11464', '8561a29c-632a-58bf-9610-567f18a29058', 'c1b35865-2bfa-54da-95df-fd31c753349b', 'c3c4df8b-54a3-5bab-b8ee-1a81087cc33b', '89ee34bb-8a4e-5bc7-a538-f0b94c635e2f', 'c9dc5040-a907-5187-b603-3eed11972adb', '65d849e9-28eb-52ab-8ae9-a11d57716e74', 'b6bfda33-c846-5021-a67a-5726ba5a00b1', 'f8c552d5-9487-576c-afde-7ea2e53d21ab', '76f2eeb9-99a3-5e86-9ecd-e25668921c18', '65077a49-8016-576a-b497-55e666cf2092', 'b1ffc666-c64a-5cb6-b65b-3343c8d22912', '40a177b9-b107-598b-a01c-ffbc4b2c5dec', '7deba26f-bf5a-5b03-9780-b6a581c014f6', 'a13f9675-b4dd-54b4-8429-55359923f8de', 'd170f475-fd36-5ed6-9d2b-fd52e4fa5b5b', '661f54df-8f14-52d5-8339-4e0b75712894', 'b0b019b0-0899-5bcd-86f9-993436977fb4', 'e48ee862-8fee-55ae-ba48-4f2a4b34db9d', '352fb790-1625-5b3b-ae8c-95db3f8cf1eb', 'c0bca24e-2b42-5375-b6cc-756da615d8c1', 'b6def6c8-bafb-5015-b2d0-9da871a3fb28', '17a7c13e-41ad-51b5-9aee-7331fbcff65f', '7266d865-f741-57c7-8ce7-62f53de384a2', '845e66b2-7bd4-557e-9ec3-1f94398f516a', 'dc8e65fb-4444-56d0-bd46-793445f1c005', 'e17780d8-a076-5766-8bba-6a49513acf41', '3d687e3d-010d-5d25-a777-70a62fa44b0c', 'a54a901f-5d9e-5112-8fd1-77d14c5d18e8', '1bf93965-be03-521e-94b5-e241baf0d800', '8c397320-b29b-5b3f-a2da-350cd063bb66');
DELETE FROM public.chapters c WHERE c.subject_id = 'sciences-vie-terre-8eme' AND c.id NOT IN ('634232e9-8b06-5b3e-a417-0e8d27211dd9', '9bb37c09-af7f-561e-ba9f-0deaa48c851b', '1ae8f90e-eb00-506e-8477-4606e82d77c5', '3f5148df-5a90-5569-8326-597ed54c33e7', '92b5eccd-cfb2-589e-bbf9-8b342e50ca10', 'ce3663d1-42ee-5b19-968c-75d46a1ea5c3', 'd40c69c1-b472-57e1-b670-cecf2a81c526', '0a3bf243-c415-57eb-b300-dcd8259e6f0d') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('634232e9-8b06-5b3e-a417-0e8d27211dd9', 'sciences-vie-terre-8eme', 'التّكاثر الخضريّ عند النّبات', 'أعضاء التّكاثر الخضريّ عند النّبات (الجذمور، الدّرنات، البصلات، السّاق الزّاحفة، الفسائل)، التّكاثر الخضريّ الطّبيعيّ، والتّكاثر الخضريّ الاصطناعيّ الذي ينجزه الإنسان (العُقَل، الترقيد، التطعيم)', '# 🌱 التّكاثر الخضريّ عند النّبات — كيف يصنع النّبات نُسَخًا من نفسه دون بذور؟

> 💡 «ليست البذرة هي الطّريق الوحيد لظهور نبتة جديدة؛ فكثيرٌ من النّباتات تتكاثر انطلاقًا من عضو خضريّ — ساق أو جذر أو ورقة — دون أن تحتاج إلى زهرة ولا بذرة.»

في هذا الفصل ستكتشف نوعًا من التّكاثر مختلفًا تمامًا عمّا تعرفه: **التّكاثر الخضريّ**. فالنّبات لا يعتمد دائمًا على الأزهار والبذور لينتج نباتات جديدة، بل يستطيع أن يصنع نُسَخًا من نفسه انطلاقًا من أحد أعضائه الخضريّة.

## 🌿 ما هو التّكاثر الخضريّ؟

**التّكاثر الخضريّ** هو تكاثر تنتج فيه نبتةٌ جديدة انطلاقًا من **عضو خضريّ** من النّبات الأمّ (ساق أو جذر أو ورقة)، **دون تدخّل الأزهار ولا البذور ولا إخصاب**. لهذا يُسمّى أيضًا **تكاثرًا لا جنسيًّا**.

النّتيجة المهمّة: النّبتة الجديدة تكون **نسخة مطابقة** للنّبات الأمّ، تحمل صفاته نفسها تمامًا (نفس اللّون، نفس نوع الثّمرة، نفس المذاق).

> ⚠️ لا تخلط بين نوعي التّكاثر عند النّبات:
>
> - **التّكاثر الجنسيّ**: يحتاج إلى **زهرة** ثمّ تأبير وإخصاب لتتكوّن **بذرة**، والنّبتة الجديدة تختلف عن أبويها.
> - **التّكاثر الخضريّ (لا جنسيّ)**: **لا زهرة ولا بذرة ولا إخصاب**، والنّبتة الجديدة نسخة مطابقة للأمّ.

## 🥔 أعضاء التّكاثر الخضريّ الطّبيعيّ

بعض النّباتات تملك أعضاء خاصّة تتكاثر بها خضريًّا في الطّبيعة دون تدخّل الإنسان. إليك أهمّها:

- **الجذمور**: ساق تنمو **أفقيًّا تحت التّربة**، تحمل براعم تعطي كلٌّ منها نبتة جديدة. مثال: **القصب** على ضفاف الأودية، ونبات **السّوسن**.
- **الدّرنة**: انتفاخ في ساق تحت أرضيّة يخزّن موادّ احتياطيّة، وعليه براعم تُسمّى **العيون** تنبت منها نباتات جديدة. المثال الأشهر: **البطاطا**.
- **البصلة**: ساق قصيرة جدًّا محاطة بأوراق سميكة مدّخِرة للغذاء، تعطي **بصيلات** جديدة تنمو نباتات مستقلّة. مثال: **البصل** و**الثّوم**.
- **السّاق الزّاحفة (المدّادة)**: ساق تزحف **أفقيًّا فوق سطح التّربة**، وتكوّن جذورًا وبراعم عند نقاط تماسّها بالأرض فتعطي نباتات جديدة. مثال: **الفراولة (الفريز)**.
- **الفسائل**: براعم تنمو من **قاعدة النّبات الأمّ** أو من جذوره، فتعطي نباتات صغيرة تُفصل لاحقًا. المثال التّونسيّ الشّهير: **فسيلة النّخيل**، وكذلك **الصّبّار** و**الموز**.

<svg viewBox="0 0 300 258">
<title>أعضاء التكاثر الخضري الطبيعي</title>
<line x1="40" y1="32" x2="152" y2="32" stroke="#d97706" stroke-width="1.4" stroke-dasharray="4 3"/>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="40" y="28" text-anchor="start" fill="#d97706" font-size="9">سطح التربة</text></g>
<path d="M 44 66 h 96" fill="none" stroke="#d97706" stroke-width="7" stroke-linecap="round"/>
<line x1="62" y1="66" x2="62" y2="24" stroke="#0f6e56" stroke-width="2.4"/>
<ellipse cx="62" cy="20" rx="5" ry="8" fill="#86efac" stroke="#0f6e56" stroke-width="1.6"/>
<line x1="62" y1="70" x2="56" y2="84" stroke="#065f46" stroke-width="1.4"/>
<line x1="62" y1="70" x2="68" y2="84" stroke="#065f46" stroke-width="1.4"/>
<line x1="96" y1="66" x2="96" y2="24" stroke="#0f6e56" stroke-width="2.4"/>
<ellipse cx="96" cy="20" rx="5" ry="8" fill="#86efac" stroke="#0f6e56" stroke-width="1.6"/>
<line x1="96" y1="70" x2="90" y2="84" stroke="#065f46" stroke-width="1.4"/>
<line x1="96" y1="70" x2="102" y2="84" stroke="#065f46" stroke-width="1.4"/>
<line x1="130" y1="66" x2="130" y2="24" stroke="#0f6e56" stroke-width="2.4"/>
<ellipse cx="130" cy="20" rx="5" ry="8" fill="#86efac" stroke="#0f6e56" stroke-width="1.6"/>
<line x1="130" y1="70" x2="124" y2="84" stroke="#065f46" stroke-width="1.4"/>
<line x1="130" y1="70" x2="136" y2="84" stroke="#065f46" stroke-width="1.4"/>
<ellipse cx="225" cy="64" rx="34" ry="22" fill="#fed7aa" stroke="#b45309" stroke-width="2"/>
<circle cx="209" cy="56" r="3" fill="#b45309"/>
<circle cx="229" cy="52" r="3" fill="#b45309"/>
<circle cx="243" cy="66" r="3" fill="#b45309"/>
<circle cx="217" cy="72" r="3" fill="#b45309"/>
<line x1="229" y1="52" x2="229" y2="34" stroke="#0f6e56" stroke-width="2.4"/>
<ellipse cx="229" cy="30" rx="5" ry="7" fill="#86efac" stroke="#0f6e56" stroke-width="1.6"/>
<line x1="209" y1="56" x2="195" y2="40" stroke="#0f172a" stroke-width="1.1"/>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="195" y="36" text-anchor="middle" fill="#b45309" font-size="10">عين</text></g>
<path d="M 40 194 A 30 39 0 0 1 100 194 Z" fill="none" stroke="#7c3aed" stroke-width="1.8"/>
<path d="M 47 194 A 23 29.900000000000002 0 0 1 93 194 Z" fill="none" stroke="#7c3aed" stroke-width="1.8"/>
<path d="M 54 194 A 16 20.8 0 0 1 86 194 Z" fill="none" stroke="#7c3aed" stroke-width="1.8"/>
<path d="M 61 194 A 9 11.700000000000001 0 0 1 79 194 Z" fill="none" stroke="#7c3aed" stroke-width="1.8"/>
<line x1="40" y1="194" x2="100" y2="194" stroke="#6d28d9" stroke-width="2.4"/>
<line x1="54" y1="194" x2="51" y2="210" stroke="#065f46" stroke-width="1.4"/>
<line x1="64" y1="194" x2="61" y2="210" stroke="#065f46" stroke-width="1.4"/>
<line x1="74" y1="194" x2="71" y2="210" stroke="#065f46" stroke-width="1.4"/>
<line x1="84" y1="194" x2="81" y2="210" stroke="#065f46" stroke-width="1.4"/>
<line x1="70" y1="156" x2="70" y2="142" stroke="#0f6e56" stroke-width="2.4"/>
<ellipse cx="70" cy="138" rx="5" ry="7" fill="#86efac" stroke="#0f6e56" stroke-width="1.6"/>
<line x1="150" y1="210" x2="300" y2="210" stroke="#d97706" stroke-width="1.6"/>
<path d="M154 210 L147 217 M166 210 L159 217 M178 210 L171 217 M190 210 L183 217 M202 210 L195 217 M214 210 L207 217 M226 210 L219 217 M238 210 L231 217 M250 210 L243 217 M262 210 L255 217 M274 210 L267 217 M286 210 L279 217" stroke="#d97706" stroke-width="1.2"/>
<line x1="172" y1="210" x2="172" y2="184" stroke="#0f6e56" stroke-width="2.6"/>
<ellipse cx="163" cy="180" rx="6" ry="9" fill="#86efac" stroke="#0f6e56" stroke-width="1.6"/>
<ellipse cx="172" cy="180" rx="6" ry="9" fill="#86efac" stroke="#0f6e56" stroke-width="1.6"/>
<ellipse cx="181" cy="180" rx="6" ry="9" fill="#86efac" stroke="#0f6e56" stroke-width="1.6"/>
<line x1="172" y1="210" x2="168" y2="224" stroke="#065f46" stroke-width="1.4"/>
<line x1="172" y1="210" x2="176" y2="224" stroke="#065f46" stroke-width="1.4"/>
<path d="M 172 206 q 40 -20, 90 -2" fill="none" stroke="#0f6e56" stroke-width="2.6"/>
<line x1="262" y1="210" x2="262" y2="192" stroke="#0f6e56" stroke-width="2.2"/>
<ellipse cx="262" cy="188" rx="5" ry="7" fill="#86efac" stroke="#0f6e56" stroke-width="1.6"/>
<line x1="262" y1="210" x2="258" y2="222" stroke="#065f46" stroke-width="1.4"/>
<line x1="262" y1="210" x2="266" y2="222" stroke="#065f46" stroke-width="1.4"/>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="220" y="180" text-anchor="middle" fill="#0f6e56" font-size="9.5">نبتة جديدة</text></g>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="92" y="116" text-anchor="middle" fill="#d97706" font-size="12.5">الجذمور</text><text x="225" y="110" text-anchor="middle" fill="#b45309" font-size="12.5">الدّرنة (بعيون)</text><text x="70" y="244" text-anchor="middle" fill="#7c3aed" font-size="12.5">البصلة</text><text x="235" y="250" text-anchor="middle" fill="#0f6e56" font-size="12.5">السّاق الزّاحفة</text></g>
</svg>


> 🗡️ في **واحة توزر**، لا يزرع الفلّاح نواة تمرة لينتج نخلة تشبه الأمّ، لأنّ نخلة النّواة قد تختلف عنها؛ بل يفصل **فسيلة** تنمو عند قاعدة النّخلة الأمّ ويغرسها، فيحصل على نخلة تحمل **صفات الأمّ نفسها** ونوع تمرها ذاته.

## 🌍 التّكاثر الخضريّ الطّبيعيّ

في التّكاثر الخضريّ **الطّبيعيّ**، يحدث كلّ شيء **دون تدخّل الإنسان**: تنتشر الجذامير والسّيقان الزّاحفة، وتنبت الدّرنات والبصلات والفسائل من تلقاء نفسها فتغزو المكان بنباتات جديدة. لهذا يصعب أحيانًا التّخلّص من نبات مثل القصب أو النّجم، لأنّه يتكاثر خضريًّا بسرعة في التّربة.

## ✂️ التّكاثر الخضريّ الاصطناعيّ

هنا **يتدخّل الإنسان** ليُكثر النّباتات التي تهمّه (أشجار مثمرة، ورود، أشجار زينة) بطرق خضريّة. أهمّ ثلاث تقنيّات:

- **العُقلة (التّعقيل)**: يأخذ الفلّاح **جزءًا** من النّبات (غصنًا أو ساقًا أو ورقة)، **يفصله ثمّ يغرسه** في التّربة أو الماء، فيكوّن جذورًا وبراعم وينمو نبتة جديدة. مثال: **الياسمين (الفلّ) التّونسيّ** و**العنب** و**التّين**.
- **الترقيد**: **يثني** الفلّاح غصنًا مرنًا من النّبات الأمّ **دون فصله**، ويطمر جزءًا منه في التّربة حتّى يكوّن جذورًا، **ثمّ يفصله** عن الأمّ ليصبح نبتة مستقلّة. مثال: **العنب** و**الياسمين**.
- **التطعيم**: يركّب الفلّاح جزءًا من نبات (يُسمّى **الطُّعم**) على نبات آخر متجذّر (يُسمّى **الحامل** أو الأصل)، فيلتحمان وينمو الطّعم معتمدًا على جذور الحامل. مثال: تطعيم **المشمش** أو **الحمضيّات** على أصل مناسب في بساتين الوطن القبليّ.

> ⚠️ لا تخلط بين التّقنيّات الثّلاث:
>
> - في **العُقلة** يُفصل الجزء عن الأمّ **أوّلًا** ثمّ يُغرس.
> - في **الترقيد** يبقى الغصن **متّصلًا** بالأمّ حتّى يجذّر، ولا يُفصل إلّا **بعد** ذلك.
> - في **التطعيم** يُجمع بين **نباتين مختلفين** (طُعم + حامل) لا جزء واحد.

| التّقنية | ما الذي يفعله الإنسان؟              | ملاحظة مميّزة                  |
| -------- | ----------------------------------- | ------------------------------ |
| العُقلة  | يفصل جزءًا من النّبات ثمّ يغرسه     | نبات واحد، يُفصل قبل الغرس     |
| الترقيد  | يثني غصنًا متّصلًا ويطمره ثمّ يفصله | يبقى متّصلًا بالأمّ حتّى يجذّر |
| التطعيم  | يركّب طُعمًا على حامل متجذّر        | نباتان مختلفان يلتحمان         |

## 🌾 لماذا يلجأ الإنسان إلى التّكاثر الخضريّ؟

- **الحفاظ على صفات النّبات الأمّ**: النّبتة الجديدة نسخة مطابقة، فيضمن الفلّاح نفس نوع الثّمرة ومذاقها.
- **السّرعة**: يحصل على نباتات جديدة أسرع من انتظار نموّها من البذرة.
- **الحصول على ثمار مبكّرة وجيّدة**، خاصّة بالتّطعيم على أصل قويّ.

> 🏆 أتقنت الآن الفرق بين التّكاثر الخضريّ (لا جنسيّ، نسخة مطابقة، دون زهرة ولا بذرة) والتّكاثر الجنسيّ، وميّزت أعضاء التّكاثر الخضريّ الطّبيعيّ (الجذمور، الدّرنة، البصلة، السّاق الزّاحفة، الفسيلة) عن تقنيّات التّكاثر الاصطناعيّ (العُقلة، الترقيد، التطعيم). في الفصل القادم ستكتشف التّكاثر الجنسيّ عند النّبات الزّهريّ!', '# 📜 ملخّص: التّكاثر الخضريّ عند النّبات

- **تعريف**: التّكاثر الخضريّ (اللّاجنسيّ) هو إنتاج نبتة جديدة انطلاقًا من عضو خضريّ (ساق أو جذر أو ورقة) من النّبات الأمّ، **دون زهرة ولا بذرة ولا إخصاب**، والنّبتة الجديدة **نسخة مطابقة** للأمّ.
- **الفرق عن التّكاثر الجنسيّ**: الجنسيّ يحتاج زهرة وإخصابًا وبذرة، والنّبتة الجديدة مختلفة؛ أمّا الخضريّ فلا يحتاج شيئًا من ذلك والنّبتة مطابقة للأمّ.
- **أعضاء التّكاثر الخضريّ الطّبيعيّ**:
  - **الجذمور**: ساق أفقيّة تحت التّربة (القصب، السّوسن).
  - **الدّرنة**: انتفاخ مدّخِر عليه عيون (البطاطا).
  - **البصلة**: ساق قصيرة بأوراق سميكة مدّخِرة (البصل، الثّوم).
  - **السّاق الزّاحفة**: تزحف فوق سطح التّربة وتجذّر عند العقد (الفراولة).
  - **الفسائل**: براعم من قاعدة النّبات الأمّ (النّخيل، الموز، الصّبّار).
- **التّكاثر الطّبيعيّ**: يحدث دون تدخّل الإنسان (انتشار الجذامير والسّيقان الزّاحفة والفسائل).
- **التّكاثر الاصطناعيّ** (بتدخّل الإنسان):
  - **العُقلة**: فصل جزء من النّبات ثمّ غرسه (الياسمين، العنب، التّين).
  - **الترقيد**: ثني غصن متّصل بالأمّ وطمره حتّى يجذّر، ثمّ فصله (العنب، الياسمين).
  - **التطعيم**: تركيب طُعم على حامل متجذّر من نبات آخر (المشمش، الحمضيّات).
- **فوائده**: الحفاظ على صفات الأمّ (نسخة مطابقة)، سرعة الإكثار، ثمار مبكّرة وجيّدة.', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('9bb37c09-af7f-561e-ba9f-0deaa48c851b', 'sciences-vie-terre-8eme', 'التكاثر الجنسي عند النبات الزهري', 'الزهرة عضوُ التكاثر الجنسي وأجزاؤها التكاثرية (الأسدية والطلع، المدقّة والمبيض والبويضات)، التأبير ونقلُ حبوب الطلع إلى الميسم، الإخصابُ واندماجُ المشيجين داخل المبيض، تكوّنُ البذرة من البويضة المخصبة والثمرة من المبيض، انتشارُ البذور وشروطُ الإنتاش', '# 🌸 التكاثر الجنسي عند النبات الزهري

> 💡 «في كلّ ربيعٍ تتفتّح أزهار اللوز في بساتين الوطن القبليّ، فتلتقي حبّةُ طلعٍ ببويضةٍ خفيّة، ومن هذا اللقاء تولد بذرةٌ تحمل حياةً جديدة.»

تعرّفت في الفصل السابق على **التكاثر الخضريّ**، حيث تنتج النبتةُ نبتةً جديدة انطلاقًا من عضوٍ خضريّ (ساق أو جذر أو ورقة) دون زهرةٍ ولا بذرة. في هذا الفصل ستكتشف نمطًا آخر مختلفًا تمامًا: **التكاثر الجنسيّ**، الذي يحتاج إلى **زهرةٍ** وإلى التقاء عنصرٍ ذكريّ بعنصرٍ أنثويّ، فينتهي بتكوّن **بذرةٍ** و**ثمرةٍ**.

## 🌼 الزهرة: عضو التكاثر الجنسي

**الزهرة** هي العضو المسؤول عن التكاثر الجنسيّ عند النباتات الزهرية. إذا لاحظت زهرةً كاملةً، مثل زهرة الخوخ أو الرمّان، وجدتها مكوّنةً من أربع مجموعاتٍ من الأوراق، من الخارج نحو الداخل:

- **الكأس**: أوراقٌ خضراء صغيرة تُسمّى **السبلات**، تحمي البرعم قبل تفتّحه.
- **التويج**: أوراقٌ ملوّنة زاهية تُسمّى **البتلات**، تجذب الحشرات بلونها ورحيقها.
- **الأعضاء الذكرية**: **الأسدية**.
- **الأعضاء الأنثوية**: **المدقّة**، في وسط الزهرة.

> ⚠️ الكأس والتويج ليسا عضوَي تكاثر: هما ورقتان واقيتان وجاذبتان فقط. الأعضاء التكاثرية الحقيقية هي **الأسدية** (ذكرية) و**المدقّة** (أنثوية).

<svg viewBox="0 0 300 310">
<title>مقطع في زهرة كاملة</title>
<polygon points="150,248 190,248 184,266 156,266" fill="#dcfce7" stroke="#0f6e56" stroke-width="2"/>
<path d="M152 244 C 95 235, 60 175, 82 108 C 108 150, 150 200, 156 240 Z" fill="#fbcfe8" stroke="#7c3aed" stroke-width="2"/>
<path d="M188 244 C 245 235, 280 175, 258 108 C 232 150, 190 200, 184 240 Z" fill="#fbcfe8" stroke="#7c3aed" stroke-width="2"/>
<polygon points="152,246 126,270 150,258" fill="#bbf7d0" stroke="#0f6e56" stroke-width="2"/>
<polygon points="188,246 214,270 190,258" fill="#bbf7d0" stroke="#0f6e56" stroke-width="2"/>
<path d="M156 244 C 140 200, 120 160, 122 124" fill="none" stroke="#d97706" stroke-width="2.4"/>
<ellipse cx="122" cy="116" rx="9" ry="13" fill="#fde68a" stroke="#d97706" stroke-width="2"/>
<path d="M184 244 C 200 200, 220 160, 218 124" fill="none" stroke="#d97706" stroke-width="2.4"/>
<ellipse cx="218" cy="116" rx="9" ry="13" fill="#fde68a" stroke="#d97706" stroke-width="2"/>
<ellipse cx="170" cy="212" rx="21" ry="30" fill="#d1fae5" stroke="#0f6e56" stroke-width="2.4"/>
<circle cx="160" cy="206" r="3.4" fill="#0f6e56"/>
<circle cx="170" cy="216" r="3.4" fill="#0f6e56"/>
<circle cx="180" cy="206" r="3.4" fill="#0f6e56"/>
<line x1="170" y1="183" x2="170" y2="112" stroke="#0f6e56" stroke-width="3"/>
<ellipse cx="163" cy="104" rx="9" ry="6" fill="#86efac" stroke="#0f6e56" stroke-width="2"/>
<ellipse cx="177" cy="104" rx="9" ry="6" fill="#86efac" stroke="#0f6e56" stroke-width="2"/>
<line x1="170" y1="96" x2="170" y2="100" stroke="#0f172a" stroke-width="1.2"/>
<line x1="214" y1="150" x2="172" y2="150" stroke="#0f172a" stroke-width="1.2"/>
<line x1="232" y1="210" x2="192" y2="211" stroke="#0f172a" stroke-width="1.2"/>
<line x1="238" y1="236" x2="176" y2="216" stroke="#0f172a" stroke-width="1.2"/>
<line x1="52" y1="116" x2="110" y2="116" stroke="#0f172a" stroke-width="1.2"/>
<line x1="56" y1="182" x2="140" y2="182" stroke="#0f172a" stroke-width="1.2"/>
<line x1="66" y1="88" x2="86" y2="120" stroke="#0f172a" stroke-width="1.2"/>
<line x1="80" y1="276" x2="138" y2="262" stroke="#0f172a" stroke-width="1.2"/>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="170" y="90" text-anchor="middle" fill="#0f172a" font-size="12">الميسم</text><text x="232" y="148" text-anchor="start" fill="#0f172a" font-size="12">القلم</text><text x="250" y="210" text-anchor="start" fill="#0f6e56" font-size="12">المبيض</text><text x="256" y="238" text-anchor="start" fill="#0f6e56" font-size="12">البويضات</text><text x="48" y="118" text-anchor="end" fill="#d97706" font-size="12">المئبر</text><text x="52" y="184" text-anchor="end" fill="#d97706" font-size="12">الخيط</text><text x="62" y="84" text-anchor="end" fill="#7c3aed" font-size="11.5">البتلة (التويج)</text><text x="76" y="280" text-anchor="end" fill="#0f6e56" font-size="11.5">السبلة (الكأس)</text></g>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="122" y="300" text-anchor="middle" fill="#d97706" font-size="11.5">سداة (ذكرية)</text><text x="218" y="300" text-anchor="middle" fill="#0f6e56" font-size="11.5">مدقّة (أنثوية)</text></g>
<line x1="122" y1="290" x2="122" y2="132" stroke="#d97706" stroke-width="1" stroke-dasharray="3 3"/>
<line x1="218" y1="290" x2="192" y2="190" stroke="#0f6e56" stroke-width="1" stroke-dasharray="3 3"/>
</svg>


## 🟡 الأعضاء الذكرية: الأسدية وحبوب الطلع

**الأسدية** هي الأعضاء **الذكرية** في الزهرة، وتكون عادةً متعدّدةً تحيط بالمدقّة. تتكوّن كلّ **سداة** من جزأين:

- **الخيط**: عنقٌ رفيع يحمل الجزء العلويّ.
- **المئبر**: كيسٌ في أعلى الخيط، ينتج ويحفظ **حبوب الطلع** (مسحوقٌ دقيق أصفر غالبًا).

**حبوب الطلع** هي التي تحمل **العنصر الذكريّ** (المشيج الذكريّ). فبدونها لا يحدث تكاثرٌ جنسيّ.

## 🟢 الأعضاء الأنثوية: المدقّة والمبيض والبويضات

**المدقّة** هي العضو **الأنثويّ**، وتوجد في **وسط الزهرة**. تتكوّن من ثلاثة أجزاء، من الأعلى نحو الأسفل:

- **الميسم**: الجزء العلويّ اللزج الذي تلتصق به حبوب الطلع.
- **القلم**: عنقٌ يصل الميسم بالمبيض.
- **المبيض**: الجزء المنتفخ في الأسفل، وبداخله **البويضات** التي تحمل **العنصر الأنثويّ** (المشيج الأنثويّ).

> ⚠️ الخطأ الأشهر هو عكس الجنسين: **الأسدية ذكرية** (تنتج الطلع) و**المدقّة أنثوية** (تحوي البويضات). لا تقلبهما أبدًا. تذكّر: المدقّة في **الوسط** وتحمل المبيض المنتفخ.

| الجزء       | العضو  | الجنس | دورُه                                      |
| ----------- | ------ | ----- | ------------------------------------------ |
| **الأسدية** | ذكريّ  | مذكّر | مئبرٌ ينتج **حبوب الطلع** (المشيج الذكريّ) |
| **المدقّة** | أنثويّ | مؤنّث | ميسم ← قلم ← **مبيضٌ** فيه **البويضات**    |

> 🔮 بعض الأزهار **خنثى** (تحمل الأسدية والمدقّة معًا في زهرةٍ واحدة، كزهرة البازلاء)، وبعضها **وحيد الجنس** (زهرةٌ ذكرية وأخرى أنثوية، كأزهار القرع). وجودُ العضوين في زهرةٍ واحدة لا يعني أنّ التأبير الذاتيّ إجباريّ، كما سترى.

## 🐝 التأبير: نقل حبوب الطلع

**التأبير** هو **انتقال حبوب الطلع من المئبر إلى ميسم المدقّة**. وهو خطوةٌ **سابقةٌ** للإخصاب وشرطٌ لحدوثه.

نميّز نوعين:

- **التأبير المباشر (الذاتيّ)**: تنتقل حبّة الطلع إلى ميسم **الزهرة نفسها** أو زهرةٍ أخرى على **النبتة نفسها**.
- **التأبير غير المباشر (الخلطيّ)**: تنتقل حبّة الطلع إلى ميسم زهرةٍ على **نبتةٍ أخرى** من النوع نفسه.

ولأنّ حبوب الطلع لا تتحرّك وحدها، فهي تحتاج إلى **عوامل نقل**:

- **الحشرات** (كالنحل والفراشات): تنجذب إلى لون البتلات ورحيقها فيعلق الطلع بأجسامها وتنقله من زهرةٍ إلى أخرى.
- **الريح**: تحمل الطلع الخفيف مسافاتٍ طويلة (كما في القمح والصنوبر).
- **الماء** عند بعض النباتات المائية، و**الإنسان** في الزراعة.

> ⚠️ لا تخلط: **التأبير = نقل حبوب الطلع فقط** (يحدث خارج المدقّة، على الميسم). أمّا اندماج العنصرين فهو **الإخصاب**، ويأتي **بعد** التأبير وداخل المبيض. التأبير لا يعني حدوث التكاثر ما لم يتبعه إخصاب.

## 💠 الإخصاب: اندماج المشيجين

بعد أن تستقرّ حبّة الطلع على الميسم، **تنبت** وتكوّن أنبوبًا دقيقًا يُسمّى **الأنبوب الطلعيّ**، ينمو نازلًا عبر القلم حتّى يبلغ **بويضةً** داخل المبيض.

هناك يحدث **الإخصاب**: **اندماج المشيج الذكريّ (من حبّة الطلع) مع المشيج الأنثويّ (البويضة)**، فتتكوّن خليّةٌ جديدة تُسمّى **البيضة المخصبة**، وهي أوّل خليّةٍ في النبتة الجديدة.

> 🗡️ الإخصاب يحدث **داخل المبيض**، لا على الميسم ولا في الهواء. والميسم مجرّد محطّة وصولٍ لحبّة الطلع؛ الرحلةُ الحقيقية تبدأ بالأنبوب الطلعيّ نحو البويضة.

## 🍅 من الزهرة إلى الثمرة: البذرة والثمرة

بعد الإخصاب تذبل البتلات والأسدية وتسقط، بينما يتضاعف نموّ جزأين اثنين فقط:

- **البويضة المخصبة (البيضة)** تتحوّل إلى **بذرة**.
- **المبيض** يتحوّل إلى **ثمرة** تحيط بالبذور وتحميها.

| قبل الإخصاب | بعد الإخصاب |
| ----------- | ----------- |
| **البويضة** | ← **بذرة**  |
| **المبيض**  | ← **ثمرة**  |

> ⚠️ لا تعكس القاعدة: **البذرة تأتي من البويضة**، و**الثمرة تأتي من المبيض**. فالثمرة (كحبّة الطماطم أو التفاحة) هي المبيض المتضخّم، وتحوي بداخلها البذور. حبّةُ اللوز التي نزرعها بذرة، والغلافُ حولها ثمرة.

تحتوي كلّ **بذرة** على **رُشيمٍ** (النبتة الصغيرة المستقبلية) و**مدّخرٍ غذائيّ** يغذّيه في بداية نموّه، ويحيط بهما **غلافٌ** واقٍ.

## 🪂 انتشار البذور

لو سقطت كلّ البذور تحت النبتة الأمّ لتزاحمت على الماء والضوء. لذلك تملك النباتات وسائل **لنشر بذورها** بعيدًا:

- **بالريح**: بذورٌ خفيفة ذات زغبٍ أو أجنحة (كالهندباء).
- **بالحيوانات**: بذورٌ ذات خطاطيف تعلق بفرو الحيوان، أو بذورٌ داخل ثمارٍ يأكلها الحيوان فتخرج بعيدًا مع فضلاته.
- **بالماء**: بذورٌ طافية تحملها الجداول والأنهار.
- **ذاتيًّا**: ثمارٌ تنفجر عند نضجها فتقذف بذورها.

> ✓ فائدة الانتشار: تجنّبُ التزاحم قرب النبتة الأمّ، وغزوُ أماكن جديدة لضمان بقاء النوع وانتشاره.

## 🌱 الإنتاش: من البذرة إلى نبتةٍ جديدة

**الإنتاش** هو **نموّ الرُّشيم داخل البذرة ليعطي نبتةً جديدة**. عند توفّر الظروف الملائمة، تنتفخ البذرة، ثمّ يخرج منها **الجذير أوّلًا نحو الأسفل** (ليثبّت النبتة ويمتصّ الماء)، ثمّ تظهر السويقة والوريقات نحو الأعلى.

يحتاج الإنتاش إلى **ثلاثة شروطٍ** معًا:

- **الماء** (لترطيب البذرة وتنشيط الرُّشيم).
- **الهواء** (الأكسجين اللازم لتنفّس الرُّشيم).
- **حرارةٌ ملائمة** (ليست باردةً جدًّا ولا حارّةً جدًّا).

> ⚠️ **الضوء ليس شرطًا للإنتاش**: كثيرٌ من البذور تنتش في الظلام تحت التراب. الضوء يصبح ضروريًّا **بعد** الإنتاش، حين تخرج الوريقات الخضراء لتصنع غذاءها. أمّا شروط الإنتاش نفسه فهي الماء والهواء والحرارة الملائمة.

يمكن التحقّق عمليًّا من هذه الشروط بتجربةٍ بسيطة: نضع بذور حمّصٍ في عدّة أوعية، ونحرم كلّ وعاءٍ من عاملٍ واحد (وعاءٌ بلا ماء، وعاءٌ في البرد، وعاءٌ مغمورٌ تمامًا في الماء بلا هواء)، ونحتفظ **بوعاء شاهدٍ** تتوفّر فيه كلّ الشروط. تنتش بذور الشاهد وحدها، فنستنتج أنّ كلّ شرطٍ ضروريّ.

> 🏆 أتقنت الآن رحلة التكاثر الجنسيّ كاملةً: من زهرةٍ بأسديتها ومدقّتها، إلى تأبيرٍ فإخصابٍ داخل المبيض، فبذرةٍ وثمرةٍ تنتشران، ثمّ إنتاشٍ يبدأ دورةً جديدة. في الفصل القادم ستكتشف كيف يحسّن الإنسان الإنتاج النباتيّ اعتمادًا على هذه المعارف!', '# 📜 ملخّص: التكاثر الجنسي عند النبات الزهري

- **الزهرة عضو التكاثر الجنسي**: من الخارج نحو الداخل: الكأس (سبلات واقية) ← التويج (بتلات ملوّنة جاذبة) ← الأعضاء التكاثرية. الكأس والتويج ليسا عضوَي تكاثر.
- **الأعضاء الذكرية = الأسدية**: كلّ سداة = خيط + **مئبر** ينتج **حبوب الطلع** (المشيج الذكريّ).
- **الأعضاء الأنثوية = المدقّة** (في وسط الزهرة): **الميسم** ← **القلم** ← **المبيض** الذي يحوي **البويضات** (المشيج الأنثويّ). ⚠️ الأسدية مذكّرة والمدقّة مؤنّثة، لا تعكسهما.
- **التأبير**: انتقال حبوب الطلع من المئبر إلى **الميسم** (ذاتيّ أو خلطيّ)، بعوامل: الحشرات، الريح، الماء، الإنسان. هو خطوةٌ **سابقة** للإخصاب لا تعني حدوثه.
- **الإخصاب**: تنبت حبّة الطلع على الميسم وتكوّن **أنبوبًا طلعيًّا** ينزل عبر القلم إلى بويضةٍ **داخل المبيض**، فيندمج المشيج الذكريّ مع الأنثويّ ← **البيضة المخصبة**. ⚠️ التأبير = نقل الطلع؛ الإخصاب = اندماج المشيجين داخل المبيض.
- **تكوّن البذرة والثمرة**: **البويضة المخصبة ← بذرة**، و**المبيض ← ثمرة** تحيط بالبذور. البذرة تحوي رُشيمًا ومدّخرًا غذائيًّا وغلافًا. ⚠️ لا تعكس: البذرة من البويضة، الثمرة من المبيض.
- **انتشار البذور**: بالريح (زغب/أجنحة)، بالحيوانات (خطاطيف/أكل الثمار)، بالماء، أو ذاتيًّا (انفجار)؛ لتجنّب التزاحم وغزو أماكن جديدة.
- **الإنتاش**: نموّ الرُّشيم ← نبتة جديدة؛ يخرج **الجذير أوّلًا نحو الأسفل**. شروطه الثلاثة: **الماء + الهواء (الأكسجين) + حرارة ملائمة**. ⚠️ الضوء ليس شرطًا للإنتاش (يلزم بعده فقط).', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('1ae8f90e-eb00-506e-8477-4606e82d77c5', 'sciences-vie-terre-8eme', 'تحسين الإنتاج النباتي', 'كيف يحسّن الفلّاح إنتاجه النباتي كمًّا وكيفًا: التهجين بين الأصناف، الانتخاب الطبيعيّ والاصطناعيّ، تقنيات الإكثار الجنسيّ والخضريّ (العُقَل، الترقيد، الفسائل، زراعة الأنسجة)، والتطعيم، مع التمييز بين ما يُحدث تنوّعًا جديدًا وما يحافظ على الصّفات المرغوبة', '# 🌾 تحسين الإنتاج النباتي — كيف يجعل الفلّاح محاصيله أوفر وأجود؟

> 💡 «لا ينتظر الفلّاح الماهر أن تمنحه الطّبيعة أفضل الثّمار صدفةً، بل يتدخّل بذكاء في تكاثر النّبات ليحصل على إنتاج أوفر كمًّا وأجود كيفًا.»

في الفصول السّابقة اكتشفت كيف يتكاثر النّبات جنسيًّا (بالبذور) وخضريًّا (دون بذور). في هذا الفصل ستكتشف كيف يستغلّ **الإنسان** هذه الطّرق ليُحسّن الإنتاج النباتي: أن يزيد **كمّية** المحصول، ويرفع **جودته** (ثمار أكبر، طعم أفضل، مقاومة للأمراض والجفاف).

## 🧬 التهجين: تزويج صنفين للحصول على هجين جديد

**التهجين** هو تلقيح اصطناعيّ بين **صنفين مختلفين** من نفس النّوع، بنقل غبار الطّلع من زهرة صنف إلى مدقّة صنف آخر. ينتج عن هذا الإخصاب بذور تعطي نبتة جديدة تُسمّى **الهجين**، تجمع صفات مرغوبة من الأبوين معًا.

- مثال: يُهجّن باحث صنف **قمح صلب** غزير الإنتاج في سهول باجة مع صنف آخر **مقاوم للجفاف**، فيحصل على هجين يجمع بين وفرة الحبوب ومقاومة قلّة الأمطار.

> ⚙️ التهجين يعتمد على **التكاثر الجنسيّ** (تلقيح + إخصاب)، ولهذا فهو **يُنشئ تركيبات جديدة** من الصّفات لم تكن موجودة في أيٍّ من الأبوين وحده.

## 🎯 الانتخاب: اختيار الأفضل والتخلّص من الرّديء

**الانتخاب** هو **اختيار** النّباتات ذات الصّفات المرغوبة (إنتاج وفير، ثمار كبيرة، مقاومة للأمراض) للإكثار منها، والتخلّص من النّباتات الرّديئة. نوعان:

- **الانتخاب الطبيعيّ**: تقوم به الطّبيعة، إذ تبقى النّباتات الأقدر على العيش في وسطها وتزول الأضعف.
- **الانتخاب الاصطناعيّ**: يقوم به **الإنسان**، فيحتفظ ببذور أو نباتات أفضل الأصناف جيلًا بعد جيل. مثال: يحتفظ فلّاح كلّ موسم ببذور أكبر حبّات **طماطم** حصل عليها، ليزرعها في الموسم المقبل.

> ⚠️ الخطأ الشّائع هو الخلط بين التهجين والانتخاب: **التهجين يُنشئ صنفًا هجينًا جديدًا** بتزويج صنفين، أمّا **الانتخاب فلا يُنشئ صفات جديدة**، بل يكتفي باختيار الأفضل من بين ما هو **موجود** أصلًا.

## 🌱 الإكثار الجنسيّ والإكثار الخضريّ: تنوّع أم مطابقة؟

بعد الحصول على نبتة ممتازة، يريد الفلّاح إكثارها. أمامه طريقان:

- **الإكثار الجنسيّ (بالبذور)**: ناتج عن تكاثر جنسيّ، فيُدخل **تنوّعًا** بين النّباتات النّاتجة (لا تكون كلّها مطابقة للأصل). هو الطّريق المستعمَل في التهجين للحصول على تركيبات جديدة.
- **الإكثار الخضريّ (اللّاجنسيّ)**: يُنتج نباتات **مطابقة تمامًا** للنّبتة الأصليّة (نُسخ)، لأنّه لا يمرّ بالإخصاب. من تقنياته:
  - **العُقَل**: غرس قطعة من ساق نبات (مثل **الدّالية / العنب**) لتُنبت جذورًا وتعطي نبتة جديدة.
  - **الترقيد**: ثني غصن نحو التّربة حتّى يُنبت جذورًا ثمّ فصله عن الأمّ.
  - **الفسائل**: فصل النّبتات الصّغيرة النّابتة حول قاعدة **نخلة التّمر** (مثل صنف دقلة النّور في واحات توزر) لزراعتها.
  - **زراعة الأنسجة**: إكثار مخبريّ سريع انطلاقًا من جزء صغير من النّبتة، للحصول على عدد كبير من النّسخ في وقت قصير.

> 🔮 فائدة الإكثار الخضريّ هي **المحافظة التّامّة على الصّفات المرغوبة** للنبتة الممتازة، وإكثارها بسرعة. لكنّه **لا يُحدث أيّ تنوّع** — الخطأ الشّائع أن يُظنّ أنّ الاستنساخ الخضريّ يخلق أصنافًا جديدة، والحقيقة أنّ التنوّع الجديد لا يأتي إلّا من التكاثر الجنسيّ (البذور، التهجين).

## 🌳 التطعيم: جمع مزايا نبتتين في شجرة واحدة

**التطعيم** تقنية إكثار خضريّ خاصّة: نُثبّت جزءًا (**الطُّعم**) مأخوذًا من صنف مرغوب (ذي ثمار جيّدة) على نبتة أخرى (**الأصل / حامل الطُّعم**) ذات جذور قويّة مقاومة. فتُعطي الشّجرة النّاتجة **ثمار الطُّعم** بفضل **جذور الأصل**.

- مثال: تُطعَّم أصناف **الحمضيّات** (البرتقال، اللّيمون) بجهة نابل على أصول مقاومة لأمراض التّربة، وتُطعَّم أشجار **الزّيتون** و**اللّوز** و**التّفاح** للحصول على ثمار جيّدة بسرعة.

> ⚠️ الطُّعم يعطي الجزء الهوائيّ والثّمار، والأصل يعطي الجذور: الخلط بين دور القطعتين خطأ شائع.

## 📈 تحسين الإنتاج كمًّا وكيفًا

كلّ هذه التّقنيات تخدم هدفين:

| الهدف           | المعنى                  | أمثلة                                                            |
| --------------- | ----------------------- | ---------------------------------------------------------------- |
| تحسين **الكمّ** | إنتاج أوفر لنفس المساحة | أصناف قمح غزيرة الحبوب، إكثار سريع بزراعة الأنسجة                |
| تحسين **الكيف** | جودة أعلى للثمار        | ثمار أكبر وأحلى، مقاومة للأمراض والجفاف، تطعيم أشجار مثمرة جيّدة |

> 🏆 أتقنت الآن كيف يتدخّل الإنسان في تكاثر النّبات لتحسين إنتاجه: التهجين لخلق تركيبات جديدة، الانتخاب لاصطفاء الأفضل، الإكثار الخضريّ والتطعيم للمحافظة على الصّفات المرغوبة وإكثارها بسرعة — كلّ ذلك لرفع الإنتاج كمًّا وكيفًا. في الفصل القادم ستكتشف عالم التكاثر عند الحيوان!', '# 📜 ملخّص: تحسين الإنتاج النباتي

- **الهدف**: يتدخّل الإنسان في تكاثر النّبات لتحسين الإنتاج **كمًّا** (محصول أوفر) و**كيفًا** (ثمار أجود، مقاومة للأمراض والجفاف).
- **التهجين**: تلقيح اصطناعيّ بين **صنفين مختلفين** يعطي **هجينًا** يجمع صفات مرغوبة من الأبوين؛ يعتمد على التكاثر الجنسيّ فيُنشئ **تركيبات جديدة**.
- **الانتخاب**: **اختيار** أفضل النّباتات والتخلّص من الرّديئة؛ طبيعيّ (تقوم به الطّبيعة) أو اصطناعيّ (يقوم به الإنسان). لا يُنشئ صفات جديدة، بل يصطفي من **الموجود**.
- **الفرق التهجين/الانتخاب**: التهجين يُنشئ صنفًا جديدًا بتزويج صنفين؛ الانتخاب يكتفي باختيار الأفضل ممّا هو موجود.
- **الإكثار الجنسيّ (بالبذور)**: يُدخل **تنوّعًا**؛ مستعمَل في التهجين.
- **الإكثار الخضريّ (اللّاجنسيّ)**: يعطي نُسخًا **مطابقة** للأصل (لا تنوّع)، ويحافظ على الصّفات المرغوبة ويُكثرها بسرعة؛ تقنياته: **العُقَل، الترقيد، الفسائل، زراعة الأنسجة**.
- **خطأ شائع**: الاستنساخ الخضريّ **لا يخلق تنوّعًا** جديدًا؛ التنوّع الجديد لا يأتي إلّا من التكاثر الجنسيّ (التهجين/البذور).
- **التطعيم**: تثبيت **طُعم** من صنف مرغوب (يعطي الثّمار) على **أصل / حامل الطُّعم** ذي جذور قويّة مقاومة؛ شائع في الزّيتون والحمضيّات واللّوز والتّفاح.', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('3f5148df-5a90-5569-8326-597ed54c33e7', 'sciences-vie-terre-8eme', 'التكاثر عند الحيوانات', 'التكاثر الجنسي عند الحيوانات: التقاء الحيوان المنوي بالبويضة والإخصاب، الإخصاب الداخلي والإخصاب الخارجي حسب الوسط، الحيوانات الولودة والحيوانات البيوضة، مراحل النموّ من نموّ مباشر إلى تحوّل (métamorphose) عند الضفدع والفراشة، ومفهوم التفريخ (incubation) الطبيعي والاصطناعي', '# 🐣 التكاثر عند الحيوانات

> 💡 «من قاع البحر إلى أعالي التلال، يضمن كلّ حيوان بقاء نوعه عبر خليّتين تتّحدان لتصنعا كائنًا جديدًا.»

عرفت في الفصول السابقة كيف يتكاثر النبات. أمّا في هذا الفصل فستكتشف كيف يتكاثر **الحيوان** تكاثرًا **جنسيًّا**: كيف تلتقي خليّتان من والدين مختلفين، وأين يحدث هذا اللقاء، ولماذا تلد بعض الحيوانات صغارها أحياءً بينما يضع بعضها الآخر بيضًا، وكيف ينمو الصغير حتّى يصبح بالغًا.

## 🥚 التكاثر الجنسي: خليّتان تتّحدان

**التكاثر الجنسي** عند الحيوانات يحتاج دائمًا إلى **والدين**: **ذكر** و**أنثى**. لكلّ منهما خليّة تكاثرية خاصّة تُسمّى **العُرس** (خليّة جنسية):

- ينتج **الذكر** خلايا صغيرة متحرّكة تُسمّى **الحيوانات المنوية**.
- تنتج **الأنثى** خليّة أكبر غير متحرّكة تُسمّى **البويضة**.

**الإخصاب** هو **التقاء حيوان منوي واحد بالبويضة واندماجهما** في خليّة واحدة تُسمّى **البيضة المخصّبة**. من هذه البيضة المخصّبة ينمو الكائن الجديد.

> ⚠️ الخطأ الشائع أن نظنّ أنّ الأنثى وحدها تكفي للتكاثر الجنسي. لا: لا بدّ من **حيوان منوي من الذكر** يُخصِب **بويضة الأنثى**؛ فبدون إخصاب لا تنمو البويضة إلى كائن جديد.

## 🌊 الإخصاب الداخلي والإخصاب الخارجي

يختلف **مكان** التقاء الحيوان المنوي بالبويضة من حيوان إلى آخر، فنميّز نوعين من الإخصاب:

- **الإخصاب الداخلي**: يلتقي الحيوان المنوي بالبويضة **داخل جسم الأنثى** بعد تزاوج الذكر والأنثى. لا يحتاج إلى ماء، لذلك نجده عند الحيوانات التي تتكاثر خارج الماء: الثدييات (كالجمل والأرنب)، الطيور (كالنورس)، الزواحف (كالسلحفاة)، والحشرات.
- **الإخصاب الخارجي**: يطرح الذكر حيواناته المنوية والأنثى بويضاتها **في الماء**، فيلتقيان **خارج جسم الأنثى**. يحتاج هذا الإخصاب إلى وسط مائي، لذلك نجده عند معظم الأسماك (كالسردين) والبرمائيات (كالضفدع) التي تتكاثر في الماء.

> ⚠️ لا تربط نوع الإخصاب بمكان **عيش** الحيوان، بل بمكان **تكاثره**: فالدلفين والسلحفاة البحرية يعيشان في الماء لكنّهما يتكاثران بإخصاب **داخلي** (الدلفين يتزاوج، والسلحفاة تخرج إلى الشاطئ لتضع بيضها). الإخصاب الخارجي يقتصر على من يطرح خلاياه التكاثرية **مباشرة في الماء**.

## 🐣 حيوانات ولودة وحيوانات بيوضة

بحسب طريقة قدوم الصغير إلى الحياة، نصنّف الحيوانات إلى صنفين:

- **حيوان ولود**: ينمو الصغير **داخل جسم الأمّ** ويتغذّى منها، ثمّ يولد **حيًّا** (الولادة). كلّ **الثدييات** ولودة: الجمل، الأرنب، الخروف، القطّ، وحتّى الدلفين والحوت رغم عيشهما في الماء.
- **حيوان بيوض**: تضع الأنثى **بيضًا** خارج جسمها، وينمو الصغير **داخل البيضة** ثمّ يخرج منها عند **الفقس**. الطيور والأسماك والزواحف والبرمائيات والحشرات حيوانات بيوضة.

> ⚠️ **أخطر خطأ في هذا الفصل**: الخلط بين **نوع الإخصاب** و**الولودة/البيوضة**. الإخصاب الداخلي **لا يعني** أنّ الحيوان ولود! فالنورس والسلحفاة يتكاثران بإخصاب **داخلي** لكنّهما **بيوضان** يضعان بيضًا. القاعدة: الإخصاب الخارجي بيوض دائمًا (البيض في الماء)، أمّا الإخصاب الداخلي فقد يكون بيوضًا (طيور، زواحف، حشرات) أو ولودًا (الثدييات وحدها).

| الصنف    | كيف يأتي الصغير؟                       | أمثلة                                         |
| -------- | -------------------------------------- | --------------------------------------------- |
| **ولود** | يولد حيًّا بعد نموّه داخل جسم الأمّ    | الثدييات: الجمل، الأرنب، الدلفين              |
| **بيوض** | يخرج من بيضة توضع خارج الجسم عند الفقس | الطيور، الأسماك، الزواحف، البرمائيات، الحشرات |

## 🦋 مراحل النموّ: نموّ مباشر وتحوّل

بعد الولادة أو الفقس، ينمو الصغير حتّى يبلغ. لكنّ طريقة نموّه ليست واحدة عند جميع الحيوانات:

- **النموّ المباشر**: يشبه الصغير **الوالدين منذ ولادته أو فقسه**، ولا يتغيّر شكله العامّ، بل يكبر حجمه فقط حتّى يصبح بالغًا. مثال: صغير الجمل يشبه أمّه، وفرخ النورس يشبه أبويه.
- **النموّ بالتحوّل (métamorphose)**: يولد الصغير في شكل **مختلف تمامًا** عن البالغ، ثمّ يمرّ بمراحل يتغيّر فيها شكله جذريًّا. مثالان مهمّان:

**تحوّل الضفدع** (برمائي):

> البيضة ← الشرغوف (يعيش في الماء، له ذيل وخياشيم) ← ضفدع صغير (تنمو أطرافه ويختفي ذيله) ← الضفدع البالغ (يعيش على اليابسة ويتنفّس برئتين).

<svg viewBox="0 0 300 300">
<title>تحوّل الضفدع: دورة من أربع مراحل</title>
<circle cx="136" cy="54" r="7" fill="#e0f2fe" stroke="#2563eb" stroke-width="1.6"/>
<circle cx="136" cy="54" r="2.6" fill="#0f172a"/>
<circle cx="148" cy="48" r="7" fill="#e0f2fe" stroke="#2563eb" stroke-width="1.6"/>
<circle cx="148" cy="48" r="2.6" fill="#0f172a"/>
<circle cx="160" cy="56" r="7" fill="#e0f2fe" stroke="#2563eb" stroke-width="1.6"/>
<circle cx="160" cy="56" r="2.6" fill="#0f172a"/>
<circle cx="144" cy="64" r="7" fill="#e0f2fe" stroke="#2563eb" stroke-width="1.6"/>
<circle cx="144" cy="64" r="2.6" fill="#0f172a"/>
<circle cx="156" cy="64" r="7" fill="#e0f2fe" stroke="#2563eb" stroke-width="1.6"/>
<circle cx="156" cy="64" r="2.6" fill="#0f172a"/>
<circle cx="150" cy="57" r="7" fill="#e0f2fe" stroke="#2563eb" stroke-width="1.6"/>
<circle cx="150" cy="57" r="2.6" fill="#0f172a"/>
<path d="M 250 144 Q 276 138, 286 150 Q 276 162, 250 156 Z" fill="#dcfce7" stroke="#0f6e56" stroke-width="2"/>
<ellipse cx="238" cy="150" rx="15" ry="11" fill="#bbf7d0" stroke="#0f6e56" stroke-width="2"/>
<circle cx="233" cy="147" r="2.4" fill="#0f172a"/>
<ellipse cx="150" cy="250" rx="17" ry="13" fill="#86efac" stroke="#0f6e56" stroke-width="2"/>
<path d="M 165 252 q 12 4, 16 12" fill="none" stroke="#0f6e56" stroke-width="2.4"/>
<path d="M 138 258 q -8 6, -4 14" fill="none" stroke="#0f6e56" stroke-width="2.4"/>
<path d="M 158 259 q 8 6, 4 13" fill="none" stroke="#0f6e56" stroke-width="2.4"/>
<circle cx="144" cy="246" r="2.4" fill="#0f172a"/>
<circle cx="156" cy="246" r="2.4" fill="#0f172a"/>
<ellipse cx="56" cy="150" rx="22" ry="16" fill="#0f6e56" stroke="#065f46" stroke-width="2"/>
<circle cx="47" cy="138" r="5" fill="#0f6e56" stroke="#065f46" stroke-width="1.6"/>
<circle cx="65" cy="138" r="5" fill="#0f6e56" stroke="#065f46" stroke-width="1.6"/>
<circle cx="47" cy="138" r="2" fill="#0f172a"/>
<circle cx="65" cy="138" r="2" fill="#0f172a"/>
<path d="M 40 160 q -12 4, -14 16 q 8 -2, 12 2" fill="none" stroke="#065f46" stroke-width="2.4"/>
<path d="M 72 160 q 12 4, 14 16 q -8 -2, -12 2" fill="none" stroke="#065f46" stroke-width="2.4"/>
<line x1="196" y1="78" x2="226" y2="116" stroke="#0f172a" stroke-width="2.5"/>
<polygon points="226,116 216.89,111.72 223.96,106.15" fill="#0f172a"/>
<line x1="224" y1="196" x2="190" y2="228" stroke="#0f172a" stroke-width="2.5"/>
<polygon points="190,228 193.47,218.55 199.64,225.11" fill="#0f172a"/>
<line x1="104" y1="224" x2="74" y2="190" stroke="#0f172a" stroke-width="2.5"/>
<polygon points="74,190 83.33,193.77 76.58,199.73" fill="#0f172a"/>
<line x1="72" y1="112" x2="106" y2="80" stroke="#0f172a" stroke-width="2.5"/>
<polygon points="106,80 102.53,89.45 96.36,82.89" fill="#0f172a"/>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="150" y="156" text-anchor="middle" fill="#d97706" font-size="12.5">دورة التحوّل</text></g>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="150" y="26" text-anchor="middle" fill="#2563eb" font-size="13">البيضة</text><text x="252" y="182" text-anchor="middle" fill="#0f6e56" font-size="13">الشرغوف</text><text x="150" y="286" text-anchor="middle" fill="#0f6e56" font-size="13">ضفدع صغير</text><text x="56" y="196" text-anchor="middle" fill="#065f46" font-size="13">الضفدع البالغ</text></g>
</svg>


**تحوّل الفراشة** (حشرة):

> البيضة ← اليرقة (دودة تأكل الأوراق) ← الخادرة (طور ساكن داخل شرنقة) ← الفراشة البالغة.

> ⚠️ ترتيب المراحل ثابت لا يتغيّر ولا يُعكس. لا يمكن أن تسبق **الخادرة** اليرقةَ، ولا أن يتحوّل الضفدع البالغ إلى شرغوف. التحوّل يسير دائمًا من البيضة نحو البالغ في اتّجاه واحد.

## 🔥 التفريخ (incubation)

حتّى تنمو البيضة عند الحيوانات البيوضة البرّية (خاصّة الطيور)، تحتاج إلى **حرارة مناسبة** طوال مدّة معيّنة. هذه العملية تُسمّى **التفريخ**: توفير الحرارة اللازمة للبيضة المخصّبة حتّى يكتمل نموّ الجنين داخلها ويخرج عند **الفقس**.

نميّز نوعين من التفريخ:

- **التفريخ الطبيعي**: تحتضن الأنثى (أو الأبوان) البيض بجسمها الدافئ طوال مدّة التفريخ. مثلًا تحتضن الدجاجة بيضها نحو 21 يومًا قبل أن يفقس إلى فراخ.
- **التفريخ الاصطناعي**: يوضع البيض داخل جهاز يُسمّى **المفرخة** (الحاضنة) يوفّر الحرارة والرطوبة المناسبتين آليًّا، فتفقس أعداد كبيرة من البيض دفعةً واحدة. تعتمد المداجن التونسية هذا الأسلوب لإنتاج كمّيات كبيرة من الفراخ.

> ✓ الإخصاب شرط أوّل لا غنى عنه: **البيضة غير المخصّبة لا يخرج منها فرخ مهما طال تفريخها**، لأنّها لا تحمل جنينًا أصلًا. التفريخ يوفّر الحرارة فقط، لكنّه لا يعوّض غياب الإخصاب.

> 🏆 صرت الآن تعرف كيف يتكاثر الحيوان جنسيًّا: التقاء حيوان منوي ببويضة (إخصاب داخلي أو خارجي)، ثمّ قدوم الصغير ولادةً أو فقسًا، ونموّه نموًّا مباشرًا أو بالتحوّل، مع دور التفريخ في بيض الطيور. في الفصل القادم ستكتشف كيف يحسّن الإنسان الإنتاج الحيواني!', '# 📜 ملخّص: التكاثر عند الحيوانات

- **التكاثر الجنسي**: يحتاج إلى **ذكر** (ينتج **الحيوانات المنوية**) و**أنثى** (تنتج **البويضة**). **الإخصاب** = التقاء حيوان منوي بالبويضة واندماجهما في **بيضة مخصّبة** ينمو منها الكائن الجديد.
- **الإخصاب الداخلي**: يلتقي الحيوان المنوي بالبويضة **داخل جسم الأنثى** بعد التزاوج (الثدييات، الطيور، الزواحف، الحشرات) — لا يحتاج ماءً.
- **الإخصاب الخارجي**: تُطرح الخلايا التكاثرية **في الماء** ويحدث اللقاء **خارج جسم الأنثى** (معظم الأسماك والبرمائيات) — يحتاج وسطًا مائيًّا. العبرة بمكان **التكاثر** لا مكان العيش (الدلفين والسلحفاة مائيان بإخصاب داخلي).
- **ولود / بيوض**: **الولود** يولد حيًّا بعد نموّه داخل جسم الأمّ (كلّ الثدييات، حتّى الدلفين)؛ **البيوض** يخرج من بيضة توضع خارج الجسم عند **الفقس** (الطيور، الأسماك، الزواحف، البرمائيات، الحشرات). ⚠️ الإخصاب الداخلي **لا يعني** ولودًا: النورس والسلحفاة داخليّا الإخصاب لكنّهما **بيوضان**.
- **مراحل النموّ**: **نموّ مباشر** (الصغير يشبه البالغ ويكبر فقط: الجمل، النورس) أو **تحوّل (métamorphose)** حيث يتغيّر الشكل جذريًّا بترتيب ثابت لا يُعكس — الضفدع: بيضة ← شرغوف ← ضفدع بالغ؛ الفراشة: بيضة ← يرقة ← خادرة ← فراشة.
- **التفريخ (incubation)**: توفير الحرارة للبيضة المخصّبة حتّى تفقس. **طبيعي** (الأنثى تحتضن البيض، الدجاجة نحو 21 يومًا) أو **اصطناعي** (المفرخة/الحاضنة). البيضة **غير المخصّبة لا تفقس** مهما طال تفريخها.', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('92b5eccd-cfb2-589e-bbf9-8b342e50ca10', 'sciences-vie-terre-8eme', 'تحسين الإنتاج الحيواني', 'تقنيات الرفع من الإنتاج الحيواني كمًّا وكيفًا: الانتخاب واصطفاء الأفضل للتّكاثر، والتلقيح الاصطناعي، والتهجين بين السّلالات، وتحسين التغذية والظروف الصحّية وظروف الإيواء، مع التمييز بين التقنيات الوراثيّة التي تحسّن السّلالة عبر الأجيال والتقنيات التي ترفع المردود دون تغيير المورثات', '# 🐄 تحسين الإنتاج الحيواني — كيف يرفع المربّي إنتاج قطيعه؟

> 💡 «لا يكتفي المربّي الماهر بأن ينتظر ما يعطيه حيوانه، بل يتدخّل بذكاء ليصنع قطيعًا أكثر إنتاجًا للحليب واللّحم والبيض والصّوف والعسل.»

اكتشفت في الفصول السّابقة كيف تتكاثر الحيوانات. في هذا الفصل ستكتشف كيف يستغلّ الإنسان معرفته بالتّكاثر ليُحسّن **الإنتاج الحيواني**، أي ليجعل حيوانات التّربية تعطي كمّيات أكبر ونوعيّة أفضل من منتجاتها.

## 🎯 لماذا نحسّن الإنتاج الحيواني؟

يربّي الإنسان الحيوانات للحصول على منتجات متنوّعة: **الحليب** من الأبقار والأغنام والماعز، و**اللّحم**، و**البيض** من الدّجاج، و**الصّوف** من الأغنام، و**العسل** من النّحل. وهدف التّحسين مزدوج:

- **الكمّ**: الحصول على كمّية أكبر (مثلًا بقرة تعطي 25 لترًا من الحليب يوميًّا بدل 8 لترات).
- **الكيف (النّوعيّة)**: الحصول على منتوج أجود (حليب أغنى، لحم أفضل، صوف أنعم، دجاجة تبيض أكثر).

ولبلوغ هذا الهدف يستعمل المربّي مجموعتين من التّقنيات: **تقنيات وراثيّة** تحسّن السّلالة نفسها عبر الأجيال، و**تقنيات تتعلّق بظروف التّربية** ترفع مردود الحيوانات الموجودة دون أن تغيّر مورثاتها.

## 🧬 الانتخاب: اصطفاء الأفضل للتّكاثر

**الانتخاب** هو أن يختار المربّي، من بين حيواناته، الأفراد الّذين يملكون **أفضل الصّفات** ويجعلهم هم الّذين يتكاثرون، لأنّ هذه الصّفات الجيّدة **تنتقل إلى النّسل** (الأبناء).

مثلًا، في ضيعة لتربية الأبقار الحلوب بجهة سليانة، يحتفظ المربّي بالبقرة الّتي تعطي أكبر كمّية من الحليب ليجعلها تتكاثر، ويتخلّص من التّكاثر بالأبقار قليلة الإنتاج. وبتكرار هذا الاختيار **جيلًا بعد جيل**، تتحسّن سلالة القطيع كلّه شيئًا فشيئًا.

> ⚠️ الانتخاب لا يعني قتل الحيوانات الضّعيفة، بل يعني اختيار الأفضل **للتّكاثر** حتّى تُورَّث صفاته الجيّدة. كما أنّ الانتخاب يتمّ **داخل نفس السّلالة** (نختار الأفضل من بين أفرادها)، وهو مختلف عن التّهجين الّذي يجمع بين سلالتين.

> 🗡️ في منحل بجهة عين دراهم، ينتخب النّحّال **الملكة** الّتي تنحدر منها طائفة نحل هادئة وكثيرة إنتاج العسل، فيربّي منها ملكات جديدة، فتنتقل هذه الصّفات إلى الطّوائف الجديدة.

## 💉 التلقيح الاصطناعي

في **التّلقيح الطّبيعي**، يتزاوج الذّكر والأنثى مباشرة فيحدث الإخصاب داخل جسم الأنثى. أمّا في **التّلقيح الاصطناعي** فيتدخّل الإنسان: يأخذ **السّائل المنويّ (النّطاف)** من **ذكر منتخب** ذي صفات ممتازة، ثمّ يضعه في الجهاز التّناسليّ لعدد كبير من الإناث **دون تزاوج مباشر**.

وفائدة هذه التّقنية كبيرة:

- **ذكر واحد ممتاز** يمكن أن يُخصِب **عددًا كبيرًا جدًّا من الإناث**، فتنتشر صفاته الجيّدة بسرعة في القطيع كلّه.
- الاستغناء عن نقل الحيوانات لمسافات طويلة من أجل التّزاوج.
- **الوقاية** من بعض الأمراض الّتي قد تنتقل بالتّزاوج المباشر.
- إمكانيّة تنظيم مواعيد الولادات وضبطها.

> ⚠️ لا تخلط بين **التّلقيح الطّبيعي** (تزاوج مباشر بين ذكر وأنثى) و**التّلقيح الاصطناعي** (يتدخّل الإنسان فيضع نطاف ذكر منتخب في الإناث دون تزاوج). التّلقيح الاصطناعي وسيلة قويّة لنشر صفات ذكر ممتاز على نطاق واسع.

## 🔀 التهجين بين السلالات

**التّهجين** هو تزويج فردين من **سلالتين مختلفتين**، للحصول على نسل **هجين** يجمع بين **صفات السّلالتين معًا**.

مثلًا، قد يهجّن مربٍّ في جهة سيدي بوزيد بين سلالة أغنام محلّيّة **مقاومة** للجفاف والحرارة وقليلة الحاجة إلى العلف، وسلالة مستوردة **وفيرة اللّحم** لكنّها ضعيفة أمام مناخ البلاد. فيأمل أن يجمع الهجين بين **مقاومة** السّلالة المحلّيّة و**غزارة إنتاج** السّلالة المستوردة.

> 🔮 الفرق الجوهريّ: **الانتخاب** يختار الأفضل **داخل السّلالة الواحدة**، أمّا **التّهجين** فيجمع **بين سلالتين مختلفتين** ليمزج صفاتهما في نسل واحد.

## 🥗 تحسين التغذية والظروف الصحية والإيواء

إلى جانب التّقنيات الوراثيّة، يرفع المربّي المردود بتحسين **ظروف التّربية**:

- **تحسين التّغذية**: تقديم علف متوازن وكافٍ وغنيّ يجعل الحيوان ينتج حليبًا أو لحمًا أو بيضًا أكثر. لكنّ تحسين التّغذية **يرفع المردود فقط**، ولا يغيّر مورثات الحيوان: فبقرة تُطعَم جيّدًا تنتج حليبًا أكثر، لكنّ عجلها لا يرث هذا الإنتاج المرتفع لمجرّد أنّ أمّه أُطعِمت جيّدًا.
- **تحسين الظّروف الصّحّية**: التّلقيح ضدّ الأمراض، والنّظافة، ومكافحة الطّفيليّات، والعناية البيطريّة، تجعل الحيوانات سليمة وتقلّل الخسائر (النّفوق والمرض).
- **تحسين ظروف الإيواء**: توفير حظائر نظيفة، جيّدة التّهوية، مناسبة الحرارة، واسعة بما يكفي، يقلّل من إجهاد الحيوان ويرفع إنتاجه. مثلًا، في مزرعة دواجن بالمنستير، تبيض الدّجاجات في قنّ نظيف جيّد التّهوية أكثر ممّا تبيض في قنّ مزدحم قذر.

> ⚠️ **الخطأ الشّائع الأخطر**: الاعتقاد أنّ تحسين التّغذية أو الصّحّة أو الإيواء يغيّر **السّلالة** أو **المورثات**. الحقيقة: هذه التّقنيات ترفع مردود الحيوان الموجود، لكن **الصّفات المنقولة إلى النّسل** لا تتحسّن إلّا بالتّقنيات الوراثيّة (الانتخاب، التّلقيح الاصطناعي، التّهجين).

## 📊 تقنيات وراثيّة مقابل تقنيات الظّروف

| التّقنية                           | كيف تعمل؟                              | هل تغيّر الصّفات المورّثة للنّسل؟ |
| ---------------------------------- | -------------------------------------- | --------------------------------- |
| الانتخاب                           | اختيار الأفضل داخل السّلالة للتّكاثر   | نعم، عبر الأجيال                  |
| التّلقيح الاصطناعي                 | نشر نطاف ذكر منتخب في إناث كثيرة       | نعم، عبر الأجيال                  |
| التّهجين بين السّلالات             | تزويج سلالتين مختلفتين لجمع صفاتهما    | نعم                               |
| تحسين التّغذية / الصّحّة / الإيواء | رفع مردود الحيوان الموجود بتحسين ظروفه | لا، ترفع المردود فقط              |

> 🏆 أتقنت الآن تقنيات تحسين الإنتاج الحيواني: **الانتخاب** لاصطفاء الأفضل، و**التّلقيح الاصطناعي** لنشر صفات ذكر ممتاز، و**التّهجين** لجمع صفات سلالتين، وتحسين **التّغذية والصّحّة والإيواء** لرفع المردود. وتعلّمت الفرق الجوهريّ بين التّقنيات الّتي تحسّن السّلالة وراثيًّا وتلك الّتي ترفع المردود دون أن تمسّ المورثات. في الفصل القادم ستكتشف موضوعًا جديدًا!', '# 📜 ملخّص: تحسين الإنتاج الحيواني

- **الهدف**: الرّفع من الإنتاج الحيواني (حليب، لحم، بيض، صوف، عسل) **كمًّا وكيفًا** بتدخّل المربّي.
- **الانتخاب**: اختيار الأفراد ذوي أفضل الصّفات **للتّكاثر** حتّى تُورَّث صفاتهم للنّسل؛ يتمّ **داخل السّلالة الواحدة** وتتحسّن السّلالة **عبر الأجيال**.
- **التّلقيح الاصطناعي**: أخذ نطاف **ذكر منتخب** ووضعها في إناث كثيرة **دون تزاوج مباشر**؛ ذكر واحد ممتاز يُخصِب عددًا كبيرًا من الإناث فتنتشر صفاته بسرعة، مع الوقاية من بعض الأمراض وتفادي نقل الحيوانات. غير **التّلقيح الطّبيعي** (تزاوج مباشر).
- **التّهجين بين السّلالات**: تزويج **سلالتين مختلفتين** للحصول على **هجين** يجمع صفاتهما (مثل مقاومة سلالة محلّيّة + غزارة سلالة مستوردة)؛ يختلف عن الانتخاب الّذي يبقى داخل سلالة واحدة.
- **تحسين التّغذية والصّحّة والإيواء**: علف متوازن، تلقيح ونظافة وعناية بيطريّة، حظائر نظيفة جيّدة التّهوية؛ **ترفع مردود الحيوان الموجود فقط**.
- **قاعدة أساسيّة**: تحسين التّغذية أو الصّحّة أو الإيواء **لا يغيّر المورثات ولا السّلالة**؛ الصّفات المنقولة للنّسل لا تتحسّن إلّا بالتّقنيات الوراثيّة (الانتخاب، التّلقيح الاصطناعي، التّهجين).', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('ce3663d1-42ee-5b19-968c-75d46a1ea5c3', 'sciences-vie-terre-8eme', 'النظم البيئية والتوازن الطبيعي', 'مفهوم النظام البيئي (وسط غير حيّ ومجموعة كائنات حيّة)، السلاسل والشبكات الغذائية من المنتِج إلى المستهلك إلى المحلِّل، العلاقات بين الكائنات (افتراس وتنافس) والتوازن الطبيعي، وتأثير الإنسان على المحيط وسبل حماية البيئة، وفق برنامج السنة الثامنة من التعليم الأساسي', '# 🌍 النظم البيئية والتوازن الطبيعي — عالمٌ متشابك حلقاته

> 💡 «ليس الوسط البيئي مجرّد أرض وماء وهواء، بل نظامٌ حيّ تتشابك فيه آلاف الكائنات في شبكة واحدة، إن اهتزّت منها خيطٌ واحد اهتزّ النظام كلّه.»

عرفت في السنة السابقة أنّ لكلّ كائن حيّ وسطًا يعيش فيه، وأنّ الكائنات ترتبط في سلاسل غذائية. في هذا الفصل سترتقي خطوة: ستكتشف أنّ **الوسط والكائنات معًا** يكوّنان وحدة واحدة اسمها **النظام البيئي**، وأنّ هذه الكائنات لا ترتبط بسلاسل مستقيمة فحسب بل بـ**شبكات** متشابكة، وأنّ توازنها الدقيق مهدَّد بيد الإنسان نفسه.

## 🏞️ مفهوم النظام البيئي: وسطٌ + كائنات

**النظام البيئي** وحدة طبيعية تجمع بين مكوّنَين لا ينفصلان:

- **الوسط (المكوّنات غير الحيّة)**: التربة، الماء، الضوء، الحرارة، الهواء، ودرجة الملوحة. هذه العوامل تحدّد أيّ الكائنات تستطيع العيش هناك.
- **مجموعة الكائنات الحيّة**: كلّ النباتات والحيوانات والكائنات المجهرية التي تعيش في ذلك الوسط وتتفاعل فيما بينها.

فالنظام البيئي إذن = **وسط غير حيّ + مجموعة كائنات حيّة تتفاعل معه ومع بعضها**.

> ⚠️ الخطأ الشائع أن نحصر النظام البيئي في الكائنات الحيّة وحدها. النظام البيئي يضمّ **الوسط أيضًا**: لولا ملوحة السبخة وحرارتها لما عاشت فيها الكائنات التي نراها.

## 🌴🏜️ أنظمة بيئية تونسية

يختلف كلّ نظام بيئي عن غيره باختلاف وسطه وكائناته:

| النظام البيئي     | من وسطه (غير حيّ)      | من كائناته الحيّة                       |
| ----------------- | ---------------------- | --------------------------------------- |
| **السبخة**        | ماء مالح، حرارة عالية  | نبات القطف الملحي، قشريات، طائر النحام  |
| **بستان الزيتون** | تربة، ضوء، حرارة       | شجرة الزيتون، عثّة الزيتون، عصفور، بومة |
| **غابة الفلّين**  | تربة رطبة، ظلّ الأشجار | بلّوط الفلّين، يرقات، طائر، ابن آوى     |
| **الواد**         | ماء عذب جارٍ           | طحالب، سمك صغير، ضفدع، مالك الحزين      |

## 🌿 حلقات النظام: منتِج ومستهلك ومحلِّل

تنقسم كائنات أيّ نظام بيئي بحسب طريقة تغذيتها إلى ثلاث حلقات:

| الحلقة       | تعريفها                                                              | مثال                               |
| ------------ | -------------------------------------------------------------------- | ---------------------------------- |
| **المنتِج**  | نبتة خضراء تصنع مادّتها العضوية بنفسها من ماء وأملاح وضوء            | شجرة الزيتون، الطحالب              |
| **المستهلك** | حيوان لا يصنع غذاءه بل يأخذه من كائن حيّ آخر (أوّل، ثانٍ، ثالث)      | عثّة تأكل الورق، بومة تأكل عصفورًا |
| **المحلِّل** | جراثيم وفطريات التربة تحوّل المادّة العضوية الميّتة إلى أملاح معدنية | جراثيم التربة، فطريات              |

> ⚠️ لا تخلط بين الحلقات: **المنتِج** يصنع غذاءه بنفسه، و**المستهلك** يأكل كائنًا آخر حيًّا، و**المحلِّل** لا يفترس كائنًا حيًّا أبدًا بل يتغذّى فقط على البقايا الميّتة.

## 🔗 من السلسلة إلى الشبكة الغذائية

**السلسلة الغذائية** ترتيب لعدّة حلقات يربط بينها سهم (→) معناه الثابت **«يُؤكل من طرف»**، وتبدأ دائمًا بمنتِج:

$$ زيتون → عثّة → عصفور → بومة $$

نقرؤها: الزيتون (منتِج) يُؤكل من طرف العثّة (مستهلك أوّل)، والعثّة تُؤكل من طرف العصفور (مستهلك ثانٍ)، والعصفور يُؤكل من طرف البومة (مستهلك ثالث).

لكنّ الواقع أعقد: الكائن الواحد قد يكون في أكثر من سلسلة (فالعصفور يأكل عثّات وديدانًا معًا، والبومة تأكل عصافير وفئرانًا). حين تتشابك عدّة سلاسل غذائية في نظام واحد تتكوّن **الشبكة الغذائية**: مجموع السلاسل المترابطة التي تشترك في بعض حلقاتها.

<svg viewBox="0 0 300 258">
<title>شبكة غذائية: عدّة سلاسل متشابكة</title>
<line x1="128.99" y1="201.51" x2="74.54" y2="144.49" stroke="#0f6e56" stroke-width="2.2"/>
<polygon points="74.54,144.49 82.96,147.51 77.17,153.04" fill="#0f6e56"/>
<line x1="150" y1="195" x2="150" y2="151" stroke="#0f6e56" stroke-width="2.2"/>
<polygon points="150,151 154,159 146,159" fill="#0f6e56"/>
<line x1="171.56" y1="201.95" x2="230.98" y2="144.05" stroke="#0f6e56" stroke-width="2.2"/>
<polygon points="230.98,144.05 228.04,152.5 222.46,146.77" fill="#0f6e56"/>
<line x1="67.99" y1="116.28" x2="90.41" y2="63.46" stroke="#0f6e56" stroke-width="2.2"/>
<polygon points="90.41,63.46 90.97,72.39 83.6,69.26" fill="#0f6e56"/>
<line x1="138.4" y1="116.13" x2="117.15" y2="63.64" stroke="#0f6e56" stroke-width="2.2"/>
<polygon points="117.15,63.64 123.86,69.55 116.44,72.55" fill="#0f6e56"/>
<line x1="243.9" y1="114.56" x2="234.91" y2="65.38" stroke="#0f6e56" stroke-width="2.2"/>
<polygon points="234.91,65.38 240.28,72.53 232.41,73.97" fill="#0f6e56"/>
<line x1="131.88" y1="46" x2="200.12" y2="46" stroke="#0f6e56" stroke-width="2.2"/>
<polygon points="200.12,46 192.12,50 192.12,42" fill="#0f6e56"/>
<ellipse cx="150" cy="214" rx="34" ry="16" fill="#dcfce7" stroke="#0f6e56" stroke-width="2.2"/>
<ellipse cx="56" cy="132" rx="30" ry="15" fill="#fef3c7" stroke="#d97706" stroke-width="2.2"/>
<ellipse cx="150" cy="132" rx="30" ry="15" fill="#fef3c7" stroke="#d97706" stroke-width="2.2"/>
<ellipse cx="250" cy="132" rx="30" ry="15" fill="#fef3c7" stroke="#d97706" stroke-width="2.2"/>
<ellipse cx="104" cy="46" rx="34" ry="16" fill="#dbeafe" stroke="#2563eb" stroke-width="2.2"/>
<ellipse cx="228" cy="46" rx="34" ry="16" fill="#ede9fe" stroke="#7c3aed" stroke-width="2.2"/>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="150" y="218" text-anchor="middle" fill="#0f6e56" font-size="12.5">زيتون</text><text x="56" y="136" text-anchor="middle" fill="#d97706" font-size="12.5">عثّة</text><text x="150" y="136" text-anchor="middle" fill="#d97706" font-size="12.5">دودة</text><text x="250" y="136" text-anchor="middle" fill="#d97706" font-size="12.5">فأر</text><text x="104" y="50" text-anchor="middle" fill="#2563eb" font-size="12.5">عصفور</text><text x="228" y="50" text-anchor="middle" fill="#7c3aed" font-size="12.5">بومة</text></g>
<line x1="20" y1="244" x2="44" y2="244" stroke="#0f6e56" stroke-width="2.2"/>
<polygon points="44,244 36,248 36,240" fill="#0f6e56"/>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="50" y="248" text-anchor="start" fill="#0f172a" font-size="11">السهم = «يُؤكل من طرف»</text></g>
</svg>


> 🔮 الشبكة الغذائية أمتن من السلسلة الواحدة: إن قلّت فريسة، وجد المفترس بديلًا في سلسلة أخرى، فيصمد النظام. لكنّ لهذا التشابك حدودًا.

## ⚖️ التوازن الطبيعي والعلاقات بين الكائنات

تربط كائنات النظام علاقات متعدّدة، أهمّها:

- **الافتراس**: كائن يتغذّى على كائن آخر (البومة تفترس العصفور).
- **التنافس**: كائنان يتزاحمان على المورد نفسه (عصفوران يتنافسان على الحشرات نفسها).

ما دامت أعداد المنتِجات والمستهلكات والمحلِّلات متكافئة نسبيًّا، يبقى النظام في **توازن طبيعي**: أعداد الكائنات تتذبذب قليلًا لكنّها لا تنهار. هذا التوازن ليس ثباتًا جامدًا بل استقرارٌ نسبيّ تحفظه العلاقات الغذائية نفسها.

> ⚠️ إن اختفت حلقة (كصيد مفرط لمفترس)، تكاثرت فريسته دون رادع فاستنزفت المنتِج، فيختلّ توازن النظام كلّه؛ فليست أيّ حلقة «بلا أثر».

## 🏭 تأثير الإنسان على المحيط

يتدخّل الإنسان في الأنظمة البيئية فيخلّ بتوازنها عبر عدّة أنشطة:

- **التلوّث**: صبّ الفضلات والمواد الكيميائية في الماء والهواء والتربة يسمّم الكائنات.
- **الصيد وقطع الأشجار المفرطان**: يقضيان على حلقات كاملة فينهار ما فوقها.
- **تجفيف السباخ والمناطق الرطبة والبناء عليها**: يحرم الطيور المهاجرة من ملجئها.

نتيجة ذلك: **انقراض أنواع** واختلال التوازن الطبيعي، وقد يمتدّ الضرر إلى الإنسان نفسه.

## 🛡️ حماية البيئة

يستطيع الإنسان أيضًا أن يحمي الأنظمة البيئية:

- إنشاء **المحميّات الطبيعية** وحماية **المناطق الرطبة** ملجأً للكائنات.
- **ترشيد الصيد** واحترام مواسم التكاثر.
- **التشجير** وإعادة الغطاء النباتي.
- **رسكلة النفايات** والحدّ من التلوّث.

> 🏆 أتقنت الآن مفهوم النظام البيئي (وسط + كائنات)، وحلقاته الثلاث (منتِج، مستهلك، محلِّل)، والفرق بين السلسلة والشبكة الغذائية، والعلاقات التي تحفظ التوازن الطبيعي، وكيف يهدّده الإنسان ويحميه. في الفصل القادم ستكتشف الظواهر الجيولوجية الخارجية!', '# 📜 ملخّص: النظم البيئية والتوازن الطبيعي

- **النظام البيئي** = **وسط غير حيّ** (تربة، ماء، ضوء، حرارة، ملوحة) + **مجموعة الكائنات الحيّة** التي تتفاعل فيه؛ لا يُختزل في الكائنات وحدها.
- **أمثلة تونسية**: السبخة (ماء مالح؛ قطف، قشريات، نحام)، بستان الزيتون (زيتون، عثّة، عصفور، بومة)، غابة الفلّين (بلّوط، يرقات، ابن آوى)، الواد (طحالب، سمك، ضفدع، مالك الحزين).
- **حلقات النظام**: **المنتِج** (نبتة خضراء تصنع غذاءها بنفسها)، **المستهلك** (حيوان يأكل كائنًا حيًّا آخر: أوّل/ثانٍ/ثالث)، **المحلِّل** (جراثيم وفطريات تحوّل المادّة العضوية الميّتة إلى أملاح معدنية، ولا تفترس كائنًا حيًّا).
- **السلسلة الغذائية**: حلقات مرتبطة بسهم (→) معناه الثابت «يُؤكل من طرف»، تبدأ دائمًا بمنتِج.
- **الشبكة الغذائية**: تشابك عدّة سلاسل غذائية في نظام واحد، لأنّ الكائن الواحد قد يكون في أكثر من سلسلة؛ وهي أمتن من السلسلة المفردة.
- **العلاقات بين الكائنات**: الافتراس (آكل ومأكول) والتنافس (تزاحم على المورد نفسه).
- **التوازن الطبيعي**: استقرار نسبيّ لأعداد المنتِجات والمستهلكات والمحلِّلات؛ اختفاء حلقة واحدة (كصيد مفرط لمفترس) يختلّ به النظام كلّه.
- **تأثير الإنسان**: التلوّث، الصيد وقطع الأشجار المفرطان، تجفيف السباخ → انقراض أنواع واختلال التوازن.
- **حماية البيئة**: المحميّات الطبيعية والمناطق الرطبة، ترشيد الصيد، التشجير، رسكلة النفايات والحدّ من التلوّث.', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('d40c69c1-b472-57e1-b670-cecf2a81c526', 'sciences-vie-terre-8eme', 'الظّواهر الجيولوجيّة الخارجيّة', 'تغيّر سطح الأرض ببطء بفعل عوامل خارجيّة عبر ثلاث مراحل مترابطة: التّعرية (تفتّت الصّخور وتآكلها بفعل الماء والرّياح والجليد وتغيّر الحرارة)، ثمّ النّقل (حمل الفتات بعيدًا وتصنيفه حسب حجمه)، ثمّ التّرسّب (استقرار الرّواسب وتراكمها في طبقات عند مصبّات الوديان والسّبخات وقاع البحر وسفوح الكثبان)', '# 🏜️ الظّواهر الجيولوجيّة الخارجيّة

> 💡 «الجبل الصّلب الّذي تراه اليوم كان قمّة أعلى بكثير قبل ملايين السّنين؛ فما الّذي نحت صخوره وحمل فتاتها إلى قاع البحر؟»

اكتشفت في الفصل السّابق التّربة، وكيف تحميها جذور النّباتات من التّعرية. في هذا الفصل نوسّع النّظر إلى **سطح الأرض كلّه**: كيف تتغيّر تضاريسه ببطء تحت فعل عوامل خارجيّة كالماء والرّياح والجليد والحرارة. هذه التّغيّرات تُسمّى **الظّواهر الجيولوجيّة الخارجيّة**، وتحدث في ثلاث مراحل متتالية: **التّعرية** ثمّ **النّقل** ثمّ **التّرسّب**.

## 🌍 ظواهر «خارجيّة» تحدث فوق سطح الأرض

الظّواهر الجيولوجيّة الخارجيّة هي التّغيّرات الّتي تطرأ على **سطح الأرض** بفعل **عوامل خارجيّة** مصدرها الغلاف الجوّيّ والماء: المطر، الجريان، الرّياح، الجليد، وتغيّر الحرارة. تعمل هذه العوامل ببطء شديد وعبر أزمنة طويلة جدًّا، لكنّها في النّهاية تنحت الجبال وتُشكّل الوديان والسّهول والكثبان.

تمرّ هذه الظّواهر دائمًا بثلاث مراحل مترابطة:

1. **التّعرية**: تفتّت الصّخور وتآكلها في مكانها.
2. **النّقل**: حمل الفتات النّاتج بعيدًا عن مكانه.
3. **التّرسّب**: تراكم الفتات واستقراره في مكان جديد.

<svg viewBox="0 0 300 196">
<title>سلسلة: تعرية ← نقل ← ترسّب</title>
<polygon points="82,150 100,150 152,130 206,116 256,44 300,152 300,190 82,190" fill="#fde68a" stroke="#b45309" stroke-width="2"/>
<polygon points="206,116 256,44 300,152 300,116" fill="#e7c9a0" stroke="#92400e" stroke-width="1.6"/>
<line x1="256" y1="58" x2="268" y2="86" stroke="#92400e" stroke-width="1.3"/>
<line x1="256" y1="58" x2="246" y2="84" stroke="#92400e" stroke-width="1.3"/>
<line x1="272" y1="70" x2="284" y2="104" stroke="#92400e" stroke-width="1.3"/>
<circle cx="238" cy="100" r="2.2" fill="#92400e"/>
<circle cx="248" cy="112" r="2.2" fill="#92400e"/>
<circle cx="230" cy="110" r="2.2" fill="#92400e"/>
<rect x="0" y="150" width="82" height="40" fill="#bfdbfe"/>
<polyline points="0,150 12,146 24,150 36,146 48,150 60,146 72,150 82,150" fill="none" stroke="#2563eb" stroke-width="1.6"/>
<rect x="0" y="178" width="82" height="5" fill="#fef3c7" stroke="#b45309" stroke-width="1"/>
<rect x="0" y="183" width="82" height="5" fill="#e2e8f0" stroke="#64748b" stroke-width="1"/>
<polyline points="252,62 214,112 158,128 100,148 82,150" fill="none" stroke="#2563eb" stroke-width="3.4"/>
<line x1="236" y1="86" x2="214" y2="110" stroke="#2563eb" stroke-width="2.4"/>
<polygon points="214,110 216.46,101.4 222.35,106.81" fill="#2563eb"/>
<line x1="186" y1="122" x2="150" y2="130" stroke="#2563eb" stroke-width="2.4"/>
<polygon points="150,130 156.94,124.36 158.68,132.17" fill="#2563eb"/>
<line x1="128" y1="143" x2="98" y2="149" stroke="#2563eb" stroke-width="2.4"/>
<polygon points="98,149 105.06,143.51 106.63,151.35" fill="#2563eb"/>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="262" y="30" text-anchor="middle" fill="#92400e" font-size="12.5">التعرية</text><text x="180" y="104" text-anchor="middle" fill="#2563eb" font-size="12.5">النقل</text><text x="40" y="138" text-anchor="middle" fill="#b45309" font-size="12.5">الترسّب</text></g>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="272" y="140" text-anchor="middle" fill="#92400e" font-size="10.5">جبل</text><text x="150" y="158" text-anchor="middle" fill="#2563eb" font-size="10.5">واد</text><text x="40" y="174" text-anchor="middle" fill="#b45309" font-size="9.5">رواسب في طبقات</text><text x="24" y="166" text-anchor="middle" fill="#2563eb" font-size="9.5">البحر / السهل</text></g>
</svg>


> ⚠️ لا تخلط بين هذه الظّواهر **الخارجيّة** الّتي تحدث فوق سطح الأرض، وظواهر أخرى **باطنيّة** مصدرها باطن الأرض؛ موضوعنا هنا هو ما يجري فوق السّطح فقط.

## 🪨 المرحلة الأولى: التّعرية (تفتّت الصّخور وتآكلها)

**التّعرية** هي **تفتّت الصّخور وتآكلها** في مكانها بفعل العوامل الخارجيّة، فتتحوّل الصّخرة الصّلبة تدريجيًّا إلى فتات وحبيبات أصغر: كتل صغيرة، حصى، رمل، ثمّ غبار دقيق.

لا تحدث التّعرية دفعةً واحدة، بل عبر عوامل (وسائط) متعدّدة تعمل غالبًا معًا:

### 💧 الماء

- ماء المطر والجريان في الوديان يُذيب بعض الصّخور ويجرف فتاتها.
- أمواج البحر تضرب الصّخور على السّواحل باستمرار فتفتّتها شيئًا فشيئًا.

### 💨 الرّياح

- تحمل الرّياح حبيبات الرّمل فتصطدم بالصّخور وتحتّها كأنّها ورق صنفرة طبيعيّ، خاصّة في المناطق الصّحراويّة القليلة الغطاء النّباتيّ في الجنوب التّونسيّ.

### ❄️ الجليد (تجمّد الماء)

- يتسرّب الماء داخل شقوق الصّخور؛ فإذا تجمّد ليلًا في المرتفعات الباردة تمدّد وضغط على جدران الشّقّ حتّى يوسّعه ويكسر الصّخرة. ويتكرّر هذا كلّما تجمّد الماء وذاب.

### 🌡️ تغيّر الحرارة

- في الصّحراء يشتدّ الفرق بين حرارة النّهار المرتفعة وبرودة اللّيل، وقد يفوق هذا الفرق 30 درجة. يتمدّد سطح الصّخرة نهارًا بالحرارة وينكمش ليلًا بالبرودة، فتتشقّق وتتقشّر مع تكرار ذلك آلاف المرّات.

> 🗡️ ميّز جيّدًا بين **العامل** و**أثره**: الرّياح والماء والجليد والحرارة هي **عوامل** التّعرية؛ أمّا تفتّت الصّخرة وتشقّقها فهو **أثر** هذه العوامل، لا عاملًا قائمًا بذاته.

## 🚚 المرحلة الثّانية: النّقل

بعد أن تُفتّت التّعريةُ الصّخرَ، تأتي مرحلة **النّقل**: حمل الفتات (الحصى، الرّمل، الغبار، الطّين) بعيدًا عن مكان تفتّته، بفعل العوامل نفسها:

- **الماء الجاري** في الوديان يدحرج الحصى الثّقيل على قاعه، ويحمل الرّمل والطّين معلّقًا في الماء إلى مسافات أبعد.
- **الرّياح** تدحرج حبيبات الرّمل قرب سطح الأرض، وتحمل الغبار الدّقيق عاليًا وإلى مسافات بعيدة جدًّا.
- **الجليد المتحرّك** في المرتفعات يدفع أمامه كتلًا صخريّة كبيرة.

> 🗡️ خطأ شائع: الاعتقاد أنّ الرّياح لا تنقل إلّا الرّمل. في الحقيقة تحمل الرّياح **الغبار الدّقيق** إلى مسافات وارتفاعات أكبر ممّا تحمله من الرّمل، لكنّها **لا تقدر** على حمل الحصى الثّقيل أو الكتل الكبيرة. فكلّما كانت الحبيبة أدقّ، أمكن نقلها أبعد وأعلى.

وكلّما طال النّقل، احتكّت الحبيبات بعضها ببعض فتآكلت حوافّها واستدارت، وتصنّفت حسب حجمها: يستقرّ الثّقيل قريبًا ويُحمَل الخفيف أبعد.

## 🏝️ المرحلة الثّالثة: التّرسّب

عندما يفقد عامل النّقل قوّته أو سرعته (يهدأ الماء، تسكن الرّيح)، لا يعود قادرًا على حمل ما ينقله، فيُسقطه ويتركه يستقرّ: هذه هي مرحلة **التّرسّب**، والفتات المتراكم يُسمّى **رواسب**.

أين يحدث التّرسّب؟

- عند مصبّات الوديان وفي السّهول، حين يتّسع مجرى الماء ويبطؤ جريانه.
- في قاع البحيرات والسّبخات والبحر، حيث يهدأ الماء تمامًا.
- عند سفوح الكثبان الرّمليّة، حين تسكن الرّياح.

يترسّب الأثقل والأكبر أوّلًا بمجرّد أن تقلّ السّرعة قليلًا، ثمّ يترسّب الأدقّ لاحقًا لأنّه يحتاج ماءً شبه ساكن، فتتراكم الرّواسب في **طبقات** بعضها فوق بعض عبر الزّمن.

> 🔮 هذه الرّواسب المتراكمة عبر ملايين السّنين هي ما سيتحوّل لاحقًا إلى صخور رسوبيّة؛ وهو موضوع الفصل القادم.

## 🔗 سلسلة واحدة مترتّبة: تعرية ← نقل ← ترسّب

المهمّ أن تتذكّر أنّ هذه الظّواهر الثّلاث تحدث **بهذا التّرتيب دائمًا**، وكأنّها حلقات سلسلة واحدة:

**التّعرية** (تفتّت الصّخر في مكانه) ← **النّقل** (حمل الفتات بعيدًا) ← **التّرسّب** (استقرار الفتات وتراكمه في مكان جديد).

> ⚠️ لا يصحّ عكس التّرتيب: لا نقل قبل تعرية (لا شيء يُنقَل قبل أن يتفتّت)، ولا ترسّب قبل نقل (لا يستقرّ الفتات قبل أن يُحمَل).

> 🏆 أتقنت الآن الظّواهر الجيولوجيّة الخارجيّة الثّلاث وعواملها. في الفصل القادم ستكتشف كيف تتحوّل الرّواسب إلى صخور رسوبيّة، وما تحمله من مستحاثات!', '# 📜 ملخّص: الظّواهر الجيولوجيّة الخارجيّة

- **تعريف**: الظّواهر الجيولوجيّة الخارجيّة تغيّرات تطرأ على سطح الأرض بفعل عوامل خارجيّة (الماء، الرّياح، الجليد، تغيّر الحرارة)، وتمرّ بثلاث مراحل مترتّبة: **التّعرية ← النّقل ← التّرسّب**.
- **التّعرية**: تفتّت الصّخور وتآكلها في مكانها؛ عواملها: **الماء** (المطر والجريان والأمواج)، **الرّياح** (حبيبات الرّمل تحتّ الصّخر)، **الجليد** (تجمّد الماء في الشّقوق يوسّعها ويكسر الصّخر)، **تغيّر الحرارة** (تمدّد الصّخر نهارًا وانكماشه ليلًا يشقّقه، خاصّة في الصّحراء).
- **العامل ≠ الأثر**: الماء والرّياح والجليد والحرارة عوامل؛ أمّا تفتّت الصّخرة وتشقّقها فهو أثر هذه العوامل لا عامل بذاته.
- **النّقل**: حمل الفتات بعيدًا عن مكان تفتّته؛ الماء الجاري يدحرج الحصى ويحمل الرّمل والطّين معلّقًا، والرّياح تدحرج الرّمل وتحمل الغبار عاليًا وبعيدًا. كلّما طال النّقل استدارت الحبيبات وتصنّفت حسب حجمها.
- **الرّياح تنقل أكثر من الرّمل**: تحمل الرّياح الغبار الدّقيق إلى مسافات وارتفاعات أكبر من الرّمل، لكنّها لا تقدر على حمل الحصى الثّقيل أو الكتل الكبيرة؛ فكلّما دقّت الحبيبة أمكن نقلها أبعد.
- **التّرسّب**: حين يفقد عامل النّقل سرعته يُسقط ما يحمله، فتستقرّ الرّواسب عند مصبّات الوديان والسّبخات وقاع البحر وسفوح الكثبان. يترسّب الأثقل أوّلًا والأدقّ لاحقًا (يحتاج ماءً شبه ساكن)، فتتراكم الرّواسب في طبقات عبر الزّمن.
- **التّرتيب ثابت**: لا نقل قبل تعرية، ولا ترسّب قبل نقل.', 7, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('0a3bf243-c415-57eb-b300-dcd8259e6f0d', 'sciences-vie-terre-8eme', 'الصخور الرسوبية والمستحاثات', 'خصائص الصخور الرسوبية (الرمل والحجر الرملي، والطين، والكلس) وتمييزها عن الصخور الصهاريّة، وكيفية تشكّلها بتراكم الرواسب في طبقات ثم تصلّبها، ثم المستحاثات: تعريفها وشروط تحفّظها وأنواعها ودلالتها بوصفها شاهدًا على الماضي وعلى البيئة القديمة', '# 🪨 الصخور الرسوبية والمستحاثات

> 💡 «كلّ صخرة رسوبيّة صفحةٌ من كتاب الأرض، وكلّ مستحاثة سطرٌ مكتوبٌ فيها منذ ملايين السنين. تعلّم أن تقرأ، تقرأ تاريخ كوكبك.»

في الفصل السابق اكتشفت الظواهر الجيولوجية الخارجية: كيف تُفتّت **التعرية** الصخور، ثم يحملها **النقل**، ثم تستقرّ في الأسفل عبر **الترسّب**. في هذا الفصل نتابع الحكاية: ماذا تصبح هذه الرواسب المتراكمة؟ إنّها تتحوّل مع الزمن إلى **صخور رسوبيّة**، وقد تحبس في داخلها كنوزًا تروي ماضي الحياة: **المستحاثات**.

## 🌍 ما هي الصخور الرسوبية؟

**الصخرة الرسوبيّة** هي صخرةٌ تتكوّن قرب **سطح الأرض** بفعل **تراكم الرواسب** (فُتات صخور، حبيبات، بقايا كائنات) ثم **تصلّبها** عبر آلاف أو ملايين السنين.

تتميّز الصخور الرسوبيّة بثلاث علامات تساعدك على التعرّف عليها في الميدان:

- تترتّب عادةً في **طبقات** (رواسب فوق رواسب)؛
- كثيرًا ما تكون **ليّنة أو سهلة التفتّت** نسبيًّا؛
- قد تحتوي على **مستحاثات** (بقايا كائنات).

> 🗡️ لا تخلط بين نوعين من الصخور:
>
> |             | **الصخرة الرسوبيّة**   | **الصخرة الصهاريّة (البركانيّة)**            |
> | ----------- | ---------------------- | -------------------------------------------- |
> | أين تتشكّل؟ | قرب سطح الأرض          | من تبرّد الصهارة (المهل)                     |
> | كيف تتشكّل؟ | تراكم رواسب ثم تصلّبها | تجمّد مادّة منصهرة                           |
> | طبقات؟      | نعم غالبًا             | لا                                           |
> | مستحاثات؟   | **نعم قد تحتوي**       | **لا، أبدًا** (الحرارة تُتلف كلّ أثر للحياة) |
> | أمثلة       | الرمل، الطين، الكلس    | البازلت، الغرانيت                            |

## 🏖️ أنواع الصخور الرسوبية وخصائصها

تختلف الصخور الرسوبيّة باختلاف الرواسب المكوّنة لها. إليك الأنواع الثلاثة الأساسيّة:

| الصخرة                    | أصلها وحبيباتها                                                     | خاصّية مميّزة                                                                  |
| ------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| **الرمل / الحجر الرمليّ** | حبيبات صغيرة **مرئيّة بالعين** ومنفصلة (رمل)، أو ملتحمة (حجر رمليّ) | **نفوذة**: يتسرّب الماء عبرها بسهولة                                           |
| **الطين (الصلصال)**       | حبيبات **دقيقة جدًّا** غير مرئيّة                                   | **كتيمة** (يصعب مرور الماء)، وتصبح **لدنة لزجة** عند بلّها                     |
| **الكلس (الحجر الكلسيّ)** | غنيّ بكربونات الكلسيوم، غالبًا من بقايا أصداف ومرجان                | **يتفاعل مع حمض كلور الماء المخفّف** فينطلق **فوران** (غاز ثاني أكسيد الكربون) |

> 🔬 **الاختبار الحاسم للكلس**: ضع قطرة من حمض كلور الماء المخفّف (أو خلّ قويّ) على صخرة مجهولة. إذا ظهرت **فقاعات وفوران**، فهي صخرة **كلسيّة**. أمّا الرمل والطين فلا يُفوران. هذا الاختبار يميّز الكلس عن بقيّة الصخور بسرعة.

> ⚠️ خطأٌ شائع: الاعتقاد أنّ الطين والرمل شيءٌ واحد لأنّهما «ترابٌ». الفرق جوهريّ: حبيبات الرمل **كبيرة ومرئيّة** والصخرة **نفوذة**، أمّا حبيبات الطين **دقيقة جدًّا** والصخرة **كتيمة تحبس الماء**.

## ⏳ كيف تتشكّل الصخور الرسوبية؟

تمرّ الصخرة الرسوبيّة بسلسلة مراحل مرتّبة، تبدأ من صخرة قديمة وتنتهي بصخرة جديدة:

1. **التعرية**: تُفتّت العوامل الطبيعيّة (الماء، الرياح، الحرارة) الصخور إلى فُتاتٍ وحبيبات.
2. **النقل**: تحمل الأنهار والأودية والرياح هذا الفُتات مسافاتٍ بعيدة.
3. **الترسّب**: حين **تضعف سرعة** الماء أو الرياح (عند مصبّ نهرٍ، في بحيرة، في قاع بحر)، تسقط الحبيبات وتستقرّ فتُشكّل **رواسب**.
4. **التراكم في طبقات**: تتراكم الرواسب طبقةً فوق طبقة عبر آلاف السنين.
5. **التصلّب**: تحت ثقل الطبقات العليا، تتماسك حبيبات الرواسب وتلتحم فتتحوّل إلى **صخرة صلبة**.

> 🧭 **قاعدة ترتيب الطبقات (التعاقب)**: تترسّب الطبقة السفلى **أوّلًا**، ثم تعلوها الطبقات الأحدث. لذلك، وما لم تنقلب الطبقات: **الطبقة السفلى هي الأقدم، والطبقة العليا هي الأحدث**. هذه القاعدة هي مفتاح قراءة تاريخ الأرض.

<svg viewBox="0 0 300 262">
<title>تعاقب الطبقات الرسوبية</title>
<rect x="66" y="96" width="172" height="34" fill="#fecaca" stroke="#ef4444" stroke-width="1.8"/>
<rect x="66" y="130" width="172" height="34" fill="#fde68a" stroke="#d97706" stroke-width="1.8"/>
<rect x="66" y="164" width="172" height="34" fill="#dbeafe" stroke="#2563eb" stroke-width="1.8"/>
<rect x="66" y="198" width="172" height="36" fill="#e2e8f0" stroke="#64748b" stroke-width="1.8"/>
<rect x="66" y="96" width="172" height="138" fill="none" stroke="#0f172a" stroke-width="2.6"/>
<path d="M 100 216 a 3 3 0 1 0 5 -1 a 7 7 0 1 0 -11 2 a 11 11 0 1 0 18 -3" fill="none" stroke="#334155" stroke-width="2"/>
<path d="M 167 187 Q 178 174, 189 187 Q 178 191, 167 187 Z" fill="#f8fafc" stroke="#334155" stroke-width="1.8"/>
<line x1="178" y1="180" x2="173" y2="187" stroke="#334155" stroke-width="1.1"/>
<line x1="178" y1="180" x2="178" y2="188" stroke="#334155" stroke-width="1.1"/>
<line x1="178" y1="180" x2="183" y2="187" stroke="#334155" stroke-width="1.1"/>
<line x1="46" y1="102" x2="46" y2="230" stroke="#0f172a" stroke-width="2.4"/>
<polygon points="46,230 41.5,221 50.5,221" fill="#0f172a"/>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="8" y="108" text-anchor="start" fill="#ef4444" font-size="11.5">أحدث</text><text x="8" y="228" text-anchor="start" fill="#64748b" font-size="11.5">أقدم</text></g>
<g font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="3.5" stroke-linejoin="round"><text x="152" y="86" text-anchor="middle" fill="#ef4444" font-size="12">الطبقة العليا = الأحدث</text><text x="152" y="254" text-anchor="middle" fill="#64748b" font-size="12">الطبقة السفلى = الأقدم</text></g>
</svg>


> ⚠️ خطأٌ شائع: الاعتقاد أنّ الترسّب يحدث حيث يكون الماء **سريعًا**. الحقيقة عكس ذلك: الماء السريع **يحمل** الحبيبات، وحين **يبطؤ** فقط تسقط وتترسّب. لذلك تتجمّع الرواسب في البحيرات والبحار الهادئة لا في وسط الوادي الجارف.

## 🦴 المستحاثات: تعريفها وتشكّلها

**المستحاثة (الأُحفورة)** هي **بقايا** كائنٍ حيّ (نبات أو حيوان) عاش في الماضي، أو **أثرٌ** تركه، حُفظ داخل صخرة رسوبيّة.

لكن انتبه: **ليس كلّ كائنٍ يموت يصبح مستحاثة**! التحفّظ حدثٌ نادرٌ يتطلّب شروطًا:

- **دفنٌ سريع** تحت الرواسب قبل أن تتحلّل الجثّة أو تأكلها الكائنات المُحلِّلة؛
- وجود **أجزاء صلبة** (عظام، أصداف، أسنان، جذوع، أوراق قويّة) أقدر على المقاومة من الأجزاء الليّنة؛
- **وسطٌ يحمي** من الهواء والتعفّن (قاع بحرٍ أو بحيرة مثلًا).

مراحل التشكّل باختصار: **موت الكائن → دفنٌ سريع تحت الرواسب → تراكم الطبقات وتصلّبها → تمعدنٌ (تحجّرٌ) تدريجيّ عبر ملايين السنين**.

| نوع المستحاثة    | مثال                                        |
| ---------------- | ------------------------------------------- |
| **بقايا مباشرة** | عظمٌ، صَدفة، سنّ، جذعٌ متحجّر               |
| **آثار**         | بصمة ورقة نبات، أثر أقدام حيوان، قالب صَدفة |

> 🗡️ لهذا نجد أصداف الرخويّات والعظام أكثر من الأجزاء الليّنة كالجلد والعضلات: **الأجزاء الصلبة تقاوم التحلّل أطول**، فتحتفظ بها الصخرة الرسوبيّة.

> ⚠️ خطأٌ شائع: الاعتقاد أنّ المستحاثات توجد في كلّ الصخور. الحقيقة أنّها لا توجد إلّا في **الصخور الرسوبيّة**، لأنّ الصخور الصهاريّة (البركانيّة) تتكوّن من مادّةٍ منصهرةٍ حارّةٍ تُتلف كلّ أثرٍ للحياة.

## 🔮 دلالة المستحاثات: شاهدٌ على الماضي

المستحاثات ليست حجارةً جميلةً فحسب، بل **وثائق** تقرأ منها الأرضُ تاريخها:

- **شاهدٌ على أحياء الماضي**: تدلّ على كائناتٍ عاشت قديمًا، بعضها **انقرض** ولم يعد له وجود (كالحيوانات الضخمة القديمة).
- **دليلٌ على البيئة القديمة**: إذا وجدنا **مستحاثات بحريّة** (أصداف، مرجان) في **منطقةٍ يابسةٍ اليوم** كالجنوب التونسيّ الصحراويّ، استنتجنا أنّ تلك المنطقة كانت **مغمورةً بالبحر** في الماضي البعيد.
- **أداةٌ لتأريخ الطبقات**: بما أنّ الطبقة السفلى أقدم من العليا، فإنّ مستحاثةً في طبقةٍ عميقةٍ تكون **أقدم** من مستحاثةٍ في طبقةٍ أعلى، فنرتّب بها أحداث الماضي.

> 🔮 مثال ميدانيّ: يعثر جيولوجيّ في **هضبة أَملال** الصحراويّة على صخرةٍ كلسيّةٍ مليئةٍ بأصداف بحريّة متحجّرة. لا وجود للبحر هناك اليوم، لكنّ هذه المستحاثات تؤكّد أنّ **بحرًا قديمًا غمر المكان** ثم انحسر، وأنّ الأصداف ترسّبت وتحوّلت مع رواسبها إلى كلسٍ يحمل شهادتها.

> 🏆 أتقنت الآن كيف نميّز الصخور الرسوبيّة عن الصهاريّة، وأنواعها وخصائصها، وكيف تتشكّل في طبقات، وكيف تحبس المستحاثات التي تروي لنا ماضي الحياة والبيئة. أصبحت تقرأ صفحاتٍ من كتاب الأرض!', '# 📜 ملخّص: الصخور الرسوبية والمستحاثات

- **تعريف الصخرة الرسوبيّة**: صخرةٌ تتكوّن قرب سطح الأرض بتراكم الرواسب ثم تصلّبها؛ علاماتها: طبقات، ليونة نسبيّة، واحتمال وجود مستحاثات.
- **رسوبيّة أم صهاريّة؟**: الرسوبيّة تتكوّن من تراكم رواسب وقد تحوي مستحاثات (رمل، طين، كلس)؛ الصهاريّة (البركانيّة) تتكوّن من تبرّد الصهارة ولا تحوي مستحاثات أبدًا (بازلت، غرانيت).
- **أنواع الصخور الرسوبيّة**: الرمل/الحجر الرمليّ (حبيبات مرئيّة، نفوذة)، الطين (حبيبات دقيقة جدًّا، كتيمة لدنة عند البلّ)، الكلس (يفور مع حمض كلور الماء المخفّف بانطلاق ثاني أكسيد الكربون).
- **اختبار الكلس**: قطرة حمضٍ مخفّفٍ ← فوران وفقاعات = صخرة كلسيّة؛ الرمل والطين لا يفوران.
- **مراحل التشكّل**: تعرية ← نقل ← ترسّب (حين تضعف سرعة الماء أو الريح) ← تراكم في طبقات ← تصلّب تحت ثقل الطبقات العليا.
- **ترتيب الطبقات (التعاقب)**: الطبقة السفلى الأقدم والعليا الأحدث (ما لم تنقلب).
- **المستحاثة**: بقايا كائنٍ حيّ أو أثرٌ تركه، محفوظٌ في صخرة رسوبيّة. **ليس كلّ ميّتٍ يتحفّظ**: يلزم دفنٌ سريع ووجود أجزاء صلبة (عظام، أصداف) ووسطٌ يحمي من التعفّن.
- **أنواعها**: بقايا مباشرة (عظم، صدفة، سنّ) أو آثار (بصمة ورقة، أثر أقدام).
- **دلالتها**: شاهدٌ على أحياء الماضي (بعضها انقرض)، ودليلٌ على البيئة القديمة (مستحاثات بحريّة في منطقة يابسة = بحرٌ قديمٌ غمرها)، وأداةٌ لتأريخ الطبقات وترتيب أحداث الماضي.', 8, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('48065d0a-33cd-5ee5-b533-2802a227a3cb', '634232e9-8b06-5b3e-a417-0e8d27211dd9', 'sciences-vie-terre-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('037b2e85-6130-5718-b164-5ab940649234', '48065d0a-33cd-5ee5-b533-2802a227a3cb', 'ما الذي يميّز التّكاثر الخضريّ (اللّاجنسيّ) عند النّبات؟', '[{"id":"a","text":"يحتاج إلى زهرة وتأبير وإخصاب لتتكوّن بذرة"},{"id":"b","text":"ينتج نبتة تختلف كثيرًا عن النّبات الأمّ"},{"id":"c","text":"ينتج نبتة جديدة من عضو خضريّ، دون زهرة ولا بذرة، فتكون نسخة مطابقة للأمّ"},{"id":"d","text":"لا يحدث إلّا داخل بذور النّبات"}]'::jsonb, 'c', 'التّكاثر الخضريّ ينتج نبتة جديدة انطلاقًا من عضو خضريّ (ساق أو جذر أو ورقة) دون زهرة ولا بذرة ولا إخصاب، فتكون النّبتة نسخة مطابقة للنّبات الأمّ. الحاجة إلى الزّهرة والبذرة تخصّ التّكاثر الجنسيّ.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('11c47cac-5992-5223-b711-6503c9c42afa', '48065d0a-33cd-5ee5-b533-2802a227a3cb', 'بأيّ عضو خضريّ تتكاثر البطاطا في الطّبيعة؟', '[{"id":"a","text":"بالدّرنة"},{"id":"b","text":"بالبصلة"},{"id":"c","text":"بالبذرة"},{"id":"d","text":"بالجذمور"}]'::jsonb, 'a', 'البطاطا تتكاثر بالدّرنة، وهي انتفاخ في ساق تحت أرضيّة يخزّن موادّ احتياطيّة وعليه براعم (عيون) تنبت منها نباتات جديدة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8848618c-8585-52b7-858f-d54f3c290b9b', '48065d0a-33cd-5ee5-b533-2802a227a3cb', 'كيف تُكثِر نخلةً في واحة توزر مع الحفاظ على نوع تمرها نفسه؟', '[{"id":"a","text":"بزرع نواة تمرة منها"},{"id":"b","text":"بقطع أوراقها وغرسها في الماء"},{"id":"c","text":"بتطعيم غصن منها على شجرة زيتون"},{"id":"d","text":"بفصل فسيلة تنمو عند قاعدتها وغرسها"}]'::jsonb, 'd', 'الفسيلة برعم ينمو عند قاعدة النّخلة الأمّ؛ بفصلها وغرسها نحصل على نخلة نسخة مطابقة للأمّ بنفس نوع تمرها. زرع النّواة تكاثر جنسيّ قد يعطي تمرًا مختلفًا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('73907a87-342a-5af2-9f81-07bff2fabb4d', '48065d0a-33cd-5ee5-b533-2802a227a3cb', 'في تقنية العُقلة، ماذا يفعل الفلّاح ليُكثر شجرة تين؟', '[{"id":"a","text":"يركّب غصنًا من التّين على شجرة أخرى متجذّرة"},{"id":"b","text":"يفصل غصنًا من الشّجرة ثمّ يغرسه فيكوّن جذورًا وينمو نبتة جديدة"},{"id":"c","text":"يثني غصنًا متّصلًا بالشّجرة ويطمره دون فصله"},{"id":"d","text":"ينتظر سقوط بذور التّين لتنبت وحدها"}]'::jsonb, 'b', 'في العُقلة يُفصل جزء من النّبات (غصن أو ساق) أوّلًا ثمّ يُغرس في التّربة أو الماء فيكوّن جذورًا وينمو نبتة جديدة. تركيب الطّعم يخصّ التّطعيم، وثني الغصن المتّصل يخصّ الترقيد.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('746f174e-accb-54dc-9b02-eb7984dbc1b7', '48065d0a-33cd-5ee5-b533-2802a227a3cb', 'ما الفرق الأساسيّ بين الترقيد والتطعيم؟', '[{"id":"a","text":"الترقيد تكاثر جنسيّ بالبذور، أمّا التطعيم فتكاثر خضريّ"},{"id":"b","text":"كلاهما يعتمد على زرع البذور في التّربة"},{"id":"c","text":"في الترقيد يُطمر غصن متّصل بالأمّ حتّى يجذّر ثمّ يُفصل، وفي التطعيم يُركّب طُعم على حامل متجذّر من نبات آخر"},{"id":"d","text":"لا فرق بينهما، فهما اسمان لنفس التّقنية"}]'::jsonb, 'c', 'الترقيد يعتمد على غصن يبقى متّصلًا بالنّبات الأمّ حتّى يكوّن جذورًا ثمّ يُفصل، بينما التطعيم يجمع بين نباتين مختلفين: طُعم يُركّب على حامل متجذّر. وكلاهما تكاثر خضريّ لا جنسيّ (لا بذور).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('32565d66-3cf6-5143-8708-ccd52cb9c5ef', '634232e9-8b06-5b3e-a417-0e8d27211dd9', 'sciences-vie-terre-8eme', '⭐ تمرين: التّكاثر الخضريّ عند النّبات', 1, 50, 10, 'practice', 'admin', 1)
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
  ('b50e5c82-f069-5c59-9f14-a517feeb37a4', '32565d66-3cf6-5143-8708-ccd52cb9c5ef', 'نبتة جديدة ظهرت انطلاقًا من ساق نبات دون أن تمرّ عبر زهرة ولا بذرة. ما نوع هذا التّكاثر؟', '[{"id":"a","text":"تكاثر جنسيّ"},{"id":"b","text":"تكاثر خضريّ (لا جنسيّ)"},{"id":"c","text":"تكاثر بالبذور"},{"id":"d","text":"تكاثر بالإخصاب"}]'::jsonb, 'b', 'ظهور نبتة جديدة من عضو خضريّ (ساق) دون زهرة ولا بذرة ولا إخصاب هو التّكاثر الخضريّ اللّاجنسيّ. أمّا التّكاثر الجنسيّ فيمرّ عبر الزّهرة والإخصاب والبذرة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('85a77b01-7d9d-5013-8d7b-38b9d984edb5', '32565d66-3cf6-5143-8708-ccd52cb9c5ef', 'يتكاثر البصل في حقل بالقيروان انطلاقًا من عضو خضريّ ذي أوراق سميكة مدّخِرة للغذاء. ما اسم هذا العضو؟', '[{"id":"a","text":"الجذمور"},{"id":"b","text":"الدّرنة"},{"id":"c","text":"البصلة"},{"id":"d","text":"السّاق الزّاحفة"}]'::jsonb, 'c', 'البصلة ساق قصيرة جدًّا محاطة بأوراق سميكة مدّخِرة للغذاء، وهي عضو التّكاثر الخضريّ عند البصل والثّوم؛ تعطي بصيلات جديدة تنمو نباتات مستقلّة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('20743489-0031-5ccb-9ac8-b1c76fcc34a5', '32565d66-3cf6-5143-8708-ccd52cb9c5ef', 'تنتشر نبتة الفراولة في حديقة بنابل بواسطة سيقان تزحف فوق سطح التّربة وتكوّن جذورًا عند تماسّها بالأرض. ماذا نسمّي هذا العضو؟', '[{"id":"a","text":"الجذمور"},{"id":"b","text":"البصلة"},{"id":"c","text":"الفسيلة"},{"id":"d","text":"السّاق الزّاحفة (المدّادة)"}]'::jsonb, 'd', 'السّاق الزّاحفة تنمو أفقيًّا فوق سطح التّربة وتكوّن جذورًا وبراعم عند نقاط تماسّها بالأرض فتعطي نباتات جديدة، كما في الفراولة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ed696e50-7d38-5818-8d22-52b5da5ee047', '32565d66-3cf6-5143-8708-ccd52cb9c5ef', 'ينمو نبات القصب على ضفّة وادٍ بواسطة ساق أفقيّة تمتدّ تحت سطح التّربة وتحمل براعم. ما اسم هذا العضو الخضريّ؟', '[{"id":"a","text":"الجذمور"},{"id":"b","text":"الدّرنة"},{"id":"c","text":"البصلة"},{"id":"d","text":"الفسيلة"}]'::jsonb, 'a', 'الجذمور ساق تنمو أفقيًّا تحت التّربة وتحمل براعم يعطي كلٌّ منها نبتة جديدة، كما في القصب والسّوسن.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('edff8b61-4832-55c8-9177-bb10e50d8c8b', '32565d66-3cf6-5143-8708-ccd52cb9c5ef', 'في التّكاثر الخضريّ، كيف تكون النّبتة الجديدة مقارنة بالنّبات الأمّ؟', '[{"id":"a","text":"مختلفة تمامًا عنه في صفاتها"},{"id":"b","text":"نسخة مطابقة له تحمل صفاته نفسها"},{"id":"c","text":"أضعف منه دائمًا ولا تثمر أبدًا"},{"id":"d","text":"تتحوّل إلى نوع نباتيّ آخر"}]'::jsonb, 'b', 'لأنّ التّكاثر الخضريّ ينطلق من عضو خضريّ للأمّ دون إخصاب، تكون النّبتة الجديدة نسخة مطابقة للنّبات الأمّ تحمل صفاته نفسها (نفس نوع الثّمرة ومذاقها).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2a03a1c7-f8c8-57bd-92f1-2156bd0bf8de', '32565d66-3cf6-5143-8708-ccd52cb9c5ef', 'أخذ بستانيّ في الوطن القبليّ غصنًا من شجرة الياسمين (الفلّ)، فصله وغرسه في التّربة فكوّن جذورًا ونما نبتة جديدة. ما اسم هذه التّقنية؟', '[{"id":"a","text":"الترقيد"},{"id":"b","text":"التطعيم"},{"id":"c","text":"العُقلة"},{"id":"d","text":"زرع البذور"}]'::jsonb, 'c', 'العُقلة تقنية تكاثر خضريّ اصطناعيّ: يُفصل جزء من النّبات (غصن) ثمّ يُغرس فيكوّن جذورًا وينمو نبتة جديدة، كما في الياسمين والعنب والتّين.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('18788a03-a302-5110-9255-8db6881b174a', '634232e9-8b06-5b3e-a417-0e8d27211dd9', 'sciences-vie-terre-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: التّكاثر الخضريّ عند النّبات', 3, 120, 30, 'boss', 'admin', 2)
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
  ('077df22e-6ad6-5cf9-8ddd-fda5ac0f3024', '18788a03-a302-5110-9255-8db6881b174a', 'أيّ ممّا يلي يُعدّ عضوًا من أعضاء التّكاثر الخضريّ الطّبيعيّ عند النّبات؟', '[{"id":"a","text":"الدّرنة"},{"id":"b","text":"الزّهرة"},{"id":"c","text":"البذرة"},{"id":"d","text":"حبّة اللّقاح"}]'::jsonb, 'a', 'الدّرنة عضو تكاثر خضريّ طبيعيّ (كما في البطاطا). أمّا الزّهرة وحبّة اللّقاح والبذرة فتخصّ التّكاثر الجنسيّ لا الخضريّ.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('61e4e128-193e-5367-9eba-27ebbd2803a2', '18788a03-a302-5110-9255-8db6881b174a', 'ما الفرق الدّقيق بين العُقلة والترقيد؟', '[{"id":"a","text":"لا فرق بينهما، فكلاهما يعتمد على زرع البذور"},{"id":"b","text":"العُقلة تكاثر جنسيّ والترقيد تكاثر خضريّ"},{"id":"c","text":"في العُقلة يُفصل الجزء عن الأمّ أوّلًا ثمّ يُغرس، وفي الترقيد يبقى الغصن متّصلًا بالأمّ حتّى يجذّر ثمّ يُفصل"},{"id":"d","text":"الترقيد يجمع بين نباتين مختلفين، والعُقلة تركّب طُعمًا على حامل"}]'::jsonb, 'c', 'في العُقلة يُفصل جزء النّبات أوّلًا ثمّ يُغرس، بينما في الترقيد يبقى الغصن متّصلًا بالنّبات الأمّ حتّى يكوّن جذورًا ثمّ يُفصل بعد ذلك. الجمع بين نباتين مختلفين يخصّ التطعيم، وكلاهما تكاثر خضريّ لا جنسيّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2d931d2e-69b1-53ea-827d-9e2997a4e155', '18788a03-a302-5110-9255-8db6881b174a', 'متى نقول إنّ التّكاثر الخضريّ طبيعيّ لا اصطناعيّ؟', '[{"id":"a","text":"عندما يزرع الفلّاح بذورًا في التّربة"},{"id":"b","text":"عندما تنتشر الجذامير والفسائل وتنبت الدّرنات وحدها دون تدخّل الإنسان"},{"id":"c","text":"عندما يطعّم الفلّاح شجرة على أخرى"},{"id":"d","text":"عندما يفصل الفلّاح عُقلة ويغرسها"}]'::jsonb, 'b', 'التّكاثر الخضريّ الطّبيعيّ يحدث دون تدخّل الإنسان: انتشار الجذامير والسّيقان الزّاحفة والفسائل ونبات الدّرنات والبصلات من تلقاء نفسها. أمّا العُقلة والترقيد والتطعيم فتكاثر خضريّ اصطناعيّ ينجزه الإنسان.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('275a2293-acef-591b-b2dd-5e62e9d386fc', '18788a03-a302-5110-9255-8db6881b174a', 'يريد فلّاح في الوطن القبليّ إكثار شجرة مشمش ممتازة بتركيب غصن منها على شجرة أخرى متجذّرة، ليحصل على ثمار من النّوع الجيّد نفسه. ما التّقنية الملائمة؟', '[{"id":"a","text":"زرع نوى المشمش"},{"id":"b","text":"السّاق الزّاحفة"},{"id":"c","text":"التّكاثر بالبصلة"},{"id":"d","text":"التطعيم"}]'::jsonb, 'd', 'التطعيم هو تركيب طُعم (غصن من الشّجرة الجيّدة) على حامل متجذّر، فيلتحمان وينمو الطّعم بجذور الحامل ويعطي ثمارًا من النّوع نفسه. زرع النّوى تكاثر جنسيّ قد يعطي ثمارًا مختلفة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0d8a963e-04e4-524f-8f44-0276a3411f06', '18788a03-a302-5110-9255-8db6881b174a', 'لاحظ تلميذ أنّ درنة بطاطا تُركت في مخزن رطب أنبتت عدّة نباتات صغيرة من نقاط محدّدة على سطحها. ما تفسير ذلك؟', '[{"id":"a","text":"لأنّ الدّرنة بذرة أنبتت جنينًا واحدًا فقط"},{"id":"b","text":"لأنّ الرّطوبة حوّلت الدّرنة إلى زهرة"},{"id":"c","text":"لأنّ الدّرنة تحمل براعم (عيونًا) ينبت كلٌّ منها نبتة جديدة بفضل الموادّ المدّخرة فيها"},{"id":"d","text":"لأنّ الدّرنة امتصّت بذورًا من الهواء المحيط"}]'::jsonb, 'c', 'الدّرنة تخزّن موادّ احتياطيّة وتحمل براعم تُسمّى العيون؛ ينبت كلٌّ منها نبتة جديدة معتمدة على غذاء الدّرنة، وهذا تكاثر خضريّ لا علاقة له بالبذور ولا بالأزهار.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6330ad06-c030-5c57-9ba7-1a9b19339b72', '18788a03-a302-5110-9255-8db6881b174a', 'زرع فلّاح نواة تمرة من نخلة ذات تمر ممتاز، ففوجئ بأنّ النّخلة النّاتجة أعطت تمرًا مختلفًا وأقلّ جودة. ما التّفسير العلميّ الأصحّ؟', '[{"id":"a","text":"زرع النّواة تكاثر جنسيّ، فقد تعطي نبتة مختلفة عن الأمّ؛ ولضمان النّوع نفسه كان عليه استعمال الفسيلة (تكاثر خضريّ)"},{"id":"b","text":"لأنّ الفسائل تعطي تمرًا مختلفًا دائمًا عن الأمّ"},{"id":"c","text":"لأنّ التّكاثر بالنّواة ينتج نسخة مطابقة للأمّ دائمًا"},{"id":"d","text":"لأنّ النّخيل لا يتكاثر إلّا بالتطعيم على الزّيتون"}]'::jsonb, 'a', 'زرع النّواة تكاثر جنسيّ يمرّ عبر البذرة، فقد يعطي نبتة تختلف عن الأمّ. لضمان النّوع نفسه يُلجأ إلى التّكاثر الخضريّ بالفسيلة، لأنّها تعطي نسخة مطابقة للنّخلة الأمّ.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('58aa5e5c-8633-5c0d-ad49-e7edb4c733d1', '634232e9-8b06-5b3e-a417-0e8d27211dd9', 'sciences-vie-terre-8eme', '⭐⭐ تمرين مراجعة (نمط امتحان): التّكاثر الخضريّ عند النّبات', 2, 70, 15, 'practice', 'admin', 3)
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
  ('6864b523-f443-56b2-9e9f-e193ae83b734', '58aa5e5c-8633-5c0d-ad49-e7edb4c733d1', 'أيّ نبات ممّا يلي يتكاثر خضريًّا بواسطة بصلة؟', '[{"id":"a","text":"القصب"},{"id":"b","text":"البطاطا"},{"id":"c","text":"الفراولة"},{"id":"d","text":"الثّوم"}]'::jsonb, 'd', 'الثّوم يتكاثر بالبصلة، مثل البصل. أمّا القصب فيتكاثر بالجذمور، والبطاطا بالدّرنة، والفراولة بالسّاق الزّاحفة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9a791d06-520e-5f85-a85f-8f88d44da349', '58aa5e5c-8633-5c0d-ad49-e7edb4c733d1', 'ينمو من قاعدة نخلة في واحة توزر برعم يعطي نخلة صغيرة تُفصل وتُغرس. ما اسم عضو التّكاثر الخضريّ هذا؟', '[{"id":"a","text":"الدّرنة"},{"id":"b","text":"الفسيلة"},{"id":"c","text":"الجذمور"},{"id":"d","text":"البصلة"}]'::jsonb, 'b', 'الفسيلة برعم ينمو من قاعدة النّبات الأمّ (كالنّخلة) أو من جذوره، فيعطي نبتة صغيرة تُفصل وتُغرس لتنمو نباتًا مستقلًّا مطابقًا للأمّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a85ff69e-ea17-5c53-a498-f44e13fdc12b', '58aa5e5c-8633-5c0d-ad49-e7edb4c733d1', 'أراد فلّاح في ضيعة بجندوبة إكثار كرمة عنب، فقطع منها غصنًا وغرسه مباشرة في التّربة فكوّن جذورًا ونما. ما التّقنية التي استعملها؟', '[{"id":"a","text":"التطعيم"},{"id":"b","text":"التّكاثر بالبذور"},{"id":"c","text":"العُقلة"},{"id":"d","text":"التّكاثر بالجذمور"}]'::jsonb, 'c', 'قطع غصن وغرسه مباشرة ليكوّن جذورًا هو العُقلة، وهي تقنية تكاثر خضريّ اصطناعيّ شائعة في إكثار العنب والتّين والياسمين.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fa595ac6-c8ec-5b02-8fa8-6c99d6bfd70d', '58aa5e5c-8633-5c0d-ad49-e7edb4c733d1', 'في بستان حمضيّات بنابل، رُكّب غصن برتقال جيّد على شجرة صغيرة متجذّرة من نوع آخر، فالتحما ونما الغصن معطيًا برتقالًا من النّوع الجيّد. ما اسم هذه التّقنية؟', '[{"id":"a","text":"التطعيم"},{"id":"b","text":"الترقيد"},{"id":"c","text":"التّكاثر بالبصلة"},{"id":"d","text":"التّكاثر بالسّاق الزّاحفة"}]'::jsonb, 'a', 'تركيب غصن (طُعم) على شجرة أخرى متجذّرة (حامل) حتّى يلتحما وينمو الطّعم هو التطعيم، وهو شائع في إكثار أشجار الحمضيّات مع الحفاظ على نوع الثّمرة الجيّد.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e60f1b9c-891a-5b6c-b821-a8af4bb74ce1', '58aa5e5c-8633-5c0d-ad49-e7edb4c733d1', 'ما الفرق بين الجذمور والدّرنة؟', '[{"id":"a","text":"الجذمور بذرة، والدّرنة زهرة"},{"id":"b","text":"كلاهما ساق تنمو فوق سطح التّربة وتزحف"},{"id":"c","text":"الجذمور ساق أفقيّة تحت التّربة تحمل براعم، والدّرنة انتفاخ في ساق تحت أرضيّة يخزّن موادّ احتياطيّة وعليه عيون"},{"id":"d","text":"الجذمور عضو تكاثر جنسيّ، والدّرنة عضو تكاثر خضريّ"}]'::jsonb, 'c', 'الجذمور ساق أفقيّة تمتدّ تحت التّربة وتحمل براعم (القصب)، بينما الدّرنة انتفاخ مدّخِر في ساق تحت أرضيّة عليه براعم تُسمّى العيون (البطاطا). وكلاهما عضو تكاثر خضريّ لا جنسيّ.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6f2f202a-b3de-523f-bb09-ffa98338ede6', '58aa5e5c-8633-5c0d-ad49-e7edb4c733d1', 'لماذا يفضّل فلّاح استعمال التّكاثر الخضريّ لإكثار شجرة تين مذاق ثمرها ممتاز، بدل زرع بذورها؟', '[{"id":"a","text":"لأنّ زرع البذور أسرع دائمًا من التّكاثر الخضريّ"},{"id":"b","text":"لأنّ التّكاثر الخضريّ ينتج نسخة مطابقة للأمّ فيحافظ على مذاق الثّمرة نفسه، بينما قد يعطي زرع البذور ثمارًا مختلفة"},{"id":"c","text":"لأنّ التّكاثر الخضريّ يحوّل التّين إلى نوع نباتيّ آخر"},{"id":"d","text":"لأنّ البذور لا تنبت أبدًا عند التّين"}]'::jsonb, 'b', 'التّكاثر الخضريّ يعطي نبتة نسخة مطابقة للأمّ، فيضمن الفلّاح مذاق الثّمرة ونوعها نفسه؛ أمّا زرع البذور (تكاثر جنسيّ) فقد يعطي ثمارًا مختلفة عن الأمّ.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c31f20c8-26e6-5065-9299-1944741f24c5', '634232e9-8b06-5b3e-a417-0e8d27211dd9', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: التّكاثر الخضريّ عند النّبات', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('a6e25046-af44-5262-99da-5e2c655ae559', 'c31f20c8-26e6-5065-9299-1944741f24c5', 'أيّ مجموعة ممّا يلي تضمّ تقنيّات التّكاثر الخضريّ الاصطناعيّ الثّلاث (التي ينجزها الإنسان)؟', '[{"id":"a","text":"الجذمور والدّرنة والبصلة"},{"id":"b","text":"الفسائل والسّاق الزّاحفة والجذمور"},{"id":"c","text":"العُقلة والترقيد والتطعيم"},{"id":"d","text":"الزّهرة والبذرة والإخصاب"}]'::jsonb, 'c', 'التّكاثر الخضريّ الاصطناعيّ ينجزه الإنسان بثلاث تقنيّات: العُقلة والترقيد والتطعيم. أمّا الجذمور والدّرنة والبصلة والفسائل والسّاق الزّاحفة فأعضاء تكاثر خضريّ طبيعيّ، والزّهرة والبذرة والإخصاب فتخصّ التّكاثر الجنسيّ.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('52a1fe86-24c5-52b4-9aff-ee3259306b82', 'c31f20c8-26e6-5065-9299-1944741f24c5', 'صنّف تلميذ البصلة ضمن أعضاء التّكاثر الجنسيّ. أين يكمن الخطأ بالضّبط؟', '[{"id":"a","text":"الخطأ أنّ البصلة عضو تكاثر خضريّ (لا جنسيّ)، فهي ساق قصيرة بأوراق مدّخِرة تعطي بصيلات مطابقة للأمّ دون زهرة ولا بذرة"},{"id":"b","text":"لا خطأ، فالبصلة فعلًا عضو تكاثر جنسيّ لأنّها تحتوي بذورًا"},{"id":"c","text":"الخطأ فقط في الاسم؛ فالبصلة تُسمّى في الحقيقة درنة"},{"id":"d","text":"الخطأ أنّ البصلة عضو تكاثر جنسيّ يحتاج إلى إخصاب زهرتين"}]'::jsonb, 'a', 'البصلة عضو تكاثر خضريّ لا جنسيّ: ساق قصيرة محاطة بأوراق سميكة مدّخِرة، تعطي بصيلات جديدة مطابقة للأمّ دون زهرة ولا بذرة ولا إخصاب. فالخطأ في تصنيفها ضمن التّكاثر الجنسيّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bcaeec67-1e37-5d61-9e87-607f3719db2a', 'c31f20c8-26e6-5065-9299-1944741f24c5', 'أيّ العبارات التالية عن التّكاثر الخضريّ **خاطئة**؟', '[{"id":"a","text":"النّبتة النّاتجة عن التّكاثر الخضريّ نسخة مطابقة للنّبات الأمّ"},{"id":"b","text":"البطاطا تتكاثر خضريًّا بالدّرنة، والقصب بالجذمور"},{"id":"c","text":"التطعيم والعُقلة والترقيد تقنيّات تكاثر خضريّ اصطناعيّ"},{"id":"d","text":"التّكاثر الخضريّ يحتاج دائمًا إلى زهرة وإخصاب لتتكوّن بذرة"}]'::jsonb, 'd', 'العبارة الخاطئة هي أنّ التّكاثر الخضريّ يحتاج إلى زهرة وإخصاب وبذرة: هذا يخصّ التّكاثر الجنسيّ. التّكاثر الخضريّ لا جنسيّ ينطلق من عضو خضريّ دون شيء من ذلك. العبارات الثّلاث الأخرى صحيحة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6eb1b6c7-b7b7-5702-a85b-c8692cab46f5', 'c31f20c8-26e6-5065-9299-1944741f24c5', 'يريد بستانيّ إكثار الياسمين بالترقيد. أيّ وصف يصف خطوات الترقيد وصفًا صحيحًا؟', '[{"id":"a","text":"يفصل غصنًا كاملًا أوّلًا ثمّ يغرسه مباشرة في التّربة"},{"id":"b","text":"يثني غصنًا مرنًا متّصلًا بالنّبات الأمّ، يطمر جزءًا منه في التّربة حتّى يكوّن جذورًا، ثمّ يفصله عن الأمّ"},{"id":"c","text":"يركّب غصنًا من الياسمين على شجرة زيتون متجذّرة"},{"id":"d","text":"يزرع بذور الياسمين في أصيص وينتظر إنباتها"}]'::jsonb, 'b', 'الترقيد: يُثنى غصن مرن يبقى متّصلًا بالنّبات الأمّ، ويُطمر جزء منه في التّربة حتّى يكوّن جذورًا، ثمّ يُفصل بعد ذلك. الفصل أوّلًا ثمّ الغرس هو العُقلة، والتّركيب على شجرة أخرى هو التطعيم.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('49ef8acd-9569-56d9-8c85-90b86a4fd924', 'c31f20c8-26e6-5065-9299-1944741f24c5', 'يريد مشتلٌ إنتاج آلاف نباتات فراولة **متطابقة** الصّفات وبسرعة كبيرة لتسويقها. ما الطّريقة الأنسب علميًّا؟', '[{"id":"a","text":"زرع بذور الفراولة، لأنّها تعطي نباتات مطابقة تمامًا للأمّ"},{"id":"b","text":"تطعيم كلّ نبتة فراولة على شجرة زيتون"},{"id":"c","text":"انتظار التّأبير والإخصاب بين الأزهار لإنتاج نباتات متطابقة"},{"id":"d","text":"التّكاثر الخضريّ (بالسّيقان الزّاحفة أو العُقل)، لأنّه سريع ويعطي نسخًا مطابقة للأمّ"}]'::jsonb, 'd', 'للحصول على نباتات متطابقة بسرعة يُختار التّكاثر الخضريّ (السّاق الزّاحفة أو العُقل)، لأنّه لا جنسيّ فيعطي نسخًا مطابقة للأمّ وينتشر بسرعة. زرع البذور والتّأبير والإخصاب تكاثر جنسيّ يعطي نباتات مختلفة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('80f8f48a-e72c-5422-8db8-4bfd9342ffd1', 'c31f20c8-26e6-5065-9299-1944741f24c5', 'رتّب تلميذ أربعة نباتات مع أعضاء تكاثرها الخضريّ. أيّ ترتيب صحيح تمامًا؟', '[{"id":"a","text":"البطاطا ← درنة، البصل ← بصلة، القصب ← جذمور، النّخيل ← فسيلة"},{"id":"b","text":"البطاطا ← بصلة، البصل ← درنة، القصب ← فسيلة، النّخيل ← جذمور"},{"id":"c","text":"البطاطا ← جذمور، البصل ← فسيلة، القصب ← بصلة، النّخيل ← درنة"},{"id":"d","text":"البطاطا ← فسيلة، البصل ← جذمور، القصب ← درنة، النّخيل ← بصلة"}]'::jsonb, 'a', 'الرّبط الصّحيح: البطاطا تتكاثر بالدّرنة، والبصل بالبصلة، والقصب بالجذمور، والنّخيل بالفسيلة. بقيّة التّرتيبات تخلط بين هذه الأعضاء الأربعة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ab075f92-8aaa-51b7-bf2a-5b2a3924c767', '634232e9-8b06-5b3e-a417-0e8d27211dd9', 'sciences-vie-terre-8eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): التّكاثر الخضريّ عند النّبات', 3, 120, 30, 'boss', 'admin', 5)
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
  ('5df8db17-11ba-533c-9ad1-216c345a45b1', 'ab075f92-8aaa-51b7-bf2a-5b2a3924c767', 'أيّ عبارة تصف السّاق الزّاحفة (المدّادة) وصفًا صحيحًا؟', '[{"id":"a","text":"انتفاخ تحت أرضيّ يخزّن موادّ احتياطيّة"},{"id":"b","text":"ساق تزحف فوق سطح التّربة وتكوّن جذورًا وبراعم عند نقاط تماسّها بالأرض"},{"id":"c","text":"ساق قصيرة محاطة بأوراق سميكة مدّخِرة"},{"id":"d","text":"برعم ينمو من قاعدة النّبات الأمّ"}]'::jsonb, 'b', 'السّاق الزّاحفة تنمو أفقيًّا فوق سطح التّربة وتكوّن جذورًا وبراعم عند تماسّها بالأرض فتعطي نباتات جديدة (الفراولة). الانتفاخ المدّخر هو الدّرنة، والسّاق ذات الأوراق المدّخِرة هي البصلة، والبرعم من قاعدة الأمّ هو الفسيلة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f1c52d35-364c-5c33-be10-3cf34c9eeabc', 'ab075f92-8aaa-51b7-bf2a-5b2a3924c767', 'يشترك النّخيل والموز والصّبّار في التّكاثر الخضريّ بواسطة عضو ينمو من قاعدة النّبات الأمّ. ما اسمه؟', '[{"id":"a","text":"الجذمور"},{"id":"b","text":"الدّرنة"},{"id":"c","text":"البصلة"},{"id":"d","text":"الفسائل"}]'::jsonb, 'd', 'الفسائل براعم تنمو من قاعدة النّبات الأمّ أو جذوره فتعطي نباتات جديدة تُفصل وتُغرس، وهي طريقة تكاثر النّخيل والموز والصّبّار.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('67d16759-289b-5815-b14d-c59b22a691c9', 'ab075f92-8aaa-51b7-bf2a-5b2a3924c767', 'في تقنية العُقلة، ما الجزء الذي يمكن أن يأخذه الفلّاح من النّبات ليغرسه؟', '[{"id":"a","text":"غصنًا أو ساقًا أو ورقة يفصلها ثمّ يغرسها فتكوّن جذورًا"},{"id":"b","text":"زهرة يفصلها لتتحوّل مباشرة إلى نبتة"},{"id":"c","text":"بذرة ناضجة يزرعها في التّربة"},{"id":"d","text":"حبّة لقاح يضعها في التّربة"}]'::jsonb, 'a', 'العُقلة جزء خضريّ (غصن أو ساق أو ورقة) يُفصل عن النّبات ثمّ يُغرس فيكوّن جذورًا وينمو نبتة جديدة. الزّهرة والبذرة وحبّة اللّقاح تخصّ التّكاثر الجنسيّ لا العُقلة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('96b44086-4e9c-53f8-b27f-c7f97b7f200e', 'ab075f92-8aaa-51b7-bf2a-5b2a3924c767', 'طعّم فلّاح غصن مشمش جيّد على حامل متجذّر، لكنّه توقّع أن يعطي الطّعم نوعًا جديدًا مختلفًا من الثّمار. ما الخطأ في توقّعه؟', '[{"id":"a","text":"لا خطأ، فالتطعيم يُنتج دائمًا نوعًا جديدًا من الثّمار"},{"id":"b","text":"الخطأ أنّ الطّعم لا ينمو أبدًا على حامل من نبات آخر"},{"id":"c","text":"الخطأ أنّ الطّعم يعطي ثمارًا من نوعه هو (المشمش الجيّد) لأنّه تكاثر خضريّ يحافظ على صفات الطّعم، لا نوعًا جديدًا"},{"id":"d","text":"الخطأ أنّ التطعيم تكاثر جنسيّ يعطي ثمارًا مختلفة دائمًا"}]'::jsonb, 'c', 'التطعيم تكاثر خضريّ: ينمو الطّعم معتمدًا على جذور الحامل لكنّه يحتفظ بصفاته هو، فيعطي ثمارًا من نوع الطّعم الجيّد نفسه، لا نوعًا جديدًا. لهذا يُستعمل التطعيم أصلًا: للحفاظ على النّوع الجيّد.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f423630a-0355-5d72-a22c-a48c3950e172', 'ab075f92-8aaa-51b7-bf2a-5b2a3924c767', 'يجد فلّاح صعوبة كبيرة في التّخلّص نهائيًّا من نبات القصب الذي غزا حقله، إذ يعود للظّهور كلّما اقتلعه. ما التّفسير العلميّ؟', '[{"id":"a","text":"لأنّ القصب يتكاثر خضريًّا بجذاميره التي تمتدّ تحت التّربة وتعطي نباتات جديدة بسرعة"},{"id":"b","text":"لأنّ القصب يتكاثر فقط بالبذور التي تنقلها الرّياح"},{"id":"c","text":"لأنّ القصب يتطعّم تلقائيًّا على نباتات الحقل الأخرى"},{"id":"d","text":"لأنّ القصب يتكاثر بالبصلات تحت التّربة"}]'::jsonb, 'a', 'القصب يتكاثر خضريًّا طبيعيًّا بالجذمور، وهو ساق أفقيّة تمتدّ تحت التّربة وتحمل براعم؛ يكفي بقاء قطعة منها في الأرض لتعطي نباتات جديدة، فيصعب استئصاله.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('60c3f038-6456-50b9-9a2d-29ed23a898aa', 'ab075f92-8aaa-51b7-bf2a-5b2a3924c767', 'في أيّ تقنية من تقنيّات التّكاثر الخضريّ الاصطناعيّ يبقى الغصن **متّصلًا** بالنّبات الأمّ حتّى يكوّن جذورًا، ثمّ يُفصل بعد ذلك؟', '[{"id":"a","text":"العُقلة"},{"id":"b","text":"التطعيم"},{"id":"c","text":"التّكاثر بالبذور"},{"id":"d","text":"الترقيد"}]'::jsonb, 'd', 'في الترقيد يبقى الغصن متّصلًا بالنّبات الأمّ ويُطمر جزء منه حتّى يكوّن جذورًا، ثمّ يُفصل. في العُقلة يُفصل الجزء أوّلًا ثمّ يُغرس، وفي التطعيم يُجمع بين نباتين مختلفين.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1f17cdcd-ce30-54e8-b937-041e308b84d8', '634232e9-8b06-5b3e-a417-0e8d27211dd9', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐ (القمّة): التّكاثر الخضريّ عند النّبات', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('dc216fa7-d29e-50fe-8a05-a3af40233ec0', '1f17cdcd-ce30-54e8-b937-041e308b84d8', 'أيّ عبارة تصنّف طريقتي تكاثر تصنيفًا صحيحًا (طبيعيّ / اصطناعيّ)؟', '[{"id":"a","text":"تكاثر النّخيل بالفسائل اصطناعيّ، وإكثار العنب بالعُقلة طبيعيّ"},{"id":"b","text":"كلاهما اصطناعيّ لأنّ الإنسان يتدخّل فيهما دائمًا"},{"id":"c","text":"تكاثر النّخيل بالفسائل طبيعيّ، وإكثار العنب بالعُقلة اصطناعيّ"},{"id":"d","text":"كلاهما طبيعيّ لأنّ الإنسان لا يتدخّل في أيّ تكاثر خضريّ"}]'::jsonb, 'c', 'الفسائل عضو تكاثر خضريّ طبيعيّ ينمو من قاعدة النّخلة دون تدخّل الإنسان (وإن فصلها الفلّاح لاحقًا)، أمّا العُقلة فتقنية اصطناعيّة ينجزها الإنسان بفصل غصن وغرسه. فالتّصنيف الصّحيح: النّخيل طبيعيّ والعُقلة اصطناعيّة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1816efba-4963-591c-9462-a117dc6cac82', '1f17cdcd-ce30-54e8-b937-041e308b84d8', 'ما الفرق الدّقيق بين البصلة والدّرنة كعضوين للتّكاثر الخضريّ؟', '[{"id":"a","text":"البصلة تحت التّربة والدّرنة فوقها تزحف على السّطح"},{"id":"b","text":"البصلة ساق قصيرة محاطة بأوراق سميكة مدّخِرة (البصل)، والدّرنة انتفاخ في ساق تحت أرضيّة يخزّن غذاءً وعليه عيون (البطاطا)"},{"id":"c","text":"البصلة عضو تكاثر جنسيّ والدّرنة عضو تكاثر خضريّ"},{"id":"d","text":"لا فرق بينهما، فكلاهما اسم لنفس العضو"}]'::jsonb, 'b', 'البصلة ساق قصيرة جدًّا محاطة بأوراق سميكة مدّخِرة للغذاء (البصل، الثّوم)، بينما الدّرنة انتفاخ في ساق تحت أرضيّة يخزّن موادّ احتياطيّة وعليه براعم تُسمّى العيون (البطاطا). وكلاهما عضو تكاثر خضريّ طبيعيّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('68cf55d2-c580-59ea-954a-a5d11cebda92', '1f17cdcd-ce30-54e8-b937-041e308b84d8', 'يريد بستانيّ إكثار الياسمين بأبسط طريقة يفصل فيها الجزء عن النّبات الأمّ **أوّلًا** ثمّ يغرسه دون حاجة إلى إبقائه متّصلًا. أيّ تقنية يختار، ولماذا؟', '[{"id":"a","text":"الترقيد، لأنّه يبقي الغصن متّصلًا بالأمّ حتّى يجذّر"},{"id":"b","text":"التطعيم، لأنّه يجمع بين نباتين مختلفين"},{"id":"c","text":"زرع البذور، لأنّه يعطي نسخة مطابقة للأمّ"},{"id":"d","text":"العُقلة، لأنّها تعتمد على فصل غصن أوّلًا ثمّ غرسه ليكوّن جذورًا وينمو نبتة جديدة"}]'::jsonb, 'd', 'العُقلة تفصل الجزء (الغصن) عن الأمّ أوّلًا ثمّ تغرسه، فهي الأنسب لهذا الشّرط. الترقيد يُبقي الغصن متّصلًا حتّى يجذّر ثمّ يفصله، والتطعيم يجمع نباتين، وزرع البذور تكاثر جنسيّ لا يعطي نسخة مطابقة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d6781f64-0718-5f33-a2e9-0ce7cfd82711', '1f17cdcd-ce30-54e8-b937-041e308b84d8', 'لماذا يكون كلّ نبات ناتج عن تكاثر خضريّ نسخةً مطابقة للنّبات الأمّ، مهما اختلفت التّقنية (فسيلة أو عُقلة أو تطعيم)؟', '[{"id":"a","text":"لأنّ التّكاثر الخضريّ لا جنسيّ يتمّ من عضو خضريّ للأمّ دون إخصاب، فينقل صفات الأمّ نفسها إلى النّبتة الجديدة"},{"id":"b","text":"لأنّ التّكاثر الخضريّ يمرّ عبر إخصاب زهرتين متطابقتين"},{"id":"c","text":"لأنّ البذرة النّاتجة تحمل صفات الأمّ فقط"},{"id":"d","text":"لأنّ الضّوء يجبر النّبتة الجديدة على مشابهة الأمّ"}]'::jsonb, 'a', 'التّكاثر الخضريّ لا جنسيّ: ينطلق من عضو خضريّ للأمّ دون زهرة ولا بذرة ولا إخصاب، فتنتقل صفات الأمّ كما هي إلى النّبتة الجديدة، فتكون نسخة مطابقة. أمّا الاختلاف فيظهر في التّكاثر الجنسيّ الذي يمرّ عبر الإخصاب.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('eccaa9b1-7224-5689-9229-bf0acc226c8e', '1f17cdcd-ce30-54e8-b937-041e308b84d8', 'أيّ العبارات التالية عن التطعيم **صحيحة**؟', '[{"id":"a","text":"التطعيم تكاثر جنسيّ يمرّ عبر بذور النّبتين"},{"id":"b","text":"التطعيم تركيب طُعم على حامل متجذّر من نبات آخر، فينمو الطّعم بجذور الحامل ويحتفظ بصفات نوعه"},{"id":"c","text":"في التطعيم يُغرس الطّعم مباشرة في التّربة دون حامل"},{"id":"d","text":"التطعيم يحوّل الحامل والطّعم معًا إلى نوع نباتيّ ثالث جديد"}]'::jsonb, 'b', 'التطعيم تكاثر خضريّ اصطناعيّ: يُركّب طُعم على حامل متجذّر من نبات آخر فيلتحمان، وينمو الطّعم معتمدًا على جذور الحامل محتفظًا بصفات نوعه (فيعطي ثماره الجيّدة). لا بذور فيه، ولا يُنتج نوعًا ثالثًا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3b008d19-5338-5572-8717-205208dcfd3f', '1f17cdcd-ce30-54e8-b937-041e308b84d8', 'أيّ عبارة تصف الفرق بين التّكاثر الخضريّ الطّبيعيّ والاصطناعيّ وصفًا كاملًا ودقيقًا؟', '[{"id":"a","text":"الطّبيعيّ يعطي نباتات مختلفة عن الأمّ، والاصطناعيّ يعطي نسخًا مطابقة"},{"id":"b","text":"الطّبيعيّ تكاثر جنسيّ بالبذور، والاصطناعيّ تكاثر خضريّ"},{"id":"c","text":"كلاهما تكاثر خضريّ لا جنسيّ يعطي نسخًا مطابقة، لكنّ الطّبيعيّ يحدث دون تدخّل الإنسان (جذامير، فسائل...) والاصطناعيّ ينجزه الإنسان بتقنيّات كالعُقلة والترقيد والتطعيم"},{"id":"d","text":"لا فرق بينهما إطلاقًا، فكلاهما يحتاج إلى تدخّل الإنسان"}]'::jsonb, 'c', 'التّكاثر الخضريّ الطّبيعيّ والاصطناعيّ كلاهما لا جنسيّ يعطي نسخًا مطابقة للأمّ؛ الفرق أنّ الطّبيعيّ يحدث دون تدخّل الإنسان (انتشار الجذامير والفسائل...) بينما الاصطناعيّ ينجزه الإنسان بتقنيّات العُقلة والترقيد والتطعيم.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b661058f-3f46-5d94-9ff7-bdef7386045c', '9bb37c09-af7f-561e-ba9f-0deaa48c851b', 'sciences-vie-terre-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('fe155b96-c66a-5f6c-9116-f3c636a38c7c', 'b661058f-3f46-5d94-9ff7-bdef7386045c', 'ما العضو المسؤول عن التكاثر الجنسي عند النبات الزهري؟', '[{"id":"a","text":"الجذر"},{"id":"b","text":"الزهرة"},{"id":"c","text":"الورقة الخضراء"},{"id":"d","text":"الساق"}]'::jsonb, 'b', 'التكاثر الجنسيّ عند النبات الزهري يتمّ في الزهرة، لأنّها تحمل الأعضاء التكاثرية: الأسدية (ذكرية) والمدقّة (أنثوية). الجذر والساق والورقة أعضاء خضرية تُستعمل في التكاثر الخضريّ لا الجنسيّ.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('177f2a3d-0100-51f7-af49-88ff4a2f3a98', 'b661058f-3f46-5d94-9ff7-bdef7386045c', 'أيّ عضوٍ في الزهرة يُعدّ ذكريًّا وينتج حبوب الطلع؟', '[{"id":"a","text":"المدقّة"},{"id":"b","text":"المبيض"},{"id":"c","text":"الأسدية"},{"id":"d","text":"الميسم"}]'::jsonb, 'c', 'الأسدية هي الأعضاء الذكرية؛ يحمل مئبرُها حبوب الطلع (المشيج الذكريّ). أمّا المدقّة (وأجزاؤها الميسم والقلم والمبيض) فهي العضو الأنثويّ الذي يحوي البويضات.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1da9f5db-9a81-5209-bcc2-958904d29777', 'b661058f-3f46-5d94-9ff7-bdef7386045c', 'ماذا نعني بالتأبير؟', '[{"id":"a","text":"انتقال حبوب الطلع من المئبر إلى ميسم المدقّة"},{"id":"b","text":"اندماج المشيج الذكريّ مع البويضة داخل المبيض"},{"id":"c","text":"تحوّل المبيض إلى ثمرة"},{"id":"d","text":"نموّ الرُّشيم داخل البذرة"}]'::jsonb, 'a', 'التأبير هو نقل حبوب الطلع من المئبر إلى الميسم، وهو خطوة سابقة للإخصاب. أمّا اندماج المشيجين داخل المبيض فهو الإخصاب، وتحوّل المبيض إلى ثمرة يأتي لاحقًا، ونموّ الرُّشيم هو الإنتاش.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9026f41e-82cf-5c94-b397-e286f011d665', 'b661058f-3f46-5d94-9ff7-bdef7386045c', 'بعد الإخصاب، إلى أيّ جزءٍ من الزهرة تتحوّل البويضة المخصبة؟', '[{"id":"a","text":"إلى ثمرة"},{"id":"b","text":"إلى بذرة"},{"id":"c","text":"إلى بتلة ملوّنة"},{"id":"d","text":"إلى ميسم"}]'::jsonb, 'b', 'البويضة المخصبة تتحوّل إلى بذرة، بينما يتحوّل المبيض المحيط بها إلى ثمرة. الخلط الشائع هو عكس هذه القاعدة (البذرة من المبيض والثمرة من البويضة)، وهو خطأ.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d58ace6d-cae5-5586-a830-aa1e4187adba', 'b661058f-3f46-5d94-9ff7-bdef7386045c', 'أيٌّ من التالي ليس شرطًا ضروريًّا لإنتاش البذرة؟', '[{"id":"a","text":"الماء"},{"id":"b","text":"الهواء (الأكسجين)"},{"id":"c","text":"الضوء"},{"id":"d","text":"حرارة ملائمة"}]'::jsonb, 'c', 'شروط الإنتاش الثلاثة هي: الماء والهواء والحرارة الملائمة. الضوء ليس شرطًا للإنتاش (تنتش كثير من البذور في الظلام تحت التراب)؛ يصبح الضوء ضروريًّا بعد الإنتاش حين تخرج الوريقات الخضراء.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('9959a780-c054-587c-a688-6f55875b4190', '9bb37c09-af7f-561e-ba9f-0deaa48c851b', 'sciences-vie-terre-8eme', '⭐ تمرين: التكاثر الجنسي عند النبات الزهري', 1, 50, 10, 'practice', 'admin', 1)
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
  ('86ea5a06-0eae-5a7e-a0c1-729e131f338b', '9959a780-c054-587c-a688-6f55875b4190', 'ما اسم الأوراق الملوّنة الزاهية في الزهرة التي تجذب الحشرات؟', '[{"id":"a","text":"السبلات (الكأس)"},{"id":"b","text":"البتلات (التويج)"},{"id":"c","text":"الأسدية"},{"id":"d","text":"المدقّة"}]'::jsonb, 'b', 'البتلات هي الأوراق الملوّنة التي تكوّن التويج وتجذب الحشرات بلونها ورحيقها. أمّا السبلات فخضراء واقية، والأسدية والمدقّة عضوان تكاثريّان لا جاذبان.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('870b81c3-630e-50cf-b1b9-49bb3ead76c8', '9959a780-c054-587c-a688-6f55875b4190', 'أين تُنتَج حبوب الطلع في الزهرة؟', '[{"id":"a","text":"في الميسم"},{"id":"b","text":"في المبيض"},{"id":"c","text":"في المئبر (أعلى السداة)"},{"id":"d","text":"في السبلات"}]'::jsonb, 'c', 'حبوب الطلع تُنتَج وتُحفَظ في المئبر، وهو الكيس الموجود أعلى خيط السداة. الميسم والمبيض جزءان من المدقّة الأنثوية، والسبلات أوراق واقية.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('84369274-206b-5f62-8539-431bc9dec9ac', '9959a780-c054-587c-a688-6f55875b4190', 'ما العضو الأنثوي الموجود في وسط الزهرة؟', '[{"id":"a","text":"الأسدية"},{"id":"b","text":"المدقّة"},{"id":"c","text":"التويج"},{"id":"d","text":"الكأس"}]'::jsonb, 'b', 'المدقّة هي العضو الأنثويّ، وتوجد في وسط الزهرة، وتتكوّن من الميسم والقلم والمبيض. الأسدية عضو ذكريّ، والتويج والكأس ورقتان واقية وجاذبة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d338630e-0afb-5c06-9d65-5db173059e21', '9959a780-c054-587c-a688-6f55875b4190', 'أين توجد البويضات في الزهرة؟', '[{"id":"a","text":"داخل المبيض"},{"id":"b","text":"داخل المئبر"},{"id":"c","text":"على البتلات"},{"id":"d","text":"في الخيط"}]'::jsonb, 'a', 'البويضات (الحاملة للمشيج الأنثويّ) توجد داخل المبيض، وهو الجزء المنتفخ أسفل المدقّة. المئبر يحوي حبوب الطلع الذكرية، لا البويضات.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9db46745-6cb9-5a0d-9abd-fc4066dd19c0', '9959a780-c054-587c-a688-6f55875b4190', 'زارت سلمى بستان لوزٍ في نابل ورأت النحل يطنّ فوق الأزهار. ما دور النحل هنا؟', '[{"id":"a","text":"عاملُ تأبيرٍ ينقل حبوب الطلع بين الأزهار"},{"id":"b","text":"يمتصّ البويضات من المبيض"},{"id":"c","text":"يحوّل الثمرة إلى بذرة"},{"id":"d","text":"يمنع الأزهار من التفتّح"}]'::jsonb, 'a', 'النحل عاملُ تأبير: يعلق الطلع بجسمه وهو يجمع الرحيق فينقله من زهرةٍ إلى أخرى، فيساعد على التأبير. لا علاقة له بامتصاص البويضات ولا بتحويل الثمرة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2fb3c545-31d5-567a-b5b7-baee7d4fe7be', '9959a780-c054-587c-a688-6f55875b4190', 'ما اسم الجزء العلويّ اللزج من المدقّة الذي تلتصق به حبوب الطلع؟', '[{"id":"a","text":"المئبر"},{"id":"b","text":"الخيط"},{"id":"c","text":"الميسم"},{"id":"d","text":"السبلة"}]'::jsonb, 'c', 'الميسم هو أعلى المدقّة، وهو لزجٌ لتلتصق به حبوب الطلع أثناء التأبير. المئبر والخيط جزءان من السداة الذكرية، والسبلة ورقة من الكأس.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8b0f237b-7d43-5a7f-876b-9a685096322c', '9bb37c09-af7f-561e-ba9f-0deaa48c851b', 'sciences-vie-terre-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: التكاثر الجنسي عند النبات الزهري', 3, 120, 30, 'boss', 'admin', 2)
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
  ('ec0949c5-ec4f-5bd2-a58c-076def1c35be', '8b0f237b-7d43-5a7f-876b-9a685096322c', 'أيّ زوجٍ يربط العضو بجنسه ربطًا صحيحًا؟', '[{"id":"a","text":"الأسدية ذكرية والمدقّة أنثوية"},{"id":"b","text":"الأسدية أنثوية والمدقّة ذكرية"},{"id":"c","text":"الأسدية والمدقّة كلاهما ذكريّ"},{"id":"d","text":"الأسدية والمدقّة كلاهما أنثويّ"}]'::jsonb, 'a', 'الأسدية عضو ذكريّ (مئبرها ينتج حبوب الطلع)، والمدقّة عضو أنثويّ (مبيضها يحوي البويضات). عكسُ الجنسين خطأٌ شائع يجب تجنّبه.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('18471247-1365-5c1d-b46e-6812ab797757', '8b0f237b-7d43-5a7f-876b-9a685096322c', 'رتّب أجزاء المدقّة من الأعلى نحو الأسفل ترتيبًا صحيحًا.', '[{"id":"a","text":"المبيض ← القلم ← الميسم"},{"id":"b","text":"الميسم ← المبيض ← القلم"},{"id":"c","text":"القلم ← الميسم ← المبيض"},{"id":"d","text":"الميسم ← القلم ← المبيض"}]'::jsonb, 'd', 'المدقّة من الأعلى نحو الأسفل: الميسم (لالتقاط الطلع) ثمّ القلم (عنق) ثمّ المبيض (المنتفخ، فيه البويضات). لذلك يجب أن ينزل الأنبوب الطلعيّ من الميسم عبر القلم إلى المبيض.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8b231eea-3e9e-5b5c-81d1-c3c10b3b09a5', '8b0f237b-7d43-5a7f-876b-9a685096322c', 'لماذا يُقال إنّ التأبير خطوةٌ سابقةٌ للإخصاب لا مرادفةٌ له؟', '[{"id":"a","text":"لأنّ التأبير نقلٌ لحبوب الطلع إلى الميسم، بينما الإخصاب اندماجٌ للمشيجين داخل المبيض يأتي بعده"},{"id":"b","text":"لأنّ التأبير والإخصاب يحدثان في اللحظة نفسها وبالمعنى نفسه"},{"id":"c","text":"لأنّ التأبير يحدث داخل المبيض والإخصاب على الميسم"},{"id":"d","text":"لأنّ الإخصاب يسبق التأبير دائمًا"}]'::jsonb, 'a', 'التأبير هو وصول حبوب الطلع إلى الميسم (خارج المبيض)، ثمّ ينبت الأنبوب الطلعيّ لينزل إلى بويضةٍ داخل المبيض حيث يحدث الإخصاب (اندماج المشيجين). فالتأبير سابقٌ للإخصاب وشرطٌ له، وليس مرادفًا له.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c8b19a22-1271-5457-a4f7-6bbc7711d586', '8b0f237b-7d43-5a7f-876b-9a685096322c', 'في زهرة رمّانٍ ملقّحة، ما الجزء الذي سيتحوّل إلى ثمرة؟', '[{"id":"a","text":"البويضة"},{"id":"b","text":"الميسم"},{"id":"c","text":"المبيض"},{"id":"d","text":"البتلة"}]'::jsonb, 'c', 'المبيض هو الذي يتحوّل إلى ثمرة تحيط بالبذور. أمّا البويضة (بعد إخصابها) فتتحوّل إلى بذرة، والميسم والبتلة يذبلان ويسقطان بعد الإخصاب.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3e3aecec-cc23-5af3-acef-34455ee6a042', '8b0f237b-7d43-5a7f-876b-9a685096322c', 'وضع أيوب بذور حمّصٍ في وعاءٍ مغمورٍ تمامًا بالماء وتركه في حرارةٍ ملائمة، فلم تنتش البذور. ما التفسير الأرجح؟', '[{"id":"a","text":"غياب الحرارة الملائمة"},{"id":"b","text":"غياب الماء"},{"id":"c","text":"غياب الهواء (الأكسجين) لأنّ الغمر التامّ يحرم البذور منه"},{"id":"d","text":"غياب الضوء الذي هو شرط الإنتاش"}]'::jsonb, 'c', 'الغمر التامّ يوفّر الماء والحرارة لكنّه يحرم البذرة من الهواء (الأكسجين) اللازم لتنفّس الرُّشيم، فلا تنتش. الماء والحرارة متوفّران هنا، والضوء ليس شرطًا للإنتاش أصلًا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5e2f16ed-d474-5c8f-a4db-32c814ed4d6e', '8b0f237b-7d43-5a7f-876b-9a685096322c', 'بعد الإخصاب داخل مبيض زهرةٍ، أيّ سلسلةٍ تصف التحوّلات بشكلٍ صحيح؟', '[{"id":"a","text":"البويضة المخصبة ← ثمرة، والمبيض ← بذرة"},{"id":"b","text":"البويضة المخصبة ← بذرة، والمبيض ← ثمرة"},{"id":"c","text":"الميسم ← بذرة، والقلم ← ثمرة"},{"id":"d","text":"حبّة الطلع ← بذرة، والبتلة ← ثمرة"}]'::jsonb, 'b', 'القاعدة الثابتة: البويضة المخصبة تعطي بذرة، والمبيض المحيط بها يعطي ثمرة. الخيار (a) يعكسها، والخياران الآخران يخلطان أجزاءً لا تتحوّل (الميسم والقلم والبتلة تذبل وتسقط، وحبّة الطلع لا تصير بذرة).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e24ffbee-4222-58e7-981a-15561c53e42f', '9bb37c09-af7f-561e-ba9f-0deaa48c851b', 'sciences-vie-terre-8eme', '⭐⭐ تمرين مراجعة (نمط امتحان): التكاثر الجنسي عند النبات الزهري', 2, 70, 15, 'practice', 'admin', 3)
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
  ('a030bd5b-51e7-55fe-ae39-6c9a49406327', 'e24ffbee-4222-58e7-981a-15561c53e42f', 'ما ترتيب مجموعات أوراق الزهرة من الخارج نحو الداخل؟', '[{"id":"a","text":"الكأس ← التويج ← الأسدية ← المدقّة"},{"id":"b","text":"التويج ← الكأس ← المدقّة ← الأسدية"},{"id":"c","text":"المدقّة ← الأسدية ← التويج ← الكأس"},{"id":"d","text":"الأسدية ← المدقّة ← الكأس ← التويج"}]'::jsonb, 'a', 'من الخارج نحو الداخل: الكأس (سبلات واقية) ثمّ التويج (بتلات ملوّنة) ثمّ الأسدية (ذكرية) ثمّ المدقّة في الوسط (أنثوية). الأعضاء التكاثرية تقع في الداخل محميةً بالكأس والتويج.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0f1b9755-5aeb-50ae-a07a-51b17457f042', 'e24ffbee-4222-58e7-981a-15561c53e42f', 'قالت رانية: «حبوب الطلع تحمل المشيج الأنثويّ». صحّح العبارة.', '[{"id":"a","text":"العبارة صحيحة كما هي"},{"id":"b","text":"حبوب الطلع تحمل المشيج الذكريّ، والبويضة تحمل المشيج الأنثويّ"},{"id":"c","text":"حبوب الطلع تحمل المشيجين معًا"},{"id":"d","text":"حبوب الطلع لا تحمل أيّ مشيج"}]'::jsonb, 'b', 'حبوب الطلع (من الأسدية الذكرية) تحمل المشيج الذكريّ، بينما البويضة (داخل مبيض المدقّة الأنثوية) تحمل المشيج الأنثويّ. عكسُ ذلك خطأ شائع.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('48a5e5d6-e0a6-5756-9524-9003624353ae', 'e24ffbee-4222-58e7-981a-15561c53e42f', 'انتقلت حبّة طلعٍ من زهرةٍ على شجرة برتقالٍ إلى زهرةٍ على شجرة برتقالٍ أخرى مجاورة. ما نوع هذا التأبير؟', '[{"id":"a","text":"تأبير ذاتيّ (مباشر)"},{"id":"b","text":"إخصاب مباشر"},{"id":"c","text":"تأبير خلطيّ (غير مباشر)"},{"id":"d","text":"إنتاش"}]'::jsonb, 'c', 'لأنّ الطلع انتقل بين نبتتين مختلفتين من النوع نفسه، فهو تأبير خلطيّ (غير مباشر). التأبير الذاتيّ يكون داخل الزهرة نفسها أو على النبتة نفسها. وهذا نقلٌ للطلع (تأبير) لا اندماجٌ للمشيجين (إخصاب) ولا نموٌّ لرُشيم (إنتاش).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3b84b82e-00d8-5788-976d-7d3e508f7eac', 'e24ffbee-4222-58e7-981a-15561c53e42f', 'ما المسار الصحيح لحبّة الطلع حتّى تصل إلى البويضة؟', '[{"id":"a","text":"تلتصق بالميسم ← ينبت أنبوب طلعيّ عبر القلم ← يبلغ البويضة في المبيض"},{"id":"b","text":"تدخل المبيض مباشرة ← تصعد إلى الميسم"},{"id":"c","text":"تلتصق بالبتلة ← تنتقل إلى الأسدية"},{"id":"d","text":"تدخل السبلة ← تخرج من الخيط"}]'::jsonb, 'a', 'تلتصق حبّة الطلع بالميسم اللزج، ثمّ تنبت مكوّنةً أنبوبًا طلعيًّا ينزل عبر القلم حتّى يبلغ بويضةً داخل المبيض، فيحدث الإخصاب. لا تدخل حبّة الطلع المبيض مباشرة ولا تمرّ بالبتلة أو السبلة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6676f415-e027-536a-94fa-8f8a791d2aa1', 'e24ffbee-4222-58e7-981a-15561c53e42f', 'جمعت سلمى حبّة لوزٍ ثمّ زرعتها فنبتت شجرة. حبّة اللوز المزروعة هي في الأصل...', '[{"id":"a","text":"مبيضٌ تحوّل إلى ثمرة"},{"id":"b","text":"ميسمٌ تحوّل إلى بذرة"},{"id":"c","text":"حبّة طلعٍ تحوّلت إلى بذرة"},{"id":"d","text":"بويضةٌ مخصبة تحوّلت إلى بذرة"}]'::jsonb, 'd', 'حبّة اللوز التي نزرعها بذرة، والبذرة تنشأ من البويضة بعد إخصابها. المبيض هو الذي يعطي الثمرة (الغلاف حول البذرة)، وحبّة الطلع والميسم لا يتحوّلان إلى بذرة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6602e5ee-da34-5f6d-9a80-9ed950cec77c', 'e24ffbee-4222-58e7-981a-15561c53e42f', 'عند إنتاش بذرة فولٍ، أيّ عضوٍ يخرج أوّلًا وفي أيّ اتّجاه؟', '[{"id":"a","text":"الوريقات الخضراء نحو الأعلى"},{"id":"b","text":"الجذير نحو الأسفل"},{"id":"c","text":"الجذير نحو الأعلى"},{"id":"d","text":"الزهرة نحو الأسفل"}]'::jsonb, 'b', 'أوّل ما يخرج من البذرة عند الإنتاش هو الجذير، ويتّجه نحو الأسفل ليثبّت النبتة ويمتصّ الماء، ثمّ تظهر السويقة والوريقات نحو الأعلى لاحقًا. الزهرة لا تظهر إلّا بعد نموّ النبتة واكتمالها.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('af76941e-c47c-534e-af10-4909c0cdb600', '9bb37c09-af7f-561e-ba9f-0deaa48c851b', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: التكاثر الجنسي عند النبات الزهري', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('0a1acc7f-2349-595d-9047-c21c6a3ca6b9', 'af76941e-c47c-534e-af10-4909c0cdb600', 'كتب تلميذٌ: «التأبير هو اندماج حبّة الطلع مع البويضة داخل المبيض». أين الخطأ؟', '[{"id":"a","text":"لا خطأ، التعريف صحيح"},{"id":"b","text":"هذا تعريف الإخصاب؛ التأبير هو نقل حبوب الطلع إلى الميسم قبل الإخصاب"},{"id":"c","text":"الخطأ أنّ الاندماج يحدث في الميسم لا في المبيض"},{"id":"d","text":"الخطأ أنّ حبّة الطلع أنثوية والبويضة ذكرية"}]'::jsonb, 'b', 'التلميذ خلط بين المفهومين: الوصف المذكور (اندماج المشيجين داخل المبيض) هو الإخصاب، أمّا التأبير فهو مجرّد نقلٍ لحبوب الطلع من المئبر إلى الميسم، ويسبق الإخصاب. الإخصاب فعلًا يحدث داخل المبيض، وحبّة الطلع ذكرية والبويضة أنثوية.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a05fb75d-9e4a-5999-bd34-1c797de2f8e4', 'af76941e-c47c-534e-af10-4909c0cdb600', 'زهرةٌ خنثى تحمل أسديةً ومدقّةً معًا، لكنّ مئابرها تنضج وتُفرغ طلعها قبل أن ينضج ميسمها بأيّام. ما الأثر الأرجح على تأبيرها؟', '[{"id":"a","text":"يستحيل أيّ تأبيرٍ لهذه الزهرة إطلاقًا"},{"id":"b","text":"يصبح التأبير الذاتيّ إجباريًّا لأنّ العضوين في زهرةٍ واحدة"},{"id":"c","text":"يُرجَّح التأبير الخلطيّ لأنّ طلعها يجهز قبل جهوز ميسمها فيصعب التأبير الذاتيّ"},{"id":"d","text":"يتحوّل ميسمها إلى مئبرٍ لتعويض الفارق"}]'::jsonb, 'c', 'اختلافُ توقيت نضج المئبر والميسم يعيق وصول طلع الزهرة إلى ميسمها هي (تأبير ذاتيّ)، فيُرجَّح أن يأتي الطلع من زهرةٍ أخرى نضج ميسمها في الوقت المناسب (تأبير خلطيّ). فوجود العضوين معًا لا يجعل التأبير الذاتيّ إجباريًّا، والميسم لا يتحوّل إلى مئبر.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('77298bc6-4489-56d5-a152-00c3aaa56b52', 'af76941e-c47c-534e-af10-4909c0cdb600', 'لاحظ فلّاحٌ في باجة أنّ حقل قمحٍ عزله عن بقيّة الحقول أنتج حبوبًا رغم غياب الحشرات تمامًا. ما التفسير الأنسب؟', '[{"id":"a","text":"القمح تأبّر بالريح التي حملت حبوب طلعه الخفيفة"},{"id":"b","text":"القمح لا يحتاج تأبيرًا لأنّه يتكاثر خضريًّا فقط"},{"id":"c","text":"الحبوب تكوّنت دون أيّ إخصاب"},{"id":"d","text":"الماء وحده هو الذي أبّر القمح داخل السنبلة"}]'::jsonb, 'a', 'القمح من النباتات التي تُؤبَّر بالريح: طلعه خفيف تحمله الرياح إلى مياسم الأزهار، فلا يحتاج إلى الحشرات. تكوّنُ الحبوب (البذور) يعني أنّ إخصابًا حدث، والماء ليس عامل التأبير هنا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('aa2e3f48-dee2-5d87-812e-8c3b533df27d', 'af76941e-c47c-534e-af10-4909c0cdb600', 'بذورٌ ذات زغبٍ خفيفٍ كالمظلّة (كبذور الهندباء) تنتشر عادةً بأيّ وسيلة، وما فائدة ذلك؟', '[{"id":"a","text":"بالماء، لتغرق قرب الأمّ"},{"id":"b","text":"بالانفجار الذاتيّ، لتسقط كلّها تحت الأمّ"},{"id":"c","text":"بالحيوانات التي تأكلها، لتبقى ملتصقة بالأمّ"},{"id":"d","text":"بالريح، لتبتعد عن النبتة الأمّ فتتجنّب التزاحم وتغزو أماكن جديدة"}]'::jsonb, 'd', 'الزغب الخفيف كالمظلّة تكيّفٌ للانتشار بالريح: تحمل الرياح البذرة بعيدًا عن النبتة الأمّ فتتجنّب التزاحم على الماء والضوء، وتستعمر أماكن جديدة. باقي الخيارات تناقض هدف الانتشار (الابتعاد) أو لا تناسب بنية البذرة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('57054bad-0452-59b3-8e09-7cfe2d90b70e', 'af76941e-c47c-534e-af10-4909c0cdb600', 'أعدّت رانية أربعة أوعية ببذور حمّص: (1) شاهدٌ بكلّ الشروط، (2) بلا ماءٍ، (3) في ثلّاجةٍ باردة، (4) مغمورٌ تمامًا في الماء. أيّ الأوعية وحده ستنتش بذوره؟', '[{"id":"a","text":"الوعاء (1) الشاهد فقط"},{"id":"b","text":"الوعاءان (1) و(4)"},{"id":"c","text":"الوعاءان (2) و(3)"},{"id":"d","text":"كلّها تنتش"}]'::jsonb, 'a', 'الإنتاش يحتاج الماء والهواء والحرارة الملائمة معًا. الشاهد (1) تتوفّر فيه الشروط فينتش. (2) حُرم الماء، (3) حُرم الحرارة الملائمة (بردٌ شديد)، (4) حُرم الهواء بالغمر التامّ — فلا ينتش أيٌّ منها. لذلك ينتش الشاهد وحده.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a1abc7c5-0da3-5c68-8baf-ba432b5455fc', 'af76941e-c47c-534e-af10-4909c0cdb600', 'لماذا لا يُعدّ الضوء شرطًا لإنتاش أغلب البذور، رغم أنّ النبتة الخضراء تحتاجه لاحقًا؟', '[{"id":"a","text":"لأنّ النبتة الخضراء لا تحتاج الضوء إطلاقًا"},{"id":"b","text":"لأنّ البذرة تنتش غالبًا تحت التراب في الظلام معتمدةً على مدّخرها الغذائيّ، ولا تحتاج الضوء إلّا بعد خروج وريقاتها الخضراء"},{"id":"c","text":"لأنّ الضوء يمنع الجذير من الخروج"},{"id":"d","text":"لأنّ الإنتاش يحتاج الضوء لكنّه يحدث ليلًا فقط"}]'::jsonb, 'b', 'أثناء الإنتاش يتغذّى الرُّشيم من المدّخر الغذائيّ المخزّن في البذرة، ويحدث ذلك غالبًا في الظلام تحت التراب، فلا يلزم الضوء. يصبح الضوء ضروريًّا بعد الإنتاش حين تخرج الوريقات الخضراء لتصنع غذاءها. فشروط الإنتاش هي الماء والهواء والحرارة الملائمة فقط.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a338554a-cd0a-5ec5-a2f5-5eed2ced2141', '9bb37c09-af7f-561e-ba9f-0deaa48c851b', 'sciences-vie-terre-8eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): التكاثر الجنسي عند النبات الزهري', 3, 120, 30, 'boss', 'admin', 5)
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
  ('e92d1c2c-ef08-59cb-8754-e8424175a7f2', 'a338554a-cd0a-5ec5-a2f5-5eed2ced2141', 'أيّ عبارةٍ تصف دور الكأس والتويج بدقّة؟', '[{"id":"a","text":"هما العضوان التكاثريّان المنتجان للطلع والبويضات"},{"id":"b","text":"السبلات تحمي البرعم والبتلات تجذب الحشرات، وليسا عضوَي تكاثر"},{"id":"c","text":"الكأس يحمل حبوب الطلع والتويج يحمل البويضات"},{"id":"d","text":"كلاهما يتحوّل إلى ثمرةٍ بعد الإخصاب"}]'::jsonb, 'b', 'الكأس (سبلات) يحمي البرعم، والتويج (بتلات ملوّنة) يجذب الحشرات؛ وكلاهما ورقتان واقية وجاذبة لا عضوا تكاثر. الأعضاء التكاثرية هي الأسدية والمدقّة، والمبيض وحده (لا الكأس والتويج) يعطي الثمرة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b58b7f29-e0f4-5549-9597-02051a4214c8', 'a338554a-cd0a-5ec5-a2f5-5eed2ced2141', 'ما العلاقة الصحيحة بين المئبر والميسم أثناء التأبير؟', '[{"id":"a","text":"ينتقل الرحيق من الميسم إلى المئبر"},{"id":"b","text":"تنتقل البويضات من الميسم إلى المئبر"},{"id":"c","text":"تنتقل حبوب الطلع من المئبر (ذكريّ) إلى الميسم (أنثويّ)"},{"id":"d","text":"يندمج المئبر بالميسم ليكوّنا بذرة"}]'::jsonb, 'c', 'التأبير هو انتقال حبوب الطلع من المئبر (جزء ذكريّ من السداة) إلى الميسم (جزء أنثويّ أعلى المدقّة). البويضات لا تنتقل، والمئبر والميسم لا يندمجان لتكوين بذرة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b77f4784-3cbc-5b91-8508-e512017a111c', 'a338554a-cd0a-5ec5-a2f5-5eed2ced2141', 'قارن بين التكاثر الخضريّ (الفصل السابق) والتكاثر الجنسيّ عند النبات. ما الفرق الجوهريّ؟', '[{"id":"a","text":"الجنسيّ ينطلق من ساقٍ زاحفةٍ والخضريّ من بذرة"},{"id":"b","text":"الخضريّ يحتاج زهرةً والجنسيّ لا يحتاجها"},{"id":"c","text":"كلاهما يحتاج إخصابًا داخل المبيض"},{"id":"d","text":"الجنسيّ يحتاج زهرةً والتقاء مشيجين ذكريّ وأنثويّ، أمّا الخضريّ فينطلق من عضوٍ خضريّ دون زهرةٍ ولا إخصاب"}]'::jsonb, 'd', 'التكاثر الجنسيّ يحتاج زهرةً والتقاء مشيجٍ ذكريّ (طلع) بمشيجٍ أنثويّ (بويضة) في إخصاب، فينتج بذرةً وثمرة. أمّا الخضريّ فينتج نبتةً جديدة من عضوٍ خضريّ (ساق، جذر، ورقة) دون زهرةٍ ولا إخصابٍ ولا بذرة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2fda47d6-28af-5cea-ab16-a1114a672bed', 'a338554a-cd0a-5ec5-a2f5-5eed2ced2141', 'في زهرةٍ أُزيلت كلّ أسديتها قبل نضجها ثمّ عُزلت عن أيّ مصدر طلعٍ خارجيّ، ماذا يُتوقّع؟', '[{"id":"a","text":"لن يحدث تأبيرٌ ولا إخصاب، فلن تتكوّن بذورٌ ولا ثمرة"},{"id":"b","text":"ستتكوّن الثمرة والبذور طبيعيًّا دون طلع"},{"id":"c","text":"سيتحوّل الميسم مباشرةً إلى بذرة"},{"id":"d","text":"سيتضاعف عدد البويضات لتعويض غياب الطلع"}]'::jsonb, 'a', 'بإزالة الأسدية وعزل الزهرة عن أيّ طلعٍ خارجيّ ينعدم مصدر حبوب الطلع، فلا يحدث تأبيرٌ ولا إخصاب، ومن ثمّ لا تتكوّن بذورٌ (من البويضات) ولا ثمرة (من المبيض). الميسم لا يتحوّل إلى بذرة، وعدد البويضات لا يتضاعف تلقائيًّا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7e409bcd-0d6c-5c8f-ba8a-3c99f7a4e37f', 'a338554a-cd0a-5ec5-a2f5-5eed2ced2141', 'لماذا يوصف الأنبوب الطلعيّ بأنّه «جسرٌ» بين التأبير والإخصاب؟', '[{"id":"a","text":"لأنّه ينمو من حبّة الطلع على الميسم عبر القلم حتّى يبلغ البويضة في المبيض، فيتيح اندماج المشيجين"},{"id":"b","text":"لأنّه ينقل البويضة من المبيض إلى الميسم"},{"id":"c","text":"لأنّه يحوّل الميسم إلى ثمرة"},{"id":"d","text":"لأنّه يمنع حبّة الطلع من الوصول إلى المبيض"}]'::jsonb, 'a', 'بعد وصول الطلع إلى الميسم (نهاية التأبير)، ينبت أنبوبٌ طلعيّ ينزل عبر القلم إلى بويضةٍ في المبيض، فيوصل المشيج الذكريّ إلى الأنثويّ ليحدث الإخصاب. فهو بذلك «جسر» يربط خطوة التأبير بخطوة الإخصاب. لا ينقل البويضة ولا يمنع الوصول.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('78f3ff70-e62c-5f5a-b5f4-3099cd15e33b', 'a338554a-cd0a-5ec5-a2f5-5eed2ced2141', 'بعد نضج ثمرة طماطم، وجدنا بداخلها بذورًا. ما الأصل الصحيح لكلٍّ من الثمرة والبذور؟', '[{"id":"a","text":"الثمرة من البتلات والبذور من الميسم"},{"id":"b","text":"الثمرة من المبيض والبذور من البويضات المخصبة داخله"},{"id":"c","text":"الثمرة من البويضات والبذور من المبيض"},{"id":"d","text":"الثمرة والبذور كلاهما من حبوب الطلع"}]'::jsonb, 'b', 'الثمرة (لبّ الطماطم) هي المبيض المتضخّم، والبذور بداخلها نشأت من البويضات بعد إخصابها. الخيار (c) يعكس القاعدة، والبتلات والميسم يذبلان ولا يعطيان ثمرةً أو بذورًا، وحبوب الطلع لا تصير ثمرةً ولا بذرة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('9c18ee77-7ff8-5b44-b92d-0410f157dbb3', '9bb37c09-af7f-561e-ba9f-0deaa48c851b', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐ (القمّة): التكاثر الجنسي عند النبات الزهري', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('7154b752-12b7-5575-81e5-21c60f68fe2e', '9c18ee77-7ff8-5b44-b92d-0410f157dbb3', 'رتّب مراحل التكاثر الجنسيّ ترتيبًا زمنيًّا صحيحًا من التفتّح إلى النبتة الجديدة.', '[{"id":"a","text":"تأبير ← إخصاب ← تكوّن البذرة والثمرة ← انتشار البذرة ← إنتاش"},{"id":"b","text":"إخصاب ← تأبير ← إنتاش ← تكوّن الثمرة ← انتشار"},{"id":"c","text":"إنتاش ← تأبير ← إخصاب ← تكوّن الثمرة ← انتشار"},{"id":"d","text":"تأبير ← تكوّن الثمرة ← إخصاب ← انتشار ← إنتاش"}]'::jsonb, 'a', 'التسلسل الصحيح: يُنقل الطلع إلى الميسم (تأبير)، ثمّ يندمج المشيجان في المبيض (إخصاب)، فتتحوّل البويضة إلى بذرة والمبيض إلى ثمرة، ثمّ تنتشر البذرة بعيدًا، وأخيرًا تنتش لتعطي نبتةً جديدة. الإخصاب يلي التأبير دائمًا، وتكوّن البذرة يسبق الإنتاش.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c3ff0f7e-c41e-5031-aab4-cfe685a21d0d', '9c18ee77-7ff8-5b44-b92d-0410f157dbb3', 'طلى تلميذٌ ميسم زهرةٍ بمادّةٍ لاصقةٍ تمنع أيّ حبّة طلعٍ من الالتصاق به، مع بقاء بقيّة أجزاء الزهرة سليمة. ما النتيجة المتوقّعة؟', '[{"id":"a","text":"ستتكوّن الثمرة لكن دون بذورٍ بداخلها"},{"id":"b","text":"سيحدث الإخصاب مباشرةً داخل المبيض دون حاجةٍ للميسم"},{"id":"c","text":"لن يتمّ التأبير، فلن ينبت أنبوبٌ طلعيّ ولن يحدث إخصابٌ ولا بذور"},{"id":"d","text":"سيتحوّل الميسم الملطّخ إلى بذرة"}]'::jsonb, 'c', 'الميسم هو بوّابة استقبال الطلع؛ إذا مُنع التصاق الطلع به انقطع التأبير في بدايته، فلا ينبت أنبوبٌ طلعيّ ولا يصل مشيجٌ ذكريّ إلى البويضة، فلا إخصاب ولا بذور ولا ثمرة. الإخصاب لا يحدث دون وصول الطلع عبر الميسم.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b7ab9c4d-d0ba-5ff2-a9df-94b1d0abe0f9', '9c18ee77-7ff8-5b44-b92d-0410f157dbb3', 'علّل: يزرع بعض الفلّاحين خلايا نحلٍ قرب بساتين اللوز والتفّاح رغم أنّهم لا يريدون العسل أساسًا.', '[{"id":"a","text":"لأنّ النحل يمنع انتشار البذور بعيدًا"},{"id":"b","text":"لأنّ النحل يمتصّ الماء الزائد من التربة"},{"id":"c","text":"لأنّ النحل يغذّي البويضات مباشرةً داخل المبيض"},{"id":"d","text":"لأنّ النحل عاملُ تأبيرٍ ينقل الطلع بين الأزهار فيرفع نسبة الإخصاب وكمّية الثمار"}]'::jsonb, 'd', 'النحل عاملُ تأبيرٍ فعّال: ينقل حبوب الطلع من زهرةٍ إلى أخرى فيزيد فرص الإخصاب، وبالتالي عدد الثمار والبذور. لذلك يستعمله الفلّاحون لتحسين المحصول، لا لغرض العسل وحده. لا علاقة له بامتصاص الماء ولا بتغذية البويضات.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a0a85109-299f-5175-902a-6aebcb449c05', '9c18ee77-7ff8-5b44-b92d-0410f157dbb3', 'بذورٌ محاطةٌ بخطاطيف صغيرة تعلق بفرو الثعالب المارّة قرب واحةٍ في توزر. ما وسيلة انتشارها، ولماذا هذا التكيّف مفيد؟', '[{"id":"a","text":"بالريح، لتبقى قرب الأمّ"},{"id":"b","text":"بالحيوانات، فتُحمل بعيدًا عالقةً بالفرو فتستعمر مناطق جديدة وتتجنّب التزاحم"},{"id":"c","text":"بالماء، لأنّها ثقيلةٌ تغرق فورًا"},{"id":"d","text":"بالانفجار الذاتيّ، دون حاجةٍ للحيوان"}]'::jsonb, 'b', 'الخطاطيف تكيّفٌ للانتشار بالحيوانات: تعلق البذور بالفرو فتنتقل مسافاتٍ بعيدة قبل أن تسقط، فتغزو أماكن جديدة وتتجنّب التزاحم قرب النبتة الأمّ. بنية الخطاطيف لا تناسب الريح ولا الماء ولا الانفجار الذاتيّ.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('dd93b15b-3954-5de9-80fb-158b72460430', '9c18ee77-7ff8-5b44-b92d-0410f157dbb3', 'قال تلميذٌ: «ما دامت البذرة تحوي مدّخرًا غذائيًّا، فهي تنتش حتّى بلا ماءٍ ولا هواء». ناقش العبارة.', '[{"id":"a","text":"صحيحة، فالمدّخر يغني عن كلّ الشروط الخارجية"},{"id":"b","text":"خاطئة: المدّخر يغذّي الرُّشيم فقط، لكنّ الإنتاش يظلّ يحتاج الماء لترطيب البذرة والهواء لتنفّس الرُّشيم وحرارةً ملائمة"},{"id":"c","text":"خاطئة لأنّ البذرة لا تحوي أيّ مدّخرٍ غذائيّ"},{"id":"d","text":"صحيحة بشرط توفّر الضوء فقط"}]'::jsonb, 'b', 'المدّخر الغذائيّ يمدّ الرُّشيم بالغذاء في بداية نموّه، لكنّه لا يغني عن الشروط الخارجية: يلزم الماء لترطيب البذرة وتنشيط الرُّشيم، والهواء (الأكسجين) لتنفّسه، وحرارةٌ ملائمة. لذا العبارة خاطئة. والضوء ليس شرطًا للإنتاش أصلًا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d9714829-cd7a-58c0-a11b-b6fe71a420b9', '9c18ee77-7ff8-5b44-b92d-0410f157dbb3', 'أُخصبت 20 بويضةً داخل مبيض زهرة قرعٍ واحدة ونمت الثمرة. كم بذرةً يُتوقّع أن تحويها الثمرة، وممّ نشأت الثمرة نفسها؟', '[{"id":"a","text":"20 بذرة، والثمرة نشأت من المبيض"},{"id":"b","text":"بذرةٌ واحدة، والثمرة نشأت من البتلات"},{"id":"c","text":"20 ثمرةً صغيرة، وبذرةٌ واحدة من المبيض"},{"id":"d","text":"لا بذور، والثمرة نشأت من الميسم"}]'::jsonb, 'a', 'كلّ بويضةٍ مخصبة تعطي بذرةً واحدة، فـ 20 بويضةً مخصبة تعطي 20 بذرة داخل الثمرة الواحدة. والثمرة نفسها نشأت من المبيض الذي كان يحوي هذه البويضات. البتلات والميسم لا يعطيان ثمرة، والمبيض الواحد يعطي ثمرةً واحدة لا عشرين.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('5b6d2a1c-c67d-58f4-8356-1d6e081e58c2', '1ae8f90e-eb00-506e-8477-4606e82d77c5', 'sciences-vie-terre-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('92da7082-38af-58ee-a6c9-d76178959f72', '5b6d2a1c-c67d-58f4-8356-1d6e081e58c2', 'ما المقصود بتحسين الإنتاج النباتي «كمًّا وكيفًا»؟', '[{"id":"a","text":"زيادة كمّية المحصول ورفع جودته معًا"},{"id":"b","text":"زيادة كمّية المحصول فقط دون الاهتمام بجودته"},{"id":"c","text":"الاكتفاء بتلوين الثّمار دون زيادة عددها"},{"id":"d","text":"تقليل المحصول للحفاظ على التّربة"}]'::jsonb, 'a', 'تحسين الإنتاج كمًّا يعني الحصول على محصول أوفر، وتحسينه كيفًا يعني رفع جودته (ثمار أكبر وأجود، مقاومة للأمراض والجفاف)؛ والهدف هو الجمع بين الاثنين معًا.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('89796a87-2328-5e79-af9c-cd83c1cdbe54', '5b6d2a1c-c67d-58f4-8356-1d6e081e58c2', 'ما هو التهجين عند النّبات؟', '[{"id":"a","text":"اختيار أفضل النّباتات والتخلّص من الرّديئة"},{"id":"b","text":"تلقيح اصطناعيّ بين صنفين مختلفين للحصول على هجين يجمع صفاتهما المرغوبة"},{"id":"c","text":"غرس قطعة من ساق النّبات لتُنبت جذورًا"},{"id":"d","text":"قطع أوراق النّبات لتسريع نموّه"}]'::jsonb, 'b', 'التهجين تلقيح اصطناعيّ بين صنفين مختلفين من نفس النّوع، يعطي بذورًا تنبت هجينًا يجمع صفات مرغوبة من الأبوين معًا. أمّا اختيار الأفضل فهو الانتخاب، وغرس قطعة الساق فهو العُقَل.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9ec99fdd-60e0-532f-8faf-5d04e9030b12', '5b6d2a1c-c67d-58f4-8356-1d6e081e58c2', 'أيّ العبارات التالية تصف الانتخاب الاصطناعيّ؟', '[{"id":"a","text":"الطّبيعة هي الّتي تُبقي النّباتات الأقدر على العيش"},{"id":"b","text":"الإنسان يزوّج صنفين مختلفين للحصول على صنف جديد"},{"id":"c","text":"الإنسان يحتفظ ببذور أو نباتات أفضل الأصناف للإكثار منها"},{"id":"d","text":"النّبات يصنع مادّته العضويّة بنفسه"}]'::jsonb, 'c', 'في الانتخاب الاصطناعيّ يقوم الإنسان باختيار أفضل النّباتات أو بذورها للإكثار منها جيلًا بعد جيل. الخيار الأوّل هو الانتخاب الطبيعيّ، والثّاني هو التهجين.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('71b7cb72-d1db-5400-86c7-7ffb76d56ded', '5b6d2a1c-c67d-58f4-8356-1d6e081e58c2', 'ما الّذي يميّز الإكثار الخضريّ (اللّاجنسيّ) مثل العُقَل والفسائل؟', '[{"id":"a","text":"يُنتج نباتات مطابقة تمامًا للنّبتة الأصليّة"},{"id":"b","text":"يُنتج نباتات مختلفة كثيرًا عن النّبتة الأصليّة"},{"id":"c","text":"يمرّ حتمًا بالتلقيح والإخصاب"},{"id":"d","text":"لا يمكن استعماله إلّا مع القمح"}]'::jsonb, 'a', 'الإكثار الخضريّ لا يمرّ بالإخصاب، فيُنتج نُسخًا مطابقة تمامًا للنّبتة الأصليّة ويحافظ على صفاتها المرغوبة. أمّا التنوّع فيأتي من التكاثر الجنسيّ (البذور).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('610d4354-936f-5677-bc76-e4487ca6d660', '5b6d2a1c-c67d-58f4-8356-1d6e081e58c2', 'في التطعيم، ما دور «الأصل» (حامل الطُّعم)؟', '[{"id":"a","text":"يعطي الثّمار المرغوبة"},{"id":"b","text":"يعطي الجذور القويّة المقاومة للشّجرة النّاتجة"},{"id":"c","text":"ينتج بذورًا هجينة جديدة"},{"id":"d","text":"يمنع الشّجرة من الإثمار نهائيًّا"}]'::jsonb, 'b', 'في التطعيم يُثبَّت الطُّعم (من صنف مرغوب يعطي الثّمار) على الأصل الّذي يمدّ الشّجرة بجذوره القويّة المقاومة؛ فالأصل مسؤول عن الجذور، والطُّعم عن الجزء الهوائيّ والثّمار.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('769d57ea-fc3e-56b7-890e-5a034366d2b3', '1ae8f90e-eb00-506e-8477-4606e82d77c5', 'sciences-vie-terre-8eme', '⭐ تمرين: تحسين الإنتاج النباتي', 1, 50, 10, 'practice', 'admin', 1)
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
  ('e612c77f-cdf8-5f9a-ae85-f89ae1f83439', '769d57ea-fc3e-56b7-890e-5a034366d2b3', 'أراد فلّاح في سهول باجة الحصول على صنف قمح يجمع بين غزارة الإنتاج ومقاومة الجفاف عبر تزويج صنفين مختلفين. ما اسم هذه التّقنية؟', '[{"id":"a","text":"التطعيم"},{"id":"b","text":"التهجين"},{"id":"c","text":"الترقيد"},{"id":"d","text":"زراعة الأنسجة"}]'::jsonb, 'b', 'تزويج صنفين مختلفين للحصول على هجين يجمع صفاتهما المرغوبة هو التهجين. أمّا التطعيم والترقيد وزراعة الأنسجة فهي تقنيات إكثار خضريّ لا تزويج بين صنفين.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d5239925-72a5-59b7-a6ad-4829444edbbc', '769d57ea-fc3e-56b7-890e-5a034366d2b3', 'يحتفظ فلّاح كلّ موسم ببذور أكبر حبّات الطّماطم وأجودها ليزرعها في الموسم المقبل، ويهمل الرّديئة. ما اسم هذا التّصرّف؟', '[{"id":"a","text":"الانتخاب الاصطناعيّ"},{"id":"b","text":"التهجين"},{"id":"c","text":"التطعيم"},{"id":"d","text":"الإخصاب"}]'::jsonb, 'a', 'اختيار الإنسان لأفضل النّباتات أو بذورها للإكثار منها وإهمال الرّديئة هو الانتخاب الاصطناعيّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e572a945-cfa2-5ba7-a965-f628931db574', '769d57ea-fc3e-56b7-890e-5a034366d2b3', 'يغرس فلّاح قطعة من ساق شجرة الدّالية (العنب) في التّربة فتُنبت جذورًا وتعطي نبتة جديدة. ما اسم هذه التّقنية؟', '[{"id":"a","text":"التهجين"},{"id":"b","text":"الانتخاب الطبيعيّ"},{"id":"c","text":"العُقَل"},{"id":"d","text":"التلقيح"}]'::jsonb, 'c', 'غرس قطعة من ساق النّبات لتُنبت جذورًا وتعطي نبتة جديدة هو الإكثار بالعُقَل، وهو نوع من الإكثار الخضريّ.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f8039c2a-7b33-5307-8071-574912e5d151', '769d57ea-fc3e-56b7-890e-5a034366d2b3', 'لإكثار صنف دقلة النّور في واحات توزر، يفصل الفلّاح النّبتات الصّغيرة النّابتة حول قاعدة النّخلة الأمّ ويزرعها. ماذا نسمّي هذه النّبتات الصّغيرة؟', '[{"id":"a","text":"البذور"},{"id":"b","text":"الطّعوم"},{"id":"c","text":"الأزهار"},{"id":"d","text":"الفسائل"}]'::jsonb, 'd', 'النّبتات الصّغيرة النّابتة حول قاعدة النّخلة تُسمّى الفسائل، وفصلها وزراعتها نوع من الإكثار الخضريّ يحافظ على صفات الصّنف الأمّ.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('17ea2ebf-0c6d-55ed-b16d-c06d18d669d2', '769d57ea-fc3e-56b7-890e-5a034366d2b3', 'في التطعيم، يُثبَّت الطُّعم المأخوذ من صنف حمضيّات مرغوب على أصل ذي جذور قويّة. ما الّذي يمنحه الطُّعم للشّجرة النّاتجة؟', '[{"id":"a","text":"الثّمار المرغوبة"},{"id":"b","text":"الجذور القويّة المقاومة"},{"id":"c","text":"الماء والأملاح المعدنية من التّربة"},{"id":"d","text":"المقاومة لأمراض التّربة فقط"}]'::jsonb, 'a', 'الطُّعم مأخوذ من الصّنف المرغوب، فهو يمنح الشّجرة جزأها الهوائيّ وثمارها الجيّدة؛ أمّا الجذور القويّة المقاومة فيمنحها الأصل (حامل الطُّعم).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c695ce74-0819-5c52-8607-f78297a9ffd0', '769d57ea-fc3e-56b7-890e-5a034366d2b3', 'أيّ من هذه الأهداف يمثّل تحسين الإنتاج «كيفًا» (جودةً) لا «كمًّا»؟', '[{"id":"a","text":"الحصول على عدد أكبر من الحبوب في نفس المساحة"},{"id":"b","text":"الحصول على أشجار زيتون مقاومة لأمراض التّربة وذات ثمار أجود"},{"id":"c","text":"زراعة مساحة أوسع بنفس الصّنف"},{"id":"d","text":"مضاعفة عدد النّباتات المنتَجة بزراعة الأنسجة"}]'::jsonb, 'b', 'تحسين الكيف يخصّ جودة الثّمار ومقاومتها للأمراض، كما في أشجار الزّيتون المقاومة ذات الثّمار الأجود. أمّا زيادة عدد الحبوب أو النّباتات أو المساحة فتخصّ الكمّ.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bc1d884b-979a-5f87-8903-a48674c6c13f', '1ae8f90e-eb00-506e-8477-4606e82d77c5', 'sciences-vie-terre-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: تحسين الإنتاج النباتي', 3, 120, 30, 'boss', 'admin', 2)
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
  ('75965531-1917-53ee-b110-60c3e1ac784d', 'bc1d884b-979a-5f87-8903-a48674c6c13f', 'ما الفرق الجوهريّ بين التهجين والانتخاب؟', '[{"id":"a","text":"التهجين يُنشئ صنفًا هجينًا جديدًا بتزويج صنفين، والانتخاب يكتفي باختيار الأفضل ممّا هو موجود"},{"id":"b","text":"التهجين يختار الأفضل، والانتخاب يزوّج صنفين مختلفين"},{"id":"c","text":"كلاهما لا يعتمد على التكاثر إطلاقًا"},{"id":"d","text":"لا فرق بينهما، فهما تسميتان لعمليّة واحدة"}]'::jsonb, 'a', 'التهجين يُنشئ تركيبات جديدة من الصّفات بتزويج صنفين مختلفين (تكاثر جنسيّ)، بينما الانتخاب لا يُنشئ صفات جديدة بل يصطفي أفضل النّباتات من بين الموجود. الخلط بينهما خطأ شائع.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('103aff4b-3f21-5b23-ac14-f379ca906356', 'bc1d884b-979a-5f87-8903-a48674c6c13f', 'أراد فلّاح إكثار شجرة زيتون ممتازة مع المحافظة التّامّة على صفاتها المرغوبة دون أيّ تغيير. أيّ طريق يختار؟', '[{"id":"a","text":"زراعة بذورها، لأنّ البذور تعطي نُسخًا مطابقة لها"},{"id":"b","text":"إكثارها خضريًّا (بالعُقَل أو التطعيم)، لأنّه يعطي نُسخًا مطابقة للأصل"},{"id":"c","text":"تهجينها مع صنف آخر للحصول على نفس الصّفات"},{"id":"d","text":"الانتخاب الطبيعيّ وتركها للطّبيعة"}]'::jsonb, 'b', 'الإكثار الخضريّ (العُقَل، التطعيم) لا يمرّ بالإخصاب فيعطي نُسخًا مطابقة تمامًا للأصل، وهو الطّريق الّذي يحافظ على الصّفات المرغوبة. أمّا البذور والتهجين فيُدخلان تنوّعًا لا يضمن مطابقة الأصل.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3c15df48-e966-58f1-a226-b31fbc54d604', 'bc1d884b-979a-5f87-8903-a48674c6c13f', 'زرع باحث بذور هجين نتج عن تزويج صنفَي طماطم مختلفين. لماذا يُتوقّع أن تكون النّباتات النّاتجة عن هذه البذور غير متطابقة تمامًا فيما بينها؟', '[{"id":"a","text":"لأنّ التّربة تجعل كلّ نبتة مطابقة للأخرى"},{"id":"b","text":"لأنّ البذور تنتج عن إكثار خضريّ يعطي نُسخًا مطابقة"},{"id":"c","text":"لأنّ البذور تنتج عن تكاثر جنسيّ (تلقيح وإخصاب) يُدخل تنوّعًا بين النّباتات"},{"id":"d","text":"لأنّ الطّماطم لا تتكاثر بالبذور إطلاقًا"}]'::jsonb, 'c', 'البذور ناتجة عن تكاثر جنسيّ (تلقيح + إخصاب)، وهو يُدخل تنوّعًا بين النّباتات النّاتجة فلا تكون كلّها متطابقة. هذا التنوّع هو ما يستغلّه التهجين لخلق تركيبات جديدة من الصّفات.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bfa4cb86-b1da-570c-a353-f1620ff416d0', 'bc1d884b-979a-5f87-8903-a48674c6c13f', 'يُطعَّم صنف برتقال مرغوب بجهة نابل على أصل من نبتة أخرى مقاومة لأمراض التّربة. ما الفائدة الدّقيقة من هذا التطعيم؟', '[{"id":"a","text":"الحصول على تنوّع وراثيّ جديد في ثمار البرتقال"},{"id":"b","text":"منع الشّجرة من إعطاء أيّ ثمار للمحافظة على الأصل"},{"id":"c","text":"تحويل شجرة البرتقال إلى نبات لا يحتاج إلى جذور"},{"id":"d","text":"الجمع بين ثمار الصّنف المرغوب (الطُّعم) وجذور مقاومة للأمراض (الأصل) في شجرة واحدة"}]'::jsonb, 'd', 'التطعيم يجمع مزايا نبتتين: الطُّعم يعطي ثمار الصّنف المرغوب، والأصل يمدّ الشّجرة بجذوره القويّة المقاومة للأمراض. فيحصل الفلّاح على الميزتين معًا في شجرة واحدة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('08611089-5e42-58db-828b-0ac1749de058', 'bc1d884b-979a-5f87-8903-a48674c6c13f', 'قال تلميذ: «إكثار دقلة النّور بالفسائل يخلق أصنافًا جديدة متنوّعة من التّمر.» أين الخطأ في قوله؟', '[{"id":"a","text":"الفسائل إكثار خضريّ يعطي نُسخًا مطابقة للأمّ، فلا يخلق تنوّعًا؛ التنوّع الجديد يأتي من التكاثر الجنسيّ"},{"id":"b","text":"لا خطأ، فالإكثار بالفسائل يخلق فعلًا تنوّعًا جديدًا"},{"id":"c","text":"الخطأ أنّ دقلة النّور لا تتكاثر بالفسائل إطلاقًا"},{"id":"d","text":"الخطأ أنّ الفسائل نوع من التهجين لا من الإكثار الخضريّ"}]'::jsonb, 'a', 'الإكثار بالفسائل إكثار خضريّ لا يمرّ بالإخصاب، فيعطي نُسخًا مطابقة تمامًا للنّخلة الأمّ ويحافظ على صفاتها دون أن يُحدث تنوّعًا. التنوّع الجديد لا يأتي إلّا من التكاثر الجنسيّ (البذور، التهجين).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('60619f59-c5c6-5848-bd2d-89e866ec641a', 'bc1d884b-979a-5f87-8903-a48674c6c13f', 'يريد مركز بحث فلاحيّ إنتاج آلاف النّسخ المطابقة من نبتة موز ممتازة خالية من الأمراض في أقصر وقت. أيّ تقنية هي الأنسب؟', '[{"id":"a","text":"الانتخاب الطبيعيّ على مدى أجيال"},{"id":"b","text":"التهجين مع صنف موز آخر"},{"id":"c","text":"زراعة الأنسجة (الإكثار المخبريّ)"},{"id":"d","text":"زراعة البذور النّاتجة عن الإخصاب"}]'::jsonb, 'c', 'زراعة الأنسجة إكثار خضريّ مخبريّ يعطي عددًا كبيرًا من النّسخ المطابقة من نبتة واحدة في وقت قصير، فهي الأنسب هنا. أمّا التهجين والبذور فيُدخلان تنوّعًا، والانتخاب الطبيعيّ بطيء ولا يضمن المطابقة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8117b5dd-8e46-5f51-bf30-21683a2558d8', '1ae8f90e-eb00-506e-8477-4606e82d77c5', 'sciences-vie-terre-8eme', '⭐⭐ تمرين مراجعة (نمط امتحان): تحسين الإنتاج النباتي', 2, 70, 15, 'practice', 'admin', 3)
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
  ('940b5dd3-d786-592c-bf16-072a6218e184', '8117b5dd-8e46-5f51-bf30-21683a2558d8', 'أيّ التّقنيات التالية يعتمد على التكاثر الجنسيّ (تلقيح وإخصاب)؟', '[{"id":"a","text":"التهجين"},{"id":"b","text":"العُقَل"},{"id":"c","text":"التطعيم"},{"id":"d","text":"الفسائل"}]'::jsonb, 'a', 'التهجين تلقيح اصطناعيّ بين صنفين ينتهي بالإخصاب، فهو تكاثر جنسيّ. أمّا العُقَل والتطعيم والفسائل فتقنيات إكثار خضريّ (لاجنسيّ) لا تمرّ بالإخصاب.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('758aa002-b787-58be-8bee-455c84d15398', '8117b5dd-8e46-5f51-bf30-21683a2558d8', 'في الانتخاب الطبيعيّ، من الّذي يُبقي النّباتات الأقدر على العيش في وسطها؟', '[{"id":"a","text":"الفلّاح باختياره اليدويّ"},{"id":"b","text":"الطّبيعة نفسها دون تدخّل الإنسان"},{"id":"c","text":"المختبر بزراعة الأنسجة"},{"id":"d","text":"التطعيم على أصل مقاوم"}]'::jsonb, 'b', 'الانتخاب الطبيعيّ تقوم به الطّبيعة، إذ تبقى النّباتات الأقدر على العيش في وسطها وتزول الأضعف، دون تدخّل الإنسان. أمّا اختيار الفلّاح فهو الانتخاب الاصطناعيّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ba377ddf-8d79-5219-adab-4d265a90c592', '8117b5dd-8e46-5f51-bf30-21683a2558d8', 'لماذا يلجأ الفلّاح إلى الإكثار الخضريّ لصنف تفّاح ممتاز بدل زراعة بذوره؟', '[{"id":"a","text":"لأنّ بذور التفّاح لا تنبت أبدًا"},{"id":"b","text":"لأنّ الإكثار الخضريّ يُدخل تنوّعًا كبيرًا في الصّفات"},{"id":"c","text":"لأنّ الإكثار الخضريّ يحافظ على صفات الصّنف الممتاز في نُسخ مطابقة"},{"id":"d","text":"لأنّ الإكثار الخضريّ يحوّل التفّاح إلى صنف جديد كلّيًّا"}]'::jsonb, 'c', 'الإكثار الخضريّ يعطي نُسخًا مطابقة للأصل فيحافظ على صفات الصّنف الممتاز؛ أمّا البذور فتُدخل تنوّعًا قد يُفقد بعض الصّفات المرغوبة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e9986fd2-0e59-5a24-b073-5124e08084a2', '8117b5dd-8e46-5f51-bf30-21683a2558d8', 'في التطعيم، أيّ توزيع للأدوار بين الطُّعم والأصل هو الصّحيح؟', '[{"id":"a","text":"الطُّعم يعطي الجذور، والأصل يعطي الثّمار"},{"id":"b","text":"الطُّعم يمنع الإثمار، والأصل ينتج البذور"},{"id":"c","text":"الطُّعم والأصل كلاهما يعطي الجذور فقط"},{"id":"d","text":"الطُّعم يعطي الثّمار المرغوبة، والأصل يعطي الجذور القويّة المقاومة"}]'::jsonb, 'd', 'الطُّعم مأخوذ من الصّنف المرغوب فيعطي الجزء الهوائيّ والثّمار الجيّدة، والأصل (حامل الطُّعم) يمدّ الشّجرة بجذوره القويّة المقاومة. الخلط بين الدّورين خطأ شائع.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e5414e10-be3a-50c6-a30e-0fd619e71265', '8117b5dd-8e46-5f51-bf30-21683a2558d8', 'أراد مركز بحث الحصول على صنف فلفل جديد يجمع بين لون جذّاب من صنف ومقاومة لمرض من صنف آخر. ما التّقنية المناسبة؟', '[{"id":"a","text":"التهجين بين الصّنفين"},{"id":"b","text":"الإكثار بالعُقَل لأحد الصّنفين"},{"id":"c","text":"زراعة الأنسجة لأحد الصّنفين"},{"id":"d","text":"الترقيد لأحد الصّنفين"}]'::jsonb, 'a', 'الجمع بين صفتين مرغوبتين موجودتين في صنفين مختلفين يتطلّب تزويجهما، أي التهجين، لأنّه وحده يُنشئ تركيبة جديدة. أمّا العُقَل وزراعة الأنسجة والترقيد فتعطي نُسخًا مطابقة لصنف واحد ولا تجمع صفات صنفين.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ba33abe4-50c0-5341-bf32-8c64649fc8ad', '8117b5dd-8e46-5f51-bf30-21683a2558d8', 'أيّ العبارات التالية عن تحسين الإنتاج النباتي **خاطئة**؟', '[{"id":"a","text":"التهجين يعتمد على التكاثر الجنسيّ ويُنشئ تركيبات جديدة"},{"id":"b","text":"الإكثار الخضريّ يعطي نُسخًا مطابقة للأصل"},{"id":"c","text":"الانتخاب الاصطناعيّ يخلق صفات جديدة لم تكن موجودة في أيّ نبات"},{"id":"d","text":"التطعيم يجمع بين ثمار الطُّعم وجذور الأصل"}]'::jsonb, 'c', 'العبارة الخاطئة هي أنّ الانتخاب يخلق صفات جديدة: الانتخاب لا يُنشئ صفات، بل يكتفي باختيار الأفضل من بين النّباتات الموجودة. أمّا العبارات الأخرى فصحيحة تمامًا.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('45e01563-eb45-5b27-a493-99b644705361', '1ae8f90e-eb00-506e-8477-4606e82d77c5', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: تحسين الإنتاج النباتي', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('2abf4a5a-cd0d-56d3-9c84-b73203e78d64', '45e01563-eb45-5b27-a493-99b644705361', 'حصل باحث على شجرة مشمش هجينة ممتازة تجمع بين حلاوة صنف ومقاومة صنف آخر للبرد. يريد الآن أن يملأ بستانه بأشجار مطابقة لها تمامًا. ما التّسلسل المنطقيّ الصّحيح؟', '[{"id":"a","text":"حصل على الشّجرة بالتهجين (تكاثر جنسيّ)، ثمّ يكثرها بالإكثار الخضريّ (تطعيم/عُقَل) للمحافظة على صفاتها"},{"id":"b","text":"حصل على الشّجرة بالإكثار الخضريّ، ثمّ يكثرها بزراعة بذورها للمحافظة على صفاتها"},{"id":"c","text":"حصل على الشّجرة بالانتخاب الطبيعيّ، ثمّ يكثرها بالتهجين المتكرّر"},{"id":"d","text":"يكثرها بزراعة البذور مباشرة لأنّها تعطي نُسخًا مطابقة للهجين"}]'::jsonb, 'a', 'خلق تركيبة جديدة (حلاوة + مقاومة برد) يتطلّب التهجين (تكاثر جنسيّ). لكن للمحافظة على هذه التّركيبة المطابقة في كلّ البستان يجب الإكثار الخضريّ (تطعيم أو عُقَل)، لأنّ زراعة البذور تُدخل تنوّعًا يُفقد التّركيبة الممتازة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('51dcefb8-a7f9-5127-ae83-f916c2be53ce', '45e01563-eb45-5b27-a493-99b644705361', 'قال تلميذ: «التطعيم والتهجين تقنيتان متطابقتان لأنّ كلتيهما تجمع صفات نبتتين.» أين الخطأ الدّقيق في هذا القول؟', '[{"id":"a","text":"لا خطأ، فالتطعيم والتهجين عمليّة واحدة"},{"id":"b","text":"التهجين تكاثر جنسيّ يمزج صفات صنفين في هجين وراثيّ جديد، أمّا التطعيم فإلصاق خضريّ لجزأين يبقى كلّ منهما بصفاته دون مزج وراثيّ"},{"id":"c","text":"الخطأ أنّ التهجين إكثار خضريّ والتطعيم تكاثر جنسيّ"},{"id":"d","text":"الخطأ أنّ التطعيم يُنتج بذورًا هجينة جديدة دائمًا"}]'::jsonb, 'b', 'التهجين تكاثر جنسيّ يُخصب فيلد هجينًا يمزج صفات الصّنفين في نبتة جديدة واحدة. أمّا التطعيم فإلصاق خضريّ: يبقى الطُّعم بصفاته (الثّمار) والأصل بصفاته (الجذور) دون امتزاج وراثيّ. فالجمع في التطعيم ميكانيكيّ لا وراثيّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('afa5c35d-d790-5faa-9108-8e1050a79df0', '45e01563-eb45-5b27-a493-99b644705361', 'قارن فلّاح بين قطعتين من نفس صنف الطّماطم: القطعة الأولى أُكثرت بزراعة الأنسجة، والثّانية بزراعة البذور. أيّ نتيجة يُتوقّع أن يلاحظها؟', '[{"id":"a","text":"نباتات القطعة الأولى شديدة التنوّع، ونباتات الثّانية متطابقة تمامًا"},{"id":"b","text":"القطعتان تعطيان نباتات متطابقة تمامًا بلا أيّ فرق"},{"id":"c","text":"نباتات القطعة الأولى متطابقة تقريبًا (نُسخ)، ونباتات الثّانية أكثر تنوّعًا بينها"},{"id":"d","text":"القطعتان تعطيان نباتات شديدة التنوّع بلا أيّ فرق"}]'::jsonb, 'c', 'زراعة الأنسجة إكثار خضريّ يعطي نُسخًا متطابقة تقريبًا، أمّا زراعة البذور فتكاثر جنسيّ يُدخل تنوّعًا بين النّباتات. لذلك يُتوقّع تطابق نباتات القطعة الأولى وتنوّع نباتات الثّانية.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0ddc0640-d1d5-5a09-877f-0c9dc6d3a023', '45e01563-eb45-5b27-a493-99b644705361', 'في ضيعة زيتون بمنطقة صفاقس، اختار الفلّاح عبر سنوات أفضل الأشجار إنتاجًا واحتفظ بها، ثمّ طعّم منها طعومًا على أصول فتيّة مقاومة. كيف تُحسّن هاتان الخطوتان الإنتاج كمًّا وكيفًا معًا؟', '[{"id":"a","text":"الخطوتان تعتمدان على التكاثر الجنسيّ فقط دون أيّ إكثار خضريّ"},{"id":"b","text":"الانتخاب والتطعيم كلاهما يخفّض الإنتاج للمحافظة على التّربة"},{"id":"c","text":"الانتخاب خلق صفات جديدة، والتطعيم ألغى حاجة الأشجار إلى الجذور"},{"id":"d","text":"الانتخاب اصطفى الأشجار الأجود إنتاجًا (كيفًا)، والتطعيم نشر صفاتها الجيّدة على أصول مقاومة تكثر الأشجار المنتجة (كمًّا)"}]'::jsonb, 'd', 'الانتخاب اصطفى الأشجار ذات الإنتاج الأجود (تحسين الكيف)، والتطعيم نشر صفاتها الجيّدة بإكثار خضريّ على أصول مقاومة، فزاد عدد الأشجار المنتجة (تحسين الكمّ). فتكاملت الخطوتان لرفع الإنتاج كمًّا وكيفًا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('58a5a4e8-55d7-5508-963b-21a9194151e5', '45e01563-eb45-5b27-a493-99b644705361', 'أراد مركز بحث صنعَ صنف قمح جديد أكثر مقاومة للصّدأ (مرض فطريّ) وأغزر إنتاجًا، ثمّ تعميمه على فلّاحي الجهة بصفات ثابتة. ما التّرتيب الصّحيح للتّقنيات؟', '[{"id":"a","text":"تطعيم القمح على أصل مقاوم ثمّ توزيعه"},{"id":"b","text":"تهجين صنفين (مقاوم + غزير) للحصول على هجين، ثمّ انتخاب أفضل النّباتات وإكثار بذورها المنتخبة لتعميم الصّنف الثّابت"},{"id":"c","text":"إكثار خضريّ للقمح بالعُقَل ثمّ تهجينه لاحقًا"},{"id":"d","text":"الاكتفاء بالانتخاب الطبيعيّ حتّى تظهر المقاومة وحدها"}]'::jsonb, 'b', 'لخلق تركيبة جديدة (مقاومة + غزارة) يلزم التهجين أوّلًا؛ ثمّ الانتخاب لاصطفاء أفضل النّباتات الهجينة؛ ثمّ إكثار بذورها المنتخبة لتثبيت الصّنف وتعميمه. القمح يُكثَر عادةً بالبذور لا بالعُقَل أو التطعيم، والانتخاب الطبيعيّ وحده لا يضمن الجمع بين الصّفتين.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a7b0d4f7-4357-525b-b0cb-0f83fdb4ab10', '45e01563-eb45-5b27-a493-99b644705361', 'لاحظ باحث أنّ صنفًا من العنب أُكثر بالعُقَل لعشرات السّنين بقي محافظًا على نفس صفات الصّنف الأصليّ دون ظهور تنوّع يُذكر. ما التّفسير العلميّ الأدقّ؟', '[{"id":"a","text":"لأنّ العُقَل إكثار خضريّ لا يمرّ بالإخصاب، فينتج نُسخًا مطابقة للأصل دون إدخال تنوّع"},{"id":"b","text":"لأنّ العُقَل تكاثر جنسيّ يمنع أيّ تنوّع بين النّباتات"},{"id":"c","text":"لأنّ العنب لا يمكن أن يتنوّع بأيّ طريقة كانت"},{"id":"d","text":"لأنّ التّربة هي الّتي توحّد صفات كلّ نباتات العنب"}]'::jsonb, 'a', 'العُقَل إكثار خضريّ (لاجنسيّ) لا يمرّ بالتلقيح والإخصاب، فيعطي نُسخًا مطابقة تمامًا للأصل جيلًا بعد جيل دون إدخال تنوّع. التنوّع الجديد لا يظهر إلّا عبر التكاثر الجنسيّ (البذور، التهجين).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('9ba61fcc-3cdb-5744-ad92-27d56bb27fa9', '1ae8f90e-eb00-506e-8477-4606e82d77c5', 'sciences-vie-terre-8eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): تحسين الإنتاج النباتي', 3, 120, 30, 'boss', 'admin', 5)
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
  ('18859b3d-ef88-541b-aef9-ec5244986ea1', '9ba61fcc-3cdb-5744-ad92-27d56bb27fa9', 'أيّ زوج من التّقنيات ينتمي كلاهما إلى الإكثار الخضريّ (اللّاجنسيّ)؟', '[{"id":"a","text":"الترقيد وزراعة الأنسجة"},{"id":"b","text":"التهجين والانتخاب"},{"id":"c","text":"التهجين وزراعة البذور"},{"id":"d","text":"الإخصاب والتلقيح"}]'::jsonb, 'a', 'الترقيد وزراعة الأنسجة كلاهما إكثار خضريّ لا يمرّ بالإخصاب. أمّا التهجين وزراعة البذور والإخصاب والتلقيح فتتعلّق بالتكاثر الجنسيّ، والانتخاب اختيار لا إكثار.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d2fe60de-f50e-5002-865e-0233b1221974', '9ba61fcc-3cdb-5744-ad92-27d56bb27fa9', 'يريد فلّاح تكثير صنف موز خالٍ من الأمراض بأقصى سرعة وبأكبر عدد من النّسخ المطابقة. ما التّقنية المثلى؟', '[{"id":"a","text":"التهجين مع صنف موز آخر"},{"id":"b","text":"زراعة الأنسجة (الإكثار المخبريّ)"},{"id":"c","text":"زراعة البذور الهجينة"},{"id":"d","text":"الانتخاب الطبيعيّ عبر الأجيال"}]'::jsonb, 'b', 'زراعة الأنسجة تعطي عددًا كبيرًا من النّسخ المطابقة في وقت قصير مع المحافظة على خلوّ الصّنف من الأمراض. التهجين والبذور يُدخلان تنوّعًا، والانتخاب الطبيعيّ بطيء ولا يضمن المطابقة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('96c24100-5b37-518c-bd99-1ed1db3f29be', '9ba61fcc-3cdb-5744-ad92-27d56bb27fa9', 'لماذا يُعدّ التطعيم مفيدًا خاصّةً في أشجار الحمضيّات المهدَّدة بأمراض التّربة؟', '[{"id":"a","text":"لأنّه يُدخل تنوّعًا وراثيًّا يقضي على المرض نهائيًّا"},{"id":"b","text":"لأنّه يحوّل الحمضيّات إلى نبات لا يحتاج إلى تربة"},{"id":"c","text":"لأنّه يجمع ثمار الصّنف المرغوب مع جذور أصل مقاوم لأمراض التّربة"},{"id":"d","text":"لأنّه يمنع الشّجرة من الإثمار حتّى تُشفى"}]'::jsonb, 'c', 'التطعيم يثبّت طُعم الصّنف المرغوب (الثّمار) على أصل ذي جذور مقاومة لأمراض التّربة، فيجمع بين جودة الثّمار وصمود الجذور — وهذا مفيد بالضّبط حين تكون التّربة موبوءة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e7f76acf-7e6c-5915-a849-fe7991ff6824', '9ba61fcc-3cdb-5744-ad92-27d56bb27fa9', 'أراد باحث الجمع بين مقاومة صنف قمح للجفاف وغزارة صنف آخر، ثمّ الحصول على نبتة هجينة تجمع الصّفتين. أيّ تسلسل صحيح؟', '[{"id":"a","text":"زراعة الأنسجة لصنف واحد فينتج هجين يجمع صفتَي الصّنفين"},{"id":"b","text":"غرس عُقلة من صنف على الآخر فيتكوّن هجين وراثيّ يجمع الصّفتين"},{"id":"c","text":"فصل فسيلة من صنف وزراعتها بجانب الآخر فتُنتج هجينًا"},{"id":"d","text":"نقل غبار الطّلع من صنف إلى مدقّة الصّنف الآخر (تلقيح)، فيحدث إخصاب وتتكوّن بذور تنبت هجينًا يجمع الصّفتين"}]'::jsonb, 'd', 'التهجين يتمّ بنقل غبار الطّلع من صنف إلى مدقّة صنف آخر (تلقيح خلطيّ)، فيحدث إخصاب وتتكوّن بذور تنبت هجينًا يجمع صفات الأبوين. أمّا العُقَل والفسائل وزراعة الأنسجة فإكثار خضريّ لصنف واحد لا يجمع صفات صنفين.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4725e5e4-34d9-54a7-be0b-dd7c6a3b2873', '9ba61fcc-3cdb-5744-ad92-27d56bb27fa9', 'قال تلميذ: «الانتخاب الاصطناعيّ يخترع في النّبات صفات جديدة لم تكن موجودة من قبل.» ما الخطأ في هذه الجملة؟', '[{"id":"a","text":"الانتخاب لا يخترع صفات جديدة، بل يختار النّباتات ذات الصّفات المرغوبة الموجودة أصلًا ويكثرها"},{"id":"b","text":"لا خطأ، فالانتخاب فعلًا يخترع صفات جديدة"},{"id":"c","text":"الخطأ أنّ الانتخاب الاصطناعيّ تقوم به الطّبيعة لا الإنسان"},{"id":"d","text":"الخطأ أنّ الانتخاب نوع من الإكثار الخضريّ"}]'::jsonb, 'a', 'الانتخاب لا يُنشئ صفات جديدة، بل يصطفي النّباتات ذات الصّفات المرغوبة الموجودة فعلًا ويكثرها. خلق تركيبات جديدة من الصّفات يكون بالتهجين لا بالانتخاب.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3aaa8a8b-77f4-5ac1-b506-3701d54cf384', '9ba61fcc-3cdb-5744-ad92-27d56bb27fa9', 'بستان تفّاح مُكوّن من أشجار مطعَّمة كلّها من نفس الصّنف الممتاز. لماذا تتشابه ثمار كلّ الأشجار تشابهًا كبيرًا في الصّنف والصّفات؟', '[{"id":"a","text":"لأنّ كلّ شجرة نتجت عن بذرة مختلفة"},{"id":"b","text":"لأنّ التطعيم تكاثر جنسيّ يُدخل تنوّعًا كبيرًا بين الأشجار"},{"id":"c","text":"لأنّ الطّعوم أُخذت من صنف واحد وأُكثرت خضريًّا، فأعطت أشجارًا تحمل نفس صفات الثّمار المطابقة"},{"id":"d","text":"لأنّ التّربة وحدها هي الّتي تحدّد صنف الثّمار"}]'::jsonb, 'c', 'التطعيم إكثار خضريّ؛ ولمّا أُخذت كلّ الطّعوم من صنف ممتاز واحد، حملت كلّ الأشجار نفس صفات الثّمار المطابقة للأصل. فالتّشابه ناتج عن الإكثار الخضريّ من مصدر واحد، لا عن التّربة أو البذور.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bd471611-27d2-5c0b-bf0b-89e05ffac5a8', '1ae8f90e-eb00-506e-8477-4606e82d77c5', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐ (القمّة): تحسين الإنتاج النباتي', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('dbaf125d-4729-5a97-bd2c-765dc0b836f7', 'bd471611-27d2-5c0b-bf0b-89e05ffac5a8', 'قال تلميذ: «كلّ من التهجين والانتخاب والإكثار الخضريّ يخلق تنوّعًا جديدًا في النّبات.» أيّ تصحيح دقيق لهذه الجملة؟', '[{"id":"a","text":"التهجين وحده (تكاثر جنسيّ) يُنشئ تركيبات جديدة؛ الانتخاب يصطفي من الموجود؛ والإكثار الخضريّ يعطي نُسخًا مطابقة دون تنوّع"},{"id":"b","text":"الإكثار الخضريّ وحده يخلق التنوّع، أمّا التهجين والانتخاب فيعطيان نُسخًا مطابقة"},{"id":"c","text":"الثّلاثة تعطي نُسخًا مطابقة تمامًا دون أيّ تنوّع"},{"id":"d","text":"الجملة صحيحة، فالثّلاثة تخلق تنوّعًا جديدًا"}]'::jsonb, 'a', 'التهجين تكاثر جنسيّ يُنشئ تركيبات جديدة من الصّفات؛ الانتخاب لا يخلق شيئًا بل يصطفي أفضل الموجود؛ والإكثار الخضريّ يعطي نُسخًا مطابقة للأصل دون تنوّع. فالتنوّع الجديد مصدره التكاثر الجنسيّ وحده.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d1bbd852-a313-56ab-ac7b-55e19ae13075', 'bd471611-27d2-5c0b-bf0b-89e05ffac5a8', 'شجرة برتقال مطعَّمة: طُعمها من صنف حلو المذاق، وأصلها من نبتة برّية مقاومة لملوحة التّربة. أنبتت هذه الشّجرة بذورًا، فزرعها فلّاح متوقّعًا أشجارًا مطابقة للأمّ الحلوة المقاومة. لماذا يُرجّح أن يخيب توقّعه؟', '[{"id":"a","text":"لأنّ البذور نتجت عن إكثار خضريّ يعطي نُسخًا مطابقة تمامًا"},{"id":"b","text":"لأنّ البذور نتجت عن تكاثر جنسيّ يُدخل تنوّعًا، فلا تعطي أشجارًا مطابقة للطُّعم؛ المطابقة تُضمن بالإكثار الخضريّ (تطعيم) لا بالبذور"},{"id":"c","text":"لأنّ الأصل البرّي يمنع تكوّن أيّ بذور"},{"id":"d","text":"لأنّ الطُّعم لا علاقة له بثمار الشّجرة إطلاقًا"}]'::jsonb, 'b', 'بذور الشّجرة نتجت عن تكاثر جنسيّ يُدخل تنوّعًا، فالأشجار النّابتة منها لا تكون بالضّرورة مطابقة للصّنف الحلو المرغوب. لضمان المطابقة يجب الإكثار الخضريّ (تطعيم طعوم من الصّنف نفسه)، لا زراعة البذور.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a9419c58-e6b9-5d21-8f16-883b169d5763', 'bd471611-27d2-5c0b-bf0b-89e05ffac5a8', 'لتعميم صنف تمر ممتاز في واحات قبلي، أيّ استراتيجية تجمع بين سرعة الإكثار والمحافظة التّامّة على صفات الصّنف، مع تفسير سليم؟', '[{"id":"a","text":"تهجين الصّنف مع صنف آخر لتثبيت صفاته"},{"id":"b","text":"زراعة بذور التّمر، لأنّها تعطي نُسخًا مطابقة للنّخلة الأمّ"},{"id":"c","text":"الإكثار بالفسائل أو بزراعة الأنسجة، لأنّهما إكثار خضريّ يعطي نُسخًا مطابقة للنّخلة الأمّ ويحافظ على صفات الصّنف"},{"id":"d","text":"الاعتماد على الانتخاب الطبيعيّ فقط دون تدخّل الإنسان"}]'::jsonb, 'c', 'الفسائل وزراعة الأنسجة إكثار خضريّ يعطي نُسخًا مطابقة للنّخلة الأمّ فيحافظ تمامًا على صفات الصّنف الممتاز ويكثره. أمّا البذور والتهجين فيُدخلان تنوّعًا، والانتخاب الطبيعيّ بطيء ولا يضمن ثبات الصّفات.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e9d4d2bf-ec7d-50aa-b19d-85f10674628a', 'bd471611-27d2-5c0b-bf0b-89e05ffac5a8', 'مركز بحث فلاحيّ نفّذ برنامجًا متكاملًا على الطّماطم: (1) هجّن صنفين، (2) انتخب من الهجائن أفضل نبتة، (3) أكثرها بزراعة الأنسجة. ما الدّور الدّقيق لكلّ خطوة في تحسين الإنتاج؟', '[{"id":"a","text":"الخطوات الثّلاث كلّها إكثار خضريّ يعطي نُسخًا مطابقة"},{"id":"b","text":"التهجين كثّر النّسخ، والانتخاب أنشأ صفات جديدة، وزراعة الأنسجة زوّجت الصّنفين"},{"id":"c","text":"الخطوات الثّلاث كلّها تعتمد على التكاثر الجنسيّ وتُدخل تنوّعًا"},{"id":"d","text":"التهجين أنشأ تركيبة جديدة من الصّفات، والانتخاب اصطفى أفضلها، وزراعة الأنسجة كثّرت النّبتة المنتخبة في نُسخ مطابقة"}]'::jsonb, 'd', 'لكلّ خطوة دور مختلف: التهجين (تكاثر جنسيّ) أنشأ تركيبة جديدة من الصّفات، والانتخاب اصطفى أفضل نبتة هجينة من الموجود، وزراعة الأنسجة (إكثار خضريّ) كثّرت هذه النّبتة المنتخبة في نُسخ مطابقة بسرعة. فتكاملت الخطوات لتحسين الإنتاج كمًّا وكيفًا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fb5c342b-1b8f-5147-93d3-9cbdaa2c9324', 'bd471611-27d2-5c0b-bf0b-89e05ffac5a8', 'بستانان من نفس صنف الزّيتون الممتاز: البستان الأوّل أُنشئ بتطعيم طعوم من شجرة أمّ واحدة، والثّاني بزراعة بذور تلك الشّجرة نفسها. أيّ توقّع عن تجانس الإنتاج بين البستانين هو الأدقّ، ولماذا؟', '[{"id":"a","text":"البستان المطعَّم أكثر تجانسًا لأنّه إكثار خضريّ يعطي نُسخًا مطابقة، والبستان البذريّ أكثر تباينًا لأنّه ناتج عن تكاثر جنسيّ"},{"id":"b","text":"البستان البذريّ أكثر تجانسًا لأنّ البذور تعطي نُسخًا مطابقة"},{"id":"c","text":"البستانان متطابقان في التّجانس لأنّ الصّنف واحد"},{"id":"d","text":"البستان المطعَّم أكثر تباينًا لأنّ التطعيم يُدخل تنوّعًا وراثيًّا"}]'::jsonb, 'a', 'التطعيم إكثار خضريّ يعطي نُسخًا مطابقة للشّجرة الأمّ، فيكون البستان المطعَّم متجانسًا. أمّا البذور فناتجة عن تكاثر جنسيّ يُدخل تنوّعًا، فيكون البستان البذريّ أكثر تباينًا رغم أنّ مصدره الشّجرة نفسها.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('069a8a32-d858-5088-b7db-74a437bd0bee', 'bd471611-27d2-5c0b-bf0b-89e05ffac5a8', 'أراد باحث صنعَ صنف فراولة جديد يقاوم فطرًا معيّنًا، ثمّ تعميمه على المزارعين بصفات ثابتة موحّدة. أيّ خطّة تُحقّق الهدفين معًا مع تفسير سليم؟', '[{"id":"a","text":"يكثر الصّنف الحسّاس خضريًّا فتظهر فيه المقاومة تلقائيًّا، ثمّ يوزّعه"},{"id":"b","text":"يهجّن صنفًا حسّاسًا مع صنف مقاوم للحصول على هجين مقاوم (خلق التّركيبة)، ثمّ يكثر أفضل نبتة منتخبة خضريًّا (نُسخ مطابقة) لتعميم صفات ثابتة"},{"id":"c","text":"يزرع بذور الصّنف المقاوم مباشرة لأنّها تعطي أصنافًا ثابتة موحّدة"},{"id":"d","text":"يعتمد الانتخاب الطبيعيّ حتّى تظهر المقاومة، ثمّ يهجّن لإلغائها"}]'::jsonb, 'b', 'خلق المقاومة الجديدة يتطلّب التهجين (تكاثر جنسيّ يُنشئ تركيبة جديدة)، ثمّ الانتخاب لاصطفاء أفضل هجين مقاوم، ثمّ الإكثار الخضريّ لتكثيره في نُسخ مطابقة بصفات ثابتة تُعمَّم على المزارعين. الإكثار الخضريّ للصّنف الحسّاس لا يخلق مقاومة، والبذور تُدخل تنوّعًا لا ثباتًا.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6aadf254-16b2-5987-a152-d84537cf1d25', '3f5148df-5a90-5569-8326-597ed54c33e7', 'sciences-vie-terre-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('118d531d-df3b-5816-b247-bb1ffdbd0a75', '6aadf254-16b2-5987-a152-d84537cf1d25', 'ما هو الإخصاب في التكاثر الجنسي عند الحيوانات؟', '[{"id":"a","text":"نموّ البويضة وحدها دون تدخّل الذكر"},{"id":"b","text":"التقاء حيوان منوي بالبويضة واندماجهما في بيضة مخصّبة"},{"id":"c","text":"انقسام جسم الأنثى إلى جزأين متشابهين"},{"id":"d","text":"خروج الصغير من جسم الأمّ"}]'::jsonb, 'b', 'الإخصاب هو التقاء حيوان منوي (من الذكر) بالبويضة (من الأنثى) واندماجهما في خليّة واحدة تُسمّى البيضة المخصّبة، ومنها ينمو الكائن الجديد.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c70afc50-729a-57d8-abe7-7900b408f7c6', '6aadf254-16b2-5987-a152-d84537cf1d25', 'الجمل حيوان يولد صغيره حيًّا بعد نموّه داخل جسم أمّه. إلى أيّ صنف ينتمي؟', '[{"id":"a","text":"حيوان بيوض"},{"id":"b","text":"حيوان ولود"},{"id":"c","text":"حيوان لا يتكاثر"},{"id":"d","text":"حيوان يتكاثر خضريًّا"}]'::jsonb, 'b', 'الجمل من الثدييات: ينمو صغيره داخل جسم الأمّ ثمّ يولد حيًّا، وهذه هي صفة الحيوان الولود. كلّ الثدييات ولودة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('aed79e1d-3efb-548f-9151-ea48d73f46bc', '6aadf254-16b2-5987-a152-d84537cf1d25', 'يطرح ذكر السردين حيواناته المنوية وتطرح الأنثى بويضاتها في ماء البحر فيلتقيان هناك. ما نوع هذا الإخصاب؟', '[{"id":"a","text":"إخصاب داخلي لأنّه يحدث داخل الماء"},{"id":"b","text":"لا يوجد إخصاب في هذه الحالة"},{"id":"c","text":"إخصاب خارجي لأنّه يحدث خارج جسم الأنثى في الماء"},{"id":"d","text":"تكاثر بدون خلايا تكاثرية"}]'::jsonb, 'c', 'عندما تُطرح الخلايا التكاثرية في الماء ويلتقي الحيوان المنوي بالبويضة خارج جسم الأنثى، يكون الإخصاب خارجيًّا. «داخلي/خارجي» يعني داخل جسم الأنثى أو خارجه، لا داخل الماء أو خارجه.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d023be47-b4fc-558d-afc2-4274d0e7d40d', '6aadf254-16b2-5987-a152-d84537cf1d25', 'ما الترتيب الصحيح لمراحل تحوّل الفراشة؟', '[{"id":"a","text":"البيضة ← اليرقة ← الخادرة ← الفراشة البالغة"},{"id":"b","text":"البيضة ← الخادرة ← اليرقة ← الفراشة البالغة"},{"id":"c","text":"اليرقة ← البيضة ← الفراشة البالغة ← الخادرة"},{"id":"d","text":"الفراشة البالغة ← الخادرة ← اليرقة ← البيضة"}]'::jsonb, 'a', 'يسير تحوّل الفراشة في اتّجاه واحد: البيضة، ثمّ اليرقة (دودة تأكل الأوراق)، ثمّ الخادرة (طور ساكن)، ثمّ الفراشة البالغة. الترتيب ثابت لا يُعكس.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('932e8444-f715-5fcf-a2fc-338cb4bccca0', '6aadf254-16b2-5987-a152-d84537cf1d25', 'احتضنت دجاجة عددًا من البيض مدّة كافية لكن بعضه لم يفقس لأنّه لم يكن مخصّبًا. ماذا نستنتج عن دور التفريخ؟', '[{"id":"a","text":"البيضة غير المخصّبة تفقس لكن ببطء أكبر"},{"id":"b","text":"التفريخ يخصّب البيضة بنفسه دون حاجة إلى ذكر"},{"id":"c","text":"كلّ بيضة تفقس حتمًا إذا طال تفريخها"},{"id":"d","text":"التفريخ يوفّر الحرارة فقط ولا يعوّض غياب الإخصاب"}]'::jsonb, 'd', 'التفريخ يوفّر الحرارة اللازمة لنموّ الجنين داخل البيضة المخصّبة فقط. أمّا البيضة غير المخصّبة فلا تحمل جنينًا أصلًا، فلا تفقس مهما طال تفريخها؛ إذن الإخصاب شرط سابق لا غنى عنه.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('dda4e91e-da70-56ad-8819-c91169b35611', '3f5148df-5a90-5569-8326-597ed54c33e7', 'sciences-vie-terre-8eme', '⭐ تمرين: التكاثر عند الحيوانات', 1, 50, 10, 'practice', 'admin', 1)
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
  ('3a352a02-57e9-5bad-908f-5a4ac82d478a', 'dda4e91e-da70-56ad-8819-c91169b35611', 'أيّ خليّة تكاثرية ينتجها الذكر في التكاثر الجنسي عند الحيوانات؟', '[{"id":"a","text":"البويضة"},{"id":"b","text":"الحيوان المنوي"},{"id":"c","text":"البيضة المخصّبة"},{"id":"d","text":"الشرغوف"}]'::jsonb, 'b', 'ينتج الذكر خلايا صغيرة متحرّكة تُسمّى الحيوانات المنوية، بينما تنتج الأنثى البويضة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e3868f80-393c-5812-ae99-8317901b1874', 'dda4e91e-da70-56ad-8819-c91169b35611', 'ماذا نسمّي الخليّة الناتجة عن اندماج الحيوان المنوي بالبويضة؟', '[{"id":"a","text":"اليرقة"},{"id":"b","text":"الخادرة"},{"id":"c","text":"البيضة المخصّبة"},{"id":"d","text":"الغطاء الخيشومي"}]'::jsonb, 'c', 'عند اندماج الحيوان المنوي بالبويضة تتكوّن خليّة واحدة تُسمّى البيضة المخصّبة، ومنها ينمو الكائن الجديد.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7c6eb913-6a7e-5194-83fa-b36eafce94a8', 'dda4e91e-da70-56ad-8819-c91169b35611', 'الأرنب من الثدييات ويلد صغاره أحياءً. إلى أيّ صنف ينتمي؟', '[{"id":"a","text":"حيوان ولود"},{"id":"b","text":"حيوان بيوض"},{"id":"c","text":"حيوان يفقس من بيضة"},{"id":"d","text":"حيوان لا ينمو"}]'::jsonb, 'a', 'الأرنب من الثدييات، ينمو صغيره داخل جسم الأمّ ثمّ يولد حيًّا، فهو حيوان ولود مثل بقية الثدييات.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b8b43bc3-8b57-561e-a15f-cb14ab028e43', 'dda4e91e-da70-56ad-8819-c91169b35611', 'النورس طائر يضع بيضًا يخرج منه الفرخ عند الفقس. إلى أيّ صنف ينتمي؟', '[{"id":"a","text":"حيوان ولود"},{"id":"b","text":"حيوان يتكاثر خضريًّا"},{"id":"c","text":"حيوان يلد ويبيض معًا"},{"id":"d","text":"حيوان بيوض"}]'::jsonb, 'd', 'النورس يضع بيضًا خارج جسمه، وينمو الفرخ داخل البيضة ثمّ يخرج منها عند الفقس؛ فهو حيوان بيوض مثل بقية الطيور.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('349cd98a-e65e-5846-9f86-69d5e438167a', 'dda4e91e-da70-56ad-8819-c91169b35611', 'أين يلتقي الحيوان المنوي بالبويضة في الإخصاب الداخلي؟', '[{"id":"a","text":"في الماء خارج الجسم"},{"id":"b","text":"داخل جسم الأنثى"},{"id":"c","text":"داخل البيضة بعد وضعها"},{"id":"d","text":"في الهواء أثناء الطيران"}]'::jsonb, 'b', 'في الإخصاب الداخلي يلتقي الحيوان المنوي بالبويضة داخل جسم الأنثى بعد تزاوج الذكر والأنثى.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a7ed7228-ddfa-561c-8340-49372d028fe1', 'dda4e91e-da70-56ad-8819-c91169b35611', 'ما اسم الطور الأوّل الذي يخرج من بيضة الضفدع ويعيش في الماء بذيل وخياشيم؟', '[{"id":"a","text":"الخادرة"},{"id":"b","text":"الفرخ"},{"id":"c","text":"الشرغوف"},{"id":"d","text":"اليرقة الأرضية"}]'::jsonb, 'c', 'يخرج من بيضة الضفدع طور يُسمّى الشرغوف، يعيش في الماء وله ذيل وخياشيم، ثمّ يتحوّل تدريجيًّا حتّى يصبح ضفدعًا بالغًا.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('40f9b65e-d3dd-5383-ab67-9a0d792a8201', '3f5148df-5a90-5569-8326-597ed54c33e7', 'sciences-vie-terre-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: التكاثر عند الحيوانات', 3, 120, 30, 'boss', 'admin', 2)
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
  ('71e6f7b2-ff10-5326-863a-d7402e7cf519', '40f9b65e-d3dd-5383-ab67-9a0d792a8201', 'ماذا يلزم من الوالدين لحدوث التكاثر الجنسي عند الحيوانات؟', '[{"id":"a","text":"أنثى وحدها تنتج بويضة تنمو دون إخصاب"},{"id":"b","text":"ذكر ينتج حيوانات منوية وأنثى تنتج بويضة، ثمّ إخصاب"},{"id":"c","text":"ذكران ينتجان حيوانات منوية فقط"},{"id":"d","text":"أيّ فرد واحد مهما كان جنسه"}]'::jsonb, 'b', 'يحتاج التكاثر الجنسي إلى ذكر ينتج حيوانات منوية وأنثى تنتج بويضة، ثمّ إخصاب يجمع بينهما في بيضة مخصّبة. لا تكفي الأنثى وحدها لأنّ البويضة غير المخصّبة لا تنمو.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('265d643c-c84f-595d-b67e-7829da5bf08c', '40f9b65e-d3dd-5383-ab67-9a0d792a8201', 'الضفدع برمائي يطرح خلاياه التكاثرية في الماء فيحدث اللقاء هناك. ما نوع إخصابه؟', '[{"id":"a","text":"إخصاب داخلي"},{"id":"b","text":"إخصاب خارجي"},{"id":"c","text":"لا إخصاب لأنّه بيوض"},{"id":"d","text":"إخصاب داخلي وخارجي معًا"}]'::jsonb, 'b', 'الضفدع يطرح حيواناته المنوية وبويضاته في الماء فيلتقيان خارج جسم الأنثى؛ إذن إخصابه خارجي، وهو ما نجده عند معظم البرمائيات والأسماك.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('19712673-db7d-5a55-912f-a0f5fc0f83fd', '40f9b65e-d3dd-5383-ab67-9a0d792a8201', 'لماذا لا يمكن للسردين أن يتكاثر بإخصاب خارجي فوق اليابسة الجافّة؟', '[{"id":"a","text":"لأنّ الإخصاب الخارجي يحتاج إلى وسط مائي يلتقي فيه الحيوان المنوي بالبويضة"},{"id":"b","text":"لأنّ الإخصاب الخارجي يحدث داخل جسم الأنثى"},{"id":"c","text":"لأنّ السردين حيوان ولود لا يحتاج ماءً"},{"id":"d","text":"لأنّ الأسماك تتكاثر خضريًّا لا جنسيًّا"}]'::jsonb, 'a', 'الإخصاب الخارجي يتطلّب طرح الخلايا التكاثرية في الماء ليلتقي فيه الحيوان المنوي بالبويضة؛ فوق اليابسة الجافّة تجفّ هذه الخلايا ولا تلتقي، لذلك يبقى تكاثر السردين مرتبطًا بالماء.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e6d18789-2a76-53bd-a5c1-4e5d1947976f', '40f9b65e-d3dd-5383-ab67-9a0d792a8201', 'النورس والدجاجة طائران يتكاثران بإخصاب داخلي. لماذا يبقيان مع ذلك حيوانين بيوضين؟', '[{"id":"a","text":"لأنّ كلّ حيوان إخصابه داخلي يكون ولودًا حتمًا"},{"id":"b","text":"لأنّ الإخصاب الداخلي يحدث بعد وضع البيض"},{"id":"c","text":"لأنّ الأنثى تضع البيض المخصّب خارج جسمها فينمو الفرخ داخل البيضة ويخرج بالفقس"},{"id":"d","text":"لأنّ الطيور لا تنتج بويضات إطلاقًا"}]'::jsonb, 'c', 'الإخصاب الداخلي لا يعني الولودة. الطيور تُخصِب داخليًّا ثمّ تضع البيض المخصّب خارج جسمها، فينمو الجنين داخل البيضة ويخرج عند الفقس؛ فهي بيوضة. الولودة (النموّ داخل جسم الأمّ حتّى الولادة الحيّة) خاصّة بالثدييات.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bf1853cc-52a1-5c7c-b927-00bf6c0df684', '40f9b65e-d3dd-5383-ab67-9a0d792a8201', 'قارن بين نموّ صغير الجمل ونموّ الفراشة. ما الفرق الجوهري؟', '[{"id":"a","text":"صغير الجمل يشبه أمّه ويكبر فقط (نموّ مباشر)، بينما تمرّ الفراشة بأطوار مختلفة الشكل (تحوّل)"},{"id":"b","text":"كلاهما يمرّ بتحوّل يغيّر شكله جذريًّا"},{"id":"c","text":"الفراشة تنمو نموًّا مباشرًا والجمل يمرّ بتحوّل"},{"id":"d","text":"لا فرق، فكلّ الحيوانات تنمو بالطريقة نفسها"}]'::jsonb, 'a', 'صغير الجمل يشبه البالغ منذ ولادته ويكبر حجمه فقط: نموّ مباشر. أمّا الفراشة فتمرّ بأطوار مختلفة الشكل تمامًا (بيضة، يرقة، خادرة، بالغة): نموّ بالتحوّل. طريقة النموّ تختلف من حيوان إلى آخر.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('37cf1301-dedd-5c2a-a931-c031642a9071', '40f9b65e-d3dd-5383-ab67-9a0d792a8201', 'وُصف حيوان بحري بأنّه يتزاوج، ثمّ ينمو صغيره داخل جسم أمّه ويرضع بعد ولادته حيًّا. ما تصنيفه الأرجح؟', '[{"id":"a","text":"سمكة بيوضة إخصابها خارجي"},{"id":"b","text":"برمائي إخصابه خارجي"},{"id":"c","text":"طائر بيوض يفرّخ بيضه"},{"id":"d","text":"ثديي بحري ولود إخصابه داخلي، مثل الدلفين"}]'::jsonb, 'd', 'التزاوج يدلّ على إخصاب داخلي، والنموّ داخل جسم الأمّ ثمّ الولادة الحيّة والرضاعة صفات الثدييات الولودة. فهو ثديي بحري ولود مثل الدلفين، رغم عيشه في الماء.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('95303c2e-c807-5bf5-9eb7-56e70eea638e', '3f5148df-5a90-5569-8326-597ed54c33e7', 'sciences-vie-terre-8eme', '⭐⭐ تمرين مراجعة (نمط امتحان): التكاثر عند الحيوانات', 2, 70, 15, 'practice', 'admin', 3)
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
  ('6b7ec60a-cfba-5961-8587-c989f7f2e5b3', '95303c2e-c807-5bf5-9eb7-56e70eea638e', 'أيّ خليّة تنتجها الأنثى في التكاثر الجنسي؟', '[{"id":"a","text":"الحيوان المنوي"},{"id":"b","text":"البويضة"},{"id":"c","text":"الخادرة"},{"id":"d","text":"الفرخ"}]'::jsonb, 'b', 'تنتج الأنثى خليّة تكاثرية كبيرة غير متحرّكة تُسمّى البويضة، بينما ينتج الذكر الحيوانات المنوية.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b60b9169-4fa6-5fa8-bda0-d38c54fe4dbe', '95303c2e-c807-5bf5-9eb7-56e70eea638e', 'السلحفاة البحرية تخرج إلى الشاطئ لتضع بيضها بعد أن يحدث الإخصاب داخل جسمها. ما نوع إخصابها وصنفها؟', '[{"id":"a","text":"إخصاب خارجي، وهي ولودة"},{"id":"b","text":"إخصاب داخلي، وهي ولودة"},{"id":"c","text":"إخصاب خارجي، وهي بيوضة"},{"id":"d","text":"إخصاب داخلي، وهي بيوضة"}]'::jsonb, 'd', 'حدوث الإخصاب داخل جسم الأنثى يعني إخصابًا داخليًّا، ووضعها بيضًا يخرج منه الصغير عند الفقس يعني أنّها بيوضة. الإخصاب الداخلي لا يستلزم الولودة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5a2d26d5-9e7f-54b8-b87c-f0724594993c', '95303c2e-c807-5bf5-9eb7-56e70eea638e', 'لماذا نصنّف الدلفين حيوانًا ولودًا رغم أنّه يعيش في الماء مثل الأسماك؟', '[{"id":"a","text":"لأنّه ثديي ينمو صغيره داخل جسم الأمّ ثمّ يولد حيًّا"},{"id":"b","text":"لأنّه يضع بيضًا في الماء مثل الأسماك"},{"id":"c","text":"لأنّ كلّ حيوان يعيش في الماء يكون ولودًا"},{"id":"d","text":"لأنّه يتنفّس بالخياشيم"}]'::jsonb, 'a', 'الدلفين ثديي: ينمو صغيره داخل جسم الأمّ ثمّ يولد حيًّا، وهذه صفة الولود. التصنيف يعتمد على طريقة التكاثر لا على وسط العيش، فليس كلّ ساكن للماء بيوضًا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('669fc01d-38a8-5d36-a464-7c233e9e2a91', '95303c2e-c807-5bf5-9eb7-56e70eea638e', 'ما الترتيب الصحيح لمراحل تحوّل الضفدع؟', '[{"id":"a","text":"البيضة ← الشرغوف ← الضفدع البالغ"},{"id":"b","text":"الشرغوف ← البيضة ← الضفدع البالغ"},{"id":"c","text":"الضفدع البالغ ← الشرغوف ← البيضة"},{"id":"d","text":"البيضة ← الضفدع البالغ ← الشرغوف"}]'::jsonb, 'a', 'يبدأ تحوّل الضفدع بالبيضة، ثمّ يخرج منها الشرغوف المائي بذيله وخياشيمه، ثمّ يتحوّل تدريجيًّا إلى ضفدع بالغ يعيش على اليابسة. الاتّجاه ثابت من البيضة نحو البالغ.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0c3f7a07-3daa-5534-b3c2-05d51290067c', '95303c2e-c807-5bf5-9eb7-56e70eea638e', 'ما الفرق بين التفريخ الطبيعي والتفريخ الاصطناعي؟', '[{"id":"a","text":"لا فرق بينهما إطلاقًا"},{"id":"b","text":"الطبيعي يخصّب البيض، والاصطناعي يمنع الإخصاب"},{"id":"c","text":"الطبيعي يستعمل مفرخة، والاصطناعي تقوم به الأنثى بجسمها"},{"id":"d","text":"الطبيعي تحتضن فيه الأنثى البيض بجسمها، والاصطناعي يوضع فيه البيض في مفرخة توفّر الحرارة آليًّا"}]'::jsonb, 'd', 'في التفريخ الطبيعي تحتضن الأنثى بيضها بجسمها الدافئ، أمّا في التفريخ الاصطناعي فيوضع البيض داخل جهاز يُسمّى المفرخة يوفّر الحرارة والرطوبة آليًّا لتفقيس أعداد كبيرة دفعةً واحدة. كلاهما يوفّر الحرارة فقط ولا يخصّب البيض.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f08c510b-2db3-55c4-a23a-df5a301941fb', '95303c2e-c807-5bf5-9eb7-56e70eea638e', 'أيّ الحيوانات التالية إخصابه خارجي؟', '[{"id":"a","text":"الجمل"},{"id":"b","text":"النورس"},{"id":"c","text":"السردين"},{"id":"d","text":"الأرنب"}]'::jsonb, 'c', 'السردين سمكة تطرح خلاياها التكاثرية في الماء فيحدث اللقاء خارج جسم الأنثى: إخصاب خارجي. أمّا الجمل والأرنب (ثدييات) والنورس (طائر) فإخصابها داخلي.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a17f73b5-d6e9-50f9-9d59-5c5d42fc49f1', '3f5148df-5a90-5569-8326-597ed54c33e7', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: التكاثر عند الحيوانات', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('b8b01ea0-4608-583f-8f8d-02c29a03cdb1', 'a17f73b5-d6e9-50f9-9d59-5c5d42fc49f1', 'صنّف حيوانًا يتزاوج ثمّ يضع بيضًا مخصّبًا يفقس بعد تفريخ. ماذا يكون؟', '[{"id":"a","text":"إخصاب خارجي، ولود"},{"id":"b","text":"إخصاب داخلي، بيوض"},{"id":"c","text":"إخصاب خارجي، بيوض"},{"id":"d","text":"إخصاب داخلي، ولود"}]'::jsonb, 'b', 'التزاوج قبل وضع البيض يدلّ على إخصاب داخلي، ووضع بيض مخصّب يفقس لاحقًا يدلّ على أنّه بيوض. هذا حال الطيور والزواحف: إخصاب داخلي مع بيوضة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ed181bc7-a947-5e98-abb7-4361e3de2096', 'a17f73b5-d6e9-50f9-9d59-5c5d42fc49f1', 'صنّف تلميذ حيوانًا بحريًّا يتنفّس بالخياشيم على أنّه ولود بمجرّد أنّه يعيش في الماء. أين الخطأ في استدلاله؟', '[{"id":"a","text":"لا خطأ، فكلّ حيوان مائي ولود"},{"id":"b","text":"الخطأ أنّ التنفّس بالخياشيم يعني الولودة"},{"id":"c","text":"الخطأ أنّ التصنيف يعتمد على طريقة التكاثر لا على وسط العيش؛ فأغلب أسماك الماء بيوضة إخصابها خارجي"},{"id":"d","text":"الخطأ أنّ الحيوانات المائية لا تتكاثر إطلاقًا"}]'::jsonb, 'c', 'وسط العيش وعضو التنفّس لا يحدّدان الصنف. الصنف (ولود/بيوض) يُحدَّد بطريقة قدوم الصغير: أغلب الأسماك بيوضة إخصابها خارجي، بينما ثدييات بحرية كالدلفين ولودة. الاستدلال بوسط العيش وحده غير صحيح.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c0f6a9d4-bdd5-528d-a786-3cbe03a366a2', 'a17f73b5-d6e9-50f9-9d59-5c5d42fc49f1', 'رتّب تلميذ مراحل الفراشة هكذا: البيضة ← الخادرة ← اليرقة ← الفراشة. أين الخطأ وما التصحيح؟', '[{"id":"a","text":"الخطأ في تقديم الخادرة على اليرقة؛ الصحيح: البيضة ← اليرقة ← الخادرة ← الفراشة"},{"id":"b","text":"لا خطأ، الترتيب صحيح"},{"id":"c","text":"الخطأ في وضع البيضة أوّلًا؛ الصحيح أن تبدأ بالفراشة"},{"id":"d","text":"الخطأ في ذكر الفراشة؛ يجب أن تنتهي بالشرغوف"}]'::jsonb, 'a', 'الترتيب الصحيح: البيضة ثمّ اليرقة (الدودة الآكلة للأوراق) ثمّ الخادرة (الطور الساكن) ثمّ الفراشة البالغة. الخطأ هو تقديم الخادرة على اليرقة؛ فالترتيب ثابت لا يُعكس. (سؤال اكتشاف خطأ: الخيار الصحيح يصف موضع الخطأ والتصحيح معًا.)', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2e7e5c00-1ee1-56a7-8334-ebc960ed7979', 'a17f73b5-d6e9-50f9-9d59-5c5d42fc49f1', 'وُضعت بيوض مخصّبة سليمة في مفرخة لكنّ الجهاز تعطّل فبقيت الحرارة منخفضة طوال المدّة. ما النتيجة الأرجح ولماذا؟', '[{"id":"a","text":"تفقس كلّها لأنّ الإخصاب وحده يكفي دون حرارة"},{"id":"b","text":"تفقس أسرع لأنّ البرودة تسرّع نموّ الجنين"},{"id":"c","text":"تتحوّل البيوض إلى بيوض غير مخصّبة بسبب البرد"},{"id":"d","text":"لا تفقس أو يتعطّل نموّها لأنّ نموّ الجنين يحتاج حرارة مناسبة يوفّرها التفريخ"}]'::jsonb, 'd', 'الإخصاب شرط ضروري لكنّه غير كافٍ: يحتاج الجنين داخل البيضة المخصّبة إلى حرارة مناسبة طوال التفريخ حتّى يكتمل نموّه. غياب الحرارة (تعطّل المفرخة) يوقف هذا النموّ فلا تفقس البيوض رغم أنّها مخصّبة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8b781607-4da9-5b49-aaf4-ece53ed14c64', 'a17f73b5-d6e9-50f9-9d59-5c5d42fc49f1', 'يعيش حيوانان في الماء: الأوّل يطرح خلاياه التكاثرية في الماء ويضع بيضًا، والثاني يتزاوج ويلد صغيره حيًّا ويرضعه. كيف نصنّف كلًّا منهما؟', '[{"id":"a","text":"كلاهما بيوض إخصابه خارجي لأنّهما في الماء"},{"id":"b","text":"الأوّل بيوض إخصابه خارجي، والثاني ولود إخصابه داخلي (ثديي بحري)"},{"id":"c","text":"الأوّل ولود إخصابه داخلي، والثاني بيوض إخصابه خارجي"},{"id":"d","text":"كلاهما ولود إخصابه داخلي"}]'::jsonb, 'b', 'الأوّل يطرح خلاياه في الماء ويضع بيضًا: إخصاب خارجي وبيوض (سمكة نموذجية). الثاني يتزاوج ويلد ويرضع: إخصاب داخلي وولود (ثديي بحري كالدلفين). وسط العيش المشترك لا يوحّد التصنيف.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('943538f3-4be5-5b31-b2c8-e648eed63a4c', 'a17f73b5-d6e9-50f9-9d59-5c5d42fc49f1', 'أيّ العبارات التالية عن التكاثر عند الحيوانات **خاطئة**؟', '[{"id":"a","text":"كلّ حيوان إخصابه داخلي يكون بالضرورة ولودًا"},{"id":"b","text":"الإخصاب الخارجي يحتاج إلى وسط مائي"},{"id":"c","text":"الحيوان الولود ينمو صغيره داخل جسم الأمّ قبل الولادة"},{"id":"d","text":"البيضة غير المخصّبة لا تفقس مهما طال تفريخها"}]'::jsonb, 'a', 'العبارة الخاطئة هي ربط الإخصاب الداخلي بالولودة حتمًا: فالطيور والزواحف إخصابها داخلي لكنّها بيوضة. أمّا العبارات الأخرى فصحيحة: الإخصاب الخارجي يحتاج ماءً، والولود ينمو داخل الأمّ، والبيضة غير المخصّبة لا تفقس.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('5daef3fb-d24a-57b1-a996-8759e50d2373', '3f5148df-5a90-5569-8326-597ed54c33e7', 'sciences-vie-terre-8eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): التكاثر عند الحيوانات', 3, 120, 30, 'boss', 'admin', 5)
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
  ('5842f0dd-729f-5578-9398-8d7add43e037', '5daef3fb-d24a-57b1-a996-8759e50d2373', 'ما دور الحيوان المنوي في التكاثر الجنسي؟', '[{"id":"a","text":"يحتضن البيضة ويوفّر لها الحرارة"},{"id":"b","text":"يُخصِب البويضة بالتقائه بها واندماجه فيها"},{"id":"c","text":"يتحوّل وحده إلى كائن جديد دون بويضة"},{"id":"d","text":"يغذّي الأنثى أثناء الحمل"}]'::jsonb, 'b', 'الحيوان المنوي هو الخليّة التكاثرية للذكر؛ يُخصِب البويضة بالتقائه بها واندماجه فيها لتتكوّن البيضة المخصّبة. لا ينمو وحده ولا يحتضن البيض.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8f578208-c3e8-5ecf-aba9-fcf40e6eda8f', '5daef3fb-d24a-57b1-a996-8759e50d2373', 'الحشرة والسمكة كلتاهما بيوضة. ما الفرق بينهما في نوع الإخصاب غالبًا؟', '[{"id":"a","text":"إخصاب الحشرة داخلي (تتزاوج)، وإخصاب السمكة خارجي (في الماء)"},{"id":"b","text":"إخصاب الحشرة خارجي، وإخصاب السمكة داخلي"},{"id":"c","text":"كلاهما خارجي دائمًا"},{"id":"d","text":"كلاهما داخلي دائمًا"}]'::jsonb, 'a', 'كونهما بيوضين لا يعني تطابق نوع الإخصاب: الحشرة تتزاوج فإخصابها داخلي رغم أنّها تضع بيضًا، بينما تطرح السمكة خلاياها في الماء فإخصابها خارجي. البيوضة صفة والإخصاب صفة أخرى مستقلّة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1f4a48a2-2626-546e-a207-b352cb650337', '5daef3fb-d24a-57b1-a996-8759e50d2373', 'لماذا يعدّ الإخصاب الداخلي أكثر ملاءمة للحيوانات التي تتكاثر بعيدًا عن الماء؟', '[{"id":"a","text":"لأنّه يمنع وضع البيض نهائيًّا"},{"id":"b","text":"لأنّه يحوّل الحيوان إلى ولود دائمًا"},{"id":"c","text":"لأنّه يحدث داخل جسم الأنثى فلا يحتاج إلى ماء يلتقي فيه الحيوان المنوي بالبويضة"},{"id":"d","text":"لأنّه يجعل الأنثى تنتج حيوانات منوية أيضًا"}]'::jsonb, 'c', 'في الإخصاب الداخلي يلتقي الحيوان المنوي بالبويضة داخل جسم الأنثى في وسط رطب محميّ، فلا حاجة إلى ماء خارجي؛ لذلك يلائم الحيوانات البرّية (ثدييات، طيور، زواحف، حشرات) التي تتكاثر بعيدًا عن الماء.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fc3136e2-cf3a-5008-a390-362d223827ee', '5daef3fb-d24a-57b1-a996-8759e50d2373', 'خرج من بيضة نورس فرخ يشبه أبويه في الشكل العامّ ولا يمرّ بأطوار مغايرة. ما نوع نموّه؟', '[{"id":"a","text":"نموّ بالتحوّل مثل الفراشة"},{"id":"b","text":"لا ينمو لأنّه بيوض"},{"id":"c","text":"نموّ يبدأ بطور الشرغوف"},{"id":"d","text":"نموّ مباشر: يشبه البالغ ويكبر حجمه فقط"}]'::jsonb, 'd', 'فرخ النورس يشبه أبويه منذ فقسه ولا يتغيّر شكله العامّ، بل يكبر حجمه حتّى يبلغ: هذا نموّ مباشر، خلافًا للتحوّل الذي تمرّ فيه الفراشة والضفدع بأطوار مختلفة الشكل.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('11a6116d-0726-5eaf-9cdd-a6239d9f1ad2', '5daef3fb-d24a-57b1-a996-8759e50d2373', 'احتُضنت بيوض دجاجة نحو 21 يومًا ففقس أغلبها بينما لم تفقس بيضتان لأنّهما لم تُخصَّبا. ماذا نستنتج عن شرطَي الفقس؟', '[{"id":"a","text":"الحرارة وحدها تكفي للفقس دون إخصاب"},{"id":"b","text":"الفقس يحتاج شرطين معًا: بيضة مخصّبة + تفريخ يوفّر الحرارة المناسبة"},{"id":"c","text":"الإخصاب وحده يكفي دون حرارة"},{"id":"d","text":"البيضتان غير المخصّبتين تفقسان لاحقًا بعد 21 يومًا إضافيًّا"}]'::jsonb, 'b', 'فقس البيض المخصّب دون غير المخصّب رغم تفريخ الجميع يبيّن أنّ الفقس يحتاج شرطين معًا: بيضة مخصّبة تحمل جنينًا، وتفريخ يوفّر الحرارة اللازمة لنموّه. غياب أيّ شرط يمنع الفقس.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e305a914-2fd0-5a7a-b7fb-73edd34e99ac', '5daef3fb-d24a-57b1-a996-8759e50d2373', 'قيل عن حيوان: «يعيش في الماء، يتزاوج، وتضع أنثاه بيضًا مخصّبًا على الشاطئ». ما تصنيفه الأدقّ؟', '[{"id":"a","text":"سمكة إخصابها خارجي وبيوضة"},{"id":"b","text":"ثديي بحري ولود إخصابه داخلي"},{"id":"c","text":"زاحف مائي إخصابه داخلي وبيوض، مثل السلحفاة البحرية"},{"id":"d","text":"برمائي إخصابه خارجي وبيوض"}]'::jsonb, 'c', 'التزاوج يدلّ على إخصاب داخلي، ووضع البيض المخصّب خارج الجسم (على الشاطئ) يدلّ على البيوضة. حيوان مائي يتزاوج ويضع بيضه على اليابسة هو زاحف بحري كالسلحفاة، لا سمكة (إخصابها خارجي) ولا ثديي (ولود).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f02fbabe-605d-5c0b-a041-929421cf4ce4', '3f5148df-5a90-5569-8326-597ed54c33e7', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐ (القمّة): التكاثر عند الحيوانات', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('7153712d-cfa4-5ddb-958c-93931fe72726', 'f02fbabe-605d-5c0b-a041-929421cf4ce4', 'لماذا لا يكفي وجود بويضات كثيرة عند أنثى حيوان لإنتاج صغار جدد؟', '[{"id":"a","text":"لأنّ البويضة تحتاج إلى إخصاب بحيوان منوي من الذكر لتصبح بيضة مخصّبة تنمو"},{"id":"b","text":"لأنّ البويضات تتحوّل وحدها إلى حيوانات منوية أوّلًا"},{"id":"c","text":"لأنّ عدد البويضات الكبير يمنع التكاثر"},{"id":"d","text":"لأنّ الأنثى وحدها تنتج بيضة مخصّبة دون ذكر"}]'::jsonb, 'a', 'التكاثر الجنسي يستلزم إخصابًا: لا تنمو البويضة إلى كائن جديد إلّا بعد التقائها بحيوان منوي من الذكر لتكوّن بيضة مخصّبة. فمهما كثرت البويضات، تبقى عقيمة دون إخصاب.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('634f7443-0fcd-5cf0-bfaa-0ffc2b4ba9e4', 'f02fbabe-605d-5c0b-a041-929421cf4ce4', 'لاحظ باحث أنّ سمكة تطرح آلاف البويضات دفعةً واحدة في الماء، بينما لا تلد بقرة إلّا عجلًا واحدًا. ما التفسير الأنسب لهذا الفرق في العدد؟', '[{"id":"a","text":"البقرة أكبر حجمًا فقط، ولا علاقة للعدد بطريقة التكاثر"},{"id":"b","text":"الإخصاب الخارجي في الماء تضيع فيه بويضات كثيرة، فتُنتج السمكة أعدادًا ضخمة لتعويض الفاقد، بينما يحمي الإخصاب الداخلي والنموّ داخل الأمّ صغير البقرة"},{"id":"c","text":"السمكة ولودة والبقرة بيوضة"},{"id":"d","text":"البقرة لا تحتاج إخصابًا أصلًا"}]'::jsonb, 'b', 'في الإخصاب الخارجي تُطرح الخلايا في الماء المفتوح فيضيع كثير منها ولا يُخصَّب أو يُفترَس، لذلك تنتج السمكة أعدادًا ضخمة لضمان بقاء بعضها. أمّا الإخصاب الداخلي والنموّ داخل جسم الأمّ فيوفّران حماية أكبر، فيكفي عدد قليل من الصغار.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2c122595-499f-526e-a284-64b45fc0ad33', 'f02fbabe-605d-5c0b-a041-929421cf4ce4', 'جمع تلميذ الصفات التالية لحيوان مجهول: «يتزاوج، تضع أنثاه بيضًا مخصّبًا، تحتضنه حتّى يفقس، والصغير يشبه البالغ عند خروجه». ما تصنيفه المتكامل؟', '[{"id":"a","text":"إخصاب خارجي، بيوض، نموّ بالتحوّل"},{"id":"b","text":"إخصاب داخلي، ولود، نموّ مباشر"},{"id":"c","text":"إخصاب داخلي، بيوض، نموّ مباشر (طائر مثلًا)"},{"id":"d","text":"إخصاب خارجي، ولود، نموّ بالتحوّل"}]'::jsonb, 'c', 'التزاوج ← إخصاب داخلي؛ وضع بيض مخصّب واحتضانه حتّى الفقس ← بيوض مع تفريخ طبيعي؛ الصغير يشبه البالغ ← نموّ مباشر. تجتمع هذه الصفات في الطيور: داخلي + بيوض + نموّ مباشر.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('357dac91-0182-55ac-8619-15e19e4af2e9', 'f02fbabe-605d-5c0b-a041-929421cf4ce4', 'قارن بين شرغوف الضفدع ويرقة الفراشة من حيث موقعهما في دورة النموّ. ما القاسم المشترك بينهما؟', '[{"id":"a","text":"كلاهما الطور البالغ النهائي في دورة النموّ"},{"id":"b","text":"كلاهما ينتمي إلى حيوان ولود"},{"id":"c","text":"كلاهما بيضة لم تُخصَّب بعد"},{"id":"d","text":"كلاهما طور يافع يختلف شكله عن البالغ ويسبقه في نموّ بالتحوّل"}]'::jsonb, 'd', 'الشرغوف واليرقة طوران يافعان يختلفان في الشكل اختلافًا كبيرًا عن البالغ (الضفدع، الفراشة) ويسبقانه في دورة نموّ بالتحوّل. كلاهما مرحلة انتقالية لا الطور النهائي، وكلاهما لحيوان بيوض لا ولود.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2a2be6ba-5d4b-5035-8ac0-4d0af5ccead5', 'f02fbabe-605d-5c0b-a041-929421cf4ce4', 'زعم تلميذ أنّ «كلّ حيوان يعيش في الماء إخصابه خارجي، وكلّ حيوان يعيش على اليابسة إخصابه داخلي». اختر المثال الذي يكفي وحده لإسقاط هذا التعميم.', '[{"id":"a","text":"السردين: سمكة في الماء إخصابها خارجي"},{"id":"b","text":"الأرنب: ثديي بريّ إخصابه داخلي"},{"id":"c","text":"الدلفين: ثديي يعيش في الماء لكن إخصابه داخلي"},{"id":"d","text":"النورس: طائر برّي إخصابه داخلي"}]'::jsonb, 'c', 'الدلفين حيوان مائي لكنّ إخصابه داخلي؛ فهو يناقض شقّ التعميم القائل إنّ كلّ مائي إخصابه خارجي، ويكفي هذا المثال المضادّ وحده لإسقاط القاعدة. أمّا الأمثلة الأخرى فتوافق التعميم ولا تناقضه.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8f45bd69-d56c-5f10-92f7-b334bcb19ce2', 'f02fbabe-605d-5c0b-a041-929421cf4ce4', 'وُضعت بيوض مخصّبة في مفرخة اصطناعية بحرارة مناسبة، لكن رُفعت الرطوبة والتهوية بشكل غير سليم فمات أغلب الأجنّة. ماذا يبيّن ذلك عن التفريخ الاصطناعي؟', '[{"id":"a","text":"أنّ الحرارة وحدها تضمن الفقس دائمًا مهما كانت بقية الظروف"},{"id":"b","text":"أنّ المفرخة يجب أن توفّر ظروفًا ملائمة متكاملة (حرارة ورطوبة وتهوية) لنموّ الجنين، لا الحرارة وحدها"},{"id":"c","text":"أنّ البيوض تحوّلت إلى غير مخصّبة"},{"id":"d","text":"أنّ التفريخ الاصطناعي يخصّب البيض بنفسه"}]'::jsonb, 'b', 'التفريخ الاصطناعي ينجح فقط إذا حاكت المفرخة الظروف الطبيعية بشكل متكامل: حرارة ورطوبة وتهوية مناسبة. ضبط الحرارة وحده لا يكفي؛ فاختلال بقية الظروف يعطّل نموّ الجنين رغم أنّ البيض مخصّب وحرارته مضبوطة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4b462b22-ec8f-5352-89bc-9080ea9fd40d', '92b5eccd-cfb2-589e-bbf9-8b342e50ca10', 'sciences-vie-terre-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('cb54cb1e-f1bd-5afe-a894-27eff63e4517', '4b462b22-ec8f-5352-89bc-9080ea9fd40d', 'ما الهدف من تحسين الإنتاج الحيواني؟', '[{"id":"a","text":"تقليل عدد الحيوانات في الضّيعة فقط"},{"id":"b","text":"الحصول على كمّية أكبر ونوعيّة أفضل من المنتجات الحيوانيّة"},{"id":"c","text":"منع الحيوانات من التّكاثر نهائيًّا"},{"id":"d","text":"تغيير لون الحيوانات لتصبح أجمل"}]'::jsonb, 'b', 'يهدف تحسين الإنتاج الحيواني إلى الرّفع من المنتجات (حليب، لحم، بيض، صوف، عسل) كمًّا (كمّية أكبر) وكيفًا (نوعيّة أفضل)، وذلك بتدخّل المربّي بتقنيات مناسبة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c0096a38-f8ef-573e-81e0-32ed310cd862', '4b462b22-ec8f-5352-89bc-9080ea9fd40d', 'ماذا يعني «الانتخاب» في تربية الحيوان؟', '[{"id":"a","text":"قتل الحيوانات الضّعيفة والتّخلّص منها"},{"id":"b","text":"تزويج سلالتين مختلفتين معًا"},{"id":"c","text":"اختيار الأفراد ذوي أفضل الصّفات ليكونوا هم الّذين يتكاثرون"},{"id":"d","text":"إطعام كلّ الحيوانات علفًا واحدًا"}]'::jsonb, 'c', 'الانتخاب هو اصطفاء الأفراد ذوي أفضل الصّفات وجعلهم يتكاثرون، حتّى تنتقل صفاتهم الجيّدة إلى النّسل. وهو ليس قتلًا للضّعفاء، بل اختيار للأفضل للتّكاثر.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8c726669-9951-5dd1-bd7b-82dc34584902', '4b462b22-ec8f-5352-89bc-9080ea9fd40d', 'في التّلقيح الاصطناعي، ماذا يفعل المربّي؟', '[{"id":"a","text":"يضع نطاف ذكر منتخب في إناث كثيرة دون تزاوج مباشر"},{"id":"b","text":"يترك الذّكر والأنثى يتزاوجان مباشرة كالعادة"},{"id":"c","text":"يحسّن علف الحيوانات ليزيد إنتاجها"},{"id":"d","text":"ينقل الحيوانات إلى حظيرة أوسع"}]'::jsonb, 'a', 'في التّلقيح الاصطناعي يأخذ المربّي النّطاف من ذكر منتخب ذي صفات ممتازة ويضعها في الجهاز التّناسليّ لعدد كبير من الإناث دون تزاوج مباشر، فتنتشر صفات الذّكر الممتاز على نطاق واسع. أمّا التّزاوج المباشر فهو التّلقيح الطّبيعي.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('55554351-47e3-5a44-917e-79fe4e5c061a', '4b462b22-ec8f-5352-89bc-9080ea9fd40d', 'ما هو التّهجين بين السّلالات؟', '[{"id":"a","text":"اختيار أفضل بقرة داخل نفس السّلالة"},{"id":"b","text":"إطعام الحيوان علفًا متوازنًا لزيادة إنتاجه"},{"id":"c","text":"تنظيف الحظيرة وتهويتها جيّدًا"},{"id":"d","text":"تزويج فردين من سلالتين مختلفتين للحصول على نسل يجمع صفاتهما"}]'::jsonb, 'd', 'التّهجين هو تزويج فردين من سلالتين مختلفتين للحصول على هجين يجمع بين صفات السّلالتين (مثل مقاومة سلالة محلّيّة وغزارة إنتاج سلالة مستوردة). أمّا اختيار الأفضل داخل السّلالة الواحدة فهو الانتخاب.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('861e15aa-eb53-5ca8-9436-d4b5a65a4202', '4b462b22-ec8f-5352-89bc-9080ea9fd40d', 'بقرة أُطعِمت علفًا ممتازًا فزاد إنتاجها من الحليب. ماذا نستنتج عن عجلها؟', '[{"id":"a","text":"سيرث حتمًا إنتاجًا مرتفعًا من الحليب لأنّ أمّه أُطعِمت جيّدًا"},{"id":"b","text":"تحسين التّغذية رفع مردود الأمّ فقط ولم يغيّر مورثاتها، فلا ينتقل هذا الأثر بالوراثة"},{"id":"c","text":"سيصبح العجل من سلالة جديدة مختلفة تمامًا"},{"id":"d","text":"لن ينتج العجل أيّ حليب في المستقبل"}]'::jsonb, 'b', 'تحسين التّغذية يرفع مردود الحيوان الموجود فقط ولا يغيّر مورثاته؛ لذلك لا ينتقل هذا الأثر إلى النّسل بالوراثة. الصّفات المنقولة للنّسل لا تتحسّن إلّا بالتّقنيات الوراثيّة كالانتخاب والتّلقيح الاصطناعي والتّهجين.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b7845e62-06f5-5884-b797-aff68bae0906', '92b5eccd-cfb2-589e-bbf9-8b342e50ca10', 'sciences-vie-terre-8eme', '⭐ تمرين: أساسيات تحسين الإنتاج الحيواني', 1, 50, 10, 'practice', 'admin', 1)
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
  ('42d0067b-def0-584b-9092-3ff29278ea36', 'b7845e62-06f5-5884-b797-aff68bae0906', 'احتفظ مربٍّ بجهة سليانة بالبقرة الأكثر إنتاجًا للحليب ليجعلها تتكاثر، وأبعد قليلات الإنتاج عن التّكاثر. ما اسم هذه التّقنية؟', '[{"id":"a","text":"التّهجين"},{"id":"b","text":"التّلقيح الاصطناعي"},{"id":"c","text":"تحسين الإيواء"},{"id":"d","text":"الانتخاب"}]'::jsonb, 'd', 'اختيار الأفراد ذوي أفضل الصّفات (أكثر الأبقار حليبًا) ليكونوا هم الّذين يتكاثرون هو تعريف الانتخاب؛ فتنتقل صفاتهم الجيّدة إلى النّسل.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4234efe4-a907-5de6-b2a3-fa0a14e2bae0', 'b7845e62-06f5-5884-b797-aff68bae0906', 'من أيّ حيوان من حيوانات التّربية نحصل أساسًا على الصّوف؟', '[{"id":"a","text":"الأغنام"},{"id":"b","text":"الدّجاج"},{"id":"c","text":"النّحل"},{"id":"d","text":"السّمك"}]'::jsonb, 'a', 'الصّوف منتوج نحصل عليه من الأغنام. أمّا الدّجاج فمصدر للبيض واللّحم، والنّحل مصدر للعسل.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ee51b6d9-7172-5e7e-88bb-952b5bc3f59a', 'b7845e62-06f5-5884-b797-aff68bae0906', 'ما هو التّلقيح الطّبيعي؟', '[{"id":"a","text":"أخذ نطاف ذكر منتخب ووضعها في الإناث دون تزاوج"},{"id":"b","text":"تزاوج مباشر بين الذّكر والأنثى يحدث بعده الإخصاب"},{"id":"c","text":"تقديم علف متوازن للحيوان لزيادة إنتاجه"},{"id":"d","text":"تزويج سلالتين مختلفتين معًا"}]'::jsonb, 'b', 'التّلقيح الطّبيعي هو التّزاوج المباشر بين الذّكر والأنثى فيحدث الإخصاب داخل جسم الأنثى. أمّا وضع نطاف ذكر منتخب في الإناث دون تزاوج فهو التّلقيح الاصطناعي.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e1f91378-8b55-535b-8dd8-038d505ad155', 'b7845e62-06f5-5884-b797-aff68bae0906', 'ما الهدف من التّهجين بين سلالتين مختلفتين؟', '[{"id":"a","text":"الحصول على نسل يجمع بين صفات السّلالتين معًا"},{"id":"b","text":"اختيار أفضل الأفراد داخل سلالة واحدة"},{"id":"c","text":"تنظيف الحظيرة وتحسين تهويتها"},{"id":"d","text":"علاج الحيوانات المريضة بالأدوية البيطريّة"}]'::jsonb, 'a', 'التّهجين يزوّج فردين من سلالتين مختلفتين للحصول على هجين يجمع صفاتهما (مثلًا مقاومة سلالة وغزارة إنتاج أخرى). أمّا اختيار الأفضل داخل السّلالة الواحدة فهو الانتخاب.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7950ce89-5fc5-568c-b180-e654ae97c9d1', 'b7845e62-06f5-5884-b797-aff68bae0906', 'لماذا يحرص المربّي على أن تكون الحظيرة نظيفة وجيّدة التّهوية وواسعة؟', '[{"id":"a","text":"لأنّ ذلك يغيّر سلالة الحيوانات ومورثاتها"},{"id":"b","text":"لأنّ ذلك يجعل الحيوان أكثر إجهادًا"},{"id":"c","text":"لأنّ ظروف الإيواء الجيّدة تقلّل إجهاد الحيوان وأمراضه فيرتفع إنتاجه"},{"id":"d","text":"لأنّ ذلك يمنع الحيوانات من التّكاثر"}]'::jsonb, 'c', 'تحسين ظروف الإيواء (نظافة، تهوية، مساحة كافية) يقلّل إجهاد الحيوان والأمراض فيرتفع مردوده. وهو من التّقنيات الّتي ترفع المردود دون أن تغيّر المورثات.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2599d5c9-1c2a-5f9c-a974-818b3a0ca78d', 'b7845e62-06f5-5884-b797-aff68bae0906', 'في أيّ شيء يؤثّر تحسين تغذية الحيوان بعلف متوازن وكافٍ؟', '[{"id":"a","text":"يغيّر مورثات الحيوان فتنتقل للنّسل"},{"id":"b","text":"يرفع مردود الحيوان الموجود دون تغيير مورثاته"},{"id":"c","text":"يحوّل الحيوان إلى سلالة جديدة"},{"id":"d","text":"لا أثر له إطلاقًا على الإنتاج"}]'::jsonb, 'b', 'تحسين التّغذية يرفع مردود الحيوان الموجود (حليب، لحم، بيض) دون أن يغيّر مورثاته أو سلالته؛ لذلك لا ينتقل هذا الأثر إلى النّسل بالوراثة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0335245d-3a3c-5b24-a8ac-f185b490c603', '92b5eccd-cfb2-589e-bbf9-8b342e50ca10', 'sciences-vie-terre-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: تحسين الإنتاج الحيواني', 3, 120, 30, 'boss', 'admin', 2)
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
  ('8fce9765-d7c7-5eff-a343-d7f6c0ffa974', '0335245d-3a3c-5b24-a8ac-f185b490c603', 'يريد نحّال بجهة عين دراهم أن تصبح طوائف نحله كلّها هادئة وكثيرة إنتاج العسل. أيّ تصرّف يوافق مبدأ الانتخاب؟', '[{"id":"a","text":"يربّي ملكات جديدة من الملكة الّتي تنحدر منها أهدأ طائفة وأكثرها عسلًا"},{"id":"b","text":"يطعم كلّ الطّوائف سكّرًا إضافيًّا فقط"},{"id":"c","text":"يجلب ملكة من سلالة نحل مختلفة تمامًا"},{"id":"d","text":"ينقل الخلايا إلى مكان أكثر تهوية فحسب"}]'::jsonb, 'a', 'الانتخاب هو اصطفاء الأفضل (الملكة صاحبة الطّائفة الأهدأ والأكثر عسلًا) للتّكاثر حتّى تُورَّث صفاتها. جلب ملكة من سلالة أخرى تهجين، والتّغذية والتّهوية ترفعان المردود دون أن تنتخبا صفة موروثة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7b2f760f-bd0d-505c-b719-3816551b9756', '0335245d-3a3c-5b24-a8ac-f185b490c603', 'ذكر تيس (ذكر الماعز) منتخب ذو صفات ممتازة. كيف يستفيد المربّي من صفاته لأكبر عدد من الإناث في أقصر وقت؟', '[{"id":"a","text":"بتحسين علف الإناث فقط"},{"id":"b","text":"بالتّلقيح الاصطناعي: يوزّع نطافه على عدد كبير من الإناث دون تزاوج مباشر"},{"id":"c","text":"بتركه يتزاوج طبيعيًّا مع أنثى واحدة في الموسم"},{"id":"d","text":"بتوسيع الحظيرة وتحسين تهويتها"}]'::jsonb, 'b', 'التّلقيح الاصطناعي يتيح توزيع نطاف ذكر منتخب واحد على عدد كبير جدًّا من الإناث دون تزاوج مباشر، فتنتشر صفاته الممتازة بسرعة وعلى نطاق واسع، وهو أنجع من التّزاوج الطّبيعي مع أنثى واحدة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('304869d7-6632-56c2-bd18-f2ce22fa7d59', '0335245d-3a3c-5b24-a8ac-f185b490c603', 'أراد مربٍّ الجمع بين مقاومة سلالة أبقار محلّيّة للحرارة وغزارة إنتاج سلالة مستوردة للحليب في نسل واحد. ما التّقنية المناسبة؟', '[{"id":"a","text":"الانتخاب داخل السّلالة المحلّيّة وحدها"},{"id":"b","text":"تحسين تغذية السّلالة المستوردة فقط"},{"id":"c","text":"التّهجين بين السّلالة المحلّيّة والسّلالة المستوردة"},{"id":"d","text":"تحسين ظروف الإيواء لكلتا السّلالتين"}]'::jsonb, 'c', 'الجمع بين صفات سلالتين مختلفتين (مقاومة + غزارة) في نسل واحد يتحقّق بالتّهجين بينهما. الانتخاب يبقى داخل سلالة واحدة، والتّغذية والإيواء يرفعان المردود دون جمع صفات سلالتين.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bc57802b-d0d6-5f93-98f5-2d8b0ef99e9b', '0335245d-3a3c-5b24-a8ac-f185b490c603', 'قال تلميذ: «التّلقيح الاصطناعي والتّلقيح الطّبيعي شيء واحد، والفرق في الاسم فقط.» أين الخطأ بالضّبط؟', '[{"id":"a","text":"لا خطأ، فهما فعلًا الشّيء نفسه"},{"id":"b","text":"الخطأ أنّ الطّبيعي يحدث دون إخصاب أصلًا"},{"id":"c","text":"الخطأ أنّ في الطّبيعي تزاوجًا مباشرًا، أمّا في الاصطناعي فيتدخّل الإنسان بوضع نطاف ذكر منتخب في الإناث دون تزاوج"},{"id":"d","text":"الخطأ أنّ الاصطناعي لا يؤدّي إلى أيّ نسل"}]'::jsonb, 'c', 'الفرق جوهريّ لا لفظيّ: في التّلقيح الطّبيعي يتزاوج الذّكر والأنثى مباشرة، أمّا في الاصطناعي فيتدخّل الإنسان فيأخذ نطاف ذكر منتخب ويضعها في إناث كثيرة دون تزاوج، وكلاهما يؤدّي إلى إخصاب ونسل.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1bee5515-e499-556c-918d-cc2fb981f883', '0335245d-3a3c-5b24-a8ac-f185b490c603', 'مربّي دواجن بالمنستير حسّن تغذية دجاجاته ونظافة القنّ، فارتفع عدد البيض. لكنّ صيصان الجيل التّالي عادت إلى إنتاج ضعيف حين أُهمِلت تغذيتها. ما التّفسير الأصحّ؟', '[{"id":"a","text":"التّغذية والنّظافة رفعتا مردود الأمّهات فقط ولم تغيّرا مورثاتهنّ، فلم يُورَّث الإنتاج المرتفع"},{"id":"b","text":"التّغذية الجيّدة غيّرت سلالة الدّجاج نهائيًّا فكان يجب أن يبقى الإنتاج مرتفعًا"},{"id":"c","text":"الصّيصان وُلدت من سلالة مختلفة تمامًا عن أمّهاتها"},{"id":"d","text":"البيض الكثير أضعف مورثات الصّيصان"}]'::jsonb, 'a', 'تحسين التّغذية والنّظافة يرفع مردود الحيوان الموجود دون أن يغيّر مورثاته؛ لذلك لا يُورَّث هذا التّحسّن، وحين أُهمِلت تغذية الجيل التّالي عاد الإنتاج ضعيفًا. لتحسين الصّفات الموروثة يلزم انتخاب أو تلقيح اصطناعي أو تهجين.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b1aa4ab9-9e75-5def-adf3-3c0deeb5096e', '0335245d-3a3c-5b24-a8ac-f185b490c603', 'لماذا يُعدّ التّلقيح الاصطناعي وسيلة للوقاية أيضًا، لا للإنتاج فقط؟', '[{"id":"a","text":"لأنّه يزيد وزن الحيوان مباشرة"},{"id":"b","text":"لأنّه يجنّب التّزاوج المباشر فيقي من بعض الأمراض الّتي قد تنتقل به، ويغني عن نقل الحيوانات"},{"id":"c","text":"لأنّه يغيّر لون الحيوانات ليصبح أجمل"},{"id":"d","text":"لأنّه يوقف تكاثر القطيع نهائيًّا"}]'::jsonb, 'b', 'إلى جانب نشر صفات ذكر منتخب، يُجنِّب التّلقيح الاصطناعي التّزاوج المباشر فيقي من بعض الأمراض المنقولة به، ويغني عن نقل الحيوانات لمسافات طويلة، ويساعد على تنظيم الولادات.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6585500e-bbed-54e4-acb9-35af02eaa808', '92b5eccd-cfb2-589e-bbf9-8b342e50ca10', 'sciences-vie-terre-8eme', '⭐⭐ تمرين مراجعة (نمط امتحان): تحسين الإنتاج الحيواني', 2, 70, 15, 'practice', 'admin', 3)
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
  ('df459ef2-b872-56c1-9e7d-e7d88446242e', '6585500e-bbed-54e4-acb9-35af02eaa808', 'صنِّف: أيّ التّقنيات التّالية تحسّن الصّفات المنقولة إلى النّسل (تقنية وراثيّة)؟', '[{"id":"a","text":"تحسين تغذية الحيوان بعلف متوازن"},{"id":"b","text":"تنظيف الحظيرة وتحسين تهويتها"},{"id":"c","text":"الانتخاب واصطفاء الأفضل للتّكاثر"},{"id":"d","text":"تلقيح الحيوان ضدّ الأمراض"}]'::jsonb, 'c', 'الانتخاب تقنية وراثيّة: يختار الأفضل للتّكاثر فتنتقل صفاته إلى النّسل. أمّا التّغذية والنّظافة والتّهوية والتّلقيح ضدّ الأمراض فترفع مردود الحيوان الموجود دون تغيير مورثاته.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f831e819-32a1-5cf5-a0de-209a6742c785', '6585500e-bbed-54e4-acb9-35af02eaa808', 'أيّ زوج من التّقنيات ينتمي كلاهما إلى «تحسين ظروف التّربية» (لا إلى التّقنيات الوراثيّة)؟', '[{"id":"a","text":"الانتخاب والتّهجين"},{"id":"b","text":"تحسين التّغذية وتحسين الظّروف الصّحّية"},{"id":"c","text":"التّلقيح الاصطناعي والانتخاب"},{"id":"d","text":"التّهجين والتّلقيح الاصطناعي"}]'::jsonb, 'b', 'تحسين التّغذية وتحسين الظّروف الصّحّية (والإيواء) يرفعان مردود الحيوان الموجود دون تغيير مورثاته، فهما من تحسين ظروف التّربية. أمّا الانتخاب والتّلقيح الاصطناعي والتّهجين فتقنيات وراثيّة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0b15bd21-2b5d-5e10-86c7-13ee305177f1', '6585500e-bbed-54e4-acb9-35af02eaa808', 'الفرق الأساسيّ بين الانتخاب والتّهجين هو أنّ:', '[{"id":"a","text":"الانتخاب يتمّ داخل السّلالة الواحدة، والتّهجين بين سلالتين مختلفتين"},{"id":"b","text":"الانتخاب يخصّ النّبات والتّهجين يخصّ الحيوان فقط"},{"id":"c","text":"الانتخاب يرفع المردود دون توريث، والتّهجين لا يوريّث شيئًا"},{"id":"d","text":"لا فرق بينهما فهما تسميتان لتقنية واحدة"}]'::jsonb, 'a', 'الانتخاب اصطفاء للأفضل داخل السّلالة الواحدة، أمّا التّهجين فتزويج فردين من سلالتين مختلفتين لجمع صفاتهما. وكلاهما تقنية وراثيّة تؤثّر في صفات النّسل.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('aa4fc70b-19b1-5d12-83fc-40c5484067e1', '6585500e-bbed-54e4-acb9-35af02eaa808', 'مربٍّ يريد رفع إنتاج قطيع أبقاره من الحليب هذا الموسم فورًا، دون انتظار أجيال جديدة. ما أنسب تدخّل مباشر؟', '[{"id":"a","text":"تهجين القطيع بسلالة أخرى وانتظار مولود جديد"},{"id":"b","text":"تحسين تغذية الأبقار الحاليّة وظروف صحّتها وإيوائها"},{"id":"c","text":"انتخاب عجول جديدة للتّكاثر مستقبلًا"},{"id":"d","text":"التّلقيح الاصطناعي لإنجاب جيل قادم"}]'::jsonb, 'b', 'لرفع إنتاج القطيع الحاليّ فورًا في الموسم نفسه، الأنسب تحسين التّغذية والصّحّة والإيواء لأنّها ترفع مردود الحيوانات الموجودة. أمّا التّهجين والانتخاب والتّلقيح الاصطناعي فتؤثّر في الأجيال القادمة، لا في الموسم الحاليّ.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6215aa19-fd85-5c0b-b781-8dbb65ab2eea', '6585500e-bbed-54e4-acb9-35af02eaa808', 'بقرتان من نفس السّلالة أُطعِمتا العلف نفسه؛ أعطت الأولى حليبًا أكثر بكثير من الثّانية باستمرار. ما التّصرّف الأصحّ لتحسين السّلالة عبر الأجيال؟', '[{"id":"a","text":"التّخلّص من البقرتين معًا"},{"id":"b","text":"زيادة علف البقرة الثّانية فقط حتّى تلحق بالأولى"},{"id":"c","text":"انتخاب البقرة الأولى (الأغزر) لتكون هي الّتي تتكاثر فتُورَّث صفتها"},{"id":"d","text":"نقل البقرتين إلى حظيرة أوسع فحسب"}]'::jsonb, 'c', 'بما أنّ الظّروف متماثلة (نفس السّلالة ونفس العلف) وتفوّقت الأولى باستمرار، فالأرجح أنّ تفوّقها موروث؛ فانتخابها للتّكاثر يوريّث صفة الغزارة للنّسل ويحسّن السّلالة عبر الأجيال.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8b82111c-4161-5975-a99a-2002d1708700', '6585500e-bbed-54e4-acb9-35af02eaa808', 'لماذا يُوصف الانتخاب بأنّه يحسّن السّلالة «عبر الأجيال» لا دفعة واحدة؟', '[{"id":"a","text":"لأنّه لا ينتقل إلى النّسل أصلًا"},{"id":"b","text":"لأنّه يغيّر مورثات الحيوان الواحد في يوم واحد"},{"id":"c","text":"لأنّه يعتمد على تحسين التّغذية فقط"},{"id":"d","text":"لأنّ أثره يظهر فقط بتكرار اصطفاء الأفضل جيلًا بعد جيل فتتراكم الصّفات الجيّدة"}]'::jsonb, 'd', 'الانتخاب يعمل بتوريث صفات الأفراد المصطفَين إلى نسلهم؛ وبتكرار اصطفاء الأفضل جيلًا بعد جيل تتراكم الصّفات الجيّدة في القطيع فتتحسّن السّلالة تدريجيًّا عبر الأجيال لا دفعة واحدة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('485e4050-9e5f-5568-aa7f-ffeb54c8195f', '92b5eccd-cfb2-589e-bbf9-8b342e50ca10', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: تحسين الإنتاج الحيواني', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('e347394c-8f6d-5367-9127-0f3e8c4d35e3', '485e4050-9e5f-5568-aa7f-ffeb54c8195f', 'أيّ العبارات التّالية عن تحسين الإنتاج الحيواني **خاطئة**؟', '[{"id":"a","text":"الانتخاب يختار الأفضل داخل السّلالة للتّكاثر"},{"id":"b","text":"التّهجين يجمع صفات سلالتين مختلفتين في نسل واحد"},{"id":"c","text":"تحسين التّغذية يغيّر مورثات الحيوان فتنتقل الزّيادة إلى النّسل بالوراثة"},{"id":"d","text":"التّلقيح الاصطناعي ينشر صفات ذكر منتخب في إناث كثيرة دون تزاوج"}]'::jsonb, 'c', 'العبارة الخاطئة أنّ تحسين التّغذية يغيّر المورثات: التّغذية ترفع مردود الحيوان الموجود فقط ولا تمسّ مورثاته، فلا تنتقل الزّيادة للنّسل بالوراثة. العبارات الثّلاث الأخرى صحيحة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c8aeec27-8249-5cb7-b932-5f92a25444f8', '485e4050-9e5f-5568-aa7f-ffeb54c8195f', 'ثلاثة مربّين يريدون كلٌّ منهم هدفًا مختلفًا: (1) نشر صفات ثور ممتاز بسرعة على أكبر عدد من الأبقار، (2) جمع مقاومة سلالة محلّيّة وغزارة سلالة مستوردة، (3) رفع إنتاج القطيع الحاليّ هذا الموسم. ما التّرتيب الصّحيح للتّقنيات؟', '[{"id":"a","text":"(1) تلقيح اصطناعي، (2) تهجين، (3) تحسين التّغذية والظّروف"},{"id":"b","text":"(1) تهجين، (2) انتخاب، (3) تلقيح اصطناعي"},{"id":"c","text":"(1) تحسين التّغذية، (2) تلقيح اصطناعي، (3) تهجين"},{"id":"d","text":"(1) انتخاب، (2) تحسين الإيواء، (3) تهجين"}]'::jsonb, 'a', 'نشر صفات ذكر ممتاز على أكبر عدد من الإناث = التّلقيح الاصطناعي؛ جمع صفات سلالتين مختلفتين = التّهجين؛ رفع إنتاج القطيع الموجود في الموسم نفسه = تحسين التّغذية والظّروف الصّحّية والإيواء.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c50ab1b8-eeb2-5577-a7dc-9ca621d8557c', '485e4050-9e5f-5568-aa7f-ffeb54c8195f', 'لماذا لا يكفي التّلقيح الاصطناعي وحده لضمان قطيع ذي صفات ممتازة إن كان الذّكر المستعمَل عاديًّا غير منتخب؟', '[{"id":"a","text":"لأنّ التّلقيح الاصطناعي يخصّ الإناث دون الذّكور"},{"id":"b","text":"لأنّ التّلقيح الاصطناعي لا يؤدّي إلى أيّ إخصاب أصلًا"},{"id":"c","text":"لأنّ التّلقيح الاصطناعي يغيّر صفات الذّكر إلى الأفضل تلقائيًّا"},{"id":"d","text":"لأنّ التّلقيح الاصطناعي ينشر صفات الذّكر المستعمَل كما هي؛ فإن لم يكن منتخبًا نشرنا صفات عاديّة على نطاق واسع"}]'::jsonb, 'd', 'التّلقيح الاصطناعي أداة نشر: ينقل صفات الذّكر المستعمَل إلى نسله كما هي. فقوّته تأتي من كون الذّكر **منتخبًا** ذا صفات ممتازة؛ فإن كان عاديًّا نشرنا صفات عاديّة على نطاق واسع. لذلك يُقرَن غالبًا بالانتخاب.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('897d2fba-84a7-5a19-8cc6-fcbbb819f504', '485e4050-9e5f-5568-aa7f-ffeb54c8195f', 'هجّن مربٍّ سلالة أبقار محلّيّة مقاومة للحرارة بسلالة مستوردة غزيرة الحليب فحصل على هجين جيّد. لكنّه لاحظ أنّ إنتاج الهجين ينخفض بشدّة حين يهمل تغذيته وحظيرته. ما الاستنتاج الأدقّ؟', '[{"id":"a","text":"الظّروف الجيّدة وحدها كافية والتّهجين لا لزوم له"},{"id":"b","text":"التّهجين فشل تمامًا فلا قيمة له"},{"id":"c","text":"التّهجين أعطى صفات وراثيّة جيّدة، لكنّ التّعبير عنها كاملًا يبقى مرهونًا بظروف تربية جيّدة (تغذية وصحّة وإيواء)"},{"id":"d","text":"الهجين تحوّل إلى السّلالة المحلّيّة من جديد"}]'::jsonb, 'c', 'التّقنيات الوراثيّة (كالتّهجين) تمنح الحيوان قدرة موروثة جيّدة، لكنّ ظهور هذه القدرة كاملةً يتطلّب ظروف تربية مناسبة. فالوراثة والظّروف تتكاملان: صفات جيّدة موروثة + تغذية وصحّة وإيواء جيّدة = إنتاج أعلى فعليّ.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bee77870-5dcb-52a6-8273-ca478f4a340a', '485e4050-9e5f-5568-aa7f-ffeb54c8195f', 'تلميذ قال: «ما دام تحسين التّغذية لا يغيّر المورثات، فهو عديم الفائدة في تحسين الإنتاج الحيواني.» ما الرّدّ الصّحيح؟', '[{"id":"a","text":"الرّدّ صحيح: التّغذية لا فائدة منها فعلًا"},{"id":"b","text":"خطأ: تحسين التّغذية يرفع مردود الحيوان الموجود فعليًّا (حليب/لحم/بيض أكثر)، وإن كان لا يغيّر المورثات المنقولة للنّسل"},{"id":"c","text":"خطأ: تحسين التّغذية يغيّر المورثات فعلًا وينقلها للنّسل"},{"id":"d","text":"الرّدّ صحيح لأنّ الإنتاج يتوقّف على الوراثة وحدها"}]'::jsonb, 'b', 'الاستنتاج خاطئ: تحسين التّغذية مفيد جدًّا لأنّه يرفع الإنتاج الفعليّ للحيوان الموجود، حتّى وإن لم يغيّر المورثات المنقولة للنّسل. عدم تغيير المورثات لا يعني انعدام الفائدة؛ التّحسين نوعان متكاملان: وراثيّ وظرفيّ.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('260547f4-ff60-57f7-832d-d3309ea75412', '485e4050-9e5f-5568-aa7f-ffeb54c8195f', 'لماذا يجمع المربّي الحديث غالبًا بين التّقنيات الوراثيّة (انتخاب/تلقيح اصطناعي/تهجين) وتحسين ظروف التّربية معًا، بدل الاكتفاء بواحدة؟', '[{"id":"a","text":"لأنّ الجمع بينها يوقف تكاثر القطيع لضبط عدده"},{"id":"b","text":"لأنّ التّقنيات الوراثيّة وحدها ترفع الإنتاج فورًا دون حاجة إلى تغذية"},{"id":"c","text":"لأنّ تحسين الظّروف وحده يغيّر مورثات القطيع"},{"id":"d","text":"لأنّ التّقنيات الوراثيّة تحسّن قدرة القطيع الموروثة، وتحسين الظّروف يجعل هذه القدرة تُترجَم إلى إنتاج فعليّ مرتفع؛ فيتكامل النّوعان"}]'::jsonb, 'd', 'النّوعان متكاملان: الانتخاب والتّلقيح الاصطناعي والتّهجين تحسّن القدرة الموروثة للقطيع عبر الأجيال، وتحسين التّغذية والصّحّة والإيواء يتيح لهذه القدرة أن تُترجَم إلى إنتاج فعليّ مرتفع في الحاضر. لذا يجمع المربّي بينهما لأقصى مردود.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('614a69d9-18ef-50a5-9084-ea865afcbd26', '92b5eccd-cfb2-589e-bbf9-8b342e50ca10', 'sciences-vie-terre-8eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): تحسين الإنتاج الحيواني', 3, 120, 30, 'boss', 'admin', 5)
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
  ('e2967043-858d-58f5-bdd2-3d433f3f8173', '614a69d9-18ef-50a5-9084-ea865afcbd26', 'منتوجات ومصادرها: أيّ الأزواج التّالية **غير** صحيح؟', '[{"id":"a","text":"العسل ← النّحل"},{"id":"b","text":"البيض ← الدّجاج"},{"id":"c","text":"الصّوف ← الأبقار"},{"id":"d","text":"الحليب ← الأغنام والماعز والأبقار"}]'::jsonb, 'c', 'الصّوف نحصل عليه من الأغنام لا من الأبقار؛ فالزّوج «الصّوف ← الأبقار» غير صحيح. بقيّة الأزواج صحيحة: العسل من النّحل، والبيض من الدّجاج، والحليب من الأغنام والماعز والأبقار.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1aef321f-436f-5889-933a-aec275ddae6b', '614a69d9-18ef-50a5-9084-ea865afcbd26', 'مربّي أغنام بجهة القصرين يريد أن ينشر صفة «وفرة الصّوف» لكبش (ذكر) ممتاز على أكبر عدد من النّعاج (الإناث) دون نقلها إليه. ما التّقنية؟', '[{"id":"a","text":"تحسين الإيواء"},{"id":"b","text":"التّلقيح الاصطناعي"},{"id":"c","text":"التّلقيح الطّبيعي مع نعجة واحدة"},{"id":"d","text":"تحسين التّغذية"}]'::jsonb, 'b', 'التّلقيح الاصطناعي يتيح توزيع نطاف الكبش الممتاز على عدد كبير من النّعاج دون تزاوج مباشر ودون نقلها، فتنتشر صفة وفرة الصّوف على نطاق واسع.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('56003f6e-ddf8-5ae4-b217-4dd00721d566', '614a69d9-18ef-50a5-9084-ea865afcbd26', 'مربٍّ حسّن التّغذية والإيواء والصّحّة لقطيعه فارتفع الإنتاج، ثمّ توقّف الارتفاع عند حدّ معيّن رغم زيادة العناية. ما التّفسير الأرجح؟', '[{"id":"a","text":"الظّروف الجيّدة تُخرِج أقصى ما تسمح به القدرة الموروثة للقطيع؛ لتجاوز هذا الحدّ يلزم تحسين وراثيّ (انتخاب/تلقيح اصطناعي/تهجين)"},{"id":"b","text":"الظّروف الجيّدة تغيّر المورثات بلا حدود فالتّوقّف غير منطقيّ"},{"id":"c","text":"القطيع تحوّل إلى سلالة جديدة فتوقّف الإنتاج"},{"id":"d","text":"تحسين الظّروف لا يرفع الإنتاج إطلاقًا"}]'::jsonb, 'a', 'تحسين الظّروف يرفع الإنتاج حتّى يبلغ سقف القدرة الموروثة للقطيع، ثمّ يتوقّف الارتفاع لأنّ الظّروف لا تغيّر المورثات. لتجاوز هذا السّقف يلزم تحسين الصّفات الموروثة بالتّقنيات الوراثيّة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('00312414-5a2b-5c3f-b7ee-3d6a1cdbc139', '614a69d9-18ef-50a5-9084-ea865afcbd26', 'قال تلميذ إنّ «التّهجين والانتخاب تقنيتان لجمع صفات سلالتين مختلفتين». أين الخلط؟', '[{"id":"a","text":"لا خلط، فالعبارة دقيقة"},{"id":"b","text":"الخلط أنّ التّهجين وحده يجمع صفات سلالتين مختلفتين، أمّا الانتخاب فيصطفي الأفضل داخل السّلالة الواحدة"},{"id":"c","text":"الخلط أنّ الانتخاب يجمع سلالتين والتّهجين يبقى داخل سلالة"},{"id":"d","text":"الخلط أنّ كليهما يرفع المردود دون توريث"}]'::jsonb, 'b', 'التّهجين وحده هو الّذي يزوّج سلالتين مختلفتين لجمع صفاتهما، أمّا الانتخاب فيصطفي الأفراد الأفضل **داخل السّلالة الواحدة** للتّكاثر. نسبة «جمع سلالتين» إلى الانتخاب خطأ.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1999efdb-1ef9-5ef7-968b-e0cacc58dd1c', '614a69d9-18ef-50a5-9084-ea865afcbd26', 'في مزرعة دواجن، دجاجتان: الأولى من سلالة منتخبة لكثرة البيض لكنّها في قنّ مزدحم قذر، والثّانية من سلالة عاديّة في قنّ نظيف جيّد التّهوية ومغذّاة جيّدًا. ماذا نتوقّع، وما الأفضل مبدئيًّا؟', '[{"id":"a","text":"قد لا تُظهر الأولى تفوّقها الموروث بسبب سوء الظّروف؛ والأفضل مبدئيًّا الجمع بين السّلالة المنتخبة والظّروف الجيّدة معًا"},{"id":"b","text":"الأولى ستتفوّق حتمًا لأنّ الوراثة تكفي وحدها مهما ساءت الظّروف"},{"id":"c","text":"الثّانية أفضل وراثيًّا لأنّ الظّروف تغيّر مورثاتها"},{"id":"d","text":"لا فرق أبدًا بين الحالتين"}]'::jsonb, 'a', 'الصّفة الموروثة الجيّدة لا تظهر كاملةً في ظروف سيّئة؛ فقد يتراجع تفوّق الدّجاجة المنتخبة في قنّ قذر مزدحم. والأمثل هو الجمع: سلالة منتخبة + ظروف تربية جيّدة، لأنّ الوراثة والظّروف تتكاملان. (الظّروف الجيّدة للثّانية لا تغيّر مورثاتها.)', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a6d4f385-0a64-5e79-97e2-e1cc1e443616', '614a69d9-18ef-50a5-9084-ea865afcbd26', 'أيّ سلسلة تصرّفات تمثّل خطّة متكاملة لتحسين إنتاج ضيعة أبقار حلوب على المدى الطّويل؟', '[{"id":"a","text":"تحسين التّغذية فقط دون أيّ تدخّل في التّكاثر"},{"id":"b","text":"ترك القطيع يتكاثر عشوائيًّا مع إهمال الحظيرة"},{"id":"c","text":"بيع كلّ الأبقار قليلة الإنتاج دون اختيار للتّكاثر"},{"id":"d","text":"انتخاب الأبقار الأغزر وتلقيحها اصطناعيًّا بثور منتخب، مع تحسين التّغذية والصّحّة والإيواء"}]'::jsonb, 'd', 'الخطّة المتكاملة تجمع التّقنيات الوراثيّة (انتخاب الأغزر + تلقيح اصطناعي بثور منتخب لتحسين السّلالة عبر الأجيال) مع تحسين ظروف التّربية (تغذية وصحّة وإيواء) لترجمة القدرة الموروثة إلى إنتاج فعليّ مرتفع.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1b7bd92a-132a-51cd-b333-61a6c6363921', '92b5eccd-cfb2-589e-bbf9-8b342e50ca10', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: إتقان تحسين الإنتاج الحيواني', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('3a0a0cf1-f5d4-59ed-95ed-67b4b73c9120', '1b7bd92a-132a-51cd-b333-61a6c6363921', 'أيّ مقارنة بين التّلقيح الطّبيعي والتّلقيح الاصطناعي **صحيحة**؟', '[{"id":"a","text":"الطّبيعي: تزاوج مباشر / الاصطناعي: تدخّل الإنسان بوضع نطاف ذكر منتخب في إناث كثيرة دون تزاوج"},{"id":"b","text":"الطّبيعي بلا إخصاب / الاصطناعي بإخصاب"},{"id":"c","text":"الطّبيعي ينشر صفات الذّكر على نطاق أوسع من الاصطناعي"},{"id":"d","text":"الاصطناعي يخصّ ذكرًا واحدًا وأنثى واحدة فقط"}]'::jsonb, 'a', 'التّلقيح الطّبيعي تزاوج مباشر بين ذكر وأنثى، والاصطناعي تدخّل الإنسان بوضع نطاف ذكر منتخب في إناث كثيرة دون تزاوج. كلاهما يؤدّي إلى إخصاب، والاصطناعي (لا الطّبيعي) هو الّذي ينشر صفات الذّكر على نطاق أوسع.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('85e2f90e-f732-5f47-a411-9139b4da0920', '1b7bd92a-132a-51cd-b333-61a6c6363921', 'نجح مربٍّ بالانتخاب في رفع معدّل إنتاج قطيعه من الحليب من 8 لترات إلى 15 لترًا في اليوم عبر عدّة أجيال. ما الّذي حدث حقيقةً؟', '[{"id":"a","text":"تحوّل القطيع فجأة إلى سلالة مستوردة"},{"id":"b","text":"تغيّر العلف وحده هو الّذي رفع المعدّل دون أيّ توريث"},{"id":"c","text":"تراكمت في القطيع صفات الغزارة الموروثة باصطفاء الأغزر للتّكاثر جيلًا بعد جيل"},{"id":"d","text":"ارتفع الإنتاج في يوم واحد دون علاقة بالأجيال"}]'::jsonb, 'c', 'الانتخاب رفع المعدّل بتوريث صفة الغزارة: باصطفاء الأغزر للتّكاثر جيلًا بعد جيل تتراكم الصّفات الجيّدة الموروثة في القطيع، فيرتفع المعدّل تدريجيًّا عبر الأجيال (من 8 إلى 15 لترًا)، لا في يوم واحد ولا بالعلف وحده.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2b0674cb-0469-5905-a340-1fda461920bb', '1b7bd92a-132a-51cd-b333-61a6c6363921', 'لماذا قد يفضّل مربٍّ التّهجين على الانتخاب حين تكون سلالته المحلّيّة مقاومةً للجفاف لكنّها قليلة اللّحم، ويريد الاحتفاظ بالمقاومة وزيادة اللّحم؟', '[{"id":"a","text":"لأنّ الانتخاب يغيّر التّغذية فقط"},{"id":"b","text":"لأنّ الانتخاب داخل سلالة قليلة اللّحم لا يجلب صفة جديدة من الخارج، بينما التّهجين بسلالة غزيرة اللّحم يُدخِل هذه الصّفة مع الإبقاء على المقاومة"},{"id":"c","text":"لأنّ التّهجين يبقى داخل السّلالة المحلّيّة وحدها"},{"id":"d","text":"لأنّ الانتخاب يُدخِل صفات سلالة أخرى تلقائيًّا"}]'::jsonb, 'b', 'الانتخاب يصطفي الأفضل ممّا هو موجود **داخل** السّلالة؛ فإن كانت كلّها قليلة اللّحم لا يخلق الانتخاب صفة غزارة اللّحم من العدم. أمّا التّهجين بسلالة غزيرة اللّحم فيُدخِل هذه الصّفة الجديدة مع أمل الإبقاء على مقاومة السّلالة المحلّيّة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0178672c-e3b9-5586-b918-93eaf64bfac4', '1b7bd92a-132a-51cd-b333-61a6c6363921', 'مربّيان بدآ بقطيعين متماثلين: الأوّل حسّن الظّروف فقط (تغذية/صحّة/إيواء) لعشر سنوات، والثّاني جمع تحسين الظّروف مع الانتخاب والتّلقيح الاصطناعي. ما الفرق المتوقّع بعد عدّة أجيال؟', '[{"id":"a","text":"القطيعان متطابقان وراثيًّا لأنّ الظّروف تغيّر المورثات بالتّساوي"},{"id":"b","text":"قطيع الأوّل يصير أفضل وراثيًّا لأنّ التّغذية الطّويلة تورّث الغزارة"},{"id":"c","text":"لا يتغيّر أيّ قطيع مهما فعل المربّيان"},{"id":"d","text":"قطيع الثّاني يصير أعلى قدرةً موروثة على الإنتاج، بينما يعود قطيع الأوّل إلى مستواه الأصليّ إن تراجعت الظّروف لأنّ مورثاته لم تتحسّن"}]'::jsonb, 'd', 'تحسين الظّروف يرفع المردود الآنيّ لكنّه لا يغيّر المورثات؛ فقطيع الأوّل يعود لمستواه الأصليّ إن تراجعت الظّروف. أمّا الثّاني فقد حسّن الصّفات الموروثة بالانتخاب والتّلقيح الاصطناعي عبر الأجيال، فصار أعلى قدرةً موروثة على الإنتاج.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f773c1c3-b41f-5b26-8846-1cbdb7d45781', '1b7bd92a-132a-51cd-b333-61a6c6363921', 'أيّ استنتاج يلخّص بدقّة العلاقة بين «الوراثة» و«الظّروف» في تحسين الإنتاج الحيواني؟', '[{"id":"a","text":"التّقنيات الوراثيّة ترفع سقف قدرة الحيوان، وتحسين الظّروف يقرّب الإنتاج الفعليّ من هذا السّقف؛ فالنّوعان متكاملان لا متعارضان"},{"id":"b","text":"الوراثة وحدها تحدّد الإنتاج، والظّروف لا أثر لها"},{"id":"c","text":"الظّروف وحدها تحدّد الإنتاج، والوراثة لا أثر لها"},{"id":"d","text":"الوراثة والظّروف كلتاهما تغيّران المورثات معًا"}]'::jsonb, 'a', 'التّقنيات الوراثيّة (انتخاب/تلقيح اصطناعي/تهجين) ترفع سقف القدرة الموروثة للحيوان، وتحسين الظّروف (تغذية/صحّة/إيواء) يقرّب الإنتاج الفعليّ من ذلك السّقف دون تغيير المورثات. فالنّوعان متكاملان، وهذا جوهر تحسين الإنتاج الحيواني.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('afdb280e-5438-5a19-8b87-e6807c4d342c', '1b7bd92a-132a-51cd-b333-61a6c6363921', 'اكتشف مربٍّ بقرة استثنائيّة الغزارة في قطيعه. ما التّصرّف الّذي يستغلّ صفتها الموروثة على أوسع نطاق وبأسرع ما يمكن؟', '[{"id":"a","text":"الاكتفاء بتحسين علفها وحدها دون إشراكها في التّكاثر"},{"id":"b","text":"بيعها فورًا قبل أن تتكاثر"},{"id":"c","text":"انتخابها للتّكاثر، وإن أمكن تلقيح بناتها المتفوّقات اصطناعيًّا بثور منتخب لنشر الغزارة أوسع وأسرع"},{"id":"d","text":"نقلها إلى حظيرة أوسع فقط دون أيّ تكاثر"}]'::jsonb, 'c', 'لاستغلال صفة موروثة استثنائيّة على أوسع نطاق يجب إشراك صاحبتها في التّكاثر (انتخابها)، وتسريع نشر الصّفة عبر التّلقيح الاصطناعي لنسلها المتفوّق بثور منتخب. أمّا تحسين علفها وحدها أو نقلها فلا يوريّث صفتها، وبيعها يُضيّعها.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f00b7066-a233-5fb2-b1f6-64165b830c3e', 'ce3663d1-42ee-5b19-968c-75d46a1ea5c3', 'sciences-vie-terre-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('affaebbc-91c5-5548-9280-22bf2de964b8', 'f00b7066-a233-5fb2-b1f6-64165b830c3e', 'ممّ يتكوّن النظام البيئي؟', '[{"id":"a","text":"من الوسط غير الحيّ ومجموعة الكائنات الحيّة معًا"},{"id":"b","text":"من الكائنات الحيّة وحدها دون وسطها"},{"id":"c","text":"من التربة والماء والهواء فقط دون كائنات"},{"id":"d","text":"من النباتات الخضراء فقط"}]'::jsonb, 'a', 'النظام البيئي وحدة تجمع بين مكوّنَين لا ينفصلان: الوسط غير الحيّ (تربة، ماء، ضوء، حرارة، ملوحة) ومجموعة الكائنات الحيّة التي تتفاعل فيه.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9ff03a8a-8813-5327-a8b8-76759e27a367', 'f00b7066-a233-5fb2-b1f6-64165b830c3e', 'في النظام البيئي، أيّ حلقة تصنع مادّتها العضوية بنفسها؟', '[{"id":"a","text":"المستهلك الأوّل"},{"id":"b","text":"المنتِج"},{"id":"c","text":"المستهلك الثاني"},{"id":"d","text":"المحلِّل"}]'::jsonb, 'b', 'المنتِج نبتة خضراء تصنع مادّتها العضوية بنفسها من الماء والأملاح المعدنية والضوء، ولهذا تبدأ به كلّ سلسلة غذائية.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d64d25c1-d3e7-56e5-a9e2-ea76eedc90f2', 'f00b7066-a233-5fb2-b1f6-64165b830c3e', 'في سلسلة زيتون → عثّة، ماذا يعني السهم (→) بين الكائنَين؟', '[{"id":"a","text":"الزيتون يأكل العثّة"},{"id":"b","text":"لا علاقة غذائية بينهما"},{"id":"c","text":"الزيتون يُؤكل من طرف العثّة"},{"id":"d","text":"العثّة والزيتون منتِجان معًا"}]'::jsonb, 'c', 'معنى السهم ثابت هو «يُؤكل من طرف»: زيتون → عثّة تعني أنّ الزيتون هو المأكول والعثّة هي الآكلة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5912c721-2670-5584-80f0-e7f902b3a834', 'f00b7066-a233-5fb2-b1f6-64165b830c3e', 'ما الذي يميّز الشبكة الغذائية عن السلسلة الغذائية المفردة؟', '[{"id":"a","text":"الشبكة لا تضمّ محلِّلات إطلاقًا"},{"id":"b","text":"الشبكة سلسلة واحدة مستقيمة لا تتفرّع أبدًا"},{"id":"c","text":"الشبكة تبدأ بمستهلك لا بمنتِج"},{"id":"d","text":"الشبكة تشابك عدّة سلاسل يشترك بعضها في حلقات مشتركة"}]'::jsonb, 'd', 'الشبكة الغذائية تشابك عدّة سلاسل غذائية في نظام واحد، لأنّ الكائن الواحد قد ينتمي إلى أكثر من سلسلة (يأكل عدّة فرائس ويأكله عدّة مفترسين).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1937bc57-9bc1-5101-967d-cddb93668959', 'f00b7066-a233-5fb2-b1f6-64165b830c3e', 'لو جفّف الإنسان سبخة وبنى عليها، ما الأثر المتوقّع على النظام البيئي فيها؟', '[{"id":"a","text":"يفقد الطيور والكائنات ملجأها فيختلّ التوازن وقد تنقرض أنواع"},{"id":"b","text":"تزداد أعداد الطيور المهاجرة فيها"},{"id":"c","text":"يبقى النظام كما هو دون أيّ تغيير"},{"id":"d","text":"تتحوّل الكائنات إلى محلِّلات تحمي الوسط"}]'::jsonb, 'a', 'تجفيف السبخة يهدم وسطها المائي المالح فيحرم كائناتها والطيور المهاجرة من ملجئها، فيختلّ التوازن الطبيعي وقد تنقرض أنواع.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('63baf174-368c-5650-85e3-f333aacfcea0', 'ce3663d1-42ee-5b19-968c-75d46a1ea5c3', 'sciences-vie-terre-8eme', '⭐ تمرين: النظم البيئية والتوازن الطبيعي', 1, 50, 10, 'practice', 'admin', 1)
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
  ('ec811fe5-31b0-5674-a446-c05e75bf99e1', '63baf174-368c-5650-85e3-f333aacfcea0', 'أيّ العناصر التالية من المكوّنات غير الحيّة (الوسط) في النظام البيئي؟', '[{"id":"a","text":"شجرة الزيتون"},{"id":"b","text":"درجة ملوحة الماء"},{"id":"c","text":"طائر النحام"},{"id":"d","text":"جراثيم التربة"}]'::jsonb, 'b', 'درجة ملوحة الماء عامل غير حيّ من مكوّنات الوسط، أمّا الزيتون والنحام والجراثيم فكائنات حيّة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4bff6b03-ee5c-5c23-9c59-f6aac9ef3f7b', '63baf174-368c-5650-85e3-f333aacfcea0', 'في نظام بستان الزيتون، إلى أيّ حلقة تنتمي شجرة الزيتون؟', '[{"id":"a","text":"مستهلك أوّل"},{"id":"b","text":"محلِّل"},{"id":"c","text":"منتِج"},{"id":"d","text":"مستهلك ثانٍ"}]'::jsonb, 'c', 'شجرة الزيتون نبتة خضراء تصنع مادّتها العضوية بنفسها، فهي منتِج في هذا النظام البيئي.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e1458d9f-5952-575b-8138-5e5aa4ec0ae4', '63baf174-368c-5650-85e3-f333aacfcea0', 'في الواد، تأكل يرقة طحالبَ خضراء. إلى أيّ حلقة تنتمي اليرقة؟', '[{"id":"a","text":"منتِج"},{"id":"b","text":"محلِّل"},{"id":"c","text":"مستهلك ثانٍ"},{"id":"d","text":"مستهلك أوّل"}]'::jsonb, 'd', 'اليرقة تتغذّى مباشرة على الطحالب (المنتِج)، فهي مستهلك أوّل في هذه السلسلة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9d2ce771-a035-5021-a44d-32925b0b01ea', '63baf174-368c-5650-85e3-f333aacfcea0', 'في سلسلة طحالب → سمكة صغيرة، ماذا يعني السهم (→)؟', '[{"id":"a","text":"الطحالب تُؤكل من طرف السمكة الصغيرة"},{"id":"b","text":"لا علاقة غذائية بينهما"},{"id":"c","text":"الطحالب تأكل السمكة الصغيرة"},{"id":"d","text":"السمكة الصغيرة منتِج مثل الطحالب"}]'::jsonb, 'a', 'معنى السهم ثابت هو «يُؤكل من طرف»: طحالب → سمكة صغيرة تعني أنّ الطحالب هي المأكولة والسمكة هي الآكلة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('41da8dd1-f941-5071-b1a5-0e85c8d7d433', '63baf174-368c-5650-85e3-f333aacfcea0', 'أيّ كائنات حيّة تُسمّى محلِّلات في النظام البيئي؟', '[{"id":"a","text":"النباتات الخضراء"},{"id":"b","text":"جراثيم وفطريات التربة"},{"id":"c","text":"الحيوانات اللاحمة الكبيرة"},{"id":"d","text":"الطيور المهاجرة"}]'::jsonb, 'b', 'المحلِّلات كائنات مجهرية في التراب، أهمّها الجراثيم والفطريات، وهي التي تحوّل المادّة العضوية الميّتة إلى أملاح معدنية.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6084aa67-3e9b-5af9-b7e8-bacdef624407', '63baf174-368c-5650-85e3-f333aacfcea0', 'ماذا ينتج المحلِّل من تحويله للمادّة العضوية الميّتة؟', '[{"id":"a","text":"مادّة عضوية جديدة يأكلها بنفسه"},{"id":"b","text":"أكسجين فقط"},{"id":"c","text":"أملاح معدنية تعود إلى التراب"},{"id":"d","text":"ضوءًا وحرارة"}]'::jsonb, 'c', 'يحوّل المحلِّل المادّة العضوية الميّتة إلى أملاح معدنية تعود إلى التراب، فتمتصّها جذور المنتِجات من جديد.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c650da8f-9831-56a7-95d5-0987d02dca32', 'ce3663d1-42ee-5b19-968c-75d46a1ea5c3', 'sciences-vie-terre-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: النظم البيئية والتوازن الطبيعي', 3, 120, 30, 'boss', 'admin', 2)
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
  ('71e8364a-0b06-535e-904a-b4513d139cf9', 'c650da8f-9831-56a7-95d5-0987d02dca32', 'قال تلميذ: «النظام البيئي في غابة الفلّين هو مجموع الأشجار والحيوانات فقط.» ما الناقص في تعريفه؟', '[{"id":"a","text":"لا شيء ناقص، فالتعريف كامل"},{"id":"b","text":"ينقصه ذكر أنّ الغابة لا تضمّ محلِّلات"},{"id":"c","text":"ينقصه الوسط غير الحيّ (التربة، الرطوبة، الضوء، الحرارة)"},{"id":"d","text":"ينقصه أنّ الحيوانات ليست جزءًا من النظام"}]'::jsonb, 'c', 'النظام البيئي = وسط غير حيّ + كائنات حيّة؛ فقصْره على الكائنات وحدها يُسقط الوسط (تربة، رطوبة، ضوء، حرارة) الذي يحدّد أيّ الكائنات تعيش هناك.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b5701cfa-43c1-575b-ab6c-03b8189e0755', 'c650da8f-9831-56a7-95d5-0987d02dca32', 'في نظام السبخة: قطف ملحي → قشريات → طائر النحام. إذا صنّف تلميذ القشريات على أنّها منتِج، فأين خطؤه؟', '[{"id":"a","text":"لا خطأ، فالقشريات منتِج فعلًا"},{"id":"b","text":"القشريات محلِّل لا منتِج"},{"id":"c","text":"القشريات مستهلك ثانٍ لأنّها تأكل النحام"},{"id":"d","text":"القشريات مستهلك أوّل لأنّها تأكل القطف (المنتِج) ولا تصنع غذاءها"}]'::jsonb, 'd', 'القشريات لا تصنع غذاءها بنفسها بل تتغذّى على القطف الملحي (المنتِج)، فهي مستهلك أوّل؛ المنتِج هنا هو نبات القطف وحده.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('21d5c623-da1a-528d-9bdc-3e44c6b3e10c', 'c650da8f-9831-56a7-95d5-0987d02dca32', 'في بستان الزيتون يأكل العصفور العثّاتِ والديدانَ، وتفترسه البومة، وتفترس البومة أيضًا فئرانًا تأكل بذور الزيتون. أيّ استنتاج صحيح؟', '[{"id":"a","text":"هذه شبكة غذائية لأنّ عدّة سلاسل تتشابك في حلقات مشتركة كالبومة"},{"id":"b","text":"هذه سلسلة غذائية واحدة مستقيمة فقط"},{"id":"c","text":"لا توجد أيّ علاقة غذائية بين هذه الكائنات"},{"id":"d","text":"البومة منتِج لأنّها تقع في قمّة الشبكة"}]'::jsonb, 'a', 'تشابك سلسلتَين أو أكثر تشتركان في حلقات (البومة تفترس العصفور والفأر معًا) يكوّن شبكة غذائية، لا سلسلة مفردة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('500052be-c418-5802-ba9a-2bf0ff78f5ec', 'c650da8f-9831-56a7-95d5-0987d02dca32', 'ماتت شجرة زيتون في البستان. أيّ مسار صحيح لمصير مادّتها العضوية حتى تصبح غذاءً معدنيًّا لزيتونة جديدة؟', '[{"id":"a","text":"الشجرة الميّتة تتحوّل تلقائيًّا دون وسيط إلى زيتونة جديدة"},{"id":"b","text":"الشجرة الميّتة → تحلّلها الجراثيم والفطريات → أملاح معدنية في التراب → تمتصّها جذور زيتونة جديدة"},{"id":"c","text":"الشجرة الميّتة → تفترسها البومة → أملاح معدنية مباشرة"},{"id":"d","text":"الشجرة الميّتة تبقى كما هي إلى الأبد دون دور للمحلِّلات"}]'::jsonb, 'b', 'المحلِّلات وحدها تحوّل الخشب الميّت إلى أملاح معدنية في التراب، تمتصّها جذور زيتونة جديدة لتصنع مادّة عضوية بالتركيب الضوئي.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b50efb35-d4f0-57f1-a7ad-db9fa68b0582', 'c650da8f-9831-56a7-95d5-0987d02dca32', 'أيّ العبارات التالية بخصوص المحلِّلات **خاطئة**؟', '[{"id":"a","text":"المحلِّلات تحوّل المادّة العضوية الميّتة إلى أملاح معدنية"},{"id":"b","text":"من المحلِّلات جراثيم التربة وفطرياتها"},{"id":"c","text":"المحلِّلات تفترس المستهلك الثالث وهو حيّ لتنهي به الشبكة"},{"id":"d","text":"بفضل المحلِّلات تعود المادّة أملاحًا يمتصّها المنتِج"}]'::jsonb, 'c', 'العبارة الخاطئة أنّ المحلِّل يفترس كائنًا حيًّا؛ فهو لا يفترس شيئًا حيًّا بل يتغذّى فقط على البقايا والفضلات الميّتة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('77f3e415-3508-5341-a681-95fada53e170', 'c650da8f-9831-56a7-95d5-0987d02dca32', 'في نظام الواد: طحالب → سمك صغير → ضفدع → مالك الحزين. لو صاد الإنسان مالك الحزين بكثرة حتى ندر، فما الأثر المتسلسل المتوقّع أوّلًا على الضفادع ثمّ على السمك الصغير؟', '[{"id":"a","text":"تتحوّل الضفادع إلى منتِجات فتغني الواد"},{"id":"b","text":"تتناقص الضفادع فيزدهر السمك الصغير بلا حدّ"},{"id":"c","text":"لا يتأثّر أيّ منهما إطلاقًا"},{"id":"d","text":"تتكاثر الضفادع لغياب مفترسها، فتلتهم السمك الصغير فيتناقص"}]'::jsonb, 'd', 'بندرة مالك الحزين (مفترس الضفادع) تتكاثر الضفادع دون رادع، فتفترس السمك الصغير بكثرة فيتناقص؛ أثرٌ متسلسل عبر حلقتَين يختلّ به توازن الواد.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e618ef9a-ce64-5db9-8ba4-080994161307', 'ce3663d1-42ee-5b19-968c-75d46a1ea5c3', 'sciences-vie-terre-8eme', '⭐⭐ تمرين مراجعة (نمط امتحان): النظم البيئية والتوازن الطبيعي', 2, 70, 15, 'practice', 'admin', 3)
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
  ('23525484-d92e-5e95-ad04-6691bbd49853', 'e618ef9a-ce64-5db9-8ba4-080994161307', 'أيّ تعريف يصف النظام البيئي وصفًا صحيحًا؟', '[{"id":"a","text":"حيوان واحد يعيش منعزلًا"},{"id":"b","text":"مجموعة نباتات خضراء فقط"},{"id":"c","text":"تربة وماء وهواء دون أيّ كائن حيّ"},{"id":"d","text":"وسط غير حيّ ومجموعة كائنات حيّة تتفاعل فيما بينها ومع وسطها"}]'::jsonb, 'd', 'النظام البيئي يجمع الوسط غير الحيّ ومجموعة الكائنات الحيّة التي تتفاعل معه ومع بعضها؛ لا يُختزل في الكائنات ولا في الوسط وحده.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9acf1d3c-8d72-5ff9-86cb-5b9aeaefadc3', 'e618ef9a-ce64-5db9-8ba4-080994161307', 'في سلسلة قطف ملحي → قشريات → طائر النحام، أيّ كائن هو المستهلك الثاني؟', '[{"id":"a","text":"طائر النحام"},{"id":"b","text":"القشريات"},{"id":"c","text":"القطف الملحي"},{"id":"d","text":"لا يوجد مستهلك ثانٍ"}]'::jsonb, 'a', 'النحام يأكل القشريات (وهي مستهلك أوّل يأكل المنتِج)، فيكون النحام مستهلكًا ثانيًا في هذه السلسلة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('083b375f-d3b5-5863-aa13-911f75e90e6d', 'e618ef9a-ce64-5db9-8ba4-080994161307', 'لماذا تبدأ كلّ سلسلة غذائية بمنتِج؟', '[{"id":"a","text":"لأنّ المنتِج أكبر الكائنات حجمًا دائمًا"},{"id":"b","text":"لأنّ المنتِج وحده يصنع المادّة العضوية بنفسه فيغذّي بقيّة الحلقات"},{"id":"c","text":"لأنّ المنتِج يفترس المستهلكات"},{"id":"d","text":"لأنّ المنتِج يحلّل البقايا الميّتة"}]'::jsonb, 'b', 'المنتِج (النبتة الخضراء) هو الكائن الوحيد القادر على صنع مادّة عضوية من مادّة معدنية وضوء، فمنه تنطلق كلّ سلسلة، مهما كان حجمه.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a7c504e0-6930-52e1-8f60-07880778379a', 'e618ef9a-ce64-5db9-8ba4-080994161307', 'أيّ العلاقتَين التاليتَين تمثّل «تنافسًا» بين كائنَين؟', '[{"id":"a","text":"بومة تفترس عصفورًا"},{"id":"b","text":"فطر يحلّل ورقة ميّتة"},{"id":"c","text":"عصفوران يتزاحمان على الحشرات نفسها في البستان"},{"id":"d","text":"طحلب يصنع غذاءه بالضوء"}]'::jsonb, 'c', 'التنافس تزاحم كائنَين على المورد نفسه (الغذاء أو المكان)؛ عصفوران يتزاحمان على الحشراتِ نفسها مثالٌ عليه، بخلاف الافتراس (آكل ومأكول).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('47435d3f-e093-5dc8-9131-c8aac5154cee', 'e618ef9a-ce64-5db9-8ba4-080994161307', 'ما معنى أن يكون النظام البيئي في «توازن طبيعي»؟', '[{"id":"a","text":"توقّف كلّ الكائنات عن التكاثر نهائيًّا"},{"id":"b","text":"أن يصبح كلّ الكائنات منتِجات"},{"id":"c","text":"اختفاء المحلِّلات من الوسط"},{"id":"d","text":"استقرار نسبيّ لأعداد المنتِجات والمستهلكات والمحلِّلات دون انهيار"}]'::jsonb, 'd', 'التوازن الطبيعي استقرار نسبيّ: تتذبذب أعداد الكائنات قليلًا لكنّها لا تنهار، ما دامت الحلقات الثلاث متكافئة تحفظها العلاقات الغذائية.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('89eeca08-f7c7-5069-baae-fff4f8477e08', 'e618ef9a-ce64-5db9-8ba4-080994161307', 'أيّ نشاط بشريّ يساعد على حماية النظام البيئي لا على الإخلال به؟', '[{"id":"a","text":"إنشاء محميّة طبيعية وترشيد الصيد"},{"id":"b","text":"الصيد المفرط دون احترام مواسم التكاثر"},{"id":"c","text":"صبّ الفضلات الكيميائية في الواد"},{"id":"d","text":"تجفيف السبخة والبناء عليها"}]'::jsonb, 'a', 'إنشاء المحميّات وترشيد الصيد من سبل حماية البيئة، بخلاف التلوّث والصيد المفرط وتجفيف السباخ التي تخلّ بالتوازن الطبيعي.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c68138e2-b488-5d1f-b004-75ce7e53f1d1', 'ce3663d1-42ee-5b19-968c-75d46a1ea5c3', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: النظم البيئية والتوازن الطبيعي', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('c5f2823f-df2a-5b5f-9a44-6ef2d8c3ad38', 'c68138e2-b488-5d1f-b004-75ce7e53f1d1', 'كتب باحث أنّ نظام غابة الفلّين البيئي يشمل: بلّوط الفلّين، يرقات تأكل أوراقه، عصافير تأكل اليرقات، ابن آوى يأكل العصافير، وجراثيم التربة. عند رسم شبكة هذا النظام، أيّ ترتيب صحيح للحلقات من المنتِج إلى أعلى مستهلك؟', '[{"id":"a","text":"بلّوط الفلّين (منتِج) → يرقة (مستهلك أوّل) → عصفور (مستهلك ثانٍ) → ابن آوى (مستهلك ثالث)"},{"id":"b","text":"ابن آوى (منتِج) → عصفور → يرقة → بلّوط الفلّين"},{"id":"c","text":"بلّوط الفلّين (مستهلك أوّل) → يرقة (منتِج) → عصفور → ابن آوى"},{"id":"d","text":"جراثيم التربة (منتِج) → بلّوط → يرقة → عصفور"}]'::jsonb, 'a', 'تبدأ السلسلة بالمنتِج (بلّوط الفلّين يصنع غذاءه)، ثمّ من يأكله مستهلك أوّل (يرقة)، فمن يأكل اليرقة مستهلك ثانٍ (عصفور)، فمن يأكل العصفور مستهلك ثالث (ابن آوى)؛ والجراثيم محلِّل خارج هذا الترتيب.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e095f648-bd65-5ad0-926a-defccfe3b04f', 'c68138e2-b488-5d1f-b004-75ce7e53f1d1', 'في نظام السبخة، تشترك سلسلتان في طائر النحام: قطف ملحي → قشريات → نحام، وأيضًا طحالب → يرقات مائية → نحام. لو انقرضت القشريات وحدها، لماذا قد يصمد النحام مع ذلك؟', '[{"id":"a","text":"لأنّ النحام منتِج يصنع غذاءه بنفسه"},{"id":"b","text":"لأنّ الشبكة توفّر له فريسة بديلة (اليرقات المائية) في سلسلة أخرى مشتركة"},{"id":"c","text":"لأنّ النحام يتحوّل إلى محلِّل عند نقص الغذاء"},{"id":"d","text":"لأنّ انقراض القشريات يزيد أعداد النحام مباشرة"}]'::jsonb, 'b', 'متانة الشبكة الغذائية أنّ حلقة مشتركة (النحام) تتغذّى عبر أكثر من سلسلة؛ فبفقد القشريات يبقى له مصدر بديل (اليرقات المائية)، بخلاف سلسلة مفردة ينهار أعلاها بفقد حلقة واحدة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e034d6aa-232d-53dc-92ce-d43c4cc32c8b', 'c68138e2-b488-5d1f-b004-75ce7e53f1d1', 'استنتج تلميذ: «ما دام النحام يجد فريسة بديلة في الشبكة، فلا خطر على أيّ نظام بيئي مهما فعل الإنسان.» أين الخطأ في تعميمه؟', '[{"id":"a","text":"لا خطأ، فالشبكة تحمي النظام من كلّ خطر دائمًا"},{"id":"b","text":"الخطأ أنّ الشبكة لا تضمّ إلّا سلسلة واحدة"},{"id":"c","text":"الخطأ أنّ متانة الشبكة محدودة: إتلاف الوسط نفسه (تجفيف السبخة) أو فقد المنتِج القاعديّ يهدم النظام رغم البدائل"},{"id":"d","text":"الخطأ أنّ النحام لا يأكل القشريات إطلاقًا"}]'::jsonb, 'c', 'البدائل تحمي من فقد حلقة واحدة، لكنّها لا تحمي من هدم الوسط ذاته (تجفيف السبخة) أو زوال المنتِج الذي تقوم عليه كلّ السلاسل؛ فمتانة الشبكة نسبيّة لا مطلقة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cf0b1837-3380-5bc5-bef7-647ef17f1fe3', 'c68138e2-b488-5d1f-b004-75ce7e53f1d1', 'في الواد: طحالب → سمك صغير → ضفدع → مالك الحزين، ومحلِّلات في القاع. لو تسبّب تلوّث كيميائي في موت الطحالب كلّها، فما التسلسل الأرجح لانهيار النظام؟', '[{"id":"a","text":"لا يتأثّر أحد لأنّ المحلِّلات تعوّض الطحالب"},{"id":"b","text":"يزدهر السمك الصغير أوّلًا ثمّ الضفادع ثمّ مالك الحزين"},{"id":"c","text":"تتحوّل الطحالب الميّتة مباشرة إلى مالك حزين جديد"},{"id":"d","text":"يجوع السمك الصغير لفقد غذائه، فتقلّ الضفادع، فيندر مالك الحزين، وتنشط المحلِّلات على الجثث"}]'::jsonb, 'd', 'بزوال المنتِج القاعديّ (الطحالب) ينهار ما فوقه بالترتيب: يجوع السمك الصغير فيقلّ، فتقلّ الضفادع، فيندر مالك الحزين؛ وتنشط المحلِّلات على الجثث لكنّها لا تصنع غذاءً بديلًا عن المنتِج.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('19f311cf-bb34-5c64-8cf0-fee2f9866a6f', 'c68138e2-b488-5d1f-b004-75ce7e53f1d1', 'أيّ العبارات التالية عن التوازن الطبيعي وتأثير الإنسان **خاطئة**؟', '[{"id":"a","text":"حماية نوع واحد فقط تكفي لضمان توازن النظام كلّه مهما لوّثنا وسطه"},{"id":"b","text":"الصيد المفرط لمفترسٍ قد يفجّر أعداد فريسته فتستنزف المنتِج"},{"id":"c","text":"التوازن الطبيعي استقرار نسبيّ لا ثبات جامد لأعداد الكائنات"},{"id":"d","text":"تجفيف المناطق الرطبة يحرم الطيور المهاجرة من ملجئها"}]'::jsonb, 'a', 'العبارة الخاطئة أنّ حماية نوع واحد تكفي: التوازن يقوم على الحلقات مجتمعة ووسطها؛ فتلويث الوسط أو فقد حلقات أخرى يخلّ بالنظام مهما حمينا نوعًا واحدًا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f1f6e72e-4489-5a22-852c-36737c380956', 'c68138e2-b488-5d1f-b004-75ce7e53f1d1', 'وصف باحث نظامًا بيئيًّا فيه: نبتة تصنع غذاءها من الضوء، حيوان يأكلها، حيوان ثانٍ يفترس الأوّل، وكائنات مجهرية تحلّل بقايا الجميع إلى أملاح. كم عدد المستهلكات، وهل تُحسب الكائنات المجهرية منها؟', '[{"id":"a","text":"ثلاثة مستهلكين، والكائنات المجهرية منها"},{"id":"b","text":"مستهلكان اثنان، والكائنات المجهرية محلِّلات لا تُحسب مستهلكات"},{"id":"c","text":"مستهلك واحد فقط، والكائنات المجهرية مستهلك ثانٍ"},{"id":"d","text":"لا يوجد أيّ مستهلك في هذا الوصف"}]'::jsonb, 'b', 'الوصف فيه منتِج واحد، ومستهلك أوّل (يأكل النبتة)، ومستهلك ثانٍ (يفترس الأوّل) = مستهلكان؛ أمّا الكائنات المجهرية فمحلِّلات تتغذّى على البقايا الميّتة ولا تُحسب مستهلكات.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f0b8dfb1-d3bc-591f-a378-e8fb3d818b52', 'ce3663d1-42ee-5b19-968c-75d46a1ea5c3', 'sciences-vie-terre-8eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): النظم البيئية والتوازن الطبيعي', 3, 120, 30, 'boss', 'admin', 5)
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
  ('faa3b10e-c515-506d-a0a4-87f39d57c7e8', 'f0b8dfb1-d3bc-591f-a378-e8fb3d818b52', 'لماذا يُعدّ عاملا الحرارة والملوحة جزءًا من النظام البيئي للسبخة، لا مجرّد ظروف خارجية عنه؟', '[{"id":"a","text":"لأنّهما كائنان حيّان ينتِجان الغذاء"},{"id":"b","text":"لأنّهما من مكوّنات الوسط غير الحيّ التي تحدّد أيّ الكائنات تعيش هناك"},{"id":"c","text":"لأنّهما محلِّلان يفكّكان البقايا"},{"id":"d","text":"لأنّهما لا يؤثّران في الكائنات إطلاقًا"}]'::jsonb, 'b', 'الحرارة والملوحة من المكوّنات غير الحيّة للوسط، وهي جزء أصيل من النظام البيئي لأنّها تحدّد الكائنات القادرة على العيش فيه (نبات القطف الملحي مثلًا).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('37a0a0d1-3302-53bf-88bf-2610fa3897fa', 'f0b8dfb1-d3bc-591f-a378-e8fb3d818b52', 'في بستان الزيتون، أيّ ترتيب سلسلة غذائية صحيح باتّجاه سهم «يُؤكل من طرف»؟', '[{"id":"a","text":"بومة → عصفور → عثّة → زيتون"},{"id":"b","text":"عثّة → زيتون → بومة → عصفور"},{"id":"c","text":"زيتون → عثّة → عصفور → بومة"},{"id":"d","text":"عصفور → بومة → زيتون → عثّة"}]'::jsonb, 'c', 'السلسلة تبدأ بالمنتِج (زيتون) والسهم يعني «يُؤكل من طرف»: زيتون يُؤكل من طرف العثّة، والعثّة من طرف العصفور، والعصفور من طرف البومة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1c0a75e0-fd0d-5018-a8e0-48b7cf4393fb', 'f0b8dfb1-d3bc-591f-a378-e8fb3d818b52', 'لماذا لا يُحسب المحلِّل مستهلكًا رابعًا في نهاية السلسلة، رغم أنّه «يتغذّى» على الكائنات؟', '[{"id":"a","text":"لأنّه يصنع غذاءه بنفسه كالمنتِج"},{"id":"b","text":"لأنّه أكبر الكائنات حجمًا"},{"id":"c","text":"لأنّه لا يتغذّى إطلاقًا"},{"id":"d","text":"لأنّه لا يفترس كائنًا حيًّا بل يحلّل البقايا الميّتة إلى أملاح معدنية"}]'::jsonb, 'd', 'المستهلك يفترس كائنًا حيًّا، أمّا المحلِّل فيتغذّى على البقايا الميّتة فقط ويعيدها أملاحًا معدنية؛ فدوره مختلف عن حلقات الاستهلاك ولا يُعدّ مستهلكًا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0a1febed-2191-5249-a28d-edc1baf7f2a5', 'f0b8dfb1-d3bc-591f-a378-e8fb3d818b52', 'في نظام الواد يفترس مالك الحزين الضفادعَ والأسماك الصغيرة معًا، وتفترس الأفعى الضفادع أيضًا. ما نوع العلاقة بين مالك الحزين والأفعى تجاه الضفادع؟', '[{"id":"a","text":"تنافس بينهما على الفريسة نفسها (الضفادع)"},{"id":"b","text":"افتراس مالك الحزين للأفعى"},{"id":"c","text":"تحليل مشترك للبقايا"},{"id":"d","text":"لا توجد بينهما أيّ علاقة"}]'::jsonb, 'a', 'حين يعتمد مفترسان على الفريسة نفسها (الضفادع) تنشأ بينهما علاقة تنافس على المورد الغذائي المشترك، لا افتراس أحدهما للآخر.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('91cde1fa-56ec-5344-9194-b2a68e2f4629', 'f0b8dfb1-d3bc-591f-a378-e8fb3d818b52', 'بنى الإنسان مصنعًا يصبّ فضلاته في واد فماتت طحالبه. أيّ تفسير يربط هذا التلوّث باختلال التوازن الطبيعي ربطًا صحيحًا؟', '[{"id":"a","text":"لا علاقة، فموت الطحالب لا يؤثّر في بقيّة الكائنات"},{"id":"b","text":"بموت المنتِج القاعديّ ينهار غذاء كلّ الحلقات فوقه، فتتناقص الأسماك والضفادع والطيور تباعًا"},{"id":"c","text":"موت الطحالب يزيد الأكسجين فيزدهر النظام"},{"id":"d","text":"التلوّث يحوّل الأسماك إلى منتِجات بديلة"}]'::jsonb, 'b', 'الطحالب منتِج قاعديّ تقوم عليه كلّ السلاسل؛ فبموتها بالتلوّث ينهار الغذاء صعودًا (سمك، ضفادع، طيور)، وهو اختلال مباشر للتوازن الطبيعي بيد الإنسان.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('588b1bb2-b2e9-5d73-9c1f-a56271f1fd4f', 'f0b8dfb1-d3bc-591f-a378-e8fb3d818b52', 'أيّ مجموعة إجراءات كلّها تصبّ في حماية الأنظمة البيئية؟', '[{"id":"a","text":"صبّ الفضلات + البناء على السباخ + الصيد في موسم التكاثر"},{"id":"b","text":"الصيد المفرط + قطع الأشجار + تجفيف السباخ"},{"id":"c","text":"ترشيد الصيد + التشجير + حماية المناطق الرطبة + رسكلة النفايات"},{"id":"d","text":"التلوّث الكيميائي + إتلاف الغابات + قتل المفترسات كلّها"}]'::jsonb, 'c', 'ترشيد الصيد والتشجير وحماية المناطق الرطبة ورسكلة النفايات كلّها إجراءات حماية؛ أمّا البقيّة فأنشطة إخلال تهدّد التوازن الطبيعي وتسبّب انقراض الأنواع.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('5953f81c-ea4c-5752-ba12-36bfc5b11dbc', 'ce3663d1-42ee-5b19-968c-75d46a1ea5c3', 'sciences-vie-terre-8eme', '🔥 تحدّي النخبة المطلق ⭐⭐⭐⭐: النظم البيئية والتوازن الطبيعي', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('a938aeb2-9f45-5427-83e1-bab1d79d1f98', '5953f81c-ea4c-5752-ba12-36bfc5b11dbc', 'درس باحث شبكة نظام السبخة: القطف الملحي يُؤكل من طرف القشريات واليرقات المائية، وكلاهما يُؤكل من طرف النحام، والنحام تُحلّل بقاياه جراثيمُ التربة فتعود أملاحًا يمتصّها القطف. أيّ استنتاج يجمع أدوار الحلقات جمعًا صحيحًا؟', '[{"id":"a","text":"الجراثيم منتِج، والنحام مستهلك أوّل، والقطف محلِّل، والقشريات مستهلك ثانٍ"},{"id":"b","text":"القطف مستهلك أوّل، والقشريات منتِج، والنحام محلِّل، والجراثيم مستهلك ثانٍ"},{"id":"c","text":"القطف منتِج، والقشريات واليرقات مستهلكات أُولى، والنحام مستهلك ثانٍ، والجراثيم محلِّل يغلق الدورة إلى القطف"},{"id":"d","text":"كلّ الكائنات منتِجات لأنّها تعيش في السبخة نفسها"}]'::jsonb, 'c', 'القطف يصنع غذاءه = منتِج؛ ما يأكله مباشرة (قشريات ويرقات) = مستهلكات أُولى؛ ما يأكلها (النحام) = مستهلك ثانٍ؛ والجراثيم تحلّل البقايا إلى أملاح يمتصّها القطف فتُغلق دورة المادّة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('673fdb2a-da4f-5f58-aca5-d32abcb074f8', '5953f81c-ea4c-5752-ba12-36bfc5b11dbc', 'استنتج تلميذ: «بما أنّ المحلِّلات تعيد المادّة العضوية أملاحًا معدنية، فبإمكانها أن تعوّض المنتِج، ويستغني النظام عن النباتات الخضراء.» أين مكمن الخطأ؟', '[{"id":"a","text":"لا خطأ، فالمحلِّل يعوّض المنتِج فعلًا"},{"id":"b","text":"النباتات الخضراء مستهلكات لا يحتاجها النظام"},{"id":"c","text":"المحلِّل يفترس النباتات فيغني عنها"},{"id":"d","text":"المحلِّل ينتج أملاحًا معدنية فقط، ولا يصنع مادّة عضوية؛ فالمنتِج وحده يحوّل المعدنيّ إلى عضويّ يغذّي الشبكة"}]'::jsonb, 'd', 'المحلِّل يوقف عند إنتاج الأملاح المعدنية، والمنتِج وحده يحوّل هذه الأملاح إلى مادّة عضوية بالتركيب الضوئي؛ فبدون منتِج لا مصدر للمادّة العضوية وتنهار الشبكة كلّها.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('386b1948-b165-5be3-9331-d85abfe42da2', '5953f81c-ea4c-5752-ba12-36bfc5b11dbc', 'في نظامَي بستان الزيتون والواد، أُدخل مبيد قتل الحشرات كلّها (عثّات ويرقات). ما الأثر المتسلسل الأرجح على العصافير ثمّ على البوم أو مالك الحزين؟', '[{"id":"a","text":"يجوع أكلة الحشرات (العصافير) فتتناقص، فيقلّ غذاء المفترسات العليا (البوم/مالك الحزين) فتندر بدورها"},{"id":"b","text":"لا يتأثّر أحد لأنّ الحشرات ليست حلقة مهمّة"},{"id":"c","text":"تزدهر العصافير لكثرة الغذاء، فتزدهر معها المفترسات العليا"},{"id":"d","text":"تتحوّل الحشرات الميّتة إلى منتِجات تغذّي العصافير"}]'::jsonb, 'a', 'قتل المستهلكات الأُولى (الحشرات) يحرم العصافير (مستهلكها) من الغذاء فتتناقص، فيقلّ بدوره غذاء المفترسات العليا فتندر؛ أثرٌ متسلسل صاعد يختلّ به توازن النظامَين.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0db3dcfc-f0e3-5982-91cf-29dd98b03950', '5953f81c-ea4c-5752-ba12-36bfc5b11dbc', 'أيّ العبارات التالية عن الفرق بين السلسلة والشبكة الغذائية **خاطئة**؟', '[{"id":"a","text":"الشبكة تشابك عدّة سلاسل تشترك في بعض حلقاتها"},{"id":"b","text":"الشبكة أهشّ من السلسلة المفردة لأنّ فقد أيّ حلقة يهدمها فورًا"},{"id":"c","text":"الكائن الواحد قد ينتمي إلى أكثر من سلسلة داخل الشبكة"},{"id":"d","text":"توفّر الشبكة فرائس بديلة قد تُبقي مفترسًا حين تندر إحدى فرائسه"}]'::jsonb, 'b', 'العكس هو الصحيح: الشبكة أمتن من السلسلة المفردة لأنّ البدائل والتشابك يخفّفان أثر فقد حلقة؛ فوصفها بالأهشّ خطأ.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a877a821-e8e0-5736-9b56-6a682b687802', '5953f81c-ea4c-5752-ba12-36bfc5b11dbc', 'لحماية نظام سبخة تتوافد إليها الطيور المهاجرة، أيّ خطّة هي الأنسب والأشمل؟', '[{"id":"a","text":"قتل مفترسات الطيور كلّها لتكثر الطيور"},{"id":"b","text":"تجفيفها والبناء عليها لحماية الطيور من الغرق"},{"id":"c","text":"إعلانها محميّة طبيعية وحفظ مائها المالح ومنع تجفيفها وترشيد الصيد فيها"},{"id":"d","text":"صبّ الأملاح الصناعية في مائها لزيادة ملوحته فقط"}]'::jsonb, 'c', 'حماية النظام تقتضي حفظ وسطه (الماء المالح) ومنع تجفيفه وترشيد الصيد ضمن محميّة؛ أمّا التجفيف أو قتل المفترسات فيهدمان التوازن ويضرّان الطيور نفسها.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6fd9a41e-d644-5e13-bdc8-d58aef2f20e1', '5953f81c-ea4c-5752-ba12-36bfc5b11dbc', 'وصف باحث نظامًا: منتِج واحد، مستهلكان أوّلان يتغذّيان عليه ويتنافسان، مستهلك ثانٍ يفترسهما معًا، ومحلِّلات. لو انقرض أحد المستهلكَين الأوّلَين فقط، فما الأثر الأرجح على منافسه ثمّ على المنتِج؟', '[{"id":"a","text":"ينقرض المنافس فورًا هو الآخر، ويزدهر المنتِج بلا حدّ"},{"id":"b","text":"يتحوّل المنافس إلى محلِّل فيحمي المنتِج"},{"id":"c","text":"لا يتأثّر المنافس ولا المنتِج إطلاقًا"},{"id":"d","text":"يتحرّر المنافس من مزاحمه فتزيد أعداده، فيزداد الضغط على المنتِج فيتناقص"}]'::jsonb, 'd', 'بزوال أحد المتنافسَين يتحرّر الآخر من المزاحمة على الغذاء فتزيد أعداده، فيرتفع ضغط الرعي على المنتِج المشترك فيتناقص؛ فحتّى فقد حلقة «مكرّرة» يزحزح التوازن.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('606b9a57-725a-5478-8854-c312b034852e', 'd40c69c1-b472-57e1-b670-cecf2a81c526', 'sciences-vie-terre-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('61e25641-0ff7-511e-865b-7784755e3020', '606b9a57-725a-5478-8854-c312b034852e', 'ما تعريف التّعرية؟', '[{"id":"a","text":"تراكم الرّواسب واستقرارها في قاع البحر"},{"id":"b","text":"تفتّت الصّخور وتآكلها في مكانها بفعل عوامل خارجيّة"},{"id":"c","text":"حمل الفتات الصّخريّ بعيدًا عن مكانه"},{"id":"d","text":"تحوّل الرّواسب إلى صخور صلبة عميقة"}]'::jsonb, 'b', 'التّعرية هي تفتّت الصّخور وتآكلها في مكانها بفعل العوامل الخارجيّة (الماء، الرّياح، الجليد، تغيّر الحرارة)؛ أمّا حمل الفتات فهو النّقل، وتراكمه واستقراره فهو التّرسّب.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('75f59b1a-5541-5e08-9bac-499a79a27fbe', '606b9a57-725a-5478-8854-c312b034852e', 'أيّ ممّا يلي يُعدّ من عوامل (وسائط) التّعرية الخارجيّة؟', '[{"id":"a","text":"لون الصّخرة"},{"id":"b","text":"تشقّق الصّخرة"},{"id":"c","text":"الرّياح"},{"id":"d","text":"الطّبقات الرّسوبيّة"}]'::jsonb, 'c', 'الرّياح من عوامل التّعرية إلى جانب الماء والجليد وتغيّر الحرارة. أمّا تشقّق الصّخرة فهو أثر التّعرية لا عاملها، ولون الصّخرة والطّبقات الرّسوبيّة ليسا من عواملها.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('274f1e8b-705f-51af-bbf0-7c4b6935318c', '606b9a57-725a-5478-8854-c312b034852e', 'ما التّرتيب الصّحيح للمراحل الثّلاث للظّواهر الجيولوجيّة الخارجيّة؟', '[{"id":"a","text":"التّرسّب ← النّقل ← التّعرية"},{"id":"b","text":"النّقل ← التّعرية ← التّرسّب"},{"id":"c","text":"التّعرية ← التّرسّب ← النّقل"},{"id":"d","text":"التّعرية ← النّقل ← التّرسّب"}]'::jsonb, 'd', 'التّرتيب الثّابت هو التّعرية (تفتّت الصّخر) ثمّ النّقل (حمل الفتات بعيدًا) ثمّ التّرسّب (استقرار الفتات وتراكمه)؛ فلا شيء يُنقَل قبل أن يتفتّت، ولا يستقرّ قبل أن يُحمَل.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0407ef72-f9c1-5dda-927a-b4fc57e17258', '606b9a57-725a-5478-8854-c312b034852e', '«الرّياح لا تنقل إلّا حبيبات الرّمل.» هل هذه العبارة صحيحة؟', '[{"id":"a","text":"خاطئة؛ فالرّياح تحمل الغبار الدّقيق إلى مسافات وارتفاعات أكبر من الرّمل"},{"id":"b","text":"صحيحة؛ فالرّياح تعجز عن حمل أيّ شيء غير الرّمل"},{"id":"c","text":"صحيحة؛ فالرّياح تنقل الحصى الثّقيل والرّمل فقط"},{"id":"d","text":"خاطئة؛ فالرّياح تنقل الكتل الصّخريّة الكبيرة لمسافات بعيدة"}]'::jsonb, 'a', 'العبارة خاطئة: تحمل الرّياح الغبار الدّقيق إلى مسافات وارتفاعات أكبر ممّا تحمله من الرّمل، لكنّها لا تقدر على حمل الحصى الثّقيل ولا الكتل الكبيرة. فكلّما دقّت الحبيبة أمكن نقلها أبعد وأعلى.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('95262b1a-9973-54cb-a516-775331001b4a', '606b9a57-725a-5478-8854-c312b034852e', 'لماذا تترسّب الحبيبات الّتي يحملها الوادي عند مصبّه في السّهل؟', '[{"id":"a","text":"لأنّ الماء يزداد سرعة عند المصبّ فيدفع الحبيبات إلى الأمام"},{"id":"b","text":"لأنّ مجرى الماء يتّسع ويبطؤ جريانه، فيعجز عن حمل الحبيبات فتستقرّ"},{"id":"c","text":"لأنّ الحبيبات تتفتّت أكثر فتصير أثقل من أن تُحمَل"},{"id":"d","text":"لأنّ الرّياح تدفع الماء إلى الوراء عند المصبّ"}]'::jsonb, 'b', 'عند المصبّ يتّسع مجرى الوادي ويبطؤ جريان الماء، فيفقد قوّته ولا يعود قادرًا على حمل الحبيبات، فيُسقطها وتستقرّ رواسبَ. التّرسّب يحدث حين يفقد عامل النّقل سرعته، لا حين يزداد سرعة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('7c8c8ef4-b5f5-5b83-8f5a-013f79ca457d', 'd40c69c1-b472-57e1-b670-cecf2a81c526', 'sciences-vie-terre-8eme', '⭐ تمرين: الظّواهر الجيولوجيّة الخارجيّة', 1, 50, 10, 'practice', 'admin', 1)
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
  ('e34e3e5c-994b-5b05-9171-cf0d86a9bc8f', '7c8c8ef4-b5f5-5b83-8f5a-013f79ca457d', 'على ساحل صخريّ في شمال البلاد، تضرب أمواج البحر الصّخور باستمرار فتفتّتها شيئًا فشيئًا مع مرور السّنين. أيّ عامل من عوامل التّعرية يظهر هنا؟', '[{"id":"a","text":"الماء"},{"id":"b","text":"الرّياح"},{"id":"c","text":"تغيّر الحرارة"},{"id":"d","text":"الجليد"}]'::jsonb, 'a', 'أمواج البحر ماءٌ يضرب الصّخور على السّاحل فيفتّتها؛ فالماء (مطرًا وجريانًا وأمواجًا) أحد عوامل التّعرية الأساسيّة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c35b02cb-027a-5539-9593-8436b0039fa2', '7c8c8ef4-b5f5-5b83-8f5a-013f79ca457d', 'في كثبان الجنوب التّونسيّ، تحمل الرّياح حبيبات الرّمل فتصطدم بالصّخور وتحتّها كأنّها ورق صنفرة طبيعيّ. أيّ عامل تعرية هذا؟', '[{"id":"a","text":"الجليد"},{"id":"b","text":"الماء الجاري"},{"id":"c","text":"الرّياح"},{"id":"d","text":"أمواج البحر"}]'::jsonb, 'c', 'الرّياح تحمل حبيبات الرّمل فتصطدم بالصّخور وتحتّها؛ وهذا فعل تعرية بالرّياح، شائع في المناطق الصّحراويّة القليلة الغطاء النّباتيّ.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3350d665-b4c2-5108-a1a4-1d6fe99bf40a', '7c8c8ef4-b5f5-5b83-8f5a-013f79ca457d', 'بعد أن تُفتّت التّعريةُ صخرةً على سفح جبل، يجرف الوادي فتاتها من الحصى والرّمل بعيدًا إلى مجرًى أسفل السّفح. ما اسم هذه المرحلة؟', '[{"id":"a","text":"التّعرية"},{"id":"b","text":"النّقل"},{"id":"c","text":"التّرسّب"},{"id":"d","text":"التّبخّر"}]'::jsonb, 'b', 'حمل الفتات (الحصى والرّمل) بعيدًا عن مكان تفتّته هو مرحلة النّقل، وتأتي بعد التّعرية وقبل التّرسّب.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1a1e770c-8537-544e-a1ad-791222b2abbf', '7c8c8ef4-b5f5-5b83-8f5a-013f79ca457d', 'ما التّرتيب الصّحيح للمراحل الثّلاث الّتي تمرّ بها الظّواهر الجيولوجيّة الخارجيّة؟', '[{"id":"a","text":"النّقل ← الترسّب ← التّعرية"},{"id":"b","text":"التّرسّب ← التّعرية ← النّقل"},{"id":"c","text":"التّعرية ← التّرسّب ← النّقل"},{"id":"d","text":"التّعرية ← النّقل ← التّرسّب"}]'::jsonb, 'd', 'التّرتيب الثّابت: التّعرية (تفتّت الصّخر) ثمّ النّقل (حمل الفتات) ثمّ التّرسّب (استقرار الفتات وتراكمه).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('66bcd214-16d9-5f44-b4e8-5e0ec1c0bbff', '7c8c8ef4-b5f5-5b83-8f5a-013f79ca457d', 'ماذا نسمّي الفتات الصّخريّ الّذي يستقرّ ويتراكم في قاع بحيرة أو سبخة بعد أن يفقد الماء قدرته على حمله؟', '[{"id":"a","text":"رواسب"},{"id":"b","text":"غطاء نباتيّ"},{"id":"c","text":"أملاح معدنيّة ذائبة"},{"id":"d","text":"شقوق صخريّة"}]'::jsonb, 'a', 'الفتات المتراكم المستقرّ بعد التّرسّب يُسمّى رواسب؛ وهي ما سيتحوّل عبر ملايين السّنين إلى صخور رسوبيّة لاحقًا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('18716d4b-5ea9-562f-a95a-8049f8a29d31', '7c8c8ef4-b5f5-5b83-8f5a-013f79ca457d', 'عند مصبّ وادٍ موسميّ في سهل واسع، يبطؤ جريان الماء فيسقط ما كان يحمله من حصى ورمل ويتركه يتراكم. أيّ مرحلة من مراحل الظّواهر الجيولوجيّة الخارجيّة هذه؟', '[{"id":"a","text":"التّعرية"},{"id":"b","text":"النّقل"},{"id":"c","text":"التّرسّب"},{"id":"d","text":"التّجمّد"}]'::jsonb, 'c', 'حين يبطؤ الماء عند المصبّ يعجز عن حمل الحبيبات فيُسقطها وتتراكم؛ وهذا هو التّرسّب، آخر مراحل الظّواهر الجيولوجيّة الخارجيّة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b382a4a0-d0f1-539d-8469-514794b31ab0', 'd40c69c1-b472-57e1-b670-cecf2a81c526', 'sciences-vie-terre-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: الظّواهر الجيولوجيّة الخارجيّة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('8d5be853-92c2-5e3b-9041-09737262db48', 'b382a4a0-d0f1-539d-8469-514794b31ab0', 'على قمّة جبل مرتفع في الشّمال، يتسرّب الماء داخل شقوق الصّخر، فإذا تجمّد ليلًا تمدّد وضغط على جدران الشّقّ حتّى كسر الصّخرة. أيّ عامل تعرية يظهر هنا؟', '[{"id":"a","text":"الرّياح"},{"id":"b","text":"الجليد (تجمّد الماء)"},{"id":"c","text":"أمواج البحر"},{"id":"d","text":"الغبار الدّقيق"}]'::jsonb, 'b', 'تجمّد الماء داخل شقوق الصّخر يجعله يتمدّد ويضغط على جدران الشّقّ حتّى يوسّعه ويكسر الصّخرة؛ وهذا فعل تعرية بالجليد، شائع في المرتفعات الباردة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4a2ccd4f-f2db-5faf-b947-52698d274985', 'b382a4a0-d0f1-539d-8469-514794b31ab0', 'على هضبة صحراويّة في الجنوب، تتشقّق الصّخور وتتقشّر سطحيًّا بعد أن يشتدّ الفرق بين حرارة النّهار المرتفعة وبرودة اللّيل مرّة بعد مرّة. أيّ عامل تعرية هذا؟', '[{"id":"a","text":"الجليد"},{"id":"b","text":"الماء الجاري"},{"id":"c","text":"تغيّر الحرارة"},{"id":"d","text":"أمواج البحر"}]'::jsonb, 'c', 'تمدّد سطح الصّخرة نهارًا بالحرارة وانكماشه ليلًا بالبرودة، مع تكرار ذلك، يشقّقها ويقشّرها؛ وهذا فعل تغيّر الحرارة، القويّ في الصّحراء لكبر الفرق بين حرارة النّهار واللّيل.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('398f5a78-8df1-59bd-b26d-b59b11508ce3', 'b382a4a0-d0f1-539d-8469-514794b31ab0', 'أيّ العبارات التّالية بخصوص نقل الرّياح للفتات هي الصّحيحة؟', '[{"id":"a","text":"تحمل الرّياح الغبار الدّقيق أبعد وأعلى من الرّمل، لكنّها تعجز عن حمل الحصى الثّقيل"},{"id":"b","text":"تنقل الرّياح الكتل الصّخريّة الكبيرة إلى مسافات أبعد من الرّمل"},{"id":"c","text":"لا تنقل الرّياح إلّا الحصى الثّقيل دون الرّمل والغبار"},{"id":"d","text":"تنقل الرّياح كلّ أحجام الفتات بالتّساوي إلى المسافة نفسها"}]'::jsonb, 'a', 'كلّما دقّت الحبيبة أمكن نقلها أبعد وأعلى؛ فالغبار الدّقيق يُحمَل أبعد من الرّمل، بينما تعجز الرّياح عن حمل الحصى الثّقيل والكتل الكبيرة أصلًا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('216425d8-e003-513e-af78-6523b0e2685e', 'b382a4a0-d0f1-539d-8469-514794b31ab0', 'يحمل وادٍ بعد المطر حصًى ورملًا وطينًا معًا. حين يبطؤ جريانه تدريجيًّا في السّهل، أيّ الحبيبات نتوقّع أن تترسّب أوّلًا؟', '[{"id":"a","text":"الطّين الدّقيق جدًّا لأنّه الأخفّ"},{"id":"b","text":"لا يترسّب شيء ما دام في الماء أيّ حركة"},{"id":"c","text":"كلّ الأحجام تترسّب في اللّحظة نفسها بالضّبط"},{"id":"d","text":"الحصى الثّقيل لأنّه أوّل ما يعجز الماء عن حمله حين تقلّ السّرعة قليلًا"}]'::jsonb, 'd', 'يترسّب الأثقل والأكبر أوّلًا بمجرّد أن تقلّ السّرعة قليلًا؛ فالحصى الثّقيل أوّل ما يعجز الماء عن حمله، بينما يحتاج الطّين الدّقيق ماءً شبه ساكن فيترسّب لاحقًا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c50a9da0-6c51-5cc1-a8d6-ffe74d554e8e', 'b382a4a0-d0f1-539d-8469-514794b31ab0', 'كتب تلميذ: «الفتات الصّخريّ يُنقَل أوّلًا ثمّ يتفتّت أثناء النّقل، فالنّقل يسبق التّعرية.» أين الخطأ؟', '[{"id":"a","text":"لا خطأ، فالتّرتيب دقيق تمامًا"},{"id":"b","text":"الخطأ أنّ التّرسّب هو ما يسبق النّقل لا التّعرية"},{"id":"c","text":"الخطأ أنّ النّقل لا يسبق التّعرية: لا شيء يُنقَل قبل أن تُفتّته التّعرية أوّلًا، فالتّعرية تسبق النّقل دائمًا"},{"id":"d","text":"الخطأ أنّ الفتات لا يُنقَل إطلاقًا بل يبقى في مكانه دائمًا"}]'::jsonb, 'c', 'لا يُنقَل الفتات قبل أن يوجد؛ والتّعرية هي الّتي تُنتِج الفتات بتفتيت الصّخر. لذلك التّرتيب الثّابت هو التّعرية ثمّ النّقل ثمّ التّرسّب، والتّعرية تسبق النّقل دائمًا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5b6dae6e-e2fc-5253-9ce2-1b0bb22d21ed', 'b382a4a0-d0f1-539d-8469-514794b31ab0', 'تفتّتت صخرة على سفح جبل بالشّمال، فحملها وادٍ إلى سهل، ثمّ إلى مصبّه على السّاحل حيث استقرّ فتاتها في قاع البحر. رتّب المراحل الّتي مرّت بها هذه الصّخرة.', '[{"id":"a","text":"ترسّب في قاع البحر ← نقل بالوادي ← تعرية على السّفح"},{"id":"b","text":"تعرية على السّفح ← نقل بالوادي ← ترسّب في قاع البحر"},{"id":"c","text":"نقل بالوادي ← تعرية على السّفح ← ترسّب في قاع البحر"},{"id":"d","text":"تعرية على السّفح ← ترسّب في قاع البحر ← نقل بالوادي"}]'::jsonb, 'b', 'تفتّتت الصّخرة أوّلًا على السّفح (تعرية)، ثمّ حملها الوادي بعيدًا (نقل)، ثمّ استقرّ فتاتها في قاع البحر (ترسّب)؛ وهو التّرتيب الثّابت للظّواهر الجيولوجيّة الخارجيّة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('939cc2c6-e045-586b-85e4-da9c19749089', 'd40c69c1-b472-57e1-b670-cecf2a81c526', 'sciences-vie-terre-8eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الظّواهر الجيولوجيّة الخارجيّة', 2, 70, 15, 'practice', 'admin', 3)
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
  ('c0136bbe-2e52-52b4-956c-476b4cf9575a', '939cc2c6-e045-586b-85e4-da9c19749089', 'قال تلميذ إنّ «تشقّق الصّخرة» هو أحد عوامل التّعرية. أين الخطأ؟', '[{"id":"a","text":"لا خطأ، فتشقّق الصّخرة عامل تعرية مثل الرّياح تمامًا"},{"id":"b","text":"الخطأ أنّ تشقّق الصّخرة أثرٌ من آثار التّعرية لا عاملًا لها؛ العوامل هي الماء والرّياح والجليد وتغيّر الحرارة"},{"id":"c","text":"الخطأ أنّ تشقّق الصّخرة لا يحدث إطلاقًا في الطّبيعة"},{"id":"d","text":"الخطأ أنّ تشقّق الصّخرة عامل نقل لا عامل تعرية"}]'::jsonb, 'b', 'يجب التّمييز بين العامل وأثره: عوامل التّعرية هي الماء والرّياح والجليد وتغيّر الحرارة، أمّا تشقّق الصّخرة وتفتّتها فهو أثر هذه العوامل، لا عاملًا قائمًا بذاته.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('01631cb6-4814-53d0-8dbd-ff7797f5b633', '939cc2c6-e045-586b-85e4-da9c19749089', 'ما تعريف مرحلة النّقل في الظّواهر الجيولوجيّة الخارجيّة؟', '[{"id":"a","text":"تفتّت الصّخر وتآكله في مكانه"},{"id":"b","text":"تحوّل الرّواسب إلى صخور صلبة"},{"id":"c","text":"حمل الفتات الصّخريّ بعيدًا عن مكان تفتّته بفعل الماء أو الرّياح أو الجليد"},{"id":"d","text":"استقرار الفتات وتراكمه في طبقات"}]'::jsonb, 'c', 'النّقل هو حمل الفتات النّاتج عن التّعرية بعيدًا عن مكانه بفعل عوامل النّقل نفسها (الماء الجاري، الرّياح، الجليد المتحرّك)؛ أمّا التّفتّت فهو التّعرية والاستقرار فهو التّرسّب.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6955da91-1107-55bc-a4b1-081740eb48d7', '939cc2c6-e045-586b-85e4-da9c19749089', 'في وادٍ يجري بعد المطر، يدحرج الماء الحصى الثّقيل على قاعه، بينما يحمل الطّين الدّقيق معلّقًا فيه. أيّ الحبيبات نتوقّع أن تُنقَل إلى مسافة أبعد؟', '[{"id":"a","text":"الطّين الدّقيق المعلّق، لأنّ الحبيبة الأدقّ تُحمَل أبعد"},{"id":"b","text":"الحصى الثّقيل، لأنّه أكبر حجمًا"},{"id":"c","text":"كلاهما إلى المسافة نفسها تمامًا"},{"id":"d","text":"لا يُنقَل أيّ منهما ما دام في الماء"}]'::jsonb, 'a', 'كلّما دقّت الحبيبة سهُل حملها إلى مسافة أبعد؛ فالطّين الدّقيق المعلّق في الماء يُنقَل أبعد بكثير من الحصى الثّقيل الّذي يتدحرج قرب القاع ويستقرّ سريعًا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c98b64af-883b-5e8d-88b4-473d338183e3', '939cc2c6-e045-586b-85e4-da9c19749089', 'في سبخة يهدأ فيها الماء تمامًا، تترسّب حبيبات الطّين الدّقيقة جدًّا في القاع. لماذا يحتاج الطّين إلى ماء شبه ساكن ليترسّب؟', '[{"id":"a","text":"لأنّ الطّين أثقل من الحصى فيحتاج قوّة أكبر لإسقاطه"},{"id":"b","text":"لأنّ الطّين يتبخّر قبل أن يترسّب"},{"id":"c","text":"لأنّ الطّين لا يترسّب إطلاقًا في الماء"},{"id":"d","text":"لأنّ حبيبات الطّين دقيقة جدًّا وخفيفة، فيبقيها أيّ تحرّك للماء معلّقةً؛ ولا تستقرّ إلّا حين يهدأ الماء تقريبًا"}]'::jsonb, 'd', 'حبيبات الطّين دقيقة جدًّا وخفيفة، فيكفي أدنى تحرّك للماء ليبقيها معلّقة؛ لذلك لا تترسّب إلّا في ماء شبه ساكن، بعكس الحصى الثّقيل الّذي يترسّب بمجرّد أن تقلّ سرعة الماء قليلًا.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3a2ff8ca-6190-59a4-970a-d2a8ce559644', '939cc2c6-e045-586b-85e4-da9c19749089', 'لوحظ أنّ حصى وادٍ بعيدًا عن منبعه يكون مستديرًا أملسَ، بينما يكون قرب المنبع أكثر خشونة وحدّة. ما تفسير ذلك؟', '[{"id":"a","text":"لأنّ الحصى يكبر حجمًا كلّما ابتعد عن المنبع"},{"id":"b","text":"لأنّ الماء يذيب الحصى القريب من المنبع فقط"},{"id":"c","text":"لأنّ طول النّقل جعل الحبيبات تحتكّ بعضها ببعض فتآكلت حوافّها واستدارت"},{"id":"d","text":"لأنّ الرّياح وحدها هي الّتي تنقل الحصى البعيد"}]'::jsonb, 'c', 'كلّما طال النّقل احتكّت الحبيبات بعضها ببعض وبقاع المجرى، فتآكلت حوافّها الحادّة واستدارت؛ لذلك يكون الحصى البعيد عن المنبع أكثر استدارة ونعومة من القريب منه.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c509a04c-365c-5666-85c8-5d4fa59012b5', '939cc2c6-e045-586b-85e4-da9c19749089', 'أيّ ممّا يلي **ليس** من عوامل التّعرية الخارجيّة؟', '[{"id":"a","text":"الرّياح"},{"id":"b","text":"تغيّر الحرارة"},{"id":"c","text":"الماء الجاري"},{"id":"d","text":"لون الصّخرة"}]'::jsonb, 'd', 'عوامل التّعرية هي الماء والرّياح والجليد وتغيّر الحرارة؛ أمّا لون الصّخرة فصفة لها لا يؤثّر في تفتّتها، فليس عامل تعرية.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('eee4ccc8-3933-535f-8ac8-cc400d9b08d8', 'd40c69c1-b472-57e1-b670-cecf2a81c526', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: الظّواهر الجيولوجيّة الخارجيّة', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('dfe6f248-95ec-5882-ad64-c3c427c2ce30', 'eee4ccc8-3933-535f-8ac8-cc400d9b08d8', 'أيّ العبارات الأربع التّالية بخصوص النّقل بالرّياح **خاطئة**؟', '[{"id":"a","text":"تحمل الرّياح الغبار الدّقيق عاليًا وإلى مسافات بعيدة جدًّا"},{"id":"b","text":"تدحرج الرّياح حبيبات الرّمل قرب سطح الأرض"},{"id":"c","text":"تعجز الرّياح عن حمل الحصى الثّقيل والكتل الكبيرة"},{"id":"d","text":"تنقل الرّياح الكتل الصّخريّة الكبيرة إلى مسافات أبعد من الغبار"}]'::jsonb, 'd', 'العبارة (د) خاطئة: كلّما دقّت الحبيبة أمكن نقلها أبعد؛ فالغبار الدّقيق هو ما يُحمَل أبعد وأعلى، بينما تعجز الرّياح أصلًا عن حمل الكتل الكبيرة. العبارات الثّلاث الأخرى صحيحة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d6d87631-f17f-5241-a851-ea0b4827c70b', 'eee4ccc8-3933-535f-8ac8-cc400d9b08d8', 'كتب تلميذ في تقريره: «الرّياح أثرٌ من آثار التّعرية، أمّا تفتّت الصّخرة فهو عامل التّعرية.» أين الخطأ في هذا التّقرير؟', '[{"id":"a","text":"لا خطأ، فالتّقرير دقيق تمامًا"},{"id":"b","text":"الخطأ أنّ الرّياح وتفتّت الصّخرة كليهما أثران وليسا عاملًا ولا أثرًا لبعضهما"},{"id":"c","text":"الخطأ أنّه عكس الأمر: الرّياح هي العامل، وتفتّت الصّخرة هو الأثر النّاتج عن هذا العامل"},{"id":"d","text":"الخطأ أنّ الرّياح لا علاقة لها بالتّعرية إطلاقًا"}]'::jsonb, 'c', 'التّقرير قلب العلاقة: الرّياح (كالماء والجليد والحرارة) عاملٌ من عوامل التّعرية، أمّا تفتّت الصّخرة فهو الأثر النّاتج عن فعل هذا العامل، لا العكس.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fe728fec-4022-5020-95f2-504ca63def42', 'eee4ccc8-3933-535f-8ac8-cc400d9b08d8', 'لماذا يكون فعل تغيّر الحرارة في تفتيت الصّخور أقوى في الصّحراء منه في المناطق السّاحليّة المعتدلة؟', '[{"id":"a","text":"لأنّ الصّخور في الصّحراء أضعف بطبيعتها من صخور السّاحل"},{"id":"b","text":"لأنّ الفرق بين حرارة النّهار المرتفعة وبرودة اللّيل كبير جدًّا في الصّحراء، فيتمدّد الصّخر وينكمش بشدّة متكرّرة"},{"id":"c","text":"لأنّ الصّحراء أكثر مطرًا من السّاحل"},{"id":"d","text":"لأنّ تغيّر الحرارة لا يحدث إطلاقًا قرب البحر"}]'::jsonb, 'b', 'في الصّحراء يشتدّ الفرق بين حرارة النّهار وبرودة اللّيل، فيتمدّد سطح الصّخر نهارًا وينكمش ليلًا بشكل حادّ ومتكرّر، ما يشقّقه ويقشّره؛ بينما يكون الفرق ألطف قرب البحر المعتدل.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f2108937-b37f-5510-b0ad-37cc9b57b440', 'eee4ccc8-3933-535f-8ac8-cc400d9b08d8', 'على امتداد سهل ينبسط فيه وادٍ ويبطؤ جريانه تدريجيًّا من مصبّه، وُجد أنّ الحصى يترسّب قرب المصبّ، ثمّ الرّمل أبعد، ثمّ الطّين في أبعد نقطة داخل السّبخة. ما تفسير هذا التّوزيع؟', '[{"id":"a","text":"يترسّب الأثقل أوّلًا حين تقلّ السّرعة قليلًا، ثمّ الأخفّ فالأخفّ كلّما زاد هدوء الماء"},{"id":"b","text":"يترسّب الأخفّ أوّلًا لأنّه الأسرع سقوطًا"},{"id":"c","text":"تترسّب كلّ الأحجام في النّقطة نفسها عند المصبّ"},{"id":"d","text":"التّوزيع عشوائيّ ولا علاقة له بحجم الحبيبات أو سرعة الماء"}]'::jsonb, 'a', 'كلّما بطؤ الماء أكثر، ترسّبت حبيبات أدقّ؛ فالحصى الثّقيل أوّل ما يستقرّ قرب المصبّ حين تقلّ السّرعة قليلًا، يليه الرّمل، ثمّ الطّين الدّقيق الّذي يحتاج ماءً شبه ساكن في أبعد نقطة. هذا التّدرّج هو تصنيف الرّواسب حسب حجمها.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('53910d10-dca1-5f9a-b1e4-7a6de392a010', 'eee4ccc8-3933-535f-8ac8-cc400d9b08d8', 'ساحلان صخريّان متجاوران: الأوّل تضربه أمواج قويّة على مدار السّنة، والثّاني محميّ داخل خليج هادئ نادرًا ما تصله أمواج قويّة. أيّهما نتوقّع أن تتفتّت صخوره أسرع، ولماذا؟', '[{"id":"a","text":"السّاحل المحميّ، لأنّ هدوء الماء يُضعف الصّخر"},{"id":"b","text":"لا يتفتّت أيّ منهما لأنّ الماء لا يُفتّت الصّخر إطلاقًا"},{"id":"c","text":"كلاهما بالسّرعة نفسها، لأنّ الماء موجود في الحالتين"},{"id":"d","text":"السّاحل ذو الأمواج القويّة، لأنّ ضرب الأمواج المتكرّر للصّخر يفتّته أسرع من ماء الخليج الهادئ"}]'::jsonb, 'd', 'الماء عامل تعرية، وشدّة فعله ترتبط بقوّته وتكراره؛ فالأمواج القويّة المتكرّرة تفتّت صخور السّاحل الأوّل أسرع بكثير من ماء الخليج الهادئ الّذي نادرًا ما يضرب الصّخر بقوّة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('392a1227-1f52-562d-95cb-8deb35ee34a0', 'eee4ccc8-3933-535f-8ac8-cc400d9b08d8', 'زعم تلميذ أنّ «رواسب قاع البحر تكوّنت مباشرة هناك دون تعرية ولا نقل سابقين». صحّح هذا الزّعم مستندًا إلى تسلسل الظّواهر الخارجيّة.', '[{"id":"a","text":"الزّعم صحيح؛ فالتّرسّب يحدث دون حاجة إلى تعرية أو نقل"},{"id":"b","text":"الزّعم خاطئ؛ فالتّرتيب الصّحيح هو نقل ← ترسّب ← تعرية"},{"id":"c","text":"الزّعم خاطئ؛ فرواسب القاع فتاتٌ نتج عن تعرية صخور في اليابسة، ثمّ نُقل بالماء أو الرّياح، ثمّ ترسّب في القاع: تعرية ← نقل ← ترسّب"},{"id":"d","text":"الزّعم خاطئ؛ فرواسب القاع تكوّنت بالتّرسّب أوّلًا ثمّ تعرّضت للتّعرية والنّقل"}]'::jsonb, 'c', 'التّرسّب حلقة أخيرة في سلسلة: لا رواسب دون فتات، ولا فتات دون تعرية سابقة؛ فرواسب القاع أصلها صخور تفتّتت (تعرية)، ثمّ حُمل فتاتها (نقل)، ثمّ استقرّ في القاع (ترسّب)، بهذا التّرتيب الثّابت.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('306e1117-d2cd-50f8-831c-1021c09e407c', 'd40c69c1-b472-57e1-b670-cecf2a81c526', 'sciences-vie-terre-8eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): الظّواهر الجيولوجيّة الخارجيّة', 3, 120, 30, 'boss', 'admin', 5)
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
  ('10d490ed-3395-5d12-9dc1-b47d69d8e1f7', '306e1117-d2cd-50f8-831c-1021c09e407c', 'في مجرى وادٍ جافّ في الجنوب، تهبّ رياح قويّة فتحمل الرّمل الجافّ وتنقله إلى الكثبان المجاورة. أيّ عامل يقوم بالنّقل هنا؟', '[{"id":"a","text":"الرّياح"},{"id":"b","text":"الماء الجاري"},{"id":"c","text":"الجليد"},{"id":"d","text":"أمواج البحر"}]'::jsonb, 'a', 'الرّياح تحمل الرّمل الجافّ وتنقله إلى الكثبان؛ فهي عامل نقل كما هي عامل تعرية، خاصّة في المناطق الجافّة القليلة الغطاء النّباتيّ.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4889149c-1535-5112-a7e8-c9596e1c648a', '306e1117-d2cd-50f8-831c-1021c09e407c', 'ما اسم الظّاهرة الّتي تتفتّت فيها الصّخور وتتآكل في مكانها بفعل الماء والرّياح والجليد وتغيّر الحرارة؟', '[{"id":"a","text":"التّرسّب"},{"id":"b","text":"النّقل"},{"id":"c","text":"التّعرية"},{"id":"d","text":"الإنتاش"}]'::jsonb, 'c', 'تفتّت الصّخور وتآكلها في مكانها بفعل العوامل الخارجيّة هو التّعرية، أولى مراحل الظّواهر الجيولوجيّة الخارجيّة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e31e2d49-2e47-5072-aa49-56aabe05846c', '306e1117-d2cd-50f8-831c-1021c09e407c', 'في مرتفع بارد بالشّمال، يتكرّر تجمّد الماء داخل شقوق صخرة وذوبانه مع تعاقب اللّيل والنّهار. ما الأثر المتوقّع على الصّخرة على المدى الطّويل؟', '[{"id":"a","text":"تزداد صلابة وتماسكًا كلّما تجمّد الماء فيها"},{"id":"b","text":"تتوسّع شقوقها تدريجيًّا حتّى تتفتّت، لأنّ الماء يتمدّد عند تجمّده فيضغط على جدران الشّقّ"},{"id":"c","text":"يذوب الصّخر نفسه ويتحوّل إلى ماء"},{"id":"d","text":"لا يتأثّر الصّخر إطلاقًا بتجمّد الماء"}]'::jsonb, 'b', 'يتمدّد الماء عند تجمّده، فيضغط على جدران الشّقّ ويوسّعه؛ ومع تكرار التّجمّد والذّوبان تتّسع الشّقوق حتّى تتفتّت الصّخرة. هذه تعرية بالجليد.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ca1c65b3-47d7-50e9-9cf7-28617a911bc4', '306e1117-d2cd-50f8-831c-1021c09e407c', 'لماذا نقول إنّ الرّياح والماء يقومان بدورَين في هذه الظّواهر لا بدور واحد؟', '[{"id":"a","text":"لأنّهما يقومان بالتّعرية فقط دون سواها"},{"id":"b","text":"لأنّهما يقومان بالتّرسّب فقط دون سواه"},{"id":"c","text":"لأنّهما يُفتّتان الصّخر (تعرية) ثمّ يحملان فتاته بعيدًا (نقل)، فهما عاملا تعرية ونقل معًا"},{"id":"d","text":"لأنّهما لا علاقة لهما لا بالتّعرية ولا بالنّقل"}]'::jsonb, 'c', 'الماء والرّياح عاملان مزدوجان: يُفتّتان الصّخر في مكانه (تعرية)، ثمّ يحملان الفتات النّاتج بعيدًا (نقل)؛ ولذلك يظهران في مرحلتين من مراحل الظّواهر الخارجيّة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('49d8f6a1-bde7-5608-9836-4d00d46bbf19', '306e1117-d2cd-50f8-831c-1021c09e407c', 'كتب تلميذ: «كلّما ابتعد الحصى عن منبع الوادي كبُر حجمه وازدادت حدّة حوافّه.» أين الخطأ؟', '[{"id":"a","text":"لا خطأ، فالحصى يكبر ويزداد حدّة كلّما ابتعد"},{"id":"b","text":"الخطأ أنّ الحصى يبقى ثابت الحجم والشّكل مهما طال النّقل"},{"id":"c","text":"الخطأ أنّ طول النّقل يجعل الحصى أصغر وأكثر استدارة لا أكبر وأحدّ، لأنّ الاحتكاك يآكل حوافّه"},{"id":"d","text":"الخطأ أنّ الحصى لا يُنقَل إطلاقًا في الوادي"}]'::jsonb, 'c', 'طول النّقل يجعل الحبيبات تحتكّ بعضها ببعض، فتتآكل حوافّها الحادّة ويصغر حجمها وتستدير؛ فالحصى البعيد أصغر وأملس لا أكبر وأحدّ، عكس ما كتب التّلميذ.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('24a7db6c-2406-52f0-9895-579ada6a3f10', '306e1117-d2cd-50f8-831c-1021c09e407c', 'بعد عاصفة، حمل وادٍ خليطًا من الحصى والرّمل والطّين إلى سبخة. في الأيّام التّالية هدأ الماء تدريجيًّا. ما التّرتيب المتوقّع لترسّب هذه الحبيبات من قاع المصبّ إلى عمق السّبخة الهادئ؟', '[{"id":"a","text":"الطّين أوّلًا قرب المصبّ، ثمّ الرّمل، ثمّ الحصى في العمق الهادئ"},{"id":"b","text":"الحصى أوّلًا قرب المصبّ، ثمّ الرّمل، ثمّ الطّين في العمق الهادئ"},{"id":"c","text":"تترسّب الأحجام الثّلاثة معًا في النّقطة نفسها"},{"id":"d","text":"لا يترسّب شيء ما دام في السّبخة أيّ ماء"}]'::jsonb, 'b', 'يترسّب الأثقل أوّلًا حين تقلّ السّرعة قليلًا: فالحصى قرب المصبّ، ثمّ الرّمل أبعد، ثمّ الطّين الدّقيق في العمق الهادئ لأنّه يحتاج ماءً شبه ساكن. هذا هو تصنيف الرّواسب حسب الحجم.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b71e574c-cbc7-52ce-96c6-17506fad2e2e', 'd40c69c1-b472-57e1-b670-cecf2a81c526', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐ (القمّة): الظّواهر الجيولوجيّة الخارجيّة', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('b7bf674f-4963-5bc1-bbc3-b0006acd4522', 'b71e574c-cbc7-52ce-96c6-17506fad2e2e', 'أربع ملاحظات ميدانيّة عن عوامل التّعرية؛ أيّها يخلط بين العامل وأثره خلطًا **خاطئًا**؟', '[{"id":"a","text":"الرّياح تحمل حبيبات الرّمل فتحتّ الصّخر: الرّياح عامل، وحتّ الصّخر أثر"},{"id":"b","text":"تجمّد الماء في الشّقوق يفتّت الصّخر: الجليد عامل، وتفتّت الصّخر أثر"},{"id":"c","text":"تشقّق الصّخرة يفتّت تغيّرَ الحرارة: تشقّق الصّخرة عامل، وتغيّر الحرارة أثر"},{"id":"d","text":"أمواج البحر تضرب السّاحل فتفتّت صخوره: الأمواج عامل، وتفتّت الصّخر أثر"}]'::jsonb, 'c', 'الملاحظة (ج) مقلوبة: تغيّر الحرارة هو العامل، وتشقّق الصّخرة هو الأثر، لا العكس. أمّا الملاحظات الثّلاث الأخرى فتُميّز العامل عن أثره تمييزًا صحيحًا.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3f9aa920-be69-5b34-9039-639eb77a4ed3', 'b71e574c-cbc7-52ce-96c6-17506fad2e2e', 'أيّ العبارات التّالية عن العلاقة بين حجم الحبيبة ونقلها هي الصّحيحة؟', '[{"id":"a","text":"كلّما كبرت الحبيبة سهُل حملها إلى مسافة أبعد وأعلى"},{"id":"b","text":"كلّما دقّت الحبيبة سهُل حملها إلى مسافة أبعد وأعلى، وكلّما كبرت استقرّت أقرب"},{"id":"c","text":"حجم الحبيبة لا علاقة له بالمسافة الّتي تُنقَل إليها"},{"id":"d","text":"الحبيبات الكبيرة والصّغيرة تُنقَل دائمًا إلى المسافة نفسها"}]'::jsonb, 'b', 'كلّما دقّت الحبيبة قلّ وزنها فسهُل حملها أبعد وأعلى (الغبار مثلًا)، وكلّما كبرت (الحصى) عجز العامل عن حملها بعيدًا فاستقرّت أقرب. لذلك تتصنّف الحبيبات حسب حجمها أثناء النّقل والتّرسّب.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cc856f38-c9c6-574a-a78e-70871811d90b', 'b71e574c-cbc7-52ce-96c6-17506fad2e2e', 'رُصدت أربع حالات ميدانيّة: (A) صخرة على قمّة باردة تفتّتها الشّقوق بعد تجمّد الماء فيها. (B) هضبة صحراويّة تتقشّر صخورها لكبر الفرق بين حرارة النّهار واللّيل. (C) ساحل تفتّت أمواجُه الصّخر. (D) كثيب يحتّ الرّملُ المحمول بالرّيح صخورَه. أيّ إسناد لعوامل التّعرية صحيح؟', '[{"id":"a","text":"A جليد، B تغيّر حرارة، C ماء، D رياح"},{"id":"b","text":"A رياح، B ماء، C جليد، D تغيّر حرارة"},{"id":"c","text":"A تغيّر حرارة، B جليد، C رياح، D ماء"},{"id":"d","text":"A ماء، B رياح، C تغيّر حرارة، D جليد"}]'::jsonb, 'a', 'تجمّد الماء في الشّقوق = الجليد (A)؛ التّقشّر لكبر الفرق بين حرارة النّهار واللّيل = تغيّر الحرارة (B)؛ تفتيت الأمواج للصّخر = الماء (C)؛ حتّ الرّمل المحمول بالرّيح للصّخر = الرّياح (D).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c8d1d453-d101-5f3b-92ef-7eec62679352', 'b71e574c-cbc7-52ce-96c6-17506fad2e2e', 'زعم تلميذ: «التّرسّب يمكن أن يحدث دون نقل سابق، لأنّ الرّواسب تنشأ في مكانها.» ما التّصحيح المستند إلى تسلسل الظّواهر الخارجيّة؟', '[{"id":"a","text":"الزّعم صحيح؛ فالرّواسب تنشأ في موضع ترسّبها دون أن تُنقَل إليه"},{"id":"b","text":"الزّعم خاطئ؛ فالتّرسّب استقرارٌ لفتاتٍ سبق أن نُقل من موضع تعرّى فيه، فلا ترسّب دون نقل سابق ولا نقل دون تعرية سابقة"},{"id":"c","text":"الزّعم خاطئ؛ فالتّرتيب الصّحيح ترسّب ← تعرية ← نقل"},{"id":"d","text":"الزّعم خاطئ؛ فالنّقل يحدث بعد التّرسّب لا قبله"}]'::jsonb, 'b', 'التّرسّب استقرار فتاتٍ حُمل إلى مكانه؛ وهذا الفتات نتج عن تعرية صخر في موضع آخر ثمّ نُقل. فالتّرتيب الثّابت تعرية ← نقل ← ترسّب، ولا يمكن أن يحدث ترسّب دون نقل سابق.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7d465653-7e4d-5035-bfae-91dc90c02042', 'b71e574c-cbc7-52ce-96c6-17506fad2e2e', 'قرأ تلميذ أربع عبارات عن الظّواهر الجيولوجيّة الخارجيّة، إحداها **خاطئة**. أيّها؟', '[{"id":"a","text":"تحمل الرّياح الغبار الدّقيق أبعد ممّا تحمل الرّمل"},{"id":"b","text":"يترسّب الطّين الدّقيق قبل الحصى الثّقيل حين يبطؤ الماء تدريجيًّا"},{"id":"c","text":"تجمّد الماء في شقوق الصّخر يوسّعها ويفتّت الصّخر"},{"id":"d","text":"طول النّقل يجعل حوافّ الحصى تستدير وتنعم"}]'::jsonb, 'b', 'العبارة (ب) خاطئة: يترسّب الأثقل أوّلًا، فالحصى الثّقيل يستقرّ قبل الطّين الدّقيق الّذي يحتاج ماءً شبه ساكن؛ فالتّرتيب معكوس. أمّا العبارات الأخرى فصحيحة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e44bda26-949d-5796-928c-db3da41d0265', 'b71e574c-cbc7-52ce-96c6-17506fad2e2e', 'منطقتان تُنتِجان رواسب في البحر: المنطقة (1) جبال شديدة الانحدار قليلة الغطاء النّباتيّ تعبرها وديان سريعة، والمنطقة (2) سهل منبسط كثيف الغطاء النّباتيّ تجري فيه المياه ببطء. أيّهما نتوقّع أن تُنتِج كمّية رواسب أكبر في البحر، ولماذا؟', '[{"id":"a","text":"المنطقة (2)، لأنّ الغطاء النّباتيّ الكثيف يزيد تفتّت الصّخر ونقله"},{"id":"b","text":"المنطقة (1)، لأنّ الانحدار الشّديد وقلّة الغطاء النّباتيّ يقوّيان التّعرية، والوديان السّريعة تنقل فتاتًا أكثر إلى البحر"},{"id":"c","text":"كلتاهما تُنتجان الكمّية نفسها لأنّ الرّواسب لا علاقة لها بالتّضاريس"},{"id":"d","text":"لا تُنتِج أيّ منطقة رواسب ما دام فيها غطاء نباتيّ أو ماء"}]'::jsonb, 'b', 'التّعرية والنّقل أقوى حيث يشتدّ الانحدار ويقلّ الغطاء النّباتيّ المُثبّت للتّربة، والمياه السّريعة تحمل فتاتًا أكثر؛ فالمنطقة (1) تُنتِج رواسب أكثر. أمّا الغطاء النّباتيّ الكثيف والمياه البطيئة في المنطقة (2) فيقلّلان التّعرية والنّقل.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('3dd505bc-5674-5aa8-8c9a-4723ef0c7b1d', '0a3bf243-c415-57eb-b300-dcd8259e6f0d', 'sciences-vie-terre-8eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('27ca696f-e24e-5db2-81ea-ae13ccc299d9', '3dd505bc-5674-5aa8-8c9a-4723ef0c7b1d', 'ما تعريف الصخرة الرسوبيّة؟', '[{"id":"a","text":"صخرةٌ تتكوّن قرب سطح الأرض بتراكم الرواسب ثم تصلّبها"},{"id":"b","text":"صخرةٌ ناتجةٌ عن تبرّد الصهارة في باطن الأرض"},{"id":"c","text":"صخرةٌ منصهرةٌ تخرج من البركان"},{"id":"d","text":"معدنٌ ثمينٌ يوجد في أعماق الأرض"}]'::jsonb, 'a', 'الصخرة الرسوبيّة تتكوّن قرب سطح الأرض بتراكم الرواسب (فُتات صخور وحبيبات وبقايا كائنات) ثم تصلّبها عبر الزمن. أمّا التي تتكوّن من تبرّد الصهارة فهي صخرة صهاريّة (بركانيّة).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('86e1f500-2e88-56c1-b88d-78ab5ed9e3dd', '3dd505bc-5674-5aa8-8c9a-4723ef0c7b1d', 'أيّ صخرةٍ رسوبيّةٍ تتميّز بحبيباتٍ دقيقةٍ جدًّا وتصبح لدنةً لزجةً عند بلّها بالماء؟', '[{"id":"a","text":"الحجر الرمليّ"},{"id":"b","text":"الكلس"},{"id":"c","text":"الطين"},{"id":"d","text":"البازلت"}]'::jsonb, 'c', 'الطين حبيباته دقيقةٌ جدًّا غير مرئيّةٍ بالعين، ويصبح لدنًا لزجًا عند بلّه، وهو صخرةٌ كتيمة. أمّا الرمل فحبيباته مرئيّةٌ ونفوذة، والبازلت صخرةٌ صهاريّةٌ لا رسوبيّة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b452a9a0-a0b6-59be-86d4-566f6f4ef946', '3dd505bc-5674-5aa8-8c9a-4723ef0c7b1d', 'أُسقطت قطرةٌ من حمض كلور الماء المخفّف على صخرةٍ فظهر فورانٌ وفقاعات غاز. ما نوع هذه الصخرة؟', '[{"id":"a","text":"صخرةٌ رمليّة"},{"id":"b","text":"صخرةٌ كلسيّة"},{"id":"c","text":"صخرةٌ طينيّة"},{"id":"d","text":"صخرةٌ بركانيّة"}]'::jsonb, 'b', 'الصخرة الكلسيّة غنيّةٌ بكربونات الكلسيوم، فتتفاعل مع الحمض المخفّف ويظهر فورانٌ (انطلاق غاز ثاني أكسيد الكربون). الرمل والطين لا يفوران، وهذا الاختبار يميّز الكلس بسرعة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0a5f9e3b-e5bb-566c-a63f-4b23652d52af', '3dd505bc-5674-5aa8-8c9a-4723ef0c7b1d', 'لماذا لا نجد أبدًا مستحاثاتٍ داخل الصخور الصهاريّة (البركانيّة)؟', '[{"id":"a","text":"لأنّها صخورٌ قديمةٌ جدًّا فقط"},{"id":"b","text":"لأنّ الكائنات لم تكن موجودةً حين تشكّلت"},{"id":"c","text":"لأنّ حبيباتها كبيرةٌ جدًّا فلا تحفظ البقايا"},{"id":"d","text":"لأنّها تتكوّن من مادّةٍ منصهرةٍ حارّةٍ تُتلف كلّ أثرٍ للحياة"}]'::jsonb, 'd', 'تتكوّن الصخرة الصهاريّة من تبرّد صهارةٍ منصهرةٍ شديدة الحرارة، وهذه الحرارة تُتلف أيّ بقايا كائنٍ حيّ. لذلك تُحفظ المستحاثات في الصخور الرسوبيّة فقط.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fd63dcf8-8a29-54ff-b7a1-c006e8d1d7be', '3dd505bc-5674-5aa8-8c9a-4723ef0c7b1d', 'عُثر في هضبةٍ صحراويّةٍ يابسةٍ اليوم على صخرةٍ كلسيّةٍ مليئةٍ بأصدافٍ بحريّةٍ متحجّرة. ماذا نستنتج؟', '[{"id":"a","text":"أنّ هذه الأصداف نقلتها الرياح من البحر حديثًا"},{"id":"b","text":"أنّ الأصداف نشأت داخل الصخرة نفسها دون كائنات"},{"id":"c","text":"أنّ المنطقة كانت مغمورةً ببحرٍ قديمٍ في الماضي"},{"id":"d","text":"أنّ الصحراء كانت غابةً كثيفة"}]'::jsonb, 'c', 'المستحاثات البحريّة (كالأصداف) دليلٌ على البيئة القديمة: وجودها في منطقةٍ يابسةٍ اليوم يعني أنّ بحرًا قديمًا غمر المكان، وترسّبت فيه الأصداف ثم تحوّلت مع رواسبها إلى صخرةٍ كلسيّة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a21ae9db-0ea7-523b-96b6-e4a6d391d1ce', '0a3bf243-c415-57eb-b300-dcd8259e6f0d', 'sciences-vie-terre-8eme', '⭐ تمرين: الصخور الرسوبية والمستحاثات', 1, 50, 10, 'practice', 'admin', 1)
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
  ('9ea0e9f0-2998-5b24-aba7-64755b200d5c', 'a21ae9db-0ea7-523b-96b6-e4a6d391d1ce', 'تتراكم في مصبّ وادي الرمّال حبيباتٌ صغيرةٌ ثم تتصلّب مع الزمن مكوّنةً صخرة. إلى أيّ صنفٍ من الصخور تنتمي؟', '[{"id":"a","text":"صخرة رسوبيّة"},{"id":"b","text":"صخرة صهاريّة (بركانيّة)"},{"id":"c","text":"معدنٌ منصهر"},{"id":"d","text":"صهارةٌ خرجت من بركان"}]'::jsonb, 'a', 'تكوّن الصخرة بتراكم الرواسب قرب سطح الأرض ثم تصلّبها يجعلها صخرةً رسوبيّة، لا صهاريّةً (التي تنتج عن تبرّد الصهارة).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('81019d7c-47ea-5ea7-9b62-5aa5481f65e4', 'a21ae9db-0ea7-523b-96b6-e4a6d391d1ce', 'لاحظ تلميذٌ صخرةً ذات حبيباتٍ صغيرةٍ مرئيّةٍ بالعين، يتسرّب الماء عبرها بسهولة. ما هذه الصخرة؟', '[{"id":"a","text":"الطين"},{"id":"b","text":"الكلس"},{"id":"c","text":"الرمل (الحجر الرمليّ)"},{"id":"d","text":"الغرانيت"}]'::jsonb, 'c', 'الرمل والحجر الرمليّ حبيباتهما صغيرةٌ لكن مرئيّةٌ بالعين، والصخرة نفوذةٌ يتسرّب الماء عبرها بسهولة. أمّا الطين فحبيباته دقيقةٌ جدًّا والصخرة كتيمة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('07ccbd12-28ca-564f-94b0-3e3cfd8d56d0', 'a21ae9db-0ea7-523b-96b6-e4a6d391d1ce', 'ما الخاصّية المميّزة للصخرة الكلسيّة عند وضع قطرةٍ من حمض كلور الماء المخفّف عليها؟', '[{"id":"a","text":"تتصلّب أكثر"},{"id":"b","text":"يظهر فورانٌ وفقاعات غاز"},{"id":"c","text":"تتلوّن بالأزرق"},{"id":"d","text":"لا يحدث أيّ تغيّر"}]'::jsonb, 'b', 'الكلس يتفاعل مع الحمض المخفّف فينطلق غاز ثاني أكسيد الكربون على شكل فورانٍ وفقاعات؛ وهذا هو الاختبار الذي يميّز الصخرة الكلسيّة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a5e102f3-c9bd-5c11-ac3a-ecdc66a1fdce', 'a21ae9db-0ea7-523b-96b6-e4a6d391d1ce', 'ما المستحاثة؟', '[{"id":"a","text":"حجرٌ ملوّنٌ جميلٌ فقط"},{"id":"b","text":"نوعٌ من المعادن الثمينة"},{"id":"c","text":"كائنٌ حيٌّ يعيش داخل الصخور اليوم"},{"id":"d","text":"بقايا كائنٍ حيٍّ عاش في الماضي أو أثرٌ تركه، محفوظٌ في صخرة رسوبيّة"}]'::jsonb, 'd', 'المستحاثة هي بقايا كائنٍ حيّ (نبات أو حيوان) عاش في الماضي، أو أثرٌ تركه كبصمة ورقةٍ أو أثر أقدام، حُفظ داخل صخرة رسوبيّة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6b7a8e25-0b5a-59bb-b7b0-414c74058d05', 'a21ae9db-0ea7-523b-96b6-e4a6d391d1ce', 'رتّب المراحل الأولى في تشكّل صخرةٍ رسوبيّة بدءًا من صخرةٍ قديمة.', '[{"id":"a","text":"تعرية ← نقل ← ترسّب"},{"id":"b","text":"ترسّب ← تعرية ← نقل"},{"id":"c","text":"نقل ← تعرية ← ترسّب"},{"id":"d","text":"ترسّب ← نقل ← تعرية"}]'::jsonb, 'a', 'تبدأ السلسلة بالتعرية التي تُفتّت الصخرة، ثم النقل الذي يحمل الفُتات، ثم الترسّب حيث تستقرّ الحبيبات وتتراكم. أيّ ترتيبٍ آخر يعكس منطق العمليّة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0609b3a4-7734-5128-87ec-29e16ce11464', 'a21ae9db-0ea7-523b-96b6-e4a6d391d1ce', 'أيّ صنفٍ من الصخور وحده يمكن أن يحتوي على مستحاثات؟', '[{"id":"a","text":"الصخور الصهاريّة (البركانيّة)"},{"id":"b","text":"كلّ الصخور دون استثناء"},{"id":"c","text":"الصخور الرسوبيّة"},{"id":"d","text":"لا شيء من الصخور يحتوي مستحاثات"}]'::jsonb, 'c', 'المستحاثات لا تُحفظ إلّا في الصخور الرسوبيّة، لأنّ الصخور الصهاريّة تتكوّن من مادّةٍ منصهرةٍ حارّةٍ تُتلف كلّ أثرٍ للحياة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8ac69b4a-9d35-5e3f-a112-c8db0520945b', '0a3bf243-c415-57eb-b300-dcd8259e6f0d', 'sciences-vie-terre-8eme', '⚔️ زعيم الفصل ⭐⭐⭐: الصخور الرسوبية والمستحاثات', 3, 120, 30, 'boss', 'admin', 2)
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
  ('8561a29c-632a-58bf-9610-567f18a29058', '8ac69b4a-9d35-5e3f-a112-c8db0520945b', 'أثناء رحلةٍ ميدانيّة، جمع فريقٌ ثلاث صخور: الأولى تفور مع الحمض المخفّف، والثانية حبيباتها مرئيّةٌ ونفوذة، والثالثة صهاريّةٌ لامعةٌ متبلورة. أيّ الصخور الثلاث قد تحتوي على مستحاثات؟', '[{"id":"a","text":"الثالثة فقط (الصهاريّة)"},{"id":"b","text":"الثلاث جميعًا"},{"id":"c","text":"الأولى والثانية (الكلسيّة والرمليّة)"},{"id":"d","text":"لا صخرة منها"}]'::jsonb, 'c', 'الأولى (كلسيّة) والثانية (رمليّة) صخرتان رسوبيّتان فقد تحويان مستحاثات. أمّا الثالثة الصهاريّة فلا تحوي مستحاثات أبدًا لأنّها تكوّنت من صهارةٍ حارّةٍ تُتلف كلّ أثرٍ للحياة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c1b35865-2bfa-54da-95df-fd31c753349b', '8ac69b4a-9d35-5e3f-a112-c8db0520945b', 'في مقطعٍ جيولوجيّ بهضبة أَملال ظهرت من الأسفل إلى الأعلى: طبقة رمل، ثم طبقة طين، ثم طبقة كلس تعلوها كلّها. ما الترتيب الزمنيّ لترسّبها من الأقدم إلى الأحدث؟', '[{"id":"a","text":"الرمل ثم الطين ثم الكلس"},{"id":"b","text":"الكلس ثم الطين ثم الرمل"},{"id":"c","text":"الطين ثم الرمل ثم الكلس"},{"id":"d","text":"ترسّبت الطبقات الثلاث في اللحظة نفسها"}]'::jsonb, 'a', 'الطبقة السفلى الأقدم والعليا الأحدث. الرمل في الأسفل فهو الأقدم، ثم الطين، ثم الكلس في الأعلى وهو الأحدث. اختيار الكلس أوّلًا يعكس قاعدة التعاقب.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c3c4df8b-54a3-5bab-b8ee-1a81087cc33b', '8ac69b4a-9d35-5e3f-a112-c8db0520945b', 'عُثر في طبقةٍ رسوبيّةٍ عميقةٍ على مستحاثة (أ)، وفي طبقةٍ أعلى منها على مستحاثة (ب). ماذا نستنتج عن عمر الكائنَين؟', '[{"id":"a","text":"لا يمكن استنتاج شيءٍ من موقع الطبقات"},{"id":"b","text":"الكائن (ب) أقدم من الكائن (أ)"},{"id":"c","text":"الكائنان في العمر نفسه تمامًا"},{"id":"d","text":"الكائن (أ) أقدم من الكائن (ب)"}]'::jsonb, 'd', 'المستحاثة في الطبقة الأعمق (أ) ترسّبت أوّلًا فهي أقدم، والمستحاثة في الطبقة الأعلى (ب) أحدث. بهذه القاعدة تُرتّب أحداث الماضي.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('89ee34bb-8a4e-5bc7-a538-f0b94c635e2f', '8ac69b4a-9d35-5e3f-a112-c8db0520945b', 'لماذا لا تُعدّ حشرةٌ ماتت اليوم على سطح الأرض مكشوفةً للهواء مرشّحةً لأن تصبح مستحاثة؟', '[{"id":"a","text":"لأنّ الحشرات لا تتحفّظ إطلاقًا في أيّ حال"},{"id":"b","text":"لأنّها لم تُدفن سريعًا، فستتحلّل أو تأكلها المحلّلات قبل التحفّظ"},{"id":"c","text":"لأنّها كائنٌ صغيرٌ جدًّا لا يترك أيّ أثر"},{"id":"d","text":"لأنّ التحفّظ يحدث فورًا في اليوم نفسه"}]'::jsonb, 'b', 'شرط التحفّظ دفنٌ سريع تحت الرواسب قبل التحلّل. جثّةٌ مكشوفةٌ في الهواء تتعرّض للتعفّن وللكائنات المحلّلة فتزول قبل أن تتحجّر. (وليس أنّ الحشرات لا تتحفّظ مطلقًا؛ فقد تتحفّظ إن دُفنت سريعًا.)', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c9dc5040-a907-5187-b603-3eed11972adb', '8ac69b4a-9d35-5e3f-a112-c8db0520945b', 'وجد جيولوجيّ في جبل الأصداف بصمةً واضحةً لورقة نباتٍ منطبعةً في صخرةٍ رسوبيّة، دون بقايا الورقة نفسها. كيف نصنّف هذه المستحاثة؟', '[{"id":"a","text":"أثرٌ تركه الكائن"},{"id":"b","text":"بقايا مباشرة للكائن"},{"id":"c","text":"ليست مستحاثةً لأنّ الورقة نفسها غائبة"},{"id":"d","text":"صخرةٌ صهاريّة"}]'::jsonb, 'a', 'البصمة أو القالب الذي يتركه الكائن دون بقاياه المباشرة يُصنّف ضمن المستحاثات من نوع «الآثار»، وهي مستحاثةٌ حقيقيّةٌ تدلّ على وجود الكائن رغم غياب جسمه.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('65d849e9-28eb-52ab-8ae9-a11d57716e74', '8ac69b4a-9d35-5e3f-a112-c8db0520945b', 'اكتشف باحثٌ في سبخة المرجان طبقةً كلسيّةً مليئةً بمستحاثاتٍ لمرجانٍ وأصدافٍ بحريّة، بينما المكان اليوم يابسٌ بعيدٌ عن البحر. ما الاستنتاج الأدقّ؟', '[{"id":"a","text":"أنّ المرجان يعيش حاليًّا في اليابسة الجافّة"},{"id":"b","text":"أنّ هذه المستحاثات نُقلت من متحفٍ قريب"},{"id":"c","text":"أنّ بحرًا قديمًا غمر المكان في الماضي ثم انحسر"},{"id":"d","text":"أنّ الطبقة الكلسيّة صخرةٌ صهاريّة"}]'::jsonb, 'c', 'مستحاثات كائناتٍ بحريّة (مرجان، أصداف) في منطقةٍ يابسةٍ اليوم دليلٌ على أنّ المكان كان مغمورًا ببحرٍ قديمٍ حين عاشت تلك الكائنات، ثم انحسر البحر. هذه هي دلالة المستحاثات على البيئة القديمة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('17d15e9f-d5cb-53e0-a41a-642dc835edd1', '0a3bf243-c415-57eb-b300-dcd8259e6f0d', 'sciences-vie-terre-8eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الصخور الرسوبية والمستحاثات', 2, 70, 15, 'practice', 'admin', 3)
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
  ('b6bfda33-c846-5021-a67a-5726ba5a00b1', '17d15e9f-d5cb-53e0-a41a-642dc835edd1', 'أيّ خاصّيةٍ من الخصائص التالية تُميّز الصخور الرسوبيّة عن الصخور الصهاريّة؟', '[{"id":"a","text":"الصلابة الشديدة دائمًا"},{"id":"b","text":"لونها الأسود دائمًا"},{"id":"c","text":"تكوّنها من تبرّد الصهارة"},{"id":"d","text":"ترتّبها في طبقاتٍ واحتمال احتوائها على مستحاثات"}]'::jsonb, 'd', 'من علامات الصخور الرسوبيّة أنّها تترتّب في طبقات وقد تحتوي مستحاثات. أمّا التكوّن من تبرّد الصهارة فهو خاصّية الصخور الصهاريّة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f8c552d5-9487-576c-afde-7ea2e53d21ab', '17d15e9f-d5cb-53e0-a41a-642dc835edd1', 'في جُرف تينْزارت الكلسيّ، تظهر طبقاتٌ رسوبيّةٌ بعضها فوق بعض. أيّ الطبقات هي الأقدم؟', '[{"id":"a","text":"الطبقة العليا"},{"id":"b","text":"الطبقة الوسطى دائمًا"},{"id":"c","text":"الطبقة السفلى"},{"id":"d","text":"لا يمكن ترتيبها إطلاقًا"}]'::jsonb, 'c', 'تترسّب الطبقة السفلى أوّلًا ثم تعلوها الأحدث، فالطبقة السفلى هي الأقدم والعليا هي الأحدث (ما لم تنقلب الطبقات). هذه قاعدة التعاقب.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('76f2eeb9-99a3-5e86-9ecd-e25668921c18', '17d15e9f-d5cb-53e0-a41a-642dc835edd1', 'لماذا نجد أصداف الرخويّات وعظام الحيوانات متحجّرةً أكثر بكثيرٍ من أجزائها الليّنة كالجلد والعضلات؟', '[{"id":"a","text":"لأنّ الأجزاء الصلبة تقاوم التحلّل مدّةً أطول فتُحفظ في الصخرة"},{"id":"b","text":"لأنّ الأجزاء الليّنة لا توجد في الكائنات الحيّة"},{"id":"c","text":"لأنّ الأجزاء الليّنة تتحوّل إلى معادن ثمينة"},{"id":"d","text":"لأنّ الأصداف تتكاثر داخل الصخور"}]'::jsonb, 'a', 'الأجزاء الصلبة (عظام، أصداف، أسنان) تقاوم التعفّن والتحلّل مدّةً أطول من الأجزاء الليّنة، فتزداد فرصة دفنها وتحجّرها وتحفّظها في الصخرة الرسوبيّة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('65077a49-8016-576a-b497-55e666cf2092', '17d15e9f-d5cb-53e0-a41a-642dc835edd1', 'أين يحدث الترسّب عادةً أثناء تشكّل الصخور الرسوبيّة؟', '[{"id":"a","text":"في وسط الوادي حيث الماء أشدّ جريانًا"},{"id":"b","text":"حيث تضعف سرعة الماء أو الريح كالبحيرات وقيعان البحار"},{"id":"c","text":"في قمم الجبال المرتفعة"},{"id":"d","text":"داخل البراكين النشطة"}]'::jsonb, 'b', 'يحمل الماء السريع الحبيبات؛ وحين تضعف سرعته (في بحيرةٍ أو مصبٍّ أو قاع بحرٍ هادئ) تسقط الحبيبات وتترسّب. الماء الأشدّ جريانًا ينقل ولا يُرسّب.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b1ffc666-c64a-5cb6-b65b-3343c8d22912', '17d15e9f-d5cb-53e0-a41a-642dc835edd1', 'صخرةٌ مجهولةٌ حبيباتها دقيقةٌ جدًّا لا تُرى بالعين، تصبح لدنةً لزجةً عند بلّها، ويصعب مرور الماء عبرها. ما هي؟', '[{"id":"a","text":"الحجر الرمليّ"},{"id":"b","text":"البازلت"},{"id":"c","text":"الكلس"},{"id":"d","text":"الطين"}]'::jsonb, 'd', 'الحبيبات الدقيقة جدًّا واللدونة عند البلّ والكتامة (صعوبة مرور الماء) كلّها خصائص الطين، خلافًا للرمل النفوذ ذي الحبيبات المرئيّة.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('40a177b9-b107-598b-a01c-ffbc4b2c5dec', '17d15e9f-d5cb-53e0-a41a-642dc835edd1', 'ما الشرط الأساسيّ الذي يجب توفّره حتى يتحوّل كائنٌ ميّتٌ إلى مستحاثة؟', '[{"id":"a","text":"أن يُدفن سريعًا تحت الرواسب قبل تحلّله"},{"id":"b","text":"أن يبقى مكشوفًا في الهواء مدّةً طويلة"},{"id":"c","text":"أن يموت داخل صخرةٍ بركانيّة"},{"id":"d","text":"أن يكون كائنًا مجهريًّا فقط"}]'::jsonb, 'a', 'التحفّظ نادرٌ ويشترط دفنًا سريعًا تحت الرواسب قبل أن تتحلّل الجثّة أو تأكلها الكائنات المحلّلة. البقاء مكشوفًا في الهواء يؤدّي إلى التحلّل لا التحفّظ.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('cd918789-bf7f-5538-886a-668d0b256493', '0a3bf243-c415-57eb-b300-dcd8259e6f0d', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: الصخور الرسوبية والمستحاثات', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('7deba26f-bf5a-5b03-9780-b6a581c014f6', 'cd918789-bf7f-5538-886a-668d0b256493', 'في جُرف تينْزارت، من الأسفل إلى الأعلى: طبقة كلسٍ بها مستحاثات مرجانٍ بحريّ، تعلوها طبقة طينٍ بها مستحاثات نباتاتٍ قارّيّة، تعلوها طبقة رملٍ صحراويّ. ما القراءة الأصحّ لتاريخ المكان من الأقدم إلى الأحدث؟', '[{"id":"a","text":"بحر ← وسط قارّيّ رطب ← صحراء"},{"id":"b","text":"صحراء ← وسط قارّيّ رطب ← بحر"},{"id":"c","text":"بحر ← صحراء ← وسط قارّيّ رطب"},{"id":"d","text":"الأوساط الثلاثة وُجدت في الوقت نفسه"}]'::jsonb, 'a', 'الطبقة السفلى الأقدم: الكلس بمرجانٍ بحريّ = بحرٌ قديم؛ ثم الطين بنباتاتٍ قارّيّة = وسطٌ قارّيّ رطب؛ ثم الرمل الصحراويّ في الأعلى = بيئةٌ صحراويّة أحدث. تُقرأ المستحاثات مع ترتيب الطبقات معًا.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a13f9675-b4dd-54b4-8429-55359923f8de', 'cd918789-bf7f-5538-886a-668d0b256493', 'يريد فريقٌ إثبات أنّ منطقةً صحراويّةً كانت مغمورةً ببحرٍ قديم. أيّ دليلٍ ميدانيٍّ يكون الأقوى؟', '[{"id":"a","text":"وجود رمالٍ صفراء كثيرةٍ على السطح"},{"id":"b","text":"وجود صخورٍ صهاريّةٍ متبلورة"},{"id":"c","text":"ارتفاع حرارة المنطقة نهارًا"},{"id":"d","text":"وجود صخرةٍ رسوبيّةٍ تحوي مستحاثاتٍ بحريّة (أصداف، مرجان)"}]'::jsonb, 'd', 'المستحاثات البحريّة داخل صخرةٍ رسوبيّةٍ في مكانٍ يابسٍ اليوم هي البصمة المباشرة لبيئةٍ بحريّةٍ قديمة. الرمال أو الحرارة لا تدلّان على بحرٍ سابق، والصخور الصهاريّة لا تحمل مستحاثاتٍ أصلًا.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d170f475-fd36-5ed6-9d2b-fd52e4fa5b5b', 'cd918789-bf7f-5538-886a-668d0b256493', 'زعم تلميذٌ: «كلّ كائنٍ بحريٍّ يموت يتحوّل حتمًا إلى مستحاثة، لذلك قاع كلّ بحرٍ مليءٌ بالمستحاثات». أين الخطأ المنطقيّ؟', '[{"id":"a","text":"لا خطأ؛ فعلًا كلّ كائنٍ بحريٍّ يتحفّظ"},{"id":"b","text":"التحفّظ نادرٌ ومشروطٌ (دفنٌ سريع وأجزاء صلبة)، فأغلب الجثث تتحلّل ولا تتحفّظ"},{"id":"c","text":"الكائنات البحريّة لا تموت في قاع البحر"},{"id":"d","text":"المستحاثات تتكوّن في الصخور الصهاريّة تحت البحر"}]'::jsonb, 'b', 'التحفّظ استثناءٌ لا قاعدة: يشترط دفنًا سريعًا ووجود أجزاء صلبةٍ ووسطًا يحمي من التعفّن. معظم الكائنات تتحلّل أو تأكلها المحلّلات فلا تصبح مستحاثات؛ لذا قاع البحر ليس «مليئًا» بها.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('661f54df-8f14-52d5-8339-4e0b75712894', 'cd918789-bf7f-5538-886a-668d0b256493', 'لدينا مستحاثتان: (م1) في صخرةٍ كلسيّةٍ تحوي أصدافًا بحريّة، و(م2) في صخرةٍ رمليّةٍ تحوي آثار أقدامٍ لزواحف يابسة. لو وُجدت (م1) في طبقةٍ أسفل (م2) في المقطع نفسه، ما الاستنتاج المزدوج الصحيح؟', '[{"id":"a","text":"(م2) أقدم من (م1)، وكان المكان يابسًا ثم صار بحرًا"},{"id":"b","text":"المستحاثتان في العمر نفسه، والبيئة لم تتغيّر"},{"id":"c","text":"(م1) أقدم من (م2)، وكان المكان بحرًا ثم انحسر وصار يابسًا"},{"id":"d","text":"لا يمكن استنتاج العمر ولا البيئة"}]'::jsonb, 'c', '(م1) في الطبقة السفلى فهي الأقدم، وبيئتها بحريّة (أصداف)؛ (م2) أعلى فهي أحدث، وبيئتها يابسة (آثار أقدام زواحف). فالمكان كان بحرًا ثم انحسر وصار يابسًا. يُجمع بين قاعدة التعاقب ودلالة المستحاثات على البيئة.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b0b019b0-0899-5bcd-86f9-993436977fb4', 'cd918789-bf7f-5538-886a-668d0b256493', 'لماذا يُعدّ الترسّب في وسطٍ مائيٍّ هادئ (بحيرة، قاع بحر) بيئةً مثاليّةً لتشكّل المستحاثات مقارنةً بسفح جبلٍ منحدرٍ جافّ؟', '[{"id":"a","text":"لأنّ الرواسب تتراكم بهدوءٍ فتدفن البقايا سريعًا وتحميها من التحلّل، بخلاف السفح المكشوف"},{"id":"b","text":"لأنّ الماء الهادئ يذيب العظام والأصداف بسرعة"},{"id":"c","text":"لأنّ السفح المنحدر يدفن البقايا أسرع من قاع البحر"},{"id":"d","text":"لأنّ الماء الهادئ يمنع تكوّن الطبقات نهائيًّا"}]'::jsonb, 'a', 'في الوسط الهادئ تترسّب الحبيبات باستمرارٍ وتدفن البقايا سريعًا فتحميها من الهواء والمحلّلات، وهو شرط التحفّظ. أمّا السفح المنحدر الجافّ فتُجرف منه المواد وتبقى البقايا مكشوفةً فتتحلّل.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e48ee862-8fee-55ae-ba48-4f2a4b34db9d', 'cd918789-bf7f-5538-886a-668d0b256493', 'أُعطي فريقٌ صخرةً: لا تفور مع الحمض، حبيباتها دقيقةٌ جدًّا لا تُرى، كتيمةٌ تحبس الماء، وتحوي بصمة سمكة. ما التصنيف الكامل الصحيح؟', '[{"id":"a","text":"صخرةٌ كلسيّةٌ صهاريّةٌ بلا مستحاثات"},{"id":"b","text":"صخرةٌ رمليّةٌ نفوذةٌ تحوي بقايا مباشرة"},{"id":"c","text":"صخرةٌ صهاريّةٌ لا يمكن أن تحوي أيّ أثرٍ للحياة"},{"id":"d","text":"صخرةٌ طينيّةٌ رسوبيّةٌ تحوي مستحاثةً من نوع أثر (بصمة)"}]'::jsonb, 'd', 'عدم الفوران يستبعد الكلس، والحبيبات الدقيقة جدًّا والكتامة تدلّان على الطين (لا الرمل النفوذ). وجود بصمةٍ يعني أنّها صخرةٌ رسوبيّةٌ تحوي مستحاثةً من نوع «أثر». والصخرة الصهاريّة لا تحوي مستحاثاتٍ أصلًا.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8b56d09c-ff32-5fa3-a581-fb3fbc49e087', '0a3bf243-c415-57eb-b300-dcd8259e6f0d', 'sciences-vie-terre-8eme', '📝 تدريب ⭐⭐⭐ (مراجعة شاملة): الصخور الرسوبية والمستحاثات', 3, 120, 30, 'boss', 'admin', 5)
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
  ('352fb790-1625-5b3b-ae8c-95db3f8cf1eb', '8b56d09c-ff32-5fa3-a581-fb3fbc49e087', 'أراد تلميذٌ التمييز بين صخرةٍ كلسيّةٍ وأخرى رمليّةٍ متشابهتَي اللون. ما التجربة الحاسمة التي يجريها؟', '[{"id":"a","text":"يزن كلّ صخرةٍ ويقارن الكتلتَين"},{"id":"b","text":"يضع قطرةً من حمض كلور الماء المخفّف ويراقب أيّهما يفور"},{"id":"c","text":"يعرّض الصخرتَين للشمس ويقارن حرارتهما"},{"id":"d","text":"يكسر كلّ صخرةٍ ويقارن الصوت"}]'::jsonb, 'b', 'اختبار الحمض المخفّف حاسم: الكلس يفور (ينطلق ثاني أكسيد الكربون) بينما الرمل لا يفور. الوزن أو الحرارة أو الصوت لا تميّز نوع الصخرة.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c0bca24e-2b42-5375-b6cc-756da615d8c1', '8b56d09c-ff32-5fa3-a581-fb3fbc49e087', 'ما دور «التصلّب» في المرحلة الأخيرة من تشكّل الصخرة الرسوبيّة؟', '[{"id":"a","text":"تماسك حبيبات الرواسب والتحامها لتصبح صخرةً صلبة"},{"id":"b","text":"تفتيت الرواسب إلى حبيباتٍ أصغر"},{"id":"c","text":"نقل الرواسب إلى البحر"},{"id":"d","text":"إذابة الرواسب في الماء"}]'::jsonb, 'a', 'التصلّب هو تماسك حبيبات الرواسب المتراكمة والتحامها، تحت ثقل الطبقات العليا وبمرور الزمن، فتتحوّل الرواسب المفكّكة إلى صخرةٍ صلبة. أمّا التفتيت فهو دور التعرية في البداية.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b6def6c8-bafb-5015-b2d0-9da871a3fb28', '8b56d09c-ff32-5fa3-a581-fb3fbc49e087', 'أيّ سلسلةٍ تصف بشكلٍ صحيحٍ ومكتملٍ تشكّل صخرةٍ رسوبيّة من صخرةٍ قديمة؟', '[{"id":"a","text":"نقل ← ترسّب ← تعرية ← تصلّب"},{"id":"b","text":"تصلّب ← ترسّب ← نقل ← تعرية"},{"id":"c","text":"تعرية ← نقل ← ترسّب ← تراكم في طبقات ← تصلّب"},{"id":"d","text":"تراكم في طبقات ← تعرية ← نقل ← ترسّب"}]'::jsonb, 'c', 'الترتيب الصحيح: تعرية تُفتّت الصخرة، ثم نقلٌ للفُتات، ثم ترسّبٌ حين تضعف السرعة، ثم تراكمٌ في طبقات، وأخيرًا تصلّبٌ تحت ثقل الطبقات العليا.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('17a7c13e-41ad-51b5-9aee-7331fbcff65f', '8b56d09c-ff32-5fa3-a581-fb3fbc49e087', 'كائنان ماتا في اللحظة نفسها: الأوّل سمكةٌ غرقت في قاع بحيرةٍ فغطّتها الرواسب بسرعة، والثاني غزالٌ نفق في العراء. أيّهما أقرب إلى أن يصبح مستحاثة، ولماذا؟', '[{"id":"a","text":"الغزال، لأنّه أكبر حجمًا"},{"id":"b","text":"لا أحد منهما يمكن أن يتحفّظ"},{"id":"c","text":"كلاهما بالقدر نفسه لأنّهما ماتا معًا"},{"id":"d","text":"السمكة، لأنّها دُفنت سريعًا تحت الرواسب"}]'::jsonb, 'd', 'التحفّظ يشترط دفنًا سريعًا يحمي من التحلّل. السمكة غطّتها رواسب القاع سريعًا فزادت فرصتها، بينما الغزال في العراء يتعرّض للتعفّن والمحلّلات. الحجم أو تزامن الموت لا يحدّدان التحفّظ.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7266d865-f741-57c7-8ce7-62f53de384a2', '8b56d09c-ff32-5fa3-a581-fb3fbc49e087', 'خلط تلميذٌ بين الصخرة الرسوبيّة والصهاريّة. أيّ عبارةٍ من التالي صحيحةٌ تمامًا؟', '[{"id":"a","text":"كلتاهما تتكوّن بتراكم الرواسب وتحتويان مستحاثات"},{"id":"b","text":"الرسوبيّة قد تحوي مستحاثاتٍ وتترتّب في طبقات، والصهاريّة تنشأ من تبرّد الصهارة ولا تحوي مستحاثات"},{"id":"c","text":"الصهاريّة تترتّب في طبقاتٍ والرسوبيّة تنشأ من الصهارة"},{"id":"d","text":"لا فرق بينهما في طريقة التكوّن"}]'::jsonb, 'b', 'الرسوبيّة تنشأ بتراكم الرواسب وتصلّبها، تترتّب في طبقاتٍ وقد تحوي مستحاثات؛ الصهاريّة تنشأ من تبرّد الصهارة ولا تحوي مستحاثاتٍ أبدًا. بقيّة العبارات تخلط بين خصائص الصنفَين.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('845e66b2-7bd4-557e-9ec3-1f94398f516a', '8b56d09c-ff32-5fa3-a581-fb3fbc49e087', 'بمَ تفيد مستحاثةٌ لكائنٍ انقرض ولم يعد له وجودٌ اليوم في فهمنا لتاريخ الأرض؟', '[{"id":"a","text":"لا تفيد بشيءٍ ما دام الكائن غير موجود"},{"id":"b","text":"تدلّ على أنّ الكائن ما زال يعيش في مكانٍ آخر"},{"id":"c","text":"تشهد بأنّ كائناتٍ عاشت في الماضي ثم زالت، فتُطلعنا على أحياءٍ سابقةٍ للحاضر"},{"id":"d","text":"تثبت أنّ الأرض حديثة العمر"}]'::jsonb, 'c', 'المستحاثة شاهدٌ على الماضي: تثبت أنّ كائناتٍ عاشت قديمًا ثم انقرض بعضها، فتكشف لنا أحياءً لم نرها قطّ وتساعد على فهم تعاقب الحياة عبر الزمن.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('fa5ea997-8419-5f7a-818c-d267940bc71b', '0a3bf243-c415-57eb-b300-dcd8259e6f0d', 'sciences-vie-terre-8eme', '👑 تحدّي النخبة ⭐⭐⭐⭐ (القمّة): الصخور الرسوبية والمستحاثات', 4, 300, 60, 'challenge', 'admin', 6)
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
  ('dc8e65fb-4444-56d0-bd46-793445f1c005', 'fa5ea997-8419-5f7a-818c-d267940bc71b', 'في مقطعٍ بسهل بني غزلان، طبقتان أفقيّتان: السفلى كلسٌ بمستحاثاتٍ بحريّة، والعليا رملٌ بمستحاثاتٍ قارّيّة، وبينهما سطحٌ يفصلهما بوضوح. ما التفسير الجيولوجيّ الأصحّ؟', '[{"id":"a","text":"تشكّلت الطبقتان في اللحظة نفسها في البيئة نفسها"},{"id":"b","text":"ترسّب الرمل أوّلًا في اليابسة ثم غمره البحر فترسّب الكلس فوقه"},{"id":"c","text":"ترسّب الكلس أوّلًا في بحرٍ قديم، ثم انحسر البحر وترسّب الرمل في وسطٍ قارّيٍّ لاحق"},{"id":"d","text":"الطبقتان صخرتان صهاريّتان تبرّدتا معًا"}]'::jsonb, 'c', 'الطبقة السفلى الأقدم (كلسٌ بحريّ = بحرٌ قديم)، ثم الطبقة العليا الأحدث (رملٌ قارّيّ = يابسة). فالتسلسل: بحرٌ ثم انحسارٌ ثم وسطٌ قارّيّ. الخيار (ب) يعكس ترتيب الطبقات، و(د) يخلط الرسوبيّ بالصهاريّ.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e17780d8-a076-5766-8bba-6a49513acf41', 'fa5ea997-8419-5f7a-818c-d267940bc71b', 'اقترح تلميذٌ أنّ صخرةً تفور مع الحمض «قد تكون صهاريّة». كيف تدحض ذلك بحجّةٍ علميّةٍ مزدوجة؟', '[{"id":"a","text":"الفوران دليل كلسٍ (كربونات كلسيوم)، والكلس صخرةٌ رسوبيّةٌ تتشكّل بتراكم بقايا وأصداف، لا من تبرّد صهارة"},{"id":"b","text":"لا يمكن الدحض؛ الصخور الصهاريّة تفور أيضًا"},{"id":"c","text":"الفوران دليلٌ على أنّ الصخرة معدنٌ ثمين"},{"id":"d","text":"الفوران يحدث في كلّ الصخور دون تمييز"}]'::jsonb, 'a', 'الفوران مع الحمض خاصّية الكلس (كربونات الكلسيوم)، والكلس صخرةٌ رسوبيّةٌ تنشأ من تراكم رواسب وأصدافٍ قرب السطح، لا من تبرّد صهارة. فصفةُ الفوران نفسها تصنّفها رسوبيّةً لا صهاريّة.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3d687e3d-010d-5d25-a777-70a62fa44b0c', 'fa5ea997-8419-5f7a-818c-d267940bc71b', 'قارن باحثٌ طبقةً رمليّةً نفوذةً وطبقةً طينيّةً كتيمةً متجاورتَين. لماذا يُتوقّع أن يتجمّع الماء الجوفيّ فوق الطين لا فوق الرمل؟', '[{"id":"a","text":"لأنّ الطين نفوذٌ أكثر من الرمل"},{"id":"b","text":"لأنّ الطين يذيب الماء ويُفنيه"},{"id":"c","text":"لأنّ الرمل يمتصّ كلّ الماء ويحوّله إلى طين"},{"id":"d","text":"لأنّ الطين كتيمٌ يعيق مرور الماء، بينما الرمل نفوذٌ يمرّره، فيُحتجز الماء فوق الطبقة الطينيّة"}]'::jsonb, 'd', 'الرمل نفوذٌ يمرّ الماء عبره بسهولة، والطين كتيمٌ (حبيباته دقيقةٌ جدًّا) يعيق مروره. فحين ينزل الماء عبر الرمل ويصادف الطين يُحتجز فوقه. هذا التباين في النفاذيّة أساس تكوّن طبقات المياه الجوفيّة.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a54a901f-5d9e-5112-8fd1-77d14c5d18e8', 'fa5ea997-8419-5f7a-818c-d267940bc71b', 'مُنع فريقٌ من فتح صخرة، فأُعطي بياناتها فقط: تكوّنت من تبرّد مادّةٍ منصهرةٍ حارّة، متبلورةٌ صلبة، بلا طبقات. هل يُجدي البحث فيها عن مستحاثات؟ ولماذا؟', '[{"id":"a","text":"نعم، فقد تحوي مستحاثاتٍ دقيقة"},{"id":"b","text":"لا، لأنّها صخرةٌ صهاريّة والحرارة المنصهرة تُتلف كلّ أثرٍ للحياة"},{"id":"c","text":"نعم، لأنّ كلّ الصخور تحوي مستحاثات"},{"id":"d","text":"لا يمكن الحكم دون فتحها فعليًّا"}]'::jsonb, 'b', 'البيانات (تبرّد مادّةٍ منصهرة، تبلور، غياب الطبقات) تصنّفها صخرةً صهاريّة. والصخور الصهاريّة لا تحوي مستحاثاتٍ أبدًا لأنّ الصهارة الحارّة تُتلف البقايا؛ فالبحث فيها عن مستحاثاتٍ عبثٌ يُعرف حكمه من الوصف وحده.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1bf93965-be03-521e-94b5-e241baf0d800', 'fa5ea997-8419-5f7a-818c-d267940bc71b', 'لماذا تُعدّ الصخور الرسوبيّة تحديدًا «أرشيفًا» لتاريخ الحياة والبيئة على الأرض، دون غيرها من الصخور؟', '[{"id":"a","text":"لأنّها أصلب أنواع الصخور وأطولها بقاءً"},{"id":"b","text":"لأنّها الوحيدة التي تحتوي معادن ثمينة"},{"id":"c","text":"لأنّها تتشكّل بتراكمٍ هادئٍ في طبقاتٍ متعاقبةٍ تدفن البقايا وتحفظها، فتسجّل ترتيب الأحداث والبيئات القديمة"},{"id":"d","text":"لأنّها تتكوّن بسرعةٍ كبيرةٍ في يومٍ واحد"}]'::jsonb, 'c', 'التراكم الطبقيّ المتعاقب يدفن البقايا فيحفظها كمستحاثات، وترتيب الطبقات يسجّل تسلسل الزمن، ونوع المستحاثات يكشف البيئات القديمة. بهذا تكون الصخور الرسوبيّة سجلًّا لتاريخ الحياة، بخلاف الصهاريّة التي لا تحفظ أثرًا.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8c397320-b29b-5b3f-a2da-350cd063bb66', 'fa5ea997-8419-5f7a-818c-d267940bc71b', 'في موقعٍ واحد، وُجدت في الطبقة (1) السفلى مستحاثة كائنٍ ما، وفي الطبقة (3) العليا مستحاثةٌ لكائنٍ آخر، ولم يُعثر على النوعَين معًا في أيّ طبقةٍ وسطى. ما الاستنتاج الأدقّ حول الكائنَين؟', '[{"id":"a","text":"كائن الطبقة السفلى أقدم، وقد عاش كلّ نوعٍ في فترةٍ مختلفةٍ من الزمن"},{"id":"b","text":"الكائنان عاشا في الحقبة نفسها تمامًا وجنبًا إلى جنب"},{"id":"c","text":"كائن الطبقة العليا هو الأقدم لأنّه أقرب إلى السطح"},{"id":"d","text":"لا فرق زمنيّ بينهما ما داما في الموقع نفسه"}]'::jsonb, 'a', 'الطبقة السفلى (1) الأقدم فكائنها أقدم، والعليا (3) الأحدث فكائنها أحدث، وغيابهما معًا يدلّ على أنّهما عاشا في فترتَين مختلفتَين. القربُ من السطح يعني الأحدث لا الأقدم، فالخيار (ج) يعكس القاعدة.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
      AND e.subject_id = 'sciences-vie-terre-8eme'
      AND e.source = 'admin';
  END IF;
END $$;

