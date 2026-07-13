-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: french-3eme (Français)
-- Regenerate with: npm run content:build
-- Source of truth: content/french-3eme/
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
  ('french-3eme', 'Français', 'Première année de français : nous apprenons à écouter et à parler (saluer, se présenter, nommer, décrire, poser des questions simples), à entrer dans la lecture en associant les sons et les lettres (déchiffrer des syllabes, des mots et de courtes phrases), et à écrire en lettres minuscules. Au fil de huit thèmes — la famille, l''école, le corps, les aliments, les animaux, le livre, les jeux et la fête — nous enrichissons notre vocabulaire, nous travaillons la prononciation des sons du français et nous comptons de 1 à 30, selon le programme officiel de français de la 3ᵉ année de l''enseignement de base.', 'Sagesse', 'subject-french', 'BookOpen', 4, 'fr', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '3eme-base'))
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
      AND e.subject_id = 'french-3eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('d40a93c8-4a89-5bd7-aaab-7c28b91524f1', 'cb06b55e-9ec1-599c-bfd5-e5d8f3fab0df', 'b1e4f5b2-43d3-575d-b46f-121eebdb5616', '2c1ccef3-2fc0-5ba9-b874-af149129a9eb', '29a5c2c3-b473-59e1-9edf-bc2677dcd53d', 'd8d3aabe-8a59-503e-baf3-15aef14eb6d8', '3faf3680-6a8c-582f-8326-96ce79f0ee3d', '7d37a669-33b4-5c9b-bb49-8cb9deb5e311', 'bd20f4e6-6ca9-5922-933b-edaf014cca67', 'b0b5ec5e-d7bc-5e0c-95fe-037c25e8e276', '25e40252-faef-5704-959b-d9f3e5e12c19', '6968da3d-7923-58ab-a1f2-aa99c6ed29e4', 'abbef869-f0f0-576d-82ec-62999857f86c', '829275ce-9574-5642-b40b-ccc7392f904b', 'f8b8591e-021e-5ca2-9d78-faf839ba7692', 'bff16267-e699-53cb-baa0-d91c87160cb9', '79556161-e1b2-5838-8309-8f876b1597bd', 'c682fe47-cff2-58e5-86d2-4f6b45891f98', 'add5974c-365e-53e4-a20c-444bb2f58e41', '594f0eee-16b9-5e18-9a16-d8fcc443d721', '01f30970-55dd-5eef-9125-ac863e6d0193', 'eeee92fd-fcfa-5f8c-ba76-3ed21005ef66', '73eefc10-1e5f-5388-8785-f5100b24c64d', '29fde2ee-36fe-58cd-b61f-ed230b323b8f', 'fbfca64e-6263-51c5-abfa-3ec5f5598c26', '9c2a6a51-7f21-5eae-9f69-ffc204d08ef1', '8e074005-3314-5124-8d06-19029c3814be', '6e0f3fba-878f-579b-a471-8163504583c6', 'cd76747b-6fb0-5b40-bdf2-f08c142d3874', '55ca44ff-8927-594d-9034-12134491c788', 'e14b3c48-f7a0-50ba-9ada-adf99fe7548e', '12893cfc-5024-5d0e-b19d-9b2631073b28', '9c0e7f7f-2a9c-50c0-8d05-e45edc5ec1b5', 'b85c9fa3-468d-560f-a026-848fd3678d82', 'd360b515-7e41-50f7-a876-9f045cceb9c5', 'e1a1e336-223f-5b6b-a26d-dce47762b9be', '9508aef8-f295-5a61-aace-9b3735425374', 'd23b6153-139e-5c57-a3e0-529ab6726802', '64b2d8da-d1f5-5abe-826c-2379feed64c7', '9e73560d-bf13-5519-bf5e-29dd9d7dce00', 'd9c8e67b-8d52-5448-9287-e91dc61fba25', 'f0b7b4b3-ef4e-54cf-9118-871e84115a26', '54ae9f52-d006-5fec-a810-45a982195732', '59a8296d-2ca5-5f02-9de2-0c9f85ad919a', 'da9c4c77-5e2b-5836-989c-c69766ae39b7', 'f79ad9a4-ad00-5bfd-bea5-f9f20f177978', 'f15cde06-f499-557c-bd64-547b4707404f', '729828ca-2326-548c-a68a-2ac252f1c918', 'd5f9a9d1-da2d-5fa3-9dfb-9dc355e18b8d', '7734d4c8-04d5-5739-95ef-42f60603bb02', 'ce9cc688-36be-5cb7-84c6-42ae6e8a8368', '0b0efe57-fac1-5816-b0eb-4802c83cb50d', 'bf9f72fe-9559-5f5c-860a-c3f52f677ce6', 'a5105259-3f30-5401-8735-ab4e797969a3', 'd3116b03-9e86-5f35-9790-efb5c37311c1', '05024b0b-89cc-515e-86fc-69cd356cf760', 'c3792795-1e63-5370-a1f4-7f54991d9caf', '47b6c045-2bdf-57f7-871f-6932c24dffc4', '5254f554-ceef-586a-b4de-fbd461158427', '99b20fa5-8d21-5d7d-bf98-55040d703681', '37fb1222-28be-5e5a-ba6d-bcaf1c109f0b', '2652b061-b025-5ba4-9ebd-910a0175a6ed', 'e58ef6a2-4434-551d-8e71-0ac9c0a87263', '415d5a09-bb03-5dcd-8d91-a6f21ac10b74', '014cf8a5-2647-5e36-964c-83b4f73dda7d', 'f9b9efb1-a8ef-55b1-b76f-bc8c0fe66444', '7421dc69-3c87-50d8-ab11-32c00c095552', 'e0413769-b122-57cd-bc6f-a013468ffeb9', '7a1bb4b3-9354-5a86-9f73-d9265b429135', '69f26143-f692-5b95-802e-d829a15a3021', '1d39b7fc-5897-5754-afce-f9a87a121138', 'bbcf3400-6991-50ca-85cb-29aee05d78c7', 'fa2bfcaa-e70d-51f2-a163-955b81a66df1', '71228add-734d-5908-9da0-b0132d7578a6', '804f07e5-7bae-51b8-bf2d-609a9b049a47', '7fb61a66-cfcf-517e-8400-56583b979bf4', '62fd5f9d-a00a-5c3b-abe1-1f038c869c4d', '02863ddf-7815-51ef-ac63-ee188ca5bd38', '5423da57-e071-55c7-bb45-586869d59d44', '48fcaac1-5a2d-5d90-88ef-6b59250a0e89', 'cbd5a0f0-6fdf-5b98-a169-cb7046b134f9', '1f4410d2-4f80-5a1e-a021-5a4f4c6074e0', '2bfd2635-5170-5f52-9837-9c74d33461e4', '60bbf1c9-cf5b-5300-b371-0bb02a6ef34e', 'fdb439e3-e8cd-5ffa-afd1-dc5e6ad02b00', '0410219d-308c-56cb-b8af-b145ed36ec22', '2d3c5573-7276-559a-9fe8-67956f563967', '3e3df111-1329-510b-ac84-ef26e572977c', '1d9b20b7-8eff-5f08-8cd8-9302030e7812', 'dd462ee7-632d-5c17-ba33-c39821d8c154', '7da834b5-314f-5a7b-9c2f-13fd6dba79ee', 'bdd182b6-fad2-51d2-b5b5-2891d7a4f7a0', 'd924508f-cfbe-5803-8269-2a8cf71507bb', 'f16ebb7a-67e3-5a43-a51b-1fa3d3dc4840', 'd1c05e55-10d7-5bc6-b519-e153f4d7220b', 'f7de79fd-9c1b-5cf0-83eb-ad94cbfd1bd1', '3da6c76d-5b7d-5e56-939c-a12809333a55', '83b6036c-dc7d-5e6f-bf7f-5d86cc2f7163', '55471905-c960-5731-987d-d77a2b72f07a', '77c1ed4b-6f62-5118-8906-cb68524f46a1', 'da025371-d89d-5043-a08d-8bb8395f5213', '98a4c74a-4439-5c84-ab4f-c4d2bd474792', '4e504e4b-bb77-5fe9-b689-89c76ab0e41b', '9296fb04-ec6e-57f4-8632-820c90db05a5', '74b91b90-e9e2-5226-8c08-fe5fc3406d46', 'fa9f40c5-c02c-5c20-9e70-1e987ff7e232', '23eda5c8-6bdb-5f59-a9a5-8648a9eec022', '9e887d61-2bc0-59f9-9de2-f39ad356d634', 'c184d782-8cfd-572f-b902-f4f7f3eda058', 'af0e7bb2-47de-5561-aab8-30b15c8d825a', '5c560397-f5ae-5816-98c6-47118c588da2', 'd096a0c1-aa38-5ec9-8966-9c4627f88c83', '1d457b65-3c6a-5fa5-8512-e62d1f848f83', '04c7a430-2d0d-5489-896a-cf0052ccba5a', '30bda6d7-c0d1-534e-a470-0a85fbf0bbb2', '8498444c-7a5e-5284-be13-3d453fc076dd', '31985503-d3a2-5039-b409-936294be08c2', '10ee235d-8024-5e4d-bdda-2f5befdcfcbe', 'f1f985df-2a39-5225-af80-09c6b74623cb', 'b3cf6ff6-e317-59df-9b7c-e61ed76fa0da', '0b78d09e-6557-5d0e-b7cc-afa07e172267', '548fea8e-8b1f-540a-9c94-2e8917ccf8f2', '25ddf88e-2437-5489-8e8e-a6c10f0024d4', 'd2aea363-8bcc-58d7-9b66-bfbb9f73f106', '26fd41c6-bf9c-557d-a05b-d947d43e2052', '1e6356e9-3e0e-5fa4-b00b-8b48f7c3a8d4', 'e2d8bfc2-77b1-5c56-8c7d-8552451dcc70', '2e825dfb-548b-50e6-81d6-28d09797c579', '76f1bd57-99c5-596e-b74b-b6f4d1160c28', 'e273fa03-ea03-580c-af48-f748d399cef2', '0a972080-ddd7-5f99-83b0-cda02b6131a3', 'bc01ce9a-a808-57c3-a5b8-31cb8d71ea09', 'b26ab546-7052-5b70-a703-9de7cc1cf469', 'd23359b1-a7aa-5172-a664-2fe766625e62', '8147a071-8f86-5672-b4ac-6f50a1d25db7', 'aa9358c8-d4e6-56c5-8726-678767577103', 'd0c0a898-6bfa-5fe2-8340-4b6856f4cb46', 'eca30035-228f-56ff-8ab6-f9da371b5d29', '1c696444-6420-540d-a1e2-ba5a8381d784', '2481a5f6-f6bb-546d-a389-28783c16bb17', 'e9423c94-dd3a-5eda-a988-0f3f8accdfac', '1be9dd6b-ab20-552f-9414-a4291bf2bae8', '484eccc7-3966-5f51-b427-4c4fab9663f2', 'ef2fb6b8-ea29-55b1-802a-4ede94c86df0', 'ffb3e825-0bf8-5d50-941c-bd24fc57c634', '404dafa3-b8ff-5852-8c09-c2a94efecc87', '3b212333-34db-5674-a5e8-2c941971b8bd', '4a2c86f4-668e-5f5a-8467-7aaf8cb3f623', 'f7df9cc2-3a67-5933-bbcc-8632e4bee30e', 'd843e075-4e4c-55e4-b31f-70f06375cebf', 'a2d7801e-e1ca-5609-81af-31a43aac89f8', '3962471d-13be-58c5-9e38-b26a8266f83d', '6570694f-9020-5c20-8491-590d0e5ed585', 'ee9bc776-ed07-5f67-9fec-1a4914563d76', 'f2e40359-e6a6-5978-9651-9e4d3bf6c7f4', '96c37135-feb5-5324-8e15-0defc400fbde', '5b0249fa-6521-53d3-b8b7-4ee357374fa4', '833f947d-6f04-5e89-9d54-4d9a5180cd72', '343c98b4-b4a4-511d-ad74-ce9c20da4075', 'a9864def-7fd9-5c86-bd57-3e3e6512cc55', '4571cf31-645a-560a-98f8-32e765c549e8', 'ccd344c0-da82-5485-84a3-062e1b3a045b', '73c35dda-5e03-55a1-bde2-f977a9a9ac60', '01fa02c2-b3db-5717-aea4-b507a0ed3bb8', '052908dc-28b7-5d75-a865-6e0c26b85584', '5a4320f7-91f4-5594-903c-27f7e79cddb7', '7816d344-9145-53ee-8b50-8e24634c8331', '2788d7ef-e795-5bdd-ba1b-b4225ed9bcdc', '36f84981-a3e1-5149-8248-16f1782f845a', '76dbe8a5-d2ad-594e-b688-e6df0e58b1d7', '23a4c81b-0ed0-554e-81f5-826561543ee3', '7364f343-f013-5881-8676-3cd6c9a3a94b', 'bbe92ec0-254a-54b5-8106-33f7ae20a2c2', '78e38dcf-1b45-5f69-bbdb-3e6859c6b1e1', '540a81ff-40c8-563d-a6b5-cc50cd19f28e', '35747898-71f6-5555-bdcc-1fbe9a75379f', '0c797549-54d8-5292-b4a2-f734b4fe2a6b', 'eda30fdc-f9f4-5ffa-bf4e-aa0f4874f2b6', 'b0e6794e-7fec-589e-966e-acc6309a9825', '65808528-8e7a-5cc8-953a-00c99912845b', '63f5afc3-da0b-5133-87e3-5b1f6e4c2cd9', 'e522eef3-42b4-5aa5-8f60-5ac839817a60', '004e0069-0b5a-50fb-aeb6-b817c8b66a8d', '74a30f22-1442-5150-8197-8a98d5a8226b', 'c4b3de53-b96f-5441-baa2-fa5f214c790d', '8bf81f2f-d6ea-5a65-a195-10d2c48c8fb2', 'b2b5144f-95c0-56f0-8dcc-0c915a4a939e', '2563ca17-1ca2-5ea6-94d8-64b5ce8e9ef2', 'bcc42bdc-b5e8-53bd-ada4-f087a98245af', 'cf4942b6-8b19-5540-bf3b-f21e5c4910ce', '408dd4bd-b5ad-56b3-aa31-a2ab83bccdc8', '49248b8c-64f5-5d7a-8bd7-2116b254c330', 'ed19e978-cad3-5435-bdac-f3a19433089d', '019cce52-003c-506d-9254-0b25883a327e', '24d977bb-6ea5-5c64-a1b9-cb36c54ef9b7');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'french-3eme' AND source = 'admin' AND id NOT IN ('d6ca3f31-8038-5e5d-b150-22216fee4b46', 'f6c7ba8f-a477-57dc-89dc-b8f5a3865ad8', '3eeff9c9-2a9b-5617-9aed-4ef47a49f0a9', '6993fed0-ef22-5ab4-81b6-e75bab3f0cb4', '543d3d29-d1dc-5d6d-8f7b-bef50d1e77ea', '96b85d7f-9ca2-5306-9ed7-1875aceaf295', '9aa78bf3-725c-5d62-a99a-6bfa751780ea', '569b9851-2975-5250-ab85-804af049dc38', '323f8653-8b29-5c3e-b01d-6306610d630b', '46a6462f-c6b9-5b41-a7fa-f6ceada58b00', '06605cbe-1b69-58c0-9636-98872b253b34', '05a1db80-513a-572e-a7b2-82ae1fbd0d5a', 'ad0f3c07-865f-52ef-a38b-f97b7756c133', '44f35254-f37b-5ff4-bc37-04f4aeb3e070', '2cfa4dd4-27d1-52c1-91c9-85d6b3ecc024', '204f9ca8-f2b4-5739-b74d-066644364882', '797ce678-42ab-5b1f-b3d0-66bc74637cd8', 'f974bb00-cf29-557a-bae9-0b54ca38f5af', 'fd731c33-66db-5f12-bfbb-91fae20e1241', 'f78bf935-ec01-5bec-81eb-927f118fdd22', '6b117d8d-e59d-532e-b681-76bc066a5b29', 'ae14a6e5-b665-5aad-acdd-ae77956f307a', '871b2c45-5432-55e0-a1dc-79a68638110e', '17a4ea62-2dcc-5270-a450-c96d2918e948', '177656ab-af5f-5416-92e0-4726f44d2bf2', 'e13318a3-fdf0-51ee-9d3b-0fc05b3db172', '8617fa16-5d9d-5696-a52c-be466692afdd', '1ed7ba95-38d5-532b-b744-e70812355756', '8c2da2f7-6784-56e0-a234-2572baa75688', 'b779e8a4-b58a-5545-aa7d-d0b5ca3e6ce6', 'b55db625-747d-588b-a74c-86db5438edfa', 'd40e41bd-343c-5760-becc-cc400f68f4af', '24eed047-a578-5702-8fba-938eed20f29a', 'de58ba5f-d6f0-5331-a705-42b5bafa03b7');
