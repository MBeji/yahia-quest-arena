-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: math-4eme (Mathématiques)
-- Regenerate with: npm run content:build
-- Source of truth: content/math-4eme/
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
  ('math-4eme', 'Mathématiques', 'الأنشطة العددية والقيس والهندسة وفق برنامج الرياضيات للسنة الرابعة من التعليم الأساسي', 'Force', 'subject-math', 'Calculator', 1, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '4eme-base'))
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
      AND e.subject_id = 'math-4eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('c8522cfd-ced3-54d5-b16c-bc210c42b058', 'bc7b6b37-1a73-5060-b1c1-899b2b9abff5', '1504f422-7f9d-52cf-a215-a96de1d2549a', '2ee5ca82-42f1-5036-ac9d-e4f8a48338bb', '6892ef1c-860c-5084-983a-d70413da51fe', '5016aedf-21d5-5c86-8f82-7c6822387466', '2bcc0769-766e-5a4b-a3f5-f51d428a591f', 'f0ade16e-8921-5081-bb33-3fb3ce437eb0', '70b0e03a-0f86-5a97-89b9-cabb718bf3f6', '39250332-0972-5907-aa2d-41caa2280ec0', '6383efcd-04eb-5884-8b09-19322826722d', 'b670f214-655d-5561-ab64-e6ad3c24543b', 'ef65de59-2a6a-5921-877f-05a76ce8c1e4', '86f27dfa-0116-5f8e-8143-c07f48f96710', '9f796947-f012-540e-afca-3fccfdf3941d', 'f0f47238-c04b-54e2-8679-415725b0463c', '76939230-885a-5e22-8a0d-8059d0b470a9', '59b64d06-812f-5bfc-b55d-50fda5d872b2', 'c2111661-190f-52a4-afb8-4fa42fd0bea7', '2f9f42fe-41b4-5247-801d-4ddff09c17fd', '0236d77a-cdd8-5dd0-9cca-ae0e66a22ac7', '87db69fa-91fd-5660-90a3-44a19221fae6', 'e1535337-7f11-58c2-af86-2ae7a1896894', '456a1869-dedc-5271-93ff-1b42631ac49c', 'd1d01dd8-83d0-5004-88eb-479f89f748f0', 'd42f0d8e-6466-5e1f-951c-29c1eb33984a', 'd8623911-b8b6-5528-b74c-0bef1ab2e521', '5a9c7a52-a0ab-5924-a518-44e357761bc4', '762143fb-9a07-5c4a-a1c3-03d80b822e08', 'e536fc05-0948-53d7-9594-e1abb9d1b2eb', 'ee5fbe91-fa44-54ce-be70-6fc4136b6d34', '3b1632a2-56f3-5c25-b1d0-019142c9703c', '7956ede4-fb20-57de-aced-9557cbaca630', '8f453ee0-5277-5d32-b15c-ad64e9ab53bc', '9453a405-81d6-5d9b-ac16-0acf66a9e9d4', 'de407ffe-6871-5174-8cf6-fb1fbad64739', '26b231a1-b5b1-5af6-90de-27993b68720d', '6b7bac15-beb7-529a-b752-765373e479b1', 'b015f604-65bc-59c4-bb5e-612650e8dbb5', '367386f7-d61c-58be-8e3d-3ad72e3f4d10', 'e4d19f9a-0635-52c6-8ef8-68502644fc4d', '1e07318f-3e0c-537c-ac6c-715b97c2a5e4', 'd2bbb97b-3ac0-5bff-9e35-cc0d89fc0d89', '852ed74c-f789-5ad5-b642-0597f8c83f3d', '4c90b1ea-ee81-5631-a4c4-49cf59672159', '522871d2-e558-55b0-abcf-58dde22f78a7', 'd5af2d3e-f592-5c63-9b7e-98786c8192ab', 'be1cc105-8ca3-5731-93bd-f8fb5bf2ff5e', '421bb0d4-3c57-569a-b320-6114007d4fe2', '3d895722-d8e6-5151-8915-6a1d98dbb4ac', 'af4bfd03-b58d-5fdf-b810-6b36b18a1950', '96e931b9-433b-5449-9132-4598bb0308b8', '0734c142-e9f9-55a6-a55f-11f90759937f', '725e6fe2-eb76-5ef4-bd9b-c1a30e0fcfb4', 'fc71293f-af3c-5cb2-beb5-415584314ee0', '3ab2de6f-3e34-55ee-802a-27e9b5b29082', 'c2855819-c279-5f2c-b315-deadd9b43983', '90a4460c-8ce9-520e-90c1-c12d36b8e1f3', 'd644f959-eea8-5d95-a959-6532c08d8075', '08a67320-40a6-56ed-ae4f-a081b60f36e8', '3f1b3ac1-f517-50c0-9f92-8bc6bfad2a64', '8a98c6e8-bdab-5fd0-aeb9-93f1fe7999c0', 'dfd12b21-d154-5e8e-9421-4c6e5f834d5d', '501de559-2b46-512f-a2f4-bac2e0218956', '8e196184-c181-59c9-9672-839b6e2c333f', '3a1f3e80-6acd-569b-86b9-886d3292722a', 'bb01e64b-767f-59d3-b009-e6c2263a1dea', '294354a2-50a1-567a-98fb-d277f7e6c5c4', 'e9b6acf1-bbb7-5fcb-a84a-54ff2dc30a80', 'd1631948-8c13-500a-ab4d-18472c97aa8f', 'd3b0ac0f-26bc-5b80-88f2-212416bc865d', '029069b8-d4bd-55c0-9d21-5dafa84c531e', '39eb085e-ee0b-516a-9b56-6f4a4947150c', '14dde8da-655b-5cbf-8963-b2243df6f711', '9334ab8b-b2b8-55bd-afa5-619cb63de274', '4c7e30bd-e584-544f-bd59-81d75fe1627f', '0b5be84a-d654-5035-8f54-75b504fa6775', '414ba6f6-ab03-56ab-9f48-80d42b4fb008', 'ce27632f-881e-5829-962c-c34bc4129fed', '404d95a1-ce38-58f3-acb4-389fc3cd5915', '4acd465b-e489-5b2a-b8b0-c91b78a15e8c', '5d6b3647-420e-57c1-9e35-b193ef692584', '6545db63-73ff-5578-9bdc-45b391636594', 'd7c9ae52-db90-5beb-aa4d-6e7cfd210ce6', '1e4ad8e2-7256-5cce-92fd-050b292ed62d', '02a5c8f6-662c-5387-84e6-0572643dc3ca', '451cd894-acfa-5ec4-a704-5519af1bb8b6', '440ce391-174c-552c-a182-534ba5b151f6', '13cbcd1a-3b33-5423-b1e0-0352fb633d45', '87e813c7-094d-55f1-86a8-ec583b61e9d4', '0c5d04e4-72b3-5fdb-8da9-0002b242163f', '08bda3fd-04a4-5319-a1c6-31a90ccda056', '8e322ef7-ec82-5f46-a2ec-b8c6eec74598', 'd6521925-927d-58af-8473-12bd846dc5f2', 'f59ef8fd-1393-50cd-af4b-16e5d829666b', '15fa5f7d-147f-5134-b480-2580f7989b04', 'ad3e6515-ee0b-559f-90eb-acaa14ae424e', '27e2f790-6bb1-596a-aeb9-b1fae7ddfa52', '2ddf6a8e-f6b0-57d6-bbee-6a6834e24d77', '77cd03b9-c9b6-5fdd-8632-305ba23552ce', '12c06f18-0dfa-534a-b48f-4c48e70d143c', 'f6d8f01b-17de-5fbe-b35d-e32a5becf9be', 'e5595fc5-b6f5-51b7-9072-be66c38e8cb8', 'bfbf3a32-84ec-5e06-8294-e076554ba90d', '316e1ef9-27f6-5a24-baeb-55668d684024', '99a720b4-3745-5932-a21f-983ed5bfab10', '2defd0c3-900b-5955-8868-0047350d92bb', 'bcc15adc-de8a-5a63-82ae-1aa1dcb055ed', '3302bf2f-57c3-567b-81af-76b083003874', '3f07e809-1a53-5c16-af15-84d43cf47676', '88fca28d-9ec7-5454-89df-fcdcb199100a', 'f9f15e51-b93e-5d19-bf72-eaeaf590b572', '15ebc4b0-78ed-5b34-bc29-d99d540cfa48', '1e2abb38-1f26-5ac5-9427-1e96227f0c78', 'ed821292-f466-5032-bd55-8955bb242429', '4ef607d8-48cb-5084-9534-cc9abec978eb', '01dcfdf2-9494-5bb2-9beb-0d2b648227f9', 'ba3a2db6-0c84-5695-8a22-682a78a3f0b1', '80e43d2b-627c-5386-8666-7a411a069d4f', '4e7ec573-b20e-5e2c-a95a-dff46f6bcfad', '98c54e25-c01a-5729-b965-7d0bf1c1c1b9', '183f0d5e-549c-5467-8abc-da2c84afbc20', '7177ad2d-2696-5d96-80f8-980646dd1b3c', '8aa762bd-b295-52ad-b693-317851d582bf', '0025700b-0b3c-5a1b-b67c-9771d0909dd7', '018c0755-7896-5a17-91e8-7530e23516d6', '87674221-5e3f-5a41-8c78-97fb1cfa2118', 'e909bfca-afa2-58d3-a0dc-1efc6df0302e', 'e2cf07ac-e48f-5da3-b9e8-777cbe5a0ff5', 'eaa67713-18cb-5fe1-b03d-42fadf00b8af', 'a08cafd8-4be5-5223-887a-c9ae03b63edc', 'ba61da78-556d-5b85-adae-a6cb8b11d514', 'cfd725f8-95ee-5140-87ea-2377cd539b68', '16febc0a-2d1f-5304-ab0b-6ee6d114a28c', '48b07ec0-f0d2-5773-8985-c92f58765dba', 'ad1948f3-3a15-58db-acdc-c4ea93356da7', '13e951de-18b6-54a8-a269-88e0d6c6b88d', 'ebd5c4d4-c7ab-5780-8fe4-5392ce26ec62', '7838a935-5234-5026-9c24-d65b028c2498', 'de7c550a-5c30-5755-8b90-bfd98ad88eef');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'math-4eme' AND source = 'admin' AND id NOT IN ('0ad3f671-c535-5299-bac1-dedd3d9f814d', '6b9890f7-ddea-57b9-a773-74d9eb18658d', '392f7fa4-aa89-5181-9be4-79410f1ec329', 'af2d5a59-4a5f-5112-be0d-c44e7720cab3', '7248ab16-f92a-533a-9836-4ae0ce003d93', 'c36679ee-80b0-51b6-8c7f-8f85b19fae95', '1cdf46a6-cc85-5fc0-a186-0a6f0573ed74', '789989c5-4a44-5e35-8e80-6574250a997b', 'a35f0805-b9cf-5884-b56c-5711fffcfeb1', 'bebb64ec-ac80-59aa-bf3e-35e2f44f276f', '2472a4bb-fe42-5e82-82f1-246187df2ecd', '739dd918-14c9-5ac7-8d76-3a84db2cf24c', 'b535a3ad-6896-52fb-b6ca-8a0bc1bfccd5', '3e967624-a330-57f0-83bd-006a130d6277', '1951560a-05a9-52fb-8d09-000f80412655', 'eaa51ddb-dc08-5f57-b00f-ed10a30aff09', '992245fb-6ccc-57a7-b5ba-ef41540a37ad', 'b1cb17bf-bf14-5f5c-adfc-e03156f99920', '414f92be-14bd-51c6-b505-c5cfbcff91c6', '835b8c59-6eaa-547f-b42a-0cef079d9cb2', '000fc0e3-f7ea-5058-a909-efe142f04a4f', '60a81108-c031-589b-8b88-d02eddd4dcb6', '705dbc07-bc85-58eb-a174-999541a00f7a', 'c83ff5b2-9818-5123-b509-9371285d1a8b');
