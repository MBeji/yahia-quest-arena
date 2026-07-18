-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: physique-1ere-sec (Sciences Physiques)
-- Regenerate with: npm run content:build
-- Source of truth: content/physique-1ere-sec/
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
  ('physique-1ere-sec', 'Sciences Physiques', 'L''électricité, la matière, la mécanique et l''énergie selon le programme officiel de la 1ère année de l''enseignement secondaire (tronc commun) : le phénomène d''électrisation, le circuit électrique, l''intensité et la tension électriques, le dipôle résistor et la loi d''Ohm ; les états physiques de la matière, ses propriétés (dilatation, température, conductivité thermique), la masse (masse volumique, densité) et les changements d''état d''un corps pur ; la mécanique : le mouvement, les actions mécaniques et le poids, forces et équilibre, forces et pression ; enfin l''énergie et son contrôle (sources renouvelables ou non, formes, conservation et conversions, modes de transfert, chaleur, isolation thermique)', 'Observation', 'subject-svt', 'Atom', 2, 'fr', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '1ere-sec'), NULL)
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
      AND e.subject_id = 'physique-1ere-sec'
      AND e.source = 'admin'
      AND q.id NOT IN ('cd81dc68-012d-5b7b-933f-d7435246ca21', 'a86d19a9-30d9-5c8d-90d6-d731fd8c3612', 'ba093546-03bb-5f48-b5ab-332a4678ebf6', '4020c7c3-42ec-5666-ac02-4a7c928298c3', '01ce9519-615d-5193-a9ed-164d0b5a072d', 'd08bd409-bb8d-5a8c-95ab-629c0f9a422f', '2ce36be3-6e4b-52b3-9a1d-7c7f54a6cc84', '51ce21a3-3dd2-5c6f-b861-402f5aafaba0', '2058a83d-ec8d-53f0-861d-a626c400a934', 'bef91dee-3629-5e84-bade-c7522a85fb50', 'bbba134a-f585-5325-9050-883b9fced6ef', '680466e0-720b-5f2b-b901-9d1549225955', '65d44468-4c57-58f6-988e-b41cffdbf06d', '0be8d0a3-98bf-5aa1-89f0-997374ec0922', 'c5fa6f99-06bd-5072-b7c7-c1fe9ec69f4b', '719be2dd-43e5-5a01-9a87-5d3229436d1e', '16fbe64e-9ed9-504b-a6f4-97bcad3e4d60', '593f42be-93b1-539f-9322-a8d575e1a230', 'e471922a-f642-51a7-bb9e-033148f07ab8', 'e6ae6bc1-5f41-5427-8663-966a9f69011b', '3219b52c-4050-536e-a787-d88a78e20a56', '16e4af28-858b-50dd-ab76-15ff08bd3a3d', 'd1eb1423-8c01-5eb0-8f4e-6fcdc490e7bd', 'f06ec153-9a5d-5921-8cee-ee4bc8f28a6d', 'eaded567-35c8-5e33-8c78-4390a0158224', 'c7701a6d-c3a4-5c3c-b9ec-c7924b005f9c', 'ea325711-a531-5ac4-820b-d0830db1e4e8', '84b39c4c-c1a9-5e1a-985c-e0b77e47b62e', '296021ad-7e08-546c-9dbe-aaae56fd29e9', 'e4d55829-3d13-5138-81d0-18c228a57299', '7facd2a5-4bfd-50c2-a843-4959d28528c5', '58838187-63ac-5d6a-94ec-0ebfe67c6383', '485bc1fd-849e-5f84-88cc-38034411f189', '2cbc3e67-cbb2-5fb2-b5cc-573c046492d3', '03340da1-e134-5d23-a6da-4fa8758f7d93', '2b5f857f-c66f-5e1b-9b81-2512f2bf448c', 'f965d026-c959-5dbb-959a-627734428969', 'd58ee35d-e22e-5253-8bb6-4d3968cf2c9f', '64fb427c-c19f-5c39-8663-1d3598b6b47c', 'aa3e6731-bb22-52b1-b36b-b65c012e3b3b', '8720ecf5-db88-5cdc-a041-489b34b363fa', '8b561a76-af87-55be-900d-790038fa5101', '1d07fd26-fb3d-5bf3-9d73-672be638bbfe', 'fdfff668-8cea-5ba3-a664-5e4c24672e98', 'b79494b4-f612-5930-96f7-f80616f6d462', '47981fe7-4f66-5600-afc6-e076e535b7f8', 'eaf88d4d-6b20-5533-a3ce-591bdc9a7900', '0a38a704-d473-5ac3-b4c7-993995d4c29f', '53189c58-507c-56b7-903b-5aecf00ddb48', 'afff4689-031e-56c8-a4bc-a1bea114a14f', 'eeb1aad5-2c6c-50ae-b230-7ca3785764ee', '209983c0-a5b5-5ec3-984e-d29485e28584', '9007d29d-5aa2-5acb-8b20-465475a1ca4d', 'a45667e8-3ab4-54a0-84b4-11b6aa63abdc', '49bf1bda-7235-598d-9788-41f843be864f', 'd431ec8e-8e26-519f-9b15-c24355ed386c', 'a9df8c0b-d628-5ba4-bf5b-0e5b19f805c2', '5b30ac05-ab65-506e-87b6-14e9d6915203', '89ad05de-c572-5581-9325-79a511f17280', '42cbe483-f5da-5c86-88f4-ff14087d8c9c', '21a2da4a-2ccb-57b7-9d1e-64ba4003707b', 'faf9e844-3874-512b-9c3f-7d79e45bd9fe', '8104cc1a-7645-50e1-b7e2-04987db22904', '783d5c76-c42e-5890-9687-67972acd4c70', 'eabf0b7c-56ce-5ef5-a814-1e2e3a3d4613', 'f9c848cd-7dd1-55a0-abff-39fbe5b7f2be', '8fe13c74-52fb-538c-bc1e-d6e131b933a3', 'f6ca22d5-58c4-59e1-b026-5e8a9156bfd5', '8c7567b0-ac54-50ff-841a-32c5e7cd0b83', '0908c2c0-30b4-5855-b726-14ba7fbdb2d7', 'c0217e65-f239-55aa-a831-38a8c11c7a32', 'ce94ce9e-22ab-53dc-a639-6914ba5d7c48', 'f2948742-e856-5312-a4c4-94e961c453cd', 'f2c9f793-58b3-5608-9ef1-9822c13489cf', '71335a8b-4bcf-5a1a-9506-df483e881db2', '32a4e4ff-cb39-5a0f-abb0-280ceffb76b1', '20b0c8ec-40b0-593d-8296-7ca351414023', 'e432b93c-7430-5d50-a3d4-d8e3958391ca', 'f5db2d0c-d850-5039-bfa5-035d1b3b71ba', '4993eff6-9020-5a3e-bdf3-2376e4d0549e', 'e811528a-a241-56fc-a45b-914b217d25e1', 'c2ffa223-7429-560b-9077-67c135a8cb36', '60c4fc30-c54c-5450-802a-95639ccb4945', 'add45e24-fff3-506b-9133-053dd2ae80c3', '2fcb7236-95ac-5676-aa39-df0bb85ff409', '25217386-51db-5e5e-bdc6-0b74467b5ea5', 'abc07094-845e-5b5b-98b6-6dfdf42d1bfe', '671a0763-76ea-516c-b5e0-93363e15b1f0', 'f222edc4-95c0-5c44-ad24-0926e0d7c608', '5eefd557-3a06-5882-abfc-8eecaa9e8c0c', '7cafe90a-730f-5a2d-b90c-d9b0ae44da95', 'd0f28444-ef0a-5d09-bd3f-976e941a5951', 'ae69b3f1-142d-5727-af35-f2061a87bf1a', 'f254c2d6-77d2-5b05-b3ee-8d47bb45418a', '36a7acf2-fb31-539a-9c16-1c54b094e302', '7fa903cb-2892-5e30-a204-5955bd68e873', '9ece779e-0e45-5a9d-8825-a112d328cf42', 'e3efc622-cd7b-5914-971c-fd2bc0af9bbd', '61a6a809-b368-5682-a878-5df72a0ffd6c', 'a0479655-43aa-551a-aabc-8bb6a0ccf566', 'c61b00a6-b4d6-5ebd-8fc1-271594a559b0', '0a18a7a3-5b30-5e16-ac86-5579b6571c38', '4e48535a-8747-5264-8460-6055c9dc55cc', '9544663c-43ec-5fb0-9050-a8b7e49ea42f', '7168b5a2-cf82-5029-b45b-e71c258083f9', '4579525f-f116-5a0f-8166-a9358fc74f60', '79b10bca-3e49-569a-83e9-ea426f3e017f', 'f36da336-ef77-5cee-8c64-2b7e75504968', 'becb03c1-56f3-579c-a1c2-f73cfc84c3f8', '9405bc80-f2a0-5785-8204-09e75334d255', '21a14880-73c3-559f-85ee-e648ffd4adce', 'cbac5a2f-a278-52db-88d6-f4738159afe4', '0a8fd254-8e16-5bc5-8de0-5c81d8a439d0', '13b192cd-1882-517c-8f58-de9373d34408', '0d230c63-a295-5db4-839e-c8ea8f906084', '8dee3edb-15e8-5c37-909f-7ee2fa31ab76', '943e8084-af94-5be6-bf4a-33c7b64a20e3', '048d6a99-dfe1-5fef-a69b-014bd28e8db4', '81cbfde1-78f7-510e-af9b-8a39c60ef5b9', '901088c7-9fe6-5ab7-a2da-4bdc1cb7c126', '46c842ff-b964-514f-a585-1d21701968b9', 'c517d5ee-f0f0-5125-b38b-aa31317e87f7', 'b48ed0de-81ef-58f3-acda-c93765aa77e1', 'a2144baa-d3b9-5eaa-9fed-0516b67c34e1', '696c3ec0-a0be-5639-90da-2ccd62f57503', '86ed9c43-ea7c-512b-8cd4-669e3e8ac507', '968b920e-58de-516c-85c7-5a0212720e84', 'cad32dbd-ea52-592a-9e91-01cb2ea95e34', '0a57dbcd-4898-593e-b517-d86efdb83065', 'b525b03b-77be-54a4-a3af-0ba632d33d8e', '5612e769-b27a-5b88-af8f-a6e549bde657', '95fde13f-f2f8-581f-852a-4b7540ecf1db', 'c96091b6-c363-5c5c-9247-e1b9873f5681', '0f7c1fec-9b53-5b37-9382-8f5a4d869533', 'dfe295fe-7b17-5250-9b22-ceeafd9d4b9d', '55b8437f-deb4-56f1-80b0-a7dc7ef4e208', '52ef1e8e-9443-51eb-9721-aad8e9b67083', '70d6eada-0c28-53d5-8a0e-209f4e02312c', '1243d960-6bc9-50f3-86df-a03627d2ced5', '59b1fa2e-579a-5292-ad19-8758551d8565', 'dd9483bf-9486-5a08-96e5-a8dfa26c5f21', '68878c00-3bfb-5889-8de8-7d19b65bb0b1', 'b965b8cd-cdaa-5ca7-ae45-e525898f087a', '71d40794-119f-5b05-98d5-4c833db53ffb', 'f83c933b-de36-5e08-a867-0af7125c9d74', '0f9b0f3f-8547-5aae-bc35-e9ccf87e13cc', 'fe0b9f06-2472-53ac-bdb0-132cca91c50b', '4dda1f80-a8d8-5687-9dc0-e958b5a1fd6f', 'cf0dcf01-4324-51f0-8eb3-60efea699dd8', '608fd8d9-a73e-52b7-8d93-07f04f474006', '1c029ee7-cd8b-5cce-9e00-577679376c5f', '4b0dd7b3-925e-5047-bc97-2c116d331324', 'd88bf2b4-e009-52a9-9ede-864872a15a18', 'e330a40f-c0f5-5450-a24d-f85391669092', '2581fd79-32b1-569b-aff9-078e406d8400', '1ade1bbd-1b4c-5181-941e-3f4d763bf77e', 'cb94fa8a-6965-582b-b822-3f2f9f365461', '1a2f481f-f7b2-54b2-ad45-b585ba60f75c', 'ebbbd5e0-1461-5d44-bfad-ec62ad240307', '14c91eb6-4b49-50e0-ab53-6202a3024100', '443d4494-a824-5596-b36d-c27138558c39', 'e3d78bcb-719f-5e94-a74d-b52f2ab0d472', 'c8d3f6a6-6a36-5281-b85c-1a729886b6cf', 'ad3c0dfd-77a0-56e6-ad95-ac5f572b3bd9', 'c1362b71-90d2-5b66-a12e-6d57b2bd1a4e', 'a2b7d150-aa88-5b11-b74e-bf3d4b4ecb8f', '118d25fa-1878-53e7-81c4-b7a066c507aa', '05905e85-f9a8-556c-b59d-6f886ac3fce6', '4ca9502a-16dc-5e58-b3e5-a05f270e0e47', '2955aa3a-8a54-5630-87ff-ecec8468bd61', '7690ed5f-25da-5854-b4db-0e3a767d6ecb', 'd3cab0b1-a2c9-51f2-a555-f3562c707b86', '64855545-4c08-571b-b5f6-917916d40e96', '680da7d8-1eb2-58fc-b9dc-fcd5267cd3f0', '355b981f-10be-540f-8ce8-30535dde173d', 'ec333663-5494-5130-afb2-5b1203d98a4c', 'a1aa71c7-8515-566c-9de1-074170c60a4a', 'a766200e-0ec2-59bd-9ff9-e9a3ebc47c5c', '34c05089-555e-5436-b7db-3254ccb0b9a6', 'e56f771a-1595-59e9-9534-44a88405e317', '44891c20-f709-5171-8603-109bf8f7d601', 'f5dcad86-38e6-5563-b34a-96a26bc938fe', '54c871cc-66f7-5ad2-9e75-5037e7c0cbcd', 'aa8d71e4-90cb-5351-a3b5-f8e71535d971', '1c334e34-a05c-5ff1-893e-0fbdee844f51', 'c7ec54f5-5c0c-5aab-ac63-02e8ee629344', '038b0dea-5314-507b-813a-73e5699233d9', '0acc1aaa-50bd-5227-b6f3-606cffc83c9b', '963d254c-722e-5418-b40d-3a95a902eb39', '8f26dcbd-6d05-53ea-ba38-757332de4c51', '0ccba164-785b-50e0-b4c6-ce2a2f0382c9', '8f2998d6-458a-5afc-97a7-737c9672b10c', '5fdcdc87-b278-5999-8041-89ac7e46a003', 'f0848d8e-a7d0-526b-9987-8896ede66677', '32dd497b-23ce-5eab-b2f5-64dae9ad65cd', '2e02eca7-9032-5891-802d-487202660784', 'e3dbe365-d118-517e-9e5a-a28bcd25e5da', '0915fdcb-7ad2-5fb0-a97b-f1b8c05bd8f6', '9eb1d9a6-4232-5963-a8ba-f5fc065334d1', 'be125d0c-b913-532c-b7e6-99b1879206c7', 'c9c4ce49-17e8-5d48-a7c9-f9271423d335', 'ff7892dc-6d19-505d-87bd-2bf5022e3bf2', '5607e522-2fde-5492-91fc-96889abe8e11', '8b2af84e-f3d3-5726-9816-15c94f4e4572', '5ec04184-7ca2-5598-a726-06b6f2612fcb', '34c3b5c8-a317-5d9f-a729-771393a267a7', '6897c10e-4ea4-543e-9d9f-8635e7e4cc9b', 'c6e15392-4616-5f43-98b3-f11974327502', 'aad7a298-cc71-56a6-ab12-31dc14010602', 'a2614ae7-b99c-5657-bf2d-ba30898e7ef5', '02c3c751-4c1c-5ef4-857b-45113ebdd2be', 'acc60f52-f51e-574b-97b3-210d682c1de6', 'f4d398e6-96d4-5eb4-b42f-0e87db1db23b', '110389f6-e92e-58b3-b3ed-83e88f6ac9c5', '77db3ae9-4ff0-5fa2-a35c-f45341cdb351', 'ca4461a8-889e-5407-9ef3-ee740663376b', 'a27d458d-ea7c-57b8-8864-ff61d358508e', '414e6063-5fad-5fd2-aa9e-515e32a8683c', '5c695327-48d4-55d0-b61e-4444e0652fb8', '0cccfb77-6c60-51b5-9183-9d7300c5b11f', '508c5cf8-db5b-5cea-abcb-301549d771f9', 'db41d726-e208-5b84-993d-bc94801a3d9b', '501dc4fb-c0b7-55ca-9e99-2fb1455f0f1c', '418a6f7d-f3a0-54d5-94e3-b036606d7cca', '207ad235-720d-5093-be5b-7fffd3bfb8f1', '8b11944d-a240-5e16-a0b1-2982e56bdf4f', '653406ea-31f4-55e1-8460-fdd8b187980e', 'f28283ef-15ea-504d-bd3a-e81d6d0add6f', '9a96c23b-19eb-58af-9764-6763aa1d3201', '4b37f4b0-7161-55c4-a5ff-d2c820ff2c53', '359ba898-216f-53bd-9b32-3e0d35715228', 'f8f25db6-f3d3-51ac-ada2-81cebdeeccfd', '502c0a2d-35d6-563a-bd0f-2d1b383448fb', 'bf4ac9bc-144e-5b65-8d07-a798cf33b153', '1600b2b1-4d62-58ca-8def-4c56d0a51aaf', 'ed88ac33-ff75-5ae8-af12-748fdd054874', '421af3b3-d7fd-500f-a1b9-6cb80f7f3141', '584274f6-ddf8-5926-9524-184d9f91e6a0');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'physique-1ere-sec' AND source = 'admin' AND id NOT IN ('23efe879-f28b-5f02-9781-87c73bbf943c', '825c0e36-76ff-5ed0-807a-767423c8d266', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', '4c945492-15a7-5744-b8d4-aca03ae96823', '1f35f50b-4457-5031-8b0c-fdde34926782', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', '1d81c458-1701-5b14-a5fe-009936e9168d', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'd11513d0-a414-5c0c-91d2-e662b444d896', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', '7d6f7463-11be-5740-95b6-ff3eb85030e0', '422ca09e-9435-5139-8fd2-f18b5b26b6e1', '0660f866-d04b-5781-85bf-8fb151817d67', '5dd05201-7540-5485-a414-2641610ddff8', '0dee1c4c-f8bb-54ba-9846-8e6bf16cea42', 'a30e1a83-eb93-5edb-a494-525db481fa85', 'cfaa1433-5718-5f95-a3ed-8e0ac0f578cd', '67514517-cc86-572f-acb0-78c101a3e4a8', 'f23249a3-447c-5a84-b598-7befa440dea4', '57a6d088-3606-574e-9c7a-21ad61085b10', '77a71048-e455-52a7-8990-63bf49db5cde', '00f33ff4-afff-53df-a6c6-ae0ce43de208', 'abec3893-aeff-5291-b4fd-469141699639', 'ed73f815-6a7a-53e4-a11e-7bf15e6b7725', 'bf9dc0af-f96d-5a69-946c-2672a7624bd3', 'd06ae886-0bd4-5fd3-b145-6bd4ccd3e66d', '111cc851-de77-5b0c-9d18-a246009aca79', 'ba18e988-ce16-507d-a989-942f4e511fc4', '1db9845a-a557-5435-8fa2-162b2e319e0c', '94aa116d-1cda-54c2-bbb1-01412b80b661', '01a46421-8763-5bd9-8898-af99bcccb771', 'f2e54830-da42-5888-96e4-c07be773fc36', 'eace3946-a8d8-57e4-bdf2-304b8554ca26', '39cdd03b-2a64-535f-8689-e9ba39b780b1', 'c677f7e6-a95c-55ed-92d2-5bc598dd6840', '26157329-4219-5520-a338-1c7479dc99be', '961454a0-bb36-53da-88aa-83310d305e36', '60914d60-5103-585b-9e66-9dfbc2559cf0', 'ba3ba71d-71a3-5fa1-bfee-1e54cb7ca45d', '19cd0107-12e5-5d0a-9ec1-c4957d482013');
DELETE FROM public.questions WHERE exercise_id IN ('23efe879-f28b-5f02-9781-87c73bbf943c', '825c0e36-76ff-5ed0-807a-767423c8d266', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', '4c945492-15a7-5744-b8d4-aca03ae96823', '1f35f50b-4457-5031-8b0c-fdde34926782', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', '1d81c458-1701-5b14-a5fe-009936e9168d', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'd11513d0-a414-5c0c-91d2-e662b444d896', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', '7d6f7463-11be-5740-95b6-ff3eb85030e0', '422ca09e-9435-5139-8fd2-f18b5b26b6e1', '0660f866-d04b-5781-85bf-8fb151817d67', '5dd05201-7540-5485-a414-2641610ddff8', '0dee1c4c-f8bb-54ba-9846-8e6bf16cea42', 'a30e1a83-eb93-5edb-a494-525db481fa85', 'cfaa1433-5718-5f95-a3ed-8e0ac0f578cd', '67514517-cc86-572f-acb0-78c101a3e4a8', 'f23249a3-447c-5a84-b598-7befa440dea4', '57a6d088-3606-574e-9c7a-21ad61085b10', '77a71048-e455-52a7-8990-63bf49db5cde', '00f33ff4-afff-53df-a6c6-ae0ce43de208', 'abec3893-aeff-5291-b4fd-469141699639', 'ed73f815-6a7a-53e4-a11e-7bf15e6b7725', 'bf9dc0af-f96d-5a69-946c-2672a7624bd3', 'd06ae886-0bd4-5fd3-b145-6bd4ccd3e66d', '111cc851-de77-5b0c-9d18-a246009aca79', 'ba18e988-ce16-507d-a989-942f4e511fc4', '1db9845a-a557-5435-8fa2-162b2e319e0c', '94aa116d-1cda-54c2-bbb1-01412b80b661', '01a46421-8763-5bd9-8898-af99bcccb771', 'f2e54830-da42-5888-96e4-c07be773fc36', 'eace3946-a8d8-57e4-bdf2-304b8554ca26', '39cdd03b-2a64-535f-8689-e9ba39b780b1', 'c677f7e6-a95c-55ed-92d2-5bc598dd6840', '26157329-4219-5520-a338-1c7479dc99be', '961454a0-bb36-53da-88aa-83310d305e36', '60914d60-5103-585b-9e66-9dfbc2559cf0', 'ba3ba71d-71a3-5fa1-bfee-1e54cb7ca45d', '19cd0107-12e5-5d0a-9ec1-c4957d482013') AND id NOT IN ('cd81dc68-012d-5b7b-933f-d7435246ca21', 'a86d19a9-30d9-5c8d-90d6-d731fd8c3612', 'ba093546-03bb-5f48-b5ab-332a4678ebf6', '4020c7c3-42ec-5666-ac02-4a7c928298c3', '01ce9519-615d-5193-a9ed-164d0b5a072d', 'd08bd409-bb8d-5a8c-95ab-629c0f9a422f', '2ce36be3-6e4b-52b3-9a1d-7c7f54a6cc84', '51ce21a3-3dd2-5c6f-b861-402f5aafaba0', '2058a83d-ec8d-53f0-861d-a626c400a934', 'bef91dee-3629-5e84-bade-c7522a85fb50', 'bbba134a-f585-5325-9050-883b9fced6ef', '680466e0-720b-5f2b-b901-9d1549225955', '65d44468-4c57-58f6-988e-b41cffdbf06d', '0be8d0a3-98bf-5aa1-89f0-997374ec0922', 'c5fa6f99-06bd-5072-b7c7-c1fe9ec69f4b', '719be2dd-43e5-5a01-9a87-5d3229436d1e', '16fbe64e-9ed9-504b-a6f4-97bcad3e4d60', '593f42be-93b1-539f-9322-a8d575e1a230', 'e471922a-f642-51a7-bb9e-033148f07ab8', 'e6ae6bc1-5f41-5427-8663-966a9f69011b', '3219b52c-4050-536e-a787-d88a78e20a56', '16e4af28-858b-50dd-ab76-15ff08bd3a3d', 'd1eb1423-8c01-5eb0-8f4e-6fcdc490e7bd', 'f06ec153-9a5d-5921-8cee-ee4bc8f28a6d', 'eaded567-35c8-5e33-8c78-4390a0158224', 'c7701a6d-c3a4-5c3c-b9ec-c7924b005f9c', 'ea325711-a531-5ac4-820b-d0830db1e4e8', '84b39c4c-c1a9-5e1a-985c-e0b77e47b62e', '296021ad-7e08-546c-9dbe-aaae56fd29e9', 'e4d55829-3d13-5138-81d0-18c228a57299', '7facd2a5-4bfd-50c2-a843-4959d28528c5', '58838187-63ac-5d6a-94ec-0ebfe67c6383', '485bc1fd-849e-5f84-88cc-38034411f189', '2cbc3e67-cbb2-5fb2-b5cc-573c046492d3', '03340da1-e134-5d23-a6da-4fa8758f7d93', '2b5f857f-c66f-5e1b-9b81-2512f2bf448c', 'f965d026-c959-5dbb-959a-627734428969', 'd58ee35d-e22e-5253-8bb6-4d3968cf2c9f', '64fb427c-c19f-5c39-8663-1d3598b6b47c', 'aa3e6731-bb22-52b1-b36b-b65c012e3b3b', '8720ecf5-db88-5cdc-a041-489b34b363fa', '8b561a76-af87-55be-900d-790038fa5101', '1d07fd26-fb3d-5bf3-9d73-672be638bbfe', 'fdfff668-8cea-5ba3-a664-5e4c24672e98', 'b79494b4-f612-5930-96f7-f80616f6d462', '47981fe7-4f66-5600-afc6-e076e535b7f8', 'eaf88d4d-6b20-5533-a3ce-591bdc9a7900', '0a38a704-d473-5ac3-b4c7-993995d4c29f', '53189c58-507c-56b7-903b-5aecf00ddb48', 'afff4689-031e-56c8-a4bc-a1bea114a14f', 'eeb1aad5-2c6c-50ae-b230-7ca3785764ee', '209983c0-a5b5-5ec3-984e-d29485e28584', '9007d29d-5aa2-5acb-8b20-465475a1ca4d', 'a45667e8-3ab4-54a0-84b4-11b6aa63abdc', '49bf1bda-7235-598d-9788-41f843be864f', 'd431ec8e-8e26-519f-9b15-c24355ed386c', 'a9df8c0b-d628-5ba4-bf5b-0e5b19f805c2', '5b30ac05-ab65-506e-87b6-14e9d6915203', '89ad05de-c572-5581-9325-79a511f17280', '42cbe483-f5da-5c86-88f4-ff14087d8c9c', '21a2da4a-2ccb-57b7-9d1e-64ba4003707b', 'faf9e844-3874-512b-9c3f-7d79e45bd9fe', '8104cc1a-7645-50e1-b7e2-04987db22904', '783d5c76-c42e-5890-9687-67972acd4c70', 'eabf0b7c-56ce-5ef5-a814-1e2e3a3d4613', 'f9c848cd-7dd1-55a0-abff-39fbe5b7f2be', '8fe13c74-52fb-538c-bc1e-d6e131b933a3', 'f6ca22d5-58c4-59e1-b026-5e8a9156bfd5', '8c7567b0-ac54-50ff-841a-32c5e7cd0b83', '0908c2c0-30b4-5855-b726-14ba7fbdb2d7', 'c0217e65-f239-55aa-a831-38a8c11c7a32', 'ce94ce9e-22ab-53dc-a639-6914ba5d7c48', 'f2948742-e856-5312-a4c4-94e961c453cd', 'f2c9f793-58b3-5608-9ef1-9822c13489cf', '71335a8b-4bcf-5a1a-9506-df483e881db2', '32a4e4ff-cb39-5a0f-abb0-280ceffb76b1', '20b0c8ec-40b0-593d-8296-7ca351414023', 'e432b93c-7430-5d50-a3d4-d8e3958391ca', 'f5db2d0c-d850-5039-bfa5-035d1b3b71ba', '4993eff6-9020-5a3e-bdf3-2376e4d0549e', 'e811528a-a241-56fc-a45b-914b217d25e1', 'c2ffa223-7429-560b-9077-67c135a8cb36', '60c4fc30-c54c-5450-802a-95639ccb4945', 'add45e24-fff3-506b-9133-053dd2ae80c3', '2fcb7236-95ac-5676-aa39-df0bb85ff409', '25217386-51db-5e5e-bdc6-0b74467b5ea5', 'abc07094-845e-5b5b-98b6-6dfdf42d1bfe', '671a0763-76ea-516c-b5e0-93363e15b1f0', 'f222edc4-95c0-5c44-ad24-0926e0d7c608', '5eefd557-3a06-5882-abfc-8eecaa9e8c0c', '7cafe90a-730f-5a2d-b90c-d9b0ae44da95', 'd0f28444-ef0a-5d09-bd3f-976e941a5951', 'ae69b3f1-142d-5727-af35-f2061a87bf1a', 'f254c2d6-77d2-5b05-b3ee-8d47bb45418a', '36a7acf2-fb31-539a-9c16-1c54b094e302', '7fa903cb-2892-5e30-a204-5955bd68e873', '9ece779e-0e45-5a9d-8825-a112d328cf42', 'e3efc622-cd7b-5914-971c-fd2bc0af9bbd', '61a6a809-b368-5682-a878-5df72a0ffd6c', 'a0479655-43aa-551a-aabc-8bb6a0ccf566', 'c61b00a6-b4d6-5ebd-8fc1-271594a559b0', '0a18a7a3-5b30-5e16-ac86-5579b6571c38', '4e48535a-8747-5264-8460-6055c9dc55cc', '9544663c-43ec-5fb0-9050-a8b7e49ea42f', '7168b5a2-cf82-5029-b45b-e71c258083f9', '4579525f-f116-5a0f-8166-a9358fc74f60', '79b10bca-3e49-569a-83e9-ea426f3e017f', 'f36da336-ef77-5cee-8c64-2b7e75504968', 'becb03c1-56f3-579c-a1c2-f73cfc84c3f8', '9405bc80-f2a0-5785-8204-09e75334d255', '21a14880-73c3-559f-85ee-e648ffd4adce', 'cbac5a2f-a278-52db-88d6-f4738159afe4', '0a8fd254-8e16-5bc5-8de0-5c81d8a439d0', '13b192cd-1882-517c-8f58-de9373d34408', '0d230c63-a295-5db4-839e-c8ea8f906084', '8dee3edb-15e8-5c37-909f-7ee2fa31ab76', '943e8084-af94-5be6-bf4a-33c7b64a20e3', '048d6a99-dfe1-5fef-a69b-014bd28e8db4', '81cbfde1-78f7-510e-af9b-8a39c60ef5b9', '901088c7-9fe6-5ab7-a2da-4bdc1cb7c126', '46c842ff-b964-514f-a585-1d21701968b9', 'c517d5ee-f0f0-5125-b38b-aa31317e87f7', 'b48ed0de-81ef-58f3-acda-c93765aa77e1', 'a2144baa-d3b9-5eaa-9fed-0516b67c34e1', '696c3ec0-a0be-5639-90da-2ccd62f57503', '86ed9c43-ea7c-512b-8cd4-669e3e8ac507', '968b920e-58de-516c-85c7-5a0212720e84', 'cad32dbd-ea52-592a-9e91-01cb2ea95e34', '0a57dbcd-4898-593e-b517-d86efdb83065', 'b525b03b-77be-54a4-a3af-0ba632d33d8e', '5612e769-b27a-5b88-af8f-a6e549bde657', '95fde13f-f2f8-581f-852a-4b7540ecf1db', 'c96091b6-c363-5c5c-9247-e1b9873f5681', '0f7c1fec-9b53-5b37-9382-8f5a4d869533', 'dfe295fe-7b17-5250-9b22-ceeafd9d4b9d', '55b8437f-deb4-56f1-80b0-a7dc7ef4e208', '52ef1e8e-9443-51eb-9721-aad8e9b67083', '70d6eada-0c28-53d5-8a0e-209f4e02312c', '1243d960-6bc9-50f3-86df-a03627d2ced5', '59b1fa2e-579a-5292-ad19-8758551d8565', 'dd9483bf-9486-5a08-96e5-a8dfa26c5f21', '68878c00-3bfb-5889-8de8-7d19b65bb0b1', 'b965b8cd-cdaa-5ca7-ae45-e525898f087a', '71d40794-119f-5b05-98d5-4c833db53ffb', 'f83c933b-de36-5e08-a867-0af7125c9d74', '0f9b0f3f-8547-5aae-bc35-e9ccf87e13cc', 'fe0b9f06-2472-53ac-bdb0-132cca91c50b', '4dda1f80-a8d8-5687-9dc0-e958b5a1fd6f', 'cf0dcf01-4324-51f0-8eb3-60efea699dd8', '608fd8d9-a73e-52b7-8d93-07f04f474006', '1c029ee7-cd8b-5cce-9e00-577679376c5f', '4b0dd7b3-925e-5047-bc97-2c116d331324', 'd88bf2b4-e009-52a9-9ede-864872a15a18', 'e330a40f-c0f5-5450-a24d-f85391669092', '2581fd79-32b1-569b-aff9-078e406d8400', '1ade1bbd-1b4c-5181-941e-3f4d763bf77e', 'cb94fa8a-6965-582b-b822-3f2f9f365461', '1a2f481f-f7b2-54b2-ad45-b585ba60f75c', 'ebbbd5e0-1461-5d44-bfad-ec62ad240307', '14c91eb6-4b49-50e0-ab53-6202a3024100', '443d4494-a824-5596-b36d-c27138558c39', 'e3d78bcb-719f-5e94-a74d-b52f2ab0d472', 'c8d3f6a6-6a36-5281-b85c-1a729886b6cf', 'ad3c0dfd-77a0-56e6-ad95-ac5f572b3bd9', 'c1362b71-90d2-5b66-a12e-6d57b2bd1a4e', 'a2b7d150-aa88-5b11-b74e-bf3d4b4ecb8f', '118d25fa-1878-53e7-81c4-b7a066c507aa', '05905e85-f9a8-556c-b59d-6f886ac3fce6', '4ca9502a-16dc-5e58-b3e5-a05f270e0e47', '2955aa3a-8a54-5630-87ff-ecec8468bd61', '7690ed5f-25da-5854-b4db-0e3a767d6ecb', 'd3cab0b1-a2c9-51f2-a555-f3562c707b86', '64855545-4c08-571b-b5f6-917916d40e96', '680da7d8-1eb2-58fc-b9dc-fcd5267cd3f0', '355b981f-10be-540f-8ce8-30535dde173d', 'ec333663-5494-5130-afb2-5b1203d98a4c', 'a1aa71c7-8515-566c-9de1-074170c60a4a', 'a766200e-0ec2-59bd-9ff9-e9a3ebc47c5c', '34c05089-555e-5436-b7db-3254ccb0b9a6', 'e56f771a-1595-59e9-9534-44a88405e317', '44891c20-f709-5171-8603-109bf8f7d601', 'f5dcad86-38e6-5563-b34a-96a26bc938fe', '54c871cc-66f7-5ad2-9e75-5037e7c0cbcd', 'aa8d71e4-90cb-5351-a3b5-f8e71535d971', '1c334e34-a05c-5ff1-893e-0fbdee844f51', 'c7ec54f5-5c0c-5aab-ac63-02e8ee629344', '038b0dea-5314-507b-813a-73e5699233d9', '0acc1aaa-50bd-5227-b6f3-606cffc83c9b', '963d254c-722e-5418-b40d-3a95a902eb39', '8f26dcbd-6d05-53ea-ba38-757332de4c51', '0ccba164-785b-50e0-b4c6-ce2a2f0382c9', '8f2998d6-458a-5afc-97a7-737c9672b10c', '5fdcdc87-b278-5999-8041-89ac7e46a003', 'f0848d8e-a7d0-526b-9987-8896ede66677', '32dd497b-23ce-5eab-b2f5-64dae9ad65cd', '2e02eca7-9032-5891-802d-487202660784', 'e3dbe365-d118-517e-9e5a-a28bcd25e5da', '0915fdcb-7ad2-5fb0-a97b-f1b8c05bd8f6', '9eb1d9a6-4232-5963-a8ba-f5fc065334d1', 'be125d0c-b913-532c-b7e6-99b1879206c7', 'c9c4ce49-17e8-5d48-a7c9-f9271423d335', 'ff7892dc-6d19-505d-87bd-2bf5022e3bf2', '5607e522-2fde-5492-91fc-96889abe8e11', '8b2af84e-f3d3-5726-9816-15c94f4e4572', '5ec04184-7ca2-5598-a726-06b6f2612fcb', '34c3b5c8-a317-5d9f-a729-771393a267a7', '6897c10e-4ea4-543e-9d9f-8635e7e4cc9b', 'c6e15392-4616-5f43-98b3-f11974327502', 'aad7a298-cc71-56a6-ab12-31dc14010602', 'a2614ae7-b99c-5657-bf2d-ba30898e7ef5', '02c3c751-4c1c-5ef4-857b-45113ebdd2be', 'acc60f52-f51e-574b-97b3-210d682c1de6', 'f4d398e6-96d4-5eb4-b42f-0e87db1db23b', '110389f6-e92e-58b3-b3ed-83e88f6ac9c5', '77db3ae9-4ff0-5fa2-a35c-f45341cdb351', 'ca4461a8-889e-5407-9ef3-ee740663376b', 'a27d458d-ea7c-57b8-8864-ff61d358508e', '414e6063-5fad-5fd2-aa9e-515e32a8683c', '5c695327-48d4-55d0-b61e-4444e0652fb8', '0cccfb77-6c60-51b5-9183-9d7300c5b11f', '508c5cf8-db5b-5cea-abcb-301549d771f9', 'db41d726-e208-5b84-993d-bc94801a3d9b', '501dc4fb-c0b7-55ca-9e99-2fb1455f0f1c', '418a6f7d-f3a0-54d5-94e3-b036606d7cca', '207ad235-720d-5093-be5b-7fffd3bfb8f1', '8b11944d-a240-5e16-a0b1-2982e56bdf4f', '653406ea-31f4-55e1-8460-fdd8b187980e', 'f28283ef-15ea-504d-bd3a-e81d6d0add6f', '9a96c23b-19eb-58af-9764-6763aa1d3201', '4b37f4b0-7161-55c4-a5ff-d2c820ff2c53', '359ba898-216f-53bd-9b32-3e0d35715228', 'f8f25db6-f3d3-51ac-ada2-81cebdeeccfd', '502c0a2d-35d6-563a-bd0f-2d1b383448fb', 'bf4ac9bc-144e-5b65-8d07-a798cf33b153', '1600b2b1-4d62-58ca-8def-4c56d0a51aaf', 'ed88ac33-ff75-5ae8-af12-748fdd054874', '421af3b3-d7fd-500f-a1b9-6cb80f7f3141', '584274f6-ddf8-5926-9524-184d9f91e6a0');
DELETE FROM public.chapters c WHERE c.subject_id = 'physique-1ere-sec' AND c.id NOT IN ('f3c0e519-3356-5b57-bf8a-c39cf6650721', '60fba4c2-4acb-5966-bf21-451643db2757', '79bcf821-5a01-5dd5-93b8-497591138ae0', 'cefe9013-8f6e-57cc-beb2-addd28192c81', 'fa37b216-c0bf-59cd-aa50-40529b1b01f0', '090c9e09-759f-5ce2-af21-f48409c41776', 'c6786b76-bc3d-55f9-80fb-b9b4febeca46', '32d59637-8b9b-5c5d-be28-a661504a41e7', '0c787ec0-ce62-5817-b4ab-cd87ee9922a3', '9da7c97f-7d81-5e5e-95f1-9019f1394cc2', '5e11f66c-337a-5c91-9846-11ae4934ed8d', '220d0f57-1bc2-534e-83f9-a77d72422212', '7c2390d8-5766-59ff-a691-f015bda6c442', '4d0448ec-57fd-5c08-9d6a-3c97976068e8') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('f3c0e519-3356-5b57-bf8a-c39cf6650721', 'physique-1ere-sec', 'Le phénomène d''électrisation', 'Électrisation par frottement et détection au pendule électrostatique ; les deux types de charges et la convention de signe référencée au verre (positive/vitrée, négative/résineuse) ; lois d''interaction (même signe → répulsion, signes contraires → attraction) ; les trois modes d''électrisation (frottement, contact, influence) et l''électroscope ; le modèle des porteurs de charges et le transfert d''électrons ; la charge q en coulomb (C) et la charge élémentaire e = 1,6 × 10⁻¹⁹ C ; conducteurs et isolants ; décharge électrique, étincelle, éclair, effet de pointe ; cage de Faraday, foudre et paratonnerre', '# ⚡ Le phénomène d''électrisation — quand la matière se charge

> 💡 «Tu tires un pull en laine par temps sec : ça crépite, ça t''attire les cheveux, et parfois une petite étincelle te pique le doigt. Ce chapitre t''explique ce petit choc — et, au passage, l''éclair qui tombe du ciel.»

Bienvenue dans **L''ÉLECTRICITÉ**, héros. Avant les circuits et les piles, il faut comprendre d''où vient l''électricité. Tout part d''un geste banal : **frotter**. Ce chapitre est entièrement **qualitatif** — aucun calcul — mais il pose le modèle sur lequel repose tout le reste du programme.

## 🧲 Électriser un corps

Approche une règle en plexiglas d''une petite boule légère suspendue à un fil de soie — un **pendule électrostatique**. Rien ne bouge. Frotte maintenant cette règle avec un tissu en **laine**, puis approche-la **sans toucher** la boule : **la boule est attirée**.

Le frottement a modifié la surface de la règle : elle est devenue capable d''attirer les corps légers. On dit qu''elle est **électrisée**, ou **chargée d''électricité**. Le verre, le plexiglas, le plastique, le caoutchouc, les métaux, la laine… sont **susceptibles d''être électrisés par frottement**. Le **pendule électrostatique** est notre premier **détecteur** de charge.

## ➕➖ Deux charges, une règle de signe

Frotte deux bâtons en verre : approchés l''un de l''autre, ils **se repoussent**. Frotte un bâton en verre et un bâton en P.V.C : ils **s''attirent**. Il existe donc **deux types de charges électriques**. La convention se lit **par rapport au verre** frotté avec de la laine :

- un corps qui **repousse** le verre électrisé porte une charge **positive (+)** (autrefois « électricité vitrée ») ;
- un corps qui est **attiré** par le verre électrisé porte une charge **négative (−)** (autrefois « électricité résineuse »).

::: figure Deux charges de même signe s''écartent, deux charges de signes contraires se rapprochent : c''est le signe, jamais la seule présence de charge, qui décide
<svg viewBox="0 0 340 170">
<g stroke="#0f172a" stroke-width="1.8">
<circle cx="55" cy="55" r="20" fill="#ef4444" opacity="0.75"/>
<circle cx="120" cy="55" r="20" fill="#ef4444" opacity="0.75"/>
<circle cx="55" cy="125" r="20" fill="#ef4444" opacity="0.75"/>
<circle cx="120" cy="125" r="20" fill="#3b82f6" opacity="0.75"/>
</g>
<g font-size="20" font-weight="700" fill="#0f172a" text-anchor="middle">
<text x="55" y="62">+</text><text x="120" y="62">+</text>
<text x="55" y="132">+</text><text x="120" y="132">−</text>
</g>
<g stroke="#0f172a" stroke-width="2.5" fill="none" marker-end="url(#ar)">
<path d="M78 40 L100 40"/><path d="M97 70 L75 70"/>
<path d="M88 110 L102 110"/><path d="M87 140 L73 140"/>
</g>
<defs><marker id="ar" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto"><path d="M0 0 L9 4.5 L0 9 Z" fill="#0f172a"/></marker></defs>
<g font-size="12" font-weight="700" fill="#0f172a">
<text x="175" y="59">même signe → répulsion</text>
<text x="175" y="129">signes contraires → attraction</text>
</g>
</svg>
:::

Retiens la double loi : **deux corps chargés de même signe se repoussent ; deux corps chargés de signes contraires s''attirent.**

## 🔄 Trois façons d''électriser

Il existe **trois modes d''électrisation** :

| Mode           | Comment                                         | Résultat                                           |
| -------------- | ----------------------------------------------- | -------------------------------------------------- |
| **frottement** | on frotte deux corps l''un contre l''autre        | chaque corps se charge                             |
| **contact**    | un corps électrisé en touche un autre           | le corps touché prend une charge **de même signe** |
| **influence**  | on approche un corps électrisé **sans toucher** | les charges de l''autre corps se réorganisent       |

L''**électroscope** est l''appareil qui, par **influence**, permet de **détecter si un corps qui lui est approché est électrisé ou non** : son aiguille (ou ses feuilles) dévie.

C''est aussi l''**influence** qui explique pourquoi un corps chargé attire même un corps **neutre** (comme la boule du début du chapitre) : il attire vers lui les charges de signe opposé et repousse les charges de même signe. Les charges attirées se retrouvant **plus proches** que les charges repoussées, **l''attraction l''emporte sur la répulsion**.

> 🗡️ Un corps **non frotté et non électrisé par contact** n''agit sur rien : il est **électriquement neutre**. Neutre ne veut pas dire « vide de charges » — tu vas voir pourquoi.

## ⚛️ Le modèle : des électrons qui migrent

Pour tout expliquer, on admet que la matière contient des **porteurs de charges** de deux sortes : les uns portent de l''électricité **positive**, les autres de l''électricité **négative**. Un corps **neutre** en contient des **quantités égales** — d''où sa neutralité.

Lors du frottement, de minuscules porteurs négatifs, les **électrons**, **migrent d''un corps à l''autre** :

- le corps qui **reçoit** les électrons devient chargé **négativement** ;
- le corps qui **cède** ses électrons devient chargé **positivement**.

::: figure En frottant le verre avec la laine, des électrons quittent le verre pour la laine : le verre, qui en cède, devient positif ; la laine, qui en reçoit, devient négative
<svg viewBox="0 0 340 160">
<rect x="30" y="60" width="90" height="26" rx="6" fill="#fca5a5" opacity="0.7" stroke="#0f172a" stroke-width="1.8"/>
<rect x="220" y="60" width="90" height="26" rx="6" fill="#93c5fd" opacity="0.7" stroke="#0f172a" stroke-width="1.8"/>
<g stroke="#1d4ed8" stroke-width="2.5" fill="none" marker-end="url(#e)">
<path d="M130 50 C 170 30, 200 30, 214 48"/>
</g>
<defs><marker id="e" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto"><path d="M0 0 L9 4.5 L0 9 Z" fill="#1d4ed8"/></marker></defs>
<g fill="#1d4ed8" stroke="#0f172a" stroke-width="1"><circle cx="150" cy="41" r="6"/><circle cx="172" cy="35" r="6"/><circle cx="194" cy="38" r="6"/></g>
<g font-size="10" font-weight="700" fill="#ffffff" text-anchor="middle"><text x="150" y="45">−</text><text x="172" y="39">−</text><text x="194" y="42">−</text></g>
<g font-size="13" font-weight="700" fill="#0f172a" text-anchor="middle">
<text x="75" y="77">verre</text><text x="265" y="77">laine</text>
<text x="75" y="112">devient +</text><text x="265" y="112">devient −</text>
<text x="172" y="20">électrons</text>
</g>
</svg>
:::

La charge portée par un corps est une **grandeur mesurable**, notée **q**. Son unité, dans le système international, est le **coulomb** (symbole **C**). La charge d''un seul électron est notée **−e**, où **e** est la **charge élémentaire** :

$$ e = 1,6 × 10⁻¹⁹ C $$

## 🚧 Conducteurs et isolants

Électrise une tige, puis relie-la à la boule du pendule par différents matériaux. Résultat :

- avec le **cuivre**, l''**aluminium** ou le **carbone**, la charge **se propage** : ce sont des **conducteurs**. Ils **laissent circuler les électrons**, et la charge se **répartit sur toute la tige**.
- avec le **bois**, le **verre**, le **P.V.C** ou le **plexiglas**, rien ne passe : ce sont des **isolants**. La charge **reste localisée** là où elle est apparue.

> ⚠️ Piège classique : « le verre est un isolant, donc on ne peut pas l''électriser ». Faux ! On électrise très bien le verre **par frottement** — sa charge reste simplement **localisée** au point frotté, faute de pouvoir circuler.

## ⚡ Décharges, étincelles et foudre

Accumule des charges de signes contraires sur les deux sphères d''une **machine de Wimshurst** : au bout d''un moment, une **étincelle** jaillit avec un **crépitement**. Deux corps très chargés de signes contraires provoquent un **déplacement d''électrons à travers l''air** : c''est une **décharge électrique**. Ces électrons se déplacent **du corps négatif vers le corps positif**. La lueur qui matérialise le canal de la décharge est l''**éclair** ; l''échauffement intense de l''air produit le **crépitement**.

Au bout d''une **pointe**, les charges s''accumulent très fortement et la décharge y est facilitée : c''est l''**effet de pointe**. C''est exactement ce qui se joue dans le ciel : le bas d''un nuage orageux, chargé négativement, provoque une décharge vers le sol — la **foudre** ; le bruit qui suit est le **tonnerre**. Une grosse pointe métallique reliée à la Terre, le **paratonnerre**, capte la foudre et la conduit au sol. Et la carrosserie métallique d''une voiture forme une **cage de Faraday** : elle protège ses occupants en maintenant le champ électrique **nul à l''intérieur**.

> 🏆 Première quête franchie, héros ! Tu sais électriser un corps, lire le signe d''une charge, expliquer les trois modes d''électrisation par le transfert d''électrons, et distinguer conducteur et isolant. Cap sur le **circuit électrique** : il est temps de faire circuler ce courant.', '# 📜 Résumé : Le phénomène d''électrisation

- **Électriser un corps.** Un corps frotté peut devenir **électrisé** (chargé d''électricité) : il attire alors les corps légers. Le **pendule électrostatique** sert à **détecter** cette charge.
- **Deux charges, règle de signe.** Il existe deux types de charges. Par convention, référencée au **verre** frotté à la laine : un corps **repoussé** par le verre est **positif (+)**, un corps **attiré** par le verre est **négatif (−)**. Loi : **même signe → répulsion ; signes contraires → attraction.**
- **Trois modes d''électrisation.** Par **frottement**, par **contact** (le corps touché prend le **même signe** que le corps électrisant) et par **influence** (sans contact). L''**électroscope** détecte, par influence, si un corps est chargé. Un corps ni frotté ni touché est **électriquement neutre**.
- **Le modèle des électrons.** La matière contient des **porteurs de charges** ; un corps neutre en a autant de positifs que de négatifs. Au frottement, des **électrons** migrent : celui qui en **reçoit** devient **négatif**, celui qui en **cède** devient **positif**. La charge se note **q**, en **coulomb (C)** ; la charge élémentaire vaut **e = 1,6 × 10⁻¹⁹ C**, et l''électron porte **−e**.
- **Conducteurs et isolants.** Les **conducteurs** (cuivre, aluminium, carbone) **laissent circuler les électrons** : la charge se répartit sur tout le corps. Les **isolants** (bois, verre, P.V.C, plexiglas) ne le permettent pas : la charge **reste localisée**.
- **Décharges et foudre.** Entre deux corps très chargés de signes contraires, des électrons traversent l''air **du corps négatif vers le positif** : c''est une **décharge**, avec **étincelle**, **éclair** et **crépitement**. Au bout d''une **pointe**, la décharge est facilitée (**effet de pointe**). Dans le ciel : **foudre** et **tonnerre** ; on s''en protège par le **paratonnerre** et la **cage de Faraday** (carrosserie de voiture).', 1, '{"code":"223103P00","pages":"9-24","pageNumbers":[9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('60fba4c2-4acb-5966-bf21-451643db2757', 'physique-1ere-sec', 'Le circuit électrique', 'Notion de dipôle et de circuit électrique fermé (chaîne continue de dipôles avec au moins un générateur) ; dipôle générateur et dipôle récepteur ; les quatre effets du courant (thermique, chimique, magnétique, lumineux) ; conducteurs et isolants, circuit ouvert, conditions de passage du courant ; symboles normalisés et schématisation ; sens conventionnel du courant (de la borne + vers la borne − à l''extérieur du générateur) ; nature du courant (électrons dans les métaux, cations et anions dans les électrolytes) ; la diode, dipôle dissymétrique (sens passant et sens bloquant) ; le court-circuit et ses dangers', '# 🔌 Le circuit électrique — mettre le courant en route

> 💡 «Une pile toute seule ne sert à rien ; une lampe toute seule non plus. C''est en les reliant que la lampe s''allume. Ce chapitre t''apprend la règle du jeu : comment faire circuler un courant, et dans quel sens.»

Au chapitre 1, les charges restaient immobiles. Maintenant, on les fait **circuler**. Un courant électrique parcourt un ensemble de composants reliés : un **circuit**. Voyons comment le construire, le lire et le protéger.

## 🔌 Dipôles et circuit fermé

Une pile, une lampe, un moteur ont un point commun : chacun possède **deux bornes** de connexion. On les appelle des **dipôles**. Relie-les bout à bout par des fils : tu formes une **chaîne**.

- Si la chaîne est **continue** (aucune coupure) et contient **au moins un générateur**, un courant circule : c''est un **circuit électrique fermé**.
- Le **générateur** (la pile) est le dipôle qui **fait apparaître** le courant. La lampe et le moteur sont des **récepteurs** : ils **utilisent** le courant pour fonctionner, mais ne peuvent pas le créer.

## 🔥 Les quatre effets du courant

Comment savoir qu''un courant passe ? Par ses **effets**. Le manuel en retient **quatre** :

| Effet          | On l''observe quand…                               | Exemple              |
| -------------- | ------------------------------------------------- | -------------------- |
| **thermique**  | un conducteur **chauffe**                         | filament d''une lampe |
| **chimique**   | le courant **transforme la matière**              | électrolyseur        |
| **magnétique** | une aiguille aimantée **dévie**                   | près d''un fil        |
| **lumineux**   | un composant **émet de la lumière** sans chauffer | DEL                  |

> 🗡️ La manifestation de **l''un** de ces effets **prouve** le passage d''un courant. Selon les composants, plusieurs effets peuvent apparaître à la fois (une DEL : lumineux, et un peu magnétique).

## 🚧 Conducteurs, isolants et circuit ouvert

Coupe la chaîne et intercale un objet. S''il **laisse passer** le courant (la lampe se rallume), c''est un **conducteur** (métaux, carbone). S''il **bloque** le courant, c''est un **isolant** (plastique, bois, verre). Un circuit qui contient un isolant dans sa chaîne est un **circuit ouvert** : aucun courant n''y circule.

Un circuit n''est parcouru par un courant que s''il remplit **deux conditions** :

1. il comporte un **dipôle générateur** ;
2. il forme une **chaîne continue de conducteurs**.

> 🗡️ L''air sec est isolant ; mais l''air humide, l''eau et le corps humain sont de **mauvais conducteurs** — d''où le danger de l''électricité près de l''eau.

## ✏️ Schématiser un circuit

Pour dessiner un circuit sans faire de portrait, on utilise des **symboles normalisés** : les mêmes pour tout le monde.

::: figure Un circuit fermé : le générateur (pile) impose le courant, qui parcourt la chaîne continue et allume la lampe ; la flèche rouge donne le sens conventionnel
<svg viewBox="0 0 320 190">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M60 55 V88"/><path d="M60 112 V150"/>
<path d="M60 55 H260"/><path d="M60 150 H260"/>
<path d="M260 55 V88"/><path d="M260 112 V150"/>
</g>
<g stroke="#0f172a" stroke-width="2.5"><path d="M44 92 H76"/><path d="M52 112 H68"/></g>
<circle cx="260" cy="100" r="13" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M251 91 L269 109 M269 91 L251 109" stroke="#0f172a" stroke-width="1.5"/>
<path d="M150 55 H178" stroke="#dc2626" stroke-width="2.6" fill="none" marker-end="url(#c2)"/>
<defs><marker id="c2" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto"><path d="M0 0 L9 4.5 L0 9 Z" fill="#dc2626"/></marker></defs>
<g font-size="14" font-weight="700" fill="#0f172a" text-anchor="middle">
<text x="34" y="97">+</text><text x="34" y="117">−</text>
<text x="60" y="178">pile</text><text x="260" y="140">lampe</text>
</g>
<text x="164" y="46" font-size="11" font-weight="700" fill="#dc2626" text-anchor="middle">sens du courant</text>
</svg>
:::

Retiens les symboles cités par le programme : **fil, générateur, lampe, moteur, interrupteur** (ouvert ou fermé), **diode, DEL, électrolyseur, ampèremètre, voltmètre, ohmmètre**.

## ➡️ Le sens du courant et sa nature

Le courant a un **sens**. **Par convention**, à l''**extérieur** du générateur, il circule de la **borne positive (+)** vers la **borne négative (−)**. C''est le **sens conventionnel**.

Mais que sont ces « porteurs » qui circulent vraiment ?

- **Dans les métaux** : ce sont les **électrons** (dits électrons de conduction). Comme ils sont négatifs, ils se déplacent **en sens inverse** du sens conventionnel — vers la borne **+** du générateur.
- **Dans les solutions ioniques** (électrolytes) : ce sont des **ions**. Les **cations** (positifs) se déplacent dans le **sens conventionnel** (vers la borne −), les **anions** (négatifs) dans le sens inverse (vers la borne +).

> ⚠️ Piège classique : « le courant, ce sont toujours des électrons ». Non — dans une solution ionique, ce sont des **ions** qui se déplacent, pas des électrons.

## 🔀 La diode et le court-circuit

La **diode** est un dipôle **dissymétrique** : ses deux bornes ne jouent pas le même rôle. Elle ne laisse passer le courant que dans **un seul sens** :

- dans le **sens passant**, elle se comporte comme un **interrupteur fermé** ;
- dans le **sens bloquant**, comme un **interrupteur ouvert**.

Elle sert donc à imposer, ou à repérer, le sens du courant. La **DEL** (diode électroluminescente) est une diode qui, en plus, **émet de la lumière**.

Enfin, un **court-circuit** : on relie les deux bornes d''un dipôle par un simple **fil conducteur**. Le courant passe alors par le fil au lieu du dipôle : le dipôle **court-circuité est mis hors usage**. Aux bornes d''un **générateur**, un court-circuit est dangereux : il peut l''endommager et provoquer un **incendie**.

> 🏆 Deuxième quête bouclée, héros ! Tu sais bâtir un circuit fermé, reconnaître les quatre effets du courant, tracer un schéma normalisé et donner le sens du courant. Il te reste à le **mesurer** : cap sur l''intensité.', '# 📜 Résumé : Le circuit électrique

- **Dipôles et circuit fermé.** Un **dipôle** a **deux bornes**. Une **chaîne continue** de dipôles comportant **au moins un générateur** forme un **circuit électrique fermé**. Le **générateur** fait apparaître le courant ; les **récepteurs** (lampe, moteur) l''utilisent pour fonctionner.
- **Les quatre effets du courant.** Le passage d''un courant se manifeste par un effet **thermique** (échauffement), **chimique** (électrolyseur), **magnétique** (déviation d''une aiguille aimantée) ou **lumineux** (DEL). L''un de ces effets **prouve** qu''un courant passe.
- **Conducteurs, isolants, circuit ouvert.** Un **conducteur** laisse passer le courant, un **isolant** le bloque. Un circuit contenant un isolant est un **circuit ouvert**. Deux conditions pour un courant : un **générateur** + une **chaîne continue de conducteurs**. L''eau et le corps humain sont de **mauvais conducteurs**.
- **Schématiser.** On dessine un circuit avec des **symboles normalisés** (fil, générateur, lampe, moteur, interrupteur, diode, DEL, électrolyseur, ampèremètre, voltmètre, ohmmètre).
- **Sens et nature du courant.** Sens **conventionnel** : de la borne **+** vers la borne **−**, à l''**extérieur** du générateur. Nature : des **électrons** dans les métaux (ils vont en sens inverse, vers la borne +), des **ions** dans les électrolytes (**cations** dans le sens conventionnel, **anions** en sens inverse).
- **Diode et court-circuit.** La **diode** est un dipôle **dissymétrique** : passante (interrupteur fermé) dans un sens, bloquante (interrupteur ouvert) dans l''autre ; la **DEL** émet en plus de la lumière. Un dipôle **court-circuité** (bornes reliées par un fil) est **hors usage** ; court-circuiter un générateur peut l''endommager et causer un **incendie**.', 2, '{"code":"223103P00","pages":"25-42","pageNumbers":[25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('79bcf821-5a01-5dd5-93b8-497591138ae0', 'physique-1ere-sec', 'L''intensité du courant électrique', 'Associations de dipôles : montage en série et montage en dérivation (parallèle), branche principale et branches dérivées, nœud et maille ; l''intensité du courant I et son unité l''ampère (A) ; l''ampèremètre (bornes A et COM, commutateur, calibre, échelle), son branchement en série et le choix du calibre ; la conservation de l''intensité dans un circuit série ; la loi des nœuds dans un montage en dérivation ; le fusible et les dangers électriques liés à l''intensité', '# 🔋 L''intensité du courant électrique — mesurer le débit

> 💡 «Deux lampes, deux éclats différents : l''une brille fort, l''autre à peine. La différence, c''est l''intensité du courant qui les traverse. Ce chapitre t''apprend à la mesurer et à prévoir sa valeur.»

Tu sais faire circuler un courant. Reste à le **mesurer**. Le courant électrique a un « débit » : son **intensité**. Mais d''abord, il faut savoir de quelle façon les dipôles sont associés.

## 🔗 Série ou dérivation

Avec un générateur et plusieurs dipôles, on distingue **deux sortes de montages** :

| Montage                    | Comment les dipôles sont branchés            |
| -------------------------- | -------------------------------------------- |
| **série**                  | les uns à la suite des autres, en une boucle |
| **dérivation** (parallèle) | sur des branches séparées                    |

Dans un montage en dérivation à un seul générateur :

- la **branche principale** est celle qui contient le **générateur** ;
- les **branches dérivées** sont celles des récepteurs ;
- un **nœud** est un point où se rencontrent **plus de deux branches** ;
- une **maille** est une boucle fermée du circuit.

::: figure Le générateur est sur la branche principale ; les deux lampes sont sur des branches dérivées qui se rejoignent aux nœuds — les points où trois fils se rencontrent
<svg viewBox="0 0 300 190">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M55 55 H245"/><path d="M55 150 H245"/>
<path d="M55 55 V85"/><path d="M55 115 V150"/>
<path d="M245 55 V88"/><path d="M245 112 V150"/>
<path d="M150 55 V88"/><path d="M150 112 V150"/>
</g>
<g stroke="#0f172a" stroke-width="2.5"><path d="M40 88 H70"/><path d="M48 110 H62"/></g>
<circle cx="245" cy="100" r="12" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M236.5 91.5 L253.5 108.5 M253.5 91.5 L236.5 108.5" stroke="#0f172a" stroke-width="1.4"/>
<circle cx="150" cy="100" r="12" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M141.5 91.5 L158.5 108.5 M158.5 91.5 L141.5 108.5" stroke="#0f172a" stroke-width="1.4"/>
<g fill="#dc2626"><circle cx="150" cy="55" r="4.5"/><circle cx="150" cy="150" r="4.5"/></g>
<g font-size="11" font-weight="700" fill="#0f172a">
<text x="30" y="82">+</text>
<text x="55" y="175" text-anchor="middle">branche principale</text>
<text x="198" y="45" text-anchor="middle" fill="#dc2626">nœud</text>
</g>
</svg>
:::

## 📊 L''intensité et l''ampère

Deux piles branchées sur une même lampe la font briller différemment : une grandeur caractérise cette différence, l''**intensité** du courant. Elle est **notée I** et s''exprime, dans le système international, en **ampère** (symbole **A**). On la mesure avec un **ampèremètre** (à aiguille ou numérique).

## 🎛️ Mesurer avec l''ampèremètre

L''ampèremètre se branche **en série**, en respectant ses bornes : le courant entre par la borne **A** (rouge, +) et sort par la borne **COM** (noire, −). Le **calibre** est la **plus grande intensité** que l''appareil peut mesurer.

**Règle du calibre** : on commence par le **plus grand** calibre (aucun risque), puis on descend vers le **plus petit calibre adapté** — c''est lui qui donne la mesure la plus **précise**. Sur un appareil à aiguille, on lit :

$$ Valeur = Lecture × Calibre ÷ Échelle $$

_Exemple détaillé_ : calibre **1 A**, échelle de **100** divisions, aiguille sur la division **40**. Alors Valeur = 40 × 1 ÷ 100 = **0,40 A** ✓.

## ➖ En série : une seule intensité

Insère l''ampèremètre à différents endroits d''un **circuit série** : il indique **toujours la même valeur**.

> 🗡️ **Dans un circuit série, l''intensité du courant est la même en tout point** — quel que soit l''ordre des dipôles. Ajouter un récepteur en série **diminue** cette intensité commune.

Si aucun effet du courant n''apparaît, c''est que l''intensité est **nulle** : il y a une **coupure** quelque part (appareil grillé, fil coupé, mauvais contact).

## ➕ La loi des nœuds

En dérivation, le courant se **partage** aux nœuds. Mesure les intensités de chaque branche : celle de la branche principale est la **somme** de celles des branches dérivées.

::: figure Au nœud, le courant entrant se partage entre les deux branches : 0,90 A d''un côté, 0,65 A et 0,25 A de l''autre, et 0,65 + 0,25 = 0,90
<svg viewBox="0 0 300 160">
<path d="M35 80 H126" stroke="#0f172a" stroke-width="2.6" fill="none" marker-end="url(#nd)"/>
<path d="M158 73 L250 38" stroke="#0f172a" stroke-width="2.6" fill="none" marker-end="url(#nd)"/>
<path d="M158 87 L250 122" stroke="#0f172a" stroke-width="2.6" fill="none" marker-end="url(#nd)"/>
<circle cx="145" cy="80" r="5.5" fill="#dc2626"/>
<defs><marker id="nd" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto"><path d="M0 0 L9 4.5 L0 9 Z" fill="#0f172a"/></marker></defs>
<g font-size="13" font-weight="700" fill="#0f172a">
<text x="55" y="72">I₁ = 0,90 A</text>
<text x="205" y="32">I₂ = 0,65 A</text>
<text x="205" y="140">I₃ = 0,25 A</text>
</g>
<text x="145" y="108" font-size="11" font-weight="700" fill="#dc2626" text-anchor="middle">nœud</text>
</svg>
:::

**Loi des nœuds** : la somme des intensités des courants qui **arrivent** à un nœud est égale à la somme des intensités des courants qui en **partent**. Ici : I₁ = I₂ + I₃, soit 0,90 = 0,65 + 0,25 ✓.

## 🛡️ Fusible et sécurité

Un **fusible** protège le circuit : c''est un fil qui **fond** dès que l''intensité dépasse une valeur donnée, coupant le courant. L''intensité est aussi une affaire de **sécurité** — le corps humain n''est ni bon conducteur ni isolant :

| Intensité traversant le corps | Conséquence          |
| ----------------------------- | -------------------- |
| 30 mA                         | paralysie musculaire |
| 50 mA                         | asphyxie             |
| 100 mA                        | fibrillation du cœur |

> 🏆 Troisième quête franchie, héros ! Tu sais distinguer série et dérivation, mesurer une intensité au bon calibre, et appliquer la loi des nœuds. Il te manque une dernière grandeur pour tout relier : la **tension**.', '# 📜 Résumé : L''intensité du courant électrique

- **Série ou dérivation.** En **série**, les dipôles sont branchés les uns à la suite des autres ; en **dérivation** (parallèle), sur des branches séparées. La **branche principale** contient le générateur, les **branches dérivées** les récepteurs. Un **nœud** est un point de rencontre de plus de deux branches ; une **maille** est une boucle fermée.
- **L''intensité et l''ampère.** L''**intensité** du courant, notée **I**, se mesure en **ampère (A)** à l''aide d''un **ampèremètre**.
- **Mesurer avec l''ampèremètre.** Il se branche **en série** ; le courant entre par la borne **A (+)** et sort par **COM (−)**. Le **calibre** est la plus grande intensité mesurable ; on part du **plus grand** calibre puis on descend au **plus petit adapté** (le plus précis). Sur un appareil à aiguille : **Valeur = Lecture × Calibre ÷ Échelle** (ex. 40 × 1 ÷ 100 = 0,40 A).
- **En série : une seule intensité.** Dans un circuit **série**, l''intensité est **la même en tout point**, quel que soit l''ordre des dipôles ; ajouter un récepteur en série la **diminue**. Une intensité **nulle** signale une **coupure**.
- **La loi des nœuds.** En dérivation, le courant se partage aux nœuds : la somme des intensités **arrivant** à un nœud égale la somme de celles qui en **partent**. Ainsi I₁ = I₂ + I₃ (0,90 A = 0,65 A + 0,25 A).
- **Fusible et sécurité.** Un **fusible** fond dès que l''intensité dépasse un seuil et coupe le courant. Pour le corps humain : 30 mA → paralysie, 50 mA → asphyxie, 100 mA → fibrillation cardiaque.', 3, '{"code":"223103P00","pages":"43-56","pageNumbers":[43,44,45,46,47,48,49,50,51,52,53,54,55,56]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('cefe9013-8f6e-57cc-beb2-addd28192c81', 'physique-1ere-sec', 'La tension électrique', 'La tension électrique et son unité le volt (V) ; le voltmètre et son branchement en dérivation (bornes V et COM) ; la tension aux bornes d''un dipôle isolé (non nulle pour un générateur, nulle pour un récepteur) ; force électromotrice (tension à vide) et tension nominale ; la tension en circuit fermé ; le caractère algébrique de la tension, la notation UAB et la relation UAB = −UBA ; la loi des mailles ; l''oscilloscope et la tension continue', '# ⚡ La tension électrique — la « pression » qui pousse le courant

> 💡 «Sur une pile, il est écrit 4,5 V ; sur une lampe, 3 V. Ce « V », c''est le volt, l''unité de la tension. Ce chapitre t''explique ce que mesure cette valeur — et pourquoi elle peut être négative.»

Tu sais mesurer le débit du courant (l''intensité). Voici la seconde grandeur clé : la **tension**. C''est elle qui caractérise un dipôle par ses bornes, et qui explique pourquoi un courant circule.

## ⚡ La tension et le volt

Les indications « 1,5 V », « 4,5 V », « 220 V » sur les piles, les lampes ou le compteur désignent une **tension**. La tension caractérise un dipôle **par ses deux bornes**. Elle est **notée U**, s''exprime en **volt** (symbole **V**) et se mesure avec un **voltmètre**.

## 🔀 Le voltmètre en dérivation

Contrairement à l''ampèremètre, le voltmètre se branche **en dérivation**, c''est-à-dire **aux bornes** du dipôle. Le courant entre par la borne **V** (rouge, +) et la borne **COM** (noire, −) se relie à l''autre borne.

::: figure Le voltmètre est branché en dérivation : ses deux fils rejoignent directement les deux bornes de la lampe, sans couper le circuit
<svg viewBox="0 0 300 165">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M35 55 H100"/><path d="M140 55 H265"/>
<path d="M85 55 V115"/><path d="M85 115 H105"/>
<path d="M155 55 V115"/><path d="M155 115 H135"/>
</g>
<circle cx="120" cy="55" r="18" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M107 42 L133 68 M133 42 L107 68" stroke="#0f172a" stroke-width="1.3"/>
<g fill="#0f172a"><circle cx="85" cy="55" r="3.5"/><circle cx="155" cy="55" r="3.5"/></g>
<circle cx="120" cy="115" r="16" fill="#e0e7ff" stroke="#0f172a" stroke-width="2"/>
<text x="120" y="121" font-size="15" font-weight="700" fill="#0f172a" text-anchor="middle">V</text>
<g font-size="12" font-weight="700" fill="#0f172a" text-anchor="middle">
<text x="120" y="27">lampe</text><text x="120" y="150">voltmètre</text>
</g>
</svg>
:::

## 🔌 Dipôle isolé : générateur ou récepteur

Mesure la tension aux bornes d''un dipôle **isolé** (non branché dans un circuit). Deux cas :

- aux bornes d''un **générateur** (une pile), la tension est **non nulle** ;
- aux bornes d''un **récepteur** (lampe, moteur, diode) isolé, la tension est **nulle**.

C''est un test : **un dipôle isolé dont la tension n''est pas nulle est un générateur.**

Deux mots à ne pas confondre :

- la **force électromotrice (f.é.m.)** : la tension d''un générateur **à vide** (non branché à un récepteur) ;
- la **tension nominale** : la tension qu''il faut appliquer à un **récepteur** pour qu''il fonctionne normalement. En dessous, il fonctionne mal ; **au-dessus, il se détériore**.

## ➕➖ La tension est algébrique

Inverse les branchements d''un voltmètre numérique : il affiche la **même valeur, mais négative**. La **tension est une grandeur algébrique** : elle peut être positive ou négative.

On note **UAB** la tension aux bornes d''un dipôle placé entre A et B, mesurée quand la borne **V** est reliée à A et **COM** à B. On la représente par une **flèche allant de B vers A**. Inverser les points inverse le signe :

$$ UAB = −UBA $$

La tension UAB est aussi appelée **différence de potentiel** (d.d.p.), notée VA − VB.

> ⚠️ Piège classique : « l''unité de la tension est le voltmètre ». Non ! L''unité est le **volt (V)** ; le **voltmètre** est l''appareil de mesure. Ne confonds pas la grandeur et l''instrument.

## 🔄 La loi des mailles

Aux bornes d''un **fil** parcouru par un courant, la tension est **nulle**. Sur une **maille** (une boucle fermée), les tensions se compensent :

> 🗡️ **Loi des mailles** : dans une maille, la **somme algébrique** des tensions aux bornes des différents dipôles est **nulle**.

_Exemple détaillé_ : un générateur de tension U = 6 V alimente deux lampes en série, de tensions U₁ et U₂. La loi des mailles donne U = U₁ + U₂. Si U₁ = 2 V, alors U₂ = 6 − 2 = **4 V** ✓.

::: figure Autour de la maille, la tension du générateur se répartit sur les deux lampes : U = U₁ + U₂, soit 6 = 2 + 4
<svg viewBox="0 0 320 175">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M55 50 V78"/><path d="M55 112 V150"/>
<path d="M55 50 H115"/><path d="M155 50 H205"/><path d="M245 50 H265"/>
<path d="M265 50 V150"/><path d="M55 150 H265"/>
</g>
<g stroke="#0f172a" stroke-width="2.5"><path d="M40 85 H70"/><path d="M48 106 H62"/></g>
<circle cx="135" cy="50" r="15" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M124 39 L146 61 M146 39 L124 61" stroke="#0f172a" stroke-width="1.3"/>
<circle cx="225" cy="50" r="15" fill="#fde68a" stroke="#0f172a" stroke-width="2"/>
<path d="M214 39 L236 61 M236 39 L214 61" stroke="#0f172a" stroke-width="1.3"/>
<g font-size="12" font-weight="700" fill="#0f172a" text-anchor="middle">
<text x="30" y="90">+</text>
<text x="90" y="172" text-anchor="start">U = 6 V (générateur)</text>
<text x="135" y="90">U₁ = 2 V</text>
<text x="225" y="90">U₂ = 4 V</text>
</g>
</svg>
:::

## 📉 L''oscilloscope et la tension continue

Un **oscilloscope** permet de **visualiser** une tension et d''en mesurer la valeur. Branche une pile plate à son entrée : l''écran affiche un **trait horizontal**. Cela signifie que la tension **ne varie pas au cours du temps** : c''est une **tension continue**.

> 🏆 Dernière quête du thème L''ÉLECTRICITÉ franchie, héros ! Tu sais mesurer une tension au voltmètre, distinguer générateur et récepteur, manier son signe et appliquer la loi des mailles. Intensité et tension en main, tu es prêt pour la suite : la caractéristique d''un dipôle.', '# 📜 Résumé : La tension électrique

- **La tension et le volt.** La **tension**, notée **U**, caractérise un dipôle par ses deux bornes. Elle s''exprime en **volt (V)** et se mesure avec un **voltmètre**.
- **Le voltmètre en dérivation.** Le voltmètre se branche **en dérivation**, aux bornes du dipôle : borne **V (+)** d''un côté, borne **COM (−)** de l''autre. (À l''inverse de l''ampèremètre, qui se branche en série.)
- **Dipôle isolé.** Aux bornes d''un **générateur** isolé, la tension est **non nulle** ; aux bornes d''un **récepteur** isolé, elle est **nulle** — c''est un test pour les distinguer. La **f.é.m.** est la tension d''un générateur **à vide** ; la **tension nominale** est celle qu''il faut appliquer à un récepteur pour qu''il fonctionne normalement (une tension trop grande le **détériore**).
- **La tension est algébrique.** Elle peut être positive ou négative : **UAB = −UBA**. On la note **UAB** (borne V reliée à A, COM reliée à B) et on la représente par une **flèche de B vers A**. C''est aussi la **différence de potentiel** VA − VB.
- **La loi des mailles.** Sur une **maille** (boucle fermée), la **somme algébrique** des tensions aux bornes des dipôles est **nulle**. Ainsi, pour un générateur (U) alimentant deux lampes en série : U = U₁ + U₂ (par exemple 6 V = 2 V + 4 V). La tension aux bornes d''un simple fil est nulle.
- **L''oscilloscope et la tension continue.** L''**oscilloscope** visualise une tension. Un **trait horizontal** à l''écran signale une tension qui ne varie pas dans le temps : une **tension continue**.', 4, '{"code":"223103P00","pages":"57-70","pageNumbers":[57,58,59,60,61,62,63,64,65,66,67,68,69,70]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('fa37b216-c0bf-59cd-aa50-40529b1b01f0', 'physique-1ere-sec', 'Le dipôle résistor', 'La caractéristique intensité-tension U = f(I) d''un dipôle ; le dipôle résistor (ou conducteur ohmique), reconnu à sa caractéristique en droite passant par l''origine et à la proportionnalité entre U et I ; la résistance R et son unité l''ohm (Ω) ; la loi d''Ohm U = R × I ; la mesure d''une résistance (ohmmètre, code des couleurs) ; le rhéostat qui règle l''intensité ; les caractéristiques non linéaires (lampe, électrolyseur, diode) ; la sécurité électrique liée à la résistance du corps humain', '# ⚡ Le dipôle résistor — quand tension et intensité marchent au pas

> 💡 «Tu sais mesurer une intensité et une tension. Question de héros : quand tu doubles la tension aux bornes d''un composant, que devient le courant qui le traverse ? Pour un dipôle bien particulier, la réponse est d''une simplicité redoutable.»

Tu maîtrises l''intensité I (le débit du courant) et la tension U (aux bornes d''un dipôle). Ce chapitre relie enfin les deux : pour un **dipôle résistor**, U et I obéissent à une loi limpide, la **loi d''Ohm**.

## 📈 La caractéristique intensité-tension

Branche un dipôle récepteur à un générateur **réglable**. Pour chaque valeur de la tension U appliquée, tu relèves l''intensité I qui traverse le dipôle. En plaçant tous les couples (I, U) dans un repère, tu obtiens une courbe.

Cette courbe, qui représente **U en fonction de I**, s''appelle la **caractéristique intensité-tension** du dipôle. Elle est la carte d''identité électrique du composant : deux dipôles différents n''ont pas la même caractéristique.

## 📐 Le dipôle résistor : une droite qui passe par l''origine

Pour certains dipôles, la caractéristique est une **portion de droite qui passe par l''origine**. Un tel dipôle est appelé **dipôle résistor** (ou **conducteur ohmique**).

::: figure Pour un dipôle résistor, la caractéristique U = f(I) est une droite qui part de l''origine : U et I augmentent ensemble, dans le même rapport
<svg viewBox="0 0 220 160">
<g fill="none" stroke="#0f172a" stroke-width="2.5">
<path d="M35 20 V132 H205"/>
<path d="M35 132 L190 38"/>
</g>
<g fill="#0f172a" font-size="12" font-weight="700">
<text x="18" y="26">U</text>
<text x="196" y="150">I</text>
<text x="24" y="146">O</text>
</g>
</svg>
:::

Une droite passant par l''origine, en mathématiques, signale une **proportionnalité**. Ici : **la tension U et l''intensité I sont proportionnelles**. Le quotient U/I garde donc la **même valeur** en tout point de la droite.

## 🛡️ La résistance et la loi d''Ohm

Ce quotient constant est une nouvelle grandeur : la **résistance** du résistor, notée **R**.

$$ R = U / I $$

Elle mesure à quel point le dipôle **s''oppose au passage du courant** : à tension égale, plus R est grande, moins il passe de courant. La résistance s''exprime dans le système international en **ohm**, de symbole **Ω**.

En réarrangeant ce quotient, on obtient la relation reine du chapitre, la **loi d''Ohm** :

$$ U = R × I $$

> 🗡️ **Loi d''Ohm** : la tension U aux bornes d''un résistor est égale au produit de sa résistance R par l''intensité I qui le traverse.

_Exemple détaillé_ : un résistor de résistance **R = 12 Ω** est traversé par un courant **I = 0,5 A**. La tension à ses bornes vaut U = R × I = 12 × 0,5 = **6 V** ✓. Inversement, si tu mesures U = 6 V et I = 0,5 A, tu retrouves R = U/I = 6 ÷ 0,5 = **12 Ω**.

## 🔧 Mesurer une résistance

Deux moyens de connaître R sans tracer de graphique :

- l''**ohmmètre** (une fonction du multimètre) : hors tension, on branche le résistor entre les bornes **COM** et **Ω**, et la valeur s''affiche directement ;
- le **code des couleurs** : des anneaux colorés imprimés sur le résistor codent sa valeur, qui se lit directement.

## 🎛️ Le rhéostat : régler l''intensité

Un **rhéostat** est un **résistor réglable** : en déplaçant un curseur, on modifie la longueur de fil parcourue, donc sa résistance. Inséré dans un circuit, il permet de **commander l''intensité** du courant — c''est ainsi qu''on ajuste la vitesse d''un moteur ou l''éclat d''une lampe.

## 🔮 Tous les dipôles ne se ressemblent pas

Attention : **tous les dipôles ne sont pas des résistors**. La lampe à incandescence, l''électrolyseur ou la diode ont des caractéristiques qui ne sont **pas des droites passant par l''origine**. Ils ne réalisent donc pas de relation de proportionnalité entre U et I.

> ⚠️ Piège classique : « une droite, donc un résistor ». Non ! Il faut une droite **qui passe par l''origine**. Une caractéristique courbe, ou une droite décalée, n''est pas celle d''un résistor.

Enfin, le corps humain est lui aussi un conducteur, de résistance **5000 Ω** environ (peau sèche) mais seulement **1000 Ω** si la peau est mouillée. Comme I = U/R, une tension d''autant plus faible devient dangereuse que la résistance chute : le seuil de danger tombe à **25 V** en milieu humide, contre **50 V** en conditions habituelles.

> 🏆 Dernière quête du thème L''ÉLECTRICITÉ franchie, héros ! Tu sais lire une caractéristique, reconnaître un résistor, appliquer la loi d''Ohm et manier le rhéostat. Range tes fils : le prochain thème t''attend, LA MATIÈRE et ses trois états.', '# 📜 Résumé : Le dipôle résistor

- **La caractéristique intensité-tension.** La courbe qui représente la tension **U en fonction de l''intensité I** est la **caractéristique intensité-tension** d''un dipôle : sa carte d''identité électrique.
- **Le dipôle résistor.** Un **dipôle résistor** (ou **conducteur ohmique**) a une caractéristique en **portion de droite passant par l''origine** : U et I sont donc **proportionnelles** (le quotient U/I est constant).
- **La résistance et la loi d''Ohm.** Ce quotient constant est la **résistance R = U/I**, exprimée en **ohm (Ω)** ; elle mesure l''opposition au passage du courant. D''où la **loi d''Ohm : U = R × I** (par exemple R = 12 Ω et I = 0,5 A donnent U = 6 V).
- **Mesurer une résistance.** On lit R directement à l''**ohmmètre** (branché hors tension) ou grâce au **code des couleurs** imprimé sur le résistor.
- **Le rhéostat.** Un **rhéostat** est un **résistor réglable** : on l''insère dans un circuit pour **commander l''intensité** du courant.
- **Les caractéristiques non linéaires.** Tous les dipôles ne sont pas des résistors : la **lampe à incandescence**, l''**électrolyseur** et la **diode** ont des caractéristiques qui ne sont pas des droites passant par l''origine.
- **Sécurité électrique.** Le corps humain a une résistance d''environ **5000 Ω** (peau sèche), qui chute vers **1000 Ω** si la peau est mouillée : le seuil de tension dangereuse tombe alors de **50 V** à **25 V**.', 5, '{"code":"223103P00","pages":"71-86","pageNumbers":[71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('090c9e09-759f-5ce2-af21-f48409c41776', 'physique-1ere-sec', 'Les états physiques de la matière', 'Les trois états physiques (solide, liquide, gazeux) ; le critère de préhension entre les doigts qui distingue les solides des fluides (liquides et gaz) ; l''air est de la matière ; le volume, grandeur qui caractérise l''espace occupé, et ses unités (m³, L, mL, cm³) ; les propriétés macroscopiques (forme propre, volume propre, surface libre) ; la compressibilité et l''expansibilité des gaz ; la description microscopique des trois états (ordre, contact et agitation des particules)', '# 🧊 Les états physiques de la matière — solide, liquide, gazeux

> 💡 «Un glaçon, un verre d''eau, l''air que tu respires : la même eau peut être dure comme un caillou, couler entre tes doigts ou s''échapper invisible. Trois états, trois comportements — et une explication cachée à l''échelle des particules.»

Nouveau thème, héros : **LA MATIÈRE**. Tu vas apprendre à ranger tout ce qui t''entoure en trois grandes familles, à mesurer l''espace qu''un corps occupe, et à comprendre ce qui se passe **à l''intérieur** de la matière.

## 🧊 Les trois états de la matière

La matière se présente sous trois **états physiques** principaux :

- l''**état solide** (une bille d''acier, une craie, un clou) ;
- l''**état liquide** (l''eau, l''huile, l''alcool) ;
- l''**état gazeux** (l''air, le dioxygène, le diazote).

## ✋ Solides et fluides : le critère de préhension

Comment reconnaître l''état d''un corps ? Un test simple : essaie de le **saisir entre les doigts**.

- un **solide** est **saisissable** entre les doigts : la bille d''acier reste dans ta main ;
- un **liquide** et un **gaz** ne le sont pas : ils **s''écoulent** facilement. On les appelle des **fluides**.

> 🗡️ Un « verre vide » ne l''est pas ! Renverse-le sur l''eau et incline-le : des bulles s''échappent. **L''air est de la matière.** Retiens la règle : **deux corps ne peuvent pas occuper le même espace en même temps.**

> ⚠️ Piège classique : « ça coule, donc c''est un liquide ». Faux ! La farine, le sable, le sucre ou la semoule **coulent** mais restent **saisissables entre les doigts** : ce sont des **solides** en grains, pas des liquides.

## 📏 Le volume et ses unités

Le **volume** d''un corps est la grandeur qui caractérise l''**espace qu''il occupe**. C''est une grandeur **mesurable** ; son unité dans le système international est le **mètre cube (m³)**.

On utilise souvent des unités plus petites, à connaître par cœur :

$$ 1 mL = 1 cm³ $$
$$ 1 L = 1000 mL = 1000 cm³ = 1 dm³ $$
$$ 1 m³ = 1000 L $$

Pour un solide de forme géométrique simple, le volume se **calcule** à partir des dimensions :

| Solide          | Volume         |
| --------------- | -------------- |
| cube (arête a)  | a³             |
| pavé (L, l, h)  | L × l × h      |
| cylindre (R, h) | π × R² × h     |
| sphère (R)      | (4/3) × π × R³ |

_Exemple détaillé_ : un cube d''arête a = 5 cm a pour volume V = a³ = 5 × 5 × 5 = **125 cm³**, soit **125 mL** ✓ (puisque 1 cm³ = 1 mL).

Pour un solide de forme quelconque, on mesure son volume par **déplacement d''eau** dans une éprouvette graduée.

> 🗡️ Au contact du verre, la surface libre de l''eau se courbe légèrement : c''est le **ménisque**. On lit le volume en plaçant l''œil **au niveau** de la surface, jamais en plongée.

## 🧱 Forme propre, volume propre, surface libre

Chaque état a ses propriétés. À retenir dans ce tableau :

| État    | Forme propre ? | Volume propre ? | Particularité                      |
| ------- | -------------- | --------------- | ---------------------------------- |
| solide  | oui            | oui             | garde toujours sa forme            |
| liquide | non            | oui             | surface libre plane et horizontale |
| gaz     | non            | non             | occupe tout l''espace offert        |

Un **solide** garde sa forme et son volume quel que soit le récipient. Un **liquide** épouse la forme de son contenant (pas de forme propre) mais conserve son volume ; sa **surface libre** est plane et horizontale.

## 💨 Les gaz : compressibles et expansibles

Emprisonne un gaz dans une seringue bouchée. Pousse le piston : le gaz occupe **moins** d''espace — il est **compressible**. Tire le piston : il occupe **plus** d''espace — il est **expansible**. Un gaz n''a donc **ni forme propre ni volume propre** : il occupe **tout** l''espace qu''on lui offre.

## 🔬 Zoom microscopique sur les trois états

La matière est faite de **particules** (molécules, atomes ou ions). Leur arrangement explique tout :

::: figure Dans le solide, les particules se touchent et sont ordonnées ; dans le liquide, elles se touchent mais sont désordonnées ; dans le gaz, elles sont dispersées et très agitées
<svg viewBox="0 0 300 118">
<g fill="none" stroke="#0f172a" stroke-width="2">
<rect x="8" y="14" width="84" height="80"/>
<rect x="108" y="14" width="84" height="80"/>
<rect x="208" y="14" width="84" height="80"/>
</g>
<g fill="#93c5fd" stroke="#0f172a" stroke-width="1.5">
<circle cx="28" cy="34" r="11"/><circle cx="50" cy="34" r="11"/><circle cx="72" cy="34" r="11"/>
<circle cx="28" cy="54" r="11"/><circle cx="50" cy="54" r="11"/><circle cx="72" cy="54" r="11"/>
<circle cx="28" cy="74" r="11"/><circle cx="50" cy="74" r="11"/><circle cx="72" cy="74" r="11"/>
<circle cx="126" cy="36" r="11"/><circle cx="149" cy="32" r="11"/><circle cx="172" cy="38" r="11"/>
<circle cx="122" cy="58" r="11"/><circle cx="146" cy="60" r="11"/><circle cx="170" cy="56" r="11"/>
<circle cx="134" cy="80" r="11"/><circle cx="159" cy="80" r="11"/>
<circle cx="224" cy="32" r="7"/><circle cx="256" cy="46" r="7"/><circle cx="281" cy="30" r="7"/>
<circle cx="230" cy="72" r="7"/><circle cx="268" cy="80" r="7"/><circle cx="248" cy="58" r="7"/>
</g>
<g fill="#0f172a" font-size="12" font-weight="700" text-anchor="middle">
<text x="50" y="110">solide</text><text x="150" y="110">liquide</text><text x="250" y="110">gazeux</text>
</g>
</svg>
:::

- **Solide** : les particules se **touchent**, gardent la même disposition (**ordonnée** si le solide est cristallin) et sont **très peu agitées**.
- **Liquide** : les particules se **touchent** encore, mais **désordonnées**, elles **glissent** les unes sur les autres.
- **Gaz** : les particules sont **dispersées**, **espacées** et **très agitées**.

> 🏆 Première quête du thème LA MATIÈRE franchie ! Tu classes les corps en trois états, tu mesures un volume et tu sais ce que cachent les particules. Prochaine étape : ce qui arrive à la matière quand on la chauffe ou la refroidit.', '# 📜 Résumé : Les états physiques de la matière

- **Les trois états.** La matière se présente sous trois états physiques : **solide**, **liquide** et **gazeux**.
- **Solides et fluides.** Un **solide** est **saisissable entre les doigts** ; les **liquides** et **gaz** s''écoulent et ne le sont pas : ce sont des **fluides**. Les grains (farine, sable) coulent mais restent saisissables : ce sont des solides. L''**air est de la matière**, et deux corps ne peuvent occuper le même espace en même temps.
- **Le volume et ses unités.** Le **volume** caractérise l''espace occupé par un corps ; unité SI le **mètre cube (m³)**. À retenir : **1 mL = 1 cm³**, **1 L = 1000 mL = 1 dm³**, **1 m³ = 1000 L**. Volume du cube = a³ ; du pavé = L × l × h.
- **Forme propre, volume propre.** Un **solide** a une forme propre et un volume propre ; un **liquide** a un volume propre mais pas de forme propre (surface libre plane et horizontale) ; un **gaz** n''a ni l''une ni l''autre et occupe tout l''espace offert.
- **Les gaz.** Un gaz est **compressible** (occupe moins d''espace sous le piston) et **expansible** (occupe plus d''espace).
- **Description microscopique.** Les **particules** sont au contact et **ordonnées** dans le solide (peu agitées), au contact mais **désordonnées** dans le liquide (elles glissent), **dispersées et très agitées** dans le gaz.', 6, '{"code":"223103P00","pages":"87-100","pageNumbers":[87,88,89,90,91,92,93,94,95,96,97,98,99,100]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('c6786b76-bc3d-55f9-80fb-b9b4febeca46', 'physique-1ere-sec', 'Quelques propriétés de la matière', 'L''effet de la température sur le volume : la dilatation (échauffement) et la contraction (refroidissement) des solides, liquides et gaz ; la dépendance de la dilatation à la nature, au volume et à la variation de température ; la hiérarchie gaz > liquides > solides ; l''anomalie de l''eau entre 0 °C et 4 °C ; le thermomètre et l''échelle Celsius (points fixes 0 °C et 100 °C) ; la conductivité thermique et le classement des bons et mauvais conducteurs de chaleur ; le lien entre conducteurs électriques et conducteurs thermiques', '# 🔥 Quelques propriétés de la matière — chaud, froid et dilatation

> 💡 «Pourquoi laisse-t-on un petit espace entre deux rails de chemin de fer ? Pourquoi une bouteille d''eau pleine éclate-t-elle au congélateur ? La réponse tient en un mot : la matière réagit à la température.»

Tu connais les trois états de la matière. Voici maintenant comment la matière **change** quand on la chauffe ou la refroidit : elle se dilate, se contracte, conduit plus ou moins la chaleur — et l''eau, elle, joue les rebelles.

## 🔥 Dilatation et contraction

Chauffe un corps : son volume **augmente**, on dit qu''il se **dilate**. Refroidis-le : son volume **diminue**, il se **contracte**. C''est vrai pour les **solides**, les **liquides** et les **gaz**.

_Exemple détaillé_ : une bille métallique passe tout juste dans un anneau. Chauffée, elle **grossit** et ne passe plus ; refroidie, elle repasse. La bille ne s''est pas transformée : seul son **volume** a varié avec la température.

## 🧭 De quoi dépend la dilatation

La dilatation d''un corps dépend de **trois facteurs** :

- sa **nature** (le matériau) ;
- son **volume** (ou sa longueur) initial ;
- la **variation de sa température**.

Pour un solide **filiforme** (un long fil de longueur l₀), l''allongement Δl obéit à la relation :

$$ Δl = l₀ × λ × Δθ $$

où Δθ est la variation de température et **λ une constante qui dépend du matériau**. Ainsi, chauffées pareillement, trois tiges de même longueur s''allongent différemment : l''**aluminium** plus que le **cuivre**, qui s''allonge plus que le **fer**.

## 📊 Qui se dilate le plus ?

À volume égal et pour une même élévation de température, l''ordre est toujours le même :

$$ gaz > liquides > solides $$

Les **gaz** se dilatent beaucoup plus que les **liquides**, qui se dilatent plus que les **solides**.

## 💧 L''anomalie de l''eau

L''eau désobéit à la règle « refroidir = se contracter ». En la refroidissant de 4 °C jusqu''à 0 °C, son volume **augmente** au lieu de diminuer ! Son volume est **minimal à 4 °C**.

::: figure Le volume d''une même masse d''eau passe par un minimum à 4 °C : en dessous, l''eau se dilate en refroidissant
<svg viewBox="0 0 230 140">
<g fill="none" stroke="#0f172a" stroke-width="2">
<path d="M40 20 V115 H212" />
</g>
<path d="M40 34 C 72 72, 104 104, 120 106 C 138 104, 170 72, 200 38" fill="none" stroke="#2563eb" stroke-width="2.5" />
<g stroke="#0f172a" stroke-width="1.5">
<path d="M120 115 V119" />
<path d="M200 115 V119" />
</g>
<circle cx="120" cy="106" r="3.5" fill="#2563eb" stroke="none" />
<g fill="#0f172a" font-size="11" font-weight="700">
<text x="24" y="26">V</text>
<text x="182" y="134">θ (°C)</text>
<text x="30" y="127">0</text>
<text x="116" y="132">4</text>
<text x="196" y="132">8</text>
</g>
</svg>
:::

> 🗡️ C''est pour cela qu''une bouteille en verre **pleine d''eau** placée au froid **se casse** : en gelant, l''eau augmente de volume et pousse sur les parois.

## 🌡️ Le thermomètre et l''échelle Celsius

Un **thermomètre** repère la température d''un corps. Son principe : la **dilatation** d''un liquide, souvent le **mercure**, choisi car il se dilate facilement, s''obtient pur et **ne mouille pas** le verre.

L''**échelle Celsius** est bâtie sur deux **points fixes** :

| Point fixe                        | Température |
| --------------------------------- | ----------- |
| glace fondante                    | 0 °C        |
| eau bouillante (pression normale) | 100 °C      |

L''intervalle est partagé en 100 parts égales : chaque part est un **degré Celsius**, de symbole **°C**.

## 🔗 La conductivité thermique

Tous les corps ne transmettent pas la chaleur de la même façon. La **conductivité thermique** d''un corps dépend de la **nature** du matériau : le cuivre conduit mieux la chaleur que l''aluminium, qui conduit beaucoup mieux que le verre.

| Conducteurs              | Exemples                         |
| ------------------------ | -------------------------------- |
| bons conducteurs         | argent, cuivre, aluminium, fer   |
| mauvais conducteurs      | verre, bois, brique, papier      |
| très mauvais conducteurs | amiante, plastique, laine, liège |

> 🗡️ Retiens le pont avec le chapitre 1 : les solides **bons conducteurs d''électricité** sont généralement de **bons conducteurs de chaleur** (comme les métaux), et les **isolants électriques** sont de **mauvais conducteurs de chaleur** (comme le bois).

> ⚠️ Piège classique : « le bois se dilate donc c''est un bon conducteur ». Non ! Se dilater et conduire la chaleur sont **deux propriétés différentes**. Le bois se dilate un peu à la chaleur mais reste un **isolant thermique**.

> 🏆 Deuxième quête du thème LA MATIÈRE franchie ! Tu sais pourquoi les corps se dilatent, pourquoi l''eau est spéciale et pourquoi la poignée d''une casserole n''est pas en métal. Cap sur la grandeur suivante : la masse.', '# 📜 Résumé : Quelques propriétés de la matière

- **Dilatation et contraction.** En s''échauffant, les solides, liquides et gaz **se dilatent** (leur volume augmente) ; en se refroidissant, ils **se contractent**.
- **De quoi dépend la dilatation.** Elle dépend de la **nature** du corps, de son **volume** et de la **variation de sa température**. Pour un solide filiforme : **Δl = l₀ × λ × Δθ**, où λ dépend du matériau.
- **Qui se dilate le plus.** À volume égal et pour une même élévation de température : **gaz > liquides > solides**.
- **L''anomalie de l''eau.** L''eau se **dilate** lorsqu''on la refroidit de 4 °C à 0 °C ; son volume est **minimal à 4 °C**. C''est pourquoi une bouteille pleine d''eau se casse en gelant.
- **Le thermomètre et l''échelle Celsius.** Le **thermomètre** fonctionne grâce à la **dilatation** (souvent du mercure). L''échelle **Celsius (°C)** a deux points fixes : **glace fondante = 0 °C**, **eau bouillante = 100 °C**.
- **La conductivité thermique.** Elle dépend de la **nature** du matériau : les **métaux** (argent, cuivre, aluminium, fer) sont de **bons conducteurs** de chaleur ; le **bois**, le **verre** et la **laine** sont de mauvais conducteurs. Les bons conducteurs d''électricité sont généralement de bons conducteurs de chaleur.', 7, '{"code":"223103P00","pages":"101-114","pageNumbers":[101,102,103,104,105,106,107,108,109,110,111,112,113,114]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('32d59637-8b9b-5c5d-be28-a661504a41e7', 'physique-1ere-sec', 'La masse', 'La masse, grandeur physique qui caractérise la quantité de matière (unité le kilogramme, kg), indépendante de la forme, de la position et de l''état physique du corps ; sa mesure avec la balance de Roberval et les masses marquées ; la masse volumique ρ = m/V et son unité kg·m⁻³ ; la densité d = ρ(substance)/ρ(eau), grandeur sans unité ; la flottaison et le classement des corps par densité par rapport à l''eau ; la détection d''une cavité par comparaison de la masse volumique', '# ⚖️ La masse — mesurer la quantité de matière

> 💡 «Sur un paquet de couscous : 1 kg. Sur une bouteille d''huile : 920 g. Ce nombre dit combien de matière tu tiens. Mais alors, pourquoi 1 kg de liège occupe-t-il tant de place, et 1 kg de plomb si peu ?»

Tu sais mesurer un volume. Voici la grandeur qui va avec : la **masse**. En la combinant au volume, tu vas découvrir deux grandeurs qui identifient une substance : la **masse volumique** et la **densité**.

## ⚖️ La masse, quantité de matière

La **masse** d''un corps est la grandeur physique qui caractérise la **quantité de matière** qu''il contient. C''est une grandeur **mesurable** ; son unité dans le système international est le **kilogramme (kg)**, et on la mesure avec une **balance**.

> 🗡️ Règle d''or : la masse d''un corps **ne dépend ni de sa forme, ni de sa position dans l''espace, ni de son état physique**. Écrase une boule de pâte : sa masse ne change pas. Fais fondre un glaçon : la masse de l''eau reste la même.

## 🪙 Mesurer une masse : la balance de Roberval

La **balance de Roberval** compare la masse d''un corps à des **masses marquées** connues. On place le corps sur un plateau, puis on ajoute des masses marquées sur l''autre jusqu''à l''**équilibre** : la masse du corps est alors la **somme** des masses marquées.

_Exemple détaillé_ : à l''équilibre, on a posé sur l''autre plateau des masses de 50 g, 10 g et 2 g. La masse du corps vaut donc m = 50 + 10 + 2 = **62 g** ✓.

## 🧊 La masse volumique

Deux corps de même volume n''ont pas forcément la même masse : le volume seul ne suffit pas à identifier une substance. On définit alors la **masse volumique**, notée **ρ** (rho), comme le rapport de la masse au volume :

$$ ρ = m / V $$

Son unité dans le système international est le **kg·m⁻³** (on utilise aussi le **g·cm⁻³** et le **kg·L⁻¹**). À retenir : **1 g·cm⁻³ = 1000 kg·m⁻³**.

| Substance | Masse volumique (kg·m⁻³) |
| --------- | ------------------------ |
| liège     | 240                      |
| eau       | 1000                     |
| aluminium | 2700                     |
| cuivre    | 8900                     |
| plomb     | 11300                    |
| or        | 19300                    |

_Exemple détaillé_ : un morceau de cuivre de masse m = 89 g occupe un volume V = 10 cm³. Sa masse volumique est ρ = m/V = 89/10 = **8,9 g·cm⁻³**, soit **8900 kg·m⁻³** ✓.

> ⚠️ Piège classique : « la masse volumique ne change jamais ». Faux ! Elle **varie avec la température** : quand un corps se dilate, son volume augmente alors que sa masse reste la même, donc ρ diminue.

## 🌊 La densité

La **densité** d''une substance, notée **d**, compare sa masse volumique à celle de l''**eau** :

$$ d = ρ(substance) / ρ(eau) $$

Comme on divise deux masses volumiques exprimées dans la même unité, la densité **n''a pas d''unité**. Avec ρ(eau) = 1000 kg·m⁻³ :

| Substance   | Densité |
| ----------- | ------- |
| liège       | 0,24    |
| huile       | 0,92    |
| eau         | 1,00    |
| chloroforme | 1,48    |
| cuivre      | 8,90    |
| or          | 19,30   |

_Exemple détaillé_ : pour le cuivre, d = ρ(cuivre)/ρ(eau) = 8900/1000 = **8,90** ✓ (sans unité).

## 🛟 Flotter ou couler

La densité range les substances par rapport à l''eau :

- une substance de densité **plus grande que 1** est **plus dense que l''eau** : elle **coule** (cuivre, or) ;
- une substance de densité **plus petite que 1** est **moins dense que l''eau** : elle **flotte** (liège, huile).

Verse dans un tube des liquides qui ne se mélangent pas : ils se rangent par densité, le **plus dense au fond**.

::: figure Des liquides non miscibles se superposent par densité : le chloroforme (le plus dense) au fond, l''alcool (le moins dense) au-dessus
<svg viewBox="0 0 240 150">
<g stroke="#0f172a" stroke-width="1.5">
<rect x="70" y="34" width="70" height="26" fill="#ddd6fe" />
<rect x="70" y="60" width="70" height="26" fill="#fde68a" />
<rect x="70" y="86" width="70" height="26" fill="#93c5fd" />
<rect x="70" y="112" width="70" height="22" fill="#cbd5e1" />
</g>
<path d="M70 20 V134 H140 V20" fill="none" stroke="#0f172a" stroke-width="2.5" />
<g fill="#0f172a" font-size="11" font-weight="700">
<text x="148" y="51">alcool (0,79)</text>
<text x="148" y="77">huile (0,92)</text>
<text x="148" y="103">eau (1,00)</text>
<text x="148" y="127">chloroforme (1,48)</text>
</g>
</svg>
:::

> 🏆 Troisième quête du thème LA MATIÈRE franchie ! Tu mesures une masse, tu calcules une masse volumique et une densité, et tu prévois si un corps flotte ou coule. Bravo, héros : tu tiens les grandeurs qui identifient la matière.', '# 📜 Résumé : La masse

- **La masse, quantité de matière.** La **masse** caractérise la quantité de matière d''un corps ; unité SI le **kilogramme (kg)**, mesurée avec une **balance**. Elle **ne dépend ni de la forme, ni de la position, ni de l''état physique** du corps.
- **Mesurer une masse.** La **balance de Roberval** compare le corps à des **masses marquées** : à l''équilibre, la masse du corps est la **somme** des masses marquées (par exemple 50 + 10 + 2 = 62 g).
- **La masse volumique.** C''est le rapport de la masse au volume : **ρ = m/V**, en **kg·m⁻³** (aussi g·cm⁻³, kg·L⁻¹), avec **1 g·cm⁻³ = 1000 kg·m⁻³**. Elle **varie avec la température**. Exemple : cuivre, 89 g pour 10 cm³ → ρ = 8,9 g·cm⁻³ = 8900 kg·m⁻³.
- **La densité.** C''est le rapport de la masse volumique de la substance à celle de l''eau : **d = ρ(substance)/ρ(eau)**. Elle **n''a pas d''unité**. Exemple : cuivre, d = 8900/1000 = 8,90.
- **Flotter ou couler.** Une substance de densité **> 1** est plus dense que l''eau et **coule** (cuivre, or) ; une densité **< 1** est moins dense que l''eau et **flotte** (liège, huile). Des liquides non miscibles se rangent par densité, le plus dense au fond.', 8, '{"code":"223103P00","pages":"115-130","pageNumbers":[115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('0c787ec0-ce62-5817-b4ab-cd87ee9922a3', 'physique-1ere-sec', 'Les changements d''état d''un corps pur', 'Les six changements d''état d''un corps pur et leurs couples inverses (fusion/solidification, vaporisation/liquéfaction, sublimation/condensation) ; les deux modes de vaporisation (ébullition à température constante, évaporation à toute température) ; la température de changement d''état constante d''un corps pur sous une pression donnée (0°C et 100°C pour l''eau sous la pression atmosphérique normale) et sa lecture sur une courbe θ(t) à palier ; la conservation de la masse et de la nature au cours d''un changement d''état ; l''interprétation microscopique et la notion d''équilibre dynamique', '# 🧊 Les changements d''état — quand la matière se transforme

> 💡 «Un glaçon fond dans ton verre, l''eau bout dans la casserole, la buée se forme sur la vitre. Toujours de l''eau, mais qui passe d''un état à un autre. Comment nommer ces passages, et à quelle température se produisent-ils ?»

Tu connais déjà les **trois états physiques** : solide, liquide, gazeux. Voici maintenant les **passages** d''un état à l''autre. En les nommant et en repérant leurs **températures**, tu vas apprendre à lire la carte d''identité thermique d''un corps pur.

## 🔄 Passer d''un état à un autre

Un corps peut passer d''un **état physique** à un autre quand on **fait varier sa température**. On appelle ces passages des **changements d''état**.

> 🗡️ Règle d''or : à **chaque** changement d''état correspond un **changement d''état inverse**. Chauffer produit un passage, refroidir produit le passage contraire.

## 🧊 Les six changements d''état

Entre les trois états, il existe **six** passages, regroupés en trois couples inverses :

| Changement d''état  | Passage          | Transformation inverse |
| ------------------ | ---------------- | ---------------------- |
| **Fusion**         | solide → liquide | solidification         |
| **Solidification** | liquide → solide | fusion                 |
| **Vaporisation**   | liquide → gaz    | liquéfaction           |
| **Liquéfaction**   | gaz → liquide    | vaporisation           |
| **Sublimation**    | solide → gaz     | condensation           |
| **Condensation**   | gaz → solide     | sublimation            |

La **sublimation** est le passage **direct** du solide au gaz, sans passer par le liquide : c''est le cas de l''iode chauffé, ou d''une boule antimite qui « disparaît » peu à peu dans l''armoire.

::: figure Les six changements d''état d''un corps pur : à chaque passage (flèche du haut) correspond la transformation inverse (flèche du bas) ; la sublimation et la condensation relient directement le solide et le gaz.
<svg viewBox="0 0 320 170">
<g stroke="#0f172a" stroke-width="1.5">
<rect x="10" y="46" width="66" height="34" rx="5" fill="#bfdbfe" />
<rect x="127" y="46" width="66" height="34" rx="5" fill="#60a5fa" />
<rect x="244" y="46" width="66" height="34" rx="5" fill="#e0f2fe" />
</g>
<g fill="#0f172a" font-size="12" font-weight="700" text-anchor="middle">
<text x="43" y="67">SOLIDE</text>
<text x="160" y="67">LIQUIDE</text>
<text x="277" y="67">GAZ</text>
</g>
<g stroke="#0f172a" stroke-width="1.5" fill="none">
<path d="M80 56 H121" />
<path d="M123 70 H84" />
<path d="M197 56 H238" />
<path d="M240 70 H201" />
<path d="M43 84 Q160 150 277 84" />
</g>
<g fill="#0f172a">
<polygon points="121,52 129,56 121,60" />
<polygon points="84,66 76,70 84,74" />
<polygon points="238,52 246,56 238,60" />
<polygon points="201,66 193,70 201,74" />
<polygon points="277,84 271,92 283,92" />
</g>
<g fill="#0f172a" font-size="9.5" text-anchor="middle">
<text x="101" y="42">fusion</text>
<text x="101" y="82">solidification</text>
<text x="218" y="42">vaporisation</text>
<text x="218" y="82">liquéfaction</text>
<text x="160" y="146">sublimation → · ← condensation</text>
</g>
</svg>
:::

## ⚗️ Deux façons de se vaporiser

Un liquide peut passer à l''état gazeux de **deux manières** :

- par **ébullition** : dans toute la masse du liquide, avec de grosses bulles, à une **température constante** (100°C pour l''eau pure sous la pression atmosphérique normale) ;
- par **évaporation** : seulement à la **surface** du liquide, sans bulles, à **n''importe quelle température** (par exemple à la température ambiante).

_Exemple détaillé_ : le linge mouillé sèche à l''air libre parce que l''eau **s''évapore** à température ambiante ; il n''est pas nécessaire de le porter à 100°C ✓.

> ⚠️ Piège classique : « l''évaporation, c''est de l''ébullition à basse température ». Faux ! L''ébullition se produit dans **tout** le liquide à une température **fixe** ; l''évaporation se produit **uniquement en surface** et à **toute** température.

## 🌡️ Une température de changement d''état constante

Pour un **corps pur** sous une **pression donnée**, chaque changement d''état se produit à une **température constante**. Tant que le corps change d''état, sa température ne bouge pas : la courbe θ(t) présente un **palier**.

Pour l''**eau pure**, sous la pression atmosphérique normale, la **fusion** se produit à **0°C** et l''**ébullition** à **100°C**. Chaque corps pur a ses propres valeurs :

| Corps pur | Température de fusion | Température d''ébullition |
| --------- | --------------------- | ------------------------ |
| Eau       | 0°C                   | 100°C                    |
| Éthanol   | −117°C                | 78°C                     |
| Mercure   | −39°C                 | 357°C                    |
| Fer       | 1535°C                | 2750°C                   |

::: figure Courbe θ(t) de l''eau pure chauffée : la température monte, puis reste bloquée à 100°C (le palier) pendant toute l''ébullition, avant de remonter.
<svg viewBox="0 0 260 160">
<g stroke="#0f172a" stroke-width="1.5" fill="none">
<path d="M34 14 V138 H244" />
<path d="M34 120 L104 60 H184 L214 34" />
</g>
<g stroke="#94a3b8" stroke-width="1" stroke-dasharray="4 3">
<path d="M34 60 H104" />
</g>
<g fill="#0f172a" font-size="11">
<text x="8" y="64">100</text>
<text x="120" y="52">palier</text>
<text x="228" y="152">t</text>
<text x="14" y="20">θ(°C)</text>
</g>
</svg>
:::

## ⚖️ La masse ne change pas

Au cours d''un changement d''état, la **masse** et la **nature** du corps sont **conservées** : seul l''état (et donc le volume) change.

_Exemple détaillé_ : un glaçon de masse 50 g fond entièrement. On obtient toujours **50 g** d''eau liquide ✓ — pas un gramme de plus ni de moins.

## 🔬 Ce qui se passe chez les molécules

Un changement d''état, c''est un changement d''**organisation** des molécules, jamais de leur nature :

- lors de la **fusion**, les molécules serrées et ordonnées du solide se **désordonnent** et glissent les unes sur les autres (liquide) ;
- lors de la **vaporisation**, les molécules du liquide s''**éloignent** beaucoup les unes des autres (gaz) ;
- refroidir produit à chaque fois le mouvement inverse (rapprochement, mise en ordre).

Dans un système **fermé** et **isolé thermiquement** où coexistent deux états (par exemple glace + eau), les quantités des deux états n''évoluent plus : autant de molécules passent d''un état à l''autre dans les deux sens. On dit que le système est en **équilibre dynamique**.

> 🏆 Quatrième quête du thème LA MATIÈRE franchie ! Tu nommes les six changements d''état, tu distingues ébullition et évaporation, et tu sais qu''un corps pur change d''état à température constante. Héros de la matière, la mécanique t''attend : cap sur le mouvement.', '# 📜 Résumé : Les changements d''état d''un corps pur

- **Passer d''un état à un autre.** Un corps change d''**état physique** quand on fait varier sa **température**. À **chaque** changement d''état correspond un **changement d''état inverse**.
- **Les six changements d''état.** Fusion (solide → liquide) ↔ solidification ; vaporisation (liquide → gaz) ↔ liquéfaction ; sublimation (solide → gaz) ↔ condensation. La **sublimation** est le passage **direct** du solide au gaz, sans passer par le liquide.
- **Deux modes de vaporisation.** L''**ébullition** se fait dans toute la masse du liquide, à **température constante** (100°C pour l''eau pure sous pression atmosphérique normale) ; l''**évaporation** se fait seulement en **surface**, à **toute** température.
- **Une température constante.** Un **corps pur** change d''état à **température constante** sous une pression donnée : la courbe θ(t) présente un **palier**. Eau pure : fusion à 0°C, ébullition à 100°C.
- **La masse se conserve.** Au cours d''un changement d''état, la **masse** et la **nature** du corps sont conservées ; seuls l''état et le volume changent (50 g de glace → 50 g d''eau).
- **Interprétation microscopique et équilibre dynamique.** Un changement d''état réorganise les molécules (ordre/désordre, rapprochement/éloignement) sans changer leur nature. Dans un système fermé, isolé thermiquement, où deux états coexistent, le système est en **équilibre dynamique**.', 9, '{"code":"223103P00","pages":"131-146","pageNumbers":[131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('9da7c97f-7d81-5e5e-95f1-9019f1394cc2', 'physique-1ere-sec', 'Le mouvement', 'La description du mouvement : instant, date et durée ; le repère temps (origine + unité, la seconde s) et le repère espace (origine, orientation, unité, le mètre m), dont la réunion forme un référentiel ; la relativité du mouvement selon le corps de référence choisi ; la trajectoire et ses types (rectiligne, curviligne, circulaire) ; les régimes de mouvement (accéléré, décéléré, uniforme) ; la vitesse moyenne Vmoy = d/t (en m·s⁻¹, avec 1 m·s⁻¹ = 3,6 km·h⁻¹) et la vitesse instantanée lue au tachymètre', '# 🏃 Le mouvement — décrire, situer, mesurer

> 💡 «Le train démarre. Assis à l''intérieur, tu ne bouges pas par rapport à ton siège… mais le quai file devant la fenêtre. Alors, es-tu en mouvement ou au repos ? La réponse dépend de qui regarde.»

Bienvenue dans le thème **LA MÉCANIQUE**. Ce premier chapitre apprend à **décrire** un mouvement — sans encore chercher ses causes. Tu vas repérer le temps et l''espace, reconnaître les trajectoires et calculer une **vitesse**.

## ⏱️ Repérer le temps et l''espace

Pour étudier un mouvement, il faut d''abord savoir **quand** et **où**.

- Un **instant** est un point du temps ; on lui associe une **date**, notée t. La **durée** est l''intervalle de temps entre deux instants.
- Un **repère temps** est fait d''une **origine** (l''instant d''un événement choisi) et d''une **unité de durée** : dans le système international, la **seconde (s)**.
- Un **repère espace** permet de repérer la **position** : une origine, une orientation, et une **unité de longueur**, le **mètre (m)** dans le SI.

> 🗡️ Règle d''or : l''ensemble **repère espace + repère temps** forme un **référentiel**. C''est le point de vue depuis lequel on étudie le mouvement.

## 🔄 Le mouvement est relatif

Un même corps peut être **en mouvement** ou **au repos** selon le corps que l''on choisit comme **référence**.

_Exemple détaillé_ : un passager assis dans un train est **au repos** par rapport à son siège, mais **en mouvement** par rapport au quai ✓. Ni l''un ni l''autre n''a tort : tout dépend de la référence.

> ⚠️ Piège classique : « ce corps bouge, un point c''est tout ». Faux ! Dire qu''un corps est en mouvement ou au repos **n''a de sens que si on précise la référence**.

## 〰️ La trajectoire et ses types

La **trajectoire** d''un point mobile est l''ensemble des **positions** qu''il occupe au cours du temps, dans un repère donné. On distingue trois types :

| Trajectoire    | Portée par...    | Exemple                        |
| -------------- | ---------------- | ------------------------------ |
| **Rectiligne** | une droite       | une bille qui roule tout droit |
| **Curviligne** | une ligne courbe | un ballon lancé en cloche      |
| **Circulaire** | un cercle        | une valve de roue de vélo      |

::: figure Les trois types de trajectoire selon la ligne que suit le mobile (point rouge) : une droite, une courbe, un cercle.
<svg viewBox="0 0 300 120">
<g stroke="#0f172a" stroke-width="2" fill="none">
<path d="M18 55 H92" />
<path d="M112 78 Q150 12 188 78" />
<circle cx="250" cy="52" r="30" />
</g>
<g fill="#dc2626">
<circle cx="70" cy="55" r="5" />
<circle cx="150" cy="30" r="5" />
<circle cx="280" cy="52" r="5" />
</g>
<g fill="#0f172a" font-size="12" font-weight="700" text-anchor="middle">
<text x="55" y="102">rectiligne</text>
<text x="150" y="102">curviligne</text>
<text x="250" y="102">circulaire</text>
</g>
</svg>
:::

## 🚀 Accéléré, décéléré, uniforme

On qualifie un mouvement par la façon dont sa **vitesse** évolue :

- **accéléré** : la vitesse **augmente** (une voiture qui démarre) ;
- **décéléré** (ou ralenti) : la vitesse **diminue** (une voiture qui freine) ;
- **uniforme** : la vitesse **reste inchangée**.

## 🏃 La vitesse moyenne et la vitesse instantanée

La **vitesse moyenne** d''un mobile est le quotient de la **distance** parcourue par la **durée** du parcours :

$$ Vmoy = d / t $$

Dans le système international, elle s''exprime en **mètre par seconde (m·s⁻¹)**. On passe aux kilomètres par heure avec : **1 m·s⁻¹ = 3,6 km·h⁻¹**.

_Exemple détaillé_ : un coureur parcourt d = 100 m en t = 20 s. Sa vitesse moyenne vaut Vmoy = 100/20 = **5 m·s⁻¹**, soit 5 × 3,6 = **18 km·h⁻¹** ✓.

La **vitesse instantanée** est la vitesse à un instant précis : c''est la vitesse moyenne calculée sur une durée **très brève** autour de cet instant. C''est elle qu''affiche le **tachymètre** (compteur de vitesse) d''une voiture.

> 🏆 Première quête de LA MÉCANIQUE franchie ! Tu sais poser un référentiel, reconnaître une trajectoire et calculer une vitesse. Prochaine étape : découvrir **pourquoi** les corps se mettent en mouvement — les actions mécaniques et les forces t''attendent.', '# 📜 Résumé : Le mouvement

- **Repérer le temps et l''espace.** Un **instant** porte une **date** t ; une **durée** sépare deux instants. Le **repère temps** (origine + unité, la **seconde s**) et le **repère espace** (origine, orientation, unité, le **mètre m**) forment ensemble un **référentiel**.
- **Le mouvement est relatif.** Un même corps peut être en mouvement ou au repos selon le **corps de référence** choisi (un passager est au repos par rapport au train, en mouvement par rapport au quai). L''état de mouvement n''a de sens qu''avec une référence.
- **La trajectoire et ses types.** La **trajectoire** est l''ensemble des positions successives du mobile. Elle est **rectiligne** (droite), **curviligne** (courbe) ou **circulaire** (cercle).
- **Accéléré, décéléré, uniforme.** Un mouvement est **accéléré** si la vitesse augmente, **décéléré** (ralenti) si elle diminue, **uniforme** si elle reste inchangée.
- **La vitesse moyenne.** Vmoy = d/t, en **m·s⁻¹**, avec **1 m·s⁻¹ = 3,6 km·h⁻¹**. Exemple : 100 m en 20 s → 5 m·s⁻¹ = 18 km·h⁻¹.
- **La vitesse instantanée.** C''est la vitesse à un instant précis (vitesse moyenne sur une durée très brève) ; c''est elle qu''affiche le **tachymètre**.', 10, '{"code":"223103P00","pages":"147-162","pageNumbers":[147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('5e11f66c-337a-5c91-9846-11ae4934ed8d', 'physique-1ere-sec', 'Les actions mécaniques', 'Les actions mécaniques : actions de contact et à distance, localisées et réparties ; l''effet dynamique (mise en mouvement, changement de vitesse ou de trajectoire) et l''effet statique (déformation), corps élastiques et inélastiques ; la modélisation d''une action par une force (point d''application, direction, sens, intensité en newton N), mesurée au dynamomètre ; le poids d''un corps (force d''attraction terrestre, verticale, vers le bas, appliquée au centre de gravité G), la relation P = m × g et la variation de l''intensité de la pesanteur g (N·kg⁻¹) avec l''altitude et la latitude ; le centre d''inertie et le principe d''inertie (1ère loi de Newton)', '# ⚡ Les actions mécaniques — mettre en mouvement, déformer, attirer

> 💡 «Le footballeur frappe le ballon, l''aimant attire le clou sans le toucher, la pomme tombe de l''arbre. Trois actions, trois effets. Comment les décrire avec un seul outil : la force ?»

Au chapitre précédent, tu as appris à **décrire** un mouvement. Il est temps d''en chercher la **cause** : une **action mécanique**. Tu vas la modéliser par une **force**, puis découvrir la plus célèbre des forces : le **poids**.

## 🤝 Actions de contact et à distance

Une **action mécanique** est toute cause capable de **mettre en mouvement**, de **modifier le mouvement** ou de **déformer** un corps. On distingue :

- une **action de contact** : les deux corps se touchent (la main pousse le chariot) ;
- une **action à distance** : elle agit sans contact (l''aimant attire une bille en fer, la Terre attire la pomme).

Une action peut aussi être **localisée** (en un point, comme un fil accroché) ou **répartie** (sur tout le corps, comme le poids).

## ✨ Deux effets d''une action

Une action produit deux types d''effets :

- un **effet dynamique** : elle met en mouvement, ou change la vitesse ou la trajectoire ;
- un **effet statique** : elle **déforme** le corps.

Selon leur réaction à la déformation, les corps sont **élastiques** (le ressort reprend sa forme) ou **inélastiques** (la pâte à modeler reste déformée).

> 🗡️ Règle d''or : une **seule** action suffit à mettre un corps en mouvement, mais il en faut au moins **deux** pour le déformer.

## ➡️ Modéliser une action par une force

On modélise une action mécanique par une **force**. Une action possède trois caractéristiques : une **intensité** (ou valeur), une **direction** et un **sens**.

On représente la force par une **flèche** (un vecteur), qu''on note par une lettre surmontée d''une flèche :

- son **point d''application** : là où la flèche commence ;
- sa **direction** : la droite qui la porte ;
- son **sens** : celui de la flèche ;
- son **intensité** : donnée par la longueur de la flèche (à l''échelle).

L''intensité d''une force se mesure avec un **dynamomètre** et s''exprime en **newton (N)** dans le système international.

::: figure Une force se représente par une flèche partant de son point d''application A : la droite qui la porte donne la direction, la pointe donne le sens, et sa longueur (à l''échelle) donne l''intensité en newtons.
<svg viewBox="0 0 240 150">
<g stroke="#0f172a" stroke-width="1.5">
<path d="M12 130 H228" />
<rect x="34" y="104" width="52" height="24" rx="3" fill="#bfdbfe" />
</g>
<g stroke="#0f172a" stroke-width="2.5" fill="none">
<path d="M60 104 L168 44" />
</g>
<polygon points="168,44 156,48 162,58" fill="#0f172a" />
<circle cx="60" cy="104" r="4" fill="#dc2626" />
<g fill="#0f172a" font-size="12" font-weight="700">
<text x="44" y="102">A</text>
<text x="176" y="42">F</text>
</g>
</svg>
:::

## 🌍 Le poids d''un corps

Le **poids** d''un corps est la **force d''attraction** exercée par la **Terre** sur ce corps. On le note **P**. Ses caractéristiques :

- **direction** : verticale ;
- **sens** : vers le bas ;
- **point d''application** : le **centre de gravité G** du corps.

Son intensité est **proportionnelle à la masse** :

$$ P = m × g $$

où **g** est l''**intensité de la pesanteur**, en **newton par kilogramme (N·kg⁻¹)**. L''intensité g n''est pas la même partout : elle **diminue avec l''altitude** et **augmente avec la latitude**.

| Lieu      | Latitude | g (N·kg⁻¹) |
| --------- | -------- | ---------- |
| Équateur  | 0°       | 9,78       |
| Tunis     | 37°      | 9,80       |
| Pôle Nord | 90°      | 9,83       |

_Exemple détaillé_ : un corps de masse m = 10 kg, avec g = 9,8 N·kg⁻¹, a un poids P = m × g = 10 × 9,8 = **98 N** ✓.

> ⚠️ Piège classique : « le poids et la masse, c''est pareil ». Faux ! La **masse** (en kg) mesure la quantité de matière et ne change pas de lieu ; le **poids** (en N) est une force qui **dépend de g**, donc du lieu.

## 🎯 Le principe d''inertie

Parmi tous les points d''un corps, le **centre de gravité G** a le mouvement le plus simple ; on l''appelle aussi **centre d''inertie**.

Un corps est **isolé** s''il ne subit aucune action, **pseudo-isolé** si les actions se compensent. La **1ère loi de Newton (principe d''inertie)** énonce : dans un **référentiel galiléen**, le centre d''inertie d''un corps isolé ou pseudo-isolé **reste au repos** (s''il était immobile) ou est animé d''un **mouvement rectiligne uniforme** (s''il était en mouvement).

> 🏆 Deuxième quête de LA MÉCANIQUE franchie ! Tu modélises une action par une force, tu connais le poids et la relation P = m × g, et tu énonces le principe d''inertie. Cap sur l''équilibre : que se passe-t-il quand plusieurs forces s''affrontent ?', '# 📜 Résumé : Les actions mécaniques

- **Actions de contact et à distance.** Une **action mécanique** met en mouvement, modifie le mouvement ou déforme un corps. Elle est **de contact** (les corps se touchent) ou **à distance** (aimant, poids) ; **localisée** ou **répartie**.
- **Deux effets.** Un **effet dynamique** (mise en mouvement, changement de vitesse ou de trajectoire) et un **effet statique** (déformation). Un corps est **élastique** (reprend sa forme) ou **inélastique**.
- **Modéliser par une force.** On modélise une action par une **force**, représentée par une flèche : **point d''application**, **direction**, **sens**, **intensité**. L''intensité se mesure au **dynamomètre** et s''exprime en **newton (N)**.
- **Le poids.** Le **poids P** est la force d''attraction de la Terre : direction **verticale**, sens **vers le bas**, appliqué au **centre de gravité G**. Son intensité : **P = m × g**, avec g l''intensité de la pesanteur en **N·kg⁻¹** (g **diminue avec l''altitude**, **augmente avec la latitude**). Exemple : m = 10 kg, g = 9,8 → P = 98 N.
- **Poids ≠ masse.** La **masse** (kg) mesure la quantité de matière et ne dépend pas du lieu ; le **poids** (N) est une force qui dépend de g, donc du lieu.
- **Le principe d''inertie.** Le **centre de gravité G** est aussi le **centre d''inertie**. Dans un **référentiel galiléen**, le centre d''inertie d''un corps **isolé** ou **pseudo-isolé** reste au repos ou est animé d''un **mouvement rectiligne uniforme** (1ère loi de Newton).', 11, '{"code":"223103P00","pages":"163-178","pageNumbers":[163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('220d0f57-1bc2-534e-83f9-a77d72422212', 'physique-1ere-sec', 'Forces et équilibre', 'L''équilibre d''un solide soumis à deux forces : la condition d''équilibre (forces directement opposées — même droite d''action, sens contraires, même intensité, F1 + F2 = 0) ; la tension d''un fil et la réaction d''un plan comme forces de contact identifiées par l''équilibre ; la détermination expérimentale du centre de gravité ; la loi de Hooke (tension d''un ressort T = k × Δl, constante de raideur k en N·m⁻¹, limite d''élasticité) ; le principe d''interaction (3ème loi de Newton, F(A/B) = −F(B/A)), interactions de contact et à distance, transmission d''une force par un fil ou un ressort tendu', '# 🛡️ Forces et équilibre — quand les forces se compensent

> 💡 «Un lustre pend au plafond sans tomber, un livre repose sur la table sans bouger. Pourtant leur poids les tire vers le bas. Quelle force le compense exactement pour que l''équilibre tienne ?»

Tu sais modéliser une action par une force. Voici maintenant la question clé de la statique : à quelle **condition** un solide reste-t-il en **équilibre** ? Tu découvriras aussi la **loi de Hooke** et le **principe d''interaction**.

## ⚖️ Deux forces directement opposées

Un solide soumis à **deux forces** est en **équilibre** si ces deux forces sont **directement opposées**, c''est-à-dire :

- elles ont la **même droite d''action** ;
- elles sont de **sens contraires** ;
- elles ont la **même intensité**.

On résume par : **F1 + F2 = 0**.

::: figure Deux forces directement opposées appliquées à un solide en équilibre : même droite d''action (horizontale), sens contraires, longueurs (intensités) égales.
<svg viewBox="0 0 240 110">
<circle cx="120" cy="55" r="15" fill="#bfdbfe" stroke="#0f172a" stroke-width="1.5" />
<g stroke="#0f172a" stroke-width="2.5" fill="none">
<path d="M135 55 H203" />
<path d="M105 55 H37" />
</g>
<polygon points="205,55 194,50 194,60" fill="#0f172a" />
<polygon points="35,55 46,50 46,60" fill="#0f172a" />
<g fill="#0f172a" font-size="12" font-weight="700">
<text x="196" y="44">F1</text>
<text x="34" y="44">F2</text>
</g>
</svg>
:::

## 🧵 La tension d''un fil et la réaction d''un plan

L''équilibre révèle des forces de contact qu''on ne « voit » pas :

- un corps **suspendu** à un fil reste en équilibre : le fil exerce vers le haut une **tension**, notée T, **directement opposée au poids** (même intensité, sens contraire) ;
- un corps **posé** sur une table reste en équilibre : la table exerce une **réaction du plan**, notée R, directement opposée au poids. Elle s''exerce sur toute la surface de contact, la **base d''appui**.

> 🗡️ Astuce : en suspendant une plaque par plusieurs points l''un après l''autre, les **droites d''action du poids** se croisent toutes en un même point : c''est le **centre de gravité G**.

## 🌀 La loi de Hooke

Quand on déforme un ressort (on l''allonge ou on le comprime), il exerce une force appelée **tension du ressort**, notée T. Pour un **ressort linéaire**, cette tension est proportionnelle à la **déformation** Δl :

$$ T = k × Δl $$

**k** est la **constante de raideur** du ressort, exprimée en **newton par mètre (N·m⁻¹)**. La tension est **opposée à la déformation** : le ressort ramène toujours son extrémité vers sa position de repos.

_Exemple détaillé_ : un ressort de raideur k = 20 N·m⁻¹ allongé de Δl = 0,1 m exerce une tension T = k × Δl = 20 × 0,1 = **2 N** ✓.

> ⚠️ Piège classique : la loi n''est valable que dans le **domaine d''élasticité**. Au-delà d''un allongement limite (la **limite d''élasticité**), le ressort ne reprend plus sa forme initiale.

## 🤜🤛 Le principe d''interaction

Quand deux corps A et B **interagissent**, A exerce sur B une force notée F(A/B), et **en même temps** B exerce sur A une force F(B/A) **directement opposée** :

$$ F(A/B) = −F(B/A) $$

C''est la **3ème loi de Newton (principe d''interaction)**. Il s''applique aux interactions **de contact** (deux mains qui se poussent) comme **à distance** (l''aimant et le fer), aux corps au repos comme en mouvement.

_Exemple détaillé_ : la Terre attire la pomme (son poids) ; en retour, la pomme attire la Terre avec une force **de même intensité** et de sens contraire ✓ — même si cette force ne déplace pas la Terre.

Un **fil** ou un **ressort tendu** permet de **transmettre** à une extrémité la force reçue à l''autre extrémité.

> 🏆 Troisième quête de LA MÉCANIQUE franchie ! Tu connais la condition d''équilibre de deux forces, la loi de Hooke et le principe d''interaction. Héros, tu maîtrises désormais la mécanique de base : forces, mouvement et équilibre n''ont plus de secret.', '# 📜 Résumé : Forces et équilibre

- **Deux forces directement opposées.** Un solide soumis à deux forces est en **équilibre** si elles sont **directement opposées** : même **droite d''action**, **sens contraires**, **même intensité**. On écrit **F1 + F2 = 0**.
- **Tension du fil et réaction du plan.** Un corps **suspendu** subit la **tension du fil T**, dirigée vers le haut, directement opposée au poids ; un corps **posé** subit la **réaction du plan R**, opposée au poids, répartie sur la **base d''appui**. En suspendant une plaque par plusieurs points, les droites d''action du poids se croisent au **centre de gravité G**.
- **La loi de Hooke.** Pour un ressort linéaire, la tension est proportionnelle à la déformation : **T = k × Δl**, avec **k** la **constante de raideur** en **N·m⁻¹**. Valable dans le **domaine d''élasticité** seulement. Exemple : k = 20 N·m⁻¹, Δl = 0,1 m → T = 2 N.
- **Le principe d''interaction.** Quand deux corps A et B interagissent, **F(A/B) = −F(B/A)** : les deux forces sont directement opposées (3ème loi de Newton). Vrai pour les interactions de contact et à distance, au repos comme en mouvement.
- **Transmettre une force.** Un fil ou un ressort tendu **transmet** à une extrémité la force reçue à l''autre extrémité.', 12, '{"code":"223103P00","pages":"179-194","pageNumbers":[179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('7c2390d8-5766-59ff-a691-f015bda6c442', 'physique-1ere-sec', 'Forces et pression', 'Un solide transmet toute action, localisée ou répartie, à tout corps en contact avec lui. Les actions réparties sur une surface sont équivalentes à une force pressante F, normale (perpendiculaire) à la surface pressée et uniforme. La pression p = F/s (quotient de l''intensité de la force pressante par l''aire de la surface pressée), mesurée en pascal (Pa) : 1 bar = 10⁵ Pa, 1 millibar = 10² Pa. À force égale, la pression est d''autant plus grande que la surface pressée est petite ; à surface égale, elle croît avec la force. Applications : fortes pressions (instruments tranchants ou pointus, machines-outils) et faibles pressions (skis, raquettes, chenilles, traverses de voie ferrée, socles)', '# ⚔️ Forces et pression — quand la surface change tout

> 💡 «Un chameau lourd s''enfonce à peine dans le sable, mais un talon fin y creuse un trou profond. Comment un poids plus faible peut-il marquer davantage le sol ?»

Tu sais qu''une force se transmet le long d''un fil ou d''un ressort. Voici la dernière quête de la mécanique : comment un solide transmet ses actions à un support, et pourquoi l''effet dépend autant de la **surface** que de la force. Tu découvriras la **force pressante** et la **pression**.

## 🧱 Un solide transmet les forces

Pose un livre sur une table : la table « ressent » le poids du livre. C''est une règle générale :

> **Un solide transmet toute action, localisée ou répartie, qu''il subit à tout corps en contact avec lui.**

Un corps posé sur le sol lui transmet ainsi l''action que la Terre exerce sur lui (son poids).

## 🎯 La force pressante

Quand un corps appuie par toute une surface de contact, ces actions réparties sont **équivalentes à une force unique** F, appelée **force pressante**. La surface de contact entre le corps qui presse et le corps pressé est la **surface pressée**, notée s.

La force pressante a deux caractéristiques importantes : elle est **normale** (perpendiculaire) à la surface pressée, et elle agit **uniformément** sur toute cette surface.

::: figure La force pressante F est perpendiculaire (normale) à la surface pressée s et s''exerce uniformément sur elle.
<svg viewBox="0 0 240 160">
<line x1="20" y1="120" x2="220" y2="120" stroke="#0f172a" stroke-width="2" />
<rect x="90" y="58" width="60" height="62" fill="#bfdbfe" stroke="#0f172a" stroke-width="1.5" />
<line x1="90" y1="120" x2="150" y2="120" stroke="#0f6e56" stroke-width="4.5" />
<path d="M120 32 V104" fill="none" stroke="#dc2626" stroke-width="3" />
<polygon points="120,118 112,103 128,103" fill="#dc2626" />
<g fill="#0f172a" font-size="14" font-weight="700">
<text x="126" y="58">F</text>
<text x="156" y="134">s</text>
</g>
</svg>
:::

## ⚖️ La pression p = F/s

Pose un corps sur du plâtre en poudre par sa **petite** face, puis par sa **grande** face : la petite face s''enfonce davantage. À force égale, l''effet dépend donc de la surface. Pour mesurer cet effet, on définit une nouvelle grandeur, la **pression** :

$$ p = F/s $$

- **p** est la **pression** ;
- **F** est l''intensité de la force pressante, en newton (N) ;
- **s** est l''aire de la surface pressée, en mètre carré (m²).

La pression s''exprime dans le Système international en **pascal**, de symbole **Pa** (avec F en N et s en m²).

_Exemple détaillé_ : une force pressante F = 200 N s''exerce sur une surface s = 0,5 m². La pression vaut p = F/s = 200/0,5 = **400 Pa** ✓.

Le pascal est une très petite unité ; on utilise ses multiples :

$$ 1 bar = 10⁵ Pa $$

$$ 1 millibar (mbar) = 10² Pa $$

## 🔎 Deux règles à retenir

- **À surface pressée égale**, la pression (et l''enfoncement) est **d''autant plus grande** que la force pressante est **plus intense**.
- **À force pressante égale**, la pression est **d''autant plus grande** que la surface pressée est **plus petite**.

> ⚠️ Piège classique : ce n''est pas la force seule qui compte, mais le **rapport** F/s. Une petite force sur une toute petite surface peut créer une pression énorme.

## 🛠️ Réaliser de fortes ou de faibles pressions

- **Fortes pressions** — on **réduit la surface** (instruments **tranchants** : couteau, rasoir ; **pointus** : punaise, clou, aiguille) ou on **augmente la force** (presses, laminoirs, machines-outils).
- **Faibles pressions** — on **augmente la surface d''appui** pour moins s''enfoncer : skis et raquettes sur la neige, chenilles des engins, traverses des voies ferrées, socles des monuments lourds.

> 🏆 Quête finale de LA MÉCANIQUE franchie ! Force pressante, pression p = F/s en pascal, fortes et faibles pressions : tu comprends maintenant pourquoi un couteau coupe et pourquoi un ski flotte sur la neige. Héros, la mécanique n''a plus de secret — cap sur l''énergie et l''univers !', '# 📜 Résumé : Forces et pression

- **Transmission des forces.** Un solide **transmet** toute action, localisée ou répartie, à tout corps en contact avec lui (un corps posé transmet son poids au support).
- **Force pressante.** Les actions réparties sur une surface de contact sont équivalentes à une **force pressante F**. Elle est **normale** (perpendiculaire) à la **surface pressée s** et agit **uniformément** sur elle.
- **Pression.** La **pression** est le quotient de la force pressante par l''aire de la surface pressée : **p = F/s** (F en N, s en m²). Unité SI : le **pascal (Pa)**. Exemple : F = 200 N sur s = 0,5 m² → p = 400 Pa.
- **Multiples.** **1 bar = 10⁵ Pa** ; **1 millibar (mbar) = 10² Pa**.
- **Deux règles.** À surface égale, la pression croît avec la force ; à force égale, la pression est **d''autant plus grande que la surface pressée est petite**.
- **Applications.** Fortes pressions : petite surface (couteau, punaise, clou) ou grande force (presses, machines-outils). Faibles pressions : grande surface d''appui (skis, raquettes, chenilles, traverses, socles).', 13, '{"code":"223103P00","pages":"195-208","pageNumbers":[195,196,197,198,199,200,201,202,203,204,205,206,207,208]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('4d0448ec-57fd-5c08-9d6a-3c97976068e8', 'physique-1ere-sec', 'Énergie et contrôle', 'Sources d''énergie renouvelables (Soleil, vent, marées, biomasse, géothermie) et non renouvelables ou épuisables (charbon, pétrole, gaz naturel, uranium). L''énergie totale d''un système = énergie mécanique (macroscopique) + énergie microscopique. L''énergie se conserve mais se transforme d''une forme à une autre ; les convertisseurs d''énergie réalisent ces transformations ; seules les variations d''énergie ΔE sont mesurables, en joule (J). Les transferts s''effectuent par travail mécanique (WM), travail électrique (WE), travail rayonnant (WR) ou chaleur (Q) ; le travail est un transfert ordonné, la chaleur un transfert désordonné qui va spontanément du corps chaud vers le corps froid par conduction ou convection. Agitation thermique et température ; enceinte adiabatique (calorifugée) et isolation thermique', '# ⚡ Énergie et contrôle — la transformer sans la perdre

> 💡 «Le vent fait tourner une éolienne, la pile allume une lampe, le Soleil chauffe l''eau du chauffe-eau. À chaque fois, quelque chose passe d''un objet à un autre, et se transforme. Ce quelque chose, c''est l''énergie.»

Première quête du thème **L''ÉNERGIE** : d''où vient l''énergie, sous quelles **formes** elle existe, comment elle se **transforme** et se **transfère** — et pourquoi elle ne disparaît jamais.

## 🌱 Sources renouvelables et non renouvelables

- Une **source d''énergie renouvelable** produit de l''énergie de manière **relativement illimitée** dans le temps, en polluant peu : le **Soleil**, le **vent**, les **marées**, la **biomasse** (végétaux et animaux), la **géothermie**.
- Une **source non renouvelable** (ou **épuisable**) disparaît peu à peu à mesure qu''on l''utilise : le **charbon**, le **pétrole**, le **gaz naturel**, l''**uranium**.

## 🔋 Les formes de l''énergie

Un **système matériel** est un ensemble de particules. Son **énergie totale** est la somme de deux parts :

$$ énergie totale = énergie mécanique + énergie microscopique $$

- L''**énergie mécanique** (macroscopique) est liée au **mouvement d''ensemble** et à la **position** du système (une voiture qui roule, un ressort tendu).
- L''**énergie microscopique** est cachée à l''intérieur de la matière : l''**énergie thermique** (agitation des particules) et l''**énergie chimique** ou **nucléaire**.

## 🔄 Conservation et conversion

> **L''énergie contenue dans l''Univers se conserve, mais elle peut se transformer d''une forme à une autre.**

Les objets qui transforment l''énergie d''une forme en une autre sont des **convertisseurs d''énergie**. On ne peut en général pas mesurer l''énergie d''un système ; **seules ses variations** le sont. La **variation d''énergie**, notée **ΔE**, s''exprime en **joule** (symbole **J**).

::: figure Un convertisseur transforme une forme d''énergie en une autre : la pile (énergie chimique) fait tourner le moteur (énergie mécanique) par un transfert de travail électrique WE.
<svg viewBox="0 0 300 90">
<rect x="12" y="30" width="72" height="38" rx="5" fill="#bfdbfe" stroke="#0f172a" stroke-width="1.5" />
<rect x="212" y="30" width="76" height="38" rx="5" fill="#fde68a" stroke="#0f172a" stroke-width="1.5" />
<line x1="86" y1="49" x2="204" y2="49" fill="none" stroke="#0f172a" stroke-width="2.5" />
<polygon points="210,49 199,44 199,54" fill="#0f172a" />
<g fill="#0f172a" font-size="12" font-weight="700" text-anchor="middle">
<text x="48" y="53">pile</text>
<text x="250" y="53">moteur</text>
<text x="145" y="41">WE</text>
</g>
</svg>
:::

## 🚚 Les modes de transfert

L''énergie passe d''un système à un autre par **quatre modes** :

- le **travail mécanique** (WM) — un tracteur qui tire une remorque ;
- le **travail électrique** (WE) — une pile qui alimente un moteur ;
- le **travail rayonnant** (WR) — un four à micro-ondes qui chauffe l''eau ;
- la **chaleur** (Q) — un corps chaud plongé dans l''eau froide.

Le **travail** est un transfert **ordonné** d''énergie ; la **chaleur** est un transfert **désordonné**.

## 🔥 La chaleur, la conduction et la convection

La **chaleur** transfère de l''énergie **spontanément du corps chaud vers le corps froid**, de deux façons :

- la **conduction** — la chaleur se propage de proche en proche **sans déplacement de matière** (une tige métallique chauffée à un bout) ;
- la **convection** — la chaleur est transportée **par le déplacement de la matière** (les parties chaudes d''un liquide montent, les froides descendent).

> ⚠️ Piège classique : **chaleur** et **température** ne sont pas la même chose. La chaleur (en joule) est un **transfert** d''énergie ; la température (en °C) renseigne sur l''**agitation** des particules — l''agitation thermique.

## 🧊 L''isolation thermique

Une **enceinte adiabatique** (ou **calorifugée**) empêche tout échange de chaleur avec l''extérieur : elle réalise une **isolation thermique**. Exemples : le **calorimètre**, la **bouteille thermos**, la glacière, le réfrigérateur.

> 🏆 Première quête de L''ÉNERGIE franchie ! Sources renouvelables ou non, formes de l''énergie, conservation, convertisseurs, modes de transfert et isolation thermique : tu sais désormais suivre l''énergie à la trace, de sa source jusqu''à sa transformation. Héros, tu contrôles l''énergie !', '# 📜 Résumé : Énergie et contrôle

- **Sources d''énergie.** **Renouvelables** (illimitées, peu polluantes) : Soleil, vent, marées, biomasse, géothermie. **Non renouvelables** (épuisables) : charbon, pétrole, gaz naturel, uranium.
- **Formes de l''énergie.** L''**énergie totale** d''un système = **énergie mécanique** (macroscopique : mouvement, position) + **énergie microscopique** (thermique, chimique, nucléaire).
- **Conservation et conversion.** L''énergie **se conserve** mais **se transforme** d''une forme à une autre. Un **convertisseur d''énergie** réalise cette transformation. On mesure seulement les **variations d''énergie ΔE**, en **joule (J)**.
- **Modes de transfert.** Quatre : **travail mécanique (WM)**, **travail électrique (WE)**, **travail rayonnant (WR)**, **chaleur (Q)**. Le travail est un transfert **ordonné**, la chaleur un transfert **désordonné**.
- **La chaleur.** Elle passe **spontanément du corps chaud vers le corps froid**, par **conduction** (sans déplacement de matière) ou **convection** (avec déplacement de matière). **Chaleur ≠ température** : la température renseigne sur l''**agitation thermique** des particules.
- **Isolation thermique.** Une **enceinte adiabatique** (ou **calorifugée**) empêche tout échange de chaleur (calorimètre, bouteille thermos, glacière).', 14, '{"code":"223103P00","pages":"209-226","pageNumbers":[209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226]}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('23efe879-f28b-5f02-9781-87c73bbf943c', 'f3c0e519-3356-5b57-bf8a-c39cf6650721', 'physique-1ere-sec', 'Test de compréhension ⭐ : Le phénomène d''électrisation', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('cd81dc68-012d-5b7b-933f-d7435246ca21', '23efe879-f28b-5f02-9781-87c73bbf943c', 'Un bâton frotté avec de la laine est repoussé par un bâton en verre lui aussi électrisé. Quel est le signe de la charge portée par ce bâton ?', '[{"id":"a","text":"Positive (+)"},{"id":"b","text":"Négative (−)"},{"id":"c","text":"Nulle"},{"id":"d","text":"Positive ou négative selon la distance"}]'::jsonb, 'a', 'La convention se lit par rapport au verre : un corps qui repousse le verre électrisé porte une charge positive ✓. Deux corps qui se repoussent portent des charges de même signe, et le verre définit justement le signe +. Le bâton attiré par le verre, lui, serait négatif — c''est la confusion la plus fréquente. La répulsion ne signifie pas non plus que le corps est neutre, et le signe d''une charge ne dépend pas de la distance.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a86d19a9-30d9-5c8d-90d6-d731fd8c3612', '23efe879-f28b-5f02-9781-87c73bbf943c', 'Deux boules chargées de même signe sont approchées l''une de l''autre. Que se passe-t-il ?', '[{"id":"a","text":"Elles s''attirent"},{"id":"b","text":"Elles se repoussent"},{"id":"c","text":"Elles restent sans action l''une sur l''autre"},{"id":"d","text":"Elles se neutralisent aussitôt"}]'::jsonb, 'b', 'Deux corps chargés d''électricité de même signe se repoussent ✓ ; ce sont les signes contraires qui s''attirent — inverser les deux est le piège classique. Deux corps chargés exercent toujours une interaction : ils ne restent donc pas sans action l''un sur l''autre. Et un simple rapprochement, sans contact, ne neutralise pas les charges.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ba093546-03bb-5f48-b5ab-332a4678ebf6', '23efe879-f28b-5f02-9781-87c73bbf943c', 'Au cours d''un frottement, un corps reçoit des électrons venus d''un autre corps. Comment se charge-t-il ?', '[{"id":"a","text":"Positivement"},{"id":"b","text":"Négativement"},{"id":"c","text":"Il reste neutre"},{"id":"d","text":"Il se décharge entièrement"}]'::jsonb, 'b', 'L''électron porte une charge négative : le corps qui en reçoit se retrouve avec un excès de charges négatives, donc chargé négativement ✓. C''est le corps qui cède ses électrons qui devient positif — ne pas inverser les deux. Recevoir des charges ne laisse pas le corps neutre, et l''électrisation charge le corps, elle ne le décharge pas.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4020c7c3-42ec-5666-ac02-4a7c928298c3', '23efe879-f28b-5f02-9781-87c73bbf943c', 'Parmi ces quatre matériaux, lequel est un conducteur ?', '[{"id":"a","text":"Le verre"},{"id":"b","text":"Le plexiglas"},{"id":"c","text":"Le cuivre"},{"id":"d","text":"Le bois"}]'::jsonb, 'c', 'Le cuivre laisse circuler les électrons : c''est un conducteur ✓, au même titre que l''aluminium et le carbone. Le verre, le plexiglas et le bois sont au contraire des isolants : la charge y reste localisée là où elle apparaît, sans se propager. On peut les électriser par frottement, mais leur charge ne circule pas.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('01ce9519-615d-5193-a9ed-164d0b5a072d', '23efe879-f28b-5f02-9781-87c73bbf943c', 'On met en contact une boule neutre avec un bâton chargé négativement. Que devient la boule ?', '[{"id":"a","text":"Elle se charge positivement"},{"id":"b","text":"Elle reste neutre"},{"id":"c","text":"Elle se décharge dans l''air"},{"id":"d","text":"Elle se charge négativement"}]'::jsonb, 'd', 'Lors d''une électrisation par contact, le corps touché prend une charge de même signe que le corps électrisant : touchée par un bâton négatif, la boule devient négative ✓. Elle ne prend pas le signe opposé — c''est l''erreur courante, confondre contact et attraction. Le contact avec un corps chargé ne la laisse pas neutre, et il n''y a ici aucune décharge dans l''air.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('825c0e36-76ff-5ed0-807a-767423c8d266', 'f3c0e519-3356-5b57-bf8a-c39cf6650721', 'physique-1ere-sec', '⭐ Exercice : Premiers pas dans l''électrisation', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d08bd409-bb8d-5a8c-95ab-629c0f9a422f', '825c0e36-76ff-5ed0-807a-767423c8d266', 'À quoi sert un pendule électrostatique ?', '[{"id":"a","text":"À détecter si un corps est électrisé"},{"id":"b","text":"À mesurer la masse d''un corps"},{"id":"c","text":"À produire de l''électricité"},{"id":"d","text":"À mesurer une longueur"}]'::jsonb, 'a', 'Le pendule électrostatique est une petite boule légère suspendue à un fil : approchée d''un corps électrisé, elle est attirée. Il sert donc à détecter la présence d''une charge ✓. Il ne pèse rien, ne mesure aucune longueur, et ne produit pas d''électricité : c''est un détecteur, pas une source.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2ce36be3-6e4b-52b3-9a1d-7c7f54a6cc84', '825c0e36-76ff-5ed0-807a-767423c8d266', 'Comment rend-on une règle en plastique capable d''attirer de petits morceaux de papier ?', '[{"id":"a","text":"En la chauffant"},{"id":"b","text":"En la frottant avec un tissu"},{"id":"c","text":"En la mouillant"},{"id":"d","text":"En la refroidissant"}]'::jsonb, 'b', 'En la frottant avec un tissu (laine, coton…), on l''électrise : sa surface devient capable d''attirer les corps légers ✓. C''est le frottement, et lui seul, qui charge la règle ici. La chauffer ou la refroidir ne l''électrise pas ; la mouiller la rendrait au contraire mauvais isolant et ferait fuir la charge.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('51ce21a3-3dd2-5c6f-b861-402f5aafaba0', '825c0e36-76ff-5ed0-807a-767423c8d266', 'Un corps est attiré par un bâton en verre électrisé. Quel est le signe de sa charge ?', '[{"id":"a","text":"Positive"},{"id":"b","text":"Négative"},{"id":"c","text":"Nulle"},{"id":"d","text":"Elle n''a pas de signe"}]'::jsonb, 'b', 'Par convention, un corps attiré par le verre électrisé porte une charge négative ✓ : l''attraction traduit des signes contraires, et le verre est positif. Un corps repoussé par le verre serait au contraire positif. L''attraction prouve que le corps est bien chargé, donc sa charge n''est ni nulle ni sans signe.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2058a83d-ec8d-53f0-861d-a626c400a934', '825c0e36-76ff-5ed0-807a-767423c8d266', 'Dans le système international, la charge électrique q d''un corps s''exprime en :', '[{"id":"a","text":"Ampère (A)"},{"id":"b","text":"Volt (V)"},{"id":"c","text":"Coulomb (C)"},{"id":"d","text":"Newton (N)"}]'::jsonb, 'c', 'La charge, notée q, est une grandeur mesurable dont l''unité SI est le coulomb, de symbole C ✓. L''ampère mesure une intensité, le volt une tension et le newton une force : aucun ne convient pour une charge.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bef91dee-3629-5e84-bade-c7522a85fb50', '825c0e36-76ff-5ed0-807a-767423c8d266', 'Quand on approche un corps électrisé d''un autre corps sans le toucher, et que ce dernier voit ses charges se réorganiser, on parle d''électrisation par :', '[{"id":"a","text":"Frottement"},{"id":"b","text":"Contact"},{"id":"c","text":"Conduction"},{"id":"d","text":"Influence"}]'::jsonb, 'd', 'Agir à distance, sans contact, en approchant simplement un corps chargé, c''est l''électrisation par influence ✓ — c''est ainsi que fonctionne l''électroscope. Le frottement suppose un contact frotté et le contact un simple attouchement : tous deux exigent de toucher. « Conduction » n''est pas un mode d''électrisation du chapitre.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bbba134a-f585-5325-9050-883b9fced6ef', '825c0e36-76ff-5ed0-807a-767423c8d266', 'Quelle est la valeur de la charge élémentaire e ?', '[{"id":"a","text":"1,6 × 10⁻¹⁹ C"},{"id":"b","text":"1,6 × 10¹⁹ C"},{"id":"c","text":"3,2 × 10⁻¹⁹ C"},{"id":"d","text":"1,6 × 10⁻¹² C"}]'::jsonb, 'a', 'La charge élémentaire vaut e = 1,6 × 10⁻¹⁹ C ✓ ; la charge d''un électron est −e. Attention à l''exposant : il est négatif (10⁻¹⁹, une très petite charge), pas positif. La valeur 3,2 × 10⁻¹⁹ C correspondrait à deux charges élémentaires, et 10⁻¹² est un tout autre ordre de grandeur.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'f3c0e519-3356-5b57-bf8a-c39cf6650721', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Charges, conducteurs et décharges', 2, 75, 15, 'practice', 'admin', 3)
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
  ('680466e0-720b-5f2b-b901-9d1549225955', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'Par temps sec, une baguette en verre frottée et tenue à la main garde sa charge, alors qu''une baguette en cuivre frottée et tenue à la main la perd. Comment l''expliquer ?', '[{"id":"a","text":"Le cuivre est conducteur, le verre est isolant"},{"id":"b","text":"Le verre est conducteur, le cuivre est isolant"},{"id":"c","text":"Le cuivre ne peut pas être électrisé"},{"id":"d","text":"Le verre est plus léger que le cuivre"}]'::jsonb, 'a', 'Le cuivre est un conducteur : sa charge circule et s''écoule à travers la main de l''expérimentateur, si bien que la baguette se décharge ✓. Le verre est un isolant : sa charge reste localisée et ne peut pas s''échapper par la main, donc elle demeure. Inverser les deux natures donne l''option b, fausse. Le cuivre s''électrise très bien, et la masse n''a rien à voir avec la conservation de la charge.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('65d44468-4c57-58f6-988e-b41cffdbf06d', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'Lors d''une décharge électrique entre deux corps chargés de signes contraires, dans quel sens les électrons traversent-ils l''air ?', '[{"id":"a","text":"Du corps positif vers le corps négatif"},{"id":"b","text":"Dans les deux sens à la fois"},{"id":"c","text":"Du corps négatif vers le corps positif"},{"id":"d","text":"Ils restent immobiles"}]'::jsonb, 'c', 'Les électrons portent une charge négative et se déplacent du corps chargé négativement vers le corps chargé positivement ✓ : c''est ce déplacement à travers l''air qui constitue la décharge, matérialisée par l''étincelle. Ils ne vont pas dans l''autre sens (ce serait le sens conventionnel du courant, étudié plus loin), ni dans les deux à la fois, et une décharge est justement un déplacement de charges, non une immobilité.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0be8d0a3-98bf-5aa1-89f0-997374ec0922', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'En cas d''orage, pourquoi une voiture constitue-t-elle un bon abri ?', '[{"id":"a","text":"Parce que ses pneus en caoutchouc l''isolent du sol"},{"id":"b","text":"Parce qu''elle roule plus vite que la foudre"},{"id":"c","text":"Parce que sa carrosserie métallique forme une cage de Faraday"},{"id":"d","text":"Parce que le verre des vitres arrête la foudre"}]'::jsonb, 'c', 'La carrosserie métallique de la voiture forme une cage de Faraday : le champ électrique reste nul à l''intérieur et les occupants sont protégés, même si la foudre frappe le véhicule ✓. Ce ne sont pas les pneus qui protègent — c''est la croyance courante, mais une décharge capable de traverser des kilomètres d''air n''est pas arrêtée par quelques centimètres de caoutchouc. La vitesse du véhicule et le verre des vitres n''y jouent aucun rôle.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c5fa6f99-06bd-5072-b7c7-c1fe9ec69f4b', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'Pourquoi installe-t-on au sommet d''un bâtiment un paratonnerre en forme de pointe métallique reliée à la Terre ?', '[{"id":"a","text":"La pointe repousse la foudre au loin"},{"id":"b","text":"À la pointe, les charges se concentrent et la décharge est facilitée vers le sol"},{"id":"c","text":"Le métal empêche toute décharge de se produire"},{"id":"d","text":"La pointe isole le bâtiment du sol"}]'::jsonb, 'b', 'C''est l''effet de pointe : au bout d''une pointe, les charges d''un corps électrisé s''accumulent très fortement et la décharge y est facilitée ✓. Le paratonnerre capte donc la foudre de préférence et, étant relié à la Terre, il conduit les charges vers le sol sans danger. La pointe ne repousse pas la foudre, elle l''attire ; le métal ne bloque pas la décharge, il la canalise ; et le paratonnerre est justement relié au sol, non isolé de lui.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('719be2dd-43e5-5a01-9a87-5d3229436d1e', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'Après frottement à la laine, un bâton en verre repousse un bâton en plexiglas, et ce bâton en plexiglas attire un bâton en ébonite. Quelle interaction s''exerce entre le verre et l''ébonite ?', '[{"id":"a","text":"Ils se repoussent"},{"id":"b","text":"Ils s''attirent"},{"id":"c","text":"Ils n''ont aucune action l''un sur l''autre"},{"id":"d","text":"L''ébonite est forcément neutre"}]'::jsonb, 'b', 'On enchaîne les deux règles. Le verre repousse le plexiglas : même signe, donc le plexiglas est positif comme le verre. Le plexiglas attire l''ébonite : signes contraires, donc l''ébonite est négative. Le verre (+) et l''ébonite (−) sont de signes contraires : ils s''attirent ✓. Ils ne se repoussent donc pas, et l''ébonite, attirée par un corps chargé, n''est pas neutre.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('16fbe64e-9ed9-504b-a6f4-97bcad3e4d60', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', 'Un bâton chargé attire une boule métallique légère initialement neutre, avant même tout contact. Comment expliquer cette attraction ?', '[{"id":"a","text":"La boule était en réalité déjà chargée avant l''approche"},{"id":"b","text":"Un corps chargé attire indifféremment tout objet, sans raison"},{"id":"c","text":"La boule s''est chargée par frottement avec l''air"},{"id":"d","text":"Par influence : les charges de la boule se réorganisent et l''attraction l''emporte"}]'::jsonb, 'd', 'C''est l''électrisation par influence. Le bâton attire vers sa face proche les charges de signe opposé de la boule et repousse vers la face éloignée les charges de même signe. La boule reste globalement neutre, mais les charges attirées sont plus proches que les charges repoussées : l''attraction l''emporte sur la répulsion, d''où le mouvement ✓. La boule n''était pas chargée au départ, et un corps chargé n''attire pas « sans raison » : c''est cette réorganisation qui l''explique. Le frottement avec l''air n''intervient pas.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', '60fba4c2-4acb-5966-bf21-451643db2757', 'physique-1ere-sec', 'Test de compréhension ⭐ : Le circuit électrique', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('593f42be-93b1-539f-9322-a8d575e1a230', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', 'Qu''est-ce qu''un dipôle électrique ?', '[{"id":"a","text":"Un composant électrique qui possède deux bornes"},{"id":"b","text":"Un composant électrique qui possède une seule borne"},{"id":"c","text":"Un composant électrique qui possède trois bornes"},{"id":"d","text":"Un composant qui produit toujours de la lumière"}]'::jsonb, 'a', 'Un dipôle est un composant électrique muni de deux bornes de connexion ✓ : une pile, une lampe et un moteur sont des dipôles. Ce n''est ni un composant à une seule borne ni à trois bornes, et produire de la lumière n''est pas ce qui définit un dipôle (une lampe éclaire, un interrupteur non, et tous deux sont des dipôles).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e471922a-f642-51a7-bb9e-033148f07ab8', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', 'Dans un circuit, quel dipôle est responsable de l''apparition du courant électrique ?', '[{"id":"a","text":"La lampe"},{"id":"b","text":"Le moteur"},{"id":"c","text":"Le générateur"},{"id":"d","text":"L''interrupteur"}]'::jsonb, 'c', 'Le générateur (la pile) est le dipôle qui fait apparaître le courant dans le circuit ✓. La lampe et le moteur sont des récepteurs : ils utilisent le courant mais ne peuvent pas le créer. L''interrupteur ne fait qu''ouvrir ou fermer le circuit ; il ne produit aucun courant.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e6ae6bc1-5f41-5427-8663-966a9f69011b', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', 'Une aiguille aimantée dévie lorsqu''on l''approche d''un fil parcouru par un courant. Quel effet du courant est ainsi mis en évidence ?', '[{"id":"a","text":"L''effet thermique"},{"id":"b","text":"L''effet chimique"},{"id":"c","text":"L''effet lumineux"},{"id":"d","text":"L''effet magnétique"}]'::jsonb, 'd', 'La déviation d''une aiguille aimantée révèle l''effet magnétique du courant ✓. L''effet thermique se traduit par un échauffement, l''effet chimique par une transformation de la matière (électrolyseur), l''effet lumineux par une émission de lumière : aucun ne fait dévier une aiguille aimantée.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3219b52c-4050-536e-a787-d88a78e20a56', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', 'À l''extérieur du générateur, dans quel sens le courant conventionnel circule-t-il ?', '[{"id":"a","text":"De la borne − vers la borne +"},{"id":"b","text":"De la borne + vers la borne −"},{"id":"c","text":"Dans les deux sens à la fois"},{"id":"d","text":"Le courant n''a pas de sens"}]'::jsonb, 'b', 'Par convention, à l''extérieur du générateur, le courant circule de la borne positive (+) vers la borne négative (−) ✓. Le sens inverse est celui du déplacement réel des électrons dans les métaux, pas celui du courant conventionnel. Le courant a bien un sens déterminé, unique à un instant donné.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('16e4af28-858b-50dd-ab76-15ff08bd3a3d', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', 'Dans une solution ionique (électrolyte), à quoi correspond le passage du courant électrique ?', '[{"id":"a","text":"Au déplacement d''électrons"},{"id":"b","text":"Au déplacement d''atomes neutres"},{"id":"c","text":"Au déplacement d''ions"},{"id":"d","text":"Au déplacement de photons"}]'::jsonb, 'c', 'Dans une solution ionique, le courant est un déplacement ordonné d''ions : les cations (positifs) dans le sens conventionnel, les anions (négatifs) en sens inverse ✓. Ce sont les électrons qui portent le courant dans les métaux, pas dans les électrolytes. Des atomes neutres ne transportent aucune charge, et les photons sont des grains de lumière, sans rôle ici.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('4c945492-15a7-5744-b8d4-aca03ae96823', '60fba4c2-4acb-5966-bf21-451643db2757', 'physique-1ere-sec', '⭐ Exercice : Construire et lire un circuit', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d1eb1423-8c01-5eb0-8f4e-6fcdc490e7bd', '4c945492-15a7-5744-b8d4-aca03ae96823', 'On intercale un objet isolant dans la chaîne d''un circuit. Comment devient ce circuit ?', '[{"id":"a","text":"Un circuit fermé"},{"id":"b","text":"Un court-circuit"},{"id":"c","text":"Un générateur"},{"id":"d","text":"Un circuit ouvert"}]'::jsonb, 'd', 'Un isolant bloque le courant : la chaîne n''est plus continue, le circuit est ouvert et aucun courant ne circule ✓. Ce n''est donc pas un circuit fermé (qui exige une chaîne continue de conducteurs). Un court-circuit est tout autre chose (des bornes reliées par un fil), et un circuit n''est jamais un « générateur ».', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f06ec153-9a5d-5921-8cee-ee4bc8f28a6d', '4c945492-15a7-5744-b8d4-aca03ae96823', 'La lampe et le moteur utilisent le courant pour fonctionner mais ne peuvent pas le créer. Comment appelle-t-on ces dipôles ?', '[{"id":"a","text":"Des générateurs"},{"id":"b","text":"Des conducteurs"},{"id":"c","text":"Des récepteurs"},{"id":"d","text":"Des isolants"}]'::jsonb, 'c', 'Un dipôle qui utilise le courant pour fonctionner est un récepteur ✓ : la lampe et le moteur en sont. Le générateur, lui, fait apparaître le courant : c''est le rôle inverse. « Conducteur » et « isolant » qualifient l''aptitude à laisser passer le courant, pas le rôle du dipôle dans le circuit.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('eaded567-35c8-5e33-8c78-4390a0158224', '4c945492-15a7-5744-b8d4-aca03ae96823', 'Le filament d''une lampe s''échauffe fortement lorsqu''elle brille. Quel effet du courant cela met-il en évidence ?', '[{"id":"a","text":"L''effet thermique"},{"id":"b","text":"L''effet magnétique"},{"id":"c","text":"L''effet chimique"},{"id":"d","text":"L''effet lumineux"}]'::jsonb, 'a', 'L''échauffement d''un conducteur traduit l''effet thermique du courant ✓. L''effet magnétique fait dévier une aiguille aimantée, l''effet chimique transforme la matière dans un électrolyseur : ni l''un ni l''autre n''est un échauffement. La lampe produit aussi de la lumière (effet lumineux), mais la question porte ici sur l''échauffement du filament.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c7701a6d-c3a4-5c3c-b9ec-c7924b005f9c', '4c945492-15a7-5744-b8d4-aca03ae96823', 'Une diode branchée dans le sens passant se comporte comme :', '[{"id":"a","text":"Un interrupteur fermé"},{"id":"b","text":"Un interrupteur ouvert"},{"id":"c","text":"Un générateur"},{"id":"d","text":"Un isolant en toute circonstance"}]'::jsonb, 'a', 'Dans le sens passant, la diode laisse circuler le courant : elle agit comme un interrupteur fermé ✓. Dans le sens bloquant, au contraire, elle se comporte comme un interrupteur ouvert. Elle ne produit jamais de courant (ce n''est pas un générateur) et n''est pas isolante en permanence : tout dépend du sens de branchement.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ea325711-a531-5ac4-820b-d0830db1e4e8', '4c945492-15a7-5744-b8d4-aca03ae96823', 'Lequel de ces objets, intercalé dans un circuit, permet à la lampe de rester allumée ?', '[{"id":"a","text":"Une règle en plastique"},{"id":"b","text":"Un objet métallique"},{"id":"c","text":"Un morceau de verre"},{"id":"d","text":"Un bâton en bois"}]'::jsonb, 'b', 'Un objet métallique est un conducteur : il laisse passer le courant, la lampe reste allumée ✓. Le plastique, le verre et le bois sont des isolants : ils ouvrent le circuit et la lampe s''éteint.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('84b39c4c-c1a9-5e1a-985c-e0b77e47b62e', '4c945492-15a7-5744-b8d4-aca03ae96823', 'Dans un fil métallique parcouru par un courant, dans quel sens se déplacent les électrons ?', '[{"id":"a","text":"Dans le sens conventionnel du courant"},{"id":"b","text":"Dans les deux sens à la fois"},{"id":"c","text":"En sens inverse du courant conventionnel"},{"id":"d","text":"Ils restent immobiles"}]'::jsonb, 'c', 'Les électrons sont négatifs : ils se déplacent en sens inverse du sens conventionnel du courant, c''est-à-dire vers la borne + du générateur ✓. Le sens conventionnel a été fixé avant qu''on ne connaisse les électrons, d''où cette opposition. Les électrons se déplacent bien (ils ne sont pas immobiles) et tous dans le même sens.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1f35f50b-4457-5031-8b0c-fdde34926782', '60fba4c2-4acb-5966-bf21-451643db2757', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Effets, sens et dangers du courant', 2, 75, 15, 'practice', 'admin', 3)
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
  ('296021ad-7e08-546c-9dbe-aaae56fd29e9', '1f35f50b-4457-5031-8b0c-fdde34926782', 'À quelles deux conditions un circuit électrique est-il parcouru par un courant ?', '[{"id":"a","text":"Un générateur et une chaîne continue de conducteurs"},{"id":"b","text":"Un récepteur et une chaîne interrompue"},{"id":"c","text":"Au moins deux lampes montées en série"},{"id":"d","text":"Un interrupteur ouvert dans la chaîne"}]'::jsonb, 'a', 'Un courant circule si, et seulement si, le circuit comporte un dipôle générateur et forme une chaîne continue de conducteurs ✓. Sans générateur, rien n''impose le courant ; sans chaîne continue (chaîne interrompue ou interrupteur ouvert), le circuit est ouvert. Le nombre de lampes n''a rien à voir avec ces deux conditions.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e4d55829-3d13-5138-81d0-18c228a57299', '1f35f50b-4457-5031-8b0c-fdde34926782', 'Dans une solution ionique parcourue par un courant, dans quel sens se déplacent les cations (ions positifs) ?', '[{"id":"a","text":"En sens inverse du courant conventionnel"},{"id":"b","text":"Dans le sens conventionnel du courant"},{"id":"c","text":"Ils ne se déplacent pas"},{"id":"d","text":"Tantôt dans un sens, tantôt dans l''autre"}]'::jsonb, 'b', 'Les cations, positifs, se déplacent dans le sens conventionnel du courant, c''est-à-dire vers la borne − du générateur ✓. Ce sont les anions (négatifs) et les électrons qui se déplacent en sens inverse, vers la borne +. Dans un électrolyte parcouru par un courant, les ions se déplacent bien, chacun dans un sens déterminé.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7facd2a5-4bfd-50c2-a843-4959d28528c5', '1f35f50b-4457-5031-8b0c-fdde34926782', 'Près d''un composant d''un circuit, une aiguille aimantée dévie. Que peut-on en conclure ?', '[{"id":"a","text":"Le composant est un aimant permanent"},{"id":"b","text":"Aucun courant ne circule dans ce composant"},{"id":"c","text":"Un courant circule dans ce composant"},{"id":"d","text":"Le composant est un isolant"}]'::jsonb, 'c', 'La déviation d''une aiguille aimantée est l''effet magnétique du courant : sa manifestation prouve qu''un courant circule dans le composant ✓. Ce n''est pas la signature d''un aimant permanent (qui dévierait l''aiguille même sans circuit alimenté), et un isolant ne serait traversé par aucun courant, donc ne dévierait pas l''aiguille.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('58838187-63ac-5d6a-94ec-0ebfe67c6383', '1f35f50b-4457-5031-8b0c-fdde34926782', 'Deux lampes L1 et L2 sont montées en série. On relie les deux bornes de L1 par un fil de connexion. Que devient L1 ?', '[{"id":"a","text":"Elle brille plus fort"},{"id":"b","text":"Elle s''éteint"},{"id":"c","text":"Elle explose"},{"id":"d","text":"Rien ne change pour elle"}]'::jsonb, 'b', 'En reliant ses deux bornes par un fil, on court-circuite L1 : le courant passe par le fil plutôt que par le filament, qui n''est plus traversé — L1 s''éteint ✓. Un dipôle court-circuité est mis hors usage. Elle ne brille donc pas davantage (c''est L2 qui brillerait plus), et elle n''explose pas.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('485bc1fd-849e-5f84-88cc-38034411f189', '1f35f50b-4457-5031-8b0c-fdde34926782', 'Une lampe brille dans un circuit contenant une diode montée dans le sens passant. On inverse le sens de la diode. Que devient la lampe ?', '[{"id":"a","text":"Elle brille davantage"},{"id":"b","text":"Elle brille de la même façon"},{"id":"c","text":"Elle s''éteint"},{"id":"d","text":"Elle se met à clignoter"}]'::jsonb, 'c', 'Inversée, la diode est branchée dans le sens bloquant : elle se comporte alors comme un interrupteur ouvert et ne laisse plus passer le courant, la lampe s''éteint ✓. Une diode ne laisse passer le courant que dans un seul sens ; dans l''autre, le circuit est ouvert. La lampe ne peut donc ni briller pareil, ni davantage, ni clignoter.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2cbc3e67-cbb2-5fb2-b5cc-573c046492d3', '1f35f50b-4457-5031-8b0c-fdde34926782', 'Pourquoi ne faut-il jamais relier directement les deux bornes d''une pile par un simple fil conducteur ?', '[{"id":"a","text":"Parce que la pile se recharge alors toute seule"},{"id":"b","text":"Parce que le fil se transforme en aimant permanent"},{"id":"c","text":"Parce qu''il ne se passe absolument rien"},{"id":"d","text":"Parce que la pile peut être endommagée et provoquer un incendie"}]'::jsonb, 'd', 'Relier directement les deux bornes d''un générateur, c''est le court-circuiter : un courant très intense s''établit, l''effet thermique devient énorme, la pile peut être endommagée et le fil peut provoquer un incendie ✓. Une pile ne se recharge pas ainsi, le fil ne devient pas un aimant permanent, et il se passe au contraire quelque chose de dangereux.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6d851b3d-7e0a-5089-88e3-e1650983ebe0', '79bcf821-5a01-5dd5-93b8-497591138ae0', 'physique-1ere-sec', 'Test de compréhension ⭐ : L''intensité du courant électrique', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('03340da1-e134-5d23-a6da-4fa8758f7d93', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', 'Quelle est l''unité de l''intensité du courant électrique dans le système international ?', '[{"id":"a","text":"Le volt (V)"},{"id":"b","text":"L''ampère (A)"},{"id":"c","text":"Le coulomb (C)"},{"id":"d","text":"Le watt (W)"}]'::jsonb, 'b', 'L''intensité du courant, notée I, s''exprime en ampère, de symbole A ✓. Le volt est l''unité de la tension, le coulomb celle de la charge électrique, et le watt celle d''une puissance : aucun ne mesure une intensité.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2b5f857f-c66f-5e1b-9b81-2512f2bf448c', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', 'Comment branche-t-on un ampèremètre pour mesurer l''intensité du courant dans une branche ?', '[{"id":"a","text":"En série"},{"id":"b","text":"En dérivation"},{"id":"c","text":"En court-circuit"},{"id":"d","text":"Aux bornes du générateur uniquement"}]'::jsonb, 'a', 'Un ampèremètre se branche en série dans la branche dont on veut mesurer l''intensité, afin d''être traversé par le même courant qu''elle ✓. Branché en dérivation, il ne mesurerait pas ce courant ; le brancher en court-circuit est dangereux ; et il se place là où l''on veut mesurer, pas seulement aux bornes du générateur.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f965d026-c959-5dbb-959a-627734428969', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', 'Dans un circuit en série, comment se comporte l''intensité du courant d''un point à un autre ?', '[{"id":"a","text":"Elle est plus grande près du générateur"},{"id":"b","text":"Elle est plus grande dans la première lampe"},{"id":"c","text":"Elle est la même en tout point"},{"id":"d","text":"Elle est nulle partout"}]'::jsonb, 'c', 'Dans un circuit série, l''intensité du courant est la même en tout point, quel que soit l''ordre des dipôles ✓ : l''ampèremètre indique la même valeur où qu''on l''insère. Elle n''est donc ni plus forte près du générateur, ni plus forte dans une lampe particulière, et elle n''est nulle que si le circuit est coupé.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d58ee35d-e22e-5253-8bb6-4d3968cf2c9f', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', 'Dans un montage en dérivation, la branche principale porte une intensité de 0,90 A. L''une des deux branches dérivées porte 0,65 A. Quelle est l''intensité dans l''autre branche dérivée ?', '[{"id":"a","text":"0,25 A"},{"id":"b","text":"0,65 A"},{"id":"c","text":"0,90 A"},{"id":"d","text":"1,55 A"}]'::jsonb, 'a', 'D''après la loi des nœuds, l''intensité de la branche principale est la somme des intensités des branches dérivées : I₁ = I₂ + I₃, donc 0,90 = 0,65 + I₃, soit I₃ = 0,90 − 0,65 = 0,25 A ✓. La valeur 1,55 A vient d''une addition au lieu d''une soustraction ; 0,90 A et 0,65 A sont des intensités déjà connues, pas celle cherchée.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('64fb427c-c19f-5c39-8663-1d3598b6b47c', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', 'Que désigne le calibre d''un ampèremètre ?', '[{"id":"a","text":"La plus petite intensité qu''il peut mesurer"},{"id":"b","text":"Le nombre de divisions de son échelle"},{"id":"c","text":"La valeur exacte affichée par l''aiguille"},{"id":"d","text":"La plus grande intensité qu''il peut mesurer"}]'::jsonb, 'd', 'Le calibre est la plus grande intensité que l''ampèremètre peut mesurer ✓ : on choisit un calibre supérieur à l''intensité attendue pour ne pas détériorer l''appareil. Ce n''est pas la plus petite intensité, ni le nombre de divisions de l''échelle, ni la valeur lue, qui se calcule à partir du calibre et de l''échelle.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1d81c458-1701-5b14-a5fe-009936e9168d', '79bcf821-5a01-5dd5-93b8-497591138ae0', 'physique-1ere-sec', '⭐ Exercice : Intensité, calibres et loi des nœuds', 1, 50, 10, 'practice', 'admin', 1)
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
  ('aa3e6731-bb22-52b1-b36b-b65c012e3b3b', '1d81c458-1701-5b14-a5fe-009936e9168d', 'Dans un montage en série, comment les dipôles sont-ils branchés ?', '[{"id":"a","text":"Les uns à la suite des autres"},{"id":"b","text":"Sur des branches séparées"},{"id":"c","text":"Chacun directement sur le générateur"},{"id":"d","text":"En étoile autour d''un point central"}]'::jsonb, 'a', 'Dans un montage en série, tous les dipôles sont branchés les uns à la suite des autres, formant une seule boucle ✓. Les brancher sur des branches séparées serait un montage en dérivation (parallèle) : c''est le montage opposé.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8720ecf5-db88-5cdc-a041-489b34b363fa', '1d81c458-1701-5b14-a5fe-009936e9168d', 'Qu''est-ce qu''un nœud dans un circuit électrique ?', '[{"id":"a","text":"Une boucle fermée du circuit"},{"id":"b","text":"Un point de rencontre de plus de deux branches"},{"id":"c","text":"La branche qui contient le générateur"},{"id":"d","text":"Un dipôle muni de deux bornes"}]'::jsonb, 'b', 'Un nœud est un point où se rencontrent plus de deux branches ✓ : c''est là que le courant se partage. Une boucle fermée est une maille, la branche qui contient le générateur est la branche principale, et un dipôle à deux bornes est un composant, pas un nœud.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8b561a76-af87-55be-900d-790038fa5101', '1d81c458-1701-5b14-a5fe-009936e9168d', 'Par quelle lettre note-t-on l''intensité du courant électrique ?', '[{"id":"a","text":"U"},{"id":"b","text":"Q"},{"id":"c","text":"I"},{"id":"d","text":"R"}]'::jsonb, 'c', 'L''intensité du courant est notée I ✓ et s''exprime en ampère (A). La lettre U désigne la tension, Q la charge électrique et R la résistance : ce sont d''autres grandeurs.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1d07fd26-fb3d-5bf3-9d73-672be638bbfe', '1d81c458-1701-5b14-a5fe-009936e9168d', 'Sur un ampèremètre, par quelle borne le courant doit-il entrer ?', '[{"id":"a","text":"La borne COM (noire, −)"},{"id":"b","text":"N''importe quelle borne"},{"id":"c","text":"Les deux bornes à la fois"},{"id":"d","text":"La borne A (rouge, +)"}]'::jsonb, 'd', 'Le courant doit entrer par la borne A (rouge, notée +) et ressortir par la borne COM (noire, notée −) ✓. Inverser le branchement fausserait l''indication (ou ferait dévier l''aiguille à l''envers). Le sens de branchement de l''ampèremètre n''est donc pas indifférent.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fdfff668-8cea-5ba3-a664-5e4c24672e98', '1d81c458-1701-5b14-a5fe-009936e9168d', 'Un générateur débite une intensité de 80 mA. Dans un montage en dérivation, une branche est traversée par 30 mA. Quelle intensité traverse la seconde branche ?', '[{"id":"a","text":"30 mA"},{"id":"b","text":"50 mA"},{"id":"c","text":"80 mA"},{"id":"d","text":"110 mA"}]'::jsonb, 'b', 'La loi des nœuds donne I = I₁ + I₂, donc 80 = 30 + I₂, soit I₂ = 80 − 30 = 50 mA ✓. La valeur 110 mA proviendrait d''une addition (80 + 30) au lieu d''une soustraction ; 80 mA est l''intensité totale et 30 mA celle déjà connue.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b79494b4-f612-5930-96f7-f80616f6d462', '1d81c458-1701-5b14-a5fe-009936e9168d', 'Dans un circuit en série, que devient l''intensité du courant lorsqu''on ajoute un récepteur supplémentaire ?', '[{"id":"a","text":"Elle augmente"},{"id":"b","text":"Elle reste identique"},{"id":"c","text":"Elle diminue"},{"id":"d","text":"Elle s''annule aussitôt"}]'::jsonb, 'c', 'Ajouter un récepteur en série diminue l''intensité du courant qui parcourt le circuit ✓ : c''est pourquoi trois lampes en série brillent moins que deux. Elle n''augmente pas et ne reste pas identique, et elle ne s''annule que si le circuit est coupé, pas par le simple ajout d''un récepteur.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b224ac1f-0892-5896-afb0-e8e6f7c5501e', '79bcf821-5a01-5dd5-93b8-497591138ae0', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Mesures, loi des nœuds et sécurité', 2, 75, 15, 'practice', 'admin', 3)
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
  ('47981fe7-4f66-5600-afc6-e076e535b7f8', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'À quoi sert un fusible dans une installation électrique ?', '[{"id":"a","text":"À produire de la lumière"},{"id":"b","text":"À augmenter l''intensité du courant"},{"id":"c","text":"À couper le courant en fondant lorsque l''intensité dépasse un seuil"},{"id":"d","text":"À mesurer l''intensité du courant"}]'::jsonb, 'c', 'Un fusible est un fil qui fond dès que l''intensité dépasse une valeur donnée, ce qui coupe le courant et protège le reste du circuit ✓. Il ne produit pas de lumière, n''augmente jamais l''intensité (il la coupe), et ne mesure rien — c''est le rôle de l''ampèremètre.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('eaf88d4d-6b20-5533-a3ce-591bdc9a7900', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'À un nœud d''un circuit arrivent deux courants d''intensités 0,30 A et 0,45 A. Un seul courant en repart. Quelle est son intensité ?', '[{"id":"a","text":"0,15 A"},{"id":"b","text":"0,30 A"},{"id":"c","text":"0,45 A"},{"id":"d","text":"0,75 A"}]'::jsonb, 'd', 'La loi des nœuds impose que la somme des intensités qui arrivent égale la somme de celles qui partent : le courant sortant vaut 0,30 + 0,45 = 0,75 A ✓. La valeur 0,15 A viendrait d''une soustraction, tandis que 0,30 A et 0,45 A sont les intensités entrantes, pas la sortante.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0a38a704-d473-5ac3-b4c7-993995d4c29f', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'Un courant de 100 mA traverse le corps humain. D''après le tableau de sécurité, quelle en est la conséquence ?', '[{"id":"a","text":"Une fibrillation du cœur"},{"id":"b","text":"Une paralysie musculaire"},{"id":"c","text":"Une asphyxie"},{"id":"d","text":"Aucun effet notable"}]'::jsonb, 'a', 'À 100 mA, le courant provoque une fibrillation du cœur ✓, la conséquence la plus grave du tableau. La paralysie musculaire survient dès 30 mA et l''asphyxie vers 50 mA : ces effets apparaissent avant, à des intensités plus faibles. Un courant de 100 mA à travers le corps est loin d''être sans effet.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('53189c58-507c-56b7-903b-5aecf00ddb48', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'On veut mesurer une intensité d''environ 0,02 A avec un ampèremètre offrant les calibres 1 mA, 10 mA, 100 mA, 1 A et 10 A. Quel calibre choisir ?', '[{"id":"a","text":"10 mA"},{"id":"b","text":"100 mA"},{"id":"c","text":"1 A"},{"id":"d","text":"10 A"}]'::jsonb, 'b', 'L''intensité vaut 0,02 A, soit 20 mA. Le calibre doit être supérieur à la valeur mesurée : le calibre 10 mA est trop petit (20 > 10). Parmi les calibres possibles (100 mA, 1 A, 10 A), on choisit le plus petit, qui donne la mesure la plus précise : 100 mA ✓. Les calibres 1 A et 10 A conviendraient mais mesureraient moins finement.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('afff4689-031e-56c8-a4bc-a1bea114a14f', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'Un ampèremètre à aiguille est réglé sur le calibre 1 A ; son échelle compte 100 divisions et l''aiguille s''arrête sur la division 40. Quelle intensité indique-t-il ?', '[{"id":"a","text":"0,04 A"},{"id":"b","text":"0,40 A"},{"id":"c","text":"4 A"},{"id":"d","text":"40 A"}]'::jsonb, 'b', 'On applique Valeur = Lecture × Calibre ÷ Échelle = 40 × 1 ÷ 100 = 0,40 A ✓. Oublier de diviser par l''échelle donnerait 40 A ; se tromper d''un facteur 10 donnerait 0,04 A ou 4 A. La valeur mesurée reste toujours inférieure au calibre choisi (ici 1 A).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('eeb1aad5-2c6c-50ae-b230-7ca3785764ee', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'Une prise est protégée par un fusible de calibre 20 A. On y branche en même temps une machine à laver qui appelle 12 A et une plaque chauffante qui appelle 10 A. Que se passe-t-il ?', '[{"id":"a","text":"Rien de particulier ne se produit"},{"id":"b","text":"La prise fournit automatiquement plus de courant"},{"id":"c","text":"La machine à laver ralentit pour compenser"},{"id":"d","text":"Le fusible fond et coupe le courant"}]'::jsonb, 'd', 'Les deux appareils en dérivation appellent une intensité totale de 12 + 10 = 22 A, supérieure au calibre du fusible (20 A) : le fusible fond et coupe le courant ✓. Le fusible ne « laisse » pas passer davantage que son calibre, et aucun appareil ne ralentit tout seul pour s''adapter — c''est justement le rôle protecteur du fusible d''interrompre le circuit surchargé.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d11513d0-a414-5c0c-91d2-e662b444d896', 'cefe9013-8f6e-57cc-beb2-addd28192c81', 'physique-1ere-sec', 'Test de compréhension ⭐ : La tension électrique', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('209983c0-a5b5-5ec3-984e-d29485e28584', 'd11513d0-a414-5c0c-91d2-e662b444d896', 'Quelle est l''unité de la tension électrique dans le système international ?', '[{"id":"a","text":"Le voltmètre"},{"id":"b","text":"Le volt (V)"},{"id":"c","text":"L''ampère (A)"},{"id":"d","text":"Le coulomb (C)"}]'::jsonb, 'b', 'L''unité de la tension est le volt, de symbole V ✓. Attention au piège : le voltmètre n''est pas une unité, c''est l''appareil qui mesure la tension. L''ampère mesure une intensité et le coulomb une charge : ni l''un ni l''autre n''est l''unité d''une tension.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9007d29d-5aa2-5acb-8b20-465475a1ca4d', 'd11513d0-a414-5c0c-91d2-e662b444d896', 'Comment se branche un voltmètre pour mesurer la tension aux bornes d''un dipôle ?', '[{"id":"a","text":"En dérivation, aux bornes du dipôle"},{"id":"b","text":"En série avec le dipôle"},{"id":"c","text":"En court-circuit sur le dipôle"},{"id":"d","text":"À la place du générateur"}]'::jsonb, 'a', 'Le voltmètre se branche en dérivation, c''est-à-dire directement aux bornes du dipôle, sans couper le circuit ✓. C''est l''ampèremètre, lui, qui se branche en série. Le brancher en court-circuit ou à la place du générateur n''aurait aucun sens pour mesurer une tension.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a45667e8-3ab4-54a0-84b4-11b6aa63abdc', 'd11513d0-a414-5c0c-91d2-e662b444d896', 'Aux bornes d''un générateur isolé (non branché dans un circuit), la tension est :', '[{"id":"a","text":"Nulle"},{"id":"b","text":"Toujours négative"},{"id":"c","text":"Non nulle"},{"id":"d","text":"Impossible à mesurer"}]'::jsonb, 'c', 'Aux bornes d''un générateur isolé, la tension est non nulle : elle vaut approximativement la valeur indiquée sur le générateur ✓. C''est justement ce qui distingue un générateur d''un récepteur isolé, dont la tension est nulle. Cette tension se mesure sans difficulté au voltmètre, et rien n''impose qu''elle soit négative.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('49bf1bda-7235-598d-9788-41f843be864f', 'd11513d0-a414-5c0c-91d2-e662b444d896', 'Que traduit la relation UAB = −UBA ?', '[{"id":"a","text":"La tension est toujours positive"},{"id":"b","text":"UAB et UBA sont toujours égales"},{"id":"c","text":"La tension est nécessairement nulle"},{"id":"d","text":"La tension est une grandeur algébrique (positive ou négative)"}]'::jsonb, 'd', 'La relation UAB = −UBA exprime que la tension est une grandeur algébrique : elle change de signe quand on échange les deux points, donc elle peut être positive ou négative ✓. Elle n''est donc pas toujours positive, et UAB et UBA sont opposées, pas égales (sauf si toutes deux sont nulles).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d431ec8e-8e26-519f-9b15-c24355ed386c', 'd11513d0-a414-5c0c-91d2-e662b444d896', 'Dans une maille d''un circuit, que vaut la somme algébrique des tensions aux bornes des différents dipôles ?', '[{"id":"a","text":"Zéro"},{"id":"b","text":"La tension du générateur"},{"id":"c","text":"La somme des intensités"},{"id":"d","text":"La tension nominale d''un récepteur"}]'::jsonb, 'a', 'D''après la loi des mailles, la somme algébrique des tensions aux bornes des dipôles d''une maille est nulle ✓. Ce n''est pas la tension du générateur seule (celle-ci se répartit justement sur les récepteurs), et une somme de tensions ne peut pas donner une somme d''intensités : ce sont des grandeurs différentes.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'cefe9013-8f6e-57cc-beb2-addd28192c81', 'physique-1ere-sec', '⭐ Exercice : Tension, voltmètre et loi des mailles', 1, 50, 10, 'practice', 'admin', 1)
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
  ('a9df8c0b-d628-5ba4-bf5b-0e5b19f805c2', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'Par quelle lettre note-t-on la tension électrique ?', '[{"id":"a","text":"I"},{"id":"b","text":"U"},{"id":"c","text":"R"},{"id":"d","text":"Q"}]'::jsonb, 'b', 'La tension est notée U ✓ et s''exprime en volt (V). La lettre I désigne l''intensité, R la résistance et Q la charge électrique : ce sont d''autres grandeurs.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5b30ac05-ab65-506e-87b6-14e9d6915203', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'Aux bornes de quel dipôle isolé (non branché) mesure-t-on une tension non nulle ?', '[{"id":"a","text":"Une lampe"},{"id":"b","text":"Un moteur"},{"id":"c","text":"Un générateur"},{"id":"d","text":"Une diode"}]'::jsonb, 'c', 'Seul un générateur isolé présente une tension non nulle à ses bornes ✓ ; c''est ce qui permet de le reconnaître. La lampe, le moteur et la diode sont des récepteurs : isolés, la tension à leurs bornes est nulle.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('89ad05de-c572-5581-9325-79a511f17280', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'Que désigne la tension nominale d''un récepteur ?', '[{"id":"a","text":"La tension maximale avant qu''il ne soit détruit"},{"id":"b","text":"La tension du générateur à vide"},{"id":"c","text":"La tension aux bornes d''un fil conducteur"},{"id":"d","text":"La tension à appliquer pour qu''il fonctionne normalement"}]'::jsonb, 'd', 'La tension nominale est la tension qu''il faut appliquer aux bornes d''un récepteur pour qu''il fonctionne normalement ✓ : en dessous il fonctionne mal, au-dessus il se détériore. Ce n''est donc pas une tension de destruction. La tension à vide est la f.é.m. d''un générateur, et la tension aux bornes d''un fil parcouru par un courant est nulle.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('42cbe483-f5da-5c86-88f4-ff14087d8c9c', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'La tension UAB aux bornes d''un dipôle est représentée par une flèche allant :', '[{"id":"a","text":"De B vers A"},{"id":"b","text":"De A vers B"},{"id":"c","text":"Du pôle + vers le pôle −"},{"id":"d","text":"Du haut vers le bas"}]'::jsonb, 'a', 'Par convention, la tension UAB se représente par une flèche allant de B vers A ✓. Inverser le sens de la flèche reviendrait à considérer UBA = −UAB. Le sens de la flèche est fixé par l''ordre des indices A et B, pas par les pôles du générateur ni par une orientation « haut-bas ».', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('21a2da4a-2ccb-57b7-9d1e-64ba4003707b', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'Un générateur de tension 6 V alimente deux lampes montées en série. La tension aux bornes de la première lampe est 2 V. Quelle est la tension aux bornes de la seconde ?', '[{"id":"a","text":"2 V"},{"id":"b","text":"4 V"},{"id":"c","text":"6 V"},{"id":"d","text":"8 V"}]'::jsonb, 'b', 'La loi des mailles donne U = U₁ + U₂, donc 6 = 2 + U₂, soit U₂ = 6 − 2 = 4 V ✓. La valeur 8 V viendrait d''une addition (6 + 2) au lieu d''une soustraction ; 6 V est la tension du générateur et 2 V celle de la première lampe.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('faf9e844-3874-512b-9c3f-7d79e45bd9fe', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'Sur l''écran d''un oscilloscope, la tension aux bornes d''une pile plate apparaît comme un trait horizontal. Que peut-on en conclure ?', '[{"id":"a","text":"La tension est nulle"},{"id":"b","text":"La tension varie rapidement"},{"id":"c","text":"La tension est continue"},{"id":"d","text":"La tension est très élevée"}]'::jsonb, 'c', 'Un trait horizontal signifie que la tension ne varie pas au cours du temps : c''est une tension continue ✓, celle que délivre une pile. Une tension nulle donnerait un trait sur l''axe (valeur zéro), une tension variable donnerait une courbe qui monte et descend, et la hauteur du trait n''indique pas forcément une valeur élevée.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'cefe9013-8f6e-57cc-beb2-addd28192c81', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Tension, signe et loi des mailles', 2, 75, 15, 'practice', 'admin', 3)
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
  ('8104cc1a-7645-50e1-b7e2-04987db22904', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'Une lampe est insérée dans un circuit fermé et traversée par un courant. Que peut-on dire de la tension à ses bornes ?', '[{"id":"a","text":"Elle est nulle"},{"id":"b","text":"Elle est non nulle"},{"id":"c","text":"Elle est forcément négative"},{"id":"d","text":"Elle est toujours égale à la tension du générateur"}]'::jsonb, 'b', 'En circuit fermé, un récepteur traversé par un courant présente une tension non nulle à ses bornes ✓, dont la valeur dépend des composants du circuit. C''est différent du récepteur isolé, dont la tension est nulle. Elle n''est pas nécessairement négative, et elle n''égale la tension du générateur que dans des cas particuliers (récepteur seul), pas toujours.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('783d5c76-c42e-5890-9687-67972acd4c70', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'On mesure la tension aux bornes de deux dipôles isolés : le premier donne 4,5 V, le second 0 V. Que peut-on en déduire ?', '[{"id":"a","text":"Le premier est un récepteur, le second un générateur"},{"id":"b","text":"Les deux sont des générateurs"},{"id":"c","text":"Le premier est un générateur, le second un récepteur"},{"id":"d","text":"Les deux sont des récepteurs"}]'::jsonb, 'c', 'Un dipôle isolé dont la tension n''est pas nulle est un générateur, un dipôle isolé de tension nulle est un récepteur : le premier (4,5 V) est donc un générateur, le second (0 V) un récepteur ✓. L''association inverse est fausse, et si les deux étaient de même nature ils donneraient la même sorte d''indication (tous deux non nuls, ou tous deux nuls).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('eabf0b7c-56ce-5ef5-a814-1e2e3a3d4613', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'Que désigne la force électromotrice (f.é.m.) d''un générateur ?', '[{"id":"a","text":"Sa tension nominale en fonctionnement"},{"id":"b","text":"La tension aux bornes d''un récepteur"},{"id":"c","text":"La tension aux bornes d''un fil conducteur"},{"id":"d","text":"Sa tension à vide, lorsqu''il n''est branché à aucun récepteur"}]'::jsonb, 'd', 'La force électromotrice est la tension d''un générateur à vide, c''est-à-dire lorsqu''il n''alimente aucun récepteur ✓. La « tension nominale » qualifie un récepteur, pas un générateur ; la tension aux bornes d''un fil parcouru par un courant est nulle. La f.é.m. est bien une caractéristique propre au générateur.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f9c848cd-7dd1-55a0-abff-39fbe5b7f2be', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'Aux bornes d''un dipôle, un voltmètre indique UAB = 4,5 V. Que vaut alors UBA ?', '[{"id":"a","text":"−4,5 V"},{"id":"b","text":"0 V"},{"id":"c","text":"4,5 V"},{"id":"d","text":"9 V"}]'::jsonb, 'a', 'La tension est algébrique : échanger les indices change le signe, donc UBA = −UAB = −4,5 V ✓. La valeur reste la même en grandeur, mais devient négative. Répondre 4,5 V oublie ce changement de signe ; 0 V et 9 V ne correspondent à aucune règle du chapitre.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8fe13c74-52fb-538c-bc1e-d6e131b933a3', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'Un générateur de tension 6 V alimente trois lampes identiques montées en série. Quelle est la tension aux bornes de chaque lampe ?', '[{"id":"a","text":"2 V"},{"id":"b","text":"3 V"},{"id":"c","text":"6 V"},{"id":"d","text":"18 V"}]'::jsonb, 'a', 'La loi des mailles donne U = U₁ + U₂ + U₃. Les trois lampes étant identiques, elles se partagent également la tension : chacune reçoit U ÷ 3 = 6 ÷ 3 = 2 V ✓. La valeur 18 V viendrait d''une multiplication par 3 au lieu d''une division ; 6 V est la tension totale du générateur, pas celle d''une seule lampe.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f6ca22d5-58c4-59e1-b026-5e8a9156bfd5', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', 'Une lampe porte l''indication « 3 V ». On la branche seule aux bornes d''un générateur de 12 V. Que se passe-t-il ?', '[{"id":"a","text":"Elle brille faiblement"},{"id":"b","text":"Elle se détériore"},{"id":"c","text":"Elle fonctionne normalement"},{"id":"d","text":"Rien, la tension n''a aucun effet"}]'::jsonb, 'b', '3 V est la tension nominale de la lampe : c''est la tension à appliquer pour un fonctionnement normal. Sous 12 V, très supérieure à la valeur nominale, la lampe se détériore ✓. Une tension plus faible que la nominale la ferait briller faiblement, mais ici la tension est bien trop grande, ce qui est destructeur : il ne faut jamais éloigner un récepteur de sa tension nominale.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('7d6f7463-11be-5740-95b6-ff3eb85030e0', 'fa37b216-c0bf-59cd-aa50-40529b1b01f0', 'physique-1ere-sec', 'Test de compréhension ⭐ : Le dipôle résistor', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('8c7567b0-ac54-50ff-841a-32c5e7cd0b83', '7d6f7463-11be-5740-95b6-ff3eb85030e0', 'La courbe qui représente la tension U en fonction de l''intensité I d''un dipôle s''appelle :', '[{"id":"a","text":"Sa caractéristique intensité-tension"},{"id":"b","text":"Sa résistance"},{"id":"c","text":"Sa loi d''Ohm"},{"id":"d","text":"Sa tension nominale"}]'::jsonb, 'a', 'La courbe donnant U en fonction de I est la caractéristique intensité-tension du dipôle ✓, sa carte d''identité électrique. La résistance est une grandeur (un nombre), pas une courbe ; la loi d''Ohm est une relation ; la tension nominale est une valeur de fonctionnement d''un récepteur.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0908c2c0-30b4-5855-b726-14ba7fbdb2d7', '7d6f7463-11be-5740-95b6-ff3eb85030e0', 'Quelle est l''unité de la résistance dans le système international ?', '[{"id":"a","text":"Le volt (V)"},{"id":"b","text":"L''ampère (A)"},{"id":"c","text":"Le watt (W)"},{"id":"d","text":"L''ohm (Ω)"}]'::jsonb, 'd', 'La résistance s''exprime en ohm, de symbole Ω ✓. Le volt est l''unité de la tension, l''ampère celle de l''intensité, et le watt celle d''une puissance : aucune n''est l''unité d''une résistance.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c0217e65-f239-55aa-a831-38a8c11c7a32', '7d6f7463-11be-5740-95b6-ff3eb85030e0', 'La caractéristique intensité-tension d''un dipôle résistor est :', '[{"id":"a","text":"Une droite horizontale"},{"id":"b","text":"Une portion de droite passant par l''origine"},{"id":"c","text":"Une courbe qui ne passe jamais par l''origine"},{"id":"d","text":"Un cercle"}]'::jsonb, 'b', 'Pour un dipôle résistor, la caractéristique est une portion de droite passant par l''origine ✓, ce qui traduit la proportionnalité entre U et I. Une droite horizontale signifierait une tension constante quelle que soit l''intensité, et une courbe ou un cercle ne correspondent pas à un résistor.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ce94ce9e-22ab-53dc-a639-6914ba5d7c48', '7d6f7463-11be-5740-95b6-ff3eb85030e0', 'Comment s''écrit la loi d''Ohm pour un résistor de résistance R ?', '[{"id":"a","text":"U = R + I"},{"id":"b","text":"U = R / I"},{"id":"c","text":"U = R × I"},{"id":"d","text":"U = I / R"}]'::jsonb, 'c', 'La loi d''Ohm énonce que la tension est le produit de la résistance par l''intensité : U = R × I ✓. Ajouter R et I n''a aucun sens (grandeurs différentes) ; U = R/I confond avec la définition R = U/I, dont on ne peut pas simplement échanger les termes ainsi.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f2948742-e856-5312-a4c4-94e961c453cd', '7d6f7463-11be-5740-95b6-ff3eb85030e0', 'À quoi sert un rhéostat inséré dans un circuit ?', '[{"id":"a","text":"À commander l''intensité du courant"},{"id":"b","text":"À mesurer la tension"},{"id":"c","text":"À produire le courant"},{"id":"d","text":"À ouvrir le circuit"}]'::jsonb, 'a', 'Un rhéostat est un résistor réglable : en modifiant sa résistance, il commande l''intensité du courant dans le circuit ✓. Mesurer la tension est le rôle du voltmètre, produire le courant celui du générateur, et ouvrir le circuit celui de l''interrupteur.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('422ca09e-9435-5139-8fd2-f18b5b26b6e1', 'fa37b216-c0bf-59cd-aa50-40529b1b01f0', 'physique-1ere-sec', '⭐ Exercice : Résistance, loi d''Ohm et rhéostat', 1, 50, 10, 'practice', 'admin', 1)
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
  ('f2c9f793-58b3-5608-9ef1-9822c13489cf', '422ca09e-9435-5139-8fd2-f18b5b26b6e1', 'Par quelle lettre note-t-on la résistance d''un dipôle ?', '[{"id":"a","text":"U"},{"id":"b","text":"I"},{"id":"c","text":"R"},{"id":"d","text":"Q"}]'::jsonb, 'c', 'La résistance est notée R ✓ et s''exprime en ohm (Ω). La lettre U désigne la tension, I l''intensité et Q la charge électrique : ce sont d''autres grandeurs du circuit.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('71335a8b-4bcf-5a1a-9506-df483e881db2', '422ca09e-9435-5139-8fd2-f18b5b26b6e1', 'Quel appareil permet de mesurer directement une résistance ?', '[{"id":"a","text":"L''ohmmètre"},{"id":"b","text":"Le voltmètre"},{"id":"c","text":"L''ampèremètre"},{"id":"d","text":"Le chronomètre"}]'::jsonb, 'a', 'L''ohmmètre (une fonction du multimètre) affiche directement la résistance ✓, lorsqu''on branche le dipôle hors tension. Le voltmètre mesure une tension, l''ampèremètre une intensité, et le chronomètre une durée.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('32a4e4ff-cb39-5a0f-abb0-280ceffb76b1', '422ca09e-9435-5139-8fd2-f18b5b26b6e1', 'Comment appelle-t-on aussi un dipôle résistor ?', '[{"id":"a","text":"Un générateur"},{"id":"b","text":"Un isolant"},{"id":"c","text":"Un condensateur"},{"id":"d","text":"Un conducteur ohmique"}]'::jsonb, 'd', 'Un dipôle résistor est aussi appelé conducteur ohmique ✓, car il obéit à la loi d''Ohm. Un générateur produit le courant, un isolant ne le laisse pas passer, et un condensateur est un tout autre composant.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('20b0c8ec-40b0-593d-8296-7ca351414023', '422ca09e-9435-5139-8fd2-f18b5b26b6e1', 'Que caractérise la résistance R d''un dipôle ?', '[{"id":"a","text":"La vitesse du courant"},{"id":"b","text":"Son opposition au passage du courant"},{"id":"c","text":"La tension du générateur"},{"id":"d","text":"Le nombre d''électrons qu''il contient"}]'::jsonb, 'b', 'La résistance mesure à quel point le dipôle s''oppose au passage du courant ✓ : à tension égale, plus R est grande, moins il passe de courant. Ce n''est ni une vitesse, ni la tension du générateur, ni un nombre d''électrons.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e432b93c-7430-5d50-a3d4-d8e3958391ca', '422ca09e-9435-5139-8fd2-f18b5b26b6e1', 'Un résistor de résistance R = 12 Ω est traversé par un courant d''intensité I = 0,5 A. Quelle est la tension à ses bornes ?', '[{"id":"a","text":"6 V"},{"id":"b","text":"12,5 V"},{"id":"c","text":"24 V"},{"id":"d","text":"0,04 V"}]'::jsonb, 'a', 'D''après la loi d''Ohm, U = R × I = 12 × 0,5 = 6 V ✓. La valeur 12,5 V viendrait d''une addition (12 + 0,5), 24 V d''une division (12 ÷ 0,5), et 0,04 V d''une division inversée : il faut bien multiplier.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f5db2d0c-d850-5039-bfa5-035d1b3b71ba', '422ca09e-9435-5139-8fd2-f18b5b26b6e1', 'Comment peut-on connaître la valeur d''une résistance en la lisant directement sur le résistor ?', '[{"id":"a","text":"Grâce à sa longueur"},{"id":"b","text":"Grâce à son poids"},{"id":"c","text":"Grâce au code des couleurs"},{"id":"d","text":"Grâce à sa forme"}]'::jsonb, 'c', 'Des anneaux colorés imprimés sur le résistor codent sa valeur : c''est le code des couleurs, qui se lit directement ✓. Ni la longueur, ni le poids, ni la forme du résistor n''indiquent sa résistance.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0660f866-d04b-5781-85bf-8fb151817d67', 'fa37b216-c0bf-59cd-aa50-40529b1b01f0', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Loi d''Ohm et caractéristiques', 2, 75, 15, 'practice', 'admin', 3)
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
  ('4993eff6-9020-5a3e-bdf3-2376e4d0549e', '0660f866-d04b-5781-85bf-8fb151817d67', 'Aux bornes d''un résistor, on mesure une tension U = 6 V pour une intensité I = 0,5 A. Quelle est sa résistance ?', '[{"id":"a","text":"0,08 Ω"},{"id":"b","text":"3 Ω"},{"id":"c","text":"6,5 Ω"},{"id":"d","text":"12 Ω"}]'::jsonb, 'd', 'La résistance est le quotient de la tension par l''intensité : R = U/I = 6/0,5 = 12 Ω ✓. Multiplier (6 × 0,5 = 3) ou additionner (6 + 0,5 = 6,5) est faux, et 0,08 Ω vient de la division inversée 0,5/6.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e811528a-a241-56fc-a45b-914b217d25e1', '0660f866-d04b-5781-85bf-8fb151817d67', 'Un résistor de résistance R = 5 Ω est soumis à une tension U = 10 V. Quelle est l''intensité du courant qui le traverse ?', '[{"id":"a","text":"0,5 A"},{"id":"b","text":"2 A"},{"id":"c","text":"15 A"},{"id":"d","text":"50 A"}]'::jsonb, 'b', 'De la loi d''Ohm U = R × I, on tire I = U/R = 10/5 = 2 A ✓. La valeur 50 A viendrait d''une multiplication (10 × 5), 15 A d''une addition (10 + 5), et 0,5 A de la division inversée 5/10.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c2ffa223-7429-560b-9077-67c135a8cb36', '0660f866-d04b-5781-85bf-8fb151817d67', 'Deux résistors sont soumis à la même tension : R1 = 10 Ω et R2 = 20 Ω. Lequel est traversé par le courant le plus faible ?', '[{"id":"a","text":"R1"},{"id":"b","text":"Les deux le même courant"},{"id":"c","text":"R2"},{"id":"d","text":"On ne peut pas savoir"}]'::jsonb, 'c', 'Comme I = U/R, à tension égale, plus la résistance est grande, plus l''intensité est faible. R2 = 20 Ω étant la plus grande résistance, c''est lui qui laisse passer le courant le plus faible ✓. R1, plus petit, laisse passer davantage de courant.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('60c4fc30-c54c-5450-802a-95639ccb4945', '0660f866-d04b-5781-85bf-8fb151817d67', 'Quel composant a une caractéristique courbe, qui n''est pas une droite passant par l''origine ?', '[{"id":"a","text":"Une diode"},{"id":"b","text":"Un conducteur ohmique"},{"id":"c","text":"Un résistor de 10 Ω"},{"id":"d","text":"Un résistor de 100 Ω"}]'::jsonb, 'a', 'La diode n''est pas un résistor : sa caractéristique n''est pas une droite passant par l''origine ✓. Le conducteur ohmique est justement un autre nom du résistor, et un résistor de 10 Ω comme un de 100 Ω ont bien une caractéristique en droite passant par l''origine.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('add45e24-fff3-506b-9133-053dd2ae80c3', '0660f866-d04b-5781-85bf-8fb151817d67', 'Lorsque la peau est mouillée, la résistance du corps humain chute d''environ 5000 Ω à 1000 Ω. Pour une même tension de contact, que devient l''intensité du courant qui traverse le corps ?', '[{"id":"a","text":"Elle diminue"},{"id":"b","text":"Elle reste la même"},{"id":"c","text":"Elle devient nulle"},{"id":"d","text":"Elle augmente"}]'::jsonb, 'd', 'À tension fixée, I = U/R : quand la résistance chute de 5000 Ω à 1000 Ω, l''intensité augmente ✓. C''est pourquoi une peau mouillée rend l''électricité plus dangereuse, le seuil de tension dangereuse tombant de 50 V à 25 V.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2fcb7236-95ac-5676-aa39-df0bb85ff409', '0660f866-d04b-5781-85bf-8fb151817d67', 'Un rhéostat est branché en série avec une lampe. En déplaçant le curseur, on augmente la résistance du rhéostat. Que devient l''intensité du courant dans le circuit ?', '[{"id":"a","text":"Elle augmente"},{"id":"b","text":"Elle diminue"},{"id":"c","text":"Elle reste constante"},{"id":"d","text":"Elle double"}]'::jsonb, 'b', 'Augmenter la résistance du rhéostat augmente la résistance totale du circuit ; or l''intensité diminue quand la résistance grandit (I = U/R). Le courant diminue donc et la lampe brille moins ✓. C''est précisément ainsi qu''un rhéostat commande l''intensité, sans jamais la faire augmenter.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('5dd05201-7540-5485-a414-2641610ddff8', '090c9e09-759f-5ce2-af21-f48409c41776', 'physique-1ere-sec', 'Test de compréhension ⭐ : Les états physiques de la matière', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('25217386-51db-5e5e-bdc6-0b74467b5ea5', '5dd05201-7540-5485-a414-2641610ddff8', 'Quels sont les trois états physiques de la matière ?', '[{"id":"a","text":"Solide, liquide, gazeux"},{"id":"b","text":"Chaud, tiède, froid"},{"id":"c","text":"Dur, mou, mouillé"},{"id":"d","text":"Petit, moyen, grand"}]'::jsonb, 'a', 'La matière se présente sous trois états physiques : solide, liquide et gazeux ✓. Les autres propositions décrivent une température ou une taille, pas un état physique de la matière.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('abc07094-845e-5b5b-98b6-6dfdf42d1bfe', '5dd05201-7540-5485-a414-2641610ddff8', 'Un corps que l''on peut saisir entre les doigts est à l''état :', '[{"id":"a","text":"Liquide"},{"id":"b","text":"Gazeux"},{"id":"c","text":"Solide"},{"id":"d","text":"Fondu"}]'::jsonb, 'c', 'Être saisissable entre les doigts est la marque de l''état solide ✓. Un liquide et un gaz, eux, s''écoulent et ne se laissent pas saisir ; « fondu » n''est pas un état physique de la matière.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('671a0763-76ea-516c-b5e0-93363e15b1f0', '5dd05201-7540-5485-a414-2641610ddff8', 'Comment appelle-t-on les liquides et les gaz, qui s''écoulent facilement ?', '[{"id":"a","text":"Des solides"},{"id":"b","text":"Des fluides"},{"id":"c","text":"Des grains"},{"id":"d","text":"Des cristaux"}]'::jsonb, 'b', 'Les liquides et les gaz, insaisissables et qui s''écoulent, sont appelés des fluides ✓. Les solides, eux, sont saisissables ; les grains et les cristaux sont des formes particulières de solides.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f222edc4-95c0-5c44-ad24-0926e0d7c608', '5dd05201-7540-5485-a414-2641610ddff8', 'Quelle est l''unité de volume dans le système international ?', '[{"id":"a","text":"Le litre (L)"},{"id":"b","text":"Le kilogramme (kg)"},{"id":"c","text":"Le mètre (m)"},{"id":"d","text":"Le mètre cube (m³)"}]'::jsonb, 'd', 'Dans le système international, le volume s''exprime en mètre cube (m³) ✓. Le litre est une unité usuelle mais non l''unité SI ; le kilogramme mesure une masse et le mètre une longueur.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5eefd557-3a06-5882-abfc-8eecaa9e8c0c', '5dd05201-7540-5485-a414-2641610ddff8', 'Que peut-on dire d''un gaz ?', '[{"id":"a","text":"Il a une forme propre"},{"id":"b","text":"Il est compressible et expansible"},{"id":"c","text":"Il a un volume propre"},{"id":"d","text":"Il garde toujours le même volume"}]'::jsonb, 'b', 'Un gaz est compressible (il occupe moins d''espace sous le piston) et expansible (il en occupe plus) ✓. Il n''a donc ni forme propre ni volume propre : il occupe tout l''espace qu''on lui offre.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('0dee1c4c-f8bb-54ba-9846-8e6bf16cea42', '090c9e09-759f-5ce2-af21-f48409c41776', 'physique-1ere-sec', '⭐ Exercice : États, volume et propriétés de la matière', 1, 50, 10, 'practice', 'admin', 1)
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
  ('7cafe90a-730f-5a2d-b90c-d9b0ae44da95', '0dee1c4c-f8bb-54ba-9846-8e6bf16cea42', 'Un verre semble vide. Renversé sur l''eau puis incliné, il laisse échapper des bulles. Que contenait-il ?', '[{"id":"a","text":"De l''air, qui est de la matière"},{"id":"b","text":"Rien du tout"},{"id":"c","text":"Du vide absolu"},{"id":"d","text":"De l''eau"}]'::jsonb, 'a', 'Le verre « vide » est en réalité plein d''air, qui est de la matière ✓ : les bulles qui s''en échappent le prouvent. Il ne contient ni rien ni du vide, et il n''était pas rempli d''eau au départ.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d0f28444-ef0a-5d09-bd3f-976e941a5951', '0dee1c4c-f8bb-54ba-9846-8e6bf16cea42', 'À combien de millilitres correspond 1 cm³ ?', '[{"id":"a","text":"0,1 mL"},{"id":"b","text":"1 mL"},{"id":"c","text":"10 mL"},{"id":"d","text":"1000 mL"}]'::jsonb, 'b', 'Par définition, 1 cm³ = 1 mL ✓. C''est une égalité à retenir. La valeur 1000 mL correspond à 1 litre (1 L = 1000 mL), pas à 1 cm³.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ae69b3f1-142d-5727-af35-f2061a87bf1a', '0dee1c4c-f8bb-54ba-9846-8e6bf16cea42', 'Quelles propriétés caractérisent un corps à l''état solide ?', '[{"id":"a","text":"Ni forme ni volume propres"},{"id":"b","text":"Un volume propre mais pas de forme propre"},{"id":"c","text":"Une forme propre et un volume propre"},{"id":"d","text":"Une forme propre mais pas de volume propre"}]'::jsonb, 'c', 'Un solide a à la fois une forme propre et un volume propre ✓ : il garde sa forme quel que soit le récipient. Un liquide, lui, a un volume propre sans forme propre ; un gaz n''a ni l''une ni l''autre.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f254c2d6-77d2-5b05-b3ee-8d47bb45418a', '0dee1c4c-f8bb-54ba-9846-8e6bf16cea42', 'La farine s''écoule quand on la verse, mais on peut la saisir entre les doigts. C''est :', '[{"id":"a","text":"Un liquide"},{"id":"b","text":"Un gaz"},{"id":"c","text":"Un fluide"},{"id":"d","text":"Un solide"}]'::jsonb, 'd', 'La farine est un solide en grains ✓ : même si elle coule, elle reste saisissable entre les doigts, ce qui la range parmi les solides. Seuls les liquides et les gaz (les fluides) sont insaisissables.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('36a7acf2-fb31-539a-9c16-1c54b094e302', '0dee1c4c-f8bb-54ba-9846-8e6bf16cea42', 'Quel est le volume d''un cube d''arête a = 5 cm ?', '[{"id":"a","text":"15 cm³"},{"id":"b","text":"25 cm³"},{"id":"c","text":"125 cm³"},{"id":"d","text":"625 cm³"}]'::jsonb, 'c', 'Le volume d''un cube est a³ = 5 × 5 × 5 = 125 cm³ ✓. La valeur 25 cm² est l''aire d''une face (5²), 15 vient de 3 × 5, et 625 de 5⁴ : il faut élever l''arête au cube.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7fa903cb-2892-5e30-a204-5955bd68e873', '0dee1c4c-f8bb-54ba-9846-8e6bf16cea42', 'On verse un liquide d''un verre dans une bouteille de forme différente. Que se passe-t-il ?', '[{"id":"a","text":"Il garde sa forme et son volume"},{"id":"b","text":"Il change de forme mais garde son volume"},{"id":"c","text":"Il change de forme et de volume"},{"id":"d","text":"Son volume double"}]'::jsonb, 'b', 'Un liquide épouse la forme de son récipient (pas de forme propre) mais conserve son volume ✓. Il ne garde donc pas sa forme, et son volume ne change pas : il a un volume propre.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('a30e1a83-eb93-5edb-a494-525db481fa85', '090c9e09-759f-5ce2-af21-f48409c41776', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : États, volumes et particules', 2, 75, 15, 'practice', 'admin', 3)
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
  ('9ece779e-0e45-5a9d-8825-a112d328cf42', 'a30e1a83-eb93-5edb-a494-525db481fa85', 'À combien de millilitres correspond 1 litre ?', '[{"id":"a","text":"10 mL"},{"id":"b","text":"100 mL"},{"id":"c","text":"1000 mL"},{"id":"d","text":"10000 mL"}]'::jsonb, 'c', 'Par définition, 1 L = 1000 mL ✓ (soit 1000 cm³, c''est-à-dire 1 dm³). Les valeurs 10 et 100 mL sont bien trop petites, et 10000 mL correspondrait à 10 litres.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e3efc622-cd7b-5914-971c-fd2bc0af9bbd', 'a30e1a83-eb93-5edb-a494-525db481fa85', 'Dans quel état les particules sont-elles dispersées et très agitées ?', '[{"id":"a","text":"L''état solide"},{"id":"b","text":"L''état liquide"},{"id":"c","text":"L''état cristallin"},{"id":"d","text":"L''état gazeux"}]'::jsonb, 'd', 'Dans un gaz, les particules sont espacées, dispersées et très agitées ✓. Dans un solide elles se touchent et sont ordonnées ; dans un liquide elles se touchent mais glissent les unes sur les autres.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('61a6a809-b368-5682-a878-5df72a0ffd6c', 'a30e1a83-eb93-5edb-a494-525db481fa85', 'Comment est la surface libre d''un liquide au repos dans un large récipient ?', '[{"id":"a","text":"Plane et horizontale"},{"id":"b","text":"Toujours courbée"},{"id":"c","text":"Verticale"},{"id":"d","text":"Sphérique"}]'::jsonb, 'a', 'La surface libre d''un liquide étendu est plane et horizontale ✓. Elle n''est courbée (le ménisque) qu''au contact des parois, et jamais verticale ni sphérique pour un liquide au repos.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a0479655-43aa-551a-aabc-8bb6a0ccf566', 'a30e1a83-eb93-5edb-a494-525db481fa85', 'Dans un solide cristallin, comment sont disposées les particules ?', '[{"id":"a","text":"Dispersées et très agitées"},{"id":"b","text":"Au contact et ordonnées"},{"id":"c","text":"Espacées mais immobiles"},{"id":"d","text":"En désordre, glissant les unes sur les autres"}]'::jsonb, 'b', 'Dans un solide cristallin, les particules se touchent et sont ordonnées, avec une agitation très faible ✓. Être dispersées et agitées décrit un gaz ; glisser en désordre décrit un liquide.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c61b00a6-b4d6-5ebd-8fc1-271594a559b0', 'a30e1a83-eb93-5edb-a494-525db481fa85', 'Un récipient cylindrique de rayon R = 2 cm contient de l''eau sur une hauteur h = 5 cm. Quel est le volume de l''eau ? (on prend π ≈ 3,14)', '[{"id":"a","text":"20 cm³"},{"id":"b","text":"31,4 cm³"},{"id":"c","text":"62,8 cm³"},{"id":"d","text":"125,6 cm³"}]'::jsonb, 'c', 'Le volume d''un cylindre est V = π × R² × h = 3,14 × 2² × 5 = 3,14 × 4 × 5 = 62,8 cm³ ✓. Oublier le carré du rayon donne 31,4 ; oublier π donne 20 ; doubler le résultat (ou prendre le diamètre) donne 125,6.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0a18a7a3-5b30-5e16-ac86-5579b6571c38', 'a30e1a83-eb93-5edb-a494-525db481fa85', 'Un verre est déjà rempli à ras bord d''eau. Pourquoi ne peut-on pas y verser du sable sans faire déborder l''eau ?', '[{"id":"a","text":"Parce que deux corps ne peuvent occuper le même espace en même temps"},{"id":"b","text":"Parce que le sable est trop lourd pour l''eau"},{"id":"c","text":"Parce que le sable se dissout aussitôt dans l''eau"},{"id":"d","text":"Parce que l''eau s''évapore au contact du sable"}]'::jsonb, 'a', 'Le sable et l''eau ne peuvent occuper le même espace en même temps : le sable prend la place de l''eau, qui déborde ✓. Ce n''est pas une question de poids, et le sable ne se dissout pas ni ne fait s''évaporer l''eau.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('cfaa1433-5718-5f95-a3ed-8e0ac0f578cd', 'c6786b76-bc3d-55f9-80fb-b9b4febeca46', 'physique-1ere-sec', 'Test de compréhension ⭐ : Quelques propriétés de la matière', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('4e48535a-8747-5264-8460-6055c9dc55cc', 'cfaa1433-5718-5f95-a3ed-8e0ac0f578cd', 'En chauffant un corps solide, que devient son volume ?', '[{"id":"a","text":"Il augmente"},{"id":"b","text":"Il diminue"},{"id":"c","text":"Il reste constant"},{"id":"d","text":"Il s''annule"}]'::jsonb, 'a', 'En s''échauffant, un solide se dilate : son volume augmente ✓. C''est en se refroidissant qu''il se contracte (volume qui diminue). Le volume ne reste pas constant et ne s''annule évidemment jamais.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9544663c-43ec-5fb0-9050-a8b7e49ea42f', 'cfaa1433-5718-5f95-a3ed-8e0ac0f578cd', 'À quelle température l''eau bout-elle sur l''échelle Celsius, sous pression atmosphérique normale ?', '[{"id":"a","text":"0 °C"},{"id":"b","text":"4 °C"},{"id":"c","text":"37 °C"},{"id":"d","text":"100 °C"}]'::jsonb, 'd', 'L''eau bout à 100 °C sous pression normale : c''est le second point fixe de l''échelle Celsius ✓. Le 0 °C correspond à la glace fondante (premier point fixe), 4 °C au volume minimal de l''eau, et 37 °C à la température du corps humain.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7168b5a2-cf82-5029-b45b-e71c258083f9', 'cfaa1433-5718-5f95-a3ed-8e0ac0f578cd', 'À volume égal et pour une même élévation de température, qui se dilate le plus ?', '[{"id":"a","text":"Les solides"},{"id":"b","text":"Les liquides"},{"id":"c","text":"Les gaz"},{"id":"d","text":"Tous de la même façon"}]'::jsonb, 'c', 'L''ordre est gaz > liquides > solides : ce sont les gaz qui se dilatent le plus ✓. Les liquides se dilatent plus que les solides, mais moins que les gaz ; la dilatation n''est donc pas la même pour les trois.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4579525f-f116-5a0f-8166-a9358fc74f60', 'cfaa1433-5718-5f95-a3ed-8e0ac0f578cd', 'De quoi dépend la conductivité thermique d''un corps ?', '[{"id":"a","text":"De sa couleur"},{"id":"b","text":"De la nature du matériau"},{"id":"c","text":"De sa masse"},{"id":"d","text":"De son prix"}]'::jsonb, 'b', 'La conductivité thermique dépend de la nature du matériau ✓ : le cuivre conduit mieux la chaleur que le verre, par exemple. La couleur, la masse ou le prix d''un objet n''ont aucun rôle dans sa capacité à conduire la chaleur.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('79b10bca-3e49-569a-83e9-ea426f3e017f', 'cfaa1433-5718-5f95-a3ed-8e0ac0f578cd', 'Que devient le volume de l''eau quand on la refroidit de 4 °C jusqu''à 0 °C ?', '[{"id":"a","text":"Il diminue"},{"id":"b","text":"Il augmente"},{"id":"c","text":"Il ne change pas"},{"id":"d","text":"Il devient nul"}]'::jsonb, 'b', 'C''est l''anomalie de l''eau : entre 4 °C et 0 °C, son volume augmente au lieu de diminuer ✓. Son volume est minimal à 4 °C. Cette exception explique qu''une bouteille pleine d''eau se casse en gelant.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('67514517-cc86-572f-acb0-78c101a3e4a8', 'c6786b76-bc3d-55f9-80fb-b9b4febeca46', 'physique-1ere-sec', '⭐ Exercice : Dilatation, température et conduction', 1, 50, 10, 'practice', 'admin', 1)
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
  ('f36da336-ef77-5cee-8c64-2b7e75504968', '67514517-cc86-572f-acb0-78c101a3e4a8', 'Quand on refroidit un corps, que lui arrive-t-il ?', '[{"id":"a","text":"Il se dilate"},{"id":"b","text":"Il se contracte"},{"id":"c","text":"Il fond"},{"id":"d","text":"Il s''évapore"}]'::jsonb, 'b', 'En se refroidissant, un corps se contracte : son volume diminue ✓. C''est en le chauffant qu''il se dilate. Fondre ou s''évaporer sont des changements d''état, pas la contraction due au froid.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('becb03c1-56f3-579c-a1c2-f73cfc84c3f8', '67514517-cc86-572f-acb0-78c101a3e4a8', 'Sur l''échelle Celsius, quelle est la température de la glace fondante ?', '[{"id":"a","text":"0 °C"},{"id":"b","text":"4 °C"},{"id":"c","text":"50 °C"},{"id":"d","text":"100 °C"}]'::jsonb, 'a', 'La glace fondante définit le premier point fixe de l''échelle Celsius, à 0 °C ✓. Le 100 °C correspond à l''eau bouillante (second point fixe) et 4 °C au volume minimal de l''eau liquide.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9405bc80-f2a0-5785-8204-09e75334d255', '67514517-cc86-572f-acb0-78c101a3e4a8', 'Vis-à-vis de la chaleur, le bois est :', '[{"id":"a","text":"Un bon conducteur de chaleur"},{"id":"b","text":"Un métal"},{"id":"c","text":"Un mauvais conducteur de chaleur"},{"id":"d","text":"Un excellent conducteur de chaleur"}]'::jsonb, 'c', 'Le bois est un mauvais conducteur de chaleur (un isolant thermique) ✓, ce qui explique les manches en bois des ustensiles. Ce n''est pas un métal, et les métaux, eux, sont de bons conducteurs de chaleur.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('21a14880-73c3-559f-85ee-e648ffd4adce', '67514517-cc86-572f-acb0-78c101a3e4a8', 'Sur quel phénomène repose le fonctionnement d''un thermomètre usuel ?', '[{"id":"a","text":"La couleur du liquide"},{"id":"b","text":"Le poids du liquide"},{"id":"c","text":"Le bruit du liquide"},{"id":"d","text":"La dilatation d''un liquide"}]'::jsonb, 'd', 'Un thermomètre fonctionne grâce à la dilatation d''un liquide (souvent le mercure) : quand la température monte, le liquide se dilate et monte dans le tube ✓. Ni la couleur, ni le poids, ni le bruit du liquide n''interviennent.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cbac5a2f-a278-52db-88d6-f4738159afe4', '67514517-cc86-572f-acb0-78c101a3e4a8', 'On chauffe de la même façon trois tiges de même longueur, en fer, en cuivre et en aluminium. Laquelle s''allonge le plus ?', '[{"id":"a","text":"L''aluminium"},{"id":"b","text":"Le cuivre"},{"id":"c","text":"Le fer"},{"id":"d","text":"Toutes de la même façon"}]'::jsonb, 'a', 'La dilatation dépend de la nature du matériau : l''aluminium s''allonge plus que le cuivre, qui s''allonge plus que le fer ✓. Elles ne s''allongent donc pas de la même façon, malgré une longueur et un chauffage identiques.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0a8fd254-8e16-5bc5-8de0-5c81d8a439d0', '67514517-cc86-572f-acb0-78c101a3e4a8', 'Le mercure est utilisé dans les thermomètres notamment parce qu''il :', '[{"id":"a","text":"Ne se dilate jamais"},{"id":"b","text":"Se dilate facilement"},{"id":"c","text":"Est un gaz à température ordinaire"},{"id":"d","text":"Change de couleur avec la chaleur"}]'::jsonb, 'b', 'Le mercure est choisi car il se dilate facilement, s''obtient pur et ne mouille pas le verre ✓ : c''est sa dilatation qui fait monter le liquide dans le tube. Il ne change pas de couleur et reste liquide à température ordinaire.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f23249a3-447c-5a84-b598-7befa440dea4', 'c6786b76-bc3d-55f9-80fb-b9b4febeca46', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Dilatation, eau et conduction', 2, 75, 15, 'practice', 'admin', 3)
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
  ('13b192cd-1882-517c-8f58-de9373d34408', 'f23249a3-447c-5a84-b598-7befa440dea4', 'Pourquoi laisse-t-on un petit espace entre deux rails de chemin de fer ?', '[{"id":"a","text":"Pour leur permettre de se dilater sans se déformer"},{"id":"b","text":"Pour rendre la pose des rails moins coûteuse"},{"id":"c","text":"Pour réduire le bruit du passage des trains"},{"id":"d","text":"Pour faciliter le nettoyage de la voie"}]'::jsonb, 'a', 'Quand il fait chaud, les rails en acier se dilatent et s''allongent ; l''espace leur laisse la place de le faire sans se déformer ✓. Sans cet espace, la dilatation tordrait la voie. Le coût, le bruit ou le nettoyage n''entrent pas en jeu.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0d230c63-a295-5db4-839e-c8ea8f906084', 'f23249a3-447c-5a84-b598-7befa440dea4', 'Pour un solide filiforme de longueur l₀, quelle relation donne son allongement Δl lorsque sa température varie de Δθ ?', '[{"id":"a","text":"Δl = l₀ × λ × Δθ"},{"id":"b","text":"Δl = l₀ + λ + Δθ"},{"id":"c","text":"Δl = l₀ / (λ × Δθ)"},{"id":"d","text":"Δl = λ / (l₀ × Δθ)"}]'::jsonb, 'a', 'L''allongement d''un solide filiforme est Δl = l₀ × λ × Δθ ✓, où λ est une constante propre au matériau. L''allongement croît avec la longueur initiale, avec λ et avec la variation de température : additionner ou diviser ces grandeurs n''aurait pas de sens physique.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8dee3edb-15e8-5c37-909f-7ee2fa31ab76', 'f23249a3-447c-5a84-b598-7befa440dea4', 'Parmi le cuivre, le verre et le bois, lequel conduit le mieux la chaleur ?', '[{"id":"a","text":"Le verre"},{"id":"b","text":"Le bois"},{"id":"c","text":"Ils conduisent tous de la même façon"},{"id":"d","text":"Le cuivre"}]'::jsonb, 'd', 'Le cuivre est un métal, donc un bon conducteur de chaleur : il conduit bien mieux que le verre, lui-même meilleur que le bois ✓. Le bois est même un isolant thermique. Ils ne conduisent donc pas la chaleur de la même façon.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('943e8084-af94-5be6-bf4a-33c7b64a20e3', 'f23249a3-447c-5a84-b598-7befa440dea4', 'Les solides qui sont de bons conducteurs d''électricité sont généralement :', '[{"id":"a","text":"Des isolants thermiques"},{"id":"b","text":"De bons conducteurs de chaleur"},{"id":"c","text":"De mauvais conducteurs de chaleur"},{"id":"d","text":"Des liquides"}]'::jsonb, 'b', 'Les bons conducteurs d''électricité, comme les métaux, sont généralement de bons conducteurs de chaleur ✓. À l''inverse, les isolants électriques (bois, verre) sont de mauvais conducteurs de chaleur. C''est le pont avec l''électricité du chapitre 1.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('048d6a99-dfe1-5fef-a69b-014bd28e8db4', 'f23249a3-447c-5a84-b598-7befa440dea4', 'Un rail en acier de 10 m s''allonge de 0,01 mm par mètre et par °C. De combien s''allonge-t-il si sa température augmente de 20 °C ?', '[{"id":"a","text":"0,2 mm"},{"id":"b","text":"2 mm"},{"id":"c","text":"20 mm"},{"id":"d","text":"200 mm"}]'::jsonb, 'b', 'L''allongement est 0,01 mm × 10 (mètres) × 20 (°C) = 2 mm ✓. Oublier la longueur (× 10) donne 0,2 mm ; compter un facteur 10 en trop donne 20 mm. Il faut multiplier les trois nombres.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('81cbfde1-78f7-510e-af9b-8a39c60ef5b9', 'f23249a3-447c-5a84-b598-7befa440dea4', 'Une bouteille en verre entièrement remplie d''eau et bien fermée se casse au congélateur. Pourquoi ?', '[{"id":"a","text":"Parce que le verre se dilate au froid"},{"id":"b","text":"Parce que l''eau devient plus lourde en gelant"},{"id":"c","text":"Parce que l''eau augmente de volume en gelant"},{"id":"d","text":"Parce que l''air à l''intérieur se comprime"}]'::jsonb, 'c', 'En gelant, l''eau augmente de volume et pousse sur les parois de la bouteille pleine, qui finit par se casser ✓. Le verre ne se dilate pas au froid (il se contracte), la masse de l''eau ne change pas, et la bouteille pleine ne contient pas d''air.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('57a6d088-3606-574e-9c7a-21ad61085b10', '32d59637-8b9b-5c5d-be28-a661504a41e7', 'physique-1ere-sec', 'Test de compréhension ⭐ : La masse', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('901088c7-9fe6-5ab7-a2da-4bdc1cb7c126', '57a6d088-3606-574e-9c7a-21ad61085b10', 'Avec quel instrument mesure-t-on la masse d''un corps ?', '[{"id":"a","text":"Une éprouvette graduée"},{"id":"b","text":"Une balance"},{"id":"c","text":"Un thermomètre"},{"id":"d","text":"Un voltmètre"}]'::jsonb, 'b', 'La masse se mesure avec une balance ✓, par exemple la balance de Roberval. L''éprouvette sert à mesurer un volume, le thermomètre une température et le voltmètre une tension.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('46c842ff-b964-514f-a585-1d21701968b9', '57a6d088-3606-574e-9c7a-21ad61085b10', 'Quelle est l''unité de la masse dans le système international ?', '[{"id":"a","text":"Le litre (L)"},{"id":"b","text":"Le mètre cube (m³)"},{"id":"c","text":"Le newton (N)"},{"id":"d","text":"Le kilogramme (kg)"}]'::jsonb, 'd', 'L''unité SI de la masse est le kilogramme (kg) ✓. Le litre et le mètre cube mesurent des volumes ; le newton est une unité de force, pas de masse.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c517d5ee-f0f0-5125-b38b-aa31317e87f7', '57a6d088-3606-574e-9c7a-21ad61085b10', 'Comment définit-on la masse volumique ρ d''un corps ?', '[{"id":"a","text":"ρ = m × V"},{"id":"b","text":"ρ = V / m"},{"id":"c","text":"ρ = m / V"},{"id":"d","text":"ρ = m + V"}]'::jsonb, 'c', 'La masse volumique est le rapport de la masse au volume : ρ = m/V ✓, exprimée en kg·m⁻³. Multiplier, additionner ou inverser le rapport (V/m) ne donne pas la masse volumique.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b48ed0de-81ef-58f3-acda-c93765aa77e1', '57a6d088-3606-574e-9c7a-21ad61085b10', 'Que peut-on dire de la densité d''une substance ?', '[{"id":"a","text":"Elle n''a pas d''unité"},{"id":"b","text":"Elle s''exprime en kilogrammes"},{"id":"c","text":"Elle s''exprime en kg·m⁻³"},{"id":"d","text":"Elle s''exprime en litres"}]'::jsonb, 'a', 'La densité est le quotient de deux masses volumiques exprimées dans la même unité : elle n''a donc pas d''unité ✓. C''est la masse volumique, elle, qui s''exprime en kg·m⁻³.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a2144baa-d3b9-5eaa-9fed-0516b67c34e1', '57a6d088-3606-574e-9c7a-21ad61085b10', 'Un corps dont la densité est inférieure à 1 est placé dans l''eau. Que se passe-t-il ?', '[{"id":"a","text":"Il coule"},{"id":"b","text":"Il flotte"},{"id":"c","text":"Il se dissout"},{"id":"d","text":"Il disparaît"}]'::jsonb, 'b', 'Une densité inférieure à 1 signifie que le corps est moins dense que l''eau : il flotte ✓, comme le liège. Un corps de densité supérieure à 1, plus dense que l''eau, coulerait.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('77a71048-e455-52a7-8990-63bf49db5cde', '32d59637-8b9b-5c5d-be28-a661504a41e7', 'physique-1ere-sec', '⭐ Exercice : Masse, masse volumique et densité', 1, 50, 10, 'practice', 'admin', 1)
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
  ('696c3ec0-a0be-5639-90da-2ccd62f57503', '77a71048-e455-52a7-8990-63bf49db5cde', 'Quelle est l''unité de la masse volumique dans le système international ?', '[{"id":"a","text":"Le kilogramme (kg)"},{"id":"b","text":"Le litre (L)"},{"id":"c","text":"Le newton (N)"},{"id":"d","text":"Le kg·m⁻³"}]'::jsonb, 'd', 'La masse volumique s''exprime en kg·m⁻³ dans le système international ✓ (on utilise aussi le g·cm⁻³). Le kilogramme est l''unité de la masse, le litre celle d''un volume et le newton celle d''une force.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('86ed9c43-ea7c-512b-8cd4-669e3e8ac507', '77a71048-e455-52a7-8990-63bf49db5cde', 'On écrase une boule de pâte à modeler pour l''aplatir. Que devient sa masse ?', '[{"id":"a","text":"Elle ne change pas"},{"id":"b","text":"Elle augmente"},{"id":"c","text":"Elle diminue"},{"id":"d","text":"Elle devient nulle"}]'::jsonb, 'a', 'La masse ne dépend pas de la forme du corps : aplatir la pâte ne change pas sa masse ✓. La quantité de matière reste la même, seule la forme change.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('968b920e-58de-516c-85c7-5a0212720e84', '77a71048-e455-52a7-8990-63bf49db5cde', 'Un bloc de glace de masse 1 kg fond entièrement. Quelle est la masse de l''eau obtenue ?', '[{"id":"a","text":"0,92 kg"},{"id":"b","text":"1 kg"},{"id":"c","text":"1,08 kg"},{"id":"d","text":"2 kg"}]'::jsonb, 'b', 'La masse ne dépend pas de l''état physique : 1 kg de glace donne 1 kg d''eau ✓. Seul le volume change lors de la fusion. La valeur 0,92 kg vient d''une confusion avec la densité de la glace (0,92), qui ne s''applique pas à la masse.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cad32dbd-ea52-592a-9e91-01cb2ea95e34', '77a71048-e455-52a7-8990-63bf49db5cde', 'Sur une balance de Roberval, l''équilibre est obtenu avec des masses marquées de 20 g, 5 g et 1 g. Quelle est la masse du corps pesé ?', '[{"id":"a","text":"20 g"},{"id":"b","text":"25 g"},{"id":"c","text":"26 g"},{"id":"d","text":"35 g"}]'::jsonb, 'c', 'À l''équilibre, la masse du corps est la somme des masses marquées : m = 20 + 5 + 1 = 26 g ✓. Oublier la masse de 1 g donnerait 25 g, et ne prendre que la plus grande donnerait 20 g.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0a57dbcd-4898-593e-b517-d86efdb83065', '77a71048-e455-52a7-8990-63bf49db5cde', 'Le cuivre a une densité de 8,90. Que fait un morceau de cuivre plongé dans l''eau ?', '[{"id":"a","text":"Il flotte"},{"id":"b","text":"Il coule"},{"id":"c","text":"Il se dissout"},{"id":"d","text":"Il reste en surface"}]'::jsonb, 'b', 'Une densité de 8,90 est très supérieure à 1 : le cuivre est bien plus dense que l''eau, il coule ✓. Seule une substance de densité inférieure à 1, moins dense que l''eau, flotterait.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b525b03b-77be-54a4-a3af-0ba632d33d8e', '77a71048-e455-52a7-8990-63bf49db5cde', 'Deux objets ont le même volume mais sont faits de substances différentes. Ont-ils forcément la même masse ?', '[{"id":"a","text":"Non, pas forcément la même masse"},{"id":"b","text":"Oui, toujours la même masse"},{"id":"c","text":"Oui, si leur forme est identique"},{"id":"d","text":"Oui, car le volume fixe la masse"}]'::jsonb, 'a', 'À volume égal, deux substances différentes n''ont pas la même masse ✓ : c''est justement ce qui rend le volume insuffisant pour identifier une substance et motive la masse volumique. La forme n''y change rien.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('00f33ff4-afff-53df-a6c6-ae0ce43de208', '32d59637-8b9b-5c5d-be28-a661504a41e7', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Masse volumique, densité et flottaison', 2, 75, 15, 'practice', 'admin', 3)
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
  ('5612e769-b27a-5b88-af8f-a6e549bde657', '00f33ff4-afff-53df-a6c6-ae0ce43de208', 'Un morceau de cuivre a une masse de 89 g et un volume de 10 cm³. Quelle est sa masse volumique ?', '[{"id":"a","text":"0,11 g·cm⁻³"},{"id":"b","text":"8,9 g·cm⁻³"},{"id":"c","text":"89 g·cm⁻³"},{"id":"d","text":"890 g·cm⁻³"}]'::jsonb, 'b', 'La masse volumique est ρ = m/V = 89/10 = 8,9 g·cm⁻³ ✓. Inverser le rapport (10/89) donne 0,11 ; multiplier (89 × 10) donne 890 ; oublier la division laisse 89.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('95fde13f-f2f8-581f-852a-4b7540ecf1db', '00f33ff4-afff-53df-a6c6-ae0ce43de208', 'La masse volumique du cuivre est 8900 kg·m⁻³ et celle de l''eau est 1000 kg·m⁻³. Quelle est la densité du cuivre ?', '[{"id":"a","text":"0,11"},{"id":"b","text":"8,90"},{"id":"c","text":"89"},{"id":"d","text":"8900"}]'::jsonb, 'b', 'La densité est d = ρ(cuivre)/ρ(eau) = 8900/1000 = 8,90 ✓ (sans unité). Diviser dans le mauvais sens donne 0,11, et oublier la division laisse 8900 : il faut bien diviser la masse volumique du cuivre par celle de l''eau.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c96091b6-c363-5c5c-9247-e1b9873f5681', '00f33ff4-afff-53df-a6c6-ae0ce43de208', 'La masse volumique d''un corps peut-elle varier ?', '[{"id":"a","text":"Non, jamais"},{"id":"b","text":"Oui, avec la forme du corps"},{"id":"c","text":"Oui, avec la température"},{"id":"d","text":"Oui, avec la couleur du corps"}]'::jsonb, 'c', 'La masse volumique varie avec la température ✓ : quand le corps se dilate, son volume augmente alors que sa masse reste la même, donc ρ diminue. La forme ou la couleur n''ont, elles, aucun effet sur ρ.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0f7c1fec-9b53-5b37-9382-8f5a4d869533', '00f33ff4-afff-53df-a6c6-ae0ce43de208', 'Deux objets ont le même volume : l''un en cuivre (ρ = 8900 kg·m⁻³), l''autre en aluminium (ρ = 2700 kg·m⁻³). Lequel a la plus grande masse ?', '[{"id":"a","text":"L''aluminium"},{"id":"b","text":"Les deux ont la même masse"},{"id":"c","text":"Impossible à savoir"},{"id":"d","text":"Le cuivre"}]'::jsonb, 'd', 'Comme m = ρ × V, à volume égal, la plus grande masse volumique donne la plus grande masse. Le cuivre (8900 kg·m⁻³) étant plus dense que l''aluminium (2700 kg·m⁻³), c''est lui qui a la plus grande masse ✓.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('dfe295fe-7b17-5250-9b22-ceeafd9d4b9d', '00f33ff4-afff-53df-a6c6-ae0ce43de208', 'Un objet a une masse volumique de 2700 kg·m⁻³ ; celle de l''eau est 1000 kg·m⁻³. Flotte-t-il ou coule-t-il dans l''eau ?', '[{"id":"a","text":"Il coule, car sa densité est supérieure à 1"},{"id":"b","text":"Il flotte, car sa densité est inférieure à 1"},{"id":"c","text":"Il flotte, car sa densité est supérieure à 1"},{"id":"d","text":"Il coule, car sa densité est inférieure à 1"}]'::jsonb, 'a', 'Sa densité vaut d = 2700/1000 = 2,7, supérieure à 1 : l''objet est plus dense que l''eau, il coule ✓. Une densité supérieure à 1 entraîne toujours le coulage, jamais la flottaison.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('55b8437f-deb4-56f1-80b0-a7dc7ef4e208', '00f33ff4-afff-53df-a6c6-ae0ce43de208', 'Un bijou en or a une masse de 25,1 g et un volume de 2 cm³. La masse volumique de l''or est 19,3 g·cm⁻³. Que peut-on conclure ?', '[{"id":"a","text":"Le bijou est en or massif"},{"id":"b","text":"Le bijou est plus dense que l''or"},{"id":"c","text":"Le bijou comporte une cavité (il est creux)"},{"id":"d","text":"Le bijou est en un métal plus lourd que l''or"}]'::jsonb, 'c', 'Le rapport masse sur volume du bijou vaut 25,1/2 = 12,55 g·cm⁻³, inférieur à la masse volumique de l''or (19,3 g·cm⁻³). Un objet en or massif donnerait exactement 19,3 : le bijou comporte donc une cavité, il est creux ✓.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('abec3893-aeff-5291-b4fd-469141699639', '0c787ec0-ce62-5817-b4ab-cd87ee9922a3', 'physique-1ere-sec', 'Test de compréhension ⭐ : Les changements d''état d''un corps pur', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('52ef1e8e-9443-51eb-9721-aad8e9b67083', 'abec3893-aeff-5291-b4fd-469141699639', 'La fusion est le passage d''un corps de l''état...', '[{"id":"a","text":"solide à l''état liquide"},{"id":"b","text":"liquide à l''état solide"},{"id":"c","text":"liquide à l''état gazeux"},{"id":"d","text":"gazeux à l''état solide"}]'::jsonb, 'a', 'La fusion est le passage de l''état solide à l''état liquide ✓ (un glaçon qui fond). Le passage liquide → solide est la solidification, liquide → gaz la vaporisation, gaz → solide la condensation.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('70d6eada-0c28-53d5-8a0e-209f4e02312c', 'abec3893-aeff-5291-b4fd-469141699639', 'Sous la pression atmosphérique normale, à quelle température l''eau pure fond-elle ?', '[{"id":"a","text":"−10°C"},{"id":"b","text":"0°C"},{"id":"c","text":"78°C"},{"id":"d","text":"100°C"}]'::jsonb, 'b', 'L''eau pure fond à 0°C sous la pression atmosphérique normale ✓. La valeur 100°C est sa température d''ébullition, pas de fusion ; 78°C est la température d''ébullition de l''éthanol.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1243d960-6bc9-50f3-86df-a03627d2ced5', 'abec3893-aeff-5291-b4fd-469141699639', 'Comment appelle-t-on le passage direct de l''état solide à l''état gazeux, sans passer par l''état liquide ?', '[{"id":"a","text":"La fusion"},{"id":"b","text":"La liquéfaction"},{"id":"c","text":"La solidification"},{"id":"d","text":"La sublimation"}]'::jsonb, 'd', 'Le passage direct solide → gaz est la sublimation ✓ (l''iode chauffé, une boule antimite). La fusion mène au liquide, la liquéfaction va du gaz au liquide, la solidification du liquide au solide.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('59b1fa2e-579a-5292-ad19-8758551d8565', 'abec3893-aeff-5291-b4fd-469141699639', 'Un glaçon de masse 60 g fond entièrement. Quelle est la masse de l''eau liquide obtenue ?', '[{"id":"a","text":"0 g"},{"id":"b","text":"55 g"},{"id":"c","text":"60 g"},{"id":"d","text":"66 g"}]'::jsonb, 'c', 'Au cours d''un changement d''état, la masse est conservée : 60 g de glace donnent 60 g d''eau ✓. La glace ne « disparaît » pas (0 g) et ne gagne ni ne perd de matière (55 g ou 66 g) ; seul le volume change.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('dd9483bf-9486-5a08-96e5-a8dfa26c5f21', 'abec3893-aeff-5291-b4fd-469141699639', 'Pendant que l''eau pure bout, sous pression constante, que fait sa température ?', '[{"id":"a","text":"Elle reste constante"},{"id":"b","text":"Elle augmente régulièrement"},{"id":"c","text":"Elle diminue"},{"id":"d","text":"Elle augmente puis diminue"}]'::jsonb, 'a', 'Pour un corps pur, la température reste constante pendant tout le changement d''état ✓ : c''est le palier. L''eau pure reste à 100°C tant qu''elle bout, même si on continue de chauffer.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ed73f815-6a7a-53e4-a11e-7bf15e6b7725', '0c787ec0-ce62-5817-b4ab-cd87ee9922a3', 'physique-1ere-sec', '⭐ Exercice : Nommer et reconnaître les changements d''état', 1, 50, 10, 'practice', 'admin', 1)
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
  ('68878c00-3bfb-5889-8de8-7d19b65bb0b1', 'ed73f815-6a7a-53e4-a11e-7bf15e6b7725', 'Comment appelle-t-on le passage de l''état liquide à l''état solide ?', '[{"id":"a","text":"La solidification"},{"id":"b","text":"La fusion"},{"id":"c","text":"La sublimation"},{"id":"d","text":"La vaporisation"}]'::jsonb, 'a', 'Le passage liquide → solide est la solidification ✓ (l''eau qui gèle). La fusion est le passage inverse, solide → liquide ; elle en est la transformation inverse.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b965b8cd-cdaa-5ca7-ae45-e525898f087a', 'ed73f815-6a7a-53e4-a11e-7bf15e6b7725', 'Sous la pression atmosphérique normale, à quelle température l''eau pure bout-elle ?', '[{"id":"a","text":"0°C"},{"id":"b","text":"37°C"},{"id":"c","text":"78°C"},{"id":"d","text":"100°C"}]'::jsonb, 'd', 'L''eau pure bout à 100°C sous la pression atmosphérique normale ✓. La valeur 0°C est sa température de fusion, pas d''ébullition.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('71d40794-119f-5b05-98d5-4c833db53ffb', 'ed73f815-6a7a-53e4-a11e-7bf15e6b7725', 'Du linge mouillé étendu à l''air libre sèche peu à peu, à la température ambiante. De quel changement d''état s''agit-il ?', '[{"id":"a","text":"Une ébullition"},{"id":"b","text":"Une évaporation"},{"id":"c","text":"Une fusion"},{"id":"d","text":"Une liquéfaction"}]'::jsonb, 'b', 'L''eau du linge passe à l''état gazeux à la surface, sans bouillir : c''est une évaporation ✓. L''évaporation se produit à n''importe quelle température, contrairement à l''ébullition qui exige 100°C.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f83c933b-de36-5e08-a867-0af7125c9d74', 'ed73f815-6a7a-53e4-a11e-7bf15e6b7725', 'À chaque changement d''état d''un corps pur correspond...', '[{"id":"a","text":"une perte de masse"},{"id":"b","text":"un changement de nature"},{"id":"c","text":"un changement d''état inverse"},{"id":"d","text":"rien de particulier"}]'::jsonb, 'c', 'À chaque changement d''état correspond un changement d''état inverse ✓ : à la fusion répond la solidification, à la vaporisation la liquéfaction, à la sublimation la condensation. La masse et la nature, elles, sont conservées.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0f9b0f3f-8547-5aae-bc35-e9ccf87e13cc', 'ed73f815-6a7a-53e4-a11e-7bf15e6b7725', 'De la vapeur d''eau se dépose en fines gouttelettes liquides sur une vitre froide (la buée). De quel changement d''état s''agit-il ?', '[{"id":"a","text":"Une fusion"},{"id":"b","text":"Une solidification"},{"id":"c","text":"Une sublimation"},{"id":"d","text":"Une liquéfaction"}]'::jsonb, 'd', 'La vapeur (gaz) qui devient liquide subit une liquéfaction ✓ : c''est le passage gaz → liquide, transformation inverse de la vaporisation. La fusion et la solidification ne concernent que le couple solide-liquide.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fe0b9f06-2472-53ac-bdb0-132cca91c50b', 'ed73f815-6a7a-53e4-a11e-7bf15e6b7725', 'Lorsqu''un corps pur change d''état, que devient la substance (sa nature) ?', '[{"id":"a","text":"Elle change complètement"},{"id":"b","text":"Elle reste la même"},{"id":"c","text":"Elle disparaît"},{"id":"d","text":"Elle devient un mélange"}]'::jsonb, 'b', 'Au cours d''un changement d''état, la nature du corps reste la même ✓ : de la glace, de l''eau liquide et de la vapeur sont toutes de l''eau. Seul l''état physique (et le volume) change, jamais la substance.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('bf9dc0af-f96d-5a69-946c-2672a7624bd3', '0c787ec0-ce62-5817-b4ab-cd87ee9922a3', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Paliers, modes de vaporisation et corps pur', 2, 75, 15, 'practice', 'admin', 3)
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
  ('4dda1f80-a8d8-5687-9dc0-e958b5a1fd6f', 'bf9dc0af-f96d-5a69-946c-2672a7624bd3', 'Quelle propriété caractérise l''évaporation (et non l''ébullition) ?', '[{"id":"a","text":"Elle se produit dans toute la masse du liquide"},{"id":"b","text":"Elle exige la formation de grosses bulles"},{"id":"c","text":"Elle a lieu à une température fixe de 100°C"},{"id":"d","text":"Elle a lieu en surface, à n''importe quelle température"}]'::jsonb, 'd', 'L''évaporation se produit seulement en surface et à n''importe quelle température ✓. L''ébullition, elle, se produit dans toute la masse du liquide, avec de grosses bulles, à une température fixe (100°C pour l''eau).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cf0dcf01-4324-51f0-8eb3-60efea699dd8', 'bf9dc0af-f96d-5a69-946c-2672a7624bd3', 'Sur la courbe θ(t) d''un corps pur chauffé, la température reste bloquée à une valeur constante pendant un moment (un palier). Que se passe-t-il durant ce palier ?', '[{"id":"a","text":"Sa température augmente"},{"id":"b","text":"Il change d''état"},{"id":"c","text":"Sa masse augmente"},{"id":"d","text":"Il se refroidit"}]'::jsonb, 'b', 'Pour un corps pur, la température reste constante pendant tout un changement d''état : le palier correspond au changement d''état ✓ (fusion ou ébullition). La chaleur apportée sert à changer l''état, pas à élever la température.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('608fd8d9-a73e-52b7-8d93-07f04f474006', 'bf9dc0af-f96d-5a69-946c-2672a7624bd3', 'Un liquide se solidifie entièrement à une température constante de 5°C. Que peut-on en déduire ?', '[{"id":"a","text":"C''est un corps pur"},{"id":"b","text":"C''est un mélange"},{"id":"c","text":"C''est forcément de l''eau"},{"id":"d","text":"Il n''a pas de température de solidification"}]'::jsonb, 'a', 'Une solidification à température constante est la signature d''un corps pur ✓. Ce n''est pas de l''eau (qui se solidifie à 0°C, pas à 5°C) : la valeur du palier dépend du corps, mais sa constance prouve la pureté.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1c029ee7-cd8b-5cce-9e00-577679376c5f', 'bf9dc0af-f96d-5a69-946c-2672a7624bd3', 'Au cours d''un changement d''état d''un corps pur, qu''est-ce qui est conservé ?', '[{"id":"a","text":"Le volume et la forme"},{"id":"b","text":"Le volume et la température"},{"id":"c","text":"La masse et la nature"},{"id":"d","text":"Rien n''est conservé"}]'::jsonb, 'c', 'La masse et la nature du corps sont conservées ✓. Le volume, lui, change (la glace occupe plus de place que l''eau liquide), et la température reste constante seulement pendant le palier : ce ne sont donc pas eux qui définissent la conservation.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4b0dd7b3-925e-5047-bc97-2c116d331324', 'bf9dc0af-f96d-5a69-946c-2672a7624bd3', 'On chauffe de l''eau liquide de 20°C jusqu''à 120°C, sous la pression atmosphérique normale. Combien de paliers la courbe θ(t) présente-t-elle ?', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"2"},{"id":"d","text":"3"}]'::jsonb, 'b', 'L''eau part déjà liquide (20°C) : il n''y a pas de fusion. Elle atteint seulement l''ébullition à 100°C, d''où 1 seul palier ✓. Un départ à l''état solide (glace) aurait ajouté le palier de fusion à 0°C, soit 2 paliers.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d88bf2b4-e009-52a9-9ede-864872a15a18', 'bf9dc0af-f96d-5a69-946c-2672a7624bd3', 'Dans une bouteille fermée et isolée thermiquement, de la glace et de l''eau liquide coexistent sans que leurs quantités changent au cours du temps. Comment décrit-on ce système ?', '[{"id":"a","text":"En fusion totale"},{"id":"b","text":"En évaporation"},{"id":"c","text":"En équilibre dynamique"},{"id":"d","text":"En sublimation"}]'::jsonb, 'c', 'Les quantités ne changent plus car autant de molécules passent de la glace à l''eau que l''inverse : le système est en équilibre dynamique ✓. Il n''y a ni fusion totale (la glace subsiste) ni sublimation (aucun passage direct solide → gaz).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d06ae886-0bd4-5fd3-b145-6bd4ccd3e66d', '9da7c97f-7d81-5e5e-95f1-9019f1394cc2', 'physique-1ere-sec', 'Test de compréhension ⭐ : Le mouvement', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('e330a40f-c0f5-5450-a24d-f85391669092', 'd06ae886-0bd4-5fd3-b145-6bd4ccd3e66d', 'Dans le système international, quelle est l''unité de durée ?', '[{"id":"a","text":"Le mètre (m)"},{"id":"b","text":"La seconde (s)"},{"id":"c","text":"Le kilomètre (km)"},{"id":"d","text":"Le newton (N)"}]'::jsonb, 'b', 'L''unité de durée du système international est la seconde (s) ✓. Le mètre et le kilomètre mesurent des longueurs, le newton une force : aucun ne mesure une durée.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2581fd79-32b1-569b-aff9-078e406d8400', 'd06ae886-0bd4-5fd3-b145-6bd4ccd3e66d', 'De quoi est constitué un référentiel ?', '[{"id":"a","text":"D''un repère espace et d''un repère temps"},{"id":"b","text":"D''un repère espace et d''une balance"},{"id":"c","text":"D''une règle et d''un thermomètre"},{"id":"d","text":"D''une trajectoire et d''une vitesse"}]'::jsonb, 'a', 'Un référentiel réunit un repère espace (pour situer la position) et un repère temps (pour dater) ✓. C''est le point de vue depuis lequel on étudie le mouvement d''un mobile.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1ade1bbd-1b4c-5181-941e-3f4d763bf77e', 'd06ae886-0bd4-5fd3-b145-6bd4ccd3e66d', 'Comment appelle-t-on une trajectoire portée par un cercle ?', '[{"id":"a","text":"Rectiligne"},{"id":"b","text":"Curviligne"},{"id":"c","text":"Uniforme"},{"id":"d","text":"Circulaire"}]'::jsonb, 'd', 'Une trajectoire portée par un cercle est circulaire ✓. Rectiligne = portée par une droite, curviligne = par une courbe. « Uniforme » ne décrit pas la trajectoire mais la façon dont la vitesse évolue.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cb94fa8a-6965-582b-b822-3f2f9f365461', 'd06ae886-0bd4-5fd3-b145-6bd4ccd3e66d', 'Une voiture parcourt 200 m en 10 s. Quelle est sa vitesse moyenne ?', '[{"id":"a","text":"0,05 m·s⁻¹"},{"id":"b","text":"20 m·s⁻¹"},{"id":"c","text":"200 m·s⁻¹"},{"id":"d","text":"2000 m·s⁻¹"}]'::jsonb, 'b', 'Vmoy = d/t = 200/10 = 20 m·s⁻¹ ✓. Inverser le rapport (10/200) donne 0,05 ; oublier la division laisse 200 ; multiplier (200 × 10) donne 2000.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1a2f481f-f7b2-54b2-ad45-b585ba60f75c', 'd06ae886-0bd4-5fd3-b145-6bd4ccd3e66d', 'Comment qualifie-t-on un mouvement dont la vitesse diminue au cours du temps ?', '[{"id":"a","text":"Accéléré"},{"id":"b","text":"Uniforme"},{"id":"c","text":"Décéléré"},{"id":"d","text":"Rectiligne"}]'::jsonb, 'c', 'Un mouvement dont la vitesse diminue est décéléré (ou ralenti) ✓. Si la vitesse augmente, il est accéléré ; si elle reste inchangée, il est uniforme. « Rectiligne » décrit la trajectoire, pas la vitesse.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('111cc851-de77-5b0c-9d18-a246009aca79', '9da7c97f-7d81-5e5e-95f1-9019f1394cc2', 'physique-1ere-sec', '⭐ Exercice : Référentiel, trajectoire et vitesse', 1, 50, 10, 'practice', 'admin', 1)
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
  ('ebbbd5e0-1461-5d44-bfad-ec62ad240307', '111cc851-de77-5b0c-9d18-a246009aca79', 'Dans le système international, quelle est l''unité de longueur ?', '[{"id":"a","text":"Le mètre (m)"},{"id":"b","text":"La seconde (s)"},{"id":"c","text":"Le litre (L)"},{"id":"d","text":"Le newton (N)"}]'::jsonb, 'a', 'L''unité de longueur du système international est le mètre (m) ✓. La seconde mesure une durée, le litre un volume et le newton une force.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('14c91eb6-4b49-50e0-ab53-6202a3024100', '111cc851-de77-5b0c-9d18-a246009aca79', 'Qu''est-ce que la trajectoire d''un mobile ?', '[{"id":"a","text":"Sa vitesse à chaque instant"},{"id":"b","text":"La durée de son parcours"},{"id":"c","text":"L''ensemble des positions qu''il occupe au cours du temps"},{"id":"d","text":"Son seul point de départ"}]'::jsonb, 'c', 'La trajectoire est l''ensemble des positions successives occupées par le mobile au cours du temps, dans un repère donné ✓. Ce n''est ni sa vitesse, ni la durée du trajet, ni un point isolé.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('443d4494-a824-5596-b36d-c27138558c39', '111cc851-de77-5b0c-9d18-a246009aca79', 'Pour dire si un corps est en mouvement ou au repos, il faut d''abord...', '[{"id":"a","text":"connaître sa masse"},{"id":"b","text":"choisir un corps de référence"},{"id":"c","text":"mesurer sa température"},{"id":"d","text":"attendre qu''il s''arrête"}]'::jsonb, 'b', 'Le mouvement est relatif : il faut choisir un corps de référence ✓. Un même corps peut être en mouvement par rapport à l''un et au repos par rapport à un autre. Ni la masse ni la température n''entrent en jeu.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e3d78bcb-719f-5e94-a74d-b52f2ab0d472', '111cc851-de77-5b0c-9d18-a246009aca79', 'Une voiture qui démarre et prend de la vitesse a un mouvement...', '[{"id":"a","text":"uniforme"},{"id":"b","text":"décéléré"},{"id":"c","text":"circulaire"},{"id":"d","text":"accéléré"}]'::jsonb, 'd', 'Sa vitesse augmente : le mouvement est accéléré ✓. Uniforme = vitesse constante, décéléré = vitesse qui diminue. « Circulaire » décrit la forme de la trajectoire, pas l''évolution de la vitesse.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c8d3f6a6-6a36-5281-b85c-1a729886b6cf', '111cc851-de77-5b0c-9d18-a246009aca79', 'Une bille roule en ligne droite sur le sol. Sa trajectoire est...', '[{"id":"a","text":"circulaire"},{"id":"b","text":"curviligne"},{"id":"c","text":"rectiligne"},{"id":"d","text":"uniforme"}]'::jsonb, 'c', 'Une trajectoire portée par une droite est rectiligne ✓. Circulaire = un cercle, curviligne = une courbe. « Uniforme » ne qualifie pas la trajectoire mais la vitesse.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ad3c0dfd-77a0-56e6-ad95-ac5f572b3bd9', '111cc851-de77-5b0c-9d18-a246009aca79', 'La vitesse moyenne d''un mobile est égale...', '[{"id":"a","text":"au produit de la distance par la durée"},{"id":"b","text":"au quotient de la distance par la durée"},{"id":"c","text":"à la somme de la distance et de la durée"},{"id":"d","text":"à la durée divisée par la distance"}]'::jsonb, 'b', 'La vitesse moyenne est le quotient de la distance parcourue par la durée du parcours : Vmoy = d/t ✓. Multiplier, additionner ou inverser le rapport (t/d) ne donne pas une vitesse.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ba18e988-ce16-507d-a989-942f4e511fc4', '9da7c97f-7d81-5e5e-95f1-9019f1394cc2', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Vitesses, conversions et relativité', 2, 75, 15, 'practice', 'admin', 3)
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
  ('c1362b71-90d2-5b66-a12e-6d57b2bd1a4e', 'ba18e988-ce16-507d-a989-942f4e511fc4', 'Une vitesse de 15 m·s⁻¹ correspond à quelle vitesse en kilomètres par heure ?', '[{"id":"a","text":"4,2 km·h⁻¹"},{"id":"b","text":"18,6 km·h⁻¹"},{"id":"c","text":"54 km·h⁻¹"},{"id":"d","text":"540 km·h⁻¹"}]'::jsonb, 'c', 'On multiplie par 3,6 : 15 × 3,6 = 54 km·h⁻¹ ✓. Diviser par 3,6 donne 4,2 ; ajouter 3,6 donne 18,6 ; multiplier par 36 donne 540. La bonne conversion est 1 m·s⁻¹ = 3,6 km·h⁻¹.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a2b7d150-aa88-5b11-b74e-bf3d4b4ecb8f', 'ba18e988-ce16-507d-a989-942f4e511fc4', 'Un voyageur est assis dans un avion en vol. Par rapport à quoi est-il en mouvement ?', '[{"id":"a","text":"Par rapport au sol"},{"id":"b","text":"Par rapport à son siège"},{"id":"c","text":"Par rapport au passager assis à côté"},{"id":"d","text":"Par rapport à son bagage posé près de lui"}]'::jsonb, 'a', 'Il est en mouvement par rapport au sol ✓ : sa position par rapport au sol change à chaque instant. Par rapport à son siège, à son voisin ou à son bagage, il reste immobile : le mouvement dépend de la référence choisie.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('118d25fa-1878-53e7-81c4-b7a066c507aa', 'ba18e988-ce16-507d-a989-942f4e511fc4', 'Que mesure le tachymètre (compteur de vitesse) d''une voiture ?', '[{"id":"a","text":"La vitesse moyenne du trajet"},{"id":"b","text":"La vitesse maximale autorisée"},{"id":"c","text":"La vitesse du vent"},{"id":"d","text":"La vitesse instantanée"}]'::jsonb, 'd', 'Le tachymètre affiche la vitesse instantanée, c''est-à-dire la vitesse à l''instant précis où on le lit ✓. La vitesse moyenne, elle, se calcule sur tout le trajet (Vmoy = d/t) et peut être différente.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('05905e85-f9a8-556c-b59d-6f886ac3fce6', 'ba18e988-ce16-507d-a989-942f4e511fc4', 'Une bille se déplace en gardant une vitesse constante. Son mouvement est...', '[{"id":"a","text":"accéléré"},{"id":"b","text":"uniforme"},{"id":"c","text":"décéléré"},{"id":"d","text":"instantané"}]'::jsonb, 'b', 'Une vitesse qui reste inchangée définit un mouvement uniforme ✓. Accéléré = vitesse qui augmente, décéléré = vitesse qui diminue. « Instantané » n''est pas un type de mouvement.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4ca9502a-16dc-5e58-b3e5-a05f270e0e47', 'ba18e988-ce16-507d-a989-942f4e511fc4', 'Un marcheur parcourt 600 m en 2 min 30 s. Quelle est sa vitesse moyenne ?', '[{"id":"a","text":"4 m·s⁻¹"},{"id":"b","text":"5 m·s⁻¹"},{"id":"c","text":"240 m·s⁻¹"},{"id":"d","text":"300 m·s⁻¹"}]'::jsonb, 'a', 'Il faut convertir la durée en secondes : 2 min 30 s = 150 s. Alors Vmoy = 600/150 = 4 m·s⁻¹ ✓. Prendre 120 s (oubli des 30 s) donne 5 ; garder 2,5 min sans convertir donne 240 ; ne compter que 2 min donne 300.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2955aa3a-8a54-5630-87ff-ecec8468bd61', 'ba18e988-ce16-507d-a989-942f4e511fc4', 'Un train roule à la vitesse constante de 30 m·s⁻¹. Quelle distance parcourt-il en 1 min ?', '[{"id":"a","text":"30 m"},{"id":"b","text":"108 m"},{"id":"c","text":"1800 m"},{"id":"d","text":"3600 m"}]'::jsonb, 'c', 'De Vmoy = d/t on tire d = Vmoy × t. Avec t = 1 min = 60 s : d = 30 × 60 = 1800 m ✓. Oublier de convertir la minute (t = 1 s) donne 30 m ; confondre avec 30 m·s⁻¹ = 108 km·h⁻¹ donne 108.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1db9845a-a557-5435-8fa2-162b2e319e0c', '5e11f66c-337a-5c91-9846-11ae4934ed8d', 'physique-1ere-sec', 'Test de compréhension ⭐ : Les actions mécaniques', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('7690ed5f-25da-5854-b4db-0e3a767d6ecb', '1db9845a-a557-5435-8fa2-162b2e319e0c', 'Un aimant attire une bille en fer sans la toucher. Cette action mécanique est...', '[{"id":"a","text":"de contact"},{"id":"b","text":"à distance"},{"id":"c","text":"de frottement"},{"id":"d","text":"de pression"}]'::jsonb, 'b', 'L''aimant agit sans contact : c''est une action à distance ✓, comme le poids exercé par la Terre. Le frottement et la pression, eux, sont des actions de contact : ils supposent que les corps se touchent.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d3cab0b1-a2c9-51f2-a555-f3562c707b86', '1db9845a-a557-5435-8fa2-162b2e319e0c', 'Dans le système international, en quelle unité s''exprime l''intensité d''une force ?', '[{"id":"a","text":"Le kilogramme (kg)"},{"id":"b","text":"Le mètre (m)"},{"id":"c","text":"La seconde (s)"},{"id":"d","text":"Le newton (N)"}]'::jsonb, 'd', 'L''intensité d''une force s''exprime en newton (N) ✓ et se mesure avec un dynamomètre. Le kilogramme mesure une masse, le mètre une longueur et la seconde une durée.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('64855545-4c08-571b-b5f6-917916d40e96', '1db9845a-a557-5435-8fa2-162b2e319e0c', 'Dans quelle direction et quel sens le poids d''un corps est-il dirigé ?', '[{"id":"a","text":"Verticalement, vers le bas"},{"id":"b","text":"Horizontalement"},{"id":"c","text":"Verticalement, vers le haut"},{"id":"d","text":"Dans le sens du mouvement"}]'::jsonb, 'a', 'Le poids est vertical et orienté vers le bas ✓, vers le centre de la Terre. Il n''est ni horizontal, ni dirigé vers le haut, et ne suit pas le mouvement du corps.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('680da7d8-1eb2-58fc-b9dc-fcd5267cd3f0', '1db9845a-a557-5435-8fa2-162b2e319e0c', 'Un corps a une masse de 2 kg. En prenant g = 10 N·kg⁻¹, quelle est l''intensité de son poids ?', '[{"id":"a","text":"2 N"},{"id":"b","text":"12 N"},{"id":"c","text":"20 N"},{"id":"d","text":"200 N"}]'::jsonb, 'c', 'P = m × g = 2 × 10 = 20 N ✓. Garder seulement la masse donne 2 ; additionner (2 + 10) donne 12 ; se tromper de facteur (× 100) donne 200.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('355b981f-10be-540f-8ce8-30535dde173d', '1db9845a-a557-5435-8fa2-162b2e319e0c', 'On écrase une boule de pâte à modeler pour l''aplatir. De quel type d''effet s''agit-il ?', '[{"id":"a","text":"Un effet dynamique"},{"id":"b","text":"Un effet statique"},{"id":"c","text":"Une mise en mouvement"},{"id":"d","text":"Une action à distance"}]'::jsonb, 'b', 'Déformer un corps est un effet statique ✓. Un effet dynamique met en mouvement ou change la vitesse/trajectoire ; ici la pâte ne se déplace pas, elle change de forme.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('94aa116d-1cda-54c2-bbb1-01412b80b661', '5e11f66c-337a-5c91-9846-11ae4934ed8d', 'physique-1ere-sec', '⭐ Exercice : Actions, effets et poids', 1, 50, 10, 'practice', 'admin', 1)
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
  ('ec333663-5494-5130-afb2-5b1203d98a4c', '94aa116d-1cda-54c2-bbb1-01412b80b661', 'Un joueur frappe un ballon avec son pied. Cette action mécanique est...', '[{"id":"a","text":"de contact"},{"id":"b","text":"à distance"},{"id":"c","text":"une attraction"},{"id":"d","text":"sans point d''application"}]'::jsonb, 'a', 'Le pied touche le ballon : c''est une action de contact ✓. Elle n''agit pas à distance (contrairement à un aimant), c''est une poussée et non une attraction, et comme toute force elle possède bien un point d''application.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a1aa71c7-8515-566c-9de1-074170c60a4a', '94aa116d-1cda-54c2-bbb1-01412b80b661', 'Pousser un chariot immobile pour le faire avancer, c''est produire...', '[{"id":"a","text":"un effet statique"},{"id":"b","text":"un effet dynamique"},{"id":"c","text":"une déformation"},{"id":"d","text":"une attraction à distance"}]'::jsonb, 'b', 'Mettre un corps en mouvement est un effet dynamique ✓. Un effet statique déformerait le corps sans le déplacer ; ici le chariot se déplace sans se déformer.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a766200e-0ec2-59bd-9ff9-e9a3ebc47c5c', '94aa116d-1cda-54c2-bbb1-01412b80b661', 'Un ressort qu''on étire puis qu''on relâche reprend sa forme initiale. Ce corps est...', '[{"id":"a","text":"inélastique"},{"id":"b","text":"rigide"},{"id":"c","text":"élastique"},{"id":"d","text":"liquide"}]'::jsonb, 'c', 'Un corps qui reprend sa forme après déformation est élastique ✓. Un corps inélastique, comme la pâte à modeler, resterait déformé.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('34c05089-555e-5436-b7db-3254ccb0b9a6', '94aa116d-1cda-54c2-bbb1-01412b80b661', 'Quel instrument mesure l''intensité d''une force ?', '[{"id":"a","text":"La balance"},{"id":"b","text":"Le thermomètre"},{"id":"c","text":"Le chronomètre"},{"id":"d","text":"Le dynamomètre"}]'::jsonb, 'd', 'L''intensité d''une force se mesure avec un dynamomètre ✓, en newtons. La balance mesure une masse, le thermomètre une température et le chronomètre une durée.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e56f771a-1595-59e9-9534-44a88405e317', '94aa116d-1cda-54c2-bbb1-01412b80b661', 'Le poids d''un corps est une action à distance exercée par...', '[{"id":"a","text":"l''air qui l''entoure"},{"id":"b","text":"la Terre"},{"id":"c","text":"le Soleil"},{"id":"d","text":"l''aimant le plus proche"}]'::jsonb, 'b', 'Le poids est la force d''attraction exercée par la Terre sur le corps ✓. Ce n''est pas l''air, ni le Soleil, ni un aimant : c''est bien l''attraction terrestre.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('44891c20-f709-5171-8603-109bf8f7d601', '94aa116d-1cda-54c2-bbb1-01412b80b661', 'En quel point d''un corps représente-t-on son poids ?', '[{"id":"a","text":"À son sommet"},{"id":"b","text":"En son centre de gravité G"},{"id":"c","text":"Dans un coin"},{"id":"d","text":"En son point le plus bas"}]'::jsonb, 'b', 'On représente le poids au centre de gravité G du corps ✓ : c''est son point d''application. Ce n''est ni le sommet, ni un coin, ni le point le plus bas.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('01a46421-8763-5bd9-8898-af99bcccb771', '5e11f66c-337a-5c91-9846-11ae4934ed8d', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Poids, pesanteur et principe d''inertie', 2, 75, 15, 'practice', 'admin', 3)
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
  ('f5dcad86-38e6-5563-b34a-96a26bc938fe', '01a46421-8763-5bd9-8898-af99bcccb771', 'Au même endroit, on double la masse d''un corps. Que devient l''intensité de son poids ?', '[{"id":"a","text":"Elle ne change pas"},{"id":"b","text":"Elle double"},{"id":"c","text":"Elle diminue de moitié"},{"id":"d","text":"Elle devient nulle"}]'::jsonb, 'b', 'Comme P = m × g et que g est le même au même endroit, le poids est proportionnel à la masse : doubler la masse double le poids ✓. Il ne peut ni rester constant, ni diminuer, ni s''annuler.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('54c871cc-66f7-5ad2-9e75-5037e7c0cbcd', '01a46421-8763-5bd9-8898-af99bcccb771', 'Un même corps est pesé à l''équateur (g = 9,78 N·kg⁻¹) puis au pôle Nord (g = 9,83 N·kg⁻¹). Où son poids est-il le plus grand ?', '[{"id":"a","text":"Le même aux deux endroits"},{"id":"b","text":"À l''équateur"},{"id":"c","text":"Nul au pôle"},{"id":"d","text":"Au pôle Nord"}]'::jsonb, 'd', 'P = m × g : la masse est la même, donc le poids est le plus grand là où g est le plus grand. Comme g augmente avec la latitude (9,83 au pôle > 9,78 à l''équateur), le poids est le plus grand au pôle Nord ✓.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('aa8d71e4-90cb-5351-a3b5-f8e71535d971', '01a46421-8763-5bd9-8898-af99bcccb771', 'Un astronaute emporte un objet de la Terre vers un lieu où l''intensité de la pesanteur g est plus faible. Que devient la masse de l''objet ?', '[{"id":"a","text":"Elle ne change pas"},{"id":"b","text":"Elle diminue"},{"id":"c","text":"Elle augmente"},{"id":"d","text":"Elle devient nulle"}]'::jsonb, 'a', 'La masse mesure la quantité de matière : elle ne dépend pas du lieu et ne change pas ✓. C''est le poids (P = m × g) qui diminue là où g est plus faible, pas la masse.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1c334e34-a05c-5ff1-893e-0fbdee844f51', '01a46421-8763-5bd9-8898-af99bcccb771', 'Dans un référentiel galiléen, le centre d''inertie d''un corps isolé, initialement en mouvement, est animé d''un...', '[{"id":"a","text":"arrêt immédiat"},{"id":"b","text":"mouvement circulaire"},{"id":"c","text":"mouvement rectiligne uniforme"},{"id":"d","text":"mouvement de plus en plus rapide"}]'::jsonb, 'c', 'C''est le principe d''inertie (1ère loi de Newton) : sans action (ou avec des actions qui se compensent), le centre d''inertie déjà en mouvement garde un mouvement rectiligne uniforme ✓. Il ne s''arrête pas, ne tourne pas et n''accélère pas.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c7ec54f5-5c0c-5aab-ac63-02e8ee629344', '01a46421-8763-5bd9-8898-af99bcccb771', 'Le poids d''un corps vaut 60 N en un lieu où g = 10 N·kg⁻¹. Quelle est sa masse ?', '[{"id":"a","text":"6 kg"},{"id":"b","text":"50 kg"},{"id":"c","text":"70 kg"},{"id":"d","text":"600 kg"}]'::jsonb, 'a', 'De P = m × g on tire m = P/g = 60/10 = 6 kg ✓. Soustraire (60 − 10) donne 50 ; additionner (60 + 10) donne 70 ; multiplier (60 × 10) donne 600 : il faut bien diviser.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('038b0dea-5314-507b-813a-73e5699233d9', '01a46421-8763-5bd9-8898-af99bcccb771', 'Un corps de masse 4 kg a un poids de 39,2 N à Tunis. Quelle est l''intensité de la pesanteur g à Tunis ?', '[{"id":"a","text":"0,1 N·kg⁻¹"},{"id":"b","text":"9,8 N·kg⁻¹"},{"id":"c","text":"35,2 N·kg⁻¹"},{"id":"d","text":"156,8 N·kg⁻¹"}]'::jsonb, 'b', 'De P = m × g on tire g = P/m = 39,2/4 = 9,8 N·kg⁻¹ ✓. Inverser (4/39,2) donne 0,1 ; soustraire (39,2 − 4) donne 35,2 ; multiplier (39,2 × 4) donne 156,8.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f2e54830-da42-5888-96e4-c07be773fc36', '220d0f57-1bc2-534e-83f9-a77d72422212', 'physique-1ere-sec', 'Test de compréhension ⭐ : Forces et équilibre', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('0acc1aaa-50bd-5227-b6f3-606cffc83c9b', 'f2e54830-da42-5888-96e4-c07be773fc36', 'Un solide soumis à deux forces est en équilibre. Ces deux forces sont...', '[{"id":"a","text":"de même sens"},{"id":"b","text":"perpendiculaires"},{"id":"c","text":"de même point d''application"},{"id":"d","text":"directement opposées"}]'::jsonb, 'd', 'À l''équilibre, deux forces sont directement opposées ✓ : même droite d''action, sens contraires, même intensité (F1 + F2 = 0). Des forces de même sens ou perpendiculaires ne se compenseraient pas.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('963d254c-722e-5418-b40d-3a95a902eb39', 'f2e54830-da42-5888-96e4-c07be773fc36', 'En quelle unité s''exprime la constante de raideur k d''un ressort ?', '[{"id":"a","text":"En newton (N)"},{"id":"b","text":"En N·m⁻¹"},{"id":"c","text":"En mètre (m)"},{"id":"d","text":"En kilogramme (kg)"}]'::jsonb, 'b', 'La constante de raideur s''exprime en newton par mètre (N·m⁻¹) ✓, car dans T = k × Δl une force (N) est le produit de k par une longueur (m). Le newton seul est l''unité de la tension T, pas de k.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8f26dcbd-6d05-53ea-ba38-757332de4c51', 'f2e54830-da42-5888-96e4-c07be773fc36', 'Quand deux corps A et B interagissent, la force de A sur B et la force de B sur A sont...', '[{"id":"a","text":"directement opposées"},{"id":"b","text":"de même sens"},{"id":"c","text":"toutes les deux nulles"},{"id":"d","text":"perpendiculaires"}]'::jsonb, 'a', 'D''après le principe d''interaction (3ème loi de Newton), F(A/B) = −F(B/A) : les deux forces sont directement opposées ✓, de même intensité et de sens contraires. Elles ne sont ni de même sens, ni nulles.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0ccba164-785b-50e0-b4c6-ce2a2f0382c9', 'f2e54830-da42-5888-96e4-c07be773fc36', 'Un ressort de raideur k = 20 N·m⁻¹ est allongé de Δl = 0,1 m. Quelle est l''intensité de sa tension ?', '[{"id":"a","text":"0,2 N"},{"id":"b","text":"2 N"},{"id":"c","text":"20 N"},{"id":"d","text":"200 N"}]'::jsonb, 'b', 'T = k × Δl = 20 × 0,1 = 2 N ✓. Prendre Δl = 0,01 m donnerait 0,2 ; oublier l''allongement laisserait 20 ; se tromper d''un facteur 10 donnerait 200.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8f2998d6-458a-5afc-97a7-737c9672b10c', 'f2e54830-da42-5888-96e4-c07be773fc36', 'Un corps est suspendu à un fil et reste en équilibre. Que peut-on dire de la tension du fil par rapport au poids ?', '[{"id":"a","text":"La tension dépasse le poids"},{"id":"b","text":"La tension est nulle"},{"id":"c","text":"La tension a la même intensité que le poids"},{"id":"d","text":"La tension est plus faible que le poids"}]'::jsonb, 'c', 'À l''équilibre, la tension du fil et le poids sont directement opposés : ils ont la même intensité et des sens contraires ✓. Si la tension était plus grande, plus faible ou nulle, le corps ne resterait pas en équilibre.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('eace3946-a8d8-57e4-bdf2-304b8554ca26', '220d0f57-1bc2-534e-83f9-a77d72422212', 'physique-1ere-sec', '⭐ Exercice : Équilibre, tension et interaction', 1, 50, 10, 'practice', 'admin', 1)
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
  ('5fdcdc87-b278-5999-8041-89ac7e46a003', 'eace3946-a8d8-57e4-bdf2-304b8554ca26', 'Un corps est suspendu à un fil vertical et reste immobile. Dans quel sens la tension du fil est-elle dirigée ?', '[{"id":"a","text":"Vers le bas"},{"id":"b","text":"Vers le haut"},{"id":"c","text":"Horizontalement"},{"id":"d","text":"Vers la droite"}]'::jsonb, 'b', 'La tension du fil est dirigée vers le haut ✓, directement opposée au poids qui, lui, tire vers le bas. C''est ce qui empêche le corps de tomber.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f0848d8e-a7d0-526b-9987-8896ede66677', 'eace3946-a8d8-57e4-bdf2-304b8554ca26', 'Un livre posé sur une table horizontale reste en équilibre. Comment appelle-t-on la force que la table exerce sur lui ?', '[{"id":"a","text":"La réaction du plan"},{"id":"b","text":"Le poids"},{"id":"c","text":"La tension du fil"},{"id":"d","text":"La force musculaire"}]'::jsonb, 'a', 'La table exerce une réaction du plan ✓, dirigée vers le haut et directement opposée au poids du livre. Le poids, lui, est exercé par la Terre, pas par la table.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('32dd497b-23ce-5eab-b2f5-64dae9ad65cd', 'eace3946-a8d8-57e4-bdf2-304b8554ca26', 'Pour un ressort linéaire, comment la tension T est-elle reliée à l''allongement Δl ?', '[{"id":"a","text":"T = k + Δl"},{"id":"b","text":"T = Δl / k"},{"id":"c","text":"T = k × Δl"},{"id":"d","text":"T = k − Δl"}]'::jsonb, 'c', 'La loi de Hooke s''écrit T = k × Δl ✓ : la tension est proportionnelle à l''allongement, avec la constante de raideur k comme coefficient. Additionner, soustraire ou inverser ne donne pas la loi.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2e02eca7-9032-5891-802d-487202660784', 'eace3946-a8d8-57e4-bdf2-304b8554ca26', 'Au-delà d''un certain allongement, un ressort ne reprend plus sa forme initiale. On dit qu''on a dépassé...', '[{"id":"a","text":"la constante de raideur"},{"id":"b","text":"le point d''application"},{"id":"c","text":"la tension maximale"},{"id":"d","text":"la limite d''élasticité"}]'::jsonb, 'd', 'On a dépassé la limite d''élasticité ✓ : au-delà, le ressort reste déformé et la loi de Hooke ne s''applique plus. La constante de raideur k, elle, caractérise le ressort dans son domaine d''élasticité.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e3dbe365-d118-517e-9e5a-a28bcd25e5da', 'eace3946-a8d8-57e4-bdf2-304b8554ca26', 'À quoi sert un fil ou un ressort tendu entre deux corps ?', '[{"id":"a","text":"À transmettre une force d''une extrémité à l''autre"},{"id":"b","text":"À supprimer la force"},{"id":"c","text":"À doubler la force"},{"id":"d","text":"À changer la nature de la force"}]'::jsonb, 'a', 'Un fil ou un ressort tendu transmet à une extrémité la force reçue à l''autre extrémité ✓. Il ne supprime pas, ne double pas et ne transforme pas la force.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0915fdcb-7ad2-5fb0-a97b-f1b8c05bd8f6', 'eace3946-a8d8-57e4-bdf2-304b8554ca26', 'Pour un livre posé sur une table, la réaction du plan est directement opposée...', '[{"id":"a","text":"à la table elle-même"},{"id":"b","text":"au poids du livre"},{"id":"c","text":"à la tension d''un fil"},{"id":"d","text":"à aucune force"}]'::jsonb, 'b', 'La réaction du plan est directement opposée au poids du livre ✓ : c''est ce qui assure l''équilibre (les deux forces se compensent). Il n''y a pas de fil ici, donc pas de tension de fil en jeu.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('39cdd03b-2a64-535f-8689-e9ba39b780b1', '220d0f57-1bc2-534e-83f9-a77d72422212', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Loi de Hooke, équilibre et interaction', 2, 75, 15, 'practice', 'admin', 3)
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
  ('9eb1d9a6-4232-5963-a8ba-f5fc065334d1', '39cdd03b-2a64-535f-8689-e9ba39b780b1', 'Pour trouver expérimentalement le centre de gravité d''une plaque, on la suspend successivement par plusieurs de ses points et on trace la droite d''action du poids à chaque fois. Que fait-on de ces droites ?', '[{"id":"a","text":"On additionne leurs longueurs"},{"id":"b","text":"Leur point d''intersection est le centre de gravité"},{"id":"c","text":"On mesure leurs angles"},{"id":"d","text":"Elles n''ont aucun rapport avec G"}]'::jsonb, 'b', 'Toutes les droites d''action du poids se croisent en un même point : ce point d''intersection est le centre de gravité G ✓. C''est la méthode expérimentale pour le repérer, quelle que soit la forme de la plaque.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('be125d0c-b913-532c-b7e6-99b1879206c7', '39cdd03b-2a64-535f-8689-e9ba39b780b1', 'Un ressort s''allonge de Δl = 0,05 m sous une tension T = 3 N. Quelle est sa constante de raideur k ?', '[{"id":"a","text":"0,15 N·m⁻¹"},{"id":"b","text":"6 N·m⁻¹"},{"id":"c","text":"60 N·m⁻¹"},{"id":"d","text":"600 N·m⁻¹"}]'::jsonb, 'c', 'De T = k × Δl on tire k = T/Δl = 3/0,05 = 60 N·m⁻¹ ✓. Multiplier (3 × 0,05) donne 0,15 ; prendre Δl = 0,5 m donne 6 ; prendre Δl = 0,005 m donne 600.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c9c4ce49-17e8-5d48-a7c9-f9271423d335', '39cdd03b-2a64-535f-8689-e9ba39b780b1', 'La Terre attire une pomme (c''est son poids). D''après le principe d''interaction, la pomme exerce-t-elle une force sur la Terre ?', '[{"id":"a","text":"Non, la pomme n''exerce aucune force"},{"id":"b","text":"Oui, mais une force bien plus faible"},{"id":"c","text":"Oui, une force de même sens que le poids"},{"id":"d","text":"Oui, une force directement opposée, de même intensité"}]'::jsonb, 'd', 'Le principe d''interaction impose F(pomme/Terre) = −F(Terre/pomme) : la pomme attire la Terre avec une force de même intensité et de sens contraire ✓. Cette force ne déplace pas la Terre à cause de son énorme masse, mais elle existe bel et bien.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ff7892dc-6d19-505d-87bd-2bf5022e3bf2', '39cdd03b-2a64-535f-8689-e9ba39b780b1', 'Un corps de masse 2 kg est suspendu à un fil et reste en équilibre (g = 10 N·kg⁻¹). Quelle est l''intensité de la tension du fil ?', '[{"id":"a","text":"0,2 N"},{"id":"b","text":"12 N"},{"id":"c","text":"20 N"},{"id":"d","text":"200 N"}]'::jsonb, 'c', 'À l''équilibre, la tension égale le poids : T = P = m × g = 2 × 10 = 20 N ✓. Additionner (2 + 10) donne 12 ; se tromper de facteur donne 0,2 ou 200. La tension équilibre exactement le poids.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5607e522-2fde-5492-91fc-96889abe8e11', '39cdd03b-2a64-535f-8689-e9ba39b780b1', 'Un solide accroché à un ressort de raideur k = 20 N·m⁻¹ l''allonge de Δl = 0,05 m à l''équilibre (g = 10 N·kg⁻¹). Quelle est la masse du solide ?', '[{"id":"a","text":"0,1 kg"},{"id":"b","text":"1 kg"},{"id":"c","text":"2 kg"},{"id":"d","text":"10 kg"}]'::jsonb, 'a', 'La tension du ressort équilibre le poids. D''abord T = k × Δl = 20 × 0,05 = 1 N, puis T = P = m × g donne m = T/g = 1/10 = 0,1 kg ✓. Oublier de diviser par g laisserait 1 kg.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8b2af84e-f3d3-5726-9816-15c94f4e4572', '39cdd03b-2a64-535f-8689-e9ba39b780b1', 'Un dynamomètre est fait d''un ressort de raideur k = 25 N·m⁻¹. De quel allongement se déforme-t-il sous une force de 5 N ?', '[{"id":"a","text":"0,2 m"},{"id":"b","text":"5 m"},{"id":"c","text":"30 m"},{"id":"d","text":"125 m"}]'::jsonb, 'a', 'De T = k × Δl on tire Δl = T/k = 5/25 = 0,2 m ✓ (soit 20 cm). Garder la force comme longueur donne 5 ; additionner (5 + 25) donne 30 ; multiplier (5 × 25) donne 125.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('c677f7e6-a95c-55ed-92d2-5bc598dd6840', '7c2390d8-5766-59ff-a691-f015bda6c442', 'physique-1ere-sec', 'Test de compréhension ⭐ : Forces et pression', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('5ec04184-7ca2-5598-a726-06b6f2612fcb', 'c677f7e6-a95c-55ed-92d2-5bc598dd6840', 'La force pressante s''exerce sur la surface pressée...', '[{"id":"a","text":"parallèlement à elle"},{"id":"b","text":"en un seul point"},{"id":"c","text":"dans toutes les directions"},{"id":"d","text":"perpendiculairement (normale) à elle"}]'::jsonb, 'd', 'La force pressante est normale, c''est-à-dire perpendiculaire, à la surface pressée ✓, et elle agit uniformément sur toute cette surface. Elle n''est ni parallèle, ni ponctuelle.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('34c3b5c8-a317-5d9f-a729-771393a267a7', 'c677f7e6-a95c-55ed-92d2-5bc598dd6840', 'Comment la pression p est-elle reliée à la force pressante F et à l''aire s de la surface pressée ?', '[{"id":"a","text":"p = F × s"},{"id":"b","text":"p = F/s"},{"id":"c","text":"p = F + s"},{"id":"d","text":"p = s/F"}]'::jsonb, 'b', 'La pression est le quotient de l''intensité de la force pressante par l''aire de la surface pressée : p = F/s ✓. Multiplier ou additionner ne donne pas une pression, et inverser (s/F) est faux.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6897c10e-4ea4-543e-9d9f-8635e7e4cc9b', 'c677f7e6-a95c-55ed-92d2-5bc598dd6840', 'Dans quelle unité s''exprime la pression dans le Système international ?', '[{"id":"a","text":"le newton (N)"},{"id":"b","text":"le mètre carré (m²)"},{"id":"c","text":"le pascal (Pa)"},{"id":"d","text":"le kilogramme (kg)"}]'::jsonb, 'c', 'La pression s''exprime en pascal, de symbole Pa ✓. Le newton est l''unité de la force pressante F, le mètre carré celle de la surface pressée s.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c6e15392-4616-5f43-98b3-f11974327502', 'c677f7e6-a95c-55ed-92d2-5bc598dd6840', 'À force pressante égale, comment varie la pression quand la surface pressée diminue ?', '[{"id":"a","text":"elle augmente"},{"id":"b","text":"elle diminue"},{"id":"c","text":"elle reste la même"},{"id":"d","text":"elle devient nulle"}]'::jsonb, 'a', 'Dans p = F/s, si F reste constant et que s diminue, le quotient augmente : la pression augmente ✓. C''est pourquoi une lame fine, à même effort, coupe mieux.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('aad7a298-cc71-56a6-ab12-31dc14010602', 'c677f7e6-a95c-55ed-92d2-5bc598dd6840', 'Une force pressante F = 100 N s''exerce sur une surface pressée s = 0,5 m². Quelle est la pression ?', '[{"id":"a","text":"50 Pa"},{"id":"b","text":"100 Pa"},{"id":"c","text":"200 Pa"},{"id":"d","text":"500 Pa"}]'::jsonb, 'c', 'p = F/s = 100/0,5 = 200 Pa ✓. Multiplier (100 × 0,5) donnerait 50 ; oublier la surface laisserait 100 ; se tromper d''un facteur donnerait 500.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('26157329-4219-5520-a338-1c7479dc99be', '7c2390d8-5766-59ff-a691-f015bda6c442', 'physique-1ere-sec', '⭐ Exercice : Force pressante et pression', 1, 50, 10, 'practice', 'admin', 1)
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
  ('a2614ae7-b99c-5657-bf2d-ba30898e7ef5', '26157329-4219-5520-a338-1c7479dc99be', 'Un livre posé sur une table horizontale transmet à celle-ci...', '[{"id":"a","text":"rien du tout"},{"id":"b","text":"seulement de la chaleur"},{"id":"c","text":"son poids, l''action que la Terre exerce sur lui"},{"id":"d","text":"sa couleur"}]'::jsonb, 'c', 'Un solide transmet à son support toute action qu''il subit ; le livre transmet donc à la table l''action que la Terre exerce sur lui, c''est-à-dire son poids ✓.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('02c3c751-4c1c-5ef4-857b-45113ebdd2be', '26157329-4219-5520-a338-1c7479dc99be', 'Comment appelle-t-on la surface de contact entre le corps qui presse et le corps pressé ?', '[{"id":"a","text":"la surface pressante"},{"id":"b","text":"la surface pressée"},{"id":"c","text":"la base de gravité"},{"id":"d","text":"la surface libre"}]'::jsonb, 'b', 'La surface de contact sur laquelle s''exerce la force pressante est la surface pressée, notée s ✓. C''est son aire qui intervient dans le calcul de la pression.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('acc60f52-f51e-574b-97b3-210d682c1de6', '26157329-4219-5520-a338-1c7479dc99be', 'Quelle grandeur physique mesure l''effet d''une force répartie selon la surface sur laquelle elle agit ?', '[{"id":"a","text":"la vitesse"},{"id":"b","text":"la température"},{"id":"c","text":"la pression"},{"id":"d","text":"la masse"}]'::jsonb, 'c', 'C''est la pression p = F/s qui caractérise cet effet ✓ : elle relie l''intensité de la force pressante à l''aire de la surface pressée.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f4d398e6-96d4-5eb4-b42f-0e87db1db23b', '26157329-4219-5520-a338-1c7479dc99be', 'Parmi ces objets, lequel est conçu pour exercer une forte pression ?', '[{"id":"a","text":"un ski"},{"id":"b","text":"une raquette à neige"},{"id":"c","text":"une large semelle"},{"id":"d","text":"une aiguille pointue"}]'::jsonb, 'd', 'Une pointe fine offre une très petite surface pressée : à force égale, p = F/s est alors très grande ✓. Skis, raquettes et larges semelles font l''inverse (grande surface → faible pression).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('110389f6-e92e-58b3-b3ed-83e88f6ac9c5', '26157329-4219-5520-a338-1c7479dc99be', 'Pourquoi chausse-t-on des skis pour marcher sur la neige sans trop s''enfoncer ?', '[{"id":"a","text":"pour augmenter la surface d''appui et réduire la pression"},{"id":"b","text":"pour augmenter son poids"},{"id":"c","text":"pour annuler la force pressante"},{"id":"d","text":"pour durcir la neige"}]'::jsonb, 'a', 'Les skis répartissent le poids sur une grande surface : la pression p = F/s diminue et on s''enfonce moins ✓. Le poids, lui, ne change pas.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('77db3ae9-4ff0-5fa2-a35c-f45341cdb351', '26157329-4219-5520-a338-1c7479dc99be', 'Combien vaut 1 bar exprimé en pascals ?', '[{"id":"a","text":"1 Pa"},{"id":"b","text":"10² Pa"},{"id":"c","text":"10³ Pa"},{"id":"d","text":"10⁵ Pa"}]'::jsonb, 'd', '1 bar = 10⁵ Pa ✓. C''est 10² Pa (soit 100 Pa) qui correspond à 1 millibar.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('961454a0-bb36-53da-88aa-83310d305e36', '7c2390d8-5766-59ff-a691-f015bda6c442', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Calculs de pression', 2, 75, 15, 'practice', 'admin', 3)
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
  ('ca4461a8-889e-5407-9ef3-ee740663376b', '961454a0-bb36-53da-88aa-83310d305e36', 'Un corps exerce une force pressante F = 60 N sur une surface pressée s = 0,2 m². Quelle est la pression ?', '[{"id":"a","text":"12 Pa"},{"id":"b","text":"30 Pa"},{"id":"c","text":"300 Pa"},{"id":"d","text":"3000 Pa"}]'::jsonb, 'c', 'p = F/s = 60/0,2 = 300 Pa ✓. Multiplier (60 × 0,2) donnerait 12 ; se tromper d''un facteur 10 donnerait 30 ou 3000.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a27d458d-ea7c-57b8-8864-ff61d358508e', '961454a0-bb36-53da-88aa-83310d305e36', 'Une pression p = 200 Pa s''exerce sur une surface pressée s = 0,5 m². Quelle est l''intensité de la force pressante F ?', '[{"id":"a","text":"100 N"},{"id":"b","text":"200 N"},{"id":"c","text":"400 N"},{"id":"d","text":"1000 N"}]'::jsonb, 'a', 'De p = F/s on tire F = p × s = 200 × 0,5 = 100 N ✓. Diviser (200/0,5) donnerait 400 ; garder p seul laisserait 200.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('414e6063-5fad-5fd2-aa9e-515e32a8683c', '961454a0-bb36-53da-88aa-83310d305e36', 'Deux briques identiques sont posées sur du sable : la brique (A) sur sa grande face, la brique (B) sur sa petite face. Laquelle exerce la plus grande pression sur le sable ?', '[{"id":"a","text":"la brique (A), sur sa grande face"},{"id":"b","text":"la brique (B), sur sa petite face"},{"id":"c","text":"les deux exercent la même pression"},{"id":"d","text":"aucune n''exerce de pression"}]'::jsonb, 'b', 'Les deux briques ont le même poids, donc la même force pressante ; mais (B) s''appuie sur une plus petite surface, donc p = F/s est plus grande pour elle ✓. C''est elle qui s''enfonce le plus.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5c695327-48d4-55d0-b61e-4444e0652fb8', '961454a0-bb36-53da-88aa-83310d305e36', 'Pourquoi pose-t-on de larges traverses sous les rails d''une voie ferrée ?', '[{"id":"a","text":"pour augmenter le poids des trains"},{"id":"b","text":"pour faire rouler les trains plus vite"},{"id":"c","text":"pour répartir le poids sur une grande surface et réduire la pression sur le sol"},{"id":"d","text":"pour augmenter la force pressante sur le sol"}]'::jsonb, 'c', 'Les traverses augmentent la surface d''appui des rails : la pression exercée sur le ballast et le sol diminue, ce qui évite l''enfoncement ✓. Le poids des convois, lui, ne change pas.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0cccfb77-6c60-51b5-9183-9d7300c5b11f', '961454a0-bb36-53da-88aa-83310d305e36', 'Une pression vaut 3 bars. Combien cela fait-il en pascals ?', '[{"id":"a","text":"3 Pa"},{"id":"b","text":"300 Pa"},{"id":"c","text":"30 000 Pa"},{"id":"d","text":"300 000 Pa"}]'::jsonb, 'd', '1 bar = 10⁵ Pa, donc 3 bars = 3 × 10⁵ = 300 000 Pa ✓. Confondre le bar avec le millibar (10² Pa) donnerait 300 Pa.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('508c5cf8-db5b-5cea-abcb-301549d771f9', '961454a0-bb36-53da-88aa-83310d305e36', 'Un solide de poids P = 50 N est posé sur le sol par une face carrée de côté 0,5 m. Quelle pression exerce-t-il sur le sol ?', '[{"id":"a","text":"100 Pa"},{"id":"b","text":"200 Pa"},{"id":"c","text":"250 Pa"},{"id":"d","text":"1000 Pa"}]'::jsonb, 'b', 'La surface pressée est le carré de côté 0,5 m, soit s = 0,5 × 0,5 = 0,25 m². La force pressante égale le poids, donc p = P/s = 50/0,25 = 200 Pa ✓. Oublier d''élever le côté au carré (prendre s = 0,5) donnerait 100.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('60914d60-5103-585b-9e66-9dfbc2559cf0', '4d0448ec-57fd-5c08-9d6a-3c97976068e8', 'physique-1ere-sec', 'Test de compréhension ⭐ : Énergie et contrôle', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('db41d726-e208-5b84-993d-bc94801a3d9b', '60914d60-5103-585b-9e66-9dfbc2559cf0', 'Parmi ces sources d''énergie, laquelle est renouvelable ?', '[{"id":"a","text":"le charbon"},{"id":"b","text":"le pétrole"},{"id":"c","text":"l''uranium"},{"id":"d","text":"le Soleil"}]'::jsonb, 'd', 'Le Soleil produit de l''énergie de manière relativement illimitée : c''est une source renouvelable ✓. Le charbon, le pétrole et l''uranium sont épuisables, donc non renouvelables.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('501dc4fb-c0b7-55ca-9e99-2fb1455f0f1c', '60914d60-5103-585b-9e66-9dfbc2559cf0', 'L''énergie totale d''un système est la somme de son énergie mécanique et de son énergie...', '[{"id":"a","text":"microscopique"},{"id":"b","text":"électrique"},{"id":"c","text":"solaire"},{"id":"d","text":"musculaire"}]'::jsonb, 'a', 'L''énergie totale = énergie mécanique (macroscopique) + énergie microscopique ✓, cette dernière regroupant l''énergie thermique, chimique et nucléaire.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('418a6f7d-f3a0-54d5-94e3-b036606d7cca', '60914d60-5103-585b-9e66-9dfbc2559cf0', 'Comment appelle-t-on un objet qui transforme une forme d''énergie en une autre ?', '[{"id":"a","text":"un isolant"},{"id":"b","text":"un conducteur"},{"id":"c","text":"un convertisseur d''énergie"},{"id":"d","text":"un calorimètre"}]'::jsonb, 'c', 'Un convertisseur d''énergie transforme une forme d''énergie en une autre ✓ (par exemple un moteur transforme l''énergie électrique en énergie mécanique).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('207ad235-720d-5093-be5b-7fffd3bfb8f1', '60914d60-5103-585b-9e66-9dfbc2559cf0', 'Entre deux corps en contact, la chaleur passe spontanément...', '[{"id":"a","text":"du corps froid vers le corps chaud"},{"id":"b","text":"du corps chaud vers le corps froid"},{"id":"c","text":"dans les deux sens de façon égale"},{"id":"d","text":"seulement dans le vide"}]'::jsonb, 'b', 'La chaleur est un transfert d''énergie qui s''effectue spontanément du corps chaud vers le corps froid ✓, par conduction ou par convection.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8b11944d-a240-5e16-a0b1-2982e56bdf4f', '60914d60-5103-585b-9e66-9dfbc2559cf0', 'Dans quelle unité mesure-t-on une variation d''énergie ΔE ?', '[{"id":"a","text":"le watt (W)"},{"id":"b","text":"le degré Celsius (°C)"},{"id":"c","text":"le joule (J)"},{"id":"d","text":"le newton (N)"}]'::jsonb, 'c', 'La variation d''énergie ΔE s''exprime dans le Système international en joule, de symbole J ✓. Le degré Celsius mesure une température, pas une énergie.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ba3ba71d-71a3-5fa1-bfee-1e54cb7ca45d', '4d0448ec-57fd-5c08-9d6a-3c97976068e8', 'physique-1ere-sec', '⭐ Exercice : Sources, formes et transferts d''énergie', 1, 50, 10, 'practice', 'admin', 1)
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
  ('653406ea-31f4-55e1-8460-fdd8b187980e', 'ba3ba71d-71a3-5fa1-bfee-1e54cb7ca45d', 'Parmi ces sources d''énergie, laquelle est non renouvelable (épuisable) ?', '[{"id":"a","text":"le vent"},{"id":"b","text":"les marées"},{"id":"c","text":"la géothermie"},{"id":"d","text":"le gaz naturel"}]'::jsonb, 'd', 'Le gaz naturel disparaît peu à peu à mesure qu''on l''utilise : c''est une source non renouvelable ✓. Le vent, les marées et la géothermie sont renouvelables.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f28283ef-15ea-504d-bd3a-e81d6d0add6f', 'ba3ba71d-71a3-5fa1-bfee-1e54cb7ca45d', 'L''énergie thermique d''un corps fait partie de son énergie...', '[{"id":"a","text":"microscopique"},{"id":"b","text":"mécanique"},{"id":"c","text":"macroscopique"},{"id":"d","text":"de mouvement d''ensemble"}]'::jsonb, 'a', 'L''énergie thermique est liée à l''agitation des particules : c''est une énergie microscopique ✓, distincte de l''énergie mécanique (macroscopique).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9a96c23b-19eb-58af-9764-6763aa1d3201', 'ba3ba71d-71a3-5fa1-bfee-1e54cb7ca45d', 'Une génératrice de bicyclette transforme l''énergie du mouvement en énergie électrique. C''est donc...', '[{"id":"a","text":"un isolant thermique"},{"id":"b","text":"un convertisseur d''énergie"},{"id":"c","text":"une source non renouvelable"},{"id":"d","text":"une enceinte adiabatique"}]'::jsonb, 'b', 'Elle transforme une forme d''énergie (mécanique) en une autre (électrique) : c''est un convertisseur d''énergie ✓.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4b37f4b0-7161-55c4-a5ff-d2c820ff2c53', 'ba3ba71d-71a3-5fa1-bfee-1e54cb7ca45d', 'On chauffe une tige métallique à une extrémité : la chaleur se propage de proche en proche, sans déplacement de matière. Ce mode de transfert s''appelle...', '[{"id":"a","text":"la convection"},{"id":"b","text":"le rayonnement"},{"id":"c","text":"la conduction"},{"id":"d","text":"le travail mécanique"}]'::jsonb, 'c', 'La conduction propage la chaleur de proche en proche sans transport de matière ✓. La convection, elle, transporte la chaleur en déplaçant la matière.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('359ba898-216f-53bd-9b32-3e0d35715228', 'ba3ba71d-71a3-5fa1-bfee-1e54cb7ca45d', 'Comment appelle-t-on une enceinte qui empêche tout échange de chaleur avec l''extérieur ?', '[{"id":"a","text":"une enceinte adiabatique (calorifugée)"},{"id":"b","text":"un convertisseur d''énergie"},{"id":"c","text":"un bon conducteur thermique"},{"id":"d","text":"une source d''énergie"}]'::jsonb, 'a', 'Une enceinte adiabatique, ou calorifugée, réalise une isolation thermique ✓ : c''est le principe du calorimètre et de la bouteille thermos.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f8f25db6-f3d3-51ac-ada2-81cebdeeccfd', 'ba3ba71d-71a3-5fa1-bfee-1e54cb7ca45d', 'Par opposition à la chaleur, le travail est un mode de transfert d''énergie dit...', '[{"id":"a","text":"désordonné"},{"id":"b","text":"ordonné"},{"id":"c","text":"impossible"},{"id":"d","text":"renouvelable"}]'::jsonb, 'b', 'Le travail est un transfert ordonné d''énergie, alors que la chaleur est un transfert désordonné ✓.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('19cd0107-12e5-5d0a-9ec1-c4957d482013', '4d0448ec-57fd-5c08-9d6a-3c97976068e8', 'physique-1ere-sec', '⭐⭐ Révision (type examen) : Conversions et transferts d''énergie', 2, 75, 15, 'practice', 'admin', 3)
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
  ('502c0a2d-35d6-563a-bd0f-2d1b383448fb', '19cd0107-12e5-5d0a-9ec1-c4957d482013', 'Parmi ces sources d''énergie, laquelle est renouvelable ?', '[{"id":"a","text":"le charbon"},{"id":"b","text":"l''uranium"},{"id":"c","text":"les marées"},{"id":"d","text":"le pétrole"}]'::jsonb, 'c', 'Les marées produisent de l''énergie de manière illimitée : c''est une source renouvelable ✓. Le charbon, l''uranium et le pétrole sont épuisables.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bf4ac9bc-144e-5b65-8d07-a798cf33b153', '19cd0107-12e5-5d0a-9ec1-c4957d482013', 'Une cellule photovoltaïque reçoit l''énergie du Soleil, puis la transforme en énergie électrique. Par quel mode le Soleil lui transfère-t-il cette énergie ?', '[{"id":"a","text":"le travail rayonnant (WR)"},{"id":"b","text":"le travail mécanique (WM)"},{"id":"c","text":"la chaleur (Q) par conduction"},{"id":"d","text":"le travail électrique (WE)"}]'::jsonb, 'a', 'L''énergie du Soleil parvient à la cellule par rayonnement, c''est-à-dire par travail rayonnant WR ✓. La cellule est alors le convertisseur qui la transforme en énergie électrique.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1600b2b1-4d62-58ca-8def-4c56d0a51aaf', '19cd0107-12e5-5d0a-9ec1-c4957d482013', 'Dans un liquide chauffé par le bas, les parties chaudes montent et les parties froides descendent, transportant la chaleur. Ce mode de transfert est...', '[{"id":"a","text":"la conduction"},{"id":"b","text":"la convection"},{"id":"c","text":"le rayonnement"},{"id":"d","text":"le travail électrique"}]'::jsonb, 'b', 'Ici la chaleur est transportée par le déplacement de la matière (le liquide qui circule) : c''est la convection ✓, à ne pas confondre avec la conduction (sans déplacement de matière).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ed88ac33-ff75-5ae8-af12-748fdd054874', '19cd0107-12e5-5d0a-9ec1-c4957d482013', 'Que peut-on dire de la chaleur et de la température ?', '[{"id":"a","text":"ce sont deux noms de la même grandeur"},{"id":"b","text":"la température se mesure en joule"},{"id":"c","text":"la chaleur se mesure en degrés Celsius"},{"id":"d","text":"la chaleur est un transfert d''énergie (en joule), la température renseigne sur l''agitation des particules"}]'::jsonb, 'd', 'La chaleur est un transfert d''énergie, mesuré en joule ; la température (en degrés Celsius) renseigne sur l''agitation thermique des particules ✓. Ce sont deux grandeurs différentes.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('421af3b3-d7fd-500f-a1b9-6cb80f7f3141', '19cd0107-12e5-5d0a-9ec1-c4957d482013', 'Un radiateur électrique branché sur le secteur chauffe une pièce. Quels modes de transfert interviennent, dans l''ordre ?', '[{"id":"a","text":"travail électrique (secteur → radiateur), puis chaleur (radiateur → pièce)"},{"id":"b","text":"chaleur (secteur → radiateur), puis travail mécanique (radiateur → pièce)"},{"id":"c","text":"travail mécanique (secteur → radiateur), puis rayonnement (radiateur → pièce)"},{"id":"d","text":"rayonnement (secteur → radiateur), puis travail électrique (radiateur → pièce)"}]'::jsonb, 'a', 'Le secteur transfère l''énergie au radiateur par travail électrique ; le radiateur la cède ensuite à la pièce par chaleur (et rayonnement) ✓. Le radiateur est le convertisseur.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('584274f6-ddf8-5926-9524-184d9f91e6a0', '19cd0107-12e5-5d0a-9ec1-c4957d482013', 'Une facture d''électricité compte l''énergie en kilowattheures (kWh), avec 1 kWh = 3,6×10⁶ J. À combien de joules correspondent 2 kWh ?', '[{"id":"a","text":"1,8×10⁶ J"},{"id":"b","text":"3,6×10⁶ J"},{"id":"c","text":"7,2×10⁶ J"},{"id":"d","text":"7,2×10³ J"}]'::jsonb, 'c', '2 kWh = 2 × 3,6×10⁶ = 7,2×10⁶ J ✓. Diviser par 2 donnerait 1,8×10⁶ ; oublier le facteur 2 laisserait 3,6×10⁶.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
      AND e.subject_id = 'physique-1ere-sec'
      AND e.source = 'admin';
  END IF;
END $$;