DELETE FROM public.questions WHERE exercise_id IN ('d6ca3f31-8038-5e5d-b150-22216fee4b46', 'f6c7ba8f-a477-57dc-89dc-b8f5a3865ad8', '3eeff9c9-2a9b-5617-9aed-4ef47a49f0a9', '6993fed0-ef22-5ab4-81b6-e75bab3f0cb4', '543d3d29-d1dc-5d6d-8f7b-bef50d1e77ea', '96b85d7f-9ca2-5306-9ed7-1875aceaf295', '9aa78bf3-725c-5d62-a99a-6bfa751780ea', '569b9851-2975-5250-ab85-804af049dc38', '323f8653-8b29-5c3e-b01d-6306610d630b', '46a6462f-c6b9-5b41-a7fa-f6ceada58b00', '06605cbe-1b69-58c0-9636-98872b253b34', '05a1db80-513a-572e-a7b2-82ae1fbd0d5a', 'ad0f3c07-865f-52ef-a38b-f97b7756c133', '44f35254-f37b-5ff4-bc37-04f4aeb3e070', '2cfa4dd4-27d1-52c1-91c9-85d6b3ecc024', '204f9ca8-f2b4-5739-b74d-066644364882', '797ce678-42ab-5b1f-b3d0-66bc74637cd8', 'f974bb00-cf29-557a-bae9-0b54ca38f5af', 'fd731c33-66db-5f12-bfbb-91fae20e1241', 'f78bf935-ec01-5bec-81eb-927f118fdd22', '6b117d8d-e59d-532e-b681-76bc066a5b29', 'ae14a6e5-b665-5aad-acdd-ae77956f307a', '871b2c45-5432-55e0-a1dc-79a68638110e', '17a4ea62-2dcc-5270-a450-c96d2918e948', '177656ab-af5f-5416-92e0-4726f44d2bf2', 'e13318a3-fdf0-51ee-9d3b-0fc05b3db172', '8617fa16-5d9d-5696-a52c-be466692afdd', '1ed7ba95-38d5-532b-b744-e70812355756', '8c2da2f7-6784-56e0-a234-2572baa75688', 'b779e8a4-b58a-5545-aa7d-d0b5ca3e6ce6', 'b55db625-747d-588b-a74c-86db5438edfa', 'd40e41bd-343c-5760-becc-cc400f68f4af', '24eed047-a578-5702-8fba-938eed20f29a', 'de58ba5f-d6f0-5331-a705-42b5bafa03b7') AND id NOT IN ('d40a93c8-4a89-5bd7-aaab-7c28b91524f1', 'cb06b55e-9ec1-599c-bfd5-e5d8f3fab0df', 'b1e4f5b2-43d3-575d-b46f-121eebdb5616', '2c1ccef3-2fc0-5ba9-b874-af149129a9eb', '29a5c2c3-b473-59e1-9edf-bc2677dcd53d', 'd8d3aabe-8a59-503e-baf3-15aef14eb6d8', '3faf3680-6a8c-582f-8326-96ce79f0ee3d', '7d37a669-33b4-5c9b-bb49-8cb9deb5e311', 'bd20f4e6-6ca9-5922-933b-edaf014cca67', 'b0b5ec5e-d7bc-5e0c-95fe-037c25e8e276', '25e40252-faef-5704-959b-d9f3e5e12c19', '6968da3d-7923-58ab-a1f2-aa99c6ed29e4', 'abbef869-f0f0-576d-82ec-62999857f86c', '829275ce-9574-5642-b40b-ccc7392f904b', 'f8b8591e-021e-5ca2-9d78-faf839ba7692', 'bff16267-e699-53cb-baa0-d91c87160cb9', '79556161-e1b2-5838-8309-8f876b1597bd', 'c682fe47-cff2-58e5-86d2-4f6b45891f98', 'add5974c-365e-53e4-a20c-444bb2f58e41', '594f0eee-16b9-5e18-9a16-d8fcc443d721', '01f30970-55dd-5eef-9125-ac863e6d0193', 'eeee92fd-fcfa-5f8c-ba76-3ed21005ef66', '73eefc10-1e5f-5388-8785-f5100b24c64d', '29fde2ee-36fe-58cd-b61f-ed230b323b8f', 'fbfca64e-6263-51c5-abfa-3ec5f5598c26', '9c2a6a51-7f21-5eae-9f69-ffc204d08ef1', '8e074005-3314-5124-8d06-19029c3814be', '6e0f3fba-878f-579b-a471-8163504583c6', 'cd76747b-6fb0-5b40-bdf2-f08c142d3874', '55ca44ff-8927-594d-9034-12134491c788', 'e14b3c48-f7a0-50ba-9ada-adf99fe7548e', '12893cfc-5024-5d0e-b19d-9b2631073b28', '9c0e7f7f-2a9c-50c0-8d05-e45edc5ec1b5', 'b85c9fa3-468d-560f-a026-848fd3678d82', 'd360b515-7e41-50f7-a876-9f045cceb9c5', 'e1a1e336-223f-5b6b-a26d-dce47762b9be', '9508aef8-f295-5a61-aace-9b3735425374', 'd23b6153-139e-5c57-a3e0-529ab6726802', '64b2d8da-d1f5-5abe-826c-2379feed64c7', '9e73560d-bf13-5519-bf5e-29dd9d7dce00', 'd9c8e67b-8d52-5448-9287-e91dc61fba25', 'f0b7b4b3-ef4e-54cf-9118-871e84115a26', '54ae9f52-d006-5fec-a810-45a982195732', '59a8296d-2ca5-5f02-9de2-0c9f85ad919a', 'da9c4c77-5e2b-5836-989c-c69766ae39b7', 'f79ad9a4-ad00-5bfd-bea5-f9f20f177978', 'f15cde06-f499-557c-bd64-547b4707404f', '729828ca-2326-548c-a68a-2ac252f1c918', 'd5f9a9d1-da2d-5fa3-9dfb-9dc355e18b8d', '7734d4c8-04d5-5739-95ef-42f60603bb02', 'ce9cc688-36be-5cb7-84c6-42ae6e8a8368', '0b0efe57-fac1-5816-b0eb-4802c83cb50d', 'bf9f72fe-9559-5f5c-860a-c3f52f677ce6', 'a5105259-3f30-5401-8735-ab4e797969a3', 'd3116b03-9e86-5f35-9790-efb5c37311c1', '05024b0b-89cc-515e-86fc-69cd356cf760', 'c3792795-1e63-5370-a1f4-7f54991d9caf', '47b6c045-2bdf-57f7-871f-6932c24dffc4', '5254f554-ceef-586a-b4de-fbd461158427', '99b20fa5-8d21-5d7d-bf98-55040d703681', '37fb1222-28be-5e5a-ba6d-bcaf1c109f0b', '2652b061-b025-5ba4-9ebd-910a0175a6ed', 'e58ef6a2-4434-551d-8e71-0ac9c0a87263', '415d5a09-bb03-5dcd-8d91-a6f21ac10b74', '014cf8a5-2647-5e36-964c-83b4f73dda7d', 'f9b9efb1-a8ef-55b1-b76f-bc8c0fe66444', '7421dc69-3c87-50d8-ab11-32c00c095552', 'e0413769-b122-57cd-bc6f-a013468ffeb9', '7a1bb4b3-9354-5a86-9f73-d9265b429135', '69f26143-f692-5b95-802e-d829a15a3021', '1d39b7fc-5897-5754-afce-f9a87a121138', 'bbcf3400-6991-50ca-85cb-29aee05d78c7', 'fa2bfcaa-e70d-51f2-a163-955b81a66df1', '71228add-734d-5908-9da0-b0132d7578a6', '804f07e5-7bae-51b8-bf2d-609a9b049a47', '7fb61a66-cfcf-517e-8400-56583b979bf4', '62fd5f9d-a00a-5c3b-abe1-1f038c869c4d', '02863ddf-7815-51ef-ac63-ee188ca5bd38', '5423da57-e071-55c7-bb45-586869d59d44', '48fcaac1-5a2d-5d90-88ef-6b59250a0e89', 'cbd5a0f0-6fdf-5b98-a169-cb7046b134f9', '1f4410d2-4f80-5a1e-a021-5a4f4c6074e0', '2bfd2635-5170-5f52-9837-9c74d33461e4', '60bbf1c9-cf5b-5300-b371-0bb02a6ef34e', 'fdb439e3-e8cd-5ffa-afd1-dc5e6ad02b00', '0410219d-308c-56cb-b8af-b145ed36ec22', '2d3c5573-7276-559a-9fe8-67956f563967', '3e3df111-1329-510b-ac84-ef26e572977c', '1d9b20b7-8eff-5f08-8cd8-9302030e7812', 'dd462ee7-632d-5c17-ba33-c39821d8c154', '7da834b5-314f-5a7b-9c2f-13fd6dba79ee', 'bdd182b6-fad2-51d2-b5b5-2891d7a4f7a0', 'd924508f-cfbe-5803-8269-2a8cf71507bb', 'f16ebb7a-67e3-5a43-a51b-1fa3d3dc4840', 'd1c05e55-10d7-5bc6-b519-e153f4d7220b', 'f7de79fd-9c1b-5cf0-83eb-ad94cbfd1bd1', '3da6c76d-5b7d-5e56-939c-a12809333a55', '83b6036c-dc7d-5e6f-bf7f-5d86cc2f7163', '55471905-c960-5731-987d-d77a2b72f07a', '77c1ed4b-6f62-5118-8906-cb68524f46a1', 'da025371-d89d-5043-a08d-8bb8395f5213', '98a4c74a-4439-5c84-ab4f-c4d2bd474792', '4e504e4b-bb77-5fe9-b689-89c76ab0e41b', '9296fb04-ec6e-57f4-8632-820c90db05a5', '74b91b90-e9e2-5226-8c08-fe5fc3406d46', 'fa9f40c5-c02c-5c20-9e70-1e987ff7e232', '23eda5c8-6bdb-5f59-a9a5-8648a9eec022', '9e887d61-2bc0-59f9-9de2-f39ad356d634', 'c184d782-8cfd-572f-b902-f4f7f3eda058', 'af0e7bb2-47de-5561-aab8-30b15c8d825a', '5c560397-f5ae-5816-98c6-47118c588da2', 'd096a0c1-aa38-5ec9-8966-9c4627f88c83', '1d457b65-3c6a-5fa5-8512-e62d1f848f83', '04c7a430-2d0d-5489-896a-cf0052ccba5a', '30bda6d7-c0d1-534e-a470-0a85fbf0bbb2', '8498444c-7a5e-5284-be13-3d453fc076dd', '31985503-d3a2-5039-b409-936294be08c2', '10ee235d-8024-5e4d-bdda-2f5befdcfcbe', 'f1f985df-2a39-5225-af80-09c6b74623cb', 'b3cf6ff6-e317-59df-9b7c-e61ed76fa0da', '0b78d09e-6557-5d0e-b7cc-afa07e172267', '548fea8e-8b1f-540a-9c94-2e8917ccf8f2', '25ddf88e-2437-5489-8e8e-a6c10f0024d4', 'd2aea363-8bcc-58d7-9b66-bfbb9f73f106', '26fd41c6-bf9c-557d-a05b-d947d43e2052', '1e6356e9-3e0e-5fa4-b00b-8b48f7c3a8d4', 'e2d8bfc2-77b1-5c56-8c7d-8552451dcc70', '2e825dfb-548b-50e6-81d6-28d09797c579', '76f1bd57-99c5-596e-b74b-b6f4d1160c28', 'e273fa03-ea03-580c-af48-f748d399cef2', '0a972080-ddd7-5f99-83b0-cda02b6131a3', 'bc01ce9a-a808-57c3-a5b8-31cb8d71ea09', 'b26ab546-7052-5b70-a703-9de7cc1cf469', 'd23359b1-a7aa-5172-a664-2fe766625e62', '8147a071-8f86-5672-b4ac-6f50a1d25db7', 'aa9358c8-d4e6-56c5-8726-678767577103', 'd0c0a898-6bfa-5fe2-8340-4b6856f4cb46', 'eca30035-228f-56ff-8ab6-f9da371b5d29', '1c696444-6420-540d-a1e2-ba5a8381d784', '2481a5f6-f6bb-546d-a389-28783c16bb17', 'e9423c94-dd3a-5eda-a988-0f3f8accdfac', '1be9dd6b-ab20-552f-9414-a4291bf2bae8', '484eccc7-3966-5f51-b427-4c4fab9663f2', 'ef2fb6b8-ea29-55b1-802a-4ede94c86df0', 'ffb3e825-0bf8-5d50-941c-bd24fc57c634', '404dafa3-b8ff-5852-8c09-c2a94efecc87', '3b212333-34db-5674-a5e8-2c941971b8bd', '4a2c86f4-668e-5f5a-8467-7aaf8cb3f623', 'f7df9cc2-3a67-5933-bbcc-8632e4bee30e', 'd843e075-4e4c-55e4-b31f-70f06375cebf', 'a2d7801e-e1ca-5609-81af-31a43aac89f8', '3962471d-13be-58c5-9e38-b26a8266f83d', '6570694f-9020-5c20-8491-590d0e5ed585', 'ee9bc776-ed07-5f67-9fec-1a4914563d76', 'f2e40359-e6a6-5978-9651-9e4d3bf6c7f4', '96c37135-feb5-5324-8e15-0defc400fbde', '5b0249fa-6521-53d3-b8b7-4ee357374fa4', '833f947d-6f04-5e89-9d54-4d9a5180cd72', '343c98b4-b4a4-511d-ad74-ce9c20da4075', 'a9864def-7fd9-5c86-bd57-3e3e6512cc55', '4571cf31-645a-560a-98f8-32e765c549e8', 'ccd344c0-da82-5485-84a3-062e1b3a045b', '73c35dda-5e03-55a1-bde2-f977a9a9ac60', '01fa02c2-b3db-5717-aea4-b507a0ed3bb8', '052908dc-28b7-5d75-a865-6e0c26b85584', '5a4320f7-91f4-5594-903c-27f7e79cddb7', '7816d344-9145-53ee-8b50-8e24634c8331', '2788d7ef-e795-5bdd-ba1b-b4225ed9bcdc', '36f84981-a3e1-5149-8248-16f1782f845a', '76dbe8a5-d2ad-594e-b688-e6df0e58b1d7', '23a4c81b-0ed0-554e-81f5-826561543ee3', '7364f343-f013-5881-8676-3cd6c9a3a94b', 'bbe92ec0-254a-54b5-8106-33f7ae20a2c2', '78e38dcf-1b45-5f69-bbdb-3e6859c6b1e1', '540a81ff-40c8-563d-a6b5-cc50cd19f28e', '35747898-71f6-5555-bdcc-1fbe9a75379f', '0c797549-54d8-5292-b4a2-f734b4fe2a6b', 'eda30fdc-f9f4-5ffa-bf4e-aa0f4874f2b6', 'b0e6794e-7fec-589e-966e-acc6309a9825', '65808528-8e7a-5cc8-953a-00c99912845b', '63f5afc3-da0b-5133-87e3-5b1f6e4c2cd9', 'e522eef3-42b4-5aa5-8f60-5ac839817a60', '004e0069-0b5a-50fb-aeb6-b817c8b66a8d', '74a30f22-1442-5150-8197-8a98d5a8226b', 'c4b3de53-b96f-5441-baa2-fa5f214c790d', '8bf81f2f-d6ea-5a65-a195-10d2c48c8fb2', 'b2b5144f-95c0-56f0-8dcc-0c915a4a939e', '2563ca17-1ca2-5ea6-94d8-64b5ce8e9ef2', 'bcc42bdc-b5e8-53bd-ada4-f087a98245af', 'cf4942b6-8b19-5540-bf3b-f21e5c4910ce', '408dd4bd-b5ad-56b3-aa31-a2ab83bccdc8', '49248b8c-64f5-5d7a-8bd7-2116b254c330', 'ed19e978-cad3-5435-bdac-f3a19433089d', '019cce52-003c-506d-9254-0b25883a327e', '24d977bb-6ea5-5c64-a1b9-cb36c54ef9b7');
DELETE FROM public.chapters c WHERE c.subject_id = 'french-3eme' AND c.id NOT IN ('ffaa354a-a903-51f9-80e5-bea7ab783079', 'fd91eed0-0263-518d-8761-b6d7f8aed2ab', '579e4915-2832-573a-bdb3-235828d6cba0', '051b4252-0a68-5811-9e48-2e0b2b26eca8', 'd9567912-0c24-5610-adfb-5a758276e321', 'a3d1662c-7d42-595a-b886-3d26403e2a84', 'b8d76031-4a47-58c8-a4f6-48e52bdd3fb8', '51822d93-c9ce-52d8-b95c-a34ca3e52d6c', 'a0ca537c-88ef-5162-ba74-c1faf472492c') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('ffaa354a-a903-51f9-80e5-bea7ab783079', 'french-3eme', 'Unité 0 — Je révise mes premiers mots', 'Avant de commencer, nous révisons nos premiers acquis de français : saluer et se présenter, nommer la famille, l''école et le corps, dire les couleurs et les jours de la semaine, et compter de 1 à 10.', '# 🎒 je révise mes premiers mots

> 💡 « bonjour ! je m''appelle elyssa. je révise mes premiers mots de français : ma famille, mon école, mon corps, les couleurs, les jours et les nombres. »

## 👋 je dis bonjour

quand je vois un ami le matin, je dis : **bonjour !**

le soir, je dis : **bonsoir !**

quand je pars, je dis : **au revoir !**

pour être poli, je dis aussi : **merci** et **s''il te plaît**.

> 🗝️ le matin → **bonjour** · pour partir → **au revoir** · pour remercier → **merci**.

## 🙋 je me présente

je dis mon nom comme ça : **je m''appelle elyssa.**

pour demander son nom à un ami, je dis : **comment t''appelles-tu ?**

pour montrer quelqu''un, je dis : **c''est mon ami.** ou : **voici mon ami.**

pour dire ce que j''ai, je dis : **j''ai un cartable.**

## 👨‍👩‍👧 ma famille

dans ma **famille**, il y a :

- le **papa** et la **maman**,
- le **frère** et la **sœur**,
- le **grand-père** et la **grand-mère**.

je dis : **j''aime ma famille.**

## 🏫 mon école

à l''**école**, il y a la **classe**, le **maître** ou la **maîtresse**, et beaucoup d''**amis**.

dans mon **cartable**, je mets mes affaires :

> 🗝️ un **livre**, un **cahier**, un **stylo**, un **crayon**, une **gomme** et une **règle**.

je compte mes affaires avec le mot **et** : un livre **et** un cahier **et** un stylo.

## 🧍 mon corps

je nomme les parties de mon corps :

- sur ma **tête**, j''ai deux **yeux**, un **nez** et une **bouche** ;
- j''ai aussi deux **oreilles** et deux **mains** ;
- en bas, j''ai deux **pieds**.

je dis : **j''ai un nez** et **j''ai deux mains.**

## 🎨 les couleurs

je connais les **couleurs** :

> 🗝️ **rouge**, **rose**, **noir**, **marron**, **bleu**, **vert**, **jaune**, **blanc**.

je dis : **le stylo est rouge.** ou : **la gomme est rose.**

## 📅 les jours de la semaine

je récite les **jours** dans l''ordre :

**lundi**, **mardi**, **mercredi**, **jeudi**, **vendredi**, **samedi**, **dimanche**.

après **lundi**, c''est **mardi**. après **jeudi**, c''est **vendredi**.

## 🔢 je compte de 1 à 10

je compte avec mes doigts :

> 🗝️ **1** un · **2** deux · **3** trois · **4** quatre · **5** cinq · **6** six · **7** sept · **8** huit · **9** neuf · **10** dix.

après **trois**, c''est **quatre**. après **huit**, c''est **neuf**.

## 🗣️ je parle un peu

je sais dire de petites phrases :

- pour dire que j''aime : **j''aime le bleu.**
- pour dire que je n''aime pas : **je n''aime pas le noir.**
- pour poser une question simple : **où est mon stylo ?**
- pour répondre : **mon stylo est dans le cartable.**

> 🗡️ je révise tout : je salue, je me présente, je nomme ma famille, mon école, mon corps, les couleurs, les jours, et je compte de 1 à 10.

> 🏆 bravo ! tu as révisé tes premiers mots. dans la prochaine unité, nous parlons de la famille avec « ma famille, mon amour ! ».', '# 📜 résumé : je révise mes premiers mots

- **je dis bonjour** : le matin je dis **bonjour**, le soir **bonsoir**, pour partir **au revoir** ; je dis aussi **merci** et **s''il te plaît**.
- **je me présente** : je dis **je m''appelle elyssa** ; je demande **comment t''appelles-tu ?** ; je montre avec **c''est** ou **voici**.
- **ma famille** : le **papa**, la **maman**, le **frère**, la **sœur**, le **grand-père**, la **grand-mère**.
- **mon école** : la **classe**, le **maître** ou la **maîtresse**, les **amis** ; dans le **cartable** : **livre**, **cahier**, **stylo**, **crayon**, **gomme**, **règle**.
- **mon corps** : la **tête**, les **yeux**, le **nez**, la **bouche**, les **oreilles**, les **mains**, les **pieds**.
- **les couleurs** : **rouge**, **rose**, **noir**, **marron**, **bleu**, **vert**, **jaune**, **blanc**.
- **les jours** : **lundi**, **mardi**, **mercredi**, **jeudi**, **vendredi**, **samedi**, **dimanche**.
- **je compte de 1 à 10** : un, deux, trois, quatre, cinq, six, sept, huit, neuf, dix.
- **je parle un peu** : **j''aime le bleu** · **je n''aime pas le noir** · **où est mon stylo ?** · **mon stylo est dans le cartable**.', 1, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('fd91eed0-0263-518d-8761-b6d7f8aed2ab', 'french-3eme', 'Ma famille, mon amour !', 'Nous nommons les membres de la famille (papa, maman, frère, sœur, papi, mamie, oncle, tante) et les pièces de la maison, nous présentons une personne (c''est, voici, voilà) et posons des questions simples (qui ? où ? comment t''appelles-tu ?), nous lisons les lettres a, l, i, m, nous écoutons le son on et nous comptons de 1 à 10.', '# 👨‍👩‍👧‍👦 Ma famille, mon amour !

> 💡 « J''aime ma famille : papa, maman, mon frère et ma sœur. Je sais dire leur nom, et je sais lire les lettres a, l, i, m. »

## 🌟 Les mots de la famille

Voici les personnes de ma famille :

- **papa** (le père) et **maman** (la mère)
- mon **frère** (un garçon) et ma **sœur** (une fille)
- **papi** (le grand-père) et **mamie** (la grand-mère)
- mon **oncle** et ma **tante**

Dans une famille, il y a des **filles** et des **garçons**. Une fille, un garçon : c''est un enfant.

## 🏠 Les pièces de la maison

Ma famille habite dans une **maison**. Dans la maison, il y a :

- le **salon** (on s''assoit ensemble)
- la **cuisine** (on prépare à manger)
- la **chambre** (on dort)
- la **salle de bains** (on se lave)
- le **jardin** (on joue dehors)

## 👋 Je présente quelqu''un

Pour montrer une personne, je dis **c''est**, **voici** ou **voilà** :

- **C''est** maman.
- **Voici** mon frère.
- **Voilà** ma sœur.

Je dis aussi **mon** ou **ma** : **mon** papa, **ma** maman, **mon** oncle, **ma** tante.

## ❓ Je pose une question

Je peux poser des questions simples :

- **Comment t''appelles-tu ?** → Je m''appelle Lina.
- **Qui est-ce ?** ou **C''est qui ?** → C''est papi.
- **Où ?** → Maman est dans la cuisine.
- Et pour demander à mon ami : **Et toi ?**

## 🔤 Je lis les lettres a, l, i, m

Cette semaine, je lis quatre lettres : **a · l · i · m**.

Je colle les lettres pour faire des **syllabes** :

- **m** + **a** = **ma**
- **l** + **a** = **la**
- **m** + **i** = **mi**
- **l** + **i** = **li**

Et je lis des petits mots : **ma**, **la**, **lila**, **mima**.

## 🎵 J''écoute le son **on**

J''écoute bien le son **on**, comme dans le chant de la famille :

- m**on** papa, t**on** frère, s**on** oncle
- b**on**jour, le sal**on**, un garç**on**

Quand j''entends **on**, je pense à **mon** et à **maman** qui dit « b**on**jour ! ».

## 🔢 Je compte de 1 à 10

Je compte les personnes de ma famille :

**1** un · **2** deux · **3** trois · **4** quatre · **5** cinq · **6** six · **7** sept · **8** huit · **9** neuf · **10** dix.

> 🗝️ Pour montrer une personne : **c''est**, **voici**, **voilà**. Pour demander son nom : **comment t''appelles-tu ?**

> 🏆 Bravo ! Tu sais nommer ta famille, présenter une personne et lire les lettres a, l, i, m. Dans le prochain chapitre, nous partons à l''école !', '# 📜 Résumé : Ma famille, mon amour !

- **La famille** : papa (père), maman (mère), le frère (un garçon), la sœur (une fille), papi (grand-père), mamie (grand-mère), l''oncle, la tante.
- **La maison** : le salon, la cuisine, la chambre, la salle de bains, le jardin.
- **Présenter quelqu''un** : c''est, voici, voilà → c''est maman, voici mon frère, voilà ma sœur (mon papa, ma maman).
- **Poser une question** : comment t''appelles-tu ? · qui est-ce ? / c''est qui ? · où ? · et toi ?
- **Lire les lettres a, l, i, m** : m + a = ma, l + a = la, m + i = mi, l + i = li ; je lis ma, la, lila, mima.
- **Le son on** : mon, ton, son, bonjour, salon, garçon (mon, maman, bonjour).
- **Compter de 1 à 10** : 1 un, 2 deux, 3 trois, 4 quatre, 5 cinq, 6 six, 7 sept, 8 huit, 9 neuf, 10 dix.', 2, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('579e4915-2832-573a-bdb3-235828d6cba0', 'french-3eme', 'Mon école', 'Nous découvrons l''école : la cour, la classe, la cantine, le préau, la maîtresse et nos camarades. Nous disons où sont les objets (il y a … dans …), nous posons des questions simples (qui ? que ? où ?), nous lisons les lettres o, d, u, r, nous écoutons les sons o/ou, p/b, u/i, et nous comptons de 10 à 20.', '# 📖 Mon école — je nomme, je situe, je lis

> 💡 « À l''école, il y a la cour, la classe et la cantine. Je nomme les lieux, je dis où sont les choses, et je lis de nouveaux mots avec Poupou. »

## 🏫 Les lieux de mon école

Voici les lieux de l''école :

- la **cour** : on joue dans la cour à la **récréation**.
- la **salle de classe** : on travaille dans la classe.
- le **préau** : c''est un endroit couvert près de la cour.
- la **cantine** : on mange à la cantine.
- la **bibliothèque** : on lit des livres à la bibliothèque.
- le **bureau** : c''est la table de la maîtresse.

Dans l''école, il y a une **maîtresse** et des **élèves**. Un autre élève de ma classe est mon **camarade** ou mon **ami**.

## ✏️ Mes affaires de classe

Dans mon **cartable**, je range mes affaires :

- un **livre** pour lire,
- un **cahier** pour écrire,
- un **crayon** pour dessiner,
- une **gomme** pour effacer,
- une **règle** pour tracer un trait.

Sur le mur de la classe, il y a un **drapeau**.

## 📍 Je dis où sont les choses

Pour dire où est une chose, je dis **il y a … dans …** :

- Il y a un livre **dans** le cartable.
- Il y a des élèves **dans** la cour.
- Il y a une gomme **dans** la trousse.

## ❓ Je pose des questions

Je pose des questions simples :

- **Qui ?** → pour une personne. *Qui est dans la classe ? La maîtresse.*
- **Que ?** → pour une chose ou une action. *Que fais-tu ? Je lis.*
- **Où ?** → pour un lieu. *Où es-tu ? Dans la cour.*

## 🔤 Je lis des lettres et des sons

Je lis quatre lettres : **o** · **d** · **u** · **r**.

Je joins une lettre à une autre pour faire une **syllabe** :

- d + o = **do** · r + u = **ru** · m + o = **mo** · l + u = **lu**

J''écoute bien les sons qui se ressemblent :

- le son **o** (comme dans *do*) et le son **ou** (comme dans *cou*).
- le son **p** (comme dans *papa*) et le son **b** (comme dans *bébé*).
- le son **u** (comme dans *lune*) et le son **i** (comme dans *lit*).

## 🔢 Je compte de 10 à 20

Je compte : **dix (10), onze (11), douze (12), treize (13), quatorze (14), quinze (15), seize (16), dix-sept (17), dix-huit (18), dix-neuf (19), vingt (20).**

> 🗡️ À l''école, je nomme les lieux et mes affaires, je dis où sont les choses, je pose des questions, je lis o, d, u, r, et je compte jusqu''à 20.

> 🏆 Bravo ! Tu connais ton école. Dans le prochain chapitre, nous découvrons un nouveau thème : mon corps.', '# 📜 Résumé : Mon école

- **Les lieux de l''école** : la cour (on y joue à la récréation), la salle de classe (on y travaille), le préau (endroit couvert), la cantine (on y mange), la bibliothèque (on y lit), le bureau (la table de la maîtresse). À l''école il y a une maîtresse, des élèves, des camarades et des amis.
- **Mes affaires de classe** : dans le cartable je range un livre (lire), un cahier (écrire), un crayon (dessiner), une gomme (effacer), une règle (tracer). Sur le mur, il y a un drapeau.
- **Je situe les choses** : je dis **il y a … dans …** (il y a un livre dans le cartable ; il y a des élèves dans la cour).
- **Je pose des questions** : **qui ?** pour une personne, **que ?** pour une chose ou une action, **où ?** pour un lieu.
- **Je lis des lettres et des sons** : les lettres **o, d, u, r** ; je forme des syllabes (d + o = do, r + u = ru) ; j''écoute les sons qui se ressemblent : **o / ou**, **p / b**, **u / i**.
- **Je compte de 10 à 20** : dix, onze, douze, treize, quatorze, quinze, seize, dix-sept, dix-huit, dix-neuf, vingt.', 3, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('051b4252-0a68-5811-9e48-2e0b2b26eca8', 'french-3eme', 'Mon corps', 'Nous nommons les parties du visage et du corps (tête, yeux, nez, bouche, main, pied…), nous parlons de la toilette (se laver, se brosser les dents, le savon, le peigne), nous disons où se trouvent les choses (en haut, en bas), nous apprenons les jours de la semaine, et nous lisons les graphies « ou », « t », « e/eu » et « j ». Nous écoutons les sons e/eu et d/t, et nous comptons de 1 à 20.', '# 📖 Mon corps — je le nomme et j''en prends soin

> 💡 « j''ai une tête, deux yeux, un nez et une bouche : c''est mon corps, et j''en prends bien soin ! »

## 🌟 mon visage

sur ma **tête**, il y a mes **cheveux** et mon **visage**. sur le visage, j''ai :

- deux **yeux** pour voir,
- un **nez** pour sentir,
- une **bouche** et une **langue** pour parler et goûter,
- deux **oreilles** pour écouter,
- deux **joues** et mes **dents**.

je dis : « j''ai un nez pour sentir. j''ai deux yeux pour voir. »

## 💪 mon corps

mon corps a d''autres parties :

- les **bras** et les **mains**, avec les **doigts**,
- les **épaules** et le **dos**,
- les **jambes**, les **genoux** et les **pieds**.

une **main**, deux **mains**. un **pied**, deux **pieds**.

## 🧼 je fais ma toilette

le matin, je prends soin de mon corps. dans ma **trousse de toilette**, il y a :

- le **savon** pour me laver,
- la **brosse à dents** et le **dentifrice** pour mes dents,
- le **shampoing** pour mes cheveux,
- le **peigne** et le **miroir**.

je dis : « je me **lave**. je me **brosse** les dents. je me **peigne**. »

## 🔼 en haut, en bas

je sais dire **où** se trouve une chose :

- la tête est **en haut**.
- les pieds sont **en bas**.

les cheveux sont en haut ; les genoux sont en bas.

## 📅 les jours de la semaine

la semaine a **sept** jours, dans l''ordre :

**lundi · mardi · mercredi · jeudi · vendredi · samedi · dimanche.**

après lundi vient mardi. après samedi vient dimanche.

## 🔤 je lis les sons

j''apprends à lire des syllabes et des mots avec mes nouvelles lettres :

- **ou** se lit [ou], comme dans **roue**, **doux**, **joue**.
- **t** se lit [t], comme dans **tomi**, **moto**, **tortue**.
- **e/eu** se lit [e]/[eu], comme dans **le**, **petit**, **jeu**.
- **j** se lit [j], comme dans **joli**, **jour**, **jeu**.

je lis : **t + ou = tou** · **j + ou = jou** · **l + e = le**.

## 🔊 j''écoute bien : e/eu et d/t

je fais attention à deux paires de sons proches :

- **e** comme dans **le**, et **eu** comme dans **jeu**.
- **d** comme dans **doux**, et **t** comme dans **tout**. (**d** et **t** se ressemblent : j''écoute bien !)

et je change la voix pour **poser une question** : « tu as mal ? » (la voix monte à la fin).

## 🔢 je compte de 1 à 20

je compte mes doigts et mes amis :

**1, 2, 3, 4, 5, 6, 7, 8, 9, 10** — puis **11, 12, 13, 14, 15, 16, 17, 18, 19, 20.**

j''ai **deux** mains et **dix** doigts.

> 🗡️ je nomme mon corps, je fais ma toilette, je lis mes sons et je compte : bravo !

> 🏆 super travail ! tu connais ton corps et tu lis « ou », « t », « e/eu » et « j ». dans le prochain chapitre, nous parlons des aliments : « dans mon assiette ! ».', '# 📜 Résumé : mon corps

- **mon visage** : sur la tête, j''ai les cheveux et le visage ; sur le visage : les yeux (voir), le nez (sentir), la bouche et la langue (parler, goûter), les oreilles (écouter), les joues et les dents.
- **mon corps** : les bras et les mains avec les doigts, les épaules et le dos, les jambes, les genoux et les pieds. une main → deux mains ; un pied → deux pieds.
- **je fais ma toilette** : dans la trousse de toilette, il y a le savon, la brosse à dents, le dentifrice, le shampoing, le peigne et le miroir ; je me lave, je me brosse les dents, je me peigne.
- **en haut, en bas** : la tête est en haut, les pieds sont en bas.
- **les jours de la semaine** : sept jours dans l''ordre — lundi, mardi, mercredi, jeudi, vendredi, samedi, dimanche.
- **je lis les sons** : « ou » = [ou] (roue, joue), « t » = [t] (moto, tortue), « e/eu » = [e]/[eu] (le, jeu), « j » = [j] (joli, jour) ; t + ou = tou.
- **j''écoute bien** : e (le) / eu (jeu) ; d (doux) / t (tout) se ressemblent ; pour poser une question, la voix monte à la fin.
- **je compte de 1 à 20** : 1 à 10 puis 11 à 20 ; j''ai deux mains et dix doigts.', 4, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('d9567912-0c24-5610-adfb-5a758276e321', 'french-3eme', 'Unité 4 — Dans mon assiette !', 'Nous parlons des aliments et des repas : le matin, le midi, le soir. Nous nommons des aliments et des ustensiles, nous disons la quantité (peu, beaucoup, trop) et la formule « Bon appétit ! ». Nous lisons les sons é, p et b, nous distinguons p/b et on/an, et nous comptons de 10 à 20.', '# 🍽️ Dans mon assiette !

> 💡 « Le matin, le midi, le soir : à chaque repas, je mange un peu de tout pour être en bonne santé. Bon appétit ! »

## 🥗 Les aliments dans mon assiette

Dans mon assiette, il y a beaucoup d''aliments. J''aime les nommer :

- du **pain**, du **lait**, du **fromage**
- une **salade**, une **soupe**, des **fruits**
- du **poulet**, du **poisson**, un **gâteau**

Un aliment peut être **bon** et **délicieux**. Une **galette** est **dorée**. Le citron est **acide**, le sucre est **sucré**.

## 🕐 Le matin, le midi, le soir

La journée a des moments. À chaque moment, il y a un repas :

- Le **matin**, je prends le **petit déjeuner**.
- Le **midi**, je prends le **déjeuner**. **Il est midi !**
- L''après-midi, je prends le **goûter**.
- Le **soir**, je prends le **dîner**.

Pour savoir l''heure, je regarde l''horloge. **Il est midi.** **Il est huit heures.**

## 🥄 Mes ustensiles

Pour manger et pour cuisiner, j''utilise des ustensiles :

- une **assiette**, une **tasse**, une **cuillère**
- un **fouet** pour battre les œufs
- le **cuisinier** met sa **toque** et son **tablier**

## ⚖️ Un peu, beaucoup, trop

Je dis la quantité avec trois petits mots :

- **un peu** : il y a un peu de sucre. (juste ce qu''il faut)
- **beaucoup** : il y a beaucoup de fruits. (une grande quantité)
- **trop** : il y a trop de sel ! (c''est trop, ce n''est pas bon)

Pour être en bonne santé, je mange **un peu de tout** et jamais **trop**.

## 🙅 Je dis « non » : la forme négative

Pour dire « non », j''entoure le mot avec **ne… pas** :

- J''aime le gâteau. → Je **n''**aime **pas** le sel.
- C''est sucré. → Ce **n''**est **pas** sucré.
- Il y a du pain. → Il **n''**y a **pas** de pain.

> 🗝️ Quand je veux dire le contraire, je mets **ne** devant et **pas** derrière : « je **ne** mange **pas** trop ».

## 😋 Bon appétit !

À table, avant de manger, on dit une formule de politesse :

- **« Bon appétit ! »** quand on commence à manger.
- **« Merci ! »** quand le repas est délicieux.

## 🔤 Les sons é, p et b

J''écoute et je lis de nouvelles graphies :

- le son **[é]** s''écrit **é** (comme dans **bébé**, **café**) ou **er** à la fin d''un mot (comme dans **goûter**, **manger**).
- le son **[s]** s''écrit **s** (comme dans **salade**) ou **ss** entre deux voyelles (comme dans **assiette**, **tasse**).
- la lettre **b** fait le son **[b]** (comme dans **banane**, **beurre**).
- la lettre **p** fait le son **[p]** (comme dans **pain**, **pomme**).

J''assemble les sons en syllabes : **b** + **a** = **ba** ; **p** + **a** = **pa** ; **s** + **é** = **sé**.

## 👂 Je n''entends pas la même chose : p/b et on/an

Deux sons peuvent se ressembler. J''écoute bien :

- **p** et **b** : **pain** / **bain**, **pon** / **bon**, **pas** / **bas**.
- **on** et **an** : **bon** / **banc**, **mon** / **ment**, **pont** / **paon**.

Avec **on**, ma bouche est ronde ; avec **an**, ma bouche est ouverte.

## 🔢 Je compte de 10 à 20

Je compte les aliments dans mon assiette :

dix (10), onze (11), douze (12), treize (13), quatorze (14), quinze (15), seize (16), dix-sept (17), dix-huit (18), dix-neuf (19), vingt (20).

## 📕 Je lis un petit texte

> 🗝️ C''est le matin. Léa met la table. Il y a du pain, du lait et un peu de confiture. Papa dit : « Bon appétit ! »

> 🗡️ Je nomme les aliments et les repas, je dis la quantité (peu, beaucoup, trop), je lis les sons é, p et b, et je distingue p/b et on/an.

> 🏆 Bravo ! Tu sais parler de ton assiette. Dans le prochain chapitre, nous partons à la rencontre de nos amis les animaux.', '# 📜 Résumé : Dans mon assiette !

- **Les aliments** : le pain, le lait, le fromage, la salade, la soupe, les fruits, le poulet, le poisson, le gâteau. Un aliment peut être **bon**, **délicieux**, **sucré**, **doré**.
- **Les moments et les repas** : le **matin** → le petit déjeuner ; le **midi** → le déjeuner ; l''après-midi → le goûter ; le **soir** → le dîner. Pour l''heure : **il est midi**.
- **Les ustensiles** : une assiette, une tasse, une cuillère, un fouet ; le cuisinier met sa toque et son tablier.
- **La quantité** : **un peu** (juste ce qu''il faut), **beaucoup** (une grande quantité), **trop** (c''est trop). Je mange un peu de tout, jamais trop.
- **La forme négative** : pour dire « non », je mets **ne** devant et **pas** derrière → « je **ne** mange **pas** trop ».
- **La politesse à table** : on dit **« Bon appétit ! »** pour commencer et **« Merci ! »** quand c''est délicieux.
- **Les sons é, p et b** : le son **[é]** s''écrit **é** ou **er** (goûter) ; le son **[s]** s''écrit **s** ou **ss** (tasse) ; **b** fait **[b]** (banane) ; **p** fait **[p]** (pain).
- **p/b et on/an** : j''écoute la différence — **pain/bain**, **bon/banc** ; avec **on** la bouche est ronde, avec **an** elle est ouverte.
- **Les nombres de 10 à 20** : dix, onze, douze, treize, quatorze, quinze, seize, dix-sept, dix-huit, dix-neuf, vingt.
- **Je lis un petit texte** : une courte histoire avec le pain, le lait et « Bon appétit ! ».', 5, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('a3d1662c-7d42-595a-b886-3d26403e2a84', 'french-3eme', 'Unité 5 — Mes amis, les animaux !', 'Nous découvrons les animaux et leurs petits, nous parlons des saisons et des jours, et nous disons ce que font les animaux (nager, voler, courir…). Nous lisons les sons n, an/en, f et on, nous écoutons les sons ch et j, et nous comptons de 1 à 30.', '# 🐾 Mes amis, les animaux !

> 💡 « Le chat, le chien, l''oiseau, la vache… Je nomme mes amis les animaux, je dis ce qu''ils font, et je compte de un à trente. »

## 🐔 Je nomme les animaux

Voici des animaux que nous aimons :

- à la ferme : la **poule**, le **coq**, la **vache**, le **mouton**, la **chèvre**, le **cheval**, l''**âne**.
- à la maison : le **chat**, le **chien**.
- dans le ciel et l''eau : l''**oiseau**, le **pigeon**, le **flamant**.

Je dis : **c''est** un chat. **C''est** une poule. **C''est** un oiseau.

## 🐣 Les animaux et leurs petits

Chaque animal a un **petit** :

- le chat → le **chaton**
- la poule → le **poussin**
- l''âne → l''**ânon**
- le cheval → le **poulain**

Le chaton est petit. La poule a un poussin.

## 🏞️ Où vivent les animaux ?

Les animaux vivent dans la nature :

- la **ferme** : la poule et la vache.
- le **pré** : le mouton et la chèvre.
- le **lac** : le flamant et le canard.
- la **campagne** : l''âne et le cheval.

Je protège les animaux et la nature. C''est important !

## 🏃 Je dis ce que font les animaux

Chaque animal **bouge** à sa façon. Je dis :

- l''oiseau **vole** dans le ciel.
- le poisson **nage** dans le lac.
- le cheval **court** dans le pré.
- le chat **saute** sur le mur.
- le mouton **marche** dans le pré.

Je **nourris** mon chat : je lui donne à manger.

## ☀️ Les saisons et les jours

L''année a **quatre saisons** : le **printemps**, l''**été**, l''**automne**, l''**hiver**.

En hiver, il fait **froid**. En été, il fait **chaud**.

La semaine a **sept jours** : lundi, mardi, mercredi, jeudi, vendredi, samedi, dimanche.

## 🔤 Je lis les sons : n · an/en · f · on

Je lis et je relie les sons aux lettres :

- la lettre **n** fait le son [n] : **n**id, â**n**e, **n**age.
- les lettres **an** et **en** font le son [ɑ̃] : **an**e, gr**an**d, **en**fant.
- la lettre **f** fait le son [f] : **f**erme, **f**lamant, en**f**ant.
- les lettres **on** font le son [ɔ̃] : mout**on**, pouss**in**… non : mout**on**, p**on**t, b**on**.

J''assemble : f + on = **fon**. n + on = **non**. ch + a = **cha**.

## 🔊 J''écoute les sons : ch [ʃ] et j [ʒ]

Deux sons des animaux et de la nature :

- le son **ch** [ʃ], comme dans **ch**at, **ch**ien, **ch**èvre, **ch**eval.
- le son **j** [ʒ], comme dans **j**oli, **j**our, **j**ardin ; on l''entend aussi dans na**ge** et pi**ge**on.

J''écoute bien : **ch**at (ch) et **j**our (j) ne font pas le même son.

## 🔢 Je compte de 1 à 30

Je compte les animaux : un, deux, trois… jusqu''à **trente**.

- de 1 à 10 : un, deux, trois, quatre, cinq, six, sept, huit, neuf, dix.
- de 11 à 20 : onze, douze, treize, quatorze, quinze, seize, dix-sept, dix-huit, dix-neuf, vingt.
- jusqu''à 30 : vingt et un, vingt-deux… vingt-neuf, **trente**.

Après **vingt-neuf** vient **trente**. Trois poules + deux poules = **cinq** poules.

> 🗝️ Je nomme les animaux et leurs petits, je dis ce qu''ils font, je lis les sons n, an/en, f et on, et je compte jusqu''à trente.

> 🏆 Bravo ! Tu connais tes amis les animaux. Dans le chapitre suivant, nous parlons de notre ami le livre !', '# 📜 Résumé : Mes amis, les animaux !

- **Je nomme les animaux** : la poule, le coq, la vache, le mouton, la chèvre, le cheval, l''âne, le chat, le chien, l''oiseau, le pigeon, le flamant. Je dis : c''est un chat.
- **Les petits** : le chat → le chaton ; la poule → le poussin ; l''âne → l''ânon ; le cheval → le poulain.
- **Où vivent les animaux** : la ferme, le pré, le lac, la campagne. Je protège les animaux et la nature.
- **Ce que font les animaux** : l''oiseau vole, le poisson nage, le cheval court, le chat saute, le mouton marche. Je nourris mon chat.
- **Les saisons et les jours** : quatre saisons (printemps, été, automne, hiver) ; en hiver il fait froid, en été il fait chaud ; sept jours (lundi… dimanche).
- **Les sons n, an/en, f, on** : n fait [n] (âne) ; an/en font [ɑ̃] (grand, enfant) ; f fait [f] (ferme) ; on fait [ɔ̃] (mouton).
- **Les sons ch et j** : ch [ʃ] dans chat, chien, chèvre ; j [ʒ] dans joli, jour, et dans nage, pigeon.
- **Je compte de 1 à 30** : un, deux… dix ; onze… vingt ; jusqu''à trente. Après vingt-neuf vient trente.', 6, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('b8d76031-4a47-58c8-a4f6-48e52bdd3fb8', 'french-3eme', 'Unité 6 — Mon ami, le livre !', 'Le coin-lecture : nommer le livre et les objets pour lire, dire où est un objet (dans, sur, sous, à côté de), poser les questions « où ? » et « que ? », s''exclamer, dire un désir (je veux / je peux) et demander de l''aide poliment. Sons f/v et è/e ; graphies v, c=s, c=k, è/ë.', '# 📖 Mon ami, le livre !

> 💡 « Le livre est mon ami. Je lis une belle histoire, et je range mes livres dans le coin-lecture. »

## 📚 Les mots du coin-lecture

Le **coin-lecture**, c''est le petit endroit de la classe où nous lisons. Voici mes amis pour lire :

- un **livre** : je lis une **histoire** ou un **conte**.
- un **album** : un livre avec de belles images.
- une **revue** : on la lit puis on tourne les pages.
- une **boîte** et un **carton** : pour ranger les livres.
- une **étagère** : je range mes livres dessus.
- la **colle**, les **crayons de couleurs**, les **ciseaux** : pour faire un beau livre.

Je dis : « **un** livre », « **une** boîte », « **le** conte », « **la** revue ».

## 📍 Où est le livre ? (dans, sur, sous, à côté de)

Pour dire **où** est un objet, j''utilise un petit mot :

- **dans** : le livre est **dans** la boîte.
- **sur** : le livre est **sur** la table.
- **sous** : le livre est **sous** la table.
- **à côté de** : le livre est **à côté de** la colle.

Je pose la question avec **où** : « **Où** est le livre ? » Je réponds : « Il est **sur** la table. »

## ❓ Je pose des questions : où ? que ?

- **Où** ? → pour demander l''endroit. « **Où** est mon album ? »
- **Que** ? → pour demander la chose ou l''action. « **Que** fais-tu ? — Je lis. » « **Que** lis-tu ? — Une histoire. »

## ✨ Je m''exclame : quel beau livre !

Quand je suis **content**, je dis une phrase qui montre ma joie. C''est une **phrase exclamative**, et elle se termine par **!** :

- « **Quel beau livre !** »
- « **Comme c''est joli !** »
- « **Quelle belle histoire !** »

Je peux dire que le livre est **beau**, **joli**, **grand** ou **petit**, et que la boîte est **vide** (rien dedans) ou **pleine** (beaucoup dedans).

## 🙏 Je veux lire, et je demande de l''aide

Pour dire ce que je désire, je dis **je veux** ou **je peux** :

- « **Je veux** lire ce conte. »
- « **Je peux** ranger les livres. »

Pour demander de l''aide, je suis poli : j''ajoute **s''il te plaît** :

- « Tu peux m''aider, **s''il te plaît** ? »
- « Donne-moi le livre, **s''il te plaît**. »

## 🔤 Les sons f et v

J''écoute bien le début des mots :

- le son **[f]** s''écrit **f** : **f**ille, **f**rère.
- le son **[v]** s''écrit **v** : **v**ide, li**v**re, re**v**ue, élè**v**e.

Je lis des syllabes : v + i = **vi** (vide), f + a = **fa**. Le son **[v]** se dit avec la voix ; le son **[f]** se dit en soufflant.

## 🔡 Les graphies c et è/ë

La lettre **c** fait **deux** sons :

- **c = [s]** devant **e** et **i** : mer**ci**, **ci**ble, i**ci**.
- **c = [k]** devant **a**, **o**, **u** : **ca**rton, **co**lle, **co**nte.

La lettre **è** fait le son ouvert **[è]** : p**è**re, fr**è**re, élè**v**e, tr**è**s. (Le frère de **è**, c''est **ë** : on l''écrit parfois sur le **e**, comme dans No**ë**l.) Attention : dans « l**e** » et « petit**e** », le **e** est plus discret, on l''entend à peine.

> 🗝️ Le livre est mon ami : je lis, je range, je demande de l''aide poliment, et je dis où sont mes livres.

> 🏆 Bravo ! Tu connais le coin-lecture, les sons f/v et è/e, et les mots dans, sur, sous, à côté de. Dans l''unité suivante, on parle de nos jeux préférés !', '# 📜 Résumé : Mon ami, le livre !

- **Le livre est mon ami** : je lis une histoire et je range mes livres dans le coin-lecture.
- **Les mots du coin-lecture** : un livre, une histoire, un conte, un album, une revue, une boîte, un carton, une étagère, la colle, les ciseaux.
- **Dire où** : **dans** la boîte, **sur** la table, **sous** la table, **à côté de** la colle.
- **Poser des questions** : **où** ? pour l''endroit (« Où est le livre ? ») ; **que** ? pour la chose ou l''action (« Que lis-tu ? »).
- **La phrase exclamative** montre la joie et finit par **!** : « Quel beau livre ! », « Comme c''est joli ! ».
- **Dire un désir** : **je veux** / **je peux** ; **demander de l''aide** poliment : « s''il te plaît ».
- **Les sons f et v** : **f** comme dans frère ; **v** comme dans livre, revue, élève.
- **Les graphies c et è** : **c = [s]** devant e/i (merci, ici) ; **c = [k]** devant a/o/u (carton, colle) ; **è** fait le son ouvert (père, frère, très).', 7, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('51822d93-c9ce-52d8-b95c-a34ca3e52d6c', 'french-3eme', 'Unité 7 — Mes jeux préférés !', 'Nous parlons de nos jeux et de nos jouets : nommer un jeu, dire « je joue à / au / avec », exprimer un désir et une préférence (je veux, j''aime, je préfère), dire « pour » faire quelque chose, et dire non avec « ne… pas ». Nous lisons les sons des lettres g, ai/ei et in/ain/ein, nous comptons de 10 à 30, et nous pensons aux jeux qui sont sans danger.', '# 🎲 Mes jeux préférés !

> 💡 « Jouer, quel plaisir ! Je dis à quoi je joue, ce que j''aime et ce que je préfère, et je choisis des jeux sans danger. »

## 🧸 Mes jeux et mes jouets

Voici des mots pour parler des jeux et des jouets :

- une **balle**, un **ballon**, une **corde**, un **cerceau**
- une **poupée**, un **robot**, un **train**, une **bague**
- les **billes**, les **dominos**, la **marelle**, le **cache-cache**
- le **toboggan**, le **manège**, la **balançoire**, la **guitare**

Au parc, je joue dehors. À la maison, je joue aussi.

## 🎯 Je joue à, au, avec

Pour dire à quoi je joue, j''utilise **à**, **au** ou **avec** :

- Je joue **à** la balle. Je joue **à** la corde.
- Je joue **au** ballon. Je joue **au** train.
- Je joue **avec** ma poupée. Je joue **avec** mon robot.

Petit secret : je dis **au** ballon (pour un mot avec « le »), et **à la** corde (pour un mot avec « la »).

## 💛 Je veux, j''aime, je préfère

Je dis ce que je veux et ce que j''aime :

- Je **veux** jouer. J''**aime** la balle.
- Quand un jeu me plaît plus que les autres, je dis : **je préfère**.
- Exemple : j''aime la corde, mais **je préfère** le ballon.

## 🎈 Pour + un jeu

Avec le mot **pour**, je dis pourquoi je fais quelque chose :

- Je prends le ballon **pour** jouer.
- Je vais au parc **pour** courir.
- Je range mes jouets **pour** aider maman.

## 🚫 Je dis non : ne… pas

Pour dire **non**, j''entoure le mot avec **ne** et **pas** :

- J''aime le ballon. → Je **n''**aime **pas** la corde.
- Je veux jouer. → Je **ne** veux **pas** dormir.

C''est trop ! C''est peu ! C''est bon ! Et : il y a **trop** de billes, il y a **peu** de cordes.

## 🔤 Le son de la lettre g

La lettre **g** chante de deux façons :

- Devant **i** ou **e**, elle fait le son doux **[j]** : un **gilet**, une **girafe**, une **bougie**.
- Avec **gu** devant **e**, elle fait le son fort **[g]** : une **guitare**, une **bague**, une **vague**.

## 🔊 Le son [è] : ai et ei

Les lettres **ai** et **ei** font le son **[è]**, comme dans **lait** :

- avec **ai** : un **balai**, du **lait**, j''**aime**, une f**ai**ble pluie.
- avec **ei** : la **neige**, **treize** (13), **seize** (16).

## 👃 Le son [ain] : in, ain, ein

Les lettres **in**, **ain** et **ein** font le son du nez **[ain]**, comme dans **pain** :

- avec **in** : un lap**in**, un sap**in**, un mat**in**.
- avec **ain** : le p**ain**, une m**ain**, un tr**ain**.
- avec **ein** : un fr**ein**, la p**ein**ture, ple**in**.

## 🔢 Je compte de 10 à 30

Je compte mes billes et mes jouets :

**dix (10)**, onze, douze, **treize (13)**, quatorze, quinze, **seize (16)**, dix-sept, dix-huit, dix-neuf, **vingt (20)**, vingt et un, vingt-deux… jusqu''à **trente (30)**.

J''ai dix billes. Tu as treize dominos. Il y a vingt enfants au parc.

## 🛡️ Je joue sans danger

Jouer, c''est bon, mais je fais attention :

- Sur le **toboggan**, je glisse un par un, je ne pousse **pas**.
- Avec une **corde**, je joue par terre, loin des autres.
- Je range mes jouets **pour** ne pas tomber.

> 🗡️ Je dis à quoi je joue (à / au / avec), ce que j''aime et ce que je préfère ; je lis les sons de **g**, de **ai/ei** et de **in/ain/ein** ; je compte de 10 à 30 ; et je choisis des jeux sans danger.

> 🏆 Bravo ! Tu sais parler de tes jeux préférés. Dans le chapitre suivant, nous préparons une grande fête : « Quelle fête ! »', '# 📜 Résumé : Mes jeux préférés !

- **Mes jeux et mes jouets** : balle, ballon, corde, cerceau, poupée, robot, train, billes, dominos, marelle, toboggan, manège, balançoire, guitare.
- **Je joue à, au, avec** : je joue **à** la corde, **au** ballon, **avec** ma poupée.
- **Je veux, j''aime, je préfère** : je dis ce que je veux et ce que j''aime ; mon jeu préféré : **je préfère**.
- **Pour + un jeu** : avec **pour**, je dis pourquoi : je prends le ballon **pour** jouer.
- **Je dis non : ne… pas** : je n''aime **pas** la corde ; je ne veux **pas** dormir.
- **Le son de la lettre g** : **g** doux **[j]** devant i/e (gilet, girafe) ; **gu** fort **[g]** (guitare, bague).
- **Le son [è]** : **ai** et **ei** font **[è]** : lait, balai, neige, treize.
- **Le son [ain]** : **in**, **ain**, **ein** font **[ain]** : lapin, pain, main, train, frein.
- **Je compte de 10 à 30** : dix, treize, seize, vingt… jusqu''à trente.
- **Je joue sans danger** : sur le toboggan je ne pousse **pas** ; je range mes jouets.', 8, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order, manuel_ref) VALUES
  ('a0ca537c-88ef-5162-ba74-c1faf472492c', 'french-3eme', 'Quelle fête !', 'Dernier thème de l''année : la fête et le spectacle. Nous nommons la fête, la scène et les vêtements (chéchia, jebba, kimono…), nous décrivons un lieu, une personne et une action, nous disons ce que nous voulons et ce que nous savons faire, nous récitons les mois de l''année, nous lisons les sons oi, k, au/eau et ch, et nous comptons de 1 à 30.', '# 🎉 Quelle fête ! — je décris, je veux, je sais faire

> 💡 « C''est la fête de l''école ! Je décris la scène décorée, je mets ma chéchia, je dis ce que je veux faire et ce que je sais faire, et je lis les sons oi, k, au, eau et ch avec Poupou. »

## 🎊 Les mots de la fête

À la fin de l''année, il y a une grande **fête** à l''**école**. Voici les mots de la fête :

- la **scène** : on monte sur la scène pour le **spectacle**.
- les **guirlandes** : on décore la scène avec des guirlandes.
- la **musique** : on écoute la musique et on chante une **chanson**.
- une **danse**, un **poème**, un **conte** : ce sont des numéros du spectacle.
- un **gâteau** : on mange un bon gâteau à la fête.

On présente le spectacle avec son **équipe**. La **chanteuse** chante et la **danseuse** danse.

## 👗 Les vêtements de la fête

Pour la fête, chaque enfant met de beaux **vêtements** d''un pays :

- la **chéchia** et la **jebba** : des vêtements de chez nous.
- le **kimono** : un vêtement du Japon.
- un **pantalon** et des **chaussures** pour tout le monde.

Je dis : **je mets ma chéchia.** ou : **je mets un kimono.**

## 🎨 Je décris un lieu et une personne

Pour décrire, j''emploie de petits mots :

- la scène est **décorée** et **dorée**.
- le gâteau est **grand** et **beau**.
- la danseuse est **belle** ; sa robe est **blanche**.

Je dis : **c''est ma danse préférée.** Le mot **préféré** dit ce que j''aime le plus.

## 🙋 Je dis ce que je veux et ce que je sais faire

Pour dire ce que je veux, je dis **je veux** + un mot :

- **je veux danser.** · **je veux chanter.**

Pour dire ce que je sais faire, je dis **je sais** + un mot :

- **je sais danser.** · **je sais lire un poème.**

Pour demander à un ami, je dis **tu veux** ? ou **tu sais** ? :

- **tu veux jouer ?** → oui, je veux ! · **tu sais chanter ?** → oui, je sais !

Pour aider mon équipe, je dis : **je peux t''aider.** Pour dire non, je dis : **je ne veux pas.**

## 🔤 Je lis des sons : oi, k, au, eau, ch

Cette fois, je lis quatre nouveaux sons :

- le son **oi** (comme dans *roi* et *étoile*).
- le son **k** (comme dans *kimono* et *karaté*).
- le son **au** et le son **eau** (comme dans *gâteau* et *beau*) : ils font le même son.
- le son **ch** (comme dans *chéchia* et *chaussures*).

Je joins des sons pour faire une **syllabe** :

- ch + a = **cha** · k + i = **ki** · b + eau = **beau** · r + oi = **roi**

## 👂 J''écoute les sons qui se ressemblent

J''écoute bien deux sons proches :

- le son **k** (comme dans *képi*) et le son **g** (comme dans *gâteau*).
- le son **ch** (comme dans *chat*) et le son **j** (comme dans *jeu*).

## 📅 Les mois de l''année

Je récite les douze **mois de l''année** dans l''ordre :

> 🗝️ **janvier**, **février**, **mars**, **avril**, **mai**, **juin**, **juillet**, **août**, **septembre**, **octobre**, **novembre**, **décembre**.

Après **mars**, c''est **avril**. La fête de l''école est en **juin**.

## 🔢 Je compte de 1 à 30

Je compte jusqu''à **trente** :

> 🗝️ … **vingt (20)**, **vingt et un (21)**, **vingt-deux (22)**, … **vingt-neuf (29)**, **trente (30)**.

Après **vingt-neuf**, c''est **trente**. Il y a **trente** enfants sur la scène.

> 🗡️ À la fête, je nomme la scène et les vêtements, je décris un lieu et une personne, je dis « je veux » et « je sais », je lis oi, k, au, eau et ch, je récite les mois, et je compte jusqu''à 30.

> 🏆 Bravo ! Tu as fini l''année de français. Tu sais écouter, parler, lire de petits mots et compter de 1 à 30. Quelle belle fête !', '# 📜 Résumé : Quelle fête !

- **Les mots de la fête** : la fête, la scène, le spectacle, les guirlandes, la musique, la chanson, la danse, le poème, le conte, le gâteau, l''équipe, la chanteuse, la danseuse.
- **Les vêtements de la fête** : la chéchia et la jebba (de chez nous), le kimono (du Japon), un pantalon, des chaussures. Je dis : **je mets** ma chéchia.
- **Décrire un lieu, une personne, une chose** : la scène est **décorée** et **dorée** ; le gâteau est **grand** et **beau** ; la robe est **blanche**. **Préféré** = ce que j''aime le plus.
- **Dire ce que je veux et ce que je sais faire** : **je veux** danser ; **je sais** lire un poème ; **tu veux** ? / **tu sais** ? ; **je peux** t''aider ; **je ne veux pas**.
- **Lire des sons** : **oi** (roi, étoile), **k** (kimono, karaté), **au / eau** (gâteau, beau — même son), **ch** (chéchia, chaussures). Sons proches : **k** / **g**, **ch** / **j**.
- **Les mois de l''année** : janvier, février, mars, avril, mai, juin, juillet, août, septembre, octobre, novembre, décembre. Après mars, c''est avril ; la fête est en juin.
- **Compter de 1 à 30** : … vingt (20), vingt et un (21), vingt-deux (22), … vingt-neuf (29), trente (30). Après vingt-neuf, c''est trente.', 9, NULL)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order,
  manuel_ref = EXCLUDED.manuel_ref;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d6ca3f31-8038-5e5d-b150-22216fee4b46', 'ffaa354a-a903-51f9-80e5-bea7ab783079', 'french-3eme', 'Quiz de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d40a93c8-4a89-5bd7-aaab-7c28b91524f1', 'd6ca3f31-8038-5e5d-b150-22216fee4b46', 'le matin, quand je vois un ami, je dis :', '[{"id":"a","text":"au revoir"},{"id":"b","text":"bonjour"},{"id":"c","text":"merci"},{"id":"d","text":"bonsoir"}]'::jsonb, 'b', 'le matin, je salue avec « bonjour ». L''erreur fréquente : dire « au revoir », qui sert seulement quand on part.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cb06b55e-9ec1-599c-bfd5-e5d8f3fab0df', 'd6ca3f31-8038-5e5d-b150-22216fee4b46', 'pour dire mon nom, je dis :', '[{"id":"a","text":"j''ai un cartable"},{"id":"b","text":"où est mon stylo ?"},{"id":"c","text":"je m''appelle elyssa"},{"id":"d","text":"c''est ma famille"}]'::jsonb, 'c', 'pour me présenter, je dis « je m''appelle… » puis mon nom. L''erreur fréquente : confondre dire son nom et dire ce qu''on a (« j''ai… »).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b1e4f5b2-43d3-575d-b46f-121eebdb5616', 'd6ca3f31-8038-5e5d-b150-22216fee4b46', 'lequel de ces mots fait partie de la famille ?', '[{"id":"a","text":"cahier"},{"id":"b","text":"règle"},{"id":"c","text":"gomme"},{"id":"d","text":"maman"}]'::jsonb, 'd', 'la « maman » fait partie de la famille. L''erreur fréquente : choisir une affaire d''école (cahier, règle, gomme) au lieu d''une personne de la famille.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2c1ccef3-2fc0-5ba9-b874-af149129a9eb', 'd6ca3f31-8038-5e5d-b150-22216fee4b46', 'sur ma tête, j''ai deux :', '[{"id":"a","text":"yeux"},{"id":"b","text":"pieds"},{"id":"c","text":"stylos"},{"id":"d","text":"cahiers"}]'::jsonb, 'a', 'sur la tête, j''ai deux yeux. L''erreur fréquente : penser aux pieds, qui sont en bas, pas sur la tête.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('29a5c2c3-b473-59e1-9edf-bc2677dcd53d', 'd6ca3f31-8038-5e5d-b150-22216fee4b46', 'je compte : un, deux, trois, … quel nombre vient après trois ?', '[{"id":"a","text":"deux"},{"id":"b","text":"dix"},{"id":"c","text":"quatre"},{"id":"d","text":"huit"}]'::jsonb, 'c', 'après trois, je dis quatre : un, deux, trois, quatre. L''erreur fréquente : revenir en arrière vers « deux » au lieu d''avancer.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f6c7ba8f-a477-57dc-89dc-b8f5a3865ad8', 'ffaa354a-a903-51f9-80e5-bea7ab783079', 'french-3eme', '⭐ Exercice : je salue et je me présente', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d8d3aabe-8a59-503e-baf3-15aef14eb6d8', 'f6c7ba8f-a477-57dc-89dc-b8f5a3865ad8', 'pour remercier un ami, je dis :', '[{"id":"a","text":"merci"},{"id":"b","text":"bonsoir"},{"id":"c","text":"au revoir"},{"id":"d","text":"voici"}]'::jsonb, 'a', 'pour remercier, je dis « merci ». L''erreur fréquente : utiliser une salutation comme « bonsoir » à la place d''un remerciement.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3faf3680-6a8c-582f-8326-96ce79f0ee3d', 'f6c7ba8f-a477-57dc-89dc-b8f5a3865ad8', 'pour demander son nom à un ami, je dis :', '[{"id":"a","text":"j''aime le bleu"},{"id":"b","text":"merci beaucoup"},{"id":"c","text":"comment t''appelles-tu ?"},{"id":"d","text":"au revoir"}]'::jsonb, 'c', 'pour demander le nom, je dis « comment t''appelles-tu ? ». L''erreur fréquente : poser une autre question au lieu de demander le nom.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7d37a669-33b4-5c9b-bb49-8cb9deb5e311', 'f6c7ba8f-a477-57dc-89dc-b8f5a3865ad8', 'quand je pars, je dis :', '[{"id":"a","text":"bonjour"},{"id":"b","text":"au revoir"},{"id":"c","text":"s''il te plaît"},{"id":"d","text":"voici"}]'::jsonb, 'b', 'quand je pars, je dis « au revoir ». L''erreur fréquente : dire « bonjour », qui sert pour arriver, pas pour partir.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bd20f4e6-6ca9-5922-933b-edaf014cca67', 'f6c7ba8f-a477-57dc-89dc-b8f5a3865ad8', 'pour montrer quelqu''un, je dis :', '[{"id":"a","text":"merci"},{"id":"b","text":"au revoir"},{"id":"c","text":"où ?"},{"id":"d","text":"voici mon ami"}]'::jsonb, 'd', 'pour montrer quelqu''un, je dis « voici… » ou « c''est… ». L''erreur fréquente : utiliser un mot de politesse au lieu d''un mot pour montrer.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b0b5ec5e-d7bc-5e0c-95fe-037c25e8e276', 'f6c7ba8f-a477-57dc-89dc-b8f5a3865ad8', 'pour dire ce que j''ai dans la main, je dis :', '[{"id":"a","text":"comment t''appelles-tu ?"},{"id":"b","text":"j''ai un stylo"},{"id":"c","text":"bonsoir"},{"id":"d","text":"au revoir"}]'::jsonb, 'b', 'pour dire ce que je possède, je dis « j''ai… » : j''ai un stylo. L''erreur fréquente : confondre avec une question ou une salutation.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('25e40252-faef-5704-959b-d9f3e5e12c19', 'f6c7ba8f-a477-57dc-89dc-b8f5a3865ad8', 'le soir, pour saluer, je dis :', '[{"id":"a","text":"merci"},{"id":"b","text":"au revoir"},{"id":"c","text":"bonsoir"},{"id":"d","text":"voici"}]'::jsonb, 'c', 'le soir, je salue avec « bonsoir ». L''erreur fréquente : garder « bonjour » même le soir.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('3eeff9c9-2a9b-5617-9aed-4ef47a49f0a9', 'ffaa354a-a903-51f9-80e5-bea7ab783079', 'french-3eme', '⚔️ Le gardien du chapitre ⭐⭐⭐ : mes premiers mots', 3, 120, 30, 'boss', 'admin', 2)
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
  ('6968da3d-7923-58ab-a1f2-aa99c6ed29e4', '3eeff9c9-2a9b-5617-9aed-4ef47a49f0a9', 'je range mes affaires d''école. lequel n''est pas une affaire d''école ?', '[{"id":"a","text":"cahier"},{"id":"b","text":"gomme"},{"id":"c","text":"frère"},{"id":"d","text":"règle"}]'::jsonb, 'c', 'le « frère » est une personne de la famille, pas une affaire d''école. L''erreur fréquente : oublier que cahier, gomme et règle vont ensemble dans le cartable.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('abbef869-f0f0-576d-82ec-62999857f86c', '3eeff9c9-2a9b-5617-9aed-4ef47a49f0a9', 'lequel est une couleur ?', '[{"id":"a","text":"lundi"},{"id":"b","text":"main"},{"id":"c","text":"cartable"},{"id":"d","text":"vert"}]'::jsonb, 'd', '« vert » est une couleur. L''erreur fréquente : choisir un jour (lundi) ou une partie du corps (main) au lieu d''une couleur.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('829275ce-9574-5642-b40b-ccc7392f904b', '3eeff9c9-2a9b-5617-9aed-4ef47a49f0a9', 'je récite les jours. après mardi, c''est :', '[{"id":"a","text":"lundi"},{"id":"b","text":"mercredi"},{"id":"c","text":"dimanche"},{"id":"d","text":"vendredi"}]'::jsonb, 'b', 'après mardi vient mercredi : lundi, mardi, mercredi. L''erreur fréquente : revenir à lundi au lieu d''avancer.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f8b8591e-021e-5ca2-9d78-faf839ba7692', '3eeff9c9-2a9b-5617-9aed-4ef47a49f0a9', 'je compte : … sept, huit, neuf. quel nombre vient juste après huit ?', '[{"id":"a","text":"neuf"},{"id":"b","text":"sept"},{"id":"c","text":"deux"},{"id":"d","text":"dix"}]'::jsonb, 'a', 'après huit, je dis neuf : sept, huit, neuf, dix. L''erreur fréquente : sauter directement à dix en oubliant neuf.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bff16267-e699-53cb-baa0-d91c87160cb9', '3eeff9c9-2a9b-5617-9aed-4ef47a49f0a9', 'lola montre sa main. combien a-t-elle de mains ?', '[{"id":"a","text":"trois"},{"id":"b","text":"cinq"},{"id":"c","text":"dix"},{"id":"d","text":"deux"}]'::jsonb, 'd', 'on a deux mains, comme on a deux yeux et deux pieds. L''erreur fréquente : confondre le nombre de mains avec le nombre de doigts.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('79556161-e1b2-5838-8309-8f876b1597bd', '3eeff9c9-2a9b-5617-9aed-4ef47a49f0a9', 'un ami dit : « bonsoir ! ». à quel moment de la journée parle-t-il ?', '[{"id":"a","text":"le matin"},{"id":"b","text":"le soir"},{"id":"c","text":"à l''école seulement"},{"id":"d","text":"jamais"}]'::jsonb, 'b', 'on dit « bonsoir » le soir, et « bonjour » le matin. L''erreur fréquente : croire que « bonsoir » sert le matin.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6993fed0-ef22-5ab4-81b6-e75bab3f0cb4', 'ffaa354a-a903-51f9-80e5-bea7ab783079', 'french-3eme', '⭐⭐ Révision : ma famille, mon corps, mes couleurs', 2, 75, 15, 'practice', 'admin', 3)
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
  ('c682fe47-cff2-58e5-86d2-4f6b45891f98', '6993fed0-ef22-5ab4-81b6-e75bab3f0cb4', 'je dis : « la gomme est … ». quel mot est une couleur ?', '[{"id":"a","text":"rose"},{"id":"b","text":"mardi"},{"id":"c","text":"trois"},{"id":"d","text":"livre"}]'::jsonb, 'a', '« rose » est une couleur ; on peut dire « la gomme est rose ». L''erreur fréquente : choisir un jour, un nombre ou un objet au lieu d''une couleur.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('add5974c-365e-53e4-a20c-444bb2f58e41', '6993fed0-ef22-5ab4-81b6-e75bab3f0cb4', 'j''écris avec mon … :', '[{"id":"a","text":"pied"},{"id":"b","text":"nez"},{"id":"c","text":"stylo"},{"id":"d","text":"oreille"}]'::jsonb, 'c', 'j''écris avec un stylo ou un crayon. L''erreur fréquente : choisir une partie du corps au lieu d''une affaire d''école.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('594f0eee-16b9-5e18-9a16-d8fcc443d721', '6993fed0-ef22-5ab4-81b6-e75bab3f0cb4', 'la maman de mon papa, c''est ma :', '[{"id":"a","text":"sœur"},{"id":"b","text":"grand-mère"},{"id":"c","text":"maîtresse"},{"id":"d","text":"amie"}]'::jsonb, 'b', 'la maman du papa, c''est la grand-mère. L''erreur fréquente : confondre la grand-mère avec la maman ou la sœur.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('01f30970-55dd-5eef-9125-ac863e6d0193', '6993fed0-ef22-5ab4-81b6-e75bab3f0cb4', 'avec quoi est-ce que je sens une fleur ?', '[{"id":"a","text":"la bouche"},{"id":"b","text":"le pied"},{"id":"c","text":"l''oreille"},{"id":"d","text":"le nez"}]'::jsonb, 'd', 'je sens avec le nez. L''erreur fréquente : confondre le nez avec la bouche, qui sert à manger et à parler.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('eeee92fd-fcfa-5f8c-ba76-3ed21005ef66', '6993fed0-ef22-5ab4-81b6-e75bab3f0cb4', 'dans ma classe, la personne qui m''apprend, c''est :', '[{"id":"a","text":"le frère"},{"id":"b","text":"le grand-père"},{"id":"c","text":"le papa"},{"id":"d","text":"la maîtresse"}]'::jsonb, 'd', 'à l''école, c''est le maître ou la maîtresse qui m''apprend. L''erreur fréquente : choisir une personne de la famille au lieu de l''école.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('73eefc10-1e5f-5388-8785-f5100b24c64d', '6993fed0-ef22-5ab4-81b6-e75bab3f0cb4', 'je marche avec mes deux :', '[{"id":"a","text":"pieds"},{"id":"b","text":"yeux"},{"id":"c","text":"oreilles"},{"id":"d","text":"cahiers"}]'::jsonb, 'a', 'je marche avec mes deux pieds. L''erreur fréquente : confondre les pieds, qui servent à marcher, avec les yeux, qui servent à voir.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('543d3d29-d1dc-5d6d-8f7b-bef50d1e77ea', 'ffaa354a-a903-51f9-80e5-bea7ab783079', 'french-3eme', '👑 Défi de l''élite ⭐⭐⭐⭐ : je révise tout', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('29fde2ee-36fe-58cd-b61f-ed230b323b8f', '543d3d29-d1dc-5d6d-8f7b-bef50d1e77ea', 'adam arrive en classe le matin et voit la maîtresse. que dit-il ?', '[{"id":"a","text":"au revoir"},{"id":"b","text":"merci"},{"id":"c","text":"bonsoir"},{"id":"d","text":"bonjour"}]'::jsonb, 'd', 'le matin, en arrivant, adam dit « bonjour ». L''erreur fréquente : utiliser « au revoir », qui sert pour partir, ou « bonsoir », pour le soir.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fbfca64e-6263-51c5-abfa-3ec5f5598c26', '543d3d29-d1dc-5d6d-8f7b-bef50d1e77ea', 'lina compte ses doigts : six, sept, … quel nombre vient juste après sept ?', '[{"id":"a","text":"six"},{"id":"b","text":"huit"},{"id":"c","text":"dix"},{"id":"d","text":"deux"}]'::jsonb, 'b', 'après sept vient huit : six, sept, huit, neuf. L''erreur fréquente : revenir vers six au lieu d''avancer.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9c2a6a51-7f21-5eae-9f69-ffc204d08ef1', '543d3d29-d1dc-5d6d-8f7b-bef50d1e77ea', 'je veux montrer un ami et dire son nom. quelle petite phrase est correcte ?', '[{"id":"a","text":"au revoir mon ami"},{"id":"b","text":"merci mon ami"},{"id":"c","text":"voici mon ami adam"},{"id":"d","text":"où mon ami"}]'::jsonb, 'c', 'pour montrer et nommer, je dis « voici… » ou « c''est… » : voici mon ami adam. L''erreur fréquente : commencer par un mot de politesse ou une question.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8e074005-3314-5124-8d06-19029c3814be', '543d3d29-d1dc-5d6d-8f7b-bef50d1e77ea', 'sara dit : « j''ai deux … pour voir. » quel mot complète bien la phrase ?', '[{"id":"a","text":"yeux"},{"id":"b","text":"pieds"},{"id":"c","text":"mains"},{"id":"d","text":"oreilles"}]'::jsonb, 'a', 'on voit avec les yeux : « j''ai deux yeux pour voir ». L''erreur fréquente : choisir les oreilles (pour entendre) ou les pieds (pour marcher).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6e0f3fba-878f-579b-a471-8163504583c6', '543d3d29-d1dc-5d6d-8f7b-bef50d1e77ea', 'nous sommes lundi aujourd''hui. quel jour vient demain ?', '[{"id":"a","text":"dimanche"},{"id":"b","text":"vendredi"},{"id":"c","text":"mardi"},{"id":"d","text":"jeudi"}]'::jsonb, 'c', 'après lundi vient mardi : lundi, mardi, mercredi. L''erreur fréquente : choisir un jour plus loin dans la semaine.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cd76747b-6fb0-5b40-bdf2-f08c142d3874', '543d3d29-d1dc-5d6d-8f7b-bef50d1e77ea', 'je veux dire que je n''aime pas une couleur. quelle phrase est correcte ?', '[{"id":"a","text":"j''aime le noir"},{"id":"b","text":"je n''aime pas le noir"},{"id":"c","text":"j''ai le noir"},{"id":"d","text":"voici le noir"}]'::jsonb, 'b', 'pour dire que je n''aime pas, j''utilise « je n''aime pas… » : je n''aime pas le noir. L''erreur fréquente : oublier « ne… pas » et dire le contraire de ce que je pense.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('96b85d7f-9ca2-5306-9ed7-1875aceaf295', 'fd91eed0-0263-518d-8761-b6d7f8aed2ab', 'french-3eme', 'Quiz de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('55ca44ff-8927-594d-9034-12134491c788', '96b85d7f-9ca2-5306-9ed7-1875aceaf295', 'Dans la famille, qui est la mère ?', '[{"id":"a","text":"papi"},{"id":"b","text":"maman"},{"id":"c","text":"le frère"},{"id":"d","text":"l''oncle"}]'::jsonb, 'b', 'Maman, c''est la mère. Papa, c''est le père. L''erreur fréquente : confondre maman (la mère) avec mamie (la grand-mère).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e14b3c48-f7a0-50ba-9ada-adf99fe7548e', '96b85d7f-9ca2-5306-9ed7-1875aceaf295', 'Je montre une personne. Quel mot je peux dire ?', '[{"id":"a","text":"merci"},{"id":"b","text":"dans"},{"id":"c","text":"avec"},{"id":"d","text":"voici"}]'::jsonb, 'd', 'Pour montrer une personne, je dis c''est, voici ou voilà : « voici mon frère ». L''erreur fréquente : prendre « merci », qui sert à remercier, pas à présenter.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('12893cfc-5024-5d0e-b19d-9b2631073b28', '96b85d7f-9ca2-5306-9ed7-1875aceaf295', 'Je colle les lettres : m + a = ?', '[{"id":"a","text":"ma"},{"id":"b","text":"am"},{"id":"c","text":"mi"},{"id":"d","text":"al"}]'::jsonb, 'a', 'Je dis d''abord m, puis a : m + a = ma. L''erreur fréquente : inverser les lettres et lire « am ».', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9c0e7f7f-2a9c-50c0-8d05-e45edc5ec1b5', '96b85d7f-9ca2-5306-9ed7-1875aceaf295', 'Dans quel mot entends-tu le son « on » ?', '[{"id":"a","text":"papa"},{"id":"b","text":"mamie"},{"id":"c","text":"mon"},{"id":"d","text":"la"}]'::jsonb, 'c', 'Dans « mon », j''entends le son on, comme dans bonjour et salon. L''erreur fréquente : choisir « papa », où l''on entend le son a, pas on.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b85c9fa3-468d-560f-a026-848fd3678d82', '96b85d7f-9ca2-5306-9ed7-1875aceaf295', 'Pour demander son nom à un ami, je dis :', '[{"id":"a","text":"Où es-tu ?"},{"id":"b","text":"Merci beaucoup."},{"id":"c","text":"Au revoir."},{"id":"d","text":"Comment t''appelles-tu ?"}]'::jsonb, 'd', 'Pour demander le nom, je dis « comment t''appelles-tu ? ». L''erreur fréquente : prendre « où es-tu ? », qui demande le lieu, pas le nom.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('9aa78bf3-725c-5d62-a99a-6bfa751780ea', 'fd91eed0-0263-518d-8761-b6d7f8aed2ab', 'french-3eme', '⭐ Exercice : Ma famille et ma maison', 1, 50, 10, 'practice', 'admin', 1)
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
  ('d360b515-7e41-50f7-a876-9f045cceb9c5', '9aa78bf3-725c-5d62-a99a-6bfa751780ea', 'Le père de la famille, c''est :', '[{"id":"a","text":"mamie"},{"id":"b","text":"papa"},{"id":"c","text":"la sœur"},{"id":"d","text":"la tante"}]'::jsonb, 'b', 'Papa, c''est le père. Maman, c''est la mère. L''erreur fréquente : confondre papa (le père) avec papi (le grand-père).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e1a1e336-223f-5b6b-a26d-dce47762b9be', '9aa78bf3-725c-5d62-a99a-6bfa751780ea', 'Quel mot désigne une fille de la famille ?', '[{"id":"a","text":"le frère"},{"id":"b","text":"papi"},{"id":"c","text":"l''oncle"},{"id":"d","text":"la sœur"}]'::jsonb, 'd', 'La sœur est une fille. Le frère est un garçon. L''erreur fréquente : choisir « le frère », qui est un garçon.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9508aef8-f295-5a61-aace-9b3735425374', '9aa78bf3-725c-5d62-a99a-6bfa751780ea', 'Dans la maison, où prépare-t-on à manger ?', '[{"id":"a","text":"la cuisine"},{"id":"b","text":"la chambre"},{"id":"c","text":"le jardin"},{"id":"d","text":"le salon"}]'::jsonb, 'a', 'On prépare à manger dans la cuisine. L''erreur fréquente : choisir la chambre, où l''on dort.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d23b6153-139e-5c57-a3e0-529ab6726802', '9aa78bf3-725c-5d62-a99a-6bfa751780ea', 'Je veux montrer ma sœur. Je dis :', '[{"id":"a","text":"Merci, ma sœur."},{"id":"b","text":"Où, ma sœur ?"},{"id":"c","text":"Voilà ma sœur."},{"id":"d","text":"Et toi, ma sœur ?"}]'::jsonb, 'c', 'Pour montrer une personne, je dis c''est, voici ou voilà : « voilà ma sœur ». L''erreur fréquente : utiliser « merci », qui sert à remercier.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('64b2d8da-d1f5-5abe-826c-2379feed64c7', '9aa78bf3-725c-5d62-a99a-6bfa751780ea', 'Je colle les lettres : l + i = ?', '[{"id":"a","text":"il"},{"id":"b","text":"li"},{"id":"c","text":"la"},{"id":"d","text":"mi"}]'::jsonb, 'b', 'Je dis d''abord l, puis i : l + i = li. L''erreur fréquente : inverser les lettres et lire « il ».', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9e73560d-bf13-5519-bf5e-29dd9d7dce00', '9aa78bf3-725c-5d62-a99a-6bfa751780ea', 'La grand-mère de la famille, c''est :', '[{"id":"a","text":"maman"},{"id":"b","text":"la fille"},{"id":"c","text":"papi"},{"id":"d","text":"mamie"}]'::jsonb, 'd', 'Mamie, c''est la grand-mère. Papi, c''est le grand-père. L''erreur fréquente : confondre mamie (la grand-mère) avec maman (la mère).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('569b9851-2975-5250-ab85-804af049dc38', 'fd91eed0-0263-518d-8761-b6d7f8aed2ab', 'french-3eme', '⚔️ Le gardien du chapitre ⭐⭐⭐ : Ma famille, mon amour !', 3, 120, 30, 'boss', 'admin', 2)
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
  ('d9c8e67b-8d52-5448-9287-e91dc61fba25', '569b9851-2975-5250-ab85-804af049dc38', 'Lina dit : « ... mon papa ! » Quel mot va au début pour le montrer ?', '[{"id":"a","text":"Merci"},{"id":"b","text":"Où"},{"id":"c","text":"Voici"},{"id":"d","text":"Et toi"}]'::jsonb, 'c', 'Pour montrer une personne, on dit c''est, voici ou voilà : « voici mon papa ». L''erreur fréquente : commencer par « merci », qui sert à remercier.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f0b7b4b3-ef4e-54cf-9118-871e84115a26', '569b9851-2975-5250-ab85-804af049dc38', 'Quel mot commence par le son du « m » ?', '[{"id":"a","text":"maman"},{"id":"b","text":"la"},{"id":"c","text":"papa"},{"id":"d","text":"oncle"}]'::jsonb, 'a', '« maman » commence par le son du m. L''erreur fréquente : choisir « papa », qui commence par le son du p.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('54ae9f52-d006-5fec-a810-45a982195732', '569b9851-2975-5250-ab85-804af049dc38', 'Je lis la syllabe « mi ». Quelles lettres ai-je collées ?', '[{"id":"a","text":"l + i"},{"id":"b","text":"m + a"},{"id":"c","text":"i + m"},{"id":"d","text":"m + i"}]'::jsonb, 'd', '« mi », c''est m d''abord, puis i : m + i. L''erreur fréquente : inverser et lire « im ».', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('59a8296d-2ca5-5f02-9de2-0c9f85ad919a', '569b9851-2975-5250-ab85-804af049dc38', 'Je compte : un, deux, trois, ... Quel nombre vient après trois ?', '[{"id":"a","text":"quatre"},{"id":"b","text":"deux"},{"id":"c","text":"un"},{"id":"d","text":"dix"}]'::jsonb, 'a', 'Après trois (3) vient quatre (4) : 1, 2, 3, 4. L''erreur fréquente : redire « deux », qui vient avant trois.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('da9c4c77-5e2b-5836-989c-c69766ae39b7', '569b9851-2975-5250-ab85-804af049dc38', 'Maman demande : « ... est papi ? » Il est dans le jardin. Quel mot manque ?', '[{"id":"a","text":"Merci"},{"id":"b","text":"Où"},{"id":"c","text":"Voilà"},{"id":"d","text":"Bonjour"}]'::jsonb, 'b', 'Pour demander le lieu, on dit « où ? » : « où est papi ? ». L''erreur fréquente : choisir « voilà », qui sert à montrer, pas à demander.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f79ad9a4-ad00-5bfd-bea5-f9f20f177978', '569b9851-2975-5250-ab85-804af049dc38', 'Dans quel mot entends-tu le son « on » ?', '[{"id":"a","text":"mamie"},{"id":"b","text":"papa"},{"id":"c","text":"salon"},{"id":"d","text":"la"}]'::jsonb, 'c', 'Dans « salon », j''entends le son on, comme dans mon et bonjour. L''erreur fréquente : choisir « mamie », où l''on n''entend pas le son on.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('323f8653-8b29-5c3e-b01d-6306610d630b', 'fd91eed0-0263-518d-8761-b6d7f8aed2ab', 'french-3eme', '⭐⭐ Révision : Ma famille, mon amour !', 2, 75, 15, 'practice', 'admin', 3)
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
  ('f15cde06-f499-557c-bd64-547b4707404f', '323f8653-8b29-5c3e-b01d-6306610d630b', 'Le frère, dans la famille, c''est :', '[{"id":"a","text":"une grand-mère"},{"id":"b","text":"une fille"},{"id":"c","text":"une tante"},{"id":"d","text":"un garçon"}]'::jsonb, 'd', 'Le frère est un garçon ; la sœur est une fille. L''erreur fréquente : confondre le frère (un garçon) avec la sœur (une fille).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('729828ca-2326-548c-a68a-2ac252f1c918', '323f8653-8b29-5c3e-b01d-6306610d630b', 'Dans la maison, où dort-on ?', '[{"id":"a","text":"le jardin"},{"id":"b","text":"la chambre"},{"id":"c","text":"la cuisine"},{"id":"d","text":"le salon"}]'::jsonb, 'b', 'On dort dans la chambre. L''erreur fréquente : choisir la cuisine, où l''on prépare à manger.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d5f9a9d1-da2d-5fa3-9dfb-9dc355e18b8d', '323f8653-8b29-5c3e-b01d-6306610d630b', 'Je lis la syllabe « la ». Quelles lettres ai-je collées ?', '[{"id":"a","text":"l + a"},{"id":"b","text":"a + l"},{"id":"c","text":"m + a"},{"id":"d","text":"l + i"}]'::jsonb, 'a', '« la », c''est l d''abord, puis a : l + a. L''erreur fréquente : inverser et lire « al ».', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7734d4c8-04d5-5739-95ef-42f60603bb02', '323f8653-8b29-5c3e-b01d-6306610d630b', 'On me demande : « Comment t''appelles-tu ? » Je réponds :', '[{"id":"a","text":"Dans le jardin."},{"id":"b","text":"Merci beaucoup."},{"id":"c","text":"Je m''appelle Sami."},{"id":"d","text":"Il y a dix."}]'::jsonb, 'c', 'À « comment t''appelles-tu ? », je réponds par mon nom : « je m''appelle Sami ». L''erreur fréquente : répondre « dans le jardin », qui dit le lieu, pas le nom.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ce9cc688-36be-5cb7-84c6-42ae6e8a8368', '323f8653-8b29-5c3e-b01d-6306610d630b', 'Dans quel mot entends-tu le son « on » ?', '[{"id":"a","text":"mami"},{"id":"b","text":"papa"},{"id":"c","text":"ma"},{"id":"d","text":"bonjour"}]'::jsonb, 'd', 'Dans « bonjour », j''entends le son on, comme dans mon et salon. L''erreur fréquente : choisir « papa », où l''on entend le son a.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0b0efe57-fac1-5816-b0eb-4802c83cb50d', '323f8653-8b29-5c3e-b01d-6306610d630b', 'Je compte mes doigts d''une main : 1, 2, 3, 4, ... Quel nombre vient après quatre ?', '[{"id":"a","text":"trois"},{"id":"b","text":"cinq"},{"id":"c","text":"dix"},{"id":"d","text":"deux"}]'::jsonb, 'b', 'Après quatre (4) vient cinq (5) : 1, 2, 3, 4, 5. L''erreur fréquente : redire « trois », qui vient avant quatre.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('46a6462f-c6b9-5b41-a7fa-f6ceada58b00', '579e4915-2832-573a-bdb3-235828d6cba0', 'french-3eme', 'Quiz de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('bf9f72fe-9559-5f5c-860a-c3f52f677ce6', '46a6462f-c6b9-5b41-a7fa-f6ceada58b00', 'À l''école, dans quel lieu mange-t-on ?', '[{"id":"a","text":"la bibliothèque"},{"id":"b","text":"la cantine"},{"id":"c","text":"la cour"},{"id":"d","text":"la classe"}]'::jsonb, 'b', 'On mange à la cantine. L''erreur fréquente : confondre la cantine (pour manger) et la bibliothèque (pour lire des livres).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a5105259-3f30-5401-8735-ab4e797969a3', '46a6462f-c6b9-5b41-a7fa-f6ceada58b00', 'Comment s''appelle le lieu couvert, près de la cour ?', '[{"id":"a","text":"le cartable"},{"id":"b","text":"le drapeau"},{"id":"c","text":"le crayon"},{"id":"d","text":"le préau"}]'::jsonb, 'd', 'Le préau est l''endroit couvert près de la cour. L''erreur fréquente : choisir le cartable, qui est un sac pour ranger les affaires, pas un lieu.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d3116b03-9e86-5f35-9790-efb5c37311c1', '46a6462f-c6b9-5b41-a7fa-f6ceada58b00', 'Je joins les lettres : d + o = … ?', '[{"id":"a","text":"od"},{"id":"b","text":"do"},{"id":"c","text":"du"},{"id":"d","text":"ro"}]'::jsonb, 'b', 'Je lis d''abord d, puis o : d + o = do. L''erreur fréquente : inverser l''ordre et lire « od » au lieu de « do ».', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('05024b0b-89cc-515e-86fc-69cd356cf760', '46a6462f-c6b9-5b41-a7fa-f6ceada58b00', 'Choisis le mot qui manque : « Il y a un livre … le cartable. »', '[{"id":"a","text":"dans"},{"id":"b","text":"qui"},{"id":"c","text":"où"},{"id":"d","text":"et"}]'::jsonb, 'a', 'Pour dire où est une chose, on dit « il y a … dans … » : il y a un livre dans le cartable. L''erreur fréquente : mettre « qui », qui sert à poser une question sur une personne.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c3792795-1e63-5370-a1f4-7f54991d9caf', '46a6462f-c6b9-5b41-a7fa-f6ceada58b00', 'Quel mot sert à poser une question sur une personne ?', '[{"id":"a","text":"où ?"},{"id":"b","text":"que ?"},{"id":"c","text":"qui ?"},{"id":"d","text":"dans ?"}]'::jsonb, 'c', 'On demande « qui ? » pour une personne (Qui est dans la classe ? La maîtresse). L''erreur fréquente : utiliser « où ? », qui sert à demander un lieu.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('06605cbe-1b69-58c0-9636-98872b253b34', '579e4915-2832-573a-bdb3-235828d6cba0', 'french-3eme', '⭐ Exercice : les lieux et les affaires de l''école', 1, 50, 10, 'practice', 'admin', 1)
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
  ('47b6c045-2bdf-57f7-871f-6932c24dffc4', '06605cbe-1b69-58c0-9636-98872b253b34', 'Dans quel lieu joue-t-on à la récréation ?', '[{"id":"a","text":"la cantine"},{"id":"b","text":"le bureau"},{"id":"c","text":"la cour"},{"id":"d","text":"la bibliothèque"}]'::jsonb, 'c', 'On joue dans la cour à la récréation. L''erreur fréquente : choisir la cantine, qui est le lieu où l''on mange.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5254f554-ceef-586a-b4de-fbd461158427', '06605cbe-1b69-58c0-9636-98872b253b34', 'Avec quoi est-ce que j''efface ?', '[{"id":"a","text":"une gomme"},{"id":"b","text":"un livre"},{"id":"c","text":"une règle"},{"id":"d","text":"un cahier"}]'::jsonb, 'a', 'J''efface avec une gomme. L''erreur fréquente : confondre la gomme (pour effacer) et la règle (pour tracer un trait).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('99b20fa5-8d21-5d7d-bf98-55040d703681', '06605cbe-1b69-58c0-9636-98872b253b34', 'Comment appelle-t-on la personne qui fait la classe ?', '[{"id":"a","text":"l''élève"},{"id":"b","text":"le camarade"},{"id":"c","text":"l''ami"},{"id":"d","text":"la maîtresse"}]'::jsonb, 'd', 'La maîtresse fait la classe. L''erreur fréquente : choisir l''élève, qui est l''enfant qui apprend à l''école.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('37fb1222-28be-5e5a-ba6d-bcaf1c109f0b', '06605cbe-1b69-58c0-9636-98872b253b34', 'Dans quoi est-ce que je range mes affaires ?', '[{"id":"a","text":"le préau"},{"id":"b","text":"le cartable"},{"id":"c","text":"le drapeau"},{"id":"d","text":"la cour"}]'::jsonb, 'b', 'Je range mes affaires dans le cartable. L''erreur fréquente : choisir le préau, qui est un lieu de l''école, pas un sac.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2652b061-b025-5ba4-9ebd-910a0175a6ed', '06605cbe-1b69-58c0-9636-98872b253b34', 'Avec quoi est-ce que je lis ?', '[{"id":"a","text":"un livre"},{"id":"b","text":"une gomme"},{"id":"c","text":"un crayon"},{"id":"d","text":"une règle"}]'::jsonb, 'a', 'Je lis avec un livre. L''erreur fréquente : choisir le crayon, qui sert à écrire ou à dessiner.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e58ef6a2-4434-551d-8e71-0ac9c0a87263', '06605cbe-1b69-58c0-9636-98872b253b34', 'Dans quel lieu lit-on des livres ?', '[{"id":"a","text":"la cantine"},{"id":"b","text":"la cour"},{"id":"c","text":"le bureau"},{"id":"d","text":"la bibliothèque"}]'::jsonb, 'd', 'On lit des livres à la bibliothèque. L''erreur fréquente : choisir la cantine, qui est le lieu où l''on mange.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('05a1db80-513a-572e-a7b2-82ae1fbd0d5a', '579e4915-2832-573a-bdb3-235828d6cba0', 'french-3eme', '⚔️ Le gardien du chapitre ⭐⭐⭐ : les sons de l''école', 3, 120, 30, 'boss', 'admin', 2)
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
  ('415d5a09-bb03-5dcd-8d91-a6f21ac10b74', '05a1db80-513a-572e-a7b2-82ae1fbd0d5a', 'Quelle lettre fais-tu entendre au début du mot « domino » ?', '[{"id":"a","text":"le son r"},{"id":"b","text":"le son d"},{"id":"c","text":"le son u"},{"id":"d","text":"le son o"}]'::jsonb, 'b', '« domino » commence par le son d : do-mi-no. L''erreur fréquente : entendre le o qui vient juste après le d, au lieu du tout premier son.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('014cf8a5-2647-5e36-964c-83b4f73dda7d', '05a1db80-513a-572e-a7b2-82ae1fbd0d5a', 'Quel mot commence par le son « b » ?', '[{"id":"a","text":"papa"},{"id":"b","text":"pile"},{"id":"c","text":"bébé"},{"id":"d","text":"pomme"}]'::jsonb, 'c', '« bébé » commence par le son b. L''erreur fréquente : confondre le son b (bébé) avec le son p (papa, pomme), qui se ressemblent.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f9b9efb1-a8ef-55b1-b76f-bc8c0fe66444', '05a1db80-513a-572e-a7b2-82ae1fbd0d5a', 'Je lis : r + u = … ?', '[{"id":"a","text":"ru"},{"id":"b","text":"ur"},{"id":"c","text":"ro"},{"id":"d","text":"du"}]'::jsonb, 'a', 'Je lis d''abord r, puis u : r + u = ru. L''erreur fréquente : inverser et lire « ur » au lieu de « ru ».', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7421dc69-3c87-50d8-ab11-32c00c095552', '05a1db80-513a-572e-a7b2-82ae1fbd0d5a', 'Complète : « Il y a des élèves … la cour. »', '[{"id":"a","text":"qui"},{"id":"b","text":"dans"},{"id":"c","text":"où"},{"id":"d","text":"que"}]'::jsonb, 'b', 'Pour dire où sont les élèves, on dit « il y a … dans … » : il y a des élèves dans la cour. L''erreur fréquente : mettre « qui », qui sert à poser une question.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e0413769-b122-57cd-bc6f-a013468ffeb9', '05a1db80-513a-572e-a7b2-82ae1fbd0d5a', 'Dans quel mot entends-tu le son « ou » ?', '[{"id":"a","text":"do"},{"id":"b","text":"ru"},{"id":"c","text":"lo"},{"id":"d","text":"cou"}]'::jsonb, 'd', '« cou » contient le son ou. L''erreur fréquente : confondre le son o (do, lo) avec le son ou (cou).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7a1bb4b3-9354-5a86-9f73-d9265b429135', '05a1db80-513a-572e-a7b2-82ae1fbd0d5a', 'Dans quel mot entends-tu le son « i » ?', '[{"id":"a","text":"lune"},{"id":"b","text":"ru"},{"id":"c","text":"lit"},{"id":"d","text":"du"}]'::jsonb, 'c', '« lit » contient le son i. L''erreur fréquente : confondre le son u (lune, du) avec le son i (lit).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ad0f3c07-865f-52ef-a38b-f97b7756c133', '579e4915-2832-573a-bdb3-235828d6cba0', 'french-3eme', '⭐⭐ Révision : mon école (nombres, mots et sons)', 2, 75, 15, 'practice', 'admin', 3)
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
  ('69f26143-f692-5b95-802e-d829a15a3021', 'ad0f3c07-865f-52ef-a38b-f97b7756c133', 'Je lis : m + o = … ?', '[{"id":"a","text":"om"},{"id":"b","text":"mu"},{"id":"c","text":"ro"},{"id":"d","text":"mo"}]'::jsonb, 'd', 'Je lis d''abord m, puis o : m + o = mo. L''erreur fréquente : inverser et lire « om » au lieu de « mo ».', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1d39b7fc-5897-5754-afce-f9a87a121138', 'ad0f3c07-865f-52ef-a38b-f97b7756c133', 'Quel objet est accroché sur le mur de la classe ?', '[{"id":"a","text":"la cantine"},{"id":"b","text":"le drapeau"},{"id":"c","text":"le préau"},{"id":"d","text":"la récréation"}]'::jsonb, 'b', 'Sur le mur de la classe, il y a un drapeau. L''erreur fréquente : choisir le préau ou la cantine, qui sont des lieux, pas des objets sur le mur.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bbcf3400-6991-50ca-85cb-29aee05d78c7', 'ad0f3c07-865f-52ef-a38b-f97b7756c133', 'Quel nombre vient juste après quinze (15) ?', '[{"id":"a","text":"dix-huit"},{"id":"b","text":"quatorze"},{"id":"c","text":"vingt"},{"id":"d","text":"seize"}]'::jsonb, 'd', 'Après quinze (15) vient seize (16). L''erreur fréquente : revenir en arrière vers quatorze (14) au lieu d''avancer.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fa2bfcaa-e70d-51f2-a163-955b81a66df1', 'ad0f3c07-865f-52ef-a38b-f97b7756c133', 'Comment écrit-on le nombre 20 en lettres ?', '[{"id":"a","text":"douze"},{"id":"b","text":"vingt"},{"id":"c","text":"dix"},{"id":"d","text":"treize"}]'::jsonb, 'b', 'Le nombre 20 s''écrit « vingt ». L''erreur fréquente : confondre vingt (20) avec douze (12).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('71228add-734d-5908-9da0-b0132d7578a6', 'ad0f3c07-865f-52ef-a38b-f97b7756c133', 'Quel mot sert à poser une question sur un lieu ?', '[{"id":"a","text":"où ?"},{"id":"b","text":"qui ?"},{"id":"c","text":"et ?"},{"id":"d","text":"dans ?"}]'::jsonb, 'a', 'On demande « où ? » pour un lieu (Où es-tu ? Dans la cour). L''erreur fréquente : utiliser « qui ? », qui sert à demander une personne.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('804f07e5-7bae-51b8-bf2d-609a9b049a47', 'ad0f3c07-865f-52ef-a38b-f97b7756c133', 'Avec quoi est-ce que je trace un trait ?', '[{"id":"a","text":"une gomme"},{"id":"b","text":"un livre"},{"id":"c","text":"une règle"},{"id":"d","text":"un cahier"}]'::jsonb, 'c', 'Je trace un trait avec une règle. L''erreur fréquente : confondre la règle (pour tracer) et la gomme (pour effacer).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('44f35254-f37b-5ff4-bc37-04f4aeb3e070', '579e4915-2832-573a-bdb3-235828d6cba0', 'french-3eme', '👑 Défi de l''élite ⭐⭐⭐⭐ : maître de l''école', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('7fb61a66-cfcf-517e-8400-56583b979bf4', '44f35254-f37b-5ff4-bc37-04f4aeb3e070', 'Léa demande : « … est dans la classe ? » On lui répond : « La maîtresse. » Quel mot manque dans sa question ?', '[{"id":"a","text":"où"},{"id":"b","text":"dans"},{"id":"c","text":"qui"},{"id":"d","text":"que"}]'::jsonb, 'c', 'La réponse est une personne (la maîtresse), donc la question est « Qui est dans la classe ? ». L''erreur fréquente : utiliser « où », qui demande un lieu, pas une personne.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('62fd5f9d-a00a-5c3b-abe1-1f038c869c4d', '44f35254-f37b-5ff4-bc37-04f4aeb3e070', 'Trois mots commencent par le son « o ». Lequel ne commence PAS par le son « o » ?', '[{"id":"a","text":"roue"},{"id":"b","text":"olive"},{"id":"c","text":"orange"},{"id":"d","text":"ortie"}]'::jsonb, 'a', '« roue » commence par le son r, pas par le son o. L''erreur fréquente : voir la lettre o écrite dans le mot et croire qu''on l''entend au début.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('02863ddf-7815-51ef-ac63-ee188ca5bd38', '44f35254-f37b-5ff4-bc37-04f4aeb3e070', 'Sami dit : « Je mange dans la bibliothèque. » Que faut-il corriger ?', '[{"id":"a","text":"rien, la phrase est juste"},{"id":"b","text":"on lit à la cantine"},{"id":"c","text":"on joue à la bibliothèque"},{"id":"d","text":"on mange à la cantine, pas à la bibliothèque"}]'::jsonb, 'd', 'On mange à la cantine ; à la bibliothèque, on lit des livres. L''erreur fréquente : confondre la cantine (pour manger) et la bibliothèque (pour lire).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5423da57-e071-55c7-bb45-586869d59d44', '44f35254-f37b-5ff4-bc37-04f4aeb3e070', 'Je lis la syllabe « du ». Quelles lettres ai-je jointes ?', '[{"id":"a","text":"d + o"},{"id":"b","text":"d + u"},{"id":"c","text":"u + d"},{"id":"d","text":"r + u"}]'::jsonb, 'b', '« du » se lit d puis u : d + u = du. L''erreur fréquente : choisir d + o (qui donne « do ») au lieu de d + u.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('48fcaac1-5a2d-5d90-88ef-6b59250a0e89', '44f35254-f37b-5ff4-bc37-04f4aeb3e070', 'Quel mot contient le son « u », comme dans « lune » ?', '[{"id":"a","text":"lit"},{"id":"b","text":"do"},{"id":"c","text":"rue"},{"id":"d","text":"cou"}]'::jsonb, 'c', '« rue » contient le son u, comme « lune ». L''erreur fréquente : confondre le son u (rue) avec le son ou (cou) ou le son i (lit).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('cbd5a0f0-6fdf-5b98-a169-cb7046b134f9', '44f35254-f37b-5ff4-bc37-04f4aeb3e070', 'Range ces nombres du plus petit au plus grand : seize, douze, dix-neuf. Lequel est le plus petit ?', '[{"id":"a","text":"douze"},{"id":"b","text":"dix-neuf"},{"id":"c","text":"seize"},{"id":"d","text":"ils sont égaux"}]'::jsonb, 'a', 'douze (12) est plus petit que seize (16) et que dix-neuf (19). L''erreur fréquente : choisir dix-neuf en croyant que « neuf » le rend petit, alors que dix-neuf vaut 19.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('2cfa4dd4-27d1-52c1-91c9-85d6b3ecc024', '051b4252-0a68-5811-9e48-2e0b2b26eca8', 'french-3eme', 'Quiz de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('1f4410d2-4f80-5a1e-a021-5a4f4c6074e0', '2cfa4dd4-27d1-52c1-91c9-85d6b3ecc024', 'Avec quoi est-ce que je sens les odeurs ?', '[{"id":"a","text":"la main"},{"id":"b","text":"le nez"},{"id":"c","text":"le pied"},{"id":"d","text":"le dos"}]'::jsonb, 'b', 'j''ai un nez pour sentir. L''erreur fréquente : confondre le nez (sentir) avec la bouche (goûter).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2bfd2635-5170-5f52-9837-9c74d33461e4', '2cfa4dd4-27d1-52c1-91c9-85d6b3ecc024', 'Dans le corps, qu''est-ce qui est en bas ?', '[{"id":"a","text":"les cheveux"},{"id":"b","text":"la tête"},{"id":"c","text":"les oreilles"},{"id":"d","text":"les pieds"}]'::jsonb, 'd', 'la tête est en haut et les pieds sont en bas. L''erreur fréquente : mettre la tête en bas.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('60bbf1c9-cf5b-5300-b371-0bb02a6ef34e', '2cfa4dd4-27d1-52c1-91c9-85d6b3ecc024', 'Quel jour vient juste après lundi ?', '[{"id":"a","text":"mardi"},{"id":"b","text":"dimanche"},{"id":"c","text":"samedi"},{"id":"d","text":"jeudi"}]'::jsonb, 'a', 'dans la semaine, après lundi vient mardi. L''erreur fréquente : oublier l''ordre des jours.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fdb439e3-e8cd-5ffa-afd1-dc5e6ad02b00', '2cfa4dd4-27d1-52c1-91c9-85d6b3ecc024', 'Je lis la syllabe : t + ou = ?', '[{"id":"a","text":"to"},{"id":"b","text":"ti"},{"id":"c","text":"tou"},{"id":"d","text":"ta"}]'::jsonb, 'c', 't fait le son [t] et ou fait le son [ou] : ensemble, cela fait « tou ». L''erreur fréquente : lire « ou » comme [o].', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0410219d-308c-56cb-b8af-b145ed36ec22', '2cfa4dd4-27d1-52c1-91c9-85d6b3ecc024', 'Combien de jours y a-t-il dans une semaine ?', '[{"id":"a","text":"trois"},{"id":"b","text":"sept"},{"id":"c","text":"dix"},{"id":"d","text":"vingt"}]'::jsonb, 'b', 'la semaine a sept jours : lundi, mardi, mercredi, jeudi, vendredi, samedi, dimanche. L''erreur fréquente : compter seulement les jours d''école.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('204f9ca8-f2b4-5739-b74d-066644364882', '051b4252-0a68-5811-9e48-2e0b2b26eca8', 'french-3eme', '⭐ Exercice : je nomme mon corps', 1, 50, 10, 'practice', 'admin', 1)
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
  ('2d3c5573-7276-559a-9fe8-67956f563967', '204f9ca8-f2b4-5739-b74d-066644364882', 'Avec quoi est-ce que je vois ?', '[{"id":"a","text":"le dos"},{"id":"b","text":"la main"},{"id":"c","text":"les yeux"},{"id":"d","text":"le pied"}]'::jsonb, 'c', 'j''ai deux yeux pour voir. L''erreur fréquente : confondre les yeux (voir) avec les oreilles (écouter).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3e3df111-1329-510b-ac84-ef26e572977c', '204f9ca8-f2b4-5739-b74d-066644364882', 'Avec quoi est-ce que j''écoute ?', '[{"id":"a","text":"les oreilles"},{"id":"b","text":"le nez"},{"id":"c","text":"la jambe"},{"id":"d","text":"la bouche"}]'::jsonb, 'a', 'j''ai deux oreilles pour écouter. L''erreur fréquente : penser qu''on écoute avec la bouche.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1d9b20b7-8eff-5f08-8cd8-9302030e7812', '204f9ca8-f2b4-5739-b74d-066644364882', 'Sur la main, il y a les ...', '[{"id":"a","text":"cheveux"},{"id":"b","text":"genoux"},{"id":"c","text":"dents"},{"id":"d","text":"doigts"}]'::jsonb, 'd', 'la main a des doigts. L''erreur fréquente : placer les doigts sur le pied au lieu de la main.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('dd462ee7-632d-5c17-ba33-c39821d8c154', '204f9ca8-f2b4-5739-b74d-066644364882', 'Pour me laver, j''utilise le ...', '[{"id":"a","text":"miroir"},{"id":"b","text":"savon"},{"id":"c","text":"peigne"},{"id":"d","text":"lit"}]'::jsonb, 'b', 'j''utilise le savon pour me laver. L''erreur fréquente : choisir le peigne, qui sert pour les cheveux.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('7da834b5-314f-5a7b-9c2f-13fd6dba79ee', '204f9ca8-f2b4-5739-b74d-066644364882', 'Quelle partie est en haut du corps ?', '[{"id":"a","text":"le pied"},{"id":"b","text":"le genou"},{"id":"c","text":"la tête"},{"id":"d","text":"la jambe"}]'::jsonb, 'c', 'la tête est en haut et les pieds sont en bas. L''erreur fréquente : oublier que la tête est tout en haut.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bdd182b6-fad2-51d2-b5b5-2891d7a4f7a0', '204f9ca8-f2b4-5739-b74d-066644364882', 'Combien ai-je de mains ?', '[{"id":"a","text":"deux"},{"id":"b","text":"cinq"},{"id":"c","text":"dix"},{"id":"d","text":"vingt"}]'::jsonb, 'a', 'j''ai deux mains (et dix doigts). L''erreur fréquente : confondre le nombre de mains (deux) et de doigts (dix).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('797ce678-42ab-5b1f-b3d0-66bc74637cd8', '051b4252-0a68-5811-9e48-2e0b2b26eca8', 'french-3eme', '⚔️ Le gardien du chapitre ⭐⭐⭐ : mon corps et mes sons', 3, 120, 30, 'boss', 'admin', 2)
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
  ('d924508f-cfbe-5803-8269-2a8cf71507bb', '797ce678-42ab-5b1f-b3d0-66bc74637cd8', 'Avec quoi est-ce que je goûte les aliments ?', '[{"id":"a","text":"le doigt"},{"id":"b","text":"la langue"},{"id":"c","text":"l''oreille"},{"id":"d","text":"le dos"}]'::jsonb, 'b', 'je goûte avec la bouche et la langue. L''erreur fréquente : confondre goûter (la langue) et sentir (le nez).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f16ebb7a-67e3-5a43-a51b-1fa3d3dc4840', '797ce678-42ab-5b1f-b3d0-66bc74637cd8', 'Je lis la syllabe : j + ou = ?', '[{"id":"a","text":"jo"},{"id":"b","text":"ja"},{"id":"c","text":"ji"},{"id":"d","text":"jou"}]'::jsonb, 'd', 'j fait le son [j] et ou fait le son [ou] : ensemble, cela fait « jou ». L''erreur fréquente : lire « ou » comme [o].', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d1c05e55-10d7-5bc6-b519-e153f4d7220b', '797ce678-42ab-5b1f-b3d0-66bc74637cd8', 'Dans quel mot entends-tu le son [ou] ?', '[{"id":"a","text":"roue"},{"id":"b","text":"lit"},{"id":"c","text":"moto"},{"id":"d","text":"ami"}]'::jsonb, 'a', 'dans « roue », on entend bien le son [ou]. L''erreur fréquente : entendre [o] au lieu de [ou].', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f7de79fd-9c1b-5cf0-83eb-ad94cbfd1bd1', '797ce678-42ab-5b1f-b3d0-66bc74637cd8', 'Pour me brosser les dents, j''utilise la brosse à dents et le ...', '[{"id":"a","text":"savon"},{"id":"b","text":"shampoing"},{"id":"c","text":"dentifrice"},{"id":"d","text":"miroir"}]'::jsonb, 'c', 'pour les dents, j''utilise la brosse à dents et le dentifrice. L''erreur fréquente : choisir le shampoing, qui sert pour les cheveux.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3da6c76d-5b7d-5e56-939c-a12809333a55', '797ce678-42ab-5b1f-b3d0-66bc74637cd8', 'Quel mot commence par le son [t] ?', '[{"id":"a","text":"joli"},{"id":"b","text":"midi"},{"id":"c","text":"ami"},{"id":"d","text":"tortue"}]'::jsonb, 'd', '« tortue » commence par le son [t]. L''erreur fréquente : confondre le son [t] et le son [d], qui se ressemblent.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('83b6036c-dc7d-5e6f-bf7f-5d86cc2f7163', '797ce678-42ab-5b1f-b3d0-66bc74637cd8', 'Quel jour vient juste après mardi ?', '[{"id":"a","text":"lundi"},{"id":"b","text":"mercredi"},{"id":"c","text":"dimanche"},{"id":"d","text":"samedi"}]'::jsonb, 'b', 'dans la semaine, après mardi vient mercredi. L''erreur fréquente : revenir à lundi au lieu d''avancer à mercredi.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f974bb00-cf29-557a-bae9-0b54ca38f5af', '051b4252-0a68-5811-9e48-2e0b2b26eca8', 'french-3eme', '⭐⭐ Révision : mon corps, ma toilette, mes sons', 2, 75, 15, 'practice', 'admin', 3)
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
  ('55471905-c960-5731-987d-d77a2b72f07a', 'f974bb00-cf29-557a-bae9-0b54ca38f5af', 'Avec quoi est-ce que je parle ?', '[{"id":"a","text":"le genou"},{"id":"b","text":"le pied"},{"id":"c","text":"le dos"},{"id":"d","text":"la bouche"}]'::jsonb, 'd', 'je parle avec la bouche. L''erreur fréquente : confondre la bouche (parler) et le nez (sentir).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('77c1ed4b-6f62-5118-8906-cb68524f46a1', 'f974bb00-cf29-557a-bae9-0b54ca38f5af', 'Pour me peigner les cheveux, j''utilise le ...', '[{"id":"a","text":"savon"},{"id":"b","text":"peigne"},{"id":"c","text":"dentifrice"},{"id":"d","text":"miroir"}]'::jsonb, 'b', 'j''utilise le peigne pour mes cheveux. L''erreur fréquente : choisir le savon, qui sert à se laver.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('da025371-d89d-5043-a08d-8bb8395f5213', 'f974bb00-cf29-557a-bae9-0b54ca38f5af', 'Je lis la syllabe : l + e = ?', '[{"id":"a","text":"la"},{"id":"b","text":"lo"},{"id":"c","text":"le"},{"id":"d","text":"li"}]'::jsonb, 'c', 'l fait le son [l] et e fait le son [e] : ensemble, cela fait « le ». L''erreur fréquente : lire « e » comme [a].', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('98a4c74a-4439-5c84-ab4f-c4d2bd474792', 'f974bb00-cf29-557a-bae9-0b54ca38f5af', 'Dans le mot « jeu », quel son entends-tu à la fin ?', '[{"id":"a","text":"[eu]"},{"id":"b","text":"[a]"},{"id":"c","text":"[i]"},{"id":"d","text":"[o]"}]'::jsonb, 'a', 'dans « jeu », on entend le son [eu] à la fin. L''erreur fréquente : confondre [e] (le) et [eu] (jeu).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4e504e4b-bb77-5fe9-b689-89c76ab0e41b', 'f974bb00-cf29-557a-bae9-0b54ca38f5af', 'Quelle partie relie le bras à la main ? Sur le bras, il y a la main et les ...', '[{"id":"a","text":"oreilles"},{"id":"b","text":"doigts"},{"id":"c","text":"cheveux"},{"id":"d","text":"dents"}]'::jsonb, 'b', 'sur la main, au bout du bras, il y a les doigts. L''erreur fréquente : placer les doigts ailleurs que sur la main.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9296fb04-ec6e-57f4-8632-820c90db05a5', 'f974bb00-cf29-557a-bae9-0b54ca38f5af', 'Quel jour vient juste avant dimanche ?', '[{"id":"a","text":"lundi"},{"id":"b","text":"mardi"},{"id":"c","text":"samedi"},{"id":"d","text":"jeudi"}]'::jsonb, 'c', 'dans la semaine, avant dimanche vient samedi. L''erreur fréquente : oublier l''ordre des jours à la fin de la semaine.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('fd731c33-66db-5f12-bfbb-91fae20e1241', 'd9567912-0c24-5610-adfb-5a758276e321', 'french-3eme', 'Quiz de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('74b91b90-e9e2-5226-8c08-fe5fc3406d46', 'fd731c33-66db-5f12-bfbb-91fae20e1241', 'Lequel de ces mots est un aliment ?', '[{"id":"a","text":"une tasse"},{"id":"b","text":"un fouet"},{"id":"c","text":"une assiette"},{"id":"d","text":"un gâteau"}]'::jsonb, 'd', 'Un gâteau est un aliment : on le mange. La tasse, le fouet et l''assiette sont des ustensiles : ils servent à manger ou à cuisiner. L''erreur fréquente : confondre ce qu''on mange avec l''objet qui sert à manger.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('fa9f40c5-c02c-5c20-9e70-1e987ff7e232', 'fd731c33-66db-5f12-bfbb-91fae20e1241', 'Le matin, quel repas est-ce que je prends ?', '[{"id":"a","text":"le dîner"},{"id":"b","text":"le déjeuner"},{"id":"c","text":"le petit déjeuner"},{"id":"d","text":"le goûter"}]'::jsonb, 'c', 'Le matin, on prend le petit déjeuner. Le déjeuner est le midi et le dîner est le soir. L''erreur fréquente : confondre le repas du matin avec celui du soir.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('23eda5c8-6bdb-5f59-a9a5-8648a9eec022', 'fd731c33-66db-5f12-bfbb-91fae20e1241', 'Quel mot dit une grande quantité ?', '[{"id":"a","text":"beaucoup"},{"id":"b","text":"un peu"},{"id":"c","text":"rien"},{"id":"d","text":"jamais"}]'::jsonb, 'a', '« Beaucoup » dit une grande quantité : il y a beaucoup de fruits. « Un peu » dit une petite quantité. L''erreur fréquente : prendre « un peu » pour une grande quantité.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('9e887d61-2bc0-59f9-9de2-f39ad356d634', 'fd731c33-66db-5f12-bfbb-91fae20e1241', 'À table, avant de commencer à manger, on dit :', '[{"id":"a","text":"« Bonne nuit ! »"},{"id":"b","text":"« Bon appétit ! »"},{"id":"c","text":"« Au revoir ! »"},{"id":"d","text":"« À demain ! »"}]'::jsonb, 'b', 'Avant de manger, on dit « Bon appétit ! ». « Bonne nuit ! » se dit le soir avant de dormir. L''erreur fréquente : choisir une formule qui n''est pas pour le repas.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c184d782-8cfd-572f-b902-f4f7f3eda058', 'fd731c33-66db-5f12-bfbb-91fae20e1241', 'Dans le mot « tasse », quelles lettres font le son [s] ?', '[{"id":"a","text":"la lettre t"},{"id":"b","text":"la lettre é"},{"id":"c","text":"les lettres ss"},{"id":"d","text":"la lettre b"}]'::jsonb, 'c', 'Entre deux voyelles, le son [s] s''écrit « ss », comme dans « tasse » et « assiette ». L''erreur fréquente : écrire un seul « s » entre deux voyelles.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('f78bf935-ec01-5bec-81eb-927f118fdd22', 'd9567912-0c24-5610-adfb-5a758276e321', 'french-3eme', '⭐ Exercice : je remplis mon assiette', 1, 50, 10, 'practice', 'admin', 1)
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
  ('af0e7bb2-47de-5561-aab8-30b15c8d825a', 'f78bf935-ec01-5bec-81eb-927f118fdd22', 'Lequel de ces mots est une boisson ?', '[{"id":"a","text":"le pain"},{"id":"b","text":"le lait"},{"id":"c","text":"la salade"},{"id":"d","text":"le fromage"}]'::jsonb, 'b', 'Le lait est une boisson : on le boit. Le pain, la salade et le fromage se mangent. L''erreur fréquente : oublier que le lait est une boisson.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5c560397-f5ae-5816-98c6-47118c588da2', 'f78bf935-ec01-5bec-81eb-927f118fdd22', 'Le soir, quel repas est-ce que je prends ?', '[{"id":"a","text":"le petit déjeuner"},{"id":"b","text":"le goûter"},{"id":"c","text":"le dîner"},{"id":"d","text":"le déjeuner"}]'::jsonb, 'c', 'Le soir, on prend le dîner. Le matin c''est le petit déjeuner et le midi c''est le déjeuner. L''erreur fréquente : confondre le repas du soir avec celui du midi.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d096a0c1-aa38-5ec9-8966-9c4627f88c83', 'f78bf935-ec01-5bec-81eb-927f118fdd22', 'Avec quel ustensile est-ce que je bats les œufs ?', '[{"id":"a","text":"un fouet"},{"id":"b","text":"une tasse"},{"id":"c","text":"une assiette"},{"id":"d","text":"un tablier"}]'::jsonb, 'a', 'On bat les œufs avec un fouet. La tasse sert à boire, l''assiette à manger, et le tablier protège les habits. L''erreur fréquente : choisir un objet qui ne sert pas à battre.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1d457b65-3c6a-5fa5-8512-e62d1f848f83', 'f78bf935-ec01-5bec-81eb-927f118fdd22', 'Quel nombre vient juste après onze (11) ?', '[{"id":"a","text":"douze (12)"},{"id":"b","text":"dix (10)"},{"id":"c","text":"vingt (20)"},{"id":"d","text":"treize (13)"}]'::jsonb, 'a', 'Après onze (11) vient douze (12). Dix (10) vient avant onze. L''erreur fréquente : sauter un nombre dans la suite 10, 11, 12, 13.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('04c7a430-2d0d-5489-896a-cf0052ccba5a', 'f78bf935-ec01-5bec-81eb-927f118fdd22', 'Il y a trop de sel dans la soupe. « Trop » veut dire :', '[{"id":"a","text":"il n''y a pas de sel"},{"id":"b","text":"il y a juste ce qu''il faut"},{"id":"c","text":"il y a un tout petit peu de sel"},{"id":"d","text":"il y a trop de sel, ce n''est pas bon"}]'::jsonb, 'd', '« Trop » veut dire une quantité trop grande : c''est trop, ce n''est pas bon. « Un peu » veut dire une petite quantité. L''erreur fréquente : penser que « trop » veut dire « un peu ».', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('30bda6d7-c0d1-534e-a470-0a85fbf0bbb2', 'f78bf935-ec01-5bec-81eb-927f118fdd22', 'Dans quel mot est-ce que j''entends le son [p] au début ?', '[{"id":"a","text":"banane"},{"id":"b","text":"beurre"},{"id":"c","text":"pomme"},{"id":"d","text":"lait"}]'::jsonb, 'c', 'Dans « pomme », j''entends le son [p] au début. « Banane » et « beurre » commencent par le son [b]. L''erreur fréquente : confondre le son [p] et le son [b].', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('6b117d8d-e59d-532e-b681-76bc066a5b29', 'a3d1662c-7d42-595a-b886-3d26403e2a84', 'french-3eme', 'Quiz de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('8498444c-7a5e-5284-be13-3d453fc076dd', '6b117d8d-e59d-532e-b681-76bc066a5b29', 'Lequel de ces mots est un animal ?', '[{"id":"a","text":"ferme"},{"id":"b","text":"chat"},{"id":"c","text":"pré"},{"id":"d","text":"lac"}]'::jsonb, 'b', 'Le chat est un animal. La ferme, le pré et le lac sont des lieux où vivent les animaux. L''erreur fréquente : confondre un animal et le lieu où il vit.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('31985503-d3a2-5039-b409-936294be08c2', '6b117d8d-e59d-532e-b681-76bc066a5b29', 'Le petit de la poule s''appelle le …', '[{"id":"a","text":"chaton"},{"id":"b","text":"ânon"},{"id":"c","text":"poulain"},{"id":"d","text":"poussin"}]'::jsonb, 'd', 'Le petit de la poule est le poussin. Le chaton est le petit du chat, l''ânon celui de l''âne. L''erreur fréquente : mélanger les petits des animaux.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('10ee235d-8024-5e4d-bdda-2f5befdcfcbe', '6b117d8d-e59d-532e-b681-76bc066a5b29', 'Que fait l''oiseau ?', '[{"id":"a","text":"il vole"},{"id":"b","text":"il nage"},{"id":"c","text":"il marche dans le lac"},{"id":"d","text":"il dort dans l''eau"}]'::jsonb, 'a', 'L''oiseau vole dans le ciel. C''est le poisson qui nage dans l''eau. L''erreur fréquente : donner à l''oiseau l''action du poisson.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f1f985df-2a39-5225-af80-09c6b74623cb', '6b117d8d-e59d-532e-b681-76bc066a5b29', 'Combien y a-t-il de saisons dans l''année ?', '[{"id":"a","text":"deux"},{"id":"b","text":"sept"},{"id":"c","text":"quatre"},{"id":"d","text":"dix"}]'::jsonb, 'c', 'L''année a quatre saisons : le printemps, l''été, l''automne et l''hiver. L''erreur fréquente : confondre les sept jours de la semaine avec les quatre saisons.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b3cf6ff6-e317-59df-9b7c-e61ed76fa0da', '6b117d8d-e59d-532e-b681-76bc066a5b29', 'Quel son entends-tu au début du mot « ferme » ?', '[{"id":"a","text":"le son [n]"},{"id":"b","text":"le son [f]"},{"id":"c","text":"le son [ɔ̃]"},{"id":"d","text":"le son [ʃ]"}]'::jsonb, 'b', '« Ferme » commence par la lettre f, qui fait le son [f]. L''erreur fréquente : confondre le son [f] de « ferme » avec le son [ʃ] de « chat ».', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('ae14a6e5-b665-5aad-acdd-ae77956f307a', 'a3d1662c-7d42-595a-b886-3d26403e2a84', 'french-3eme', '⭐ Exercice : Je nomme mes amis les animaux', 1, 50, 10, 'practice', 'admin', 1)
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
  ('0b78d09e-6557-5d0e-b7cc-afa07e172267', 'ae14a6e5-b665-5aad-acdd-ae77956f307a', 'Quel mot désigne un animal de la ferme ?', '[{"id":"a","text":"campagne"},{"id":"b","text":"lac"},{"id":"c","text":"vache"},{"id":"d","text":"pré"}]'::jsonb, 'c', 'La vache est un animal de la ferme. La campagne, le lac et le pré sont des lieux. L''erreur fréquente : prendre un lieu pour un animal.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('548fea8e-8b1f-540a-9c94-2e8917ccf8f2', 'ae14a6e5-b665-5aad-acdd-ae77956f307a', 'Le petit du chat s''appelle le …', '[{"id":"a","text":"chaton"},{"id":"b","text":"poussin"},{"id":"c","text":"ânon"},{"id":"d","text":"poulain"}]'::jsonb, 'a', 'Le petit du chat est le chaton. Le poussin est le petit de la poule. L''erreur fréquente : mélanger les noms des petits.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('25ddf88e-2437-5489-8e8e-a6c10f0024d4', 'ae14a6e5-b665-5aad-acdd-ae77956f307a', 'Complète : le poisson … dans le lac.', '[{"id":"a","text":"vole"},{"id":"b","text":"court"},{"id":"c","text":"saute"},{"id":"d","text":"nage"}]'::jsonb, 'd', 'Le poisson nage dans le lac. C''est l''oiseau qui vole. L''erreur fréquente : donner au poisson l''action de l''oiseau.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d2aea363-8bcc-58d7-9b66-bfbb9f73f106', 'ae14a6e5-b665-5aad-acdd-ae77956f307a', 'Quel mot désigne un lieu où vivent les animaux ?', '[{"id":"a","text":"chèvre"},{"id":"b","text":"ferme"},{"id":"c","text":"chien"},{"id":"d","text":"mouton"}]'::jsonb, 'b', 'La ferme est un lieu où vivent les animaux. La chèvre, le chien et le mouton sont des animaux. L''erreur fréquente : confondre un animal et son lieu.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('26fd41c6-bf9c-557d-a05b-d947d43e2052', 'ae14a6e5-b665-5aad-acdd-ae77956f307a', 'Quel son entends-tu au début du mot « nid » ?', '[{"id":"a","text":"le son [n]"},{"id":"b","text":"le son [f]"},{"id":"c","text":"le son [ʒ]"},{"id":"d","text":"le son [ɔ̃]"}]'::jsonb, 'a', '« Nid » commence par la lettre n, qui fait le son [n]. L''erreur fréquente : confondre le son [n] avec le son [f] de « ferme ».', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1e6356e9-3e0e-5fa4-b00b-8b48f7c3a8d4', 'ae14a6e5-b665-5aad-acdd-ae77956f307a', 'Je compte : un, deux, trois, … . Quel nombre vient après trois ?', '[{"id":"a","text":"deux"},{"id":"b","text":"six"},{"id":"c","text":"dix"},{"id":"d","text":"quatre"}]'::jsonb, 'd', 'Après trois vient quatre : un, deux, trois, quatre. L''erreur fréquente : sauter un nombre en comptant.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('871b2c45-5432-55e0-a1dc-79a68638110e', 'b8d76031-4a47-58c8-a4f6-48e52bdd3fb8', 'french-3eme', 'Quiz de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('e2d8bfc2-77b1-5c56-8c7d-8552451dcc70', '871b2c45-5432-55e0-a1dc-79a68638110e', 'Sur quoi est-ce que je range mes livres ?', '[{"id":"a","text":"les ciseaux"},{"id":"b","text":"l''étagère"},{"id":"c","text":"la colle"},{"id":"d","text":"la revue"}]'::jsonb, 'b', 'Je range mes livres sur l''étagère. L''erreur fréquente : choisir les ciseaux, qui servent à découper pour faire un livre, pas à ranger.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2e825dfb-548b-50e6-81d6-28d09797c579', '871b2c45-5432-55e0-a1dc-79a68638110e', 'Complète : « Le livre est posé … la table. »', '[{"id":"a","text":"sur"},{"id":"b","text":"sous"},{"id":"c","text":"que"},{"id":"d","text":"où"}]'::jsonb, 'a', 'Quand le livre est posé au-dessus, sur le dessus de la table, je dis « sur la table ». L''erreur fréquente : choisir « sous », qui veut dire en dessous.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('76f1bd57-99c5-596e-b74b-b6f4d1160c28', '871b2c45-5432-55e0-a1dc-79a68638110e', 'Quel petit mot sert à demander l''endroit ?', '[{"id":"a","text":"que ?"},{"id":"b","text":"et ?"},{"id":"c","text":"où ?"},{"id":"d","text":"sur ?"}]'::jsonb, 'c', 'On demande « où ? » pour l''endroit : « Où est mon album ? ». L''erreur fréquente : choisir « que ? », qui sert à demander la chose ou l''action (« Que lis-tu ? »).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e273fa03-ea03-580c-af48-f748d399cef2', '871b2c45-5432-55e0-a1dc-79a68638110e', 'Dans quel mot entends-tu le son « v » ?', '[{"id":"a","text":"fille"},{"id":"b","text":"livre"},{"id":"c","text":"colle"},{"id":"d","text":"frère"}]'::jsonb, 'b', '« livre » contient le son v. L''erreur fréquente : confondre le son v (livre) avec le son f (fille, frère), qui se ressemblent.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0a972080-ddd7-5f99-83b0-cda02b6131a3', '871b2c45-5432-55e0-a1dc-79a68638110e', 'Dans le mot « merci », quel son fait la lettre « c » ?', '[{"id":"a","text":"le son s"},{"id":"b","text":"le son k"},{"id":"c","text":"le son f"},{"id":"d","text":"le son v"}]'::jsonb, 'a', 'Devant e et i, la lettre c fait le son s : merci, ici. L''erreur fréquente : lire « c = k » comme dans carton, mais devant i le c fait le son s.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('17a4ea62-2dcc-5270-a450-c96d2918e948', 'b8d76031-4a47-58c8-a4f6-48e52bdd3fb8', 'french-3eme', '⭐ Exercice : les mots du coin-lecture', 1, 50, 10, 'practice', 'admin', 1)
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
  ('bc01ce9a-a808-57c3-a5b8-31cb8d71ea09', '17a4ea62-2dcc-5270-a450-c96d2918e948', 'Comment appelle-t-on un livre avec de belles images ?', '[{"id":"a","text":"une revue"},{"id":"b","text":"un album"},{"id":"c","text":"une boîte"},{"id":"d","text":"une étagère"}]'::jsonb, 'b', 'Un album est un livre avec de belles images. L''erreur fréquente : choisir la boîte, qui sert à ranger les livres, pas à les lire.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b26ab546-7052-5b70-a703-9de7cc1cf469', '17a4ea62-2dcc-5270-a450-c96d2918e948', 'Avec quoi est-ce que je colle les images de mon livre ?', '[{"id":"a","text":"la colle"},{"id":"b","text":"l''étagère"},{"id":"c","text":"le conte"},{"id":"d","text":"la revue"}]'::jsonb, 'a', 'Je colle les images avec la colle. L''erreur fréquente : choisir l''étagère, qui sert à ranger les livres, pas à coller.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d23359b1-a7aa-5172-a664-2fe766625e62', '17a4ea62-2dcc-5270-a450-c96d2918e948', 'Complète : « Le livre est … la boîte : je ne le vois pas, il est dedans. »', '[{"id":"a","text":"sur"},{"id":"b","text":"à côté de"},{"id":"c","text":"dans"},{"id":"d","text":"où"}]'::jsonb, 'c', 'Quand le livre est dedans, je dis « dans la boîte ». L''erreur fréquente : choisir « sur », qui veut dire posé au-dessus.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8147a071-8f86-5672-b4ac-6f50a1d25db7', '17a4ea62-2dcc-5270-a450-c96d2918e948', 'Complète : « Le livre est … la table : il est tombé en dessous. »', '[{"id":"a","text":"sous"},{"id":"b","text":"sur"},{"id":"c","text":"dans"},{"id":"d","text":"que"}]'::jsonb, 'a', 'Quand le livre est en dessous, je dis « sous la table ». L''erreur fréquente : confondre « sous » (en dessous) et « sur » (au-dessus).', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('aa9358c8-d4e6-56c5-8726-678767577103', '17a4ea62-2dcc-5270-a450-c96d2918e948', 'La boîte est pleine de livres. Quel mot dit le contraire de « pleine » ?', '[{"id":"a","text":"grande"},{"id":"b","text":"vide"},{"id":"c","text":"belle"},{"id":"d","text":"jolie"}]'::jsonb, 'b', 'Le contraire de « pleine » (beaucoup dedans) est « vide » (rien dedans). L''erreur fréquente : choisir « grande », qui parle de la taille, pas de ce qu''il y a dedans.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('d0c0a898-6bfa-5fe2-8340-4b6856f4cb46', '17a4ea62-2dcc-5270-a450-c96d2918e948', 'Je suis poli et je demande de l''aide. Que dois-je ajouter ?', '[{"id":"a","text":"s''il te plaît"},{"id":"b","text":"au revoir"},{"id":"c","text":"très bien"},{"id":"d","text":"beaucoup"}]'::jsonb, 'a', 'Pour être poli quand je demande de l''aide, j''ajoute « s''il te plaît » : « Donne-moi le livre, s''il te plaît. ». L''erreur fréquente : dire « au revoir », qui sert à se quitter, pas à demander.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('177656ab-af5f-5416-92e0-4726f44d2bf2', 'b8d76031-4a47-58c8-a4f6-48e52bdd3fb8', 'french-3eme', '⚔️ Le gardien du chapitre ⭐⭐⭐ : les sons f, v et la lettre c', 3, 120, 30, 'boss', 'admin', 2)
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
  ('eca30035-228f-56ff-8ab6-f9da371b5d29', '177656ab-af5f-5416-92e0-4726f44d2bf2', 'Dans quel mot entends-tu le son « f » ?', '[{"id":"a","text":"livre"},{"id":"b","text":"revue"},{"id":"c","text":"frère"},{"id":"d","text":"élève"}]'::jsonb, 'c', '« frère » commence par le son f. L''erreur fréquente : confondre le son f (frère) avec le son v (livre, revue, élève).', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1c696444-6420-540d-a1e2-ba5a8381d784', '177656ab-af5f-5416-92e0-4726f44d2bf2', 'Je lis la syllabe : v + i = … ?', '[{"id":"a","text":"iv"},{"id":"b","text":"vi"},{"id":"c","text":"fi"},{"id":"d","text":"vo"}]'::jsonb, 'b', 'Je lis d''abord v, puis i : v + i = vi (comme dans « vide »). L''erreur fréquente : inverser et lire « iv » au lieu de « vi ».', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2481a5f6-f6bb-546d-a389-28783c16bb17', '177656ab-af5f-5416-92e0-4726f44d2bf2', 'Je suis très content de mon livre. Quelle phrase montre ma joie ?', '[{"id":"a","text":"Où est le livre ?"},{"id":"b","text":"Je range le livre."},{"id":"c","text":"Quel beau livre !"},{"id":"d","text":"Le livre est dans la boîte."}]'::jsonb, 'c', '« Quel beau livre ! » est une phrase exclamative : elle montre la joie et finit par « ! ». L''erreur fréquente : choisir une question (« Où est le livre ? »), qui demande quelque chose au lieu de montrer la joie.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e9423c94-dd3a-5eda-a988-0f3f8accdfac', '177656ab-af5f-5416-92e0-4726f44d2bf2', 'Dans « carton », quel son fait la lettre « c » ?', '[{"id":"a","text":"le son s"},{"id":"b","text":"le son k"},{"id":"c","text":"le son v"},{"id":"d","text":"le son f"}]'::jsonb, 'b', 'Devant a, o, u, la lettre c fait le son k : carton, colle, conte. L''erreur fréquente : lire « c = s » comme dans merci, mais devant a le c fait le son k.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('1be9dd6b-ab20-552f-9414-a4291bf2bae8', '177656ab-af5f-5416-92e0-4726f44d2bf2', 'Dans quel mot la lettre « c » fait-elle le son « s » ?', '[{"id":"a","text":"carton"},{"id":"b","text":"colle"},{"id":"c","text":"ici"},{"id":"d","text":"conte"}]'::jsonb, 'c', 'Dans « ici », le c est devant i, donc il fait le son s. L''erreur fréquente : choisir carton ou colle, où le c est devant a ou o et fait le son k.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('484eccc7-3966-5f51-b427-4c4fab9663f2', '177656ab-af5f-5416-92e0-4726f44d2bf2', 'Léa demande : « … lis-tu ? » Sami répond : « Une belle histoire. » Quel mot manque ?', '[{"id":"a","text":"Où"},{"id":"b","text":"Que"},{"id":"c","text":"Sur"},{"id":"d","text":"Dans"}]'::jsonb, 'b', 'La réponse est une chose (une histoire), donc la question est « Que lis-tu ? ». L''erreur fréquente : choisir « Où », qui demande un lieu, pas la chose qu''on lit.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('e13318a3-fdf0-51ee-9d3b-0fc05b3db172', 'b8d76031-4a47-58c8-a4f6-48e52bdd3fb8', 'french-3eme', '⭐⭐ Révision : mon ami le livre (mots, lieux et sons)', 2, 75, 15, 'practice', 'admin', 3)
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
  ('ef2fb6b8-ea29-55b1-802a-4ede94c86df0', 'e13318a3-fdf0-51ee-9d3b-0fc05b3db172', 'Quel mot désigne une petite histoire qu''on lit dans un livre ?', '[{"id":"a","text":"un conte"},{"id":"b","text":"une étagère"},{"id":"c","text":"des ciseaux"},{"id":"d","text":"un carton"}]'::jsonb, 'a', 'Un conte est une petite histoire qu''on lit. L''erreur fréquente : choisir l''étagère, qui sert à ranger les livres, pas à raconter.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ffb3e825-0bf8-5d50-941c-bd24fc57c634', 'e13318a3-fdf0-51ee-9d3b-0fc05b3db172', 'Je joins les lettres : f + a = … ?', '[{"id":"a","text":"af"},{"id":"b","text":"va"},{"id":"c","text":"fa"},{"id":"d","text":"fo"}]'::jsonb, 'c', 'Je lis d''abord f, puis a : f + a = fa. L''erreur fréquente : inverser et lire « af » au lieu de « fa ».', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('404dafa3-b8ff-5852-8c09-c2a94efecc87', 'e13318a3-fdf0-51ee-9d3b-0fc05b3db172', 'Complète : « La colle est … la boîte, tout près d''elle. »', '[{"id":"a","text":"sous"},{"id":"b","text":"à côté de"},{"id":"c","text":"dans"},{"id":"d","text":"que"}]'::jsonb, 'b', 'Quand la colle est tout près de la boîte, je dis « à côté de la boîte ». L''erreur fréquente : choisir « dans », qui veut dire à l''intérieur.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3b212333-34db-5674-a5e8-2c941971b8bd', 'e13318a3-fdf0-51ee-9d3b-0fc05b3db172', 'Pour demander la chose qu''on fait, je pose la question avec :', '[{"id":"a","text":"où ?"},{"id":"b","text":"sur ?"},{"id":"c","text":"que ?"},{"id":"d","text":"sous ?"}]'::jsonb, 'c', 'Je demande « que ? » pour la chose ou l''action : « Que fais-tu ? — Je lis. ». L''erreur fréquente : utiliser « où ? », qui sert à demander l''endroit.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('4a2c86f4-668e-5f5a-8467-7aaf8cb3f623', 'e13318a3-fdf0-51ee-9d3b-0fc05b3db172', 'Dans quel mot entends-tu le son « v » ?', '[{"id":"a","text":"fille"},{"id":"b","text":"revue"},{"id":"c","text":"colle"},{"id":"d","text":"conte"}]'::jsonb, 'b', '« revue » contient le son v. L''erreur fréquente : confondre le son v (revue) avec le son f (fille).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f7df9cc2-3a67-5933-bbcc-8632e4bee30e', 'e13318a3-fdf0-51ee-9d3b-0fc05b3db172', 'Pour dire ce que je désire, je dis :', '[{"id":"a","text":"je veux lire ce conte"},{"id":"b","text":"où lire ce conte"},{"id":"c","text":"que lire ce conte"},{"id":"d","text":"sous lire ce conte"}]'::jsonb, 'a', 'Pour dire mon désir, je dis « je veux » : « je veux lire ce conte ». L''erreur fréquente : commencer par « où » ou « que », qui servent à poser une question.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8617fa16-5d9d-5696-a52c-be466692afdd', 'b8d76031-4a47-58c8-a4f6-48e52bdd3fb8', 'french-3eme', '👑 Défi de l''élite ⭐⭐⭐⭐ : gardien du coin-lecture', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('d843e075-4e4c-55e4-b31f-70f06375cebf', '8617fa16-5d9d-5696-a52c-be466692afdd', 'Sami cherche son album. Il demande : « … est mon album ? » On répond : « Sur l''étagère. » Quel mot manque ?', '[{"id":"a","text":"Que"},{"id":"b","text":"Où"},{"id":"c","text":"Dans"},{"id":"d","text":"Sur"}]'::jsonb, 'b', 'La réponse est un endroit (sur l''étagère), donc la question est « Où est mon album ? ». L''erreur fréquente : choisir « Que », qui demande la chose, pas l''endroit.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a2d7801e-e1ca-5609-81af-31a43aac89f8', '8617fa16-5d9d-5696-a52c-be466692afdd', 'Dans trois de ces mots, la lettre « c » fait le son « k ». Dans lequel fait-elle le son « s » ?', '[{"id":"a","text":"carton"},{"id":"b","text":"cible"},{"id":"c","text":"colle"},{"id":"d","text":"conte"}]'::jsonb, 'b', 'Dans « cible », le c est devant i, donc il fait le son s. L''erreur fréquente : croire que le c fait toujours le son k ; devant e et i, il fait le son s.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('3962471d-13be-58c5-9e38-b26a8266f83d', '8617fa16-5d9d-5696-a52c-be466692afdd', 'Le livre n''est pas sur la table, ni dessous. Il est tout près, juste à droite de la colle. Où est-il ?', '[{"id":"a","text":"sous la table"},{"id":"b","text":"dans la boîte"},{"id":"c","text":"à côté de la colle"},{"id":"d","text":"sur la table"}]'::jsonb, 'c', 'Tout près, juste à côté de la colle, je dis « à côté de la colle ». L''erreur fréquente : choisir « sur la table », alors que la phrase dit qu''il n''est pas sur la table.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('6570694f-9020-5c20-8491-590d0e5ed585', '8617fa16-5d9d-5696-a52c-be466692afdd', 'Trois mots contiennent le son « v ». Lequel contient plutôt le son « f » ?', '[{"id":"a","text":"livre"},{"id":"b","text":"fille"},{"id":"c","text":"revue"},{"id":"d","text":"élève"}]'::jsonb, 'b', '« fille » contient le son f ; livre, revue et élève contiennent le son v. L''erreur fréquente : confondre f et v, deux sons proches.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ee9bc776-ed07-5f67-9fec-1a4914563d76', '8617fa16-5d9d-5696-a52c-be466692afdd', 'Nora veut ranger les livres et elle demande gentiment de l''aide. Quelle phrase est la bonne ?', '[{"id":"a","text":"Range les livres où ?"},{"id":"b","text":"Tu peux m''aider, s''il te plaît ?"},{"id":"c","text":"Que les livres."},{"id":"d","text":"Sous les livres !"}]'::jsonb, 'b', 'Pour demander de l''aide poliment, on dit « Tu peux m''aider, s''il te plaît ? ». L''erreur fréquente : oublier « s''il te plaît » ou mettre un mot de question (où, que) qui ne demande pas d''aide.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('f2e40359-e6a6-5978-9651-9e4d3bf6c7f4', '8617fa16-5d9d-5696-a52c-be466692afdd', 'La boîte n''a plus aucun livre dedans. Comment est-elle ?', '[{"id":"a","text":"pleine"},{"id":"b","text":"vide"},{"id":"c","text":"belle"},{"id":"d","text":"grande"}]'::jsonb, 'b', 'S''il n''y a plus rien dedans, la boîte est vide. L''erreur fréquente : choisir « pleine », qui veut dire le contraire (beaucoup dedans).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('1ed7ba95-38d5-532b-b744-e70812355756', '51822d93-c9ce-52d8-b95c-a34ca3e52d6c', 'french-3eme', 'Quiz de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('96c37135-feb5-5324-8e15-0defc400fbde', '1ed7ba95-38d5-532b-b744-e70812355756', 'Quel mot est un jouet ?', '[{"id":"a","text":"le lait"},{"id":"b","text":"le matin"},{"id":"c","text":"la poupée"},{"id":"d","text":"le pain"}]'::jsonb, 'c', 'Une poupée est un jouet ; le lait et le pain sont des aliments. L''erreur fréquente : confondre un jouet avec un aliment.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5b0249fa-6521-53d3-b8b7-4ee357374fa4', '1ed7ba95-38d5-532b-b744-e70812355756', 'Je prends le ballon ___ jouer.', '[{"id":"a","text":"ne"},{"id":"b","text":"avec"},{"id":"c","text":"pour"},{"id":"d","text":"pas"}]'::jsonb, 'c', 'Avec « pour », je dis pourquoi je fais une action : je prends le ballon pour jouer. L''erreur fréquente : oublier « pour » devant l''action.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('833f947d-6f04-5e89-9d54-4d9a5180cd72', '1ed7ba95-38d5-532b-b744-e70812355756', 'Complète : Je joue ___ ballon.', '[{"id":"a","text":"avec"},{"id":"b","text":"au"},{"id":"c","text":"la"},{"id":"d","text":"et"}]'::jsonb, 'b', 'On dit « je joue au ballon » (un mot avec « le »). L''erreur fréquente : dire « je joue à le ballon ».', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('343c98b4-b4a4-511d-ad74-ce9c20da4075', '1ed7ba95-38d5-532b-b744-e70812355756', 'Léa aime tous les jeux, mais son jeu numéro un, c''est le ballon. Que dit-elle ?', '[{"id":"a","text":"Je n''aime pas le ballon."},{"id":"b","text":"Je dors."},{"id":"c","text":"C''est peu."},{"id":"d","text":"Je préfère le ballon."}]'::jsonb, 'd', 'Pour dire le jeu qu''on aime le plus, on dit « je préfère ». L''erreur fréquente : dire « je préfère » pour un jeu qu''on n''aime pas.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('a9864def-7fd9-5c86-bd57-3e3e6512cc55', '1ed7ba95-38d5-532b-b744-e70812355756', 'Quel mot a le son [è] comme dans « lait » ?', '[{"id":"a","text":"neige"},{"id":"b","text":"ballon"},{"id":"c","text":"robot"},{"id":"d","text":"poupée"}]'::jsonb, 'a', 'Dans « neige », les lettres « ei » font le son [è], comme « ai » dans « lait ». L''erreur fréquente : oublier que « ei » fait le même son que « ai ».', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('8c2da2f7-6784-56e0-a234-2572baa75688', '51822d93-c9ce-52d8-b95c-a34ca3e52d6c', 'french-3eme', '⭐ Exercice : Mes jeux préférés', 1, 50, 10, 'practice', 'admin', 1)
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
  ('4571cf31-645a-560a-98f8-32e765c549e8', '8c2da2f7-6784-56e0-a234-2572baa75688', 'Quel mot est un jeu ?', '[{"id":"a","text":"la marelle"},{"id":"b","text":"le lait"},{"id":"c","text":"le nez"},{"id":"d","text":"la main"}]'::jsonb, 'a', 'La marelle est un jeu. L''erreur fréquente : choisir un aliment ou une partie du corps à la place d''un jeu.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ccd344c0-da82-5485-84a3-062e1b3a045b', '8c2da2f7-6784-56e0-a234-2572baa75688', 'Complète : Je joue ___ ma poupée.', '[{"id":"a","text":"au"},{"id":"b","text":"et"},{"id":"c","text":"avec"},{"id":"d","text":"pour"}]'::jsonb, 'c', 'On joue « avec » un jouet : je joue avec ma poupée. L''erreur fréquente : dire « je joue au poupée ».', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('73c35dda-5e03-55a1-bde2-f977a9a9ac60', '8c2da2f7-6784-56e0-a234-2572baa75688', 'Comment dit-on « non » dans cette phrase : Je ___ veux ___ dormir ?', '[{"id":"a","text":"à … au"},{"id":"b","text":"ne … pas"},{"id":"c","text":"pour … et"},{"id":"d","text":"au … avec"}]'::jsonb, 'b', 'Pour dire non, on met « ne » avant et « pas » après : je ne veux pas dormir. L''erreur fréquente : oublier « pas ».', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('01fa02c2-b3db-5717-aea4-b507a0ed3bb8', '8c2da2f7-6784-56e0-a234-2572baa75688', 'Quel mot a le son [ain] comme dans « pain » ?', '[{"id":"a","text":"balle"},{"id":"b","text":"robot"},{"id":"c","text":"corde"},{"id":"d","text":"lapin"}]'::jsonb, 'd', 'Dans « lapin », les lettres « in » font le son du nez [ain], comme dans « pain ». L''erreur fréquente : ne pas entendre le son du nez.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('052908dc-28b7-5d75-a865-6e0c26b85584', '8c2da2f7-6784-56e0-a234-2572baa75688', 'Quel nombre vient juste après dix-neuf ?', '[{"id":"a","text":"douze"},{"id":"b","text":"vingt"},{"id":"c","text":"dix"},{"id":"d","text":"trente"}]'::jsonb, 'b', 'Après dix-neuf vient vingt (20). L''erreur fréquente : sauter de dix-neuf à trente.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('5a4320f7-91f4-5594-903c-27f7e79cddb7', '8c2da2f7-6784-56e0-a234-2572baa75688', 'Sur le toboggan, qu''est-ce qui est sans danger ?', '[{"id":"a","text":"Je pousse les amis."},{"id":"b","text":"Je cours sur le toboggan."},{"id":"c","text":"Je glisse un par un."},{"id":"d","text":"Je saute du haut."}]'::jsonb, 'c', 'Sur le toboggan, je glisse un par un et je ne pousse pas : c''est sans danger. L''erreur fréquente : pousser ou sauter, ce qui fait tomber.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b779e8a4-b58a-5545-aa7d-d0b5ca3e6ce6', 'a0ca537c-88ef-5162-ba74-c1faf472492c', 'french-3eme', 'Quiz de compréhension ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('7816d344-9145-53ee-8b50-8e24634c8331', 'b779e8a4-b58a-5545-aa7d-d0b5ca3e6ce6', 'Sur quoi monte-t-on pour présenter le spectacle ?', '[{"id":"a","text":"la guirlande"},{"id":"b","text":"le gâteau"},{"id":"c","text":"la scène"},{"id":"d","text":"la chanson"}]'::jsonb, 'c', 'On monte sur la scène pour le spectacle. L''erreur fréquente : choisir la guirlande, qui sert à décorer la scène, pas à monter dessus.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2788d7ef-e795-5bdd-ba1b-b4225ed9bcdc', 'b779e8a4-b58a-5545-aa7d-d0b5ca3e6ce6', 'Quel vêtement vient du Japon ?', '[{"id":"a","text":"la chéchia"},{"id":"b","text":"le kimono"},{"id":"c","text":"la jebba"},{"id":"d","text":"le pantalon"}]'::jsonb, 'b', 'Le kimono est un vêtement du Japon. L''erreur fréquente : choisir la chéchia ou la jebba, qui sont des vêtements de chez nous.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('36f84981-a3e1-5149-8248-16f1782f845a', 'b779e8a4-b58a-5545-aa7d-d0b5ca3e6ce6', 'Pour dire que tu es capable de danser, tu dis :', '[{"id":"a","text":"je veux danser"},{"id":"b","text":"je mets danser"},{"id":"c","text":"je sais danser"},{"id":"d","text":"je décore danser"}]'::jsonb, 'c', 'Pour dire ce que je suis capable de faire, je dis « je sais » : je sais danser. L''erreur fréquente : dire « je veux danser », qui dit ce que je désire, pas ce que je sais faire.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('76dbe8a5-d2ad-594e-b688-e6df0e58b1d7', 'b779e8a4-b58a-5545-aa7d-d0b5ca3e6ce6', 'Dans quel mot entends-tu le son « ch » ?', '[{"id":"a","text":"kimono"},{"id":"b","text":"roi"},{"id":"c","text":"gâteau"},{"id":"d","text":"chéchia"}]'::jsonb, 'd', '« chéchia » commence par le son ch. L''erreur fréquente : choisir kimono, qui commence par le son k, pas par le son ch.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('23a4c81b-0ed0-554e-81f5-826561543ee3', 'b779e8a4-b58a-5545-aa7d-d0b5ca3e6ce6', 'Quel nombre vient juste après vingt-neuf (29) ?', '[{"id":"a","text":"vingt-huit"},{"id":"b","text":"trente"},{"id":"c","text":"vingt"},{"id":"d","text":"vingt et un"}]'::jsonb, 'b', 'Après vingt-neuf (29) vient trente (30). L''erreur fréquente : revenir en arrière vers vingt-huit (28) au lieu d''avancer.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('b55db625-747d-588b-a74c-86db5438edfa', 'a0ca537c-88ef-5162-ba74-c1faf472492c', 'french-3eme', '⭐ Exercice : les mots de la fête', 1, 50, 10, 'practice', 'admin', 1)
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
  ('7364f343-f013-5881-8676-3cd6c9a3a94b', 'b55db625-747d-588b-a74c-86db5438edfa', 'Avec quoi est-ce qu''on décore la scène ?', '[{"id":"a","text":"des guirlandes"},{"id":"b","text":"un gâteau"},{"id":"c","text":"un poème"},{"id":"d","text":"une équipe"}]'::jsonb, 'a', 'On décore la scène avec des guirlandes. L''erreur fréquente : choisir le gâteau, qu''on mange à la fête mais qui ne décore pas la scène.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bbe92ec0-254a-54b5-8106-33f7ae20a2c2', 'b55db625-747d-588b-a74c-86db5438edfa', 'Comment appelle-t-on la personne qui chante ?', '[{"id":"a","text":"la danseuse"},{"id":"b","text":"la chanteuse"},{"id":"c","text":"l''équipe"},{"id":"d","text":"la scène"}]'::jsonb, 'b', 'La chanteuse est la personne qui chante. L''erreur fréquente : choisir la danseuse, qui danse au lieu de chanter.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('78e38dcf-1b45-5f69-bbdb-3e6859c6b1e1', 'b55db625-747d-588b-a74c-86db5438edfa', 'Quel vêtement est de chez nous, en Tunisie ?', '[{"id":"a","text":"le kimono"},{"id":"b","text":"la chéchia"},{"id":"c","text":"le pantalon"},{"id":"d","text":"les chaussures"}]'::jsonb, 'b', 'La chéchia est un vêtement de chez nous. L''erreur fréquente : choisir le kimono, qui est un vêtement du Japon (le pantalon et les chaussures sont pour tout le monde).', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('540a81ff-40c8-563d-a6b5-cc50cd19f28e', 'b55db625-747d-588b-a74c-86db5438edfa', 'Qu''est-ce qu''on mange à la fête de l''école ?', '[{"id":"a","text":"une guirlande"},{"id":"b","text":"une danse"},{"id":"c","text":"un gâteau"},{"id":"d","text":"une chanson"}]'::jsonb, 'c', 'On mange un bon gâteau à la fête. L''erreur fréquente : choisir la danse, qui est un numéro du spectacle, pas quelque chose qu''on mange.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('35747898-71f6-5555-bdcc-1fbe9a75379f', 'b55db625-747d-588b-a74c-86db5438edfa', 'Complète : « Je … ma chéchia pour la fête. »', '[{"id":"a","text":"mets"},{"id":"b","text":"mange"},{"id":"c","text":"lis"},{"id":"d","text":"range"}]'::jsonb, 'a', 'Pour un vêtement, je dis « je mets » : je mets ma chéchia. L''erreur fréquente : choisir « je mange », qui sert pour la nourriture, pas pour un vêtement.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('0c797549-54d8-5292-b4a2-f734b4fe2a6b', 'b55db625-747d-588b-a74c-86db5438edfa', 'Sur quoi danse et chante l''équipe pendant le spectacle ?', '[{"id":"a","text":"la scène"},{"id":"b","text":"le gâteau"},{"id":"c","text":"la guirlande"},{"id":"d","text":"le pantalon"}]'::jsonb, 'a', 'L''équipe monte sur la scène pour le spectacle. L''erreur fréquente : choisir le gâteau, qu''on mange, pas un lieu où l''on danse.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('d40e41bd-343c-5760-becc-cc400f68f4af', 'a0ca537c-88ef-5162-ba74-c1faf472492c', 'french-3eme', '⚔️ Le gardien du chapitre ⭐⭐⭐ : les sons de la fête', 3, 120, 30, 'boss', 'admin', 2)
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
  ('eda30fdc-f9f4-5ffa-bf4e-aa0f4874f2b6', 'd40e41bd-343c-5760-becc-cc400f68f4af', 'Je joins les sons : b + eau = … ?', '[{"id":"a","text":"bo"},{"id":"b","text":"beau"},{"id":"c","text":"eaub"},{"id":"d","text":"boi"}]'::jsonb, 'b', 'Je lis d''abord b, puis eau : b + eau = beau. L''erreur fréquente : inverser l''ordre et lire « eaub ».', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b0e6794e-7fec-589e-966e-acc6309a9825', 'd40e41bd-343c-5760-becc-cc400f68f4af', 'Dans quel mot entends-tu le son « k » ?', '[{"id":"a","text":"chéchia"},{"id":"b","text":"roi"},{"id":"c","text":"kimono"},{"id":"d","text":"jeu"}]'::jsonb, 'c', '« kimono » commence par le son k, comme « karaté ». L''erreur fréquente : choisir chéchia, qui commence par le son ch, pas par le son k.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('65808528-8e7a-5cc8-953a-00c99912845b', 'd40e41bd-343c-5760-becc-cc400f68f4af', 'Dans quel mot entends-tu le son « oi » ?', '[{"id":"a","text":"kimono"},{"id":"b","text":"roi"},{"id":"c","text":"gâteau"},{"id":"d","text":"chat"}]'::jsonb, 'b', '« roi » contient le son oi, comme dans « étoile ». L''erreur fréquente : choisir gâteau, qui contient le son eau, pas le son oi.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('63f5afc3-da0b-5133-87e3-5b1f6e4c2cd9', 'd40e41bd-343c-5760-becc-cc400f68f4af', '« gâteau » et « beau » se terminent par le même son. Lequel ?', '[{"id":"a","text":"le son o (au / eau)"},{"id":"b","text":"le son oi"},{"id":"c","text":"le son ch"},{"id":"d","text":"le son i"}]'::jsonb, 'a', '« au » et « eau » font le même son o : gât-eau, b-eau. L''erreur fréquente : croire que « eau », qui a trois lettres, fait un son différent de « au ».', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('e522eef3-42b4-5aa5-8f60-5ac839817a60', 'd40e41bd-343c-5760-becc-cc400f68f4af', 'La scène brille comme de l''or. Quel mot la décrit ?', '[{"id":"a","text":"vide"},{"id":"b","text":"dorée"},{"id":"c","text":"blanche"},{"id":"d","text":"petite"}]'::jsonb, 'b', 'Une scène qui brille comme de l''or est « dorée ». L''erreur fréquente : choisir « blanche », qui est la couleur de la robe de la danseuse, pas l''éclat de l''or.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('004e0069-0b5a-50fb-aeb6-b817c8b66a8d', 'd40e41bd-343c-5760-becc-cc400f68f4af', 'J''écoute deux sons proches. Lequel de ces mots contient le son « ch » (comme dans « chat ») ?', '[{"id":"a","text":"jeu"},{"id":"b","text":"gâteau"},{"id":"c","text":"chaussures"},{"id":"d","text":"roi"}]'::jsonb, 'c', '« chaussures » contient le son ch. L''erreur fréquente : confondre le son ch (chat) avec le son j (jeu), deux sons proches.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('24eed047-a578-5702-8fba-938eed20f29a', 'a0ca537c-88ef-5162-ba74-c1faf472492c', 'french-3eme', '⭐⭐ Révision : quelle fête (mots, sons et nombres)', 2, 75, 15, 'practice', 'admin', 3)
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
  ('74a30f22-1442-5150-8197-8a98d5a8226b', '24eed047-a578-5702-8fba-938eed20f29a', 'Quel numéro du spectacle se lit à voix haute et rime souvent ?', '[{"id":"a","text":"le gâteau"},{"id":"b","text":"le poème"},{"id":"c","text":"la guirlande"},{"id":"d","text":"la chéchia"}]'::jsonb, 'b', 'Le poème est un numéro qu''on dit à voix haute pendant le spectacle. L''erreur fréquente : choisir le gâteau, qu''on mange, ce n''est pas un numéro.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('c4b3de53-b96f-5441-baa2-fa5f214c790d', '24eed047-a578-5702-8fba-938eed20f29a', 'Pour dire ce que je désire faire, je dis :', '[{"id":"a","text":"je veux chanter"},{"id":"b","text":"je mets chanter"},{"id":"c","text":"je range chanter"},{"id":"d","text":"je décore chanter"}]'::jsonb, 'a', 'Pour dire mon désir, je dis « je veux » : je veux chanter. L''erreur fréquente : dire « je mets », qui sert pour un vêtement (je mets ma chéchia).', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('8bf81f2f-d6ea-5a65-a195-10d2c48c8fb2', '24eed047-a578-5702-8fba-938eed20f29a', 'Amine dit : « C''est ma danse … » pour dire que c''est la danse qu''il aime le plus. Quel mot manque ?', '[{"id":"a","text":"vide"},{"id":"b","text":"blanche"},{"id":"c","text":"préférée"},{"id":"d","text":"dorée"}]'::jsonb, 'c', 'Ce qu''on aime le plus est « préféré » : c''est ma danse préférée. L''erreur fréquente : choisir « blanche », qui est une couleur, pas ce qu''on aime le plus.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('b2b5144f-95c0-56f0-8dcc-0c915a4a939e', '24eed047-a578-5702-8fba-938eed20f29a', 'Dans quel mot entends-tu le son « oi » ?', '[{"id":"a","text":"beau"},{"id":"b","text":"étoile"},{"id":"c","text":"kimono"},{"id":"d","text":"chat"}]'::jsonb, 'b', '« étoile » contient le son oi. L''erreur fréquente : choisir beau, qui contient le son o (eau), pas le son oi.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('2563ca17-1ca2-5ea6-94d8-64b5ce8e9ef2', '24eed047-a578-5702-8fba-938eed20f29a', 'Je récite les mois. Quel mois vient juste après avril ?', '[{"id":"a","text":"mars"},{"id":"b","text":"juin"},{"id":"c","text":"mai"},{"id":"d","text":"janvier"}]'::jsonb, 'c', 'Après avril vient mai. L''erreur fréquente : revenir en arrière vers mars, qui vient avant avril.', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('bcc42bdc-b5e8-53bd-ada4-f087a98245af', '24eed047-a578-5702-8fba-938eed20f29a', 'Je compte : « … vingt et un, vingt-deux, vingt-trois … ». Quel nombre vient juste avant vingt et un ?', '[{"id":"a","text":"vingt"},{"id":"b","text":"vingt-deux"},{"id":"c","text":"dix"},{"id":"d","text":"trente"}]'::jsonb, 'a', 'Avant vingt et un (21) vient vingt (20). L''erreur fréquente : choisir vingt-deux (22), qui vient après vingt et un, pas avant.', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
  ('de58ba5f-d6f0-5331-a705-42b5bafa03b7', 'a0ca537c-88ef-5162-ba74-c1faf472492c', 'french-3eme', '👑 Défi de l''élite ⭐⭐⭐⭐ : maître de la fête', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('cf4942b6-8b19-5540-bf3b-f21e5c4910ce', 'de58ba5f-d6f0-5331-a705-42b5bafa03b7', 'Sara est capable de lire un poème toute seule. Quelle phrase le dit ?', '[{"id":"a","text":"je veux lire un poème"},{"id":"b","text":"je sais lire un poème"},{"id":"c","text":"je mets lire un poème"},{"id":"d","text":"je décore lire un poème"}]'::jsonb, 'b', 'Pour dire ce qu''on est capable de faire, on dit « je sais » : je sais lire un poème. L''erreur fréquente : dire « je veux », qui exprime le désir, pas la capacité.', 1, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('408dd4bd-b5ad-56b3-aa31-a2ab83bccdc8', 'de58ba5f-d6f0-5331-a705-42b5bafa03b7', 'La fête de l''école est en juin. Quel mois vient juste avant juin ?', '[{"id":"a","text":"juillet"},{"id":"b","text":"mars"},{"id":"c","text":"mai"},{"id":"d","text":"août"}]'::jsonb, 'c', 'Avant juin vient mai (… avril, mai, juin …). L''erreur fréquente : choisir juillet, qui vient après juin, pas avant.', 2, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('49248b8c-64f5-5d7a-8bd7-2116b254c330', 'de58ba5f-d6f0-5331-a705-42b5bafa03b7', 'Trois de ces mots contiennent le son « ch ». Lequel contient plutôt le son « k » ?', '[{"id":"a","text":"chéchia"},{"id":"b","text":"chaussures"},{"id":"c","text":"kimono"},{"id":"d","text":"chanson"}]'::jsonb, 'c', '« kimono » contient le son k ; chéchia, chaussures et chanson contiennent le son ch. L''erreur fréquente : confondre le son k et le son ch.', 3, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('ed19e978-cad3-5435-bdac-f3a19433089d', 'de58ba5f-d6f0-5331-a705-42b5bafa03b7', 'Il y a vingt-cinq enfants sur la scène, puis cinq de plus arrivent. Combien sont-ils en tout ?', '[{"id":"a","text":"vingt"},{"id":"b","text":"trente"},{"id":"c","text":"vingt-neuf"},{"id":"d","text":"vingt et un"}]'::jsonb, 'b', 'vingt-cinq (25) et cinq de plus font trente (30). L''erreur fréquente : oublier de compter les cinq nouveaux et rester vers vingt-cinq.', 4, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('019cce52-003c-506d-9254-0b25883a327e', 'de58ba5f-d6f0-5331-a705-42b5bafa03b7', 'Yassine veut aider son équipe à décorer. Quelle phrase est correcte et polie ?', '[{"id":"a","text":"je ne veux pas décorer"},{"id":"b","text":"je peux t''aider à décorer"},{"id":"c","text":"je mets décorer"},{"id":"d","text":"où décorer la scène"}]'::jsonb, 'b', 'Pour proposer son aide, on dit « je peux t''aider » : je peux t''aider à décorer. L''erreur fréquente : choisir « je ne veux pas », qui dit le contraire (le refus).', 5, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order,
  question_type = EXCLUDED.question_type,
  answer_key = EXCLUDED.answer_key,
  distractor_tags = EXCLUDED.distractor_tags;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order, question_type, answer_key, distractor_tags) VALUES
  ('24d977bb-6ea5-5c64-a1b9-cb36c54ef9b7', 'de58ba5f-d6f0-5331-a705-42b5bafa03b7', 'La danseuse porte une robe blanche et la scène est dorée. Que veut dire « dorée » ?', '[{"id":"a","text":"qui brille comme l''or"},{"id":"b","text":"qui est toute blanche"},{"id":"c","text":"qui est vide"},{"id":"d","text":"qui est petite"}]'::jsonb, 'a', '« dorée » veut dire qui brille comme l''or. L''erreur fréquente : confondre « dorée » (couleur de l''or) avec « blanche » (la couleur de la robe).', 6, 'mcq', NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
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
      AND e.subject_id = 'french-3eme'
      AND e.source = 'admin';
  END IF;
END $$;