DELETE FROM public.questions WHERE exercise_id IN ('0ad3f671-c535-5299-bac1-dedd3d9f814d', '6b9890f7-ddea-57b9-a773-74d9eb18658d', '392f7fa4-aa89-5181-9be4-79410f1ec329', 'af2d5a59-4a5f-5112-be0d-c44e7720cab3', '7248ab16-f92a-533a-9836-4ae0ce003d93', 'c36679ee-80b0-51b6-8c7f-8f85b19fae95', '1cdf46a6-cc85-5fc0-a186-0a6f0573ed74', '789989c5-4a44-5e35-8e80-6574250a997b', 'a35f0805-b9cf-5884-b56c-5711fffcfeb1', 'bebb64ec-ac80-59aa-bf3e-35e2f44f276f', '2472a4bb-fe42-5e82-82f1-246187df2ecd', '739dd918-14c9-5ac7-8d76-3a84db2cf24c', 'b535a3ad-6896-52fb-b6ca-8a0bc1bfccd5', '3e967624-a330-57f0-83bd-006a130d6277', '1951560a-05a9-52fb-8d09-000f80412655', 'eaa51ddb-dc08-5f57-b00f-ed10a30aff09', '992245fb-6ccc-57a7-b5ba-ef41540a37ad', 'b1cb17bf-bf14-5f5c-adfc-e03156f99920', '414f92be-14bd-51c6-b505-c5cfbcff91c6', '835b8c59-6eaa-547f-b42a-0cef079d9cb2', '000fc0e3-f7ea-5058-a909-efe142f04a4f', '60a81108-c031-589b-8b88-d02eddd4dcb6', '705dbc07-bc85-58eb-a174-999541a00f7a', 'c83ff5b2-9818-5123-b509-9371285d1a8b') AND id NOT IN ('c8522cfd-ced3-54d5-b16c-bc210c42b058', 'bc7b6b37-1a73-5060-b1c1-899b2b9abff5', '1504f422-7f9d-52cf-a215-a96de1d2549a', '2ee5ca82-42f1-5036-ac9d-e4f8a48338bb', '6892ef1c-860c-5084-983a-d70413da51fe', '5016aedf-21d5-5c86-8f82-7c6822387466', '2bcc0769-766e-5a4b-a3f5-f51d428a591f', 'f0ade16e-8921-5081-bb33-3fb3ce437eb0', '70b0e03a-0f86-5a97-89b9-cabb718bf3f6', '39250332-0972-5907-aa2d-41caa2280ec0', '6383efcd-04eb-5884-8b09-19322826722d', 'b670f214-655d-5561-ab64-e6ad3c24543b', 'ef65de59-2a6a-5921-877f-05a76ce8c1e4', '86f27dfa-0116-5f8e-8143-c07f48f96710', '9f796947-f012-540e-afca-3fccfdf3941d', 'f0f47238-c04b-54e2-8679-415725b0463c', '76939230-885a-5e22-8a0d-8059d0b470a9', '59b64d06-812f-5bfc-b55d-50fda5d872b2', 'c2111661-190f-52a4-afb8-4fa42fd0bea7', '2f9f42fe-41b4-5247-801d-4ddff09c17fd', '0236d77a-cdd8-5dd0-9cca-ae0e66a22ac7', '87db69fa-91fd-5660-90a3-44a19221fae6', 'e1535337-7f11-58c2-af86-2ae7a1896894', '456a1869-dedc-5271-93ff-1b42631ac49c', 'd1d01dd8-83d0-5004-88eb-479f89f748f0', 'd42f0d8e-6466-5e1f-951c-29c1eb33984a', 'd8623911-b8b6-5528-b74c-0bef1ab2e521', '5a9c7a52-a0ab-5924-a518-44e357761bc4', '762143fb-9a07-5c4a-a1c3-03d80b822e08', 'e536fc05-0948-53d7-9594-e1abb9d1b2eb', 'ee5fbe91-fa44-54ce-be70-6fc4136b6d34', '3b1632a2-56f3-5c25-b1d0-019142c9703c', '7956ede4-fb20-57de-aced-9557cbaca630', '8f453ee0-5277-5d32-b15c-ad64e9ab53bc', '9453a405-81d6-5d9b-ac16-0acf66a9e9d4', 'de407ffe-6871-5174-8cf6-fb1fbad64739', '26b231a1-b5b1-5af6-90de-27993b68720d', '6b7bac15-beb7-529a-b752-765373e479b1', 'b015f604-65bc-59c4-bb5e-612650e8dbb5', '367386f7-d61c-58be-8e3d-3ad72e3f4d10', 'e4d19f9a-0635-52c6-8ef8-68502644fc4d', '1e07318f-3e0c-537c-ac6c-715b97c2a5e4', 'd2bbb97b-3ac0-5bff-9e35-cc0d89fc0d89', '852ed74c-f789-5ad5-b642-0597f8c83f3d', '4c90b1ea-ee81-5631-a4c4-49cf59672159', '522871d2-e558-55b0-abcf-58dde22f78a7', 'd5af2d3e-f592-5c63-9b7e-98786c8192ab', 'be1cc105-8ca3-5731-93bd-f8fb5bf2ff5e', '421bb0d4-3c57-569a-b320-6114007d4fe2', '3d895722-d8e6-5151-8915-6a1d98dbb4ac', 'af4bfd03-b58d-5fdf-b810-6b36b18a1950', '96e931b9-433b-5449-9132-4598bb0308b8', '0734c142-e9f9-55a6-a55f-11f90759937f', '725e6fe2-eb76-5ef4-bd9b-c1a30e0fcfb4', 'fc71293f-af3c-5cb2-beb5-415584314ee0', '3ab2de6f-3e34-55ee-802a-27e9b5b29082', 'c2855819-c279-5f2c-b315-deadd9b43983', '90a4460c-8ce9-520e-90c1-c12d36b8e1f3', 'd644f959-eea8-5d95-a959-6532c08d8075', '08a67320-40a6-56ed-ae4f-a081b60f36e8', '3f1b3ac1-f517-50c0-9f92-8bc6bfad2a64', '8a98c6e8-bdab-5fd0-aeb9-93f1fe7999c0', 'dfd12b21-d154-5e8e-9421-4c6e5f834d5d', '501de559-2b46-512f-a2f4-bac2e0218956', '8e196184-c181-59c9-9672-839b6e2c333f', '3a1f3e80-6acd-569b-86b9-886d3292722a', 'bb01e64b-767f-59d3-b009-e6c2263a1dea', '294354a2-50a1-567a-98fb-d277f7e6c5c4', 'e9b6acf1-bbb7-5fcb-a84a-54ff2dc30a80', 'd1631948-8c13-500a-ab4d-18472c97aa8f', 'd3b0ac0f-26bc-5b80-88f2-212416bc865d', '029069b8-d4bd-55c0-9d21-5dafa84c531e', '39eb085e-ee0b-516a-9b56-6f4a4947150c', '14dde8da-655b-5cbf-8963-b2243df6f711', '9334ab8b-b2b8-55bd-afa5-619cb63de274', '4c7e30bd-e584-544f-bd59-81d75fe1627f', '0b5be84a-d654-5035-8f54-75b504fa6775', '414ba6f6-ab03-56ab-9f48-80d42b4fb008', 'ce27632f-881e-5829-962c-c34bc4129fed', '404d95a1-ce38-58f3-acb4-389fc3cd5915', '4acd465b-e489-5b2a-b8b0-c91b78a15e8c', '5d6b3647-420e-57c1-9e35-b193ef692584', '6545db63-73ff-5578-9bdc-45b391636594', 'd7c9ae52-db90-5beb-aa4d-6e7cfd210ce6', '1e4ad8e2-7256-5cce-92fd-050b292ed62d', '02a5c8f6-662c-5387-84e6-0572643dc3ca', '451cd894-acfa-5ec4-a704-5519af1bb8b6', '440ce391-174c-552c-a182-534ba5b151f6', '13cbcd1a-3b33-5423-b1e0-0352fb633d45', '87e813c7-094d-55f1-86a8-ec583b61e9d4', '0c5d04e4-72b3-5fdb-8da9-0002b242163f', '08bda3fd-04a4-5319-a1c6-31a90ccda056', '8e322ef7-ec82-5f46-a2ec-b8c6eec74598', 'd6521925-927d-58af-8473-12bd846dc5f2', 'f59ef8fd-1393-50cd-af4b-16e5d829666b', '15fa5f7d-147f-5134-b480-2580f7989b04', 'ad3e6515-ee0b-559f-90eb-acaa14ae424e', '27e2f790-6bb1-596a-aeb9-b1fae7ddfa52', '2ddf6a8e-f6b0-57d6-bbee-6a6834e24d77', '77cd03b9-c9b6-5fdd-8632-305ba23552ce', '12c06f18-0dfa-534a-b48f-4c48e70d143c', 'f6d8f01b-17de-5fbe-b35d-e32a5becf9be', 'e5595fc5-b6f5-51b7-9072-be66c38e8cb8', 'bfbf3a32-84ec-5e06-8294-e076554ba90d', '316e1ef9-27f6-5a24-baeb-55668d684024', '99a720b4-3745-5932-a21f-983ed5bfab10', '2defd0c3-900b-5955-8868-0047350d92bb', 'bcc15adc-de8a-5a63-82ae-1aa1dcb055ed', '3302bf2f-57c3-567b-81af-76b083003874', '3f07e809-1a53-5c16-af15-84d43cf47676', '88fca28d-9ec7-5454-89df-fcdcb199100a', 'f9f15e51-b93e-5d19-bf72-eaeaf590b572', '15ebc4b0-78ed-5b34-bc29-d99d540cfa48', '1e2abb38-1f26-5ac5-9427-1e96227f0c78', 'ed821292-f466-5032-bd55-8955bb242429', '4ef607d8-48cb-5084-9534-cc9abec978eb', '01dcfdf2-9494-5bb2-9beb-0d2b648227f9', 'ba3a2db6-0c84-5695-8a22-682a78a3f0b1', '80e43d2b-627c-5386-8666-7a411a069d4f', '4e7ec573-b20e-5e2c-a95a-dff46f6bcfad', '98c54e25-c01a-5729-b965-7d0bf1c1c1b9', '183f0d5e-549c-5467-8abc-da2c84afbc20', '7177ad2d-2696-5d96-80f8-980646dd1b3c', '8aa762bd-b295-52ad-b693-317851d582bf', '0025700b-0b3c-5a1b-b67c-9771d0909dd7', '018c0755-7896-5a17-91e8-7530e23516d6', '87674221-5e3f-5a41-8c78-97fb1cfa2118', 'e909bfca-afa2-58d3-a0dc-1efc6df0302e', 'e2cf07ac-e48f-5da3-b9e8-777cbe5a0ff5', 'eaa67713-18cb-5fe1-b03d-42fadf00b8af', 'a08cafd8-4be5-5223-887a-c9ae03b63edc', 'ba61da78-556d-5b85-adae-a6cb8b11d514', 'cfd725f8-95ee-5140-87ea-2377cd539b68', '16febc0a-2d1f-5304-ab0b-6ee6d114a28c', '48b07ec0-f0d2-5773-8985-c92f58765dba', 'ad1948f3-3a15-58db-acdc-c4ea93356da7', '13e951de-18b6-54a8-a269-88e0d6c6b88d', 'ebd5c4d4-c7ab-5780-8fe4-5392ce26ec62', '7838a935-5234-5026-9c24-d65b028c2498', 'de7c550a-5c30-5755-8b90-bfd98ad88eef');
DELETE FROM public.chapters c WHERE c.subject_id = 'math-4eme' AND c.id NOT IN ('4ebcb036-2ec2-5db3-b24e-29cde2c28a91', '04715775-0b39-57ae-8721-5cf64ba3fe74', 'af509553-26c9-5d21-bbfe-3ed8114bf196', '98f8395c-1912-5475-ae45-d93d5f2ffc6f') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('4ebcb036-2ec2-5db3-b24e-29cde2c28a91', 'math-4eme', 'الأعداد الطبيعية إلى 9999', 'نظام العدّ العشري، الرتب الأربع (آحاد، عشرات، مئات، آلاف)، قراءة وكتابة الأعداد إلى 9999، التفكيك، المقارنة والترتيب، والتدوير', '# ⚔️ الأعداد الطبيعية إلى 9999 — بوّابة عالَم الآلاف

> 💡 «من يُتقن منازل العدد يَقرأ أيَّ عددٍ ولو بلغ الآلاف.»

أهلًا بك أيّها البطل في أوّل بوّابة من مغامرة السنة الرابعة. أنت تعرف من قبلُ الأعداد إلى 999؛ اليوم نفتح **رتبةً جديدة**: رتبة **الآلاف**، فنصير نقرأ ونكتب ونقارن كلّ عددٍ إلى **9999**.

## 🏰 الأعداد الطبيعية وما نَعُدّ به

الأعداد الطبيعية هي الأعداد التي نَعُدّ بها: **0، 1، 2، 3، 4، …** وتستمرّ بلا نهاية.

- لكلّ عددٍ طبيعيّ _عددٌ يليه_ (تالٍ): بعد 9 يأتي 10، وبعد 999 يأتي 1000.
- ولكلّ عددٍ (ما عدا 0) _عددٌ يسبقه_ (سابق): سابق 1000 هو 999.
- أصغر عددٍ طبيعيّ هو **0**، ولا يوجد **أكبر** عددٍ طبيعيّ.

## 🧮 نظام العدّ العشري: الرتب الأربع

نكتب كلّ الأعداد بعشرة رموزٍ فقط (من 0 إلى 9)، وتتعلّق قيمة الرقم بـ**موضعه** (رتبته). وكلّ **عشر وحداتٍ** من رتبةٍ تُكوّن **وحدةً واحدة** من الرتبة الأعلى.

| الرتبة | آحاد | عشرات | مئات | آلاف  |
| ------ | ---- | ----- | ---- | ----- |
| قيمتها | 1    | 10    | 100  | 1 000 |

_مثال:_ في العدد 3 758، الرقم 3 في رتبة الآلاف (قيمته 3 000)، والرقم 7 في رتبة المئات (قيمته 700)، والرقم 5 عشرات (قيمته 50)، والرقم 8 آحاد.

## 🔮 قراءة وكتابة الأعداد إلى 9999

لقراءة عددٍ من أربعة أرقام نقرأ أوّلًا عدد الآلاف، ثمّ نُتبعه بقراءة العدد المكوّن من المئات والعشرات والآحاد.

- _مثال:_ العدد 4 206 يُقرأ «أربعة آلاف ومئتان وستّة».

> 🗡️ عند الكتابة بالأرقام نترك **فراغًا صغيرًا** بين رتبة الآلاف وبقيّة الأرقام (لا فاصلة): 4 206، حتّى تَسهُل القراءة.

## ⚡ تفكيك عدد

تفكيك عددٍ يعني كتابته **مجموعَ حاصلات ضربٍ** حسب رتب أرقامه:

$$3 758 = 3 × 1000 + 7 × 100 + 5 × 10 + 8$$

- الرقم **0** في رتبةٍ يعني _لا شيء في تلك الرتبة_، لكنّه ضروريّ ليحفظ مواضع بقيّة الأرقام: 3 070 = 3 × 1000 + 7 × 10.

## 🛡️ المقارنة والترتيب

لمقارنة عددين طبيعيّين:

1. العدد ذو **عددِ الأرقام الأكبر** هو الأكبر (بعد إهمال الأصفار غير المفيدة على اليسار).
2. إذا تساوى عددُ الأرقام، نقارن **رقمًا رقمًا** من اليسار إلى اليمين، فالحُكم لأوّل اختلاف.

ثمّ نرتّب الأعداد **تصاعديًّا** (من الأصغر إلى الأكبر) أو **تنازليًّا** (العكس)، مستعملين الرموز < و > و =.

> ⚠️ الفخّ الشائع: الظنّ أنّ 4 206 أكبر من 4 260 لأنّ فيه الرقم 6؛ والصواب أنّنا نقارن بالرتبة: المئات متساوية (2 = 2)، ثمّ العشرات 0 < 6، إذن 4 206 < 4 260.

## 📐 تدوير عدد (القيمة المقرّبة)

لتدوير عددٍ إلى رتبةٍ معيّنة (أقرب عشرة، مئة، أو ألف):

- ننظر إلى الرقم الذي **يلي** الرتبة المطلوبة مباشرةً (على يمينها).
- إذا كان **5 أو أكثر** نُدوّر إلى الأعلى؛ وإذا كان **أقلّ من 5** نُبقي الرتبة كما هي، ثمّ نُعوّض كلّ ما بعدها أصفارًا.
- _مثال:_ تدوير 3 758 إلى أقرب **مئة**: الرقم بعد المئات هو 5 (≥ 5) ⟸ النتيجة 3 800. وتدويره إلى أقرب **ألف**: الرقم بعد الآلاف هو 7 (≥ 5) ⟸ النتيجة 4 000.

> 🏆 لقد عبرت البوّابة الأولى! صرت تقرأ وتكتب وتُفكّك وتقارن وتُدوّر كلّ عددٍ إلى 9999. استعدّ الآن للبوّابة الموالية حيث نفتح رتبة **عشرات الآلاف** ونبلغ 99999.', '# 📜 ملخّص: الأعداد الطبيعية إلى 9999

- **الأعداد الطبيعية:** 0، 1، 2، 3، … بلا نهاية؛ أصغرها 0 ولا أكبر لها، ولكلّ عددٍ سابقٌ وتالٍ.
- **الرتب الأربع:** آحاد (1)، عشرات (10)، مئات (100)، آلاف (1 000)؛ وكلّ 10 وحداتٍ من رتبةٍ = وحدةٌ من الرتبة الأعلى.
- **القراءة والكتابة:** نقرأ عددَ الآلاف ثمّ بقيّة العدد؛ ونكتب بفراغٍ صغير قبل الآلاف مثل 4 206.
- **التفكيك:** كتابة العدد مجموعَ حاصلات ضربٍ حسب الرتب، مثل 3 758 = 3×1000 + 7×100 + 5×10 + 8.
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
  ('04715775-0b39-57ae-8721-5cf64ba3fe74', 'math-4eme', 'الأعداد الطبيعية إلى 99999', 'رتبة عشرات الآلاف، صنف الآلاف وصنف الوحدات، قراءة وكتابة الأعداد إلى 99999، التفكيك، المقارنة والترتيب، والتدوير إلى أقرب ألف وعشرة آلاف', '# ⚔️ الأعداد الطبيعية إلى 99999 — بوّابة عشرات الآلاف

> 💡 «كلّما فتحت رتبةً جديدة اتّسع عالَمك العدديّ.»

في البوّابة السابقة بلغتَ 9999. اليوم نفتح **رتبةً خامسة**: رتبة **عشرات الآلاف**، فنصير نقرأ ونكتب ونقارن كلّ عددٍ إلى **99999**، ونتعلّم تجميع الأرقام في **أصناف**.

## 🏰 رتبة جديدة: عشرات الآلاف

بعد رتبة الآلاف تأتي رتبة **عشرات الآلاف** (قيمتها 10 000)، فيصير لدينا خمس رتب:

| الرتبة | آحاد | عشرات | مئات | آلاف  | عشرات الآلاف |
| ------ | ---- | ----- | ---- | ----- | ------------ |
| قيمتها | 1    | 10    | 100  | 1 000 | 10 000       |

_مثال:_ في العدد 47 305، الرقم 4 في رتبة عشرات الآلاف (قيمته 40 000)، والرقم 7 في رتبة الآلاف (قيمته 7 000).

## 🧮 الأصناف: صنف الوحدات وصنف الآلاف

نُجمّع الأرقام **ثلاثةً ثلاثةً** انطلاقًا من اليمين، فنحصل على **أصناف**:

- **صنف الوحدات البسيطة:** الآحاد والعشرات والمئات.
- **صنف الآلاف:** الآلاف وعشرات الآلاف (ومئات الآلاف لاحقًا).

في العدد 47 305: صنف الآلاف هو **47** (سبعة وأربعون ألفًا)، وصنف الوحدات هو **305**.

## 🔮 قراءة وكتابة الأعداد إلى 99999

لقراءة العدد نقرأ **صنف الآلاف** متبوعًا بكلمة «ألف/آلاف»، ثمّ نقرأ **صنف الوحدات**.

- _مثال:_ العدد 47 305 يُقرأ «سبعة وأربعون ألفًا وثلاثمئة وخمسة».

> 🗡️ نترك **فراغًا صغيرًا** بين الصنفين عند الكتابة بالأرقام (لا فاصلة): 47 305، حتّى تَسهُل القراءة.

## ⚡ تفكيك عدد

نكتب العدد **مجموعَ حاصلات ضربٍ** حسب رتبه:

$$47 305 = 4 × 10000 + 7 × 1000 + 3 × 100 + 0 × 10 + 5$$

- الرقم **0** في رتبةٍ ضروريّ ليحفظ المواضع: 30 008 = 3 × 10000 + 8.

## 🛡️ المقارنة والترتيب

لمقارنة عددين:

1. الأكثر **أرقامًا** هو الأكبر (بعد إهمال أصفار اليسار): 9 999 < 12 000.
2. عند تساوي عدد الأرقام نقارن **رقمًا رقمًا** من اليسار، فالحُكم لأوّل اختلاف.

ثمّ نرتّب **تصاعديًّا** أو **تنازليًّا** بالرموز < و > و =.

> ⚠️ الفخّ الشائع: مقارنة عددين بعدد أرقامهما فقط دون محاذاتهما من اليمين؛ تذكّر أنّ 8 765 (أربعة أرقام) أصغر من 10 002 (خمسة أرقام).

## 📐 التدوير إلى أقرب ألف وعشرة آلاف

نفس قاعدة التدوير: ننظر إلى الرقم الذي **يلي** الرتبة المطلوبة:

- إلى أقرب **ألف**: ننظر إلى رقم المئات. _مثال:_ 47 305 → رقم المئات 3 (أقلّ من 5) ⟸ 47 000.
- إلى أقرب **عشرة آلاف**: ننظر إلى رقم الآلاف. _مثال:_ 47 305 → رقم الآلاف 7 (≥ 5) ⟸ 50 000.

> 🏆 لقد فتحتَ رتبة عشرات الآلاف وأتقنتَ الأصناف! صرت سيّدًا للأعداد إلى 99999. حان الآن وقت المعارك الحقيقية: العمليّات على هذه الأعداد، بدءًا بالجمع والطرح.', '# 📜 ملخّص: الأعداد الطبيعية إلى 99999

- **رتبة عشرات الآلاف:** قيمتها 10 000، وهي الرتبة الخامسة بعد الآحاد والعشرات والمئات والآلاف.
- **الأصناف:** نُجمّع الأرقام ثلاثيّاتٍ من اليمين: صنف الوحدات (آحاد، عشرات، مئات) وصنف الآلاف (آلاف، عشرات الآلاف).
- **القراءة:** نقرأ صنف الآلاف متبوعًا بـ«ألف/آلاف» ثمّ صنف الوحدات، مثل 47 305 = «سبعة وأربعون ألفًا وثلاثمئة وخمسة».
- **الكتابة:** فراغٌ صغير بين الصنفين، مثل 47 305.
- **التفكيك:** مجموعُ حاصلات ضربٍ حسب الرتب، مثل 47 305 = 4×10000 + 7×1000 + 3×100 + 5.
- **المقارنة:** الأكثر أرقامًا أكبر (بعد إهمال أصفار اليسار)، وعند التساوي نقارن رقمًا رقمًا من اليسار.
- **التدوير:** إلى أقرب ألف ننظر إلى المئات، وإلى أقرب عشرة آلاف ننظر إلى الآلاف؛ إن كان الرقم ≥ 5 نُدوّر إلى الأعلى.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('af509553-26c9-5d21-bbfe-3ed8114bf196', 'math-4eme', 'الجمع والطرح', 'تقنية الجمع مع الاحتفاظ، خاصّيات الجمع، تقنية الطرح مع الاستلاف، العلاقة بين الجمع والطرح، حساب الحدّ المجهول، وحلّ المسائل', '# ⚔️ الجمع والطرح — سلاحا الحساب

> 💡 «بالجمع نَزيد وبالطرح نَنقص، وبهما معًا نَحُلّ كلّ مسائل اليوم.»

أتقنتَ قراءة الأعداد الكبيرة؛ حان وقت **العمل بها**. في هذه البوّابة تتعلّم تقنيتَي الجمع والطرح بإتقانٍ مع **الاحتفاظ** و**الاستلاف**، وتكتشف العلاقة الخفيّة التي تربط بينهما.

## ➕ الجمع: المصطلحات والمعنى

في عمليّة الجمع نسمّي الأعداد التي نجمعها **الحدود**، ونسمّي النتيجة **المجموع**:

$$3 245 + 1 132 = 4 377$$

هنا 3 245 و 1 132 حدّان، و 4 377 هو المجموع. نَجمع عندما **نضمّ** كمّيّاتٍ بعضها إلى بعض.

## 🧮 تقنية الجمع مع الاحتفاظ

نكتب الأعداد بعضها تحت بعضٍ مع **محاذاة الرتب** (الآحاد تحت الآحاد…)، ثمّ نجمع رتبةً رتبةً من اليمين. وإذا بلغ مجموع رتبةٍ عشرةً أو أكثر **نحتفظ** بالعشرة في الرتبة الموالية.

- _مثال:_ 3 658 + 2 476. الآحاد: 8 + 6 = 14، نكتب 4 ونحتفظ بـ 1. العشرات: 5 + 7 + 1 = 13، نكتب 3 ونحتفظ بـ 1. المئات: 6 + 4 + 1 = 11، نكتب 1 ونحتفظ بـ 1. الآلاف: 3 + 2 + 1 = 6. النتيجة **6 134**.

> 🗡️ احتفظ دائمًا بالرقم المنقول إلى الرتبة الموالية، ولا تنسَ إضافته.

## 🔮 خاصّيات الجمع

- **التبديليّة:** يمكن تبديل ترتيب الحدّين دون أن يتغيّر المجموع: 234 + 566 = 566 + 234.
- **التجميعيّة:** عند جمع ثلاثة حدودٍ نختار الترتيب الأسهل: (25 + 75) + 48 = 100 + 48 = 148.
- **العنصر المحايد:** جمع 0 لا يغيّر العدد: 4 377 + 0 = 4 377.

هذه الخاصّيات تساعدك على **الحساب الذهنيّ** السريع.

## ➖ الطرح: المصطلحات والمعنى

في الطرح نطرح **المطروح** من **المطروح منه** فنحصل على **الفرق** (الباقي):

$$6 134 − 2 476 = 3 658$$

هنا 6 134 هو المطروح منه، و 2 476 هو المطروح، و 3 658 هو الفرق. نطرح عندما نريد معرفة **ما تبقّى** أو **الفرق** بين عددين.

## 🛡️ تقنية الطرح مع الاستلاف

نحاذي الرتب ونطرح من اليمين. وإذا كان رقم الرتبة في الأعلى **أصغر** من الذي تحته **نستلف** عشرةً من الرتبة الموالية.

- _مثال:_ 6 134 − 2 476. الآحاد: 4 أصغر من 6، نستلف: 14 − 6 = 8. العشرات: صارت 2 (بعد الاستلاف) أصغر من 7، نستلف: 12 − 7 = 5. المئات: صارت 0 أصغر من 4، نستلف: 10 − 4 = 6. الآلاف: صارت 5 − 2 = 3. النتيجة **3 658**.

> ⚠️ الفخّ الشائع: طرح الرقم الأصغر من الأكبر في كلّ رتبةٍ مهما كان موضعه؛ والصواب أن نطرح **الأسفل من الأعلى** دائمًا، ونستلف عند اللزوم.

## ⚡ العلاقة بين الجمع والطرح وحساب الحدّ المجهول

الجمع والطرح عمليّتان **عكسيّتان**: إذا كان a − b = c فإنّ c + b = a. نستعمل هذا للتثبّت ولإيجاد حدٍّ مجهول:

- لإيجاد الحدّ المجهول في جمعٍ: نطرح الحدّ المعلوم من المجموع. مثال: ? + 150 = 480 ⟸ ? = 480 − 150 = **330**.
- للتثبّت من طرحٍ: نجمع الفرق مع المطروح فنجد المطروح منه. مثال: 3 658 + 2 476 = 6 134 ✓.

> 🏆 صرت تملك سلاحَي الجمع والطرح وتعرف سرّ العلاقة بينهما! انطلق الآن نحو بوّابة **الضرب**، حيث نجمع نفس العدد مرّاتٍ عديدة دفعةً واحدة.', '# 📜 ملخّص: الجمع والطرح

- **الجمع:** نضمّ الحدود فنحصل على المجموع، مثل 3 245 + 1 132 = 4 377.
- **تقنية الجمع:** نحاذي الرتب ونجمع من اليمين، ونحتفظ بعشرةٍ في الرتبة الموالية كلّما بلغ مجموع رتبةٍ 10 أو أكثر.
- **خاصّيات الجمع:** التبديليّة (تبديل الحدّين)، التجميعيّة (تغيير ترتيب جمع ثلاثة حدود)، والعنصر المحايد 0.
- **الطرح:** نطرح المطروح من المطروح منه فنحصل على الفرق، مثل 6 134 − 2 476 = 3 658.
- **تقنية الطرح:** نحاذي الرتب ونطرح الأسفل من الأعلى من اليمين، ونستلف عشرةً من الرتبة الموالية عند اللزوم.
- **العلاقة العكسيّة:** إذا كان a − b = c فإنّ c + b = a؛ نستعملها للتثبّت ولإيجاد الحدّ المجهول.
- **الحدّ المجهول:** نجده بعمليّةٍ عكسيّة، مثل ? + 150 = 480 ⟸ ? = 480 − 150 = 330.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('98f8395c-1912-5475-ae45-d93d5f2ffc6f', 'math-4eme', 'الضرب', 'معنى الضرب ومصطلحاته، خاصّيات الضرب، الضرب في 10 و100 و1000، تقنية الضرب في عددٍ من رقمٍ واحد ثمّ من رقمين، التوزيعيّة، وحلّ المسائل', '# ⚔️ الضرب — قوّة الجمع المتكرّر

> 💡 «الضرب اختصارٌ ذكيّ: بدل أن تجمع العدد مرّاتٍ كثيرة، تضربه دفعةً واحدة.»

تعلّمتَ الجمع؛ والضرب هو سلاحك الأقوى لجمع **نفس العدد** مرّاتٍ عديدة في خطوةٍ واحدة. في هذه البوّابة تتقن تقنية الضرب في عددٍ من رقمٍ واحد ثمّ من رقمين، وتكتشف خاصّياته التي تسرّع حسابك.

## ✖️ معنى الضرب ومصطلحاته

ضربُ عددٍ في آخر هو **جمعه مع نفسه** بعدد المرّات المطلوب:

$$4 × 3 = 4 + 4 + 4 = 12$$

نسمّي العددين المضروبين **العاملين**، ونسمّي النتيجة **الجداء**. في 4 × 3 = 12، العددان 4 و 3 عاملان، و 12 هو الجداء.

## 🔮 خاصّيات الضرب

- **التبديليّة:** ترتيب العاملين لا يغيّر الجداء: 6 × 4 = 4 × 6 = 24.
- **التجميعيّة:** عند ضرب ثلاثة عوامل نختار الترتيب الأسهل: (2 × 5) × 7 = 10 × 7 = 70.
- **العنصر المحايد 1:** الضرب في 1 لا يغيّر العدد: 587 × 1 = 587.
- **العنصر الماحي 0:** الضرب في 0 يعطي 0 دائمًا: 736 × 0 = 0.

## 🧮 الضرب في 10 و100 و1000

للضرب في 10 نضيف **صفرًا** واحدًا على يمين العدد، وفي 100 نضيف **صفرين**، وفي 1000 **ثلاثة أصفار**:

| العمليّة | النتيجة |
| -------- | ------- |
| 45 × 10  | 450     |
| 45 × 100 | 4 500   |
| 45 × 1000 | 45 000 |

> 🗡️ هذه القاعدة تجعل الضرب في مضاعفات العشرة (مثل 30 = 3 × 10) سريعًا: 24 × 30 = 24 × 3 × 10 = 72 × 10 = 720.

## ⚡ الضرب في عددٍ من رقمٍ واحد

نضرب كلّ رقمٍ من العدد في العامل من اليمين إلى اليسار، **محتفظين** بالعشرات عند اللزوم:

- _مثال:_ 234 × 3. الآحاد: 4 × 3 = 12، نكتب 2 ونحتفظ بـ 1. العشرات: 3 × 3 = 9 زائد 1 = 10، نكتب 0 ونحتفظ بـ 1. المئات: 2 × 3 = 6 زائد 1 = 7. الجداء **702**.

## 🛡️ الضرب في عددٍ من رقمين والتوزيعيّة

نستعمل **التوزيعيّة**: نوزّع الضرب على رتب العامل الثاني، ثمّ نجمع الجداءات الجزئيّة.

- _مثال:_ 213 × 24 = 213 × 20 + 213 × 4 = 4 260 + 852 = **5 112**.
- بالتوزيعيّة كذلك: 8 × 13 = 8 × (10 + 3) = 8 × 10 + 8 × 3 = 80 + 24 = 104.

> ⚠️ الفخّ الشائع عند الضرب في رقم العشرات هو نسيان **الصفر** في رتبة الآحاد للجداء الجزئيّ: 213 × 2 **عشرات** = 4 260 لا 426.

> 🏆 صرت تتقن الضرب في رقمٍ واحد وفي رقمين وتستعمل خاصّياته بذكاء! استعدّ للبوّابة الموالية: **القسمة الإقليدية**، العمليّة العكسيّة للضرب.', '# 📜 ملخّص: الضرب

- **معنى الضرب:** جمعٌ متكرّرٌ لنفس العدد، مثل 4 × 3 = 4 + 4 + 4 = 12؛ العددان عاملان والنتيجة جداء.
- **خاصّيات الضرب:** التبديليّة (6×4 = 4×6)، التجميعيّة، العنصر المحايد 1 (587×1 = 587)، والعنصر الماحي 0 (736×0 = 0).
- **الضرب في 10 و100 و1000:** نضيف صفرًا واحدًا أو صفرين أو ثلاثة أصفار على يمين العدد، مثل 45×100 = 4 500.
- **الضرب في رقمٍ واحد:** نضرب كلّ رقمٍ من اليمين مع الاحتفاظ، مثل 234 × 3 = 702.
- **الضرب في رقمين:** بالتوزيعيّة نوزّع على رتب العامل ونجمع الجداءات الجزئيّة، مثل 213 × 24 = 4 260 + 852 = 5 112.
- **التوزيعيّة:** a × (b + c) = a×b + a×c، مثل 8 × 13 = 8×10 + 8×3 = 104.
- **فخّ الضرب في العشرات:** لا تنسَ الصفر في رتبة الآحاد للجداء الجزئيّ (213 × 20 = 4 260).', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0ad3f671-c535-5299-bac1-dedd3d9f814d', '4ebcb036-2ec2-5db3-b24e-29cde2c28a91', 'math-4eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('c8522cfd-ced3-54d5-b16c-bc210c42b058', '0ad3f671-c535-5299-bac1-dedd3d9f814d', 'في العدد 5 327، ما رتبة الرقم 5؟', '[{"id":"a","text":"الآحاد"},{"id":"b","text":"العشرات"},{"id":"c","text":"المئات"},{"id":"d","text":"الآلاف"}]'::jsonb, 'd', 'ابتداءً من اليمين في 5 327: الرقم 7 آحاد، 2 عشرات، 3 مئات، 5 آلاف. إذن الرقم 5 في رتبة الآلاف وقيمته 5 000.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc7b6b37-1a73-5060-b1c1-899b2b9abff5', '0ad3f671-c535-5299-bac1-dedd3d9f814d', 'كيف نكتب بالأرقام العددَ «ثلاثة آلاف وأربعون»؟', '[{"id":"a","text":"340"},{"id":"b","text":"3 004"},{"id":"c","text":"3 040"},{"id":"d","text":"3 400"}]'::jsonb, 'c', 'ثلاثة آلاف = 3 000، وأربعون = 4 عشرات = 40، مع صفرٍ في رتبة المئات وصفرٍ في الآحاد، فيكون العدد 3 040.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1504f422-7f9d-52cf-a215-a96de1d2549a', '0ad3f671-c535-5299-bac1-dedd3d9f814d', 'أيّ تفكيكٍ يوافق العدد 2 605؟', '[{"id":"a","text":"2 × 100 + 6 × 10 + 5"},{"id":"b","text":"2 × 1000 + 6 × 100 + 5"},{"id":"c","text":"2 × 1000 + 6 × 10 + 5"},{"id":"d","text":"26 × 100 + 5"}]'::jsonb, 'b', 'العدد 2 605 = 2 آلاف + 6 مئات + 0 عشرات + 5 آحاد، أي 2 × 1000 + 6 × 100 + 5. الصفر في العشرات لا يُكتب في المجموع.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ee5ca82-42f1-5036-ac9d-e4f8a48338bb', '0ad3f671-c535-5299-bac1-dedd3d9f814d', 'ما العلاقة الصحيحة بين العددين 4 206 و 4 260؟', '[{"id":"a","text":"4 206 < 4 260"},{"id":"b","text":"4 206 = 4 260"},{"id":"c","text":"4 206 > 4 260"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'a', 'للعددين 4 أرقام؛ نقارن من اليسار: الآلاف متساوية (4 = 4)، ثمّ المئات متساوية (2 = 2)، ثمّ العشرات: 0 < 6. إذن 4 206 < 4 260.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6892ef1c-860c-5084-983a-d70413da51fe', '0ad3f671-c535-5299-bac1-dedd3d9f814d', 'ما القيمة المقرّبة للعدد 3 472 إلى أقرب مئة؟', '[{"id":"a","text":"3 000"},{"id":"b","text":"3 400"},{"id":"c","text":"3 470"},{"id":"d","text":"3 500"}]'::jsonb, 'd', 'للتدوير إلى أقرب مئة ننظر إلى رقم العشرات: هو 7 (أكبر من أو يساوي 5)، فنُدوّر إلى الأعلى. إذن 3 472 يصبح 3 500.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6b9890f7-ddea-57b9-a773-74d9eb18658d', '4ebcb036-2ec2-5db3-b24e-29cde2c28a91', 'math-4eme', '⭐ تمرين: أوّل خطوات إلى عالَم الآلاف', 1, 50, 10, 'practice', 'admin', 1)
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
  ('5016aedf-21d5-5c86-8f82-7c6822387466', '6b9890f7-ddea-57b9-a773-74d9eb18658d', 'في العدد 4 813، ما رتبة الرقم 8؟', '[{"id":"a","text":"الآحاد"},{"id":"b","text":"العشرات"},{"id":"c","text":"المئات"},{"id":"d","text":"الآلاف"}]'::jsonb, 'c', 'ابتداءً من اليمين في 4 813: الرقم 3 آحاد، 1 عشرات، 8 مئات، 4 آلاف. إذن الرقم 8 في رتبة المئات.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2bcc0769-766e-5a4b-a3f5-f51d428a591f', '6b9890f7-ddea-57b9-a773-74d9eb18658d', 'كيف يُقرأ العدد 6 050؟', '[{"id":"a","text":"ستّة آلاف وخمسون"},{"id":"b","text":"ستّة آلاف وخمسمئة"},{"id":"c","text":"ستّمئة وخمسون"},{"id":"d","text":"ستّون ألفًا وخمسون"}]'::jsonb, 'a', 'العدد 6 050 = 6 آلاف + 0 مئات + 5 عشرات + 0 آحاد، فيُقرأ «ستّة آلاف وخمسون».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0ade16e-8921-5081-bb33-3fb3ce437eb0', '6b9890f7-ddea-57b9-a773-74d9eb18658d', 'كيف نكتب بالأرقام العددَ «خمسة آلاف ومئتان»؟', '[{"id":"a","text":"520"},{"id":"b","text":"5 020"},{"id":"c","text":"5 002"},{"id":"d","text":"5 200"}]'::jsonb, 'd', 'خمسة آلاف = 5 000، ومئتان = 200، مع صفرٍ في العشرات وصفرٍ في الآحاد، فيكون العدد 5 200.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('70b0e03a-0f86-5a97-89b9-cabb718bf3f6', '6b9890f7-ddea-57b9-a773-74d9eb18658d', 'أيّ تفكيكٍ يوافق العدد 3 408؟', '[{"id":"a","text":"3 × 100 + 4 × 10 + 8"},{"id":"b","text":"3 × 1000 + 4 × 100 + 8"},{"id":"c","text":"3 × 1000 + 4 × 10 + 8"},{"id":"d","text":"34 × 100 + 8"}]'::jsonb, 'b', 'العدد 3 408 = 3 آلاف + 4 مئات + 0 عشرات + 8 آحاد، أي 3 × 1000 + 4 × 100 + 8.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('39250332-0972-5907-aa2d-41caa2280ec0', '6b9890f7-ddea-57b9-a773-74d9eb18658d', 'أيّ الأعداد التالية هو الأكبر؟', '[{"id":"a","text":"2 007"},{"id":"b","text":"2 070"},{"id":"c","text":"2 077"},{"id":"d","text":"2 700"}]'::jsonb, 'd', 'نقارن رتبة الآلاف فهي متساوية (2)، ثمّ المئات: 7 أكبر من 0، إذن الأكبر هو 2 700.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6383efcd-04eb-5884-8b09-19322826722d', '6b9890f7-ddea-57b9-a773-74d9eb18658d', 'ما العدد الطبيعيّ الذي يلي مباشرةً العددَ 3 999؟', '[{"id":"a","text":"3 990"},{"id":"b","text":"3 998"},{"id":"c","text":"4 000"},{"id":"d","text":"4 009"}]'::jsonb, 'c', 'العدد التالي مباشرةً يساوي العددَ زائد 1: 3 999 + 1 = 4 000.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('392f7fa4-aa89-5181-9be4-79410f1ec329', '4ebcb036-2ec2-5db3-b24e-29cde2c28a91', 'math-4eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الأعداد إلى 9999', 3, 120, 30, 'boss', 'admin', 2)
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
  ('b670f214-655d-5561-ab64-e6ad3c24543b', '392f7fa4-aa89-5181-9be4-79410f1ec329', 'عددٌ رقمُ آلافه 3 ورقمُ مئاته 0 ورقمُ عشراته 5 ورقمُ آحاده 9. ما هو؟', '[{"id":"a","text":"3 590"},{"id":"b","text":"359"},{"id":"c","text":"3 059"},{"id":"d","text":"3 509"}]'::jsonb, 'c', 'نضع كلّ رقمٍ في رتبته من اليسار إلى اليمين: 3 آلاف، 0 مئات، 5 عشرات، 9 آحاد، فيكون العدد 3 059.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ef65de59-2a6a-5921-877f-05a76ce8c1e4', '392f7fa4-aa89-5181-9be4-79410f1ec329', 'ما القيمة المقرّبة للعدد 7 845 إلى أقرب ألف؟', '[{"id":"a","text":"7 000"},{"id":"b","text":"7 800"},{"id":"c","text":"7 850"},{"id":"d","text":"8 000"}]'::jsonb, 'd', 'للتدوير إلى أقرب ألف ننظر إلى رقم المئات: هو 8 (أكبر من أو يساوي 5)، فنُدوّر إلى الأعلى. إذن 7 845 يصبح 8 000.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('86f27dfa-0116-5f8e-8143-c07f48f96710', '392f7fa4-aa89-5181-9be4-79410f1ec329', 'ما الترتيب التصاعديّ الصحيح للأعداد 1 909 و 1 990 و 1 099؟', '[{"id":"a","text":"1 099 < 1 909 < 1 990"},{"id":"b","text":"1 099 < 1 990 < 1 909"},{"id":"c","text":"1 909 < 1 099 < 1 990"},{"id":"d","text":"1 990 < 1 909 < 1 099"}]'::jsonb, 'a', 'للأعداد الثلاثة رتبة الآلاف نفسها (1)؛ نقارن المئات: 0 (في 1 099) أصغر، ثمّ بين 1 909 و 1 990 نقارن العشرات: 0 < 9. إذن الترتيب 1 099 < 1 909 < 1 990.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9f796947-f012-540e-afca-3fccfdf3941d', '392f7fa4-aa89-5181-9be4-79410f1ec329', 'أيّ الأعداد التالية يُدوَّر إلى 4 000 عند تدويره إلى أقرب ألف؟', '[{"id":"a","text":"3 480"},{"id":"b","text":"3 700"},{"id":"c","text":"4 600"},{"id":"d","text":"4 950"}]'::jsonb, 'b', 'يُدوَّر العدد إلى 4 000 إذا وقع بين 3 500 و 4 499. الرقم 3 700 رقمُ مئاته 7 (≥ 5) فيُدوَّر إلى 4 000. أمّا 3 480 فيُدوَّر إلى 3 000، و 4 600 و 4 950 فيُدوَّران إلى 5 000.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0f47238-c04b-54e2-8679-415725b0463c', '392f7fa4-aa89-5181-9be4-79410f1ec329', 'باستعمال الأرقام 7 و 0 و 4 و 9 مرّةً واحدة لكلٍّ منها، ما أكبر عددٍ يمكن تكوينه؟', '[{"id":"a","text":"7 940"},{"id":"b","text":"9 470"},{"id":"c","text":"9 704"},{"id":"d","text":"9 740"}]'::jsonb, 'd', 'لتكوين أكبر عدد نضع أكبر رقمٍ في أعلى رتبة: 9 في الآلاف، ثمّ 7 في المئات، ثمّ 4 في العشرات، ثمّ 0 في الآحاد، فنحصل على 9 740.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('76939230-885a-5e22-8a0d-8059d0b470a9', '392f7fa4-aa89-5181-9be4-79410f1ec329', 'باستعمال الأرقام 7 و 0 و 4 و 9 مرّةً واحدة لكلٍّ منها، ما أصغر عددٍ من أربعة أرقام يمكن تكوينه؟', '[{"id":"a","text":"4 079"},{"id":"b","text":"4 097"},{"id":"c","text":"4 709"},{"id":"d","text":"4 790"}]'::jsonb, 'a', 'لا يجوز أن يبدأ العدد بالصفر وإلّا صار من ثلاثة أرقام، فنضع 4 (أصغر رقمٍ غير الصفر) في الآلاف، ثمّ 0 في المئات، ثمّ 7 في العشرات، ثمّ 9 في الآحاد: 4 079.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('af2d5a59-4a5f-5112-be0d-c44e7720cab3', '4ebcb036-2ec2-5db3-b24e-29cde2c28a91', 'math-4eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الأعداد إلى 9999', 2, 70, 15, 'practice', 'admin', 3)
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
  ('59b64d06-812f-5bfc-b55d-50fda5d872b2', 'af2d5a59-4a5f-5112-be0d-c44e7720cab3', 'في العدد 8 364، ما رتبة الرقم 8؟', '[{"id":"a","text":"الآحاد"},{"id":"b","text":"العشرات"},{"id":"c","text":"المئات"},{"id":"d","text":"الآلاف"}]'::jsonb, 'd', 'ابتداءً من اليمين في 8 364: الرقم 4 آحاد، 6 عشرات، 3 مئات، 8 آلاف. إذن الرقم 8 في رتبة الآلاف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2111661-190f-52a4-afb8-4fa42fd0bea7', 'af2d5a59-4a5f-5112-be0d-c44e7720cab3', 'كيف يُقرأ العدد 4 700؟', '[{"id":"a","text":"أربعة آلاف وسبعمئة"},{"id":"b","text":"أربعة آلاف وسبعون"},{"id":"c","text":"أربعمئة وسبعون"},{"id":"d","text":"أربعون ألفًا وسبعمئة"}]'::jsonb, 'a', 'العدد 4 700 = 4 آلاف + 7 مئات + 0 عشرات + 0 آحاد، فيُقرأ «أربعة آلاف وسبعمئة».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2f9f42fe-41b4-5247-801d-4ddff09c17fd', 'af2d5a59-4a5f-5112-be0d-c44e7720cab3', 'كيف نكتب بالأرقام العددَ «ستّة آلاف وتسعة»؟', '[{"id":"a","text":"609"},{"id":"b","text":"6 009"},{"id":"c","text":"6 090"},{"id":"d","text":"6 900"}]'::jsonb, 'b', 'ستّة آلاف = 6 000، وتسعة آحاد = 9، مع صفرٍ في المئات وصفرٍ في العشرات، فيكون العدد 6 009.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0236d77a-cdd8-5dd0-9cca-ae0e66a22ac7', 'af2d5a59-4a5f-5112-be0d-c44e7720cab3', 'ما العلاقة الصحيحة بين العددين 5 555 و 5 550؟', '[{"id":"a","text":"5 555 < 5 550"},{"id":"b","text":"5 555 = 5 550"},{"id":"c","text":"5 555 > 5 550"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'c', 'نقارن من اليسار: الآلاف والمئات والعشرات متساوية (5 و 5 و 5)، ثمّ الآحاد: 5 > 0. إذن 5 555 > 5 550.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87db69fa-91fd-5660-90a3-44a19221fae6', 'af2d5a59-4a5f-5112-be0d-c44e7720cab3', 'ما القيمة المقرّبة للعدد 2 451 إلى أقرب مئة؟', '[{"id":"a","text":"2 400"},{"id":"b","text":"2 450"},{"id":"c","text":"2 460"},{"id":"d","text":"2 500"}]'::jsonb, 'd', 'للتدوير إلى أقرب مئة ننظر إلى رقم العشرات: هو 5 (≥ 5)، فنُدوّر إلى الأعلى. إذن 2 451 يصبح 2 500.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e1535337-7f11-58c2-af86-2ae7a1896894', 'af2d5a59-4a5f-5112-be0d-c44e7720cab3', 'أيّ عددٍ يساوي 7 × 1000 + 5 × 10 + 3؟', '[{"id":"a","text":"7 053"},{"id":"b","text":"753"},{"id":"c","text":"7 503"},{"id":"d","text":"7 530"}]'::jsonb, 'a', '7 × 1000 = 7 000، و 5 × 10 = 50، و 3 آحاد = 3، ولا مئات (0 مئات)، فيكون العدد 7 053.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7248ab16-f92a-533a-9836-4ae0ce003d93', '4ebcb036-2ec2-5db3-b24e-29cde2c28a91', 'math-4eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز الأعداد إلى 9999', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('456a1869-dedc-5271-93ff-1b42631ac49c', '7248ab16-f92a-533a-9836-4ae0ce003d93', 'كم عددًا طبيعيًّا يقع تمامًا بين 3 999 و 4 003 (دون أن نَعُدّهما)؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'b', 'الأعداد الواقعة بينهما هي 4 000 و 4 001 و 4 002، أي 3 أعداد. لا نَعُدّ 3 999 ولا 4 003 لأنّ السؤال يستثنيهما.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1d01dd8-83d0-5004-88eb-479f89f748f0', '7248ab16-f92a-533a-9836-4ae0ce003d93', 'عددٌ إذا دُوِّر إلى أقرب مئة أعطى 3 600. ما أكبر قيمةٍ ممكنة لهذا العدد؟', '[{"id":"a","text":"3 600"},{"id":"b","text":"3 640"},{"id":"c","text":"3 649"},{"id":"d","text":"3 650"}]'::jsonb, 'c', 'يُدوَّر العدد إلى 3 600 إذا وقع بين 3 550 و 3 649 (لأنّ 3 650 يُدوَّر إلى 3 700). فأكبر قيمةٍ ممكنة هي 3 649.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d42f0d8e-6466-5e1f-951c-29c1eb33984a', '7248ab16-f92a-533a-9836-4ae0ce003d93', 'ما أكبر عددٍ من أربعة أرقام رقمُ آلافه 5 ورقمُ آحاده 0؟', '[{"id":"a","text":"5 990"},{"id":"b","text":"5 900"},{"id":"c","text":"5 090"},{"id":"d","text":"5 999"}]'::jsonb, 'a', 'رقم الآلاف مثبَّت (5) ورقم الآحاد مثبَّت (0)؛ لجعل العدد أكبر ما يمكن نختار أكبر رقمٍ (9) للمئات وللعشرات، فنحصل على 5 990. أمّا 5 999 فرقمُ آحاده 9 لا 0.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8623911-b8b6-5528-b74c-0bef1ab2e521', '7248ab16-f92a-533a-9836-4ae0ce003d93', 'أنا عددٌ من أربعة أرقام: رقمُ آلافي 6، ورقما مئاتي وعشراتي صفران، ومجموع رقمَي آلافي وآحادي يساوي 9. من أكون؟', '[{"id":"a","text":"6 300"},{"id":"b","text":"6 003"},{"id":"c","text":"9 000"},{"id":"d","text":"6 030"}]'::jsonb, 'b', 'رقم الآلاف 6، والمئات والعشرات أصفار. ومجموع الآلاف والآحاد 9، فرقمُ الآحاد = 9 − 6 = 3. إذن العدد 6 003.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a9c7a52-a0ab-5924-a518-44e357761bc4', '7248ab16-f92a-533a-9836-4ae0ce003d93', 'ما الترتيب التنازليّ الصحيح للأعداد 7 007 و 7 070 و 7 700؟', '[{"id":"a","text":"7 007 > 7 070 > 7 700"},{"id":"b","text":"7 070 > 7 700 > 7 007"},{"id":"c","text":"7 700 > 7 007 > 7 070"},{"id":"d","text":"7 700 > 7 070 > 7 007"}]'::jsonb, 'd', 'رتبة الآلاف نفسها (7)؛ نقارن المئات: 7 (في 7 700) الأكبر، ثمّ بين 7 070 و 7 007 نقارن العشرات: 7 > 0. إذن تنازليًّا: 7 700 > 7 070 > 7 007.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('762143fb-9a07-5c4a-a1c3-03d80b822e08', '7248ab16-f92a-533a-9836-4ae0ce003d93', 'باستعمال الأرقام 5 و 3 و 0 و 8 مرّةً واحدة لكلٍّ منها، ما العدد (من أربعة أرقام) الأقرب إلى 5 000؟', '[{"id":"a","text":"5 308"},{"id":"b","text":"5 083"},{"id":"c","text":"5 038"},{"id":"d","text":"5 380"}]'::jsonb, 'c', 'نبحث عن أقرب عددٍ إلى 5 000، فنبدأ بالرقم 5 في الآلاف ونصغّر ما بعده: أصغر تكوينٍ هو 5 038 (الفرق 38). أمّا 5 083 فالفرق 83، و 5 308 الفرق 308، و 5 380 الفرق 380. إذن الأقرب 5 038.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c36679ee-80b0-51b6-8c7f-8f85b19fae95', '4ebcb036-2ec2-5db3-b24e-29cde2c28a91', 'math-4eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للأعداد إلى 9999', 3, 120, 30, 'boss', 'admin', 5)
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
  ('e536fc05-0948-53d7-9594-e1abb9d1b2eb', 'c36679ee-80b0-51b6-8c7f-8f85b19fae95', 'ما قيمة الرقم 4 في العدد 6 482؟', '[{"id":"a","text":"4"},{"id":"b","text":"40"},{"id":"c","text":"400"},{"id":"d","text":"4 000"}]'::jsonb, 'c', 'في العدد 6 482 الرقم 4 في رتبة المئات، فقيمته 4 × 100 = 400 (لا تُخلَط القيمة بالرقم نفسه 4).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ee5fbe91-fa44-54ce-be70-6fc4136b6d34', 'c36679ee-80b0-51b6-8c7f-8f85b19fae95', 'كيف نكتب بالأرقام العددَ «تسعة آلاف»؟', '[{"id":"a","text":"900"},{"id":"b","text":"9 000"},{"id":"c","text":"9 090"},{"id":"d","text":"9 900"}]'::jsonb, 'b', 'تسعة آلاف = 9 × 1000 = 9 000، مع أصفارٍ في المئات والعشرات والآحاد.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3b1632a2-56f3-5c25-b1d0-019142c9703c', 'c36679ee-80b0-51b6-8c7f-8f85b19fae95', 'كيف يُقرأ العدد 5 016؟', '[{"id":"a","text":"خمسة آلاف وستّة عشر"},{"id":"b","text":"خمسة آلاف ومئة وستّة"},{"id":"c","text":"خمسمئة وستّة عشر"},{"id":"d","text":"خمسون ألفًا وستّة عشر"}]'::jsonb, 'a', 'العدد 5 016 = 5 آلاف + 0 مئات + 1 عشرات + 6 آحاد، أي ستّة عشر في صنف الوحدات، فيُقرأ «خمسة آلاف وستّة عشر».', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7956ede4-fb20-57de-aced-9557cbaca630', 'c36679ee-80b0-51b6-8c7f-8f85b19fae95', 'أيّ الأعداد التالية هو الأقرب إلى 5 000؟', '[{"id":"a","text":"4 700"},{"id":"b","text":"4 800"},{"id":"c","text":"5 300"},{"id":"d","text":"4 950"}]'::jsonb, 'd', 'نحسب بُعد كلّ عددٍ عن 5 000: 4 700 يبعد 300، و 4 800 يبعد 200، و 5 300 يبعد 300، و 4 950 يبعد 50 فقط. إذن الأقرب هو 4 950.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8f453ee0-5277-5d32-b15c-ad64e9ab53bc', 'c36679ee-80b0-51b6-8c7f-8f85b19fae95', 'إذا دوّرنا كلًّا من 6 749 و 6 751 إلى أقرب مئة، فماذا نحصل على التوالي؟', '[{"id":"a","text":"6 700 و 6 700"},{"id":"b","text":"6 800 و 6 800"},{"id":"c","text":"6 700 و 6 800"},{"id":"d","text":"6 800 و 6 700"}]'::jsonb, 'c', 'في 6 749 رقم العشرات 4 (أقلّ من 5) فيُدوَّر إلى 6 700؛ وفي 6 751 رقم العشرات 5 (≥ 5) فيُدوَّر إلى 6 800. إذن النتيجة 6 700 و 6 800.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9453a405-81d6-5d9b-ac16-0acf66a9e9d4', 'c36679ee-80b0-51b6-8c7f-8f85b19fae95', 'ما أصغر عددٍ طبيعيّ مكوَّن من أربعة أرقام؟', '[{"id":"a","text":"0"},{"id":"b","text":"1 000"},{"id":"c","text":"1 111"},{"id":"d","text":"9 999"}]'::jsonb, 'b', 'أصغر عددٍ من أربعة أرقام يبدأ برقمٍ غير الصفر في رتبة الآلاف ثمّ أصغر ما يمكن بعده: 1 ثمّ ثلاثة أصفار، أي 1 000. (و 9 999 هو الأكبر من أربعة أرقام.)', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1cdf46a6-cc85-5fc0-a186-0a6f0573ed74', '04715775-0b39-57ae-8721-5cf64ba3fe74', 'math-4eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('de407ffe-6871-5174-8cf6-fb1fbad64739', '1cdf46a6-cc85-5fc0-a186-0a6f0573ed74', 'في العدد 47 305، ما رتبة الرقم 4؟', '[{"id":"a","text":"العشرات"},{"id":"b","text":"المئات"},{"id":"c","text":"الآلاف"},{"id":"d","text":"عشرات الآلاف"}]'::jsonb, 'd', 'في 47 305 صنف الآلاف هو 47؛ الرقم 7 آلاف والرقم 4 في رتبة عشرات الآلاف، فقيمته 40 000.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('26b231a1-b5b1-5af6-90de-27993b68720d', '1cdf46a6-cc85-5fc0-a186-0a6f0573ed74', 'كيف يُقرأ العدد 23 040؟', '[{"id":"a","text":"ثلاثة وعشرون ألفًا وأربعمئة"},{"id":"b","text":"مئتان وثلاثون ألفًا وأربعون"},{"id":"c","text":"ثلاثة وعشرون ألفًا وأربعون"},{"id":"d","text":"ألفان وثلاثمئة وأربعون"}]'::jsonb, 'c', 'صنف الآلاف هو 23 (ثلاثة وعشرون ألفًا)، وصنف الوحدات هو 040 أي أربعون. فيُقرأ «ثلاثة وعشرون ألفًا وأربعون».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6b7bac15-beb7-529a-b752-765373e479b1', '1cdf46a6-cc85-5fc0-a186-0a6f0573ed74', 'كيف نكتب بالأرقام العددَ «خمسة عشر ألفًا وثلاثة»؟', '[{"id":"a","text":"1 503"},{"id":"b","text":"15 003"},{"id":"c","text":"15 030"},{"id":"d","text":"15 300"}]'::jsonb, 'b', 'خمسة عشر ألفًا = 15 000، وثلاثة آحاد = 3، مع أصفارٍ في المئات والعشرات، فيكون العدد 15 003.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b015f604-65bc-59c4-bb5e-612650e8dbb5', '1cdf46a6-cc85-5fc0-a186-0a6f0573ed74', 'ما العلاقة الصحيحة بين العددين 8 999 و 12 000؟', '[{"id":"a","text":"8 999 < 12 000"},{"id":"b","text":"8 999 = 12 000"},{"id":"c","text":"8 999 > 12 000"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'a', 'للعدد 8 999 أربعة أرقام وللعدد 12 000 خمسة أرقام؛ والأكثر أرقامًا هو الأكبر، إذن 8 999 < 12 000.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('367386f7-d61c-58be-8e3d-3ad72e3f4d10', '1cdf46a6-cc85-5fc0-a186-0a6f0573ed74', 'ما القيمة المقرّبة للعدد 47 305 إلى أقرب عشرة آلاف؟', '[{"id":"a","text":"40 000"},{"id":"b","text":"47 000"},{"id":"c","text":"47 300"},{"id":"d","text":"50 000"}]'::jsonb, 'd', 'للتدوير إلى أقرب عشرة آلاف ننظر إلى رقم الآلاف: هو 7 (≥ 5)، فنُدوّر إلى الأعلى. إذن 47 305 يصبح 50 000.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('789989c5-4a44-5e35-8e80-6574250a997b', '04715775-0b39-57ae-8721-5cf64ba3fe74', 'math-4eme', '⭐ تمرين: في رحاب عشرات الآلاف', 1, 50, 10, 'practice', 'admin', 1)
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
  ('e4d19f9a-0635-52c6-8ef8-68502644fc4d', '789989c5-4a44-5e35-8e80-6574250a997b', 'في العدد 36 218، ما رتبة الرقم 3؟', '[{"id":"a","text":"العشرات"},{"id":"b","text":"المئات"},{"id":"c","text":"الآلاف"},{"id":"d","text":"عشرات الآلاف"}]'::jsonb, 'd', 'في 36 218 صنف الآلاف هو 36؛ الرقم 6 آلاف والرقم 3 في رتبة عشرات الآلاف، فقيمته 30 000.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e07318f-3e0c-537c-ac6c-715b97c2a5e4', '789989c5-4a44-5e35-8e80-6574250a997b', 'كيف يُقرأ العدد 50 200؟', '[{"id":"a","text":"خمسون ألفًا ومئتان"},{"id":"b","text":"خمسة آلاف ومئتان"},{"id":"c","text":"خمسون ألفًا واثنان"},{"id":"d","text":"خمسمئة ألفٍ ومئتان"}]'::jsonb, 'a', 'صنف الآلاف هو 50 (خمسون ألفًا)، وصنف الوحدات هو 200 (مئتان). فيُقرأ «خمسون ألفًا ومئتان».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d2bbb97b-3ac0-5bff-9e35-cc0d89fc0d89', '789989c5-4a44-5e35-8e80-6574250a997b', 'كيف نكتب بالأرقام العددَ «اثنا عشر ألفًا»؟', '[{"id":"a","text":"1 200"},{"id":"b","text":"12 000"},{"id":"c","text":"12 012"},{"id":"d","text":"120 000"}]'::jsonb, 'b', 'اثنا عشر ألفًا = 12 × 1000 = 12 000، مع أصفارٍ في المئات والعشرات والآحاد.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('852ed74c-f789-5ad5-b642-0597f8c83f3d', '789989c5-4a44-5e35-8e80-6574250a997b', 'أيّ تفكيكٍ يوافق العدد 30 405؟', '[{"id":"a","text":"3 × 1000 + 4 × 100 + 5"},{"id":"b","text":"3 × 10000 + 4 × 10 + 5"},{"id":"c","text":"34 × 1000 + 5"},{"id":"d","text":"3 × 10000 + 4 × 100 + 5"}]'::jsonb, 'd', 'العدد 30 405 = 3 عشرات آلاف + 0 آلاف + 4 مئات + 0 عشرات + 5 آحاد، أي 3 × 10000 + 4 × 100 + 5.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4c90b1ea-ee81-5631-a4c4-49cf59672159', '789989c5-4a44-5e35-8e80-6574250a997b', 'ما العلاقة الصحيحة بين العددين 19 800 و 19 080؟', '[{"id":"a","text":"19 800 < 19 080"},{"id":"b","text":"19 800 = 19 080"},{"id":"c","text":"19 800 > 19 080"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'c', 'نقارن من اليسار: عشرات الآلاف والآلاف متساوية (1 و 9)، ثمّ المئات: 8 > 0. إذن 19 800 > 19 080.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('522871d2-e558-55b0-abcf-58dde22f78a7', '789989c5-4a44-5e35-8e80-6574250a997b', 'ما العدد الطبيعيّ الذي يسبق مباشرةً العددَ 40 000؟', '[{"id":"a","text":"39 990"},{"id":"b","text":"39 999"},{"id":"c","text":"40 001"},{"id":"d","text":"40 100"}]'::jsonb, 'b', 'العدد السابق مباشرةً يساوي العددَ ناقص 1: 40 000 − 1 = 39 999.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a35f0805-b9cf-5884-b56c-5711fffcfeb1', '04715775-0b39-57ae-8721-5cf64ba3fe74', 'math-4eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد عشرات الآلاف', 3, 120, 30, 'boss', 'admin', 2)
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
  ('d5af2d3e-f592-5c63-9b7e-98786c8192ab', 'a35f0805-b9cf-5884-b56c-5711fffcfeb1', 'عددٌ صنفُ آلافه 18 وصنفُ وحداته 207. ما هو؟', '[{"id":"a","text":"18 270"},{"id":"b","text":"18 207"},{"id":"c","text":"18 027"},{"id":"d","text":"180 207"}]'::jsonb, 'b', 'صنف الآلاف 18 يُكتب في رتبتَي الآلاف وعشرات الآلاف، وصنف الوحدات 207 في المئات والعشرات والآحاد، فيكون العدد 18 207.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('be1cc105-8ca3-5731-93bd-f8fb5bf2ff5e', 'a35f0805-b9cf-5884-b56c-5711fffcfeb1', 'ما القيمة المقرّبة للعدد 62 480 إلى أقرب مئة؟', '[{"id":"a","text":"62 000"},{"id":"b","text":"62 400"},{"id":"c","text":"62 480"},{"id":"d","text":"62 500"}]'::jsonb, 'd', 'للتدوير إلى أقرب مئة ننظر إلى رقم العشرات: هو 8 (≥ 5)، فنُدوّر إلى الأعلى. إذن 62 480 يصبح 62 500.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('421bb0d4-3c57-569a-b320-6114007d4fe2', 'a35f0805-b9cf-5884-b56c-5711fffcfeb1', 'ما الترتيب التصاعديّ الصحيح للأعداد 21 099 و 21 990 و 21 909؟', '[{"id":"a","text":"21 099 < 21 909 < 21 990"},{"id":"b","text":"21 099 < 21 990 < 21 909"},{"id":"c","text":"21 909 < 21 099 < 21 990"},{"id":"d","text":"21 990 < 21 909 < 21 099"}]'::jsonb, 'a', 'صنف الآلاف نفسه (21)؛ نقارن المئات: 0 (في 21 099) الأصغر، ثمّ بين 21 909 و 21 990 نقارن العشرات: 0 < 9. إذن 21 099 < 21 909 < 21 990.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d895722-d8e6-5151-8915-6a1d98dbb4ac', 'a35f0805-b9cf-5884-b56c-5711fffcfeb1', 'أيّ الأعداد التالية يُدوَّر إلى 30 000 عند تدويره إلى أقرب عشرة آلاف؟', '[{"id":"a","text":"18 000"},{"id":"b","text":"24 000"},{"id":"c","text":"32 700"},{"id":"d","text":"46 000"}]'::jsonb, 'c', 'يُدوَّر العدد إلى 30 000 إذا وقع بين 25 000 و 34 999. الرقم 32 700 رقمُ آلافه 2 (أقلّ من 5) فيبقى في رتبة 30 000. أمّا 18 000 و 24 000 فيُدوَّران إلى 20 000، و 46 000 إلى 50 000.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af4bfd03-b58d-5fdf-b810-6b36b18a1950', 'a35f0805-b9cf-5884-b56c-5711fffcfeb1', 'باستعمال الأرقام 8 و 1 و 0 و 5 و 3 مرّةً واحدة لكلٍّ منها، ما أكبر عددٍ يمكن تكوينه؟', '[{"id":"a","text":"83 510"},{"id":"b","text":"85 130"},{"id":"c","text":"85 301"},{"id":"d","text":"85 310"}]'::jsonb, 'd', 'نضع أكبر رقمٍ في أعلى رتبة، ثمّ نتنازل: 8 ثمّ 5 ثمّ 3 ثمّ 1 ثمّ 0، فنحصل على 85 310.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('96e931b9-433b-5449-9132-4598bb0308b8', 'a35f0805-b9cf-5884-b56c-5711fffcfeb1', 'باستعمال الأرقام 8 و 1 و 0 و 5 و 3 مرّةً واحدة لكلٍّ منها، ما أصغر عددٍ من خمسة أرقام يمكن تكوينه؟', '[{"id":"a","text":"80 135"},{"id":"b","text":"10 358"},{"id":"c","text":"10 385"},{"id":"d","text":"13 058"}]'::jsonb, 'b', 'لا يبدأ العدد بالصفر، فنضع 1 (أصغر رقمٍ غير الصفر) في عشرات الآلاف، ثمّ نرتّب الباقي تصاعديًّا 0 ثمّ 3 ثمّ 5 ثمّ 8: 10 358.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('bebb64ec-ac80-59aa-bf3e-35e2f44f276f', '04715775-0b39-57ae-8721-5cf64ba3fe74', 'math-4eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الأعداد إلى 99999', 2, 70, 15, 'practice', 'admin', 3)
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
  ('0734c142-e9f9-55a6-a55f-11f90759937f', 'bebb64ec-ac80-59aa-bf3e-35e2f44f276f', 'ما قيمة الرقم 5 في العدد 25 600؟', '[{"id":"a","text":"5"},{"id":"b","text":"50"},{"id":"c","text":"500"},{"id":"d","text":"5 000"}]'::jsonb, 'd', 'في 25 600 الرقم 5 في رتبة الآلاف، فقيمته 5 × 1000 = 5 000.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('725e6fe2-eb76-5ef4-bd9b-c1a30e0fcfb4', 'bebb64ec-ac80-59aa-bf3e-35e2f44f276f', 'كيف يُقرأ العدد 40 015؟', '[{"id":"a","text":"أربعة آلاف وخمسة عشر"},{"id":"b","text":"أربعون ألفًا وخمسون"},{"id":"c","text":"أربعون ألفًا وخمسة عشر"},{"id":"d","text":"أربعمئة ألفٍ وخمسة عشر"}]'::jsonb, 'c', 'صنف الآلاف 40 (أربعون ألفًا)، وصنف الوحدات 015 أي خمسة عشر. فيُقرأ «أربعون ألفًا وخمسة عشر».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fc71293f-af3c-5cb2-beb5-415584314ee0', 'bebb64ec-ac80-59aa-bf3e-35e2f44f276f', 'كيف نكتب بالأرقام العددَ «ثلاثون ألفًا وستّمئة»؟', '[{"id":"a","text":"30 600"},{"id":"b","text":"3 600"},{"id":"c","text":"30 060"},{"id":"d","text":"36 000"}]'::jsonb, 'a', 'ثلاثون ألفًا = 30 000، وستّمئة = 600، مع صفرٍ في العشرات وصفرٍ في الآحاد، فيكون العدد 30 600.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3ab2de6f-3e34-55ee-802a-27e9b5b29082', 'bebb64ec-ac80-59aa-bf3e-35e2f44f276f', 'ما العلاقة الصحيحة بين العددين 17 070 و 17 700؟', '[{"id":"a","text":"17 070 = 17 700"},{"id":"b","text":"17 070 < 17 700"},{"id":"c","text":"17 070 > 17 700"},{"id":"d","text":"لا يمكن المقارنة"}]'::jsonb, 'b', 'نقارن من اليسار: عشرات الآلاف والآلاف متساوية (1 و 7)، ثمّ المئات: 0 < 7. إذن 17 070 < 17 700.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2855819-c279-5f2c-b315-deadd9b43983', 'bebb64ec-ac80-59aa-bf3e-35e2f44f276f', 'ما القيمة المقرّبة للعدد 34 712 إلى أقرب ألف؟', '[{"id":"a","text":"34 000"},{"id":"b","text":"34 700"},{"id":"c","text":"34 710"},{"id":"d","text":"35 000"}]'::jsonb, 'd', 'للتدوير إلى أقرب ألف ننظر إلى رقم المئات: هو 7 (≥ 5)، فنُدوّر إلى الأعلى. إذن 34 712 يصبح 35 000.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('90a4460c-8ce9-520e-90c1-c12d36b8e1f3', 'bebb64ec-ac80-59aa-bf3e-35e2f44f276f', 'أيّ عددٍ يساوي 6 × 10000 + 2 × 1000 + 5 × 10؟', '[{"id":"a","text":"6 250"},{"id":"b","text":"62 050"},{"id":"c","text":"62 500"},{"id":"d","text":"62 005"}]'::jsonb, 'b', '6 × 10000 = 60 000، و 2 × 1000 = 2 000، و 5 × 10 = 50، ولا مئات ولا آحاد، فيكون العدد 62 050.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2472a4bb-fe42-5e82-82f1-246187df2ecd', '04715775-0b39-57ae-8721-5cf64ba3fe74', 'math-4eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز عشرات الآلاف', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('d644f959-eea8-5d95-a959-6532c08d8075', '2472a4bb-fe42-5e82-82f1-246187df2ecd', 'كم عددًا طبيعيًّا يقع تمامًا بين 29 998 و 30 002 (دون أن نَعُدّهما)؟', '[{"id":"a","text":"2"},{"id":"b","text":"3"},{"id":"c","text":"4"},{"id":"d","text":"5"}]'::jsonb, 'b', 'الأعداد الواقعة بينهما هي 29 999 و 30 000 و 30 001، أي 3 أعداد. لا نَعُدّ 29 998 ولا 30 002 لأنّ السؤال يستثنيهما.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08a67320-40a6-56ed-ae4f-a081b60f36e8', '2472a4bb-fe42-5e82-82f1-246187df2ecd', 'عددٌ إذا دُوِّر إلى أقرب عشرة آلاف أعطى 40 000. ما أكبر قيمةٍ ممكنة له؟', '[{"id":"a","text":"40 000"},{"id":"b","text":"44 000"},{"id":"c","text":"44 999"},{"id":"d","text":"45 000"}]'::jsonb, 'c', 'يُدوَّر العدد إلى 40 000 إذا وقع بين 35 000 و 44 999 (لأنّ 45 000 يُدوَّر إلى 50 000). فأكبر قيمةٍ ممكنة هي 44 999.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f1b3ac1-f517-50c0-9f92-8bc6bfad2a64', '2472a4bb-fe42-5e82-82f1-246187df2ecd', 'ما أكبر عددٍ من خمسة أرقام رقمُ عشرات آلافه 7 ورقمُ آحاده 0؟', '[{"id":"a","text":"79 990"},{"id":"b","text":"79 900"},{"id":"c","text":"70 990"},{"id":"d","text":"79 999"}]'::jsonb, 'a', 'رقم عشرات الآلاف مثبَّت (7) والآحاد مثبَّت (0)؛ لجعله أكبر ما يمكن نختار 9 للآلاف والمئات والعشرات، فنحصل على 79 990. أمّا 79 999 فرقمُ آحاده 9 لا 0.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8a98c6e8-bdab-5fd0-aeb9-93f1fe7999c0', '2472a4bb-fe42-5e82-82f1-246187df2ecd', 'أنا عددٌ من خمسة أرقام: رقمُ عشرات آلافي 5، وأرقامُ آلافي ومئاتي وعشراتي أصفار، ورقمُ آحادي يساوي رقمَ عشرات آلافي ناقص 2. من أكون؟', '[{"id":"a","text":"50 300"},{"id":"b","text":"50 003"},{"id":"c","text":"52 000"},{"id":"d","text":"50 030"}]'::jsonb, 'b', 'رقم عشرات الآلاف 5، والآلاف والمئات والعشرات أصفار. ورقم الآحاد = 5 − 2 = 3. إذن العدد 50 003.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dfd12b21-d154-5e8e-9421-4c6e5f834d5d', '2472a4bb-fe42-5e82-82f1-246187df2ecd', 'ما الترتيب التنازليّ الصحيح للأعداد 60 060 و 60 600 و 60 006؟', '[{"id":"a","text":"60 006 > 60 060 > 60 600"},{"id":"b","text":"60 060 > 60 600 > 60 006"},{"id":"c","text":"60 600 > 60 006 > 60 060"},{"id":"d","text":"60 600 > 60 060 > 60 006"}]'::jsonb, 'd', 'صنف الآلاف نفسه (60)؛ نقارن المئات: 6 (في 60 600) الأكبر، ثمّ بين 60 060 و 60 006 نقارن العشرات: 6 > 0. إذن تنازليًّا: 60 600 > 60 060 > 60 006.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('501de559-2b46-512f-a2f4-bac2e0218956', '2472a4bb-fe42-5e82-82f1-246187df2ecd', 'باستعمال الأرقام 4 و 8 و 0 و 2 و 1 مرّةً واحدة لكلٍّ منها، ما العدد (من خمسة أرقام) الأقرب إلى 50 000؟', '[{"id":"a","text":"48 210"},{"id":"b","text":"48 120"},{"id":"c","text":"42 810"},{"id":"d","text":"41 280"}]'::jsonb, 'a', 'لا يوجد الرقم 5، فأقرب عددٍ إلى 50 000 هو أكبر عددٍ أقلّ منه: نبدأ بـ 4 ثمّ نتنازل 8 ثمّ 2 ثمّ 1 ثمّ 0، أي 48 210 (الفرق 1 790). بقيّة التكوينات أبعد عن 50 000.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('739dd918-14c9-5ac7-8d76-3a84db2cf24c', '04715775-0b39-57ae-8721-5cf64ba3fe74', 'math-4eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للأعداد إلى 99999', 3, 120, 30, 'boss', 'admin', 5)
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
  ('8e196184-c181-59c9-9672-839b6e2c333f', '739dd918-14c9-5ac7-8d76-3a84db2cf24c', 'ما قيمة الرقم 9 في العدد 91 234؟', '[{"id":"a","text":"9"},{"id":"b","text":"900"},{"id":"c","text":"9 000"},{"id":"d","text":"90 000"}]'::jsonb, 'd', 'في 91 234 الرقم 9 في رتبة عشرات الآلاف، فقيمته 9 × 10000 = 90 000.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a1f3e80-6acd-569b-86b9-886d3292722a', '739dd918-14c9-5ac7-8d76-3a84db2cf24c', 'كيف يُقرأ العدد 70 003؟', '[{"id":"a","text":"سبعة آلاف وثلاثة"},{"id":"b","text":"سبعون ألفًا وثلاثون"},{"id":"c","text":"سبعون ألفًا وثلاثة"},{"id":"d","text":"سبعمئة ألفٍ وثلاثة"}]'::jsonb, 'c', 'صنف الآلاف 70 (سبعون ألفًا)، وصنف الوحدات 003 أي ثلاثة. فيُقرأ «سبعون ألفًا وثلاثة».', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb01e64b-767f-59d3-b009-e6c2263a1dea', '739dd918-14c9-5ac7-8d76-3a84db2cf24c', 'كيف نكتب بالأرقام العددَ «أربعة وعشرون ألفًا وخمسون»؟', '[{"id":"a","text":"2 450"},{"id":"b","text":"24 050"},{"id":"c","text":"24 005"},{"id":"d","text":"24 500"}]'::jsonb, 'b', 'أربعة وعشرون ألفًا = 24 000، وخمسون = 50، مع صفرٍ في المئات وصفرٍ في الآحاد، فيكون العدد 24 050.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('294354a2-50a1-567a-98fb-d277f7e6c5c4', '739dd918-14c9-5ac7-8d76-3a84db2cf24c', 'أيّ الأعداد التالية هو الأقرب إلى 30 000؟', '[{"id":"a","text":"27 000"},{"id":"b","text":"29 900"},{"id":"c","text":"30 050"},{"id":"d","text":"33 000"}]'::jsonb, 'c', 'نحسب بُعد كلّ عددٍ عن 30 000: 27 000 يبعد 3 000، و 29 900 يبعد 100، و 30 050 يبعد 50، و 33 000 يبعد 3 000. إذن الأقرب هو 30 050.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9b6acf1-bbb7-5fcb-a84a-54ff2dc30a80', '739dd918-14c9-5ac7-8d76-3a84db2cf24c', 'إذا دوّرنا كلًّا من 35 499 و 35 500 إلى أقرب ألف، فماذا نحصل على التوالي؟', '[{"id":"a","text":"35 000 و 36 000"},{"id":"b","text":"35 000 و 35 000"},{"id":"c","text":"36 000 و 36 000"},{"id":"d","text":"36 000 و 35 000"}]'::jsonb, 'a', 'في 35 499 رقم المئات 4 (أقلّ من 5) فيُدوَّر إلى 35 000؛ وفي 35 500 رقم المئات 5 (≥ 5) فيُدوَّر إلى 36 000. إذن النتيجة 35 000 و 36 000.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1631948-8c13-500a-ab4d-18472c97aa8f', '739dd918-14c9-5ac7-8d76-3a84db2cf24c', 'ما أكبر عددٍ طبيعيّ مكوَّن من خمسة أرقام؟', '[{"id":"a","text":"10 000"},{"id":"b","text":"11 111"},{"id":"c","text":"90 000"},{"id":"d","text":"99 999"}]'::jsonb, 'd', 'أكبر عددٍ من خمسة أرقام يضع أكبر رقمٍ (9) في كلّ الرتب الخمس، أي 99 999. (و 10 000 هو الأصغر من خمسة أرقام.)', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b535a3ad-6896-52fb-b6ca-8a0bc1bfccd5', 'af509553-26c9-5d21-bbfe-3ed8114bf196', 'math-4eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d3b0ac0f-26bc-5b80-88f2-212416bc865d', 'b535a3ad-6896-52fb-b6ca-8a0bc1bfccd5', 'ما مجموع 3 245 + 1 132؟', '[{"id":"a","text":"4 277"},{"id":"b","text":"4 367"},{"id":"c","text":"4 377"},{"id":"d","text":"4 477"}]'::jsonb, 'c', 'نجمع رتبةً رتبةً دون احتفاظ: 5 + 2 = 7 آحاد، 4 + 3 = 7 عشرات، 2 + 1 = 3 مئات، 3 + 1 = 4 آلاف. المجموع 4 377.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('029069b8-d4bd-55c0-9d21-5dafa84c531e', 'b535a3ad-6896-52fb-b6ca-8a0bc1bfccd5', 'ما الفرق 754 − 318؟', '[{"id":"a","text":"436"},{"id":"b","text":"444"},{"id":"c","text":"446"},{"id":"d","text":"536"}]'::jsonb, 'a', 'الآحاد: 4 أصغر من 8 فنستلف: 14 − 8 = 6. العشرات: صارت 4 − 1 = 3. المئات: 7 − 3 = 4. إذن 754 − 318 = 436.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('39eb085e-ee0b-516a-9b56-6f4a4947150c', 'b535a3ad-6896-52fb-b6ca-8a0bc1bfccd5', 'أيّ مساواةٍ تعبّر عن تبديليّة الجمع؟', '[{"id":"a","text":"234 + 0 = 234"},{"id":"b","text":"234 + 566 = 566 + 234"},{"id":"c","text":"234 − 566 = 566 − 234"},{"id":"d","text":"234 + 566 = 234 − 566"}]'::jsonb, 'b', 'التبديليّة تعني أنّ تبديل ترتيب الحدّين لا يغيّر المجموع: 234 + 566 = 566 + 234. أمّا الطرح فليس تبديليًّا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14dde8da-655b-5cbf-8963-b2243df6f711', 'b535a3ad-6896-52fb-b6ca-8a0bc1bfccd5', 'ما الفرق 6 005 − 1 248؟', '[{"id":"a","text":"4 657"},{"id":"b","text":"4 747"},{"id":"c","text":"4 753"},{"id":"d","text":"4 757"}]'::jsonb, 'd', 'نطرح مع الاستلاف عبر الأصفار: 6 005 − 1 248 = 4 757. للتثبّت: 4 757 + 1 248 = 6 005 ✓.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9334ab8b-b2b8-55bd-afa5-619cb63de274', 'b535a3ad-6896-52fb-b6ca-8a0bc1bfccd5', 'ما العدد المجهول في المساواة: ? + 150 = 480؟', '[{"id":"a","text":"330"},{"id":"b","text":"450"},{"id":"c","text":"630"},{"id":"d","text":"660"}]'::jsonb, 'a', 'لإيجاد الحدّ المجهول في جمعٍ نطرح الحدّ المعلوم من المجموع: ? = 480 − 150 = 330. تحقّق: 330 + 150 = 480 ✓.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3e967624-a330-57f0-83bd-006a130d6277', 'af509553-26c9-5d21-bbfe-3ed8114bf196', 'math-4eme', '⭐ تمرين: أوّل معارك الجمع والطرح', 1, 50, 10, 'practice', 'admin', 1)
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
  ('4c7e30bd-e584-544f-bd59-81d75fe1627f', '3e967624-a330-57f0-83bd-006a130d6277', 'ما مجموع 2 314 + 1 263؟', '[{"id":"a","text":"3 477"},{"id":"b","text":"3 567"},{"id":"c","text":"3 577"},{"id":"d","text":"3 677"}]'::jsonb, 'c', 'نجمع رتبةً رتبةً دون احتفاظ: 4 + 3 = 7، 1 + 6 = 7، 3 + 2 = 5، 2 + 1 = 3. المجموع 3 577.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0b5be84a-d654-5035-8f54-75b504fa6775', '3e967624-a330-57f0-83bd-006a130d6277', 'ما الفرق 486 − 254؟', '[{"id":"a","text":"222"},{"id":"b","text":"232"},{"id":"c","text":"242"},{"id":"d","text":"332"}]'::jsonb, 'b', 'نطرح رتبةً رتبةً دون استلاف: 6 − 4 = 2، 8 − 5 = 3، 4 − 2 = 2. الفرق 232.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('414ba6f6-ab03-56ab-9f48-80d42b4fb008', '3e967624-a330-57f0-83bd-006a130d6277', 'ما مجموع 3 528 + 1 247؟', '[{"id":"a","text":"4 675"},{"id":"b","text":"4 765"},{"id":"c","text":"4 770"},{"id":"d","text":"4 775"}]'::jsonb, 'd', 'الآحاد: 8 + 7 = 15، نكتب 5 ونحتفظ بـ 1. العشرات: 2 + 4 + 1 = 7. المئات: 5 + 2 = 7. الآلاف: 3 + 1 = 4. المجموع 4 775.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce27632f-881e-5829-962c-c34bc4129fed', '3e967624-a330-57f0-83bd-006a130d6277', 'ما الفرق 905 − 327؟', '[{"id":"a","text":"578"},{"id":"b","text":"582"},{"id":"c","text":"588"},{"id":"d","text":"678"}]'::jsonb, 'a', 'الآحاد: 5 أصغر من 7 فنستلف: 15 − 7 = 8. العشرات: صارت 0 ثمّ نستلف: 10 − 2 = 8. المئات: صارت 8 − 3 = 5. الفرق 578.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('404d95a1-ce38-58f3-acb4-389fc3cd5915', '3e967624-a330-57f0-83bd-006a130d6277', 'ما العدد المجهول في المساواة: ? + 120 = 300؟', '[{"id":"a","text":"160"},{"id":"b","text":"180"},{"id":"c","text":"220"},{"id":"d","text":"420"}]'::jsonb, 'b', 'نطرح الحدّ المعلوم من المجموع: ? = 300 − 120 = 180. تحقّق: 180 + 120 = 300 ✓.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4acd465b-e489-5b2a-b8b0-c91b78a15e8c', '3e967624-a330-57f0-83bd-006a130d6277', 'كم نضيف إلى 360 لنحصل على 400؟', '[{"id":"a","text":"40"},{"id":"b","text":"60"},{"id":"c","text":"140"},{"id":"d","text":"440"}]'::jsonb, 'a', 'المطلوب هو 400 − 360 = 40. تحقّق: 360 + 40 = 400 ✓.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1951560a-05a9-52fb-8d09-000f80412655', 'af509553-26c9-5d21-bbfe-3ed8114bf196', 'math-4eme', '⚔️ زعيم الفصل ⭐⭐⭐: معركة الاحتفاظ والاستلاف', 3, 120, 30, 'boss', 'admin', 2)
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
  ('5d6b3647-420e-57c1-9e35-b193ef692584', '1951560a-05a9-52fb-8d09-000f80412655', 'ما مجموع 4 678 + 3 859؟', '[{"id":"a","text":"8 427"},{"id":"b","text":"8 437"},{"id":"c","text":"8 527"},{"id":"d","text":"8 537"}]'::jsonb, 'd', 'الآحاد: 8 + 9 = 17، نكتب 7 ونحتفظ بـ 1. العشرات: 7 + 5 + 1 = 13، نكتب 3 ونحتفظ بـ 1. المئات: 6 + 8 + 1 = 15، نكتب 5 ونحتفظ بـ 1. الآلاف: 4 + 3 + 1 = 8. المجموع 8 537.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6545db63-73ff-5578-9bdc-45b391636594', '1951560a-05a9-52fb-8d09-000f80412655', 'ما الفرق 8 003 − 4 567؟', '[{"id":"a","text":"3 336"},{"id":"b","text":"3 426"},{"id":"c","text":"3 436"},{"id":"d","text":"3 536"}]'::jsonb, 'c', 'نطرح مع الاستلاف عبر الأصفار: 8 003 − 4 567 = 3 436. للتثبّت: 3 436 + 4 567 = 8 003 ✓.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d7c9ae52-db90-5beb-aa4d-6e7cfd210ce6', '1951560a-05a9-52fb-8d09-000f80412655', 'في مكتبةٍ 12 450 كتابًا، أُضيف إليها 3 675 كتابًا جديدًا. كم صار عدد الكتب؟', '[{"id":"a","text":"16 125"},{"id":"b","text":"15 025"},{"id":"c","text":"16 025"},{"id":"d","text":"16 225"}]'::jsonb, 'a', '«أُضيف» يعني الجمع: 12 450 + 3 675 = 16 125 كتابًا. (الآحاد 0 + 5 = 5، والعشرات 5 + 7 = 12 مع احتفاظ…).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e4ad8e2-7256-5cce-92fd-050b292ed62d', '1951560a-05a9-52fb-8d09-000f80412655', 'كان عدّاد سيّارةٍ يشير إلى 28 400 كم، فصار يشير إلى 33 000 كم. كم كيلومترًا قطعت؟', '[{"id":"a","text":"4 500"},{"id":"b","text":"4 600"},{"id":"c","text":"5 400"},{"id":"d","text":"5 600"}]'::jsonb, 'b', 'المسافة المقطوعة هي الفرق بين القراءتين: 33 000 − 28 400 = 4 600 كم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('02a5c8f6-662c-5387-84e6-0572643dc3ca', '1951560a-05a9-52fb-8d09-000f80412655', 'ما العدد المجهول في المساواة: ? − 1 250 = 3 480؟', '[{"id":"a","text":"2 230"},{"id":"b","text":"4 730"},{"id":"c","text":"4 630"},{"id":"d","text":"4 830"}]'::jsonb, 'b', 'بما أنّ ? − 1 250 = 3 480 فإنّ ? = 3 480 + 1 250 = 4 730. تحقّق: 4 730 − 1 250 = 3 480 ✓.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('451cd894-acfa-5ec4-a704-5519af1bb8b6', '1951560a-05a9-52fb-8d09-000f80412655', 'ما نتيجة 2 500 + 1 750 − 900؟', '[{"id":"a","text":"3 250"},{"id":"b","text":"3 350"},{"id":"c","text":"3 450"},{"id":"d","text":"5 150"}]'::jsonb, 'b', 'ننجز العمليّتين بالترتيب: 2 500 + 1 750 = 4 250، ثمّ 4 250 − 900 = 3 350.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('eaa51ddb-dc08-5f57-b00f-ed10a30aff09', 'af509553-26c9-5d21-bbfe-3ed8114bf196', 'math-4eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الجمع والطرح', 2, 70, 15, 'practice', 'admin', 3)
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
  ('440ce391-174c-552c-a182-534ba5b151f6', 'eaa51ddb-dc08-5f57-b00f-ed10a30aff09', 'ما مجموع 5 142 + 2 736؟', '[{"id":"a","text":"7 778"},{"id":"b","text":"7 868"},{"id":"c","text":"7 878"},{"id":"d","text":"7 978"}]'::jsonb, 'c', 'نجمع رتبةً رتبةً دون احتفاظ: 2 + 6 = 8، 4 + 3 = 7، 1 + 7 = 8، 5 + 2 = 7. المجموع 7 878.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13cbcd1a-3b33-5423-b1e0-0352fb633d45', 'eaa51ddb-dc08-5f57-b00f-ed10a30aff09', 'ما الفرق 4 300 − 1 850؟', '[{"id":"a","text":"2 350"},{"id":"b","text":"2 450"},{"id":"c","text":"2 550"},{"id":"d","text":"3 450"}]'::jsonb, 'b', 'نطرح مع الاستلاف: 4 300 − 1 850 = 2 450. للتثبّت: 2 450 + 1 850 = 4 300 ✓.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87e813c7-094d-55f1-86a8-ec583b61e9d4', 'eaa51ddb-dc08-5f57-b00f-ed10a30aff09', 'ما مجموع 1 250 + 3 750؟', '[{"id":"a","text":"4 000"},{"id":"b","text":"4 900"},{"id":"c","text":"4 990"},{"id":"d","text":"5 000"}]'::jsonb, 'd', 'نجمع الآحاد فالعشرات فالمئات: 250 + 750 = 1 000، ثمّ 1 000 + 1 250 + 3 750 يعطي 5 000.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0c5d04e4-72b3-5fdb-8da9-0002b242163f', 'eaa51ddb-dc08-5f57-b00f-ed10a30aff09', 'ما العدد المجهول في المساواة: 900 − ? = 540؟', '[{"id":"a","text":"360"},{"id":"b","text":"460"},{"id":"c","text":"540"},{"id":"d","text":"1 440"}]'::jsonb, 'a', 'لإيجاد المطروح المجهول نطرح الفرق من المطروح منه: ? = 900 − 540 = 360. تحقّق: 900 − 360 = 540 ✓.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08bda3fd-04a4-5319-a1c6-31a90ccda056', 'eaa51ddb-dc08-5f57-b00f-ed10a30aff09', 'ما نتيجة 4 + 96 + 250 (باستعمال أسهل ترتيب)؟', '[{"id":"a","text":"250"},{"id":"b","text":"340"},{"id":"c","text":"346"},{"id":"d","text":"350"}]'::jsonb, 'd', 'بالتجميعيّة نجمع أوّلًا 4 + 96 = 100، ثمّ 100 + 250 = 350.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8e322ef7-ec82-5f46-a2ec-b8c6eec74598', 'eaa51ddb-dc08-5f57-b00f-ed10a30aff09', 'ما الفرق 7 654 − 3 654؟', '[{"id":"a","text":"3 000"},{"id":"b","text":"4 000"},{"id":"c","text":"4 100"},{"id":"d","text":"11 308"}]'::jsonb, 'b', 'بما أنّ رقمَي صنف الوحدات متساويان (654 = 654)، يبقى الفرق في صنف الآلاف: 7 − 3 = 4، أي 4 000.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('992245fb-6ccc-57a7-b5ba-ef41540a37ad', 'af509553-26c9-5d21-bbfe-3ed8114bf196', 'math-4eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: مسائل الجمع والطرح', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('d6521925-927d-58af-8473-12bd846dc5f2', '992245fb-6ccc-57a7-b5ba-ef41540a37ad', 'عددٌ مضافًا إليه 2 480 يعطي 7 000. ما هو هذا العدد؟', '[{"id":"a","text":"4 420"},{"id":"b","text":"4 520"},{"id":"c","text":"4 620"},{"id":"d","text":"5 520"}]'::jsonb, 'b', 'نطرح الحدّ المعلوم من المجموع: 7 000 − 2 480 = 4 520. تحقّق: 4 520 + 2 480 = 7 000 ✓.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f59ef8fd-1393-50cd-af4b-16e5d829666b', '992245fb-6ccc-57a7-b5ba-ef41540a37ad', 'ادّخر تلميذٌ 1 250 مليمًا، ثمّ أنفق 480 مليمًا، ثمّ ادّخر 1 000 مليمٍ أخرى. كم صار لديه؟', '[{"id":"a","text":"1 670"},{"id":"b","text":"1 730"},{"id":"c","text":"1 770"},{"id":"d","text":"2 730"}]'::jsonb, 'c', 'ننجز العمليّات بالترتيب: 1 250 − 480 = 770، ثمّ 770 + 1 000 = 1 770 مليمًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('15fa5f7d-147f-5134-b480-2580f7989b04', '992245fb-6ccc-57a7-b5ba-ef41540a37ad', 'ما حاصل جمع أكبر عددٍ من ثلاثة أرقام مع أصغر عددٍ من أربعة أرقام؟', '[{"id":"a","text":"1 099"},{"id":"b","text":"1 909"},{"id":"c","text":"1 990"},{"id":"d","text":"1 999"}]'::jsonb, 'd', 'أكبر عددٍ من ثلاثة أرقام هو 999، وأصغر عددٍ من أربعة أرقام هو 1 000، فمجموعهما 999 + 1 000 = 1 999.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad3e6515-ee0b-559f-90eb-acaa14ae424e', '992245fb-6ccc-57a7-b5ba-ef41540a37ad', 'ما العدد المجهول في المساواة: ? − 1 500 − 2 300 = 1 200؟', '[{"id":"a","text":"2 600"},{"id":"b","text":"4 000"},{"id":"c","text":"5 000"},{"id":"d","text":"5 300"}]'::jsonb, 'c', 'نعكس العمليّات: ? = 1 200 + 2 300 + 1 500 = 5 000. تحقّق: 5 000 − 1 500 − 2 300 = 1 200 ✓.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('27e2f790-6bb1-596a-aeb9-b1fae7ddfa52', '992245fb-6ccc-57a7-b5ba-ef41540a37ad', 'في بستانٍ 4 250 شجرة: 1 800 زيتون و 950 لوز، والباقي برتقال. كم عدد أشجار البرتقال؟', '[{"id":"a","text":"1 500"},{"id":"b","text":"1 600"},{"id":"c","text":"2 450"},{"id":"d","text":"3 300"}]'::jsonb, 'a', 'نطرح ما عُرف من المجموع: 4 250 − 1 800 − 950 = 1 500 شجرة برتقال. (أو نجمع 1 800 + 950 = 2 750 ثمّ 4 250 − 2 750 = 1 500.)', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ddf6a8e-f6b0-57d6-bbee-6a6834e24d77', '992245fb-6ccc-57a7-b5ba-ef41540a37ad', 'ما نتيجة 12 000 − 4 500 − 2 800؟', '[{"id":"a","text":"4 600"},{"id":"b","text":"4 700"},{"id":"c","text":"5 300"},{"id":"d","text":"6 700"}]'::jsonb, 'b', 'ننجز الطرحين بالترتيب: 12 000 − 4 500 = 7 500، ثمّ 7 500 − 2 800 = 4 700.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b1cb17bf-bf14-5f5c-adfc-e03156f99920', 'af509553-26c9-5d21-bbfe-3ed8114bf196', 'math-4eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للجمع والطرح', 3, 120, 30, 'boss', 'admin', 5)
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
  ('77cd03b9-c9b6-5fdd-8632-305ba23552ce', 'b1cb17bf-bf14-5f5c-adfc-e03156f99920', 'ما مجموع 6 472 + 2 838؟', '[{"id":"a","text":"9 210"},{"id":"b","text":"9 300"},{"id":"c","text":"9 310"},{"id":"d","text":"9 410"}]'::jsonb, 'c', 'الآحاد: 2 + 8 = 10، نكتب 0 ونحتفظ بـ 1. العشرات: 7 + 3 + 1 = 11، نكتب 1 ونحتفظ بـ 1. المئات: 4 + 8 + 1 = 13، نكتب 3 ونحتفظ بـ 1. الآلاف: 6 + 2 + 1 = 9. المجموع 9 310.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('12c06f18-0dfa-534a-b48f-4c48e70d143c', 'b1cb17bf-bf14-5f5c-adfc-e03156f99920', 'ما الفرق 5 600 − 2 850؟', '[{"id":"a","text":"2 650"},{"id":"b","text":"2 750"},{"id":"c","text":"2 850"},{"id":"d","text":"3 750"}]'::jsonb, 'b', 'نطرح مع الاستلاف: 5 600 − 2 850 = 2 750. للتثبّت: 2 750 + 2 850 = 5 600 ✓.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f6d8f01b-17de-5fbe-b35d-e32a5becf9be', 'b1cb17bf-bf14-5f5c-adfc-e03156f99920', 'أيّ مجموعٍ يساوي 10 000؟', '[{"id":"a","text":"4 600 + 5 000"},{"id":"b","text":"4 600 + 5 200"},{"id":"c","text":"4 600 + 5 300"},{"id":"d","text":"4 600 + 5 400"}]'::jsonb, 'd', 'نبحث عن المكمّل لـ 4 600 إلى 10 000: هو 10 000 − 4 600 = 5 400. إذن 4 600 + 5 400 = 10 000.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5595fc5-b6f5-51b7-9072-be66c38e8cb8', 'b1cb17bf-bf14-5f5c-adfc-e03156f99920', 'في قطارٍ 1 280 راكبًا؛ في محطّةٍ نزل 475 راكبًا وصعد 690. كم صار عدد الرّكّاب؟', '[{"id":"a","text":"1 395"},{"id":"b","text":"1 495"},{"id":"c","text":"1 595"},{"id":"d","text":"2 445"}]'::jsonb, 'b', 'ننقص النازلين ونزيد الصاعدين: 1 280 − 475 = 805، ثمّ 805 + 690 = 1 495 راكبًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bfbf3a32-84ec-5e06-8294-e076554ba90d', 'b1cb17bf-bf14-5f5c-adfc-e03156f99920', 'ما العدد المجهول في المساواة: ? + 2 600 = 3 000؟', '[{"id":"a","text":"400"},{"id":"b","text":"600"},{"id":"c","text":"5 400"},{"id":"d","text":"5 600"}]'::jsonb, 'a', 'نطرح الحدّ المعلوم من المجموع: ? = 3 000 − 2 600 = 400. تحقّق: 400 + 2 600 = 3 000 ✓.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('316e1ef9-27f6-5a24-baeb-55668d684024', 'b1cb17bf-bf14-5f5c-adfc-e03156f99920', 'ما مجموع 4 870 + 3 120؟', '[{"id":"a","text":"7 890"},{"id":"b","text":"7 980"},{"id":"c","text":"7 990"},{"id":"d","text":"8 090"}]'::jsonb, 'c', 'الآحاد: 0 + 0 = 0. العشرات: 7 + 2 = 9. المئات: 8 + 1 = 9. الآلاف: 4 + 3 = 7. المجموع 7 990.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('414f92be-14bd-51c6-b505-c5cfbcff91c6', '98f8395c-1912-5475-ae45-d93d5f2ffc6f', 'math-4eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('99a720b4-3745-5932-a21f-983ed5bfab10', '414f92be-14bd-51c6-b505-c5cfbcff91c6', 'ما جداء 7 × 6؟', '[{"id":"a","text":"36"},{"id":"b","text":"42"},{"id":"c","text":"48"},{"id":"d","text":"56"}]'::jsonb, 'b', '7 × 6 يعني جمع 6 سبع مرّات (أو 7 ستّ مرّات)، والنتيجة 42 حسب جدول الضرب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2defd0c3-900b-5955-8868-0047350d92bb', '414f92be-14bd-51c6-b505-c5cfbcff91c6', 'ما جداء 38 × 100؟', '[{"id":"a","text":"380"},{"id":"b","text":"3 080"},{"id":"c","text":"3 800"},{"id":"d","text":"38 000"}]'::jsonb, 'c', 'للضرب في 100 نضيف صفرين على يمين العدد: 38 × 100 = 3 800.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bcc15adc-de8a-5a63-82ae-1aa1dcb055ed', '414f92be-14bd-51c6-b505-c5cfbcff91c6', 'أيّ مساواةٍ تعبّر عن تبديليّة الضرب؟', '[{"id":"a","text":"6 × 4 = 4 × 6"},{"id":"b","text":"6 × 4 = 6 + 4"},{"id":"c","text":"6 × 4 = 24 + 6"},{"id":"d","text":"6 × 4 = 12 × 2"}]'::jsonb, 'a', 'التبديليّة تعني أنّ تبديل ترتيب العاملين لا يغيّر الجداء: 6 × 4 = 4 × 6 = 24.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3302bf2f-57c3-567b-81af-76b083003874', '414f92be-14bd-51c6-b505-c5cfbcff91c6', 'ما جداء 213 × 24؟', '[{"id":"a","text":"4 260"},{"id":"b","text":"5 012"},{"id":"c","text":"5 100"},{"id":"d","text":"5 112"}]'::jsonb, 'd', 'بالتوزيعيّة: 213 × 24 = 213 × 20 + 213 × 4 = 4 260 + 852 = 5 112.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f07e809-1a53-5c16-af15-84d43cf47676', '414f92be-14bd-51c6-b505-c5cfbcff91c6', 'باستعمال التوزيعيّة، ما جداء 8 × 13؟', '[{"id":"a","text":"96"},{"id":"b","text":"104"},{"id":"c","text":"112"},{"id":"d","text":"824"}]'::jsonb, 'b', '8 × 13 = 8 × (10 + 3) = 8 × 10 + 8 × 3 = 80 + 24 = 104.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('835b8c59-6eaa-547f-b42a-0cef079d9cb2', '98f8395c-1912-5475-ae45-d93d5f2ffc6f', 'math-4eme', '⭐ تمرين: أوّل خطوات في الضرب', 1, 50, 10, 'practice', 'admin', 1)
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
  ('88fca28d-9ec7-5454-89df-fcdcb199100a', '835b8c59-6eaa-547f-b42a-0cef079d9cb2', 'ما جداء 8 × 7؟', '[{"id":"a","text":"48"},{"id":"b","text":"54"},{"id":"c","text":"56"},{"id":"d","text":"63"}]'::jsonb, 'c', '8 × 7 = 56 حسب جدول الضرب (جمع 7 ثماني مرّات).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f9f15e51-b93e-5d19-bf72-eaeaf590b572', '835b8c59-6eaa-547f-b42a-0cef079d9cb2', 'ما جداء 9 × 6؟', '[{"id":"a","text":"45"},{"id":"b","text":"54"},{"id":"c","text":"56"},{"id":"d","text":"63"}]'::jsonb, 'b', '9 × 6 = 54 حسب جدول الضرب (جمع 6 تسع مرّات).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('15ebc4b0-78ed-5b34-bc29-d99d540cfa48', '835b8c59-6eaa-547f-b42a-0cef079d9cb2', 'ما جداء 25 × 10؟', '[{"id":"a","text":"250"},{"id":"b","text":"2 500"},{"id":"c","text":"205"},{"id":"d","text":"35"}]'::jsonb, 'a', 'للضرب في 10 نضيف صفرًا واحدًا على يمين العدد: 25 × 10 = 250.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e2abb38-1f26-5ac5-9427-1e96227f0c78', '835b8c59-6eaa-547f-b42a-0cef079d9cb2', 'ما جداء 132 × 3؟', '[{"id":"a","text":"336"},{"id":"b","text":"366"},{"id":"c","text":"393"},{"id":"d","text":"396"}]'::jsonb, 'd', 'نضرب من اليمين: 2 × 3 = 6، 3 × 3 = 9، 1 × 3 = 3. الجداء 396.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed821292-f466-5032-bd55-8955bb242429', '835b8c59-6eaa-547f-b42a-0cef079d9cb2', 'ما جداء 213 × 2؟', '[{"id":"a","text":"226"},{"id":"b","text":"416"},{"id":"c","text":"426"},{"id":"d","text":"436"}]'::jsonb, 'c', 'نضرب من اليمين: 3 × 2 = 6، 1 × 2 = 2، 2 × 2 = 4. الجداء 426.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4ef607d8-48cb-5084-9534-cc9abec978eb', '835b8c59-6eaa-547f-b42a-0cef079d9cb2', 'ما جداء 6 × 100؟', '[{"id":"a","text":"60"},{"id":"b","text":"600"},{"id":"c","text":"6 000"},{"id":"d","text":"106"}]'::jsonb, 'b', 'للضرب في 100 نضيف صفرين على يمين العدد: 6 × 100 = 600.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('000fc0e3-f7ea-5058-a909-efe142f04a4f', '98f8395c-1912-5475-ae45-d93d5f2ffc6f', 'math-4eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّد الجداءات', 3, 120, 30, 'boss', 'admin', 2)
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
  ('01dcfdf2-9494-5bb2-9beb-0d2b648227f9', '000fc0e3-f7ea-5058-a909-efe142f04a4f', 'ما جداء 347 × 4؟', '[{"id":"a","text":"1 288"},{"id":"b","text":"1 388"},{"id":"c","text":"1 468"},{"id":"d","text":"1 488"}]'::jsonb, 'b', 'نضرب مع الاحتفاظ: 7 × 4 = 28 (نكتب 8 ونحتفظ بـ 2)، 4 × 4 = 16 زائد 2 = 18 (نكتب 8 ونحتفظ بـ 1)، 3 × 4 = 12 زائد 1 = 13. الجداء 1 388.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba3a2db6-0c84-5695-8a22-682a78a3f0b1', '000fc0e3-f7ea-5058-a909-efe142f04a4f', 'ما جداء 256 × 6؟', '[{"id":"a","text":"1 436"},{"id":"b","text":"1 506"},{"id":"c","text":"1 526"},{"id":"d","text":"1 536"}]'::jsonb, 'd', 'نضرب مع الاحتفاظ: 6 × 6 = 36 (نكتب 6 ونحتفظ بـ 3)، 5 × 6 = 30 زائد 3 = 33 (نكتب 3 ونحتفظ بـ 3)، 2 × 6 = 12 زائد 3 = 15. الجداء 1 536.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('80e43d2b-627c-5386-8666-7a411a069d4f', '000fc0e3-f7ea-5058-a909-efe142f04a4f', 'ما جداء 124 × 23؟', '[{"id":"a","text":"2 752"},{"id":"b","text":"2 842"},{"id":"c","text":"2 852"},{"id":"d","text":"2 952"}]'::jsonb, 'c', 'بالتوزيعيّة: 124 × 23 = 124 × 20 + 124 × 3 = 2 480 + 372 = 2 852.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4e7ec573-b20e-5e2c-a95a-dff46f6bcfad', '000fc0e3-f7ea-5058-a909-efe142f04a4f', 'علبةٌ فيها 48 قلمًا. كم قلمًا في 25 علبة؟', '[{"id":"a","text":"1 200"},{"id":"b","text":"1 220"},{"id":"c","text":"1 250"},{"id":"d","text":"1 280"}]'::jsonb, 'a', 'العدد الإجماليّ = عدد العلب × عدد الأقلام في كلٍّ: 25 × 48 = 1 200 قلمًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98c54e25-c01a-5729-b965-7d0bf1c1c1b9', '000fc0e3-f7ea-5058-a909-efe142f04a4f', 'ما جداء 305 × 7؟', '[{"id":"a","text":"2 035"},{"id":"b","text":"2 135"},{"id":"c","text":"2 415"},{"id":"d","text":"2 450"}]'::jsonb, 'b', 'نضرب مع الاحتفاظ: 5 × 7 = 35 (نكتب 5 ونحتفظ بـ 3)، 0 × 7 = 0 زائد 3 = 3، 3 × 7 = 21. الجداء 2 135.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('183f0d5e-549c-5467-8abc-da2c84afbc20', '000fc0e3-f7ea-5058-a909-efe142f04a4f', 'ما جداء 215 × 30؟', '[{"id":"a","text":"6 150"},{"id":"b","text":"6 250"},{"id":"c","text":"6 350"},{"id":"d","text":"6 450"}]'::jsonb, 'd', '215 × 30 = 215 × 3 × 10 = 645 × 10 = 6 450 (نضرب في 3 ثمّ نضيف صفرًا).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('60a81108-c031-589b-8b88-d02eddd4dcb6', '98f8395c-1912-5475-ae45-d93d5f2ffc6f', 'math-4eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الضرب', 2, 70, 15, 'practice', 'admin', 3)
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
  ('7177ad2d-2696-5d96-80f8-980646dd1b3c', '60a81108-c031-589b-8b88-d02eddd4dcb6', 'ما جداء 6 × 8؟', '[{"id":"a","text":"42"},{"id":"b","text":"48"},{"id":"c","text":"54"},{"id":"d","text":"56"}]'::jsonb, 'b', '6 × 8 = 48 حسب جدول الضرب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8aa762bd-b295-52ad-b693-317851d582bf', '60a81108-c031-589b-8b88-d02eddd4dcb6', 'ما جداء 47 × 10؟', '[{"id":"a","text":"47"},{"id":"b","text":"407"},{"id":"c","text":"470"},{"id":"d","text":"4 700"}]'::jsonb, 'c', 'للضرب في 10 نضيف صفرًا واحدًا على يمين العدد: 47 × 10 = 470.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0025700b-0b3c-5a1b-b67c-9771d0909dd7', '60a81108-c031-589b-8b88-d02eddd4dcb6', 'ما جداء 213 × 3؟', '[{"id":"a","text":"609"},{"id":"b","text":"619"},{"id":"c","text":"629"},{"id":"d","text":"639"}]'::jsonb, 'd', 'نضرب من اليمين: 3 × 3 = 9، 1 × 3 = 3، 2 × 3 = 6. الجداء 639.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('018c0755-7896-5a17-91e8-7530e23516d6', '60a81108-c031-589b-8b88-d02eddd4dcb6', 'ما جداء 4 × 250؟', '[{"id":"a","text":"900"},{"id":"b","text":"1 000"},{"id":"c","text":"1 040"},{"id":"d","text":"1 250"}]'::jsonb, 'b', '4 × 250 = 4 × 25 × 10 = 100 × 10 = 1 000.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('87674221-5e3f-5a41-8c78-97fb1cfa2118', '60a81108-c031-589b-8b88-d02eddd4dcb6', 'ما ناتج 1 × 587؟', '[{"id":"a","text":"0"},{"id":"b","text":"1"},{"id":"c","text":"587"},{"id":"d","text":"588"}]'::jsonb, 'c', 'العدد 1 هو العنصر المحايد للضرب، فالضرب فيه لا يغيّر العدد: 1 × 587 = 587.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e909bfca-afa2-58d3-a0dc-1efc6df0302e', '60a81108-c031-589b-8b88-d02eddd4dcb6', 'ما جداء 32 × 20؟', '[{"id":"a","text":"640"},{"id":"b","text":"620"},{"id":"c","text":"320"},{"id":"d","text":"6 400"}]'::jsonb, 'a', '32 × 20 = 32 × 2 × 10 = 64 × 10 = 640.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('705dbc07-bc85-58eb-a174-999541a00f7a', '98f8395c-1912-5475-ae45-d93d5f2ffc6f', 'math-4eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: ألغاز الضرب', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('e2cf07ac-e48f-5da3-b9e8-777cbe5a0ff5', '705dbc07-bc85-58eb-a174-999541a00f7a', 'ما جداء 125 × 8؟', '[{"id":"a","text":"900"},{"id":"b","text":"1 000"},{"id":"c","text":"1 025"},{"id":"d","text":"1 250"}]'::jsonb, 'b', '125 × 8 = 1 000 (لأنّ 125 × 8 = 125 × 2 × 2 × 2 = 250 × 2 × 2 = 500 × 2 = 1 000).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eaa67713-18cb-5fe1-b03d-42fadf00b8af', '705dbc07-bc85-58eb-a174-999541a00f7a', 'ما جداء 234 × 21؟', '[{"id":"a","text":"4 614"},{"id":"b","text":"4 714"},{"id":"c","text":"4 814"},{"id":"d","text":"4 914"}]'::jsonb, 'd', 'بالتوزيعيّة: 234 × 21 = 234 × 20 + 234 × 1 = 4 680 + 234 = 4 914.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a08cafd8-4be5-5223-887a-c9ae03b63edc', '705dbc07-bc85-58eb-a174-999541a00f7a', 'قاعةٌ فيها 28 صفًّا، وفي كلّ صفٍّ 35 كرسيًّا. كم كرسيًّا في القاعة؟', '[{"id":"a","text":"63"},{"id":"b","text":"880"},{"id":"c","text":"980"},{"id":"d","text":"1 080"}]'::jsonb, 'c', 'العدد الإجماليّ = عدد الصفوف × عدد الكراسي في الصفّ: 28 × 35 = 980 كرسيًّا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ba61da78-556d-5b85-adae-a6cb8b11d514', '705dbc07-bc85-58eb-a174-999541a00f7a', 'باستعمال التوزيعيّة، ما جداء 99 × 7؟', '[{"id":"a","text":"693"},{"id":"b","text":"700"},{"id":"c","text":"707"},{"id":"d","text":"793"}]'::jsonb, 'a', '99 = 100 − 1، فإنّ 99 × 7 = 100 × 7 − 1 × 7 = 700 − 7 = 693.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cfd725f8-95ee-5140-87ea-2377cd539b68', '705dbc07-bc85-58eb-a174-999541a00f7a', 'اشترى تاجرٌ 6 صناديق في كلٍّ منها 24 زجاجة، ثمّ بيعت 30 زجاجة. كم زجاجة بقيت؟', '[{"id":"a","text":"104"},{"id":"b","text":"110"},{"id":"c","text":"114"},{"id":"d","text":"144"}]'::jsonb, 'c', 'عدد الزجاجات أوّلًا: 6 × 24 = 144، ثمّ نطرح المبيع: 144 − 30 = 114 زجاجة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16febc0a-2d1f-5304-ab0b-6ee6d114a28c', '705dbc07-bc85-58eb-a174-999541a00f7a', 'أيّ جداءٍ ممّا يلي يساوي 3 600؟', '[{"id":"a","text":"40 × 80"},{"id":"b","text":"60 × 60"},{"id":"c","text":"50 × 60"},{"id":"d","text":"90 × 50"}]'::jsonb, 'b', 'نحسب: 40 × 80 = 3 200، و 60 × 60 = 3 600، و 50 × 60 = 3 000، و 90 × 50 = 4 500. إذن 60 × 60 = 3 600.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c83ff5b2-9818-5123-b509-9371285d1a8b', '98f8395c-1912-5475-ae45-d93d5f2ffc6f', 'math-4eme', '📝 تدريب ⭐⭐⭐: مراجعة شاملة للضرب', 3, 120, 30, 'boss', 'admin', 5)
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
  ('48b07ec0-f0d2-5773-8985-c92f58765dba', 'c83ff5b2-9818-5123-b509-9371285d1a8b', 'ما جداء 9 × 9؟', '[{"id":"a","text":"18"},{"id":"b","text":"72"},{"id":"c","text":"81"},{"id":"d","text":"99"}]'::jsonb, 'c', '9 × 9 = 81 حسب جدول الضرب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ad1948f3-3a15-58db-acdc-c4ea93356da7', 'c83ff5b2-9818-5123-b509-9371285d1a8b', 'ما جداء 408 × 5؟', '[{"id":"a","text":"2 000"},{"id":"b","text":"2 040"},{"id":"c","text":"2 050"},{"id":"d","text":"2 400"}]'::jsonb, 'b', 'نضرب مع الاحتفاظ: 8 × 5 = 40 (نكتب 0 ونحتفظ بـ 4)، 0 × 5 = 0 زائد 4 = 4، 4 × 5 = 20. الجداء 2 040.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('13e951de-18b6-54a8-a269-88e0d6c6b88d', 'c83ff5b2-9818-5123-b509-9371285d1a8b', 'ما جداء 73 × 100؟', '[{"id":"a","text":"7 300"},{"id":"b","text":"730"},{"id":"c","text":"73"},{"id":"d","text":"73 000"}]'::jsonb, 'a', 'للضرب في 100 نضيف صفرين على يمين العدد: 73 × 100 = 7 300.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ebd5c4d4-c7ab-5780-8fe4-5392ce26ec62', 'c83ff5b2-9818-5123-b509-9371285d1a8b', 'ما جداء 152 × 14؟', '[{"id":"a","text":"2 028"},{"id":"b","text":"2 108"},{"id":"c","text":"2 118"},{"id":"d","text":"2 128"}]'::jsonb, 'd', 'بالتوزيعيّة: 152 × 14 = 152 × 10 + 152 × 4 = 1 520 + 608 = 2 128.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7838a935-5234-5026-9c24-d65b028c2498', 'c83ff5b2-9818-5123-b509-9371285d1a8b', 'تقطع حافلةٌ 240 كم يوميًّا. كم كيلومترًا تقطع في 15 يومًا؟', '[{"id":"a","text":"3 400"},{"id":"b","text":"3 600"},{"id":"c","text":"3 500"},{"id":"d","text":"3 700"}]'::jsonb, 'b', 'المسافة الإجماليّة = المسافة اليوميّة × عدد الأيّام: 240 × 15 = 3 600 كم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de7c550a-5c30-5755-8b90-bfd98ad88eef', 'c83ff5b2-9818-5123-b509-9371285d1a8b', 'ما ناتج 736 × 0؟', '[{"id":"a","text":"1"},{"id":"b","text":"736"},{"id":"c","text":"730"},{"id":"d","text":"0"}]'::jsonb, 'd', 'الصفر عنصرٌ ماحٍ للضرب: ضربُ أيّ عددٍ في 0 يعطي 0 دائمًا، فإنّ 736 × 0 = 0.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

