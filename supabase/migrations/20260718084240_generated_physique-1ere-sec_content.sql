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
  ('physique-1ere-sec', 'Sciences Physiques', 'L''électricité et la matière selon le programme officiel de la 1ère année de l''enseignement secondaire (tronc commun) : le phénomène d''électrisation, le circuit électrique, l''intensité et la tension électriques, le dipôle résistor et la loi d''Ohm ; puis les états physiques de la matière, ses propriétés (dilatation, température, conductivité thermique) et la masse (masse volumique, densité)', 'Observation', 'subject-svt', 'Atom', 2, 'fr', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '1ere-sec'), NULL)
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
      AND q.id NOT IN ('cd81dc68-012d-5b7b-933f-d7435246ca21', 'a86d19a9-30d9-5c8d-90d6-d731fd8c3612', 'ba093546-03bb-5f48-b5ab-332a4678ebf6', '4020c7c3-42ec-5666-ac02-4a7c928298c3', '01ce9519-615d-5193-a9ed-164d0b5a072d', 'd08bd409-bb8d-5a8c-95ab-629c0f9a422f', '2ce36be3-6e4b-52b3-9a1d-7c7f54a6cc84', '51ce21a3-3dd2-5c6f-b861-402f5aafaba0', '2058a83d-ec8d-53f0-861d-a626c400a934', 'bef91dee-3629-5e84-bade-c7522a85fb50', 'bbba134a-f585-5325-9050-883b9fced6ef', '680466e0-720b-5f2b-b901-9d1549225955', '65d44468-4c57-58f6-988e-b41cffdbf06d', '0be8d0a3-98bf-5aa1-89f0-997374ec0922', 'c5fa6f99-06bd-5072-b7c7-c1fe9ec69f4b', '719be2dd-43e5-5a01-9a87-5d3229436d1e', '16fbe64e-9ed9-504b-a6f4-97bcad3e4d60', '593f42be-93b1-539f-9322-a8d575e1a230', 'e471922a-f642-51a7-bb9e-033148f07ab8', 'e6ae6bc1-5f41-5427-8663-966a9f69011b', '3219b52c-4050-536e-a787-d88a78e20a56', '16e4af28-858b-50dd-ab76-15ff08bd3a3d', 'd1eb1423-8c01-5eb0-8f4e-6fcdc490e7bd', 'f06ec153-9a5d-5921-8cee-ee4bc8f28a6d', 'eaded567-35c8-5e33-8c78-4390a0158224', 'c7701a6d-c3a4-5c3c-b9ec-c7924b005f9c', 'ea325711-a531-5ac4-820b-d0830db1e4e8', '84b39c4c-c1a9-5e1a-985c-e0b77e47b62e', '296021ad-7e08-546c-9dbe-aaae56fd29e9', 'e4d55829-3d13-5138-81d0-18c228a57299', '7facd2a5-4bfd-50c2-a843-4959d28528c5', '58838187-63ac-5d6a-94ec-0ebfe67c6383', '485bc1fd-849e-5f84-88cc-38034411f189', '2cbc3e67-cbb2-5fb2-b5cc-573c046492d3', '03340da1-e134-5d23-a6da-4fa8758f7d93', '2b5f857f-c66f-5e1b-9b81-2512f2bf448c', 'f965d026-c959-5dbb-959a-627734428969', 'd58ee35d-e22e-5253-8bb6-4d3968cf2c9f', '64fb427c-c19f-5c39-8663-1d3598b6b47c', 'aa3e6731-bb22-52b1-b36b-b65c012e3b3b', '8720ecf5-db88-5cdc-a041-489b34b363fa', '8b561a76-af87-55be-900d-790038fa5101', '1d07fd26-fb3d-5bf3-9d73-672be638bbfe', 'fdfff668-8cea-5ba3-a664-5e4c24672e98', 'b79494b4-f612-5930-96f7-f80616f6d462', '47981fe7-4f66-5600-afc6-e076e535b7f8', 'eaf88d4d-6b20-5533-a3ce-591bdc9a7900', '0a38a704-d473-5ac3-b4c7-993995d4c29f', '53189c58-507c-56b7-903b-5aecf00ddb48', 'afff4689-031e-56c8-a4bc-a1bea114a14f', 'eeb1aad5-2c6c-50ae-b230-7ca3785764ee', '209983c0-a5b5-5ec3-984e-d29485e28584', '9007d29d-5aa2-5acb-8b20-465475a1ca4d', 'a45667e8-3ab4-54a0-84b4-11b6aa63abdc', '49bf1bda-7235-598d-9788-41f843be864f', 'd431ec8e-8e26-519f-9b15-c24355ed386c', 'a9df8c0b-d628-5ba4-bf5b-0e5b19f805c2', '5b30ac05-ab65-506e-87b6-14e9d6915203', '89ad05de-c572-5581-9325-79a511f17280', '42cbe483-f5da-5c86-88f4-ff14087d8c9c', '21a2da4a-2ccb-57b7-9d1e-64ba4003707b', 'faf9e844-3874-512b-9c3f-7d79e45bd9fe', '8104cc1a-7645-50e1-b7e2-04987db22904', '783d5c76-c42e-5890-9687-67972acd4c70', 'eabf0b7c-56ce-5ef5-a814-1e2e3a3d4613', 'f9c848cd-7dd1-55a0-abff-39fbe5b7f2be', '8fe13c74-52fb-538c-bc1e-d6e131b933a3', 'f6ca22d5-58c4-59e1-b026-5e8a9156bfd5', '8c7567b0-ac54-50ff-841a-32c5e7cd0b83', '0908c2c0-30b4-5855-b726-14ba7fbdb2d7', 'c0217e65-f239-55aa-a831-38a8c11c7a32', 'ce94ce9e-22ab-53dc-a639-6914ba5d7c48', 'f2948742-e856-5312-a4c4-94e961c453cd', 'f2c9f793-58b3-5608-9ef1-9822c13489cf', '71335a8b-4bcf-5a1a-9506-df483e881db2', '32a4e4ff-cb39-5a0f-abb0-280ceffb76b1', '20b0c8ec-40b0-593d-8296-7ca351414023', 'e432b93c-7430-5d50-a3d4-d8e3958391ca', 'f5db2d0c-d850-5039-bfa5-035d1b3b71ba', '4993eff6-9020-5a3e-bdf3-2376e4d0549e', 'e811528a-a241-56fc-a45b-914b217d25e1', 'c2ffa223-7429-560b-9077-67c135a8cb36', '60c4fc30-c54c-5450-802a-95639ccb4945', 'add45e24-fff3-506b-9133-053dd2ae80c3', '2fcb7236-95ac-5676-aa39-df0bb85ff409', '25217386-51db-5e5e-bdc6-0b74467b5ea5', 'abc07094-845e-5b5b-98b6-6dfdf42d1bfe', '671a0763-76ea-516c-b5e0-93363e15b1f0', 'f222edc4-95c0-5c44-ad24-0926e0d7c608', '5eefd557-3a06-5882-abfc-8eecaa9e8c0c', '7cafe90a-730f-5a2d-b90c-d9b0ae44da95', 'd0f28444-ef0a-5d09-bd3f-976e941a5951', 'ae69b3f1-142d-5727-af35-f2061a87bf1a', 'f254c2d6-77d2-5b05-b3ee-8d47bb45418a', '36a7acf2-fb31-539a-9c16-1c54b094e302', '7fa903cb-2892-5e30-a204-5955bd68e873', '9ece779e-0e45-5a9d-8825-a112d328cf42', 'e3efc622-cd7b-5914-971c-fd2bc0af9bbd', '61a6a809-b368-5682-a878-5df72a0ffd6c', 'a0479655-43aa-551a-aabc-8bb6a0ccf566', 'c61b00a6-b4d6-5ebd-8fc1-271594a559b0', '0a18a7a3-5b30-5e16-ac86-5579b6571c38', '4e48535a-8747-5264-8460-6055c9dc55cc', '9544663c-43ec-5fb0-9050-a8b7e49ea42f', '7168b5a2-cf82-5029-b45b-e71c258083f9', '4579525f-f116-5a0f-8166-a9358fc74f60', '79b10bca-3e49-569a-83e9-ea426f3e017f', 'f36da336-ef77-5cee-8c64-2b7e75504968', 'becb03c1-56f3-579c-a1c2-f73cfc84c3f8', '9405bc80-f2a0-5785-8204-09e75334d255', '21a14880-73c3-559f-85ee-e648ffd4adce', 'cbac5a2f-a278-52db-88d6-f4738159afe4', '0a8fd254-8e16-5bc5-8de0-5c81d8a439d0', '13b192cd-1882-517c-8f58-de9373d34408', '0d230c63-a295-5db4-839e-c8ea8f906084', '8dee3edb-15e8-5c37-909f-7ee2fa31ab76', '943e8084-af94-5be6-bf4a-33c7b64a20e3', '048d6a99-dfe1-5fef-a69b-014bd28e8db4', '81cbfde1-78f7-510e-af9b-8a39c60ef5b9', '901088c7-9fe6-5ab7-a2da-4bdc1cb7c126', '46c842ff-b964-514f-a585-1d21701968b9', 'c517d5ee-f0f0-5125-b38b-aa31317e87f7', 'b48ed0de-81ef-58f3-acda-c93765aa77e1', 'a2144baa-d3b9-5eaa-9fed-0516b67c34e1', '696c3ec0-a0be-5639-90da-2ccd62f57503', '86ed9c43-ea7c-512b-8cd4-669e3e8ac507', '968b920e-58de-516c-85c7-5a0212720e84', 'cad32dbd-ea52-592a-9e91-01cb2ea95e34', '0a57dbcd-4898-593e-b517-d86efdb83065', 'b525b03b-77be-54a4-a3af-0ba632d33d8e', '5612e769-b27a-5b88-af8f-a6e549bde657', '95fde13f-f2f8-581f-852a-4b7540ecf1db', 'c96091b6-c363-5c5c-9247-e1b9873f5681', '0f7c1fec-9b53-5b37-9382-8f5a4d869533', 'dfe295fe-7b17-5250-9b22-ceeafd9d4b9d', '55b8437f-deb4-56f1-80b0-a7dc7ef4e208');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'physique-1ere-sec' AND source = 'admin' AND id NOT IN ('23efe879-f28b-5f02-9781-87c73bbf943c', '825c0e36-76ff-5ed0-807a-767423c8d266', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', '4c945492-15a7-5744-b8d4-aca03ae96823', '1f35f50b-4457-5031-8b0c-fdde34926782', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', '1d81c458-1701-5b14-a5fe-009936e9168d', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'd11513d0-a414-5c0c-91d2-e662b444d896', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', '7d6f7463-11be-5740-95b6-ff3eb85030e0', '422ca09e-9435-5139-8fd2-f18b5b26b6e1', '0660f866-d04b-5781-85bf-8fb151817d67', '5dd05201-7540-5485-a414-2641610ddff8', '0dee1c4c-f8bb-54ba-9846-8e6bf16cea42', 'a30e1a83-eb93-5edb-a494-525db481fa85', 'cfaa1433-5718-5f95-a3ed-8e0ac0f578cd', '67514517-cc86-572f-acb0-78c101a3e4a8', 'f23249a3-447c-5a84-b598-7befa440dea4', '57a6d088-3606-574e-9c7a-21ad61085b10', '77a71048-e455-52a7-8990-63bf49db5cde', '00f33ff4-afff-53df-a6c6-ae0ce43de208');
DELETE FROM public.questions WHERE exercise_id IN ('23efe879-f28b-5f02-9781-87c73bbf943c', '825c0e36-76ff-5ed0-807a-767423c8d266', '1236315a-99dd-5a69-96f5-5dfb8419a8ce', '8a0c1f7d-8df9-5fd3-89ba-1c2213e13dbb', '4c945492-15a7-5744-b8d4-aca03ae96823', '1f35f50b-4457-5031-8b0c-fdde34926782', '6d851b3d-7e0a-5089-88e3-e1650983ebe0', '1d81c458-1701-5b14-a5fe-009936e9168d', 'b224ac1f-0892-5896-afb0-e8e6f7c5501e', 'd11513d0-a414-5c0c-91d2-e662b444d896', '2e59ed7d-5427-5760-a8b1-c4cd65d9bc2f', 'e5fe894a-40ef-5e8b-b9ec-3b6a25992841', '7d6f7463-11be-5740-95b6-ff3eb85030e0', '422ca09e-9435-5139-8fd2-f18b5b26b6e1', '0660f866-d04b-5781-85bf-8fb151817d67', '5dd05201-7540-5485-a414-2641610ddff8', '0dee1c4c-f8bb-54ba-9846-8e6bf16cea42', 'a30e1a83-eb93-5edb-a494-525db481fa85', 'cfaa1433-5718-5f95-a3ed-8e0ac0f578cd', '67514517-cc86-572f-acb0-78c101a3e4a8', 'f23249a3-447c-5a84-b598-7befa440dea4', '57a6d088-3606-574e-9c7a-21ad61085b10', '77a71048-e455-52a7-8990-63bf49db5cde', '00f33ff4-afff-53df-a6c6-ae0ce43de208') AND id NOT IN ('cd81dc68-012d-5b7b-933f-d7435246ca21', 'a86d19a9-30d9-5c8d-90d6-d731fd8c3612', 'ba093546-03bb-5f48-b5ab-332a4678ebf6', '4020c7c3-42ec-5666-ac02-4a7c928298c3', '01ce9519-615d-5193-a9ed-164d0b5a072d', 'd08bd409-bb8d-5a8c-95ab-629c0f9a422f', '2ce36be3-6e4b-52b3-9a1d-7c7f54a6cc84', '51ce21a3-3dd2-5c6f-b861-402f5aafaba0', '2058a83d-ec8d-53f0-861d-a626c400a934', 'bef91dee-3629-5e84-bade-c7522a85fb50', 'bbba134a-f585-5325-9050-883b9fced6ef', '680466e0-720b-5f2b-b901-9d1549225955', '65d44468-4c57-58f6-988e-b41cffdbf06d', '0be8d0a3-98bf-5aa1-89f0-997374ec0922', 'c5fa6f99-06bd-5072-b7c7-c1fe9ec69f4b', '719be2dd-43e5-5a01-9a87-5d3229436d1e', '16fbe64e-9ed9-504b-a6f4-97bcad3e4d60', '593f42be-93b1-539f-9322-a8d575e1a230', 'e471922a-f642-51a7-bb9e-033148f07ab8', 'e6ae6bc1-5f41-5427-8663-966a9f69011b', '3219b52c-4050-536e-a787-d88a78e20a56', '16e4af28-858b-50dd-ab76-15ff08bd3a3d', 'd1eb1423-8c01-5eb0-8f4e-6fcdc490e7bd', 'f06ec153-9a5d-5921-8cee-ee4bc8f28a6d', 'eaded567-35c8-5e33-8c78-4390a0158224', 'c7701a6d-c3a4-5c3c-b9ec-c7924b005f9c', 'ea325711-a531-5ac4-820b-d0830db1e4e8', '84b39c4c-c1a9-5e1a-985c-e0b77e47b62e', '296021ad-7e08-546c-9dbe-aaae56fd29e9', 'e4d55829-3d13-5138-81d0-18c228a57299', '7facd2a5-4bfd-50c2-a843-4959d28528c5', '58838187-63ac-5d6a-94ec-0ebfe67c6383', '485bc1fd-849e-5f84-88cc-38034411f189', '2cbc3e67-cbb2-5fb2-b5cc-573c046492d3', '03340da1-e134-5d23-a6da-4fa8758f7d93', '2b5f857f-c66f-5e1b-9b81-2512f2bf448c', 'f965d026-c959-5dbb-959a-627734428969', 'd58ee35d-e22e-5253-8bb6-4d3968cf2c9f', '64fb427c-c19f-5c39-8663-1d3598b6b47c', 'aa3e6731-bb22-52b1-b36b-b65c012e3b3b', '8720ecf5-db88-5cdc-a041-489b34b363fa', '8b561a76-af87-55be-900d-790038fa5101', '1d07fd26-fb3d-5bf3-9d73-672be638bbfe', 'fdfff668-8cea-5ba3-a664-5e4c24672e98', 'b79494b4-f612-5930-96f7-f80616f6d462', '47981fe7-4f66-5600-afc6-e076e535b7f8', 'eaf88d4d-6b20-5533-a3ce-591bdc9a7900', '0a38a704-d473-5ac3-b4c7-993995d4c29f', '53189c58-507c-56b7-903b-5aecf00ddb48', 'afff4689-031e-56c8-a4bc-a1bea114a14f', 'eeb1aad5-2c6c-50ae-b230-7ca3785764ee', '209983c0-a5b5-5ec3-984e-d29485e28584', '9007d29d-5aa2-5acb-8b20-465475a1ca4d', 'a45667e8-3ab4-54a0-84b4-11b6aa63abdc', '49bf1bda-7235-598d-9788-41f843be864f', 'd431ec8e-8e26-519f-9b15-c24355ed386c', 'a9df8c0b-d628-5ba4-bf5b-0e5b19f805c2', '5b30ac05-ab65-506e-87b6-14e9d6915203', '89ad05de-c572-5581-9325-79a511f17280', '42cbe483-f5da-5c86-88f4-ff14087d8c9c', '21a2da4a-2ccb-57b7-9d1e-64ba4003707b', 'faf9e844-3874-512b-9c3f-7d79e45bd9fe', '8104cc1a-7645-50e1-b7e2-04987db22904', '783d5c76-c42e-5890-9687-67972acd4c70', 'eabf0b7c-56ce-5ef5-a814-1e2e3a3d4613', 'f9c848cd-7dd1-55a0-abff-39fbe5b7f2be', '8fe13c74-52fb-538c-bc1e-d6e131b933a3', 'f6ca22d5-58c4-59e1-b026-5e8a9156bfd5', '8c7567b0-ac54-50ff-841a-32c5e7cd0b83', '0908c2c0-30b4-5855-b726-14ba7fbdb2d7', 'c0217e65-f239-55aa-a831-38a8c11c7a32', 'ce94ce9e-22ab-53dc-a639-6914ba5d7c48', 'f2948742-e856-5312-a4c4-94e961c453cd', 'f2c9f793-58b3-5608-9ef1-9822c13489cf', '71335a8b-4bcf-5a1a-9506-df483e881db2', '32a4e4ff-cb39-5a0f-abb0-280ceffb76b1', '20b0c8ec-40b0-593d-8296-7ca351414023', 'e432b93c-7430-5d50-a3d4-d8e3958391ca', 'f5db2d0c-d850-5039-bfa5-035d1b3b71ba', '4993eff6-9020-5a3e-bdf3-2376e4d0549e', 'e811528a-a241-56fc-a45b-914b217d25e1', 'c2ffa223-7429-560b-9077-67c135a8cb36', '60c4fc30-c54c-5450-802a-95639ccb4945', 'add45e24-fff3-506b-9133-053dd2ae80c3', '2fcb7236-95ac-5676-aa39-df0bb85ff409', '25217386-51db-5e5e-bdc6-0b74467b5ea5', 'abc07094-845e-5b5b-98b6-6dfdf42d1bfe', '671a0763-76ea-516c-b5e0-93363e15b1f0', 'f222edc4-95c0-5c44-ad24-0926e0d7c608', '5eefd557-3a06-5882-abfc-8eecaa9e8c0c', '7cafe90a-730f-5a2d-b90c-d9b0ae44da95', 'd0f28444-ef0a-5d09-bd3f-976e941a5951', 'ae69b3f1-142d-5727-af35-f2061a87bf1a', 'f254c2d6-77d2-5b05-b3ee-8d47bb45418a', '36a7acf2-fb31-539a-9c16-1c54b094e302', '7fa903cb-2892-5e30-a204-5955bd68e873', '9ece779e-0e45-5a9d-8825-a112d328cf42', 'e3efc622-cd7b-5914-971c-fd2bc0af9bbd', '61a6a809-b368-5682-a878-5df72a0ffd6c', 'a0479655-43aa-551a-aabc-8bb6a0ccf566', 'c61b00a6-b4d6-5ebd-8fc1-271594a559b0', '0a18a7a3-5b30-5e16-ac86-5579b6571c38', '4e48535a-8747-5264-8460-6055c9dc55cc', '9544663c-43ec-5fb0-9050-a8b7e49ea42f', '7168b5a2-cf82-5029-b45b-e71c258083f9', '4579525f-f116-5a0f-8166-a9358fc74f60', '79b10bca-3e49-569a-83e9-ea426f3e017f', 'f36da336-ef77-5cee-8c64-2b7e75504968', 'becb03c1-56f3-579c-a1c2-f73cfc84c3f8', '9405bc80-f2a0-5785-8204-09e75334d255', '21a14880-73c3-559f-85ee-e648ffd4adce', 'cbac5a2f-a278-52db-88d6-f4738159afe4', '0a8fd254-8e16-5bc5-8de0-5c81d8a439d0', '13b192cd-1882-517c-8f58-de9373d34408', '0d230c63-a295-5db4-839e-c8ea8f906084', '8dee3edb-15e8-5c37-909f-7ee2fa31ab76', '943e8084-af94-5be6-bf4a-33c7b64a20e3', '048d6a99-dfe1-5fef-a69b-014bd28e8db4', '81cbfde1-78f7-510e-af9b-8a39c60ef5b9', '901088c7-9fe6-5ab7-a2da-4bdc1cb7c126', '46c842ff-b964-514f-a585-1d21701968b9', 'c517d5ee-f0f0-5125-b38b-aa31317e87f7', 'b48ed0de-81ef-58f3-acda-c93765aa77e1', 'a2144baa-d3b9-5eaa-9fed-0516b67c34e1', '696c3ec0-a0be-5639-90da-2ccd62f57503', '86ed9c43-ea7c-512b-8cd4-669e3e8ac507', '968b920e-58de-516c-85c7-5a0212720e84', 'cad32dbd-ea52-592a-9e91-01cb2ea95e34', '0a57dbcd-4898-593e-b517-d86efdb83065', 'b525b03b-77be-54a4-a3af-0ba632d33d8e', '5612e769-b27a-5b88-af8f-a6e549bde657', '95fde13f-f2f8-581f-852a-4b7540ecf1db', 'c96091b6-c363-5c5c-9247-e1b9873f5681', '0f7c1fec-9b53-5b37-9382-8f5a4d869533', 'dfe295fe-7b17-5250-9b22-ceeafd9d4b9d', '55b8437f-deb4-56f1-80b0-a7dc7ef4e208');
DELETE FROM public.chapters c WHERE c.subject_id = 'physique-1ere-sec' AND c.id NOT IN ('f3c0e519-3356-5b57-bf8a-c39cf6650721', '60fba4c2-4acb-5966-bf21-451643db2757', '79bcf821-5a01-5dd5-93b8-497591138ae0', 'cefe9013-8f6e-57cc-beb2-addd28192c81', 'fa37b216-c0bf-59cd-aa50-40529b1b01f0', '090c9e09-759f-5ce2-af21-f48409c41776', 'c6786b76-bc3d-55f9-80fb-b9b4febeca46', '32d59637-8b9b-5c5d-be28-a661504a41e7') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

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

