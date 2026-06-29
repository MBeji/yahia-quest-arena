-- =========================================================
-- GENERATED FILE — do not edit by hand.
-- Subject: eveil-scientifique-5eme (الإيقاظ العلمي)
-- Regenerate with: npm run content:build
-- Source of truth: content/eveil-scientifique-5eme/
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
  ('eveil-scientifique-5eme', 'الإيقاظ العلمي', 'نستكشفُ الضوءَ وانتشارَه والظلَّ والكسوف، وجسمَ الإنسان من هيكلٍ عظميٍّ وحركةٍ وتنفّسٍ ودورةٍ دمويّة، والدارةَ الكهربائيّة والموادَّ الناقلة والعازلة، والوسطَ البيئيَّ من تغذيةِ الحيوان والنبتة والإنباتِ والسلسلةِ الغذائيّةِ والماءِ الصالحِ للشّرب، وفق برنامج الإيقاظ العلمي للسنة الخامسة من التعليم الأساسي', 'Observation', 'subject-svt', 'Microscope', 2, 'ar', false, 'ecole-tn', (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '5eme-base'))
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
      AND e.subject_id = 'eveil-scientifique-5eme'
      AND e.source = 'admin'
      AND q.id NOT IN ('d4801fc3-8155-5bdd-ba58-91ace83f0064', 'b5e33dbb-d8e3-5eb9-a489-de2797652a44', '778e9095-c35d-5c86-9d9b-2d6498304115', 'a48f82b7-1ec6-584b-899f-0bc43dd2c15a', '188ba58d-416a-5e6c-bf4c-fedb91790819', 'eb94aed9-f478-510e-94c9-c069a6a1d14d', '24900867-294a-577d-89b5-478d49436ae2', 'd961d7a6-75dd-5e8e-97b7-d924c74c31ef', 'cc217cc4-93d7-5a9f-9f57-2b4211620c82', 'e5b40409-401a-5585-9ed0-95a22ddc74d9', '2fd66c92-4dca-5ee1-b2e6-8cebef4617d7', 'e548969f-e2c5-5b64-8d63-9e039dff4c11', 'cea93a79-846e-5e91-9770-60e153af0eab', 'fe743846-896f-5a2a-b794-366a8d4a3120', '9cb9b330-09d1-598c-870e-5f688113271f', '59e66f05-827b-59f8-96d2-3479b1e036e1', '7dac3b34-694e-55d1-8a4e-6a282fe14c84', '8a36db53-b3fe-57ad-b2b2-a7deb330bc61', '3fbf75d7-4873-5d80-acbc-363379276fa4', '4aa3810e-14c6-5497-b826-369b10d47f03', 'b43efbb0-1c6e-5539-87ea-3bf62870170a', 'fcbe6a96-97c0-5011-873d-c50a6726663c', 'b3a88dee-8767-5d62-99f7-c33a4d7f9b7e', '51bda941-ba48-51af-b02e-62780e10e9a4', 'bb8511ab-38a8-5753-9eaa-f89563419605', '2cbc1217-4d82-5d4a-be2c-3a3712f1f3df', '6de28d54-680b-5b8b-a284-1d13742b92e9', '8aa7e14d-c258-59b1-adef-56d20205d6ec', '7fb217ca-1a1a-564b-8d47-5753611926f5', '5a19eafe-5283-5a06-b673-691590c9ae4e', '9c238362-8cb2-58af-a1b7-c4e4a47d5485', 'b5c514ee-77ae-5379-a23b-ed9652dfe523', '29d3149a-c816-5f03-aebd-79b0d9036274', 'adac008a-b566-54ed-b8e4-255d4e102c11', '4f4306a2-6b9f-5137-a506-db768048fbab', '4515d410-0f84-53ab-a356-a3081dc261a8', '396195d9-a998-55af-8cab-7404f959bbbd', 'b8f3cf9b-473d-57c9-b311-df357930bd17', '2701546d-2919-5d60-bd63-38d717229725', 'c8280b8c-5dfe-5e5b-9518-edb66d86ff5f', '101c3a9b-93fb-577d-9e53-8693df6dfbed', '7ef4465a-5d55-5e8a-aa96-72412e257bac', '3360e64f-733a-58cf-aa85-b45fd736c140', 'c76e4dbe-e7d6-5e49-bc9b-ca1865982ce6', 'a0e51942-6704-5ec6-9d1a-bc60e91460f5', 'f5a70d33-85f6-506b-9e72-134269130a62', 'fa19b2f0-9525-575b-a93a-856a577ca1c8', '35757184-b656-5cb6-80fa-f0433a64b25c', '9921c8fb-2724-53c0-8422-09acafda27cc', '8b30c628-a37f-5937-91df-1e7bc40b8839', 'ac203eeb-14b4-517f-ad1b-3b0a1b24e153', '7462c830-ebaa-5bcc-ac7f-4fbabaa83e55', '24be6026-7e23-5bf2-a285-7116dc6b88d8', 'cc049fe1-f473-5ddf-91e2-5fa7bfd93bbc', '9e58f4f9-af6f-5b3c-861b-66379eb75138', '84a9c665-ee19-558c-8772-a9b07266c8a4', '1d088b2f-9f71-56f7-bacd-401b77a25c77', 'c40afccc-35a9-5889-9280-2d204f61ea09', 'd24433a4-a599-5ca0-a550-ada39c10e986', '9c7d3212-8584-5a5c-843a-bcb490adadd8', '50f0bd05-67d9-52c6-91a4-1d3d067545f6', 'e7ee0a9e-0ed0-58e8-a1bf-6c475f719546', '5be1eb46-83a5-5ca8-8d56-6f70e21e1d4c', 'fe355a0e-6d10-5336-a3ab-f802325f51b2', '0b4785e6-e429-5958-a825-305fe0fef811', '4f2c552a-24bf-55dd-ba66-00c5faf82cc8', 'd70266a4-f360-5b38-8a5e-425392d68fc0', 'abb31600-ee20-5438-b3eb-a53389fb0b3a', '1be95d3e-34fd-5a81-95f6-039aa8814d61', '8ddc8e4a-669a-5714-ab0f-598437fc95ba', '04a7c3ae-513a-544a-adb1-ac07fca90dd2', '9b3cc3fc-56de-5b27-a630-d71aad736e32', '386a1d60-2c1b-5045-b72d-022c300cfad6', 'f2db04c4-0e3d-5ec0-9e9d-5f44b52040c2', '84bbab41-e2b2-5186-a2c3-3748c6b31db7', '6056726b-e6d4-5fd1-88a8-9fded6fa2bdb', 'fa761468-5a3f-5406-be2f-67ea52c85b7b', '937868cf-0085-5d8f-8c3f-9696b8ded874', '2d9524f8-543a-52b5-b426-208deaf9f802', 'aebe2f22-7688-5efe-b39f-05598d4bece4', '9bcf79b4-1f09-5407-be5a-c658452bf846', '3fe0a691-7bd5-56e9-abfa-4a38d60052eb', '180a5d56-508f-5c17-a9d9-d78d8d4f152a', '9035eee5-4864-583c-bd1b-aed32fbfc911', '7a00e3a9-656a-5166-b077-c90e41177ce5', 'e7af417c-b44e-5375-a9f8-89bc705b538f', 'b71111cd-f19f-5fa2-8f7d-5286d19a6c07', '7b4455c0-2957-585a-adf9-6710bd8f26f2', '5d80791d-afa4-50e6-af4a-e942e526f90b', '57043ac5-2996-58be-a986-c8b9d097eda9', 'a16f3f6a-f8df-5527-aba8-8c27ed17bdc3', '6c38f0ec-9c71-5853-9aeb-594d382409c9', 'fcbc10d4-a5e4-5e19-b4d2-4b61fa20db98', 'd15e5c0e-753f-5a99-895b-2543218e999d', '5f4fa1ac-0947-5416-98f1-c3650235bb15', '5dea4080-0e84-57fe-86b4-1960ada0b96f', 'd1c3622a-d036-5eea-9fa4-13c510207eb2', '3c85f94e-a9f4-5b4c-9924-607cdbdae1db', '07cd377c-3ee7-51e2-a0de-b571645f3837', 'a3db3448-b0a8-5d30-b1a0-be3e274ffbf6', 'f0d03245-60dc-5d49-b27d-4b3a2a399b17', '83019b1b-3374-5479-8a2d-408d8bd025ab', '85e7ecb6-2158-5a5c-b565-4c48cfe7f315', 'dc0ff405-15db-5cb2-9ed0-20b14407681d', '00dd4a1b-3722-5403-a953-90c3179603e4', '337b8767-d57b-5f82-99e2-941abb2ef94f', '04d37574-9009-530f-809e-4d23565e6f2f', '75d7239b-e2fa-5545-ae6e-3bd097582fea', 'ce9dbcb5-bcb7-575d-8eaa-1da1cb024d6c', '91a01cdd-7bad-5a00-ad43-46abfb7d7f76', 'f73d43db-4939-5fa8-98cf-cf7ee746389e', '257ea8c0-5982-59ab-a9f1-a7620d798db6', '5d4a9b66-83ab-5459-b151-606fffdd58c8', '0d4a6e39-00ba-5907-9e84-3be70ef9e0f8', 'd76d9db0-d392-500c-96ec-af05829b69b9', 'f39b77be-6ae4-5fad-b92a-a3f7efa9d3fd', 'bfeb8f78-de52-58d1-a085-8d12398f5c20', 'bd387dde-1c14-5c2d-804d-d80413c1555e', '4fe4dabf-5ffc-594c-983e-b8465c1263c6', '864bdb74-ab9e-5e1d-87a6-f835990a9cda', '7f33f582-a9b3-5157-a8fb-ac0807152c0e', '01dbb36b-129b-53fd-ba84-06cad1eddc2e', '79b1efdc-9af5-5f5b-bc82-a8d7ea493999', 'd415a3a3-6400-578a-ac6e-8e5ca03fc68b', 'daa30dc0-a71f-586c-bcd0-6ed13fb90e65', '1e8aaddd-2648-5ba4-83a5-2ed8472501d1', '5b52017c-6aba-5b24-af1c-d70436a3b8e8', '17a9ad4f-c500-5943-9996-bdf61c0b8e05', '174e627b-af3a-5ba3-a6e8-30937b5789c1', '4bdb06bd-87ad-5de4-b93c-9eb462bf3013', '7e3f6cd3-42a9-58b5-98ca-47494e5314a8', '0bc7a3a3-4a9f-567b-987a-fa77d291a5a1', 'd3a30657-69f2-52d3-8198-0c545904ceda', '79b3b49e-6caf-5311-93ac-6f1789112509', '13e8e302-0735-5d4a-99be-659d8f5bb5a9', '0eaa1b47-4408-5e90-b1b5-668923e01eee', 'd5c7e832-0200-54fe-8e96-4dffc5acca33', 'd8166c15-0de4-5687-b2cf-bddf59edd74f', 'fbdde263-35e4-59fa-8632-277f52e21e19', '1c8cdc8e-6b81-5311-b104-8556d5aca473', '42156446-ce09-5b2d-9e0f-9df1832546c0', '3055911e-e178-5ef9-a4c8-a900c0a8f162', '09127134-3194-5508-848c-8d6ceb6ff44a', 'f62cd9d3-cd1f-5d8f-b256-13c7aa5f96e9', 'af70ec5b-d1e4-5286-8946-9ea552ff6037', 'ce8c58c8-5616-51b3-a144-6fa25d63912d', '43f1d3f8-d4da-5d54-8341-aa29fa1f1882', 'ea2af380-b6bd-5e98-b667-a895ac18aab7', '5570ae11-4a4a-551f-b820-6633d7800771', '24dd109e-4e9e-541e-a431-021be5dcdf0a', '9625763e-e050-5b7a-83e0-0f21db7f9c1f', '68e2fc68-ac24-5b51-bd23-5d6730207a62', 'de1500ad-6657-57cc-8984-2823d5394981', 'b2dc0604-a9e3-592d-9846-3c55b08c8172', 'd1a15c6a-9e0d-544f-8f23-d378680a96a3', '50038235-16ba-5e80-9898-bde3c81bd957', '29a7266d-b707-538f-a4c0-f8005ee61359', '61201b5a-f6ed-5106-8c7d-9fd173bda9aa', '823b4d98-da11-59b6-85df-ff56f51e24a3', 'd5f61126-f3db-5274-a123-4b0135e53ab6', 'f1537f48-8039-586c-afe9-96fe5a50c1bb', '2a0da3fd-b0a0-5b0f-aee2-06b469f62344', '3f7a7a1c-3b77-5703-a4b8-b57ab035868a', '5bb160b6-4204-56b4-b705-9f370b243dcf', 'c81bd642-fb9c-5e96-8995-c287102c8f6a', '7aa2021b-545d-561f-84ad-eca1cdaddf7c', 'ed6abf32-ce3d-5e2f-b8f3-b6f2f668d614', '44866cf3-500c-51a3-9163-dd1c9f4c465d', '6ca7fc99-3799-51f6-9edc-dd88454f667a', '428b5bfc-ac86-5912-a11d-98723f0feba6', 'a269d132-3aa2-51a7-a5ab-7a25b04f9d4f', 'ecdffe3a-7a00-57f6-9751-913fe367efb8', '06e27276-803c-50ba-9423-b1a5fb965eb9', '8801050f-e3db-55e8-9438-aab34c0a22e3', '703b29d4-6187-5c61-b7e7-1e948e3ed137', '79fd2605-2d65-511d-a0d3-2ec305796a05', '0cce210c-4d3b-55b7-b37f-53f73cb79496', '54313504-0f37-5d14-ad8f-8bb36761b69d', 'b74bb4ca-c839-58ab-91b1-9ea969c4512a', '10b170e6-c535-58f0-8c93-158bfc744a38', 'ca4a0290-b7b2-59a0-b7df-ed65bc7dc6f1', 'adbfc2a8-e3d5-5dc9-a7a3-67891edeaf56', 'f3b415c4-c1c1-5113-985f-486cb922e93c', '59ce70a9-296b-55e4-9378-20ad1854559b', 'e9b14e9e-4d6c-5e7d-83eb-4a9d585a50f5', '7a6f8e5d-12fd-53b8-84eb-4c9d9f12a4c3', 'ca818cdd-85d7-5f56-b1b4-a21924ca2018', 'a15e0a88-f5c9-5806-9ecc-00cd15e39bae', '7364bbbe-ea34-5d0d-8df7-97dbbbcc6e3a', '11e61550-5b7f-5fb7-9f66-637f1f01e461', '31466efa-6210-5a6b-a1cb-f37626225718', '7d8cee0d-9599-547c-a9f5-e5c3decddd5e', 'e3845459-b36d-5664-8263-6c4c997dda54', 'bc8fef7f-9b4d-5bcb-a80d-4612ea2c48a3', '4605c300-308c-51f1-a00b-ed66f8b99fc5', '4f91e9f9-d022-5b96-a2a0-010404f79494', 'f42fc86b-9360-5ac3-96e6-4ec53781353f', '1c88f2d5-078d-5122-a639-4a12c4d434ba', 'd0c8a7c7-9cfc-5d05-8759-d5a64450d700', '956f5932-f857-5ef1-bf73-4e10be374f1f', '2ad4ad34-535e-5d83-a553-8f73c778f514', '60b62f0f-22b9-5006-8d19-278b53c66a10', '55840c36-5aba-522f-ac0e-64073a27ede0', 'ea85c715-175d-5ff4-a5cb-0b3d9d8738c8', '7bd0ed8d-614f-5b94-8af4-8dcdf7b421eb', '33772719-27a6-5859-b8c8-f8188cb60516', '664ecc9b-dafa-59f5-a3e9-f29045409389', '03bc2e1a-df6b-58b0-9854-41f1f1165f6e', '0472b3c4-b2a7-5fc7-b65d-4906aa6a93f7', '8cef93ff-6d57-5a10-8137-0a9848d8179f', 'cbb46478-2e9c-514b-bd81-b116f737f314', 'ebecab47-ca7e-50a2-998e-ff31f140d5b9', '053324bf-ebc1-5140-8fc6-5c21db5b8b27', 'c2b1550a-12c7-544e-b7bf-3413101b442d', 'eef65a72-2046-5b3a-b911-330973e5b903', '95a59d21-456f-53ae-8350-9714649abf2c', 'cdbd1da1-9702-5c25-8f10-8ce450ec6ed2', '38ad5828-7411-57d1-be4f-5a73be6d4d8e', '891f58b6-4487-53b0-af5a-cc171fbf9b41', '7be2091d-1f34-5c15-92ba-28e4de1b9ae7', '739e89a1-e646-5b13-8ccc-bc0ec4e52d85', '6fd95c0a-21c2-5f51-8c51-ca39a0a40d54', '14cf7822-21b4-576a-ae53-4df2a431dd56', 'aca81549-0aef-5ffc-a864-1a0da6b91a18', '9613d99e-dff0-5034-9b74-97bcc549bbbe', 'd1f0a796-df9a-5b08-a895-72f06996632e', '503d0723-3305-526b-97d7-ed3e62a8f6cc', '44bb05c3-8c4a-563d-a5e8-072189817ebe', '56be73d9-505a-5f4b-8cfa-53b217402af6', 'b5a5097b-7338-54ba-8a60-e4a1351d27a2', '98452388-355c-5037-8abf-4ef8b82d72b3', '6549011b-2bff-5fa5-a91d-837742390b3f', 'beef4c71-3a40-5617-8338-15e287c0ad67', '448a5774-82ed-5a89-acd1-20bbc6495caf', 'a9ffe6da-a8cf-5c6b-94cb-479357dd0f06', '664f5a6a-891f-5856-a61a-85211fd6aedc', 'fd31d6de-873c-5475-824b-42d3f1bd4032', '7390e271-fff6-5cd1-96b2-0f364871dfd6', 'bfb384a2-d069-5181-9411-bdc7d058e321', '10e60025-377b-52e9-87a0-9213dd4a78d7', 'a03b3884-1992-55fc-864d-8f01676bcd3d', '435c729d-4771-551c-a27d-69fc14c23335', 'cd86af53-f366-56e9-ab08-ffc9d13862fd', 'fb0919ef-f526-5911-93e3-b5e299af0d33', '798f05f0-f981-5969-837e-6c6f4e40092e', '45621ae6-6ef5-5f37-8d6d-dbe1eb38f761', '49f1c036-4322-50c6-95d5-ee9e3097134a', '2ae445ad-6d83-5c6e-b4b1-3a883f3a4a61', '2041117d-b5c8-5688-ac4b-f98a06982405', '2a2270cb-8afe-52a9-abcf-d77aedece45b', '5a7c34b9-7bde-5cad-9889-286211bc374e', '36a4f63a-c226-51e7-837c-aabb90a99b4e', 'fb8bfe74-a7ae-5a94-ab47-e1f7729ea6e6', '0dd9ed98-8e44-5050-8c95-56aa3517b751', '66a45c07-701a-5a70-a534-74628c9ff315', 'eba3afda-8159-5501-bbc8-66bab893d990', '6fe9645b-bfae-57b1-bfe1-6048f80f82e3', '23e9722a-4875-5325-ae06-d1c37160a59c', '2236f3ee-58df-5cc2-9d3a-85af5397d20b', 'ce4cd562-f09d-57c7-8b76-d1aeaf84d688', '3a5dcae6-37b1-5114-9f96-6326a8a735fc', 'e12bebd5-7af5-5866-9722-d41fd8cab12b', '9f5dab6d-35fc-5014-a475-c72b7587dfc9', '6c367ded-025d-552c-adae-c256211bbcf8', '7b0e3f43-53fc-5ce6-824f-b798e199ae3a', 'd3d2abe7-5fdd-5e42-9de4-985753a9a516', '6c6bf5ed-1ca4-5815-8ed3-e455232ea44d', '29e3891a-0477-57fc-95b1-e343096525fb', 'ba884777-7c88-52aa-93b1-7f62baae9bf3', '1c4530f0-dac4-5147-bbad-8a512d221256', 'e0db8c60-0c42-599d-b9eb-f7f38b74539d', '82dcdbda-5e56-5a5c-9a38-22223f2f9f57', '5a31b348-2f53-5b4c-835d-c72bd212607b', '7c575440-b687-570a-98ce-23c088e715d0', 'b3066aaa-0639-5c6f-a23d-62cf3d7e464d', '5b7362a5-45a3-5113-bc8f-1e215f7e9c46', '633dfe1a-39cd-531a-9e8c-880dad522ad1', 'd017098f-b89f-5736-aa9b-7c08f5b568a6', 'f39ababd-1e11-5da4-a312-96d0c16cd24c', 'd0b58213-1bc6-5951-9e73-a1c568608068', 'd727ca1d-e171-56b0-a284-a9be5d5e290e', 'dfe9fe41-6f1f-57f0-85f9-3beb5663205b', '302d2779-7a86-5af4-af1d-4328f2e4f951', '6492618a-4d8c-5ecb-bea8-5c1b3c807437', 'e3884acb-7bce-5f1a-aeaf-513b1e82583c', '930a6370-293a-56d1-a4e4-3deec889104a', '0246b885-2da2-56ce-bd27-52187745e24c', '1ea8d742-f15e-5400-8ada-ee360a6ffdf9', '16aa9f85-76f2-5f12-a64a-738de8c8977c', '5f5ced4d-2cd3-56c0-a752-685bada74d9a', '85bac3a0-1880-5a77-8fd8-f74c595958d6', '3f966ed6-7238-5460-9a58-4262070d4823', 'fd3608cf-09c4-5d75-a75c-45d936366eb9', '93d68ea7-8e0d-5bda-b5d9-6e88cf94d7a6', 'cb68a4e7-a50e-53bf-8a39-4bb79d73d819', 'b315569b-f2aa-55cd-9499-f92d3f55f422', '30e49c9c-3521-5a7e-9ed8-0974ed97f929', '3cda0a5c-0dea-5eae-9187-63d5b6c0dc1a', '78db6d09-a1d4-5596-8a3f-ef609ac525a2', '8fd245d8-ac44-5491-b7ec-255f86ef0062', 'cddf60fc-dd93-5b07-ba3c-e03ba664c7f4', 'f667b401-9f26-576b-b09a-307129fc4c56', '7497e5a1-46ab-5ad9-b80b-8b60c4b6e5a1', '1fa82fee-2491-59db-a1b7-9a2546f89018', '1d6fc97d-be3a-57f7-932c-4453e65634c1', '6d4c2428-ccb2-5d5e-bdea-21f6126b5651', '0ccd17d4-9143-56b7-9531-031c27df79a2', 'a6c9262f-1d9e-517b-b6ef-69a8dcc8c013', '1c216753-a22d-5464-86d3-be90a15829ed', 'c51bb842-40a5-5470-bc1c-c33eca4a05db', 'aa15740c-bc7c-51b7-9f42-d6514d9103b8', 'c6f57a2b-2500-5135-8156-2fb61a2ee190', 'ce338b7f-bd3a-5d2d-b26d-8f18793a553a', 'de16a223-1307-548d-b23b-ad65b67ca2bf', 'bdd02bf7-4bdc-5ee4-b256-899e4fe1efb6', '243ce463-0ee8-580b-a9d2-fa1f844324a4', 'a239764e-80e3-59ec-b345-38bc9d96e8a7', '3d2dd40f-762a-5f77-aa68-2f1647a78615', 'dcc380bb-2d9e-5add-b613-0980a194cada', 'db61f524-cc17-553e-a310-08f90fd6def7', 'ed2da95c-8e39-57c7-a726-30260632cff4', '43690b1d-0a1b-576a-81af-b5ac0b845f56', '08477d77-b9f5-5c3a-b556-37aa1fa14966', '395d007e-9359-5a00-b442-605ca27c4971', '07939c5e-ec5a-5f11-98f4-5eba7cce9c50', 'b938cf9b-e79e-5a2a-bdc3-9d1ece377268', '92d0da45-6226-50ba-a257-23a32ce66996', 'b05b91c1-5ab6-50e2-aa6c-120d857ed5f6', 'c700223c-ce99-5ea1-a817-5dc9adf357fc', '332e69ef-5164-5604-8f71-d0155a9c9a90', 'bfa91ea0-f898-52a1-94e2-f3bef9f88d10', '11385cb0-1619-5da9-b3b1-30636520db04', 'a2520564-da50-52d2-9724-77e931c42e08', 'b0e0fb36-1c51-5273-babf-9c4a8cb6243a', 'e3b3ce55-5af0-5bb0-9b6e-480c7587ef49', '336babd0-79ef-5521-b14d-deec809be8fd', 'ca582431-ef96-5abc-a8de-1470b337fb37', '9ef44578-3a1e-5595-a2ca-6a3fb40a8b0d', 'f130a20a-11ce-5269-a25c-6144688cd2f8', 'e82f9930-44c6-58ee-82db-97b4dfe64b26', 'febfa53a-c216-5aa8-9f7c-ce3c991942b7', '44745b88-c6df-5daf-b56b-dba2b51f4157', 'b7881855-77c9-5869-8943-ce3bb6a7f0cd', 'a3816302-f911-56bf-850e-1a43b59de26a', 'bf18cda7-5bf3-5c4b-aa43-5e824c18647c', '9aae2c90-e5fa-5583-b97e-49e124432a81', 'daade666-9453-55d5-9025-bd7b280ebf62', 'f8e0ed42-f90b-5a84-93f2-2326037b8d93', 'f6cb3b4d-9914-5fec-b4df-427bf11fbf1d', '61a1d0ce-9b72-59c0-9f15-4fd1997453d6');
  END IF;
END $$;
DELETE FROM public.exercises WHERE subject_id = 'eveil-scientifique-5eme' AND source = 'admin' AND id NOT IN ('55428725-ea97-54df-8ac0-cad043b22446', 'be3d0f2d-8b8b-5c6c-9b6d-dbb1b3ed659a', '77647602-4de3-529b-9211-c0ec5205bdbb', '128a28b6-6910-5567-85ab-20afeae9160f', '9a75e8d5-f060-58b5-b6c5-66d61656731a', 'fadce1da-b5c1-5098-ae9d-d84df00e1fe0', 'e3878a85-7fb3-52ba-97f7-4bd0f9cdfc35', 'e95d69ec-3c50-5a6e-b177-1f4eb3f16065', '9a325752-057c-5858-a3a5-495d9fa46241', 'ff960339-4558-5c3d-88d4-4b68135c7885', 'c39dbf02-888b-50f7-9721-7cde3f815bab', 'da092241-f24c-5827-95a0-dc6944090ae4', '24d0cc73-4af1-59f3-9e6b-56f457bf0aba', '7cebecfb-8502-5b65-a1bc-a36864376f4d', '2328476e-9838-51fb-bf4f-6fd40bb5ff5c', '70c004dc-67e4-5167-8c02-6602de13f6d6', 'b3ed288f-cef8-55a5-a492-91b19e7f1d0b', 'dc7626cb-c9bd-5250-b9f8-133bf1a63154', '6fb62761-1a21-503e-bee8-25220383b695', 'a2cd8402-49ab-5a88-aafe-48ff7b35e36e', 'e14cd373-aebc-50f7-bd9f-651d22667b78', '47394b9e-fad1-5c35-ba03-cbc3274737a5', '8dcf5083-2cac-50e7-83ce-a709d54fb1ff', '27ee852d-3db4-59e5-bc16-b51ecf6358a7', 'ed17a50f-fb98-5ae8-834c-94ae05b8d79b', '63621775-0398-57bd-9dc5-ad13b32453ac', 'f1af9a4d-d024-5fb1-9bb4-7a8a6c3de405', 'f1072900-0f98-5a0a-aa47-7589a3f6a689', '0ccd5016-4053-557e-95fc-d819d59e3b21', '003875d2-eb6b-59db-85ae-35dac548c9df', '97e79ea7-a018-5629-a456-d872e047f2c1', 'a41fcdb4-0774-5608-991b-f702474991f5', '31418d2c-6fff-5002-bc34-74a6d685015b', '6ff290b4-43ff-53d6-8ef0-3e650e9d8bdc', '48368488-950a-52d6-aae4-d2a2127a1f53', 'aa22e92b-3b5b-53ea-a27d-5912e1079ae0', 'a03472bd-57e3-5c1d-917d-7416b23e57eb', '8c655a5f-a2f2-5394-8b16-011cb05cd89b', '15e5e4c2-2c85-5acc-afb4-99d5fa1d52c9', '1b4889fd-8f65-5ee9-a86d-88d85b69e827', '2f0cbea3-9363-5fc2-b54a-ae2688d921d8', '7c650208-506e-5efc-8f2f-fbe379906487', 'fd3003ad-9452-5cb3-a199-5490d7223cbd', 'fc4164dd-336d-59e9-8d54-cb7f301a85a7', 'a531854e-ec8f-52c1-ae07-7af13a71b351', '9f2d8f19-b5ff-5405-bbc7-2e7c9d3b2d87', 'cc5cac2f-b9fa-5393-9cac-c64be053555b', 'caf47842-b908-5477-857f-b5eaab0b797a', '5a575d74-6590-5839-ad3b-80c2ee232fe6', 'd1bfb4b3-df85-5fc7-803a-4ec419db31e1', '77650b2a-3198-5bce-a012-9e94dbefb49d', 'ed79968a-5c3a-580b-ae7a-2fbda3744016', '3b3d6af4-7787-50d9-9972-fa49d9fd188b', '5ab353d5-3a69-5657-a1fe-9c843b74576f', 'de4b8d8e-94f8-5fef-8450-533a1796a423', 'ec1b0927-7f26-58b4-8801-406bdbd98db2', '690289c1-c919-5221-ab17-5e784333c77b', '740fe23f-6e63-5faf-80df-06a7b7614cda', '9577f7e4-482d-5c4c-b634-5add8af5a573', 'df2b296c-cc46-5eb3-a78f-34956c620d29');
DELETE FROM public.questions WHERE exercise_id IN ('55428725-ea97-54df-8ac0-cad043b22446', 'be3d0f2d-8b8b-5c6c-9b6d-dbb1b3ed659a', '77647602-4de3-529b-9211-c0ec5205bdbb', '128a28b6-6910-5567-85ab-20afeae9160f', '9a75e8d5-f060-58b5-b6c5-66d61656731a', 'fadce1da-b5c1-5098-ae9d-d84df00e1fe0', 'e3878a85-7fb3-52ba-97f7-4bd0f9cdfc35', 'e95d69ec-3c50-5a6e-b177-1f4eb3f16065', '9a325752-057c-5858-a3a5-495d9fa46241', 'ff960339-4558-5c3d-88d4-4b68135c7885', 'c39dbf02-888b-50f7-9721-7cde3f815bab', 'da092241-f24c-5827-95a0-dc6944090ae4', '24d0cc73-4af1-59f3-9e6b-56f457bf0aba', '7cebecfb-8502-5b65-a1bc-a36864376f4d', '2328476e-9838-51fb-bf4f-6fd40bb5ff5c', '70c004dc-67e4-5167-8c02-6602de13f6d6', 'b3ed288f-cef8-55a5-a492-91b19e7f1d0b', 'dc7626cb-c9bd-5250-b9f8-133bf1a63154', '6fb62761-1a21-503e-bee8-25220383b695', 'a2cd8402-49ab-5a88-aafe-48ff7b35e36e', 'e14cd373-aebc-50f7-bd9f-651d22667b78', '47394b9e-fad1-5c35-ba03-cbc3274737a5', '8dcf5083-2cac-50e7-83ce-a709d54fb1ff', '27ee852d-3db4-59e5-bc16-b51ecf6358a7', 'ed17a50f-fb98-5ae8-834c-94ae05b8d79b', '63621775-0398-57bd-9dc5-ad13b32453ac', 'f1af9a4d-d024-5fb1-9bb4-7a8a6c3de405', 'f1072900-0f98-5a0a-aa47-7589a3f6a689', '0ccd5016-4053-557e-95fc-d819d59e3b21', '003875d2-eb6b-59db-85ae-35dac548c9df', '97e79ea7-a018-5629-a456-d872e047f2c1', 'a41fcdb4-0774-5608-991b-f702474991f5', '31418d2c-6fff-5002-bc34-74a6d685015b', '6ff290b4-43ff-53d6-8ef0-3e650e9d8bdc', '48368488-950a-52d6-aae4-d2a2127a1f53', 'aa22e92b-3b5b-53ea-a27d-5912e1079ae0', 'a03472bd-57e3-5c1d-917d-7416b23e57eb', '8c655a5f-a2f2-5394-8b16-011cb05cd89b', '15e5e4c2-2c85-5acc-afb4-99d5fa1d52c9', '1b4889fd-8f65-5ee9-a86d-88d85b69e827', '2f0cbea3-9363-5fc2-b54a-ae2688d921d8', '7c650208-506e-5efc-8f2f-fbe379906487', 'fd3003ad-9452-5cb3-a199-5490d7223cbd', 'fc4164dd-336d-59e9-8d54-cb7f301a85a7', 'a531854e-ec8f-52c1-ae07-7af13a71b351', '9f2d8f19-b5ff-5405-bbc7-2e7c9d3b2d87', 'cc5cac2f-b9fa-5393-9cac-c64be053555b', 'caf47842-b908-5477-857f-b5eaab0b797a', '5a575d74-6590-5839-ad3b-80c2ee232fe6', 'd1bfb4b3-df85-5fc7-803a-4ec419db31e1', '77650b2a-3198-5bce-a012-9e94dbefb49d', 'ed79968a-5c3a-580b-ae7a-2fbda3744016', '3b3d6af4-7787-50d9-9972-fa49d9fd188b', '5ab353d5-3a69-5657-a1fe-9c843b74576f', 'de4b8d8e-94f8-5fef-8450-533a1796a423', 'ec1b0927-7f26-58b4-8801-406bdbd98db2', '690289c1-c919-5221-ab17-5e784333c77b', '740fe23f-6e63-5faf-80df-06a7b7614cda', '9577f7e4-482d-5c4c-b634-5add8af5a573', 'df2b296c-cc46-5eb3-a78f-34956c620d29') AND id NOT IN ('d4801fc3-8155-5bdd-ba58-91ace83f0064', 'b5e33dbb-d8e3-5eb9-a489-de2797652a44', '778e9095-c35d-5c86-9d9b-2d6498304115', 'a48f82b7-1ec6-584b-899f-0bc43dd2c15a', '188ba58d-416a-5e6c-bf4c-fedb91790819', 'eb94aed9-f478-510e-94c9-c069a6a1d14d', '24900867-294a-577d-89b5-478d49436ae2', 'd961d7a6-75dd-5e8e-97b7-d924c74c31ef', 'cc217cc4-93d7-5a9f-9f57-2b4211620c82', 'e5b40409-401a-5585-9ed0-95a22ddc74d9', '2fd66c92-4dca-5ee1-b2e6-8cebef4617d7', 'e548969f-e2c5-5b64-8d63-9e039dff4c11', 'cea93a79-846e-5e91-9770-60e153af0eab', 'fe743846-896f-5a2a-b794-366a8d4a3120', '9cb9b330-09d1-598c-870e-5f688113271f', '59e66f05-827b-59f8-96d2-3479b1e036e1', '7dac3b34-694e-55d1-8a4e-6a282fe14c84', '8a36db53-b3fe-57ad-b2b2-a7deb330bc61', '3fbf75d7-4873-5d80-acbc-363379276fa4', '4aa3810e-14c6-5497-b826-369b10d47f03', 'b43efbb0-1c6e-5539-87ea-3bf62870170a', 'fcbe6a96-97c0-5011-873d-c50a6726663c', 'b3a88dee-8767-5d62-99f7-c33a4d7f9b7e', '51bda941-ba48-51af-b02e-62780e10e9a4', 'bb8511ab-38a8-5753-9eaa-f89563419605', '2cbc1217-4d82-5d4a-be2c-3a3712f1f3df', '6de28d54-680b-5b8b-a284-1d13742b92e9', '8aa7e14d-c258-59b1-adef-56d20205d6ec', '7fb217ca-1a1a-564b-8d47-5753611926f5', '5a19eafe-5283-5a06-b673-691590c9ae4e', '9c238362-8cb2-58af-a1b7-c4e4a47d5485', 'b5c514ee-77ae-5379-a23b-ed9652dfe523', '29d3149a-c816-5f03-aebd-79b0d9036274', 'adac008a-b566-54ed-b8e4-255d4e102c11', '4f4306a2-6b9f-5137-a506-db768048fbab', '4515d410-0f84-53ab-a356-a3081dc261a8', '396195d9-a998-55af-8cab-7404f959bbbd', 'b8f3cf9b-473d-57c9-b311-df357930bd17', '2701546d-2919-5d60-bd63-38d717229725', 'c8280b8c-5dfe-5e5b-9518-edb66d86ff5f', '101c3a9b-93fb-577d-9e53-8693df6dfbed', '7ef4465a-5d55-5e8a-aa96-72412e257bac', '3360e64f-733a-58cf-aa85-b45fd736c140', 'c76e4dbe-e7d6-5e49-bc9b-ca1865982ce6', 'a0e51942-6704-5ec6-9d1a-bc60e91460f5', 'f5a70d33-85f6-506b-9e72-134269130a62', 'fa19b2f0-9525-575b-a93a-856a577ca1c8', '35757184-b656-5cb6-80fa-f0433a64b25c', '9921c8fb-2724-53c0-8422-09acafda27cc', '8b30c628-a37f-5937-91df-1e7bc40b8839', 'ac203eeb-14b4-517f-ad1b-3b0a1b24e153', '7462c830-ebaa-5bcc-ac7f-4fbabaa83e55', '24be6026-7e23-5bf2-a285-7116dc6b88d8', 'cc049fe1-f473-5ddf-91e2-5fa7bfd93bbc', '9e58f4f9-af6f-5b3c-861b-66379eb75138', '84a9c665-ee19-558c-8772-a9b07266c8a4', '1d088b2f-9f71-56f7-bacd-401b77a25c77', 'c40afccc-35a9-5889-9280-2d204f61ea09', 'd24433a4-a599-5ca0-a550-ada39c10e986', '9c7d3212-8584-5a5c-843a-bcb490adadd8', '50f0bd05-67d9-52c6-91a4-1d3d067545f6', 'e7ee0a9e-0ed0-58e8-a1bf-6c475f719546', '5be1eb46-83a5-5ca8-8d56-6f70e21e1d4c', 'fe355a0e-6d10-5336-a3ab-f802325f51b2', '0b4785e6-e429-5958-a825-305fe0fef811', '4f2c552a-24bf-55dd-ba66-00c5faf82cc8', 'd70266a4-f360-5b38-8a5e-425392d68fc0', 'abb31600-ee20-5438-b3eb-a53389fb0b3a', '1be95d3e-34fd-5a81-95f6-039aa8814d61', '8ddc8e4a-669a-5714-ab0f-598437fc95ba', '04a7c3ae-513a-544a-adb1-ac07fca90dd2', '9b3cc3fc-56de-5b27-a630-d71aad736e32', '386a1d60-2c1b-5045-b72d-022c300cfad6', 'f2db04c4-0e3d-5ec0-9e9d-5f44b52040c2', '84bbab41-e2b2-5186-a2c3-3748c6b31db7', '6056726b-e6d4-5fd1-88a8-9fded6fa2bdb', 'fa761468-5a3f-5406-be2f-67ea52c85b7b', '937868cf-0085-5d8f-8c3f-9696b8ded874', '2d9524f8-543a-52b5-b426-208deaf9f802', 'aebe2f22-7688-5efe-b39f-05598d4bece4', '9bcf79b4-1f09-5407-be5a-c658452bf846', '3fe0a691-7bd5-56e9-abfa-4a38d60052eb', '180a5d56-508f-5c17-a9d9-d78d8d4f152a', '9035eee5-4864-583c-bd1b-aed32fbfc911', '7a00e3a9-656a-5166-b077-c90e41177ce5', 'e7af417c-b44e-5375-a9f8-89bc705b538f', 'b71111cd-f19f-5fa2-8f7d-5286d19a6c07', '7b4455c0-2957-585a-adf9-6710bd8f26f2', '5d80791d-afa4-50e6-af4a-e942e526f90b', '57043ac5-2996-58be-a986-c8b9d097eda9', 'a16f3f6a-f8df-5527-aba8-8c27ed17bdc3', '6c38f0ec-9c71-5853-9aeb-594d382409c9', 'fcbc10d4-a5e4-5e19-b4d2-4b61fa20db98', 'd15e5c0e-753f-5a99-895b-2543218e999d', '5f4fa1ac-0947-5416-98f1-c3650235bb15', '5dea4080-0e84-57fe-86b4-1960ada0b96f', 'd1c3622a-d036-5eea-9fa4-13c510207eb2', '3c85f94e-a9f4-5b4c-9924-607cdbdae1db', '07cd377c-3ee7-51e2-a0de-b571645f3837', 'a3db3448-b0a8-5d30-b1a0-be3e274ffbf6', 'f0d03245-60dc-5d49-b27d-4b3a2a399b17', '83019b1b-3374-5479-8a2d-408d8bd025ab', '85e7ecb6-2158-5a5c-b565-4c48cfe7f315', 'dc0ff405-15db-5cb2-9ed0-20b14407681d', '00dd4a1b-3722-5403-a953-90c3179603e4', '337b8767-d57b-5f82-99e2-941abb2ef94f', '04d37574-9009-530f-809e-4d23565e6f2f', '75d7239b-e2fa-5545-ae6e-3bd097582fea', 'ce9dbcb5-bcb7-575d-8eaa-1da1cb024d6c', '91a01cdd-7bad-5a00-ad43-46abfb7d7f76', 'f73d43db-4939-5fa8-98cf-cf7ee746389e', '257ea8c0-5982-59ab-a9f1-a7620d798db6', '5d4a9b66-83ab-5459-b151-606fffdd58c8', '0d4a6e39-00ba-5907-9e84-3be70ef9e0f8', 'd76d9db0-d392-500c-96ec-af05829b69b9', 'f39b77be-6ae4-5fad-b92a-a3f7efa9d3fd', 'bfeb8f78-de52-58d1-a085-8d12398f5c20', 'bd387dde-1c14-5c2d-804d-d80413c1555e', '4fe4dabf-5ffc-594c-983e-b8465c1263c6', '864bdb74-ab9e-5e1d-87a6-f835990a9cda', '7f33f582-a9b3-5157-a8fb-ac0807152c0e', '01dbb36b-129b-53fd-ba84-06cad1eddc2e', '79b1efdc-9af5-5f5b-bc82-a8d7ea493999', 'd415a3a3-6400-578a-ac6e-8e5ca03fc68b', 'daa30dc0-a71f-586c-bcd0-6ed13fb90e65', '1e8aaddd-2648-5ba4-83a5-2ed8472501d1', '5b52017c-6aba-5b24-af1c-d70436a3b8e8', '17a9ad4f-c500-5943-9996-bdf61c0b8e05', '174e627b-af3a-5ba3-a6e8-30937b5789c1', '4bdb06bd-87ad-5de4-b93c-9eb462bf3013', '7e3f6cd3-42a9-58b5-98ca-47494e5314a8', '0bc7a3a3-4a9f-567b-987a-fa77d291a5a1', 'd3a30657-69f2-52d3-8198-0c545904ceda', '79b3b49e-6caf-5311-93ac-6f1789112509', '13e8e302-0735-5d4a-99be-659d8f5bb5a9', '0eaa1b47-4408-5e90-b1b5-668923e01eee', 'd5c7e832-0200-54fe-8e96-4dffc5acca33', 'd8166c15-0de4-5687-b2cf-bddf59edd74f', 'fbdde263-35e4-59fa-8632-277f52e21e19', '1c8cdc8e-6b81-5311-b104-8556d5aca473', '42156446-ce09-5b2d-9e0f-9df1832546c0', '3055911e-e178-5ef9-a4c8-a900c0a8f162', '09127134-3194-5508-848c-8d6ceb6ff44a', 'f62cd9d3-cd1f-5d8f-b256-13c7aa5f96e9', 'af70ec5b-d1e4-5286-8946-9ea552ff6037', 'ce8c58c8-5616-51b3-a144-6fa25d63912d', '43f1d3f8-d4da-5d54-8341-aa29fa1f1882', 'ea2af380-b6bd-5e98-b667-a895ac18aab7', '5570ae11-4a4a-551f-b820-6633d7800771', '24dd109e-4e9e-541e-a431-021be5dcdf0a', '9625763e-e050-5b7a-83e0-0f21db7f9c1f', '68e2fc68-ac24-5b51-bd23-5d6730207a62', 'de1500ad-6657-57cc-8984-2823d5394981', 'b2dc0604-a9e3-592d-9846-3c55b08c8172', 'd1a15c6a-9e0d-544f-8f23-d378680a96a3', '50038235-16ba-5e80-9898-bde3c81bd957', '29a7266d-b707-538f-a4c0-f8005ee61359', '61201b5a-f6ed-5106-8c7d-9fd173bda9aa', '823b4d98-da11-59b6-85df-ff56f51e24a3', 'd5f61126-f3db-5274-a123-4b0135e53ab6', 'f1537f48-8039-586c-afe9-96fe5a50c1bb', '2a0da3fd-b0a0-5b0f-aee2-06b469f62344', '3f7a7a1c-3b77-5703-a4b8-b57ab035868a', '5bb160b6-4204-56b4-b705-9f370b243dcf', 'c81bd642-fb9c-5e96-8995-c287102c8f6a', '7aa2021b-545d-561f-84ad-eca1cdaddf7c', 'ed6abf32-ce3d-5e2f-b8f3-b6f2f668d614', '44866cf3-500c-51a3-9163-dd1c9f4c465d', '6ca7fc99-3799-51f6-9edc-dd88454f667a', '428b5bfc-ac86-5912-a11d-98723f0feba6', 'a269d132-3aa2-51a7-a5ab-7a25b04f9d4f', 'ecdffe3a-7a00-57f6-9751-913fe367efb8', '06e27276-803c-50ba-9423-b1a5fb965eb9', '8801050f-e3db-55e8-9438-aab34c0a22e3', '703b29d4-6187-5c61-b7e7-1e948e3ed137', '79fd2605-2d65-511d-a0d3-2ec305796a05', '0cce210c-4d3b-55b7-b37f-53f73cb79496', '54313504-0f37-5d14-ad8f-8bb36761b69d', 'b74bb4ca-c839-58ab-91b1-9ea969c4512a', '10b170e6-c535-58f0-8c93-158bfc744a38', 'ca4a0290-b7b2-59a0-b7df-ed65bc7dc6f1', 'adbfc2a8-e3d5-5dc9-a7a3-67891edeaf56', 'f3b415c4-c1c1-5113-985f-486cb922e93c', '59ce70a9-296b-55e4-9378-20ad1854559b', 'e9b14e9e-4d6c-5e7d-83eb-4a9d585a50f5', '7a6f8e5d-12fd-53b8-84eb-4c9d9f12a4c3', 'ca818cdd-85d7-5f56-b1b4-a21924ca2018', 'a15e0a88-f5c9-5806-9ecc-00cd15e39bae', '7364bbbe-ea34-5d0d-8df7-97dbbbcc6e3a', '11e61550-5b7f-5fb7-9f66-637f1f01e461', '31466efa-6210-5a6b-a1cb-f37626225718', '7d8cee0d-9599-547c-a9f5-e5c3decddd5e', 'e3845459-b36d-5664-8263-6c4c997dda54', 'bc8fef7f-9b4d-5bcb-a80d-4612ea2c48a3', '4605c300-308c-51f1-a00b-ed66f8b99fc5', '4f91e9f9-d022-5b96-a2a0-010404f79494', 'f42fc86b-9360-5ac3-96e6-4ec53781353f', '1c88f2d5-078d-5122-a639-4a12c4d434ba', 'd0c8a7c7-9cfc-5d05-8759-d5a64450d700', '956f5932-f857-5ef1-bf73-4e10be374f1f', '2ad4ad34-535e-5d83-a553-8f73c778f514', '60b62f0f-22b9-5006-8d19-278b53c66a10', '55840c36-5aba-522f-ac0e-64073a27ede0', 'ea85c715-175d-5ff4-a5cb-0b3d9d8738c8', '7bd0ed8d-614f-5b94-8af4-8dcdf7b421eb', '33772719-27a6-5859-b8c8-f8188cb60516', '664ecc9b-dafa-59f5-a3e9-f29045409389', '03bc2e1a-df6b-58b0-9854-41f1f1165f6e', '0472b3c4-b2a7-5fc7-b65d-4906aa6a93f7', '8cef93ff-6d57-5a10-8137-0a9848d8179f', 'cbb46478-2e9c-514b-bd81-b116f737f314', 'ebecab47-ca7e-50a2-998e-ff31f140d5b9', '053324bf-ebc1-5140-8fc6-5c21db5b8b27', 'c2b1550a-12c7-544e-b7bf-3413101b442d', 'eef65a72-2046-5b3a-b911-330973e5b903', '95a59d21-456f-53ae-8350-9714649abf2c', 'cdbd1da1-9702-5c25-8f10-8ce450ec6ed2', '38ad5828-7411-57d1-be4f-5a73be6d4d8e', '891f58b6-4487-53b0-af5a-cc171fbf9b41', '7be2091d-1f34-5c15-92ba-28e4de1b9ae7', '739e89a1-e646-5b13-8ccc-bc0ec4e52d85', '6fd95c0a-21c2-5f51-8c51-ca39a0a40d54', '14cf7822-21b4-576a-ae53-4df2a431dd56', 'aca81549-0aef-5ffc-a864-1a0da6b91a18', '9613d99e-dff0-5034-9b74-97bcc549bbbe', 'd1f0a796-df9a-5b08-a895-72f06996632e', '503d0723-3305-526b-97d7-ed3e62a8f6cc', '44bb05c3-8c4a-563d-a5e8-072189817ebe', '56be73d9-505a-5f4b-8cfa-53b217402af6', 'b5a5097b-7338-54ba-8a60-e4a1351d27a2', '98452388-355c-5037-8abf-4ef8b82d72b3', '6549011b-2bff-5fa5-a91d-837742390b3f', 'beef4c71-3a40-5617-8338-15e287c0ad67', '448a5774-82ed-5a89-acd1-20bbc6495caf', 'a9ffe6da-a8cf-5c6b-94cb-479357dd0f06', '664f5a6a-891f-5856-a61a-85211fd6aedc', 'fd31d6de-873c-5475-824b-42d3f1bd4032', '7390e271-fff6-5cd1-96b2-0f364871dfd6', 'bfb384a2-d069-5181-9411-bdc7d058e321', '10e60025-377b-52e9-87a0-9213dd4a78d7', 'a03b3884-1992-55fc-864d-8f01676bcd3d', '435c729d-4771-551c-a27d-69fc14c23335', 'cd86af53-f366-56e9-ab08-ffc9d13862fd', 'fb0919ef-f526-5911-93e3-b5e299af0d33', '798f05f0-f981-5969-837e-6c6f4e40092e', '45621ae6-6ef5-5f37-8d6d-dbe1eb38f761', '49f1c036-4322-50c6-95d5-ee9e3097134a', '2ae445ad-6d83-5c6e-b4b1-3a883f3a4a61', '2041117d-b5c8-5688-ac4b-f98a06982405', '2a2270cb-8afe-52a9-abcf-d77aedece45b', '5a7c34b9-7bde-5cad-9889-286211bc374e', '36a4f63a-c226-51e7-837c-aabb90a99b4e', 'fb8bfe74-a7ae-5a94-ab47-e1f7729ea6e6', '0dd9ed98-8e44-5050-8c95-56aa3517b751', '66a45c07-701a-5a70-a534-74628c9ff315', 'eba3afda-8159-5501-bbc8-66bab893d990', '6fe9645b-bfae-57b1-bfe1-6048f80f82e3', '23e9722a-4875-5325-ae06-d1c37160a59c', '2236f3ee-58df-5cc2-9d3a-85af5397d20b', 'ce4cd562-f09d-57c7-8b76-d1aeaf84d688', '3a5dcae6-37b1-5114-9f96-6326a8a735fc', 'e12bebd5-7af5-5866-9722-d41fd8cab12b', '9f5dab6d-35fc-5014-a475-c72b7587dfc9', '6c367ded-025d-552c-adae-c256211bbcf8', '7b0e3f43-53fc-5ce6-824f-b798e199ae3a', 'd3d2abe7-5fdd-5e42-9de4-985753a9a516', '6c6bf5ed-1ca4-5815-8ed3-e455232ea44d', '29e3891a-0477-57fc-95b1-e343096525fb', 'ba884777-7c88-52aa-93b1-7f62baae9bf3', '1c4530f0-dac4-5147-bbad-8a512d221256', 'e0db8c60-0c42-599d-b9eb-f7f38b74539d', '82dcdbda-5e56-5a5c-9a38-22223f2f9f57', '5a31b348-2f53-5b4c-835d-c72bd212607b', '7c575440-b687-570a-98ce-23c088e715d0', 'b3066aaa-0639-5c6f-a23d-62cf3d7e464d', '5b7362a5-45a3-5113-bc8f-1e215f7e9c46', '633dfe1a-39cd-531a-9e8c-880dad522ad1', 'd017098f-b89f-5736-aa9b-7c08f5b568a6', 'f39ababd-1e11-5da4-a312-96d0c16cd24c', 'd0b58213-1bc6-5951-9e73-a1c568608068', 'd727ca1d-e171-56b0-a284-a9be5d5e290e', 'dfe9fe41-6f1f-57f0-85f9-3beb5663205b', '302d2779-7a86-5af4-af1d-4328f2e4f951', '6492618a-4d8c-5ecb-bea8-5c1b3c807437', 'e3884acb-7bce-5f1a-aeaf-513b1e82583c', '930a6370-293a-56d1-a4e4-3deec889104a', '0246b885-2da2-56ce-bd27-52187745e24c', '1ea8d742-f15e-5400-8ada-ee360a6ffdf9', '16aa9f85-76f2-5f12-a64a-738de8c8977c', '5f5ced4d-2cd3-56c0-a752-685bada74d9a', '85bac3a0-1880-5a77-8fd8-f74c595958d6', '3f966ed6-7238-5460-9a58-4262070d4823', 'fd3608cf-09c4-5d75-a75c-45d936366eb9', '93d68ea7-8e0d-5bda-b5d9-6e88cf94d7a6', 'cb68a4e7-a50e-53bf-8a39-4bb79d73d819', 'b315569b-f2aa-55cd-9499-f92d3f55f422', '30e49c9c-3521-5a7e-9ed8-0974ed97f929', '3cda0a5c-0dea-5eae-9187-63d5b6c0dc1a', '78db6d09-a1d4-5596-8a3f-ef609ac525a2', '8fd245d8-ac44-5491-b7ec-255f86ef0062', 'cddf60fc-dd93-5b07-ba3c-e03ba664c7f4', 'f667b401-9f26-576b-b09a-307129fc4c56', '7497e5a1-46ab-5ad9-b80b-8b60c4b6e5a1', '1fa82fee-2491-59db-a1b7-9a2546f89018', '1d6fc97d-be3a-57f7-932c-4453e65634c1', '6d4c2428-ccb2-5d5e-bdea-21f6126b5651', '0ccd17d4-9143-56b7-9531-031c27df79a2', 'a6c9262f-1d9e-517b-b6ef-69a8dcc8c013', '1c216753-a22d-5464-86d3-be90a15829ed', 'c51bb842-40a5-5470-bc1c-c33eca4a05db', 'aa15740c-bc7c-51b7-9f42-d6514d9103b8', 'c6f57a2b-2500-5135-8156-2fb61a2ee190', 'ce338b7f-bd3a-5d2d-b26d-8f18793a553a', 'de16a223-1307-548d-b23b-ad65b67ca2bf', 'bdd02bf7-4bdc-5ee4-b256-899e4fe1efb6', '243ce463-0ee8-580b-a9d2-fa1f844324a4', 'a239764e-80e3-59ec-b345-38bc9d96e8a7', '3d2dd40f-762a-5f77-aa68-2f1647a78615', 'dcc380bb-2d9e-5add-b613-0980a194cada', 'db61f524-cc17-553e-a310-08f90fd6def7', 'ed2da95c-8e39-57c7-a726-30260632cff4', '43690b1d-0a1b-576a-81af-b5ac0b845f56', '08477d77-b9f5-5c3a-b556-37aa1fa14966', '395d007e-9359-5a00-b442-605ca27c4971', '07939c5e-ec5a-5f11-98f4-5eba7cce9c50', 'b938cf9b-e79e-5a2a-bdc3-9d1ece377268', '92d0da45-6226-50ba-a257-23a32ce66996', 'b05b91c1-5ab6-50e2-aa6c-120d857ed5f6', 'c700223c-ce99-5ea1-a817-5dc9adf357fc', '332e69ef-5164-5604-8f71-d0155a9c9a90', 'bfa91ea0-f898-52a1-94e2-f3bef9f88d10', '11385cb0-1619-5da9-b3b1-30636520db04', 'a2520564-da50-52d2-9724-77e931c42e08', 'b0e0fb36-1c51-5273-babf-9c4a8cb6243a', 'e3b3ce55-5af0-5bb0-9b6e-480c7587ef49', '336babd0-79ef-5521-b14d-deec809be8fd', 'ca582431-ef96-5abc-a8de-1470b337fb37', '9ef44578-3a1e-5595-a2ca-6a3fb40a8b0d', 'f130a20a-11ce-5269-a25c-6144688cd2f8', 'e82f9930-44c6-58ee-82db-97b4dfe64b26', 'febfa53a-c216-5aa8-9f7c-ce3c991942b7', '44745b88-c6df-5daf-b56b-dba2b51f4157', 'b7881855-77c9-5869-8943-ce3bb6a7f0cd', 'a3816302-f911-56bf-850e-1a43b59de26a', 'bf18cda7-5bf3-5c4b-aa43-5e824c18647c', '9aae2c90-e5fa-5583-b97e-49e124432a81', 'daade666-9453-55d5-9025-bd7b280ebf62', 'f8e0ed42-f90b-5a84-93f2-2326037b8d93', 'f6cb3b4d-9914-5fec-b4df-427bf11fbf1d', '61a1d0ce-9b72-59c0-9f15-4fd1997453d6');
DELETE FROM public.chapters c WHERE c.subject_id = 'eveil-scientifique-5eme' AND c.id NOT IN ('12baa086-c007-5337-9ee0-2216e2ec7739', 'e6444c30-5acd-50ea-b3e8-a419bc5fb1a9', '4b11c4b9-1114-53e1-a9bf-9a61bb490f91', '17b55ae5-b632-5d69-9251-dcfca34e09b2', 'a7133914-32d3-5cea-8555-449857501380', '2c985fde-3a73-5c2e-806f-954d6535f701', '3745467d-e265-51a5-b94e-7f9761992b43', '637e7981-42ce-59d6-9af7-43ab233e8224', '355404c0-718e-5471-abe9-6d83b0333716', '62629568-19b1-5474-8f7f-f4e48091f0d4') AND NOT EXISTS (SELECT 1 FROM public.exercises e WHERE e.chapter_id = c.id);

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('12baa086-c007-5337-9ee0-2216e2ec7739', 'eveil-scientifique-5eme', 'مصادرُ الضوءِ وسرُّ الرؤية', 'نميّز بين الأجسام المضيئة التي تنتج الضوء بنفسها والأجسام المُضاءة التي تعكسه، ونكتشف أنّ الرؤية لا تتمّ إلّا بتوفّر عنصرين معًا: العين والضوء.', '# ⚔️ مصادرُ الضوءِ وسرُّ الرؤية — مستكشفُ النور

> 💡 «في الظلام التامّ لا ترى عينُك شيئًا مهما اتّسعت؛ فالرؤية سرٌّ يجمع بين نورٍ وعين.»

أنت تعرف أنّك ترى الأشياء في النهار وتحت ضوء المصباح، ولا تراها في العتمة. في هذا الفصل نكتشف **من أين يأتي الضوء**، ولماذا **لا نرى إلّا إذا اجتمع الضوءُ والعين**.

## ☀️ الأجسام المضيئة: تنتج الضوء بنفسها

**الجسم المضيء** هو جسمٌ **ينتج الضوء بنفسه** ويرسله إلى ما حوله. منه:

- **مصادر طبيعيّة:** الشمس، والنجوم، والبرق، واليراعة (الحشرة المضيئة).
- **مصادر اصطناعيّة** (صنعها الإنسان): المصباح، والشمعة، والنار، وشاشة الهاتف.

*مثال:* الشمس جسمٌ مضيءٌ كبير، تُرسل ضوءها إلى الأرض في النهار.

## 🌙 الأجسام المُضاءة: تعكس ضوء غيرها

**الجسم المُضاء** جسمٌ **لا ينتج ضوءًا**، لكنّه **يعكس** الضوء الذي يصله من جسمٍ مضيء، فنراه. منه: الكرسيّ، والكتاب، والجدار، والقمر.

> 🗡️ معلومة مهمّة: **القمر جسمٌ مُضاء لا مضيء**؛ فهو لا ينتج ضوءًا، بل يعكس ضوء الشمس، لذلك نراه ليلًا.

## 🔍 كيف نميّز بينهما؟

نسأل سؤالًا واحدًا: **هل يضيء الجسم في الظلام التامّ من تلقاء نفسه؟**

| السؤال | جسم مضيء | جسم مُضاء |
| --- | --- | --- |
| هل ينتج الضوء بنفسه؟ | نعم | لا |
| هل نراه في الظلام التامّ؟ | نعم، لأنّه يضيء | لا، حتّى يصله ضوء |
| أمثلة | الشمس، المصباح، الشمعة | القمر، الكتاب، المرآة |

## 👁️ سرُّ الرؤية: عينٌ + ضوء

لكي **ترى** جسمًا يجب أن يجتمع أمران معًا:

1. **ضوءٌ** يأتي من جسمٍ مضيء ويصل إلى الجسم ثمّ يدخل عينك.
2. **عينٌ سليمة** تستقبل هذا الضوء.

إذا غاب أحدهما **انعدمت الرؤية**: في الظلام التامّ لا ضوء، فلا نرى؛ ولو أغمضنا أعيننا في وضح النهار لا نرى أيضًا.

> 🧪 جرّب: ادخل غرفةً مظلمة تمامًا وأغلق الباب؛ لن ترى الأشياء رغم أنّها موجودة، لأنّ الضوء غائب.

> ⚠️ الفخّ الشائع: الظنّ أنّ العين «تُطلق» شعاعًا فترى به في الظلام. هذا خطأ: العين **تستقبل** الضوء ولا تنتجه، فلا رؤية بلا ضوءٍ يدخل العين.

> 🏆 ممتاز! صرت تميّز الجسم المضيء من المُضاء، وتعرف أنّ الرؤية تجمع بين النور والعين. في الفصل القادم نكتشف كيف ينتشر هذا الضوء ويعبر بعض الأجسام.', '# 📜 ملخّص: مصادرُ الضوءِ وسرُّ الرؤية

- **الجسم المضيء:** ينتج الضوء بنفسه ويرسله، مثل **الشمس والمصباح والشمعة والنار**.
- **مصادر الضوء نوعان:** طبيعيّة (الشمس، النجوم، البرق) واصطناعيّة من صنع الإنسان (المصباح، الشمعة).
- **الجسم المُضاء:** لا ينتج ضوءًا بل **يعكس** ضوء غيره فنراه، مثل **القمر والكتاب والجدار**.
- **القمر جسمٌ مُضاء لا مضيء:** يعكس ضوء الشمس ولا ينتج ضوءًا.
- **سرُّ الرؤية:** لا نرى إلّا إذا اجتمع **الضوءُ + العينُ** معًا؛ إن غاب أحدهما انعدمت الرؤية.
- **العين تستقبل الضوء ولا تنتجه:** لذلك لا نرى في الظلام التامّ مهما كانت العين سليمة.', 1)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('e6444c30-5acd-50ea-b3e8-a419bc5fb1a9', 'eveil-scientifique-5eme', 'انتشارُ الضوءِ والأجسامُ الشفّافة', 'نكتشف أنّ الضوء ينتشر في خطوطٍ مستقيمة، ونصنّف الأجسام حسب نفاذ الضوء فيها إلى شفّافة وشافّة (نصف شفّافة) وعاتمة.', '# ⚔️ انتشارُ الضوءِ والأجسامُ الشفّافة — طريقُ النور المستقيم

> 💡 «يسير الضوءُ في خطٍّ مستقيمٍ لا ينحني؛ ولهذا يكفي جدارٌ صغيرٌ ليصنع ظلًّا كبيرًا.»

في الفصل السابق عرفت مصادر الضوء. الآن نتتبّع **كيف يسافر الضوء** من المصدر، و**أيّ الأجسام يعبرها** وأيّها يحجبه.

## ➡️ الانتشار المستقيميّ للضوء

**ينتشر الضوء في خطوطٍ مستقيمة** ما دام يسير في **وسطٍ واحد** (مثل الهواء). لا ينحني الضوء من تلقاء نفسه.

نسمّي الخطّ المستقيم الذي يسلكه الضوء **شعاعًا ضوئيًّا**، ونرسمه بسهمٍ يبيّن جهة سيره.

*مثال:* حزمة ضوء المصباح اليدويّ في غرفةٍ فيها غبارٌ خفيف تظهر كخطٍّ مستقيم.

> 🧪 جرّب: ثقب ثلاث بطاقاتٍ في نقاطٍ متطابقة وصفّها؛ لا ترى المصباح من الثقوب إلّا إذا كانت الثقوب على **خطٍّ مستقيمٍ واحد**، لأنّ الضوء لا ينحني ليمرّ.

## 🔍 الأجسام حسب نفاذ الضوء

عندما يصل الضوء إلى جسمٍ، يتصرّف الجسم بإحدى ثلاث طرق:

| نوع الجسم | يمرّ الضوء؟ | نرى عبره؟ | أمثلة |
| --- | --- | --- | --- |
| **شفّاف** | يمرّ كلّه | نرى الأشياء بوضوح | الزجاج النقيّ، الماء الصافي، الهواء |
| **شافّ** (نصف شفّاف) | يمرّ بعضه | نرى الضوء لا التفاصيل | الورق الرقيق، الزجاج المثلّج، البلّور |
| **عاتم** | لا يمرّ | لا نرى عبره إطلاقًا | الخشب، الجدار، المعدن، الكتاب |

## 🪟 الجسم الشفّاف

**الشفّاف** يدع الضوء يمرّ كلّه تقريبًا، فنرى الأشياء خلفه بوضوح. *مثل:* نظرنا عبر زجاج النافذة النقيّ فنرى الشارع.

## 🌫️ الجسم الشافّ (نصف الشفّاف)

**الشافّ** يدع بعض الضوء يمرّ ويحجب البعض، فنرى **نورًا** خلفه لكن لا نميّز التفاصيل. *مثل:* الزجاج المثلّج في باب الحمّام نرى وراءه ضوءًا دون تفاصيل.

## 🧱 الجسم العاتم

**العاتم** يحجب الضوء كلّه فلا يمرّ منه شيء، ولا نرى عبره أبدًا، ويصنع **ظلًّا**. *مثل:* الجدار والباب الخشبيّ.

> ⚠️ الفخّ الشائع: الخلط بين **الشفّاف** و**الشافّ**. الشفّاف نرى عبره **التفاصيل بوضوح** (الزجاج النقيّ)، أمّا الشافّ فنرى عبره **ضوءًا فقط دون تفاصيل** (الزجاج المثلّج).

> 🏆 رائع! صرت تعرف أنّ الضوء يسير في خطٍّ مستقيم، وتصنّف الأجسام إلى شفّافةٍ وشافّةٍ وعاتمة. في الفصل القادم نكتشف كيف يصنع الجسم العاتم **الظلّ**، وكيف يحدث الكسوف والخسوف.', '# 📜 ملخّص: انتشارُ الضوءِ والأجسامُ الشفّافة

- **الانتشار المستقيميّ:** ينتشر الضوء في **خطوطٍ مستقيمة** في الوسط الواحد، ولا ينحني من تلقاء نفسه.
- **الشعاع الضوئيّ:** الخطّ المستقيم الذي يسلكه الضوء، نرسمه بسهمٍ يبيّن جهته.
- **الجسم الشفّاف:** يمرّ الضوء كلّه ونرى عبره الأشياء بوضوح (الزجاج النقيّ، الماء الصافي، الهواء).
- **الجسم الشافّ (نصف الشفّاف):** يمرّ بعض الضوء فنرى نورًا دون تفاصيل (الزجاج المثلّج، الورق الرقيق).
- **الجسم العاتم:** يحجب الضوء كلّه فلا نرى عبره ويصنع ظلًّا (الخشب، الجدار، المعدن).
- **لا تخلط بين الشفّاف والشافّ:** الشفّاف نرى عبره التفاصيل، والشافّ نرى عبره الضوء فقط.', 2)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('4b11c4b9-1114-53e1-a9bf-9a61bb490f91', 'eveil-scientifique-5eme', 'الظلُّ والكسوفُ والخسوف', 'نفهم كيف يتكوّن الظلّ عندما يعترض جسمٌ عاتم الضوء، ونفسّر كسوف الشمس وخسوف القمر بترتيب الشمس والأرض والقمر.', '# ⚔️ الظلُّ والكسوفُ والخسوف — أسرارُ الظلال

> 💡 «حين يقف جسمٌ عاتمٌ في طريق الضوء يولد الظلّ؛ وحين تصطفّ الأرضُ والشمسُ والقمر يكبر الظلّ حتّى يبتلع الشمسَ أو القمر.»

تعلّمت أنّ الجسم العاتم يحجب الضوء. هنا نكتشف ماذا يحدث **خلف الجسم العاتم**: يتكوّن **الظلّ**، ونرى كيف يصنع هذا المبدأ نفسه **الكسوف والخسوف**.

## 🌑 كيف يتكوّن الظلّ؟

يتكوّن الظلّ عندما تجتمع **ثلاثة عناصر**:

1. **مصدرٌ مضيء** (مثل المصباح أو الشمس).
2. **جسمٌ عاتم** يعترض الضوء (مثل كرةٍ أو يد).
3. **شاشة** يظهر عليها الظلّ (مثل جدارٍ أو أرض).

لأنّ الضوء يسير **مستقيمًا**، يحجبه الجسم العاتم فتظهر **منطقةٌ مظلمة** خلفه على الشاشة هي **الظلّ**.

*مثال:* تقف تحت الشمس فيظهر ظلّك على الأرض، لأنّ جسمك جسمٌ عاتمٌ يحجب ضوء الشمس.

## 📏 شكل الظلّ وحجمه

- يأخذ الظلّ **شكل الجسم العاتم** نفسه تقريبًا (ظلّ الكرة دائريّ، ظلّ المسطرة مستطيل).
- **كلّما اقترب الجسم من المصدر المضيء كبر ظلّه**، وكلّما ابتعد عنه صغر ظلّه.

> 🗡️ حيلة: قرّب يدك من المصباح يكبر ظلّها على الجدار، وأبعدها يصغر؛ والسبب أنّ الضوء يسير مستقيمًا.

## ☀️ كسوف الشمس

**الكسوف** يحدث نهارًا عندما **يقف القمر بين الشمس والأرض** على خطٍّ واحد. فيحجب القمر (الجسم العاتم) ضوء الشمس عن جزءٍ من الأرض، فيقع ظلّ القمر على الأرض ويصير النهار معتمًا قليلًا.

$$ الشمس ← القمر ← الأرض $$

## 🌕 خسوف القمر

**الخسوف** يحدث ليلًا عندما **تقف الأرض بين الشمس والقمر** على خطٍّ واحد. فتحجب الأرض (الجسم العاتم) ضوء الشمس عن القمر، فيدخل القمر في **ظلّ الأرض** ويُظلم.

$$ الشمس ← الأرض ← القمر $$

| الظاهرة | الترتيب | الجسم العاتم الحاجب | متى |
| --- | --- | --- | --- |
| **كسوف الشمس** | الشمس ← القمر ← الأرض | القمر | نهارًا |
| **خسوف القمر** | الشمس ← الأرض ← القمر | الأرض | ليلًا |

> ⚠️ الفخّ الشائع: الخلط بين الكسوف والخسوف. تذكّر: في **كسوف الشمس** القمر هو الحاجب في الوسط، وفي **خسوف القمر** الأرض هي الحاجبة في الوسط.

> 🛡️ تنبيه مهمّ: **لا تنظر إلى الشمس مباشرة** أثناء الكسوف، فضوؤها القويّ يؤذي العين حتّى وهي مكسوفة.

> 🏆 رائع! أتممت وحدة الضوء: تعرف الآن كيف يولد الظلّ، وكيف يفسّر الانتشار المستقيميّ للضوء الكسوفَ والخسوف. في الفصل القادم ندخل عالم جسم الإنسان ونكتشف الهيكل العظميّ.', '# 📜 ملخّص: الظلُّ والكسوفُ والخسوف

- **تكوّن الظلّ:** يحتاج ثلاثة عناصر: **مصدرٌ مضيء + جسمٌ عاتم + شاشة**؛ يحجب الجسم العاتم الضوء فتظهر منطقةٌ مظلمة خلفه.
- **سبب الظلّ:** الضوء يسير مستقيمًا، فلا يلتفّ حول الجسم العاتم.
- **شكل الظلّ:** يشبه شكل الجسم العاتم؛ ويكبر كلّما اقترب الجسم من المصدر المضيء، ويصغر كلّما ابتعد.
- **كسوف الشمس (نهارًا):** يقف **القمر** بين الشمس والأرض (الشمس ← القمر ← الأرض)، فيحجب ضوء الشمس.
- **خسوف القمر (ليلًا):** تقف **الأرض** بين الشمس والقمر (الشمس ← الأرض ← القمر)، فيدخل القمر في ظلّ الأرض.
- **لا تخلط:** في الكسوف القمر هو الحاجب، وفي الخسوف الأرض هي الحاجبة. ولا تنظر إلى الشمس مباشرة أثناء الكسوف.', 3)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('17b55ae5-b632-5d69-9251-dcfca34e09b2', 'eveil-scientifique-5eme', 'الهيكلُ العظميُّ وأنواعُ العظام', 'نتعرّف على دور الهيكل العظميّ في دعم الجسم وحمايته وحركته، ونصنّف العظام إلى طويلة وقصيرة ومسطّحة مع أمثلتها.', '# ⚔️ الهيكلُ العظميُّ وأنواعُ العظام — دعائمُ الجسد

> 💡 «لولا الهيكل العظميّ لكان جسمك كيسًا ليّنًا لا يقف؛ فهو العمود الذي يحملك ويحميك.»

تحت جلدك ولحمك يوجد **هيكلٌ عظميّ** قويّ. في هذا الفصل نكتشف **وظائفه** و**أنواع عظامه**.

## 🦴 ما هو الهيكل العظميّ؟

**الهيكل العظميّ** مجموعة **العظام** الصلبة المترابطة في الجسم. عظام الإنسان كثيرة، وأهمّ أجزائه:

- **الجمجمة:** صندوقٌ عظميّ في الرأس.
- **العمود الفقريّ:** سلسلة عظامٍ في الظهر.
- **القفص الصدريّ:** أضلاعٌ تحيط بالصدر.
- **عظام الأطراف:** عظام الذراعين والساقين.

## 🛡️ وظائف الهيكل العظميّ

للهيكل العظميّ ثلاث وظائف مهمّة:

1. **الدعم (السند):** يحمل الجسم ويبقيه منتصبًا، كعمود الخيمة.
2. **الحماية:** يحمي الأعضاء الرقيقة؛ فالجمجمة تحمي الدماغ، والقفص الصدريّ يحمي القلب والرئتين.
3. **الحركة:** ترتكز عليه العضلات فتحرّك الجسم.

> 🗡️ تذكّر: العمود الفقريّ يحمي **النّخاع الشوكيّ**، والجمجمة تحمي **الدماغ** — أعضاءٌ ثمينةٌ جدًّا.

## 📏 أنواع العظام

نصنّف العظام حسب **شكلها** إلى ثلاثة أنواع:

| النوع | الشكل | أمثلة |
| --- | --- | --- |
| **عظمٌ طويل** | طوله أكبر من عرضه | عظم الذراع، عظم الفخذ، عظم الساق |
| **عظمٌ قصير** | طوله قريبٌ من عرضه (مكعّب الشكل) | عظام الرسغ، عظام القدم |
| **عظمٌ مسطّح** | رقيقٌ ومنبسط | عظام الجمجمة، عظم الكتف، الأضلاع |

## 🥛 كيف نحافظ على عظامنا؟

- نأكل غذاءً غنيًّا بـ**الكالسيوم** (الحليب، الأجبان) فيقوّي العظام.
- نمارس **الرياضة** فتشتدّ العظام.
- نجلس ونمشي **بظهرٍ مستقيم** حتّى لا يعوجّ العمود الفقريّ.

> ⚠️ الفخّ الشائع: الخلط بين أنواع العظام بحسب الحجم لا الشكل. التصنيف بالشكل: **الطويل** طوله أكبر من عرضه (الفخذ)، و**القصير** طوله قريبٌ من عرضه (الرسغ)، و**المسطّح** رقيقٌ منبسط (الجمجمة) — لا بحسب كونه كبيرًا أو صغيرًا فحسب.

> 🏆 ممتاز! صرت تعرف أنّ الهيكل العظميّ يدعم جسمك ويحميه ويحرّكه، وتميّز العظم الطويل من القصير من المسطّح. في الفصل القادم نكتشف كيف تتحرّك هذه العظام بفضل العضلات والمفاصل.', '# 📜 ملخّص: الهيكلُ العظميُّ وأنواعُ العظام

- **الهيكل العظميّ:** مجموعة العظام الصلبة المترابطة؛ أهمّ أجزائه: الجمجمة، العمود الفقريّ، القفص الصدريّ، عظام الأطراف.
- **وظائف الهيكل ثلاث:** **الدعم** (يحمل الجسم منتصبًا)، **الحماية** (الجمجمة تحمي الدماغ، القفص الصدريّ يحمي القلب والرئتين)، **الحركة** (ترتكز عليه العضلات).
- **العظم الطويل:** طوله أكبر من عرضه، مثل عظم الفخذ والذراع والساق.
- **العظم القصير:** طوله قريبٌ من عرضه، مثل عظام الرسغ والقدم.
- **العظم المسطّح:** رقيقٌ ومنبسط، مثل عظام الجمجمة وعظم الكتف والأضلاع.
- **أحافظ على عظامي:** أتناول الكالسيوم (الحليب)، أمارس الرياضة، أجلس بظهرٍ مستقيم.', 4)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('a7133914-32d3-5cea-8555-449857501380', 'eveil-scientifique-5eme', 'الحركةُ: العضلاتُ والمفاصل', 'نكتشف كيف يتحرّك الجسم بفضل العضلات التي تنقبض وتنبسط، والمفاصل التي تربط العظام، والأوتار التي تشدّ العظم.', '# ⚔️ الحركةُ: العضلاتُ والمفاصل — محرّكاتُ الجسد

> 💡 «العظام وحدها لا تتحرّك؛ تحتاج إلى عضلاتٍ تشدّها ومفاصل تثنيها — فريقٌ متكامل يصنع كلّ حركة.»

تعلّمت أنّ الهيكل العظميّ يساعد على الحركة. لكن **كيف** تتحرّك العظام فعلًا؟ السرّ في **العضلات** و**المفاصل** و**الأوتار**.

## 💪 العضلات: محرّك الحركة

**العضلة** نسيجٌ ليّنٌ قويّ يلتصق بالعظام. تتحرّك العضلة بطريقتين:

- **الانقباض:** تقصر العضلة وتنتفخ، فتشدّ العظم وتحرّكه.
- **الانبساط:** تطول العضلة وتسترخي، فتعود إلى وضعها.

*مثال:* عندما تثني ذراعك تنقبض عضلة الذراع (العضلة ذات الرأسين) وتنتفخ، فيرتفع الساعد.

## 🔗 الأوتار: حبال الوصل

**الوتر** حبلٌ قويٌّ يربط **العضلة بالعظم**. عندما تنقبض العضلة، يشدّ الوتر العظم فيتحرّك.

*مثال:* وتر العرقوب فوق الكعب يربط عضلة الساق بعظم الكعب، فنرفع أعقابنا عند المشي.

## 🦵 المفاصل: مواضع الثني

**المفصل** هو **موضع التقاء عظمين** يسمح بالحركة بينهما. بفضل المفاصل نثني ونمدّ أطرافنا. من المفاصل:

- **مفصل الركبة:** يثني الساق.
- **مفصل المرفق (الكوع):** يثني الذراع.
- **مفصل الكتف** و**مفصل الورك:** يديران الطرف في كلّ الجهات.

> 🗡️ تذكّر: حيث **يثني** جسمك يوجد **مفصل**؛ والعظم نفسه لا ينثني، بل يلتقي عظمان عند المفصل.

## 🤝 تعاون العضلات والعظام والمفاصل

تحدث الحركة بتعاونٍ منظّم:

1. تنقبض **العضلة** فتنتفخ.
2. يشدّ **الوتر** **العظم**.
3. يتحرّك العظم حول **المفصل**.

فلا حركة بعضلةٍ وحدها، ولا بعظمٍ وحده؛ بل بتعاونهما عند المفصل.

> ⚠️ الفخّ الشائع: الظنّ أنّ العظم نفسه ينثني. العظم **صلبٌ لا ينثني**؛ الانثناء يحدث عند **المفصل** حيث يلتقي عظمان، وتحرّكهما العضلات بواسطة الأوتار.

> 🛡️ نحافظ على عضلاتنا ومفاصلنا: نمارس الرياضة بانتظام، ونُحمّي العضلات قبل الجهد، ولا نحمل أوزانًا أثقل من طاقتنا.

> 🏆 رائع! صرت تفهم أنّ الحركة فريقٌ من العضلات والأوتار والعظام والمفاصل. في الفصل القادم ندخل إلى التنفّس ونكتشف كيف يحصل جسمك على الأكسجين.', '# 📜 ملخّص: الحركةُ: العضلاتُ والمفاصل

- **العضلة:** نسيجٌ ليّنٌ قويّ يلتصق بالعظام ويحرّكها.
- **حركة العضلة نوعان:** **الانقباض** (تقصر وتنتفخ فتشدّ العظم) و**الانبساط** (تطول وتسترخي).
- **الوتر:** حبلٌ قويٌّ يربط العضلة بالعظم، فينقل شدّ العضلة إلى العظم.
- **المفصل:** موضع التقاء عظمين يسمح بالحركة بينهما، مثل الركبة والمرفق والكتف.
- **تعاون الحركة:** تنقبض العضلة ← يشدّ الوتر العظم ← يتحرّك العظم حول المفصل.
- **العظم لا ينثني:** الانثناء يحدث عند المفصل لا في العظم نفسه (العظم صلب).
- **نحافظ على الحركة:** الرياضة بانتظام، تحمية العضلات، وعدم حمل ما يفوق طاقتنا.', 5)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('2c985fde-3a73-5c2e-806f-954d6535f701', 'eveil-scientifique-5eme', 'التنفّسُ والجهازُ التنفّسيّ', 'نتعرّف على أعضاء الجهاز التنفّسيّ ومسار الهواء، وحركتي الشهيق والزفير، وتبادل الأكسجين وغاز الفحم، وقواعد المحافظة على الجهاز التنفّسيّ.', '# ⚔️ التنفّسُ والجهازُ التنفّسيّ — نَفَسُ الحياة

> 💡 «نصبر عن الأكل ساعاتٍ، لكنّنا لا نصبر عن التنفّس إلّا دقائق؛ فالتنفّس نَفَسُ الحياة.»

في كلّ لحظةٍ نأخذ هواءً ونطرده دون أن ننتبه. هذه العمليّة اسمها **التنفّس**، ويقوم بها **الجهاز التنفّسيّ**.

## 🌬️ ما هو التنفّس؟

**التنفّس** هو دخول الهواء إلى الجسم وخروجه منه باستمرار. يأخذ الجسم من الهواء غازًا مفيدًا اسمه **الأكسجين**، ويطرد غازًا غير مفيد اسمه **غاز الفحم** (ثاني أكسيد الكربون).

## 🫁 أعضاء الجهاز التنفّسيّ ومسار الهواء

يمرّ الهواء في طريقه إلى داخل الجسم عبر:

- **الأنف:** يدخل منه الهواء فيُصفّى ويُدفّأ.
- **الرّغامى (القصبة الهوائيّة):** أنبوبٌ ينقل الهواء من الأنف إلى الرئتين.
- **الرئتان:** عضوان إسفنجيّان في الصدر، فيهما يأخذ الجسم الأكسجين ويطرح غاز الفحم.

> 🧭 مسار الهواء عند الدخول: الأنف ← الرّغامى ← الرئتان.

## 🔄 حركتا الشهيق والزفير

يتنفّس الجسم بحركتين متعاقبتين:

- **الشهيق:** ندخل الهواء إلى الرئتين، فينتفخ الصدر (هواءٌ غنيٌّ بالأكسجين).
- **الزفير:** نُخرج الهواء من الرئتين، فينكمش الصدر (هواءٌ غنيٌّ بغاز الفحم).

> 🧪 جرّب: ضع يدك على صدرك؛ تشعر أنّه ينتفخ مع الشهيق وينكمش مع الزفير.

## 💨 الأكسجين وغاز الفحم

- **الهواء الذي ندخله (شهيق):** غنيٌّ بـ**الأكسجين** المفيد للجسم.
- **الهواء الذي نُخرجه (زفير):** غنيٌّ بـ**غاز الفحم** الذي طرحه الجسم.

ففي الرئتين يحدث **تبادل**: يأخذ الدم الأكسجين لينقله إلى الجسم، ويتخلّص من غاز الفحم.

## 🛡️ كيف نحافظ على جهازنا التنفّسيّ؟

- نتنفّس **هواءً نقيًّا** ونبتعد عن الدخان.
- نمارس **الرياضة** فتقوى الرئتان.
- نتجنّب الأماكن الملوّثة بالغبار والغازات.

> ⚠️ الفخّ الشائع: الظنّ أنّ الهواء الذي نُخرجه (الزفير) هو نفسه الذي ندخله. في الحقيقة هواء الزفير فقد كثيرًا من الأكسجين وامتلأ بغاز الفحم.

> 🏆 الآن صرت تعرف كيف يحصل جسمك على الأكسجين في كلّ نَفَس، ولماذا يجب أن نتنفّس هواءً نقيًّا. في الفصل القادم نتتبّع رحلة هذا الأكسجين في الدم عبر الدورة الدمويّة.', '# 📜 ملخّص: التنفّسُ والجهازُ التنفّسيّ

- **التنفّس:** دخول الهواء إلى الجسم وخروجه باستمرار؛ يأخذ الجسم الأكسجين ويطرد غاز الفحم.
- **أعضاء الجهاز التنفّسيّ:** الأنف (يُصفّي الهواء ويُدفّئه)، الرّغامى (تنقل الهواء)، الرئتان (مكان التبادل).
- **مسار الهواء:** الأنف ← الرّغامى ← الرئتان.
- **الشهيق:** دخول الهواء فينتفخ الصدر (هواءٌ غنيٌّ بالأكسجين).
- **الزفير:** خروج الهواء فينكمش الصدر (هواءٌ غنيٌّ بغاز الفحم).
- **التبادل في الرئتين:** يأخذ الدم الأكسجين ويتخلّص من غاز الفحم.
- **نحافظ على الجهاز التنفّسيّ:** نتنفّس هواءً نقيًّا، نبتعد عن الدخان، ونمارس الرياضة.', 6)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('3745467d-e265-51a5-b94e-7f9761992b43', 'eveil-scientifique-5eme', 'الدورةُ الدمويّةُ ونبضُ القلب', 'نكتشف دور القلب في ضخّ الدم، والفرق بين الشرايين والأوردة، والدورتين الدمويّتين الكبرى والصغرى، ودور الدم في نقل الأكسجين والغذاء.', '# ⚔️ الدورةُ الدمويّةُ ونبضُ القلب — نهرُ الحياة

> 💡 «في جسمك نهرٌ أحمر لا يتوقّف، ومضخّةٌ صغيرة بحجم قبضتك تدفعه ليلًا ونهارًا: إنّه القلب والدم.»

أخذ الدمُ الأكسجينَ في الرئتين. لكن **كيف يصل** هذا الأكسجين إلى كلّ خليّةٍ في جسمك؟ السرّ في **القلب** و**الأوعية الدمويّة**.

## ❤️ القلب: المضخّة

**القلب** عضوٌ عضليٌّ بحجم قبضة اليد، يقع في الصدر بين الرئتين. يعمل القلب **مضخّةً**: ينقبض وينبسط باستمرار **فيضخّ الدم** إلى كلّ الجسم.

نبضات القلب التي نحسّها هي انقباضاته وهو يدفع الدم.

> 🗡️ جرّب: ضع إصبعك على رقبتك أو معصمك تحسّ **النبض**؛ هو دفعات الدم مع كلّ انقباضةٍ للقلب.

## 🩸 الأوعية الدمويّة: الشرايين والأوردة

يجري الدم في أنابيب تُسمّى **الأوعية الدمويّة**، نوعان رئيسيّان:

| الوعاء | يحمل الدم | الاتّجاه |
| --- | --- | --- |
| **الشريان** | من القلب إلى الجسم | خارجٌ من القلب |
| **الوريد** | من الجسم إلى القلب | عائدٌ إلى القلب |

فالشريان يُخرج الدم من القلب، والوريد يُرجعه إليه.

## 🔄 الدورتان: الكبرى والصغرى

يدور الدم في الجسم في **دورتين**:

- **الدورة الكبرى:** يخرج الدم من القلب إلى **كلّ أعضاء الجسم** (يحمل الأكسجين والغذاء)، ثمّ يعود إلى القلب.
- **الدورة الصغرى:** يذهب الدم من القلب إلى **الرئتين** (يأخذ الأكسجين ويطرح غاز الفحم)، ثمّ يعود إلى القلب.

## 🚚 دور الدم في الجسم

الدم وسيلة النقل في الجسم:

- ينقل **الأكسجين** من الرئتين والغذاء من الأمعاء إلى كلّ الأعضاء.
- يحمل **الفضلات** وغاز الفحم بعيدًا عن الأعضاء ليتخلّص الجسم منها.

> ⚠️ الفخّ الشائع: الخلط بين **الشريان** و**الوريد**. تذكّر: **الشريان** يحمل الدم **من القلب** إلى الجسم (خارج)، و**الوريد** يحمل الدم **إلى القلب** (عائد). انظر إلى **اتّجاه** الدم لا إلى لونه.

> 🛡️ نحافظ على قلبنا: نمارس الرياضة فيقوى القلب، ونأكل غذاءً متوازنًا، ونبتعد عن التدخين.

> 🏆 ممتاز! صرت تعرف أنّ القلب مضخّةٌ تدفع الدم في الشرايين والأوردة، وتميّز الدورة الكبرى من الصغرى. في الفصل القادم ننتقل إلى عالم الكهرباء ونبني دارةً تُضيء مصباحًا.', '# 📜 ملخّص: الدورةُ الدمويّةُ ونبضُ القلب

- **القلب:** عضوٌ عضليٌّ بحجم قبضة اليد في الصدر، يعمل مضخّةً تضخّ الدم إلى الجسم بانقباضه وانبساطه.
- **النبض:** دفعات الدم التي نحسّها مع كلّ انقباضةٍ للقلب.
- **الشريان:** وعاءٌ يحمل الدم **من القلب إلى الجسم** (خارج).
- **الوريد:** وعاءٌ يحمل الدم **من الجسم إلى القلب** (عائد).
- **الدورة الكبرى:** من القلب إلى كلّ أعضاء الجسم ثمّ العودة إليه.
- **الدورة الصغرى:** من القلب إلى الرئتين (لأخذ الأكسجين وطرح غاز الفحم) ثمّ العودة إليه.
- **دور الدم:** ينقل الأكسجين والغذاء إلى الأعضاء، ويحمل الفضلات وغاز الفحم بعيدًا.
- **لا تخلط:** الشريان يخرج من القلب، والوريد يعود إليه — انظر إلى الاتّجاه.', 7)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('637e7981-42ce-59d6-9af7-43ab233e8224', 'eveil-scientifique-5eme', 'الدارةُ الكهربائيّةُ والأمان', 'نبني دارةً كهربائيّة بسيطة ونتعرّف على عناصرها وشرط اشتغالها، ونميّز الموادّ الناقلة من العازلة، ونتعلّم قواعد السلامة من الكهرباء.', '# ⚔️ الدارةُ الكهربائيّةُ والأمان — الطريقُ المغلق للتيّار

> 💡 «بضغطة زرٍّ يُضاء المصباح؛ سرّ ذلك دارةٌ كهربائيّة تشبه طريقًا مغلقًا يجري فيه التيّار.»

كيف يضيء المصباح؟ وكيف نُشعله ونطفئه؟ في هذا الفصل نبني **دارةً كهربائيّة** ونكتشف أسرارها وقواعد الأمان معها.

## 🔋 عناصر الدارة الكهربائيّة البسيطة

**الدارة الكهربائيّة** طريقٌ مغلقٌ يمرّ فيه **التيّار الكهربائيّ**. تتكوّن الدارة البسيطة من:

- **المولّد (العمود/البطاريّة):** مصدر الكهرباء.
- **الأسلاك:** تنقل الكهرباء.
- **المصباح:** يستهلك الكهرباء فيضيء.
- **القاطعة (الزرّ):** تفتح الدارة أو تغلقها للتحكّم.

## 💡 أجزاء المصباح الكهربائيّ

داخل المصباح **خيطٌ رفيع** (الفتيلة) يتوهّج فيضيء عند مرور التيّار، يحيط به زجاجٌ يحميه. ويتّصل المصباح بالدارة عبر طرفين معدنيّين.

## 🔁 شرط اشتغال الدارة

لكي يضيء المصباح يجب أن تكون الدارة **مغلقة**: أي أنّ التيّار يجد طريقًا متّصلًا من المولّد إلى المصباح ثمّ يعود.

- **دارة مغلقة:** كلّ شيءٍ متّصل ← المصباح **يضيء**.
- **دارة مفتوحة:** السلك مقطوع أو الزرّ مفتوح ← المصباح **لا يضيء**.

> 🧪 جرّب: إذا فصلت سلكًا واحدًا انطفأ المصباح؛ لأنّ الدارة صارت مفتوحة فانقطع طريق التيّار.

## 🧲 الموادّ الناقلة والعازلة

ليست كلّ الموادّ تسمح بمرور الكهرباء:

| النوع | يمرّ التيّار؟ | أمثلة |
| --- | --- | --- |
| **موادّ ناقلة** | نعم | المعادن (النحاس، الحديد، الألمنيوم) |
| **موادّ عازلة** | لا | البلاستيك، الخشب، الزجاج، المطّاط |

> 🧪 جرّب: ضع قطعة نحاسٍ في الدارة فيضيء المصباح (ناقل)؛ وضع قطعة بلاستيكٍ فيبقى مطفأً (عازل).

## 🛡️ القاطعة والصّهيرة والأمان

- **القاطعة:** زرٌّ يفتح الدارة فيقطع التيّار عند الحاجة (للتحكّم في الإشعال والإطفاء).
- **الصّهيرة:** قطعةٌ تنصهر فتقطع التيّار تلقائيًّا عند مروره بقوّةٍ خطيرة، فتحمي الدارة.

قواعد السلامة من الكهرباء:

- **لا نلمس** الأسلاك العارية أو المقابس بأيدٍ مبلّلة.
- **لا ندخل** أيّ شيءٍ في مأخذ الكهرباء.
- نبتعد عن الأسلاك الكهربائيّة الكبيرة في الخارج.
- نطلب مساعدة الكبار عند أيّ مشكلٍ كهربائيّ.

> ⚠️ الفخّ الشائع: الظنّ أنّ المصباح يضيء حتّى لو كانت الدارة مفتوحة. في الحقيقة يجب أن تكون الدارة **مغلقة** ليمرّ التيّار ويضيء المصباح.

> 🏆 ممتاز! صرت تبني دارةً تُضيء مصباحًا، وتميّز الناقل من العازل، وتعرف قواعد الأمان مع الكهرباء. في الفصل القادم ندخل عالم الكائنات الحيّة والوسط البيئيّ.', '# 📜 ملخّص: الدارةُ الكهربائيّةُ والأمان

- **الدارة الكهربائيّة:** طريقٌ مغلقٌ يمرّ فيه التيّار؛ عناصرها: المولّد (العمود) + الأسلاك + المصباح + القاطعة.
- **المصباح:** فيه خيطٌ رفيع (فتيلة) يتوهّج فيضيء عند مرور التيّار.
- **شرط الإضاءة:** الدارة **مغلقة** (طريقٌ متّصل) ← المصباح يضيء؛ الدارة **مفتوحة** ← المصباح لا يضيء.
- **الموادّ الناقلة:** تسمح بمرور التيّار، مثل المعادن (النحاس، الحديد).
- **الموادّ العازلة:** تمنع مرور التيّار، مثل البلاستيك والخشب والزجاج والمطّاط.
- **القاطعة:** زرٌّ يفتح الدارة للتحكّم؛ **الصّهيرة:** تنصهر فتقطع التيّار عند الخطر فتحمي الدارة.
- **الأمان:** لا نلمس الأسلاك العارية بأيدٍ مبلّلة، ولا ندخل شيئًا في المأخذ، ونطلب مساعدة الكبار.', 8)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('355404c0-718e-5471-abe9-6d83b0333716', 'eveil-scientifique-5eme', 'الكائناتُ الحيّةُ والسلسلةُ الغذائيّة', 'نتعرّف على عناصر الوسط البيئيّ، وكيف تتغذّى الحيوانات وتصطاد، ونبني سلاسل غذائيّة تربط الكائنات الحيّة بعضها ببعض.', '# ⚔️ الكائناتُ الحيّةُ والسلسلةُ الغذائيّة — شبكةُ الحياة

> 💡 «في الطبيعة لا يعيش كائنٌ وحده؛ فالنبتة تُطعم الأرنب، والأرنب يُطعم الثعلب — حلقاتٌ مترابطة في شبكة الحياة.»

حولنا **وسطٌ بيئيٌّ** مليءٌ بالكائنات الحيّة. في هذا الفصل نكتشف **كيف تتغذّى الحيوانات**، وكيف ترتبط الكائنات في **سلاسل غذائيّة**.

## 🌍 الوسط البيئيّ وعناصره

**الوسط البيئيّ** هو المكان الذي تعيش فيه الكائنات الحيّة. يتكوّن من عناصر:

- **عناصر حيّة:** النباتات والحيوانات.
- **عناصر غير حيّة:** التربة، الماء، الهواء، الضوء، الحرارة (المناخ).

تعيش الكائنات الحيّة معًا في توازنٍ، يأخذ بعضها من بعض.

## 🍃 كيف تتغذّى الحيوانات؟

نصنّف الحيوانات حسب غذائها:

| الصنف | يأكل | أمثلة |
| --- | --- | --- |
| **عاشبة** | النباتات | الأرنب، الغزال، البقرة |
| **لاحمة** | حيواناتٍ أخرى | الأسد، الثعلب، الصقر |
| **كالشة (مختلطة)** | نباتاتٍ وحيوانات | الدجاجة، الإنسان، الدبّ |

## 🦅 الاصطياد واستهلاك الغذاء

تأخذ الحيوانات غذاءها بطرقٍ مختلفة:

- **الاصطياد:** تصطاد الحيوانات اللاحمة فرائسها (الأسد يصطاد الغزال).
- **القرض والمضغ:** تقرض العواشب النبات بأسنانها.
- **الالتقاط والابتلاع:** يلتقط الطائر الحبوب ويبتلعها.
- **المصّ والامتصاص:** تمصّ الفراشة رحيق الأزهار.

## 🔗 السلسلة الغذائيّة

**السلسلة الغذائيّة** سلسلةٌ تبيّن **من يأكل من**، تبدأ دائمًا بـ**نبتة**. كلّ سهمٍ يعني «يُؤكَل من قِبَل»:

$$ نبتة → أرنب → ثعلب $$

- **النبتة** أوّل حلقة: تصنع غذاءها بنفسها بمساعدة الضوء.
- **العاشب** يأكل النبتة.
- **اللاحم** يأكل العاشب.

> 🗡️ تذكّر: السهم في السلسلة يتّجه دائمًا **نحو الآكل**؛ فـ«نبتة → أرنب» تعني أنّ الأرنب يأكل النبتة.

## ⚖️ التوازن البيئيّ

ترتبط الكائنات بعضها ببعض؛ فإذا اختفت حلقةٌ تأثّرت باقي الحلقات. *مثال:* لو اختفت النباتات لجاع الأرنب، ولو جاع الأرنب لجاع الثعلب. لذلك نحافظ على الكائنات الحيّة كلّها.

> ⚠️ الفخّ الشائع: عكس اتّجاه السهم في السلسلة. السهم يشير إلى **من يأكل**، لا إلى من يُؤكَل؛ فـ«عشب → غزال» صحيحة لأنّ الغزال يأكل العشب، وليس العكس.

> 🏆 رائع! صرت تعرف كيف تتغذّى الحيوانات وتبني سلسلةً غذائيّة، وتفهم التوازن البيئيّ. في الفصل القادم نكتشف النبتة والإنبات والتربة والماء الصالح للشرب.', '# 📜 ملخّص: الكائناتُ الحيّةُ والسلسلةُ الغذائيّة

- **الوسط البيئيّ:** مكان عيش الكائنات؛ عناصره حيّة (نباتات وحيوانات) وغير حيّة (تربة، ماء، هواء، ضوء، حرارة).
- **تغذية الحيوانات:** **عاشبة** (تأكل النبات: الأرنب)، **لاحمة** (تأكل الحيوان: الأسد)، **كالشة/مختلطة** (تأكل الاثنين: الدجاجة، الإنسان).
- **طرق أخذ الغذاء:** الاصطياد، القرض والمضغ، الالتقاط والابتلاع، المصّ والامتصاص.
- **السلسلة الغذائيّة:** تبيّن من يأكل من، تبدأ دائمًا بنبتة؛ السهم يعني «يُؤكَل من قِبَل»: نبتة → أرنب → ثعلب.
- **اتّجاه السهم:** نحو الآكل دائمًا (عشب → غزال يعني الغزال يأكل العشب).
- **التوازن البيئيّ:** الكائنات مترابطة؛ اختفاء حلقةٍ يؤثّر في باقي الحلقات، فنحافظ عليها كلّها.', 9)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.chapters (id, subject_id, title, description, lesson_content, summary, display_order) VALUES
  ('62629568-19b1-5474-8f7f-f4e48091f0d4', 'eveil-scientifique-5eme', 'النبتةُ والتربةُ والماءُ الصالحُ للشّرب', 'نكتشف مكوّنات البذرة وشروط الإنبات والتكاثر بالبذور، ومكوّنات التربة ودور الماء والأملاح المعدنيّة في نموّ النبتة، وكيف يصبح الماء صالحًا للشّرب بالترسيب والترشيح والتعقيم.', '# ⚔️ النبتةُ والتربةُ والماءُ الصالحُ للشّرب — كنوزُ الأرض

> 💡 «من بذرةٍ صغيرة تخرج شجرةٌ كبيرة؛ كلّ ما تحتاجه ماءٌ وترابٌ ودفءٌ وقليلٌ من الصبر.»

النبتة كائنٌ حيّ ينمو من **بذرة**. في هذا الفصل نكتشف كيف **تنبت البذرة**، وما الذي تحتاجه النبتة من **التربة والماء**، وكيف يصبح الماء **صالحًا للشّرب**.

## 🌱 مكوّنات البذرة والتكاثر بالبذور

تتكاثر معظم النباتات بـ**البذور**. تتكوّن البذرة من:

- **الغلاف:** يحمي البذرة من الخارج.
- **الجنين (الرشيم):** نبتةٌ صغيرة نائمة تنمو فيما بعد.
- **المدّخر الغذائيّ:** غذاءٌ مخزون يتغذّى منه الجنين عند الإنبات.

## 🌾 شروط الإنبات

**الإنبات** هو خروج النبتة الصغيرة من البذرة. لتنبت البذرة تحتاج إلى شروطٍ ملائمة:

- **الماء:** يوقظ البذرة ويُليّن غلافها.
- **الهواء:** تحتاج البذرة الهواء لتتنفّس.
- **الحرارة المعتدلة (الدفء):** تساعد على الإنبات.

> 🧪 جرّب: ضع بذور العدس على قطنٍ رطبٍ في مكانٍ دافئ؛ بعد أيّامٍ تنبت. أمّا البذور الجافّة فلا تنبت.

## 🪴 التربة ودور الماء والأملاح المعدنيّة

تنمو النبتة في **التربة** التي تثبّت جذورها وتغذّيها. تتكوّن التربة من رمل وطين وحصى وبقايا كائناتٍ حيّة (الدّبال).

تأخذ النبتة من التربة بجذورها:

- **الماء:** ضروريٌّ لحياة النبتة ونموّها.
- **الأملاح المعدنيّة:** موادٌّ ذائبةٌ في الماء تغذّي النبتة وتساعدها على النموّ.

> 🗡️ تذكّر: تأخذ النبتة الماء والأملاح المعدنيّة من التربة بواسطة **الجذور**.

## 💧 الماء الصالح للشّرب

ليس كلّ ماءٍ صالحًا للشّرب؛ فماء الأنهار قد يكون عكرًا وملوّثًا. ليصبح صالحًا للشّرب يمرّ بثلاث عمليّات:

| العمليّة | ماذا تفعل |
| --- | --- |
| **الترسيب** | نترك الماء يهدأ فتنزل الأوساخ الثقيلة إلى القاع |
| **الترشيح** | نمرّر الماء عبر طبقاتٍ (رمل وحصى) فتحتجز الشوائب |
| **التعقيم** | نقتل الجراثيم (مثلًا بمادّةٍ معقّمة) فيصبح الماء آمنًا |

> 🛡️ نحافظ على الماء: لا نلوّث الأنهار والآبار، ولا نُسرف في استعماله، فهو كنزٌ ثمين.

> ⚠️ الفخّ الشائع: الظنّ أنّ الماء العكر يصبح صالحًا للشّرب بمجرّد تركه يهدأ (الترسيب وحده). في الحقيقة لا بدّ من **الترشيح ثمّ التعقيم** أيضًا لقتل الجراثيم التي لا تُرى.

> 🏆 رائع! أتممت برنامج الإيقاظ العلمي للسنة الخامسة: تعرف الآن كيف تنبت البذرة وتنمو النبتة، وكيف يصبح الماء صالحًا للشّرب. تهانينا أيّها المستكشف!', '# 📜 ملخّص: النبتةُ والتربةُ والماءُ الصالحُ للشّرب

- **التكاثر بالبذور:** تتكاثر معظم النباتات بالبذور.
- **مكوّنات البذرة:** الغلاف (يحمي)، الجنين/الرشيم (نبتةٌ صغيرة نائمة)، المدّخر الغذائيّ (غذاءٌ مخزون).
- **شروط الإنبات:** الماء + الهواء + الحرارة المعتدلة (الدفء).
- **التربة:** تثبّت الجذور وتغذّي النبتة؛ تتكوّن من رمل وطين وحصى ودبال.
- **تأخذ النبتة من التربة بجذورها:** الماء والأملاح المعدنيّة الذائبة فيه، وهي ضروريّةٌ للنموّ.
- **الماء الصالح للشّرب:** يمرّ بثلاث عمليّات: **الترسيب** (تهدأ الأوساخ فتنزل)، **الترشيح** (تُحتجز الشوائب)، **التعقيم** (تُقتل الجراثيم).
- **لا يكفي الترسيب وحده:** لا بدّ من الترشيح ثمّ التعقيم لقتل الجراثيم غير المرئيّة.', 10)
ON CONFLICT (id) DO UPDATE SET
  subject_id = EXCLUDED.subject_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  lesson_content = EXCLUDED.lesson_content,
  summary = EXCLUDED.summary,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('55428725-ea97-54df-8ac0-cad043b22446', '12baa086-c007-5337-9ee0-2216e2ec7739', 'eveil-scientifique-5eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d4801fc3-8155-5bdd-ba58-91ace83f0064', '55428725-ea97-54df-8ac0-cad043b22446', 'ما هو الجسم المضيء؟', '[{"id":"a","text":"جسمٌ ينتج الضوء بنفسه"},{"id":"b","text":"جسمٌ يعكس ضوء غيره فقط"},{"id":"c","text":"جسمٌ لا نراه أبدًا"},{"id":"d","text":"جسمٌ بارد دائمًا"}]'::jsonb, 'a', 'الجسم المضيء ينتج الضوء بنفسه ويرسله إلى ما حوله، مثل الشمس والمصباح.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5e33dbb-d8e3-5eb9-a489-de2797652a44', '55428725-ea97-54df-8ac0-cad043b22446', 'أيٌّ ممّا يلي مصدرٌ طبيعيٌّ للضوء؟', '[{"id":"a","text":"المصباح الكهربائيّ"},{"id":"b","text":"الشمس"},{"id":"c","text":"الشمعة"},{"id":"d","text":"شاشة الهاتف"}]'::jsonb, 'b', 'الشمس مصدرٌ طبيعيٌّ للضوء. أمّا المصباح والشمعة وشاشة الهاتف فمصادر اصطناعيّة صنعها الإنسان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('778e9095-c35d-5c86-9d9b-2d6498304115', '55428725-ea97-54df-8ac0-cad043b22446', 'لماذا نرى القمر في الليل؟', '[{"id":"a","text":"لأنّه ينتج الضوء بنفسه"},{"id":"b","text":"لأنّه نجمٌ مشتعل"},{"id":"c","text":"لأنّه يعكس ضوء الشمس"},{"id":"d","text":"لأنّه أقرب جسمٍ إلينا"}]'::jsonb, 'c', 'القمر جسمٌ مُضاء لا مضيء: لا ينتج ضوءًا بل يعكس ضوء الشمس فنراه ليلًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a48f82b7-1ec6-584b-899f-0bc43dd2c15a', '55428725-ea97-54df-8ac0-cad043b22446', 'ماذا يجب أن يجتمع لكي نرى جسمًا؟', '[{"id":"a","text":"الصوت والأذن"},{"id":"b","text":"الحرارة واليد"},{"id":"c","text":"الماء والعين"},{"id":"d","text":"الضوء والعين"}]'::jsonb, 'd', 'لا تتمّ الرؤية إلّا باجتماع الضوء والعين معًا؛ إن غاب أحدهما لم نرَ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('188ba58d-416a-5e6c-bf4c-fedb91790819', '55428725-ea97-54df-8ac0-cad043b22446', 'في الصورة جسمان: الشمس والقمر. أيّهما الجسم المضيء الذي ينتج الضوء بنفسه؟ <svg viewBox="0 0 200 110" xmlns="http://www.w3.org/2000/svg"><circle cx="55" cy="55" r="30" fill="#fcd116" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="55" y1="10" x2="55" y2="20"/><line x1="55" y1="90" x2="55" y2="100"/><line x1="10" y1="55" x2="20" y2="55"/><line x1="90" y1="55" x2="100" y2="55"/><line x1="23" y1="23" x2="30" y2="30"/><line x1="80" y1="80" x2="87" y2="87"/></g><text x="42" y="60" font-size="13" fill="#1f2937">1</text><path d="M165 30 a30 30 0 1 0 0 60 a24 24 0 1 1 0 -60 z" fill="#cbd5e1" stroke="#1f2937" stroke-width="3"/><text x="150" y="64" font-size="13" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"الجسم رقم 1 (الشمس)"},{"id":"b","text":"الجسم رقم 2 (القمر)"},{"id":"c","text":"كلاهما مضيء"},{"id":"d","text":"لا يوجد جسمٌ مضيء"}]'::jsonb, 'a', 'الشمس (رقم 1) جسمٌ مضيء ينتج الضوء بنفسه، أمّا القمر (رقم 2) فمُضاء يعكس ضوءها.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('be3d0f2d-8b8b-5c6c-9b6d-dbb1b3ed659a', '12baa086-c007-5337-9ee0-2216e2ec7739', 'eveil-scientifique-5eme', '⭐ تمرين: مضيءٌ أم مُضاء؟', 1, 50, 10, 'practice', 'admin', 1)
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
  ('eb94aed9-f478-510e-94c9-c069a6a1d14d', 'be3d0f2d-8b8b-5c6c-9b6d-dbb1b3ed659a', 'أيٌّ ممّا يلي جسمٌ مضيءٌ ينتج الضوء بنفسه؟', '[{"id":"a","text":"المصباح المُشعَل"},{"id":"b","text":"المرآة"},{"id":"c","text":"الجدار"},{"id":"d","text":"الكتاب"}]'::jsonb, 'a', 'المصباح المُشعَل ينتج الضوء بنفسه فهو جسمٌ مضيء. أمّا المرآة والجدار والكتاب فأجسامٌ مُضاءة تعكس الضوء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24900867-294a-577d-89b5-478d49436ae2', 'be3d0f2d-8b8b-5c6c-9b6d-dbb1b3ed659a', 'الشمعة المُشعَلة جسمٌ:', '[{"id":"a","text":"مُضاء"},{"id":"b","text":"مضيء"},{"id":"c","text":"مظلم"},{"id":"d","text":"شفّاف"}]'::jsonb, 'b', 'الشمعة المُشعَلة تنتج الضوء بنفسها بلهبها، فهي جسمٌ مضيء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d961d7a6-75dd-5e8e-97b7-d924c74c31ef', 'be3d0f2d-8b8b-5c6c-9b6d-dbb1b3ed659a', 'أيٌّ ممّا يلي جسمٌ مُضاء (لا ينتج ضوءًا)؟', '[{"id":"a","text":"الشمس"},{"id":"b","text":"البرق"},{"id":"c","text":"الكرسيّ"},{"id":"d","text":"النار"}]'::jsonb, 'c', 'الكرسيّ لا ينتج ضوءًا بل يعكس ضوء غيره، فهو جسمٌ مُضاء. أمّا الشمس والبرق والنار فأجسامٌ مضيئة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc217cc4-93d7-5a9f-9f57-2b4211620c82', 'be3d0f2d-8b8b-5c6c-9b6d-dbb1b3ed659a', 'أيٌّ ممّا يلي مصدرٌ اصطناعيٌّ للضوء (صنعه الإنسان)؟', '[{"id":"a","text":"النجوم"},{"id":"b","text":"الشمس"},{"id":"c","text":"البرق"},{"id":"d","text":"المصباح الكهربائيّ"}]'::jsonb, 'd', 'المصباح الكهربائيّ مصدرٌ اصطناعيٌّ صنعه الإنسان. أمّا النجوم والشمس والبرق فمصادر طبيعيّة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e5b40409-401a-5585-9ed0-95a22ddc74d9', 'be3d0f2d-8b8b-5c6c-9b6d-dbb1b3ed659a', 'في غرفةٍ مظلمةٍ تمامًا، أيّ جسمٍ نراه دون أن نُشعل أيّ شيء؟', '[{"id":"a","text":"اليراعة (الحشرة المضيئة)"},{"id":"b","text":"كرسيٌّ خشبيّ"},{"id":"c","text":"كتابٌ مغلق"},{"id":"d","text":"مرآةٌ معلّقة"}]'::jsonb, 'a', 'اليراعة جسمٌ مضيء ينتج ضوءه بنفسه، فنراه في الظلام. أمّا الكرسيّ والكتاب والمرآة فأجسامٌ مُضاءة لا تُرى بلا ضوء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2fd66c92-4dca-5ee1-b2e6-8cebef4617d7', 'be3d0f2d-8b8b-5c6c-9b6d-dbb1b3ed659a', 'أكمل: لا تتمّ الرؤية إلّا إذا توفّر ............ والعين معًا.', '[{"id":"a","text":"الصوت"},{"id":"b","text":"الضوء"},{"id":"c","text":"الحرارة"},{"id":"d","text":"الماء"}]'::jsonb, 'b', 'الرؤية تحتاج إلى الضوء الذي يدخل العين؛ بلا ضوءٍ لا نرى مهما كانت العين سليمة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('77647602-4de3-529b-9211-c0ec5205bdbb', '12baa086-c007-5337-9ee0-2216e2ec7739', 'eveil-scientifique-5eme', '⚔️ زعيم الفصل ⭐⭐⭐: حارسُ النور', 3, 120, 30, 'boss', 'admin', 2)
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
  ('e548969f-e2c5-5b64-8d63-9e039dff4c11', '77647602-4de3-529b-9211-c0ec5205bdbb', 'صنّف الأجسام التالية: أيّها كلّها أجسامٌ مضيئة؟', '[{"id":"a","text":"الشمس، المصباح المُشعَل، الشمعة المُشعَلة"},{"id":"b","text":"القمر، المرآة، الكتاب"},{"id":"c","text":"الشمس، القمر، الجدار"},{"id":"d","text":"المصباح، الكرسيّ، الكتاب"}]'::jsonb, 'a', 'الشمس والمصباح المُشعَل والشمعة المُشعَلة كلّها تنتج الضوء بنفسها فهي مضيئة. باقي المجموعات تخلط أجسامًا مُضاءة مع مضيئة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cea93a79-846e-5e91-9770-60e153af0eab', '77647602-4de3-529b-9211-c0ec5205bdbb', 'نراقب القمر ليلًا. أيّ تفسيرٍ صحيح؟', '[{"id":"a","text":"القمر ينتج ضوءه بنفسه مثل الشمس"},{"id":"b","text":"القمر يعكس ضوء الشمس الواصل إليه"},{"id":"c","text":"القمر نارٌ مشتعلة في السماء"},{"id":"d","text":"القمر يضيء بفضل النجوم القريبة منه"}]'::jsonb, 'b', 'القمر جسمٌ مُضاء: يعكس ضوء الشمس الواصل إليه فنراه. الخطأ الشائع هو الظنّ أنّه ينتج ضوءه بنفسه، والصحيح أنّه لا مصدر للضوء فيه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe743846-896f-5a2a-b794-366a8d4a3120', '77647602-4de3-529b-9211-c0ec5205bdbb', 'في كهفٍ مظلمٍ تمامًا توجد تفّاحةٌ حمراء على طاولة. لماذا لا نراها؟', '[{"id":"a","text":"لأنّ التفّاحة جسمٌ مُضاء ولا ضوء يصلها لتعكسه"},{"id":"b","text":"لأنّ التفّاحة صغيرةٌ جدًّا"},{"id":"c","text":"لأنّ العين تتوقّف عن العمل في الكهف"},{"id":"d","text":"لأنّ التفّاحة تمتصّ كلّ الألوان"}]'::jsonb, 'a', 'التفّاحة جسمٌ مُضاء يحتاج إلى ضوءٍ يصله ليعكسه نحو العين؛ في الظلام التامّ لا ضوء، فلا رؤية. الفخّ الشائع نسبة العجز إلى العين، والصحيح أنّ الضوء هو الغائب.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9cb9b330-09d1-598c-870e-5f688113271f', '77647602-4de3-529b-9211-c0ec5205bdbb', 'أيّ عبارةٍ عن العين صحيحة؟', '[{"id":"a","text":"العين تُطلق ضوءًا فترى به الأشياء في الظلام"},{"id":"b","text":"العين تستقبل الضوء الآتي من الأجسام فنرى"},{"id":"c","text":"العين تنتج الضوء مثل المصباح"},{"id":"d","text":"العين ترى دون حاجةٍ إلى أيّ ضوء"}]'::jsonb, 'b', 'العين تستقبل الضوء ولا تنتجه؛ لذلك نرى الأجسام عندما يدخل ضوؤها إلى العين. الخطأ الشائع هو الظنّ أنّ العين تُطلق شعاعًا، وهذا غير صحيح.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59e66f05-827b-59f8-96d2-3479b1e036e1', '77647602-4de3-529b-9211-c0ec5205bdbb', 'أيّ جسمين كلاهما مصدرٌ طبيعيٌّ للضوء؟', '[{"id":"a","text":"المصباح والشمعة"},{"id":"b","text":"شاشة الهاتف والمصباح"},{"id":"c","text":"الشمس والبرق"},{"id":"d","text":"الشمعة والنار في الموقد"}]'::jsonb, 'c', 'الشمس والبرق مصدران طبيعيّان للضوء لم يصنعهما الإنسان. أمّا المصباح والشمعة وشاشة الهاتف فمصادر اصطناعيّة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7dac3b34-694e-55d1-8a4e-6a282fe14c84', '77647602-4de3-529b-9211-c0ec5205bdbb', 'نهارًا داخل غرفةٍ مضاءة، أغمض تلميذٌ عينيه. لماذا لم يعد يرى الأشياء؟', '[{"id":"a","text":"لأنّ الضوء اختفى من الغرفة"},{"id":"b","text":"لأنّ الأشياء صارت مظلمة"},{"id":"c","text":"لأنّ الأجسام المُضاءة توقّفت عن عكس الضوء"},{"id":"d","text":"لأنّ الضوء موجودٌ لكنّ العين أُغلقت فلم تستقبله"}]'::jsonb, 'd', 'الرؤية تحتاج عنصرين: ضوء وعين. الضوء بقي موجودًا، لكنّ إغماض العين منعها من استقباله فانعدمت الرؤية. الفخّ الشائع نسبة السبب إلى الضوء أو الأشياء، والصحيح أنّ العين أُغلقت.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('128a28b6-6910-5567-85ab-20afeae9160f', '12baa086-c007-5337-9ee0-2216e2ec7739', 'eveil-scientifique-5eme', '⭐⭐ تمرين مراجعة (نمط امتحان): مصادرُ الضوء', 2, 75, 15, 'practice', 'admin', 3)
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
  ('8a36db53-b3fe-57ad-b2b2-a7deb330bc61', '128a28b6-6910-5567-85ab-20afeae9160f', 'الفرق الأساسيّ بين الجسم المضيء والجسم المُضاء هو:', '[{"id":"a","text":"المضيء ينتج الضوء بنفسه، والمُضاء يعكس ضوء غيره"},{"id":"b","text":"المضيء صغير، والمُضاء كبير"},{"id":"c","text":"المضيء بارد، والمُضاء ساخن"},{"id":"d","text":"المضيء أبيض، والمُضاء ملوّن"}]'::jsonb, 'a', 'الجسم المضيء ينتج الضوء بنفسه، أمّا الجسم المُضاء فيعكس ضوء غيره فقط؛ هذا هو الفرق الأساسيّ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3fbf75d7-4873-5d80-acbc-363379276fa4', '128a28b6-6910-5567-85ab-20afeae9160f', 'أيّ مجموعةٍ كلّها أجسامٌ مُضاءة؟', '[{"id":"a","text":"الشمس، الشمعة، المصباح"},{"id":"b","text":"القمر، الكتاب، الجدار"},{"id":"c","text":"البرق، النار، النجوم"},{"id":"d","text":"المصباح، اليراعة، الشمس"}]'::jsonb, 'b', 'القمر والكتاب والجدار لا تنتج ضوءًا بل تعكس ضوء غيرها، فهي مُضاءة. باقي المجموعات تحتوي أجسامًا مضيئة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4aa3810e-14c6-5497-b826-369b10d47f03', '128a28b6-6910-5567-85ab-20afeae9160f', 'النجوم في السماء أجسامٌ:', '[{"id":"a","text":"مُضاءة بضوء القمر"},{"id":"b","text":"مُضاءة تعكس ضوء الأرض"},{"id":"c","text":"مضيئة تنتج ضوءها بنفسها"},{"id":"d","text":"مظلمة لا تُرى"}]'::jsonb, 'c', 'النجوم أجسامٌ مضيئة تنتج ضوءها بنفسها مثل الشمس، ولهذا نراها ليلًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b43efbb0-1c6e-5539-87ea-3bf62870170a', '128a28b6-6910-5567-85ab-20afeae9160f', 'في الصورة جسمٌ ينتج خطوطًا من الضوء نحو الخارج. ما نوع هذا الجسم؟ <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg"><circle cx="60" cy="60" r="26" fill="#fcd116" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="4" stroke-linecap="round"><line x1="60" y1="14" x2="60" y2="26"/><line x1="60" y1="94" x2="60" y2="106"/><line x1="14" y1="60" x2="26" y2="60"/><line x1="94" y1="60" x2="106" y2="60"/><line x1="27" y1="27" x2="35" y2="35"/><line x1="85" y1="85" x2="93" y2="93"/><line x1="85" y1="27" x2="93" y2="35"/><line x1="27" y1="85" x2="35" y2="93"/></g></svg>', '[{"id":"a","text":"جسمٌ مُضاء يعكس ضوء غيره"},{"id":"b","text":"جسمٌ مظلم لا ضوء فيه"},{"id":"c","text":"جسمٌ شفّاف يعبره الضوء"},{"id":"d","text":"جسمٌ مضيء ينتج الضوء بنفسه"}]'::jsonb, 'd', 'الجسم يُرسل خطوط ضوءٍ نحو الخارج، فهو جسمٌ مضيء ينتج الضوء بنفسه (مثل الشمس).', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fcbe6a96-97c0-5011-873d-c50a6726663c', '128a28b6-6910-5567-85ab-20afeae9160f', 'لماذا نحتاج إلى مصباحٍ لنقرأ كتابًا ليلًا في غرفةٍ مغلقة؟', '[{"id":"a","text":"لأنّ الكلمات مكتوبةٌ بحبرٍ مضيء"},{"id":"b","text":"لأنّ الكتاب جسمٌ مُضاء يحتاج إلى ضوءٍ يصله لنراه"},{"id":"c","text":"لأنّ الكتاب ينتج ضوءًا ضعيفًا"},{"id":"d","text":"لأنّ العين تنتج الضوء نهارًا فقط"}]'::jsonb, 'b', 'الكتاب جسمٌ مُضاء لا ينتج ضوءًا؛ يحتاج إلى ضوء المصباح يصله ليعكسه نحو العين فنقرأه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b3a88dee-8767-5d62-99f7-c33a4d7f9b7e', '128a28b6-6910-5567-85ab-20afeae9160f', 'أيّ زوجٍ صحيحٌ (جسم ← نوعه)؟', '[{"id":"a","text":"الشمس ← مضيئة"},{"id":"b","text":"المرآة ← مضيئة"},{"id":"c","text":"القمر ← مضيء"},{"id":"d","text":"المصباح المُشعَل ← مُضاء"}]'::jsonb, 'a', 'الشمس جسمٌ مضيء ينتج الضوء بنفسه. أمّا القمر والمرآة فمُضاءان، والمصباح المُشعَل مضيءٌ لا مُضاء.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9a75e8d5-f060-58b5-b6c5-66d61656731a', '12baa086-c007-5337-9ee0-2216e2ec7739', 'eveil-scientifique-5eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: سيّدُ النور', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('51bda941-ba48-51af-b02e-62780e10e9a4', '9a75e8d5-f060-58b5-b6c5-66d61656731a', 'أكمل التصنيف الصحيح:', '[{"id":"a","text":"مضيء طبيعيّ: الشمس — مضيء اصطناعيّ: المصباح — مُضاء: القمر"},{"id":"b","text":"مضيء طبيعيّ: المصباح — مُضاء: الشمس — مضيء اصطناعيّ: القمر"},{"id":"c","text":"مُضاء: الشمس — مضيء: القمر — اصطناعيّ: النجوم"},{"id":"d","text":"مضيء طبيعيّ: المرآة — مُضاء: المصباح — اصطناعيّ: الشمس"}]'::jsonb, 'a', 'الشمس مضيءٌ طبيعيّ، والمصباح مضيءٌ اصطناعيّ صنعه الإنسان، والقمر مُضاء يعكس الضوء. هذا هو التصنيف الصحيح الوحيد.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bb8511ab-38a8-5753-9eaa-f89563419605', '9a75e8d5-f060-58b5-b6c5-66d61656731a', 'رائد فضاءٍ على القمر ينظر إلى الأرض فيراها مضيئة. ما تفسير ذلك؟', '[{"id":"a","text":"الأرض نجمٌ ينتج ضوءه بنفسه"},{"id":"b","text":"الأرض جسمٌ مُضاء يعكس ضوء الشمس الواصل إليه"},{"id":"c","text":"الأرض تضيء بضوء القمر"},{"id":"d","text":"الأرض مظلمةٌ ولا يمكن رؤيتها"}]'::jsonb, 'b', 'الأرض مثل القمر جسمٌ مُضاء: تعكس ضوء الشمس الواصل إليها فتبدو مضيئة من الفضاء. الخطأ الشائع اعتبارها نجمًا منتجًا للضوء، والصحيح أنّها تعكس فقط.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2cbc1217-4d82-5d4a-be2c-3a3712f1f3df', '9a75e8d5-f060-58b5-b6c5-66d61656731a', 'نضع مرآةً مقابل المصباح المُشعَل في غرفةٍ مظلمة، فتلمع المرآة. هل المرآة جسمٌ مضيء؟', '[{"id":"a","text":"نعم، لأنّها لمعت فهي تنتج الضوء"},{"id":"b","text":"نعم، لأنّ كلّ جسمٍ يلمع مضيء"},{"id":"c","text":"لا، هي مُضاءة تعكس ضوء المصباح ولا تنتجه"},{"id":"d","text":"لا، لأنّ المرآة لا علاقة لها بالضوء"}]'::jsonb, 'c', 'المرآة جسمٌ مُضاء: تعكس ضوء المصباح فتلمع، لكنّها لا تنتج ضوءًا بنفسها. لو أطفأنا المصباح لانطفأ لمعانها. الفخّ الشائع الخلط بين اللمعان وإنتاج الضوء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6de28d54-680b-5b8b-a284-1d13742b92e9', '9a75e8d5-f060-58b5-b6c5-66d61656731a', 'تلميذٌ قال: «أرى في الظلام التامّ لأنّ عينيّ قويّتان.» أين الخطأ؟', '[{"id":"a","text":"الخطأ أنّ العين الضعيفة هي التي ترى في الظلام"},{"id":"b","text":"الخطأ أنّ الظلام يُنتج ضوءًا خاصًّا"},{"id":"c","text":"لا خطأ، فالعين القويّة ترى بلا ضوء"},{"id":"d","text":"الخطأ أنّ العين مهما كانت قويّة لا ترى بلا ضوءٍ يدخلها"}]'::jsonb, 'd', 'العين تستقبل الضوء ولا تنتجه؛ في الظلام التامّ لا ضوء يدخلها فلا رؤية مهما كانت قويّة. هذا هو الخطأ الشائع: ظنّ أنّ قوّة العين تُغني عن الضوء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8aa7e14d-c258-59b1-adef-56d20205d6ec', '9a75e8d5-f060-58b5-b6c5-66d61656731a', 'أيّ موقفٍ تكون فيه الرؤية ممكنة؟', '[{"id":"a","text":"غرفةٌ مضاءةٌ وعينٌ مغمضة"},{"id":"b","text":"غرفةٌ مضاءةٌ وعينٌ مفتوحةٌ سليمة"},{"id":"c","text":"ضوءٌ موجودٌ خلف جدارٍ معتمٍ وعينٌ مفتوحة"},{"id":"d","text":"غرفةٌ مظلمةٌ تمامًا وعينٌ مفتوحة"}]'::jsonb, 'b', 'الرؤية تحتاج اجتماع الضوء والعين السليمة المفتوحة معًا؛ هذا يتحقّق فقط في الغرفة المضاءة مع عينٍ مفتوحة. باقي الحالات يغيب فيها أحد الشرطين.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7fb217ca-1a1a-564b-8d47-5753611926f5', '9a75e8d5-f060-58b5-b6c5-66d61656731a', 'في الصورة جسمان مظلمان (1 و2) وجسمٌ مضيء (3) في الوسط. أيّ جسمٍ يمكن أن نراه حتّى لو أطفأنا كلّ المصابيح الأخرى؟ <svg viewBox="0 0 200 90" xmlns="http://www.w3.org/2000/svg"><rect x="15" y="30" width="34" height="34" rx="4" fill="#9ca3af" stroke="#1f2937" stroke-width="3"/><text x="28" y="52" font-size="14" fill="#1f2937">1</text><circle cx="100" cy="45" r="22" fill="#fcd116" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="3" stroke-linecap="round"><line x1="100" y1="12" x2="100" y2="21"/><line x1="100" y1="69" x2="100" y2="78"/><line x1="67" y1="45" x2="76" y2="45"/><line x1="124" y1="45" x2="133" y2="45"/></g><text x="94" y="50" font-size="13" fill="#1f2937">3</text><rect x="151" y="30" width="34" height="34" rx="4" fill="#9ca3af" stroke="#1f2937" stroke-width="3"/><text x="164" y="52" font-size="14" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"الجسم رقم 3 (المضيء)"},{"id":"b","text":"لا يمكن رؤية أيّ جسم"},{"id":"c","text":"الجسم رقم 1"},{"id":"d","text":"الجسم رقم 2"}]'::jsonb, 'a', 'الجسم رقم 3 مضيء ينتج ضوءه بنفسه، فنراه حتّى بعد إطفاء المصابيح. أمّا 1 و2 فمظلمان مُضاءان يحتاجان إلى ضوءٍ خارجيّ لرؤيتهما.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fadce1da-b5c1-5098-ae9d-d84df00e1fe0', '12baa086-c007-5337-9ee0-2216e2ec7739', 'eveil-scientifique-5eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملةٌ للضوء ومصادره', 3, 120, 30, 'boss', 'admin', 5)
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
  ('5a19eafe-5283-5a06-b673-691590c9ae4e', 'fadce1da-b5c1-5098-ae9d-d84df00e1fe0', 'أيّ تعريفٍ صحيحٌ للجسم المُضاء؟', '[{"id":"a","text":"جسمٌ يعكس ضوء غيره ولا ينتج ضوءًا بنفسه"},{"id":"b","text":"جسمٌ ينتج الضوء بنفسه"},{"id":"c","text":"جسمٌ ساخنٌ دائمًا"},{"id":"d","text":"جسمٌ يُسمع منه صوت"}]'::jsonb, 'a', 'الجسم المُضاء يعكس ضوء غيره ولا ينتج ضوءًا بنفسه، مثل القمر والكتاب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c238362-8cb2-58af-a1b7-c4e4a47d5485', 'fadce1da-b5c1-5098-ae9d-d84df00e1fe0', 'أيّ مجموعةٍ ترتّب الأجسام كلّها كمصادر طبيعيّة للضوء؟', '[{"id":"a","text":"المصباح، الشمعة، شاشة الحاسوب"},{"id":"b","text":"الشمس، البرق، النجوم"},{"id":"c","text":"الشمس، المصباح، الشمعة"},{"id":"d","text":"القمر، المرآة، الكتاب"}]'::jsonb, 'b', 'الشمس والبرق والنجوم مصادر طبيعيّة للضوء لم يصنعها الإنسان. المجموعتان (أ) و(ج) فيهما مصادر اصطناعيّة، و(د) أجسامٌ مُضاءة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5c514ee-77ae-5379-a23b-ed9652dfe523', 'fadce1da-b5c1-5098-ae9d-d84df00e1fe0', 'في يومٍ غائمٍ لا نرى الشمس، لكنّ النهار مضيء. لماذا؟', '[{"id":"a","text":"لأنّ الأرض مصدرٌ للضوء"},{"id":"b","text":"لأنّ الغيوم تنتج ضوءها بنفسها"},{"id":"c","text":"لأنّ ضوء الشمس يصل إلينا عبر الغيوم رغم حجبها لقرصها"},{"id":"d","text":"لأنّ القمر يضيء نهارًا"}]'::jsonb, 'c', 'الشمس مصدر الضوء؛ يصل ضوؤها إلينا عبر الغيوم فيبقى النهار مضيئًا حتّى لو حجبت الغيوم قرصها. الفخّ الشائع نسبة الضوء إلى الغيوم نفسها.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29d3149a-c816-5f03-aebd-79b0d9036274', 'fadce1da-b5c1-5098-ae9d-d84df00e1fe0', 'لماذا تبدو زجاجةٌ شفّافةٌ لامعةً عند وضعها قرب نافذةٍ مشمسة؟', '[{"id":"a","text":"لأنّ الزجاج يُسخّن فيضيء"},{"id":"b","text":"لأنّ الزجاج يبتلع كلّ الضوء"},{"id":"c","text":"لأنّها مصدرٌ مضيءٌ ينتج الضوء"},{"id":"d","text":"لأنّها تعكس وتمرّر ضوء الشمس الواصل إليها"}]'::jsonb, 'd', 'الزجاجة جسمٌ مُضاء: تعكس جزءًا من ضوء الشمس وتمرّر جزءًا، فتبدو لامعة. لا تنتج ضوءًا بنفسها؛ لو غاب ضوء الشمس لم تلمع.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('adac008a-b566-54ed-b8e4-255d4e102c11', 'fadce1da-b5c1-5098-ae9d-d84df00e1fe0', 'اختر العبارة الصحيحة عن الرؤية:', '[{"id":"a","text":"نرى الأجسام بلا حاجةٍ إلى ضوء"},{"id":"b","text":"نرى الأجسام عندما يصل ضوؤها إلى أعيننا"},{"id":"c","text":"نرى الأجسام بحاسّة السمع"},{"id":"d","text":"نرى الأجسام لأنّ أعيننا تُرسل ضوءًا إليها"}]'::jsonb, 'b', 'نرى الأجسام عندما يصل الضوء الآتي منها (مصدره مضيء) إلى أعيننا. العين تستقبل الضوء ولا تُرسله.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f4306a2-6b9f-5137-a506-db768048fbab', 'fadce1da-b5c1-5098-ae9d-d84df00e1fe0', 'أكمل سلسلة الرؤية بالترتيب الصحيح: مصدرٌ مضيء ← ............ ← العين.', '[{"id":"a","text":"ضوءٌ يصل من الجسم المُضاء إلى العين"},{"id":"b","text":"حرارةٌ تخرج من العين"},{"id":"c","text":"ظلٌّ يخرج من المصدر"},{"id":"d","text":"صوتٌ يصل من الجسم"}]'::jsonb, 'a', 'سلسلة الرؤية: مصدرٌ مضيء يُرسل ضوءًا ← يصل الجسم المُضاء فيعكسه ← يدخل الضوء العين فنرى. العنصر الناقص هو الضوء.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e3878a85-7fb3-52ba-97f7-4bd0f9cdfc35', 'e6444c30-5acd-50ea-b3e8-a419bc5fb1a9', 'eveil-scientifique-5eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('4515d410-0f84-53ab-a356-a3081dc261a8', 'e3878a85-7fb3-52ba-97f7-4bd0f9cdfc35', 'كيف ينتشر الضوء في الهواء؟', '[{"id":"a","text":"في خطوطٍ مستقيمة"},{"id":"b","text":"في خطوطٍ منحنية"},{"id":"c","text":"في دوائر"},{"id":"d","text":"في زوايا متعرّجة"}]'::jsonb, 'a', 'ينتشر الضوء في خطوطٍ مستقيمة في الوسط الواحد مثل الهواء، ولا ينحني من تلقاء نفسه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('396195d9-a998-55af-8cab-7404f959bbbd', 'e3878a85-7fb3-52ba-97f7-4bd0f9cdfc35', 'الجسم الذي يمرّ منه الضوء كلّه فنرى عبره بوضوح هو:', '[{"id":"a","text":"جسمٌ عاتم"},{"id":"b","text":"جسمٌ شافّ"},{"id":"c","text":"جسمٌ شفّاف"},{"id":"d","text":"جسمٌ مظلم"}]'::jsonb, 'c', 'الجسم الشفّاف يمرّ منه الضوء كلّه فنرى الأشياء خلفه بوضوح، مثل الزجاج النقيّ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b8f3cf9b-473d-57c9-b311-df357930bd17', 'e3878a85-7fb3-52ba-97f7-4bd0f9cdfc35', 'أيٌّ ممّا يلي جسمٌ عاتم؟', '[{"id":"a","text":"الماء الصافي"},{"id":"b","text":"الزجاج النقيّ"},{"id":"c","text":"الهواء"},{"id":"d","text":"الجدار"}]'::jsonb, 'd', 'الجدار جسمٌ عاتم يحجب الضوء كلّه فلا نرى عبره. أمّا الماء الصافي والزجاج النقيّ والهواء فأجسامٌ شفّافة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2701546d-2919-5d60-bd63-38d717229725', 'e3878a85-7fb3-52ba-97f7-4bd0f9cdfc35', 'الزجاج المثلّج (في باب الحمّام) نرى عبره ضوءًا دون تفاصيل. ما نوعه؟', '[{"id":"a","text":"شفّاف"},{"id":"b","text":"عاتم"},{"id":"c","text":"شافّ (نصف شفّاف)"},{"id":"d","text":"مضيء"}]'::jsonb, 'c', 'الزجاج المثلّج جسمٌ شافّ (نصف شفّاف): يمرّ بعض الضوء فنرى نورًا دون تمييز التفاصيل.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c8280b8c-5dfe-5e5b-9518-edb66d86ff5f', 'e3878a85-7fb3-52ba-97f7-4bd0f9cdfc35', 'في الصورة شعاعٌ خرج من المصباح. كيف يسير؟ <svg viewBox="0 0 200 70" xmlns="http://www.w3.org/2000/svg"><circle cx="30" cy="35" r="16" fill="#fcd116" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="3" stroke-linecap="round"><line x1="30" y1="13" x2="30" y2="19"/><line x1="30" y1="51" x2="30" y2="57"/><line x1="8" y1="35" x2="14" y2="35"/></g><line x1="48" y1="35" x2="176" y2="35" stroke="#ef4444" stroke-width="3"/><polygon points="176,35 166,30 166,40" fill="#ef4444" stroke="#1f2937" stroke-width="1"/></svg>', '[{"id":"a","text":"في خطٍّ مستقيم"},{"id":"b","text":"في خطٍّ منحنٍ إلى أعلى"},{"id":"c","text":"في دائرة"},{"id":"d","text":"في خطٍّ متعرّج"}]'::jsonb, 'a', 'السهم الأحمر يبيّن أنّ الشعاع الضوئيّ يسير في خطٍّ مستقيمٍ من المصباح، وهذا هو الانتشار المستقيميّ للضوء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e95d69ec-3c50-5a6e-b177-1f4eb3f16065', 'e6444c30-5acd-50ea-b3e8-a419bc5fb1a9', 'eveil-scientifique-5eme', '⭐ تمرين: شفّافٌ، شافٌّ أم عاتم؟', 1, 50, 10, 'practice', 'admin', 1)
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
  ('101c3a9b-93fb-577d-9e53-8693df6dfbed', 'e95d69ec-3c50-5a6e-b177-1f4eb3f16065', 'الماء الصافي في كأسٍ زجاجيّة جسمٌ:', '[{"id":"a","text":"شفّاف"},{"id":"b","text":"عاتم"},{"id":"c","text":"مظلم"},{"id":"d","text":"مضيء"}]'::jsonb, 'a', 'الماء الصافي يمرّ منه الضوء كلّه فنرى عبره بوضوح، فهو جسمٌ شفّاف.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7ef4465a-5d55-5e8a-aa96-72412e257bac', 'e95d69ec-3c50-5a6e-b177-1f4eb3f16065', 'لوحٌ خشبيٌّ سميك جسمٌ:', '[{"id":"a","text":"شفّاف"},{"id":"b","text":"عاتم"},{"id":"c","text":"شافّ"},{"id":"d","text":"مضيء"}]'::jsonb, 'b', 'اللوح الخشبيّ يحجب الضوء كلّه فلا نرى عبره، فهو جسمٌ عاتم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3360e64f-733a-58cf-aa85-b45fd736c140', 'e95d69ec-3c50-5a6e-b177-1f4eb3f16065', 'ينتشر الضوء في الهواء في خطوط:', '[{"id":"a","text":"منحنية"},{"id":"b","text":"متعرّجة"},{"id":"c","text":"مستقيمة"},{"id":"d","text":"دائريّة"}]'::jsonb, 'c', 'ينتشر الضوء في الوسط الواحد في خطوطٍ مستقيمة؛ هذا هو الانتشار المستقيميّ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c76e4dbe-e7d6-5e49-bc9b-ca1865982ce6', 'e95d69ec-3c50-5a6e-b177-1f4eb3f16065', 'ورقةٌ بيضاء رقيقة نرى عبرها ضوءًا دون تفاصيل. هي جسمٌ:', '[{"id":"a","text":"مضيء"},{"id":"b","text":"عاتم"},{"id":"c","text":"شفّاف"},{"id":"d","text":"شافّ (نصف شفّاف)"}]'::jsonb, 'd', 'الورقة الرقيقة تمرّر بعض الضوء وتحجب البعض، فنرى نورًا دون تفاصيل، فهي جسمٌ شافّ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a0e51942-6704-5ec6-9d1a-bc60e91460f5', 'e95d69ec-3c50-5a6e-b177-1f4eb3f16065', 'أيٌّ ممّا يلي جسمٌ شفّاف؟', '[{"id":"a","text":"صفيحةٌ معدنيّة"},{"id":"b","text":"زجاج النافذة النقيّ"},{"id":"c","text":"كتابٌ مغلق"},{"id":"d","text":"بابٌ خشبيّ"}]'::jsonb, 'b', 'زجاج النافذة النقيّ يمرّ منه الضوء كلّه فنرى الشارع بوضوح، فهو شفّاف. الباقي أجسامٌ عاتمة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f5a70d33-85f6-506b-9e72-134269130a62', 'e95d69ec-3c50-5a6e-b177-1f4eb3f16065', 'الجسم الذي يصنع ظلًّا لأنّه يحجب الضوء كلّه هو الجسم:', '[{"id":"a","text":"العاتم"},{"id":"b","text":"المضيء"},{"id":"c","text":"الشفّاف"},{"id":"d","text":"الشافّ"}]'::jsonb, 'a', 'الجسم العاتم يحجب الضوء كلّه فيمنعه من المرور، فيصنع ظلًّا خلفه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9a325752-057c-5858-a3a5-495d9fa46241', 'e6444c30-5acd-50ea-b3e8-a419bc5fb1a9', 'eveil-scientifique-5eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّدُ الانتشار', 3, 120, 30, 'boss', 'admin', 2)
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
  ('fa19b2f0-9525-575b-a93a-856a577ca1c8', '9a325752-057c-5858-a3a5-495d9fa46241', 'أيّ مجموعةٍ كلّها أجسامٌ شفّافة؟', '[{"id":"a","text":"الزجاج النقيّ، الماء الصافي، الهواء"},{"id":"b","text":"الخشب، الجدار، المعدن"},{"id":"c","text":"الزجاج المثلّج، الورق الرقيق، البلّور"},{"id":"d","text":"الكتاب، الباب، الحجر"}]'::jsonb, 'a', 'الزجاج النقيّ والماء الصافي والهواء تمرّر الضوء كلّه فنرى عبرها بوضوح، فهي شفّافة. (ب) و(د) عاتمة، و(ج) شافّة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('35757184-b656-5cb6-80fa-f0433a64b25c', '9a325752-057c-5858-a3a5-495d9fa46241', 'نصفّ ثلاث بطاقاتٍ مثقوبة، فلا نرى المصباح من الثقوب إلّا إذا كانت على خطٍّ مستقيمٍ واحد. ماذا يثبت هذا؟', '[{"id":"a","text":"أنّ الضوء ينحني ليمرّ من أيّ ثقب"},{"id":"b","text":"أنّ الضوء ينتشر في خطٍّ مستقيم فلا يصل إلّا إذا اصطفّت الثقوب"},{"id":"c","text":"أنّ البطاقات شفّافة"},{"id":"d","text":"أنّ المصباح مُضاء"}]'::jsonb, 'b', 'لو انحنى الضوء لمرّ من ثقوبٍ غير مصطفّة، لكنّه لا يصل العين إلّا حين تصطفّ الثقوب على خطٍّ مستقيم؛ فهذا يثبت الانتشار المستقيميّ. الخطأ الشائع توهّم أنّ الضوء ينحني.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9921c8fb-2724-53c0-8422-09acafda27cc', '9a325752-057c-5858-a3a5-495d9fa46241', 'نضع زجاجًا مثلّجًا بين مصباحٍ والعين. ماذا نرى؟', '[{"id":"a","text":"نرى المصباح وتفاصيله بوضوحٍ تامّ"},{"id":"b","text":"لا نرى أيّ ضوءٍ إطلاقًا"},{"id":"c","text":"نرى ضوءًا منتشرًا دون تمييز شكل المصباح"},{"id":"d","text":"نرى ظلًّا أسود فقط"}]'::jsonb, 'c', 'الزجاج المثلّج جسمٌ شافّ: يمرّر بعض الضوء ويبعثره، فنرى ضوءًا دون تمييز شكل المصباح. الفخّ الشائع اعتباره شفّافًا (نرى التفاصيل) أو عاتمًا (لا ضوء).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8b30c628-a37f-5937-91df-1e7bc40b8839', '9a325752-057c-5858-a3a5-495d9fa46241', 'لماذا لا نرى ما خلف بابٍ خشبيٍّ مغلق رغم وجود ضوءٍ في الغرفة الأخرى؟', '[{"id":"a","text":"لأنّ الباب جسمٌ شفّاف"},{"id":"b","text":"لأنّ الضوء ينحني حول الباب"},{"id":"c","text":"لأنّ العين لا تعمل قرب الأبواب"},{"id":"d","text":"لأنّ الباب جسمٌ عاتم يحجب الضوء كلّه"}]'::jsonb, 'd', 'الباب الخشبيّ جسمٌ عاتم يمنع مرور الضوء كلّه، فلا يصلنا ضوء الغرفة الأخرى ولا نرى ما خلفه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ac203eeb-14b4-517f-ad1b-3b0a1b24e153', '9a325752-057c-5858-a3a5-495d9fa46241', 'رتّب الأجسام من الأكثر تمريرًا للضوء إلى الأقلّ:', '[{"id":"a","text":"لوح خشبيّ ← زجاج مثلّج ← زجاج نقيّ"},{"id":"b","text":"زجاج نقيّ ← زجاج مثلّج ← لوح خشبيّ"},{"id":"c","text":"لوح خشبيّ ← زجاج نقيّ ← زجاج مثلّج"},{"id":"d","text":"زجاج مثلّج ← لوح خشبيّ ← زجاج نقيّ"}]'::jsonb, 'b', 'الزجاج النقيّ شفّاف (يمرّ كلّ الضوء)، فالزجاج المثلّج شافّ (يمرّ بعضه)، فاللوح الخشبيّ عاتم (لا يمرّ شيء). هذا هو الترتيب الصحيح.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7462c830-ebaa-5bcc-ac7f-4fbabaa83e55', '9a325752-057c-5858-a3a5-495d9fa46241', 'في الصورة شعاعٌ يخرج من المصباح ويسقط على لوحٍ عاتم. ماذا يحدث للضوء عند اللوح؟ <svg viewBox="0 0 200 80" xmlns="http://www.w3.org/2000/svg"><circle cx="26" cy="40" r="14" fill="#fcd116" stroke="#1f2937" stroke-width="3"/><line x1="42" y1="40" x2="120" y2="40" stroke="#ef4444" stroke-width="3"/><polygon points="120,40 110,35 110,45" fill="#ef4444" stroke="#1f2937" stroke-width="1"/><rect x="128" y="10" width="16" height="60" fill="#92400e" stroke="#1f2937" stroke-width="3"/><rect x="148" y="14" width="44" height="52" fill="#6b7280" stroke="#1f2937" stroke-width="2" stroke-dasharray="4 3"/></svg>', '[{"id":"a","text":"يحجبه اللوح العاتم فيتكوّن ظلٌّ خلفه"},{"id":"b","text":"ينحني فوق اللوح"},{"id":"c","text":"يتحوّل إلى صوت"},{"id":"d","text":"يمرّ عبر اللوح فيضيء خلفه"}]'::jsonb, 'a', 'اللوح العاتم يحجب الضوء فلا يمرّ منه شيء، فتتكوّن منطقةٌ مظلمة (ظلّ) خلفه، وهي المنطقة المنقّطة في الصورة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ff960339-4558-5c3d-88d4-4b68135c7885', 'e6444c30-5acd-50ea-b3e8-a419bc5fb1a9', 'eveil-scientifique-5eme', '⭐⭐ تمرين مراجعة (نمط امتحان): نفاذُ الضوء', 2, 75, 15, 'practice', 'admin', 3)
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
  ('24be6026-7e23-5bf2-a285-7116dc6b88d8', 'ff960339-4558-5c3d-88d4-4b68135c7885', 'نسمّي الخطّ المستقيم الذي يسلكه الضوء:', '[{"id":"a","text":"شعاعًا ضوئيًّا"},{"id":"b","text":"ظلًّا"},{"id":"c","text":"وسطًا عاتمًا"},{"id":"d","text":"انعكاسًا"}]'::jsonb, 'a', 'الشعاع الضوئيّ هو الخطّ المستقيم الذي يسلكه الضوء، ونرسمه بسهمٍ يبيّن جهته.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cc049fe1-f473-5ddf-91e2-5fa7bfd93bbc', 'ff960339-4558-5c3d-88d4-4b68135c7885', 'أيّ زوجٍ صحيحٌ (جسم ← نوعه)؟', '[{"id":"a","text":"الجدار ← شفّاف"},{"id":"b","text":"الهواء ← شفّاف"},{"id":"c","text":"المعدن ← شافّ"},{"id":"d","text":"الزجاج النقيّ ← عاتم"}]'::jsonb, 'b', 'الهواء جسمٌ شفّاف يمرّ منه الضوء كلّه فنرى عبره. الأزواج الأخرى خاطئة: الزجاج النقيّ شفّاف، والجدار والمعدن عاتمان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9e58f4f9-af6f-5b3c-861b-66379eb75138', 'ff960339-4558-5c3d-88d4-4b68135c7885', 'لماذا نضع زجاجًا شفّافًا في النوافذ بدل لوحٍ خشبيّ؟', '[{"id":"a","text":"لأنّ الزجاج ينتج الضوء"},{"id":"b","text":"لأنّ الخشب شفّاف أكثر"},{"id":"c","text":"ليمرّ الضوء فنرى الخارج وتُضاء الغرفة"},{"id":"d","text":"ليحجب الضوء كلّه"}]'::jsonb, 'c', 'الزجاج الشفّاف يمرّر الضوء فتُضاء الغرفة ونرى الخارج، بينما اللوح الخشبيّ عاتمٌ يحجب الضوء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84a9c665-ee19-558c-8772-a9b07266c8a4', 'ff960339-4558-5c3d-88d4-4b68135c7885', 'في يومٍ مشمس نرى حزمة الضوء الداخلة من النافذة مستقيمة في الغبار. ماذا يثبت هذا؟', '[{"id":"a","text":"أنّ الضوء ينحني في الغبار"},{"id":"b","text":"أنّ الغبار مصدرٌ للضوء"},{"id":"c","text":"أنّ النافذة عاتمة"},{"id":"d","text":"أنّ الضوء ينتشر في خطٍّ مستقيم"}]'::jsonb, 'd', 'ظهور حزمة الضوء كخطٍّ مستقيمٍ في الغبار يثبت أنّ الضوء ينتشر في خطوطٍ مستقيمة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1d088b2f-9f71-56f7-bacd-401b77a25c77', 'ff960339-4558-5c3d-88d4-4b68135c7885', 'أيٌّ ممّا يلي جسمٌ شافٌّ (نصف شفّاف)؟', '[{"id":"a","text":"جدارٌ إسمنتيّ"},{"id":"b","text":"ورق الكلك (الورق الشفّاف الرقيق) المُغبَّش"},{"id":"c","text":"صفيحةٌ حديديّة"},{"id":"d","text":"ماءٌ صافٍ"}]'::jsonb, 'b', 'ورق الكلك المُغبَّش يمرّر بعض الضوء دون التفاصيل، فهو شافّ. الصفيحة والجدار عاتمان، والماء الصافي شفّاف.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c40afccc-35a9-5889-9280-2d204f61ea09', 'ff960339-4558-5c3d-88d4-4b68135c7885', 'في الصورة جسمان: نرى عبر الأوّل بوضوح ولا نرى عبر الثاني شيئًا. ما نوعاهما؟ <svg viewBox="0 0 200 80" xmlns="http://www.w3.org/2000/svg"><rect x="20" y="16" width="60" height="48" fill="#bae6fd" stroke="#1f2937" stroke-width="3"/><circle cx="50" cy="40" r="10" fill="#22c55e" stroke="#1f2937" stroke-width="2"/><text x="44" y="75" font-size="12" fill="#1f2937">1</text><rect x="120" y="16" width="60" height="48" fill="#78350f" stroke="#1f2937" stroke-width="3"/><text x="146" y="75" font-size="12" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"1 شفّاف، 2 عاتم"},{"id":"b","text":"1 عاتم، 2 شفّاف"},{"id":"c","text":"كلاهما شفّاف"},{"id":"d","text":"كلاهما عاتم"}]'::jsonb, 'a', 'نرى الدائرة الخضراء خلف الجسم 1 فهو شفّاف، ولا نرى شيئًا خلف الجسم 2 فهو عاتم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('c39dbf02-888b-50f7-9721-7cde3f815bab', 'e6444c30-5acd-50ea-b3e8-a419bc5fb1a9', 'eveil-scientifique-5eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: عبقريُّ الضوء', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('d24433a4-a599-5ca0-a550-ada39c10e986', 'c39dbf02-888b-50f7-9721-7cde3f815bab', 'أيّ ترتيبٍ صحيحٌ للأجسام الثلاثة حسب نفاذ الضوء (من الأكثر إلى الأقلّ)؟', '[{"id":"a","text":"شفّاف ← شافّ ← عاتم"},{"id":"b","text":"عاتم ← شفّاف ← شافّ"},{"id":"c","text":"شافّ ← عاتم ← شفّاف"},{"id":"d","text":"عاتم ← شافّ ← شفّاف"}]'::jsonb, 'a', 'الشفّاف يمرّر كلّ الضوء، فالشافّ يمرّر بعضه، فالعاتم لا يمرّر شيئًا؛ فالترتيب من الأكثر إلى الأقلّ: شفّاف ← شافّ ← عاتم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9c7d3212-8584-5a5c-843a-bcb490adadd8', 'c39dbf02-888b-50f7-9721-7cde3f815bab', 'نريد صنع شاشةٍ تمرّر ضوءًا لطيفًا للقراءة دون أن نرى ما خلفها. أيّ مادّةٍ نختار؟', '[{"id":"a","text":"زجاجٌ نقيٌّ شفّاف"},{"id":"b","text":"لوحٌ خشبيٌّ عاتم"},{"id":"c","text":"زجاجٌ مثلّجٌ شافّ"},{"id":"d","text":"صفيحةٌ معدنيّة عاتمة"}]'::jsonb, 'c', 'الزجاج المثلّج شافّ: يمرّر ضوءًا لطيفًا منتشرًا ويحجب التفاصيل، فلا نرى ما خلفه. الشفّاف يكشف ما خلفه، والعاتم يحجب كلّ الضوء فلا إضاءة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('50f0bd05-67d9-52c6-91a4-1d3d067545f6', 'c39dbf02-888b-50f7-9721-7cde3f815bab', 'وضع تلميذٌ يده فوق مصباحٍ يدويّ مشتعلٍ في الظلام فظهرت أصابعه حمراء قليلًا عند الحوافّ. ما تفسير ذلك؟', '[{"id":"a","text":"اليد جسمٌ شفّاف يمرّر الضوء كلّه"},{"id":"b","text":"اليد عاتمةٌ في معظمها، لكنّ حوافّ الأصابع الرقيقة تمرّر قليلًا من الضوء (شبه شافّة)"},{"id":"c","text":"اليد تنتج ضوءًا أحمر"},{"id":"d","text":"الضوء انحنى داخل اليد"}]'::jsonb, 'b', 'اليد عاتمةٌ في معظمها فتصنع ظلًّا، لكنّ الأطراف الرقيقة جدًّا للأصابع تمرّر قليلًا من الضوء فتبدو حمراء، أي تتصرّف كجسمٍ شبه شافّ. الخطأ الشائع توهّم أنّ اليد تنتج الضوء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7ee0a9e-0ed0-58e8-a1bf-6c475f719546', 'c39dbf02-888b-50f7-9721-7cde3f815bab', 'لماذا يجب أن تكون الثقوب الثلاثة على خطٍّ مستقيمٍ واحد لنرى المصباح عبرها؟', '[{"id":"a","text":"لأنّ الضوء ينتشر مستقيمًا فلا يمرّ من ثقوبٍ غير مصطفّة"},{"id":"b","text":"لأنّ الضوء ينحني عند كلّ ثقب"},{"id":"c","text":"لأنّ البطاقات شفّافة"},{"id":"d","text":"لأنّ العين تُطلق شعاعًا منحنيًا"}]'::jsonb, 'a', 'الضوء يسير في خطٍّ مستقيم؛ فلا يجد طريقًا عبر الثقوب إلّا إذا اصطفّت على خطٍّ واحد. لو انحنى لمرّ من ثقوبٍ غير مصطفّة. هذا هو دليل الانتشار المستقيميّ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5be1eb46-83a5-5ca8-8d56-6f70e21e1d4c', 'c39dbf02-888b-50f7-9721-7cde3f815bab', 'نهارًا نرى داخل سيّارةٍ نوافذها زجاجٌ شفّاف، لكنّ بعض السيّارات نوافذها مُعتّمة لا نرى داخلها. ما الفرق؟', '[{"id":"a","text":"الزجاج المُعتّم صار مصدرًا للضوء"},{"id":"b","text":"الزجاج الشفّاف يمرّر الضوء فنرى الداخل، والمُعتّم يمرّر القليل فيصعب رؤية الداخل"},{"id":"c","text":"الزجاج الشفّاف عاتمٌ تمامًا"},{"id":"d","text":"لا فرق بين الزجاجين"}]'::jsonb, 'b', 'الزجاج الشفّاف يمرّر الضوء فنرى داخل السيّارة، أمّا الزجاج المُعتّم فيمرّر القليل (أقرب إلى الشافّ) فيصعب تمييز الداخل. الفرق في كميّة الضوء النافذ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fe355a0e-6d10-5336-a3ab-f802325f51b2', 'c39dbf02-888b-50f7-9721-7cde3f815bab', 'في الصورة مصباحٌ وأمامه ثلاثة ألواح: أحدها يمرّر كلّ الضوء، وآخر بعضه، وآخر لا شيء. أيّ لوحٍ يصنع أغمق ظلّ؟ <svg viewBox="0 0 210 80" xmlns="http://www.w3.org/2000/svg"><circle cx="22" cy="40" r="13" fill="#fcd116" stroke="#1f2937" stroke-width="3"/><rect x="55" y="16" width="26" height="48" fill="#bae6fd" stroke="#1f2937" stroke-width="2"/><text x="63" y="75" font-size="12" fill="#1f2937">1</text><rect x="105" y="16" width="26" height="48" fill="#cbd5e1" stroke="#1f2937" stroke-width="2" stroke-dasharray="3 2"/><text x="113" y="75" font-size="12" fill="#1f2937">2</text><rect x="155" y="16" width="26" height="48" fill="#1f2937" stroke="#1f2937" stroke-width="2"/><text x="163" y="75" font-size="12" fill="#1f2937">3</text></svg>', '[{"id":"a","text":"اللوح 1 (الشفّاف)"},{"id":"b","text":"اللوح 2 (الشافّ)"},{"id":"c","text":"كلّها تصنع ظلًّا واحدًا"},{"id":"d","text":"اللوح 3 (العاتم)"}]'::jsonb, 'd', 'اللوح 3 العاتم (الأسود) يحجب الضوء كلّه فيصنع أغمق ظلّ. اللوح 1 الشفّاف لا يصنع ظلًّا تقريبًا، واللوح 2 الشافّ يصنع ظلًّا خفيفًا.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('da092241-f24c-5827-95a0-dc6944090ae4', 'e6444c30-5acd-50ea-b3e8-a419bc5fb1a9', 'eveil-scientifique-5eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملةٌ لانتشار الضوء', 3, 120, 30, 'boss', 'admin', 5)
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
  ('0b4785e6-e429-5958-a825-305fe0fef811', 'da092241-f24c-5827-95a0-dc6944090ae4', 'خاصيّة انتشار الضوء في خطوطٍ مستقيمة تُسمّى:', '[{"id":"a","text":"الانتشار المستقيميّ للضوء"},{"id":"b","text":"انعكاس الضوء"},{"id":"c","text":"نفاذيّة الجسم"},{"id":"d","text":"عتامة الجسم"}]'::jsonb, 'a', 'انتشار الضوء في خطوطٍ مستقيمة في الوسط الواحد يُسمّى الانتشار المستقيميّ للضوء.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f2c552a-24bf-55dd-ba66-00c5faf82cc8', 'da092241-f24c-5827-95a0-dc6944090ae4', 'أيّ مجموعةٍ ترتّب الأجسام الثلاثة بالنوع الصحيح؟', '[{"id":"a","text":"الزجاج النقيّ: شافّ — الورق الرقيق: عاتم — الخشب: شفّاف"},{"id":"b","text":"الزجاج النقيّ: شفّاف — الورق الرقيق: شافّ — الخشب: عاتم"},{"id":"c","text":"الزجاج النقيّ: عاتم — الورق الرقيق: شفّاف — الخشب: شافّ"},{"id":"d","text":"الزجاج النقيّ: شفّاف — الورق الرقيق: عاتم — الخشب: شافّ"}]'::jsonb, 'b', 'الزجاج النقيّ شفّاف (يمرّ كلّ الضوء)، الورق الرقيق شافّ (يمرّ بعضه)، الخشب عاتم (لا يمرّ شيء). هذا هو التصنيف الصحيح.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d70266a4-f360-5b38-8a5e-425392d68fc0', 'da092241-f24c-5827-95a0-dc6944090ae4', 'نضع كأسًا من الماء الصافي فوق صورةٍ ملوّنة فنراها عبر الماء. هذا يدلّ على أنّ الماء الصافي:', '[{"id":"a","text":"شافٌّ يحجب التفاصيل"},{"id":"b","text":"عاتمٌ يحجب الضوء"},{"id":"c","text":"شفّافٌ يمرّر الضوء فنرى ما خلفه"},{"id":"d","text":"مصدرٌ مضيءٌ للضوء"}]'::jsonb, 'c', 'رؤية الصورة بوضوحٍ عبر الماء تدلّ على أنّ الماء الصافي شفّاف يمرّر الضوء كلّه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('abb31600-ee20-5438-b3eb-a53389fb0b3a', 'da092241-f24c-5827-95a0-dc6944090ae4', 'تلميذٌ قال: «الضوء ينحني حول الجدار فنرى ما خلفه.» أين الخطأ؟', '[{"id":"a","text":"الخطأ أنّ الجدار شفّاف"},{"id":"b","text":"الخطأ أنّ العين تُطلق الضوء"},{"id":"c","text":"لا خطأ، فالضوء ينحني فعلًا حول الأجسام"},{"id":"d","text":"الخطأ أنّ الضوء يسير مستقيمًا فلا ينحني حول الجدار، لذلك يتكوّن ظلٌّ خلفه"}]'::jsonb, 'd', 'الضوء ينتشر مستقيمًا ولا ينحني حول الجدار العاتم، فيتكوّن ظلٌّ خلفه ولا نرى ما وراءه. هذا هو الخطأ الشائع: ظنّ أنّ الضوء ينحني.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1be95d3e-34fd-5a81-95f6-039aa8814d61', 'da092241-f24c-5827-95a0-dc6944090ae4', 'لماذا تُصنع زجاجات النوافذ في الحمّامات من زجاجٍ مثلّجٍ شافّ بدل الشفّاف؟', '[{"id":"a","text":"لأنّ الشافّ أرخص دائمًا"},{"id":"b","text":"ليمرّ الضوء فتُضاء الغرفة دون أن يُرى ما بالداخل"},{"id":"c","text":"ليحجب كلّ الضوء فتبقى الغرفة مظلمة"},{"id":"d","text":"لأنّ الزجاج المثلّج ينتج الضوء"}]'::jsonb, 'b', 'الزجاج المثلّج الشافّ يمرّر الضوء فتُضاء الغرفة، لكنّه يحجب التفاصيل فلا يُرى الداخل؛ وهذا هو المطلوب في الحمّام.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8ddc8e4a-669a-5714-ab0f-598437fc95ba', 'da092241-f24c-5827-95a0-dc6944090ae4', 'أكمل سلسلة تكوّن الظلّ بالترتيب الصحيح:', '[{"id":"a","text":"مصدرٌ مضيء ← جسمٌ عاتم يحجب الضوء ← ظلٌّ على الشاشة"},{"id":"b","text":"جسمٌ شفّاف ← مصدرٌ مضيء ← لا ظلّ"},{"id":"c","text":"عينٌ تُطلق ضوءًا ← جسمٌ ← ظلّ"},{"id":"d","text":"صوتٌ ← جسمٌ ← ظلّ"}]'::jsonb, 'a', 'يتكوّن الظلّ هكذا: مصدرٌ مضيء يُرسل ضوءًا ← يعترضه جسمٌ عاتم يحجب الضوء ← تظهر منطقةٌ مظلمة (ظلّ) على الشاشة خلفه.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('24d0cc73-4af1-59f3-9e6b-56f457bf0aba', '4b11c4b9-1114-53e1-a9bf-9a61bb490f91', 'eveil-scientifique-5eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('04a7c3ae-513a-544a-adb1-ac07fca90dd2', '24d0cc73-4af1-59f3-9e6b-56f457bf0aba', 'ما العناصر الثلاثة اللازمة لتكوّن الظلّ؟', '[{"id":"a","text":"مصدرٌ مضيء + جسمٌ عاتم + شاشة"},{"id":"b","text":"ماء + هواء + تراب"},{"id":"c","text":"صوت + أذن + هواء"},{"id":"d","text":"ثلاثة مصابيح"}]'::jsonb, 'a', 'يتكوّن الظلّ عند اجتماع مصدرٍ مضيء وجسمٍ عاتم يحجب الضوء وشاشةٍ يظهر عليها الظلّ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9b3cc3fc-56de-5b27-a630-d71aad736e32', '24d0cc73-4af1-59f3-9e6b-56f457bf0aba', 'لماذا يتكوّن ظلٌّ خلف الجسم العاتم؟', '[{"id":"a","text":"لأنّ الضوء ينحني حوله"},{"id":"b","text":"لأنّ الضوء يسير مستقيمًا فيحجبه الجسم"},{"id":"c","text":"لأنّ الجسم ينتج ظلامًا"},{"id":"d","text":"لأنّ الجسم شفّاف"}]'::jsonb, 'b', 'الضوء يسير مستقيمًا، فيحجبه الجسم العاتم ولا يلتفّ حوله، فتظهر منطقةٌ مظلمة خلفه هي الظلّ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('386a1d60-2c1b-5045-b72d-022c300cfad6', '24d0cc73-4af1-59f3-9e6b-56f457bf0aba', 'متى يحدث كسوف الشمس؟', '[{"id":"a","text":"عندما تقف الأرض بين الشمس والقمر"},{"id":"b","text":"عندما تختفي الشمس ليلًا"},{"id":"c","text":"عندما يقف القمر بين الشمس والأرض"},{"id":"d","text":"عندما يكبر القمر"}]'::jsonb, 'c', 'كسوف الشمس يحدث نهارًا عندما يقف القمر بين الشمس والأرض فيحجب ضوءها (الشمس ← القمر ← الأرض).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f2db04c4-0e3d-5ec0-9e9d-5f44b52040c2', '24d0cc73-4af1-59f3-9e6b-56f457bf0aba', 'ماذا يكبر ظلّ يدك على الجدار؟', '[{"id":"a","text":"عندما نطفئ المصباح"},{"id":"b","text":"عندما نغلق العينين"},{"id":"c","text":"عندما نبعد اليد عن المصباح"},{"id":"d","text":"عندما نقرّب اليد من المصباح"}]'::jsonb, 'd', 'كلّما اقترب الجسم العاتم من المصدر المضيء كبر ظلّه؛ فتقريب اليد من المصباح يكبّر ظلّها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('84bbab41-e2b2-5186-a2c3-3748c6b31db7', '24d0cc73-4af1-59f3-9e6b-56f457bf0aba', 'في الصورة ترتيبٌ للأجرام أثناء ظاهرة. أيّ ظاهرةٍ هذه؟ <svg viewBox="0 0 220 70" xmlns="http://www.w3.org/2000/svg"><circle cx="30" cy="35" r="20" fill="#fcd116" stroke="#1f2937" stroke-width="3"/><text x="16" y="63" font-size="11" fill="#1f2937">الشمس</text><circle cx="110" cy="35" r="9" fill="#9ca3af" stroke="#1f2937" stroke-width="3"/><text x="98" y="63" font-size="11" fill="#1f2937">القمر</text><circle cx="185" cy="35" r="15" fill="#3b82f6" stroke="#1f2937" stroke-width="3"/><text x="170" y="63" font-size="11" fill="#1f2937">الأرض</text></svg>', '[{"id":"a","text":"خسوف القمر"},{"id":"b","text":"كسوف الشمس"},{"id":"c","text":"النهار العاديّ"},{"id":"d","text":"اكتمال القمر"}]'::jsonb, 'b', 'الترتيب الشمس ← القمر ← الأرض، أي القمر في الوسط يحجب ضوء الشمس عن الأرض، وهذا كسوف الشمس.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7cebecfb-8502-5b65-a1bc-a36864376f4d', '4b11c4b9-1114-53e1-a9bf-9a61bb490f91', 'eveil-scientifique-5eme', '⭐ تمرين: أتعرّف على الظلّ', 1, 50, 10, 'practice', 'admin', 1)
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
  ('6056726b-e6d4-5fd1-88a8-9fded6fa2bdb', '7cebecfb-8502-5b65-a1bc-a36864376f4d', 'الجسم الذي يصنع ظلًّا لأنّه يحجب الضوء هو جسمٌ:', '[{"id":"a","text":"عاتم"},{"id":"b","text":"مضيء"},{"id":"c","text":"شافّ"},{"id":"d","text":"شفّاف"}]'::jsonb, 'a', 'الجسم العاتم يحجب الضوء فيمنع مروره، فيتكوّن ظلٌّ خلفه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fa761468-5a3f-5406-be2f-67ea52c85b7b', '7cebecfb-8502-5b65-a1bc-a36864376f4d', 'ظلّي يظهر على الأرض تحت الشمس لأنّ:', '[{"id":"a","text":"الشمس عاتمة"},{"id":"b","text":"جسمي يحجب ضوء الشمس فيتكوّن ظلٌّ خلفي"},{"id":"c","text":"جسمي ينتج ظلامًا"},{"id":"d","text":"الأرض مضيئة"}]'::jsonb, 'b', 'جسمي جسمٌ عاتمٌ يحجب ضوء الشمس، فتتكوّن منطقةٌ مظلمة خلفي على الأرض هي ظلّي.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('937868cf-0085-5d8f-8c3f-9696b8ded874', '7cebecfb-8502-5b65-a1bc-a36864376f4d', 'أيّ عنصرٍ ليس لازمًا لتكوّن الظلّ؟', '[{"id":"a","text":"جسمٌ عاتم"},{"id":"b","text":"شاشةٌ يظهر عليها الظلّ"},{"id":"c","text":"صوتٌ عالٍ"},{"id":"d","text":"مصدرٌ مضيء"}]'::jsonb, 'c', 'الظلّ يحتاج مصدرًا مضيئًا وجسمًا عاتمًا وشاشة؛ الصوت لا علاقة له بتكوّن الظلّ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2d9524f8-543a-52b5-b426-208deaf9f802', '7cebecfb-8502-5b65-a1bc-a36864376f4d', 'كسوف الشمس يحدث:', '[{"id":"a","text":"عند الفجر فقط"},{"id":"b","text":"في الشتاء فقط"},{"id":"c","text":"ليلًا"},{"id":"d","text":"نهارًا"}]'::jsonb, 'd', 'كسوف الشمس يحدث نهارًا عندما يقف القمر بين الشمس والأرض فيحجب ضوء الشمس.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aebe2f22-7688-5efe-b39f-05598d4bece4', '7cebecfb-8502-5b65-a1bc-a36864376f4d', 'ظلّ كرةٍ يكون شكله:', '[{"id":"a","text":"مثلّثًا"},{"id":"b","text":"دائريًّا تقريبًا"},{"id":"c","text":"نجمةً"},{"id":"d","text":"مربّعًا"}]'::jsonb, 'b', 'يأخذ الظلّ شكل الجسم العاتم نفسه تقريبًا، فظلّ الكرة دائريّ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9bcf79b4-1f09-5407-be5a-c658452bf846', '7cebecfb-8502-5b65-a1bc-a36864376f4d', 'خسوف القمر يحدث عندما تقف ............ بين الشمس والقمر.', '[{"id":"a","text":"الأرض"},{"id":"b","text":"الشمس"},{"id":"c","text":"السحب"},{"id":"d","text":"النجوم"}]'::jsonb, 'a', 'خسوف القمر يحدث ليلًا عندما تقف الأرض بين الشمس والقمر، فيدخل القمر في ظلّ الأرض.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2328476e-9838-51fb-bf4f-6fd40bb5ff5c', '4b11c4b9-1114-53e1-a9bf-9a61bb490f91', 'eveil-scientifique-5eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّدُ الظلال', 3, 120, 30, 'boss', 'admin', 2)
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
  ('3fe0a691-7bd5-56e9-abfa-4a38d60052eb', '2328476e-9838-51fb-bf4f-6fd40bb5ff5c', 'نقرّب كرةً من مصباحٍ ثابت، فماذا يحدث لظلّها على الجدار؟', '[{"id":"a","text":"يكبر الظلّ"},{"id":"b","text":"يختفي الظلّ"},{"id":"c","text":"يتحوّل إلى ضوء"},{"id":"d","text":"يصغر الظلّ"}]'::jsonb, 'a', 'كلّما اقترب الجسم العاتم من المصدر المضيء كبر ظلّه؛ فتقريب الكرة من المصباح يكبّر ظلّها على الجدار.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('180a5d56-508f-5c17-a9d9-d78d8d4f152a', '2328476e-9838-51fb-bf4f-6fd40bb5ff5c', 'ما الترتيب الصحيح للأجرام في كسوف الشمس؟', '[{"id":"a","text":"الشمس ← الأرض ← القمر"},{"id":"b","text":"الشمس ← القمر ← الأرض"},{"id":"c","text":"القمر ← الشمس ← الأرض"},{"id":"d","text":"الأرض ← الشمس ← القمر"}]'::jsonb, 'b', 'في كسوف الشمس يقف القمر بين الشمس والأرض (الشمس ← القمر ← الأرض)، فيحجب القمر ضوء الشمس عن الأرض. الخطأ الشائع وضع الأرض في الوسط (ذلك خسوف).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9035eee5-4864-583c-bd1b-aed32fbfc911', '2328476e-9838-51fb-bf4f-6fd40bb5ff5c', 'في خسوف القمر، ما الجسم العاتم الذي يحجب الضوء؟', '[{"id":"a","text":"القمر نفسه"},{"id":"b","text":"السحب"},{"id":"c","text":"الأرض"},{"id":"d","text":"الشمس"}]'::jsonb, 'c', 'في خسوف القمر تقف الأرض بين الشمس والقمر، فتكون الأرض هي الجسم العاتم الذي يحجب ضوء الشمس عن القمر فيُظلم. الخطأ الشائع ظنّ أنّ القمر يحجب نفسه.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a00e3a9-656a-5166-b077-c90e41177ce5', '2328476e-9838-51fb-bf4f-6fd40bb5ff5c', 'لماذا يُعتم جزءٌ من النهار أثناء كسوف الشمس؟', '[{"id":"a","text":"لأنّ الأرض توقّفت عن الدوران"},{"id":"b","text":"لأنّ القمر ينتج ظلامًا"},{"id":"c","text":"لأنّ الشمس انطفأت"},{"id":"d","text":"لأنّ القمر العاتم حجب ضوء الشمس عن ذلك الجزء من الأرض فوقع عليه ظلّ القمر"}]'::jsonb, 'd', 'أثناء الكسوف يقع ظلّ القمر العاتم على جزءٍ من الأرض، فيُحجب عنه ضوء الشمس ويُعتم النهار هناك. الشمس لم تنطفئ، بل حُجب ضوؤها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e7af417c-b44e-5375-a9f8-89bc705b538f', '2328476e-9838-51fb-bf4f-6fd40bb5ff5c', 'أيّ عبارةٍ صحيحةٌ عن الفرق بين الكسوف والخسوف؟', '[{"id":"a","text":"كلاهما يحدث ليلًا والأرض في الوسط"},{"id":"b","text":"كسوف الشمس: القمر في الوسط نهارًا — خسوف القمر: الأرض في الوسط ليلًا"},{"id":"c","text":"كسوف الشمس ليلًا — خسوف القمر نهارًا"},{"id":"d","text":"لا فرق بينهما"}]'::jsonb, 'b', 'في كسوف الشمس القمر هو الحاجب في الوسط نهارًا، وفي خسوف القمر الأرض هي الحاجبة في الوسط ليلًا. هذا هو الفرق الصحيح.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b71111cd-f19f-5fa2-8f7d-5286d19a6c07', '2328476e-9838-51fb-bf4f-6fd40bb5ff5c', 'في الصورة ترتيب الشمس والأرض والقمر أثناء ظاهرة. أيّ ظاهرةٍ هذه؟ <svg viewBox="0 0 220 70" xmlns="http://www.w3.org/2000/svg"><circle cx="30" cy="35" r="20" fill="#fcd116" stroke="#1f2937" stroke-width="3"/><text x="16" y="63" font-size="11" fill="#1f2937">الشمس</text><circle cx="115" cy="35" r="15" fill="#3b82f6" stroke="#1f2937" stroke-width="3"/><text x="100" y="63" font-size="11" fill="#1f2937">الأرض</text><circle cx="190" cy="35" r="9" fill="#9ca3af" stroke="#1f2937" stroke-width="3"/><text x="178" y="63" font-size="11" fill="#1f2937">القمر</text></svg>', '[{"id":"a","text":"خسوف القمر"},{"id":"b","text":"النهار العاديّ"},{"id":"c","text":"شروق الشمس"},{"id":"d","text":"كسوف الشمس"}]'::jsonb, 'a', 'الترتيب الشمس ← الأرض ← القمر، أي الأرض في الوسط تحجب ضوء الشمس عن القمر، وهذا خسوف القمر.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('70c004dc-67e4-5167-8c02-6602de13f6d6', '4b11c4b9-1114-53e1-a9bf-9a61bb490f91', 'eveil-scientifique-5eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الظلُّ والظواهر', 2, 75, 15, 'practice', 'admin', 3)
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
  ('7b4455c0-2957-585a-adf9-6710bd8f26f2', '70c004dc-67e4-5167-8c02-6602de13f6d6', 'أيّ زوجٍ صحيحٌ (ظاهرة ← وقتها)؟', '[{"id":"a","text":"كسوف الشمس ← نهارًا"},{"id":"b","text":"كسوف الشمس ← ليلًا"},{"id":"c","text":"خسوف القمر ← نهارًا"},{"id":"d","text":"كسوف الشمس ← عند الغروب فقط"}]'::jsonb, 'a', 'كسوف الشمس يحدث نهارًا (القمر يحجب الشمس)، وخسوف القمر يحدث ليلًا (الأرض تحجب الضوء عن القمر).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5d80791d-afa4-50e6-af4a-e942e526f90b', '70c004dc-67e4-5167-8c02-6602de13f6d6', 'نبعد جسمًا عاتمًا عن المصباح. ماذا يحدث لظلّه؟', '[{"id":"a","text":"يكبر"},{"id":"b","text":"يصغر"},{"id":"c","text":"يبقى ثابتًا"},{"id":"d","text":"يصبح ملوّنًا"}]'::jsonb, 'b', 'كلّما ابتعد الجسم العاتم عن المصدر المضيء صغر ظلّه؛ فإبعاد الجسم عن المصباح يصغّر ظلّه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('57043ac5-2996-58be-a986-c8b9d097eda9', '70c004dc-67e4-5167-8c02-6602de13f6d6', 'ما الذي يحدّد شكل الظلّ؟', '[{"id":"a","text":"لون المصباح"},{"id":"b","text":"شكل الجسم العاتم"},{"id":"c","text":"حجم الشاشة"},{"id":"d","text":"صوت الجسم"}]'::jsonb, 'b', 'يأخذ الظلّ شكل الجسم العاتم نفسه تقريبًا؛ فظلّ المسطرة مستطيل وظلّ الكرة دائريّ.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a16f3f6a-f8df-5527-aba8-8c27ed17bdc3', '70c004dc-67e4-5167-8c02-6602de13f6d6', 'في كسوف الشمس، أيّ جرمٍ هو الجسم العاتم الحاجب؟', '[{"id":"a","text":"الشمس"},{"id":"b","text":"الأرض"},{"id":"c","text":"القمر"},{"id":"d","text":"نجمٌ بعيد"}]'::jsonb, 'c', 'في كسوف الشمس يقف القمر بين الشمس والأرض، فيكون القمر هو الجسم العاتم الذي يحجب ضوء الشمس.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6c38f0ec-9c71-5853-9aeb-594d382409c9', '70c004dc-67e4-5167-8c02-6602de13f6d6', 'لماذا نُحذَّر من النظر إلى الشمس مباشرة أثناء الكسوف؟', '[{"id":"a","text":"لأنّ ضوء الشمس القويّ يؤذي العين حتّى وهي مكسوفة"},{"id":"b","text":"لأنّ الشمس تصبح باردة"},{"id":"c","text":"لأنّ القمر يطلق ضوءًا ضارًّا"},{"id":"d","text":"لأنّ العين تطلق شعاعًا نحو الشمس"}]'::jsonb, 'a', 'حتّى أثناء الكسوف يبقى ضوء الشمس قويًّا جدًّا، والنظر المباشر إليه يؤذي العين؛ لذلك نتجنّبه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fcbc10d4-a5e4-5e19-b4d2-4b61fa20db98', '70c004dc-67e4-5167-8c02-6602de13f6d6', 'نضع كرةً بين مصباحٍ وجدار. أيّ العناصر يمثّل دور "الشاشة"؟', '[{"id":"a","text":"المصباح"},{"id":"b","text":"الكرة"},{"id":"c","text":"الهواء"},{"id":"d","text":"الجدار"}]'::jsonb, 'd', 'الجدار هو الشاشة التي يظهر عليها الظلّ؛ المصباح مصدرٌ مضيء والكرة جسمٌ عاتم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('b3ed288f-cef8-55a5-a492-91b19e7f1d0b', '4b11c4b9-1114-53e1-a9bf-9a61bb490f91', 'eveil-scientifique-5eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: عبقريُّ الكسوف', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('d15e5c0e-753f-5a99-895b-2543218e999d', 'b3ed288f-cef8-55a5-a492-91b19e7f1d0b', 'أكمل بالترتيب الصحيح: في كسوف الشمس .......... وفي خسوف القمر ..........', '[{"id":"a","text":"القمر يحجب الشمس عن الأرض / الأرض تحجب الشمس عن القمر"},{"id":"b","text":"الأرض تحجب الشمس عن القمر / القمر يحجب الشمس عن الأرض"},{"id":"c","text":"الشمس تحجب القمر / القمر يحجب الأرض"},{"id":"d","text":"القمر ينطفئ / الشمس تنطفئ"}]'::jsonb, 'a', 'في كسوف الشمس القمر يحجب ضوء الشمس عن الأرض (نهارًا)، وفي خسوف القمر الأرض تحجب ضوء الشمس عن القمر (ليلًا). هذا هو التطابق الصحيح.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f4fa1ac-0947-5416-98f1-c3650235bb15', 'b3ed288f-cef8-55a5-a492-91b19e7f1d0b', 'يلعب طفلٌ بكرةٍ صغيرة (تمثّل القمر) وكرةٍ كبيرة (تمثّل الأرض) ومصباح (يمثّل الشمس). كيف يرتّبها ليُحاكي خسوف القمر؟', '[{"id":"a","text":"المصباح ← الكرة الصغيرة ← الكرة الكبيرة"},{"id":"b","text":"المصباح ← الكرة الكبيرة ← الكرة الصغيرة"},{"id":"c","text":"الكرة الصغيرة ← المصباح ← الكرة الكبيرة"},{"id":"d","text":"الكرة الكبيرة ← الكرة الصغيرة ← المصباح"}]'::jsonb, 'b', 'خسوف القمر: الشمس ← الأرض ← القمر، أي المصباح ثمّ الكرة الكبيرة (الأرض) في الوسط ثمّ الكرة الصغيرة (القمر) التي تدخل ظلّ الأرض. الخطأ الشائع وضع القمر في الوسط.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5dea4080-0e84-57fe-86b4-1960ada0b96f', 'b3ed288f-cef8-55a5-a492-91b19e7f1d0b', 'في الظهيرة يكون ظلّ العمود قصيرًا، وعند الغروب يصير طويلًا. ما السبب؟', '[{"id":"a","text":"لأنّ الأرض عاتمة مساءً فقط"},{"id":"b","text":"لأنّ العمود يكبر مساءً"},{"id":"c","text":"لأنّ ضوء الشمس يأتي مائلًا عند الغروب فيطول الظلّ، ويأتي عموديًّا في الظهيرة فيقصر"},{"id":"d","text":"لأنّ الشمس تقترب من الأرض مساءً"}]'::jsonb, 'c', 'اتّجاه ضوء الشمس يتغيّر خلال اليوم: في الظهيرة يكون قريبًا من العموديّ فيقصر الظلّ، وعند الغروب يكون مائلًا جدًّا فيطول الظلّ. العمود لم يتغيّر حجمه. الفخّ الشائع توهّم تغيّر حجم العمود أو اقتراب الشمس.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1c3622a-d036-5eea-9fa4-13c510207eb2', 'b3ed288f-cef8-55a5-a492-91b19e7f1d0b', 'تلميذٌ قال: «الشمس تنطفئ أثناء كسوفها.» أين الخطأ؟', '[{"id":"a","text":"الخطأ أنّ القمر هو الذي ينطفئ"},{"id":"b","text":"الخطأ أنّ الأرض تنطفئ"},{"id":"c","text":"لا خطأ، فالشمس تنطفئ فعلًا"},{"id":"d","text":"الخطأ أنّ الشمس تبقى مضيئة، لكنّ القمر يحجب ضوءها عن جزءٍ من الأرض"}]'::jsonb, 'd', 'الشمس تبقى مضيئة دائمًا أثناء الكسوف؛ ما يحدث أنّ القمر العاتم يقف في طريق ضوئها فيحجبه عن جزءٍ من الأرض. هذا هو الخطأ الشائع: ظنّ أنّ الشمس تنطفئ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3c85f94e-a9f4-5b4c-9924-607cdbdae1db', 'b3ed288f-cef8-55a5-a492-91b19e7f1d0b', 'نضيء كرةً بمصباحٍ ونحرّك شاشةً خلفها. متى يكون الظلّ على الشاشة أكبر؟', '[{"id":"a","text":"عندما تكون الشاشة قريبةً جدًّا من الكرة"},{"id":"b","text":"عندما تكون الشاشة بعيدةً عن الكرة"},{"id":"c","text":"عندما نطفئ المصباح"},{"id":"d","text":"حجم الظلّ لا يتغيّر أبدًا"}]'::jsonb, 'b', 'لأنّ الضوء ينتشر مستقيمًا متباعدًا من المصدر، يكبر الظلّ كلّما ابتعدت الشاشة عن الجسم العاتم. الفخّ الشائع توهّم ثبات حجم الظلّ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07cd377c-3ee7-51e2-a0de-b571645f3837', 'b3ed288f-cef8-55a5-a492-91b19e7f1d0b', 'في الصورة مصباحٌ وكرةٌ عاتمة وشاشة. أيّ منطقةٍ هي الظلّ؟ <svg viewBox="0 0 220 90" xmlns="http://www.w3.org/2000/svg"><circle cx="24" cy="45" r="14" fill="#fcd116" stroke="#1f2937" stroke-width="3"/><circle cx="100" cy="45" r="16" fill="#7c3aed" stroke="#1f2937" stroke-width="3"/><line x1="38" y1="38" x2="150" y2="18" stroke="#f59e0b" stroke-width="2"/><line x1="38" y1="52" x2="150" y2="72" stroke="#f59e0b" stroke-width="2"/><rect x="150" y="10" width="14" height="70" fill="#e5e7eb" stroke="#1f2937" stroke-width="2"/><rect x="150" y="33" width="14" height="24" fill="#1f2937"/><text x="168" y="48" font-size="11" fill="#1f2937">؟</text></svg>', '[{"id":"a","text":"المنطقة الداكنة على الشاشة خلف الكرة"},{"id":"b","text":"المصباح نفسه"},{"id":"c","text":"الكرة البنفسجيّة"},{"id":"d","text":"المنطقة المضيئة فوق الشاشة"}]'::jsonb, 'a', 'الكرة العاتمة تحجب الضوء، فتتكوّن منطقةٌ داكنة على الشاشة خلفها مباشرة، وهي الظلّ (المستطيل الأسود على الشاشة).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('dc7626cb-c9bd-5250-b9f8-133bf1a63154', '4b11c4b9-1114-53e1-a9bf-9a61bb490f91', 'eveil-scientifique-5eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملةٌ للظلّ والكسوف', 3, 120, 30, 'boss', 'admin', 5)
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
  ('a3db3448-b0a8-5d30-b1a0-be3e274ffbf6', 'dc7626cb-c9bd-5250-b9f8-133bf1a63154', 'العناصر الثلاثة لتكوّن الظلّ هي:', '[{"id":"a","text":"مصدرٌ مضيء، جسمٌ عاتم، شاشة"},{"id":"b","text":"ماء، نار، هواء"},{"id":"c","text":"ثلاثة أجسامٍ شفّافة"},{"id":"d","text":"مصدرٌ مضيء، جسمٌ شفّاف، صوت"}]'::jsonb, 'a', 'لتكوّن الظلّ نحتاج مصدرًا مضيئًا وجسمًا عاتمًا يحجب الضوء وشاشة يظهر عليها الظلّ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f0d03245-60dc-5d49-b27d-4b3a2a399b17', 'dc7626cb-c9bd-5250-b9f8-133bf1a63154', 'أيّ جملةٍ صحيحةٌ عن خسوف القمر؟', '[{"id":"a","text":"يحدث نهارًا والقمر يحجب الشمس"},{"id":"b","text":"يحدث ليلًا وتدخل الأرض بين الشمس والقمر فيُظلم القمر"},{"id":"c","text":"يحدث عندما ينطفئ القمر"},{"id":"d","text":"يحدث عندما يقترب القمر من الشمس"}]'::jsonb, 'b', 'خسوف القمر يحدث ليلًا عندما تقف الأرض بين الشمس والقمر فيدخل القمر في ظلّ الأرض ويُظلم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('83019b1b-3374-5479-8a2d-408d8bd025ab', 'dc7626cb-c9bd-5250-b9f8-133bf1a63154', 'نحرّك مصباحًا حول جسمٍ عاتمٍ ثابت. كيف يتغيّر الظلّ؟', '[{"id":"a","text":"يصبح الظلّ مصدرًا للضوء"},{"id":"b","text":"يبقى الظلّ في مكانه دائمًا"},{"id":"c","text":"يتحرّك الظلّ في الجهة المقابلة للمصباح ويتغيّر طوله"},{"id":"d","text":"يختفي الظلّ تمامًا"}]'::jsonb, 'c', 'الظلّ يتكوّن دائمًا في الجهة المقابلة للمصدر المضيء؛ فعند تحريك المصباح يتحرّك الظلّ ويتغيّر طوله تبعًا لاتّجاه الضوء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85e7ecb6-2158-5a5c-b565-4c48cfe7f315', 'dc7626cb-c9bd-5250-b9f8-133bf1a63154', 'لماذا يكون ظلّ الإنسان عند الظهيرة أقصر منه عند الصباح الباكر؟', '[{"id":"a","text":"لأنّ الإنسان يقصر في الظهيرة"},{"id":"b","text":"لأنّ الشمس تنطفئ ظهرًا"},{"id":"c","text":"لأنّ الأرض تقترب من الشمس ظهرًا"},{"id":"d","text":"لأنّ الشمس تكون أعلى في الظهيرة فيأتي ضوؤها قريبًا من العموديّ فيقصر الظلّ"}]'::jsonb, 'd', 'موضع الشمس في السماء يتغيّر خلال اليوم؛ في الظهيرة تكون عاليةً فيأتي ضوؤها قريبًا من العموديّ فيقصر الظلّ، وفي الصباح تكون منخفضةً فيأتي مائلًا فيطول الظلّ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dc0ff405-15db-5cb2-9ed0-20b14407681d', 'dc7626cb-c9bd-5250-b9f8-133bf1a63154', 'أيّ تجربةٍ تثبت أنّ الظلّ يأخذ شكل الجسم العاتم؟', '[{"id":"a","text":"النظر إلى الشمس مباشرة"},{"id":"b","text":"إضاءة كرةٍ فيظهر ظلٌّ دائريّ، وإضاءة مسطرةٍ فيظهر ظلٌّ مستطيل"},{"id":"c","text":"إضاءة زجاجٍ شفّاف فيظهر ظلٌّ كبير"},{"id":"d","text":"إطفاء المصباح فيظهر ظلٌّ ملوّن"}]'::jsonb, 'b', 'إضاءة أجسامٍ عاتمةٍ مختلفة الشكل (كرة، مسطرة) وملاحظة أنّ ظلّ كلٍّ يشبه شكلها يثبت أنّ الظلّ يأخذ شكل الجسم العاتم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('00dd4a1b-3722-5403-a953-90c3179603e4', 'dc7626cb-c9bd-5250-b9f8-133bf1a63154', 'رتّب مراحل تكوّن ظلّ يدٍ على الجدار بالترتيب الصحيح:', '[{"id":"a","text":"المصباح يُرسل ضوءًا ← اليد العاتمة تحجبه ← منطقةٌ مظلمة (ظلّ) على الجدار"},{"id":"b","text":"اليد تُطلق ظلامًا ← الجدار يضيء ← لا ظلّ"},{"id":"c","text":"الجدار يُرسل ضوءًا ← اليد تعكسه ← ظلّ على المصباح"},{"id":"d","text":"العين تُطلق شعاعًا ← اليد ← ظلّ"}]'::jsonb, 'a', 'يتكوّن الظلّ هكذا: المصباح (مصدر مضيء) يُرسل ضوءًا ← تعترضه اليد (جسم عاتم) فتحجبه ← تظهر منطقةٌ مظلمة على الجدار (الشاشة) هي الظلّ.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6fb62761-1a21-503e-bee8-25220383b695', '17b55ae5-b632-5d69-9251-dcfca34e09b2', 'eveil-scientifique-5eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('337b8767-d57b-5f82-99e2-941abb2ef94f', '6fb62761-1a21-503e-bee8-25220383b695', 'ما هو الهيكل العظميّ؟', '[{"id":"a","text":"مجموعة العظام الصلبة المترابطة في الجسم"},{"id":"b","text":"مجموعة العضلات فقط"},{"id":"c","text":"الجلد الذي يغطّي الجسم"},{"id":"d","text":"الدم الذي يجري في الجسم"}]'::jsonb, 'a', 'الهيكل العظميّ هو مجموعة العظام الصلبة المترابطة التي تدعم الجسم وتحميه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('04d37574-9009-530f-809e-4d23565e6f2f', '6fb62761-1a21-503e-bee8-25220383b695', 'أيّ عضوٍ تحميه الجمجمة؟', '[{"id":"a","text":"القلب"},{"id":"b","text":"الدماغ"},{"id":"c","text":"المعدة"},{"id":"d","text":"الرئتان"}]'::jsonb, 'b', 'الجمجمة صندوقٌ عظميّ يحمي الدماغ في الرأس.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('75d7239b-e2fa-5545-ae6e-3bd097582fea', '6fb62761-1a21-503e-bee8-25220383b695', 'عظم الفخذ في الساق هو عظمٌ:', '[{"id":"a","text":"قصير"},{"id":"b","text":"مسطّح"},{"id":"c","text":"طويل"},{"id":"d","text":"ليّن"}]'::jsonb, 'c', 'عظم الفخذ طوله أكبر من عرضه، فهو عظمٌ طويل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce9dbcb5-bcb7-575d-8eaa-1da1cb024d6c', '6fb62761-1a21-503e-bee8-25220383b695', 'أيّ وظيفةٍ من وظائف الهيكل العظميّ؟', '[{"id":"a","text":"هضم الطعام"},{"id":"b","text":"تنقية الهواء"},{"id":"c","text":"تذوّق الطعام"},{"id":"d","text":"دعم الجسم وحمايته"}]'::jsonb, 'd', 'من وظائف الهيكل العظميّ دعم الجسم وحماية الأعضاء ومساعدة الحركة. أمّا الهضم والتنفّس والذوق فوظائف أعضاء أخرى.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('91a01cdd-7bad-5a00-ad43-46abfb7d7f76', '6fb62761-1a21-503e-bee8-25220383b695', 'في الصورة هيكلٌ مبسّط. أيّ جزءٍ يحمي القلب والرئتين؟ <svg viewBox="0 0 120 170" xmlns="http://www.w3.org/2000/svg"><circle cx="60" cy="28" r="20" fill="#fef3c7" stroke="#1f2937" stroke-width="3"/><text x="86" y="30" font-size="12" fill="#1f2937">1</text><line x1="60" y1="48" x2="60" y2="120" stroke="#1f2937" stroke-width="4"/><g stroke="#1f2937" stroke-width="3" fill="none"><path d="M60 60 q-26 8 -28 24"/><path d="M60 70 q-24 8 -26 22"/><path d="M60 80 q-22 8 -24 20"/><path d="M60 60 q26 8 28 24"/><path d="M60 70 q24 8 26 22"/><path d="M60 80 q22 8 24 20"/></g><text x="2" y="80" font-size="12" fill="#1f2937">2</text><line x1="60" y1="120" x2="42" y2="160" stroke="#1f2937" stroke-width="5"/><line x1="60" y1="120" x2="78" y2="160" stroke="#1f2937" stroke-width="5"/><text x="82" y="150" font-size="12" fill="#1f2937">3</text></svg>', '[{"id":"a","text":"الجزء رقم 1 (الجمجمة)"},{"id":"b","text":"الجزء رقم 2 (القفص الصدريّ)"},{"id":"c","text":"الجزء رقم 3 (عظام الساق)"},{"id":"d","text":"لا شيء يحميهما"}]'::jsonb, 'b', 'القفص الصدريّ (رقم 2) أضلاعٌ تحيط بالصدر فتحمي القلب والرئتين. الجمجمة تحمي الدماغ، وعظام الساق للحركة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a2cd8402-49ab-5a88-aafe-48ff7b35e36e', '17b55ae5-b632-5d69-9251-dcfca34e09b2', 'eveil-scientifique-5eme', '⭐ تمرين: أتعرّف على عظامي', 1, 50, 10, 'practice', 'admin', 1)
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
  ('f73d43db-4939-5fa8-98cf-cf7ee746389e', 'a2cd8402-49ab-5a88-aafe-48ff7b35e36e', 'العظام في الجسم تكون:', '[{"id":"a","text":"صلبةً قويّة"},{"id":"b","text":"ليّنةً كالإسفنج"},{"id":"c","text":"سائلةً كالماء"},{"id":"d","text":"غازيّةً كالهواء"}]'::jsonb, 'a', 'العظام صلبةٌ قويّة، ولهذا تستطيع أن تدعم الجسم وتحميه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('257ea8c0-5982-59ab-a9f1-a7620d798db6', 'a2cd8402-49ab-5a88-aafe-48ff7b35e36e', 'الجزء العظميّ الذي يحمي الدماغ هو:', '[{"id":"a","text":"القفص الصدريّ"},{"id":"b","text":"الجمجمة"},{"id":"c","text":"عظم الفخذ"},{"id":"d","text":"عظام الرسغ"}]'::jsonb, 'b', 'الجمجمة صندوقٌ عظميّ في الرأس يحمي الدماغ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5d4a9b66-83ab-5459-b151-606fffdd58c8', 'a2cd8402-49ab-5a88-aafe-48ff7b35e36e', 'أيّ هذه وظيفةٌ للهيكل العظميّ؟', '[{"id":"a","text":"تنقية الدم"},{"id":"b","text":"هضم الطعام"},{"id":"c","text":"دعم الجسم"},{"id":"d","text":"سماع الأصوات"}]'::jsonb, 'c', 'من وظائف الهيكل العظميّ دعم الجسم وإبقاؤه منتصبًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0d4a6e39-00ba-5907-9e84-3be70ef9e0f8', 'a2cd8402-49ab-5a88-aafe-48ff7b35e36e', 'عظام الجمجمة عظامٌ:', '[{"id":"a","text":"طويلة"},{"id":"b","text":"قصيرة"},{"id":"c","text":"مسطّحة"},{"id":"d","text":"ليّنة"}]'::jsonb, 'c', 'عظام الجمجمة رقيقةٌ ومنبسطة، فهي عظامٌ مسطّحة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d76d9db0-d392-500c-96ec-af05829b69b9', 'a2cd8402-49ab-5a88-aafe-48ff7b35e36e', 'أيّ غذاءٍ يقوّي العظام؟', '[{"id":"a","text":"الحلويّات والسكّر"},{"id":"b","text":"الحليب الغنيّ بالكالسيوم"},{"id":"c","text":"المشروبات الغازيّة"},{"id":"d","text":"الملح"}]'::jsonb, 'b', 'الحليب غنيٌّ بالكالسيوم الذي يقوّي العظام ويجعلها صلبة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f39b77be-6ae4-5fad-b92a-a3f7efa9d3fd', 'a2cd8402-49ab-5a88-aafe-48ff7b35e36e', 'عظم الذراع عظمٌ طويل لأنّ:', '[{"id":"a","text":"هو ليّنٌ ينضغط"},{"id":"b","text":"طوله يساوي عرضه"},{"id":"c","text":"هو رقيقٌ ومنبسط"},{"id":"d","text":"طوله أكبر من عرضه"}]'::jsonb, 'd', 'العظم الطويل يكون طوله أكبر من عرضه، مثل عظم الذراع.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('e14cd373-aebc-50f7-bd9f-651d22667b78', '17b55ae5-b632-5d69-9251-dcfca34e09b2', 'eveil-scientifique-5eme', '⚔️ زعيم الفصل ⭐⭐⭐: حارسُ العظام', 3, 120, 30, 'boss', 'admin', 2)
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
  ('bfeb8f78-de52-58d1-a085-8d12398f5c20', 'e14cd373-aebc-50f7-bd9f-651d22667b78', 'أيّ مجموعةٍ كلّها عظامٌ طويلة؟', '[{"id":"a","text":"عظم الفخذ، عظم الذراع، عظم الساق"},{"id":"b","text":"عظام الجمجمة، عظم الكتف، الأضلاع"},{"id":"c","text":"عظام الرسغ، عظام القدم"},{"id":"d","text":"الجمجمة، الأضلاع، الرسغ"}]'::jsonb, 'a', 'عظم الفخذ والذراع والساق طولها أكبر من عرضها فهي عظامٌ طويلة. (ب) عظامٌ مسطّحة، و(ج) عظامٌ قصيرة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bd387dde-1c14-5c2d-804d-d80413c1555e', 'e14cd373-aebc-50f7-bd9f-651d22667b78', 'لماذا يحمي القفص الصدريّ القلب والرئتين؟', '[{"id":"a","text":"لأنّه ليّنٌ ينضغط حولهما"},{"id":"b","text":"لأنّه أضلاعٌ عظميّة صلبة تحيط بهما كالقفص"},{"id":"c","text":"لأنّه يضخّ الدم إليهما"},{"id":"d","text":"لأنّه ينقّي الهواء الداخل إليهما"}]'::jsonb, 'b', 'القفص الصدريّ أضلاعٌ عظميّة صلبة تحيط بالصدر كالقفص، فتحمي القلب والرئتين من الصدمات. الخطأ الشائع نسبة وظائف أعضاء أخرى (الضخّ، التنقية) إليه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4fe4dabf-5ffc-594c-983e-b8465c1263c6', 'e14cd373-aebc-50f7-bd9f-651d22667b78', 'تلميذٌ صنّف عظم الفخذ "قصيرًا" لأنّه كبير. أين الخطأ؟', '[{"id":"a","text":"الخطأ أنّ عظم الفخذ ليّن"},{"id":"b","text":"لا خطأ، فالعظم الكبير قصير"},{"id":"c","text":"الخطأ أنّ التصنيف بالشكل لا بالحجم: عظم الفخذ طوله أكبر من عرضه فهو طويل"},{"id":"d","text":"الخطأ أنّ عظم الفخذ مسطّح"}]'::jsonb, 'c', 'نصنّف العظام حسب الشكل لا الحجم؛ عظم الفخذ طوله أكبر بكثير من عرضه فهو عظمٌ طويل مهما كان كبيرًا. هذا هو الخطأ الشائع: الخلط بين الحجم والشكل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('864bdb74-ab9e-5e1d-87a6-f835990a9cda', 'e14cd373-aebc-50f7-bd9f-651d22667b78', 'أيّ زوجٍ صحيحٌ (وظيفة ← مثال)؟', '[{"id":"a","text":"الحماية ← عظم الساق يهضم الطعام"},{"id":"b","text":"الدعم ← القلب يحمل الجسم"},{"id":"c","text":"الحركة ← الجلد يحرّك العظام"},{"id":"d","text":"الحماية ← الجمجمة تحمي الدماغ"}]'::jsonb, 'd', 'الجمجمة تحمي الدماغ، وهذا مثالٌ صحيحٌ لوظيفة الحماية. باقي الأزواج تنسب أدوارًا خاطئة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7f33f582-a9b3-5157-a8fb-ac0807152c0e', 'e14cd373-aebc-50f7-bd9f-651d22667b78', 'لماذا ننصح بالجلوس بظهرٍ مستقيم؟', '[{"id":"a","text":"حتّى يتوقّف نموّ العظام"},{"id":"b","text":"حتّى لا يعوجّ العمود الفقريّ مع الوقت"},{"id":"c","text":"حتّى يكبر الرأس"},{"id":"d","text":"حتّى تصبح العظام ليّنة"}]'::jsonb, 'b', 'الجلوس المنحني المتكرّر قد يجعل العمود الفقريّ يعوجّ؛ لذلك ننصح بظهرٍ مستقيم للمحافظة على استقامته.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('01dbb36b-129b-53fd-ba84-06cad1eddc2e', 'e14cd373-aebc-50f7-bd9f-651d22667b78', 'أيّ مجموعةٍ ترتّب كلّ عظمٍ بنوعه الصحيح؟', '[{"id":"a","text":"الفخذ: طويل — الجمجمة: مسطّح — الرسغ: قصير"},{"id":"b","text":"الفخذ: قصير — الجمجمة: طويل — الرسغ: مسطّح"},{"id":"c","text":"الفخذ: مسطّح — الجمجمة: قصير — الرسغ: طويل"},{"id":"d","text":"الفخذ: مسطّح — الجمجمة: طويل — الرسغ: قصير"}]'::jsonb, 'a', 'عظم الفخذ طويل (طوله أكبر من عرضه)، وعظام الجمجمة مسطّحة (رقيقة منبسطة)، وعظام الرسغ قصيرة (طولها قريبٌ من عرضها). هذا هو التصنيف الصحيح.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('47394b9e-fad1-5c35-ba03-cbc3274737a5', '17b55ae5-b632-5d69-9251-dcfca34e09b2', 'eveil-scientifique-5eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الهيكلُ والعظام', 2, 75, 15, 'practice', 'admin', 3)
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
  ('79b1efdc-9af5-5f5b-bc82-a8d7ea493999', '47394b9e-fad1-5c35-ba03-cbc3274737a5', 'أيّ جزءٍ من أجزاء الهيكل العظميّ يوجد في الظهر؟', '[{"id":"a","text":"العمود الفقريّ"},{"id":"b","text":"عظم الذراع"},{"id":"c","text":"عظام القدم"},{"id":"d","text":"الجمجمة"}]'::jsonb, 'a', 'العمود الفقريّ سلسلة عظامٍ تمتدّ في الظهر ويحمي النّخاع الشوكيّ.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d415a3a3-6400-578a-ac6e-8e5ca03fc68b', '47394b9e-fad1-5c35-ba03-cbc3274737a5', 'عظام الرسغ عظامٌ:', '[{"id":"a","text":"مسطّحة"},{"id":"b","text":"قصيرة"},{"id":"c","text":"سائلة"},{"id":"d","text":"طويلة"}]'::jsonb, 'b', 'عظام الرسغ طولها قريبٌ من عرضها (شبه مكعّبة)، فهي عظامٌ قصيرة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('daa30dc0-a71f-586c-bcd0-6ed13fb90e65', '47394b9e-fad1-5c35-ba03-cbc3274737a5', 'أيّ زوجٍ صحيحٌ (عظم ← نوعه)؟', '[{"id":"a","text":"الرسغ ← طويل"},{"id":"b","text":"عظم الساق ← مسطّح"},{"id":"c","text":"عظم الكتف ← مسطّح"},{"id":"d","text":"الجمجمة ← طويل"}]'::jsonb, 'c', 'عظم الكتف رقيقٌ منبسط فهو مسطّح. عظم الساق طويل، والجمجمة مسطّحة، والرسغ قصير.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1e8aaddd-2648-5ba4-83a5-2ed8472501d1', '47394b9e-fad1-5c35-ba03-cbc3274737a5', 'ماذا يحدث لو لم يكن للجسم هيكلٌ عظميّ؟', '[{"id":"a","text":"يصبح الجسم أسرع"},{"id":"b","text":"يهضم الجسم أفضل"},{"id":"c","text":"يرى الجسم أوضح"},{"id":"d","text":"لا يستطيع الجسم أن يقف منتصبًا"}]'::jsonb, 'd', 'الهيكل العظميّ يدعم الجسم؛ بدونه لا يستطيع الجسم الوقوف منتصبًا ويصير كيسًا ليّنًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b52017c-6aba-5b24-af1c-d70436a3b8e8', '47394b9e-fad1-5c35-ba03-cbc3274737a5', 'أيّ سلوكٍ يحافظ على صحّة العظام؟', '[{"id":"a","text":"الإكثار من المشروبات الغازيّة"},{"id":"b","text":"ممارسة الرياضة وشرب الحليب"},{"id":"c","text":"حمل أوزانٍ ثقيلةٍ جدًّا فجأة"},{"id":"d","text":"الجلوس منحنيًا طوال اليوم"}]'::jsonb, 'b', 'ممارسة الرياضة تشدّ العظام، وشرب الحليب يمدّها بالكالسيوم، فكلاهما يحافظ على صحّتها.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('17a9ad4f-c500-5943-9996-bdf61c0b8e05', '47394b9e-fad1-5c35-ba03-cbc3274737a5', 'في الصورة عظمان: 1 طويلٌ ممتدّ، و2 رقيقٌ منبسط. ما نوعاهما؟ <svg viewBox="0 0 200 90" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="3"><rect x="22" y="20" width="16" height="50" rx="6" fill="#fde68a"/><circle cx="30" cy="18" r="8" fill="#fde68a"/><circle cx="30" cy="72" r="8" fill="#fde68a"/></g><text x="44" y="48" font-size="12" fill="#1f2937">1</text><ellipse cx="140" cy="45" rx="40" ry="22" fill="#fef3c7" stroke="#1f2937" stroke-width="3"/><text x="136" y="80" font-size="12" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"1 طويل، 2 مسطّح"},{"id":"b","text":"1 مسطّح، 2 طويل"},{"id":"c","text":"1 قصير، 2 طويل"},{"id":"d","text":"كلاهما قصير"}]'::jsonb, 'a', 'العظم 1 طوله أكبر من عرضه فهو طويل، والعظم 2 رقيقٌ منبسط فهو مسطّح.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8dcf5083-2cac-50e7-83ce-a709d54fb1ff', '17b55ae5-b632-5d69-9251-dcfca34e09b2', 'eveil-scientifique-5eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: عبقريُّ الهيكل', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('174e627b-af3a-5ba3-a6e8-30937b5789c1', '8dcf5083-2cac-50e7-83ce-a709d54fb1ff', 'أكمل: الجمجمة عظمٌ ........ يحمي ........ ، والقفص الصدريّ يحمي ........', '[{"id":"a","text":"مسطّح / الدماغ / القلب والرئتين"},{"id":"b","text":"طويل / القلب / الدماغ"},{"id":"c","text":"قصير / الرئتين / المعدة"},{"id":"d","text":"ليّن / المعدة / الكبد"}]'::jsonb, 'a', 'الجمجمة عظمٌ مسطّح يحمي الدماغ، والقفص الصدريّ يحمي القلب والرئتين. هذا هو الإكمال الصحيح الوحيد.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4bdb06bd-87ad-5de4-b93c-9eb462bf3013', '8dcf5083-2cac-50e7-83ce-a709d54fb1ff', 'رياضيٌّ يكسر عظم ساقه. لماذا ينصحه الطبيب بتثبيته بالجبس مدّةً؟', '[{"id":"a","text":"ليحوّل العظم إلى عضلة"},{"id":"b","text":"ليبقى العظم ثابتًا حتّى يلتئم ويعود صلبًا"},{"id":"c","text":"ليصبح العظم ليّنًا"},{"id":"d","text":"ليمنع العظم من النموّ"}]'::jsonb, 'b', 'تثبيت العظم المكسور بالجبس يبقيه ثابتًا فيلتئم بشكلٍ صحيح ويعود صلبًا. الحركة قبل الالتئام قد تعيق الشفاء. الفخّ الشائع توهّم أنّ الجبس يليّن العظم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7e3f6cd3-42a9-58b5-98ca-47494e5314a8', '8dcf5083-2cac-50e7-83ce-a709d54fb1ff', 'لماذا تكون عظام الجمجمة مسطّحةً وملتحمةً بإحكام؟', '[{"id":"a","text":"لتضخّ الدم إلى الرأس"},{"id":"b","text":"لتهضم الطعام في الرأس"},{"id":"c","text":"لتكوّن صندوقًا صلبًا يحمي الدماغ من الصدمات"},{"id":"d","text":"لتساعد على المشي"}]'::jsonb, 'c', 'العظام المسطّحة الملتحمة في الجمجمة تكوّن صندوقًا صلبًا محكمًا يحيط بالدماغ ويحميه من الصدمات. باقي الخيارات وظائف أعضاء أخرى.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0bc7a3a3-4a9f-567b-987a-fa77d291a5a1', '8dcf5083-2cac-50e7-83ce-a709d54fb1ff', 'أيّ تفسيرٍ يربط بين أنواع العظام ووظائفها بشكلٍ صحيح؟', '[{"id":"a","text":"العظام الطويلة للحماية فقط، والمسطّحة للحركة فقط"},{"id":"b","text":"كلّ العظام مسطّحة لتهضم الطعام"},{"id":"c","text":"العظام القصيرة تضخّ الدم"},{"id":"d","text":"العظام الطويلة (كالفخذ) تناسب الحركة والوقوف، والمسطّحة (كالجمجمة) تناسب الحماية"}]'::jsonb, 'd', 'شكل العظم يناسب وظيفته: العظام الطويلة كالفخذ تحمل الجسم وتساعد الحركة، والمسطّحة كالجمجمة تحيط بالأعضاء فتحميها. هذا الربط هو الصحيح.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3a30657-69f2-52d3-8198-0c545904ceda', '8dcf5083-2cac-50e7-83ce-a709d54fb1ff', 'طفلٌ يحمل حقيبةً ثقيلةً جدًّا على كتفٍ واحد كلّ يوم. ما الخطر المحتمل على هيكله؟', '[{"id":"a","text":"قد يتوقّف قلبه عن الضخّ"},{"id":"b","text":"قد يميل عموده الفقريّ ويختلّ توازن ظهره"},{"id":"c","text":"قد تكبر جمجمته"},{"id":"d","text":"قد تصبح عظامه سائلة"}]'::jsonb, 'b', 'حمل ثقلٍ كبيرٍ على كتفٍ واحدٍ باستمرار قد يميل العمود الفقريّ ويسبّب اعوجاجًا في الظهر؛ لذلك يُنصح بتوزيع الحمل على الكتفين. الفخّ الشائع نسبة آثارٍ غير واقعيّة (نموّ الجمجمة، توقّف القلب).', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('79b3b49e-6caf-5311-93ac-6f1789112509', '8dcf5083-2cac-50e7-83ce-a709d54fb1ff', 'في الصورة ثلاثة عظام (1 ; 2 ; 3). أيّها العظم المسطّح؟ <svg viewBox="0 0 220 90" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="3"><rect x="20" y="16" width="14" height="54" rx="5" fill="#fde68a"/><circle cx="27" cy="14" r="7" fill="#fde68a"/><circle cx="27" cy="72" r="7" fill="#fde68a"/></g><text x="40" y="46" font-size="12" fill="#1f2937">1</text><rect x="95" y="34" width="26" height="24" rx="5" fill="#fcd34d" stroke="#1f2937" stroke-width="3"/><text x="104" y="78" font-size="12" fill="#1f2937">2</text><ellipse cx="180" cy="45" rx="34" ry="20" fill="#fef3c7" stroke="#1f2937" stroke-width="3"/><text x="176" y="80" font-size="12" fill="#1f2937">3</text></svg>', '[{"id":"a","text":"العظم رقم 3 (المنبسط)"},{"id":"b","text":"لا يوجد عظمٌ مسطّح"},{"id":"c","text":"العظم رقم 1 (الطويل)"},{"id":"d","text":"العظم رقم 2 (القصير)"}]'::jsonb, 'a', 'العظم 3 رقيقٌ ومنبسط (شكلٌ بيضويّ مسطّح) فهو المسطّح. العظم 1 طويل والعظم 2 قصير (شبه مكعّب).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('27ee852d-3db4-59e5-bc16-b51ecf6358a7', '17b55ae5-b632-5d69-9251-dcfca34e09b2', 'eveil-scientifique-5eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملةٌ للهيكل العظميّ', 3, 120, 30, 'boss', 'admin', 5)
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
  ('13e8e302-0735-5d4a-99be-659d8f5bb5a9', '27ee852d-3db4-59e5-bc16-b51ecf6358a7', 'وظائف الهيكل العظميّ الثلاث هي:', '[{"id":"a","text":"الدعم والحماية والحركة"},{"id":"b","text":"الهضم والتنفّس والإبصار"},{"id":"c","text":"السمع والشمّ والذوق"},{"id":"d","text":"التذوّق واللمس والكلام"}]'::jsonb, 'a', 'الهيكل العظميّ يدعم الجسم ويحمي الأعضاء ويساعد على الحركة؛ هذه وظائفه الثلاث.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0eaa1b47-4408-5e90-b1b5-668923e01eee', '27ee852d-3db4-59e5-bc16-b51ecf6358a7', 'أيّ مجموعةٍ كلّها عظامٌ مسطّحة؟', '[{"id":"a","text":"عظم الفخذ، عظم الذراع"},{"id":"b","text":"عظام الجمجمة، عظم الكتف، الأضلاع"},{"id":"c","text":"عظام الرسغ، عظام القدم"},{"id":"d","text":"عظم الساق، عظم الفخذ"}]'::jsonb, 'b', 'عظام الجمجمة وعظم الكتف والأضلاع رقيقةٌ منبسطة فهي مسطّحة. (أ) و(د) عظامٌ طويلة، و(ج) قصيرة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d5c7e832-0200-54fe-8e96-4dffc5acca33', '27ee852d-3db4-59e5-bc16-b51ecf6358a7', 'نلمس صدرنا فنحسّ بأضلاعٍ صلبة. ما دورها؟', '[{"id":"a","text":"تنقية الدم"},{"id":"b","text":"سماع الأصوات"},{"id":"c","text":"حماية القلب والرئتين داخل القفص الصدريّ"},{"id":"d","text":"هضم الطعام في الصدر"}]'::jsonb, 'c', 'الأضلاع تكوّن القفص الصدريّ الذي يحيط بالقلب والرئتين فيحميهما من الصدمات.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d8166c15-0de4-5687-b2cf-bddf59edd74f', '27ee852d-3db4-59e5-bc16-b51ecf6358a7', 'لماذا نحتاج إلى الكالسيوم في غذائنا؟', '[{"id":"a","text":"لأنّه يليّن العظام"},{"id":"b","text":"لأنّه يوقف نموّ العظام"},{"id":"c","text":"لأنّه يحوّل العظام إلى عضلات"},{"id":"d","text":"لأنّه يقوّي العظام ويجعلها صلبة"}]'::jsonb, 'd', 'الكالسيوم (الموجود في الحليب والأجبان) يقوّي العظام ويجعلها صلبة؛ لذلك يهمّ غذاؤنا أن يحتوي عليه.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fbdde263-35e4-59fa-8632-277f52e21e19', '27ee852d-3db4-59e5-bc16-b51ecf6358a7', 'أيّ عبارةٍ صحيحةٌ عن العمود الفقريّ؟', '[{"id":"a","text":"عضلةٌ تحرّك القلب"},{"id":"b","text":"سلسلة عظامٍ في الظهر تحمل الجسم وتحمي النّخاع الشوكيّ"},{"id":"c","text":"عظمٌ واحدٌ طويلٌ في الذراع"},{"id":"d","text":"عضوٌ ليّنٌ يهضم الطعام"}]'::jsonb, 'b', 'العمود الفقريّ سلسلةٌ من العظام في الظهر تدعم الجسم وتحمي النّخاع الشوكيّ بداخلها.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c8cdc8e-6b81-5311-b104-8556d5aca473', '27ee852d-3db4-59e5-bc16-b51ecf6358a7', 'رتّب التصنيف الصحيح حسب الشكل:', '[{"id":"a","text":"طويل: طوله أكبر من عرضه — قصير: طوله قريبٌ من عرضه — مسطّح: رقيقٌ منبسط"},{"id":"b","text":"طويل: رقيقٌ منبسط — قصير: طوله أكبر من عرضه — مسطّح: مكعّب"},{"id":"c","text":"طويل: مكعّب — قصير: منبسط — مسطّح: ممتدّ"},{"id":"d","text":"كلّها بالحجم: الكبير طويل والصغير مسطّح"}]'::jsonb, 'a', 'التصنيف بالشكل: العظم الطويل طوله أكبر من عرضه، والقصير طوله قريبٌ من عرضه، والمسطّح رقيقٌ منبسط. هذا هو التصنيف الصحيح.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ed17a50f-fb98-5ae8-834c-94ae05b8d79b', 'a7133914-32d3-5cea-8555-449857501380', 'eveil-scientifique-5eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('42156446-ce09-5b2d-9e0f-9df1832546c0', 'ed17a50f-fb98-5ae8-834c-94ae05b8d79b', 'ما الذي يحرّك العظام في الجسم؟', '[{"id":"a","text":"العضلات"},{"id":"b","text":"الجلد"},{"id":"c","text":"الدم"},{"id":"d","text":"الشعر"}]'::jsonb, 'a', 'العضلات تلتصق بالعظام وتحرّكها عندما تنقبض وتنبسط.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3055911e-e178-5ef9-a4c8-a900c0a8f162', 'ed17a50f-fb98-5ae8-834c-94ae05b8d79b', 'عندما تنقبض العضلة فإنّها:', '[{"id":"a","text":"تطول وتسترخي"},{"id":"b","text":"تقصر وتنتفخ فتشدّ العظم"},{"id":"c","text":"تختفي تمامًا"},{"id":"d","text":"تتحوّل إلى عظم"}]'::jsonb, 'b', 'عند الانقباض تقصر العضلة وتنتفخ، فتشدّ العظم وتحرّكه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('09127134-3194-5508-848c-8d6ceb6ff44a', 'ed17a50f-fb98-5ae8-834c-94ae05b8d79b', 'ما هو المفصل؟', '[{"id":"a","text":"عضلةٌ كبيرة"},{"id":"b","text":"عظمٌ طويل"},{"id":"c","text":"موضع التقاء عظمين يسمح بالحركة"},{"id":"d","text":"وعاءٌ ينقل الدم"}]'::jsonb, 'c', 'المفصل هو موضع التقاء عظمين، ويسمح بالحركة بينهما مثل الركبة والمرفق.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f62cd9d3-cd1f-5d8f-b256-13c7aa5f96e9', 'ed17a50f-fb98-5ae8-834c-94ae05b8d79b', 'ما الذي يربط العضلة بالعظم؟', '[{"id":"a","text":"الجلد"},{"id":"b","text":"الوتر"},{"id":"c","text":"الشعر"},{"id":"d","text":"الدم"}]'::jsonb, 'b', 'الوتر حبلٌ قويٌّ يربط العضلة بالعظم، فينقل شدّ العضلة إلى العظم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('af70ec5b-d1e4-5286-8946-9ea552ff6037', 'ed17a50f-fb98-5ae8-834c-94ae05b8d79b', 'في الصورة ذراعٌ مثنيّة. أين العضلة المنقبضة المنتفخة؟ <svg viewBox="0 0 170 150" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="4" fill="none"><line x1="40" y1="20" x2="40" y2="80"/><line x1="40" y1="80" x2="95" y2="50"/></g><circle cx="40" cy="80" r="6" fill="#ef4444" stroke="#1f2937" stroke-width="2"/><text x="10" y="86" font-size="12" fill="#1f2937">2</text><path d="M44 30 q22 14 18 40 q-10 6 -18 -2 q-6 -22 0 -38 z" fill="#f87171" stroke="#1f2937" stroke-width="2"/><text x="70" y="96" font-size="12" fill="#1f2937">1</text></svg>', '[{"id":"a","text":"الموضع رقم 1 (العضلة المنتفخة)"},{"id":"b","text":"الموضع رقم 2 (المفصل)"},{"id":"c","text":"لا توجد عضلة"},{"id":"d","text":"العظم المستقيم"}]'::jsonb, 'a', 'الموضع 1 هو العضلة المنتفخة التي انقبضت فثنت الذراع. أمّا الموضع 2 (النقطة الحمراء) فهو المفصل (المرفق) الذي يلتقي عنده العظمان.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('63621775-0398-57bd-9dc5-ad13b32453ac', 'a7133914-32d3-5cea-8555-449857501380', 'eveil-scientifique-5eme', '⭐ تمرين: كيف يتحرّك جسمي؟', 1, 50, 10, 'practice', 'admin', 1)
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
  ('ce8c58c8-5616-51b3-a144-6fa25d63912d', '63621775-0398-57bd-9dc5-ad13b32453ac', 'العضلة نسيجٌ:', '[{"id":"a","text":"ليّنٌ قويّ يلتصق بالعظام"},{"id":"b","text":"صلبٌ كالعظم"},{"id":"c","text":"سائلٌ كالدم"},{"id":"d","text":"شفّافٌ كالزجاج"}]'::jsonb, 'a', 'العضلة نسيجٌ ليّنٌ قويّ يلتصق بالعظام ويحرّكها.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43f1d3f8-d4da-5d54-8341-aa29fa1f1882', '63621775-0398-57bd-9dc5-ad13b32453ac', 'أثني ركبتي بفضل:', '[{"id":"a","text":"الجلد"},{"id":"b","text":"مفصل الركبة"},{"id":"c","text":"الشعر"},{"id":"d","text":"الدم"}]'::jsonb, 'b', 'مفصل الركبة هو موضع التقاء العظمين الذي يسمح بثني الساق.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea2af380-b6bd-5e98-b667-a895ac18aab7', '63621775-0398-57bd-9dc5-ad13b32453ac', 'الحبل الذي يربط العضلة بالعظم هو:', '[{"id":"a","text":"العصب"},{"id":"b","text":"الوريد"},{"id":"c","text":"الوتر"},{"id":"d","text":"الشريان"}]'::jsonb, 'c', 'الوتر حبلٌ قويٌّ يربط العضلة بالعظم وينقل إليه شدّ العضلة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5570ae11-4a4a-551f-b820-6633d7800771', '63621775-0398-57bd-9dc5-ad13b32453ac', 'عندما تنبسط العضلة فإنّها:', '[{"id":"a","text":"تتحوّل إلى عظم"},{"id":"b","text":"تختفي"},{"id":"c","text":"تقصر وتنتفخ"},{"id":"d","text":"تطول وتسترخي"}]'::jsonb, 'd', 'عند الانبساط تطول العضلة وتسترخي فتعود إلى وضعها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('24dd109e-4e9e-541e-a431-021be5dcdf0a', '63621775-0398-57bd-9dc5-ad13b32453ac', 'أين يوجد مفصل المرفق؟', '[{"id":"a","text":"في الأنف"},{"id":"b","text":"في الذراع، حيث نثني الكوع"},{"id":"c","text":"في الرأس"},{"id":"d","text":"في البطن"}]'::jsonb, 'b', 'مفصل المرفق (الكوع) في الذراع، وبه نثني الذراع ونمدّها.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9625763e-e050-5b7a-83e0-0f21db7f9c1f', '63621775-0398-57bd-9dc5-ad13b32453ac', 'أيّ عبارةٍ صحيحة؟', '[{"id":"a","text":"الانثناء يحدث عند المفصل لا في العظم"},{"id":"b","text":"الجلد هو الذي يحرّك العظام"},{"id":"c","text":"العضلات صلبةٌ لا تتحرّك"},{"id":"d","text":"العظم نفسه ينثني في وسطه"}]'::jsonb, 'a', 'العظم صلبٌ لا ينثني؛ الانثناء يحدث عند المفصل حيث يلتقي عظمان، وتحرّكهما العضلات.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f1af9a4d-d024-5fb1-9bb4-7a8a6c3de405', 'a7133914-32d3-5cea-8555-449857501380', 'eveil-scientifique-5eme', '⚔️ زعيم الفصل ⭐⭐⭐: سيّدُ الحركة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('68e2fc68-ac24-5b51-bd23-5d6730207a62', 'f1af9a4d-d024-5fb1-9bb4-7a8a6c3de405', 'عندما أثني ذراعي، ماذا يحدث للعضلة ذات الرأسين في أعلى الذراع؟', '[{"id":"a","text":"تنقبض وتنتفخ فترفع الساعد"},{"id":"b","text":"تختفي"},{"id":"c","text":"تتحوّل إلى عظم"},{"id":"d","text":"تنبسط وتطول"}]'::jsonb, 'a', 'عند ثني الذراع تنقبض العضلة ذات الرأسين فتقصر وتنتفخ، فتشدّ الساعد وترفعه. الخطأ الشائع توهّم أنّها تنبسط أثناء الثني.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de1500ad-6657-57cc-8984-2823d5394981', 'f1af9a4d-d024-5fb1-9bb4-7a8a6c3de405', 'رتّب مراحل حركة الطرف بالترتيب الصحيح:', '[{"id":"a","text":"يضخّ الدم ← يتحرّك المفصل ← تنبسط العضلة"},{"id":"b","text":"تنقبض العضلة ← يشدّ الوتر العظم ← يتحرّك العظم حول المفصل"},{"id":"c","text":"ينثني العظم ← تنقبض العضلة ← يختفي المفصل"},{"id":"d","text":"يشدّ الجلد العظم ← تسترخي العضلة ← لا حركة"}]'::jsonb, 'b', 'الحركة تحدث هكذا: تنقبض العضلة فتنتفخ ← يشدّ الوتر العظم ← يتحرّك العظم حول المفصل. هذا هو الترتيب الصحيح للتعاون بينها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b2dc0604-a9e3-592d-9846-3c55b08c8172', 'f1af9a4d-d024-5fb1-9bb4-7a8a6c3de405', 'تلميذٌ قال: «العظم نفسه ينثني عند الركبة.» أين الخطأ؟', '[{"id":"a","text":"الخطأ أنّ الجلد ينثني"},{"id":"b","text":"لا خطأ، فالعظم ينثني فعلًا"},{"id":"c","text":"الخطأ أنّ العظم صلبٌ لا ينثني؛ الانثناء يحدث عند مفصل الركبة حيث يلتقي عظمان"},{"id":"d","text":"الخطأ أنّ العضلة هي التي تنثني"}]'::jsonb, 'c', 'العظم صلبٌ لا ينثني في وسطه؛ الانثناء يحدث عند المفصل (الركبة) الذي يلتقي عنده عظمان وتحرّكهما العضلات. هذا هو الخطأ الشائع.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1a15c6a-9e0d-544f-8f23-d378680a96a3', 'f1af9a4d-d024-5fb1-9bb4-7a8a6c3de405', 'ما دور الوتر في الحركة؟', '[{"id":"a","text":"يضخّ الدم إلى العضلة"},{"id":"b","text":"ينقّي الهواء قبل العضلة"},{"id":"c","text":"يحوّل العظم إلى عضلة"},{"id":"d","text":"ينقل شدّ العضلة المنقبضة إلى العظم فيتحرّك"}]'::jsonb, 'd', 'الوتر يربط العضلة بالعظم؛ فعندما تنقبض العضلة يشدّ الوتر العظم فيتحرّك. لولا الوتر لما وصل شدّ العضلة إلى العظم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('50038235-16ba-5e80-9898-bde3c81bd957', 'f1af9a4d-d024-5fb1-9bb4-7a8a6c3de405', 'لماذا نُحمّي عضلاتنا (تمارين خفيفة) قبل ممارسة الرياضة بقوّة؟', '[{"id":"a","text":"لجعل العظام ليّنة"},{"id":"b","text":"لتجهيز العضلات والمفاصل وتقليل خطر الإصابة"},{"id":"c","text":"لتحويل العضلات إلى عظام"},{"id":"d","text":"لإيقاف عمل المفاصل"}]'::jsonb, 'b', 'التحمية تجهّز العضلات والأوتار والمفاصل للجهد، فتقلّ احتمالات الشدّ والإصابة. الفخّ الشائع نسبة آثارٍ غير واقعيّة للتحمية.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29a7266d-b707-538f-a4c0-f8005ee61359', 'f1af9a4d-d024-5fb1-9bb4-7a8a6c3de405', 'أيّ زوجٍ صحيحٌ (مفصل ← حركته)؟', '[{"id":"a","text":"مفصل الركبة ← ثني الساق"},{"id":"b","text":"مفصل الركبة ← مضغ الطعام"},{"id":"c","text":"مفصل المرفق ← ضخّ الدم"},{"id":"d","text":"مفصل الكتف ← هضم الطعام"}]'::jsonb, 'a', 'مفصل الركبة يسمح بثني الساق ومدّها، وهذا الزوج صحيح. باقي الأزواج تنسب وظائف أعضاء أخرى إلى المفاصل.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('f1072900-0f98-5a0a-aa47-7589a3f6a689', 'a7133914-32d3-5cea-8555-449857501380', 'eveil-scientifique-5eme', '⭐⭐ تمرين مراجعة (نمط امتحان): العضلاتُ والمفاصل', 2, 75, 15, 'practice', 'admin', 3)
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
  ('61201b5a-f6ed-5106-8c7d-9fd173bda9aa', 'f1072900-0f98-5a0a-aa47-7589a3f6a689', 'أيّ زوجٍ صحيحٌ (عنصر ← دوره)؟', '[{"id":"a","text":"العضلة ← تنقبض فتحرّك العظم"},{"id":"b","text":"العظم ← ينثني في وسطه"},{"id":"c","text":"المفصل ← يضخّ الدم"},{"id":"d","text":"الوتر ← ينقّي الهواء"}]'::jsonb, 'a', 'العضلة تنقبض فتشدّ العظم وتحرّكه، وهذا دورها الصحيح. باقي الأزواج خاطئة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('823b4d98-da11-59b6-85df-ff56f51e24a3', 'f1072900-0f98-5a0a-aa47-7589a3f6a689', 'مفصل الكتف يسمح بـ:', '[{"id":"a","text":"تذوّق الطعام"},{"id":"b","text":"إدارة الذراع في كلّ الجهات"},{"id":"c","text":"هضم الطعام"},{"id":"d","text":"سماع الأصوات"}]'::jsonb, 'b', 'مفصل الكتف مفصلٌ واسع الحركة يسمح بإدارة الذراع في مختلف الجهات.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d5f61126-f3db-5274-a123-4b0135e53ab6', 'f1072900-0f98-5a0a-aa47-7589a3f6a689', 'لماذا لا تحدث الحركة بعضلةٍ وحدها دون عظمٍ ومفصل؟', '[{"id":"a","text":"لأنّ العضلة صلبة"},{"id":"b","text":"لأنّ العظم يحرّك نفسه"},{"id":"c","text":"لأنّ العضلة تحتاج عظمًا تشدّه ومفصلًا يدور حوله العظم"},{"id":"d","text":"لأنّ العضلة لا تنقبض أبدًا"}]'::jsonb, 'c', 'الحركة تعاونٌ: العضلة تشدّ العظم بواسطة الوتر، والعظم يتحرّك حول المفصل؛ فلا حركة بعنصرٍ واحدٍ وحده.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f1537f48-8039-586c-afe9-96fe5a50c1bb', 'f1072900-0f98-5a0a-aa47-7589a3f6a689', 'عند رفع الأعقاب أثناء المشي، أيّ وترٍ يعمل فوق الكعب؟', '[{"id":"a","text":"وترٌ في الرأس"},{"id":"b","text":"وترٌ في الأنف"},{"id":"c","text":"لا يوجد وتر"},{"id":"d","text":"وتر العرقوب الذي يربط عضلة الساق بعظم الكعب"}]'::jsonb, 'd', 'وتر العرقوب فوق الكعب يربط عضلة الساق بعظم الكعب؛ فعند انقباض العضلة يشدّ الوتر الكعب فنرفع أعقابنا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a0da3fd-b0a0-5b0f-aee2-06b469f62344', 'f1072900-0f98-5a0a-aa47-7589a3f6a689', 'أيّ سلوكٍ يحافظ على العضلات والمفاصل؟', '[{"id":"a","text":"حمل أوزانٍ أثقل من الطاقة فجأة"},{"id":"b","text":"ممارسة الرياضة بانتظامٍ مع التحمية"},{"id":"c","text":"عدم الحركة إطلاقًا"},{"id":"d","text":"الجلوس بوضعيّةٍ ملتوية دائمًا"}]'::jsonb, 'b', 'الرياضة المنتظمة مع التحمية تقوّي العضلات وتحافظ على مرونة المفاصل، بعكس الحمل المفاجئ الثقيل أو قلّة الحركة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3f7a7a1c-3b77-5703-a4b8-b57ab035868a', 'f1072900-0f98-5a0a-aa47-7589a3f6a689', 'في الصورة موضعان على الساق: 1 عند الركبة و2 على العضلة. أيّهما المفصل؟ <svg viewBox="0 0 130 160" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="5" fill="none"><line x1="55" y1="15" x2="55" y2="75"/><line x1="55" y1="75" x2="70" y2="145"/></g><circle cx="55" cy="75" r="7" fill="#22c55e" stroke="#1f2937" stroke-width="2"/><text x="66" y="80" font-size="12" fill="#1f2937">1</text><path d="M40 25 q-12 22 -4 44 q8 6 12 -2 q4 -22 -2 -42 z" fill="#f87171" stroke="#1f2937" stroke-width="2"/><text x="14" y="50" font-size="12" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"الموضع رقم 1 (الركبة)"},{"id":"b","text":"الموضع رقم 2 (العضلة)"},{"id":"c","text":"لا يوجد مفصل"},{"id":"d","text":"كلاهما عضلة"}]'::jsonb, 'a', 'الموضع 1 (النقطة الخضراء عند التقاء العظمين) هو مفصل الركبة. أمّا الموضع 2 فهو العضلة الملتصقة بالعظم.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('0ccd5016-4053-557e-95fc-d819d59e3b21', 'a7133914-32d3-5cea-8555-449857501380', 'eveil-scientifique-5eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: عبقريُّ الحركة', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('5bb160b6-4204-56b4-b705-9f370b243dcf', '0ccd5016-4053-557e-95fc-d819d59e3b21', 'أكمل: لرفع الساعد .......... العضلة الأماميّة، ولمدّ الذراع .......... هذه العضلة وتعمل الأخرى.', '[{"id":"a","text":"تنقبض / تنبسط"},{"id":"b","text":"تنبسط / تنقبض"},{"id":"c","text":"تختفي / تظهر"},{"id":"d","text":"تتصلّب / تذوب"}]'::jsonb, 'a', 'لرفع الساعد تنقبض العضلة الأماميّة فتشدّه، ولمدّ الذراع تنبسط هذه العضلة بينما تنقبض العضلة المقابلة. هذا هو التتابع الصحيح.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c81bd642-fb9c-5e96-8995-c287102c8f6a', '0ccd5016-4053-557e-95fc-d819d59e3b21', 'بعد كسرٍ في الذراع وتثبيتها بالجبس أسابيع، تبدو العضلة أنحف عند نزع الجبس. لماذا؟', '[{"id":"a","text":"لأنّ العضلة ذابت في الدم"},{"id":"b","text":"لأنّ العضلة لم تتحرّك مدّةً فضعفت وصغرت، وتعود بالتمرين"},{"id":"c","text":"لأنّ العضلة تحوّلت إلى عظم"},{"id":"d","text":"لأنّ العضلة انتقلت إلى مكانٍ آخر"}]'::jsonb, 'b', 'العضلة التي لا تتحرّك مدّةً تضعف ويقلّ حجمها؛ ومع العودة إلى التمرين تقوى وتكبر من جديد. الفخّ الشائع توهّم تحوّلها إلى عظمٍ أو اختفائها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7aa2021b-545d-561f-84ad-eca1cdaddf7c', '0ccd5016-4053-557e-95fc-d819d59e3b21', 'لماذا نستطيع تحريك أصابعنا في اتّجاهاتٍ كثيرة بينما عظم الإصبع نفسه صلب؟', '[{"id":"a","text":"لأنّ الجلد يطوي العظم"},{"id":"b","text":"لأنّ الدم يثني العظم"},{"id":"c","text":"لأنّ الإصبع فيه عدّة مفاصل بين عظامٍ صغيرة، وتحرّكها عضلاتٌ وأوتار"},{"id":"d","text":"لأنّ عظم الإصبع ليّنٌ ينثني"}]'::jsonb, 'c', 'الإصبع يضمّ عظامًا صغيرةً يفصل بينها عدّة مفاصل، وتحرّكها عضلاتٌ وأوتار، فيمكن ثنيه في مواضع كثيرة رغم صلابة كلّ عظم. الخطأ الشائع ظنّ أنّ العظم نفسه ينثني.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ed6abf32-ce3d-5e2f-b8f3-b6f2f668d614', '0ccd5016-4053-557e-95fc-d819d59e3b21', 'يقفز لاعبٌ ثمّ ينزل. ما العناصر التي تعاونت لتحريك ساقه؟', '[{"id":"a","text":"الجلد وحده يحرّك الساق"},{"id":"b","text":"الدم وحده يرفع الساق"},{"id":"c","text":"العظام تنثني في وسطها بلا عضلات"},{"id":"d","text":"العضلات تنقبض، والأوتار تشدّ العظام، والعظام تتحرّك حول المفاصل"}]'::jsonb, 'd', 'القفز حركةٌ معقّدة تعاونت فيها العضلات (الانقباض) والأوتار (شدّ العظام) والعظام والمفاصل (الدوران)؛ لا يكفي عنصرٌ واحدٌ وحده. هذا هو التفسير الصحيح.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44866cf3-500c-51a3-9163-dd1c9f4c465d', '0ccd5016-4053-557e-95fc-d819d59e3b21', 'تلميذٌ قال: «أحرّك يدي بالجلد فقط دون عضلات.» أين الخطأ؟', '[{"id":"a","text":"الخطأ أنّ الدم يحرّك اليد"},{"id":"b","text":"الخطأ أنّ العضلات هي التي تحرّك العظام؛ الجلد غطاءٌ لا يحرّكها"},{"id":"c","text":"لا خطأ، فالجلد يحرّك اليد"},{"id":"d","text":"الخطأ أنّ العظام تتحرّك وحدها"}]'::jsonb, 'b', 'الجلد غطاءٌ خارجيّ لا يحرّك العظام؛ الحركة تتمّ بانقباض العضلات التي تشدّ العظام بواسطة الأوتار. هذا هو الخطأ الشائع: نسبة الحركة إلى الجلد.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6ca7fc99-3799-51f6-9edc-dd88454f667a', '0ccd5016-4053-557e-95fc-d819d59e3b21', 'في الصورة ذراعان: في 1 العضلة منتفخة والذراع مثنيّة، وفي 2 العضلة مسترخية والذراع ممدودة. أيّهما يمثّل انقباض العضلة؟ <svg viewBox="0 0 230 140" xmlns="http://www.w3.org/2000/svg"><g stroke="#1f2937" stroke-width="4" fill="none"><line x1="30" y1="20" x2="30" y2="70"/><line x1="30" y1="70" x2="75" y2="45"/></g><path d="M34 28 q20 12 16 34 q-9 5 -16 -2 q-5 -20 0 -32 z" fill="#ef4444" stroke="#1f2937" stroke-width="2"/><text x="40" y="95" font-size="13" fill="#1f2937">1</text><g stroke="#1f2937" stroke-width="4" fill="none"><line x1="150" y1="20" x2="150" y2="70"/><line x1="150" y1="70" x2="150" y2="120"/></g><path d="M137 30 q-7 30 0 60 q7 4 12 0 q5 -30 0 -60 q-6 -3 -12 0 z" fill="#fca5a5" stroke="#1f2937" stroke-width="2"/><text x="158" y="95" font-size="13" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"الذراع رقم 1 (العضلة منتفخة، الذراع مثنيّة)"},{"id":"b","text":"الذراع رقم 2 (العضلة مسترخية، الذراع ممدودة)"},{"id":"c","text":"كلاهما انبساط"},{"id":"d","text":"لا فرق بينهما"}]'::jsonb, 'a', 'الانقباض يجعل العضلة تقصر وتنتفخ فتثني الذراع، وهذا حال الذراع 1. أمّا الذراع 2 فالعضلة فيها مسترخية ممدودة (انبساط).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('003875d2-eb6b-59db-85ae-35dac548c9df', 'a7133914-32d3-5cea-8555-449857501380', 'eveil-scientifique-5eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملةٌ للحركة', 3, 120, 30, 'boss', 'admin', 5)
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
  ('428b5bfc-ac86-5912-a11d-98723f0feba6', '003875d2-eb6b-59db-85ae-35dac548c9df', 'العناصر التي تتعاون لإحداث الحركة هي:', '[{"id":"a","text":"العضلات والأوتار والعظام والمفاصل"},{"id":"b","text":"الجلد والشعر والأظافر"},{"id":"c","text":"الدم والهواء والماء"},{"id":"d","text":"العين والأذن والأنف"}]'::jsonb, 'a', 'الحركة تعاونٌ بين العضلات (تنقبض) والأوتار (تشدّ العظام) والعظام والمفاصل (تدور حولها العظام).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a269d132-3aa2-51a7-a5ab-7a25b04f9d4f', '003875d2-eb6b-59db-85ae-35dac548c9df', 'أيّ جملةٍ صحيحةٌ عن الانقباض والانبساط؟', '[{"id":"a","text":"كلاهما يحوّل العضلة إلى عظم"},{"id":"b","text":"الانقباض: العضلة تقصر وتنتفخ — الانبساط: العضلة تطول وتسترخي"},{"id":"c","text":"الانقباض: العضلة تطول — الانبساط: العضلة تنتفخ"},{"id":"d","text":"كلاهما يعني اختفاء العضلة"}]'::jsonb, 'b', 'في الانقباض تقصر العضلة وتنتفخ فتشدّ العظم، وفي الانبساط تطول وتسترخي. هذا هو التعريف الصحيح.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ecdffe3a-7a00-57f6-9751-913fe367efb8', '003875d2-eb6b-59db-85ae-35dac548c9df', 'لماذا يصعب على عظمٍ بلا مفصلٍ أن يؤدّي حركةً مثل ثني الذراع؟', '[{"id":"a","text":"لأنّ المفصل يضخّ الدم"},{"id":"b","text":"لأنّ العظم يحتاج إلى جلدٍ سميك"},{"id":"c","text":"لأنّ العظم صلبٌ لا ينثني، والانثناء يحتاج مفصلًا يلتقي عنده عظمان"},{"id":"d","text":"لأنّ العظم ليّنٌ ينثني وحده"}]'::jsonb, 'c', 'العظم صلبٌ لا ينثني في وسطه؛ الثني يحتاج إلى مفصلٍ يلتقي عنده عظمان وتحرّكهما العضلات. لذلك لا حركة ثنيٍ بلا مفصل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('06e27276-803c-50ba-9423-b1a5fb965eb9', '003875d2-eb6b-59db-85ae-35dac548c9df', 'ما الفرق بين الوتر والمفصل؟', '[{"id":"a","text":"الوتر موضع التقاء عظمين، والمفصل يربط العضلة بالعظم"},{"id":"b","text":"كلاهما عضلة"},{"id":"c","text":"كلاهما عظمٌ طويل"},{"id":"d","text":"الوتر يربط العضلة بالعظم، والمفصل موضع التقاء عظمين"}]'::jsonb, 'd', 'الوتر حبلٌ يربط العضلة بالعظم لينقل شدّها، أمّا المفصل فموضع التقاء عظمين يسمح بالحركة بينهما. لكلٍّ دورٌ مختلف.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8801050f-e3db-55e8-9438-aab34c0a22e3', '003875d2-eb6b-59db-85ae-35dac548c9df', 'أيّ سلوكٍ يحمي عضلاتك ومفاصلك أثناء الرياضة؟', '[{"id":"a","text":"تجنّب الحركة تمامًا"},{"id":"b","text":"البدء بتمارين تحميةٍ خفيفة قبل الجهد الكبير"},{"id":"c","text":"حمل أثقل وزنٍ ممكنٍ من أوّل لحظة"},{"id":"d","text":"ثني المفاصل بعنفٍ مفاجئ"}]'::jsonb, 'b', 'التحمية الخفيفة تجهّز العضلات والأوتار والمفاصل تدريجيًّا، فتقلّ الإصابات. أمّا الجهد المفاجئ العنيف فيزيد خطر الشدّ والإصابة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('703b29d4-6187-5c61-b7e7-1e948e3ed137', '003875d2-eb6b-59db-85ae-35dac548c9df', 'رتّب ما يحدث عند ثني الذراع بالترتيب الصحيح:', '[{"id":"a","text":"تنقبض عضلة الذراع وتنتفخ ← يشدّ الوتر عظم الساعد ← يدور الساعد حول مفصل المرفق فيرتفع"},{"id":"b","text":"ينثني عظم الساعد ← تختفي العضلة ← لا مفصل"},{"id":"c","text":"يشدّ الجلد العظم ← يضخّ الدم ← لا حركة"},{"id":"d","text":"يتحرّك المفصل وحده دون عضلة"}]'::jsonb, 'a', 'عند ثني الذراع: تنقبض العضلة وتنتفخ ← يشدّ الوتر عظم الساعد ← يدور الساعد حول مفصل المرفق فيرتفع. هذا هو الترتيب الصحيح للتعاون.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('97e79ea7-a018-5629-a456-d872e047f2c1', '2c985fde-3a73-5c2e-806f-954d6535f701', 'eveil-scientifique-5eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('79fd2605-2d65-511d-a0d3-2ec305796a05', '97e79ea7-a018-5629-a456-d872e047f2c1', 'ما الغاز المفيد الذي يأخذه الجسم من الهواء؟', '[{"id":"a","text":"الأكسجين"},{"id":"b","text":"غاز الفحم"},{"id":"c","text":"بخار الماء"},{"id":"d","text":"الدخان"}]'::jsonb, 'a', 'يأخذ الجسم من الهواء الأكسجين، وهو الغاز المفيد اللازم للحياة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0cce210c-4d3b-55b7-b37f-53f73cb79496', '97e79ea7-a018-5629-a456-d872e047f2c1', 'أيّ عضوٍ من أعضاء الجهاز التنفّسيّ يوجد في الصدر؟', '[{"id":"a","text":"اللسان"},{"id":"b","text":"الرئتان"},{"id":"c","text":"المعدة"},{"id":"d","text":"العين"}]'::jsonb, 'b', 'الرئتان عضوان إسفنجيّان في الصدر، فيهما يأخذ الجسم الأكسجين ويطرح غاز الفحم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('54313504-0f37-5d14-ad8f-8bb36761b69d', '97e79ea7-a018-5629-a456-d872e047f2c1', 'ماذا يحدث للصدر أثناء الشهيق؟', '[{"id":"a","text":"يختفي"},{"id":"b","text":"ينكمش"},{"id":"c","text":"ينتفخ"},{"id":"d","text":"لا يتغيّر"}]'::jsonb, 'c', 'أثناء الشهيق يدخل الهواء إلى الرئتين فينتفخ الصدر.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b74bb4ca-c839-58ab-91b1-9ea969c4512a', '97e79ea7-a018-5629-a456-d872e047f2c1', 'الهواء الذي نُخرجه في الزفير يكون غنيًّا بـ:', '[{"id":"a","text":"الغبار"},{"id":"b","text":"الأكسجين فقط"},{"id":"c","text":"الماء النقيّ"},{"id":"d","text":"غاز الفحم"}]'::jsonb, 'd', 'هواء الزفير فقد كثيرًا من الأكسجين وامتلأ بغاز الفحم الذي طرحه الجسم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('10b170e6-c535-58f0-8c93-158bfc744a38', '97e79ea7-a018-5629-a456-d872e047f2c1', 'في الصورة جهازٌ تنفّسيّ مبسّط. ما العضوان الإسفنجيّان (رقم 2) اللذان يحدث فيهما التبادل؟ <svg viewBox="0 0 140 170" xmlns="http://www.w3.org/2000/svg"><line x1="70" y1="15" x2="70" y2="75" stroke="#1f2937" stroke-width="6"/><text x="78" y="45" font-size="12" fill="#1f2937">1</text><path d="M66 75 q-34 6 -34 50 q0 26 18 30 q14 2 16 -14 z" fill="#fca5a5" stroke="#1f2937" stroke-width="3"/><path d="M74 75 q34 6 34 50 q0 26 -18 30 q-14 2 -16 -14 z" fill="#fca5a5" stroke="#1f2937" stroke-width="3"/><text x="30" y="120" font-size="12" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"العضو رقم 1 (الرّغامى)"},{"id":"b","text":"العضوان رقم 2 (الرئتان)"},{"id":"c","text":"لا يوجد تبادل"},{"id":"d","text":"الأنف فقط"}]'::jsonb, 'b', 'العضوان رقم 2 هما الرئتان، وفيهما يأخذ الدم الأكسجين ويتخلّص من غاز الفحم. أمّا رقم 1 فهو الرّغامى التي تنقل الهواء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a41fcdb4-0774-5608-991b-f702474991f5', '2c985fde-3a73-5c2e-806f-954d6535f701', 'eveil-scientifique-5eme', '⭐ تمرين: أتنفّس فأحيا', 1, 50, 10, 'practice', 'admin', 1)
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
  ('ca4a0290-b7b2-59a0-b7df-ed65bc7dc6f1', 'a41fcdb4-0774-5608-991b-f702474991f5', 'من أيّ عضوٍ يدخل الهواء أوّلًا فيُصفّى ويُدفّأ؟', '[{"id":"a","text":"الأنف"},{"id":"b","text":"المعدة"},{"id":"c","text":"العين"},{"id":"d","text":"اليد"}]'::jsonb, 'a', 'يدخل الهواء من الأنف أوّلًا، فيُصفّى من الغبار ويُدفّأ قبل أن يصل الرئتين.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('adbfc2a8-e3d5-5dc9-a7a3-67891edeaf56', 'a41fcdb4-0774-5608-991b-f702474991f5', 'الغاز الذي يطرده الجسم في الزفير هو:', '[{"id":"a","text":"الأكسجين"},{"id":"b","text":"غاز الفحم"},{"id":"c","text":"الماء العذب"},{"id":"d","text":"النور"}]'::jsonb, 'b', 'يطرد الجسم غاز الفحم (ثاني أكسيد الكربون) في الزفير لأنّه غازٌ غير مفيد.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f3b415c4-c1c1-5113-985f-486cb922e93c', 'a41fcdb4-0774-5608-991b-f702474991f5', 'الأنبوب الذي ينقل الهواء من الأنف إلى الرئتين هو:', '[{"id":"a","text":"الوريد"},{"id":"b","text":"العصب"},{"id":"c","text":"الرّغامى (القصبة الهوائيّة)"},{"id":"d","text":"المريء"}]'::jsonb, 'c', 'الرّغامى (القصبة الهوائيّة) أنبوبٌ ينقل الهواء من الأنف إلى الرئتين.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('59ce70a9-296b-55e4-9378-20ad1854559b', 'a41fcdb4-0774-5608-991b-f702474991f5', 'أثناء الزفير يكون الصدر:', '[{"id":"a","text":"ثابتًا"},{"id":"b","text":"مختفيًا"},{"id":"c","text":"منتفخًا"},{"id":"d","text":"منكمشًا"}]'::jsonb, 'd', 'في الزفير يخرج الهواء من الرئتين فينكمش الصدر.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e9b14e9e-4d6c-5e7d-83eb-4a9d585a50f5', 'a41fcdb4-0774-5608-991b-f702474991f5', 'أيّ سلوكٍ يحافظ على الجهاز التنفّسيّ؟', '[{"id":"a","text":"الجلوس قرب الدخان"},{"id":"b","text":"تنفّس هواءٍ نقيٍّ بعيدًا عن التلوّث"},{"id":"c","text":"البقاء في غرفةٍ مليئةٍ بالغبار"},{"id":"d","text":"عدم ممارسة أيّ رياضة"}]'::jsonb, 'b', 'تنفّس الهواء النقيّ بعيدًا عن الدخان والتلوّث يحافظ على صحّة الجهاز التنفّسيّ.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7a6f8e5d-12fd-53b8-84eb-4c9d9f12a4c3', 'a41fcdb4-0774-5608-991b-f702474991f5', 'ما الترتيب الصحيح لمسار الهواء عند الدخول؟', '[{"id":"a","text":"الأنف ← الرّغامى ← الرئتان"},{"id":"b","text":"الرّغامى ← الرئتان ← الأنف"},{"id":"c","text":"الأنف ← الرئتان ← الرّغامى"},{"id":"d","text":"الرئتان ← الأنف ← الرّغامى"}]'::jsonb, 'a', 'يسلك الهواء عند الدخول: الأنف ← الرّغامى ← الرئتان.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('31418d2c-6fff-5002-bc34-74a6d685015b', '2c985fde-3a73-5c2e-806f-954d6535f701', 'eveil-scientifique-5eme', '⚔️ زعيم الفصل ⭐⭐⭐: حارسُ النَّفَس', 3, 120, 30, 'boss', 'admin', 2)
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
  ('ca818cdd-85d7-5f56-b1b4-a21924ca2018', '31418d2c-6fff-5002-bc34-74a6d685015b', 'لماذا يكون هواء الزفير مختلفًا عن هواء الشهيق؟', '[{"id":"a","text":"لأنّ الجسم أخذ من هواء الشهيق أكسجينًا وأضاف إليه غاز الفحم"},{"id":"b","text":"لأنّ الزفير يحمل ماءً فقط"},{"id":"c","text":"لأنّ الزفير يحمل أكسجينًا أكثر"},{"id":"d","text":"لأنّهما متطابقان تمامًا"}]'::jsonb, 'a', 'في الرئتين يأخذ الدم الأكسجين من هواء الشهيق ويطرح غاز الفحم؛ فيخرج هواء الزفير فقيرًا بالأكسجين غنيًّا بغاز الفحم. الخطأ الشائع ظنّ أنّ الهواءين متطابقان.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a15e0a88-f5c9-5806-9ecc-00cd15e39bae', '31418d2c-6fff-5002-bc34-74a6d685015b', 'ما الذي يحدث فعليًّا في الرئتين؟', '[{"id":"a","text":"هضم الطعام"},{"id":"b","text":"تبادل الغازات: الدم يأخذ الأكسجين ويطرح غاز الفحم"},{"id":"c","text":"تصفية الدم من الفضلات الصلبة"},{"id":"d","text":"إنتاج الضوء"}]'::jsonb, 'b', 'في الرئتين يحدث تبادل الغازات: يأخذ الدم الأكسجين من الهواء وينقله إلى الجسم، ويتخلّص من غاز الفحم. باقي الوظائف لأعضاء أخرى.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7364bbbe-ea34-5d0d-8df7-97dbbbcc6e3a', '31418d2c-6fff-5002-bc34-74a6d685015b', 'لماذا يُنصح بالتنفّس من الأنف لا من الفم قدر الإمكان؟', '[{"id":"a","text":"لأنّ الفم لا يصل إلى الرئتين"},{"id":"b","text":"لأنّ الأنف يهضم الهواء"},{"id":"c","text":"لأنّ الأنف يُصفّي الهواء من الغبار ويُدفّئه قبل وصوله الرئتين"},{"id":"d","text":"لأنّ الأنف ينتج الأكسجين"}]'::jsonb, 'c', 'الأنف يُصفّي الهواء من الغبار ويُدفّئه ويُرطّبه، فيصل الرئتين أنقى؛ لذلك يُفضّل التنفّس منه. الفخّ الشائع ظنّ أنّ الأنف ينتج الأكسجين.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11e61550-5b7f-5fb7-9f66-637f1f01e461', '31418d2c-6fff-5002-bc34-74a6d685015b', 'رياضيٌّ يلهث بعد الجري ويتنفّس بسرعة. ما تفسير ذلك؟', '[{"id":"a","text":"لأنّ رئتيه توقّفتا عن العمل"},{"id":"b","text":"لأنّه يطرد الأكسجين بسرعة"},{"id":"c","text":"لأنّ الجري يوقف التنفّس"},{"id":"d","text":"لأنّ جسمه يحتاج أكسجينًا أكثر بعد الجهد، فيزيد عدد مرّات التنفّس"}]'::jsonb, 'd', 'أثناء الجهد يحتاج الجسم أكسجينًا أكثر، فيتنفّس بسرعةٍ وعمقٍ أكبر ليأخذ ما يكفيه ويطرد غاز الفحم الزائد. الخطأ الشائع ظنّ توقّف الرئتين.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('31466efa-6210-5a6b-a1cb-f37626225718', '31418d2c-6fff-5002-bc34-74a6d685015b', 'أيّ زوجٍ صحيحٌ (عضو ← دوره)؟', '[{"id":"a","text":"الرئتان ← تذوّق الطعام"},{"id":"b","text":"الرّغامى ← نقل الهواء بين الأنف والرئتين"},{"id":"c","text":"الرئتان ← هضم الطعام"},{"id":"d","text":"الأنف ← ضخّ الدم"}]'::jsonb, 'b', 'الرّغامى أنبوبٌ ينقل الهواء بين الأنف والرئتين، وهذا دورها الصحيح. باقي الأزواج تنسب وظائف خاطئة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7d8cee0d-9599-547c-a9f5-e5c3decddd5e', '31418d2c-6fff-5002-bc34-74a6d685015b', 'لماذا يضرّ التدخين بالجهاز التنفّسيّ؟', '[{"id":"a","text":"لأنّ دخان السجائر يلوّث الهواء ويؤذي الرئتين والقصبة الهوائيّة"},{"id":"b","text":"لأنّ الدخان يزيد الأكسجين في الرئتين"},{"id":"c","text":"لأنّ الدخان ينقّي الرئتين"},{"id":"d","text":"لأنّ الدخان يقوّي الرئتين"}]'::jsonb, 'a', 'دخان السجائر يحمل موادّ ضارّة تلوّث الهواء وتؤذي الرئتين والقصبة الهوائيّة، فتضعف التنفّس. لذلك يضرّ التدخين بالجهاز التنفّسيّ.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('6ff290b4-43ff-53d6-8ef0-3e650e9d8bdc', '2c985fde-3a73-5c2e-806f-954d6535f701', 'eveil-scientifique-5eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الجهازُ التنفّسيّ', 2, 75, 15, 'practice', 'admin', 3)
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
  ('e3845459-b36d-5664-8263-6c4c997dda54', '6ff290b4-43ff-53d6-8ef0-3e650e9d8bdc', 'التنفّس هو:', '[{"id":"a","text":"دخول الهواء إلى الجسم وخروجه باستمرار"},{"id":"b","text":"هضم الطعام في المعدة"},{"id":"c","text":"ضخّ الدم في الجسم"},{"id":"d","text":"رؤية الألوان"}]'::jsonb, 'a', 'التنفّس دخول الهواء إلى الجسم وخروجه باستمرار، يأخذ فيه الجسم الأكسجين ويطرد غاز الفحم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bc8fef7f-9b4d-5bcb-a80d-4612ea2c48a3', '6ff290b4-43ff-53d6-8ef0-3e650e9d8bdc', 'أيّ زوجٍ صحيحٌ (حركة ← حالة الصدر)؟', '[{"id":"a","text":"الزفير ← الصدر منتفخ"},{"id":"b","text":"الشهيق ← الصدر منتفخ"},{"id":"c","text":"الزفير ← الصدر ثابت"},{"id":"d","text":"الشهيق ← الصدر منكمش"}]'::jsonb, 'b', 'في الشهيق يدخل الهواء فينتفخ الصدر، وفي الزفير يخرج الهواء فينكمش الصدر. الزوج الصحيح هو الشهيق ← الصدر منتفخ.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4605c300-308c-51f1-a00b-ed66f8b99fc5', '6ff290b4-43ff-53d6-8ef0-3e650e9d8bdc', 'لماذا نُصفّي الهواء عبر الأنف قبل وصوله الرئتين؟', '[{"id":"a","text":"لضخّ الدم"},{"id":"b","text":"لإنتاج غاز الفحم"},{"id":"c","text":"لمنع وصول الغبار إلى الرئتين قدر الإمكان"},{"id":"d","text":"لتسخين الطعام"}]'::jsonb, 'c', 'الأنف يُصفّي الهواء من الغبار ويُدفّئه، فيصل الرئتين أنقى وأقلّ ضررًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('4f91e9f9-d022-5b96-a2a0-010404f79494', '6ff290b4-43ff-53d6-8ef0-3e650e9d8bdc', 'أين يأخذ الدم الأكسجين من الهواء؟', '[{"id":"a","text":"في العين"},{"id":"b","text":"في القدم"},{"id":"c","text":"في المعدة"},{"id":"d","text":"في الرئتين"}]'::jsonb, 'd', 'في الرئتين يحدث التبادل: يأخذ الدم الأكسجين من الهواء ويطرح غاز الفحم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f42fc86b-9360-5ac3-96e6-4ec53781353f', '6ff290b4-43ff-53d6-8ef0-3e650e9d8bdc', 'أيّ ممارسةٍ تقوّي الرئتين؟', '[{"id":"a","text":"التدخين"},{"id":"b","text":"ممارسة الرياضة بانتظام"},{"id":"c","text":"البقاء في غرفةٍ مدخّنة"},{"id":"d","text":"تنفّس هواءٍ ملوّث"}]'::jsonb, 'b', 'ممارسة الرياضة بانتظامٍ تقوّي الرئتين وتحسّن التنفّس، بعكس التدخين والهواء الملوّث.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c88f2d5-078d-5122-a639-4a12c4d434ba', '6ff290b4-43ff-53d6-8ef0-3e650e9d8bdc', 'في الصورة سهمٌ يبيّن مسار الهواء الداخل. ما العضو رقم 1 الذي يدخل منه أوّلًا؟ <svg viewBox="0 0 130 170" xmlns="http://www.w3.org/2000/svg"><ellipse cx="55" cy="24" rx="22" ry="15" fill="#fcd9b6" stroke="#1f2937" stroke-width="3"/><text x="80" y="26" font-size="12" fill="#1f2937">1</text><line x1="55" y1="39" x2="55" y2="85" stroke="#1f2937" stroke-width="6"/><path d="M51 85 q-28 6 -28 44 q0 22 16 26 q12 2 14 -12 z" fill="#fca5a5" stroke="#1f2937" stroke-width="3"/><path d="M59 85 q28 6 28 44 q0 22 -16 26 q-12 2 -14 -12 z" fill="#fca5a5" stroke="#1f2937" stroke-width="3"/><line x1="100" y1="15" x2="68" y2="22" stroke="#2563eb" stroke-width="3"/><polygon points="68,22 78,19 76,28" fill="#2563eb"/></svg>', '[{"id":"a","text":"العضو رقم 1 (الأنف)"},{"id":"b","text":"الرئتان"},{"id":"c","text":"المعدة"},{"id":"d","text":"القلب"}]'::jsonb, 'a', 'السهم الأزرق يدخل عند العضو رقم 1 وهو الأنف، أوّل أعضاء مسار الهواء، حيث يُصفّى ويُدفّأ.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('48368488-950a-52d6-aae4-d2a2127a1f53', '2c985fde-3a73-5c2e-806f-954d6535f701', 'eveil-scientifique-5eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: عبقريُّ التنفّس', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('d0c8a7c7-9cfc-5d05-8759-d5a64450d700', '48368488-950a-52d6-aae4-d2a2127a1f53', 'أكمل: في الشهيق يدخل هواءٌ غنيٌّ بـ ........ ، وفي الزفير يخرج هواءٌ غنيٌّ بـ ........', '[{"id":"a","text":"الأكسجين / غاز الفحم"},{"id":"b","text":"غاز الفحم / الأكسجين"},{"id":"c","text":"الغبار / الماء"},{"id":"d","text":"الدخان / النور"}]'::jsonb, 'a', 'هواء الشهيق غنيٌّ بالأكسجين (يدخل)، وهواء الزفير غنيٌّ بغاز الفحم (يخرج). هذا هو الإكمال الصحيح.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('956f5932-f857-5ef1-bf73-4e10be374f1f', '48368488-950a-52d6-aae4-d2a2127a1f53', 'وضع تلميذٌ مرآةً أمام فمه وزفر، فتغطّت بقطراتٍ صغيرة. ماذا يدلّ ذلك؟', '[{"id":"a","text":"أنّ الفم مصدرٌ للضوء"},{"id":"b","text":"أنّ هواء الزفير يحمل بخار ماءٍ يتكثّف على المرآة"},{"id":"c","text":"أنّ المرآة تنتج الماء"},{"id":"d","text":"أنّ الزفير يحمل أكسجينًا فقط"}]'::jsonb, 'b', 'هواء الزفير يحمل بخار ماءٍ من الجسم، فيتكثّف على سطح المرآة الباردة قطراتٍ صغيرة. هذا دليلٌ على أنّ الزفير يختلف عن هواء الشهيق ويحمل بخار الماء. الفخّ الشائع نسبة الماء إلى المرآة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ad4ad34-535e-5d83-a553-8f73c778f514', '48368488-950a-52d6-aae4-d2a2127a1f53', 'تلميذٌ قال: «الهواء الذي أُخرجه هو نفسه الذي أدخله دون تغيير.» أين الخطأ؟', '[{"id":"a","text":"الخطأ أنّ الشهيق يحمل غاز الفحم"},{"id":"b","text":"لا خطأ، فالهواء لا يتغيّر"},{"id":"c","text":"الخطأ أنّ الجسم أخذ من هواء الشهيق أكسجينًا وأضاف غاز الفحم، فاختلف هواء الزفير"},{"id":"d","text":"الخطأ أنّ الزفير يحمل أكسجينًا أكثر"}]'::jsonb, 'c', 'هواء الزفير يختلف عن الشهيق: الجسم أخذ منه الأكسجين وأضاف إليه غاز الفحم وبخار الماء. هذا هو الخطأ الشائع: ظنّ أنّ الهواءين متطابقان.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('60b62f0f-22b9-5006-8d19-278b53c66a10', '48368488-950a-52d6-aae4-d2a2127a1f53', 'لماذا نشعر بصعوبةٍ في التنفّس في غرفةٍ مغلقةٍ مزدحمةٍ بالناس مدّةً طويلة؟', '[{"id":"a","text":"لأنّ الغرفة تنتج دخانًا"},{"id":"b","text":"لأنّ الرئتين تكبران"},{"id":"c","text":"لأنّ الهواء يصبح ضوئيًّا"},{"id":"d","text":"لأنّ الأكسجين يقلّ وغاز الفحم يزداد في هواء الغرفة المغلقة"}]'::jsonb, 'd', 'في الغرفة المغلقة المزدحمة يستهلك الناس الأكسجين ويطرحون غاز الفحم، فيقلّ الأكسجين ويزداد غاز الفحم، فنشعر بصعوبةٍ في التنفّس؛ لذلك نُهوّي الغرف. الفخّ الشائع تخيّل أسبابٍ غير واقعيّة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('55840c36-5aba-522f-ac0e-64073a27ede0', '48368488-950a-52d6-aae4-d2a2127a1f53', 'أيّ سلسلةٍ تصف رحلة الأكسجين الصحيحة من الهواء إلى الجسم؟', '[{"id":"a","text":"الجلد ← القلب ← الرئتان"},{"id":"b","text":"الأنف ← الرّغامى ← الرئتان ← الدم ← الجسم"},{"id":"c","text":"الفم ← المعدة ← الدم ← الجسم"},{"id":"d","text":"الأنف ← الرئتان ← المعدة ← الجسم"}]'::jsonb, 'b', 'يدخل الأكسجين من الأنف ← الرّغامى ← الرئتان، حيث يأخذه الدم ← ينقله إلى الجسم. هذه هي السلسلة الصحيحة لرحلة الأكسجين.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ea85c715-175d-5ff4-a5cb-0b3d9d8738c8', '48368488-950a-52d6-aae4-d2a2127a1f53', 'لماذا يساعد الجهاز التنفّسيّ السليم على نشاط الجسم وقدرته على الجري الطويل؟', '[{"id":"a","text":"لأنّه يوفّر أكسجينًا كافيًا للجسم ويطرد غاز الفحم بكفاءة"},{"id":"b","text":"لأنّه يهضم الطعام أسرع"},{"id":"c","text":"لأنّه يضخّ الدم بدل القلب"},{"id":"d","text":"لأنّه ينتج طاقةً ضوئيّة"}]'::jsonb, 'a', 'الجهاز التنفّسيّ السليم يأخذ أكسجينًا كافيًا للجسم ويطرد غاز الفحم بكفاءة، فيدوم النشاط ويقدر الجسم على الجهد الطويل. باقي الخيارات وظائف أعضاء أخرى.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('aa22e92b-3b5b-53ea-a27d-5912e1079ae0', '2c985fde-3a73-5c2e-806f-954d6535f701', 'eveil-scientifique-5eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملةٌ للتنفّس', 3, 120, 30, 'boss', 'admin', 5)
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
  ('7bd0ed8d-614f-5b94-8af4-8dcdf7b421eb', 'aa22e92b-3b5b-53ea-a27d-5912e1079ae0', 'أعضاء الجهاز التنفّسيّ الرئيسيّة هي:', '[{"id":"a","text":"الأنف والرّغامى والرئتان"},{"id":"b","text":"المعدة والأمعاء والكبد"},{"id":"c","text":"القلب والشرايين والأوردة"},{"id":"d","text":"العين والأذن والأنف"}]'::jsonb, 'a', 'أعضاء الجهاز التنفّسيّ الرئيسيّة هي الأنف والرّغامى (القصبة الهوائيّة) والرئتان.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('33772719-27a6-5859-b8c8-f8188cb60516', 'aa22e92b-3b5b-53ea-a27d-5912e1079ae0', 'أيّ جملةٍ صحيحةٌ عن التبادل في الرئتين؟', '[{"id":"a","text":"الرئتان تنتجان الدم"},{"id":"b","text":"الدم يأخذ الأكسجين ويتخلّص من غاز الفحم"},{"id":"c","text":"الدم يأخذ غاز الفحم ويتخلّص من الأكسجين"},{"id":"d","text":"الرئتان تهضمان الطعام"}]'::jsonb, 'b', 'في الرئتين يأخذ الدم الأكسجين من الهواء وينقله للجسم، ويتخلّص من غاز الفحم بطرحه في الزفير.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('664ecc9b-dafa-59f5-a3e9-f29045409389', 'aa22e92b-3b5b-53ea-a27d-5912e1079ae0', 'لماذا نُهوّي غرف النوم صباحًا؟', '[{"id":"a","text":"لإدخال الغبار"},{"id":"b","text":"لإطفاء الضوء"},{"id":"c","text":"لتجديد الهواء بأكسجينٍ نقيٍّ وطرد غاز الفحم المتراكم"},{"id":"d","text":"لتسخين الغرفة فقط"}]'::jsonb, 'c', 'أثناء الليل يستهلك النائمون الأكسجين ويطرحون غاز الفحم؛ فتهوية الغرفة صباحًا تجدّد الهواء بأكسجينٍ نقيٍّ وتطرد غاز الفحم المتراكم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('03bc2e1a-df6b-58b0-9854-41f1f1165f6e', 'aa22e92b-3b5b-53ea-a27d-5912e1079ae0', 'ما العلاقة بين التنفّس والرياضة؟', '[{"id":"a","text":"الرياضة توقف التنفّس"},{"id":"b","text":"الرياضة تقلّل حاجة الجسم للأكسجين"},{"id":"c","text":"لا علاقة بينهما إطلاقًا"},{"id":"d","text":"أثناء الرياضة يحتاج الجسم أكسجينًا أكثر فيزداد التنفّس، والرياضة المنتظمة تقوّي الرئتين"}]'::jsonb, 'd', 'أثناء الجهد يحتاج الجسم أكسجينًا أكثر فيتنفّس أسرع وأعمق، والمواظبة على الرياضة تقوّي الرئتين فيتحسّن التنفّس. هذه هي العلاقة الصحيحة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0472b3c4-b2a7-5fc7-b65d-4906aa6a93f7', 'aa22e92b-3b5b-53ea-a27d-5912e1079ae0', 'تلميذٌ قال: «الرئتان تهضمان الطعام.» أين الخطأ؟', '[{"id":"a","text":"الخطأ أنّ الرئتين تريان الألوان"},{"id":"b","text":"الخطأ أنّ الرئتين للتنفّس وتبادل الغازات، والهضم في المعدة والأمعاء"},{"id":"c","text":"لا خطأ، فالرئتان تهضمان"},{"id":"d","text":"الخطأ أنّ الرئتين تضخّان الدم"}]'::jsonb, 'b', 'الرئتان عضوان للتنفّس وتبادل الغازات (الأكسجين وغاز الفحم)، أمّا الهضم فيتمّ في المعدة والأمعاء. هذا هو الخطأ الشائع: خلط وظائف الأعضاء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8cef93ff-6d57-5a10-8137-0a9848d8179f', 'aa22e92b-3b5b-53ea-a27d-5912e1079ae0', 'رتّب حركتي التنفّس مع حالة الصدر بشكلٍ صحيح:', '[{"id":"a","text":"شهيق: يدخل الهواء فينتفخ الصدر — زفير: يخرج الهواء فينكمش الصدر"},{"id":"b","text":"شهيق: يخرج الهواء فينكمش الصدر — زفير: يدخل الهواء فينتفخ الصدر"},{"id":"c","text":"شهيق وزفير: الصدر ثابتٌ دائمًا"},{"id":"d","text":"شهيق: الصدر يختفي — زفير: الصدر يكبر"}]'::jsonb, 'a', 'في الشهيق يدخل الهواء فينتفخ الصدر، وفي الزفير يخرج الهواء فينكمش الصدر. هذا هو الترتيب الصحيح للحركتين.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a03472bd-57e3-5c1d-917d-7416b23e57eb', '3745467d-e265-51a5-b94e-7f9761992b43', 'eveil-scientifique-5eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('cbb46478-2e9c-514b-bd81-b116f737f314', 'a03472bd-57e3-5c1d-917d-7416b23e57eb', 'ما العضو الذي يضخّ الدم في الجسم؟', '[{"id":"a","text":"القلب"},{"id":"b","text":"الرئة"},{"id":"c","text":"المعدة"},{"id":"d","text":"الكبد"}]'::jsonb, 'a', 'القلب عضوٌ عضليٌّ يعمل مضخّةً تضخّ الدم إلى كلّ الجسم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ebecab47-ca7e-50a2-998e-ff31f140d5b9', 'a03472bd-57e3-5c1d-917d-7416b23e57eb', 'ما الذي نحسّه عند وضع إصبعنا على المعصم؟', '[{"id":"a","text":"التنفّس"},{"id":"b","text":"النبض (دفعات الدم مع نبض القلب)"},{"id":"c","text":"الهضم"},{"id":"d","text":"العرق"}]'::jsonb, 'b', 'النبض الذي نحسّه في المعصم هو دفعات الدم التي يدفعها القلب مع كلّ انقباضة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('053324bf-ebc1-5140-8fc6-5c21db5b8b27', 'a03472bd-57e3-5c1d-917d-7416b23e57eb', 'الوعاء الذي يحمل الدم من القلب إلى الجسم هو:', '[{"id":"a","text":"الوريد"},{"id":"b","text":"الرّغامى"},{"id":"c","text":"الشريان"},{"id":"d","text":"المريء"}]'::jsonb, 'c', 'الشريان يحمل الدم من القلب إلى أعضاء الجسم (خارجٌ من القلب).', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c2b1550a-12c7-544e-b7bf-3413101b442d', 'a03472bd-57e3-5c1d-917d-7416b23e57eb', 'في الدورة الصغرى يذهب الدم من القلب إلى:', '[{"id":"a","text":"القدمين"},{"id":"b","text":"الدماغ"},{"id":"c","text":"المعدة"},{"id":"d","text":"الرئتين"}]'::jsonb, 'd', 'في الدورة الصغرى يذهب الدم من القلب إلى الرئتين ليأخذ الأكسجين ويطرح غاز الفحم، ثمّ يعود.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eef65a72-2046-5b3a-b911-330973e5b903', 'a03472bd-57e3-5c1d-917d-7416b23e57eb', 'في الصورة قلبٌ وسهمان. السهم الخارج من القلب يمثّل وعاءً يحمل الدم بعيدًا عنه. ما اسمه؟ <svg viewBox="0 0 160 120" xmlns="http://www.w3.org/2000/svg"><path d="M70 95 C20 60 35 20 70 45 C105 20 120 60 70 95 Z" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><line x1="95" y1="45" x2="148" y2="30" stroke="#dc2626" stroke-width="5"/><polygon points="148,30 137,27 139,38" fill="#dc2626"/><text x="120" y="22" font-size="12" fill="#1f2937">خارج</text><line x1="40" y1="55" x2="12" y2="75" stroke="#2563eb" stroke-width="5"/><polygon points="40,55 30,57 36,64" fill="#2563eb"/></svg>', '[{"id":"a","text":"الوريد"},{"id":"b","text":"الشريان"},{"id":"c","text":"الرّغامى"},{"id":"d","text":"المريء"}]'::jsonb, 'b', 'السهم الأحمر يخرج من القلب حاملًا الدم بعيدًا عنه، فهو يمثّل الشريان. أمّا السهم الأزرق العائد فيمثّل الوريد.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('8c655a5f-a2f2-5394-8b16-011cb05cd89b', '3745467d-e265-51a5-b94e-7f9761992b43', 'eveil-scientifique-5eme', '⭐ تمرين: القلبُ والدم', 1, 50, 10, 'practice', 'admin', 1)
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
  ('95a59d21-456f-53ae-8350-9714649abf2c', '8c655a5f-a2f2-5394-8b16-011cb05cd89b', 'القلب يقع في:', '[{"id":"a","text":"الصدر بين الرئتين"},{"id":"b","text":"الرأس"},{"id":"c","text":"القدم"},{"id":"d","text":"البطن السفلى"}]'::jsonb, 'a', 'القلب عضوٌ عضليٌّ يقع في الصدر بين الرئتين.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cdbd1da1-9702-5c25-8f10-8ce450ec6ed2', '8c655a5f-a2f2-5394-8b16-011cb05cd89b', 'وظيفة القلب الأساسيّة هي:', '[{"id":"a","text":"هضم الطعام"},{"id":"b","text":"ضخّ الدم إلى الجسم"},{"id":"c","text":"تنقية الهواء"},{"id":"d","text":"رؤية الأشياء"}]'::jsonb, 'b', 'القلب مضخّةٌ تضخّ الدم إلى كلّ أعضاء الجسم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('38ad5828-7411-57d1-be4f-5a73be6d4d8e', '8c655a5f-a2f2-5394-8b16-011cb05cd89b', 'الوعاء الذي يُعيد الدم من الجسم إلى القلب هو:', '[{"id":"a","text":"العصب"},{"id":"b","text":"الشريان"},{"id":"c","text":"الوريد"},{"id":"d","text":"الرّغامى"}]'::jsonb, 'c', 'الوريد يحمل الدم من الجسم عائدًا إلى القلب.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('891f58b6-4487-53b0-af5a-cc171fbf9b41', '8c655a5f-a2f2-5394-8b16-011cb05cd89b', 'ماذا ينقل الدم إلى أعضاء الجسم؟', '[{"id":"a","text":"الضوء"},{"id":"b","text":"الصوت"},{"id":"c","text":"الغبار"},{"id":"d","text":"الأكسجين والغذاء"}]'::jsonb, 'd', 'الدم ينقل الأكسجين من الرئتين والغذاء من الأمعاء إلى كلّ أعضاء الجسم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7be2091d-1f34-5c15-92ba-28e4de1b9ae7', '8c655a5f-a2f2-5394-8b16-011cb05cd89b', 'النبض الذي نحسّه في المعصم سببه:', '[{"id":"a","text":"حركة العضلات في اليد"},{"id":"b","text":"دفعات الدم مع كلّ انقباضةٍ للقلب"},{"id":"c","text":"دخول الهواء إلى اليد"},{"id":"d","text":"هضم الطعام"}]'::jsonb, 'b', 'النبض هو دفعات الدم في الأوعية مع كلّ انقباضةٍ للقلب، فنحسّه في المعصم والرقبة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('739e89a1-e646-5b13-8ccc-bc0ec4e52d85', '8c655a5f-a2f2-5394-8b16-011cb05cd89b', 'في الدورة الكبرى يذهب الدم من القلب إلى:', '[{"id":"a","text":"كلّ أعضاء الجسم"},{"id":"b","text":"الأنف فقط"},{"id":"c","text":"خارج الجسم"},{"id":"d","text":"الرئتين فقط"}]'::jsonb, 'a', 'في الدورة الكبرى يخرج الدم من القلب إلى كلّ أعضاء الجسم حاملًا الأكسجين والغذاء، ثمّ يعود.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('15e5e4c2-2c85-5acc-afb4-99d5fa1d52c9', '3745467d-e265-51a5-b94e-7f9761992b43', 'eveil-scientifique-5eme', '⚔️ زعيم الفصل ⭐⭐⭐: حارسُ القلب', 3, 120, 30, 'boss', 'admin', 2)
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
  ('6fd95c0a-21c2-5f51-8c51-ca39a0a40d54', '15e5e4c2-2c85-5acc-afb4-99d5fa1d52c9', 'ما الفرق الأساسيّ بين الشريان والوريد؟', '[{"id":"a","text":"الشريان يحمل الدم من القلب إلى الجسم، والوريد يحمله من الجسم إلى القلب"},{"id":"b","text":"الشريان ينقل الهواء والوريد ينقل الطعام"},{"id":"c","text":"لا فرق بينهما"},{"id":"d","text":"الشريان أحمر والوريد أبيض دائمًا"}]'::jsonb, 'a', 'الفرق في اتّجاه الدم: الشريان يخرج الدم من القلب إلى الجسم، والوريد يعيده من الجسم إلى القلب. الخطأ الشائع التمييز باللون بدل الاتّجاه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('14cf7822-21b4-576a-ae53-4df2a431dd56', '15e5e4c2-2c85-5acc-afb4-99d5fa1d52c9', 'لماذا يُسمّى القلب "مضخّة"؟', '[{"id":"a","text":"لأنّه يخزّن الدم دون تحريكه"},{"id":"b","text":"لأنّه ينقبض وينبسط فيدفع الدم في الأوعية إلى كلّ الجسم"},{"id":"c","text":"لأنّه يهضم الطعام"},{"id":"d","text":"لأنّه يصفّي الهواء"}]'::jsonb, 'b', 'القلب كالمضخّة: ينقبض فيدفع الدم وينبسط فيمتلئ من جديد، فيظلّ الدم يجري في الجسم. الخطأ الشائع نسبة وظائف أعضاء أخرى إليه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aca81549-0aef-5ffc-a864-1a0da6b91a18', '15e5e4c2-2c85-5acc-afb4-99d5fa1d52c9', 'في أيّ دورةٍ يأخذ الدم الأكسجين من الرئتين؟', '[{"id":"a","text":"في دورة الهضم"},{"id":"b","text":"الدورة الكبرى"},{"id":"c","text":"الدورة الصغرى (القلب ← الرئتان ← القلب)"},{"id":"d","text":"لا يأخذ الدم أكسجينًا أبدًا"}]'::jsonb, 'c', 'في الدورة الصغرى يذهب الدم من القلب إلى الرئتين فيأخذ الأكسجين ويطرح غاز الفحم، ثمّ يعود إلى القلب. أمّا الكبرى فتوزّع الأكسجين على الجسم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9613d99e-dff0-5034-9b74-97bcc549bbbe', '15e5e4c2-2c85-5acc-afb4-99d5fa1d52c9', 'لماذا يزداد نبض القلب أثناء الجري؟', '[{"id":"a","text":"لأنّ القلب يتوقّف عند الجري"},{"id":"b","text":"لأنّ الدم يتوقّف عن الحركة"},{"id":"c","text":"لأنّ الجري يهضم الطعام"},{"id":"d","text":"لأنّ العضلات تحتاج دمًا وأكسجينًا أكثر، فيضخّ القلب أسرع"}]'::jsonb, 'd', 'أثناء الجري تحتاج العضلات أكسجينًا وغذاءً أكثر، فيسرّع القلب ضخّه ليوصل الدم بسرعةٍ أكبر، فيزداد النبض. الفخّ الشائع توهّم توقّف القلب أو الدم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d1f0a796-df9a-5b08-a895-72f06996632e', '15e5e4c2-2c85-5acc-afb4-99d5fa1d52c9', 'أيّ زوجٍ صحيحٌ (وعاء ← اتّجاه الدم)؟', '[{"id":"a","text":"الوريد ← خارج الجسم"},{"id":"b","text":"الشريان ← من القلب إلى الجسم"},{"id":"c","text":"الوريد ← من القلب إلى الجسم"},{"id":"d","text":"الشريان ← من الجسم إلى القلب"}]'::jsonb, 'b', 'الشريان يحمل الدم من القلب إلى الجسم، وهذا الزوج صحيح. أمّا الوريد فيحمله من الجسم إلى القلب.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('503d0723-3305-526b-97d7-ed3e62a8f6cc', '15e5e4c2-2c85-5acc-afb4-99d5fa1d52c9', 'ما العلاقة بين الجهاز التنفّسيّ والدورة الدمويّة؟', '[{"id":"a","text":"الرئتان تأخذان الأكسجين، والدم ينقله إلى الجسم؛ فهما يتعاونان"},{"id":"b","text":"لا علاقة بينهما إطلاقًا"},{"id":"c","text":"الدورة الدمويّة تهضم الطعام للرئتين"},{"id":"d","text":"الرئتان تضخّان الدم بدل القلب"}]'::jsonb, 'a', 'يتعاون الجهازان: الرئتان تأخذان الأكسجين من الهواء، والدم (تدفعه الدورة الدمويّة) ينقله إلى كلّ الجسم ويعيد غاز الفحم إلى الرئتين. هذه هي العلاقة الصحيحة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('1b4889fd-8f65-5ee9-a86d-88d85b69e827', '3745467d-e265-51a5-b94e-7f9761992b43', 'eveil-scientifique-5eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الدورةُ الدمويّة', 2, 75, 15, 'practice', 'admin', 3)
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
  ('44bb05c3-8c4a-563d-a5e8-072189817ebe', '1b4889fd-8f65-5ee9-a86d-88d85b69e827', 'حجم القلب قريبٌ من حجم:', '[{"id":"a","text":"قبضة اليد"},{"id":"b","text":"كرة القدم"},{"id":"c","text":"حبّة الأرزّ"},{"id":"d","text":"السيّارة"}]'::jsonb, 'a', 'القلب عضوٌ عضليٌّ حجمه قريبٌ من حجم قبضة اليد.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('56be73d9-505a-5f4b-8cfa-53b217402af6', '1b4889fd-8f65-5ee9-a86d-88d85b69e827', 'أيّ زوجٍ صحيحٌ (وعاء ← اتّجاه)؟', '[{"id":"a","text":"الشريان ← لا يحمل دمًا"},{"id":"b","text":"الوريد ← من الجسم إلى القلب"},{"id":"c","text":"الشريان ← من الجسم إلى القلب"},{"id":"d","text":"الوريد ← من القلب إلى الجسم"}]'::jsonb, 'b', 'الوريد يحمل الدم من الجسم عائدًا إلى القلب، وهذا الزوج صحيح. الشريان عكسه (من القلب إلى الجسم).', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b5a5097b-7338-54ba-8a60-e4a1351d27a2', '1b4889fd-8f65-5ee9-a86d-88d85b69e827', 'لماذا يجب أن يستمرّ القلب في العمل دون توقّف؟', '[{"id":"a","text":"ليهضم الطعام"},{"id":"b","text":"لينتج الضوء"},{"id":"c","text":"ليبقى الدم يجري فيصل الأكسجين والغذاء إلى الأعضاء باستمرار"},{"id":"d","text":"ليصفّي الهواء"}]'::jsonb, 'c', 'إذا توقّف القلب توقّف جريان الدم، فلا يصل الأكسجين والغذاء إلى الأعضاء؛ لذلك يعمل القلب باستمرارٍ ليلًا ونهارًا.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('98452388-355c-5037-8abf-4ef8b82d72b3', '1b4889fd-8f65-5ee9-a86d-88d85b69e827', 'الدورة الكبرى تختلف عن الصغرى في أنّها:', '[{"id":"a","text":"تخصّ الرئتين فقط"},{"id":"b","text":"تهضم الطعام"},{"id":"c","text":"تنقّي الهواء"},{"id":"d","text":"توزّع الدم على كلّ أعضاء الجسم، بينما الصغرى تخصّ الرئتين"}]'::jsonb, 'd', 'الدورة الكبرى تنقل الدم من القلب إلى كلّ أعضاء الجسم وتعيده، أمّا الصغرى فبين القلب والرئتين. هذا هو الفرق الصحيح.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6549011b-2bff-5fa5-a91d-837742390b3f', '1b4889fd-8f65-5ee9-a86d-88d85b69e827', 'أيّ سلوكٍ يحافظ على صحّة القلب؟', '[{"id":"a","text":"التدخين"},{"id":"b","text":"ممارسة الرياضة والغذاء المتوازن"},{"id":"c","text":"قلّة الحركة الدائمة"},{"id":"d","text":"الإكثار من الدهون والملح"}]'::jsonb, 'b', 'ممارسة الرياضة تقوّي عضلة القلب، والغذاء المتوازن يحميه؛ بعكس التدخين وقلّة الحركة والإفراط في الدهون.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('beef4c71-3a40-5617-8338-15e287c0ad67', '1b4889fd-8f65-5ee9-a86d-88d85b69e827', 'في الصورة قلبٌ ووعاءان ملوّنان: 1 خارجٌ من القلب و2 عائدٌ إليه. أيّهما الشريان؟ <svg viewBox="0 0 160 120" xmlns="http://www.w3.org/2000/svg"><path d="M70 95 C20 60 35 20 70 45 C105 20 120 60 70 95 Z" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><line x1="95" y1="45" x2="150" y2="32" stroke="#dc2626" stroke-width="5"/><polygon points="150,32 139,29 141,40" fill="#dc2626"/><text x="122" y="24" font-size="12" fill="#1f2937">1</text><line x1="12" y1="78" x2="42" y2="58" stroke="#2563eb" stroke-width="5"/><polygon points="42,58 32,60 38,67" fill="#2563eb"/><text x="8" y="92" font-size="12" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"الوعاء رقم 1 (الخارج من القلب)"},{"id":"b","text":"الوعاء رقم 2 (العائد إلى القلب)"},{"id":"c","text":"كلاهما وريد"},{"id":"d","text":"لا يوجد شريان"}]'::jsonb, 'a', 'الوعاء 1 يخرج من القلب حاملًا الدم إلى الجسم فهو الشريان. أمّا الوعاء 2 العائد إلى القلب فهو الوريد.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('2f0cbea3-9363-5fc2-b54a-ae2688d921d8', '3745467d-e265-51a5-b94e-7f9761992b43', 'eveil-scientifique-5eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: عبقريُّ الدورة الدمويّة', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('448a5774-82ed-5a89-acd1-20bbc6495caf', '2f0cbea3-9363-5fc2-b54a-ae2688d921d8', 'أكمل: .......... يحمل الدم من القلب، و.......... يعيده إلى القلب، و.......... هو المضخّة.', '[{"id":"a","text":"الشريان / الوريد / القلب"},{"id":"b","text":"الوريد / الشريان / الرئة"},{"id":"c","text":"القلب / الشريان / الوريد"},{"id":"d","text":"الوريد / القلب / الشريان"}]'::jsonb, 'a', 'الشريان يحمل الدم من القلب، والوريد يعيده إلى القلب، والقلب هو المضخّة. هذا هو الإكمال الصحيح الوحيد.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a9ffe6da-a8cf-5c6b-94cb-479357dd0f06', '2f0cbea3-9363-5fc2-b54a-ae2688d921d8', 'يقيس طبيبٌ نبض طفلٍ فيجده أسرع بعد لعبه. لماذا؟', '[{"id":"a","text":"لأنّ النبض لا علاقة له بالقلب"},{"id":"b","text":"لأنّ الجهد زاد حاجة العضلات للأكسجين، فسرّع القلب ضخّه فزاد النبض"},{"id":"c","text":"لأنّ قلب الطفل توقّف أثناء اللعب"},{"id":"d","text":"لأنّ اللعب يقلّل الدم في الجسم"}]'::jsonb, 'b', 'بعد اللعب تحتاج العضلات أكسجينًا أكثر، فيضخّ القلب أسرع ليوصل الدم بسرعة، فيرتفع النبض. النبض مرآةٌ لعمل القلب. الفخّ الشائع توهّم توقّف القلب.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('664f5a6a-891f-5856-a61a-85211fd6aedc', '2f0cbea3-9363-5fc2-b54a-ae2688d921d8', 'كيف يصل الأكسجين من الهواء إلى عضلة الساق؟ رتّب الرحلة:', '[{"id":"a","text":"الجلد يأخذ الأكسجين ← العظم ← الساق"},{"id":"b","text":"الأذن تأخذ الأكسجين ← الوريد ← الساق"},{"id":"c","text":"الرئتان تأخذ الأكسجين ← الدم يحمله ← القلب يضخّه في الشرايين ← يصل عضلة الساق"},{"id":"d","text":"المعدة تهضم الأكسجين ← الدم ← الساق"}]'::jsonb, 'c', 'الرحلة الصحيحة: تأخذ الرئتان الأكسجين من الهواء ← يحمله الدم ← يضخّه القلب في الشرايين ← يصل إلى عضلة الساق. هذا يبيّن تعاون التنفّس والدورة الدمويّة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd31d6de-873c-5475-824b-42d3f1bd4032', '2f0cbea3-9363-5fc2-b54a-ae2688d921d8', 'تلميذٌ قال: «الوريد يحمل الدم من القلب إلى الجسم.» أين الخطأ؟', '[{"id":"a","text":"الخطأ أنّ القلب لا يضخّ الدم"},{"id":"b","text":"الخطأ أنّ الدم لا يتحرّك"},{"id":"c","text":"لا خطأ، فالوريد يخرج من القلب"},{"id":"d","text":"الخطأ أنّ الوريد يعيد الدم من الجسم إلى القلب؛ الذي يخرج من القلب هو الشريان"}]'::jsonb, 'd', 'الوريد يحمل الدم من الجسم عائدًا إلى القلب، والشريان هو الذي يخرجه من القلب إلى الجسم. هذا هو الخطأ الشائع: عكس اتّجاهي الوعاءين.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7390e271-fff6-5cd1-96b2-0f364871dfd6', '2f0cbea3-9363-5fc2-b54a-ae2688d921d8', 'لماذا تساعد ممارسة الرياضة بانتظامٍ القلب؟', '[{"id":"a","text":"لأنّها تقلّل الدم في الجسم"},{"id":"b","text":"لأنّها تقوّي عضلة القلب فيضخّ الدم بكفاءةٍ أكبر"},{"id":"c","text":"لأنّها توقف القلب لراحته"},{"id":"d","text":"لأنّها تحوّل القلب إلى رئة"}]'::jsonb, 'b', 'القلب عضلة؛ الرياضة المنتظمة تقوّيه فيضخّ الدم بكفاءةٍ أكبر وبجهدٍ أقلّ. الفخّ الشائع تخيّل آثارٍ غير واقعيّة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bfb384a2-d069-5181-9411-bdc7d058e321', '2f0cbea3-9363-5fc2-b54a-ae2688d921d8', 'في الصورة مساران للدم من القلب: 1 إلى الرئتين، 2 إلى باقي الجسم. أيّهما الدورة الكبرى؟ <svg viewBox="0 0 180 120" xmlns="http://www.w3.org/2000/svg"><path d="M85 80 C55 55 65 30 85 45 C105 30 115 55 85 80 Z" fill="#ef4444" stroke="#1f2937" stroke-width="3"/><ellipse cx="40" cy="25" rx="22" ry="13" fill="#fca5a5" stroke="#1f2937" stroke-width="2"/><text x="30" y="28" font-size="9" fill="#1f2937">رئتان</text><line x1="75" y1="50" x2="55" y2="32" stroke="#1f2937" stroke-width="3"/><polygon points="55,32 64,36 60,42" fill="#1f2937"/><text x="60" y="58" font-size="11" fill="#1f2937">1</text><rect x="120" y="60" width="44" height="34" rx="5" fill="#fde68a" stroke="#1f2937" stroke-width="2"/><text x="126" y="80" font-size="9" fill="#1f2937">الجسم</text><line x1="100" y1="68" x2="122" y2="74" stroke="#1f2937" stroke-width="3"/><polygon points="122,74 112,72 116,80" fill="#1f2937"/><text x="104" y="64" font-size="11" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"المسار رقم 2 (إلى باقي الجسم)"},{"id":"b","text":"لا توجد دورة كبرى"},{"id":"c","text":"كلاهما إلى الرئتين"},{"id":"d","text":"المسار رقم 1 (إلى الرئتين)"}]'::jsonb, 'a', 'الدورة الكبرى تنقل الدم من القلب إلى باقي أعضاء الجسم (المسار 2). أمّا المسار 1 إلى الرئتين فهو الدورة الصغرى.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('7c650208-506e-5efc-8f2f-fbe379906487', '3745467d-e265-51a5-b94e-7f9761992b43', 'eveil-scientifique-5eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملةٌ للدورة الدمويّة', 3, 120, 30, 'boss', 'admin', 5)
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
  ('10e60025-377b-52e9-87a0-9213dd4a78d7', '7c650208-506e-5efc-8f2f-fbe379906487', 'الأوعية الدمويّة نوعان رئيسيّان هما:', '[{"id":"a","text":"الشرايين والأوردة"},{"id":"b","text":"الرّغامى والمريء"},{"id":"c","text":"العظام والعضلات"},{"id":"d","text":"الأعصاب والأوتار"}]'::jsonb, 'a', 'الأوعية الدمويّة الرئيسيّة نوعان: الشرايين (من القلب) والأوردة (إلى القلب).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a03b3884-1992-55fc-864d-8f01676bcd3d', '7c650208-506e-5efc-8f2f-fbe379906487', 'أيّ جملةٍ صحيحةٌ عن دور الدم؟', '[{"id":"a","text":"يرى الألوان"},{"id":"b","text":"ينقل الأكسجين والغذاء إلى الأعضاء ويحمل الفضلات بعيدًا"},{"id":"c","text":"يهضم الطعام في المعدة"},{"id":"d","text":"يصفّي الهواء في الأنف"}]'::jsonb, 'b', 'الدم وسيلة نقلٍ في الجسم: يوصل الأكسجين والغذاء إلى الأعضاء، ويحمل الفضلات وغاز الفحم بعيدًا.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('435c729d-4771-551c-a27d-69fc14c23335', '7c650208-506e-5efc-8f2f-fbe379906487', 'كيف يتعاون القلب والرئتان لخدمة الجسم؟', '[{"id":"a","text":"الرئتان تضخّان الدم والقلب يصفّي الهواء"},{"id":"b","text":"لا تعاون بينهما"},{"id":"c","text":"الرئتان تزوّدان الدم بالأكسجين، والقلب يضخّ هذا الدم إلى كلّ الجسم"},{"id":"d","text":"القلب يهضم الطعام والرئتان تضخّان الدم"}]'::jsonb, 'c', 'تتعاون الرئتان (تأخذان الأكسجين) والقلب (يضخّ الدم المحمّل بالأكسجين إلى الجسم)، فيستفيد كلّ عضوٍ من الأكسجين. هذا هو التعاون الصحيح.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cd86af53-f366-56e9-ab08-ffc9d13862fd', '7c650208-506e-5efc-8f2f-fbe379906487', 'لماذا يصبح وجه الإنسان أحمر ويتصبّب عرقًا أثناء الجهد الكبير؟', '[{"id":"a","text":"لأنّ الدم يتوقّف عن الجريان"},{"id":"b","text":"لأنّ الجلد ينتج دمًا"},{"id":"c","text":"لأنّ القلب يتوقّف"},{"id":"d","text":"لأنّ القلب يضخّ الدم بسرعةٍ أكبر إلى الجلد والعضلات أثناء الجهد"}]'::jsonb, 'd', 'أثناء الجهد يسرّع القلب ضخّه فيزداد جريان الدم إلى الجلد والعضلات، فيحمرّ الوجه ويعمل الجسم على تبريد نفسه بالعرق. الفخّ الشائع توهّم توقّف القلب أو الدم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb0919ef-f526-5911-93e3-b5e299af0d33', '7c650208-506e-5efc-8f2f-fbe379906487', 'تلميذٌ قال: «القلب يصفّي الهواء مثل الأنف.» أين الخطأ؟', '[{"id":"a","text":"الخطأ أنّ القلب يرى"},{"id":"b","text":"الخطأ أنّ القلب يضخّ الدم، أمّا تصفية الهواء فمن وظائف الأنف والجهاز التنفّسيّ"},{"id":"c","text":"لا خطأ، فالقلب يصفّي الهواء"},{"id":"d","text":"الخطأ أنّ القلب يهضم الطعام"}]'::jsonb, 'b', 'القلب مضخّةٌ تضخّ الدم؛ أمّا تصفية الهواء فمن وظائف الأنف والجهاز التنفّسيّ. هذا هو الخطأ الشائع: خلط وظائف الأعضاء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('798f05f0-f981-5969-837e-6c6f4e40092e', '7c650208-506e-5efc-8f2f-fbe379906487', 'رتّب مسار الدم في الدورة الصغرى بشكلٍ صحيح:', '[{"id":"a","text":"القلب ← الرئتان (أخذ الأكسجين وطرح غاز الفحم) ← القلب"},{"id":"b","text":"القلب ← المعدة ← القلب"},{"id":"c","text":"الرئتان ← الجلد ← الرئتان"},{"id":"d","text":"القلب ← القدمان ← القلب"}]'::jsonb, 'a', 'في الدورة الصغرى: يخرج الدم من القلب ← يذهب إلى الرئتين فيأخذ الأكسجين ويطرح غاز الفحم ← يعود إلى القلب. هذا هو المسار الصحيح.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fd3003ad-9452-5cb3-a199-5490d7223cbd', '637e7981-42ce-59d6-9af7-43ab233e8224', 'eveil-scientifique-5eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('45621ae6-6ef5-5f37-8d6d-dbe1eb38f761', 'fd3003ad-9452-5cb3-a199-5490d7223cbd', 'ما مصدر الكهرباء في الدارة البسيطة؟', '[{"id":"a","text":"المولّد (العمود/البطاريّة)"},{"id":"b","text":"السلك"},{"id":"c","text":"الزرّ"},{"id":"d","text":"المصباح"}]'::jsonb, 'a', 'المولّد (العمود أو البطاريّة) هو مصدر الكهرباء في الدارة الكهربائيّة البسيطة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('49f1c036-4322-50c6-95d5-ee9e3097134a', 'fd3003ad-9452-5cb3-a199-5490d7223cbd', 'متى يضيء المصباح في الدارة؟', '[{"id":"a","text":"عندما يُقطع أحد الأسلاك"},{"id":"b","text":"عندما تكون الدارة مغلقة"},{"id":"c","text":"عندما يُنزع المولّد"},{"id":"d","text":"عندما تكون الدارة مفتوحة"}]'::jsonb, 'b', 'يضيء المصباح عندما تكون الدارة مغلقة، فيجد التيّار طريقًا متّصلًا يمرّ فيه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2ae445ad-6d83-5c6e-b4b1-3a883f3a4a61', 'fd3003ad-9452-5cb3-a199-5490d7223cbd', 'أيٌّ ممّا يلي مادّةٌ ناقلةٌ للكهرباء؟', '[{"id":"a","text":"الخشب"},{"id":"b","text":"البلاستيك"},{"id":"c","text":"النحاس"},{"id":"d","text":"الزجاج"}]'::jsonb, 'c', 'النحاس معدنٌ ناقلٌ للكهرباء يسمح بمرور التيّار. أمّا الخشب والبلاستيك والزجاج فموادّ عازلة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2041117d-b5c8-5688-ac4b-f98a06982405', 'fd3003ad-9452-5cb3-a199-5490d7223cbd', 'أيّ سلوكٍ آمنٌ مع الكهرباء؟', '[{"id":"a","text":"اللعب قرب الأسلاك الكبيرة"},{"id":"b","text":"لمس الأسلاك العارية بيدٍ مبلّلة"},{"id":"c","text":"إدخال مسمارٍ في مأخذ الكهرباء"},{"id":"d","text":"طلب مساعدة الكبار عند مشكلٍ كهربائيّ"}]'::jsonb, 'd', 'طلب مساعدة الكبار عند أيّ مشكلٍ كهربائيّ سلوكٌ آمن. أمّا لمس الأسلاك بيدٍ مبلّلة وإدخال الأشياء في المأخذ فخطِرٌ جدًّا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2a2270cb-8afe-52a9-abcf-d77aedece45b', 'fd3003ad-9452-5cb3-a199-5490d7223cbd', 'في الصورة دارةٌ كهربائيّة. هل المصباح يضيء؟ <svg viewBox="0 0 170 120" xmlns="http://www.w3.org/2000/svg"><rect x="60" y="95" width="50" height="18" fill="#fcd116" stroke="#1f2937" stroke-width="3"/><text x="72" y="108" font-size="9" fill="#1f2937">مولّد</text><polyline points="60,95 25,95 25,30 70,30" fill="none" stroke="#b45309" stroke-width="3"/><polyline points="110,95 145,95 145,30 100,30" fill="none" stroke="#b45309" stroke-width="3"/><circle cx="85" cy="30" r="15" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><g stroke="#f59e0b" stroke-width="2"><line x1="85" y1="8" x2="85" y2="13"/><line x1="107" y1="30" x2="112" y2="30"/><line x1="63" y1="30" x2="58" y2="30"/></g></svg>', '[{"id":"a","text":"لا، لأنّ المصباح مكسور"},{"id":"b","text":"نعم، لأنّ الدارة مغلقة والتيّار يجد طريقًا متّصلًا"},{"id":"c","text":"لا، لأنّ الدارة مفتوحة"},{"id":"d","text":"لا، لأنّه لا يوجد مولّد"}]'::jsonb, 'b', 'الأسلاك تصل المولّد بالمصباح في حلقةٍ متّصلة، فالدارة مغلقة ويمرّ التيّار، فيضيء المصباح.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('fc4164dd-336d-59e9-8d54-cb7f301a85a7', '637e7981-42ce-59d6-9af7-43ab233e8224', 'eveil-scientifique-5eme', '⭐ تمرين: أبني دارةً كهربائيّة', 1, 50, 10, 'practice', 'admin', 1)
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
  ('5a7c34b9-7bde-5cad-9889-286211bc374e', 'fc4164dd-336d-59e9-8d54-cb7f301a85a7', 'العنصر الذي يستهلك الكهرباء فيضيء هو:', '[{"id":"a","text":"المصباح"},{"id":"b","text":"المولّد"},{"id":"c","text":"السلك"},{"id":"d","text":"القاطعة"}]'::jsonb, 'a', 'المصباح يستهلك الكهرباء فيضيء عند مرور التيّار فيه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('36a4f63a-c226-51e7-837c-aabb90a99b4e', 'fc4164dd-336d-59e9-8d54-cb7f301a85a7', 'ما الذي ينقل الكهرباء بين عناصر الدارة؟', '[{"id":"a","text":"الماء العذب"},{"id":"b","text":"الأسلاك"},{"id":"c","text":"الزجاج"},{"id":"d","text":"الهواء"}]'::jsonb, 'b', 'الأسلاك (وهي معدنيّة ناقلة) تنقل الكهرباء بين عناصر الدارة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fb8bfe74-a7ae-5a94-ab47-e1f7729ea6e6', 'fc4164dd-336d-59e9-8d54-cb7f301a85a7', 'إذا قطعنا سلكًا في الدارة فإنّ المصباح:', '[{"id":"a","text":"يتحوّل إلى مولّد"},{"id":"b","text":"يضيء أكثر"},{"id":"c","text":"ينطفئ لأنّ الدارة صارت مفتوحة"},{"id":"d","text":"يبقى مضيئًا كما هو"}]'::jsonb, 'c', 'قطع السلك يفتح الدارة فينقطع طريق التيّار، فلا يضيء المصباح.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0dd9ed98-8e44-5050-8c95-56aa3517b751', 'fc4164dd-336d-59e9-8d54-cb7f301a85a7', 'أيٌّ ممّا يلي مادّةٌ عازلة؟', '[{"id":"a","text":"الألمنيوم"},{"id":"b","text":"النحاس"},{"id":"c","text":"الحديد"},{"id":"d","text":"البلاستيك"}]'::jsonb, 'd', 'البلاستيك مادّةٌ عازلة تمنع مرور التيّار. أمّا النحاس والحديد والألمنيوم فمعادن ناقلة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('66a45c07-701a-5a70-a534-74628c9ff315', 'fc4164dd-336d-59e9-8d54-cb7f301a85a7', 'ما دور القاطعة (الزرّ) في الدارة؟', '[{"id":"a","text":"إنتاج الكهرباء"},{"id":"b","text":"فتح الدارة أو غلقها للتحكّم في الإشعال والإطفاء"},{"id":"c","text":"استهلاك الكهرباء فتضيء"},{"id":"d","text":"تخزين الماء"}]'::jsonb, 'b', 'القاطعة (الزرّ) تفتح الدارة أو تغلقها، فنتحكّم بها في إشعال المصباح وإطفائه.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('eba3afda-8159-5501-bbc8-66bab893d990', 'fc4164dd-336d-59e9-8d54-cb7f301a85a7', 'أيّ سلوكٍ آمنٌ مع الكهرباء؟', '[{"id":"a","text":"عدم إدخال أيّ شيءٍ في مأخذ الكهرباء"},{"id":"b","text":"اللعب بالأسلاك العارية"},{"id":"c","text":"قطع الأسلاك باليد"},{"id":"d","text":"لمس المقابس بيدٍ مبلّلة"}]'::jsonb, 'a', 'عدم إدخال أيّ شيءٍ في المأخذ سلوكٌ آمن يحمينا من الصدمة الكهربائيّة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('a531854e-ec8f-52c1-ae07-7af13a71b351', '637e7981-42ce-59d6-9af7-43ab233e8224', 'eveil-scientifique-5eme', '⚔️ زعيم الفصل ⭐⭐⭐: حارسُ التيّار', 3, 120, 30, 'boss', 'admin', 2)
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
  ('6fe9645b-bfae-57b1-bfe1-6048f80f82e3', 'a531854e-ec8f-52c1-ae07-7af13a71b351', 'لماذا لا يضيء المصباح عند فتح الزرّ (القاطعة)؟', '[{"id":"a","text":"لأنّ فتح الزرّ يقطع الدارة فلا يجد التيّار طريقًا متّصلًا"},{"id":"b","text":"لأنّ المصباح ينتج الكهرباء"},{"id":"c","text":"لأنّ المولّد ينطفئ"},{"id":"d","text":"لأنّ السلك يصبح عازلًا"}]'::jsonb, 'a', 'فتح الزرّ يفتح الدارة فينقطع طريق التيّار المتّصل، فلا يمرّ التيّار ولا يضيء المصباح. الخطأ الشائع توهّم أنّ المصباح ينتج الكهرباء بنفسه.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('23e9722a-4875-5325-ae06-d1c37160a59c', 'a531854e-ec8f-52c1-ae07-7af13a71b351', 'نضع قطعة خشبٍ مكان جزءٍ من السلك في الدارة. ماذا يحدث للمصباح؟', '[{"id":"a","text":"يضيء أكثر"},{"id":"b","text":"لا يضيء لأنّ الخشب عازلٌ يمنع مرور التيّار"},{"id":"c","text":"يضيء كالعادة"},{"id":"d","text":"يتحوّل الخشب إلى نحاس"}]'::jsonb, 'b', 'الخشب مادّةٌ عازلة تمنع مرور التيّار؛ فوضعه في الدارة يقطع طريق التيّار فلا يضيء المصباح. الخطأ الشائع ظنّ أنّ كلّ المواد تنقل الكهرباء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('2236f3ee-58df-5cc2-9d3a-85af5397d20b', 'a531854e-ec8f-52c1-ae07-7af13a71b351', 'ما دور الصّهيرة في الدارة الكهربائيّة؟', '[{"id":"a","text":"تضيء بدل المصباح"},{"id":"b","text":"تخزّن الماء"},{"id":"c","text":"تنصهر فتقطع التيّار تلقائيًّا عند مروره بقوّةٍ خطيرة فتحمي الدارة"},{"id":"d","text":"تنتج الكهرباء"}]'::jsonb, 'c', 'الصّهيرة قطعةٌ تنصهر عند مرور تيّارٍ قويٍّ خطير، فتقطع الدارة وتحميها من الخطر. الخطأ الشائع نسبة وظيفة المولّد أو المصباح إليها.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce4cd562-f09d-57c7-8b76-d1aeaf84d688', 'a531854e-ec8f-52c1-ae07-7af13a71b351', 'لماذا تُغلّف الأسلاك الكهربائيّة بالبلاستيك؟', '[{"id":"a","text":"لأنّ البلاستيك ناقلٌ يقوّي التيّار"},{"id":"b","text":"لتزيين السلك فقط"},{"id":"c","text":"ليصبح السلك أثقل"},{"id":"d","text":"لأنّ البلاستيك عازلٌ يمنع وصول التيّار إلى أيدينا فيحمينا"}]'::jsonb, 'd', 'يُغلّف السلك (وهو معدنٌ ناقل) بالبلاستيك العازل لمنع وصول التيّار إلى أيدينا عند لمسه، فيحمينا من الصدمة. الفخّ الشائع ظنّ أنّ البلاستيك يقوّي التيّار.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3a5dcae6-37b1-5114-9f96-6326a8a735fc', 'a531854e-ec8f-52c1-ae07-7af13a71b351', 'أيّ زوجٍ صحيحٌ (مادّة ← نوعها)؟', '[{"id":"a","text":"الزجاج ← ناقل"},{"id":"b","text":"النحاس ← ناقل"},{"id":"c","text":"الحديد ← عازل"},{"id":"d","text":"البلاستيك ← ناقل"}]'::jsonb, 'b', 'النحاس معدنٌ ناقلٌ للكهرباء، وهذا الزوج صحيح. الحديد ناقل (لا عازل)، والبلاستيك والزجاج عازلان.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e12bebd5-7af5-5866-9722-d41fd8cab12b', 'a531854e-ec8f-52c1-ae07-7af13a71b351', 'لماذا يخطر لمس الأجهزة الكهربائيّة بأيدٍ مبلّلة؟', '[{"id":"a","text":"لأنّ الماء يساعد على نقل التيّار إلى الجسم فيزيد خطر الصدمة"},{"id":"b","text":"لأنّ الماء يطفئ الكهرباء تمامًا فلا خطر"},{"id":"c","text":"لأنّ اليد المبلّلة عازلة تمامًا"},{"id":"d","text":"لأنّ الماء يحوّل التيّار إلى ضوء"}]'::jsonb, 'a', 'الماء يساعد على نقل التيّار، فاليد المبلّلة تسهّل وصول الكهرباء إلى الجسم وتزيد خطر الصدمة؛ لذلك لا نلمس الأجهزة بأيدٍ مبلّلة. الفخّ الشائع ظنّ أنّ الماء يحمي.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9f2d8f19-b5ff-5405-bbc7-2e7c9d3b2d87', '637e7981-42ce-59d6-9af7-43ab233e8224', 'eveil-scientifique-5eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الدارةُ والمواد', 2, 75, 15, 'practice', 'admin', 3)
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
  ('9f5dab6d-35fc-5014-a475-c72b7587dfc9', '9f2d8f19-b5ff-5405-bbc7-2e7c9d3b2d87', 'عناصر الدارة الكهربائيّة البسيطة هي:', '[{"id":"a","text":"المولّد والأسلاك والمصباح والقاطعة"},{"id":"b","text":"القلب والرئتان والمعدة"},{"id":"c","text":"العين والأذن والأنف"},{"id":"d","text":"الماء والهواء والتراب"}]'::jsonb, 'a', 'الدارة البسيطة تتكوّن من المولّد (مصدر الكهرباء) والأسلاك (تنقلها) والمصباح (يستهلكها) والقاطعة (للتحكّم).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6c367ded-025d-552c-adae-c256211bbcf8', '9f2d8f19-b5ff-5405-bbc7-2e7c9d3b2d87', 'الدارة المغلقة هي التي:', '[{"id":"a","text":"فيها سلكٌ مقطوع"},{"id":"b","text":"يجد فيها التيّار طريقًا متّصلًا فيضيء المصباح"},{"id":"c","text":"لا مولّد فيها"},{"id":"d","text":"زرّها مفتوح"}]'::jsonb, 'b', 'الدارة المغلقة يجد فيها التيّار طريقًا متّصلًا من المولّد إلى المصباح ثمّ يعود، فيضيء المصباح.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7b0e3f43-53fc-5ce6-824f-b798e199ae3a', '9f2d8f19-b5ff-5405-bbc7-2e7c9d3b2d87', 'أيّ زوجٍ صحيحٌ (مادّة ← نوعها)؟', '[{"id":"a","text":"الحديد ← عازل"},{"id":"b","text":"الخشب ← ناقل"},{"id":"c","text":"المطّاط ← عازل"},{"id":"d","text":"النحاس ← عازل"}]'::jsonb, 'c', 'المطّاط مادّةٌ عازلة تمنع مرور التيّار. أمّا النحاس والحديد فناقلان، والخشب عازل.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d3d2abe7-5fdd-5e42-9de4-985753a9a516', '9f2d8f19-b5ff-5405-bbc7-2e7c9d3b2d87', 'لماذا نستعمل القاطعة في الإنارة المنزليّة؟', '[{"id":"a","text":"لإنتاج الكهرباء"},{"id":"b","text":"لتسخين الغرفة"},{"id":"c","text":"لتنقية الهواء"},{"id":"d","text":"لنتحكّم في إشعال المصباح وإطفائه بفتح الدارة وغلقها"}]'::jsonb, 'd', 'القاطعة (الزرّ) تفتح الدارة وتغلقها، فنتحكّم بها في إشعال المصباح وإطفائه متى شئنا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6c6bf5ed-1ca4-5815-8ed3-e455232ea44d', '9f2d8f19-b5ff-5405-bbc7-2e7c9d3b2d87', 'الموادّ العازلة في الدارة الكهربائيّة:', '[{"id":"a","text":"تضيء بدل المصباح"},{"id":"b","text":"تمنع مرور التيّار"},{"id":"c","text":"تقوّي التيّار"},{"id":"d","text":"تنتج الكهرباء"}]'::jsonb, 'b', 'الموادّ العازلة مثل البلاستيك والخشب تمنع مرور التيّار الكهربائيّ في الدارة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('29e3891a-0477-57fc-95b1-e343096525fb', '9f2d8f19-b5ff-5405-bbc7-2e7c9d3b2d87', 'في الصورة دارةٌ فيها سلكٌ مقطوع (فجوة). هل يضيء المصباح؟ <svg viewBox="0 0 170 120" xmlns="http://www.w3.org/2000/svg"><rect x="60" y="95" width="50" height="18" fill="#fcd116" stroke="#1f2937" stroke-width="3"/><polyline points="60,95 25,95 25,30 55,30" fill="none" stroke="#b45309" stroke-width="3"/><polyline points="110,95 145,95 145,30 100,30" fill="none" stroke="#b45309" stroke-width="3"/><circle cx="85" cy="30" r="15" fill="#e5e7eb" stroke="#1f2937" stroke-width="3"/><line x1="63" y1="30" x2="70" y2="30" stroke="#b45309" stroke-width="3"/><line x1="45" y1="22" x2="58" y2="38" stroke="#ef4444" stroke-width="2"/><line x1="58" y1="22" x2="45" y2="38" stroke="#ef4444" stroke-width="2"/></svg>', '[{"id":"a","text":"لا، لأنّ السلك مقطوع فالدارة مفتوحة"},{"id":"b","text":"نعم، رغم القطع"},{"id":"c","text":"لا، لأنّ المصباح مولّد"},{"id":"d","text":"نعم، يضيء بقوّة"}]'::jsonb, 'a', 'الفجوة (X الحمراء) تبيّن أنّ السلك مقطوع، فالدارة مفتوحة وينقطع طريق التيّار، فلا يضيء المصباح.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('cc5cac2f-b9fa-5393-9cac-c64be053555b', '637e7981-42ce-59d6-9af7-43ab233e8224', 'eveil-scientifique-5eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: عبقريُّ الكهرباء', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('ba884777-7c88-52aa-93b1-7f62baae9bf3', 'cc5cac2f-b9fa-5393-9cac-c64be053555b', 'نريد اختبار مادّةٍ مجهولة: هل هي ناقلة أم عازلة؟ كيف نفعل؟', '[{"id":"a","text":"نضعها في الدارة مكان جزءٍ من السلك: إن أضاء المصباح فهي ناقلة، وإلّا فهي عازلة"},{"id":"b","text":"نشمّها بالأنف"},{"id":"c","text":"نسمع صوتها بالأذن"},{"id":"d","text":"نزنها بالميزان"}]'::jsonb, 'a', 'نضع المادّة المجهولة في الدارة ضمن المسار: إن مرّ التيّار وأضاء المصباح فهي ناقلة، وإن بقي مطفأً فهي عازلة. هذه طريقةٌ علميّة للاختبار.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c4530f0-dac4-5147-bbad-8a512d221256', 'cc5cac2f-b9fa-5393-9cac-c64be053555b', 'مصباحان في دارةٍ واحدةٍ متّصلان على التوالي (واحدًا بعد الآخر). إذا نزعنا أحدهما من مكانه ماذا يحدث للآخر؟', '[{"id":"a","text":"يتحوّل الآخر إلى مولّد"},{"id":"b","text":"ينطفئ الآخر لأنّ نزع أحدهما يفتح الدارة فينقطع التيّار"},{"id":"c","text":"يضيء الآخر أكثر"},{"id":"d","text":"يبقى الآخر مضيئًا كما هو"}]'::jsonb, 'b', 'عندما يكون المصباحان على التوالي في طريقٍ واحد، نزع أحدهما يفتح الدارة فينقطع التيّار، فينطفئ الآخر أيضًا. الفخّ الشائع توهّم استقلال المصباحين.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e0db8c60-0c42-599d-b9eb-f7f38b74539d', 'cc5cac2f-b9fa-5393-9cac-c64be053555b', 'لماذا تنصهر الصّهيرة عند حدوث ماسٍّ كهربائيٍّ (تيّارٍ قويٍّ مفاجئ)؟', '[{"id":"a","text":"لتضيء بدل المصباح"},{"id":"b","text":"لتنتج كهرباء جديدة"},{"id":"c","text":"لتقطع الدارة بسرعةٍ وتحمي الأجهزة والمنزل من خطر التيّار القويّ"},{"id":"d","text":"لتزيد التيّار أكثر"}]'::jsonb, 'c', 'عند مرور تيّارٍ قويٍّ خطير تنصهر الصّهيرة فتقطع الدارة بسرعة، فتمنع وصول هذا التيّار إلى الأجهزة وتحمي المنزل. الفخّ الشائع نسبة أدوارٍ معاكسة لها.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('82dcdbda-5e56-5a5c-9a38-22223f2f9f57', 'cc5cac2f-b9fa-5393-9cac-c64be053555b', 'تلميذٌ قال: «المصباح يضيء بنفسه دون مولّد.» أين الخطأ؟', '[{"id":"a","text":"لا خطأ، فالمصباح ينتج الكهرباء"},{"id":"b","text":"الخطأ أنّ المولّد يستهلك الكهرباء"},{"id":"c","text":"الخطأ أنّ السلك ينتج الكهرباء"},{"id":"d","text":"الخطأ أنّ المصباح يستهلك الكهرباء ولا ينتجها؛ يحتاج مولّدًا يمدّه بالتيّار"}]'::jsonb, 'd', 'المصباح يستهلك الكهرباء فيضيء، ولا ينتجها؛ فهو يحتاج مولّدًا (عمودًا) يمدّه بالتيّار عبر دارةٍ مغلقة. هذا هو الخطأ الشائع: ظنّ أنّ المصباح مصدرٌ للكهرباء.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5a31b348-2f53-5b4c-835d-c72bd212607b', 'cc5cac2f-b9fa-5393-9cac-c64be053555b', 'لماذا نطلب مساعدة شخصٍ كبيرٍ عند رؤية سلكٍ كهربائيٍّ عارٍ في المنزل؟', '[{"id":"a","text":"لأنّ لمسه يقوّي الكهرباء"},{"id":"b","text":"لأنّ لمسه خطِرٌ قد يسبّب صدمةً كهربائيّة، والكبار يعالجونه بأمان"},{"id":"c","text":"لأنّ السلك العاري ينتج ضوءًا مفيدًا"},{"id":"d","text":"لأنّ السلك العاري لا خطر منه إطلاقًا"}]'::jsonb, 'b', 'السلك العاري قد يمرّر التيّار إلى من يلمسه فيسبّب صدمةً خطيرة؛ لذلك نتجنّب لمسه ونطلب من الكبار معالجته بأمان. باقي الخيارات تستهين بالخطر.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7c575440-b687-570a-98ce-23c088e715d0', 'cc5cac2f-b9fa-5393-9cac-c64be053555b', 'في الصورة دارتان: 1 حلقتها متّصلة، و2 فيها فجوةٌ عند الزرّ. أيّ مصباحٍ يضيء؟ <svg viewBox="0 0 230 110" xmlns="http://www.w3.org/2000/svg"><rect x="15" y="80" width="36" height="14" fill="#fcd116" stroke="#1f2937" stroke-width="2"/><polyline points="15,80 8,80 8,30 28,30" fill="none" stroke="#b45309" stroke-width="2"/><polyline points="51,80 58,80 58,30 44,30" fill="none" stroke="#b45309" stroke-width="2"/><circle cx="36" cy="30" r="11" fill="#fde047" stroke="#1f2937" stroke-width="2"/><text x="30" y="108" font-size="12" fill="#1f2937">1</text><rect x="140" y="80" width="36" height="14" fill="#fcd116" stroke="#1f2937" stroke-width="2"/><polyline points="140,80 133,80 133,30 153,30" fill="none" stroke="#b45309" stroke-width="2"/><polyline points="176,80 200,80 200,30 185,30" fill="none" stroke="#b45309" stroke-width="2"/><line x1="185" y1="30" x2="176" y2="20" stroke="#b45309" stroke-width="2"/><circle cx="169" cy="30" r="11" fill="#e5e7eb" stroke="#1f2937" stroke-width="2"/><line x1="178" y1="40" x2="190" y2="22" stroke="#ef4444" stroke-width="2"/><line x1="190" y1="40" x2="178" y2="22" stroke="#ef4444" stroke-width="2"/><text x="155" y="108" font-size="12" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"المصباح رقم 1 (الدارة المتّصلة)"},{"id":"b","text":"المصباح رقم 2 (الزرّ مفتوح)"},{"id":"c","text":"كلاهما يضيء"},{"id":"d","text":"لا أحد يضيء"}]'::jsonb, 'a', 'الدارة 1 حلقتها متّصلة (مغلقة) فيمرّ التيّار ويضيء مصباحها (الأصفر). أمّا الدارة 2 ففيها فجوةٌ عند الزرّ المفتوح (الدارة مفتوحة) فلا يضيء مصباحها (الرماديّ).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('caf47842-b908-5477-857f-b5eaab0b797a', '637e7981-42ce-59d6-9af7-43ab233e8224', 'eveil-scientifique-5eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملةٌ للكهرباء', 3, 120, 30, 'boss', 'admin', 5)
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
  ('b3066aaa-0639-5c6f-a23d-62cf3d7e464d', 'caf47842-b908-5477-857f-b5eaab0b797a', 'ما العنصر الذي يُعتبر مصدر الكهرباء في الدارة؟', '[{"id":"a","text":"المولّد (العمود/البطاريّة)"},{"id":"b","text":"المصباح"},{"id":"c","text":"السلك"},{"id":"d","text":"القاطعة"}]'::jsonb, 'a', 'المولّد (العمود أو البطاريّة) هو مصدر الكهرباء الذي يمدّ الدارة بالتيّار.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5b7362a5-45a3-5113-bc8f-1e215f7e9c46', 'caf47842-b908-5477-857f-b5eaab0b797a', 'أيّ مجموعةٍ كلّها موادّ ناقلة؟', '[{"id":"a","text":"الخشب، النحاس، المطّاط"},{"id":"b","text":"النحاس، الحديد، الألمنيوم"},{"id":"c","text":"البلاستيك، الخشب، الزجاج"},{"id":"d","text":"المطّاط، الورق، الزجاج"}]'::jsonb, 'b', 'النحاس والحديد والألمنيوم معادن ناقلة تسمح بمرور التيّار. (ب) و(ج) موادّ عازلة، و(د) مختلطة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('633dfe1a-39cd-531a-9e8c-880dad522ad1', 'caf47842-b908-5477-857f-b5eaab0b797a', 'ما الفرق بين القاطعة والصّهيرة؟', '[{"id":"a","text":"القاطعة تنصهر والصّهيرة زرّ"},{"id":"b","text":"كلاهما يضيء بدل المصباح"},{"id":"c","text":"القاطعة زرٌّ نفتح به الدارة للتحكّم، والصّهيرة تنصهر تلقائيًّا عند الخطر فتحمي الدارة"},{"id":"d","text":"كلاهما ينتج الكهرباء"}]'::jsonb, 'c', 'القاطعة زرٌّ نتحكّم به في فتح الدارة وغلقها، أمّا الصّهيرة فتنصهر تلقائيًّا عند مرور تيّارٍ خطير فتقطع الدارة وتحميها. لكلٍّ دورٌ مختلف.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d017098f-b89f-5736-aa9b-7c08f5b568a6', 'caf47842-b908-5477-857f-b5eaab0b797a', 'لماذا تُصنع مقابض أدوات الكهربائيّ من البلاستيك أو المطّاط؟', '[{"id":"a","text":"لأنّهما ناقلان يقوّيان التيّار"},{"id":"b","text":"لتزيين الأدوات فقط"},{"id":"c","text":"ليصبح وزنها أثقل"},{"id":"d","text":"لأنّهما عازلان يمنعان وصول التيّار إلى يده فيحميانه"}]'::jsonb, 'd', 'البلاستيك والمطّاط عازلان يمنعان مرور التيّار إلى يد الكهربائيّ، فيحميانه من الصدمة أثناء العمل. الفخّ الشائع ظنّ أنّهما ناقلان.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f39ababd-1e11-5da4-a312-96d0c16cd24c', 'caf47842-b908-5477-857f-b5eaab0b797a', 'تلميذٌ قال: «كلّ المواد تنقل الكهرباء.» أين الخطأ؟', '[{"id":"a","text":"الخطأ أنّ المصباح مادّة عازلة"},{"id":"b","text":"الخطأ أنّ الموادّ نوعان: ناقلة (المعادن) وعازلة (البلاستيك والخشب) لا تمرّر التيّار"},{"id":"c","text":"لا خطأ، فكلّ المواد ناقلة"},{"id":"d","text":"الخطأ أنّ المعادن عازلة"}]'::jsonb, 'b', 'ليست كلّ المواد ناقلة؛ فالمعادن ناقلة تمرّر التيّار، أمّا البلاستيك والخشب والزجاج فعازلة تمنعه. هذا هو الخطأ الشائع: تعميم النقل على كلّ المواد.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('d0b58213-1bc6-5951-9e73-a1c568608068', 'caf47842-b908-5477-857f-b5eaab0b797a', 'رتّب شرط إضاءة المصباح بشكلٍ صحيح:', '[{"id":"a","text":"مولّدٌ + أسلاكٌ متّصلة + دارةٌ مغلقة ← يمرّ التيّار ← يضيء المصباح"},{"id":"b","text":"دارةٌ مفتوحة ← يمرّ التيّار ← يضيء المصباح"},{"id":"c","text":"مصباحٌ وحده دون مولّد ← يضيء"},{"id":"d","text":"سلكٌ مقطوع ← يمرّ التيّار ← يضيء المصباح"}]'::jsonb, 'a', 'يضيء المصباح هكذا: مولّدٌ يمدّ التيّار + أسلاكٌ متّصلة تشكّل دارةً مغلقة ← يمرّ التيّار في طريقٍ متّصل ← يضيء المصباح. هذا هو الترتيب الصحيح.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5a575d74-6590-5839-ad3b-80c2ee232fe6', '355404c0-718e-5471-abe9-6d83b0333716', 'eveil-scientifique-5eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('d727ca1d-e171-56b0-a284-a9be5d5e290e', '5a575d74-6590-5839-ad3b-80c2ee232fe6', 'الحيوان الذي يأكل النباتات فقط يُسمّى:', '[{"id":"a","text":"عاشبًا"},{"id":"b","text":"لاحمًا"},{"id":"c","text":"مفترسًا"},{"id":"d","text":"نباتًا"}]'::jsonb, 'a', 'الحيوان الذي يأكل النباتات فقط يُسمّى عاشبًا، مثل الأرنب والبقرة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dfe9fe41-6f1f-57f0-85f9-3beb5663205b', '5a575d74-6590-5839-ad3b-80c2ee232fe6', 'بماذا تبدأ كلّ سلسلةٍ غذائيّة؟', '[{"id":"a","text":"بحيوانٍ لاحم"},{"id":"b","text":"بنبتة"},{"id":"c","text":"بحجر"},{"id":"d","text":"بالماء"}]'::jsonb, 'b', 'تبدأ السلسلة الغذائيّة دائمًا بنبتة، لأنّها تصنع غذاءها بنفسها بمساعدة الضوء.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('302d2779-7a86-5af4-af1d-4328f2e4f951', '5a575d74-6590-5839-ad3b-80c2ee232fe6', 'الأسد الذي يأكل الغزال حيوانٌ:', '[{"id":"a","text":"عاشب"},{"id":"b","text":"نبات"},{"id":"c","text":"لاحم"},{"id":"d","text":"يأكل التراب"}]'::jsonb, 'c', 'الأسد يأكل حيواناتٍ أخرى مثل الغزال، فهو حيوانٌ لاحم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6492618a-4d8c-5ecb-bea8-5c1b3c807437', '5a575d74-6590-5839-ad3b-80c2ee232fe6', 'أيٌّ ممّا يلي عنصرٌ غير حيٍّ في الوسط البيئيّ؟', '[{"id":"a","text":"الأرنب"},{"id":"b","text":"شجرة"},{"id":"c","text":"الماء"},{"id":"d","text":"العصفور"}]'::jsonb, 'c', 'الماء عنصرٌ غير حيٍّ في الوسط البيئيّ. أمّا الأرنب والشجرة والعصفور فكائناتٌ حيّة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3884acb-7bce-5f1a-aeaf-513b1e82583c', '5a575d74-6590-5839-ad3b-80c2ee232fe6', 'في الصورة سلسلةٌ غذائيّة. ماذا يأكل الأرنب؟ <svg viewBox="0 0 230 70" xmlns="http://www.w3.org/2000/svg"><path d="M22 55 q-8 -22 0 -34 q8 12 0 34 z" fill="#22c55e" stroke="#1f2937" stroke-width="2"/><rect x="20" y="55" width="4" height="8" fill="#16a34a"/><text x="6" y="68" font-size="10" fill="#1f2937">نبتة</text><line x1="38" y1="40" x2="78" y2="40" stroke="#1f2937" stroke-width="2"/><polygon points="78,40 68,35 68,45" fill="#1f2937"/><ellipse cx="100" cy="40" rx="18" ry="12" fill="#d6d3d1" stroke="#1f2937" stroke-width="2"/><ellipse cx="92" cy="26" rx="4" ry="9" fill="#d6d3d1" stroke="#1f2937" stroke-width="2"/><text x="90" y="68" font-size="10" fill="#1f2937">أرنب</text><line x1="122" y1="40" x2="162" y2="40" stroke="#1f2937" stroke-width="2"/><polygon points="162,40 152,35 152,45" fill="#1f2937"/><ellipse cx="190" cy="40" rx="22" ry="13" fill="#f97316" stroke="#1f2937" stroke-width="2"/><polygon points="178,30 174,20 184,28" fill="#f97316" stroke="#1f2937" stroke-width="1"/><text x="176" y="68" font-size="10" fill="#1f2937">ثعلب</text></svg>', '[{"id":"a","text":"النبتة"},{"id":"b","text":"الثعلب"},{"id":"c","text":"الماء"},{"id":"d","text":"لا يأكل شيئًا"}]'::jsonb, 'a', 'السهم يتّجه من النبتة إلى الأرنب، أي أنّ الأرنب يأكل النبتة. ثمّ يتّجه سهمٌ من الأرنب إلى الثعلب لأنّ الثعلب يأكل الأرنب.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('d1bfb4b3-df85-5fc7-803a-4ec419db31e1', '355404c0-718e-5471-abe9-6d83b0333716', 'eveil-scientifique-5eme', '⭐ تمرين: من يأكل من؟', 1, 50, 10, 'practice', 'admin', 1)
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
  ('930a6370-293a-56d1-a4e4-3deec889104a', 'd1bfb4b3-df85-5fc7-803a-4ec419db31e1', 'البقرة التي تأكل العشب حيوانٌ:', '[{"id":"a","text":"عاشب"},{"id":"b","text":"لاحم"},{"id":"c","text":"نبات"},{"id":"d","text":"يأكل الحجارة"}]'::jsonb, 'a', 'البقرة تأكل العشب (نباتًا)، فهي حيوانٌ عاشب.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0246b885-2da2-56ce-bd27-52187745e24c', 'd1bfb4b3-df85-5fc7-803a-4ec419db31e1', 'تبدأ السلسلة الغذائيّة دائمًا بـ:', '[{"id":"a","text":"حيوانٍ لاحم"},{"id":"b","text":"نبتة"},{"id":"c","text":"ماء"},{"id":"d","text":"هواء"}]'::jsonb, 'b', 'تبدأ السلسلة الغذائيّة بنبتة لأنّها تصنع غذاءها بنفسها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1ea8d742-f15e-5400-8ada-ee360a6ffdf9', 'd1bfb4b3-df85-5fc7-803a-4ec419db31e1', 'أيّ هذه عنصرٌ حيٌّ في الوسط البيئيّ؟', '[{"id":"a","text":"الصخرة"},{"id":"b","text":"الهواء"},{"id":"c","text":"الشجرة"},{"id":"d","text":"الماء"}]'::jsonb, 'c', 'الشجرة كائنٌ حيٌّ في الوسط البيئيّ. أمّا الصخرة والهواء والماء فعناصر غير حيّة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('16aa9f85-76f2-5f12-a64a-738de8c8977c', 'd1bfb4b3-df85-5fc7-803a-4ec419db31e1', 'في السلسلة «عشب → غزال»، السهم يعني أنّ:', '[{"id":"a","text":"العشب والغزال لا علاقة بينهما"},{"id":"b","text":"الغزال نبات"},{"id":"c","text":"العشب يأكل الغزال"},{"id":"d","text":"الغزال يأكل العشب"}]'::jsonb, 'd', 'السهم يتّجه نحو الآكل؛ فـ«عشب → غزال» تعني أنّ الغزال يأكل العشب.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('5f5ced4d-2cd3-56c0-a752-685bada74d9a', 'd1bfb4b3-df85-5fc7-803a-4ec419db31e1', 'الثعلب الذي يصطاد الأرنب حيوانٌ:', '[{"id":"a","text":"عاشب"},{"id":"b","text":"لاحم"},{"id":"c","text":"نبات"},{"id":"d","text":"يأكل التراب"}]'::jsonb, 'b', 'الثعلب يصطاد ويأكل حيواناتٍ أخرى مثل الأرنب، فهو حيوانٌ لاحم.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('85bac3a0-1880-5a77-8fd8-f74c595958d6', 'd1bfb4b3-df85-5fc7-803a-4ec419db31e1', 'الفراشة تأخذ غذاءها من الأزهار عن طريق:', '[{"id":"a","text":"مصّ الرحيق"},{"id":"b","text":"قرض الخشب"},{"id":"c","text":"اصطياد الطيور"},{"id":"d","text":"أكل الحجارة"}]'::jsonb, 'a', 'الفراشة تمصّ رحيق الأزهار، فهذه طريقتها في أخذ الغذاء.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('77650b2a-3198-5bce-a012-9e94dbefb49d', '355404c0-718e-5471-abe9-6d83b0333716', 'eveil-scientifique-5eme', '⚔️ زعيم الفصل ⭐⭐⭐: حارسُ السلسلة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('3f966ed6-7238-5460-9a58-4262070d4823', '77650b2a-3198-5bce-a012-9e94dbefb49d', 'أيّ سلسلةٍ غذائيّةٍ مرتّبةٌ ترتيبًا صحيحًا؟', '[{"id":"a","text":"عشب → أرنب → ثعلب"},{"id":"b","text":"ثعلب → أرنب → عشب"},{"id":"c","text":"أرنب → عشب → ثعلب"},{"id":"d","text":"ثعلب → عشب → أرنب"}]'::jsonb, 'a', 'تبدأ السلسلة بنبتة (عشب) ← يأكلها العاشب (أرنب) ← يأكله اللاحم (ثعلب). السهم نحو الآكل. الخطأ الشائع عكس الترتيب أو السهم.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('fd3608cf-09c4-5d75-a75c-45d936366eb9', '77650b2a-3198-5bce-a012-9e94dbefb49d', 'تلميذٌ كتب «أرنب → عشب». أين الخطأ؟', '[{"id":"a","text":"لا خطأ، فالعشب يأكل الأرنب"},{"id":"b","text":"الخطأ أنّ السهم يجب أن يتّجه نحو الآكل؛ الصحيح «عشب → أرنب» لأنّ الأرنب يأكل العشب"},{"id":"c","text":"الخطأ أنّ الأرنب نبات"},{"id":"d","text":"الخطأ أنّ العشب حيوان"}]'::jsonb, 'b', 'السهم يتّجه دائمًا نحو الآكل؛ الأرنب يأكل العشب فالصحيح «عشب → أرنب». هذا هو الخطأ الشائع: عكس اتّجاه السهم.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('93d68ea7-8e0d-5bda-b5d9-6e88cf94d7a6', '77650b2a-3198-5bce-a012-9e94dbefb49d', 'في سلسلة «عشب → أرنب → ثعلب»، ماذا يحدث لو اختفى العشب تمامًا؟', '[{"id":"a","text":"يتحوّل الثعلب إلى عاشب فورًا"},{"id":"b","text":"لا يتأثّر أحد"},{"id":"c","text":"يجوع الأرنب ويقلّ عدده، فيقلّ غذاء الثعلب أيضًا"},{"id":"d","text":"يزداد عدد الأرانب"}]'::jsonb, 'c', 'العشب أوّل حلقة؛ اختفاؤه يجوّع الأرنب فيقلّ عدده، فيقلّ غذاء الثعلب الذي يأكل الأرنب. هذا يبيّن ترابط الحلقات في التوازن البيئيّ. الفخّ الشائع توهّم استقلال الحلقات.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cb68a4e7-a50e-53bf-8a39-4bb79d73d819', '77650b2a-3198-5bce-a012-9e94dbefb49d', 'أيّ حيوانٍ يُعدّ كالشًا (مختلطًا) يأكل النبات والحيوان معًا؟', '[{"id":"a","text":"الغزال (عاشب)"},{"id":"b","text":"الأسد (لاحم)"},{"id":"c","text":"الأرنب (عاشب)"},{"id":"d","text":"الدجاجة (تأكل الحبوب والديدان)"}]'::jsonb, 'd', 'الدجاجة تأكل الحبوب (نبات) والديدان (حيوان) معًا، فهي حيوانٌ كالش (مختلط). الأسد لاحم، والأرنب والغزال عاشبان.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b315569b-f2aa-55cd-9499-f92d3f55f422', '77650b2a-3198-5bce-a012-9e94dbefb49d', 'لماذا تُعدّ النبتة الحلقة الأولى في كلّ سلسلةٍ غذائيّة؟', '[{"id":"a","text":"لأنّها تصطاد فرائسها"},{"id":"b","text":"لأنّها تصنع غذاءها بنفسها بمساعدة الضوء، فتكون مصدر الغذاء للعواشب"},{"id":"c","text":"لأنّها تأكل الحيوانات"},{"id":"d","text":"لأنّها لا علاقة لها بالغذاء"}]'::jsonb, 'b', 'النبتة تصنع غذاءها بنفسها بمساعدة الضوء (لا تأكل غيرها)، فتكون مصدر الغذاء الأوّل الذي تأكله العواشب، ومنها تبدأ السلسلة. الفخّ الشائع نسبة الاصطياد للنبتة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('30e49c9c-3521-5a7e-9ed8-0974ed97f929', '77650b2a-3198-5bce-a012-9e94dbefb49d', 'أيّ زوجٍ صحيحٌ (حيوان ← صنفه)؟', '[{"id":"a","text":"الصقر ← لاحم"},{"id":"b","text":"البقرة ← لاحمة"},{"id":"c","text":"الأسد ← عاشب"},{"id":"d","text":"الأرنب ← لاحم"}]'::jsonb, 'a', 'الصقر يصطاد ويأكل حيواناتٍ أخرى، فهو لاحم. البقرة والأرنب عاشبان، والأسد لاحمٌ لا عاشب.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ed79968a-5c3a-580b-ae7a-2fbda3744016', '355404c0-718e-5471-abe9-6d83b0333716', 'eveil-scientifique-5eme', '⭐⭐ تمرين مراجعة (نمط امتحان): الكائناتُ والسلسلة', 2, 75, 15, 'practice', 'admin', 3)
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
  ('3cda0a5c-0dea-5eae-9187-63d5b6c0dc1a', 'ed79968a-5c3a-580b-ae7a-2fbda3744016', 'عناصر الوسط البيئيّ الحيّة هي:', '[{"id":"a","text":"النباتات والحيوانات"},{"id":"b","text":"الماء والهواء فقط"},{"id":"c","text":"التربة والصخور"},{"id":"d","text":"الضوء والحرارة"}]'::jsonb, 'a', 'العناصر الحيّة في الوسط البيئيّ هي النباتات والحيوانات. أمّا الماء والهواء والتربة والضوء فعناصر غير حيّة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('78db6d09-a1d4-5596-8a3f-ef609ac525a2', 'ed79968a-5c3a-580b-ae7a-2fbda3744016', 'أيّ زوجٍ صحيحٌ (حيوان ← غذاؤه)؟', '[{"id":"a","text":"البقرة ← الحيوانات"},{"id":"b","text":"الأرنب ← النباتات"},{"id":"c","text":"الأسد ← النباتات"},{"id":"d","text":"الغزال ← الحيوانات"}]'::jsonb, 'b', 'الأرنب عاشبٌ يأكل النباتات، وهذا الزوج صحيح. الأسد لاحم، والغزال والبقرة عاشبان لا لاحمان.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('8fd245d8-ac44-5491-b7ec-255f86ef0062', 'ed79968a-5c3a-580b-ae7a-2fbda3744016', 'في سلسلة «نبتة → جرادة → عصفور → صقر»، من يأكل الجرادة؟', '[{"id":"a","text":"لا أحد"},{"id":"b","text":"النبتة"},{"id":"c","text":"العصفور"},{"id":"d","text":"الصقر"}]'::jsonb, 'c', 'السهم يتّجه من الجرادة إلى العصفور، أي أنّ العصفور يأكل الجرادة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('cddf60fc-dd93-5b07-ba3c-e03ba664c7f4', 'ed79968a-5c3a-580b-ae7a-2fbda3744016', 'لماذا نحافظ على التوازن البيئيّ؟', '[{"id":"a","text":"لأنّ الكائنات مستقلّةٌ تمامًا"},{"id":"b","text":"لأنّ النباتات تأكل الحيوانات"},{"id":"c","text":"لأنّ الحيوانات لا تحتاج غذاءً"},{"id":"d","text":"لأنّ الكائنات مترابطة، واختفاء حلقةٍ يؤثّر في باقي الكائنات"}]'::jsonb, 'd', 'الكائنات الحيّة مترابطةٌ في سلاسل غذائيّة؛ اختفاء حلقةٍ يؤثّر في الباقي، لذلك نحافظ على التوازن البيئيّ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f667b401-9f26-576b-b09a-307129fc4c56', 'ed79968a-5c3a-580b-ae7a-2fbda3744016', 'النحلة تأخذ غذاءها من الأزهار عن طريق:', '[{"id":"a","text":"أكل التراب"},{"id":"b","text":"مصّ الرحيق"},{"id":"c","text":"اصطياد العصافير"},{"id":"d","text":"قرض الحجارة"}]'::jsonb, 'b', 'النحلة تمصّ رحيق الأزهار، فهذه طريقتها في أخذ الغذاء.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('7497e5a1-46ab-5ad9-b80b-8b60c4b6e5a1', 'ed79968a-5c3a-580b-ae7a-2fbda3744016', 'في الصورة سلسلةٌ غذائيّة. أيّ كائنٍ هو الحلقة الأولى؟ <svg viewBox="0 0 230 70" xmlns="http://www.w3.org/2000/svg"><path d="M22 55 q-9 -24 0 -36 q9 12 0 36 z" fill="#16a34a" stroke="#1f2937" stroke-width="2"/><text x="4" y="68" font-size="10" fill="#1f2937">عشب</text><line x1="38" y1="38" x2="76" y2="38" stroke="#1f2937" stroke-width="2"/><polygon points="76,38 66,33 66,43" fill="#1f2937"/><ellipse cx="98" cy="38" rx="16" ry="9" fill="#84cc16" stroke="#1f2937" stroke-width="2"/><text x="86" y="68" font-size="10" fill="#1f2937">جرادة</text><line x1="118" y1="38" x2="156" y2="38" stroke="#1f2937" stroke-width="2"/><polygon points="156,38 146,33 146,43" fill="#1f2937"/><ellipse cx="188" cy="38" rx="20" ry="12" fill="#a16207" stroke="#1f2937" stroke-width="2"/><circle cx="203" cy="30" r="5" fill="#a16207" stroke="#1f2937" stroke-width="1"/><text x="172" y="68" font-size="10" fill="#1f2937">عصفور</text></svg>', '[{"id":"a","text":"العشب (النبتة)"},{"id":"b","text":"الجرادة"},{"id":"c","text":"العصفور"},{"id":"d","text":"لا توجد حلقة أولى"}]'::jsonb, 'a', 'الحلقة الأولى في السلسلة هي النبتة (العشب)، إذ تبدأ منها السهام نحو الجرادة فالعصفور.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('3b3d6af4-7787-50d9-9972-fa49d9fd188b', '355404c0-718e-5471-abe9-6d83b0333716', 'eveil-scientifique-5eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: عبقريُّ التوازن البيئيّ', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('1fa82fee-2491-59db-a1b7-9a2546f89018', '3b3d6af4-7787-50d9-9972-fa49d9fd188b', 'رتّب الكائنات في سلسلةٍ غذائيّةٍ صحيحة: ثعلب، عشب، جرادة، عصفور.', '[{"id":"a","text":"عشب → جرادة → عصفور → ثعلب"},{"id":"b","text":"ثعلب → عصفور → جرادة → عشب"},{"id":"c","text":"جرادة → عشب → ثعلب → عصفور"},{"id":"d","text":"عصفور → ثعلب → عشب → جرادة"}]'::jsonb, 'a', 'تبدأ السلسلة بنبتة (عشب) ← تأكلها الجرادة ← يأكلها العصفور ← يأكله الثعلب. السهم نحو الآكل. هذا هو الترتيب الصحيح.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1d6fc97d-be3a-57f7-932c-4453e65634c1', '3b3d6af4-7787-50d9-9972-fa49d9fd188b', 'في سلسلة «عشب → أرنب → ثعلب»، اصطاد الصيّادون أغلب الثعالب. ما الأثر المتوقّع على الأرانب؟', '[{"id":"a","text":"لا يتأثّر شيء"},{"id":"b","text":"يزداد عدد الأرانب لأنّ عدوّها الثعلب قلّ"},{"id":"c","text":"ينقرض الأرنب فورًا"},{"id":"d","text":"يتحوّل الأرنب إلى ثعلب"}]'::jsonb, 'b', 'الثعلب يأكل الأرنب؛ فإذا قلّ الثعلب قلّ افتراس الأرانب فيزداد عددها. هذا يبيّن ترابط الحلقات في التوازن البيئيّ. الفخّ الشائع توهّم انقراض الأرنب رغم قلّة عدوّه.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('6d4c2428-ccb2-5d5e-bdea-21f6126b5651', '3b3d6af4-7787-50d9-9972-fa49d9fd188b', 'لماذا لا يمكن أن تبدأ سلسلةٌ غذائيّة بحيوانٍ لاحم؟', '[{"id":"a","text":"لأنّ اللاحم نبات"},{"id":"b","text":"لأنّ النبتة تأكل اللاحم"},{"id":"c","text":"لأنّ اللاحم يحتاج كائنًا حيًّا يأكله، والسلسلة تبدأ بنبتةٍ تصنع غذاءها بنفسها"},{"id":"d","text":"لأنّ اللاحم لا يأكل أبدًا"}]'::jsonb, 'c', 'السلسلة تبدأ بكائنٍ يصنع غذاءه بنفسه (النبتة)؛ أمّا اللاحم فيحتاج إلى من يأكله قبله، فلا يمكن أن يكون الحلقة الأولى. الفخّ الشائع تجاهل دور النبتة المنتجة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('0ccd17d4-9143-56b7-9531-031c27df79a2', '3b3d6af4-7787-50d9-9972-fa49d9fd188b', 'صيّادٌ قطع كلّ أشجار غابةٍ لبناء مصنع. ما الأثر على حيوانات الغابة؟', '[{"id":"a","text":"تزداد كلّ الحيوانات"},{"id":"b","text":"تتحوّل الحيوانات إلى نباتات"},{"id":"c","text":"لا أثر على أيّ كائن"},{"id":"d","text":"تفقد العواشب غذاءها فتهاجر أو تموت، فتتأثّر اللواحم التي تأكلها"}]'::jsonb, 'd', 'الأشجار حلقةٌ أولى تطعم العواشب؛ قطعها يحرم العواشب غذاءها فتهاجر أو تموت، فيقلّ غذاء اللواحم أيضًا. هذا يبيّن خطر الإخلال بالتوازن البيئيّ.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a6c9262f-1d9e-517b-b6ef-69a8dcc8c013', '3b3d6af4-7787-50d9-9972-fa49d9fd188b', 'أيّ عبارةٍ تصف العلاقة بين الضوء والنبتة والحيوان في الوسط البيئيّ بشكلٍ صحيح؟', '[{"id":"a","text":"النبتة تأكل الحيوانات بمساعدة الضوء"},{"id":"b","text":"النبتة تصنع غذاءها بمساعدة الضوء، ثمّ تأكلها العواشب، ثمّ تأكل اللواحم العواشب"},{"id":"c","text":"الحيوان يصنع الضوء للنبتة"},{"id":"d","text":"الضوء يأكل النبتة"}]'::jsonb, 'b', 'الضوء يساعد النبتة على صنع غذائها، ثمّ تأكل العواشب النبتة، ثمّ تأكل اللواحم العواشب؛ فهذه سلسلةٌ تربط الضوء بالنبتة بالحيوان. باقي الخيارات تعكس العلاقات.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('1c216753-a22d-5464-86d3-be90a15829ed', '3b3d6af4-7787-50d9-9972-fa49d9fd188b', 'في الصورة سلسلةٌ ناقصة: «عشب → ؟ → أسد». أيّ حيوانٍ يملأ الفراغ؟ <svg viewBox="0 0 230 70" xmlns="http://www.w3.org/2000/svg"><path d="M22 55 q-9 -24 0 -36 q9 12 0 36 z" fill="#16a34a" stroke="#1f2937" stroke-width="2"/><text x="4" y="68" font-size="10" fill="#1f2937">عشب</text><line x1="38" y1="38" x2="78" y2="38" stroke="#1f2937" stroke-width="2"/><polygon points="78,38 68,33 68,43" fill="#1f2937"/><rect x="90" y="26" width="30" height="24" rx="4" fill="#fde68a" stroke="#1f2937" stroke-width="2"/><text x="100" y="42" font-size="16" fill="#1f2937">؟</text><line x1="124" y1="38" x2="162" y2="38" stroke="#1f2937" stroke-width="2"/><polygon points="162,38 152,33 152,43" fill="#1f2937"/><ellipse cx="192" cy="38" rx="22" ry="13" fill="#d97706" stroke="#1f2937" stroke-width="2"/><circle cx="178" cy="30" r="7" fill="#d97706" stroke="#1f2937" stroke-width="1"/><text x="178" y="68" font-size="10" fill="#1f2937">أسد</text></svg>', '[{"id":"a","text":"غزال (عاشب يأكل العشب ويأكله الأسد)"},{"id":"b","text":"صقر (لاحم لا يأكل العشب)"},{"id":"c","text":"شجرة (نبات)"},{"id":"d","text":"حجر"}]'::jsonb, 'a', 'الفراغ يحتاج عاشبًا يأكل العشب ويأكله الأسد، وهو الغزال: «عشب → غزال → أسد». الصقر لاحم لا يأكل العشب، والشجرة نبات، والحجر غير حيّ.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('5ab353d5-3a69-5657-a1fe-9c843b74576f', '355404c0-718e-5471-abe9-6d83b0333716', 'eveil-scientifique-5eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملةٌ للكائنات الحيّة', 3, 120, 30, 'boss', 'admin', 5)
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
  ('c51bb842-40a5-5470-bc1c-c33eca4a05db', '5ab353d5-3a69-5657-a1fe-9c843b74576f', 'أصناف الحيوانات حسب غذائها هي:', '[{"id":"a","text":"عاشبة ولاحمة وكالشة (مختلطة)"},{"id":"b","text":"صلبة وسائلة وغازيّة"},{"id":"c","text":"طويلة وقصيرة ومسطّحة"},{"id":"d","text":"شفّافة وعاتمة"}]'::jsonb, 'a', 'تُصنّف الحيوانات حسب غذائها إلى عاشبة (نبات)، ولاحمة (حيوان)، وكالشة مختلطة (نبات وحيوان).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('aa15740c-bc7c-51b7-9f42-d6514d9103b8', '5ab353d5-3a69-5657-a1fe-9c843b74576f', 'أيّ سلسلةٍ غذائيّةٍ صحيحة؟', '[{"id":"a","text":"بومة → نبتة → فأر"},{"id":"b","text":"نبتة → فأر → بومة"},{"id":"c","text":"بومة → فأر → نبتة"},{"id":"d","text":"فأر → نبتة → بومة"}]'::jsonb, 'b', 'تبدأ بنبتة ← يأكلها الفأر (عاشب) ← تأكله البومة (لاحمة). السهم نحو الآكل. هذا هو الترتيب الصحيح.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c6f57a2b-2500-5135-8156-2fb61a2ee190', '5ab353d5-3a69-5657-a1fe-9c843b74576f', 'لماذا يُقال إنّ الكائنات الحيّة في الوسط البيئيّ يأخذ بعضها من بعض؟', '[{"id":"a","text":"لأنّها كلّها نباتات"},{"id":"b","text":"لأنّها كلّها لا تأكل"},{"id":"c","text":"لأنّ بعضها غذاءٌ للبعض الآخر في سلاسل غذائيّة مترابطة"},{"id":"d","text":"لأنّها لا علاقة بينها"}]'::jsonb, 'c', 'الكائنات الحيّة مترابطة: النبتة غذاءٌ للعاشب، والعاشب غذاءٌ للاحم؛ فيأخذ بعضها من بعض في سلاسل غذائيّة.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ce338b7f-bd3a-5d2d-b26d-8f18793a553a', '5ab353d5-3a69-5657-a1fe-9c843b74576f', 'تلميذٌ قال: «النبتة حيوانٌ لاحم لأنّها تنمو.» أين الخطأ؟', '[{"id":"a","text":"لا خطأ، فالنبتة لاحمة"},{"id":"b","text":"الخطأ أنّ النبتة عاشبة"},{"id":"c","text":"الخطأ أنّ النبتة لا تنمو"},{"id":"d","text":"الخطأ أنّ النبتة ليست حيوانًا؛ هي كائنٌ حيٌّ يصنع غذاءه بنفسه بمساعدة الضوء"}]'::jsonb, 'd', 'النبتة ليست حيوانًا؛ هي كائنٌ حيٌّ يصنع غذاءه بنفسه بمساعدة الضوء، ولا يصطاد. هذا هو الخطأ الشائع: تصنيف النبتة حيوانًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('de16a223-1307-548d-b23b-ad65b67ca2bf', '5ab353d5-3a69-5657-a1fe-9c843b74576f', 'ما العلاقة بين العناصر غير الحيّة (الماء والضوء) والكائنات الحيّة في الوسط البيئيّ؟', '[{"id":"a","text":"الكائنات تأكل الماء والضوء كغذاءٍ مباشر"},{"id":"b","text":"تحتاج الكائنات الحيّة الماء والضوء لتعيش وتنمو، فهما جزءٌ من وسطها"},{"id":"c","text":"لا تحتاج الكائنات الماء ولا الضوء"},{"id":"d","text":"الماء والضوء كائنان حيّان"}]'::jsonb, 'b', 'العناصر غير الحيّة (الماء، الضوء، الهواء) ضروريّةٌ للكائنات الحيّة لتعيش وتنمو؛ فالنبتة تحتاج الماء والضوء، والحيوان يحتاج الماء. فهي جزءٌ من الوسط البيئيّ. باقي الخيارات خاطئة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bdd02bf7-4bdc-5ee4-b256-899e4fe1efb6', '5ab353d5-3a69-5657-a1fe-9c843b74576f', 'رتّب بناء سلسلةٍ غذائيّةٍ صحيحة في حديقة:', '[{"id":"a","text":"ورق الشجر → دودة → طائر → قطّ"},{"id":"b","text":"قطّ → طائر → دودة → ورق الشجر"},{"id":"c","text":"دودة → ورق الشجر → قطّ → طائر"},{"id":"d","text":"طائر → قطّ → ورق الشجر → دودة"}]'::jsonb, 'a', 'تبدأ السلسلة بنبتة (ورق الشجر) ← تأكلها الدودة ← يأكلها الطائر ← يأكله القطّ. السهم نحو الآكل. هذا هو الترتيب الصحيح.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('de4b8d8e-94f8-5fef-8450-533a1796a423', '62629568-19b1-5474-8f7f-f4e48091f0d4', 'eveil-scientifique-5eme', 'اختبار فهم الدرس ⭐', 1, 20, 5, 'quiz', 'admin', 0)
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
  ('243ce463-0ee8-580b-a9d2-fa1f844324a4', 'de4b8d8e-94f8-5fef-8450-533a1796a423', 'بماذا تتكاثر معظم النباتات؟', '[{"id":"a","text":"بالبذور"},{"id":"b","text":"بالحجارة"},{"id":"c","text":"بالماء وحده"},{"id":"d","text":"بالهواء وحده"}]'::jsonb, 'a', 'تتكاثر معظم النباتات بالبذور، التي تنبت فتنمو نباتاتٍ جديدة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a239764e-80e3-59ec-b345-38bc9d96e8a7', 'de4b8d8e-94f8-5fef-8450-533a1796a423', 'أيّ هذا شرطٌ ضروريٌّ لإنبات البذرة؟', '[{"id":"a","text":"الظلام التامّ"},{"id":"b","text":"الماء"},{"id":"c","text":"الجفاف التامّ"},{"id":"d","text":"البرد الشديد"}]'::jsonb, 'b', 'تحتاج البذرة إلى الماء لتنبت، إضافةً إلى الهواء والحرارة المعتدلة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('3d2dd40f-762a-5f77-aa68-2f1647a78615', 'de4b8d8e-94f8-5fef-8450-533a1796a423', 'بأيّ جزءٍ تأخذ النبتة الماء والأملاح المعدنيّة من التربة؟', '[{"id":"a","text":"الأوراق"},{"id":"b","text":"الأزهار"},{"id":"c","text":"الجذور"},{"id":"d","text":"الثمار"}]'::jsonb, 'c', 'تأخذ النبتة الماء والأملاح المعدنيّة من التربة بواسطة الجذور.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('dcc380bb-2d9e-5add-b613-0980a194cada', 'de4b8d8e-94f8-5fef-8450-533a1796a423', 'أيّ عمليّةٍ تقتل الجراثيم لجعل الماء صالحًا للشّرب؟', '[{"id":"a","text":"الترسيب"},{"id":"b","text":"الترشيح"},{"id":"c","text":"التعقيم"},{"id":"d","text":"التجميد"}]'::jsonb, 'c', 'التعقيم يقتل الجراثيم في الماء فيصبح آمنًا للشّرب. أمّا الترسيب والترشيح فيزيلان الأوساخ والشوائب.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('db61f524-cc17-553e-a310-08f90fd6def7', 'de4b8d8e-94f8-5fef-8450-533a1796a423', 'في الصورة بذرةٌ نبتت في التربة. ما الجزء رقم 2 الذي يمتدّ في التربة ليأخذ الماء؟ <svg viewBox="0 0 140 150" xmlns="http://www.w3.org/2000/svg"><rect x="0" y="85" width="140" height="60" fill="#a16207" stroke="#1f2937" stroke-width="2"/><line x1="70" y1="85" x2="70" y2="40" stroke="#16a34a" stroke-width="4"/><path d="M70 55 q-20 -6 -26 -22 q18 2 26 14 z" fill="#22c55e" stroke="#1f2937" stroke-width="2"/><path d="M70 48 q20 -6 26 -22 q-18 2 -26 14 z" fill="#22c55e" stroke="#1f2937" stroke-width="2"/><text x="96" y="40" font-size="12" fill="#1f2937">1</text><g stroke="#92400e" stroke-width="3" fill="none"><path d="M70 85 q-10 18 -22 28"/><path d="M70 85 q4 22 0 40"/><path d="M70 85 q12 18 22 26"/></g><text x="96" y="120" font-size="12" fill="#1f2937">2</text></svg>', '[{"id":"a","text":"الجزء رقم 1 (الأوراق)"},{"id":"b","text":"الجزء رقم 2 (الجذور)"},{"id":"c","text":"لا يوجد جزءٌ في التربة"},{"id":"d","text":"الغلاف"}]'::jsonb, 'b', 'الجزء رقم 2 الممتدّ في التربة هو الجذور، وبها تأخذ النبتة الماء والأملاح المعدنيّة. أمّا رقم 1 فهو الأوراق فوق التربة.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('ec1b0927-7f26-58b4-8801-406bdbd98db2', '62629568-19b1-5474-8f7f-f4e48091f0d4', 'eveil-scientifique-5eme', '⭐ تمرين: من البذرة إلى النبتة', 1, 50, 10, 'practice', 'admin', 1)
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
  ('ed2da95c-8e39-57c7-a726-30260632cff4', 'ec1b0927-7f26-58b4-8801-406bdbd98db2', 'خروج النبتة الصغيرة من البذرة يُسمّى:', '[{"id":"a","text":"الإنبات"},{"id":"b","text":"الترسيب"},{"id":"c","text":"التعقيم"},{"id":"d","text":"الزفير"}]'::jsonb, 'a', 'الإنبات هو خروج النبتة الصغيرة من البذرة عندما تتوفّر الشروط الملائمة.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('43690b1d-0a1b-576a-81af-b5ac0b845f56', 'ec1b0927-7f26-58b4-8801-406bdbd98db2', 'الجزء الذي يحمي البذرة من الخارج هو:', '[{"id":"a","text":"الجنين"},{"id":"b","text":"الغلاف"},{"id":"c","text":"الجذر"},{"id":"d","text":"الزهرة"}]'::jsonb, 'b', 'الغلاف هو الطبقة الخارجيّة التي تحمي البذرة.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('08477d77-b9f5-5c3a-b556-37aa1fa14966', 'ec1b0927-7f26-58b4-8801-406bdbd98db2', 'أيّ هذه شرطٌ لإنبات البذرة؟', '[{"id":"a","text":"الظلام التامّ"},{"id":"b","text":"الجفاف"},{"id":"c","text":"الحرارة المعتدلة (الدفء)"},{"id":"d","text":"البرد الشديد"}]'::jsonb, 'c', 'تحتاج البذرة إلى حرارةٍ معتدلة (دفء) لتنبت، إضافةً إلى الماء والهواء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('395d007e-9359-5a00-b442-605ca27c4971', 'ec1b0927-7f26-58b4-8801-406bdbd98db2', 'تأخذ النبتة الأملاح المعدنيّة من:', '[{"id":"a","text":"الضوء فقط"},{"id":"b","text":"الأوراق فقط"},{"id":"c","text":"الهواء فقط"},{"id":"d","text":"التربة بواسطة الجذور"}]'::jsonb, 'd', 'تأخذ النبتة الماء والأملاح المعدنيّة من التربة بواسطة جذورها.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('07939c5e-ec5a-5f11-98f4-5eba7cce9c50', 'ec1b0927-7f26-58b4-8801-406bdbd98db2', 'العمليّة التي نترك فيها الماء يهدأ فتنزل الأوساخ إلى القاع هي:', '[{"id":"a","text":"التبخّر"},{"id":"b","text":"الترسيب"},{"id":"c","text":"التعقيم"},{"id":"d","text":"الإنبات"}]'::jsonb, 'b', 'في الترسيب نترك الماء يهدأ فتنزل الأوساخ الثقيلة إلى القاع.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b938cf9b-e79e-5a2a-bdc3-9d1ece377268', 'ec1b0927-7f26-58b4-8801-406bdbd98db2', 'ما الذي تخزّنه البذرة ليتغذّى منه الجنين عند الإنبات؟', '[{"id":"a","text":"المدّخر الغذائيّ"},{"id":"b","text":"الماء فقط"},{"id":"c","text":"الهواء فقط"},{"id":"d","text":"الحجارة"}]'::jsonb, 'a', 'تخزّن البذرة مدّخرًا غذائيًّا يتغذّى منه الجنين (الرشيم) عند بدء الإنبات.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('690289c1-c919-5221-ab17-5e784333c77b', '62629568-19b1-5474-8f7f-f4e48091f0d4', 'eveil-scientifique-5eme', '⚔️ زعيم الفصل ⭐⭐⭐: حارسُ الحياة', 3, 120, 30, 'boss', 'admin', 2)
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
  ('92d0da45-6226-50ba-a257-23a32ce66996', '690289c1-c919-5221-ab17-5e784333c77b', 'وضعنا بذورًا على قطنٍ جافٍّ في مكانٍ دافئ، فلم تنبت. ما السبب؟', '[{"id":"a","text":"نقص الماء؛ فالبذرة تحتاج الماء لتنبت"},{"id":"b","text":"وجود الهواء"},{"id":"c","text":"وجود الدفء"},{"id":"d","text":"البذور كثيرةٌ جدًّا"}]'::jsonb, 'a', 'توفّر الدفء والهواء لكن غاب الماء، فلم تنبت البذور؛ لأنّ الماء شرطٌ ضروريٌّ للإنبات. الخطأ الشائع نسبة الفشل إلى الهواء أو الدفء وهما مفيدان.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b05b91c1-5ab6-50e2-aa6c-120d857ed5f6', '690289c1-c919-5221-ab17-5e784333c77b', 'تلميذٌ قال: «الماء العكر يصبح صالحًا للشّرب بمجرّد تركه يهدأ.» أين الخطأ؟', '[{"id":"a","text":"لا خطأ، فالترسيب وحده يكفي"},{"id":"b","text":"الخطأ أنّ الترسيب يزيل الأوساخ الثقيلة فقط؛ لا بدّ من الترشيح ثمّ التعقيم لقتل الجراثيم"},{"id":"c","text":"الخطأ أنّ الماء العكر صالحٌ مباشرة"},{"id":"d","text":"الخطأ أنّ التعقيم يزيد الأوساخ"}]'::jsonb, 'b', 'الترسيب يُنزل الأوساخ الثقيلة، لكن تبقى شوائب وجراثيم؛ فلا بدّ من الترشيح (لاحتجاز الشوائب) ثمّ التعقيم (لقتل الجراثيم). هذا هو الخطأ الشائع: الاكتفاء بالترسيب.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('c700223c-ce99-5ea1-a817-5dc9adf357fc', '690289c1-c919-5221-ab17-5e784333c77b', 'زرعنا نبتتين متماثلتين، سقينا الأولى وحرمنا الثانية الماء. لماذا ذبلت الثانية؟', '[{"id":"a","text":"لأنّ التربة سامّة"},{"id":"b","text":"لأنّ الهواء أذاها"},{"id":"c","text":"لأنّ الماء ضروريٌّ لحياة النبتة ونموّها"},{"id":"d","text":"لأنّ الضوء يضرّ النبتة"}]'::jsonb, 'c', 'النبتة تحتاج الماء لتعيش وتنمو؛ فحرمانها منه يجعلها تذبل. التجربة تثبت دور الماء في نموّ النبتة. الفخّ الشائع اتّهام الضوء أو الهواء المفيدين.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('332e69ef-5164-5604-8f71-d0155a9c9a90', '690289c1-c919-5221-ab17-5e784333c77b', 'ما دور الترشيح في تنقية الماء؟', '[{"id":"a","text":"قتل كلّ الجراثيم"},{"id":"b","text":"تجميد الماء"},{"id":"c","text":"تسخين الماء حتّى الغليان دائمًا"},{"id":"d","text":"تمرير الماء عبر طبقاتٍ (رمل وحصى) لاحتجاز الشوائب"}]'::jsonb, 'd', 'الترشيح يمرّر الماء عبر طبقاتٍ من الرمل والحصى فتحتجز الشوائب العالقة. أمّا قتل الجراثيم فمهمّة التعقيم. الخطأ الشائع خلط دوري الترشيح والتعقيم.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('bfa91ea0-f898-52a1-94e2-f3bef9f88d10', '690289c1-c919-5221-ab17-5e784333c77b', 'أيّ زوجٍ صحيحٌ (مكوّن البذرة ← دوره)؟', '[{"id":"a","text":"الجذر ← جزءٌ داخل البذرة الجافّة"},{"id":"b","text":"الجنين (الرشيم) ← نبتةٌ صغيرة تنمو فيما بعد"},{"id":"c","text":"الغلاف ← يتغذّى منه الجنين"},{"id":"d","text":"المدّخر الغذائيّ ← يحمي البذرة من الخارج"}]'::jsonb, 'b', 'الجنين (الرشيم) نبتةٌ صغيرة نائمة تنمو عند الإنبات، وهذا الزوج صحيح. الغلاف يحمي، والمدّخر الغذائيّ يغذّي الجنين.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('11385cb0-1619-5da9-b3b1-30636520db04', '690289c1-c919-5221-ab17-5e784333c77b', 'لماذا تُضاف مادّةٌ معقّمة إلى ماء الشّرب في محطّات المعالجة؟', '[{"id":"a","text":"لقتل الجراثيم غير المرئيّة فيصبح الماء آمنًا للشّرب"},{"id":"b","text":"لتلوين الماء"},{"id":"c","text":"لزيادة الأوساخ"},{"id":"d","text":"لتجميد الماء"}]'::jsonb, 'a', 'تُضاف مادّةٌ معقّمة لقتل الجراثيم التي لا تُرى بالعين، فيصبح الماء آمنًا للشّرب. هذا هو دور التعقيم. باقي الخيارات تضرّ بالماء.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('740fe23f-6e63-5faf-80df-06a7b7614cda', '62629568-19b1-5474-8f7f-f4e48091f0d4', 'eveil-scientifique-5eme', '⭐⭐ تمرين مراجعة (نمط امتحان): النبتةُ والماء', 2, 75, 15, 'practice', 'admin', 3)
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
  ('a2520564-da50-52d2-9724-77e931c42e08', '740fe23f-6e63-5faf-80df-06a7b7614cda', 'مكوّنات البذرة هي:', '[{"id":"a","text":"الغلاف والجنين والمدّخر الغذائيّ"},{"id":"b","text":"القلب والرئتان"},{"id":"c","text":"الجذور والأوراق والأزهار فقط"},{"id":"d","text":"الرمل والحصى"}]'::jsonb, 'a', 'تتكوّن البذرة من الغلاف (يحمي) والجنين/الرشيم (نبتةٌ نائمة) والمدّخر الغذائيّ (غذاءٌ مخزون).', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b0e0fb36-1c51-5273-babf-9c4a8cb6243a', '740fe23f-6e63-5faf-80df-06a7b7614cda', 'أيّ زوجٍ صحيحٌ (عمليّة ← دورها في تنقية الماء)؟', '[{"id":"a","text":"التعقيم ← إنزال الأوساخ الثقيلة"},{"id":"b","text":"التعقيم ← قتل الجراثيم"},{"id":"c","text":"الترسيب ← قتل الجراثيم"},{"id":"d","text":"الترشيح ← تجميد الماء"}]'::jsonb, 'b', 'التعقيم يقتل الجراثيم، وهذا الزوج صحيح. الترسيب يُنزل الأوساخ، والترشيح يحتجز الشوائب.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e3b3ce55-5af0-5bb0-9b6e-480c7587ef49', '740fe23f-6e63-5faf-80df-06a7b7614cda', 'لماذا نضع النبتة قرب النافذة المضيئة؟', '[{"id":"a","text":"لأنّ النبتة تأكل الزجاج"},{"id":"b","text":"لأنّ النافذة تعطيها أملاحًا"},{"id":"c","text":"لأنّ النبتة تحتاج الضوء لتصنع غذاءها وتنمو"},{"id":"d","text":"لأنّ الضوء يقتل النبتة"}]'::jsonb, 'c', 'النبتة تحتاج الضوء لتصنع غذاءها وتنمو؛ لذلك نضعها قرب الضوء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('336babd0-79ef-5521-b14d-deec809be8fd', '740fe23f-6e63-5faf-80df-06a7b7614cda', 'ماذا تأخذ النبتة من التربة بجذورها؟', '[{"id":"a","text":"الضوء"},{"id":"b","text":"الصوت"},{"id":"c","text":"غاز الفحم فقط"},{"id":"d","text":"الماء والأملاح المعدنيّة"}]'::jsonb, 'd', 'تأخذ النبتة الماء والأملاح المعدنيّة الذائبة فيه من التربة بواسطة الجذور.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('ca582431-ef96-5abc-a8de-1470b337fb37', '740fe23f-6e63-5faf-80df-06a7b7614cda', 'ما الترتيب الصحيح لعمليّات جعل ماء النهر صالحًا للشّرب؟', '[{"id":"a","text":"التعقيم ← الترشيح ← الترسيب"},{"id":"b","text":"الترسيب ← الترشيح ← التعقيم"},{"id":"c","text":"التعقيم ← الترسيب ← الترشيح"},{"id":"d","text":"الترشيح ← التعقيم ← الترسيب"}]'::jsonb, 'b', 'نبدأ بالترسيب (تنزل الأوساخ الثقيلة)، ثمّ الترشيح (تُحتجز الشوائب)، ثمّ التعقيم (تُقتل الجراثيم). هذا هو الترتيب الصحيح.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9ef44578-3a1e-5595-a2ca-6a3fb40a8b0d', '740fe23f-6e63-5faf-80df-06a7b7614cda', 'في الصورة بذرةٌ مقطوعة. ما الجزء رقم 1 الذي ينمو ليصير نبتة؟ <svg viewBox="0 0 150 110" xmlns="http://www.w3.org/2000/svg"><ellipse cx="70" cy="55" rx="48" ry="38" fill="#fde68a" stroke="#1f2937" stroke-width="3"/><text x="122" y="30" font-size="11" fill="#1f2937">2</text><path d="M70 30 q-10 20 0 44 q10 -20 0 -44 z" fill="#22c55e" stroke="#1f2937" stroke-width="2"/><text x="74" y="58" font-size="11" fill="#1f2937">1</text><line x1="118" y1="33" x2="100" y2="45" stroke="#1f2937" stroke-width="1"/></svg>', '[{"id":"a","text":"الجزء رقم 1 (الجنين/الرشيم)"},{"id":"b","text":"الجزء رقم 2 (الغلاف)"},{"id":"c","text":"لا يوجد جزءٌ ينمو"},{"id":"d","text":"المدّخر الغذائيّ فقط"}]'::jsonb, 'a', 'الجزء رقم 1 (الأخضر في الوسط) هو الجنين/الرشيم الذي ينمو فيصير نبتة. أمّا رقم 2 فهو الغلاف الذي يحمي البذرة.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('9577f7e4-482d-5c4c-b634-5add8af5a573', '62629568-19b1-5474-8f7f-f4e48091f0d4', 'eveil-scientifique-5eme', '👑 تحدّي النخبة ⭐⭐⭐⭐: عبقريُّ النبتة والماء', 4, 300, 60, 'challenge', 'admin', 4)
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
  ('f130a20a-11ce-5269-a25c-6144688cd2f8', '9577f7e4-482d-5c4c-b634-5add8af5a573', 'أردنا أن نثبت أنّ البذرة تحتاج الماء لتنبت. كيف نصمّم التجربة؟', '[{"id":"a","text":"نضع بذورًا متماثلة في وعاءين دافئين بهما هواء، نسقي الأوّل ونترك الثاني جافًّا، ونقارن"},{"id":"b","text":"نضع البذور في الظلام والنور ونقارن الألوان"},{"id":"c","text":"نأكل البذور ونرى طعمها"},{"id":"d","text":"نزن البذور بميزان"}]'::jsonb, 'a', 'نثبت دور الماء بتجربةٍ نغيّر فيها الماء فقط (وعاء مسقيّ ووعاء جافّ) مع تساوي الدفء والهواء، فإذا نبت المسقيّ وحده ثبت أنّ الماء ضروريّ. هذا هو المنهج العلميّ الصحيح.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('e82f9930-44c6-58ee-82db-97b4dfe64b26', '9577f7e4-482d-5c4c-b634-5add8af5a573', 'نبتةٌ في تربةٍ فقيرةٍ بالأملاح المعدنيّة تنمو ضعيفةً وصفراء رغم سقيها. ما السبب الأرجح؟', '[{"id":"a","text":"وجود الهواء"},{"id":"b","text":"نقص الأملاح المعدنيّة التي تحتاجها النبتة للنموّ السليم"},{"id":"c","text":"كثرة الماء فقط"},{"id":"d","text":"وجود الضوء"}]'::jsonb, 'b', 'النبتة تحتاج الماء والأملاح المعدنيّة معًا؛ فإن نقصت الأملاح في التربة ضعف نموّها واصفرّت رغم السقي. الفخّ الشائع اتّهام الضوء أو الهواء المفيدين.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('febfa53a-c216-5aa8-9f7c-ce3c991942b7', '9577f7e4-482d-5c4c-b634-5add8af5a573', 'لماذا لا يكفي ترشيح ماء النهر لجعله صالحًا للشّرب تمامًا؟', '[{"id":"a","text":"لأنّ الترشيح يجمّد الماء"},{"id":"b","text":"لأنّ الماء المرشَّح سامّ دائمًا"},{"id":"c","text":"لأنّ الترشيح يزيل الشوائب العالقة لكن تبقى جراثيمٌ مجهريّة يقتلها التعقيم"},{"id":"d","text":"لأنّ الترشيح يضيف جراثيم"}]'::jsonb, 'c', 'الترشيح يحتجز الشوائب الكبيرة، لكن تبقى جراثيم مجهريّة لا يزيلها؛ لذلك نحتاج التعقيم لقتلها فيصبح الماء آمنًا. الفخّ الشائع ظنّ أنّ صفاء الماء يعني خلوّه من الجراثيم.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('44745b88-c6df-5daf-b56b-dba2b51f4157', '9577f7e4-482d-5c4c-b634-5add8af5a573', 'أيّ سلسلةٍ تصف رحلة البذرة حتّى تصير نبتةً كاملةً بشكلٍ صحيح؟', '[{"id":"a","text":"بذرة جافّة ← إنبات فوريّ دون ماء"},{"id":"b","text":"بذرة ← اصطياد ← نبتة لاحمة"},{"id":"c","text":"بذرة ← تعقيم ← ترشيح ← نبتة"},{"id":"d","text":"بذرة + ماء + هواء + دفء ← إنبات ← نبتةٌ صغيرة بجذرٍ وأوراق ← نموّ"}]'::jsonb, 'd', 'تنبت البذرة عند توفّر الماء والهواء والدفء ← تخرج نبتةٌ صغيرة بجذرٍ وأوراق ← تنمو آخذةً الماء والأملاح من التربة والضوء من الشمس. هذه هي الرحلة الصحيحة.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('b7881855-77c9-5869-8943-ce3bb6a7f0cd', '9577f7e4-482d-5c4c-b634-5add8af5a573', 'تلميذٌ شرب من بركةٍ راكدةٍ صافية الظاهر فمرض. ما التفسير العلميّ؟', '[{"id":"a","text":"الماء الصافي ينقص الأكسجين"},{"id":"b","text":"صفاء الماء لا يعني خلوّه من الجراثيم؛ كان يحتاج تعقيمًا قبل الشّرب"},{"id":"c","text":"الماء الصافي مضرٌّ دائمًا"},{"id":"d","text":"البركة كانت مالحة"}]'::jsonb, 'b', 'قد يبدو الماء صافيًا لكنّه يحوي جراثيم مجهريّة لا تُرى؛ فالشّرب منه دون تعقيمٍ يسبّب المرض. لذلك لا نشرب إلّا ماءً معالجًا وآمنًا. الفخّ الشائع الحكم على الماء بمظهره فقط.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('a3816302-f911-56bf-850e-1a43b59de26a', '9577f7e4-482d-5c4c-b634-5add8af5a573', 'في الصورة ثلاث مراحل لتنقية الماء (1 ; 2 ; 3). أيّ مرحلةٍ تُحتجز فيها الشوائب عبر طبقات الرمل؟ <svg viewBox="0 0 230 90" xmlns="http://www.w3.org/2000/svg"><rect x="12" y="20" width="40" height="55" fill="#bae6fd" stroke="#1f2937" stroke-width="2"/><circle cx="24" cy="66" r="3" fill="#78350f"/><circle cx="38" cy="68" r="3" fill="#78350f"/><text x="26" y="86" font-size="11" fill="#1f2937">1</text><rect x="95" y="20" width="40" height="55" fill="#e0f2fe" stroke="#1f2937" stroke-width="2"/><rect x="95" y="50" width="40" height="14" fill="#fcd34d" stroke="#1f2937" stroke-width="1"/><rect x="95" y="64" width="40" height="11" fill="#9ca3af" stroke="#1f2937" stroke-width="1"/><text x="108" y="86" font-size="11" fill="#1f2937">2</text><rect x="178" y="20" width="40" height="55" fill="#ccfbf1" stroke="#1f2937" stroke-width="2"/><text x="186" y="50" font-size="13" fill="#1f2937">✓</text><text x="192" y="86" font-size="11" fill="#1f2937">3</text></svg>', '[{"id":"a","text":"المرحلة 2 (الترشيح عبر الرمل والحصى)"},{"id":"b","text":"المرحلة 3 (التعقيم)"},{"id":"c","text":"لا توجد مرحلة ترشيح"},{"id":"d","text":"المرحلة 1 (الترسيب)"}]'::jsonb, 'a', 'المرحلة 2 تُظهر طبقتي الرمل (الأصفر) والحصى (الرماديّ) اللتين تحتجزان الشوائب، وهذا هو الترشيح. المرحلة 1 ترسيبٌ (تنزل الأوساخ)، والمرحلة 3 تعقيمٌ (ماءٌ آمن ✓).', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, xp_reward, reward_coins, mode, source, display_order) VALUES
  ('df2b296c-cc46-5eb3-a78f-34956c620d29', '62629568-19b1-5474-8f7f-f4e48091f0d4', 'eveil-scientifique-5eme', '📝 تدريب ⭐⭐⭐: مراجعةٌ شاملةٌ للنبتة والماء', 3, 120, 30, 'boss', 'admin', 5)
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
  ('bf18cda7-5bf3-5c4b-aa43-5e824c18647c', 'df2b296c-cc46-5eb3-a78f-34956c620d29', 'شروط إنبات البذرة هي:', '[{"id":"a","text":"الماء والهواء والحرارة المعتدلة"},{"id":"b","text":"الجفاف والبرد والظلام"},{"id":"c","text":"الملح والزيت"},{"id":"d","text":"الصوت والضوء الشديد فقط"}]'::jsonb, 'a', 'تنبت البذرة عند توفّر الماء والهواء والحرارة المعتدلة (الدفء) معًا.', 1)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('9aae2c90-e5fa-5583-b97e-49e124432a81', 'df2b296c-cc46-5eb3-a78f-34956c620d29', 'أيّ جملةٍ صحيحةٌ عن دور التربة للنبتة؟', '[{"id":"a","text":"تهضم النبتة"},{"id":"b","text":"تثبّت جذور النبتة وتمدّها بالماء والأملاح المعدنيّة"},{"id":"c","text":"تمنع النبتة من النموّ"},{"id":"d","text":"تعطي النبتة الضوء"}]'::jsonb, 'b', 'التربة تثبّت جذور النبتة وتمدّها بالماء والأملاح المعدنيّة اللازمة لنموّها.', 2)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('daade666-9453-55d5-9025-bd7b280ebf62', 'df2b296c-cc46-5eb3-a78f-34956c620d29', 'لماذا تُجرى عمليّات الترسيب والترشيح والتعقيم على ماء الشّرب بالترتيب؟', '[{"id":"a","text":"لتجميد الماء تدريجيًّا"},{"id":"b","text":"لزيادة الجراثيم في كلّ مرحلة"},{"id":"c","text":"لإزالة الأوساخ الثقيلة ثمّ الشوائب العالقة ثمّ قتل الجراثيم، فيصبح آمنًا"},{"id":"d","text":"لتلوين الماء بثلاثة ألوان"}]'::jsonb, 'c', 'كلّ مرحلةٍ تكمّل ما قبلها: الترسيب يُنزل الأوساخ الثقيلة، والترشيح يحتجز الشوائب العالقة، والتعقيم يقتل الجراثيم؛ فيصبح الماء آمنًا للشّرب. باقي الخيارات تضرّ بالماء.', 3)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f8e0ed42-f90b-5a84-93f2-2326037b8d93', 'df2b296c-cc46-5eb3-a78f-34956c620d29', 'نبتةٌ مُنحت ماءً وأملاحًا وضوءًا وهواءً، فنمت قويّة. ما الذي نستنتجه؟', '[{"id":"a","text":"أنّ النبتة لا تحتاج شيئًا"},{"id":"b","text":"أنّ الماء وحده يكفي"},{"id":"c","text":"أنّ الضوء يضرّ النبتة"},{"id":"d","text":"أنّ النبتة تحتاج هذه العناصر معًا لتنمو نموًّا سليمًا"}]'::jsonb, 'd', 'نموّ النبتة القويّ عند توفّر الماء والأملاح والضوء والهواء يدلّ على أنّها تحتاج هذه العناصر مجتمعةً لتنمو نموًّا سليمًا.', 4)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('f6cb3b4d-9914-5fec-b4df-427bf11fbf1d', 'df2b296c-cc46-5eb3-a78f-34956c620d29', 'تلميذٌ قال: «كلّ ماءٍ صافٍ صالحٌ للشّرب مباشرة.» أين الخطأ؟', '[{"id":"a","text":"الخطأ أنّ الماء الصافي بلا أكسجين"},{"id":"b","text":"الخطأ أنّ الماء قد يبدو صافيًا ويحوي جراثيم مجهريّة؛ يحتاج تعقيمًا قبل الشّرب"},{"id":"c","text":"لا خطأ، فكلّ ماءٍ صافٍ آمن"},{"id":"d","text":"الخطأ أنّ الماء الصافي مالحٌ دائمًا"}]'::jsonb, 'b', 'الصفاء لا يعني الأمان؛ فقد يحوي الماء الصافي جراثيم لا تُرى تسبّب المرض، فيحتاج تعقيمًا. هذا هو الخطأ الشائع: الحكم على الماء بمظهره فقط.', 5)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order) VALUES
  ('61a1d0ce-9b72-59c0-9f15-4fd1997453d6', 'df2b296c-cc46-5eb3-a78f-34956c620d29', 'رتّب مراحل تحوّل ماء النهر العكر إلى ماءٍ صالحٍ للشّرب:', '[{"id":"a","text":"ترسيب (تنزل الأوساخ) ← ترشيح (تُحتجز الشوائب) ← تعقيم (تُقتل الجراثيم)"},{"id":"b","text":"تعقيم ← ترسيب ← ترشيح"},{"id":"c","text":"ترشيح ← ترسيب ← تجميد"},{"id":"d","text":"تعقيم ← تجميد ← ترسيب"}]'::jsonb, 'a', 'الترتيب الصحيح: الترسيب (تنزل الأوساخ الثقيلة) ← الترشيح (تُحتجز الشوائب العالقة) ← التعقيم (تُقتل الجراثيم)، فيصبح الماء صالحًا للشّرب.', 6)
ON CONFLICT (id) DO UPDATE SET
  exercise_id = EXCLUDED.exercise_id,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  correct_option = EXCLUDED.correct_option,
  explanation = EXCLUDED.explanation,
  display_order = EXCLUDED.display_order;

